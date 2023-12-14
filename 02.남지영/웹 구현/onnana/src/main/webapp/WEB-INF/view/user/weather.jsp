<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
		    z-index: -1;
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
        
        .weather-info {
	   		position: absolute;
		    margin-left: 50px; /* 왼쪽 여백 설정 */
		    padding: 10px;
		    text-align: center; 
		    font-size: 20px;
		}
		
		.weather-info2 {
	   		position: absolute;
		    margin-left: 50px; /* 왼쪽 여백 설정 */
		    text-align: left; 
		    font-size: 14px;
		    
		}
		
		
		th {
			width: 500px;
			height: 100px;
			text-align: center;
		}
		
		td {
			text-align: center;
		}
		
		 .table-cell {
	        position: relative; /* 포지션 설정 */
	        width: 100px; /* 원하는 셀 너비로 설정 */
	        height: 100px; /* 원하는 셀 높이로 설정 */
	        z-index: 1;
	    }
	
	    .table-cell::before {
	        content: ""; /* 가상 요소 생성 */
	        position: absolute; /* 절대 위치 설정 */
	        top: 10px;
	        left: 20px;
	        right: 0;
	        bottom: 25px;
	        width: 80px; 
	        height: 80px; 
	        background-image: url('/onnana/img/backimg.png'); /* 배경 이미지 설정 */
	        background-size: cover; /* 이미지 크기 조절 */
	        z-index: -1; /* 이미지를 텍스트 뒤로 보냄 */
	    }
	
	    .text {
	        position: relative; /* 포지션 설정 */
	        z-index: 1; /* 텍스트를 이미지 위로 올림 */
	    }
	    /* 부모 요소인 h4에 display: inline-block 설정 */
	    h4 {
	        display: inline-block;
	    }
	
	    /* 클릭한 버튼 ID 요소를 inline-block으로 설정하여 한 줄에 표시 */
	    #clickedButtonId {
	        display: inline-block;
	    }	
		
    </style>
  	<script>
  	document.addEventListener('DOMContentLoaded', function() {
  	    const buttons = document.querySelectorAll('.weather-button');
  	    const displayId = document.getElementById('clickedButtonId');

  	    buttons.forEach(button => {
  	        button.addEventListener('click', function(event) {
  	            const clickedButtonId = this.id;
				document.querySelector("span").innerHTML = "(" + clickedButtonId + ")";
  	            // HTML 화면에 출력
  	        });
  	    });
  	});
    
  	</script>
</head>
<body>
<%@ include file="../common/top.jspf" %>
<div class="container" style="margin-top:80px">
    <div class="row">
      
        <!-- ================ 내가 작성할 부분 =================== -->
        <div class="col-md-6">
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
				
				<!-- <div id="result"></div>
				<div id="result1"></div> -->
				
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
				                var tableContent = '<table style="width:600px;">';
				                tableContent += '<tr>';
				                tableContent += '<th colspan="3"><h1><i class="fa-solid fa-temperature-low"></i>&nbsp;' + response['기온'] + '</h1></th>';
				                tableContent += '</tr>';
				                tableContent += '<tr><td><i class="fa-solid fa-droplet" style="color:DodgerBlue;"></i>&nbsp; 습도 </td><td>' 
				                				+ '<i class="fa-solid fa-cloud-showers-heavy" style="color:DodgerBlue;"></i>&nbsp; 강수량 </td><td>'
				                				+ '<i class="fa-solid fa-wind"style="color:DodgerBlue;"></i>&nbsp; 바람 </td></tr>';
				                tableContent += '<tr><td>' + response['습도']  + '</td><td>' + response['1시간 강수량'] + '</td><td>' + response['풍향'] + ' , ' + response['풍속'] + '</td></tr>';
				                tableContent += '</table>';

				                $("#result").html(tableContent);
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
			                    var tableContent2 = '<table style="margin-top:200px; width:600px;">';
			                    	tableContent2 += '<tr>';
			                    	tableContent2 += '<th class="table-cell">' + response['미세먼지(PM10) 농도'] + '<small class="unit">㎍/m³</small></th>' +
								                        '<th class="table-cell">' + response['초미세먼지(PM2.5) 농도'] + '<small class="unit">㎍/m³</small></th>' +
								                        '<th class="table-cell">' + response['이산화질소 농도'] + '<small class="unit">ppm</small></th>' +
								                        '<th class="table-cell">' + response['아황산가스 농도'] + '<small class="unit">ppm</small></th>' +
								                        '<th class="table-cell">' + response['오존 농도'] + '<small class="unit">ppm</small></th>';
			                    	tableContent2 += '</tr>';
			                    	tableContent2 += '<tr>';
			                    	tableContent2 += '<td>'+ '미세먼지<small class="unit">(PM10)</small>' +'</td>' + '<td>'+ '초미세먼지<small class="unit">(PM2.5)</small>' +'</td>' 
			                    					+ '<td>'+ '이산화질소' +'</td>' + '<td>'+ '아황산가스' +'</td>' + '<td>'+ '오존' +'</td>';
			                    	tableContent2 += '</tr>';
			                    	tableContent2 += '<tr>';
			                    	tableContent2 += '<td colspan="5" style="text-align:right;margin-top:100px;">'+ '측정소명(측정망정보): ' + response['이름'] + '(' + response['측정망 정보'] + ')&nbsp;&nbsp;&nbsp;&nbsp;' + "기준일시: " + response['날짜'] + '</td>'; 
			                    	tableContent2 += '</tr>';
			                    	tableContent2 += '<tr>';
			                    	tableContent2 += '<td colspan="5" style="text-align:right;">정보출처: 대기질정보(한국환경공단), 기상정보(기상청)</td>'; 
			                    	tableContent2 += '</tr>';
			                    	
			                                     
			                                   
                                $("#result1").html(tableContent2);
			                },
			                error: function(error) {
			                    console.error("에러:", error);
			                }
			            });
			        }
				</script>


                
            </div>

        </div>
       <div class="col-6 mt-3">
		    <div style="text-align:center;">
	        	<h4 style="color:DodgerBlue;"><i class="fa-solid fa-cloud-sun"></i>&nbsp;오늘의 기상정보&nbsp;&nbsp;&nbsp;</h4>
		        <!-- 클릭한 버튼의 ID를 출력하는 부분 -->
				<span id="clickedButtonId"></span>
		        <hr style="margin-bottom:-10px;">
		    </div>
		    <div class="d-flex justify-content-start" style="border: none;">
		        <div id="result" class="weather-info">
		            <!-- sendRequestWeather 함수가 호출되면 자동으로 결과가 표시됩니다. -->
		        </div>
		    </div>
		    <div class="d-flex justify-content-start" style="border: none;">
		        <div id="result1" class="weather-info2">
		            <!-- sendRequestWeather 함수가 호출되면 자동으로 결과가 표시됩니다. -->
		        </div>
		    </div>
		</div>

	</div>

</div>


<%@ include file="../common/bottom.jspf" %>
</body>
</html>