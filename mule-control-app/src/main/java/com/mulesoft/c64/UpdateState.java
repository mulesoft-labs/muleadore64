package com.mulesoft.c64;

import org.mule.api.MuleEventContext;
import org.mule.api.lifecycle.Callable;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class UpdateState implements Callable {

	public static Gson gson = new GsonBuilder().create();

	@Override
	public Object onCall(MuleEventContext eventContext) throws Exception {
		UpdateCommand cmd = gson.fromJson(eventContext.getMessage().getPayloadAsString(), UpdateCommand.class);
		
		if (cmd.twitterToMule != null) Memory.state.twitterToMule = cmd.twitterToMule;
		if (cmd.weatherToMule != null) Memory.state.weatherToMule = cmd.weatherToMule;
		if (cmd.greenhouseToMule != null) Memory.state.greenhouseToMule = cmd.greenhouseToMule;
		if (cmd.envoyToMule != null) Memory.state.envoyToMule = cmd.envoyToMule;
		if (cmd.controlAppToMule != null) Memory.state.controlAppToMule = cmd.controlAppToMule;
		if (cmd.muleToAmq != null) Memory.state.muleToAmq = cmd.muleToAmq;
		if (cmd.amqToPi != null) Memory.state.amqToPi = cmd.amqToPi;
		if (cmd.piToC64 != null) Memory.state.piToC64 = cmd.piToC64;
		if (cmd.c64ToPi != null) Memory.state.c64ToPi = cmd.c64ToPi;
		if (cmd.piToLights != null) Memory.state.piToLights = cmd.piToLights;
		if (cmd.piToTwitter != null) Memory.state.piToTwitter = cmd.piToTwitter;
		
		return eventContext.getMessage();
	}
	
	class UpdateCommand {
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
	}

}
