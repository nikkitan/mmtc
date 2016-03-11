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
	var testStartTime = new Date();
	window.localStorage.setItem('start_time',testStartTime);
	var iii = 9;
	console.log("[START]: " + testStartTime);	
	var endTime = testStartTime;
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
		console.log("resume! ");
		console.log(Date.parse(resumeTime) - Date.parse(pauseTime));
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
	
	//Review Btn.
	$('#rvwbtn').on('click', function (e) {
		$('#rvwModal').modal();
		//console.log("prev! " + curTest);
		
	});
	
	//Submit.
	$('#sbtbtn').on('click', function (e) {
		p.user = "${pageContext.request.userPrincipal.name}";
		testStartTime = window.localStorage.getItem('start_time');
		var curDate = new Date();
		p.end = Date.parse(curDate);
		p.beg = Date.parse(testStartTime);
		//p.testdur = (Date.parse(curDate) - Date.parse(testStartTime))/1000;
		console.log("s: " + testStartTime);
		console.log("c: " + curDate);
		console.log(Date.parse(curDate));
		console.log(Date.parse(testStartTime));
		console.log((Date.parse(curDate) - Date.parse(testStartTime))/1000);
		$('input[name="tests"]').attr("value",JSON.stringify(p));
		clearInterval(timerIntervalObj);
	});	
	
	function genReviewTable(){
		var review = "<div class=\"container-fluid col-md-12\"><div class=\"row\">";
		var listPrefix = "<div class=\"list-group\">";
		var itemPrefix = "<p class=\"list-group-item\">";
		var itemSuffix = "</p>";
		var divEndTag = "</div>";
		var colPrefix = "<div class=\"col-md-2\">";
		review += colPrefix;
		review += listPrefix;
		var limit = p.tests.length;
		for(var i = 0; i < limit; ++i){
			if(i != 0 && i%20 == 0){
				review += divEndTag;
				review += divEndTag;				
				review += colPrefix;
				review += listPrefix;
			}
			
			review += itemPrefix;
			review += i+1;
			review += ":";
			if(p.tests[i].hasOwnProperty("taking")){
				review += p.tests[i].taking.stuans;				
			}else{
				review += "-";
			}
			review += itemSuffix;				

		}
		review += divEndTag;
		review += divEndTag;
		return review;
	}
	//Review Modal
	$('#rvwModal').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var recipient = button.data('whatever') // Extract info from data-* attributes
	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
	  var modal = $(this)
	  //modal.find('.modal-title').text('New message to ' + recipient)
	  modal.find('.modal-body').html(genReviewTable());
	})
	//Show/Hide answer.
	$('#ansbtn').on('click', function (e) {
		//.log("answer!" + curTest);
		if($(this).html() == "Show Answer"){
			$(this).html("Hide Answer");
			$('#ansrow #anscol #answell').removeClass('hidden');
			if(typeof p.tests[curTest].answers != 'undefined'){
				$("#ansrow #anscol #answell").append("Answer:"+ p.tests[curTest].answers[0] + "<br>");
			}

			if(typeof p.tests[curTest].kwds != 'undefined'){
				var kwds = p.tests[curTest].kwds;
				$("#ansrow #anscol #answell").append("Keyword: " + kwds + "<br>");
				for(var i = 0; i < kwds.length; i+=2){
					$('#testrootpanel #quescol #ques').highlight(kwds[i]);
					$('#testrootpanel #optcol .radio .radiobtnopt').highlight(kwds[i]);					
				}
			}
			
			
			if(typeof p.tests[curTest].watchword != 'undefined'){
				$("#ansrow #anscol #answell").append("Watchword:"+ p.tests[curTest].watchword + "<br>");
			}
			
			if(typeof p.tests[curTest].tips != 'undefined'){
				$("#ansrow #anscol #answell").append("Tips:"+ p.tests[curTest].tips);
			}

		}else{
			$(this).html("Show Answer");
			$("#ansrow #anscol #answell").html('');
			$('#ansrow #anscol #answell').addClass('hidden');
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
			$('#testrootpanel #ansrow #anscol #answell').html('');
			$('#ansrow #anscol #answell').addClass('hidden');
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
				var id = "opt" + i;
				if(typeof p.tests[curTest].taking != 'undefined'){
					if(p.tests[curTest].taking.stuans == opt.charAt(0)){
						$('#testrootpanel #optcol').append("<div class=\"radio\"><label class=\"radiobtnopt\" for=\"" 
							+ id + "\"><input id=\"" + id + "\"type=\"radio\" name=\"optradio\" checked>" + opt + "</label></div>");
					}else{
						$('#testrootpanel #optcol').append("<div class=\"radio\"><label class=\"radiobtnopt\" for=\"" 
								+ id + "\"><input id=\"" + id + "\"type=\"radio\" name=\"optradio\">" + opt + "</label></div>");			
					}
				}else{
					$('#testrootpanel #optcol').append("<div class=\"radio\"><label class=\"radiobtnopt\" for=\"" 
							+ id + "\"><input id=\"" + id + "\"type=\"radio\" name=\"optradio\">" + opt + "</label></div>");
				}
				$('input[name="optradio"]').on('click',
					function(){
						//onclicked, cache clicked option to local storage.
						p.tests[curTest].taking = {"stuans":$(this).parent().text().charAt(0)}
						window.localStorage.setItem('tests',JSON.stringify(p));						
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
        <h4 class="modal-title">Pause!</h4>
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
        <h4 class="modal-title">Time Out</h4>
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
<!-- Review Modal -->
<div class="modal fade" id="rvwModal" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Test Review</h4>
      </div>
      <div class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button id="endtestbtn" type="button" class="btn btn-default" data-dismiss="modal" >OK</button>
      </div>
    </div>
  </div>
</div>
<form:form id="myform" method="POST" action="${pageContext.request.contextPath}/submitans?${_csrf.parameterName}=${_csrf.token}"> 
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
<button type="button" id="rvwbtn">Review</button>
</div>
<div style="text-align:right" class="col-sm-4">
<!-- pause,end exam -->
<button id="paubtn" type="button" data-toggle="modal" data-target="#pauModal">Pause</button>
<input type="hidden" name="tests" />
<input type="submit" value="Submit" id="sbtbtn"/> 
</div>
</div>
</form:form>
</div>

<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
  <p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer></body>
</html>