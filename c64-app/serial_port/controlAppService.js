'use strict'
var request = require('request-promise');
var Promise = require('bluebird');

module.exports = {
  markRouteAsActive
};

var urlBase = 'http://muleadore64.cloudhub.io';

function markRouteAsActive(routeName) {
  var data = {};
  data[routeName] = {
    lastActive: Date.now()
  };
  return request({
    url: urlBase + '/api/state',
    method: 'PATCH',
    body: data,
    json: true
  });
}