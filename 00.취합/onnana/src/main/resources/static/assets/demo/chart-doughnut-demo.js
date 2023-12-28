// 부트스트랩의 기본 스타일을 모방하기 위해 새로운 기본 글꼴 및 글꼴 색상 설정
Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#292b2c';

// 파이 차트 예시
var ctx = document.getElementById("myPieChart");

// 로컬 저장소에서 데이터 가져오기
var AveDifference = JSON.parse(localStorage.getItem('AveDifference'));
var userUID;

function updateLabelsForMonthController(uid) {
    userUID = $('#uid_' + uid).val();
}
    
function updatedateList(AveDifference) {
    // 차트 데이터 업데이트
    
    $.ajax({
    type: 'POST',
    url: '/onnana/user/processUid',
    data: { userUID: userUID },
    success: function(result) {
        var jsonData = JSON.parse(result);
        var AveDifference = jsonData.AveDifference;
        myPieChart.data.datasets[0].data = [AveDifference, 100 - AveDifference];
    	myPieChart.update(); // 차트 업데이트

    },
    error: function(error) {
        console.log('요청 실패');
    }
});
    
}



var myPieChart = new Chart(ctx, {
  type: 'doughnut',
  data: {
    labels: ["나의 기여도", "전체 유저"],
    datasets: [{
      data: [50, 50],
      backgroundColor: ['#ffc107', '#28a745'],
    }],
  },
});

// 가져온 데이터를 사용하여 차트를 업데이트하는 함수 호출
updatedateList(AveDifference);
