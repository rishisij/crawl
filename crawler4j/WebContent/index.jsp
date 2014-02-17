<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="javax.servlet.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="javax.jdo.*"%>
<%@ page import="javax.jdo.Query"%>
<%@ page import="javax.jdo.PersistenceManager"%>
<%@ page import="org.apache.solr.client.solrj.*"%>
<%@ page import="org.apache.solr.client.solrj.impl.HttpSolrServer"%>
<%@ page import="org.apache.solr.client.solrj.response.QueryResponse"%>
<%@ page import="org.apache.solr.common.SolrDocumentList"%>
<%@ page import="org.apache.solr.common.SolrDocument"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Extraction :)</title>
<style type="text/css">
/* #####this is where trigger where describe about color and and its hi or wi  */
a.trigger {
	position: absolute;
	background: #000000 url(images/plus.png) 6% 55% no-repeat;
	text-decoration: none;
	font-size: 16px;
	letter-spacing: -1px;
	font-family: verdana, helvetica, arial, sans-serif;
	color: #fff;
	padding: 4px 12px 6px 24px;
	font-weight: bold;
	z-index: 2;
}
/*############This is uses for trigger in right and border  and its design  */
a.trigger.right {
	right: 0;
	border-bottom-left-radius: 5px;
	border-top-left-radius: 5px;
	-moz-border-radius-bottomleft: 5px;
	-moz-border-radius-topleft: 5px;
	-webkit-border-bottom-left-radius: 5px;
	-webkit-border-top-left-radius: 5px;
}
/*#################when trigger get mouse on it or a tab on it then it will chage its backgroung color into this color  */
a.trigger:hover {
	background-color: #59B;
}
/*##########here trigger put a minus button after triggered  */
a.active.trigger {
	background: #666 url(images/minus.png) 6% 55% no-repeat;
}
/* #####this is where panel where describe about color and and its hi or wi  */
.panel {
	color: #CCC;
	position: absolute;
	display: none;
	background: #000000;
	width: 300px;
	height: auto;
	z-index: 1;
}
/*############This is uses for panel in right and border and padding and its design  */
.panel.right {
	right: 0;
	padding: 20px 100px 20px 30px;
	border-bottom-left-radius: 15px;
	border-top-left-radius: 15px;
	-moz-border-radius-bottomleft: 15px;
	-moz-border-radius-topleft: 15px;
	-webkit-border-bottom-left-radius: 15px;
	-webkit-border-top-left-radius: 15px;
}
</style>
<link rel="stylesheet" href="WEB-INF/css/styles.css" type="text/css" />

<script type="text/javascript"
	src="ajax.googleapis.com.ajax.libs.jquery.1.4.2.jquery.min.js"></script>
<script src="jquery.slidePanel.min.js"></script>
<!--Jquery uses for login functionality  -->
<script type="text/javascript">
	$(document).ready(function() {

		$('#panel2').slidePanel({
			triggerName : '#trigger2',
			triggerTopPos : '20px',
			panelTopPos : '10px'
		});

	});
</script>
</head>
<body><!--Login Functionality  -->
	<a href="#" id="trigger2" class="trigger right"><i>Login</i></a>
	<div id="panel2" class="panel right">
		<form action="hello.jsp" method="POST">
			<table>
				<tr>
					<td><b>username:</b><input type="text" name="user" size="20"
						tabindex="1" /></td>
					<td></td>
				</tr>
				<tr>
					<td><b>password:</b><input type="password" name="password"
						size="20" tabindex="2" /></td>
					<td></td>
				</tr>
				<tr>
					<td style="text-align: right">
						<%
							if (request.getParameter("error") != null) {

								out.println("<font size=2>Invalid Username or Password<font>!");
							}
						%><input type="submit" value="submit" tabindex="3" />
					</td>
					<td style="text-align: right"></td>
				</tr>


			</table>
		</form>
	</div>
<!--#######Gatewat image Loading  -->
	<div align="center" >
		<a href="index.jsp"  ><img src="jack.png" alt="Gtl"></a>
	</div>
	<!--######Here I parse String into Tnt :p -->
	<%!public int nullIntconv(String str) {
		int conv = 0;
		if (str == null) {
			str = "0";
		} else if ((str.trim()).equals("null")) {
			str = "0";
		} else if (str.equals("")) {
			str = "0";
		}
		try {
			conv = Integer.parseInt(str);
		} catch (Exception e) {
		}
		return conv;
	}%>
<!--######This function is used for any change happen in query box will tell it to query also after submit or pressing enter  -->
	<script type="text/javascript">
		function getComboA(sel) {
			var cname = document.getElementById("q");
			var input_val = document.getElementById("q").value;
			name.action = "index.jsp?q=" + input_val + "";
			name.submit();
		}
	</script>
	<!--##################here i wrote a program for Solr server and Query and fetch the search result from it  -->
	<%
		int prePageNo = 0;
		int postPageNo = 0;
		long start = 0;
		String test = " ";
		int PageNo = nullIntconv(request.getParameter("PageNo"));
		if (PageNo == 0) {
			start = 0;
		} else {
			start = PageNo * 10;

		}
		SolrServer server = new HttpSolrServer("http://10.0.1.92:8983/solr");

		SolrQuery params = new SolrQuery();
		params.setFacet(true);
		params.setFacetMinCount(1);
		params.addFacetField("Facets");
		params.addFacetField("content_type");
		if (request.getParameter("q") == null
				|| request.getParameter("q") == ""
				|| request.getParameter("q").trim() == " ") {
			params.setQuery("*:*");

		} else {
			params.setQuery(request.getParameter("q").trim()
					.replaceAll(" ", "+"));
		}
		if (request.getParameter("fq") == null
				|| request.getParameter("fq") == ""
				|| request.getParameter("fq").trim() == " ") {

		} else {
			String fstring = "";
			fstring = request.getParameter("fq");
			/* System.out.println(fstring); */
			params.setFilterQueries(fstring);
		}

		params.setStart((int) start);
		QueryResponse respons = server.query(params);

		SolrDocumentList solrDocumentList = respons.getResults();
		respons.getQTime();
		long i = respons.getResults().getNumFound();
	%>
	<!-- 	####### Here I wrote a Program for Facets -->
	<div
		style="width: 15%; height: 273%; border-radius: 10px;position: absolute; top: 24%; left: 0px; background-color: #C9FFE5;">
		<div style="left: 25px; background-color: #556;border-radius: 5px ;">
			<div
				style="margin-left: 12%; height: 30px; font-size: 16pt; color: #fff">
				<b>Field Facets</b>
			</div>
		</div>
		<%
			String s = "";
			@SuppressWarnings("rawtypes")
			List abs = respons.getLimitingFacets();

			for (Object Abs : abs) {
				String[] split = Abs.toString().split(":");
				/* split[0] = split[0].replace("_", " "); */
		%>
		<!--###########This div is used for Facets  -->
		<div>
			<table style="color: #200;">
				<tr>
					<td align="center" bgcolor="#909090" style="border-radius:5px"><b><%="   " + split[0]%></b></td>
				</tr>

				<%
					split[1] = split[1].replace("[", "");
						split[1] = split[1].replace("]", "");
						String[] fValue = split[1].split(",");
						for (String Fvalue : fValue) {
							/* Fvalue = Fvalue.replaceAll(" ", ""); */
							String[] san = Fvalue.split("\\(");

							san[0] = san[0].replaceFirst(" ", "");
							san[0] = san[0].replaceFirst("\\s+", " ");
							san[0] = san[0].trim();
							san[0] = san[0].replaceAll(" ", "+");
							san[0] = san[0].replace("$+", "");

							if (request.getParameter("q") == null
									|| request.getParameter("q") == ""
									|| request.getParameter("q").trim() == " ") {
								if (request.getParameter("fq") == null
										|| request.getParameter("fq") == ""
										|| request.getParameter("fq").trim() == " ") {
									s = "index.jsp?q=&fq=" + split[0] + ":" + san[0];
								} else {
									String addFq = request.getQueryString();
									s = "index.jsp?" + addFq + "&fq=" + split[0] + ":"
											+ san[0];
									/* System.out.println(request.getQueryString()); */
								}
							} else if (request.getParameter("fq") == null
									|| request.getParameter("fq") == ""
									|| request.getParameter("fq").trim() == " ") {
								String van = request.getParameter("q").trim()
										.replaceAll(" ", "+");
								s = "index.jsp?q=" + van + "&fq=" + split[0] + ":"
										+ san[0];

							} else {
								/* String van = request.getParameter("q").trim().replaceAll(" ", "+"); */
								String addFq = request.getQueryString();
								s = "index.jsp?" + addFq + "&fq=" + split[0] + ":"
										+ san[0];
								/* 								System.out.println(s); */
							}
				%>
				<tr>
					<td align="left"><i><a href=<%=s%>
							style="color: #000000; text-decoration: none;"><%=Fvalue%></a></i></td>
					
				</tr>
				<%
					}

					}

					/* Set<String> uniqueSet = new HashSet<String>(solrDocumentList);
					for (String temp : uniqueSet) {
						System.out.println(temp + " (" + Collections.frequency(solrDocumentList, temp)+")");
					} */
				%>
			</table>
		</div>
	</div>
	<!-- ########### Here I wrote a Program for Query -->
	<div
		style="width: 85%; height: 100%; position: absolute; top: 24%; left: 15%;">
		<!--#############This Div tells us about cancellation of facets  -->
		<div style="margin-left: 3px; margin-right: 3px; position: absolute;">
			<table>
				<tr>
					<%
						if (request.getParameter("fq") == null
								|| request.getParameter("fq") == ""
								|| request.getParameter("fq").trim() == " ") {
						}

						else {
							String qStr1 = request.getQueryString().replaceAll("=", "@")
									.replaceAll("&", "!!");
							String[] and = qStr1.split("!!");
							System.out.println(qStr1);
							for (int l = 1; l < and.length; l++) {
								String and2 = and[l].replaceFirst(".*?@(.*?)", "$1");
								String[] and1 = and[l].split(":");
								and1[1]=and1[1].replaceAll("@", "=");
								System.out.println(and2);
					%><td style="background-color: #556;border-radius: 4px"><a
						href="delFacetFromUrl.jsp?delFacet=<%=and2%>&qString=<%=qStr1%>"
						style="color: #fff; text-decoration: none; font-size: 12pt;"><%=and1[1]%></a></td>
					<%
						}
						}
					%>
				</tr>
			</table>
		</div>
		<!--################This Div for Query box and submit button  -->
		<div style="top:2%; position:absolute;">
			<div
				style="padding: 5px; margin-left: 2%; margin-right: 2%; margin-bottom: 15px;"
				align="center">

				<form name="name" method="GET">
					<table
						style="padding: 5px; margin-left: 2%; margin-right: 2%; margin-bottom: 15px; margin: 5px; font-weight: normal; font-size: 17px; letter-spacing: 0.08em;">
						<tr>

							<%
								if (request.getParameter("q") == null
										|| request.getParameter("q") == ""
										|| request.getParameter("q").trim() == " ") {
							%><td><b><input type="text" name="q"
									style="height: 30px; font-size: 14pt;" size="65px"
									onchange="getComboA();"></b></td>
							<%
								} else {
									String van = request.getParameter("q").trim();
							%><td><b><input type="text"
									style="height: 30px; font-size: 14pt;" size="65px" name="q"
									onchange="getComboA();" value=<%="\"" + van + "\""%>></b></td>
							<%
								}
							%>

							<td><input type="submit" value="  Search  " 
								style="height: 38px;background-color: #556;border-radius:7px;color: #fff; font-size: 16pt;"></td>
						</tr>
						<tr>
							<td></td>
						</tr>
					</table>
				</form>
			</div>

			<!--##############This Div For Next and prev Button and show how many results are found  -->
			<div
				style="background-color: #C9FFE5; padding: 5px;border-radius: 10px ;margin: 2px; margin-left: 2%; margin-right: 2%; margin-bottom: 15px;">
				<table style="margin-left: 30%; color: #8A2BE2;">
					<tr>
						<%
							prePageNo = PageNo - 1;
							postPageNo = PageNo + 1;
							String reqParams = "";
							String dSplit = "";
							String[] dsplit = {};
							if (request.getParameter("fq") == null
									|| request.getParameter("fq") == ""
									|| request.getParameter("fq").trim() == " ") {
							} else {
								dSplit = request.getParameter("fq");

								dsplit = dSplit.split(":");
								dsplit[1] = dsplit[1].replaceAll("\"", "");
							}

							if (request.getParameter("q") == null
									|| request.getParameter("q") == ""
									|| request.getParameter("q").trim() == " ") {
								reqParams = "";
							} else {
								reqParams = request.getParameter("q");
							}
							if (start > 0) {
								if (request.getParameter("fq") == null
										|| request.getParameter("fq") == ""
										|| request.getParameter("fq").trim() == " ") {
						%>
						<td style="background-color: #556;border-radius:5px;"><a
							href="index.jsp?q=<%=reqParams%>&PageNo=<%=prePageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Prev&nbsp;</i></b></a></td>
						<%
							} else {
						%><td style="background-color: #556;border-radius:5px;"><a
							href="index.jsp?q=<%=reqParams%>&fq=<%=dsplit[0] + ":" + dsplit[1]%>&PageNo=<%=prePageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Prev&nbsp;</i></b></a></td>
						<%
							}

							}
						%>
						<td style="color: #556;"><b><i>&nbsp;Found : </i></b><%=solrDocumentList.getNumFound()%></td>
						<td style="color: #556;"><b><i> in </i></b><%=respons.getElapsedTime()%><b><i> MiliSec&nbsp;</i></b></td>
						<%-- <td>And <%=respons.getQTime()%> QueryMiliSec
				</td> --%>
						<%
							long a = solrDocumentList.getNumFound() % 10;
							if (!(start >= (solrDocumentList.getNumFound() - a))) {
								if (request.getParameter("fq") == null
										|| request.getParameter("fq") == ""
										|| request.getParameter("fq").trim() == " ") {
						%><td style="background-color: #556;border-radius:5px;"><a
							href="index.jsp?q=<%=reqParams%>&PageNo=<%=postPageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Next&nbsp;</i></b></a></td>

						<%
							} else {
						%>
						<td style="background-color: #556;border-radius:5px;"><a
							href="index.jsp?q=<%=reqParams%>&fq=<%=dsplit[0] + ":" + dsplit[1]%>&PageNo=<%=postPageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Next&nbsp;</i></b></a></td>

						<%
							}
							}
						%>
					</tr>
				</table>

			</div>
			<!--######From here the results are iterated from Solr  -->
			<%
				for (SolrDocument solD : solrDocumentList) {
					String name = (String) solD.getFieldValue("ido");
					String url1 = (String) solD.getFieldValue("url");
					String con1 = (String) solD.getFirstValue("content_type");
					String texto = (String) solD.getFirstValue("texto");
					/* ArrayList facet =  (ArrayList) solD.getFieldValue("Facets");
					System.out.println(facet.toString());
						for(Object face:facet){
							test=test+","+face.toString();
							System.out.println(test);
						} */
					texto = texto.substring(0, 500);
			%>

			<div
				style="background-color: #C9FFE5; border-radius: 10px;padding: 5px; margin: 5px; margin-left: 2%; margin-right: 2%; margin-bottom: 15px;">
				<table>
					<tr>
						<td></td>
					</tr>

					<tr>
						<td><b>Title : </b><%=name%></td>
					</tr>
					<tr>
						<td><b>Url : </b><%=url1%></td>
					</tr>
					<tr>
						<td><b>Content-Type : </b><%=con1%></td>
					</tr>
					<tr>
						<td><b>Data : </b><%=texto + "......."%></td>
					</tr>
					<%-- <tr>
				<td><b>Facets : </b><%=test%></td>
			</tr> --%>
					<tr>
						<td></td>
					</tr>

				</table>
			</div>
			<%
				test = "";
				}
			%>
			
			
			
			<!--And this div also used for same Next and prev Button and show how many results are found -->
			<div
				style="background-color: #C9FFE5;border-radius: 10px; padding: 5px; margin: 5px; margin-left: 2%; margin-right: 2%; margin-bottom: 15px;">
				<table style="margin-left: 30%; color: #8A2BE2;">
					<tr>
						<%
							if (start > 0) {
								if (request.getParameter("fq") == null
										|| request.getParameter("fq") == ""
										|| request.getParameter("fq").trim() == " ") {
						%>
						<td style="background-color: #556;border-radius:5px;"><a
							href="index.jsp?q=<%=reqParams%>&PageNo=<%=prePageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Prev&nbsp;</i></b></a></td>
						<%
							} else {
						%><td style="background-color: #556;border-radius:5px;"><a
							href="index.jsp?q=<%=reqParams%>&fq=<%=dsplit[0] + ":" + dsplit[1]%>&PageNo=<%=prePageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Prev&nbsp;</i></b></a></td>
						<%
							}

							}
						%>
						<td style="color: #556;"><b><i>&nbsp;Found : </i></b><%=solrDocumentList.getNumFound()%></td>
						<td style="color: #556;"><b><i> in </i></b><%=respons.getElapsedTime()%><b><i> MiliSec&nbsp;</i></b></td>
						<%-- <td>And <%=respons.getQTime()%> QueryMiliSec
				</td> --%>
						<%
							a = solrDocumentList.getNumFound() % 10;
							if (!(start >= (solrDocumentList.getNumFound() - a))) {
								if (request.getParameter("fq") == null
										|| request.getParameter("fq") == ""
										|| request.getParameter("fq").trim() == " ") {
						%><td style="background-color: #556;border-radius:5px;"><a
							href="index.jsp?q=<%=reqParams%>&PageNo=<%=postPageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Next&nbsp;</i></b></a></td>

						<%
							} else {
						%>
						<td style="background-color: #556; border-radius:5px;"><a
							href="index.jsp?q=<%=reqParams%>&fq=<%=dsplit[0] + ":" + dsplit[1]%>&PageNo=<%=postPageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Next&nbsp;</i></b></a></td>
						<td>
							<%
								}
								}
							%>
						
					</tr>
				</table>

			</div>
		</div>
		<!-- <iframe src="http://10.0.1.92:8983/solr/collection1/browse"
		width="1080" height="700"></iframe> -->
	</div>
	<!-- <div
		style="overflow: auto; width: 15%; height: 273%; position: absolute; top: 24%; left: 85%;border-radius: 10px; background-color: #C9FFE5;">
	</div> -->


	<!-- <br />
	<br />
	<br />
	<br />
	<br />
	<br /> -->
</body>
</html>