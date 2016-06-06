#include <threads.h>
#include <stdio.h>
#include <unistd.h>

int status = 0;

static int do1(void *t) {
	printf("%d\n", (int)t);
	sleep(5);
	status += 1;
	return 0;
}
 
static int do2(void *t) {
	printf("2\n");
	status += 2;
	return 0;
}
 
int main(int argc, char *argv[])
{
	thrd_t thr1, thr2;
	thrd_create(&thr1, do1, (void *)1234);
	thrd_create(&thr2, do2, 0);
	thrd_join(thr2, 0);
	thrd_join(thr1, 0);

	// Thread execution blocked until do1 and do2 are completed

	return 0;
}
