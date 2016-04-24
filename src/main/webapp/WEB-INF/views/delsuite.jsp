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
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">
<style>
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
<div class="container-fluid bg-3">
<form:form method="POST" action="delsuite" commandName="ts" >  
<table><!-- ROOT -->
<tr>
<td style="width:70%;">
<table>  
    <tbody><tr>  
    <td>  
        <ul>  
            <form:select path="name" items="${suites}">  
        </form:select></ul>  
    </td>  
    </tr>  
    <tr>  
        <td>  
            <input type="submit" value="Submit">  
        </td>  
    </tr>  
</tbody></table>    
</form:form>
</td>

<td style="vertical-align:top;">
</td>
</tr>
</table><!-- ROOT -->
</div>
<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
  <p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer></body>
</html>