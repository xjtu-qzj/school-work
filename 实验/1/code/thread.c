/*
 * @Author: zjq 1070709586@qq.com
 * @Date: 2023-10-16 16:43:26
 * @LastEditors: zjq 1070709586@qq.com
 * @LastEditTime: 2023-10-16 16:51:34
 * @FilePath: \code\1-5.c
 * @Description: è¿™æ˜¯é»˜è?¤è?¾ç½®,è¯·è?¾ç½®`customMade`, æ‰“å¼€koroFileHeaderæŸ¥çœ‹é…ç½® è¿›è?Œè?¾ç½®: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AEint global = 0;
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int global = 0;

void *thread2_func()
{
    int i;
    for (i = 0; i < 100000; i++)
    {
        global = global + 100;
        
    }
    printf("thread2 global = %d\n", global);
}

void *thread1_func()
{
    int i;
    for (i = 0; i < 100000; i++)
    {
        global = global - 100;
        
    }
    printf("thread1 global = %d\n", global);
}

int main()
{
    int status;
    pthread_t tid_one, tid_two;
    // Create Thread 1
    status = pthread_create(&tid_one, NULL, thread1_func, NULL);
    if (status != 0)
    { //  error occured
        printf("thread1 default = %d\n", status);
        return 1;
    }
    printf("thread1 success create\n");

    // Create Thread 2
    status = pthread_create(&tid_two, NULL, thread2_func, NULL);
    if (status != 0)
    { //  error occured
        printf("thread1 default = %d\n", status);
        return 1;
    }
    printf("thread2 success create\n");
    
    //wait
    pthread_join(tid_one, NULL);
    pthread_join(tid_two, NULL);
    printf("gloabl = %d\n",global);
    return 0;
}