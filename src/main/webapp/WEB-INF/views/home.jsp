<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Welcome to MMTC!</title>
</head>
<body>
    <table>
		<ul>
			<li><a href="${pageContext.request.contextPath}/testsuite">Exam Simulations</a></li>
			<li><a href="${pageContext.request.contextPath}/addtestsuite">Add Exams</a></li>
			<li><a href="${pageContext.request.contextPath}/edittests">Edit Exams</a></li>
		</ul>
    </table>

<P>  The time on the server is ${serverTime}. </P>
</body>
</html>
