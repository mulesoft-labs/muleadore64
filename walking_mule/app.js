var getPixels = require("get-pixels")
 
getPixels("frame_7_delay-0.08s.gif", function(err, pixels) {
  if(err) {
    console.log("Bad image path", err)
    return
  }

  for (var y = 0; y < 21; y++) {
    process.stdout.write('data ');
    for (var x = 0; x < 3; x++) {
      var index = (y * 24 * 4) + (x * 8 * 4);
      var output = 0;
      var shift = 7;
      for (var px = 0; px < 8; px++) {
        if (pixels.data[index + (px * 4) + 3] === 255) output |= (1 << shift);
        shift--;
      }
      process.stdout.write(String(output));
      if (x < 2) { process.stdout.write(','); }
    }
    console.log();
  }
})