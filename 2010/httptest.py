#from http import cookiejar as cookielib
import urllib, urllib.request as urllib2, http.cookiejar as cookielib

cj = cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
opener.addheaders = [('User-agent', 'Mozilla/5.0')]

auth = urllib.parse.urlencode({'user':username,'pass':password})

link = 'http://s5.ba.bitefight.org/user/login'
data = opener.open(link,data=auth)

print(data.read())
opener.close()
