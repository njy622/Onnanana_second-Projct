<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="height" value="${600 / numberOfWeeks}"></c:set>
<c:set var="todaySdate" value="${fn:substring(today,0,4)}${fn:substring(today,5,7)}${fn:substring(today,8,10)}"></c:set>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="../common/head.jspf" %>
    <style>
        th { text-align: center; width: 14.28%;}
        .disabled-link	{ pointer-events: none; }
    </style>
    <script src="/onnana/js/calendar.js?v=2"></script>
    <script src="/onnana/js/calcu.js"></script>
    
    <!-- =================== 탄소계산기 스크립트 start =================== -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 라이브러리 -->    
	<script>

   <!-- =================== 탄소계산기 end =================== -->
   
// <!-- ========================= insert 함수 form태그없이 함수로 제출버튼 구현 ======================== -->
	function insert(){
		
		var startDate = $('#startDate').val();
		var startTime = $('#startTime').val();
		var title = $('#title').val();				// insert에 들어가는 데이터 id로 불러와서 변수에 넣음
		var place = $('#place').val();
		var smoke = $('#smoke').val();
		
		
	    $.ajax({
	        type: "POST",
	        url: "/onnana/schedule/insert", // 스케줄 컨트롤러안의 함수 불러오는 경로
	        data: {startDate, startTime, title, place, smoke},
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
	        }
	        });
	}
	

	// <!-- =================== update 함수 form태그없이 함수로 제출버튼 구현 =================== -->
	function update(){
		var startDate = $('#startDate2').val();
		var startTime = $('#startTime2').val();
		var title = $('#title2').val();				// insert에 들어가는 데이터 id로 불러와서 변수에 넣음
		var place = $('#place2').val();
		var smoke = $('#smoke2').val();
		
		
	    $.ajax({
	        type: "POST",
	        url: "/onnana/schedule/update", // 스케줄 컨트롤러안의 함수 불러오는 경로
	        data: {startDate, startTime, title, place, smoke},
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
	        }
	        });
	}
	

	
//담배 갯수 선택한 값에 * 14g 연산 후  kg으로 출력하는 함수
function calculateAndShow() {
   document.getElementById('showResult').innerText = $('#smoke').val() * 14 / 1000;
}
//거리환산+ 담배환산 값을 제목에 넣는 함수
function readJs() {
	
	//거리 환산해서 탄소배출량 출력
    let carbonEmission = parseFloat((document.getElementById('result').innerText).match(/\d+/)[0]);

  //담배 갯수 선택한 값에 * 14g 연산 후  kg으로 출력
    let smokeCarbon = parseInt($('#smoke').val()) * 14 / 1000;
	
  	
    let totalCarbon = carbonEmission + smokeCarbon;
    document.getElementById('showResult').innerText = totalCarbon.toFixed(2);

    // 입력값이 변경될 때마다 제목에 결과값 추가
    let titleElement = document.getElementById('title');
    let currentTitle = titleElement.value;
    titleElement.value = currentTitle.split('-')[0].trim() + '- ' + totalCarbon.toFixed(2) + 'kg 감소';
}


	</script>                       
	                        
    
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	
	<div class="container" style="margin-top: 80px;">
        <div class="row">
        	<%@ include file="../common/aside.jspf" %>
        
        	<!-- ======================== main ======================== -->
			<div class="col-sm-9 mt-3 ms-1">
            	<h3 style="color:green;"><strong>그린캠페인 캘린더</strong></h3>
            	<hr>
                <div class="d-flex justify-content-between">
                    <div>${today}</div>
                    <div>
                        <a href="/onnana/schedule/calendar/left2"><i class="fa-solid fa-angles-left"></i></a>
                        <a href="/onnana/schedule/calendar/left"><i class="fa-solid fa-angle-left ms-2"></i></a>
                        <span class="badge bg-success mx-2">${year}.${month}</span>
                        <a href="/onnana/schedule/calendar/right"><i class="fa-solid fa-angle-right me-2"></i></a>
                        <a href="/onnana/schedule/calendar/right2"><i class="fa-solid fa-angles-right"></i></a>
                    </div>
                    <div>
                    	<a href="#" onclick="addAnniversary()"><i class="fa-solid fa-pen me-2"></i></a>
                    	<%-- 관리자만이 공휴일/24절기 추가권한이 있음 --%>
        				<c:if test="${sessUid eq 'admin'}">
                    		<a href="#" onclick="addAnnivList()"><i class="fa-solid fa-calendar-plus"></i></a>
                    	</c:if>
                    	<c:if test="${sessUid ne 'admin'}">
       						<a href="#" class="disabled-link"><i class="fa-solid fa-calendar-plus"></i></a>
       					</c:if>
                    </div>
                </div>
                <table class="table table-bordered mt-2 mb-5">
                    <tr>
                        <th class="text-danger">일</th>
                        <th>월</th><th>화</th><th>수</th><th>목</th><th>금</th>
                        <th class="text-primary">토</th>
                    </tr>
                <c:forEach var="week" items="${calendar}">
                    <tr>
                    <c:forEach var="day" items="${week}">
                        <td style="height: ${height}px; ${todaySdate eq day.sdate ? 'background-color: #efffff;' : ''}" onclick="cellClick(${day.sdate})">
                            <div class="d-flex justify-content-between">
                           	<c:if test="${day.isOtherMonth eq 1}">
                               	<div class="${(day.date eq 0 or day.isHoliday eq 1) ? 'text-danger' : day.date eq 6 ? 'text-primary' : ''}" 
                               		 style="opacity: 0.5;"><strong>${day.day}</strong></div>
	                        	<div style="opacity: 0.5;">
		                        <c:forEach var="name" items="${day.annivList}" varStatus="loop">
		                        	${loop.first ? '' : '&middot;'} ${name}
	                        	</c:forEach>
	                        	</div>
                           	</c:if>
                           	<c:if test="${day.isOtherMonth eq 0}">
                               	<div class="${(day.date eq 0 or day.isHoliday eq 1) ? 'text-danger' : day.date eq 6 ? 'text-primary' : ''}">
                               		<strong>${day.day}</strong></div>
                               	<div>
		                        <c:forEach var="name" items="${day.annivList}" varStatus="loop">
		                        	${loop.first ? '' : '&middot;'} ${name}
	                        	</c:forEach>
	                        	</div>
                           	</c:if>
                            </div>
                        <c:forEach var="sched" items="${day.schedList}" varStatus="loop">
                        	<div style="text-align:center; font-size:13px;"  class="${loop.first ? 'mt-1' : ''}" style="font-size: 12px;" onclick="schedClick(${sched.sid})">
	                        	<!-- 글작성 시, 스탬프 찍기 -->
								<img height="60px" src="/onnana/img/stamp.png">
	                        	<br>
	                        	${sched.title}
                        	</div>
                        </c:forEach>
                        </td>
                    </c:forEach>
                    </tr>
                </c:forEach>
                </table>
            </div>
			<!-- =================== main =================== -->
            
        </div>
    </div>

    <%@ include file="../common/bottom.jspf" %>
    
<!---------------------------------------- Insert 프론트엔드  ------------------------------------------>
	<div class="modal" id="addModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h5 class="modal-title"><i class="fa-solid fa-leaf"></i> 오늘의 탄소감소량</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
			
				<!-- Modal body -->
				<div class="modal-body">
				
					<!-- <form action="/onnana/schedule/insert" method="post"> -->
						<table class="table table-borderless">
	                       
	                        
	                        <tr>
	                            <td>
	                                <label for="startDate">일 자</label>
	                                <input class="form-control" type="date" id="startDate" name="startDate">
	                            </td>
	                            <td style="display: none;">
	                                <label for="startTime" >시작 시간</label>
	                                <select class="form-control" name="startTime" id="startTime">
	                                <c:forEach var="tl" items="${timeList}">
	                                    <option value="${tl}">${tl}</option>
	                                </c:forEach>
	                                </select>
	                            </td>
	                        </tr>
<!-- ========================================================= 탄소계산기 start ========================================================= -->
	                         <tr>
	                            <td colspan="2">
	                            	<p id="demo" style="display: none;"></p> <!-- 현재 위치를 표시할 요소 -->
	                                <label for="place">거리에 따른 배출 감소량 계산하기</label>
	                                <div class="input-group outer-container" style="width: 100%;">
									    <input type="text" style="height: auto;" class="form-control" id="place" name="place" placeholder=" 도착지 주소를 입력하면 현재위치부터 계산합니다">
									    <button class="btn btn-success" style="width: 80px;" type="submit" onclick="searchAndCalculateDistance()">계산</button>
									</div>
		                              <p id="result"></p>  <!-- 검색된 위치의 좌표와 거리를 표시할 요소 -->
	                            </td>
	                        </tr>    
<!-- ========================================================= 탄소계산기 end ======================================================== -->
	                        <tr>
	                            <td colspan="2">
                                <label for="smoke">금연(개비) 배출 감소량</label>
                                  <form action="/action_page.php">
									    <select class="form-select form-control"  type="text" id="smoke" name="smoke" onchange="calculateAndShow()">
										     <c:forEach var="i" begin="1" end="20">
										      <option value="${i}" >${i}</option>
									      		</c:forEach>
									    </select>
									    <p id="showResult"  style="display: none;"></p>
									    <p>※ 산출방식: 14g/개</p>
									  </form>
	                            </td>
	                        </tr>
	                         <tr>
	                            <td colspan="2">
	                                <label for="title">합 산</label>
	                                <div class="input-group outer-container" style="width: 100%;">
									    <input class="form-control" type="text" id="title" name="title" disabled>
									    <button class="btn btn-success" style="width: 80px;" type="submit" onclick="readJs()"><i class="fa-solid fa-calculator"></i></button>
									</div>
	                            </td>
	                        </tr>   
	                        
	                        
	                        <tr>
	                            <td colspan="2" style="text-align: right;">
	                                <button class="btn btn-primary me-2" type="submit" onclick="insert()">제출</button>
	                                <!-- <button class="btn btn-secondary" type="reset">취소</button> -->
	                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">종료</button>
	                            </td>
	                        </tr>
	                        
	                    </table>
					<!-- </form> -->
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal" id="updateModal">
		<div class="modal-dialog">
			<div class="modal-content">
<!---------------------------------------- update 프론트엔드  ------------------------------------------>
				<!-- Modal Header -->
				<div class="modal-header">
					<h5 class="modal-title"><i class="fa-solid fa-leaf"></i> 오늘의 탄소감소량 수정</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
			
				<!-- Modal body -->
				<div class="modal-body">
				
					<!--<form action="/onnana/schedule/update" method="post"> -->
						<input type="hidden" name="sid" id="sid2">
						<table class="table table-borderless">
	                       
	                            <td>
	                                <label for="startDate2">일 자</label>
	                                <input class="form-control" type="date" id="startDate2" name="startDate">
	                            </td>
	                            <td style="display: none;">
	                                <label for="startTime2">시작시간</label>
	                                <select class="form-control" name="startTime" id="startTime2">
	                                <c:forEach var="tl" items="${timeList}">
	                                    <option value="${tl}" >${tl}</option>
	                                </c:forEach>
	                                </select>
	                            </td>
	                        </tr>
<!-- ========================================================= 탄소계산기 start ========================================================= -->
	                         <tr>
	                            <td colspan="2">
	                            	<p id="demo" style="display: none;"></p> <!-- 현재 위치를 표시할 요소 -->
	                                <label for="place">거리에 따른 배출 감소량 계산하기</label>
	                                <div class="input-group outer-container" style="width: 100%;">
									    <input type="text" style="height: auto;" class="form-control" id="place2" name="place" placeholder=" 도착지 주소를 입력하면 현재위치부터 계산합니다">
									    <button class="btn btn-success" style="width: 80px;" type="submit" onclick="searchAndCalculateDistance()">계산</button>
									</div>
		                              <p id="result"></p>  <!-- 검색된 위치의 좌표와 거리를 표시할 요소 -->
	                            </td>
	                        </tr>  
	                        
<!-- ========================================================= 탄소계산기 end ======================================================== -->
	                         <tr>
	                            <td colspan="2">
                                <label for="smoke">금연(개비) 배출 감소량</label>
                                  <form action="/action_page.php">
									    <select class="form-select form-control"  type="text" id="smoke2" name="smoke" onchange="calculateAndShow()">
										     <c:forEach var="i" begin="1" end="20">
										      <option value="${i}" >${i}</option>
									      		</c:forEach>
									    </select>
									    <p id="showResult"  style="display: none;"></p>
									    <p>※ 산출방식: 14g/개</p>
									  </form>
	                            </td>
	                        </tr>
	                         <tr>
	                            <td colspan="2">
	                                <label for="title">합 산</label>
	                                <div class="input-group outer-container" style="width: 100%;">
									    <input class="form-control" type="text" id="title2" name="title" disabled>
									    <button class="btn btn-success" style="width: 80px;" type="submit" onclick="readJs()"><i class="fa-solid fa-calculator"></i></button>
									</div>
	                            </td>
	                        </tr>   
	                        <tr>
	                        <tr>
	                            <td colspan="2" style="text-align: right;">
	                                <button class="btn btn-success me-2" type="submit"  onclick="update()">수정</button>
	                                <button class="btn btn-danger me-2" type="button" data-bs-dismiss="modal" onclick="deleteSchedule()">삭제</button>
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">종료</button>
	                            </td>
	                        </tr>
	                    </table>
					<!-- </form> -->
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal" id="addAnnivModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">기념일 추가</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
			
				<!-- Modal body -->
				<div class="modal-body">
					<form action="/onnana/schedule/insertAnniv" method="post">
						<table class="table table-borderless">
	                        <tr>
	                            <td>
	                                <label for="title">제목</label>
	                                <input class="ms-5 me-2" type="checkbox" name="holiday">공휴일
	                                <input class="form-control" type="text" id="title" name="title">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                                <label for="annivDate">날짜</label>
	                                <input class="form-control" type="date" id="annivDate" name="annivDate">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td style="text-align: right;">
	                                <button class="btn btn-primary me-2" type="submit">제출</button>
	                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">종료</button>
	                            </td>
	                        </tr>
	                    </table>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal" id="addAnnivListModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">공휴일/24절기 추가</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
			
				<!-- Modal body -->
				<div class="modal-body">
					<form action="/onnana/schedule/insertAnnivList" method="post">
						<table class="table table-borderless">
	                        <tr>
	                            <td>
	                            	<input type="radio" class="form-check-input" name="option" value="공휴일" checked> 공휴일
	                            	<input type="radio" class="form-check-input ms-3" name="option" value="24절기"> 24절기
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                                <label for="year">년도</label>
	                                <select class="form-select" id="year" name="year">
	                                	<option>2020</option>
	                                	<option>2021</option>
	                                	<option>2022</option>
	                                	<option selected>2023</option>
	                                	<option>2024</option>
	                                	<option>2025</option>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td style="text-align: right;">
	                                <button class="btn btn-primary me-2" type="submit">제출</button>
	                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">종료</button>
	                            </td>
	                        </tr>
	                    </table>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>