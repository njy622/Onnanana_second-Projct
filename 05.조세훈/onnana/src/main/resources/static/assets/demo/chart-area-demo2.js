// 부트스트랩의 기본 스타일링과 비슷하도록 기본 글꼴 패밀리와 글자 색상 설정
Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#292b2c';

// Area Chart Example

// 차트를 표시할 캔버스 요소 가져오기
var ctx2 = document.getElementById("myAreaChart2");

var month;



// 월별 일 수를 반환하는 함수
function getDaysInMonth2(month) {
    // 1월부터 12월까지의 일 수를 객체에 저장합니다. 각 월별로 일 수가 다르므로 이를 참조합니다.
    const daysInMonth = {
        '01': 31,
        '02': 28, // 윤년일 경우에는 29일
        '03': 31,
        '04': 30,
        '05': 31,
        '06': 30,
        '07': 31,
        '08': 31,
        '09': 30,
        '10': 31,
        '11': 30,
        '12': 31
    };

    return daysInMonth[month]; // 해당 월의 일 수 반환
}

    
	// 월별 라벨 업데이트 함수
	function updateLabelsForMonth2(month) {
		  let labelList2 = [];
		  let daysInMonth2 = getDaysInMonth2(month);
		
		  for (let i = 1; i <= daysInMonth2; i++) {
		    labelList2.push(i);
		  }
		
		  // 차트의 labels를 새로운 라벨 리스트로 업데이트
		  myLineChart2.data.labels = labelList2;
		
		
		  // x축 눈금의 최대 표시 개수 설정 (일 수에 따라 동적으로 설정)
		  let maxTicks = daysInMonth2; // 해당 월의 일 수까지 표시
		  myLineChart2.options.scales.xAxes[0].ticks.maxTicksLimit = maxTicks;
		  myLineChart2.options.scales.xAxes[0].ticks.max = daysInMonth2 + 1; // x축 최대값 설정 (해당 월의 마지막 날짜 + 1)
		
		  myLineChart2.update(); // 차트 업데이트
		  
		  console.log(daysInMonth2);
		  console.log(month);
		  $.ajax({
		        type: 'POST',
		        url: '/onnana/user/processdaycarbon',
		        data: { month: month, userUID:userUID}, // 사용자 UID를 전송합니다.
		        success: function(result) {
		            // 성공 시 처리
		            var jsonData2 = JSON.parse(result);
		            console.log(result);
		            console.log(jsonData2);
		            console.log(jsonData2.userdaydata);
					myLineChart2.data.datasets[0].data = jsonData2.userdaydata;
		            
		            var secondDataSet = jsonData2.userAlldaydata;
		            console.log(secondDataSet);
		            
		             // Modify the existing dataset instead of pushing a new one
			        if (myLineChart2.data.datasets.length > 1) {
			            myLineChart2.data.datasets[1].data = jsonData2.userAlldaydata;
			        } else {
		            myLineChart2.data.datasets.push({
					  label: "전체 유저의 하루 감소량", // 두 번째 데이터셋 레이블
					  lineTension: 0.3,
					  backgroundColor: "rgba(255, 99, 132, 0.2)", // 배경색 설정
					  borderColor: "rgba(255,215,0,1)", // 테두리 색상 설정
					  pointRadius: 5,
					  pointBackgroundColor: "rgba(255,215,0,1)", // 점의 배경색 설정
					  pointBorderColor: "rgba(255,255,255,0.8)", // 점의 테두리 색상 설정
					  pointHoverRadius: 5,
					  pointHoverBackgroundColor: "rgba(255,99,132,1)", // 마우스 호버시 점의 배경색 설정
					  pointHitRadius: 50,
					  pointBorderWidth: 2,
					  data: secondDataSet // 두 번째 데이터셋에 대한 데이터 값 설정
					 });
		        }
		
		        myLineChart2.update();
		    }
		});
    
    }
	  
	  





// 라인 차트 생성
var labels2 = [];
for (let i = 1; i <= 31; i++) {
  labels2.push(i.toString());
}


var myLineChart2 = new Chart(ctx2, {

  type: 'line', // 라인 차트 타입 설정
  data: {
    labels: labels2, // x축 라벨 설정
    datasets: [{
      label: "나의 하루 감소량", // 데이터셋 레이블
      lineTension: 0.3,
      backgroundColor: "rgba(2,117,216,0.2)", // 배경색 설정
      borderColor: "rgba(2,117,216,1)", // 테두리 색상 설정
      pointRadius: 5,
      pointBackgroundColor: "rgba(2,117,216,1)", // 점의 배경색 설정
      pointBorderColor: "rgba(255,255,255,0.8)", // 점의 테두리 색상 설정
      pointHoverRadius: 5,
      pointHoverBackgroundColor: "rgba(2,117,216,1)", // 마우스 호버시 점의 배경색 설정
      pointHitRadius: 50,
      pointBorderWidth: 2,
      data: [75, 0, 200, 300, 120, 80, 180, 250, 0, 258, 241, 51, 84, 51, 0, 0, 75, 0, 200, 300, 120, 80, 180, 250, 0, 258, 241, 51, 84, 51, 0 ] // 차트에 표시할 데이터 값 설정
    }],
  },
  options: {
	  
    scales: {
      xAxes: [{
        time: {
          unit: 'date' // x축 시간 단위 설정
        },
        gridLines: {
          display: false // x축 그리드 라인 표시 여부 설정
        },
        ticks: {
          maxTicksLimit: 31 // 최대 표시할 눈금 개수 설정
        }
      }],
      yAxes: [{
        ticks: {
          min: 0, // y축 최소값 설정
          max: 300, // y축 최대값 설정
          maxTicksLimit: 5 // 최대 표시할 눈금 개수 설정
        },
        gridLines: {
          color: "rgba(0, 0, 0, .125)", // y축 그리드 라인 색상 설정
        }
      }],
    },
    legend: {
      display: true // 범례 표시 여부 설정
      
    }
    
  }
});