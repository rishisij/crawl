<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"  %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<%
Class.forName("com.mysql.jdbc.Driver").newInstance();
Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/words","root", "root");
Statement st = conn.createStatement();
String sq=request.getParameter("sql");
String[] an=sq.split(" ");
String[] ana = an[0].split("@");
int ides=Integer.parseInt(ana[1]); 
String foredit="UPDATE taxo SET url='"+an[1]+"',word='"+an[2]+"' WHERE id="+ides+";";
String fordelete="DELETE FROM taxo WHERE id="+ides+";";
if(ana[0].equalsIgnoreCase("Edit")){
	st.executeUpdate(foredit);
}
if(ana[0].equalsIgnoreCase("Delete")){
	st.executeUpdate(fordelete);
}

%>
</head>
<body>

</body>
</html>