package com.human.onnana.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.human.onnana.utility.AsideUtil;

@Controller
@RequestMapping("/aside")
public class AsideController {
	
	@Autowired private AsideUtil asideUtil;

	// ★★ 명언 ★★
		@ResponseBody				// for ajax
		@GetMapping("/stateMsg")
		public String changeStateMsg(String stateMsg, HttpSession session) {
			session.setAttribute("stateMsg", stateMsg);
			return "aside";
		}
    
	// ★★ 웨더 ★★

		// 날씨 정보 가져오기
	    @ResponseBody
	    @GetMapping("/weather")
	    public ResponseEntity<Map<String, String>> getWeatherInfo(
	            @RequestParam(name = "lat") String lat,
	            @RequestParam(name = "lon") String lon) {
	        String weather = asideUtil.getWeather(lat, lon);

	     // 추가된 부분: 현재 위치의 이름 가져오기
	        String location = asideUtil.getAddressFromCoordinates(Double.parseDouble(lat), Double.parseDouble(lon));
	        
	        Map<String, String> result = new HashMap<>();
	        result.put("weather", weather);
	        result.put("location", location); // 위치 정보를 서버에서 받아와서 설정

	        return ResponseEntity.ok(result);
	    }
}
