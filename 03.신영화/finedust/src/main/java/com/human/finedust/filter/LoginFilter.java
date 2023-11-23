package com.human.finedust.filter;

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
public class LoginFilter extends HttpFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		HttpSession session = httpRequest.getSession();
		session.setMaxInactiveInterval(10 * 3600);  		// 세션 유효시간: 10시간  (3600은 초(seconds)!)
		
		String uri = httpRequest.getRequestURI();
		String sessionUid = (String) session.getAttribute("sessUid");
		
		// 로그인 해야만 들어올 수 있는 path
		String[] urlPatterns = {"/user/list", "/user/update", "/user/delete", "/schedule"};	
		for (String routing: urlPatterns) {
			if (uri.contains(routing)) {
				if (sessionUid == null || sessionUid.equals(""))
					httpResponse.sendRedirect("/finedust/user/login");
				break;
			}
		}
		
		chain.doFilter(request, response); 		//response를 이용해 응답의 필터링 작업 
	}
	
}
