package com.mulesoft.c64;

public class State {

	public StateObject twitterToMule;
	public StateObject weatherToMule;
	public StateObject greenhouseToMule;
	public StateObject envoyToMule;
	public StateObject controlAppToMule;
	public StateObject muleToAmq;
	public StateObject amqToPi;
	public StateObject piToC64;
	public StateObject c64ToPi;
	public StateObject piToLights;
	public StateObject piToTwitter;
	
	public State() {
		this.twitterToMule = new StateObject();
		this.weatherToMule = new StateObject();
		this.greenhouseToMule = new StateObject();
		this.envoyToMule = new StateObject();
		this.controlAppToMule = new StateObject();
		this.muleToAmq = new StateObject();
		this.amqToPi = new StateObject();
		this.piToC64 = new StateObject();
		this.c64ToPi = new StateObject();
		this.piToLights = new StateObject();
		this.piToTwitter = new StateObject();
	}
}

/**
var state = {
'twitter-to-mule': {
  lastActive: 2000,
  message: {
  	type: tweet,
  	id: 1235-2634-77334-44455,
  	c64command: "7something goes here",
  	bytesBefore: 702,
  	bytesAfter:64
  }
},
'weather-to-mule': {
  lastActive: 2000
},
'greenhouse-to-mule': {
  lastActive: 2000
},
'envoy-to-mule': {
  lastActive: 2000
},
'mule-to-amq': {
  lastActive: 2000
},
'amq-to-pi': {
  lastActive: 2000
},
'pi-to-c64': {
  lastActive: 2000
},
'c64-to-pi': {
  lastActive: 2000
},
'pi-to-lights': {
  lastActive: 2000
},
'pi-to-twitter': {
  lastActive: 2000
}
};
*/