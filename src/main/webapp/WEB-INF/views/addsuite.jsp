<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;">
<title>Insert title here</title>
</head>
<body>
<form action="uploadtestsuite" method="post" enctype="multipart/form-data">
<table><!-- ROOT -->
<tr>
<td style="width:80%;">
<h4> Choose File to Upload in Server </h4>
</td>
<td>
<nav>
<a href="${pageContext.request.contextPath}/home">Home</a> |
<a href="${pageContext.request.contextPath}/logout">LogOut</a>
</nav>
</td>
</tr>
<tr>
<td colspan="2">
<table>
<tr>
<td>

Name of this test suite:<input type="text" name="name" />

</td>
</tr>
<tr>
<td>
Test suite file:<input type="file" name="file" />
</td>
</tr>
<tr>
<td>
<input type="submit" value="upload" /></td>
</tr>

</table> 
</td>
</tr>
</table><!-- ROOT -->
</form>

<div align="center">@2016 Mendez Master Training Center. All rights reserved.</div>    
</body>
</html>