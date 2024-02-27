#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
int global = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *thread1_func(void* arg)
{
    pthread_mutex_lock(&mutex);
    int i;
    for (i = 0; i < 5000; i++)
    {
        global++;
    }
    printf("thread1 getpid: %d , the tid=%ld", getpid(), pthread_self());
    printf("global = %d\n", global);
     execl("/root/code/1/pthread_system_call", "pthread_system_call", "1",NULL);
    pthread_mutex_unlock(&mutex);
}

void *thread2_func(void* arg)
{
    pthread_mutex_lock(&mutex);
    int i;
    for (i = 0; i < 5000; i++)
    {
        global = global -1;
    }
    printf("thread2 getpid: %d , the tid=%ld", getpid(), pthread_self());
    printf("global = %d\n", global);
    execl("/root/code/1/pthread_system_call", "pthread_system_call", "2",NULL);
    pthread_mutex_unlock(&mutex);
}


int main()
{
    int status;
    pthread_t tid_one, tid_two;
    // thread 1
    status = pthread_create(&tid_one, NULL, thread1_func, NULL);
    if (status != 0)
    { // error occured
        printf("thread1 default = %d\n", status);
        return 1;
    }
    printf("thread1 success create\n");

    // thread 2
    status = pthread_create(&tid_two, NULL, thread2_func, NULL);
    if (status != 0)
    { // error occured
        printf("thread2 default = %d\n", status);
        return 1;
    }
     printf("thread2 success create\n");
    pthread_join(tid_one, NULL);
    pthread_join(tid_two, NULL);
    pthread_mutex_destroy(&mutex);
    printf("global = %d ", global);
    return 0;
}