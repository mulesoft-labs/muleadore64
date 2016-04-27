package com.mulesoft.c64;
import org.mule.api.MuleEventContext;
import org.mule.api.lifecycle.Callable;

public class Writer implements Callable {

	@Override
	public Object onCall(MuleEventContext eventContext) throws Exception {
		String payloadAsString = eventContext.getMessage().getPayloadAsString();
		Memory.json = payloadAsString;
		return eventContext;
	}
	
}
