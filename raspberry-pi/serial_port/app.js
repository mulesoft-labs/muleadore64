#!/usr/bin/env node
'use strict';
const Promise = require('bluebird');
const request = require('request-promise');
const serialPortDevice = process.env.C64_SERIALPORT_DEVICE;
const C64SerialChannel = require('./c64SerialChannel');
const logger = require('./logger');
const commandFetcher = require('./commandFetcher');
const petscii = require('./petscii');
const bitmapGenerator = require('./bitmapGenerator');
const child_process = require('child_process');
const fs = require('fs');

const COMMAND_PROCESSED_CALLBACK_MSG = 1;
const TWEET_END_MARKER = "~";
const c64Channel = new C64SerialChannel(serialPortDevice, 1200);

var c64IsReady = true;
var delayNextFetchUntil = 0;
var lastMessage = '';

c64Channel.on('commandReceived', (command, data) => {
  switch (command) {
    case COMMAND_PROCESSED_CALLBACK_MSG:
      c64IsReady = true;
      if (lastMessage === 'background-image') {
        delayNextFetchUntil = Date.now() + 5 * 1000;
      }
      else {
        delayNextFetchUntil = Date.now() + 2 * 1000; 
      }
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

      c64IsReady = false;

      if (msg.data) {
        logger.log('message recieved (base64)', msg.type);
      }
      else {
        logger.log('message recieved', msg);
      }

      if (!msg.type) {
        logger.log('[warn] no type field on msg, ignoring...');
        return;
      }

      switch (msg.type) {

        case 'background-image':
          if (msg.data) {
            var b64string = msg.data.substring(msg.data.indexOf(','));
            var buf = Buffer.from(b64string, 'base64');
            fs.writeFileSync('/tmp/b64.jpg', buf);
            msg.url = '/tmp/b64.jpg';
          }
          if (!msg.url) {
            logger.log('no url property... ignoring');
            return;
          }
          var filename = msg.url;
          var timestamp = Date.now();
          child_process.spawnSync('cp', [filename, '/tmp/img/' + timestamp + '-orig.png']);
	        var outputfile = '/tmp/img/' + timestamp + '.png';

          //var imPath = 'convert ' + filename + ' -resize \'320x200>\' -background black -gravity center -extent 320x200 -monochrome /tmp/resized.png | tee /tmp/conv-output.txt' ;
          var imPath = 'convert ' + filename + ' -resize \'320\' -background black -gravity center -extent 320x200 -monochrome ' + outputfile + ' | tee /tmp/conv-output.txt' ;
          logger.log('Resizing and reducing colorspace...');
          child_process.execSync(imPath);
          logger.log('done');
          //var execPath = 'node ../background-bitmap-generator/app.js /tmp/resized.png | tee /tmp/conv-output2.txt';
          logger.log('Generating c64 bitmap bitstream...');
          return bitmapGenerator.generateFromFile(outputfile, 320, 192)
            .then((pixelData) => {
              c64Channel.write(1, pixelData);
              logger.log('done');
            });
          
          break;

        case 'tweet':
          var petsciiData = petscii.to(msg.text.replace(TWEET_END_MARKER, '-')) + TWEET_END_MARKER;
          c64Channel.write(3, Buffer.from(petsciiData));
          break;

        default:
          logger.log('unexpected message', msg);
          c64IsReady = true;
      }
    })
    .catch((e) => {
      logger.log(e);
      c64IsReady = true;
    });
  
}

triggerFetch();
