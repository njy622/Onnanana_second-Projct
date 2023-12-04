<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jspf" %>
	<style>
        #cartogram {
            width: 100%;
            cursor: pointer;
        }
        
        .transparent-button {
            background-color: transparent;
            cursor: pointer;
            width: 36px; /* 버튼의 너비 설정 */
            height: 30px; /* 버튼의 높이 설정 */
        }
    </style>
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	<div class="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="../common/aside.jspf" %> 
			<!-- ================ 내가 작성할 부분 =================== -->
			<div class="col-9">
				<h3 class="mt-3"><strong>기상 예보 띄우는창</strong></h3>
				<hr>
				<div id="map" style="height: 500px;">
					<!-- 이미지 표시 -->
	    			<img id="cartogram" src="/onnana/img/카토그램.png" alt="Example Image">
	    			<!-- 여러 개의 버튼 -->
			        <form action="${pageContext.request.contextPath}/buttonAction" method="post" style="position: absolute; top: 313px; left: 544px;">
					    <input type="hidden" name="buttonIndex" value="1" />
					    <button type="submit" class="transparent-button"> </button>
					</form>
					<form action="${pageContext.request.contextPath}/buttonAction" method="post" style="position: absolute; top: 343px; left: 544px;">
					    <input type="hidden" name="buttonIndex" value="1" />
					    <button type="submit" class="transparent-button"> </button>
					</form>
					<form action="${pageContext.request.contextPath}/buttonAction" method="post" style="position: absolute; top: 373px; left: 544px;">
					    <input type="hidden" name="buttonIndex" value="1" />
					    <button type="submit" class="transparent-button"> </button>
					</form>
    			</div>
    			
			</div>
			
			
		</div>
	</div>
	<%@ include file="../common/bottom.jspf" %>
</body>
</html>