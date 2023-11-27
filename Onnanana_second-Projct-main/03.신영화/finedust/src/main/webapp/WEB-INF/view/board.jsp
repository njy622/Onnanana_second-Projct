<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="common/head.jspf" %>
	<title>이미지 상세 정보</title>
	    <style>
	        /* 상세 정보 레이어의 초기 스타일을 정의합니다. */
	        #detailLayer {
	            display: none;
	            position: absolute;
	            border: 1px solid #ccc;
	            background-color: #fff;
	            padding: 10px;
	            z-index: 1;
	        }
	    </style>
</head>
<body>
	<%@ include file="common/top.jspf" %>
	<div class ="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="common/aside.jspf" %>
			<!-- ===============내가 작성할 부분 ================ -->
						<!-- 이미지 엘리먼트를 추가합니다. -->
			<img src="img/body.jpg" id="image" alt="이미지">
			
			<!-- 상세 정보를 표시할 레이어를 추가합니다. -->
			<div id="detailLayer">상세 정보가 여기에 표시됩니다.</div>
			
			<script>
			    // 이미지 엘리먼트를 선택합니다.
			    var image = document.getElementById("image");
			
			    // 상세 정보를 표시할 레이어를 선택합니다.
			    var detailLayer = document.getElementById("detailLayer");
			
			    // 마우스를 이미지 위에 올렸을 때 발생하는 이벤트를 처리합니다.
			    image.addEventListener("mouseover", function (event) {
			        // 마우스 위치에 따라 레이어를 이동시킵니다.
			        detailLayer.style.left = event.pageX + "px";
			        detailLayer.style.top = event.pageY + "px";
			
			        // 레이어를 표시합니다.
			        detailLayer.style.display = "block";
			    });
			
			    // 마우스가 이미지에서 벗어났을 때 발생하는 이벤트를 처리합니다.
			    image.addEventListener("mouseout", function () {
			        // 레이어를 숨깁니다.
			        detailLayer.style.display = "none";
			    });
			</script>

			<!-- ===============내가 작성할 부분 ================ -->
		</div>
	</div>
	<%@ include file="common/bottom.jspf" %>
</body>
</html>