typedef struct list_item {
	int value;
	struct list_item *next;
	struct list_item *prev;
} list_item;

typedef struct list {
	struct list_item *top, *bottom;
} list;

list *list_init();
void list_free(list *l);
void list_push(list *l, int value);
int list_pop(list *l);
void list_enqueue(list *l, int value);
int list_dequeue(list *l);
int list_count(list *l);
void list_print(list *l);
