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
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	<div class="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="../common/aside.jspf" %> 
			<!-- ================ Main =================== -->
			<div class="col-6 mt-5">
				<hr>
				<table class="table table-hover">
					<tr data-user-id="1" class="user-row">
						<th style="width: 5%">No</th>
						<th style="width: 14%">UID</th>
						<th style="width: 16%">이름</th>
						<th style="width: 20%">이메일</th>
						<th style="width: 25%">가입일</th>
						<th style="width: 20%">액션</th>
					</tr>
				<c:forEach var="user" items="${userList}" varStatus="loop">
					<tr onclick="showUserName('${user.uname}', '${user.uid}')">
			            <td>${loop.index + 1}</td>
			            <td>${user.uid}</td>
			            <td>${user.uname}</td>
			            <td>${user.email}</td>
			            <td>${user.regDate}</td>
						<td>
							<!-- 본인만이 수정 권한이 있음 -->
							<c:if test="${sessUid eq user.uid}">
								<a href="javascript:updateFunc('${user.uid}')"><i class="fa-solid fa-user-pen me-2"></i></a>
							</c:if>
							<c:if test="${sessUid ne user.uid}">
								<a href="#" class="disabled-link"><i class="fa-solid fa-user-pen me-2"></i></a>
							</c:if>
							<!-- 관리자만이 삭제 권한이 있음 -->
							<c:if test="${sessUid eq 'admin'}">
								<a href="javascript:deleteFunc('${user.uid}')"><i class="fa-solid fa-user-minus"></i></a>
							</c:if>
							<c:if test="${sessUid ne 'admin'}">
								<a href="#" class="disabled-link"><i class="fa-solid fa-user-minus"></i></a>
							</c:if>
						</td>
					</tr>
				<!-- 이 부분에 새로운 ID 입력 필드를 추가합니다. -->
				    <tr style="display: none;">
				        <td colspan="5">
				            <input type="hidden" id="uid_${user.uid}" value="${user.uid}">
				            <input type="hidden" id="uname_${user.uid}" value="${user.uname}">
				            <input type="hidden" id="email_${user.uid}" value="${user.email}">
				        </td>
				    </tr>
				</c:forEach>	
				</table>
				<ul class="pagination mt-3 justify-content-center">
				<c:forEach var="page" items="${pageList}">
					<li class="page-item ${(currentUserPage eq page) ? 'active' : ''}">
						<a class="page-link" href="/onnana/user/list/${page}">${page}</a>
					</li>
				</c:forEach>
				</ul>				
			</div>
			<div class="col-6">
			    <!-- Jumbotron -->
			    <div class="container mt-3">
			        <h4 style="color:green;">&nbsp;&nbsp;&nbsp;</h4>
			        <div class="mt-4 p-5 bg-primary-transparent text-dark rounded">
			        	<h4 id="userNameJumbotron" style="color:green; margin-bottom:20px;">&nbsp;&nbsp;&nbsp;</h4>
						<img id="userImage" src="/onnana/img/리스트안내.png" style="width=auto; margin-left:-150px;">
						<p id="userContent"></p>
				        
				        
			        </div>
			    </div>
			</div>
			
			<script>
			function sendUIDToController(uid) {
			    var email = $('#email_' + uid).val();
			    var uname = $('#uname_' + uid).val();
			    var userUID = $('#uid_' + uid).val();

			    $.ajax({
			        type: 'POST',
			        url: '/onnana/user/processUid',
			        data: { userUID: userUID }, // 사용자 UID를 전송합니다.
			        success: function(result) {
			            // 성공 시 처리
			            var jsonData = JSON.parse(result);
			            var userlistCount = jsonData.userlistCount;
			            var userlistCarbon = jsonData.userlistCarbon;
			            var UserDateAve = jsonData.UserDateAve;
			            var userlistCountAll = jsonData.userlistCountAll;
			            var userlistCarbonAll = jsonData.userlistCarbonAll;
			            var UserDateAveAll = jsonData.UserDateAveAll;
			            var AveDifference = jsonData.AveDifference;
			            $('#userlistCount').text(userlistCount); // 한 유저의 캠페인 참여일
			            $('#userlistCarbon').text(userlistCarbon); // 한 유저의 탄소감소량
			            $('#UserDateAve').text(UserDateAve); // 한 유저의 평균 하루 탄소감소량
			            $('#userlistCountAll').text(userlistCountAll); // 모든 유저의 캠페인 참여일
			            $('#userlistCarbonAll').text(userlistCarbonAll); // 모든 유저의 탄소감소량
			            $('#UserDateAveAll').text(UserDateAveAll); // 모든 평균 하루 탄소감소량
			            $('#AveDifference').text(AveDifference); // 모든 유저의 평균 하루 탄소감소량과 나의 차이
			            console.log(result);
			        },
			        error: function(error) {
			            // 에러 처리
			            console.log('요청 실패');
			        }
			    });
			}	
			function updateFunc(uid) {
			    console.log('updateFunc()');
			    $.ajax({
			        type: 'GET',
			        url: '/onnana/user/update/' + uid,
			        success: function(result) {
			            let user = JSON.parse(result);
			            $('#uid').val(user.uid);
			            $('#uname').val(user.uname);
			            $('#email').val(user.email);
			            $('#updateModal').modal('show');
			        }
			    });
			}

			function deleteFunc(uid) {
			    $('#delUid').val(uid);
			    $('#deleteModal').modal('show');
			}

			function showUserName(userName, userUID) {
			    document.getElementById('userNameJumbotron').innerHTML = '<i class="fa-solid fa-tree"></i>&nbsp;&nbsp;' + userName + "님의 캠페인 활동 내역";
			    document.getElementById('userImage').style.display = 'none'; // 이미지 숨기기
			    console.log(`uname: ${userName}, uid: ${userUID}`);
			    document.getElementById('userContent').innerHTML = `
			        <!-- 출석 횟수 표시 -->
			        <p class="ms-3" style="font-size:18px; margin-bottom:-2px;"><i style="color:green;" class="fa-solid fa-clipboard-user"></i>&nbsp;&nbsp; 출석 일수: ${attendanceCount}</h5>
			        <p class="ms-3" style="font-size:18px; margin-bottom:-2px;"><i style="color:green;" class="fa-solid fa-leaf"></i>&nbsp;&nbsp;그린캠페인 참여일 : <span id="userlistCount">${userlistCount}</span> 일</p>
			        <p class="ms-3" style="font-size:18px; margin-bottom:-2px;"><i style="color:green;" class="fa-regular fa-face-kiss-wink-heart"></i>&nbsp;&nbsp;나의 감소량: <span id="userlistCarbon">${userlistCarbon}</span> kg</p>
			        <p class="ms-3" style="font-size:18px;"><i style="color:green;" class="fa-regular fa-calendar-check"></i>&nbsp;&nbsp;나의 하루 평균 감소량: <span id="UserDateAve">${UserDateAve}</span> kg</p>
			        <hr>
			        <h4 style="color:green; margin-bottom:20px;"><i class="fa-solid fa-people-carry-box"></i>&nbsp;&nbsp; 그린캠페인에 함께한 우리들</h4>
			        <p class="ms-3" style="font-size:18px; margin-bottom:-2px;"><i style="color:green;" class="fa-solid fa-clipboard-user"></i>&nbsp;&nbsp;  그린캠페인 참여인원 : <span id="userlistCountAll">${userlistCountAll}</span> 명</p>
			        <p class="ms-3" style="font-size:18px; margin-bottom:-2px;"><i style="color:green;" class="fa-regular fa-face-kiss-wink-heart"></i>&nbsp;&nbsp; 캠페인 배출 감소량 : <span id="userlistCarbonAll">${userlistCarbonAll}</span> kg</p>
			        <p class="ms-3" style="font-size:18px;"><i style="color:green;" class="fa-regular fa-calendar-check"></i>&nbsp;&nbsp;하루 평균 감소량(/일): <span id="UserDateAveAll">${UserDateAveAll}</span> kg</p>

			    `;


			    sendUIDToController(userUID);
			}
			</script>
			<input type="hidden" id="delUid">
			<!-- ================ Main =================== -->
		</div>
	</div>
	<%@ include file="../common/bottom.jspf" %>
	<div class="modal" id="updateModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">사용자 수정</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="/onnana/user/update" method="post">
                        <table class="table table-borderless">
                            <tr>
                                <td style="width:35%"><label class="col-form-label">사용자 ID</label></td>
                                <td style="width:65%"><input type="text" id="uid" class="form-control" value="${sessUid}"   disabled></td>
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
                                <td><input type="text" name="uname" id="uname" class="form-control" value="${sessUname}"   disabled ></td>
                            </tr>
                            <tr>
                                <td><label class="col-form-label">이메일</label></td>
                                <td><input type="text" name="email" id="email" class="form-control" value="${sessEmail}"  ></td>
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
        </div>
    </div>
    <div class="modal" id="deleteModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">사용자 삭제</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <strong>삭제하시겠습니까?</strong>
                    <div class="text-center mt-5">
                        <button class="btn btn-danger" onclick="location.href='/onnana/user/delete/'+$('#delUid').val()">삭제</button>
                        <button class="btn btn-secondary ms-1" data-bs-dismiss="modal">취소</button>
                    </div>
                </div>
            </div>
        </div>
    </div>	
</body>
</html>