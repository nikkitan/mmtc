<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page session="false"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=5"><!-- IE fix -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.highlight.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">

<style>
.error {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	color: #a94442;
	background-color: #f2dede;
	border-color: #ebccd1;
}

.msg {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	color: #31708f;
	background-color: #d9edf7;
	border-color: #bce8f1;
}

#login-box {
	width: 300px;
	padding: 20px;
	margin: 100px auto;
	background: #fff;
	-webkit-border-radius: 2px;
	-moz-border-radius: 2px;
	border: 1px solid #000;
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
      <a class="navbar-brand" href="${pageContext.request.contextPath}/home">MMTC 全方位专业按摩培训</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="${pageContext.request.contextPath}/index">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/logout">LogOut</a></li>
      </ul>
    </div>
  </div>
</nav>
<div class="container-fluid bg-3" id="testrootpanel">
<div class="row">
<div class="col-xs-12 col-md-5 col-lg-5">
<form:form method="POST" action="adduser">  
<div class="form-group">
        <label for="fn">First Name:</label>
    	<input type="text" name="firstname" class="form-control" placeholder="Your First Name" id="fn"/> 
        <label for="ln">Last Name:</label>
    	<input type="text" name="lastname" class="form-control" placeholder="Your Last Name" id="ln"/> 
        <font color="red">*</font><label for="pw">Password:</label>
    	<input type="password" name="pwd" class="form-control" placeholder="Create Your Password" id="pw"/> 
        <font color="red">*</font><label for="em">Email:</label>
    	<input type="email" name="email" class="form-control" placeholder="Your Email" id="em"/> 
    <% if (request.isUserInRole("ROLE_ADMIN")) {%> 
        <font color="red">***</font><label for="epw">Email Password:</label>
    	<input type="password" name="emailpwd" class="form-control" placeholder="Password to student's email" id="epw"/> 
    <% } %> 
        <button type="submit" class="btn btn-primary">Register</button>  
</div> 
<input type="hidden" name="${_csrf.parameterName}"
	value="${_csrf.token}" />  
</form:form>
</div>
</div>
</div>
<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
<p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer></body>


</html>