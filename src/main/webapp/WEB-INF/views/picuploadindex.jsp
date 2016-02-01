<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style1.css">
<title>MMTC</title>
</head>
<body>
<table class="root">
<tr>
<td style="width:70%;">
<table>
<%
if (session.getAttribute("uploadFile") != null
&& !(session.getAttribute("uploadFile")).equals("")) {
%>
<caption>File Uploaded Successfully.</caption>
<tr>
<td>
<img src="<%=session.getAttribute("uploadFile")%>" alt="Upload Image" />

<%
session.removeAttribute("uploadFile");
}
%>
</td>
</tr>
</table>
</td>
<td style="vertical-align:top;">
<nav>
<a href="${pageContext.request.contextPath}/home">Home</a> |
<a href="${pageContext.request.contextPath}/login?logout">LogOut</a>
</nav>
</td>
</tr>
</table>
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>
</html>