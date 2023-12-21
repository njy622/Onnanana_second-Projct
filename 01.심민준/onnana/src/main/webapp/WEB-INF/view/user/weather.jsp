<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <%@ include file="../common/head.jspf" %>
     <style>
         #map-container {
            position: relative;
            display: inline-block;
            width: 800px;
       }
        #cartogram {
          width: 100%; /* 이미지의 가로 크기를 부모 컨테이너에 맞추기 */
          height: auto; /* 세로 크기는 자동으로 조절 */
          z-index: -1;
      }
      
        .weather-button {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 12px 15px;
            background-color: transparent;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        
        .weather-info {
            position: absolute;
          margin-left: 50px; /* 왼쪽 여백 설정 */
          padding: 10px;
          text-align: center; 
          font-size: 20px;
      }
      
      .weather-info2 {
            position: absolute;
          margin-left: 50px; /* 왼쪽 여백 설정 */
          text-align: left; 
          font-size: 14px;
          
      }
      
      
      th {
         width: 500px;
         height: 100px;
         text-align: center;
      }
      
      td {
         text-align: center;
      }
      
       .table-cell {
           position: relative; /* 포지션 설정 */
           width: 100px; /* 원하는 셀 너비로 설정 */
           height: 100px; /* 원하는 셀 높이로 설정 */
           z-index: 999;
       }
   
       .table-cell::before {
           content: ""; /* 가상 요소 생성 */
           position: absolute; /* 절대 위치 설정 */
           top: 10px;
           left: 20px;
           right: 0;
           bottom: 25px;
           width: 80px; 
           height: 80px; 
           background-image: url('/onnana/img/backimg.png'); /* 배경 이미지 설정 */
           background-size: cover; /* 이미지 크기 조절 */
           z-index: -1; /* 이미지를 텍스트 뒤로 보냄 */
       }
   
       .text {
           position: relative; /* 포지션 설정 */
           z-index: 999; /* 텍스트를 이미지 위로 올림 */
       }
       /* 부모 요소인 h4에 display: inline-block 설정 */
       h4 {
           display: inline-block;
       }
   
       /* 클릭한 버튼 ID 요소를 inline-block으로 설정하여 한 줄에 표시 */
       #clickedButtonId {
           display: inline-block;
       }   
       
       .Express {
       z-index: 999; /* 이미지 위에 텍스트*/
       }
      
    </style>
     <script>
     document.addEventListener('DOMContentLoaded', function() {
         const buttons = document.querySelectorAll('.weather-button');
         const displayId = document.getElementById('clickedButtonId');

         buttons.forEach(button => {
             button.addEventListener('click', function(event) {
                 const clickedButtonId = this.id;
            document.querySelector("span").innerHTML = "(" + clickedButtonId + ")";
                 // HTML 화면에 출력
             });
         });
     });
    
     </script>
</head>
<body>
<%@ include file="../common/top.jspf" %>
<div class="container" style="margin-top:80px">
    <div class="row">
      <%@ include file="../common/aside.jspf" %>
        <!-- ================ 내가 작성할 부분 =================== -->
        <div class="col-md-6">
            <div class="container" id="map-container">
               <!-- 이미지 표시 -->
             <img id="cartogram" src="/onnana/img/카토그램.png" alt="Example Image">
             <!-- 각 버튼에는 고유한 id와 공통된 클래스를 할당합니다. -->
            <button id="인천옹진" class="weather-button" data-nx="54" data-ny="124" data-name="영흥" style="top: 398px;left: 126px;"> </button>
            <button id="태안" class="weather-button" data-nx="48" data-ny="109" data-name="원북면" style="top: 425px;left: 126px;"> </button>
            <button id="신안" class="weather-button" data-nx="50" data-ny="66" data-name="신안군" style="top: 695px;left: 126px;"> </button>
            <button id="목포" class="weather-button" data-nx="50" data-ny="67" data-name="부흥동" style="top: 722px;left: 126px;"> </button>
            <button id="해남" class="weather-button" data-nx="54" data-ny="61" data-name="해납읍" style="top: 749px;left: 126px;"> </button>
            <button id="진도" class="weather-button" data-nx="48" data-ny="59" data-name="진도읍" style="top: 776px;left: 126px;"> </button>
            <button id="인천강화" class="weather-button" data-nx="51" data-ny="130" data-name="길상" style="top: 263px;left: 160px;"> </button>
            <button id="인천서구" class="weather-button" data-nx="97" data-ny="74" data-name="검단" style="top: 290px;left: 160px;"> </button>
            <button id="인천중구" class="weather-button" data-nx="54" data-ny="125" data-name="신흥" style="top: 371px;left: 160px;"> </button>
            <button id="인천연수" class="weather-button" data-nx="55" data-ny="123" data-name="동춘" style="top: 398px;left: 160px;"> </button>
            <button id="서산" class="weather-button" data-nx="51" data-ny="110" data-name="대산리" style="top: 425px;left: 160px;"> </button>
            <button id="홍성" class="weather-button" data-nx="55" data-ny="106" data-name="내포" style="top: 452px;left: 160px;"> </button>
            <button id="보령" class="weather-button" data-nx="54" data-ny="100" data-name="대천2동" style="top: 479px;left: 160px;"> </button>
            <button id="고창" class="weather-button" data-nx="56" data-ny="80" data-name="고창읍" style="top: 614px;left: 160px;"> </button>
            <button id="영광" class="weather-button" data-nx="52" data-ny="77" data-name="영광읍" style="top: 641px;left: 160px;"> </button>
            <button id="함평" class="weather-button" data-nx="52" data-ny="72" data-name="함평읍" style="top: 668px;left: 160px;"> </button>
            <button id="무안" class="weather-button" data-nx="52" data-ny="71" data-name="무안읍" style="top: 695px;left: 160px;"> </button>
            <button id="나주" class="weather-button" data-nx="56" data-ny="71" data-name="빛가람동" style="top: 722px;left: 160px;"> </button>
            <button id="영암" class="weather-button" data-nx="56" data-ny="66" data-name="대불" style="top: 749px;left: 160px;"> </button>
            <button id="강진" class="weather-button" data-nx="57" data-ny="63" data-name="강진읍" style="top: 776px;left: 160px;"> </button>
            <button id="김포" class="weather-button" data-nx="55" data-ny="128" data-name="고촌읍" style="top: 236px;left: 195px;"> </button>
            <button id="부천" class="weather-button" data-nx="56" data-ny="125" data-name="내동" style="top: 263px;left: 195px;"> </button>
            <button id="인천동구" class="weather-button" data-nx="54" data-ny="125" data-name="송림" style="top: 290px;left: 195px;"> </button>
            <button id="인천계양" class="weather-button" data-nx="56" data-ny="126" data-name="계산" style="top: 317px;left: 195px;"> </button>
            <button id="인천부평" class="weather-button" data-nx="55" data-ny="125" data-name="부평" style="top: 344px;left: 195px;"> </button>
            <button id="인천미추홀" class="weather-button" data-nx="54" data-ny="124" data-name="숭의" style="top: 371px;left: 195px;"> </button>
            <button id="인천남동" class="weather-button" data-nx="56" data-ny="124" data-name="고잔" style="top: 398px;left: 195px;"> </button>
            <button id="당진" class="weather-button" data-nx="54" data-ny="112" data-name="당진시청사" style="top: 425px;left: 195px;"> </button>
            <button id="예산" class="weather-button" data-nx="58" data-ny="107" data-name="고덕면(충남)" style="top: 452px;left: 195px;"> </button>
            <button id="청양" class="weather-button" data-nx="57" data-ny="103" data-name="정산면" style="top: 479px;left: 195px;"> </button>
            <button id="부여" class="weather-button" data-nx="59" data-ny="99" data-name="부여읍" style="top: 506px;left: 195px;"> </button>
            <button id="서천" class="weather-button" data-nx="55" data-ny="94" data-name="서면" style="top: 533px;left: 195px;"> </button>
            <button id="군산" class="weather-button" data-nx="56" data-ny="92" data-name="비응도동" style="top: 560px;left: 195px;"> </button>
            <button id="부안" class="weather-button" data-nx="56" data-ny="87" data-name="계화면" style="top: 587px;left: 195px;"> </button>
            <button id="정읍" class="weather-button" data-nx="58" data-ny="83" data-name="신태인" style="top: 614px;left: 195px;"> </button>
            <button id="장성" class="weather-button" data-nx="55" data-ny="57" data-name="장성읍" style="top: 641px;left: 195px;"> </button>
            <button id="담양" class="weather-button" data-nx="61" data-ny="78" data-name="담양읍" style="top: 668px;left: 195px;"> </button>
            <button id="광주광산" class="weather-button" data-nx="57" data-ny="74" data-name="오선동" style="top: 695px;left: 195px;"> </button>
            <button id="광주서구" class="weather-button" data-nx="59" data-ny="74" data-name="농성동" style="top: 722px;left: 195px;"> </button>
            <button id="광주남구" class="weather-button" data-nx="59" data-ny="73" data-name="노대동" style="top: 749px;left: 195px;"> </button>
            <button id="장흥" class="weather-button" data-nx="59" data-ny="64" data-name="장흥읍" style="top: 776px;left: 195px;"> </button>
            <button id="완도" class="weather-button" data-nx="57" data-ny="56" data-name="신지면" style="top: 803px;left: 195px;"> </button>
            <button id="양주" class="weather-button" data-nx="61" data-ny="131" data-name="고읍" style="top: 154px;left: 229px;"> </button>
            <button id="파주" class="weather-button" data-nx="56" data-ny="131" data-name="금촌동" style="top: 181px;left: 229px;"> </button>
            <button id="고양일산서" class="weather-button" data-nx="56" data-ny="129" data-name="주엽동" style="top: 208px;left: 229px;"> </button>
            <button id="광명" class="weather-button" data-nx="58" data-ny="125" data-name="소하동" style="top: 235px;left: 229px;"> </button>
            <button id="안양만안" class="weather-button" data-nx="59" data-ny="123" data-name="안양2동" style="top: 262px;left: 229px;"> </button>
            <button id="안양동안" class="weather-button" data-nx="59" data-ny="123" data-name="부림동" style="top: 289px;left: 229px;"> </button>
            <button id="시흥" class="weather-button" data-nx="57" data-ny="123" data-name="대야동" style="top: 316px;left: 229px;"> </button>
            <button id="안산상록" class="weather-button" data-nx="58" data-ny="121" data-name="본오동" style="top: 343px;left: 229px;"> </button>
            <button id="안산단원" class="weather-button" data-nx="57" data-ny="121" data-name="고잔동" style="top: 370px;left: 229px;"> </button>
            <button id="화성" class="weather-button" data-nx="57" data-ny="119" data-name="남양읍" style="top: 397px;left: 229px;"> </button>
            <button id="아산" class="weather-button" data-nx="60" data-ny="110" data-name="도고면" style="top: 424px;left: 229px;"> </button>
            <button id="천안서북" class="weather-button" data-nx="63" data-ny="112" data-name="백석동" style="top: 451px;left: 229px;"> </button>
            <button id="공주" class="weather-button" data-nx="63" data-ny="102" data-name="공주" style="top: 478px;left: 229px;"> </button>
            <button id="논산" class="weather-button" data-nx="62" data-ny="97" data-name="논산" style="top: 505px;left: 229px;"> </button>
            <button id="금산" class="weather-button" data-nx="69" data-ny="95" data-name="금산읍" style="top: 532px;left: 229px;"> </button>
            <button id="익산" class="weather-button" data-nx="60" data-ny="91" data-name="모현동" style="top: 559px;left: 229px;"> </button>
            <button id="김제" class="weather-button" data-nx="59" data-ny="88" data-name="광활면" style="top: 586px;left: 229px;"> </button>
            <button id="전주덕진" class="weather-button" data-nx="63" data-ny="89" data-name="노송동" style="top: 613px;left: 229px;"> </button>
            <button id="전주완산" class="weather-button" data-nx="63" data-ny="89" data-name="송천동" style="top: 640px;left: 229px;"> </button>
            <button id="순창" class="weather-button" data-nx="63" data-ny="79" data-name="순창읍" style="top: 667px;left: 229px;"> </button>
            <button id="곡성" class="weather-button" data-nx="66" data-ny="77" data-name="곡성읍" style="top: 694px;left: 229px;"> </button>
            <button id="광주북구" class="weather-button" data-nx="59" data-ny="75" data-name="건국동" style="top: 721px;left: 229px;"> </button>
            <button id="광주동구" class="weather-button" data-nx="60" data-ny="74" data-name="서석동" style="top: 748px;left: 229px;"> </button>
            <button id="보성" class="weather-button" data-nx="62" data-ny="66" data-name="벌교읍" style="top: 775px;left: 229px;"> </button>
            <button id="동두천" class="weather-button" data-nx="61" data-ny="134" data-name="보산동" style="top: 154px;left: 263px;"> </button>
            <button id="고양일산동" class="weather-button" data-nx="56" data-ny="129" data-name="식사동" style="top: 181px;left: 263px;"> </button>
            <button id="고양덕양" class="weather-button" data-nx="57" data-ny="128" data-name="신원동" style="top: 208px;left: 263px;"> </button>
            <button id="서울은평" class="weather-button" data-nx="59" data-ny="127" data-name="은평구" style="top: 235px;left: 263px;"> </button>
            <button id="서울강서" class="weather-button" data-nx="58" data-ny="126" data-name="강서구" style="top: 262px;left: 263px;"> </button>
            <button id="서울양천" class="weather-button" data-nx="58" data-ny="126" data-name="양천구" style="top: 289px;left: 263px;"> </button>
            <button id="서울금천" class="weather-button" data-nx="59" data-ny="124" data-name="금천구" style="top: 316px;left: 263px;"> </button>
            <button id="서울구로" class="weather-button" data-nx="58" data-ny="125" data-name="구로구" style="top: 343px;left: 263px;"> </button>
            <button id="군포" class="weather-button" data-nx="59" data-ny="122" data-name="당동" style="top: 370px;left: 263px;"> </button>
            <button id="오산" class="weather-button" data-nx="62" data-ny="118" data-name="오산동" style="top: 397px;left: 263px;"> </button>
            <button id="평택" class="weather-button" data-nx="62" data-ny="114" data-name="고덕동" style="top: 424px;left: 263px;"> </button>
            <button id="천안동남" class="weather-button" data-nx="63" data-ny="110" data-name="성황동" style="top: 451px;left: 263px;"> </button>
            <button id="세종" class="weather-button" data-nx="66" data-ny="103" data-name="부강면" style="top: 478px;left: 263px;"> </button>
            <button id="계룡" class="weather-button" data-nx="65" data-ny="99" data-name="엄사면" style="top: 505px;left: 263px;"> </button>
            <button id="대전유성" class="weather-button" data-nx="67" data-ny="101" data-name="관평동" style="top: 532px;left: 263px;"> </button>
            <button id="대전서구" class="weather-button" data-nx="67" data-ny="100" data-name="둔산동" style="top: 559px;left: 263px;"> </button>
            <button id="완주" class="weather-button" data-nx="63" data-ny="89" data-name="고산면" style="top: 586px;left: 263px;"> </button>
            <button id="진안" class="weather-button" data-nx="68" data-ny="88" data-name="진안읍" style="top: 613px;left: 263px;"> </button>
            <button id="임실" class="weather-button" data-nx="66" data-ny="84" data-name="관촌면" style="top: 640px;left: 263px;"> </button>
            <button id="구례" class="weather-button" data-nx="69" data-ny="75" data-name="구례읍" style="top: 667px;left: 263px;"> </button>
            <button id="화순" class="weather-button" data-nx="61" data-ny="72" data-name="화순읍" style="top: 694px;left: 263px;"> </button>
            <button id="순천" class="weather-button" data-nx="70" data-ny="70" data-name="순천만" style="top: 721px;left: 263px;"> </button>
            <button id="고흥" class="weather-button" data-nx="66" data-ny="62" data-name="고흥읍" style="top: 748px;left: 263px;"> </button>
            <button id="연천" class="weather-button" data-nx="61" data-ny="138" data-name="연천" style="top: 154px;left: 297px;"> </button>
            <button id="서울도봉" class="weather-button" data-nx="61" data-ny="129" data-name="도봉구" style="top: 181px;left: 297px;"> </button>
            <button id="서울강북" class="weather-button" data-nx="61" data-ny="128" data-name="강북구" style="top: 208px;left: 297px;"> </button>
            <button id="서울서대문" class="weather-button" data-nx="59" data-ny="127" data-name="서대문구" style="top: 235px;left: 297px;"> </button>
            <button id="서울마포" class="weather-button" data-nx="59" data-ny="127" data-name="마포구" style="top: 262px;left: 297px;"> </button>
            <button id="서울동작" class="weather-button" data-nx="59" data-ny="125" data-name="동작구" style="top: 289px;left: 297px;"> </button>
            <button id="서울영등포" class="weather-button" data-nx="58" data-ny="126" data-name="영등포구" style="top: 316px;left: 297px;"> </button>
            <button id="서울관악" class="weather-button" data-nx="59" data-ny="125" data-name="관악구" style="top: 343px;left: 297px;"> </button>
            <button id="의왕" class="weather-button" data-nx="60" data-ny="122" data-name="고천동" style="top: 370px;left: 297px;"> </button>
            <button id="수원팔달" class="weather-button" data-nx="61" data-ny="121" data-name="신풍동" style="top: 397px;left: 297px;"> </button>
            <button id="음성" class="weather-button" data-nx="72" data-ny="113" data-name="소이면" style="top: 424px;left: 297px;"> </button>
            <button id="진천" class="weather-button" data-nx="68" data-ny="111" data-name="덕산읍" style="top: 451px;left: 297px;"> </button>
            <button id="대전대덕" class="weather-button" data-nx="68" data-ny="100" data-name="문평동" style="top: 478px;left: 297px;"> </button>
            <button id="대전동구" class="weather-button" data-nx="68" data-ny="100" data-name="대성동" style="top: 505px;left: 297px;"> </button>
            <button id="대전중구" class="weather-button" data-nx="68" data-ny="100" data-name="문창동" style="top: 532px;left: 297px;"> </button>
            <button id="무주" class="weather-button" data-nx="72" data-ny="93" data-name="무주읍" style="top: 559px;left: 297px;"> </button>
            <button id="장수" class="weather-button" data-nx="70" data-ny="85" data-name="장수읍" style="top: 586px;left: 297px;"> </button>
            <button id="남원" class="weather-button" data-nx="68" data-ny="80" data-name="운봉읍" style="top: 613px;left: 297px;"> </button>
            <button id="함안" class="weather-button" data-nx="86" data-ny="77" data-name="가야읍" style="top: 640px;left: 297px;"> </button>
            <button id="하동" class="weather-button" data-nx="74" data-ny="73" data-name="금성면" style="top: 667px;left: 297px;"> </button>
            <button id="광양" class="weather-button" data-nx="73" data-ny="70" data-name="광양읍" style="top: 694px;left: 297px;"> </button>
            <button id="여수" class="weather-button" data-nx="73" data-ny="66" data-name="덕충동" style="top: 721px;left: 297px;"> </button>
            <button id="포천" class="weather-button" data-nx="64" data-ny="134" data-name="선단동" style="top: 154px;left: 331px;"> </button>
            <button id="서울노원" class="weather-button" data-nx="61" data-ny="129" data-name="노원구" style="top: 181px;left: 331px;"> </button>
            <button id="서울성북" class="weather-button" data-nx="61" data-ny="127" data-name="성북구" style="top: 208px;left: 331px;"> </button>
            <button id="서울종로" class="weather-button" data-nx="60" data-ny="127" data-name="종로구" style="top: 235px;left: 331px;"> </button>
            <button id="서울중구" class="weather-button" data-nx="60" data-ny="127" data-name="중구" style="top: 262px;left: 331px;"> </button>
            <button id="서울용산" class="weather-button" data-nx="60" data-ny="126" data-name="용산구" style="top: 289px;left: 331px;"> </button>
            <button id="서울서초" class="weather-button" data-nx="61" data-ny="125" data-name="서초구" style="top: 316px;left: 331px;"> </button>
            <button id="과천" class="weather-button" data-nx="60" data-ny="124" data-name="별양동" style="top: 343px;left: 331px;"> </button>
            <button id="수원권선" class="weather-button" data-nx="60" data-ny="120" data-name="고색동" style="top: 370px;left: 331px;"> </button>
            <button id="수원장안" class="weather-button" data-nx="60" data-ny="121" data-name="천천동" style="top: 397px;left: 331px;"> </button>
            <button id="안성" class="weather-button" data-nx="65" data-ny="115" data-name="공도읍" style="top: 424px;left: 331px;"> </button>
            <button id="청주흥덕" class="weather-button" data-nx="67" data-ny="106" data-name="송정동(봉명동)" style="top: 451px;left: 331px;"> </button>
            <button id="청주청원" class="weather-button" data-nx="69" data-ny="107" data-name="사천동" style="top: 478px;left: 331px;"> </button>
            <button id="청주서원" class="weather-button" data-nx="69" data-ny="107" data-name="산남동" style="top: 505px;left: 331px;"> </button>
            <button id="옥천" class="weather-button" data-nx="71" data-ny="99" data-name="옥천읍" style="top: 532px;left: 331px;"> </button>
            <button id="거창" class="weather-button" data-nx="77" data-ny="86" data-name="거창읍" style="top: 559px;left: 331px;"> </button>
            <button id="함양" class="weather-button" data-nx="74" data-ny="82" data-name="함양읍" style="top: 586px;left: 331px;"> </button>
            <button id="산청" class="weather-button" data-nx="76" data-ny="80" data-name="산청읍" style="top: 613px;left: 331px;"> </button>
            <button id="진주" class="weather-button" data-nx="81" data-ny="75" data-name="대안동" style="top: 640px;left: 331px;"> </button>
            <button id="창원합포" class="weather-button" data-nx="89" data-ny="76" data-name="월영동" style="top: 667px;left: 331px;"> </button>
            <button id="사천" class="weather-button" data-nx="80" data-ny="71" data-name="향촌동" style="top: 694px;left: 331px;"> </button>
            <button id="남해" class="weather-button" data-nx="77" data-ny="68" data-name="남해읍" style="top: 721px;left: 331px;"> </button>
            <button id="철원" class="weather-button" data-nx="65" data-ny="139" data-name="갈말읍" style="top: 127px;left: 365px;"> </button>
            <button id="의정부" class="weather-button" data-nx="61" data-ny="130" data-name="송산3동" style="top: 154px;left: 365px;"> </button>
            <button id="남양주" class="weather-button" data-nx="64" data-ny="128" data-name="금곡동" style="top: 181px;left: 365px;"> </button>
            <button id="가평" class="weather-button" data-nx="69" data-ny="133" data-name="가평" style="top: 208px;left: 365px;"> </button>
            <button id="서울동대문" class="weather-button" data-nx="61" data-ny="127" data-name="동대문구" style="top: 235px;left: 365px;"> </button>
            <button id="서울성동" class="weather-button" data-nx="61" data-ny="127" data-name="성동구" style="top: 262px;left: 365px;"> </button>
            <button id="서울광진" class="weather-button" data-nx="62" data-ny="126" data-name="광진구" style="top: 289px;left: 365px;"> </button>
            <button id="서울강남" class="weather-button" data-nx="61" data-ny="126" data-name="강남구" style="top: 316px;left: 365px;"> </button>
            <button id="성남분당" class="weather-button" data-nx="62" data-ny="123" data-name="수내동" style="top: 343px;left: 365px;"> </button>
            <button id="수원영통" class="weather-button" data-nx="61" data-ny="120" data-name="광교동" style="top: 370px;left: 365px;"> </button>
            <button id="제천" class="weather-button" data-nx="81" data-ny="118" data-name="영천동" style="top: 397px;left: 365px;"> </button>
            <button id="단양" class="weather-button" data-nx="84" data-ny="115" data-name="단성면" style="top: 424px;left: 365px;"> </button>
            <button id="충주" class="weather-button" data-nx="76" data-ny="114" data-name="살미면" style="top: 451px;left: 365px;"> </button>
            <button id="증평" class="weather-button" data-nx="71" data-ny="110" data-name="도안면" style="top: 478px;left: 365px;"> </button>
            <button id="청주상당" class="weather-button" data-nx="69" data-ny="106" data-name="가덕면" style="top: 505px;left: 365px;"> </button>
            <button id="영동" class="weather-button" data-nx="74" data-ny="97" data-name="영동읍" style="top: 532px;left: 365px;"> </button>
            <button id="합천" class="weather-button" data-nx="81" data-ny="84" data-name="합천읍" style="top: 559px;left: 365px;"> </button>
            <button id="창녕" class="weather-button" data-nx="87" data-ny="83" data-name="창녕읍" style="top: 586px;left: 365px;"> </button>
            <button id="의령" class="weather-button" data-nx="83" data-ny="78" data-name="의령읍" style="top: 613px;left: 365px;"> </button>
            <button id="창원의창" class="weather-button" data-nx="90" data-ny="77" data-name="명서동" style="top: 640px;left: 365px;"> </button>
            <button id="창원회원" class="weather-button" data-nx="89" data-ny=76 data-name="내서읍" style="top: 667px;left: 365px;"> </button>
            <button id="고성(경남)" class="weather-button" data-nx="85" data-ny="71" data-name="고성읍" style="top: 694px;left: 365px;"> </button>
            <button id="통영" class="weather-button" data-nx="87" data-ny="68" data-name="무전동" style="top: 721px;left: 365px;"> </button>
            <button id="화천" class="weather-button" data-nx="72" data-ny="139" data-name="화천읍" style="top: 127px;left: 400px;"> </button>
            <button id="춘천" class="weather-button" data-nx="73" data-ny="134" data-name="신사우동" style="top: 154px;left: 400px;"> </button>
            <button id="홍천" class="weather-button" data-nx="75" data-ny="130" data-name="홍천읍" style="top: 181px;left: 400px;"> </button>
            <button id="구리" class="weather-button" data-nx="62" data-ny="127" data-name="교문동" style="top: 208px;left: 400px;"> </button>
            <button id="서울중랑" class="weather-button" data-nx="62" data-ny="128" data-name="중랑구" style="top: 235px;left: 400px;"> </button>
            <button id="서울강동" class="weather-button" data-nx="62" data-ny="126" data-name="강동구" style="top: 262px;left: 400px;"> </button>
            <button id="서울송파" class="weather-button" data-nx="62" data-ny="126" data-name="송파구" style="top: 289px;left: 400px;"> </button>
            <button id="성남중원" class="weather-button" data-nx="63" data-ny="124" data-name="상대원동" style="top: 316px;left: 400px;"> </button>
            <button id="성남수정" class="weather-button" data-nx="63" data-ny="124" data-name="단대동" style="top: 343px;left: 400px;"> </button>
            <button id="용인수지" class="weather-button" data-nx="62" data-ny="121" data-name="수지" style="top: 370px;left: 400px;"> </button>
            <button id="상주" class="weather-button" data-nx="81" data-ny="102" data-name="상주시" style="top: 397px;left: 400px;"> </button>
            <button id="김천" class="weather-button" data-nx="80" data-ny="96" data-name="대광동" style="top: 424px;left: 400px;"> </button>
            <button id="괴산" class="weather-button" data-nx="74" data-ny="111" data-name="감물면" style="top: 451px;left: 400px;"> </button>
            <button id="보은" class="weather-button" data-nx="73" data-ny="103" data-name="보은읍" style="top: 478px;left: 400px;"> </button>
            <button id="대구서구" class="weather-button" data-nx="88" data-ny="90" data-name="내당동" style="top: 505px;left: 400px;"> </button>
            <button id="대구남구" class="weather-button" data-nx="89" data-ny="90" data-name="대명동" style="top: 532px;left: 400px;"> </button>
            <button id="대구달서" class="weather-button" data-nx="88" data-ny="90" data-name="본동" style="top: 559px;left: 400px;"> </button>
            <button id="밀양" class="weather-button" data-nx="92" data-ny="83" data-name="내일동" style="top: 586px;left: 400px;"> </button>
            <button id="부산강서" class="weather-button" data-nx="96" data-ny="76" data-name="대저동" style="top: 613px;left: 400px;"> </button>
            <button id="양산" class="weather-button" data-nx="97" data-ny="79" data-name="물금읍" style="top: 640px;left: 400px;"> </button>
            <button id="창원성산" class="weather-button" data-nx="91" data-ny="76" data-name="사파동" style="top: 667px;left: 400px;"> </button>
            <button id="창원진해" class="weather-button" data-nx="91" data-ny="75" data-name="경화동" style="top: 694px;left: 400px;"> </button>
            <button id="거제" class="weather-button" data-nx="90" data-ny="69" data-name="고현동" style="top: 721px;left: 400px;"> </button>
            <button id="양구" class="weather-button" data-nx="77" data-ny="139" data-name="양구읍" style="top: 127px;left: 435px;"> </button>
            <button id="인제" class="weather-button" data-nx="80" data-ny="138" data-name="인제읍" style="top: 154px;left: 435px;"> </button>
            <button id="횡성" class="weather-button" data-nx="77" data-ny="125" data-name="횡성읍" style="top: 181px;left: 435px;"> </button>
            <button id="양평" class="weather-button" data-nx="69" data-ny="125" data-name="양평읍" style="top: 208px;left: 435px;"> </button>
            <button id="여주" class="weather-button" data-nx="71" data-ny="121" data-name="가남읍" style="top: 235px;left: 435px;"> </button>
            <button id="이천" class="weather-button" data-nx="68" data-ny="121" data-name="부발읍" style="top: 262px;left: 435px;"> </button>
            <button id="하남" class="weather-button" data-nx="64" data-ny="126" data-name="미사" style="top: 289px;left: 435px;"> </button>
            <button id="광주" class="weather-button" data-nx="65" data-ny="123" data-name="경안동" style="top: 316px;left: 435px;"> </button>
            <button id="용인처인" class="weather-button" data-nx="64" data-ny="119" data-name="김량장동" style="top: 343px;left: 435px;"> </button>
            <button id="용인기흥" class="weather-button" data-nx="62" data-ny="120" data-name="기흥" style="top: 370px;left: 435px;"> </button>
            <button id="문경" class="weather-button" data-nx="81" data-ny="106" data-name="문경시" style="top: 397px;left: 435px;"> </button>
            <button id="구미" class="weather-button" data-nx="84" data-ny="96" data-name="4공단" style="top: 424px;left: 435px;"> </button>
            <button id="성주" class="weather-button" data-nx="83" data-ny="91" data-name="성주군" style="top: 451px;left: 435px;"> </button>
            <button id="고령" class="weather-button" data-nx="83" data-ny="87" data-name="대가야읍" style="top: 478px;left: 435px;"> </button>
            <button id="대구북구" class="weather-button" data-nx="89" data-ny="91" data-name="산격동" style="top: 505px;left: 435px;"> </button>
            <button id="대구중구" class="weather-button" data-nx="89" data-ny="90" data-name="남산1동" style="top: 532px;left: 435px;"> </button>
            <button id="대구달성" class="weather-button" data-nx="86" data-ny="88" data-name="다사읍" style="top: 559px;left: 435px;"> </button>
            <button id="부산사상" class="weather-button" data-nx="96" data-ny="75" data-name="덕포동" style="top: 586px;left: 435px;"> </button>
            <button id="부산서구" class="weather-button" data-nx="97" data-ny="74" data-name="대신동" style="top: 613px;left: 435px;"> </button>
            <button id="부산사하" class="weather-button" data-nx="96" data-ny="74" data-name="당리동" style="top: 640px;left: 435px;"> </button>
            <button id="김해" class="weather-button" data-nx="95" data-ny="77" data-name="동상동" style="top: 667px;left: 435px;"> </button>
            <button id="고성(강원)" class="weather-button" data-nx="85" data-ny="145" data-name="상리" style="top: 127px;left: 469px;"> </button>
            <button id="속초" class="weather-button" data-nx="87" data-ny="141" data-name="금호동" style="top: 154px;left: 469px;"> </button>
            <button id="양양" class="weather-button" data-nx="88" data-ny="138" data-name="양양읍" style="top: 181px;left: 469px;"> </button>
            <button id="평창" class="weather-button" data-nx="84" data-ny="123" data-name="평창읍" style="top: 208px;left: 469px;"> </button>
            <button id="정선" class="weather-button" data-nx="89" data-ny="123" data-name="정선읍" style="top: 235px;left: 469px;"> </button>
            <button id="원주" class="weather-button" data-nx="76" data-ny="122" data-name="문막읍" style="top: 262px;left: 469px;"> </button>
            <button id="영월" class="weather-button" data-nx="86" data-ny="119" data-name="영월읍" style="top: 289px;left: 469px;"> </button>
            <button id="태백" class="weather-button" data-nx="95" data-ny="119" data-name="황지동" style="top: 316px;left: 469px;"> </button>
            <button id="영주" class="weather-button" data-nx="89" data-ny=111 data-name="가흥동" style="top: 343px;left: 469px;"> </button>
            <button id="예천" class="weather-button" data-nx="86" data-ny="107" data-name="예천군" style="top: 370px;left: 469px;"> </button>
            <button id="안동" class="weather-button" data-nx="91" data-ny="106" data-name="명륜동" style="top: 397px;left: 469px;"> </button>
            <button id="군위" class="weather-button" data-nx="88" data-ny="99" data-name="군위읍" style="top: 424px;left: 469px;"> </button>
            <button id="칠곡" class="weather-button" data-nx="85" data-ny="93" data-name="칠곡군" style="top: 451px;left: 469px;"> </button>
            <button id="청도" class="weather-button" data-nx="91" data-ny="86" data-name="화양읍" style="top: 478px;left: 469px;"> </button>
            <button id="대구동구" class="weather-button" data-nx="90" data-ny="91" data-name="서호동" style="top: 505px;left: 469px;"> </button>
            <button id="대구수성" class="weather-button" data-nx="89" data-ny="90" data-name="만촌동" style="top: 532px;left: 469px;"> </button>
            <button id="부산북구" class="weather-button" data-nx="96" data-ny="76" data-name="덕천동" style="top: 559px;left: 469px;"> </button>
            <button id="부산부산진" class="weather-button" data-nx="97" data-ny="75" data-name="개금동" style="top: 586px;left: 469px;"> </button>
            <button id="부산동구" class="weather-button" data-nx="98" data-ny="75" data-name="수정동" style="top: 613px;left: 469px;"> </button>
            <button id="부산중구" class="weather-button" data-nx="97" data-ny="74" data-name="광복동" style="top: 640px;left: 469px;"> </button>
            <button id="부산영도" class="weather-button" data-nx="98" data-ny="74" data-name="청학동" style="top: 667px;left: 469px;"> </button>
            <button id="강릉" class="weather-button" data-nx="92" data-ny="131" data-name="옥천동" style="top: 208px;left: 504px;"> </button>
            <button id="동해" class="weather-button" data-nx="97" data-ny="127" data-name="천곡동" style="top: 235px;left: 504px;"> </button>
            <button id="삼척" class="weather-button" data-nx="98" data-ny="125" data-name="남양동1" style="top: 262px;left: 504px;"> </button>
            <button id="울진" class="weather-button" data-nx="102" data-ny="115" data-name="울진군" style="top: 289px;left: 504px;"> </button>
            <button id="봉화" class="weather-button" data-nx="90" data-ny="113" data-name="봉화군청" style="top: 316px;left: 504px;"> </button>
            <button id="영양" class="weather-button" data-nx="97" data-ny="108" data-name="영양군" style="top: 343px;left: 504px;"> </button>
            <button id="영덕" class="weather-button" data-nx="102" data-ny="103" data-name="영덕읍" style="top: 370px;left: 504px;"> </button>
            <button id="청송" class="weather-button" data-nx="96" data-ny="103" data-name="청송읍" style="top: 397px;left: 504px;"> </button>
            <button id="의성" class="weather-button" data-nx="90" data-ny="101" data-name="안계면" style="top: 424px;left: 504px;"> </button>
            <button id="영천" class="weather-button" data-nx="95" data-ny="93" data-name="영천시" style="top: 451px;left: 504px;"> </button>
            <button id="경산" class="weather-button" data-nx=91 data-ny="90" data-name="중방동" style="top: 478px;left: 504px;"> </button>
            <button id="울산울주" class="weather-button" data-nx="101" data-ny="84" data-name="덕신리" style="top: 505px;left: 504px;"> </button>
            <button id="울산중구" class="weather-button" data-nx="102" data-ny="84" data-name="성남동" style="top: 532px;left: 504px;"> </button>
            <button id="부산금정" class="weather-button" data-nx="98" data-ny="77" data-name="부곡동" style="top: 559px;left: 504px;"> </button>
            <button id="부산동래" class="weather-button" data-nx="98" data-ny="76" data-name="명장동" style="top: 586px;left: 504px;"> </button>
            <button id="부산연제" class="weather-button" data-nx="98" data-ny="76" data-name="연산동" style="top: 613px;left: 504px;"> </button>
            <button id="부산수영" class="weather-button" data-nx="99" data-ny="75" data-name="광안동" style="top: 640px;left: 504px;"> </button>
            <button id="부산남구" class="weather-button" data-nx="98" data-ny="75" data-name="대연동" style="top: 667px;left: 504px;"> </button>
            <button id="포항북구" class="weather-button" data-nx="102" data-ny="95" data-name="양덕동" style="top: 397px;left: 538px;"> </button>
            <button id="포항남구" class="weather-button" data-nx="102" data-ny="94" data-name="3공단" style="top: 424px;left: 538px;"> </button>
            <button id="경주" class="weather-button" data-nx="100" data-ny="91" data-name="보덕동" style="top: 451px;left: 538px;"> </button>
            <button id="울산북구" class="weather-button" data-nx="103" data-ny="85" data-name="농소동" style="top: 478px;left: 538px;"> </button>
            <button id="울산동구" class="weather-button" data-nx="104" data-ny="83" data-name="대송동" style="top: 505px;left: 538px;"> </button>
            <button id="울산남구" class="weather-button" data-nx="102" data-ny="84" data-name="무거동" style="top: 532px;left: 538px;"> </button>
            <button id="부산기장" class="weather-button" data-nx="100" data-ny="77" data-name="기장읍" style="top: 559px;left: 538px;"> </button>
            <button id="부산해운대" class="weather-button" data-nx="99" data-ny="75" data-name="재송동" style="top: 586px;left: 538px;"> </button>
            <button id="울릉" class="weather-button" data-nx="127" data-ny="127" data-name="울릉읍" style="top: 343px;left: 572px;"> </button>
            <button id="제주" class="weather-button" data-nx="53" data-ny="38" data-name="애월읍" style="top: 802px;left: 297px;"> </button>
            <button id="서귀포" class="weather-button" data-nx="52" data-ny="33" data-name="강정동" style="top: 829px;left: 297px;"> </button>
            
            <!-- 나머지 버튼들도 동일한 방식으로 클래스와 데이터 속성을 설정합니다. -->
            <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
            <script>
            $(document).ready(function() {
                var defaultButton = $("#서울영등포"); // 변경하고 싶은 디폴트 버튼 지정
                var nx = defaultButton.data("nx");
                var ny = defaultButton.data("ny");

                // 초기 로딩 시 디폴트 버튼의 정보로 기상정보와 대기질 정보 요청
                sendRequestWeather(nx, ny);
                sendRequestAirQuality(defaultButton.data("name"));

                // 초기 로딩 시 디폴트 버튼의 ID를 출력
                $("#clickedButtonId").text("(" + defaultButton.attr("id") + ")");

                $(".weather-button").click(function() {
                    var nx = $(this).data("nx");
                    var ny = $(this).data("ny");
                    var name = $(this).data("name");

                    sendRequestWeather(nx, ny);
                    sendRequestAirQuality(name);

                    // 클릭한 버튼의 ID를 #clickedButtonId에 출력
                    $("#clickedButtonId").text("(" + $(this).attr("id") + ")");
                });
            });

            
                function sendRequestWeather(nx, ny) {
                    $.ajax({
                        type: "GET",
                        url: "http://localhost:5000/get_weather",  // 플라스크 서버 주소로 업데이트하세요
                        data: { nx: nx, ny: ny },
                        success: function(response) {
                            var tableContent = '<table style="width:600px;">';
                            tableContent += '<tr>';
                            tableContent += '<th colspan="3"><h1><i class="fa-solid fa-temperature-low"></i>&nbsp;' + response['기온'] + '</h1></th>';
                            tableContent += '</tr>';
                            tableContent += '<tr><td><i class="fa-solid fa-droplet" style="color:DodgerBlue;"></i>&nbsp; 습도 </td><td>' 
                                        + '<i class="fa-solid fa-cloud-showers-heavy" style="color:DodgerBlue;"></i>&nbsp; 강수량 </td><td>'
                                        + '<i class="fa-solid fa-wind"style="color:DodgerBlue;"></i>&nbsp; 바람 </td></tr>';
                            tableContent += '<tr><td>' + response['습도']  + '</td><td>' + response['1시간 강수량'] + '</td><td>' + response['풍향'] + ' , ' + response['풍속'] + '</td></tr>';
                            tableContent += '</table>';

                            $("#result").html(tableContent);
                        },
                        error: function(error) {
                            console.error("에러:", error);
                        }
                    });
                }

            
                function sendRequestAirQuality(name) {
                     $.ajax({
                         type: "GET",
                         url: "http://localhost:5000/get_air_quality",
                         data: { name: name },
                         success: function(response) {
                             var tableContent2 = '<table style="margin-top:200px; width:600px;">';
                                tableContent2 += '<tr>';
                                tableContent2 += '<th class="table-cell">' + response['미세먼지(PM10) 농도'] + '<small class="unit">㎍/m³</small></th>' +
                                                '<th class="table-cell">' + response['초미세먼지(PM2.5) 농도'] + '<small class="unit">㎍/m³</small></th>' +
                                                '<th class="table-cell">' + response['이산화질소 농도'] + '<small class="unit">ppm</small></th>' +
                                                '<th class="table-cell">' + response['아황산가스 농도'] + '<small class="unit">ppm</small></th>' +
                                                '<th class="table-cell">' + response['오존 농도'] + '<small class="unit">ppm</small></th>';
                                tableContent2 += '</tr>';
                                tableContent2 += '<tr>';
                                tableContent2 += '<td>'+ '미세먼지<small class="unit">(PM10)</small>' +'</td>' + '<td>'+ '초미세먼지<small class="unit">(PM2.5)</small>' +'</td>' 
                                            + '<td>'+ '이산화질소' +'</td>' + '<td>'+ '아황산가스' +'</td>' + '<td>'+ '오존' +'</td>';
                                tableContent2 += '</tr>';
                                tableContent2 += '<tr>';
                                tableContent2 += '<td colspan="5" style="text-align:right;margin-top:100px;">'+ '측정소명(측정망정보): ' + response['이름'] + '(' + response['측정망 정보'] + ')&nbsp;&nbsp;&nbsp;&nbsp;' + "기준일시: " + response['날짜'] + '</td>'; 
                                tableContent2 += '</tr>';
                                tableContent2 += '<tr>';
                                tableContent2 += '<td colspan="5" style="text-align:right;">정보출처: 대기질정보(한국환경공단), 기상정보(기상청)</td>'; 
                                tableContent2 += '</tr>';
                                
                                              
                                            
                                $("#result1").html(tableContent2);
                         },
                         error: function(error) {
                             console.error("에러:", error);
                         }
                     });
                 }
            </script>


                
            </div>

        </div>
       <div class="col-6 mt-3">
       		 <div class="row">
		          <div style="text-align:center;">
		              <h4 class="text-center" style="color:DodgerBlue;"><i class="fa-solid fa-cloud-sun"></i>&nbsp;오늘의 기상정보&nbsp;&nbsp;&nbsp;</h4>
		              <!-- 클릭한 버튼의 ID를 출력하는 부분 -->
		            <span id="clickedButtonId"></span>
		              <hr style="margin-bottom:-10px;">
		          </div>
		          <div class="d-flex justify-content-start" style="border: none;">
		              <div id="result" class="weather-info">
		                  <!-- sendRequestWeather 함수가 호출되면 자동으로 결과가 표시됩니다. -->
		              </div>
		          </div>
		          <div class="d-flex justify-content-start" style="border: none;">
		              <div id="result1" class="weather-info2">
		                  <!-- sendRequestWeather 함수가 호출되면 자동으로 결과가 표시됩니다. -->
		              </div>
	          </div>
          </div>
          <div class="row"><div class="container"></div></div>
          <div class="row">
          	<div class="Express" style="margin-top:500px; font-size:12px; text-align:right; margin-right:-80px;">
	          	<p>데이터는 실시간 관측된 자료이며, 측정소 현지 사정이나 데이터의 수신 상태에 따라 미수신될 수 있음</p>
				
          	</div>
          </div>
      </div>

	</div>
</div>


<%@ include file="../common/bottom.jspf" %>
</body>
</html>