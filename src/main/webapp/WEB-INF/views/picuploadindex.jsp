<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.highlight.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">
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
<a href="${pageContext.request.contextPath}/logout">LogOut</a>
</nav>
</td>
</tr>
</table>
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>
</html>