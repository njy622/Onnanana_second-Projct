package com.human.onnana.service;

import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Service
public class QuoteService {

    private final ResourceLoader resourceLoader;
    private List<String> quotes;

    public QuoteService(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    @PostConstruct
    public void init() {
        try {
            // ResourceLoader를 사용하여 리소스를 읽어옴
            Resource resource = resourceLoader.getResource("classpath:static/data/quotes.txt");
            InputStream inputStream = resource.getInputStream();

            // InputStream을 이용하여 명언을 읽어옴
            quotes = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))
                    .lines()
                    .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String getRandomQuote() {
        if (quotes == null || quotes.isEmpty()) {
            return "No quotes available.";
        }

        // 랜덤으로 명언 선택
        int randomIndex = new Random().nextInt(quotes.size());
        return quotes.get(randomIndex);
    }
}