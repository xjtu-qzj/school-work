### 类EXT2文件系统的设计

[TOC]



#### 实验内容

- 模拟EXT2文件系统原理设计实现一个类EXT2文件系统

#### 实验步骤

- 定义类 EXT2 文件系统所需的数据结构，包括组描述符、索引结点和目录项
- 实现包括分配数据块等底层操作
- 实现命令层函数，包括 dir 等操作
- 完成 shell 的设计
- 测试整个文件系统的功能

#### 数据结构定义

1. ```c
   // 组描述符
   struct group_desc { // 32 B
       char bg_volume_name[16]; //文件系统的卷名
       unsigned short bg_block_bitmap; //块位图的起始块号
       unsigned short bg_inode_bitmap; //索引结点位图的起始块号
       unsigned short bg_inode_table; //索引结点表的起始块号
       unsigned short bg_free_blocks_count; //本组空闲块的个数
       unsigned short bg_free_inodes_count; //本组空闲索引结点的个数
       unsigned short bg_used_dirs_count; //组中分配给目录的结点
       char bg_pad[4]; //填充(0xff)
   };
   
   // 索引结点
   struct inode {     //  64 B
       unsigned short i_mode;   //文件类型及访问权限
       unsigned short i_blocks; //文件所占的数据块个数(0~7), 最大为7
       unsigned long i_size;    //文件或目录大小(单位 byte)
       unsigned long i_atime;   //访问时间
       unsigned long i_ctime;   //创建时间
       unsigned long i_mtime;   //修改时间
       unsigned long i_dtime;   //删除时间
       unsigned short i_block[8]; //直接索引方式 指向数据块号
       char i_pad[24];           //填充(0xff)
   };
   
   // 目录项
   struct dir_entry { // 16 B
       unsigned short inode; //索引节点号
       unsigned short rec_len; //目录项长度
       unsigned short name_len; //文件名长度
       char file_type; //文件类型(1 普通文件 2 目录.. )
       char name[9]; //文件名
   };
   
   
   // 用户信息
   struct user {
       char username[10];
       char password[10];
   }User[USER_MAX];
   ```

   - 因为系统中最多有4096个数据块，所以索引节点最多也是4096。所以索引节点号只需16位（unsigned short）即可。
   - struct inode 中为保证一个索引节点占64位，需要提供char i_pad[24]，作为填充。

#### 底层函数

1. ##### **读写缓冲区类操作函数**

   ```c
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
   ```

   `update_group_desc`函数打开一个名为"FS.txt"的文件，以**读写模式打开（"rb+"）**，然后将文件指针移动到GDT的起始位置（GDT_START），并将内存中的GDT数据（gdt）写入文件。最后，使用`fflush`函数刷新文件流，确保数据被写入文件。

   `reload_group_desc`函数假定文件指针`fp`已经打开，然后将文件指针移动到GDT的起始位置（GDT_START），并从文件中读取GDT数据到内存中的gdt变量中。

   其他结构体缓冲区读写函数依次类推：**但需注意何时用指针合适取地址**

2. ##### **分配删除块函数：标注位图**

   **分配函数**

   ```c
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
   
   ```

   ​	**循环遍历块位图的每个字节（共512个字节）**，然后再遍历每个字节中的每一位做**与运算**。如果某一位为0，表示该数据块未被分配，则将该位设置为1，表示分配了该数据块，并记录下该数据块的编号。最后跳出循环，返回分配的数据块编号。

   **删除块函数**

   ```c
   // 删除data_block
   static void remove_block(unsigned short del_num)
   {
       unsigned short tmp;
       tmp = del_num / 8;
       reload_block_bitmap();
       switch (del_num % 8)
       { 
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
   ```

   ​	首先计算出要删除的数据块编号在块位图中的位置。接下来，根据要删除的数据块编号在字节中的位置，使用`switch`语句来设置对应位为0，表示释放该数据块。

3. ##### **配置新节点及初始化目录**

   ```c
   static void dir_init(unsigned short tmp, unsigned short len, int type, char name[100])
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
   ```

   函数根据类型`type`的值来初始化i节点的各个字段。**如果类型为2（表示目录）**，则设置i节点的字段，并初始化目录项`dir`的内容，并将"."和".."目录项的名称赋值为当前目录和父目录的名称。

   **如果类型不为2（表示文件）**，则设置i节点的大小、块数、创建时间、修改时间、访问时间等字段，并根据**文件名的后缀(扩展名为.exe,.bin,.com及不带扩展名的)**来判断是否为可执行文件，如果是则设置i节点的执行权限。

#### 命令层函数

1. ##### cd  改变路径

   ![image-20231128201721031](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128201721031.png)

   ```c
   // 进入某个目录，实际上是改变当前路径
   void cd(char tmp[100])
   {
       unsigned short i, j, k, flag;
       flag = research_file(tmp, 2, &i, &j, &k);
       if (flag)
       {
   
           if (!strcmp(tmp, "..") && dir[k - 1].name_len) 
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
           else if (!strcmp(tmp, "..") && !dir[k - 1].name_len) 
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
           // printf("tmp[length] = %c\n", tmp[length]);
           // printf("tmp2 = %s\n", tmp2);
   
           if (!strcmp(p, "/"))
           {
               tmp2[ii] = '\0';
               unsigned short i, j, k, flag;
               // printf("tmp2 = %s\n", tmp2);
               flag = research_file(tmp2, 2, &i, &j, &k);
               if (flag)
               {
                   current_dir = i;
   
                   // printf("current_dir: %d\n", current_dir);
                   current_dirlen += strlen(tmp2);
                   strcat(current_path, tmp2);
                   strcat(current_path, "/");
                   // printf("current_path: %s\n", current_path);
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
       // printf("tmp2 = %s\n", tmp2);
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
   ```

   cd 分为三种情况：主要考虑更改 **`current_dir`**和**`current_path`**

   1. **传送到上一级目录（..）**但不在根目录上

   2. 在根目录上执行 `cd ..`（直接return）

   3. **传送到子目录（考虑多级）:** **以/为分隔符**,截取每一级的路径，搜索其索引节点及路径，不断循环。

      <img src="C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128203920554.png" alt="image-20231128203920554" style="zoom:67%;" />

      ​                                                   该图展示了分割路径的路径，通过遍历路径寻找 **“/”**分割每一层路径。

2. ##### mkdir 创建目录

   ![image-20231128204403213](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128204403213.png)

   ```c
   // 创建目录
   void mkdir(char tmp[100], int type)
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
                       {
                           flag = 0; 
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
       { 
           printf("Directory has already existed!\n");
       }
   }
   
   ```

   

3. ##### rmdir 删除目录

   ![image-20231128201614398](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128201614398.png)

   ```c
   // 删除目录
   void rmdir(char tmp[100])
   {
       unsigned short i, j, k, flag;
       unsigned short m, n;
       unsigned short tmp1 = current_dir;
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
               return;
           }
           else
           {
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
                           rmdir(dir[m].name);
                       }
                       else if (dir[m].file_type == 1)
                       {
                           current_dir = i;
                           del(dir[m].name);
                           current_dir = i;
                       }
                   }
                   if (inode_buff.i_size == 32)
                   {
   
                       current_dir = tmp1;
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
   ```

   1. 首先检查要删除的目录是否为"."或".."，如果是则无法删除，否则继续执行。

   2. 如果目录下只有"."和".."两个项，则直接删除该目录，更新父目录信息，并释放相关的数据块和节点。

   3. 如果目录下还有其他文件或子目录，则递归调用rmdir函数，依次删除其中的文件和子目录。最后更新父目录信息。

      在递归调用时要注意更新 **`current_dir`**，与当前删除的一级的目录相对应。

      <img src="C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128202508451.png" alt="image-20231128202508451" style="zoom:55%;" />

      图中表示的是**`current_dir`**的变化过程。该文件的构成为<img src="C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128202932313.png" alt="image-20231128202932313" style="zoom:50%;" />

   有图中可知结点从根节点先层层递进到达目录2，删除文件3后（判断目录是否已空）再删除目录本身。从子节点再递归删除返回。

4. ##### open_file 打开文件

   ![image-20231128203616113](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128203616113.png)

   ```c
   void open_file(char tmp[100])
   {
       unsigned short flag,inode_num , block_num, dir_num;
       flag = research_file(tmp, 1, &inode_num, &block_num, &dir_num);
       if (flag)
       {
           if (search_file(dir[dir_num].inode))
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
               fopen_table[flag] = (short)dir[dir_num].inode;
               // 更新文件的访问时间
               reload_inode_entry(dir[dir_num].inode);
               time_t t;
               time(&t);
               inode_buff.i_atime = t;
               update_inode_entry(dir[dir_num].inode);
   
               printf(" %s sucessfully opened!\n", tmp);
           }
       }
       else
           printf("The file %s does not exist!\n", tmp);
   }
   ```

   首先查找文件，如果找到了文件，则检查该文件是否已经被打开，如果已经被打开，则输出提示信息。如果文件没有被打开，则在 `fopen_table` 数组中找到一个空闲的位置，将该文件的 inode 号存入该位置。然后更新文件的访问时间。

   

5. ##### read_file 读文件

   ![image-20231128213219244](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128213219244.png)

   ```c
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
                         reload_block(inode_buff.i_block[6]);
                       reload_block(Buffer[flag * 2] * 256 + Buffer[flag * 2 + 1]);
                       for (t = 6 * 512; t < inode_buff.i_size - 6 * 512; ++t)
                       {
                           printf("%c", Buffer[t]);
                       }
                   }
                   reload_block(inode_buff.i_block[7]);
                   for (flag = 0; flag < inode_buff.i_blocks - 262; flag++)
                   {
                       reload_block(inode_buff.i_block[7]);
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
   ```

   创建文件需满足两个条件：

   1. 该文件是可读的  $r$                         2.该文件已打开 open

   若满足条件即可读。读时首先读取i_blcoks的个数。根据数据块个数选择索引方式:

   1. （i_blcoks< 6）直接索引将数据块的位置信息存储在文件的inode项中的`i_blocks`数组中**。每个数组元素对应一个数据块的位置**。直接读取i_blcok[]数组中的块号，然后直接读取块号指向的数据块的内容。

   2. （i_blcoks< 262）一级子索引是一个额外的索引块，其中每个索引项指向一个数据块的位置。索引块中用unsigned int 16位变量，即2字节表示1个块号。索引块都用来存放块号。读取时若想获得一个块号需读取两个Buffer[]，代表最终块号的高8位和低8位。

      `int t = Buffer[flag * 2] * 256 + Buffer[flag * 2 + 1];`读取对应块号的内容。

   3. （i_blcoks< 4072）读入二级索引块。代码通过循环读入一级索引块的块号，**并在每个一级索引块中再次循环读入块号，将这些块的块号对应的数据块载入读取**。

      

   ![image-20231128213104507](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128213104507.png)

6. ##### write_file 写文件

   ![image-20231128210703769](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128210703769.png)

   ```c
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
               else if (need_blocks < 262)
               {
                   inode_buff.i_size = length;
                   printf("need_blocks = %d\n", need_blocks);
                   if (inode_buff.i_blocks <= 6)
                   {
                       while (inode_buff.i_blocks < 6)
                       {
                           inode_buff.i_block[inode_buff.i_blocks] = alloc_block();
                           inode_buff.i_blocks++;
                       }
                       inode_buff.i_block[6] = alloc_block();
                       inode_buff.i_blocks++;
                   }
                   // 写一级索引 2字节表示1个块号
                   reload_block(inode_buff.i_block[6]);
                   printf("inode_buff.i_block[6] = %d\n", inode_buff.i_block[6]);
                   for (j = 0; j < need_blocks - 6; j++)
                   {
                       short block_num = alloc_block();
                       inode_buff.i_blocks++;
                       Buffer[j * 2] = block_num / 256;
                       Buffer[j * 2 + 1] = block_num % 256;
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
                       reload_block(block_num);
                       memcpy(Buffer, tempbuf + (j + 6) * BLOCK_SIZE, BLOCK_SIZE);
                       update_block(block_num);
                   }
                   update_inode_entry(dir[k].inode);
                   reload_inode_entry(dir[k].inode);
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
   ```

   创建文件需满足两个条件：

   1. 该文件是可写的  $W$                         2.该文件已打开 open

   若满足条件即可写入。写入时首先计算所需块数need_blocks。根据索引个数选择索引方式:

   1. （need_blocks < 6）直接索引将数据块的位置信息存储在文件的inode项中的`i_blocks`数组中**。每个数组元素对应一个数据块的位置**。在代码中，通过更新inode项的`i_blocks`数组来分配或释放直接索引所需的数据块。然后，使用循环将数据块中的数据逐块写入磁盘。

   2. （need_blocks < 262）一级子索引是**一个额外的索引块，其中存储的块号指向一个数据块的位置。索引块中用unsigned int 16位变量**，**即2字节表示1个块号**。索引块都用来存放块号，可以存放512/2＝256个。因为Buffer为char型（8位），所以每得到一个数据块需要取两个Buffer[]代表高 8位和低8位。

      ```c
                  Buffer[j * 2] = block_num / 256;
                  Buffer[j * 2 + 1] = block_num % 256;
      ```

   3. （need_blocks < 4072）写入二级索引块。代码通过循环分配一级索引块的块号，**并在每个一级索引块中再次循环分配块号，将这些块的块号存储在二级索引块中的相应位置**。写入数据块。代码通过循环读取`tempbuf`中的数据，并将其写入对应的数据块中。前6个数据块写入直接索引块，接下来的256个数据块写入一级索引块指向的块，剩余的数据块按照二级索引块的结构依次写入。

      ![image-20231128212538790](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128212538790.png)

   

7. ##### ls  显示指定工作目录下之内容

   ![image-20231128220843653](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128220843653.png)

8. ##### chmod  更改文件权限

   ![image-20231129135235720](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231129135235720.png)

   ```c
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
   ```

   检查权限模式是否在0到7之间，如果不在范围内则输出错误信息并返回。如果权限模式在范围内，则重新加载文件的索引节点信息，更新权限模式，并更新索引节点信息。如果文件不存在，则输出文件不存在的错误信息。

9. ##### initialize_user 初始化用户       **password_change**  更改密码 

   <img src="C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128215147077.png" alt="image-20231128215147077" style="zoom:67%;" />

   

```c
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
```

这两个函数共同完成了用户信息的初始化和密码修改的功能。`initialize_user()`用于初始化用户信息并创建文件，而`password_change()`用于修改特定用户的密码并更新文件

1. `initialize_user()`:

   - 该函数用于初始化用户信息并创建/读取一个名为`password.txt`的文件。将预定义的用户信息写入`User`数组中。
   - 接下来，使用`fwrite`将`User`数组中的用户信息写入文件中，并关闭文件。
   - 最后，再次打开`password.txt`文件以读取其中的用户信息，并将其存储到`User`数组中

2. `password_change(char username[10], char password[10])`:

   - 以写入模式重新打开`password.txt`文件，并使用`fwrite`将更新后的`User`数组写入文件。

     ![image-20231128220616325](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128220616325.png)

     <center>password.txt<center>

#### shell 的设计

```c
int main()
{
    char command[10], temp[100];
    char username[10], password[10];
    initialize_user();
    while (1)
    {
        printf("Please print username : \n");
        scanf("%s", username);
        if (!strcmp(username, "quit") || !strcmp(username, "exit"))
            return 0;
        printf("Please print password : \n");
        scanf("%s", password);
        if (login(username, password))
        {
            strcpy(current_user, username);
            strcpy(current_path, "[");
            strcat(current_path, current_user);
            strcat(current_path, "@ext2 /");
            printf("User %s sign in!\n", username);
            break;
        }
        else
        {
            printf("User name or password wrong, please enter again!\n");
            printf("If want to exit, please enter \"quit\" or \"exit\"!\n");
        }
    }
    initialize_memory();
    while (1)
    {
        
        printf("%s]#", current_path);
        scanf("%s", command);
        if (!strcmp(command, "cd"))
        { // 进入当前目录下
            scanf("%s", temp);
            cd(temp);
        }
        else if (!strcmp(command, "mkdir"))
        { // 创建目录
            scanf("%s", temp);
            mkdir(temp, 2);
        }
```

**1.shell层进行用户登陆**

![image-20231128221228819](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128221228819.png)

<center>用户登陆界面<center>

**2.执行命令行（包括    “help”    查询操作用法）**

<img src="C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128221444075.png" alt="image-20231128221444075" style="zoom:67%;" />

**3.退出文件系统**

![image-20231128221157459](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128221157459.png)

**4.格式化系统**

![image-20231128221633010](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231128221633010.png)



