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
   				<h3 style="color:green;"><i class="fa-solid fa-leaf"></i>&nbsp;아이디 찾기</h3>
				<hr>
				<form action="/onnana/user/Idsearch" method="post">
					<table class="table table-borderless">
	                     <tr>
	                         <td><label class="col-form-label">이름</label></td>
	                         <td><input type="text" name="idUname" id="idUname" class="form-control"></td>
	                     </tr>
	                     <tr>
	                         <td><label class="col-form-label">이메일</label></td>
	                         <td><input type="text" name="idEmail" id="idEmail" class="form-control"></td>
	                     </tr>
	                     <tr>
	                         <td colspan="3" style="text-align: center;">
	                             <input class="btn btn-primary" type="submit" value="찾기">
	                             <a href="/onnana/home">
		                             <input class="btn btn-light ms-1" type="reset" value="취소">
	                             </a>
	                             <a href="/onnana/user/Pwdchange">
		               	        	<button type="button" class="btn btn-light">비밀번호 찾기</button>
	    						 </a>
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