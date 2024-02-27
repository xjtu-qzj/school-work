/*
 * @Author: zjq 1070709586@qq.com
 * @Date: 2023-10-16 16:09:43
 * @LastEditors: zjq 1070709586@qq.com
 * @LastEditTime: 2023-10-16 16:10:53
 * @FilePath: \code\system_child_process.c
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>

int main()
{
    pid_t pid = getpid();
    printf("system_call pid = %d\n", pid);   //print pid
    return 0;
}
