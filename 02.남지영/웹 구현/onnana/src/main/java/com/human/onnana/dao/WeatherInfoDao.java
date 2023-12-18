// com.human.onnana.dao 패키지에 위치
package com.human.onnana.dao;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.human.onnana.entity.WeatherInfo;

import org.springframework.stereotype.Repository;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Repository
public class WeatherInfoDao {

    private final String jsonFilePath = "classpath:static/js/kweather.json"; // JSON 파일 경로를 지정

    public List<WeatherInfo> getWeatherInfoList() {
        ObjectMapper objectMapper = new ObjectMapper();
        List<WeatherInfo> weatherInfoList = null;

        try {
            weatherInfoList = objectMapper.readValue(new File(jsonFilePath), new TypeReference<List<WeatherInfo>>() {});
        } catch (IOException e) {
            e.printStackTrace();
            // 예외 처리를 여기에 추가
        }

        return weatherInfoList;
    }
}
