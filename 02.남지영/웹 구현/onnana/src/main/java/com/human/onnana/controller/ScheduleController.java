package com.human.onnana.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.javassist.compiler.TypeChecker;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.human.onnana.entity.Anniversary;
import com.human.onnana.entity.SchDay;
import com.human.onnana.entity.Schedule;
import com.human.onnana.entity.User;
import com.human.onnana.service.AnniversaryService;
import com.human.onnana.service.ScheduleService;
import com.human.onnana.utility.SchedUtil;

@Controller
@RequestMapping("/schedule")
public class ScheduleController {

	@Autowired private ScheduleService schedService;
	@Autowired private AnniversaryService annivService;
	@Autowired private SchedUtil schedUtil;
	
	@GetMapping(value = {"/calendar/{arrow}", "/calendar"})
	public String calendar(@PathVariable(required = false) String arrow, HttpSession session, Model model) {
		LocalDate today = LocalDate.now();
		String date = "일 월 화 수 목 금 토".split(" ")[today.getDayOfWeek().getValue() % 7];
		int year = 2023, month = 1;
		String sessionMonthYear = (String) session.getAttribute("scheduleMonthYear");
		if (sessionMonthYear == null) {
			year = today.getYear();
			month = today.getMonthValue();
		} else {
			year = Integer.parseInt(sessionMonthYear.substring(0,4));
			month = Integer.parseInt(sessionMonthYear.substring(5));
		}
		
		if (arrow != null) {
			switch(arrow) {
			case "left":
				month = month - 1;
				if (month == 0) {
					month = 12;
					year = year - 1;
				}
				break;
			case "right":
				month = month + 1;
				if (month == 13) {
					month = 1;
					year = year + 1;
				}
				break;
			case "left2":
				year = year - 1;
				break;
			case "right2":
				year = year + 1;
			}
		}
		sessionMonthYear = String.format("%d.%02d", year, month);
		session.setAttribute("scheduleMonthYear", sessionMonthYear);
		String sessUid = (String) session.getAttribute("sessUid");
		
		List<SchDay> week = new ArrayList<>();
		List<List<SchDay>> calendar = new ArrayList<>();
		LocalDate startDay = LocalDate.parse(String.format("%d-%02d-01", year, month));
		int startDate = startDay.getDayOfWeek().getValue() % 7;		// 1 ~ 7 사이의 값을 0 ~ 6 사이의 값으로
		LocalDate lastDay = startDay.withDayOfMonth(startDay.lengthOfMonth());
		int lastDate = lastDay.getDayOfWeek().getValue() % 7;
		
		// 아래에서 k는 날짜, i는 요일을 가리킴
		String sdate = null;
		// 첫번째 주
		if (startDate != 0) {
			LocalDate prevSunDay = startDay.minusDays(startDate);
			int prevDay = prevSunDay.getDayOfMonth();
			int prevYear = prevSunDay.getYear();
			int prevMonth = prevSunDay.getMonthValue();
			for (int i=0; i<startDate; i++) {
				sdate = String.format("%d%02d%d", prevYear, prevMonth, prevDay+i);
				week.add(schedService.generateSchDay(sessUid, sdate, i, 1));
			}
		}
		for (int i=startDate, k=1; i<7; i++, k++) {
			sdate = String.format("%d%02d%02d", year, month, k);
			week.add(schedService.generateSchDay(sessUid, sdate, i, 0));
		}
		calendar.add(week);
		
		// 둘째 주부터 해당월의 마지막까지
		int day = 8 - startDate;
		for (int k=day, i=0; k<=lastDay.getDayOfMonth(); k++, i++) {
			if (i % 7 == 0)
				week = new ArrayList<>();
			sdate = String.format("%d%02d%02d", year, month, k);
			week.add(schedService.generateSchDay(sessUid, sdate, i % 7, 0));
			if (i % 7 == 6)
				calendar.add(week);
		}
		// 마지막 주 다음달 내용
		if (lastDate != 6) {
			LocalDate nextDay = lastDay.plusDays(1);
			int nextYear = nextDay.getYear();
			int nextMonth = nextDay.getMonthValue();
			for (int i=lastDate+1, k=1; i<7; i++, k++) {
				sdate = String.format("%d%02d%02d", nextYear, nextMonth, k);
				week.add(schedService.generateSchDay(sessUid, sdate, i, 1));
			}
			calendar.add(week);
		}
		
		model.addAttribute("calendar", calendar);
		model.addAttribute("today", today + "(" + date + ")");
		model.addAttribute("year", year);
		model.addAttribute("month", String.format("%02d", month));
		model.addAttribute("numberOfWeeks", calendar.size());
		model.addAttribute("timeList", schedUtil.genTime());
		model.addAttribute("menu", "calendar");
		return "schedule/calendar";
	}
	
	
	
	
	@PostMapping("/calendar")
	public String list(@PathVariable int page, HttpSession session, Model model, String uid, String sdate) {
	    String sessUid = (String) session.getAttribute("sessUid");
	    List<Schedule> userList = schedService.getuserdateCarvon(sessUid, sdate);
	    model.addAttribute("userList", userList);
	    model.addAttribute("sdate", sdate); // 해당 날짜도 함께 전달합니다.
	    return "schedule/calendar";
	}
	
	
	
	
	
	@ResponseBody
	@PostMapping("/insert")
	public String insert(HttpServletRequest req, HttpSession session, String uid) {
		
		
		String startDate = req.getParameter("startDate");
		String startTime = req.getParameter("startTime");
		LocalDateTime startDateTime = LocalDateTime.parse(startDate + "T" + startTime + ":00");
		String title = req.getParameter("title");
		String title2 = req.getParameter("title2");
		String place = req.getParameter("place");
		String startplace = req.getParameter("startplace");
		String endplace = req.getParameter("endplace");
		String smoke = req.getParameter("smoke");
		String smoke2 = req.getParameter("smoke2");
		String waypoint1 = req.getParameter("waypoint1");
		String waypoint2 = req.getParameter("waypoint2");
		String waypoint3 = req.getParameter("waypoint3");
		String sdate = startDate.replace("-", "");
		
		String sessUid = (String) session.getAttribute("sessUid");
	    Schedule schedule = new Schedule(sessUid, sdate, startDateTime);

	    schedule.setTitle(title != null && !title.isEmpty() ? title : "");
	    schedule.setTitle2(title2 != null && !title2.isEmpty() ? title2 : "");
	    schedule.setPlace(place != null && !place.isEmpty() ? place : "");
	    schedule.setStartplace(startplace != null && !startplace.isEmpty() ? startplace : "");
	    schedule.setEndplace(endplace != null && !endplace.isEmpty() ? endplace : "");
	    schedule.setSmoke(smoke != null && !smoke.isEmpty() ? smoke : "");
	    schedule.setSmoke2(smoke2 != null && !smoke2.isEmpty() ? smoke2 : "");
	    schedule.setWaypoint1(waypoint1 != null && !waypoint1.isEmpty() ? waypoint1 : "");
	    schedule.setWaypoint2(waypoint2 != null && !waypoint2.isEmpty() ? waypoint2 : "");
	    schedule.setWaypoint3(waypoint3 != null && !waypoint3.isEmpty() ? waypoint3 : "");

	    
	    schedService.insert(schedule);

		System.out.println(schedule);
///////////////// 캘린더 생성 되었을때 , DB베이스와 웹서버 연동 실시간으로 되도록 설정///////////////////////////

		
		// 전체 유저의 참여인원을 카운트 값 불러오는것
		int count = schedService.getCount();
		// 전체 유저의 참여인원을 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessAllId", count);
		// 탄소배출감소량 전체 유저 카운트 값 불러오는것
		Double countCarbon = schedService.getCarbonCount();
		// 탄소배출감소량 전체 유저 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessAllCarbonId", countCarbon);
		
		
		// 유저의 참여 일수를 카운트 값 불러오는것
		int countUser = schedService.getUserCount(sessUid);
		// 유저의 참여 일수를 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessId", countUser);
		
		// 탄소배출감소량 한 유저 카운트 값 불러오는것
		Double countUserCarbon =  schedService.getCarbonUserCount(sessUid);
		// 탄소배출감소량 한 유저 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessCarbonId", countUserCarbon);
		
		
		// count 외에도 여러 변수를 포함한 JSON 객체를 생성합니다.
		Map<String, Object> response = new HashMap<>();
		response.put("count", count);
		response.put("countCarbon", countCarbon);
		response.put("countUser", countUser);
		response.put("countUserCarbon", countUserCarbon);

		// Map을 JSON 문자열로 변환합니다.
		String jsonResponse = new Gson().toJson(response);

		return jsonResponse;
		
///////////////////////////////////////////////////////////////////////////////////////////////////////		
	}
	
	

	@ResponseBody
	@GetMapping("/detail/{sid}")
	public String detail(@PathVariable int sid) {
	    Schedule sched = schedService.getSchedule(sid);
	    JSONObject jSched = new JSONObject();
	    jSched.put("sid", sid);
	    jSched.put("startTime", sched.getStartTime().toString());
	    jSched.put("title", sched.getTitle());
	    jSched.put("title2", sched.getTitle2());
	    jSched.put("place", sched.getPlace());
	    jSched.put("startplace", sched.getStartplace());
	    jSched.put("endplace", sched.getEndplace()); // Corrected 'endplace' typo
	    jSched.put("smoke", sched.getSmoke().toString());
	    jSched.put("smoke2", sched.getSmoke2().toString()); // Changed to 'getSmoke2()'
	    jSched.put("waypoint1", sched.getWaypoint1());
	    jSched.put("waypoint2", sched.getWaypoint2());
	    jSched.put("waypoint3", sched.getWaypoint3());
	    
	    System.out.println(jSched);
	    return jSched.toString();
	}

	
	
	@ResponseBody
	@PostMapping("/update")
	public String update(HttpServletRequest req, HttpSession session) {
		String startDate = req.getParameter("startDate");
		String startTime = req.getParameter("startTime");
		LocalDateTime startDateTime = LocalDateTime.parse(startDate + "T" + startTime + ":00");
		String title = req.getParameter("title");
		String title2 = req.getParameter("title2");
		String place = req.getParameter("place");
		String startplace = req.getParameter("startplace");
		String endplace = req.getParameter("endplace");
		String smoke = req.getParameter("smoke");
		String smoke2 = req.getParameter("smoke2");
		String waypoint1 = req.getParameter("waypoint1");
		String waypoint2 = req.getParameter("waypoint2");
		String waypoint3 = req.getParameter("waypoint3");
		int sid = Integer.parseInt(req.getParameter("sid"));
		String sdate = startDate.replace("-", "");
		
		String sessUid = (String) session.getAttribute("sessUid");
	    Schedule schedule = new Schedule(sid, sessUid, sdate, startDateTime);

	    schedule.setTitle(title != null && !title.isEmpty() ? title : "");
	    schedule.setTitle2(title2 != null && !title2.isEmpty() ? title2 : "");
	    schedule.setPlace(place != null && !place.isEmpty() ? place : "");
	    schedule.setStartplace(startplace != null && !startplace.isEmpty() ? startplace : "");
	    schedule.setEndplace(endplace != null && !endplace.isEmpty() ? endplace : "");
	    schedule.setSmoke(smoke != null && !smoke.isEmpty() ? smoke : "");
	    schedule.setSmoke2(smoke2 != null && !smoke2.isEmpty() ? smoke2 : "");
	    schedule.setWaypoint1(waypoint1 != null && !waypoint1.isEmpty() ? waypoint1 : "");
	    schedule.setWaypoint2(waypoint2 != null && !waypoint2.isEmpty() ? waypoint2 : "");
	    schedule.setWaypoint3(waypoint3 != null && !waypoint3.isEmpty() ? waypoint3 : "");

	    
		System.out.println(schedule);
		schedService.update(schedule);
		
///////////////// 캘린더 생성 되었을때 , DB베이스와 웹서버 연동 실시간으로 되도록 설정///////////////////////////
		
		
		
		// 전체 유저의 참여인원을 카운트 값 불러오는것
		int count = schedService.getCount();
		// 전체 유저의 참여인원을 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessAllId", count);
		// 탄소배출감소량 전체 유저 카운트 값 불러오는것
		Double countCarbon = schedService.getCarbonCount();
		// 탄소배출감소량 전체 유저 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessAllCarbonId", countCarbon);
		
		
		// 유저의 참여 일수를 카운트 값 불러오는것
		int countUser = schedService.getUserCount(sessUid);
		// 유저의 참여 일수를 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessId", countUser);
		
		// 탄소배출감소량 한 유저 카운트 값 불러오는것
		Double countUserCarbon =  schedService.getCarbonUserCount(sessUid);
		// 탄소배출감소량 한 유저 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessCarbonId", countUserCarbon);
		
		
		// count 외에도 여러 변수를 포함한 JSON 객체를 생성합니다.
		Map<String, Object> response = new HashMap<>();
		response.put("count", count);
		response.put("countCarbon", countCarbon);
		response.put("countUser", countUser);
		response.put("countUserCarbon", countUserCarbon);

		// Map을 JSON 문자열로 변환합니다.
		String jsonResponse = new Gson().toJson(response);

		return jsonResponse;
		
	}
	@GetMapping("/delete/{sid}")
	public String delete(@PathVariable int sid) {
		schedService.delete(sid);
		return "redirect:/schedule/calendar";
	}
	
	@PostMapping("/delete/{sid}")
	@ResponseBody
	public String delete(@PathVariable int sid, HttpSession session) {
		
		schedService.delete(sid);
		
		
///////////////// 캘린더 생성 되었을때 , DB베이스와 웹서버 연동 실시간으로 되도록 설정///////////////////////////
		String sessUid = (String) session.getAttribute("sessUid");


		// 전체 유저의 참여인원을 카운트 값 불러오는것
		int count = schedService.getCount();
		// 전체 유저의 참여인원을 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessAllId", count);
		// 탄소배출감소량 전체 유저 카운트 값 불러오는것
		Double countCarbon = schedService.getCarbonCount();
		// 탄소배출감소량 전체 유저 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessAllCarbonId", countCarbon);
		
		
		// 유저의 참여 일수를 카운트 값 불러오는것
		int countUser = schedService.getUserCount(sessUid);
		// 유저의 참여 일수를 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessId", countUser);
		
		// 탄소배출감소량 한 유저 카운트 값 불러오는것
		Double countUserCarbon =  schedService.getCarbonUserCount(sessUid);
		// 탄소배출감소량 한 유저 카운트 세션값을 다시 불러오는것
		session.setAttribute("sessCarbonId", countUserCarbon);
		
		
		// count 외에도 여러 변수를 포함한 JSON 객체를 생성합니다.
		Map<String, Object> response = new HashMap<>();
		response.put("count", count);
		response.put("countCarbon", countCarbon);
		response.put("countUser", countUser);
		response.put("countUserCarbon", countUserCarbon);
		
		// Map을 JSON 문자열로 변환합니다.
		String jsonResponse = new Gson().toJson(response);
		
		return jsonResponse;

		//return "redirect:/schedule/calendar";
	}
	
	@PostMapping("/insertAnniv")
	public String insertAnniv(HttpServletRequest req, HttpSession session) {
		String aname = req.getParameter("title");
		String sessUid = (String) session.getAttribute("sessUid");
		int isHoliday = (req.getParameter("holiday") == null) ? 0 : 1;
		String adate = req.getParameter("annivDate").replace("-", "");
		Anniversary anniv = new Anniversary(sessUid, aname, adate, isHoliday);
		annivService.insertAnniv(anniv);
		return "redirect:/schedule/calendar";
	}
	
	@PostMapping("/insertAnnivList")
	public String insertAnnivList(String option, int year) {
		List<Anniversary> list = schedUtil.getAnnivList(option, year);
		for (Anniversary anniv: list)
			annivService.insertAnniv(anniv);
		return "redirect:/schedule/calendar";
	}
	
}
