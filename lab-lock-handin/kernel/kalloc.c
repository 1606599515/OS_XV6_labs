// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  char lockname[8];
} kmems[NCPU];

void
kinit()
{
  for(int i=0;i<NCPU;i++){
    snprintf(kmems[i].lockname, 8, "kmem_%d", i);//rename of kmems' lock name
    initlock(&kmems[i].lock, kmems[i].lockname);
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  push_off();  //stop interrupt
  int i=cpuid();  //get the kmems' lock id
  pop_off();  //restart interrupt
  acquire(&kmems[i].lock);
  r->next = kmems[i].freelist;
  kmems[i].freelist = r;
  release(&kmems[i].lock);
}
struct run *
steal(int cpu_id)
{
  struct run *fast,*slow,*head;
  if(cpu_id!=cpuid())panic("steal"); //whether the cpu_id is the current cpu's
  int c=cpu_id;
  for(int i=1;i<NCPU;i++){
    if(++c==NCPU)c=0;  //a loop for travelsal
    acquire(&kmems[c].lock);
    if(kmems[c].freelist)  //has freelist to be steel
    {
      slow=head=kmems[c].freelist;
      fast=slow->next;
      while(fast)  //slow=1/2 fast
      {
        fast=fast->next;
        if(fast)
        {
          slow=slow->next;
          fast=fast->next;
        }
      }
      kmems[c].freelist=slow->next;  //steal half of the freelist
      slow->next=0;
      release(&kmems[c].lock);
     
      return head;
    }
    release(&kmems[c].lock);
  }
    return 0;
}
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.

void *
kalloc(void)
{
  struct run *r;
  push_off();
  int i=cpuid();  //get the kmems' lock id
  pop_off();
  acquire(&kmems[i].lock);
  r = kmems[i].freelist;
  if(!r)  //the current cpu's page is free and has stealed
  {
    r=steal(i);
  }
  if(r)
    kmems[i].freelist = r->next;
  release(&kmems[i].lock);
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
