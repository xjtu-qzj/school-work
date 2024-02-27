#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
int global = 0;                                    // Declare a global variable
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; // Initialize a mutex lock
// Function for thread 1
void *thread1_func(void *arg)
{
    pthread_mutex_lock(&mutex); // Lock the mutex to ensure mutual exclusion
    // Decrement the global variable in a loop
    int i;
    for (i = 0; i < 5000; i++)
    {
        global = global - 200;
    }
    printf("thread1 global = %d\n", global);
    // Get thread's process id and thread id and execute a system call
    char num = '1';
    char command[100];
    printf("thread1 getpid: %d , the tid=%ld", getpid(), pthread_self());
    sprintf(command, "./pthread_system_call.out %c", num);
    system(command);
    pthread_mutex_unlock(&mutex); // Unlock the mutex
}

// Function for thread 2
void *thread2_func(void *arg)
{
    pthread_mutex_lock(&mutex); // Lock the mutex to ensure mutual exclusion
    // Increment the global variable in a loop
    int i;
    for (i = 0; i < 5000; i++)
    {
        global = global + 100;
    }
    printf("thread2 global = %d\n", global);
    // Get thread's process id and thread id and execute a system call
    char num = '2';
    char command[100];
    printf("thread2 getpid: %d , the tid=%ld", getpid(), pthread_self());
    sprintf(command, "./pthread_system_call.out %c ", num);
    system(command);
    pthread_mutex_unlock(&mutex); // Unlock the mutex
}

int main()
{
    int status;
    pthread_t tid_one, tid_two;
    // Create thread 1
    status = pthread_create(&tid_one, NULL, thread1_func, NULL);
    if (status != 0)
    {
        printf("thread1 default = %d\n", status);
        return 1;
    }
    printf("thread1 success create\n");
    // Create thread 2
    status = pthread_create(&tid_two, NULL, thread2_func, NULL);
    if (status != 0)
    {
        printf("thread2 default = %d\n", status);
        return 1;
    }
    printf("thread2 success create\n");
    // Wait for thread 1 to finish
    pthread_join(tid_one, NULL);
    // Wait for thread 2 to finish
    pthread_join(tid_two, NULL);
    // Destroy the mutex
    pthread_mutex_destroy(&mutex);
    printf("global = %d ", global); // Print the value of global variable
    return 0;
}