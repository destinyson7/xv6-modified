#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "proc_stat.h"

int main(int argc, char *argv[]) 
{
    if(argc != 2) 
    {
        printf(1, "Usage: pinfo <pid>\n");
    }

    else 
    {
        struct proc_stat stat;

        int pid = atoi(argv[1]);
        int success = getpinfo(pid, &stat);

        if(success == 0) 
        {
            printf(1, "pid does not exist\n");
        }

        else 
        {
            printf(1, "pid: %d\n", stat.pid);
            printf(1, "Total Runtime of process: %d\n", stat.runtime);
            printf(1, "Number of times process has run: %d\n", stat.num_run);
            printf(1, "It is currently in Queue: %d\n", stat.current_queue + 1);
            
            for(int i = 0; i < 5; i++) 
            {
                printf(1, "Number of ticks process has spent in queue %d: %d\n", i + 1, stat.ticks[i]);
            }

        }
    }

    exit();
}