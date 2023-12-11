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
        <div class="col-9">
            <h3 class="mt-3"><strong>기상 예보 띄우는창</strong></h3>
            <hr>
            <div class="container" id="map" style="height: 500px; position: relative;">
	            <!-- 이미지 표시 -->
	    		<img id="cartogram" src="/onnana/img/카토그램.png" alt="Example Image">
                <!-- 여러 개의 버튼 -->
                <c:forEach var="index" begin="1" end="2">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${437 + (29 * (index - 1))}px; left: 478px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="22">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${401 + (29 * (index - 1))}px; left: 507px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="24">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${313 + (29 * (index - 1))}px; left: 544px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="23">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${313 + (29 * (index - 1))}px; left: 581px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="22">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${313 + (29 * (index - 1))}px; left: 618px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="22">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${313 + (29 * (index - 1))}px; left: 654px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="23">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${284 + (29 * (index - 1))}px; left: 692px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="23">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${284 + (29 * (index - 1))}px; left: 729px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="21">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${284 + (29 * (index - 1))}px; left: 765px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="21">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${284 + (29 * (index - 1))}px; left: 801px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="18">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${372 + (29 * (index - 1))}px; left: 837px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <c:forEach var="index" begin="1" end="8">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${575 + (29 * (index - 1))}px; left: 874px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <form action="${pageContext.request.contextPath}/buttonAction" method="post" style="position: absolute; top: 516px; left: 911px;">
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