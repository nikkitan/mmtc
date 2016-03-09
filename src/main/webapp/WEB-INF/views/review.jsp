<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.highlight.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/d3/d3.v3.min.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<style type="text/css">

body {
    font: 20px Montserrat, sans-serif;
    line-height: 1.8;
    color: #f5f6f7;
 	-webkit-user-select: none;
    -moz-user-select: -moz-none;
    -ms-user-select: none;
    user-select: none;
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

.highlight{
	background-color: #FFFF88;
}
</style>
<script>
var data = ${scores};
var cat = ['Required Score','Your Score'];
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
        <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/logout">LogOut</a></li>
      </ul>
    </div>
  </div>
</nav>
<div class="container-fluid bg-3">
<h2><span class="label label-default">Examination Score Report:</span></h2>
<div class="row">
<div class="col-sm-2">
</div>
<div class="col-sm-8">
<div class="container-fluid bg-3">
<!-- Candidate -->
<div class="row">
<div class="col-sm-4">
<label>Candidate:</label>
</div>
<div class="col-sm-2">
<h4>${participant}</h4>
</div>
</div>
<!-- Date,Time -->
<div class="row">
<div class="col-sm-4">
<label>Date:</label>
</div>
<div class="col-sm-2">
<h4>${date}</h4>
</div>
<div class="col-sm-4">
<label>Time:</label>
</div>
<div class="col-sm-2">
<h4>${time}</h4>
</div>
</div>
<!-- Exam Number, Elapsed Time -->
<div class="row">
<div class="col-sm-4">
<label>Exam Number:</label>
</div>
<div class="col-sm-2">
<h4>${examnum}</h4>
</div>
<div class="col-sm-4">
<label>Elapsed Time:</label>
</div>
<div class="col-sm-2">
<h4>${elaptime}</h4>
</div>
</div>
<!-- Bar chart -->
<div class="row">
<div class="col-sm-4">
<label>Chart goes here</label>
</div>
<div class="col-sm-2">
<h4>chart</h4>
</div>
</div>
<!-- Passing Score, Your Score, Grade:Fail/Pass -->
<div class="row">
<div class="col-sm-4">
<label>Passing Score:</label>
</div>
<div class="col-sm-2">
<h4>${passscore}</h4>
</div>
</div>
<!-- Your Score, Grade:Fail/Pass -->
<div class="row">
<div class="col-sm-4">
<label>Your Score:</label>
</div>
<div class="col-sm-2">
<h4>${urscore}</h4>
</div>
</div>
<!-- Grade:Fail/Pass -->
<div class="row">
<div class="col-sm-4">
<label>Grade:</label>
</div>
<div class="col-sm-2">
<h4>${grade}</h4>
</div>
</div>
</div>
</div>
<div class="col-sm-2">
</div>
</div>
</div>
<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
  <p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer>
</body>
</html>