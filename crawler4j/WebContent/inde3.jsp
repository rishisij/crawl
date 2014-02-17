<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="edu.uci.ics.crawler4j.crawler.BasicCrawlController"%>
<%@page import="edu.uci.ics.crawler4j.crawler.BasicCrawlController"%>
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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>EXtraction</title>
<style type="text/css">
a.trigger {
	position: absolute;
	background: #200 url(images/plus.png) 6% 55% no-repeat;
	text-decoration: none;
	font-size: 16px;
	letter-spacing: -1px;
	font-family: verdana, helvetica, arial, sans-serif;
	color: #fff;
	padding: 4px 12px 6px 24px;
	font-weight: bold;
	z-index: 2;
}

a.trigger.right {
	right: 0;
	border-bottom-left-radius: 5px;
	border-top-left-radius: 5px;
	-moz-border-radius-bottomleft: 5px;
	-moz-border-radius-topleft: 5px;
	-webkit-border-bottom-left-radius: 5px;
	-webkit-border-top-left-radius: 5px;
}

a.trigger:hover {
	background-color: #59B;
}

a.active.trigger {
	background: #666 url(images/minus.png) 6% 55% no-repeat;
}

.panel {
	color: #eee;
	position: absolute;
	display: none;
	background: #000000;
	width: 410px;
	height: auto;
	z-index: 1;
}

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
<script type="text/javascript"
	src="ajax.googleapis.com.ajax.libs.jquery.1.4.2.jquery.min.js"></script>
<script src="jquery.slidePanel.min.js"></script>

<script type="text/javascript">
	$(document).ready(function() {

		$('#panel1').slidePanel({
			triggerName : '#trigger1',
			triggerTopPos : '20px',
			panelTopPos : '10px'
		});

		$('#panel3').slidePanel({
			triggerName : '#trigger3',
			triggerTopPos : '60px',
			panelTopPos : '10px'
		});
		$('#panel2').slidePanel({
			triggerName : '#trigger2',
			triggerTopPos : '100px',
			panelTopPos : '100px'
		});

	});
</script>
<script type="text/javascript">
	function functionajax() {
		var xmlhttp;
		if (document.getElementById("checkbox_yes").checked) {
			if (document.getElementById("chemino").checked) {
				if (window.XMLHttpRequest) {
					xmlhttp = new XMLHttpRequest();
				} else {
					xmlhttp = new ActiceXObject("Microsoft.XMLHTTP");
				}
				xmlhttp.onreadystatechange = function() {
					if (xmlhttp.readystate == 4 && xmlhttp.status == 200) {
						document.getElementById("chemino").innerHTML = xmlhttp.responseText;
					}
				}
				chemi = document.getElementById("chemino").value;
			} else if (!document.getElementById("chemino").checked) {
				chemi = "0";
			}
			if (document.getElementById("chemorg").checked) {
				if (window.XMLHttpRequest) {
					xmlhttp = new XMLHttpRequest();
				} else {
					xmlhttp = new ActiceXObject("Microsoft.XMLHTTP");
				}
				xmlhttp.onreadystatechange = function() {
					if (xmlhttp.readystate == 4 && xmlhttp.status == 200) {
						document.getElementById("chemorg").innerHTML = xmlhttp.responseText;
					}
				}
				chemo = document.getElementById("chemorg").value;
			} else if (!document.getElementById("chemorg").checked) {
				chemo = "0";
			}
			if (document.getElementById("chembio").checked) {
				if (window.XMLHttpRequest) {
					xmlhttp = new XMLHttpRequest();
				} else {
					xmlhttp = new ActiceXObject("Microsoft.XMLHTTP");
				}
				xmlhttp.onreadystatechange = function() {
					if (xmlhttp.readystate == 4 && xmlhttp.status == 200) {
						document.getElementById("chembio").innerHTML = xmlhttp.responseText;
					}
				}
				chemb = document.getElementById("chembio").value;
			} else if (!document.getElementById("chembio").checked) {
				chemb = "0";
			}
			xmlhttp
					.open("post", "ajax.jsp?chem=" + chemi + chemo + chemb,
							true);
			xmlhttp.send();

		}
	}
</script>
</head>
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
<%
	if (session.getAttribute("UserName") == null) {
		response.sendRedirect("http://10.0.1.92:8080/crawler4j");
	}
%>
<script>
	function disableElement() {
		document.getElementById("chembio").disabled = true;
		document.getElementById("chemorg").disabled = true;
		document.getElementById("chemino").disabled = true;
		document.getElementById("chembio").checked = false;
		document.getElementById("chemorg").checked = false;
		document.getElementById("chemino").checked = false;
	}
	function enableElement() {
		document.getElementById("chembio").disabled = false;
		document.getElementById("chemorg").disabled = false;
		document.getElementById("chemino").disabled = false;
	}
	function validateForm() {
		if (document.getElementById("checkbox_yes").checked) {
			rv = document.getElementById("checkbox_yes").value;
			if (document.getElementById("chembio").checked
					|| document.getElementById("chemorg").checked
					|| document.getElementById("chemino").checked) {
				var x = document.forms["oops"]["url"].value;
				if (x == null || x == "") {
					alert("Url must be Given for Web Indexing");
					return false;
				}
			} else {
				alert("You didn't check it!.You must have to check :)")
				return false;
			}

		} else if (document.getElementById("checkbox_no").checked) {
			rv = document.getElementById("checkbox_no").value;
			var x = document.forms["oops"]["url"].value;
			if (x == null || x == "") {
				alert("Url must be Given for Web Indexing");
				return false;
			}

			return false;
		} else {
			alert("noooo not again");
			return false;
		}
	}
	function validateForm1() {
		if (document.getElementById("checkbox_yes").checked) {
			rv = document.getElementById("checkbox_yes").value;
			if (document.getElementById("chembio").checked
					|| document.getElementById("chemorg").checked
					|| document.getElementById("chemino").checked) {
				var x = document.forms["oops2"]["dbname"].value;
				if (x == null || x == "") {
					alert("dbname must be Given for Database Indexing");
					return false;
				}
				var x = document.forms["oops2"]["port"].value;
				if (x == null || x == "" || x.length > 4 || x.length < 4) {
					alert("port must be correct ");
					return false;
				}
				var x = document.forms["oops2"]["tname"].value;
				if (x == null || x == "") {
					alert("table name must be Given for Database Indexing");
					return false;
				}
				var x = document.forms["oops2"]["uname"].value;
				if (x == null || x == "") {
					alert("username must be Given for Database Indexing");
					return false;
				}
				var x = document.forms["oops2"]["pword"].value;
				if (x == null || x == "") {
					alert("password must be Given for Database Indexing");
					return false;
				}
			} else {
				alert("You didn't check it!.You must have to check :)")
				return false;
			}

			return false;
		} else if (document.getElementById("checkbox_no").checked) {
			rv = document.getElementById("checkbox_no").value;
			var x = document.forms["oops2"]["dbname"].value;
			if (x == null || x == "") {
				alert("dbname must be Given for Database Indexing");
				return false;
			}
			var x = document.forms["oops2"]["port"].value;
			if (x == null || x == "" || x.length > 4 || x.length < 4) {
				alert("port must be correct ");
				return false;
			}
			var x = document.forms["oops2"]["tname"].value;
			if (x == null || x == "") {
				alert("table name must be Given for Database Indexing");
				return false;
			}
			var x = document.forms["oops2"]["uname"].value;
			if (x == null || x == "") {
				alert("username must be Given for Database Indexing");
				return false;
			}
			var x = document.forms["oops2"]["pword"].value;
			if (x == null || x == "") {
				alert("password must be Given for Database Indexing");
				return false;
			}

			return false;
		} else {
			alert("noooo not again");
			return false;
		}

	}
	function validateForm2() {
		if (document.getElementById("checkbox_yes").checked) {
			rv = document.getElementById("checkbox_yes").value;
			if (document.getElementById("chembio").checked
					|| document.getElementById("chemorg").checked
					|| document.getElementById("chemino").checked) {

			} else {
				alert("You didn't check it!.You must have to check :)")
				return false;
			}

		} else if (document.getElementById("checkbox_no").checked) {
			rv = document.getElementById("checkbox_no").value;
			return false;
		} else {
			alert("noooo not again");
			return false;
		}
	}
</script>
<body>
	<div>
		<div align="center">

			<a href="inde3.jsp"><img src="jack.png" alt="Gtl"></a>
		</div>
		<div align="right"
			style="width: 99%; height: 2%; position: absolute; top: 18%;">
			<table>
				<tr>
					<td></td>
					<td style="color:#000000"><b><i>UserName::</i></b><i><b style="color:#556;"><%=session.getAttribute("UserName")%></b></i></td>
				</tr>
				<tr>
					<td>
						<%
							if (request.getParameter("error") != null) {
								out.print("<font size=2>D()nE</font>!");
							}
						%>
					</td>
					<td><span style="float: right;"><a href="logout.jsp" style="color: #ffffff;border-radius:5px; text-decoration: none;background-color:#000000;"><i>&nbsp;Logout&nbsp;</i></a></span></td>
				</tr>
			</table>
		</div>
	</div>
	<div>
		<table style="border: 0px solid #474747; width: 100%;">
			<tr>
				<td><a href="#" id="trigger1" class="trigger right"><i>Web
							Index</i></a>
					<div id="panel1" class="panel right">
						<form action="inde2.jsp" name="oops"
							onsubmit="return validateForm()" method="POST">
							<fieldset>
								<legend style="color: #8A2BE2;">Web Indexing</legend>
								<table>
									<tr>
										<td><textarea name="url" rows="2" cols="40"></textarea></td>
									</tr>
									<tr>
										<td><input type="submit" name="Web_Ind"
											value="Web_Indexing" style="color: black;" /></td>
										<td>
											<%-- <%=session.getAttribute("usme")%> --%>
										</td>
									</tr>

								</table>
								<!-- <div id="meDiv">
							</div> -->
							</fieldset>
						</form>
					</div></td>
				<td><a href="#" id="trigger2" class="trigger right"><i>Database
							Index</i></a>
					<div id="panel2" class="panel right">
						<form action="inde2.jsp" name="oops2"
							onsubmit="return validateForm1()" method="POST">
							<fieldset>
								<legend style="color: #8A2BE2;">Database Indexing</legend>
								<table>
									<tr>
										<td>Port:<input type="text" name="port" size="2px" /></td>
									</tr>
									<tr>
										<td>Db_name :<input type="text" name="dbname" size="10px" /></td>
										<td>Table_name:<input type="text" name="tname"
											size="17px" /></td>
									</tr>
									<tr>
										<td>User_name:<input type="text" name="uname" size="20px" /></td>
										<td>Password:<input type="password" name="pword"
											size="20px" /></td>
									</tr>
									<tr>
										<td><input type="submit" name="DB_Ind"
											value="DB_Indexing" style="color: black;" /></td>
									</tr>
								</table>
							</fieldset>
						</form>
					</div></td>
				<td><a href="#" id="trigger3" class="trigger right"><i>Local-Dir-Files</i></a>
					<div id="panel3" class="panel right">
						<form action="inde2.jsp" name="oops1" method="POST"
							onsubmit="return validateForm2()">
							<fieldset>
								<legend style="color: #8A2BE2;">Local-Dir-Files</legend>
								<table>
									<tr>
										<td></td>
									</tr>
									<tr>
										<td></td>
									</tr>
									<tr>
										<td><input type="submit" name="Local_Ind"
											value="Local_Indexing" /></td>
									</tr>
								</table>
							</fieldset>

						</form>
					</div></td>

				<td>
					<!-- this container transfer in 3rd DIv --> <!-- <fieldset>
						<legend style="color: #8A2BE2;">Taxonomy</legend>
						<form name="check" method="POST">
							<table>
								<tr>
									<td><input type="checkbox" id="chembio" name="chembio"
										value="4" onclick="functionajax()" />ChemBio</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="chemorg" name="chemorg"
										value="2" onclick="functionajax()" />ChemOrg</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="chemino" name="chemino"
										value="1" onclick="functionajax()" />ChemIno</td>
								</tr>
							</table>
						</form>
						<form name="radio">
							<table>
								<tr>
									<td><input type="radio" name="checkbox" id="checkbox_no"
										value="no" onclick="return disableElement()">NoTaxo</td>
									<td><input type="radio" name="checkbox" id="checkbox_yes"
										value="yes" checked="checked" onclick="return enableElement()">Taxo</td>
								</tr>
							</table>
						</form>
					</fieldset> -->
				</td>
			</tr>

			<tr>
				<td></td>
			</tr>
		</table>
		<%-- 	<table style="align:center">
							<tr>
								<td>Username::<i><b><%=session.getAttribute("UserName")%></b></i></td>
							</tr>
							<tr>
								<td><span style="float: right"><a href="logout.jsp">logout</a></span></td>
							</tr>
						</table> --%>
	</div>
	<script type="text/javascript">
		function getComboA(sel) {
			var cname = document.getElementById("q");
			var input_val = document.getElementById("q").value;
			name.action = "inde3.jsp?q=" + input_val + "";
			name.submit();
		}
	</script>
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
			params.setQuery(request.getParameter("q"));

		}
		if (request.getParameter("fq") == null
				|| request.getParameter("fq") == ""
				|| request.getParameter("fq").trim() == " ") {

		} else {
			params.setFilterQueries(request.getParameter("fq"));
		}

		params.setStart((int) start);
		QueryResponse respons = server.query(params);

		SolrDocumentList solrDocumentList = respons.getResults();
		respons.getQTime();
		long i = respons.getResults().getNumFound();
	%>
	<!-- 	####### Here I wrote a Program for Facets -->
	<div
		style="width: 15%; height: 273%; border-radius: 10px; position: absolute; top: 24%; left: 0px; background-color: #C9FFE5;">
		<div style="left: 25px; background-color: #556; border-radius: 5px;">
			<div
				style="margin-left: 12%; height: 30px; font-size: 16pt; color: #fff">
				<b>Field Facets</b>
			</div>
		</div>

		<%
			String s = "";
			@SuppressWarnings("rawtypes")
			List abs = respons.getFacetFields();

			for (Object Abs : abs) {
				String[] split = Abs.toString().split(":");
				/* split[0] = split[0].replace("_", " "); */
		%>
		<div>
			<table style="color: #200;">
				<tr>
					<td align="center" bgcolor="#909090" style="border-radius: 5px"><b><%="   " + split[0]%></b></td>
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
									s = "inde3.jsp?q=&fq=" + split[0] + ":" + san[0];
								} else {
									String addFq = request.getQueryString();
									s = "inde3.jsp?" + addFq + "&fq=" + split[0] + ":"
											+ san[0];
									/* System.out.println(request.getQueryString()); */
								}
							} else if (request.getParameter("fq") == null
									|| request.getParameter("fq") == ""
									|| request.getParameter("fq").trim() == " ") {
								String van = request.getParameter("q").trim()
										.replaceAll(" ", "+");
								s = "inde3.jsp?q=" + van + "&fq=" + split[0] + ":"
										+ san[0];

							} else {
								/* String van = request.getParameter("q").trim().replaceAll(" ", "+"); */
								String addFq = request.getQueryString();
								s = "inde3.jsp?" + addFq + "&fq=" + split[0] + ":"
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
	<!--  Here I wrote a Program for Query -->
	<div
		style="width: 70%; height: 100%; position: absolute; top: 24%; left: 15%;">
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
								and1[1] = and1[1].replaceAll("@", "=");
								System.out.println(and2);
					%><td style="background-color: #556; border-radius: 4px"><a
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
							href="inde3.jsp?q=<%=reqParams%>&PageNo=<%=prePageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Prev&nbsp;</i></b></a></td>
						<%
							} else {
						%><td style="background-color: #556;border-radius:5px;"><a
							href="inde3.jsp?q=<%=reqParams%>&fq=<%=dsplit[0] + ":" + dsplit[1]%>&PageNo=<%=prePageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Prev&nbsp;</i></b></a></td>
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
							href="inde3.jsp?q=<%=reqParams%>&PageNo=<%=postPageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Next&nbsp;</i></b></a></td>

						<%
							} else {
						%>
						<td style="background-color: #556;border-radius:5px;"><a
							href="inde3.jsp?q=<%=reqParams%>&fq=<%=dsplit[0] + ":" + dsplit[1]%>&PageNo=<%=postPageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Next&nbsp;</i></b></a></td>

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

			<div style="background-color: #C9FFE5; border-radius: 10px;padding: 5px; margin: 5px; margin-left: 2%; margin-right: 2%; margin-bottom: 15px;">
				<table>
					<tr>
						<td align="right"><a
							href="delete.jsp?del=<%=url1%>&bUrl=<%=request.getQueryString()%>"
							style="color: #000000; text-decoration: none;">X</a></td>
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
			%><div
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
							href="inde3.jsp?q=<%=reqParams%>&PageNo=<%=prePageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Prev&nbsp;</i></b></a></td>
						<%
							} else {
						%><td style="background-color: #556;border-radius:5px;"><a
							href="inde3.jsp?q=<%=reqParams%>&fq=<%=dsplit[0] + ":" + dsplit[1]%>&PageNo=<%=prePageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Prev&nbsp;</i></b></a></td>
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
							href="inde3.jsp?q=<%=reqParams%>&PageNo=<%=postPageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Next&nbsp;</i></b></a></td>

						<%
							} else {
						%>
						<td style="background-color: #556; border-radius:5px;"><a
							href="inde3.jsp?q=<%=reqParams%>&fq=<%=dsplit[0] + ":" + dsplit[1]%>&PageNo=<%=postPageNo%>" style="color: #fff; text-decoration: none;"><b><i>&nbsp;Next&nbsp;</i></b></a></td>
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
		<div
			style="overflow: auto; width: 15%; height: 273%; position: absolute; top: 24%; left: 85%; background-color: #C9FFE5; border-radius:10px;">
			<div>
				<fieldset style="border: 0px;">
					<div style="width: 100%; background-color: #556;border-radius:5px;">
						<div
							style="width: 100%; height: 30px; font-size: 16pt; color: #fff" align="center">
							<b><i>Taxonomy</i></b>
						</div>
					</div>

					<form name="check" method="POST">
						<table style="margin-left:15px;">
							<tr>
								<td><input type="checkbox" id="chembio" name="chembio"
									value="4" onclick="functionajax()" />ChemBio</td>
							</tr>
							<tr>
								<td><input type="checkbox" id="chemorg" name="chemorg"
									value="2" onclick="functionajax()" />ChemOrg</td>
							</tr>
							<tr>
								<td><input type="checkbox" id="chemino" name="chemino"
									value="1" onclick="functionajax()" />ChemIno</td>
							</tr>
						</table>
					</form>
					<form name="radio">
						<table style="margin-left:15px;">
							<tr>
								<td><input type="radio" name="checkbox" id="checkbox_no"
									value="no" onclick="return disableElement()">NoTaxo</td>
								<td><input type="radio" name="checkbox" id="checkbox_yes"
									value="yes" checked="checked" onclick="return enableElement()">Taxo</td>
							</tr>
						</table>
					</form>
				</fieldset>
			</div>
		</div>
</body>
</html>