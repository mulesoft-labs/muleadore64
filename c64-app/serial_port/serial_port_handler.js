#!/usr/bin/env node
'use strict';
var child_process = require('child_process');
var Promise = require('bluebird');
var amqService = require('./amqService.js');
var muleService = require('./muleService.js');
var SerialPort = require("serialport").SerialPort;
var request = require('request-promise');

var mode = 1; // 0 = stdin/out, 1 = serial

if (mode == 1) {
  var port = new SerialPort("/dev/ttyUSB0", {
    baudrate: 300
  });
}
else {
  process.stdin.setEncoding('ascii');
}

var delay = 100;
write(' ');  // seems to be needed to 'wake up' the connection


function timeout () {
  setTimeout(function () {
    amqService.getMessage()
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
  //process.stderr.write("writing " + str + ":\n");
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
  input = input.replace(/\n/g, "@@@");
  var output = child_process.execFileSync('/usr/local/bin/petcat', ['-nh', '-text'], {
    input: input
  });
  output = String(output);
  output = output.replace(/@@@/g, "\x0d");
  return String(output);
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
