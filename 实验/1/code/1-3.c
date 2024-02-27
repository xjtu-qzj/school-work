/*
 * @Author: zjq 1070709586@qq.com
 * @Date: 2023-10-16 16:03:30
 * @LastEditors: zjq 1070709586@qq.com
 * @LastEditTime: 2023-10-16 16:18:13
 * @FilePath: \code\1-3.c
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>
#include <wait.h>

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
        printf("child: pid1 = %d\n", pid1);
        system("./system_call"); // call function
    }
    else
    { // parent process
        pid1 = getpid();
        printf("parent: pid = %d\n", pid);
        printf("parent: pid1 = %d\n", pid1);
        wait(NULL);
    }
    return 0;
}