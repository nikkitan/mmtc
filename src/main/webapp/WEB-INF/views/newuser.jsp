<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page session="false"%>
<!DOCTYPE html>
<html>
<head>
<!-- <meta http-equiv="Content-Type" content="application/javascript; charset=UTF-8" />
<title>Register yourself</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript"> 
$(document).ready(function(){

	$(".btn-slide").click(function(){
		$("#panel").slideToggle("slow");
		$(this).toggleClass("active"); return false;
	});
	
	 
});
</script>-->

<style>
.error {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	color: #a94442;
	background-color: #f2dede;
	border-color: #ebccd1;
}

.msg {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	color: #31708f;
	background-color: #d9edf7;
	border-color: #bce8f1;
}

#login-box {
	width: 300px;
	padding: 20px;
	margin: 100px auto;
	background: #fff;
	-webkit-border-radius: 2px;
	-moz-border-radius: 2px;
	border: 1px solid #000;
}
</style>
</head>
<body>

<h1>Registration Form</h1>

<table><!-- ROOT -->
<tr>
<td style="width:70%;">
<form:form method="POST" action="adduser" commandName="us" >  
<table>  
    <tbody>
    <tr>  
    <td>  
        User Name:
    </td>  
    <td>
    	<form:input path="username" />
    </td>
    </tr>
    <tr>  
    <td>  
        Password:
    </td>  
    <td>
    	<form:password path="password" />
    </td> 
    </tr> 
    <tr>  
    <td>  
        Email:
    </td>  
    <td>
    	<form:input path="email" />
    </td> 
    </tr>
    <tr>  
    <td>  
        Email Password:
    </td>  
    <td>
    	<form:password path="emailpw" />
    </td> 
    </tr>  
    <tr>  
        <td>  
            <input type="submit" value="Register">  
        </td>  
    </tr>  
	</tbody>
</table>    
</form:form>
</td>

<td style="vertical-align:top;">
<nav>
<a href="${pageContext.request.contextPath}/">Home</a> |
<a href="${pageContext.request.contextPath}/login">LogIn</a>
</nav>
</td>
</tr>
</table><!-- ROOT -->
<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>
</body>


</html>