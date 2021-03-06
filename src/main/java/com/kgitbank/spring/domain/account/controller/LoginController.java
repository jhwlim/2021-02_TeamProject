package com.kgitbank.spring.domain.account.controller;

import java.sql.Date;
import java.util.List;

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
import com.kgitbank.spring.domain.account.service.GetIp;
import com.kgitbank.spring.domain.account.service.LoginService;
import com.kgitbank.spring.domain.follow.FollowDto;
import com.kgitbank.spring.domain.follow.service.FollowService;
import com.kgitbank.spring.domain.model.FollowVO;
import com.kgitbank.spring.domain.model.LoginVO;
import com.kgitbank.spring.domain.model.MemberVO;
import com.kgitbank.spring.domain.myprofile.dto.ProfileDto;
import com.kgitbank.spring.global.config.SessionConfig;
import com.kgitbank.spring.global.util.SecurityPwEncoder;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class LoginController {
	
	
	@Autowired
	LoginService service;
	
	@Autowired
	SecurityPwEncoder encoder;
	
	@Autowired
	GetIp getip;
	
	@Autowired
	AccountService accService;
	
	@Autowired
	FollowService followService;
	
	@GetMapping(value = "/")
	public String main(HttpServletRequest req, HttpServletResponse rep, HttpSession session, Model model) {
		
		MemberVO loginMember = null;
		
		String doubleLogin = "";
		
		Cookie[] cookies = req.getCookies();
		String sessionId;
		
		// 로그인 세션이 있다면 home으로 이동시킴
		String loginId = (String) session.getAttribute("user");
		if(loginId != null) {
			System.out.println("이미 로그인한 상태!!");
			
			int loginSeqId = accService.selectMemberById(loginId).getSeqId();
			model.addAttribute("follows", followService.selectProfileOfFollow(loginSeqId));
			
			List<FollowDto> topFiveFollows = followService.selectTop5Follows();
			FollowVO vo = new FollowVO();
			vo.setFollowerId(loginSeqId);
			for(FollowDto f : topFiveFollows) {
				vo.setFollowId(f.getSeqId());
				f.setFollowed(followService.checkFollow(vo));
			}
			log.info(topFiveFollows);
			model.addAttribute("topFiveFollows", topFiveFollows);
			
			return"/main/home";
		}
		
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("loginCookie") && cookie.getValue() != null) {
					sessionId=cookie.getValue();
					System.out.println(sessionId);
					loginMember = service.checkUserWithSessionkey(sessionId);
					
					
					System.out.println(loginMember);
					if(loginMember != null) {
						
						doubleLogin = SessionConfig.getSessionidCheck("user", loginMember.getId());
						session.setAttribute("user", loginMember.getId());
						
						session.setAttribute("userProfile", loginMember.getImgPath()); // 프로필 이미지도 세션 영역에 추가
						session.setAttribute("name", loginMember.getName());
						
						LoginVO logvo = new LoginVO();
						
						logvo.setMemberSeqId(loginMember.getSeqId());
						logvo.setIp(getip.getIp(req));
						service.loginHistory(logvo);
						
						if(doubleLogin != "") {
							
							Date sessionLimit = new Date(System.currentTimeMillis());
							
							Sessionkey key = new Sessionkey();
							key.setEmail(loginMember.getEmail());
							key.setSessionId(session.getId());
							key.setNext(sessionLimit);
							
							service.keepLogin(key);
						}
					
						model.addAttribute("follows", followService.selectProfileOfFollow(loginMember.getSeqId()));
						
						List<FollowDto> topFiveFollows = followService.selectTop5Follows();
						FollowVO vo = new FollowVO();
						vo.setFollowerId(loginMember.getSeqId());
						for(FollowDto f : topFiveFollows) {
							vo.setFollowId(f.getSeqId());
							f.setFollowed(followService.checkFollow(vo));
						}
						log.info(topFiveFollows);
						model.addAttribute("topFiveFollows", topFiveFollows);
						
						return "/main/home";
					}
				}
			}
		}
	
		return "account/login";
	}

	@PostMapping(value = "/")
	public String mainsignin(MemberVO member, HttpSession session, Model model, HttpServletRequest req, HttpServletResponse rep) {
		
		String doubleLogin = "";
		
		MemberVO loginMember = null;

		if(session.getAttribute("user") != null)session.removeAttribute("user");
		
		loginMember = service.getLogin(member);
		if(loginMember != null) {
			if(!(encoder.matches(member.getPw(), loginMember.getPw()))) {
				loginMember = null;
				req.setAttribute("loginFailMsg", "입력한 아이디와 비밀번호가 일치하지 않습니다. <br>아이디 또는 비밀번호를 다시 한번 입력해 주세요.");
				
			}
		}else {
			req.setAttribute("loginFailId", "해당 아이디가 없습니다.");
		}

		log.info(loginMember);
		
		if(loginMember != null) {
			
			System.out.println("다시로그인??");
			System.out.println("현재 세션 아이디" + session.getId());
			doubleLogin = SessionConfig.getSessionidCheck("user", loginMember.getId());
			session.setAttribute("user", loginMember.getId());
			
			session.setAttribute("userProfile", loginMember.getImgPath()); // 프로필 이미지도 세션 영역에 추가
			session.setAttribute("userName", loginMember.getName());
			
			System.out.println(getip.getIp(req));
			
			
			LoginVO logvo = new LoginVO();
			
			logvo.setMemberSeqId(loginMember.getSeqId());
			logvo.setIp(getip.getIp(req));
			log.info(logvo);
			
			service.loginHistory(logvo);
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

					service.keepLogin(key);
			}
			
			if(doubleLogin != "") {
				
				Date sessionLimit = new Date(System.currentTimeMillis());
				
				Sessionkey key = new Sessionkey();
				key.setEmail(loginMember.getEmail());
				key.setSessionId(session.getId());
				key.setNext(sessionLimit);
				
				service.keepLogin(key);
			}
			
			model.addAttribute("follows", followService.selectProfileOfFollow(loginMember.getSeqId()));
			
			List<FollowDto> topFiveFollows = followService.selectTop5Follows();
			FollowVO vo = new FollowVO();
			vo.setFollowerId(loginMember.getSeqId());
			for(FollowDto f : topFiveFollows) {
				vo.setFollowId(f.getSeqId());
				f.setFollowed(followService.checkFollow(vo));
			}
			log.info(topFiveFollows);
			model.addAttribute("topFiveFollows", topFiveFollows);
			
			return "main/home";
		}else {
			System.out.println("로그인실패");
		}
		
		return "account/login";
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
	
	@PostMapping(value = "/sessiondel")
	public String sessiondel(HttpSession session) {
		
		session.invalidate();
		
		return "redirect:/";
	}

}
