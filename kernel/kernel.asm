
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8e013103          	ld	sp,-1824(sp) # 800088e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	798050ef          	jal	ra,800057ae <start>

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
    80000030:	00022797          	auipc	a5,0x22
    80000034:	f7078793          	addi	a5,a5,-144 # 80021fa0 <end>
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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8e090913          	addi	s2,s2,-1824 # 80008930 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	142080e7          	jalr	322(ra) # 8000619c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1e2080e7          	jalr	482(ra) # 80006250 <release>
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
    8000008e:	bd6080e7          	jalr	-1066(ra) # 80005c60 <panic>

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
    800000f0:	84450513          	addi	a0,a0,-1980 # 80008930 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	018080e7          	jalr	24(ra) # 8000610c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	ea050513          	addi	a0,a0,-352 # 80021fa0 <end>
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
    80000126:	80e48493          	addi	s1,s1,-2034 # 80008930 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	070080e7          	jalr	112(ra) # 8000619c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7f650513          	addi	a0,a0,2038 # 80008930 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	10c080e7          	jalr	268(ra) # 80006250 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	7ca50513          	addi	a0,a0,1994 # 80008930 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	0e2080e7          	jalr	226(ra) # 80006250 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	afc080e7          	jalr	-1284(ra) # 80000e22 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	5d270713          	addi	a4,a4,1490 # 80008900 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ae0080e7          	jalr	-1312(ra) # 80000e22 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	956080e7          	jalr	-1706(ra) # 80005caa <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	862080e7          	jalr	-1950(ra) # 80001bc6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	df4080e7          	jalr	-524(ra) # 80005160 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	0ac080e7          	jalr	172(ra) # 80001420 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	7f4080e7          	jalr	2036(ra) # 80005b70 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b06080e7          	jalr	-1274(ra) # 80005e8a <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	916080e7          	jalr	-1770(ra) # 80005caa <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	906080e7          	jalr	-1786(ra) # 80005caa <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	8f6080e7          	jalr	-1802(ra) # 80005caa <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	99c080e7          	jalr	-1636(ra) # 80000d70 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	7c2080e7          	jalr	1986(ra) # 80001b9e <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	7e2080e7          	jalr	2018(ra) # 80001bc6 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	d5e080e7          	jalr	-674(ra) # 8000514a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d6c080e7          	jalr	-660(ra) # 80005160 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f14080e7          	jalr	-236(ra) # 80002310 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	5b8080e7          	jalr	1464(ra) # 800029bc <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	556080e7          	jalr	1366(ra) # 80003962 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	e54080e7          	jalr	-428(ra) # 80005268 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	de6080e7          	jalr	-538(ra) # 80001202 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	4cf72b23          	sw	a5,1238(a4) # 80008900 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	4ca7b783          	ld	a5,1226(a5) # 80008908 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	7d6080e7          	jalr	2006(ra) # 80005c60 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c82080e7          	jalr	-894(ra) # 80000118 <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd2080e7          	jalr	-814(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	00a7d513          	srli	a0,a5,0xa
    8000053c:	0532                	slli	a0,a0,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	77fd                	lui	a5,0xfffff
    80000562:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000566:	15fd                	addi	a1,a1,-1
    80000568:	00c589b3          	add	s3,a1,a2
    8000056c:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000570:	8952                	mv	s2,s4
    80000572:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	6b0080e7          	jalr	1712(ra) # 80005c60 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	6a0080e7          	jalr	1696(ra) # 80005c60 <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	654080e7          	jalr	1620(ra) # 80005c60 <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	af8080e7          	jalr	-1288(ra) # 80000118 <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4a080e7          	jalr	-1206(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	20a7b723          	sd	a0,526(a5) # 80008908 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	508080e7          	jalr	1288(ra) # 80005c60 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	4f8080e7          	jalr	1272(ra) # 80005c60 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	4e8080e7          	jalr	1256(ra) # 80005c60 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	4d8080e7          	jalr	1240(ra) # 80005c60 <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	940080e7          	jalr	-1728(ra) # 80000118 <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	990080e7          	jalr	-1648(ra) # 80000178 <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	900080e7          	jalr	-1792(ra) # 80000118 <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	952080e7          	jalr	-1710(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	98e080e7          	jalr	-1650(ra) # 800001d4 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	3fa080e7          	jalr	1018(ra) # 80005c60 <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	767d                	lui	a2,0xfffff
    8000088a:	8f71                	and	a4,a4,a2
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff1                	and	a5,a5,a2
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6985                	lui	s3,0x1
    800008d4:	19fd                	addi	s3,s3,-1
    800008d6:	95ce                	add	a1,a1,s3
    800008d8:	79fd                	lui	s3,0xfffff
    800008da:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	830080e7          	jalr	-2000(ra) # 80000118 <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	880080e7          	jalr	-1920(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a821                	j	8000099a <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000986:	0532                	slli	a0,a0,0xc
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	fe0080e7          	jalr	-32(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000990:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000994:	04a1                	addi	s1,s1,8
    80000996:	03248163          	beq	s1,s2,800009b8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000099a:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099c:	00f57793          	andi	a5,a0,15
    800009a0:	ff3782e3          	beq	a5,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a4:	8905                	andi	a0,a0,1
    800009a6:	d57d                	beqz	a0,80000994 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a8:	00007517          	auipc	a0,0x7
    800009ac:	75050513          	addi	a0,a0,1872 # 800080f8 <etext+0xf8>
    800009b0:	00005097          	auipc	ra,0x5
    800009b4:	2b0080e7          	jalr	688(ra) # 80005c60 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b8:	8552                	mv	a0,s4
    800009ba:	fffff097          	auipc	ra,0xfffff
    800009be:	662080e7          	jalr	1634(ra) # 8000001c <kfree>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret

00000000800009d2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d2:	1101                	addi	sp,sp,-32
    800009d4:	ec06                	sd	ra,24(sp)
    800009d6:	e822                	sd	s0,16(sp)
    800009d8:	e426                	sd	s1,8(sp)
    800009da:	1000                	addi	s0,sp,32
    800009dc:	84aa                	mv	s1,a0
  if(sz > 0)
    800009de:	e999                	bnez	a1,800009f4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e0:	8526                	mv	a0,s1
    800009e2:	00000097          	auipc	ra,0x0
    800009e6:	f86080e7          	jalr	-122(ra) # 80000968 <freewalk>
}
    800009ea:	60e2                	ld	ra,24(sp)
    800009ec:	6442                	ld	s0,16(sp)
    800009ee:	64a2                	ld	s1,8(sp)
    800009f0:	6105                	addi	sp,sp,32
    800009f2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f4:	6605                	lui	a2,0x1
    800009f6:	167d                	addi	a2,a2,-1
    800009f8:	962e                	add	a2,a2,a1
    800009fa:	4685                	li	a3,1
    800009fc:	8231                	srli	a2,a2,0xc
    800009fe:	4581                	li	a1,0
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	d0a080e7          	jalr	-758(ra) # 8000070a <uvmunmap>
    80000a08:	bfe1                	j	800009e0 <uvmfree+0xe>

0000000080000a0a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0a:	c679                	beqz	a2,80000ad8 <uvmcopy+0xce>
{
    80000a0c:	715d                	addi	sp,sp,-80
    80000a0e:	e486                	sd	ra,72(sp)
    80000a10:	e0a2                	sd	s0,64(sp)
    80000a12:	fc26                	sd	s1,56(sp)
    80000a14:	f84a                	sd	s2,48(sp)
    80000a16:	f44e                	sd	s3,40(sp)
    80000a18:	f052                	sd	s4,32(sp)
    80000a1a:	ec56                	sd	s5,24(sp)
    80000a1c:	e85a                	sd	s6,16(sp)
    80000a1e:	e45e                	sd	s7,8(sp)
    80000a20:	0880                	addi	s0,sp,80
    80000a22:	8b2a                	mv	s6,a0
    80000a24:	8aae                	mv	s5,a1
    80000a26:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a28:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2a:	4601                	li	a2,0
    80000a2c:	85ce                	mv	a1,s3
    80000a2e:	855a                	mv	a0,s6
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	a2c080e7          	jalr	-1492(ra) # 8000045c <walk>
    80000a38:	c531                	beqz	a0,80000a84 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3a:	6118                	ld	a4,0(a0)
    80000a3c:	00177793          	andi	a5,a4,1
    80000a40:	cbb1                	beqz	a5,80000a94 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a42:	00a75593          	srli	a1,a4,0xa
    80000a46:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4e:	fffff097          	auipc	ra,0xfffff
    80000a52:	6ca080e7          	jalr	1738(ra) # 80000118 <kalloc>
    80000a56:	892a                	mv	s2,a0
    80000a58:	c939                	beqz	a0,80000aae <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	85de                	mv	a1,s7
    80000a5e:	fffff097          	auipc	ra,0xfffff
    80000a62:	776080e7          	jalr	1910(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a66:	8726                	mv	a4,s1
    80000a68:	86ca                	mv	a3,s2
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	85ce                	mv	a1,s3
    80000a6e:	8556                	mv	a0,s5
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	ad4080e7          	jalr	-1324(ra) # 80000544 <mappages>
    80000a78:	e515                	bnez	a0,80000aa4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7a:	6785                	lui	a5,0x1
    80000a7c:	99be                	add	s3,s3,a5
    80000a7e:	fb49e6e3          	bltu	s3,s4,80000a2a <uvmcopy+0x20>
    80000a82:	a081                	j	80000ac2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a84:	00007517          	auipc	a0,0x7
    80000a88:	68450513          	addi	a0,a0,1668 # 80008108 <etext+0x108>
    80000a8c:	00005097          	auipc	ra,0x5
    80000a90:	1d4080e7          	jalr	468(ra) # 80005c60 <panic>
      panic("uvmcopy: page not present");
    80000a94:	00007517          	auipc	a0,0x7
    80000a98:	69450513          	addi	a0,a0,1684 # 80008128 <etext+0x128>
    80000a9c:	00005097          	auipc	ra,0x5
    80000aa0:	1c4080e7          	jalr	452(ra) # 80005c60 <panic>
      kfree(mem);
    80000aa4:	854a                	mv	a0,s2
    80000aa6:	fffff097          	auipc	ra,0xfffff
    80000aaa:	576080e7          	jalr	1398(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aae:	4685                	li	a3,1
    80000ab0:	00c9d613          	srli	a2,s3,0xc
    80000ab4:	4581                	li	a1,0
    80000ab6:	8556                	mv	a0,s5
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	c52080e7          	jalr	-942(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac0:	557d                	li	a0,-1
}
    80000ac2:	60a6                	ld	ra,72(sp)
    80000ac4:	6406                	ld	s0,64(sp)
    80000ac6:	74e2                	ld	s1,56(sp)
    80000ac8:	7942                	ld	s2,48(sp)
    80000aca:	79a2                	ld	s3,40(sp)
    80000acc:	7a02                	ld	s4,32(sp)
    80000ace:	6ae2                	ld	s5,24(sp)
    80000ad0:	6b42                	ld	s6,16(sp)
    80000ad2:	6ba2                	ld	s7,8(sp)
    80000ad4:	6161                	addi	sp,sp,80
    80000ad6:	8082                	ret
  return 0;
    80000ad8:	4501                	li	a0,0
}
    80000ada:	8082                	ret

0000000080000adc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000adc:	1141                	addi	sp,sp,-16
    80000ade:	e406                	sd	ra,8(sp)
    80000ae0:	e022                	sd	s0,0(sp)
    80000ae2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae4:	4601                	li	a2,0
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	976080e7          	jalr	-1674(ra) # 8000045c <walk>
  if(pte == 0)
    80000aee:	c901                	beqz	a0,80000afe <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af0:	611c                	ld	a5,0(a0)
    80000af2:	9bbd                	andi	a5,a5,-17
    80000af4:	e11c                	sd	a5,0(a0)
}
    80000af6:	60a2                	ld	ra,8(sp)
    80000af8:	6402                	ld	s0,0(sp)
    80000afa:	0141                	addi	sp,sp,16
    80000afc:	8082                	ret
    panic("uvmclear");
    80000afe:	00007517          	auipc	a0,0x7
    80000b02:	64a50513          	addi	a0,a0,1610 # 80008148 <etext+0x148>
    80000b06:	00005097          	auipc	ra,0x5
    80000b0a:	15a080e7          	jalr	346(ra) # 80005c60 <panic>

0000000080000b0e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0e:	c6bd                	beqz	a3,80000b7c <copyout+0x6e>
{
    80000b10:	715d                	addi	sp,sp,-80
    80000b12:	e486                	sd	ra,72(sp)
    80000b14:	e0a2                	sd	s0,64(sp)
    80000b16:	fc26                	sd	s1,56(sp)
    80000b18:	f84a                	sd	s2,48(sp)
    80000b1a:	f44e                	sd	s3,40(sp)
    80000b1c:	f052                	sd	s4,32(sp)
    80000b1e:	ec56                	sd	s5,24(sp)
    80000b20:	e85a                	sd	s6,16(sp)
    80000b22:	e45e                	sd	s7,8(sp)
    80000b24:	e062                	sd	s8,0(sp)
    80000b26:	0880                	addi	s0,sp,80
    80000b28:	8b2a                	mv	s6,a0
    80000b2a:	8c2e                	mv	s8,a1
    80000b2c:	8a32                	mv	s4,a2
    80000b2e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b30:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b32:	6a85                	lui	s5,0x1
    80000b34:	a015                	j	80000b58 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b36:	9562                	add	a0,a0,s8
    80000b38:	0004861b          	sext.w	a2,s1
    80000b3c:	85d2                	mv	a1,s4
    80000b3e:	41250533          	sub	a0,a0,s2
    80000b42:	fffff097          	auipc	ra,0xfffff
    80000b46:	692080e7          	jalr	1682(ra) # 800001d4 <memmove>

    len -= n;
    80000b4a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b50:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b54:	02098263          	beqz	s3,80000b78 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b58:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b5c:	85ca                	mv	a1,s2
    80000b5e:	855a                	mv	a0,s6
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	9a2080e7          	jalr	-1630(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b68:	cd01                	beqz	a0,80000b80 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6a:	418904b3          	sub	s1,s2,s8
    80000b6e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b70:	fc99f3e3          	bgeu	s3,s1,80000b36 <copyout+0x28>
    80000b74:	84ce                	mv	s1,s3
    80000b76:	b7c1                	j	80000b36 <copyout+0x28>
  }
  return 0;
    80000b78:	4501                	li	a0,0
    80000b7a:	a021                	j	80000b82 <copyout+0x74>
    80000b7c:	4501                	li	a0,0
}
    80000b7e:	8082                	ret
      return -1;
    80000b80:	557d                	li	a0,-1
}
    80000b82:	60a6                	ld	ra,72(sp)
    80000b84:	6406                	ld	s0,64(sp)
    80000b86:	74e2                	ld	s1,56(sp)
    80000b88:	7942                	ld	s2,48(sp)
    80000b8a:	79a2                	ld	s3,40(sp)
    80000b8c:	7a02                	ld	s4,32(sp)
    80000b8e:	6ae2                	ld	s5,24(sp)
    80000b90:	6b42                	ld	s6,16(sp)
    80000b92:	6ba2                	ld	s7,8(sp)
    80000b94:	6c02                	ld	s8,0(sp)
    80000b96:	6161                	addi	sp,sp,80
    80000b98:	8082                	ret

0000000080000b9a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9a:	caa5                	beqz	a3,80000c0a <copyin+0x70>
{
    80000b9c:	715d                	addi	sp,sp,-80
    80000b9e:	e486                	sd	ra,72(sp)
    80000ba0:	e0a2                	sd	s0,64(sp)
    80000ba2:	fc26                	sd	s1,56(sp)
    80000ba4:	f84a                	sd	s2,48(sp)
    80000ba6:	f44e                	sd	s3,40(sp)
    80000ba8:	f052                	sd	s4,32(sp)
    80000baa:	ec56                	sd	s5,24(sp)
    80000bac:	e85a                	sd	s6,16(sp)
    80000bae:	e45e                	sd	s7,8(sp)
    80000bb0:	e062                	sd	s8,0(sp)
    80000bb2:	0880                	addi	s0,sp,80
    80000bb4:	8b2a                	mv	s6,a0
    80000bb6:	8a2e                	mv	s4,a1
    80000bb8:	8c32                	mv	s8,a2
    80000bba:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bbc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bbe:	6a85                	lui	s5,0x1
    80000bc0:	a01d                	j	80000be6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc2:	018505b3          	add	a1,a0,s8
    80000bc6:	0004861b          	sext.w	a2,s1
    80000bca:	412585b3          	sub	a1,a1,s2
    80000bce:	8552                	mv	a0,s4
    80000bd0:	fffff097          	auipc	ra,0xfffff
    80000bd4:	604080e7          	jalr	1540(ra) # 800001d4 <memmove>

    len -= n;
    80000bd8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bdc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bde:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be2:	02098263          	beqz	s3,80000c06 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bea:	85ca                	mv	a1,s2
    80000bec:	855a                	mv	a0,s6
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	914080e7          	jalr	-1772(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bf6:	cd01                	beqz	a0,80000c0e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf8:	418904b3          	sub	s1,s2,s8
    80000bfc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bfe:	fc99f2e3          	bgeu	s3,s1,80000bc2 <copyin+0x28>
    80000c02:	84ce                	mv	s1,s3
    80000c04:	bf7d                	j	80000bc2 <copyin+0x28>
  }
  return 0;
    80000c06:	4501                	li	a0,0
    80000c08:	a021                	j	80000c10 <copyin+0x76>
    80000c0a:	4501                	li	a0,0
}
    80000c0c:	8082                	ret
      return -1;
    80000c0e:	557d                	li	a0,-1
}
    80000c10:	60a6                	ld	ra,72(sp)
    80000c12:	6406                	ld	s0,64(sp)
    80000c14:	74e2                	ld	s1,56(sp)
    80000c16:	7942                	ld	s2,48(sp)
    80000c18:	79a2                	ld	s3,40(sp)
    80000c1a:	7a02                	ld	s4,32(sp)
    80000c1c:	6ae2                	ld	s5,24(sp)
    80000c1e:	6b42                	ld	s6,16(sp)
    80000c20:	6ba2                	ld	s7,8(sp)
    80000c22:	6c02                	ld	s8,0(sp)
    80000c24:	6161                	addi	sp,sp,80
    80000c26:	8082                	ret

0000000080000c28 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c28:	c6c5                	beqz	a3,80000cd0 <copyinstr+0xa8>
{
    80000c2a:	715d                	addi	sp,sp,-80
    80000c2c:	e486                	sd	ra,72(sp)
    80000c2e:	e0a2                	sd	s0,64(sp)
    80000c30:	fc26                	sd	s1,56(sp)
    80000c32:	f84a                	sd	s2,48(sp)
    80000c34:	f44e                	sd	s3,40(sp)
    80000c36:	f052                	sd	s4,32(sp)
    80000c38:	ec56                	sd	s5,24(sp)
    80000c3a:	e85a                	sd	s6,16(sp)
    80000c3c:	e45e                	sd	s7,8(sp)
    80000c3e:	0880                	addi	s0,sp,80
    80000c40:	8a2a                	mv	s4,a0
    80000c42:	8b2e                	mv	s6,a1
    80000c44:	8bb2                	mv	s7,a2
    80000c46:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c48:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4a:	6985                	lui	s3,0x1
    80000c4c:	a035                	j	80000c78 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c4e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c52:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c54:	0017b793          	seqz	a5,a5
    80000c58:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5c:	60a6                	ld	ra,72(sp)
    80000c5e:	6406                	ld	s0,64(sp)
    80000c60:	74e2                	ld	s1,56(sp)
    80000c62:	7942                	ld	s2,48(sp)
    80000c64:	79a2                	ld	s3,40(sp)
    80000c66:	7a02                	ld	s4,32(sp)
    80000c68:	6ae2                	ld	s5,24(sp)
    80000c6a:	6b42                	ld	s6,16(sp)
    80000c6c:	6ba2                	ld	s7,8(sp)
    80000c6e:	6161                	addi	sp,sp,80
    80000c70:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c72:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c76:	c8a9                	beqz	s1,80000cc8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c78:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7c:	85ca                	mv	a1,s2
    80000c7e:	8552                	mv	a0,s4
    80000c80:	00000097          	auipc	ra,0x0
    80000c84:	882080e7          	jalr	-1918(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c88:	c131                	beqz	a0,80000ccc <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c8a:	41790833          	sub	a6,s2,s7
    80000c8e:	984e                	add	a6,a6,s3
    if(n > max)
    80000c90:	0104f363          	bgeu	s1,a6,80000c96 <copyinstr+0x6e>
    80000c94:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c96:	955e                	add	a0,a0,s7
    80000c98:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9c:	fc080be3          	beqz	a6,80000c72 <copyinstr+0x4a>
    80000ca0:	985a                	add	a6,a6,s6
    80000ca2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	14fd                	addi	s1,s1,-1
    80000caa:	9b26                	add	s6,s6,s1
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4)
    80000cb4:	df49                	beqz	a4,80000c4e <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      --max;
    80000cba:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cbe:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc0:	ff0796e3          	bne	a5,a6,80000cac <copyinstr+0x84>
      dst++;
    80000cc4:	8b42                	mv	s6,a6
    80000cc6:	b775                	j	80000c72 <copyinstr+0x4a>
    80000cc8:	4781                	li	a5,0
    80000cca:	b769                	j	80000c54 <copyinstr+0x2c>
      return -1;
    80000ccc:	557d                	li	a0,-1
    80000cce:	b779                	j	80000c5c <copyinstr+0x34>
  int got_null = 0;
    80000cd0:	4781                	li	a5,0
  if(got_null){
    80000cd2:	0017b793          	seqz	a5,a5
    80000cd6:	40f00533          	neg	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	08e48493          	addi	s1,s1,142 # 80008d80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	addi	s5,s5,772 # 80008000 <etext>
    80000d04:	01000937          	lui	s2,0x1000
    80000d08:	197d                	addi	s2,s2,-1
    80000d0a:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	0000ea17          	auipc	s4,0xe
    80000d10:	c74a0a13          	addi	s4,s4,-908 # 8000e980 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	404080e7          	jalr	1028(ra) # 80000118 <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c129                	beqz	a0,80000d60 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	8591                	srai	a1,a1,0x4
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d32:	4719                	li	a4,6
    80000d34:	6685                	lui	a3,0x1
    80000d36:	40b905b3          	sub	a1,s2,a1
    80000d3a:	854e                	mv	a0,s3
    80000d3c:	00000097          	auipc	ra,0x0
    80000d40:	8a8080e7          	jalr	-1880(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d44:	17048493          	addi	s1,s1,368
    80000d48:	fd4496e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4c:	70e2                	ld	ra,56(sp)
    80000d4e:	7442                	ld	s0,48(sp)
    80000d50:	74a2                	ld	s1,40(sp)
    80000d52:	7902                	ld	s2,32(sp)
    80000d54:	69e2                	ld	s3,24(sp)
    80000d56:	6a42                	ld	s4,16(sp)
    80000d58:	6aa2                	ld	s5,8(sp)
    80000d5a:	6b02                	ld	s6,0(sp)
    80000d5c:	6121                	addi	sp,sp,64
    80000d5e:	8082                	ret
      panic("kalloc");
    80000d60:	00007517          	auipc	a0,0x7
    80000d64:	3f850513          	addi	a0,a0,1016 # 80008158 <etext+0x158>
    80000d68:	00005097          	auipc	ra,0x5
    80000d6c:	ef8080e7          	jalr	-264(ra) # 80005c60 <panic>

0000000080000d70 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d70:	7139                	addi	sp,sp,-64
    80000d72:	fc06                	sd	ra,56(sp)
    80000d74:	f822                	sd	s0,48(sp)
    80000d76:	f426                	sd	s1,40(sp)
    80000d78:	f04a                	sd	s2,32(sp)
    80000d7a:	ec4e                	sd	s3,24(sp)
    80000d7c:	e852                	sd	s4,16(sp)
    80000d7e:	e456                	sd	s5,8(sp)
    80000d80:	e05a                	sd	s6,0(sp)
    80000d82:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d84:	00007597          	auipc	a1,0x7
    80000d88:	3dc58593          	addi	a1,a1,988 # 80008160 <etext+0x160>
    80000d8c:	00008517          	auipc	a0,0x8
    80000d90:	bc450513          	addi	a0,a0,-1084 # 80008950 <pid_lock>
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	378080e7          	jalr	888(ra) # 8000610c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9c:	00007597          	auipc	a1,0x7
    80000da0:	3cc58593          	addi	a1,a1,972 # 80008168 <etext+0x168>
    80000da4:	00008517          	auipc	a0,0x8
    80000da8:	bc450513          	addi	a0,a0,-1084 # 80008968 <wait_lock>
    80000dac:	00005097          	auipc	ra,0x5
    80000db0:	360080e7          	jalr	864(ra) # 8000610c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db4:	00008497          	auipc	s1,0x8
    80000db8:	fcc48493          	addi	s1,s1,-52 # 80008d80 <proc>
      initlock(&p->lock, "proc");
    80000dbc:	00007b17          	auipc	s6,0x7
    80000dc0:	3bcb0b13          	addi	s6,s6,956 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc4:	8aa6                	mv	s5,s1
    80000dc6:	00007a17          	auipc	s4,0x7
    80000dca:	23aa0a13          	addi	s4,s4,570 # 80008000 <etext>
    80000dce:	01000937          	lui	s2,0x1000
    80000dd2:	197d                	addi	s2,s2,-1
    80000dd4:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	0000e997          	auipc	s3,0xe
    80000dda:	baa98993          	addi	s3,s3,-1110 # 8000e980 <tickslock>
      initlock(&p->lock, "proc");
    80000dde:	85da                	mv	a1,s6
    80000de0:	8526                	mv	a0,s1
    80000de2:	00005097          	auipc	ra,0x5
    80000de6:	32a080e7          	jalr	810(ra) # 8000610c <initlock>
      p->state = UNUSED;
    80000dea:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000dee:	415487b3          	sub	a5,s1,s5
    80000df2:	8791                	srai	a5,a5,0x4
    80000df4:	000a3703          	ld	a4,0(s4)
    80000df8:	02e787b3          	mul	a5,a5,a4
    80000dfc:	00d7979b          	slliw	a5,a5,0xd
    80000e00:	40f907b3          	sub	a5,s2,a5
    80000e04:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e06:	17048493          	addi	s1,s1,368
    80000e0a:	fd349ae3          	bne	s1,s3,80000dde <procinit+0x6e>
  }
}
    80000e0e:	70e2                	ld	ra,56(sp)
    80000e10:	7442                	ld	s0,48(sp)
    80000e12:	74a2                	ld	s1,40(sp)
    80000e14:	7902                	ld	s2,32(sp)
    80000e16:	69e2                	ld	s3,24(sp)
    80000e18:	6a42                	ld	s4,16(sp)
    80000e1a:	6aa2                	ld	s5,8(sp)
    80000e1c:	6b02                	ld	s6,0(sp)
    80000e1e:	6121                	addi	sp,sp,64
    80000e20:	8082                	ret

0000000080000e22 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e22:	1141                	addi	sp,sp,-16
    80000e24:	e422                	sd	s0,8(sp)
    80000e26:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e28:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2a:	2501                	sext.w	a0,a0
    80000e2c:	6422                	ld	s0,8(sp)
    80000e2e:	0141                	addi	sp,sp,16
    80000e30:	8082                	ret

0000000080000e32 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e32:	1141                	addi	sp,sp,-16
    80000e34:	e422                	sd	s0,8(sp)
    80000e36:	0800                	addi	s0,sp,16
    80000e38:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3a:	2781                	sext.w	a5,a5
    80000e3c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e3e:	00008517          	auipc	a0,0x8
    80000e42:	b4250513          	addi	a0,a0,-1214 # 80008980 <cpus>
    80000e46:	953e                	add	a0,a0,a5
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e4e:	1101                	addi	sp,sp,-32
    80000e50:	ec06                	sd	ra,24(sp)
    80000e52:	e822                	sd	s0,16(sp)
    80000e54:	e426                	sd	s1,8(sp)
    80000e56:	1000                	addi	s0,sp,32
  push_off();
    80000e58:	00005097          	auipc	ra,0x5
    80000e5c:	2f8080e7          	jalr	760(ra) # 80006150 <push_off>
    80000e60:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e62:	2781                	sext.w	a5,a5
    80000e64:	079e                	slli	a5,a5,0x7
    80000e66:	00008717          	auipc	a4,0x8
    80000e6a:	aea70713          	addi	a4,a4,-1302 # 80008950 <pid_lock>
    80000e6e:	97ba                	add	a5,a5,a4
    80000e70:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	37e080e7          	jalr	894(ra) # 800061f0 <pop_off>
  return p;
}
    80000e7a:	8526                	mv	a0,s1
    80000e7c:	60e2                	ld	ra,24(sp)
    80000e7e:	6442                	ld	s0,16(sp)
    80000e80:	64a2                	ld	s1,8(sp)
    80000e82:	6105                	addi	sp,sp,32
    80000e84:	8082                	ret

0000000080000e86 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e86:	1141                	addi	sp,sp,-16
    80000e88:	e406                	sd	ra,8(sp)
    80000e8a:	e022                	sd	s0,0(sp)
    80000e8c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e8e:	00000097          	auipc	ra,0x0
    80000e92:	fc0080e7          	jalr	-64(ra) # 80000e4e <myproc>
    80000e96:	00005097          	auipc	ra,0x5
    80000e9a:	3ba080e7          	jalr	954(ra) # 80006250 <release>

  if (first) {
    80000e9e:	00008797          	auipc	a5,0x8
    80000ea2:	9f27a783          	lw	a5,-1550(a5) # 80008890 <first.1>
    80000ea6:	eb89                	bnez	a5,80000eb8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea8:	00001097          	auipc	ra,0x1
    80000eac:	d36080e7          	jalr	-714(ra) # 80001bde <usertrapret>
}
    80000eb0:	60a2                	ld	ra,8(sp)
    80000eb2:	6402                	ld	s0,0(sp)
    80000eb4:	0141                	addi	sp,sp,16
    80000eb6:	8082                	ret
    first = 0;
    80000eb8:	00008797          	auipc	a5,0x8
    80000ebc:	9c07ac23          	sw	zero,-1576(a5) # 80008890 <first.1>
    fsinit(ROOTDEV);
    80000ec0:	4505                	li	a0,1
    80000ec2:	00002097          	auipc	ra,0x2
    80000ec6:	a7a080e7          	jalr	-1414(ra) # 8000293c <fsinit>
    80000eca:	bff9                	j	80000ea8 <forkret+0x22>

0000000080000ecc <allocpid>:
{
    80000ecc:	1101                	addi	sp,sp,-32
    80000ece:	ec06                	sd	ra,24(sp)
    80000ed0:	e822                	sd	s0,16(sp)
    80000ed2:	e426                	sd	s1,8(sp)
    80000ed4:	e04a                	sd	s2,0(sp)
    80000ed6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed8:	00008917          	auipc	s2,0x8
    80000edc:	a7890913          	addi	s2,s2,-1416 # 80008950 <pid_lock>
    80000ee0:	854a                	mv	a0,s2
    80000ee2:	00005097          	auipc	ra,0x5
    80000ee6:	2ba080e7          	jalr	698(ra) # 8000619c <acquire>
  pid = nextpid;
    80000eea:	00008797          	auipc	a5,0x8
    80000eee:	9aa78793          	addi	a5,a5,-1622 # 80008894 <nextpid>
    80000ef2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef4:	0014871b          	addiw	a4,s1,1
    80000ef8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efa:	854a                	mv	a0,s2
    80000efc:	00005097          	auipc	ra,0x5
    80000f00:	354080e7          	jalr	852(ra) # 80006250 <release>
}
    80000f04:	8526                	mv	a0,s1
    80000f06:	60e2                	ld	ra,24(sp)
    80000f08:	6442                	ld	s0,16(sp)
    80000f0a:	64a2                	ld	s1,8(sp)
    80000f0c:	6902                	ld	s2,0(sp)
    80000f0e:	6105                	addi	sp,sp,32
    80000f10:	8082                	ret

0000000080000f12 <proc_pagetable>:
{
    80000f12:	1101                	addi	sp,sp,-32
    80000f14:	ec06                	sd	ra,24(sp)
    80000f16:	e822                	sd	s0,16(sp)
    80000f18:	e426                	sd	s1,8(sp)
    80000f1a:	e04a                	sd	s2,0(sp)
    80000f1c:	1000                	addi	s0,sp,32
    80000f1e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	8ae080e7          	jalr	-1874(ra) # 800007ce <uvmcreate>
    80000f28:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2a:	cd39                	beqz	a0,80000f88 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f2c:	4729                	li	a4,10
    80000f2e:	00006697          	auipc	a3,0x6
    80000f32:	0d268693          	addi	a3,a3,210 # 80007000 <_trampoline>
    80000f36:	6605                	lui	a2,0x1
    80000f38:	040005b7          	lui	a1,0x4000
    80000f3c:	15fd                	addi	a1,a1,-1
    80000f3e:	05b2                	slli	a1,a1,0xc
    80000f40:	fffff097          	auipc	ra,0xfffff
    80000f44:	604080e7          	jalr	1540(ra) # 80000544 <mappages>
    80000f48:	04054763          	bltz	a0,80000f96 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f4c:	4719                	li	a4,6
    80000f4e:	05893683          	ld	a3,88(s2)
    80000f52:	6605                	lui	a2,0x1
    80000f54:	020005b7          	lui	a1,0x2000
    80000f58:	15fd                	addi	a1,a1,-1
    80000f5a:	05b6                	slli	a1,a1,0xd
    80000f5c:	8526                	mv	a0,s1
    80000f5e:	fffff097          	auipc	ra,0xfffff
    80000f62:	5e6080e7          	jalr	1510(ra) # 80000544 <mappages>
    80000f66:	04054063          	bltz	a0,80000fa6 <proc_pagetable+0x94>
  if (mappages(pagetable, USYSCALL, PGSIZE,
    80000f6a:	4749                	li	a4,18
    80000f6c:	16893683          	ld	a3,360(s2)
    80000f70:	6605                	lui	a2,0x1
    80000f72:	040005b7          	lui	a1,0x4000
    80000f76:	15f5                	addi	a1,a1,-3
    80000f78:	05b2                	slli	a1,a1,0xc
    80000f7a:	8526                	mv	a0,s1
    80000f7c:	fffff097          	auipc	ra,0xfffff
    80000f80:	5c8080e7          	jalr	1480(ra) # 80000544 <mappages>
    80000f84:	04054463          	bltz	a0,80000fcc <proc_pagetable+0xba>
}
    80000f88:	8526                	mv	a0,s1
    80000f8a:	60e2                	ld	ra,24(sp)
    80000f8c:	6442                	ld	s0,16(sp)
    80000f8e:	64a2                	ld	s1,8(sp)
    80000f90:	6902                	ld	s2,0(sp)
    80000f92:	6105                	addi	sp,sp,32
    80000f94:	8082                	ret
    uvmfree(pagetable, 0);
    80000f96:	4581                	li	a1,0
    80000f98:	8526                	mv	a0,s1
    80000f9a:	00000097          	auipc	ra,0x0
    80000f9e:	a38080e7          	jalr	-1480(ra) # 800009d2 <uvmfree>
    return 0;
    80000fa2:	4481                	li	s1,0
    80000fa4:	b7d5                	j	80000f88 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa6:	4681                	li	a3,0
    80000fa8:	4605                	li	a2,1
    80000faa:	040005b7          	lui	a1,0x4000
    80000fae:	15fd                	addi	a1,a1,-1
    80000fb0:	05b2                	slli	a1,a1,0xc
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	756080e7          	jalr	1878(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a12080e7          	jalr	-1518(ra) # 800009d2 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	bf7d                	j	80000f88 <proc_pagetable+0x76>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	04000937          	lui	s2,0x4000
    80000fd4:	ffd90593          	addi	a1,s2,-3 # 3fffffd <_entry-0x7c000003>
    80000fd8:	05b2                	slli	a1,a1,0xc
    80000fda:	8526                	mv	a0,s1
    80000fdc:	fffff097          	auipc	ra,0xfffff
    80000fe0:	72e080e7          	jalr	1838(ra) # 8000070a <uvmunmap>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fe4:	4681                	li	a3,0
    80000fe6:	4605                	li	a2,1
    80000fe8:	fff90593          	addi	a1,s2,-1
    80000fec:	05b2                	slli	a1,a1,0xc
    80000fee:	8526                	mv	a0,s1
    80000ff0:	fffff097          	auipc	ra,0xfffff
    80000ff4:	71a080e7          	jalr	1818(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000ff8:	4581                	li	a1,0
    80000ffa:	8526                	mv	a0,s1
    80000ffc:	00000097          	auipc	ra,0x0
    80001000:	9d6080e7          	jalr	-1578(ra) # 800009d2 <uvmfree>
    return 0;
    80001004:	4481                	li	s1,0
    80001006:	b749                	j	80000f88 <proc_pagetable+0x76>

0000000080001008 <proc_freepagetable>:
{
    80001008:	7179                	addi	sp,sp,-48
    8000100a:	f406                	sd	ra,40(sp)
    8000100c:	f022                	sd	s0,32(sp)
    8000100e:	ec26                	sd	s1,24(sp)
    80001010:	e84a                	sd	s2,16(sp)
    80001012:	e44e                	sd	s3,8(sp)
    80001014:	1800                	addi	s0,sp,48
    80001016:	84aa                	mv	s1,a0
    80001018:	89ae                	mv	s3,a1
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000101a:	4681                	li	a3,0
    8000101c:	4605                	li	a2,1
    8000101e:	04000937          	lui	s2,0x4000
    80001022:	ffd90593          	addi	a1,s2,-3 # 3fffffd <_entry-0x7c000003>
    80001026:	05b2                	slli	a1,a1,0xc
    80001028:	fffff097          	auipc	ra,0xfffff
    8000102c:	6e2080e7          	jalr	1762(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001030:	4681                	li	a3,0
    80001032:	4605                	li	a2,1
    80001034:	197d                	addi	s2,s2,-1
    80001036:	00c91593          	slli	a1,s2,0xc
    8000103a:	8526                	mv	a0,s1
    8000103c:	fffff097          	auipc	ra,0xfffff
    80001040:	6ce080e7          	jalr	1742(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001044:	4681                	li	a3,0
    80001046:	4605                	li	a2,1
    80001048:	020005b7          	lui	a1,0x2000
    8000104c:	15fd                	addi	a1,a1,-1
    8000104e:	05b6                	slli	a1,a1,0xd
    80001050:	8526                	mv	a0,s1
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	6b8080e7          	jalr	1720(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    8000105a:	85ce                	mv	a1,s3
    8000105c:	8526                	mv	a0,s1
    8000105e:	00000097          	auipc	ra,0x0
    80001062:	974080e7          	jalr	-1676(ra) # 800009d2 <uvmfree>
}
    80001066:	70a2                	ld	ra,40(sp)
    80001068:	7402                	ld	s0,32(sp)
    8000106a:	64e2                	ld	s1,24(sp)
    8000106c:	6942                	ld	s2,16(sp)
    8000106e:	69a2                	ld	s3,8(sp)
    80001070:	6145                	addi	sp,sp,48
    80001072:	8082                	ret

0000000080001074 <freeproc>:
{
    80001074:	1101                	addi	sp,sp,-32
    80001076:	ec06                	sd	ra,24(sp)
    80001078:	e822                	sd	s0,16(sp)
    8000107a:	e426                	sd	s1,8(sp)
    8000107c:	1000                	addi	s0,sp,32
    8000107e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001080:	6d28                	ld	a0,88(a0)
    80001082:	c509                	beqz	a0,8000108c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001084:	fffff097          	auipc	ra,0xfffff
    80001088:	f98080e7          	jalr	-104(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000108c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001090:	68a8                	ld	a0,80(s1)
    80001092:	cd11                	beqz	a0,800010ae <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    80001094:	64ac                	ld	a1,72(s1)
    80001096:	00000097          	auipc	ra,0x0
    8000109a:	f72080e7          	jalr	-142(ra) # 80001008 <proc_freepagetable>
  if (p->trapframe)
    8000109e:	6cbc                	ld	a5,88(s1)
    800010a0:	c799                	beqz	a5,800010ae <freeproc+0x3a>
    kfree((void *)p->usyscall);
    800010a2:	1684b503          	ld	a0,360(s1)
    800010a6:	fffff097          	auipc	ra,0xfffff
    800010aa:	f76080e7          	jalr	-138(ra) # 8000001c <kfree>
  p->usyscall=0;
    800010ae:	1604b423          	sd	zero,360(s1)
  p->pagetable = 0;
    800010b2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010b6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010ba:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010be:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010c2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010c6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010ca:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010ce:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010d2:	0004ac23          	sw	zero,24(s1)
}
    800010d6:	60e2                	ld	ra,24(sp)
    800010d8:	6442                	ld	s0,16(sp)
    800010da:	64a2                	ld	s1,8(sp)
    800010dc:	6105                	addi	sp,sp,32
    800010de:	8082                	ret

00000000800010e0 <allocproc>:
{
    800010e0:	1101                	addi	sp,sp,-32
    800010e2:	ec06                	sd	ra,24(sp)
    800010e4:	e822                	sd	s0,16(sp)
    800010e6:	e426                	sd	s1,8(sp)
    800010e8:	e04a                	sd	s2,0(sp)
    800010ea:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ec:	00008497          	auipc	s1,0x8
    800010f0:	c9448493          	addi	s1,s1,-876 # 80008d80 <proc>
    800010f4:	0000e917          	auipc	s2,0xe
    800010f8:	88c90913          	addi	s2,s2,-1908 # 8000e980 <tickslock>
    acquire(&p->lock);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00005097          	auipc	ra,0x5
    80001102:	09e080e7          	jalr	158(ra) # 8000619c <acquire>
    if(p->state == UNUSED) {
    80001106:	4c9c                	lw	a5,24(s1)
    80001108:	cf81                	beqz	a5,80001120 <allocproc+0x40>
      release(&p->lock);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00005097          	auipc	ra,0x5
    80001110:	144080e7          	jalr	324(ra) # 80006250 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001114:	17048493          	addi	s1,s1,368
    80001118:	ff2492e3          	bne	s1,s2,800010fc <allocproc+0x1c>
  return 0;
    8000111c:	4481                	li	s1,0
    8000111e:	a89d                	j	80001194 <allocproc+0xb4>
  p->pid = allocpid();
    80001120:	00000097          	auipc	ra,0x0
    80001124:	dac080e7          	jalr	-596(ra) # 80000ecc <allocpid>
    80001128:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000112a:	4785                	li	a5,1
    8000112c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000112e:	fffff097          	auipc	ra,0xfffff
    80001132:	fea080e7          	jalr	-22(ra) # 80000118 <kalloc>
    80001136:	892a                	mv	s2,a0
    80001138:	eca8                	sd	a0,88(s1)
    8000113a:	c525                	beqz	a0,800011a2 <allocproc+0xc2>
  p->pagetable = proc_pagetable(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	dd4080e7          	jalr	-556(ra) # 80000f12 <proc_pagetable>
    80001146:	892a                	mv	s2,a0
    80001148:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000114a:	c925                	beqz	a0,800011ba <allocproc+0xda>
  memset(&p->context, 0, sizeof(p->context));
    8000114c:	07000613          	li	a2,112
    80001150:	4581                	li	a1,0
    80001152:	06048513          	addi	a0,s1,96
    80001156:	fffff097          	auipc	ra,0xfffff
    8000115a:	022080e7          	jalr	34(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000115e:	00000797          	auipc	a5,0x0
    80001162:	d2878793          	addi	a5,a5,-728 # 80000e86 <forkret>
    80001166:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001168:	60bc                	ld	a5,64(s1)
    8000116a:	6705                	lui	a4,0x1
    8000116c:	97ba                	add	a5,a5,a4
    8000116e:	f4bc                	sd	a5,104(s1)
  if ((p->usyscall = (struct usyscall *)kalloc()) == 0)
    80001170:	fffff097          	auipc	ra,0xfffff
    80001174:	fa8080e7          	jalr	-88(ra) # 80000118 <kalloc>
    80001178:	892a                	mv	s2,a0
    8000117a:	16a4b423          	sd	a0,360(s1)
    8000117e:	c931                	beqz	a0,800011d2 <allocproc+0xf2>
  p->usyscall->pid=p->pid;
    80001180:	589c                	lw	a5,48(s1)
    80001182:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p); 
    80001184:	8526                	mv	a0,s1
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	d8c080e7          	jalr	-628(ra) # 80000f12 <proc_pagetable>
    8000118e:	892a                	mv	s2,a0
    80001190:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001192:	cd21                	beqz	a0,800011ea <allocproc+0x10a>
}
    80001194:	8526                	mv	a0,s1
    80001196:	60e2                	ld	ra,24(sp)
    80001198:	6442                	ld	s0,16(sp)
    8000119a:	64a2                	ld	s1,8(sp)
    8000119c:	6902                	ld	s2,0(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret
    freeproc(p);
    800011a2:	8526                	mv	a0,s1
    800011a4:	00000097          	auipc	ra,0x0
    800011a8:	ed0080e7          	jalr	-304(ra) # 80001074 <freeproc>
    release(&p->lock);
    800011ac:	8526                	mv	a0,s1
    800011ae:	00005097          	auipc	ra,0x5
    800011b2:	0a2080e7          	jalr	162(ra) # 80006250 <release>
    return 0;
    800011b6:	84ca                	mv	s1,s2
    800011b8:	bff1                	j	80001194 <allocproc+0xb4>
    freeproc(p);
    800011ba:	8526                	mv	a0,s1
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	eb8080e7          	jalr	-328(ra) # 80001074 <freeproc>
    release(&p->lock);
    800011c4:	8526                	mv	a0,s1
    800011c6:	00005097          	auipc	ra,0x5
    800011ca:	08a080e7          	jalr	138(ra) # 80006250 <release>
    return 0;
    800011ce:	84ca                	mv	s1,s2
    800011d0:	b7d1                	j	80001194 <allocproc+0xb4>
    freeproc(p);
    800011d2:	8526                	mv	a0,s1
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	ea0080e7          	jalr	-352(ra) # 80001074 <freeproc>
    release(&p->lock);
    800011dc:	8526                	mv	a0,s1
    800011de:	00005097          	auipc	ra,0x5
    800011e2:	072080e7          	jalr	114(ra) # 80006250 <release>
    return 0;
    800011e6:	84ca                	mv	s1,s2
    800011e8:	b775                	j	80001194 <allocproc+0xb4>
    freeproc(p);
    800011ea:	8526                	mv	a0,s1
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	e88080e7          	jalr	-376(ra) # 80001074 <freeproc>
    release(&p->lock);
    800011f4:	8526                	mv	a0,s1
    800011f6:	00005097          	auipc	ra,0x5
    800011fa:	05a080e7          	jalr	90(ra) # 80006250 <release>
    return 0;
    800011fe:	84ca                	mv	s1,s2
    80001200:	bf51                	j	80001194 <allocproc+0xb4>

0000000080001202 <userinit>:
{
    80001202:	1101                	addi	sp,sp,-32
    80001204:	ec06                	sd	ra,24(sp)
    80001206:	e822                	sd	s0,16(sp)
    80001208:	e426                	sd	s1,8(sp)
    8000120a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	ed4080e7          	jalr	-300(ra) # 800010e0 <allocproc>
    80001214:	84aa                	mv	s1,a0
  initproc = p;
    80001216:	00007797          	auipc	a5,0x7
    8000121a:	6ea7bd23          	sd	a0,1786(a5) # 80008910 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000121e:	03400613          	li	a2,52
    80001222:	00007597          	auipc	a1,0x7
    80001226:	67e58593          	addi	a1,a1,1662 # 800088a0 <initcode>
    8000122a:	6928                	ld	a0,80(a0)
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	5d0080e7          	jalr	1488(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    80001234:	6785                	lui	a5,0x1
    80001236:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001238:	6cb8                	ld	a4,88(s1)
    8000123a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000123e:	6cb8                	ld	a4,88(s1)
    80001240:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001242:	4641                	li	a2,16
    80001244:	00007597          	auipc	a1,0x7
    80001248:	f3c58593          	addi	a1,a1,-196 # 80008180 <etext+0x180>
    8000124c:	15848513          	addi	a0,s1,344
    80001250:	fffff097          	auipc	ra,0xfffff
    80001254:	072080e7          	jalr	114(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001258:	00007517          	auipc	a0,0x7
    8000125c:	f3850513          	addi	a0,a0,-200 # 80008190 <etext+0x190>
    80001260:	00002097          	auipc	ra,0x2
    80001264:	0fe080e7          	jalr	254(ra) # 8000335e <namei>
    80001268:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000126c:	478d                	li	a5,3
    8000126e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001270:	8526                	mv	a0,s1
    80001272:	00005097          	auipc	ra,0x5
    80001276:	fde080e7          	jalr	-34(ra) # 80006250 <release>
}
    8000127a:	60e2                	ld	ra,24(sp)
    8000127c:	6442                	ld	s0,16(sp)
    8000127e:	64a2                	ld	s1,8(sp)
    80001280:	6105                	addi	sp,sp,32
    80001282:	8082                	ret

0000000080001284 <growproc>:
{
    80001284:	1101                	addi	sp,sp,-32
    80001286:	ec06                	sd	ra,24(sp)
    80001288:	e822                	sd	s0,16(sp)
    8000128a:	e426                	sd	s1,8(sp)
    8000128c:	e04a                	sd	s2,0(sp)
    8000128e:	1000                	addi	s0,sp,32
    80001290:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001292:	00000097          	auipc	ra,0x0
    80001296:	bbc080e7          	jalr	-1092(ra) # 80000e4e <myproc>
    8000129a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000129c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000129e:	01204c63          	bgtz	s2,800012b6 <growproc+0x32>
  } else if(n < 0){
    800012a2:	02094663          	bltz	s2,800012ce <growproc+0x4a>
  p->sz = sz;
    800012a6:	e4ac                	sd	a1,72(s1)
  return 0;
    800012a8:	4501                	li	a0,0
}
    800012aa:	60e2                	ld	ra,24(sp)
    800012ac:	6442                	ld	s0,16(sp)
    800012ae:	64a2                	ld	s1,8(sp)
    800012b0:	6902                	ld	s2,0(sp)
    800012b2:	6105                	addi	sp,sp,32
    800012b4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800012b6:	4691                	li	a3,4
    800012b8:	00b90633          	add	a2,s2,a1
    800012bc:	6928                	ld	a0,80(a0)
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	5f8080e7          	jalr	1528(ra) # 800008b6 <uvmalloc>
    800012c6:	85aa                	mv	a1,a0
    800012c8:	fd79                	bnez	a0,800012a6 <growproc+0x22>
      return -1;
    800012ca:	557d                	li	a0,-1
    800012cc:	bff9                	j	800012aa <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012ce:	00b90633          	add	a2,s2,a1
    800012d2:	6928                	ld	a0,80(a0)
    800012d4:	fffff097          	auipc	ra,0xfffff
    800012d8:	59a080e7          	jalr	1434(ra) # 8000086e <uvmdealloc>
    800012dc:	85aa                	mv	a1,a0
    800012de:	b7e1                	j	800012a6 <growproc+0x22>

00000000800012e0 <fork>:
{
    800012e0:	7139                	addi	sp,sp,-64
    800012e2:	fc06                	sd	ra,56(sp)
    800012e4:	f822                	sd	s0,48(sp)
    800012e6:	f426                	sd	s1,40(sp)
    800012e8:	f04a                	sd	s2,32(sp)
    800012ea:	ec4e                	sd	s3,24(sp)
    800012ec:	e852                	sd	s4,16(sp)
    800012ee:	e456                	sd	s5,8(sp)
    800012f0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	b5c080e7          	jalr	-1188(ra) # 80000e4e <myproc>
    800012fa:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012fc:	00000097          	auipc	ra,0x0
    80001300:	de4080e7          	jalr	-540(ra) # 800010e0 <allocproc>
    80001304:	10050c63          	beqz	a0,8000141c <fork+0x13c>
    80001308:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000130a:	048ab603          	ld	a2,72(s5)
    8000130e:	692c                	ld	a1,80(a0)
    80001310:	050ab503          	ld	a0,80(s5)
    80001314:	fffff097          	auipc	ra,0xfffff
    80001318:	6f6080e7          	jalr	1782(ra) # 80000a0a <uvmcopy>
    8000131c:	04054863          	bltz	a0,8000136c <fork+0x8c>
  np->sz = p->sz;
    80001320:	048ab783          	ld	a5,72(s5)
    80001324:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001328:	058ab683          	ld	a3,88(s5)
    8000132c:	87b6                	mv	a5,a3
    8000132e:	058a3703          	ld	a4,88(s4)
    80001332:	12068693          	addi	a3,a3,288
    80001336:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000133a:	6788                	ld	a0,8(a5)
    8000133c:	6b8c                	ld	a1,16(a5)
    8000133e:	6f90                	ld	a2,24(a5)
    80001340:	01073023          	sd	a6,0(a4)
    80001344:	e708                	sd	a0,8(a4)
    80001346:	eb0c                	sd	a1,16(a4)
    80001348:	ef10                	sd	a2,24(a4)
    8000134a:	02078793          	addi	a5,a5,32
    8000134e:	02070713          	addi	a4,a4,32
    80001352:	fed792e3          	bne	a5,a3,80001336 <fork+0x56>
  np->trapframe->a0 = 0;
    80001356:	058a3783          	ld	a5,88(s4)
    8000135a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000135e:	0d0a8493          	addi	s1,s5,208
    80001362:	0d0a0913          	addi	s2,s4,208
    80001366:	150a8993          	addi	s3,s5,336
    8000136a:	a00d                	j	8000138c <fork+0xac>
    freeproc(np);
    8000136c:	8552                	mv	a0,s4
    8000136e:	00000097          	auipc	ra,0x0
    80001372:	d06080e7          	jalr	-762(ra) # 80001074 <freeproc>
    release(&np->lock);
    80001376:	8552                	mv	a0,s4
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	ed8080e7          	jalr	-296(ra) # 80006250 <release>
    return -1;
    80001380:	597d                	li	s2,-1
    80001382:	a059                	j	80001408 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001384:	04a1                	addi	s1,s1,8
    80001386:	0921                	addi	s2,s2,8
    80001388:	01348b63          	beq	s1,s3,8000139e <fork+0xbe>
    if(p->ofile[i])
    8000138c:	6088                	ld	a0,0(s1)
    8000138e:	d97d                	beqz	a0,80001384 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001390:	00002097          	auipc	ra,0x2
    80001394:	664080e7          	jalr	1636(ra) # 800039f4 <filedup>
    80001398:	00a93023          	sd	a0,0(s2)
    8000139c:	b7e5                	j	80001384 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000139e:	150ab503          	ld	a0,336(s5)
    800013a2:	00001097          	auipc	ra,0x1
    800013a6:	7d8080e7          	jalr	2008(ra) # 80002b7a <idup>
    800013aa:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013ae:	4641                	li	a2,16
    800013b0:	158a8593          	addi	a1,s5,344
    800013b4:	158a0513          	addi	a0,s4,344
    800013b8:	fffff097          	auipc	ra,0xfffff
    800013bc:	f0a080e7          	jalr	-246(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800013c0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800013c4:	8552                	mv	a0,s4
    800013c6:	00005097          	auipc	ra,0x5
    800013ca:	e8a080e7          	jalr	-374(ra) # 80006250 <release>
  acquire(&wait_lock);
    800013ce:	00007497          	auipc	s1,0x7
    800013d2:	59a48493          	addi	s1,s1,1434 # 80008968 <wait_lock>
    800013d6:	8526                	mv	a0,s1
    800013d8:	00005097          	auipc	ra,0x5
    800013dc:	dc4080e7          	jalr	-572(ra) # 8000619c <acquire>
  np->parent = p;
    800013e0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013e4:	8526                	mv	a0,s1
    800013e6:	00005097          	auipc	ra,0x5
    800013ea:	e6a080e7          	jalr	-406(ra) # 80006250 <release>
  acquire(&np->lock);
    800013ee:	8552                	mv	a0,s4
    800013f0:	00005097          	auipc	ra,0x5
    800013f4:	dac080e7          	jalr	-596(ra) # 8000619c <acquire>
  np->state = RUNNABLE;
    800013f8:	478d                	li	a5,3
    800013fa:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013fe:	8552                	mv	a0,s4
    80001400:	00005097          	auipc	ra,0x5
    80001404:	e50080e7          	jalr	-432(ra) # 80006250 <release>
}
    80001408:	854a                	mv	a0,s2
    8000140a:	70e2                	ld	ra,56(sp)
    8000140c:	7442                	ld	s0,48(sp)
    8000140e:	74a2                	ld	s1,40(sp)
    80001410:	7902                	ld	s2,32(sp)
    80001412:	69e2                	ld	s3,24(sp)
    80001414:	6a42                	ld	s4,16(sp)
    80001416:	6aa2                	ld	s5,8(sp)
    80001418:	6121                	addi	sp,sp,64
    8000141a:	8082                	ret
    return -1;
    8000141c:	597d                	li	s2,-1
    8000141e:	b7ed                	j	80001408 <fork+0x128>

0000000080001420 <scheduler>:
{
    80001420:	7139                	addi	sp,sp,-64
    80001422:	fc06                	sd	ra,56(sp)
    80001424:	f822                	sd	s0,48(sp)
    80001426:	f426                	sd	s1,40(sp)
    80001428:	f04a                	sd	s2,32(sp)
    8000142a:	ec4e                	sd	s3,24(sp)
    8000142c:	e852                	sd	s4,16(sp)
    8000142e:	e456                	sd	s5,8(sp)
    80001430:	e05a                	sd	s6,0(sp)
    80001432:	0080                	addi	s0,sp,64
    80001434:	8792                	mv	a5,tp
  int id = r_tp();
    80001436:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001438:	00779a93          	slli	s5,a5,0x7
    8000143c:	00007717          	auipc	a4,0x7
    80001440:	51470713          	addi	a4,a4,1300 # 80008950 <pid_lock>
    80001444:	9756                	add	a4,a4,s5
    80001446:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000144a:	00007717          	auipc	a4,0x7
    8000144e:	53e70713          	addi	a4,a4,1342 # 80008988 <cpus+0x8>
    80001452:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001454:	498d                	li	s3,3
        p->state = RUNNING;
    80001456:	4b11                	li	s6,4
        c->proc = p;
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	00007a17          	auipc	s4,0x7
    8000145e:	4f6a0a13          	addi	s4,s4,1270 # 80008950 <pid_lock>
    80001462:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001464:	0000d917          	auipc	s2,0xd
    80001468:	51c90913          	addi	s2,s2,1308 # 8000e980 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000146c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001470:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001474:	10079073          	csrw	sstatus,a5
    80001478:	00008497          	auipc	s1,0x8
    8000147c:	90848493          	addi	s1,s1,-1784 # 80008d80 <proc>
    80001480:	a811                	j	80001494 <scheduler+0x74>
      release(&p->lock);
    80001482:	8526                	mv	a0,s1
    80001484:	00005097          	auipc	ra,0x5
    80001488:	dcc080e7          	jalr	-564(ra) # 80006250 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000148c:	17048493          	addi	s1,s1,368
    80001490:	fd248ee3          	beq	s1,s2,8000146c <scheduler+0x4c>
      acquire(&p->lock);
    80001494:	8526                	mv	a0,s1
    80001496:	00005097          	auipc	ra,0x5
    8000149a:	d06080e7          	jalr	-762(ra) # 8000619c <acquire>
      if(p->state == RUNNABLE) {
    8000149e:	4c9c                	lw	a5,24(s1)
    800014a0:	ff3791e3          	bne	a5,s3,80001482 <scheduler+0x62>
        p->state = RUNNING;
    800014a4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800014a8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800014ac:	06048593          	addi	a1,s1,96
    800014b0:	8556                	mv	a0,s5
    800014b2:	00000097          	auipc	ra,0x0
    800014b6:	682080e7          	jalr	1666(ra) # 80001b34 <swtch>
        c->proc = 0;
    800014ba:	020a3823          	sd	zero,48(s4)
    800014be:	b7d1                	j	80001482 <scheduler+0x62>

00000000800014c0 <sched>:
{
    800014c0:	7179                	addi	sp,sp,-48
    800014c2:	f406                	sd	ra,40(sp)
    800014c4:	f022                	sd	s0,32(sp)
    800014c6:	ec26                	sd	s1,24(sp)
    800014c8:	e84a                	sd	s2,16(sp)
    800014ca:	e44e                	sd	s3,8(sp)
    800014cc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	980080e7          	jalr	-1664(ra) # 80000e4e <myproc>
    800014d6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	c4a080e7          	jalr	-950(ra) # 80006122 <holding>
    800014e0:	c93d                	beqz	a0,80001556 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014e2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014e4:	2781                	sext.w	a5,a5
    800014e6:	079e                	slli	a5,a5,0x7
    800014e8:	00007717          	auipc	a4,0x7
    800014ec:	46870713          	addi	a4,a4,1128 # 80008950 <pid_lock>
    800014f0:	97ba                	add	a5,a5,a4
    800014f2:	0a87a703          	lw	a4,168(a5)
    800014f6:	4785                	li	a5,1
    800014f8:	06f71763          	bne	a4,a5,80001566 <sched+0xa6>
  if(p->state == RUNNING)
    800014fc:	4c98                	lw	a4,24(s1)
    800014fe:	4791                	li	a5,4
    80001500:	06f70b63          	beq	a4,a5,80001576 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001504:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001508:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000150a:	efb5                	bnez	a5,80001586 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000150c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000150e:	00007917          	auipc	s2,0x7
    80001512:	44290913          	addi	s2,s2,1090 # 80008950 <pid_lock>
    80001516:	2781                	sext.w	a5,a5
    80001518:	079e                	slli	a5,a5,0x7
    8000151a:	97ca                	add	a5,a5,s2
    8000151c:	0ac7a983          	lw	s3,172(a5)
    80001520:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001522:	2781                	sext.w	a5,a5
    80001524:	079e                	slli	a5,a5,0x7
    80001526:	00007597          	auipc	a1,0x7
    8000152a:	46258593          	addi	a1,a1,1122 # 80008988 <cpus+0x8>
    8000152e:	95be                	add	a1,a1,a5
    80001530:	06048513          	addi	a0,s1,96
    80001534:	00000097          	auipc	ra,0x0
    80001538:	600080e7          	jalr	1536(ra) # 80001b34 <swtch>
    8000153c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000153e:	2781                	sext.w	a5,a5
    80001540:	079e                	slli	a5,a5,0x7
    80001542:	97ca                	add	a5,a5,s2
    80001544:	0b37a623          	sw	s3,172(a5)
}
    80001548:	70a2                	ld	ra,40(sp)
    8000154a:	7402                	ld	s0,32(sp)
    8000154c:	64e2                	ld	s1,24(sp)
    8000154e:	6942                	ld	s2,16(sp)
    80001550:	69a2                	ld	s3,8(sp)
    80001552:	6145                	addi	sp,sp,48
    80001554:	8082                	ret
    panic("sched p->lock");
    80001556:	00007517          	auipc	a0,0x7
    8000155a:	c4250513          	addi	a0,a0,-958 # 80008198 <etext+0x198>
    8000155e:	00004097          	auipc	ra,0x4
    80001562:	702080e7          	jalr	1794(ra) # 80005c60 <panic>
    panic("sched locks");
    80001566:	00007517          	auipc	a0,0x7
    8000156a:	c4250513          	addi	a0,a0,-958 # 800081a8 <etext+0x1a8>
    8000156e:	00004097          	auipc	ra,0x4
    80001572:	6f2080e7          	jalr	1778(ra) # 80005c60 <panic>
    panic("sched running");
    80001576:	00007517          	auipc	a0,0x7
    8000157a:	c4250513          	addi	a0,a0,-958 # 800081b8 <etext+0x1b8>
    8000157e:	00004097          	auipc	ra,0x4
    80001582:	6e2080e7          	jalr	1762(ra) # 80005c60 <panic>
    panic("sched interruptible");
    80001586:	00007517          	auipc	a0,0x7
    8000158a:	c4250513          	addi	a0,a0,-958 # 800081c8 <etext+0x1c8>
    8000158e:	00004097          	auipc	ra,0x4
    80001592:	6d2080e7          	jalr	1746(ra) # 80005c60 <panic>

0000000080001596 <yield>:
{
    80001596:	1101                	addi	sp,sp,-32
    80001598:	ec06                	sd	ra,24(sp)
    8000159a:	e822                	sd	s0,16(sp)
    8000159c:	e426                	sd	s1,8(sp)
    8000159e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	8ae080e7          	jalr	-1874(ra) # 80000e4e <myproc>
    800015a8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	bf2080e7          	jalr	-1038(ra) # 8000619c <acquire>
  p->state = RUNNABLE;
    800015b2:	478d                	li	a5,3
    800015b4:	cc9c                	sw	a5,24(s1)
  sched();
    800015b6:	00000097          	auipc	ra,0x0
    800015ba:	f0a080e7          	jalr	-246(ra) # 800014c0 <sched>
  release(&p->lock);
    800015be:	8526                	mv	a0,s1
    800015c0:	00005097          	auipc	ra,0x5
    800015c4:	c90080e7          	jalr	-880(ra) # 80006250 <release>
}
    800015c8:	60e2                	ld	ra,24(sp)
    800015ca:	6442                	ld	s0,16(sp)
    800015cc:	64a2                	ld	s1,8(sp)
    800015ce:	6105                	addi	sp,sp,32
    800015d0:	8082                	ret

00000000800015d2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015d2:	7179                	addi	sp,sp,-48
    800015d4:	f406                	sd	ra,40(sp)
    800015d6:	f022                	sd	s0,32(sp)
    800015d8:	ec26                	sd	s1,24(sp)
    800015da:	e84a                	sd	s2,16(sp)
    800015dc:	e44e                	sd	s3,8(sp)
    800015de:	1800                	addi	s0,sp,48
    800015e0:	89aa                	mv	s3,a0
    800015e2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	86a080e7          	jalr	-1942(ra) # 80000e4e <myproc>
    800015ec:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	bae080e7          	jalr	-1106(ra) # 8000619c <acquire>
  release(lk);
    800015f6:	854a                	mv	a0,s2
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	c58080e7          	jalr	-936(ra) # 80006250 <release>

  // Go to sleep.
  p->chan = chan;
    80001600:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001604:	4789                	li	a5,2
    80001606:	cc9c                	sw	a5,24(s1)

  sched();
    80001608:	00000097          	auipc	ra,0x0
    8000160c:	eb8080e7          	jalr	-328(ra) # 800014c0 <sched>

  // Tidy up.
  p->chan = 0;
    80001610:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001614:	8526                	mv	a0,s1
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	c3a080e7          	jalr	-966(ra) # 80006250 <release>
  acquire(lk);
    8000161e:	854a                	mv	a0,s2
    80001620:	00005097          	auipc	ra,0x5
    80001624:	b7c080e7          	jalr	-1156(ra) # 8000619c <acquire>
}
    80001628:	70a2                	ld	ra,40(sp)
    8000162a:	7402                	ld	s0,32(sp)
    8000162c:	64e2                	ld	s1,24(sp)
    8000162e:	6942                	ld	s2,16(sp)
    80001630:	69a2                	ld	s3,8(sp)
    80001632:	6145                	addi	sp,sp,48
    80001634:	8082                	ret

0000000080001636 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001636:	7139                	addi	sp,sp,-64
    80001638:	fc06                	sd	ra,56(sp)
    8000163a:	f822                	sd	s0,48(sp)
    8000163c:	f426                	sd	s1,40(sp)
    8000163e:	f04a                	sd	s2,32(sp)
    80001640:	ec4e                	sd	s3,24(sp)
    80001642:	e852                	sd	s4,16(sp)
    80001644:	e456                	sd	s5,8(sp)
    80001646:	0080                	addi	s0,sp,64
    80001648:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000164a:	00007497          	auipc	s1,0x7
    8000164e:	73648493          	addi	s1,s1,1846 # 80008d80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001652:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001654:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001656:	0000d917          	auipc	s2,0xd
    8000165a:	32a90913          	addi	s2,s2,810 # 8000e980 <tickslock>
    8000165e:	a811                	j	80001672 <wakeup+0x3c>
      }
      release(&p->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	00005097          	auipc	ra,0x5
    80001666:	bee080e7          	jalr	-1042(ra) # 80006250 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000166a:	17048493          	addi	s1,s1,368
    8000166e:	03248663          	beq	s1,s2,8000169a <wakeup+0x64>
    if(p != myproc()){
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	7dc080e7          	jalr	2012(ra) # 80000e4e <myproc>
    8000167a:	fea488e3          	beq	s1,a0,8000166a <wakeup+0x34>
      acquire(&p->lock);
    8000167e:	8526                	mv	a0,s1
    80001680:	00005097          	auipc	ra,0x5
    80001684:	b1c080e7          	jalr	-1252(ra) # 8000619c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001688:	4c9c                	lw	a5,24(s1)
    8000168a:	fd379be3          	bne	a5,s3,80001660 <wakeup+0x2a>
    8000168e:	709c                	ld	a5,32(s1)
    80001690:	fd4798e3          	bne	a5,s4,80001660 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001694:	0154ac23          	sw	s5,24(s1)
    80001698:	b7e1                	j	80001660 <wakeup+0x2a>
    }
  }
}
    8000169a:	70e2                	ld	ra,56(sp)
    8000169c:	7442                	ld	s0,48(sp)
    8000169e:	74a2                	ld	s1,40(sp)
    800016a0:	7902                	ld	s2,32(sp)
    800016a2:	69e2                	ld	s3,24(sp)
    800016a4:	6a42                	ld	s4,16(sp)
    800016a6:	6aa2                	ld	s5,8(sp)
    800016a8:	6121                	addi	sp,sp,64
    800016aa:	8082                	ret

00000000800016ac <reparent>:
{
    800016ac:	7179                	addi	sp,sp,-48
    800016ae:	f406                	sd	ra,40(sp)
    800016b0:	f022                	sd	s0,32(sp)
    800016b2:	ec26                	sd	s1,24(sp)
    800016b4:	e84a                	sd	s2,16(sp)
    800016b6:	e44e                	sd	s3,8(sp)
    800016b8:	e052                	sd	s4,0(sp)
    800016ba:	1800                	addi	s0,sp,48
    800016bc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016be:	00007497          	auipc	s1,0x7
    800016c2:	6c248493          	addi	s1,s1,1730 # 80008d80 <proc>
      pp->parent = initproc;
    800016c6:	00007a17          	auipc	s4,0x7
    800016ca:	24aa0a13          	addi	s4,s4,586 # 80008910 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016ce:	0000d997          	auipc	s3,0xd
    800016d2:	2b298993          	addi	s3,s3,690 # 8000e980 <tickslock>
    800016d6:	a029                	j	800016e0 <reparent+0x34>
    800016d8:	17048493          	addi	s1,s1,368
    800016dc:	01348d63          	beq	s1,s3,800016f6 <reparent+0x4a>
    if(pp->parent == p){
    800016e0:	7c9c                	ld	a5,56(s1)
    800016e2:	ff279be3          	bne	a5,s2,800016d8 <reparent+0x2c>
      pp->parent = initproc;
    800016e6:	000a3503          	ld	a0,0(s4)
    800016ea:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	f4a080e7          	jalr	-182(ra) # 80001636 <wakeup>
    800016f4:	b7d5                	j	800016d8 <reparent+0x2c>
}
    800016f6:	70a2                	ld	ra,40(sp)
    800016f8:	7402                	ld	s0,32(sp)
    800016fa:	64e2                	ld	s1,24(sp)
    800016fc:	6942                	ld	s2,16(sp)
    800016fe:	69a2                	ld	s3,8(sp)
    80001700:	6a02                	ld	s4,0(sp)
    80001702:	6145                	addi	sp,sp,48
    80001704:	8082                	ret

0000000080001706 <exit>:
{
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	e052                	sd	s4,0(sp)
    80001714:	1800                	addi	s0,sp,48
    80001716:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001718:	fffff097          	auipc	ra,0xfffff
    8000171c:	736080e7          	jalr	1846(ra) # 80000e4e <myproc>
    80001720:	89aa                	mv	s3,a0
  if(p == initproc)
    80001722:	00007797          	auipc	a5,0x7
    80001726:	1ee7b783          	ld	a5,494(a5) # 80008910 <initproc>
    8000172a:	0d050493          	addi	s1,a0,208
    8000172e:	15050913          	addi	s2,a0,336
    80001732:	02a79363          	bne	a5,a0,80001758 <exit+0x52>
    panic("init exiting");
    80001736:	00007517          	auipc	a0,0x7
    8000173a:	aaa50513          	addi	a0,a0,-1366 # 800081e0 <etext+0x1e0>
    8000173e:	00004097          	auipc	ra,0x4
    80001742:	522080e7          	jalr	1314(ra) # 80005c60 <panic>
      fileclose(f);
    80001746:	00002097          	auipc	ra,0x2
    8000174a:	300080e7          	jalr	768(ra) # 80003a46 <fileclose>
      p->ofile[fd] = 0;
    8000174e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001752:	04a1                	addi	s1,s1,8
    80001754:	01248563          	beq	s1,s2,8000175e <exit+0x58>
    if(p->ofile[fd]){
    80001758:	6088                	ld	a0,0(s1)
    8000175a:	f575                	bnez	a0,80001746 <exit+0x40>
    8000175c:	bfdd                	j	80001752 <exit+0x4c>
  begin_op();
    8000175e:	00002097          	auipc	ra,0x2
    80001762:	e1c080e7          	jalr	-484(ra) # 8000357a <begin_op>
  iput(p->cwd);
    80001766:	1509b503          	ld	a0,336(s3)
    8000176a:	00001097          	auipc	ra,0x1
    8000176e:	608080e7          	jalr	1544(ra) # 80002d72 <iput>
  end_op();
    80001772:	00002097          	auipc	ra,0x2
    80001776:	e88080e7          	jalr	-376(ra) # 800035fa <end_op>
  p->cwd = 0;
    8000177a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000177e:	00007497          	auipc	s1,0x7
    80001782:	1ea48493          	addi	s1,s1,490 # 80008968 <wait_lock>
    80001786:	8526                	mv	a0,s1
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	a14080e7          	jalr	-1516(ra) # 8000619c <acquire>
  reparent(p);
    80001790:	854e                	mv	a0,s3
    80001792:	00000097          	auipc	ra,0x0
    80001796:	f1a080e7          	jalr	-230(ra) # 800016ac <reparent>
  wakeup(p->parent);
    8000179a:	0389b503          	ld	a0,56(s3)
    8000179e:	00000097          	auipc	ra,0x0
    800017a2:	e98080e7          	jalr	-360(ra) # 80001636 <wakeup>
  acquire(&p->lock);
    800017a6:	854e                	mv	a0,s3
    800017a8:	00005097          	auipc	ra,0x5
    800017ac:	9f4080e7          	jalr	-1548(ra) # 8000619c <acquire>
  p->xstate = status;
    800017b0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800017b4:	4795                	li	a5,5
    800017b6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800017ba:	8526                	mv	a0,s1
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	a94080e7          	jalr	-1388(ra) # 80006250 <release>
  sched();
    800017c4:	00000097          	auipc	ra,0x0
    800017c8:	cfc080e7          	jalr	-772(ra) # 800014c0 <sched>
  panic("zombie exit");
    800017cc:	00007517          	auipc	a0,0x7
    800017d0:	a2450513          	addi	a0,a0,-1500 # 800081f0 <etext+0x1f0>
    800017d4:	00004097          	auipc	ra,0x4
    800017d8:	48c080e7          	jalr	1164(ra) # 80005c60 <panic>

00000000800017dc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800017dc:	7179                	addi	sp,sp,-48
    800017de:	f406                	sd	ra,40(sp)
    800017e0:	f022                	sd	s0,32(sp)
    800017e2:	ec26                	sd	s1,24(sp)
    800017e4:	e84a                	sd	s2,16(sp)
    800017e6:	e44e                	sd	s3,8(sp)
    800017e8:	1800                	addi	s0,sp,48
    800017ea:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017ec:	00007497          	auipc	s1,0x7
    800017f0:	59448493          	addi	s1,s1,1428 # 80008d80 <proc>
    800017f4:	0000d997          	auipc	s3,0xd
    800017f8:	18c98993          	addi	s3,s3,396 # 8000e980 <tickslock>
    acquire(&p->lock);
    800017fc:	8526                	mv	a0,s1
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	99e080e7          	jalr	-1634(ra) # 8000619c <acquire>
    if(p->pid == pid){
    80001806:	589c                	lw	a5,48(s1)
    80001808:	01278d63          	beq	a5,s2,80001822 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000180c:	8526                	mv	a0,s1
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	a42080e7          	jalr	-1470(ra) # 80006250 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001816:	17048493          	addi	s1,s1,368
    8000181a:	ff3491e3          	bne	s1,s3,800017fc <kill+0x20>
  }
  return -1;
    8000181e:	557d                	li	a0,-1
    80001820:	a829                	j	8000183a <kill+0x5e>
      p->killed = 1;
    80001822:	4785                	li	a5,1
    80001824:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001826:	4c98                	lw	a4,24(s1)
    80001828:	4789                	li	a5,2
    8000182a:	00f70f63          	beq	a4,a5,80001848 <kill+0x6c>
      release(&p->lock);
    8000182e:	8526                	mv	a0,s1
    80001830:	00005097          	auipc	ra,0x5
    80001834:	a20080e7          	jalr	-1504(ra) # 80006250 <release>
      return 0;
    80001838:	4501                	li	a0,0
}
    8000183a:	70a2                	ld	ra,40(sp)
    8000183c:	7402                	ld	s0,32(sp)
    8000183e:	64e2                	ld	s1,24(sp)
    80001840:	6942                	ld	s2,16(sp)
    80001842:	69a2                	ld	s3,8(sp)
    80001844:	6145                	addi	sp,sp,48
    80001846:	8082                	ret
        p->state = RUNNABLE;
    80001848:	478d                	li	a5,3
    8000184a:	cc9c                	sw	a5,24(s1)
    8000184c:	b7cd                	j	8000182e <kill+0x52>

000000008000184e <setkilled>:

void
setkilled(struct proc *p)
{
    8000184e:	1101                	addi	sp,sp,-32
    80001850:	ec06                	sd	ra,24(sp)
    80001852:	e822                	sd	s0,16(sp)
    80001854:	e426                	sd	s1,8(sp)
    80001856:	1000                	addi	s0,sp,32
    80001858:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	942080e7          	jalr	-1726(ra) # 8000619c <acquire>
  p->killed = 1;
    80001862:	4785                	li	a5,1
    80001864:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	9e8080e7          	jalr	-1560(ra) # 80006250 <release>
}
    80001870:	60e2                	ld	ra,24(sp)
    80001872:	6442                	ld	s0,16(sp)
    80001874:	64a2                	ld	s1,8(sp)
    80001876:	6105                	addi	sp,sp,32
    80001878:	8082                	ret

000000008000187a <killed>:

int
killed(struct proc *p)
{
    8000187a:	1101                	addi	sp,sp,-32
    8000187c:	ec06                	sd	ra,24(sp)
    8000187e:	e822                	sd	s0,16(sp)
    80001880:	e426                	sd	s1,8(sp)
    80001882:	e04a                	sd	s2,0(sp)
    80001884:	1000                	addi	s0,sp,32
    80001886:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	914080e7          	jalr	-1772(ra) # 8000619c <acquire>
  k = p->killed;
    80001890:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	9ba080e7          	jalr	-1606(ra) # 80006250 <release>
  return k;
}
    8000189e:	854a                	mv	a0,s2
    800018a0:	60e2                	ld	ra,24(sp)
    800018a2:	6442                	ld	s0,16(sp)
    800018a4:	64a2                	ld	s1,8(sp)
    800018a6:	6902                	ld	s2,0(sp)
    800018a8:	6105                	addi	sp,sp,32
    800018aa:	8082                	ret

00000000800018ac <wait>:
{
    800018ac:	715d                	addi	sp,sp,-80
    800018ae:	e486                	sd	ra,72(sp)
    800018b0:	e0a2                	sd	s0,64(sp)
    800018b2:	fc26                	sd	s1,56(sp)
    800018b4:	f84a                	sd	s2,48(sp)
    800018b6:	f44e                	sd	s3,40(sp)
    800018b8:	f052                	sd	s4,32(sp)
    800018ba:	ec56                	sd	s5,24(sp)
    800018bc:	e85a                	sd	s6,16(sp)
    800018be:	e45e                	sd	s7,8(sp)
    800018c0:	e062                	sd	s8,0(sp)
    800018c2:	0880                	addi	s0,sp,80
    800018c4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018c6:	fffff097          	auipc	ra,0xfffff
    800018ca:	588080e7          	jalr	1416(ra) # 80000e4e <myproc>
    800018ce:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018d0:	00007517          	auipc	a0,0x7
    800018d4:	09850513          	addi	a0,a0,152 # 80008968 <wait_lock>
    800018d8:	00005097          	auipc	ra,0x5
    800018dc:	8c4080e7          	jalr	-1852(ra) # 8000619c <acquire>
    havekids = 0;
    800018e0:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800018e2:	4a15                	li	s4,5
        havekids = 1;
    800018e4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e6:	0000d997          	auipc	s3,0xd
    800018ea:	09a98993          	addi	s3,s3,154 # 8000e980 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018ee:	00007c17          	auipc	s8,0x7
    800018f2:	07ac0c13          	addi	s8,s8,122 # 80008968 <wait_lock>
    havekids = 0;
    800018f6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f8:	00007497          	auipc	s1,0x7
    800018fc:	48848493          	addi	s1,s1,1160 # 80008d80 <proc>
    80001900:	a0bd                	j	8000196e <wait+0xc2>
          pid = pp->pid;
    80001902:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001906:	000b0e63          	beqz	s6,80001922 <wait+0x76>
    8000190a:	4691                	li	a3,4
    8000190c:	02c48613          	addi	a2,s1,44
    80001910:	85da                	mv	a1,s6
    80001912:	05093503          	ld	a0,80(s2)
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	1f8080e7          	jalr	504(ra) # 80000b0e <copyout>
    8000191e:	02054563          	bltz	a0,80001948 <wait+0x9c>
          freeproc(pp);
    80001922:	8526                	mv	a0,s1
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	750080e7          	jalr	1872(ra) # 80001074 <freeproc>
          release(&pp->lock);
    8000192c:	8526                	mv	a0,s1
    8000192e:	00005097          	auipc	ra,0x5
    80001932:	922080e7          	jalr	-1758(ra) # 80006250 <release>
          release(&wait_lock);
    80001936:	00007517          	auipc	a0,0x7
    8000193a:	03250513          	addi	a0,a0,50 # 80008968 <wait_lock>
    8000193e:	00005097          	auipc	ra,0x5
    80001942:	912080e7          	jalr	-1774(ra) # 80006250 <release>
          return pid;
    80001946:	a0b5                	j	800019b2 <wait+0x106>
            release(&pp->lock);
    80001948:	8526                	mv	a0,s1
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	906080e7          	jalr	-1786(ra) # 80006250 <release>
            release(&wait_lock);
    80001952:	00007517          	auipc	a0,0x7
    80001956:	01650513          	addi	a0,a0,22 # 80008968 <wait_lock>
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	8f6080e7          	jalr	-1802(ra) # 80006250 <release>
            return -1;
    80001962:	59fd                	li	s3,-1
    80001964:	a0b9                	j	800019b2 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001966:	17048493          	addi	s1,s1,368
    8000196a:	03348463          	beq	s1,s3,80001992 <wait+0xe6>
      if(pp->parent == p){
    8000196e:	7c9c                	ld	a5,56(s1)
    80001970:	ff279be3          	bne	a5,s2,80001966 <wait+0xba>
        acquire(&pp->lock);
    80001974:	8526                	mv	a0,s1
    80001976:	00005097          	auipc	ra,0x5
    8000197a:	826080e7          	jalr	-2010(ra) # 8000619c <acquire>
        if(pp->state == ZOMBIE){
    8000197e:	4c9c                	lw	a5,24(s1)
    80001980:	f94781e3          	beq	a5,s4,80001902 <wait+0x56>
        release(&pp->lock);
    80001984:	8526                	mv	a0,s1
    80001986:	00005097          	auipc	ra,0x5
    8000198a:	8ca080e7          	jalr	-1846(ra) # 80006250 <release>
        havekids = 1;
    8000198e:	8756                	mv	a4,s5
    80001990:	bfd9                	j	80001966 <wait+0xba>
    if(!havekids || killed(p)){
    80001992:	c719                	beqz	a4,800019a0 <wait+0xf4>
    80001994:	854a                	mv	a0,s2
    80001996:	00000097          	auipc	ra,0x0
    8000199a:	ee4080e7          	jalr	-284(ra) # 8000187a <killed>
    8000199e:	c51d                	beqz	a0,800019cc <wait+0x120>
      release(&wait_lock);
    800019a0:	00007517          	auipc	a0,0x7
    800019a4:	fc850513          	addi	a0,a0,-56 # 80008968 <wait_lock>
    800019a8:	00005097          	auipc	ra,0x5
    800019ac:	8a8080e7          	jalr	-1880(ra) # 80006250 <release>
      return -1;
    800019b0:	59fd                	li	s3,-1
}
    800019b2:	854e                	mv	a0,s3
    800019b4:	60a6                	ld	ra,72(sp)
    800019b6:	6406                	ld	s0,64(sp)
    800019b8:	74e2                	ld	s1,56(sp)
    800019ba:	7942                	ld	s2,48(sp)
    800019bc:	79a2                	ld	s3,40(sp)
    800019be:	7a02                	ld	s4,32(sp)
    800019c0:	6ae2                	ld	s5,24(sp)
    800019c2:	6b42                	ld	s6,16(sp)
    800019c4:	6ba2                	ld	s7,8(sp)
    800019c6:	6c02                	ld	s8,0(sp)
    800019c8:	6161                	addi	sp,sp,80
    800019ca:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019cc:	85e2                	mv	a1,s8
    800019ce:	854a                	mv	a0,s2
    800019d0:	00000097          	auipc	ra,0x0
    800019d4:	c02080e7          	jalr	-1022(ra) # 800015d2 <sleep>
    havekids = 0;
    800019d8:	bf39                	j	800018f6 <wait+0x4a>

00000000800019da <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019da:	7179                	addi	sp,sp,-48
    800019dc:	f406                	sd	ra,40(sp)
    800019de:	f022                	sd	s0,32(sp)
    800019e0:	ec26                	sd	s1,24(sp)
    800019e2:	e84a                	sd	s2,16(sp)
    800019e4:	e44e                	sd	s3,8(sp)
    800019e6:	e052                	sd	s4,0(sp)
    800019e8:	1800                	addi	s0,sp,48
    800019ea:	84aa                	mv	s1,a0
    800019ec:	892e                	mv	s2,a1
    800019ee:	89b2                	mv	s3,a2
    800019f0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019f2:	fffff097          	auipc	ra,0xfffff
    800019f6:	45c080e7          	jalr	1116(ra) # 80000e4e <myproc>
  if(user_dst){
    800019fa:	c08d                	beqz	s1,80001a1c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019fc:	86d2                	mv	a3,s4
    800019fe:	864e                	mv	a2,s3
    80001a00:	85ca                	mv	a1,s2
    80001a02:	6928                	ld	a0,80(a0)
    80001a04:	fffff097          	auipc	ra,0xfffff
    80001a08:	10a080e7          	jalr	266(ra) # 80000b0e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a0c:	70a2                	ld	ra,40(sp)
    80001a0e:	7402                	ld	s0,32(sp)
    80001a10:	64e2                	ld	s1,24(sp)
    80001a12:	6942                	ld	s2,16(sp)
    80001a14:	69a2                	ld	s3,8(sp)
    80001a16:	6a02                	ld	s4,0(sp)
    80001a18:	6145                	addi	sp,sp,48
    80001a1a:	8082                	ret
    memmove((char *)dst, src, len);
    80001a1c:	000a061b          	sext.w	a2,s4
    80001a20:	85ce                	mv	a1,s3
    80001a22:	854a                	mv	a0,s2
    80001a24:	ffffe097          	auipc	ra,0xffffe
    80001a28:	7b0080e7          	jalr	1968(ra) # 800001d4 <memmove>
    return 0;
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	bff9                	j	80001a0c <either_copyout+0x32>

0000000080001a30 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a30:	7179                	addi	sp,sp,-48
    80001a32:	f406                	sd	ra,40(sp)
    80001a34:	f022                	sd	s0,32(sp)
    80001a36:	ec26                	sd	s1,24(sp)
    80001a38:	e84a                	sd	s2,16(sp)
    80001a3a:	e44e                	sd	s3,8(sp)
    80001a3c:	e052                	sd	s4,0(sp)
    80001a3e:	1800                	addi	s0,sp,48
    80001a40:	892a                	mv	s2,a0
    80001a42:	84ae                	mv	s1,a1
    80001a44:	89b2                	mv	s3,a2
    80001a46:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	406080e7          	jalr	1030(ra) # 80000e4e <myproc>
  if(user_src){
    80001a50:	c08d                	beqz	s1,80001a72 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a52:	86d2                	mv	a3,s4
    80001a54:	864e                	mv	a2,s3
    80001a56:	85ca                	mv	a1,s2
    80001a58:	6928                	ld	a0,80(a0)
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	140080e7          	jalr	320(ra) # 80000b9a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a62:	70a2                	ld	ra,40(sp)
    80001a64:	7402                	ld	s0,32(sp)
    80001a66:	64e2                	ld	s1,24(sp)
    80001a68:	6942                	ld	s2,16(sp)
    80001a6a:	69a2                	ld	s3,8(sp)
    80001a6c:	6a02                	ld	s4,0(sp)
    80001a6e:	6145                	addi	sp,sp,48
    80001a70:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a72:	000a061b          	sext.w	a2,s4
    80001a76:	85ce                	mv	a1,s3
    80001a78:	854a                	mv	a0,s2
    80001a7a:	ffffe097          	auipc	ra,0xffffe
    80001a7e:	75a080e7          	jalr	1882(ra) # 800001d4 <memmove>
    return 0;
    80001a82:	8526                	mv	a0,s1
    80001a84:	bff9                	j	80001a62 <either_copyin+0x32>

0000000080001a86 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a86:	715d                	addi	sp,sp,-80
    80001a88:	e486                	sd	ra,72(sp)
    80001a8a:	e0a2                	sd	s0,64(sp)
    80001a8c:	fc26                	sd	s1,56(sp)
    80001a8e:	f84a                	sd	s2,48(sp)
    80001a90:	f44e                	sd	s3,40(sp)
    80001a92:	f052                	sd	s4,32(sp)
    80001a94:	ec56                	sd	s5,24(sp)
    80001a96:	e85a                	sd	s6,16(sp)
    80001a98:	e45e                	sd	s7,8(sp)
    80001a9a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a9c:	00006517          	auipc	a0,0x6
    80001aa0:	5ac50513          	addi	a0,a0,1452 # 80008048 <etext+0x48>
    80001aa4:	00004097          	auipc	ra,0x4
    80001aa8:	206080e7          	jalr	518(ra) # 80005caa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aac:	00007497          	auipc	s1,0x7
    80001ab0:	42c48493          	addi	s1,s1,1068 # 80008ed8 <proc+0x158>
    80001ab4:	0000d917          	auipc	s2,0xd
    80001ab8:	02490913          	addi	s2,s2,36 # 8000ead8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001abc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001abe:	00006997          	auipc	s3,0x6
    80001ac2:	74298993          	addi	s3,s3,1858 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001ac6:	00006a97          	auipc	s5,0x6
    80001aca:	742a8a93          	addi	s5,s5,1858 # 80008208 <etext+0x208>
    printf("\n");
    80001ace:	00006a17          	auipc	s4,0x6
    80001ad2:	57aa0a13          	addi	s4,s4,1402 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ad6:	00006b97          	auipc	s7,0x6
    80001ada:	772b8b93          	addi	s7,s7,1906 # 80008248 <states.0>
    80001ade:	a00d                	j	80001b00 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ae0:	ed86a583          	lw	a1,-296(a3)
    80001ae4:	8556                	mv	a0,s5
    80001ae6:	00004097          	auipc	ra,0x4
    80001aea:	1c4080e7          	jalr	452(ra) # 80005caa <printf>
    printf("\n");
    80001aee:	8552                	mv	a0,s4
    80001af0:	00004097          	auipc	ra,0x4
    80001af4:	1ba080e7          	jalr	442(ra) # 80005caa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001af8:	17048493          	addi	s1,s1,368
    80001afc:	03248163          	beq	s1,s2,80001b1e <procdump+0x98>
    if(p->state == UNUSED)
    80001b00:	86a6                	mv	a3,s1
    80001b02:	ec04a783          	lw	a5,-320(s1)
    80001b06:	dbed                	beqz	a5,80001af8 <procdump+0x72>
      state = "???";
    80001b08:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b0a:	fcfb6be3          	bltu	s6,a5,80001ae0 <procdump+0x5a>
    80001b0e:	1782                	slli	a5,a5,0x20
    80001b10:	9381                	srli	a5,a5,0x20
    80001b12:	078e                	slli	a5,a5,0x3
    80001b14:	97de                	add	a5,a5,s7
    80001b16:	6390                	ld	a2,0(a5)
    80001b18:	f661                	bnez	a2,80001ae0 <procdump+0x5a>
      state = "???";
    80001b1a:	864e                	mv	a2,s3
    80001b1c:	b7d1                	j	80001ae0 <procdump+0x5a>
  }
}
    80001b1e:	60a6                	ld	ra,72(sp)
    80001b20:	6406                	ld	s0,64(sp)
    80001b22:	74e2                	ld	s1,56(sp)
    80001b24:	7942                	ld	s2,48(sp)
    80001b26:	79a2                	ld	s3,40(sp)
    80001b28:	7a02                	ld	s4,32(sp)
    80001b2a:	6ae2                	ld	s5,24(sp)
    80001b2c:	6b42                	ld	s6,16(sp)
    80001b2e:	6ba2                	ld	s7,8(sp)
    80001b30:	6161                	addi	sp,sp,80
    80001b32:	8082                	ret

0000000080001b34 <swtch>:
    80001b34:	00153023          	sd	ra,0(a0)
    80001b38:	00253423          	sd	sp,8(a0)
    80001b3c:	e900                	sd	s0,16(a0)
    80001b3e:	ed04                	sd	s1,24(a0)
    80001b40:	03253023          	sd	s2,32(a0)
    80001b44:	03353423          	sd	s3,40(a0)
    80001b48:	03453823          	sd	s4,48(a0)
    80001b4c:	03553c23          	sd	s5,56(a0)
    80001b50:	05653023          	sd	s6,64(a0)
    80001b54:	05753423          	sd	s7,72(a0)
    80001b58:	05853823          	sd	s8,80(a0)
    80001b5c:	05953c23          	sd	s9,88(a0)
    80001b60:	07a53023          	sd	s10,96(a0)
    80001b64:	07b53423          	sd	s11,104(a0)
    80001b68:	0005b083          	ld	ra,0(a1)
    80001b6c:	0085b103          	ld	sp,8(a1)
    80001b70:	6980                	ld	s0,16(a1)
    80001b72:	6d84                	ld	s1,24(a1)
    80001b74:	0205b903          	ld	s2,32(a1)
    80001b78:	0285b983          	ld	s3,40(a1)
    80001b7c:	0305ba03          	ld	s4,48(a1)
    80001b80:	0385ba83          	ld	s5,56(a1)
    80001b84:	0405bb03          	ld	s6,64(a1)
    80001b88:	0485bb83          	ld	s7,72(a1)
    80001b8c:	0505bc03          	ld	s8,80(a1)
    80001b90:	0585bc83          	ld	s9,88(a1)
    80001b94:	0605bd03          	ld	s10,96(a1)
    80001b98:	0685bd83          	ld	s11,104(a1)
    80001b9c:	8082                	ret

0000000080001b9e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b9e:	1141                	addi	sp,sp,-16
    80001ba0:	e406                	sd	ra,8(sp)
    80001ba2:	e022                	sd	s0,0(sp)
    80001ba4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ba6:	00006597          	auipc	a1,0x6
    80001baa:	6d258593          	addi	a1,a1,1746 # 80008278 <states.0+0x30>
    80001bae:	0000d517          	auipc	a0,0xd
    80001bb2:	dd250513          	addi	a0,a0,-558 # 8000e980 <tickslock>
    80001bb6:	00004097          	auipc	ra,0x4
    80001bba:	556080e7          	jalr	1366(ra) # 8000610c <initlock>
}
    80001bbe:	60a2                	ld	ra,8(sp)
    80001bc0:	6402                	ld	s0,0(sp)
    80001bc2:	0141                	addi	sp,sp,16
    80001bc4:	8082                	ret

0000000080001bc6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bc6:	1141                	addi	sp,sp,-16
    80001bc8:	e422                	sd	s0,8(sp)
    80001bca:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bcc:	00003797          	auipc	a5,0x3
    80001bd0:	4c478793          	addi	a5,a5,1220 # 80005090 <kernelvec>
    80001bd4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bd8:	6422                	ld	s0,8(sp)
    80001bda:	0141                	addi	sp,sp,16
    80001bdc:	8082                	ret

0000000080001bde <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bde:	1141                	addi	sp,sp,-16
    80001be0:	e406                	sd	ra,8(sp)
    80001be2:	e022                	sd	s0,0(sp)
    80001be4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001be6:	fffff097          	auipc	ra,0xfffff
    80001bea:	268080e7          	jalr	616(ra) # 80000e4e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bf2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bf4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bf8:	00005617          	auipc	a2,0x5
    80001bfc:	40860613          	addi	a2,a2,1032 # 80007000 <_trampoline>
    80001c00:	00005697          	auipc	a3,0x5
    80001c04:	40068693          	addi	a3,a3,1024 # 80007000 <_trampoline>
    80001c08:	8e91                	sub	a3,a3,a2
    80001c0a:	040007b7          	lui	a5,0x4000
    80001c0e:	17fd                	addi	a5,a5,-1
    80001c10:	07b2                	slli	a5,a5,0xc
    80001c12:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c14:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c18:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c1a:	180026f3          	csrr	a3,satp
    80001c1e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c20:	6d38                	ld	a4,88(a0)
    80001c22:	6134                	ld	a3,64(a0)
    80001c24:	6585                	lui	a1,0x1
    80001c26:	96ae                	add	a3,a3,a1
    80001c28:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c2a:	6d38                	ld	a4,88(a0)
    80001c2c:	00000697          	auipc	a3,0x0
    80001c30:	13068693          	addi	a3,a3,304 # 80001d5c <usertrap>
    80001c34:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c36:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c38:	8692                	mv	a3,tp
    80001c3a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c40:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c44:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c48:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c4c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c4e:	6f18                	ld	a4,24(a4)
    80001c50:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c54:	6928                	ld	a0,80(a0)
    80001c56:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c58:	00005717          	auipc	a4,0x5
    80001c5c:	44470713          	addi	a4,a4,1092 # 8000709c <userret>
    80001c60:	8f11                	sub	a4,a4,a2
    80001c62:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c64:	577d                	li	a4,-1
    80001c66:	177e                	slli	a4,a4,0x3f
    80001c68:	8d59                	or	a0,a0,a4
    80001c6a:	9782                	jalr	a5
}
    80001c6c:	60a2                	ld	ra,8(sp)
    80001c6e:	6402                	ld	s0,0(sp)
    80001c70:	0141                	addi	sp,sp,16
    80001c72:	8082                	ret

0000000080001c74 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c74:	1101                	addi	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c7e:	0000d497          	auipc	s1,0xd
    80001c82:	d0248493          	addi	s1,s1,-766 # 8000e980 <tickslock>
    80001c86:	8526                	mv	a0,s1
    80001c88:	00004097          	auipc	ra,0x4
    80001c8c:	514080e7          	jalr	1300(ra) # 8000619c <acquire>
  ticks++;
    80001c90:	00007517          	auipc	a0,0x7
    80001c94:	c8850513          	addi	a0,a0,-888 # 80008918 <ticks>
    80001c98:	411c                	lw	a5,0(a0)
    80001c9a:	2785                	addiw	a5,a5,1
    80001c9c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c9e:	00000097          	auipc	ra,0x0
    80001ca2:	998080e7          	jalr	-1640(ra) # 80001636 <wakeup>
  release(&tickslock);
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	00004097          	auipc	ra,0x4
    80001cac:	5a8080e7          	jalr	1448(ra) # 80006250 <release>
}
    80001cb0:	60e2                	ld	ra,24(sp)
    80001cb2:	6442                	ld	s0,16(sp)
    80001cb4:	64a2                	ld	s1,8(sp)
    80001cb6:	6105                	addi	sp,sp,32
    80001cb8:	8082                	ret

0000000080001cba <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cba:	1101                	addi	sp,sp,-32
    80001cbc:	ec06                	sd	ra,24(sp)
    80001cbe:	e822                	sd	s0,16(sp)
    80001cc0:	e426                	sd	s1,8(sp)
    80001cc2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cc8:	00074d63          	bltz	a4,80001ce2 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ccc:	57fd                	li	a5,-1
    80001cce:	17fe                	slli	a5,a5,0x3f
    80001cd0:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cd2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cd4:	06f70363          	beq	a4,a5,80001d3a <devintr+0x80>
  }
}
    80001cd8:	60e2                	ld	ra,24(sp)
    80001cda:	6442                	ld	s0,16(sp)
    80001cdc:	64a2                	ld	s1,8(sp)
    80001cde:	6105                	addi	sp,sp,32
    80001ce0:	8082                	ret
     (scause & 0xff) == 9){
    80001ce2:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001ce6:	46a5                	li	a3,9
    80001ce8:	fed792e3          	bne	a5,a3,80001ccc <devintr+0x12>
    int irq = plic_claim();
    80001cec:	00003097          	auipc	ra,0x3
    80001cf0:	4ac080e7          	jalr	1196(ra) # 80005198 <plic_claim>
    80001cf4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cf6:	47a9                	li	a5,10
    80001cf8:	02f50763          	beq	a0,a5,80001d26 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cfc:	4785                	li	a5,1
    80001cfe:	02f50963          	beq	a0,a5,80001d30 <devintr+0x76>
    return 1;
    80001d02:	4505                	li	a0,1
    } else if(irq){
    80001d04:	d8f1                	beqz	s1,80001cd8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d06:	85a6                	mv	a1,s1
    80001d08:	00006517          	auipc	a0,0x6
    80001d0c:	57850513          	addi	a0,a0,1400 # 80008280 <states.0+0x38>
    80001d10:	00004097          	auipc	ra,0x4
    80001d14:	f9a080e7          	jalr	-102(ra) # 80005caa <printf>
      plic_complete(irq);
    80001d18:	8526                	mv	a0,s1
    80001d1a:	00003097          	auipc	ra,0x3
    80001d1e:	4a2080e7          	jalr	1186(ra) # 800051bc <plic_complete>
    return 1;
    80001d22:	4505                	li	a0,1
    80001d24:	bf55                	j	80001cd8 <devintr+0x1e>
      uartintr();
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	396080e7          	jalr	918(ra) # 800060bc <uartintr>
    80001d2e:	b7ed                	j	80001d18 <devintr+0x5e>
      virtio_disk_intr();
    80001d30:	00004097          	auipc	ra,0x4
    80001d34:	958080e7          	jalr	-1704(ra) # 80005688 <virtio_disk_intr>
    80001d38:	b7c5                	j	80001d18 <devintr+0x5e>
    if(cpuid() == 0){
    80001d3a:	fffff097          	auipc	ra,0xfffff
    80001d3e:	0e8080e7          	jalr	232(ra) # 80000e22 <cpuid>
    80001d42:	c901                	beqz	a0,80001d52 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d44:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d48:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d4a:	14479073          	csrw	sip,a5
    return 2;
    80001d4e:	4509                	li	a0,2
    80001d50:	b761                	j	80001cd8 <devintr+0x1e>
      clockintr();
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	f22080e7          	jalr	-222(ra) # 80001c74 <clockintr>
    80001d5a:	b7ed                	j	80001d44 <devintr+0x8a>

0000000080001d5c <usertrap>:
{
    80001d5c:	1101                	addi	sp,sp,-32
    80001d5e:	ec06                	sd	ra,24(sp)
    80001d60:	e822                	sd	s0,16(sp)
    80001d62:	e426                	sd	s1,8(sp)
    80001d64:	e04a                	sd	s2,0(sp)
    80001d66:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d68:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d6c:	1007f793          	andi	a5,a5,256
    80001d70:	e3b1                	bnez	a5,80001db4 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d72:	00003797          	auipc	a5,0x3
    80001d76:	31e78793          	addi	a5,a5,798 # 80005090 <kernelvec>
    80001d7a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d7e:	fffff097          	auipc	ra,0xfffff
    80001d82:	0d0080e7          	jalr	208(ra) # 80000e4e <myproc>
    80001d86:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d88:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d8a:	14102773          	csrr	a4,sepc
    80001d8e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d90:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d94:	47a1                	li	a5,8
    80001d96:	02f70763          	beq	a4,a5,80001dc4 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	f20080e7          	jalr	-224(ra) # 80001cba <devintr>
    80001da2:	892a                	mv	s2,a0
    80001da4:	c151                	beqz	a0,80001e28 <usertrap+0xcc>
  if(killed(p))
    80001da6:	8526                	mv	a0,s1
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	ad2080e7          	jalr	-1326(ra) # 8000187a <killed>
    80001db0:	c929                	beqz	a0,80001e02 <usertrap+0xa6>
    80001db2:	a099                	j	80001df8 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001db4:	00006517          	auipc	a0,0x6
    80001db8:	4ec50513          	addi	a0,a0,1260 # 800082a0 <states.0+0x58>
    80001dbc:	00004097          	auipc	ra,0x4
    80001dc0:	ea4080e7          	jalr	-348(ra) # 80005c60 <panic>
    if(killed(p))
    80001dc4:	00000097          	auipc	ra,0x0
    80001dc8:	ab6080e7          	jalr	-1354(ra) # 8000187a <killed>
    80001dcc:	e921                	bnez	a0,80001e1c <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001dce:	6cb8                	ld	a4,88(s1)
    80001dd0:	6f1c                	ld	a5,24(a4)
    80001dd2:	0791                	addi	a5,a5,4
    80001dd4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dda:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dde:	10079073          	csrw	sstatus,a5
    syscall();
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	2d4080e7          	jalr	724(ra) # 800020b6 <syscall>
  if(killed(p))
    80001dea:	8526                	mv	a0,s1
    80001dec:	00000097          	auipc	ra,0x0
    80001df0:	a8e080e7          	jalr	-1394(ra) # 8000187a <killed>
    80001df4:	c911                	beqz	a0,80001e08 <usertrap+0xac>
    80001df6:	4901                	li	s2,0
    exit(-1);
    80001df8:	557d                	li	a0,-1
    80001dfa:	00000097          	auipc	ra,0x0
    80001dfe:	90c080e7          	jalr	-1780(ra) # 80001706 <exit>
  if(which_dev == 2)
    80001e02:	4789                	li	a5,2
    80001e04:	04f90f63          	beq	s2,a5,80001e62 <usertrap+0x106>
  usertrapret();
    80001e08:	00000097          	auipc	ra,0x0
    80001e0c:	dd6080e7          	jalr	-554(ra) # 80001bde <usertrapret>
}
    80001e10:	60e2                	ld	ra,24(sp)
    80001e12:	6442                	ld	s0,16(sp)
    80001e14:	64a2                	ld	s1,8(sp)
    80001e16:	6902                	ld	s2,0(sp)
    80001e18:	6105                	addi	sp,sp,32
    80001e1a:	8082                	ret
      exit(-1);
    80001e1c:	557d                	li	a0,-1
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	8e8080e7          	jalr	-1816(ra) # 80001706 <exit>
    80001e26:	b765                	j	80001dce <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e28:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e2c:	5890                	lw	a2,48(s1)
    80001e2e:	00006517          	auipc	a0,0x6
    80001e32:	49250513          	addi	a0,a0,1170 # 800082c0 <states.0+0x78>
    80001e36:	00004097          	auipc	ra,0x4
    80001e3a:	e74080e7          	jalr	-396(ra) # 80005caa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e3e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e42:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	4aa50513          	addi	a0,a0,1194 # 800082f0 <states.0+0xa8>
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	e5c080e7          	jalr	-420(ra) # 80005caa <printf>
    setkilled(p);
    80001e56:	8526                	mv	a0,s1
    80001e58:	00000097          	auipc	ra,0x0
    80001e5c:	9f6080e7          	jalr	-1546(ra) # 8000184e <setkilled>
    80001e60:	b769                	j	80001dea <usertrap+0x8e>
    yield();
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	734080e7          	jalr	1844(ra) # 80001596 <yield>
    80001e6a:	bf79                	j	80001e08 <usertrap+0xac>

0000000080001e6c <kerneltrap>:
{
    80001e6c:	7179                	addi	sp,sp,-48
    80001e6e:	f406                	sd	ra,40(sp)
    80001e70:	f022                	sd	s0,32(sp)
    80001e72:	ec26                	sd	s1,24(sp)
    80001e74:	e84a                	sd	s2,16(sp)
    80001e76:	e44e                	sd	s3,8(sp)
    80001e78:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e7a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e7e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e82:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e86:	1004f793          	andi	a5,s1,256
    80001e8a:	cb85                	beqz	a5,80001eba <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e90:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e92:	ef85                	bnez	a5,80001eca <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e94:	00000097          	auipc	ra,0x0
    80001e98:	e26080e7          	jalr	-474(ra) # 80001cba <devintr>
    80001e9c:	cd1d                	beqz	a0,80001eda <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e9e:	4789                	li	a5,2
    80001ea0:	06f50a63          	beq	a0,a5,80001f14 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ea4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ea8:	10049073          	csrw	sstatus,s1
}
    80001eac:	70a2                	ld	ra,40(sp)
    80001eae:	7402                	ld	s0,32(sp)
    80001eb0:	64e2                	ld	s1,24(sp)
    80001eb2:	6942                	ld	s2,16(sp)
    80001eb4:	69a2                	ld	s3,8(sp)
    80001eb6:	6145                	addi	sp,sp,48
    80001eb8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001eba:	00006517          	auipc	a0,0x6
    80001ebe:	45650513          	addi	a0,a0,1110 # 80008310 <states.0+0xc8>
    80001ec2:	00004097          	auipc	ra,0x4
    80001ec6:	d9e080e7          	jalr	-610(ra) # 80005c60 <panic>
    panic("kerneltrap: interrupts enabled");
    80001eca:	00006517          	auipc	a0,0x6
    80001ece:	46e50513          	addi	a0,a0,1134 # 80008338 <states.0+0xf0>
    80001ed2:	00004097          	auipc	ra,0x4
    80001ed6:	d8e080e7          	jalr	-626(ra) # 80005c60 <panic>
    printf("scause %p\n", scause);
    80001eda:	85ce                	mv	a1,s3
    80001edc:	00006517          	auipc	a0,0x6
    80001ee0:	47c50513          	addi	a0,a0,1148 # 80008358 <states.0+0x110>
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	dc6080e7          	jalr	-570(ra) # 80005caa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ef0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ef4:	00006517          	auipc	a0,0x6
    80001ef8:	47450513          	addi	a0,a0,1140 # 80008368 <states.0+0x120>
    80001efc:	00004097          	auipc	ra,0x4
    80001f00:	dae080e7          	jalr	-594(ra) # 80005caa <printf>
    panic("kerneltrap");
    80001f04:	00006517          	auipc	a0,0x6
    80001f08:	47c50513          	addi	a0,a0,1148 # 80008380 <states.0+0x138>
    80001f0c:	00004097          	auipc	ra,0x4
    80001f10:	d54080e7          	jalr	-684(ra) # 80005c60 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	f3a080e7          	jalr	-198(ra) # 80000e4e <myproc>
    80001f1c:	d541                	beqz	a0,80001ea4 <kerneltrap+0x38>
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	f30080e7          	jalr	-208(ra) # 80000e4e <myproc>
    80001f26:	4d18                	lw	a4,24(a0)
    80001f28:	4791                	li	a5,4
    80001f2a:	f6f71de3          	bne	a4,a5,80001ea4 <kerneltrap+0x38>
    yield();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	668080e7          	jalr	1640(ra) # 80001596 <yield>
    80001f36:	b7bd                	j	80001ea4 <kerneltrap+0x38>

0000000080001f38 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	1000                	addi	s0,sp,32
    80001f42:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	f0a080e7          	jalr	-246(ra) # 80000e4e <myproc>
  switch (n) {
    80001f4c:	4795                	li	a5,5
    80001f4e:	0497e163          	bltu	a5,s1,80001f90 <argraw+0x58>
    80001f52:	048a                	slli	s1,s1,0x2
    80001f54:	00006717          	auipc	a4,0x6
    80001f58:	46470713          	addi	a4,a4,1124 # 800083b8 <states.0+0x170>
    80001f5c:	94ba                	add	s1,s1,a4
    80001f5e:	409c                	lw	a5,0(s1)
    80001f60:	97ba                	add	a5,a5,a4
    80001f62:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f64:	6d3c                	ld	a5,88(a0)
    80001f66:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f68:	60e2                	ld	ra,24(sp)
    80001f6a:	6442                	ld	s0,16(sp)
    80001f6c:	64a2                	ld	s1,8(sp)
    80001f6e:	6105                	addi	sp,sp,32
    80001f70:	8082                	ret
    return p->trapframe->a1;
    80001f72:	6d3c                	ld	a5,88(a0)
    80001f74:	7fa8                	ld	a0,120(a5)
    80001f76:	bfcd                	j	80001f68 <argraw+0x30>
    return p->trapframe->a2;
    80001f78:	6d3c                	ld	a5,88(a0)
    80001f7a:	63c8                	ld	a0,128(a5)
    80001f7c:	b7f5                	j	80001f68 <argraw+0x30>
    return p->trapframe->a3;
    80001f7e:	6d3c                	ld	a5,88(a0)
    80001f80:	67c8                	ld	a0,136(a5)
    80001f82:	b7dd                	j	80001f68 <argraw+0x30>
    return p->trapframe->a4;
    80001f84:	6d3c                	ld	a5,88(a0)
    80001f86:	6bc8                	ld	a0,144(a5)
    80001f88:	b7c5                	j	80001f68 <argraw+0x30>
    return p->trapframe->a5;
    80001f8a:	6d3c                	ld	a5,88(a0)
    80001f8c:	6fc8                	ld	a0,152(a5)
    80001f8e:	bfe9                	j	80001f68 <argraw+0x30>
  panic("argraw");
    80001f90:	00006517          	auipc	a0,0x6
    80001f94:	40050513          	addi	a0,a0,1024 # 80008390 <states.0+0x148>
    80001f98:	00004097          	auipc	ra,0x4
    80001f9c:	cc8080e7          	jalr	-824(ra) # 80005c60 <panic>

0000000080001fa0 <fetchaddr>:
{
    80001fa0:	1101                	addi	sp,sp,-32
    80001fa2:	ec06                	sd	ra,24(sp)
    80001fa4:	e822                	sd	s0,16(sp)
    80001fa6:	e426                	sd	s1,8(sp)
    80001fa8:	e04a                	sd	s2,0(sp)
    80001faa:	1000                	addi	s0,sp,32
    80001fac:	84aa                	mv	s1,a0
    80001fae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	e9e080e7          	jalr	-354(ra) # 80000e4e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fb8:	653c                	ld	a5,72(a0)
    80001fba:	02f4f863          	bgeu	s1,a5,80001fea <fetchaddr+0x4a>
    80001fbe:	00848713          	addi	a4,s1,8
    80001fc2:	02e7e663          	bltu	a5,a4,80001fee <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fc6:	46a1                	li	a3,8
    80001fc8:	8626                	mv	a2,s1
    80001fca:	85ca                	mv	a1,s2
    80001fcc:	6928                	ld	a0,80(a0)
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	bcc080e7          	jalr	-1076(ra) # 80000b9a <copyin>
    80001fd6:	00a03533          	snez	a0,a0
    80001fda:	40a00533          	neg	a0,a0
}
    80001fde:	60e2                	ld	ra,24(sp)
    80001fe0:	6442                	ld	s0,16(sp)
    80001fe2:	64a2                	ld	s1,8(sp)
    80001fe4:	6902                	ld	s2,0(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret
    return -1;
    80001fea:	557d                	li	a0,-1
    80001fec:	bfcd                	j	80001fde <fetchaddr+0x3e>
    80001fee:	557d                	li	a0,-1
    80001ff0:	b7fd                	j	80001fde <fetchaddr+0x3e>

0000000080001ff2 <fetchstr>:
{
    80001ff2:	7179                	addi	sp,sp,-48
    80001ff4:	f406                	sd	ra,40(sp)
    80001ff6:	f022                	sd	s0,32(sp)
    80001ff8:	ec26                	sd	s1,24(sp)
    80001ffa:	e84a                	sd	s2,16(sp)
    80001ffc:	e44e                	sd	s3,8(sp)
    80001ffe:	1800                	addi	s0,sp,48
    80002000:	892a                	mv	s2,a0
    80002002:	84ae                	mv	s1,a1
    80002004:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	e48080e7          	jalr	-440(ra) # 80000e4e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000200e:	86ce                	mv	a3,s3
    80002010:	864a                	mv	a2,s2
    80002012:	85a6                	mv	a1,s1
    80002014:	6928                	ld	a0,80(a0)
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	c12080e7          	jalr	-1006(ra) # 80000c28 <copyinstr>
    8000201e:	00054e63          	bltz	a0,8000203a <fetchstr+0x48>
  return strlen(buf);
    80002022:	8526                	mv	a0,s1
    80002024:	ffffe097          	auipc	ra,0xffffe
    80002028:	2d0080e7          	jalr	720(ra) # 800002f4 <strlen>
}
    8000202c:	70a2                	ld	ra,40(sp)
    8000202e:	7402                	ld	s0,32(sp)
    80002030:	64e2                	ld	s1,24(sp)
    80002032:	6942                	ld	s2,16(sp)
    80002034:	69a2                	ld	s3,8(sp)
    80002036:	6145                	addi	sp,sp,48
    80002038:	8082                	ret
    return -1;
    8000203a:	557d                	li	a0,-1
    8000203c:	bfc5                	j	8000202c <fetchstr+0x3a>

000000008000203e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000203e:	1101                	addi	sp,sp,-32
    80002040:	ec06                	sd	ra,24(sp)
    80002042:	e822                	sd	s0,16(sp)
    80002044:	e426                	sd	s1,8(sp)
    80002046:	1000                	addi	s0,sp,32
    80002048:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000204a:	00000097          	auipc	ra,0x0
    8000204e:	eee080e7          	jalr	-274(ra) # 80001f38 <argraw>
    80002052:	c088                	sw	a0,0(s1)
}
    80002054:	60e2                	ld	ra,24(sp)
    80002056:	6442                	ld	s0,16(sp)
    80002058:	64a2                	ld	s1,8(sp)
    8000205a:	6105                	addi	sp,sp,32
    8000205c:	8082                	ret

000000008000205e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000205e:	1101                	addi	sp,sp,-32
    80002060:	ec06                	sd	ra,24(sp)
    80002062:	e822                	sd	s0,16(sp)
    80002064:	e426                	sd	s1,8(sp)
    80002066:	1000                	addi	s0,sp,32
    80002068:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000206a:	00000097          	auipc	ra,0x0
    8000206e:	ece080e7          	jalr	-306(ra) # 80001f38 <argraw>
    80002072:	e088                	sd	a0,0(s1)
}
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	64a2                	ld	s1,8(sp)
    8000207a:	6105                	addi	sp,sp,32
    8000207c:	8082                	ret

000000008000207e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000207e:	7179                	addi	sp,sp,-48
    80002080:	f406                	sd	ra,40(sp)
    80002082:	f022                	sd	s0,32(sp)
    80002084:	ec26                	sd	s1,24(sp)
    80002086:	e84a                	sd	s2,16(sp)
    80002088:	1800                	addi	s0,sp,48
    8000208a:	84ae                	mv	s1,a1
    8000208c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000208e:	fd840593          	addi	a1,s0,-40
    80002092:	00000097          	auipc	ra,0x0
    80002096:	fcc080e7          	jalr	-52(ra) # 8000205e <argaddr>
  return fetchstr(addr, buf, max);
    8000209a:	864a                	mv	a2,s2
    8000209c:	85a6                	mv	a1,s1
    8000209e:	fd843503          	ld	a0,-40(s0)
    800020a2:	00000097          	auipc	ra,0x0
    800020a6:	f50080e7          	jalr	-176(ra) # 80001ff2 <fetchstr>
}
    800020aa:	70a2                	ld	ra,40(sp)
    800020ac:	7402                	ld	s0,32(sp)
    800020ae:	64e2                	ld	s1,24(sp)
    800020b0:	6942                	ld	s2,16(sp)
    800020b2:	6145                	addi	sp,sp,48
    800020b4:	8082                	ret

00000000800020b6 <syscall>:



void
syscall(void)
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	e426                	sd	s1,8(sp)
    800020be:	e04a                	sd	s2,0(sp)
    800020c0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	d8c080e7          	jalr	-628(ra) # 80000e4e <myproc>
    800020ca:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020cc:	05853903          	ld	s2,88(a0)
    800020d0:	0a893783          	ld	a5,168(s2)
    800020d4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020d8:	37fd                	addiw	a5,a5,-1
    800020da:	4775                	li	a4,29
    800020dc:	00f76f63          	bltu	a4,a5,800020fa <syscall+0x44>
    800020e0:	00369713          	slli	a4,a3,0x3
    800020e4:	00006797          	auipc	a5,0x6
    800020e8:	2ec78793          	addi	a5,a5,748 # 800083d0 <syscalls>
    800020ec:	97ba                	add	a5,a5,a4
    800020ee:	639c                	ld	a5,0(a5)
    800020f0:	c789                	beqz	a5,800020fa <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020f2:	9782                	jalr	a5
    800020f4:	06a93823          	sd	a0,112(s2)
    800020f8:	a839                	j	80002116 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020fa:	15848613          	addi	a2,s1,344
    800020fe:	588c                	lw	a1,48(s1)
    80002100:	00006517          	auipc	a0,0x6
    80002104:	29850513          	addi	a0,a0,664 # 80008398 <states.0+0x150>
    80002108:	00004097          	auipc	ra,0x4
    8000210c:	ba2080e7          	jalr	-1118(ra) # 80005caa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002110:	6cbc                	ld	a5,88(s1)
    80002112:	577d                	li	a4,-1
    80002114:	fbb8                	sd	a4,112(a5)
  }
}
    80002116:	60e2                	ld	ra,24(sp)
    80002118:	6442                	ld	s0,16(sp)
    8000211a:	64a2                	ld	s1,8(sp)
    8000211c:	6902                	ld	s2,0(sp)
    8000211e:	6105                	addi	sp,sp,32
    80002120:	8082                	ret

0000000080002122 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002122:	1101                	addi	sp,sp,-32
    80002124:	ec06                	sd	ra,24(sp)
    80002126:	e822                	sd	s0,16(sp)
    80002128:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000212a:	fec40593          	addi	a1,s0,-20
    8000212e:	4501                	li	a0,0
    80002130:	00000097          	auipc	ra,0x0
    80002134:	f0e080e7          	jalr	-242(ra) # 8000203e <argint>
  exit(n);
    80002138:	fec42503          	lw	a0,-20(s0)
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	5ca080e7          	jalr	1482(ra) # 80001706 <exit>
  return 0;  // not reached
}
    80002144:	4501                	li	a0,0
    80002146:	60e2                	ld	ra,24(sp)
    80002148:	6442                	ld	s0,16(sp)
    8000214a:	6105                	addi	sp,sp,32
    8000214c:	8082                	ret

000000008000214e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000214e:	1141                	addi	sp,sp,-16
    80002150:	e406                	sd	ra,8(sp)
    80002152:	e022                	sd	s0,0(sp)
    80002154:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	cf8080e7          	jalr	-776(ra) # 80000e4e <myproc>
}
    8000215e:	5908                	lw	a0,48(a0)
    80002160:	60a2                	ld	ra,8(sp)
    80002162:	6402                	ld	s0,0(sp)
    80002164:	0141                	addi	sp,sp,16
    80002166:	8082                	ret

0000000080002168 <sys_fork>:

uint64
sys_fork(void)
{
    80002168:	1141                	addi	sp,sp,-16
    8000216a:	e406                	sd	ra,8(sp)
    8000216c:	e022                	sd	s0,0(sp)
    8000216e:	0800                	addi	s0,sp,16
  return fork();
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	170080e7          	jalr	368(ra) # 800012e0 <fork>
}
    80002178:	60a2                	ld	ra,8(sp)
    8000217a:	6402                	ld	s0,0(sp)
    8000217c:	0141                	addi	sp,sp,16
    8000217e:	8082                	ret

0000000080002180 <sys_wait>:

uint64
sys_wait(void)
{
    80002180:	1101                	addi	sp,sp,-32
    80002182:	ec06                	sd	ra,24(sp)
    80002184:	e822                	sd	s0,16(sp)
    80002186:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002188:	fe840593          	addi	a1,s0,-24
    8000218c:	4501                	li	a0,0
    8000218e:	00000097          	auipc	ra,0x0
    80002192:	ed0080e7          	jalr	-304(ra) # 8000205e <argaddr>
  return wait(p);
    80002196:	fe843503          	ld	a0,-24(s0)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	712080e7          	jalr	1810(ra) # 800018ac <wait>
}
    800021a2:	60e2                	ld	ra,24(sp)
    800021a4:	6442                	ld	s0,16(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret

00000000800021aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021aa:	7179                	addi	sp,sp,-48
    800021ac:	f406                	sd	ra,40(sp)
    800021ae:	f022                	sd	s0,32(sp)
    800021b0:	ec26                	sd	s1,24(sp)
    800021b2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021b4:	fdc40593          	addi	a1,s0,-36
    800021b8:	4501                	li	a0,0
    800021ba:	00000097          	auipc	ra,0x0
    800021be:	e84080e7          	jalr	-380(ra) # 8000203e <argint>
  addr = myproc()->sz;
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	c8c080e7          	jalr	-884(ra) # 80000e4e <myproc>
    800021ca:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021cc:	fdc42503          	lw	a0,-36(s0)
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	0b4080e7          	jalr	180(ra) # 80001284 <growproc>
    800021d8:	00054863          	bltz	a0,800021e8 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021dc:	8526                	mv	a0,s1
    800021de:	70a2                	ld	ra,40(sp)
    800021e0:	7402                	ld	s0,32(sp)
    800021e2:	64e2                	ld	s1,24(sp)
    800021e4:	6145                	addi	sp,sp,48
    800021e6:	8082                	ret
    return -1;
    800021e8:	54fd                	li	s1,-1
    800021ea:	bfcd                	j	800021dc <sys_sbrk+0x32>

00000000800021ec <sys_sleep>:

uint64
sys_sleep(void)
{
    800021ec:	7139                	addi	sp,sp,-64
    800021ee:	fc06                	sd	ra,56(sp)
    800021f0:	f822                	sd	s0,48(sp)
    800021f2:	f426                	sd	s1,40(sp)
    800021f4:	f04a                	sd	s2,32(sp)
    800021f6:	ec4e                	sd	s3,24(sp)
    800021f8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800021fa:	fcc40593          	addi	a1,s0,-52
    800021fe:	4501                	li	a0,0
    80002200:	00000097          	auipc	ra,0x0
    80002204:	e3e080e7          	jalr	-450(ra) # 8000203e <argint>
  acquire(&tickslock);
    80002208:	0000c517          	auipc	a0,0xc
    8000220c:	77850513          	addi	a0,a0,1912 # 8000e980 <tickslock>
    80002210:	00004097          	auipc	ra,0x4
    80002214:	f8c080e7          	jalr	-116(ra) # 8000619c <acquire>
  ticks0 = ticks;
    80002218:	00006917          	auipc	s2,0x6
    8000221c:	70092903          	lw	s2,1792(s2) # 80008918 <ticks>
  while(ticks - ticks0 < n){
    80002220:	fcc42783          	lw	a5,-52(s0)
    80002224:	cf9d                	beqz	a5,80002262 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002226:	0000c997          	auipc	s3,0xc
    8000222a:	75a98993          	addi	s3,s3,1882 # 8000e980 <tickslock>
    8000222e:	00006497          	auipc	s1,0x6
    80002232:	6ea48493          	addi	s1,s1,1770 # 80008918 <ticks>
    if(killed(myproc())){
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	c18080e7          	jalr	-1000(ra) # 80000e4e <myproc>
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	63c080e7          	jalr	1596(ra) # 8000187a <killed>
    80002246:	ed15                	bnez	a0,80002282 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002248:	85ce                	mv	a1,s3
    8000224a:	8526                	mv	a0,s1
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	386080e7          	jalr	902(ra) # 800015d2 <sleep>
  while(ticks - ticks0 < n){
    80002254:	409c                	lw	a5,0(s1)
    80002256:	412787bb          	subw	a5,a5,s2
    8000225a:	fcc42703          	lw	a4,-52(s0)
    8000225e:	fce7ece3          	bltu	a5,a4,80002236 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002262:	0000c517          	auipc	a0,0xc
    80002266:	71e50513          	addi	a0,a0,1822 # 8000e980 <tickslock>
    8000226a:	00004097          	auipc	ra,0x4
    8000226e:	fe6080e7          	jalr	-26(ra) # 80006250 <release>
  return 0;
    80002272:	4501                	li	a0,0
}
    80002274:	70e2                	ld	ra,56(sp)
    80002276:	7442                	ld	s0,48(sp)
    80002278:	74a2                	ld	s1,40(sp)
    8000227a:	7902                	ld	s2,32(sp)
    8000227c:	69e2                	ld	s3,24(sp)
    8000227e:	6121                	addi	sp,sp,64
    80002280:	8082                	ret
      release(&tickslock);
    80002282:	0000c517          	auipc	a0,0xc
    80002286:	6fe50513          	addi	a0,a0,1790 # 8000e980 <tickslock>
    8000228a:	00004097          	auipc	ra,0x4
    8000228e:	fc6080e7          	jalr	-58(ra) # 80006250 <release>
      return -1;
    80002292:	557d                	li	a0,-1
    80002294:	b7c5                	j	80002274 <sys_sleep+0x88>

0000000080002296 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002296:	1141                	addi	sp,sp,-16
    80002298:	e422                	sd	s0,8(sp)
    8000229a:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    8000229c:	4501                	li	a0,0
    8000229e:	6422                	ld	s0,8(sp)
    800022a0:	0141                	addi	sp,sp,16
    800022a2:	8082                	ret

00000000800022a4 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800022a4:	1101                	addi	sp,sp,-32
    800022a6:	ec06                	sd	ra,24(sp)
    800022a8:	e822                	sd	s0,16(sp)
    800022aa:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022ac:	fec40593          	addi	a1,s0,-20
    800022b0:	4501                	li	a0,0
    800022b2:	00000097          	auipc	ra,0x0
    800022b6:	d8c080e7          	jalr	-628(ra) # 8000203e <argint>
  return kill(pid);
    800022ba:	fec42503          	lw	a0,-20(s0)
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	51e080e7          	jalr	1310(ra) # 800017dc <kill>
}
    800022c6:	60e2                	ld	ra,24(sp)
    800022c8:	6442                	ld	s0,16(sp)
    800022ca:	6105                	addi	sp,sp,32
    800022cc:	8082                	ret

00000000800022ce <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022ce:	1101                	addi	sp,sp,-32
    800022d0:	ec06                	sd	ra,24(sp)
    800022d2:	e822                	sd	s0,16(sp)
    800022d4:	e426                	sd	s1,8(sp)
    800022d6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022d8:	0000c517          	auipc	a0,0xc
    800022dc:	6a850513          	addi	a0,a0,1704 # 8000e980 <tickslock>
    800022e0:	00004097          	auipc	ra,0x4
    800022e4:	ebc080e7          	jalr	-324(ra) # 8000619c <acquire>
  xticks = ticks;
    800022e8:	00006497          	auipc	s1,0x6
    800022ec:	6304a483          	lw	s1,1584(s1) # 80008918 <ticks>
  release(&tickslock);
    800022f0:	0000c517          	auipc	a0,0xc
    800022f4:	69050513          	addi	a0,a0,1680 # 8000e980 <tickslock>
    800022f8:	00004097          	auipc	ra,0x4
    800022fc:	f58080e7          	jalr	-168(ra) # 80006250 <release>
  return xticks;
}
    80002300:	02049513          	slli	a0,s1,0x20
    80002304:	9101                	srli	a0,a0,0x20
    80002306:	60e2                	ld	ra,24(sp)
    80002308:	6442                	ld	s0,16(sp)
    8000230a:	64a2                	ld	s1,8(sp)
    8000230c:	6105                	addi	sp,sp,32
    8000230e:	8082                	ret

0000000080002310 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002310:	7179                	addi	sp,sp,-48
    80002312:	f406                	sd	ra,40(sp)
    80002314:	f022                	sd	s0,32(sp)
    80002316:	ec26                	sd	s1,24(sp)
    80002318:	e84a                	sd	s2,16(sp)
    8000231a:	e44e                	sd	s3,8(sp)
    8000231c:	e052                	sd	s4,0(sp)
    8000231e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002320:	00006597          	auipc	a1,0x6
    80002324:	1a858593          	addi	a1,a1,424 # 800084c8 <syscalls+0xf8>
    80002328:	0000c517          	auipc	a0,0xc
    8000232c:	67050513          	addi	a0,a0,1648 # 8000e998 <bcache>
    80002330:	00004097          	auipc	ra,0x4
    80002334:	ddc080e7          	jalr	-548(ra) # 8000610c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002338:	00014797          	auipc	a5,0x14
    8000233c:	66078793          	addi	a5,a5,1632 # 80016998 <bcache+0x8000>
    80002340:	00015717          	auipc	a4,0x15
    80002344:	8c070713          	addi	a4,a4,-1856 # 80016c00 <bcache+0x8268>
    80002348:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000234c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002350:	0000c497          	auipc	s1,0xc
    80002354:	66048493          	addi	s1,s1,1632 # 8000e9b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002358:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000235a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000235c:	00006a17          	auipc	s4,0x6
    80002360:	174a0a13          	addi	s4,s4,372 # 800084d0 <syscalls+0x100>
    b->next = bcache.head.next;
    80002364:	2b893783          	ld	a5,696(s2)
    80002368:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000236a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000236e:	85d2                	mv	a1,s4
    80002370:	01048513          	addi	a0,s1,16
    80002374:	00001097          	auipc	ra,0x1
    80002378:	4c4080e7          	jalr	1220(ra) # 80003838 <initsleeplock>
    bcache.head.next->prev = b;
    8000237c:	2b893783          	ld	a5,696(s2)
    80002380:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002382:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002386:	45848493          	addi	s1,s1,1112
    8000238a:	fd349de3          	bne	s1,s3,80002364 <binit+0x54>
  }
}
    8000238e:	70a2                	ld	ra,40(sp)
    80002390:	7402                	ld	s0,32(sp)
    80002392:	64e2                	ld	s1,24(sp)
    80002394:	6942                	ld	s2,16(sp)
    80002396:	69a2                	ld	s3,8(sp)
    80002398:	6a02                	ld	s4,0(sp)
    8000239a:	6145                	addi	sp,sp,48
    8000239c:	8082                	ret

000000008000239e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000239e:	7179                	addi	sp,sp,-48
    800023a0:	f406                	sd	ra,40(sp)
    800023a2:	f022                	sd	s0,32(sp)
    800023a4:	ec26                	sd	s1,24(sp)
    800023a6:	e84a                	sd	s2,16(sp)
    800023a8:	e44e                	sd	s3,8(sp)
    800023aa:	1800                	addi	s0,sp,48
    800023ac:	892a                	mv	s2,a0
    800023ae:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023b0:	0000c517          	auipc	a0,0xc
    800023b4:	5e850513          	addi	a0,a0,1512 # 8000e998 <bcache>
    800023b8:	00004097          	auipc	ra,0x4
    800023bc:	de4080e7          	jalr	-540(ra) # 8000619c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023c0:	00015497          	auipc	s1,0x15
    800023c4:	8904b483          	ld	s1,-1904(s1) # 80016c50 <bcache+0x82b8>
    800023c8:	00015797          	auipc	a5,0x15
    800023cc:	83878793          	addi	a5,a5,-1992 # 80016c00 <bcache+0x8268>
    800023d0:	02f48f63          	beq	s1,a5,8000240e <bread+0x70>
    800023d4:	873e                	mv	a4,a5
    800023d6:	a021                	j	800023de <bread+0x40>
    800023d8:	68a4                	ld	s1,80(s1)
    800023da:	02e48a63          	beq	s1,a4,8000240e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023de:	449c                	lw	a5,8(s1)
    800023e0:	ff279ce3          	bne	a5,s2,800023d8 <bread+0x3a>
    800023e4:	44dc                	lw	a5,12(s1)
    800023e6:	ff3799e3          	bne	a5,s3,800023d8 <bread+0x3a>
      b->refcnt++;
    800023ea:	40bc                	lw	a5,64(s1)
    800023ec:	2785                	addiw	a5,a5,1
    800023ee:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f0:	0000c517          	auipc	a0,0xc
    800023f4:	5a850513          	addi	a0,a0,1448 # 8000e998 <bcache>
    800023f8:	00004097          	auipc	ra,0x4
    800023fc:	e58080e7          	jalr	-424(ra) # 80006250 <release>
      acquiresleep(&b->lock);
    80002400:	01048513          	addi	a0,s1,16
    80002404:	00001097          	auipc	ra,0x1
    80002408:	46e080e7          	jalr	1134(ra) # 80003872 <acquiresleep>
      return b;
    8000240c:	a8b9                	j	8000246a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000240e:	00015497          	auipc	s1,0x15
    80002412:	83a4b483          	ld	s1,-1990(s1) # 80016c48 <bcache+0x82b0>
    80002416:	00014797          	auipc	a5,0x14
    8000241a:	7ea78793          	addi	a5,a5,2026 # 80016c00 <bcache+0x8268>
    8000241e:	00f48863          	beq	s1,a5,8000242e <bread+0x90>
    80002422:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002424:	40bc                	lw	a5,64(s1)
    80002426:	cf81                	beqz	a5,8000243e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002428:	64a4                	ld	s1,72(s1)
    8000242a:	fee49de3          	bne	s1,a4,80002424 <bread+0x86>
  panic("bget: no buffers");
    8000242e:	00006517          	auipc	a0,0x6
    80002432:	0aa50513          	addi	a0,a0,170 # 800084d8 <syscalls+0x108>
    80002436:	00004097          	auipc	ra,0x4
    8000243a:	82a080e7          	jalr	-2006(ra) # 80005c60 <panic>
      b->dev = dev;
    8000243e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002442:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002446:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000244a:	4785                	li	a5,1
    8000244c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000244e:	0000c517          	auipc	a0,0xc
    80002452:	54a50513          	addi	a0,a0,1354 # 8000e998 <bcache>
    80002456:	00004097          	auipc	ra,0x4
    8000245a:	dfa080e7          	jalr	-518(ra) # 80006250 <release>
      acquiresleep(&b->lock);
    8000245e:	01048513          	addi	a0,s1,16
    80002462:	00001097          	auipc	ra,0x1
    80002466:	410080e7          	jalr	1040(ra) # 80003872 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000246a:	409c                	lw	a5,0(s1)
    8000246c:	cb89                	beqz	a5,8000247e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000246e:	8526                	mv	a0,s1
    80002470:	70a2                	ld	ra,40(sp)
    80002472:	7402                	ld	s0,32(sp)
    80002474:	64e2                	ld	s1,24(sp)
    80002476:	6942                	ld	s2,16(sp)
    80002478:	69a2                	ld	s3,8(sp)
    8000247a:	6145                	addi	sp,sp,48
    8000247c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000247e:	4581                	li	a1,0
    80002480:	8526                	mv	a0,s1
    80002482:	00003097          	auipc	ra,0x3
    80002486:	fd2080e7          	jalr	-46(ra) # 80005454 <virtio_disk_rw>
    b->valid = 1;
    8000248a:	4785                	li	a5,1
    8000248c:	c09c                	sw	a5,0(s1)
  return b;
    8000248e:	b7c5                	j	8000246e <bread+0xd0>

0000000080002490 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002490:	1101                	addi	sp,sp,-32
    80002492:	ec06                	sd	ra,24(sp)
    80002494:	e822                	sd	s0,16(sp)
    80002496:	e426                	sd	s1,8(sp)
    80002498:	1000                	addi	s0,sp,32
    8000249a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000249c:	0541                	addi	a0,a0,16
    8000249e:	00001097          	auipc	ra,0x1
    800024a2:	46e080e7          	jalr	1134(ra) # 8000390c <holdingsleep>
    800024a6:	cd01                	beqz	a0,800024be <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024a8:	4585                	li	a1,1
    800024aa:	8526                	mv	a0,s1
    800024ac:	00003097          	auipc	ra,0x3
    800024b0:	fa8080e7          	jalr	-88(ra) # 80005454 <virtio_disk_rw>
}
    800024b4:	60e2                	ld	ra,24(sp)
    800024b6:	6442                	ld	s0,16(sp)
    800024b8:	64a2                	ld	s1,8(sp)
    800024ba:	6105                	addi	sp,sp,32
    800024bc:	8082                	ret
    panic("bwrite");
    800024be:	00006517          	auipc	a0,0x6
    800024c2:	03250513          	addi	a0,a0,50 # 800084f0 <syscalls+0x120>
    800024c6:	00003097          	auipc	ra,0x3
    800024ca:	79a080e7          	jalr	1946(ra) # 80005c60 <panic>

00000000800024ce <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024ce:	1101                	addi	sp,sp,-32
    800024d0:	ec06                	sd	ra,24(sp)
    800024d2:	e822                	sd	s0,16(sp)
    800024d4:	e426                	sd	s1,8(sp)
    800024d6:	e04a                	sd	s2,0(sp)
    800024d8:	1000                	addi	s0,sp,32
    800024da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024dc:	01050913          	addi	s2,a0,16
    800024e0:	854a                	mv	a0,s2
    800024e2:	00001097          	auipc	ra,0x1
    800024e6:	42a080e7          	jalr	1066(ra) # 8000390c <holdingsleep>
    800024ea:	c92d                	beqz	a0,8000255c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024ec:	854a                	mv	a0,s2
    800024ee:	00001097          	auipc	ra,0x1
    800024f2:	3da080e7          	jalr	986(ra) # 800038c8 <releasesleep>

  acquire(&bcache.lock);
    800024f6:	0000c517          	auipc	a0,0xc
    800024fa:	4a250513          	addi	a0,a0,1186 # 8000e998 <bcache>
    800024fe:	00004097          	auipc	ra,0x4
    80002502:	c9e080e7          	jalr	-866(ra) # 8000619c <acquire>
  b->refcnt--;
    80002506:	40bc                	lw	a5,64(s1)
    80002508:	37fd                	addiw	a5,a5,-1
    8000250a:	0007871b          	sext.w	a4,a5
    8000250e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002510:	eb05                	bnez	a4,80002540 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002512:	68bc                	ld	a5,80(s1)
    80002514:	64b8                	ld	a4,72(s1)
    80002516:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002518:	64bc                	ld	a5,72(s1)
    8000251a:	68b8                	ld	a4,80(s1)
    8000251c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000251e:	00014797          	auipc	a5,0x14
    80002522:	47a78793          	addi	a5,a5,1146 # 80016998 <bcache+0x8000>
    80002526:	2b87b703          	ld	a4,696(a5)
    8000252a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000252c:	00014717          	auipc	a4,0x14
    80002530:	6d470713          	addi	a4,a4,1748 # 80016c00 <bcache+0x8268>
    80002534:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002536:	2b87b703          	ld	a4,696(a5)
    8000253a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000253c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002540:	0000c517          	auipc	a0,0xc
    80002544:	45850513          	addi	a0,a0,1112 # 8000e998 <bcache>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	d08080e7          	jalr	-760(ra) # 80006250 <release>
}
    80002550:	60e2                	ld	ra,24(sp)
    80002552:	6442                	ld	s0,16(sp)
    80002554:	64a2                	ld	s1,8(sp)
    80002556:	6902                	ld	s2,0(sp)
    80002558:	6105                	addi	sp,sp,32
    8000255a:	8082                	ret
    panic("brelse");
    8000255c:	00006517          	auipc	a0,0x6
    80002560:	f9c50513          	addi	a0,a0,-100 # 800084f8 <syscalls+0x128>
    80002564:	00003097          	auipc	ra,0x3
    80002568:	6fc080e7          	jalr	1788(ra) # 80005c60 <panic>

000000008000256c <bpin>:

void
bpin(struct buf *b) {
    8000256c:	1101                	addi	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	e426                	sd	s1,8(sp)
    80002574:	1000                	addi	s0,sp,32
    80002576:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002578:	0000c517          	auipc	a0,0xc
    8000257c:	42050513          	addi	a0,a0,1056 # 8000e998 <bcache>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	c1c080e7          	jalr	-996(ra) # 8000619c <acquire>
  b->refcnt++;
    80002588:	40bc                	lw	a5,64(s1)
    8000258a:	2785                	addiw	a5,a5,1
    8000258c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000258e:	0000c517          	auipc	a0,0xc
    80002592:	40a50513          	addi	a0,a0,1034 # 8000e998 <bcache>
    80002596:	00004097          	auipc	ra,0x4
    8000259a:	cba080e7          	jalr	-838(ra) # 80006250 <release>
}
    8000259e:	60e2                	ld	ra,24(sp)
    800025a0:	6442                	ld	s0,16(sp)
    800025a2:	64a2                	ld	s1,8(sp)
    800025a4:	6105                	addi	sp,sp,32
    800025a6:	8082                	ret

00000000800025a8 <bunpin>:

void
bunpin(struct buf *b) {
    800025a8:	1101                	addi	sp,sp,-32
    800025aa:	ec06                	sd	ra,24(sp)
    800025ac:	e822                	sd	s0,16(sp)
    800025ae:	e426                	sd	s1,8(sp)
    800025b0:	1000                	addi	s0,sp,32
    800025b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b4:	0000c517          	auipc	a0,0xc
    800025b8:	3e450513          	addi	a0,a0,996 # 8000e998 <bcache>
    800025bc:	00004097          	auipc	ra,0x4
    800025c0:	be0080e7          	jalr	-1056(ra) # 8000619c <acquire>
  b->refcnt--;
    800025c4:	40bc                	lw	a5,64(s1)
    800025c6:	37fd                	addiw	a5,a5,-1
    800025c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ca:	0000c517          	auipc	a0,0xc
    800025ce:	3ce50513          	addi	a0,a0,974 # 8000e998 <bcache>
    800025d2:	00004097          	auipc	ra,0x4
    800025d6:	c7e080e7          	jalr	-898(ra) # 80006250 <release>
}
    800025da:	60e2                	ld	ra,24(sp)
    800025dc:	6442                	ld	s0,16(sp)
    800025de:	64a2                	ld	s1,8(sp)
    800025e0:	6105                	addi	sp,sp,32
    800025e2:	8082                	ret

00000000800025e4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025e4:	1101                	addi	sp,sp,-32
    800025e6:	ec06                	sd	ra,24(sp)
    800025e8:	e822                	sd	s0,16(sp)
    800025ea:	e426                	sd	s1,8(sp)
    800025ec:	e04a                	sd	s2,0(sp)
    800025ee:	1000                	addi	s0,sp,32
    800025f0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025f2:	00d5d59b          	srliw	a1,a1,0xd
    800025f6:	00015797          	auipc	a5,0x15
    800025fa:	a7e7a783          	lw	a5,-1410(a5) # 80017074 <sb+0x1c>
    800025fe:	9dbd                	addw	a1,a1,a5
    80002600:	00000097          	auipc	ra,0x0
    80002604:	d9e080e7          	jalr	-610(ra) # 8000239e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002608:	0074f713          	andi	a4,s1,7
    8000260c:	4785                	li	a5,1
    8000260e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002612:	14ce                	slli	s1,s1,0x33
    80002614:	90d9                	srli	s1,s1,0x36
    80002616:	00950733          	add	a4,a0,s1
    8000261a:	05874703          	lbu	a4,88(a4)
    8000261e:	00e7f6b3          	and	a3,a5,a4
    80002622:	c69d                	beqz	a3,80002650 <bfree+0x6c>
    80002624:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002626:	94aa                	add	s1,s1,a0
    80002628:	fff7c793          	not	a5,a5
    8000262c:	8ff9                	and	a5,a5,a4
    8000262e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002632:	00001097          	auipc	ra,0x1
    80002636:	120080e7          	jalr	288(ra) # 80003752 <log_write>
  brelse(bp);
    8000263a:	854a                	mv	a0,s2
    8000263c:	00000097          	auipc	ra,0x0
    80002640:	e92080e7          	jalr	-366(ra) # 800024ce <brelse>
}
    80002644:	60e2                	ld	ra,24(sp)
    80002646:	6442                	ld	s0,16(sp)
    80002648:	64a2                	ld	s1,8(sp)
    8000264a:	6902                	ld	s2,0(sp)
    8000264c:	6105                	addi	sp,sp,32
    8000264e:	8082                	ret
    panic("freeing free block");
    80002650:	00006517          	auipc	a0,0x6
    80002654:	eb050513          	addi	a0,a0,-336 # 80008500 <syscalls+0x130>
    80002658:	00003097          	auipc	ra,0x3
    8000265c:	608080e7          	jalr	1544(ra) # 80005c60 <panic>

0000000080002660 <balloc>:
{
    80002660:	711d                	addi	sp,sp,-96
    80002662:	ec86                	sd	ra,88(sp)
    80002664:	e8a2                	sd	s0,80(sp)
    80002666:	e4a6                	sd	s1,72(sp)
    80002668:	e0ca                	sd	s2,64(sp)
    8000266a:	fc4e                	sd	s3,56(sp)
    8000266c:	f852                	sd	s4,48(sp)
    8000266e:	f456                	sd	s5,40(sp)
    80002670:	f05a                	sd	s6,32(sp)
    80002672:	ec5e                	sd	s7,24(sp)
    80002674:	e862                	sd	s8,16(sp)
    80002676:	e466                	sd	s9,8(sp)
    80002678:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000267a:	00015797          	auipc	a5,0x15
    8000267e:	9e27a783          	lw	a5,-1566(a5) # 8001705c <sb+0x4>
    80002682:	10078163          	beqz	a5,80002784 <balloc+0x124>
    80002686:	8baa                	mv	s7,a0
    80002688:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000268a:	00015b17          	auipc	s6,0x15
    8000268e:	9ceb0b13          	addi	s6,s6,-1586 # 80017058 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002692:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002694:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002696:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002698:	6c89                	lui	s9,0x2
    8000269a:	a061                	j	80002722 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000269c:	974a                	add	a4,a4,s2
    8000269e:	8fd5                	or	a5,a5,a3
    800026a0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026a4:	854a                	mv	a0,s2
    800026a6:	00001097          	auipc	ra,0x1
    800026aa:	0ac080e7          	jalr	172(ra) # 80003752 <log_write>
        brelse(bp);
    800026ae:	854a                	mv	a0,s2
    800026b0:	00000097          	auipc	ra,0x0
    800026b4:	e1e080e7          	jalr	-482(ra) # 800024ce <brelse>
  bp = bread(dev, bno);
    800026b8:	85a6                	mv	a1,s1
    800026ba:	855e                	mv	a0,s7
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	ce2080e7          	jalr	-798(ra) # 8000239e <bread>
    800026c4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026c6:	40000613          	li	a2,1024
    800026ca:	4581                	li	a1,0
    800026cc:	05850513          	addi	a0,a0,88
    800026d0:	ffffe097          	auipc	ra,0xffffe
    800026d4:	aa8080e7          	jalr	-1368(ra) # 80000178 <memset>
  log_write(bp);
    800026d8:	854a                	mv	a0,s2
    800026da:	00001097          	auipc	ra,0x1
    800026de:	078080e7          	jalr	120(ra) # 80003752 <log_write>
  brelse(bp);
    800026e2:	854a                	mv	a0,s2
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	dea080e7          	jalr	-534(ra) # 800024ce <brelse>
}
    800026ec:	8526                	mv	a0,s1
    800026ee:	60e6                	ld	ra,88(sp)
    800026f0:	6446                	ld	s0,80(sp)
    800026f2:	64a6                	ld	s1,72(sp)
    800026f4:	6906                	ld	s2,64(sp)
    800026f6:	79e2                	ld	s3,56(sp)
    800026f8:	7a42                	ld	s4,48(sp)
    800026fa:	7aa2                	ld	s5,40(sp)
    800026fc:	7b02                	ld	s6,32(sp)
    800026fe:	6be2                	ld	s7,24(sp)
    80002700:	6c42                	ld	s8,16(sp)
    80002702:	6ca2                	ld	s9,8(sp)
    80002704:	6125                	addi	sp,sp,96
    80002706:	8082                	ret
    brelse(bp);
    80002708:	854a                	mv	a0,s2
    8000270a:	00000097          	auipc	ra,0x0
    8000270e:	dc4080e7          	jalr	-572(ra) # 800024ce <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002712:	015c87bb          	addw	a5,s9,s5
    80002716:	00078a9b          	sext.w	s5,a5
    8000271a:	004b2703          	lw	a4,4(s6)
    8000271e:	06eaf363          	bgeu	s5,a4,80002784 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002722:	41fad79b          	sraiw	a5,s5,0x1f
    80002726:	0137d79b          	srliw	a5,a5,0x13
    8000272a:	015787bb          	addw	a5,a5,s5
    8000272e:	40d7d79b          	sraiw	a5,a5,0xd
    80002732:	01cb2583          	lw	a1,28(s6)
    80002736:	9dbd                	addw	a1,a1,a5
    80002738:	855e                	mv	a0,s7
    8000273a:	00000097          	auipc	ra,0x0
    8000273e:	c64080e7          	jalr	-924(ra) # 8000239e <bread>
    80002742:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002744:	004b2503          	lw	a0,4(s6)
    80002748:	000a849b          	sext.w	s1,s5
    8000274c:	8662                	mv	a2,s8
    8000274e:	faa4fde3          	bgeu	s1,a0,80002708 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002752:	41f6579b          	sraiw	a5,a2,0x1f
    80002756:	01d7d69b          	srliw	a3,a5,0x1d
    8000275a:	00c6873b          	addw	a4,a3,a2
    8000275e:	00777793          	andi	a5,a4,7
    80002762:	9f95                	subw	a5,a5,a3
    80002764:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002768:	4037571b          	sraiw	a4,a4,0x3
    8000276c:	00e906b3          	add	a3,s2,a4
    80002770:	0586c683          	lbu	a3,88(a3)
    80002774:	00d7f5b3          	and	a1,a5,a3
    80002778:	d195                	beqz	a1,8000269c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000277a:	2605                	addiw	a2,a2,1
    8000277c:	2485                	addiw	s1,s1,1
    8000277e:	fd4618e3          	bne	a2,s4,8000274e <balloc+0xee>
    80002782:	b759                	j	80002708 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002784:	00006517          	auipc	a0,0x6
    80002788:	d9450513          	addi	a0,a0,-620 # 80008518 <syscalls+0x148>
    8000278c:	00003097          	auipc	ra,0x3
    80002790:	51e080e7          	jalr	1310(ra) # 80005caa <printf>
  return 0;
    80002794:	4481                	li	s1,0
    80002796:	bf99                	j	800026ec <balloc+0x8c>

0000000080002798 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002798:	7179                	addi	sp,sp,-48
    8000279a:	f406                	sd	ra,40(sp)
    8000279c:	f022                	sd	s0,32(sp)
    8000279e:	ec26                	sd	s1,24(sp)
    800027a0:	e84a                	sd	s2,16(sp)
    800027a2:	e44e                	sd	s3,8(sp)
    800027a4:	e052                	sd	s4,0(sp)
    800027a6:	1800                	addi	s0,sp,48
    800027a8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027aa:	47ad                	li	a5,11
    800027ac:	02b7e763          	bltu	a5,a1,800027da <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800027b0:	02059493          	slli	s1,a1,0x20
    800027b4:	9081                	srli	s1,s1,0x20
    800027b6:	048a                	slli	s1,s1,0x2
    800027b8:	94aa                	add	s1,s1,a0
    800027ba:	0504a903          	lw	s2,80(s1)
    800027be:	06091e63          	bnez	s2,8000283a <bmap+0xa2>
      addr = balloc(ip->dev);
    800027c2:	4108                	lw	a0,0(a0)
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	e9c080e7          	jalr	-356(ra) # 80002660 <balloc>
    800027cc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027d0:	06090563          	beqz	s2,8000283a <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800027d4:	0524a823          	sw	s2,80(s1)
    800027d8:	a08d                	j	8000283a <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027da:	ff45849b          	addiw	s1,a1,-12
    800027de:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027e2:	0ff00793          	li	a5,255
    800027e6:	08e7e563          	bltu	a5,a4,80002870 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027ea:	08052903          	lw	s2,128(a0)
    800027ee:	00091d63          	bnez	s2,80002808 <bmap+0x70>
      addr = balloc(ip->dev);
    800027f2:	4108                	lw	a0,0(a0)
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	e6c080e7          	jalr	-404(ra) # 80002660 <balloc>
    800027fc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002800:	02090d63          	beqz	s2,8000283a <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002804:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002808:	85ca                	mv	a1,s2
    8000280a:	0009a503          	lw	a0,0(s3)
    8000280e:	00000097          	auipc	ra,0x0
    80002812:	b90080e7          	jalr	-1136(ra) # 8000239e <bread>
    80002816:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002818:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000281c:	02049593          	slli	a1,s1,0x20
    80002820:	9181                	srli	a1,a1,0x20
    80002822:	058a                	slli	a1,a1,0x2
    80002824:	00b784b3          	add	s1,a5,a1
    80002828:	0004a903          	lw	s2,0(s1)
    8000282c:	02090063          	beqz	s2,8000284c <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002830:	8552                	mv	a0,s4
    80002832:	00000097          	auipc	ra,0x0
    80002836:	c9c080e7          	jalr	-868(ra) # 800024ce <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000283a:	854a                	mv	a0,s2
    8000283c:	70a2                	ld	ra,40(sp)
    8000283e:	7402                	ld	s0,32(sp)
    80002840:	64e2                	ld	s1,24(sp)
    80002842:	6942                	ld	s2,16(sp)
    80002844:	69a2                	ld	s3,8(sp)
    80002846:	6a02                	ld	s4,0(sp)
    80002848:	6145                	addi	sp,sp,48
    8000284a:	8082                	ret
      addr = balloc(ip->dev);
    8000284c:	0009a503          	lw	a0,0(s3)
    80002850:	00000097          	auipc	ra,0x0
    80002854:	e10080e7          	jalr	-496(ra) # 80002660 <balloc>
    80002858:	0005091b          	sext.w	s2,a0
      if(addr){
    8000285c:	fc090ae3          	beqz	s2,80002830 <bmap+0x98>
        a[bn] = addr;
    80002860:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002864:	8552                	mv	a0,s4
    80002866:	00001097          	auipc	ra,0x1
    8000286a:	eec080e7          	jalr	-276(ra) # 80003752 <log_write>
    8000286e:	b7c9                	j	80002830 <bmap+0x98>
  panic("bmap: out of range");
    80002870:	00006517          	auipc	a0,0x6
    80002874:	cc050513          	addi	a0,a0,-832 # 80008530 <syscalls+0x160>
    80002878:	00003097          	auipc	ra,0x3
    8000287c:	3e8080e7          	jalr	1000(ra) # 80005c60 <panic>

0000000080002880 <iget>:
{
    80002880:	7179                	addi	sp,sp,-48
    80002882:	f406                	sd	ra,40(sp)
    80002884:	f022                	sd	s0,32(sp)
    80002886:	ec26                	sd	s1,24(sp)
    80002888:	e84a                	sd	s2,16(sp)
    8000288a:	e44e                	sd	s3,8(sp)
    8000288c:	e052                	sd	s4,0(sp)
    8000288e:	1800                	addi	s0,sp,48
    80002890:	89aa                	mv	s3,a0
    80002892:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002894:	00014517          	auipc	a0,0x14
    80002898:	7e450513          	addi	a0,a0,2020 # 80017078 <itable>
    8000289c:	00004097          	auipc	ra,0x4
    800028a0:	900080e7          	jalr	-1792(ra) # 8000619c <acquire>
  empty = 0;
    800028a4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028a6:	00014497          	auipc	s1,0x14
    800028aa:	7ea48493          	addi	s1,s1,2026 # 80017090 <itable+0x18>
    800028ae:	00016697          	auipc	a3,0x16
    800028b2:	27268693          	addi	a3,a3,626 # 80018b20 <log>
    800028b6:	a039                	j	800028c4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028b8:	02090b63          	beqz	s2,800028ee <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028bc:	08848493          	addi	s1,s1,136
    800028c0:	02d48a63          	beq	s1,a3,800028f4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028c4:	449c                	lw	a5,8(s1)
    800028c6:	fef059e3          	blez	a5,800028b8 <iget+0x38>
    800028ca:	4098                	lw	a4,0(s1)
    800028cc:	ff3716e3          	bne	a4,s3,800028b8 <iget+0x38>
    800028d0:	40d8                	lw	a4,4(s1)
    800028d2:	ff4713e3          	bne	a4,s4,800028b8 <iget+0x38>
      ip->ref++;
    800028d6:	2785                	addiw	a5,a5,1
    800028d8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028da:	00014517          	auipc	a0,0x14
    800028de:	79e50513          	addi	a0,a0,1950 # 80017078 <itable>
    800028e2:	00004097          	auipc	ra,0x4
    800028e6:	96e080e7          	jalr	-1682(ra) # 80006250 <release>
      return ip;
    800028ea:	8926                	mv	s2,s1
    800028ec:	a03d                	j	8000291a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ee:	f7f9                	bnez	a5,800028bc <iget+0x3c>
    800028f0:	8926                	mv	s2,s1
    800028f2:	b7e9                	j	800028bc <iget+0x3c>
  if(empty == 0)
    800028f4:	02090c63          	beqz	s2,8000292c <iget+0xac>
  ip->dev = dev;
    800028f8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028fc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002900:	4785                	li	a5,1
    80002902:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002906:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000290a:	00014517          	auipc	a0,0x14
    8000290e:	76e50513          	addi	a0,a0,1902 # 80017078 <itable>
    80002912:	00004097          	auipc	ra,0x4
    80002916:	93e080e7          	jalr	-1730(ra) # 80006250 <release>
}
    8000291a:	854a                	mv	a0,s2
    8000291c:	70a2                	ld	ra,40(sp)
    8000291e:	7402                	ld	s0,32(sp)
    80002920:	64e2                	ld	s1,24(sp)
    80002922:	6942                	ld	s2,16(sp)
    80002924:	69a2                	ld	s3,8(sp)
    80002926:	6a02                	ld	s4,0(sp)
    80002928:	6145                	addi	sp,sp,48
    8000292a:	8082                	ret
    panic("iget: no inodes");
    8000292c:	00006517          	auipc	a0,0x6
    80002930:	c1c50513          	addi	a0,a0,-996 # 80008548 <syscalls+0x178>
    80002934:	00003097          	auipc	ra,0x3
    80002938:	32c080e7          	jalr	812(ra) # 80005c60 <panic>

000000008000293c <fsinit>:
fsinit(int dev) {
    8000293c:	7179                	addi	sp,sp,-48
    8000293e:	f406                	sd	ra,40(sp)
    80002940:	f022                	sd	s0,32(sp)
    80002942:	ec26                	sd	s1,24(sp)
    80002944:	e84a                	sd	s2,16(sp)
    80002946:	e44e                	sd	s3,8(sp)
    80002948:	1800                	addi	s0,sp,48
    8000294a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000294c:	4585                	li	a1,1
    8000294e:	00000097          	auipc	ra,0x0
    80002952:	a50080e7          	jalr	-1456(ra) # 8000239e <bread>
    80002956:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002958:	00014997          	auipc	s3,0x14
    8000295c:	70098993          	addi	s3,s3,1792 # 80017058 <sb>
    80002960:	02000613          	li	a2,32
    80002964:	05850593          	addi	a1,a0,88
    80002968:	854e                	mv	a0,s3
    8000296a:	ffffe097          	auipc	ra,0xffffe
    8000296e:	86a080e7          	jalr	-1942(ra) # 800001d4 <memmove>
  brelse(bp);
    80002972:	8526                	mv	a0,s1
    80002974:	00000097          	auipc	ra,0x0
    80002978:	b5a080e7          	jalr	-1190(ra) # 800024ce <brelse>
  if(sb.magic != FSMAGIC)
    8000297c:	0009a703          	lw	a4,0(s3)
    80002980:	102037b7          	lui	a5,0x10203
    80002984:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002988:	02f71263          	bne	a4,a5,800029ac <fsinit+0x70>
  initlog(dev, &sb);
    8000298c:	00014597          	auipc	a1,0x14
    80002990:	6cc58593          	addi	a1,a1,1740 # 80017058 <sb>
    80002994:	854a                	mv	a0,s2
    80002996:	00001097          	auipc	ra,0x1
    8000299a:	b40080e7          	jalr	-1216(ra) # 800034d6 <initlog>
}
    8000299e:	70a2                	ld	ra,40(sp)
    800029a0:	7402                	ld	s0,32(sp)
    800029a2:	64e2                	ld	s1,24(sp)
    800029a4:	6942                	ld	s2,16(sp)
    800029a6:	69a2                	ld	s3,8(sp)
    800029a8:	6145                	addi	sp,sp,48
    800029aa:	8082                	ret
    panic("invalid file system");
    800029ac:	00006517          	auipc	a0,0x6
    800029b0:	bac50513          	addi	a0,a0,-1108 # 80008558 <syscalls+0x188>
    800029b4:	00003097          	auipc	ra,0x3
    800029b8:	2ac080e7          	jalr	684(ra) # 80005c60 <panic>

00000000800029bc <iinit>:
{
    800029bc:	7179                	addi	sp,sp,-48
    800029be:	f406                	sd	ra,40(sp)
    800029c0:	f022                	sd	s0,32(sp)
    800029c2:	ec26                	sd	s1,24(sp)
    800029c4:	e84a                	sd	s2,16(sp)
    800029c6:	e44e                	sd	s3,8(sp)
    800029c8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029ca:	00006597          	auipc	a1,0x6
    800029ce:	ba658593          	addi	a1,a1,-1114 # 80008570 <syscalls+0x1a0>
    800029d2:	00014517          	auipc	a0,0x14
    800029d6:	6a650513          	addi	a0,a0,1702 # 80017078 <itable>
    800029da:	00003097          	auipc	ra,0x3
    800029de:	732080e7          	jalr	1842(ra) # 8000610c <initlock>
  for(i = 0; i < NINODE; i++) {
    800029e2:	00014497          	auipc	s1,0x14
    800029e6:	6be48493          	addi	s1,s1,1726 # 800170a0 <itable+0x28>
    800029ea:	00016997          	auipc	s3,0x16
    800029ee:	14698993          	addi	s3,s3,326 # 80018b30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029f2:	00006917          	auipc	s2,0x6
    800029f6:	b8690913          	addi	s2,s2,-1146 # 80008578 <syscalls+0x1a8>
    800029fa:	85ca                	mv	a1,s2
    800029fc:	8526                	mv	a0,s1
    800029fe:	00001097          	auipc	ra,0x1
    80002a02:	e3a080e7          	jalr	-454(ra) # 80003838 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a06:	08848493          	addi	s1,s1,136
    80002a0a:	ff3498e3          	bne	s1,s3,800029fa <iinit+0x3e>
}
    80002a0e:	70a2                	ld	ra,40(sp)
    80002a10:	7402                	ld	s0,32(sp)
    80002a12:	64e2                	ld	s1,24(sp)
    80002a14:	6942                	ld	s2,16(sp)
    80002a16:	69a2                	ld	s3,8(sp)
    80002a18:	6145                	addi	sp,sp,48
    80002a1a:	8082                	ret

0000000080002a1c <ialloc>:
{
    80002a1c:	715d                	addi	sp,sp,-80
    80002a1e:	e486                	sd	ra,72(sp)
    80002a20:	e0a2                	sd	s0,64(sp)
    80002a22:	fc26                	sd	s1,56(sp)
    80002a24:	f84a                	sd	s2,48(sp)
    80002a26:	f44e                	sd	s3,40(sp)
    80002a28:	f052                	sd	s4,32(sp)
    80002a2a:	ec56                	sd	s5,24(sp)
    80002a2c:	e85a                	sd	s6,16(sp)
    80002a2e:	e45e                	sd	s7,8(sp)
    80002a30:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a32:	00014717          	auipc	a4,0x14
    80002a36:	63272703          	lw	a4,1586(a4) # 80017064 <sb+0xc>
    80002a3a:	4785                	li	a5,1
    80002a3c:	04e7fa63          	bgeu	a5,a4,80002a90 <ialloc+0x74>
    80002a40:	8aaa                	mv	s5,a0
    80002a42:	8bae                	mv	s7,a1
    80002a44:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a46:	00014a17          	auipc	s4,0x14
    80002a4a:	612a0a13          	addi	s4,s4,1554 # 80017058 <sb>
    80002a4e:	00048b1b          	sext.w	s6,s1
    80002a52:	0044d793          	srli	a5,s1,0x4
    80002a56:	018a2583          	lw	a1,24(s4)
    80002a5a:	9dbd                	addw	a1,a1,a5
    80002a5c:	8556                	mv	a0,s5
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	940080e7          	jalr	-1728(ra) # 8000239e <bread>
    80002a66:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a68:	05850993          	addi	s3,a0,88
    80002a6c:	00f4f793          	andi	a5,s1,15
    80002a70:	079a                	slli	a5,a5,0x6
    80002a72:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a74:	00099783          	lh	a5,0(s3)
    80002a78:	c3a1                	beqz	a5,80002ab8 <ialloc+0x9c>
    brelse(bp);
    80002a7a:	00000097          	auipc	ra,0x0
    80002a7e:	a54080e7          	jalr	-1452(ra) # 800024ce <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a82:	0485                	addi	s1,s1,1
    80002a84:	00ca2703          	lw	a4,12(s4)
    80002a88:	0004879b          	sext.w	a5,s1
    80002a8c:	fce7e1e3          	bltu	a5,a4,80002a4e <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a90:	00006517          	auipc	a0,0x6
    80002a94:	af050513          	addi	a0,a0,-1296 # 80008580 <syscalls+0x1b0>
    80002a98:	00003097          	auipc	ra,0x3
    80002a9c:	212080e7          	jalr	530(ra) # 80005caa <printf>
  return 0;
    80002aa0:	4501                	li	a0,0
}
    80002aa2:	60a6                	ld	ra,72(sp)
    80002aa4:	6406                	ld	s0,64(sp)
    80002aa6:	74e2                	ld	s1,56(sp)
    80002aa8:	7942                	ld	s2,48(sp)
    80002aaa:	79a2                	ld	s3,40(sp)
    80002aac:	7a02                	ld	s4,32(sp)
    80002aae:	6ae2                	ld	s5,24(sp)
    80002ab0:	6b42                	ld	s6,16(sp)
    80002ab2:	6ba2                	ld	s7,8(sp)
    80002ab4:	6161                	addi	sp,sp,80
    80002ab6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ab8:	04000613          	li	a2,64
    80002abc:	4581                	li	a1,0
    80002abe:	854e                	mv	a0,s3
    80002ac0:	ffffd097          	auipc	ra,0xffffd
    80002ac4:	6b8080e7          	jalr	1720(ra) # 80000178 <memset>
      dip->type = type;
    80002ac8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002acc:	854a                	mv	a0,s2
    80002ace:	00001097          	auipc	ra,0x1
    80002ad2:	c84080e7          	jalr	-892(ra) # 80003752 <log_write>
      brelse(bp);
    80002ad6:	854a                	mv	a0,s2
    80002ad8:	00000097          	auipc	ra,0x0
    80002adc:	9f6080e7          	jalr	-1546(ra) # 800024ce <brelse>
      return iget(dev, inum);
    80002ae0:	85da                	mv	a1,s6
    80002ae2:	8556                	mv	a0,s5
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	d9c080e7          	jalr	-612(ra) # 80002880 <iget>
    80002aec:	bf5d                	j	80002aa2 <ialloc+0x86>

0000000080002aee <iupdate>:
{
    80002aee:	1101                	addi	sp,sp,-32
    80002af0:	ec06                	sd	ra,24(sp)
    80002af2:	e822                	sd	s0,16(sp)
    80002af4:	e426                	sd	s1,8(sp)
    80002af6:	e04a                	sd	s2,0(sp)
    80002af8:	1000                	addi	s0,sp,32
    80002afa:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002afc:	415c                	lw	a5,4(a0)
    80002afe:	0047d79b          	srliw	a5,a5,0x4
    80002b02:	00014597          	auipc	a1,0x14
    80002b06:	56e5a583          	lw	a1,1390(a1) # 80017070 <sb+0x18>
    80002b0a:	9dbd                	addw	a1,a1,a5
    80002b0c:	4108                	lw	a0,0(a0)
    80002b0e:	00000097          	auipc	ra,0x0
    80002b12:	890080e7          	jalr	-1904(ra) # 8000239e <bread>
    80002b16:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b18:	05850793          	addi	a5,a0,88
    80002b1c:	40c8                	lw	a0,4(s1)
    80002b1e:	893d                	andi	a0,a0,15
    80002b20:	051a                	slli	a0,a0,0x6
    80002b22:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b24:	04449703          	lh	a4,68(s1)
    80002b28:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b2c:	04649703          	lh	a4,70(s1)
    80002b30:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b34:	04849703          	lh	a4,72(s1)
    80002b38:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b3c:	04a49703          	lh	a4,74(s1)
    80002b40:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b44:	44f8                	lw	a4,76(s1)
    80002b46:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b48:	03400613          	li	a2,52
    80002b4c:	05048593          	addi	a1,s1,80
    80002b50:	0531                	addi	a0,a0,12
    80002b52:	ffffd097          	auipc	ra,0xffffd
    80002b56:	682080e7          	jalr	1666(ra) # 800001d4 <memmove>
  log_write(bp);
    80002b5a:	854a                	mv	a0,s2
    80002b5c:	00001097          	auipc	ra,0x1
    80002b60:	bf6080e7          	jalr	-1034(ra) # 80003752 <log_write>
  brelse(bp);
    80002b64:	854a                	mv	a0,s2
    80002b66:	00000097          	auipc	ra,0x0
    80002b6a:	968080e7          	jalr	-1688(ra) # 800024ce <brelse>
}
    80002b6e:	60e2                	ld	ra,24(sp)
    80002b70:	6442                	ld	s0,16(sp)
    80002b72:	64a2                	ld	s1,8(sp)
    80002b74:	6902                	ld	s2,0(sp)
    80002b76:	6105                	addi	sp,sp,32
    80002b78:	8082                	ret

0000000080002b7a <idup>:
{
    80002b7a:	1101                	addi	sp,sp,-32
    80002b7c:	ec06                	sd	ra,24(sp)
    80002b7e:	e822                	sd	s0,16(sp)
    80002b80:	e426                	sd	s1,8(sp)
    80002b82:	1000                	addi	s0,sp,32
    80002b84:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b86:	00014517          	auipc	a0,0x14
    80002b8a:	4f250513          	addi	a0,a0,1266 # 80017078 <itable>
    80002b8e:	00003097          	auipc	ra,0x3
    80002b92:	60e080e7          	jalr	1550(ra) # 8000619c <acquire>
  ip->ref++;
    80002b96:	449c                	lw	a5,8(s1)
    80002b98:	2785                	addiw	a5,a5,1
    80002b9a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b9c:	00014517          	auipc	a0,0x14
    80002ba0:	4dc50513          	addi	a0,a0,1244 # 80017078 <itable>
    80002ba4:	00003097          	auipc	ra,0x3
    80002ba8:	6ac080e7          	jalr	1708(ra) # 80006250 <release>
}
    80002bac:	8526                	mv	a0,s1
    80002bae:	60e2                	ld	ra,24(sp)
    80002bb0:	6442                	ld	s0,16(sp)
    80002bb2:	64a2                	ld	s1,8(sp)
    80002bb4:	6105                	addi	sp,sp,32
    80002bb6:	8082                	ret

0000000080002bb8 <ilock>:
{
    80002bb8:	1101                	addi	sp,sp,-32
    80002bba:	ec06                	sd	ra,24(sp)
    80002bbc:	e822                	sd	s0,16(sp)
    80002bbe:	e426                	sd	s1,8(sp)
    80002bc0:	e04a                	sd	s2,0(sp)
    80002bc2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bc4:	c115                	beqz	a0,80002be8 <ilock+0x30>
    80002bc6:	84aa                	mv	s1,a0
    80002bc8:	451c                	lw	a5,8(a0)
    80002bca:	00f05f63          	blez	a5,80002be8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bce:	0541                	addi	a0,a0,16
    80002bd0:	00001097          	auipc	ra,0x1
    80002bd4:	ca2080e7          	jalr	-862(ra) # 80003872 <acquiresleep>
  if(ip->valid == 0){
    80002bd8:	40bc                	lw	a5,64(s1)
    80002bda:	cf99                	beqz	a5,80002bf8 <ilock+0x40>
}
    80002bdc:	60e2                	ld	ra,24(sp)
    80002bde:	6442                	ld	s0,16(sp)
    80002be0:	64a2                	ld	s1,8(sp)
    80002be2:	6902                	ld	s2,0(sp)
    80002be4:	6105                	addi	sp,sp,32
    80002be6:	8082                	ret
    panic("ilock");
    80002be8:	00006517          	auipc	a0,0x6
    80002bec:	9b050513          	addi	a0,a0,-1616 # 80008598 <syscalls+0x1c8>
    80002bf0:	00003097          	auipc	ra,0x3
    80002bf4:	070080e7          	jalr	112(ra) # 80005c60 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bf8:	40dc                	lw	a5,4(s1)
    80002bfa:	0047d79b          	srliw	a5,a5,0x4
    80002bfe:	00014597          	auipc	a1,0x14
    80002c02:	4725a583          	lw	a1,1138(a1) # 80017070 <sb+0x18>
    80002c06:	9dbd                	addw	a1,a1,a5
    80002c08:	4088                	lw	a0,0(s1)
    80002c0a:	fffff097          	auipc	ra,0xfffff
    80002c0e:	794080e7          	jalr	1940(ra) # 8000239e <bread>
    80002c12:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c14:	05850593          	addi	a1,a0,88
    80002c18:	40dc                	lw	a5,4(s1)
    80002c1a:	8bbd                	andi	a5,a5,15
    80002c1c:	079a                	slli	a5,a5,0x6
    80002c1e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c20:	00059783          	lh	a5,0(a1)
    80002c24:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c28:	00259783          	lh	a5,2(a1)
    80002c2c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c30:	00459783          	lh	a5,4(a1)
    80002c34:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c38:	00659783          	lh	a5,6(a1)
    80002c3c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c40:	459c                	lw	a5,8(a1)
    80002c42:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c44:	03400613          	li	a2,52
    80002c48:	05b1                	addi	a1,a1,12
    80002c4a:	05048513          	addi	a0,s1,80
    80002c4e:	ffffd097          	auipc	ra,0xffffd
    80002c52:	586080e7          	jalr	1414(ra) # 800001d4 <memmove>
    brelse(bp);
    80002c56:	854a                	mv	a0,s2
    80002c58:	00000097          	auipc	ra,0x0
    80002c5c:	876080e7          	jalr	-1930(ra) # 800024ce <brelse>
    ip->valid = 1;
    80002c60:	4785                	li	a5,1
    80002c62:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c64:	04449783          	lh	a5,68(s1)
    80002c68:	fbb5                	bnez	a5,80002bdc <ilock+0x24>
      panic("ilock: no type");
    80002c6a:	00006517          	auipc	a0,0x6
    80002c6e:	93650513          	addi	a0,a0,-1738 # 800085a0 <syscalls+0x1d0>
    80002c72:	00003097          	auipc	ra,0x3
    80002c76:	fee080e7          	jalr	-18(ra) # 80005c60 <panic>

0000000080002c7a <iunlock>:
{
    80002c7a:	1101                	addi	sp,sp,-32
    80002c7c:	ec06                	sd	ra,24(sp)
    80002c7e:	e822                	sd	s0,16(sp)
    80002c80:	e426                	sd	s1,8(sp)
    80002c82:	e04a                	sd	s2,0(sp)
    80002c84:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c86:	c905                	beqz	a0,80002cb6 <iunlock+0x3c>
    80002c88:	84aa                	mv	s1,a0
    80002c8a:	01050913          	addi	s2,a0,16
    80002c8e:	854a                	mv	a0,s2
    80002c90:	00001097          	auipc	ra,0x1
    80002c94:	c7c080e7          	jalr	-900(ra) # 8000390c <holdingsleep>
    80002c98:	cd19                	beqz	a0,80002cb6 <iunlock+0x3c>
    80002c9a:	449c                	lw	a5,8(s1)
    80002c9c:	00f05d63          	blez	a5,80002cb6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ca0:	854a                	mv	a0,s2
    80002ca2:	00001097          	auipc	ra,0x1
    80002ca6:	c26080e7          	jalr	-986(ra) # 800038c8 <releasesleep>
}
    80002caa:	60e2                	ld	ra,24(sp)
    80002cac:	6442                	ld	s0,16(sp)
    80002cae:	64a2                	ld	s1,8(sp)
    80002cb0:	6902                	ld	s2,0(sp)
    80002cb2:	6105                	addi	sp,sp,32
    80002cb4:	8082                	ret
    panic("iunlock");
    80002cb6:	00006517          	auipc	a0,0x6
    80002cba:	8fa50513          	addi	a0,a0,-1798 # 800085b0 <syscalls+0x1e0>
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	fa2080e7          	jalr	-94(ra) # 80005c60 <panic>

0000000080002cc6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cc6:	7179                	addi	sp,sp,-48
    80002cc8:	f406                	sd	ra,40(sp)
    80002cca:	f022                	sd	s0,32(sp)
    80002ccc:	ec26                	sd	s1,24(sp)
    80002cce:	e84a                	sd	s2,16(sp)
    80002cd0:	e44e                	sd	s3,8(sp)
    80002cd2:	e052                	sd	s4,0(sp)
    80002cd4:	1800                	addi	s0,sp,48
    80002cd6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cd8:	05050493          	addi	s1,a0,80
    80002cdc:	08050913          	addi	s2,a0,128
    80002ce0:	a021                	j	80002ce8 <itrunc+0x22>
    80002ce2:	0491                	addi	s1,s1,4
    80002ce4:	01248d63          	beq	s1,s2,80002cfe <itrunc+0x38>
    if(ip->addrs[i]){
    80002ce8:	408c                	lw	a1,0(s1)
    80002cea:	dde5                	beqz	a1,80002ce2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cec:	0009a503          	lw	a0,0(s3)
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	8f4080e7          	jalr	-1804(ra) # 800025e4 <bfree>
      ip->addrs[i] = 0;
    80002cf8:	0004a023          	sw	zero,0(s1)
    80002cfc:	b7dd                	j	80002ce2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cfe:	0809a583          	lw	a1,128(s3)
    80002d02:	e185                	bnez	a1,80002d22 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d04:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d08:	854e                	mv	a0,s3
    80002d0a:	00000097          	auipc	ra,0x0
    80002d0e:	de4080e7          	jalr	-540(ra) # 80002aee <iupdate>
}
    80002d12:	70a2                	ld	ra,40(sp)
    80002d14:	7402                	ld	s0,32(sp)
    80002d16:	64e2                	ld	s1,24(sp)
    80002d18:	6942                	ld	s2,16(sp)
    80002d1a:	69a2                	ld	s3,8(sp)
    80002d1c:	6a02                	ld	s4,0(sp)
    80002d1e:	6145                	addi	sp,sp,48
    80002d20:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d22:	0009a503          	lw	a0,0(s3)
    80002d26:	fffff097          	auipc	ra,0xfffff
    80002d2a:	678080e7          	jalr	1656(ra) # 8000239e <bread>
    80002d2e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d30:	05850493          	addi	s1,a0,88
    80002d34:	45850913          	addi	s2,a0,1112
    80002d38:	a021                	j	80002d40 <itrunc+0x7a>
    80002d3a:	0491                	addi	s1,s1,4
    80002d3c:	01248b63          	beq	s1,s2,80002d52 <itrunc+0x8c>
      if(a[j])
    80002d40:	408c                	lw	a1,0(s1)
    80002d42:	dde5                	beqz	a1,80002d3a <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d44:	0009a503          	lw	a0,0(s3)
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	89c080e7          	jalr	-1892(ra) # 800025e4 <bfree>
    80002d50:	b7ed                	j	80002d3a <itrunc+0x74>
    brelse(bp);
    80002d52:	8552                	mv	a0,s4
    80002d54:	fffff097          	auipc	ra,0xfffff
    80002d58:	77a080e7          	jalr	1914(ra) # 800024ce <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d5c:	0809a583          	lw	a1,128(s3)
    80002d60:	0009a503          	lw	a0,0(s3)
    80002d64:	00000097          	auipc	ra,0x0
    80002d68:	880080e7          	jalr	-1920(ra) # 800025e4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d6c:	0809a023          	sw	zero,128(s3)
    80002d70:	bf51                	j	80002d04 <itrunc+0x3e>

0000000080002d72 <iput>:
{
    80002d72:	1101                	addi	sp,sp,-32
    80002d74:	ec06                	sd	ra,24(sp)
    80002d76:	e822                	sd	s0,16(sp)
    80002d78:	e426                	sd	s1,8(sp)
    80002d7a:	e04a                	sd	s2,0(sp)
    80002d7c:	1000                	addi	s0,sp,32
    80002d7e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d80:	00014517          	auipc	a0,0x14
    80002d84:	2f850513          	addi	a0,a0,760 # 80017078 <itable>
    80002d88:	00003097          	auipc	ra,0x3
    80002d8c:	414080e7          	jalr	1044(ra) # 8000619c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d90:	4498                	lw	a4,8(s1)
    80002d92:	4785                	li	a5,1
    80002d94:	02f70363          	beq	a4,a5,80002dba <iput+0x48>
  ip->ref--;
    80002d98:	449c                	lw	a5,8(s1)
    80002d9a:	37fd                	addiw	a5,a5,-1
    80002d9c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d9e:	00014517          	auipc	a0,0x14
    80002da2:	2da50513          	addi	a0,a0,730 # 80017078 <itable>
    80002da6:	00003097          	auipc	ra,0x3
    80002daa:	4aa080e7          	jalr	1194(ra) # 80006250 <release>
}
    80002dae:	60e2                	ld	ra,24(sp)
    80002db0:	6442                	ld	s0,16(sp)
    80002db2:	64a2                	ld	s1,8(sp)
    80002db4:	6902                	ld	s2,0(sp)
    80002db6:	6105                	addi	sp,sp,32
    80002db8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dba:	40bc                	lw	a5,64(s1)
    80002dbc:	dff1                	beqz	a5,80002d98 <iput+0x26>
    80002dbe:	04a49783          	lh	a5,74(s1)
    80002dc2:	fbf9                	bnez	a5,80002d98 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dc4:	01048913          	addi	s2,s1,16
    80002dc8:	854a                	mv	a0,s2
    80002dca:	00001097          	auipc	ra,0x1
    80002dce:	aa8080e7          	jalr	-1368(ra) # 80003872 <acquiresleep>
    release(&itable.lock);
    80002dd2:	00014517          	auipc	a0,0x14
    80002dd6:	2a650513          	addi	a0,a0,678 # 80017078 <itable>
    80002dda:	00003097          	auipc	ra,0x3
    80002dde:	476080e7          	jalr	1142(ra) # 80006250 <release>
    itrunc(ip);
    80002de2:	8526                	mv	a0,s1
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	ee2080e7          	jalr	-286(ra) # 80002cc6 <itrunc>
    ip->type = 0;
    80002dec:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002df0:	8526                	mv	a0,s1
    80002df2:	00000097          	auipc	ra,0x0
    80002df6:	cfc080e7          	jalr	-772(ra) # 80002aee <iupdate>
    ip->valid = 0;
    80002dfa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dfe:	854a                	mv	a0,s2
    80002e00:	00001097          	auipc	ra,0x1
    80002e04:	ac8080e7          	jalr	-1336(ra) # 800038c8 <releasesleep>
    acquire(&itable.lock);
    80002e08:	00014517          	auipc	a0,0x14
    80002e0c:	27050513          	addi	a0,a0,624 # 80017078 <itable>
    80002e10:	00003097          	auipc	ra,0x3
    80002e14:	38c080e7          	jalr	908(ra) # 8000619c <acquire>
    80002e18:	b741                	j	80002d98 <iput+0x26>

0000000080002e1a <iunlockput>:
{
    80002e1a:	1101                	addi	sp,sp,-32
    80002e1c:	ec06                	sd	ra,24(sp)
    80002e1e:	e822                	sd	s0,16(sp)
    80002e20:	e426                	sd	s1,8(sp)
    80002e22:	1000                	addi	s0,sp,32
    80002e24:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	e54080e7          	jalr	-428(ra) # 80002c7a <iunlock>
  iput(ip);
    80002e2e:	8526                	mv	a0,s1
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	f42080e7          	jalr	-190(ra) # 80002d72 <iput>
}
    80002e38:	60e2                	ld	ra,24(sp)
    80002e3a:	6442                	ld	s0,16(sp)
    80002e3c:	64a2                	ld	s1,8(sp)
    80002e3e:	6105                	addi	sp,sp,32
    80002e40:	8082                	ret

0000000080002e42 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e42:	1141                	addi	sp,sp,-16
    80002e44:	e422                	sd	s0,8(sp)
    80002e46:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e48:	411c                	lw	a5,0(a0)
    80002e4a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e4c:	415c                	lw	a5,4(a0)
    80002e4e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e50:	04451783          	lh	a5,68(a0)
    80002e54:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e58:	04a51783          	lh	a5,74(a0)
    80002e5c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e60:	04c56783          	lwu	a5,76(a0)
    80002e64:	e99c                	sd	a5,16(a1)
}
    80002e66:	6422                	ld	s0,8(sp)
    80002e68:	0141                	addi	sp,sp,16
    80002e6a:	8082                	ret

0000000080002e6c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e6c:	457c                	lw	a5,76(a0)
    80002e6e:	0ed7e963          	bltu	a5,a3,80002f60 <readi+0xf4>
{
    80002e72:	7159                	addi	sp,sp,-112
    80002e74:	f486                	sd	ra,104(sp)
    80002e76:	f0a2                	sd	s0,96(sp)
    80002e78:	eca6                	sd	s1,88(sp)
    80002e7a:	e8ca                	sd	s2,80(sp)
    80002e7c:	e4ce                	sd	s3,72(sp)
    80002e7e:	e0d2                	sd	s4,64(sp)
    80002e80:	fc56                	sd	s5,56(sp)
    80002e82:	f85a                	sd	s6,48(sp)
    80002e84:	f45e                	sd	s7,40(sp)
    80002e86:	f062                	sd	s8,32(sp)
    80002e88:	ec66                	sd	s9,24(sp)
    80002e8a:	e86a                	sd	s10,16(sp)
    80002e8c:	e46e                	sd	s11,8(sp)
    80002e8e:	1880                	addi	s0,sp,112
    80002e90:	8b2a                	mv	s6,a0
    80002e92:	8bae                	mv	s7,a1
    80002e94:	8a32                	mv	s4,a2
    80002e96:	84b6                	mv	s1,a3
    80002e98:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e9a:	9f35                	addw	a4,a4,a3
    return 0;
    80002e9c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e9e:	0ad76063          	bltu	a4,a3,80002f3e <readi+0xd2>
  if(off + n > ip->size)
    80002ea2:	00e7f463          	bgeu	a5,a4,80002eaa <readi+0x3e>
    n = ip->size - off;
    80002ea6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eaa:	0a0a8963          	beqz	s5,80002f5c <readi+0xf0>
    80002eae:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eb0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eb4:	5c7d                	li	s8,-1
    80002eb6:	a82d                	j	80002ef0 <readi+0x84>
    80002eb8:	020d1d93          	slli	s11,s10,0x20
    80002ebc:	020ddd93          	srli	s11,s11,0x20
    80002ec0:	05890793          	addi	a5,s2,88
    80002ec4:	86ee                	mv	a3,s11
    80002ec6:	963e                	add	a2,a2,a5
    80002ec8:	85d2                	mv	a1,s4
    80002eca:	855e                	mv	a0,s7
    80002ecc:	fffff097          	auipc	ra,0xfffff
    80002ed0:	b0e080e7          	jalr	-1266(ra) # 800019da <either_copyout>
    80002ed4:	05850d63          	beq	a0,s8,80002f2e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ed8:	854a                	mv	a0,s2
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	5f4080e7          	jalr	1524(ra) # 800024ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee2:	013d09bb          	addw	s3,s10,s3
    80002ee6:	009d04bb          	addw	s1,s10,s1
    80002eea:	9a6e                	add	s4,s4,s11
    80002eec:	0559f763          	bgeu	s3,s5,80002f3a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002ef0:	00a4d59b          	srliw	a1,s1,0xa
    80002ef4:	855a                	mv	a0,s6
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	8a2080e7          	jalr	-1886(ra) # 80002798 <bmap>
    80002efe:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f02:	cd85                	beqz	a1,80002f3a <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f04:	000b2503          	lw	a0,0(s6)
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	496080e7          	jalr	1174(ra) # 8000239e <bread>
    80002f10:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f12:	3ff4f613          	andi	a2,s1,1023
    80002f16:	40cc87bb          	subw	a5,s9,a2
    80002f1a:	413a873b          	subw	a4,s5,s3
    80002f1e:	8d3e                	mv	s10,a5
    80002f20:	2781                	sext.w	a5,a5
    80002f22:	0007069b          	sext.w	a3,a4
    80002f26:	f8f6f9e3          	bgeu	a3,a5,80002eb8 <readi+0x4c>
    80002f2a:	8d3a                	mv	s10,a4
    80002f2c:	b771                	j	80002eb8 <readi+0x4c>
      brelse(bp);
    80002f2e:	854a                	mv	a0,s2
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	59e080e7          	jalr	1438(ra) # 800024ce <brelse>
      tot = -1;
    80002f38:	59fd                	li	s3,-1
  }
  return tot;
    80002f3a:	0009851b          	sext.w	a0,s3
}
    80002f3e:	70a6                	ld	ra,104(sp)
    80002f40:	7406                	ld	s0,96(sp)
    80002f42:	64e6                	ld	s1,88(sp)
    80002f44:	6946                	ld	s2,80(sp)
    80002f46:	69a6                	ld	s3,72(sp)
    80002f48:	6a06                	ld	s4,64(sp)
    80002f4a:	7ae2                	ld	s5,56(sp)
    80002f4c:	7b42                	ld	s6,48(sp)
    80002f4e:	7ba2                	ld	s7,40(sp)
    80002f50:	7c02                	ld	s8,32(sp)
    80002f52:	6ce2                	ld	s9,24(sp)
    80002f54:	6d42                	ld	s10,16(sp)
    80002f56:	6da2                	ld	s11,8(sp)
    80002f58:	6165                	addi	sp,sp,112
    80002f5a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f5c:	89d6                	mv	s3,s5
    80002f5e:	bff1                	j	80002f3a <readi+0xce>
    return 0;
    80002f60:	4501                	li	a0,0
}
    80002f62:	8082                	ret

0000000080002f64 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f64:	457c                	lw	a5,76(a0)
    80002f66:	10d7e863          	bltu	a5,a3,80003076 <writei+0x112>
{
    80002f6a:	7159                	addi	sp,sp,-112
    80002f6c:	f486                	sd	ra,104(sp)
    80002f6e:	f0a2                	sd	s0,96(sp)
    80002f70:	eca6                	sd	s1,88(sp)
    80002f72:	e8ca                	sd	s2,80(sp)
    80002f74:	e4ce                	sd	s3,72(sp)
    80002f76:	e0d2                	sd	s4,64(sp)
    80002f78:	fc56                	sd	s5,56(sp)
    80002f7a:	f85a                	sd	s6,48(sp)
    80002f7c:	f45e                	sd	s7,40(sp)
    80002f7e:	f062                	sd	s8,32(sp)
    80002f80:	ec66                	sd	s9,24(sp)
    80002f82:	e86a                	sd	s10,16(sp)
    80002f84:	e46e                	sd	s11,8(sp)
    80002f86:	1880                	addi	s0,sp,112
    80002f88:	8aaa                	mv	s5,a0
    80002f8a:	8bae                	mv	s7,a1
    80002f8c:	8a32                	mv	s4,a2
    80002f8e:	8936                	mv	s2,a3
    80002f90:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f92:	00e687bb          	addw	a5,a3,a4
    80002f96:	0ed7e263          	bltu	a5,a3,8000307a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f9a:	00043737          	lui	a4,0x43
    80002f9e:	0ef76063          	bltu	a4,a5,8000307e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa2:	0c0b0863          	beqz	s6,80003072 <writei+0x10e>
    80002fa6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fac:	5c7d                	li	s8,-1
    80002fae:	a091                	j	80002ff2 <writei+0x8e>
    80002fb0:	020d1d93          	slli	s11,s10,0x20
    80002fb4:	020ddd93          	srli	s11,s11,0x20
    80002fb8:	05848793          	addi	a5,s1,88
    80002fbc:	86ee                	mv	a3,s11
    80002fbe:	8652                	mv	a2,s4
    80002fc0:	85de                	mv	a1,s7
    80002fc2:	953e                	add	a0,a0,a5
    80002fc4:	fffff097          	auipc	ra,0xfffff
    80002fc8:	a6c080e7          	jalr	-1428(ra) # 80001a30 <either_copyin>
    80002fcc:	07850263          	beq	a0,s8,80003030 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	00000097          	auipc	ra,0x0
    80002fd6:	780080e7          	jalr	1920(ra) # 80003752 <log_write>
    brelse(bp);
    80002fda:	8526                	mv	a0,s1
    80002fdc:	fffff097          	auipc	ra,0xfffff
    80002fe0:	4f2080e7          	jalr	1266(ra) # 800024ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe4:	013d09bb          	addw	s3,s10,s3
    80002fe8:	012d093b          	addw	s2,s10,s2
    80002fec:	9a6e                	add	s4,s4,s11
    80002fee:	0569f663          	bgeu	s3,s6,8000303a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002ff2:	00a9559b          	srliw	a1,s2,0xa
    80002ff6:	8556                	mv	a0,s5
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	7a0080e7          	jalr	1952(ra) # 80002798 <bmap>
    80003000:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003004:	c99d                	beqz	a1,8000303a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003006:	000aa503          	lw	a0,0(s5)
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	394080e7          	jalr	916(ra) # 8000239e <bread>
    80003012:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003014:	3ff97513          	andi	a0,s2,1023
    80003018:	40ac87bb          	subw	a5,s9,a0
    8000301c:	413b073b          	subw	a4,s6,s3
    80003020:	8d3e                	mv	s10,a5
    80003022:	2781                	sext.w	a5,a5
    80003024:	0007069b          	sext.w	a3,a4
    80003028:	f8f6f4e3          	bgeu	a3,a5,80002fb0 <writei+0x4c>
    8000302c:	8d3a                	mv	s10,a4
    8000302e:	b749                	j	80002fb0 <writei+0x4c>
      brelse(bp);
    80003030:	8526                	mv	a0,s1
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	49c080e7          	jalr	1180(ra) # 800024ce <brelse>
  }

  if(off > ip->size)
    8000303a:	04caa783          	lw	a5,76(s5)
    8000303e:	0127f463          	bgeu	a5,s2,80003046 <writei+0xe2>
    ip->size = off;
    80003042:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003046:	8556                	mv	a0,s5
    80003048:	00000097          	auipc	ra,0x0
    8000304c:	aa6080e7          	jalr	-1370(ra) # 80002aee <iupdate>

  return tot;
    80003050:	0009851b          	sext.w	a0,s3
}
    80003054:	70a6                	ld	ra,104(sp)
    80003056:	7406                	ld	s0,96(sp)
    80003058:	64e6                	ld	s1,88(sp)
    8000305a:	6946                	ld	s2,80(sp)
    8000305c:	69a6                	ld	s3,72(sp)
    8000305e:	6a06                	ld	s4,64(sp)
    80003060:	7ae2                	ld	s5,56(sp)
    80003062:	7b42                	ld	s6,48(sp)
    80003064:	7ba2                	ld	s7,40(sp)
    80003066:	7c02                	ld	s8,32(sp)
    80003068:	6ce2                	ld	s9,24(sp)
    8000306a:	6d42                	ld	s10,16(sp)
    8000306c:	6da2                	ld	s11,8(sp)
    8000306e:	6165                	addi	sp,sp,112
    80003070:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003072:	89da                	mv	s3,s6
    80003074:	bfc9                	j	80003046 <writei+0xe2>
    return -1;
    80003076:	557d                	li	a0,-1
}
    80003078:	8082                	ret
    return -1;
    8000307a:	557d                	li	a0,-1
    8000307c:	bfe1                	j	80003054 <writei+0xf0>
    return -1;
    8000307e:	557d                	li	a0,-1
    80003080:	bfd1                	j	80003054 <writei+0xf0>

0000000080003082 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003082:	1141                	addi	sp,sp,-16
    80003084:	e406                	sd	ra,8(sp)
    80003086:	e022                	sd	s0,0(sp)
    80003088:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000308a:	4639                	li	a2,14
    8000308c:	ffffd097          	auipc	ra,0xffffd
    80003090:	1bc080e7          	jalr	444(ra) # 80000248 <strncmp>
}
    80003094:	60a2                	ld	ra,8(sp)
    80003096:	6402                	ld	s0,0(sp)
    80003098:	0141                	addi	sp,sp,16
    8000309a:	8082                	ret

000000008000309c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000309c:	7139                	addi	sp,sp,-64
    8000309e:	fc06                	sd	ra,56(sp)
    800030a0:	f822                	sd	s0,48(sp)
    800030a2:	f426                	sd	s1,40(sp)
    800030a4:	f04a                	sd	s2,32(sp)
    800030a6:	ec4e                	sd	s3,24(sp)
    800030a8:	e852                	sd	s4,16(sp)
    800030aa:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030ac:	04451703          	lh	a4,68(a0)
    800030b0:	4785                	li	a5,1
    800030b2:	00f71a63          	bne	a4,a5,800030c6 <dirlookup+0x2a>
    800030b6:	892a                	mv	s2,a0
    800030b8:	89ae                	mv	s3,a1
    800030ba:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030bc:	457c                	lw	a5,76(a0)
    800030be:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030c0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c2:	e79d                	bnez	a5,800030f0 <dirlookup+0x54>
    800030c4:	a8a5                	j	8000313c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030c6:	00005517          	auipc	a0,0x5
    800030ca:	4f250513          	addi	a0,a0,1266 # 800085b8 <syscalls+0x1e8>
    800030ce:	00003097          	auipc	ra,0x3
    800030d2:	b92080e7          	jalr	-1134(ra) # 80005c60 <panic>
      panic("dirlookup read");
    800030d6:	00005517          	auipc	a0,0x5
    800030da:	4fa50513          	addi	a0,a0,1274 # 800085d0 <syscalls+0x200>
    800030de:	00003097          	auipc	ra,0x3
    800030e2:	b82080e7          	jalr	-1150(ra) # 80005c60 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e6:	24c1                	addiw	s1,s1,16
    800030e8:	04c92783          	lw	a5,76(s2)
    800030ec:	04f4f763          	bgeu	s1,a5,8000313a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030f0:	4741                	li	a4,16
    800030f2:	86a6                	mv	a3,s1
    800030f4:	fc040613          	addi	a2,s0,-64
    800030f8:	4581                	li	a1,0
    800030fa:	854a                	mv	a0,s2
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	d70080e7          	jalr	-656(ra) # 80002e6c <readi>
    80003104:	47c1                	li	a5,16
    80003106:	fcf518e3          	bne	a0,a5,800030d6 <dirlookup+0x3a>
    if(de.inum == 0)
    8000310a:	fc045783          	lhu	a5,-64(s0)
    8000310e:	dfe1                	beqz	a5,800030e6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003110:	fc240593          	addi	a1,s0,-62
    80003114:	854e                	mv	a0,s3
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	f6c080e7          	jalr	-148(ra) # 80003082 <namecmp>
    8000311e:	f561                	bnez	a0,800030e6 <dirlookup+0x4a>
      if(poff)
    80003120:	000a0463          	beqz	s4,80003128 <dirlookup+0x8c>
        *poff = off;
    80003124:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003128:	fc045583          	lhu	a1,-64(s0)
    8000312c:	00092503          	lw	a0,0(s2)
    80003130:	fffff097          	auipc	ra,0xfffff
    80003134:	750080e7          	jalr	1872(ra) # 80002880 <iget>
    80003138:	a011                	j	8000313c <dirlookup+0xa0>
  return 0;
    8000313a:	4501                	li	a0,0
}
    8000313c:	70e2                	ld	ra,56(sp)
    8000313e:	7442                	ld	s0,48(sp)
    80003140:	74a2                	ld	s1,40(sp)
    80003142:	7902                	ld	s2,32(sp)
    80003144:	69e2                	ld	s3,24(sp)
    80003146:	6a42                	ld	s4,16(sp)
    80003148:	6121                	addi	sp,sp,64
    8000314a:	8082                	ret

000000008000314c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000314c:	711d                	addi	sp,sp,-96
    8000314e:	ec86                	sd	ra,88(sp)
    80003150:	e8a2                	sd	s0,80(sp)
    80003152:	e4a6                	sd	s1,72(sp)
    80003154:	e0ca                	sd	s2,64(sp)
    80003156:	fc4e                	sd	s3,56(sp)
    80003158:	f852                	sd	s4,48(sp)
    8000315a:	f456                	sd	s5,40(sp)
    8000315c:	f05a                	sd	s6,32(sp)
    8000315e:	ec5e                	sd	s7,24(sp)
    80003160:	e862                	sd	s8,16(sp)
    80003162:	e466                	sd	s9,8(sp)
    80003164:	1080                	addi	s0,sp,96
    80003166:	84aa                	mv	s1,a0
    80003168:	8aae                	mv	s5,a1
    8000316a:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000316c:	00054703          	lbu	a4,0(a0)
    80003170:	02f00793          	li	a5,47
    80003174:	02f70363          	beq	a4,a5,8000319a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003178:	ffffe097          	auipc	ra,0xffffe
    8000317c:	cd6080e7          	jalr	-810(ra) # 80000e4e <myproc>
    80003180:	15053503          	ld	a0,336(a0)
    80003184:	00000097          	auipc	ra,0x0
    80003188:	9f6080e7          	jalr	-1546(ra) # 80002b7a <idup>
    8000318c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000318e:	02f00913          	li	s2,47
  len = path - s;
    80003192:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003194:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003196:	4b85                	li	s7,1
    80003198:	a865                	j	80003250 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000319a:	4585                	li	a1,1
    8000319c:	4505                	li	a0,1
    8000319e:	fffff097          	auipc	ra,0xfffff
    800031a2:	6e2080e7          	jalr	1762(ra) # 80002880 <iget>
    800031a6:	89aa                	mv	s3,a0
    800031a8:	b7dd                	j	8000318e <namex+0x42>
      iunlockput(ip);
    800031aa:	854e                	mv	a0,s3
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	c6e080e7          	jalr	-914(ra) # 80002e1a <iunlockput>
      return 0;
    800031b4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031b6:	854e                	mv	a0,s3
    800031b8:	60e6                	ld	ra,88(sp)
    800031ba:	6446                	ld	s0,80(sp)
    800031bc:	64a6                	ld	s1,72(sp)
    800031be:	6906                	ld	s2,64(sp)
    800031c0:	79e2                	ld	s3,56(sp)
    800031c2:	7a42                	ld	s4,48(sp)
    800031c4:	7aa2                	ld	s5,40(sp)
    800031c6:	7b02                	ld	s6,32(sp)
    800031c8:	6be2                	ld	s7,24(sp)
    800031ca:	6c42                	ld	s8,16(sp)
    800031cc:	6ca2                	ld	s9,8(sp)
    800031ce:	6125                	addi	sp,sp,96
    800031d0:	8082                	ret
      iunlock(ip);
    800031d2:	854e                	mv	a0,s3
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	aa6080e7          	jalr	-1370(ra) # 80002c7a <iunlock>
      return ip;
    800031dc:	bfe9                	j	800031b6 <namex+0x6a>
      iunlockput(ip);
    800031de:	854e                	mv	a0,s3
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	c3a080e7          	jalr	-966(ra) # 80002e1a <iunlockput>
      return 0;
    800031e8:	89e6                	mv	s3,s9
    800031ea:	b7f1                	j	800031b6 <namex+0x6a>
  len = path - s;
    800031ec:	40b48633          	sub	a2,s1,a1
    800031f0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031f4:	099c5463          	bge	s8,s9,8000327c <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031f8:	4639                	li	a2,14
    800031fa:	8552                	mv	a0,s4
    800031fc:	ffffd097          	auipc	ra,0xffffd
    80003200:	fd8080e7          	jalr	-40(ra) # 800001d4 <memmove>
  while(*path == '/')
    80003204:	0004c783          	lbu	a5,0(s1)
    80003208:	01279763          	bne	a5,s2,80003216 <namex+0xca>
    path++;
    8000320c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000320e:	0004c783          	lbu	a5,0(s1)
    80003212:	ff278de3          	beq	a5,s2,8000320c <namex+0xc0>
    ilock(ip);
    80003216:	854e                	mv	a0,s3
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	9a0080e7          	jalr	-1632(ra) # 80002bb8 <ilock>
    if(ip->type != T_DIR){
    80003220:	04499783          	lh	a5,68(s3)
    80003224:	f97793e3          	bne	a5,s7,800031aa <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003228:	000a8563          	beqz	s5,80003232 <namex+0xe6>
    8000322c:	0004c783          	lbu	a5,0(s1)
    80003230:	d3cd                	beqz	a5,800031d2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003232:	865a                	mv	a2,s6
    80003234:	85d2                	mv	a1,s4
    80003236:	854e                	mv	a0,s3
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	e64080e7          	jalr	-412(ra) # 8000309c <dirlookup>
    80003240:	8caa                	mv	s9,a0
    80003242:	dd51                	beqz	a0,800031de <namex+0x92>
    iunlockput(ip);
    80003244:	854e                	mv	a0,s3
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	bd4080e7          	jalr	-1068(ra) # 80002e1a <iunlockput>
    ip = next;
    8000324e:	89e6                	mv	s3,s9
  while(*path == '/')
    80003250:	0004c783          	lbu	a5,0(s1)
    80003254:	05279763          	bne	a5,s2,800032a2 <namex+0x156>
    path++;
    80003258:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000325a:	0004c783          	lbu	a5,0(s1)
    8000325e:	ff278de3          	beq	a5,s2,80003258 <namex+0x10c>
  if(*path == 0)
    80003262:	c79d                	beqz	a5,80003290 <namex+0x144>
    path++;
    80003264:	85a6                	mv	a1,s1
  len = path - s;
    80003266:	8cda                	mv	s9,s6
    80003268:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000326a:	01278963          	beq	a5,s2,8000327c <namex+0x130>
    8000326e:	dfbd                	beqz	a5,800031ec <namex+0xa0>
    path++;
    80003270:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	ff279ce3          	bne	a5,s2,8000326e <namex+0x122>
    8000327a:	bf8d                	j	800031ec <namex+0xa0>
    memmove(name, s, len);
    8000327c:	2601                	sext.w	a2,a2
    8000327e:	8552                	mv	a0,s4
    80003280:	ffffd097          	auipc	ra,0xffffd
    80003284:	f54080e7          	jalr	-172(ra) # 800001d4 <memmove>
    name[len] = 0;
    80003288:	9cd2                	add	s9,s9,s4
    8000328a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000328e:	bf9d                	j	80003204 <namex+0xb8>
  if(nameiparent){
    80003290:	f20a83e3          	beqz	s5,800031b6 <namex+0x6a>
    iput(ip);
    80003294:	854e                	mv	a0,s3
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	adc080e7          	jalr	-1316(ra) # 80002d72 <iput>
    return 0;
    8000329e:	4981                	li	s3,0
    800032a0:	bf19                	j	800031b6 <namex+0x6a>
  if(*path == 0)
    800032a2:	d7fd                	beqz	a5,80003290 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032a4:	0004c783          	lbu	a5,0(s1)
    800032a8:	85a6                	mv	a1,s1
    800032aa:	b7d1                	j	8000326e <namex+0x122>

00000000800032ac <dirlink>:
{
    800032ac:	7139                	addi	sp,sp,-64
    800032ae:	fc06                	sd	ra,56(sp)
    800032b0:	f822                	sd	s0,48(sp)
    800032b2:	f426                	sd	s1,40(sp)
    800032b4:	f04a                	sd	s2,32(sp)
    800032b6:	ec4e                	sd	s3,24(sp)
    800032b8:	e852                	sd	s4,16(sp)
    800032ba:	0080                	addi	s0,sp,64
    800032bc:	892a                	mv	s2,a0
    800032be:	8a2e                	mv	s4,a1
    800032c0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032c2:	4601                	li	a2,0
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	dd8080e7          	jalr	-552(ra) # 8000309c <dirlookup>
    800032cc:	e93d                	bnez	a0,80003342 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ce:	04c92483          	lw	s1,76(s2)
    800032d2:	c49d                	beqz	s1,80003300 <dirlink+0x54>
    800032d4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032d6:	4741                	li	a4,16
    800032d8:	86a6                	mv	a3,s1
    800032da:	fc040613          	addi	a2,s0,-64
    800032de:	4581                	li	a1,0
    800032e0:	854a                	mv	a0,s2
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	b8a080e7          	jalr	-1142(ra) # 80002e6c <readi>
    800032ea:	47c1                	li	a5,16
    800032ec:	06f51163          	bne	a0,a5,8000334e <dirlink+0xa2>
    if(de.inum == 0)
    800032f0:	fc045783          	lhu	a5,-64(s0)
    800032f4:	c791                	beqz	a5,80003300 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f6:	24c1                	addiw	s1,s1,16
    800032f8:	04c92783          	lw	a5,76(s2)
    800032fc:	fcf4ede3          	bltu	s1,a5,800032d6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003300:	4639                	li	a2,14
    80003302:	85d2                	mv	a1,s4
    80003304:	fc240513          	addi	a0,s0,-62
    80003308:	ffffd097          	auipc	ra,0xffffd
    8000330c:	f7c080e7          	jalr	-132(ra) # 80000284 <strncpy>
  de.inum = inum;
    80003310:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003314:	4741                	li	a4,16
    80003316:	86a6                	mv	a3,s1
    80003318:	fc040613          	addi	a2,s0,-64
    8000331c:	4581                	li	a1,0
    8000331e:	854a                	mv	a0,s2
    80003320:	00000097          	auipc	ra,0x0
    80003324:	c44080e7          	jalr	-956(ra) # 80002f64 <writei>
    80003328:	1541                	addi	a0,a0,-16
    8000332a:	00a03533          	snez	a0,a0
    8000332e:	40a00533          	neg	a0,a0
}
    80003332:	70e2                	ld	ra,56(sp)
    80003334:	7442                	ld	s0,48(sp)
    80003336:	74a2                	ld	s1,40(sp)
    80003338:	7902                	ld	s2,32(sp)
    8000333a:	69e2                	ld	s3,24(sp)
    8000333c:	6a42                	ld	s4,16(sp)
    8000333e:	6121                	addi	sp,sp,64
    80003340:	8082                	ret
    iput(ip);
    80003342:	00000097          	auipc	ra,0x0
    80003346:	a30080e7          	jalr	-1488(ra) # 80002d72 <iput>
    return -1;
    8000334a:	557d                	li	a0,-1
    8000334c:	b7dd                	j	80003332 <dirlink+0x86>
      panic("dirlink read");
    8000334e:	00005517          	auipc	a0,0x5
    80003352:	29250513          	addi	a0,a0,658 # 800085e0 <syscalls+0x210>
    80003356:	00003097          	auipc	ra,0x3
    8000335a:	90a080e7          	jalr	-1782(ra) # 80005c60 <panic>

000000008000335e <namei>:

struct inode*
namei(char *path)
{
    8000335e:	1101                	addi	sp,sp,-32
    80003360:	ec06                	sd	ra,24(sp)
    80003362:	e822                	sd	s0,16(sp)
    80003364:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003366:	fe040613          	addi	a2,s0,-32
    8000336a:	4581                	li	a1,0
    8000336c:	00000097          	auipc	ra,0x0
    80003370:	de0080e7          	jalr	-544(ra) # 8000314c <namex>
}
    80003374:	60e2                	ld	ra,24(sp)
    80003376:	6442                	ld	s0,16(sp)
    80003378:	6105                	addi	sp,sp,32
    8000337a:	8082                	ret

000000008000337c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000337c:	1141                	addi	sp,sp,-16
    8000337e:	e406                	sd	ra,8(sp)
    80003380:	e022                	sd	s0,0(sp)
    80003382:	0800                	addi	s0,sp,16
    80003384:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003386:	4585                	li	a1,1
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	dc4080e7          	jalr	-572(ra) # 8000314c <namex>
}
    80003390:	60a2                	ld	ra,8(sp)
    80003392:	6402                	ld	s0,0(sp)
    80003394:	0141                	addi	sp,sp,16
    80003396:	8082                	ret

0000000080003398 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003398:	1101                	addi	sp,sp,-32
    8000339a:	ec06                	sd	ra,24(sp)
    8000339c:	e822                	sd	s0,16(sp)
    8000339e:	e426                	sd	s1,8(sp)
    800033a0:	e04a                	sd	s2,0(sp)
    800033a2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033a4:	00015917          	auipc	s2,0x15
    800033a8:	77c90913          	addi	s2,s2,1916 # 80018b20 <log>
    800033ac:	01892583          	lw	a1,24(s2)
    800033b0:	02892503          	lw	a0,40(s2)
    800033b4:	fffff097          	auipc	ra,0xfffff
    800033b8:	fea080e7          	jalr	-22(ra) # 8000239e <bread>
    800033bc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033be:	02c92683          	lw	a3,44(s2)
    800033c2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033c4:	02d05763          	blez	a3,800033f2 <write_head+0x5a>
    800033c8:	00015797          	auipc	a5,0x15
    800033cc:	78878793          	addi	a5,a5,1928 # 80018b50 <log+0x30>
    800033d0:	05c50713          	addi	a4,a0,92
    800033d4:	36fd                	addiw	a3,a3,-1
    800033d6:	1682                	slli	a3,a3,0x20
    800033d8:	9281                	srli	a3,a3,0x20
    800033da:	068a                	slli	a3,a3,0x2
    800033dc:	00015617          	auipc	a2,0x15
    800033e0:	77860613          	addi	a2,a2,1912 # 80018b54 <log+0x34>
    800033e4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033e6:	4390                	lw	a2,0(a5)
    800033e8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033ea:	0791                	addi	a5,a5,4
    800033ec:	0711                	addi	a4,a4,4
    800033ee:	fed79ce3          	bne	a5,a3,800033e6 <write_head+0x4e>
  }
  bwrite(buf);
    800033f2:	8526                	mv	a0,s1
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	09c080e7          	jalr	156(ra) # 80002490 <bwrite>
  brelse(buf);
    800033fc:	8526                	mv	a0,s1
    800033fe:	fffff097          	auipc	ra,0xfffff
    80003402:	0d0080e7          	jalr	208(ra) # 800024ce <brelse>
}
    80003406:	60e2                	ld	ra,24(sp)
    80003408:	6442                	ld	s0,16(sp)
    8000340a:	64a2                	ld	s1,8(sp)
    8000340c:	6902                	ld	s2,0(sp)
    8000340e:	6105                	addi	sp,sp,32
    80003410:	8082                	ret

0000000080003412 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003412:	00015797          	auipc	a5,0x15
    80003416:	73a7a783          	lw	a5,1850(a5) # 80018b4c <log+0x2c>
    8000341a:	0af05d63          	blez	a5,800034d4 <install_trans+0xc2>
{
    8000341e:	7139                	addi	sp,sp,-64
    80003420:	fc06                	sd	ra,56(sp)
    80003422:	f822                	sd	s0,48(sp)
    80003424:	f426                	sd	s1,40(sp)
    80003426:	f04a                	sd	s2,32(sp)
    80003428:	ec4e                	sd	s3,24(sp)
    8000342a:	e852                	sd	s4,16(sp)
    8000342c:	e456                	sd	s5,8(sp)
    8000342e:	e05a                	sd	s6,0(sp)
    80003430:	0080                	addi	s0,sp,64
    80003432:	8b2a                	mv	s6,a0
    80003434:	00015a97          	auipc	s5,0x15
    80003438:	71ca8a93          	addi	s5,s5,1820 # 80018b50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000343c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000343e:	00015997          	auipc	s3,0x15
    80003442:	6e298993          	addi	s3,s3,1762 # 80018b20 <log>
    80003446:	a00d                	j	80003468 <install_trans+0x56>
    brelse(lbuf);
    80003448:	854a                	mv	a0,s2
    8000344a:	fffff097          	auipc	ra,0xfffff
    8000344e:	084080e7          	jalr	132(ra) # 800024ce <brelse>
    brelse(dbuf);
    80003452:	8526                	mv	a0,s1
    80003454:	fffff097          	auipc	ra,0xfffff
    80003458:	07a080e7          	jalr	122(ra) # 800024ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345c:	2a05                	addiw	s4,s4,1
    8000345e:	0a91                	addi	s5,s5,4
    80003460:	02c9a783          	lw	a5,44(s3)
    80003464:	04fa5e63          	bge	s4,a5,800034c0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003468:	0189a583          	lw	a1,24(s3)
    8000346c:	014585bb          	addw	a1,a1,s4
    80003470:	2585                	addiw	a1,a1,1
    80003472:	0289a503          	lw	a0,40(s3)
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	f28080e7          	jalr	-216(ra) # 8000239e <bread>
    8000347e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003480:	000aa583          	lw	a1,0(s5)
    80003484:	0289a503          	lw	a0,40(s3)
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	f16080e7          	jalr	-234(ra) # 8000239e <bread>
    80003490:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003492:	40000613          	li	a2,1024
    80003496:	05890593          	addi	a1,s2,88
    8000349a:	05850513          	addi	a0,a0,88
    8000349e:	ffffd097          	auipc	ra,0xffffd
    800034a2:	d36080e7          	jalr	-714(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034a6:	8526                	mv	a0,s1
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	fe8080e7          	jalr	-24(ra) # 80002490 <bwrite>
    if(recovering == 0)
    800034b0:	f80b1ce3          	bnez	s6,80003448 <install_trans+0x36>
      bunpin(dbuf);
    800034b4:	8526                	mv	a0,s1
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	0f2080e7          	jalr	242(ra) # 800025a8 <bunpin>
    800034be:	b769                	j	80003448 <install_trans+0x36>
}
    800034c0:	70e2                	ld	ra,56(sp)
    800034c2:	7442                	ld	s0,48(sp)
    800034c4:	74a2                	ld	s1,40(sp)
    800034c6:	7902                	ld	s2,32(sp)
    800034c8:	69e2                	ld	s3,24(sp)
    800034ca:	6a42                	ld	s4,16(sp)
    800034cc:	6aa2                	ld	s5,8(sp)
    800034ce:	6b02                	ld	s6,0(sp)
    800034d0:	6121                	addi	sp,sp,64
    800034d2:	8082                	ret
    800034d4:	8082                	ret

00000000800034d6 <initlog>:
{
    800034d6:	7179                	addi	sp,sp,-48
    800034d8:	f406                	sd	ra,40(sp)
    800034da:	f022                	sd	s0,32(sp)
    800034dc:	ec26                	sd	s1,24(sp)
    800034de:	e84a                	sd	s2,16(sp)
    800034e0:	e44e                	sd	s3,8(sp)
    800034e2:	1800                	addi	s0,sp,48
    800034e4:	892a                	mv	s2,a0
    800034e6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034e8:	00015497          	auipc	s1,0x15
    800034ec:	63848493          	addi	s1,s1,1592 # 80018b20 <log>
    800034f0:	00005597          	auipc	a1,0x5
    800034f4:	10058593          	addi	a1,a1,256 # 800085f0 <syscalls+0x220>
    800034f8:	8526                	mv	a0,s1
    800034fa:	00003097          	auipc	ra,0x3
    800034fe:	c12080e7          	jalr	-1006(ra) # 8000610c <initlock>
  log.start = sb->logstart;
    80003502:	0149a583          	lw	a1,20(s3)
    80003506:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003508:	0109a783          	lw	a5,16(s3)
    8000350c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000350e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003512:	854a                	mv	a0,s2
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	e8a080e7          	jalr	-374(ra) # 8000239e <bread>
  log.lh.n = lh->n;
    8000351c:	4d34                	lw	a3,88(a0)
    8000351e:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003520:	02d05563          	blez	a3,8000354a <initlog+0x74>
    80003524:	05c50793          	addi	a5,a0,92
    80003528:	00015717          	auipc	a4,0x15
    8000352c:	62870713          	addi	a4,a4,1576 # 80018b50 <log+0x30>
    80003530:	36fd                	addiw	a3,a3,-1
    80003532:	1682                	slli	a3,a3,0x20
    80003534:	9281                	srli	a3,a3,0x20
    80003536:	068a                	slli	a3,a3,0x2
    80003538:	06050613          	addi	a2,a0,96
    8000353c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000353e:	4390                	lw	a2,0(a5)
    80003540:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003542:	0791                	addi	a5,a5,4
    80003544:	0711                	addi	a4,a4,4
    80003546:	fed79ce3          	bne	a5,a3,8000353e <initlog+0x68>
  brelse(buf);
    8000354a:	fffff097          	auipc	ra,0xfffff
    8000354e:	f84080e7          	jalr	-124(ra) # 800024ce <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003552:	4505                	li	a0,1
    80003554:	00000097          	auipc	ra,0x0
    80003558:	ebe080e7          	jalr	-322(ra) # 80003412 <install_trans>
  log.lh.n = 0;
    8000355c:	00015797          	auipc	a5,0x15
    80003560:	5e07a823          	sw	zero,1520(a5) # 80018b4c <log+0x2c>
  write_head(); // clear the log
    80003564:	00000097          	auipc	ra,0x0
    80003568:	e34080e7          	jalr	-460(ra) # 80003398 <write_head>
}
    8000356c:	70a2                	ld	ra,40(sp)
    8000356e:	7402                	ld	s0,32(sp)
    80003570:	64e2                	ld	s1,24(sp)
    80003572:	6942                	ld	s2,16(sp)
    80003574:	69a2                	ld	s3,8(sp)
    80003576:	6145                	addi	sp,sp,48
    80003578:	8082                	ret

000000008000357a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000357a:	1101                	addi	sp,sp,-32
    8000357c:	ec06                	sd	ra,24(sp)
    8000357e:	e822                	sd	s0,16(sp)
    80003580:	e426                	sd	s1,8(sp)
    80003582:	e04a                	sd	s2,0(sp)
    80003584:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003586:	00015517          	auipc	a0,0x15
    8000358a:	59a50513          	addi	a0,a0,1434 # 80018b20 <log>
    8000358e:	00003097          	auipc	ra,0x3
    80003592:	c0e080e7          	jalr	-1010(ra) # 8000619c <acquire>
  while(1){
    if(log.committing){
    80003596:	00015497          	auipc	s1,0x15
    8000359a:	58a48493          	addi	s1,s1,1418 # 80018b20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000359e:	4979                	li	s2,30
    800035a0:	a039                	j	800035ae <begin_op+0x34>
      sleep(&log, &log.lock);
    800035a2:	85a6                	mv	a1,s1
    800035a4:	8526                	mv	a0,s1
    800035a6:	ffffe097          	auipc	ra,0xffffe
    800035aa:	02c080e7          	jalr	44(ra) # 800015d2 <sleep>
    if(log.committing){
    800035ae:	50dc                	lw	a5,36(s1)
    800035b0:	fbed                	bnez	a5,800035a2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b2:	509c                	lw	a5,32(s1)
    800035b4:	0017871b          	addiw	a4,a5,1
    800035b8:	0007069b          	sext.w	a3,a4
    800035bc:	0027179b          	slliw	a5,a4,0x2
    800035c0:	9fb9                	addw	a5,a5,a4
    800035c2:	0017979b          	slliw	a5,a5,0x1
    800035c6:	54d8                	lw	a4,44(s1)
    800035c8:	9fb9                	addw	a5,a5,a4
    800035ca:	00f95963          	bge	s2,a5,800035dc <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035ce:	85a6                	mv	a1,s1
    800035d0:	8526                	mv	a0,s1
    800035d2:	ffffe097          	auipc	ra,0xffffe
    800035d6:	000080e7          	jalr	ra # 800015d2 <sleep>
    800035da:	bfd1                	j	800035ae <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035dc:	00015517          	auipc	a0,0x15
    800035e0:	54450513          	addi	a0,a0,1348 # 80018b20 <log>
    800035e4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035e6:	00003097          	auipc	ra,0x3
    800035ea:	c6a080e7          	jalr	-918(ra) # 80006250 <release>
      break;
    }
  }
}
    800035ee:	60e2                	ld	ra,24(sp)
    800035f0:	6442                	ld	s0,16(sp)
    800035f2:	64a2                	ld	s1,8(sp)
    800035f4:	6902                	ld	s2,0(sp)
    800035f6:	6105                	addi	sp,sp,32
    800035f8:	8082                	ret

00000000800035fa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035fa:	7139                	addi	sp,sp,-64
    800035fc:	fc06                	sd	ra,56(sp)
    800035fe:	f822                	sd	s0,48(sp)
    80003600:	f426                	sd	s1,40(sp)
    80003602:	f04a                	sd	s2,32(sp)
    80003604:	ec4e                	sd	s3,24(sp)
    80003606:	e852                	sd	s4,16(sp)
    80003608:	e456                	sd	s5,8(sp)
    8000360a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000360c:	00015497          	auipc	s1,0x15
    80003610:	51448493          	addi	s1,s1,1300 # 80018b20 <log>
    80003614:	8526                	mv	a0,s1
    80003616:	00003097          	auipc	ra,0x3
    8000361a:	b86080e7          	jalr	-1146(ra) # 8000619c <acquire>
  log.outstanding -= 1;
    8000361e:	509c                	lw	a5,32(s1)
    80003620:	37fd                	addiw	a5,a5,-1
    80003622:	0007891b          	sext.w	s2,a5
    80003626:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003628:	50dc                	lw	a5,36(s1)
    8000362a:	e7b9                	bnez	a5,80003678 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000362c:	04091e63          	bnez	s2,80003688 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003630:	00015497          	auipc	s1,0x15
    80003634:	4f048493          	addi	s1,s1,1264 # 80018b20 <log>
    80003638:	4785                	li	a5,1
    8000363a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000363c:	8526                	mv	a0,s1
    8000363e:	00003097          	auipc	ra,0x3
    80003642:	c12080e7          	jalr	-1006(ra) # 80006250 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003646:	54dc                	lw	a5,44(s1)
    80003648:	06f04763          	bgtz	a5,800036b6 <end_op+0xbc>
    acquire(&log.lock);
    8000364c:	00015497          	auipc	s1,0x15
    80003650:	4d448493          	addi	s1,s1,1236 # 80018b20 <log>
    80003654:	8526                	mv	a0,s1
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	b46080e7          	jalr	-1210(ra) # 8000619c <acquire>
    log.committing = 0;
    8000365e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003662:	8526                	mv	a0,s1
    80003664:	ffffe097          	auipc	ra,0xffffe
    80003668:	fd2080e7          	jalr	-46(ra) # 80001636 <wakeup>
    release(&log.lock);
    8000366c:	8526                	mv	a0,s1
    8000366e:	00003097          	auipc	ra,0x3
    80003672:	be2080e7          	jalr	-1054(ra) # 80006250 <release>
}
    80003676:	a03d                	j	800036a4 <end_op+0xaa>
    panic("log.committing");
    80003678:	00005517          	auipc	a0,0x5
    8000367c:	f8050513          	addi	a0,a0,-128 # 800085f8 <syscalls+0x228>
    80003680:	00002097          	auipc	ra,0x2
    80003684:	5e0080e7          	jalr	1504(ra) # 80005c60 <panic>
    wakeup(&log);
    80003688:	00015497          	auipc	s1,0x15
    8000368c:	49848493          	addi	s1,s1,1176 # 80018b20 <log>
    80003690:	8526                	mv	a0,s1
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	fa4080e7          	jalr	-92(ra) # 80001636 <wakeup>
  release(&log.lock);
    8000369a:	8526                	mv	a0,s1
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	bb4080e7          	jalr	-1100(ra) # 80006250 <release>
}
    800036a4:	70e2                	ld	ra,56(sp)
    800036a6:	7442                	ld	s0,48(sp)
    800036a8:	74a2                	ld	s1,40(sp)
    800036aa:	7902                	ld	s2,32(sp)
    800036ac:	69e2                	ld	s3,24(sp)
    800036ae:	6a42                	ld	s4,16(sp)
    800036b0:	6aa2                	ld	s5,8(sp)
    800036b2:	6121                	addi	sp,sp,64
    800036b4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b6:	00015a97          	auipc	s5,0x15
    800036ba:	49aa8a93          	addi	s5,s5,1178 # 80018b50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036be:	00015a17          	auipc	s4,0x15
    800036c2:	462a0a13          	addi	s4,s4,1122 # 80018b20 <log>
    800036c6:	018a2583          	lw	a1,24(s4)
    800036ca:	012585bb          	addw	a1,a1,s2
    800036ce:	2585                	addiw	a1,a1,1
    800036d0:	028a2503          	lw	a0,40(s4)
    800036d4:	fffff097          	auipc	ra,0xfffff
    800036d8:	cca080e7          	jalr	-822(ra) # 8000239e <bread>
    800036dc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036de:	000aa583          	lw	a1,0(s5)
    800036e2:	028a2503          	lw	a0,40(s4)
    800036e6:	fffff097          	auipc	ra,0xfffff
    800036ea:	cb8080e7          	jalr	-840(ra) # 8000239e <bread>
    800036ee:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036f0:	40000613          	li	a2,1024
    800036f4:	05850593          	addi	a1,a0,88
    800036f8:	05848513          	addi	a0,s1,88
    800036fc:	ffffd097          	auipc	ra,0xffffd
    80003700:	ad8080e7          	jalr	-1320(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003704:	8526                	mv	a0,s1
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	d8a080e7          	jalr	-630(ra) # 80002490 <bwrite>
    brelse(from);
    8000370e:	854e                	mv	a0,s3
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	dbe080e7          	jalr	-578(ra) # 800024ce <brelse>
    brelse(to);
    80003718:	8526                	mv	a0,s1
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	db4080e7          	jalr	-588(ra) # 800024ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003722:	2905                	addiw	s2,s2,1
    80003724:	0a91                	addi	s5,s5,4
    80003726:	02ca2783          	lw	a5,44(s4)
    8000372a:	f8f94ee3          	blt	s2,a5,800036c6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000372e:	00000097          	auipc	ra,0x0
    80003732:	c6a080e7          	jalr	-918(ra) # 80003398 <write_head>
    install_trans(0); // Now install writes to home locations
    80003736:	4501                	li	a0,0
    80003738:	00000097          	auipc	ra,0x0
    8000373c:	cda080e7          	jalr	-806(ra) # 80003412 <install_trans>
    log.lh.n = 0;
    80003740:	00015797          	auipc	a5,0x15
    80003744:	4007a623          	sw	zero,1036(a5) # 80018b4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	c50080e7          	jalr	-944(ra) # 80003398 <write_head>
    80003750:	bdf5                	j	8000364c <end_op+0x52>

0000000080003752 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003752:	1101                	addi	sp,sp,-32
    80003754:	ec06                	sd	ra,24(sp)
    80003756:	e822                	sd	s0,16(sp)
    80003758:	e426                	sd	s1,8(sp)
    8000375a:	e04a                	sd	s2,0(sp)
    8000375c:	1000                	addi	s0,sp,32
    8000375e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003760:	00015917          	auipc	s2,0x15
    80003764:	3c090913          	addi	s2,s2,960 # 80018b20 <log>
    80003768:	854a                	mv	a0,s2
    8000376a:	00003097          	auipc	ra,0x3
    8000376e:	a32080e7          	jalr	-1486(ra) # 8000619c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003772:	02c92603          	lw	a2,44(s2)
    80003776:	47f5                	li	a5,29
    80003778:	06c7c563          	blt	a5,a2,800037e2 <log_write+0x90>
    8000377c:	00015797          	auipc	a5,0x15
    80003780:	3c07a783          	lw	a5,960(a5) # 80018b3c <log+0x1c>
    80003784:	37fd                	addiw	a5,a5,-1
    80003786:	04f65e63          	bge	a2,a5,800037e2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000378a:	00015797          	auipc	a5,0x15
    8000378e:	3b67a783          	lw	a5,950(a5) # 80018b40 <log+0x20>
    80003792:	06f05063          	blez	a5,800037f2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003796:	4781                	li	a5,0
    80003798:	06c05563          	blez	a2,80003802 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000379c:	44cc                	lw	a1,12(s1)
    8000379e:	00015717          	auipc	a4,0x15
    800037a2:	3b270713          	addi	a4,a4,946 # 80018b50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037a6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037a8:	4314                	lw	a3,0(a4)
    800037aa:	04b68c63          	beq	a3,a1,80003802 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037ae:	2785                	addiw	a5,a5,1
    800037b0:	0711                	addi	a4,a4,4
    800037b2:	fef61be3          	bne	a2,a5,800037a8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037b6:	0621                	addi	a2,a2,8
    800037b8:	060a                	slli	a2,a2,0x2
    800037ba:	00015797          	auipc	a5,0x15
    800037be:	36678793          	addi	a5,a5,870 # 80018b20 <log>
    800037c2:	963e                	add	a2,a2,a5
    800037c4:	44dc                	lw	a5,12(s1)
    800037c6:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037c8:	8526                	mv	a0,s1
    800037ca:	fffff097          	auipc	ra,0xfffff
    800037ce:	da2080e7          	jalr	-606(ra) # 8000256c <bpin>
    log.lh.n++;
    800037d2:	00015717          	auipc	a4,0x15
    800037d6:	34e70713          	addi	a4,a4,846 # 80018b20 <log>
    800037da:	575c                	lw	a5,44(a4)
    800037dc:	2785                	addiw	a5,a5,1
    800037de:	d75c                	sw	a5,44(a4)
    800037e0:	a835                	j	8000381c <log_write+0xca>
    panic("too big a transaction");
    800037e2:	00005517          	auipc	a0,0x5
    800037e6:	e2650513          	addi	a0,a0,-474 # 80008608 <syscalls+0x238>
    800037ea:	00002097          	auipc	ra,0x2
    800037ee:	476080e7          	jalr	1142(ra) # 80005c60 <panic>
    panic("log_write outside of trans");
    800037f2:	00005517          	auipc	a0,0x5
    800037f6:	e2e50513          	addi	a0,a0,-466 # 80008620 <syscalls+0x250>
    800037fa:	00002097          	auipc	ra,0x2
    800037fe:	466080e7          	jalr	1126(ra) # 80005c60 <panic>
  log.lh.block[i] = b->blockno;
    80003802:	00878713          	addi	a4,a5,8
    80003806:	00271693          	slli	a3,a4,0x2
    8000380a:	00015717          	auipc	a4,0x15
    8000380e:	31670713          	addi	a4,a4,790 # 80018b20 <log>
    80003812:	9736                	add	a4,a4,a3
    80003814:	44d4                	lw	a3,12(s1)
    80003816:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003818:	faf608e3          	beq	a2,a5,800037c8 <log_write+0x76>
  }
  release(&log.lock);
    8000381c:	00015517          	auipc	a0,0x15
    80003820:	30450513          	addi	a0,a0,772 # 80018b20 <log>
    80003824:	00003097          	auipc	ra,0x3
    80003828:	a2c080e7          	jalr	-1492(ra) # 80006250 <release>
}
    8000382c:	60e2                	ld	ra,24(sp)
    8000382e:	6442                	ld	s0,16(sp)
    80003830:	64a2                	ld	s1,8(sp)
    80003832:	6902                	ld	s2,0(sp)
    80003834:	6105                	addi	sp,sp,32
    80003836:	8082                	ret

0000000080003838 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003838:	1101                	addi	sp,sp,-32
    8000383a:	ec06                	sd	ra,24(sp)
    8000383c:	e822                	sd	s0,16(sp)
    8000383e:	e426                	sd	s1,8(sp)
    80003840:	e04a                	sd	s2,0(sp)
    80003842:	1000                	addi	s0,sp,32
    80003844:	84aa                	mv	s1,a0
    80003846:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003848:	00005597          	auipc	a1,0x5
    8000384c:	df858593          	addi	a1,a1,-520 # 80008640 <syscalls+0x270>
    80003850:	0521                	addi	a0,a0,8
    80003852:	00003097          	auipc	ra,0x3
    80003856:	8ba080e7          	jalr	-1862(ra) # 8000610c <initlock>
  lk->name = name;
    8000385a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000385e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003862:	0204a423          	sw	zero,40(s1)
}
    80003866:	60e2                	ld	ra,24(sp)
    80003868:	6442                	ld	s0,16(sp)
    8000386a:	64a2                	ld	s1,8(sp)
    8000386c:	6902                	ld	s2,0(sp)
    8000386e:	6105                	addi	sp,sp,32
    80003870:	8082                	ret

0000000080003872 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003872:	1101                	addi	sp,sp,-32
    80003874:	ec06                	sd	ra,24(sp)
    80003876:	e822                	sd	s0,16(sp)
    80003878:	e426                	sd	s1,8(sp)
    8000387a:	e04a                	sd	s2,0(sp)
    8000387c:	1000                	addi	s0,sp,32
    8000387e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003880:	00850913          	addi	s2,a0,8
    80003884:	854a                	mv	a0,s2
    80003886:	00003097          	auipc	ra,0x3
    8000388a:	916080e7          	jalr	-1770(ra) # 8000619c <acquire>
  while (lk->locked) {
    8000388e:	409c                	lw	a5,0(s1)
    80003890:	cb89                	beqz	a5,800038a2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003892:	85ca                	mv	a1,s2
    80003894:	8526                	mv	a0,s1
    80003896:	ffffe097          	auipc	ra,0xffffe
    8000389a:	d3c080e7          	jalr	-708(ra) # 800015d2 <sleep>
  while (lk->locked) {
    8000389e:	409c                	lw	a5,0(s1)
    800038a0:	fbed                	bnez	a5,80003892 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038a2:	4785                	li	a5,1
    800038a4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038a6:	ffffd097          	auipc	ra,0xffffd
    800038aa:	5a8080e7          	jalr	1448(ra) # 80000e4e <myproc>
    800038ae:	591c                	lw	a5,48(a0)
    800038b0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038b2:	854a                	mv	a0,s2
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	99c080e7          	jalr	-1636(ra) # 80006250 <release>
}
    800038bc:	60e2                	ld	ra,24(sp)
    800038be:	6442                	ld	s0,16(sp)
    800038c0:	64a2                	ld	s1,8(sp)
    800038c2:	6902                	ld	s2,0(sp)
    800038c4:	6105                	addi	sp,sp,32
    800038c6:	8082                	ret

00000000800038c8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038c8:	1101                	addi	sp,sp,-32
    800038ca:	ec06                	sd	ra,24(sp)
    800038cc:	e822                	sd	s0,16(sp)
    800038ce:	e426                	sd	s1,8(sp)
    800038d0:	e04a                	sd	s2,0(sp)
    800038d2:	1000                	addi	s0,sp,32
    800038d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d6:	00850913          	addi	s2,a0,8
    800038da:	854a                	mv	a0,s2
    800038dc:	00003097          	auipc	ra,0x3
    800038e0:	8c0080e7          	jalr	-1856(ra) # 8000619c <acquire>
  lk->locked = 0;
    800038e4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038e8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038ec:	8526                	mv	a0,s1
    800038ee:	ffffe097          	auipc	ra,0xffffe
    800038f2:	d48080e7          	jalr	-696(ra) # 80001636 <wakeup>
  release(&lk->lk);
    800038f6:	854a                	mv	a0,s2
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	958080e7          	jalr	-1704(ra) # 80006250 <release>
}
    80003900:	60e2                	ld	ra,24(sp)
    80003902:	6442                	ld	s0,16(sp)
    80003904:	64a2                	ld	s1,8(sp)
    80003906:	6902                	ld	s2,0(sp)
    80003908:	6105                	addi	sp,sp,32
    8000390a:	8082                	ret

000000008000390c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000390c:	7179                	addi	sp,sp,-48
    8000390e:	f406                	sd	ra,40(sp)
    80003910:	f022                	sd	s0,32(sp)
    80003912:	ec26                	sd	s1,24(sp)
    80003914:	e84a                	sd	s2,16(sp)
    80003916:	e44e                	sd	s3,8(sp)
    80003918:	1800                	addi	s0,sp,48
    8000391a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000391c:	00850913          	addi	s2,a0,8
    80003920:	854a                	mv	a0,s2
    80003922:	00003097          	auipc	ra,0x3
    80003926:	87a080e7          	jalr	-1926(ra) # 8000619c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000392a:	409c                	lw	a5,0(s1)
    8000392c:	ef99                	bnez	a5,8000394a <holdingsleep+0x3e>
    8000392e:	4481                	li	s1,0
  release(&lk->lk);
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	91e080e7          	jalr	-1762(ra) # 80006250 <release>
  return r;
}
    8000393a:	8526                	mv	a0,s1
    8000393c:	70a2                	ld	ra,40(sp)
    8000393e:	7402                	ld	s0,32(sp)
    80003940:	64e2                	ld	s1,24(sp)
    80003942:	6942                	ld	s2,16(sp)
    80003944:	69a2                	ld	s3,8(sp)
    80003946:	6145                	addi	sp,sp,48
    80003948:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000394a:	0284a983          	lw	s3,40(s1)
    8000394e:	ffffd097          	auipc	ra,0xffffd
    80003952:	500080e7          	jalr	1280(ra) # 80000e4e <myproc>
    80003956:	5904                	lw	s1,48(a0)
    80003958:	413484b3          	sub	s1,s1,s3
    8000395c:	0014b493          	seqz	s1,s1
    80003960:	bfc1                	j	80003930 <holdingsleep+0x24>

0000000080003962 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003962:	1141                	addi	sp,sp,-16
    80003964:	e406                	sd	ra,8(sp)
    80003966:	e022                	sd	s0,0(sp)
    80003968:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000396a:	00005597          	auipc	a1,0x5
    8000396e:	ce658593          	addi	a1,a1,-794 # 80008650 <syscalls+0x280>
    80003972:	00015517          	auipc	a0,0x15
    80003976:	2f650513          	addi	a0,a0,758 # 80018c68 <ftable>
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	792080e7          	jalr	1938(ra) # 8000610c <initlock>
}
    80003982:	60a2                	ld	ra,8(sp)
    80003984:	6402                	ld	s0,0(sp)
    80003986:	0141                	addi	sp,sp,16
    80003988:	8082                	ret

000000008000398a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000398a:	1101                	addi	sp,sp,-32
    8000398c:	ec06                	sd	ra,24(sp)
    8000398e:	e822                	sd	s0,16(sp)
    80003990:	e426                	sd	s1,8(sp)
    80003992:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003994:	00015517          	auipc	a0,0x15
    80003998:	2d450513          	addi	a0,a0,724 # 80018c68 <ftable>
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	800080e7          	jalr	-2048(ra) # 8000619c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a4:	00015497          	auipc	s1,0x15
    800039a8:	2dc48493          	addi	s1,s1,732 # 80018c80 <ftable+0x18>
    800039ac:	00016717          	auipc	a4,0x16
    800039b0:	27470713          	addi	a4,a4,628 # 80019c20 <disk>
    if(f->ref == 0){
    800039b4:	40dc                	lw	a5,4(s1)
    800039b6:	cf99                	beqz	a5,800039d4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b8:	02848493          	addi	s1,s1,40
    800039bc:	fee49ce3          	bne	s1,a4,800039b4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039c0:	00015517          	auipc	a0,0x15
    800039c4:	2a850513          	addi	a0,a0,680 # 80018c68 <ftable>
    800039c8:	00003097          	auipc	ra,0x3
    800039cc:	888080e7          	jalr	-1912(ra) # 80006250 <release>
  return 0;
    800039d0:	4481                	li	s1,0
    800039d2:	a819                	j	800039e8 <filealloc+0x5e>
      f->ref = 1;
    800039d4:	4785                	li	a5,1
    800039d6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039d8:	00015517          	auipc	a0,0x15
    800039dc:	29050513          	addi	a0,a0,656 # 80018c68 <ftable>
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	870080e7          	jalr	-1936(ra) # 80006250 <release>
}
    800039e8:	8526                	mv	a0,s1
    800039ea:	60e2                	ld	ra,24(sp)
    800039ec:	6442                	ld	s0,16(sp)
    800039ee:	64a2                	ld	s1,8(sp)
    800039f0:	6105                	addi	sp,sp,32
    800039f2:	8082                	ret

00000000800039f4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039f4:	1101                	addi	sp,sp,-32
    800039f6:	ec06                	sd	ra,24(sp)
    800039f8:	e822                	sd	s0,16(sp)
    800039fa:	e426                	sd	s1,8(sp)
    800039fc:	1000                	addi	s0,sp,32
    800039fe:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a00:	00015517          	auipc	a0,0x15
    80003a04:	26850513          	addi	a0,a0,616 # 80018c68 <ftable>
    80003a08:	00002097          	auipc	ra,0x2
    80003a0c:	794080e7          	jalr	1940(ra) # 8000619c <acquire>
  if(f->ref < 1)
    80003a10:	40dc                	lw	a5,4(s1)
    80003a12:	02f05263          	blez	a5,80003a36 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a16:	2785                	addiw	a5,a5,1
    80003a18:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a1a:	00015517          	auipc	a0,0x15
    80003a1e:	24e50513          	addi	a0,a0,590 # 80018c68 <ftable>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	82e080e7          	jalr	-2002(ra) # 80006250 <release>
  return f;
}
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	60e2                	ld	ra,24(sp)
    80003a2e:	6442                	ld	s0,16(sp)
    80003a30:	64a2                	ld	s1,8(sp)
    80003a32:	6105                	addi	sp,sp,32
    80003a34:	8082                	ret
    panic("filedup");
    80003a36:	00005517          	auipc	a0,0x5
    80003a3a:	c2250513          	addi	a0,a0,-990 # 80008658 <syscalls+0x288>
    80003a3e:	00002097          	auipc	ra,0x2
    80003a42:	222080e7          	jalr	546(ra) # 80005c60 <panic>

0000000080003a46 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a46:	7139                	addi	sp,sp,-64
    80003a48:	fc06                	sd	ra,56(sp)
    80003a4a:	f822                	sd	s0,48(sp)
    80003a4c:	f426                	sd	s1,40(sp)
    80003a4e:	f04a                	sd	s2,32(sp)
    80003a50:	ec4e                	sd	s3,24(sp)
    80003a52:	e852                	sd	s4,16(sp)
    80003a54:	e456                	sd	s5,8(sp)
    80003a56:	0080                	addi	s0,sp,64
    80003a58:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a5a:	00015517          	auipc	a0,0x15
    80003a5e:	20e50513          	addi	a0,a0,526 # 80018c68 <ftable>
    80003a62:	00002097          	auipc	ra,0x2
    80003a66:	73a080e7          	jalr	1850(ra) # 8000619c <acquire>
  if(f->ref < 1)
    80003a6a:	40dc                	lw	a5,4(s1)
    80003a6c:	06f05163          	blez	a5,80003ace <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a70:	37fd                	addiw	a5,a5,-1
    80003a72:	0007871b          	sext.w	a4,a5
    80003a76:	c0dc                	sw	a5,4(s1)
    80003a78:	06e04363          	bgtz	a4,80003ade <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a7c:	0004a903          	lw	s2,0(s1)
    80003a80:	0094ca83          	lbu	s5,9(s1)
    80003a84:	0104ba03          	ld	s4,16(s1)
    80003a88:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a8c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a90:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a94:	00015517          	auipc	a0,0x15
    80003a98:	1d450513          	addi	a0,a0,468 # 80018c68 <ftable>
    80003a9c:	00002097          	auipc	ra,0x2
    80003aa0:	7b4080e7          	jalr	1972(ra) # 80006250 <release>

  if(ff.type == FD_PIPE){
    80003aa4:	4785                	li	a5,1
    80003aa6:	04f90d63          	beq	s2,a5,80003b00 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aaa:	3979                	addiw	s2,s2,-2
    80003aac:	4785                	li	a5,1
    80003aae:	0527e063          	bltu	a5,s2,80003aee <fileclose+0xa8>
    begin_op();
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	ac8080e7          	jalr	-1336(ra) # 8000357a <begin_op>
    iput(ff.ip);
    80003aba:	854e                	mv	a0,s3
    80003abc:	fffff097          	auipc	ra,0xfffff
    80003ac0:	2b6080e7          	jalr	694(ra) # 80002d72 <iput>
    end_op();
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	b36080e7          	jalr	-1226(ra) # 800035fa <end_op>
    80003acc:	a00d                	j	80003aee <fileclose+0xa8>
    panic("fileclose");
    80003ace:	00005517          	auipc	a0,0x5
    80003ad2:	b9250513          	addi	a0,a0,-1134 # 80008660 <syscalls+0x290>
    80003ad6:	00002097          	auipc	ra,0x2
    80003ada:	18a080e7          	jalr	394(ra) # 80005c60 <panic>
    release(&ftable.lock);
    80003ade:	00015517          	auipc	a0,0x15
    80003ae2:	18a50513          	addi	a0,a0,394 # 80018c68 <ftable>
    80003ae6:	00002097          	auipc	ra,0x2
    80003aea:	76a080e7          	jalr	1898(ra) # 80006250 <release>
  }
}
    80003aee:	70e2                	ld	ra,56(sp)
    80003af0:	7442                	ld	s0,48(sp)
    80003af2:	74a2                	ld	s1,40(sp)
    80003af4:	7902                	ld	s2,32(sp)
    80003af6:	69e2                	ld	s3,24(sp)
    80003af8:	6a42                	ld	s4,16(sp)
    80003afa:	6aa2                	ld	s5,8(sp)
    80003afc:	6121                	addi	sp,sp,64
    80003afe:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b00:	85d6                	mv	a1,s5
    80003b02:	8552                	mv	a0,s4
    80003b04:	00000097          	auipc	ra,0x0
    80003b08:	34c080e7          	jalr	844(ra) # 80003e50 <pipeclose>
    80003b0c:	b7cd                	j	80003aee <fileclose+0xa8>

0000000080003b0e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b0e:	715d                	addi	sp,sp,-80
    80003b10:	e486                	sd	ra,72(sp)
    80003b12:	e0a2                	sd	s0,64(sp)
    80003b14:	fc26                	sd	s1,56(sp)
    80003b16:	f84a                	sd	s2,48(sp)
    80003b18:	f44e                	sd	s3,40(sp)
    80003b1a:	0880                	addi	s0,sp,80
    80003b1c:	84aa                	mv	s1,a0
    80003b1e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b20:	ffffd097          	auipc	ra,0xffffd
    80003b24:	32e080e7          	jalr	814(ra) # 80000e4e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b28:	409c                	lw	a5,0(s1)
    80003b2a:	37f9                	addiw	a5,a5,-2
    80003b2c:	4705                	li	a4,1
    80003b2e:	04f76763          	bltu	a4,a5,80003b7c <filestat+0x6e>
    80003b32:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b34:	6c88                	ld	a0,24(s1)
    80003b36:	fffff097          	auipc	ra,0xfffff
    80003b3a:	082080e7          	jalr	130(ra) # 80002bb8 <ilock>
    stati(f->ip, &st);
    80003b3e:	fb840593          	addi	a1,s0,-72
    80003b42:	6c88                	ld	a0,24(s1)
    80003b44:	fffff097          	auipc	ra,0xfffff
    80003b48:	2fe080e7          	jalr	766(ra) # 80002e42 <stati>
    iunlock(f->ip);
    80003b4c:	6c88                	ld	a0,24(s1)
    80003b4e:	fffff097          	auipc	ra,0xfffff
    80003b52:	12c080e7          	jalr	300(ra) # 80002c7a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b56:	46e1                	li	a3,24
    80003b58:	fb840613          	addi	a2,s0,-72
    80003b5c:	85ce                	mv	a1,s3
    80003b5e:	05093503          	ld	a0,80(s2)
    80003b62:	ffffd097          	auipc	ra,0xffffd
    80003b66:	fac080e7          	jalr	-84(ra) # 80000b0e <copyout>
    80003b6a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b6e:	60a6                	ld	ra,72(sp)
    80003b70:	6406                	ld	s0,64(sp)
    80003b72:	74e2                	ld	s1,56(sp)
    80003b74:	7942                	ld	s2,48(sp)
    80003b76:	79a2                	ld	s3,40(sp)
    80003b78:	6161                	addi	sp,sp,80
    80003b7a:	8082                	ret
  return -1;
    80003b7c:	557d                	li	a0,-1
    80003b7e:	bfc5                	j	80003b6e <filestat+0x60>

0000000080003b80 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b80:	7179                	addi	sp,sp,-48
    80003b82:	f406                	sd	ra,40(sp)
    80003b84:	f022                	sd	s0,32(sp)
    80003b86:	ec26                	sd	s1,24(sp)
    80003b88:	e84a                	sd	s2,16(sp)
    80003b8a:	e44e                	sd	s3,8(sp)
    80003b8c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b8e:	00854783          	lbu	a5,8(a0)
    80003b92:	c3d5                	beqz	a5,80003c36 <fileread+0xb6>
    80003b94:	84aa                	mv	s1,a0
    80003b96:	89ae                	mv	s3,a1
    80003b98:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b9a:	411c                	lw	a5,0(a0)
    80003b9c:	4705                	li	a4,1
    80003b9e:	04e78963          	beq	a5,a4,80003bf0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ba2:	470d                	li	a4,3
    80003ba4:	04e78d63          	beq	a5,a4,80003bfe <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba8:	4709                	li	a4,2
    80003baa:	06e79e63          	bne	a5,a4,80003c26 <fileread+0xa6>
    ilock(f->ip);
    80003bae:	6d08                	ld	a0,24(a0)
    80003bb0:	fffff097          	auipc	ra,0xfffff
    80003bb4:	008080e7          	jalr	8(ra) # 80002bb8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bb8:	874a                	mv	a4,s2
    80003bba:	5094                	lw	a3,32(s1)
    80003bbc:	864e                	mv	a2,s3
    80003bbe:	4585                	li	a1,1
    80003bc0:	6c88                	ld	a0,24(s1)
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	2aa080e7          	jalr	682(ra) # 80002e6c <readi>
    80003bca:	892a                	mv	s2,a0
    80003bcc:	00a05563          	blez	a0,80003bd6 <fileread+0x56>
      f->off += r;
    80003bd0:	509c                	lw	a5,32(s1)
    80003bd2:	9fa9                	addw	a5,a5,a0
    80003bd4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bd6:	6c88                	ld	a0,24(s1)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	0a2080e7          	jalr	162(ra) # 80002c7a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003be0:	854a                	mv	a0,s2
    80003be2:	70a2                	ld	ra,40(sp)
    80003be4:	7402                	ld	s0,32(sp)
    80003be6:	64e2                	ld	s1,24(sp)
    80003be8:	6942                	ld	s2,16(sp)
    80003bea:	69a2                	ld	s3,8(sp)
    80003bec:	6145                	addi	sp,sp,48
    80003bee:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bf0:	6908                	ld	a0,16(a0)
    80003bf2:	00000097          	auipc	ra,0x0
    80003bf6:	3c6080e7          	jalr	966(ra) # 80003fb8 <piperead>
    80003bfa:	892a                	mv	s2,a0
    80003bfc:	b7d5                	j	80003be0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bfe:	02451783          	lh	a5,36(a0)
    80003c02:	03079693          	slli	a3,a5,0x30
    80003c06:	92c1                	srli	a3,a3,0x30
    80003c08:	4725                	li	a4,9
    80003c0a:	02d76863          	bltu	a4,a3,80003c3a <fileread+0xba>
    80003c0e:	0792                	slli	a5,a5,0x4
    80003c10:	00015717          	auipc	a4,0x15
    80003c14:	fb870713          	addi	a4,a4,-72 # 80018bc8 <devsw>
    80003c18:	97ba                	add	a5,a5,a4
    80003c1a:	639c                	ld	a5,0(a5)
    80003c1c:	c38d                	beqz	a5,80003c3e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c1e:	4505                	li	a0,1
    80003c20:	9782                	jalr	a5
    80003c22:	892a                	mv	s2,a0
    80003c24:	bf75                	j	80003be0 <fileread+0x60>
    panic("fileread");
    80003c26:	00005517          	auipc	a0,0x5
    80003c2a:	a4a50513          	addi	a0,a0,-1462 # 80008670 <syscalls+0x2a0>
    80003c2e:	00002097          	auipc	ra,0x2
    80003c32:	032080e7          	jalr	50(ra) # 80005c60 <panic>
    return -1;
    80003c36:	597d                	li	s2,-1
    80003c38:	b765                	j	80003be0 <fileread+0x60>
      return -1;
    80003c3a:	597d                	li	s2,-1
    80003c3c:	b755                	j	80003be0 <fileread+0x60>
    80003c3e:	597d                	li	s2,-1
    80003c40:	b745                	j	80003be0 <fileread+0x60>

0000000080003c42 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c42:	715d                	addi	sp,sp,-80
    80003c44:	e486                	sd	ra,72(sp)
    80003c46:	e0a2                	sd	s0,64(sp)
    80003c48:	fc26                	sd	s1,56(sp)
    80003c4a:	f84a                	sd	s2,48(sp)
    80003c4c:	f44e                	sd	s3,40(sp)
    80003c4e:	f052                	sd	s4,32(sp)
    80003c50:	ec56                	sd	s5,24(sp)
    80003c52:	e85a                	sd	s6,16(sp)
    80003c54:	e45e                	sd	s7,8(sp)
    80003c56:	e062                	sd	s8,0(sp)
    80003c58:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c5a:	00954783          	lbu	a5,9(a0)
    80003c5e:	10078663          	beqz	a5,80003d6a <filewrite+0x128>
    80003c62:	892a                	mv	s2,a0
    80003c64:	8aae                	mv	s5,a1
    80003c66:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c68:	411c                	lw	a5,0(a0)
    80003c6a:	4705                	li	a4,1
    80003c6c:	02e78263          	beq	a5,a4,80003c90 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c70:	470d                	li	a4,3
    80003c72:	02e78663          	beq	a5,a4,80003c9e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c76:	4709                	li	a4,2
    80003c78:	0ee79163          	bne	a5,a4,80003d5a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c7c:	0ac05d63          	blez	a2,80003d36 <filewrite+0xf4>
    int i = 0;
    80003c80:	4981                	li	s3,0
    80003c82:	6b05                	lui	s6,0x1
    80003c84:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c88:	6b85                	lui	s7,0x1
    80003c8a:	c00b8b9b          	addiw	s7,s7,-1024
    80003c8e:	a861                	j	80003d26 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c90:	6908                	ld	a0,16(a0)
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	22e080e7          	jalr	558(ra) # 80003ec0 <pipewrite>
    80003c9a:	8a2a                	mv	s4,a0
    80003c9c:	a045                	j	80003d3c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c9e:	02451783          	lh	a5,36(a0)
    80003ca2:	03079693          	slli	a3,a5,0x30
    80003ca6:	92c1                	srli	a3,a3,0x30
    80003ca8:	4725                	li	a4,9
    80003caa:	0cd76263          	bltu	a4,a3,80003d6e <filewrite+0x12c>
    80003cae:	0792                	slli	a5,a5,0x4
    80003cb0:	00015717          	auipc	a4,0x15
    80003cb4:	f1870713          	addi	a4,a4,-232 # 80018bc8 <devsw>
    80003cb8:	97ba                	add	a5,a5,a4
    80003cba:	679c                	ld	a5,8(a5)
    80003cbc:	cbdd                	beqz	a5,80003d72 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cbe:	4505                	li	a0,1
    80003cc0:	9782                	jalr	a5
    80003cc2:	8a2a                	mv	s4,a0
    80003cc4:	a8a5                	j	80003d3c <filewrite+0xfa>
    80003cc6:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	8b0080e7          	jalr	-1872(ra) # 8000357a <begin_op>
      ilock(f->ip);
    80003cd2:	01893503          	ld	a0,24(s2)
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	ee2080e7          	jalr	-286(ra) # 80002bb8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cde:	8762                	mv	a4,s8
    80003ce0:	02092683          	lw	a3,32(s2)
    80003ce4:	01598633          	add	a2,s3,s5
    80003ce8:	4585                	li	a1,1
    80003cea:	01893503          	ld	a0,24(s2)
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	276080e7          	jalr	630(ra) # 80002f64 <writei>
    80003cf6:	84aa                	mv	s1,a0
    80003cf8:	00a05763          	blez	a0,80003d06 <filewrite+0xc4>
        f->off += r;
    80003cfc:	02092783          	lw	a5,32(s2)
    80003d00:	9fa9                	addw	a5,a5,a0
    80003d02:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d06:	01893503          	ld	a0,24(s2)
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	f70080e7          	jalr	-144(ra) # 80002c7a <iunlock>
      end_op();
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	8e8080e7          	jalr	-1816(ra) # 800035fa <end_op>

      if(r != n1){
    80003d1a:	009c1f63          	bne	s8,s1,80003d38 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d1e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d22:	0149db63          	bge	s3,s4,80003d38 <filewrite+0xf6>
      int n1 = n - i;
    80003d26:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d2a:	84be                	mv	s1,a5
    80003d2c:	2781                	sext.w	a5,a5
    80003d2e:	f8fb5ce3          	bge	s6,a5,80003cc6 <filewrite+0x84>
    80003d32:	84de                	mv	s1,s7
    80003d34:	bf49                	j	80003cc6 <filewrite+0x84>
    int i = 0;
    80003d36:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d38:	013a1f63          	bne	s4,s3,80003d56 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d3c:	8552                	mv	a0,s4
    80003d3e:	60a6                	ld	ra,72(sp)
    80003d40:	6406                	ld	s0,64(sp)
    80003d42:	74e2                	ld	s1,56(sp)
    80003d44:	7942                	ld	s2,48(sp)
    80003d46:	79a2                	ld	s3,40(sp)
    80003d48:	7a02                	ld	s4,32(sp)
    80003d4a:	6ae2                	ld	s5,24(sp)
    80003d4c:	6b42                	ld	s6,16(sp)
    80003d4e:	6ba2                	ld	s7,8(sp)
    80003d50:	6c02                	ld	s8,0(sp)
    80003d52:	6161                	addi	sp,sp,80
    80003d54:	8082                	ret
    ret = (i == n ? n : -1);
    80003d56:	5a7d                	li	s4,-1
    80003d58:	b7d5                	j	80003d3c <filewrite+0xfa>
    panic("filewrite");
    80003d5a:	00005517          	auipc	a0,0x5
    80003d5e:	92650513          	addi	a0,a0,-1754 # 80008680 <syscalls+0x2b0>
    80003d62:	00002097          	auipc	ra,0x2
    80003d66:	efe080e7          	jalr	-258(ra) # 80005c60 <panic>
    return -1;
    80003d6a:	5a7d                	li	s4,-1
    80003d6c:	bfc1                	j	80003d3c <filewrite+0xfa>
      return -1;
    80003d6e:	5a7d                	li	s4,-1
    80003d70:	b7f1                	j	80003d3c <filewrite+0xfa>
    80003d72:	5a7d                	li	s4,-1
    80003d74:	b7e1                	j	80003d3c <filewrite+0xfa>

0000000080003d76 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d76:	7179                	addi	sp,sp,-48
    80003d78:	f406                	sd	ra,40(sp)
    80003d7a:	f022                	sd	s0,32(sp)
    80003d7c:	ec26                	sd	s1,24(sp)
    80003d7e:	e84a                	sd	s2,16(sp)
    80003d80:	e44e                	sd	s3,8(sp)
    80003d82:	e052                	sd	s4,0(sp)
    80003d84:	1800                	addi	s0,sp,48
    80003d86:	84aa                	mv	s1,a0
    80003d88:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d8a:	0005b023          	sd	zero,0(a1)
    80003d8e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	bf8080e7          	jalr	-1032(ra) # 8000398a <filealloc>
    80003d9a:	e088                	sd	a0,0(s1)
    80003d9c:	c551                	beqz	a0,80003e28 <pipealloc+0xb2>
    80003d9e:	00000097          	auipc	ra,0x0
    80003da2:	bec080e7          	jalr	-1044(ra) # 8000398a <filealloc>
    80003da6:	00aa3023          	sd	a0,0(s4)
    80003daa:	c92d                	beqz	a0,80003e1c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dac:	ffffc097          	auipc	ra,0xffffc
    80003db0:	36c080e7          	jalr	876(ra) # 80000118 <kalloc>
    80003db4:	892a                	mv	s2,a0
    80003db6:	c125                	beqz	a0,80003e16 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003db8:	4985                	li	s3,1
    80003dba:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dbe:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dc2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dc6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dca:	00005597          	auipc	a1,0x5
    80003dce:	8c658593          	addi	a1,a1,-1850 # 80008690 <syscalls+0x2c0>
    80003dd2:	00002097          	auipc	ra,0x2
    80003dd6:	33a080e7          	jalr	826(ra) # 8000610c <initlock>
  (*f0)->type = FD_PIPE;
    80003dda:	609c                	ld	a5,0(s1)
    80003ddc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003de0:	609c                	ld	a5,0(s1)
    80003de2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003de6:	609c                	ld	a5,0(s1)
    80003de8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dec:	609c                	ld	a5,0(s1)
    80003dee:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003df2:	000a3783          	ld	a5,0(s4)
    80003df6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dfa:	000a3783          	ld	a5,0(s4)
    80003dfe:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e02:	000a3783          	ld	a5,0(s4)
    80003e06:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e0a:	000a3783          	ld	a5,0(s4)
    80003e0e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e12:	4501                	li	a0,0
    80003e14:	a025                	j	80003e3c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e16:	6088                	ld	a0,0(s1)
    80003e18:	e501                	bnez	a0,80003e20 <pipealloc+0xaa>
    80003e1a:	a039                	j	80003e28 <pipealloc+0xb2>
    80003e1c:	6088                	ld	a0,0(s1)
    80003e1e:	c51d                	beqz	a0,80003e4c <pipealloc+0xd6>
    fileclose(*f0);
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	c26080e7          	jalr	-986(ra) # 80003a46 <fileclose>
  if(*f1)
    80003e28:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e2c:	557d                	li	a0,-1
  if(*f1)
    80003e2e:	c799                	beqz	a5,80003e3c <pipealloc+0xc6>
    fileclose(*f1);
    80003e30:	853e                	mv	a0,a5
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	c14080e7          	jalr	-1004(ra) # 80003a46 <fileclose>
  return -1;
    80003e3a:	557d                	li	a0,-1
}
    80003e3c:	70a2                	ld	ra,40(sp)
    80003e3e:	7402                	ld	s0,32(sp)
    80003e40:	64e2                	ld	s1,24(sp)
    80003e42:	6942                	ld	s2,16(sp)
    80003e44:	69a2                	ld	s3,8(sp)
    80003e46:	6a02                	ld	s4,0(sp)
    80003e48:	6145                	addi	sp,sp,48
    80003e4a:	8082                	ret
  return -1;
    80003e4c:	557d                	li	a0,-1
    80003e4e:	b7fd                	j	80003e3c <pipealloc+0xc6>

0000000080003e50 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e50:	1101                	addi	sp,sp,-32
    80003e52:	ec06                	sd	ra,24(sp)
    80003e54:	e822                	sd	s0,16(sp)
    80003e56:	e426                	sd	s1,8(sp)
    80003e58:	e04a                	sd	s2,0(sp)
    80003e5a:	1000                	addi	s0,sp,32
    80003e5c:	84aa                	mv	s1,a0
    80003e5e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e60:	00002097          	auipc	ra,0x2
    80003e64:	33c080e7          	jalr	828(ra) # 8000619c <acquire>
  if(writable){
    80003e68:	02090d63          	beqz	s2,80003ea2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e6c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e70:	21848513          	addi	a0,s1,536
    80003e74:	ffffd097          	auipc	ra,0xffffd
    80003e78:	7c2080e7          	jalr	1986(ra) # 80001636 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e7c:	2204b783          	ld	a5,544(s1)
    80003e80:	eb95                	bnez	a5,80003eb4 <pipeclose+0x64>
    release(&pi->lock);
    80003e82:	8526                	mv	a0,s1
    80003e84:	00002097          	auipc	ra,0x2
    80003e88:	3cc080e7          	jalr	972(ra) # 80006250 <release>
    kfree((char*)pi);
    80003e8c:	8526                	mv	a0,s1
    80003e8e:	ffffc097          	auipc	ra,0xffffc
    80003e92:	18e080e7          	jalr	398(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e96:	60e2                	ld	ra,24(sp)
    80003e98:	6442                	ld	s0,16(sp)
    80003e9a:	64a2                	ld	s1,8(sp)
    80003e9c:	6902                	ld	s2,0(sp)
    80003e9e:	6105                	addi	sp,sp,32
    80003ea0:	8082                	ret
    pi->readopen = 0;
    80003ea2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ea6:	21c48513          	addi	a0,s1,540
    80003eaa:	ffffd097          	auipc	ra,0xffffd
    80003eae:	78c080e7          	jalr	1932(ra) # 80001636 <wakeup>
    80003eb2:	b7e9                	j	80003e7c <pipeclose+0x2c>
    release(&pi->lock);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	00002097          	auipc	ra,0x2
    80003eba:	39a080e7          	jalr	922(ra) # 80006250 <release>
}
    80003ebe:	bfe1                	j	80003e96 <pipeclose+0x46>

0000000080003ec0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ec0:	711d                	addi	sp,sp,-96
    80003ec2:	ec86                	sd	ra,88(sp)
    80003ec4:	e8a2                	sd	s0,80(sp)
    80003ec6:	e4a6                	sd	s1,72(sp)
    80003ec8:	e0ca                	sd	s2,64(sp)
    80003eca:	fc4e                	sd	s3,56(sp)
    80003ecc:	f852                	sd	s4,48(sp)
    80003ece:	f456                	sd	s5,40(sp)
    80003ed0:	f05a                	sd	s6,32(sp)
    80003ed2:	ec5e                	sd	s7,24(sp)
    80003ed4:	e862                	sd	s8,16(sp)
    80003ed6:	1080                	addi	s0,sp,96
    80003ed8:	84aa                	mv	s1,a0
    80003eda:	8aae                	mv	s5,a1
    80003edc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ede:	ffffd097          	auipc	ra,0xffffd
    80003ee2:	f70080e7          	jalr	-144(ra) # 80000e4e <myproc>
    80003ee6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ee8:	8526                	mv	a0,s1
    80003eea:	00002097          	auipc	ra,0x2
    80003eee:	2b2080e7          	jalr	690(ra) # 8000619c <acquire>
  while(i < n){
    80003ef2:	0b405663          	blez	s4,80003f9e <pipewrite+0xde>
  int i = 0;
    80003ef6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ef8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003efa:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003efe:	21c48b93          	addi	s7,s1,540
    80003f02:	a089                	j	80003f44 <pipewrite+0x84>
      release(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	34a080e7          	jalr	842(ra) # 80006250 <release>
      return -1;
    80003f0e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f10:	854a                	mv	a0,s2
    80003f12:	60e6                	ld	ra,88(sp)
    80003f14:	6446                	ld	s0,80(sp)
    80003f16:	64a6                	ld	s1,72(sp)
    80003f18:	6906                	ld	s2,64(sp)
    80003f1a:	79e2                	ld	s3,56(sp)
    80003f1c:	7a42                	ld	s4,48(sp)
    80003f1e:	7aa2                	ld	s5,40(sp)
    80003f20:	7b02                	ld	s6,32(sp)
    80003f22:	6be2                	ld	s7,24(sp)
    80003f24:	6c42                	ld	s8,16(sp)
    80003f26:	6125                	addi	sp,sp,96
    80003f28:	8082                	ret
      wakeup(&pi->nread);
    80003f2a:	8562                	mv	a0,s8
    80003f2c:	ffffd097          	auipc	ra,0xffffd
    80003f30:	70a080e7          	jalr	1802(ra) # 80001636 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f34:	85a6                	mv	a1,s1
    80003f36:	855e                	mv	a0,s7
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	69a080e7          	jalr	1690(ra) # 800015d2 <sleep>
  while(i < n){
    80003f40:	07495063          	bge	s2,s4,80003fa0 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f44:	2204a783          	lw	a5,544(s1)
    80003f48:	dfd5                	beqz	a5,80003f04 <pipewrite+0x44>
    80003f4a:	854e                	mv	a0,s3
    80003f4c:	ffffe097          	auipc	ra,0xffffe
    80003f50:	92e080e7          	jalr	-1746(ra) # 8000187a <killed>
    80003f54:	f945                	bnez	a0,80003f04 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f56:	2184a783          	lw	a5,536(s1)
    80003f5a:	21c4a703          	lw	a4,540(s1)
    80003f5e:	2007879b          	addiw	a5,a5,512
    80003f62:	fcf704e3          	beq	a4,a5,80003f2a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f66:	4685                	li	a3,1
    80003f68:	01590633          	add	a2,s2,s5
    80003f6c:	faf40593          	addi	a1,s0,-81
    80003f70:	0509b503          	ld	a0,80(s3)
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	c26080e7          	jalr	-986(ra) # 80000b9a <copyin>
    80003f7c:	03650263          	beq	a0,s6,80003fa0 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f80:	21c4a783          	lw	a5,540(s1)
    80003f84:	0017871b          	addiw	a4,a5,1
    80003f88:	20e4ae23          	sw	a4,540(s1)
    80003f8c:	1ff7f793          	andi	a5,a5,511
    80003f90:	97a6                	add	a5,a5,s1
    80003f92:	faf44703          	lbu	a4,-81(s0)
    80003f96:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f9a:	2905                	addiw	s2,s2,1
    80003f9c:	b755                	j	80003f40 <pipewrite+0x80>
  int i = 0;
    80003f9e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fa0:	21848513          	addi	a0,s1,536
    80003fa4:	ffffd097          	auipc	ra,0xffffd
    80003fa8:	692080e7          	jalr	1682(ra) # 80001636 <wakeup>
  release(&pi->lock);
    80003fac:	8526                	mv	a0,s1
    80003fae:	00002097          	auipc	ra,0x2
    80003fb2:	2a2080e7          	jalr	674(ra) # 80006250 <release>
  return i;
    80003fb6:	bfa9                	j	80003f10 <pipewrite+0x50>

0000000080003fb8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fb8:	715d                	addi	sp,sp,-80
    80003fba:	e486                	sd	ra,72(sp)
    80003fbc:	e0a2                	sd	s0,64(sp)
    80003fbe:	fc26                	sd	s1,56(sp)
    80003fc0:	f84a                	sd	s2,48(sp)
    80003fc2:	f44e                	sd	s3,40(sp)
    80003fc4:	f052                	sd	s4,32(sp)
    80003fc6:	ec56                	sd	s5,24(sp)
    80003fc8:	e85a                	sd	s6,16(sp)
    80003fca:	0880                	addi	s0,sp,80
    80003fcc:	84aa                	mv	s1,a0
    80003fce:	892e                	mv	s2,a1
    80003fd0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fd2:	ffffd097          	auipc	ra,0xffffd
    80003fd6:	e7c080e7          	jalr	-388(ra) # 80000e4e <myproc>
    80003fda:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fdc:	8526                	mv	a0,s1
    80003fde:	00002097          	auipc	ra,0x2
    80003fe2:	1be080e7          	jalr	446(ra) # 8000619c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fe6:	2184a703          	lw	a4,536(s1)
    80003fea:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fee:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff2:	02f71763          	bne	a4,a5,80004020 <piperead+0x68>
    80003ff6:	2244a783          	lw	a5,548(s1)
    80003ffa:	c39d                	beqz	a5,80004020 <piperead+0x68>
    if(killed(pr)){
    80003ffc:	8552                	mv	a0,s4
    80003ffe:	ffffe097          	auipc	ra,0xffffe
    80004002:	87c080e7          	jalr	-1924(ra) # 8000187a <killed>
    80004006:	e941                	bnez	a0,80004096 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004008:	85a6                	mv	a1,s1
    8000400a:	854e                	mv	a0,s3
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	5c6080e7          	jalr	1478(ra) # 800015d2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004014:	2184a703          	lw	a4,536(s1)
    80004018:	21c4a783          	lw	a5,540(s1)
    8000401c:	fcf70de3          	beq	a4,a5,80003ff6 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004020:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004022:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004024:	05505363          	blez	s5,8000406a <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004028:	2184a783          	lw	a5,536(s1)
    8000402c:	21c4a703          	lw	a4,540(s1)
    80004030:	02f70d63          	beq	a4,a5,8000406a <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004034:	0017871b          	addiw	a4,a5,1
    80004038:	20e4ac23          	sw	a4,536(s1)
    8000403c:	1ff7f793          	andi	a5,a5,511
    80004040:	97a6                	add	a5,a5,s1
    80004042:	0187c783          	lbu	a5,24(a5)
    80004046:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000404a:	4685                	li	a3,1
    8000404c:	fbf40613          	addi	a2,s0,-65
    80004050:	85ca                	mv	a1,s2
    80004052:	050a3503          	ld	a0,80(s4)
    80004056:	ffffd097          	auipc	ra,0xffffd
    8000405a:	ab8080e7          	jalr	-1352(ra) # 80000b0e <copyout>
    8000405e:	01650663          	beq	a0,s6,8000406a <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004062:	2985                	addiw	s3,s3,1
    80004064:	0905                	addi	s2,s2,1
    80004066:	fd3a91e3          	bne	s5,s3,80004028 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000406a:	21c48513          	addi	a0,s1,540
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	5c8080e7          	jalr	1480(ra) # 80001636 <wakeup>
  release(&pi->lock);
    80004076:	8526                	mv	a0,s1
    80004078:	00002097          	auipc	ra,0x2
    8000407c:	1d8080e7          	jalr	472(ra) # 80006250 <release>
  return i;
}
    80004080:	854e                	mv	a0,s3
    80004082:	60a6                	ld	ra,72(sp)
    80004084:	6406                	ld	s0,64(sp)
    80004086:	74e2                	ld	s1,56(sp)
    80004088:	7942                	ld	s2,48(sp)
    8000408a:	79a2                	ld	s3,40(sp)
    8000408c:	7a02                	ld	s4,32(sp)
    8000408e:	6ae2                	ld	s5,24(sp)
    80004090:	6b42                	ld	s6,16(sp)
    80004092:	6161                	addi	sp,sp,80
    80004094:	8082                	ret
      release(&pi->lock);
    80004096:	8526                	mv	a0,s1
    80004098:	00002097          	auipc	ra,0x2
    8000409c:	1b8080e7          	jalr	440(ra) # 80006250 <release>
      return -1;
    800040a0:	59fd                	li	s3,-1
    800040a2:	bff9                	j	80004080 <piperead+0xc8>

00000000800040a4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040a4:	1141                	addi	sp,sp,-16
    800040a6:	e422                	sd	s0,8(sp)
    800040a8:	0800                	addi	s0,sp,16
    800040aa:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040ac:	8905                	andi	a0,a0,1
    800040ae:	c111                	beqz	a0,800040b2 <flags2perm+0xe>
      perm = PTE_X;
    800040b0:	4521                	li	a0,8
    if(flags & 0x2)
    800040b2:	8b89                	andi	a5,a5,2
    800040b4:	c399                	beqz	a5,800040ba <flags2perm+0x16>
      perm |= PTE_W;
    800040b6:	00456513          	ori	a0,a0,4
    return perm;
}
    800040ba:	6422                	ld	s0,8(sp)
    800040bc:	0141                	addi	sp,sp,16
    800040be:	8082                	ret

00000000800040c0 <exec>:

int
exec(char *path, char **argv)
{
    800040c0:	de010113          	addi	sp,sp,-544
    800040c4:	20113c23          	sd	ra,536(sp)
    800040c8:	20813823          	sd	s0,528(sp)
    800040cc:	20913423          	sd	s1,520(sp)
    800040d0:	21213023          	sd	s2,512(sp)
    800040d4:	ffce                	sd	s3,504(sp)
    800040d6:	fbd2                	sd	s4,496(sp)
    800040d8:	f7d6                	sd	s5,488(sp)
    800040da:	f3da                	sd	s6,480(sp)
    800040dc:	efde                	sd	s7,472(sp)
    800040de:	ebe2                	sd	s8,464(sp)
    800040e0:	e7e6                	sd	s9,456(sp)
    800040e2:	e3ea                	sd	s10,448(sp)
    800040e4:	ff6e                	sd	s11,440(sp)
    800040e6:	1400                	addi	s0,sp,544
    800040e8:	892a                	mv	s2,a0
    800040ea:	dea43423          	sd	a0,-536(s0)
    800040ee:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040f2:	ffffd097          	auipc	ra,0xffffd
    800040f6:	d5c080e7          	jalr	-676(ra) # 80000e4e <myproc>
    800040fa:	84aa                	mv	s1,a0

  begin_op();
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	47e080e7          	jalr	1150(ra) # 8000357a <begin_op>

  if((ip = namei(path)) == 0){
    80004104:	854a                	mv	a0,s2
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	258080e7          	jalr	600(ra) # 8000335e <namei>
    8000410e:	c93d                	beqz	a0,80004184 <exec+0xc4>
    80004110:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004112:	fffff097          	auipc	ra,0xfffff
    80004116:	aa6080e7          	jalr	-1370(ra) # 80002bb8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000411a:	04000713          	li	a4,64
    8000411e:	4681                	li	a3,0
    80004120:	e5040613          	addi	a2,s0,-432
    80004124:	4581                	li	a1,0
    80004126:	8556                	mv	a0,s5
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	d44080e7          	jalr	-700(ra) # 80002e6c <readi>
    80004130:	04000793          	li	a5,64
    80004134:	00f51a63          	bne	a0,a5,80004148 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004138:	e5042703          	lw	a4,-432(s0)
    8000413c:	464c47b7          	lui	a5,0x464c4
    80004140:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004144:	04f70663          	beq	a4,a5,80004190 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004148:	8556                	mv	a0,s5
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	cd0080e7          	jalr	-816(ra) # 80002e1a <iunlockput>
    end_op();
    80004152:	fffff097          	auipc	ra,0xfffff
    80004156:	4a8080e7          	jalr	1192(ra) # 800035fa <end_op>
  }
  return -1;
    8000415a:	557d                	li	a0,-1
}
    8000415c:	21813083          	ld	ra,536(sp)
    80004160:	21013403          	ld	s0,528(sp)
    80004164:	20813483          	ld	s1,520(sp)
    80004168:	20013903          	ld	s2,512(sp)
    8000416c:	79fe                	ld	s3,504(sp)
    8000416e:	7a5e                	ld	s4,496(sp)
    80004170:	7abe                	ld	s5,488(sp)
    80004172:	7b1e                	ld	s6,480(sp)
    80004174:	6bfe                	ld	s7,472(sp)
    80004176:	6c5e                	ld	s8,464(sp)
    80004178:	6cbe                	ld	s9,456(sp)
    8000417a:	6d1e                	ld	s10,448(sp)
    8000417c:	7dfa                	ld	s11,440(sp)
    8000417e:	22010113          	addi	sp,sp,544
    80004182:	8082                	ret
    end_op();
    80004184:	fffff097          	auipc	ra,0xfffff
    80004188:	476080e7          	jalr	1142(ra) # 800035fa <end_op>
    return -1;
    8000418c:	557d                	li	a0,-1
    8000418e:	b7f9                	j	8000415c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004190:	8526                	mv	a0,s1
    80004192:	ffffd097          	auipc	ra,0xffffd
    80004196:	d80080e7          	jalr	-640(ra) # 80000f12 <proc_pagetable>
    8000419a:	8b2a                	mv	s6,a0
    8000419c:	d555                	beqz	a0,80004148 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000419e:	e7042783          	lw	a5,-400(s0)
    800041a2:	e8845703          	lhu	a4,-376(s0)
    800041a6:	c735                	beqz	a4,80004212 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041a8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041aa:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800041ae:	6a05                	lui	s4,0x1
    800041b0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041b4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041b8:	6d85                	lui	s11,0x1
    800041ba:	7d7d                	lui	s10,0xfffff
    800041bc:	a481                	j	800043fc <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041be:	00004517          	auipc	a0,0x4
    800041c2:	4da50513          	addi	a0,a0,1242 # 80008698 <syscalls+0x2c8>
    800041c6:	00002097          	auipc	ra,0x2
    800041ca:	a9a080e7          	jalr	-1382(ra) # 80005c60 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ce:	874a                	mv	a4,s2
    800041d0:	009c86bb          	addw	a3,s9,s1
    800041d4:	4581                	li	a1,0
    800041d6:	8556                	mv	a0,s5
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	c94080e7          	jalr	-876(ra) # 80002e6c <readi>
    800041e0:	2501                	sext.w	a0,a0
    800041e2:	1aa91a63          	bne	s2,a0,80004396 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    800041e6:	009d84bb          	addw	s1,s11,s1
    800041ea:	013d09bb          	addw	s3,s10,s3
    800041ee:	1f74f763          	bgeu	s1,s7,800043dc <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    800041f2:	02049593          	slli	a1,s1,0x20
    800041f6:	9181                	srli	a1,a1,0x20
    800041f8:	95e2                	add	a1,a1,s8
    800041fa:	855a                	mv	a0,s6
    800041fc:	ffffc097          	auipc	ra,0xffffc
    80004200:	306080e7          	jalr	774(ra) # 80000502 <walkaddr>
    80004204:	862a                	mv	a2,a0
    if(pa == 0)
    80004206:	dd45                	beqz	a0,800041be <exec+0xfe>
      n = PGSIZE;
    80004208:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000420a:	fd49f2e3          	bgeu	s3,s4,800041ce <exec+0x10e>
      n = sz - i;
    8000420e:	894e                	mv	s2,s3
    80004210:	bf7d                	j	800041ce <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004212:	4901                	li	s2,0
  iunlockput(ip);
    80004214:	8556                	mv	a0,s5
    80004216:	fffff097          	auipc	ra,0xfffff
    8000421a:	c04080e7          	jalr	-1020(ra) # 80002e1a <iunlockput>
  end_op();
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	3dc080e7          	jalr	988(ra) # 800035fa <end_op>
  p = myproc();
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	c28080e7          	jalr	-984(ra) # 80000e4e <myproc>
    8000422e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004230:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004234:	6785                	lui	a5,0x1
    80004236:	17fd                	addi	a5,a5,-1
    80004238:	993e                	add	s2,s2,a5
    8000423a:	77fd                	lui	a5,0xfffff
    8000423c:	00f977b3          	and	a5,s2,a5
    80004240:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004244:	4691                	li	a3,4
    80004246:	6609                	lui	a2,0x2
    80004248:	963e                	add	a2,a2,a5
    8000424a:	85be                	mv	a1,a5
    8000424c:	855a                	mv	a0,s6
    8000424e:	ffffc097          	auipc	ra,0xffffc
    80004252:	668080e7          	jalr	1640(ra) # 800008b6 <uvmalloc>
    80004256:	8c2a                	mv	s8,a0
  ip = 0;
    80004258:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000425a:	12050e63          	beqz	a0,80004396 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000425e:	75f9                	lui	a1,0xffffe
    80004260:	95aa                	add	a1,a1,a0
    80004262:	855a                	mv	a0,s6
    80004264:	ffffd097          	auipc	ra,0xffffd
    80004268:	878080e7          	jalr	-1928(ra) # 80000adc <uvmclear>
  stackbase = sp - PGSIZE;
    8000426c:	7afd                	lui	s5,0xfffff
    8000426e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004270:	df043783          	ld	a5,-528(s0)
    80004274:	6388                	ld	a0,0(a5)
    80004276:	c925                	beqz	a0,800042e6 <exec+0x226>
    80004278:	e9040993          	addi	s3,s0,-368
    8000427c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004280:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004282:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004284:	ffffc097          	auipc	ra,0xffffc
    80004288:	070080e7          	jalr	112(ra) # 800002f4 <strlen>
    8000428c:	0015079b          	addiw	a5,a0,1
    80004290:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004294:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004298:	13596663          	bltu	s2,s5,800043c4 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000429c:	df043d83          	ld	s11,-528(s0)
    800042a0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042a4:	8552                	mv	a0,s4
    800042a6:	ffffc097          	auipc	ra,0xffffc
    800042aa:	04e080e7          	jalr	78(ra) # 800002f4 <strlen>
    800042ae:	0015069b          	addiw	a3,a0,1
    800042b2:	8652                	mv	a2,s4
    800042b4:	85ca                	mv	a1,s2
    800042b6:	855a                	mv	a0,s6
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	856080e7          	jalr	-1962(ra) # 80000b0e <copyout>
    800042c0:	10054663          	bltz	a0,800043cc <exec+0x30c>
    ustack[argc] = sp;
    800042c4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042c8:	0485                	addi	s1,s1,1
    800042ca:	008d8793          	addi	a5,s11,8
    800042ce:	def43823          	sd	a5,-528(s0)
    800042d2:	008db503          	ld	a0,8(s11)
    800042d6:	c911                	beqz	a0,800042ea <exec+0x22a>
    if(argc >= MAXARG)
    800042d8:	09a1                	addi	s3,s3,8
    800042da:	fb3c95e3          	bne	s9,s3,80004284 <exec+0x1c4>
  sz = sz1;
    800042de:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042e2:	4a81                	li	s5,0
    800042e4:	a84d                	j	80004396 <exec+0x2d6>
  sp = sz;
    800042e6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042e8:	4481                	li	s1,0
  ustack[argc] = 0;
    800042ea:	00349793          	slli	a5,s1,0x3
    800042ee:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdcff0>
    800042f2:	97a2                	add	a5,a5,s0
    800042f4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042f8:	00148693          	addi	a3,s1,1
    800042fc:	068e                	slli	a3,a3,0x3
    800042fe:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004302:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004306:	01597663          	bgeu	s2,s5,80004312 <exec+0x252>
  sz = sz1;
    8000430a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000430e:	4a81                	li	s5,0
    80004310:	a059                	j	80004396 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004312:	e9040613          	addi	a2,s0,-368
    80004316:	85ca                	mv	a1,s2
    80004318:	855a                	mv	a0,s6
    8000431a:	ffffc097          	auipc	ra,0xffffc
    8000431e:	7f4080e7          	jalr	2036(ra) # 80000b0e <copyout>
    80004322:	0a054963          	bltz	a0,800043d4 <exec+0x314>
  p->trapframe->a1 = sp;
    80004326:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000432a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000432e:	de843783          	ld	a5,-536(s0)
    80004332:	0007c703          	lbu	a4,0(a5)
    80004336:	cf11                	beqz	a4,80004352 <exec+0x292>
    80004338:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000433a:	02f00693          	li	a3,47
    8000433e:	a039                	j	8000434c <exec+0x28c>
      last = s+1;
    80004340:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004344:	0785                	addi	a5,a5,1
    80004346:	fff7c703          	lbu	a4,-1(a5)
    8000434a:	c701                	beqz	a4,80004352 <exec+0x292>
    if(*s == '/')
    8000434c:	fed71ce3          	bne	a4,a3,80004344 <exec+0x284>
    80004350:	bfc5                	j	80004340 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004352:	4641                	li	a2,16
    80004354:	de843583          	ld	a1,-536(s0)
    80004358:	158b8513          	addi	a0,s7,344
    8000435c:	ffffc097          	auipc	ra,0xffffc
    80004360:	f66080e7          	jalr	-154(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004364:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004368:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000436c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004370:	058bb783          	ld	a5,88(s7)
    80004374:	e6843703          	ld	a4,-408(s0)
    80004378:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000437a:	058bb783          	ld	a5,88(s7)
    8000437e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004382:	85ea                	mv	a1,s10
    80004384:	ffffd097          	auipc	ra,0xffffd
    80004388:	c84080e7          	jalr	-892(ra) # 80001008 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000438c:	0004851b          	sext.w	a0,s1
    80004390:	b3f1                	j	8000415c <exec+0x9c>
    80004392:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004396:	df843583          	ld	a1,-520(s0)
    8000439a:	855a                	mv	a0,s6
    8000439c:	ffffd097          	auipc	ra,0xffffd
    800043a0:	c6c080e7          	jalr	-916(ra) # 80001008 <proc_freepagetable>
  if(ip){
    800043a4:	da0a92e3          	bnez	s5,80004148 <exec+0x88>
  return -1;
    800043a8:	557d                	li	a0,-1
    800043aa:	bb4d                	j	8000415c <exec+0x9c>
    800043ac:	df243c23          	sd	s2,-520(s0)
    800043b0:	b7dd                	j	80004396 <exec+0x2d6>
    800043b2:	df243c23          	sd	s2,-520(s0)
    800043b6:	b7c5                	j	80004396 <exec+0x2d6>
    800043b8:	df243c23          	sd	s2,-520(s0)
    800043bc:	bfe9                	j	80004396 <exec+0x2d6>
    800043be:	df243c23          	sd	s2,-520(s0)
    800043c2:	bfd1                	j	80004396 <exec+0x2d6>
  sz = sz1;
    800043c4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043c8:	4a81                	li	s5,0
    800043ca:	b7f1                	j	80004396 <exec+0x2d6>
  sz = sz1;
    800043cc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043d0:	4a81                	li	s5,0
    800043d2:	b7d1                	j	80004396 <exec+0x2d6>
  sz = sz1;
    800043d4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043d8:	4a81                	li	s5,0
    800043da:	bf75                	j	80004396 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043dc:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043e0:	e0843783          	ld	a5,-504(s0)
    800043e4:	0017869b          	addiw	a3,a5,1
    800043e8:	e0d43423          	sd	a3,-504(s0)
    800043ec:	e0043783          	ld	a5,-512(s0)
    800043f0:	0387879b          	addiw	a5,a5,56
    800043f4:	e8845703          	lhu	a4,-376(s0)
    800043f8:	e0e6dee3          	bge	a3,a4,80004214 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043fc:	2781                	sext.w	a5,a5
    800043fe:	e0f43023          	sd	a5,-512(s0)
    80004402:	03800713          	li	a4,56
    80004406:	86be                	mv	a3,a5
    80004408:	e1840613          	addi	a2,s0,-488
    8000440c:	4581                	li	a1,0
    8000440e:	8556                	mv	a0,s5
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	a5c080e7          	jalr	-1444(ra) # 80002e6c <readi>
    80004418:	03800793          	li	a5,56
    8000441c:	f6f51be3          	bne	a0,a5,80004392 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    80004420:	e1842783          	lw	a5,-488(s0)
    80004424:	4705                	li	a4,1
    80004426:	fae79de3          	bne	a5,a4,800043e0 <exec+0x320>
    if(ph.memsz < ph.filesz)
    8000442a:	e4043483          	ld	s1,-448(s0)
    8000442e:	e3843783          	ld	a5,-456(s0)
    80004432:	f6f4ede3          	bltu	s1,a5,800043ac <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004436:	e2843783          	ld	a5,-472(s0)
    8000443a:	94be                	add	s1,s1,a5
    8000443c:	f6f4ebe3          	bltu	s1,a5,800043b2 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80004440:	de043703          	ld	a4,-544(s0)
    80004444:	8ff9                	and	a5,a5,a4
    80004446:	fbad                	bnez	a5,800043b8 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004448:	e1c42503          	lw	a0,-484(s0)
    8000444c:	00000097          	auipc	ra,0x0
    80004450:	c58080e7          	jalr	-936(ra) # 800040a4 <flags2perm>
    80004454:	86aa                	mv	a3,a0
    80004456:	8626                	mv	a2,s1
    80004458:	85ca                	mv	a1,s2
    8000445a:	855a                	mv	a0,s6
    8000445c:	ffffc097          	auipc	ra,0xffffc
    80004460:	45a080e7          	jalr	1114(ra) # 800008b6 <uvmalloc>
    80004464:	dea43c23          	sd	a0,-520(s0)
    80004468:	d939                	beqz	a0,800043be <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000446a:	e2843c03          	ld	s8,-472(s0)
    8000446e:	e2042c83          	lw	s9,-480(s0)
    80004472:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004476:	f60b83e3          	beqz	s7,800043dc <exec+0x31c>
    8000447a:	89de                	mv	s3,s7
    8000447c:	4481                	li	s1,0
    8000447e:	bb95                	j	800041f2 <exec+0x132>

0000000080004480 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004480:	7179                	addi	sp,sp,-48
    80004482:	f406                	sd	ra,40(sp)
    80004484:	f022                	sd	s0,32(sp)
    80004486:	ec26                	sd	s1,24(sp)
    80004488:	e84a                	sd	s2,16(sp)
    8000448a:	1800                	addi	s0,sp,48
    8000448c:	892e                	mv	s2,a1
    8000448e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004490:	fdc40593          	addi	a1,s0,-36
    80004494:	ffffe097          	auipc	ra,0xffffe
    80004498:	baa080e7          	jalr	-1110(ra) # 8000203e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000449c:	fdc42703          	lw	a4,-36(s0)
    800044a0:	47bd                	li	a5,15
    800044a2:	02e7eb63          	bltu	a5,a4,800044d8 <argfd+0x58>
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	9a8080e7          	jalr	-1624(ra) # 80000e4e <myproc>
    800044ae:	fdc42703          	lw	a4,-36(s0)
    800044b2:	01a70793          	addi	a5,a4,26
    800044b6:	078e                	slli	a5,a5,0x3
    800044b8:	953e                	add	a0,a0,a5
    800044ba:	611c                	ld	a5,0(a0)
    800044bc:	c385                	beqz	a5,800044dc <argfd+0x5c>
    return -1;
  if(pfd)
    800044be:	00090463          	beqz	s2,800044c6 <argfd+0x46>
    *pfd = fd;
    800044c2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044c6:	4501                	li	a0,0
  if(pf)
    800044c8:	c091                	beqz	s1,800044cc <argfd+0x4c>
    *pf = f;
    800044ca:	e09c                	sd	a5,0(s1)
}
    800044cc:	70a2                	ld	ra,40(sp)
    800044ce:	7402                	ld	s0,32(sp)
    800044d0:	64e2                	ld	s1,24(sp)
    800044d2:	6942                	ld	s2,16(sp)
    800044d4:	6145                	addi	sp,sp,48
    800044d6:	8082                	ret
    return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	bfcd                	j	800044cc <argfd+0x4c>
    800044dc:	557d                	li	a0,-1
    800044de:	b7fd                	j	800044cc <argfd+0x4c>

00000000800044e0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044e0:	1101                	addi	sp,sp,-32
    800044e2:	ec06                	sd	ra,24(sp)
    800044e4:	e822                	sd	s0,16(sp)
    800044e6:	e426                	sd	s1,8(sp)
    800044e8:	1000                	addi	s0,sp,32
    800044ea:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ec:	ffffd097          	auipc	ra,0xffffd
    800044f0:	962080e7          	jalr	-1694(ra) # 80000e4e <myproc>
    800044f4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044f6:	0d050793          	addi	a5,a0,208
    800044fa:	4501                	li	a0,0
    800044fc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044fe:	6398                	ld	a4,0(a5)
    80004500:	cb19                	beqz	a4,80004516 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004502:	2505                	addiw	a0,a0,1
    80004504:	07a1                	addi	a5,a5,8
    80004506:	fed51ce3          	bne	a0,a3,800044fe <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000450a:	557d                	li	a0,-1
}
    8000450c:	60e2                	ld	ra,24(sp)
    8000450e:	6442                	ld	s0,16(sp)
    80004510:	64a2                	ld	s1,8(sp)
    80004512:	6105                	addi	sp,sp,32
    80004514:	8082                	ret
      p->ofile[fd] = f;
    80004516:	01a50793          	addi	a5,a0,26
    8000451a:	078e                	slli	a5,a5,0x3
    8000451c:	963e                	add	a2,a2,a5
    8000451e:	e204                	sd	s1,0(a2)
      return fd;
    80004520:	b7f5                	j	8000450c <fdalloc+0x2c>

0000000080004522 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004522:	715d                	addi	sp,sp,-80
    80004524:	e486                	sd	ra,72(sp)
    80004526:	e0a2                	sd	s0,64(sp)
    80004528:	fc26                	sd	s1,56(sp)
    8000452a:	f84a                	sd	s2,48(sp)
    8000452c:	f44e                	sd	s3,40(sp)
    8000452e:	f052                	sd	s4,32(sp)
    80004530:	ec56                	sd	s5,24(sp)
    80004532:	e85a                	sd	s6,16(sp)
    80004534:	0880                	addi	s0,sp,80
    80004536:	8b2e                	mv	s6,a1
    80004538:	89b2                	mv	s3,a2
    8000453a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000453c:	fb040593          	addi	a1,s0,-80
    80004540:	fffff097          	auipc	ra,0xfffff
    80004544:	e3c080e7          	jalr	-452(ra) # 8000337c <nameiparent>
    80004548:	84aa                	mv	s1,a0
    8000454a:	14050f63          	beqz	a0,800046a8 <create+0x186>
    return 0;

  ilock(dp);
    8000454e:	ffffe097          	auipc	ra,0xffffe
    80004552:	66a080e7          	jalr	1642(ra) # 80002bb8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004556:	4601                	li	a2,0
    80004558:	fb040593          	addi	a1,s0,-80
    8000455c:	8526                	mv	a0,s1
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	b3e080e7          	jalr	-1218(ra) # 8000309c <dirlookup>
    80004566:	8aaa                	mv	s5,a0
    80004568:	c931                	beqz	a0,800045bc <create+0x9a>
    iunlockput(dp);
    8000456a:	8526                	mv	a0,s1
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	8ae080e7          	jalr	-1874(ra) # 80002e1a <iunlockput>
    ilock(ip);
    80004574:	8556                	mv	a0,s5
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	642080e7          	jalr	1602(ra) # 80002bb8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000457e:	000b059b          	sext.w	a1,s6
    80004582:	4789                	li	a5,2
    80004584:	02f59563          	bne	a1,a5,800045ae <create+0x8c>
    80004588:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd0a4>
    8000458c:	37f9                	addiw	a5,a5,-2
    8000458e:	17c2                	slli	a5,a5,0x30
    80004590:	93c1                	srli	a5,a5,0x30
    80004592:	4705                	li	a4,1
    80004594:	00f76d63          	bltu	a4,a5,800045ae <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004598:	8556                	mv	a0,s5
    8000459a:	60a6                	ld	ra,72(sp)
    8000459c:	6406                	ld	s0,64(sp)
    8000459e:	74e2                	ld	s1,56(sp)
    800045a0:	7942                	ld	s2,48(sp)
    800045a2:	79a2                	ld	s3,40(sp)
    800045a4:	7a02                	ld	s4,32(sp)
    800045a6:	6ae2                	ld	s5,24(sp)
    800045a8:	6b42                	ld	s6,16(sp)
    800045aa:	6161                	addi	sp,sp,80
    800045ac:	8082                	ret
    iunlockput(ip);
    800045ae:	8556                	mv	a0,s5
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	86a080e7          	jalr	-1942(ra) # 80002e1a <iunlockput>
    return 0;
    800045b8:	4a81                	li	s5,0
    800045ba:	bff9                	j	80004598 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045bc:	85da                	mv	a1,s6
    800045be:	4088                	lw	a0,0(s1)
    800045c0:	ffffe097          	auipc	ra,0xffffe
    800045c4:	45c080e7          	jalr	1116(ra) # 80002a1c <ialloc>
    800045c8:	8a2a                	mv	s4,a0
    800045ca:	c539                	beqz	a0,80004618 <create+0xf6>
  ilock(ip);
    800045cc:	ffffe097          	auipc	ra,0xffffe
    800045d0:	5ec080e7          	jalr	1516(ra) # 80002bb8 <ilock>
  ip->major = major;
    800045d4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045d8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045dc:	4905                	li	s2,1
    800045de:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800045e2:	8552                	mv	a0,s4
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	50a080e7          	jalr	1290(ra) # 80002aee <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ec:	000b059b          	sext.w	a1,s6
    800045f0:	03258b63          	beq	a1,s2,80004626 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800045f4:	004a2603          	lw	a2,4(s4)
    800045f8:	fb040593          	addi	a1,s0,-80
    800045fc:	8526                	mv	a0,s1
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	cae080e7          	jalr	-850(ra) # 800032ac <dirlink>
    80004606:	06054f63          	bltz	a0,80004684 <create+0x162>
  iunlockput(dp);
    8000460a:	8526                	mv	a0,s1
    8000460c:	fffff097          	auipc	ra,0xfffff
    80004610:	80e080e7          	jalr	-2034(ra) # 80002e1a <iunlockput>
  return ip;
    80004614:	8ad2                	mv	s5,s4
    80004616:	b749                	j	80004598 <create+0x76>
    iunlockput(dp);
    80004618:	8526                	mv	a0,s1
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	800080e7          	jalr	-2048(ra) # 80002e1a <iunlockput>
    return 0;
    80004622:	8ad2                	mv	s5,s4
    80004624:	bf95                	j	80004598 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004626:	004a2603          	lw	a2,4(s4)
    8000462a:	00004597          	auipc	a1,0x4
    8000462e:	08e58593          	addi	a1,a1,142 # 800086b8 <syscalls+0x2e8>
    80004632:	8552                	mv	a0,s4
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	c78080e7          	jalr	-904(ra) # 800032ac <dirlink>
    8000463c:	04054463          	bltz	a0,80004684 <create+0x162>
    80004640:	40d0                	lw	a2,4(s1)
    80004642:	00004597          	auipc	a1,0x4
    80004646:	07e58593          	addi	a1,a1,126 # 800086c0 <syscalls+0x2f0>
    8000464a:	8552                	mv	a0,s4
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	c60080e7          	jalr	-928(ra) # 800032ac <dirlink>
    80004654:	02054863          	bltz	a0,80004684 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004658:	004a2603          	lw	a2,4(s4)
    8000465c:	fb040593          	addi	a1,s0,-80
    80004660:	8526                	mv	a0,s1
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	c4a080e7          	jalr	-950(ra) # 800032ac <dirlink>
    8000466a:	00054d63          	bltz	a0,80004684 <create+0x162>
    dp->nlink++;  // for ".."
    8000466e:	04a4d783          	lhu	a5,74(s1)
    80004672:	2785                	addiw	a5,a5,1
    80004674:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004678:	8526                	mv	a0,s1
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	474080e7          	jalr	1140(ra) # 80002aee <iupdate>
    80004682:	b761                	j	8000460a <create+0xe8>
  ip->nlink = 0;
    80004684:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004688:	8552                	mv	a0,s4
    8000468a:	ffffe097          	auipc	ra,0xffffe
    8000468e:	464080e7          	jalr	1124(ra) # 80002aee <iupdate>
  iunlockput(ip);
    80004692:	8552                	mv	a0,s4
    80004694:	ffffe097          	auipc	ra,0xffffe
    80004698:	786080e7          	jalr	1926(ra) # 80002e1a <iunlockput>
  iunlockput(dp);
    8000469c:	8526                	mv	a0,s1
    8000469e:	ffffe097          	auipc	ra,0xffffe
    800046a2:	77c080e7          	jalr	1916(ra) # 80002e1a <iunlockput>
  return 0;
    800046a6:	bdcd                	j	80004598 <create+0x76>
    return 0;
    800046a8:	8aaa                	mv	s5,a0
    800046aa:	b5fd                	j	80004598 <create+0x76>

00000000800046ac <sys_dup>:
{
    800046ac:	7179                	addi	sp,sp,-48
    800046ae:	f406                	sd	ra,40(sp)
    800046b0:	f022                	sd	s0,32(sp)
    800046b2:	ec26                	sd	s1,24(sp)
    800046b4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046b6:	fd840613          	addi	a2,s0,-40
    800046ba:	4581                	li	a1,0
    800046bc:	4501                	li	a0,0
    800046be:	00000097          	auipc	ra,0x0
    800046c2:	dc2080e7          	jalr	-574(ra) # 80004480 <argfd>
    return -1;
    800046c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046c8:	02054363          	bltz	a0,800046ee <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046cc:	fd843503          	ld	a0,-40(s0)
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	e10080e7          	jalr	-496(ra) # 800044e0 <fdalloc>
    800046d8:	84aa                	mv	s1,a0
    return -1;
    800046da:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046dc:	00054963          	bltz	a0,800046ee <sys_dup+0x42>
  filedup(f);
    800046e0:	fd843503          	ld	a0,-40(s0)
    800046e4:	fffff097          	auipc	ra,0xfffff
    800046e8:	310080e7          	jalr	784(ra) # 800039f4 <filedup>
  return fd;
    800046ec:	87a6                	mv	a5,s1
}
    800046ee:	853e                	mv	a0,a5
    800046f0:	70a2                	ld	ra,40(sp)
    800046f2:	7402                	ld	s0,32(sp)
    800046f4:	64e2                	ld	s1,24(sp)
    800046f6:	6145                	addi	sp,sp,48
    800046f8:	8082                	ret

00000000800046fa <sys_read>:
{
    800046fa:	7179                	addi	sp,sp,-48
    800046fc:	f406                	sd	ra,40(sp)
    800046fe:	f022                	sd	s0,32(sp)
    80004700:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004702:	fd840593          	addi	a1,s0,-40
    80004706:	4505                	li	a0,1
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	956080e7          	jalr	-1706(ra) # 8000205e <argaddr>
  argint(2, &n);
    80004710:	fe440593          	addi	a1,s0,-28
    80004714:	4509                	li	a0,2
    80004716:	ffffe097          	auipc	ra,0xffffe
    8000471a:	928080e7          	jalr	-1752(ra) # 8000203e <argint>
  if(argfd(0, 0, &f) < 0)
    8000471e:	fe840613          	addi	a2,s0,-24
    80004722:	4581                	li	a1,0
    80004724:	4501                	li	a0,0
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	d5a080e7          	jalr	-678(ra) # 80004480 <argfd>
    8000472e:	87aa                	mv	a5,a0
    return -1;
    80004730:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004732:	0007cc63          	bltz	a5,8000474a <sys_read+0x50>
  return fileread(f, p, n);
    80004736:	fe442603          	lw	a2,-28(s0)
    8000473a:	fd843583          	ld	a1,-40(s0)
    8000473e:	fe843503          	ld	a0,-24(s0)
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	43e080e7          	jalr	1086(ra) # 80003b80 <fileread>
}
    8000474a:	70a2                	ld	ra,40(sp)
    8000474c:	7402                	ld	s0,32(sp)
    8000474e:	6145                	addi	sp,sp,48
    80004750:	8082                	ret

0000000080004752 <sys_write>:
{
    80004752:	7179                	addi	sp,sp,-48
    80004754:	f406                	sd	ra,40(sp)
    80004756:	f022                	sd	s0,32(sp)
    80004758:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000475a:	fd840593          	addi	a1,s0,-40
    8000475e:	4505                	li	a0,1
    80004760:	ffffe097          	auipc	ra,0xffffe
    80004764:	8fe080e7          	jalr	-1794(ra) # 8000205e <argaddr>
  argint(2, &n);
    80004768:	fe440593          	addi	a1,s0,-28
    8000476c:	4509                	li	a0,2
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	8d0080e7          	jalr	-1840(ra) # 8000203e <argint>
  if(argfd(0, 0, &f) < 0)
    80004776:	fe840613          	addi	a2,s0,-24
    8000477a:	4581                	li	a1,0
    8000477c:	4501                	li	a0,0
    8000477e:	00000097          	auipc	ra,0x0
    80004782:	d02080e7          	jalr	-766(ra) # 80004480 <argfd>
    80004786:	87aa                	mv	a5,a0
    return -1;
    80004788:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000478a:	0007cc63          	bltz	a5,800047a2 <sys_write+0x50>
  return filewrite(f, p, n);
    8000478e:	fe442603          	lw	a2,-28(s0)
    80004792:	fd843583          	ld	a1,-40(s0)
    80004796:	fe843503          	ld	a0,-24(s0)
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	4a8080e7          	jalr	1192(ra) # 80003c42 <filewrite>
}
    800047a2:	70a2                	ld	ra,40(sp)
    800047a4:	7402                	ld	s0,32(sp)
    800047a6:	6145                	addi	sp,sp,48
    800047a8:	8082                	ret

00000000800047aa <sys_close>:
{
    800047aa:	1101                	addi	sp,sp,-32
    800047ac:	ec06                	sd	ra,24(sp)
    800047ae:	e822                	sd	s0,16(sp)
    800047b0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047b2:	fe040613          	addi	a2,s0,-32
    800047b6:	fec40593          	addi	a1,s0,-20
    800047ba:	4501                	li	a0,0
    800047bc:	00000097          	auipc	ra,0x0
    800047c0:	cc4080e7          	jalr	-828(ra) # 80004480 <argfd>
    return -1;
    800047c4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047c6:	02054463          	bltz	a0,800047ee <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	684080e7          	jalr	1668(ra) # 80000e4e <myproc>
    800047d2:	fec42783          	lw	a5,-20(s0)
    800047d6:	07e9                	addi	a5,a5,26
    800047d8:	078e                	slli	a5,a5,0x3
    800047da:	97aa                	add	a5,a5,a0
    800047dc:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047e0:	fe043503          	ld	a0,-32(s0)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	262080e7          	jalr	610(ra) # 80003a46 <fileclose>
  return 0;
    800047ec:	4781                	li	a5,0
}
    800047ee:	853e                	mv	a0,a5
    800047f0:	60e2                	ld	ra,24(sp)
    800047f2:	6442                	ld	s0,16(sp)
    800047f4:	6105                	addi	sp,sp,32
    800047f6:	8082                	ret

00000000800047f8 <sys_fstat>:
{
    800047f8:	1101                	addi	sp,sp,-32
    800047fa:	ec06                	sd	ra,24(sp)
    800047fc:	e822                	sd	s0,16(sp)
    800047fe:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004800:	fe040593          	addi	a1,s0,-32
    80004804:	4505                	li	a0,1
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	858080e7          	jalr	-1960(ra) # 8000205e <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000480e:	fe840613          	addi	a2,s0,-24
    80004812:	4581                	li	a1,0
    80004814:	4501                	li	a0,0
    80004816:	00000097          	auipc	ra,0x0
    8000481a:	c6a080e7          	jalr	-918(ra) # 80004480 <argfd>
    8000481e:	87aa                	mv	a5,a0
    return -1;
    80004820:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004822:	0007ca63          	bltz	a5,80004836 <sys_fstat+0x3e>
  return filestat(f, st);
    80004826:	fe043583          	ld	a1,-32(s0)
    8000482a:	fe843503          	ld	a0,-24(s0)
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	2e0080e7          	jalr	736(ra) # 80003b0e <filestat>
}
    80004836:	60e2                	ld	ra,24(sp)
    80004838:	6442                	ld	s0,16(sp)
    8000483a:	6105                	addi	sp,sp,32
    8000483c:	8082                	ret

000000008000483e <sys_link>:
{
    8000483e:	7169                	addi	sp,sp,-304
    80004840:	f606                	sd	ra,296(sp)
    80004842:	f222                	sd	s0,288(sp)
    80004844:	ee26                	sd	s1,280(sp)
    80004846:	ea4a                	sd	s2,272(sp)
    80004848:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000484a:	08000613          	li	a2,128
    8000484e:	ed040593          	addi	a1,s0,-304
    80004852:	4501                	li	a0,0
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	82a080e7          	jalr	-2006(ra) # 8000207e <argstr>
    return -1;
    8000485c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485e:	10054e63          	bltz	a0,8000497a <sys_link+0x13c>
    80004862:	08000613          	li	a2,128
    80004866:	f5040593          	addi	a1,s0,-176
    8000486a:	4505                	li	a0,1
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	812080e7          	jalr	-2030(ra) # 8000207e <argstr>
    return -1;
    80004874:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004876:	10054263          	bltz	a0,8000497a <sys_link+0x13c>
  begin_op();
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	d00080e7          	jalr	-768(ra) # 8000357a <begin_op>
  if((ip = namei(old)) == 0){
    80004882:	ed040513          	addi	a0,s0,-304
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	ad8080e7          	jalr	-1320(ra) # 8000335e <namei>
    8000488e:	84aa                	mv	s1,a0
    80004890:	c551                	beqz	a0,8000491c <sys_link+0xde>
  ilock(ip);
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	326080e7          	jalr	806(ra) # 80002bb8 <ilock>
  if(ip->type == T_DIR){
    8000489a:	04449703          	lh	a4,68(s1)
    8000489e:	4785                	li	a5,1
    800048a0:	08f70463          	beq	a4,a5,80004928 <sys_link+0xea>
  ip->nlink++;
    800048a4:	04a4d783          	lhu	a5,74(s1)
    800048a8:	2785                	addiw	a5,a5,1
    800048aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048ae:	8526                	mv	a0,s1
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	23e080e7          	jalr	574(ra) # 80002aee <iupdate>
  iunlock(ip);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	3c0080e7          	jalr	960(ra) # 80002c7a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048c2:	fd040593          	addi	a1,s0,-48
    800048c6:	f5040513          	addi	a0,s0,-176
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	ab2080e7          	jalr	-1358(ra) # 8000337c <nameiparent>
    800048d2:	892a                	mv	s2,a0
    800048d4:	c935                	beqz	a0,80004948 <sys_link+0x10a>
  ilock(dp);
    800048d6:	ffffe097          	auipc	ra,0xffffe
    800048da:	2e2080e7          	jalr	738(ra) # 80002bb8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048de:	00092703          	lw	a4,0(s2)
    800048e2:	409c                	lw	a5,0(s1)
    800048e4:	04f71d63          	bne	a4,a5,8000493e <sys_link+0x100>
    800048e8:	40d0                	lw	a2,4(s1)
    800048ea:	fd040593          	addi	a1,s0,-48
    800048ee:	854a                	mv	a0,s2
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	9bc080e7          	jalr	-1604(ra) # 800032ac <dirlink>
    800048f8:	04054363          	bltz	a0,8000493e <sys_link+0x100>
  iunlockput(dp);
    800048fc:	854a                	mv	a0,s2
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	51c080e7          	jalr	1308(ra) # 80002e1a <iunlockput>
  iput(ip);
    80004906:	8526                	mv	a0,s1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	46a080e7          	jalr	1130(ra) # 80002d72 <iput>
  end_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	cea080e7          	jalr	-790(ra) # 800035fa <end_op>
  return 0;
    80004918:	4781                	li	a5,0
    8000491a:	a085                	j	8000497a <sys_link+0x13c>
    end_op();
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	cde080e7          	jalr	-802(ra) # 800035fa <end_op>
    return -1;
    80004924:	57fd                	li	a5,-1
    80004926:	a891                	j	8000497a <sys_link+0x13c>
    iunlockput(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	4f0080e7          	jalr	1264(ra) # 80002e1a <iunlockput>
    end_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	cc8080e7          	jalr	-824(ra) # 800035fa <end_op>
    return -1;
    8000493a:	57fd                	li	a5,-1
    8000493c:	a83d                	j	8000497a <sys_link+0x13c>
    iunlockput(dp);
    8000493e:	854a                	mv	a0,s2
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	4da080e7          	jalr	1242(ra) # 80002e1a <iunlockput>
  ilock(ip);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	26e080e7          	jalr	622(ra) # 80002bb8 <ilock>
  ip->nlink--;
    80004952:	04a4d783          	lhu	a5,74(s1)
    80004956:	37fd                	addiw	a5,a5,-1
    80004958:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000495c:	8526                	mv	a0,s1
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	190080e7          	jalr	400(ra) # 80002aee <iupdate>
  iunlockput(ip);
    80004966:	8526                	mv	a0,s1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	4b2080e7          	jalr	1202(ra) # 80002e1a <iunlockput>
  end_op();
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	c8a080e7          	jalr	-886(ra) # 800035fa <end_op>
  return -1;
    80004978:	57fd                	li	a5,-1
}
    8000497a:	853e                	mv	a0,a5
    8000497c:	70b2                	ld	ra,296(sp)
    8000497e:	7412                	ld	s0,288(sp)
    80004980:	64f2                	ld	s1,280(sp)
    80004982:	6952                	ld	s2,272(sp)
    80004984:	6155                	addi	sp,sp,304
    80004986:	8082                	ret

0000000080004988 <sys_unlink>:
{
    80004988:	7151                	addi	sp,sp,-240
    8000498a:	f586                	sd	ra,232(sp)
    8000498c:	f1a2                	sd	s0,224(sp)
    8000498e:	eda6                	sd	s1,216(sp)
    80004990:	e9ca                	sd	s2,208(sp)
    80004992:	e5ce                	sd	s3,200(sp)
    80004994:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004996:	08000613          	li	a2,128
    8000499a:	f3040593          	addi	a1,s0,-208
    8000499e:	4501                	li	a0,0
    800049a0:	ffffd097          	auipc	ra,0xffffd
    800049a4:	6de080e7          	jalr	1758(ra) # 8000207e <argstr>
    800049a8:	18054163          	bltz	a0,80004b2a <sys_unlink+0x1a2>
  begin_op();
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	bce080e7          	jalr	-1074(ra) # 8000357a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049b4:	fb040593          	addi	a1,s0,-80
    800049b8:	f3040513          	addi	a0,s0,-208
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	9c0080e7          	jalr	-1600(ra) # 8000337c <nameiparent>
    800049c4:	84aa                	mv	s1,a0
    800049c6:	c979                	beqz	a0,80004a9c <sys_unlink+0x114>
  ilock(dp);
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	1f0080e7          	jalr	496(ra) # 80002bb8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049d0:	00004597          	auipc	a1,0x4
    800049d4:	ce858593          	addi	a1,a1,-792 # 800086b8 <syscalls+0x2e8>
    800049d8:	fb040513          	addi	a0,s0,-80
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	6a6080e7          	jalr	1702(ra) # 80003082 <namecmp>
    800049e4:	14050a63          	beqz	a0,80004b38 <sys_unlink+0x1b0>
    800049e8:	00004597          	auipc	a1,0x4
    800049ec:	cd858593          	addi	a1,a1,-808 # 800086c0 <syscalls+0x2f0>
    800049f0:	fb040513          	addi	a0,s0,-80
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	68e080e7          	jalr	1678(ra) # 80003082 <namecmp>
    800049fc:	12050e63          	beqz	a0,80004b38 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a00:	f2c40613          	addi	a2,s0,-212
    80004a04:	fb040593          	addi	a1,s0,-80
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	692080e7          	jalr	1682(ra) # 8000309c <dirlookup>
    80004a12:	892a                	mv	s2,a0
    80004a14:	12050263          	beqz	a0,80004b38 <sys_unlink+0x1b0>
  ilock(ip);
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	1a0080e7          	jalr	416(ra) # 80002bb8 <ilock>
  if(ip->nlink < 1)
    80004a20:	04a91783          	lh	a5,74(s2)
    80004a24:	08f05263          	blez	a5,80004aa8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a28:	04491703          	lh	a4,68(s2)
    80004a2c:	4785                	li	a5,1
    80004a2e:	08f70563          	beq	a4,a5,80004ab8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a32:	4641                	li	a2,16
    80004a34:	4581                	li	a1,0
    80004a36:	fc040513          	addi	a0,s0,-64
    80004a3a:	ffffb097          	auipc	ra,0xffffb
    80004a3e:	73e080e7          	jalr	1854(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a42:	4741                	li	a4,16
    80004a44:	f2c42683          	lw	a3,-212(s0)
    80004a48:	fc040613          	addi	a2,s0,-64
    80004a4c:	4581                	li	a1,0
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	514080e7          	jalr	1300(ra) # 80002f64 <writei>
    80004a58:	47c1                	li	a5,16
    80004a5a:	0af51563          	bne	a0,a5,80004b04 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a5e:	04491703          	lh	a4,68(s2)
    80004a62:	4785                	li	a5,1
    80004a64:	0af70863          	beq	a4,a5,80004b14 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	3b0080e7          	jalr	944(ra) # 80002e1a <iunlockput>
  ip->nlink--;
    80004a72:	04a95783          	lhu	a5,74(s2)
    80004a76:	37fd                	addiw	a5,a5,-1
    80004a78:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a7c:	854a                	mv	a0,s2
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	070080e7          	jalr	112(ra) # 80002aee <iupdate>
  iunlockput(ip);
    80004a86:	854a                	mv	a0,s2
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	392080e7          	jalr	914(ra) # 80002e1a <iunlockput>
  end_op();
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	b6a080e7          	jalr	-1174(ra) # 800035fa <end_op>
  return 0;
    80004a98:	4501                	li	a0,0
    80004a9a:	a84d                	j	80004b4c <sys_unlink+0x1c4>
    end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	b5e080e7          	jalr	-1186(ra) # 800035fa <end_op>
    return -1;
    80004aa4:	557d                	li	a0,-1
    80004aa6:	a05d                	j	80004b4c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aa8:	00004517          	auipc	a0,0x4
    80004aac:	c2050513          	addi	a0,a0,-992 # 800086c8 <syscalls+0x2f8>
    80004ab0:	00001097          	auipc	ra,0x1
    80004ab4:	1b0080e7          	jalr	432(ra) # 80005c60 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ab8:	04c92703          	lw	a4,76(s2)
    80004abc:	02000793          	li	a5,32
    80004ac0:	f6e7f9e3          	bgeu	a5,a4,80004a32 <sys_unlink+0xaa>
    80004ac4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ac8:	4741                	li	a4,16
    80004aca:	86ce                	mv	a3,s3
    80004acc:	f1840613          	addi	a2,s0,-232
    80004ad0:	4581                	li	a1,0
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	398080e7          	jalr	920(ra) # 80002e6c <readi>
    80004adc:	47c1                	li	a5,16
    80004ade:	00f51b63          	bne	a0,a5,80004af4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ae2:	f1845783          	lhu	a5,-232(s0)
    80004ae6:	e7a1                	bnez	a5,80004b2e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae8:	29c1                	addiw	s3,s3,16
    80004aea:	04c92783          	lw	a5,76(s2)
    80004aee:	fcf9ede3          	bltu	s3,a5,80004ac8 <sys_unlink+0x140>
    80004af2:	b781                	j	80004a32 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004af4:	00004517          	auipc	a0,0x4
    80004af8:	bec50513          	addi	a0,a0,-1044 # 800086e0 <syscalls+0x310>
    80004afc:	00001097          	auipc	ra,0x1
    80004b00:	164080e7          	jalr	356(ra) # 80005c60 <panic>
    panic("unlink: writei");
    80004b04:	00004517          	auipc	a0,0x4
    80004b08:	bf450513          	addi	a0,a0,-1036 # 800086f8 <syscalls+0x328>
    80004b0c:	00001097          	auipc	ra,0x1
    80004b10:	154080e7          	jalr	340(ra) # 80005c60 <panic>
    dp->nlink--;
    80004b14:	04a4d783          	lhu	a5,74(s1)
    80004b18:	37fd                	addiw	a5,a5,-1
    80004b1a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b1e:	8526                	mv	a0,s1
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	fce080e7          	jalr	-50(ra) # 80002aee <iupdate>
    80004b28:	b781                	j	80004a68 <sys_unlink+0xe0>
    return -1;
    80004b2a:	557d                	li	a0,-1
    80004b2c:	a005                	j	80004b4c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	2ea080e7          	jalr	746(ra) # 80002e1a <iunlockput>
  iunlockput(dp);
    80004b38:	8526                	mv	a0,s1
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	2e0080e7          	jalr	736(ra) # 80002e1a <iunlockput>
  end_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	ab8080e7          	jalr	-1352(ra) # 800035fa <end_op>
  return -1;
    80004b4a:	557d                	li	a0,-1
}
    80004b4c:	70ae                	ld	ra,232(sp)
    80004b4e:	740e                	ld	s0,224(sp)
    80004b50:	64ee                	ld	s1,216(sp)
    80004b52:	694e                	ld	s2,208(sp)
    80004b54:	69ae                	ld	s3,200(sp)
    80004b56:	616d                	addi	sp,sp,240
    80004b58:	8082                	ret

0000000080004b5a <sys_open>:

uint64
sys_open(void)
{
    80004b5a:	7131                	addi	sp,sp,-192
    80004b5c:	fd06                	sd	ra,184(sp)
    80004b5e:	f922                	sd	s0,176(sp)
    80004b60:	f526                	sd	s1,168(sp)
    80004b62:	f14a                	sd	s2,160(sp)
    80004b64:	ed4e                	sd	s3,152(sp)
    80004b66:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b68:	f4c40593          	addi	a1,s0,-180
    80004b6c:	4505                	li	a0,1
    80004b6e:	ffffd097          	auipc	ra,0xffffd
    80004b72:	4d0080e7          	jalr	1232(ra) # 8000203e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b76:	08000613          	li	a2,128
    80004b7a:	f5040593          	addi	a1,s0,-176
    80004b7e:	4501                	li	a0,0
    80004b80:	ffffd097          	auipc	ra,0xffffd
    80004b84:	4fe080e7          	jalr	1278(ra) # 8000207e <argstr>
    80004b88:	87aa                	mv	a5,a0
    return -1;
    80004b8a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b8c:	0a07c963          	bltz	a5,80004c3e <sys_open+0xe4>

  begin_op();
    80004b90:	fffff097          	auipc	ra,0xfffff
    80004b94:	9ea080e7          	jalr	-1558(ra) # 8000357a <begin_op>

  if(omode & O_CREATE){
    80004b98:	f4c42783          	lw	a5,-180(s0)
    80004b9c:	2007f793          	andi	a5,a5,512
    80004ba0:	cfc5                	beqz	a5,80004c58 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ba2:	4681                	li	a3,0
    80004ba4:	4601                	li	a2,0
    80004ba6:	4589                	li	a1,2
    80004ba8:	f5040513          	addi	a0,s0,-176
    80004bac:	00000097          	auipc	ra,0x0
    80004bb0:	976080e7          	jalr	-1674(ra) # 80004522 <create>
    80004bb4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004bb6:	c959                	beqz	a0,80004c4c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bb8:	04449703          	lh	a4,68(s1)
    80004bbc:	478d                	li	a5,3
    80004bbe:	00f71763          	bne	a4,a5,80004bcc <sys_open+0x72>
    80004bc2:	0464d703          	lhu	a4,70(s1)
    80004bc6:	47a5                	li	a5,9
    80004bc8:	0ce7ed63          	bltu	a5,a4,80004ca2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	dbe080e7          	jalr	-578(ra) # 8000398a <filealloc>
    80004bd4:	89aa                	mv	s3,a0
    80004bd6:	10050363          	beqz	a0,80004cdc <sys_open+0x182>
    80004bda:	00000097          	auipc	ra,0x0
    80004bde:	906080e7          	jalr	-1786(ra) # 800044e0 <fdalloc>
    80004be2:	892a                	mv	s2,a0
    80004be4:	0e054763          	bltz	a0,80004cd2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004be8:	04449703          	lh	a4,68(s1)
    80004bec:	478d                	li	a5,3
    80004bee:	0cf70563          	beq	a4,a5,80004cb8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bf2:	4789                	li	a5,2
    80004bf4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bf8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bfc:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c00:	f4c42783          	lw	a5,-180(s0)
    80004c04:	0017c713          	xori	a4,a5,1
    80004c08:	8b05                	andi	a4,a4,1
    80004c0a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c0e:	0037f713          	andi	a4,a5,3
    80004c12:	00e03733          	snez	a4,a4
    80004c16:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c1a:	4007f793          	andi	a5,a5,1024
    80004c1e:	c791                	beqz	a5,80004c2a <sys_open+0xd0>
    80004c20:	04449703          	lh	a4,68(s1)
    80004c24:	4789                	li	a5,2
    80004c26:	0af70063          	beq	a4,a5,80004cc6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	04e080e7          	jalr	78(ra) # 80002c7a <iunlock>
  end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	9c6080e7          	jalr	-1594(ra) # 800035fa <end_op>

  return fd;
    80004c3c:	854a                	mv	a0,s2
}
    80004c3e:	70ea                	ld	ra,184(sp)
    80004c40:	744a                	ld	s0,176(sp)
    80004c42:	74aa                	ld	s1,168(sp)
    80004c44:	790a                	ld	s2,160(sp)
    80004c46:	69ea                	ld	s3,152(sp)
    80004c48:	6129                	addi	sp,sp,192
    80004c4a:	8082                	ret
      end_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	9ae080e7          	jalr	-1618(ra) # 800035fa <end_op>
      return -1;
    80004c54:	557d                	li	a0,-1
    80004c56:	b7e5                	j	80004c3e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c58:	f5040513          	addi	a0,s0,-176
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	702080e7          	jalr	1794(ra) # 8000335e <namei>
    80004c64:	84aa                	mv	s1,a0
    80004c66:	c905                	beqz	a0,80004c96 <sys_open+0x13c>
    ilock(ip);
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	f50080e7          	jalr	-176(ra) # 80002bb8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c70:	04449703          	lh	a4,68(s1)
    80004c74:	4785                	li	a5,1
    80004c76:	f4f711e3          	bne	a4,a5,80004bb8 <sys_open+0x5e>
    80004c7a:	f4c42783          	lw	a5,-180(s0)
    80004c7e:	d7b9                	beqz	a5,80004bcc <sys_open+0x72>
      iunlockput(ip);
    80004c80:	8526                	mv	a0,s1
    80004c82:	ffffe097          	auipc	ra,0xffffe
    80004c86:	198080e7          	jalr	408(ra) # 80002e1a <iunlockput>
      end_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	970080e7          	jalr	-1680(ra) # 800035fa <end_op>
      return -1;
    80004c92:	557d                	li	a0,-1
    80004c94:	b76d                	j	80004c3e <sys_open+0xe4>
      end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	964080e7          	jalr	-1692(ra) # 800035fa <end_op>
      return -1;
    80004c9e:	557d                	li	a0,-1
    80004ca0:	bf79                	j	80004c3e <sys_open+0xe4>
    iunlockput(ip);
    80004ca2:	8526                	mv	a0,s1
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	176080e7          	jalr	374(ra) # 80002e1a <iunlockput>
    end_op();
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	94e080e7          	jalr	-1714(ra) # 800035fa <end_op>
    return -1;
    80004cb4:	557d                	li	a0,-1
    80004cb6:	b761                	j	80004c3e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cb8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cbc:	04649783          	lh	a5,70(s1)
    80004cc0:	02f99223          	sh	a5,36(s3)
    80004cc4:	bf25                	j	80004bfc <sys_open+0xa2>
    itrunc(ip);
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	ffe080e7          	jalr	-2(ra) # 80002cc6 <itrunc>
    80004cd0:	bfa9                	j	80004c2a <sys_open+0xd0>
      fileclose(f);
    80004cd2:	854e                	mv	a0,s3
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	d72080e7          	jalr	-654(ra) # 80003a46 <fileclose>
    iunlockput(ip);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	13c080e7          	jalr	316(ra) # 80002e1a <iunlockput>
    end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	914080e7          	jalr	-1772(ra) # 800035fa <end_op>
    return -1;
    80004cee:	557d                	li	a0,-1
    80004cf0:	b7b9                	j	80004c3e <sys_open+0xe4>

0000000080004cf2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cf2:	7175                	addi	sp,sp,-144
    80004cf4:	e506                	sd	ra,136(sp)
    80004cf6:	e122                	sd	s0,128(sp)
    80004cf8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	880080e7          	jalr	-1920(ra) # 8000357a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d02:	08000613          	li	a2,128
    80004d06:	f7040593          	addi	a1,s0,-144
    80004d0a:	4501                	li	a0,0
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	372080e7          	jalr	882(ra) # 8000207e <argstr>
    80004d14:	02054963          	bltz	a0,80004d46 <sys_mkdir+0x54>
    80004d18:	4681                	li	a3,0
    80004d1a:	4601                	li	a2,0
    80004d1c:	4585                	li	a1,1
    80004d1e:	f7040513          	addi	a0,s0,-144
    80004d22:	00000097          	auipc	ra,0x0
    80004d26:	800080e7          	jalr	-2048(ra) # 80004522 <create>
    80004d2a:	cd11                	beqz	a0,80004d46 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	0ee080e7          	jalr	238(ra) # 80002e1a <iunlockput>
  end_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	8c6080e7          	jalr	-1850(ra) # 800035fa <end_op>
  return 0;
    80004d3c:	4501                	li	a0,0
}
    80004d3e:	60aa                	ld	ra,136(sp)
    80004d40:	640a                	ld	s0,128(sp)
    80004d42:	6149                	addi	sp,sp,144
    80004d44:	8082                	ret
    end_op();
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	8b4080e7          	jalr	-1868(ra) # 800035fa <end_op>
    return -1;
    80004d4e:	557d                	li	a0,-1
    80004d50:	b7fd                	j	80004d3e <sys_mkdir+0x4c>

0000000080004d52 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d52:	7135                	addi	sp,sp,-160
    80004d54:	ed06                	sd	ra,152(sp)
    80004d56:	e922                	sd	s0,144(sp)
    80004d58:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	820080e7          	jalr	-2016(ra) # 8000357a <begin_op>
  argint(1, &major);
    80004d62:	f6c40593          	addi	a1,s0,-148
    80004d66:	4505                	li	a0,1
    80004d68:	ffffd097          	auipc	ra,0xffffd
    80004d6c:	2d6080e7          	jalr	726(ra) # 8000203e <argint>
  argint(2, &minor);
    80004d70:	f6840593          	addi	a1,s0,-152
    80004d74:	4509                	li	a0,2
    80004d76:	ffffd097          	auipc	ra,0xffffd
    80004d7a:	2c8080e7          	jalr	712(ra) # 8000203e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d7e:	08000613          	li	a2,128
    80004d82:	f7040593          	addi	a1,s0,-144
    80004d86:	4501                	li	a0,0
    80004d88:	ffffd097          	auipc	ra,0xffffd
    80004d8c:	2f6080e7          	jalr	758(ra) # 8000207e <argstr>
    80004d90:	02054b63          	bltz	a0,80004dc6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d94:	f6841683          	lh	a3,-152(s0)
    80004d98:	f6c41603          	lh	a2,-148(s0)
    80004d9c:	458d                	li	a1,3
    80004d9e:	f7040513          	addi	a0,s0,-144
    80004da2:	fffff097          	auipc	ra,0xfffff
    80004da6:	780080e7          	jalr	1920(ra) # 80004522 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004daa:	cd11                	beqz	a0,80004dc6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	06e080e7          	jalr	110(ra) # 80002e1a <iunlockput>
  end_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	846080e7          	jalr	-1978(ra) # 800035fa <end_op>
  return 0;
    80004dbc:	4501                	li	a0,0
}
    80004dbe:	60ea                	ld	ra,152(sp)
    80004dc0:	644a                	ld	s0,144(sp)
    80004dc2:	610d                	addi	sp,sp,160
    80004dc4:	8082                	ret
    end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	834080e7          	jalr	-1996(ra) # 800035fa <end_op>
    return -1;
    80004dce:	557d                	li	a0,-1
    80004dd0:	b7fd                	j	80004dbe <sys_mknod+0x6c>

0000000080004dd2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dd2:	7135                	addi	sp,sp,-160
    80004dd4:	ed06                	sd	ra,152(sp)
    80004dd6:	e922                	sd	s0,144(sp)
    80004dd8:	e526                	sd	s1,136(sp)
    80004dda:	e14a                	sd	s2,128(sp)
    80004ddc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dde:	ffffc097          	auipc	ra,0xffffc
    80004de2:	070080e7          	jalr	112(ra) # 80000e4e <myproc>
    80004de6:	892a                	mv	s2,a0
  
  begin_op();
    80004de8:	ffffe097          	auipc	ra,0xffffe
    80004dec:	792080e7          	jalr	1938(ra) # 8000357a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004df0:	08000613          	li	a2,128
    80004df4:	f6040593          	addi	a1,s0,-160
    80004df8:	4501                	li	a0,0
    80004dfa:	ffffd097          	auipc	ra,0xffffd
    80004dfe:	284080e7          	jalr	644(ra) # 8000207e <argstr>
    80004e02:	04054b63          	bltz	a0,80004e58 <sys_chdir+0x86>
    80004e06:	f6040513          	addi	a0,s0,-160
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	554080e7          	jalr	1364(ra) # 8000335e <namei>
    80004e12:	84aa                	mv	s1,a0
    80004e14:	c131                	beqz	a0,80004e58 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	da2080e7          	jalr	-606(ra) # 80002bb8 <ilock>
  if(ip->type != T_DIR){
    80004e1e:	04449703          	lh	a4,68(s1)
    80004e22:	4785                	li	a5,1
    80004e24:	04f71063          	bne	a4,a5,80004e64 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e28:	8526                	mv	a0,s1
    80004e2a:	ffffe097          	auipc	ra,0xffffe
    80004e2e:	e50080e7          	jalr	-432(ra) # 80002c7a <iunlock>
  iput(p->cwd);
    80004e32:	15093503          	ld	a0,336(s2)
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	f3c080e7          	jalr	-196(ra) # 80002d72 <iput>
  end_op();
    80004e3e:	ffffe097          	auipc	ra,0xffffe
    80004e42:	7bc080e7          	jalr	1980(ra) # 800035fa <end_op>
  p->cwd = ip;
    80004e46:	14993823          	sd	s1,336(s2)
  return 0;
    80004e4a:	4501                	li	a0,0
}
    80004e4c:	60ea                	ld	ra,152(sp)
    80004e4e:	644a                	ld	s0,144(sp)
    80004e50:	64aa                	ld	s1,136(sp)
    80004e52:	690a                	ld	s2,128(sp)
    80004e54:	610d                	addi	sp,sp,160
    80004e56:	8082                	ret
    end_op();
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	7a2080e7          	jalr	1954(ra) # 800035fa <end_op>
    return -1;
    80004e60:	557d                	li	a0,-1
    80004e62:	b7ed                	j	80004e4c <sys_chdir+0x7a>
    iunlockput(ip);
    80004e64:	8526                	mv	a0,s1
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	fb4080e7          	jalr	-76(ra) # 80002e1a <iunlockput>
    end_op();
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	78c080e7          	jalr	1932(ra) # 800035fa <end_op>
    return -1;
    80004e76:	557d                	li	a0,-1
    80004e78:	bfd1                	j	80004e4c <sys_chdir+0x7a>

0000000080004e7a <sys_exec>:

uint64
sys_exec(void)
{
    80004e7a:	7145                	addi	sp,sp,-464
    80004e7c:	e786                	sd	ra,456(sp)
    80004e7e:	e3a2                	sd	s0,448(sp)
    80004e80:	ff26                	sd	s1,440(sp)
    80004e82:	fb4a                	sd	s2,432(sp)
    80004e84:	f74e                	sd	s3,424(sp)
    80004e86:	f352                	sd	s4,416(sp)
    80004e88:	ef56                	sd	s5,408(sp)
    80004e8a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e8c:	e3840593          	addi	a1,s0,-456
    80004e90:	4505                	li	a0,1
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	1cc080e7          	jalr	460(ra) # 8000205e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e9a:	08000613          	li	a2,128
    80004e9e:	f4040593          	addi	a1,s0,-192
    80004ea2:	4501                	li	a0,0
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	1da080e7          	jalr	474(ra) # 8000207e <argstr>
    80004eac:	87aa                	mv	a5,a0
    return -1;
    80004eae:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004eb0:	0c07c363          	bltz	a5,80004f76 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004eb4:	10000613          	li	a2,256
    80004eb8:	4581                	li	a1,0
    80004eba:	e4040513          	addi	a0,s0,-448
    80004ebe:	ffffb097          	auipc	ra,0xffffb
    80004ec2:	2ba080e7          	jalr	698(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ec6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eca:	89a6                	mv	s3,s1
    80004ecc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ece:	02000a13          	li	s4,32
    80004ed2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ed6:	00391793          	slli	a5,s2,0x3
    80004eda:	e3040593          	addi	a1,s0,-464
    80004ede:	e3843503          	ld	a0,-456(s0)
    80004ee2:	953e                	add	a0,a0,a5
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	0bc080e7          	jalr	188(ra) # 80001fa0 <fetchaddr>
    80004eec:	02054a63          	bltz	a0,80004f20 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ef0:	e3043783          	ld	a5,-464(s0)
    80004ef4:	c3b9                	beqz	a5,80004f3a <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ef6:	ffffb097          	auipc	ra,0xffffb
    80004efa:	222080e7          	jalr	546(ra) # 80000118 <kalloc>
    80004efe:	85aa                	mv	a1,a0
    80004f00:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f04:	cd11                	beqz	a0,80004f20 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f06:	6605                	lui	a2,0x1
    80004f08:	e3043503          	ld	a0,-464(s0)
    80004f0c:	ffffd097          	auipc	ra,0xffffd
    80004f10:	0e6080e7          	jalr	230(ra) # 80001ff2 <fetchstr>
    80004f14:	00054663          	bltz	a0,80004f20 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004f18:	0905                	addi	s2,s2,1
    80004f1a:	09a1                	addi	s3,s3,8
    80004f1c:	fb491be3          	bne	s2,s4,80004ed2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f20:	10048913          	addi	s2,s1,256
    80004f24:	6088                	ld	a0,0(s1)
    80004f26:	c539                	beqz	a0,80004f74 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f28:	ffffb097          	auipc	ra,0xffffb
    80004f2c:	0f4080e7          	jalr	244(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f30:	04a1                	addi	s1,s1,8
    80004f32:	ff2499e3          	bne	s1,s2,80004f24 <sys_exec+0xaa>
  return -1;
    80004f36:	557d                	li	a0,-1
    80004f38:	a83d                	j	80004f76 <sys_exec+0xfc>
      argv[i] = 0;
    80004f3a:	0a8e                	slli	s5,s5,0x3
    80004f3c:	fc0a8793          	addi	a5,s5,-64
    80004f40:	00878ab3          	add	s5,a5,s0
    80004f44:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f48:	e4040593          	addi	a1,s0,-448
    80004f4c:	f4040513          	addi	a0,s0,-192
    80004f50:	fffff097          	auipc	ra,0xfffff
    80004f54:	170080e7          	jalr	368(ra) # 800040c0 <exec>
    80004f58:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5a:	10048993          	addi	s3,s1,256
    80004f5e:	6088                	ld	a0,0(s1)
    80004f60:	c901                	beqz	a0,80004f70 <sys_exec+0xf6>
    kfree(argv[i]);
    80004f62:	ffffb097          	auipc	ra,0xffffb
    80004f66:	0ba080e7          	jalr	186(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6a:	04a1                	addi	s1,s1,8
    80004f6c:	ff3499e3          	bne	s1,s3,80004f5e <sys_exec+0xe4>
  return ret;
    80004f70:	854a                	mv	a0,s2
    80004f72:	a011                	j	80004f76 <sys_exec+0xfc>
  return -1;
    80004f74:	557d                	li	a0,-1
}
    80004f76:	60be                	ld	ra,456(sp)
    80004f78:	641e                	ld	s0,448(sp)
    80004f7a:	74fa                	ld	s1,440(sp)
    80004f7c:	795a                	ld	s2,432(sp)
    80004f7e:	79ba                	ld	s3,424(sp)
    80004f80:	7a1a                	ld	s4,416(sp)
    80004f82:	6afa                	ld	s5,408(sp)
    80004f84:	6179                	addi	sp,sp,464
    80004f86:	8082                	ret

0000000080004f88 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f88:	7139                	addi	sp,sp,-64
    80004f8a:	fc06                	sd	ra,56(sp)
    80004f8c:	f822                	sd	s0,48(sp)
    80004f8e:	f426                	sd	s1,40(sp)
    80004f90:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f92:	ffffc097          	auipc	ra,0xffffc
    80004f96:	ebc080e7          	jalr	-324(ra) # 80000e4e <myproc>
    80004f9a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f9c:	fd840593          	addi	a1,s0,-40
    80004fa0:	4501                	li	a0,0
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	0bc080e7          	jalr	188(ra) # 8000205e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004faa:	fc840593          	addi	a1,s0,-56
    80004fae:	fd040513          	addi	a0,s0,-48
    80004fb2:	fffff097          	auipc	ra,0xfffff
    80004fb6:	dc4080e7          	jalr	-572(ra) # 80003d76 <pipealloc>
    return -1;
    80004fba:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fbc:	0c054463          	bltz	a0,80005084 <sys_pipe+0xfc>
  fd0 = -1;
    80004fc0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fc4:	fd043503          	ld	a0,-48(s0)
    80004fc8:	fffff097          	auipc	ra,0xfffff
    80004fcc:	518080e7          	jalr	1304(ra) # 800044e0 <fdalloc>
    80004fd0:	fca42223          	sw	a0,-60(s0)
    80004fd4:	08054b63          	bltz	a0,8000506a <sys_pipe+0xe2>
    80004fd8:	fc843503          	ld	a0,-56(s0)
    80004fdc:	fffff097          	auipc	ra,0xfffff
    80004fe0:	504080e7          	jalr	1284(ra) # 800044e0 <fdalloc>
    80004fe4:	fca42023          	sw	a0,-64(s0)
    80004fe8:	06054863          	bltz	a0,80005058 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fec:	4691                	li	a3,4
    80004fee:	fc440613          	addi	a2,s0,-60
    80004ff2:	fd843583          	ld	a1,-40(s0)
    80004ff6:	68a8                	ld	a0,80(s1)
    80004ff8:	ffffc097          	auipc	ra,0xffffc
    80004ffc:	b16080e7          	jalr	-1258(ra) # 80000b0e <copyout>
    80005000:	02054063          	bltz	a0,80005020 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005004:	4691                	li	a3,4
    80005006:	fc040613          	addi	a2,s0,-64
    8000500a:	fd843583          	ld	a1,-40(s0)
    8000500e:	0591                	addi	a1,a1,4
    80005010:	68a8                	ld	a0,80(s1)
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	afc080e7          	jalr	-1284(ra) # 80000b0e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000501a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000501c:	06055463          	bgez	a0,80005084 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005020:	fc442783          	lw	a5,-60(s0)
    80005024:	07e9                	addi	a5,a5,26
    80005026:	078e                	slli	a5,a5,0x3
    80005028:	97a6                	add	a5,a5,s1
    8000502a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000502e:	fc042503          	lw	a0,-64(s0)
    80005032:	0569                	addi	a0,a0,26
    80005034:	050e                	slli	a0,a0,0x3
    80005036:	94aa                	add	s1,s1,a0
    80005038:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000503c:	fd043503          	ld	a0,-48(s0)
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	a06080e7          	jalr	-1530(ra) # 80003a46 <fileclose>
    fileclose(wf);
    80005048:	fc843503          	ld	a0,-56(s0)
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	9fa080e7          	jalr	-1542(ra) # 80003a46 <fileclose>
    return -1;
    80005054:	57fd                	li	a5,-1
    80005056:	a03d                	j	80005084 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005058:	fc442783          	lw	a5,-60(s0)
    8000505c:	0007c763          	bltz	a5,8000506a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005060:	07e9                	addi	a5,a5,26
    80005062:	078e                	slli	a5,a5,0x3
    80005064:	94be                	add	s1,s1,a5
    80005066:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000506a:	fd043503          	ld	a0,-48(s0)
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	9d8080e7          	jalr	-1576(ra) # 80003a46 <fileclose>
    fileclose(wf);
    80005076:	fc843503          	ld	a0,-56(s0)
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	9cc080e7          	jalr	-1588(ra) # 80003a46 <fileclose>
    return -1;
    80005082:	57fd                	li	a5,-1
}
    80005084:	853e                	mv	a0,a5
    80005086:	70e2                	ld	ra,56(sp)
    80005088:	7442                	ld	s0,48(sp)
    8000508a:	74a2                	ld	s1,40(sp)
    8000508c:	6121                	addi	sp,sp,64
    8000508e:	8082                	ret

0000000080005090 <kernelvec>:
    80005090:	7111                	addi	sp,sp,-256
    80005092:	e006                	sd	ra,0(sp)
    80005094:	e40a                	sd	sp,8(sp)
    80005096:	e80e                	sd	gp,16(sp)
    80005098:	ec12                	sd	tp,24(sp)
    8000509a:	f016                	sd	t0,32(sp)
    8000509c:	f41a                	sd	t1,40(sp)
    8000509e:	f81e                	sd	t2,48(sp)
    800050a0:	fc22                	sd	s0,56(sp)
    800050a2:	e0a6                	sd	s1,64(sp)
    800050a4:	e4aa                	sd	a0,72(sp)
    800050a6:	e8ae                	sd	a1,80(sp)
    800050a8:	ecb2                	sd	a2,88(sp)
    800050aa:	f0b6                	sd	a3,96(sp)
    800050ac:	f4ba                	sd	a4,104(sp)
    800050ae:	f8be                	sd	a5,112(sp)
    800050b0:	fcc2                	sd	a6,120(sp)
    800050b2:	e146                	sd	a7,128(sp)
    800050b4:	e54a                	sd	s2,136(sp)
    800050b6:	e94e                	sd	s3,144(sp)
    800050b8:	ed52                	sd	s4,152(sp)
    800050ba:	f156                	sd	s5,160(sp)
    800050bc:	f55a                	sd	s6,168(sp)
    800050be:	f95e                	sd	s7,176(sp)
    800050c0:	fd62                	sd	s8,184(sp)
    800050c2:	e1e6                	sd	s9,192(sp)
    800050c4:	e5ea                	sd	s10,200(sp)
    800050c6:	e9ee                	sd	s11,208(sp)
    800050c8:	edf2                	sd	t3,216(sp)
    800050ca:	f1f6                	sd	t4,224(sp)
    800050cc:	f5fa                	sd	t5,232(sp)
    800050ce:	f9fe                	sd	t6,240(sp)
    800050d0:	d9dfc0ef          	jal	ra,80001e6c <kerneltrap>
    800050d4:	6082                	ld	ra,0(sp)
    800050d6:	6122                	ld	sp,8(sp)
    800050d8:	61c2                	ld	gp,16(sp)
    800050da:	7282                	ld	t0,32(sp)
    800050dc:	7322                	ld	t1,40(sp)
    800050de:	73c2                	ld	t2,48(sp)
    800050e0:	7462                	ld	s0,56(sp)
    800050e2:	6486                	ld	s1,64(sp)
    800050e4:	6526                	ld	a0,72(sp)
    800050e6:	65c6                	ld	a1,80(sp)
    800050e8:	6666                	ld	a2,88(sp)
    800050ea:	7686                	ld	a3,96(sp)
    800050ec:	7726                	ld	a4,104(sp)
    800050ee:	77c6                	ld	a5,112(sp)
    800050f0:	7866                	ld	a6,120(sp)
    800050f2:	688a                	ld	a7,128(sp)
    800050f4:	692a                	ld	s2,136(sp)
    800050f6:	69ca                	ld	s3,144(sp)
    800050f8:	6a6a                	ld	s4,152(sp)
    800050fa:	7a8a                	ld	s5,160(sp)
    800050fc:	7b2a                	ld	s6,168(sp)
    800050fe:	7bca                	ld	s7,176(sp)
    80005100:	7c6a                	ld	s8,184(sp)
    80005102:	6c8e                	ld	s9,192(sp)
    80005104:	6d2e                	ld	s10,200(sp)
    80005106:	6dce                	ld	s11,208(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	addi	sp,sp,256
    80005112:	10200073          	sret
    80005116:	00000013          	nop
    8000511a:	00000013          	nop
    8000511e:	0001                	nop

0000000080005120 <timervec>:
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	e10c                	sd	a1,0(a0)
    80005126:	e510                	sd	a2,8(a0)
    80005128:	e914                	sd	a3,16(a0)
    8000512a:	6d0c                	ld	a1,24(a0)
    8000512c:	7110                	ld	a2,32(a0)
    8000512e:	6194                	ld	a3,0(a1)
    80005130:	96b2                	add	a3,a3,a2
    80005132:	e194                	sd	a3,0(a1)
    80005134:	4589                	li	a1,2
    80005136:	14459073          	csrw	sip,a1
    8000513a:	6914                	ld	a3,16(a0)
    8000513c:	6510                	ld	a2,8(a0)
    8000513e:	610c                	ld	a1,0(a0)
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	30200073          	mret
	...

000000008000514a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000514a:	1141                	addi	sp,sp,-16
    8000514c:	e422                	sd	s0,8(sp)
    8000514e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005150:	0c0007b7          	lui	a5,0xc000
    80005154:	4705                	li	a4,1
    80005156:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005158:	c3d8                	sw	a4,4(a5)
}
    8000515a:	6422                	ld	s0,8(sp)
    8000515c:	0141                	addi	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <plicinithart>:

void
plicinithart(void)
{
    80005160:	1141                	addi	sp,sp,-16
    80005162:	e406                	sd	ra,8(sp)
    80005164:	e022                	sd	s0,0(sp)
    80005166:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	cba080e7          	jalr	-838(ra) # 80000e22 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005170:	0085171b          	slliw	a4,a0,0x8
    80005174:	0c0027b7          	lui	a5,0xc002
    80005178:	97ba                	add	a5,a5,a4
    8000517a:	40200713          	li	a4,1026
    8000517e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005182:	00d5151b          	slliw	a0,a0,0xd
    80005186:	0c2017b7          	lui	a5,0xc201
    8000518a:	953e                	add	a0,a0,a5
    8000518c:	00052023          	sw	zero,0(a0)
}
    80005190:	60a2                	ld	ra,8(sp)
    80005192:	6402                	ld	s0,0(sp)
    80005194:	0141                	addi	sp,sp,16
    80005196:	8082                	ret

0000000080005198 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005198:	1141                	addi	sp,sp,-16
    8000519a:	e406                	sd	ra,8(sp)
    8000519c:	e022                	sd	s0,0(sp)
    8000519e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a0:	ffffc097          	auipc	ra,0xffffc
    800051a4:	c82080e7          	jalr	-894(ra) # 80000e22 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a8:	00d5179b          	slliw	a5,a0,0xd
    800051ac:	0c201537          	lui	a0,0xc201
    800051b0:	953e                	add	a0,a0,a5
  return irq;
}
    800051b2:	4148                	lw	a0,4(a0)
    800051b4:	60a2                	ld	ra,8(sp)
    800051b6:	6402                	ld	s0,0(sp)
    800051b8:	0141                	addi	sp,sp,16
    800051ba:	8082                	ret

00000000800051bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051bc:	1101                	addi	sp,sp,-32
    800051be:	ec06                	sd	ra,24(sp)
    800051c0:	e822                	sd	s0,16(sp)
    800051c2:	e426                	sd	s1,8(sp)
    800051c4:	1000                	addi	s0,sp,32
    800051c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c8:	ffffc097          	auipc	ra,0xffffc
    800051cc:	c5a080e7          	jalr	-934(ra) # 80000e22 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051d0:	00d5151b          	slliw	a0,a0,0xd
    800051d4:	0c2017b7          	lui	a5,0xc201
    800051d8:	97aa                	add	a5,a5,a0
    800051da:	c3c4                	sw	s1,4(a5)
}
    800051dc:	60e2                	ld	ra,24(sp)
    800051de:	6442                	ld	s0,16(sp)
    800051e0:	64a2                	ld	s1,8(sp)
    800051e2:	6105                	addi	sp,sp,32
    800051e4:	8082                	ret

00000000800051e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051e6:	1141                	addi	sp,sp,-16
    800051e8:	e406                	sd	ra,8(sp)
    800051ea:	e022                	sd	s0,0(sp)
    800051ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ee:	479d                	li	a5,7
    800051f0:	04a7cc63          	blt	a5,a0,80005248 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800051f4:	00015797          	auipc	a5,0x15
    800051f8:	a2c78793          	addi	a5,a5,-1492 # 80019c20 <disk>
    800051fc:	97aa                	add	a5,a5,a0
    800051fe:	0187c783          	lbu	a5,24(a5)
    80005202:	ebb9                	bnez	a5,80005258 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005204:	00451613          	slli	a2,a0,0x4
    80005208:	00015797          	auipc	a5,0x15
    8000520c:	a1878793          	addi	a5,a5,-1512 # 80019c20 <disk>
    80005210:	6394                	ld	a3,0(a5)
    80005212:	96b2                	add	a3,a3,a2
    80005214:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005218:	6398                	ld	a4,0(a5)
    8000521a:	9732                	add	a4,a4,a2
    8000521c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005220:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005224:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005228:	953e                	add	a0,a0,a5
    8000522a:	4785                	li	a5,1
    8000522c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005230:	00015517          	auipc	a0,0x15
    80005234:	a0850513          	addi	a0,a0,-1528 # 80019c38 <disk+0x18>
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	3fe080e7          	jalr	1022(ra) # 80001636 <wakeup>
}
    80005240:	60a2                	ld	ra,8(sp)
    80005242:	6402                	ld	s0,0(sp)
    80005244:	0141                	addi	sp,sp,16
    80005246:	8082                	ret
    panic("free_desc 1");
    80005248:	00003517          	auipc	a0,0x3
    8000524c:	4c050513          	addi	a0,a0,1216 # 80008708 <syscalls+0x338>
    80005250:	00001097          	auipc	ra,0x1
    80005254:	a10080e7          	jalr	-1520(ra) # 80005c60 <panic>
    panic("free_desc 2");
    80005258:	00003517          	auipc	a0,0x3
    8000525c:	4c050513          	addi	a0,a0,1216 # 80008718 <syscalls+0x348>
    80005260:	00001097          	auipc	ra,0x1
    80005264:	a00080e7          	jalr	-1536(ra) # 80005c60 <panic>

0000000080005268 <virtio_disk_init>:
{
    80005268:	1101                	addi	sp,sp,-32
    8000526a:	ec06                	sd	ra,24(sp)
    8000526c:	e822                	sd	s0,16(sp)
    8000526e:	e426                	sd	s1,8(sp)
    80005270:	e04a                	sd	s2,0(sp)
    80005272:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005274:	00003597          	auipc	a1,0x3
    80005278:	4b458593          	addi	a1,a1,1204 # 80008728 <syscalls+0x358>
    8000527c:	00015517          	auipc	a0,0x15
    80005280:	acc50513          	addi	a0,a0,-1332 # 80019d48 <disk+0x128>
    80005284:	00001097          	auipc	ra,0x1
    80005288:	e88080e7          	jalr	-376(ra) # 8000610c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000528c:	100017b7          	lui	a5,0x10001
    80005290:	4398                	lw	a4,0(a5)
    80005292:	2701                	sext.w	a4,a4
    80005294:	747277b7          	lui	a5,0x74727
    80005298:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000529c:	14f71c63          	bne	a4,a5,800053f4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052a0:	100017b7          	lui	a5,0x10001
    800052a4:	43dc                	lw	a5,4(a5)
    800052a6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a8:	4709                	li	a4,2
    800052aa:	14e79563          	bne	a5,a4,800053f4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ae:	100017b7          	lui	a5,0x10001
    800052b2:	479c                	lw	a5,8(a5)
    800052b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052b6:	12e79f63          	bne	a5,a4,800053f4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ba:	100017b7          	lui	a5,0x10001
    800052be:	47d8                	lw	a4,12(a5)
    800052c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c2:	554d47b7          	lui	a5,0x554d4
    800052c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052ca:	12f71563          	bne	a4,a5,800053f4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ce:	100017b7          	lui	a5,0x10001
    800052d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d6:	4705                	li	a4,1
    800052d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052da:	470d                	li	a4,3
    800052dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052de:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052e0:	c7ffe737          	lui	a4,0xc7ffe
    800052e4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc7bf>
    800052e8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052ea:	2701                	sext.w	a4,a4
    800052ec:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ee:	472d                	li	a4,11
    800052f0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052f2:	5bbc                	lw	a5,112(a5)
    800052f4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052f8:	8ba1                	andi	a5,a5,8
    800052fa:	10078563          	beqz	a5,80005404 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052fe:	100017b7          	lui	a5,0x10001
    80005302:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005306:	43fc                	lw	a5,68(a5)
    80005308:	2781                	sext.w	a5,a5
    8000530a:	10079563          	bnez	a5,80005414 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000530e:	100017b7          	lui	a5,0x10001
    80005312:	5bdc                	lw	a5,52(a5)
    80005314:	2781                	sext.w	a5,a5
  if(max == 0)
    80005316:	10078763          	beqz	a5,80005424 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000531a:	471d                	li	a4,7
    8000531c:	10f77c63          	bgeu	a4,a5,80005434 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005320:	ffffb097          	auipc	ra,0xffffb
    80005324:	df8080e7          	jalr	-520(ra) # 80000118 <kalloc>
    80005328:	00015497          	auipc	s1,0x15
    8000532c:	8f848493          	addi	s1,s1,-1800 # 80019c20 <disk>
    80005330:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005332:	ffffb097          	auipc	ra,0xffffb
    80005336:	de6080e7          	jalr	-538(ra) # 80000118 <kalloc>
    8000533a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000533c:	ffffb097          	auipc	ra,0xffffb
    80005340:	ddc080e7          	jalr	-548(ra) # 80000118 <kalloc>
    80005344:	87aa                	mv	a5,a0
    80005346:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005348:	6088                	ld	a0,0(s1)
    8000534a:	cd6d                	beqz	a0,80005444 <virtio_disk_init+0x1dc>
    8000534c:	00015717          	auipc	a4,0x15
    80005350:	8dc73703          	ld	a4,-1828(a4) # 80019c28 <disk+0x8>
    80005354:	cb65                	beqz	a4,80005444 <virtio_disk_init+0x1dc>
    80005356:	c7fd                	beqz	a5,80005444 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005358:	6605                	lui	a2,0x1
    8000535a:	4581                	li	a1,0
    8000535c:	ffffb097          	auipc	ra,0xffffb
    80005360:	e1c080e7          	jalr	-484(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005364:	00015497          	auipc	s1,0x15
    80005368:	8bc48493          	addi	s1,s1,-1860 # 80019c20 <disk>
    8000536c:	6605                	lui	a2,0x1
    8000536e:	4581                	li	a1,0
    80005370:	6488                	ld	a0,8(s1)
    80005372:	ffffb097          	auipc	ra,0xffffb
    80005376:	e06080e7          	jalr	-506(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000537a:	6605                	lui	a2,0x1
    8000537c:	4581                	li	a1,0
    8000537e:	6888                	ld	a0,16(s1)
    80005380:	ffffb097          	auipc	ra,0xffffb
    80005384:	df8080e7          	jalr	-520(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005388:	100017b7          	lui	a5,0x10001
    8000538c:	4721                	li	a4,8
    8000538e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005390:	4098                	lw	a4,0(s1)
    80005392:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005396:	40d8                	lw	a4,4(s1)
    80005398:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000539c:	6498                	ld	a4,8(s1)
    8000539e:	0007069b          	sext.w	a3,a4
    800053a2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053a6:	9701                	srai	a4,a4,0x20
    800053a8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053ac:	6898                	ld	a4,16(s1)
    800053ae:	0007069b          	sext.w	a3,a4
    800053b2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053b6:	9701                	srai	a4,a4,0x20
    800053b8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053bc:	4705                	li	a4,1
    800053be:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053c0:	00e48c23          	sb	a4,24(s1)
    800053c4:	00e48ca3          	sb	a4,25(s1)
    800053c8:	00e48d23          	sb	a4,26(s1)
    800053cc:	00e48da3          	sb	a4,27(s1)
    800053d0:	00e48e23          	sb	a4,28(s1)
    800053d4:	00e48ea3          	sb	a4,29(s1)
    800053d8:	00e48f23          	sb	a4,30(s1)
    800053dc:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053e0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e4:	0727a823          	sw	s2,112(a5)
}
    800053e8:	60e2                	ld	ra,24(sp)
    800053ea:	6442                	ld	s0,16(sp)
    800053ec:	64a2                	ld	s1,8(sp)
    800053ee:	6902                	ld	s2,0(sp)
    800053f0:	6105                	addi	sp,sp,32
    800053f2:	8082                	ret
    panic("could not find virtio disk");
    800053f4:	00003517          	auipc	a0,0x3
    800053f8:	34450513          	addi	a0,a0,836 # 80008738 <syscalls+0x368>
    800053fc:	00001097          	auipc	ra,0x1
    80005400:	864080e7          	jalr	-1948(ra) # 80005c60 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005404:	00003517          	auipc	a0,0x3
    80005408:	35450513          	addi	a0,a0,852 # 80008758 <syscalls+0x388>
    8000540c:	00001097          	auipc	ra,0x1
    80005410:	854080e7          	jalr	-1964(ra) # 80005c60 <panic>
    panic("virtio disk should not be ready");
    80005414:	00003517          	auipc	a0,0x3
    80005418:	36450513          	addi	a0,a0,868 # 80008778 <syscalls+0x3a8>
    8000541c:	00001097          	auipc	ra,0x1
    80005420:	844080e7          	jalr	-1980(ra) # 80005c60 <panic>
    panic("virtio disk has no queue 0");
    80005424:	00003517          	auipc	a0,0x3
    80005428:	37450513          	addi	a0,a0,884 # 80008798 <syscalls+0x3c8>
    8000542c:	00001097          	auipc	ra,0x1
    80005430:	834080e7          	jalr	-1996(ra) # 80005c60 <panic>
    panic("virtio disk max queue too short");
    80005434:	00003517          	auipc	a0,0x3
    80005438:	38450513          	addi	a0,a0,900 # 800087b8 <syscalls+0x3e8>
    8000543c:	00001097          	auipc	ra,0x1
    80005440:	824080e7          	jalr	-2012(ra) # 80005c60 <panic>
    panic("virtio disk kalloc");
    80005444:	00003517          	auipc	a0,0x3
    80005448:	39450513          	addi	a0,a0,916 # 800087d8 <syscalls+0x408>
    8000544c:	00001097          	auipc	ra,0x1
    80005450:	814080e7          	jalr	-2028(ra) # 80005c60 <panic>

0000000080005454 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005454:	7119                	addi	sp,sp,-128
    80005456:	fc86                	sd	ra,120(sp)
    80005458:	f8a2                	sd	s0,112(sp)
    8000545a:	f4a6                	sd	s1,104(sp)
    8000545c:	f0ca                	sd	s2,96(sp)
    8000545e:	ecce                	sd	s3,88(sp)
    80005460:	e8d2                	sd	s4,80(sp)
    80005462:	e4d6                	sd	s5,72(sp)
    80005464:	e0da                	sd	s6,64(sp)
    80005466:	fc5e                	sd	s7,56(sp)
    80005468:	f862                	sd	s8,48(sp)
    8000546a:	f466                	sd	s9,40(sp)
    8000546c:	f06a                	sd	s10,32(sp)
    8000546e:	ec6e                	sd	s11,24(sp)
    80005470:	0100                	addi	s0,sp,128
    80005472:	8aaa                	mv	s5,a0
    80005474:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005476:	00c52d03          	lw	s10,12(a0)
    8000547a:	001d1d1b          	slliw	s10,s10,0x1
    8000547e:	1d02                	slli	s10,s10,0x20
    80005480:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005484:	00015517          	auipc	a0,0x15
    80005488:	8c450513          	addi	a0,a0,-1852 # 80019d48 <disk+0x128>
    8000548c:	00001097          	auipc	ra,0x1
    80005490:	d10080e7          	jalr	-752(ra) # 8000619c <acquire>
  for(int i = 0; i < 3; i++){
    80005494:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005496:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005498:	00014b97          	auipc	s7,0x14
    8000549c:	788b8b93          	addi	s7,s7,1928 # 80019c20 <disk>
  for(int i = 0; i < 3; i++){
    800054a0:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054a2:	00015c97          	auipc	s9,0x15
    800054a6:	8a6c8c93          	addi	s9,s9,-1882 # 80019d48 <disk+0x128>
    800054aa:	a08d                	j	8000550c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054ac:	00fb8733          	add	a4,s7,a5
    800054b0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054b4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800054b6:	0207c563          	bltz	a5,800054e0 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800054ba:	2905                	addiw	s2,s2,1
    800054bc:	0611                	addi	a2,a2,4
    800054be:	05690c63          	beq	s2,s6,80005516 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054c2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800054c4:	00014717          	auipc	a4,0x14
    800054c8:	75c70713          	addi	a4,a4,1884 # 80019c20 <disk>
    800054cc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800054ce:	01874683          	lbu	a3,24(a4)
    800054d2:	fee9                	bnez	a3,800054ac <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800054d4:	2785                	addiw	a5,a5,1
    800054d6:	0705                	addi	a4,a4,1
    800054d8:	fe979be3          	bne	a5,s1,800054ce <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800054dc:	57fd                	li	a5,-1
    800054de:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800054e0:	01205d63          	blez	s2,800054fa <virtio_disk_rw+0xa6>
    800054e4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800054e6:	000a2503          	lw	a0,0(s4)
    800054ea:	00000097          	auipc	ra,0x0
    800054ee:	cfc080e7          	jalr	-772(ra) # 800051e6 <free_desc>
      for(int j = 0; j < i; j++)
    800054f2:	2d85                	addiw	s11,s11,1
    800054f4:	0a11                	addi	s4,s4,4
    800054f6:	ffb918e3          	bne	s2,s11,800054e6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054fa:	85e6                	mv	a1,s9
    800054fc:	00014517          	auipc	a0,0x14
    80005500:	73c50513          	addi	a0,a0,1852 # 80019c38 <disk+0x18>
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	0ce080e7          	jalr	206(ra) # 800015d2 <sleep>
  for(int i = 0; i < 3; i++){
    8000550c:	f8040a13          	addi	s4,s0,-128
{
    80005510:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005512:	894e                	mv	s2,s3
    80005514:	b77d                	j	800054c2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005516:	f8042583          	lw	a1,-128(s0)
    8000551a:	00a58793          	addi	a5,a1,10
    8000551e:	0792                	slli	a5,a5,0x4

  if(write)
    80005520:	00014617          	auipc	a2,0x14
    80005524:	70060613          	addi	a2,a2,1792 # 80019c20 <disk>
    80005528:	00f60733          	add	a4,a2,a5
    8000552c:	018036b3          	snez	a3,s8
    80005530:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005532:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005536:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000553a:	f6078693          	addi	a3,a5,-160
    8000553e:	6218                	ld	a4,0(a2)
    80005540:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005542:	00878513          	addi	a0,a5,8
    80005546:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005548:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000554a:	6208                	ld	a0,0(a2)
    8000554c:	96aa                	add	a3,a3,a0
    8000554e:	4741                	li	a4,16
    80005550:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005552:	4705                	li	a4,1
    80005554:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005558:	f8442703          	lw	a4,-124(s0)
    8000555c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005560:	0712                	slli	a4,a4,0x4
    80005562:	953a                	add	a0,a0,a4
    80005564:	058a8693          	addi	a3,s5,88
    80005568:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000556a:	6208                	ld	a0,0(a2)
    8000556c:	972a                	add	a4,a4,a0
    8000556e:	40000693          	li	a3,1024
    80005572:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005574:	001c3c13          	seqz	s8,s8
    80005578:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000557a:	001c6c13          	ori	s8,s8,1
    8000557e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005582:	f8842603          	lw	a2,-120(s0)
    80005586:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000558a:	00014697          	auipc	a3,0x14
    8000558e:	69668693          	addi	a3,a3,1686 # 80019c20 <disk>
    80005592:	00258713          	addi	a4,a1,2
    80005596:	0712                	slli	a4,a4,0x4
    80005598:	9736                	add	a4,a4,a3
    8000559a:	587d                	li	a6,-1
    8000559c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055a0:	0612                	slli	a2,a2,0x4
    800055a2:	9532                	add	a0,a0,a2
    800055a4:	f9078793          	addi	a5,a5,-112
    800055a8:	97b6                	add	a5,a5,a3
    800055aa:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800055ac:	629c                	ld	a5,0(a3)
    800055ae:	97b2                	add	a5,a5,a2
    800055b0:	4605                	li	a2,1
    800055b2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055b4:	4509                	li	a0,2
    800055b6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800055ba:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055be:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800055c2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055c6:	6698                	ld	a4,8(a3)
    800055c8:	00275783          	lhu	a5,2(a4)
    800055cc:	8b9d                	andi	a5,a5,7
    800055ce:	0786                	slli	a5,a5,0x1
    800055d0:	97ba                	add	a5,a5,a4
    800055d2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055d6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055da:	6698                	ld	a4,8(a3)
    800055dc:	00275783          	lhu	a5,2(a4)
    800055e0:	2785                	addiw	a5,a5,1
    800055e2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055e6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055ea:	100017b7          	lui	a5,0x10001
    800055ee:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055f2:	004aa783          	lw	a5,4(s5)
    800055f6:	02c79163          	bne	a5,a2,80005618 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800055fa:	00014917          	auipc	s2,0x14
    800055fe:	74e90913          	addi	s2,s2,1870 # 80019d48 <disk+0x128>
  while(b->disk == 1) {
    80005602:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005604:	85ca                	mv	a1,s2
    80005606:	8556                	mv	a0,s5
    80005608:	ffffc097          	auipc	ra,0xffffc
    8000560c:	fca080e7          	jalr	-54(ra) # 800015d2 <sleep>
  while(b->disk == 1) {
    80005610:	004aa783          	lw	a5,4(s5)
    80005614:	fe9788e3          	beq	a5,s1,80005604 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005618:	f8042903          	lw	s2,-128(s0)
    8000561c:	00290793          	addi	a5,s2,2
    80005620:	00479713          	slli	a4,a5,0x4
    80005624:	00014797          	auipc	a5,0x14
    80005628:	5fc78793          	addi	a5,a5,1532 # 80019c20 <disk>
    8000562c:	97ba                	add	a5,a5,a4
    8000562e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005632:	00014997          	auipc	s3,0x14
    80005636:	5ee98993          	addi	s3,s3,1518 # 80019c20 <disk>
    8000563a:	00491713          	slli	a4,s2,0x4
    8000563e:	0009b783          	ld	a5,0(s3)
    80005642:	97ba                	add	a5,a5,a4
    80005644:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005648:	854a                	mv	a0,s2
    8000564a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000564e:	00000097          	auipc	ra,0x0
    80005652:	b98080e7          	jalr	-1128(ra) # 800051e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005656:	8885                	andi	s1,s1,1
    80005658:	f0ed                	bnez	s1,8000563a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000565a:	00014517          	auipc	a0,0x14
    8000565e:	6ee50513          	addi	a0,a0,1774 # 80019d48 <disk+0x128>
    80005662:	00001097          	auipc	ra,0x1
    80005666:	bee080e7          	jalr	-1042(ra) # 80006250 <release>
}
    8000566a:	70e6                	ld	ra,120(sp)
    8000566c:	7446                	ld	s0,112(sp)
    8000566e:	74a6                	ld	s1,104(sp)
    80005670:	7906                	ld	s2,96(sp)
    80005672:	69e6                	ld	s3,88(sp)
    80005674:	6a46                	ld	s4,80(sp)
    80005676:	6aa6                	ld	s5,72(sp)
    80005678:	6b06                	ld	s6,64(sp)
    8000567a:	7be2                	ld	s7,56(sp)
    8000567c:	7c42                	ld	s8,48(sp)
    8000567e:	7ca2                	ld	s9,40(sp)
    80005680:	7d02                	ld	s10,32(sp)
    80005682:	6de2                	ld	s11,24(sp)
    80005684:	6109                	addi	sp,sp,128
    80005686:	8082                	ret

0000000080005688 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005688:	1101                	addi	sp,sp,-32
    8000568a:	ec06                	sd	ra,24(sp)
    8000568c:	e822                	sd	s0,16(sp)
    8000568e:	e426                	sd	s1,8(sp)
    80005690:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005692:	00014497          	auipc	s1,0x14
    80005696:	58e48493          	addi	s1,s1,1422 # 80019c20 <disk>
    8000569a:	00014517          	auipc	a0,0x14
    8000569e:	6ae50513          	addi	a0,a0,1710 # 80019d48 <disk+0x128>
    800056a2:	00001097          	auipc	ra,0x1
    800056a6:	afa080e7          	jalr	-1286(ra) # 8000619c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056aa:	10001737          	lui	a4,0x10001
    800056ae:	533c                	lw	a5,96(a4)
    800056b0:	8b8d                	andi	a5,a5,3
    800056b2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056b4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056b8:	689c                	ld	a5,16(s1)
    800056ba:	0204d703          	lhu	a4,32(s1)
    800056be:	0027d783          	lhu	a5,2(a5)
    800056c2:	04f70863          	beq	a4,a5,80005712 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056c6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ca:	6898                	ld	a4,16(s1)
    800056cc:	0204d783          	lhu	a5,32(s1)
    800056d0:	8b9d                	andi	a5,a5,7
    800056d2:	078e                	slli	a5,a5,0x3
    800056d4:	97ba                	add	a5,a5,a4
    800056d6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056d8:	00278713          	addi	a4,a5,2
    800056dc:	0712                	slli	a4,a4,0x4
    800056de:	9726                	add	a4,a4,s1
    800056e0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056e4:	e721                	bnez	a4,8000572c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056e6:	0789                	addi	a5,a5,2
    800056e8:	0792                	slli	a5,a5,0x4
    800056ea:	97a6                	add	a5,a5,s1
    800056ec:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056ee:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056f2:	ffffc097          	auipc	ra,0xffffc
    800056f6:	f44080e7          	jalr	-188(ra) # 80001636 <wakeup>

    disk.used_idx += 1;
    800056fa:	0204d783          	lhu	a5,32(s1)
    800056fe:	2785                	addiw	a5,a5,1
    80005700:	17c2                	slli	a5,a5,0x30
    80005702:	93c1                	srli	a5,a5,0x30
    80005704:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005708:	6898                	ld	a4,16(s1)
    8000570a:	00275703          	lhu	a4,2(a4)
    8000570e:	faf71ce3          	bne	a4,a5,800056c6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005712:	00014517          	auipc	a0,0x14
    80005716:	63650513          	addi	a0,a0,1590 # 80019d48 <disk+0x128>
    8000571a:	00001097          	auipc	ra,0x1
    8000571e:	b36080e7          	jalr	-1226(ra) # 80006250 <release>
}
    80005722:	60e2                	ld	ra,24(sp)
    80005724:	6442                	ld	s0,16(sp)
    80005726:	64a2                	ld	s1,8(sp)
    80005728:	6105                	addi	sp,sp,32
    8000572a:	8082                	ret
      panic("virtio_disk_intr status");
    8000572c:	00003517          	auipc	a0,0x3
    80005730:	0c450513          	addi	a0,a0,196 # 800087f0 <syscalls+0x420>
    80005734:	00000097          	auipc	ra,0x0
    80005738:	52c080e7          	jalr	1324(ra) # 80005c60 <panic>

000000008000573c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000573c:	1141                	addi	sp,sp,-16
    8000573e:	e422                	sd	s0,8(sp)
    80005740:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005742:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005746:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000574a:	0037979b          	slliw	a5,a5,0x3
    8000574e:	02004737          	lui	a4,0x2004
    80005752:	97ba                	add	a5,a5,a4
    80005754:	0200c737          	lui	a4,0x200c
    80005758:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000575c:	000f4637          	lui	a2,0xf4
    80005760:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005764:	95b2                	add	a1,a1,a2
    80005766:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005768:	00269713          	slli	a4,a3,0x2
    8000576c:	9736                	add	a4,a4,a3
    8000576e:	00371693          	slli	a3,a4,0x3
    80005772:	00014717          	auipc	a4,0x14
    80005776:	5ee70713          	addi	a4,a4,1518 # 80019d60 <timer_scratch>
    8000577a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000577c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000577e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005780:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005784:	00000797          	auipc	a5,0x0
    80005788:	99c78793          	addi	a5,a5,-1636 # 80005120 <timervec>
    8000578c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005790:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005794:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005798:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000579c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057a0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057a4:	30479073          	csrw	mie,a5
}
    800057a8:	6422                	ld	s0,8(sp)
    800057aa:	0141                	addi	sp,sp,16
    800057ac:	8082                	ret

00000000800057ae <start>:
{
    800057ae:	1141                	addi	sp,sp,-16
    800057b0:	e406                	sd	ra,8(sp)
    800057b2:	e022                	sd	s0,0(sp)
    800057b4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057ba:	7779                	lui	a4,0xffffe
    800057bc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc85f>
    800057c0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057c2:	6705                	lui	a4,0x1
    800057c4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057ca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057ce:	ffffb797          	auipc	a5,0xffffb
    800057d2:	b5078793          	addi	a5,a5,-1200 # 8000031e <main>
    800057d6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057da:	4781                	li	a5,0
    800057dc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057e0:	67c1                	lui	a5,0x10
    800057e2:	17fd                	addi	a5,a5,-1
    800057e4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057ec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057f0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057f4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f8:	57fd                	li	a5,-1
    800057fa:	83a9                	srli	a5,a5,0xa
    800057fc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005800:	47bd                	li	a5,15
    80005802:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005806:	00000097          	auipc	ra,0x0
    8000580a:	f36080e7          	jalr	-202(ra) # 8000573c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000580e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005812:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005814:	823e                	mv	tp,a5
  asm volatile("mret");
    80005816:	30200073          	mret
}
    8000581a:	60a2                	ld	ra,8(sp)
    8000581c:	6402                	ld	s0,0(sp)
    8000581e:	0141                	addi	sp,sp,16
    80005820:	8082                	ret

0000000080005822 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005822:	715d                	addi	sp,sp,-80
    80005824:	e486                	sd	ra,72(sp)
    80005826:	e0a2                	sd	s0,64(sp)
    80005828:	fc26                	sd	s1,56(sp)
    8000582a:	f84a                	sd	s2,48(sp)
    8000582c:	f44e                	sd	s3,40(sp)
    8000582e:	f052                	sd	s4,32(sp)
    80005830:	ec56                	sd	s5,24(sp)
    80005832:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005834:	04c05663          	blez	a2,80005880 <consolewrite+0x5e>
    80005838:	8a2a                	mv	s4,a0
    8000583a:	84ae                	mv	s1,a1
    8000583c:	89b2                	mv	s3,a2
    8000583e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005840:	5afd                	li	s5,-1
    80005842:	4685                	li	a3,1
    80005844:	8626                	mv	a2,s1
    80005846:	85d2                	mv	a1,s4
    80005848:	fbf40513          	addi	a0,s0,-65
    8000584c:	ffffc097          	auipc	ra,0xffffc
    80005850:	1e4080e7          	jalr	484(ra) # 80001a30 <either_copyin>
    80005854:	01550c63          	beq	a0,s5,8000586c <consolewrite+0x4a>
      break;
    uartputc(c);
    80005858:	fbf44503          	lbu	a0,-65(s0)
    8000585c:	00000097          	auipc	ra,0x0
    80005860:	782080e7          	jalr	1922(ra) # 80005fde <uartputc>
  for(i = 0; i < n; i++){
    80005864:	2905                	addiw	s2,s2,1
    80005866:	0485                	addi	s1,s1,1
    80005868:	fd299de3          	bne	s3,s2,80005842 <consolewrite+0x20>
  }

  return i;
}
    8000586c:	854a                	mv	a0,s2
    8000586e:	60a6                	ld	ra,72(sp)
    80005870:	6406                	ld	s0,64(sp)
    80005872:	74e2                	ld	s1,56(sp)
    80005874:	7942                	ld	s2,48(sp)
    80005876:	79a2                	ld	s3,40(sp)
    80005878:	7a02                	ld	s4,32(sp)
    8000587a:	6ae2                	ld	s5,24(sp)
    8000587c:	6161                	addi	sp,sp,80
    8000587e:	8082                	ret
  for(i = 0; i < n; i++){
    80005880:	4901                	li	s2,0
    80005882:	b7ed                	j	8000586c <consolewrite+0x4a>

0000000080005884 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005884:	7159                	addi	sp,sp,-112
    80005886:	f486                	sd	ra,104(sp)
    80005888:	f0a2                	sd	s0,96(sp)
    8000588a:	eca6                	sd	s1,88(sp)
    8000588c:	e8ca                	sd	s2,80(sp)
    8000588e:	e4ce                	sd	s3,72(sp)
    80005890:	e0d2                	sd	s4,64(sp)
    80005892:	fc56                	sd	s5,56(sp)
    80005894:	f85a                	sd	s6,48(sp)
    80005896:	f45e                	sd	s7,40(sp)
    80005898:	f062                	sd	s8,32(sp)
    8000589a:	ec66                	sd	s9,24(sp)
    8000589c:	e86a                	sd	s10,16(sp)
    8000589e:	1880                	addi	s0,sp,112
    800058a0:	8aaa                	mv	s5,a0
    800058a2:	8a2e                	mv	s4,a1
    800058a4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058a6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058aa:	0001c517          	auipc	a0,0x1c
    800058ae:	5f650513          	addi	a0,a0,1526 # 80021ea0 <cons>
    800058b2:	00001097          	auipc	ra,0x1
    800058b6:	8ea080e7          	jalr	-1814(ra) # 8000619c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058ba:	0001c497          	auipc	s1,0x1c
    800058be:	5e648493          	addi	s1,s1,1510 # 80021ea0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058c2:	0001c917          	auipc	s2,0x1c
    800058c6:	67690913          	addi	s2,s2,1654 # 80021f38 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800058ca:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058cc:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058ce:	4ca9                	li	s9,10
  while(n > 0){
    800058d0:	07305b63          	blez	s3,80005946 <consoleread+0xc2>
    while(cons.r == cons.w){
    800058d4:	0984a783          	lw	a5,152(s1)
    800058d8:	09c4a703          	lw	a4,156(s1)
    800058dc:	02f71763          	bne	a4,a5,8000590a <consoleread+0x86>
      if(killed(myproc())){
    800058e0:	ffffb097          	auipc	ra,0xffffb
    800058e4:	56e080e7          	jalr	1390(ra) # 80000e4e <myproc>
    800058e8:	ffffc097          	auipc	ra,0xffffc
    800058ec:	f92080e7          	jalr	-110(ra) # 8000187a <killed>
    800058f0:	e535                	bnez	a0,8000595c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800058f2:	85a6                	mv	a1,s1
    800058f4:	854a                	mv	a0,s2
    800058f6:	ffffc097          	auipc	ra,0xffffc
    800058fa:	cdc080e7          	jalr	-804(ra) # 800015d2 <sleep>
    while(cons.r == cons.w){
    800058fe:	0984a783          	lw	a5,152(s1)
    80005902:	09c4a703          	lw	a4,156(s1)
    80005906:	fcf70de3          	beq	a4,a5,800058e0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000590a:	0017871b          	addiw	a4,a5,1
    8000590e:	08e4ac23          	sw	a4,152(s1)
    80005912:	07f7f713          	andi	a4,a5,127
    80005916:	9726                	add	a4,a4,s1
    80005918:	01874703          	lbu	a4,24(a4)
    8000591c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005920:	077d0563          	beq	s10,s7,8000598a <consoleread+0x106>
    cbuf = c;
    80005924:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005928:	4685                	li	a3,1
    8000592a:	f9f40613          	addi	a2,s0,-97
    8000592e:	85d2                	mv	a1,s4
    80005930:	8556                	mv	a0,s5
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	0a8080e7          	jalr	168(ra) # 800019da <either_copyout>
    8000593a:	01850663          	beq	a0,s8,80005946 <consoleread+0xc2>
    dst++;
    8000593e:	0a05                	addi	s4,s4,1
    --n;
    80005940:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005942:	f99d17e3          	bne	s10,s9,800058d0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005946:	0001c517          	auipc	a0,0x1c
    8000594a:	55a50513          	addi	a0,a0,1370 # 80021ea0 <cons>
    8000594e:	00001097          	auipc	ra,0x1
    80005952:	902080e7          	jalr	-1790(ra) # 80006250 <release>

  return target - n;
    80005956:	413b053b          	subw	a0,s6,s3
    8000595a:	a811                	j	8000596e <consoleread+0xea>
        release(&cons.lock);
    8000595c:	0001c517          	auipc	a0,0x1c
    80005960:	54450513          	addi	a0,a0,1348 # 80021ea0 <cons>
    80005964:	00001097          	auipc	ra,0x1
    80005968:	8ec080e7          	jalr	-1812(ra) # 80006250 <release>
        return -1;
    8000596c:	557d                	li	a0,-1
}
    8000596e:	70a6                	ld	ra,104(sp)
    80005970:	7406                	ld	s0,96(sp)
    80005972:	64e6                	ld	s1,88(sp)
    80005974:	6946                	ld	s2,80(sp)
    80005976:	69a6                	ld	s3,72(sp)
    80005978:	6a06                	ld	s4,64(sp)
    8000597a:	7ae2                	ld	s5,56(sp)
    8000597c:	7b42                	ld	s6,48(sp)
    8000597e:	7ba2                	ld	s7,40(sp)
    80005980:	7c02                	ld	s8,32(sp)
    80005982:	6ce2                	ld	s9,24(sp)
    80005984:	6d42                	ld	s10,16(sp)
    80005986:	6165                	addi	sp,sp,112
    80005988:	8082                	ret
      if(n < target){
    8000598a:	0009871b          	sext.w	a4,s3
    8000598e:	fb677ce3          	bgeu	a4,s6,80005946 <consoleread+0xc2>
        cons.r--;
    80005992:	0001c717          	auipc	a4,0x1c
    80005996:	5af72323          	sw	a5,1446(a4) # 80021f38 <cons+0x98>
    8000599a:	b775                	j	80005946 <consoleread+0xc2>

000000008000599c <consputc>:
{
    8000599c:	1141                	addi	sp,sp,-16
    8000599e:	e406                	sd	ra,8(sp)
    800059a0:	e022                	sd	s0,0(sp)
    800059a2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059a4:	10000793          	li	a5,256
    800059a8:	00f50a63          	beq	a0,a5,800059bc <consputc+0x20>
    uartputc_sync(c);
    800059ac:	00000097          	auipc	ra,0x0
    800059b0:	560080e7          	jalr	1376(ra) # 80005f0c <uartputc_sync>
}
    800059b4:	60a2                	ld	ra,8(sp)
    800059b6:	6402                	ld	s0,0(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059bc:	4521                	li	a0,8
    800059be:	00000097          	auipc	ra,0x0
    800059c2:	54e080e7          	jalr	1358(ra) # 80005f0c <uartputc_sync>
    800059c6:	02000513          	li	a0,32
    800059ca:	00000097          	auipc	ra,0x0
    800059ce:	542080e7          	jalr	1346(ra) # 80005f0c <uartputc_sync>
    800059d2:	4521                	li	a0,8
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	538080e7          	jalr	1336(ra) # 80005f0c <uartputc_sync>
    800059dc:	bfe1                	j	800059b4 <consputc+0x18>

00000000800059de <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059de:	1101                	addi	sp,sp,-32
    800059e0:	ec06                	sd	ra,24(sp)
    800059e2:	e822                	sd	s0,16(sp)
    800059e4:	e426                	sd	s1,8(sp)
    800059e6:	e04a                	sd	s2,0(sp)
    800059e8:	1000                	addi	s0,sp,32
    800059ea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059ec:	0001c517          	auipc	a0,0x1c
    800059f0:	4b450513          	addi	a0,a0,1204 # 80021ea0 <cons>
    800059f4:	00000097          	auipc	ra,0x0
    800059f8:	7a8080e7          	jalr	1960(ra) # 8000619c <acquire>

  switch(c){
    800059fc:	47d5                	li	a5,21
    800059fe:	0af48663          	beq	s1,a5,80005aaa <consoleintr+0xcc>
    80005a02:	0297ca63          	blt	a5,s1,80005a36 <consoleintr+0x58>
    80005a06:	47a1                	li	a5,8
    80005a08:	0ef48763          	beq	s1,a5,80005af6 <consoleintr+0x118>
    80005a0c:	47c1                	li	a5,16
    80005a0e:	10f49a63          	bne	s1,a5,80005b22 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a12:	ffffc097          	auipc	ra,0xffffc
    80005a16:	074080e7          	jalr	116(ra) # 80001a86 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a1a:	0001c517          	auipc	a0,0x1c
    80005a1e:	48650513          	addi	a0,a0,1158 # 80021ea0 <cons>
    80005a22:	00001097          	auipc	ra,0x1
    80005a26:	82e080e7          	jalr	-2002(ra) # 80006250 <release>
}
    80005a2a:	60e2                	ld	ra,24(sp)
    80005a2c:	6442                	ld	s0,16(sp)
    80005a2e:	64a2                	ld	s1,8(sp)
    80005a30:	6902                	ld	s2,0(sp)
    80005a32:	6105                	addi	sp,sp,32
    80005a34:	8082                	ret
  switch(c){
    80005a36:	07f00793          	li	a5,127
    80005a3a:	0af48e63          	beq	s1,a5,80005af6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a3e:	0001c717          	auipc	a4,0x1c
    80005a42:	46270713          	addi	a4,a4,1122 # 80021ea0 <cons>
    80005a46:	0a072783          	lw	a5,160(a4)
    80005a4a:	09872703          	lw	a4,152(a4)
    80005a4e:	9f99                	subw	a5,a5,a4
    80005a50:	07f00713          	li	a4,127
    80005a54:	fcf763e3          	bltu	a4,a5,80005a1a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a58:	47b5                	li	a5,13
    80005a5a:	0cf48763          	beq	s1,a5,80005b28 <consoleintr+0x14a>
      consputc(c);
    80005a5e:	8526                	mv	a0,s1
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	f3c080e7          	jalr	-196(ra) # 8000599c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a68:	0001c797          	auipc	a5,0x1c
    80005a6c:	43878793          	addi	a5,a5,1080 # 80021ea0 <cons>
    80005a70:	0a07a683          	lw	a3,160(a5)
    80005a74:	0016871b          	addiw	a4,a3,1
    80005a78:	0007061b          	sext.w	a2,a4
    80005a7c:	0ae7a023          	sw	a4,160(a5)
    80005a80:	07f6f693          	andi	a3,a3,127
    80005a84:	97b6                	add	a5,a5,a3
    80005a86:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a8a:	47a9                	li	a5,10
    80005a8c:	0cf48563          	beq	s1,a5,80005b56 <consoleintr+0x178>
    80005a90:	4791                	li	a5,4
    80005a92:	0cf48263          	beq	s1,a5,80005b56 <consoleintr+0x178>
    80005a96:	0001c797          	auipc	a5,0x1c
    80005a9a:	4a27a783          	lw	a5,1186(a5) # 80021f38 <cons+0x98>
    80005a9e:	9f1d                	subw	a4,a4,a5
    80005aa0:	08000793          	li	a5,128
    80005aa4:	f6f71be3          	bne	a4,a5,80005a1a <consoleintr+0x3c>
    80005aa8:	a07d                	j	80005b56 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aaa:	0001c717          	auipc	a4,0x1c
    80005aae:	3f670713          	addi	a4,a4,1014 # 80021ea0 <cons>
    80005ab2:	0a072783          	lw	a5,160(a4)
    80005ab6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005aba:	0001c497          	auipc	s1,0x1c
    80005abe:	3e648493          	addi	s1,s1,998 # 80021ea0 <cons>
    while(cons.e != cons.w &&
    80005ac2:	4929                	li	s2,10
    80005ac4:	f4f70be3          	beq	a4,a5,80005a1a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ac8:	37fd                	addiw	a5,a5,-1
    80005aca:	07f7f713          	andi	a4,a5,127
    80005ace:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ad0:	01874703          	lbu	a4,24(a4)
    80005ad4:	f52703e3          	beq	a4,s2,80005a1a <consoleintr+0x3c>
      cons.e--;
    80005ad8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005adc:	10000513          	li	a0,256
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	ebc080e7          	jalr	-324(ra) # 8000599c <consputc>
    while(cons.e != cons.w &&
    80005ae8:	0a04a783          	lw	a5,160(s1)
    80005aec:	09c4a703          	lw	a4,156(s1)
    80005af0:	fcf71ce3          	bne	a4,a5,80005ac8 <consoleintr+0xea>
    80005af4:	b71d                	j	80005a1a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005af6:	0001c717          	auipc	a4,0x1c
    80005afa:	3aa70713          	addi	a4,a4,938 # 80021ea0 <cons>
    80005afe:	0a072783          	lw	a5,160(a4)
    80005b02:	09c72703          	lw	a4,156(a4)
    80005b06:	f0f70ae3          	beq	a4,a5,80005a1a <consoleintr+0x3c>
      cons.e--;
    80005b0a:	37fd                	addiw	a5,a5,-1
    80005b0c:	0001c717          	auipc	a4,0x1c
    80005b10:	42f72a23          	sw	a5,1076(a4) # 80021f40 <cons+0xa0>
      consputc(BACKSPACE);
    80005b14:	10000513          	li	a0,256
    80005b18:	00000097          	auipc	ra,0x0
    80005b1c:	e84080e7          	jalr	-380(ra) # 8000599c <consputc>
    80005b20:	bded                	j	80005a1a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b22:	ee048ce3          	beqz	s1,80005a1a <consoleintr+0x3c>
    80005b26:	bf21                	j	80005a3e <consoleintr+0x60>
      consputc(c);
    80005b28:	4529                	li	a0,10
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	e72080e7          	jalr	-398(ra) # 8000599c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b32:	0001c797          	auipc	a5,0x1c
    80005b36:	36e78793          	addi	a5,a5,878 # 80021ea0 <cons>
    80005b3a:	0a07a703          	lw	a4,160(a5)
    80005b3e:	0017069b          	addiw	a3,a4,1
    80005b42:	0006861b          	sext.w	a2,a3
    80005b46:	0ad7a023          	sw	a3,160(a5)
    80005b4a:	07f77713          	andi	a4,a4,127
    80005b4e:	97ba                	add	a5,a5,a4
    80005b50:	4729                	li	a4,10
    80005b52:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b56:	0001c797          	auipc	a5,0x1c
    80005b5a:	3ec7a323          	sw	a2,998(a5) # 80021f3c <cons+0x9c>
        wakeup(&cons.r);
    80005b5e:	0001c517          	auipc	a0,0x1c
    80005b62:	3da50513          	addi	a0,a0,986 # 80021f38 <cons+0x98>
    80005b66:	ffffc097          	auipc	ra,0xffffc
    80005b6a:	ad0080e7          	jalr	-1328(ra) # 80001636 <wakeup>
    80005b6e:	b575                	j	80005a1a <consoleintr+0x3c>

0000000080005b70 <consoleinit>:

void
consoleinit(void)
{
    80005b70:	1141                	addi	sp,sp,-16
    80005b72:	e406                	sd	ra,8(sp)
    80005b74:	e022                	sd	s0,0(sp)
    80005b76:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b78:	00003597          	auipc	a1,0x3
    80005b7c:	c9058593          	addi	a1,a1,-880 # 80008808 <syscalls+0x438>
    80005b80:	0001c517          	auipc	a0,0x1c
    80005b84:	32050513          	addi	a0,a0,800 # 80021ea0 <cons>
    80005b88:	00000097          	auipc	ra,0x0
    80005b8c:	584080e7          	jalr	1412(ra) # 8000610c <initlock>

  uartinit();
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	32c080e7          	jalr	812(ra) # 80005ebc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b98:	00013797          	auipc	a5,0x13
    80005b9c:	03078793          	addi	a5,a5,48 # 80018bc8 <devsw>
    80005ba0:	00000717          	auipc	a4,0x0
    80005ba4:	ce470713          	addi	a4,a4,-796 # 80005884 <consoleread>
    80005ba8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005baa:	00000717          	auipc	a4,0x0
    80005bae:	c7870713          	addi	a4,a4,-904 # 80005822 <consolewrite>
    80005bb2:	ef98                	sd	a4,24(a5)
}
    80005bb4:	60a2                	ld	ra,8(sp)
    80005bb6:	6402                	ld	s0,0(sp)
    80005bb8:	0141                	addi	sp,sp,16
    80005bba:	8082                	ret

0000000080005bbc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bbc:	7179                	addi	sp,sp,-48
    80005bbe:	f406                	sd	ra,40(sp)
    80005bc0:	f022                	sd	s0,32(sp)
    80005bc2:	ec26                	sd	s1,24(sp)
    80005bc4:	e84a                	sd	s2,16(sp)
    80005bc6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bc8:	c219                	beqz	a2,80005bce <printint+0x12>
    80005bca:	08054763          	bltz	a0,80005c58 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005bce:	2501                	sext.w	a0,a0
    80005bd0:	4881                	li	a7,0
    80005bd2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bd6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bd8:	2581                	sext.w	a1,a1
    80005bda:	00003617          	auipc	a2,0x3
    80005bde:	c5e60613          	addi	a2,a2,-930 # 80008838 <digits>
    80005be2:	883a                	mv	a6,a4
    80005be4:	2705                	addiw	a4,a4,1
    80005be6:	02b577bb          	remuw	a5,a0,a1
    80005bea:	1782                	slli	a5,a5,0x20
    80005bec:	9381                	srli	a5,a5,0x20
    80005bee:	97b2                	add	a5,a5,a2
    80005bf0:	0007c783          	lbu	a5,0(a5)
    80005bf4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bf8:	0005079b          	sext.w	a5,a0
    80005bfc:	02b5553b          	divuw	a0,a0,a1
    80005c00:	0685                	addi	a3,a3,1
    80005c02:	feb7f0e3          	bgeu	a5,a1,80005be2 <printint+0x26>

  if(sign)
    80005c06:	00088c63          	beqz	a7,80005c1e <printint+0x62>
    buf[i++] = '-';
    80005c0a:	fe070793          	addi	a5,a4,-32
    80005c0e:	00878733          	add	a4,a5,s0
    80005c12:	02d00793          	li	a5,45
    80005c16:	fef70823          	sb	a5,-16(a4)
    80005c1a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c1e:	02e05763          	blez	a4,80005c4c <printint+0x90>
    80005c22:	fd040793          	addi	a5,s0,-48
    80005c26:	00e784b3          	add	s1,a5,a4
    80005c2a:	fff78913          	addi	s2,a5,-1
    80005c2e:	993a                	add	s2,s2,a4
    80005c30:	377d                	addiw	a4,a4,-1
    80005c32:	1702                	slli	a4,a4,0x20
    80005c34:	9301                	srli	a4,a4,0x20
    80005c36:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c3a:	fff4c503          	lbu	a0,-1(s1)
    80005c3e:	00000097          	auipc	ra,0x0
    80005c42:	d5e080e7          	jalr	-674(ra) # 8000599c <consputc>
  while(--i >= 0)
    80005c46:	14fd                	addi	s1,s1,-1
    80005c48:	ff2499e3          	bne	s1,s2,80005c3a <printint+0x7e>
}
    80005c4c:	70a2                	ld	ra,40(sp)
    80005c4e:	7402                	ld	s0,32(sp)
    80005c50:	64e2                	ld	s1,24(sp)
    80005c52:	6942                	ld	s2,16(sp)
    80005c54:	6145                	addi	sp,sp,48
    80005c56:	8082                	ret
    x = -xx;
    80005c58:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c5c:	4885                	li	a7,1
    x = -xx;
    80005c5e:	bf95                	j	80005bd2 <printint+0x16>

0000000080005c60 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c60:	1101                	addi	sp,sp,-32
    80005c62:	ec06                	sd	ra,24(sp)
    80005c64:	e822                	sd	s0,16(sp)
    80005c66:	e426                	sd	s1,8(sp)
    80005c68:	1000                	addi	s0,sp,32
    80005c6a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c6c:	0001c797          	auipc	a5,0x1c
    80005c70:	2e07aa23          	sw	zero,756(a5) # 80021f60 <pr+0x18>
  printf("panic: ");
    80005c74:	00003517          	auipc	a0,0x3
    80005c78:	b9c50513          	addi	a0,a0,-1124 # 80008810 <syscalls+0x440>
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	02e080e7          	jalr	46(ra) # 80005caa <printf>
  printf(s);
    80005c84:	8526                	mv	a0,s1
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	024080e7          	jalr	36(ra) # 80005caa <printf>
  printf("\n");
    80005c8e:	00002517          	auipc	a0,0x2
    80005c92:	3ba50513          	addi	a0,a0,954 # 80008048 <etext+0x48>
    80005c96:	00000097          	auipc	ra,0x0
    80005c9a:	014080e7          	jalr	20(ra) # 80005caa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c9e:	4785                	li	a5,1
    80005ca0:	00003717          	auipc	a4,0x3
    80005ca4:	c6f72e23          	sw	a5,-900(a4) # 8000891c <panicked>
  for(;;)
    80005ca8:	a001                	j	80005ca8 <panic+0x48>

0000000080005caa <printf>:
{
    80005caa:	7131                	addi	sp,sp,-192
    80005cac:	fc86                	sd	ra,120(sp)
    80005cae:	f8a2                	sd	s0,112(sp)
    80005cb0:	f4a6                	sd	s1,104(sp)
    80005cb2:	f0ca                	sd	s2,96(sp)
    80005cb4:	ecce                	sd	s3,88(sp)
    80005cb6:	e8d2                	sd	s4,80(sp)
    80005cb8:	e4d6                	sd	s5,72(sp)
    80005cba:	e0da                	sd	s6,64(sp)
    80005cbc:	fc5e                	sd	s7,56(sp)
    80005cbe:	f862                	sd	s8,48(sp)
    80005cc0:	f466                	sd	s9,40(sp)
    80005cc2:	f06a                	sd	s10,32(sp)
    80005cc4:	ec6e                	sd	s11,24(sp)
    80005cc6:	0100                	addi	s0,sp,128
    80005cc8:	8a2a                	mv	s4,a0
    80005cca:	e40c                	sd	a1,8(s0)
    80005ccc:	e810                	sd	a2,16(s0)
    80005cce:	ec14                	sd	a3,24(s0)
    80005cd0:	f018                	sd	a4,32(s0)
    80005cd2:	f41c                	sd	a5,40(s0)
    80005cd4:	03043823          	sd	a6,48(s0)
    80005cd8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cdc:	0001cd97          	auipc	s11,0x1c
    80005ce0:	284dad83          	lw	s11,644(s11) # 80021f60 <pr+0x18>
  if(locking)
    80005ce4:	020d9b63          	bnez	s11,80005d1a <printf+0x70>
  if (fmt == 0)
    80005ce8:	040a0263          	beqz	s4,80005d2c <printf+0x82>
  va_start(ap, fmt);
    80005cec:	00840793          	addi	a5,s0,8
    80005cf0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf4:	000a4503          	lbu	a0,0(s4)
    80005cf8:	14050f63          	beqz	a0,80005e56 <printf+0x1ac>
    80005cfc:	4981                	li	s3,0
    if(c != '%'){
    80005cfe:	02500a93          	li	s5,37
    switch(c){
    80005d02:	07000b93          	li	s7,112
  consputc('x');
    80005d06:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d08:	00003b17          	auipc	s6,0x3
    80005d0c:	b30b0b13          	addi	s6,s6,-1232 # 80008838 <digits>
    switch(c){
    80005d10:	07300c93          	li	s9,115
    80005d14:	06400c13          	li	s8,100
    80005d18:	a82d                	j	80005d52 <printf+0xa8>
    acquire(&pr.lock);
    80005d1a:	0001c517          	auipc	a0,0x1c
    80005d1e:	22e50513          	addi	a0,a0,558 # 80021f48 <pr>
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	47a080e7          	jalr	1146(ra) # 8000619c <acquire>
    80005d2a:	bf7d                	j	80005ce8 <printf+0x3e>
    panic("null fmt");
    80005d2c:	00003517          	auipc	a0,0x3
    80005d30:	af450513          	addi	a0,a0,-1292 # 80008820 <syscalls+0x450>
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	f2c080e7          	jalr	-212(ra) # 80005c60 <panic>
      consputc(c);
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	c60080e7          	jalr	-928(ra) # 8000599c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d44:	2985                	addiw	s3,s3,1
    80005d46:	013a07b3          	add	a5,s4,s3
    80005d4a:	0007c503          	lbu	a0,0(a5)
    80005d4e:	10050463          	beqz	a0,80005e56 <printf+0x1ac>
    if(c != '%'){
    80005d52:	ff5515e3          	bne	a0,s5,80005d3c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d56:	2985                	addiw	s3,s3,1
    80005d58:	013a07b3          	add	a5,s4,s3
    80005d5c:	0007c783          	lbu	a5,0(a5)
    80005d60:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d64:	cbed                	beqz	a5,80005e56 <printf+0x1ac>
    switch(c){
    80005d66:	05778a63          	beq	a5,s7,80005dba <printf+0x110>
    80005d6a:	02fbf663          	bgeu	s7,a5,80005d96 <printf+0xec>
    80005d6e:	09978863          	beq	a5,s9,80005dfe <printf+0x154>
    80005d72:	07800713          	li	a4,120
    80005d76:	0ce79563          	bne	a5,a4,80005e40 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d7a:	f8843783          	ld	a5,-120(s0)
    80005d7e:	00878713          	addi	a4,a5,8
    80005d82:	f8e43423          	sd	a4,-120(s0)
    80005d86:	4605                	li	a2,1
    80005d88:	85ea                	mv	a1,s10
    80005d8a:	4388                	lw	a0,0(a5)
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	e30080e7          	jalr	-464(ra) # 80005bbc <printint>
      break;
    80005d94:	bf45                	j	80005d44 <printf+0x9a>
    switch(c){
    80005d96:	09578f63          	beq	a5,s5,80005e34 <printf+0x18a>
    80005d9a:	0b879363          	bne	a5,s8,80005e40 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d9e:	f8843783          	ld	a5,-120(s0)
    80005da2:	00878713          	addi	a4,a5,8
    80005da6:	f8e43423          	sd	a4,-120(s0)
    80005daa:	4605                	li	a2,1
    80005dac:	45a9                	li	a1,10
    80005dae:	4388                	lw	a0,0(a5)
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	e0c080e7          	jalr	-500(ra) # 80005bbc <printint>
      break;
    80005db8:	b771                	j	80005d44 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dba:	f8843783          	ld	a5,-120(s0)
    80005dbe:	00878713          	addi	a4,a5,8
    80005dc2:	f8e43423          	sd	a4,-120(s0)
    80005dc6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dca:	03000513          	li	a0,48
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	bce080e7          	jalr	-1074(ra) # 8000599c <consputc>
  consputc('x');
    80005dd6:	07800513          	li	a0,120
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	bc2080e7          	jalr	-1086(ra) # 8000599c <consputc>
    80005de2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005de4:	03c95793          	srli	a5,s2,0x3c
    80005de8:	97da                	add	a5,a5,s6
    80005dea:	0007c503          	lbu	a0,0(a5)
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	bae080e7          	jalr	-1106(ra) # 8000599c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005df6:	0912                	slli	s2,s2,0x4
    80005df8:	34fd                	addiw	s1,s1,-1
    80005dfa:	f4ed                	bnez	s1,80005de4 <printf+0x13a>
    80005dfc:	b7a1                	j	80005d44 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005dfe:	f8843783          	ld	a5,-120(s0)
    80005e02:	00878713          	addi	a4,a5,8
    80005e06:	f8e43423          	sd	a4,-120(s0)
    80005e0a:	6384                	ld	s1,0(a5)
    80005e0c:	cc89                	beqz	s1,80005e26 <printf+0x17c>
      for(; *s; s++)
    80005e0e:	0004c503          	lbu	a0,0(s1)
    80005e12:	d90d                	beqz	a0,80005d44 <printf+0x9a>
        consputc(*s);
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	b88080e7          	jalr	-1144(ra) # 8000599c <consputc>
      for(; *s; s++)
    80005e1c:	0485                	addi	s1,s1,1
    80005e1e:	0004c503          	lbu	a0,0(s1)
    80005e22:	f96d                	bnez	a0,80005e14 <printf+0x16a>
    80005e24:	b705                	j	80005d44 <printf+0x9a>
        s = "(null)";
    80005e26:	00003497          	auipc	s1,0x3
    80005e2a:	9f248493          	addi	s1,s1,-1550 # 80008818 <syscalls+0x448>
      for(; *s; s++)
    80005e2e:	02800513          	li	a0,40
    80005e32:	b7cd                	j	80005e14 <printf+0x16a>
      consputc('%');
    80005e34:	8556                	mv	a0,s5
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	b66080e7          	jalr	-1178(ra) # 8000599c <consputc>
      break;
    80005e3e:	b719                	j	80005d44 <printf+0x9a>
      consputc('%');
    80005e40:	8556                	mv	a0,s5
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	b5a080e7          	jalr	-1190(ra) # 8000599c <consputc>
      consputc(c);
    80005e4a:	8526                	mv	a0,s1
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	b50080e7          	jalr	-1200(ra) # 8000599c <consputc>
      break;
    80005e54:	bdc5                	j	80005d44 <printf+0x9a>
  if(locking)
    80005e56:	020d9163          	bnez	s11,80005e78 <printf+0x1ce>
}
    80005e5a:	70e6                	ld	ra,120(sp)
    80005e5c:	7446                	ld	s0,112(sp)
    80005e5e:	74a6                	ld	s1,104(sp)
    80005e60:	7906                	ld	s2,96(sp)
    80005e62:	69e6                	ld	s3,88(sp)
    80005e64:	6a46                	ld	s4,80(sp)
    80005e66:	6aa6                	ld	s5,72(sp)
    80005e68:	6b06                	ld	s6,64(sp)
    80005e6a:	7be2                	ld	s7,56(sp)
    80005e6c:	7c42                	ld	s8,48(sp)
    80005e6e:	7ca2                	ld	s9,40(sp)
    80005e70:	7d02                	ld	s10,32(sp)
    80005e72:	6de2                	ld	s11,24(sp)
    80005e74:	6129                	addi	sp,sp,192
    80005e76:	8082                	ret
    release(&pr.lock);
    80005e78:	0001c517          	auipc	a0,0x1c
    80005e7c:	0d050513          	addi	a0,a0,208 # 80021f48 <pr>
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	3d0080e7          	jalr	976(ra) # 80006250 <release>
}
    80005e88:	bfc9                	j	80005e5a <printf+0x1b0>

0000000080005e8a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e8a:	1101                	addi	sp,sp,-32
    80005e8c:	ec06                	sd	ra,24(sp)
    80005e8e:	e822                	sd	s0,16(sp)
    80005e90:	e426                	sd	s1,8(sp)
    80005e92:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e94:	0001c497          	auipc	s1,0x1c
    80005e98:	0b448493          	addi	s1,s1,180 # 80021f48 <pr>
    80005e9c:	00003597          	auipc	a1,0x3
    80005ea0:	99458593          	addi	a1,a1,-1644 # 80008830 <syscalls+0x460>
    80005ea4:	8526                	mv	a0,s1
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	266080e7          	jalr	614(ra) # 8000610c <initlock>
  pr.locking = 1;
    80005eae:	4785                	li	a5,1
    80005eb0:	cc9c                	sw	a5,24(s1)
}
    80005eb2:	60e2                	ld	ra,24(sp)
    80005eb4:	6442                	ld	s0,16(sp)
    80005eb6:	64a2                	ld	s1,8(sp)
    80005eb8:	6105                	addi	sp,sp,32
    80005eba:	8082                	ret

0000000080005ebc <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ebc:	1141                	addi	sp,sp,-16
    80005ebe:	e406                	sd	ra,8(sp)
    80005ec0:	e022                	sd	s0,0(sp)
    80005ec2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ec4:	100007b7          	lui	a5,0x10000
    80005ec8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ecc:	f8000713          	li	a4,-128
    80005ed0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ed4:	470d                	li	a4,3
    80005ed6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005eda:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ede:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ee2:	469d                	li	a3,7
    80005ee4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ee8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005eec:	00003597          	auipc	a1,0x3
    80005ef0:	96458593          	addi	a1,a1,-1692 # 80008850 <digits+0x18>
    80005ef4:	0001c517          	auipc	a0,0x1c
    80005ef8:	07450513          	addi	a0,a0,116 # 80021f68 <uart_tx_lock>
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	210080e7          	jalr	528(ra) # 8000610c <initlock>
}
    80005f04:	60a2                	ld	ra,8(sp)
    80005f06:	6402                	ld	s0,0(sp)
    80005f08:	0141                	addi	sp,sp,16
    80005f0a:	8082                	ret

0000000080005f0c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f0c:	1101                	addi	sp,sp,-32
    80005f0e:	ec06                	sd	ra,24(sp)
    80005f10:	e822                	sd	s0,16(sp)
    80005f12:	e426                	sd	s1,8(sp)
    80005f14:	1000                	addi	s0,sp,32
    80005f16:	84aa                	mv	s1,a0
  push_off();
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	238080e7          	jalr	568(ra) # 80006150 <push_off>

  if(panicked){
    80005f20:	00003797          	auipc	a5,0x3
    80005f24:	9fc7a783          	lw	a5,-1540(a5) # 8000891c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f28:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f2c:	c391                	beqz	a5,80005f30 <uartputc_sync+0x24>
    for(;;)
    80005f2e:	a001                	j	80005f2e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f30:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f34:	0207f793          	andi	a5,a5,32
    80005f38:	dfe5                	beqz	a5,80005f30 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f3a:	0ff4f513          	andi	a0,s1,255
    80005f3e:	100007b7          	lui	a5,0x10000
    80005f42:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	2aa080e7          	jalr	682(ra) # 800061f0 <pop_off>
}
    80005f4e:	60e2                	ld	ra,24(sp)
    80005f50:	6442                	ld	s0,16(sp)
    80005f52:	64a2                	ld	s1,8(sp)
    80005f54:	6105                	addi	sp,sp,32
    80005f56:	8082                	ret

0000000080005f58 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f58:	00003797          	auipc	a5,0x3
    80005f5c:	9c87b783          	ld	a5,-1592(a5) # 80008920 <uart_tx_r>
    80005f60:	00003717          	auipc	a4,0x3
    80005f64:	9c873703          	ld	a4,-1592(a4) # 80008928 <uart_tx_w>
    80005f68:	06f70a63          	beq	a4,a5,80005fdc <uartstart+0x84>
{
    80005f6c:	7139                	addi	sp,sp,-64
    80005f6e:	fc06                	sd	ra,56(sp)
    80005f70:	f822                	sd	s0,48(sp)
    80005f72:	f426                	sd	s1,40(sp)
    80005f74:	f04a                	sd	s2,32(sp)
    80005f76:	ec4e                	sd	s3,24(sp)
    80005f78:	e852                	sd	s4,16(sp)
    80005f7a:	e456                	sd	s5,8(sp)
    80005f7c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f7e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f82:	0001ca17          	auipc	s4,0x1c
    80005f86:	fe6a0a13          	addi	s4,s4,-26 # 80021f68 <uart_tx_lock>
    uart_tx_r += 1;
    80005f8a:	00003497          	auipc	s1,0x3
    80005f8e:	99648493          	addi	s1,s1,-1642 # 80008920 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f92:	00003997          	auipc	s3,0x3
    80005f96:	99698993          	addi	s3,s3,-1642 # 80008928 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f9a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f9e:	02077713          	andi	a4,a4,32
    80005fa2:	c705                	beqz	a4,80005fca <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fa4:	01f7f713          	andi	a4,a5,31
    80005fa8:	9752                	add	a4,a4,s4
    80005faa:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fae:	0785                	addi	a5,a5,1
    80005fb0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fb2:	8526                	mv	a0,s1
    80005fb4:	ffffb097          	auipc	ra,0xffffb
    80005fb8:	682080e7          	jalr	1666(ra) # 80001636 <wakeup>
    
    WriteReg(THR, c);
    80005fbc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fc0:	609c                	ld	a5,0(s1)
    80005fc2:	0009b703          	ld	a4,0(s3)
    80005fc6:	fcf71ae3          	bne	a4,a5,80005f9a <uartstart+0x42>
  }
}
    80005fca:	70e2                	ld	ra,56(sp)
    80005fcc:	7442                	ld	s0,48(sp)
    80005fce:	74a2                	ld	s1,40(sp)
    80005fd0:	7902                	ld	s2,32(sp)
    80005fd2:	69e2                	ld	s3,24(sp)
    80005fd4:	6a42                	ld	s4,16(sp)
    80005fd6:	6aa2                	ld	s5,8(sp)
    80005fd8:	6121                	addi	sp,sp,64
    80005fda:	8082                	ret
    80005fdc:	8082                	ret

0000000080005fde <uartputc>:
{
    80005fde:	7179                	addi	sp,sp,-48
    80005fe0:	f406                	sd	ra,40(sp)
    80005fe2:	f022                	sd	s0,32(sp)
    80005fe4:	ec26                	sd	s1,24(sp)
    80005fe6:	e84a                	sd	s2,16(sp)
    80005fe8:	e44e                	sd	s3,8(sp)
    80005fea:	e052                	sd	s4,0(sp)
    80005fec:	1800                	addi	s0,sp,48
    80005fee:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005ff0:	0001c517          	auipc	a0,0x1c
    80005ff4:	f7850513          	addi	a0,a0,-136 # 80021f68 <uart_tx_lock>
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	1a4080e7          	jalr	420(ra) # 8000619c <acquire>
  if(panicked){
    80006000:	00003797          	auipc	a5,0x3
    80006004:	91c7a783          	lw	a5,-1764(a5) # 8000891c <panicked>
    80006008:	e7c9                	bnez	a5,80006092 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000600a:	00003717          	auipc	a4,0x3
    8000600e:	91e73703          	ld	a4,-1762(a4) # 80008928 <uart_tx_w>
    80006012:	00003797          	auipc	a5,0x3
    80006016:	90e7b783          	ld	a5,-1778(a5) # 80008920 <uart_tx_r>
    8000601a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000601e:	0001c997          	auipc	s3,0x1c
    80006022:	f4a98993          	addi	s3,s3,-182 # 80021f68 <uart_tx_lock>
    80006026:	00003497          	auipc	s1,0x3
    8000602a:	8fa48493          	addi	s1,s1,-1798 # 80008920 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000602e:	00003917          	auipc	s2,0x3
    80006032:	8fa90913          	addi	s2,s2,-1798 # 80008928 <uart_tx_w>
    80006036:	00e79f63          	bne	a5,a4,80006054 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000603a:	85ce                	mv	a1,s3
    8000603c:	8526                	mv	a0,s1
    8000603e:	ffffb097          	auipc	ra,0xffffb
    80006042:	594080e7          	jalr	1428(ra) # 800015d2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006046:	00093703          	ld	a4,0(s2)
    8000604a:	609c                	ld	a5,0(s1)
    8000604c:	02078793          	addi	a5,a5,32
    80006050:	fee785e3          	beq	a5,a4,8000603a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006054:	0001c497          	auipc	s1,0x1c
    80006058:	f1448493          	addi	s1,s1,-236 # 80021f68 <uart_tx_lock>
    8000605c:	01f77793          	andi	a5,a4,31
    80006060:	97a6                	add	a5,a5,s1
    80006062:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006066:	0705                	addi	a4,a4,1
    80006068:	00003797          	auipc	a5,0x3
    8000606c:	8ce7b023          	sd	a4,-1856(a5) # 80008928 <uart_tx_w>
  uartstart();
    80006070:	00000097          	auipc	ra,0x0
    80006074:	ee8080e7          	jalr	-280(ra) # 80005f58 <uartstart>
  release(&uart_tx_lock);
    80006078:	8526                	mv	a0,s1
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	1d6080e7          	jalr	470(ra) # 80006250 <release>
}
    80006082:	70a2                	ld	ra,40(sp)
    80006084:	7402                	ld	s0,32(sp)
    80006086:	64e2                	ld	s1,24(sp)
    80006088:	6942                	ld	s2,16(sp)
    8000608a:	69a2                	ld	s3,8(sp)
    8000608c:	6a02                	ld	s4,0(sp)
    8000608e:	6145                	addi	sp,sp,48
    80006090:	8082                	ret
    for(;;)
    80006092:	a001                	j	80006092 <uartputc+0xb4>

0000000080006094 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006094:	1141                	addi	sp,sp,-16
    80006096:	e422                	sd	s0,8(sp)
    80006098:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000609a:	100007b7          	lui	a5,0x10000
    8000609e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060a2:	8b85                	andi	a5,a5,1
    800060a4:	cb91                	beqz	a5,800060b8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060a6:	100007b7          	lui	a5,0x10000
    800060aa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060ae:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060b2:	6422                	ld	s0,8(sp)
    800060b4:	0141                	addi	sp,sp,16
    800060b6:	8082                	ret
    return -1;
    800060b8:	557d                	li	a0,-1
    800060ba:	bfe5                	j	800060b2 <uartgetc+0x1e>

00000000800060bc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060bc:	1101                	addi	sp,sp,-32
    800060be:	ec06                	sd	ra,24(sp)
    800060c0:	e822                	sd	s0,16(sp)
    800060c2:	e426                	sd	s1,8(sp)
    800060c4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060c6:	54fd                	li	s1,-1
    800060c8:	a029                	j	800060d2 <uartintr+0x16>
      break;
    consoleintr(c);
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	914080e7          	jalr	-1772(ra) # 800059de <consoleintr>
    int c = uartgetc();
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	fc2080e7          	jalr	-62(ra) # 80006094 <uartgetc>
    if(c == -1)
    800060da:	fe9518e3          	bne	a0,s1,800060ca <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060de:	0001c497          	auipc	s1,0x1c
    800060e2:	e8a48493          	addi	s1,s1,-374 # 80021f68 <uart_tx_lock>
    800060e6:	8526                	mv	a0,s1
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	0b4080e7          	jalr	180(ra) # 8000619c <acquire>
  uartstart();
    800060f0:	00000097          	auipc	ra,0x0
    800060f4:	e68080e7          	jalr	-408(ra) # 80005f58 <uartstart>
  release(&uart_tx_lock);
    800060f8:	8526                	mv	a0,s1
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	156080e7          	jalr	342(ra) # 80006250 <release>
}
    80006102:	60e2                	ld	ra,24(sp)
    80006104:	6442                	ld	s0,16(sp)
    80006106:	64a2                	ld	s1,8(sp)
    80006108:	6105                	addi	sp,sp,32
    8000610a:	8082                	ret

000000008000610c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000610c:	1141                	addi	sp,sp,-16
    8000610e:	e422                	sd	s0,8(sp)
    80006110:	0800                	addi	s0,sp,16
  lk->name = name;
    80006112:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006114:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006118:	00053823          	sd	zero,16(a0)
}
    8000611c:	6422                	ld	s0,8(sp)
    8000611e:	0141                	addi	sp,sp,16
    80006120:	8082                	ret

0000000080006122 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006122:	411c                	lw	a5,0(a0)
    80006124:	e399                	bnez	a5,8000612a <holding+0x8>
    80006126:	4501                	li	a0,0
  return r;
}
    80006128:	8082                	ret
{
    8000612a:	1101                	addi	sp,sp,-32
    8000612c:	ec06                	sd	ra,24(sp)
    8000612e:	e822                	sd	s0,16(sp)
    80006130:	e426                	sd	s1,8(sp)
    80006132:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006134:	6904                	ld	s1,16(a0)
    80006136:	ffffb097          	auipc	ra,0xffffb
    8000613a:	cfc080e7          	jalr	-772(ra) # 80000e32 <mycpu>
    8000613e:	40a48533          	sub	a0,s1,a0
    80006142:	00153513          	seqz	a0,a0
}
    80006146:	60e2                	ld	ra,24(sp)
    80006148:	6442                	ld	s0,16(sp)
    8000614a:	64a2                	ld	s1,8(sp)
    8000614c:	6105                	addi	sp,sp,32
    8000614e:	8082                	ret

0000000080006150 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006150:	1101                	addi	sp,sp,-32
    80006152:	ec06                	sd	ra,24(sp)
    80006154:	e822                	sd	s0,16(sp)
    80006156:	e426                	sd	s1,8(sp)
    80006158:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000615a:	100024f3          	csrr	s1,sstatus
    8000615e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006162:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006164:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006168:	ffffb097          	auipc	ra,0xffffb
    8000616c:	cca080e7          	jalr	-822(ra) # 80000e32 <mycpu>
    80006170:	5d3c                	lw	a5,120(a0)
    80006172:	cf89                	beqz	a5,8000618c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006174:	ffffb097          	auipc	ra,0xffffb
    80006178:	cbe080e7          	jalr	-834(ra) # 80000e32 <mycpu>
    8000617c:	5d3c                	lw	a5,120(a0)
    8000617e:	2785                	addiw	a5,a5,1
    80006180:	dd3c                	sw	a5,120(a0)
}
    80006182:	60e2                	ld	ra,24(sp)
    80006184:	6442                	ld	s0,16(sp)
    80006186:	64a2                	ld	s1,8(sp)
    80006188:	6105                	addi	sp,sp,32
    8000618a:	8082                	ret
    mycpu()->intena = old;
    8000618c:	ffffb097          	auipc	ra,0xffffb
    80006190:	ca6080e7          	jalr	-858(ra) # 80000e32 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006194:	8085                	srli	s1,s1,0x1
    80006196:	8885                	andi	s1,s1,1
    80006198:	dd64                	sw	s1,124(a0)
    8000619a:	bfe9                	j	80006174 <push_off+0x24>

000000008000619c <acquire>:
{
    8000619c:	1101                	addi	sp,sp,-32
    8000619e:	ec06                	sd	ra,24(sp)
    800061a0:	e822                	sd	s0,16(sp)
    800061a2:	e426                	sd	s1,8(sp)
    800061a4:	1000                	addi	s0,sp,32
    800061a6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	fa8080e7          	jalr	-88(ra) # 80006150 <push_off>
  if(holding(lk))
    800061b0:	8526                	mv	a0,s1
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	f70080e7          	jalr	-144(ra) # 80006122 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ba:	4705                	li	a4,1
  if(holding(lk))
    800061bc:	e115                	bnez	a0,800061e0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061be:	87ba                	mv	a5,a4
    800061c0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061c4:	2781                	sext.w	a5,a5
    800061c6:	ffe5                	bnez	a5,800061be <acquire+0x22>
  __sync_synchronize();
    800061c8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061cc:	ffffb097          	auipc	ra,0xffffb
    800061d0:	c66080e7          	jalr	-922(ra) # 80000e32 <mycpu>
    800061d4:	e888                	sd	a0,16(s1)
}
    800061d6:	60e2                	ld	ra,24(sp)
    800061d8:	6442                	ld	s0,16(sp)
    800061da:	64a2                	ld	s1,8(sp)
    800061dc:	6105                	addi	sp,sp,32
    800061de:	8082                	ret
    panic("acquire");
    800061e0:	00002517          	auipc	a0,0x2
    800061e4:	67850513          	addi	a0,a0,1656 # 80008858 <digits+0x20>
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	a78080e7          	jalr	-1416(ra) # 80005c60 <panic>

00000000800061f0 <pop_off>:

void
pop_off(void)
{
    800061f0:	1141                	addi	sp,sp,-16
    800061f2:	e406                	sd	ra,8(sp)
    800061f4:	e022                	sd	s0,0(sp)
    800061f6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	c3a080e7          	jalr	-966(ra) # 80000e32 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006200:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006204:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006206:	e78d                	bnez	a5,80006230 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006208:	5d3c                	lw	a5,120(a0)
    8000620a:	02f05b63          	blez	a5,80006240 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000620e:	37fd                	addiw	a5,a5,-1
    80006210:	0007871b          	sext.w	a4,a5
    80006214:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006216:	eb09                	bnez	a4,80006228 <pop_off+0x38>
    80006218:	5d7c                	lw	a5,124(a0)
    8000621a:	c799                	beqz	a5,80006228 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000621c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006220:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006224:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006228:	60a2                	ld	ra,8(sp)
    8000622a:	6402                	ld	s0,0(sp)
    8000622c:	0141                	addi	sp,sp,16
    8000622e:	8082                	ret
    panic("pop_off - interruptible");
    80006230:	00002517          	auipc	a0,0x2
    80006234:	63050513          	addi	a0,a0,1584 # 80008860 <digits+0x28>
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	a28080e7          	jalr	-1496(ra) # 80005c60 <panic>
    panic("pop_off");
    80006240:	00002517          	auipc	a0,0x2
    80006244:	63850513          	addi	a0,a0,1592 # 80008878 <digits+0x40>
    80006248:	00000097          	auipc	ra,0x0
    8000624c:	a18080e7          	jalr	-1512(ra) # 80005c60 <panic>

0000000080006250 <release>:
{
    80006250:	1101                	addi	sp,sp,-32
    80006252:	ec06                	sd	ra,24(sp)
    80006254:	e822                	sd	s0,16(sp)
    80006256:	e426                	sd	s1,8(sp)
    80006258:	1000                	addi	s0,sp,32
    8000625a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000625c:	00000097          	auipc	ra,0x0
    80006260:	ec6080e7          	jalr	-314(ra) # 80006122 <holding>
    80006264:	c115                	beqz	a0,80006288 <release+0x38>
  lk->cpu = 0;
    80006266:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000626a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000626e:	0f50000f          	fence	iorw,ow
    80006272:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006276:	00000097          	auipc	ra,0x0
    8000627a:	f7a080e7          	jalr	-134(ra) # 800061f0 <pop_off>
}
    8000627e:	60e2                	ld	ra,24(sp)
    80006280:	6442                	ld	s0,16(sp)
    80006282:	64a2                	ld	s1,8(sp)
    80006284:	6105                	addi	sp,sp,32
    80006286:	8082                	ret
    panic("release");
    80006288:	00002517          	auipc	a0,0x2
    8000628c:	5f850513          	addi	a0,a0,1528 # 80008880 <digits+0x48>
    80006290:	00000097          	auipc	ra,0x0
    80006294:	9d0080e7          	jalr	-1584(ra) # 80005c60 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
