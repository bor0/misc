function listtonumber_stack(s) {
	var sum = 0;

	while (s.length) {
		sum = sum * 10 + s.pop();
	}

	return sum;
}

function listtonumber_queue(q) {
	var sum = 0;

	while (q.length) {
		sum = sum * 10 + q.shift();
	}

	return sum;
}

function numbertolist_stack(n) {
        var stack = [n];

        while (stack.length) {
                var x = stack.pop();
		stack.push(x % 10);

                if (parseInt(x / 10)) {
                        stack.push(parseInt(x / 10));
                } else {
                        break;
                }
        }

        return stack;
}

function numbertolist_queue(n) {
        var queue = [n];

        while (queue.length) {
		var flag = false;
                var x = queue.shift();

                if (parseInt(x / 10)) {
                        queue.push(parseInt(x / 10));
		} else {
			flag = true;
		}

		queue.push(x % 10);

                if (flag) {
                        break;
                }
        }

        return queue;
}

console.log(listtonumber_stack([1, 2, 3])); // 321
console.log(listtonumber_queue([1, 2, 3])); // 123

console.log(numbertolist_stack(123)); // [3, 2, 1]
console.log(numbertolist_queue(123)); // [1, 2, 3]
