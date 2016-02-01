<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Select test suite</title>
</head>
<body>
<table><!-- ROOT -->
<tr>
<td style="width=70%;">
<td>
<h3>Select test suite:</h3>
	<c:if test="${not empty suites}">

		<ul>
			<c:forEach var="i" items="${suites}">
				<li><a href="${pageContext.request.contextPath}/runsuite/${i}">${i}</a></li>
			</c:forEach>
		</ul>

	</c:if>
	</td>
</td>
<td>
<nav>
<a href="${pageContext.request.contextPath}/home">Home</a> |
<a href="${pageContext.request.contextPath}/login?logout">LogOut</a>
</nav>
</td>
</tr>

</table><!-- ROOT -->
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>

</body>
</html>