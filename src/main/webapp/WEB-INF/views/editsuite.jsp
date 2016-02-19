<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>MMTC</title>
</head>
<body>
<form:form method="POST" action="listtest" commandName="ts" >  
<table><!-- ROOT -->
<tr>
<td style="width:70%;">
<table>  
    <tbody><tr>  
    <td>  
        <ul>  
            <form:select path="name" items="${suites}">  
        </form:select></ul>  
    </td>  
    </tr>  
    <tr>  
        <td>  
            <input type="submit" value="Submit">  
        </td>  
    </tr>  
</tbody></table>    
</form:form>
</td>

<td style="vertical-align:top;">
<nav>
<a href="${pageContext.request.contextPath}/home">Home</a> |
<a href="${pageContext.request.contextPath}/logout">LogOut</a>
</nav>
</td>
</tr>
</table><!-- ROOT -->
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>
</html>