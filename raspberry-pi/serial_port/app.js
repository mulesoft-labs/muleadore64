#!/usr/bin/env node
'use strict';
const Promise = require('bluebird');
const request = require('request-promise');
const serialPortDevice = process.env.C64_SERIALPORT_DEVICE;
const C64SerialChannel = require('./c64SerialChannel');
const logger = require('./logger');
const commandFetcher = require('./commandFetcher');
const petscii = require('./petscii');
const child_process = require('child_process');
const fs = require('fs');

const COMMAND_PROCESSED_CALLBACK_MSG = 1;

const c64Channel = new C64SerialChannel(serialPortDevice, 1200);

var c64IsReady = true;
var delayNextFetchUntil = 0;

c64Channel.on('commandReceived', (command, data) => {
  switch (command) {
    case COMMAND_PROCESSED_CALLBACK_MSG:
      c64IsReady = true;
      delayNextFetchUntil = Date.now() + 10 * 1000;
      break;
      
    default: {
      logger.log('unknown command:', data.toString());
    }
  }
});

function triggerFetch() {
  setTimeout(() => {
    fetchAndProcessMessage()
      .then(() => {
        triggerFetch();
      })
    }, 1000);
}

function fetchAndProcessMessage() {
  if (!c64IsReady) {
    logger.log('c64 not ready...');
    return Promise.resolve();
  }

  if (delayNextFetchUntil > Date.now()) {
    logger.log('delaying...');
    return Promise.resolve();
  }

  return commandFetcher.fetchNextMessageFromQueue()
    .then((msg) => {
      if (!msg) {
        return;
      }

      logger.log('message recieved', msg);

      switch (msg.type) {

        case 'background-image':
          var filename = msg.url;
          //var imPath = 'convert ' + filename + ' -resize \'320x200>\' -background black -gravity center -extent 320x200 -monochrome /tmp/resized.png | tee /tmp/conv-output.txt' ;
          var imPath = 'convert ' + filename + ' -resize \'320\' -background black -gravity center -extent 320x200 -monochrome /tmp/resized.png | tee /tmp/conv-output.txt' ;
          logger.log('Resizing and reducing colorspace...');
          child_process.execSync(imPath);
          logger.log('done');
          var execPath = 'node ../background-bitmap-generator/app.js /tmp/resized.png | tee /tmp/conv-output2.txt';
          logger.log('Generating c64 bitmap bitstream...');
          child_process.execSync(execPath);
          logger.log('done');
          var data = fs.readFileSync('/tmp/c64-output.bin');
          //data = data.slice(0, 1000);
          c64IsReady = false;
          c64Channel.write(1, data);
          break;

        case 'tweet':
          delayNextFetchUntil = Date.now() + 5 * 1000;
          c64Channel.write(3, Buffer.from(petscii.to(msg.text) + '\0'));
          break;

        default:
          logger.log('unexpected message', msg);
      }
    })
    .catch((e) => {
      logger.log(e);
      c64IsReady = true;
    });
  
}

triggerFetch();
