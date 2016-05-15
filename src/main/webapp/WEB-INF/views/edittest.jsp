<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=5"><!-- IE fix -->
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style3.css">

<style type="text/css">
caption {
  text-align: left;
  color: Black;
  font-weight: bold;
  text-transform: uppercase;
  padding: 5px;
}
th,
td {
  padding: 10px 10px;
  background:#f5f5f5;
}
tbody td:nth-child(1){
	width:30%;
}

table tbody tr:{
  background: silver;
}
</style>
<title>MMTC</title>
</head>
<body>
<form:form method="POST" action="${id}" commandName="ts" enctype="multipart/form-data"> 
<input type="hidden" value="${id}" name="id" style="width:0; height:0; border:0; background-color:inherit; overflow:hidden;"/> 
<table> 
<caption>Editing Test:</caption>
    <tbody>
    <tr>  
    <td align="left">
     Test Suite:
    </td>
    <td>  
		${ste}
    </td>  
    </tr>
    <tr> 
    <td align="left">
     Test #:
    </td> 
    <td>  
		${sn}		
    </td>  
    </tr>
    <tr> 
    <td align="left">
    	Question:
    </td> 
    <td>  
		${q}	
    </td>  
    </tr> 
    <tr>     
    <td align="left">
     Answer:
    </td>    
    <td>  
    	<ul>
    		<c:forEach var="a" items="${ans}">
    			<li>${a}</li>
    		</c:forEach>
    	</ul>    
    </td>  
    </tr>
    <tr>
    <td align="left">
     Options:
    </td> 
    <td>  
    	<ul>
    		<c:forEach var="o" items="${opt}">
    			<li>${o}</li>
    		</c:forEach>
    	</ul>
    </td>  
    </tr>
    <tr>
    <td align="left">
     Keywords:
    </td> 
    <td>  
    	<ul>
    		<c:forEach var="k" items="${kwd}">
    			<c:choose>
    				<c:when test="${not empty k}">
    					<li>${k}</li>
    				</c:when>
    			</c:choose>
    		</c:forEach>
    	</ul>
    </td>  
    </tr>
    <tr>
    <td align="left">
     Picture:
    </td>  
    <td>
    	<label for="pic_input">
    		<img src="<%=session.getAttribute("uploadFile")%>"/>
    	</label>
    	<input id="pic_input" type="file" name="file"/>
    </td>  
    </tr>  
    <tr>  
        <td colspan=2 align="right">  
            <input type="submit" value="Submit"/>  
        </td>  
    </tr>  
</tbody></table> 
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />   
</form:form>
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>    
</body>
</html>