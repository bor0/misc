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
	print("Zapocnuvam so refreshiranje na LAN adapter..")
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
	print("Se sluci greska pri obid na spoofiranje."); sys.exit()

print("Odberi adapter za spoofiranje:")

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
	print("Toj adapter ne e pronajden ili ne moze da se spoofira."); time.sleep(3); sys.exit()
	
os.system("cls")

print("MAC Address Spoofer by Boro Sitnikovski\n---------------------------------------\nRabota na adapterot \"" + winreg.QueryValueEx(macaddr, "DriverDesc")[0] + '\"')

try:
	value, type = winreg.QueryValueEx(macaddr, "NetworkAddress")
	print("Momentalno ja spoofiras MAC adresata " + repr(value))
	i=1
	s = myinput("Odberi opcija:\n0) Zapri go spoofiranjeto na MAC\n1) Vnesi nova MAC adresa za spoofiranje\n2) Vnesi MAC za spoofiranje preku IP ili hostname\n3) Spoofiraj MAC adresa od ARP lista\n4) Refresh na LAN adapter\n5) Izlez\n--> ")
except WindowsError:
	print("Momentalno ne spoofiras MAC adresa")
	i=0
	s = myinput("Odberi opcija:\n1) Vnesi nova MAC adresa za spoofiranje\n2) Vnesi MAC za spoofiranje preku IP ili hostname\n3) Spoofiraj MAC adresa od ARP lista\n4) Refresh na LAN adapter\n5) Izlez\n--> ")

if (s == '0' and i == 1):
	try:
		winreg.DeleteValue(macaddr, "NetworkAddress")
		refreshadapter()
		print("Poveke ne spoofiras MAC adresa.")
	except WindowsError:
		print("Se sluci greska. Probaj povtorno.")
elif (s == '1'):
	x = myinput("Vnesi MAC adresa: ").replace('-','').replace(' ','')
	if (ishex(x)):
		try:
			winreg.SetValueEx(macaddr, "NetworkAddress", 0, winreg.REG_SZ, x)
			refreshadapter()
			print("Uspesno namesteno spoofiranje na MAC.")
		except WindowsError:
			print("Se sluci greska. Probaj povtorno.")
	else:
		print("Vnese pogresen heksadecimalen broj.")
elif (s == '2'):
	x = myinput("Vnesi ime na PC ili IP koe sakas da spoofiras za da ja najdeme MAC adresata:\n")
	print("Go baram kompjuterot vo mreza, pricekaj...")
	proc = subprocess.Popen(["nbtstat.exe", "-R"], stdout=subprocess.PIPE); proc.wait()
	proc = subprocess.Popen(["nbtstat.exe", "-a", x], stdout=subprocess.PIPE); proc.wait()
	output = str(proc.communicate()[0], "UTF-8")
	x = str.find(output, "MAC Address = ")+14
	if (x == 13):
		print("Ne mozam da najdam takov korisnik vo mrezata..")
	else:
		x = output[x:x+17].replace('-', '')
		try:
			winreg.SetValueEx(macaddr, "NetworkAddress", 0, winreg.REG_SZ, x)
			refreshadapter()
			print("Uspesno namesteno spoofiranje na MAC.")
		except WindowsError:
			print("Se sluci greska. Probaj povtorno.")
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
		print("ARP Listata e prazna.")
	else:
		try:
			x = int(myinput("Vnesi indeks za spoofiranje: "))
			winreg.SetValueEx(macaddr, "NetworkAddress", 0, winreg.REG_SZ, lista[x])
			refreshadapter()
			print("Uspesno namesteno spoofiranje na MAC.")
		except WindowsError:
			print("Se sluci greska. Probaj povtorno.")
		except (IndexError, ValueError):
			print("Vnese pogresna vrednost.")
elif (s == '4'):
	refreshadapter()
	print("Uspesno refreshirano.")
else:
	print("Prijaten den ;)")

winreg.CloseKey(macaddr)
time.sleep(3)
