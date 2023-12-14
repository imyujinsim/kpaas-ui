<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Micro Service Architecture Board</title>
<script src="/js/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function(){
	
	$('#listBtn').click(function(){
		location.href = 'board';
	});
	
	$('#writeBtn').click(function(){
		if($('#writeType').val() == "R") {
			$('.write').show();
			$('.read').hide();
			$('#writeType').val('M');
			$('#writeBtn').text('저장');
			$('#deleteBtn').hide();
			$('#cancelBtn').show();
		} else if($('#writeType').val() == "M") {
			
			// ajax 타는 부분
			var result = confirm('수정하시겠습니까?');			
			if(result) {
				$('#writeForm').children('input[name="boardTitle"]').val($('#boardTitle').val());
				$('#writeForm').children('input[name="boardText"]').val($('#boardText').val());
				$('#writeForm').children('input[name="writeUserId"]').val('${`.user_id}');
				$('#writeForm').children('input[name="writeUserName"]').val('${sessionScope.user_name}');
				
				$.ajax({
				    url:'./boardUpdateJSON',
			        type:'post',
			        data:$('#writeForm').serializeArray(),
			        dataType:'json',
				    success:function(data){
				    	if(data.result == 'SUCCESS') {
				    		$('#titleSpan').text(data.resultData.boardTitle);
				    		$('#textDiv').html(data.resultData.boardText);
				    		$('#writeUserId').text(data.resultData.writeUserId);
				    		$('#writeUserName').text(data.resultData.writeUserId);
				    		
							$('.write').hide();
							$('.read').show();
							$('#writeType').val('R');
							$('#writeBtn').text('수정');
							$('#cancelBtn').hide();
							$('#deleteBtn').show();
				    	}
				    }
				});
			}
		} else {
			
			// ajax 타는 부분
			var result = confirm('등록하시겠습니까?');			
			if(result) {
				$('#writeForm').children('input[name="boardTitle"]').val($('#boardTitle').val());
				$('#writeForm').children('input[name="boardText"]').val($('#boardText').val());
				$('#writeForm').children('input[name="writeUserId"]').val('${sessionScope.user_id}');
				$('#writeForm').children('input[name="writeUserName"]').val('${sessionScope.user_name}');
				
				$.ajax({
				    url:'./boardCreateJSON',
			        type:'post',
			        data:$('#writeForm').serializeArray(),
			        dataType:'json',
				    success:function(data){
				    	if(data.result == 'SUCCESS') {
					    	alert(data.result);
					    	console.log(data.resultData);
				    		$('#titleSpan').text(data.resultData.boardTitle);
				    		$('#textDiv').html(data.resultData.boardText);
				    		$('#createDt').text(data.resultData.createDt);
				    		$('#writeUserId').text(data.resultData.writeUserId);
				    		$('#writeUserName').text(data.resultData.writeUserId);
				    		
							$('.write').hide();
							$('.read').show();
							$('#writeType').val('R');
							$('#writeBtn').text('수정');
							$('#cancelBtn').hide();
							$('#deleteBtn').show();
				    	}
				    }
				});
			}
		}
	});
	$('#commentSubmit').click(function(){
		// ajax 타는 부분
		var result = confirm('댓글을 등록하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			paramMap["comment"] = $('#comment-input').val();
			paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
			paramMap["writeUserId"] = '${sessionScope.user_id}';
			paramMap["writeUserName"] = '${sessionScope.user_name}';
			
			console.log(paramMap);
			$.ajax({
			    url:'./comments',
		        type:'post',
		        data:paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
				    	alert(data.result);
				    	console.log(data.resultData);
			    		$('#titleSpan').text(data.resultData.boardTitle);
			    	}
			    }
			}); 
		}
	});
	
	$('#commentUpdate').click(function(){
		// ajax 타는 부분
		var result = confirm('댓글을 수정하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			/* paramMap["commentSeq"] = $('#comment-input').val(); */
			paramMap["commentSeq"] = 20;
			paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
			paramMap["comment"] = "TESTTESTSETSETEST";
			paramMap["writeUserId"] = '${sessionScope.user_id}';
			paramMap["writeUserName"] = '${sessionScope.user_name}';
			
			console.log(paramMap);
			$.ajax({
			    url:'./updateComment',
		        type:'post',
		        data:paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
				    	alert(data.result);
				    	console.log(data.resultData);
			    		$('#titleSpan').text(data.resultData.boardTitle);
			    	}
			    }
			}); 
		}
	});
	$('#commentDelete').click(function(){
		// ajax 타는 부분
		var result = confirm('댓글을 삭제하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			/* paramMap["commentSeq"] = $('#comment-input').val(); */
			paramMap["commentSeq"] = 21;
			paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
			paramMap["writeUserId"] = '${sessionScope.user_id}';
			paramMap["writeUserName"] = '${sessionScope.user_name}';
			
			console.log(paramMap);
			$.ajax({
			    url:'./deleteComment',
		        type:'post',
		        data:paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
				    	alert(data.result);
				    	console.log(data.resultData);
			    		$('#titleSpan').text(data.resultData.boardTitle);
			    	}
			    }
			}); 
		}
	});
	
	$('#cancelBtn').click(function(){
        $("form").each(function() {  
            this.reset();  
         });  
		$('.write').hide();
		$('.read').show();
		$('#writeType').val('R');
		$('#writeBtn').text('수정');
		$('#cancelBtn').hide();
		$('#deleteBtn').show();
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
	
	if($('#writeType').val() == "R") {
		$('.read').show();
		$('#writeBtn').text('수정');
	} else {
		$('.write').show();
	}

});

$.fn.showRW = function() {
	if($('#writeType').val() == "R") {
		$('.read').show();
		$('.write').hide();
	} else {
		$('.write').show();
		$('.read').hide();
	}
}
</script>
<script>
$(document).ready(function(){
	
	$('#listBtn').click(function(){
		location.href = 'board';
	});
	
	$('#writeBtn').click(function(){
		// ajax 타는 부분
		var result = confirm('수정하시겠습니까?');			
		if(result) {
			location.href = 'boardUpdate';
		}
	});
	$('#commentSubmit').click(function(){
		// ajax 타는 부분
		var result = confirm('댓글을 등록하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			paramMap["comment"] = $('#comment-input').val();
			paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
			paramMap["writeUserId"] = '${sessionScope.user_id}';
			paramMap["writeUserName"] = '${sessionScope.user_name}';
			
			console.log(paramMap);
			$.ajax({
			    url:'./comments',
		        type:'post',
		        data:paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
				    	alert(data.result);
				    	console.log(data.resultData);
			    		$('#titleSpan').text(data.resultData.boardTitle);
			    	}
			    }
			}); 
		}
	});
	
	$('#commentUpdate').click(function(){
		// ajax 타는 부분
		var result = confirm('댓글을 수정하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			/* paramMap["commentSeq"] = $('#comment-input').val(); */
			paramMap["commentSeq"] = 20;
			paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
			paramMap["comment"] = "TESTTESTSETSETEST";
			paramMap["writeUserId"] = '${sessionScope.user_id}';
			paramMap["writeUserName"] = '${sessionScope.user_name}';
			
			console.log(paramMap);
			$.ajax({
			    url:'./updateComment',
		        type:'post',
		        data:paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
				    	alert(data.result);
				    	console.log(data.resultData);
			    		$('#titleSpan').text(data.resultData.boardTitle);
			    	}
			    }
			}); 
		}
	});
	$('#commentDelete').click(function(){
		// ajax 타는 부분
		var result = confirm('댓글을 삭제하시겠습니까?');			
		if(result) {
			var paramMap = new Map();
			/* paramMap["commentSeq"] = $('#comment-input').val(); */
			paramMap["commentSeq"] = 21;
			paramMap["boardSeq"] = $('input[name="boardSeq"]').val();
			paramMap["writeUserId"] = '${sessionScope.user_id}';
			paramMap["writeUserName"] = '${sessionScope.user_name}';
			
			console.log(paramMap);
			$.ajax({
			    url:'./deleteComment',
		        type:'post',
		        data:paramMap,
		        dataType:'json',
			    success:function(data){
			    	if(data.result == 'SUCCESS') {
				    	alert(data.result);
				    	console.log(data.resultData);
			    		$('#titleSpan').text(data.resultData.boardTitle);
			    	}
			    }
			}); 
		}
	});
	
	$('#cancelBtn').click(function(){
        $("form").each(function() {  
            this.reset();  
         });  
		$('.write').hide();
		$('.read').show();
		$('#writeType').val('R');
		$('#writeBtn').text('수정');
		$('#cancelBtn').hide();
		$('#deleteBtn').show();
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
	
});
</script>
<style type="text/css">
html, body {
	margin: 0;
	padding: 0;
	height: 100%;
}

div.header {
	margin: 0;
	padding: 0;
	height: 15%;
}

div.body {
	margin: 0;
	padding: 0;
	margin: 0% 15%;
	min-height: 70%;
	/* 	background-color: #EEEEEE; */
}

div.footer {
	margin: 0;
	padding: 0;
	height: 15%;
}

table {
	margin: 0;
	padding: 0;
	border: 0px;
    border-collapse: collapse;
	width: 100%;
	border-top: solid 2px;
	border-bottom: solid 2px;
}

table thead {
	height: 30px;
	border-top: solid 1px;
	border-bottom: solid 1px #404040;
}

table thead tr {
	height: 40px;
	vertical-align: middle;
}

table thead th{
	padding: 0px;
}

table thead th .read {
	padding: 0px 15px;
	height: 35px;
}

table tbody tr {
	border-bottom: solid 1px #DDDDDD;
	vertical-align: text-top;
    height: 550px;
}

textarea {
    width: 100%; /* 원하는 너비설정 */
    height: 572px;
    margin: 5px 0px;
    padding: .3em .5em; /* 여백으로 높이 설정 */
    font-family: inherit;  /* 폰트 상속 */
    border: 1px solid #999;
	box-sizing : border-box;
 }

/* input 디자인 시작*/
input[type=text] {
    -webkit-appearance: none;  /* 네이티브 외형 감추기 */
    -moz-appearance: none;
    appearance: none;
    
    box-sizing : border-box;
    width: 100%; /* 원하는 너비설정 */
    padding: .3em .5em; /* 여백으로 높이 설정 */
    font-family: inherit;  /* 폰트 상속 */
    border: 1px solid #999;
    border-radius: 0px; /* iOS 둥근모서리 제거 */
    -webkit-appearance: none; /* 네이티브 외형 감추기 */
    -moz-appearance: none;
    appearance: none;
}
/* input 디자인 시작*/

.button {
    -webkit-appearance: none;  /* 네이티브 외형 감추기 */
    -moz-appearance: none;
    appearance: none;
    font-family: inherit;  /* 폰트 상속 */
    font-size: 0.85em;
    border: 1px solid #999;
    padding: .3em .5em; /* 여백으로 높이 설정 */
    border-radius: 0px; /* iOS 둥근모서리 제거 */
    -webkit-appearance: none; /* 네이티브 외형 감추기 */
    -moz-appearance: none;
    appearance: none;
	background-color: #EEEEEE;
	cursor: pointer;
}

.left {
	text-align: left;
}
.right {
	text-align: right;
}
.center {
	text-align: center;
}
.read {
 	display: none;
}
.write {
 	display: none;
}
</style>

</head>
<body>
	<div class="header"></div>
	<div class="body">
		<article>
			<form id="writeForm">
				<input type="hidden" name="writeUserName" value="${resultData.userName}" /><!-- 추후 로그인 처리 후 로그인 사용자명 -->
				<input type="hidden" name="writeUserId" value="${resultData.userId}" /><!-- 추후 로그인 처리 후 로그인 사용자ID -->
				<input type="hidden" name="boardSeq" value="${resultData.boardSeq}" />
				<input type="hidden" id="writeType" value="${type}" />
				<input type="hidden" name="boardTitle" />
				<input type="hidden" name="boardText" />
			</form>
				<table>
					<thead>
						<tr>
							<th class="left" colspan="2"><span id="titleSpan" class="read">${resultData.boardTitle}</span><span class="write"><input type="text" id="boardTitle" placeholder="제목을 입력하세요" value="${resultData.boardTitle}"/></span></th>
						</tr>
						<tr class="read">
							<th class="left">
								<span class="read" style="font-weight:normal">${resultData.userName}</span><!-- 추후 로그인 이름 처리 -->
							</th>
							<th class="right"><span id="createDt" class="read" style="font-weight:normal">${resultData.createDt}</span></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2">
								<div  id="textDiv"class="read" style="padding: 15px 15px;">${resultData.boardText}</div>
								<span class="write"><textarea id="boardText" placeholder="내용을 입력하세요">${resultData.boardText}</textarea></span>
							</td>
						</tr>
					</tbody>
				</table>
				<div style="padding-top: 10px;float:left"><span id="listBtn" class="button">목록</span></div>
				<c:if test="${sessionScope.userId eq resultData.userId}">
					<div class="right" style="padding-top: 10px;"><span id="writeBtn" class="button">등록</span> <span id="deleteBtn" class="button read" value="${resultData.boardSeq}">삭제</span><span id="cancelBtn" class="button" style="display:none;">취소</span></div>
				</c:if>
		</article>
		<div id="commentArea" style="padding-top:30px;">
			 <hr width = "100%" color = "black" size = "2">
			<div id="commentHead">
				<div id="comment-count">댓글 <span id="count">0</span></div>
				<input id="comment-input" placeholder="댓글을 입력해 주세요." width="90%"> <button id="commentSubmit">등록</button>
			</div>
			<div id="cmmentLow1">
				<div id="commentLow" style="text-align:left;">
					<span style="display:inline-block;height:5%; width:90%;">댓글 내용</span>
					<span><button id="commentDelete">삭제</button></span>
					<span><button id="commentUpdate">수정</button></span>
				</div>
			</div>
		</div>
	</div>
	<div class="footer"></div>
</body>
</html>
