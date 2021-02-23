package com.kgitbank.spring.domain.account.controller;


import java.sql.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kgitbank.spring.domain.account.dto.Sessionkey;
import com.kgitbank.spring.domain.account.service.AccountService;
import com.kgitbank.spring.domain.model.MemberVO;
import com.kgitbank.spring.global.util.SecurityPwEncoder;

import lombok.extern.log4j.Log4j;


@Controller
@Log4j
public class LoginController {
	
	@Autowired
	AccountService service;
	
	@Autowired
	SecurityPwEncoder encoder;

	@GetMapping(value = "/")
	public String main(HttpServletRequest req, HttpServletResponse rep, HttpSession session) {
		
		MemberVO loginMember = null;
		
		Cookie[] cookies = req.getCookies();
		String sessionId;
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("loginCookie") && cookie.getValue() != null) {
					System.out.println("쿠키발견 ! : " + cookie.getName() + " = "+ cookie.getValue());
					sessionId=cookie.getValue();
					loginMember = service.checkUserWithSessionkey(sessionId);
					System.out.println(loginMember);
					if(loginMember != null) {
						session.setAttribute("user", loginMember);
						return "/main/home";
					}
				}
			}
		}
		
		return "account/login";
	}

	@PostMapping(value = "/")
	public String mainsignin(MemberVO member, HttpSession session, Model model, HttpServletRequest req, HttpServletResponse rep) {
		
		
		
		MemberVO loginMember = null;

		if(session.getAttribute("login") != null)session.removeAttribute("user");
		
		loginMember = service.getLogin(member);
		if(!(encoder.matches(member.getPw(), loginMember.getPw()))) {
			loginMember = null;
		}
		
		
		log.info(loginMember);
		
		if(loginMember != null) {
			session.setAttribute("user", loginMember);
			String check = req.getParameter("remember");
			if(check != null) {
				Cookie newCookie = new Cookie("loginCookie", session.getId());
				newCookie.setPath("/");
				int amount = 60 * 60 * 24 * 7;
				newCookie.setMaxAge(amount);
				rep.addCookie(newCookie);
				Date sessionLimit = new Date(System.currentTimeMillis() + (1000*amount));
				Sessionkey key = new Sessionkey();
				key.setEmail(loginMember.getEmail());
				key.setSessionId(session.getId());
				key.setNext(sessionLimit);
				System.out.println(key);
				System.out.println(loginMember);
				service.keepLogin(key);
			}
			return "main/home";
		}else {
			System.out.println("로그인실패");
		}
		
		return "redirect:/";
	} 
	
	@PostMapping(value = "/logout")
	public String logout(HttpSession session, HttpServletRequest req, HttpServletResponse rep) {
		session.invalidate();
		Cookie[] cookies = req.getCookies();
		if(cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				System.out.println(cookies[i].getName() + " : " + cookies[i].getValue());
				cookies[i].setValue(null);
				cookies[i].setPath("/");
				cookies[i].setMaxAge(0);
				rep.addCookie(cookies[i]);
			}
		}
		return "redirect:/";
	}

}