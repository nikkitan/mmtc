<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false"%>
<!DOCTYPE html>
<head>
<meta charset="utf8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">

<title>MMTC</title>
<style>

</style>
</head>
<body>

<!-- Navbar -->
<nav class="container-fluid navbar navbar-default">
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
        <li><a href="${pageContext.request.contextPath}/login">Log in</a></li>
        <li><a href="${pageContext.request.contextPath}/adduser" id="signup" class="btn btn-signup">Sign Up</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- First Container -->
  <div id="myCarousel" class="carousel slide" data-ride="carousel">
	  <!-- Indicators -->
	  <ol class="carousel-indicators">
	    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
	    <li data-target="#myCarousel" data-slide-to="1"></li>
	    <li data-target="#myCarousel" data-slide-to="2"></li>
	    <li data-target="#myCarousel" data-slide-to="3"></li>
	  </ol>

	  <!-- Wrapper for slides -->
	  <div class="carousel-inner licensepic" role="listbox">
	    <div class="item active">
	      <img src="${pageContext.request.contextPath}/resources/pic/slogan.jpg" alt="slogan">
	    </div>
	
	    <div class="item">
	      <img src="${pageContext.request.contextPath}/resources/pic/Indiana.jpg" alt="Indiana License">
	    </div>
	
	    <div class="item">
	      <img src="${pageContext.request.contextPath}/resources/pic/slogan2.jpg" alt="slogan2">
	    </div>
	
	    <div class="item">
	      <img src="${pageContext.request.contextPath}/resources/pic/Virginia.jpg" alt="Virginia">
	    </div>
	  </div>

		<!-- Left and right controls -->
		<a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
	 		<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
	 		<span class="sr-only">Previous</span>
		</a>
		<a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
	 		<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
	 		<span class="sr-only">Next</span>
		</a>
	</div>

<!-- Second Container -->
<div class="container-fluid bg-2 text-center">
  <h3 class="margin">Our Services</h3>
  <p>這裡要放業務流程（希望有插圖）</p>
  <!-- <a href="#" class="btn btn-default btn-lg">
    <span class="glyphicon glyphicon-search"></span> Search
  </a> -->
</div>

<!-- Third Container (Grid) -->
<div class="container-fluid bg-3 text-center">    
  <h3 class="margin">Hear what our students say</h3><br>
  <div class="row">
    <div class="col-sm-4">
      <p>（學生實例1）</p>
      <!--  <img src="birds1.jpg" class="img-responsive margin" style="width:100%" alt="Image">-->
    </div>
    <div class="col-sm-4"> 
      <p>（學生實例2）</p>
      <!-- <img src="birds2.jpg" class="img-responsive margin" style="width:100%" alt="Image">  -->
    </div>
    <div class="col-sm-4"> 
      <p>（學生實例3）</p>
      <!--  <img src="birds3.jpg" class="img-responsive margin" style="width:100%" alt="Image"> -->
    </div>
  </div>
</div>

<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
  <p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer>

</body>
</html>