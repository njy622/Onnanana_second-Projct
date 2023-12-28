<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="../common/head.jspf" %>
    <style>
        .graph-image {
            margin-bottom: 50px;
            cursor: pointer;
            max-width: 100%;
            height: auto;
        }
    </style>
    <script>
        function openImagePopup(src) {
            var newWindow = window.open('', '_blank', 'width=1280,height=1024');
            newWindow.document.write('<img src="' + src + '" alt="변수 그래프 이미지" style="max-width:100%;height:auto;">');
        }
    </script>
</head>
<body>
    <%@ include file="../common/top.jspf" %>
    <div class="container" style="margin:130px">
        <div class="row">
            <%@ include file="../common/aside.jspf" %>
            <div>
                <!-- 이미지 표시 및 클릭 이벤트 -->
                <p style="font-size:12px;">출처:KOSIS/국내통계포털(https://kosis.kr/)</p>
                <img src="${imageData}" alt="변수 그래프 이미지" class="graph-image" onclick="openImagePopup(this.src)"/>
            </div>
        </div>
    </div>
    <%@ include file="../common/bottom.jspf" %>
</body>
</html>
