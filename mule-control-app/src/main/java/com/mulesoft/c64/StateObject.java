package com.mulesoft.c64;

import java.util.Date;

public class StateObject {
	
	public long lastActive;
	public C64Message message; 
	
	public StateObject() {
		this.lastActive = new Date().getTime();
		this.message = null;
	}
}