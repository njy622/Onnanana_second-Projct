package com.human.onnana.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@RestController
public class WeatherController {

    private final String base_url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst";
    private final String serviceKey = "D:/WorkSpace/Onnanana_second-Projct/01.심민준/기상청/keys/기상청api.txt"; // 발급받은 기상청 API 키 입력

    @GetMapping("/getWeather")
    public Map<String, String> getWeather(@RequestParam int nx, @RequestParam int ny) {
        LocalDateTime now = LocalDateTime.now();
        String baseDate;
        String baseTime;

        if (now.getMinute() <= 40) {
            if (now.getHour() == 0) {
                baseDate = now.minusDays(1).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
                baseTime = "2300";
            } else {
                baseDate = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
                baseTime = now.minusHours(1).format(DateTimeFormatter.ofPattern("HH00"));
            }
        } else {
            baseDate = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            baseTime = now.format(DateTimeFormatter.ofPattern("HH00"));
        }

        Map<String, String> params = new HashMap<>();
        params.put("serviceKey", serviceKey);
        params.put("numOfRows", "30");
        params.put("pageNo", "1");
        params.put("dataType", "JSON");
        params.put("base_date", baseDate);
        params.put("base_time", baseTime);
        params.put("nx", String.valueOf(nx));
        params.put("ny", String.valueOf(ny));

        RestTemplate restTemplate = new RestTemplate();
        String apiUrl = base_url + "?";
        for (Map.Entry<String, String> entry : params.entrySet()) {
            apiUrl += entry.getKey() + "=" + entry.getValue() + "&";
        }

        // Remove the last "&" character
        apiUrl = apiUrl.substring(0, apiUrl.length() - 1);

        Map<String, String> results = restTemplate.getForObject(apiUrl, Map.class);

        // Process the results and convert to the desired format

        return results;
    }
}
