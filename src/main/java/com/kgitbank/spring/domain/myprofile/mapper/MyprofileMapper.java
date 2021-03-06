package com.kgitbank.spring.domain.myprofile.mapper;

import java.util.List;

import com.kgitbank.spring.domain.model.LoginVO;
import com.kgitbank.spring.domain.model.MemberVO;

public interface MyprofileMapper {

	// UPDATE members SET name = #{name}, email = #{email}, phone = #{phone} WHERE id = #{id}
	public void updateMyprofile(MemberVO vo);
	
	// SELECT pw FROM members WHERE id = #{id}
	public String currentpw(MemberVO vo);
	
	// UPDATE members SET pw = #{pw} WHERE id = #{id}
	public int updatepw(MemberVO vo);
	
	// SELECT location, login_date FROM members JOIN logins ON seq_id = member_seq_id
	public List<LoginVO> getLoginActivityList(LoginVO lv);
	
	public String getEditInfo(String id);
	
	public int getSeqId(String id);
}
