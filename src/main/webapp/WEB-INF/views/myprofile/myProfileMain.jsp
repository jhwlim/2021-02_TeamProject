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
.summary {
	margin: 0 auto;
	width: 100%;
	display: flex;
	justify-content: space-around;
	padding: 20px;
}
.summary__image-area {
	display: inline-block;
	width: 160px;
	height: 160px;
	border-radius: 50%;
	overflow: hidden;
}
.summary__image {
	width: 100%;
	height: 100%;
	object-fit: cover;
}
.summary__content {
	padding: 20px;
}
.summary__id {
	font-size: 30px;
}
.summary__row {
	margin-bottom: 20px;
}
.summary__row:last-child {
	margin-bottom: 0;
}
.summary__name {
	font-weight: bold;
}
.file-upload {
	display: none;
}
.profile-area {
	border-radius: 50%;
	width: 500px;
	height: 500px;
	border: 1px solid gray;
	overflow: hidden;
}
</style>
</head>
<body>

<%@ include file="/WEB-INF/include/header.jspf" %>

<div class="wrapper">
    <div class="container">
    	<div class="summary">
   			<figure class="summary__image-area" id="profileImageArea" 
   					${member.signedIn && member.hasImg ? 'data-bs-toggle="modal" data-bs-target="#exampleModal"' : ''}>
   				<img src="<c:url value = '/image/profile/${member.imgPath}/' />" class="summary__image" id="profileImg"/>
	    	</figure>
    		<div class="summary__content">
    			<div class="summary__row">
    				<span class="summary__id">${member.id}</span>
    				&nbsp;&nbsp;
    				<button class="profile-upload">프로필 편집</button>
    				&nbsp;&nbsp;
    				<span>아이콘</span>
    			</div>
    			<div class="summary__row">
    				<span>게시물</span>
    				&nbsp;&nbsp;
    				<span>팔로워</span>
    				&nbsp;&nbsp;
    				<span>팔로우</span>
    			</div>
    			<div class="summary__row">
    				<span class="summary__name">${member.name}</span>
    			</div>
    			<div class="summary__row">
    				<span class="summary__profile">${member.profile}</span>
    			</div>
    		</div>
    	</div>
    </div>    
</div>

<c:if test="${member.signedIn}">
	<form method="POST" action="<c:url value='/image/profile' />" enctype="multipart/form-data" id="uploadForm">
		<input type="file" accept="image/jpeg, image/png" name="file" class="file-upload" />
		<input type="hidden" name="seqId" value="${member.seqId}" />
	</form>
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
				  	<h5 class="modal-title">프로필 사진 바꾸기</h5>
				</div>
				<div class="modal-body">
				  	<ul>
				  		<li class="profile-upload">사진 업로드</li>
				  		<li id="profileImgDelete">현재 사진 삭제</li>
				  	</ul>
				</div>
				<div class="modal-footer" data-bs-dismiss="modal" id="modalClose">취소</div>
			</div>
		</div>
	</div>
	
	<script>
	var profileImageArea = document.getElementById('profileImageArea');
	var hasImg = ${member.hasImg};
	var prevImgPath = null;
	
	function setModal() {
		profileImageArea.setAttribute('data-bs-toggle', 'modal');
		profileImageArea.setAttribute('data-bs-target', '#exampleModal');
	}
	function removeModal() {
		profileImageArea.removeAttribute('data-bs-toggle');
		profileImageArea.removeAttribute('data-bs-target');
	}
	
	if (!hasImg) {
		$("#profileImageArea").on('click', function() {
			$('.file-upload').click();
		});
	}	

	$(".profile-upload").on('click', function(event) {
		$('.file-upload').click();
	});
	
	$(".file-upload").on('change', function() {
		$("#uploadForm").submit();
	});
	
	$('#uploadForm').ajaxForm({
		beforeSend: function() {
			prevImgPath = $('#profileImg').attr('src');
			$("#profileImg").attr("src", "<c:url value = '/image/profile/loading.gif/' />");
			$("#modalClose").click();
		},
		success: function(fileName, status, xhr) {
			switch (status) {
			case "nocontent" :
				$("#profileImg").attr("src", prevImgPath);
				break;
			case "success" :
				$("#profileImg").attr("src", "<c:url value = '/image/profile/' />" + fileName + "/");				
				$("#profileImageArea").off('click');
				$("#modalClose").click();
				setModal();
				break;
			}
		},
		error: function() {
			console.log("Upload Fail");
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
				$("#modalClose").click();
			},
			complete : function() {
				$("#profileImg").attr("src", "<c:url value = '/image/profile/blank.png/' />");
				$("#modalClose").click();
				$("#profileImageArea").on('click', function() {
					$('.file-upload').click();
				});
				removeModal();
			}
		})
	});
	</script>

</c:if>



</body>
</html>