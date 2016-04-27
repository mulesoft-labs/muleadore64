'use strict'
var request = require('request-promise')
// var Promise = require('bluebird')

var authToken

// Here is how to get an auth token with the Anypoing MQ client app keys
// curl -v -X POST -H 'Content-type: application/json' 'https://anypoint.mulesoft.com/accounts/oauth2/token' -d '{
//    'client_id' : '2cc7b2ae1e6f47be9ed9638f489d2a13',
//    'client_secret': '80bed3adfe3b449eA866EC803C9C9A37',
//    'grant_type' : 'client_credentials'
// }'

function getAuthToken () {
  var opts = {
    method: 'POST',
    uri: 'https://anypoint.mulesoft.com/accounts/oauth2/token',
    headers: {
      'Content-type': 'application/json'
    },
    body: {
      'client_id': '2cc7b2ae1e6f47be9ed9638f489d2a13',
      'client_secret': '80bed3adfe3b449eA866EC803C9C9A37',
      'grant_type': 'client_credentials'
    },
    json: true // Automatically parses the JSON string in the response
  }

  return request(opts)
    .then(function (res) {
      console.error('Got new access token:', res.access_token)
      authToken = res.access_token
    })
    .catch(function (err) {
      console.error('Problem getting auth token', err)
    })
}

function getMessage () {
  var opts = {
    uri: 'https://mq-us-east-1.anypoint.mulesoft.com/api/v1/organizations/54d7e390-ed17-4f23-9343-fb6c0a135951/environments/d8d1e203-272a-4a9e-bb33-03f5bc005672/destinations/c64-interactive-queue/messages',
    headers: {
      'Authorization': 'bearer' + authToken,
      'Content-type': 'application/json'
    },
    qs: {
      batchSize: 1,
      poolingTime: 0,
      ackMode: 'none'
    },
    json: true
  }

  return request(opts)
    .then(function (msg) {
      if (msg) {

        opts.method= 'DELETE';
        opts.qs = {};
        opts.body = [
          {
            messageId: msg[0].headers.messageId,
            lockId: msg[0].headers.lockId
          }];
        return request(opts)
          .then((r) => {
            return JSON.parse(msg[0].body);
          })
           .catch((e) =>  
             {
               console.error('ERROR:', e.message);  });
      }
      return
    })
    .catch(function (err) {
      console.error('Problem getting a message:', err.message)
      if (err.statusCode === 401) {
        getAuthToken()
      }
    })
}

module.exports = {
  getMessage: getMessage
}
