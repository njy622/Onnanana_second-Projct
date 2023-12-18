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
            position: absolute; /* 버튼의 위치를 상대 위치로 설정 */
        }
    </style>
  
</head>
<body>
<%@ include file="../common/top.jspf" %>
<div class="container" style="margin-top:80px">
    <div class="row">
        <%@ include file="../common/aside.jspf" %>
        <!-- ================ 내가 작성할 부분 =================== -->
        <div class="col-9">
            <h3 class="mt-3"><strong>기상 예보 띄우는창</strong></h3>
            <hr>
            <div class="container" id="map" style="height: 500px; position: relative;">
	            <!-- 이미지 표시 -->
	    		<img id="cartogram" src="/onnana/img/카토그램.png" alt="Example Image">
	    		
				<div id="result"></div>
				
				<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
				<script>
				$(document).ready(function() {
				    // CSV 파일에서 버튼의 위치 정보를 읽어와서 동적으로 생성
				    $.ajax({
                        type: "GET",
                        url: "/onnana/data/위도경도_최종.csv",  // CSV 파일 경로에 맞게 수정
                        dataType: "text",
                        success: function(data) {
                            var lines = data.split("\n");
                            for (var i = 1; i < lines.length; i++) {
                                var cols = lines[i].split(",");
                                var id = cols[0] ? cols[0].trim() : "";
                                var nx = cols[1] ? parseInt(cols[1].trim()) : 0;
                                var ny = cols[2] ? parseInt(cols[2].trim()) : 0;

                                
                                // 각 버튼에는 고유한 id와 공통된 클래스를 할당합니다.
                                var button = $("<button>", {
                                    id: id,
                                    class: "weather-button",
                                    "data-nx": nx,
                                    "data-ny": ny,
                                    css: {
                                        top: ny + "px",
                                        left: nx + "px"
                                    }
                                });
                                $("#cartogram").append(button);
                            }
                            
                            // 클릭 이벤트 핸들러 등록
                            $(".weather-button").click(function() {
                                var nx = $(this).data("nx");
                                var ny = $(this).data("ny");
                                sendRequest(nx, ny);
                            });
                        }
                    });

                    function sendRequest(nx, ny) {
                        $.ajax({
                            type: "GET",
                            url: "http://localhost:5000/get_weather",  // 플라스크 서버 주소로 업데이트하세요
                            data: { nx: nx, ny: ny },
                            success: function(response) {
                                // 받은 JSON 데이터의 특정 속성을 선택하여 출력
                                var resultText = "기온: " + response['기온'] + ", 습도: " + response['습도'] +  ", 강수량: " + response['1시간 강수량'] + ", 풍향: " + response['풍향'] + ", 풍속: " + response['풍속'];
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
