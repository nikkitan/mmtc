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

</style>
<script type="text/javascript">
$(document).on("contextmenu", function (event) { event.preventDefault(); });
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
	
	//Ans <p> in Review Modal.
	$('#rvwModal').on('hide.bs.modal', function (e) {
		curTest = parseInt(window.localStorage.getItem('modelsel'));
		showTest();
	});	
	
	//Mark checkbox.
	$('#chekmark').on('click', function (e) {
		p.tests[curTest].marked = $(this).prop('dirty');
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
		var review = "<div id=\"rvwmodalcol\" class=\"container-fluid col-md-12\"><div class=\"row\">";
		var listPrefix = "<div class=\"list-group\">";
		var itemPrefix = "<p ";
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
			review += "id=\"";
			review += i;
			review += "\" onclick='window.localStorage.setItem(\"modelsel\","+i+"); $(\"#rvwModal\").modal(\"hide\");' ";

			
			if(p.tests[i].hasOwnProperty("taking")
					&& typeof p.tests[i].taking != 'undefined'
					&& typeof p.tests[i].taking.stuAns != 'undefined'){
				if(p.tests[i].taking.stuAns != p.tests[i].answers[0]){
					review += "class=\"list-group-item wrongans\">";
					console.log("WRONG ans: " + review);

					review += i+1;
					review += ":";
					review += p.tests[i].taking.stuAns;				
				}else{
					console.log("GOOD ans: " + p.tests[i].taking.stuAns);

					review += "class=\"list-group-item correctans\">";
					review += i+1;
					review += ":";
					review += p.tests[i].taking.stuAns;
				}
			}else{
				console.log("NO ans: ");

				review += "class=\"list-group-item wrongans\">";
				review += i+1;
				review += ":";				
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
	  var button = $(event.relatedTarget);
	  var recipient = button.data('whatever');
	  var modal = $(this);
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
	//En/Disable all text inputs.
	function ToggleTextInputs(){
		
	}
	//Display tests.
	function showTest(){
		if(curTest > -1 && curTest < total){
			$('#testrootpanel #qh').children().last().remove();
			$('#testrootpanel #quescol').html('');
			$('#testrootpanel #optcol').html('');
			$('#testrootpanel #ansrow #anscol #answell').html('');
			$('#testrootpanel #ansbtn').html('Show Answer');
			$('#chekmark').prop('checked',false);
			if(p.tests[curTest].hasOwnProperty('marked')
				&& typeof p.tests[curTest].marked != 'undefined'){
				$('#chekmark').prop('checked',p.tests[curTest].marked);
			}
			var curSN = curTest + 1;
			$('#testrootpanel #qh').append("<label>Item " + curSN + " of "+ total +"</label>");
			if(typeof p.tests[curTest].pic != 'undefined'){
				$('#testrootpanel #quescol').append("<div class=\"thumbnail\" id=\"qthb\"><img src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[curTest].pic+ "\"/></div>")
				$('#testrootpanel #quescol').append("<div class=\"caption\" id=\"ques\"><h4>" + p.tests[curTest].question[0] + "</h4>");
			}else{
				$('#testrootpanel #quescol').append("Question:<textarea id=\"ques\" class=\"form-control\" disabled>" 
						+ p.tests[curTest].question[0] +"</textarea>")
			}
			var opts = p.tests[curTest].options;
			$('#testrootpanel #optcol').append("Options:");
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
			
			//Answer area
			if(typeof p.tests[curTest].answers != 'undefined'){
				$("#ansrow #anscol #answell").append("Answer:<textarea class=\"form-control\" disabled>"+ p.tests[curTest].answers[0] + "</textarea><br>");
			}else{
				$("#ansrow #anscol #answell").append("Answer:<textarea class=\"form-control\" disabled></textarea><br>");				
			}

			if(typeof p.tests[curTest].kwds != 'undefined'){
				var kwds = p.tests[curTest].kwds;
				$("#ansrow #anscol #answell").append("Keyword: <textarea class=\"form-control\ disabled> " + kwds + "</textarea><br>");
				for(var i = 0; i < kwds.length; i+=2){
					$('#testrootpanel #quescol #ques').highlight(kwds[i]);
					$('#testrootpanel #optcol .radio .radiobtnopt').highlight(kwds[i]);					
				}
			}else{
				$("#ansrow #anscol #answell").append("Keyword: <textarea class=\"form-control\" disabled></textarea><br>");				
			}
			
			
			if(typeof p.tests[curTest].watchword != 'undefined'){
				$("#ansrow #anscol #answell").append("Watchword:<textarea class=\"form-control\" disabled>"+ p.tests[curTest].watchword + "</textarea><br>");
			}else{
				$("#ansrow #anscol #answell").append("Watchword:<textarea class=\"form-control\" disabled></textarea><br>");				
			}
			
			if(typeof p.tests[curTest].tips != 'undefined'){
				$("#ansrow #anscol #answell").append("Tips:<textarea class=\"form-control\" disabled>"+ p.tests[curTest].tips+"</textarea>");
			}else{
				$("#ansrow #anscol #answell").append("Tips:<textarea class=\"form-control\" disabled></textarea>");				
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
<h4><input id="chekmark" type="checkbox" style="margin-right:10px;">Edit</h4>
</div>
<div class="col-sm-4">
</div>
</div>
<div class="row">
<div class="col-sm-8">
<div id="qh"></div>
</div>
<div style="text-align:right" class="col-sm-4">
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
<div class="well" id="answell">
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