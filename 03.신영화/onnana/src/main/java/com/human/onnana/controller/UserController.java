package com.human.onnana.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.simple.JSONObject;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import com.human.onnana.entity.Button;
import com.human.onnana.entity.User;
import com.human.onnana.service.ScheduleService;
import com.human.onnana.service.UserService;
import java.sql.Timestamp; // 새로운 import 구문 추가

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
		
		// 올바른 패스워드 규칙을 맞췄을 경우, 패스워드 변경
		if (pwd.length() >=  4 && pwd.equals(pwd2)) {
			String hashedPwd = BCrypt.hashpw(pwd, BCrypt.gensalt());
			user.setPwd(hashedPwd);
		
			  // 아래 라인에서 currentTimestamp를 생성하여 updateUser 메서드에 전달
            Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
            userService.updateUser(uid, currentTimestamp);
			
			
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
		
		return "redirect:/user/list/" + session.getAttribute("currentUserPage");
	}
	
	@GetMapping("/delete/{uid}")
	   public String delete(@PathVariable String uid, HttpSession session) {
		userService.deleteUser(uid);
		return"redirect:/user/list/"+ session.getAttribute("currentUserPage");
   }

	
	
	
	
	@GetMapping("/list/{page}")
	public String list(@PathVariable int page, HttpSession session, Model model) {
		List<User> list = userService.getUserList(page);
		model.addAttribute("userList", list);
		
		int totalUsers = userService.getUserCount();
		int totalPages = (int) Math.ceil((double)totalUsers / userService.RECORDS_PER_PAGE);
		List<String> pageList = new ArrayList<>();
		for (int i=1; i<=totalPages; i++)
			pageList.add(String.valueOf(i));
		model.addAttribute("pageList", pageList);
		session.setAttribute("currentUserPage", page);
		model.addAttribute("menu", "user"); // 유저아이콘 불들어옴
		
		return "user/list";
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
	
	
	
	
	
	@GetMapping("/analysis")
	public String analysisForm() {
		
		return "user/analysis";
	}
	

	@GetMapping("/weather")
	public String weatherForm() {
		
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

	      return "user/dust";
	   }

}



