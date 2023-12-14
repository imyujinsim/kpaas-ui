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
			
			location.href = "/user/join";
					    
		})
	
		$("#submit").on("click", function(){
			var rtn = false;
			if($("#userId").val()==""){
				alert("아이디를 입력해주세요.");
				$("#userId").focus();
				return rtn;
			}
			if($("#userPass").val()==""){
				alert("비밀번호를 입력해주세요."); 
				$("#userPass").focus();
				return rtn;
			}
			$.ajax({
			    url:'./loginUser',
		        type:'post',
		        data:$('#loginForm').serializeArray(),
		        dataType:'json',
		        async: false,
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
			    		alert("로그인 되었습니다.");
			    		location.href="../board";
			    	} else {
			    		alert(data.errMsg);
			    	}
			    }
			});
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
					<a href="<c:url value='/user/join' />">회원가입</a>
					<a href="<c:url value='/user/login' />" class="on">로그인</a>
				</div>
			</div>
		</header>
		<!-- // Header -->
		<!-- Content -->
		<div id="content" class="login">
			<div>
				<div class="loginBox">
					<!-- title -->
					<div class="title">
						<dl>
							<dt>로그인</dt>
							<dd>K-PaaS 서비스 이용을 위해 로그인을 해주세요.</dd>
						</dl>
					</div>
					<!-- user-login -->
					<div class="user-login">
						<form id="loginForm" method="post">
							<fieldset>
								<input type="text" autocomplete="off" id="userId" name="userId"  minlength="5" maxlength="12" placeholder="아이디를 입력해주세요" title="아이디" />
								<button>지우기</button>
							</fieldset>
							<fieldset>
								<input type="password" autocomplete="off" id="userPasswd" name="userPasswd"  minlength="9" maxlength="20" placeholder="패스워드를 입력해주세요" title="패스워드" />
								<button>지우기</button>
							</fieldset>
							<div class="memberBtn">
								<a  href="<c:url value='/user/join' />">회원가입</a>
								<button type="submit" id="submit">로그인</button>
							</div>
						</form>
					</div>
				</div>
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