<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=5"><!-- IE fix -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.highlight.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">
<style type="text/css">
table.color {
	width: 100%;
}
caption.color {
  text-align: left;
  color: Black;
  font-weight: bold;
  text-transform: uppercase;
  padding: 5px;
  width:100%;
}
th.color,
td.color {
  padding: 10px 10px;
}
tbody.color td:nth-child(1){
	width:70%;
}
</style>
<title>List tests</title>
</head>
<body>
<table style="width:100%;"><!-- ROOT TABLE -->
<tr>
<td style="width:70%;">
<table class="color">
<tr class="color">
<td class="color">
	<c:if test="${not empty tests}">

		<ul>
			<c:forEach var="t" items="${tests}">
				<li><a href="${pageContext.request.contextPath}/edittest/${t.id}">${t.question}</a></li>
			</c:forEach>
		</ul>

	</c:if>
</td>
</tr>
</table>
</td>
<td style="vertical-align:top;">
<nav>
<a href="${pageContext.request.contextPath}/home">Home</a> |
<a href="${pageContext.request.contextPath}/logout">LogOut</a>
</nav>
</td>
</tr>
</table><!-- ROOT TABLE  -->
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>
</html>