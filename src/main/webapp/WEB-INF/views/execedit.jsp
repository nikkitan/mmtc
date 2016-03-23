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
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">

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

.form-control#ques{
	font-size: 20px;
}

input[name="opt"]{
	margin-top:10px;
	margin-bottom:10px;
	width:100%;
}

label[for="chekedit"]{
	font-weight: normal;
}

#nxtbtn.notorig{
	margin-left:6px;
	margin-right:6px;
}

#delbtn.notorig{
	margin-right:6px;
}
</style>
<script type="text/javascript">
$(document).on("contextmenu", function (event) { event.preventDefault(); });
var delBtn = '<button id="delbtn" class="notorig" type="button">Delete</button>';
var newBtn = '<button id="newbtn" class="notorig" type="button">New</button>';
var prvBtn = '<button type="button" class="notorig" id="prvbtn">Prev</button>';
var nxtBtn = '<button type="button" class="notorig" id="nxtbtn">Next</button>';
var rvwBtn = '<button type="button" class="notorig" id="rvwbtn">Review</button>';
var sbtBtn = '<input type="submit" value="Submit" id="sbtbtn"/>';
var view = 'v';
var edit = 'e';
var curMode = view;
var curDom;
$(document).ready(function() {
	//Get and save in JSON.
	<% String origTest=(String)request.getAttribute("tests");%>
	var oo = '<%=origTest%>';
	var p = jQuery.parseJSON(oo);
	window.localStorage.setItem('tests',oo);	
	var total = p.tests.length;
	
	//Next test.
	var curTest = 0;
	$('#nxtbtn').on('click', function (e) {
		if(curTest + 1 < p.tests.length){
			curTest += 1;
			showTest4View();
		}
	});	
	
	//Prev test.
	$('#prvbtn').on('click', function (e) {
		if(curTest-1 >= 0){
			curTest -= 1;
			showTest4View();
		}
	});
	
	
	//TimeOut End test.
	$('#endtestbtn').on('click', function (e) {
		curTest -= 1;
		showTest4View();
		window.location.replace("${pageContext.request.contextPath}/index");
	});
	
	//Review Btn.
	$('#rvwbtn').on('click', function (e) {
		$('#rvwModal').modal();		
	});
	
	//Delete Test Btn.
	$('#delbtn').on('click', function (e) {
		$('#rvwModal').modal();		
	});
		
	//New Test Btn.
	$('#newbtn').on('click', function (e) {
		p.tests.splice(curTest,0,{"dirty":true,"isnew":true,"serialNo":curTest});
		window.localStorage.setItem("tests",JSON.stringify(p));
		showTest4Edit();
	});
	
	
	//Ans <p> in Review Modal.
	$('#rvwModal').on('hide.bs.modal', function (e) {
		curTest = parseInt(window.localStorage.getItem('modelsel'));
		showTest4View();
	});	
	
	//Mark checkbox.
	$('#chekedit').on('click', function (e) {
		p.tests[curTest].dirty = true;
		if(curMode == view){
			curMode = edit;
			showTest4Edit();
		}else{
			curDom = $('#prvnxtrvwdiv');
			curDom.append(prvBtn);
			curDom.children().last().on('click', function (e) {
				if(curTest-1 >= 0){
					curTest -= 1;
					showTest4View();
				}
			});
			curDom.append(nxtBtn);
			curDom.children().last().on('click', function (e) {
				if(curTest + 1 < p.tests.length){
					curTest += 1;
					showTest4View();
				}
			});
			curDom.append(rvwBtn);
			curDom.children().last().on('click', function (e) {
				$('#rvwModal').modal();		
			});
			curDom = $('#delnewdiv');
			curDom.append(delBtn);
			curDom.append(newBtn);
			curDom.children().last().on('click', function (e) {
				p.tests.splice(curTest,0,{"dirty":true,"isnew":true,"serialNo":curTest});
				window.localStorage.setItem("tests",JSON.stringify(p));
				showTest4Edit();
			});
			curDom = $('#sbtdiv');
			curDom.append(sbtBtn).on('click', function (e) {
				p.user = "${pageContext.request.userPrincipal.name}";
				testStartTime = window.localStorage.getItem('start_time');
				var curDate = new Date();
				p.end = Date.now();//Date.parse(curDate);
				p.beg = testStartTime;//Date.parse(testStartTime);
				//p.testdur = (Date.parse(curDate) - Date.parse(testStartTime))/1000;
				console.log("s: " + testStartTime);
				console.log("c: " + curDate);
				console.log(Date.parse(curDate));
				console.log(Date.parse(testStartTime));
				console.log((Date.parse(curDate) - Date.parse(testStartTime))/1000);
				$('input[name="tests"]').attr("value",JSON.stringify(p));
				clearInterval(timerIntervalObj);
			});
			curMode = view;
			showTest4View();
		}
	});
	
	//Submit.
	$('#sbtbtn').on('click', function (e) {
		p.user = "${pageContext.request.userPrincipal.name}";
		testStartTime = window.localStorage.getItem('start_time');
		var curDate = new Date();
		p.end = Date.now();//Date.parse(curDate);
		p.beg = testStartTime;//Date.parse(testStartTime);
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
			if(p.tests[i].hasOwnProperty('dirty')
					&& p.tests[i].dirty != 'undefined'){
				review += 'E';
			}
			review += itemSuffix;
			review += divEndTag;//close item col1;
			review += listGroupItemCol2Prefix;
			if(p.tests[i].hasOwnProperty("taking")
					&& p.tests[i].taking != 'undefined'){
				review += itemPrefix;
				review += "\" onclick='window.localStorage.setItem(\"modelsel\","+i+"); $(\"#rvwModal\").modal(\"hide\");' ";
				review += ">";
				review += i+1;
				review += ":";
				review += p.tests[i].taking.stuans;				
			}else{
				review += itemPrefix;
				review += "\" onclick='window.localStorage.setItem(\"modelsel\","+i+"); $(\"#rvwModal\").modal(\"hide\");' ";
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
	  var button = $(event.relatedTarget);
	  var recipient = button.data('whatever');
	  var modal = $(this);
	  modal.find('.modal-body').html(genReviewTable());
	})


	//Display tests.
	function showTest4Edit(){
		if(curTest > -1 && curTest < total){
			console.log('[show4Edit]');
			$('#prvnxtrvwdiv').html('');
			$('#delnewdiv').html('');
			$('#sbtdiv').html('');
			$('#qh').children().last().remove();
			$('#quescol').html('');
			$('#optcol').html('');
			var answell = $('#answell');
			answell.html('');
			answell.removeClass('hidden');
			if(p.tests[curTest].hasOwnProperty('dirty')
				&& typeof p.tests[curTest].dirty != 'undefined'){
				$('#chekedit').prop('checked',p.tests[curTest].dirty);
				$('label[for="chekedit"]').text('Uncheck to finalize editing.');
			}
			var curSN = curTest + 1;
			$('#qh').append("<label>Item " + curSN + " of "+ total +"</label>");
			
			$('#quescol').append("<div class=\"thumbnail\" id=\"qthb\"><label for=\"pic_input\"><img src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[curTest].pic+ "\"/></label><input id=\"pic_input\" type=\"file\" name=\"file\"/></div>");	
			
			if(typeof p.tests[curTest].question != 'undefined'){
				$('#quescol').append("<textarea id=\"ques\" class=\"form-control\">" + p.tests[curTest].question[0] + "</textarea>");
			}else{
				$('#quescol').append("<textarea id=\"ques\" class=\"form-control\" placeholder=\"Question\"></textarea>");				
			}
						
			//Options.
			if(p.tests[curTest].hasOwnProperty('dirty')
				&& typeof p.tests[curTest].options != 'undefined'){
				var opts = p.tests[curTest].options;
				for(var i = 0; i < opts.length; ++i){
					var opt = opts[i];
					var id = "opt" + i;
					$('#optcol').append("<input id=\"" + id + "\"type=\"text\" name=\"opt\" placeholder=\"" + opt + "\"></input><br>");
				}
			}else{
				var optcol = $('#optcol');
				optcol.append("<div class=\"row\">");
				optcol.children().last().append("<div id=\"opt\" class=\"col-xs-5\">");
				optcol.children().last().append("<div class=\"col-xs-5\">");

				optcol = $('#opt');
				
				optcol.append("<input name=\"opt\" type=\"text\" placeholder=\"Option A\">");
				optcol.append("<input name=\"opt\" type=\"text\" placeholder=\"Option B\">");
				optcol.append("<input name=\"opt\" type=\"text\" placeholder=\"Option C\">");
				optcol.append("<input name=\"opt\" type=\"text\" placeholder=\"Option D\">");
			}
			
			//Answer area
			answell.append("<div class=\"row\">Answer:</div>");
			answell.append("<div id=\"ansr\" class=\"row\">");
			$("#ansr").append("<div id=\"ansc\" class=\"col-xs-2\">");
			if(typeof p.tests[curTest].answers != 'undefined'){
				$("#ansc").append("<input type=\"text\" class=\"form-control\" placeholder=\""+ p.tests[curTest].answers[0] + "\"></input>");
			}else{
				$("#ansc").append("<input type=\"text\" class=\"form-control\"></input>");
			}
			
			
			//Keyword
			answell.append("<div class=\"row\">Keyword:</div>");
			answell.append("<div id=\"kwds\" class=\"row\">");
			$("#kwds").append("<div id=\"en\" class=\"col-xs-5\">");
			$("#kwds").append("<div id=\"ch\" class=\"col-xs-5\">");
			if(typeof p.tests[curTest].kwds != 'undefined'){
				var kwds = p.tests[curTest].kwds;
				for(var i = 0; i < kwds.length; ++i){
					if(i%2 == 0){
						$("#kwds #en").append("<textarea class=\"form-control\"> " + kwds[i] + "</textarea>");
					}else{
						$("#kwds #ch").append("<textarea class=\"form-control\"> " + kwds[i] + "</textarea>");						
					}
				}
			}
			answell.append("<button type=\"button\" id=\"pluskwdbtn\" class=\"btn btn-info\">");
			answell.children().last()
			.on('click',function(){
				$("#kwds #en").append("<textarea class=\"form-control\"> </textarea>");	
				$("#kwds #ch").append("<textarea class=\"form-control\"> </textarea>");
			});
			answell.children().last().append("<span class=\"glyphicon glyphicon-plus\"></span>");
			
			answell.append("<button type=\"button\" id=\"minuskwdbtn\" class=\"btn btn-info\">");
			answell.children().last()
			.on('click',function(){
				$("#kwds #en").children().last().remove();	
				$("#kwds #ch").children().last().remove();
			});
			answell.children().last().append("<span class=\"glyphicon glyphicon-minus\"></span>");
			
			//Watchword
			answell.append("<div class=\"row\">Watchword:</div>");
			answell.append("<div id=\"wwds\" class=\"row\">");
			$("#wwds").append("<div id=\"en\" class=\"col-xs-5\">");
			$("#wwds").append("<div id=\"ch\" class=\"col-xs-5\">");
			if(typeof p.tests[curTest].watchword != 'undefined'){
				var wwds = p.tests[curTest].watchword;
				for(var i = 0; i < wwds.length; ++i){
					if(i%2 != 0){
						$("#wwds #en").append("<textarea class=\"form-control\"> " + wwds[i] + "</textarea>");
					}else{
						$("#wwds #ch").append("<textarea class=\"form-control\"> " + wwds[i] + "</textarea>");						
					}
				}
			}
			answell.append("<button type=\"button\"  id=\"pluswdbtn\" class=\"btn btn-info\">");
			$("#pluswdbtn").append("<span class=\"glyphicon glyphicon-plus\"></span>");
			$("#pluswdbtn").on('click',function(){
				$("#wwds #en").append("<textarea class=\"form-control\"> </textarea>");	
				$("#wwds #ch").append("<textarea class=\"form-control\"> </textarea>");							
			});
			answell.append("<button type=\"button\" id=\"minuswdbtn\" class=\"btn btn-info\">");
			answell.children().last()
			.on('click',function(){
				$("#wwds #en").children().last().remove();	
				$("#wwds #ch").children().last().remove();
			});
			answell.children().last().append("<span class=\"glyphicon glyphicon-minus\"></span>");
			
			
			//Tips.
			answell.append("<div class=\"row\">Tips:</div>");
			answell.append("<div id=\"tipsr\" class=\"row\">");
			$("#tipsr").append("<div id=\"tipsc\" class=\"col-xs-12\">");
			if(typeof p.tests[curTest].tips != 'undefined'){
				$("#tipsc").append("<textarea class=\"form-control\" >"+ p.tests[curTest].tips+"</textarea>");
			}else{
				$("#tipsc").append("<textarea class=\"form-control\" ></textarea>");
			}
		}
	}
	
	//Display tests.
	function showTest4View(){
		if(curTest > -1 && curTest < total){
			console.log('cur: ' + curTest);
			$('#qh').children().last().remove();
			$('#quescol').html('');
			$('#optcol').html('');
			$('#answell').html('');
			$('#answell').addClass('hidden');
			$('#chekedit').prop('checked',false);
			$('label[for="chekedit"]').text('Edit');
			var curSN = curTest + 1;
			//Pic
			$('#qh').append("<label>Item " + curSN + " of "+ total +"</label>");
			if(typeof p.tests[curTest].pic != 'undefined'){
				$('#quescol').append("<div class=\"thumbnail\" id=\"qthb\"><img src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[curTest].pic+ "\"/></div>")
			}
			//Question
			if(typeof p.tests[curTest].question != "undefined"){
				$('#quescol').append("<div class=\"caption\" id=\"ques\"><h4>" + p.tests[curTest].question[0] + "</h4>");
			}else{
				$('#quescol').append("<div class=\"caption\" id=\"ques\"><h4>" 
						+ p.tests[curTest].question[0] +"</h4></div>")
			}
			
			var opts = p.tests[curTest].options;
			for(var i = 0; i < opts.length; ++i){
				var opt = opts[i];
				var id = "opt" + i;
				if(typeof p.tests[curTest].taking != 'undefined'){
					if(p.tests[curTest].taking.stuans == opt.charAt(0)){
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
						p.tests[curTest].taking = {"stuans":$(this).parent().text().charAt(0)}
						window.localStorage.setItem('tests',JSON.stringify(p));						
				});
			}
		}
	}
	
	showTest4View();
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
<form:form id="myform" method="POST" action="${pageContext.request.contextPath}/submitedit"> 
<div class="row">
<div class="col-sm-8">
<!-- MARK -->
<input id="chekedit" type="checkbox" style="margin-right:1px;">
<label for="chekedit">Edit</label>
</div>
<div class="col-sm-4">
</div>
</div>
<div class="row">
<div class="col-sm-8">
<div id="qh"></div>
</div>
<div style="text-align:right" class="col-sm-4" id="delnewdiv">
<button id="delbtn" type="button">Delete</button>
<button id="newbtn" type="button">New</button>
</div>
</div>
<hr>
<div class="row">
<div class="col-sm-8" id="quescol">

</div>

</div>
<div class="row">
<div class="col-sm-4" id="optcol">
<!-- OPTIONS -->
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
<div class="col-sm-8" id="prvnxtrvwdiv">
<!-- prev,next,review -->
<button type="button" id="prvbtn">Prev</button>
<button type="button" id="nxtbtn">Next</button>
<button type="button" id="rvwbtn">Review</button>
</div>
<div style="text-align:right" class="col-sm-4" id="sbtdiv">
<!-- pause,end exam -->
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