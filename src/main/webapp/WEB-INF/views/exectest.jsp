<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">

<style type="text/css">

body {
    font: 20px Montserrat, sans-serif;
    line-height: 1.8;
    color: #f5f6f7;
}
p {font-size: 16px;}
.margin {margin-bottom: 45px;}
.bg-1 { 
    background-color: #1abc9c; /* Green */
    color: #ffffff;
}
.bg-2 { 
    background-color: #474e5d; /* Dark Blue */
    color: #ffffff;
}
.bg-3 { 
    background-color: #ffffff; /* White */
    color: #555555;
}
.bg-4 { 
    background-color: #2f2f2f; /* Black Gray */
    color: #fff;
}
.container-fluid {
    padding-top: 70px;
    padding-bottom: 70px;
}
.navbar {
    padding-top: 15px;
    padding-bottom: 15px;
    border: 0;
    border-radius: 0;
    margin-bottom: 0;
    font-size: 12px;
    letter-spacing: 5px;
}
.navbar-nav  li a:hover {
    color: #1abc9c !important;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
	window.localStorage.setItem('tests','<%=(String)request.getAttribute("tests")%>');
});
</script>
<title>MMTC</title>
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
	      <a class="navbar-brand" href="#">MMTC 全方位专业按摩培训</a>
	    </div>
	    <div class="collapse navbar-collapse" id="myNavbar">
	      <ul class="nav navbar-nav navbar-right">
	        <li><a href="${pageContext.request.contextPath}/index">Home</a></li>
	        <li><a href="${pageContext.request.contextPath}/logout">LogOut</a></li>
	      </ul>
	    </div>
	  </div>
	</nav>
<!--<mmtc:jsonparser></mmtc:jsonparser>-->
<div class="container-fluid">
<form:form method="POST" action="${s}?${_csrf.parameterName}=${_csrf.token}" commandName="ts" enctype="multipart/form-data"> 
<div class="row">
<div class="col-sm-12">
<h3></h3>
</div>
</div>
<div class="row">
<div class="col-sm-12">
</div>
</div>
<div class="row">
<div class="col-sm-12">
</div>
</div>
<div class="row">
<div class="col-sm-12">
<input type="submit" value="Submit"/> 
</div>
</div> 
</form:form>
</div>
<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
  <p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer></body>
</html>