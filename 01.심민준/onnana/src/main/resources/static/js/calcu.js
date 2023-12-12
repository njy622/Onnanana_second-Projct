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
  var address = document.getElementById('place').value;
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
          var distance = parseInt(distanceResult.routes[0].summary.distance, 10);
          var distancekg = parseInt(distance*130.736/1000/1000, 10);
          //resultDiv.innerHTML += '\n거리: ' +  distance/1000 + 'km / 탄소배출량 : ' + distancekg + 'kg';
          resultDiv.innerHTML = "대중교통 탄소배출량 : " + distancekg + 'kg'; // 탄소배출량만 표기
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
