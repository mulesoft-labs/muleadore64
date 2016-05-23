#!/usr/bin/env node
'use strict';
var Promise = require('bluebird');
var muleService = require('./muleService.js');
var SerialPort = require("serialport").SerialPort;
var request = require('request-promise');

//console.log(convertToPetscii('Clouds'));
//return;

var mode = 1; // 0 = stdin/out, 1 = serial

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
write(' ');  // seems to be needed to 'wake up' the connection


function timeout () {
  setTimeout(function () {
    muleService.getMessage()
      .then(function (msg) {
        if (msg) {
          write(msg.c64command);
        }
      });
    timeout();
  }, 1000)
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

// wait 10 seconds before firing stuff
setTimeout(function () {
    heartbeat();
    timeout();
    weather();
  }, 20000);



function write(str) {
  var str = str[0] + convertToPetscii(str.substring(1));
  str += '~';  // add end marker
  process.stderr.write("writing " + str + ":\n");
  if (mode == 1) {
      port.write(str, function(e, bytesWritten) {
        if (e) {
          console.error(e);
        }
      });
  }
  else {
    process.stdout.write(str);
  }
  
  return;
}

function convertToPetscii(input) {
  var output = '';
  for (var i = 0; i < input.length; i++) {
    var o = _p_toascii(input[i]);
    //console.error(input[i] + ' => ' + o);
    output += o;
  }
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
