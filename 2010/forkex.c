#include <stdio.h>
#include <sys/types.h>

int main() {

		pid_t pid;
		int i = 10;

		while (i != 0) {

				pid = fork();
				if (pid == 0) {
						printf("Hello from child no %d\n", i);
						break;
				} else {
						printf("Created child %d\n", i);
						i--;
				}
		}

		return 0;

}
