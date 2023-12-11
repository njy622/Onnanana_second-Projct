<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="../common/head.jspf" %>
     <style>
        #cartogram {
            width: 100%;
            cursor: pointer;
            position: relative;
        }
        
		#result {
			position: absolute;
            top: 10px;
            right: 10px;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #f4f4f4;
        }
        .weather-button {
            background-color: transparent;
            cursor: pointer;
            width: 35px;
            height: 29px;
        }
    </style>
</head>
<body>
<%@ include file="../common/top.jspf" %>
<div class="container" style="margin-top:80px">
    <div class="row">
        <%@ include file="../common/aside.jspf" %>
        <!-- 내가 작성할 부분 -->
        <div class="col-9">
            <h3 class="mt-3"><strong>기상 예보 띄우는창</strong></h3>
            <hr>
            <div class="container" id="map" style="height: 500px; position: relative;">
                <!-- 이미지 표시 -->
                <img id="cartogram" src="/onnana/img/카토그램.png" alt="Example Image">
                <!-- CSV 파일에서 버튼 데이터 읽어오기 -->
                <%@ page import="java.io.BufferedReader"%>
                <%@ page import="java.io.FileReader"%>
                <%@ page import="java.util.StringTokenizer"%>
                
                <%
                    String csvFilePath = "/static/data/위도경도_최종.csv"; // 실제 CSV 파일 경로로 변경
                    BufferedReader br = new BufferedReader(new FileReader(csvFilePath));
                    String line;
                
                    while ((line = br.readLine()) != null) {
                        StringTokenizer st = new StringTokenizer(line, ",");
                        String id = st.nextToken();
                        String nx = st.nextToken();
                        String ny = st.nextToken();
                %>
                        <!-- 동적으로 생성된 버튼 -->
                        <button id="<%=id%>" class="weather-button" data-nx="<%=nx%>" data-ny="<%=ny%>" style="position: absolute; top:300px; left: 420px"></button>
                <%
                    }
                    br.close();
                %>
                <div id="result"></div>
                
                <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
                <script>
				    $(document).ready(function() {
				        $(".weather-button").click(function() {
				            // 클릭된 버튼의 nx 및 ny 값을 가져옵니다.
				            var nx = $(this).data("nx");
				            var ny = $(this).data("ny");
				
				            // Flask API에 요청을 보냅니다.
				            sendRequest(nx, ny);
				        });
				
				        function sendRequest(nx, ny) {
				            $.ajax({
				                type: "GET",
				                url: "http://localhost:5000/get_weather",
				                data: { nx: nx, ny: ny },
				                success: function(response) {
				                    // 받은 JSON 데이터의 특정 속성을 선택하여 출력
				                    var resultText = "기온: " + response['기온'] + ", 습도: " + response['습도'] + ", 강수량: " + response['1시간 강수량'] + ", 풍향: " + response['풍향'] + ", 풍속: " + response['풍속'];
				                    $("#result").text(resultText);
				                },
				                error: function(error) {
				                    console.error("에러:", error);
				                }
				            });
				        }
				    });
				</script>
            </div>
        </div>
    </div>
</div>
<%@ include file="../common/bottom.jspf" %>
</body>
</html>
