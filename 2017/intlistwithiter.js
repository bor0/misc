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
        var sum = 0;

        while (stack.length) {
                var x = stack.pop();

                if (x / 10) {
			stack.push(x % 10);
                        stack.push(parseInt(x / 10));
                } else {
                        break;
                }
        }

        return stack;
}

function numbertolist_queue(n) {
        var queue = [n];
        var sum = 0;

        while (queue.length) {
                var x = queue.shift();

                if (x / 10) {
			queue.unshift(x % 10);
                        queue.unshift(parseInt(x / 10));
                } else {
                        break;
                }
        }

        return queue;
}

console.log(listtonumber_stack([1, 2, 3])); // 321
console.log(listtonumber_queue([1, 2, 3])); // 123

console.log(numbertolist_stack(123)); // [3, 2, 1]
console.log(numbertolist_queue(123)); // [1, 2, 3]
