<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<style type="text/css">
table.root {
	width: 100%;
}
caption.root {
  text-align: left;
  color: Black;
  font-weight: bold;
  text-transform: uppercase;
  padding: 5px;
  width:100%;
}
th.root,
td.root {
  padding: 10px 10px;
}
tbody.root td:nth-child(1){
	width:70%;
}
</style>
<head>
	<title>Welcome to Mendez Master Training Center!</title>
</head>
<body>
<table class="root"><!-- ROOT TABLE -->
<tr style="width:100%;">
<td style="width:100%;">
		<ul>
			<li><a href="${pageContext.request.contextPath}/testsuite">Exam Simulations</a></li>
			<li><a href="${pageContext.request.contextPath}/addtestsuite">Add Exams</a></li>
			<li><a href="${pageContext.request.contextPath}/edittests">Edit Exams</a></li>
		</ul>
</td>
</tr>
</table><!-- ROOT TABLE -->
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>
</html>
