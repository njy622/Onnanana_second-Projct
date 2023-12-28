// 부트스트랩의 기본 스타일을 모방하기 위해 새로운 기본 글꼴 및 글꼴 색상 설정
Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#292b2c';


$(document).ready(function() {
    // input 태그에 클릭 이벤트 리스너 추가
    $('input[type="hidden"]').on('click', function() {
        updateBarchartForMonthController($(this).val());
        updatedateListBarChart();
    });
});

// 파이 차트 예시
var ctx = document.getElementById("myBarChart");

var userUID;

function updateBarchartForMonthController(uid) {
    userUID = $('#uid_' + uid).val();
    console.log(userUID + ' updateBarchartForMonthController 호출됨');
}

function updatedateListBarChart(userUID) {
    const barchartdata = [];

    $.ajax({
        type: 'POST',
        url: '/onnana/user/processUid',
        data: { userUID: userUID },
        success: function (result2) {
            console.log('updatedateListBarChart 호출됨');
            var jsonData = JSON.parse(result2);
            var UserattendanceCount2 = 50;  // 한유저의 출석일자
            var UserAllattendanceCount2 = 100; // 전체 유저의 출석일자
            var userlistCount2 = jsonData.userlistCount;
            var userlistCountAll2 = jsonData.userlistCountAll;

            // 데이터를 차트에 설정
            barchartdata.push(UserattendanceCount2);
            barchartdata.push(UserAllattendanceCount2);
            barchartdata.push(userlistCount2);
            barchartdata.push(userlistCountAll2);
            myBarChart.data.datasets[0].data = barchartdata;

            // 차트 업데이트
            myBarChart.update();
        },
        error: function (error) {
            console.log('요청 실패');
        }
    });
}

var myBarChart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['나의 출석', '모든 유저', '나의 캠페인참여', '모든 유저'],
        datasets: [{
            label: '참여일',
            data: [65, 59, 80, 81],
            backgroundColor: [
                'rgb(255, 205, 86)',
                'rgb(75, 192, 192)',
                'rgb(255, 205, 86)',
                'rgb(75, 192, 192)'
            ],
            borderColor: [
                'rgb(255, 205, 86)',
                'rgb(75, 192, 192)',
                'rgb(255, 205, 86)',
                'rgb(75, 192, 192)'
            ],
            borderWidth: 1
        }]
    }
});


