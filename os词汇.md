# os词汇

[TOC]

# 第1章 intro

- Client-Server Computing 
- Peer-to-Peer Computing
- Pervasive computing
- system, privileged or supervisor mode.（Kernel mode）
- System Calls
- bootstrap program 
- Synchronous I/O
- Asynchronous I/O
- Distributed Systems
- Clustered Systems
- Time-sharing System
- Real-Time System
- Parallel Systems

# 第二章   Operating-System Structures

- Command-Line (CLI) 命令行

- Graphics User Interface (GUI) 用户界面

- Batch 批处理

- **并发(Concurrent) 与并行(Parallel)**

- Microkernel

- Hybrid Systems

- “异常”（Exception）

- primitive or atomic action

# 第3章 Process

- System process
- User process
- ![image-20231212212125354](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231212212125354.png)
- Accounting information
- ![image-20231212212414620](C:\Users\邱子杰\AppData\Roaming\Typora\typora-user-images\image-20231212212414620.png)
- Long-term scheduler 
- short-term scheduler 
- Medium-term scheduling
-  the *degree* *of multiprogramming*
- context switch
- overhead
- process identifier 
- interprocess communication (IPC)
- Message Passing
- synchronous
- asynchronous

# 第四章 Threads

- duplicate
- Asynchronous cancellation 
- Deferred cancellation 
- lightweight process(LWP)
- upcall（回调） handler

# 第五章 **CPU Scheduling**

- CPU-I/O Burst Cycle
- preemptive
- Throughput
- Turnaround time 
- Shortest-Job-First (SJF) Scheduling
- Shortest-Job-First (SJF) Scheduling
- Aging
- Round Robin 
- foreground
- background
- process-contention scope (PCS) 
- system-contention scope (SCS) 
- Homogeneous processors 
- Symmetric multiprocessing (SMP)
- scheduler
- dispatcher
- soft affinity
- Push migration 
- Pull migration 

# 第6章 **Deadlocks**

- Mutual exclusion
- Hold and wait
- Circular wait
- Deadlock Prevention 
- Deadlock Avoidance



# 第7章 **Process Synchronization**

- critical-section
- Race Condition
- mutual exclusion
- coordination
- remainder section. 
- entry section
- Progress
- Bounded Waiting 
- Semaphore
- mutex locks
- Spinlock
- Deadlock
- asymmetry

# 第8章 main memory

- segmentation    
- paging
- base and limit registers 
- Memory-Management Unit (MMU)
- relocation register 
- Swapping
- Dynamic Linking
- Dynamic Loading
- Backing store 
- Contiguous Allocation
- Fixed Partitioning
- Dynamic Partitioning
- Dynamic Relocationable Partitioning
- Roll out, roll in 换出换入
- Hole
- External Fragmentation 
- compaction
- Page-table base register (PTBR) 
- Page-table length register (PRLR) 
- Page frame
- Segment-table base register (STBR) 
- Segment-table length register (STLR)
- Inverted Page Table
- Valid-invalid

- transaction(事务)

- Log Structured File Systems
- back up 
- restoring
- read-ahead（提前读取）
- read-ahead（提前读取）
- Unified Buffer Cache
- Page Cache 

# 第12章 Mass-storge systems

-  Magnetic tape
- read-write head
- sector
- cylinder
- track
- platter
- spindle
- rotational latency 旋转延迟
- seek time
- Positioning time (random-access time) 
- Host-attached storage 
- Network-attached storage 
- storage area networks (SANs) 
- Shortest-Seek-Time-Fist (SSTF) 
- the elevator algorithm
- physical formatting 
- clusters
- logical formatting 
- bootstrap
- MBR（Master Boot Recorder，主引导记录）
- raw disk
- page slot
- Redundant Arrays of Independent Disk
- ldata-striping 数据分条
- mirroring
- Polling
- interrupt-request line
- interrupt-controller
- 