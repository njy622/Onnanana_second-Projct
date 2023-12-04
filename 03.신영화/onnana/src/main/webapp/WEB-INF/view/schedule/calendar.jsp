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
    <!-- =================== 탄소계산기 스크립트 start =================== -->
 	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 라이브러리 -->
 	<script src="../js/calcu.js"></script>
	<script>

   <!-- =================== 탄소계산기 end =================== -->
   
   <!-- =================== insert 함수 form태그없이 함수로 제출버튼 구현 =================== -->
	function insert(){
		var title = $('#title').val();				// insert에 들어가는 데이터 id로 불러와서 변수에 넣음
		var startDate = $('#startDate').val();
		var startTime = $('#startTime').val();
		var endDate = $('#endDate').val();
		var endTime = $('#endTime').val();
		var place = $('#place').val();
		var memo = $('#memo').val();
	    $.ajax({
	        type: "POST",
	        url: "/onnana/schedule/insert", // 스케줄 컨트롤러안의 함수 불러오는 경로
	        data: {title, startDate, startTime, endDate, endTime, place, memo},
	        success: function(){
	            $('#addModal').modal('hide');  // 모달창 숨기고
	            location.href = '/onnana/schedule/calendar';   // 제출버튼 이후 calendar 창으로 감     
	        }
	    });
	}
<!-- ============================================ end ==================================== --> 
   
   
	</script>                       
	                        
    
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	
	<div class="container" style="margin-top: 80px;">
        <div class="row">
        	<%@ include file="../common/aside.jspf" %>
        
        	<!-- ======================== main ======================== -->
			<div class="col-sm-9 mt-3 ms-1">
            	<h3><strong>일정표</strong></h3>
            	<hr>
                <div class="d-flex justify-content-between">
                    <div>${today}</div>
                    <div>
                        <a href="/onnana/schedule/calendar/left2"><i class="fa-solid fa-angles-left"></i></a>
                        <a href="/onnana/schedule/calendar/left"><i class="fa-solid fa-angle-left ms-2"></i></a>
                        <span class="badge bg-primary mx-2">${year}.${month}</span>
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
	                        	${fn:substring(sched.startTime, 11, 16)}
	                        <c:if test="${sched.isImportant eq 1}">
	                        	<strong>${sched.title}</strong>
	                        </c:if>
	                        <c:if test="${sched.isImportant ne 1}">
	                        	${sched.title}
	                        </c:if>
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
    
	<div class="modal" id="addModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">일정 추가</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
			
				<!-- Modal body -->
				<div class="modal-body">
					<!-- <form action="/onnana/schedule/insert" method="post"> -->
						<table class="table table-borderless">
	                        <tr>
	                            <td colspan="2">
	                                <label for="title">제목</label>
	                                <input class="ms-5 me-2" type="checkbox" name="importance">중요
	                                <input class="form-control" type="text" id="title" name="title">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                                <label for="startDate">시작일</label>
	                                <input class="form-control" type="date" id="startDate" name="startDate">
	                            </td>
	                            <td>
	                                <label for="startTime">시작시간</label>
	                                <select class="form-control" name="startTime" id="startTime">
	                                <c:forEach var="tl" items="${timeList}">
	                                    <option value="${tl}">${tl}</option>
	                                </c:forEach>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                                <label for="endDate">종료일</label>
	                                <input class="form-control" type="date" id="endDate" name="endDate">
	                            </td>
	                            <td>
	                                <label for="endTime">종료시간</label>
	                                <select class="form-control" name="endTime" id="endTime">
	                                <c:forEach var="tl" items="${timeList}">
	                                    <option value="${tl}">${tl}</option>
	                                </c:forEach>
	                                </select>
	                            </td>
	                        </tr>
<!-- ========================================================= 탄소계산기 start ========================================================= -->
	                         <tr>
	                            <td colspan="2">
	                            	<p id="demo"></p> <!-- 현재 위치를 표시할 요소 -->
	                                <label for="place">대중교통 배출량 계산하기 </label>
	                                <div class="input-group outer-container" style="width: 100%;">
									    <input type="text" style="height: auto;" class="form-control" id="address" name="address" placeholder=" 도착지 주소를 입력하세요">
									    <button class="btn btn-success" style="width: 80px;" type="submit" onclick="searchAndCalculateDistance()">계산</button>
									</div>
		                                <p id="result"></p> <!-- 검색된 위치의 좌표와 거리를 표시할 요소 -->
	                            </td>
	                        </tr>    
	                        
<!-- ========================================================= 탄소계산기 end ======================================================== -->
	                        <tr>
	                            <td colspan="2">
	                                <label for="place">장소</label>
	                                <input class="form-control" type="text" id="place" name="place">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td colspan="2">
	                                <label for="memo">메모</label>
	                                <input class="form-control" type="text" id="memo" name="memo">
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
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">일정 조회/수정/삭제</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
			
				<!-- Modal body -->
				<div class="modal-body">
					<form action="/onnana/schedule/update" method="post">
						<input type="hidden" name="sid" id="sid2">
						<table class="table table-borderless">
	                        <tr>
	                            <td colspan="2">
	                                <label for="title2">제목</label>
	                                <input class="ms-5 me-2" type="checkbox" id="importance2" name="importance">중요
	                                <input class="form-control" type="text" id="title2" name="title">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                                <label for="startDate2">시작일</label>
	                                <input class="form-control" type="date" id="startDate2" name="startDate">
	                            </td>
	                            <td>
	                                <label for="startTime2">시작시간</label>
	                                <select class="form-control" name="startTime" id="startTime2">
	                                <c:forEach var="tl" items="${timeList}">
	                                    <option value="${tl}" >${tl}</option>
	                                </c:forEach>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                                <label for="endDate2">종료일</label>
	                                <input class="form-control" type="date" id="endDate2" name="endDate">
	                            </td>
	                            <td>
	                                <label for="endTime2">종료시간</label>
	                                <select class="form-control" name="endTime" id="endTime2">
	                                <c:forEach var="tl" items="${timeList}">
	                                    <option value="${tl}" >${tl}</option>
	                                </c:forEach>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td colspan="2">
	                                <label for="place2">장소</label>
	                                <input class="form-control" type="text" id="place2" name="place">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td colspan="2">
	                                <label for="memo2">메모</label>
	                                <input class="form-control" type="text" id="memo2" name="memo">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td colspan="2" style="text-align: right;">
	                                <button class="btn btn-primary me-2" type="submit">수정</button>
	                                <button class="btn btn-danger me-2" type="button" data-bs-dismiss="modal" onclick="deleteSchedule()">삭제</button>
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">종료</button>
	                            </td>
	                        </tr>
	                    </table>
					</form>
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