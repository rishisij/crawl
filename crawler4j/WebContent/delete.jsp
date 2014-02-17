<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="org.apache.solr.client.solrj.*"%>
<%@ page import="org.apache.solr.client.solrj.impl.HttpSolrServer"%>
<%@ page import="org.apache.solr.client.solrj.response.QueryResponse"%>
<%@ page import="org.apache.solr.common.SolrDocumentList"%>
<%@ page import="org.apache.solr.common.SolrDocument"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String queryStr = request.getQueryString();
	queryStr = queryStr.replaceFirst("&", "@");
	String[] urlSplitter = queryStr.split("@");
	urlSplitter[0]=urlSplitter[0].replace("del=", "");
	urlSplitter[1]=urlSplitter[1].replace("bUrl=", "");
	SolrServer server = new HttpSolrServer("http://10.0.1.92:8983/solr");
	String str="url:"+"\""+urlSplitter[0]+"\"";
	server.deleteByQuery(str);
	server.commit();
	String site ="inde3.jsp?"+urlSplitter[1];
	response.sendRedirect(site);
%>
</body>
</html>