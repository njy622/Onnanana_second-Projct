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
				<form action="/onnana/graph/corona-graph" method="post" class="d-flex flex-wrap align-items-end">
                    <!-- 시도 선택 -->
                    <div class="form-group mb-0 mr-2" style="flex-grow: 0; min-width: 0;">
                        <select class="form-control" name="sido" style="width: 170px;">
                            <c:forEach var="sido" items="${sidos}">
                                <option value="${sido}" ${sido == selectedSido ? 'selected' : ''}>${sido}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- 변수 선택 -->
                    <div class="form-group mb-0 mr-2" style="flex-grow: 0; min-width: 0; margin-left: 10px;">
                        <select class="form-control" name="variable" style="width: 170px;">
                            <c:forEach var="variable" items="${variables}">
                                <option value="${variable}" ${variable == selectedVariable ? 'selected' : ''}>${variable}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 제출 버튼 -->
                    <button type="submit" class="btn btn-success" style="margin-left: 10px;">코로나 그래프 보기</button>

                    <!-- 유사한 증감폭 메시지 표시 -->
                    <c:if test="${not empty similarImpact}">
                        <span style="margin-left: 10px;" class="align-self-center">${similarImpact}</span>
                    </c:if>
                </form>
               
                <!-- 이미지 및 추가적인 정보 표시 부분 -->
                <c:if test="${not empty graph}">
	       			<p style="font-size:12px;">출처:KOSIS/국내통계포털(https://kosis.kr/)</p>
                    <img src="${graph}" alt="코로나19 기간 대비 데이터 비교 그래프" class="img-fluid mt-3" />
                </c:if>
                <c:if test="${empty graph}">
                	<img src="/onnana/img/clickimg.png" style="width:800px; z-index: -100; margin-left:300px">
                </c:if>
            </div>
        </div>
    </div>
    <%@ include file="../common/bottom.jspf" %>
</body>
</html>
