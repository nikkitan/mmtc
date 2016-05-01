<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="mmtc" uri="/WEB-INF/custom.tld" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9"><!-- IE 11 fix -->
<meta charset="utf8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">
<style type="text/css">
</style>
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
	      <a class="navbar-brand" href="${pageContext.request.contextPath}/index">MMTC 全方位专业按摩培训</a>
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
<div class="container-fluid bg-3">
<form:form method="POST" action="${s}" commandName="ts" enctype="multipart/form-data"> 
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
<div class="row">
<div class="col-sm-12">
<h3>Test Suite ${su} Options</h3>
</div>
</div>
<div class="row">
<div class="col-sm-12">
<form:checkbox path="isQuestionRandom" value="1"/> Randomize Questions
</div>
</div>
<div class="row">
<div class="col-sm-12">
<form:checkbox path="isChoiceRandom" value="1"/> Randomize Choices 
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