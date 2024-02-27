/*
 * @Author: zjq 1070709586@qq.com
 * @Date: 2023-10-16 15:00:52
 * @LastEditors: zjq 1070709586@qq.com
 * @LastEditTime: 2023-10-16 17:02:37
 * @FilePath: \code\1-1.c
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE//
 */
//给我这段程序写注释

#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>
#include <wait.h>

int main()
{

    pid_t pid, pid1;//
    pid = fork();//创建一个子进程
    if (pid < 0)
    { // error occured
        fprintf(stderr, "Fork Failed");
        return 1;
    }
    else if (pid == 0)
    { // child process
        pid1 = getpid();
        printf("child: pid = %d", pid);
        printf("child: pid1 = %d", pid1);
    }
    else
    { // parent process
        pid1 = getpid();
        printf("parent: pid = %d", pid);
        printf("parent: pid1 = %d", pid1);
        wait(NULL);
    }
    return 0;
}
