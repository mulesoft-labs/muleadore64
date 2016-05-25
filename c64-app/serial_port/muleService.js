'use strict'
var request = require('request-promise')

module.exports = {
  getMessage,
  postMessage
};

function getMessage() {
  return request({
    url: 'http://pi-mule-app.cloudhub.io/api/message',
    json: true
  });
}

function postMessage(data) {
  var cmd;
  var payload;
  if (data.startsWith('L-')) {
    cmd = 'light';
    payload = data.substr(2).toLower();
  }
  else if (data.startsWith('T-')) {
    cmd = 'twitter';
    payload = data.substr(2);
  }
  else {
    return Promise.reject('invalid command');
  }
  console.error(cmd, payload);
  return request({
    url: 'http://pi-mule-app.cloudhub.io/api/message',
    json: true,
    method: 'POST',
    body: {
      data: payload,
      command: cmd
    }
  });
}
