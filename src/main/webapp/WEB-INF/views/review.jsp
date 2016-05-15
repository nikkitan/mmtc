<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=5"><!-- IE fix -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.highlight.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/d3/d3.min.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">

<style type="text/css">
.highlight{
	background-color: #FFFF88;
}
.chart {
  background: #b0e0f8;
  margin: 5px;
}
.chart rect {
  stroke: white;
  fill: steelblue;
}

.chart text.name {
  fill: black;
}

.chart text.score {
  fill: white;
}

.chart rect:hover {
  fill: cyan;
}

h4#fail{
	color:red;
}

h4#pass{
	color:black;
}

</style>
<script>
"use strict";
var data = ${scores};
var cat = ['Your Score','Required Score'];
var suite = "${suite}";
var user = "${participant}";
var starttime = ${starttime};
var endtime = ${endtime};
function sec2hms(t){
	var dur = Date.parse(t) - Date.parse(new Date());
	var seconds = Math.floor( (dur/1000) % 60 );
	var minutes = Math.floor( (dur/1000/60) % 60 );
	var hours = Math.floor( (dur/(1000*60*60)) % 24 );
	var days = Math.floor( dur/(1000*60*60*24) );
	return {
	  'dur': dur,
	  'days': days,
	  'housr': hours,
	  'minutes': minutes,
	  'seconds': seconds
	};
}
function renderChart(dataX,dataY,w,h){
	var chart = d3.select("#chartdiv")
	.append('svg')
	.attr('class','chart')
	.attr('width',w)
	.attr('height',h);
	var bar_right_padding = 95;
	var bar_left_padding = 150;
	var left_padding = 150;
	var bar_height = 20;
	var gap = 5;
	
	var x = d3.scale.linear()
			.domain([0,d3.max(dataX)])
			.range([0,w-200]);
	var y = d3.scale.ordinal()
			.domain([dataX[0],dataX[1]])
			.range([150,50]);
	chart.selectAll("rect")
	   .data([data[0],data[1]])
	   .enter().append("rect")
	   .attr("x", bar_left_padding)
	   .attr("y", y)
	   .attr("width", x)
	   .attr("height", bar_height);
	chart.selectAll("text.score")
	  .data([data[0],data[1]])
	  .enter().append("text")
	  .attr("x", function(d) { return x(d) + left_padding; })
	  .attr("y", function(d){ return y(d) + y.rangeBand()/2+10; } )
	  .attr("dx", -5)
	  .attr("dy", ".26em")
	  .attr("text-anchor", "end")
	  .attr('class', 'score')
	  .text(String);

	chart.selectAll("text.name")
	  .data(dataY)
	  .enter().append("text")
	  .attr("x", left_padding / 2)
	  .attr("y", function(d){ return y(d) + y.rangeBand()/2+10; } )
	  .attr("dy", ".20em")
	  .attr("text-anchor", "middle")
	  .attr('class', 'name')
	  .text(String);
	
	chart.selectAll("line")
	  .data(x.ticks(10))
	  .enter().append("line")
	  .attr("x1", function(d) { return x(d) + left_padding; })
	  .attr("x2", function(d) { return x(d) + left_padding; })
	  .attr("y1", 20)
	  .attr("y2", h-20)
	  .attr("stroke","silver");

	  
	chart.selectAll(".rule")
	  .data(x.ticks(10))
	  .enter().append("text")
	  .attr("class", "rule")
	  .attr("x", function(d) { return x(d) + 150; })
	  .attr("y", 15)
	  //.attr("dy", -6)
	  .attr("text-anchor", "middle")
	  .attr("font-size", 10)
	  .attr("stroke","black")
	  .text(String);	
}
$(window).resize(function(){
	var h = $('#chartdiv').innerHeight();
	console.log(h);
	$('#chartdiv').html('');
	renderChart(data,cat,$('#chartdiv').innerWidth(),200);
})
$(document).ready(function() {
	renderChart(data,cat,$('#chartdiv').innerWidth(),200);
	var grade = '${grade}';
	if(grade == 'Fail'
		|| grade == 'FAIL'){
		$('#gradecol').append('<h4 id=\'fail\'>'+grade + '</h4>');
	}else if(grade == 'Pass'
			|| grade == 'PASS'){
		$('#gradecol').append('<h4 id=\'pass\'>'+grade + '</h4>');		
	}
	
	//View Answers.
	$('#vwansbtn').on('click', function (e) {
		var href = "${pageContext.request.contextPath}/execans?su="+ suite
				+ "&u="+user+"&st="+starttime+"&et="+endtime;
		$(this).attr("href",href);
	})
	
	
	//Insert start time, end time.
	$('#st').html(new Date(starttime));
	$('#et').html(new Date(endtime));
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

<div class="container-fluid bg-3">
<h2><span class="label label-default">Examination Score Report:</span></h2>
<div class="row">
<div class="col-sm-2">
</div>
<div class="col-sm-8">
<div class="container-fluid bg-3">
<!-- Test Suite -->
<div class="row">
<div class="col-sm-2">
<label>Test Suite:</label>
</div>
<div class="col-sm-4">
<h4>${suite}</h4>
</div>
</div>
<!-- Candidate -->
<div class="row">
<div class="col-sm-2">
<label>Candidate:</label>
</div>
<div class="col-sm-4">
<h4>${participant}</h4>
</div>
</div>
<!-- Date,Time -->
<div class="row">
<div class="col-sm-2">
<label>Start Time:</label>
</div>
<div class="col-sm-4" id="stcol">
<h4 id="st"></h4>
</div>
<div class="col-sm-2">
<label>End Time:</label>
</div>
<div class="col-sm-4" id="etcol">
<h4 id="et"></h4>
</div>
</div>
<!-- Exam Number, Elapsed Time -->
<div class="row">
<div class="col-sm-2">
<label>Elapsed Time:</label>
</div>
<div class="col-sm-4">
<h4>${elaptime}</h4>
</div>
</div>
<!-- Bar chart -->
<div class="row">
<div class="col-sm-12" id="chartcol">
<label>Chart:</label>
<div id="chartdiv"></div>
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
<div class="col-sm-2" id="gradecol">
</div>
</div>

<!-- View Answer -->
<hr>
<div class="row">
<div class="col-sm-4">
<a id="vwansbtn" role="button" class="btn btn-primary btn-lg">View Answers</a>
<button id="exitbtn" type="button" class="btn btn-primary btn-lg">Exit</button>

</div>
</div>
</div>
</div>

</div>
</div>
<!-- Footer -->
<footer class="container-fluid bg-4 text-center">
  <p>@2016 Mendez Master Training Center. All rights reserved.</p> 
</footer>
</body>
</html>