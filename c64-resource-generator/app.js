var Promise = require('bluebird');
var getPixels = Promise.promisify(require("get-pixels"));
var Buffer = require('buffer').Buffer;
var fs = Promise.promisifyAll(require('fs'));

var outputFile = fs.createWriteStream("output.spr");

var filename = process.argv[2];
console.log('Processing', filename);
getPixels(filename)
  .then((pixels) => {
    var frameCount = pixels.shape[0];
    console.log('frames', frameCount);
    var fileWrites = [];
    for (var frame = 0; frame < frameCount; frame++) {
      var pxBuffer = new Buffer(64);
      pxBuffer[63] = 0;  //trailing padding byte
      var pxBufferIndex = 0;
      for (var y = 0; y < 21; y++) {
        for (var x = 0; x < 3; x++) {
          var output = 0;
          var shift = 7;
          for (var px = 0; px < 8; px++) {
            if (pixels.get(frame, x * 8 + px, y, 3) === 255) {
              output |= (1 << shift);
            }
            shift--;
          }
          pxBuffer[pxBufferIndex++] = output;
        }
      }
      fileWrites.push(outputFile.writeAsync(pxBuffer));
    }
    return Promise.all(fileWrites);
  })
  .then(() => {
    outputFile.close();
    console.log('Sprites written to output.spr');
  });
 
