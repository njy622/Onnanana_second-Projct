<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="../common/head.jspf" %>
</head>
<body>
    <%@ include file="../common/top.jspf" %>
    <div class="container" style="margin-top:80px">
        <div class="row">
            <%@ include file="../common/aside.jspf" %>
            <div>
                <hr>
	 			<!-- 폼과 버튼을 플렉스 레이아웃으로 배치 -->
	            <form action="/onnana/graph/select-variable" method="post" class="d-flex align-items-end">
	                <div class="form-group mb-0 mr-2" style="flex-grow: 0; min-width: 0;">
	                    <select class="form-control" id="variableSelect" name="variable" style="width: 170px;">
	                        <c:forEach items="${variables}" var="variable">
	                            <option value="${variable}" ${variable == selectedVariable ? 'selected' : ''}>${variable}</option>
	                        </c:forEach>
	                    </select>
	                </div>
	                <button type="submit" class="btn btn-success"  style="margin-left: 10px;">상관관계 그래프 보기</button>
	            </form>
	
	            <!-- Flask 서버로부터 반환된 그래프를 표시 -->
	            <c:if test="${!empty graph}">
	                <img src="${graph}" alt="상관 관계 그래프" class="img-fluid mt-3" />
	            </c:if>
	            <c:if test="${empty graph}">
                	<img src="/onnana/img/clickimg.png" style="width:800px;  margin-left:300px; z-index: -100;">
                </c:if>

            </div>
        </div>
    </div>
    <%@ include file="../common/bottom.jspf" %>
</body>
</html>
