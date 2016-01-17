<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Settings</title>
</head>
<body>
<table>
	<c:if test="${not empty tests}">

		<ul>
			<c:forEach var="t" items="${tests}">
				<li><a href="${pageContext.request.contextPath}/edittest/${t.id}">${t.question}</a></li>
			</c:forEach>
		</ul>

	</c:if>
    </table>
</body>
</html>