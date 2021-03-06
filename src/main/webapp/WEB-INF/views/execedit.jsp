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
<script src="${pageContext.request.contextPath}/resources/js/cjst.js" type="text/javascript"></script>
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

textarea[name='ques']{
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
/*#delbtn.recover{
	margin-right:6px;
	color:#AA0000;
}*/
div.row.disabled{
	background-color: #A9A9A9;
}
div.row.disabled{
	background-color: #A9A9A9;
}
#testrootpanel.container-fluid.bg-3.disabled{
	background-color: #808080;	
}

#delpicbtn {
    position: absolute;
    left: 10px;
    top: 0px;
}

#ques>h3{
	font-weight:500;
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
	var debug = JSON.parse("${debug}");
	<% String origTest=(String)request.getAttribute("tests");%>
	var oo = '<%=origTest%>';
	var p = $.parseJSON(oo);
	window.sessionStorage.setItem('tests',oo);	
	
	//Next test.
	var testItor = 0;
	$('#nxtbtn').on('click', function (e) {
		if(testItor + 1 < p.tests.length){
			testItor += 1;
			showTest4View();
		}
	});	
	
	//Prev test.
	$('#prvbtn').on('click', function (e) {
		if(testItor-1 >= 0){
			testItor -= 1;
			showTest4View();
		}
	});
	
	
	//TimeOut End test.
	$('#endtestbtn').on('click', function (e) {
		testItor -= 1;
		showTest4View();
		window.location.replace("${pageContext.request.contextPath}/index");
	});
	
	//Review Btn.
	$('#rvwbtn').on('click', function (e) {
		$('#rvwModal').modal();		
	});
	
	//Delete Test Btn.
	$('#delbtn').on('click', function (e) {
		if(p.tests[testItor].hasOwnProperty('del')
				&& typeof p.tests[testItor].del != 'undefined'){
			if(p.tests[testItor].del == false){
				p.tests[testItor].del = true;
				$(this).text('Recover');
				$(this).addClass('recover');
				disableTestGUI();
			}else{
				p.tests[testItor].del = false;		
				$(this).text('Delete');
				$(this).removeClass('recover');
				enableTestGUI();
			}
		}else{
			console.log('[2_recover]');
			p.tests[testItor].del = true;
			$(this).text('Recover');
			$(this).addClass('recover');
			disableTestGUI();
		}
		window.sessionStorage.setItem('tests',JSON.stringify(p));
	});
		
	//New Test Btn.
	$('#newbtn').on('click', function (e) {
		p.tests.splice(testItor,0,{"dirty":true,"isnew":true,"serialNo":testItor+1});
		curMode = edit;
		showTest4Edit();
	});
		
	//Ans <p> in Review Modal.
	$('#rvwModal').on('hide.bs.modal', function (e) {
		testItor = parseInt(window.sessionStorage.getItem('modelsel'));
		showTest4View();
	});
	
	//Review Modal
	$('#rvwModal').on('show.bs.modal', function (event) {
	  var modal = $(this);
	  modal.find('.modal-title').html('Test Suite of ' + p.suite);
	  modal.find('.modal-body').html(genReviewTable());
	})
	
	//Edit checkbox.
	$('#chekedit').on('click', function (e) {
		p.tests[testItor].dirty = true;
		if(curMode == view){
			curMode = edit;
			if(p.tests[testItor].hasOwnProperty('pic')
				&& p.tests[testItor].pic != null){
				window.sessionStorage.setItem('_origpic'+testItor,p.tests[testItor].pic);
			}
			showTest4Edit();
		}else{
			//Save dirty data.
			saveTestFromGUI();
			//Prepare to render UI under view mode.
			curDom = $('#prvnxtrvwdiv');
			curDom.append(prvBtn);
			curDom.children().last().on('click', function (e) {
				if(testItor-1 >= 0){
					testItor -= 1;
					showTest4View();
				}
			});
			curDom.append(nxtBtn);
			curDom.children().last().on('click', function (e) {
				if(testItor + 1 < p.tests.length){
					testItor += 1;
					showTest4View();
				}
			});
			curDom.append(rvwBtn);
			curDom.children().last().on('click', function (e) {
				$('#rvwModal').modal();		
			});
			curDom = $('#delnewdiv');
			curDom.append(delBtn);
			curDom.children().last().on('click', function (e) {
				if(p.tests[testItor].hasOwnProperty('del')
						&& typeof p.tests[testItor].del != 'undefined'){
					if(p.tests[testItor].del == false){
						p.tests[testItor].del = true;
						$(this).text('Recover');
						$(this).addClass('recover');
						disableTestGUI();
					}else{
						p.tests[testItor].del = false;		
						$(this).text('Delete');
						$(this).removeClass('recover');
						enableTestGUI();
					}
				}else{
					p.tests[testItor].del = true;
					$(this).text('Recover');
					$(this).addClass('recover');
					disableTestGUI();
				}
				window.sessionStorage.setItem('tests',JSON.stringify(p));
			});
			curDom.append(newBtn);
			curDom.children().last().on('click', function (e) {
				p.tests.splice(testItor,0,{"dirty":true,"isnew":true,"serialNo":testItor});
				window.sessionStorage.setItem("tests",JSON.stringify(p));
				curMode = edit;
				showTest4Edit();
				
			});
			curDom = $('#sbtdiv');
			curDom.append("<input type=\"hidden\" name=\"testdata\" />" 
					      + "<input type=\"hidden\" name=\"${_csrf.parameterName}\" value=\"${_csrf.token}\"/>");
			curDom.append(sbtBtn).on('click', function (e) {
				p.user = "${pageContext.request.userPrincipal.name}";
				$('input[name="testdata"]').attr("value",JSON.stringify(p));
			});
			curMode = view;
			//Ajax upload.
			$.ajaxPrefilter(function (options, originalOptions, jqXHR) {
			  jqXHR.setRequestHeader('X-CSRF-Token', "${_csrf.token}");
			});
			var postParam = {"suite":p.suite,"test":JSON.stringify(p.tests[testItor])};
			var ip = debug == true?'localhost:8080/':'www.mmtctest.com/';
			var scheme = debug == true?'http://':'https://';
			var subdomain = debug == true? "mmtcexam/oneedit":"oneedit";
			var url = scheme + ip + subdomain;
			$.ajax({
			    url : url,
			    type: "POST",
			    data : postParam,
			    dataType: "json",
			    async:true,
			    success: function(data, textStatus, jqXHR)
			    {
			        var result =  data;
			        var index = result.test.serialNo - 1;
			        p.tests[index] = result.test;
					window.sessionStorage.removeItem("pic"+index,e.target.result);
			    },
			    error: function (jqXHR, textStatus, errorThrown)
			    {
			        console.log("[AJAX_fail]: " + errorThrown);	
			        
			    }
			});
			showTest4View();
		}
	});
	
	//Submit.
	$('#sbtbtn').on('click', function (e) {
		p.user = "${pageContext.request.userPrincipal.name}";
		$('input[name="testdata"]').attr("value",JSON.stringify(p));
		
	});
	
	
	function saveTestFromGUI(){
		var curTestObj = p.tests[testItor];
		if(curTestObj.dirty == true || curTestObj.isnew == true){
			if($('#pic_input').val() != null && $('#pic_input').val().length > 0){
				curTestObj.pic = $('#picholder').prop('src');
				curTestObj.newpic = true;
			}else{
				if(window.sessionStorage.getItem('_origpic'+testItor) != null){
					if(curTestObj.hasOwnProperty('delpic') == false
					|| curTestObj.delpic == false){
						curTestObj.pic = "${pageContext.request.contextPath}/resources/pic/" + window.sessionStorage.getItem('_origpic'+testItor);
					}
					window.sessionStorage.removeItem('_origpic'+testItor);
				}
			}
			var quesTrans;
			if(typeof curTestObj.question != 'undefined' 
				&& curTestObj.question.length == 2){
				//Preserve the second item.
				quesTrans=curTestObj.question[1].toString();//deep copy.
			}
			curTestObj.question = [];		
			var q = $('textarea[name="ques"]').val();
			if(typeof q != 'undefiend'){
				q = testItor+1 + '.' + q;
				curTestObj.question.push(q);
			}
			if(quesTrans != null && typeof quesTrans != 'undefined' && quesTrans.length > 0){
				curTestObj.question.push(quesTrans);
			}
			
			curTestObj.options = [];
			$('input[name=\"opt\"]').each(function(index,value){
				if(typeof value.value != 'undefined'){
					if(value.value.length > 0){
						if(value.value.charAt(1) != '.'){
							value.value = String.fromCharCode(index+65) + '.' + value.value;
						}
						curTestObj.options.push(value.value);
					}else{
						if(value.getAttribute('placeholder').length > 0
							&& value.getAttribute('placeholder') != ('Option ' + String.fromCharCode(index+65))){							
							curTestObj.options.push(value.getAttribute('placeholder'));
						}/*else{
							//overwrite though input is empty.
							curTestObj.options.push(String.fromCharCode(index+65) + '.' + value.value);
						}*/
					}
				}
			});
			curTestObj.answers = [];
			curDom = $('input[name="ans"]');
			if(typeof curDom.val() != 'undefined'){
				if(curDom.val().length > 0){
					curTestObj.answers.push(curDom.val().toUpperCase());
				}else{
					if(curDom.prop('placeholder').length>0){
						curTestObj.answers.push(curDom.prop('placeholder'));
					}else{
						curTestObj.answers.push(curDom.val());						
					}
				}
			}
			delete curTestObj.kwds;
			var engKwd = $('#kwden > input[name="kwd"]');
			var chKwd = $('#kwdch > input[name="kwd"]');
			for(var i = 0; i < engKwd.length; ++i){
				curTestObj.kwds = [];
				if(typeof engKwd[i] != 'undefined' && engKwd[i].value.length > 0){
					curTestObj.kwds.push(engKwd[i].value);
					if(typeof chKwd[i] != 'undefined' && chKwd[i].value.length > 0)
						curTestObj.kwds.push(cjst.traditionalToSimplified(chKwd[i].value));	
				}			
			}			
			delete curTestObj.watchword;
			var engWwd = $('#wwden > input[name="wwd"]');
			var chWwd = $('#wwdch > input[name="wwd"]');
			for(var i = 0; i < engWwd.length; ++i){
				curTestObj.watchword = [];
				if(typeof engWwd[i] != 'undefined' && engWwd[i].value.length > 0){
					curTestObj.watchword.push(engWwd[i].value);
					if(typeof chWwd[i] != 'undefined' && chWwd[i].value.length > 0)
						curTestObj.watchword.push(cjst.traditionalToSimplified(chWwd[i].value));	
				}
			}
			
			delete curTestObj.tips;
			var tipVal = $('textarea[name="tips"]').val()
			if(typeof tipVal != 'undefined' && tipVal.length > 0){
				curTestObj.tips = [];
				tipVal = cjst.traditionalToSimplified(tipVal);
				curTestObj.tips=tipVal.split('\n');
				
				//curTestObj.tips=$('textarea[name="tips"]').val()
				//console.log("[save]: "+curTestObj.tips);
			}
		}
		
		//we need to increment serial# by 1 for tests after new test.
		if(curTestObj.hasOwnProperty('isnew')
				&& curTestObj.isnew == true){
			var index = curTestObj.serialNo;
			var t;
			for(var i = index; i < p.tests.length; ++i){
				t = p.tests[i];
				t.serialNo += 1;
				t.question[0] = t.question[0].substring(t.question[0].indexOf('.'));
				t.question[0] = t.serialNo + t.question[0];
			}
		}
		//p.tests[testItor].tips = curTestObj.tips.toString().replace(/[\n\r]/g,'\\n');
		window.sessionStorage.setItem("tests",JSON.stringify(p));
	}
	
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
					&& p.tests[i].dirty != 'undefined'
					&& p.tests[i].dirty == true){
				review += 'E';
			}
			else if(p.tests[i].hasOwnProperty('del')
					&& p.tests[i].del != 'undefined'
					&& p.tests[i].del == true){
				review += 'D';
			}
			review += itemSuffix;
			review += divEndTag;//close item col1;
			review += listGroupItemCol2Prefix;
			if(p.tests[i].hasOwnProperty("taking")
					&& p.tests[i].taking != 'undefined'){
				review += itemPrefix;
				review += "\" onclick='window.sessionStorage.setItem(\"modelsel\","+i+"); $(\"#rvwModal\").modal(\"hide\");' ";
				review += ">";
				review += i+1;
				review += ":";
				review += p.tests[i].taking.stuAns;				
			}else{
				review += itemPrefix;
				review += "\" onclick='window.sessionStorage.setItem(\"modelsel\","+i+"); $(\"#rvwModal\").modal(\"hide\");' ";
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


	//Display tests.
	function showTest4Edit(){
		if(testItor > -1 && testItor < p.tests.length){
			$('#prvnxtrvwdiv').html('');
			$('#delnewdiv').html('');
			$('#sbtdiv').html('');
			$('#qh').children().last().remove();
			$('#quescol').html('');
			$('#piccol').html('');
			$('#optcol').html('');
			var answell = $('#answell');
			answell.html('');
			answell.removeClass('hidden');
			if(p.tests[testItor].hasOwnProperty('dirty')
				&& typeof p.tests[testItor].dirty != 'undefined'){
				$('#chekedit').prop('checked',p.tests[testItor].dirty);
				$('label[for="chekedit"]').text('Uncheck to finalize editing.');
			}
			var curSN = testItor + 1;
			$('#qh').append("<label>Item " + curSN + " of "+ p.tests.length +"</label>");
			if(p.tests[testItor].hasOwnProperty('pic')
				&& typeof p.tests[testItor].pic != 'undefined'
				&& p.tests[testItor].pic.length > 0
				&& p.tests[testItor].pic != 'null'){
				$('#piccol').append("<div><img id=\"picholder\" class=\"img-thumbnail img-responsive\" src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[testItor].pic+ "\"/>"
						+"<button type=\"button\" id=\"delpicbtn\" class=\"btn btn-info\"><span class=\"glyphicon glyphicon-remove\"></span></button></div>");
				$('#piccol').children().children()
				.last().on('click',function(){
					p.tests[testItor].pic = null;
					p.tests[testItor].delpic = true;
					$('#picholder').prop('src','deleted');
				});
						
				$('#piccol').append("<input id=\"pic_input\" type=\"file\" name=\"file\"/>");	
			}else{
				$('#piccol').append("<div><img id=\"picholder\" class=\"img-thumbnail img-responsive\" src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[testItor].pic+ "\"/>"
						+"<input id=\"pic_input\" type=\"file\" name=\"file\"/>");					
			}
			$('#pic_input').on('change',function(){
				var filePath = $(this).val();
				if(typeof FileReader != 'undefined'){
					var picholder = $('#picholder');
					var reader = new FileReader();
					reader.onload = function(e){
						picholder.prop('src',e.target.result);
						p.tests[testItor].pic=e.target.result;
						window.sessionStorage.setItem("pic"+testItor,e.target.result);
					}		
					reader.readAsDataURL($(this)[0].files[0]);
				}else{
					console.log("This browser doesn't support HTML5 FileReader.");
				}
			});
			if(typeof p.tests[testItor].question != 'undefined'){
				var dotIndex = p.tests[testItor].question[0].indexOf('.');
				$('#quescol').append("<textarea name=\"ques\" class=\"form-control\">" + p.tests[testItor].question[0].substring(dotIndex+1) + "</textarea>");
			}else{
				$('#quescol').append("<textarea name=\"ques\" class=\"form-control\" placeholder=\"Question\"></textarea>");				
			}
						
			//Options.
			if(p.tests[testItor].hasOwnProperty('dirty')
				&& p.tests[testItor].dirty == true){
				if(typeof p.tests[testItor].options != 'undefined'
					&& p.tests[testItor].options.length > 0){
					var opts = p.tests[testItor].options;
					var i = 0;
					for(; i < opts.length; ++i){
						var opt = opts[i];
						var id = "opt" + i;
						$('#optcol').append("<input id=\"" + id + "\"type=\"text\" name=\"opt\" placeholder=\"" + opt + "\"></input><br>");
					}
					//add empty box for if user wants to add options, but no more than 4 options.
					for(; i < 4; ++i){
						$('#optcol').append("<input name=\"opt\" type=\"text\" placeholder=\"Option "+String.fromCharCode(i+65)+"\">");						
					}
					
				}else{
					//Still need to provide option boxes even no options before edit.
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
			}
			
			//Answer area
			answell.append("<div class=\"row\">Answer:</div><div class=\"row\">");
			if(typeof p.tests[testItor].answers != 'undefined'){
				answell.children().last().append("<div class=\"col-xs-2\"><input type=\"text\" name=\"ans\" class=\"form-control\" placeholder=\""+ p.tests[testItor].answers[0] + "\"></input></div>");
			}else{
				answell.children().last().append("<div class=\"col-xs-2\"><input type=\"text\" name=\"ans\" class=\"form-control\"></input></div>");
			}
			
			
			//Keyword
			answell.append("<div class=\"row\">Keyword:</div><div id=\"kwds\" class=\"row\">");
			answell.children().last().append("<div id=\"kwden\" class=\"col-xs-5\">");
			answell.children().last().append("<div id=\"kwdch\" class=\"col-xs-5\">");
			if(typeof p.tests[testItor].kwds != 'undefined'){
				var kwds = p.tests[testItor].kwds;
				for(var i = 0; i < kwds.length; ++i){
					if(i%2 == 0){
						$("#kwden").append("<input type=\"text\" name=\"kwd\" class=\"form-control\" value=\"" + kwds[i] + "\"></input>");
					}else{
						$("#kwdch").append("<input type=\"text\" name=\"kwd\" class=\"form-control\" value=\"" + kwds[i] + "\"></input>");						
					}
				}
			}
			answell.append("<button type=\"button\" id=\"pluskwdbtn\" class=\"btn btn-info\">");
			answell.children().last()
			.on('click',function(){
				$("#kwden").append("<input type=\"text\" name=\"kwd\" class=\"form-control\"></input>");	
				$("#kwdch").append("<input type=\"text\" name=\"kwd\" class=\"form-control\"></input>");
			});
			answell.children().last().append("<span class=\"glyphicon glyphicon-plus\"></span>");
			
			answell.append("<button type=\"button\" id=\"minuskwdbtn\" class=\"btn btn-info\">");
			answell.children().last()
			.on('click',function(){
				$("#kwden").children().last().remove();	
				$("#kwdch").children().last().remove();
			});
			answell.children().last().append("<span class=\"glyphicon glyphicon-minus\"></span>");
			
			//Watchword
			answell.append("<div class=\"row\">Watchword:</div><div id=\"wwds\" class=\"row\">");
			answell.children().last().append("<div id=\"wwden\" class=\"col-xs-5\">");
			answell.children().last().append("<div id=\"wwdch\" class=\"col-xs-5\">");
			if(typeof p.tests[testItor].watchword != 'undefined'){
				var wwds = p.tests[testItor].watchword;
				for(var w = 0; w < wwds.length; ++w){
					if(w%2 == 0){
						$("#wwden").append("<input type=\"text\" name=\"wwd\" class=\"form-control\" value=\"" + wwds[w] + "\"></input>");
					}else{
						$("#wwdch").append("<input type=\"text\" name=\"wwd\" class=\"form-control\" value=\"" + wwds[w] + "\"></input>");						
					}
				}
			}
			answell.append("<button type=\"button\"  id=\"pluswdbtn\" class=\"btn btn-info\">");
			$("#pluswdbtn").append("<span class=\"glyphicon glyphicon-plus\"></span>");
			$("#pluswdbtn").on('click',function(){
				$("#wwden").append("<input type=\"text\" name=\"wwd\" class=\"form-control\"></input>");	
				$("#wwdch").append("<input type=\"text\" name=\"wwd\" class=\"form-control\"></input>");							
			});
			answell.append("<button type=\"button\" id=\"minuswdbtn\" class=\"btn btn-info\">");
			answell.children().last()
			.on('click',function(){
				$("#wwden").children().last().remove();	
				$("#wwdch").children().last().remove();
			});
			answell.children().last().append("<span class=\"glyphicon glyphicon-minus\"></span>");
			
			
			//Tips.
			answell.append("<div class=\"row\">Tips:</div><div class=\"row\">");
			if(typeof p.tests[testItor].tips != 'undefined'){
				var tp = p.tests[testItor].tips.join('\n');
				//var tp = p.tests[testItor].tips.toString();
				//tp = tp.replace(/\\\\/g,'\\');
				//tp = tp.replace(/\\\\n/g,String.fromCharCode(13, 10));
				answell.children().last().append("<div class=\"col-xs-12\"><textarea name=\"tips\" class=\"form-control\" >"+ tp+"</textarea></div>");
			}else{
				answell.children().last().append("<div class=\"col-xs-12\"><textarea name=\"tips\" class=\"form-control\" ></textarea></div>");
			}
		}
	}
	
	//Disable GUI.
	function disableTestGUI(){
		$('#testrootpanel').addClass('disabled');
		$('#ques').css('color','#D3D3D3');
		$('#chekedit').prop('disabled',true);
		$('input[name="optradio"]').prop('disabled',true);
	}
	//Enable GUI.
	function enableTestGUI(){
		$('#testrootpanel').removeClass('disabled');
		$('#ques').css('color','black');
		$('#chekedit').prop('disabled',false);
		$('input[name="optradio"]').prop('disabled',false);
	}
	//Display tests.
	function showTest4View(){
		if(testItor > -1 && testItor < p.tests.length){
			$('#qh').children().last().remove();
			$('#quescol').html('');
			$('#piccol').html('');
			$('#optcol').html('');			
			var answell = $('#answell');
			answell.html('');
			$('#chekedit').prop('checked',false);
			$('label[for="chekedit"]').text('Edit');
			var curSN = testItor + 1;
			//Pic
			$('#qh').append("<label>Item " + curSN + " of "+ p.tests.length +"</label>");
			if(p.tests[testItor].hasOwnProperty('pic') && p.tests[testItor].pic != 'undefined'){
				if(p.tests[testItor].hasOwnProperty('dirty') && p.tests[testItor].dirty == true){
					$('#piccol').append("<img id=\"picholder\" \"img-thumbnail img-responsive\"/>");	
					$('#picholder').prop('src',p.tests[testItor].pic);//window.sessionStorage.getItem('pic'+testItor));					
				}else{
					$('#piccol').append("<img \"img-thumbnail img-responsive\" src=\"${pageContext.request.contextPath}/resources/pic/" + p.tests[testItor].pic+ "\"/>");
				}
			}
			//Question
			if(typeof p.tests[testItor].question != "undefined"){
				$('#quescol').append("<div class=\"caption\" id=\"ques\"><h3>" + p.tests[testItor].question[0] + "</h3>");
			}else{
				$('#quescol').append("<div class=\"caption\" id=\"ques\"><h3></h3></div>")
			}
			
			if(p.tests[testItor].hasOwnProperty("options")
				&& typeof p.tests[testItor].options != 'undefined'){
				var opts = p.tests[testItor].options;
				for(var i = 0; i < opts.length; ++i){
					var opt = opts[i];
					var id = "opt" + i;
					if(typeof p.tests[testItor].taking != 'undefined'){
						if(p.tests[testItor].taking.stuAns == opt.charAt(0)){
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
							p.tests[testItor].taking = {"stuAns":$(this).parent().text().charAt(0)}
							window.sessionStorage.setItem('tests',JSON.stringify(p));						
					});
				}
			}else{
				/*var id = "opt" + i;
				$('#optcol').append("<div class=\"radio\"><label class=\"radiobtnopt\" for=\"" 
						+ id + "\"><input id=\"" + id + "\"type=\"radio\" name=\"optradio\"></label></div>");*/
				
			}
			
			//Answer area.
			answell.removeClass('hidden');
			if(typeof p.tests[testItor].answers != 'undefined'){
				answell.append("Answer:"+ p.tests[testItor].answers[0] + "<br>");
			}

			if(typeof p.tests[testItor].kwds != 'undefined'){
				var kwds = p.tests[testItor].kwds;
				var kwd;
				answell.append("Keyword: " + kwds + "<br>");
				for(var i = 0; i < kwds.length; i+=2){
					kwd = kwds[i].trim();
					$('#ques').highlight(kwd);
					$('#optcol .radio .radiobtnopt').highlight(kwd);	
					answell.highlight(kwd);

				}
			}
			
			
			if(typeof p.tests[testItor].watchword != 'undefined'){
				answell.append("Watchword:"+ p.tests[testItor].watchword + "<br>");
				var wwd = p.tests[testItor].watchword;
				var ww;
				for(var i = 0; i < wwd.length; i+=2){
					ww = wwd[i].trim();
					$('#ques').highlight(ww);
					$('#optcol .radio .radiobtnopt').highlight(ww);	
					answell.highlight(ww);


				}
			}
			
			if(typeof p.tests[testItor].tips != 'undefined'){
				//var tp = p.tests[testItor].tips.toString();
				var tp=p.tests[testItor].tips.join("<br>");
				//tp = tp.replace(/\\n/g,"<br>");
				answell.append("Tips:"+ tp);
			}
			
			
			if(p.tests[testItor].hasOwnProperty('del')
				&& typeof p.tests[testItor].del != 'undefined'){
				if(p.tests[testItor].del == true){
					$('#delbtn').text('Recover');
					$('#delbtn').addClass('recover');
					disableTestGUI();	
				}else{
					$('#delbtn').text('Delete');
					$('#delbtn').removeClass('recover');
					enableTestGUI();
				}
			}else{
				$('#delbtn').text('Delete');
				enableTestGUI();
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
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button id="endtestbtn" type="button" class="btn btn-default" data-dismiss="modal" >OK</button>
      </div>
    </div>
  </div>
</div>
<!-- Chinese Conversion Modal -->
<div class="modal fade" id="chModal" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button id="endtestbtn" type="button" class="btn btn-default" data-dismiss="modal" >OK</button>
      </div>
    </div>
  </div>
</div>

<form:form id="myform" method="POST" enctype="multipart/form-data" action="${pageContext.request.contextPath}/submitedit"> 
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
<div class="col-sm-3" id="piccol">
</div>
</div>
<div class="row">
<div class="col-sm-12 col-lg-12" id="quescol">

</div>

</div>
<div class="row">
<div class="col-sm-4 col-lg-10" id="optcol">
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
<input type="hidden" name="testdata" />
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