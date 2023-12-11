<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
   <%@ include file="../common/head.jspf" %>
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <!-- Bootstrap CSS -->
   <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

   <style>
       /* 추가된 CSS 스타일 */
       .button-container {
           position: absolute;
           top: 0;
           left: 0;
           right: 0;
           text-align: center;
           z-index: 2;
           margin-right: 0px;
       }
   </style>
 

</head>
<body>
   <%@ include file="../common/top.jspf" %>
   <div class="container" style="margin-top:80px">
      <div class="row">
         <%@ include file="../common/aside.jspf" %>
         <!-- ================ 내가 작성할 부분 =================== -->
         <div class="col-sm-9 mt-3 ms-1 position-relative">
            <div>
               <img id="myImage" src="/onnana/img/body.jpg" class="img-fluid" alt="Image" style="width:70%; z-index: 1;">
               <!-- 버튼을 포함하는 컨테이너 추가 -->
               <div class="button-container">
                   <div class="row">
                       <div class="col">
                           <button onclick="changeImage('미세먼지질환.jpg')" class="btn btn-outline-dark">미세먼지</button>
                       </div>
                       <div class="col">
                           <button onclick="changeImage('초미세먼지 질환.jpg')" class="btn btn-outline-dark">초미세먼지</button>
                       </div>
                       <div class="col">
                           <button onclick="changeImage('일산화탄소.jpg')" class="btn btn-outline-dark">일산화탄소</button>
                       </div>
                       <div class="col">
                           <button onclick="changeImage('이산화질소.jpg')" class="btn btn-outline-dark">이산화질소</button>
                       </div>
                       <div class="col">
                           <button onclick="changeImage('아황산가스.jpg')" class="btn btn-outline-dark">아황산가스</button>
                       </div>
                       <div class="col">
                           <button onclick="changeImage('대기오염물질(중금속).jpg')" class="btn btn-outline-dark">중금속</button>
                       </div>
                   </div>
               </div>
            </div>
          </div>
      </div>
   </div>

	 <script>
	    function changeImage(imageName) {
	        document.getElementById('myImage').src = '/onnana/img/' + imageName;
	    }
	</script>


   <%@ include file="../common/bottom.jspf" %>

   <!-- jQuery와 Bootstrap JS -->
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
   
</body>
</html>
