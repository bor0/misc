#include <stdio.h>
#include <string.h>

// made by roticv

typedef struct{
char data[1000];
int size;
}bigint;

bigint x,y,z,mod;
char str[10000];


int inttobigint(bigint *a, int b){
	int ii = 0;
	while (b!=0){
		a->data[ii] = b % 10;
		ii++;
		a->size = ii;
		b /= 10;
	}
	return 0;
}

/*a = b + c*/
int add(bigint *a, bigint *b, bigint *c){
	int max,ij,carry;
	if (b->size > c->size){
		max = b->size;
	}else
		max = c->size;
	a->size = max;
	carry = 0;
	for (ij=0;ij<max;ij++){
		if (ij >= b->size)
			b->data[ij] = 0;
		if (ij >= c->size)
			c->data[ij] = 0;
		a->data[ij] = b->data[ij] + c->data[ij] + carry;
		carry = a->data[ij] / 10;
		a->data[ij] %= 10;
	}
	if (carry!=0){
		a->data[ij] = carry;
		a->size++;
	}
	return 0;
}

/*a = b x c*/
int mul(bigint *a, bigint *b, bigint *c){
	int ij, ik, carry;
	a->size = b->size + c->size;
	for (ij=0;ij< a->size;ij++)
		a->data[ij] = 0;
	for (ij=0; ij<b->size; ij++){
		carry = 0;
		for (ik=0;ik<c->size; ik++){
			a->data[ij+ik] += b->data[ij] * c->data[ik] + carry;
			carry = a->data[ij+ik] / 10;
			a->data[ij+ik] %= 10;
		}
		if (carry!=0){
			a->data[ij+ik] +=carry;
		}
	}
	if (carry==0)
		a->size--;
	return 0;
}

/*a = b - c*/
int sub(bigint *a, bigint *b, bigint *c){
	int ii,v,borrow = 0;
	a->size = b->size;
	for (ii=0;ii<b->size;ii++){
		if (ii>=c->size)
			c->data[ii] = 0;
		v = b->data[ii] - c->data[ii] - borrow;
		if (v < 0){
			v += 10;
			borrow = 1;
		}else
			borrow = 0;
		a->data[ii] = v;
	}
	while ( (a->size > 1) && (a->data[a->size-1]==0))
		a->size--;
	return 0;
}

/*a = c / d & b = c % d*/
int div(bigint *a, bigint *b, bigint *c, bigint *d){
	int ii;
	bigint tmp;
	b->size = 1;
	b->data[0] = 0;
	a->size = c->size;
	for (ii=c->size-1;ii>=0;ii--){
		shl(b);
		b->data[0] = c->data[ii];
		a->data[ii] = 0;
		while (cmp(b,d)==1){
			a->data[ii]++;
			sub(&tmp, b, d);
			cpy(b,&tmp);
		}
	}
	while ( (a->size > 1) && (a->data[a->size-1]==0))
		a->size--;
	return 0;
}

/*a = b % c*/
int GCD(bigint *a, bigint *b, bigint *c){
	bigint a1,b1,mod,tmp,tmp2,v;
	if (cmp(b,c)==-1){
		cpy(&a1,c);
		cpy(&b1,b);
	}else{
		cpy(&a1,b);
		cpy(&b1,c);
	}
	while (1){
		if (b1.data[0] == 0 && b1.size==1)
			break;
		cpy(&tmp,&b1);
		div(&v,&tmp2,&a1,&b1);
		cpy(&a1,&tmp);
		cpy(&b1,&tmp2);
	}
	cpy(a,&a1);
	return 0;
}

int print(bigint *a){
	int ii;
	for (ii=a->size-1;ii>=0;ii--)
		printf("%c",a->data[ii]+'0');
	printf("\n");
	return 0;
}

int shl(bigint *a){
	int ii;
	if (a->size == 1 && a->data[0] == 0)
		return 0;
	for (ii=a->size-1;ii>=0;ii--)
		a->data[ii+1] = a->data[ii];
	a->data[0] = 0;
	a->size++;
	return 0;
}

/*a = b*/
int cpy(bigint *a, bigint *b){
	int ii;
	a->size = b->size;
	for (ii = 0; ii < a->size; ii++)
		a->data[ii] = b->data[ii];
	a->data[ii] = 0;
	return 0;
}

/*is a > b*/
int cmp(bigint *a, bigint *b){
	int ii;
	if (a->size < b->size)
		return -1;
	if (a->size > b->size)
		return 1;
	for (ii=a->size-1;ii>=0;ii--){
		if (a->data[ii] < b->data[ii])
			return -1;
		if (a->data[ii] > b->data[ii])
			return 1;
	}
	return 1;
}

int convert(bigint *a, char *s){
	int ij;
	a->size = strlen(s);
	for (ij=0;ij<a->size;ij++){
		a->data[ij] = s[a->size - ij - 1] - '0';
	}
	return 0;
}

int main(){
	int i;
	scanf("%s",str);
	convert(&x,str);
	scanf("%s",str);
	convert(&y,str);
	div(&z,&mod,&x,&y);
	for (i= z.size-1;i>= 0 ;i--){
		printf("%c",z.data[i]+'0');
	}
	printf("\n");
	print(&mod);
	return 0;
}



