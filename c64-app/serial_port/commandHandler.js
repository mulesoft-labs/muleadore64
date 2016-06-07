var muleService = require('./muleService.js');

var events = require('events');

var _inputBuffer = '';
var lastFetched = 0;
var fetchingMessage = false;
var eventEmitter = new events.EventEmitter();

module.exports = {
  handle,
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
      fetchNextMessage();
    }
  }
  else {
    muleService.postMessage(cmd)
    .catch(function(e) {
      console.error(e);
    });
  }
}

function fetchNextMessage() {
  fetchingMessage = true;
  muleService.getMessage()
    .then(function (msg) {
      if (msg && msg.c64command) {
        eventEmitter.emit('data', msg.c64command);
      }
    })
    .catch(function(e) {
      console.error(e);
    })
    .finally(function () {
      lastFetched = Date.now();
      fetchingMessage = false;
    });
}
