package com.human.onnana.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {

	@GetMapping("/home")		// routing 정보, localhost:8090/sample/home
	public String home(Model model) {
		model.addAttribute("menu", "home");
		return "home";			// webapp/WEB-INF/view/home.jsp를 렌더링 해서 보여줄 것
	}
	
	@GetMapping("/index")
	@ResponseBody
	public String index() {
		return "<h1>Welcome to SpringBoot World!!!!</h1>";
	}
}
