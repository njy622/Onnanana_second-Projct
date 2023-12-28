package com.human.onnana.controller;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.sql.Timestamp;
import java.text.DecimalFormat;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.human.onnana.entity.Button;
import com.human.onnana.entity.User;
import com.human.onnana.service.ScheduleService;
import com.human.onnana.service.UserService;


@Controller
@RequestMapping("/user")
public class UserController {
	@Autowired private UserService userService;
	@Autowired private ScheduleService schedService;


	@GetMapping("/update/{uid}")
	@ResponseBody	
	//HTTP 요청의 분문 body 부분이 그대로 전달(xml이나 json기반의s메시지를 사용하는 요청의 경우)
	public String updateForm(@PathVariable String uid) {
		User user = userService.getUser(uid);
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("uid", user.getUid());
		jsonObject.put("uname", user.getUname());
		jsonObject.put("email", user.getEmail());
		return jsonObject.toJSONString();
	}
	
	@PostMapping("/update")
	public String updateProc(String pwd, String pwd2, String uname, 
							String email, HttpSession session, Model model) {
		String uid = (String) session.getAttribute("sessUid");
		User user = userService.getUser(uid); 
		// 패스워드 미입력시 어떻게 표현되는지 확인하기 위해 출력해봄(출력값: pwd=,pwd2=)
		// System.out.println("pwd="+ pwd + ",pwd2="+pwd2); 
		
		// 비밀번호 변경 로직
	    if (pwd.length() >= 4 && pwd.equals(pwd2)) {
	        String hashedPwd = BCrypt.hashpw(pwd, BCrypt.gensalt());
	        user.setPwd(hashedPwd);
        
	        

			  // 아래 라인에서 currentTimestamp를 생성하여 updateUser 메서드에 전달
          Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
          userService.updateUser(uid, currentTimestamp);
	        
	     // 세션 로그아웃 처리
	        session.removeAttribute("sessUid");
	        session.removeAttribute("sessUname");
	        session.removeAttribute("sessEmail");
	        
	        // 비밀번호 변경 성공 메시지 전달
	        model.addAttribute("msg", "비밀번호가 변경되었습니다. 다시 로그인해주세요.");
	        model.addAttribute("url", "/onnana/home"); // 로그아웃 URL로 변경

	        userService.updateUser(user);
	        return "common/alertMsg";
	        
		// 아무런 데이터를 입력하지 않은 경우, 패스워드 변경하지 않음
		} else if (pwd.equals("") && pwd2.equals("")) {
			;				//아무일도 하지 않는다.
		//그외에 경고 메세지를 보내준다.
		} else {
			model.addAttribute("msg", "패스워드를 다시 입력하고 수정하세요.");
			model.addAttribute("url", "/onnana/user/list/" + session.getAttribute("currentUserPage"));
			return "common/alertMsg";
		}
	    user.setUname(uname);
	    user.setEmail(email);
	    userService.updateUser(user);

	    return "redirect:/user/list/" + session.getAttribute("currentUserPage");
	}
	
	@GetMapping("/delete/{uid}")
	   public String delete(@PathVariable String uid, HttpSession session) {
		userService.deleteUser(uid);
		return"redirect:/user/list/"+ session.getAttribute("currentUserPage");
   }

	
	
	
	// 관리자 모드의 유저의 사용자목록창
	@GetMapping("/list/{page}")
	public String list(@PathVariable int page, HttpSession session, Model model) {
	    // 유저 리스트를 가져오는 코드
	    List<User> list = userService.getUserList(page);
	    model.addAttribute("userList", list);

	    // 페이징 처리 코드
	    int totalUsers = userService.getUserCount();
	    int totalPages = (int) Math.ceil((double) totalUsers / userService.RECORDS_PER_PAGE);
	    List<String> pageList = new ArrayList<>();
	    for (int i = 1; i <= totalPages; i++)
	        pageList.add(String.valueOf(i));
	    model.addAttribute("pageList", pageList);

	    session.setAttribute("currentUserPage", page);
	    model.addAttribute("menu", "user");

	    return "user/list";
	}
	
	
	
	// 한 유저의 사용자 창
	@GetMapping("/list2/{page}")
	public String list2(@PathVariable int page, HttpSession session, Model model) {
	    // 유저 리스트를 가져오는 코드
	    List<User> list = userService.getUserList(page);
	    model.addAttribute("userList", list);

	    // 페이징 처리 코드
	    int totalUsers = userService.getUserCount();
	    int totalPages = (int) Math.ceil((double) totalUsers / userService.RECORDS_PER_PAGE);
	    List<String> pageList = new ArrayList<>();
	    for (int i = 1; i <= totalPages; i++)
	        pageList.add(String.valueOf(i));
	    model.addAttribute("pageList", pageList);

	    session.setAttribute("currentUserPage", page);
	    model.addAttribute("menu", "user");

	    return "user/list2";
	}

	
	
	@PostMapping("/processUid")
	@ResponseBody // AJAX를 통해 JSON 데이터를 반환하기 위해 사용합니다.
	public String processUid(HttpServletRequest req, HttpSession session, @RequestParam("userUID") String userUID) {
	    System.out.println(userUID);
		// DecimalFormat 객체를 생성하여 소수점 자릿수를 지정합니다. 
		DecimalFormat decimalFormat = new DecimalFormat("#.###");
		
	    // 한유저의 캠페인 참여일수와 감소량을 jsp에서 사용자리스트 클릭시, 해당되는 사용자의 uid값을 가져와서 DB와 연동시킴
	    int listUidCount = schedService.getUserCount(userUID);
	    Double listUidcarbon = schedService.getCarbonUserCount(userUID);
	    // 한유저의 하루 평균 감소량(소숫점 3자리까지 나타냄)
	    double UserDateAve = Math.round(listUidcarbon /listUidCount * 1000.0) / 1000.0;
	    
	    
	    // 모든 유저의 캠페인 참여일수와 감소량을DB와 연동시킴
	    int listUidCountAll = schedService.getCount();
	    Double listUidcarbonAll = schedService.getCarbonCount();
	    // 모든 유저의 하루 평균 감소량(소숫점 3자리까지 나타냄)
	    double UserDateAveAll = Math.round(listUidcarbonAll /listUidCountAll * 1000.0) / 1000.0;
	    
	    
	    // 모든 유저의 평균 하루 평균 대비 나의 평균 감소량 기여도
	    double AveDifference = (int)(listUidcarbon / listUidcarbonAll *100);
	    
	    
	    Map<String, Object> response = new HashMap<>();
	    
		response.put("userlistCount", listUidCount);
		response.put("userlistCarbon", listUidcarbon);
		response.put("UserDateAve", UserDateAve);
		
		response.put("userlistCountAll", listUidCountAll);
		response.put("userlistCarbonAll", listUidcarbonAll);
		response.put("UserDateAveAll", UserDateAveAll);
		
		response.put("AveDifference", AveDifference);
		


		System.out.println(response);
		return new Gson().toJson(response) ;
	}
	
	
	@PostMapping("/processdaycarbon")
	@ResponseBody // AJAX를 통해 JSON 데이터를 반환하기 위해 사용합니다.
	public String processdaycarbon(HttpServletRequest req, HttpSession session, @RequestParam("userUID") String userUID,
			 @RequestParam("month") String month) {
	    
	    
	 

	 // 예시로 2023년의 월별 마지막 날짜를 구합니다.
        int year = 2023;
        
        // 각 월의 첫째 날
        LocalDate startDate = LocalDate.of(year, Integer.parseInt(month), 1);
        // 각 월의 마지막 날
        LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());

	     // 날짜 수 계산
        int daysInMonth = endDate.getDayOfMonth();

        // 날짜 수에 따라 배열 크기 지정
        double[] userDayCarbonSumArray = new double[daysInMonth];
        double[] userAllDayCarbonSumArray = new double[daysInMonth];
        
        int index = 0;
        // 해당 월의 시작일부터 마지막 일까지 반복하여 sdate를 생성
        for (LocalDate date = startDate; date.isBefore(endDate.plusDays(1)); date = date.plusDays(1)) {
            String formattedMonth = String.format("%02d", date.getMonthValue());
            String formattedDay = String.format("%02d", date.getDayOfMonth());
            String sdate = year + formattedMonth + formattedDay;

            // sdate를 이용하여 필요한 작업 수행
            double userDayCarbonSum = schedService.UserdaycarbonSum(userUID, sdate);
            double userAllDayCarbonSum = schedService.UserAlldaycarbonSum(sdate);
            
            // 배열에 값을 추가
            userDayCarbonSumArray[index] = userDayCarbonSum;
            userAllDayCarbonSumArray[index] = userAllDayCarbonSum;
            index++;
            
            System.out.print("유저데이터:"+userDayCarbonSum);
            System.out.print("전체 데이터:"+userAllDayCarbonSum);

            
        }
        
        Map<String, Object> responsedata = new HashMap<>();
        responsedata.put("userdaydata", userDayCarbonSumArray);
        responsedata.put("userAlldaydata", userAllDayCarbonSumArray);
        
        System.out.println(responsedata);
		return new Gson().toJson(responsedata) ;
	}
	
	
	
	
	@GetMapping("/login")
	public String loginForm() {
		return "user/login";
	}
	
	
	// 새로운 메서드 추가: 사용자의 last_login_date를 현재 시간으로 갱신
		@Transactional
		public void updateLastLoginDate(String uid, HttpSession session) {
		    Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
		    userService.updateLastLoginDate(uid, currentTimestamp);

		    // 출석 횟수 계산 및 세션에 저장
		    int attendanceCount = schedService.getAttendanceCount(uid);
		    session.setAttribute("attendanceCount", attendanceCount);
		}

		
		// 새로운 메서드 추가: 사용자의 출석 횟수 증가
		@Transactional
		public void incrementAttendanceCount(String uid, HttpSession session) {
		    Integer attendanceCount = (Integer) session.getAttribute("attendanceCount");
		    if (attendanceCount == null) {
		        attendanceCount = 1;
		    } else {
		        attendanceCount++;
		    }
		    session.setAttribute("attendanceCount", attendanceCount);
		}
	
	@PostMapping("/login")
	public String loginProc(String uid, String pwd, HttpSession session, Model model) {
		int result = userService.login(uid, pwd);
		if (result == userService.CORRECT_LOGIN) {
			// 사용자 로그인 시마다 last_login_date 갱신
	        updateLastLoginDate(uid, session);
            
	        // 출석 횟수 증가
	        incrementAttendanceCount(uid, session);
			
			session.setAttribute("sessUid", uid);
			User user = userService.getUser(uid);
			session.setAttribute("sessUname", user.getUname());
			session.setAttribute("sessEmail", user.getEmail());
			
			// 게시판 글 전체 카운트
			session.setAttribute("sessAllId", schedService.getCount());
			// 게시판 글 유저 카운트
			session.setAttribute("sessId", schedService.getUserCount(uid));
						
			// 탄소배출감소량 전체 유저 카운트
			session.setAttribute("sessAllCarbonId", schedService.getCarbonCount());
			// 탄소배출감소량 한 유저 카운트
			session.setAttribute("sessCarbonId", schedService.getCarbonUserCount(uid));
			
			
			
			
			// 환영 메세지
			// 로그인 입력 잘못해도, home으로 바로 이동
			model.addAttribute("msg", user.getUname() + "님 환영합니다.");
			model.addAttribute("url", "/onnana/home");
		} else if (result == userService.WRONG_PASSWORD) {
			model.addAttribute("msg", "패스워드 입력이 잘못되었습니다.");
			model.addAttribute("url", "/onnana/home");
		} else {		// UID_NOT_EXIST
			model.addAttribute("msg", "ID 입력이 잘못되었습니다.");
			model.addAttribute("url", "/onnana/home");
		}
		return "common/alertMsg";
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/home";		// 로그아웃시, 홈으로 가도록 설정
	}
	
	@GetMapping("/register")
	public String registerForm() {
		return "user/register";
	}
	
	@PostMapping("/register")
	public String registerProc(String uid, String pwd, String pwd2, 
								String uname, String email, Model model) {
		if (userService.getUser(uid) != null) {
			model.addAttribute("msg", "사용자 ID가 중복되었습니다.");
			model.addAttribute("url", "/onnana/user/register");
		}
		if (pwd.equals(pwd2) && pwd.length() >= 4) {	// pwd와 pwd2가 같고, 길이가 4이상이면
			String hashedPwd = BCrypt.hashpw(pwd, BCrypt.gensalt());
			User user = new User(uid, hashedPwd, uname, email);
			userService.insertUser(user);
			model.addAttribute("msg", "등록을 마쳤습니다. 로그인 하세요.");
			model.addAttribute("url", "/onnana/home");
		} else {
			model.addAttribute("msg", "패스워드 입력이 잘못되었습니다.");
			model.addAttribute("url", "/onnana/user/register");
		}
		return "common/alertMsg";
	}
	
	//아이디 찾기 창
	@GetMapping("/Idsearch")
	public String IdsearchForm() {
		return "user/Idsearch";
	}
	
	
	// 아이디 찾기 기능
	@PostMapping("/Idsearch")
	public String IdsearchProc(String uname, String email, HttpSession session, Model model, HttpServletRequest req) {
		String searchUname = req.getParameter("idUname");
		String searchEmail = req.getParameter("idEmail");
		String searchID = userService.idsearch(searchUname, searchEmail);
		System.out.println(searchUname);
		System.out.println(searchEmail);
		System.out.println(searchID);
		
		if (userService.idsearch(searchUname, searchEmail) == null ) {
			model.addAttribute("msg", "입력하신 정보와 일치하는 정보가 없습니다 다시 확인바랍니다.");
			model.addAttribute("url", "/onnana/user/Idsearch");
		}else {
			model.addAttribute("msg", "요청하는 ID는 "+searchID+"입니다 홈페이지로 이동합니다.");
			model.addAttribute("url", "/onnana/home");
		}
			

		return  "common/alertMsg";
	}
	
	//비밀번호 찾기 창
	@GetMapping("/Pwdchange")
	public String PwdchangeForm() {
		return "user/Pwdchange";
	}
	
	
	//비밀번호 찾기기능
	@PostMapping("/Pwdchange")
	public String PwdchangeProc(String pwd, String pwd2, String uname, 
			String email, HttpSession session, Model model, HttpServletRequest req) {
		
		String uid = req.getParameter("pwdUid");
		User user = userService.getUser(uid); 
		
		String searchUname = req.getParameter("pwdUname");
		String searchEmail = req.getParameter("pwdEmail");
		String checkUserInfo = userService.userinfosame(searchUname,uid, searchEmail).toString();
		
		
		if (checkUserInfo.equals("true")) {
			
			
			// 비밀번호 변경 로직
			if (pwd.length() >= 4 && pwd.equals(pwd2)) {
				String hashedPwd = BCrypt.hashpw(pwd, BCrypt.gensalt());
				user.setPwd(hashedPwd);
				
				// 비밀번호 변경 성공 메시지 전달
				model.addAttribute("msg", "비밀번호가 변경되었습니다. 다시 로그인해주세요.");
				model.addAttribute("url", "/onnana/home"); // 로그아웃 URL로 변경
				
				userService.updateUser(user);
				return "common/alertMsg";
				
				// 아무런 데이터를 입력하지 않은 경우, 패스워드 변경하지 않음
			} else if (pwd.equals("") && pwd2.equals("")) {
				;				//아무일도 하지 않는다.
				//그외에 경고 메세지를 보내준다.
			} else {
				model.addAttribute("msg", "패스워드가 일치하지 않습니다.");
				model.addAttribute("url", "/onnana/user/Pwdchange");
				return "common/alertMsg";
			}
			user.setUname(uname);
			user.setEmail(email);
			userService.updateUser(user);
			
			return "redirect:home";
		}else {
			
			model.addAttribute("msg", "입력하신 정보는 조회되지 않습니다. 다시 확인바랍니다.");
			model.addAttribute("url", "/onnana/user/Pwdchange");
			
		
			
		}
		
		System.out.println(uid);
		System.out.println(searchUname);
		System.out.println(searchEmail);
		System.out.println(checkUserInfo);
		System.out.println(checkUserInfo.getClass().getName());
		
		return "common/alertMsg";
	}
	
	
	
	@GetMapping("/analysis")
	public String analysisForm() {
		
		return "user/analysis";
	}
	

	@PostMapping("/weather")
	public String weatherForm(Model model) {
		model.addAttribute("menu", "weather"); // 아이콘 불들어옴

		return "user/weather";
	}
	
	
	
	@GetMapping("/weather")
	public String weatherProc(Model model) throws Exception {
		URI uri = new URI("http://localhost:5000/test");
		RestTemplate rest = new RestTemplate();
		ResponseEntity<String> response = rest.getForEntity(uri, String.class);
	      System.out.println(response.getBody());
		model.addAttribute("data", response.getBody());

	
		return "user/weather";
   }
	
	
	
	
	
	@PostMapping("/getAirQuality")
    public String getAirQuality(@RequestBody String stationName) {
        StringBuilder result = new StringBuilder();

        try {
            String apiUrl = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty";
            String serviceKey = "nBg+Hwr/AcIl8mQ6pviMUSuy9Te5CDEJKfw5CIJn6tTDevZ5u3SL7vCng8+lzQcmLlJ7o6Eqy91xpF+4UMQzGA=="; // 여기에 서비스 키 입력

            String dataType = "json";
            int numOfRows = 1;
            int pageNo = 1;
            String dataTerm = "DAILY";
            String version = "1.4";

            String urlString = String.format("%s?serviceKey=%s&returnType=%s&numOfRows=%d&pageNo=%d&stationName=%s&dataTerm=%s&ver=%s",
                    apiUrl, serviceKey, dataType, numOfRows, pageNo, stationName, dataTerm, version);

            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }
            rd.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result.toString();
    }
	
	
	   @GetMapping("/dust")
	   public String dustForm(Model model) {
	      List<Button> buttons = new ArrayList<>();
	        buttons.add(new Button("376,15,458,58", "modal1")); // 좌표 및 모달 ID를 설정
	        buttons.add(new Button("50,60,70,80", "modal2")); // 다른 버튼 추가

	        model.addAttribute("buttons", buttons);
			model.addAttribute("menu", "dust"); // 아이콘 불들어옴


	      return "user/dust";
	   }
	   
	   
	   
	   
	   
	   

}