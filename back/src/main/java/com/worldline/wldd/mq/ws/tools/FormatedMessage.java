package com.worldline.wldd.mq.ws.tools;

import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

public class FormatedMessage {

	public static String errorMessage(boolean isError){
		return errorMessage(isError,"");
	}

	public static String errorMessage(boolean isError, String message){
		JSONObject obj = new JSONObject();
		try {
			obj.put("error", isError);
			if(isError && message != null && !message.isEmpty()){
				obj.put("message", message);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}

	public static String infoMessage(boolean isError, HashMap<String,String> messages){
		JSONObject obj = new JSONObject();
		try {
			obj.put("error", isError);
			if(messages != null && messages.size()>0){
				for ( String key : messages.keySet() ) {
					obj.put(key,messages.get(key));
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}
}
