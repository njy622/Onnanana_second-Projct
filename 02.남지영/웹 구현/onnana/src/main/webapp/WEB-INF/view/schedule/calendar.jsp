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
        
        .imgcampain {
		  position: absolute; /* 이미지 위치 설정 */
		  top: 0; /* 원하는 위치로 조정 */
		  right: 0; /* 원하는 위치로 조정 */
		  z-index: 800; /* 다른 요소들보다 위에 오도록 설정 */
		}
    </style>
    <script src="/onnana/js/calendar.js?v=2"></script>
    <script src="/onnana/js/calcu.js" ></script>
    
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 라이브러리 -->    
	
	
	
	<script>


   
// <!-- ========================= insert 함수 form태그없이 함수로 제출버튼 구현 ======================== -->
	function insert(){
		
		var startDate = $('#startDate').val();
		var startTime = $('#startTime').val();
		var title = $('#title').val();				// insert에 들어가는 데이터 id로 불러와서 변수에 넣음
		var title2 = $('#title2').val();				// insert에 들어가는 데이터 id로 불러와서 변수에 넣음
		var place = $('#place').val();
		var startplace = $('#startplace').val();
		var endplace = $('#endplace').val();
		var smoke = $('#smoke').val();
		var smoke2 = $('#smoke2').val();
		var waypoint1 = $('#waypoint0').val();
		var waypoint2 = $('#waypoint1').val();
		var waypoint3 = $('#waypoint2').val();
		
		
	    $.ajax({
	        type: "POST",
	        url: "/onnana/schedule/insert", // 스케줄 컨트롤러안의 함수 불러오는 경로
	        data: {startDate, startTime, title,title2, place, startplace, endplace,
	        		smoke, smoke2, waypoint1, waypoint2, waypoint3},
	        success: function(response){
	            // JSON 응답을 파싱
	        	var data = JSON.parse(response); 
				
	            console.log(data);
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
		var title = $('#title3').val();				// update에 들어가는 데이터 id로 불러와서 변수에 넣음
		var title2 = $('#title4').val();				// update에 들어가는 데이터 id로 불러와서 변수에 넣음
		var place = $('#place2').val();
		var startplace = $('#startplace2').val();
		var endplace = $('#endplace2').val();
		var smoke = $('#smoke3').val();
		var smoke2 = $('#smoke4').val();
		var waypoint1 = $('#waypoint20').val();
		var waypoint2 = $('#waypoint21').val();
		var waypoint3 = $('#waypoint23').val();
		let sid = $('#sid2').val();

		console.log(place);
	    $.ajax({
	        type: "POST",
	        url: "/onnana/schedule/update", // 스케줄 컨트롤러안의 함수 불러오는 경로
	        data: {startDate, startTime, title,title2, place, startplace, endplace,
        			smoke, smoke2, waypoint1, waypoint2, waypoint3, sid},
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
	

	</script>                       
	             
	                        
    
</head>
	<%@ include file="../common/top.jspf" %>
<body>
	
	<div class="container" style="margin-top: 80px;">
        <div class="d-flex">
        	<%@ include file="../common/aside.jspf" %>
        
        	<!-- ======================== main ======================== -->
			<div class="col-8 mt-5 ms-1">
                <div class="d-flex justify-content-between">
                    <div>${today}</div>
                    <div style="margin-left:-100px">
                        <a href="/onnana/schedule/calendar/left2" style="color:green"><i class="fa-solid fa-angles-left"></i></a>
                        <a href="/onnana/schedule/calendar/left"style="color:green"><i class="fa-solid fa-angle-left ms-2"></i></a>
                        <span class="mx-2 ms-3 me-3" style="font-size:20px;">${year}.${month}</span>
                        <a href="/onnana/schedule/calendar/right"style="color:green"><i class="fa-solid fa-angle-right me-2"></i></a>
                        <a href="/onnana/schedule/calendar/right2"style="color:green"><i class="fa-solid fa-angles-right"></i></a>
                    </div>
                  
                  	 <div>
                  	 <!--  기념일 및 공휴일 추가 버튼 (사용안함으로 비활성화)
                    	<a href="#" onclick="addAnniversary()"><i class="fa-solid fa-pen me-2"></i></a>
                    	<%-- 관리자만이 공휴일/24절기 추가권한이 있음 --%>
        				<c:if test="${sessUid eq 'admin'}">
                    		<a href="#" onclick="addAnnivList()"><i class="fa-solid fa-calendar-plus"></i></a>
                    	</c:if>
                    	<c:if test="${sessUid ne 'admin'}">
       						<a href="#" class="disabled-link"><i class="fa-solid fa-calendar-plus"></i></a>
       					</c:if> -->
                    </div>
                </div>
                <table class="table table-bordered mt-2 mb-5">
                    <tr class="bg-warning  bg-opacity-10">
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
						    <div style="text-align: center; font-size: 13px; margin-top: ${loop.first ? '0' : '5px'}; font-size: 12px;" onclick="schedClick(${sched.sid})">
						        <!-- 글작성 시, 스탬프 찍기 -->
						        <div style="display: inline-block; margin-top:-10px;">
						            <!-- Stamp Image -->
						            <img id="stampImage" height="60px" src="/onnana/img/stamp.png">
						            <p style="margin-bottom:-5px">${sched.title}</p>
						            <p>${sched.title2}</p>
						</c:forEach>

                        </td>
                    </c:forEach>
                    </tr>
                </c:forEach>
                </table>
            </div>
			<!-- =================== main =================== -->
            
       
<!-- =================================== 상세페이지 ============================================================= -->
			<div class="col-4 ms-5 container border bg-warning p-2 text-dark bg-opacity-10" id="table-borderless" style="border-radius: .80rem!important; margin-top: 60px; height: 700px; overflow-y: auto; overflow-x: hidden;">
				<input type="hidden" name="sid" id="sid2">
					<table class="table table-borderless">
			             <h4 style="color:green; margin-top:10px;"><i class="fa-solid fa-leaf"></i>&nbsp; 감소한 탄소배출량 상세보기</h4>
			             <tr>
				             <td>
				                 <label for="startDate2">일 자</label>
				                 <input class="form-control" type="date" id="startDate2" name="startDate">
				             </td>
			             </tr>
			             <tr>
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
									<div class="row">
		                            	<p id="demo" style="display: none;"></p> <!-- 현재 위치를 표시할 요소 -->
		                            	<h6 style="color:green;"><i class="fa-solid fa-location-dot"></i>&nbsp;현재 위치로부터 자동으로 계산하기</h6>
		                                <label for="place3">도착지</label>
		                                <div class="input-group outer-container" style="width: 100%;">
										    <input type="text" style="height: auto;" class="form-control" id="place3" name="place" placeholder=" 도착지 주소를 입력하면 현재위치부터 계산합니다">
										    <button id="calculateDistanceBtn2"  class="btn btn-success" style="width: 80px;" onclick="searchAndCalculateDistance2()">계산</button>
										</div>
										<p id="result2" style="font-size:10px"></p>  <!-- 검색된 위치의 좌표와 거리를 표시할 요소 -->
									</div>
									<div class="row">
										<label for="smoke3">흡연(개비) 배출량</label>
									    <select class="form-select form-control ms-2"  type="text" id="smoke3" name="smoke" style="width:95%">
										     <c:forEach var="i" begin="0" end="20">
										      <option value="${i}" >${i}</option>
									      		</c:forEach>
									    </select>
									     <p id="showResult3"  style="display: none;"></p>
								     <p style="font-size:10px">※ 산출방식: 14g/개 (※감소량에서 차감됩니다)</p>
									</div>
									<div class="row">
		                                <label for="title3">합 산</label>
		                                <div class="input-group outer-container" style="width: 100%;">
										    <input class="form-control" type="text" id="title3" name="title" disabled>
										    <button class="btn btn-success" style="width: 80px;" onclick="readJs2()"><i class="fa-solid fa-calculator"></i></button>
										</div>
									</div>
                            </td>
                        </tr>
                         <tr>
                            <td>
		                        <hr>
		                        <h6 style="color:green;"><i class="fa-solid fa-location-dot"></i>&nbsp;직접 입력하여 거리 계산하기</h6>
                                <label for="startplace2" style="margin-top:10px">출발지 입력</label>
                            	<button type="button" class="btn btn-outline-success" onclick="addWaypoint2()" id="addWaypoint2">+ 경유지 추가</button>
                                <div class="input-group outer-container" style="width: 100%;">
								    <input type="text" style="height: auto; margin-top:5px;" class="form-control" id="startplace2" name="startplace2" placeholder=" 출발지 주소를 입력하면 현재위치부터 계산합니다">
								</div>
							</td>	
						</tr>	
                        <tr>
                            <td>
                                <div id="waypointFields2">
								</div>
                            </td>
                        </tr>
                        
                        <script>
	                        var waypointCount2 = 0;

	                        function addWaypoint2() {
	                            if (waypointCount2 < 3) {
	                                const waypointFields2 = document.getElementById('waypointFields2');

	                                // 새로운 경유지 입력 필드를 생성합니다.
	                                const newWaypointField2 = document.createElement('div');
	                                newWaypointField2.className = 'waypointField2';

	                                // jQuery 코드
	                                $(newWaypointField2).append(
	                                    $('<label></label>')
	                                        .attr({'for': 'waypoint2' + waypointCount2}) // 수정된 부분
	                                        .text('경유지 입력')
	                                );

	                                $(newWaypointField2).append(
	                                    $('<div></div>')
	                                        .attr({'class': 'input-group outer-container', 'style': 'width: 100%;', id: 'divwaypoint2' + waypointCount2})
	                                );

	                                $(newWaypointField2).find('#divwaypoint2' + waypointCount2).append(
	                                    $('<input></input>')
	                                        .attr({'style': 'height: auto;', 'class': 'form-control waypointField2', 'id': 'waypoint2' + waypointCount2, 'name': 'waypoint2' + waypointCount2, 'type': 'text', 'placeholder': '경유지 주소를 입력하세요'})
	                                );

	                                $(newWaypointField2).find('#divwaypoint2' + waypointCount2).append(
	                                    $('<button></button>')
	                                        .attr({'class': 'btn btn-danger', 'style': 'width: 80px;', 'onclick': 'removeWaypoint2(this)'})
	                                        .text('삭제')
	                                );

	                                // 생성된 요소를 waypointFields에 추가
	                                $('#waypointFields2').append(newWaypointField2);

	                                waypointCount2++;
	                            } else {
	                                alert('최대 3개까지 추가할 수 있습니다.');
	                            }
	                        }
	                        

	                        function removeWaypoint2(button) {
	                            const fieldToRemove2 = $(button).closest('.waypointField2');
	                            fieldToRemove2.remove();
	                            waypointCount2--;

	                            // 남은 입력 필드들의 ID를 재조정합니다.
	                            $('.waypointField2').each(function (index2) {
	                                $(this).find('.waypointField2').attr('id', 'waypoint2' + index2);
	                            });
	                        }
	                        
	                     // 초기 로드 시 3개의 경유지 입력 필드 생성
	                        addWaypoint2();
	                        addWaypoint2();
	                        addWaypoint2();

						</script>    
                        <tr>
						    <td colspan="2">
						        <label for="endplace2">도착지 입력</label>
						        <div class="input-group outer-container" style="width: 100%;">
						            <input type="text" style="height: auto;" class="form-control" id="endplace2" name="endplace" placeholder="도착지 주소를 입력하세요">
						            <button class="btn btn-primary" style="width: 80px;" onclick="stopoverCalculateDistance2()">계산</button>
						        </div>
						        <p style="font-size:10px" id="stopoverResult2"></p> <!-- 결과를 표시할 요소 -->
						        
						    </td>
						</tr>
<!-- ========================================================= 탄소계산기 end ======================================================== -->
                     	<tr>
                            <td colspan="2">
                               <label for="smoke4">흡연(개비) 배출량</label>
								    <select class="form-select form-control"  type="text" id="smoke4" name="smoke2">
									     <c:forEach var="i" begin="0" end="20">
									      <option value="${i}" >${i}</option>
								      		</c:forEach>
								    </select>
								     <p id="showResult4"  style="display: none;"></p>
								     <p style="font-size:10px">※ 산출방식: 14g/개 (※감소량에서 차감됩니다)</p>
                            </td>
                        </tr>
                        <tr>
			             <td colspan="2">
			                 <label for="title4">합 산</label>
			                 <div class="input-group outer-container" style="width: 100%;">
								<input class="form-control" type="text" id="title4" name="title2" disabled>
								<button  class="btn btn-success" style="width: 80px;"  onclick="stopoverreadJs2()"><i class="fa-solid fa-calculator"></i></button>
							</div>
							<p id="stopoverResult2"></p>
			              </td>
			            </tr>    
		                <tr>
		                    <td colspan="2" style="text-align: right;">
				                 <button class="btn btn-success me-2" onclick="update()">수정</button>
				                 <button class="btn btn-danger me-2"  data-bs-dismiss="modal" onclick="deleteSchedule()">삭제</button>
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">종료</button>
		                    </td>
		                </tr>
		             </table>
		             <hr>
		             
		             <p style="font-size:10px; float:left; margin-top:-10px;">거리에 따른 탄소배출량 산출식 출처:한국기후.환경네트워크 탄소발자국(https://www.kcen.kr/tanso/intro.green)</p>
		             <p style="font-size:10px; float:left; margin-top:-10px;">담배 탄소배출량 출처: 질병관리청-주간 건강과 질병•제15권 제22호(2022.6.2.)</p>
		             <img style="margin-left:50px" src="/onnana/img/greencam.png" width="300px">
		             
				</div>
			</div>
		 </div>

    <%@ include file="../common/bottom.jspf" %>
    
    
    
<!---------------------------------------- Insert 프론트엔드  ------------------------------------------>
	<div class="modal" id="addModal" style="overflow-y: auto;">
    	<div class="modal-dialog" style="max-height: 80vh;"> <!-- 80% 화면 높이까지만 모달 크기 조정 -->
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h5 class="modal-title"><i class="fa-solid fa-leaf"></i>&nbsp; 오늘의 탄소감소량</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
			
				<!-- Modal body -->
				<div class="modal-body" id="modalBody" style="max-height: 80vh; overflow-y: auto;">
				
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
	                         		<button type="button" class="btn btn-outline-success" data-bs-toggle="collapse" data-bs-target="#currentLocation">현재위치로 계산하려면 여기를 누르세요!</button>
									<div id="currentLocation" class="collapse">
										<div class="row">
			                            	<p id="demo" style="display: none;"></p> <!-- 현재 위치를 표시할 요소 -->
			                                <label for="place">현재위치부터 계산하기</label>
			                                <div class="input-group outer-container" style="width: 100%;">
											    <input type="text" style="height: auto;" class="form-control" id="place" name="place" placeholder=" 도착지 주소를 입력하면 현재위치부터 계산합니다">
											    <button id="calculateDistanceBtn"  class="btn btn-success" style="width: 80px;" onclick="searchAndCalculateDistance()">계산</button>
											</div>
											<p id="result" style="font-size:10px;"></p>  <!-- 검색된 위치의 좌표와 거리를 표시할 요소 -->
										</div>
										<div class="row">
											<label for="smoke">흡연(개비) 배출량</label>
										    <select class="form-select form-control ms-2"  type="text" id="smoke" name="smoke" style="width:95%">
											     <c:forEach var="i" begin="0" end="20">
											      <option value="${i}" >${i}</option>
										      		</c:forEach>
										    </select>
										     <p id="showResult"  style="display: none;"></p>
									     <p style="font-size:10px">※ 산출방식: 14g/개 (※감소량에서 차감됩니다)</p>
										</div>
										<div class="row">
			                                <label for="title">합 산</label>
			                                <div class="input-group outer-container" style="width: 100%;">
											    <input class="form-control" type="text" id="title" name="title" disabled>
											    <button class="btn btn-success" style="width: 80px;" onclick="readJs()"><i class="fa-solid fa-calculator"></i></button>
											</div>
										</div>
									</div>
	                            </td>
	                        </tr>
	                         <tr>
	                            <td>
	                                <label for="startplace" style="margin-top:10px">출발지 입력</label>
	                            	<button type="button" class="btn btn-outline-success" onclick="addWaypoint()" id="addWaypoint">+ 경유지 추가</button>
	                                <div class="input-group outer-container" style="width: 100%;">
									    <input type="text" style="height: auto;margin-top:5px;" class="form-control" id="startplace" name="startplace" placeholder=" 출발지 주소를 입력하면 현재위치부터 계산합니다">
									</div>
								</td>	
							</tr>	
	                        <tr>
	                            <td>
	                                <div id="waypointFields">
									</div>
	                            </td>
	                        </tr>
	                        
	                        <script>
	                        var waypointCount = 0;

	                        function addWaypoint() {
	                            if (waypointCount < 3) {
	                                const waypointFields = document.getElementById('waypointFields');

	                                // 새로운 경유지 입력 필드를 생성합니다.
	                                const newWaypointField = document.createElement('div');
	                                newWaypointField.className = 'waypointField';

	                                // jQuery 코드
	                                $(newWaypointField).append(
	                                    $('<label></label>')
	                                        .attr({'for': 'waypoint' + waypointCount})
	                                        .text('경유지 입력')
	                                );

	                                $(newWaypointField).append(
	                                    $('<div></div>')
	                                        .attr({'class': 'input-group outer-container', 'style': 'width: 100%;', id: 'divwaypoint' + waypointCount})
	                                );

	                                $(newWaypointField).find('#divwaypoint' + waypointCount).append(
	                                    $('<input></input>')
	                                        .attr({'style': 'height: auto;', 'class': 'form-control waypointField', 'id': 'waypoint' + waypointCount, 'name': 'waypoint' + waypointCount, 'type': 'text', 'placeholder': '경유지 주소를 입력하세요'})
	                                );

	                                $(newWaypointField).find('#divwaypoint' + waypointCount).append(
	                                    $('<button></button>')
	                                        .attr({'class': 'btn btn-danger', 'style': 'width: 80px;', 'onclick': 'removeWaypoint(this)'})
	                                        .text('삭제')
	                                );

	                                // 생성된 요소를 waypointFields에 추가
	                                $('#waypointFields').append(newWaypointField);

	                                waypointCount++;

	                                const modalBody = document.getElementById('modalBody');
	                                modalBody.style.maxHeight = '80vh'; // 필요한 높이로 조정 (예시로 80% 뷰포트 높이 사용)
	                                modalBody.style.overflowY = 'auto'; // 스크롤이 필요한 경우에만 스크롤 나타나도록 설정
	                            } else {
	                                alert('최대 3개까지 추가할 수 있습니다.');
	                            }
	                        }


	                        function removeWaypoint(button) {
	                            const fieldToRemove = $(button).closest('.waypointField');
	                            fieldToRemove.remove();
	                            waypointCount--;

	                            // 남은 입력 필드들의 ID를 재조정합니다.
	                            $('.waypointField').each(function(index) {
	                                $(this).find('.waypointField').attr('id', 'waypoint' + index);
	                            });
	                        }

							</script> 
	                        <tr>
							    <td colspan="2">
							        <label for="endplace">도착지 입력</label>
							        <div class="input-group outer-container" style="width: 100%;">
							            <input type="text" style="height: auto;" class="form-control" id="endplace" name="endplace" placeholder="도착지 주소를 입력하세요">
							            <button class="btn btn-primary" style="width: 80px;" onclick="stopoverCalculateDistance()">계산</button>
							        </div>
							        <p style="font-size:10px" id="stopoverResult"></p> <!-- 결과를 표시할 요소 -->
							        
							    </td>
							</tr>
<!-- ========================================================= 탄소계산기 end ======================================================== -->
	                     	<tr>
	                            <td colspan="2">
                                <label for="smoke2">흡연(개비) 배출량</label>
									    <select class="form-select form-control"  type="text" id="smoke2" name="smoke2">
										     <c:forEach var="i" begin="0" end="20">
										      <option value="${i}" >${i}</option>
									      		</c:forEach>
									    </select>
									     <p id="showResult2"  style="display: none;"></p>
									     <p style="font-size:10px">※ 산출방식: 14g/개 (※감소량에서 차감됩니다)</p>
	                            </td>
	                        </tr>
	                        <tr>
				             <td colspan="2">
				                 <label for="title2">직접 설정한 경로의 합산</label>
				                 <div class="input-group outer-container" style="width: 100%;">
									<input class="form-control" type="text" id="title2" name="title2" disabled>
									<button  class="btn btn-success" style="width: 80px;"  onclick="stopoverreadJs()"><i class="fa-solid fa-calculator"></i></button>
								</div>
								<p id="stopoverResult"></p>
				              </td>
				            </tr>    
	                        
	                        <tr>
	                            <td colspan="4" style="text-align: right;">
									<p style="font-size:10px; float:left; margin-top:10px;">거리에 따른 탄소배출량 산출식 출처:한국기후.환경네트워크 탄소발자국(https://www.kcen.kr/tanso/intro.green)<br>담배 탄소배출량 출처: 질병관리청-주간 건강과 질병•제15권 제22호(2022.6.2.)</p>
									<button class="btn btn-success me-2" onclick="insert();">제출</button>
	                               <!-- <button class="btn btn-secondary" type="reset">초기화</button> --> 
	                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">종료</button>
	                            </td>
	                        </tr>
	                        
	                    </table>
				</div>
			</div>
		</div>
	</div>
	
	
	
</body>
</html>