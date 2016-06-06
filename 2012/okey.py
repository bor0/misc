cards = []
players = [[],[],[],[]]

mc = input("Enter the magic card: ").replace("\r","").replace("\n","")
joker = "J" + str((int(mc[:len(mc)-1]) + 1)%13) + mc[len(mc)-1]

for i in range(1, 14):
	cards.append(str(i) + "A")
	cards.append(str(i) + "B")
	cards.append(str(i) + "C")
	cards.append(str(i) + "D")
	cards.append(str(i) + "A")
	cards.append(str(i) + "B")
	cards.append(str(i) + "C")
	cards.append(str(i) + "D")

cards.append(joker)
cards.append(joker)

cards.remove(mc)

for i in range(0, 14):
	players[0].append(0)
	players[1].append(0)
	players[2].append(0)
	players[3].append(0)

players[0].append(0)

player = int(input("Which player's cards are known: ").replace("\r","").replace("\n",""))

max = 15
if (player == 0): max = max + 1

for i in range(1, max):
	card = input("Enter card no " + str(i) + ": ").replace("\r","").replace("\n","")
	players[player].append(card)
	players[player].remove(0)

i = 0

while True:
	if (i > 3):
		print(cards)
		i = 0

	print(players[0])
	print(players[1])
	print(players[2])
	print(players[3])

	x = str(input("Which card did Player " + str(i) + " get (0 for unknown): ").replace("\r","").replace("\n",""))
	y = str(input("Which card did Player " + str(i) + " throw: ").replace("\r","").replace("\n",""))

	if (x != "0"):
		if (x in cards): cards.remove(x)
		players[i].remove(0)
		players[i].append(x)

	if (y in players[i]):
		players[i].remove(y)
		players[i].append(0)
	else: cards.remove(y)

	i = i + 1