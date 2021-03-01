<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/jstl.jspf" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous">

<%@ include file="/WEB-INF/include/commonCss.jspf" %>
<%@ include file="/WEB-INF/include/headerCss.jspf" %>

<!-- bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>

<!-- jquery -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<!-- jquery.form.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.3.0/jquery.form.min.js" integrity="sha384-qlmct0AOBiA2VPZkMY3+2WqkHtIQ9lSdAsAn5RUJD/3vA5MKDgSGcdmIv4ycVxyn" crossorigin="anonymous"></script>

<style>
.wrapper {
	min-height: calc(100vh - 62px);
}
.container {
	padding-top: 40px;
}
.article {
	display: flex;
	justify-content: center;
}
.article__content {
	max-height: 500px;
}
.article__content--image {
	background-color: black;
	width: 450px;
	height: 600px;
	padding: 20px;
	display: flex;
	align-content: center;
}
.article__content--description {
	width: 300px;
	border: 1px solid black;
}
.article__figure {
	width: 100%;
	height: 100%;
}
.article__img {
	width: 100%;
	height: 100%;
	object-fit: contain;	/* scale-down contain */
}
.article__writer-figure {
	display: inline-block;
	width: 40px;
	height: 40px;
	border-radius: 50%;
	overflow: hidden;
	margin: 0 10px;
}
.article__writer-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}
.article__header {
	height: 60px;
	display: flex;
	align-items: center;
	border-bottom: 1px solid gray;
}
.article__text {
	padding: 10px;
}
.comment {
	box-sizing: border-box;
	display: flex;
	vertical-align: top;
}
.comment__content {
	display: inline-block;
	width: calc(100% - 70px);
}
.comment__text {
	overflow: normal;
}
.article__text-container {
	height: calc(100% - 60px - 60px);
	overflow: auto;
}
.comment-write {
	height: 60px;
}
</style>
</head>
<body>

<%@ include file="/WEB-INF/include/header.jspf" %>

<div class="wrapper">
    <div class="container">
    	<div class="row article">
    		<div class="col-1 carousel slide article__content article__content--image" id="carouselExampleControls" data-bs-ride="carousel">
   			  	<div class="carousel-inner">
				  	<c:forEach var="file" items="${article.files}" varStatus="status">
					    <div class="carousel-item article__figure ${status.first ? 'active' : ''}">
					    	<img src="<c:url value = '/image/article/${file.imgPath}/' />"
					      		class="d-block w-100 article__img" alt="...">
					    </div>
					</c:forEach>
			  	</div>
				<button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls"  data-bs-slide="prev">
					<span class="carousel-control-prev-icon" aria-hidden="true"></span>
					<span class="visually-hidden">Previous</span>
				</button>
				<button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls"  data-bs-slide="next">
				  	<span class="carousel-control-next-icon" aria-hidden="true"></span>
				  	<span class="visually-hidden">Next</span>
				</button>
			</div>
    		<div class="col-1 article__content article__content--description">
    			<div class="article__header">
    				<figure class="article__writer-figure">
    					<img src="<c:url value = '/image/profile/${article.imgPath}/'/>" alt="" class="article__writer-img"> 
    				</figure>
    				${article.writerId}
    			</div>
    			<div class="article__text-container">
	   				<div class="article__text">
		   				<pre>${article.content}</pre>
		   			</div>
	   				
	   				<!-- 작업하실 영역 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ -->
	   				
	   				<div class="comments">
	   					<!-- 작성된 댓글이 보여지는 영역 -->
	   					<div class="comment">
	   						<figure class="article__writer-figure">
		    					<img src="<c:url value = '/image/profile/${"imgPath"}/'/>" alt="" class="article__writer-img"> 
		    				</figure>
		    				<div class="comment__content">
		    				${"댓글 작성자 아이디"}
	  						<p class="comment__text">
	  							${"댓글 내용"}
	  						</p>
	   						${"댓글 작성일"}
	   						</div>
	   					</div>
	   				</div>
   				</div>
   				<div class="comment-write">
   					<!-- 댓글을 작성하는 영역 -->
   					<input type="text" />
   					<button>작성</button>
   				</div>
   					
   			</div>
    	</div>
    	<hr>
    </div>    
</div>

<script>
$('.article__img').on('error', function() {
	this.src = "<c:url value = '/resources/image/article/alternative.jpg'/>";
});
</script>

</body>
</html>