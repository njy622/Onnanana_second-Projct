package com.human.onnana.entity;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class CrawlerExample {
    public static void main(String[] args) throws Exception {
        // 웹 페이지의 URL
        String url = "https://weather.kweather.co.kr/weather/life_weather";

        // User-Agent 설정
        String userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36";

        // URL 객체 생성
        URL obj = new URL(url);

        // HttpURLConnection 객체 생성
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();

        // 요청 방식 설정 (GET, POST 등)
        con.setRequestMethod("GET");

        // User-Agent 헤더 설정
        con.setRequestProperty("User-Agent", userAgent);

        // HTTP 응답 코드 가져오기
        int responseCode = con.getResponseCode();
        System.out.println("HTTP 응답 코드: " + responseCode);

        // HTTP 응답 내용 읽어오기
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        // HTTP 응답 내용 출력
        System.out.println("HTTP 응답 내용: " + response.toString());
    }
}
