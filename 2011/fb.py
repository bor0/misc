import urllib, urllib.request as urllib2, urllib.error, http.cookiejar as cookielib, time
from urllib.parse import urlencode

def InitializeOpener():
	#cookie storage
	cj = cookielib.CookieJar()
	#create an opener
	opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
	#Add useragent, sites don't like to interact programs.
	opener.addheaders.append(('User-agent', 'Mozilla/4.0'))
	#opener.addheaders.append( ('Referer', 'http://bor0.users.sf.net/') )
	return opener

def LoginToFacebook(opener, username, password):
	#define login data (username, password, submit)
	login_data = urlencode({'email' : username,
	'pass' : password,
	'login' : 'Log In'
	})
	#convert to bytes
	bytes_data = login_data.encode("ascii")
	#initialize resp
	resp = opener.open('https://www.facebook.com/login.php?m=m&amp;refsrc=http%3A%2F%2Fm.facebook.com%2F&amp;refid=8', bytes_data)
	#return resp
	return resp

def LocateFriends(opener, page_no=0):
	#initialize empty list
	L = []
	#open findfriends part
	resp = opener.open('http://m.facebook.com/findfriends.php?pymk_index=' + str(page_no))
	#read the content into data
	data = str(resp.read())
	#close the connection
	resp.close()
	#iteration
	while (True):
		#attempt to find friends entry
		p = data.find("connect.php?id=")
		#iterate while there are friends entries
		if (p == -1): break
		#parse accordingly
		data = data[p + 15:]
		#it always ends with ampersand
		tmp = data.find("&")
		#add it to the list
		L.append(data[:tmp])
	#return the list
	return L

def SendFriendRequest(opener, id):
	#open the page that contains the "send friend request" form
	resp = opener.open('http://m.facebook.com/connect.php?id=' + id)
	data = str(resp.read())
	resp.close()
	#read the hidden special variable fb_dtsg
	fb_dtsg = data[data.find("value") + 6:]
	#read the hidden special variable post_form_id
	post_form_id = fb_dtsg[fb_dtsg.find("value") + 6:]
	#parse accordingly the variables
	fb_dtsg = fb_dtsg.split(" ")[0].strip('"')
	post_form_id = post_form_id.split(" ")[0].strip('"')
	#store the variables to the post data
	post_data = urlencode({'post_form_id' : post_form_id,
	'fb_dtsg' : fb_dtsg,
	'connect' : 'Send Request'})
	#convert the post data to bytes so that it can be sent to opener.open()
	bytes_data = post_data.encode("ascii")
	#send the data
	resp = opener.open('http://m.facebook.com/connect.php?id=' + id, bytes_data)
	#read the data and store it to 'data'
	data = resp.read()
	#close the connection
	resp.close()
	#return the read data
	return data

def SendMessage(opener, id, msg):
	resp = opener.open('http://m.facebook.com/messages/compose/?ids=' + id)
	#open the page that contains the "send friend request" form
	data = str(resp.read())
	resp.close()
	#read the hidden special variable fb_dtsg
	fb_dtsg = data[data.find("value") + 6:]
	#read the hidden special variable post_form_id
	post_form_id = fb_dtsg[fb_dtsg.find("value") + 6:]
	#parse accordingly the variables
	fb_dtsg = fb_dtsg.split(" ")[0].strip('"')
	post_form_id = post_form_id.split(" ")[0].strip('"')
	#store the variables to the post data
	post_data = urlencode({
	'fb_dtsg' : fb_dtsg,
	'post_form_id' : post_form_id,
	'ids' + chr(91) + str(id) + chr(93) : str(id),
	'body' : msg,
	'Send' : 'Send',
	'refid' : '0'
	})
	#convert the post data to bytes so that it can be sent to opener.open()
	bytes_data = post_data.encode("ascii")
	#send the data
	resp = opener.open('http://m.facebook.com/messages/send/?refid=0', bytes_data)
	#read the data and store it to 'data'
	data = resp.read()
	#close the connection
	resp.close()
	#return the read data
	return data


username = input("Enter your Facebook login username: ")
password = input("Enter your Facebook login password: ")

username = username.replace("\r", "").replace("\n", "")
password = password.replace("\r", "").replace("\n", "")

message = "Hello friend :)))\nI am new to Facebook\nand I want to meet new friends!\nPlease send me a friend request!!! :)))\n Let's meet up and chat about life and the universe and everything else :))))"

m = int(input("Enter the starting page (0...n): "))
l = int(input("Enter the number of pages you want to parse: "))
start = time.clock()
totalsum = 0
totalsuccess = 0

try:
	opener = InitializeOpener()
	resp = LoginToFacebook(opener, username, password)
	for i in range(m, l+m):
		print("Parsing page " + str(i+1) + " ...")
		x = LocateFriends(opener, i)
		if (len(x) == 0):
			print("Page with no friends reached. Ending")
			break
		for k in x:
			try:
				#SendFriendRequest(opener, k)
				#print("Successfully sent friend request to ID: " + k)
				SendMessage(opener, k, message)
				print("Successfully messaged ID: " + k)
				totalsuccess = totalsuccess + 1
			except:
				print("Error sending friend request to ID: " + k)
			totalsum = totalsum + 1
	resp.close()
	start = int(time.clock() - start)
	print("Parsed " + str(totalsum) + " friend requests, of which " + str(totalsuccess) + " were successful.")
	print("Completed in " + str(start) + " seconds.")
except:
	print("An error occured with initializing and/or getting the friends list.")