#!/usr/bin/env node
'use strict';
var child_process = require('child_process');
var Promise = require('bluebird');
var amqService = require('./amqService.js')


process.stdin.setEncoding('ascii');

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
  }, 1000)
}

timeout();
heartbeat();


function write(str) {
  var str = str[0] + convertToPetscii(str.substring(1));
  str += 'Z';  // add end marker
  process.stderr.write("writing " + str + ":\n");
  process.stdout.write(str);
  return;
}

function convertToPetscii(input) {
  input = input.replace(/\x0d/g, "@@@");
  var output = child_process.execFileSync('/usr/local/bin/petcat', ['-nh', '-text'], {
    input: input
  });
  output = String(output);
  output = output.replace(/@@@/g, "\x0d");
  return String(output);
}

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
