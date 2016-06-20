#!/usr/bin/env node
'use strict';
var Promise = require('bluebird');
var commandHandler = require('./commandHandler.js');
var SerialPort = require("serialport").SerialPort;
var request = require('request-promise');
var moment = require('moment');

var mode = 0; // 0 = stdin/out, 1 = serial

commandHandler.eventEmitter.on('data', (data) => {
  write(data);
});


function weather() {
  setTimeout(function () {
    request.get({
      url: 'http://muleadore64.cloudhub.io/api/weather'
    });
    weather();
  }, 55000)
}


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

// from petcat.c
function convertToPetscii(input) {
  input = input.replace(/\n/g, "@@@");
  var output = '';
  for (var i = 0; i < input.length; i++) {
    var ascii = input.charCodeAt(i);
    if (ascii >= 65 && ascii <= 90) {
      output += String.fromCharCode(ascii + 32);
    }
    else if (ascii >= 97 && ascii <= 122) {
      output += String.fromCharCode(ascii - 32);
    }
    else {
      output += input[i];
    }
  }
  output = output.replace(/@@@/g, "\x0d");
  return output;
}


if (mode === 0) {
  //process.stdin.setEncoding('ascii');

  // seems to be needed to 'wake up' the connection
  process.stdout.write('\x00');

  process.stdin.on('readable', function() {
    var chunk = process.stdin.read();
    commandHandler.handle(chunk);
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
else {
  var port = new SerialPort("/dev/ttyUSB0", {
    baudrate: 300
  });
  port.on('open', function () {
    console.error('port opened');
  });
  port.on('data', function(data) {
    if (data && data.length > 0) {
      commandHandler.handle(data.toString());
    }
  });
}

// setTimeout(() => {
//   write('8Danielle, Gaston, John, Kristy, Nicholas, Radhika, Wayne');
// }, 2000);

// setTimeout(() => {
//   write('9Jeff');
// }, 2000);
