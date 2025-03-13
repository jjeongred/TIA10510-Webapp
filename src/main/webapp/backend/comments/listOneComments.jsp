<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.comments.model.*"%>
<%-- 此頁暫練習採用 Script 的寫法取值 --%>

<%
 CommentsVO commentsVO = (CommentsVO) request.getAttribute("commentsVO"); //CommentsServlet.java(Concroller), 存入req的commentsVO物件
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>活動留言板 - listOneComments.jsp</title>

<style>
  table#table-1 {
	background-color: #CCCCFF;
    border: 2px solid black;
    text-align: center;
  }
  table#table-1 h4 {
    color: red;
    display: block;
    margin-bottom: 1px;
  }
  h4 {
    color: blue;
    display: inline;
  }
</style>

<style>
  table {
	width: 600px;
	background-color: white;
	margin-top: 5px;
	margin-bottom: 5px;
  }
  table, th, td {
    border: 1px solid #CCCCFF;
  }
  th, td {
    padding: 5px;
    text-align: center;
  }
</style>

</head>
<body bgcolor='white'>

<h4>此頁暫練習採用 Script 的寫法取值:</h4>
<table id="table-1">
	<tr><td>
		 <h3>活動留言板 - listOneComments.jsp</h3>
		 <h4><a href="comments_select_page.jsp"><img src="<%=request.getContextPath()%>/resources/images/back1.gif" width="100" height="32" border="0">回首頁</a></h4>
	</td></tr>
</table>

<table>
	<tr>
		<th>留言流水號</th>
		<th>活動參與會員</th>
		<th>留言隱藏</th>
		<th>留言內容</th>
		<th>留言時間</th>
	</tr>
	<tr>
		<td><%=commentsVO.getCommentId()%></td>
		<td><%=commentsVO.getEventMemberId()%></td>
		<td><%=commentsVO.getCommentHide()%></td>
		<td><%=commentsVO.getCommentMessage()%></td>
		<td><%=commentsVO.getCommentTime()%></td>
	</tr>
</table>

</body>
</html>