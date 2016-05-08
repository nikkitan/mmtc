<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page session="false"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9"><!-- IE 11 fix -->
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
.select {
  font-size: 16px;
  position: relative;
}
.select select{
	outline:none;
	-webkit-appearance: none;
	display: inline;
	padding: 0.1em 2em 0.1em 1em;
 	margin: 0;
 	
 	line-height: normal;
  	font-family: inherit;
  	font-size: inherit;
  	line-height: inherit;
  	
   	transition: border-color 0.2s;
  	border: 1px solid #92A8D1;
  	border-radius: 5px;
}
.arrow {
  position: relative;
  left:90px;
  top:8px;
  pointer-events: none;
}

.arrow:before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  border-top: 7px solid #92A8D1;
  border-left: 7px solid transparent;
  border-right: 7px solid transparent;
}

.arrow:after {
  content: '';
  position: absolute;
  left: 8px;
  top: 0;
  border-top: -1px solid #eeeeee;
  border-left: -1px solid transparent;
  border-right: -1px solid transparent;
}
</style>
<script type="text/javascript">
function dropdown_selected(elem){
	$('#dropdownbtn').val(elem.text());
}
</script>
</head>
<body>
<!-- Navbar -->
<div class="row">
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
</div>
<div class="container bg-3" id="testrootpanel">
<div class="row text-center">
<div class="col-xs-12 col-md-10 col-lg-10">
<h3>Sign Up for MMTC's Training and Program Info!</h3>  
</div>
</div>
<div class="row">
<div class="col-md-3 col-lg-3"></div>
<div class="col-xs-12 col-md-6 col-lg-6">
<form:form method="POST" action="signup" commandName="newvisitor">
<div class="form-group">
        <label for="fn">First Name:</label>
    	<input type="text" name="firstname" class="form-control" placeholder="Your First Name" id="fn"/> 
        <label for="ln">Last Name:</label>
    	<input type="text" name="lastname" class="form-control" placeholder="Your Last Name" id="ln"/> 
        <label for="em">Email:</label>
    	<input type="email" name="email" class="form-control" placeholder="Your Email" id="em"/>
        <label for="adr">Address:</label>
    	<input type="text" name="address" class="form-control" placeholder="Your Address" id="adr"/>  
   		<label for="msg">How Did You Hear About Us?</label><br>
		<div class="select">
		<span class="arrow"></span>
		<form:select id="adleadsel" path="webLead" onchange="$('#altweblead').prop('disabled',false);if($('#adleadsel :selected').text() == 'Others'){$('#altweblead').focus();}" items="${sources}"></form:select>
		<form:input path="altWebLead" id="altweblead" disabled="true"/>
		</div>
		<br>
        <button type="submit" class="btn btn-primary">Register</button>  
</div> 
<div class="well">
<h4>SAFE SIGN UP GUARANTEE</h4>
<p>We do not and will not sell or release your contact information to other companies, for any reason, at any time.</p>
</div>
<input type="hidden" name="${_csrf.parameterName}"
	value="${_csrf.token}" />  
</form:form>
</div>
<div class="col-md-3 col-lg-3"></div>
</div>
</div>
<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
<p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer></body>


</html>