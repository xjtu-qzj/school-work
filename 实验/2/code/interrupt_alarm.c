#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <signal.h>
int flag = 0;
void inter_handler(int sig)
{
    // change signal
    flag = 0;
    printf("\n%d stop test", sig);
}
void waiting()
{
    // initial  flag
    flag = 1;
    while (flag == 1)
    {
    }
}
int main()
{
    // TODO: 五秒之后或接收到两个信号

    pid_t pid1 = -1, pid2 = -1;
    //alarm(5);
    sleep(5);
    signal(SIGINT, inter_handler);
    signal(SIGQUIT, inter_handler);
    //signal(SIGALRM, inter_handler);
    // capture signal
    while (pid1 == -1)
        pid1 = fork();
    if (pid1 > 0)
    {
        while (pid2 == -1)
            pid2 = fork();
        if (pid2 > 0)
        {
            ///  父进程
           
            // wait signal
            waiting();

            // send signal
            kill(pid1, 16);
            kill(pid2, 17);

            // wait child process
            wait(0);
            wait(0);
            printf("\nParent process is killed!!\n");
        }
        else
        {
            // TODO: 子进程2
            flag = 1;
            signal(17, inter_handler);
            waiting();
            printf("\nChild process2 is killed by parent!!\n");
            return 0;
        }
    }
    else
    {
        // TODO：子进程1
        flag = 1;
        signal(16, inter_handler);
        waiting();
        printf("\nChild process1 is killed by parent!!\n");
        return 0;
    }
    return 0;
}