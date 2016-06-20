package com.mulesoft.c64.pi;
//import java.util.regex.Matcher;
//import java.util.regex.Pattern;

import org.mule.api.MuleEventContext;
import org.mule.api.lifecycle.Callable;
import java.lang.StringBuilder;

import java.util.HashMap;

public class ProcessC64Message implements Callable {

	@Override
	public Object onCall(MuleEventContext eventContext) throws Exception {
		HashMap<String, String> myPayload = (HashMap) eventContext.getMessage().getPayload();
		String command = myPayload.get("command");
		String data = myPayload.get("data");
		switch (command) {
			case "light":
				return processLightCommand(data);
			case "tweet":
				return processTweetCommand(data);
			default:
				return null;				
		}
	}
	
	private String processLightCommand(String data) {
		switch (data) {
			case "power":
				Memory.power = !Memory.power;
				return createLightStateString(Memory.power, null, null, null, null, 0, 0);
			case "0":
				// Black
				return createLightStateString(Memory.power, 1, 0, 0, 248, 0.3804, 0.3768);
			case "1":
				// White
				return createLightStateString(Memory.power, 254, 0, 0, 248, 0.3804, 0.3768);
			case "2":
				// Yellow
				return createLightStateString(Memory.power, 254, 10922, 254, 500, 0.5615, 0.4056);
			case "3":
				// Red
				return createLightStateString(Memory.power, 254, 65535, 254, 500, 0.675, 0.322);
			case "4":
				// Magenta
				return createLightStateString(Memory.power, 254, 54612, 254, 239, 0.3739, 0.1549);
			case "5":
				// Orange
				return createLightStateString(Memory.power, 254, 5461, 254, 500, 0.6182, 0.3638);
			case "6":
				// Green
				return createLightStateString(Memory.power, 254, 21845, 254, 349, 0.448, 0.4893);
			case "7":
				// Cyan
				return createLightStateString(Memory.power, 254, 32767, 254, 176, 0.3283, 0.3587);
			case "8":
				// Brown
				return createLightStateString(Memory.power, 153, 5461, 170, 176, 0.3283, 0.3587);
			case "9":
				// Blue
				return createLightStateString(Memory.power, 254, 43690, 254, 500, 0.2054, 0.1159);
				
			default:
				return null;
				
		}	
	}
	
	private Object processTweetCommand(String data) {
		// TODO Auto-generated method stub
		return null;
	}


//	"state": {
//        "on": true,
//        "bri": 1,
//        "hue": 0,
//        "sat": 0,
//        "effect": "none",
//        "xy": [
//            0.3804,
//            0.3768
//        ],
//        "ct": 248,
//        "alert": "none",
//        "colormode": "hs",
//        "reachable": true
//    }
	public String createLightStateString(boolean on, Integer bri, Integer hue, Integer sat, Integer ct, double x, double y) {
		if (bri == null) {
			return new StringBuilder()
					.append("{\"on\":").append(on)
					.append("}")
					.toString();
		}
		return new StringBuilder()
				.append("{\"on\":").append(on)
				.append(", \"bri\":").append(bri)
				.append(", \"hue\":").append(hue)
				.append(", \"sat\":").append(sat)
				.append(", \"ct\":").append(ct)
				.append(", \"xy\":[").append(x).append(",").append(y).append("]")
				.append("}")
				.toString();
	}
	
}
