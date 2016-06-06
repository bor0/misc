#include <stdio.h>

struct state;
typedef void state_fn(struct state *);

struct state {
    void (*next)(struct state *);
    int i; // data
};

//state_fn foo, bar;
void (*t)(struct state * state);
void (*t2)(struct state * state);

void foo(struct state * state) {
    printf("%s %i\n", "foo", ++state->i);
    state->next = t;
}

void bar(struct state * state) {
    printf("%s %i\n", "bar", ++state->i);
    state->next = state->i < 10 ? t2 : 0;
}

int main(void) {
t = bar;
t2=foo;
    struct state state = { t2, 0 };
    while(state.next) state.next(&state);
}
