package edu.uci.ics.crawler4j.crawler;

import org.apache.pdfbox.pdfparser.PDFParser;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.BinaryRequestWriter;
import org.apache.solr.client.solrj.impl.ConcurrentUpdateSolrServer;
import org.apache.solr.client.solrj.impl.XMLResponseParser;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrInputDocument;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.AutoDetectParser;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.sax.BodyContentHandler;
import org.xml.sax.ContentHandler;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;

import javax.swing.*;

public class TikaExample {
	public ConcurrentUpdateSolrServer server;
	public long start = System.currentTimeMillis();
	ArrayList<String> arr = new ArrayList<String>();
	String text;
	public AutoDetectParser autoParser;
	public int totalTika = 0;
	FileInputStream match;
	InputStream input;
	static String sess="";

	// public int totalSql = 0;

	public Collection docs = new ArrayList();

	public TikaExample(int i,String ses) {
		sess=ses;
		try {
			TikaExample idxer = new TikaExample("http://10.0.1.92:8983/solr");
			if (i == 1) {
				JFileChooser fc = new JFileChooser();
				fc.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
				fc.showOpenDialog(null);
				try {
					File file = fc.getSelectedFile();
					idxer.doTikaDocuments(file);
				} catch (NullPointerException e) {
				}
			}
			if (i == 2) {
				idxer.doSqlDocuments();
			}
			idxer.endIndexing();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public TikaExample(String url) throws IOException, SolrServerException {

		server = new ConcurrentUpdateSolrServer(url, 100, 4);
		server.setRequestWriter(new BinaryRequestWriter());
		server.setParser(new XMLResponseParser());
		autoParser = new AutoDetectParser();
	}

	public void endIndexing() throws IOException, SolrServerException {
		if (docs.size() > 0) {
			server.add(docs, 3000);
		}
		server.commit();
		long endTime = System.currentTimeMillis();
		log("Total Time Taken: " + (endTime - start)
				+ " milliseconds to index " + totalTika + " documents");
	}

	public static void log(String msg) {
		System.out.println(msg);
	}

	public void doTikaDocuments(File root) throws IOException,
			SolrServerException {

		if (root.listFiles() != null) {
			for (File file : root.listFiles()) {
				if (file.isDirectory()) {
					doTikaDocuments(file);
					continue;
				}
				extract(file);
			}
		} else {
			extract(root);
		}
	}

	public void dumpMetadata(String fileName, Metadata metadata) {
		log("Dumping metadata for file: " + fileName);
		for (String name : metadata.names()) {
			log(name + ":" + metadata.get(name));
		}
		log("=============================================");
	}

	public void doSqlDocuments() throws SQLException {
		Connection con = null;
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();

			con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/words", "root", "root");

			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("select * from taxo");
			
			while (rs.next()) {

				SolrInputDocument doc = new SolrInputDocument();
				String url = rs.getString("url");
				String url1 = url.replaceAll(
						"http://en.wikipedia.org/wiki/Category:", "");
				int id = rs.getInt("id");
				// String id = rs.getString("id");

				String title = rs.getString("word");
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
							if (title.contains(b)) {
								arr.add(b);
							}
						}
						System.out.println(arr);
					} catch (FileNotFoundException e1) {
						System.out.println("File nOt Found");
					} catch (IOException e1) {
						System.out.println("File nOt Found");
					}

				}
				// String text = rs.getString("html");
				doc.addField("idiot", id);
				doc.addField("ido", url);
				doc.addField("idio", url1);
				doc.addField("texto", title);
				doc.addField("Facets", arr);
				doc.addField("content_type", "DataBase-Data");

				docs.add(doc);
				if (docs.size() >= 1000) {
					UpdateResponse resp = server.add(docs, 3000);
					if (resp.getStatus() != 0) {
						log("Some horrible error has occurred, status is: "
								+ resp.getStatus());
					}
					docs.clear();
					arr.clear();
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}

	public void extract(File rome) throws IOException, SolrServerException {
		File file = rome;
		String name=file.getName();
		String path =file.getCanonicalPath();
		name=name.replaceAll(".*?\\.", "");
		name=name.toLowerCase();
		ContentHandler textHandler = new BodyContentHandler(10000);
		Metadata metadata = new Metadata();
		ParseContext context = new ParseContext();
		System.out.println(path);
		try {
			if(name.equals("pdf")){
				input= new FileInputStream(file);
				autoParser.parse(input, textHandler, metadata, context);
				
			}
			if(name.equals("doc") || name.equals("docx")){
				input= new FileInputStream(file);
				autoParser.parse(input, textHandler, metadata, context);
				
			}
			else
			{
				input= new FileInputStream(file);
				autoParser.parse(input, textHandler, metadata, context);
			}
		} catch (Exception e) {
			System.out.println("Errrrrrrr");
			/*log(String.format("File %s failed", file.getCanonicalPath()));
			e.printStackTrace();*/
			// continue;
		}
		text=textHandler.toString();
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
				BufferedReader br = new BufferedReader(new InputStreamReader(
						match));
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

		}
		/*dumpMetadata(file.getCanonicalPath(), metadata);*/
		System.out.println(arr);
		SolrInputDocument doc = new SolrInputDocument();
		doc.addField("ido", file.getName());
		doc.addField("url", file.getCanonicalPath());
		doc.addField("Facets", arr);
		/* String author = metadata.get("Author"); */
		String ctype = metadata.get("Content-Type");
		/*
		 * if (author != null) { doc.addField("Authoro", author); }
		 */
		doc.addField("texto", text);
		doc.addField("content_type", ctype);
		if(!text.equalsIgnoreCase(""))
			{
			docs.add(doc);
			}
		else
		{
			doc.clear();
		}
		++totalTika;
		if (docs.size() >= 1000) {

			UpdateResponse resp = server.add(docs, 300000);
			if (resp.getStatus() != 0) {
				log("Some horrible error has occurred, status is: "
						+ resp.getStatus());
			}
			arr.clear();
			docs.clear();
		}

	}
}