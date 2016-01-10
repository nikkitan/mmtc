<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style type="text/css">

</style>
<title>MMTC</title>
</head>
<body>
<h2><a href="uploadfile.jsp">Upload Example</a></h2>
<%
if (session.getAttribute("uploadFile") != null
&& !(session.getAttribute("uploadFile")).equals("")) {
%>
<h3>Uploaded File</h3>
<br>
<img src="<%=session.getAttribute("uploadFile")%>" alt="Upload Image" />

<%
session.removeAttribute("uploadFile");
}
%>
</body>
</html>