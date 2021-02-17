package com.worldline.wldd.mq.ws.parameters.controllers;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.worldline.wldd.mq.ws.parameters.entities.Parameters;
import com.worldline.wldd.mq.ws.parameters.repositories.ParametersRepository;
import com.worldline.wldd.mq.ws.tools.FormatedMessage;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping(path="/parameters")
public class ParametersController {
    @Autowired
    private ParametersRepository parametersRepository;

    @PostMapping(path="/addDefaultParameterValue")
    public @ResponseBody
    String addParameterDefaultValue(@RequestParam Integer parameterId, @RequestParam String parameterValue){
        Parameters parameter = parametersRepository.findById(parameterId).get();
        if(parameter!=null){
            parameter.setParameterDefaultValue(parameterValue);
            parametersRepository.save(parameter);
            return FormatedMessage.errorMessage(false);
        }
        return FormatedMessage.errorMessage(true);
    }

    @PostMapping(path="/addAllParametersDefaultValues")
    public @ResponseBody
    String addAllParametersDefaultValues(@RequestParam String jsonString){
        JsonParser jsonParser = new JsonParser();
        JsonArray arrayFromString = jsonParser.parse(jsonString).getAsJsonArray();
        for(int i=0; i<arrayFromString.size();i++){
            JsonObject jsonObject = arrayFromString.get(i).getAsJsonObject();
            int id = jsonObject.get("id").getAsInt();
            String value = jsonObject.get("value").getAsString();
            addParameterDefaultValue(id,value);
        }
        return FormatedMessage.errorMessage(false);
    }
}
