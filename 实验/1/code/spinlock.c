#include <stdio.h>
#include <pthread.h>

typedef struct
{
    int flag;
} spinlock_t;

// 初始化自旋锁
void spinlock_init(spinlock_t *lock)
{
    lock->flag = 0;
}

void spinlock_lock(spinlock_t *lock)
{
    while (__sync_lock_test_and_set(&lock->flag, 1))
    {
        // 自旋等待
    }
}

void spinlock_unlock(spinlock_t *lock)
{
    __sync_lock_release(&lock->flag);
}

int shared_value = 0;

// 线程函数
void *thread_function(void *arg)
{
    spinlock_t *lock = (spinlock_t *)arg;

    for (int i = 0; i < 5000; ++i)
    {
        spinlock_lock(lock);
        shared_value++;
        spinlock_unlock(lock);
    }

    return NULL;
}

int main()
{
    pthread_t thread1, thread2;
    spinlock_t lock;
    int status;
    spinlock_init(&lock);

    // 输出共享变量的值
    printf("initial: %d\n", shared_value);

    // thread 1
    status = pthread_create(&thread1, NULL, thread_function, &lock);
    if (status != 0)
    {
        printf("thread1 default = %d\n ", status);
        return 1;
    }
    printf("thread1 success create\n");

    // thread 2
    pthread_create(&thread2, NULL, thread_function, &lock);
    if (status != 0)
    {
        printf("threa2 default = %d\n ", status);
        return 1;
    }
    printf("thread2 success create\n");
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    // 输出共享变量的值
    printf("final: %d\n", shared_value);

    return 0;
}