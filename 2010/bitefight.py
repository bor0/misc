import socket, sys, time, threading, os

print("Boro Sitnikovski BiteFighter\n" + "-"*28)

try:
	if sys.argv[1] == '?':
		print("Usage parameters: python bitefight.py;\n[max_threads(int)] [timeout(float)] [repeat(bool)] [id(int)] [debug(bool)]")
		raise
except IndexError:
	pass
except:
	sys.exit()

max_threads = 30
to = 10.0
repeat = False
id = 72840
debug = False

try:
	max_threads = int(sys.argv[1])
	to = float(sys.argv[2])
	if str.lower(sys.argv[3]) == "true": repeat = True
	else: repeat = False
	id = int(sys.argv[4])
	if str.lower(sys.argv[5]) == "true": debug = True
	else: debug = False
except:
	pass

count = 0
totalcount = 0

class Thread(threading.Thread):
	def __init__(self, host, port, to, repeat, id, server="s5"):
		self.host = host
		self.port = port
		self.to = to
		self.repeat = repeat
		self.id = id
		self.server = server
		threading.Thread.__init__(self)

	def GoBite(self):
		data = b"GET http://" + bytes(self.server, "ascii") + b".ba.bitefight.org/user/bite/" + bytes(str(self.id), "ascii") + b"\r\n\r\n"

		socket.setdefaulttimeout(self.to)
		client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		client_socket.settimeout(self.to)
		try:
			client_socket.connect((self.host, self.port))
		except:
			return 4
		client_socket.send(data)

		x = b"BoR0"
		p = 0
		error = 0

		while x != b"":
			try:
				if error > 10: break
				x = client_socket.recv(8192)
			except socket.timeout:
				p = 4
				break
			except:
				error = error + 1
				continue
			if x.find(b"Danas si ve") != -1:
				p = 1
				break
			elif x.find(b"Neko je") != -1:
				p = 2
				break
			elif x.find(b"Ugrizao vas je") != -1:
				p = 3
				break

		client_socket.close()
		return p

	def run(self):
		global count, debug
		p = self.GoBite()

		if debug == True: print("Bite against", self.host, self.port, "results:")
		if p == 0 and debug == True:
			print("BitError: Invalid proxy, most likely.");
		elif p == 1 and debug == True:
			print("BitError: This IP address is already bitten.");
		elif p == 2:
			if debug == True: print("BitError: Failed to get a Bite. Lucky IP!");
			if self.repeat:
				time.sleep(0.5)
				self.run()
		elif p == 3:
			if debug == True: print("BitSuccess: Successfully bitten.");
			count = count + 1
		elif debug == True:
			print("BitError: Socket connection timeout.");

try:
	f = open("bitefight.txt")
except:
	print("File bitefight.txt not found. Exiting...")
	sys.exit()
while 1:
	host = f.readline().replace("\t", " ").split(" ")
	if host == [""]: break
	try:
		while 1: host.remove("")
	except:
		pass
	port = int(host[1])
	host = host[0]
	Thread(host, port, to, repeat, id).start()
	Thread(host, port, to, repeat, 16279, "s11").start()
	totalcount = totalcount + 2
	while threading.active_count() == max_threads: time.sleep(0.5)

f.close()
while threading.active_count() != 1: time.sleep(0.5)

print("Total successful bites", count, "out of", totalcount)