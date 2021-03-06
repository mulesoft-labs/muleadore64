'use strict'
var request = require('request-promise');
var Promise = require('bluebird');
var controlAppService = require('./controlAppService.js');
const logger = require('./logger');

module.exports = {
  getMessage,
  postMessage
};

var urlBase = 'http://pi-mule-app.cloudhub.io';
//urlBase = 'http://localhost:8080';

function getMessage() {
  return request({
    uri: urlBase + '/api/photo-message',
    json: true,
  });
}

function postMessage(data) {
  var cmd;
  var payload;
  if (data.startsWith('2')) {
    controlAppService.markRouteAsActive('piToLights')
    .catch(function(e) {
      console.error('e', e);
    });
    cmd = 'light';
    payload = data.substr(1).toLowerCase();
  }
  else if (data.startsWith('1')) {
    controlAppService.markRouteAsActive('piToTwitter')
    .catch(function(e) {
      console.error('e', e);
    });
    cmd = 'twitter';
    payload = data.substr(1).toLowerCase();

    return request({
      url: 'http://muleadore64.cloudhub.io/api/tweet',
      method: 'POST',
      form: {
        tweet: payload
      }
    });
  }
  else {
    return Promise.reject('invalid command');
  }
  console.error(cmd, payload);
  return request({
    url: urlBase + '/api/message',
    json: true,
    method: 'POST',
    body: {
      data: payload,
      command: cmd
    }
  });
}

function _p_toascii(c) {
    var ascii = c.charCodeAt(0);
    if (ascii >= 65 && ascii <= 90) {
      return String.fromCharCode(ascii + 32);
    }
    if (ascii >= 97 && ascii <= 122) {
      return String.fromCharCode(ascii - 32);
    }
    return c;
}
