package edu.uci.ics.crawler4j.crawler;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.client.solrj.response.TermsResponse;
import org.apache.solr.client.solrj.response.TermsResponse.Term;
import gvjava.org.json.*;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class data {

	public static void main(String[] args) {
		SolrServer server = new HttpSolrServer("http://localhost:8983/solr/");
		SolrQuery sq=new SolrQuery();
		sq.setQueryType("/admin/luke");
		sq.setFields("text");
		sq.set("numTerms",1443);
		sq.getTermsFields();
		
		try {
			QueryResponse qr = server.query(sq);
			System.out.println(sq);
			String ana=qr.toString();
			
			String reg1="topTerms=.(.*?}),histogram.*";
			String reg2="(.*?)?=(.*?)?[,|}]";
			Pattern pat1=Pattern.compile(reg1);
			Pattern pat2=Pattern.compile(reg2);
			Matcher mat1=pat1.matcher(ana);
			if(mat1.find())
			{
				Matcher mat2=pat2.matcher(mat1.group(1));
				System.out.println(mat1.group(1));
				while(mat2.find())
				{
					System.out.println(mat2.group(1)+ "@@"+mat2.group(2));
				}
			}
			
			/*TermsResponse resp = qr.getTermsResponse();
			JSONParser parser=new JSONParser();
			Object obj = parser.parse(ana);
	        JSONArray array = (JSONArray)obj;
	        //System.out.println(array.get(2));
			*/
		/*	System.out.println("124");
			System.out.println(resp);
			System.out.println("123");
			List<TermsResponse.Term> a = resp.getTerms("text");
			System.out.println("hiiiiii");
			//System.out.println(a);
			System.out.println("hello");
			for( Term b:a){
				System.out.println(b);
			}
		}  catch (NullPointerException e) {
			System.out.println("hi");
		} catch (ParseException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		} */} catch (NullPointerException e) {
			System.out.println("hi");
		} catch (SolrServerException e) {
			e.printStackTrace();
		}
		
	}
}
