package com.human.onnana.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;

/*
 * Servlet Filter 
 */

@Component
public class LoginFilter extends HttpFilter implements Filter{
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		HttpSession session = httpRequest.getSession();
		session.setMaxInactiveInterval(10 * 3600);		// 세션 유효시간: 10시간 
		
		
		//홈페이지 들어가면 제일 먼저 
		String uri = httpRequest.getRequestURI();
		String sessionUid = (String) session.getAttribute("sessUid");
		
		// 로그인해야만 들어올 수 있는 영역 만들기
		String[] urlPatterns = {"/user/list", "/user/update", "/user/delete", "/schedule/calendar"};
		for (String routing: urlPatterns) {
			if (uri.contains(routing)) {		
				if (sessionUid == null || sessionUid.equals("")) //위의 창을 들어갈때, 로그인이 안되어있으면
					httpResponse.sendRedirect("/onnana/home");  //로그인 창으로 보내짐
				break;
			}
		}
		chain.doFilter(request, response); 
	}
}
