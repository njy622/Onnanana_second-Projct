package com.human.onnana.controller;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/weather")
public class WeatherController {

    @GetMapping("/life")
    public String getLifeWeather() {
        try {
            // 대상 사이트의 URL
            String url = "https://weather.kweather.co.kr/weather/life_weather";

            // Jsoup을 사용하여 웹 페이지 가져오기
            Document doc = Jsoup.connect(url).get();

            // 필요한 데이터를 선택자를 사용하여 추출
            Elements lifeWeatherElements = doc.select("div.life_weather");

            // 추출한 데이터를 문자열로 반환 또는 다른 처리 수행
            return lifeWeatherElements.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error occurred while fetching data";
        }
    }
}
