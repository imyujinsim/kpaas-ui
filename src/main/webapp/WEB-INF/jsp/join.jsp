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
<script type="text/javascript">
	$(document).ready(function(){
		// 취소
		$(".cencle").on("click", function(){
			
			location.href = "/login";
					    
		})
	
		$("#submit").on("click", function(){
			var rtn = false;
			if($("#userId").val()==""){
				alert("아이디를 입력해주세요.");
				$("#userId").focus();
				return rtn;
			}
			if($("#userName").val()==""){
				alert("성명을 입력해주세요.");
				$("#userName").focus();
				return rtn;
			}
			if($("#userPasswd").val()==""){
				alert("비밀번호를 입력해주세요."); 
				$("#userPasswd").focus();
				return rtn;
			}
			if($("#userPasswd2").val()==""){
				alert("비밀번호를 입력해주세요."); 
				$("#userPasswd2").focus();
				return rtn;
			}
			
			if($("#userPasswd").val() != $("#userPasswd2").val()){
				alert("비밀번호가 일치하지 않습니다."); 
				$("#userPasswd").focus();
				return rtn;
			}
			
			
			var conf = confirm("회원가입 하시겠습니까?");	
			var param = new Map();
			param["userId"] = $("#userId").val();
			param["userName"] = $("#userName").val();
			param["userPasswd"] = $("#userPasswd").val();
			
			if(conf) {
				$.ajax({
				    url:'./createUser',
			        type:'get',
			        data:param,
			        dataType:'json',
			        async: false,
				    success:function(data){
				    	if(data.result == 'SUCCESS') {
				    		alert("회원 가입이 완료되었습니다.")
				    		rtn = true;
				    		location.href="login";
				    	} else {
				    		alert("회원 가입에 실패하였습니다.");
				    	}
				    }
				});
			} 
			return rtn;
		});
	})
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
					<a href="<c:url value='/user/join' />" class="on">회원가입</a>
					<a href="<c:url value='/user/login' />">로그인</a>
				</div>
			</div>
		</header>
		<!-- // Header -->
		<!-- Content -->
		<div id="content" class="join basic-info">
			<h3>회원가입</h3>
			<div class="write">
					<dl class="id">
						<dt><label for="userId">아이디</label></dt>
						<dd>
							<input type="text" autocomplete="off" id="userId" name="userId" minlength="5" maxlength="12" placeholder="아이디를 입력해주세요" />
							<!-- <button type="submit">중복확인</button> -->
						</dd>
					</dl>
					<dl class="name">
						<dt><label for="userName">이름</label></dt>
						<dd>
							<input type="text" autocomplete="off" id="userName" name="userName" minlength="2" maxlength="12" placeholder="이름을 입력해주세요" />
						</dd>
					</dl>
					<dl class="pass">
						<dt><label for="userPw">비밀번호</label></dt>
						<dd>
							<input type="password" autocomplete="off" id="userPasswd" name="userPasswd" minlength="9" maxlength="20" placeholder="비밀번호를 입력해주세요" />
							<!-- <p>숫자 영문 대소문자 특수문자를 세가지 이상 혼용한 9~20자리 사용</p> -->
						</dd>
					</dl>
					<!-- 비밀번호 이벤트 class="wrong/right" -->
					<dl class="repass">
						<dt><label for="userPwCheck">비밀번호 확인</label></dt>
						<dd>
							<input type="password" autocomplete="off" id="userPasswd2" name="userPasswd2" minlength="9" maxlength="20" placeholder="비밀번호를 한번 더 입력해주세요" />
						</dd>
					</dl>
			</div>
			<div class="btn03">
				<a href="#">취소</a>
				<button type="submit" id="submit">회원가입</button>
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