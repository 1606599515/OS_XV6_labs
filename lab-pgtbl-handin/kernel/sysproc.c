#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  //get user's information
  
  struct proc *p=myproc();  //userpage
  uint64 firstAddr;  //the first location of userpage
  int numpage;  //number of pages
  uint64 outAddr;  //the location to store the result
  //get user's information
  //try(argaddr(0,&firstAddr),return -1);
  if(argaddr(0,&firstAddr)!=0)return -1;  //printf("pgacess:argaddr");
  //try(argint(1,&ckSize),return -1);
  if(argint(1,&numpage)!=0)return -1;//printf("pgacess:argint");
  //try(argaddr(2,&maskAddr),return -1);
  if(argaddr(2,&outAddr)!=0)return -1;//printf("pgacess:argaddr");

  if(p->pagetable==0||numpage>32)return -1;
  if(outAddr+4>=MAXVA || firstAddr+numpage*PGSIZE>=MAXVA){
    return -1;
  }


  uint32 bitmap=0;  //mask the visited bit
  uint64 s=PGROUNDDOWN(firstAddr);
  for(int i=0;i<numpage&&s<MAXVA;i++,s+=PGSIZE){
    pte_t* pte=walk(p->pagetable,s,0);  //return leave
    if((*pte&PTE_A)&&pte!=0)  //affective and have beed visited
    {
      bitmap|=(1<<i);  //set tag of the pte_t visited
      *pte=*pte & (~PTE_A);  //reset firstPate[i]
    }
  }
  //try(copyout(userpt,(uint64)maskAddr,&mask,sizeof(uint)),return -1); 
  copyout(p->pagetable,outAddr,(char *)&bitmap,4) ;
  return 0;//copy to user's space
}
#endif

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
