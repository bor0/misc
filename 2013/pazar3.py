#!/usr/bin/env python
# -*- coding: utf-8 -*- 

import sqlite3 as lite
import sys

con = lite.connect('pazar3.db')

with con:
    
    cur = con.cursor()    
    cur.execute("CREATE TABLE IF NOT EXISTS PazarList(Link TEXT PRIMARY KEY)")
    cur.execute("CREATE TABLE IF NOT EXISTS Pazar(Link TEXT PRIMARY KEY, Telefon TEXT, Parsed BOOL)")

#    cur.execute("SELECT * FROM PazarList")
#    rows = cur.fetchall()
#    print rows

    cur.execute("SELECT * FROM Pazar")
    rows = cur.fetchall()
#    print rows

    print("<html>\n<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n<table>\n<tr><td width='5%'>ID</td><td width='20%'>Телефон</td><td width='70%'>Линк</td><td width='5%'>Парсирано</td></tr>")
    for x in rows:
        href = "http://www.pazar3.mk" + x[0]
        long = x[0][len("/mk/Listing/AdDetail/Index/"):]
        short = long.split("-")[0]
        print "<tr><td>%s</td><td align='center'>%s</td><td><a href='%s'>%s</a></td><td>%s</td></tr>" % (short, x[1], href, long, x[2])
    print("</table>\n</html>")

