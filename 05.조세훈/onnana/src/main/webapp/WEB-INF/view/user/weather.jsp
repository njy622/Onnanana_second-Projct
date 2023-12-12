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

        .transparent-button {
            background-color: transparent;
            position: absolute;
            cursor: pointer;
            border: none;
            padding: 0;
        }
    </style>
    <script>
		function getAirQuality() {
	        var stationName = $("#stationName").val();
	        var base_url = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty";
	        var service_key = "nBg+Hwr/AcIl8mQ6pviMUSuy9Te5CDEJKfw5CIJn6tTDevZ5u3SL7vCng8+lzQcmLlJ7o6Eqy91xpF+4UMQzGA==";
	
	        var params = {
	            'serviceKey': service_key,
	            'returnType': 'JSON',
	            'numOfRows': 1,
	            'pageNo': 1,
	            'stationName': stationName,
	            'dataTerm': 'DAILY',
	            'ver': "1.4"
	        };
			console.log("getAirQuality()");
			$.ajax({
			    type: "post",
			    url: '/onnana/user/weather',
			    data: {stationName: stationName},
			    success: function(result) {
			    	let obj = JSON.parse(result);
			        //displayAirQuality(response);
			        console.log(obj);
			    },
			    error: function(xhr, status, error) {
			        console.error('데이터를 가져오는 중 문제가 발생했습니다:', error);
			    }
			});
		}

		function displayAirQuality(data) {
		    var airQualityInfo = document.getElementById("airQualityInfo");
		    var items = data.response.body.items[0];
		    console.log(items);
		
		    
		    $('#dataTime').html(items.dataTime);
		    $('#stationName').html(items.stationName);
		    $('#mangName').html(items.mangName);
		    $('#so2Value').html(items.so2Value);
		    $('#coValue').html(items.coValue);
		    $('#o3Value').html(items.o3Value);
		    $('#no2Value').html(items.no2Value);
		    $('#pm10Value').html(items.pm10Value);
		    $('#pm25Value').html(items.pm25Value);
		    $('#date').html(items.dataTime);
		}    
	</script>
</head>
<body>
<%@ include file="../common/top.jspf" %>
<div class="container" style="margin-top:80px">
    <div class="row">
        <%@ include file="../common/aside.jspf" %>
        <!-- ================ 내가 작성할 부분 =================== -->
        <div class="col-sm-9 mt-3 ms-1">
       		<title>대기 품질 정보 조회</title>
			<form action="/onnana/user/weather" method="post">
		    <input type="text" id="stationName" placeholder="측정소명 입력">
		    <button type="submit">데이터 가져오기</button>
		    </form>
		        <p>날짜: <span id='dataTime'></span></p>
                <p>측정소 이름: <span id='stationName'></span></p>
                <p>측정망 정보: <span id='mangName'></span></p>
                <p>아황산가스 농도: <span id='so2Value'></span>ppm</p>
                <p>일산화탄소 농도: <span id='coValue'></span>ppm</p>
                <p>오존 농도: <span id='o3Value'></span>ppm</p>
                <p>이산화질소 농도: <span id='no2Value'></span>ppm</p>
                <p>미세먼지(PM10) 농도: <span id='pm10Value'></span> ug/m³</p>
                <p>초미세먼지(PM2.5) 농도: <span id='pm25Value'></span> ug/m³</p>
		    </div>
		    
		    
		    
		
		    
    </div> 
</div>
<%@ include file="../common/bottom.jspf" %>
</body>
</html>