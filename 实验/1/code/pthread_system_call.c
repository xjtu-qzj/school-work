#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
int main(int argc, char* argv[])
{  
    char num = *(char*)argv[1];
    // getpid() :����ID   pthread_self() :�߳�ID  syscall(SYS_gettid):�̵߳�PID
    printf("thread%c getpid: %d , the tid=%ld,syscall_pid=%ld\n",num, getpid(), pthread_self(), syscall(SYS_gettid));
    printf("thread%c return\n",num);
    return 0;
}