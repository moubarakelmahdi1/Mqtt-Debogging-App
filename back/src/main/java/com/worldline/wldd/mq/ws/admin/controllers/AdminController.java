package com.worldline.wldd.mq.ws.admin.controllers;

import com.worldline.wldd.mq.ws.admin.entities.Admin;
import com.worldline.wldd.mq.ws.admin.repositories.AdminRepository;
import com.worldline.wldd.mq.ws.tools.ConstantUtils;
import com.worldline.wldd.mq.ws.tools.FormatedMessage;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.conn.params.ConnRoutePNames;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.worldline.wldd.mq.ws.tools.Token;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminRepository adminRepository;

    @RequestMapping(value = "/token", method = RequestMethod.GET)
    public ResponseEntity<Object> getDassoInformations (@RequestParam String code) throws IOException, ParseException {

        HttpGet httpGet;
        String httpResponse;
        JSONParser parser;

        StringBuffer req = new StringBuffer(512);
        req.append(ConstantUtils.OAUTH2_SERVER);
        req.append("/token.php");
        req.append("?client_id=").append(ConstantUtils.CLIENT_ID);
        req.append("&client_secret=").append(ConstantUtils.CLIENT_SECRET);
        req.append("&redirect_uri=").append(URLEncoder.encode(ConstantUtils.CLIENT_CALLBACK, "UTF-8"));
        req.append("&code=").append(code);
        req.append("&grant_type=authorization_code");

        httpGet = new HttpGet(req.toString());
        httpResponse = getHttpResponse(httpGet);

        parser = new JSONParser();

        JSONObject jsonToken = (JSONObject) parser.parse(httpResponse);

        String accessToken = (String)jsonToken.get("access_token");

        // get user information

        httpGet = new HttpGet(ConstantUtils.OAUTH2_SERVER + "/userinfo.php?access_token=" + accessToken);
        httpGet.setHeader("Accept", "application/json");

        httpResponse = getHttpResponse(httpGet);

        parser = new JSONParser();
        JSONObject userInfos = (JSONObject) parser.parse(httpResponse);

        Admin adminUser = adminRepository.findByDas((String)userInfos.get("das_id"));

        if(adminUser == null){
            adminUser = new Admin();
            adminUser.setDas((String)userInfos.get("das_id"));
            adminUser.setEmail((String)userInfos.get("email"));
            adminUser.setFirstName((String)userInfos.get("first_name"));
            adminUser.setLastName((String)userInfos.get("last_name"));
            adminUser.setComplexId(UUID.randomUUID().toString().replaceAll("-", ""));
            adminUser.setAdmin(false);
        }

        SimpleDateFormat format = new SimpleDateFormat(ConstantUtils.datePattern);
        Date date = new Date();
        adminUser.setLastConnexionDate(format.format(date));
        adminRepository.save(adminUser);

        HttpHeaders headers = new HttpHeaders();
        headers.setLocation(URI.create(ConstantUtils.REDIRECT_URL_OK+adminUser.getComplexId()));
        return new ResponseEntity<Object>(headers, HttpStatus.MOVED_PERMANENTLY);
    }


    @PostMapping(value = "/updateRole")
    public @ResponseBody String updateRole (@RequestParam String adminToken,@RequestParam String dasToUpdate)  {

        int adminId = Token.decodeToken(adminToken);
        Admin admin = adminRepository.findById(adminId);
        if(admin != null && admin.isAdmin()){
            Admin user = adminRepository.findByDas(dasToUpdate);
            user.setAdmin(true);
            adminRepository.save(user);
            return FormatedMessage.errorMessage(false);
        }

        return FormatedMessage.errorMessage(true);
    }

    @PostMapping(value = "/authenticate")
    public @ResponseBody String authenticate (@RequestParam String adminComplexId)  {
        Admin admin = adminRepository.findByComplexId(adminComplexId);
        if(admin != null){

            admin.setComplexId(UUID.randomUUID().toString().replaceAll("-", ""));
            adminRepository.save(admin);

            String token = Token.generateToken(admin.getId().toString());
            HashMap<String,String> response = new HashMap<>();
            response.put("token", token);
            response.put("das", admin.getDas());
            response.put("isAdmin", String.valueOf(admin.isAdmin()));
            response.put("name", admin.getFirstName()+" "+admin.getLastName());
            response.put("email", admin.getEmail());
            response.put("id", admin.getId().toString());


            return FormatedMessage.infoMessage(false, response);
        }

        return FormatedMessage.errorMessage(true);
    }

    @GetMapping(value = "/getAll")
    public @ResponseBody List<Admin> getAll (@RequestHeader("authorization") String authHeader)  {
        if (authHeader != null || authHeader.startsWith("Bearer ")) {
            final String token = authHeader.substring(7);

            int adminId = Token.decodeToken(token);
            Admin admin = adminRepository.findById(adminId);
            if (admin != null && admin.isAdmin()) {
                List<Admin> listAdmins = adminRepository.findAllByOrderByLastName();
                if (listAdmins != null) {
                    return listAdmins;
                }
            }
        }
        return null;
    }

    private static String getHttpResponse(HttpUriRequest request) throws IOException {
        HttpResponse response = getHttpClient().execute(request);

        BufferedReader brd = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
        StringBuffer buffer = new StringBuffer(4096);
        String line;

        while ((line = brd.readLine()) != null)
        {
            buffer.append(line);
        }
        brd.close();

        return buffer.toString();
    }

    private static HttpClient getHttpClient() {
        HttpClient httpClient = new DefaultHttpClient();
        HttpHost proxy = new HttpHost(ConstantUtils.PROXY, 3128);
        httpClient.getParams().setParameter(ConnRoutePNames.DEFAULT_PROXY, proxy);
        return httpClient;
    }
}
