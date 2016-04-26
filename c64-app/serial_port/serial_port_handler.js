#!/usr/bin/env node
'use strict';
var child_process = require('child_process');
var Promise = require('bluebird');


process.stdin.setEncoding('ascii');

var delay = 100;
write(' ');

Promise.delay(1)
  .then(() => {
    write('4Z');
    return Promise.delay(4000);
  })
  .then(() => {
    write(formatTweet({
      user: '@jeff',
      text: 'This is super cool #c64\x0danother line'
    }));
    return Promise.delay(10000);
  })
  .then(() => {
    write('1' + convertToPetscii('another tweet........................................................z'));
    return Promise.delay(4000);
  })
  .then(() => {
    write('29Z');
    return Promise.delay(4000);
  })
  .then(() => {
    write('37Z');
    return Promise.delay(4000);
  })
  


function formatTweet(tweet) {
  return '1' + convertToPetscii(tweet.user + ', at ' + '12:39:07') + '\x0d\x1c' + convertToPetscii(tweet.text) + 'Z';
}

function write(str) {
  process.stdout.write(str);
  return;
  // var arr = str.split('');
  // for (var i = 0; i < arr.length; i++) {
  //   process.stdout.write(String(str[i]));
  // }
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


// process.stdin.on('end', function () {

// });