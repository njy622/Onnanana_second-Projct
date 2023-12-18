<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
 	<%@include file="../common/head.jspf" %>
 	<style>
 		th, td {text-align: center;}
 	</style>
</head>
<body>
   <div class="container" style="margin-top:200px;">
   		<div class="row">
   			<div class="col-2"></div>
   			<div class="col-4">
   				<a href="/onnana/home/">
					<img src="/onnana/img/onna.png" width="100px" style="float: right; z-index:-1;">   
   				</a>
   				<h3 style="color:green;"><i class="fa-solid fa-leaf"></i>&nbsp;회원가입</h3>
				<hr>
				<form action="/onnana/user/register" method="post">
					<table class="table table-borderless">
						<tr>
							<td style="width: 20%"><label class="col-form-label" style="float:left;">사용자 ID</label></td>
							<td style="width: 80%"><input type="text" name="uid" class="form-control"></td>
						</tr>
						<tr>
							<td><label class="col-form-label" style="float:left;">패스워드</label></td>
							<td><input type="password" name="pwd" class="form-control"></td>
						</tr>
						<tr>
							<td><label class="col-form-label" style="float:left; font-size:10px;">(패스워드 확인)</label></td>
							<td><input type="password" name="pwd2" class="form-control"></td>
						</tr>
						<tr>
							<td><label class="col-form-label" style="float:left;">이름</label></td>
							<td><input type="text" name="uname" class="form-control"></td>
						</tr>
						<tr>
							<td><label class="col-form-label" style="float:left;">이메일</label></td>
							<td><input type="text" name="email" class="form-control"></td>
						</tr>
						<tr>
							<td colspan="2">
								<input type="submit" class="btn btn-success" value="제출">
								<input type="reset" class="btn btn-secondary" value="취소">
							</td>
						</tr>
					</table>
				</form>
   			</div>
   			<div class="col-6">
   				<img src="/onnana/img/greencam.png">
   			</div>
   		</div>
   </div>
   <%@ include file="../common/bottom.jspf" %>
</body>
</html>