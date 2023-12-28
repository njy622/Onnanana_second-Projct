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
				 <!-- "미세먼지 내일 예측하기" 버튼과 예측 결과 섹션 (col-4) -->
				<div class="container" style="margin-top:80px">
            		<div class="row">
					    <div class="col-4">
					        <form method="post" action="/onnana/graph/prediction">
					            <input type="submit" value="미세먼지 내일 예측하기" class="btn btn-primary mt-2">
					        </form>
					
					        <c:if test="${predictionSummary != null}">
					            <p class="mt-3">${predictionSummary}</p>
					        </c:if>
					
					        <c:if test="${gradePm10 != null or gradePm25 != null}">
					            <h2>서울시 예보</h2>
					            <table class="table table-bordered mt-3">
					                <thead>
					                    <tr>
					                        <th scope="col">구분</th>
					                        <th scope="col">내일</th>
					                    </tr>
					                </thead>
					                <tbody>
					                    <tr>
					                        <th scope="row">미세먼지</th>
					                        <td>${gradePm10}</td>
					                    </tr>
					                    <tr>
					                        <th scope="row">초미세먼지</th>
					                        <td>${gradePm25}</td>
					                    </tr>
					                </tbody>
					            </table>
					            <p>-출처(onnana팀)-</p>
					        </c:if>
					    </div>
					
					    <!-- 서울시 예보 섹션 (col-4) -->
					    <div class="col-4">
					        <c:if test="${requestMethod == 'POST' and airQualityData != null}">
					            <h2>서울시 예보</h2>
					            <table class="table table-bordered mt-3">
					                <thead>
					                    <tr>
					                        <th scope="col">구분</th>
					                        <th scope="col">내일</th>
					                    </tr>
					                </thead>
					                <tbody>
					                    <tr>
					                        <th scope="row">미세먼지</th>
					                        <td>${airQualityData['tomorrowPm10']}</td>
					                    </tr>
					                    <tr>
					                        <th scope="row">초미세먼지</th>
					                        <td>${airQualityData['tomorrowPm25']}</td>
					                    </tr>
					                </tbody>
					            </table>
					            <p>-출처(에어코리아)-</p>
					        </c:if>
					        <c:if test="${requestMethod == 'GET' and airQualityData != null}">
					        	<p class="mt-3">로딩 중...</p>
						    </c:if>
					    </div>
				    </div>
			    </div>
            </div>
        </div>
    </div>
    <%@ include file="../common/bottom.jspf" %>
</body>
</html>
