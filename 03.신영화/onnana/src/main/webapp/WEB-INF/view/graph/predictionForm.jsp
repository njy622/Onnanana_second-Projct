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
				<form method="post" action="/onnana/graph/prediction">
		            <input type="submit" value="미세먼지 내일 예측하기" class="btn btn-success mt-2">
		        </form>
					
		        <c:if test="${predictionSummary != null}">
		            <p class="mt-3">${predictionSummary}</p>
		        </c:if>
		        <c:if test="${predictionSummary == null}">
                	<img src="/onnana/img/clickimg.png" style="width:800px; z-index: -100; margin-left:300px">
                </c:if>
				<div class="container" style="margin-top:80px">
            		<div class="row">
					    <div class="col-4">
					        
					
					        <c:if test="${gradePm10 != null or gradePm25 != null}">
					            <h2><strong>onnana 예보</strong></h2>
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
					                        <td class="${gradePm10 eq '좋음' ? 'table-info' : 
                                                  gradePm10 eq '보통' ? 'table-success' :
                                                  gradePm10 eq '나쁨' ? 'table-warning' :
                                                  'table-danger'}">
                                                ${gradePm10}
                                            </td>
					                    </tr>
					                    <tr>
					                        <th scope="row">초미세먼지</th>
					                        <td class="${gradePm25 eq '좋음' ? 'table-info' : 
                                                  gradePm25 eq '보통' ? 'table-success' :
                                                  gradePm25 eq '나쁨' ? 'table-warning' :
                                                  'table-danger'}">
                                                ${gradePm25}
                                            </td>
					                    </tr>
					                </tbody>
					            </table>
					            <p style="font-size:12px;">
					            	출처:onnana팀 LSTM모델<br>자료출처:KOSIS/국내통계포털(https://kosis.kr/),<br>에어코리아(https://www.airkorea.or.kr/)
				            	</p>
					        </c:if>
					    </div>
					    <div class="col-2">
					    	<c:if test="${requestMethod == 'POST' and airQualityData != null}">
						    	<h2></h2>
						    	<table>
									<tbody>
									    <tr>
									        <th scope="row"></th>
									        <c:choose>
									            <c:when test="${gradePm10 == airQualityData['tomorrowPm10']}">
									                <td style="position: relative; bottom: -85px; right: -55px; text-align: center; font-size: 25px;">
									                	<strong>일치</strong>
								                	</td>
									            </c:when>
									            <c:otherwise>
									                <td style="position: relative; bottom: -85px; right: -55px; text-align: center; font-size: 25px; color: darkred;">
									                	<strong>불일치</strong>
								                	</td>
									            </c:otherwise>
									        </c:choose>
									    </tr>
									    <tr>
									        <th scope="row"></th>
									        <c:choose>
									            <c:when test="${gradePm25 == airQualityData['tomorrowPm25']}">
									                <td style="position: relative; bottom: -90px; right: -55px; text-align: center; font-size: 25px;">
									                	<strong>일치</strong>
								                	</td>
									            </c:when>
									            <c:otherwise>
									                <td style="position: relative; bottom: -90px; right: -55px; text-align: center; font-size: 25px; color: darkred;">
									                	<strong>불일치</strong>
								                	</td>
									            </c:otherwise>
									        </c:choose>
									    </tr>
									</tbody>
				            	</table>
			            	</c:if>
			            	<c:if test="${requestMethod == 'GET' and airQualityData != null}">
					        	<p class="mt-3"></p>
						    </c:if>			            	
						</div>
					    <!-- 서울시 예보 섹션 (col-4) -->
					    <div class="col-4">
					        <c:if test="${requestMethod == 'POST' and airQualityData != null}">
					            <h2><strong>서울시 예보</strong></h2>
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
					                        <td class="${airQualityData['tomorrowPm10'] eq '좋음' ? 'table-info' : 
	                                          airQualityData['tomorrowPm10'] eq '보통' ? 'table-success' :
	                                          airQualityData['tomorrowPm10'] eq '나쁨' ? 'table-warning' :
	                                          'table-danger'}">
				                                ${airQualityData['tomorrowPm10']}
				                            </td>
					                    </tr>
					                    <tr>
					                        <th scope="row">초미세먼지</th>
					                         <td class="${airQualityData['tomorrowPm25'] eq '좋음' ? 'table-info' : 
	                                          airQualityData['tomorrowPm25'] eq '보통' ? 'table-success' :
	                                          airQualityData['tomorrowPm25'] eq '나쁨' ? 'table-warning' :
	                                          'table-danger'}">
				                                ${airQualityData['tomorrowPm25']}
				                            </td>
					                    </tr>
					                </tbody>
					            </table>
					            <p style="font-size:12px;">출처:에어코리아(https://www.airkorea.or.kr/)</p>
					        </c:if>
					        <c:if test="${requestMethod == 'GET' and airQualityData != null}">
					        	<p class="mt-3"></p>
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
