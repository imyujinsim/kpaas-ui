<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
	<head>
		<!-- 합쳐지고 최소화된 최신 CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
		<!-- 부가적인 테마 -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
	 	
	 	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<title>회원가입</title>
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
				console.log($('#loginForm').serializeArray());
				$.ajax({
				    url:'./loginUser',
			        type:'post',
			        data:$('#loginForm').serializeArray(),
			        dataType:'json',
			        async: false,
				    success:function(data){
				    	if(data.result == 'SUCCESS') {
				    		alert("로그인 되었습니다.");
				    		rtn = true;
				    	} else {
				    		alert("로그인에 실패했습니다.");
				    	}
				    }
				});
				return rtn;
			});
			
				
			
		})
	</script>
	<body>
		<section id="container">
			<form id="loginForm" action="/board" method="post">
				<div class="form-group has-feedback">
					<label class="control-label" for="userId">아이디</label>
					<input class="form-control" type="text" id="userId" name="userId" />
				</div>
				<div class="form-group has-feedback">
					<label class="control-label" for="userPass">패스워드</label>
					<input class="form-control" type="password" id="userPasswd" name="userPasswd" />
				</div>
				<div class="form-group has-feedback">
					<button class="btn btn-success" type="submit" id="submit">로그인</button>
					<button class="cencle btn btn-danger" type="button">회원가입</button>
				</div>
			</form>
		</section>
		
	</body>
	
</html>