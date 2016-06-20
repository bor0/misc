import os, winreg, time

#Skriptata zavisi od DEVCON.exe
#
#AdapterControl(adapter, funkcija)
#Prima dva argumenti;
#adapter - Imeto na konekcijata
#funkcija - String "enable" ili "disable"
#
#Return value: -1 na greska ili stringot koj treba da se povika
##
#AllAdaptersControl(adapter, funkcija)
#Prima dva argumenti;
#adapter - Imeto na konekcijata
#funkcija - String "enable" ili "disable"
#Return value: -1 na greska ili lista od stringovi koi treba da se povikaat


def AdapterControl(adapter, x, splitter="\\"):
##Boro Sitnikovski EIN-SOF 06.06.2010

	if (x != "enable" and x != "disable"): return -1

	try:
		macaddr = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, "SYSTEM\\ControlSet001\\Control\\Network\\{4D36E972-E325-11CE-BFC1-08002BE10318}", 0, winreg.KEY_ALL_ACCESS)
	except:
		return -1

	a = winreg.QueryInfoKey(macaddr)

	for b in range(0,a[0]):
		d = winreg.EnumKey(macaddr, b) + "\\Connection"
		try:
			e = winreg.OpenKey(macaddr, d)
			f = winreg.QueryValueEx(e, "Name")[0]
			if (f == adapter):
				d = winreg.QueryValueEx(e, "PnpInstanceID")[0].split(splitter)[1]
				winreg.CloseKey(e)
				return("devcon " + x + " *" + d + "*")
			winreg.CloseKey(e)
		except WindowsError: pass
		except IndexError: pass

	return -1

def AllAdaptersControl(x, splitter="\\"):
##Boro Sitnikovski EIN-SOF 06.06.2010

	if (x != "enable" and x != "disable"): return -1

	list = []

	try:
		macaddr = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, "SYSTEM\\ControlSet001\\Control\\Network\\{4D36E972-E325-11CE-BFC1-08002BE10318}", 0, winreg.KEY_ALL_ACCESS)
	except:
		return -1

	a = winreg.QueryInfoKey(macaddr)

	for b in range(0,a[0]):
		d = winreg.EnumKey(macaddr, b) + "\\Connection"
		try:
			e = winreg.OpenKey(macaddr, d)
			d = winreg.QueryValueEx(e, "PnpInstanceID")[0].split(splitter)[1]
			winreg.CloseKey(e)
			list.append("devcon " + x + " *" + d + "*")
			winreg.CloseKey(e)
		except WindowsError: pass
		except IndexError: pass

	if (list == []): return -1
	else: return list

x = AllAdaptersControl("enable")
print(x)
exit()

x = AdapterControl(input("Vnesi ime na konekcija\n--> "), input("Vnesi \"enable\" ili \"disable\"\n--> "))
if (x == -1): print("Se sluci greska.")
else: print(x)

time.sleep(3)