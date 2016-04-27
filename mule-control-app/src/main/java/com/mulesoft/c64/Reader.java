package com.mulesoft.c64;
import org.mule.api.MuleEventContext;
import org.mule.api.lifecycle.Callable;

public class Reader implements Callable {

	@Override
	public Object onCall(MuleEventContext eventContext) throws Exception {
		eventContext.getMessage().setPayload(Memory.json);
		return eventContext.getMessage();
	}

}
