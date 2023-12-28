<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jspf" %>
	<style>
		th, td	{ text-align: center; }
		.disabled-link	{ pointer-events: none; }
		
		
		.bg-primary-transparent {
            background-color: rgba(255, 218, 149, 0.3); /* 알파 값은 0에서 1 사이의 숫자입니다 (0은 완전 투명, 1은 완전 불투명) */
        }
		
		
	</style>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="/onnana/assets/js/adminScripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
        <script src="/onnana/assets/demo/chart-area-demo2.js"></script>
        <script src="/onnana/assets/demo/chart-bar-demo2.js"></script>
        <script src="/onnana/assets/demo/chart-doughnut-demo2.js"></script>
	<script>
    // 세션에서 UID 가져오기
    var userUID = '${sessUid}';
    function sendUIDToController(userUID) {
	    
        localStorage.removeItem('AveDifference');

	    $.ajax({
	        type: 'POST',
	        url: '/onnana/user/processUid',
	        data: { userUID: userUID}, // 사용자 UID를 전송합니다.
	        success: function(result) {

	            // 성공 시 처리
	            var jsonData = JSON.parse(result);
	            var AveDifference = jsonData.AveDifference;
	            console.log(jsonData);
	            
	            
	            localStorage.setItem('AveDifference', JSON.stringify(AveDifference));
				
	            
	            // 각 차트 함수에 UID 전달하기
	            updateLabelsForMonth2(userUID);
	            sendUIDToController2(userUID);
	    	    updateLabelsForMonthController2(userUID);
	    	    updatedateList2(AveDifference);
	    	    updateBarchartForMonthController2(userUID);
	    	    updatedateListBarChart2(userUID)
	        },
	        error: function(error) {
	            // 에러 처리
	            console.log('요청 실패');
	        }
	    });
	}	
   
</script>
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	<div class="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="../common/aside.jspf" %> 
			<!-- ================ Main =================== -->
			<div class="col-6 mt-5">
				<div class="container">
	                <h4 style="margin-left:50px;">내정보 수정하기</h4>
	                 <form action="/onnana/user/update" method="post">
	                     <table class="table table-borderless" style="float:left;">
	                         <tr>
	                             <td style="width:35%"><label class="col-form-label">사용자 ID</label></td>
	                             <td style="width:65%"><input type="text" id="uid" class="form-control" value="${sessUid}"  disabled></td>
	                         </tr>
	                         <tr>
	                             <td><label class="col-form-label">패스워드</label></td>
	                             <td><input type="password" name="pwd" class="form-control"></td>
	                         </tr>
	                         <tr>
	                             <td><label class="col-form-label">패스워드 확인</label></td>
	                             <td><input type="password" name="pwd2" class="form-control"></td>
	                         </tr>
	                         <tr>
	                             <td><label class="col-form-label">이름</label></td>
	                             <td><input type="text" name="uname" id="uname" class="form-control" value="${sessUname}"  disabled></td>
	                         </tr>
	                         <tr>
	                             <td><label class="col-form-label">이메일</label></td>
	                             <td><input type="text" name="email" id="email" class="form-control" value="${sessEmail}"></td>
	                         </tr>
	                         <tr>
	                             <td colspan="2" style="text-align: center;">
	                                 <input class="btn btn-primary" type="submit" value="수정">
	                                 <input class="btn btn-secondary ms-1" type="reset" value="취소">
	                             </td>
	                         </tr>
	                     </table>
	                 </form>
                 </div>
             </div>
             <div class="col-6">
			    <!-- Jumbotron -->
			    <div class="container mt-3">
			        <h4 style="color:green;">&nbsp;&nbsp;&nbsp;</h4>
			        <div class="mt-4 p-5 bg-primary-transparent text-dark rounded">
			        	<h4 id="userNameJumbotron" style="color:green; margin-bottom:20px;">&nbsp;&nbsp;&nbsp;</h4>
						<h5 class="me-3" style="color:green;"><i class="fa-solid fa-tree"></i>&nbsp;${sessUname}님의 그린 발자취.</h5>
						    <!-- 출석 횟수 표시 -->
				   			<p class="ms-4" style="margin-bottom:-1px;"">출석 횟수: ${attendanceCount}</p>
						   	<p class="ms-4" style="margin-bottom:-1px;">그린캠페인 참여일 : <span id="asideSessId">${sessId}</span> 일</p>
						    <p class="ms-4">나의 감소량: <span id="asideSessCarbonId">${sessCarbonId}</span> kg</p>
						    <hr>
						    <h5 class="me-3"  style="color:green;"><i class="fa-solid fa-people-carry-box"></i> 그린캠페인에 함께한 우리들</h5>
						    <p class="ms-4" style="margin-bottom:-1px;"> 그린캠페인 참여인원 : <span id="asideSessAllId">${sessAllId}</span> 명</p>
						    <p class="ms-4"> 캠페인 배출 감소량 : <span id="asidesessAllCarbonId">${sessAllCarbonId}</span> kg</p>
				        
			        </div>
			    </div>
			</div>
            </div>
		<!-- <div class="row">
               <div id="layoutSidenav">
	            <div id="layoutSidenav_content">
	                <main>
	                    <div class="container-fluid px-4">
	                        <h3 class="breadcrumb-item active"><span id="userNameChart" style="color:green; margin-bottom:20px;"></span></h3>
	                        <div class="card mb-4">
	                            <div class="card-header">
	                            	<div colspan="20">
		                                <i class="fas fa-chart-area me-1"></i>
		                                일별 탄소배출량
		                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('01')">1월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('02')">2월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('03')">3월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('04')">4월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('05')">5월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('06')">6월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('07')">7월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('08')">8월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('09')">9월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('10')">10월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('11')">11월</button>
                               			<button type="button" class="btn btn-outline-success" onclick="updateLabelsForMonth('12')">12월</button>
                               		</div>
	                            </div>
	                            <div class="card-body">
		                            	<canvas id="myAreaChart2" width="100%" height="30"></canvas>
	                            </div>
	                            <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
	                        </div>
	                        <div class="row">
	                            <div class="col-lg-6">
	                                <div class="card mb-4">
	                                    <div class="card-header">
	                                        <i class="fas fa-chart-bar me-1"></i>
	                                        Bar Chart Example
	                                    </div>
	                                    <div class="card-body">
	                                    	
	                                    	<div class="row">
		                                    	<canvas id="myBarChart2" width="100%" height="50"></canvas>
	                                    	</div>
                                    	</div>
	                                    <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
	                                </div>
	                            </div>
	                            <div class="col-lg-6">
	                                <div class="card mb-4">
	                                    <div class="card-header">
	                                        <i class="fas fa-chart-pie me-1"></i>
	                                        <span id="userNamedoughnutChart2" style="color:green; margin-bottom:20px;"></span>
	                                    </div>
	                                    <div class="card-body"><canvas id="myPieChart2" width="100%" height="50"></canvas></div>
	                                    <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                </main>
	            </div> 
        </div>
	</div>-->	
        </div>
			<!-- ================ Main =================== -->
	<%@ include file="../common/bottom.jspf" %>
  
</body>
</html>