#include <unistd.h>
#include <sys/types.h>  
#include <sys/wait.h>
#include <signal.h>
#include<stdlib.h>
#include <stdio.h>
int pid1, pid2; // 定义两个进程变量
int main()
{
    int fd[2];
    char InPipe[4000]; // 定义读缓冲区
    char c1 = '1', c2 = '2';
    pipe(fd);
    // 创建管道
    while ((pid1 = fork()) == 1)
        ; // 如果进程1 创建不成功 则空循环
    if (pid1 == 0)
    { // 如果子进程1 创建成功, pid1 为进程号

        //  锁定管道
        lockf(fd[1], 1, 0);
        // TODO 分2000 次每次向管道写入字符’1’
        for (int i = 0; i < 2000; i++)
        {
            write(fd[1], &c1, 1);
        }
        sleep(5); // 等待读进程读出数据

        // TODO 解除管道的锁定
        lockf(fd[1], 0, 0);

        exit(0); // 结束进程1
    }
    else
    {
        while ((pid2 = fork()) == 1)
            ; // 若进程2 创建不成功 则空循环
        if (pid2 == 0)
        {
            lockf(fd[1], 1, 0);
            // 分2000 次每次向管道写入字符’2’
            for (int i = 0; i < 2000; i++)
            {
                write(fd[1], &c2, 1);
            }

            sleep(5);
            lockf(fd[1], 0, 0);
            exit(0);
        }
        else
        {
            wait(0);                                   // 等待子进程1 结束
            wait(0);                                   // 等待子进程2 结束
            int bytesRead = read(fd[0], InPipe, 4000); // 从管道中读出4000 个字符
            InPipe[bytesRead] = '\0';                  // 加字符串结束符
            printf("%s n", InPipe);                    // 显示读出的数据
            exit(0);                                   // 父进程结束
        }
    }
}