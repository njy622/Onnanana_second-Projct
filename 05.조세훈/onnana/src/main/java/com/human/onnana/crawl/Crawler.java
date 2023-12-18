package com.human.onnana.crawl;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

public class Crawler {

	public static final String WEB_DRIVER_ID = "webdriver.chrome.driver";
    public static final String WEB_DRIVER_PATH = "../chromedriver/chromedriver_win64/chromedriver.exe";
  

    public WebDriver initWebDriver() {
        try {
            System.setProperty(WEB_DRIVER_ID, WEB_DRIVER_PATH);
        } catch (Exception e) {
            e.printStackTrace();
        }

        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless");
        options.addArguments("--no-sandbox");
        options.addArguments("--single-process");
        options.addArguments("--disable-dev-shm-usage");

        return new ChromeDriver(options);
    }
    
    public WebDriver search(WebDriver driver){
    	//get()메소드에 url을 입력하면 해당 페이지로 이동한다.
    	driver.get("www.naver.com");
        // findElement()메소드로 원하는 요소를 찾는다.
        // By를 사용하여 선택자를 id,class,xPath등으로 정할 수 있다.
        WebElement inputQuery = driver.findElement(By.id("query"));
        //sendKeys()메소드를 사용하면 원하는 값을 해당 element에 입력할 수 있다.
        //검색, 로그인등에 활용한다.
        inputQuery.sendKeys("검색어");
        WebElement searchBtn = driver.findElement(By.id("search-btn"));
        //click()메소드를 사용하면 element를 클릭할 수 있다.
        searchBtn.click();
        return driver;
    }
    public String getData(WebDriver driver){
    	WebElement div = driver.findElement(By.className("link_tit"));
        String data = div.getText();
        return data;
    }
 }
