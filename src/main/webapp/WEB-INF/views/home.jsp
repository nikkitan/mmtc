<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<head>
<meta charset="utf8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
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
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-default">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="#">MMTC 一条龙按摩培训</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="${pageContext.request.contextPath}/index">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/logout">LogOut</a></li>
      </ul>
    </div>
  </div>
</nav>

<table class="root"><!-- ROOT TABLE -->
<tr style="width:100%;">
<td style="width:70%;">
		<ul>
			<li><a href="${pageContext.request.contextPath}/testsuite">Exam Simulations</a></li>
			<li><a href="${pageContext.request.contextPath}/addtestsuite">Add Exams</a></li>
			<li><a href="${pageContext.request.contextPath}/edittests">Edit Exams</a></li>
			<li><a href="${pageContext.request.contextPath}/adduser">Add New Student</a></li>
		</ul>
</td>
<td style="vertical-align:top;">
<nav>
<a href="${pageContext.request.contextPath}/home">Home</a> |
<a href="${pageContext.request.contextPath}/logout">LogOut</a>
</nav>
</td>
</tr>
</table><!-- ROOT TABLE -->
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>
</html>
