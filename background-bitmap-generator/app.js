// convert /Users/jeff/kate/IMG_1743.JPG -resize 320x200 -colors 2 /tmp/output.bmp

var Promise = require('bluebird');
var getPixels = Promise.promisify(require("get-pixels"));
var Buffer = require('buffer').Buffer;
var fs = Promise.promisifyAll(require('fs'));

var outputFile = fs.createWriteStream("/tmp/c64-output.bin");

var filename = process.argv[2];
console.log('Processing', filename);
getPixels(filename)
  .then((pixels) => {

    const BYTE_WIDTH = 320 / 8;
    
    var pxBuffer = new Buffer(BYTE_WIDTH * 200);

    colors = {};

    var pxBufferIndex = 0;
    for (var y = 0; y < 200; y += 8) {
      for (var x = 0; x < 320; x += 8) {

        for (var py = 0; py < 8; py++) {

          var output = 0;
          var shift = 7;

          // slurp 8 pixels at a time and pack into bits
          for (var px = 0; px < 8; px++) {
         //   console.log(x + px, y + py)
            var r = pixels.get(x + px, y + py, 0);
            var g = pixels.get(x + px, y + py, 1);
            var b = pixels.get(x + px, y + py, 2);
            
            if (r === 255) {
              output |= (1 << shift);
            }
            shift--;
          }
          pxBuffer[pxBufferIndex++] = output;
        }
      }
    }
    console.log(colors);
    return outputFile.writeAsync(pxBuffer);
  })
  .then(() => {
    outputFile.close();
    console.log('Packed image written to output.bin');
  });