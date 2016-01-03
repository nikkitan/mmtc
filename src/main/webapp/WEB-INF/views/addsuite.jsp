<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h3> Choose File to Upload in Server </h3>
<form action="uploadtestsuite" method="post" enctype="multipart/form-data">
Name of this test suite:<input type="text" name="name" /><br>
Test suite file:<input type="file" name="file" />
<input type="submit" value="upload" />
</form>     
</body>
</html>