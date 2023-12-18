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
            position: relative; /* 이미지 위치 기준으로 버튼을 배치하기 위해 상대 위치 설정 */
        }

        .transparent-button {
            background-color: transparent;
            position: absolute;
            cursor: pointer;
            border: none;
            padding: 0;
        }
    </style>

</head>
<body>
<%@ include file="../common/top.jspf" %>
<div class="container" style="margin-top:80px">
    <div class="row">
        <%@ include file="../common/aside.jspf" %>
        <!-- ================ 내가 작성할 부분 =================== -->
        <div class="col-sm-9 mt-3 ms-1">
       		<title>대기 품질 정보 조회</title>
		
	    
		    
		    <table class="table">
		    	<tr>
		    		<th>이미지</th>
		    		<th>생활지수</th>
		    		<th>지수</th>
		    		<th>안내멘트</th>
		    	</tr>
		    	<c:forEach var="line" items="${data}">
		    		<tr>
		    			<td><img src="${line[0]}" height="48"></td>
		    			<td>${line[1]}</td>
		    			<td>${line[2]}</td>
		    			<td>${line[3]}</td>
		    		</tr>
		    	</c:forEach>
		    </table>
		    
		
		</div>    
    </div> 
</div>
<%@ include file="../common/bottom.jspf" %>
</body>
</html>