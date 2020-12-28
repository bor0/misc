#include <stdio.h>
#include <stdlib.h>
#define MAX_ELEMENTI 100

typedef struct element1 {
int info;
char ltag,rtag;
struct element1 *llink, *rlink;
} nanizano;

void inorderNizano(nanizano *b) {
if (b->ltag == '-') return;
inorderNizano(b->llink);
printf("%d\n", b->info);
if (b->rtag == '-') return;
inorderNizano(b->rlink);
}

void dodadi(nanizano *b, int a) {
static nanizano *n;
if (b->info < a) {
if (b->ltag == '-') {
	printf(";)\n");
n = (nanizano *)malloc(sizeof(nanizano));
n->llink = b->llink; n->ltag = b->ltag;
n->rlink = b; n->rtag = '-';
b->llink = n; b->ltag = '+';
return;
}
else dodadi(b->llink, a);
} else if (b->info > a) {
if (b->rtag == '-') {
n = (nanizano *)malloc(sizeof(nanizano));
n->rlink = b->rlink; n->rtag = b->rtag;
n->llink = b; n->ltag = '-';
b->rlink = n; b->rtag = '+';
return;
}
else dodadi(b->rlink, a);
}
}


nanizano *kreirajNizanoLeksi(int a[], int c) {
nanizano *vodac = (nanizano *)malloc(sizeof(nanizano));
int i;

vodac->rlink=vodac->llink= (nanizano *)malloc(sizeof(nanizano));
vodac->rlink->info = a[0];
vodac->ltag = vodac->rtag = '+';
vodac->rlink->ltag = vodac->llink->rtag = '-';
vodac->rlink->rlink = vodac->rlink->llink = vodac;

for (i=1;i<c;i++) dodadi(vodac->rlink, a[i]);
return vodac;
}


int main () {
nanizano *v;
int i=0, n, niza[MAX_ELEMENTI], scanOK;
while ((i<MAX_ELEMENTI)&&((scanOK=(scanf("%d",&n)))||1)&&(getchar()!=EOF)) {
if (n == -1) break;
if (scanOK) niza[i++]=n;
}

v = kreirajNizanoLeksi(niza, i);
inorderNizano(v->rlink);

printf("success");
return 0;
}
