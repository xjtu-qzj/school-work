/*
 * @Author: zjq 1070709586@qq.com
 * @Date: 2023-10-16 16:43:26
 * @LastEditors: zjq 1070709586@qq.com
 * @LastEditTime: 2023-10-16 16:52:18
 * @FilePath: \code\1-5.c
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AEint global = 0;
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int global = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; // init static lock

void *thread2_func()
{
    pthread_mutex_lock(&mutex);
    int i;
    for (i = 0; i < 5000; i++)
    {
        global = global + 100;
        printf("thread2 global = %d\n", global);
    }
    pthread_mutex_unlock(&mutex); // unlock
}

void *thread1_func()
{
    pthread_mutex_lock(&mutex); // lock
    int i;
    for (i = 0; i < 5000; i++)
    {
        global = global - 100;
        printf("thread1 global = %d\n", global);
    }
    pthread_mutex_unlock(&mutex); // unlock
}

int main()
{
    int status;
    pthread_t tid_one, tid_two;
    status = pthread_create(&tid_one, NULL, thread1_func, NULL);
    if (status != 0)
    { //
        printf("thread1 default = %d\n", status);
        return 1;
    }
    printf("thread1 success create\n");

    status = pthread_create(&tid_two, NULL, thread2_func, NULL);
    if (status != 0)
    { //
        printf("thread1 default = %d\n", status);
        return 1;
    }
    printf("thread2 success create\n");

    pthread_join(tid_one, NULL);
    
    pthread_join(tid_two, NULL);
    // destory mutex
    pthread_mutex_destroy(&mutex);
    return 0;
}