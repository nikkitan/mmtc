<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<script type="text/javascript">
function updateRemainingTime(endTime){
	//console.log("[updateRemain]: " + endTime);
	var dur = Date.parse(endTime) - Date.parse(new Date());
	var seconds = Math.floor( (dur/1000) % 60 );
	var minutes = Math.floor( (dur/1000/60) % 60 );
	var hours = Math.floor( (dur/(1000*60*60)) % 24 );
	var days = Math.floor( dur/(1000*60*60*24) );
	return {
	  'dur': dur,
	  'days': days,
	  'hours': hours,
	  'minutes': minutes,
	  'seconds': seconds
	};
}
$(document).on("contextmenu", function (event) { event.preventDefault(); });
$(document).ready(function() {
	//Get and save in JSON.
	<% String origTest=(String)request.getAttribute("tests");%>
	var oo = '<%=origTest%>';
	var p = jQuery.parseJSON(oo);
	window.localStorage.setItem('tests',oo);	
	var total = p.tests.length;
	//Initialize timer.
	var startTime = new Date();
	var endTime = startTime;
	//console.log("[ENDTIME 1]: " + endTime);
	var pauseTime;
	var resumeTime;
	//endTime.setSeconds(endTime.getSeconds() + 10);
	endTime.setHours(endTime.getHours() + 2);
	function updateTimer(){
		//console.log("[updateTimer]: " + endTime);
		var d = updateRemainingTime(endTime);
		//console.log("[updateTimer]: " + JSON.stringify(d));
		$('#rt').html("Time Remaining:" + ('0'+d.hours).slice(-2) + ":" + ('0'+d.minutes).slice(-2) + ":" + ('0' + d.seconds).slice(-2));
		if(d.dur <= 0){
			clearInterval(timerIntervalObj);
			$('#timeoutModal').modal();
		}
	}
	
	updateTimer();
	var timerIntervalObj = setInterval(updateTimer,1000);	
	
	//Pause Timer.
	$('#paubtn').on('click', function (e) {
		pauseTime = new Date();
		console.log("pause!");
		clearInterval(timerIntervalObj);
	})	
	
	//Resume Timer.
	$('#unpausebtn').on('click', function (e) {
		resumeTime = new Date();
		var prevEndTime = Date.parse(endTime);
		prevEndTime += Date.parse(resumeTime) - Date.parse(pauseTime);
		endTime = new Date(prevEndTime);
		//console.log("[ENDTIME 2]: " + endTime);
		//console.log("resume!");
		updateTimer();
		timerIntervalObj = setInterval(updateTimer,1000);	
	});
	
	//Next test.
	var curTest = 0;
	$('#nxtbtn').on('click', function (e) {
		curTest += 1;
		showTest();
		//console.log("next! " + curTest);
	});	
	
	//Prev test.
	$('#prvbtn').on('click', function (e) {
		curTest -= 1;
		showTest();
		//console.log("prev! " + curTest);
	});
	
	
	//TimeOut End test.
	$('#endtestbtn').on('click', function (e) {
		curTest -= 1;
		showTest();
		window.location.replace("${pageContext.request.contextPath}/index");
		//console.log("prev! " + curTest);
	});
	
	//Show/Hide answer.
	$('#ansbtn').on('click', function (e) {
		//.log("answer!" + curTest);
		if($(this).html() == "Show Answer"){
			$(this).html("Hide Answer");
			/*if(typeof p.tests[curTest].kwds != 'undefined'
					&& typeof p.tests[curTest].kwds != 'NOKEYWORD'
					&& typeof p.tests[curTest].kwds != 'NOKEYWORDS'){
				var kwds = p.tests[curTest].kwds;
				$("#ansrow").append("<div class=\"col-sm-12\"><div class=\"well\">Answer:"
						+ p.tests[curTest].answers[0] + "<br>" + kwds + "</div></div>");
				for(var i = 0; i < kwds.length; i+=2){
					$('#testrootpanel #quescol #ques').highlight(kwds[i]);
					$('#testrootpanel #optcol .radio .radiobtnopt').highlight(kwds[i]);					
				}
			}*/

			if(typeof p.tests[curTest].answer != 'undefined'
					&& typeof p.tests[curTest].answer != 'NOANS'){
				$('#ansrow #anscol #answell').removeClass('hidden');
				$("#ansrow #anscol #answell").append("Answer:"+ p.tests[curTest].answers[0]);
			}
		}else{
			$(this).html("Show Answer");
			$('#ansrow #anscol #answell').addClass('hidden');

			$("#ansrow #anscol #answell").children().last().remove();
		}
	});	
	
	//Display tests.
	function showTest(){
		if(curTest > -1 && curTest < total){
			$('#testrootpanel #qh').children().last().remove();
			//$('#testrootpanel #qthb').children().last().remove();
			//$('#testrootpanel #ques').children().last().remove();
			$('#testrootpanel #quescol').html('');
			$('#testrootpanel #optcol').html('');
			$('#testrootpanel #ansrow').html('');
			$('#testrootpanel #ansbtn').html('Show Answer');
			var curSN = curTest + 1;
			$('#testrootpanel #qh').append("<h4>Item " + curSN + " of "+ total +"</h4>");
			if(typeof p.tests[curTest].pic != 'undefined'){
				$('#testrootpanel #quescol').append("<div class=\"thumbnail\" id=\"qthb\"><img src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[curTest].pic+ "\"/></div>")
				$('#testrootpanel #quescol').append("<div class=\"caption\" id=\"ques\"><h4>" + p.tests[curTest].question[0] + "</h4>");
			}else{
				$('#testrootpanel #quescol').append("<div class=\"caption\" id=\"ques\"><h4>" 
						+ p.tests[curTest].question[0] +"</h4></div>")
			}
			var opts = p.tests[curTest].options;
			for(var i = 0; i < opts.length; ++i){
				var opt = opts[i];
				$('#testrootpanel #optcol').append("<div class=\"radio\"><label class=\"radiobtnopt\"><input type=\"radio\" name=\"optradio\">" + opt + "</label></div>");
				$('#testrootpanel #optcol').children().last().on('click',
					function(){
						//onclicked, cache clicked option to local storage.
						var tt = window.localStorage.getItem('tests');
						
				});
			}
		}
	}
	
	showTest();
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
        <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/logout">LogOut</a></li>
      </ul>
    </div>
  </div>
</nav>
<div class="container-fluid bg-3" id="testrootpanel">
<!-- Pause Modal -->
<div class="modal fade" id="pauModal" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Modal Header</h4>
      </div>
      <div class="modal-body">
        <p>Exam paused. Click OK to resume</p>
      </div>
      <div class="modal-footer">
        <button id="unpausebtn" type="button" class="btn btn-default" data-dismiss="modal" >OK</button>
      </div>
    </div>
  </div>
</div>
<!-- TimeOut Modal -->
<div class="modal fade" id="timeoutModal" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Modal Header</h4>
      </div>
      <div class="modal-body">
        <p>Your time has expired. Press OK to end the exam.</p>
      </div>
      <div class="modal-footer">
        <button id="endtestbtn" type="button" class="btn btn-default" data-dismiss="modal" >OK</button>
      </div>
    </div>
  </div>
</div>
<form:form method="POST" action="${s}?${_csrf.parameterName}=${_csrf.token}" commandName="ts" enctype="multipart/form-data"> 
<div class="row">
<div class="col-sm-8"><!-- MARK --></div>
<div class="col-sm-4">
<!-- COUNTDOWN -->	
<h4 style="text-align:right" id="rt">Time Remaining:00:00:00</h4>
</div>
</div>
<div class="row">
<div class="col-sm-8">
<div id="qh"></div>
</div>
<div style="text-align:right" class="col-sm-4">
<button type="button" id="ansbtn">Show Answer</button>
<button>Calculator</button>
</div>
</div>
<hr>
<div class="row">
<div class="col-sm-8" id="quescol">

</div>

</div>
<div class="row">
<div class="col-sm-8" id="optcol">
<!-- radio buttons -->
</div>
</div>
<div class="row" id="ansrow">
<!-- ANSWER -->
<div class="col-sm-12" id="anscol">
<div class="well hidden" id="answell">
</div>
</div>
</div>
<div class="row">
<div class="col-sm-8">
<!-- prev,next,review -->
<button type="button" id="prvbtn">Prev</button>
<button type="button" id="nxtbtn">Next</button>
<button type="button" id="prvbtn">Review</button>
</div>
<div style="text-align:right" class="col-sm-4">
<!-- pause,end exam -->
<button id="paubtn" type="button" data-toggle="modal" data-target="#pauModal">Pause</button>
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