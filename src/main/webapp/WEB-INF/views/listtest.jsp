<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
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
<head>
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
<a href="${pageContext.request.contextPath}/">Home</a> |
<a href="${pageContext.request.contextPath}/login?logout">LogOut</a>
</nav>
</td>
</tr>
</table><!-- ROOT TABLE  -->
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>
</html>