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
         <div class="col-sm-9 mt-5 ms-1">
            <div style="position: relative;">
               <img id="myImage" src="/onnana/img/body.jpg" alt="Your Image" style="width:100%; z-index: 1;">

               <!-- Buttons dynamically created with JavaScript -->
               <script>
                  var imageWidth = 850;
                  var imageHeight = 850;

                  var buttonCoordinates = [
                     { x: 465, y: 150, modalId: "뇌졸증", modalContent: "뇌졸증은 무엇때문에 나타나는가?" },
                     { x: 465, y: 200, modalId: "비염", modalContent: "비염에 대한 정보" },
                     { x: 465, y: 250, modalId: "천식", modalContent: "천식에 대한 정보" },
                     { x: 490, y: 360, modalId: "심장", modalContent: "심장 질환에 대한 정보" },
                     { x: 530, y: 540, modalId: "아토피", modalContent: "아토피에 대한 정보" }
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
                     button.setAttribute("data-toggle", "modal");
                     button.setAttribute("data-target", "#" + coord.modalId);
                     button.setAttribute("data-content", coord.modalContent);
               
                     document.body.appendChild(button);

                     var modal = document.createElement("div");
                     modal.id = coord.modalId;
                     modal.className = "modal fade";
                     modal.setAttribute("role", "dialog");
                     modal.innerHTML = `
                        <div class="modal-dialog" role="document">
                           <div class="modal-content">
                              <div class="modal-header">
                                 <h5 class="modal-title">${coord.modalId}</h5>
                                 <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                 </button>
                              </div>
                              <div class="modal-body">
                                 <p>${coord.modalContent}</p>
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     `;

                     document.body.appendChild(modal);
                  });
                  
                  $(document).on('click', 'button', function() {
                      var modalId = $(this).attr('data-target').replace('#', '');
                      var modal = $('#' + modalId);
                      var modalTitle = modal.find('.modal-title');
                      modalTitle.text($(this).text());
                      
                      var modalContent = $(this).attr('data-content');
                      var modalBody = modal.find('.modal-body p');
                      modalBody.text(modalContent);
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