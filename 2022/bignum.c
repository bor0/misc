#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define MAX(a,b) (((a)>(b))?(a):(b))
#define MIN(a,b) (((a)>(b))?(a):(b))

typedef struct bignum {
	char *data;
	int length;
} bignum;

// create a bignum, given length (data is length+1 for null terminator)
bignum* mk_bignum(int length) {
	bignum *bn = (bignum *)malloc(sizeof(bignum));
	bn->length = length;
	bn->data = (char *)malloc(length + 1);
	memset(bn->data, '\0', length + 1);
	return bn;
}

// resize an existing bignum, copying contents
void resize_bignum(bignum *bn, int length) {
	char *data = (char *)malloc(length + 1);
	memcpy(data, bn->data, MIN(length, bn->length));
	free(bn->data);
	bn->data = data;
	bn->data[length] = '\0';
	bn->length = length;
}

void free_bignum(bignum *bn) {
	free(bn->data);
	free(bn);
}

// shift right a bignum, filling the blank space with prefix
void shr_bignum(bignum *bn, char prefix) {
	int i;
	resize_bignum(bn, bn->length + 1);
	for (i = strlen(bn->data); i > 0; i--) {
		bn->data[i] = bn->data[i-1];
	}
	bn->data[0] = prefix;
}

// shift left a bignum, filling the blank space with prefix
void shl_bignum(bignum *bn, char prefix) {
	int i;
	resize_bignum(bn, bn->length + 1);
	bn->data[bn->length-1] = prefix;
}

void trimlead0_bignum(bignum *bn) {
	int i, length;
	for (i = 0; i < bn->length && bn->data[i] == '0'; i++);
	if (i == bn->length) {
		resize_bignum(bn, 1);
		bn->data[0] = '0';
	} else if (i != 0) {
		length = strlen(bn->data + i);
		char *data = (char *)malloc(length + 1);
		memcpy(data, bn->data + i, length);
		free(bn->data);
		bn->data = data;
		bn->length = length;
	}
}

int int_length(int x) {
	int length = 0;
	while (x != 0) {
		length++;
		x /= 10;
	}
	return length;
}

bignum *from_int(int x) {
	int length = int_length(x);
	int i;
	bignum *bn = mk_bignum(length);

	for (i = length; i >= 0; i--) {
		bn->data[i - 1] = x % 10 + '0';
		x /= 10;
	}

	return bn;
}

bignum *from_string(char *x) {
	int length = strlen(x);
	bignum *bn = mk_bignum(length);

	memcpy(bn->data, x, length);

	return bn;
}

int cmp_bignum(bignum *a, bignum *b) {
	int i;
	if (a->length > b->length) return 1;
	if (a->length < b->length) return -1;

	return strcmp(a->data, b->data);
}

bignum *add_bignum(bignum *a, bignum *b) {
	bignum *res, *tmp;
	int i, j;
	int carry = 0;

	if (cmp_bignum(a, b) == -1) {
		tmp = b;
		b = a;
		a = tmp;
	}

	i = a->length - 1;
	j = b->length - 1;

	assert(i >= j);

	res = mk_bignum(a->length);

	while (i >= 0 && j >= 0) {
		res->data[i] = (a->data[i] - '0') + (b->data[j] - '0');

		// Bring carry
		if (carry) res->data[i]++;

		// Check if there's more stuff to carry
		carry = res->data[i] >= 10;

		// If we need to carry, only keep the most right digit
		if (carry) res->data[i] -= 10;

		res->data[i] += '0';
		i--; j--;
	}

	// Since `i >= j) (`a >= b`, then `i` might potentially have leftover, so process it
	while (i >= 0) {
		res->data[i] = a->data[i] - '0';
		if (carry) res->data[i]++;
		carry = res->data[i] >= 10;
		if (carry) res->data[i] -= 10;
		res->data[i] += '0';
		i--;
	}

	if (carry) {
		shr_bignum(res, '1');
	}

	return res;
}

bignum *sub_bignum(bignum *a, bignum *b) {
	bignum *res, *tmp;
	int i, j;
	int neg = 0;
	int borrow = 0;

	if (cmp_bignum(a, b) == -1) {
		tmp = b;
		b = a;
		a = tmp;
		neg = 1;
	}

	i = a->length - 1;
	j = b->length - 1;

	assert(i >= j);

	res = mk_bignum(a->length);

	while (i >= 0 && j >= 0) {
		res->data[i] = (a->data[i] - '0') - (b->data[j] - '0');

		// Bring borrow
		if (borrow) res->data[i]--;

		// Check if there's more stuff to borrow
		borrow = res->data[i] < 0;

		// If we need to borrow, only keep the most right digit
		if (borrow) res->data[i] += 10;

		res->data[i] += '0';
		i--; j--;
	}

	// Since `i >= j` (`a >= b`), then `i` might potentially have leftover, so process it
	while (i >= 0) {
		res->data[i] = a->data[i] - '0';
		if (borrow) res->data[i]--;
		borrow = res->data[i] < 0;
		if (borrow) res->data[i] += 10;
		res->data[i] += '0';
		i--;
	}

	trimlead0_bignum(res);

	if (neg) {
		shr_bignum(res, '-');
	}

	return res;
}

int main() {
	bignum *n1 = from_int(98);
	bignum *n2 = from_string("99");
	bignum *n3 = from_string("9223372036854775807");

	bignum *res1 = sub_bignum(n1, n2);
	bignum *res2 = sub_bignum(n2, n1);
	bignum *res3 = add_bignum(n1, n2);
	bignum *res4 = sub_bignum(n1, n1);
	bignum *res5 = add_bignum(n3, n3);

	printf("%s-%s=%s\n", n1->data, n2->data, res1->data);
	printf("%s-%s=%s\n", n2->data, n1->data, res2->data);
	printf("%s+%s=%s\n", n1->data, n2->data, res3->data);
	printf("%s-%s=%s\n", n1->data, n1->data, res4->data);
	printf("%s+%s=%s\n", n3->data, n3->data, res5->data);

	printf("cmp %s %s = %d\n", n1->data, n2->data, cmp_bignum(n1, n2));
	printf("cmp %s %s = %d\n", n2->data, n1->data, cmp_bignum(n2, n1));
	printf("cmp %s %s = %d\n", n1->data, n1->data, cmp_bignum(n1, n1));

	free_bignum(n1);
	free_bignum(n2);
	free_bignum(n3);
	free_bignum(res1);
	free_bignum(res2);
	free_bignum(res3);
	free_bignum(res4);
	free_bignum(res5);
	return 0;
}
