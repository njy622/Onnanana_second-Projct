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
			 	 <form action="/onnana/graph/disease-graph" method="post" class="d-flex align-items-end">
                    <!-- 첫 번째 변수 선택 -->
                    <div class="form-group mb-0 mr-2" style="flex-grow: 0; min-width: 0;">
                        <select class="form-control" name="variable1" style="width: 170px;">
                            <c:forEach items="${variables1}" var="variable">
                                <option value="${variable}" ${variable == selectedVariable1 ? 'selected' : ''}>${variable}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 두 번째 변수 선택 -->
                    <div class="form-group mb-0 mr-2" style="flex-grow: 0; min-width: 0; margin-left: 10px;">
                        <select class="form-control" name="variable2" style="width: 170px;">
                            <c:forEach items="${variables2}" var="variable">
                                <option value="${variable}" ${variable == selectedVariable2 ? 'selected' : ''}>${variable}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 집계 함수 선택 -->
                    <div class="form-group mb-0 mr-2" style="flex-grow: 0; min-width: 0; margin-left: 10px;">
                        <select class="form-control" name="agg_func_korean" style="width: 100px;">
                            <c:forEach items="${aggregationFunctions}" var="aggFunc">
                                <option value="${aggFunc}" ${aggFunc == selectedAggFuncKorean ? 'selected' : ''}>${aggFunc}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 제출 버튼 -->
                    <button type="submit" class="btn btn-success" style="margin-left: 10px;">질병 그래프 보기</button>
                </form>
                
                <!-- Flask 서버로부터 반환된 그래프 이미지 표시 -->
                <c:if test="${!empty graph}">
                    <img src="${graph}" alt="Disease Graph" class="img-fluid mt-3" />
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
