import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.Writer;

import java.net.URL;
import java.net.URLConnection;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Date;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


// http://www.w3.org/TR/1999/REC-html401-19991224/index/attributes.html

public class Main {

	public static final String folderPath = "C:\\dataCrawler";
	public static final String webPageFilter = "boro.dcmembers.com";
	public static final String webPageDisallow = null;
	public static int maximumId;

	public static String readUrlGetContent(URLConnection url) {
		int c;
		StringBuilder p = new StringBuilder();
		try {
			BufferedReader in = new BufferedReader(new InputStreamReader(url.getInputStream()));
			while ((c = in.read()) != -1) p.append((char)c);
			in.close();
			url.getInputStream().close();
		} catch (Exception e) {
			System.out.println("Exception in readUrlGetContent: " + e.toString());
			return null;
		}
		return p.toString();
	}

	private static void parseContent(String webContent, String webPage, String type, String[] array, ArrayList<String> listOfLinks) {
		String target[]; int k, j;
		for (int l=0;l<array.length;l++) {
			target = webContent.split(array[l]);
			for (int i=1;i<target.length;i++) {
				try {
					String fixedString = target[i];
					k = fixedString.indexOf(">");
					if (k == -1) continue;
					fixedString = fixedString.substring(0, k);
					j = fixedString.toLowerCase().indexOf(type);
					if (j == -1) continue;
					fixedString = fixedString.substring(j+type.length());
					if ((j = fixedString.indexOf(" ")) != -1) fixedString = fixedString.substring(0, j);
					if ((j = fixedString.indexOf("\r")) != -1) fixedString = fixedString.substring(0, j);
					if ((j = fixedString.indexOf("\n")) != -1) fixedString = fixedString.substring(0, j);
					fixedString = fixedString.replace("\\\"", "\"").replace("\"", "").replace("'", "").replace("\\/", "/");
					if (fixedString.length() == 0) continue;
					if (fixedString.contains("://") == false && fixedString.toLowerCase().startsWith("www.") == false) {
						if (fixedString.contains(":") == true) continue;
						String web = null;
						if (fixedString.startsWith("/") == true) {
							int temp; String tmp = webPage.replace("//", "zz");
							if ((temp=tmp.indexOf("/")) != -1)
								web = webPage.substring(0, temp);
							else
								web = webPage;
						} else {
							web = webPage.substring(0, webPage.lastIndexOf("/"));
						}
						fixedString = ("/" + fixedString).replace("//", "/");
						if (fixedString.startsWith("/") && web.endsWith("/")) {
							fixedString = web + fixedString.substring(1);
						} else {
							fixedString = web + fixedString;
						}
					}
					if (listOfLinks.contains(fixedString) == false) listOfLinks.add(fixedString);
				} catch (Exception e) {
					System.out.println("Exception in parseContentGetLinks: " + e.toString());
				}
			}
		}
	}

	public static ArrayList<String> parseContentGetLinks(String webContent, String webPage) {

		ArrayList<String> listOfLinks = new ArrayList<String>();

		String hreflist[] = { "(?i)<a ", "(?i)<area ", "(?i)<link ", "(?i)<base " };
		String srclist[] = { "(?i)<script ", "(?i)<input ", "(?i)<frame ", "(?i)<iframe ", "(?i)<img " };
		
		parseContent(webContent, webPage, "href=", hreflist, listOfLinks);
		parseContent(webContent, webPage, "src=", srclist, listOfLinks);
	
		/*for (i=0;i<listOfLinks.size();i++) {
			System.out.println(i + ": " + listOfLinks.get(i));
		}*/

		return listOfLinks;
	}
	
	public static boolean entryExistsInXML(String entry) {
		try {
			DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
			Document doc = docBuilder.parse (new File(folderPath + "\\data.xml"));
			doc.getDocumentElement().normalize();

			NodeList listOfEntries = doc.getElementsByTagName("entry");

			int totalEntries = listOfEntries.getLength();

			for (int i=0;i<totalEntries;i++) {
				Node firstNode = listOfEntries.item(i);
				if (firstNode.getNodeType() == Node.ELEMENT_NODE) {

					Element firstElement = (Element)firstNode;

					NodeList firstNameList = firstElement.getElementsByTagName("url");
					Element firstNameElement = (Element)firstNameList.item(0);

					NodeList textFNList = firstNameElement.getChildNodes();
					if ((((Node)textFNList.item(0)).getNodeValue().trim()).equals(entry) == true) return true;

				}
			}
		} catch (Exception e) {
			System.out.println("Exception in entryExistsInXML: " + e.toString());
		}
		return false;
	}

	public static int getMaxIdFromXML() {
		int max = 0, tmp;
		try {
			DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
			Document doc = docBuilder.parse (new File(folderPath + "\\data.xml"));
			doc.getDocumentElement().normalize();

			NodeList listOfEntries = doc.getElementsByTagName("entry");

			int totalEntries = listOfEntries.getLength();

			for (int i=0;i<totalEntries;i++) {
				Node firstNode = listOfEntries.item(i);
				if (firstNode.getNodeType() == Node.ELEMENT_NODE) {

					Element firstElement = (Element)firstNode;

					NodeList firstNameList = firstElement.getElementsByTagName("contentid");
					Element firstNameElement = (Element)firstNameList.item(0);

					NodeList textFNList = firstNameElement.getChildNodes();
					tmp = Integer.parseInt(((Node)textFNList.item(0)).getNodeValue());
					if (tmp > max) max = tmp;
				}
			}
		} catch (Exception e) {
			System.out.println("Exception in getMaxIdFromXML: " + e.toString());
		}
		return max;
	}

	public static void addEntryToXML(String entry, String date, int id) {
		try {
			DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
			Document doc = docBuilder.parse (new File(folderPath + "\\data.xml"));

			Element xmlRoot = doc.getDocumentElement();

			Element newEntry = doc.createElement("entry");

			Element urlNode = doc.createElement("url");
			urlNode.appendChild(doc.createTextNode(entry));
			newEntry.appendChild(urlNode);

			Element dateNode = doc.createElement("date");
			dateNode.appendChild(doc.createTextNode(date));
			newEntry.appendChild(dateNode);

			Element contentIdNode = doc.createElement("contentid");
			contentIdNode.appendChild(doc.createTextNode(String.valueOf(id)));
			newEntry.appendChild(contentIdNode);

			xmlRoot.appendChild(newEntry);

			TransformerFactory transfac = TransformerFactory.newInstance();
			Transformer trans = transfac.newTransformer();
			trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			trans.setOutputProperty(OutputKeys.INDENT, "yes");

			StreamResult result = new StreamResult(new File(folderPath + "\\data.xml"));
			DOMSource source = new DOMSource(doc);
			trans.transform(source, result);

		} catch (Exception e) {
			System.out.println("Exception in addEntryToXML: " + e.toString());
		}
	}

	public static void recursionStartCrawling(String webPage, ArrayList<String> pageLinks) {
		if (webPageFilter != null && webPage.contains(webPageFilter) == false) return;
		if (webPageDisallow != null && webPage.contains(webPageDisallow) == true) return;
		if (pageLinks == null) {
			if (entryExistsInXML(webPage) == true) return;
			addEntryToXML(webPage, new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()), ++maximumId);
			
			System.out.println(maximumId + ": Parsing " + webPage);

			URLConnection t = null;
			try {
				t = (new URL(webPage)).openConnection();
				if (t.getContentType().contains("text") == false) {
					t.getInputStream().close();
					return;
				}
			} catch (Exception e) {
				System.out.println("Exception in recursionStartCrawling: " + e.toString());
			}

			String pageContent = readUrlGetContent(t);
			if (pageContent == null) return;
			File file = new File(folderPath + "\\datacontent\\" + maximumId + ".content");
			try {
				Writer fileWriter = new BufferedWriter(new FileWriter(file));
				fileWriter.write(pageContent);
				fileWriter.close();
			} catch (Exception e) {
				System.out.println("Exception in recursionStartCrawling: " + e.toString());
			}
			recursionStartCrawling(webPage, parseContentGetLinks(pageContent, webPage));
		} else for (int i=0;i<pageLinks.size();i++) {
				String t = pageLinks.get(i);
				if (entryExistsInXML(t) == false) recursionStartCrawling(t, null);
		}
	}

	public static void zaTestiranje(String url) {
		try {
			System.out.println(url);
			URLConnection p = (new URL(url)).openConnection();
			String k = readUrlGetContent(p);
			parseContentGetLinks(k, url);
		} catch (Exception e) {}
	}

	public static void main(String[] args) {
		System.out.println("Start " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));
		maximumId = getMaxIdFromXML();
		recursionStartCrawling("http://boro.dcmembers.com/", null);
		System.out.println("Completed " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));
	}
}
