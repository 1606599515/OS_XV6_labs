
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7d2050ef          	jal	ra,800057e8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	17a080e7          	jalr	378(ra) # 800001c2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	188080e7          	jalr	392(ra) # 800061e2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	228080e7          	jalr	552(ra) # 80006296 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c0e080e7          	jalr	-1010(ra) # 80005c98 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	05e080e7          	jalr	94(ra) # 80006152 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	0b6080e7          	jalr	182(ra) # 800061e2 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	152080e7          	jalr	338(ra) # 80006296 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	070080e7          	jalr	112(ra) # 800001c2 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	128080e7          	jalr	296(ra) # 80006296 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <freeMem>:
uint64
freeMem(void)
{
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	1000                	addi	s0,sp,32
  struct run *currfree;
  uint64 num=0;
  acquire(&kmem.lock);  //lock the proc
    80000182:	00009497          	auipc	s1,0x9
    80000186:	eae48493          	addi	s1,s1,-338 # 80009030 <kmem>
    8000018a:	8526                	mv	a0,s1
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	056080e7          	jalr	86(ra) # 800061e2 <acquire>
  currfree=kmem.freelist;
    80000194:	6c9c                	ld	a5,24(s1)
  while(currfree)  //count the free mem
    80000196:	c785                	beqz	a5,800001be <freeMem+0x46>
  uint64 num=0;
    80000198:	4481                	li	s1,0
  {
    currfree=currfree->next;
    8000019a:	639c                	ld	a5,0(a5)
    num++;
    8000019c:	0485                	addi	s1,s1,1
  while(currfree)  //count the free mem
    8000019e:	fff5                	bnez	a5,8000019a <freeMem+0x22>
  }
  release(&kmem.lock);  //release the proc
    800001a0:	00009517          	auipc	a0,0x9
    800001a4:	e9050513          	addi	a0,a0,-368 # 80009030 <kmem>
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	0ee080e7          	jalr	238(ra) # 80006296 <release>
  return num*PGSIZE;  //number of page * size of page
}
    800001b0:	00c49513          	slli	a0,s1,0xc
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6105                	addi	sp,sp,32
    800001bc:	8082                	ret
  uint64 num=0;
    800001be:	4481                	li	s1,0
    800001c0:	b7c5                	j	800001a0 <freeMem+0x28>

00000000800001c2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001c8:	ce09                	beqz	a2,800001e2 <memset+0x20>
    800001ca:	87aa                	mv	a5,a0
    800001cc:	fff6071b          	addiw	a4,a2,-1
    800001d0:	1702                	slli	a4,a4,0x20
    800001d2:	9301                	srli	a4,a4,0x20
    800001d4:	0705                	addi	a4,a4,1
    800001d6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x16>
  }
  return dst;
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret

00000000800001e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e8:	1141                	addi	sp,sp,-16
    800001ea:	e422                	sd	s0,8(sp)
    800001ec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ee:	ca05                	beqz	a2,8000021e <memcmp+0x36>
    800001f0:	fff6069b          	addiw	a3,a2,-1
    800001f4:	1682                	slli	a3,a3,0x20
    800001f6:	9281                	srli	a3,a3,0x20
    800001f8:	0685                	addi	a3,a3,1
    800001fa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fc:	00054783          	lbu	a5,0(a0)
    80000200:	0005c703          	lbu	a4,0(a1)
    80000204:	00e79863          	bne	a5,a4,80000214 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000208:	0505                	addi	a0,a0,1
    8000020a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020c:	fed518e3          	bne	a0,a3,800001fc <memcmp+0x14>
  }

  return 0;
    80000210:	4501                	li	a0,0
    80000212:	a019                	j	80000218 <memcmp+0x30>
      return *s1 - *s2;
    80000214:	40e7853b          	subw	a0,a5,a4
}
    80000218:	6422                	ld	s0,8(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
  return 0;
    8000021e:	4501                	li	a0,0
    80000220:	bfe5                	j	80000218 <memcmp+0x30>

0000000080000222 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000222:	1141                	addi	sp,sp,-16
    80000224:	e422                	sd	s0,8(sp)
    80000226:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000228:	ca0d                	beqz	a2,8000025a <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022a:	00a5f963          	bgeu	a1,a0,8000023c <memmove+0x1a>
    8000022e:	02061693          	slli	a3,a2,0x20
    80000232:	9281                	srli	a3,a3,0x20
    80000234:	00d58733          	add	a4,a1,a3
    80000238:	02e56463          	bltu	a0,a4,80000260 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	0785                	addi	a5,a5,1
    80000246:	97ae                	add	a5,a5,a1
    80000248:	872a                	mv	a4,a0
      *d++ = *s++;
    8000024a:	0585                	addi	a1,a1,1
    8000024c:	0705                	addi	a4,a4,1
    8000024e:	fff5c683          	lbu	a3,-1(a1)
    80000252:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000256:	fef59ae3          	bne	a1,a5,8000024a <memmove+0x28>

  return dst;
}
    8000025a:	6422                	ld	s0,8(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret
    d += n;
    80000260:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000262:	fff6079b          	addiw	a5,a2,-1
    80000266:	1782                	slli	a5,a5,0x20
    80000268:	9381                	srli	a5,a5,0x20
    8000026a:	fff7c793          	not	a5,a5
    8000026e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000270:	177d                	addi	a4,a4,-1
    80000272:	16fd                	addi	a3,a3,-1
    80000274:	00074603          	lbu	a2,0(a4)
    80000278:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027c:	fef71ae3          	bne	a4,a5,80000270 <memmove+0x4e>
    80000280:	bfe9                	j	8000025a <memmove+0x38>

0000000080000282 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	f98080e7          	jalr	-104(ra) # 80000222 <memmove>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a0:	ce11                	beqz	a2,800002bc <strncmp+0x22>
    800002a2:	00054783          	lbu	a5,0(a0)
    800002a6:	cf89                	beqz	a5,800002c0 <strncmp+0x26>
    800002a8:	0005c703          	lbu	a4,0(a1)
    800002ac:	00f71a63          	bne	a4,a5,800002c0 <strncmp+0x26>
    n--, p++, q++;
    800002b0:	367d                	addiw	a2,a2,-1
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b6:	f675                	bnez	a2,800002a2 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b8:	4501                	li	a0,0
    800002ba:	a809                	j	800002cc <strncmp+0x32>
    800002bc:	4501                	li	a0,0
    800002be:	a039                	j	800002cc <strncmp+0x32>
  if(n == 0)
    800002c0:	ca09                	beqz	a2,800002d2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c2:	00054503          	lbu	a0,0(a0)
    800002c6:	0005c783          	lbu	a5,0(a1)
    800002ca:	9d1d                	subw	a0,a0,a5
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
    return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <strncmp+0x32>

00000000800002d6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002dc:	872a                	mv	a4,a0
    800002de:	8832                	mv	a6,a2
    800002e0:	367d                	addiw	a2,a2,-1
    800002e2:	01005963          	blez	a6,800002f4 <strncpy+0x1e>
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	0005c783          	lbu	a5,0(a1)
    800002ec:	fef70fa3          	sb	a5,-1(a4)
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	f7f5                	bnez	a5,800002de <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f4:	00c05d63          	blez	a2,8000030e <strncpy+0x38>
    800002f8:	86ba                	mv	a3,a4
    *s++ = 0;
    800002fa:	0685                	addi	a3,a3,1
    800002fc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000300:	fff6c793          	not	a5,a3
    80000304:	9fb9                	addw	a5,a5,a4
    80000306:	010787bb          	addw	a5,a5,a6
    8000030a:	fef048e3          	bgtz	a5,800002fa <strncpy+0x24>
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031a:	02c05363          	blez	a2,80000340 <safestrcpy+0x2c>
    8000031e:	fff6069b          	addiw	a3,a2,-1
    80000322:	1682                	slli	a3,a3,0x20
    80000324:	9281                	srli	a3,a3,0x20
    80000326:	96ae                	add	a3,a3,a1
    80000328:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032a:	00d58963          	beq	a1,a3,8000033c <safestrcpy+0x28>
    8000032e:	0585                	addi	a1,a1,1
    80000330:	0785                	addi	a5,a5,1
    80000332:	fff5c703          	lbu	a4,-1(a1)
    80000336:	fee78fa3          	sb	a4,-1(a5)
    8000033a:	fb65                	bnez	a4,8000032a <safestrcpy+0x16>
    ;
  *s = 0;
    8000033c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret

0000000080000346 <strlen>:

int
strlen(const char *s)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf91                	beqz	a5,8000036c <strlen+0x26>
    80000352:	0505                	addi	a0,a0,1
    80000354:	87aa                	mv	a5,a0
    80000356:	4685                	li	a3,1
    80000358:	9e89                	subw	a3,a3,a0
    8000035a:	00f6853b          	addw	a0,a3,a5
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff7c703          	lbu	a4,-1(a5)
    80000364:	fb7d                	bnez	a4,8000035a <strlen+0x14>
    ;
  return n;
}
    80000366:	6422                	ld	s0,8(sp)
    80000368:	0141                	addi	sp,sp,16
    8000036a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036c:	4501                	li	a0,0
    8000036e:	bfe5                	j	80000366 <strlen+0x20>

0000000080000370 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	aee080e7          	jalr	-1298(ra) # 80000e66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000380:	00009717          	auipc	a4,0x9
    80000384:	c8070713          	addi	a4,a4,-896 # 80009000 <started>
  if(cpuid() == 0){
    80000388:	c139                	beqz	a0,800003ce <main+0x5e>
    while(started == 0)
    8000038a:	431c                	lw	a5,0(a4)
    8000038c:	2781                	sext.w	a5,a5
    8000038e:	dff5                	beqz	a5,8000038a <main+0x1a>
      ;
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000394:	00001097          	auipc	ra,0x1
    80000398:	ad2080e7          	jalr	-1326(ra) # 80000e66 <cpuid>
    8000039c:	85aa                	mv	a1,a0
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c9a50513          	addi	a0,a0,-870 # 80008038 <etext+0x38>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	93c080e7          	jalr	-1732(ra) # 80005ce2 <printf>
    kvminithart();    // turn on paging
    800003ae:	00000097          	auipc	ra,0x0
    800003b2:	0d8080e7          	jalr	216(ra) # 80000486 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b6:	00001097          	auipc	ra,0x1
    800003ba:	784080e7          	jalr	1924(ra) # 80001b3a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003be:	00005097          	auipc	ra,0x5
    800003c2:	db2080e7          	jalr	-590(ra) # 80005170 <plicinithart>
  }

  scheduler();        
    800003c6:	00001097          	auipc	ra,0x1
    800003ca:	fde080e7          	jalr	-34(ra) # 800013a4 <scheduler>
    consoleinit();
    800003ce:	00005097          	auipc	ra,0x5
    800003d2:	7dc080e7          	jalr	2012(ra) # 80005baa <consoleinit>
    printfinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	af2080e7          	jalr	-1294(ra) # 80005ec8 <printfinit>
    printf("\n");
    800003de:	00008517          	auipc	a0,0x8
    800003e2:	c6a50513          	addi	a0,a0,-918 # 80008048 <etext+0x48>
    800003e6:	00006097          	auipc	ra,0x6
    800003ea:	8fc080e7          	jalr	-1796(ra) # 80005ce2 <printf>
    printf("xv6 kernel is booting\n");
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c3250513          	addi	a0,a0,-974 # 80008020 <etext+0x20>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	8ec080e7          	jalr	-1812(ra) # 80005ce2 <printf>
    printf("\n");
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c4a50513          	addi	a0,a0,-950 # 80008048 <etext+0x48>
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	8dc080e7          	jalr	-1828(ra) # 80005ce2 <printf>
    kinit();         // physical page allocator
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	cce080e7          	jalr	-818(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	322080e7          	jalr	802(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	068080e7          	jalr	104(ra) # 80000486 <kvminithart>
    procinit();      // process table
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	990080e7          	jalr	-1648(ra) # 80000db6 <procinit>
    trapinit();      // trap vectors
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	6e4080e7          	jalr	1764(ra) # 80001b12 <trapinit>
    trapinithart();  // install kernel trap vector
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	704080e7          	jalr	1796(ra) # 80001b3a <trapinithart>
    plicinit();      // set up interrupt controller
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	d1c080e7          	jalr	-740(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	d2a080e7          	jalr	-726(ra) # 80005170 <plicinithart>
    binit();         // buffer cache
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	f04080e7          	jalr	-252(ra) # 80002352 <binit>
    iinit();         // inode table
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	594080e7          	jalr	1428(ra) # 800029ea <iinit>
    fileinit();      // file table
    8000045e:	00003097          	auipc	ra,0x3
    80000462:	53e080e7          	jalr	1342(ra) # 8000399c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000466:	00005097          	auipc	ra,0x5
    8000046a:	e2c080e7          	jalr	-468(ra) # 80005292 <virtio_disk_init>
    userinit();      // first user process
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	cfc080e7          	jalr	-772(ra) # 8000116a <userinit>
    __sync_synchronize();
    80000476:	0ff0000f          	fence
    started = 1;
    8000047a:	4785                	li	a5,1
    8000047c:	00009717          	auipc	a4,0x9
    80000480:	b8f72223          	sw	a5,-1148(a4) # 80009000 <started>
    80000484:	b789                	j	800003c6 <main+0x56>

0000000080000486 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e422                	sd	s0,8(sp)
    8000048a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00009797          	auipc	a5,0x9
    80000490:	b7c7b783          	ld	a5,-1156(a5) # 80009008 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000049c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004a0:	12000073          	sfence.vma
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00005097          	auipc	ra,0x5
    800004dc:	7c0080e7          	jalr	1984(ra) # 80005c98 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cce080e7          	jalr	-818(ra) # 800001c2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	00a7d513          	srli	a0,a5,0xa
    8000058a:	0532                	slli	a0,a0,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c205                	beqz	a2,800005c8 <mappages+0x36>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	77fd                	lui	a5,0xfffff
    800005b0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	15fd                	addi	a1,a1,-1
    800005b6:	00c589b3          	add	s3,a1,a2
    800005ba:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005be:	8952                	mv	s2,s4
    800005c0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	a015                	j	800005ea <mappages+0x58>
    panic("mappages: size");
    800005c8:	00008517          	auipc	a0,0x8
    800005cc:	a9050513          	addi	a0,a0,-1392 # 80008058 <etext+0x58>
    800005d0:	00005097          	auipc	ra,0x5
    800005d4:	6c8080e7          	jalr	1736(ra) # 80005c98 <panic>
      panic("mappages: remap");
    800005d8:	00008517          	auipc	a0,0x8
    800005dc:	a9050513          	addi	a0,a0,-1392 # 80008068 <etext+0x68>
    800005e0:	00005097          	auipc	ra,0x5
    800005e4:	6b8080e7          	jalr	1720(ra) # 80005c98 <panic>
    a += PGSIZE;
    800005e8:	995e                	add	s2,s2,s7
  for(;;){
    800005ea:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	4605                	li	a2,1
    800005f0:	85ca                	mv	a1,s2
    800005f2:	8556                	mv	a0,s5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	eb6080e7          	jalr	-330(ra) # 800004aa <walk>
    800005fc:	cd19                	beqz	a0,8000061a <mappages+0x88>
    if(*pte & PTE_V)
    800005fe:	611c                	ld	a5,0(a0)
    80000600:	8b85                	andi	a5,a5,1
    80000602:	fbf9                	bnez	a5,800005d8 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000604:	80b1                	srli	s1,s1,0xc
    80000606:	04aa                	slli	s1,s1,0xa
    80000608:	0164e4b3          	or	s1,s1,s6
    8000060c:	0014e493          	ori	s1,s1,1
    80000610:	e104                	sd	s1,0(a0)
    if(a == last)
    80000612:	fd391be3          	bne	s2,s3,800005e8 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000616:	4501                	li	a0,0
    80000618:	a011                	j	8000061c <mappages+0x8a>
      return -1;
    8000061a:	557d                	li	a0,-1
}
    8000061c:	60a6                	ld	ra,72(sp)
    8000061e:	6406                	ld	s0,64(sp)
    80000620:	74e2                	ld	s1,56(sp)
    80000622:	7942                	ld	s2,48(sp)
    80000624:	79a2                	ld	s3,40(sp)
    80000626:	7a02                	ld	s4,32(sp)
    80000628:	6ae2                	ld	s5,24(sp)
    8000062a:	6b42                	ld	s6,16(sp)
    8000062c:	6ba2                	ld	s7,8(sp)
    8000062e:	6161                	addi	sp,sp,80
    80000630:	8082                	ret

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	63e080e7          	jalr	1598(ra) # 80005c98 <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aaa080e7          	jalr	-1366(ra) # 80000118 <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b46080e7          	jalr	-1210(ra) # 800001c2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	5fe080e7          	jalr	1534(ra) # 80000d20 <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00009797          	auipc	a5,0x9
    8000074c:	8ca7b023          	sd	a0,-1856(a5) # 80009008 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e863          	bltu	a1,s3,800007f4 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	4f2080e7          	jalr	1266(ra) # 80005c98 <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	4e2080e7          	jalr	1250(ra) # 80005c98 <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	4d2080e7          	jalr	1234(ra) # 80005c98 <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	4c2080e7          	jalr	1218(ra) # 80005c98 <panic>
      uint64 pa = PTE2PA(*pte);
    800007de:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e0:	0532                	slli	a0,a0,0xc
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	83a080e7          	jalr	-1990(ra) # 8000001c <kfree>
    *pte = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ee:	995a                	add	s2,s2,s6
    800007f0:	f9397ce3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f4:	4601                	li	a2,0
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8552                	mv	a0,s4
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	cb0080e7          	jalr	-848(ra) # 800004aa <walk>
    80000802:	84aa                	mv	s1,a0
    80000804:	d54d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000806:	6108                	ld	a0,0(a0)
    80000808:	00157793          	andi	a5,a0,1
    8000080c:	dbcd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080e:	3ff57793          	andi	a5,a0,1023
    80000812:	fb778ee3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    80000816:	fc0a8ae3          	beqz	s5,800007ea <uvmunmap+0x92>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f2080e7          	jalr	-1806(ra) # 80000118 <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	98c080e7          	jalr	-1652(ra) # 800001c2 <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvminit+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b2080e7          	jalr	-1870(ra) # 80000118 <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	94e080e7          	jalr	-1714(ra) # 800001c2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	98e080e7          	jalr	-1650(ra) # 80000222 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("inituvm: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	3e4080e7          	jalr	996(ra) # 80005c98 <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	767d                	lui	a2,0xfffff
    800008d8:	8f71                	and	a4,a4,a2
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff1                	and	a5,a5,a2
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66163          	bltu	a2,a1,800009a6 <uvmalloc+0xa2>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	0080                	addi	s0,sp,64
    8000091a:	8aaa                	mv	s5,a0
    8000091c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091e:	6985                	lui	s3,0x1
    80000920:	19fd                	addi	s3,s3,-1
    80000922:	95ce                	add	a1,a1,s3
    80000924:	79fd                	lui	s3,0xfffff
    80000926:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092a:	08c9f063          	bgeu	s3,a2,800009aa <uvmalloc+0xa6>
    8000092e:	894e                	mv	s2,s3
    mem = kalloc();
    80000930:	fffff097          	auipc	ra,0xfffff
    80000934:	7e8080e7          	jalr	2024(ra) # 80000118 <kalloc>
    80000938:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093a:	c51d                	beqz	a0,80000968 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	882080e7          	jalr	-1918(ra) # 800001c2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000948:	4779                	li	a4,30
    8000094a:	86a6                	mv	a3,s1
    8000094c:	6605                	lui	a2,0x1
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c40080e7          	jalr	-960(ra) # 80000592 <mappages>
    8000095a:	e905                	bnez	a0,8000098a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	993e                	add	s2,s2,a5
    80000960:	fd4968e3          	bltu	s2,s4,80000930 <uvmalloc+0x2c>
  return newsz;
    80000964:	8552                	mv	a0,s4
    80000966:	a809                	j	80000978 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f4e080e7          	jalr	-178(ra) # 800008bc <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	74a2                	ld	s1,40(sp)
    8000097e:	7902                	ld	s2,32(sp)
    80000980:	69e2                	ld	s3,24(sp)
    80000982:	6a42                	ld	s4,16(sp)
    80000984:	6aa2                	ld	s5,8(sp)
    80000986:	6121                	addi	sp,sp,64
    80000988:	8082                	ret
      kfree(mem);
    8000098a:	8526                	mv	a0,s1
    8000098c:	fffff097          	auipc	ra,0xfffff
    80000990:	690080e7          	jalr	1680(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f22080e7          	jalr	-222(ra) # 800008bc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	bfd1                	j	80000978 <uvmalloc+0x74>
    return oldsz;
    800009a6:	852e                	mv	a0,a1
}
    800009a8:	8082                	ret
  return newsz;
    800009aa:	8532                	mv	a0,a2
    800009ac:	b7f1                	j	80000978 <uvmalloc+0x74>

00000000800009ae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
    800009be:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c0:	84aa                	mv	s1,a0
    800009c2:	6905                	lui	s2,0x1
    800009c4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c6:	4985                	li	s3,1
    800009c8:	a821                	j	800009e0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ca:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009cc:	0532                	slli	a0,a0,0xc
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	fe0080e7          	jalr	-32(ra) # 800009ae <freewalk>
      pagetable[i] = 0;
    800009d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009da:	04a1                	addi	s1,s1,8
    800009dc:	03248163          	beq	s1,s2,800009fe <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	00f57793          	andi	a5,a0,15
    800009e6:	ff3782e3          	beq	a5,s3,800009ca <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ea:	8905                	andi	a0,a0,1
    800009ec:	d57d                	beqz	a0,800009da <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	70a50513          	addi	a0,a0,1802 # 800080f8 <etext+0xf8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	2a2080e7          	jalr	674(ra) # 80005c98 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fe:	8552                	mv	a0,s4
    80000a00:	fffff097          	auipc	ra,0xfffff
    80000a04:	61c080e7          	jalr	1564(ra) # 8000001c <kfree>
}
    80000a08:	70a2                	ld	ra,40(sp)
    80000a0a:	7402                	ld	s0,32(sp)
    80000a0c:	64e2                	ld	s1,24(sp)
    80000a0e:	6942                	ld	s2,16(sp)
    80000a10:	69a2                	ld	s3,8(sp)
    80000a12:	6a02                	ld	s4,0(sp)
    80000a14:	6145                	addi	sp,sp,48
    80000a16:	8082                	ret

0000000080000a18 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	1000                	addi	s0,sp,32
    80000a22:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a24:	e999                	bnez	a1,80000a3a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	f86080e7          	jalr	-122(ra) # 800009ae <freewalk>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	167d                	addi	a2,a2,-1
    80000a3e:	962e                	add	a2,a2,a1
    80000a40:	4685                	li	a3,1
    80000a42:	8231                	srli	a2,a2,0xc
    80000a44:	4581                	li	a1,0
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	d12080e7          	jalr	-750(ra) # 80000758 <uvmunmap>
    80000a4e:	bfe1                	j	80000a26 <uvmfree+0xe>

0000000080000a50 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	c679                	beqz	a2,80000b1e <uvmcopy+0xce>
{
    80000a52:	715d                	addi	sp,sp,-80
    80000a54:	e486                	sd	ra,72(sp)
    80000a56:	e0a2                	sd	s0,64(sp)
    80000a58:	fc26                	sd	s1,56(sp)
    80000a5a:	f84a                	sd	s2,48(sp)
    80000a5c:	f44e                	sd	s3,40(sp)
    80000a5e:	f052                	sd	s4,32(sp)
    80000a60:	ec56                	sd	s5,24(sp)
    80000a62:	e85a                	sd	s6,16(sp)
    80000a64:	e45e                	sd	s7,8(sp)
    80000a66:	0880                	addi	s0,sp,80
    80000a68:	8b2a                	mv	s6,a0
    80000a6a:	8aae                	mv	s5,a1
    80000a6c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a70:	4601                	li	a2,0
    80000a72:	85ce                	mv	a1,s3
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	a34080e7          	jalr	-1484(ra) # 800004aa <walk>
    80000a7e:	c531                	beqz	a0,80000aca <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a80:	6118                	ld	a4,0(a0)
    80000a82:	00177793          	andi	a5,a4,1
    80000a86:	cbb1                	beqz	a5,80000ada <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a88:	00a75593          	srli	a1,a4,0xa
    80000a8c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a90:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a94:	fffff097          	auipc	ra,0xfffff
    80000a98:	684080e7          	jalr	1668(ra) # 80000118 <kalloc>
    80000a9c:	892a                	mv	s2,a0
    80000a9e:	c939                	beqz	a0,80000af4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa0:	6605                	lui	a2,0x1
    80000aa2:	85de                	mv	a1,s7
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	77e080e7          	jalr	1918(ra) # 80000222 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aac:	8726                	mv	a4,s1
    80000aae:	86ca                	mv	a3,s2
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	adc080e7          	jalr	-1316(ra) # 80000592 <mappages>
    80000abe:	e515                	bnez	a0,80000aea <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	99be                	add	s3,s3,a5
    80000ac4:	fb49e6e3          	bltu	s3,s4,80000a70 <uvmcopy+0x20>
    80000ac8:	a081                	j	80000b08 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	63e50513          	addi	a0,a0,1598 # 80008108 <etext+0x108>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	1c6080e7          	jalr	454(ra) # 80005c98 <panic>
      panic("uvmcopy: page not present");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	64e50513          	addi	a0,a0,1614 # 80008128 <etext+0x128>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	1b6080e7          	jalr	438(ra) # 80005c98 <panic>
      kfree(mem);
    80000aea:	854a                	mv	a0,s2
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af4:	4685                	li	a3,1
    80000af6:	00c9d613          	srli	a2,s3,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	8556                	mv	a0,s5
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	c5a080e7          	jalr	-934(ra) # 80000758 <uvmunmap>
  return -1;
    80000b06:	557d                	li	a0,-1
}
    80000b08:	60a6                	ld	ra,72(sp)
    80000b0a:	6406                	ld	s0,64(sp)
    80000b0c:	74e2                	ld	s1,56(sp)
    80000b0e:	7942                	ld	s2,48(sp)
    80000b10:	79a2                	ld	s3,40(sp)
    80000b12:	7a02                	ld	s4,32(sp)
    80000b14:	6ae2                	ld	s5,24(sp)
    80000b16:	6b42                	ld	s6,16(sp)
    80000b18:	6ba2                	ld	s7,8(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret
  return 0;
    80000b1e:	4501                	li	a0,0
}
    80000b20:	8082                	ret

0000000080000b22 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2a:	4601                	li	a2,0
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	97e080e7          	jalr	-1666(ra) # 800004aa <walk>
  if(pte == 0)
    80000b34:	c901                	beqz	a0,80000b44 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	9bbd                	andi	a5,a5,-17
    80000b3a:	e11c                	sd	a5,0(a0)
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret
    panic("uvmclear");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	60450513          	addi	a0,a0,1540 # 80008148 <etext+0x148>
    80000b4c:	00005097          	auipc	ra,0x5
    80000b50:	14c080e7          	jalr	332(ra) # 80005c98 <panic>

0000000080000b54 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b54:	c6bd                	beqz	a3,80000bc2 <copyout+0x6e>
{
    80000b56:	715d                	addi	sp,sp,-80
    80000b58:	e486                	sd	ra,72(sp)
    80000b5a:	e0a2                	sd	s0,64(sp)
    80000b5c:	fc26                	sd	s1,56(sp)
    80000b5e:	f84a                	sd	s2,48(sp)
    80000b60:	f44e                	sd	s3,40(sp)
    80000b62:	f052                	sd	s4,32(sp)
    80000b64:	ec56                	sd	s5,24(sp)
    80000b66:	e85a                	sd	s6,16(sp)
    80000b68:	e45e                	sd	s7,8(sp)
    80000b6a:	e062                	sd	s8,0(sp)
    80000b6c:	0880                	addi	s0,sp,80
    80000b6e:	8b2a                	mv	s6,a0
    80000b70:	8c2e                	mv	s8,a1
    80000b72:	8a32                	mv	s4,a2
    80000b74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b78:	6a85                	lui	s5,0x1
    80000b7a:	a015                	j	80000b9e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7c:	9562                	add	a0,a0,s8
    80000b7e:	0004861b          	sext.w	a2,s1
    80000b82:	85d2                	mv	a1,s4
    80000b84:	41250533          	sub	a0,a0,s2
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	69a080e7          	jalr	1690(ra) # 80000222 <memmove>

    len -= n;
    80000b90:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b94:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b96:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9a:	02098263          	beqz	s3,80000bbe <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ca                	mv	a1,s2
    80000ba4:	855a                	mv	a0,s6
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	9aa080e7          	jalr	-1622(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bae:	cd01                	beqz	a0,80000bc6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb0:	418904b3          	sub	s1,s2,s8
    80000bb4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb6:	fc99f3e3          	bgeu	s3,s1,80000b7c <copyout+0x28>
    80000bba:	84ce                	mv	s1,s3
    80000bbc:	b7c1                	j	80000b7c <copyout+0x28>
  }
  return 0;
    80000bbe:	4501                	li	a0,0
    80000bc0:	a021                	j	80000bc8 <copyout+0x74>
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret
      return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6c02                	ld	s8,0(sp)
    80000bdc:	6161                	addi	sp,sp,80
    80000bde:	8082                	ret

0000000080000be0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be0:	c6bd                	beqz	a3,80000c4e <copyin+0x6e>
{
    80000be2:	715d                	addi	sp,sp,-80
    80000be4:	e486                	sd	ra,72(sp)
    80000be6:	e0a2                	sd	s0,64(sp)
    80000be8:	fc26                	sd	s1,56(sp)
    80000bea:	f84a                	sd	s2,48(sp)
    80000bec:	f44e                	sd	s3,40(sp)
    80000bee:	f052                	sd	s4,32(sp)
    80000bf0:	ec56                	sd	s5,24(sp)
    80000bf2:	e85a                	sd	s6,16(sp)
    80000bf4:	e45e                	sd	s7,8(sp)
    80000bf6:	e062                	sd	s8,0(sp)
    80000bf8:	0880                	addi	s0,sp,80
    80000bfa:	8b2a                	mv	s6,a0
    80000bfc:	8a2e                	mv	s4,a1
    80000bfe:	8c32                	mv	s8,a2
    80000c00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c04:	6a85                	lui	s5,0x1
    80000c06:	a015                	j	80000c2a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c08:	9562                	add	a0,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412505b3          	sub	a1,a0,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60e080e7          	jalr	1550(ra) # 80000222 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	91e080e7          	jalr	-1762(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c42:	fc99f3e3          	bgeu	s3,s1,80000c08 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	b7c1                	j	80000c08 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x74>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c6c5                	beqz	a3,80000d14 <copyinstr+0xa8>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a035                	j	80000cbc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	0017b793          	seqz	a5,a5
    80000c9c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6161                	addi	sp,sp,80
    80000cb4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cba:	c8a9                	beqz	s1,80000d0c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cbc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc0:	85ca                	mv	a1,s2
    80000cc2:	8552                	mv	a0,s4
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	88c080e7          	jalr	-1908(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000ccc:	c131                	beqz	a0,80000d10 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cce:	41790833          	sub	a6,s2,s7
    80000cd2:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd4:	0104f363          	bgeu	s1,a6,80000cda <copyinstr+0x6e>
    80000cd8:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cda:	955e                	add	a0,a0,s7
    80000cdc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce0:	fc080be3          	beqz	a6,80000cb6 <copyinstr+0x4a>
    80000ce4:	985a                	add	a6,a6,s6
    80000ce6:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce8:	41650633          	sub	a2,a0,s6
    80000cec:	14fd                	addi	s1,s1,-1
    80000cee:	9b26                	add	s6,s6,s1
    80000cf0:	00f60733          	add	a4,a2,a5
    80000cf4:	00074703          	lbu	a4,0(a4)
    80000cf8:	df49                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cfa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfe:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d02:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d04:	ff0796e3          	bne	a5,a6,80000cf0 <copyinstr+0x84>
      dst++;
    80000d08:	8b42                	mv	s6,a6
    80000d0a:	b775                	j	80000cb6 <copyinstr+0x4a>
    80000d0c:	4781                	li	a5,0
    80000d0e:	b769                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d10:	557d                	li	a0,-1
    80000d12:	b779                	j	80000ca0 <copyinstr+0x34>
  int got_null = 0;
    80000d14:	4781                	li	a5,0
  if(got_null){
    80000d16:	0017b793          	seqz	a5,a5
    80000d1a:	40f00533          	neg	a0,a5
}
    80000d1e:	8082                	ret

0000000080000d20 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d20:	7139                	addi	sp,sp,-64
    80000d22:	fc06                	sd	ra,56(sp)
    80000d24:	f822                	sd	s0,48(sp)
    80000d26:	f426                	sd	s1,40(sp)
    80000d28:	f04a                	sd	s2,32(sp)
    80000d2a:	ec4e                	sd	s3,24(sp)
    80000d2c:	e852                	sd	s4,16(sp)
    80000d2e:	e456                	sd	s5,8(sp)
    80000d30:	e05a                	sd	s6,0(sp)
    80000d32:	0080                	addi	s0,sp,64
    80000d34:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	00008497          	auipc	s1,0x8
    80000d3a:	74a48493          	addi	s1,s1,1866 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d3e:	8b26                	mv	s6,s1
    80000d40:	00007a97          	auipc	s5,0x7
    80000d44:	2c0a8a93          	addi	s5,s5,704 # 80008000 <etext>
    80000d48:	04000937          	lui	s2,0x4000
    80000d4c:	197d                	addi	s2,s2,-1
    80000d4e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	0000ea17          	auipc	s4,0xe
    80000d54:	330a0a13          	addi	s4,s4,816 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	3c0080e7          	jalr	960(ra) # 80000118 <kalloc>
    80000d60:	862a                	mv	a2,a0
    if(pa == 0)
    80000d62:	c131                	beqz	a0,80000da6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d64:	416485b3          	sub	a1,s1,s6
    80000d68:	8591                	srai	a1,a1,0x4
    80000d6a:	000ab783          	ld	a5,0(s5)
    80000d6e:	02f585b3          	mul	a1,a1,a5
    80000d72:	2585                	addiw	a1,a1,1
    80000d74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d78:	4719                	li	a4,6
    80000d7a:	6685                	lui	a3,0x1
    80000d7c:	40b905b3          	sub	a1,s2,a1
    80000d80:	854e                	mv	a0,s3
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	8b0080e7          	jalr	-1872(ra) # 80000632 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	17048493          	addi	s1,s1,368
    80000d8e:	fd4495e3          	bne	s1,s4,80000d58 <proc_mapstacks+0x38>
  }
}
    80000d92:	70e2                	ld	ra,56(sp)
    80000d94:	7442                	ld	s0,48(sp)
    80000d96:	74a2                	ld	s1,40(sp)
    80000d98:	7902                	ld	s2,32(sp)
    80000d9a:	69e2                	ld	s3,24(sp)
    80000d9c:	6a42                	ld	s4,16(sp)
    80000d9e:	6aa2                	ld	s5,8(sp)
    80000da0:	6b02                	ld	s6,0(sp)
    80000da2:	6121                	addi	sp,sp,64
    80000da4:	8082                	ret
      panic("kalloc");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	3b250513          	addi	a0,a0,946 # 80008158 <etext+0x158>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	eea080e7          	jalr	-278(ra) # 80005c98 <panic>

0000000080000db6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db6:	7139                	addi	sp,sp,-64
    80000db8:	fc06                	sd	ra,56(sp)
    80000dba:	f822                	sd	s0,48(sp)
    80000dbc:	f426                	sd	s1,40(sp)
    80000dbe:	f04a                	sd	s2,32(sp)
    80000dc0:	ec4e                	sd	s3,24(sp)
    80000dc2:	e852                	sd	s4,16(sp)
    80000dc4:	e456                	sd	s5,8(sp)
    80000dc6:	e05a                	sd	s6,0(sp)
    80000dc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39658593          	addi	a1,a1,918 # 80008160 <etext+0x160>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	27e50513          	addi	a0,a0,638 # 80009050 <pid_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	378080e7          	jalr	888(ra) # 80006152 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	360080e7          	jalr	864(ra) # 80006152 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	00007a17          	auipc	s4,0x7
    80000e10:	1f4a0a13          	addi	s4,s4,500 # 80008000 <etext>
    80000e14:	04000937          	lui	s2,0x4000
    80000e18:	197d                	addi	s2,s2,-1
    80000e1a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1c:	0000e997          	auipc	s3,0xe
    80000e20:	26498993          	addi	s3,s3,612 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e24:	85da                	mv	a1,s6
    80000e26:	8526                	mv	a0,s1
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	32a080e7          	jalr	810(ra) # 80006152 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	415487b3          	sub	a5,s1,s5
    80000e34:	8791                	srai	a5,a5,0x4
    80000e36:	000a3703          	ld	a4,0(s4)
    80000e3a:	02e787b3          	mul	a5,a5,a4
    80000e3e:	2785                	addiw	a5,a5,1
    80000e40:	00d7979b          	slliw	a5,a5,0xd
    80000e44:	40f907b3          	sub	a5,s2,a5
    80000e48:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4a:	17048493          	addi	s1,s1,368
    80000e4e:	fd349be3          	bne	s1,s3,80000e24 <procinit+0x6e>
  }
}
    80000e52:	70e2                	ld	ra,56(sp)
    80000e54:	7442                	ld	s0,48(sp)
    80000e56:	74a2                	ld	s1,40(sp)
    80000e58:	7902                	ld	s2,32(sp)
    80000e5a:	69e2                	ld	s3,24(sp)
    80000e5c:	6a42                	ld	s4,16(sp)
    80000e5e:	6aa2                	ld	s5,8(sp)
    80000e60:	6b02                	ld	s6,0(sp)
    80000e62:	6121                	addi	sp,sp,64
    80000e64:	8082                	ret

0000000080000e66 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e422                	sd	s0,8(sp)
    80000e6a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e6c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6e:	2501                	sext.w	a0,a0
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
    80000e7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e82:	00008517          	auipc	a0,0x8
    80000e86:	1fe50513          	addi	a0,a0,510 # 80009080 <cpus>
    80000e8a:	953e                	add	a0,a0,a5
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	1000                	addi	s0,sp,32
  push_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	2fa080e7          	jalr	762(ra) # 80006196 <push_off>
    80000ea4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea6:	2781                	sext.w	a5,a5
    80000ea8:	079e                	slli	a5,a5,0x7
    80000eaa:	00008717          	auipc	a4,0x8
    80000eae:	1a670713          	addi	a4,a4,422 # 80009050 <pid_lock>
    80000eb2:	97ba                	add	a5,a5,a4
    80000eb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	380080e7          	jalr	896(ra) # 80006236 <pop_off>
  return p;
}
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	60e2                	ld	ra,24(sp)
    80000ec2:	6442                	ld	s0,16(sp)
    80000ec4:	64a2                	ld	s1,8(sp)
    80000ec6:	6105                	addi	sp,sp,32
    80000ec8:	8082                	ret

0000000080000eca <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eca:	1141                	addi	sp,sp,-16
    80000ecc:	e406                	sd	ra,8(sp)
    80000ece:	e022                	sd	s0,0(sp)
    80000ed0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	fc0080e7          	jalr	-64(ra) # 80000e92 <myproc>
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	3bc080e7          	jalr	956(ra) # 80006296 <release>

  if (first) {
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	9fe7a783          	lw	a5,-1538(a5) # 800088e0 <first.1677>
    80000eea:	eb89                	bnez	a5,80000efc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	c66080e7          	jalr	-922(ra) # 80001b52 <usertrapret>
}
    80000ef4:	60a2                	ld	ra,8(sp)
    80000ef6:	6402                	ld	s0,0(sp)
    80000ef8:	0141                	addi	sp,sp,16
    80000efa:	8082                	ret
    first = 0;
    80000efc:	00008797          	auipc	a5,0x8
    80000f00:	9e07a223          	sw	zero,-1564(a5) # 800088e0 <first.1677>
    fsinit(ROOTDEV);
    80000f04:	4505                	li	a0,1
    80000f06:	00002097          	auipc	ra,0x2
    80000f0a:	a64080e7          	jalr	-1436(ra) # 8000296a <fsinit>
    80000f0e:	bff9                	j	80000eec <forkret+0x22>

0000000080000f10 <allocpid>:
allocpid() {
    80000f10:	1101                	addi	sp,sp,-32
    80000f12:	ec06                	sd	ra,24(sp)
    80000f14:	e822                	sd	s0,16(sp)
    80000f16:	e426                	sd	s1,8(sp)
    80000f18:	e04a                	sd	s2,0(sp)
    80000f1a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f1c:	00008917          	auipc	s2,0x8
    80000f20:	13490913          	addi	s2,s2,308 # 80009050 <pid_lock>
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	2bc080e7          	jalr	700(ra) # 800061e2 <acquire>
  pid = nextpid;
    80000f2e:	00008797          	auipc	a5,0x8
    80000f32:	9b678793          	addi	a5,a5,-1610 # 800088e4 <nextpid>
    80000f36:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f38:	0014871b          	addiw	a4,s1,1
    80000f3c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3e:	854a                	mv	a0,s2
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	356080e7          	jalr	854(ra) # 80006296 <release>
}
    80000f48:	8526                	mv	a0,s1
    80000f4a:	60e2                	ld	ra,24(sp)
    80000f4c:	6442                	ld	s0,16(sp)
    80000f4e:	64a2                	ld	s1,8(sp)
    80000f50:	6902                	ld	s2,0(sp)
    80000f52:	6105                	addi	sp,sp,32
    80000f54:	8082                	ret

0000000080000f56 <proc_pagetable>:
{
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	e04a                	sd	s2,0(sp)
    80000f60:	1000                	addi	s0,sp,32
    80000f62:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	8b8080e7          	jalr	-1864(ra) # 8000081c <uvmcreate>
    80000f6c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f6e:	c121                	beqz	a0,80000fae <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f70:	4729                	li	a4,10
    80000f72:	00006697          	auipc	a3,0x6
    80000f76:	08e68693          	addi	a3,a3,142 # 80007000 <_trampoline>
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	60e080e7          	jalr	1550(ra) # 80000592 <mappages>
    80000f8c:	02054863          	bltz	a0,80000fbc <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f90:	4719                	li	a4,6
    80000f92:	06093683          	ld	a3,96(s2)
    80000f96:	6605                	lui	a2,0x1
    80000f98:	020005b7          	lui	a1,0x2000
    80000f9c:	15fd                	addi	a1,a1,-1
    80000f9e:	05b6                	slli	a1,a1,0xd
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	5f0080e7          	jalr	1520(ra) # 80000592 <mappages>
    80000faa:	02054163          	bltz	a0,80000fcc <proc_pagetable+0x76>
}
    80000fae:	8526                	mv	a0,s1
    80000fb0:	60e2                	ld	ra,24(sp)
    80000fb2:	6442                	ld	s0,16(sp)
    80000fb4:	64a2                	ld	s1,8(sp)
    80000fb6:	6902                	ld	s2,0(sp)
    80000fb8:	6105                	addi	sp,sp,32
    80000fba:	8082                	ret
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a58080e7          	jalr	-1448(ra) # 80000a18 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	b7d5                	j	80000fae <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b2                	slli	a1,a1,0xc
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	77e080e7          	jalr	1918(ra) # 80000758 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe2:	4581                	li	a1,0
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	a32080e7          	jalr	-1486(ra) # 80000a18 <uvmfree>
    return 0;
    80000fee:	4481                	li	s1,0
    80000ff0:	bf7d                	j	80000fae <proc_pagetable+0x58>

0000000080000ff2 <proc_freepagetable>:
{
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
    80001000:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001002:	4681                	li	a3,0
    80001004:	4605                	li	a2,1
    80001006:	040005b7          	lui	a1,0x4000
    8000100a:	15fd                	addi	a1,a1,-1
    8000100c:	05b2                	slli	a1,a1,0xc
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	74a080e7          	jalr	1866(ra) # 80000758 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001016:	4681                	li	a3,0
    80001018:	4605                	li	a2,1
    8000101a:	020005b7          	lui	a1,0x2000
    8000101e:	15fd                	addi	a1,a1,-1
    80001020:	05b6                	slli	a1,a1,0xd
    80001022:	8526                	mv	a0,s1
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	734080e7          	jalr	1844(ra) # 80000758 <uvmunmap>
  uvmfree(pagetable, sz);
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8526                	mv	a0,s1
    80001030:	00000097          	auipc	ra,0x0
    80001034:	9e8080e7          	jalr	-1560(ra) # 80000a18 <uvmfree>
}
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6902                	ld	s2,0(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <freeproc>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	1000                	addi	s0,sp,32
    8000104e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001050:	7128                	ld	a0,96(a0)
    80001052:	c509                	beqz	a0,8000105c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	fc8080e7          	jalr	-56(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000105c:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001060:	6ca8                	ld	a0,88(s1)
    80001062:	c511                	beqz	a0,8000106e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001064:	68ac                	ld	a1,80(s1)
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	f8c080e7          	jalr	-116(ra) # 80000ff2 <proc_freepagetable>
  p->pagetable = 0;
    8000106e:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001072:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001076:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000107a:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    8000107e:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001082:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001086:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000108a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108e:	0004ac23          	sw	zero,24(s1)
}
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret

000000008000109c <allocproc>:
{
    8000109c:	1101                	addi	sp,sp,-32
    8000109e:	ec06                	sd	ra,24(sp)
    800010a0:	e822                	sd	s0,16(sp)
    800010a2:	e426                	sd	s1,8(sp)
    800010a4:	e04a                	sd	s2,0(sp)
    800010a6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a8:	00008497          	auipc	s1,0x8
    800010ac:	3d848493          	addi	s1,s1,984 # 80009480 <proc>
    800010b0:	0000e917          	auipc	s2,0xe
    800010b4:	fd090913          	addi	s2,s2,-48 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	128080e7          	jalr	296(ra) # 800061e2 <acquire>
    if(p->state == UNUSED) {
    800010c2:	4c9c                	lw	a5,24(s1)
    800010c4:	cf81                	beqz	a5,800010dc <allocproc+0x40>
      release(&p->lock);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00005097          	auipc	ra,0x5
    800010cc:	1ce080e7          	jalr	462(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d0:	17048493          	addi	s1,s1,368
    800010d4:	ff2492e3          	bne	s1,s2,800010b8 <allocproc+0x1c>
  return 0;
    800010d8:	4481                	li	s1,0
    800010da:	a889                	j	8000112c <allocproc+0x90>
  p->pid = allocpid();
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	e34080e7          	jalr	-460(ra) # 80000f10 <allocpid>
    800010e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e6:	4785                	li	a5,1
    800010e8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	02e080e7          	jalr	46(ra) # 80000118 <kalloc>
    800010f2:	892a                	mv	s2,a0
    800010f4:	f0a8                	sd	a0,96(s1)
    800010f6:	c131                	beqz	a0,8000113a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	e5c080e7          	jalr	-420(ra) # 80000f56 <proc_pagetable>
    80001102:	892a                	mv	s2,a0
    80001104:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001106:	c531                	beqz	a0,80001152 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001108:	07000613          	li	a2,112
    8000110c:	4581                	li	a1,0
    8000110e:	06848513          	addi	a0,s1,104
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	0b0080e7          	jalr	176(ra) # 800001c2 <memset>
  p->context.ra = (uint64)forkret;
    8000111a:	00000797          	auipc	a5,0x0
    8000111e:	db078793          	addi	a5,a5,-592 # 80000eca <forkret>
    80001122:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001124:	64bc                	ld	a5,72(s1)
    80001126:	6705                	lui	a4,0x1
    80001128:	97ba                	add	a5,a5,a4
    8000112a:	f8bc                	sd	a5,112(s1)
}
    8000112c:	8526                	mv	a0,s1
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6902                	ld	s2,0(sp)
    80001136:	6105                	addi	sp,sp,32
    80001138:	8082                	ret
    freeproc(p);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	f08080e7          	jalr	-248(ra) # 80001044 <freeproc>
    release(&p->lock);
    80001144:	8526                	mv	a0,s1
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	150080e7          	jalr	336(ra) # 80006296 <release>
    return 0;
    8000114e:	84ca                	mv	s1,s2
    80001150:	bff1                	j	8000112c <allocproc+0x90>
    freeproc(p);
    80001152:	8526                	mv	a0,s1
    80001154:	00000097          	auipc	ra,0x0
    80001158:	ef0080e7          	jalr	-272(ra) # 80001044 <freeproc>
    release(&p->lock);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00005097          	auipc	ra,0x5
    80001162:	138080e7          	jalr	312(ra) # 80006296 <release>
    return 0;
    80001166:	84ca                	mv	s1,s2
    80001168:	b7d1                	j	8000112c <allocproc+0x90>

000000008000116a <userinit>:
{
    8000116a:	1101                	addi	sp,sp,-32
    8000116c:	ec06                	sd	ra,24(sp)
    8000116e:	e822                	sd	s0,16(sp)
    80001170:	e426                	sd	s1,8(sp)
    80001172:	1000                	addi	s0,sp,32
  p = allocproc();
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f28080e7          	jalr	-216(ra) # 8000109c <allocproc>
    8000117c:	84aa                	mv	s1,a0
  initproc = p;
    8000117e:	00008797          	auipc	a5,0x8
    80001182:	e8a7b923          	sd	a0,-366(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001186:	03400613          	li	a2,52
    8000118a:	00007597          	auipc	a1,0x7
    8000118e:	76658593          	addi	a1,a1,1894 # 800088f0 <initcode>
    80001192:	6d28                	ld	a0,88(a0)
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	6b6080e7          	jalr	1718(ra) # 8000084a <uvminit>
  p->sz = PGSIZE;
    8000119c:	6785                	lui	a5,0x1
    8000119e:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a0:	70b8                	ld	a4,96(s1)
    800011a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a6:	70b8                	ld	a4,96(s1)
    800011a8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011aa:	4641                	li	a2,16
    800011ac:	00007597          	auipc	a1,0x7
    800011b0:	fd458593          	addi	a1,a1,-44 # 80008180 <etext+0x180>
    800011b4:	16048513          	addi	a0,s1,352
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	15c080e7          	jalr	348(ra) # 80000314 <safestrcpy>
  p->cwd = namei("/");
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	fd050513          	addi	a0,a0,-48 # 80008190 <etext+0x190>
    800011c8:	00002097          	auipc	ra,0x2
    800011cc:	1d0080e7          	jalr	464(ra) # 80003398 <namei>
    800011d0:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800011d4:	478d                	li	a5,3
    800011d6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d8:	8526                	mv	a0,s1
    800011da:	00005097          	auipc	ra,0x5
    800011de:	0bc080e7          	jalr	188(ra) # 80006296 <release>
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <growproc>:
{
    800011ec:	1101                	addi	sp,sp,-32
    800011ee:	ec06                	sd	ra,24(sp)
    800011f0:	e822                	sd	s0,16(sp)
    800011f2:	e426                	sd	s1,8(sp)
    800011f4:	e04a                	sd	s2,0(sp)
    800011f6:	1000                	addi	s0,sp,32
    800011f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	c98080e7          	jalr	-872(ra) # 80000e92 <myproc>
    80001202:	892a                	mv	s2,a0
  sz = p->sz;
    80001204:	692c                	ld	a1,80(a0)
    80001206:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000120a:	00904f63          	bgtz	s1,80001228 <growproc+0x3c>
  } else if(n < 0){
    8000120e:	0204cc63          	bltz	s1,80001246 <growproc+0x5a>
  p->sz = sz;
    80001212:	1602                	slli	a2,a2,0x20
    80001214:	9201                	srli	a2,a2,0x20
    80001216:	04c93823          	sd	a2,80(s2)
  return 0;
    8000121a:	4501                	li	a0,0
}
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6902                	ld	s2,0(sp)
    80001224:	6105                	addi	sp,sp,32
    80001226:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001228:	9e25                	addw	a2,a2,s1
    8000122a:	1602                	slli	a2,a2,0x20
    8000122c:	9201                	srli	a2,a2,0x20
    8000122e:	1582                	slli	a1,a1,0x20
    80001230:	9181                	srli	a1,a1,0x20
    80001232:	6d28                	ld	a0,88(a0)
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	6d0080e7          	jalr	1744(ra) # 80000904 <uvmalloc>
    8000123c:	0005061b          	sext.w	a2,a0
    80001240:	fa69                	bnez	a2,80001212 <growproc+0x26>
      return -1;
    80001242:	557d                	li	a0,-1
    80001244:	bfe1                	j	8000121c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001246:	9e25                	addw	a2,a2,s1
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6d28                	ld	a0,88(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	66a080e7          	jalr	1642(ra) # 800008bc <uvmdealloc>
    8000125a:	0005061b          	sext.w	a2,a0
    8000125e:	bf55                	j	80001212 <growproc+0x26>

0000000080001260 <fork>:
{
    80001260:	7179                	addi	sp,sp,-48
    80001262:	f406                	sd	ra,40(sp)
    80001264:	f022                	sd	s0,32(sp)
    80001266:	ec26                	sd	s1,24(sp)
    80001268:	e84a                	sd	s2,16(sp)
    8000126a:	e44e                	sd	s3,8(sp)
    8000126c:	e052                	sd	s4,0(sp)
    8000126e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001270:	00000097          	auipc	ra,0x0
    80001274:	c22080e7          	jalr	-990(ra) # 80000e92 <myproc>
    80001278:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e22080e7          	jalr	-478(ra) # 8000109c <allocproc>
    80001282:	10050f63          	beqz	a0,800013a0 <fork+0x140>
    80001286:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001288:	05093603          	ld	a2,80(s2)
    8000128c:	6d2c                	ld	a1,88(a0)
    8000128e:	05893503          	ld	a0,88(s2)
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	7be080e7          	jalr	1982(ra) # 80000a50 <uvmcopy>
    8000129a:	04054663          	bltz	a0,800012e6 <fork+0x86>
  np->sz = p->sz;
    8000129e:	05093783          	ld	a5,80(s2)
    800012a2:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a6:	06093683          	ld	a3,96(s2)
    800012aa:	87b6                	mv	a5,a3
    800012ac:	0609b703          	ld	a4,96(s3)
    800012b0:	12068693          	addi	a3,a3,288
    800012b4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b8:	6788                	ld	a0,8(a5)
    800012ba:	6b8c                	ld	a1,16(a5)
    800012bc:	6f90                	ld	a2,24(a5)
    800012be:	01073023          	sd	a6,0(a4)
    800012c2:	e708                	sd	a0,8(a4)
    800012c4:	eb0c                	sd	a1,16(a4)
    800012c6:	ef10                	sd	a2,24(a4)
    800012c8:	02078793          	addi	a5,a5,32
    800012cc:	02070713          	addi	a4,a4,32
    800012d0:	fed792e3          	bne	a5,a3,800012b4 <fork+0x54>
  np->trapframe->a0 = 0;
    800012d4:	0609b783          	ld	a5,96(s3)
    800012d8:	0607b823          	sd	zero,112(a5)
    800012dc:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    800012e0:	15800a13          	li	s4,344
    800012e4:	a03d                	j	80001312 <fork+0xb2>
    freeproc(np);
    800012e6:	854e                	mv	a0,s3
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	d5c080e7          	jalr	-676(ra) # 80001044 <freeproc>
    release(&np->lock);
    800012f0:	854e                	mv	a0,s3
    800012f2:	00005097          	auipc	ra,0x5
    800012f6:	fa4080e7          	jalr	-92(ra) # 80006296 <release>
    return -1;
    800012fa:	5a7d                	li	s4,-1
    800012fc:	a849                	j	8000138e <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    800012fe:	00002097          	auipc	ra,0x2
    80001302:	730080e7          	jalr	1840(ra) # 80003a2e <filedup>
    80001306:	009987b3          	add	a5,s3,s1
    8000130a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000130c:	04a1                	addi	s1,s1,8
    8000130e:	01448763          	beq	s1,s4,8000131c <fork+0xbc>
    if(p->ofile[i])
    80001312:	009907b3          	add	a5,s2,s1
    80001316:	6388                	ld	a0,0(a5)
    80001318:	f17d                	bnez	a0,800012fe <fork+0x9e>
    8000131a:	bfcd                	j	8000130c <fork+0xac>
  np->cwd = idup(p->cwd);
    8000131c:	15893503          	ld	a0,344(s2)
    80001320:	00002097          	auipc	ra,0x2
    80001324:	884080e7          	jalr	-1916(ra) # 80002ba4 <idup>
    80001328:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000132c:	4641                	li	a2,16
    8000132e:	16090593          	addi	a1,s2,352
    80001332:	16098513          	addi	a0,s3,352
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	fde080e7          	jalr	-34(ra) # 80000314 <safestrcpy>
  pid = np->pid;
    8000133e:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001342:	854e                	mv	a0,s3
    80001344:	00005097          	auipc	ra,0x5
    80001348:	f52080e7          	jalr	-174(ra) # 80006296 <release>
  acquire(&wait_lock);
    8000134c:	00008497          	auipc	s1,0x8
    80001350:	d1c48493          	addi	s1,s1,-740 # 80009068 <wait_lock>
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	e8c080e7          	jalr	-372(ra) # 800061e2 <acquire>
  np->parent = p;
    8000135e:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    80001362:	8526                	mv	a0,s1
    80001364:	00005097          	auipc	ra,0x5
    80001368:	f32080e7          	jalr	-206(ra) # 80006296 <release>
  acquire(&np->lock);
    8000136c:	854e                	mv	a0,s3
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	e74080e7          	jalr	-396(ra) # 800061e2 <acquire>
  np->state = RUNNABLE;
    80001376:	478d                	li	a5,3
    80001378:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000137c:	854e                	mv	a0,s3
    8000137e:	00005097          	auipc	ra,0x5
    80001382:	f18080e7          	jalr	-232(ra) # 80006296 <release>
  np->mask = p->mask; //child's mask=parent's maskS
    80001386:	03893783          	ld	a5,56(s2)
    8000138a:	02f9bc23          	sd	a5,56(s3)
}
    8000138e:	8552                	mv	a0,s4
    80001390:	70a2                	ld	ra,40(sp)
    80001392:	7402                	ld	s0,32(sp)
    80001394:	64e2                	ld	s1,24(sp)
    80001396:	6942                	ld	s2,16(sp)
    80001398:	69a2                	ld	s3,8(sp)
    8000139a:	6a02                	ld	s4,0(sp)
    8000139c:	6145                	addi	sp,sp,48
    8000139e:	8082                	ret
    return -1;
    800013a0:	5a7d                	li	s4,-1
    800013a2:	b7f5                	j	8000138e <fork+0x12e>

00000000800013a4 <scheduler>:
{
    800013a4:	7139                	addi	sp,sp,-64
    800013a6:	fc06                	sd	ra,56(sp)
    800013a8:	f822                	sd	s0,48(sp)
    800013aa:	f426                	sd	s1,40(sp)
    800013ac:	f04a                	sd	s2,32(sp)
    800013ae:	ec4e                	sd	s3,24(sp)
    800013b0:	e852                	sd	s4,16(sp)
    800013b2:	e456                	sd	s5,8(sp)
    800013b4:	e05a                	sd	s6,0(sp)
    800013b6:	0080                	addi	s0,sp,64
    800013b8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ba:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013bc:	00779a93          	slli	s5,a5,0x7
    800013c0:	00008717          	auipc	a4,0x8
    800013c4:	c9070713          	addi	a4,a4,-880 # 80009050 <pid_lock>
    800013c8:	9756                	add	a4,a4,s5
    800013ca:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ce:	00008717          	auipc	a4,0x8
    800013d2:	cba70713          	addi	a4,a4,-838 # 80009088 <cpus+0x8>
    800013d6:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d8:	498d                	li	s3,3
        p->state = RUNNING;
    800013da:	4b11                	li	s6,4
        c->proc = p;
    800013dc:	079e                	slli	a5,a5,0x7
    800013de:	00008a17          	auipc	s4,0x8
    800013e2:	c72a0a13          	addi	s4,s4,-910 # 80009050 <pid_lock>
    800013e6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	0000e917          	auipc	s2,0xe
    800013ec:	c9890913          	addi	s2,s2,-872 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f8:	10079073          	csrw	sstatus,a5
    800013fc:	00008497          	auipc	s1,0x8
    80001400:	08448493          	addi	s1,s1,132 # 80009480 <proc>
    80001404:	a03d                	j	80001432 <scheduler+0x8e>
        p->state = RUNNING;
    80001406:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000140a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000140e:	06848593          	addi	a1,s1,104
    80001412:	8556                	mv	a0,s5
    80001414:	00000097          	auipc	ra,0x0
    80001418:	694080e7          	jalr	1684(ra) # 80001aa8 <swtch>
        c->proc = 0;
    8000141c:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001420:	8526                	mv	a0,s1
    80001422:	00005097          	auipc	ra,0x5
    80001426:	e74080e7          	jalr	-396(ra) # 80006296 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142a:	17048493          	addi	s1,s1,368
    8000142e:	fd2481e3          	beq	s1,s2,800013f0 <scheduler+0x4c>
      acquire(&p->lock);
    80001432:	8526                	mv	a0,s1
    80001434:	00005097          	auipc	ra,0x5
    80001438:	dae080e7          	jalr	-594(ra) # 800061e2 <acquire>
      if(p->state == RUNNABLE) {
    8000143c:	4c9c                	lw	a5,24(s1)
    8000143e:	ff3791e3          	bne	a5,s3,80001420 <scheduler+0x7c>
    80001442:	b7d1                	j	80001406 <scheduler+0x62>

0000000080001444 <sched>:
{
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001452:	00000097          	auipc	ra,0x0
    80001456:	a40080e7          	jalr	-1472(ra) # 80000e92 <myproc>
    8000145a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	d0c080e7          	jalr	-756(ra) # 80006168 <holding>
    80001464:	c93d                	beqz	a0,800014da <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001466:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	00008717          	auipc	a4,0x8
    80001470:	be470713          	addi	a4,a4,-1052 # 80009050 <pid_lock>
    80001474:	97ba                	add	a5,a5,a4
    80001476:	0a87a703          	lw	a4,168(a5)
    8000147a:	4785                	li	a5,1
    8000147c:	06f71763          	bne	a4,a5,800014ea <sched+0xa6>
  if(p->state == RUNNING)
    80001480:	4c98                	lw	a4,24(s1)
    80001482:	4791                	li	a5,4
    80001484:	06f70b63          	beq	a4,a5,800014fa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001488:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148e:	efb5                	bnez	a5,8000150a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001490:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001492:	00008917          	auipc	s2,0x8
    80001496:	bbe90913          	addi	s2,s2,-1090 # 80009050 <pid_lock>
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	97ca                	add	a5,a5,s2
    800014a0:	0ac7a983          	lw	s3,172(a5)
    800014a4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	00008597          	auipc	a1,0x8
    800014ae:	bde58593          	addi	a1,a1,-1058 # 80009088 <cpus+0x8>
    800014b2:	95be                	add	a1,a1,a5
    800014b4:	06848513          	addi	a0,s1,104
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	5f0080e7          	jalr	1520(ra) # 80001aa8 <swtch>
    800014c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c2:	2781                	sext.w	a5,a5
    800014c4:	079e                	slli	a5,a5,0x7
    800014c6:	97ca                	add	a5,a5,s2
    800014c8:	0b37a623          	sw	s3,172(a5)
}
    800014cc:	70a2                	ld	ra,40(sp)
    800014ce:	7402                	ld	s0,32(sp)
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	6145                	addi	sp,sp,48
    800014d8:	8082                	ret
    panic("sched p->lock");
    800014da:	00007517          	auipc	a0,0x7
    800014de:	cbe50513          	addi	a0,a0,-834 # 80008198 <etext+0x198>
    800014e2:	00004097          	auipc	ra,0x4
    800014e6:	7b6080e7          	jalr	1974(ra) # 80005c98 <panic>
    panic("sched locks");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	cbe50513          	addi	a0,a0,-834 # 800081a8 <etext+0x1a8>
    800014f2:	00004097          	auipc	ra,0x4
    800014f6:	7a6080e7          	jalr	1958(ra) # 80005c98 <panic>
    panic("sched running");
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	cbe50513          	addi	a0,a0,-834 # 800081b8 <etext+0x1b8>
    80001502:	00004097          	auipc	ra,0x4
    80001506:	796080e7          	jalr	1942(ra) # 80005c98 <panic>
    panic("sched interruptible");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	cbe50513          	addi	a0,a0,-834 # 800081c8 <etext+0x1c8>
    80001512:	00004097          	auipc	ra,0x4
    80001516:	786080e7          	jalr	1926(ra) # 80005c98 <panic>

000000008000151a <yield>:
{
    8000151a:	1101                	addi	sp,sp,-32
    8000151c:	ec06                	sd	ra,24(sp)
    8000151e:	e822                	sd	s0,16(sp)
    80001520:	e426                	sd	s1,8(sp)
    80001522:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	96e080e7          	jalr	-1682(ra) # 80000e92 <myproc>
    8000152c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	cb4080e7          	jalr	-844(ra) # 800061e2 <acquire>
  p->state = RUNNABLE;
    80001536:	478d                	li	a5,3
    80001538:	cc9c                	sw	a5,24(s1)
  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f0a080e7          	jalr	-246(ra) # 80001444 <sched>
  release(&p->lock);
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	d52080e7          	jalr	-686(ra) # 80006296 <release>
}
    8000154c:	60e2                	ld	ra,24(sp)
    8000154e:	6442                	ld	s0,16(sp)
    80001550:	64a2                	ld	s1,8(sp)
    80001552:	6105                	addi	sp,sp,32
    80001554:	8082                	ret

0000000080001556 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001556:	7179                	addi	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	1800                	addi	s0,sp,48
    80001564:	89aa                	mv	s3,a0
    80001566:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	92a080e7          	jalr	-1750(ra) # 80000e92 <myproc>
    80001570:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	c70080e7          	jalr	-912(ra) # 800061e2 <acquire>
  release(lk);
    8000157a:	854a                	mv	a0,s2
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	d1a080e7          	jalr	-742(ra) # 80006296 <release>

  // Go to sleep.
  p->chan = chan;
    80001584:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001588:	4789                	li	a5,2
    8000158a:	cc9c                	sw	a5,24(s1)

  sched();
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	eb8080e7          	jalr	-328(ra) # 80001444 <sched>

  // Tidy up.
  p->chan = 0;
    80001594:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	cfc080e7          	jalr	-772(ra) # 80006296 <release>
  acquire(lk);
    800015a2:	854a                	mv	a0,s2
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c3e080e7          	jalr	-962(ra) # 800061e2 <acquire>
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret

00000000800015ba <wait>:
{
    800015ba:	715d                	addi	sp,sp,-80
    800015bc:	e486                	sd	ra,72(sp)
    800015be:	e0a2                	sd	s0,64(sp)
    800015c0:	fc26                	sd	s1,56(sp)
    800015c2:	f84a                	sd	s2,48(sp)
    800015c4:	f44e                	sd	s3,40(sp)
    800015c6:	f052                	sd	s4,32(sp)
    800015c8:	ec56                	sd	s5,24(sp)
    800015ca:	e85a                	sd	s6,16(sp)
    800015cc:	e45e                	sd	s7,8(sp)
    800015ce:	e062                	sd	s8,0(sp)
    800015d0:	0880                	addi	s0,sp,80
    800015d2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	8be080e7          	jalr	-1858(ra) # 80000e92 <myproc>
    800015dc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015de:	00008517          	auipc	a0,0x8
    800015e2:	a8a50513          	addi	a0,a0,-1398 # 80009068 <wait_lock>
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	bfc080e7          	jalr	-1028(ra) # 800061e2 <acquire>
    havekids = 0;
    800015ee:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f0:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015f2:	0000e997          	auipc	s3,0xe
    800015f6:	a8e98993          	addi	s3,s3,-1394 # 8000f080 <tickslock>
        havekids = 1;
    800015fa:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fc:	00008c17          	auipc	s8,0x8
    80001600:	a6cc0c13          	addi	s8,s8,-1428 # 80009068 <wait_lock>
    havekids = 0;
    80001604:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001606:	00008497          	auipc	s1,0x8
    8000160a:	e7a48493          	addi	s1,s1,-390 # 80009480 <proc>
    8000160e:	a0bd                	j	8000167c <wait+0xc2>
          pid = np->pid;
    80001610:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001614:	000b0e63          	beqz	s6,80001630 <wait+0x76>
    80001618:	4691                	li	a3,4
    8000161a:	02c48613          	addi	a2,s1,44
    8000161e:	85da                	mv	a1,s6
    80001620:	05893503          	ld	a0,88(s2)
    80001624:	fffff097          	auipc	ra,0xfffff
    80001628:	530080e7          	jalr	1328(ra) # 80000b54 <copyout>
    8000162c:	02054563          	bltz	a0,80001656 <wait+0x9c>
          freeproc(np);
    80001630:	8526                	mv	a0,s1
    80001632:	00000097          	auipc	ra,0x0
    80001636:	a12080e7          	jalr	-1518(ra) # 80001044 <freeproc>
          release(&np->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	c5a080e7          	jalr	-934(ra) # 80006296 <release>
          release(&wait_lock);
    80001644:	00008517          	auipc	a0,0x8
    80001648:	a2450513          	addi	a0,a0,-1500 # 80009068 <wait_lock>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	c4a080e7          	jalr	-950(ra) # 80006296 <release>
          return pid;
    80001654:	a09d                	j	800016ba <wait+0x100>
            release(&np->lock);
    80001656:	8526                	mv	a0,s1
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	c3e080e7          	jalr	-962(ra) # 80006296 <release>
            release(&wait_lock);
    80001660:	00008517          	auipc	a0,0x8
    80001664:	a0850513          	addi	a0,a0,-1528 # 80009068 <wait_lock>
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	c2e080e7          	jalr	-978(ra) # 80006296 <release>
            return -1;
    80001670:	59fd                	li	s3,-1
    80001672:	a0a1                	j	800016ba <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001674:	17048493          	addi	s1,s1,368
    80001678:	03348463          	beq	s1,s3,800016a0 <wait+0xe6>
      if(np->parent == p){
    8000167c:	60bc                	ld	a5,64(s1)
    8000167e:	ff279be3          	bne	a5,s2,80001674 <wait+0xba>
        acquire(&np->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	00005097          	auipc	ra,0x5
    80001688:	b5e080e7          	jalr	-1186(ra) # 800061e2 <acquire>
        if(np->state == ZOMBIE){
    8000168c:	4c9c                	lw	a5,24(s1)
    8000168e:	f94781e3          	beq	a5,s4,80001610 <wait+0x56>
        release(&np->lock);
    80001692:	8526                	mv	a0,s1
    80001694:	00005097          	auipc	ra,0x5
    80001698:	c02080e7          	jalr	-1022(ra) # 80006296 <release>
        havekids = 1;
    8000169c:	8756                	mv	a4,s5
    8000169e:	bfd9                	j	80001674 <wait+0xba>
    if(!havekids || p->killed){
    800016a0:	c701                	beqz	a4,800016a8 <wait+0xee>
    800016a2:	02892783          	lw	a5,40(s2)
    800016a6:	c79d                	beqz	a5,800016d4 <wait+0x11a>
      release(&wait_lock);
    800016a8:	00008517          	auipc	a0,0x8
    800016ac:	9c050513          	addi	a0,a0,-1600 # 80009068 <wait_lock>
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	be6080e7          	jalr	-1050(ra) # 80006296 <release>
      return -1;
    800016b8:	59fd                	li	s3,-1
}
    800016ba:	854e                	mv	a0,s3
    800016bc:	60a6                	ld	ra,72(sp)
    800016be:	6406                	ld	s0,64(sp)
    800016c0:	74e2                	ld	s1,56(sp)
    800016c2:	7942                	ld	s2,48(sp)
    800016c4:	79a2                	ld	s3,40(sp)
    800016c6:	7a02                	ld	s4,32(sp)
    800016c8:	6ae2                	ld	s5,24(sp)
    800016ca:	6b42                	ld	s6,16(sp)
    800016cc:	6ba2                	ld	s7,8(sp)
    800016ce:	6c02                	ld	s8,0(sp)
    800016d0:	6161                	addi	sp,sp,80
    800016d2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d4:	85e2                	mv	a1,s8
    800016d6:	854a                	mv	a0,s2
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	e7e080e7          	jalr	-386(ra) # 80001556 <sleep>
    havekids = 0;
    800016e0:	b715                	j	80001604 <wait+0x4a>

00000000800016e2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e2:	7139                	addi	sp,sp,-64
    800016e4:	fc06                	sd	ra,56(sp)
    800016e6:	f822                	sd	s0,48(sp)
    800016e8:	f426                	sd	s1,40(sp)
    800016ea:	f04a                	sd	s2,32(sp)
    800016ec:	ec4e                	sd	s3,24(sp)
    800016ee:	e852                	sd	s4,16(sp)
    800016f0:	e456                	sd	s5,8(sp)
    800016f2:	0080                	addi	s0,sp,64
    800016f4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f6:	00008497          	auipc	s1,0x8
    800016fa:	d8a48493          	addi	s1,s1,-630 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016fe:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001700:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	0000e917          	auipc	s2,0xe
    80001706:	97e90913          	addi	s2,s2,-1666 # 8000f080 <tickslock>
    8000170a:	a821                	j	80001722 <wakeup+0x40>
        p->state = RUNNABLE;
    8000170c:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b84080e7          	jalr	-1148(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	17048493          	addi	s1,s1,368
    8000171e:	03248463          	beq	s1,s2,80001746 <wakeup+0x64>
    if(p != myproc()){
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	770080e7          	jalr	1904(ra) # 80000e92 <myproc>
    8000172a:	fea488e3          	beq	s1,a0,8000171a <wakeup+0x38>
      acquire(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	ab2080e7          	jalr	-1358(ra) # 800061e2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001738:	4c9c                	lw	a5,24(s1)
    8000173a:	fd379be3          	bne	a5,s3,80001710 <wakeup+0x2e>
    8000173e:	709c                	ld	a5,32(s1)
    80001740:	fd4798e3          	bne	a5,s4,80001710 <wakeup+0x2e>
    80001744:	b7e1                	j	8000170c <wakeup+0x2a>
    }
  }
}
    80001746:	70e2                	ld	ra,56(sp)
    80001748:	7442                	ld	s0,48(sp)
    8000174a:	74a2                	ld	s1,40(sp)
    8000174c:	7902                	ld	s2,32(sp)
    8000174e:	69e2                	ld	s3,24(sp)
    80001750:	6a42                	ld	s4,16(sp)
    80001752:	6aa2                	ld	s5,8(sp)
    80001754:	6121                	addi	sp,sp,64
    80001756:	8082                	ret

0000000080001758 <reparent>:
{
    80001758:	7179                	addi	sp,sp,-48
    8000175a:	f406                	sd	ra,40(sp)
    8000175c:	f022                	sd	s0,32(sp)
    8000175e:	ec26                	sd	s1,24(sp)
    80001760:	e84a                	sd	s2,16(sp)
    80001762:	e44e                	sd	s3,8(sp)
    80001764:	e052                	sd	s4,0(sp)
    80001766:	1800                	addi	s0,sp,48
    80001768:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176a:	00008497          	auipc	s1,0x8
    8000176e:	d1648493          	addi	s1,s1,-746 # 80009480 <proc>
      pp->parent = initproc;
    80001772:	00008a17          	auipc	s4,0x8
    80001776:	89ea0a13          	addi	s4,s4,-1890 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177a:	0000e997          	auipc	s3,0xe
    8000177e:	90698993          	addi	s3,s3,-1786 # 8000f080 <tickslock>
    80001782:	a029                	j	8000178c <reparent+0x34>
    80001784:	17048493          	addi	s1,s1,368
    80001788:	01348d63          	beq	s1,s3,800017a2 <reparent+0x4a>
    if(pp->parent == p){
    8000178c:	60bc                	ld	a5,64(s1)
    8000178e:	ff279be3          	bne	a5,s2,80001784 <reparent+0x2c>
      pp->parent = initproc;
    80001792:	000a3503          	ld	a0,0(s4)
    80001796:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	f4a080e7          	jalr	-182(ra) # 800016e2 <wakeup>
    800017a0:	b7d5                	j	80001784 <reparent+0x2c>
}
    800017a2:	70a2                	ld	ra,40(sp)
    800017a4:	7402                	ld	s0,32(sp)
    800017a6:	64e2                	ld	s1,24(sp)
    800017a8:	6942                	ld	s2,16(sp)
    800017aa:	69a2                	ld	s3,8(sp)
    800017ac:	6a02                	ld	s4,0(sp)
    800017ae:	6145                	addi	sp,sp,48
    800017b0:	8082                	ret

00000000800017b2 <exit>:
{
    800017b2:	7179                	addi	sp,sp,-48
    800017b4:	f406                	sd	ra,40(sp)
    800017b6:	f022                	sd	s0,32(sp)
    800017b8:	ec26                	sd	s1,24(sp)
    800017ba:	e84a                	sd	s2,16(sp)
    800017bc:	e44e                	sd	s3,8(sp)
    800017be:	e052                	sd	s4,0(sp)
    800017c0:	1800                	addi	s0,sp,48
    800017c2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c4:	fffff097          	auipc	ra,0xfffff
    800017c8:	6ce080e7          	jalr	1742(ra) # 80000e92 <myproc>
    800017cc:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ce:	00008797          	auipc	a5,0x8
    800017d2:	8427b783          	ld	a5,-1982(a5) # 80009010 <initproc>
    800017d6:	0d850493          	addi	s1,a0,216
    800017da:	15850913          	addi	s2,a0,344
    800017de:	02a79363          	bne	a5,a0,80001804 <exit+0x52>
    panic("init exiting");
    800017e2:	00007517          	auipc	a0,0x7
    800017e6:	9fe50513          	addi	a0,a0,-1538 # 800081e0 <etext+0x1e0>
    800017ea:	00004097          	auipc	ra,0x4
    800017ee:	4ae080e7          	jalr	1198(ra) # 80005c98 <panic>
      fileclose(f);
    800017f2:	00002097          	auipc	ra,0x2
    800017f6:	28e080e7          	jalr	654(ra) # 80003a80 <fileclose>
      p->ofile[fd] = 0;
    800017fa:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017fe:	04a1                	addi	s1,s1,8
    80001800:	01248563          	beq	s1,s2,8000180a <exit+0x58>
    if(p->ofile[fd]){
    80001804:	6088                	ld	a0,0(s1)
    80001806:	f575                	bnez	a0,800017f2 <exit+0x40>
    80001808:	bfdd                	j	800017fe <exit+0x4c>
  begin_op();
    8000180a:	00002097          	auipc	ra,0x2
    8000180e:	daa080e7          	jalr	-598(ra) # 800035b4 <begin_op>
  iput(p->cwd);
    80001812:	1589b503          	ld	a0,344(s3)
    80001816:	00001097          	auipc	ra,0x1
    8000181a:	586080e7          	jalr	1414(ra) # 80002d9c <iput>
  end_op();
    8000181e:	00002097          	auipc	ra,0x2
    80001822:	e16080e7          	jalr	-490(ra) # 80003634 <end_op>
  p->cwd = 0;
    80001826:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000182a:	00008497          	auipc	s1,0x8
    8000182e:	83e48493          	addi	s1,s1,-1986 # 80009068 <wait_lock>
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	9ae080e7          	jalr	-1618(ra) # 800061e2 <acquire>
  reparent(p);
    8000183c:	854e                	mv	a0,s3
    8000183e:	00000097          	auipc	ra,0x0
    80001842:	f1a080e7          	jalr	-230(ra) # 80001758 <reparent>
  wakeup(p->parent);
    80001846:	0409b503          	ld	a0,64(s3)
    8000184a:	00000097          	auipc	ra,0x0
    8000184e:	e98080e7          	jalr	-360(ra) # 800016e2 <wakeup>
  acquire(&p->lock);
    80001852:	854e                	mv	a0,s3
    80001854:	00005097          	auipc	ra,0x5
    80001858:	98e080e7          	jalr	-1650(ra) # 800061e2 <acquire>
  p->xstate = status;
    8000185c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001860:	4795                	li	a5,5
    80001862:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	a2e080e7          	jalr	-1490(ra) # 80006296 <release>
  sched();
    80001870:	00000097          	auipc	ra,0x0
    80001874:	bd4080e7          	jalr	-1068(ra) # 80001444 <sched>
  panic("zombie exit");
    80001878:	00007517          	auipc	a0,0x7
    8000187c:	97850513          	addi	a0,a0,-1672 # 800081f0 <etext+0x1f0>
    80001880:	00004097          	auipc	ra,0x4
    80001884:	418080e7          	jalr	1048(ra) # 80005c98 <panic>

0000000080001888 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001888:	7179                	addi	sp,sp,-48
    8000188a:	f406                	sd	ra,40(sp)
    8000188c:	f022                	sd	s0,32(sp)
    8000188e:	ec26                	sd	s1,24(sp)
    80001890:	e84a                	sd	s2,16(sp)
    80001892:	e44e                	sd	s3,8(sp)
    80001894:	1800                	addi	s0,sp,48
    80001896:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001898:	00008497          	auipc	s1,0x8
    8000189c:	be848493          	addi	s1,s1,-1048 # 80009480 <proc>
    800018a0:	0000d997          	auipc	s3,0xd
    800018a4:	7e098993          	addi	s3,s3,2016 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	938080e7          	jalr	-1736(ra) # 800061e2 <acquire>
    if(p->pid == pid){
    800018b2:	589c                	lw	a5,48(s1)
    800018b4:	01278d63          	beq	a5,s2,800018ce <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	9dc080e7          	jalr	-1572(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c2:	17048493          	addi	s1,s1,368
    800018c6:	ff3491e3          	bne	s1,s3,800018a8 <kill+0x20>
  }
  return -1;
    800018ca:	557d                	li	a0,-1
    800018cc:	a829                	j	800018e6 <kill+0x5e>
      p->killed = 1;
    800018ce:	4785                	li	a5,1
    800018d0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d2:	4c98                	lw	a4,24(s1)
    800018d4:	4789                	li	a5,2
    800018d6:	00f70f63          	beq	a4,a5,800018f4 <kill+0x6c>
      release(&p->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	9ba080e7          	jalr	-1606(ra) # 80006296 <release>
      return 0;
    800018e4:	4501                	li	a0,0
}
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6145                	addi	sp,sp,48
    800018f2:	8082                	ret
        p->state = RUNNABLE;
    800018f4:	478d                	li	a5,3
    800018f6:	cc9c                	sw	a5,24(s1)
    800018f8:	b7cd                	j	800018da <kill+0x52>

00000000800018fa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fa:	7179                	addi	sp,sp,-48
    800018fc:	f406                	sd	ra,40(sp)
    800018fe:	f022                	sd	s0,32(sp)
    80001900:	ec26                	sd	s1,24(sp)
    80001902:	e84a                	sd	s2,16(sp)
    80001904:	e44e                	sd	s3,8(sp)
    80001906:	e052                	sd	s4,0(sp)
    80001908:	1800                	addi	s0,sp,48
    8000190a:	84aa                	mv	s1,a0
    8000190c:	892e                	mv	s2,a1
    8000190e:	89b2                	mv	s3,a2
    80001910:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001912:	fffff097          	auipc	ra,0xfffff
    80001916:	580080e7          	jalr	1408(ra) # 80000e92 <myproc>
  if(user_dst){
    8000191a:	c08d                	beqz	s1,8000193c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191c:	86d2                	mv	a3,s4
    8000191e:	864e                	mv	a2,s3
    80001920:	85ca                	mv	a1,s2
    80001922:	6d28                	ld	a0,88(a0)
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	230080e7          	jalr	560(ra) # 80000b54 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6a02                	ld	s4,0(sp)
    80001938:	6145                	addi	sp,sp,48
    8000193a:	8082                	ret
    memmove((char *)dst, src, len);
    8000193c:	000a061b          	sext.w	a2,s4
    80001940:	85ce                	mv	a1,s3
    80001942:	854a                	mv	a0,s2
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	8de080e7          	jalr	-1826(ra) # 80000222 <memmove>
    return 0;
    8000194c:	8526                	mv	a0,s1
    8000194e:	bff9                	j	8000192c <either_copyout+0x32>

0000000080001950 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001950:	7179                	addi	sp,sp,-48
    80001952:	f406                	sd	ra,40(sp)
    80001954:	f022                	sd	s0,32(sp)
    80001956:	ec26                	sd	s1,24(sp)
    80001958:	e84a                	sd	s2,16(sp)
    8000195a:	e44e                	sd	s3,8(sp)
    8000195c:	e052                	sd	s4,0(sp)
    8000195e:	1800                	addi	s0,sp,48
    80001960:	892a                	mv	s2,a0
    80001962:	84ae                	mv	s1,a1
    80001964:	89b2                	mv	s3,a2
    80001966:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	52a080e7          	jalr	1322(ra) # 80000e92 <myproc>
  if(user_src){
    80001970:	c08d                	beqz	s1,80001992 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001972:	86d2                	mv	a3,s4
    80001974:	864e                	mv	a2,s3
    80001976:	85ca                	mv	a1,s2
    80001978:	6d28                	ld	a0,88(a0)
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	266080e7          	jalr	614(ra) # 80000be0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001982:	70a2                	ld	ra,40(sp)
    80001984:	7402                	ld	s0,32(sp)
    80001986:	64e2                	ld	s1,24(sp)
    80001988:	6942                	ld	s2,16(sp)
    8000198a:	69a2                	ld	s3,8(sp)
    8000198c:	6a02                	ld	s4,0(sp)
    8000198e:	6145                	addi	sp,sp,48
    80001990:	8082                	ret
    memmove(dst, (char*)src, len);
    80001992:	000a061b          	sext.w	a2,s4
    80001996:	85ce                	mv	a1,s3
    80001998:	854a                	mv	a0,s2
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	888080e7          	jalr	-1912(ra) # 80000222 <memmove>
    return 0;
    800019a2:	8526                	mv	a0,s1
    800019a4:	bff9                	j	80001982 <either_copyin+0x32>

00000000800019a6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a6:	715d                	addi	sp,sp,-80
    800019a8:	e486                	sd	ra,72(sp)
    800019aa:	e0a2                	sd	s0,64(sp)
    800019ac:	fc26                	sd	s1,56(sp)
    800019ae:	f84a                	sd	s2,48(sp)
    800019b0:	f44e                	sd	s3,40(sp)
    800019b2:	f052                	sd	s4,32(sp)
    800019b4:	ec56                	sd	s5,24(sp)
    800019b6:	e85a                	sd	s6,16(sp)
    800019b8:	e45e                	sd	s7,8(sp)
    800019ba:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019bc:	00006517          	auipc	a0,0x6
    800019c0:	68c50513          	addi	a0,a0,1676 # 80008048 <etext+0x48>
    800019c4:	00004097          	auipc	ra,0x4
    800019c8:	31e080e7          	jalr	798(ra) # 80005ce2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019cc:	00008497          	auipc	s1,0x8
    800019d0:	c1448493          	addi	s1,s1,-1004 # 800095e0 <proc+0x160>
    800019d4:	0000e917          	auipc	s2,0xe
    800019d8:	80c90913          	addi	s2,s2,-2036 # 8000f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019de:	00007997          	auipc	s3,0x7
    800019e2:	82298993          	addi	s3,s3,-2014 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e6:	00007a97          	auipc	s5,0x7
    800019ea:	822a8a93          	addi	s5,s5,-2014 # 80008208 <etext+0x208>
    printf("\n");
    800019ee:	00006a17          	auipc	s4,0x6
    800019f2:	65aa0a13          	addi	s4,s4,1626 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f6:	00007b97          	auipc	s7,0x7
    800019fa:	84ab8b93          	addi	s7,s7,-1974 # 80008240 <states.1714>
    800019fe:	a00d                	j	80001a20 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a00:	ed06a583          	lw	a1,-304(a3)
    80001a04:	8556                	mv	a0,s5
    80001a06:	00004097          	auipc	ra,0x4
    80001a0a:	2dc080e7          	jalr	732(ra) # 80005ce2 <printf>
    printf("\n");
    80001a0e:	8552                	mv	a0,s4
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	2d2080e7          	jalr	722(ra) # 80005ce2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a18:	17048493          	addi	s1,s1,368
    80001a1c:	03248163          	beq	s1,s2,80001a3e <procdump+0x98>
    if(p->state == UNUSED)
    80001a20:	86a6                	mv	a3,s1
    80001a22:	eb84a783          	lw	a5,-328(s1)
    80001a26:	dbed                	beqz	a5,80001a18 <procdump+0x72>
      state = "???";
    80001a28:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2a:	fcfb6be3          	bltu	s6,a5,80001a00 <procdump+0x5a>
    80001a2e:	1782                	slli	a5,a5,0x20
    80001a30:	9381                	srli	a5,a5,0x20
    80001a32:	078e                	slli	a5,a5,0x3
    80001a34:	97de                	add	a5,a5,s7
    80001a36:	6390                	ld	a2,0(a5)
    80001a38:	f661                	bnez	a2,80001a00 <procdump+0x5a>
      state = "???";
    80001a3a:	864e                	mv	a2,s3
    80001a3c:	b7d1                	j	80001a00 <procdump+0x5a>
  }
}
    80001a3e:	60a6                	ld	ra,72(sp)
    80001a40:	6406                	ld	s0,64(sp)
    80001a42:	74e2                	ld	s1,56(sp)
    80001a44:	7942                	ld	s2,48(sp)
    80001a46:	79a2                	ld	s3,40(sp)
    80001a48:	7a02                	ld	s4,32(sp)
    80001a4a:	6ae2                	ld	s5,24(sp)
    80001a4c:	6b42                	ld	s6,16(sp)
    80001a4e:	6ba2                	ld	s7,8(sp)
    80001a50:	6161                	addi	sp,sp,80
    80001a52:	8082                	ret

0000000080001a54 <numProc>:
uint64
numProc(void)  //to get the number of procs
{
    80001a54:	7179                	addi	sp,sp,-48
    80001a56:	f406                	sd	ra,40(sp)
    80001a58:	f022                	sd	s0,32(sp)
    80001a5a:	ec26                	sd	s1,24(sp)
    80001a5c:	e84a                	sd	s2,16(sp)
    80001a5e:	e44e                	sd	s3,8(sp)
    80001a60:	1800                	addi	s0,sp,48
  struct proc *p;
  uint64 num=0;
    80001a62:	4901                	li	s2,0
  for(p=proc;p<&proc[NPROC];p++){  //traverse the procs
    80001a64:	00008497          	auipc	s1,0x8
    80001a68:	a1c48493          	addi	s1,s1,-1508 # 80009480 <proc>
    80001a6c:	0000d997          	auipc	s3,0xd
    80001a70:	61498993          	addi	s3,s3,1556 # 8000f080 <tickslock>
    acquire(&p->lock);  //to add lock
    80001a74:	8526                	mv	a0,s1
    80001a76:	00004097          	auipc	ra,0x4
    80001a7a:	76c080e7          	jalr	1900(ra) # 800061e2 <acquire>
    if(p->state!=UNUSED)
    80001a7e:	4c9c                	lw	a5,24(s1)
      num++;  //count the procs
    80001a80:	00f037b3          	snez	a5,a5
    80001a84:	993e                	add	s2,s2,a5
    release(&p->lock);  //to release lock
    80001a86:	8526                	mv	a0,s1
    80001a88:	00005097          	auipc	ra,0x5
    80001a8c:	80e080e7          	jalr	-2034(ra) # 80006296 <release>
  for(p=proc;p<&proc[NPROC];p++){  //traverse the procs
    80001a90:	17048493          	addi	s1,s1,368
    80001a94:	ff3490e3          	bne	s1,s3,80001a74 <numProc+0x20>
  }
  return num;
}
    80001a98:	854a                	mv	a0,s2
    80001a9a:	70a2                	ld	ra,40(sp)
    80001a9c:	7402                	ld	s0,32(sp)
    80001a9e:	64e2                	ld	s1,24(sp)
    80001aa0:	6942                	ld	s2,16(sp)
    80001aa2:	69a2                	ld	s3,8(sp)
    80001aa4:	6145                	addi	sp,sp,48
    80001aa6:	8082                	ret

0000000080001aa8 <swtch>:
    80001aa8:	00153023          	sd	ra,0(a0)
    80001aac:	00253423          	sd	sp,8(a0)
    80001ab0:	e900                	sd	s0,16(a0)
    80001ab2:	ed04                	sd	s1,24(a0)
    80001ab4:	03253023          	sd	s2,32(a0)
    80001ab8:	03353423          	sd	s3,40(a0)
    80001abc:	03453823          	sd	s4,48(a0)
    80001ac0:	03553c23          	sd	s5,56(a0)
    80001ac4:	05653023          	sd	s6,64(a0)
    80001ac8:	05753423          	sd	s7,72(a0)
    80001acc:	05853823          	sd	s8,80(a0)
    80001ad0:	05953c23          	sd	s9,88(a0)
    80001ad4:	07a53023          	sd	s10,96(a0)
    80001ad8:	07b53423          	sd	s11,104(a0)
    80001adc:	0005b083          	ld	ra,0(a1)
    80001ae0:	0085b103          	ld	sp,8(a1)
    80001ae4:	6980                	ld	s0,16(a1)
    80001ae6:	6d84                	ld	s1,24(a1)
    80001ae8:	0205b903          	ld	s2,32(a1)
    80001aec:	0285b983          	ld	s3,40(a1)
    80001af0:	0305ba03          	ld	s4,48(a1)
    80001af4:	0385ba83          	ld	s5,56(a1)
    80001af8:	0405bb03          	ld	s6,64(a1)
    80001afc:	0485bb83          	ld	s7,72(a1)
    80001b00:	0505bc03          	ld	s8,80(a1)
    80001b04:	0585bc83          	ld	s9,88(a1)
    80001b08:	0605bd03          	ld	s10,96(a1)
    80001b0c:	0685bd83          	ld	s11,104(a1)
    80001b10:	8082                	ret

0000000080001b12 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b12:	1141                	addi	sp,sp,-16
    80001b14:	e406                	sd	ra,8(sp)
    80001b16:	e022                	sd	s0,0(sp)
    80001b18:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b1a:	00006597          	auipc	a1,0x6
    80001b1e:	75658593          	addi	a1,a1,1878 # 80008270 <states.1714+0x30>
    80001b22:	0000d517          	auipc	a0,0xd
    80001b26:	55e50513          	addi	a0,a0,1374 # 8000f080 <tickslock>
    80001b2a:	00004097          	auipc	ra,0x4
    80001b2e:	628080e7          	jalr	1576(ra) # 80006152 <initlock>
}
    80001b32:	60a2                	ld	ra,8(sp)
    80001b34:	6402                	ld	s0,0(sp)
    80001b36:	0141                	addi	sp,sp,16
    80001b38:	8082                	ret

0000000080001b3a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b3a:	1141                	addi	sp,sp,-16
    80001b3c:	e422                	sd	s0,8(sp)
    80001b3e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b40:	00003797          	auipc	a5,0x3
    80001b44:	56078793          	addi	a5,a5,1376 # 800050a0 <kernelvec>
    80001b48:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b4c:	6422                	ld	s0,8(sp)
    80001b4e:	0141                	addi	sp,sp,16
    80001b50:	8082                	ret

0000000080001b52 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b52:	1141                	addi	sp,sp,-16
    80001b54:	e406                	sd	ra,8(sp)
    80001b56:	e022                	sd	s0,0(sp)
    80001b58:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	338080e7          	jalr	824(ra) # 80000e92 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b68:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b6c:	00005617          	auipc	a2,0x5
    80001b70:	49460613          	addi	a2,a2,1172 # 80007000 <_trampoline>
    80001b74:	00005697          	auipc	a3,0x5
    80001b78:	48c68693          	addi	a3,a3,1164 # 80007000 <_trampoline>
    80001b7c:	8e91                	sub	a3,a3,a2
    80001b7e:	040007b7          	lui	a5,0x4000
    80001b82:	17fd                	addi	a5,a5,-1
    80001b84:	07b2                	slli	a5,a5,0xc
    80001b86:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b88:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b8c:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b8e:	180026f3          	csrr	a3,satp
    80001b92:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b94:	7138                	ld	a4,96(a0)
    80001b96:	6534                	ld	a3,72(a0)
    80001b98:	6585                	lui	a1,0x1
    80001b9a:	96ae                	add	a3,a3,a1
    80001b9c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b9e:	7138                	ld	a4,96(a0)
    80001ba0:	00000697          	auipc	a3,0x0
    80001ba4:	13868693          	addi	a3,a3,312 # 80001cd8 <usertrap>
    80001ba8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001baa:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bac:	8692                	mv	a3,tp
    80001bae:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bb4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bb8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bbc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bc0:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc2:	6f18                	ld	a4,24(a4)
    80001bc4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bc8:	6d2c                	ld	a1,88(a0)
    80001bca:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bcc:	00005717          	auipc	a4,0x5
    80001bd0:	4c470713          	addi	a4,a4,1220 # 80007090 <userret>
    80001bd4:	8f11                	sub	a4,a4,a2
    80001bd6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bd8:	577d                	li	a4,-1
    80001bda:	177e                	slli	a4,a4,0x3f
    80001bdc:	8dd9                	or	a1,a1,a4
    80001bde:	02000537          	lui	a0,0x2000
    80001be2:	157d                	addi	a0,a0,-1
    80001be4:	0536                	slli	a0,a0,0xd
    80001be6:	9782                	jalr	a5
}
    80001be8:	60a2                	ld	ra,8(sp)
    80001bea:	6402                	ld	s0,0(sp)
    80001bec:	0141                	addi	sp,sp,16
    80001bee:	8082                	ret

0000000080001bf0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bfa:	0000d497          	auipc	s1,0xd
    80001bfe:	48648493          	addi	s1,s1,1158 # 8000f080 <tickslock>
    80001c02:	8526                	mv	a0,s1
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	5de080e7          	jalr	1502(ra) # 800061e2 <acquire>
  ticks++;
    80001c0c:	00007517          	auipc	a0,0x7
    80001c10:	40c50513          	addi	a0,a0,1036 # 80009018 <ticks>
    80001c14:	411c                	lw	a5,0(a0)
    80001c16:	2785                	addiw	a5,a5,1
    80001c18:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c1a:	00000097          	auipc	ra,0x0
    80001c1e:	ac8080e7          	jalr	-1336(ra) # 800016e2 <wakeup>
  release(&tickslock);
    80001c22:	8526                	mv	a0,s1
    80001c24:	00004097          	auipc	ra,0x4
    80001c28:	672080e7          	jalr	1650(ra) # 80006296 <release>
}
    80001c2c:	60e2                	ld	ra,24(sp)
    80001c2e:	6442                	ld	s0,16(sp)
    80001c30:	64a2                	ld	s1,8(sp)
    80001c32:	6105                	addi	sp,sp,32
    80001c34:	8082                	ret

0000000080001c36 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c36:	1101                	addi	sp,sp,-32
    80001c38:	ec06                	sd	ra,24(sp)
    80001c3a:	e822                	sd	s0,16(sp)
    80001c3c:	e426                	sd	s1,8(sp)
    80001c3e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c40:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c44:	00074d63          	bltz	a4,80001c5e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c48:	57fd                	li	a5,-1
    80001c4a:	17fe                	slli	a5,a5,0x3f
    80001c4c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c4e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c50:	06f70363          	beq	a4,a5,80001cb6 <devintr+0x80>
  }
}
    80001c54:	60e2                	ld	ra,24(sp)
    80001c56:	6442                	ld	s0,16(sp)
    80001c58:	64a2                	ld	s1,8(sp)
    80001c5a:	6105                	addi	sp,sp,32
    80001c5c:	8082                	ret
     (scause & 0xff) == 9){
    80001c5e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c62:	46a5                	li	a3,9
    80001c64:	fed792e3          	bne	a5,a3,80001c48 <devintr+0x12>
    int irq = plic_claim();
    80001c68:	00003097          	auipc	ra,0x3
    80001c6c:	540080e7          	jalr	1344(ra) # 800051a8 <plic_claim>
    80001c70:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c72:	47a9                	li	a5,10
    80001c74:	02f50763          	beq	a0,a5,80001ca2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c78:	4785                	li	a5,1
    80001c7a:	02f50963          	beq	a0,a5,80001cac <devintr+0x76>
    return 1;
    80001c7e:	4505                	li	a0,1
    } else if(irq){
    80001c80:	d8f1                	beqz	s1,80001c54 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c82:	85a6                	mv	a1,s1
    80001c84:	00006517          	auipc	a0,0x6
    80001c88:	5f450513          	addi	a0,a0,1524 # 80008278 <states.1714+0x38>
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	056080e7          	jalr	86(ra) # 80005ce2 <printf>
      plic_complete(irq);
    80001c94:	8526                	mv	a0,s1
    80001c96:	00003097          	auipc	ra,0x3
    80001c9a:	536080e7          	jalr	1334(ra) # 800051cc <plic_complete>
    return 1;
    80001c9e:	4505                	li	a0,1
    80001ca0:	bf55                	j	80001c54 <devintr+0x1e>
      uartintr();
    80001ca2:	00004097          	auipc	ra,0x4
    80001ca6:	460080e7          	jalr	1120(ra) # 80006102 <uartintr>
    80001caa:	b7ed                	j	80001c94 <devintr+0x5e>
      virtio_disk_intr();
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	a00080e7          	jalr	-1536(ra) # 800056ac <virtio_disk_intr>
    80001cb4:	b7c5                	j	80001c94 <devintr+0x5e>
    if(cpuid() == 0){
    80001cb6:	fffff097          	auipc	ra,0xfffff
    80001cba:	1b0080e7          	jalr	432(ra) # 80000e66 <cpuid>
    80001cbe:	c901                	beqz	a0,80001cce <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cc0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cc4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cc6:	14479073          	csrw	sip,a5
    return 2;
    80001cca:	4509                	li	a0,2
    80001ccc:	b761                	j	80001c54 <devintr+0x1e>
      clockintr();
    80001cce:	00000097          	auipc	ra,0x0
    80001cd2:	f22080e7          	jalr	-222(ra) # 80001bf0 <clockintr>
    80001cd6:	b7ed                	j	80001cc0 <devintr+0x8a>

0000000080001cd8 <usertrap>:
{
    80001cd8:	1101                	addi	sp,sp,-32
    80001cda:	ec06                	sd	ra,24(sp)
    80001cdc:	e822                	sd	s0,16(sp)
    80001cde:	e426                	sd	s1,8(sp)
    80001ce0:	e04a                	sd	s2,0(sp)
    80001ce2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ce8:	1007f793          	andi	a5,a5,256
    80001cec:	e3ad                	bnez	a5,80001d4e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cee:	00003797          	auipc	a5,0x3
    80001cf2:	3b278793          	addi	a5,a5,946 # 800050a0 <kernelvec>
    80001cf6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	198080e7          	jalr	408(ra) # 80000e92 <myproc>
    80001d02:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d04:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d06:	14102773          	csrr	a4,sepc
    80001d0a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d0c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d10:	47a1                	li	a5,8
    80001d12:	04f71c63          	bne	a4,a5,80001d6a <usertrap+0x92>
    if(p->killed)
    80001d16:	551c                	lw	a5,40(a0)
    80001d18:	e3b9                	bnez	a5,80001d5e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d1a:	70b8                	ld	a4,96(s1)
    80001d1c:	6f1c                	ld	a5,24(a4)
    80001d1e:	0791                	addi	a5,a5,4
    80001d20:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d26:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2a:	10079073          	csrw	sstatus,a5
    syscall();
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	2e0080e7          	jalr	736(ra) # 8000200e <syscall>
  if(p->killed)
    80001d36:	549c                	lw	a5,40(s1)
    80001d38:	ebc1                	bnez	a5,80001dc8 <usertrap+0xf0>
  usertrapret();
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	e18080e7          	jalr	-488(ra) # 80001b52 <usertrapret>
}
    80001d42:	60e2                	ld	ra,24(sp)
    80001d44:	6442                	ld	s0,16(sp)
    80001d46:	64a2                	ld	s1,8(sp)
    80001d48:	6902                	ld	s2,0(sp)
    80001d4a:	6105                	addi	sp,sp,32
    80001d4c:	8082                	ret
    panic("usertrap: not from user mode");
    80001d4e:	00006517          	auipc	a0,0x6
    80001d52:	54a50513          	addi	a0,a0,1354 # 80008298 <states.1714+0x58>
    80001d56:	00004097          	auipc	ra,0x4
    80001d5a:	f42080e7          	jalr	-190(ra) # 80005c98 <panic>
      exit(-1);
    80001d5e:	557d                	li	a0,-1
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	a52080e7          	jalr	-1454(ra) # 800017b2 <exit>
    80001d68:	bf4d                	j	80001d1a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	ecc080e7          	jalr	-308(ra) # 80001c36 <devintr>
    80001d72:	892a                	mv	s2,a0
    80001d74:	c501                	beqz	a0,80001d7c <usertrap+0xa4>
  if(p->killed)
    80001d76:	549c                	lw	a5,40(s1)
    80001d78:	c3a1                	beqz	a5,80001db8 <usertrap+0xe0>
    80001d7a:	a815                	j	80001dae <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d80:	5890                	lw	a2,48(s1)
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	53650513          	addi	a0,a0,1334 # 800082b8 <states.1714+0x78>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	f58080e7          	jalr	-168(ra) # 80005ce2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d92:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d96:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d9a:	00006517          	auipc	a0,0x6
    80001d9e:	54e50513          	addi	a0,a0,1358 # 800082e8 <states.1714+0xa8>
    80001da2:	00004097          	auipc	ra,0x4
    80001da6:	f40080e7          	jalr	-192(ra) # 80005ce2 <printf>
    p->killed = 1;
    80001daa:	4785                	li	a5,1
    80001dac:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dae:	557d                	li	a0,-1
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	a02080e7          	jalr	-1534(ra) # 800017b2 <exit>
  if(which_dev == 2)
    80001db8:	4789                	li	a5,2
    80001dba:	f8f910e3          	bne	s2,a5,80001d3a <usertrap+0x62>
    yield();
    80001dbe:	fffff097          	auipc	ra,0xfffff
    80001dc2:	75c080e7          	jalr	1884(ra) # 8000151a <yield>
    80001dc6:	bf95                	j	80001d3a <usertrap+0x62>
  int which_dev = 0;
    80001dc8:	4901                	li	s2,0
    80001dca:	b7d5                	j	80001dae <usertrap+0xd6>

0000000080001dcc <kerneltrap>:
{
    80001dcc:	7179                	addi	sp,sp,-48
    80001dce:	f406                	sd	ra,40(sp)
    80001dd0:	f022                	sd	s0,32(sp)
    80001dd2:	ec26                	sd	s1,24(sp)
    80001dd4:	e84a                	sd	s2,16(sp)
    80001dd6:	e44e                	sd	s3,8(sp)
    80001dd8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dda:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dde:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001de6:	1004f793          	andi	a5,s1,256
    80001dea:	cb85                	beqz	a5,80001e1a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001df0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001df2:	ef85                	bnez	a5,80001e2a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	e42080e7          	jalr	-446(ra) # 80001c36 <devintr>
    80001dfc:	cd1d                	beqz	a0,80001e3a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dfe:	4789                	li	a5,2
    80001e00:	06f50a63          	beq	a0,a5,80001e74 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e04:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e08:	10049073          	csrw	sstatus,s1
}
    80001e0c:	70a2                	ld	ra,40(sp)
    80001e0e:	7402                	ld	s0,32(sp)
    80001e10:	64e2                	ld	s1,24(sp)
    80001e12:	6942                	ld	s2,16(sp)
    80001e14:	69a2                	ld	s3,8(sp)
    80001e16:	6145                	addi	sp,sp,48
    80001e18:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	4ee50513          	addi	a0,a0,1262 # 80008308 <states.1714+0xc8>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	e76080e7          	jalr	-394(ra) # 80005c98 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	50650513          	addi	a0,a0,1286 # 80008330 <states.1714+0xf0>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	e66080e7          	jalr	-410(ra) # 80005c98 <panic>
    printf("scause %p\n", scause);
    80001e3a:	85ce                	mv	a1,s3
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	51450513          	addi	a0,a0,1300 # 80008350 <states.1714+0x110>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	e9e080e7          	jalr	-354(ra) # 80005ce2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e50:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e54:	00006517          	auipc	a0,0x6
    80001e58:	50c50513          	addi	a0,a0,1292 # 80008360 <states.1714+0x120>
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	e86080e7          	jalr	-378(ra) # 80005ce2 <printf>
    panic("kerneltrap");
    80001e64:	00006517          	auipc	a0,0x6
    80001e68:	51450513          	addi	a0,a0,1300 # 80008378 <states.1714+0x138>
    80001e6c:	00004097          	auipc	ra,0x4
    80001e70:	e2c080e7          	jalr	-468(ra) # 80005c98 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	01e080e7          	jalr	30(ra) # 80000e92 <myproc>
    80001e7c:	d541                	beqz	a0,80001e04 <kerneltrap+0x38>
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	014080e7          	jalr	20(ra) # 80000e92 <myproc>
    80001e86:	4d18                	lw	a4,24(a0)
    80001e88:	4791                	li	a5,4
    80001e8a:	f6f71de3          	bne	a4,a5,80001e04 <kerneltrap+0x38>
    yield();
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	68c080e7          	jalr	1676(ra) # 8000151a <yield>
    80001e96:	b7bd                	j	80001e04 <kerneltrap+0x38>

0000000080001e98 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e98:	1101                	addi	sp,sp,-32
    80001e9a:	ec06                	sd	ra,24(sp)
    80001e9c:	e822                	sd	s0,16(sp)
    80001e9e:	e426                	sd	s1,8(sp)
    80001ea0:	1000                	addi	s0,sp,32
    80001ea2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	fee080e7          	jalr	-18(ra) # 80000e92 <myproc>
  switch (n) {
    80001eac:	4795                	li	a5,5
    80001eae:	0497e163          	bltu	a5,s1,80001ef0 <argraw+0x58>
    80001eb2:	048a                	slli	s1,s1,0x2
    80001eb4:	00006717          	auipc	a4,0x6
    80001eb8:	5c470713          	addi	a4,a4,1476 # 80008478 <states.1714+0x238>
    80001ebc:	94ba                	add	s1,s1,a4
    80001ebe:	409c                	lw	a5,0(s1)
    80001ec0:	97ba                	add	a5,a5,a4
    80001ec2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ec4:	713c                	ld	a5,96(a0)
    80001ec6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ec8:	60e2                	ld	ra,24(sp)
    80001eca:	6442                	ld	s0,16(sp)
    80001ecc:	64a2                	ld	s1,8(sp)
    80001ece:	6105                	addi	sp,sp,32
    80001ed0:	8082                	ret
    return p->trapframe->a1;
    80001ed2:	713c                	ld	a5,96(a0)
    80001ed4:	7fa8                	ld	a0,120(a5)
    80001ed6:	bfcd                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a2;
    80001ed8:	713c                	ld	a5,96(a0)
    80001eda:	63c8                	ld	a0,128(a5)
    80001edc:	b7f5                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a3;
    80001ede:	713c                	ld	a5,96(a0)
    80001ee0:	67c8                	ld	a0,136(a5)
    80001ee2:	b7dd                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a4;
    80001ee4:	713c                	ld	a5,96(a0)
    80001ee6:	6bc8                	ld	a0,144(a5)
    80001ee8:	b7c5                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a5;
    80001eea:	713c                	ld	a5,96(a0)
    80001eec:	6fc8                	ld	a0,152(a5)
    80001eee:	bfe9                	j	80001ec8 <argraw+0x30>
  panic("argraw");
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	49850513          	addi	a0,a0,1176 # 80008388 <states.1714+0x148>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	da0080e7          	jalr	-608(ra) # 80005c98 <panic>

0000000080001f00 <fetchaddr>:
{
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	e426                	sd	s1,8(sp)
    80001f08:	e04a                	sd	s2,0(sp)
    80001f0a:	1000                	addi	s0,sp,32
    80001f0c:	84aa                	mv	s1,a0
    80001f0e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	f82080e7          	jalr	-126(ra) # 80000e92 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f18:	693c                	ld	a5,80(a0)
    80001f1a:	02f4f863          	bgeu	s1,a5,80001f4a <fetchaddr+0x4a>
    80001f1e:	00848713          	addi	a4,s1,8
    80001f22:	02e7e663          	bltu	a5,a4,80001f4e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f26:	46a1                	li	a3,8
    80001f28:	8626                	mv	a2,s1
    80001f2a:	85ca                	mv	a1,s2
    80001f2c:	6d28                	ld	a0,88(a0)
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	cb2080e7          	jalr	-846(ra) # 80000be0 <copyin>
    80001f36:	00a03533          	snez	a0,a0
    80001f3a:	40a00533          	neg	a0,a0
}
    80001f3e:	60e2                	ld	ra,24(sp)
    80001f40:	6442                	ld	s0,16(sp)
    80001f42:	64a2                	ld	s1,8(sp)
    80001f44:	6902                	ld	s2,0(sp)
    80001f46:	6105                	addi	sp,sp,32
    80001f48:	8082                	ret
    return -1;
    80001f4a:	557d                	li	a0,-1
    80001f4c:	bfcd                	j	80001f3e <fetchaddr+0x3e>
    80001f4e:	557d                	li	a0,-1
    80001f50:	b7fd                	j	80001f3e <fetchaddr+0x3e>

0000000080001f52 <fetchstr>:
{
    80001f52:	7179                	addi	sp,sp,-48
    80001f54:	f406                	sd	ra,40(sp)
    80001f56:	f022                	sd	s0,32(sp)
    80001f58:	ec26                	sd	s1,24(sp)
    80001f5a:	e84a                	sd	s2,16(sp)
    80001f5c:	e44e                	sd	s3,8(sp)
    80001f5e:	1800                	addi	s0,sp,48
    80001f60:	892a                	mv	s2,a0
    80001f62:	84ae                	mv	s1,a1
    80001f64:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	f2c080e7          	jalr	-212(ra) # 80000e92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f6e:	86ce                	mv	a3,s3
    80001f70:	864a                	mv	a2,s2
    80001f72:	85a6                	mv	a1,s1
    80001f74:	6d28                	ld	a0,88(a0)
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	cf6080e7          	jalr	-778(ra) # 80000c6c <copyinstr>
  if(err < 0)
    80001f7e:	00054763          	bltz	a0,80001f8c <fetchstr+0x3a>
  return strlen(buf);
    80001f82:	8526                	mv	a0,s1
    80001f84:	ffffe097          	auipc	ra,0xffffe
    80001f88:	3c2080e7          	jalr	962(ra) # 80000346 <strlen>
}
    80001f8c:	70a2                	ld	ra,40(sp)
    80001f8e:	7402                	ld	s0,32(sp)
    80001f90:	64e2                	ld	s1,24(sp)
    80001f92:	6942                	ld	s2,16(sp)
    80001f94:	69a2                	ld	s3,8(sp)
    80001f96:	6145                	addi	sp,sp,48
    80001f98:	8082                	ret

0000000080001f9a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f9a:	1101                	addi	sp,sp,-32
    80001f9c:	ec06                	sd	ra,24(sp)
    80001f9e:	e822                	sd	s0,16(sp)
    80001fa0:	e426                	sd	s1,8(sp)
    80001fa2:	1000                	addi	s0,sp,32
    80001fa4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa6:	00000097          	auipc	ra,0x0
    80001faa:	ef2080e7          	jalr	-270(ra) # 80001e98 <argraw>
    80001fae:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fb0:	4501                	li	a0,0
    80001fb2:	60e2                	ld	ra,24(sp)
    80001fb4:	6442                	ld	s0,16(sp)
    80001fb6:	64a2                	ld	s1,8(sp)
    80001fb8:	6105                	addi	sp,sp,32
    80001fba:	8082                	ret

0000000080001fbc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fbc:	1101                	addi	sp,sp,-32
    80001fbe:	ec06                	sd	ra,24(sp)
    80001fc0:	e822                	sd	s0,16(sp)
    80001fc2:	e426                	sd	s1,8(sp)
    80001fc4:	1000                	addi	s0,sp,32
    80001fc6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	ed0080e7          	jalr	-304(ra) # 80001e98 <argraw>
    80001fd0:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fd2:	4501                	li	a0,0
    80001fd4:	60e2                	ld	ra,24(sp)
    80001fd6:	6442                	ld	s0,16(sp)
    80001fd8:	64a2                	ld	s1,8(sp)
    80001fda:	6105                	addi	sp,sp,32
    80001fdc:	8082                	ret

0000000080001fde <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
    80001fea:	84ae                	mv	s1,a1
    80001fec:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	eaa080e7          	jalr	-342(ra) # 80001e98 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001ff6:	864a                	mv	a2,s2
    80001ff8:	85a6                	mv	a1,s1
    80001ffa:	00000097          	auipc	ra,0x0
    80001ffe:	f58080e7          	jalr	-168(ra) # 80001f52 <fetchstr>
}
    80002002:	60e2                	ld	ra,24(sp)
    80002004:	6442                	ld	s0,16(sp)
    80002006:	64a2                	ld	s1,8(sp)
    80002008:	6902                	ld	s2,0(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret

000000008000200e <syscall>:
[SYS_sysinfo]   sys_sysinfo,
};
char *syscall_names[] = {"", "fork", "exit", "wait", "pipe","read", "kill", "exec", "fstat", "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open", "write", "mknod", "unlink", "link", "mkdir", "close", "trace","sysinfo"};
void
syscall(void)
{
    8000200e:	7179                	addi	sp,sp,-48
    80002010:	f406                	sd	ra,40(sp)
    80002012:	f022                	sd	s0,32(sp)
    80002014:	ec26                	sd	s1,24(sp)
    80002016:	e84a                	sd	s2,16(sp)
    80002018:	e44e                	sd	s3,8(sp)
    8000201a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	e76080e7          	jalr	-394(ra) # 80000e92 <myproc>
    80002024:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002026:	06053903          	ld	s2,96(a0)
    8000202a:	0a893783          	ld	a5,168(s2)
    8000202e:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002032:	37fd                	addiw	a5,a5,-1
    80002034:	4759                	li	a4,22
    80002036:	04f76863          	bltu	a4,a5,80002086 <syscall+0x78>
    8000203a:	00399713          	slli	a4,s3,0x3
    8000203e:	00006797          	auipc	a5,0x6
    80002042:	45278793          	addi	a5,a5,1106 # 80008490 <syscalls>
    80002046:	97ba                	add	a5,a5,a4
    80002048:	639c                	ld	a5,0(a5)
    8000204a:	cf95                	beqz	a5,80002086 <syscall+0x78>
    p->trapframe->a0 = syscalls[num]();
    8000204c:	9782                	jalr	a5
    8000204e:	06a93823          	sd	a0,112(s2)
     if((1 << num) & p->mask) {  //when 2^num==proc()->mask,match successful
    80002052:	4785                	li	a5,1
    80002054:	013797bb          	sllw	a5,a5,s3
    80002058:	7c98                	ld	a4,56(s1)
    8000205a:	8ff9                	and	a5,a5,a4
    8000205c:	c7a1                	beqz	a5,800020a4 <syscall+0x96>
      printf("%d: syscall %s -> %d\n", p->pid, syscall_names[num], p->trapframe->a0);
    8000205e:	70b8                	ld	a4,96(s1)
    80002060:	098e                	slli	s3,s3,0x3
    80002062:	00007797          	auipc	a5,0x7
    80002066:	8c678793          	addi	a5,a5,-1850 # 80008928 <syscall_names>
    8000206a:	99be                	add	s3,s3,a5
    8000206c:	7b34                	ld	a3,112(a4)
    8000206e:	0009b603          	ld	a2,0(s3)
    80002072:	588c                	lw	a1,48(s1)
    80002074:	00006517          	auipc	a0,0x6
    80002078:	31c50513          	addi	a0,a0,796 # 80008390 <states.1714+0x150>
    8000207c:	00004097          	auipc	ra,0x4
    80002080:	c66080e7          	jalr	-922(ra) # 80005ce2 <printf>
    80002084:	a005                	j	800020a4 <syscall+0x96>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002086:	86ce                	mv	a3,s3
    80002088:	16048613          	addi	a2,s1,352
    8000208c:	588c                	lw	a1,48(s1)
    8000208e:	00006517          	auipc	a0,0x6
    80002092:	31a50513          	addi	a0,a0,794 # 800083a8 <states.1714+0x168>
    80002096:	00004097          	auipc	ra,0x4
    8000209a:	c4c080e7          	jalr	-948(ra) # 80005ce2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000209e:	70bc                	ld	a5,96(s1)
    800020a0:	577d                	li	a4,-1
    800020a2:	fbb8                	sd	a4,112(a5)
  }
}
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6942                	ld	s2,16(sp)
    800020ac:	69a2                	ld	s3,8(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret

00000000800020b2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"
uint64
sys_exit(void)
{
    800020b2:	1101                	addi	sp,sp,-32
    800020b4:	ec06                	sd	ra,24(sp)
    800020b6:	e822                	sd	s0,16(sp)
    800020b8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020ba:	fec40593          	addi	a1,s0,-20
    800020be:	4501                	li	a0,0
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	eda080e7          	jalr	-294(ra) # 80001f9a <argint>
    return -1;
    800020c8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020ca:	00054963          	bltz	a0,800020dc <sys_exit+0x2a>
  exit(n);
    800020ce:	fec42503          	lw	a0,-20(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	6e0080e7          	jalr	1760(ra) # 800017b2 <exit>
  return 0;  // not reached
    800020da:	4781                	li	a5,0
}
    800020dc:	853e                	mv	a0,a5
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e6:	1141                	addi	sp,sp,-16
    800020e8:	e406                	sd	ra,8(sp)
    800020ea:	e022                	sd	s0,0(sp)
    800020ec:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	da4080e7          	jalr	-604(ra) # 80000e92 <myproc>
}
    800020f6:	5908                	lw	a0,48(a0)
    800020f8:	60a2                	ld	ra,8(sp)
    800020fa:	6402                	ld	s0,0(sp)
    800020fc:	0141                	addi	sp,sp,16
    800020fe:	8082                	ret

0000000080002100 <sys_fork>:

uint64
sys_fork(void)
{
    80002100:	1141                	addi	sp,sp,-16
    80002102:	e406                	sd	ra,8(sp)
    80002104:	e022                	sd	s0,0(sp)
    80002106:	0800                	addi	s0,sp,16
  return fork();
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	158080e7          	jalr	344(ra) # 80001260 <fork>
}
    80002110:	60a2                	ld	ra,8(sp)
    80002112:	6402                	ld	s0,0(sp)
    80002114:	0141                	addi	sp,sp,16
    80002116:	8082                	ret

0000000080002118 <sys_wait>:

uint64
sys_wait(void)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002120:	fe840593          	addi	a1,s0,-24
    80002124:	4501                	li	a0,0
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	e96080e7          	jalr	-362(ra) # 80001fbc <argaddr>
    8000212e:	87aa                	mv	a5,a0
    return -1;
    80002130:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002132:	0007c863          	bltz	a5,80002142 <sys_wait+0x2a>
  return wait(p);
    80002136:	fe843503          	ld	a0,-24(s0)
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	480080e7          	jalr	1152(ra) # 800015ba <wait>
}
    80002142:	60e2                	ld	ra,24(sp)
    80002144:	6442                	ld	s0,16(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000214a:	7179                	addi	sp,sp,-48
    8000214c:	f406                	sd	ra,40(sp)
    8000214e:	f022                	sd	s0,32(sp)
    80002150:	ec26                	sd	s1,24(sp)
    80002152:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002154:	fdc40593          	addi	a1,s0,-36
    80002158:	4501                	li	a0,0
    8000215a:	00000097          	auipc	ra,0x0
    8000215e:	e40080e7          	jalr	-448(ra) # 80001f9a <argint>
    80002162:	87aa                	mv	a5,a0
    return -1;
    80002164:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002166:	0207c063          	bltz	a5,80002186 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	d28080e7          	jalr	-728(ra) # 80000e92 <myproc>
    80002172:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002174:	fdc42503          	lw	a0,-36(s0)
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	074080e7          	jalr	116(ra) # 800011ec <growproc>
    80002180:	00054863          	bltz	a0,80002190 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002184:	8526                	mv	a0,s1
}
    80002186:	70a2                	ld	ra,40(sp)
    80002188:	7402                	ld	s0,32(sp)
    8000218a:	64e2                	ld	s1,24(sp)
    8000218c:	6145                	addi	sp,sp,48
    8000218e:	8082                	ret
    return -1;
    80002190:	557d                	li	a0,-1
    80002192:	bfd5                	j	80002186 <sys_sbrk+0x3c>

0000000080002194 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002194:	7139                	addi	sp,sp,-64
    80002196:	fc06                	sd	ra,56(sp)
    80002198:	f822                	sd	s0,48(sp)
    8000219a:	f426                	sd	s1,40(sp)
    8000219c:	f04a                	sd	s2,32(sp)
    8000219e:	ec4e                	sd	s3,24(sp)
    800021a0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021a2:	fcc40593          	addi	a1,s0,-52
    800021a6:	4501                	li	a0,0
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	df2080e7          	jalr	-526(ra) # 80001f9a <argint>
    return -1;
    800021b0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021b2:	06054563          	bltz	a0,8000221c <sys_sleep+0x88>
  acquire(&tickslock);
    800021b6:	0000d517          	auipc	a0,0xd
    800021ba:	eca50513          	addi	a0,a0,-310 # 8000f080 <tickslock>
    800021be:	00004097          	auipc	ra,0x4
    800021c2:	024080e7          	jalr	36(ra) # 800061e2 <acquire>
  ticks0 = ticks;
    800021c6:	00007917          	auipc	s2,0x7
    800021ca:	e5292903          	lw	s2,-430(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021ce:	fcc42783          	lw	a5,-52(s0)
    800021d2:	cf85                	beqz	a5,8000220a <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021d4:	0000d997          	auipc	s3,0xd
    800021d8:	eac98993          	addi	s3,s3,-340 # 8000f080 <tickslock>
    800021dc:	00007497          	auipc	s1,0x7
    800021e0:	e3c48493          	addi	s1,s1,-452 # 80009018 <ticks>
    if(myproc()->killed){
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	cae080e7          	jalr	-850(ra) # 80000e92 <myproc>
    800021ec:	551c                	lw	a5,40(a0)
    800021ee:	ef9d                	bnez	a5,8000222c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021f0:	85ce                	mv	a1,s3
    800021f2:	8526                	mv	a0,s1
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	362080e7          	jalr	866(ra) # 80001556 <sleep>
  while(ticks - ticks0 < n){
    800021fc:	409c                	lw	a5,0(s1)
    800021fe:	412787bb          	subw	a5,a5,s2
    80002202:	fcc42703          	lw	a4,-52(s0)
    80002206:	fce7efe3          	bltu	a5,a4,800021e4 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000220a:	0000d517          	auipc	a0,0xd
    8000220e:	e7650513          	addi	a0,a0,-394 # 8000f080 <tickslock>
    80002212:	00004097          	auipc	ra,0x4
    80002216:	084080e7          	jalr	132(ra) # 80006296 <release>
  return 0;
    8000221a:	4781                	li	a5,0
}
    8000221c:	853e                	mv	a0,a5
    8000221e:	70e2                	ld	ra,56(sp)
    80002220:	7442                	ld	s0,48(sp)
    80002222:	74a2                	ld	s1,40(sp)
    80002224:	7902                	ld	s2,32(sp)
    80002226:	69e2                	ld	s3,24(sp)
    80002228:	6121                	addi	sp,sp,64
    8000222a:	8082                	ret
      release(&tickslock);
    8000222c:	0000d517          	auipc	a0,0xd
    80002230:	e5450513          	addi	a0,a0,-428 # 8000f080 <tickslock>
    80002234:	00004097          	auipc	ra,0x4
    80002238:	062080e7          	jalr	98(ra) # 80006296 <release>
      return -1;
    8000223c:	57fd                	li	a5,-1
    8000223e:	bff9                	j	8000221c <sys_sleep+0x88>

0000000080002240 <sys_kill>:

uint64
sys_kill(void)
{
    80002240:	1101                	addi	sp,sp,-32
    80002242:	ec06                	sd	ra,24(sp)
    80002244:	e822                	sd	s0,16(sp)
    80002246:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002248:	fec40593          	addi	a1,s0,-20
    8000224c:	4501                	li	a0,0
    8000224e:	00000097          	auipc	ra,0x0
    80002252:	d4c080e7          	jalr	-692(ra) # 80001f9a <argint>
    80002256:	87aa                	mv	a5,a0
    return -1;
    80002258:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000225a:	0007c863          	bltz	a5,8000226a <sys_kill+0x2a>
  return kill(pid);
    8000225e:	fec42503          	lw	a0,-20(s0)
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	626080e7          	jalr	1574(ra) # 80001888 <kill>
}
    8000226a:	60e2                	ld	ra,24(sp)
    8000226c:	6442                	ld	s0,16(sp)
    8000226e:	6105                	addi	sp,sp,32
    80002270:	8082                	ret

0000000080002272 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002272:	1101                	addi	sp,sp,-32
    80002274:	ec06                	sd	ra,24(sp)
    80002276:	e822                	sd	s0,16(sp)
    80002278:	e426                	sd	s1,8(sp)
    8000227a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000227c:	0000d517          	auipc	a0,0xd
    80002280:	e0450513          	addi	a0,a0,-508 # 8000f080 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	f5e080e7          	jalr	-162(ra) # 800061e2 <acquire>
  xticks = ticks;
    8000228c:	00007497          	auipc	s1,0x7
    80002290:	d8c4a483          	lw	s1,-628(s1) # 80009018 <ticks>
  release(&tickslock);
    80002294:	0000d517          	auipc	a0,0xd
    80002298:	dec50513          	addi	a0,a0,-532 # 8000f080 <tickslock>
    8000229c:	00004097          	auipc	ra,0x4
    800022a0:	ffa080e7          	jalr	-6(ra) # 80006296 <release>
  return xticks;
}
    800022a4:	02049513          	slli	a0,s1,0x20
    800022a8:	9101                	srli	a0,a0,0x20
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	64a2                	ld	s1,8(sp)
    800022b0:	6105                	addi	sp,sp,32
    800022b2:	8082                	ret

00000000800022b4 <sys_trace>:
uint64
sys_trace(void)
{
    800022b4:	7179                	addi	sp,sp,-48
    800022b6:	f406                	sd	ra,40(sp)
    800022b8:	f022                	sd	s0,32(sp)
    800022ba:	ec26                	sd	s1,24(sp)
    800022bc:	1800                	addi	s0,sp,48
  int n;
  if(argint(0, &n) < 0)
    800022be:	fdc40593          	addi	a1,s0,-36
    800022c2:	4501                	li	a0,0
    800022c4:	00000097          	auipc	ra,0x0
    800022c8:	cd6080e7          	jalr	-810(ra) # 80001f9a <argint>
    return -1;
    800022cc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022ce:	00054a63          	bltz	a0,800022e2 <sys_trace+0x2e>
   myproc()->mask=n;  //set the current process's trace maskS
    800022d2:	fdc42483          	lw	s1,-36(s0)
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	bbc080e7          	jalr	-1092(ra) # 80000e92 <myproc>
    800022de:	fd04                	sd	s1,56(a0)
   return 0;
    800022e0:	4781                	li	a5,0
}
    800022e2:	853e                	mv	a0,a5
    800022e4:	70a2                	ld	ra,40(sp)
    800022e6:	7402                	ld	s0,32(sp)
    800022e8:	64e2                	ld	s1,24(sp)
    800022ea:	6145                	addi	sp,sp,48
    800022ec:	8082                	ret

00000000800022ee <sys_sysinfo>:
uint64
sys_sysinfo(void)
{
    800022ee:	7139                	addi	sp,sp,-64
    800022f0:	fc06                	sd	ra,56(sp)
    800022f2:	f822                	sd	s0,48(sp)
    800022f4:	f426                	sd	s1,40(sp)
    800022f6:	0080                	addi	s0,sp,64
  struct sysinfo sys;
  struct proc *currp=myproc();
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	b9a080e7          	jalr	-1126(ra) # 80000e92 <myproc>
    80002300:	84aa                	mv	s1,a0
  uint64 addr;
  sys.freemem=freeMem();
    80002302:	ffffe097          	auipc	ra,0xffffe
    80002306:	e76080e7          	jalr	-394(ra) # 80000178 <freeMem>
    8000230a:	fca43823          	sd	a0,-48(s0)
  sys.nproc=numProc();
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	746080e7          	jalr	1862(ra) # 80001a54 <numProc>
    80002316:	fca43c23          	sd	a0,-40(s0)
  if(argaddr(0,&addr)<0)  //wrong address is put in
    8000231a:	fc840593          	addi	a1,s0,-56
    8000231e:	4501                	li	a0,0
    80002320:	00000097          	auipc	ra,0x0
    80002324:	c9c080e7          	jalr	-868(ra) # 80001fbc <argaddr>
    return -1;
    80002328:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0)  //wrong address is put in
    8000232a:	00054e63          	bltz	a0,80002346 <sys_sysinfo+0x58>
  int copyjudge=copyout(currp->pagetable,addr,(char*)&sys,sizeof(sys));  //copy to user
    8000232e:	46c1                	li	a3,16
    80002330:	fd040613          	addi	a2,s0,-48
    80002334:	fc843583          	ld	a1,-56(s0)
    80002338:	6ca8                	ld	a0,88(s1)
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	81a080e7          	jalr	-2022(ra) # 80000b54 <copyout>
  if(copyjudge<0)return -1;  //wrong copy
    80002342:	43f55793          	srai	a5,a0,0x3f
  return 0;
}
    80002346:	853e                	mv	a0,a5
    80002348:	70e2                	ld	ra,56(sp)
    8000234a:	7442                	ld	s0,48(sp)
    8000234c:	74a2                	ld	s1,40(sp)
    8000234e:	6121                	addi	sp,sp,64
    80002350:	8082                	ret

0000000080002352 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002352:	7179                	addi	sp,sp,-48
    80002354:	f406                	sd	ra,40(sp)
    80002356:	f022                	sd	s0,32(sp)
    80002358:	ec26                	sd	s1,24(sp)
    8000235a:	e84a                	sd	s2,16(sp)
    8000235c:	e44e                	sd	s3,8(sp)
    8000235e:	e052                	sd	s4,0(sp)
    80002360:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002362:	00006597          	auipc	a1,0x6
    80002366:	1ee58593          	addi	a1,a1,494 # 80008550 <syscalls+0xc0>
    8000236a:	0000d517          	auipc	a0,0xd
    8000236e:	d2e50513          	addi	a0,a0,-722 # 8000f098 <bcache>
    80002372:	00004097          	auipc	ra,0x4
    80002376:	de0080e7          	jalr	-544(ra) # 80006152 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000237a:	00015797          	auipc	a5,0x15
    8000237e:	d1e78793          	addi	a5,a5,-738 # 80017098 <bcache+0x8000>
    80002382:	00015717          	auipc	a4,0x15
    80002386:	f7e70713          	addi	a4,a4,-130 # 80017300 <bcache+0x8268>
    8000238a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000238e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002392:	0000d497          	auipc	s1,0xd
    80002396:	d1e48493          	addi	s1,s1,-738 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000239a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000239c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000239e:	00006a17          	auipc	s4,0x6
    800023a2:	1baa0a13          	addi	s4,s4,442 # 80008558 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023a6:	2b893783          	ld	a5,696(s2)
    800023aa:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023ac:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b0:	85d2                	mv	a1,s4
    800023b2:	01048513          	addi	a0,s1,16
    800023b6:	00001097          	auipc	ra,0x1
    800023ba:	4bc080e7          	jalr	1212(ra) # 80003872 <initsleeplock>
    bcache.head.next->prev = b;
    800023be:	2b893783          	ld	a5,696(s2)
    800023c2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c8:	45848493          	addi	s1,s1,1112
    800023cc:	fd349de3          	bne	s1,s3,800023a6 <binit+0x54>
  }
}
    800023d0:	70a2                	ld	ra,40(sp)
    800023d2:	7402                	ld	s0,32(sp)
    800023d4:	64e2                	ld	s1,24(sp)
    800023d6:	6942                	ld	s2,16(sp)
    800023d8:	69a2                	ld	s3,8(sp)
    800023da:	6a02                	ld	s4,0(sp)
    800023dc:	6145                	addi	sp,sp,48
    800023de:	8082                	ret

00000000800023e0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e0:	7179                	addi	sp,sp,-48
    800023e2:	f406                	sd	ra,40(sp)
    800023e4:	f022                	sd	s0,32(sp)
    800023e6:	ec26                	sd	s1,24(sp)
    800023e8:	e84a                	sd	s2,16(sp)
    800023ea:	e44e                	sd	s3,8(sp)
    800023ec:	1800                	addi	s0,sp,48
    800023ee:	89aa                	mv	s3,a0
    800023f0:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023f2:	0000d517          	auipc	a0,0xd
    800023f6:	ca650513          	addi	a0,a0,-858 # 8000f098 <bcache>
    800023fa:	00004097          	auipc	ra,0x4
    800023fe:	de8080e7          	jalr	-536(ra) # 800061e2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002402:	00015497          	auipc	s1,0x15
    80002406:	f4e4b483          	ld	s1,-178(s1) # 80017350 <bcache+0x82b8>
    8000240a:	00015797          	auipc	a5,0x15
    8000240e:	ef678793          	addi	a5,a5,-266 # 80017300 <bcache+0x8268>
    80002412:	02f48f63          	beq	s1,a5,80002450 <bread+0x70>
    80002416:	873e                	mv	a4,a5
    80002418:	a021                	j	80002420 <bread+0x40>
    8000241a:	68a4                	ld	s1,80(s1)
    8000241c:	02e48a63          	beq	s1,a4,80002450 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002420:	449c                	lw	a5,8(s1)
    80002422:	ff379ce3          	bne	a5,s3,8000241a <bread+0x3a>
    80002426:	44dc                	lw	a5,12(s1)
    80002428:	ff2799e3          	bne	a5,s2,8000241a <bread+0x3a>
      b->refcnt++;
    8000242c:	40bc                	lw	a5,64(s1)
    8000242e:	2785                	addiw	a5,a5,1
    80002430:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002432:	0000d517          	auipc	a0,0xd
    80002436:	c6650513          	addi	a0,a0,-922 # 8000f098 <bcache>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	e5c080e7          	jalr	-420(ra) # 80006296 <release>
      acquiresleep(&b->lock);
    80002442:	01048513          	addi	a0,s1,16
    80002446:	00001097          	auipc	ra,0x1
    8000244a:	466080e7          	jalr	1126(ra) # 800038ac <acquiresleep>
      return b;
    8000244e:	a8b9                	j	800024ac <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002450:	00015497          	auipc	s1,0x15
    80002454:	ef84b483          	ld	s1,-264(s1) # 80017348 <bcache+0x82b0>
    80002458:	00015797          	auipc	a5,0x15
    8000245c:	ea878793          	addi	a5,a5,-344 # 80017300 <bcache+0x8268>
    80002460:	00f48863          	beq	s1,a5,80002470 <bread+0x90>
    80002464:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002466:	40bc                	lw	a5,64(s1)
    80002468:	cf81                	beqz	a5,80002480 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246a:	64a4                	ld	s1,72(s1)
    8000246c:	fee49de3          	bne	s1,a4,80002466 <bread+0x86>
  panic("bget: no buffers");
    80002470:	00006517          	auipc	a0,0x6
    80002474:	0f050513          	addi	a0,a0,240 # 80008560 <syscalls+0xd0>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	820080e7          	jalr	-2016(ra) # 80005c98 <panic>
      b->dev = dev;
    80002480:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002484:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002488:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000248c:	4785                	li	a5,1
    8000248e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002490:	0000d517          	auipc	a0,0xd
    80002494:	c0850513          	addi	a0,a0,-1016 # 8000f098 <bcache>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	dfe080e7          	jalr	-514(ra) # 80006296 <release>
      acquiresleep(&b->lock);
    800024a0:	01048513          	addi	a0,s1,16
    800024a4:	00001097          	auipc	ra,0x1
    800024a8:	408080e7          	jalr	1032(ra) # 800038ac <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024ac:	409c                	lw	a5,0(s1)
    800024ae:	cb89                	beqz	a5,800024c0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b0:	8526                	mv	a0,s1
    800024b2:	70a2                	ld	ra,40(sp)
    800024b4:	7402                	ld	s0,32(sp)
    800024b6:	64e2                	ld	s1,24(sp)
    800024b8:	6942                	ld	s2,16(sp)
    800024ba:	69a2                	ld	s3,8(sp)
    800024bc:	6145                	addi	sp,sp,48
    800024be:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c0:	4581                	li	a1,0
    800024c2:	8526                	mv	a0,s1
    800024c4:	00003097          	auipc	ra,0x3
    800024c8:	f12080e7          	jalr	-238(ra) # 800053d6 <virtio_disk_rw>
    b->valid = 1;
    800024cc:	4785                	li	a5,1
    800024ce:	c09c                	sw	a5,0(s1)
  return b;
    800024d0:	b7c5                	j	800024b0 <bread+0xd0>

00000000800024d2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d2:	1101                	addi	sp,sp,-32
    800024d4:	ec06                	sd	ra,24(sp)
    800024d6:	e822                	sd	s0,16(sp)
    800024d8:	e426                	sd	s1,8(sp)
    800024da:	1000                	addi	s0,sp,32
    800024dc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024de:	0541                	addi	a0,a0,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	466080e7          	jalr	1126(ra) # 80003946 <holdingsleep>
    800024e8:	cd01                	beqz	a0,80002500 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ea:	4585                	li	a1,1
    800024ec:	8526                	mv	a0,s1
    800024ee:	00003097          	auipc	ra,0x3
    800024f2:	ee8080e7          	jalr	-280(ra) # 800053d6 <virtio_disk_rw>
}
    800024f6:	60e2                	ld	ra,24(sp)
    800024f8:	6442                	ld	s0,16(sp)
    800024fa:	64a2                	ld	s1,8(sp)
    800024fc:	6105                	addi	sp,sp,32
    800024fe:	8082                	ret
    panic("bwrite");
    80002500:	00006517          	auipc	a0,0x6
    80002504:	07850513          	addi	a0,a0,120 # 80008578 <syscalls+0xe8>
    80002508:	00003097          	auipc	ra,0x3
    8000250c:	790080e7          	jalr	1936(ra) # 80005c98 <panic>

0000000080002510 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002510:	1101                	addi	sp,sp,-32
    80002512:	ec06                	sd	ra,24(sp)
    80002514:	e822                	sd	s0,16(sp)
    80002516:	e426                	sd	s1,8(sp)
    80002518:	e04a                	sd	s2,0(sp)
    8000251a:	1000                	addi	s0,sp,32
    8000251c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251e:	01050913          	addi	s2,a0,16
    80002522:	854a                	mv	a0,s2
    80002524:	00001097          	auipc	ra,0x1
    80002528:	422080e7          	jalr	1058(ra) # 80003946 <holdingsleep>
    8000252c:	c92d                	beqz	a0,8000259e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000252e:	854a                	mv	a0,s2
    80002530:	00001097          	auipc	ra,0x1
    80002534:	3d2080e7          	jalr	978(ra) # 80003902 <releasesleep>

  acquire(&bcache.lock);
    80002538:	0000d517          	auipc	a0,0xd
    8000253c:	b6050513          	addi	a0,a0,-1184 # 8000f098 <bcache>
    80002540:	00004097          	auipc	ra,0x4
    80002544:	ca2080e7          	jalr	-862(ra) # 800061e2 <acquire>
  b->refcnt--;
    80002548:	40bc                	lw	a5,64(s1)
    8000254a:	37fd                	addiw	a5,a5,-1
    8000254c:	0007871b          	sext.w	a4,a5
    80002550:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002552:	eb05                	bnez	a4,80002582 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002554:	68bc                	ld	a5,80(s1)
    80002556:	64b8                	ld	a4,72(s1)
    80002558:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000255a:	64bc                	ld	a5,72(s1)
    8000255c:	68b8                	ld	a4,80(s1)
    8000255e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002560:	00015797          	auipc	a5,0x15
    80002564:	b3878793          	addi	a5,a5,-1224 # 80017098 <bcache+0x8000>
    80002568:	2b87b703          	ld	a4,696(a5)
    8000256c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000256e:	00015717          	auipc	a4,0x15
    80002572:	d9270713          	addi	a4,a4,-622 # 80017300 <bcache+0x8268>
    80002576:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002578:	2b87b703          	ld	a4,696(a5)
    8000257c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000257e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002582:	0000d517          	auipc	a0,0xd
    80002586:	b1650513          	addi	a0,a0,-1258 # 8000f098 <bcache>
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	d0c080e7          	jalr	-756(ra) # 80006296 <release>
}
    80002592:	60e2                	ld	ra,24(sp)
    80002594:	6442                	ld	s0,16(sp)
    80002596:	64a2                	ld	s1,8(sp)
    80002598:	6902                	ld	s2,0(sp)
    8000259a:	6105                	addi	sp,sp,32
    8000259c:	8082                	ret
    panic("brelse");
    8000259e:	00006517          	auipc	a0,0x6
    800025a2:	fe250513          	addi	a0,a0,-30 # 80008580 <syscalls+0xf0>
    800025a6:	00003097          	auipc	ra,0x3
    800025aa:	6f2080e7          	jalr	1778(ra) # 80005c98 <panic>

00000000800025ae <bpin>:

void
bpin(struct buf *b) {
    800025ae:	1101                	addi	sp,sp,-32
    800025b0:	ec06                	sd	ra,24(sp)
    800025b2:	e822                	sd	s0,16(sp)
    800025b4:	e426                	sd	s1,8(sp)
    800025b6:	1000                	addi	s0,sp,32
    800025b8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025ba:	0000d517          	auipc	a0,0xd
    800025be:	ade50513          	addi	a0,a0,-1314 # 8000f098 <bcache>
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	c20080e7          	jalr	-992(ra) # 800061e2 <acquire>
  b->refcnt++;
    800025ca:	40bc                	lw	a5,64(s1)
    800025cc:	2785                	addiw	a5,a5,1
    800025ce:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d0:	0000d517          	auipc	a0,0xd
    800025d4:	ac850513          	addi	a0,a0,-1336 # 8000f098 <bcache>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	cbe080e7          	jalr	-834(ra) # 80006296 <release>
}
    800025e0:	60e2                	ld	ra,24(sp)
    800025e2:	6442                	ld	s0,16(sp)
    800025e4:	64a2                	ld	s1,8(sp)
    800025e6:	6105                	addi	sp,sp,32
    800025e8:	8082                	ret

00000000800025ea <bunpin>:

void
bunpin(struct buf *b) {
    800025ea:	1101                	addi	sp,sp,-32
    800025ec:	ec06                	sd	ra,24(sp)
    800025ee:	e822                	sd	s0,16(sp)
    800025f0:	e426                	sd	s1,8(sp)
    800025f2:	1000                	addi	s0,sp,32
    800025f4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f6:	0000d517          	auipc	a0,0xd
    800025fa:	aa250513          	addi	a0,a0,-1374 # 8000f098 <bcache>
    800025fe:	00004097          	auipc	ra,0x4
    80002602:	be4080e7          	jalr	-1052(ra) # 800061e2 <acquire>
  b->refcnt--;
    80002606:	40bc                	lw	a5,64(s1)
    80002608:	37fd                	addiw	a5,a5,-1
    8000260a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260c:	0000d517          	auipc	a0,0xd
    80002610:	a8c50513          	addi	a0,a0,-1396 # 8000f098 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	c82080e7          	jalr	-894(ra) # 80006296 <release>
}
    8000261c:	60e2                	ld	ra,24(sp)
    8000261e:	6442                	ld	s0,16(sp)
    80002620:	64a2                	ld	s1,8(sp)
    80002622:	6105                	addi	sp,sp,32
    80002624:	8082                	ret

0000000080002626 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002626:	1101                	addi	sp,sp,-32
    80002628:	ec06                	sd	ra,24(sp)
    8000262a:	e822                	sd	s0,16(sp)
    8000262c:	e426                	sd	s1,8(sp)
    8000262e:	e04a                	sd	s2,0(sp)
    80002630:	1000                	addi	s0,sp,32
    80002632:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002634:	00d5d59b          	srliw	a1,a1,0xd
    80002638:	00015797          	auipc	a5,0x15
    8000263c:	13c7a783          	lw	a5,316(a5) # 80017774 <sb+0x1c>
    80002640:	9dbd                	addw	a1,a1,a5
    80002642:	00000097          	auipc	ra,0x0
    80002646:	d9e080e7          	jalr	-610(ra) # 800023e0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000264a:	0074f713          	andi	a4,s1,7
    8000264e:	4785                	li	a5,1
    80002650:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002654:	14ce                	slli	s1,s1,0x33
    80002656:	90d9                	srli	s1,s1,0x36
    80002658:	00950733          	add	a4,a0,s1
    8000265c:	05874703          	lbu	a4,88(a4)
    80002660:	00e7f6b3          	and	a3,a5,a4
    80002664:	c69d                	beqz	a3,80002692 <bfree+0x6c>
    80002666:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002668:	94aa                	add	s1,s1,a0
    8000266a:	fff7c793          	not	a5,a5
    8000266e:	8ff9                	and	a5,a5,a4
    80002670:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002674:	00001097          	auipc	ra,0x1
    80002678:	118080e7          	jalr	280(ra) # 8000378c <log_write>
  brelse(bp);
    8000267c:	854a                	mv	a0,s2
    8000267e:	00000097          	auipc	ra,0x0
    80002682:	e92080e7          	jalr	-366(ra) # 80002510 <brelse>
}
    80002686:	60e2                	ld	ra,24(sp)
    80002688:	6442                	ld	s0,16(sp)
    8000268a:	64a2                	ld	s1,8(sp)
    8000268c:	6902                	ld	s2,0(sp)
    8000268e:	6105                	addi	sp,sp,32
    80002690:	8082                	ret
    panic("freeing free block");
    80002692:	00006517          	auipc	a0,0x6
    80002696:	ef650513          	addi	a0,a0,-266 # 80008588 <syscalls+0xf8>
    8000269a:	00003097          	auipc	ra,0x3
    8000269e:	5fe080e7          	jalr	1534(ra) # 80005c98 <panic>

00000000800026a2 <balloc>:
{
    800026a2:	711d                	addi	sp,sp,-96
    800026a4:	ec86                	sd	ra,88(sp)
    800026a6:	e8a2                	sd	s0,80(sp)
    800026a8:	e4a6                	sd	s1,72(sp)
    800026aa:	e0ca                	sd	s2,64(sp)
    800026ac:	fc4e                	sd	s3,56(sp)
    800026ae:	f852                	sd	s4,48(sp)
    800026b0:	f456                	sd	s5,40(sp)
    800026b2:	f05a                	sd	s6,32(sp)
    800026b4:	ec5e                	sd	s7,24(sp)
    800026b6:	e862                	sd	s8,16(sp)
    800026b8:	e466                	sd	s9,8(sp)
    800026ba:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026bc:	00015797          	auipc	a5,0x15
    800026c0:	0a07a783          	lw	a5,160(a5) # 8001775c <sb+0x4>
    800026c4:	cbd1                	beqz	a5,80002758 <balloc+0xb6>
    800026c6:	8baa                	mv	s7,a0
    800026c8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026ca:	00015b17          	auipc	s6,0x15
    800026ce:	08eb0b13          	addi	s6,s6,142 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026d8:	6c89                	lui	s9,0x2
    800026da:	a831                	j	800026f6 <balloc+0x54>
    brelse(bp);
    800026dc:	854a                	mv	a0,s2
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	e32080e7          	jalr	-462(ra) # 80002510 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026e6:	015c87bb          	addw	a5,s9,s5
    800026ea:	00078a9b          	sext.w	s5,a5
    800026ee:	004b2703          	lw	a4,4(s6)
    800026f2:	06eaf363          	bgeu	s5,a4,80002758 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026f6:	41fad79b          	sraiw	a5,s5,0x1f
    800026fa:	0137d79b          	srliw	a5,a5,0x13
    800026fe:	015787bb          	addw	a5,a5,s5
    80002702:	40d7d79b          	sraiw	a5,a5,0xd
    80002706:	01cb2583          	lw	a1,28(s6)
    8000270a:	9dbd                	addw	a1,a1,a5
    8000270c:	855e                	mv	a0,s7
    8000270e:	00000097          	auipc	ra,0x0
    80002712:	cd2080e7          	jalr	-814(ra) # 800023e0 <bread>
    80002716:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002718:	004b2503          	lw	a0,4(s6)
    8000271c:	000a849b          	sext.w	s1,s5
    80002720:	8662                	mv	a2,s8
    80002722:	faa4fde3          	bgeu	s1,a0,800026dc <balloc+0x3a>
      m = 1 << (bi % 8);
    80002726:	41f6579b          	sraiw	a5,a2,0x1f
    8000272a:	01d7d69b          	srliw	a3,a5,0x1d
    8000272e:	00c6873b          	addw	a4,a3,a2
    80002732:	00777793          	andi	a5,a4,7
    80002736:	9f95                	subw	a5,a5,a3
    80002738:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000273c:	4037571b          	sraiw	a4,a4,0x3
    80002740:	00e906b3          	add	a3,s2,a4
    80002744:	0586c683          	lbu	a3,88(a3)
    80002748:	00d7f5b3          	and	a1,a5,a3
    8000274c:	cd91                	beqz	a1,80002768 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000274e:	2605                	addiw	a2,a2,1
    80002750:	2485                	addiw	s1,s1,1
    80002752:	fd4618e3          	bne	a2,s4,80002722 <balloc+0x80>
    80002756:	b759                	j	800026dc <balloc+0x3a>
  panic("balloc: out of blocks");
    80002758:	00006517          	auipc	a0,0x6
    8000275c:	e4850513          	addi	a0,a0,-440 # 800085a0 <syscalls+0x110>
    80002760:	00003097          	auipc	ra,0x3
    80002764:	538080e7          	jalr	1336(ra) # 80005c98 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002768:	974a                	add	a4,a4,s2
    8000276a:	8fd5                	or	a5,a5,a3
    8000276c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002770:	854a                	mv	a0,s2
    80002772:	00001097          	auipc	ra,0x1
    80002776:	01a080e7          	jalr	26(ra) # 8000378c <log_write>
        brelse(bp);
    8000277a:	854a                	mv	a0,s2
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	d94080e7          	jalr	-620(ra) # 80002510 <brelse>
  bp = bread(dev, bno);
    80002784:	85a6                	mv	a1,s1
    80002786:	855e                	mv	a0,s7
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	c58080e7          	jalr	-936(ra) # 800023e0 <bread>
    80002790:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002792:	40000613          	li	a2,1024
    80002796:	4581                	li	a1,0
    80002798:	05850513          	addi	a0,a0,88
    8000279c:	ffffe097          	auipc	ra,0xffffe
    800027a0:	a26080e7          	jalr	-1498(ra) # 800001c2 <memset>
  log_write(bp);
    800027a4:	854a                	mv	a0,s2
    800027a6:	00001097          	auipc	ra,0x1
    800027aa:	fe6080e7          	jalr	-26(ra) # 8000378c <log_write>
  brelse(bp);
    800027ae:	854a                	mv	a0,s2
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	d60080e7          	jalr	-672(ra) # 80002510 <brelse>
}
    800027b8:	8526                	mv	a0,s1
    800027ba:	60e6                	ld	ra,88(sp)
    800027bc:	6446                	ld	s0,80(sp)
    800027be:	64a6                	ld	s1,72(sp)
    800027c0:	6906                	ld	s2,64(sp)
    800027c2:	79e2                	ld	s3,56(sp)
    800027c4:	7a42                	ld	s4,48(sp)
    800027c6:	7aa2                	ld	s5,40(sp)
    800027c8:	7b02                	ld	s6,32(sp)
    800027ca:	6be2                	ld	s7,24(sp)
    800027cc:	6c42                	ld	s8,16(sp)
    800027ce:	6ca2                	ld	s9,8(sp)
    800027d0:	6125                	addi	sp,sp,96
    800027d2:	8082                	ret

00000000800027d4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d4:	7179                	addi	sp,sp,-48
    800027d6:	f406                	sd	ra,40(sp)
    800027d8:	f022                	sd	s0,32(sp)
    800027da:	ec26                	sd	s1,24(sp)
    800027dc:	e84a                	sd	s2,16(sp)
    800027de:	e44e                	sd	s3,8(sp)
    800027e0:	e052                	sd	s4,0(sp)
    800027e2:	1800                	addi	s0,sp,48
    800027e4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027e6:	47ad                	li	a5,11
    800027e8:	04b7fe63          	bgeu	a5,a1,80002844 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ec:	ff45849b          	addiw	s1,a1,-12
    800027f0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027f4:	0ff00793          	li	a5,255
    800027f8:	0ae7e363          	bltu	a5,a4,8000289e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027fc:	08052583          	lw	a1,128(a0)
    80002800:	c5ad                	beqz	a1,8000286a <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002802:	00092503          	lw	a0,0(s2)
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	bda080e7          	jalr	-1062(ra) # 800023e0 <bread>
    8000280e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002810:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002814:	02049593          	slli	a1,s1,0x20
    80002818:	9181                	srli	a1,a1,0x20
    8000281a:	058a                	slli	a1,a1,0x2
    8000281c:	00b784b3          	add	s1,a5,a1
    80002820:	0004a983          	lw	s3,0(s1)
    80002824:	04098d63          	beqz	s3,8000287e <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002828:	8552                	mv	a0,s4
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	ce6080e7          	jalr	-794(ra) # 80002510 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002832:	854e                	mv	a0,s3
    80002834:	70a2                	ld	ra,40(sp)
    80002836:	7402                	ld	s0,32(sp)
    80002838:	64e2                	ld	s1,24(sp)
    8000283a:	6942                	ld	s2,16(sp)
    8000283c:	69a2                	ld	s3,8(sp)
    8000283e:	6a02                	ld	s4,0(sp)
    80002840:	6145                	addi	sp,sp,48
    80002842:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002844:	02059493          	slli	s1,a1,0x20
    80002848:	9081                	srli	s1,s1,0x20
    8000284a:	048a                	slli	s1,s1,0x2
    8000284c:	94aa                	add	s1,s1,a0
    8000284e:	0504a983          	lw	s3,80(s1)
    80002852:	fe0990e3          	bnez	s3,80002832 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002856:	4108                	lw	a0,0(a0)
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	e4a080e7          	jalr	-438(ra) # 800026a2 <balloc>
    80002860:	0005099b          	sext.w	s3,a0
    80002864:	0534a823          	sw	s3,80(s1)
    80002868:	b7e9                	j	80002832 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000286a:	4108                	lw	a0,0(a0)
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	e36080e7          	jalr	-458(ra) # 800026a2 <balloc>
    80002874:	0005059b          	sext.w	a1,a0
    80002878:	08b92023          	sw	a1,128(s2)
    8000287c:	b759                	j	80002802 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000287e:	00092503          	lw	a0,0(s2)
    80002882:	00000097          	auipc	ra,0x0
    80002886:	e20080e7          	jalr	-480(ra) # 800026a2 <balloc>
    8000288a:	0005099b          	sext.w	s3,a0
    8000288e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002892:	8552                	mv	a0,s4
    80002894:	00001097          	auipc	ra,0x1
    80002898:	ef8080e7          	jalr	-264(ra) # 8000378c <log_write>
    8000289c:	b771                	j	80002828 <bmap+0x54>
  panic("bmap: out of range");
    8000289e:	00006517          	auipc	a0,0x6
    800028a2:	d1a50513          	addi	a0,a0,-742 # 800085b8 <syscalls+0x128>
    800028a6:	00003097          	auipc	ra,0x3
    800028aa:	3f2080e7          	jalr	1010(ra) # 80005c98 <panic>

00000000800028ae <iget>:
{
    800028ae:	7179                	addi	sp,sp,-48
    800028b0:	f406                	sd	ra,40(sp)
    800028b2:	f022                	sd	s0,32(sp)
    800028b4:	ec26                	sd	s1,24(sp)
    800028b6:	e84a                	sd	s2,16(sp)
    800028b8:	e44e                	sd	s3,8(sp)
    800028ba:	e052                	sd	s4,0(sp)
    800028bc:	1800                	addi	s0,sp,48
    800028be:	89aa                	mv	s3,a0
    800028c0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028c2:	00015517          	auipc	a0,0x15
    800028c6:	eb650513          	addi	a0,a0,-330 # 80017778 <itable>
    800028ca:	00004097          	auipc	ra,0x4
    800028ce:	918080e7          	jalr	-1768(ra) # 800061e2 <acquire>
  empty = 0;
    800028d2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028d4:	00015497          	auipc	s1,0x15
    800028d8:	ebc48493          	addi	s1,s1,-324 # 80017790 <itable+0x18>
    800028dc:	00017697          	auipc	a3,0x17
    800028e0:	94468693          	addi	a3,a3,-1724 # 80019220 <log>
    800028e4:	a039                	j	800028f2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e6:	02090b63          	beqz	s2,8000291c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ea:	08848493          	addi	s1,s1,136
    800028ee:	02d48a63          	beq	s1,a3,80002922 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028f2:	449c                	lw	a5,8(s1)
    800028f4:	fef059e3          	blez	a5,800028e6 <iget+0x38>
    800028f8:	4098                	lw	a4,0(s1)
    800028fa:	ff3716e3          	bne	a4,s3,800028e6 <iget+0x38>
    800028fe:	40d8                	lw	a4,4(s1)
    80002900:	ff4713e3          	bne	a4,s4,800028e6 <iget+0x38>
      ip->ref++;
    80002904:	2785                	addiw	a5,a5,1
    80002906:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002908:	00015517          	auipc	a0,0x15
    8000290c:	e7050513          	addi	a0,a0,-400 # 80017778 <itable>
    80002910:	00004097          	auipc	ra,0x4
    80002914:	986080e7          	jalr	-1658(ra) # 80006296 <release>
      return ip;
    80002918:	8926                	mv	s2,s1
    8000291a:	a03d                	j	80002948 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000291c:	f7f9                	bnez	a5,800028ea <iget+0x3c>
    8000291e:	8926                	mv	s2,s1
    80002920:	b7e9                	j	800028ea <iget+0x3c>
  if(empty == 0)
    80002922:	02090c63          	beqz	s2,8000295a <iget+0xac>
  ip->dev = dev;
    80002926:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000292a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000292e:	4785                	li	a5,1
    80002930:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002934:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002938:	00015517          	auipc	a0,0x15
    8000293c:	e4050513          	addi	a0,a0,-448 # 80017778 <itable>
    80002940:	00004097          	auipc	ra,0x4
    80002944:	956080e7          	jalr	-1706(ra) # 80006296 <release>
}
    80002948:	854a                	mv	a0,s2
    8000294a:	70a2                	ld	ra,40(sp)
    8000294c:	7402                	ld	s0,32(sp)
    8000294e:	64e2                	ld	s1,24(sp)
    80002950:	6942                	ld	s2,16(sp)
    80002952:	69a2                	ld	s3,8(sp)
    80002954:	6a02                	ld	s4,0(sp)
    80002956:	6145                	addi	sp,sp,48
    80002958:	8082                	ret
    panic("iget: no inodes");
    8000295a:	00006517          	auipc	a0,0x6
    8000295e:	c7650513          	addi	a0,a0,-906 # 800085d0 <syscalls+0x140>
    80002962:	00003097          	auipc	ra,0x3
    80002966:	336080e7          	jalr	822(ra) # 80005c98 <panic>

000000008000296a <fsinit>:
fsinit(int dev) {
    8000296a:	7179                	addi	sp,sp,-48
    8000296c:	f406                	sd	ra,40(sp)
    8000296e:	f022                	sd	s0,32(sp)
    80002970:	ec26                	sd	s1,24(sp)
    80002972:	e84a                	sd	s2,16(sp)
    80002974:	e44e                	sd	s3,8(sp)
    80002976:	1800                	addi	s0,sp,48
    80002978:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000297a:	4585                	li	a1,1
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	a64080e7          	jalr	-1436(ra) # 800023e0 <bread>
    80002984:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002986:	00015997          	auipc	s3,0x15
    8000298a:	dd298993          	addi	s3,s3,-558 # 80017758 <sb>
    8000298e:	02000613          	li	a2,32
    80002992:	05850593          	addi	a1,a0,88
    80002996:	854e                	mv	a0,s3
    80002998:	ffffe097          	auipc	ra,0xffffe
    8000299c:	88a080e7          	jalr	-1910(ra) # 80000222 <memmove>
  brelse(bp);
    800029a0:	8526                	mv	a0,s1
    800029a2:	00000097          	auipc	ra,0x0
    800029a6:	b6e080e7          	jalr	-1170(ra) # 80002510 <brelse>
  if(sb.magic != FSMAGIC)
    800029aa:	0009a703          	lw	a4,0(s3)
    800029ae:	102037b7          	lui	a5,0x10203
    800029b2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029b6:	02f71263          	bne	a4,a5,800029da <fsinit+0x70>
  initlog(dev, &sb);
    800029ba:	00015597          	auipc	a1,0x15
    800029be:	d9e58593          	addi	a1,a1,-610 # 80017758 <sb>
    800029c2:	854a                	mv	a0,s2
    800029c4:	00001097          	auipc	ra,0x1
    800029c8:	b4c080e7          	jalr	-1204(ra) # 80003510 <initlog>
}
    800029cc:	70a2                	ld	ra,40(sp)
    800029ce:	7402                	ld	s0,32(sp)
    800029d0:	64e2                	ld	s1,24(sp)
    800029d2:	6942                	ld	s2,16(sp)
    800029d4:	69a2                	ld	s3,8(sp)
    800029d6:	6145                	addi	sp,sp,48
    800029d8:	8082                	ret
    panic("invalid file system");
    800029da:	00006517          	auipc	a0,0x6
    800029de:	c0650513          	addi	a0,a0,-1018 # 800085e0 <syscalls+0x150>
    800029e2:	00003097          	auipc	ra,0x3
    800029e6:	2b6080e7          	jalr	694(ra) # 80005c98 <panic>

00000000800029ea <iinit>:
{
    800029ea:	7179                	addi	sp,sp,-48
    800029ec:	f406                	sd	ra,40(sp)
    800029ee:	f022                	sd	s0,32(sp)
    800029f0:	ec26                	sd	s1,24(sp)
    800029f2:	e84a                	sd	s2,16(sp)
    800029f4:	e44e                	sd	s3,8(sp)
    800029f6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029f8:	00006597          	auipc	a1,0x6
    800029fc:	c0058593          	addi	a1,a1,-1024 # 800085f8 <syscalls+0x168>
    80002a00:	00015517          	auipc	a0,0x15
    80002a04:	d7850513          	addi	a0,a0,-648 # 80017778 <itable>
    80002a08:	00003097          	auipc	ra,0x3
    80002a0c:	74a080e7          	jalr	1866(ra) # 80006152 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a10:	00015497          	auipc	s1,0x15
    80002a14:	d9048493          	addi	s1,s1,-624 # 800177a0 <itable+0x28>
    80002a18:	00017997          	auipc	s3,0x17
    80002a1c:	81898993          	addi	s3,s3,-2024 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a20:	00006917          	auipc	s2,0x6
    80002a24:	be090913          	addi	s2,s2,-1056 # 80008600 <syscalls+0x170>
    80002a28:	85ca                	mv	a1,s2
    80002a2a:	8526                	mv	a0,s1
    80002a2c:	00001097          	auipc	ra,0x1
    80002a30:	e46080e7          	jalr	-442(ra) # 80003872 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a34:	08848493          	addi	s1,s1,136
    80002a38:	ff3498e3          	bne	s1,s3,80002a28 <iinit+0x3e>
}
    80002a3c:	70a2                	ld	ra,40(sp)
    80002a3e:	7402                	ld	s0,32(sp)
    80002a40:	64e2                	ld	s1,24(sp)
    80002a42:	6942                	ld	s2,16(sp)
    80002a44:	69a2                	ld	s3,8(sp)
    80002a46:	6145                	addi	sp,sp,48
    80002a48:	8082                	ret

0000000080002a4a <ialloc>:
{
    80002a4a:	715d                	addi	sp,sp,-80
    80002a4c:	e486                	sd	ra,72(sp)
    80002a4e:	e0a2                	sd	s0,64(sp)
    80002a50:	fc26                	sd	s1,56(sp)
    80002a52:	f84a                	sd	s2,48(sp)
    80002a54:	f44e                	sd	s3,40(sp)
    80002a56:	f052                	sd	s4,32(sp)
    80002a58:	ec56                	sd	s5,24(sp)
    80002a5a:	e85a                	sd	s6,16(sp)
    80002a5c:	e45e                	sd	s7,8(sp)
    80002a5e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a60:	00015717          	auipc	a4,0x15
    80002a64:	d0472703          	lw	a4,-764(a4) # 80017764 <sb+0xc>
    80002a68:	4785                	li	a5,1
    80002a6a:	04e7fa63          	bgeu	a5,a4,80002abe <ialloc+0x74>
    80002a6e:	8aaa                	mv	s5,a0
    80002a70:	8bae                	mv	s7,a1
    80002a72:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a74:	00015a17          	auipc	s4,0x15
    80002a78:	ce4a0a13          	addi	s4,s4,-796 # 80017758 <sb>
    80002a7c:	00048b1b          	sext.w	s6,s1
    80002a80:	0044d593          	srli	a1,s1,0x4
    80002a84:	018a2783          	lw	a5,24(s4)
    80002a88:	9dbd                	addw	a1,a1,a5
    80002a8a:	8556                	mv	a0,s5
    80002a8c:	00000097          	auipc	ra,0x0
    80002a90:	954080e7          	jalr	-1708(ra) # 800023e0 <bread>
    80002a94:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a96:	05850993          	addi	s3,a0,88
    80002a9a:	00f4f793          	andi	a5,s1,15
    80002a9e:	079a                	slli	a5,a5,0x6
    80002aa0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aa2:	00099783          	lh	a5,0(s3)
    80002aa6:	c785                	beqz	a5,80002ace <ialloc+0x84>
    brelse(bp);
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	a68080e7          	jalr	-1432(ra) # 80002510 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab0:	0485                	addi	s1,s1,1
    80002ab2:	00ca2703          	lw	a4,12(s4)
    80002ab6:	0004879b          	sext.w	a5,s1
    80002aba:	fce7e1e3          	bltu	a5,a4,80002a7c <ialloc+0x32>
  panic("ialloc: no inodes");
    80002abe:	00006517          	auipc	a0,0x6
    80002ac2:	b4a50513          	addi	a0,a0,-1206 # 80008608 <syscalls+0x178>
    80002ac6:	00003097          	auipc	ra,0x3
    80002aca:	1d2080e7          	jalr	466(ra) # 80005c98 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ace:	04000613          	li	a2,64
    80002ad2:	4581                	li	a1,0
    80002ad4:	854e                	mv	a0,s3
    80002ad6:	ffffd097          	auipc	ra,0xffffd
    80002ada:	6ec080e7          	jalr	1772(ra) # 800001c2 <memset>
      dip->type = type;
    80002ade:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ae2:	854a                	mv	a0,s2
    80002ae4:	00001097          	auipc	ra,0x1
    80002ae8:	ca8080e7          	jalr	-856(ra) # 8000378c <log_write>
      brelse(bp);
    80002aec:	854a                	mv	a0,s2
    80002aee:	00000097          	auipc	ra,0x0
    80002af2:	a22080e7          	jalr	-1502(ra) # 80002510 <brelse>
      return iget(dev, inum);
    80002af6:	85da                	mv	a1,s6
    80002af8:	8556                	mv	a0,s5
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	db4080e7          	jalr	-588(ra) # 800028ae <iget>
}
    80002b02:	60a6                	ld	ra,72(sp)
    80002b04:	6406                	ld	s0,64(sp)
    80002b06:	74e2                	ld	s1,56(sp)
    80002b08:	7942                	ld	s2,48(sp)
    80002b0a:	79a2                	ld	s3,40(sp)
    80002b0c:	7a02                	ld	s4,32(sp)
    80002b0e:	6ae2                	ld	s5,24(sp)
    80002b10:	6b42                	ld	s6,16(sp)
    80002b12:	6ba2                	ld	s7,8(sp)
    80002b14:	6161                	addi	sp,sp,80
    80002b16:	8082                	ret

0000000080002b18 <iupdate>:
{
    80002b18:	1101                	addi	sp,sp,-32
    80002b1a:	ec06                	sd	ra,24(sp)
    80002b1c:	e822                	sd	s0,16(sp)
    80002b1e:	e426                	sd	s1,8(sp)
    80002b20:	e04a                	sd	s2,0(sp)
    80002b22:	1000                	addi	s0,sp,32
    80002b24:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b26:	415c                	lw	a5,4(a0)
    80002b28:	0047d79b          	srliw	a5,a5,0x4
    80002b2c:	00015597          	auipc	a1,0x15
    80002b30:	c445a583          	lw	a1,-956(a1) # 80017770 <sb+0x18>
    80002b34:	9dbd                	addw	a1,a1,a5
    80002b36:	4108                	lw	a0,0(a0)
    80002b38:	00000097          	auipc	ra,0x0
    80002b3c:	8a8080e7          	jalr	-1880(ra) # 800023e0 <bread>
    80002b40:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b42:	05850793          	addi	a5,a0,88
    80002b46:	40c8                	lw	a0,4(s1)
    80002b48:	893d                	andi	a0,a0,15
    80002b4a:	051a                	slli	a0,a0,0x6
    80002b4c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b4e:	04449703          	lh	a4,68(s1)
    80002b52:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b56:	04649703          	lh	a4,70(s1)
    80002b5a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b5e:	04849703          	lh	a4,72(s1)
    80002b62:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b66:	04a49703          	lh	a4,74(s1)
    80002b6a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b6e:	44f8                	lw	a4,76(s1)
    80002b70:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b72:	03400613          	li	a2,52
    80002b76:	05048593          	addi	a1,s1,80
    80002b7a:	0531                	addi	a0,a0,12
    80002b7c:	ffffd097          	auipc	ra,0xffffd
    80002b80:	6a6080e7          	jalr	1702(ra) # 80000222 <memmove>
  log_write(bp);
    80002b84:	854a                	mv	a0,s2
    80002b86:	00001097          	auipc	ra,0x1
    80002b8a:	c06080e7          	jalr	-1018(ra) # 8000378c <log_write>
  brelse(bp);
    80002b8e:	854a                	mv	a0,s2
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	980080e7          	jalr	-1664(ra) # 80002510 <brelse>
}
    80002b98:	60e2                	ld	ra,24(sp)
    80002b9a:	6442                	ld	s0,16(sp)
    80002b9c:	64a2                	ld	s1,8(sp)
    80002b9e:	6902                	ld	s2,0(sp)
    80002ba0:	6105                	addi	sp,sp,32
    80002ba2:	8082                	ret

0000000080002ba4 <idup>:
{
    80002ba4:	1101                	addi	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	e426                	sd	s1,8(sp)
    80002bac:	1000                	addi	s0,sp,32
    80002bae:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bb0:	00015517          	auipc	a0,0x15
    80002bb4:	bc850513          	addi	a0,a0,-1080 # 80017778 <itable>
    80002bb8:	00003097          	auipc	ra,0x3
    80002bbc:	62a080e7          	jalr	1578(ra) # 800061e2 <acquire>
  ip->ref++;
    80002bc0:	449c                	lw	a5,8(s1)
    80002bc2:	2785                	addiw	a5,a5,1
    80002bc4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bc6:	00015517          	auipc	a0,0x15
    80002bca:	bb250513          	addi	a0,a0,-1102 # 80017778 <itable>
    80002bce:	00003097          	auipc	ra,0x3
    80002bd2:	6c8080e7          	jalr	1736(ra) # 80006296 <release>
}
    80002bd6:	8526                	mv	a0,s1
    80002bd8:	60e2                	ld	ra,24(sp)
    80002bda:	6442                	ld	s0,16(sp)
    80002bdc:	64a2                	ld	s1,8(sp)
    80002bde:	6105                	addi	sp,sp,32
    80002be0:	8082                	ret

0000000080002be2 <ilock>:
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	e04a                	sd	s2,0(sp)
    80002bec:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bee:	c115                	beqz	a0,80002c12 <ilock+0x30>
    80002bf0:	84aa                	mv	s1,a0
    80002bf2:	451c                	lw	a5,8(a0)
    80002bf4:	00f05f63          	blez	a5,80002c12 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bf8:	0541                	addi	a0,a0,16
    80002bfa:	00001097          	auipc	ra,0x1
    80002bfe:	cb2080e7          	jalr	-846(ra) # 800038ac <acquiresleep>
  if(ip->valid == 0){
    80002c02:	40bc                	lw	a5,64(s1)
    80002c04:	cf99                	beqz	a5,80002c22 <ilock+0x40>
}
    80002c06:	60e2                	ld	ra,24(sp)
    80002c08:	6442                	ld	s0,16(sp)
    80002c0a:	64a2                	ld	s1,8(sp)
    80002c0c:	6902                	ld	s2,0(sp)
    80002c0e:	6105                	addi	sp,sp,32
    80002c10:	8082                	ret
    panic("ilock");
    80002c12:	00006517          	auipc	a0,0x6
    80002c16:	a0e50513          	addi	a0,a0,-1522 # 80008620 <syscalls+0x190>
    80002c1a:	00003097          	auipc	ra,0x3
    80002c1e:	07e080e7          	jalr	126(ra) # 80005c98 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c22:	40dc                	lw	a5,4(s1)
    80002c24:	0047d79b          	srliw	a5,a5,0x4
    80002c28:	00015597          	auipc	a1,0x15
    80002c2c:	b485a583          	lw	a1,-1208(a1) # 80017770 <sb+0x18>
    80002c30:	9dbd                	addw	a1,a1,a5
    80002c32:	4088                	lw	a0,0(s1)
    80002c34:	fffff097          	auipc	ra,0xfffff
    80002c38:	7ac080e7          	jalr	1964(ra) # 800023e0 <bread>
    80002c3c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c3e:	05850593          	addi	a1,a0,88
    80002c42:	40dc                	lw	a5,4(s1)
    80002c44:	8bbd                	andi	a5,a5,15
    80002c46:	079a                	slli	a5,a5,0x6
    80002c48:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c4a:	00059783          	lh	a5,0(a1)
    80002c4e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c52:	00259783          	lh	a5,2(a1)
    80002c56:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c5a:	00459783          	lh	a5,4(a1)
    80002c5e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c62:	00659783          	lh	a5,6(a1)
    80002c66:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c6a:	459c                	lw	a5,8(a1)
    80002c6c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c6e:	03400613          	li	a2,52
    80002c72:	05b1                	addi	a1,a1,12
    80002c74:	05048513          	addi	a0,s1,80
    80002c78:	ffffd097          	auipc	ra,0xffffd
    80002c7c:	5aa080e7          	jalr	1450(ra) # 80000222 <memmove>
    brelse(bp);
    80002c80:	854a                	mv	a0,s2
    80002c82:	00000097          	auipc	ra,0x0
    80002c86:	88e080e7          	jalr	-1906(ra) # 80002510 <brelse>
    ip->valid = 1;
    80002c8a:	4785                	li	a5,1
    80002c8c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c8e:	04449783          	lh	a5,68(s1)
    80002c92:	fbb5                	bnez	a5,80002c06 <ilock+0x24>
      panic("ilock: no type");
    80002c94:	00006517          	auipc	a0,0x6
    80002c98:	99450513          	addi	a0,a0,-1644 # 80008628 <syscalls+0x198>
    80002c9c:	00003097          	auipc	ra,0x3
    80002ca0:	ffc080e7          	jalr	-4(ra) # 80005c98 <panic>

0000000080002ca4 <iunlock>:
{
    80002ca4:	1101                	addi	sp,sp,-32
    80002ca6:	ec06                	sd	ra,24(sp)
    80002ca8:	e822                	sd	s0,16(sp)
    80002caa:	e426                	sd	s1,8(sp)
    80002cac:	e04a                	sd	s2,0(sp)
    80002cae:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cb0:	c905                	beqz	a0,80002ce0 <iunlock+0x3c>
    80002cb2:	84aa                	mv	s1,a0
    80002cb4:	01050913          	addi	s2,a0,16
    80002cb8:	854a                	mv	a0,s2
    80002cba:	00001097          	auipc	ra,0x1
    80002cbe:	c8c080e7          	jalr	-884(ra) # 80003946 <holdingsleep>
    80002cc2:	cd19                	beqz	a0,80002ce0 <iunlock+0x3c>
    80002cc4:	449c                	lw	a5,8(s1)
    80002cc6:	00f05d63          	blez	a5,80002ce0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cca:	854a                	mv	a0,s2
    80002ccc:	00001097          	auipc	ra,0x1
    80002cd0:	c36080e7          	jalr	-970(ra) # 80003902 <releasesleep>
}
    80002cd4:	60e2                	ld	ra,24(sp)
    80002cd6:	6442                	ld	s0,16(sp)
    80002cd8:	64a2                	ld	s1,8(sp)
    80002cda:	6902                	ld	s2,0(sp)
    80002cdc:	6105                	addi	sp,sp,32
    80002cde:	8082                	ret
    panic("iunlock");
    80002ce0:	00006517          	auipc	a0,0x6
    80002ce4:	95850513          	addi	a0,a0,-1704 # 80008638 <syscalls+0x1a8>
    80002ce8:	00003097          	auipc	ra,0x3
    80002cec:	fb0080e7          	jalr	-80(ra) # 80005c98 <panic>

0000000080002cf0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cf0:	7179                	addi	sp,sp,-48
    80002cf2:	f406                	sd	ra,40(sp)
    80002cf4:	f022                	sd	s0,32(sp)
    80002cf6:	ec26                	sd	s1,24(sp)
    80002cf8:	e84a                	sd	s2,16(sp)
    80002cfa:	e44e                	sd	s3,8(sp)
    80002cfc:	e052                	sd	s4,0(sp)
    80002cfe:	1800                	addi	s0,sp,48
    80002d00:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d02:	05050493          	addi	s1,a0,80
    80002d06:	08050913          	addi	s2,a0,128
    80002d0a:	a021                	j	80002d12 <itrunc+0x22>
    80002d0c:	0491                	addi	s1,s1,4
    80002d0e:	01248d63          	beq	s1,s2,80002d28 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d12:	408c                	lw	a1,0(s1)
    80002d14:	dde5                	beqz	a1,80002d0c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d16:	0009a503          	lw	a0,0(s3)
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	90c080e7          	jalr	-1780(ra) # 80002626 <bfree>
      ip->addrs[i] = 0;
    80002d22:	0004a023          	sw	zero,0(s1)
    80002d26:	b7dd                	j	80002d0c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d28:	0809a583          	lw	a1,128(s3)
    80002d2c:	e185                	bnez	a1,80002d4c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d2e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d32:	854e                	mv	a0,s3
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	de4080e7          	jalr	-540(ra) # 80002b18 <iupdate>
}
    80002d3c:	70a2                	ld	ra,40(sp)
    80002d3e:	7402                	ld	s0,32(sp)
    80002d40:	64e2                	ld	s1,24(sp)
    80002d42:	6942                	ld	s2,16(sp)
    80002d44:	69a2                	ld	s3,8(sp)
    80002d46:	6a02                	ld	s4,0(sp)
    80002d48:	6145                	addi	sp,sp,48
    80002d4a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d4c:	0009a503          	lw	a0,0(s3)
    80002d50:	fffff097          	auipc	ra,0xfffff
    80002d54:	690080e7          	jalr	1680(ra) # 800023e0 <bread>
    80002d58:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d5a:	05850493          	addi	s1,a0,88
    80002d5e:	45850913          	addi	s2,a0,1112
    80002d62:	a811                	j	80002d76 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d64:	0009a503          	lw	a0,0(s3)
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	8be080e7          	jalr	-1858(ra) # 80002626 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d70:	0491                	addi	s1,s1,4
    80002d72:	01248563          	beq	s1,s2,80002d7c <itrunc+0x8c>
      if(a[j])
    80002d76:	408c                	lw	a1,0(s1)
    80002d78:	dde5                	beqz	a1,80002d70 <itrunc+0x80>
    80002d7a:	b7ed                	j	80002d64 <itrunc+0x74>
    brelse(bp);
    80002d7c:	8552                	mv	a0,s4
    80002d7e:	fffff097          	auipc	ra,0xfffff
    80002d82:	792080e7          	jalr	1938(ra) # 80002510 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d86:	0809a583          	lw	a1,128(s3)
    80002d8a:	0009a503          	lw	a0,0(s3)
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	898080e7          	jalr	-1896(ra) # 80002626 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d96:	0809a023          	sw	zero,128(s3)
    80002d9a:	bf51                	j	80002d2e <itrunc+0x3e>

0000000080002d9c <iput>:
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	e426                	sd	s1,8(sp)
    80002da4:	e04a                	sd	s2,0(sp)
    80002da6:	1000                	addi	s0,sp,32
    80002da8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002daa:	00015517          	auipc	a0,0x15
    80002dae:	9ce50513          	addi	a0,a0,-1586 # 80017778 <itable>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	430080e7          	jalr	1072(ra) # 800061e2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dba:	4498                	lw	a4,8(s1)
    80002dbc:	4785                	li	a5,1
    80002dbe:	02f70363          	beq	a4,a5,80002de4 <iput+0x48>
  ip->ref--;
    80002dc2:	449c                	lw	a5,8(s1)
    80002dc4:	37fd                	addiw	a5,a5,-1
    80002dc6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dc8:	00015517          	auipc	a0,0x15
    80002dcc:	9b050513          	addi	a0,a0,-1616 # 80017778 <itable>
    80002dd0:	00003097          	auipc	ra,0x3
    80002dd4:	4c6080e7          	jalr	1222(ra) # 80006296 <release>
}
    80002dd8:	60e2                	ld	ra,24(sp)
    80002dda:	6442                	ld	s0,16(sp)
    80002ddc:	64a2                	ld	s1,8(sp)
    80002dde:	6902                	ld	s2,0(sp)
    80002de0:	6105                	addi	sp,sp,32
    80002de2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002de4:	40bc                	lw	a5,64(s1)
    80002de6:	dff1                	beqz	a5,80002dc2 <iput+0x26>
    80002de8:	04a49783          	lh	a5,74(s1)
    80002dec:	fbf9                	bnez	a5,80002dc2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dee:	01048913          	addi	s2,s1,16
    80002df2:	854a                	mv	a0,s2
    80002df4:	00001097          	auipc	ra,0x1
    80002df8:	ab8080e7          	jalr	-1352(ra) # 800038ac <acquiresleep>
    release(&itable.lock);
    80002dfc:	00015517          	auipc	a0,0x15
    80002e00:	97c50513          	addi	a0,a0,-1668 # 80017778 <itable>
    80002e04:	00003097          	auipc	ra,0x3
    80002e08:	492080e7          	jalr	1170(ra) # 80006296 <release>
    itrunc(ip);
    80002e0c:	8526                	mv	a0,s1
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	ee2080e7          	jalr	-286(ra) # 80002cf0 <itrunc>
    ip->type = 0;
    80002e16:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e1a:	8526                	mv	a0,s1
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	cfc080e7          	jalr	-772(ra) # 80002b18 <iupdate>
    ip->valid = 0;
    80002e24:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e28:	854a                	mv	a0,s2
    80002e2a:	00001097          	auipc	ra,0x1
    80002e2e:	ad8080e7          	jalr	-1320(ra) # 80003902 <releasesleep>
    acquire(&itable.lock);
    80002e32:	00015517          	auipc	a0,0x15
    80002e36:	94650513          	addi	a0,a0,-1722 # 80017778 <itable>
    80002e3a:	00003097          	auipc	ra,0x3
    80002e3e:	3a8080e7          	jalr	936(ra) # 800061e2 <acquire>
    80002e42:	b741                	j	80002dc2 <iput+0x26>

0000000080002e44 <iunlockput>:
{
    80002e44:	1101                	addi	sp,sp,-32
    80002e46:	ec06                	sd	ra,24(sp)
    80002e48:	e822                	sd	s0,16(sp)
    80002e4a:	e426                	sd	s1,8(sp)
    80002e4c:	1000                	addi	s0,sp,32
    80002e4e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e50:	00000097          	auipc	ra,0x0
    80002e54:	e54080e7          	jalr	-428(ra) # 80002ca4 <iunlock>
  iput(ip);
    80002e58:	8526                	mv	a0,s1
    80002e5a:	00000097          	auipc	ra,0x0
    80002e5e:	f42080e7          	jalr	-190(ra) # 80002d9c <iput>
}
    80002e62:	60e2                	ld	ra,24(sp)
    80002e64:	6442                	ld	s0,16(sp)
    80002e66:	64a2                	ld	s1,8(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret

0000000080002e6c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e6c:	1141                	addi	sp,sp,-16
    80002e6e:	e422                	sd	s0,8(sp)
    80002e70:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e72:	411c                	lw	a5,0(a0)
    80002e74:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e76:	415c                	lw	a5,4(a0)
    80002e78:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e7a:	04451783          	lh	a5,68(a0)
    80002e7e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e82:	04a51783          	lh	a5,74(a0)
    80002e86:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e8a:	04c56783          	lwu	a5,76(a0)
    80002e8e:	e99c                	sd	a5,16(a1)
}
    80002e90:	6422                	ld	s0,8(sp)
    80002e92:	0141                	addi	sp,sp,16
    80002e94:	8082                	ret

0000000080002e96 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e96:	457c                	lw	a5,76(a0)
    80002e98:	0ed7e963          	bltu	a5,a3,80002f8a <readi+0xf4>
{
    80002e9c:	7159                	addi	sp,sp,-112
    80002e9e:	f486                	sd	ra,104(sp)
    80002ea0:	f0a2                	sd	s0,96(sp)
    80002ea2:	eca6                	sd	s1,88(sp)
    80002ea4:	e8ca                	sd	s2,80(sp)
    80002ea6:	e4ce                	sd	s3,72(sp)
    80002ea8:	e0d2                	sd	s4,64(sp)
    80002eaa:	fc56                	sd	s5,56(sp)
    80002eac:	f85a                	sd	s6,48(sp)
    80002eae:	f45e                	sd	s7,40(sp)
    80002eb0:	f062                	sd	s8,32(sp)
    80002eb2:	ec66                	sd	s9,24(sp)
    80002eb4:	e86a                	sd	s10,16(sp)
    80002eb6:	e46e                	sd	s11,8(sp)
    80002eb8:	1880                	addi	s0,sp,112
    80002eba:	8baa                	mv	s7,a0
    80002ebc:	8c2e                	mv	s8,a1
    80002ebe:	8ab2                	mv	s5,a2
    80002ec0:	84b6                	mv	s1,a3
    80002ec2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec4:	9f35                	addw	a4,a4,a3
    return 0;
    80002ec6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ec8:	0ad76063          	bltu	a4,a3,80002f68 <readi+0xd2>
  if(off + n > ip->size)
    80002ecc:	00e7f463          	bgeu	a5,a4,80002ed4 <readi+0x3e>
    n = ip->size - off;
    80002ed0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed4:	0a0b0963          	beqz	s6,80002f86 <readi+0xf0>
    80002ed8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eda:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ede:	5cfd                	li	s9,-1
    80002ee0:	a82d                	j	80002f1a <readi+0x84>
    80002ee2:	020a1d93          	slli	s11,s4,0x20
    80002ee6:	020ddd93          	srli	s11,s11,0x20
    80002eea:	05890613          	addi	a2,s2,88
    80002eee:	86ee                	mv	a3,s11
    80002ef0:	963a                	add	a2,a2,a4
    80002ef2:	85d6                	mv	a1,s5
    80002ef4:	8562                	mv	a0,s8
    80002ef6:	fffff097          	auipc	ra,0xfffff
    80002efa:	a04080e7          	jalr	-1532(ra) # 800018fa <either_copyout>
    80002efe:	05950d63          	beq	a0,s9,80002f58 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f02:	854a                	mv	a0,s2
    80002f04:	fffff097          	auipc	ra,0xfffff
    80002f08:	60c080e7          	jalr	1548(ra) # 80002510 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f0c:	013a09bb          	addw	s3,s4,s3
    80002f10:	009a04bb          	addw	s1,s4,s1
    80002f14:	9aee                	add	s5,s5,s11
    80002f16:	0569f763          	bgeu	s3,s6,80002f64 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f1a:	000ba903          	lw	s2,0(s7)
    80002f1e:	00a4d59b          	srliw	a1,s1,0xa
    80002f22:	855e                	mv	a0,s7
    80002f24:	00000097          	auipc	ra,0x0
    80002f28:	8b0080e7          	jalr	-1872(ra) # 800027d4 <bmap>
    80002f2c:	0005059b          	sext.w	a1,a0
    80002f30:	854a                	mv	a0,s2
    80002f32:	fffff097          	auipc	ra,0xfffff
    80002f36:	4ae080e7          	jalr	1198(ra) # 800023e0 <bread>
    80002f3a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3c:	3ff4f713          	andi	a4,s1,1023
    80002f40:	40ed07bb          	subw	a5,s10,a4
    80002f44:	413b06bb          	subw	a3,s6,s3
    80002f48:	8a3e                	mv	s4,a5
    80002f4a:	2781                	sext.w	a5,a5
    80002f4c:	0006861b          	sext.w	a2,a3
    80002f50:	f8f679e3          	bgeu	a2,a5,80002ee2 <readi+0x4c>
    80002f54:	8a36                	mv	s4,a3
    80002f56:	b771                	j	80002ee2 <readi+0x4c>
      brelse(bp);
    80002f58:	854a                	mv	a0,s2
    80002f5a:	fffff097          	auipc	ra,0xfffff
    80002f5e:	5b6080e7          	jalr	1462(ra) # 80002510 <brelse>
      tot = -1;
    80002f62:	59fd                	li	s3,-1
  }
  return tot;
    80002f64:	0009851b          	sext.w	a0,s3
}
    80002f68:	70a6                	ld	ra,104(sp)
    80002f6a:	7406                	ld	s0,96(sp)
    80002f6c:	64e6                	ld	s1,88(sp)
    80002f6e:	6946                	ld	s2,80(sp)
    80002f70:	69a6                	ld	s3,72(sp)
    80002f72:	6a06                	ld	s4,64(sp)
    80002f74:	7ae2                	ld	s5,56(sp)
    80002f76:	7b42                	ld	s6,48(sp)
    80002f78:	7ba2                	ld	s7,40(sp)
    80002f7a:	7c02                	ld	s8,32(sp)
    80002f7c:	6ce2                	ld	s9,24(sp)
    80002f7e:	6d42                	ld	s10,16(sp)
    80002f80:	6da2                	ld	s11,8(sp)
    80002f82:	6165                	addi	sp,sp,112
    80002f84:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f86:	89da                	mv	s3,s6
    80002f88:	bff1                	j	80002f64 <readi+0xce>
    return 0;
    80002f8a:	4501                	li	a0,0
}
    80002f8c:	8082                	ret

0000000080002f8e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f8e:	457c                	lw	a5,76(a0)
    80002f90:	10d7e863          	bltu	a5,a3,800030a0 <writei+0x112>
{
    80002f94:	7159                	addi	sp,sp,-112
    80002f96:	f486                	sd	ra,104(sp)
    80002f98:	f0a2                	sd	s0,96(sp)
    80002f9a:	eca6                	sd	s1,88(sp)
    80002f9c:	e8ca                	sd	s2,80(sp)
    80002f9e:	e4ce                	sd	s3,72(sp)
    80002fa0:	e0d2                	sd	s4,64(sp)
    80002fa2:	fc56                	sd	s5,56(sp)
    80002fa4:	f85a                	sd	s6,48(sp)
    80002fa6:	f45e                	sd	s7,40(sp)
    80002fa8:	f062                	sd	s8,32(sp)
    80002faa:	ec66                	sd	s9,24(sp)
    80002fac:	e86a                	sd	s10,16(sp)
    80002fae:	e46e                	sd	s11,8(sp)
    80002fb0:	1880                	addi	s0,sp,112
    80002fb2:	8b2a                	mv	s6,a0
    80002fb4:	8c2e                	mv	s8,a1
    80002fb6:	8ab2                	mv	s5,a2
    80002fb8:	8936                	mv	s2,a3
    80002fba:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fbc:	00e687bb          	addw	a5,a3,a4
    80002fc0:	0ed7e263          	bltu	a5,a3,800030a4 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fc4:	00043737          	lui	a4,0x43
    80002fc8:	0ef76063          	bltu	a4,a5,800030a8 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fcc:	0c0b8863          	beqz	s7,8000309c <writei+0x10e>
    80002fd0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fd6:	5cfd                	li	s9,-1
    80002fd8:	a091                	j	8000301c <writei+0x8e>
    80002fda:	02099d93          	slli	s11,s3,0x20
    80002fde:	020ddd93          	srli	s11,s11,0x20
    80002fe2:	05848513          	addi	a0,s1,88
    80002fe6:	86ee                	mv	a3,s11
    80002fe8:	8656                	mv	a2,s5
    80002fea:	85e2                	mv	a1,s8
    80002fec:	953a                	add	a0,a0,a4
    80002fee:	fffff097          	auipc	ra,0xfffff
    80002ff2:	962080e7          	jalr	-1694(ra) # 80001950 <either_copyin>
    80002ff6:	07950263          	beq	a0,s9,8000305a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ffa:	8526                	mv	a0,s1
    80002ffc:	00000097          	auipc	ra,0x0
    80003000:	790080e7          	jalr	1936(ra) # 8000378c <log_write>
    brelse(bp);
    80003004:	8526                	mv	a0,s1
    80003006:	fffff097          	auipc	ra,0xfffff
    8000300a:	50a080e7          	jalr	1290(ra) # 80002510 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000300e:	01498a3b          	addw	s4,s3,s4
    80003012:	0129893b          	addw	s2,s3,s2
    80003016:	9aee                	add	s5,s5,s11
    80003018:	057a7663          	bgeu	s4,s7,80003064 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000301c:	000b2483          	lw	s1,0(s6)
    80003020:	00a9559b          	srliw	a1,s2,0xa
    80003024:	855a                	mv	a0,s6
    80003026:	fffff097          	auipc	ra,0xfffff
    8000302a:	7ae080e7          	jalr	1966(ra) # 800027d4 <bmap>
    8000302e:	0005059b          	sext.w	a1,a0
    80003032:	8526                	mv	a0,s1
    80003034:	fffff097          	auipc	ra,0xfffff
    80003038:	3ac080e7          	jalr	940(ra) # 800023e0 <bread>
    8000303c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000303e:	3ff97713          	andi	a4,s2,1023
    80003042:	40ed07bb          	subw	a5,s10,a4
    80003046:	414b86bb          	subw	a3,s7,s4
    8000304a:	89be                	mv	s3,a5
    8000304c:	2781                	sext.w	a5,a5
    8000304e:	0006861b          	sext.w	a2,a3
    80003052:	f8f674e3          	bgeu	a2,a5,80002fda <writei+0x4c>
    80003056:	89b6                	mv	s3,a3
    80003058:	b749                	j	80002fda <writei+0x4c>
      brelse(bp);
    8000305a:	8526                	mv	a0,s1
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	4b4080e7          	jalr	1204(ra) # 80002510 <brelse>
  }

  if(off > ip->size)
    80003064:	04cb2783          	lw	a5,76(s6)
    80003068:	0127f463          	bgeu	a5,s2,80003070 <writei+0xe2>
    ip->size = off;
    8000306c:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003070:	855a                	mv	a0,s6
    80003072:	00000097          	auipc	ra,0x0
    80003076:	aa6080e7          	jalr	-1370(ra) # 80002b18 <iupdate>

  return tot;
    8000307a:	000a051b          	sext.w	a0,s4
}
    8000307e:	70a6                	ld	ra,104(sp)
    80003080:	7406                	ld	s0,96(sp)
    80003082:	64e6                	ld	s1,88(sp)
    80003084:	6946                	ld	s2,80(sp)
    80003086:	69a6                	ld	s3,72(sp)
    80003088:	6a06                	ld	s4,64(sp)
    8000308a:	7ae2                	ld	s5,56(sp)
    8000308c:	7b42                	ld	s6,48(sp)
    8000308e:	7ba2                	ld	s7,40(sp)
    80003090:	7c02                	ld	s8,32(sp)
    80003092:	6ce2                	ld	s9,24(sp)
    80003094:	6d42                	ld	s10,16(sp)
    80003096:	6da2                	ld	s11,8(sp)
    80003098:	6165                	addi	sp,sp,112
    8000309a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000309c:	8a5e                	mv	s4,s7
    8000309e:	bfc9                	j	80003070 <writei+0xe2>
    return -1;
    800030a0:	557d                	li	a0,-1
}
    800030a2:	8082                	ret
    return -1;
    800030a4:	557d                	li	a0,-1
    800030a6:	bfe1                	j	8000307e <writei+0xf0>
    return -1;
    800030a8:	557d                	li	a0,-1
    800030aa:	bfd1                	j	8000307e <writei+0xf0>

00000000800030ac <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030ac:	1141                	addi	sp,sp,-16
    800030ae:	e406                	sd	ra,8(sp)
    800030b0:	e022                	sd	s0,0(sp)
    800030b2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030b4:	4639                	li	a2,14
    800030b6:	ffffd097          	auipc	ra,0xffffd
    800030ba:	1e4080e7          	jalr	484(ra) # 8000029a <strncmp>
}
    800030be:	60a2                	ld	ra,8(sp)
    800030c0:	6402                	ld	s0,0(sp)
    800030c2:	0141                	addi	sp,sp,16
    800030c4:	8082                	ret

00000000800030c6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030c6:	7139                	addi	sp,sp,-64
    800030c8:	fc06                	sd	ra,56(sp)
    800030ca:	f822                	sd	s0,48(sp)
    800030cc:	f426                	sd	s1,40(sp)
    800030ce:	f04a                	sd	s2,32(sp)
    800030d0:	ec4e                	sd	s3,24(sp)
    800030d2:	e852                	sd	s4,16(sp)
    800030d4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030d6:	04451703          	lh	a4,68(a0)
    800030da:	4785                	li	a5,1
    800030dc:	00f71a63          	bne	a4,a5,800030f0 <dirlookup+0x2a>
    800030e0:	892a                	mv	s2,a0
    800030e2:	89ae                	mv	s3,a1
    800030e4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e6:	457c                	lw	a5,76(a0)
    800030e8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ea:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ec:	e79d                	bnez	a5,8000311a <dirlookup+0x54>
    800030ee:	a8a5                	j	80003166 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030f0:	00005517          	auipc	a0,0x5
    800030f4:	55050513          	addi	a0,a0,1360 # 80008640 <syscalls+0x1b0>
    800030f8:	00003097          	auipc	ra,0x3
    800030fc:	ba0080e7          	jalr	-1120(ra) # 80005c98 <panic>
      panic("dirlookup read");
    80003100:	00005517          	auipc	a0,0x5
    80003104:	55850513          	addi	a0,a0,1368 # 80008658 <syscalls+0x1c8>
    80003108:	00003097          	auipc	ra,0x3
    8000310c:	b90080e7          	jalr	-1136(ra) # 80005c98 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003110:	24c1                	addiw	s1,s1,16
    80003112:	04c92783          	lw	a5,76(s2)
    80003116:	04f4f763          	bgeu	s1,a5,80003164 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000311a:	4741                	li	a4,16
    8000311c:	86a6                	mv	a3,s1
    8000311e:	fc040613          	addi	a2,s0,-64
    80003122:	4581                	li	a1,0
    80003124:	854a                	mv	a0,s2
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	d70080e7          	jalr	-656(ra) # 80002e96 <readi>
    8000312e:	47c1                	li	a5,16
    80003130:	fcf518e3          	bne	a0,a5,80003100 <dirlookup+0x3a>
    if(de.inum == 0)
    80003134:	fc045783          	lhu	a5,-64(s0)
    80003138:	dfe1                	beqz	a5,80003110 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000313a:	fc240593          	addi	a1,s0,-62
    8000313e:	854e                	mv	a0,s3
    80003140:	00000097          	auipc	ra,0x0
    80003144:	f6c080e7          	jalr	-148(ra) # 800030ac <namecmp>
    80003148:	f561                	bnez	a0,80003110 <dirlookup+0x4a>
      if(poff)
    8000314a:	000a0463          	beqz	s4,80003152 <dirlookup+0x8c>
        *poff = off;
    8000314e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003152:	fc045583          	lhu	a1,-64(s0)
    80003156:	00092503          	lw	a0,0(s2)
    8000315a:	fffff097          	auipc	ra,0xfffff
    8000315e:	754080e7          	jalr	1876(ra) # 800028ae <iget>
    80003162:	a011                	j	80003166 <dirlookup+0xa0>
  return 0;
    80003164:	4501                	li	a0,0
}
    80003166:	70e2                	ld	ra,56(sp)
    80003168:	7442                	ld	s0,48(sp)
    8000316a:	74a2                	ld	s1,40(sp)
    8000316c:	7902                	ld	s2,32(sp)
    8000316e:	69e2                	ld	s3,24(sp)
    80003170:	6a42                	ld	s4,16(sp)
    80003172:	6121                	addi	sp,sp,64
    80003174:	8082                	ret

0000000080003176 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003176:	711d                	addi	sp,sp,-96
    80003178:	ec86                	sd	ra,88(sp)
    8000317a:	e8a2                	sd	s0,80(sp)
    8000317c:	e4a6                	sd	s1,72(sp)
    8000317e:	e0ca                	sd	s2,64(sp)
    80003180:	fc4e                	sd	s3,56(sp)
    80003182:	f852                	sd	s4,48(sp)
    80003184:	f456                	sd	s5,40(sp)
    80003186:	f05a                	sd	s6,32(sp)
    80003188:	ec5e                	sd	s7,24(sp)
    8000318a:	e862                	sd	s8,16(sp)
    8000318c:	e466                	sd	s9,8(sp)
    8000318e:	1080                	addi	s0,sp,96
    80003190:	84aa                	mv	s1,a0
    80003192:	8b2e                	mv	s6,a1
    80003194:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003196:	00054703          	lbu	a4,0(a0)
    8000319a:	02f00793          	li	a5,47
    8000319e:	02f70363          	beq	a4,a5,800031c4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031a2:	ffffe097          	auipc	ra,0xffffe
    800031a6:	cf0080e7          	jalr	-784(ra) # 80000e92 <myproc>
    800031aa:	15853503          	ld	a0,344(a0)
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	9f6080e7          	jalr	-1546(ra) # 80002ba4 <idup>
    800031b6:	89aa                	mv	s3,a0
  while(*path == '/')
    800031b8:	02f00913          	li	s2,47
  len = path - s;
    800031bc:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031be:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031c0:	4c05                	li	s8,1
    800031c2:	a865                	j	8000327a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031c4:	4585                	li	a1,1
    800031c6:	4505                	li	a0,1
    800031c8:	fffff097          	auipc	ra,0xfffff
    800031cc:	6e6080e7          	jalr	1766(ra) # 800028ae <iget>
    800031d0:	89aa                	mv	s3,a0
    800031d2:	b7dd                	j	800031b8 <namex+0x42>
      iunlockput(ip);
    800031d4:	854e                	mv	a0,s3
    800031d6:	00000097          	auipc	ra,0x0
    800031da:	c6e080e7          	jalr	-914(ra) # 80002e44 <iunlockput>
      return 0;
    800031de:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031e0:	854e                	mv	a0,s3
    800031e2:	60e6                	ld	ra,88(sp)
    800031e4:	6446                	ld	s0,80(sp)
    800031e6:	64a6                	ld	s1,72(sp)
    800031e8:	6906                	ld	s2,64(sp)
    800031ea:	79e2                	ld	s3,56(sp)
    800031ec:	7a42                	ld	s4,48(sp)
    800031ee:	7aa2                	ld	s5,40(sp)
    800031f0:	7b02                	ld	s6,32(sp)
    800031f2:	6be2                	ld	s7,24(sp)
    800031f4:	6c42                	ld	s8,16(sp)
    800031f6:	6ca2                	ld	s9,8(sp)
    800031f8:	6125                	addi	sp,sp,96
    800031fa:	8082                	ret
      iunlock(ip);
    800031fc:	854e                	mv	a0,s3
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	aa6080e7          	jalr	-1370(ra) # 80002ca4 <iunlock>
      return ip;
    80003206:	bfe9                	j	800031e0 <namex+0x6a>
      iunlockput(ip);
    80003208:	854e                	mv	a0,s3
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	c3a080e7          	jalr	-966(ra) # 80002e44 <iunlockput>
      return 0;
    80003212:	89d2                	mv	s3,s4
    80003214:	b7f1                	j	800031e0 <namex+0x6a>
  len = path - s;
    80003216:	40b48633          	sub	a2,s1,a1
    8000321a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000321e:	094cd463          	bge	s9,s4,800032a6 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003222:	4639                	li	a2,14
    80003224:	8556                	mv	a0,s5
    80003226:	ffffd097          	auipc	ra,0xffffd
    8000322a:	ffc080e7          	jalr	-4(ra) # 80000222 <memmove>
  while(*path == '/')
    8000322e:	0004c783          	lbu	a5,0(s1)
    80003232:	01279763          	bne	a5,s2,80003240 <namex+0xca>
    path++;
    80003236:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003238:	0004c783          	lbu	a5,0(s1)
    8000323c:	ff278de3          	beq	a5,s2,80003236 <namex+0xc0>
    ilock(ip);
    80003240:	854e                	mv	a0,s3
    80003242:	00000097          	auipc	ra,0x0
    80003246:	9a0080e7          	jalr	-1632(ra) # 80002be2 <ilock>
    if(ip->type != T_DIR){
    8000324a:	04499783          	lh	a5,68(s3)
    8000324e:	f98793e3          	bne	a5,s8,800031d4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003252:	000b0563          	beqz	s6,8000325c <namex+0xe6>
    80003256:	0004c783          	lbu	a5,0(s1)
    8000325a:	d3cd                	beqz	a5,800031fc <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000325c:	865e                	mv	a2,s7
    8000325e:	85d6                	mv	a1,s5
    80003260:	854e                	mv	a0,s3
    80003262:	00000097          	auipc	ra,0x0
    80003266:	e64080e7          	jalr	-412(ra) # 800030c6 <dirlookup>
    8000326a:	8a2a                	mv	s4,a0
    8000326c:	dd51                	beqz	a0,80003208 <namex+0x92>
    iunlockput(ip);
    8000326e:	854e                	mv	a0,s3
    80003270:	00000097          	auipc	ra,0x0
    80003274:	bd4080e7          	jalr	-1068(ra) # 80002e44 <iunlockput>
    ip = next;
    80003278:	89d2                	mv	s3,s4
  while(*path == '/')
    8000327a:	0004c783          	lbu	a5,0(s1)
    8000327e:	05279763          	bne	a5,s2,800032cc <namex+0x156>
    path++;
    80003282:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003284:	0004c783          	lbu	a5,0(s1)
    80003288:	ff278de3          	beq	a5,s2,80003282 <namex+0x10c>
  if(*path == 0)
    8000328c:	c79d                	beqz	a5,800032ba <namex+0x144>
    path++;
    8000328e:	85a6                	mv	a1,s1
  len = path - s;
    80003290:	8a5e                	mv	s4,s7
    80003292:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003294:	01278963          	beq	a5,s2,800032a6 <namex+0x130>
    80003298:	dfbd                	beqz	a5,80003216 <namex+0xa0>
    path++;
    8000329a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000329c:	0004c783          	lbu	a5,0(s1)
    800032a0:	ff279ce3          	bne	a5,s2,80003298 <namex+0x122>
    800032a4:	bf8d                	j	80003216 <namex+0xa0>
    memmove(name, s, len);
    800032a6:	2601                	sext.w	a2,a2
    800032a8:	8556                	mv	a0,s5
    800032aa:	ffffd097          	auipc	ra,0xffffd
    800032ae:	f78080e7          	jalr	-136(ra) # 80000222 <memmove>
    name[len] = 0;
    800032b2:	9a56                	add	s4,s4,s5
    800032b4:	000a0023          	sb	zero,0(s4)
    800032b8:	bf9d                	j	8000322e <namex+0xb8>
  if(nameiparent){
    800032ba:	f20b03e3          	beqz	s6,800031e0 <namex+0x6a>
    iput(ip);
    800032be:	854e                	mv	a0,s3
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	adc080e7          	jalr	-1316(ra) # 80002d9c <iput>
    return 0;
    800032c8:	4981                	li	s3,0
    800032ca:	bf19                	j	800031e0 <namex+0x6a>
  if(*path == 0)
    800032cc:	d7fd                	beqz	a5,800032ba <namex+0x144>
  while(*path != '/' && *path != 0)
    800032ce:	0004c783          	lbu	a5,0(s1)
    800032d2:	85a6                	mv	a1,s1
    800032d4:	b7d1                	j	80003298 <namex+0x122>

00000000800032d6 <dirlink>:
{
    800032d6:	7139                	addi	sp,sp,-64
    800032d8:	fc06                	sd	ra,56(sp)
    800032da:	f822                	sd	s0,48(sp)
    800032dc:	f426                	sd	s1,40(sp)
    800032de:	f04a                	sd	s2,32(sp)
    800032e0:	ec4e                	sd	s3,24(sp)
    800032e2:	e852                	sd	s4,16(sp)
    800032e4:	0080                	addi	s0,sp,64
    800032e6:	892a                	mv	s2,a0
    800032e8:	8a2e                	mv	s4,a1
    800032ea:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ec:	4601                	li	a2,0
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	dd8080e7          	jalr	-552(ra) # 800030c6 <dirlookup>
    800032f6:	e93d                	bnez	a0,8000336c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f8:	04c92483          	lw	s1,76(s2)
    800032fc:	c49d                	beqz	s1,8000332a <dirlink+0x54>
    800032fe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003300:	4741                	li	a4,16
    80003302:	86a6                	mv	a3,s1
    80003304:	fc040613          	addi	a2,s0,-64
    80003308:	4581                	li	a1,0
    8000330a:	854a                	mv	a0,s2
    8000330c:	00000097          	auipc	ra,0x0
    80003310:	b8a080e7          	jalr	-1142(ra) # 80002e96 <readi>
    80003314:	47c1                	li	a5,16
    80003316:	06f51163          	bne	a0,a5,80003378 <dirlink+0xa2>
    if(de.inum == 0)
    8000331a:	fc045783          	lhu	a5,-64(s0)
    8000331e:	c791                	beqz	a5,8000332a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003320:	24c1                	addiw	s1,s1,16
    80003322:	04c92783          	lw	a5,76(s2)
    80003326:	fcf4ede3          	bltu	s1,a5,80003300 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000332a:	4639                	li	a2,14
    8000332c:	85d2                	mv	a1,s4
    8000332e:	fc240513          	addi	a0,s0,-62
    80003332:	ffffd097          	auipc	ra,0xffffd
    80003336:	fa4080e7          	jalr	-92(ra) # 800002d6 <strncpy>
  de.inum = inum;
    8000333a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000333e:	4741                	li	a4,16
    80003340:	86a6                	mv	a3,s1
    80003342:	fc040613          	addi	a2,s0,-64
    80003346:	4581                	li	a1,0
    80003348:	854a                	mv	a0,s2
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	c44080e7          	jalr	-956(ra) # 80002f8e <writei>
    80003352:	872a                	mv	a4,a0
    80003354:	47c1                	li	a5,16
  return 0;
    80003356:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003358:	02f71863          	bne	a4,a5,80003388 <dirlink+0xb2>
}
    8000335c:	70e2                	ld	ra,56(sp)
    8000335e:	7442                	ld	s0,48(sp)
    80003360:	74a2                	ld	s1,40(sp)
    80003362:	7902                	ld	s2,32(sp)
    80003364:	69e2                	ld	s3,24(sp)
    80003366:	6a42                	ld	s4,16(sp)
    80003368:	6121                	addi	sp,sp,64
    8000336a:	8082                	ret
    iput(ip);
    8000336c:	00000097          	auipc	ra,0x0
    80003370:	a30080e7          	jalr	-1488(ra) # 80002d9c <iput>
    return -1;
    80003374:	557d                	li	a0,-1
    80003376:	b7dd                	j	8000335c <dirlink+0x86>
      panic("dirlink read");
    80003378:	00005517          	auipc	a0,0x5
    8000337c:	2f050513          	addi	a0,a0,752 # 80008668 <syscalls+0x1d8>
    80003380:	00003097          	auipc	ra,0x3
    80003384:	918080e7          	jalr	-1768(ra) # 80005c98 <panic>
    panic("dirlink");
    80003388:	00005517          	auipc	a0,0x5
    8000338c:	3e850513          	addi	a0,a0,1000 # 80008770 <syscalls+0x2e0>
    80003390:	00003097          	auipc	ra,0x3
    80003394:	908080e7          	jalr	-1784(ra) # 80005c98 <panic>

0000000080003398 <namei>:

struct inode*
namei(char *path)
{
    80003398:	1101                	addi	sp,sp,-32
    8000339a:	ec06                	sd	ra,24(sp)
    8000339c:	e822                	sd	s0,16(sp)
    8000339e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033a0:	fe040613          	addi	a2,s0,-32
    800033a4:	4581                	li	a1,0
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	dd0080e7          	jalr	-560(ra) # 80003176 <namex>
}
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	6105                	addi	sp,sp,32
    800033b4:	8082                	ret

00000000800033b6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033b6:	1141                	addi	sp,sp,-16
    800033b8:	e406                	sd	ra,8(sp)
    800033ba:	e022                	sd	s0,0(sp)
    800033bc:	0800                	addi	s0,sp,16
    800033be:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033c0:	4585                	li	a1,1
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	db4080e7          	jalr	-588(ra) # 80003176 <namex>
}
    800033ca:	60a2                	ld	ra,8(sp)
    800033cc:	6402                	ld	s0,0(sp)
    800033ce:	0141                	addi	sp,sp,16
    800033d0:	8082                	ret

00000000800033d2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	e426                	sd	s1,8(sp)
    800033da:	e04a                	sd	s2,0(sp)
    800033dc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033de:	00016917          	auipc	s2,0x16
    800033e2:	e4290913          	addi	s2,s2,-446 # 80019220 <log>
    800033e6:	01892583          	lw	a1,24(s2)
    800033ea:	02892503          	lw	a0,40(s2)
    800033ee:	fffff097          	auipc	ra,0xfffff
    800033f2:	ff2080e7          	jalr	-14(ra) # 800023e0 <bread>
    800033f6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033f8:	02c92683          	lw	a3,44(s2)
    800033fc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033fe:	02d05763          	blez	a3,8000342c <write_head+0x5a>
    80003402:	00016797          	auipc	a5,0x16
    80003406:	e4e78793          	addi	a5,a5,-434 # 80019250 <log+0x30>
    8000340a:	05c50713          	addi	a4,a0,92
    8000340e:	36fd                	addiw	a3,a3,-1
    80003410:	1682                	slli	a3,a3,0x20
    80003412:	9281                	srli	a3,a3,0x20
    80003414:	068a                	slli	a3,a3,0x2
    80003416:	00016617          	auipc	a2,0x16
    8000341a:	e3e60613          	addi	a2,a2,-450 # 80019254 <log+0x34>
    8000341e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003420:	4390                	lw	a2,0(a5)
    80003422:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003424:	0791                	addi	a5,a5,4
    80003426:	0711                	addi	a4,a4,4
    80003428:	fed79ce3          	bne	a5,a3,80003420 <write_head+0x4e>
  }
  bwrite(buf);
    8000342c:	8526                	mv	a0,s1
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	0a4080e7          	jalr	164(ra) # 800024d2 <bwrite>
  brelse(buf);
    80003436:	8526                	mv	a0,s1
    80003438:	fffff097          	auipc	ra,0xfffff
    8000343c:	0d8080e7          	jalr	216(ra) # 80002510 <brelse>
}
    80003440:	60e2                	ld	ra,24(sp)
    80003442:	6442                	ld	s0,16(sp)
    80003444:	64a2                	ld	s1,8(sp)
    80003446:	6902                	ld	s2,0(sp)
    80003448:	6105                	addi	sp,sp,32
    8000344a:	8082                	ret

000000008000344c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344c:	00016797          	auipc	a5,0x16
    80003450:	e007a783          	lw	a5,-512(a5) # 8001924c <log+0x2c>
    80003454:	0af05d63          	blez	a5,8000350e <install_trans+0xc2>
{
    80003458:	7139                	addi	sp,sp,-64
    8000345a:	fc06                	sd	ra,56(sp)
    8000345c:	f822                	sd	s0,48(sp)
    8000345e:	f426                	sd	s1,40(sp)
    80003460:	f04a                	sd	s2,32(sp)
    80003462:	ec4e                	sd	s3,24(sp)
    80003464:	e852                	sd	s4,16(sp)
    80003466:	e456                	sd	s5,8(sp)
    80003468:	e05a                	sd	s6,0(sp)
    8000346a:	0080                	addi	s0,sp,64
    8000346c:	8b2a                	mv	s6,a0
    8000346e:	00016a97          	auipc	s5,0x16
    80003472:	de2a8a93          	addi	s5,s5,-542 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003476:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003478:	00016997          	auipc	s3,0x16
    8000347c:	da898993          	addi	s3,s3,-600 # 80019220 <log>
    80003480:	a035                	j	800034ac <install_trans+0x60>
      bunpin(dbuf);
    80003482:	8526                	mv	a0,s1
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	166080e7          	jalr	358(ra) # 800025ea <bunpin>
    brelse(lbuf);
    8000348c:	854a                	mv	a0,s2
    8000348e:	fffff097          	auipc	ra,0xfffff
    80003492:	082080e7          	jalr	130(ra) # 80002510 <brelse>
    brelse(dbuf);
    80003496:	8526                	mv	a0,s1
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	078080e7          	jalr	120(ra) # 80002510 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a0:	2a05                	addiw	s4,s4,1
    800034a2:	0a91                	addi	s5,s5,4
    800034a4:	02c9a783          	lw	a5,44(s3)
    800034a8:	04fa5963          	bge	s4,a5,800034fa <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ac:	0189a583          	lw	a1,24(s3)
    800034b0:	014585bb          	addw	a1,a1,s4
    800034b4:	2585                	addiw	a1,a1,1
    800034b6:	0289a503          	lw	a0,40(s3)
    800034ba:	fffff097          	auipc	ra,0xfffff
    800034be:	f26080e7          	jalr	-218(ra) # 800023e0 <bread>
    800034c2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c4:	000aa583          	lw	a1,0(s5)
    800034c8:	0289a503          	lw	a0,40(s3)
    800034cc:	fffff097          	auipc	ra,0xfffff
    800034d0:	f14080e7          	jalr	-236(ra) # 800023e0 <bread>
    800034d4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d6:	40000613          	li	a2,1024
    800034da:	05890593          	addi	a1,s2,88
    800034de:	05850513          	addi	a0,a0,88
    800034e2:	ffffd097          	auipc	ra,0xffffd
    800034e6:	d40080e7          	jalr	-704(ra) # 80000222 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ea:	8526                	mv	a0,s1
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	fe6080e7          	jalr	-26(ra) # 800024d2 <bwrite>
    if(recovering == 0)
    800034f4:	f80b1ce3          	bnez	s6,8000348c <install_trans+0x40>
    800034f8:	b769                	j	80003482 <install_trans+0x36>
}
    800034fa:	70e2                	ld	ra,56(sp)
    800034fc:	7442                	ld	s0,48(sp)
    800034fe:	74a2                	ld	s1,40(sp)
    80003500:	7902                	ld	s2,32(sp)
    80003502:	69e2                	ld	s3,24(sp)
    80003504:	6a42                	ld	s4,16(sp)
    80003506:	6aa2                	ld	s5,8(sp)
    80003508:	6b02                	ld	s6,0(sp)
    8000350a:	6121                	addi	sp,sp,64
    8000350c:	8082                	ret
    8000350e:	8082                	ret

0000000080003510 <initlog>:
{
    80003510:	7179                	addi	sp,sp,-48
    80003512:	f406                	sd	ra,40(sp)
    80003514:	f022                	sd	s0,32(sp)
    80003516:	ec26                	sd	s1,24(sp)
    80003518:	e84a                	sd	s2,16(sp)
    8000351a:	e44e                	sd	s3,8(sp)
    8000351c:	1800                	addi	s0,sp,48
    8000351e:	892a                	mv	s2,a0
    80003520:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003522:	00016497          	auipc	s1,0x16
    80003526:	cfe48493          	addi	s1,s1,-770 # 80019220 <log>
    8000352a:	00005597          	auipc	a1,0x5
    8000352e:	14e58593          	addi	a1,a1,334 # 80008678 <syscalls+0x1e8>
    80003532:	8526                	mv	a0,s1
    80003534:	00003097          	auipc	ra,0x3
    80003538:	c1e080e7          	jalr	-994(ra) # 80006152 <initlock>
  log.start = sb->logstart;
    8000353c:	0149a583          	lw	a1,20(s3)
    80003540:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003542:	0109a783          	lw	a5,16(s3)
    80003546:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003548:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000354c:	854a                	mv	a0,s2
    8000354e:	fffff097          	auipc	ra,0xfffff
    80003552:	e92080e7          	jalr	-366(ra) # 800023e0 <bread>
  log.lh.n = lh->n;
    80003556:	4d3c                	lw	a5,88(a0)
    80003558:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000355a:	02f05563          	blez	a5,80003584 <initlog+0x74>
    8000355e:	05c50713          	addi	a4,a0,92
    80003562:	00016697          	auipc	a3,0x16
    80003566:	cee68693          	addi	a3,a3,-786 # 80019250 <log+0x30>
    8000356a:	37fd                	addiw	a5,a5,-1
    8000356c:	1782                	slli	a5,a5,0x20
    8000356e:	9381                	srli	a5,a5,0x20
    80003570:	078a                	slli	a5,a5,0x2
    80003572:	06050613          	addi	a2,a0,96
    80003576:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003578:	4310                	lw	a2,0(a4)
    8000357a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000357c:	0711                	addi	a4,a4,4
    8000357e:	0691                	addi	a3,a3,4
    80003580:	fef71ce3          	bne	a4,a5,80003578 <initlog+0x68>
  brelse(buf);
    80003584:	fffff097          	auipc	ra,0xfffff
    80003588:	f8c080e7          	jalr	-116(ra) # 80002510 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000358c:	4505                	li	a0,1
    8000358e:	00000097          	auipc	ra,0x0
    80003592:	ebe080e7          	jalr	-322(ra) # 8000344c <install_trans>
  log.lh.n = 0;
    80003596:	00016797          	auipc	a5,0x16
    8000359a:	ca07ab23          	sw	zero,-842(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    8000359e:	00000097          	auipc	ra,0x0
    800035a2:	e34080e7          	jalr	-460(ra) # 800033d2 <write_head>
}
    800035a6:	70a2                	ld	ra,40(sp)
    800035a8:	7402                	ld	s0,32(sp)
    800035aa:	64e2                	ld	s1,24(sp)
    800035ac:	6942                	ld	s2,16(sp)
    800035ae:	69a2                	ld	s3,8(sp)
    800035b0:	6145                	addi	sp,sp,48
    800035b2:	8082                	ret

00000000800035b4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035b4:	1101                	addi	sp,sp,-32
    800035b6:	ec06                	sd	ra,24(sp)
    800035b8:	e822                	sd	s0,16(sp)
    800035ba:	e426                	sd	s1,8(sp)
    800035bc:	e04a                	sd	s2,0(sp)
    800035be:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035c0:	00016517          	auipc	a0,0x16
    800035c4:	c6050513          	addi	a0,a0,-928 # 80019220 <log>
    800035c8:	00003097          	auipc	ra,0x3
    800035cc:	c1a080e7          	jalr	-998(ra) # 800061e2 <acquire>
  while(1){
    if(log.committing){
    800035d0:	00016497          	auipc	s1,0x16
    800035d4:	c5048493          	addi	s1,s1,-944 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d8:	4979                	li	s2,30
    800035da:	a039                	j	800035e8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035dc:	85a6                	mv	a1,s1
    800035de:	8526                	mv	a0,s1
    800035e0:	ffffe097          	auipc	ra,0xffffe
    800035e4:	f76080e7          	jalr	-138(ra) # 80001556 <sleep>
    if(log.committing){
    800035e8:	50dc                	lw	a5,36(s1)
    800035ea:	fbed                	bnez	a5,800035dc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ec:	509c                	lw	a5,32(s1)
    800035ee:	0017871b          	addiw	a4,a5,1
    800035f2:	0007069b          	sext.w	a3,a4
    800035f6:	0027179b          	slliw	a5,a4,0x2
    800035fa:	9fb9                	addw	a5,a5,a4
    800035fc:	0017979b          	slliw	a5,a5,0x1
    80003600:	54d8                	lw	a4,44(s1)
    80003602:	9fb9                	addw	a5,a5,a4
    80003604:	00f95963          	bge	s2,a5,80003616 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003608:	85a6                	mv	a1,s1
    8000360a:	8526                	mv	a0,s1
    8000360c:	ffffe097          	auipc	ra,0xffffe
    80003610:	f4a080e7          	jalr	-182(ra) # 80001556 <sleep>
    80003614:	bfd1                	j	800035e8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003616:	00016517          	auipc	a0,0x16
    8000361a:	c0a50513          	addi	a0,a0,-1014 # 80019220 <log>
    8000361e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003620:	00003097          	auipc	ra,0x3
    80003624:	c76080e7          	jalr	-906(ra) # 80006296 <release>
      break;
    }
  }
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	64a2                	ld	s1,8(sp)
    8000362e:	6902                	ld	s2,0(sp)
    80003630:	6105                	addi	sp,sp,32
    80003632:	8082                	ret

0000000080003634 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003634:	7139                	addi	sp,sp,-64
    80003636:	fc06                	sd	ra,56(sp)
    80003638:	f822                	sd	s0,48(sp)
    8000363a:	f426                	sd	s1,40(sp)
    8000363c:	f04a                	sd	s2,32(sp)
    8000363e:	ec4e                	sd	s3,24(sp)
    80003640:	e852                	sd	s4,16(sp)
    80003642:	e456                	sd	s5,8(sp)
    80003644:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003646:	00016497          	auipc	s1,0x16
    8000364a:	bda48493          	addi	s1,s1,-1062 # 80019220 <log>
    8000364e:	8526                	mv	a0,s1
    80003650:	00003097          	auipc	ra,0x3
    80003654:	b92080e7          	jalr	-1134(ra) # 800061e2 <acquire>
  log.outstanding -= 1;
    80003658:	509c                	lw	a5,32(s1)
    8000365a:	37fd                	addiw	a5,a5,-1
    8000365c:	0007891b          	sext.w	s2,a5
    80003660:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003662:	50dc                	lw	a5,36(s1)
    80003664:	efb9                	bnez	a5,800036c2 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003666:	06091663          	bnez	s2,800036d2 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000366a:	00016497          	auipc	s1,0x16
    8000366e:	bb648493          	addi	s1,s1,-1098 # 80019220 <log>
    80003672:	4785                	li	a5,1
    80003674:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003676:	8526                	mv	a0,s1
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	c1e080e7          	jalr	-994(ra) # 80006296 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003680:	54dc                	lw	a5,44(s1)
    80003682:	06f04763          	bgtz	a5,800036f0 <end_op+0xbc>
    acquire(&log.lock);
    80003686:	00016497          	auipc	s1,0x16
    8000368a:	b9a48493          	addi	s1,s1,-1126 # 80019220 <log>
    8000368e:	8526                	mv	a0,s1
    80003690:	00003097          	auipc	ra,0x3
    80003694:	b52080e7          	jalr	-1198(ra) # 800061e2 <acquire>
    log.committing = 0;
    80003698:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000369c:	8526                	mv	a0,s1
    8000369e:	ffffe097          	auipc	ra,0xffffe
    800036a2:	044080e7          	jalr	68(ra) # 800016e2 <wakeup>
    release(&log.lock);
    800036a6:	8526                	mv	a0,s1
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	bee080e7          	jalr	-1042(ra) # 80006296 <release>
}
    800036b0:	70e2                	ld	ra,56(sp)
    800036b2:	7442                	ld	s0,48(sp)
    800036b4:	74a2                	ld	s1,40(sp)
    800036b6:	7902                	ld	s2,32(sp)
    800036b8:	69e2                	ld	s3,24(sp)
    800036ba:	6a42                	ld	s4,16(sp)
    800036bc:	6aa2                	ld	s5,8(sp)
    800036be:	6121                	addi	sp,sp,64
    800036c0:	8082                	ret
    panic("log.committing");
    800036c2:	00005517          	auipc	a0,0x5
    800036c6:	fbe50513          	addi	a0,a0,-66 # 80008680 <syscalls+0x1f0>
    800036ca:	00002097          	auipc	ra,0x2
    800036ce:	5ce080e7          	jalr	1486(ra) # 80005c98 <panic>
    wakeup(&log);
    800036d2:	00016497          	auipc	s1,0x16
    800036d6:	b4e48493          	addi	s1,s1,-1202 # 80019220 <log>
    800036da:	8526                	mv	a0,s1
    800036dc:	ffffe097          	auipc	ra,0xffffe
    800036e0:	006080e7          	jalr	6(ra) # 800016e2 <wakeup>
  release(&log.lock);
    800036e4:	8526                	mv	a0,s1
    800036e6:	00003097          	auipc	ra,0x3
    800036ea:	bb0080e7          	jalr	-1104(ra) # 80006296 <release>
  if(do_commit){
    800036ee:	b7c9                	j	800036b0 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f0:	00016a97          	auipc	s5,0x16
    800036f4:	b60a8a93          	addi	s5,s5,-1184 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036f8:	00016a17          	auipc	s4,0x16
    800036fc:	b28a0a13          	addi	s4,s4,-1240 # 80019220 <log>
    80003700:	018a2583          	lw	a1,24(s4)
    80003704:	012585bb          	addw	a1,a1,s2
    80003708:	2585                	addiw	a1,a1,1
    8000370a:	028a2503          	lw	a0,40(s4)
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	cd2080e7          	jalr	-814(ra) # 800023e0 <bread>
    80003716:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003718:	000aa583          	lw	a1,0(s5)
    8000371c:	028a2503          	lw	a0,40(s4)
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	cc0080e7          	jalr	-832(ra) # 800023e0 <bread>
    80003728:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000372a:	40000613          	li	a2,1024
    8000372e:	05850593          	addi	a1,a0,88
    80003732:	05848513          	addi	a0,s1,88
    80003736:	ffffd097          	auipc	ra,0xffffd
    8000373a:	aec080e7          	jalr	-1300(ra) # 80000222 <memmove>
    bwrite(to);  // write the log
    8000373e:	8526                	mv	a0,s1
    80003740:	fffff097          	auipc	ra,0xfffff
    80003744:	d92080e7          	jalr	-622(ra) # 800024d2 <bwrite>
    brelse(from);
    80003748:	854e                	mv	a0,s3
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	dc6080e7          	jalr	-570(ra) # 80002510 <brelse>
    brelse(to);
    80003752:	8526                	mv	a0,s1
    80003754:	fffff097          	auipc	ra,0xfffff
    80003758:	dbc080e7          	jalr	-580(ra) # 80002510 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375c:	2905                	addiw	s2,s2,1
    8000375e:	0a91                	addi	s5,s5,4
    80003760:	02ca2783          	lw	a5,44(s4)
    80003764:	f8f94ee3          	blt	s2,a5,80003700 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003768:	00000097          	auipc	ra,0x0
    8000376c:	c6a080e7          	jalr	-918(ra) # 800033d2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003770:	4501                	li	a0,0
    80003772:	00000097          	auipc	ra,0x0
    80003776:	cda080e7          	jalr	-806(ra) # 8000344c <install_trans>
    log.lh.n = 0;
    8000377a:	00016797          	auipc	a5,0x16
    8000377e:	ac07a923          	sw	zero,-1326(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003782:	00000097          	auipc	ra,0x0
    80003786:	c50080e7          	jalr	-944(ra) # 800033d2 <write_head>
    8000378a:	bdf5                	j	80003686 <end_op+0x52>

000000008000378c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000378c:	1101                	addi	sp,sp,-32
    8000378e:	ec06                	sd	ra,24(sp)
    80003790:	e822                	sd	s0,16(sp)
    80003792:	e426                	sd	s1,8(sp)
    80003794:	e04a                	sd	s2,0(sp)
    80003796:	1000                	addi	s0,sp,32
    80003798:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000379a:	00016917          	auipc	s2,0x16
    8000379e:	a8690913          	addi	s2,s2,-1402 # 80019220 <log>
    800037a2:	854a                	mv	a0,s2
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	a3e080e7          	jalr	-1474(ra) # 800061e2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ac:	02c92603          	lw	a2,44(s2)
    800037b0:	47f5                	li	a5,29
    800037b2:	06c7c563          	blt	a5,a2,8000381c <log_write+0x90>
    800037b6:	00016797          	auipc	a5,0x16
    800037ba:	a867a783          	lw	a5,-1402(a5) # 8001923c <log+0x1c>
    800037be:	37fd                	addiw	a5,a5,-1
    800037c0:	04f65e63          	bge	a2,a5,8000381c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037c4:	00016797          	auipc	a5,0x16
    800037c8:	a7c7a783          	lw	a5,-1412(a5) # 80019240 <log+0x20>
    800037cc:	06f05063          	blez	a5,8000382c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037d0:	4781                	li	a5,0
    800037d2:	06c05563          	blez	a2,8000383c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d6:	44cc                	lw	a1,12(s1)
    800037d8:	00016717          	auipc	a4,0x16
    800037dc:	a7870713          	addi	a4,a4,-1416 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037e0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e2:	4314                	lw	a3,0(a4)
    800037e4:	04b68c63          	beq	a3,a1,8000383c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037e8:	2785                	addiw	a5,a5,1
    800037ea:	0711                	addi	a4,a4,4
    800037ec:	fef61be3          	bne	a2,a5,800037e2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037f0:	0621                	addi	a2,a2,8
    800037f2:	060a                	slli	a2,a2,0x2
    800037f4:	00016797          	auipc	a5,0x16
    800037f8:	a2c78793          	addi	a5,a5,-1492 # 80019220 <log>
    800037fc:	963e                	add	a2,a2,a5
    800037fe:	44dc                	lw	a5,12(s1)
    80003800:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003802:	8526                	mv	a0,s1
    80003804:	fffff097          	auipc	ra,0xfffff
    80003808:	daa080e7          	jalr	-598(ra) # 800025ae <bpin>
    log.lh.n++;
    8000380c:	00016717          	auipc	a4,0x16
    80003810:	a1470713          	addi	a4,a4,-1516 # 80019220 <log>
    80003814:	575c                	lw	a5,44(a4)
    80003816:	2785                	addiw	a5,a5,1
    80003818:	d75c                	sw	a5,44(a4)
    8000381a:	a835                	j	80003856 <log_write+0xca>
    panic("too big a transaction");
    8000381c:	00005517          	auipc	a0,0x5
    80003820:	e7450513          	addi	a0,a0,-396 # 80008690 <syscalls+0x200>
    80003824:	00002097          	auipc	ra,0x2
    80003828:	474080e7          	jalr	1140(ra) # 80005c98 <panic>
    panic("log_write outside of trans");
    8000382c:	00005517          	auipc	a0,0x5
    80003830:	e7c50513          	addi	a0,a0,-388 # 800086a8 <syscalls+0x218>
    80003834:	00002097          	auipc	ra,0x2
    80003838:	464080e7          	jalr	1124(ra) # 80005c98 <panic>
  log.lh.block[i] = b->blockno;
    8000383c:	00878713          	addi	a4,a5,8
    80003840:	00271693          	slli	a3,a4,0x2
    80003844:	00016717          	auipc	a4,0x16
    80003848:	9dc70713          	addi	a4,a4,-1572 # 80019220 <log>
    8000384c:	9736                	add	a4,a4,a3
    8000384e:	44d4                	lw	a3,12(s1)
    80003850:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003852:	faf608e3          	beq	a2,a5,80003802 <log_write+0x76>
  }
  release(&log.lock);
    80003856:	00016517          	auipc	a0,0x16
    8000385a:	9ca50513          	addi	a0,a0,-1590 # 80019220 <log>
    8000385e:	00003097          	auipc	ra,0x3
    80003862:	a38080e7          	jalr	-1480(ra) # 80006296 <release>
}
    80003866:	60e2                	ld	ra,24(sp)
    80003868:	6442                	ld	s0,16(sp)
    8000386a:	64a2                	ld	s1,8(sp)
    8000386c:	6902                	ld	s2,0(sp)
    8000386e:	6105                	addi	sp,sp,32
    80003870:	8082                	ret

0000000080003872 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003872:	1101                	addi	sp,sp,-32
    80003874:	ec06                	sd	ra,24(sp)
    80003876:	e822                	sd	s0,16(sp)
    80003878:	e426                	sd	s1,8(sp)
    8000387a:	e04a                	sd	s2,0(sp)
    8000387c:	1000                	addi	s0,sp,32
    8000387e:	84aa                	mv	s1,a0
    80003880:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003882:	00005597          	auipc	a1,0x5
    80003886:	e4658593          	addi	a1,a1,-442 # 800086c8 <syscalls+0x238>
    8000388a:	0521                	addi	a0,a0,8
    8000388c:	00003097          	auipc	ra,0x3
    80003890:	8c6080e7          	jalr	-1850(ra) # 80006152 <initlock>
  lk->name = name;
    80003894:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003898:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000389c:	0204a423          	sw	zero,40(s1)
}
    800038a0:	60e2                	ld	ra,24(sp)
    800038a2:	6442                	ld	s0,16(sp)
    800038a4:	64a2                	ld	s1,8(sp)
    800038a6:	6902                	ld	s2,0(sp)
    800038a8:	6105                	addi	sp,sp,32
    800038aa:	8082                	ret

00000000800038ac <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ac:	1101                	addi	sp,sp,-32
    800038ae:	ec06                	sd	ra,24(sp)
    800038b0:	e822                	sd	s0,16(sp)
    800038b2:	e426                	sd	s1,8(sp)
    800038b4:	e04a                	sd	s2,0(sp)
    800038b6:	1000                	addi	s0,sp,32
    800038b8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ba:	00850913          	addi	s2,a0,8
    800038be:	854a                	mv	a0,s2
    800038c0:	00003097          	auipc	ra,0x3
    800038c4:	922080e7          	jalr	-1758(ra) # 800061e2 <acquire>
  while (lk->locked) {
    800038c8:	409c                	lw	a5,0(s1)
    800038ca:	cb89                	beqz	a5,800038dc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038cc:	85ca                	mv	a1,s2
    800038ce:	8526                	mv	a0,s1
    800038d0:	ffffe097          	auipc	ra,0xffffe
    800038d4:	c86080e7          	jalr	-890(ra) # 80001556 <sleep>
  while (lk->locked) {
    800038d8:	409c                	lw	a5,0(s1)
    800038da:	fbed                	bnez	a5,800038cc <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038dc:	4785                	li	a5,1
    800038de:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038e0:	ffffd097          	auipc	ra,0xffffd
    800038e4:	5b2080e7          	jalr	1458(ra) # 80000e92 <myproc>
    800038e8:	591c                	lw	a5,48(a0)
    800038ea:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ec:	854a                	mv	a0,s2
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	9a8080e7          	jalr	-1624(ra) # 80006296 <release>
}
    800038f6:	60e2                	ld	ra,24(sp)
    800038f8:	6442                	ld	s0,16(sp)
    800038fa:	64a2                	ld	s1,8(sp)
    800038fc:	6902                	ld	s2,0(sp)
    800038fe:	6105                	addi	sp,sp,32
    80003900:	8082                	ret

0000000080003902 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003902:	1101                	addi	sp,sp,-32
    80003904:	ec06                	sd	ra,24(sp)
    80003906:	e822                	sd	s0,16(sp)
    80003908:	e426                	sd	s1,8(sp)
    8000390a:	e04a                	sd	s2,0(sp)
    8000390c:	1000                	addi	s0,sp,32
    8000390e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003910:	00850913          	addi	s2,a0,8
    80003914:	854a                	mv	a0,s2
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	8cc080e7          	jalr	-1844(ra) # 800061e2 <acquire>
  lk->locked = 0;
    8000391e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003922:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003926:	8526                	mv	a0,s1
    80003928:	ffffe097          	auipc	ra,0xffffe
    8000392c:	dba080e7          	jalr	-582(ra) # 800016e2 <wakeup>
  release(&lk->lk);
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	964080e7          	jalr	-1692(ra) # 80006296 <release>
}
    8000393a:	60e2                	ld	ra,24(sp)
    8000393c:	6442                	ld	s0,16(sp)
    8000393e:	64a2                	ld	s1,8(sp)
    80003940:	6902                	ld	s2,0(sp)
    80003942:	6105                	addi	sp,sp,32
    80003944:	8082                	ret

0000000080003946 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003946:	7179                	addi	sp,sp,-48
    80003948:	f406                	sd	ra,40(sp)
    8000394a:	f022                	sd	s0,32(sp)
    8000394c:	ec26                	sd	s1,24(sp)
    8000394e:	e84a                	sd	s2,16(sp)
    80003950:	e44e                	sd	s3,8(sp)
    80003952:	1800                	addi	s0,sp,48
    80003954:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003956:	00850913          	addi	s2,a0,8
    8000395a:	854a                	mv	a0,s2
    8000395c:	00003097          	auipc	ra,0x3
    80003960:	886080e7          	jalr	-1914(ra) # 800061e2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003964:	409c                	lw	a5,0(s1)
    80003966:	ef99                	bnez	a5,80003984 <holdingsleep+0x3e>
    80003968:	4481                	li	s1,0
  release(&lk->lk);
    8000396a:	854a                	mv	a0,s2
    8000396c:	00003097          	auipc	ra,0x3
    80003970:	92a080e7          	jalr	-1750(ra) # 80006296 <release>
  return r;
}
    80003974:	8526                	mv	a0,s1
    80003976:	70a2                	ld	ra,40(sp)
    80003978:	7402                	ld	s0,32(sp)
    8000397a:	64e2                	ld	s1,24(sp)
    8000397c:	6942                	ld	s2,16(sp)
    8000397e:	69a2                	ld	s3,8(sp)
    80003980:	6145                	addi	sp,sp,48
    80003982:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003984:	0284a983          	lw	s3,40(s1)
    80003988:	ffffd097          	auipc	ra,0xffffd
    8000398c:	50a080e7          	jalr	1290(ra) # 80000e92 <myproc>
    80003990:	5904                	lw	s1,48(a0)
    80003992:	413484b3          	sub	s1,s1,s3
    80003996:	0014b493          	seqz	s1,s1
    8000399a:	bfc1                	j	8000396a <holdingsleep+0x24>

000000008000399c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000399c:	1141                	addi	sp,sp,-16
    8000399e:	e406                	sd	ra,8(sp)
    800039a0:	e022                	sd	s0,0(sp)
    800039a2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039a4:	00005597          	auipc	a1,0x5
    800039a8:	d3458593          	addi	a1,a1,-716 # 800086d8 <syscalls+0x248>
    800039ac:	00016517          	auipc	a0,0x16
    800039b0:	9bc50513          	addi	a0,a0,-1604 # 80019368 <ftable>
    800039b4:	00002097          	auipc	ra,0x2
    800039b8:	79e080e7          	jalr	1950(ra) # 80006152 <initlock>
}
    800039bc:	60a2                	ld	ra,8(sp)
    800039be:	6402                	ld	s0,0(sp)
    800039c0:	0141                	addi	sp,sp,16
    800039c2:	8082                	ret

00000000800039c4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039c4:	1101                	addi	sp,sp,-32
    800039c6:	ec06                	sd	ra,24(sp)
    800039c8:	e822                	sd	s0,16(sp)
    800039ca:	e426                	sd	s1,8(sp)
    800039cc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039ce:	00016517          	auipc	a0,0x16
    800039d2:	99a50513          	addi	a0,a0,-1638 # 80019368 <ftable>
    800039d6:	00003097          	auipc	ra,0x3
    800039da:	80c080e7          	jalr	-2036(ra) # 800061e2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039de:	00016497          	auipc	s1,0x16
    800039e2:	9a248493          	addi	s1,s1,-1630 # 80019380 <ftable+0x18>
    800039e6:	00017717          	auipc	a4,0x17
    800039ea:	93a70713          	addi	a4,a4,-1734 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039ee:	40dc                	lw	a5,4(s1)
    800039f0:	cf99                	beqz	a5,80003a0e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f2:	02848493          	addi	s1,s1,40
    800039f6:	fee49ce3          	bne	s1,a4,800039ee <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039fa:	00016517          	auipc	a0,0x16
    800039fe:	96e50513          	addi	a0,a0,-1682 # 80019368 <ftable>
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	894080e7          	jalr	-1900(ra) # 80006296 <release>
  return 0;
    80003a0a:	4481                	li	s1,0
    80003a0c:	a819                	j	80003a22 <filealloc+0x5e>
      f->ref = 1;
    80003a0e:	4785                	li	a5,1
    80003a10:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a12:	00016517          	auipc	a0,0x16
    80003a16:	95650513          	addi	a0,a0,-1706 # 80019368 <ftable>
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	87c080e7          	jalr	-1924(ra) # 80006296 <release>
}
    80003a22:	8526                	mv	a0,s1
    80003a24:	60e2                	ld	ra,24(sp)
    80003a26:	6442                	ld	s0,16(sp)
    80003a28:	64a2                	ld	s1,8(sp)
    80003a2a:	6105                	addi	sp,sp,32
    80003a2c:	8082                	ret

0000000080003a2e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a2e:	1101                	addi	sp,sp,-32
    80003a30:	ec06                	sd	ra,24(sp)
    80003a32:	e822                	sd	s0,16(sp)
    80003a34:	e426                	sd	s1,8(sp)
    80003a36:	1000                	addi	s0,sp,32
    80003a38:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a3a:	00016517          	auipc	a0,0x16
    80003a3e:	92e50513          	addi	a0,a0,-1746 # 80019368 <ftable>
    80003a42:	00002097          	auipc	ra,0x2
    80003a46:	7a0080e7          	jalr	1952(ra) # 800061e2 <acquire>
  if(f->ref < 1)
    80003a4a:	40dc                	lw	a5,4(s1)
    80003a4c:	02f05263          	blez	a5,80003a70 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a50:	2785                	addiw	a5,a5,1
    80003a52:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a54:	00016517          	auipc	a0,0x16
    80003a58:	91450513          	addi	a0,a0,-1772 # 80019368 <ftable>
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	83a080e7          	jalr	-1990(ra) # 80006296 <release>
  return f;
}
    80003a64:	8526                	mv	a0,s1
    80003a66:	60e2                	ld	ra,24(sp)
    80003a68:	6442                	ld	s0,16(sp)
    80003a6a:	64a2                	ld	s1,8(sp)
    80003a6c:	6105                	addi	sp,sp,32
    80003a6e:	8082                	ret
    panic("filedup");
    80003a70:	00005517          	auipc	a0,0x5
    80003a74:	c7050513          	addi	a0,a0,-912 # 800086e0 <syscalls+0x250>
    80003a78:	00002097          	auipc	ra,0x2
    80003a7c:	220080e7          	jalr	544(ra) # 80005c98 <panic>

0000000080003a80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a80:	7139                	addi	sp,sp,-64
    80003a82:	fc06                	sd	ra,56(sp)
    80003a84:	f822                	sd	s0,48(sp)
    80003a86:	f426                	sd	s1,40(sp)
    80003a88:	f04a                	sd	s2,32(sp)
    80003a8a:	ec4e                	sd	s3,24(sp)
    80003a8c:	e852                	sd	s4,16(sp)
    80003a8e:	e456                	sd	s5,8(sp)
    80003a90:	0080                	addi	s0,sp,64
    80003a92:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a94:	00016517          	auipc	a0,0x16
    80003a98:	8d450513          	addi	a0,a0,-1836 # 80019368 <ftable>
    80003a9c:	00002097          	auipc	ra,0x2
    80003aa0:	746080e7          	jalr	1862(ra) # 800061e2 <acquire>
  if(f->ref < 1)
    80003aa4:	40dc                	lw	a5,4(s1)
    80003aa6:	06f05163          	blez	a5,80003b08 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aaa:	37fd                	addiw	a5,a5,-1
    80003aac:	0007871b          	sext.w	a4,a5
    80003ab0:	c0dc                	sw	a5,4(s1)
    80003ab2:	06e04363          	bgtz	a4,80003b18 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ab6:	0004a903          	lw	s2,0(s1)
    80003aba:	0094ca83          	lbu	s5,9(s1)
    80003abe:	0104ba03          	ld	s4,16(s1)
    80003ac2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ac6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aca:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ace:	00016517          	auipc	a0,0x16
    80003ad2:	89a50513          	addi	a0,a0,-1894 # 80019368 <ftable>
    80003ad6:	00002097          	auipc	ra,0x2
    80003ada:	7c0080e7          	jalr	1984(ra) # 80006296 <release>

  if(ff.type == FD_PIPE){
    80003ade:	4785                	li	a5,1
    80003ae0:	04f90d63          	beq	s2,a5,80003b3a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ae4:	3979                	addiw	s2,s2,-2
    80003ae6:	4785                	li	a5,1
    80003ae8:	0527e063          	bltu	a5,s2,80003b28 <fileclose+0xa8>
    begin_op();
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	ac8080e7          	jalr	-1336(ra) # 800035b4 <begin_op>
    iput(ff.ip);
    80003af4:	854e                	mv	a0,s3
    80003af6:	fffff097          	auipc	ra,0xfffff
    80003afa:	2a6080e7          	jalr	678(ra) # 80002d9c <iput>
    end_op();
    80003afe:	00000097          	auipc	ra,0x0
    80003b02:	b36080e7          	jalr	-1226(ra) # 80003634 <end_op>
    80003b06:	a00d                	j	80003b28 <fileclose+0xa8>
    panic("fileclose");
    80003b08:	00005517          	auipc	a0,0x5
    80003b0c:	be050513          	addi	a0,a0,-1056 # 800086e8 <syscalls+0x258>
    80003b10:	00002097          	auipc	ra,0x2
    80003b14:	188080e7          	jalr	392(ra) # 80005c98 <panic>
    release(&ftable.lock);
    80003b18:	00016517          	auipc	a0,0x16
    80003b1c:	85050513          	addi	a0,a0,-1968 # 80019368 <ftable>
    80003b20:	00002097          	auipc	ra,0x2
    80003b24:	776080e7          	jalr	1910(ra) # 80006296 <release>
  }
}
    80003b28:	70e2                	ld	ra,56(sp)
    80003b2a:	7442                	ld	s0,48(sp)
    80003b2c:	74a2                	ld	s1,40(sp)
    80003b2e:	7902                	ld	s2,32(sp)
    80003b30:	69e2                	ld	s3,24(sp)
    80003b32:	6a42                	ld	s4,16(sp)
    80003b34:	6aa2                	ld	s5,8(sp)
    80003b36:	6121                	addi	sp,sp,64
    80003b38:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b3a:	85d6                	mv	a1,s5
    80003b3c:	8552                	mv	a0,s4
    80003b3e:	00000097          	auipc	ra,0x0
    80003b42:	34c080e7          	jalr	844(ra) # 80003e8a <pipeclose>
    80003b46:	b7cd                	j	80003b28 <fileclose+0xa8>

0000000080003b48 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b48:	715d                	addi	sp,sp,-80
    80003b4a:	e486                	sd	ra,72(sp)
    80003b4c:	e0a2                	sd	s0,64(sp)
    80003b4e:	fc26                	sd	s1,56(sp)
    80003b50:	f84a                	sd	s2,48(sp)
    80003b52:	f44e                	sd	s3,40(sp)
    80003b54:	0880                	addi	s0,sp,80
    80003b56:	84aa                	mv	s1,a0
    80003b58:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b5a:	ffffd097          	auipc	ra,0xffffd
    80003b5e:	338080e7          	jalr	824(ra) # 80000e92 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b62:	409c                	lw	a5,0(s1)
    80003b64:	37f9                	addiw	a5,a5,-2
    80003b66:	4705                	li	a4,1
    80003b68:	04f76763          	bltu	a4,a5,80003bb6 <filestat+0x6e>
    80003b6c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b6e:	6c88                	ld	a0,24(s1)
    80003b70:	fffff097          	auipc	ra,0xfffff
    80003b74:	072080e7          	jalr	114(ra) # 80002be2 <ilock>
    stati(f->ip, &st);
    80003b78:	fb840593          	addi	a1,s0,-72
    80003b7c:	6c88                	ld	a0,24(s1)
    80003b7e:	fffff097          	auipc	ra,0xfffff
    80003b82:	2ee080e7          	jalr	750(ra) # 80002e6c <stati>
    iunlock(f->ip);
    80003b86:	6c88                	ld	a0,24(s1)
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	11c080e7          	jalr	284(ra) # 80002ca4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b90:	46e1                	li	a3,24
    80003b92:	fb840613          	addi	a2,s0,-72
    80003b96:	85ce                	mv	a1,s3
    80003b98:	05893503          	ld	a0,88(s2)
    80003b9c:	ffffd097          	auipc	ra,0xffffd
    80003ba0:	fb8080e7          	jalr	-72(ra) # 80000b54 <copyout>
    80003ba4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ba8:	60a6                	ld	ra,72(sp)
    80003baa:	6406                	ld	s0,64(sp)
    80003bac:	74e2                	ld	s1,56(sp)
    80003bae:	7942                	ld	s2,48(sp)
    80003bb0:	79a2                	ld	s3,40(sp)
    80003bb2:	6161                	addi	sp,sp,80
    80003bb4:	8082                	ret
  return -1;
    80003bb6:	557d                	li	a0,-1
    80003bb8:	bfc5                	j	80003ba8 <filestat+0x60>

0000000080003bba <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bba:	7179                	addi	sp,sp,-48
    80003bbc:	f406                	sd	ra,40(sp)
    80003bbe:	f022                	sd	s0,32(sp)
    80003bc0:	ec26                	sd	s1,24(sp)
    80003bc2:	e84a                	sd	s2,16(sp)
    80003bc4:	e44e                	sd	s3,8(sp)
    80003bc6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bc8:	00854783          	lbu	a5,8(a0)
    80003bcc:	c3d5                	beqz	a5,80003c70 <fileread+0xb6>
    80003bce:	84aa                	mv	s1,a0
    80003bd0:	89ae                	mv	s3,a1
    80003bd2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bd4:	411c                	lw	a5,0(a0)
    80003bd6:	4705                	li	a4,1
    80003bd8:	04e78963          	beq	a5,a4,80003c2a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bdc:	470d                	li	a4,3
    80003bde:	04e78d63          	beq	a5,a4,80003c38 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003be2:	4709                	li	a4,2
    80003be4:	06e79e63          	bne	a5,a4,80003c60 <fileread+0xa6>
    ilock(f->ip);
    80003be8:	6d08                	ld	a0,24(a0)
    80003bea:	fffff097          	auipc	ra,0xfffff
    80003bee:	ff8080e7          	jalr	-8(ra) # 80002be2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bf2:	874a                	mv	a4,s2
    80003bf4:	5094                	lw	a3,32(s1)
    80003bf6:	864e                	mv	a2,s3
    80003bf8:	4585                	li	a1,1
    80003bfa:	6c88                	ld	a0,24(s1)
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	29a080e7          	jalr	666(ra) # 80002e96 <readi>
    80003c04:	892a                	mv	s2,a0
    80003c06:	00a05563          	blez	a0,80003c10 <fileread+0x56>
      f->off += r;
    80003c0a:	509c                	lw	a5,32(s1)
    80003c0c:	9fa9                	addw	a5,a5,a0
    80003c0e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c10:	6c88                	ld	a0,24(s1)
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	092080e7          	jalr	146(ra) # 80002ca4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c1a:	854a                	mv	a0,s2
    80003c1c:	70a2                	ld	ra,40(sp)
    80003c1e:	7402                	ld	s0,32(sp)
    80003c20:	64e2                	ld	s1,24(sp)
    80003c22:	6942                	ld	s2,16(sp)
    80003c24:	69a2                	ld	s3,8(sp)
    80003c26:	6145                	addi	sp,sp,48
    80003c28:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c2a:	6908                	ld	a0,16(a0)
    80003c2c:	00000097          	auipc	ra,0x0
    80003c30:	3c8080e7          	jalr	968(ra) # 80003ff4 <piperead>
    80003c34:	892a                	mv	s2,a0
    80003c36:	b7d5                	j	80003c1a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c38:	02451783          	lh	a5,36(a0)
    80003c3c:	03079693          	slli	a3,a5,0x30
    80003c40:	92c1                	srli	a3,a3,0x30
    80003c42:	4725                	li	a4,9
    80003c44:	02d76863          	bltu	a4,a3,80003c74 <fileread+0xba>
    80003c48:	0792                	slli	a5,a5,0x4
    80003c4a:	00015717          	auipc	a4,0x15
    80003c4e:	67e70713          	addi	a4,a4,1662 # 800192c8 <devsw>
    80003c52:	97ba                	add	a5,a5,a4
    80003c54:	639c                	ld	a5,0(a5)
    80003c56:	c38d                	beqz	a5,80003c78 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c58:	4505                	li	a0,1
    80003c5a:	9782                	jalr	a5
    80003c5c:	892a                	mv	s2,a0
    80003c5e:	bf75                	j	80003c1a <fileread+0x60>
    panic("fileread");
    80003c60:	00005517          	auipc	a0,0x5
    80003c64:	a9850513          	addi	a0,a0,-1384 # 800086f8 <syscalls+0x268>
    80003c68:	00002097          	auipc	ra,0x2
    80003c6c:	030080e7          	jalr	48(ra) # 80005c98 <panic>
    return -1;
    80003c70:	597d                	li	s2,-1
    80003c72:	b765                	j	80003c1a <fileread+0x60>
      return -1;
    80003c74:	597d                	li	s2,-1
    80003c76:	b755                	j	80003c1a <fileread+0x60>
    80003c78:	597d                	li	s2,-1
    80003c7a:	b745                	j	80003c1a <fileread+0x60>

0000000080003c7c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c7c:	715d                	addi	sp,sp,-80
    80003c7e:	e486                	sd	ra,72(sp)
    80003c80:	e0a2                	sd	s0,64(sp)
    80003c82:	fc26                	sd	s1,56(sp)
    80003c84:	f84a                	sd	s2,48(sp)
    80003c86:	f44e                	sd	s3,40(sp)
    80003c88:	f052                	sd	s4,32(sp)
    80003c8a:	ec56                	sd	s5,24(sp)
    80003c8c:	e85a                	sd	s6,16(sp)
    80003c8e:	e45e                	sd	s7,8(sp)
    80003c90:	e062                	sd	s8,0(sp)
    80003c92:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c94:	00954783          	lbu	a5,9(a0)
    80003c98:	10078663          	beqz	a5,80003da4 <filewrite+0x128>
    80003c9c:	892a                	mv	s2,a0
    80003c9e:	8aae                	mv	s5,a1
    80003ca0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca2:	411c                	lw	a5,0(a0)
    80003ca4:	4705                	li	a4,1
    80003ca6:	02e78263          	beq	a5,a4,80003cca <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003caa:	470d                	li	a4,3
    80003cac:	02e78663          	beq	a5,a4,80003cd8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb0:	4709                	li	a4,2
    80003cb2:	0ee79163          	bne	a5,a4,80003d94 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cb6:	0ac05d63          	blez	a2,80003d70 <filewrite+0xf4>
    int i = 0;
    80003cba:	4981                	li	s3,0
    80003cbc:	6b05                	lui	s6,0x1
    80003cbe:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cc2:	6b85                	lui	s7,0x1
    80003cc4:	c00b8b9b          	addiw	s7,s7,-1024
    80003cc8:	a861                	j	80003d60 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cca:	6908                	ld	a0,16(a0)
    80003ccc:	00000097          	auipc	ra,0x0
    80003cd0:	22e080e7          	jalr	558(ra) # 80003efa <pipewrite>
    80003cd4:	8a2a                	mv	s4,a0
    80003cd6:	a045                	j	80003d76 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cd8:	02451783          	lh	a5,36(a0)
    80003cdc:	03079693          	slli	a3,a5,0x30
    80003ce0:	92c1                	srli	a3,a3,0x30
    80003ce2:	4725                	li	a4,9
    80003ce4:	0cd76263          	bltu	a4,a3,80003da8 <filewrite+0x12c>
    80003ce8:	0792                	slli	a5,a5,0x4
    80003cea:	00015717          	auipc	a4,0x15
    80003cee:	5de70713          	addi	a4,a4,1502 # 800192c8 <devsw>
    80003cf2:	97ba                	add	a5,a5,a4
    80003cf4:	679c                	ld	a5,8(a5)
    80003cf6:	cbdd                	beqz	a5,80003dac <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cf8:	4505                	li	a0,1
    80003cfa:	9782                	jalr	a5
    80003cfc:	8a2a                	mv	s4,a0
    80003cfe:	a8a5                	j	80003d76 <filewrite+0xfa>
    80003d00:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	8b0080e7          	jalr	-1872(ra) # 800035b4 <begin_op>
      ilock(f->ip);
    80003d0c:	01893503          	ld	a0,24(s2)
    80003d10:	fffff097          	auipc	ra,0xfffff
    80003d14:	ed2080e7          	jalr	-302(ra) # 80002be2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d18:	8762                	mv	a4,s8
    80003d1a:	02092683          	lw	a3,32(s2)
    80003d1e:	01598633          	add	a2,s3,s5
    80003d22:	4585                	li	a1,1
    80003d24:	01893503          	ld	a0,24(s2)
    80003d28:	fffff097          	auipc	ra,0xfffff
    80003d2c:	266080e7          	jalr	614(ra) # 80002f8e <writei>
    80003d30:	84aa                	mv	s1,a0
    80003d32:	00a05763          	blez	a0,80003d40 <filewrite+0xc4>
        f->off += r;
    80003d36:	02092783          	lw	a5,32(s2)
    80003d3a:	9fa9                	addw	a5,a5,a0
    80003d3c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d40:	01893503          	ld	a0,24(s2)
    80003d44:	fffff097          	auipc	ra,0xfffff
    80003d48:	f60080e7          	jalr	-160(ra) # 80002ca4 <iunlock>
      end_op();
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	8e8080e7          	jalr	-1816(ra) # 80003634 <end_op>

      if(r != n1){
    80003d54:	009c1f63          	bne	s8,s1,80003d72 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d58:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d5c:	0149db63          	bge	s3,s4,80003d72 <filewrite+0xf6>
      int n1 = n - i;
    80003d60:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d64:	84be                	mv	s1,a5
    80003d66:	2781                	sext.w	a5,a5
    80003d68:	f8fb5ce3          	bge	s6,a5,80003d00 <filewrite+0x84>
    80003d6c:	84de                	mv	s1,s7
    80003d6e:	bf49                	j	80003d00 <filewrite+0x84>
    int i = 0;
    80003d70:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d72:	013a1f63          	bne	s4,s3,80003d90 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d76:	8552                	mv	a0,s4
    80003d78:	60a6                	ld	ra,72(sp)
    80003d7a:	6406                	ld	s0,64(sp)
    80003d7c:	74e2                	ld	s1,56(sp)
    80003d7e:	7942                	ld	s2,48(sp)
    80003d80:	79a2                	ld	s3,40(sp)
    80003d82:	7a02                	ld	s4,32(sp)
    80003d84:	6ae2                	ld	s5,24(sp)
    80003d86:	6b42                	ld	s6,16(sp)
    80003d88:	6ba2                	ld	s7,8(sp)
    80003d8a:	6c02                	ld	s8,0(sp)
    80003d8c:	6161                	addi	sp,sp,80
    80003d8e:	8082                	ret
    ret = (i == n ? n : -1);
    80003d90:	5a7d                	li	s4,-1
    80003d92:	b7d5                	j	80003d76 <filewrite+0xfa>
    panic("filewrite");
    80003d94:	00005517          	auipc	a0,0x5
    80003d98:	97450513          	addi	a0,a0,-1676 # 80008708 <syscalls+0x278>
    80003d9c:	00002097          	auipc	ra,0x2
    80003da0:	efc080e7          	jalr	-260(ra) # 80005c98 <panic>
    return -1;
    80003da4:	5a7d                	li	s4,-1
    80003da6:	bfc1                	j	80003d76 <filewrite+0xfa>
      return -1;
    80003da8:	5a7d                	li	s4,-1
    80003daa:	b7f1                	j	80003d76 <filewrite+0xfa>
    80003dac:	5a7d                	li	s4,-1
    80003dae:	b7e1                	j	80003d76 <filewrite+0xfa>

0000000080003db0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003db0:	7179                	addi	sp,sp,-48
    80003db2:	f406                	sd	ra,40(sp)
    80003db4:	f022                	sd	s0,32(sp)
    80003db6:	ec26                	sd	s1,24(sp)
    80003db8:	e84a                	sd	s2,16(sp)
    80003dba:	e44e                	sd	s3,8(sp)
    80003dbc:	e052                	sd	s4,0(sp)
    80003dbe:	1800                	addi	s0,sp,48
    80003dc0:	84aa                	mv	s1,a0
    80003dc2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dc4:	0005b023          	sd	zero,0(a1)
    80003dc8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dcc:	00000097          	auipc	ra,0x0
    80003dd0:	bf8080e7          	jalr	-1032(ra) # 800039c4 <filealloc>
    80003dd4:	e088                	sd	a0,0(s1)
    80003dd6:	c551                	beqz	a0,80003e62 <pipealloc+0xb2>
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	bec080e7          	jalr	-1044(ra) # 800039c4 <filealloc>
    80003de0:	00aa3023          	sd	a0,0(s4)
    80003de4:	c92d                	beqz	a0,80003e56 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003de6:	ffffc097          	auipc	ra,0xffffc
    80003dea:	332080e7          	jalr	818(ra) # 80000118 <kalloc>
    80003dee:	892a                	mv	s2,a0
    80003df0:	c125                	beqz	a0,80003e50 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003df2:	4985                	li	s3,1
    80003df4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003df8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dfc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e00:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e04:	00004597          	auipc	a1,0x4
    80003e08:	5dc58593          	addi	a1,a1,1500 # 800083e0 <states.1714+0x1a0>
    80003e0c:	00002097          	auipc	ra,0x2
    80003e10:	346080e7          	jalr	838(ra) # 80006152 <initlock>
  (*f0)->type = FD_PIPE;
    80003e14:	609c                	ld	a5,0(s1)
    80003e16:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e1a:	609c                	ld	a5,0(s1)
    80003e1c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e20:	609c                	ld	a5,0(s1)
    80003e22:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e26:	609c                	ld	a5,0(s1)
    80003e28:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e2c:	000a3783          	ld	a5,0(s4)
    80003e30:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e34:	000a3783          	ld	a5,0(s4)
    80003e38:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e3c:	000a3783          	ld	a5,0(s4)
    80003e40:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e44:	000a3783          	ld	a5,0(s4)
    80003e48:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e4c:	4501                	li	a0,0
    80003e4e:	a025                	j	80003e76 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e50:	6088                	ld	a0,0(s1)
    80003e52:	e501                	bnez	a0,80003e5a <pipealloc+0xaa>
    80003e54:	a039                	j	80003e62 <pipealloc+0xb2>
    80003e56:	6088                	ld	a0,0(s1)
    80003e58:	c51d                	beqz	a0,80003e86 <pipealloc+0xd6>
    fileclose(*f0);
    80003e5a:	00000097          	auipc	ra,0x0
    80003e5e:	c26080e7          	jalr	-986(ra) # 80003a80 <fileclose>
  if(*f1)
    80003e62:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e66:	557d                	li	a0,-1
  if(*f1)
    80003e68:	c799                	beqz	a5,80003e76 <pipealloc+0xc6>
    fileclose(*f1);
    80003e6a:	853e                	mv	a0,a5
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	c14080e7          	jalr	-1004(ra) # 80003a80 <fileclose>
  return -1;
    80003e74:	557d                	li	a0,-1
}
    80003e76:	70a2                	ld	ra,40(sp)
    80003e78:	7402                	ld	s0,32(sp)
    80003e7a:	64e2                	ld	s1,24(sp)
    80003e7c:	6942                	ld	s2,16(sp)
    80003e7e:	69a2                	ld	s3,8(sp)
    80003e80:	6a02                	ld	s4,0(sp)
    80003e82:	6145                	addi	sp,sp,48
    80003e84:	8082                	ret
  return -1;
    80003e86:	557d                	li	a0,-1
    80003e88:	b7fd                	j	80003e76 <pipealloc+0xc6>

0000000080003e8a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e8a:	1101                	addi	sp,sp,-32
    80003e8c:	ec06                	sd	ra,24(sp)
    80003e8e:	e822                	sd	s0,16(sp)
    80003e90:	e426                	sd	s1,8(sp)
    80003e92:	e04a                	sd	s2,0(sp)
    80003e94:	1000                	addi	s0,sp,32
    80003e96:	84aa                	mv	s1,a0
    80003e98:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e9a:	00002097          	auipc	ra,0x2
    80003e9e:	348080e7          	jalr	840(ra) # 800061e2 <acquire>
  if(writable){
    80003ea2:	02090d63          	beqz	s2,80003edc <pipeclose+0x52>
    pi->writeopen = 0;
    80003ea6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eaa:	21848513          	addi	a0,s1,536
    80003eae:	ffffe097          	auipc	ra,0xffffe
    80003eb2:	834080e7          	jalr	-1996(ra) # 800016e2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eb6:	2204b783          	ld	a5,544(s1)
    80003eba:	eb95                	bnez	a5,80003eee <pipeclose+0x64>
    release(&pi->lock);
    80003ebc:	8526                	mv	a0,s1
    80003ebe:	00002097          	auipc	ra,0x2
    80003ec2:	3d8080e7          	jalr	984(ra) # 80006296 <release>
    kfree((char*)pi);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	ffffc097          	auipc	ra,0xffffc
    80003ecc:	154080e7          	jalr	340(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ed0:	60e2                	ld	ra,24(sp)
    80003ed2:	6442                	ld	s0,16(sp)
    80003ed4:	64a2                	ld	s1,8(sp)
    80003ed6:	6902                	ld	s2,0(sp)
    80003ed8:	6105                	addi	sp,sp,32
    80003eda:	8082                	ret
    pi->readopen = 0;
    80003edc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ee0:	21c48513          	addi	a0,s1,540
    80003ee4:	ffffd097          	auipc	ra,0xffffd
    80003ee8:	7fe080e7          	jalr	2046(ra) # 800016e2 <wakeup>
    80003eec:	b7e9                	j	80003eb6 <pipeclose+0x2c>
    release(&pi->lock);
    80003eee:	8526                	mv	a0,s1
    80003ef0:	00002097          	auipc	ra,0x2
    80003ef4:	3a6080e7          	jalr	934(ra) # 80006296 <release>
}
    80003ef8:	bfe1                	j	80003ed0 <pipeclose+0x46>

0000000080003efa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003efa:	7159                	addi	sp,sp,-112
    80003efc:	f486                	sd	ra,104(sp)
    80003efe:	f0a2                	sd	s0,96(sp)
    80003f00:	eca6                	sd	s1,88(sp)
    80003f02:	e8ca                	sd	s2,80(sp)
    80003f04:	e4ce                	sd	s3,72(sp)
    80003f06:	e0d2                	sd	s4,64(sp)
    80003f08:	fc56                	sd	s5,56(sp)
    80003f0a:	f85a                	sd	s6,48(sp)
    80003f0c:	f45e                	sd	s7,40(sp)
    80003f0e:	f062                	sd	s8,32(sp)
    80003f10:	ec66                	sd	s9,24(sp)
    80003f12:	1880                	addi	s0,sp,112
    80003f14:	84aa                	mv	s1,a0
    80003f16:	8aae                	mv	s5,a1
    80003f18:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f1a:	ffffd097          	auipc	ra,0xffffd
    80003f1e:	f78080e7          	jalr	-136(ra) # 80000e92 <myproc>
    80003f22:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f24:	8526                	mv	a0,s1
    80003f26:	00002097          	auipc	ra,0x2
    80003f2a:	2bc080e7          	jalr	700(ra) # 800061e2 <acquire>
  while(i < n){
    80003f2e:	0d405163          	blez	s4,80003ff0 <pipewrite+0xf6>
    80003f32:	8ba6                	mv	s7,s1
  int i = 0;
    80003f34:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f36:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f38:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f3c:	21c48c13          	addi	s8,s1,540
    80003f40:	a08d                	j	80003fa2 <pipewrite+0xa8>
      release(&pi->lock);
    80003f42:	8526                	mv	a0,s1
    80003f44:	00002097          	auipc	ra,0x2
    80003f48:	352080e7          	jalr	850(ra) # 80006296 <release>
      return -1;
    80003f4c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f4e:	854a                	mv	a0,s2
    80003f50:	70a6                	ld	ra,104(sp)
    80003f52:	7406                	ld	s0,96(sp)
    80003f54:	64e6                	ld	s1,88(sp)
    80003f56:	6946                	ld	s2,80(sp)
    80003f58:	69a6                	ld	s3,72(sp)
    80003f5a:	6a06                	ld	s4,64(sp)
    80003f5c:	7ae2                	ld	s5,56(sp)
    80003f5e:	7b42                	ld	s6,48(sp)
    80003f60:	7ba2                	ld	s7,40(sp)
    80003f62:	7c02                	ld	s8,32(sp)
    80003f64:	6ce2                	ld	s9,24(sp)
    80003f66:	6165                	addi	sp,sp,112
    80003f68:	8082                	ret
      wakeup(&pi->nread);
    80003f6a:	8566                	mv	a0,s9
    80003f6c:	ffffd097          	auipc	ra,0xffffd
    80003f70:	776080e7          	jalr	1910(ra) # 800016e2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f74:	85de                	mv	a1,s7
    80003f76:	8562                	mv	a0,s8
    80003f78:	ffffd097          	auipc	ra,0xffffd
    80003f7c:	5de080e7          	jalr	1502(ra) # 80001556 <sleep>
    80003f80:	a839                	j	80003f9e <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f82:	21c4a783          	lw	a5,540(s1)
    80003f86:	0017871b          	addiw	a4,a5,1
    80003f8a:	20e4ae23          	sw	a4,540(s1)
    80003f8e:	1ff7f793          	andi	a5,a5,511
    80003f92:	97a6                	add	a5,a5,s1
    80003f94:	f9f44703          	lbu	a4,-97(s0)
    80003f98:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f9c:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f9e:	03495d63          	bge	s2,s4,80003fd8 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003fa2:	2204a783          	lw	a5,544(s1)
    80003fa6:	dfd1                	beqz	a5,80003f42 <pipewrite+0x48>
    80003fa8:	0289a783          	lw	a5,40(s3)
    80003fac:	fbd9                	bnez	a5,80003f42 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fae:	2184a783          	lw	a5,536(s1)
    80003fb2:	21c4a703          	lw	a4,540(s1)
    80003fb6:	2007879b          	addiw	a5,a5,512
    80003fba:	faf708e3          	beq	a4,a5,80003f6a <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fbe:	4685                	li	a3,1
    80003fc0:	01590633          	add	a2,s2,s5
    80003fc4:	f9f40593          	addi	a1,s0,-97
    80003fc8:	0589b503          	ld	a0,88(s3)
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	c14080e7          	jalr	-1004(ra) # 80000be0 <copyin>
    80003fd4:	fb6517e3          	bne	a0,s6,80003f82 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fd8:	21848513          	addi	a0,s1,536
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	706080e7          	jalr	1798(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	00002097          	auipc	ra,0x2
    80003fea:	2b0080e7          	jalr	688(ra) # 80006296 <release>
  return i;
    80003fee:	b785                	j	80003f4e <pipewrite+0x54>
  int i = 0;
    80003ff0:	4901                	li	s2,0
    80003ff2:	b7dd                	j	80003fd8 <pipewrite+0xde>

0000000080003ff4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ff4:	715d                	addi	sp,sp,-80
    80003ff6:	e486                	sd	ra,72(sp)
    80003ff8:	e0a2                	sd	s0,64(sp)
    80003ffa:	fc26                	sd	s1,56(sp)
    80003ffc:	f84a                	sd	s2,48(sp)
    80003ffe:	f44e                	sd	s3,40(sp)
    80004000:	f052                	sd	s4,32(sp)
    80004002:	ec56                	sd	s5,24(sp)
    80004004:	e85a                	sd	s6,16(sp)
    80004006:	0880                	addi	s0,sp,80
    80004008:	84aa                	mv	s1,a0
    8000400a:	892e                	mv	s2,a1
    8000400c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	e84080e7          	jalr	-380(ra) # 80000e92 <myproc>
    80004016:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004018:	8b26                	mv	s6,s1
    8000401a:	8526                	mv	a0,s1
    8000401c:	00002097          	auipc	ra,0x2
    80004020:	1c6080e7          	jalr	454(ra) # 800061e2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004024:	2184a703          	lw	a4,536(s1)
    80004028:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000402c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004030:	02f71463          	bne	a4,a5,80004058 <piperead+0x64>
    80004034:	2244a783          	lw	a5,548(s1)
    80004038:	c385                	beqz	a5,80004058 <piperead+0x64>
    if(pr->killed){
    8000403a:	028a2783          	lw	a5,40(s4)
    8000403e:	ebc1                	bnez	a5,800040ce <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004040:	85da                	mv	a1,s6
    80004042:	854e                	mv	a0,s3
    80004044:	ffffd097          	auipc	ra,0xffffd
    80004048:	512080e7          	jalr	1298(ra) # 80001556 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000404c:	2184a703          	lw	a4,536(s1)
    80004050:	21c4a783          	lw	a5,540(s1)
    80004054:	fef700e3          	beq	a4,a5,80004034 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004058:	09505263          	blez	s5,800040dc <piperead+0xe8>
    8000405c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000405e:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004060:	2184a783          	lw	a5,536(s1)
    80004064:	21c4a703          	lw	a4,540(s1)
    80004068:	02f70d63          	beq	a4,a5,800040a2 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000406c:	0017871b          	addiw	a4,a5,1
    80004070:	20e4ac23          	sw	a4,536(s1)
    80004074:	1ff7f793          	andi	a5,a5,511
    80004078:	97a6                	add	a5,a5,s1
    8000407a:	0187c783          	lbu	a5,24(a5)
    8000407e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004082:	4685                	li	a3,1
    80004084:	fbf40613          	addi	a2,s0,-65
    80004088:	85ca                	mv	a1,s2
    8000408a:	058a3503          	ld	a0,88(s4)
    8000408e:	ffffd097          	auipc	ra,0xffffd
    80004092:	ac6080e7          	jalr	-1338(ra) # 80000b54 <copyout>
    80004096:	01650663          	beq	a0,s6,800040a2 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000409a:	2985                	addiw	s3,s3,1
    8000409c:	0905                	addi	s2,s2,1
    8000409e:	fd3a91e3          	bne	s5,s3,80004060 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040a2:	21c48513          	addi	a0,s1,540
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	63c080e7          	jalr	1596(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    800040ae:	8526                	mv	a0,s1
    800040b0:	00002097          	auipc	ra,0x2
    800040b4:	1e6080e7          	jalr	486(ra) # 80006296 <release>
  return i;
}
    800040b8:	854e                	mv	a0,s3
    800040ba:	60a6                	ld	ra,72(sp)
    800040bc:	6406                	ld	s0,64(sp)
    800040be:	74e2                	ld	s1,56(sp)
    800040c0:	7942                	ld	s2,48(sp)
    800040c2:	79a2                	ld	s3,40(sp)
    800040c4:	7a02                	ld	s4,32(sp)
    800040c6:	6ae2                	ld	s5,24(sp)
    800040c8:	6b42                	ld	s6,16(sp)
    800040ca:	6161                	addi	sp,sp,80
    800040cc:	8082                	ret
      release(&pi->lock);
    800040ce:	8526                	mv	a0,s1
    800040d0:	00002097          	auipc	ra,0x2
    800040d4:	1c6080e7          	jalr	454(ra) # 80006296 <release>
      return -1;
    800040d8:	59fd                	li	s3,-1
    800040da:	bff9                	j	800040b8 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040dc:	4981                	li	s3,0
    800040de:	b7d1                	j	800040a2 <piperead+0xae>

00000000800040e0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040e0:	df010113          	addi	sp,sp,-528
    800040e4:	20113423          	sd	ra,520(sp)
    800040e8:	20813023          	sd	s0,512(sp)
    800040ec:	ffa6                	sd	s1,504(sp)
    800040ee:	fbca                	sd	s2,496(sp)
    800040f0:	f7ce                	sd	s3,488(sp)
    800040f2:	f3d2                	sd	s4,480(sp)
    800040f4:	efd6                	sd	s5,472(sp)
    800040f6:	ebda                	sd	s6,464(sp)
    800040f8:	e7de                	sd	s7,456(sp)
    800040fa:	e3e2                	sd	s8,448(sp)
    800040fc:	ff66                	sd	s9,440(sp)
    800040fe:	fb6a                	sd	s10,432(sp)
    80004100:	f76e                	sd	s11,424(sp)
    80004102:	0c00                	addi	s0,sp,528
    80004104:	84aa                	mv	s1,a0
    80004106:	dea43c23          	sd	a0,-520(s0)
    8000410a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000410e:	ffffd097          	auipc	ra,0xffffd
    80004112:	d84080e7          	jalr	-636(ra) # 80000e92 <myproc>
    80004116:	892a                	mv	s2,a0

  begin_op();
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	49c080e7          	jalr	1180(ra) # 800035b4 <begin_op>

  if((ip = namei(path)) == 0){
    80004120:	8526                	mv	a0,s1
    80004122:	fffff097          	auipc	ra,0xfffff
    80004126:	276080e7          	jalr	630(ra) # 80003398 <namei>
    8000412a:	c92d                	beqz	a0,8000419c <exec+0xbc>
    8000412c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000412e:	fffff097          	auipc	ra,0xfffff
    80004132:	ab4080e7          	jalr	-1356(ra) # 80002be2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004136:	04000713          	li	a4,64
    8000413a:	4681                	li	a3,0
    8000413c:	e5040613          	addi	a2,s0,-432
    80004140:	4581                	li	a1,0
    80004142:	8526                	mv	a0,s1
    80004144:	fffff097          	auipc	ra,0xfffff
    80004148:	d52080e7          	jalr	-686(ra) # 80002e96 <readi>
    8000414c:	04000793          	li	a5,64
    80004150:	00f51a63          	bne	a0,a5,80004164 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004154:	e5042703          	lw	a4,-432(s0)
    80004158:	464c47b7          	lui	a5,0x464c4
    8000415c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004160:	04f70463          	beq	a4,a5,800041a8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004164:	8526                	mv	a0,s1
    80004166:	fffff097          	auipc	ra,0xfffff
    8000416a:	cde080e7          	jalr	-802(ra) # 80002e44 <iunlockput>
    end_op();
    8000416e:	fffff097          	auipc	ra,0xfffff
    80004172:	4c6080e7          	jalr	1222(ra) # 80003634 <end_op>
  }
  return -1;
    80004176:	557d                	li	a0,-1
}
    80004178:	20813083          	ld	ra,520(sp)
    8000417c:	20013403          	ld	s0,512(sp)
    80004180:	74fe                	ld	s1,504(sp)
    80004182:	795e                	ld	s2,496(sp)
    80004184:	79be                	ld	s3,488(sp)
    80004186:	7a1e                	ld	s4,480(sp)
    80004188:	6afe                	ld	s5,472(sp)
    8000418a:	6b5e                	ld	s6,464(sp)
    8000418c:	6bbe                	ld	s7,456(sp)
    8000418e:	6c1e                	ld	s8,448(sp)
    80004190:	7cfa                	ld	s9,440(sp)
    80004192:	7d5a                	ld	s10,432(sp)
    80004194:	7dba                	ld	s11,424(sp)
    80004196:	21010113          	addi	sp,sp,528
    8000419a:	8082                	ret
    end_op();
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	498080e7          	jalr	1176(ra) # 80003634 <end_op>
    return -1;
    800041a4:	557d                	li	a0,-1
    800041a6:	bfc9                	j	80004178 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041a8:	854a                	mv	a0,s2
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	dac080e7          	jalr	-596(ra) # 80000f56 <proc_pagetable>
    800041b2:	8baa                	mv	s7,a0
    800041b4:	d945                	beqz	a0,80004164 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b6:	e7042983          	lw	s3,-400(s0)
    800041ba:	e8845783          	lhu	a5,-376(s0)
    800041be:	c7ad                	beqz	a5,80004228 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041c0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041c2:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041c4:	6c85                	lui	s9,0x1
    800041c6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041ca:	def43823          	sd	a5,-528(s0)
    800041ce:	a42d                	j	800043f8 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041d0:	00004517          	auipc	a0,0x4
    800041d4:	54850513          	addi	a0,a0,1352 # 80008718 <syscalls+0x288>
    800041d8:	00002097          	auipc	ra,0x2
    800041dc:	ac0080e7          	jalr	-1344(ra) # 80005c98 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041e0:	8756                	mv	a4,s5
    800041e2:	012d86bb          	addw	a3,s11,s2
    800041e6:	4581                	li	a1,0
    800041e8:	8526                	mv	a0,s1
    800041ea:	fffff097          	auipc	ra,0xfffff
    800041ee:	cac080e7          	jalr	-852(ra) # 80002e96 <readi>
    800041f2:	2501                	sext.w	a0,a0
    800041f4:	1aaa9963          	bne	s5,a0,800043a6 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041f8:	6785                	lui	a5,0x1
    800041fa:	0127893b          	addw	s2,a5,s2
    800041fe:	77fd                	lui	a5,0xfffff
    80004200:	01478a3b          	addw	s4,a5,s4
    80004204:	1f897163          	bgeu	s2,s8,800043e6 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004208:	02091593          	slli	a1,s2,0x20
    8000420c:	9181                	srli	a1,a1,0x20
    8000420e:	95ea                	add	a1,a1,s10
    80004210:	855e                	mv	a0,s7
    80004212:	ffffc097          	auipc	ra,0xffffc
    80004216:	33e080e7          	jalr	830(ra) # 80000550 <walkaddr>
    8000421a:	862a                	mv	a2,a0
    if(pa == 0)
    8000421c:	d955                	beqz	a0,800041d0 <exec+0xf0>
      n = PGSIZE;
    8000421e:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004220:	fd9a70e3          	bgeu	s4,s9,800041e0 <exec+0x100>
      n = sz - i;
    80004224:	8ad2                	mv	s5,s4
    80004226:	bf6d                	j	800041e0 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004228:	4901                	li	s2,0
  iunlockput(ip);
    8000422a:	8526                	mv	a0,s1
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	c18080e7          	jalr	-1000(ra) # 80002e44 <iunlockput>
  end_op();
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	400080e7          	jalr	1024(ra) # 80003634 <end_op>
  p = myproc();
    8000423c:	ffffd097          	auipc	ra,0xffffd
    80004240:	c56080e7          	jalr	-938(ra) # 80000e92 <myproc>
    80004244:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004246:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    8000424a:	6785                	lui	a5,0x1
    8000424c:	17fd                	addi	a5,a5,-1
    8000424e:	993e                	add	s2,s2,a5
    80004250:	757d                	lui	a0,0xfffff
    80004252:	00a977b3          	and	a5,s2,a0
    80004256:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000425a:	6609                	lui	a2,0x2
    8000425c:	963e                	add	a2,a2,a5
    8000425e:	85be                	mv	a1,a5
    80004260:	855e                	mv	a0,s7
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	6a2080e7          	jalr	1698(ra) # 80000904 <uvmalloc>
    8000426a:	8b2a                	mv	s6,a0
  ip = 0;
    8000426c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000426e:	12050c63          	beqz	a0,800043a6 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004272:	75f9                	lui	a1,0xffffe
    80004274:	95aa                	add	a1,a1,a0
    80004276:	855e                	mv	a0,s7
    80004278:	ffffd097          	auipc	ra,0xffffd
    8000427c:	8aa080e7          	jalr	-1878(ra) # 80000b22 <uvmclear>
  stackbase = sp - PGSIZE;
    80004280:	7c7d                	lui	s8,0xfffff
    80004282:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004284:	e0043783          	ld	a5,-512(s0)
    80004288:	6388                	ld	a0,0(a5)
    8000428a:	c535                	beqz	a0,800042f6 <exec+0x216>
    8000428c:	e9040993          	addi	s3,s0,-368
    80004290:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004294:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004296:	ffffc097          	auipc	ra,0xffffc
    8000429a:	0b0080e7          	jalr	176(ra) # 80000346 <strlen>
    8000429e:	2505                	addiw	a0,a0,1
    800042a0:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042a4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042a8:	13896363          	bltu	s2,s8,800043ce <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042ac:	e0043d83          	ld	s11,-512(s0)
    800042b0:	000dba03          	ld	s4,0(s11)
    800042b4:	8552                	mv	a0,s4
    800042b6:	ffffc097          	auipc	ra,0xffffc
    800042ba:	090080e7          	jalr	144(ra) # 80000346 <strlen>
    800042be:	0015069b          	addiw	a3,a0,1
    800042c2:	8652                	mv	a2,s4
    800042c4:	85ca                	mv	a1,s2
    800042c6:	855e                	mv	a0,s7
    800042c8:	ffffd097          	auipc	ra,0xffffd
    800042cc:	88c080e7          	jalr	-1908(ra) # 80000b54 <copyout>
    800042d0:	10054363          	bltz	a0,800043d6 <exec+0x2f6>
    ustack[argc] = sp;
    800042d4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042d8:	0485                	addi	s1,s1,1
    800042da:	008d8793          	addi	a5,s11,8
    800042de:	e0f43023          	sd	a5,-512(s0)
    800042e2:	008db503          	ld	a0,8(s11)
    800042e6:	c911                	beqz	a0,800042fa <exec+0x21a>
    if(argc >= MAXARG)
    800042e8:	09a1                	addi	s3,s3,8
    800042ea:	fb3c96e3          	bne	s9,s3,80004296 <exec+0x1b6>
  sz = sz1;
    800042ee:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042f2:	4481                	li	s1,0
    800042f4:	a84d                	j	800043a6 <exec+0x2c6>
  sp = sz;
    800042f6:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042f8:	4481                	li	s1,0
  ustack[argc] = 0;
    800042fa:	00349793          	slli	a5,s1,0x3
    800042fe:	f9040713          	addi	a4,s0,-112
    80004302:	97ba                	add	a5,a5,a4
    80004304:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004308:	00148693          	addi	a3,s1,1
    8000430c:	068e                	slli	a3,a3,0x3
    8000430e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004312:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004316:	01897663          	bgeu	s2,s8,80004322 <exec+0x242>
  sz = sz1;
    8000431a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000431e:	4481                	li	s1,0
    80004320:	a059                	j	800043a6 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004322:	e9040613          	addi	a2,s0,-368
    80004326:	85ca                	mv	a1,s2
    80004328:	855e                	mv	a0,s7
    8000432a:	ffffd097          	auipc	ra,0xffffd
    8000432e:	82a080e7          	jalr	-2006(ra) # 80000b54 <copyout>
    80004332:	0a054663          	bltz	a0,800043de <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004336:	060ab783          	ld	a5,96(s5)
    8000433a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000433e:	df843783          	ld	a5,-520(s0)
    80004342:	0007c703          	lbu	a4,0(a5)
    80004346:	cf11                	beqz	a4,80004362 <exec+0x282>
    80004348:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000434a:	02f00693          	li	a3,47
    8000434e:	a039                	j	8000435c <exec+0x27c>
      last = s+1;
    80004350:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004354:	0785                	addi	a5,a5,1
    80004356:	fff7c703          	lbu	a4,-1(a5)
    8000435a:	c701                	beqz	a4,80004362 <exec+0x282>
    if(*s == '/')
    8000435c:	fed71ce3          	bne	a4,a3,80004354 <exec+0x274>
    80004360:	bfc5                	j	80004350 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004362:	4641                	li	a2,16
    80004364:	df843583          	ld	a1,-520(s0)
    80004368:	160a8513          	addi	a0,s5,352
    8000436c:	ffffc097          	auipc	ra,0xffffc
    80004370:	fa8080e7          	jalr	-88(ra) # 80000314 <safestrcpy>
  oldpagetable = p->pagetable;
    80004374:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004378:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    8000437c:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004380:	060ab783          	ld	a5,96(s5)
    80004384:	e6843703          	ld	a4,-408(s0)
    80004388:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000438a:	060ab783          	ld	a5,96(s5)
    8000438e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004392:	85ea                	mv	a1,s10
    80004394:	ffffd097          	auipc	ra,0xffffd
    80004398:	c5e080e7          	jalr	-930(ra) # 80000ff2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000439c:	0004851b          	sext.w	a0,s1
    800043a0:	bbe1                	j	80004178 <exec+0x98>
    800043a2:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043a6:	e0843583          	ld	a1,-504(s0)
    800043aa:	855e                	mv	a0,s7
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	c46080e7          	jalr	-954(ra) # 80000ff2 <proc_freepagetable>
  if(ip){
    800043b4:	da0498e3          	bnez	s1,80004164 <exec+0x84>
  return -1;
    800043b8:	557d                	li	a0,-1
    800043ba:	bb7d                	j	80004178 <exec+0x98>
    800043bc:	e1243423          	sd	s2,-504(s0)
    800043c0:	b7dd                	j	800043a6 <exec+0x2c6>
    800043c2:	e1243423          	sd	s2,-504(s0)
    800043c6:	b7c5                	j	800043a6 <exec+0x2c6>
    800043c8:	e1243423          	sd	s2,-504(s0)
    800043cc:	bfe9                	j	800043a6 <exec+0x2c6>
  sz = sz1;
    800043ce:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d2:	4481                	li	s1,0
    800043d4:	bfc9                	j	800043a6 <exec+0x2c6>
  sz = sz1;
    800043d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043da:	4481                	li	s1,0
    800043dc:	b7e9                	j	800043a6 <exec+0x2c6>
  sz = sz1;
    800043de:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e2:	4481                	li	s1,0
    800043e4:	b7c9                	j	800043a6 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043e6:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ea:	2b05                	addiw	s6,s6,1
    800043ec:	0389899b          	addiw	s3,s3,56
    800043f0:	e8845783          	lhu	a5,-376(s0)
    800043f4:	e2fb5be3          	bge	s6,a5,8000422a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043f8:	2981                	sext.w	s3,s3
    800043fa:	03800713          	li	a4,56
    800043fe:	86ce                	mv	a3,s3
    80004400:	e1840613          	addi	a2,s0,-488
    80004404:	4581                	li	a1,0
    80004406:	8526                	mv	a0,s1
    80004408:	fffff097          	auipc	ra,0xfffff
    8000440c:	a8e080e7          	jalr	-1394(ra) # 80002e96 <readi>
    80004410:	03800793          	li	a5,56
    80004414:	f8f517e3          	bne	a0,a5,800043a2 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004418:	e1842783          	lw	a5,-488(s0)
    8000441c:	4705                	li	a4,1
    8000441e:	fce796e3          	bne	a5,a4,800043ea <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004422:	e4043603          	ld	a2,-448(s0)
    80004426:	e3843783          	ld	a5,-456(s0)
    8000442a:	f8f669e3          	bltu	a2,a5,800043bc <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000442e:	e2843783          	ld	a5,-472(s0)
    80004432:	963e                	add	a2,a2,a5
    80004434:	f8f667e3          	bltu	a2,a5,800043c2 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004438:	85ca                	mv	a1,s2
    8000443a:	855e                	mv	a0,s7
    8000443c:	ffffc097          	auipc	ra,0xffffc
    80004440:	4c8080e7          	jalr	1224(ra) # 80000904 <uvmalloc>
    80004444:	e0a43423          	sd	a0,-504(s0)
    80004448:	d141                	beqz	a0,800043c8 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000444a:	e2843d03          	ld	s10,-472(s0)
    8000444e:	df043783          	ld	a5,-528(s0)
    80004452:	00fd77b3          	and	a5,s10,a5
    80004456:	fba1                	bnez	a5,800043a6 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004458:	e2042d83          	lw	s11,-480(s0)
    8000445c:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004460:	f80c03e3          	beqz	s8,800043e6 <exec+0x306>
    80004464:	8a62                	mv	s4,s8
    80004466:	4901                	li	s2,0
    80004468:	b345                	j	80004208 <exec+0x128>

000000008000446a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000446a:	7179                	addi	sp,sp,-48
    8000446c:	f406                	sd	ra,40(sp)
    8000446e:	f022                	sd	s0,32(sp)
    80004470:	ec26                	sd	s1,24(sp)
    80004472:	e84a                	sd	s2,16(sp)
    80004474:	1800                	addi	s0,sp,48
    80004476:	892e                	mv	s2,a1
    80004478:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000447a:	fdc40593          	addi	a1,s0,-36
    8000447e:	ffffe097          	auipc	ra,0xffffe
    80004482:	b1c080e7          	jalr	-1252(ra) # 80001f9a <argint>
    80004486:	04054063          	bltz	a0,800044c6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000448a:	fdc42703          	lw	a4,-36(s0)
    8000448e:	47bd                	li	a5,15
    80004490:	02e7ed63          	bltu	a5,a4,800044ca <argfd+0x60>
    80004494:	ffffd097          	auipc	ra,0xffffd
    80004498:	9fe080e7          	jalr	-1538(ra) # 80000e92 <myproc>
    8000449c:	fdc42703          	lw	a4,-36(s0)
    800044a0:	01a70793          	addi	a5,a4,26
    800044a4:	078e                	slli	a5,a5,0x3
    800044a6:	953e                	add	a0,a0,a5
    800044a8:	651c                	ld	a5,8(a0)
    800044aa:	c395                	beqz	a5,800044ce <argfd+0x64>
    return -1;
  if(pfd)
    800044ac:	00090463          	beqz	s2,800044b4 <argfd+0x4a>
    *pfd = fd;
    800044b0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044b4:	4501                	li	a0,0
  if(pf)
    800044b6:	c091                	beqz	s1,800044ba <argfd+0x50>
    *pf = f;
    800044b8:	e09c                	sd	a5,0(s1)
}
    800044ba:	70a2                	ld	ra,40(sp)
    800044bc:	7402                	ld	s0,32(sp)
    800044be:	64e2                	ld	s1,24(sp)
    800044c0:	6942                	ld	s2,16(sp)
    800044c2:	6145                	addi	sp,sp,48
    800044c4:	8082                	ret
    return -1;
    800044c6:	557d                	li	a0,-1
    800044c8:	bfcd                	j	800044ba <argfd+0x50>
    return -1;
    800044ca:	557d                	li	a0,-1
    800044cc:	b7fd                	j	800044ba <argfd+0x50>
    800044ce:	557d                	li	a0,-1
    800044d0:	b7ed                	j	800044ba <argfd+0x50>

00000000800044d2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044d2:	1101                	addi	sp,sp,-32
    800044d4:	ec06                	sd	ra,24(sp)
    800044d6:	e822                	sd	s0,16(sp)
    800044d8:	e426                	sd	s1,8(sp)
    800044da:	1000                	addi	s0,sp,32
    800044dc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044de:	ffffd097          	auipc	ra,0xffffd
    800044e2:	9b4080e7          	jalr	-1612(ra) # 80000e92 <myproc>
    800044e6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044e8:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd8e98>
    800044ec:	4501                	li	a0,0
    800044ee:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044f0:	6398                	ld	a4,0(a5)
    800044f2:	cb19                	beqz	a4,80004508 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044f4:	2505                	addiw	a0,a0,1
    800044f6:	07a1                	addi	a5,a5,8
    800044f8:	fed51ce3          	bne	a0,a3,800044f0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044fc:	557d                	li	a0,-1
}
    800044fe:	60e2                	ld	ra,24(sp)
    80004500:	6442                	ld	s0,16(sp)
    80004502:	64a2                	ld	s1,8(sp)
    80004504:	6105                	addi	sp,sp,32
    80004506:	8082                	ret
      p->ofile[fd] = f;
    80004508:	01a50793          	addi	a5,a0,26
    8000450c:	078e                	slli	a5,a5,0x3
    8000450e:	963e                	add	a2,a2,a5
    80004510:	e604                	sd	s1,8(a2)
      return fd;
    80004512:	b7f5                	j	800044fe <fdalloc+0x2c>

0000000080004514 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004514:	715d                	addi	sp,sp,-80
    80004516:	e486                	sd	ra,72(sp)
    80004518:	e0a2                	sd	s0,64(sp)
    8000451a:	fc26                	sd	s1,56(sp)
    8000451c:	f84a                	sd	s2,48(sp)
    8000451e:	f44e                	sd	s3,40(sp)
    80004520:	f052                	sd	s4,32(sp)
    80004522:	ec56                	sd	s5,24(sp)
    80004524:	0880                	addi	s0,sp,80
    80004526:	89ae                	mv	s3,a1
    80004528:	8ab2                	mv	s5,a2
    8000452a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000452c:	fb040593          	addi	a1,s0,-80
    80004530:	fffff097          	auipc	ra,0xfffff
    80004534:	e86080e7          	jalr	-378(ra) # 800033b6 <nameiparent>
    80004538:	892a                	mv	s2,a0
    8000453a:	12050f63          	beqz	a0,80004678 <create+0x164>
    return 0;

  ilock(dp);
    8000453e:	ffffe097          	auipc	ra,0xffffe
    80004542:	6a4080e7          	jalr	1700(ra) # 80002be2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004546:	4601                	li	a2,0
    80004548:	fb040593          	addi	a1,s0,-80
    8000454c:	854a                	mv	a0,s2
    8000454e:	fffff097          	auipc	ra,0xfffff
    80004552:	b78080e7          	jalr	-1160(ra) # 800030c6 <dirlookup>
    80004556:	84aa                	mv	s1,a0
    80004558:	c921                	beqz	a0,800045a8 <create+0x94>
    iunlockput(dp);
    8000455a:	854a                	mv	a0,s2
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	8e8080e7          	jalr	-1816(ra) # 80002e44 <iunlockput>
    ilock(ip);
    80004564:	8526                	mv	a0,s1
    80004566:	ffffe097          	auipc	ra,0xffffe
    8000456a:	67c080e7          	jalr	1660(ra) # 80002be2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000456e:	2981                	sext.w	s3,s3
    80004570:	4789                	li	a5,2
    80004572:	02f99463          	bne	s3,a5,8000459a <create+0x86>
    80004576:	0444d783          	lhu	a5,68(s1)
    8000457a:	37f9                	addiw	a5,a5,-2
    8000457c:	17c2                	slli	a5,a5,0x30
    8000457e:	93c1                	srli	a5,a5,0x30
    80004580:	4705                	li	a4,1
    80004582:	00f76c63          	bltu	a4,a5,8000459a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004586:	8526                	mv	a0,s1
    80004588:	60a6                	ld	ra,72(sp)
    8000458a:	6406                	ld	s0,64(sp)
    8000458c:	74e2                	ld	s1,56(sp)
    8000458e:	7942                	ld	s2,48(sp)
    80004590:	79a2                	ld	s3,40(sp)
    80004592:	7a02                	ld	s4,32(sp)
    80004594:	6ae2                	ld	s5,24(sp)
    80004596:	6161                	addi	sp,sp,80
    80004598:	8082                	ret
    iunlockput(ip);
    8000459a:	8526                	mv	a0,s1
    8000459c:	fffff097          	auipc	ra,0xfffff
    800045a0:	8a8080e7          	jalr	-1880(ra) # 80002e44 <iunlockput>
    return 0;
    800045a4:	4481                	li	s1,0
    800045a6:	b7c5                	j	80004586 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045a8:	85ce                	mv	a1,s3
    800045aa:	00092503          	lw	a0,0(s2)
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	49c080e7          	jalr	1180(ra) # 80002a4a <ialloc>
    800045b6:	84aa                	mv	s1,a0
    800045b8:	c529                	beqz	a0,80004602 <create+0xee>
  ilock(ip);
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	628080e7          	jalr	1576(ra) # 80002be2 <ilock>
  ip->major = major;
    800045c2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045c6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045ca:	4785                	li	a5,1
    800045cc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045d0:	8526                	mv	a0,s1
    800045d2:	ffffe097          	auipc	ra,0xffffe
    800045d6:	546080e7          	jalr	1350(ra) # 80002b18 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045da:	2981                	sext.w	s3,s3
    800045dc:	4785                	li	a5,1
    800045de:	02f98a63          	beq	s3,a5,80004612 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045e2:	40d0                	lw	a2,4(s1)
    800045e4:	fb040593          	addi	a1,s0,-80
    800045e8:	854a                	mv	a0,s2
    800045ea:	fffff097          	auipc	ra,0xfffff
    800045ee:	cec080e7          	jalr	-788(ra) # 800032d6 <dirlink>
    800045f2:	06054b63          	bltz	a0,80004668 <create+0x154>
  iunlockput(dp);
    800045f6:	854a                	mv	a0,s2
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	84c080e7          	jalr	-1972(ra) # 80002e44 <iunlockput>
  return ip;
    80004600:	b759                	j	80004586 <create+0x72>
    panic("create: ialloc");
    80004602:	00004517          	auipc	a0,0x4
    80004606:	13650513          	addi	a0,a0,310 # 80008738 <syscalls+0x2a8>
    8000460a:	00001097          	auipc	ra,0x1
    8000460e:	68e080e7          	jalr	1678(ra) # 80005c98 <panic>
    dp->nlink++;  // for ".."
    80004612:	04a95783          	lhu	a5,74(s2)
    80004616:	2785                	addiw	a5,a5,1
    80004618:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000461c:	854a                	mv	a0,s2
    8000461e:	ffffe097          	auipc	ra,0xffffe
    80004622:	4fa080e7          	jalr	1274(ra) # 80002b18 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004626:	40d0                	lw	a2,4(s1)
    80004628:	00004597          	auipc	a1,0x4
    8000462c:	12058593          	addi	a1,a1,288 # 80008748 <syscalls+0x2b8>
    80004630:	8526                	mv	a0,s1
    80004632:	fffff097          	auipc	ra,0xfffff
    80004636:	ca4080e7          	jalr	-860(ra) # 800032d6 <dirlink>
    8000463a:	00054f63          	bltz	a0,80004658 <create+0x144>
    8000463e:	00492603          	lw	a2,4(s2)
    80004642:	00004597          	auipc	a1,0x4
    80004646:	10e58593          	addi	a1,a1,270 # 80008750 <syscalls+0x2c0>
    8000464a:	8526                	mv	a0,s1
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	c8a080e7          	jalr	-886(ra) # 800032d6 <dirlink>
    80004654:	f80557e3          	bgez	a0,800045e2 <create+0xce>
      panic("create dots");
    80004658:	00004517          	auipc	a0,0x4
    8000465c:	10050513          	addi	a0,a0,256 # 80008758 <syscalls+0x2c8>
    80004660:	00001097          	auipc	ra,0x1
    80004664:	638080e7          	jalr	1592(ra) # 80005c98 <panic>
    panic("create: dirlink");
    80004668:	00004517          	auipc	a0,0x4
    8000466c:	10050513          	addi	a0,a0,256 # 80008768 <syscalls+0x2d8>
    80004670:	00001097          	auipc	ra,0x1
    80004674:	628080e7          	jalr	1576(ra) # 80005c98 <panic>
    return 0;
    80004678:	84aa                	mv	s1,a0
    8000467a:	b731                	j	80004586 <create+0x72>

000000008000467c <sys_dup>:
{
    8000467c:	7179                	addi	sp,sp,-48
    8000467e:	f406                	sd	ra,40(sp)
    80004680:	f022                	sd	s0,32(sp)
    80004682:	ec26                	sd	s1,24(sp)
    80004684:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004686:	fd840613          	addi	a2,s0,-40
    8000468a:	4581                	li	a1,0
    8000468c:	4501                	li	a0,0
    8000468e:	00000097          	auipc	ra,0x0
    80004692:	ddc080e7          	jalr	-548(ra) # 8000446a <argfd>
    return -1;
    80004696:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004698:	02054363          	bltz	a0,800046be <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000469c:	fd843503          	ld	a0,-40(s0)
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	e32080e7          	jalr	-462(ra) # 800044d2 <fdalloc>
    800046a8:	84aa                	mv	s1,a0
    return -1;
    800046aa:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046ac:	00054963          	bltz	a0,800046be <sys_dup+0x42>
  filedup(f);
    800046b0:	fd843503          	ld	a0,-40(s0)
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	37a080e7          	jalr	890(ra) # 80003a2e <filedup>
  return fd;
    800046bc:	87a6                	mv	a5,s1
}
    800046be:	853e                	mv	a0,a5
    800046c0:	70a2                	ld	ra,40(sp)
    800046c2:	7402                	ld	s0,32(sp)
    800046c4:	64e2                	ld	s1,24(sp)
    800046c6:	6145                	addi	sp,sp,48
    800046c8:	8082                	ret

00000000800046ca <sys_read>:
{
    800046ca:	7179                	addi	sp,sp,-48
    800046cc:	f406                	sd	ra,40(sp)
    800046ce:	f022                	sd	s0,32(sp)
    800046d0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d2:	fe840613          	addi	a2,s0,-24
    800046d6:	4581                	li	a1,0
    800046d8:	4501                	li	a0,0
    800046da:	00000097          	auipc	ra,0x0
    800046de:	d90080e7          	jalr	-624(ra) # 8000446a <argfd>
    return -1;
    800046e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e4:	04054163          	bltz	a0,80004726 <sys_read+0x5c>
    800046e8:	fe440593          	addi	a1,s0,-28
    800046ec:	4509                	li	a0,2
    800046ee:	ffffe097          	auipc	ra,0xffffe
    800046f2:	8ac080e7          	jalr	-1876(ra) # 80001f9a <argint>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f8:	02054763          	bltz	a0,80004726 <sys_read+0x5c>
    800046fc:	fd840593          	addi	a1,s0,-40
    80004700:	4505                	li	a0,1
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	8ba080e7          	jalr	-1862(ra) # 80001fbc <argaddr>
    return -1;
    8000470a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000470c:	00054d63          	bltz	a0,80004726 <sys_read+0x5c>
  return fileread(f, p, n);
    80004710:	fe442603          	lw	a2,-28(s0)
    80004714:	fd843583          	ld	a1,-40(s0)
    80004718:	fe843503          	ld	a0,-24(s0)
    8000471c:	fffff097          	auipc	ra,0xfffff
    80004720:	49e080e7          	jalr	1182(ra) # 80003bba <fileread>
    80004724:	87aa                	mv	a5,a0
}
    80004726:	853e                	mv	a0,a5
    80004728:	70a2                	ld	ra,40(sp)
    8000472a:	7402                	ld	s0,32(sp)
    8000472c:	6145                	addi	sp,sp,48
    8000472e:	8082                	ret

0000000080004730 <sys_write>:
{
    80004730:	7179                	addi	sp,sp,-48
    80004732:	f406                	sd	ra,40(sp)
    80004734:	f022                	sd	s0,32(sp)
    80004736:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004738:	fe840613          	addi	a2,s0,-24
    8000473c:	4581                	li	a1,0
    8000473e:	4501                	li	a0,0
    80004740:	00000097          	auipc	ra,0x0
    80004744:	d2a080e7          	jalr	-726(ra) # 8000446a <argfd>
    return -1;
    80004748:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474a:	04054163          	bltz	a0,8000478c <sys_write+0x5c>
    8000474e:	fe440593          	addi	a1,s0,-28
    80004752:	4509                	li	a0,2
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	846080e7          	jalr	-1978(ra) # 80001f9a <argint>
    return -1;
    8000475c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000475e:	02054763          	bltz	a0,8000478c <sys_write+0x5c>
    80004762:	fd840593          	addi	a1,s0,-40
    80004766:	4505                	li	a0,1
    80004768:	ffffe097          	auipc	ra,0xffffe
    8000476c:	854080e7          	jalr	-1964(ra) # 80001fbc <argaddr>
    return -1;
    80004770:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004772:	00054d63          	bltz	a0,8000478c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004776:	fe442603          	lw	a2,-28(s0)
    8000477a:	fd843583          	ld	a1,-40(s0)
    8000477e:	fe843503          	ld	a0,-24(s0)
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	4fa080e7          	jalr	1274(ra) # 80003c7c <filewrite>
    8000478a:	87aa                	mv	a5,a0
}
    8000478c:	853e                	mv	a0,a5
    8000478e:	70a2                	ld	ra,40(sp)
    80004790:	7402                	ld	s0,32(sp)
    80004792:	6145                	addi	sp,sp,48
    80004794:	8082                	ret

0000000080004796 <sys_close>:
{
    80004796:	1101                	addi	sp,sp,-32
    80004798:	ec06                	sd	ra,24(sp)
    8000479a:	e822                	sd	s0,16(sp)
    8000479c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000479e:	fe040613          	addi	a2,s0,-32
    800047a2:	fec40593          	addi	a1,s0,-20
    800047a6:	4501                	li	a0,0
    800047a8:	00000097          	auipc	ra,0x0
    800047ac:	cc2080e7          	jalr	-830(ra) # 8000446a <argfd>
    return -1;
    800047b0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047b2:	02054463          	bltz	a0,800047da <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047b6:	ffffc097          	auipc	ra,0xffffc
    800047ba:	6dc080e7          	jalr	1756(ra) # 80000e92 <myproc>
    800047be:	fec42783          	lw	a5,-20(s0)
    800047c2:	07e9                	addi	a5,a5,26
    800047c4:	078e                	slli	a5,a5,0x3
    800047c6:	97aa                	add	a5,a5,a0
    800047c8:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800047cc:	fe043503          	ld	a0,-32(s0)
    800047d0:	fffff097          	auipc	ra,0xfffff
    800047d4:	2b0080e7          	jalr	688(ra) # 80003a80 <fileclose>
  return 0;
    800047d8:	4781                	li	a5,0
}
    800047da:	853e                	mv	a0,a5
    800047dc:	60e2                	ld	ra,24(sp)
    800047de:	6442                	ld	s0,16(sp)
    800047e0:	6105                	addi	sp,sp,32
    800047e2:	8082                	ret

00000000800047e4 <sys_fstat>:
{
    800047e4:	1101                	addi	sp,sp,-32
    800047e6:	ec06                	sd	ra,24(sp)
    800047e8:	e822                	sd	s0,16(sp)
    800047ea:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ec:	fe840613          	addi	a2,s0,-24
    800047f0:	4581                	li	a1,0
    800047f2:	4501                	li	a0,0
    800047f4:	00000097          	auipc	ra,0x0
    800047f8:	c76080e7          	jalr	-906(ra) # 8000446a <argfd>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047fe:	02054563          	bltz	a0,80004828 <sys_fstat+0x44>
    80004802:	fe040593          	addi	a1,s0,-32
    80004806:	4505                	li	a0,1
    80004808:	ffffd097          	auipc	ra,0xffffd
    8000480c:	7b4080e7          	jalr	1972(ra) # 80001fbc <argaddr>
    return -1;
    80004810:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004812:	00054b63          	bltz	a0,80004828 <sys_fstat+0x44>
  return filestat(f, st);
    80004816:	fe043583          	ld	a1,-32(s0)
    8000481a:	fe843503          	ld	a0,-24(s0)
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	32a080e7          	jalr	810(ra) # 80003b48 <filestat>
    80004826:	87aa                	mv	a5,a0
}
    80004828:	853e                	mv	a0,a5
    8000482a:	60e2                	ld	ra,24(sp)
    8000482c:	6442                	ld	s0,16(sp)
    8000482e:	6105                	addi	sp,sp,32
    80004830:	8082                	ret

0000000080004832 <sys_link>:
{
    80004832:	7169                	addi	sp,sp,-304
    80004834:	f606                	sd	ra,296(sp)
    80004836:	f222                	sd	s0,288(sp)
    80004838:	ee26                	sd	s1,280(sp)
    8000483a:	ea4a                	sd	s2,272(sp)
    8000483c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000483e:	08000613          	li	a2,128
    80004842:	ed040593          	addi	a1,s0,-304
    80004846:	4501                	li	a0,0
    80004848:	ffffd097          	auipc	ra,0xffffd
    8000484c:	796080e7          	jalr	1942(ra) # 80001fde <argstr>
    return -1;
    80004850:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004852:	10054e63          	bltz	a0,8000496e <sys_link+0x13c>
    80004856:	08000613          	li	a2,128
    8000485a:	f5040593          	addi	a1,s0,-176
    8000485e:	4505                	li	a0,1
    80004860:	ffffd097          	auipc	ra,0xffffd
    80004864:	77e080e7          	jalr	1918(ra) # 80001fde <argstr>
    return -1;
    80004868:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000486a:	10054263          	bltz	a0,8000496e <sys_link+0x13c>
  begin_op();
    8000486e:	fffff097          	auipc	ra,0xfffff
    80004872:	d46080e7          	jalr	-698(ra) # 800035b4 <begin_op>
  if((ip = namei(old)) == 0){
    80004876:	ed040513          	addi	a0,s0,-304
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	b1e080e7          	jalr	-1250(ra) # 80003398 <namei>
    80004882:	84aa                	mv	s1,a0
    80004884:	c551                	beqz	a0,80004910 <sys_link+0xde>
  ilock(ip);
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	35c080e7          	jalr	860(ra) # 80002be2 <ilock>
  if(ip->type == T_DIR){
    8000488e:	04449703          	lh	a4,68(s1)
    80004892:	4785                	li	a5,1
    80004894:	08f70463          	beq	a4,a5,8000491c <sys_link+0xea>
  ip->nlink++;
    80004898:	04a4d783          	lhu	a5,74(s1)
    8000489c:	2785                	addiw	a5,a5,1
    8000489e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048a2:	8526                	mv	a0,s1
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	274080e7          	jalr	628(ra) # 80002b18 <iupdate>
  iunlock(ip);
    800048ac:	8526                	mv	a0,s1
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	3f6080e7          	jalr	1014(ra) # 80002ca4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048b6:	fd040593          	addi	a1,s0,-48
    800048ba:	f5040513          	addi	a0,s0,-176
    800048be:	fffff097          	auipc	ra,0xfffff
    800048c2:	af8080e7          	jalr	-1288(ra) # 800033b6 <nameiparent>
    800048c6:	892a                	mv	s2,a0
    800048c8:	c935                	beqz	a0,8000493c <sys_link+0x10a>
  ilock(dp);
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	318080e7          	jalr	792(ra) # 80002be2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048d2:	00092703          	lw	a4,0(s2)
    800048d6:	409c                	lw	a5,0(s1)
    800048d8:	04f71d63          	bne	a4,a5,80004932 <sys_link+0x100>
    800048dc:	40d0                	lw	a2,4(s1)
    800048de:	fd040593          	addi	a1,s0,-48
    800048e2:	854a                	mv	a0,s2
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	9f2080e7          	jalr	-1550(ra) # 800032d6 <dirlink>
    800048ec:	04054363          	bltz	a0,80004932 <sys_link+0x100>
  iunlockput(dp);
    800048f0:	854a                	mv	a0,s2
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	552080e7          	jalr	1362(ra) # 80002e44 <iunlockput>
  iput(ip);
    800048fa:	8526                	mv	a0,s1
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	4a0080e7          	jalr	1184(ra) # 80002d9c <iput>
  end_op();
    80004904:	fffff097          	auipc	ra,0xfffff
    80004908:	d30080e7          	jalr	-720(ra) # 80003634 <end_op>
  return 0;
    8000490c:	4781                	li	a5,0
    8000490e:	a085                	j	8000496e <sys_link+0x13c>
    end_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	d24080e7          	jalr	-732(ra) # 80003634 <end_op>
    return -1;
    80004918:	57fd                	li	a5,-1
    8000491a:	a891                	j	8000496e <sys_link+0x13c>
    iunlockput(ip);
    8000491c:	8526                	mv	a0,s1
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	526080e7          	jalr	1318(ra) # 80002e44 <iunlockput>
    end_op();
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	d0e080e7          	jalr	-754(ra) # 80003634 <end_op>
    return -1;
    8000492e:	57fd                	li	a5,-1
    80004930:	a83d                	j	8000496e <sys_link+0x13c>
    iunlockput(dp);
    80004932:	854a                	mv	a0,s2
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	510080e7          	jalr	1296(ra) # 80002e44 <iunlockput>
  ilock(ip);
    8000493c:	8526                	mv	a0,s1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	2a4080e7          	jalr	676(ra) # 80002be2 <ilock>
  ip->nlink--;
    80004946:	04a4d783          	lhu	a5,74(s1)
    8000494a:	37fd                	addiw	a5,a5,-1
    8000494c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	1c6080e7          	jalr	454(ra) # 80002b18 <iupdate>
  iunlockput(ip);
    8000495a:	8526                	mv	a0,s1
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	4e8080e7          	jalr	1256(ra) # 80002e44 <iunlockput>
  end_op();
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	cd0080e7          	jalr	-816(ra) # 80003634 <end_op>
  return -1;
    8000496c:	57fd                	li	a5,-1
}
    8000496e:	853e                	mv	a0,a5
    80004970:	70b2                	ld	ra,296(sp)
    80004972:	7412                	ld	s0,288(sp)
    80004974:	64f2                	ld	s1,280(sp)
    80004976:	6952                	ld	s2,272(sp)
    80004978:	6155                	addi	sp,sp,304
    8000497a:	8082                	ret

000000008000497c <sys_unlink>:
{
    8000497c:	7151                	addi	sp,sp,-240
    8000497e:	f586                	sd	ra,232(sp)
    80004980:	f1a2                	sd	s0,224(sp)
    80004982:	eda6                	sd	s1,216(sp)
    80004984:	e9ca                	sd	s2,208(sp)
    80004986:	e5ce                	sd	s3,200(sp)
    80004988:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000498a:	08000613          	li	a2,128
    8000498e:	f3040593          	addi	a1,s0,-208
    80004992:	4501                	li	a0,0
    80004994:	ffffd097          	auipc	ra,0xffffd
    80004998:	64a080e7          	jalr	1610(ra) # 80001fde <argstr>
    8000499c:	18054163          	bltz	a0,80004b1e <sys_unlink+0x1a2>
  begin_op();
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	c14080e7          	jalr	-1004(ra) # 800035b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049a8:	fb040593          	addi	a1,s0,-80
    800049ac:	f3040513          	addi	a0,s0,-208
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	a06080e7          	jalr	-1530(ra) # 800033b6 <nameiparent>
    800049b8:	84aa                	mv	s1,a0
    800049ba:	c979                	beqz	a0,80004a90 <sys_unlink+0x114>
  ilock(dp);
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	226080e7          	jalr	550(ra) # 80002be2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049c4:	00004597          	auipc	a1,0x4
    800049c8:	d8458593          	addi	a1,a1,-636 # 80008748 <syscalls+0x2b8>
    800049cc:	fb040513          	addi	a0,s0,-80
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	6dc080e7          	jalr	1756(ra) # 800030ac <namecmp>
    800049d8:	14050a63          	beqz	a0,80004b2c <sys_unlink+0x1b0>
    800049dc:	00004597          	auipc	a1,0x4
    800049e0:	d7458593          	addi	a1,a1,-652 # 80008750 <syscalls+0x2c0>
    800049e4:	fb040513          	addi	a0,s0,-80
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	6c4080e7          	jalr	1732(ra) # 800030ac <namecmp>
    800049f0:	12050e63          	beqz	a0,80004b2c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049f4:	f2c40613          	addi	a2,s0,-212
    800049f8:	fb040593          	addi	a1,s0,-80
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	6c8080e7          	jalr	1736(ra) # 800030c6 <dirlookup>
    80004a06:	892a                	mv	s2,a0
    80004a08:	12050263          	beqz	a0,80004b2c <sys_unlink+0x1b0>
  ilock(ip);
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	1d6080e7          	jalr	470(ra) # 80002be2 <ilock>
  if(ip->nlink < 1)
    80004a14:	04a91783          	lh	a5,74(s2)
    80004a18:	08f05263          	blez	a5,80004a9c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a1c:	04491703          	lh	a4,68(s2)
    80004a20:	4785                	li	a5,1
    80004a22:	08f70563          	beq	a4,a5,80004aac <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a26:	4641                	li	a2,16
    80004a28:	4581                	li	a1,0
    80004a2a:	fc040513          	addi	a0,s0,-64
    80004a2e:	ffffb097          	auipc	ra,0xffffb
    80004a32:	794080e7          	jalr	1940(ra) # 800001c2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a36:	4741                	li	a4,16
    80004a38:	f2c42683          	lw	a3,-212(s0)
    80004a3c:	fc040613          	addi	a2,s0,-64
    80004a40:	4581                	li	a1,0
    80004a42:	8526                	mv	a0,s1
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	54a080e7          	jalr	1354(ra) # 80002f8e <writei>
    80004a4c:	47c1                	li	a5,16
    80004a4e:	0af51563          	bne	a0,a5,80004af8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a52:	04491703          	lh	a4,68(s2)
    80004a56:	4785                	li	a5,1
    80004a58:	0af70863          	beq	a4,a5,80004b08 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	3e6080e7          	jalr	998(ra) # 80002e44 <iunlockput>
  ip->nlink--;
    80004a66:	04a95783          	lhu	a5,74(s2)
    80004a6a:	37fd                	addiw	a5,a5,-1
    80004a6c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a70:	854a                	mv	a0,s2
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	0a6080e7          	jalr	166(ra) # 80002b18 <iupdate>
  iunlockput(ip);
    80004a7a:	854a                	mv	a0,s2
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	3c8080e7          	jalr	968(ra) # 80002e44 <iunlockput>
  end_op();
    80004a84:	fffff097          	auipc	ra,0xfffff
    80004a88:	bb0080e7          	jalr	-1104(ra) # 80003634 <end_op>
  return 0;
    80004a8c:	4501                	li	a0,0
    80004a8e:	a84d                	j	80004b40 <sys_unlink+0x1c4>
    end_op();
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	ba4080e7          	jalr	-1116(ra) # 80003634 <end_op>
    return -1;
    80004a98:	557d                	li	a0,-1
    80004a9a:	a05d                	j	80004b40 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a9c:	00004517          	auipc	a0,0x4
    80004aa0:	cdc50513          	addi	a0,a0,-804 # 80008778 <syscalls+0x2e8>
    80004aa4:	00001097          	auipc	ra,0x1
    80004aa8:	1f4080e7          	jalr	500(ra) # 80005c98 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aac:	04c92703          	lw	a4,76(s2)
    80004ab0:	02000793          	li	a5,32
    80004ab4:	f6e7f9e3          	bgeu	a5,a4,80004a26 <sys_unlink+0xaa>
    80004ab8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004abc:	4741                	li	a4,16
    80004abe:	86ce                	mv	a3,s3
    80004ac0:	f1840613          	addi	a2,s0,-232
    80004ac4:	4581                	li	a1,0
    80004ac6:	854a                	mv	a0,s2
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	3ce080e7          	jalr	974(ra) # 80002e96 <readi>
    80004ad0:	47c1                	li	a5,16
    80004ad2:	00f51b63          	bne	a0,a5,80004ae8 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ad6:	f1845783          	lhu	a5,-232(s0)
    80004ada:	e7a1                	bnez	a5,80004b22 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004adc:	29c1                	addiw	s3,s3,16
    80004ade:	04c92783          	lw	a5,76(s2)
    80004ae2:	fcf9ede3          	bltu	s3,a5,80004abc <sys_unlink+0x140>
    80004ae6:	b781                	j	80004a26 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ae8:	00004517          	auipc	a0,0x4
    80004aec:	ca850513          	addi	a0,a0,-856 # 80008790 <syscalls+0x300>
    80004af0:	00001097          	auipc	ra,0x1
    80004af4:	1a8080e7          	jalr	424(ra) # 80005c98 <panic>
    panic("unlink: writei");
    80004af8:	00004517          	auipc	a0,0x4
    80004afc:	cb050513          	addi	a0,a0,-848 # 800087a8 <syscalls+0x318>
    80004b00:	00001097          	auipc	ra,0x1
    80004b04:	198080e7          	jalr	408(ra) # 80005c98 <panic>
    dp->nlink--;
    80004b08:	04a4d783          	lhu	a5,74(s1)
    80004b0c:	37fd                	addiw	a5,a5,-1
    80004b0e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	004080e7          	jalr	4(ra) # 80002b18 <iupdate>
    80004b1c:	b781                	j	80004a5c <sys_unlink+0xe0>
    return -1;
    80004b1e:	557d                	li	a0,-1
    80004b20:	a005                	j	80004b40 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b22:	854a                	mv	a0,s2
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	320080e7          	jalr	800(ra) # 80002e44 <iunlockput>
  iunlockput(dp);
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	316080e7          	jalr	790(ra) # 80002e44 <iunlockput>
  end_op();
    80004b36:	fffff097          	auipc	ra,0xfffff
    80004b3a:	afe080e7          	jalr	-1282(ra) # 80003634 <end_op>
  return -1;
    80004b3e:	557d                	li	a0,-1
}
    80004b40:	70ae                	ld	ra,232(sp)
    80004b42:	740e                	ld	s0,224(sp)
    80004b44:	64ee                	ld	s1,216(sp)
    80004b46:	694e                	ld	s2,208(sp)
    80004b48:	69ae                	ld	s3,200(sp)
    80004b4a:	616d                	addi	sp,sp,240
    80004b4c:	8082                	ret

0000000080004b4e <sys_open>:

uint64
sys_open(void)
{
    80004b4e:	7131                	addi	sp,sp,-192
    80004b50:	fd06                	sd	ra,184(sp)
    80004b52:	f922                	sd	s0,176(sp)
    80004b54:	f526                	sd	s1,168(sp)
    80004b56:	f14a                	sd	s2,160(sp)
    80004b58:	ed4e                	sd	s3,152(sp)
    80004b5a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b5c:	08000613          	li	a2,128
    80004b60:	f5040593          	addi	a1,s0,-176
    80004b64:	4501                	li	a0,0
    80004b66:	ffffd097          	auipc	ra,0xffffd
    80004b6a:	478080e7          	jalr	1144(ra) # 80001fde <argstr>
    return -1;
    80004b6e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b70:	0c054163          	bltz	a0,80004c32 <sys_open+0xe4>
    80004b74:	f4c40593          	addi	a1,s0,-180
    80004b78:	4505                	li	a0,1
    80004b7a:	ffffd097          	auipc	ra,0xffffd
    80004b7e:	420080e7          	jalr	1056(ra) # 80001f9a <argint>
    80004b82:	0a054863          	bltz	a0,80004c32 <sys_open+0xe4>

  begin_op();
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	a2e080e7          	jalr	-1490(ra) # 800035b4 <begin_op>

  if(omode & O_CREATE){
    80004b8e:	f4c42783          	lw	a5,-180(s0)
    80004b92:	2007f793          	andi	a5,a5,512
    80004b96:	cbdd                	beqz	a5,80004c4c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b98:	4681                	li	a3,0
    80004b9a:	4601                	li	a2,0
    80004b9c:	4589                	li	a1,2
    80004b9e:	f5040513          	addi	a0,s0,-176
    80004ba2:	00000097          	auipc	ra,0x0
    80004ba6:	972080e7          	jalr	-1678(ra) # 80004514 <create>
    80004baa:	892a                	mv	s2,a0
    if(ip == 0){
    80004bac:	c959                	beqz	a0,80004c42 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bae:	04491703          	lh	a4,68(s2)
    80004bb2:	478d                	li	a5,3
    80004bb4:	00f71763          	bne	a4,a5,80004bc2 <sys_open+0x74>
    80004bb8:	04695703          	lhu	a4,70(s2)
    80004bbc:	47a5                	li	a5,9
    80004bbe:	0ce7ec63          	bltu	a5,a4,80004c96 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	e02080e7          	jalr	-510(ra) # 800039c4 <filealloc>
    80004bca:	89aa                	mv	s3,a0
    80004bcc:	10050263          	beqz	a0,80004cd0 <sys_open+0x182>
    80004bd0:	00000097          	auipc	ra,0x0
    80004bd4:	902080e7          	jalr	-1790(ra) # 800044d2 <fdalloc>
    80004bd8:	84aa                	mv	s1,a0
    80004bda:	0e054663          	bltz	a0,80004cc6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bde:	04491703          	lh	a4,68(s2)
    80004be2:	478d                	li	a5,3
    80004be4:	0cf70463          	beq	a4,a5,80004cac <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004be8:	4789                	li	a5,2
    80004bea:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bee:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bf2:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bf6:	f4c42783          	lw	a5,-180(s0)
    80004bfa:	0017c713          	xori	a4,a5,1
    80004bfe:	8b05                	andi	a4,a4,1
    80004c00:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c04:	0037f713          	andi	a4,a5,3
    80004c08:	00e03733          	snez	a4,a4
    80004c0c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c10:	4007f793          	andi	a5,a5,1024
    80004c14:	c791                	beqz	a5,80004c20 <sys_open+0xd2>
    80004c16:	04491703          	lh	a4,68(s2)
    80004c1a:	4789                	li	a5,2
    80004c1c:	08f70f63          	beq	a4,a5,80004cba <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c20:	854a                	mv	a0,s2
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	082080e7          	jalr	130(ra) # 80002ca4 <iunlock>
  end_op();
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	a0a080e7          	jalr	-1526(ra) # 80003634 <end_op>

  return fd;
}
    80004c32:	8526                	mv	a0,s1
    80004c34:	70ea                	ld	ra,184(sp)
    80004c36:	744a                	ld	s0,176(sp)
    80004c38:	74aa                	ld	s1,168(sp)
    80004c3a:	790a                	ld	s2,160(sp)
    80004c3c:	69ea                	ld	s3,152(sp)
    80004c3e:	6129                	addi	sp,sp,192
    80004c40:	8082                	ret
      end_op();
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	9f2080e7          	jalr	-1550(ra) # 80003634 <end_op>
      return -1;
    80004c4a:	b7e5                	j	80004c32 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c4c:	f5040513          	addi	a0,s0,-176
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	748080e7          	jalr	1864(ra) # 80003398 <namei>
    80004c58:	892a                	mv	s2,a0
    80004c5a:	c905                	beqz	a0,80004c8a <sys_open+0x13c>
    ilock(ip);
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	f86080e7          	jalr	-122(ra) # 80002be2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c64:	04491703          	lh	a4,68(s2)
    80004c68:	4785                	li	a5,1
    80004c6a:	f4f712e3          	bne	a4,a5,80004bae <sys_open+0x60>
    80004c6e:	f4c42783          	lw	a5,-180(s0)
    80004c72:	dba1                	beqz	a5,80004bc2 <sys_open+0x74>
      iunlockput(ip);
    80004c74:	854a                	mv	a0,s2
    80004c76:	ffffe097          	auipc	ra,0xffffe
    80004c7a:	1ce080e7          	jalr	462(ra) # 80002e44 <iunlockput>
      end_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	9b6080e7          	jalr	-1610(ra) # 80003634 <end_op>
      return -1;
    80004c86:	54fd                	li	s1,-1
    80004c88:	b76d                	j	80004c32 <sys_open+0xe4>
      end_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	9aa080e7          	jalr	-1622(ra) # 80003634 <end_op>
      return -1;
    80004c92:	54fd                	li	s1,-1
    80004c94:	bf79                	j	80004c32 <sys_open+0xe4>
    iunlockput(ip);
    80004c96:	854a                	mv	a0,s2
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	1ac080e7          	jalr	428(ra) # 80002e44 <iunlockput>
    end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	994080e7          	jalr	-1644(ra) # 80003634 <end_op>
    return -1;
    80004ca8:	54fd                	li	s1,-1
    80004caa:	b761                	j	80004c32 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cac:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cb0:	04691783          	lh	a5,70(s2)
    80004cb4:	02f99223          	sh	a5,36(s3)
    80004cb8:	bf2d                	j	80004bf2 <sys_open+0xa4>
    itrunc(ip);
    80004cba:	854a                	mv	a0,s2
    80004cbc:	ffffe097          	auipc	ra,0xffffe
    80004cc0:	034080e7          	jalr	52(ra) # 80002cf0 <itrunc>
    80004cc4:	bfb1                	j	80004c20 <sys_open+0xd2>
      fileclose(f);
    80004cc6:	854e                	mv	a0,s3
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	db8080e7          	jalr	-584(ra) # 80003a80 <fileclose>
    iunlockput(ip);
    80004cd0:	854a                	mv	a0,s2
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	172080e7          	jalr	370(ra) # 80002e44 <iunlockput>
    end_op();
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	95a080e7          	jalr	-1702(ra) # 80003634 <end_op>
    return -1;
    80004ce2:	54fd                	li	s1,-1
    80004ce4:	b7b9                	j	80004c32 <sys_open+0xe4>

0000000080004ce6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ce6:	7175                	addi	sp,sp,-144
    80004ce8:	e506                	sd	ra,136(sp)
    80004cea:	e122                	sd	s0,128(sp)
    80004cec:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	8c6080e7          	jalr	-1850(ra) # 800035b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cf6:	08000613          	li	a2,128
    80004cfa:	f7040593          	addi	a1,s0,-144
    80004cfe:	4501                	li	a0,0
    80004d00:	ffffd097          	auipc	ra,0xffffd
    80004d04:	2de080e7          	jalr	734(ra) # 80001fde <argstr>
    80004d08:	02054963          	bltz	a0,80004d3a <sys_mkdir+0x54>
    80004d0c:	4681                	li	a3,0
    80004d0e:	4601                	li	a2,0
    80004d10:	4585                	li	a1,1
    80004d12:	f7040513          	addi	a0,s0,-144
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	7fe080e7          	jalr	2046(ra) # 80004514 <create>
    80004d1e:	cd11                	beqz	a0,80004d3a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	124080e7          	jalr	292(ra) # 80002e44 <iunlockput>
  end_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	90c080e7          	jalr	-1780(ra) # 80003634 <end_op>
  return 0;
    80004d30:	4501                	li	a0,0
}
    80004d32:	60aa                	ld	ra,136(sp)
    80004d34:	640a                	ld	s0,128(sp)
    80004d36:	6149                	addi	sp,sp,144
    80004d38:	8082                	ret
    end_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	8fa080e7          	jalr	-1798(ra) # 80003634 <end_op>
    return -1;
    80004d42:	557d                	li	a0,-1
    80004d44:	b7fd                	j	80004d32 <sys_mkdir+0x4c>

0000000080004d46 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d46:	7135                	addi	sp,sp,-160
    80004d48:	ed06                	sd	ra,152(sp)
    80004d4a:	e922                	sd	s0,144(sp)
    80004d4c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	866080e7          	jalr	-1946(ra) # 800035b4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d56:	08000613          	li	a2,128
    80004d5a:	f7040593          	addi	a1,s0,-144
    80004d5e:	4501                	li	a0,0
    80004d60:	ffffd097          	auipc	ra,0xffffd
    80004d64:	27e080e7          	jalr	638(ra) # 80001fde <argstr>
    80004d68:	04054a63          	bltz	a0,80004dbc <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d6c:	f6c40593          	addi	a1,s0,-148
    80004d70:	4505                	li	a0,1
    80004d72:	ffffd097          	auipc	ra,0xffffd
    80004d76:	228080e7          	jalr	552(ra) # 80001f9a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d7a:	04054163          	bltz	a0,80004dbc <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d7e:	f6840593          	addi	a1,s0,-152
    80004d82:	4509                	li	a0,2
    80004d84:	ffffd097          	auipc	ra,0xffffd
    80004d88:	216080e7          	jalr	534(ra) # 80001f9a <argint>
     argint(1, &major) < 0 ||
    80004d8c:	02054863          	bltz	a0,80004dbc <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d90:	f6841683          	lh	a3,-152(s0)
    80004d94:	f6c41603          	lh	a2,-148(s0)
    80004d98:	458d                	li	a1,3
    80004d9a:	f7040513          	addi	a0,s0,-144
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	776080e7          	jalr	1910(ra) # 80004514 <create>
     argint(2, &minor) < 0 ||
    80004da6:	c919                	beqz	a0,80004dbc <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	09c080e7          	jalr	156(ra) # 80002e44 <iunlockput>
  end_op();
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	884080e7          	jalr	-1916(ra) # 80003634 <end_op>
  return 0;
    80004db8:	4501                	li	a0,0
    80004dba:	a031                	j	80004dc6 <sys_mknod+0x80>
    end_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	878080e7          	jalr	-1928(ra) # 80003634 <end_op>
    return -1;
    80004dc4:	557d                	li	a0,-1
}
    80004dc6:	60ea                	ld	ra,152(sp)
    80004dc8:	644a                	ld	s0,144(sp)
    80004dca:	610d                	addi	sp,sp,160
    80004dcc:	8082                	ret

0000000080004dce <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dce:	7135                	addi	sp,sp,-160
    80004dd0:	ed06                	sd	ra,152(sp)
    80004dd2:	e922                	sd	s0,144(sp)
    80004dd4:	e526                	sd	s1,136(sp)
    80004dd6:	e14a                	sd	s2,128(sp)
    80004dd8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dda:	ffffc097          	auipc	ra,0xffffc
    80004dde:	0b8080e7          	jalr	184(ra) # 80000e92 <myproc>
    80004de2:	892a                	mv	s2,a0
  
  begin_op();
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	7d0080e7          	jalr	2000(ra) # 800035b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dec:	08000613          	li	a2,128
    80004df0:	f6040593          	addi	a1,s0,-160
    80004df4:	4501                	li	a0,0
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	1e8080e7          	jalr	488(ra) # 80001fde <argstr>
    80004dfe:	04054b63          	bltz	a0,80004e54 <sys_chdir+0x86>
    80004e02:	f6040513          	addi	a0,s0,-160
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	592080e7          	jalr	1426(ra) # 80003398 <namei>
    80004e0e:	84aa                	mv	s1,a0
    80004e10:	c131                	beqz	a0,80004e54 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	dd0080e7          	jalr	-560(ra) # 80002be2 <ilock>
  if(ip->type != T_DIR){
    80004e1a:	04449703          	lh	a4,68(s1)
    80004e1e:	4785                	li	a5,1
    80004e20:	04f71063          	bne	a4,a5,80004e60 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e24:	8526                	mv	a0,s1
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	e7e080e7          	jalr	-386(ra) # 80002ca4 <iunlock>
  iput(p->cwd);
    80004e2e:	15893503          	ld	a0,344(s2)
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	f6a080e7          	jalr	-150(ra) # 80002d9c <iput>
  end_op();
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	7fa080e7          	jalr	2042(ra) # 80003634 <end_op>
  p->cwd = ip;
    80004e42:	14993c23          	sd	s1,344(s2)
  return 0;
    80004e46:	4501                	li	a0,0
}
    80004e48:	60ea                	ld	ra,152(sp)
    80004e4a:	644a                	ld	s0,144(sp)
    80004e4c:	64aa                	ld	s1,136(sp)
    80004e4e:	690a                	ld	s2,128(sp)
    80004e50:	610d                	addi	sp,sp,160
    80004e52:	8082                	ret
    end_op();
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	7e0080e7          	jalr	2016(ra) # 80003634 <end_op>
    return -1;
    80004e5c:	557d                	li	a0,-1
    80004e5e:	b7ed                	j	80004e48 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e60:	8526                	mv	a0,s1
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	fe2080e7          	jalr	-30(ra) # 80002e44 <iunlockput>
    end_op();
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	7ca080e7          	jalr	1994(ra) # 80003634 <end_op>
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	bfd1                	j	80004e48 <sys_chdir+0x7a>

0000000080004e76 <sys_exec>:

uint64
sys_exec(void)
{
    80004e76:	7145                	addi	sp,sp,-464
    80004e78:	e786                	sd	ra,456(sp)
    80004e7a:	e3a2                	sd	s0,448(sp)
    80004e7c:	ff26                	sd	s1,440(sp)
    80004e7e:	fb4a                	sd	s2,432(sp)
    80004e80:	f74e                	sd	s3,424(sp)
    80004e82:	f352                	sd	s4,416(sp)
    80004e84:	ef56                	sd	s5,408(sp)
    80004e86:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e88:	08000613          	li	a2,128
    80004e8c:	f4040593          	addi	a1,s0,-192
    80004e90:	4501                	li	a0,0
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	14c080e7          	jalr	332(ra) # 80001fde <argstr>
    return -1;
    80004e9a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e9c:	0c054a63          	bltz	a0,80004f70 <sys_exec+0xfa>
    80004ea0:	e3840593          	addi	a1,s0,-456
    80004ea4:	4505                	li	a0,1
    80004ea6:	ffffd097          	auipc	ra,0xffffd
    80004eaa:	116080e7          	jalr	278(ra) # 80001fbc <argaddr>
    80004eae:	0c054163          	bltz	a0,80004f70 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004eb2:	10000613          	li	a2,256
    80004eb6:	4581                	li	a1,0
    80004eb8:	e4040513          	addi	a0,s0,-448
    80004ebc:	ffffb097          	auipc	ra,0xffffb
    80004ec0:	306080e7          	jalr	774(ra) # 800001c2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ec4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ec8:	89a6                	mv	s3,s1
    80004eca:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ecc:	02000a13          	li	s4,32
    80004ed0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ed4:	00391513          	slli	a0,s2,0x3
    80004ed8:	e3040593          	addi	a1,s0,-464
    80004edc:	e3843783          	ld	a5,-456(s0)
    80004ee0:	953e                	add	a0,a0,a5
    80004ee2:	ffffd097          	auipc	ra,0xffffd
    80004ee6:	01e080e7          	jalr	30(ra) # 80001f00 <fetchaddr>
    80004eea:	02054a63          	bltz	a0,80004f1e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004eee:	e3043783          	ld	a5,-464(s0)
    80004ef2:	c3b9                	beqz	a5,80004f38 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ef4:	ffffb097          	auipc	ra,0xffffb
    80004ef8:	224080e7          	jalr	548(ra) # 80000118 <kalloc>
    80004efc:	85aa                	mv	a1,a0
    80004efe:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f02:	cd11                	beqz	a0,80004f1e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f04:	6605                	lui	a2,0x1
    80004f06:	e3043503          	ld	a0,-464(s0)
    80004f0a:	ffffd097          	auipc	ra,0xffffd
    80004f0e:	048080e7          	jalr	72(ra) # 80001f52 <fetchstr>
    80004f12:	00054663          	bltz	a0,80004f1e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f16:	0905                	addi	s2,s2,1
    80004f18:	09a1                	addi	s3,s3,8
    80004f1a:	fb491be3          	bne	s2,s4,80004ed0 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f1e:	10048913          	addi	s2,s1,256
    80004f22:	6088                	ld	a0,0(s1)
    80004f24:	c529                	beqz	a0,80004f6e <sys_exec+0xf8>
    kfree(argv[i]);
    80004f26:	ffffb097          	auipc	ra,0xffffb
    80004f2a:	0f6080e7          	jalr	246(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f2e:	04a1                	addi	s1,s1,8
    80004f30:	ff2499e3          	bne	s1,s2,80004f22 <sys_exec+0xac>
  return -1;
    80004f34:	597d                	li	s2,-1
    80004f36:	a82d                	j	80004f70 <sys_exec+0xfa>
      argv[i] = 0;
    80004f38:	0a8e                	slli	s5,s5,0x3
    80004f3a:	fc040793          	addi	a5,s0,-64
    80004f3e:	9abe                	add	s5,s5,a5
    80004f40:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f44:	e4040593          	addi	a1,s0,-448
    80004f48:	f4040513          	addi	a0,s0,-192
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	194080e7          	jalr	404(ra) # 800040e0 <exec>
    80004f54:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f56:	10048993          	addi	s3,s1,256
    80004f5a:	6088                	ld	a0,0(s1)
    80004f5c:	c911                	beqz	a0,80004f70 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f5e:	ffffb097          	auipc	ra,0xffffb
    80004f62:	0be080e7          	jalr	190(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f66:	04a1                	addi	s1,s1,8
    80004f68:	ff3499e3          	bne	s1,s3,80004f5a <sys_exec+0xe4>
    80004f6c:	a011                	j	80004f70 <sys_exec+0xfa>
  return -1;
    80004f6e:	597d                	li	s2,-1
}
    80004f70:	854a                	mv	a0,s2
    80004f72:	60be                	ld	ra,456(sp)
    80004f74:	641e                	ld	s0,448(sp)
    80004f76:	74fa                	ld	s1,440(sp)
    80004f78:	795a                	ld	s2,432(sp)
    80004f7a:	79ba                	ld	s3,424(sp)
    80004f7c:	7a1a                	ld	s4,416(sp)
    80004f7e:	6afa                	ld	s5,408(sp)
    80004f80:	6179                	addi	sp,sp,464
    80004f82:	8082                	ret

0000000080004f84 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f84:	7139                	addi	sp,sp,-64
    80004f86:	fc06                	sd	ra,56(sp)
    80004f88:	f822                	sd	s0,48(sp)
    80004f8a:	f426                	sd	s1,40(sp)
    80004f8c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f8e:	ffffc097          	auipc	ra,0xffffc
    80004f92:	f04080e7          	jalr	-252(ra) # 80000e92 <myproc>
    80004f96:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f98:	fd840593          	addi	a1,s0,-40
    80004f9c:	4501                	li	a0,0
    80004f9e:	ffffd097          	auipc	ra,0xffffd
    80004fa2:	01e080e7          	jalr	30(ra) # 80001fbc <argaddr>
    return -1;
    80004fa6:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fa8:	0e054063          	bltz	a0,80005088 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fac:	fc840593          	addi	a1,s0,-56
    80004fb0:	fd040513          	addi	a0,s0,-48
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	dfc080e7          	jalr	-516(ra) # 80003db0 <pipealloc>
    return -1;
    80004fbc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fbe:	0c054563          	bltz	a0,80005088 <sys_pipe+0x104>
  fd0 = -1;
    80004fc2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fc6:	fd043503          	ld	a0,-48(s0)
    80004fca:	fffff097          	auipc	ra,0xfffff
    80004fce:	508080e7          	jalr	1288(ra) # 800044d2 <fdalloc>
    80004fd2:	fca42223          	sw	a0,-60(s0)
    80004fd6:	08054c63          	bltz	a0,8000506e <sys_pipe+0xea>
    80004fda:	fc843503          	ld	a0,-56(s0)
    80004fde:	fffff097          	auipc	ra,0xfffff
    80004fe2:	4f4080e7          	jalr	1268(ra) # 800044d2 <fdalloc>
    80004fe6:	fca42023          	sw	a0,-64(s0)
    80004fea:	06054863          	bltz	a0,8000505a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fee:	4691                	li	a3,4
    80004ff0:	fc440613          	addi	a2,s0,-60
    80004ff4:	fd843583          	ld	a1,-40(s0)
    80004ff8:	6ca8                	ld	a0,88(s1)
    80004ffa:	ffffc097          	auipc	ra,0xffffc
    80004ffe:	b5a080e7          	jalr	-1190(ra) # 80000b54 <copyout>
    80005002:	02054063          	bltz	a0,80005022 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005006:	4691                	li	a3,4
    80005008:	fc040613          	addi	a2,s0,-64
    8000500c:	fd843583          	ld	a1,-40(s0)
    80005010:	0591                	addi	a1,a1,4
    80005012:	6ca8                	ld	a0,88(s1)
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	b40080e7          	jalr	-1216(ra) # 80000b54 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000501c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000501e:	06055563          	bgez	a0,80005088 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005022:	fc442783          	lw	a5,-60(s0)
    80005026:	07e9                	addi	a5,a5,26
    80005028:	078e                	slli	a5,a5,0x3
    8000502a:	97a6                	add	a5,a5,s1
    8000502c:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005030:	fc042503          	lw	a0,-64(s0)
    80005034:	0569                	addi	a0,a0,26
    80005036:	050e                	slli	a0,a0,0x3
    80005038:	9526                	add	a0,a0,s1
    8000503a:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000503e:	fd043503          	ld	a0,-48(s0)
    80005042:	fffff097          	auipc	ra,0xfffff
    80005046:	a3e080e7          	jalr	-1474(ra) # 80003a80 <fileclose>
    fileclose(wf);
    8000504a:	fc843503          	ld	a0,-56(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	a32080e7          	jalr	-1486(ra) # 80003a80 <fileclose>
    return -1;
    80005056:	57fd                	li	a5,-1
    80005058:	a805                	j	80005088 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000505a:	fc442783          	lw	a5,-60(s0)
    8000505e:	0007c863          	bltz	a5,8000506e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005062:	01a78513          	addi	a0,a5,26
    80005066:	050e                	slli	a0,a0,0x3
    80005068:	9526                	add	a0,a0,s1
    8000506a:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000506e:	fd043503          	ld	a0,-48(s0)
    80005072:	fffff097          	auipc	ra,0xfffff
    80005076:	a0e080e7          	jalr	-1522(ra) # 80003a80 <fileclose>
    fileclose(wf);
    8000507a:	fc843503          	ld	a0,-56(s0)
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	a02080e7          	jalr	-1534(ra) # 80003a80 <fileclose>
    return -1;
    80005086:	57fd                	li	a5,-1
}
    80005088:	853e                	mv	a0,a5
    8000508a:	70e2                	ld	ra,56(sp)
    8000508c:	7442                	ld	s0,48(sp)
    8000508e:	74a2                	ld	s1,40(sp)
    80005090:	6121                	addi	sp,sp,64
    80005092:	8082                	ret
	...

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	cedfc0ef          	jal	ra,80001dcc <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e422                	sd	s0,8(sp)
    8000515e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005160:	0c0007b7          	lui	a5,0xc000
    80005164:	4705                	li	a4,1
    80005166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005168:	c3d8                	sw	a4,4(a5)
}
    8000516a:	6422                	ld	s0,8(sp)
    8000516c:	0141                	addi	sp,sp,16
    8000516e:	8082                	ret

0000000080005170 <plicinithart>:

void
plicinithart(void)
{
    80005170:	1141                	addi	sp,sp,-16
    80005172:	e406                	sd	ra,8(sp)
    80005174:	e022                	sd	s0,0(sp)
    80005176:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	cee080e7          	jalr	-786(ra) # 80000e66 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005180:	0085171b          	slliw	a4,a0,0x8
    80005184:	0c0027b7          	lui	a5,0xc002
    80005188:	97ba                	add	a5,a5,a4
    8000518a:	40200713          	li	a4,1026
    8000518e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005192:	00d5151b          	slliw	a0,a0,0xd
    80005196:	0c2017b7          	lui	a5,0xc201
    8000519a:	953e                	add	a0,a0,a5
    8000519c:	00052023          	sw	zero,0(a0)
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	addi	sp,sp,16
    800051a6:	8082                	ret

00000000800051a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051a8:	1141                	addi	sp,sp,-16
    800051aa:	e406                	sd	ra,8(sp)
    800051ac:	e022                	sd	s0,0(sp)
    800051ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	cb6080e7          	jalr	-842(ra) # 80000e66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051b8:	00d5179b          	slliw	a5,a0,0xd
    800051bc:	0c201537          	lui	a0,0xc201
    800051c0:	953e                	add	a0,a0,a5
  return irq;
}
    800051c2:	4148                	lw	a0,4(a0)
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051cc:	1101                	addi	sp,sp,-32
    800051ce:	ec06                	sd	ra,24(sp)
    800051d0:	e822                	sd	s0,16(sp)
    800051d2:	e426                	sd	s1,8(sp)
    800051d4:	1000                	addi	s0,sp,32
    800051d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	c8e080e7          	jalr	-882(ra) # 80000e66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051e0:	00d5151b          	slliw	a0,a0,0xd
    800051e4:	0c2017b7          	lui	a5,0xc201
    800051e8:	97aa                	add	a5,a5,a0
    800051ea:	c3c4                	sw	s1,4(a5)
}
    800051ec:	60e2                	ld	ra,24(sp)
    800051ee:	6442                	ld	s0,16(sp)
    800051f0:	64a2                	ld	s1,8(sp)
    800051f2:	6105                	addi	sp,sp,32
    800051f4:	8082                	ret

00000000800051f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051f6:	1141                	addi	sp,sp,-16
    800051f8:	e406                	sd	ra,8(sp)
    800051fa:	e022                	sd	s0,0(sp)
    800051fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051fe:	479d                	li	a5,7
    80005200:	06a7c963          	blt	a5,a0,80005272 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005204:	00016797          	auipc	a5,0x16
    80005208:	dfc78793          	addi	a5,a5,-516 # 8001b000 <disk>
    8000520c:	00a78733          	add	a4,a5,a0
    80005210:	6789                	lui	a5,0x2
    80005212:	97ba                	add	a5,a5,a4
    80005214:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005218:	e7ad                	bnez	a5,80005282 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000521a:	00451793          	slli	a5,a0,0x4
    8000521e:	00018717          	auipc	a4,0x18
    80005222:	de270713          	addi	a4,a4,-542 # 8001d000 <disk+0x2000>
    80005226:	6314                	ld	a3,0(a4)
    80005228:	96be                	add	a3,a3,a5
    8000522a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000522e:	6314                	ld	a3,0(a4)
    80005230:	96be                	add	a3,a3,a5
    80005232:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005236:	6314                	ld	a3,0(a4)
    80005238:	96be                	add	a3,a3,a5
    8000523a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000523e:	6318                	ld	a4,0(a4)
    80005240:	97ba                	add	a5,a5,a4
    80005242:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005246:	00016797          	auipc	a5,0x16
    8000524a:	dba78793          	addi	a5,a5,-582 # 8001b000 <disk>
    8000524e:	97aa                	add	a5,a5,a0
    80005250:	6509                	lui	a0,0x2
    80005252:	953e                	add	a0,a0,a5
    80005254:	4785                	li	a5,1
    80005256:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000525a:	00018517          	auipc	a0,0x18
    8000525e:	dbe50513          	addi	a0,a0,-578 # 8001d018 <disk+0x2018>
    80005262:	ffffc097          	auipc	ra,0xffffc
    80005266:	480080e7          	jalr	1152(ra) # 800016e2 <wakeup>
}
    8000526a:	60a2                	ld	ra,8(sp)
    8000526c:	6402                	ld	s0,0(sp)
    8000526e:	0141                	addi	sp,sp,16
    80005270:	8082                	ret
    panic("free_desc 1");
    80005272:	00003517          	auipc	a0,0x3
    80005276:	54650513          	addi	a0,a0,1350 # 800087b8 <syscalls+0x328>
    8000527a:	00001097          	auipc	ra,0x1
    8000527e:	a1e080e7          	jalr	-1506(ra) # 80005c98 <panic>
    panic("free_desc 2");
    80005282:	00003517          	auipc	a0,0x3
    80005286:	54650513          	addi	a0,a0,1350 # 800087c8 <syscalls+0x338>
    8000528a:	00001097          	auipc	ra,0x1
    8000528e:	a0e080e7          	jalr	-1522(ra) # 80005c98 <panic>

0000000080005292 <virtio_disk_init>:
{
    80005292:	1101                	addi	sp,sp,-32
    80005294:	ec06                	sd	ra,24(sp)
    80005296:	e822                	sd	s0,16(sp)
    80005298:	e426                	sd	s1,8(sp)
    8000529a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000529c:	00003597          	auipc	a1,0x3
    800052a0:	53c58593          	addi	a1,a1,1340 # 800087d8 <syscalls+0x348>
    800052a4:	00018517          	auipc	a0,0x18
    800052a8:	e8450513          	addi	a0,a0,-380 # 8001d128 <disk+0x2128>
    800052ac:	00001097          	auipc	ra,0x1
    800052b0:	ea6080e7          	jalr	-346(ra) # 80006152 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	4398                	lw	a4,0(a5)
    800052ba:	2701                	sext.w	a4,a4
    800052bc:	747277b7          	lui	a5,0x74727
    800052c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052c4:	0ef71163          	bne	a4,a5,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	43dc                	lw	a5,4(a5)
    800052ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d0:	4705                	li	a4,1
    800052d2:	0ce79a63          	bne	a5,a4,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d6:	100017b7          	lui	a5,0x10001
    800052da:	479c                	lw	a5,8(a5)
    800052dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052de:	4709                	li	a4,2
    800052e0:	0ce79363          	bne	a5,a4,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052e4:	100017b7          	lui	a5,0x10001
    800052e8:	47d8                	lw	a4,12(a5)
    800052ea:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ec:	554d47b7          	lui	a5,0x554d4
    800052f0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052f4:	0af71963          	bne	a4,a5,800053a6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f8:	100017b7          	lui	a5,0x10001
    800052fc:	4705                	li	a4,1
    800052fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005300:	470d                	li	a4,3
    80005302:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005304:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005306:	c7ffe737          	lui	a4,0xc7ffe
    8000530a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000530e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005310:	2701                	sext.w	a4,a4
    80005312:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005314:	472d                	li	a4,11
    80005316:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005318:	473d                	li	a4,15
    8000531a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000531c:	6705                	lui	a4,0x1
    8000531e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005320:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005324:	5bdc                	lw	a5,52(a5)
    80005326:	2781                	sext.w	a5,a5
  if(max == 0)
    80005328:	c7d9                	beqz	a5,800053b6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000532a:	471d                	li	a4,7
    8000532c:	08f77d63          	bgeu	a4,a5,800053c6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005330:	100014b7          	lui	s1,0x10001
    80005334:	47a1                	li	a5,8
    80005336:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005338:	6609                	lui	a2,0x2
    8000533a:	4581                	li	a1,0
    8000533c:	00016517          	auipc	a0,0x16
    80005340:	cc450513          	addi	a0,a0,-828 # 8001b000 <disk>
    80005344:	ffffb097          	auipc	ra,0xffffb
    80005348:	e7e080e7          	jalr	-386(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000534c:	00016717          	auipc	a4,0x16
    80005350:	cb470713          	addi	a4,a4,-844 # 8001b000 <disk>
    80005354:	00c75793          	srli	a5,a4,0xc
    80005358:	2781                	sext.w	a5,a5
    8000535a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000535c:	00018797          	auipc	a5,0x18
    80005360:	ca478793          	addi	a5,a5,-860 # 8001d000 <disk+0x2000>
    80005364:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005366:	00016717          	auipc	a4,0x16
    8000536a:	d1a70713          	addi	a4,a4,-742 # 8001b080 <disk+0x80>
    8000536e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005370:	00017717          	auipc	a4,0x17
    80005374:	c9070713          	addi	a4,a4,-880 # 8001c000 <disk+0x1000>
    80005378:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000537a:	4705                	li	a4,1
    8000537c:	00e78c23          	sb	a4,24(a5)
    80005380:	00e78ca3          	sb	a4,25(a5)
    80005384:	00e78d23          	sb	a4,26(a5)
    80005388:	00e78da3          	sb	a4,27(a5)
    8000538c:	00e78e23          	sb	a4,28(a5)
    80005390:	00e78ea3          	sb	a4,29(a5)
    80005394:	00e78f23          	sb	a4,30(a5)
    80005398:	00e78fa3          	sb	a4,31(a5)
}
    8000539c:	60e2                	ld	ra,24(sp)
    8000539e:	6442                	ld	s0,16(sp)
    800053a0:	64a2                	ld	s1,8(sp)
    800053a2:	6105                	addi	sp,sp,32
    800053a4:	8082                	ret
    panic("could not find virtio disk");
    800053a6:	00003517          	auipc	a0,0x3
    800053aa:	44250513          	addi	a0,a0,1090 # 800087e8 <syscalls+0x358>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	8ea080e7          	jalr	-1814(ra) # 80005c98 <panic>
    panic("virtio disk has no queue 0");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	45250513          	addi	a0,a0,1106 # 80008808 <syscalls+0x378>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	8da080e7          	jalr	-1830(ra) # 80005c98 <panic>
    panic("virtio disk max queue too short");
    800053c6:	00003517          	auipc	a0,0x3
    800053ca:	46250513          	addi	a0,a0,1122 # 80008828 <syscalls+0x398>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	8ca080e7          	jalr	-1846(ra) # 80005c98 <panic>

00000000800053d6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053d6:	7159                	addi	sp,sp,-112
    800053d8:	f486                	sd	ra,104(sp)
    800053da:	f0a2                	sd	s0,96(sp)
    800053dc:	eca6                	sd	s1,88(sp)
    800053de:	e8ca                	sd	s2,80(sp)
    800053e0:	e4ce                	sd	s3,72(sp)
    800053e2:	e0d2                	sd	s4,64(sp)
    800053e4:	fc56                	sd	s5,56(sp)
    800053e6:	f85a                	sd	s6,48(sp)
    800053e8:	f45e                	sd	s7,40(sp)
    800053ea:	f062                	sd	s8,32(sp)
    800053ec:	ec66                	sd	s9,24(sp)
    800053ee:	e86a                	sd	s10,16(sp)
    800053f0:	1880                	addi	s0,sp,112
    800053f2:	892a                	mv	s2,a0
    800053f4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053f6:	00c52c83          	lw	s9,12(a0)
    800053fa:	001c9c9b          	slliw	s9,s9,0x1
    800053fe:	1c82                	slli	s9,s9,0x20
    80005400:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005404:	00018517          	auipc	a0,0x18
    80005408:	d2450513          	addi	a0,a0,-732 # 8001d128 <disk+0x2128>
    8000540c:	00001097          	auipc	ra,0x1
    80005410:	dd6080e7          	jalr	-554(ra) # 800061e2 <acquire>
  for(int i = 0; i < 3; i++){
    80005414:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005416:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005418:	00016b97          	auipc	s7,0x16
    8000541c:	be8b8b93          	addi	s7,s7,-1048 # 8001b000 <disk>
    80005420:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005422:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005424:	8a4e                	mv	s4,s3
    80005426:	a051                	j	800054aa <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005428:	00fb86b3          	add	a3,s7,a5
    8000542c:	96da                	add	a3,a3,s6
    8000542e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005432:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005434:	0207c563          	bltz	a5,8000545e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005438:	2485                	addiw	s1,s1,1
    8000543a:	0711                	addi	a4,a4,4
    8000543c:	25548063          	beq	s1,s5,8000567c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005440:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005442:	00018697          	auipc	a3,0x18
    80005446:	bd668693          	addi	a3,a3,-1066 # 8001d018 <disk+0x2018>
    8000544a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000544c:	0006c583          	lbu	a1,0(a3)
    80005450:	fde1                	bnez	a1,80005428 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005452:	2785                	addiw	a5,a5,1
    80005454:	0685                	addi	a3,a3,1
    80005456:	ff879be3          	bne	a5,s8,8000544c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000545a:	57fd                	li	a5,-1
    8000545c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000545e:	02905a63          	blez	s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005462:	f9042503          	lw	a0,-112(s0)
    80005466:	00000097          	auipc	ra,0x0
    8000546a:	d90080e7          	jalr	-624(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    8000546e:	4785                	li	a5,1
    80005470:	0297d163          	bge	a5,s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005474:	f9442503          	lw	a0,-108(s0)
    80005478:	00000097          	auipc	ra,0x0
    8000547c:	d7e080e7          	jalr	-642(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005480:	4789                	li	a5,2
    80005482:	0097d863          	bge	a5,s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005486:	f9842503          	lw	a0,-104(s0)
    8000548a:	00000097          	auipc	ra,0x0
    8000548e:	d6c080e7          	jalr	-660(ra) # 800051f6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005492:	00018597          	auipc	a1,0x18
    80005496:	c9658593          	addi	a1,a1,-874 # 8001d128 <disk+0x2128>
    8000549a:	00018517          	auipc	a0,0x18
    8000549e:	b7e50513          	addi	a0,a0,-1154 # 8001d018 <disk+0x2018>
    800054a2:	ffffc097          	auipc	ra,0xffffc
    800054a6:	0b4080e7          	jalr	180(ra) # 80001556 <sleep>
  for(int i = 0; i < 3; i++){
    800054aa:	f9040713          	addi	a4,s0,-112
    800054ae:	84ce                	mv	s1,s3
    800054b0:	bf41                	j	80005440 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054b2:	20058713          	addi	a4,a1,512
    800054b6:	00471693          	slli	a3,a4,0x4
    800054ba:	00016717          	auipc	a4,0x16
    800054be:	b4670713          	addi	a4,a4,-1210 # 8001b000 <disk>
    800054c2:	9736                	add	a4,a4,a3
    800054c4:	4685                	li	a3,1
    800054c6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054ca:	20058713          	addi	a4,a1,512
    800054ce:	00471693          	slli	a3,a4,0x4
    800054d2:	00016717          	auipc	a4,0x16
    800054d6:	b2e70713          	addi	a4,a4,-1234 # 8001b000 <disk>
    800054da:	9736                	add	a4,a4,a3
    800054dc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054e0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054e4:	7679                	lui	a2,0xffffe
    800054e6:	963e                	add	a2,a2,a5
    800054e8:	00018697          	auipc	a3,0x18
    800054ec:	b1868693          	addi	a3,a3,-1256 # 8001d000 <disk+0x2000>
    800054f0:	6298                	ld	a4,0(a3)
    800054f2:	9732                	add	a4,a4,a2
    800054f4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054f6:	6298                	ld	a4,0(a3)
    800054f8:	9732                	add	a4,a4,a2
    800054fa:	4541                	li	a0,16
    800054fc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054fe:	6298                	ld	a4,0(a3)
    80005500:	9732                	add	a4,a4,a2
    80005502:	4505                	li	a0,1
    80005504:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005508:	f9442703          	lw	a4,-108(s0)
    8000550c:	6288                	ld	a0,0(a3)
    8000550e:	962a                	add	a2,a2,a0
    80005510:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005514:	0712                	slli	a4,a4,0x4
    80005516:	6290                	ld	a2,0(a3)
    80005518:	963a                	add	a2,a2,a4
    8000551a:	05890513          	addi	a0,s2,88
    8000551e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005520:	6294                	ld	a3,0(a3)
    80005522:	96ba                	add	a3,a3,a4
    80005524:	40000613          	li	a2,1024
    80005528:	c690                	sw	a2,8(a3)
  if(write)
    8000552a:	140d0063          	beqz	s10,8000566a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000552e:	00018697          	auipc	a3,0x18
    80005532:	ad26b683          	ld	a3,-1326(a3) # 8001d000 <disk+0x2000>
    80005536:	96ba                	add	a3,a3,a4
    80005538:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000553c:	00016817          	auipc	a6,0x16
    80005540:	ac480813          	addi	a6,a6,-1340 # 8001b000 <disk>
    80005544:	00018517          	auipc	a0,0x18
    80005548:	abc50513          	addi	a0,a0,-1348 # 8001d000 <disk+0x2000>
    8000554c:	6114                	ld	a3,0(a0)
    8000554e:	96ba                	add	a3,a3,a4
    80005550:	00c6d603          	lhu	a2,12(a3)
    80005554:	00166613          	ori	a2,a2,1
    80005558:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000555c:	f9842683          	lw	a3,-104(s0)
    80005560:	6110                	ld	a2,0(a0)
    80005562:	9732                	add	a4,a4,a2
    80005564:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005568:	20058613          	addi	a2,a1,512
    8000556c:	0612                	slli	a2,a2,0x4
    8000556e:	9642                	add	a2,a2,a6
    80005570:	577d                	li	a4,-1
    80005572:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005576:	00469713          	slli	a4,a3,0x4
    8000557a:	6114                	ld	a3,0(a0)
    8000557c:	96ba                	add	a3,a3,a4
    8000557e:	03078793          	addi	a5,a5,48
    80005582:	97c2                	add	a5,a5,a6
    80005584:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005586:	611c                	ld	a5,0(a0)
    80005588:	97ba                	add	a5,a5,a4
    8000558a:	4685                	li	a3,1
    8000558c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000558e:	611c                	ld	a5,0(a0)
    80005590:	97ba                	add	a5,a5,a4
    80005592:	4809                	li	a6,2
    80005594:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005598:	611c                	ld	a5,0(a0)
    8000559a:	973e                	add	a4,a4,a5
    8000559c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055a0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800055a4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055a8:	6518                	ld	a4,8(a0)
    800055aa:	00275783          	lhu	a5,2(a4)
    800055ae:	8b9d                	andi	a5,a5,7
    800055b0:	0786                	slli	a5,a5,0x1
    800055b2:	97ba                	add	a5,a5,a4
    800055b4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055b8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055bc:	6518                	ld	a4,8(a0)
    800055be:	00275783          	lhu	a5,2(a4)
    800055c2:	2785                	addiw	a5,a5,1
    800055c4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055c8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055cc:	100017b7          	lui	a5,0x10001
    800055d0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055d4:	00492703          	lw	a4,4(s2)
    800055d8:	4785                	li	a5,1
    800055da:	02f71163          	bne	a4,a5,800055fc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055de:	00018997          	auipc	s3,0x18
    800055e2:	b4a98993          	addi	s3,s3,-1206 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055e6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055e8:	85ce                	mv	a1,s3
    800055ea:	854a                	mv	a0,s2
    800055ec:	ffffc097          	auipc	ra,0xffffc
    800055f0:	f6a080e7          	jalr	-150(ra) # 80001556 <sleep>
  while(b->disk == 1) {
    800055f4:	00492783          	lw	a5,4(s2)
    800055f8:	fe9788e3          	beq	a5,s1,800055e8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055fc:	f9042903          	lw	s2,-112(s0)
    80005600:	20090793          	addi	a5,s2,512
    80005604:	00479713          	slli	a4,a5,0x4
    80005608:	00016797          	auipc	a5,0x16
    8000560c:	9f878793          	addi	a5,a5,-1544 # 8001b000 <disk>
    80005610:	97ba                	add	a5,a5,a4
    80005612:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005616:	00018997          	auipc	s3,0x18
    8000561a:	9ea98993          	addi	s3,s3,-1558 # 8001d000 <disk+0x2000>
    8000561e:	00491713          	slli	a4,s2,0x4
    80005622:	0009b783          	ld	a5,0(s3)
    80005626:	97ba                	add	a5,a5,a4
    80005628:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000562c:	854a                	mv	a0,s2
    8000562e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005632:	00000097          	auipc	ra,0x0
    80005636:	bc4080e7          	jalr	-1084(ra) # 800051f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000563a:	8885                	andi	s1,s1,1
    8000563c:	f0ed                	bnez	s1,8000561e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000563e:	00018517          	auipc	a0,0x18
    80005642:	aea50513          	addi	a0,a0,-1302 # 8001d128 <disk+0x2128>
    80005646:	00001097          	auipc	ra,0x1
    8000564a:	c50080e7          	jalr	-944(ra) # 80006296 <release>
}
    8000564e:	70a6                	ld	ra,104(sp)
    80005650:	7406                	ld	s0,96(sp)
    80005652:	64e6                	ld	s1,88(sp)
    80005654:	6946                	ld	s2,80(sp)
    80005656:	69a6                	ld	s3,72(sp)
    80005658:	6a06                	ld	s4,64(sp)
    8000565a:	7ae2                	ld	s5,56(sp)
    8000565c:	7b42                	ld	s6,48(sp)
    8000565e:	7ba2                	ld	s7,40(sp)
    80005660:	7c02                	ld	s8,32(sp)
    80005662:	6ce2                	ld	s9,24(sp)
    80005664:	6d42                	ld	s10,16(sp)
    80005666:	6165                	addi	sp,sp,112
    80005668:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000566a:	00018697          	auipc	a3,0x18
    8000566e:	9966b683          	ld	a3,-1642(a3) # 8001d000 <disk+0x2000>
    80005672:	96ba                	add	a3,a3,a4
    80005674:	4609                	li	a2,2
    80005676:	00c69623          	sh	a2,12(a3)
    8000567a:	b5c9                	j	8000553c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000567c:	f9042583          	lw	a1,-112(s0)
    80005680:	20058793          	addi	a5,a1,512
    80005684:	0792                	slli	a5,a5,0x4
    80005686:	00016517          	auipc	a0,0x16
    8000568a:	a2250513          	addi	a0,a0,-1502 # 8001b0a8 <disk+0xa8>
    8000568e:	953e                	add	a0,a0,a5
  if(write)
    80005690:	e20d11e3          	bnez	s10,800054b2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005694:	20058713          	addi	a4,a1,512
    80005698:	00471693          	slli	a3,a4,0x4
    8000569c:	00016717          	auipc	a4,0x16
    800056a0:	96470713          	addi	a4,a4,-1692 # 8001b000 <disk>
    800056a4:	9736                	add	a4,a4,a3
    800056a6:	0a072423          	sw	zero,168(a4)
    800056aa:	b505                	j	800054ca <virtio_disk_rw+0xf4>

00000000800056ac <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056ac:	1101                	addi	sp,sp,-32
    800056ae:	ec06                	sd	ra,24(sp)
    800056b0:	e822                	sd	s0,16(sp)
    800056b2:	e426                	sd	s1,8(sp)
    800056b4:	e04a                	sd	s2,0(sp)
    800056b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056b8:	00018517          	auipc	a0,0x18
    800056bc:	a7050513          	addi	a0,a0,-1424 # 8001d128 <disk+0x2128>
    800056c0:	00001097          	auipc	ra,0x1
    800056c4:	b22080e7          	jalr	-1246(ra) # 800061e2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056c8:	10001737          	lui	a4,0x10001
    800056cc:	533c                	lw	a5,96(a4)
    800056ce:	8b8d                	andi	a5,a5,3
    800056d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056d6:	00018797          	auipc	a5,0x18
    800056da:	92a78793          	addi	a5,a5,-1750 # 8001d000 <disk+0x2000>
    800056de:	6b94                	ld	a3,16(a5)
    800056e0:	0207d703          	lhu	a4,32(a5)
    800056e4:	0026d783          	lhu	a5,2(a3)
    800056e8:	06f70163          	beq	a4,a5,8000574a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ec:	00016917          	auipc	s2,0x16
    800056f0:	91490913          	addi	s2,s2,-1772 # 8001b000 <disk>
    800056f4:	00018497          	auipc	s1,0x18
    800056f8:	90c48493          	addi	s1,s1,-1780 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056fc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005700:	6898                	ld	a4,16(s1)
    80005702:	0204d783          	lhu	a5,32(s1)
    80005706:	8b9d                	andi	a5,a5,7
    80005708:	078e                	slli	a5,a5,0x3
    8000570a:	97ba                	add	a5,a5,a4
    8000570c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000570e:	20078713          	addi	a4,a5,512
    80005712:	0712                	slli	a4,a4,0x4
    80005714:	974a                	add	a4,a4,s2
    80005716:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000571a:	e731                	bnez	a4,80005766 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000571c:	20078793          	addi	a5,a5,512
    80005720:	0792                	slli	a5,a5,0x4
    80005722:	97ca                	add	a5,a5,s2
    80005724:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005726:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000572a:	ffffc097          	auipc	ra,0xffffc
    8000572e:	fb8080e7          	jalr	-72(ra) # 800016e2 <wakeup>

    disk.used_idx += 1;
    80005732:	0204d783          	lhu	a5,32(s1)
    80005736:	2785                	addiw	a5,a5,1
    80005738:	17c2                	slli	a5,a5,0x30
    8000573a:	93c1                	srli	a5,a5,0x30
    8000573c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005740:	6898                	ld	a4,16(s1)
    80005742:	00275703          	lhu	a4,2(a4)
    80005746:	faf71be3          	bne	a4,a5,800056fc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000574a:	00018517          	auipc	a0,0x18
    8000574e:	9de50513          	addi	a0,a0,-1570 # 8001d128 <disk+0x2128>
    80005752:	00001097          	auipc	ra,0x1
    80005756:	b44080e7          	jalr	-1212(ra) # 80006296 <release>
}
    8000575a:	60e2                	ld	ra,24(sp)
    8000575c:	6442                	ld	s0,16(sp)
    8000575e:	64a2                	ld	s1,8(sp)
    80005760:	6902                	ld	s2,0(sp)
    80005762:	6105                	addi	sp,sp,32
    80005764:	8082                	ret
      panic("virtio_disk_intr status");
    80005766:	00003517          	auipc	a0,0x3
    8000576a:	0e250513          	addi	a0,a0,226 # 80008848 <syscalls+0x3b8>
    8000576e:	00000097          	auipc	ra,0x0
    80005772:	52a080e7          	jalr	1322(ra) # 80005c98 <panic>

0000000080005776 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005776:	1141                	addi	sp,sp,-16
    80005778:	e422                	sd	s0,8(sp)
    8000577a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000577c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005780:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005784:	0037979b          	slliw	a5,a5,0x3
    80005788:	02004737          	lui	a4,0x2004
    8000578c:	97ba                	add	a5,a5,a4
    8000578e:	0200c737          	lui	a4,0x200c
    80005792:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005796:	000f4637          	lui	a2,0xf4
    8000579a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000579e:	95b2                	add	a1,a1,a2
    800057a0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057a2:	00269713          	slli	a4,a3,0x2
    800057a6:	9736                	add	a4,a4,a3
    800057a8:	00371693          	slli	a3,a4,0x3
    800057ac:	00019717          	auipc	a4,0x19
    800057b0:	85470713          	addi	a4,a4,-1964 # 8001e000 <timer_scratch>
    800057b4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057b6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057b8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057ba:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057be:	00000797          	auipc	a5,0x0
    800057c2:	97278793          	addi	a5,a5,-1678 # 80005130 <timervec>
    800057c6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ca:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057ce:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057d6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057da:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057de:	30479073          	csrw	mie,a5
}
    800057e2:	6422                	ld	s0,8(sp)
    800057e4:	0141                	addi	sp,sp,16
    800057e6:	8082                	ret

00000000800057e8 <start>:
{
    800057e8:	1141                	addi	sp,sp,-16
    800057ea:	e406                	sd	ra,8(sp)
    800057ec:	e022                	sd	s0,0(sp)
    800057ee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057f0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057f4:	7779                	lui	a4,0xffffe
    800057f6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057fa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057fc:	6705                	lui	a4,0x1
    800057fe:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005802:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005804:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005808:	ffffb797          	auipc	a5,0xffffb
    8000580c:	b6878793          	addi	a5,a5,-1176 # 80000370 <main>
    80005810:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005814:	4781                	li	a5,0
    80005816:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000581a:	67c1                	lui	a5,0x10
    8000581c:	17fd                	addi	a5,a5,-1
    8000581e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005822:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005826:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000582a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000582e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005832:	57fd                	li	a5,-1
    80005834:	83a9                	srli	a5,a5,0xa
    80005836:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000583a:	47bd                	li	a5,15
    8000583c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005840:	00000097          	auipc	ra,0x0
    80005844:	f36080e7          	jalr	-202(ra) # 80005776 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005848:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000584c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000584e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005850:	30200073          	mret
}
    80005854:	60a2                	ld	ra,8(sp)
    80005856:	6402                	ld	s0,0(sp)
    80005858:	0141                	addi	sp,sp,16
    8000585a:	8082                	ret

000000008000585c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000585c:	715d                	addi	sp,sp,-80
    8000585e:	e486                	sd	ra,72(sp)
    80005860:	e0a2                	sd	s0,64(sp)
    80005862:	fc26                	sd	s1,56(sp)
    80005864:	f84a                	sd	s2,48(sp)
    80005866:	f44e                	sd	s3,40(sp)
    80005868:	f052                	sd	s4,32(sp)
    8000586a:	ec56                	sd	s5,24(sp)
    8000586c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000586e:	04c05663          	blez	a2,800058ba <consolewrite+0x5e>
    80005872:	8a2a                	mv	s4,a0
    80005874:	84ae                	mv	s1,a1
    80005876:	89b2                	mv	s3,a2
    80005878:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000587a:	5afd                	li	s5,-1
    8000587c:	4685                	li	a3,1
    8000587e:	8626                	mv	a2,s1
    80005880:	85d2                	mv	a1,s4
    80005882:	fbf40513          	addi	a0,s0,-65
    80005886:	ffffc097          	auipc	ra,0xffffc
    8000588a:	0ca080e7          	jalr	202(ra) # 80001950 <either_copyin>
    8000588e:	01550c63          	beq	a0,s5,800058a6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005892:	fbf44503          	lbu	a0,-65(s0)
    80005896:	00000097          	auipc	ra,0x0
    8000589a:	78e080e7          	jalr	1934(ra) # 80006024 <uartputc>
  for(i = 0; i < n; i++){
    8000589e:	2905                	addiw	s2,s2,1
    800058a0:	0485                	addi	s1,s1,1
    800058a2:	fd299de3          	bne	s3,s2,8000587c <consolewrite+0x20>
  }

  return i;
}
    800058a6:	854a                	mv	a0,s2
    800058a8:	60a6                	ld	ra,72(sp)
    800058aa:	6406                	ld	s0,64(sp)
    800058ac:	74e2                	ld	s1,56(sp)
    800058ae:	7942                	ld	s2,48(sp)
    800058b0:	79a2                	ld	s3,40(sp)
    800058b2:	7a02                	ld	s4,32(sp)
    800058b4:	6ae2                	ld	s5,24(sp)
    800058b6:	6161                	addi	sp,sp,80
    800058b8:	8082                	ret
  for(i = 0; i < n; i++){
    800058ba:	4901                	li	s2,0
    800058bc:	b7ed                	j	800058a6 <consolewrite+0x4a>

00000000800058be <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058be:	7119                	addi	sp,sp,-128
    800058c0:	fc86                	sd	ra,120(sp)
    800058c2:	f8a2                	sd	s0,112(sp)
    800058c4:	f4a6                	sd	s1,104(sp)
    800058c6:	f0ca                	sd	s2,96(sp)
    800058c8:	ecce                	sd	s3,88(sp)
    800058ca:	e8d2                	sd	s4,80(sp)
    800058cc:	e4d6                	sd	s5,72(sp)
    800058ce:	e0da                	sd	s6,64(sp)
    800058d0:	fc5e                	sd	s7,56(sp)
    800058d2:	f862                	sd	s8,48(sp)
    800058d4:	f466                	sd	s9,40(sp)
    800058d6:	f06a                	sd	s10,32(sp)
    800058d8:	ec6e                	sd	s11,24(sp)
    800058da:	0100                	addi	s0,sp,128
    800058dc:	8b2a                	mv	s6,a0
    800058de:	8aae                	mv	s5,a1
    800058e0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058e2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058e6:	00021517          	auipc	a0,0x21
    800058ea:	85a50513          	addi	a0,a0,-1958 # 80026140 <cons>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	8f4080e7          	jalr	-1804(ra) # 800061e2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058f6:	00021497          	auipc	s1,0x21
    800058fa:	84a48493          	addi	s1,s1,-1974 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058fe:	89a6                	mv	s3,s1
    80005900:	00021917          	auipc	s2,0x21
    80005904:	8d890913          	addi	s2,s2,-1832 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005908:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000590a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000590c:	4da9                	li	s11,10
  while(n > 0){
    8000590e:	07405863          	blez	s4,8000597e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005912:	0984a783          	lw	a5,152(s1)
    80005916:	09c4a703          	lw	a4,156(s1)
    8000591a:	02f71463          	bne	a4,a5,80005942 <consoleread+0x84>
      if(myproc()->killed){
    8000591e:	ffffb097          	auipc	ra,0xffffb
    80005922:	574080e7          	jalr	1396(ra) # 80000e92 <myproc>
    80005926:	551c                	lw	a5,40(a0)
    80005928:	e7b5                	bnez	a5,80005994 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000592a:	85ce                	mv	a1,s3
    8000592c:	854a                	mv	a0,s2
    8000592e:	ffffc097          	auipc	ra,0xffffc
    80005932:	c28080e7          	jalr	-984(ra) # 80001556 <sleep>
    while(cons.r == cons.w){
    80005936:	0984a783          	lw	a5,152(s1)
    8000593a:	09c4a703          	lw	a4,156(s1)
    8000593e:	fef700e3          	beq	a4,a5,8000591e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005942:	0017871b          	addiw	a4,a5,1
    80005946:	08e4ac23          	sw	a4,152(s1)
    8000594a:	07f7f713          	andi	a4,a5,127
    8000594e:	9726                	add	a4,a4,s1
    80005950:	01874703          	lbu	a4,24(a4)
    80005954:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005958:	079c0663          	beq	s8,s9,800059c4 <consoleread+0x106>
    cbuf = c;
    8000595c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005960:	4685                	li	a3,1
    80005962:	f8f40613          	addi	a2,s0,-113
    80005966:	85d6                	mv	a1,s5
    80005968:	855a                	mv	a0,s6
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	f90080e7          	jalr	-112(ra) # 800018fa <either_copyout>
    80005972:	01a50663          	beq	a0,s10,8000597e <consoleread+0xc0>
    dst++;
    80005976:	0a85                	addi	s5,s5,1
    --n;
    80005978:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000597a:	f9bc1ae3          	bne	s8,s11,8000590e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000597e:	00020517          	auipc	a0,0x20
    80005982:	7c250513          	addi	a0,a0,1986 # 80026140 <cons>
    80005986:	00001097          	auipc	ra,0x1
    8000598a:	910080e7          	jalr	-1776(ra) # 80006296 <release>

  return target - n;
    8000598e:	414b853b          	subw	a0,s7,s4
    80005992:	a811                	j	800059a6 <consoleread+0xe8>
        release(&cons.lock);
    80005994:	00020517          	auipc	a0,0x20
    80005998:	7ac50513          	addi	a0,a0,1964 # 80026140 <cons>
    8000599c:	00001097          	auipc	ra,0x1
    800059a0:	8fa080e7          	jalr	-1798(ra) # 80006296 <release>
        return -1;
    800059a4:	557d                	li	a0,-1
}
    800059a6:	70e6                	ld	ra,120(sp)
    800059a8:	7446                	ld	s0,112(sp)
    800059aa:	74a6                	ld	s1,104(sp)
    800059ac:	7906                	ld	s2,96(sp)
    800059ae:	69e6                	ld	s3,88(sp)
    800059b0:	6a46                	ld	s4,80(sp)
    800059b2:	6aa6                	ld	s5,72(sp)
    800059b4:	6b06                	ld	s6,64(sp)
    800059b6:	7be2                	ld	s7,56(sp)
    800059b8:	7c42                	ld	s8,48(sp)
    800059ba:	7ca2                	ld	s9,40(sp)
    800059bc:	7d02                	ld	s10,32(sp)
    800059be:	6de2                	ld	s11,24(sp)
    800059c0:	6109                	addi	sp,sp,128
    800059c2:	8082                	ret
      if(n < target){
    800059c4:	000a071b          	sext.w	a4,s4
    800059c8:	fb777be3          	bgeu	a4,s7,8000597e <consoleread+0xc0>
        cons.r--;
    800059cc:	00021717          	auipc	a4,0x21
    800059d0:	80f72623          	sw	a5,-2036(a4) # 800261d8 <cons+0x98>
    800059d4:	b76d                	j	8000597e <consoleread+0xc0>

00000000800059d6 <consputc>:
{
    800059d6:	1141                	addi	sp,sp,-16
    800059d8:	e406                	sd	ra,8(sp)
    800059da:	e022                	sd	s0,0(sp)
    800059dc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059de:	10000793          	li	a5,256
    800059e2:	00f50a63          	beq	a0,a5,800059f6 <consputc+0x20>
    uartputc_sync(c);
    800059e6:	00000097          	auipc	ra,0x0
    800059ea:	564080e7          	jalr	1380(ra) # 80005f4a <uartputc_sync>
}
    800059ee:	60a2                	ld	ra,8(sp)
    800059f0:	6402                	ld	s0,0(sp)
    800059f2:	0141                	addi	sp,sp,16
    800059f4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059f6:	4521                	li	a0,8
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	552080e7          	jalr	1362(ra) # 80005f4a <uartputc_sync>
    80005a00:	02000513          	li	a0,32
    80005a04:	00000097          	auipc	ra,0x0
    80005a08:	546080e7          	jalr	1350(ra) # 80005f4a <uartputc_sync>
    80005a0c:	4521                	li	a0,8
    80005a0e:	00000097          	auipc	ra,0x0
    80005a12:	53c080e7          	jalr	1340(ra) # 80005f4a <uartputc_sync>
    80005a16:	bfe1                	j	800059ee <consputc+0x18>

0000000080005a18 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a18:	1101                	addi	sp,sp,-32
    80005a1a:	ec06                	sd	ra,24(sp)
    80005a1c:	e822                	sd	s0,16(sp)
    80005a1e:	e426                	sd	s1,8(sp)
    80005a20:	e04a                	sd	s2,0(sp)
    80005a22:	1000                	addi	s0,sp,32
    80005a24:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a26:	00020517          	auipc	a0,0x20
    80005a2a:	71a50513          	addi	a0,a0,1818 # 80026140 <cons>
    80005a2e:	00000097          	auipc	ra,0x0
    80005a32:	7b4080e7          	jalr	1972(ra) # 800061e2 <acquire>

  switch(c){
    80005a36:	47d5                	li	a5,21
    80005a38:	0af48663          	beq	s1,a5,80005ae4 <consoleintr+0xcc>
    80005a3c:	0297ca63          	blt	a5,s1,80005a70 <consoleintr+0x58>
    80005a40:	47a1                	li	a5,8
    80005a42:	0ef48763          	beq	s1,a5,80005b30 <consoleintr+0x118>
    80005a46:	47c1                	li	a5,16
    80005a48:	10f49a63          	bne	s1,a5,80005b5c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a4c:	ffffc097          	auipc	ra,0xffffc
    80005a50:	f5a080e7          	jalr	-166(ra) # 800019a6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a54:	00020517          	auipc	a0,0x20
    80005a58:	6ec50513          	addi	a0,a0,1772 # 80026140 <cons>
    80005a5c:	00001097          	auipc	ra,0x1
    80005a60:	83a080e7          	jalr	-1990(ra) # 80006296 <release>
}
    80005a64:	60e2                	ld	ra,24(sp)
    80005a66:	6442                	ld	s0,16(sp)
    80005a68:	64a2                	ld	s1,8(sp)
    80005a6a:	6902                	ld	s2,0(sp)
    80005a6c:	6105                	addi	sp,sp,32
    80005a6e:	8082                	ret
  switch(c){
    80005a70:	07f00793          	li	a5,127
    80005a74:	0af48e63          	beq	s1,a5,80005b30 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a78:	00020717          	auipc	a4,0x20
    80005a7c:	6c870713          	addi	a4,a4,1736 # 80026140 <cons>
    80005a80:	0a072783          	lw	a5,160(a4)
    80005a84:	09872703          	lw	a4,152(a4)
    80005a88:	9f99                	subw	a5,a5,a4
    80005a8a:	07f00713          	li	a4,127
    80005a8e:	fcf763e3          	bltu	a4,a5,80005a54 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a92:	47b5                	li	a5,13
    80005a94:	0cf48763          	beq	s1,a5,80005b62 <consoleintr+0x14a>
      consputc(c);
    80005a98:	8526                	mv	a0,s1
    80005a9a:	00000097          	auipc	ra,0x0
    80005a9e:	f3c080e7          	jalr	-196(ra) # 800059d6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa2:	00020797          	auipc	a5,0x20
    80005aa6:	69e78793          	addi	a5,a5,1694 # 80026140 <cons>
    80005aaa:	0a07a703          	lw	a4,160(a5)
    80005aae:	0017069b          	addiw	a3,a4,1
    80005ab2:	0006861b          	sext.w	a2,a3
    80005ab6:	0ad7a023          	sw	a3,160(a5)
    80005aba:	07f77713          	andi	a4,a4,127
    80005abe:	97ba                	add	a5,a5,a4
    80005ac0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005ac4:	47a9                	li	a5,10
    80005ac6:	0cf48563          	beq	s1,a5,80005b90 <consoleintr+0x178>
    80005aca:	4791                	li	a5,4
    80005acc:	0cf48263          	beq	s1,a5,80005b90 <consoleintr+0x178>
    80005ad0:	00020797          	auipc	a5,0x20
    80005ad4:	7087a783          	lw	a5,1800(a5) # 800261d8 <cons+0x98>
    80005ad8:	0807879b          	addiw	a5,a5,128
    80005adc:	f6f61ce3          	bne	a2,a5,80005a54 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ae0:	863e                	mv	a2,a5
    80005ae2:	a07d                	j	80005b90 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ae4:	00020717          	auipc	a4,0x20
    80005ae8:	65c70713          	addi	a4,a4,1628 # 80026140 <cons>
    80005aec:	0a072783          	lw	a5,160(a4)
    80005af0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005af4:	00020497          	auipc	s1,0x20
    80005af8:	64c48493          	addi	s1,s1,1612 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005afc:	4929                	li	s2,10
    80005afe:	f4f70be3          	beq	a4,a5,80005a54 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b02:	37fd                	addiw	a5,a5,-1
    80005b04:	07f7f713          	andi	a4,a5,127
    80005b08:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b0a:	01874703          	lbu	a4,24(a4)
    80005b0e:	f52703e3          	beq	a4,s2,80005a54 <consoleintr+0x3c>
      cons.e--;
    80005b12:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b16:	10000513          	li	a0,256
    80005b1a:	00000097          	auipc	ra,0x0
    80005b1e:	ebc080e7          	jalr	-324(ra) # 800059d6 <consputc>
    while(cons.e != cons.w &&
    80005b22:	0a04a783          	lw	a5,160(s1)
    80005b26:	09c4a703          	lw	a4,156(s1)
    80005b2a:	fcf71ce3          	bne	a4,a5,80005b02 <consoleintr+0xea>
    80005b2e:	b71d                	j	80005a54 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b30:	00020717          	auipc	a4,0x20
    80005b34:	61070713          	addi	a4,a4,1552 # 80026140 <cons>
    80005b38:	0a072783          	lw	a5,160(a4)
    80005b3c:	09c72703          	lw	a4,156(a4)
    80005b40:	f0f70ae3          	beq	a4,a5,80005a54 <consoleintr+0x3c>
      cons.e--;
    80005b44:	37fd                	addiw	a5,a5,-1
    80005b46:	00020717          	auipc	a4,0x20
    80005b4a:	68f72d23          	sw	a5,1690(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b4e:	10000513          	li	a0,256
    80005b52:	00000097          	auipc	ra,0x0
    80005b56:	e84080e7          	jalr	-380(ra) # 800059d6 <consputc>
    80005b5a:	bded                	j	80005a54 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b5c:	ee048ce3          	beqz	s1,80005a54 <consoleintr+0x3c>
    80005b60:	bf21                	j	80005a78 <consoleintr+0x60>
      consputc(c);
    80005b62:	4529                	li	a0,10
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	e72080e7          	jalr	-398(ra) # 800059d6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b6c:	00020797          	auipc	a5,0x20
    80005b70:	5d478793          	addi	a5,a5,1492 # 80026140 <cons>
    80005b74:	0a07a703          	lw	a4,160(a5)
    80005b78:	0017069b          	addiw	a3,a4,1
    80005b7c:	0006861b          	sext.w	a2,a3
    80005b80:	0ad7a023          	sw	a3,160(a5)
    80005b84:	07f77713          	andi	a4,a4,127
    80005b88:	97ba                	add	a5,a5,a4
    80005b8a:	4729                	li	a4,10
    80005b8c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b90:	00020797          	auipc	a5,0x20
    80005b94:	64c7a623          	sw	a2,1612(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b98:	00020517          	auipc	a0,0x20
    80005b9c:	64050513          	addi	a0,a0,1600 # 800261d8 <cons+0x98>
    80005ba0:	ffffc097          	auipc	ra,0xffffc
    80005ba4:	b42080e7          	jalr	-1214(ra) # 800016e2 <wakeup>
    80005ba8:	b575                	j	80005a54 <consoleintr+0x3c>

0000000080005baa <consoleinit>:

void
consoleinit(void)
{
    80005baa:	1141                	addi	sp,sp,-16
    80005bac:	e406                	sd	ra,8(sp)
    80005bae:	e022                	sd	s0,0(sp)
    80005bb0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bb2:	00003597          	auipc	a1,0x3
    80005bb6:	cae58593          	addi	a1,a1,-850 # 80008860 <syscalls+0x3d0>
    80005bba:	00020517          	auipc	a0,0x20
    80005bbe:	58650513          	addi	a0,a0,1414 # 80026140 <cons>
    80005bc2:	00000097          	auipc	ra,0x0
    80005bc6:	590080e7          	jalr	1424(ra) # 80006152 <initlock>

  uartinit();
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	330080e7          	jalr	816(ra) # 80005efa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bd2:	00013797          	auipc	a5,0x13
    80005bd6:	6f678793          	addi	a5,a5,1782 # 800192c8 <devsw>
    80005bda:	00000717          	auipc	a4,0x0
    80005bde:	ce470713          	addi	a4,a4,-796 # 800058be <consoleread>
    80005be2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005be4:	00000717          	auipc	a4,0x0
    80005be8:	c7870713          	addi	a4,a4,-904 # 8000585c <consolewrite>
    80005bec:	ef98                	sd	a4,24(a5)
}
    80005bee:	60a2                	ld	ra,8(sp)
    80005bf0:	6402                	ld	s0,0(sp)
    80005bf2:	0141                	addi	sp,sp,16
    80005bf4:	8082                	ret

0000000080005bf6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bf6:	7179                	addi	sp,sp,-48
    80005bf8:	f406                	sd	ra,40(sp)
    80005bfa:	f022                	sd	s0,32(sp)
    80005bfc:	ec26                	sd	s1,24(sp)
    80005bfe:	e84a                	sd	s2,16(sp)
    80005c00:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c02:	c219                	beqz	a2,80005c08 <printint+0x12>
    80005c04:	08054663          	bltz	a0,80005c90 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c08:	2501                	sext.w	a0,a0
    80005c0a:	4881                	li	a7,0
    80005c0c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c10:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c12:	2581                	sext.w	a1,a1
    80005c14:	00003617          	auipc	a2,0x3
    80005c18:	c7c60613          	addi	a2,a2,-900 # 80008890 <digits>
    80005c1c:	883a                	mv	a6,a4
    80005c1e:	2705                	addiw	a4,a4,1
    80005c20:	02b577bb          	remuw	a5,a0,a1
    80005c24:	1782                	slli	a5,a5,0x20
    80005c26:	9381                	srli	a5,a5,0x20
    80005c28:	97b2                	add	a5,a5,a2
    80005c2a:	0007c783          	lbu	a5,0(a5)
    80005c2e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c32:	0005079b          	sext.w	a5,a0
    80005c36:	02b5553b          	divuw	a0,a0,a1
    80005c3a:	0685                	addi	a3,a3,1
    80005c3c:	feb7f0e3          	bgeu	a5,a1,80005c1c <printint+0x26>

  if(sign)
    80005c40:	00088b63          	beqz	a7,80005c56 <printint+0x60>
    buf[i++] = '-';
    80005c44:	fe040793          	addi	a5,s0,-32
    80005c48:	973e                	add	a4,a4,a5
    80005c4a:	02d00793          	li	a5,45
    80005c4e:	fef70823          	sb	a5,-16(a4)
    80005c52:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c56:	02e05763          	blez	a4,80005c84 <printint+0x8e>
    80005c5a:	fd040793          	addi	a5,s0,-48
    80005c5e:	00e784b3          	add	s1,a5,a4
    80005c62:	fff78913          	addi	s2,a5,-1
    80005c66:	993a                	add	s2,s2,a4
    80005c68:	377d                	addiw	a4,a4,-1
    80005c6a:	1702                	slli	a4,a4,0x20
    80005c6c:	9301                	srli	a4,a4,0x20
    80005c6e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c72:	fff4c503          	lbu	a0,-1(s1)
    80005c76:	00000097          	auipc	ra,0x0
    80005c7a:	d60080e7          	jalr	-672(ra) # 800059d6 <consputc>
  while(--i >= 0)
    80005c7e:	14fd                	addi	s1,s1,-1
    80005c80:	ff2499e3          	bne	s1,s2,80005c72 <printint+0x7c>
}
    80005c84:	70a2                	ld	ra,40(sp)
    80005c86:	7402                	ld	s0,32(sp)
    80005c88:	64e2                	ld	s1,24(sp)
    80005c8a:	6942                	ld	s2,16(sp)
    80005c8c:	6145                	addi	sp,sp,48
    80005c8e:	8082                	ret
    x = -xx;
    80005c90:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c94:	4885                	li	a7,1
    x = -xx;
    80005c96:	bf9d                	j	80005c0c <printint+0x16>

0000000080005c98 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c98:	1101                	addi	sp,sp,-32
    80005c9a:	ec06                	sd	ra,24(sp)
    80005c9c:	e822                	sd	s0,16(sp)
    80005c9e:	e426                	sd	s1,8(sp)
    80005ca0:	1000                	addi	s0,sp,32
    80005ca2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ca4:	00020797          	auipc	a5,0x20
    80005ca8:	5407ae23          	sw	zero,1372(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cac:	00003517          	auipc	a0,0x3
    80005cb0:	bbc50513          	addi	a0,a0,-1092 # 80008868 <syscalls+0x3d8>
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	02e080e7          	jalr	46(ra) # 80005ce2 <printf>
  printf(s);
    80005cbc:	8526                	mv	a0,s1
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	024080e7          	jalr	36(ra) # 80005ce2 <printf>
  printf("\n");
    80005cc6:	00002517          	auipc	a0,0x2
    80005cca:	38250513          	addi	a0,a0,898 # 80008048 <etext+0x48>
    80005cce:	00000097          	auipc	ra,0x0
    80005cd2:	014080e7          	jalr	20(ra) # 80005ce2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cd6:	4785                	li	a5,1
    80005cd8:	00003717          	auipc	a4,0x3
    80005cdc:	34f72223          	sw	a5,836(a4) # 8000901c <panicked>
  for(;;)
    80005ce0:	a001                	j	80005ce0 <panic+0x48>

0000000080005ce2 <printf>:
{
    80005ce2:	7131                	addi	sp,sp,-192
    80005ce4:	fc86                	sd	ra,120(sp)
    80005ce6:	f8a2                	sd	s0,112(sp)
    80005ce8:	f4a6                	sd	s1,104(sp)
    80005cea:	f0ca                	sd	s2,96(sp)
    80005cec:	ecce                	sd	s3,88(sp)
    80005cee:	e8d2                	sd	s4,80(sp)
    80005cf0:	e4d6                	sd	s5,72(sp)
    80005cf2:	e0da                	sd	s6,64(sp)
    80005cf4:	fc5e                	sd	s7,56(sp)
    80005cf6:	f862                	sd	s8,48(sp)
    80005cf8:	f466                	sd	s9,40(sp)
    80005cfa:	f06a                	sd	s10,32(sp)
    80005cfc:	ec6e                	sd	s11,24(sp)
    80005cfe:	0100                	addi	s0,sp,128
    80005d00:	8a2a                	mv	s4,a0
    80005d02:	e40c                	sd	a1,8(s0)
    80005d04:	e810                	sd	a2,16(s0)
    80005d06:	ec14                	sd	a3,24(s0)
    80005d08:	f018                	sd	a4,32(s0)
    80005d0a:	f41c                	sd	a5,40(s0)
    80005d0c:	03043823          	sd	a6,48(s0)
    80005d10:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d14:	00020d97          	auipc	s11,0x20
    80005d18:	4ecdad83          	lw	s11,1260(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d1c:	020d9b63          	bnez	s11,80005d52 <printf+0x70>
  if (fmt == 0)
    80005d20:	040a0263          	beqz	s4,80005d64 <printf+0x82>
  va_start(ap, fmt);
    80005d24:	00840793          	addi	a5,s0,8
    80005d28:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d2c:	000a4503          	lbu	a0,0(s4)
    80005d30:	16050263          	beqz	a0,80005e94 <printf+0x1b2>
    80005d34:	4481                	li	s1,0
    if(c != '%'){
    80005d36:	02500a93          	li	s5,37
    switch(c){
    80005d3a:	07000b13          	li	s6,112
  consputc('x');
    80005d3e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d40:	00003b97          	auipc	s7,0x3
    80005d44:	b50b8b93          	addi	s7,s7,-1200 # 80008890 <digits>
    switch(c){
    80005d48:	07300c93          	li	s9,115
    80005d4c:	06400c13          	li	s8,100
    80005d50:	a82d                	j	80005d8a <printf+0xa8>
    acquire(&pr.lock);
    80005d52:	00020517          	auipc	a0,0x20
    80005d56:	49650513          	addi	a0,a0,1174 # 800261e8 <pr>
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	488080e7          	jalr	1160(ra) # 800061e2 <acquire>
    80005d62:	bf7d                	j	80005d20 <printf+0x3e>
    panic("null fmt");
    80005d64:	00003517          	auipc	a0,0x3
    80005d68:	b1450513          	addi	a0,a0,-1260 # 80008878 <syscalls+0x3e8>
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	f2c080e7          	jalr	-212(ra) # 80005c98 <panic>
      consputc(c);
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	c62080e7          	jalr	-926(ra) # 800059d6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d7c:	2485                	addiw	s1,s1,1
    80005d7e:	009a07b3          	add	a5,s4,s1
    80005d82:	0007c503          	lbu	a0,0(a5)
    80005d86:	10050763          	beqz	a0,80005e94 <printf+0x1b2>
    if(c != '%'){
    80005d8a:	ff5515e3          	bne	a0,s5,80005d74 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d8e:	2485                	addiw	s1,s1,1
    80005d90:	009a07b3          	add	a5,s4,s1
    80005d94:	0007c783          	lbu	a5,0(a5)
    80005d98:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d9c:	cfe5                	beqz	a5,80005e94 <printf+0x1b2>
    switch(c){
    80005d9e:	05678a63          	beq	a5,s6,80005df2 <printf+0x110>
    80005da2:	02fb7663          	bgeu	s6,a5,80005dce <printf+0xec>
    80005da6:	09978963          	beq	a5,s9,80005e38 <printf+0x156>
    80005daa:	07800713          	li	a4,120
    80005dae:	0ce79863          	bne	a5,a4,80005e7e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005db2:	f8843783          	ld	a5,-120(s0)
    80005db6:	00878713          	addi	a4,a5,8
    80005dba:	f8e43423          	sd	a4,-120(s0)
    80005dbe:	4605                	li	a2,1
    80005dc0:	85ea                	mv	a1,s10
    80005dc2:	4388                	lw	a0,0(a5)
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	e32080e7          	jalr	-462(ra) # 80005bf6 <printint>
      break;
    80005dcc:	bf45                	j	80005d7c <printf+0x9a>
    switch(c){
    80005dce:	0b578263          	beq	a5,s5,80005e72 <printf+0x190>
    80005dd2:	0b879663          	bne	a5,s8,80005e7e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005dd6:	f8843783          	ld	a5,-120(s0)
    80005dda:	00878713          	addi	a4,a5,8
    80005dde:	f8e43423          	sd	a4,-120(s0)
    80005de2:	4605                	li	a2,1
    80005de4:	45a9                	li	a1,10
    80005de6:	4388                	lw	a0,0(a5)
    80005de8:	00000097          	auipc	ra,0x0
    80005dec:	e0e080e7          	jalr	-498(ra) # 80005bf6 <printint>
      break;
    80005df0:	b771                	j	80005d7c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005df2:	f8843783          	ld	a5,-120(s0)
    80005df6:	00878713          	addi	a4,a5,8
    80005dfa:	f8e43423          	sd	a4,-120(s0)
    80005dfe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e02:	03000513          	li	a0,48
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	bd0080e7          	jalr	-1072(ra) # 800059d6 <consputc>
  consputc('x');
    80005e0e:	07800513          	li	a0,120
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	bc4080e7          	jalr	-1084(ra) # 800059d6 <consputc>
    80005e1a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e1c:	03c9d793          	srli	a5,s3,0x3c
    80005e20:	97de                	add	a5,a5,s7
    80005e22:	0007c503          	lbu	a0,0(a5)
    80005e26:	00000097          	auipc	ra,0x0
    80005e2a:	bb0080e7          	jalr	-1104(ra) # 800059d6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e2e:	0992                	slli	s3,s3,0x4
    80005e30:	397d                	addiw	s2,s2,-1
    80005e32:	fe0915e3          	bnez	s2,80005e1c <printf+0x13a>
    80005e36:	b799                	j	80005d7c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e38:	f8843783          	ld	a5,-120(s0)
    80005e3c:	00878713          	addi	a4,a5,8
    80005e40:	f8e43423          	sd	a4,-120(s0)
    80005e44:	0007b903          	ld	s2,0(a5)
    80005e48:	00090e63          	beqz	s2,80005e64 <printf+0x182>
      for(; *s; s++)
    80005e4c:	00094503          	lbu	a0,0(s2)
    80005e50:	d515                	beqz	a0,80005d7c <printf+0x9a>
        consputc(*s);
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	b84080e7          	jalr	-1148(ra) # 800059d6 <consputc>
      for(; *s; s++)
    80005e5a:	0905                	addi	s2,s2,1
    80005e5c:	00094503          	lbu	a0,0(s2)
    80005e60:	f96d                	bnez	a0,80005e52 <printf+0x170>
    80005e62:	bf29                	j	80005d7c <printf+0x9a>
        s = "(null)";
    80005e64:	00003917          	auipc	s2,0x3
    80005e68:	a0c90913          	addi	s2,s2,-1524 # 80008870 <syscalls+0x3e0>
      for(; *s; s++)
    80005e6c:	02800513          	li	a0,40
    80005e70:	b7cd                	j	80005e52 <printf+0x170>
      consputc('%');
    80005e72:	8556                	mv	a0,s5
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	b62080e7          	jalr	-1182(ra) # 800059d6 <consputc>
      break;
    80005e7c:	b701                	j	80005d7c <printf+0x9a>
      consputc('%');
    80005e7e:	8556                	mv	a0,s5
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	b56080e7          	jalr	-1194(ra) # 800059d6 <consputc>
      consputc(c);
    80005e88:	854a                	mv	a0,s2
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	b4c080e7          	jalr	-1204(ra) # 800059d6 <consputc>
      break;
    80005e92:	b5ed                	j	80005d7c <printf+0x9a>
  if(locking)
    80005e94:	020d9163          	bnez	s11,80005eb6 <printf+0x1d4>
}
    80005e98:	70e6                	ld	ra,120(sp)
    80005e9a:	7446                	ld	s0,112(sp)
    80005e9c:	74a6                	ld	s1,104(sp)
    80005e9e:	7906                	ld	s2,96(sp)
    80005ea0:	69e6                	ld	s3,88(sp)
    80005ea2:	6a46                	ld	s4,80(sp)
    80005ea4:	6aa6                	ld	s5,72(sp)
    80005ea6:	6b06                	ld	s6,64(sp)
    80005ea8:	7be2                	ld	s7,56(sp)
    80005eaa:	7c42                	ld	s8,48(sp)
    80005eac:	7ca2                	ld	s9,40(sp)
    80005eae:	7d02                	ld	s10,32(sp)
    80005eb0:	6de2                	ld	s11,24(sp)
    80005eb2:	6129                	addi	sp,sp,192
    80005eb4:	8082                	ret
    release(&pr.lock);
    80005eb6:	00020517          	auipc	a0,0x20
    80005eba:	33250513          	addi	a0,a0,818 # 800261e8 <pr>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	3d8080e7          	jalr	984(ra) # 80006296 <release>
}
    80005ec6:	bfc9                	j	80005e98 <printf+0x1b6>

0000000080005ec8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ec8:	1101                	addi	sp,sp,-32
    80005eca:	ec06                	sd	ra,24(sp)
    80005ecc:	e822                	sd	s0,16(sp)
    80005ece:	e426                	sd	s1,8(sp)
    80005ed0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ed2:	00020497          	auipc	s1,0x20
    80005ed6:	31648493          	addi	s1,s1,790 # 800261e8 <pr>
    80005eda:	00003597          	auipc	a1,0x3
    80005ede:	9ae58593          	addi	a1,a1,-1618 # 80008888 <syscalls+0x3f8>
    80005ee2:	8526                	mv	a0,s1
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	26e080e7          	jalr	622(ra) # 80006152 <initlock>
  pr.locking = 1;
    80005eec:	4785                	li	a5,1
    80005eee:	cc9c                	sw	a5,24(s1)
}
    80005ef0:	60e2                	ld	ra,24(sp)
    80005ef2:	6442                	ld	s0,16(sp)
    80005ef4:	64a2                	ld	s1,8(sp)
    80005ef6:	6105                	addi	sp,sp,32
    80005ef8:	8082                	ret

0000000080005efa <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005efa:	1141                	addi	sp,sp,-16
    80005efc:	e406                	sd	ra,8(sp)
    80005efe:	e022                	sd	s0,0(sp)
    80005f00:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f02:	100007b7          	lui	a5,0x10000
    80005f06:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f0a:	f8000713          	li	a4,-128
    80005f0e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f12:	470d                	li	a4,3
    80005f14:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f18:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f1c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f20:	469d                	li	a3,7
    80005f22:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f26:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f2a:	00003597          	auipc	a1,0x3
    80005f2e:	97e58593          	addi	a1,a1,-1666 # 800088a8 <digits+0x18>
    80005f32:	00020517          	auipc	a0,0x20
    80005f36:	2d650513          	addi	a0,a0,726 # 80026208 <uart_tx_lock>
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	218080e7          	jalr	536(ra) # 80006152 <initlock>
}
    80005f42:	60a2                	ld	ra,8(sp)
    80005f44:	6402                	ld	s0,0(sp)
    80005f46:	0141                	addi	sp,sp,16
    80005f48:	8082                	ret

0000000080005f4a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f4a:	1101                	addi	sp,sp,-32
    80005f4c:	ec06                	sd	ra,24(sp)
    80005f4e:	e822                	sd	s0,16(sp)
    80005f50:	e426                	sd	s1,8(sp)
    80005f52:	1000                	addi	s0,sp,32
    80005f54:	84aa                	mv	s1,a0
  push_off();
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	240080e7          	jalr	576(ra) # 80006196 <push_off>

  if(panicked){
    80005f5e:	00003797          	auipc	a5,0x3
    80005f62:	0be7a783          	lw	a5,190(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f66:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f6a:	c391                	beqz	a5,80005f6e <uartputc_sync+0x24>
    for(;;)
    80005f6c:	a001                	j	80005f6c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f6e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f72:	0ff7f793          	andi	a5,a5,255
    80005f76:	0207f793          	andi	a5,a5,32
    80005f7a:	dbf5                	beqz	a5,80005f6e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f7c:	0ff4f793          	andi	a5,s1,255
    80005f80:	10000737          	lui	a4,0x10000
    80005f84:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	2ae080e7          	jalr	686(ra) # 80006236 <pop_off>
}
    80005f90:	60e2                	ld	ra,24(sp)
    80005f92:	6442                	ld	s0,16(sp)
    80005f94:	64a2                	ld	s1,8(sp)
    80005f96:	6105                	addi	sp,sp,32
    80005f98:	8082                	ret

0000000080005f9a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f9a:	00003717          	auipc	a4,0x3
    80005f9e:	08673703          	ld	a4,134(a4) # 80009020 <uart_tx_r>
    80005fa2:	00003797          	auipc	a5,0x3
    80005fa6:	0867b783          	ld	a5,134(a5) # 80009028 <uart_tx_w>
    80005faa:	06e78c63          	beq	a5,a4,80006022 <uartstart+0x88>
{
    80005fae:	7139                	addi	sp,sp,-64
    80005fb0:	fc06                	sd	ra,56(sp)
    80005fb2:	f822                	sd	s0,48(sp)
    80005fb4:	f426                	sd	s1,40(sp)
    80005fb6:	f04a                	sd	s2,32(sp)
    80005fb8:	ec4e                	sd	s3,24(sp)
    80005fba:	e852                	sd	s4,16(sp)
    80005fbc:	e456                	sd	s5,8(sp)
    80005fbe:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fc0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fc4:	00020a17          	auipc	s4,0x20
    80005fc8:	244a0a13          	addi	s4,s4,580 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fcc:	00003497          	auipc	s1,0x3
    80005fd0:	05448493          	addi	s1,s1,84 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fd4:	00003997          	auipc	s3,0x3
    80005fd8:	05498993          	addi	s3,s3,84 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fdc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fe0:	0ff7f793          	andi	a5,a5,255
    80005fe4:	0207f793          	andi	a5,a5,32
    80005fe8:	c785                	beqz	a5,80006010 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fea:	01f77793          	andi	a5,a4,31
    80005fee:	97d2                	add	a5,a5,s4
    80005ff0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005ff4:	0705                	addi	a4,a4,1
    80005ff6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ff8:	8526                	mv	a0,s1
    80005ffa:	ffffb097          	auipc	ra,0xffffb
    80005ffe:	6e8080e7          	jalr	1768(ra) # 800016e2 <wakeup>
    
    WriteReg(THR, c);
    80006002:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006006:	6098                	ld	a4,0(s1)
    80006008:	0009b783          	ld	a5,0(s3)
    8000600c:	fce798e3          	bne	a5,a4,80005fdc <uartstart+0x42>
  }
}
    80006010:	70e2                	ld	ra,56(sp)
    80006012:	7442                	ld	s0,48(sp)
    80006014:	74a2                	ld	s1,40(sp)
    80006016:	7902                	ld	s2,32(sp)
    80006018:	69e2                	ld	s3,24(sp)
    8000601a:	6a42                	ld	s4,16(sp)
    8000601c:	6aa2                	ld	s5,8(sp)
    8000601e:	6121                	addi	sp,sp,64
    80006020:	8082                	ret
    80006022:	8082                	ret

0000000080006024 <uartputc>:
{
    80006024:	7179                	addi	sp,sp,-48
    80006026:	f406                	sd	ra,40(sp)
    80006028:	f022                	sd	s0,32(sp)
    8000602a:	ec26                	sd	s1,24(sp)
    8000602c:	e84a                	sd	s2,16(sp)
    8000602e:	e44e                	sd	s3,8(sp)
    80006030:	e052                	sd	s4,0(sp)
    80006032:	1800                	addi	s0,sp,48
    80006034:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006036:	00020517          	auipc	a0,0x20
    8000603a:	1d250513          	addi	a0,a0,466 # 80026208 <uart_tx_lock>
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	1a4080e7          	jalr	420(ra) # 800061e2 <acquire>
  if(panicked){
    80006046:	00003797          	auipc	a5,0x3
    8000604a:	fd67a783          	lw	a5,-42(a5) # 8000901c <panicked>
    8000604e:	c391                	beqz	a5,80006052 <uartputc+0x2e>
    for(;;)
    80006050:	a001                	j	80006050 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006052:	00003797          	auipc	a5,0x3
    80006056:	fd67b783          	ld	a5,-42(a5) # 80009028 <uart_tx_w>
    8000605a:	00003717          	auipc	a4,0x3
    8000605e:	fc673703          	ld	a4,-58(a4) # 80009020 <uart_tx_r>
    80006062:	02070713          	addi	a4,a4,32
    80006066:	02f71b63          	bne	a4,a5,8000609c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000606a:	00020a17          	auipc	s4,0x20
    8000606e:	19ea0a13          	addi	s4,s4,414 # 80026208 <uart_tx_lock>
    80006072:	00003497          	auipc	s1,0x3
    80006076:	fae48493          	addi	s1,s1,-82 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607a:	00003917          	auipc	s2,0x3
    8000607e:	fae90913          	addi	s2,s2,-82 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006082:	85d2                	mv	a1,s4
    80006084:	8526                	mv	a0,s1
    80006086:	ffffb097          	auipc	ra,0xffffb
    8000608a:	4d0080e7          	jalr	1232(ra) # 80001556 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000608e:	00093783          	ld	a5,0(s2)
    80006092:	6098                	ld	a4,0(s1)
    80006094:	02070713          	addi	a4,a4,32
    80006098:	fef705e3          	beq	a4,a5,80006082 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000609c:	00020497          	auipc	s1,0x20
    800060a0:	16c48493          	addi	s1,s1,364 # 80026208 <uart_tx_lock>
    800060a4:	01f7f713          	andi	a4,a5,31
    800060a8:	9726                	add	a4,a4,s1
    800060aa:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060ae:	0785                	addi	a5,a5,1
    800060b0:	00003717          	auipc	a4,0x3
    800060b4:	f6f73c23          	sd	a5,-136(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	ee2080e7          	jalr	-286(ra) # 80005f9a <uartstart>
      release(&uart_tx_lock);
    800060c0:	8526                	mv	a0,s1
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	1d4080e7          	jalr	468(ra) # 80006296 <release>
}
    800060ca:	70a2                	ld	ra,40(sp)
    800060cc:	7402                	ld	s0,32(sp)
    800060ce:	64e2                	ld	s1,24(sp)
    800060d0:	6942                	ld	s2,16(sp)
    800060d2:	69a2                	ld	s3,8(sp)
    800060d4:	6a02                	ld	s4,0(sp)
    800060d6:	6145                	addi	sp,sp,48
    800060d8:	8082                	ret

00000000800060da <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060da:	1141                	addi	sp,sp,-16
    800060dc:	e422                	sd	s0,8(sp)
    800060de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060e0:	100007b7          	lui	a5,0x10000
    800060e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060e8:	8b85                	andi	a5,a5,1
    800060ea:	cb91                	beqz	a5,800060fe <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060ec:	100007b7          	lui	a5,0x10000
    800060f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060f4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060f8:	6422                	ld	s0,8(sp)
    800060fa:	0141                	addi	sp,sp,16
    800060fc:	8082                	ret
    return -1;
    800060fe:	557d                	li	a0,-1
    80006100:	bfe5                	j	800060f8 <uartgetc+0x1e>

0000000080006102 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006102:	1101                	addi	sp,sp,-32
    80006104:	ec06                	sd	ra,24(sp)
    80006106:	e822                	sd	s0,16(sp)
    80006108:	e426                	sd	s1,8(sp)
    8000610a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000610c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	fcc080e7          	jalr	-52(ra) # 800060da <uartgetc>
    if(c == -1)
    80006116:	00950763          	beq	a0,s1,80006124 <uartintr+0x22>
      break;
    consoleintr(c);
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	8fe080e7          	jalr	-1794(ra) # 80005a18 <consoleintr>
  while(1){
    80006122:	b7f5                	j	8000610e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006124:	00020497          	auipc	s1,0x20
    80006128:	0e448493          	addi	s1,s1,228 # 80026208 <uart_tx_lock>
    8000612c:	8526                	mv	a0,s1
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	0b4080e7          	jalr	180(ra) # 800061e2 <acquire>
  uartstart();
    80006136:	00000097          	auipc	ra,0x0
    8000613a:	e64080e7          	jalr	-412(ra) # 80005f9a <uartstart>
  release(&uart_tx_lock);
    8000613e:	8526                	mv	a0,s1
    80006140:	00000097          	auipc	ra,0x0
    80006144:	156080e7          	jalr	342(ra) # 80006296 <release>
}
    80006148:	60e2                	ld	ra,24(sp)
    8000614a:	6442                	ld	s0,16(sp)
    8000614c:	64a2                	ld	s1,8(sp)
    8000614e:	6105                	addi	sp,sp,32
    80006150:	8082                	ret

0000000080006152 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006152:	1141                	addi	sp,sp,-16
    80006154:	e422                	sd	s0,8(sp)
    80006156:	0800                	addi	s0,sp,16
  lk->name = name;
    80006158:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000615a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000615e:	00053823          	sd	zero,16(a0)
}
    80006162:	6422                	ld	s0,8(sp)
    80006164:	0141                	addi	sp,sp,16
    80006166:	8082                	ret

0000000080006168 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006168:	411c                	lw	a5,0(a0)
    8000616a:	e399                	bnez	a5,80006170 <holding+0x8>
    8000616c:	4501                	li	a0,0
  return r;
}
    8000616e:	8082                	ret
{
    80006170:	1101                	addi	sp,sp,-32
    80006172:	ec06                	sd	ra,24(sp)
    80006174:	e822                	sd	s0,16(sp)
    80006176:	e426                	sd	s1,8(sp)
    80006178:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000617a:	6904                	ld	s1,16(a0)
    8000617c:	ffffb097          	auipc	ra,0xffffb
    80006180:	cfa080e7          	jalr	-774(ra) # 80000e76 <mycpu>
    80006184:	40a48533          	sub	a0,s1,a0
    80006188:	00153513          	seqz	a0,a0
}
    8000618c:	60e2                	ld	ra,24(sp)
    8000618e:	6442                	ld	s0,16(sp)
    80006190:	64a2                	ld	s1,8(sp)
    80006192:	6105                	addi	sp,sp,32
    80006194:	8082                	ret

0000000080006196 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006196:	1101                	addi	sp,sp,-32
    80006198:	ec06                	sd	ra,24(sp)
    8000619a:	e822                	sd	s0,16(sp)
    8000619c:	e426                	sd	s1,8(sp)
    8000619e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061a0:	100024f3          	csrr	s1,sstatus
    800061a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061a8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061aa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061ae:	ffffb097          	auipc	ra,0xffffb
    800061b2:	cc8080e7          	jalr	-824(ra) # 80000e76 <mycpu>
    800061b6:	5d3c                	lw	a5,120(a0)
    800061b8:	cf89                	beqz	a5,800061d2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ba:	ffffb097          	auipc	ra,0xffffb
    800061be:	cbc080e7          	jalr	-836(ra) # 80000e76 <mycpu>
    800061c2:	5d3c                	lw	a5,120(a0)
    800061c4:	2785                	addiw	a5,a5,1
    800061c6:	dd3c                	sw	a5,120(a0)
}
    800061c8:	60e2                	ld	ra,24(sp)
    800061ca:	6442                	ld	s0,16(sp)
    800061cc:	64a2                	ld	s1,8(sp)
    800061ce:	6105                	addi	sp,sp,32
    800061d0:	8082                	ret
    mycpu()->intena = old;
    800061d2:	ffffb097          	auipc	ra,0xffffb
    800061d6:	ca4080e7          	jalr	-860(ra) # 80000e76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061da:	8085                	srli	s1,s1,0x1
    800061dc:	8885                	andi	s1,s1,1
    800061de:	dd64                	sw	s1,124(a0)
    800061e0:	bfe9                	j	800061ba <push_off+0x24>

00000000800061e2 <acquire>:
{
    800061e2:	1101                	addi	sp,sp,-32
    800061e4:	ec06                	sd	ra,24(sp)
    800061e6:	e822                	sd	s0,16(sp)
    800061e8:	e426                	sd	s1,8(sp)
    800061ea:	1000                	addi	s0,sp,32
    800061ec:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	fa8080e7          	jalr	-88(ra) # 80006196 <push_off>
  if(holding(lk))
    800061f6:	8526                	mv	a0,s1
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	f70080e7          	jalr	-144(ra) # 80006168 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006200:	4705                	li	a4,1
  if(holding(lk))
    80006202:	e115                	bnez	a0,80006226 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006204:	87ba                	mv	a5,a4
    80006206:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000620a:	2781                	sext.w	a5,a5
    8000620c:	ffe5                	bnez	a5,80006204 <acquire+0x22>
  __sync_synchronize();
    8000620e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006212:	ffffb097          	auipc	ra,0xffffb
    80006216:	c64080e7          	jalr	-924(ra) # 80000e76 <mycpu>
    8000621a:	e888                	sd	a0,16(s1)
}
    8000621c:	60e2                	ld	ra,24(sp)
    8000621e:	6442                	ld	s0,16(sp)
    80006220:	64a2                	ld	s1,8(sp)
    80006222:	6105                	addi	sp,sp,32
    80006224:	8082                	ret
    panic("acquire");
    80006226:	00002517          	auipc	a0,0x2
    8000622a:	68a50513          	addi	a0,a0,1674 # 800088b0 <digits+0x20>
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	a6a080e7          	jalr	-1430(ra) # 80005c98 <panic>

0000000080006236 <pop_off>:

void
pop_off(void)
{
    80006236:	1141                	addi	sp,sp,-16
    80006238:	e406                	sd	ra,8(sp)
    8000623a:	e022                	sd	s0,0(sp)
    8000623c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	c38080e7          	jalr	-968(ra) # 80000e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006246:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000624a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000624c:	e78d                	bnez	a5,80006276 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000624e:	5d3c                	lw	a5,120(a0)
    80006250:	02f05b63          	blez	a5,80006286 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006254:	37fd                	addiw	a5,a5,-1
    80006256:	0007871b          	sext.w	a4,a5
    8000625a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000625c:	eb09                	bnez	a4,8000626e <pop_off+0x38>
    8000625e:	5d7c                	lw	a5,124(a0)
    80006260:	c799                	beqz	a5,8000626e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006262:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006266:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000626e:	60a2                	ld	ra,8(sp)
    80006270:	6402                	ld	s0,0(sp)
    80006272:	0141                	addi	sp,sp,16
    80006274:	8082                	ret
    panic("pop_off - interruptible");
    80006276:	00002517          	auipc	a0,0x2
    8000627a:	64250513          	addi	a0,a0,1602 # 800088b8 <digits+0x28>
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	a1a080e7          	jalr	-1510(ra) # 80005c98 <panic>
    panic("pop_off");
    80006286:	00002517          	auipc	a0,0x2
    8000628a:	64a50513          	addi	a0,a0,1610 # 800088d0 <digits+0x40>
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	a0a080e7          	jalr	-1526(ra) # 80005c98 <panic>

0000000080006296 <release>:
{
    80006296:	1101                	addi	sp,sp,-32
    80006298:	ec06                	sd	ra,24(sp)
    8000629a:	e822                	sd	s0,16(sp)
    8000629c:	e426                	sd	s1,8(sp)
    8000629e:	1000                	addi	s0,sp,32
    800062a0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	ec6080e7          	jalr	-314(ra) # 80006168 <holding>
    800062aa:	c115                	beqz	a0,800062ce <release+0x38>
  lk->cpu = 0;
    800062ac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062b0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062b4:	0f50000f          	fence	iorw,ow
    800062b8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062bc:	00000097          	auipc	ra,0x0
    800062c0:	f7a080e7          	jalr	-134(ra) # 80006236 <pop_off>
}
    800062c4:	60e2                	ld	ra,24(sp)
    800062c6:	6442                	ld	s0,16(sp)
    800062c8:	64a2                	ld	s1,8(sp)
    800062ca:	6105                	addi	sp,sp,32
    800062cc:	8082                	ret
    panic("release");
    800062ce:	00002517          	auipc	a0,0x2
    800062d2:	60a50513          	addi	a0,a0,1546 # 800088d8 <digits+0x48>
    800062d6:	00000097          	auipc	ra,0x0
    800062da:	9c2080e7          	jalr	-1598(ra) # 80005c98 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
