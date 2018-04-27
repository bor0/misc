from random import *

# Simple Random Distribution implementation
"""
The uniform or true random distribution describes the probability of random event that underlies no manipulation of the chance depending on earlier outcomes. This means that every "roll" operates independently.

The pseudo-random distribution (often shortened to PRD) in Dota 2 refers to a statistical mechanic of how certain probability-based items and abilities work. In this implementation the event's chance increases every time it does not occur, but is lower in the first place as compensation. This results in the effects occurring more consistently.

The probability of an effect to occur (or proc) on the Nth test since the last successful proc is given by P(N) = C x N. For each instance which could trigger the effect but does not, the PRD augments the probability of the effect happening for the next instance by a constant C. This constant, which is also the initial probability, is lower than the listed probability of the effect it is shadowing. Once the effect occurs, the counter is reset.
"""

def rd_run(critc, times = 1000000):
	counter   = 0
	critsofar = 0

	for i in range(0, times):
		crit   = random()

		# check for crit
		if crit < critsofar:
			counter += 1
			critsofar = critc
		else:
			critsofar += critc

	counter /= float(times)

	return counter

"""
C								Nominal Chance	Approximate C
0.003801658303553139101756466	5%				0.38%
0.014745844781072675877050816	10%				1.5%
0.032220914373087674975117359	15%				3.2%
0.055704042949781851858398652	20%				5.6%
0.084744091852316990275274806	25%				8.5%
0.118949192725403987583755553	30%				12%
0.157983098125747077557540462	35%				16%
0.201547413607754017070679639	40%				20%
0.249306998440163189714677100	45%				25%
0.302103025348741965169160432	50%				30%
0.360397850933168697104686803	55%				36%
0.422649730810374235490851220	60%				42%
0.481125478337229174401911323	65%				48%
0.571428571428571428571428572	70%				57%
0.666666666666666666666666667	75%				67%
0.750000000000000000000000000	80%				75%
0.823529411764705882352941177	85%				82%
0.888888888888888888888888889	90%				89%
0.947368421052631578947368421	95%				95%
"""
Cs = [ 0.003801658303553139101756466,
0.014745844781072675877050816,
0.032220914373087674975117359,
0.055704042949781851858398652,
0.084744091852316990275274806,
0.118949192725403987583755553,
0.157983098125747077557540462,
0.201547413607754017070679639,
0.249306998440163189714677100,
0.302103025348741965169160432,
0.360397850933168697104686803,
0.422649730810374235490851220,
0.481125478337229174401911323,
0.571428571428571428571428572,
0.666666666666666666666666667,
0.750000000000000000000000000,
0.823529411764705882352941177,
0.888888888888888888888888889,
0.947368421052631578947368421 ]

for C in Cs:
	print(rd_run(C))
