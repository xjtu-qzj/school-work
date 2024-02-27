#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#define input_number 10
#define block_num   4
#define total_input 12

int page[total_input];
int block[block_num];

struct Queue
{
    int head; // first in
    int rear; // first out
    // int num[block_num];
} queue;
//通过队列实现FIFO算法
struct Stack
{
    int top;
    int num[block_num];
} stack;
//通过栈实现LRU算法

// 寻找block中是否有num返回位置
int FIFO_Empty(int *block, int num)
{
    int empty = -1;
    for (int i = 0; i < block_num; i++)
    {
        if (block[i] == num)
        {
            return block_num + i;
        }

        if (block[i] == -1)
        {
            empty = i;
        }
    }
    return empty;
}

// 初始化变量
void page_init()
{

    for (int i = 0; i < total_input; i++)
    {
        page[i] = -1;
        block[i] =-1;
        stack.num[i] =-1;
    }
}

// 键盘输入
void input_keyboard()
{
    int i;
    int number;
    for (i = 0; i < total_input; i++)
    {
        printf("number = ");
        scanf("%d", &number);
        page[i] = number;
        if (page[i] < 0 || page[i] > total_input)
        {
            printf("error input\n");
            scanf("number : %d", &page[i]);
        }
    }
    printf("\nblock size : %d", block_num);
    printf("\nkeyboroad page number :");
    for (i = 0; i < total_input; i++)
    {
        printf(" %d ", page[i]);
    }
    printf("\n");
}

// 随机生成输入
void input_rand()
{
    int i;
    // 设置随机数种子
    srand(time(NULL));
    for (i = 0; i < total_input; i++)
    {
        page[i] = (rand() % input_number + 1);
    }
    printf("\nblock size : %d", block_num);
    printf("\nrandom page number :");
    for (i = 0; i < total_input; i++)
    {
        printf(" %d ", page[i]);
    }
    printf("\n");
}

// 显示界面
void display1()
{
    printf("\n");
    printf(" Set input Mode \n");
    printf("1 for rand input ---------- 2 for keyboard input  \n");
    printf("0 for Exit\n");
    printf("-----------------------------------------------------\n");
}

// 显示界面
void display2()
{
    printf("\n");
    printf(" Set Algorithm Mode \n");
    printf("1 for FIFO ---------- 2 for LRU  \n");
    printf("0 for Exit\n");
    printf("-----------------------------------------------------\n");
}


void FIFO()
{
    int miss = 0; // miss number
    double miss_rate;
    int num;
    int empty_flag;
    queue.head = block_num-1;
    queue.rear = block_num;
    printf("-----------------------------------------------------\n");
    printf("FIFO_Mode\n");
    
    for (num = 0; num < total_input; num++) // input coming
    {
        empty_flag = FIFO_Empty(block, page[num]);
        // printf("empty = %d \n",empty_flag);
        if (empty_flag >= block_num) // 命中
        {
            printf("successful hit %d\n", page[num]);
        }
        else if (empty_flag == -1) // 没有命中并且满了
        {
            miss++;
            block[queue.head] = page[num];
            if (queue.rear==0) {
                queue.rear =block_num-1;
            }
            else{
                queue.rear = (queue.rear - 1) % (block_num);
            }
            if (queue.head==0) {
                queue.head =block_num-1;
            }
            else{
                queue.head = (queue.head - 1) % (block_num);
            }
            
            
            //printf("rear = %d\n",queue.rear);
            //printf("head = %d\n",queue.head);
        }

        else// 没有命中并且没满
        {
            miss++;
            block[empty_flag] = page[num];
            if (queue.rear==0) {
                queue.rear =block_num-1;
            }
            else{
                queue.rear = (queue.rear - 1) % (block_num);
            }
            //printf("rear = %d\n",queue.rear);
        }
        printf("for %d time block:", num);
        for (int i = block_num-1; i >= 0; i--)
        {
            printf("%d ", block[i]);
        }
        printf("\n");
    }

    miss_rate = 100 * ((double)miss / total_input);
    printf("miss  = %d\n", miss);
    printf("miss rate = %.2f%%\n", miss_rate);
    printf("-----------------------------------------------------\n");
}

void LRU()
{
    int miss = 0; // miss number
    double miss_rate;
    int num;
    int pos = 0;
    int empty_flag;
    printf("-----------------------------------------------------\n");
    printf("LRU_Mode\n");
    for (num = 0; num < total_input; num++)
    {
        empty_flag = FIFO_Empty(block, page[num]);
        if (empty_flag >= block_num) // 命中
        {
            for (int i = 0; i < stack.top; i++)
            {
                if (page[num] == stack.num[i])
                {
                    pos = i;
                    break;
                }
            }
            // 更新栈结构体
            for (int i = pos + 1; i < stack.top; i++)
            {
                stack.num[i - 1] = stack.num[i];
            }
            stack.num[stack.top - 1] = page[num];
            printf("successful hit %d\n", page[num]);
        }

        else if (empty_flag == -1) // 没有命中并且满了
        {
            miss++;
            // 找到最远使用替换
            pos = FIFO_Empty(block, stack.num[0]) - block_num;
            printf("pos = %d\n",pos);
            block[pos] = page[num];

            // 更新结构体
            for (int i = 0; i < stack.top - 1; i++)
            {
                stack.num[i] = stack.num[i + 1];
            }
            stack.num[stack.top - 1] = page[num];
        }

        else// 没有命中并且没满
        {
            miss++;
            block[empty_flag] = page[num];
            stack.num[stack.top] = page[num];
            stack.top++;
        }
        printf("for %d time block:", num);
        for (int i = block_num-1; i >= 0; i--)
        {
            printf("%d ", block[i]);
        }
        printf("\n");
    }
    miss_rate = 100 * ((double)miss / total_input);
    printf("miss  = %d\n", miss);
    printf("miss rate = %.2f%%\n", miss_rate);
    printf("-----------------------------------------------------\n");
}

int main()
{
    int choice;
    int algorithm;

    while (1)
    {
        page_init();
        display1();
        fflush(stdin);
        scanf("%d", &choice);
        switch (choice)
        {
        case 1:
            input_rand();
            break;
        case 2:
            input_keyboard();
            break;
        case 0:
            exit(0);
        default:
            printf("error input\n");
            break;
        }
        display2();
        scanf("%d", &algorithm);
        switch (algorithm)
        {
        case 1:
            FIFO();
            break;
        case 2:
            LRU();
            break;
        case 0:
            exit(0);
            break;
        default:
            printf("error input\n");
            break;
        }
    }

    return 0;
}


