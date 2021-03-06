package com.kgitbank.spring.domain.article.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.kgitbank.spring.domain.account.service.AccountService;
import com.kgitbank.spring.domain.article.dto.ArticleDto;
import com.kgitbank.spring.domain.article.service.ArticleCommentService;
import com.kgitbank.spring.domain.article.service.ArticleContentService;
import com.kgitbank.spring.domain.model.ArticleLikeVO;
import com.kgitbank.spring.domain.model.CommentVO;

import lombok.extern.log4j.Log4j;


@Controller
@Log4j
public class ArticleContentController {

	@Autowired
	ArticleContentService service;
	
	@Autowired
	AccountService accService;

	@Autowired
	ArticleCommentService commentService;
	
	@GetMapping(value = "/post/{id}")
	public String getContent(@PathVariable("id") String id, 
							 Model model,
							 HttpSession session) {
		log.info("URL : /post/ - GET");
		log.info("id=" + id);
		
		String loginId = (String) session.getAttribute("user");
		if (loginId == null) {
			return "redirect:/"; 
		}
		
		// 게시물에 대한 정보를 조회
		ArticleDto article = service.selectArticleWithWriterInfoById(id);
		if (article == null) {
			return "redirect:/";
		}
		article.setFiles(service.selectFileByArticleId(article.getId()));
		
		// 해당 게시물에 로그인한 아이디가 좋아요를 눌렀는지 확인
		ArticleLikeVO likeVO = new ArticleLikeVO(article.getId(), accService.selectMemberById(loginId).getSeqId());
		article.setHasLike(service.selectCountLikeByMemberSeqIdAndArticleId(likeVO) == 1 ? true : false);
		
		// 게시물에 대한 댓글 리스트를 조회
		List<CommentVO> comments = commentService.listComment(article.getId());
		log.info("댓글 리스트 : " + comments);
		article.setComments(comments);

		log.info("게시글 : " + article);
		model.addAttribute("article", article);
		
		return "article/article";
	}
	
	@GetMapping(value = "/tag/{tag}")
	public String searchArticlesByTagName(@PathVariable String tag, Model model) {
		log.info("URL : /post/ - GET");
		log.info("tag=" + tag);
		
		model.addAttribute("totalCount", service.selectTotalCountOfArticlesByTagName(tag));
		
		return "article/tag";
	}
	
	@GetMapping(value = "/hotclip") 
	public String getHotClipPage() {
		log.info("URL : /post/ - GET");
		
		return "article/hotclip";
	}
}
