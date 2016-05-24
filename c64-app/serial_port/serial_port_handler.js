#!/usr/bin/env node
'use strict';
var Promise = require('bluebird');
var muleService = require('./muleService.js');
var SerialPort = require("serialport").SerialPort;
var request = require('request-promise');
var moment = require('moment');

var mode = 0; // 0 = stdin/out, 1 = serial

if (mode == 1) {
  var port = new SerialPort("/dev/ttyUSB0", {
    baudrate: 300
  });
  port.on('open', function () {
    console.error('port opened');
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
        timeout();
      });
  }, 2000)
}

function heartbeat() {
  setTimeout(function () {
    write('6');
    heartbeat();
  }, 2000)
}

function weather() {
  setTimeout(function () {
    request.get({
      url: 'http://muleadore64.cloudhub.io/api/weather'
    });
    weather();
  }, 20000)
}

function nextSession() {
  setTimeout(function () {
    var t = moment("2016-05-24 08:30").fromNow();
    write('8\'Change the Clock Speed of Business with Application Networks\' ' + t);
    nextSession();
  }, 60000);
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
    var o = _p_toascii(input[i]);
    //console.error(input[i] + ' => ' + o);
    output += o;
  }
  output = output.replace(/@@@/g, "\x0d");
  return output;
}

// from petcat.c
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


if (mode == 0) {
  process.stdin.on('readable', function() {
    //this is required
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
