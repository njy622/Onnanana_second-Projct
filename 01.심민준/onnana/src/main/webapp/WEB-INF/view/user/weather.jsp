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
        }

        .transparent-button {
            background-color: transparent;
            border: none;
            color: white;
            cursor: pointer;
            width: 36px; /* 버튼의 너비 설정 */
            height: 29px; /* 버튼의 높이 설정 */
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
            <div id="map" style="height: 500px;">
                <!-- 이미지 표시 -->
                <img id="cartogram" src="/onnana/img/카토그램.png" alt="Example Image">
                <!-- 인천 옹진 ~ 태안 -->
                <c:forEach var="index" begin="1" end="2">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${575 + (29 * (index - 1))}px; left: 434px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 신안 ~ 진도 -->
                <c:forEach var="index" begin="1" end="4">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${893 + (29 * (index - 1))}px; left: 434px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 인천 강화 ~ 서구 -->
                <c:forEach var="index" begin="1" end="2">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${430 + (29 * (index - 1))}px; left: 470px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 인천 중구 ~ 보령 -->
                <c:forEach var="index" begin="1" end="5">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${546 + (29 * (index - 1))}px; left: 470px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 고창 ~ 강진 -->
                <c:forEach var="index" begin="1" end="7">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${807 + (29 * (index - 1))}px; left: 470px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 김포 ~ 완도 -->
                <c:forEach var="index" begin="1" end="22">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${401 + (29 * (index - 1))}px; left: 507px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 양주 ~ 보성 -->
                <c:forEach var="index" begin="1" end="24">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${313 + (29 * (index - 1))}px; left: 544px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 동두천 ~ 고흥 -->
                <c:forEach var="index" begin="1" end="23">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${313 + (29 * (index - 1))}px; left: 581px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 연천 ~ 여수 -->
                <c:forEach var="index" begin="1" end="22">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${313 + (29 * (index - 1))}px; left: 618px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 포천 ~ 남해 -->
                <c:forEach var="index" begin="1" end="22">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${313 + (29 * (index - 1))}px; left: 654px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 철원 ~ 통영 -->
                <c:forEach var="index" begin="1" end="23">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${284 + (29 * (index - 1))}px; left: 692px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 화천 ~ 거제 -->
                <c:forEach var="index" begin="1" end="23">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${284 + (29 * (index - 1))}px; left: 729px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 양구 ~ 김해 -->
                <c:forEach var="index" begin="1" end="21">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${284 + (29 * (index - 1))}px; left: 765px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 고성 ~ 부산 영도 -->
                <c:forEach var="index" begin="1" end="21">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${284 + (29 * (index - 1))}px; left: 801px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 강릉 ~ 부산 남구 -->
                <c:forEach var="index" begin="1" end="18">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${372 + (29 * (index - 1))}px; left: 837px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 포항 북구 ~ 부산 해운대 -->
                <c:forEach var="index" begin="1" end="8">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${575 + (29 * (index - 1))}px; left: 874px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 제주 ~ 서귀포 -->
                <c:forEach var="index" begin="1" end="2">
                    <form action="${pageContext.request.contextPath}/buttonAction" method="post"
                          style="position: absolute; top: ${1009 + (29 * (index - 1))}px; left: 618px;">
                        <input type="hidden" name="buttonIndex" value="${index}" />
                        <button type="submit" class="transparent-button"> </button>
                    </form>
                </c:forEach>
                <!-- 울릉 -->
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
