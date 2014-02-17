<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletRequestWrapper" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title> Extraction :)</title>
</head>
<body>

<%!String f,g; %>

<% HttpServletRequest request1 = (HttpServletRequest) request ; %>
<% f= request1.getParameter("user");%>
<% g = request1.getParameter("password");%>
<% HttpSession session1 = request1.getSession(true); %>
<% session1.setAttribute("UserName", f); %>

<jsp:declaration>


Statement stmt1;
Connection con1;
String url1 = "jdbc:mysql://127.0.0.1:3306/chem";

</jsp:declaration>
<jsp:scriptlet><![CDATA[
Class.forName("com.mysql.jdbc.Driver").newInstance();
con1 = DriverManager.getConnection(url1, "root", "root"); 
stmt1 = con1.createStatement();
ResultSet rs1 =  stmt1.executeQuery("select * from html where html =\'" + f + "\' AND name =\'" + g + "\';");
if (rs1.next())
{
	int per = rs1.getInt("id");
	if (per==1||per==2)
	{
		 String site = "http://10.0.1.92:8080/crawler4j/inde3.jsp" ;
		// response.setStatus(response.SC_MOVED_TEMPORARILY);
		 response.sendRedirect(site);
		 
	}
	else
	{
		 //response.setStatus(response.SC_MOVED_TEMPORARILY);
		 String url = "http://10.0.1.92:8080/crawler4j/?error="+URLEncoder.encode("1", "UTF-8");
		 response.sendRedirect(url);
		 return ;
	}
}
else
{
	String url = "http://10.0.1.92:8080/crawler4j/?error="+URLEncoder.encode("1", "UTF-8");
	response.sendRedirect(url);
}
]]></jsp:scriptlet>


</body>
</html>