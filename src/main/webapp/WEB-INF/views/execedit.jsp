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

</style>
<script type="text/javascript">
//$(document).on("contextmenu", function (event) { event.preventDefault(); });
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
			ToggleTestApperance();
		}
	});	
	
	//Prev test.
	$('#prvbtn').on('click', function (e) {
		if(curTest-1 >= 0){
			curTest -= 1;
			ToggleTestApperance();
		}
	});
	
	
	//TimeOut End test.
	$('#endtestbtn').on('click', function (e) {
		curTest -= 1;
		ToggleTestApperance();
		window.location.replace("${pageContext.request.contextPath}/index");
	});
	
	//Review Btn.
	$('#rvwbtn').on('click', function (e) {
		$('#rvwModal').modal();		
	});
	
	//Ans <p> in Review Modal.
	$('#rvwModal').on('hide.bs.modal', function (e) {
		curTest = parseInt(window.localStorage.getItem('modelsel'));
		ToggleTestApperance();
	});	
	
	//Mark checkbox.
	$('#chekedit').on('click', function (e) {
		p.tests[curTest].dirty = $(this).prop('checked');
		ToggleTestApperance();
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
	function ToggleTestApperance(){
		if(p.tests[curTest].dirty == true){
			showTest4Edit();
		}else{
			showTest4View();
		}
	}
	//Display tests.
	function showTest4Edit(){
		if(curTest > -1 && curTest < total){
			$('#testrootpanel #qh').children().last().remove();
			$('#testrootpanel #quescol').html('');
			$('#testrootpanel #optcol').html('');
			$('#testrootpanel #ansrow #anscol #answell').html('');
			$('#testrootpanel #ansrow #anscol #answell').removeClass('hidden');
			$('#chekmark').prop('checked',false);
			if(p.tests[curTest].hasOwnProperty('marked')
				&& typeof p.tests[curTest].marked != 'undefined'){
				$('#chekmark').prop('checked',p.tests[curTest].marked);
			}
			var curSN = curTest + 1;
			$('#testrootpanel #qh').append("<label>Item " + curSN + " of "+ total +"</label>");
			if(typeof p.tests[curTest].pic != 'undefined'){
				$('#testrootpanel #quescol').append("<div class=\"thumbnail\" id=\"qthb\"><img src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[curTest].pic+ "\"/></div>");
				$('#testrootpanel #quescol').append("<div class=\"caption\" id=\"ques\"><h4>" + p.tests[curTest].question[0] + "</h4>");
			}else{
				$('#testrootpanel #quescol').append("<div class=\"thumbnail\" id=\"qthb\"><label for=\"pic_input\"><img src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[curTest].pic+ "\"/></label><input id=\"pic_input\" type=\"file\" name=\"file\"/></div>");	
				$('#testrootpanel #quescol').append("<textarea id=\"ques\" class=\"form-control\" disabled>" 
						+ p.tests[curTest].question[0] +"</textarea>")
			}
			//Options.
			var opts = p.tests[curTest].options;
			for(var i = 0; i < opts.length; ++i){
				var opt = opts[i];
				var id = "opt" + i;
				$('#testrootpanel #optcol').append("<input id=\"" + id + "\"type=\"text\" name=\"opt\" placeholder=\"" + opt + "\"></input><br>");
			}
			
			//Answer area
			$("#ansrow #anscol #answell").append("<div class=\"row\">Answer:</div>");
			$("#ansrow #anscol #answell").append("<div id=\"ansr\" class=\"row\">");
			$("#ansrow #anscol #answell #ansr").append("<div id=\"ansc\" class=\"col-xs-2\">");
			if(typeof p.tests[curTest].answers != 'undefined'){
				$("#ansrow #anscol #answell #ansr #ansc").append("<input type=\"text\" class=\"form-control\" placeholder=\""+ p.tests[curTest].answers[0] + "\"></input>");
			}else{
				$("#ansrow #anscol #answell #ansr #ansc").append("<input type=\"text\" class=\"form-control\"></input>");
			}
			
			
			//Keyword
			$("#answell").append("<div class=\"row\">Keyword:</div>");
			$("#answell").append("<div id=\"kwds\" class=\"row\">");
			$("#kwds").append("<div id=\"en\" class=\"col-xs-5\">");
			$("#kwds").append("<div id=\"ch\" class=\"col-xs-5\">");
			if(typeof p.tests[curTest].kwds != 'undefined'){
				var kwds = p.tests[curTest].kwds;
				for(var i = 0; i < kwds.length; ++i){
					if(i%2 == 0){
						$("#ansrow #anscol #answell #kwds #en").append("<textarea class=\"form-control\"> " + kwds[i] + "</textarea>");
					}else{
						$("#ansrow #anscol #answell #kwds #ch").append("<textarea class=\"form-control\"> " + kwds[i] + "</textarea>");						
					}
				}
			}
			$("#answell").append("<button type=\"button\" id=\"pluskwdbtn\" class=\"btn btn-info\">");
			$('#answell').children().last()
			.on('click',function(){
				$("#ansrow #anscol #answell #kwds #en").append("<textarea class=\"form-control\"> </textarea>");	
				$("#ansrow #anscol #answell #kwds #ch").append("<textarea class=\"form-control\"> </textarea>");
			});
			$('#answell').children().last().append("<span class=\"glyphicon glyphicon-plus\"></span>");
			
			//Watchword
			$("#ansrow #anscol #answell").append("<div class=\"row\">Watchword:</div>");
			$("#ansrow #anscol #answell").append("<div id=\"wwds\" class=\"row\">");
			$("#ansrow #anscol #answell #wwds").append("<div id=\"en\" class=\"col-xs-5\">");
			$("#ansrow #anscol #answell #wwds").append("<div id=\"ch\" class=\"col-xs-5\">");
			if(typeof p.tests[curTest].watchword != 'undefined'){
				var wwds = p.tests[curTest].watchword;
				for(var i = 0; i < wwds.length; ++i){
					if(i%2 != 0){
						$("#ansrow #anscol #answell #wwds #en").append("<textarea class=\"form-control\"> " + wwds[i] + "</textarea>");
					}else{
						$("#ansrow #anscol #answell #wwds #ch").append("<textarea class=\"form-control\"> " + wwds[i] + "</textarea>");						
					}
				}
			}
			$("#ansrow #anscol #answell").append("<button type=\"button\"  id=\"pluswdbtn\" class=\"btn btn-info\">");
			$("#ansrow #anscol #answell #pluswdbtn").append("<span class=\"glyphicon glyphicon-plus\"></span>");
			$("#ansrow #anscol #answell #pluswdbtn").on('click',function(){
				$("#ansrow #anscol #answell #wwds #en").append("<textarea class=\"form-control\"> </textarea>");	
				$("#ansrow #anscol #answell #wwds #ch").append("<textarea class=\"form-control\"> </textarea>");							
			});
			
			
			//Tips.
			$("#ansrow #anscol #answell").append("<div class=\"row\">Tips:</div>");
			$("#ansrow #anscol #answell").append("<div id=\"tipsr\" class=\"row\">");
			$("#ansrow #anscol #answell #tipsr").append("<div id=\"tipsc\" class=\"col-xs-12\">");
			if(typeof p.tests[curTest].tips != 'undefined'){
				$("#ansrow #anscol #answell #tipsr #tipsc").append("<textarea class=\"form-control\" >"+ p.tests[curTest].tips+"</textarea>");
			}else{
				$("#ansrow #anscol #answell #tipsr #tipsc").append("<textarea class=\"form-control\" ></textarea>");
			}
		}
	}
	
	//Display tests.
	function showTest4View(){
		if(curTest > -1 && curTest < total){
			$('#testrootpanel #qh').children().last().remove();
			$('#testrootpanel #quescol').html('');
			$('#testrootpanel #optcol').html('');
			$('#testrootpanel #ansrow #anscol #answell').html('');
			$('#ansrow #anscol #answell').addClass('hidden');
			$('#chekedit').prop('checked',false);
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
<h4><input id="chekedit" type="checkbox" style="margin-right:10px;">Edit</h4>
</div>
<div class="col-sm-4">
</div>
</div>
<div class="row">
<div class="col-sm-8">
<div id="qh"></div>
</div>
<div style="text-align:right" class="col-sm-4">
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
<div class="col-sm-8">
<!-- prev,next,review -->
<button type="button" id="prvbtn">Prev</button>
<button type="button" id="nxtbtn">Next</button>
<button type="button" id="rvwbtn">Review</button>
</div>
<div style="text-align:right" class="col-sm-4">
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