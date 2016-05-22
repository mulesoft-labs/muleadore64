'use strict'
var request = require('request-promise')

return {
  get: get
};

function get() {
  return request({
    url: 'http://pi-mule-app.cloudhub.io/api/message'
  })
    .then(function (res) {
      return res;
    });
}