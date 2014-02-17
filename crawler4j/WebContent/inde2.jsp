<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="edu.uci.ics.crawler4j.crawler.BasicCrawlController"%>
<%@page import="edu.uci.ics.crawler4j.crawler.TikaExample"%>
<%@page import="edu.uci.ics.crawler4j.crawler.BasicCrawler"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page
	import="javax.servlet.http.*,javax.servlet.*,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletRequestWrapper"%>
<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>HUrrray</title>
</head>
<body>
	<%
		if (request.getParameter("Web_Ind") != null) {
			String act = request.getParameter("Web_Ind");
			String arg = "";
			String fault = "";
			Socket socket = null;
			boolean reachable = false;
			String abs1 = "";

			if (act.equals("Web_Indexing")) {
				String url = request.getParameter("url");
				if (url != null) {
					String reg = ".*//(.*?)/.*";
					String urls[] = url.split(",");
					for (String ur : urls) {
						Pattern pat = Pattern.compile(reg, Pattern.DOTALL);
						Matcher mat = pat.matcher(ur);
						if (mat.find()) {
							try {
								socket = new Socket(mat.group(1), 80);
								reachable = true;
								arg = arg + "," + ur;
							} catch (UnknownHostException e) {
								fault = fault + "," + ur;

							} catch (IOException e) {
								fault = fault + "," + ur;
							} finally {
								if (socket != null) {
									try {
										socket.close();
									} catch (IOException e) {

									}
								}
							}
						}
					}

					session.setAttribute("usme", fault);
					session.setAttribute("kie", arg);

					BasicCrawlController ex = new BasicCrawlController(url,
							(String) session.getAttribute("valuetaxo"));

					abs1 = BasicCrawler.pass;
					String site = "http://10.0.1.92:8080/crawler4j/inde3.jsp?error="
							+ URLEncoder.encode(abs1, "UTF-8");
					response.sendRedirect(site);
				}
			}
		}
		if (request.getParameter("DB_Ind") != null) {
			String abs = "";
			String act = request.getParameter("DB_Ind");
			if (act.equals("DB_Indexing")) {
				TikaExample ex = new TikaExample(2,(String) session.getAttribute("valuetaxo"));

				//out.print("D0nE");
				String site = "http://10.0.1.92:8080/crawler4j/inde3.jsp?error="
						+ URLEncoder.encode("1", "UTF-8");
				response.sendRedirect(site);
				;

			}
		}
		if (request.getParameter("Local_Ind") != null) {
			String act = request.getParameter("Local_Ind");
			if (act.equals("Local_Indexing")) {
				TikaExample ex = new TikaExample(1,(String) session.getAttribute("valuetaxo"));
				//out.print("D0nE");
				String site = "http://10.0.1.92:8080/crawler4j/inde3.jsp?error="
						+ URLEncoder.encode("1", "UTF-8");
				response.sendRedirect(site);

			}
		}
	%>

</body>
</html>