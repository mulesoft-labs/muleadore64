# muleadore64

Using [MuleSoft](https://www.mulesoft.com/) technologies to power a Commodore 64, amongst other things ...

Commodore 64 commercial from 1985: [Youtube](https://www.youtube.com/watch?v=ocn806kzQAc)

![Logo](/assets/logo-c64-rendered.png?raw=true)
![The hack](/assets/the-hack.png?raw=true)

## Useful information

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
