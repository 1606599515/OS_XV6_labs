// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKET 13
#define HASH(biockno) (biockno%NBUCKET)

struct {
  struct spinlock lock;
  struct buf buf[NBUF];  //store buffers
  int size;  //the number of active buffers
  struct buf buckets[NBUCKET];  //hash buckets
  struct spinlock locks[NBUCKET];  //locks
  struct spinlock hashlock; //a lock for the hole hash
  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  //struct buf head;
} bcache;

void
binit(void)
{
  struct buf *b;
  //bcache.size=0;
  initlock(&bcache.lock, "bcache");
  initlock(&bcache.hashlock, "bcache_hash");
  for(int i=0;i<NBUCKET;i++){
    initlock(&bcache.locks[i], "bcache_bucket");
  }
  // Create linked list of buffers
  //bcache.head.prev = &bcache.head;
  //bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    //b->next = bcache.head.next;
    //b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    //bcache.head.next->prev = b;
    //bcache.head.next = b;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf* 
bget(uint dev, uint blockno)
{
  struct buf *b;  //the current buffer to search
  int idx=HASH(blockno);  //the bucket index
  struct buf *pre,*minb=0,*minpre=0;  //the min-used buffer and its prebuffer
  uint mintimestamp=-1;  //the mintimestamp

  acquire(&bcache.locks[idx]);

  // case1:Is the block already cached?
  for(b = bcache.buckets[idx].next; b; b = b->next){
    if(b->dev == dev && b->blockno == blockno){  //the cache has been cached
      b->refcnt++;
      release(&bcache.locks[idx]);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // case2:Not cached.
  acquire(&bcache.lock);  //to change the size
  if(bcache.size<NBUF)  //to allocate buffer cache
  {
    b=&bcache.buf[bcache.size++];
    release(&bcache.lock);  //have changed the size
    b->dev=dev;
    b->blockno=blockno;  //the cache number
    b->valid=0;  //have no valuable data
    b->refcnt=1;  //it is the first reference
    b->next=bcache.buckets[idx].next;
    bcache.buckets[idx].next=b;  //insert to the head
    release(&bcache.locks[idx]);  
    acquiresleep(&b->lock);
    return b;
  }
  release(&bcache.lock);  //no use to change the size
  release(&bcache.locks[idx]);
  
  // case3:Recycle the least recently used (LRU) unused buffer.
  acquire(&bcache.hashlock);  //to change the bcache
  int j=0;  //to save the i
  for(int i=0;i<NBUCKET;i++){  //to recycle the buffer
    acquire(&(bcache.locks[i]));
    for(pre=&bcache.buckets[i],b=pre->next;b!=0;pre=pre->next,b=b->next){
      if(i==HASH(blockno)&&b->dev==dev&&b->blockno==blockno)
      {
        b->refcnt++;
        release(&bcache.locks[i]);
        release(&bcache.hashlock);
        acquiresleep(&b->lock);
        return b;
      }
      if(b->refcnt==0&&b->timestamp<mintimestamp)  //relate the mintimestamp
      {
        minb=b;
        minpre=pre;
        j=i;  //to remember the i
        mintimestamp=b->timestamp;
      }
    }
    release(&(bcache.locks[i]));
  }
  acquire(&bcache.locks[j]);
  if(j!=idx)acquire(&bcache.locks[idx]);
  if(minb)
    {
      minb->dev=dev;
      minb->blockno=blockno;
      minb->valid=0;
      minb->refcnt=1;
      minpre->next=minb->next; //delete the minused buffer
      minb->next=bcache.buckets[idx].next;
      bcache.buckets[idx].next=minb;  //insert the minbuffer to new bucket
      if(j!=idx)release(&bcache.locks[idx]);
      release(&bcache.locks[j]);
      release(&bcache.hashlock);
      acquiresleep(&minb->lock);
      return minb;
    }
    // release(&bcache.locks[idx]);
    //if(++idx==NBUCKET)idx=0;  //go to the next bucket
  panic("bget: no buffers");
}
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}
// Release a locked buffer.
// Move to the head of the most-recently-used list.
//extern uint ticks;
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);
  int idx=HASH(b->blockno);
  acquire(&bcache.locks[idx]);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    //b->next->prev = b->prev;
    //b->prev->next = b->next;
    //b->next = bcache.head.next;
    //b->prev = &bcache.head;
    //bcache.head.next->prev = b;
    //bcache.head.next = b;
    b->timestamp=ticks;
  }
  release(&bcache.locks[idx]);
}
void
bpin(struct buf *b) {
  int idx=HASH(b->blockno);
  acquire(&bcache.locks[idx]);
  b->refcnt++;
  release(&bcache.locks[idx]);
}

void
bunpin(struct buf *b) {
  int idx=HASH(b->blockno);
  acquire(&bcache.locks[idx]);
  b->refcnt--;
  release(&bcache.locks[idx]);
}

