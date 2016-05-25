#!/usr/bin/env node
'use strict';
var Promise = require('bluebird');
var muleService = require('./muleService.js');
var SerialPort = require("serialport").SerialPort;
var request = require('request-promise');
var moment = require('moment');

var mode = 0; // 0 = stdin/out, 1 = serial
var inputBuffer = '';

if (mode == 1) {
  var port = new SerialPort("/dev/ttyUSB0", {
    baudrate: 300
  });
  port.on('open', function () {
    console.error('port opened');
  });
  port.on('data', function(data) {
    if (data && data.length > 0) {
      console.error('RECV:', data);
      inputBuffer += chunk.toString('ascii');
      onInputBufferUpdated();
    }
  });
}
else {
  process.stdin.setEncoding('ascii');
}

var delay = 100;
//write(' ');  // seems to be needed to 'wake up' the connection


function timeout () {
  setTimeout(function () {
    muleService.getMessage()
      .then(function (msg) {
        if (msg && msg.c64command) {
          write(msg.c64command);
        }
      })
      .catch(function(e) {
        console.error(e);
      })
      .finally(function () {
        timeout();
      });
  }, 2000)
}

function heartbeat() {
  setTimeout(function () {
    write('6');
    heartbeat();
  }, 4000)
}

function weather() {
  setTimeout(function () {
    request.get({
      url: 'http://muleadore64.cloudhub.io/api/weather'
    });
    weather();
  }, 55000)
}

function nextSession() {
  setTimeout(function () {
    var sessions = [
      { 
        at: Date.parse('2016-05-25 09:40 GMT-0700'),
        title: 'Staying Relevant in a Cloud-First World'
      },
      { 
        at: Date.parse('2016-05-25 10:30 GMT-0700'),
        title: 'Visionary API Panel Discussion'
      },
      { 
        at: Date.parse('2016-05-25 11:15 GMT-0700'),
        title: 'Cloud Strategy to Drive Business and IT Agility'
      },
      { 
        at: Date.parse('2016-05-25 11:35 GMT-0700'),
        title: 'Digitization: Disrupt or be Disrupted'
      },
      { 
        at: Date.parse('2016-05-25 12:01 GMT-0700'),
        title: 'UX Session: RAML + HTTP Connector'
      },
      { 
        at: Date.parse('2016-05-25 12:40 GMT-0700'),
        title: 'Rainfall: Real Time Information Delivery Platform'
      },
      { 
        at: Date.parse('2016-05-25 13:10 GMT-0700'),
        title: 'Connecting a Commodore64 to the Application Network in 2 days'
      },
      { 
        at: Date.parse('2016-05-25 13:30 GMT-0700'),
        title: 'ADP: Upgrading people, process, technology with Anypoint Platform to deliver value faster'
      }
    ];
    for (var i = 0; i < sessions.length; i++) {
      //console.log(Date.now(), sessions[i].at);
      if (Date.now() < sessions[i].at) {
        var t = moment(sessions[i].at).fromNow();
        write('8\'' + sessions[i].title + '\' ' + t);
        break;
      }
    }
    
    nextSession();
  }, 65000);
}

// wait 10 seconds before firing stuff
setTimeout(function () {
    heartbeat();
    timeout();
    weather();
    nextSession();
  }, 10000);



function write(str) {
  var str = str[0] + convertToPetscii(str.substring(1));
  str += '~';  // add end marker
  process.stderr.write("writing :" + str + ":\n");
  if (mode === 1) {
      port.write(str, function(e, bytesWritten) {
        if (e) {
          console.error('error', e);
        }
      });
  }
  else {
    process.stdout.write(str);
  }
}

function convertToPetscii(input) {
  input = input.replace(/\n/g, "@@@");
  var output = '';
  for (var i = 0; i < input.length; i++) {
    var o = _p_to_petscii(input[i]);
    //console.error(input[i] + ' => ' + o);
    output += o;
  }
  output = output.replace(/@@@/g, "\x0d");
  return output;
}

// from petcat.c
function _p_to_petscii(c) {
    var ascii = c.charCodeAt(0);
    if (ascii >= 65 && ascii <= 90) {
      return String.fromCharCode(ascii + 32);
    }
    if (ascii >= 97 && ascii <= 122) {
      return String.fromCharCode(ascii - 32);
    }
    return c;
}

function _p_toascii(c) {
    var ascii = c.charCodeAt(0);
    if (ascii >= 65 && ascii <= 90) {
      return String.fromCharCode(ascii - 32);
    }
    if (ascii >= 97 && ascii <= 122) {
      return String.fromCharCode(ascii + 32);
    }
    return c;
}

function onInputBufferUpdated() {
  if (inputBuffer.endsWith('~')) {
    muleService.postMessage(inputBuffer.substr(0, inputBuffer.length - 1))
      .catch(function(e) {
        console.error(e);
      })
      .finally(function() {
        inputBuffer = '';
      });
  }
}


if (mode === 0) {
  process.stdin.on('readable', function() {
    var chunk = process.stdin.read();
    if (chunk && chunk.length > 0) {
      inputBuffer += chunk;
      onInputBufferUpdated();
    }
  });

  process.stdin.on('end', function () {
    process.exit(0);
  });
  process.stdin.on('close', function () {
    process.exit(0);
  });
  process.stdout.on('error', function () {
    process.stderr.write('error');
  });
}
