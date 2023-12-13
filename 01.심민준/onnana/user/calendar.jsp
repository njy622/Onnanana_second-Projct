<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jspf" %>
    <style>
        th { text-align: center; width: 14.28%;}
    </style>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 라이브러리 -->
<script>
var hereLat, hereLon;

function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  } else {
    document.getElementById("demo").innerHTML = "Geolocation is not supported by this browser.";
  }
}

function showPosition(position) {
  hereLat = position.coords.longitude;
  hereLon = position.coords.latitude;
  document.getElementById("demo").innerHTML = "현재 위치 위도:" + hereLat + ", 경도:" + hereLon;
}

getLocation();

function searchAndCalculateDistance() {
  var address = document.getElementById('address').value;
  var baseUrl = "https://dapi.kakao.com/v2/local/search/address.json";
  var query = encodeURIComponent(address);
  var url = baseUrl + "?query=" + query;

  var headers = {
    'Authorization': 'KakaoAK db8c17d6893ffe5d073cd03b8bfe32b5'
  };

  $.ajax({
    url: url,
    headers: headers,
    success: function (result) {
      var latitude = result.documents[0].x;
      var longitude = result.documents[0].y;
      var resultDiv = document.getElementById("result");

      resultDiv.innerHTML = '검색된 위치 위도:' + latitude + ', 경도:' + longitude;

      var startLat = hereLat;
      var startLon = hereLon;
      var goalLat = latitude;
      var goalLon = longitude;

      var baseUrl = "https://apis-navi.kakaomobility.com/v1/directions?";
      var start = 'origin=' + startLat + ',' + startLon;
      var goal = '&destination=' + goalLat + ',' + goalLon;
      var waypoint = "&waypoints=&priority=DISTANCE&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false";

      var distanceUrl = baseUrl + start + goal + waypoint;

      $.ajax({
        url: distanceUrl,
        headers: headers,
        success: function (distanceResult) {
          var distance = distanceResult.routes[0].summary.distance;
          resultDiv.innerHTML += '<br>거리: ' + distance + 'm';
        },
        error: function (error) {
          console.log('에러 발생:', error);
        }
      });
    },
    error: function (error) {
      console.log('에러 발생:', error);
    }
  });
}
</script>
	
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	<div class="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="../common/aside.jspf" %> 
			 <!-- =================== main =================== -->
            <div class="col-sm-9 mt-3">
				<p id="demo"></p> <!-- 현재 위치를 표시할 요소 -->
				<input type="text" id="address" placeholder="검색할 주소를 입력하세요"> <!-- 검색할 주소를 입력할 input 요소 -->
				<button onclick="searchAndCalculateDistance()">거리 계산</button> <!-- 거리 계산을 시작하는 버튼 -->
				<p id="result"></p> <!-- 검색된 위치의 좌표와 거리를 표시할 요소 -->


				
            </div>
            <!-- =================== main =================== -->
		</div>
	</div>
	<%@ include file="../common/bottom.jspf" %>
</body>
</html>