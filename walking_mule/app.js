var Promise = require('bluebird');
var getPixels = Promise.promisify(require("get-pixels"));
var Buffer = require('buffer').Buffer;
var fs = require('fs');

var fs = require('fs');
var outputFile = fs.createWriteStream("output.spr");

var files = process.argv[2].split(',');

Promise.each(files, (f) => {
  console.log('Processing', f);

  var pxBuffer = new Buffer(64);
  pxBuffer[63] = 0;  //trailing padding byte
  var pxBufferIndex = 0;

  return getPixels(f)
    .then((pixels) => {
      for (var y = 0; y < 21; y++) {
        for (var x = 0; x < 3; x++) {
          var index = (y * 24 * 4) + (x * 8 * 4);
          var output = 0;
          var shift = 7;
          for (var px = 0; px < 8; px++) {
            if (pixels.data[index + (px * 4) + 3] === 255) output |= (1 << shift);
            shift--;
          }
          pxBuffer[pxBufferIndex++] = output;
        }
      }
      outputFile.write(pxBuffer);

    });
})
  .then(() => {
    outputFile.close();
    console.log('Sprites written to output.spr');
  });
 
