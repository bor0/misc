function findP(str) {
	var start = undefined;
	var end = undefined;
	var cnt = 0;
	for (var i = 0; i < str.length; i++) {
		if (str[i] == '(') {
			if (start === undefined) start = i;
			cnt++;
		} else if (str[i] == ')') {
			cnt--;
			if (cnt == 0) {
				end = i;
				break;
			}
		}
	}
	return [start, end];
}

function calcLispy(str) {
	if (str[0] == '(' && str[str.length - 1] == ')') {
		return calcLispy(str.slice(1, -1));
	}

	var tree = [];
	var op = '';

	if (['+','-','*','/'].includes(str[0])) {
		op = str[0];
		str = str.slice(1);
		while (str[0] == ' ') {
			str = str.slice(1);
		}
	}

	if (op == '') {
		return parseInt(str);
	}

	var ret = findP(str);
	var start = ret[0];
	var end = ret[1];

	if (!end) {
		tree = str.split(' ');
	} else {
		tree = [str.slice(0, start), str.slice(start, end + 1), str.slice(end+2)];
	}

	tree = tree.filter((x) => x != '').map(calcLispy);

	if (op == '+') return tree[0] + tree[1];
	if (op == '-') return tree[0] - tree[1];
	if (op == '*') return tree[0] * tree[1];
	if (op == '+') return tree[0] / tree[1];
}

console.log(calcLispy("1"))
console.log(calcLispy("(1)"))
console.log(calcLispy("(+ 1 2)"))
console.log(calcLispy("(+ (* 2 2) (* 3 10))"))
