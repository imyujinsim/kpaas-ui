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
	$('#selectBtn').click(function(){
		$('#page').val("1");
		$.fn.search();
	});
	
	$('#writeBtn').click(function(){
		location.href = 'boardDetail';
	});
	
	$('#btnJoin').click(function(){
		location.href = 'user/join';
	});
	
	$('#btnLogin').click(function(){
		location.href = 'user/login';
	});
	
	$('#btnLogout').click(function(){
		location.href = 'user/logout';
	});

	$('#list').children('tr').click(function(){
		location.href = 'boardDetail?boardSeq=' + $(this).attr("boardSeq");
	});
	$.fn.drawPagination();
});

$.fn.drawPagination = function() {
	var page = $('#page').val();
	var lastPage = Math.ceil($('#count').val() / $('#pagePerCount').val());
	var startPage = 1;
	
	
	if(page > 2) {
		startPage = page - 2;
	}
	
	var html = "<span class=\"firstPage\">&laquo;</span>";
	for(var i = startPage ; i < startPage + 5 && i <= lastPage; i++) {
		html += "<span class=\"numberPage " + (i==page?"selected":"") + "\">" + i + "</span>";
	}
	html += "<span class=\"lastPage\">&raquo;</span>";
	
	$('.pagination').html(html);
	$('.pagination').children('.numberPage').click(function(){
		$('#page').val($(this).text());
		$.fn.search();
	});
	$('.pagination').children('.firstPage').click(function(){
		$('#page').val("1");
		$.fn.search();
	});
	$('.pagination').children('.lastPage').click(function(){
		$('#page').val(lastPage);
		$.fn.search();
	});
	
	if(page > lastPage) {
		$('#page').val("1");
		$.fn.search();
	}
}
$.fn.search = function() {
	$.ajax({
	    url:'./boardJSON',
        type:'get',
        data:$('#search').serialize(),
	    success:function(data){
	    	var result = data.resultData;
	    	$('#countText').text(result.boardCount);
	    	$('#count').val(result.boardCount);
	    	
	    	var tableList = "";
	    	if(result.boardCount > 0) {
	    		var list = result.boardList;
		    	for(var i=0;i<list.length;i++) {
		    		tableList += "<tr boardSeq=\"" + list[i].boardSeq + "\">";
		    		tableList += "<td class=\"center\">" + list[i].boardNo +  "</td>";
		    		tableList += "<td>" + list[i].boardTitle + "</td>";
		    		tableList += "<td class=\"center\">" + list[i].writeUserName + "</td>";
		    		tableList += "<td class=\"center\">" + list[i].createDt + "</td>";
		    		tableList += "</tr>";
		    	}
			} else {
				tableList = "<tr>"
					+ "<td class=\"center\" colspan=\"4\">게시물이 존재하지 않습니다.</td>"
					+ "</tr>";
			}
	    	
	    	$('#list').html(tableList);
	    	
	    	$('#list').children('tr').click(function(){
	    		location.href = 'boardDetail?boardSeq=' + $(this).attr("boardSeq");
	    	});
	    	$.fn.drawPagination();
	    }
	});
}
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
	height: 70%;
	margin: 0% 15%;
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

table tbody tr {
	border-bottom: solid 1px #DDDDDD;
	height: 30px;
}

.searchArea {
	text-align: right;
	padding: 3px;
}

/* 페이징 디자인 시작 */
.pagination {
	width: 100%;
	text-align: center;
	margin: 1% 0;
}

.pagination span {
	color: black;
	padding: 4px 8px;
	cursor: pointer;
	text-decoration: none;
}

.pagination .selected {
	font-weight: bold !important;
}
/* 페이징 디자인 종료 */

/* selectbox 디자인 시작*/
select {

    -webkit-appearance: none;  /* 네이티브 외형 감추기 */
    -moz-appearance: none;
    appearance: none;
    
    width: 70px; /* 원하는 너비설정 */
    padding: .3em .5em; /* 여백으로 높이 설정 */
    font-family: inherit;  /* 폰트 상속 */
    background: url('/images/select_icon.jpg') no-repeat 95% 50%; /* 네이티브 화살표를 커스텀 화살표로 대체 */
    border: 1px solid #999;
    border-radius: 0px; /* iOS 둥근모서리 제거 */
    -webkit-appearance: none; /* 네이티브 외형 감추기 */
    -moz-appearance: none;
    appearance: none;
    
}

/* IE 10, 11의 네이티브 화살표 숨기기 */
select::-ms-expand {
    display: none;
}
/* selectbox 디자인 종료*/

/* input 디자인 시작*/
input[type=text] {
    -webkit-appearance: none;  /* 네이티브 외형 감추기 */
    -moz-appearance: none;
    appearance: none;
    
    width: 150px; /* 원하는 너비설정 */
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
</style>

</head>
<body>
	<div class="header" style="text-align: right; padding: 3px;">
		<c:if test="${session.session_id.value eq null}">
			<span id="btnJoin" style="float:left;" class="button">회원가입</span>
			<span id="btnLogin" style="float:left;" class="button">로그인</span>
		</c:if>
		<c:if test="${session.session_id.value ne null}">
			<span id="btnLogout" style="float:left;" class="button">로그아웃</span>
		</c:if>
 	</div>
	<div class="body">
		<article>
			<form id="search"  action="javascript:return false;">
				<div class="right"><span>총 <span id="countText">${resultData.boardCount}</span>건 조회되었습니다.</span></div>
				<input type="hidden" id="count" value="${resultData.boardCount}">
				<input type="hidden" id="page" name="page" value="${resultData.page}">
				<input type="hidden" id="pagePerCount" name="pagePerCount" value="${resultData.pagePerCount}">
				<table>
					<thead>
						<tr>
							<th style="width:10%;">번호</th>
							<th style="width:60%;">제목</th>
							<th style="width:10%;">작성자</th>
							<th style="width:20%;">작성일</th>
						</tr>
					</thead>
					<tbody id="list">
						<c:choose>
							<c:when test="${resultData.boardCount eq '0'}">
								<tr>
									<td class="center" colspan="4">게시물이 존재하지 않습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="row" items="${resultData.boardList}" varStatus="status">
									<tr boardSeq="${row.boardSeq}">
										<td class="center">${row.boardNo}</td>
										<td>${row.boardTitle}</td>
										<td class="center">${row.writeUserName}</td>
										<td class="center">${row.createDt}</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
				<div class="searchArea">
					<select name="searchType">
						<option value="boardTitle">제목</option>
						<option value="boardText">내용</option>
						<option value="writeUserName">작성자</option>
					</select>
					<input type="text" name="searchValue" onKeypress="javascript:if(event.keyCode==13) {$.fn.search();}"/>
					<span id="selectBtn" class="button">검색</span>
					<c:if test="${session.session_id.value ne null}">
						<span id="writeBtn" class="button">등록</span>
					</c:if>
				</div>
				<div id="pagination" class="pagination" page=""></div>
			</form>
		</article>
	</div>
	<div class="footer"></div>
</body>
</html>
