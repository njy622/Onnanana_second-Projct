
package com.human.onnana.utility;

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;


@Service
public class AsideUtil {
   @Value("${roadAddrKey}") private String roadAddrKey;
   @Value("${kakaoApiKey}") private String kakaoApiKey;
   @Value("${openWeatherApiKey}") private String openWeatherApiKey;

   
   // ★★ 오늘의 명언 ★★
   public String getTodayQuote(String filename) {
      String result = null;
      try {
            // 파일 경로를 상대 경로로 설정
            String path = "src/main/resources/static/data/quotes.txt";
            File file = new File(path);

            BufferedReader br = new BufferedReader(new FileReader(file), 1024);
            int index = (int) Math.floor(Math.random() * 30);
            for (int i = 0; i <= index; i++) {
                result = br.readLine();
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
   
   public String squareImage(String profilePath, String fname) {
      String newFname = null;
      try {
         File file = new File(profilePath + fname);
         BufferedImage buffer = ImageIO.read(file);
         int width = buffer.getWidth();
         int height = buffer.getHeight();
         int size = width, x = 0, y = 0;
         if (width > height) {
            size = height;
            x = (width - size) / 2;
         } else if (width < height) {
            size = width;
            y = (height - size) / 2;
         }
         
         String now = LocalDateTime.now().toString().substring(0,22).replaceAll("[-T:.]", "");
         int idx = fname.lastIndexOf('.');
         String format = fname.substring(idx+1);
         newFname = now + fname.substring(idx);
         
         BufferedImage dest = new BufferedImage(size, size, BufferedImage.TYPE_INT_RGB);
         Graphics2D g = dest.createGraphics();
         g.setComposite(AlphaComposite.Src);
         g.drawImage(buffer, 0, 0, size, size, x, y, x + size, y + size, null);
         g.dispose();
         
         File dstFile = new File(profilePath + newFname);
         OutputStream os = new FileOutputStream(dstFile);
         ImageIO.write(dest, format, os);
         os.close();
         file.delete();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return newFname;
   }
   
   // 행안부 도로명주소 API
   public String getRoadAddr(String place) {
      String apiUrl = "https://www.juso.go.kr/addrlink/addrLinkApiJsonp.do";
      String roadAddr = null;
      try {
         String keyword = URLEncoder.encode(place, "utf-8");
         apiUrl += "?confmKey=" + roadAddrKey 
               + "&currentPage=1&countPerPage=10"
               + "&keyword=" + keyword + "&resultType=json";
         URL url = new URL(apiUrl);
         BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(), "utf-8"));
         
         String line = null, result = "";
         while ((line = br.readLine()) != null)
            result += line;
         br.close();
         
         JSONParser parser = new JSONParser();
         JSONObject obj = (JSONObject) parser.parse(result.substring(1, result.length()-1));
         JSONObject results = (JSONObject) obj.get("results");
         JSONArray juso = (JSONArray) results.get("juso");
         JSONObject jusoItem = (JSONObject) juso.get(0);
         roadAddr = (String) jusoItem.get("roadAddr");
      } catch (Exception e) {
         e.printStackTrace();
      }
      return roadAddr;
   }
   
   // 카카오 Local API - 위도, 경도

   public List<String> getGeoCode(String roadAddr) {
       List<String> list = new ArrayList<>();
       String apiUrl = "https://dapi.kakao.com/v2/local/search/address.json";
       try {
           String keyword = URLEncoder.encode(roadAddr, "utf-8");
           apiUrl += "?query=" + keyword;
           URL url = new URL(apiUrl);
           // 헤더 설정
           HttpURLConnection conn = (HttpURLConnection) url.openConnection();
           conn.setRequestProperty("Authorization", "KakaoAK " + kakaoApiKey);
           conn.setDoInput(true);

           // 응답 결과 확인
           int responseCode = conn.getResponseCode();

           // 데이터 수신
           BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
           String line = null, result = "";
           while ((line = br.readLine()) != null)
               result += line;
           br.close();

           
        // Kakao API 호출 후 응답 데이터 확인
           System.out.println("Kakao API Response: " + result);

           JSONParser parser = new JSONParser();
           Object obj = parser.parse(result);

           if (obj instanceof JSONObject) {
               JSONObject jsonObject = (JSONObject) obj;
               // "documents"가 JSONArray일 경우도 고려
               JSONArray documents = (JSONArray) jsonObject.get("documents");
               if (documents != null && !documents.isEmpty()) {
                   JSONObject localItem = (JSONObject) documents.get(0);
                   list.add((String) localItem.get("x"));   // 경도
                   list.add((String) localItem.get("y"));   // 위도
               } else {
                   // documents가 null이거나 비어있는 경우 처리
                   System.out.println("Kakao API Response: documents is null or empty");
               }
           } else {
               // obj가 JSONObject가 아닌 경우 처리
               System.out.println("Kakao API Response: obj is not an instance of JSONObject");
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
       return list;
   }


   
   public String getAddressFromCoordinates(Double latitude, Double longitude) {
       String address = null;
       try {
           // Reverse Geocoding API 호출을 위한 URL 생성
           String apiUrl = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=" + longitude + "&y=" + latitude;
           URL url = new URL(apiUrl);
           HttpURLConnection conn = (HttpURLConnection) url.openConnection();
           conn.setRequestProperty("Authorization", "KakaoAK " + kakaoApiKey);
           conn.setDoInput(true);

           // 응답 결과 확인
           int responseCode = conn.getResponseCode();
           if (responseCode == HttpURLConnection.HTTP_OK) {
               BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
               String line = null, result = "";
               while ((line = br.readLine()) != null)
                   result += line;
               br.close();

            // JSON 파싱 수정
               JSONParser parser = new JSONParser();
               Object obj = parser.parse(result);

               if (obj instanceof JSONObject) {
                   JSONObject jsonObject = (JSONObject) obj;
                   Object documents = jsonObject.get("documents");

                   if (documents instanceof JSONArray) {
                       JSONArray documentsArray = (JSONArray) documents;
                       if (!documentsArray.isEmpty()) {
                           JSONObject firstDocument = (JSONObject) documentsArray.get(0);
                           JSONObject addressObject = (JSONObject) firstDocument.get("address");
                           address = (String) addressObject.get("region_2depth_name");
                       }
                   } else if (documents instanceof JSONObject) {
                       JSONObject addressInfo = (JSONObject) documents;
                       JSONObject addressObject = (JSONObject) addressInfo.get("address");
                       address = (String) addressObject.get("region_2depth_name");
                   }

               }

           }
       } catch (IOException | ParseException e) {
           System.err.println("Error during JSON parsing: " + e.getMessage());
           e.printStackTrace();
       }
       return address;
   }


   
   
   // ★★★ OpenWeather API ★★
   public String getWeather(String lon, String lat) {
      String apiUrl = "https://api.openweathermap.org/data/2.5/weather";
      apiUrl += "?lat=37.5207569&lon=126.9003409&appid=7bf73c254c8083bf83a5f9b40a7146bf&units=metric";
   
      String weatherStr = null;
      try {
         URL url = new URL(apiUrl);
         BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(), "utf-8"));
         
         String line = null, result = "";
         while ((line = br.readLine()) != null)
            result += line;
         br.close();
         
         JSONParser parser = new JSONParser();
         JSONObject obj = (JSONObject) parser.parse(result);
         JSONArray weather = (JSONArray) obj.get("weather");
         JSONObject weatherItem = (JSONObject) weather.get(0);
         String desc = (String) weatherItem.get("description");
         String iconCode = (String) weatherItem.get("icon");
         JSONObject main = (JSONObject) obj.get("main");
         double temp = (Double) main.get("temp");
         String tempStr = String.format("%.1f", temp);
         String iconUrl = "http://api.openweathermap.org/img/w/" + iconCode + ".png";
         weatherStr = "<img src=\"" + iconUrl + "\" height=\"28\">" + desc + ","
               + " 온도: " + tempStr + "&#8451";
      } catch (Exception e) {
         e.printStackTrace();
      }
      return weatherStr;
   }
   
}
