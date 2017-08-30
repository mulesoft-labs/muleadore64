# muleadore64

Using [MuleSoft](https://www.mulesoft.com/) technologies to power a Commodore 64, amongst other things ...

Commodore 64 commercial from 1985: [Youtube](https://www.youtube.com/watch?v=ocn806kzQAc)

![Logo](/assets/logo-c64-rendered.png?raw=true)
![The hack](/assets/the-hack.png?raw=true)

# Setup instructions for the picture demo on a Mac

1. Download [Vice64](http://vice-emu.sourceforge.net/) version 2.4 for Mac Cocoa compiled with gcc

Direct link: http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/vice-macosx-cocoa-i386%2bx86_64-10.6-gcc42-2.4.dmg

2. Extract Vice contents to: `/Applications/Vice64`
3. Add this to your .bashrc: `export PATH=/Applications/Vice64/tools:$PATH`
4. Install ACME assembler: `brew install acme`
5. Install ImageMagick: `brew install imagemagick`
6. Install node 6 using nvm
    1. Install NVM using the bash script on this page: [https://github.com/creationix/nvm](https://github.com/creationix/nvm)
    2. Install the latest version of node 6 using cli: `nvm install 6`
    3. Set your default node version to node 6 (optional but recommended): `echo "6" > ~/.nvmrc; nvm alias default 6`
7. Clone the commodore repo to the home dir: https://github.com/mulesoft-labs/muleadore64
8. `cd ~/muleadore64; git checkout runwiththemules`
9. `cd c64-app`
10. `mkdir build`
11. `acme main.asm`
12. `cd build`
13. Test that you can run the emulator and change its settings
    1. Launch the program from CLI: `x64 build/ms4.prg`.  Verify you see the Commodore64 Ready screen.
    2. From the top toolbar select `Settings -> Resource Inspector`.  Expand the settings window so that it's very wide.  This helps when selecting options because you have to click the arrows that appear on the right side.
    3. Navigate to `Peripherals -> Cartridges -> Userport RS232`
    4. Set Baud rate to 2400
    5. Check the `Enable` box
    6. Set RS232 Device to `Device 4`
    7. Navigate to `Peripherals -> RS232`
    8. Set `Device 4` to `|../raspberry-pi/serial_port/app.js`.  You have to double click on the text to set it.
    9. Set `Device 4 Baud Rate` to `2400`
    10. Close Settings window
    11. *VERY IMPORTANT* Save your settings before quitting x64.  From the top nav bar click on `Settings -> Save current settings`
14. `cd ~/muleadore64/raspberry-pi/serial_port`
15. `npm install` Make sure you are using node v6
16. Navigate a finder window to `~/muleadore64/c64-app`
17. Double click on the command file `start-c64-runwiththemules-demo.sh.command` to run the demo.  You should see the mulesoft Commodore64 program on the emulator screen.  If you need to change this script for your specific machine then go ahead.
18. Test that the app is working correctly by uploading a photo to twitter with `#runwiththemules` in the message and see if it renders on the screen.
19. *VERY IMPORTANT* Turn your computer sound up
20. Congratulations!  You have now setup your machine as a Commodore64 demo emulator.  It will pickup any tweets or photos uploaded to twitter with the hashtag `#runwiththemules`.  Alternatively you can upload photos to the app directly at this URL (jpg only): http://c64-photo-ingest.cloudhub.io/static

# Useful information about how the system works

### Cloudhub Application

* http://muleadore64.cloudhub.io/control/
  * V1 control webpage
  * Most stable functionality for interacting with the commodore
* http://muleadore64.cloudhub.io/control2/
  * V2 control webpage that also has the realtime flow diagram
  * The buttons on this page are not totally functional yet
  * Better to use V1 for pushing buttons and V2 for showing the flow diagram
* API commands
  * GET http://muleadore64.cloudhub.io/api/visitors - Generate a visitor message from greenhouse
  * GET http://muleadore64.cloudhub.io/api/weather - Generate a weather message
  * GET http://muleadore64.cloudhub.io/api/state - See the full state of the system including all recent messages and timestamps

### Hue Lights
* You can find the IP address of the HUE light hub from the following page.  This is necessary for the mule app on the raspberry pi to be able to talk to the hub.  The IP should hopefully not change often.
  * http://www.meethue.com/api/nupnp
  * You will get an object back like this

```javascript
[
  {
    id: "001788fffe0a4d4b",
    internalipaddress: "172.16.11.112"
  }
]
```

* There is a control API page included with the hub at the following location: http://${HUB_IP}/debug/clip.html
* Query the following endpoint to get the state of the lights: `/api/15cfeb5d3c786ba71cdfcb193c0fe5c3/lights`


