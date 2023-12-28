function userAreaProc(jsonData) {

  // 차트의 글꼴과 기본 글자 색상 설정
  Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
  Chart.defaults.global.defaultFontColor = '#292b2c';

  // JSON 데이터를 문자열로 변환 후 다시 JSON 객체로 파싱
  let jsonObject = JSON.stringify(jsonData);
  let jData = JSON.parse(jsonObject);
          
  // 라벨과 값 리스트 초기화
  let labelList = new Array();
  let valueList = new Array();
  
  // JSON 데이터를 반복하며 라벨과 값 추출하여 리스트에 추가
  for(let i = 0; i < jData.length; i++) {
      let d = jData[i];
      labelList.push(d.month + "월"); // 월별 라벨 생성하여 리스트에 추가
      valueList.push(d.numberOfPerson); // 해당 월의 인원수를 값 리스트에 추가
  }

  // 차트를 표시할 캔버스 요소 가져오기
  let ctx1 = document.getElementById("myAreaChart");

  // 라인 차트 생성
  let myLineChart = new Chart(ctx1, {
    type: 'line', // 라인 차트 타입 설정
    data: {
      labels: labelList, // x축 라벨 설정
      datasets: [{
        label: "Sessions", // 데이터셋 레이블
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
        data: valueList, // 차트에 표시할 데이터 값 설정
      }],
    },
    options: {
      scales: {
        xAxes: [{
          time: {
            unit: '월별 가입 회원수' // x축 시간 단위 설정
          },
          gridLines: {
            display: false // x축 그리드 라인 표시 여부 설정
          },
          ticks: {
            maxTicksLimit: 100 // 최대 표시할 눈금 개수 설정
          }
        }],
        yAxes: [{
          ticks: {
            min: 0, // y축 최소값 설정
            max: 10, // y축 최대값 설정
            maxTicksLimit: 100 // 최대 표시할 눈금 개수 설정
          },
          gridLines: {
            color: "rgba(0, 0, 0, .125)", // y축 그리드 라인 색상 설정
          }
        }],
      },
      legend: {
        display: false // 범례 표시 여부 설정
      }
    }
  });

}
