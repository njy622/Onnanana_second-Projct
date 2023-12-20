/**
 * calcu.js
 * 		탄소거리계산기를 구현한 코드
 */


/* ================== 현재위치 경도 위도 구하는 코드 ===================== */
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
 // document.getElementById("demo").innerHTML = "현재 위치 위도:" + hereLat + ", 경도:" + hereLon;
}

getLocation();



/* ================== 현재위치에서부터 도착지까지의 거리계산 및 탄소계산 ===================== */

function searchAndCalculateDistance() {
  var address = document.getElementById('place').value;					
  var query = encodeURIComponent(address);

  var baseUrl = "https://dapi.kakao.com/v2/local/search/address.json";
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
          
          var carbonEmissionText = "※ 탄소배출량(승용차/휘발유 기준) : " + distancekg + 'kg';
          resultDiv.innerHTML = carbonEmissionText
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





//거리환산+ 담배환산 값을 제목에 넣는 함수
function readJs() {
	//거리 환산해서 탄소배출량 출력
    let carbonEmission = parseFloat((document.getElementById('result').innerText).match(/\d+/)[0]);

  //담배 갯수 선택한 값에 * 14g 연산 후  kg으로 출력
    let smokeCarbon = parseInt($('#smoke').val()) * 14 / 1000;
	
  	
    let totalCarbon = carbonEmission - smokeCarbon;
    document.getElementById('showResult').innerText = totalCarbon.toFixed(2);

    // 입력값이 변경될 때마다 제목에 결과값 추가
    let titleElement = document.getElementById('title');
    let currentTitle = titleElement.value;
    titleElement.value = currentTitle.split('-')[0].trim() + '- ' + totalCarbon.toFixed(2) + 'kg 감소';
}


/* ================================= 경유지까지의 거리계산 및 탄소계산 ======================================== */
function stopoverCalculateDistance() {
    var headers = {
        'Authorization': 'KakaoAK db8c17d6893ffe5d073cd03b8bfe32b5'
    };

    var startQuery = encodeURIComponent(document.getElementById('startPlace').value);
    var endQuery = encodeURIComponent(document.getElementById('endPlace').value);
    
    var wayCount = 0;
    var startUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + startQuery;
    var endUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + endQuery;

    console.log(startQuery);
    console.log(endQuery);

    $.ajax({
        url: startUrl,
        headers: headers,
        success: function (startResult) {
            var startLat = startResult.documents[0].x;
            var startLon = startResult.documents[0].y;

            console.log(startLat);
            console.log(startLon);

            $.ajax({
                url: endUrl,
                headers: headers,
                success: function (endResult) {
                    var endLat = endResult.documents[0].x;
                    var endLon = endResult.documents[0].y;

                    console.log(endLat);
                    console.log(endLon);

                    var waypoints = '';
                    var totalWaypoints = document.querySelectorAll('.waypointField').length / 2;
                    var completedRequests = 0;
                    
                    console.log(totalWaypoints);
                    

                    // 각 경유지의 좌표를 가져오는 함수
                    function getWaypointCoordinates(index) {
                        var currentWaypoint = document.getElementById('waypoint' + index).value;
                        var currentWaypointQuery = encodeURIComponent(currentWaypoint);
                        var currentWaypointUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + currentWaypointQuery;

                        $.ajax({
                            url: currentWaypointUrl,
                            headers: headers,
                            success: function (waypointResult) {
                                var waypointLat = waypointResult.documents[0].x;
                                var waypointLon = waypointResult.documents[0].y;

                                console.log('경유지 ' + index + ' 좌표 - 위도: ' + waypointLat + ', 경도: ' + waypointLon);

                                waypoints += waypointLat + ',' + waypointLon + '|';

                                // 모든 경유지 좌표를 가져온 후에 거리 계산 함수 호출
                                completedRequests++;
                                if (completedRequests === totalWaypoints) {
                                    calculateDistanceWithWaypoints(startLat, startLon, endLat, endLon, waypoints);
                                }
                            },
                            error: function (error) {
                                console.log('에러 발생:', error);
                            }
                        });
                    }

                    // 각 경유지의 좌표를 가져오기 위한 반복문
                    for (var index = 0; index < totalWaypoints; index++) {
                        getWaypointCoordinates(index);
                    }
                }
            });
        }
    });
}

function calculateDistanceWithWaypoints(startLat, startLon, endLat, endLon, waypoints) {
    var waypointCoords = waypoints.split('|');
    var totalWaypoints = waypointCoords.length;
    var headers = {
        'Authorization': 'KakaoAK db8c17d6893ffe5d073cd03b8bfe32b5'
    };
    var baseUrl = "https://apis-navi.kakaomobility.com/v1/directions";
    var start = 'origin=' + startLat + ',' + startLon;
    var goal = '&destination=' + endLat + ',' + endLon;
  
    // 결과를 표시할 div를 가져옵니다.
    var resultDiv = document.getElementById("stopoverResult");
  
    // 각 경유지별로 거리를 계산하는 반복문
    for (var countway = 0; countway < totalWaypoints; countway++) {
        var waypoint = "&waypoints=" + waypointCoords[countway] + countway;
        var optionurl = "&priority=DISTANCE&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false";
        var distanceUrl = baseUrl + start + goal + waypoint + optionurl;

        $.ajax({
            url: distanceUrl,
            headers: headers,
            success: function (distanceResult) {
                var distance = parseInt(distanceResult.routes[0].summary.distance, 10);
                var distancekg = parseInt(distance * 130.736 / 1000 / 1000, 10);
                var carbonEmissionText = "※ 탄소배출량(승용차/휘발유 기준) : " + distancekg + 'kg';

                // 결과를 결과 div에 추가합니다.
                resultDiv.innerHTML += '<br>' + carbonEmissionText;
            },
            error: function (error) {
                console.log('에러 발생:', error);
            }
        });
    }
}









function searchAndCalculateDistance2() {

  var address = document.getElementById('place2').value;					
  var query = encodeURIComponent(address);

  var baseUrl = "https://dapi.kakao.com/v2/local/search/address.json";
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
      var resultDiv = document.getElementById("result2");

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
          
          var carbonEmissionText = "※ 탄소배출량(승용차/휘발유 기준) : " + distancekg + 'kg';
          resultDiv.innerHTML = carbonEmissionText
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




//거리환산+ 담배환산 값을 제목에 넣는 함수
function readJs2() {

	//거리 환산해서 탄소배출량 출력
    let carbonEmission = parseFloat((document.getElementById('result2').innerText).match(/\d+/)[0]);

  //담배 갯수 선택한 값에 * 14g 연산 후  kg으로 출력
    let smokeCarbon = parseInt($('#smoke2').val()) * 14 / 1000;
	
  	
    let totalCarbon = carbonEmission - smokeCarbon;
    document.getElementById('showResult2').innerText = totalCarbon.toFixed(2);

    // 입력값이 변경될 때마다 제목에 결과값 추가
    let titleElement = document.getElementById('title2');
    let currentTitle = titleElement.value;
    titleElement.value = currentTitle.split('-')[0].trim() + '- ' + totalCarbon.toFixed(2) + 'kg 감소';
}



