package edu.uci.ics.crawler4j.crawler;

import org.xml.sax.helpers.DefaultHandler;

public class BodyContentHandlerWhitespaced extends DefaultHandler {

	private StringBuffer m_content, m_bodyContent, m_otherContent;

	BodyContentHandlerWhitespaced() {
		super();
		m_bodyContent = new StringBuffer();
		m_otherContent = new StringBuffer();
		m_content = m_otherContent;
	}

	public void characters (char[] ch, int start, int length) throws org.xml.sax.SAXException
	{
//insert space for every call to this callback function when length < 100
		if (length < 100)
		{
			m_content.append(" ");
		}
// store the text into the current content member
		m_content.append(new String(ch, start, length));
	}

	public void startElement(java.lang.String uri, java.lang.String localName,
			java.lang.String name, org.xml.sax.Attributes atts)
			throws org.xml.sax.SAXException {
		if (localName.equalsIgnoreCase("body")) {
			// set current content member to m_bodyContent
			m_content = m_bodyContent;
		}
	}

	public void endElement(java.lang.String uri, java.lang.String localName,
			java.lang.String name) throws org.xml.sax.SAXException {
		if (localName.equalsIgnoreCase("body")) {
			// set current content member to m_otherContent
			m_content = m_otherContent;
		}
	}

	public String toString() {
		// return content
		if (m_bodyContent.length() == 0) {
			// no body content available, return all content
			return m_otherContent.toString();
		}
		// return only body content
		return m_bodyContent.toString();
	}
}