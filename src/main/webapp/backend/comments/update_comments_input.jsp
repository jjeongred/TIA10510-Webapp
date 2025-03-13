<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.comments.model.*"%>

<%
	CommentsVO commentsVO = (CommentsVO) request.getAttribute("commentsVO");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
<title>活動留言板資料修改 - update_comments_input.jsp</title>

<style>
  table#table-1 {
    width: 450px;
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
	background-color: white;
	margin-top: 1px;
	margin-bottom: 1px;
  }
  table, th, td {
    border: 0px solid #CCCCFF;
  }
  th, td {
    padding: 1px;
  }
</style>

</head>
<body bgcolor='white'>

<table id="table-1">
	<tr><td>
		 <h3>活動留言板修改 - update_comments_input.jsp</h3>
		 <h4><a href="comments_select_page.jsp"><img src="<%=request.getContextPath()%>/resources/images/back1.gif" width="100" height="32" border="0">回首頁</a></h4>
	</td></tr>
</table>

<h3>資料修改:</h3>

<%-- 錯誤表列 --%>
<c:if test="${not empty errorMsgs}">
<font style="color:red">請修正以下錯誤:</font>
	<ul>
		<c:forEach var="message" items="${errorMsgs}">
			<li style="color:red">${message}</li>
		</c:forEach>
	</ul> 
</c:if>

<FORM METHOD="post" ACTION="comments.do" name="form1">
<table>
    <tr>
		<td>留言流水號:<font color=red><b>*</b></font></td>
		<td><%=commentsVO.getCommentId()%></td>
	</tr>
<%-- 	<tr>
		<td>活動參與會員:</td>
		<td><input type="TEXT" name="eventMemberId" value="<%=commentsVO.getEventMemberId()%>" size="45"/></td>
	</tr> --%>
	<tr>
		<td>留言隱藏:</td>
		<td><input type="TEXT" name="commentHide"   value="<%=commentsVO.getCommentHide()%>"   size="45"/></td>
	</tr>
	<tr>
		<td>留言內容:</td>
		<td><input type="TEXT" name="commentMessage"   value="<%=commentsVO.getCommentMessage()%>"   size="45"/></td>
	</tr>

	<jsp:useBean id="eventMemberSvc" scope="page" class="com.eventmember.model.EventMemberService" />
	<tr>
		<td>活動參與會員:</td>
		<td><select size="1" name="eventMemberId">
			<c:forEach var="eventMemberVO" items="${eventMemberSvc.all}">
				<option value="${eventMemberVO.eventMemberId}" ${(param.eventMemberId==eventMemberVO.eventMemberId)? 'selected':'' } >${eventMemberVO.eventMemberId}
			</c:forEach>
		</select></td>
	</tr>
</table>
<br>
<input type="hidden" name="action" value="update">
<input type="hidden" name="commentId" value="<%=commentsVO.getCommentId()%>">
<input type="submit" value="送出修改"></FORM>

</body>
</html>