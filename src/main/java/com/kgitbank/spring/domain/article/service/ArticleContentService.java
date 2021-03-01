package com.kgitbank.spring.domain.article.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.kgitbank.spring.domain.article.dto.ArticleDto;
import com.kgitbank.spring.domain.model.ArticleVO;
import com.kgitbank.spring.domain.model.FileVO;

public interface ArticleContentService {
	
	public ArticleDto selectArticleWithWriterInfoById(String id);
	
	public List<FileVO> selectFileByArticleId(int articleId);

	public boolean saveArticleContent(ArticleVO article, MultipartFile[] files);
	
}
