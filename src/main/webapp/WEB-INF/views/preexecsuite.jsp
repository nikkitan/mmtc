<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="mmtc" uri="/WEB-INF/custom.tld" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
table.root {
	width: 100%;
}
caption.root {
  text-align: left;
  color: Black;
  font-weight: bold;
  text-transform: uppercase;
  padding: 5px;
  width:100%;
}
th.root,
td.root {
  padding: 10px 10px;
}
tbody.root td:nth-child(1){
	width:70%;
}
</style>
<title>MMTC</title>
</head>
<body>
<!--<mmtc:jsonparser></mmtc:jsonparser>-->
<table class="root"><!-- ROOT TABLE -->
<tr style="width:100%;">
<td style="width:80%;">
<form:form method="POST" action="${s}" commandName="ts" enctype="multipart/form-data"> 
<table class="root"> 
<caption class="root">Test Suite ${su} Options</caption>
<tr style="width:100%;">
<td style="width:50%;">
<form:radiobutton path="isQuestionRandom" value="1"/> Randomize Questions
</td>
</tr>
<tr style="width:100%;">
<td style="width:50%;">
<form:radiobutton path="isChoiceRandom" value="1"/> Randomize Choices 
</td>
</tr>
<tr style="width:100%;">
<td style="width:50%;text-align:right;">
<input type="submit" value="Submit"/>  
</td>
</tr>
</table>
</form:form>
<td style="vertical-align:top;">
<nav>
<a href="${pageContext.request.contextPath}/home">Home</a> |
<a href="${pageContext.request.contextPath}/login?logout">LogOut</a>
</nav>
</td>
</tr>
</table><!-- ROOT TABLE -->
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>

</html>