/*
 * @Author: zjq 1070709586@qq.com
 * @Date: 2023-10-16 15:37:46
 * @LastEditors: zjq 1070709586@qq.com
 * @LastEditTime: 2023-10-16 15:58:57
 * @FilePath: \code\1-2.cpp
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>
#include <wait.h>
int global = 100;
int main()
{
    pid_t pid, pid1;
    // fork a child process
    pid = fork();
    if (pid < 0)
    { // error occured
        fprintf(stderr, "Fork Failed");
        return 1;
    }
    else if (pid == 0)
    { // child process
        pid1 = getpid();
        global += 2;
        printf("global = %d\n", global);
        printf("global address = %p\n", &global); // share address
        printf("child: pid = %d\n", pid);
        printf("child: pid1 = %d\n", pid1);
    }
    else
    { // parent process
        pid1 = getpid();
        global -= 2;
        printf("global = %d\n", global);
        printf("global address = %p\n", &global); // share address
        printf("parent: pid = %d\n", pid);
        printf("parent: pid1 = %d\n", pid1);
        wait(NULL);
    }

    printf("global = %d\n", global * global); // global^2
    return 0;
}