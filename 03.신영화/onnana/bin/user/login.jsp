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
   <nav class="navbar navbar-expand-sm bg-dark navbar-dark fixed-top">
        <div class="container-fluid">
        	<img src="/onnana/img/onnana.png" height="60" class="rounded-3, mx-2">
        	<div class="p-2 bg-dark justify-content-center rounded">
        		<img src="https://picsum.photos/1500/200" width="100%">
        	</div>
        </div>
   </nav>
   
   <div class="container" style="margin-top: 250px;">
   		<div class="row">
   			<div class="col-4"></div>
   			<div class="col-4">
   				<h3>
   					<strong>로그인</strong>
   					<span style="font-size:0.6em;">
   						<a href="/onnana/user/register" class="ms-5">
   							<i class="fa-solid fa-user-plus"></i> 사용자 등록</a>
   					</span>
   				</h3>
				<hr>
				<form action="/onnana/user/login" method="post">
					<table class=table table-borderless">
						<tr>
							<td style="width: 35%"><label class="col-form-label">사용자 ID</label></td>
							<td style="width: 65%"><input type="text" name="uid" class="form-control"></td>
						</tr>
						<tr>
							<td><label class="col-form-label">패스워드</label></td>
							<td><input type="password" name="pwd" class="form-control"></td>
						</tr>
						<tr>
							<td colspan="2">
								<input type="submit" class="btn btn-primary" value="로그인">
								<input type="reset" class="btn btn-secondary" value="취소">
							</td>
						</tr>
					</table>
				</form>
   			</div>
   			<div class="col-4"></div>
   		</div>
   </div>
   <%@ include file="../common/bottom.jspf" %>
</body>
</html>