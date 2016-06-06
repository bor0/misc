/////////////////////////////////
// Boro Sitnikovski 27.11.2011
// http://www.w3schools.com/asp/coll_servervariables.asp
//

#include <stdio.h>

#define MAXSIZE 10240

char init[MAXSIZE] = "<TABLE BORDER=\"1\">\n"
		"<TR>\n"
		"<TD>\n"
		"Method 'POST':\n"
		"<FORM METHOD=\"POST\">\n"
		"<DIV><LABEL>Operand 1: <INPUT NAME=\"a\" ONKEYPRESS=\"return onlyNumbers();\" MAXLENGTH=\"5\" SIZE=\"5\"></LABEL></DIV>\n"
		"<DIV><LABEL>Operand 2: <INPUT NAME=\"b\" ONKEYPRESS=\"return onlyNumbers();\" MAXLENGTH=\"5\" SIZE=\"5\"></LABEL></DIV>\n"
		"<DIV><INPUT TYPE=\"submit\" VALUE=\"Add!\"></DIV>\n"
		"</FORM>\n"
		"</TD>\n"
		"<TD>\n"
		"Method 'GET':\n"
		"<FORM METHOD=\"GET\">\n"
		"<DIV><LABEL>Operand 1: <INPUT NAME=\"a\" ONKEYPRESS=\"return onlyNumbers();\" MAXLENGTH=\"5\" SIZE=\"5\"></LABEL></DIV>\n"
		"<DIV><LABEL>Operand 2: <INPUT NAME=\"b\" ONKEYPRESS=\"return onlyNumbers();\" MAXLENGTH=\"5\" SIZE=\"5\"></LABEL></DIV>\n"
		"<DIV><INPUT TYPE=\"submit\" VALUE=\"Add!\"></DIV>\n"
		"</FORM>\n"
		"</TD>\n"
		"</TR>\n"
		"</TABLE>\n";

void parseHTML(char *s) {
	char buffer[MAXSIZE];
	
	sprintf(buffer, "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">\n"
		"<HTML>\n"
		"<HEAD>\n"
		"<TITLE>CGI Calculator/C By Boro Sitnikovski</TITLE>\n"
		"<SCRIPT TYPE=\"TEXT/JAVASCRIPT\">\n"
		"\tfunction togglediv() {\n"
		"\t\tvar info = document.getElementById('info');\n"
		"\t\tif (info.style.display == \"none\") {\n"
		"\t\t\tinfo.style.display = \"\";\n"
		"\t\t\tinfo.style.visibility = \"visible\";\n"
		"\t\t} else {\n"
		"\t\t\tinfo.style.display = \"none\";\n"
		"\t\t\tinfo.style.visibility = \"hidden\";\n"
		"\t\t}\n"
		"\t}\n"
		"\tfunction onlyNumbers(evt) {\n"
		"\t\tvar e = event || evt;\n"
		"\t\tvar charCode = e.which || e.keyCode;\n\n"
		"\t\tif (charCode > 31 && (charCode < 48 || charCode > 57)) return false;\n"
		"\t\treturn true;\n\n"
		"\t}\n"
		"</SCRIPT>\n"
		"</HEAD>\n"
		"<BODY>\n"
		"CGI Calculator/C written by Boro Sitnikovski (27.11.2011)<BR />\n"
		"<HR />\n"
		"%s"
		"</BODY>\n"
		"</HTML>\n", s);

	printf("%s", buffer);

}

void parsedata(char *data, char *method) {
	char *tok, buffer[MAXSIZE];

	if (data != NULL) {
		int x, y, i = 0;
		tok = (char *)strtok(data, "&");
		if (tok != NULL) {
			while (tok[i] != '=' && tok[i] != '\0') i++;
			x = atoi(tok + i + 1);
			tok = (char *)strtok(NULL, "&");
			if (tok != NULL) {
				i = 0;
				while (tok[i] != '=' && tok[i] != '\0') i++;
				y = atoi(tok + i + 1);
				sprintf(buffer, "<BR />\n[Method '%s']: The results are: <B>%d + %d = %d</B>. Result stored to cookie!\n", method, x, y, x + y);
				strcat(init, buffer);
				sprintf(buffer, "Set-Cookie: Result=%d\n", x+y);
				printf(buffer);
			}
		};
	}
}

int main(int argc, char **argv, char** envp) {
	char *data, *cookies, *raddr, *sname, *ssoftware, **ar, *lenstr, buffer[MAXSIZE], i = 0;
	int len, cookie;

	// First try POST
	lenstr = (char *)getenv("CONTENT_LENGTH");
	if (lenstr != NULL) {
		len = atoi(lenstr);
		if (len < MAXSIZE) {
			fgets(buffer, len + 1, stdin);
			parsedata(buffer, "POST");
		}
	}

	// Second try GET
	else {
		data = (char *)getenv("QUERY_STRING");
		if (data != NULL) {
			parsedata(data, "GET");
		}
	}
	
	// Send header
	printf("Content-Type: text/html; charset=us-ascii\n\n");

	// Parse existing (stored) cookies
	cookies = (char *)getenv("HTTP_COOKIE");
	if (cookies != NULL) {
		while (cookies[i] != '=' && cookies[i] != '\0') i++;
		if (cookies[i] == '=') {
			i++;
			cookie = atoi(cookies+i);
			sprintf(buffer, "<BR /><HR />Last saved cookie result = %d\n", cookie);
			strcat(init, buffer);
		}
	}

	// Parse REMOTE_ADDR
	if ((raddr = (char *)getenv("REMOTE_ADDR")) == NULL) raddr = "";
	// Parse SERVER_NAME
	if ((sname = (char *)getenv("SERVER_NAME")) == NULL) sname = "";
	// Parse SERVER_SOFTWARE
	if ((ssoftware = (char *)getenv("SERVER_SOFTWARE")) == NULL) ssoftware = "";
	
	sprintf(buffer, "<BR />\n<BR />\n<BR />\n<I>You are %s, connected to %s [%s]</I>\n<BR />Other variables: <A HREF=\"javascript:togglediv();\">show/hide</A>\n<BR />\n<DIV ID=\"info\" STYLE=\"visibility:hidden; display:none;\"><PRE STYLE=\"border: 3px double silver;\" WIDTH=\"100\">\n", raddr, sname, ssoftware);
	strcat(init, buffer);

	for (ar = envp; *ar != NULL; ar++) {
		sprintf(buffer, "%s\n", *ar);
		strcat(init, buffer);
	}
	
	strcat(init, "</PRE></DIV>\n");

	parseHTML(init);
	
	return 0;
}