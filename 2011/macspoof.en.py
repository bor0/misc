import os, subprocess, winreg, time, sys

def myinput(x):
	return input(x).replace('\r','').replace('\n','')

def refreshadapter():
	value, type = winreg.QueryValueEx(macaddr, "ComponentId")
	try:
		value = '*' + value.split('&')[1] + '*'
	except IndexError:
		try:
			value = '*' + value.split('\\')[1] + '*'
		except:
			pass
	print("Refreshing LAN adapter..")
	proc = subprocess.Popen(["devcon.exe", "disable", value], stdout=subprocess.PIPE); proc.wait()
	proc = subprocess.Popen(["devcon.exe", "enable", value], stdout=subprocess.PIPE); proc.wait()
	return

def ishex(hexstring):
	hexstring = str.lower(hexstring)
	i = len(hexstring)
	if (i != 12): return 0
	for x in range(0, i):
		if (hexstring[x] != '0' and hexstring[x] != '1' and hexstring[x] != '2' and hexstring[x] != '3' and hexstring[x] != '4' and hexstring[x] != '5' and hexstring[x] != '6' and hexstring[x] != '7' and hexstring[x] != '8' and hexstring[x] != '9' and hexstring[x] != 'a' and hexstring[x] != 'b' and hexstring[x] != 'c' and hexstring[x] != 'd' and hexstring[x] != 'e' and hexstring[x] != 'f'): return 0
	return 1

print("MAC Address Spoofer by Boro Sitnikovski\n---------------------------------------")

mainkeystring = "SYSTEM\\CurrentControlSet\\Control\\Class\\{4D36E972-E325-11CE-BFC1-08002bE10318}\\"

try:
	macaddr = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, mainkeystring, 0, winreg.KEY_ALL_ACCESS)
except:
	print("Unknown error occurred."); sys.exit()

print("Pick an adapter to spoof:")

try:
	i=0; jump=0
	while 1:
		x = winreg.EnumKey(macaddr, i)
		y = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, mainkeystring + x, 0, winreg.KEY_ALL_ACCESS)
		try:
			value, type = winreg.QueryValueEx(y, "DriverDesc")
		except:
			jump=1
			pass
		winreg.CloseKey(y)
		i=i+1
		if (jump != 1):
			print('\"'+x+'\"' + ": " + value)
		jump=0
except WindowsError:
	pass

winreg.CloseKey(macaddr)
try:
	s = sys.argv[1]
except IndexError:
	s = myinput("--> ")

try:
	macaddr = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, mainkeystring + s, 0, winreg.KEY_ALL_ACCESS)
except:
	print("That adapter is not found or can not be spoofed."); time.sleep(3); sys.exit()
	
os.system("cls")

print("MAC Address Spoofer by Boro Sitnikovski\n---------------------------------------\nSelected adapter \"" + winreg.QueryValueEx(macaddr, "DriverDesc")[0] + '\"')

try:
	value, type = winreg.QueryValueEx(macaddr, "NetworkAddress")
	print("Currently spoofing MAC address " + repr(value))
	i=1
	s = myinput("Pick an option:\n0) Stop MAC spoofing\n1) Enter a new MAC address to spoof\n2) Enter an IP or hostname to spoof their MAC\n3) Spoof a MAC address from the ARP cache\n4) Refresh LAN adapter\n5) Exit\n--> ")
except WindowsError:
	print("Not spoofing anything at the moment")
	i=0
	s = myinput("Pick an option:\n1) Enter a new MAC address to spoof\n2) Enter IP or hostname to spoof their MAC\n3) Spoof a MAC address from the ARP cache\n4) Refresh LAN adapter\n5) Exit\n--> ")

if (s == '0' and i == 1):
	try:
		winreg.DeleteValue(macaddr, "NetworkAddress")
		refreshadapter()
		print("You are no longer spoofing a MAC address.")
	except WindowsError:
		print("Unknown error occurred.")
elif (s == '1'):
	x = myinput("Enter MAC address: ").replace('-','').replace(' ','')
	if (ishex(x)):
		try:
			winreg.SetValueEx(macaddr, "NetworkAddress", 0, winreg.REG_SZ, x)
			refreshadapter()
			print("Successfully started spoofing.")
		except WindowsError:
			print("Unknown error occurred.")
	else:
		print("You've entered an invalid hexadecimal number.")
elif (s == '2'):
	x = myinput("Enter hostname or IP address:\n")
	print("Searching the network, please wait...")
	proc = subprocess.Popen(["nbtstat.exe", "-R"], stdout=subprocess.PIPE); proc.wait()
	proc = subprocess.Popen(["nbtstat.exe", "-a", x], stdout=subprocess.PIPE); proc.wait()
	output = str(proc.communicate()[0], "UTF-8")
	x = str.find(output, "MAC Address = ")+14
	if (x == 13):
		print("Can not find such user in the network.")
	else:
		x = output[x:x+17].replace('-', '')
		try:
			winreg.SetValueEx(macaddr, "NetworkAddress", 0, winreg.REG_SZ, x)
			refreshadapter()
			print("Successfully started spoofing.")
		except WindowsError:
			print("Unknown error occurred.")
elif (s == '3'):
	proc = subprocess.Popen(["arpfill.bat"]); proc.wait()
	proc = subprocess.Popen(["arp.exe", "-a"], stdout=subprocess.PIPE)
	while (proc.poll() == None):
		output = str(proc.communicate()[0], "UTF-8").replace('-', '').split(' ')
	lista = []
	x = 0
	for i in range(0, len(output)):
		if (ishex(output[i]) == 1):
			skip=0
			for j in range(0, len(lista)):
				if (lista[j] == output[i]):
					skip=1
			if (skip == 0):
				lista.append(output[i])
				print(str(x) + ") " + output[i])
				x=x+1
	if (len(lista) == 0):
		print("The ARP List is empty.")
	else:
		try:
			x = int(myinput("Enter index to spoof: "))
			winreg.SetValueEx(macaddr, "NetworkAddress", 0, winreg.REG_SZ, lista[x])
			refreshadapter()
			print("Successfully started spoofing.")
		except WindowsError:
			print("Unknown error occurred.")
		except (IndexError, ValueError):
			print("You've entered an invalid value.")
elif (s == '4'):
	refreshadapter()
	print("Adapter successfully refreshed.")
else:
	print("Have a nice day ;)")

winreg.CloseKey(macaddr)
time.sleep(3)
