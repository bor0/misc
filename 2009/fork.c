/*
The fork() system call will spawn a new child process which is an identical process to the parent except 
that has a new system process ID. The process is copied in memory from the parent and a new process structure
is assigned by the kernel. The return value of the function is which discriminates the two threads of execution.
A zero is returned by the fork function in the child's process.
*/
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
pid_t pid;
char *message;
int n; printf("fork program starting\n");
pid = fork();

switch(pid) {
case -1:
return 1;
case 0:
message = "this is the child process";
n = 3;
break;
default:
message = "this is the parent process";
n = 6;
break;
}

puts(message);

return 0;

}
