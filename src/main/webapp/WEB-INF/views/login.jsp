<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<title>Login Page</title>
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
	padding: 20px;
	margin: 100px auto;
	background: #fff;
	-webkit-border-radius: 2px;
	-moz-border-radius: 2px;
	border: 1px solid #000;
}

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
</head>
<body onload='document.loginForm.username.focus();'>
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
	        <li><a href="${pageContext.request.contextPath}/newuser">SignUp</a></li>
	      </ul>
	    </div>
	  </div>
	</nav>
	<div class="container-fluid bg-3 text-center">    
	  <h3 class="margin">Login with Username and Password</h3><br>
	  <div class="row">
	    <div class="col-sm-2">
    	</div>
	    <div class="col-sm-8">
			<div id="login-box">
				<c:if test="${not empty error}">
					<div class="error">${error}</div>
				</c:if>
				<c:if test="${not empty msg}">
					<div class="msg">${msg}</div>
				</c:if>
		
				<form name='loginForm' class="form"
					action="<c:url value='/login' />" method='POST'>
		
					<div class="form-group">
						<label for="nameField">User</label>
						<input type='text' id="nameField" class="form-control" name='username' placeholder="Your User Name"/>
					</div>
					<div class="form-group">
						<label for="pwFiled">Password</label>
						<input type='password' id="pwFiled" class="form-control" name='password' placeholder="Your Password"/>
					</div>
						<button type="submit" name="submit" class="btn btn-primary">Submit</button>
						<a href="${pageContext.request.contextPath}/login?newu" class="btn btn-default">Register</a>
					<!--  <input name="submit" type="submit" value="Submit" /> 
					<a href="${pageContext.request.contextPath}/login?newu">Create New Account</a>-->
		
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />

				</form>
			 </div>	      
	    </div>
	    <div class="col-sm-2">
    	</div>
  </div>
</div>	
<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
  <p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer></body>
</html>