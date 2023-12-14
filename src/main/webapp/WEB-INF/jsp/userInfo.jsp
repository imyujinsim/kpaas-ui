<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	
    <link rel="shortcut icon" href="../../images/favicon.ico" type="image/x-icon" />
	<link rel="stylesheet" href="../../css/layout.css">
	<script src="/js/jquery-3.6.0.min.js"></script>
	<title>K-PaaS 활용 교육실습포털</title>
</head>
<script>
$(document).ready(function(){
	$('#updateBtn').click(function(){
		// ajax 타는 부분
		if($("#userName").val()==""){
			alert("성명을 입력해주세요.");
			$("#userName").focus();
			return ;
		}
		
		if($("#userPasswd").val() != $("#userPasswd2").val()){
			alert("비밀번호가 일치하지 않습니다."); 
			$("#userPasswd").focus();
			return ;
		}
		
		var result = confirm('수정하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			paramMap["userId"] = '${sessionScope.user_id}';
			paramMap["userName"] = $('#userName').val();
			
			if($('#userPasswd').val())  {
				paramMap["userPasswd"] = $('#userPasswd').val();
			}
			
			$.ajax({
			    url:'./updateUser',
		        type:'post',
		        data: paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
			    		alert("정상적으로 수정되었습니다.");
			    		location.href = "<c:url value='/board' />";
			    	} else {
			    		alert("수정에 실패했습니다.");
			    	}
			    }
			});
		}
	});
	$('#deleteBtn').click(function(){
		// ajax 타는 부분
		var result = confirm('탈퇴하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			paramMap["userId"] = '${sessionScope.user_id}';
			$.ajax({
			    url:'./deleteUser',
		        type:'post',
		        data: paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
			    		alert("정상적으로 탈퇴되었습니다.");
			    		location.href = "<c:url value='/board' />";
			    	} else {
			    		alert("탈퇴에 실패했습니다.");
			    	}
			    }
			});
		}
	});
});
</script>
<body>
	<div id="wrap">
		<!-- Header -->
		<header>
			<div>
				<h1>
					<a href="<c:url value='/board' />"><img src="../../images/logo_header.png" alt="K-PaaS로고"></a>
				</h1>
				<div>
					<c:if test="${sessionScope.session_id eq null}">
						<a href="<c:url value='/user/join' />">회원가입</a>
						<a href="<c:url value='/user/login' />">로그인</a>
					</c:if>
					<c:if test="${sessionScope.session_id ne null}">
						<a class="on" href="<c:url value='/user/userInfo' />?userId=${sessionScope.user_id}">My Page</a>
						<a href="<c:url value='/user/logout' />">로그아웃</a>
					</c:if>
				</div>
			</div>
		</header>
		<!-- // Header -->
		<!-- Content -->
		<div id="content" class="join basic-info">
			<h3>회원정보</h3>
			<div class="write">
				<dl class="id">
					<dt><label for="userId">아이디</label></dt>
					<dd>
						<input disabled="disabled" type="text" autocomplete="off" id="userId" minlength="5" maxlength="12" value="${resultData.userId}"/>
						<!-- <button type="submit">중복확인</button> -->
					</dd>
				</dl>
				<dl class="name">
					<dt><label for="userName">이름</label></dt>
					<dd>
						<input type="text" autocomplete="off" id="userName" minlength="2" maxlength="12" value="${resultData.userName}"/>
					</dd>
				</dl>
				<dl class="pass">
					<dt><label for="userPw">비밀번호</label></dt>
					<dd>
						<input type="password" autocomplete="off" id="userPasswd" minlength="9" maxlength="20" placeholder="비밀번호를 입력해주세요" />
						<!-- <p>숫자 영문 대소문자 특수문자를 세가지 이상 혼용한 9~20자리 사용</p> -->
					</dd>
				</dl>
				<!-- 비밀번호 이벤트 class="wrong/right" -->
				<dl class="repass">
					<dt><label for="userPwCheck">비밀번호 확인</label></dt>
					<dd>
						<input type="password" autocomplete="off" id="userPasswd2" minlength="9" maxlength="20" placeholder="비밀번호를 한번 더 입력해주세요" />
						<!-- <p class="incorrect">비밀번호가 일치하지 않습니다.</p>
						<p class="correct">비밀번호가 일치합니다.</p> -->
					</dd>
				</dl>
			</div>
			<div class="btn03">
				<a id="deleteBtn" href="#">회원탈퇴</a>
				<button id="updateBtn" type="submit">회원정보 수정</button>
			</div>
		</div>
		<!-- //Content -->
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