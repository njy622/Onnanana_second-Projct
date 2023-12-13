<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
   <%@ include file="../common/head.jspf" %>
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <!-- Bootstrap CSS -->
   <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
   <style>
       .popover {
           max-width: none;
       }
       /* 추가한 스타일 */
       #popover-image {
           max-width: 100%; /* 원하는 최대 너비 */
           max-height: 400px; /* 원하는 최대 높이 */
           object-fit: contain; /* 이미지 비율 유지 */
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
            <div style="position: relative;">
               <img id="myImage" src="/onnana/img/body.jpg" alt="Your Image" style="width:100%; z-index: 1;">

               <!-- Buttons dynamically created with JavaScript -->
               <script>
                  var imageWidth = 850;
                  var imageHeight = 850;

                  var buttonCoordinates = [
                    { x: 465, y: 150, modalId: "뇌졸증", modalContent: "뇌졸증은 무엇때문에 나타나는가?", imageUrl: "/onnana/img/비염상관관계.png", dataImageUrl: "/onnana/img/비염상관관계.png" },                    
                     { x: 465, y: 200, modalId: "비염", modalContent: "비염에 대한 정보" , imageUrl: "/onnana/img/비염상관관계.png", dataImageUrl: "/onnana/img/비염상관관계.png" },
                     { x: 465, y: 250, modalId: "천식", modalContent: "천식에 대한 정보", imageUrl: "/onnana/img/비염상관관계.png", dataImageUrl: "/onnana/img/비염상관관계.png" },
                     { x: 490, y: 360, modalId: "심장", modalContent: "심장 질환에 대한 정보" , imageUrl: "/onnana/img/비염상관관계.png", dataImageUrl: "/onnana/img/비염상관관계.png" },
                     { x: 530, y: 540, modalId: "아토피", modalContent: "아토피에 대한 정보" , imageUrl: "/onnana/img/비염상관관계.png", dataImageUrl: "/onnana/img/비염상관관계.png" }
                  ];

                  buttonCoordinates.forEach((coord, index) => {
                     var xPixel = (coord.x / imageWidth) * 100;
                     var yPixel = (coord.y / imageHeight) * 100;
                     
                     var button = document.createElement("button");
                     button.textContent = coord.modalId;
                     button.style.width = '80px';
                     button.style.height = '30px';
                     button.style.position = "absolute";
                     button.style.top = yPixel + "%";
                     button.style.left = xPixel + "%";
                     button.setAttribute("data-toggle", "popover");
                     button.setAttribute("data-placement", "bottom"); // 각 버튼에 팝오버 위치 설정
                     button.setAttribute("title", coord.modalId);
                     button.setAttribute("data-content", coord.modalContent);
                     button.setAttribute("data-image-url", coord.dataImageUrl);
               
                     document.body.appendChild(button);
                 });

                  $(document).ready(function() {
                      $('[data-toggle="popover"]').popover({
                          trigger: 'hover',
                          html: true,
                          content: function() {
                              return '<p>' + $(this).data('content') + '</p>' +
                                  '<img id="popover-image" src="' + $(this).data('image-url') + '" alt="' + $(this).text() + '">';
                          },
                          title: function() {
                              return $(this).attr('title');
                          }
                      }).on('inserted.bs.popover', function() {
                          var imageSize = $('#popover-image')[0].getBoundingClientRect();
                          var popover = $('.popover')[0];
                          popover.style.width = imageSize.width + 'px';
                          popover.style.height = imageSize.height + 'px';
                      });
                  });

             </script>

            </div>
         </div>
         <!-- End of Your Section -->
      </div>
   </div>
   <%@ include file="../common/bottom.jspf" %>

   <!-- jQuery and Bootstrap JS -->
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
