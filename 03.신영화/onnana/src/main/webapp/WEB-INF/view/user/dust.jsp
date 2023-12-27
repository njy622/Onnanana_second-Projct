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
           z-index: 2;
           display: flex;
           flex-direction: column;
           margin-left: -100px; 
       }

       /* 간격을 조절하는 CSS 스타일 추가 */
       .button-container .btn {
           margin-bottom: 5px; /* 원하는 간격에 맞게 조절하세요 */
       }

              
        #image-description {
           position: relative;
           background-color: rgba(255, 255, 255, 0.8);
           padding: 10px;
           margin-top: 20px; /* 이미지 아래로 이동시키기 위한 값으로 조절하세요 */
       }
       /* 추가된 CSS 스타일 */
       .additional-image-container {
           position: relative;
           top: 0;
           left: 0;
           z-index: 2;
           margin-left: 200px; /* 오른쪽 여백 조절 가능 */
       }
       
       /* 추가된 스타일 */
        #openModalBtn {
            display: none; /* 초기에는 모달 열기 버튼을 숨김 */
        } 

   </style>
</head>
<body>
   <%@ include file="../common/top.jspf" %>
   <div class="container" style="margin-top: 150px; margin-bottom: 100px; margin-left: 200px;">
   
      <div class="row">
         <%@ include file="../common/aside.jspf" %>
         <!-- ================ 내가 작성할 부분 =================== -->
         <div class="col-6">
            <div class="image-container">
               <!-- 이미지를 표시하는 부분 -->
               <img id="myImage" src="/onnana/img/body.jpg" class="img-fluid" alt="Image" style="width:100%;">
           </div>
           
             <div class="button-container">
                <button onclick="changeImage('body.jpg', '')" class="btn btn-outline-info" data-image="body.jpg">초기화면</button>
                <button onclick="changeImage('미세먼지질환.jpg', '미세먼지(PM-10)란?', '미세먼지그래프.png')" class="btn btn-outline-info" data-image="미세먼지질환.jpg">미세먼지</button>
                <button onclick="changeImage('초미세먼지 질환.jpg', '초미세먼지(PM-2.5)란?', '초미세먼지그래프.png')" class="btn btn-outline-info" data-image="초미세먼지 질환.jpg">초미세먼지</button>
                <button onclick="changeImage('일산화탄소.jpg', '일산화탄소(CO)란?','일산화탄소그래프.png')" class="btn btn-outline-info" data-image="일산화탄소.jpg">일산화탄소</button>
                <button onclick="changeImage('이산화질소.jpg', '이산화질소(NO2)란?', '이산화질소그래프.png')" class="btn btn-outline-info" data-image="이산화질소.jpg">이산화질소</button>
                <button onclick="changeImage('아황산가스.jpg', '아황산가스(SO2)란?','아황산가스그래프.png')" class="btn btn-outline-info" data-image="아황산가스.jpg">아황산가스</button>
                <button onclick="changeImage('대기오염물질(중금속).jpg', '중금속이란?','중금속그래프.png')" class="btn btn-outline-info" data-image="대기오염물질(중금속).jpg">중금속</button>
           	</div>
			
			<!-- 추가 이미지가 표시될 공간 -->
           <div id="additionalImageContainer" class="additional-image-container">
             
           </div>
			
			
         </div>
         

      <!-- 그래프 이미지 및 설명을 표시하는 부분 추가 -->
       <div class="col-5">
          <div class="image-description" id="image-description">
              <h5 id="description-title" class="text-info"></h5>
              <p id="description-content"></p>
              <p style="font-size:12px;">출처:서울특별시 대기환경정보(https://cleanair.seoul.go.kr/information/info151)</p>
              
              <button id="openModalBtn" type="button" class="btn btn-outline-info" onclick="openModal()">
                  그래프 보기
              </button>
          </div>
      </div>
      </div>
   </div>

<!-- 부트스트랩 모달 -->
<div class="modal fade" id="imageModal" tabindex="-1" role="dialog" aria-labelledby="imageModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-m" role="document">
      <div class="modal-content">
         <div class="modal-body">
            <img id="modalImage" src="" class="img-fluid" alt="추가 이미지" style="width: 100%;">
            <p style="font-size:12px; float:right;">출처:KOSIS/국내통계포털(https://kosis.kr/)</p>
            <hr>
            <!-- 닫기 버튼을 추가합니다 -->
         </div>
      </div>
   </div>
</div>


<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

<!-- Popper.js, Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


   <script>
      const imageDescriptions = {
         'body.jpg': `
            <img src="/onnana/img/안내2.png" style="width:130%; margin-left:-200px;">
         `,
         '미세먼지질환.jpg': `<hr>
             <p>미세먼지는 초미세먼지(PM-2.5)와 미세먼지(PM-10)으로 구분된다.
             초미세먼지(PM-2.5)는 직경이 2.5㎛이하인 먼지이며, 미세먼지(PM-10)은 직경이 10㎛이하인 먼지이다.
             
             일반적으로 사람 머리카락 두께와 비교할 때 초미세먼지(PM-2.5)는 1/20∼1/30, 미세먼지(PM-10)는 1/6∼1/7일 정도로 매우 작다.
            
             (초)미세먼지는 주로 산업시설, 자동차, 난방 및 에너지 사용 등으로 인해 직접적으로 1차 배출되기도 하고, 황산염, 질산염과 같이 대기 중 반응에 의해 2차 생성되기도 한다. 주요 구성성분은 이온성분(SO42+, NO32-, NH4+), 탄소성분(유기탄소, 원소탄소), 금속화합물 등이다.
             
             (초)미세먼지를 흡입했을 때 기도에서 걸러지지 못하고 대부분 폐포까지 침투하여 심장질환과 호흡기질환을 유발하여 조기 사망률을 증가시킨다.
             또한, 시정을 악화시키고, 식물의 잎 표면에 침적되어 신진대사를 방해하며, 건축물에 퇴적되어 부식을 일으킨다.</p>
             `,
             
         '초미세먼지 질환.jpg': `<hr> 
            미세먼지는 초미세먼지(PM-2.5)와 미세먼지(PM-10)으로 구분된다.
           초미세먼지(PM-2.5)는 직경이 2.5㎛이하인 먼지이며, 미세먼지(PM-10)은 직경이 10㎛이하인 먼지이다.
          
           일반적으로 사람 머리카락 두께와 비교할 때 초미세먼지(PM-2.5)는 1/20∼1/30, 미세먼지(PM-10)는 1/6∼1/7일 정도로 매우 작다.
           
           (초)미세먼지는 주로 산업시설, 자동차, 난방 및 에너지 사용 등으로 인해 직접적으로 1차 배출되기도 하고, 황산염, 질산염과 같이 대기 중 반응에 의해 2차 생성되기도 한다. 주요 구성성분은 이온성분(SO42+, NO32-, NH4+), 탄소성분(유기탄소, 원소탄소), 금속화합물 등이다.
           
           (초)미세먼지를 흡입했을 때 기도에서 걸러지지 못하고 대부분 폐포까지 침투하여 심장질환과 호흡기질환을 유발하여 조기 사망률을 증가시킨다.
           또한, 시정을 악화시키고, 식물의 잎 표면에 침적되어 신진대사를 방해하며, 건축물에 퇴적되어 부식을 일으킨다.`,
           
         '일산화탄소.jpg': `<hr>
            일산화탄소(CO)는 무색, 무취의 맹독성 기체로 주로 연료의 불완전 연소로 발생된다.
            가장 중요한 일산화탄소 배출원은 주로 수송분야로 교통체증이 심한 도심지역에서 고농도의 일산화탄소 오염이 많이 관측되고 있다. 자동차 외에는 코크스 연료, 제련, 석유화학 등 화기를 취급하는 산업공정과 발전, 유기합성 공업 등이 주요 배출원이다. 실내에서도 주방, 담배연기, 지역난방 등이 발생원이 되며 자연적으로는 산불 등이 있다.

            일산화탄소는 체내 산소를 운반하는 역할을 하는 헤모글로빈(산소보다 210배 강한 결합력)을 카르복실헤모글로빈 (COHb)으로 변성시켜 혈액의 산소운반능력을 저하시킨다. 이로 인해 뇌조직 및 신경계통에 주로 피해를 주어 운동신경, 근육마비, 사고능력 저하 등의 치명적인 피해를 가져오고 심하면 사망에 이르기도 한다.`,
            
         '이산화질소.jpg': `<hr>
            이산화질소(NO2)는 반응성이 크며, 적갈색의 자극성 냄새가 있는 유독한 기체이다(NO2의 독성은 NO의 5~10배). 질소산화물(NOx: NO2, N2O, NO, N2O3 등) 중에 대기오염에 가장 영향이 큰 물질로 휘발성유기화합물(VOCs)과 반응하여 오존(O3)을 생성하는 전구물질(Precursor) 역할을 하기도 한다.
            주요 배출원은 자동차와 발전소와 같은 고온 연소공정과 화학물질 제조공정 등에서 연소과정 또는 연소 후 NO의 산화로 생성되며, 토양 중의 세균에 의해 생성되기도 한다.

            고농도에 노출되었을 시 눈과 호흡기 등에 자극을 주어 기침, 현기증, 두통, 구토 등이 나타나고 심하면 폐수종, 폐렴, 폐출혈, 혈압상승으로 의식을 잃기도 한다. 저농도에 장시간 노출되어도 만성중독으로 기관지염, 폐기종, 위장병 등을 일으키며 혈당감소, 헤모글로빈의 증가 등을 가져온다. 식물에 대한 피해로는 식물세포를 파괴하여 꽃식물의 잎에 갈색이나 흑갈색의 반점이 생기게 한다.`,

         '아황산가스.jpg': `<hr>
            아황산가스(SO2)는 황산화물(SOx)의 대표적인 가스상 대기오염물질로 불쾌하고 자극적인 냄새가 나는 무색의 불연성 기체이다.
            황산화물(SOx)은 황을 함유한 석탄, 석유 등의 화석연료가 연소할 때 주로 배출되며 아황산가스(SO2), 삼산화황(SO3), 아황산(H2SO3), 황산(H2SO4) 등을 포함하지만 그 중 아황산가스(SO2)가 대부분을 차지하므로 대기오염과 관련해서는 아황산가스(SO2) 실측을 주로 하고 있다.

            주요 인위적 배출원은 발전소, 금속제련공장, 난방장치, 석유정제, 황산제조와 같은 산업공정 등이며, 자연적으로는 화산, 온천 등에 존재한다. 또한 광화학반응이나 촉매반응에 의하여 다른 오염물질과 반응하여 2차 오염물질을 생성하고 대기 중 습도가 높을 때는 아황산, 황산 미스트 등을 생성하여 시정감소, 각종 구조물의 부식, 생태계와 인간에 악영향을 미치게 된다.

            아황산가스(SO2)는 고농도에서 비강과 인후에 많이 흡수되며 점막액과 반응하여 황산을 형성해 염증을 일으키고 눈, 코, 기도 등을 자극하여 옥외 활동이 많고 천식에 걸린 어른과 어린이에게 일시적으로 호흡장애를 일으킬 수 있다. 아황산가스(SO2)에 의한 급성피해로는 불쾌한 자극성 냄새, 시정감소, 생리적 장애, 압박감, 기도저항 증가 등이 있고 계속된 노출에 의한 만성피해로는 폐렴, 기관지염, 천식, 폐기종, 폐쇄성 질환 등이 나타나게 된다.`,
            
         '대기오염물질(중금속).jpg':`<hr>
            중금속(重金屬)이란 용어는 여러 의미를 가지고 있다. 화학자들 사이에서 일반적으로 받아들여지는 정의에 따르면, 중금속은 주기율표에서 구리와 납 사이에 있는 원자 질량이 63.546 에서 200.590 사이이고, 비중이 4.5보다 큰 원소 집합을 말한다.
            중금속에 대한 좀 더 엄격한 정의는 중금속을 희토류 금속보다 무거운 금속으로 제한하여 정의하고 있다. 이러한 원소들 중 생물학적 체계에 필수적인 원소는 없다. 잘 알려진 비스무트나 금을 제외하고는 모두 치명적인 독성을 가지고 있다.

            현재 서울시에서 매월 측정하고 있는 중금속은 납(Pb), 카드뮴(Cd), 크롬(Cr), 구리(Cu), 망간(Mn), 철(Fe), 니켈(Ni), 비소(As), 베릴늄(Be), 알루미늄(Al), 칼슘(Ca), 마그네슘(Mg) 12개 항목이다. 현재 납에 대하여만 환경기준을 갖고 있다.`
      };

   // 페이지 로드 시 초기 이미지와 설명을 표시하는 함수
      window.onload = function () {
          // 기본 이미지와 설명 설정
          changeImage('body.jpg', '');
          // 초기 버튼을 선택된 상태로 변경
          var initialButton = document.querySelector("button[data-image='body.jpg']");
          if (initialButton) {
              initialButton.classList.add('active');
          }
      };

      function changeImage(imageName, descriptionTitle, additionalImageName) {
          document.getElementById('myImage').src = '/onnana/img/' + imageName;
          document.getElementById('description-title').innerHTML = '<strong>' + descriptionTitle + '</strong>';
          document.getElementById('description-content').innerHTML = imageDescriptions[imageName];

          // 선택된 버튼 변경
          var activeButton = document.querySelector('.btn.btn-outline-info.active');
          if (activeButton) {
              activeButton.classList.remove('active');
          }

          var currentButton = document.querySelector("button[data-image='" + imageName + "']");
          if (currentButton) {
              currentButton.classList.add('active');
          }

          // 모달 열기 버튼 표시 및 모달 이미지 업데이트
          var openModalBtn = document.getElementById('openModalBtn');
          var modalImage = document.getElementById('modalImage');
          if (additionalImageName) {
              modalImage.src = '/onnana/img/' + additionalImageName;
              openModalBtn.style.display = 'block';
          } else {
              openModalBtn.style.display = 'none';
          }
      }

      // 모달 열기 버튼 클릭 시 모달 열기
      function openModal() {
          $('#imageModal').modal('show');
      }
      
   // 모달 창 닫기 이벤트 핸들링
      function closeModal() {
          console.log('closeModal function called'); // 디버깅을 위한 출력
          $('#imageModal').modal('hide');
      }

      // 문서 로드 후 초기 설정
      $(document).ready(function () {
          // 여기에 초기 설정 코드 추가

          // 닫기 버튼 클릭 시 closeModal 함수 호출
          $('#imageModal .close, #imageModal button[data-dismiss="modal"]').on('click', function () {
              closeModal();
          });

      });


   
   

   </script>


   <%@ include file="../common/bottom.jspf" %>

   <!-- jQuery와 Bootstrap JS -->
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>