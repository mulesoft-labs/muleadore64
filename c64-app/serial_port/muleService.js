'use strict'
var request = require('request-promise')

module.exports = {
  getMessage
};

function getMessage() {
  return request({
    url: 'http://pi-mule-app.cloudhub.io/api/message',
    json: true
  });
}
