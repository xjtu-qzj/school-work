#include "ext2.h"

// 写gdt
static void update_group_desc()
{
    fp = fopen("./FS.txt", "rb+");
    fseek(fp, GDT_START, SEEK_SET);
    fwrite(&gdt, GD_SIZE, 1, fp);
    fflush(fp);
}

// 读gdt
static void reload_group_desc()
{
    fseek(fp, GDT_START, SEEK_SET);
    fread(&gdt, GD_SIZE, 1, fp);
}

// 写inode
static void update_inode_entry(unsigned short i)
{
    fp = fopen("./FS.txt", "rb+");
    fseek(fp, INODE_TABLE + (i - 1) * INODE_SIZE, SEEK_SET);
    fwrite(&inode_buff, INODE_SIZE, 1, fp);
    fflush(fp);
}

// 读inode
static void reload_inode_entry(unsigned short i)
{
    fseek(fp, INODE_TABLE + (i - 1) * INODE_SIZE, SEEK_SET);
    fread(&inode_buff, INODE_SIZE, 1, fp);
}

// 写dir
static void update_dir(unsigned short i)
{
    fp = fopen("./FS.txt", "rb+");
    fseek(fp, DATA_BLOCK + i * BLOCK_SIZE, SEEK_SET);
    fwrite(dir, BLOCK_SIZE, 1, fp);
    fflush(fp);
}

// 读dir
static void reload_dir(unsigned short i)
{
    fseek(fp, DATA_BLOCK + i * BLOCK_SIZE, SEEK_SET);
    fread(dir, BLOCK_SIZE, 1, fp);
}

// 写 blockmap
static void update_block_bitmap()
{
    fp = fopen("./FS.txt", "rb+");
    fseek(fp, BLOCK_BITMAP, SEEK_SET);
    fwrite(bitbuf, BLOCK_SIZE, 1, fp);
    fflush(fp);
}

// 读 blockmap
static void reload_block_bitmap()
{
    fseek(fp, BLOCK_BITMAP, SEEK_SET);
    fread(bitbuf, BLOCK_SIZE, 1, fp);
}

// 写 inodemap
static void update_inode_bitmap()
{
    fp = fopen("./FS.txt", "rb+");
    fseek(fp, INODE_BITMAP, SEEK_SET);
    fwrite(ibuf, BLOCK_SIZE, 1, fp);
    fflush(fp);
}

// 读 inodemap
static void reload_inode_bitmap()
{
    fseek(fp, INODE_BITMAP, SEEK_SET);
    fread(ibuf, BLOCK_SIZE, 1, fp);
}

// 写data_block
static void update_block(unsigned short i)
{
    fp = fopen("./FS.txt", "rb+");
    fseek(fp, DATA_BLOCK + i * BLOCK_SIZE, SEEK_SET);
    fwrite(Buffer, BLOCK_SIZE, 1, fp);
    fflush(fp);
}

// 写data_block
static void update_block_1(unsigned short i)
{
    fp = fopen("./FS.txt", "rb+");
    fseek(fp, DATA_BLOCK + i * BLOCK_SIZE, SEEK_SET);
    fwrite(buffer_1, BLOCK_SIZE, 1, fp);
    fflush(fp);
}

// 读data_block
static void reload_block(unsigned short i)
{
    fseek(fp, DATA_BLOCK + i * BLOCK_SIZE, SEEK_SET);
    fread(Buffer, BLOCK_SIZE, 1, fp);
}

// 读data_block
static void reload_block_1(unsigned short i)
{
    fseek(fp, DATA_BLOCK + i * BLOCK_SIZE, SEEK_SET);
    fread(buffer_1, BLOCK_SIZE, 1, fp);
}

// 分配data_block
static int alloc_block()
{
    int flag = 0;
    if (gdt.bg_free_blocks_count == 0)
    {
        printf("There is no block to be allocated!\n");
        return (0);
    }
    reload_block_bitmap();
    for (int i = 0; i < 512; i++)
    {
        if (bitbuf[i] != 0xff)
        {
            for (int j = 0; j < 8; j++)
            {
                if ((bitbuf[i] & (1 << j)) == 0)
                {
                    bitbuf[i] |= (1 << j);
                    last_alloc_block = i * 8 + j;
                    break;
                }
            }
            break;
        }
    }

    update_block_bitmap();
    gdt.bg_free_blocks_count--;
    update_group_desc();
    return last_alloc_block;
}

// 分配inode
static int get_inode()
{
    int flag = 0;
    if (gdt.bg_free_inodes_count == 0)
    {
        printf("There is no Inode to be allocated!\n");
        return 0;
    }
    reload_inode_bitmap();

    for (int i = 0; i < 512; i++)
    {
        if (ibuf[i] != 0xff)
        {
            for (int j = 0; j < 8; j++)
            {
                if ((ibuf[i] & (1 << j)) == 0)
                {
                    ibuf[i] |= (1 << j);
                    last_alloc_inode = i * 8 + j + 1;
                    break;
                }
            }
            break;
        }
    }
    update_inode_bitmap();
    gdt.bg_free_inodes_count--;
    update_group_desc();
    return last_alloc_inode;
}

// 查找
static unsigned short research_file(char tmp[100], int file_type, unsigned short *inode_num,
                                    unsigned short *block_num, unsigned short *dir_num)
{
    unsigned short j, k;
    reload_inode_entry(current_dir); // 进入当前目录
    j = 0;
    while (j < inode_buff.i_blocks)
    {
        reload_dir(inode_buff.i_block[j]);
        k = 0;
        while (k < 32)
        {
            if (!dir[k].inode || dir[k].file_type != file_type || strcmp(dir[k].name, tmp))
            {
                k++;
            }
            else
            {
                *inode_num = dir[k].inode;
                *block_num = j;
                *dir_num = k;
                return 1;
            }
        }
        j++;
    }
    return 0;
}

// 为新增目录或文件分配
static void dir_prepare(unsigned short tmp, unsigned short len, int type, char name[100])
{
    reload_inode_entry(tmp);

    time_t Time;
    time(&Time);
    if (type == 2)
    { // dir
        inode_buff.i_size = 32;
        inode_buff.i_blocks = 1;
        inode_buff.i_block[0] = alloc_block();
        inode_buff.i_ctime = Time;
        inode_buff.i_mtime = Time;
        inode_buff.i_atime = Time;
        dir[0].inode = tmp;
        dir[1].inode = current_dir;
        dir[0].name_len = len;
        dir[1].name_len = current_dirlen;
        dir[0].file_type = dir[1].file_type = 2;

        for (type = 2; type < 32; type++)
            dir[type].inode = 0;
        strcpy(dir[0].name, ".");
        strcpy(dir[1].name, "..");
        update_dir(inode_buff.i_block[0]);

        inode_buff.i_mode = 6;
    }
    else
    {
        inode_buff.i_size = 0;
        inode_buff.i_blocks = 0;
        inode_buff.i_mode = 6;
        inode_buff.i_ctime = Time;
        inode_buff.i_mtime = Time;
        inode_buff.i_atime = Time;
        int len = strlen(name);
        if (len < 4)
        {
           inode_buff.i_mode |= 1;
        }
        else
        {
            char *lastFour = &name[len - 4];
            if (strcmp(lastFour, ".exe") == 0 || strcmp(lastFour, ".bin") == 0 || strcmp(lastFour, ".com") == 0)
            {
                inode_buff.i_mode |= 1;
            }
            else
            {
                    ;
            }
        }
    }
    update_inode_entry(tmp);
}

// 删除data_block
static void remove_block(unsigned short del_num)
{
    unsigned short tmp;
    tmp = del_num / 8;
    reload_block_bitmap();
    switch (del_num % 8)
    { // 更新block位图 将具体的位置为0
    case 0:
        bitbuf[tmp] = bitbuf[tmp] & 127;
        break; 
    case 1:
        bitbuf[tmp] = bitbuf[tmp] & 191;
        break; 
    case 2:
        bitbuf[tmp] = bitbuf[tmp] & 223;
        break;
    case 3:
        bitbuf[tmp] = bitbuf[tmp] & 239;
        break; 
    case 4:
        bitbuf[tmp] = bitbuf[tmp] & 247;
        break;
    case 5:
        bitbuf[tmp] = bitbuf[tmp] & 251;
        break; 
    case 6:
        bitbuf[tmp] = bitbuf[tmp] & 253;
        break; 
    case 7:
        bitbuf[tmp] = bitbuf[tmp] & 254;
        break; 
    }
    update_block_bitmap();
    gdt.bg_free_blocks_count++;
    update_group_desc();
}

// 删除inode
static void remove_inode(unsigned short del_num)
{
    unsigned short tmp;
    tmp = (del_num - 1) / 8;
    reload_inode_bitmap();
    switch ((del_num - 1) % 8)
    { // 更改block位图
    case 0:
        bitbuf[tmp] = bitbuf[tmp] & 127;
        break;
    case 1:
        bitbuf[tmp] = bitbuf[tmp] & 191;
        break;
    case 2:
        bitbuf[tmp] = bitbuf[tmp] & 223;
        break;
    case 3:
        bitbuf[tmp] = bitbuf[tmp] & 239;
        break;
    case 4:
        bitbuf[tmp] = bitbuf[tmp] & 247;
        break;
    case 5:
        bitbuf[tmp] = bitbuf[tmp] & 251;
        break;
    case 6:
        bitbuf[tmp] = bitbuf[tmp] & 253;
        break;
    case 7:
        bitbuf[tmp] = bitbuf[tmp] & 254;
        break;
    }
    update_inode_bitmap();
    gdt.bg_free_inodes_count++;
    update_group_desc();
}

// 在打开文件表中查找是否已打开文件
static unsigned short search_file(unsigned short Inode)
{
    unsigned short fopen_table_point = 0;
    while (fopen_table_point < 16 && fopen_table[fopen_table_point++] != Inode)
        ;
    if (fopen_table_point == 16)
    {
        return 0;
    }
    return 1;
}

// 初始化磁盘
void initialize_disk()
{
    int i = 0;
    printf("Creating the ext2 file system\n");
    last_alloc_inode = 1;
    last_alloc_block = 0;
    for (i = 0; i < FOPEN_TABLE_MAX; i++)
    {
        fopen_table[i] = 0; // 清空缓冲表
    }
    for (i = 0; i < BLOCK_SIZE; i++)
    {
        Buffer[i] = 0; // 清空缓冲区
    }
    if (fp != NULL)
    {
        fclose(fp);
    }
    fp = fopen("./FS.txt", "w+");    // 此文件大小是4612*512=2361344B, 用此文件来模拟文件系统
    fseek(fp, DISK_START, SEEK_SET); // 将文件指针从0开始
    for (i = 0; i < DISK_SIZE; i++)
    {
        // 清空文件, 即清空磁盘全部用0填充, Buffer为缓冲区起始地址, BLOCK_SIZE表示读取大小, 1表示写入对象的个数
        fwrite(Buffer, BLOCK_SIZE, 1, fp);
    }

    // 根目录的inode号为1
    reload_inode_entry(1);

    reload_dir(0);
    // 修改路径名为根目录
    strcpy(current_path, "");
    strcat(current_path, "[");
    strcat(current_path, current_user);
    strcat(current_path, "@FS.txt /");

    // 初始化组描述符内容
    reload_group_desc();
    gdt.bg_block_bitmap = BLOCK_BITMAP;            // 第一个块位图的起始地址
    gdt.bg_inode_bitmap = INODE_BITMAP;            // 第一个inode位图的起始地址
    gdt.bg_inode_table = INODE_TABLE;              // inode表的起始地址
    gdt.bg_free_blocks_count = DATA_BLOCK_COUNTS;  // 空闲数据块数
    gdt.bg_free_inodes_count = INODE_TABLE_COUNTS; // 空闲inode数
    gdt.bg_used_dirs_count = 0;                    // 初始分配给目录的节点数是0
    update_group_desc();                           // 更新组描述符内容

    reload_block_bitmap();
    reload_inode_bitmap();

    inode_buff.i_mode = 518;
    inode_buff.i_blocks = 0;
    inode_buff.i_size = 32;
    inode_buff.i_atime = 0;
    inode_buff.i_ctime = 0;
    inode_buff.i_mtime = 0;
    inode_buff.i_dtime = 0;
    inode_buff.i_block[0] = alloc_block(); // 分配数据块
    inode_buff.i_blocks++;
    current_dir = get_inode();
    update_inode_entry(current_dir);

    // 初始化根目录的目录项
    dir[0].inode = dir[1].inode = current_dir;
    dir[0].name_len = 0;
    dir[1].name_len = 0;
    dir[0].file_type = dir[1].file_type = 2;
    strcpy(dir[0].name, ".");
    strcpy(dir[1].name, "..");
    update_dir(inode_buff.i_block[0]);
    printf("The ext2 file system has been installed!\n");
    // check_disk();
    // fclose(fp);
}

// 初始化用户信息
void initialize_user()
{
    // 创建password.txt
    FILE *fp;
    fp = fopen("./password.txt", "r+");
    if (fp == NULL)
    {
        fp = fopen("./password.txt", "w+");
        // 初始化用户信息
        strcpy(User[0].username, "test");
        strcpy(User[0].password, "test");

        strcpy(User[1].username, "user");
        strcpy(User[1].password, "user");

        strcpy(User[2].username, "root");
        strcpy(User[2].password, "root");

        strcpy(User[3].username, "admin");
        strcpy(User[3].password, "admin");
        fwrite(User, sizeof(struct user), USER_MAX, fp);
        printf("The password.txt has been created!\n");
        fclose(fp);
    }
    // 读取password.txt
    fp = fopen("./password.txt", "r+");
    fread(User, sizeof(struct user), USER_MAX, fp);
    fclose(fp);
    return;
}

// 修改密码
void password_change(char username[10], char password[10])
{
    for (int i = 0; i < USER_MAX; i++)
    {
        if (!strcmp(User[i].username, username))
        {
            strcpy(User[i].password, password);
            fp = fopen("./password.txt", "w+");
            fwrite(User, sizeof(struct user), USER_MAX, fp);
            break;
        }
    }
    return;
}

// 用户登录
int login(char username[10], char password[10])
{

    for (int i = 0; i < USER_MAX; i++)
    {
        if (!strcmp(User[i].username, username))
        {
            if (!strcmp(User[i].password, password))
                return 1;
            break;
        }
    }
    return 0;
}

// 初始化内存
void initialize_memory()
{
    int i = 0;
    last_alloc_inode = 1;
    last_alloc_block = 0;
    for (i = 0; i < FOPEN_TABLE_MAX; i++)
    {
        fopen_table[i] = 0;
    }
    strcpy(current_path, "");
    strcat(current_path, "[");
    strcat(current_path, current_user);
    strcat(current_path, "@ext2 /");
    current_dir = 1;
    fp = fopen("./FS.txt", "rb+");
    if (fp == NULL)
    {
        printf("The File system does not exist!\n");
        initialize_disk();
        return;
    }
    // 如果文件全部为空，需要重新初始化
    fseek(fp, 0, 0);
    char c;
    int flag = 0;
    while (!feof(fp))
    {
        fread(&c, 1, 1, fp);
        if (c != 0)
        {
            flag = 1;
            break;
        }
    }
    if (flag == 0)
    {
        printf("The File system does not exist!\n");
        initialize_disk();
        return;
    }
    reload_group_desc();
}

// 格式化
void format()
{
    initialize_disk();
    initialize_memory();
}

// 进入某个目录，实际上是改变当前路径
void cd(char tmp[100])
{
    unsigned short i, j, k, flag;
    flag = research_file(tmp, 2, &i, &j, &k);

    if (flag)
    {

        if (!strcmp(tmp, "..") && dir[k - 1].name_len) /* 到上一级目录且不是..目录 */
        {
            current_dir = i;
            current_path[strlen(current_path) - dir[k - 1].name_len - 1] = '\0';
            current_dirlen = dir[k].name_len;
            // 修改访问时间
            reload_inode_entry(current_dir);
            time_t t;
            time(&t);
            inode_buff.i_atime = t;
            update_inode_entry(current_dir);
            return;
        }
        else if (!strcmp(tmp, "..") && !dir[k - 1].name_len) /* 到上一级目录且是..目录 */
        {
            return;
        }
        else if (!strcmp(tmp, "."))
        {
            // 修改访问时间
            current_dir = i;
            reload_inode_entry(current_dir);
            time_t t;
            time(&t);
            inode_buff.i_atime = t;
            update_inode_entry(current_dir);
            return;
        }
        else if (!strcmp(tmp, "."))
        {
            // 修改访问时间
            current_dir = i;
            reload_inode_entry(current_dir);
            time_t t;
            time(&t);
            inode_buff.i_atime = t;
            update_inode_entry(current_dir);
            return;
        }
    }
    // 以/为分隔符，可以多级cd
    int length = 0;
    int ii = 0;
    char tmp2[100];
    while (tmp[length] != '\0')
    {
        // 以/为分隔符
        char p[1];
        p[0] = tmp[length];
        tmp2[ii] = tmp[length];
        tmp2[ii + 1] = '\0';
         printf("tmp[length] = %c\n", tmp[length]);
         printf("tmp2 = %s\n", tmp2);

        if (!strcmp(p, "/"))
        {
            tmp2[ii] = '\0';
            unsigned short i, j, k, flag;
             printf("tmp2 = %s\n", tmp2);
            flag = research_file(tmp2, 2, &i, &j, &k);
            if (flag)
            {
                current_dir = i;

                 printf("current_dir: %d\n", current_dir);
                current_dirlen += strlen(tmp2);
                strcat(current_path, tmp2);
                strcat(current_path, "/");
                 printf("current_path: %s\n", current_path);
                //  修改访问时间
                reload_inode_entry(current_dir);
                time_t t;
                time(&t);
                inode_buff.i_atime = t;
                update_inode_entry(current_dir);
            }
            else
            {
                printf("The directory %s not exists!\n", tmp2);
            }
            char tmp2[100];
            ii = -1;
        }
        else
        {
            ;
        }
        length++;
        ii++;
    }
    tmp2[ii] = '\0';
     printf("tmp2 = %s\n", tmp2);
    flag = research_file(tmp2, 2, &i, &j, &k);
    if (flag)
    {
        current_dir = i;
        current_dirlen += strlen(tmp2);
        strcat(current_path, tmp2);
        strcat(current_path, "/");
        // 修改访问时间
        reload_inode_entry(current_dir);
        time_t t;
        time(&t);
        inode_buff.i_atime = t;
        update_inode_entry(current_dir);
    }
    else
    {
        printf("The directory %s not exists!\n", tmp2);
    }
}

// 创建目录
void mkdir(char tmp[100], int type)
{
    unsigned short tmpno, i, j, k, flag;

    // 当前目录下新增目录或文件
    reload_inode_entry(current_dir);
    if (!research_file(tmp, type, &i, &j, &k))
    { // 未找到同名文件
        if (inode_buff.i_size == 4096)
        { // 目录项已满
            printf("Directory has no room to be alloced!\n");
            return;
        }
        flag = 1;
        if (inode_buff.i_size != inode_buff.i_blocks * 512)
        { // 目录中有某些块中32个 dir_entry 未满
            i = 0;
            while (flag && i < inode_buff.i_blocks)
            {
                reload_dir(inode_buff.i_block[i]);
                j = 0;
                while (j < 32)
                {
                    if (dir[j].inode == 0)
                    {
                        flag = 0; // 找到某个未装满目录项的块
                        break;
                    }
                    j++;
                }
                i++;
            }
            tmpno = dir[j].inode = get_inode();

            dir[j].name_len = strlen(tmp);
            dir[j].file_type = type;
            strcpy(dir[j].name, tmp);
            update_dir(inode_buff.i_block[i - 1]);
        }
        else
        { // 全满 新增加块
            inode_buff.i_block[inode_buff.i_blocks] = alloc_block();
            inode_buff.i_blocks++;
            reload_dir(inode_buff.i_block[inode_buff.i_blocks - 1]);
            tmpno = dir[0].inode = get_inode();
            dir[0].name_len = strlen(tmp);
            dir[0].file_type = type;
            strcpy(dir[0].name, tmp);
            // 初始化新块的其余目录项
            for (flag = 1; flag < 32; flag++)
            {
                dir[flag].inode = 0;
            }
            update_dir(inode_buff.i_block[inode_buff.i_blocks - 1]);
        }
        inode_buff.i_size += 16;

        update_inode_entry(current_dir);

        // 为新增目录分配 dir_entry
        dir_prepare(tmpno, strlen(tmp), type, tmp);
    }
    else
    { // 已经存在同名文件或目录
        printf("Directory has already existed!\n");
    }
}

// 创建文件
void cat(char tmp[100], int type)
{
    unsigned short tmpno, i, j, k, flag;
    reload_inode_entry(current_dir);
    if (!research_file(tmp, type, &i, &j, &k))
    {
        if (inode_buff.i_size == 4096)
        {
            printf("Directory has no room to be alloced!\n");
            return;
        }
        flag = 1;
        if (inode_buff.i_size != inode_buff.i_blocks * 512)
        {
            i = 0;
            while (flag && i < inode_buff.i_blocks)
            {
                reload_dir(inode_buff.i_block[i]);
                j = 0;
                while (j < 32)
                {
                    if (dir[j].inode == 0)
                    { // 找到了未分配的目录项
                        flag = 0;
                        break;
                    }
                    j++;
                }
                i++;
            }
            tmpno = dir[j].inode = get_inode(); // 分配一个新的inode项
            dir[j].name_len = strlen(tmp);
            dir[j].file_type = type;
            strcpy(dir[j].name, tmp);
            update_dir(inode_buff.i_block[i - 1]);
        }
        else
        { // 分配一个新的数据块
            inode_buff.i_block[inode_buff.i_blocks] = alloc_block();
            inode_buff.i_blocks++;
            reload_dir(inode_buff.i_block[inode_buff.i_blocks - 1]);
            tmpno = dir[0].inode = get_inode();
            dir[0].name_len = strlen(tmp);
            dir[0].file_type = type;
            strcpy(dir[0].name, tmp);
            // 初始化新块其他项目为0
            for (flag = 1; flag < 32; flag++)
            {
                dir[flag].inode = 0;
            }
            update_dir(inode_buff.i_block[inode_buff.i_blocks - 1]);
        }

        inode_buff.i_size += 16;
        update_inode_entry(current_dir);
        // 将新增文件的inode节点初始化
        dir_prepare(tmpno, strlen(tmp), type, tmp);
    }
    else
    {
        printf("File has already existed!\n");
    }
}

// 删除目录
void rmdir(char tmp[100])
{
    unsigned short i, j, k, flag;
    unsigned short m, n;
    unsigned short tmp1 = current_dir;
     printf("initial tmp1: %d\n", current_dir);
    if (!strcmp(tmp, "..") || !strcmp(tmp, "."))
    {
        printf("The directory can not be deleted!\n");
        return;
    }
    flag = research_file(tmp, 2, &i, &j, &k);
    unsigned short tmp2 = i;
    if (flag)
    {
        reload_inode_entry(dir[k].inode); // 加载要删除的节点
        if (inode_buff.i_size == 32)
        { // 只有.and ..
            inode_buff.i_size = 0;
            inode_buff.i_blocks = 0;

            remove_block(inode_buff.i_block[0]);
            // 更新 tmp 所在父目录
            reload_inode_entry(current_dir);
            reload_dir(inode_buff.i_block[j]);
            remove_inode(dir[k].inode);
            dir[k].inode = 0;
            update_dir(inode_buff.i_block[j]);
            inode_buff.i_size -= 16;
            flag = 0;
            m = 1;
            while (flag < 32 && m < inode_buff.i_blocks)
            {
                flag = n = 0;
                reload_dir(inode_buff.i_block[m]);
                while (n < 32)
                {
                    if (!dir[n].inode)
                    {
                        flag++;
                    }
                    n++;
                }
                // 如果删除过后，整个数据块的目录项全都为空。类似于在数组中删除某一个位置
                if (flag == 32)
                {
                    remove_block(inode_buff.i_block[m]);
                    inode_buff.i_blocks--;
                    while (m < inode_buff.i_blocks)
                    {
                        inode_buff.i_block[m] = inode_buff.i_block[m + 1];
                        ++m;
                    }
                }
            }
            update_inode_entry(current_dir);
             printf("current_inode over: %d\n", current_dir);
            return;
        }
        else
        {
            // printf("%d\n",inode_buff.i_size);
            for (int l = 0; l < inode_buff.i_blocks; l++)
            {
                reload_dir(inode_buff.i_block[l]);
                for (m = 0; m < 32; m++)
                {
                    if (!strcmp(dir[m].name, ".") || !strcmp(dir[m].name, "..") || dir[m].inode == 0)
                        continue;
                    if (dir[m].file_type == 2)
                    {
                        current_dir = i;
                         printf("2current_inode: %d\n", current_dir);
                         printf("dir[m].name: %s\n", dir[m].name);
                        rmdir(dir[m].name);
                    }
                    else if (dir[m].file_type == 1)
                    {
                        current_dir = i;
                         //printf("1current_inode: %d\n", current_dir);
                         //printf("dir[m].name: %s\n", dir[m].name);
                        del(dir[m].name);
                        current_dir = i;
                    }
                }
                if (inode_buff.i_size == 32)
                {

                    current_dir = tmp1;
                     //printf("the dic is empty \n");
                     //printf("current_inode: %d\n", current_dir);
                    rmdir(tmp);
                }
            }
            return;
        }
    }
    else
    {
        printf("Directory to be deleted not exists!\n");
    }
}

// 删除文件
void del(char tmp[100])
{
    unsigned short i, j, k, m, n, flag;
    m = 0;
    flag = research_file(tmp, 1, &i, &j, &k);
    if (flag)
    {
        flag = 0;
        // 若文件 tmp 已打开, 则将对应的 fopen_table 项清0
        while (fopen_table[flag] != dir[k].inode && flag < 16)
        {
            flag++;
        }
        if (flag < 16)
        {
            fopen_table[flag] = 0;
        }
        reload_inode_entry(i); // 加载删除文件 inode
        // 删除文件对应的数据块
        while (m < inode_buff.i_blocks)
        {
            remove_block(inode_buff.i_block[m++]);
        }
        inode_buff.i_blocks = 0;
        inode_buff.i_size = 0;
        remove_inode(i);
        // 更新父目录
        reload_inode_entry(current_dir);
        reload_dir(inode_buff.i_block[j]);
        dir[k].inode = 0; // 删除inode节点

        update_dir(inode_buff.i_block[j]);
        inode_buff.i_size -= 16;
        m = 1;
        // 删除一项后整个数据块为空，则将该数据块删除
        while (m < inode_buff.i_blocks)
        {
            flag = n = 0;
            reload_dir(inode_buff.i_block[m]);
            while (n < 32)
            {
                if (!dir[n].inode)
                {
                    flag++;
                }
                n++;
            }
            if (flag == 32)
            {
                remove_block(inode_buff.i_block[m]);
                inode_buff.i_blocks--;
                while (m < inode_buff.i_blocks)
                {
                    inode_buff.i_block[m] = inode_buff.i_block[m + 1];
                    ++m;
                }
            }
        }
        update_inode_entry(current_dir);
    }
    else
    {
        printf("The file %s not exists!\n", tmp);
    }
}

// 打开文件
void open_file(char tmp[100])
{
    unsigned short flag, i, j, k;
    flag = research_file(tmp, 1, &i, &j, &k);
    if (flag)
    {
        if (search_file(dir[k].inode))
        {
            printf("The file %s has opened!\n", tmp);
        }
        else
        {
            flag = 0;
            while (fopen_table[flag])
            {
                flag++;
            }
            fopen_table[flag] = (short)dir[k].inode;
            // 更新文件的访问时间
            reload_inode_entry(dir[k].inode);
            time_t t;
            time(&t);
            inode_buff.i_atime = t;
            update_inode_entry(dir[k].inode);

            printf(" %s sucessfully opened!\n", tmp);
        }
    }
    else
        printf("The file %s does not exist!\n", tmp);
}

// 关闭文件
void close_file(char tmp[100])
{
    unsigned short flag, i, j, k;
    flag = research_file(tmp, 1, &i, &j, &k);

    if (flag)
    {
        if (search_file(dir[k].inode))
        {
            flag = 0;
            while (fopen_table[flag] != dir[k].inode)
            {
                flag++;
            }
            fopen_table[flag] = 0;
            printf(" %s  sucessfully  closed!\n", tmp);
        }
        else
        {
            printf("The file %s has not been opened!\n", tmp);
        }
    }
    else
    {
        printf("The file %s does not exist!\n", tmp);
    }
}

// 读文件
void read_file(char tmp[100])
{
    unsigned short flag, i, j, k, t;
    flag = research_file(tmp, 1, &i, &j, &k);
    if (flag)
    {
        if (search_file(dir[k].inode)) // 读文件的前提是该文件已经打开
        {
            reload_inode_entry(dir[k].inode);
            // 判断是否有读的权限
            if (!(inode_buff.i_mode & 4)) // i_mode:111b:读,写,执行
            {
                printf("The file %s can not be read!\n", tmp);
                return;
            }
            // 读文件直接索引
            if (inode_buff.i_blocks <= 6)
            {
                for (flag = 0; flag < inode_buff.i_blocks; flag++)
                {
                    reload_block(inode_buff.i_block[flag]);
                    for (t = 0; t < inode_buff.i_size - flag * 512; ++t)
                    {
                        printf("%c", Buffer[t]);
                    }
                }
            }
            // 读文件一级索引
            else if (inode_buff.i_blocks < 262)
            {
                printf("inode_buff.i_blocks: %d\n", inode_buff.i_blocks);
                for (flag = 0; flag < 6; flag++)
                {
                    reload_block(inode_buff.i_block[flag]);
                    // printf("\ninode_buff.i_block[flag]: %d\n", inode_buff.i_block[flag]);
                    for (t = 0; t < 512; ++t)
                    {
                        printf("%c", Buffer[t]);
                    }
                }
                reload_block(inode_buff.i_block[6]);
                for (flag = 0; flag < inode_buff.i_blocks - 7; flag++)
                {
                    reload_block(inode_buff.i_block[6]);
                    int t = Buffer[flag * 2] * 256 + Buffer[flag * 2 + 1];
                    // printf("\nBuffer[flag * 2] * 256 + Buffer[flag * 2 + 1]: %d\n", Buffer[flag * 2] * 256 + Buffer[flag * 2 + 1]);
                    reload_block(t);
                    for (t = 0; t < 512; ++t)
                    {
                        printf("%c", Buffer[t]);
                    }
                }
            }
            // 读文件二级索引
            else if (inode_buff.i_blocks < 4072)
            {
                for (flag = 0; flag < 6; flag++)
                {
                    reload_block(inode_buff.i_block[flag]);
                    for (t = 0; t < 6 * 512; ++t)
                    {
                        printf("%c", Buffer[t]);
                    }
                }
                reload_block(inode_buff.i_block[6]);
                for (flag = 0; flag < 256; flag++)
                {
                    reload_block(Buffer[flag * 2] * 256 + Buffer[flag * 2 + 1]);
                    for (t = 6 * 512; t < inode_buff.i_size - 6 * 512; ++t)
                    {
                        printf("%c", Buffer[t]);
                    }
                }
                reload_block(inode_buff.i_block[7]);
                for (flag = 0; flag < inode_buff.i_blocks - 262; flag++)
                {
                    reload_block(Buffer[flag * 2] * 256 + Buffer[flag * 2 + 1]);
                    for (t = 0; t < inode_buff.i_size - (flag + 262) * 512; ++t)
                    {
                        printf("%c", Buffer[t]);
                    }
                }
            }
            if (flag == 0)
            {
                printf("The file %s is empty!\n", tmp);
            }
            else
            {
                printf("\n");
            }
        }
        else
        {
            printf("The file %s has not been opened!\n", tmp);
        }
    }
    else
        printf("The file %s not exists!\n", tmp);
}

// 文件以覆盖方式写入
void write_file(char tmp[100])
{
    unsigned short flag, i, j, k = 0, need_blocks;
    unsigned long size = 0, length;
    flag = research_file(tmp, 1, &i, &j, &k);
    if (flag)
    {
        if (search_file(dir[k].inode))
        {
            reload_inode_entry(dir[k].inode);
            if (!(inode_buff.i_mode & 2)) // i_mode:111b:读,写,执行
            {
                printf("The file %s can not be writed!\n", tmp);
                return;
            }
            // fflush(stdin);
            while (1)
            {
                tempbuf[size] = getchar();
                if (tempbuf[size] == '#')
                {
                    tempbuf[size] = '\0';
                    break;
                }
                if (size >= 4096 * 512)
                {
                    printf("Sorry,the max size of a file is 2MB!\n");
                    break;
                }
                size++;
            }
            if (size >= 4096 * 512)
            {
                length = 4096 * 512;
            }
            else
            {
                length = strlen(tempbuf);
            }
            printf("\nlength = %d\n", length);
            // 计算需要的数据块数目
            need_blocks = length / 512;
            if (length % 512)
            {
                need_blocks++;
            }
            if (need_blocks < 6) // 文件最大 8 个 blocks(512 bytes)
            {
                // 分配文件所需块数目
                // 因为以覆盖写的方式写，要先判断原有的数据块数目
                if (inode_buff.i_blocks <= need_blocks)
                {
                    while (inode_buff.i_blocks < need_blocks)
                    {
                        inode_buff.i_block[inode_buff.i_blocks] = alloc_block();
                        inode_buff.i_blocks++;
                    }
                }
                else
                {
                    while (inode_buff.i_blocks > need_blocks)
                    {
                        remove_block(inode_buff.i_block[inode_buff.i_blocks - 1]);
                        inode_buff.i_blocks--;
                    }
                }
                j = 0;
                while (j < need_blocks)
                {
                    if (j != need_blocks - 1)
                    {
                        reload_block(inode_buff.i_block[j]);
                        memcpy(Buffer, tempbuf + j * BLOCK_SIZE, BLOCK_SIZE);
                        update_block(inode_buff.i_block[j]);
                    }
                    else
                    {
                        reload_block(inode_buff.i_block[j]);
                        memcpy(Buffer, tempbuf + j * BLOCK_SIZE, length - j * BLOCK_SIZE);
                        inode_buff.i_size = length;
                        update_block(inode_buff.i_block[j]);
                    }
                    j++;
                }
                update_inode_entry(dir[k].inode);
            }
            // 一级子索引 2字节表示1个块号中，如果一个数据块都用来存放块号，则可以存放256个
            // 一级索引中大于6的块的块号放在inode.i_block[6]指向的数据块中
            else if (need_blocks < 262)
            {
                inode_buff.i_size = length;
                printf("need_blocks = %d\n", need_blocks);
                if (inode_buff.i_blocks <= 6)
                {
                    while (inode_buff.i_blocks < 6)
                    {
                        inode_buff.i_block[inode_buff.i_blocks] = alloc_block();
                        //printf("inode_buff.i_block[inode_buff.i_blocks] = %d\n", inode_buff.i_block[inode_buff.i_blocks]);
                        inode_buff.i_blocks++;
                    }
                    inode_buff.i_block[6] = alloc_block();
                    inode_buff.i_blocks++;
                }
                // 写一级索引 2字节表示1个块号
                reload_block(inode_buff.i_block[6]);
               // printf("inode_buff.i_block[6] = %d\n", inode_buff.i_block[6]);
                for (j = 0; j < need_blocks - 6; j++)
                {
                    short block_num = alloc_block();
                    inode_buff.i_blocks++;
                    Buffer[j * 2] = block_num / 256;
                    Buffer[j * 2 + 1] = block_num % 256;
                     //printf("Buffer[%d*2] = %d\n",j, (int)Buffer[j * 2]);
                     //printf("Buffer[%d*2+1] = %d\n",j, (int)Buffer[j * 2 + 1]);
                }
                update_block(inode_buff.i_block[6]);
                // 写数据块
                j = 0;
                while (j < 6)
                {
                    reload_block(inode_buff.i_block[j]);
                    memcpy(Buffer, tempbuf + j * BLOCK_SIZE, BLOCK_SIZE);
                    update_block(inode_buff.i_block[j]);
                    j++;
                }

                for (j = 0; j < need_blocks - 6; j++)
                {
                    reload_block(inode_buff.i_block[6]);
                    unsigned short block_num = (int)Buffer[j * 2] * 256 + (int)Buffer[j * 2 + 1];
                    //printf("Buffer[%d*2] = %d\n", j, (int)Buffer[j * 2]);
                     //printf("Buffer[%d*2+1] = %d\n",j, (int)Buffer[j * 2 + 1]);
                   //  printf("block_num = %d\n", block_num);
                    reload_block(block_num);
                    memcpy(Buffer, tempbuf + (j + 6) * BLOCK_SIZE, BLOCK_SIZE);
                    update_block(block_num);
                }
                update_inode_entry(dir[k].inode);
                reload_inode_entry(dir[k].inode);
             //printf("inode_buff.i_size = %d\n", inode_buff.i_size);
            }
            // 二级索引 2字节表示1个块号中，如果一个数据块都用来存放块号，则可以存放256个
            else if (need_blocks < 4072)
            {
                inode_buff.i_size = length;
                if (inode_buff.i_blocks <= 6)
                {
                    while (inode_buff.i_blocks < 6)
                    {
                        inode_buff.i_block[inode_buff.i_blocks] = alloc_block();
                        inode_buff.i_blocks++;
                    }
                    inode_buff.i_block[6] = alloc_block();
                    inode_buff.i_blocks++;
                    inode_buff.i_block[7] = alloc_block();
                    inode_buff.i_blocks++;
                }
                // 写一级索引 2字节表示1个块号
                reload_block(inode_buff.i_block[6]);
                for (j = 0; j < 256; j++)
                {
                    reload_block(inode_buff.i_block[6]);
                    int block_num = alloc_block();
                    inode_buff.i_blocks++;
                    Buffer[j * 2] = block_num / 256;
                    Buffer[j * 2 + 1] = block_num % 256;
                }
                update_block(inode_buff.i_block[6]);
                // 写二级索引 2字节表示1个块号
                reload_block(inode_buff.i_block[7]);
                for (j = 0; j < (need_blocks - 262) / 256 + 1; j++)
                {
                    reload_block(inode_buff.i_block[7]);
                    int block_num = alloc_block();
                    inode_buff.i_blocks++;
                    Buffer[j * 2] = block_num / 256;
                    Buffer[j * 2 + 1] = block_num % 256;
                    update_block(inode_buff.i_block[7]);
                    reload_block(block_num);
                    for (k = 0; k < 256; k++)
                    {
                        reload_block(block_num);
                        int block_num1 = alloc_block();
                        inode_buff.i_blocks++;
                        Buffer[k * 2] = block_num1 / 256;
                        Buffer[k * 2 + 1] = block_num1 % 256;
                        update_block(block_num);
                    }
                }
                update_block(inode_buff.i_block[7]);

                // 写数据块
                j = 0;
                while (j < 6)
                {
                    reload_block(inode_buff.i_block[j]);
                    memcpy(Buffer, tempbuf + j * BLOCK_SIZE, BLOCK_SIZE);
                    update_block(inode_buff.i_block[j]);
                    j++;
                }
                reload_block(inode_buff.i_block[6]);
                for (j = 0; j < 256; j++)
                {
                    reload_block(inode_buff.i_block[6]);
                    unsigned short block_num = Buffer[j * 2] * 256 + Buffer[j * 2 + 1];
                    reload_block(block_num);
                    memcpy(Buffer, tempbuf + (j + 6) * BLOCK_SIZE, BLOCK_SIZE);
                    update_block(block_num);
                }
                reload_block(inode_buff.i_block[7]);
                for (j = 0; j < (need_blocks - 262) / 256 + 1; j++)
                {
                     reload_block(inode_buff.i_block[7]);
                    unsigned short block_num = Buffer[j * 2] * 256 + Buffer[j * 2 + 1];
                    reload_block(block_num);
                    for (k = 0; k < 256; k++)
                    {
                        reload_block(block_num);
                        unsigned short block_num1 = Buffer[k * 2] * 256 + Buffer[k * 2 + 1];
                        reload_block(block_num1);
                        memcpy(Buffer, tempbuf + (j + 262 + k) * BLOCK_SIZE, BLOCK_SIZE);
                        update_block(block_num1);
                    }
                }
            }

            else
            {
                printf("Sorry,the max size of a file is 2MB!\n");
            }
        }
        else
        {
            printf("The file %s has not opened!\n", tmp);
        }
    }
    else
    {
        printf("The file %s does not exist!\n", tmp);
    }
}

// 查看目录下的内容
void ls()
{
    printf("items\t\ttype\t\t\tmode\t\t\tc_time\t\t\ta_time\t\t\tm_time\n");
    unsigned short i, j, k, flag;
    i = 0;
    reload_inode_entry(current_dir);
    while (i < inode_buff.i_blocks)
    {
        k = 0;
        reload_dir(inode_buff.i_block[i]);
        while (k < 32)
        {
            if (dir[k].inode != 0)
            {
                printf("%s\t\t", dir[k].name);
                if (dir[k].file_type == 2)
                {
                    j = 0;
                    reload_inode_entry(dir[k].inode);
                    if (!strcmp(dir[k].name, ".."))
                    {
                        flag = 1;
                    }
                    else if (!strcmp(dir[k].name, "."))
                    {
                        flag = 0;
                    }
                    else
                    {
                        flag = 2;
                    }
                    printf("<DIR>\t\t\t");
                    switch (inode_buff.i_mode & 7)
                    {
                    case 0:
                        printf("_____\t");
                        break;
                    case 1:
                        printf("____x\t");
                        break;
                    case 2:
                        printf("__w__\t");
                        break;
                    case 3:
                        printf("__w_x\t");
                        break;
                    case 4:
                        printf("r____\t");
                        break;
                    case 5:
                        printf("r___x\t");
                        break;
                    case 6:
                        printf("r_w__\t");
                        break;
                    case 7:
                        printf("r_w_x\t");
                        break;
                    }
                    printf("\t   ");
                    if (k >= 2)
                    {
                        struct tm *t;
                        t = localtime(&inode_buff.i_ctime);
                        printf("%d.%d.%d %d:%d:%d\t   ", t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour,
                               t->tm_min, t->tm_sec);
                        t = localtime(&inode_buff.i_atime);
                        printf("%d.%d.%d %d:%d:%d\t   ", t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour,
                               t->tm_min, t->tm_sec);
                        t = localtime(&inode_buff.i_mtime);
                        printf("%d.%d.%d %d:%d:%d", t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour,
                               t->tm_min, t->tm_sec);
                    }
                }

                else if (dir[k].file_type == 1)
                {
                    j = 0;
                    reload_inode_entry(dir[k].inode);
                    printf("<FILE>\t\t\t");
                    switch (inode_buff.i_mode & 7)
                    {
                    case 1:
                        printf("____x");
                        break;
                    case 2:
                        printf("__w__");
                        break;
                    case 3:
                        printf("__w_x");
                        break;
                    case 4:
                        printf("r____");
                        break;
                    case 5:
                        printf("r___x");
                        break;
                    case 6:
                        printf("r_w__");
                        break;
                    case 7:
                        printf("r_w_x");
                        break;
                    }
                    printf("\t\t   ");

                    struct tm *t;
                    t = localtime(&inode_buff.i_ctime);
                    printf("%d.%d.%d %d:%d:%d\t   ", t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour,
                           t->tm_min, t->tm_sec);
                    t = localtime(&inode_buff.i_atime);
                    printf("%d.%d.%d %d:%d:%d\t   ", t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour,
                           t->tm_min, t->tm_sec);
                    t = localtime(&inode_buff.i_mtime);
                    printf("%d.%d.%d %d:%d:%d", t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour,
                           t->tm_min, t->tm_sec);
                }
                printf("\n");
            }
            k++;
            reload_inode_entry(current_dir);
        }
        i++;
    }
}

// 修改文件权限
void chmod(char tmp[100], unsigned short mode)
{
    unsigned short flag, i, j, k;
    flag = research_file(tmp, 1, &i, &j, &k);
    if (flag)
    {
        if (mode < 0 || mode > 7)
        {
            printf("Wrong mode!\n");
            return;
        }
        reload_inode_entry(dir[k].inode);
        inode_buff.i_mode = mode;
        update_inode_entry(dir[k].inode);
    }
    else
        printf("The file %s does not exist!\n", tmp);
}

// 查看指令
void help()
{
    printf("============================help_list========================================\n");
    printf("=============================================================================\n");
    printf("1.cd : cd + path\t\t\t\t2.mkdir : mkdir + dirname\n");
    printf("3.rmdir : rmdir + dirname\t\t\t4.ls : ls\n");
    printf("5.create : create + filename\t\t\t6.open : open + filename\n");
    printf("7.close : close + filename\t\t\t8.read : read + filename\n");
    printf("9.write : write + filename\t\t\t10.rm : rm + filename\n");
    printf("11.chmod : chmod + filename + mode\t\t12.password : password + tmp\n");
    printf("13.format : format\t\t\t\t14.quit : quit\n");
    printf("=============================================================================\n");
}
