package com.human.onnana.utility;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.human.onnana.entity.Anniversary;

@Service
public class SchedUtil {

	@Value("${govDataApiKey}") private String govDataApiKey;
	
	public boolean isLeapYear(int year) {
		if (year % 400 == 0)
			return true;
		if (year % 100 == 0)
			return false;
		if (year % 4 == 0)
			return true;
		return false;
	}
	
	public List<String> genTime() {
		List<String> list = new ArrayList<>();
		for (int hour=0; hour<24; hour++)
			for (int min=0; min<60; min+=30)
				list.add(String.format("%02d:%02d", hour, min));
		return list;
	}
	
	public List<Anniversary> getAnnivList(String option, int year) {
		List<Anniversary> list = new ArrayList<>();
		String apiUrl = option.equals("24절기") ?
				"http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/get24DivisionsInfo" :
				"http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo";
		try {
			apiUrl += "?_type=json&numOfRows=50&solYear=" + year
					+ "&ServiceKey=" + URLEncoder.encode(govDataApiKey, "utf-8");
			URL url = new URL(apiUrl);
			BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(), "utf-8"));
			
			String line = null, result = "";
			while ((line = br.readLine()) != null)
				result += line;
			br.close();
			
			JSONParser parser = new JSONParser();
			JSONObject obj = (JSONObject) parser.parse(result);
			JSONObject response = (JSONObject) obj.get("response");
			JSONObject body = (JSONObject) response.get("body");
			JSONObject items = (JSONObject) body.get("items");
			JSONArray itemArray = (JSONArray) items.get("item");
			for (int i = 0; i < ((JSONArray)itemArray).size(); i++) {
				JSONObject item = (JSONObject) itemArray.get(i);
				String dateName = (String) item.get("dateName");
				String isHoliday = (String) item.get("isHoliday");
				long locdate = (long) item.get("locdate");
				Anniversary anniv = new Anniversary("admin", dateName, ""+locdate, isHoliday.equals("Y") ? 1 : 0);
				list.add(anniv);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
}
