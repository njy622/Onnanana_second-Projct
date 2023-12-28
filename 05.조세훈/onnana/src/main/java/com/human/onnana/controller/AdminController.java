package com.human.onnana.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@GetMapping("/index")
	public String adminIndex() {
		return "admin/index";
	}
	
	@GetMapping("/tables")
	public String tables() {
		return "admin/tables";
	}
	
	@GetMapping("/401")
	public String unauthorized() {
		return "admin/401";
	}
	
	@GetMapping("/404")
	public String urlNotFound() {
		return "admin/404";
	}
	
	@GetMapping("/500")
	public String internalServerError() {
		return "admin/500";
	}
	
	@GetMapping("/charts")
	public String charts() {
		return "admin/charts";
	}
	
	@GetMapping("/lightbar")
	public String lightBar() {
		return "admin/layout-sidenav-light";
	}
	
	@GetMapping("/layoutStatic")
	public String layoutStatic() {
		return "admin/layout-static";
	}
	
	@GetMapping("/login")
	public String login() {
		return "admin/login";
	}
	
	@GetMapping("/password")
	public String password() {
		return "admin/password";
	}
	
	@GetMapping("/register")
	public String register() {
		return "admin/register";
	}
	
	
}
