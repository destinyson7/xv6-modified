typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

#define AGE 20

int sz[5];
int front[5];
int rear[5];
int ticksQ[5];
struct proc* queue[5][64];

int isEmpty(int);
int isFull(int);
void push(int, struct proc*);
struct proc* pop(int);