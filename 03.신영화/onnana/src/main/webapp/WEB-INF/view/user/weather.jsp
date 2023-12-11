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
            position: relative; /* 이미지 위치 기준으로 버튼을 배치하기 위해 상대 위치 설정 */
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
            width: 35px; /* 버튼의 너비 설정 */
            height: 29px; /* 버튼의 높이 설정 */
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
	    		<!-- 각 버튼에는 고유한 id와 공통된 클래스를 할당합니다. -->
				<button id="인천옹진" class="weather-button" data-nx="54" data-ny="124" style="position: absolute;top: 398px;left: 113px;"> </button>
				<button id="태안" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 427px;left: 113px;"> </button>
				<button id="신안" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 709px;left: 113px;"> </button>
				<button id="목포" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 737px;left: 113px;"> </button>
				<button id="해남" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 766px;left: 113px;"> </button>
				<button id="진도" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 795px;left: 113px;"> </button>
				<button id="인천강화" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 259px;left: 149px;"> </button>
				<button id="인천서구" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 285px;left: 149px;"> </button>
				<button id="인천중구" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 371px;left: 149px;"> </button>
				<button id="인천연수" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 400px;left: 149px;"> </button>
				<button id="서산" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 429px;left: 149px;"> </button>
				<button id="홍성" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 458px;left: 149px;"> </button>
				<button id="보령" class="weather-button" data-nx="48" data-ny="109" style="position: absolute;top: 400px;left: 149px;"> </button>
				
				<!-- 나머지 버튼들도 동일한 방식으로 클래스와 데이터 속성을 설정합니다. -->
				
				<div id="result"></div>
				
				<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
				<script>
				$(document).ready(function() {
				    $(".weather-button").click(function() {
				        // 클릭된 버튼의 nx 및 ny 값을 가져옵니다.
				        var nx = $(this).data("nx");
				        var ny = $(this).data("ny");
				
				        sendRequest(nx, ny);
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