#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char *argv[])
{
  int pid, priority;

  if(argc != 3)
  {
    printf(1, "Usage: priority <pid> <new_priority>\n");
  }

  else
  {
    pid = atoi(argv[1]);
    priority = atoi(argv[2]);

    if(priority < 0 || priority > 100)
    {
      printf(1, "Priority should be between 0 and 100\n");
    }

    else
    {
      int old_priority = set_priority(pid, priority);

      if(old_priority < 0)
      {
        printf(1, "Invalid pid\n");
      }

      else
      {
        printf(1, "Old Priority of process with pid = %d was %d\n", pid, old_priority);
      }
    }
  }
}
