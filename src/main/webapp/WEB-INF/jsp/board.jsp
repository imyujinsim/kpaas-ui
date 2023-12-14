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
	$('#selectBtn').click(function(){
		$('#page').val("1");
		$.fn.search();
	});
	
	$('#writeBtn').click(function(){
		location.href = 'boardInsert';
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
	
	var html = "<a class='first " + (page == 1 ? "nor":"") + "' href='javascript:;'>처음</a>";
	html += "<a class='prev " + (page == 1 ? "nor":"") + "' href='javascript:;'>이전</a>";
	for(var i = startPage ; i < startPage + 5 && i <= lastPage; i++) {
		html += "<a class=\"numberPage " + (i==page?"on":"") + "\">" + i + "</a>";
	} 
	html += "<a class='next " + (page == lastPage ? "nor":"") + "' href='javascript:;'>다음</a>";
	html += "<a class='last " + (page == lastPage ? "nor":"") + "' href='javascript:;'>끝</a>";
	
	$('.pagination').html(html);
	$('.pagination').children('.numberPage').click(function(){
		$('#page').val($(this).text());
		$.fn.search();
	});
	$('.pagination').children('.first').click(function(){
		$('#page').val("1");
		$.fn.search();
	});
	$('.pagination').children('.prev').click(function(){
		if(page != 1) {
			$('#page').val(parseInt(page) - 1);
		} else {
			$('#page').val("1");
		}
		$.fn.search();
	});
	$('.pagination').children('.next').click(function(){
		if(page != lastPage) {
			$('#page').val(parseInt(page) + 1);
		} else {
			$('#page').val(lastPage);
		}
		$.fn.search();
	});
	$('.pagination').children('.last').click(function(){
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
	    	var i = 1;
	    	$('#countText').text(result.boardCount);
	    	$('#count').val(result.boardCount);
	    	
	    	var tableList = "";
	    	if(result.boardCount > 0) {
	    		var list = result.boardList;
		    	for(var i=0;i<list.length;i++) {
		    		tableList += "<tr boardSeq=\"" + list[i].boardSeq + "\">";
		    		tableList += "<td>" + list[i].boardNo +  "</td>";
		    		tableList += "<td>" + list[i].boardTitle + "</td>";
		    		tableList += "<td>" + list[i].writeUserName + "</td>";
		    		tableList += "<td>" + list[i].createDt + "</td>";
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
						<a href="<c:url value='/user/userInfo' />?userId=${sessionScope.user_id}">My Page</a>
						<a href="<c:url value='/user/logout' />">로그아웃</a>
					</c:if>
				</div>
			</div>
		</header>
		<!-- // Header -->
		<!-- Container -->
		<div id="content" class="notice">
			<form id="search"  action="javascript:return false;">
			<div class="searchBar">
					<div>
						총  <span id="countText">${resultData.boardCount}</span>건 조회되었습니다.
						<input type="hidden" id="count" value="${resultData.boardCount}">
					<input type="hidden" id="page" name="page" value="${resultData.page}">
					<input type="hidden" id="pagePerCount" name="pagePerCount" value="${resultData.pagePerCount}">
					</div>
					<div>
						<fieldset>
							<select title="선택" name="searchType">
								<option value="boardTitle" selected="selected">제목</option>
								<option value="boardText">내용</option>
								<option value="writeUserName">작성자</option>
							</select>
							<div>
								<input id="search" name="searchValue" type="text" title="게시판 검색" placeholder="검색어를 입력해주세요." autocomplete="off" onKeypress="javascript:if(event.keyCode==13) {$.fn.search();}">
								<button id="selectBtn" type="button">검색버튼</button>
							</div>
						</fieldset>
					</div>
			</div>
			</form>
			<table>
				<caption class="blind">게시판</caption>
				<colgroup >
					<col style="width:10%;" />
					<col style="width:60%;" />
					<col style="width:15%;" />
					<col style="width:15%;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">NO</th>
						<th scope="col">제목</th>
						<th scope="col">작성자</th>
						<th scope="col">작성일</th>
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
			<!-- 서치값 없을 때 class="on"추가-->
			<div class="searchno">
				<dl>
					<dt><span>'K-PaaS 배포'</span>에 대한 검색결과가 없습니다.</dt>
					<dd>단어의 철자가 정확한지 확인해 보세요.<br />한글을 영어로 혹인 영어를 한글로 입력했는지 확인해 보세요.<br />검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해 보세요.</dd>
				</dl>
			</div>
			<div class="noticeBtn" style="display:inline-block; margin:10px; float:right;">
                <div >
                	<c:if test="${sessionScope.session_id ne null}">
                    	<button id="writeBtn" class="listBtn">등록</button>
                    </c:if>
                </div>
            </div>
			<div id="pagination" class="paging pagination">
			</div>
		</div>
		<!-- //Container -->
		<!-- Footer -->
        <footer>
            <div>
                <div class="company">
                    <ul>
                    </ul>

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
							<dd><a href="mailto:kpaas@k-paas.kr">k-paas@k-paas.ta.kr</a></dd>
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