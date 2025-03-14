<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LifeSpace Comments: Home</title>

<style>
  table#table-1 {
	width: 450px;
	background-color: #CCCCFF;
	margin-top: 5px;
	margin-bottom: 10px;
    border: 3px ridge Gray;
    height: 80px;
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

</head>
<body bgcolor='white'>

<table id="table-1">
   <tr><td><h3>LifeSpace Comments: Home</h3><h4>( MVC )</h4></td></tr>
</table>

<p>This is the Home page for LifeSpace Comments: Home</p>

<h3>資料查詢:</h3>

<%-- 錯誤表列 --%>
<c:if test="${not empty errorMsgs}">
	<font style="color:red">請修正以下錯誤:</font>
	<ul>
		<c:forEach var="message" items="${errorMsgs}">
			<li style="color:red">${message}</li>
		</c:forEach>
	</ul>
</c:if>

<ul>
  <li><a href='listAllComments.jsp'>List</a> all Comments.  <br><br></li>
  
  
  <li>
    <FORM METHOD="post" ACTION="comments.do" >
        <b>輸入留言流水號 (如C001):</b>
        <input type="text" name="commentId">
        <input type="hidden" name="action" value="getOne_For_Display">
        <input type="submit" value="送出">
    </FORM>
  </li>

  <jsp:useBean id="commentsSvc" scope="page" class="com.comments.model.CommentsService" />
   
  <li>
     <FORM METHOD="post" ACTION="comments.do" >
       <b>選擇留言流水號:</b>
       <select size="1" name="commentId">
         <c:forEach var="commentsVO" items="${commentsSvc.all}" > 
          <option value="${commentsVO.commentId}">${commentsVO.commentId}
         </c:forEach>   
       </select>
       <input type="hidden" name="action" value="getOne_For_Display">
       <input type="submit" value="送出">
    </FORM>
  </li>
  
  <li>
     <FORM METHOD="post" ACTION="comments.do" >
       <b>選擇參與活動的會員:</b>	
       <select size="1" name="commentId">
         <c:forEach var="commentsVO" items="${commentsSvc.all}" > 
          <option value="${commentsVO.commentId}">${commentsVO.eventMemberId}
         </c:forEach>   
       </select>
       <input type="hidden" name="action" value="getOne_For_Display">
       <input type="submit" value="送出">
     </FORM>
  </li>
</ul>

<!-- 
<h3>活動留言板管理</h3>

<ul>
  <li><a href='addComments.jsp'>Add</a> a new Comments.</li>
</ul> -->

</body>
</html>