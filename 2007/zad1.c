		#include <stdio.h>
#include <stdlib.h>
#define MAX_ELEMENTI 100

typedef struct element1 {
int info;
struct element1 *llink, *rlink;
} steblo;

typedef struct element2 {
} nanizano;

void inorder(steblo *k) {
if (k) {
inorder(k->llink);
printf("[%d]\n", k->info);
inorder(k->rlink);
}
}

void preorder(steblo *k) {
if (k) {
printf("[%d]\n", k->info);
preorder(k->llink);
preorder(k->rlink);
}
}

steblo *kreirajLeksi(int a[], int b) {
steblo *start = (steblo *)malloc(sizeof(steblo)), *n;
start->info = a[0]; int i;

void dodadiLeksi(steblo *b) {

if (b->info > a[i]) {
if (b->llink != 0) dodadiLeksi(b->llink);
else { b->llink = (steblo *)malloc(sizeof(steblo)); b->llink->info = a[i]; } }

else if (b->info < a[i]) {
if (b->rlink != 0) dodadiLeksi(b->rlink);
else { b->rlink = (steblo *)malloc(sizeof(steblo)); b->rlink->info = a[i]; } }

}

for (i=1;i<b;i++) dodadiLeksi(start);

return start;
}

int main () {
steblo *k;
//nanizano *v, kreirajNizanoLeksi(int[], int);
int i=0, n, niza[MAX_ELEMENTI], scanOK;
while ((i<MAX_ELEMENTI)&&((scanOK=(scanf("%d",&n)))||1)&&(getchar()!=EOF)) {
if (n == -1) break;
if (scanOK) niza[i++]=n;
}

k = kreirajLeksi(niza, i);
preorder(k);
printf("--\n");
inorder(k);

/*
b = kreirajNizanoLeksi(niza, i);
inorderNizano(v);
*/

return 0;
}
