<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jspf" %>
 	    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendar</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .calendar {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 300px;
            text-align: center;
        }

        .month {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        #prevMonth,
        #nextMonth {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            color: #333;
        }

        #currentMonth {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .weekdays {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-weight: bold;
            color: #333;
        }

        .weekdays div {
            width: calc(100% / 7);
        }

        .days {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
        }

        .day {
            padding: 5px;
            border-radius: 50%;
            cursor: pointer;
        }

        .day:hover {
            background-color: #eee;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            border-radius: 8px;
            position: relative;
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

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

        label,
        input,
        textarea {
            display: block;
            margin-bottom: 10px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"] {
            padding: 10px;
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #555;
        }
    </style>
	<style>
        th { text-align: center; width: 14.28%; }
    </style>
    <script src="{{url_for('static', filename='js/calendar.js')}}"></script>
    <script>
        // 현재 날짜 객체 생성
        const currentDate = new Date();
        let currentMonth = currentDate.getMonth();
        let currentYear = currentDate.getFullYear();

        const monthNames = [
            "January", "February", "March", "April", "May", "June", "July",
            "August", "September", "October", "November", "December"
        ];

        // 현재 달력 표시
        function showCalendar(month, year) {
            const daysContainer = document.getElementById("daysContainer");
            daysContainer.innerHTML = '';

            const totalDays = 32 - new Date(year, month, 32).getDate();
            const firstDayIndex = new Date(year, month, 1).getDay();

            document.getElementById('currentMonth').innerHTML = `${monthNames[month]} ${year}`;

            for (let i = 0; i < firstDayIndex; i++) {
                const emptyDay = document.createElement("div");
                daysContainer.appendChild(emptyDay);
            }

            for (let i = 1; i <= totalDays; i++) {
                const day = document.createElement("div");
                day.classList.add("day");
                day.innerHTML = i;

                day.addEventListener("click", () => openModal(i, month, year));

                daysContainer.appendChild(day);
            }
        }

        showCalendar(currentMonth, currentYear);

        function openModal(day, month, year) {
            const writeModal = document.getElementById("writeModal");
            const noteTitle = document.getElementById("noteTitle");
            const noteContent = document.getElementById("noteContent");

            noteTitle.value = `${year}-${month + 1}-${day}`;
            noteContent.value = '';

            writeModal.style.display = "block";
        }

        // 모달 창 닫기
        const closeModal = document.querySelector(".close");
        closeModal.addEventListener("click", () => {
            const writeModal = document.getElementById("writeModal");
            writeModal.style.display = "none";
        });
    </script>
</head>
<body>
	<%@ include file="../common/top.jspf" %>
	<div class="container" style="margin-top:80px">
		<div class="row">
			<%@ include file="../common/aside.jspf" %> 
			<!-- ================ 내가 작성할 부분 =================== -->
			<div class="col-9">
				    <h1>Calendar</h1>
    
    <div class="calendar">
        <div class="month">
            <button id="prevMonth">Previous Month</button>
            <h2 id="currentMonth">Month Year</h2>
            <button id="nextMonth">Next Month</button>
        </div>
        <div class="weekdays">
            <div>Sun</div>
            <div>Mon</div>
            <div>Tue</div>
            <div>Wed</div>
            <div>Thu</div>
            <div>Fri</div>
            <div>Sat</div>
        </div>
        <div class="days" id="daysContainer">
            <!-- 이 부분에 달력 날짜들이 들어갈 것입니다. -->
        </div>
    </div>

    <div class="modal" id="writeModal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Write a Note</h2>
            <form id="noteForm">
                <label for="noteTitle">Title:</label><br>
                <input type="text" id="noteTitle" readonly><br>
                <label for="noteContent">Content:</label><br>
                <textarea id="noteContent" readonly></textarea><br>
                <input type="submit" value="Save">
            </form>
        </div>
    </div>
				
			</div>
			<!-- ================ 내가 작성할 부분 =================== -->
		</div>
	</div>
	<%@ include file="../common/bottom.jspf" %>
</body>
</html>