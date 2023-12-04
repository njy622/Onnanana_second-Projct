<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jspf" %>
	
	    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var buttons = [
                { x: 1200, y: 1000, text: "머리", contents: "머리는 어디에 안좋을까" },
                { x: 800, y: 250, text: "몸", contents: "몸은 왜.."  },
                { x: 800, y: 350, text: "다리", contents: "다리에 알배겼어요,..."  }
            ];
            
         
            

            buttons.forEach(function(btnInfo) {
                var btn = document.createElement("button");
                btn.innerHTML = btnInfo.text;
                btn.style.position = "absolute";
                btn.style.left = btnInfo.x + "px";
                btn.style.top = btnInfo.y + "px";
                document.body.appendChild(btn);

                btn.onclick = function() {
                    var modal = document.getElementById("myModal");
                    var span = document.getElementsByClassName("close")[0];
                    var modalText = document.getElementById("modalText");

                    modal.style.display = "block";
                    modalText.innerText = "버튼 " + btnInfo.contents + "이 클릭되었습니다.";

                    span.onclick = function() {
                        modal.style.display = "none";
                    };

                    window.onclick = function(event) {
                        if (event.target == modal) {
                            modal.style.display = "none";
                        }
                    };
                };
            });
        });
   		</script>
   		
   		
   		<style>
        /* 모달 스타일 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	<div class ="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="../common/aside.jspf" %>
			<!-- ===============내가 작성할 부분 ================ -->
			<div class="col-9">
            <h3 class="mt-3"><strong>대기오염 정의 띄우는창</strong></h3>
            <hr>
            
               <!-- 이미지 -->
             <div style="position: relative;">
                 <img src="../img/body.jpg" alt="이미지" id="myImage">
               
                 <!-- 모달 -->
                 <div id="myModal" class="modal">
                     <div class="modal-content">
                         <span class="close">&times;</span>
                         <p id="modalText">모달 내용</p>
                     </div>
                 </div>
             </div>
                           
         </div>
			<!-- ===============내가 작성할 부분 ================ -->
		</div>
	</div>
	<%@ include file="../common/bottom.jspf" %>
</body>
</html>