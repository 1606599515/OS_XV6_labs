struct buf {
  int valid;   // has data been read from disk?
  int disk;    // does disk "own" buf?
  uint dev;  //the number of device
  uint blockno;  //the data cache of device
  struct sleeplock lock;
  uint refcnt;  //the number of reference
  struct buf *prev; // LRU cache list
  struct buf *next;  //point to the next buf
  uchar data[BSIZE];  //data cache
  uint timestamp;  //the last time the buffer is used
};

