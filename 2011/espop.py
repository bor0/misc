import socket, sys, datetime, time

def InvokeService():

	HOST = 'mail.ein-sof.com'
	PORT = 110

	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.connect((HOST, PORT))
	
	data = s.recv(1024)
	s.send(b"USER boro.sitnikovski@ein-sof.com\r\n")
	data = s.recv(1024)

	s.send(b"PASS getalief123\r\n")
	data = s.recv(1024)

	s.send(b"STAT\r\n")
	data = s.recv(1024)

	s.close()

	return int(str((str(data).split(' '))[1]))

p = int(input("Enter no. of messages for break condition: "))

while True:
	try:
		x = InvokeService()
	except: #if host could not be resolved temporarily
		time.sleep(5)
		continue

	print(str(datetime.datetime.now().strftime("[%d-%m-%Y %H:%M:%S]")) + ": " + str(x) + " message(s)")

	if (x == p):
		print("Done. Mail is read.")
		break

	time.sleep(300)