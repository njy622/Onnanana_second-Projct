<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
 	<%@include file="../common/head.jspf" %>
 	<style>
 		th, td {text-align: center;}
 	</style>
</head>
<body>
   
   <div class="container" style="margin-top: 250px;">
   		<div class="row">
   			<div class="col-3"></div>
   			<div class="col-6">
   				<a  style="margin-right: 40px" href="/onnana/home"><img src="/onnana/img/onna.png" height="70"></a>
				<hr>
 				<h3>
 				   <strong>에러 페이지</strong>
                </h3>
	            <hr>
	            <h2>서비스 실행중 오류가 발생하였습니다.</h2>
	            <h2>잠시후 다시 시도해 보세요.</h2>
				<h3>${code}</h3>
				<h3>${msg}</h3>
				<h3>${timestamp}</h3>
          </div>
   			<div class="col-3"></div>
   		</div>
   </div>
   <%@ include file="../common/bottom.jspf" %>
</body>
</html>