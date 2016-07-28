package com.mulesoft.c64;

import org.mule.api.MuleEventContext;
import org.mule.api.lifecycle.Callable;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class ReadState implements Callable {

	public static Gson gson = new GsonBuilder().create();

	@Override
	public Object onCall(MuleEventContext eventContext) throws Exception {
		eventContext.getMessage().setPayload(gson.toJson(Memory.state).toString());
		return eventContext.getMessage();
	}
}
