#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// To check leaks, first compile:
// gcc gentzen.c && ./a.out
//
// And then:
// leaks -atExit -- ./a.out | grep LEAK:
//
// Debug info:
// gcc -g -fsanitize=address gentzen.c && ./a.out

typedef struct BinaryOp BinaryOp;
typedef struct UnaryOp UnaryOp;
typedef struct PropCalc PropCalc;
typedef struct Proof Proof;

// PropCalc and Proof structures
struct BinaryOp {
	PropCalc *l;
	PropCalc *r;
};

struct UnaryOp {
	PropCalc *v;
};

struct PropCalc {
	enum { Var, Not, And, Or, Imp } tag;
	union {
		char var;
		UnaryOp unop;
		BinaryOp binop;
	} data;
};

struct Proof {
	PropCalc *x;
};

// Proof helpers
Proof *mk_proof(PropCalc *a) {
	Proof *prf = (Proof *)malloc(sizeof(Proof));
	prf->x = a;
	return prf;
}

PropCalc *from_proof(Proof *a) {
	return a->x;
}

// Memory helpers
void free_propcalc(PropCalc *x) {
	if (x->tag == Not) {
		free_propcalc(x->data.unop.v);
	} else if (x->tag != Var) {
		free_propcalc(x->data.binop.l);
		free_propcalc(x->data.binop.r);
	}
	free(x);
}

void free_proof(Proof *x) {
	free_propcalc(x->x);
	free(x);
}

// Printers
void _print_propcalc(PropCalc *x) {
	switch (x->tag) {
		case Var:
			printf("%c", x->data.var);
			break;
		case Not:
			printf("!");
			_print_propcalc(x->data.unop.v);
			break;
		case And:
			_print_propcalc(x->data.binop.l);
			printf("&");
			_print_propcalc(x->data.binop.r);
			break;
		case Or:
			_print_propcalc(x->data.binop.l);
			printf("|");
			_print_propcalc(x->data.binop.r);
			break;
		case Imp:
			_print_propcalc(x->data.binop.l);
			printf("->");
			_print_propcalc(x->data.binop.r);
			break;
	}
}

void print_propcalc(PropCalc *x) {
	_print_propcalc(x);
	printf("\n");
}

void print_proof(Proof *x) {
	if (x == NULL) {
		printf("No proof.\n");
		return;
	}

	printf("|- ");
	print_propcalc(x->x);
}

// Constructors (terms)
PropCalc *tm_var(char a) {
	PropCalc *var = (PropCalc *)malloc(sizeof(PropCalc));

	var->tag = Var;
	var->data.var = a;

	return var;
}

PropCalc *tm_not(PropCalc *a) {
	PropCalc *data = (PropCalc *)malloc(sizeof(PropCalc));
	UnaryOp op = { .v = a };

	data->tag = Not;
	data->data.unop = op;

	return data;
}

PropCalc *tm_and(PropCalc *a, PropCalc *b) {
	PropCalc *data = (PropCalc *)malloc(sizeof(PropCalc));
	BinaryOp op = { .l = a, .r = b };

	data->tag = And;
	data->data.binop = op;

	return data;
}

PropCalc *tm_or(PropCalc *a, PropCalc *b) {
	PropCalc *data = (PropCalc *)malloc(sizeof(PropCalc));
	BinaryOp op = { .l = a, .r = b };

	data->tag = Or;
	data->data.binop = op;

	return data;
}

PropCalc *tm_imp(PropCalc *a, PropCalc *b) {
	PropCalc *data = (PropCalc *)malloc(sizeof(PropCalc));
	BinaryOp op = { .l = a, .r = b };

	data->tag = Imp;
	data->data.binop = op;

	return data;
}

// Constructors (rules)
Proof *rule_join(Proof *a, Proof *b) {
	return mk_proof(tm_and(from_proof(a), from_proof(b)));
}

Proof *rule_sep_l(Proof *a) {
	PropCalc *p = from_proof(a);
	if (p->tag != And) {
		return NULL;
	}

	return mk_proof(p->data.binop.l);
}

Proof *rule_double_tilde_intro(Proof *a) {
	PropCalc *tm_a = from_proof(a);

	free(a);

	return mk_proof(tm_not(tm_not(tm_a)));
}

Proof *rule_double_tilde_elim(Proof *a) {
	PropCalc *tm_a = from_proof(a);

	if (tm_a->tag != Not) {
		return NULL;
	}

	PropCalc *tm_aa = tm_a->data.unop.v;

	if (tm_aa->tag != Not) {
		return NULL;
	}

	Proof *prf = mk_proof(tm_aa->data.unop.v);

	free(tm_a);
	free(tm_aa);
	free(a);

	return prf;
}


Proof *rule_fantasy(PropCalc *a, Proof *(*f)(Proof *a)) {
	Proof *prfA = mk_proof(a);

	Proof *prfA2 = f(prfA);

	free(prfA);

	if (prfA2 == NULL) {
		return NULL;
	}

	PropCalc *tm_prfA2 = (PropCalc *)malloc(sizeof(PropCalc));
	memcpy(tm_prfA2, from_proof(prfA2), sizeof(PropCalc));

	free(prfA2);

	return mk_proof(tm_imp(a, tm_prfA2));
}

void eg1() {
	PropCalc *a = tm_var('a');
	PropCalc *b = tm_var('b');
	PropCalc *a_and_b = tm_and(a, b);
	print_propcalc(a_and_b);
	free_propcalc(a_and_b);
}

void eg2() {
	PropCalc *a = tm_var('a');
	PropCalc *b = tm_var('b');
	PropCalc *a_and_b = tm_and(a, b);

	Proof *prfa_and_b_to_a = rule_fantasy(a_and_b, rule_sep_l);
	print_proof(prfa_and_b_to_a);

	free_proof(prfa_and_b_to_a);
}

void eg3() {
	PropCalc *a = tm_var('a');
	PropCalc *b = tm_var('b');
	PropCalc *a_and_b = tm_and(a, b);

	Proof *prfa_and_b_to_a = rule_fantasy(a_and_b, rule_sep_l);

	Proof *double_neg = rule_double_tilde_intro(prfa_and_b_to_a);
	print_proof(double_neg);

	free_proof(double_neg);
}

void eg4() {
	PropCalc *a = tm_var('a');
	PropCalc *b = tm_var('b');
	PropCalc *a_and_b = tm_and(a, b);

	Proof *prfa_and_b_to_a = rule_fantasy(a_and_b, rule_sep_l);

	Proof *double_neg = rule_double_tilde_intro(prfa_and_b_to_a);
	Proof *double_neg_elim = rule_double_tilde_elim(double_neg);

	print_proof(double_neg_elim);
	free_proof(double_neg_elim);
}

int main() {
	eg1();
	eg2();
	eg3();
	eg4();
	return 0;
}
