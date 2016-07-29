/*
 * Handles command stream from the C64 -> Raspberry Pi
 */

var muleService = require('./muleService.js');
var controlAppService = require('./controlAppService.js');

var events = require('events');

var _inputBuffer = '';
var lastFetched = 0;
var fetchingMessage = false;
var eventEmitter = new events.EventEmitter();

module.exports = {
  handle,
  resetEnvironment,
  eventEmitter
};


function handle(chunk) {
  _inputBuffer += chunk;
  if (!_inputBuffer.endsWith('~'))
    return;

  var cmd = _inputBuffer.substr(0, _inputBuffer.length - 1);
  console.error('recv', cmd);
  _inputBuffer = '';

  // heartbeat from c64
  if (cmd === 'hb') {
    if (!fetchingMessage && Date.now() - lastFetched > 1000) {
      fetchNextMessageFromQueue();
    }
  }
  else {
    controlAppService.markRouteAsActive('piToC64')
    .catch(function(e) {
      console.error('e1', e);
    });
    eventEmitter.emit('gotCommandFromC64');
    muleService.postMessage(cmd)
    .catch(function(e) {
      console.error('e2', e);
    });
  }
}

function fetchNextMessageFromQueue() {
  fetchingMessage = true;
  muleService.getMessage()
    .then(function (msg) {
      console.error('m', msg);
      if (msg && msg.c64command) {
        console.error('here...');
        controlAppService.markRouteAsActive('amqToPi')
        .catch(function(e) {
          console.error('e3', e);
        });
                console.error('here2...');
        controlAppService.markRouteAsActive('piToC64')
        .catch(function(e) {
          console.error('e4', e);
        });  
                console.error('here3...');
        eventEmitter.emit('dataFromMQ', msg.c64command);
      }
    })
    .catch(function(e) {
      console.error('e5', e);
    })
    .finally(function () {
      lastFetched = Date.now();
      fetchingMessage = false;
    });
}

function resetEnvironment() {
  return muleService.postMessage('2off');
}


