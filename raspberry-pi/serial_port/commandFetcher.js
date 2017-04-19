/*
 * Fetches a command message from input queue
 */

var muleService = require('./muleService.js');
var controlAppService = require('./controlAppService.js');
const logger = require('./logger');

var list = [
  {
    type: 'tweet',
    text: '@muleadore64 good info and this is a long tweet which will expand over many many lines etc etc https://t.co/lkr7dmd3Kd\n   - @muleadore64, at Mon 4/17 2:49 PM'
  },
{
    type: 'background-image',
    url: '/Users/jeff/steve.jpeg'
  }

]

var listIndex = 0;

module.exports = {
  fetchNextMessageFromQueue
};


function fetchNextMessageFromQueue() {

  //var msg = list[listIndex];
  //listIndex = (listIndex + 1) % list.length;
  //return Promise.resolve(msg);

  fetchingMessage = true;
  return muleService.getMessage()
    .then(function (msg) {
      
      if (msg) {
        //console.error('here...');
        controlAppService.markRouteAsActive('amqToPi')
        .catch(function(e) {
          //logger.log('e3', e);
        });
        logger.log('here2...');
        controlAppService.markRouteAsActive('piToC64')
        .catch(function(e) {
          //logger.log('e4', e);
        });
      }
      return msg;
    })
    .catch(function(e) {
      logger.log('error fetching message:', e.statusCode);
      return null;
    });
}
