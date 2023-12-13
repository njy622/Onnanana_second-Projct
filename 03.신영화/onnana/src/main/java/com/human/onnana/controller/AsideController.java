package com.human.onnana.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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

    @ResponseBody
    @GetMapping("/getTodayQuote")
    public String getTodayQuote() {
        // QuoteUtility 클래스의 getTodayQuote 메서드 호출
        String quote = AsideUtil.getTodayQuote("static/data/tipsForBetterLife.txt");

        // 가져온 명언을 반환
        return quote;
    }
	

	// ★★ 웨더 ★★
	@ResponseBody				// for ajax
	@GetMapping("/weather")
	public String getWeather(@RequestParam(name="addr", defaultValue="경기도 수원시 장안구") String addr) {
		String place = addr + "청";
		String roadAddr = asideUtil.getRoadAddr(place);
		List<String> geoCode = asideUtil.getGeoCode(roadAddr);
		String result = asideUtil.getWeather(geoCode.get(0), geoCode.get(1));
		
		return result;
	}
}