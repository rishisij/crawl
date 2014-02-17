package edu.uci.ics.crawler4j.crawler;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.regex.Pattern;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.BinaryRequestWriter;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
//import org.apache.solr.client.solrj.impl.StreamingUpdateSolrServer;
import org.apache.solr.client.solrj.impl.XMLResponseParser;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrInputDocument;
import org.apache.tika.exception.TikaException;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.AutoDetectParser;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.sax.BodyContentHandler;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;

import edu.uci.ics.crawler4j.parser.HtmlParseData;
import edu.uci.ics.crawler4j.url.WebURL;

public class BasicCrawler extends WebCrawler {

	private final static Pattern FILTERS = Pattern
			.compile(".*(\\.(css|js|bmp|gif" + "|png|tiff?|mid|mp2|mp3|mp4"
					+ "|wav|avi|mov|mpeg|ram|m4v|pdf"
					+ "|rm|smil|wmv|swf|wma|zip|rar|gz))$");
	public HttpSolrServer server = new HttpSolrServer(
			"http://localhost:8983/solr");

	public AutoDetectParser autoParser;
	public Collection<SolrInputDocument> docs = new ArrayList();
	FileInputStream match;
	ArrayList<String> arr = new ArrayList<String>();
	String sess;
	public static String pass = "";
	public static String Titl = "";
	static ContentHandler bodyContentHandler;

	/**
	 * You should implement this function to specify whether the given url
	 * should be crawled or not (based on your crawling logic).
	 */

	@Override
	public boolean shouldVisit(WebURL url) {

		// System.out.println("hahahhahahahhahahhahahhahhhahahahahahahhahahahhahahahhahhahhhahaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhahhhhhahahhahahhah");
		server.setRequestWriter(new BinaryRequestWriter());
		server.setParser(new XMLResponseParser());
		autoParser = new AutoDetectParser();
		String href = url.getURL().toLowerCase();
		return !FILTERS.matcher(href).matches() && href.startsWith("http://");
	}

	/**
	 * This function is called when a page is fetched and ready to be processed
	 * by your program.
	 */

	@Override
	public void visit(Page page) {
/*		int docid = page.getWebURL().getDocid();*/
		String url = page.getWebURL().getURL();
		String cype=page.contentType;
		
	/*	String domain = page.getWebURL().getDomain();
		String path = page.getWebURL().getPath();
		String subDomain = page.getWebURL().getSubDomain();
		String parentUrl = page.getWebURL().getParentUrl();*/
		ContentHandler textHandler = new BodyContentHandler(10000000);
		Metadata metadata = new Metadata();
		URL htmlPage;
		try {
			htmlPage = new URL(url);
			DataInputStream htmlStream = new DataInputStream(htmlPage.openStream());
			bodyContentHandler = new BodyContentHandlerWhitespaced();
			AutoDetectParser p = new AutoDetectParser();
			p.parse(htmlStream, bodyContentHandler, metadata);
			System.out.println (bodyContentHandler.toString());
		} catch (MalformedURLException e2) {
			e2.printStackTrace();
		}	
		 catch (IOException e2) {
			e2.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (TikaException e) {
			e.printStackTrace();
		}
		
		/*ParseContext context = new ParseContext();*/
		System.out.println("URL: " + url);
		Titl = url;

		Titl = Titl.replaceAll(".*wiki/(.*?)", "$1");
		Titl = Titl.replaceAll("Category:", "");
		Titl = Titl.replaceAll(
				"http://creativecommons.org/licenses/by-sa/3.0/",
				"Wiki License");
		Titl = Titl.replaceAll("Help:Category", "Help");
		Titl = Titl.replaceAll("Wikipedia:(.*?)", "$1");
		Titl = Titl.replaceAll(" http://shop.wikimedia.org/", "Wikimedia Shop");
		Titl = Titl.replaceAll("_", " ");
		server.setRequestWriter(new BinaryRequestWriter());
		server.setParser(new XMLResponseParser());
		if (page.getParseData() instanceof HtmlParseData) {
			HtmlParseData htmlParseData = (HtmlParseData) page.getParseData();
			String text = htmlParseData.getText();
			String html = htmlParseData.getHtml();
			/*System.out.println(7);
			List<WebURL> links = htmlParseData.getOutgoingUrls();
			System.out.println(3);
			try {
				InputStream stream = new ByteArrayInputStream(
						html.getBytes("UTF-8"));
				System.out.println(stream);
				System.out.println(textHandler);
				System.out.println(context);
				System.out.println(metadata);
				autoParser.parse(stream, textHandler, metadata);
				System.out.println(2);
			} catch (UnsupportedEncodingException e2) {
				e2.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (SAXException e) {
				e.printStackTrace();
			} catch (TikaException e) {
				e.printStackTrace();
			}*/
			// System.out.println(text);
			// System.out.println(html);
			/*
			 * try { InputStream input = new InputStream();
			 * autoParser.parse(input, textHandler, metadata, context); } catch
			 * (FileNotFoundException e) {
			 * System.out.println("html not coming"); e.printStackTrace(); }
			 * catch (IOException e) { e.printStackTrace(); } catch
			 * (SAXException e) { e.printStackTrace(); } catch (TikaException e)
			 * { e.printStackTrace(); }
			 */
			/*
			 * String title="<meta.charset=\"UTF-8\"./><title>Category:(.*?)-";
			 * Pattern pat1 = Pattern.compile(title,Pattern.DOTALL); Matcher mat
			 * = pat1.matcher(html); if(mat.find()) { Title = mat.group(1); }
			 */
			sess = BasicCrawlController.cat;
			String ai[] = sess.split("(?!^)");
			int ant = 0;
			for (String bo : ai) {
				int i = Integer.parseInt(bo);
				i = i + ant;
				ant = i;
			}
			String[] myStringArray = new String[] {};
			if (ant == 1) {
				myStringArray = new String[] { "/home/gateway/Documents/191_data/workspace/crawler4j/ino.txt" };
			}
			if (ant == 2) {
				myStringArray = new String[] { "/home/gateway/Documents/191_data/workspace/crawler4j/org.txt" };
			}
			if (ant == 3) {
				myStringArray = new String[] {
						"/home/gateway/Documents/191_data/workspace/crawler4j/ino.txt",
						"/home/gateway/Documents/191_data/workspace/crawler4j/org.txt" };
			}
			if (ant == 4) {
				myStringArray = new String[] { "/home/gateway/Documents/191_data/workspace/crawler4j/bio.txt" };
			}
			if (ant == 5) {
				myStringArray = new String[] {
						"/home/gateway/Documents/191_data/workspace/crawler4j/ino.txt",
						"/home/gateway/Documents/191_data/workspace/crawler4j/bio.txt" };
			}
			if (ant == 6) {
				myStringArray = new String[] {
						"/home/gateway/Documents/191_data/workspace/crawler4j/ino.txt",
						"/home/gateway/Documents/191_data/workspace/crawler4j/bio.txt" };
			}
			if (ant == 7) {
				myStringArray = new String[] {
						"/home/gateway/Documents/191_data/workspace/crawler4j/ino.txt",
						"/home/gateway/Documents/191_data/workspace/crawler4j/org.txt",
						"/home/gateway/Documents/191_data/workspace/crawler4j/bio.txt" };
			}
			for (String h : myStringArray) {
				String b;
				try {
					match = new FileInputStream(h);
					BufferedReader br = new BufferedReader(
							new InputStreamReader(match));
					while ((b = br.readLine()) != null) {
						if (text.contains(b)) {
							arr.add(b);
						}
					}
					System.out.println(arr);
				} catch (FileNotFoundException e1) {
					System.out.println("File nOt Found");
				} catch (IOException e1) {
					System.out.println("File nOt Found");
				}

				if (docs.size() > 0) { // Are there any documents left over?
					try {
						server.add(docs, 300000);
						server.commit();
					} catch (SolrServerException e) {
						System.out.println("khali hai");
						;
					} catch (IOException e) {
						e.printStackTrace();
					}
				}

				docs.clear();

				// System.out.println("Text length: " + text.length());
				// System.out.println("Html length: " + html.length());
				// System.out.println("Number of outgoing links: " +
				// links.size());
			}
			cype=cype.replace(";", " ");
			cype=cype.replace("text/", "");

			SolrInputDocument doc = new SolrInputDocument();
			doc.addField("url", url);
			doc.addField("ido", Titl);
			doc.addField("texto", bodyContentHandler.toString());
			doc.addField("Facets", arr);
			doc.addField("content_type",cype);
			docs.add(doc);
			this.pass = arr.toString();
			// System.out.println(docs);
			if (docs.size() > 0) { // Are there any documents left over?
				/*
				 * System.out.println(
				 * "issme problem ho sakta hgai yeh doc ke andar aa gaya hai isme value hai"
				 * ); System.out.println(docs);
				 * System.out.println("docs print ho gaya hai");
				 * System.out.println(server);
				 */
				try {
					server.add(docs);
					server.commit();
				} catch (SolrServerException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				// System.out.println("server me add ho chuka hai");
				System.out.println("commit ho gaya");
			}
			arr.clear();
			docs.clear();

		}

		System.out.println(arr);

		System.out.println("=============");
	}

}
