<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="../common/head.jspf" %>
     <style>
	   	#map-container {
	   		position: relative;
            display: inline-block;
            width: 800px;
	    }
     	#cartogram {
		    width: 100%; /* 이미지의 가로 크기를 부모 컨테이너에 맞추기 */
		    height: auto; /* 세로 크기는 자동으로 조절 */
		}
        
		#result {
			position: absolute;
            top: 10px;
            right: 10px;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #f4f4f4;
        }
		#result1 {
			position: absolute;
            top: 70px;
            right: 10px;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #f4f4f4;
        }
        
        .weather-button {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 12px 15px;
            background-color: transparent;
            color: #fff;
            
            cursor: pointer;
        }
    </style>
  
</head>
<body>
<%@ include file="../common/top.jspf" %>
<div class="container" style="margin-top:80px">
    <div class="row">
      
        <!-- ================ 내가 작성할 부분 =================== -->
        <div class="col-9">
            <h3 class="mt-3"><strong>기상 예보 띄우는창</strong></h3>
            <hr>
            <div class="container" id="map-container"">
	            <!-- 이미지 표시 -->
	    		<img id="cartogram" src="/onnana/img/카토그램.png" alt="Example Image">
	    		<!-- 각 버튼에는 고유한 id와 공통된 클래스를 할당합니다. -->
				<button id="인천옹진" class="weather-button" data-nx="54" data-ny="124" data-name="영흥" style="top: 398px;left: 126px;"> </button>
				<button id="태안" class="weather-button" data-nx="48" data-ny="109" data-name="원북면" style="top: 425px;left: 126px;"> </button>
				<button id="신안" class="weather-button" data-nx="48" data-ny="109" style="top: 695px;left: 126px;"> </button>
				<button id="목포" class="weather-button" data-nx="48" data-ny="109" style="top: 722px;left: 126px;"> </button>
				<button id="해남" class="weather-button" data-nx="48" data-ny="109" style="top: 749px;left: 126px;"> </button>
				<button id="진도" class="weather-button" data-nx="48" data-ny="109" style="top: 776px;left: 126px;"> </button>
				<button id="인천강화" class="weather-button" data-nx="48" data-ny="109" style="top: 263px;left: 160px;"> </button>
				<button id="인천서구" class="weather-button" data-nx="48" data-ny="109" style="top: 290px;left: 160px;"> </button>
				<button id="인천중구" class="weather-button" data-nx="48" data-ny="109" style="top: 371px;left: 160px;"> </button>
				<button id="인천연수" class="weather-button" data-nx="48" data-ny="109" style="top: 398px;left: 160px;"> </button>
				<button id="서산" class="weather-button" data-nx="48" data-ny="109" style="top: 425px;left: 160px;"> </button>
				<button id="홍성" class="weather-button" data-nx="48" data-ny="109" style="top: 452px;left: 160px;"> </button>
				<button id="보령" class="weather-button" data-nx="48" data-ny="109" style="top: 479px;left: 160px;"> </button>
				
				<!-- 나머지 버튼들도 동일한 방식으로 클래스와 데이터 속성을 설정합니다. -->
				
				<div id="result"></div>
				<div id="result1"></div>
				
				<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
				<script>
				    $(document).ready(function() {
				        $(".weather-button").click(function() {
				            // 클릭된 버튼의 nx, ny, name 값을 가져옵니다.
				            var nx = $(this).data("nx");
				            var ny = $(this).data("ny");
				            var name = $(this).data("name");
				
				            sendRequestWeather(nx, ny);
				            sendRequestAirQuality(name);
				        });
				    });
				
				    function sendRequestWeather(nx, ny) {
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
				
				    function sendRequestAirQuality(name) {
			            $.ajax({
			                type: "GET",
			                url: "http://localhost:5000/get_air_quality",
			                data: { name: name },
			                success: function(response) {
			                    var resultText = "일시: " + response['날짜'] + '\n' +
			                                     "미세먼지: "+ response['미세먼지(PM10) 농도'] + '\n' +
			                                     "초미세먼지: " + response['초미세먼지(PM2.5) 농도'] + '\n' +
			                                     "이산화질소: " + response['이산화질소 농도'] + '\n' +
			                                     "아황산가스: " + response['아황산가스 농도'] + '\n' +
			                                     "오존: " + response['오존 농도'] + '\n' +
			                                     "측정소명/측정망정보: " + response['이름'] + "/" + response['측정망 정보'];
			                    resultText = resultText.replace(/\n/g, '<br>');
			                    $("#result1").html(resultText);
			                },
			                error: function(error) {
			                    console.error("에러:", error);
			                }
			            });
			        }
				</script>


                
            </div>

        </div>

    </div>
</div>
<%@ include file="../common/bottom.jspf" %>
</body>
</html>