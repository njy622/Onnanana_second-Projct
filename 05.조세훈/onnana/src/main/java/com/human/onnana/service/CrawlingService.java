package com.human.onnana.service;

import org.openqa.selenium.WebDriver;
import org.springframework.beans.factory.annotation.Autowired;

import com.human.onnana.crawl.Crawler;

public interface CrawlingService {
	@Autowired
	private Crawler crawler;

	public String Crawling() {
        String url = "https://pp.kepco.co.kr/";
        log.info("kepcoId = {}, password = {}", kepcoId, password);
        WebDriver driver = crawler.initWebDriver();
        driver = crawler.search(driver);
        data = crawler.getData(driver);
        System.out.print(data);
        //가상의 크롬창을 닫는다.
        driver.close();
        //종료한다.
        driver.quit();
    }
}
