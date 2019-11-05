#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char *argv[])
{
  
  int wtime, rtime;
  int pid = fork();
  int success = 1;

  if(pid < 0)
  {
    printf(1, "Unable to fork\n");
  }

  else if(pid == 0)
  {
    for(int i = 0; i < argc-1; i++)
    {
      argv[i] = argv[i+1];
    }
    argv[argc-1] = 0;

    exec(argv[0], argv);

    success = 0;
    printf(1, "exec: fail\n");
  }

  else
  {
    // printf(1, "******time.c  %d*******\n", pid);
    waitx(&wtime, &rtime);
  }

  if(success)
  {
    printf(1, "rtime = %d, wtime = %d\n", rtime, wtime);
  }
  
  exit();
}
