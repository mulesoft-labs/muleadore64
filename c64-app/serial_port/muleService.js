'use strict'
var request = require('request-promise');
var Promise = require('bluebird');

module.exports = {
  getMessage,
  postMessage
};

var urlBase = 'http://pi-mule-app.cloudhub.io';

function getMessage() {
  return request({
    url: urlBase + '/api/message',
    json: true
  });
}

function postMessage(data) {
  var cmd;
  var payload;
  if (data.startsWith('L-')) {
    cmd = 'light';
    payload = data.substr(2).toLowerCase();
  }
  else if (data.startsWith('T-')) {
    cmd = 'twitter';
    payload = data.substr(2).toLowerCase();

    return request({
      url: 'http://muleadore64.cloudhub.io/api/tweet',
      method: 'POST',
      form: {
        tweet: payload
      }
    });
    // console.error(payload)
    // // yuck.. nasty demo day hack
    // var output = '';
    // for (var i = 0; i < payload.length; i++) {
    //   output += _p_toascii(payload[i]);
    // }
    // payload = output;
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
