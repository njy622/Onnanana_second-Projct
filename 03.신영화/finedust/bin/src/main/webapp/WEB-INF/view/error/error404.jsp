<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jspf" %>
</head>
<body>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark fixed-top">
		<div class="container-fluid">
        	<img src="/finedust/img/ck-logo.png" height="60" class="rounded-3 mx-2">
        	<div class="p-2 bg-dark justify-content-center rounded">
        		<img src="https://picsum.photos/1500/200" width="100%">
        	</div>
        </div>
    </nav>
    
    <div class="container" style="margin-top: 250px;">
    	<div class="row">
    		<div class="col-3"></div>
    		<div class="col-6">
    			<h3>
    				<strong>에러 페이지</strong>
   				</h3>
    			<hr>
				<h2>요청한 페이지는 존재하지 않습니다.</h2>
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