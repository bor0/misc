#include <stdio.h>
#include "stackqueue.h"

list *list_init() {
	list *l = malloc(sizeof(list));
	l->top = l->bottom = NULL;

	return l;
}

void list_free(list *l) {
	list_item *tmp;

	while (l->bottom) {
		tmp = l->bottom;
		l->bottom = l->bottom->next;
		free(tmp);
	}

	free(l);
}

void list_push(list *l, int value) {
	list_item *tmp = malloc(sizeof(list_item));
	tmp->value = value;
	tmp->next = NULL;
	tmp->prev = l->top;
	l->top = tmp;

	if (tmp->prev) {
		tmp->prev->next = tmp;
	}

	if (!l->bottom) {
		l->bottom = tmp;
	}
}

int list_pop(list *l) {
	int value;
	list_item *tmp;

	if (!l->top) {
		return -1;
	}

	tmp = l->top;
	l->top = tmp->prev;
	value = tmp->value;

	if (l->bottom == tmp) {
		l->bottom = NULL;
	}

	free(tmp);

	return value;
}

void list_enqueue(list *l, int value) {
	list_item *tmp = malloc(sizeof(list_item));
	tmp->value = value;
	tmp->next = l->bottom;
	tmp->prev = NULL;
	l->bottom = tmp;

	if (tmp->next) {
		tmp->next->prev = tmp;
	}

	if (!l->top) {
		l->top = tmp;
	}
}

int list_dequeue(list *l) {
	int value;
	list_item *tmp;

	if (!l->bottom) {
		return -1;
	}

	tmp = l->bottom;
	l->bottom = tmp->next;
	value = tmp->value;

	if (l->top == tmp) {
		l->top = NULL;
	}

	free(tmp);

	return value;
}

int list_count(list *l) {
	list_item *tmp = l->bottom;
	int count = 0;

	while (tmp) {
		count++;
		tmp = tmp->next;
	}

	return count;
}

void list_print(list *l) {
	list_item *tmp = l->bottom;

	while (tmp) {
		printf("%d, ", tmp->value);
		tmp = tmp->next;
	}
	printf("\n");
}
