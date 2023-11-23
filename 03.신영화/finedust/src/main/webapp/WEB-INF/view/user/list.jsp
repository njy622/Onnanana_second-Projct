<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jspf" %>
	<style>
		th, td { text-align: center; }
		.disabled-link  { pointer-event: none; }
	</style>
	<script>
		function updateFunc(uid) {
			console.log('updateFunc()');
			$.ajax({
				type: 'GET',
				url: '/finedust/user/update/' + uid,
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
	</script>
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	<div class="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="../common/aside.jspf" %> 
			<!-- ================ Main =================== -->
			<div class="col-9">
				<h3><strong>사용자 목록</strong></h3>
				<hr>
				<table class="table table-hover">
					<tr>
						<th style="width: 10%">번호</th>
						<th style="width: 14%">UID</th>
						<th style="width: 16%">이름</th>
						<th style="width: 20%">이메일</th>
						<th style="width: 20%">가입일</th>
						<th style="width: 20%">액션</th>
					</tr>
				<c:forEach var="user" items="${userList}" varStatus="loop">  	<!-- for (User user : userList) -->
					<tr>
						<td>${loop.count}</td>
						<td>${user.uid}</td>		<!-- jsp가 uid를 getUid로 바꿔줌 -->
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
				</c:forEach>	
				</table>
				<ul class="pagination mt-3 justify-content-center">
				<c:forEach var="page" items="${pageList}">
					<li class="page-item ${(currentUserPage eq page) ? 'active' : ''}">
						<a class="page-link" href="/finedust/user/list/${page}">${page}</a>
					</li>
				</c:forEach>
				</ul>				
			</div>
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
                    <form action="/finedust/user/update" method="post">
                        <table class="table table-borderless">
                            <tr>
                                <td style="width:35%"><label class="col-form-label">사용자 ID</label></td>
                                <td style="width:65%"><input type="text" id="uid" class="form-control" disabled></td>
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
                                <td><input type="text" name="uname" id="uname" class="form-control"></td>
                            </tr>
                            <tr>
                                <td><label class="col-form-label">이메일</label></td>
                                <td><input type="text" name="email" id="email" class="form-control"></td>
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
                    <strong> 삭제하시겠습니까?</strong>
                    <div class="text-center mt-5">
                        <button class="btn btn-danger" onclick="location.href='/finedust/user/delete/'+$('#delUid').val()">삭제</button>
                        <button class="btn btn-secondary ms-1" data-bs-dismiss="modal">취소</button>
                    </div>
                </div>
            </div>
        </div>
    </div>	
</body>
</html>