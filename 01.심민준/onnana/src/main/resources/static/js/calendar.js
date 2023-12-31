/**
 * calendar.js
 * 		calendar.jsp 에서 사용하는 자바스크립트 코드
 */

 var schedClicked = false;
 
function cellClick(date) {
	if (schedClicked)
		schedClicked = false;
	else{
		
		const today = new Date();
		const year = today.getFullYear();
		const month = String(today.getMonth() + 1).padStart(2, '0');
		const day = String(today.getDate()).padStart(2, '0');
		const todaySdate = `${year}${month}${day}`; // 오늘 날짜의 sdate 형식
	
		date = date + ''; // number type을 문자열로 변환
		const dateForm = date.substring(0, 4) + '-' + date.substring(4, 6) + '-' + date.substring(6, 8);
	
		if (date === todaySdate) {
			let t = new Date();
			let hour = t.getHours();
			let minute = t.getMinutes();
			if (minute < 30) {
				minute = 30;
			} else {
				minute = 0;
				hour = (hour + 1) % 24;
			}
			const startStr = ((hour >= 10) ? '' + hour : '0' + hour) + ':' + ((minute == 0) ? '00' : '30');
			$('#startDate').val(dateForm);
			$('#startTime').val(startStr);
			$('#addModal').modal('show');
		} else {
			const schedSid = "20231207"; // 여기에 sched.sid의 값 넣으셔야 합니다.
			if (date === schedSid) {
				let t = new Date();
				let hour = t.getHours();
				let minute = t.getMinutes();
				if (minute < 30) {
					minute = 30;
				} else {
					minute = 0;
					hour = (hour + 1) % 24;
				}
				const startStr = ((hour >= 10) ? '' + hour : '0' + hour) + ':' + ((minute == 0) ? '00' : '30');
				$('#startDate').val(dateForm);
				$('#startTime').val(startStr);
				$('#addModal').modal('show');
			} else {
				alert('당일에만 글을 작성/수정할 수 있습니다.');
			}
		}
	}
}

function schedClick(sid) {
	
    schedClicked = true;
    $.ajax({
        type: 'GET',
        url: '/onnana/schedule/detail/' + sid,
        success: function(jsonSched) {
            let sched = JSON.parse(jsonSched);
            $('#sid2').val(sched.sid);
            $('#title2').val(sched.title);
            $('#startDate2').val(sched.startTime.substring(0, 10));
            $('#startTime2').val(sched.startTime.substring(11, 16));
            $('#place2').val(sched.place);
            $('#smoke2').val(sched.smoke);

            const updateButton = $('.btn-success');
            const today = new Date();
            const year = today.getFullYear();
            const month = today.getMonth() + 1;
            const day = today.getDate();

            const formattedToday = year * 10000 + month * 100 + day;
            const buttonDate = parseInt($('#startDate2').val().replace(/-/g, ''));

            if (buttonDate === formattedToday) {
                updateButton.removeAttr('disabled');
                updateButton.off('click').on('click', update);
            } else {
                updateButton.attr('disabled', 'disabled');
                updateButton.off('click');
            }

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





function addAnniversary() {
	$('#addAnnivModal').modal('show');
}

function addAnnivList() {
	$('#addAnnivListModal').modal('show');
}



// 숫자로만 된 문자열로 변환하는 함수
function extractNumericValue(dateString) {
    // 숫자만 남기고 제거하고 싶다면, 정규식을 사용해 숫자만 남기고 나머지는 제거합니다.
    const numericString = dateString.replace(/\D/g, '');
    return numericString;
}

