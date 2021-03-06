<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/jstl.jspf"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>


<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css"
	integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk"
	crossorigin="anonymous">

<!-- css -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.0.8/css/all.css">
<link rel="stylesheet"
	href="/spring/resources/css/mainpage/main.css?ver=1.0">
<link rel="stylesheet"
	href="/spring/resources/css/profile/profile.css?ver=1.1">
<link rel="stylesheet"
	href="<c:url value = '/resources/css/profile/profile_img_edit.css?ver=1.0' />" />
<link rel="stylesheet"
	href="<c:url value = '/resources/css/article/article.css?ver=2.1' />" />
<link rel="stylesheet"
	href="<c:url value = '/resources/css/article/article_modal.css?ver=1.0' />" />
<link rel="stylesheet"
	href="<c:url value = '/resources/css/article/follow_modal.css?ver=1.0' />" />
<link rel="stylesheet"
	href="<c:url value = '/resources/css/article/article_more.css?ver=1.1' />" />

<!-- jquery -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"
	integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
	crossorigin="anonymous"></script>
<!-- jquery.form.js -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.3.0/jquery.form.min.js"
	integrity="sha384-qlmct0AOBiA2VPZkMY3+2WqkHtIQ9lSdAsAn5RUJD/3vA5MKDgSGcdmIv4ycVxyn"
	crossorigin="anonymous"></script>

</head>
<body style="overflow-y: scroll;">

	<%@ include file="/WEB-INF/include/nav.jspf"%>

	<header>
		<div class="container">
			<div class="profile">
				<div class="profile-image">
					<figure class="summary__image-area" id="profileImgEditOpen">
						<img src="<c:url value = '/image/profile/${member.imgPath}/' />"
							class="summary__image" id="profileImg" />
					</figure>
				</div>
				<div class="profile-user-settings">
					<h1 class="profile-user-name">${member.id}</h1>
					<c:if test="${member.signedIn}">
						<button class="profile-btn profile-edit-btn" onclick="location.href='<c:url value='/account/edit'/>'">Edit Profile</button>
					</c:if>
					<c:if test="${!member.signedIn}">
						<button class="profile-btn profile-edit-btn">
							<c:if test="${member.id ne user }">
								<c:if test="${myfollow.followCheck eq false}">
									<a href="/spring/follow/${member.id }">팔로우하기</a>
								</c:if>
								<c:if test="${myfollow.followCheck eq true}">
									<a href="/spring/ufollow/${member.id }">팔로우해제</a>
								</c:if>
							</c:if>
						</button>
						
					</c:if>
					<button class="profile-btn profile-settings-btn"
						aria-label="Profile Settings">
						<i class="fas fa-cog" aria-hidden=""></i>
					</button>
				</div>
				<div class="profile-stats">
					<ul>
						<li><span class="profile-stat-count">${member.post}</span>
							posts</li>
						<li><span class="profile-stat-count">${follow.followerList.size()}</span> <span id="follower">followers</span></li>
						<li><span class="profile-stat-count">${follow.followList.size()}</span>	<span id="follow">following</span></li>
					</ul>
				</div>
				<div class="profile-bio">
					<p>
						<span class="profile-real-name">${member.name}</span>
						${member.profile}
					</p>
				</div>
			</div>
			<!--            End of Profile Section-->
		</div>
		<!--        End of Container-->
	</header>
	
	<main>
		<div class="container">
			<!-- Gallery-->
			<div class="gallery" id="gallery" style="min-height: 400px;">
				<c:if test="${member.post == 0}">
				게시물이 작성되지 않았음.
			</c:if>
			</div>
			<div class="loader"></div>
		</div>
	</main>

	<!-- Follow Modal -->
	<div class="follow-modal" id="followModal">
        <div class="follow-modal__container">
            <header class="follow-modal__header" id="follow_title">팔로우</header>
            <ul class="follow-modal__list" id="follow_table"></ul>
            <button class="follow-modal__close" id="followClose">X</button>
        </div>
    </div>

	<!-- Article Modal -->
	<button id="articleModalOpen" style="display: none"></button>

	<div class="article-modal" id="articleModal">
		<div class="container article-modal__container">
			<div class="col-9">
				<div class="row">
					<div class="col-8" style="padding: 0;">
						<div class="d-flex flex-column mt-4 mb-4">
							<div class="article" id="article"></div>
						</div>
					</div>
					<div class="col-4" style="padding: 0;">
						<div class="d-flex flex-column mt-4 mb-4">
							<div class="card" style="height: 500px; position: relative;">
								<div class="article__more">
									<img src="<c:url value='/resources/image/article/more.png'/>" alt="" style="height: 100%;"/>
								</div>
								<div class="card-header" style="padding: 12px 16px;">
									<div class="d-flex flex-row align-items-center">
										<div
											class="rounded-circle overflow-hidden d-flex justify-content-center border align-items-center post-profile-photo mr-3"
											style="width: 36px; height: 36px;">
											<img id="articleModalWriterImg"
												style="transform: scale(1.5); width: 100%; position: absolute; left: 0;">
										</div>
										<span class="font-weight-bold" id="articleModalWriterId"></span>
									</div>
								</div>
								<div class="card-body p-0">
									<div class="pl-3 pr-3 pb-2"
										style="height: 280px; overflow: auto; padding-top: 16px;">
										<p class="d-block mb-1" style="white-space: pre-wrap;"
											id="articleModalContent"></p>
										<small class="text-muted" id="articleModalWriteDate">4 HOURS AGO</small>
										<div class="comments" id="comments" style="margin-top: 10px;"></div>
									</div>

									<div
										class="d-flex flex-row justify-content-between pl-3 pr-3 pt-3 pb-1 article__btns">
										<ul class="list-inline d-flex flex-row align-items-center m-0">
											<li class="list-inline-item">
												<button class="btn p-0" id="articleModalLikeBtn">
													<div id="articleModalHeart" class="content">
														<span class="heart"></span>
													</div>
												</button>
											</li>
											<li class="list-inline-item ml-2">
												<button class="btn p-0">
													<svg width="1.6em" height="1.6em" viewBox="0 0 16 16"
														class="bi bi-chat" fill="currentColor"
														xmlns="http://www.w3.org/2000/svg">
                                                     <path
															fill-rule="evenodd"
															d="M2.678 11.894a1 1 0 0 1 .287.801 10.97 10.97 0 0 1-.398 2c1.395-.323 2.247-.697 2.634-.893a1 1 0 0 1 .71-.074A8.06 8.06 0 0 0 8 14c3.996 0 7-2.807 7-6 0-3.192-3.004-6-7-6S1 4.808 1 8c0 1.468.617 2.83 1.678 3.894zm-.493 3.905a21.682 21.682 0 0 1-.713.129c-.2.032-.352-.176-.273-.362a9.68 9.68 0 0 0 .244-.637l.003-.01c.248-.72.45-1.548.524-2.319C.743 11.37 0 9.76 0 8c0-3.866 3.582-7 8-7s8 3.134 8 7-3.582 7-8 7a9.06 9.06 0 0 1-2.347-.306c-.52.263-1.639.742-3.468 1.105z" />
                                                 </svg>
												</button>
											</li>
											<li class="list-inline-item ml-2">
												<button class="btn p-0">
													<svg width="1.6em" height="1.6em" viewBox="0 0 16 16"
														class="bi bi-share" fill="currentColor"
														xmlns="http://www.w3.org/2000/svg">
                                                     <path
															fill-rule="evenodd"
															d="M11.724 3.947l-7 3.5-.448-.894 7-3.5.448.894zm-.448 9l-7-3.5.448-.894 7 3.5-.448.894z" />
                                                     <path
															fill-rule="evenodd"
															d="M13.5 4a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3zm0 1a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5zm0 10a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3zm0 1a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5zm-11-6.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3zm0 1a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z" />
                                                 </svg>
												</button>
											</li>
										</ul>
										<div>
											<button class="btn p-0">
												<svg width="1.6em" height="1.6em" viewBox="0 0 16 16"
													class="bi bi-hdd" fill="currentColor"
													xmlns="http://www.w3.org/2000/svg">
                                                 <path
														fill-rule="evenodd"
														d="M14 9H2a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-1a1 1 0 0 0-1-1zM2 8a2 2 0 0 0-2 2v1a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-1a2 2 0 0 0-2-2H2z" />
                                                 <path
														d="M5 10.5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0zm-2 0a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0z" />
                                                 <path
														fill-rule="evenodd"
														d="M4.094 4a.5.5 0 0 0-.44.26l-2.47 4.532A1.5 1.5 0 0 0 1 9.51v.99H0v-.99c0-.418.105-.83.305-1.197l2.472-4.531A1.5 1.5 0 0 1 4.094 3h7.812a1.5 1.5 0 0 1 1.317.782l2.472 4.53c.2.368.305.78.305 1.198v.99h-1v-.99a1.5 1.5 0 0 0-.183-.718L12.345 4.26a.5.5 0 0 0-.439-.26H4.094z" />
                                             </svg>
											</button>
										</div>
									</div>
									<div class="article__likes" id="articleModalLikeCnt"
										style="font-weight: bold; padding: 0 16px;">
										<span></span> likes
									</div>
									<div class="position-relative comment-box">
                                        <form name="commentInsertForm" class="commentInsertForm" action="/spring/comment/insert" method="POST">
                                            <input type="hidden" name="id" value="" id="commentInsertFormId" />
						   					<input type="text" name="content" id="content" class="w-100 border-0 p-3 input-post" placeholder="Add a comment...">
                                            <button name="commentInsertBtn" class="btn btn-primary position-absolute btn-ig">Post</button>
                                        </form>
                                    </div>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
		<button class="article-modal__close" id="articleModalClose">X</button>
	</div>

	<script>
    $('#articleModalOpen').on('click', function(){
        $('#articleModal').css('display', 'flex');
    });

    $('#articleModalClose').on('click', function() {
        $('#articleModal').hide();
    });
</script>

	<c:if test="${member.signedIn}">
		<form method="POST" action="<c:url value='/image/profile' />"
			enctype="multipart/form-data" id="uploadForm">
			<input type="file" accept="image/jpeg, image/png" name="file"
				class="file-upload" /> <input type="hidden" name="seqId"
				value="${member.seqId}" />
		</form>

		<div class="profile-img-edit" id="profileImgEdit">
			<div class="profile-img-edit__container">
				<header class="profile-img-edit__header"> 프로필 사진 바꾸기 </header>
				<ul class="profile-img-edit__list">
					<li
						class="profile-img-edit__option profile-img-edit__option--upload profile-upload">사진
						업로드</li>
					<li
						class="profile-img-edit__option profile-img-edit__option--delete"
						id="profileImgDelete">현재 사진 삭제</li>
					<li class="profile-img-edit__option" id="profileImgEditClose">취소</li>
				</ul>
			</div>
		</div>

		<script>
        $('#profileImgEditOpen').on('click', function(){
            $('#profileImgEdit').css('display', 'flex');
        });

        $('#profileImgEditClose').on('click', function() {
            $('#profileImgEdit').hide();
        });
    </script>

		<script>
	var profileImgEdit = document.getElementById('profileImgEdit');
	var hasImg = ${member.hasImg};
	var prevImgPath = null;
	
	if (!hasImg) { // 프로필 이미지가 설정되어 있지 않다면
		$("#profileImgEditOpen").off('click'); // 모달창 생성하지 못하게 이벤트 제거
		$('#profileImgEditOpen').on('click', function() { // 파일 업로드창 띄우기
			$('.file-upload').click();
		});
	}

	$(".profile-upload").on('click', function(event) {
		$('.file-upload').click();
	});
	
	$(".file-upload").on('change', function() {
		if (this.files.length == 1) {
			$("#uploadForm").submit();	
			this.value = '';
		}
	});
	
	$('#uploadForm').ajaxForm({
		beforeSend: function() {
			prevImgPath = $('#profileImg').attr('src');
			$("#profileImg").attr("src", "<c:url value = '/image/profile/loading.gif/' />");
			$("#profileImgEditClose").click();
			$("#profileImgEditOpen").off('click'); // 파일 업로드창 띄우는 이벤트 제거			
		},
		success: function(fileName, status, xhr) {
			switch (status) {
			case "nocontent" : // 서버에 전송된 파일이 null 인 경우
				$("#profileImg").attr("src", prevImgPath);
				break;
			case "success" :
				$("#profileImg").attr("src", "<c:url value = '/image/profile/' />" + fileName + "/");
				$("#navProfileImg").attr("src", "<c:url value = '/image/profile/' />" + fileName + "/"); // 네비게이션 프로필 이미지 변경
				
				$('#profileImgEditOpen').on('click', function(){ // 모달창 생성
		            $('#profileImgEdit').css('display', 'flex');
		        });
				break;
			}
		},
		error: function() {
			alert("이미지 파일 업로드에 실패하였습니다.")
		}
	});
	
	$('#profileImgDelete').on('click', function() {
		$.ajax({
			type : "DELETE",
			url : "<c:url value='/image/profile' />",
			dataType : "text",
			data : "${member.seqId}",
			beforeSend: function() {
				$("#profileImg").attr("src", "<c:url value = '/image/profile/loading.gif/' />");
				$("#profileImgEditClose").click();
				$("#profileImgEditOpen").off('click'); // 모달창 생성하지 못하게 이벤트 제거
			},
			complete : function() {
				$("#profileImg").attr("src", "<c:url value = '/image/profile/' />");
				$("#navProfileImg").attr("src", "<c:url value = '/image/profile/' />"); // 네비게이션 프로필 이미지 변경
				$('#profileImgEditOpen').on('click', function() { // 파일 업로드창 띄우기
					$('.file-upload').click();
				});
			}
		})
	});
	

	
	</script>
	</c:if>
	<script src="<c:url value='/resources/js/article/gallery.js?ver=1.0'/> "></script>
	<script>
let isAjaxFinished = true;

getGallery = function getGallery() {
	if ($('.loader').length > 0 && $(window).scrollTop() + $(window).height() >= $('.loader').position().top) {
		if (isAjaxFinished) { // ajax 처리가 끝난 후에 다시 ajax 처리 진행
			isAjaxFinished = false;
			
			// 다음 페이지 정보 불러오기
			var cntOfArticle = $('.gallery').children().length;
			const articleCount = 6;
			var articleIndex = Math.floor(cntOfArticle/articleCount);
			
			var data = {
				writerSeqId : ${member.seqId},
				articleIndex : articleIndex,
			};
			
			$.ajax({
				type : "GET",
				url : "<c:url value='/article/' />",
				data : data,
				success : function(result) {
					var hasMore = result.hasMore;
					var articles = result.articles;
					
					for (var article of articles) {
						var galleryItem = addGalleryItem(article);
						$(galleryItem).on('click', function() {
							openArticleModal($(this).data('id'));
						});
					}
					
					if (hasMore) {
						isAjaxFinished = true;					
					} else {
						$('.loader').remove();
					}
				}
			});
		}
	}
}
$(document).ready(getGallery);
$(document).on('scroll', getGallery);

</script>
	<script>
function openArticleModal(id) {
	$.ajax({
		type : "GET",
		url : "<c:url value='/article/' />" + id,
		success : function(article) {
			// 모달 값 세팅하기
			$('#articleModal').data('id', article.id);
			$('#articleModalWriterImg').attr('src', '/spring/image/profile/' + article.imgPath + "/");
			$('#articleModalWriterId').text(article.writerId);
			$('#articleModalContent').html(article.content);
			setTagHref($('#articleModalContent a'));
			$('#articleModalLikeBtn').val(article.id);
			if (article.hasLike) {
				$('#articleModalHeart, #articleModalHeart span').addClass('heart-active');
			} else {
				$('#articleModalHeart, #articleModalHeart span').removeClass('heart-active');
			}
			$('#articleModalLikeCnt span').text(article.likeCount);
			$('#articleModalWriteDate').text(article.writeDateStr);
			
			// 이미지 값 설정하기
			var files = article.files;
			
			$('.article').html("");
			$('.article').append(createArticleItems());
			
			if (files.length == 0) {
				$('.article__items').append(createArticleItem('100%', "<c:url value = '/resources/image/article/alternative.jpg'/>"));
			} else {
				var len = files.length;
				$('.article__items').css('width', (100 * len) + '%');
				for (var i in files) {
					var el = createArticleItem((100 / len) + '%', "<c:url value = '/image/article/'/>" + files[i].imgPath + "/");
					if (i == 0) {
						$(el).addClass('article__on');
					}
					$('.article__items').append(el);
				}
				
				var prevBtn = createArticlePrevBtn();
				$(prevBtn).on('click', function() {
					addArticlePrevBtn();
				});
				$('.article').append(prevBtn);
				
				var nextBtn = createArticleNextBtn();
				$(nextBtn).on('click', function() {
					addArticleNextBtn();
				});
				$('.article').append(nextBtn);
			}
			var loginId = "${sessionScope.user}";
			$("#comments").html("");
			
			for(comment of article.comments) {
				$("#comments").append(createCommentItem(comment, comment.writerId == loginId));
			}
			
			$('[name=commentDeleteBtn]').click(function(){
				var id = $(this).data('id') + "";
				var btn = this;
				if(confirm("삭제하시겠습니까?")) {
				    $.ajax({
				        url : '/spring/comment/delete',
				        type : 'post',
				        contentType : "application/json",
				        data : JSON.stringify({id: id}),
				        complete : function(){
				            alert("삭제되었습니다.");
				            $(btn).closest('.listComment').remove();
				        }
				    });
				}
			});
			$('#commentInsertFormId').val(article.id);
			$('#articleModalOpen').click();
		},
		error : function() {
			location.href = "/spring/";
		}
	});
}

$('#articleModalOpen').on('click', function(){
    $('#articleModal').css('display', 'flex');
    $('body').css('overflow-y', 'hidden');
});

$('#articleModalClose').on('click', function() {
    $('#articleModal').hide();
    $('body').css('overflow-y', 'scroll');
});

</script>
<script src="<c:url value ='/resources/js/article/get_article_modal.js' />"></script>
	<script>
	$(document).ready(function(){
		$('.content').click(function(){
			$('.content').toggleClass("heart-active")
		  	$('.text').toggleClass("heart-active")
		  	$('.numb').toggleClass("heart-active")
		  	$('.heart').toggleClass("heart-active")
		});
	});

	function getIndexOfSlide(articleItems) {
		var articleItems = articleItems[0];
		var children = articleItems.children;
		
		// article__on 이 붙은 article의 index 찾기
		for (var i = 0; i < children.length; i++) {
			if (children[i].classList.contains("article__on")) {
				return i;
			}
		}
		return -1;
	}
	
	function addArticlePrevBtn() {
		var articleItems = $(".article__items");
		
		var idx = getIndexOfSlide(articleItems);
		articleItems[0].children[idx].classList.remove('article__on');
		
		var slideLen = articleItems[0].children.length;
		idx = (idx - 1) % slideLen;
		if (idx < 0) {
			idx += slideLen;
		}
		articleItems[0].children[idx].classList.add('article__on');
		
		moveSlide(articleItems, idx);
	}
	
	function addArticleNextBtn() {
		var articleItems = $(".article__items");
		
		var idx = getIndexOfSlide(articleItems);
		articleItems[0].children[idx].classList.remove('article__on');
		
		var slideLen = articleItems[0].children.length;
		idx = (idx + 1) % slideLen;
		articleItems[0].children[idx].classList.add('article__on');
		
		moveSlide(articleItems, idx);	
	}
	
	function moveSlide(target, idx) {
		var width = $('.article').width();
	
		target.stop().animate({
			'margin-left': -width * idx
		});
	}
	
	$(window).resize(function() {
		var article = $('.article');
		var articleItemsList = article.children('.article__items');
		var width = article.width();
		if (articleItemsList.length > 1) {
			$.each(articleItemsList, function(i, item) {
				articleItems = $(item);
				var idx = getIndexOfSlide(articleItems);
				articleItems.css({
					'margin-left': -width * idx
				});	
			})
		}
	});
	
	$('.content').on('click', function() {
		var $like = $(this).parents('.article__btns').next('.article__likes');
		var likeCnt = $($like).children('span');
		var hasLike = $(this).hasClass('heart-active');
		
		var data = {
				articleId : $(this).parent().val()
		};
		
		if (hasLike) { // 좋아요 상태
			$.ajax({
				url: "<c:url value = '/article/like'/> ",
				method: 'DELETE',
				contentType : "application/json",
				data: JSON.stringify(data),
				success: function() {
					likeCnt.text(parseInt(likeCnt.text())-1);
				}
			});
		} else {
			$.ajax({
				url: "<c:url value = '/article/like'/> ",
				method: 'POST',
				contentType : "application/json",
				data: JSON.stringify(data),
				success: function() {
					likeCnt.text(parseInt(likeCnt.text())+1);
				}
			});
		}
		
	});
	
	function setTagHref(tags) {
		for (var tag of tags) {
			var text = tag.innerText;
			tag.href = "/spring/tag/" + text.substring(1);
		}
	}
	
</script>

	<script>
/*
 * 팔로우/팔로워 관련 자바스크립트
 */
var sessionId = "${user}";

var myFollowSeqId = [];
var myFollowList = {
		  <c:forEach items="${myfollow.dtoFollowList}" var="item">
		  "${item.id}": {
		    name:"${item.name}",
		    img:"${item.imgPath}",
		    seqId:"${item.seqId}"
		  },
		  </c:forEach>
		}
for(obj in myFollowList){
   	myFollowSeqId.push(myFollowList[obj].seqId);
}

var followlist = {
		  <c:forEach items="${follow.dtoFollowList}" var="item">
		  "${item.id}": {
			id:"${item.id}",
		    name:"${item.name}",
		    img:"${item.imgPath}",
		    seqId:"${item.seqId}"
		  },
		  </c:forEach>
		}
	
	 $('#follow').on('click',function(){
	        $('#followModal').css('display', 'flex');
	        
	        $('#follow_title').text("팔로우");
	        $('#follow_table').html("");
	        for(obj in followlist){
	        	var tmp = myFollowSeqId.includes(followlist[obj].seqId)
	        	if(sessionId == followlist[obj].id){
        			tmp = true;
        		}
	        	
	        	var isLoginId = followlist[obj].id == "${user}";
	        	var item = createFollowModalItem(followlist[obj], tmp, isLoginId);
        		
	        	$('#follow_table').append(item);	        		
	        	
	        	var btn = $(item).find('.follow-modal__btn');
        		console.log(btn);
	        	$(btn).data('seqId', followlist[obj].seqId);
        		
        		$(btn).on('click', $.addFollowEvent);
	        }
	        
	        
	   });
	 var followerlist = {
			  <c:forEach items="${follow.dtoFollowerList}" var="item">
			  "${item.id}": {
				id:"${item.id}",
			    name:"${item.name}",
			    img:"${item.imgPath}",
			    seqId:"${item.seqId}"
			  },
			  </c:forEach>
			}
	 
	 $('#follower').on('click',function(){
	        $('#followModal').css('display', 'flex');
	        
	        $('#follow_title').text("팔로워"); 
	        $('#follow_table').html("");
	        for(obj in followerlist){
	        	var tmp2 = myFollowSeqId.includes(followerlist[obj].seqId)
	        	if(sessionId == followerlist[obj].id){
        			tmp2 = true;
        		}
	        	
	        	var isLoginId = followerlist[obj].id == "${user}";
	        	var item = createFollowModalItem(followerlist[obj], tmp2, isLoginId);
        		$('#follow_table').append(item);
        		
        		var btn = $(item).find('.follow-modal__btn');
        		console.log(btn);
	        	$(btn).data('seqId', followerlist[obj].seqId);
        		
        		$(btn).on('click', $.addFollowEvent);
	        }
	   });
	 
	 $('#followClose').on('click', function(){
		 $('#followModal').hide();
	 });
	
	 $.addFollowEvent = function() {
		 console.log('클릭됨');
		 var btn = this;
		 var seqId = $(this).data('seqId');
		 var isFollowed = $(this).hasClass('follow-modal__btn--followed');
		 
		 if (isFollowed) {
			 $.ajax({
				url: "<c:url value = '/follow'/> ",
				method: 'DELETE',
				contentType : "application/json",
				data: JSON.stringify({followId : seqId}),
				complete : function() {
					$(btn).removeClass('follow-modal__btn--followed');
					$(btn).text('팔로우');
				}
			});
		 } else {
			 $.ajax({
				url: "<c:url value = '/follow'/> ",
				method: 'POST',
				contentType : "application/json",
				data: JSON.stringify({followId : seqId}),
				complete : function() {
					$(btn).addClass('follow-modal__btn--followed');
					$(btn).text('팔로잉');
				}
			});
		 }
	 };
	
	 
	 function createFollowModalItem(obj, isFollowed, isLoginId) {
		 var item = document.createElement('li');
		 item.classList.add('follow-modal__item');
		 
		 var figure = document.createElement('figure');
		 figure.classList.add('follow-modal__figure');
		 item.appendChild(figure);
		 
		 var img = document.createElement('img');
		 img.classList.add('follow-modal__image');
		 img.src = '/spring/image/profile/' + obj.img + "/";
		 figure.appendChild(img);
		 
		 var user = document.createElement('div');
		 user.classList.add('follow-modal__user');
		 item.appendChild(user);
		 
		 var id = document.createElement('p');
		 id.classList.add('follow-modal__id');
		 id.innerText = obj.id;
		 user.appendChild(id);
		 
		 var name = document.createElement('span');
		 name.classList.add('follow-modal__name');
		 name.innerText = obj.name;
		 user.appendChild(name);
		 
		 if (!isLoginId) {
			 var btn = document.createElement('button');
			 btn.classList.add('follow-modal__btn');
			 if (isFollowed) {
				 btn.classList.add('follow-modal__btn--followed')
				 btn.innerText = '팔로잉';
			 } else {
				 btn.innerText = '팔로우';
			 }
			 user.appendChild(btn);	 
		 }
		 
		 return item;
	 }
	 

</script>
<div class="more-modal" id="moreModalClose">
    <div class="more-modal__container">
        <ul class="more-modal__list">
            <li class="more-modal__option more-modal__option--move">게시물로 이동</li>
            <li class="more-modal__option more-modal__option--delete">게시물 삭제</li>
            <li class="more-modal__option" id="moreModalClose">취소</li>
        </ul>
    </div>
</div>
<script>
$('.article__more').on('click', function() {
	$('#moreModalClose').css('display', 'flex');
});
$('.more-modal__option--delete').on('click', function() {
	var id = $('#articleModal').data('id');
	var writerId = $('#articleModalWriterId').text();
	$.ajax({
		url: "<c:url value = '/article/'/>",
		method: 'DELETE',
		contentType : "application/json",
		data: JSON.stringify({id : id, writerId : writerId}),
		complete : function() {
			alert('게시물이 삭제되었습니다.');
			location.href = "/spring/myprofile/" + writerId;
		}
	});
})
$('.more-modal__option--move').on('click', function() {
	var id = $('#articleModal').data('id');
	location.href = '/spring/post/' + id;
});
$('#moreModalClose').on('click', function() {
    $('#moreModalClose').hide();
});
</script>
</body>
</html>