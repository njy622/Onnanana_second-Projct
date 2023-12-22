/**
 * calendar.js
 * 		calendar.jsp 에서 사용하는 자바스크립트 코드
 */

var schedClicked = false;
 
function cellClick(date) {
	if (schedClicked)
		schedClicked = false;
				
	else {
		date = date + '';		// number type을 문자열로 변환
		const dateForm = date.substring(0,4)+'-'+date.substring(4,6)+'-'+date.substring(6,8);
		let t = new Date();
		let hour = t.getHours();
		let minute = t.getMinutes();
		if (minute < 30)
			minute = 30;
		else {
			minute = 0; hour = (hour + 1) % 24;
		}
		const startStr = ((hour >= 10) ? ''+hour : '0'+hour) + ':' + ((minute == 0) ? '00' : '30');
		const endStr = ((hour >= 9) ? ''+(hour+1) : '0'+(hour+1)) + ':' + ((minute == 0) ? '00' : '30');
		$('#startDate').val(dateForm);
		$('#startTime').val(startStr);
		$('#endDate').val(dateForm);
		$('#endTime').val(endStr);
		$('#addModal').modal('show');
		 
		 $.ajax({
        type: 'GET',
        url: '/onnana/schedule/detail/' + sid,
        success: function(jsonSched) {
            let sched = JSON.parse(jsonSched);
			$('#totalSum2222').text(sched.totalSum);
			console.log(sched.totalSum)
        }
    });
		}
}

function schedClick(sid) {
    schedClicked = true;
    $.ajax({
        type: 'GET',
        url: '/onnana/schedule/detail/' + sid,
        success: function(jsonSched) {
            let sched = JSON.parse(jsonSched);
			console.log(jsonSched);
            $('#sid2').val(sched.sid);
            $('#title3').val(sched.title);
            $('#title4').val(sched.title2);
            $('#startDate2').val(sched.startTime.substring(0, 10));
            $('#startTime2').val(sched.startTime.substring(11, 16));
            $('#place3').val(sched.place);
            $('#startplace2').val(sched.startplace);
            $('#endplace2').val(sched.endplace);
            $('#smoke3').val(sched.smoke);
            $('#smoke4').val(sched.smoke2);
            $('#waypoint20').val(sched.waypoint1); // Updated to 'waypoint1'
            $('#waypoint21').val(sched.waypoint2);
            $('#waypoint22').val(sched.waypoint3);
			$('#totalSum2222').text(sched.totalSum);

			
			console.log(sched.totalSum)
            $('#updateModal').modal('show');
        }
    });
}


function deleteSchedule() {
	let sid = $('#sid2').val();
	const answer = confirm('정말로 삭제하시겠습니까?');
			if (answer) {
				//location.href = '/onnana/schedule/delete/' + sid;
	
    $.ajax({
        type: "POST",
        url: "/onnana/schedule/delete/" + sid, // 스케줄 컨트롤러안의 함수 불러오는 경로
        data: {sid},
        success: function(response){
            // JSON 응답을 파싱
        	var data = JSON.parse(response); 
			
            //각 변수에 접근하여, 변경된 세션 다시 불러오기
            
            $('#asideSessId').text(data.countUser); //한 유저의 참여일수 합계
            $('#asideSessCarbonId').text(data.countUserCarbon);//한 유저의 감소량 합계
            
            $('#asideSessAllId').text(data.count);//전체유저 인원수
            $('#asidesessAllCarbonId').text(data.countCarbon); //전체유저의 감소량 합계
			
			 $('#addModal').modal('hide');
	            location.href = '/onnana/schedule/calendar';
     		
     			location.reload();
        }
        });
        }
	}




