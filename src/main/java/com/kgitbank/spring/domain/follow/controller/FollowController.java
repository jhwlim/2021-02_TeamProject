package com.kgitbank.spring.domain.follow.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kgitbank.spring.domain.account.service.AccountService;
import com.kgitbank.spring.domain.follow.service.FollowService;
import com.kgitbank.spring.domain.model.FollowVO;
import com.kgitbank.spring.domain.myprofile.dto.ProfileDto;
import com.kgitbank.spring.domain.myprofile.service.ProfileMainService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class FollowController {
	
	@Autowired
	ProfileMainService profileService;
	
	@Autowired
	FollowService followService;
	
	@Autowired
	AccountService accService;
	
	@GetMapping(value="/follow/{id}")
	public String follow(@PathVariable String id, Model model, HttpSession session) {
		
		if (id == null) {
			return "redirect:/";
		}
		
		ProfileDto member = profileService.selectMemberById(id);
		if (member == null) {
			return "redirect:/";
		}
		
		if(session.getAttribute("user") == null) {
			return "redirect:/";
		}
		
		boolean followed = false;
		
		String loginId = (String) session.getAttribute("user");
		
		ProfileDto login_id = profileService.selectMemberById(loginId);
		ProfileDto search_id = profileService.selectMemberById(id);
		
		System.out.println(login_id.getId() + " - " + search_id.getId());
		System.out.println(login_id.getSeqId() + " - " + search_id.getSeqId());
		
		List<Integer> followList = followService.selectFollow(login_id);
		System.out.println(followList);
		
		if(followList.contains(search_id.getSeqId())) {
			followed = true;
		}
		
		FollowVO vo = new FollowVO();
		
		vo.setFollowerId(login_id.getSeqId());
		vo.setFollowId(search_id.getSeqId());
		if(!followed) {
			followService.following(vo);
		}else {
			System.out.println("이미팔로우됨");
		}
		
		return "redirect:/myprofile/"+id;
	}
	
	@GetMapping(value="/ufollow/{id}")
	public String ufollow(@PathVariable String id, Model model, HttpSession session) {
		
		if (id == null) {
			return "redirect:/";
		}
		
		ProfileDto member = profileService.selectMemberById(id);
		if (member == null) {
			return "redirect:/";
		}
		
		if(session.getAttribute("user") == null) {
			return "redirect:/";
		}
		
		boolean followed = false;
		
		String loginId = (String) session.getAttribute("user");
		
		ProfileDto login_id = profileService.selectMemberById(loginId);
		ProfileDto search_id = profileService.selectMemberById(id);
		
		System.out.println(login_id.getId() + " - " + search_id.getId());
		System.out.println(login_id.getSeqId() + " - " + search_id.getSeqId());
		
		List<Integer> followList = followService.selectFollow(login_id);
		System.out.println(followList);
		
		if(followList.contains(search_id.getSeqId())) {
			followed = true;
		}
		
		FollowVO vo = new FollowVO();
		
		vo.setFollowerId(login_id.getSeqId());
		vo.setFollowId(search_id.getSeqId());
		if(followed) {
			followService.ufollow(vo);
		}else {
			System.out.println("팔로우되어있지않음");
		}
		
		
		return "redirect:/myprofile/"+id;
	}
	
	

	@ResponseBody
	@PostMapping("/follow")
	public void followByAjax(@RequestBody FollowVO vo, HttpSession session) {
		log.info("URL : /follow - POST");
		log.info("followVO=" + vo);
		
		String loginId = (String) session.getAttribute("user");
		int loginSeqId = accService.selectMemberById(loginId).getSeqId();
		vo.setFollowerId(loginSeqId);
		followService.following(vo);
	}
	
	
	@ResponseBody
	@DeleteMapping("/follow")
	public void ufollowByAjax(@RequestBody FollowVO vo, HttpSession session) {
		log.info("URL : /follow - DELETE");
		log.info("followVO=" + vo);
		
		String loginId = (String) session.getAttribute("user");
		int loginSeqId = accService.selectMemberById(loginId).getSeqId();
		vo.setFollowerId(loginSeqId);
		followService.ufollow(vo);
	}
	
	
	
	
	
	
	

}