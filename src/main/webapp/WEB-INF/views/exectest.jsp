<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=5"><!-- IE fix -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.highlight.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css"/>

<style type="text/css">
.highlight{
	background-color: #FFFF88;
	font-weight: bold;
}
p.marked{
	color:orange;
}

p.notanswered{
	color:red;
}

#ques>h3{
	font-weight:500;
}

</style>
<script type="text/javascript">
function updateRemainingTime(endTime){
	//console.log("[updateRemain]: " + endTime);
	var dur = endTime - Date.now();//Date.parse(endTime) - Date.parse(new Date());
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
	window.sessionStorage.setItem('tests',oo);	

	var total = p.tests.length;
	//Initialize timer.
	var testStartTime = Date.now();//new Date();
	window.sessionStorage.setItem('start_time',testStartTime);
	var iii = 9;
	//console.log("[START]: " + testStartTime);	
	var endTime = testStartTime;
	var pauseTime;
	var resumeTime;
	endTime += 7200000;//endTime.setHours(endTime.getHours() + 2);
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
		pauseTime = Date.now();//new Date();
		console.log("pause!");
		clearInterval(timerIntervalObj);
	})	
	
	//Resume Timer.
	$('#unpausebtn').on('click', function (e) {
		resumeTime = Date.now();//new Date();
		//var prevEndTime = endTime;//Date.parse(endTime);
		endTime += resumeTime - pauseTime;//Date.parse(resumeTime) - Date.parse(pauseTime);
		//endTime = new Date(prevEndTime);
		console.log("[ENDTIME 2]: " + endTime);
		console.log("resume! ");
		console.log(resumeTime - pauseTime);
		//console.log(Date.parse(resumeTime) - Date.parse(pauseTime));
		updateTimer();
		timerIntervalObj = setInterval(updateTimer,1000);	
	});
	
	//Next test.
	var curTest = 0;
	$('#nxtbtn').on('click', function (e) {
		if(curTest + 1 < p.tests.length){
			curTest += 1;
			showTest();
		}
	});	
	
	//Prev test.
	$('#prvbtn').on('click', function (e) {
		if(curTest-1 >= 0){
			curTest -= 1;
			showTest();
		}
	});
	
	
	//TimeOut End test.
	$('#endtestbtn').on('click', function (e) {
		curTest -= 1;
		showTest();
		window.location.replace("${pageContext.request.contextPath}/index");
	});
	
	//Review Btn.
	$('#rvwbtn').on('click', function (e) {
		$('#rvwModal').modal();		
	});
	
	//Mark checkbox.
	$('#chekmark').on('click', function (e) {
		p.tests[curTest].marked = $(this).prop('checked');
	});
	
	//Submit.
	$('#sbtbtn').on('click', function (e) {
		p.user = "${pageContext.request.userPrincipal.name}";
		testStartTime = window.sessionStorage.getItem('start_time');
		var curDate = new Date();
		p.end = Date.now();
		p.beg = testStartTime;
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
		var markedPrefix = "<p class=\"marked\">";
		var listGroupItemRowPrefix = "<div class=\"row list-group-item\">";
		var listGroupItemCol1Prefix = "<div class=\"col-xs-6\">";
		var listGroupItemCol2Prefix = "<div class=\"col-xs-6\">";
		var itemPrefix = "<p ";
		var itemSuffix = "</p>";
		var divEndTag = "</div>";
		var colPrefix = "<div class=\"col-md-2\">";
		review += colPrefix;
		review += listPrefix;
		var limit = p.tests.length;
		for(var i = 0; i < limit; ++i){
			if(i != 0 && i%20 == 0){
				review += divEndTag;//close list-group.
				review += divEndTag;//close col-md-2.
				review += colPrefix;
				review += listPrefix;
				review += listGroupItemRowPrefix;
				review += listGroupItemCol1Prefix;
			}else{
				review += listGroupItemRowPrefix;
				review += listGroupItemCol1Prefix;
			}
			review += markedPrefix
			if(p.tests[i].hasOwnProperty('marked')
					&& p.tests[i].marked != 'undefined'){
				review += 'M';
			}
			review += itemSuffix;
			review += divEndTag;//close item col1;
			review += listGroupItemCol2Prefix;
			if(p.tests[i].hasOwnProperty("taking")
					&& p.tests[i].taking != 'undefined'){
				review += itemPrefix;
				review += ">";
				review += i+1;
				review += ":";
				review += p.tests[i].taking.stuAns;				
			}else{
				review += itemPrefix;
				review += "class=\"notanswered\">";
				review += i+1;
				review += ":";
				review += "-";
			}
			review += itemSuffix;
			review += divEndTag;//close item col2.
			review += divEndTag;//close item row.
		}
		review += divEndTag;//close row in modal.
		review += divEndTag;//close root col in modal.
		return review;
	}
	//Review Modal
	$('#rvwModal').on('show.bs.modal', function (event) {
	  var modal = $(this)
	  modal.find('.modal-body').html(genReviewTable());
	})
	//Show/Hide answer.
	$('#ansbtn').on('click', function (e) {
		//.log("answer!" + curTest);
		var answell = $('#answell');
		if($(this).html() == "Show Answer"){
			$(this).html("Hide Answer");
			answell.removeClass('hidden');
			if(typeof p.tests[curTest].answers != 'undefined'){
				answell.append("Answer:"+ p.tests[curTest].answers[0] + "<br>");
			}

			if(typeof p.tests[curTest].kwds != 'undefined'){
				var kwds = p.tests[curTest].kwds;
				var kwd;
				answell.append("Keyword: " + kwds + "<br>");
				for(var i = 0; i < kwds.length; i+=2){
					kwd = kwds[i].trim();
					answell.highlight(kwd);
					$('#ques').highlight(kwd);
					$('#optcol .radio .radiobtnopt').highlight(kwd);					
				}
			}
			
			
			if(typeof p.tests[curTest].watchword != 'undefined'){
				answell.append("Watchword:"+ p.tests[curTest].watchword + "<br>");
				var wwds = p.tests[curTest].watchword;
				var wwd;
				for(var i = 0; i < wwds.length; i+=2){
					wwd = wwds[i].trim();
					answell.highlight(wwd);
					$('#ques').highlight(wwd);
					$('#optcol .radio .radiobtnopt').highlight(wwd);					
				}
			}
			
			if(typeof p.tests[curTest].tips != 'undefined'){
				answell.append("Tips:"+ p.tests[curTest].tips);
			}

		}else{
			$(this).html("Show Answer");
			answell.html('');
			answell.addClass('hidden');
			$('#ques').unhighlight();
			$('#optcol .radio .radiobtnopt').unhighlight();
		}
	});	
	
	//Display tests.
	function showTest(){
		if(curTest > -1 && curTest < total){
			$('#qh').children().last().remove();
			$('#quescol').html('');
			$('#optcol').html('');
			var answell = $('#answell');
			answell.html('');
			answell.addClass('hidden');
			$('#testrootpanel #ansbtn').html('Show Answer');
			$('#chekmark').prop('checked',false);
			if(p.tests[curTest].hasOwnProperty('marked')
				&& typeof p.tests[curTest].marked != 'undefined'){
				$('#chekmark').prop('checked',p.tests[curTest].marked);
			}
			var curSN = curTest + 1;
			$('#qh').append("<label>Item " + curSN + " of "+ total +"</label>");
			if(typeof p.tests[curTest].pic != 'undefined'){
				$('#quescol').append("<div class=\"thumbnail\" id=\"qthb\"><img src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[curTest].pic+ "\"/></div>")
				$('#quescol').append("<div class=\"caption\" id=\"ques\"><h3>" + p.tests[curTest].question[0] + "</h3>");
			}else{
				$('#quescol').append("<div class=\"caption\" id=\"ques\"><h3>" 
						+ p.tests[curTest].question[0] +"</h3></div>")
			}
			var opts = p.tests[curTest].options;
			for(var i = 0; i < opts.length; ++i){
				var opt = opts[i];
				var id = "opt" + i;
				if(typeof p.tests[curTest].taking != 'undefined'){
					if(p.tests[curTest].taking.stuAns == opt.charAt(0)){
						$('#optcol').append("<div class=\"radio\"><label class=\"radiobtnopt\" for=\"" 
							+ id + "\"><input id=\"" + id + "\"type=\"radio\" name=\"optradio\" checked>" + opt + "</label></div>");
					}else{
						$('#optcol').append("<div class=\"radio\"><label class=\"radiobtnopt\" for=\"" 
								+ id + "\"><input id=\"" + id + "\"type=\"radio\" name=\"optradio\">" + opt + "</label></div>");			
					}
				}else{
					$('#optcol').append("<div class=\"radio\"><label class=\"radiobtnopt\" for=\"" 
							+ id + "\"><input id=\"" + id + "\"type=\"radio\" name=\"optradio\">" + opt + "</label></div>");
				}
				$('input[name="optradio"]').on('click',
					function(){
						//onclicked, cache clicked option to local storage.
						p.tests[curTest].taking = {"stuAns":$(this).parent().text().charAt(0)}
						window.sessionStorage.setItem('tests',JSON.stringify(p));						
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
      <a class="navbar-brand" href="${pageContext.request.contextPath}/index">MMTC 全方位专业按摩培训</a>
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
        <button id="endtestbtn" type="button" class="btn btn-default" data-dismiss="modal" onclick='window.location.replace("${pageContext.request.contextPath}/home");' >OK</button>
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
<form:form id="myform" method="POST" action="${pageContext.request.contextPath}/submitans"> 
<div class="row">
<div class="col-sm-8">
<!-- MARK -->
<h4><input id="chekmark" type="checkbox" style="margin-right:10px;">Mark</h4>
</div>
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
<div class="col-xs-12 col-sm-12 col-lg-12" id="quescol">

</div>

</div>
<div class="row">
<div class="col-sm-8 col-lg-10" id="optcol">
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
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
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