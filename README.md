# muleadore64

Using [MuleSoft](https://www.mulesoft.com/) technologies to power a Commodore 64, amongst other things ...

Commodore 64 commercial from 1985: [Youtube](https://www.youtube.com/watch?v=ocn806kzQAc)

![Logo](/assets/logo-c64-rendered.png?raw=true)
![The hack](/assets/the-hack.png?raw=true)

# Install

* Download [Vice64](https://sourceforge.net/projects/vice-emu/files/releases/binaries/macosx/vice-macosx-sdl-x86_64-10.12-3.1.dmg/download)
* Extract Vice contents to: `/Applications/Vice64`
* Add this to your .bashrc: `export PATH=/Applications/Vice64/tools:$PATH`
* Install ACME assembler: `brew install acme`
* Install ImageMagick: `brew install imagemagick`
* Install node: `brew install node`
* `cd ~/muleadore64; git checkout tdx-18`
* `cd ~/muleadore64/raspberry-pi/serial_port`
*  `npm install`
* `cd ~/muleadore/c64-app`
* `make` to build binary
* `make run` to build + run the emulator
* Congratulations!  You have now setup your machine as a Commodore64 demo emulator.  You can upload photos to the app directly at this URL (jpg only): http://c64-photo-ingest.cloudhub.io/static.

Alternatively, you can hardcode an image in the `list` variable in `commandFetcher.js` (https://github.com/mulesoft-labs/muleadore64/blob/tdx-18/raspberry-pi/serial_port/commandFetcher.js#L12)
