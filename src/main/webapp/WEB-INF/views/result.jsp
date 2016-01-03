<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<head>
<!-- <link href="<c:url value="/resources/css/main.css" />" rel="stylesheet">
<script src="<c:url value="/resources/js/jquery-2.1.4.min.js" />"></script>
<script src="<c:url value="/resources/js/test.js" />"></script>  -->
<%Integer dur = (Integer)request.getSession().getAttribute("quizDuration");%>
<meta http-equiv="refresh" content="<%=dur%>;url=http://localhost:8080/mmtcexam/timeout"/>
<title>Insert title here</title>
</head>
<body>
<!-- <script>
hello();
</script> -->

<p>${result}</p>
<p>You have ${sessionScope.quizDuration} seconds</p>
</body>
</html>