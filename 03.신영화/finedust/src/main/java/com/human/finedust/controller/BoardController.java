package com.human.finedust.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BoardController {
	
	
	@GetMapping("/board")	// routing 정보, localhost:8090/finedust/home
	public String home(Model model) {
		model.addAttribute("menu", "board");
		return "board";		// webapp/WEB-INF/view/home.jsp 를 렌더링해서 보여줄 것
	}

}
