<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
   <%@ include file="../common/head.jspf" %>
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <!-- Bootstrap CSS -->
   <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
   <%@ include file="../common/top.jspf" %>
   <div class="container" style="margin-top:80px">
      <div class="row">
        <%@ include file="../common/aside.jspf" %>
         <!-- Your Section -->
         <div class="col-sm-9 mt-3 ms-1">
            <div style="position: relative;">
               <img id="myImage" src="/onnana/img/body.jpg" alt="Your Image" style="width:100%; z-index: 1;">

               <!-- Buttons dynamically created with JavaScript -->
               <script>
                  // 이미지 크기
                  var imageWidth = 850; // 이미지의 가로 크기 (픽셀)
                  var imageHeight = 850; // 이미지의 세로 크기 (픽셀)

                  // Button coordinates array
                  var buttonCoordinates = [
                     { x: 379, y: 459, modalId: "modal1" },
                     // Add more coordinates as needed
                  ];

                  buttonCoordinates.forEach((coord, index) => {
                     var xPixel = (coord.x / imageWidth) * 100;
                     var yPixel = (coord.y / imageHeight) * 100;

                     var button = document.createElement("button");
                     button.textContent = "Button " + (index + 1);
                     button.style.position = "absolute";
                     button.style.top = yPixel + "%";
                     button.style.left = xPixel + "%";
                     button.setAttribute("data-toggle", "modal");
                     button.setAttribute("data-target", "#" + coord.modalId);

                     document.body.appendChild(button);

                     // Modal
                     var modal = document.createElement("div");
                     modal.id = coord.modalId;
                     modal.className = "modal fade";
                     modal.setAttribute("role", "dialog");
                     modal.innerHTML = `
                        <div class="modal-dialog" role="document">
                           <div class="modal-content">
                              <div class="modal-header">
                                 <h5 class="modal-title">Information for Button ${index + 1}</h5>
                                 <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                 </button>
                              </div>
                              <div class="modal-body">
                                 <!-- Modal Body Content -->
                                 Any content for modal here...
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                 <!-- Additional Modal Buttons -->
                              </div>
                           </div>
                        </div>
                     `;

                     document.body.appendChild(modal);
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
