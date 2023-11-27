<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="common/head.jspf" %>
	<link rel="stylesheet" href="styles.css">
    <title>Image Overlay Example</title>
</head>
<body>
	<%@ include file="common/top.jspf" %>
	<div class ="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="common/aside.jspf" %>
			<!-- ===============내가 작성할 부분 ================ -->
			<div class="col-9">
		 		<img src="your-image.jpg" alt="Your Image" id="mainImage">
		        <div class="overlay" id="overlay"></div>
			</div>
			<!-- ===============내가 작성할 부분 ================ -->
		</div>
	</div>
    <script src="script.js"></script>
	<%@ include file="common/bottom.jspf" %>
</body>
</html>