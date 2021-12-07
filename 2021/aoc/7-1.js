const fs = require('fs')
const data = fs.readFileSync('input', 'utf8')

L = data.split(",").map(x => parseInt(x))

mini = Infinity
for (const el1 of L) {
    let suma=0
    for (const el2 of L) {
        if (el1 == el2) continue
        suma += Math.abs(el1 - el2)
	}
	mini = Math.min(suma, mini)
}

console.log(mini)
