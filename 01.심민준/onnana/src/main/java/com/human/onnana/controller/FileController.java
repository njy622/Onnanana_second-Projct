package com.human.onnana.controller;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

public class FileController {

    public static void main(String[] args) {
        RestTemplate restTemplate = new RestTemplate();

        // Flask 애플리케이션의 이미지 URL
        String imageUrl = "http://localhost:5000/static/img/카토그램.png";

        // 이미지 다운로드
        ResponseEntity<ByteArrayResource> response = restTemplate.getForEntity(imageUrl, ByteArrayResource.class);

        // 이미지를 ByteArray로 얻어옴
        byte[] imageBytes = response.getBody().getByteArray();

        // imageBytes를 콘솔에 출력
        System.out.println("Image Bytes: " + imageBytes);

    }
}
