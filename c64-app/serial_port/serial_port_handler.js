#!/usr/bin/env node
'use strict';
var Promise = require('bluebird');
var commandHandler = require('./commandHandler.js');
var SerialPort = require("serialport");
var request = require('request-promise');

var mode = 0; // 0 = stdin/out, 1 = serial
const RESET_TIMER_MAX = 3 * 60;
var resetTimer = 0;

commandHandler.eventEmitter.on('dataFromMQ', (data) => {
  write(data);
});

commandHandler.eventEmitter.on('gotCommandFromC64', (data) => {
  resetTimer = 0;
});

setInterval(() => {
  resetTimer += 5;
  if (resetTimer >= RESET_TIMER_MAX) {
    // this is nasty, but required to reset to defaults after X minutes
    const RESET_BORDER_CMD = '20';
    const RESET_MAIN_SCREEN_CMD = 'd';
    write(RESET_BORDER_CMD);    // reset border color
    write(RESET_MAIN_SCREEN_CMD);
    commandHandler.resetEnvironment();
    resetTimer = 0;
  }
}, 5000);


function write(str) {
  if (str[0] === '9') {
    str = nastyHackForSigninCommand();
  }
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

// hack for c64 upper-case screen handling and padding
function nastyHackForSigninCommand() {
  var maxLength = 20;
  var data = str.substr(1);
  if (data.length > maxLength) {
    data = data.substr(0, maxLength);
  }
  else {
    var padLength = (maxLength - data.length) / 2;
    data = ' '.repeat(padLength) + data + ' '.repeat(padLength);
  }
  data = data.toLowerCase();
  return str[0] + data;
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
    process.stderr.write('stdout error');
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
