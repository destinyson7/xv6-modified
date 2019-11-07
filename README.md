# xv6-modified

### Addition of waitx syscall: 
+ It is used to get total waiting time and running time of  a process.

+ time.c is a test program which utilizes the waitx system call by creating time command which returns the waiting time and running time of the process.

+ time takes a command as an argument and prints the runtime and waitime of that command using waitx on the terminal.

                        time  <command>


### Addition of getpinfo syscall:
+ It is used to get information of a process like its pid, total running time, number of times the process has run, the queue which it currently is in , and the numeber of ticks received in different queues.

+ It will be used in case of Multi Level Feedback Queue Scheduling.

+ We can utilize this syscall via the 'pinfo' command

+ pinfo takes pid as an argument and prints the info of the process corresponding to the pid, on the terminal.

                        pinfo  <pid>

### Implementation of  First Come First Serve Scheduling Policy
+ First come, First served (FCFS) is one of the simplest scheduling algorithm. 

+ FCFS simply queues processes in the order that they arrive in the ready queue.

+ Preemption is not allowed.

+ In this, the process that comes first will be executed first and next process starts only after the previous gets fully executed.

+ To change the default scheduling to FCFS , run the make in the following way:

                make clean 
                make qemu-nox SCHEDULER=FCFS


### Implementation of Priority Based Scheduling Policy
+ Priority based scheduling (PBS) is a preemptive algorithm.

+ Each process is assigned a priority. Process with highest priority (numerically least) is to be executed first and so on.

+ Processes with same priority are executed in a round robin fashion.

+ If a process of higher priority (numerically less) arrives while a lower priority process is being executed the lower priority process is preempted.

+ To change the default scheduling to PBS , run the make in the following way: 

                make clean 
                make qemu-nox SCHEDULER=PBS


### Addition of set_priority syscall: 
+ It is used to change the priority of a process.

+ We can access this syscall via 'priority' command

+ priority command takes the pid of the process and the new priority  as an argument and prints the old priority on the terminal.

                priority  <pid>  <new_priority>


### Implementation of Multi Level Feedback Queue Scheduling Policy
+ In Multilevel Feedback Queue Scheduling (MLFQ), processes are initially assigned the 0th queue out of total 5 queues.

+ It allows a process to move between queues. If a process uses too much CPU time, it will be moved to a lower-priority queue. Similarly, a process that waits too long in a lower-priority queue may be moved to a higher-priority queue. Aging prevents starvation.

+ To change the default scheduling to MLFQ , run the make in the following way:

                make clean 
                make qemu-nox SCHEDULER=MLFQ