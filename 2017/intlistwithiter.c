#include <stdio.h>
#include "stackqueue.h"

int listtonumber_stack(list *l) {
	int sum = 0;

	while (list_count(l)) {
		sum = sum * 10 + list_pop(l);
	}

	return sum;
}

int listtonumber_queue(list *l) {
	int sum = 0;

	while (list_count(l)) {
		sum = sum * 10 + list_dequeue(l);
	}

	return sum;
}

list *numbertolist_stack(int n) {
	list *l = list_init();
	int x;

	list_push(l, n);

        while (list_count(l)) {
                x = list_pop(l);
		list_push(l, x % 10);

                if (x / 10) {
                        list_push(l, x / 10);
                } else {
                        break;
                }
        }

        return l;
}

list *numbertolist_queue(int n) {
	list *l = list_init();
	int x, flag;

	list_push(l, n);

        while (list_count(l)) {
		flag = 0;
                x = list_dequeue(l);

                if (x / 10) {
                        list_push(l, x / 10);
		} else {
			flag = 1;
		}

		// namesto so flag moze list_enqueue
		list_push(l, x % 10);

                if (flag) {
                        break;
                }
        }

        return l;
}

int main() {
	list *l = list_init();

	list_push(l, 1);
	list_push(l, 2);
	list_push(l, 3);

	printf("%d\n", listtonumber_stack(l)); // 321
	list_free(l);

	l = list_init();

	list_push(l, 1);
	list_push(l, 2);
	list_push(l, 3);

	printf("%d\n", listtonumber_queue(l)); // 123
	list_free(l);

	l = numbertolist_stack(123);
	list_print(l); // [3, 2, 1]
	list_free(l);

	l = numbertolist_queue(123);
	list_print(l); // [1, 2, 3]
	list_free(l);

	return 0;
}
