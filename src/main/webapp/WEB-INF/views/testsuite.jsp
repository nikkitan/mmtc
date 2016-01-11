<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
</head>
<body>
<table>
<tr>
<td>
	<c:if test="${not empty suites}">

		<ul>
			<c:forEach var="i" items="${suites}">
				<li><a href="${pageContext.request.contextPath}/exam/${i}">${i}</a></li>
			</c:forEach>
		</ul>

	</c:if>
	</td>
</tr>
</table>
</body>
</html>