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
const { execSync } = require('child_process');
const Twitter = require('twitter');

const client = new Twitter({
  access_token_key: process.env.TWITTER_ACCESS_KEY,
  access_token_secret: process.env.TWITTER_ACCESS_SECRET,
  consumer_key: process.env.TWITTER_CONSUMER_KEY,
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
});

const COMMAND_PROCESSED_CALLBACK_MSG = 1;
const TWEET_END_MARKER = "~";
const c64Channel = new C64SerialChannel(serialPortDevice, 2400);

var c64IsReady = true;
var delayNextFetchUntil = 0;
var lastMessage = '';
var mode = 0;
var shouldCapture = false;

function screenCapture() {
  if (process.env.TWITTER_ENABLE !== 'yes') {
    logger.log("tweeting disabled")
    return
  }

  let msg = process.env.TWITTER_COPY
  if (!msg || msg === '') {
    msg = 'Pixelate yourself on our #c64 at the #MuleSoft #TDX19 booth! We truly can #integrate anything!'
  }

  const args = process.env.CAPTURE_ARGS || ''

  try {
    const stdout = execSync(`screencapture -x ${args} test.png`, {
      timeout: 600
    })
    logger.log("Screen capture OK")
    var data
    try {
      data = fs.readFileSync('test.png');
    } catch (error) {
      logger.log("ERROR: Cant read file", error)
      return
    }
    // Make post request on media endpoint. Pass file data as media parameter
    logger.log("Uploading file")
    client.post('media/upload', { media: data }, function (error, media, response) {
      if (error) {
        logger.log("ERROR: media upload error", error)
        return
      }
      // Lets tweet it
      var status = {
        status: msg,
        media_ids: media.media_id_string // Pass the media id string
      }
      logger.log("Posting update file")
      client.post('statuses/update', status, function (error, tweet, response) {
        if (error) {
          logger.log("ERROR: statuses update error", error)
          return
        }
      });
    });
  } catch (err) {
    logger.log("screencapture err", err)
    return
  }
}

c64Channel.on('commandReceived', (command, data) => {
  logger.log("XXX should cap", shouldCapture)
  switch (command) {
    case COMMAND_PROCESSED_CALLBACK_MSG:
      c64IsReady = true;
      if (shouldCapture) {
        screenCapture()
      }

      if (lastMessage === 'background-image') {
        delayNextFetchUntil = Date.now() + 5 * 1000;
      }
      else {
        delayNextFetchUntil = Date.now() + 5 * 1000;
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
        if (mode != 0) {
          c64Channel.write(4);  //attract screen
          shouldCapture = false
          mode = 0;
        }
        return;
      }

      c64IsReady = false;

      if (msg.data) {
        logger.log('message recieved (base64)', msg.type);
        shouldCapture = true
      }
      else {
        logger.log('message recieved', msg.type);
      }

      if (!msg.type) {
        logger.log('[warn] no type field on msg, ignoring...');
        return;
      }

      switch (msg.type) {

        case 'background-image':
          mode = 1;
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
          child_process.spawnSync('cp', [filename, '/tmp/c64-img-' + timestamp + '-orig.png']);
          var outputfile = '/tmp/c64-img-' + timestamp + '.png';

          //var imPath = 'convert ' + filename + ' -resize \'320x200>\' -background black -gravity center -extent 320x200 -monochrome /tmp/resized.png | tee /tmp/conv-output.txt' ;
          var imPath = 'convert ' + filename + ' -resize \'320\' -background black -gravity center -extent 320x200 -monochrome ' + outputfile + ' | tee /tmp/conv-output.txt';
          logger.log('Resizing and reducing colorspace...');
          child_process.execSync(imPath);
          logger.log('done');
          logger.log('Generating c64 bitmap bitstream...');
          return bitmapGenerator.generateFromFile(outputfile, 320, 200)
            .then((pixelData) => {
              c64Channel.write(1, pixelData);
              logger.log('done');
            });

          break;

        case 'tweet':
          mode = 1;
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
