<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h2>Session Destroyed successfully.. </h2>
<%
    session.invalidate();

String site = "http://10.0.1.92:8080/crawler4j" ;
response.sendRedirect(site);
%>
<!-- Things that to be study for future aspects -->
<h2>Session Destroyed successfully.. </h2>
<a href="javascript:history.back()">Click here to go Back</a>

</body>
</html>