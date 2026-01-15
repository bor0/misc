def getdate(string):
	datestart = '<p class="headerDatum">'
	dateend = '</p>'

	y = string.find(datestart) + len(datestart)
	string = string[y:]
	y = string.find(dateend)
	string = string[:y].replace('  ', '').replace('\\r\\n', '')

	return string

def initstrstock(string):
	stockstrstart = '<div id="txx" style="visibility:hidden">'
	stockstrend = '</div>'

	y = string.find(stockstrstart) + len(stockstrstart)
	string = string[y:]
	y = string.find(stockstrend)
	string = string[:y]

	string = string.replace("                        ", " ")
	string = string.replace("&nbsp; &nbsp;", " ")
	return string

def parsestrstock(string):
	z = string.find("</a>")
	y = string.find('>') + 1
	string = string[y:]
	y = string.find('<')
	string = string[:y]
	string = string.split(' ')
	string = (z+4, string[0], string[2], string[3])
	return string

def parseresults(string):
	p = getdate(string).split(' ')
	t = '"Date time","' + p[0] + '","' + p[1] + '"\n'

	string = initstrstock(string)

	y = [0]

	while (y[0] != 3):
		y = parsestrstock(string)
		string = string[y[0]:]
		if (y[3] != ''):
			t = t + ('"' + y[1] + '","' + y[2] + '","' + y[3] + '"\n')

	return t

import urllib.request, base64, socket, time

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 80))
s.listen(1)
while 1:
	conn, addr = s.accept()

	url = 'http://www.mse.org.mk/'
	x = str(urllib.request.urlopen(url).read())
	t = parseresults(x)

	qwe = conn.recv(1)
	if (qwe == b'q'):
		conn.close()
		break

	encoded_data = str(base64.b64encode(bytes(t.encode())))
	p = 'HTTP/1.1 200 OK\r\nServer: Apache\r\nAccept-Ranges: bytes\r\nContent-disposition: attachment; filename=stockmarket.csv\r\nContent-Length: ' + str(len(t)) + '\r\nKeep-Alive: timeout=15, max=100\r\nConnection: Keep-Alive\r\nContent-Type: text/csv\r\n\r\n'

	conn.send((p + t).encode())
	conn.recv(8192)
	conn.close()
