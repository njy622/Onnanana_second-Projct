package com.human.onnana.utility;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.chrome.ChromeOptions;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

public class CrawlingExample {

    public static void main(String[] args) {
        // 크롬 드라이버 경로 설정
        System.setProperty("webdriver.chrome.driver", "C:/Users/defaultuser0/Desktop/chromedriver_win32/chromedriver.exe");

        // 크롬 드라이버 인스턴스 생성
        //WebDriver driver = new ChromeDriver();
        
        // ChromeOptions 생성
        ChromeOptions options = new ChromeOptions();
        // 헤드리스 모드 설정
        // options.addArguments("--headless");

        // 크롬 드라이버 인스턴스 생성시 ChromeOptions 전달
        ChromeDriver driver = new ChromeDriver(options);


        try {
            getDataList(driver); // driver를 getDataList 메서드에 전달
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        driver.close(); // 탭 닫기
        driver.quit(); // 브라우저 닫기
    }

    /**
     * data 가져오기
     */
    private static List<String> getDataList(WebDriver driver) throws InterruptedException {
        List<String> list = new ArrayList<>();

        driver.get("https://weather.kweather.co.kr/weather/life_weather"); // 브라우저에서 url로 이동한다.
        Thread.sleep(1000); // 브라우저 로딩될때까지 잠시 기다린다.

        // 대상 요소 찾기
        WebElement lifeWeatherTable = driver.findElement(By.className("life_weather_table"));
        System.out.println("lifeWeatherTable found: " + lifeWeatherTable);
        WebElement table = lifeWeatherTable.findElement(By.tagName("table"));
        System.out.println("table found: " + table);
        WebElement tbody = table.findElement(By.tagName("tbody"));
        System.out.println("tbody found: " + tbody);

        // WebDriverWait를 사용하여 tr 요소가 나타날 때까지 대기
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10)); // 최대 10초간 대기
        List<WebElement> trElements = wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.tagName("tr")));
        for (WebElement element : trElements) {
            System.out.println("----------------------------");
            System.out.println(element); // ⭐
        }

        return list;
    }
}
