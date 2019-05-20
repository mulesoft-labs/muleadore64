/*
 * Fetches a command message from input queue
 */

var muleService = require('./muleService.js');
var controlAppService = require('./controlAppService.js');
const logger = require('./logger');

var list = [
  
  // {
  //   type: 'background-image',
  //   url: '/Users/jeff/Downloads/IMG_0804.jpg'
  // },
  // {
  //   type: 'tweet',
  //   text: 'hello world'
  // }

]

var listIndex = 0;

module.exports = {
  fetchNextMessageFromQueue
};


function fetchNextMessageFromQueue() {

  if (list.length > 0) {
    if (listIndex >= list.length) {
      return Promise.resolve(null);
    }
    var msg = list[listIndex];
    listIndex++;
    //listIndex = (listIndex + 1) % list.length;
    return Promise.resolve(msg);
  }

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
