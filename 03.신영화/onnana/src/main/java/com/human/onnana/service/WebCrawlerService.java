package com.human.onnana.service;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class WebCrawlerService {

    public void crawlWebsite(String url) {
        try {
            Document doc = Jsoup.connect(url).get();
            Elements links = doc.select("a[href]");

            for (Element link : links) {
                System.out.println("Link: " + link.attr("href"));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
