<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	
	<link rel="shortcut icon" href="../../images/favicon.ico" type="image/x-icon" />
	<link href='http://fonts.googleapis.com/css?family=Roboto&subset=latin,greek,greek-ext,latin-ext,cyrillic' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="../../css/layout.css">
	<script src="/js/jquery-3.6.0.min.js"></script>
	<title>K-PaaS 활용 교육실습포털</title>
</head>
<script>
$(document).ready(function(){
	
	$('#listBtn').click(function(){
		location.href = 'board';
	});
	
	$('#writeBtn').click(function(){
		// ajax 타는 부분
		var result = confirm('수정하시겠습니까?');			
		if(result) {
			location.href = 'boardUpdate?boardSeq=' + $('input[name="boardSeq"]').val();
		}
	});
	$('#commentSubmit').click(function(){
		// ajax 타는 부분
		if(!$('#comment-input').val()) {
			alert('내용을 입력해 주세요.');
			return;
		}
		var result = confirm('댓글을 등록하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			paramMap["comment"] = $('#comment-input').val();
			paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
			paramMap["writeUserId"] = '${sessionScope.user_id}';
			paramMap["writeUserName"] = '${sessionScope.user_name}';
			
			$.ajax({
			    url:'./comments',
		        type:'post',
		        data:paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
				    	$('#comment-input').val('');
				    	$.fn.drawComment();
			    	}
			    }
			}); 
		}
	});
	
	$('#deleteBtn').click(function(){
		var result = confirm('삭제하시겠습니까?');			
		if(result) {
			$('#writeForm').children('input[name="writeUserId"]').val('${sessionScope.user_id}');
			$('#writeForm').children('input[name="writeUserName"]').val('${sessionScope.user_name}');
			$.ajax({
			    url:'./boardDeleteJSON',
		        type:'post',
		        data:$('#writeForm').serializeArray(),
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
			    		location.href = 'board';
			    	}
			    }
			});
		}
	});
	
	$.fn.drawComment();
});
$.fn.drawComment = function() {
	var paramMap = new Map();
	paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
	$.ajax({
	    url:'./comments',
        type:'get',
        data:paramMap,
        dataType:'json',
	    success:function(data){
	    	if(data.result == 'SUCCESS') {
				var resultData = data.resultData;
				var commentList = resultData.commentList;
				var commentHmtl = "";
				
	    		$('#commentCount').html(resultData.commentCount);
	    		if(commentList != null && commentList.length > 0 ) {
		    		for(var i = 0 ; i < commentList.length ; i++ ) {
						commentHmtl += "<li><dl><dt id=\"dt" + commentList[i].commentSeq + "\">";
						commentHmtl += "<p>" + commentList[i].comment + "</p>";
						commentHmtl += "<div><textarea id=\"update" + commentList[i].commentSeq + "\" placeholder=\"수정\" title=\"수정\">" + commentList[i].comment + "</textarea><a href=\"javascript:;clickCommentCancel(" + commentList[i].commentSeq + ")\">취소</a></div>";
						commentHmtl += "</dt><dd>" + commentList[i].createDt + "</dd></dl>";
						if(commentList[i].writeUserId == '${sessionScope.user_id}') {
							commentHmtl += "<div class=\"commentBtn\"><button onClick=\"javascript:clickCommentUpdate(" + commentList[i].commentSeq + ")\">수정</button>"; 
							commentHmtl += "<button onClick=\"javascript:clickCommentDelete(" + commentList[i].commentSeq + ")\">삭제</button></div>"; 
						}
						commentHmtl += "</li>";
		    		}
	    		}
				$('#commentList').html(commentHmtl);
	    	} else {
	    		alert("댓글 조회 중 에러가 발생했습니다.");
	    	}
	    }
	}); 
}
function clickCommentUpdate(commentSeq) {
	if($('#dt' + commentSeq).hasClass('on')) {
		updateComment(commentSeq, $('#update' + commentSeq).val());
	} else {
		$('#dt' + commentSeq).addClass('on');
	}
}

function clickCommentCancel(commentSeq) {
	$('#dt' + commentSeq).removeClass('on');
}

function clickCommentDelete(commentSeq) {
	var result = confirm('댓글을 삭제하시겠습니까?');			
	if(result) {
		var paramMap = new Map();
		paramMap["commentSeq"] = commentSeq;
		paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
		paramMap["writeUserId"] = '${sessionScope.user_id}';
		paramMap["writeUserName"] = '${sessionScope.user_name}';
		
		$.ajax({
		    url:'./deleteComment',
	        type:'post',
	        data:paramMap,
	        dataType:'json',
		    success:function(data){
		    	if(data.result == 'SUCCESS') {
			    	$.fn.drawComment();;
		    	}
		    }
		}); 
	}
}
function updateComment(commentSeq, comment){
	// ajax 타는 부분
	var result = confirm('댓글을 수정하시겠습니까?');			
	if(result) {
		var paramMap = new Map();
		/* paramMap["commentSeq"] = $('#comment-input').val(); */
		paramMap["commentSeq"] = commentSeq;
		paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
		paramMap["comment"] = comment;
		paramMap["writeUserId"] = '${sessionScope.user_id}';
		paramMap["writeUserName"] = '${sessionScope.user_name}';
		
		$.ajax({
		    url:'./updateComment',
	        type:'post',
	        data:paramMap,
		    success:function(data){
		    	if(data.result == 'SUCCESS') {
			    	$.fn.drawComment();
		    	}
		    }
		}); 
	}
}
</script>
<body>
	<div id="wrap">
		<!-- Header -->
		<form id="writeForm">
			<input type="hidden" name="writeUserName" value="${resultData.userName}" /><!-- 추후 로그인 처리 후 로그인 사용자명 -->
			<input type="hidden" name="writeUserId" value="${resultData.userId}" /><!-- 추후 로그인 처리 후 로그인 사용자ID -->
			<input type="hidden" name="boardSeq" value="${resultData.boardSeq}" />
			<input type="hidden" id="writeType" value="${type}" />
			<input type="hidden" name="boardTitle" />
			<input type="hidden" name="boardText" />
		</form>
		<header>
			<div>
				<h1>
					<a href="<c:url value='/board' />"><img src="../../images/logo_header.png" alt="K-PaaS로고"></a>
				</h1>
				<div>
					<c:if test="${sessionScope.sessionScope_id eq null}">
						<a href="<c:url value='/user/join' />">회원가입</a>
						<a href="<c:url value='/user/login' />">로그인</a>
					</c:if>
					<c:if test="${sessionScope.sessionScope_id ne null}">
						<a href="<c:url value='/user/userInfo' />?userId=${sessionScope.user_id}">My Page</a>
						<a href="<c:url value='/user/logout' />">로그아웃</a>
					</c:if>
				</div>
			</div>
		</header>
		<!-- // Header -->
		<!-- Container -->
		<div id="content" class="noticeView">
			<div class="detail">
                <div class="con">
                    <dl>
                        <dt>${resultData.boardTitle}</dt>
                        <dd>
                            <dl>
                                <dt>등록자</dt>
                                <dd>${resultData.writeUserName}</dd>
                            </dl>
                            <dl>
                                <dt>등록일</dt>
                                <dd>${resultData.createDt}</dd>
                            </dl>
                        </dd>
                    </dl>
                    <div class="editor">
                        ${resultData.boardText}
                    </div>
                    <div class="noticeBtn">
                        <div>
                        	<c:if test="${ sessionScope.user_id eq resultData.writeUserId}">
	                            <button id="writeBtn" class="editBtn">수정</button>
	                            <button id="deleteBtn" class="delBtn">삭제</button>
                            </c:if>
                        </div>
                        <a href="#" id="listBtn" class="listBtn">목록</a>
                    </div>
                    <div class="comment-wrap">
                        <div class="comment">
                            <div>댓글 <span id="commentCount">0</span>개</div>
                            <textarea id="comment-input" placeholder="댓글을 입력하세요." title="댓글"></textarea>
                            <div class="uploadBtn">
                                <button id="commentSubmit">등록</button>
                            </div>
                        </div>
                        <ul id="commentList">
                        </ul>
                    </div>
                </div>
            </div>
		</div>
		<!-- //Container -->
		<!-- Footer -->
        <footer>
            <div>
                <div class="company">
                    <div>
                    </div>
                </div>
                <div class="company-info">
					<div>
						<h5>개방형 클라우드플랫폼 센터 K-PaaS</h5>
						<address>서울시 중구 세종대로 39 서울상공회의소 7F</address>
						<a href="#">위치안내</a>
					</div>
					<div>
						<h5>개방형 클라우드 플랫폼센터</h5>
						<dl>
							<dt>문의전화</dt>
							<dd>1522-0089</dd>
						</dl>
						<dl>
							<dt>문의메일</dt>
							<dd><a href="mailto:kpaas@k-paas.kr">kpaas@k-paas.ta.kr</a></dd>
						</dl>
					</div>
					<p>COPYRIGHT 2020 K-PaaS. ALL RIGHTS RESERVED.</p>
                </div>
            </div>
        </footer>
        <!-- // Footer -->
	</div>
</body>
</html>