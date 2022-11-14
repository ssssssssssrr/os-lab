
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	189050ef          	jal	ra,8000599e <start>

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
    80000034:	fa078793          	addi	a5,a5,-96 # 80021fd0 <end>
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
    80000054:	91090913          	addi	s2,s2,-1776 # 80008960 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	332080e7          	jalr	818(ra) # 8000638c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3d2080e7          	jalr	978(ra) # 80006440 <release>
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
    8000008e:	dc6080e7          	jalr	-570(ra) # 80005e50 <panic>

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
    800000f0:	87450513          	addi	a0,a0,-1932 # 80008960 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	208080e7          	jalr	520(ra) # 800062fc <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	ed050513          	addi	a0,a0,-304 # 80021fd0 <end>
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
    80000126:	83e48493          	addi	s1,s1,-1986 # 80008960 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	260080e7          	jalr	608(ra) # 8000638c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	82650513          	addi	a0,a0,-2010 # 80008960 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	2fc080e7          	jalr	764(ra) # 80006440 <release>

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
    8000016a:	7fa50513          	addi	a0,a0,2042 # 80008960 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	2d2080e7          	jalr	722(ra) # 80006440 <release>
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
    8000032a:	bf6080e7          	jalr	-1034(ra) # 80000f1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	60270713          	addi	a4,a4,1538 # 80008930 <started>
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
    80000346:	bda080e7          	jalr	-1062(ra) # 80000f1c <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	b46080e7          	jalr	-1210(ra) # 80005e9a <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	95c080e7          	jalr	-1700(ra) # 80001cc0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	fe4080e7          	jalr	-28(ra) # 80005350 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	1a6080e7          	jalr	422(ra) # 8000151a <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	9e4080e7          	jalr	-1564(ra) # 80005d60 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	cf6080e7          	jalr	-778(ra) # 8000607a <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	b06080e7          	jalr	-1274(ra) # 80005e9a <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	af6080e7          	jalr	-1290(ra) # 80005e9a <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	ae6080e7          	jalr	-1306(ra) # 80005e9a <printf>
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
    800003d8:	a96080e7          	jalr	-1386(ra) # 80000e6a <procinit>
    trapinit();      // trap vectors
    800003dc:	00002097          	auipc	ra,0x2
    800003e0:	8bc080e7          	jalr	-1860(ra) # 80001c98 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	8dc080e7          	jalr	-1828(ra) # 80001cc0 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	f4e080e7          	jalr	-178(ra) # 8000533a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f5c080e7          	jalr	-164(ra) # 80005350 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	0ea080e7          	jalr	234(ra) # 800024e6 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	78e080e7          	jalr	1934(ra) # 80002b92 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	72c080e7          	jalr	1836(ra) # 80003b38 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	044080e7          	jalr	68(ra) # 80005458 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	ee0080e7          	jalr	-288(ra) # 800012fc <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	50f72323          	sw	a5,1286(a4) # 80008930 <started>
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
    80000442:	4fa7b783          	ld	a5,1274(a5) # 80008938 <kernel_pagetable>
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
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	9c6080e7          	jalr	-1594(ra) # 80005e50 <panic>
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
    800005b0:	00006097          	auipc	ra,0x6
    800005b4:	8a0080e7          	jalr	-1888(ra) # 80005e50 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00006097          	auipc	ra,0x6
    800005c4:	890080e7          	jalr	-1904(ra) # 80005e50 <panic>
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
    8000060c:	00006097          	auipc	ra,0x6
    80000610:	844080e7          	jalr	-1980(ra) # 80005e50 <panic>

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
    800006d8:	702080e7          	jalr	1794(ra) # 80000dd6 <proc_mapstacks>
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
    800006fe:	22a7bf23          	sd	a0,574(a5) # 80008938 <kernel_pagetable>
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
    8000075c:	6f8080e7          	jalr	1784(ra) # 80005e50 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	6e8080e7          	jalr	1768(ra) # 80005e50 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	6d8080e7          	jalr	1752(ra) # 80005e50 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	6c8080e7          	jalr	1736(ra) # 80005e50 <panic>
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
    8000086a:	5ea080e7          	jalr	1514(ra) # 80005e50 <panic>

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
    800009b4:	4a0080e7          	jalr	1184(ra) # 80005e50 <panic>
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
    80000a90:	3c4080e7          	jalr	964(ra) # 80005e50 <panic>
      panic("uvmcopy: page not present");
    80000a94:	00007517          	auipc	a0,0x7
    80000a98:	69450513          	addi	a0,a0,1684 # 80008128 <etext+0x128>
    80000a9c:	00005097          	auipc	ra,0x5
    80000aa0:	3b4080e7          	jalr	948(ra) # 80005e50 <panic>
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
    80000b0a:	34a080e7          	jalr	842(ra) # 80005e50 <panic>

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

0000000080000cdc <pgprint>:
int
pgprint(pagetable_t pagetable, int level)
{
    80000cdc:	7159                	addi	sp,sp,-112
    80000cde:	f486                	sd	ra,104(sp)
    80000ce0:	f0a2                	sd	s0,96(sp)
    80000ce2:	eca6                	sd	s1,88(sp)
    80000ce4:	e8ca                	sd	s2,80(sp)
    80000ce6:	e4ce                	sd	s3,72(sp)
    80000ce8:	e0d2                	sd	s4,64(sp)
    80000cea:	fc56                	sd	s5,56(sp)
    80000cec:	f85a                	sd	s6,48(sp)
    80000cee:	f45e                	sd	s7,40(sp)
    80000cf0:	f062                	sd	s8,32(sp)
    80000cf2:	ec66                	sd	s9,24(sp)
    80000cf4:	e86a                	sd	s10,16(sp)
    80000cf6:	e46e                	sd	s11,8(sp)
    80000cf8:	1880                	addi	s0,sp,112
    80000cfa:	8aae                	mv	s5,a1
	// there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; ++i) {
    80000cfc:	89aa                	mv	s3,a0
    80000cfe:	4901                	li	s2,0
    pte_t pte = pagetable[i];
    if(pte & PTE_V) { // valid
      printf("..");
    80000d00:	00007c97          	auipc	s9,0x7
    80000d04:	458c8c93          	addi	s9,s9,1112 # 80008158 <etext+0x158>
      for(int k = 0; k < level; ++k) {
        printf(" ..");
      }
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      printf("%d: pte %p pa %p\\n", i, pte, child); // 打印页表内容
    80000d08:	00007c17          	auipc	s8,0x7
    80000d0c:	460c0c13          	addi	s8,s8,1120 # 80008168 <etext+0x168>
      if((pte & (PTE_R|PTE_W|PTE_X)) == 0) {
	// 递归打印下一级页表
        pgprint((pagetable_t)child, level+1);
    80000d10:	00158d9b          	addiw	s11,a1,1
      for(int k = 0; k < level; ++k) {
    80000d14:	4d01                	li	s10,0
        printf(" ..");
    80000d16:	00007b17          	auipc	s6,0x7
    80000d1a:	44ab0b13          	addi	s6,s6,1098 # 80008160 <etext+0x160>
  for(int i = 0; i < 512; ++i) {
    80000d1e:	20000b93          	li	s7,512
    80000d22:	a029                	j	80000d2c <pgprint+0x50>
    80000d24:	2905                	addiw	s2,s2,1
    80000d26:	09a1                	addi	s3,s3,8
    80000d28:	05790d63          	beq	s2,s7,80000d82 <pgprint+0xa6>
    pte_t pte = pagetable[i];
    80000d2c:	0009ba03          	ld	s4,0(s3) # 1000 <_entry-0x7ffff000>
    if(pte & PTE_V) { // valid
    80000d30:	001a7793          	andi	a5,s4,1
    80000d34:	dbe5                	beqz	a5,80000d24 <pgprint+0x48>
      printf("..");
    80000d36:	8566                	mv	a0,s9
    80000d38:	00005097          	auipc	ra,0x5
    80000d3c:	162080e7          	jalr	354(ra) # 80005e9a <printf>
      for(int k = 0; k < level; ++k) {
    80000d40:	01505b63          	blez	s5,80000d56 <pgprint+0x7a>
    80000d44:	84ea                	mv	s1,s10
        printf(" ..");
    80000d46:	855a                	mv	a0,s6
    80000d48:	00005097          	auipc	ra,0x5
    80000d4c:	152080e7          	jalr	338(ra) # 80005e9a <printf>
      for(int k = 0; k < level; ++k) {
    80000d50:	2485                	addiw	s1,s1,1
    80000d52:	fe9a9ae3          	bne	s5,s1,80000d46 <pgprint+0x6a>
      uint64 child = PTE2PA(pte);
    80000d56:	00aa5493          	srli	s1,s4,0xa
    80000d5a:	04b2                	slli	s1,s1,0xc
      printf("%d: pte %p pa %p\\n", i, pte, child); // 打印页表内容
    80000d5c:	86a6                	mv	a3,s1
    80000d5e:	8652                	mv	a2,s4
    80000d60:	85ca                	mv	a1,s2
    80000d62:	8562                	mv	a0,s8
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	136080e7          	jalr	310(ra) # 80005e9a <printf>
      if((pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80000d6c:	00ea7a13          	andi	s4,s4,14
    80000d70:	fa0a1ae3          	bnez	s4,80000d24 <pgprint+0x48>
        pgprint((pagetable_t)child, level+1);
    80000d74:	85ee                	mv	a1,s11
    80000d76:	8526                	mv	a0,s1
    80000d78:	00000097          	auipc	ra,0x0
    80000d7c:	f64080e7          	jalr	-156(ra) # 80000cdc <pgprint>
    80000d80:	b755                	j	80000d24 <pgprint+0x48>
      }
    }
  }
  return 0;
}
    80000d82:	4501                	li	a0,0
    80000d84:	70a6                	ld	ra,104(sp)
    80000d86:	7406                	ld	s0,96(sp)
    80000d88:	64e6                	ld	s1,88(sp)
    80000d8a:	6946                	ld	s2,80(sp)
    80000d8c:	69a6                	ld	s3,72(sp)
    80000d8e:	6a06                	ld	s4,64(sp)
    80000d90:	7ae2                	ld	s5,56(sp)
    80000d92:	7b42                	ld	s6,48(sp)
    80000d94:	7ba2                	ld	s7,40(sp)
    80000d96:	7c02                	ld	s8,32(sp)
    80000d98:	6ce2                	ld	s9,24(sp)
    80000d9a:	6d42                	ld	s10,16(sp)
    80000d9c:	6da2                	ld	s11,8(sp)
    80000d9e:	6165                	addi	sp,sp,112
    80000da0:	8082                	ret

0000000080000da2 <vmprint>:

void
vmprint(pagetable_t pagetable) {
    80000da2:	1101                	addi	sp,sp,-32
    80000da4:	ec06                	sd	ra,24(sp)
    80000da6:	e822                	sd	s0,16(sp)
    80000da8:	e426                	sd	s1,8(sp)
    80000daa:	1000                	addi	s0,sp,32
    80000dac:	84aa                	mv	s1,a0
  // 打印第一行
  printf("page table %p\\n", pagetable); 
    80000dae:	85aa                	mv	a1,a0
    80000db0:	00007517          	auipc	a0,0x7
    80000db4:	3d050513          	addi	a0,a0,976 # 80008180 <etext+0x180>
    80000db8:	00005097          	auipc	ra,0x5
    80000dbc:	0e2080e7          	jalr	226(ra) # 80005e9a <printf>
  pgprint(pagetable, 0);
    80000dc0:	4581                	li	a1,0
    80000dc2:	8526                	mv	a0,s1
    80000dc4:	00000097          	auipc	ra,0x0
    80000dc8:	f18080e7          	jalr	-232(ra) # 80000cdc <pgprint>
}
    80000dcc:	60e2                	ld	ra,24(sp)
    80000dce:	6442                	ld	s0,16(sp)
    80000dd0:	64a2                	ld	s1,8(sp)
    80000dd2:	6105                	addi	sp,sp,32
    80000dd4:	8082                	ret

0000000080000dd6 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dd6:	7139                	addi	sp,sp,-64
    80000dd8:	fc06                	sd	ra,56(sp)
    80000dda:	f822                	sd	s0,48(sp)
    80000ddc:	f426                	sd	s1,40(sp)
    80000dde:	f04a                	sd	s2,32(sp)
    80000de0:	ec4e                	sd	s3,24(sp)
    80000de2:	e852                	sd	s4,16(sp)
    80000de4:	e456                	sd	s5,8(sp)
    80000de6:	e05a                	sd	s6,0(sp)
    80000de8:	0080                	addi	s0,sp,64
    80000dea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dec:	00008497          	auipc	s1,0x8
    80000df0:	fc448493          	addi	s1,s1,-60 # 80008db0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000df4:	8b26                	mv	s6,s1
    80000df6:	00007a97          	auipc	s5,0x7
    80000dfa:	20aa8a93          	addi	s5,s5,522 # 80008000 <etext>
    80000dfe:	01000937          	lui	s2,0x1000
    80000e02:	197d                	addi	s2,s2,-1
    80000e04:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e06:	0000ea17          	auipc	s4,0xe
    80000e0a:	baaa0a13          	addi	s4,s4,-1110 # 8000e9b0 <tickslock>
    char *pa = kalloc();
    80000e0e:	fffff097          	auipc	ra,0xfffff
    80000e12:	30a080e7          	jalr	778(ra) # 80000118 <kalloc>
    80000e16:	862a                	mv	a2,a0
    if(pa == 0)
    80000e18:	c129                	beqz	a0,80000e5a <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e1a:	416485b3          	sub	a1,s1,s6
    80000e1e:	8591                	srai	a1,a1,0x4
    80000e20:	000ab783          	ld	a5,0(s5)
    80000e24:	02f585b3          	mul	a1,a1,a5
    80000e28:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e2c:	4719                	li	a4,6
    80000e2e:	6685                	lui	a3,0x1
    80000e30:	40b905b3          	sub	a1,s2,a1
    80000e34:	854e                	mv	a0,s3
    80000e36:	fffff097          	auipc	ra,0xfffff
    80000e3a:	7ae080e7          	jalr	1966(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3e:	17048493          	addi	s1,s1,368
    80000e42:	fd4496e3          	bne	s1,s4,80000e0e <proc_mapstacks+0x38>
  }
}
    80000e46:	70e2                	ld	ra,56(sp)
    80000e48:	7442                	ld	s0,48(sp)
    80000e4a:	74a2                	ld	s1,40(sp)
    80000e4c:	7902                	ld	s2,32(sp)
    80000e4e:	69e2                	ld	s3,24(sp)
    80000e50:	6a42                	ld	s4,16(sp)
    80000e52:	6aa2                	ld	s5,8(sp)
    80000e54:	6b02                	ld	s6,0(sp)
    80000e56:	6121                	addi	sp,sp,64
    80000e58:	8082                	ret
      panic("kalloc");
    80000e5a:	00007517          	auipc	a0,0x7
    80000e5e:	33650513          	addi	a0,a0,822 # 80008190 <etext+0x190>
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	fee080e7          	jalr	-18(ra) # 80005e50 <panic>

0000000080000e6a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e6a:	7139                	addi	sp,sp,-64
    80000e6c:	fc06                	sd	ra,56(sp)
    80000e6e:	f822                	sd	s0,48(sp)
    80000e70:	f426                	sd	s1,40(sp)
    80000e72:	f04a                	sd	s2,32(sp)
    80000e74:	ec4e                	sd	s3,24(sp)
    80000e76:	e852                	sd	s4,16(sp)
    80000e78:	e456                	sd	s5,8(sp)
    80000e7a:	e05a                	sd	s6,0(sp)
    80000e7c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e7e:	00007597          	auipc	a1,0x7
    80000e82:	31a58593          	addi	a1,a1,794 # 80008198 <etext+0x198>
    80000e86:	00008517          	auipc	a0,0x8
    80000e8a:	afa50513          	addi	a0,a0,-1286 # 80008980 <pid_lock>
    80000e8e:	00005097          	auipc	ra,0x5
    80000e92:	46e080e7          	jalr	1134(ra) # 800062fc <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e96:	00007597          	auipc	a1,0x7
    80000e9a:	30a58593          	addi	a1,a1,778 # 800081a0 <etext+0x1a0>
    80000e9e:	00008517          	auipc	a0,0x8
    80000ea2:	afa50513          	addi	a0,a0,-1286 # 80008998 <wait_lock>
    80000ea6:	00005097          	auipc	ra,0x5
    80000eaa:	456080e7          	jalr	1110(ra) # 800062fc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eae:	00008497          	auipc	s1,0x8
    80000eb2:	f0248493          	addi	s1,s1,-254 # 80008db0 <proc>
      initlock(&p->lock, "proc");
    80000eb6:	00007b17          	auipc	s6,0x7
    80000eba:	2fab0b13          	addi	s6,s6,762 # 800081b0 <etext+0x1b0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ebe:	8aa6                	mv	s5,s1
    80000ec0:	00007a17          	auipc	s4,0x7
    80000ec4:	140a0a13          	addi	s4,s4,320 # 80008000 <etext>
    80000ec8:	01000937          	lui	s2,0x1000
    80000ecc:	197d                	addi	s2,s2,-1
    80000ece:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed0:	0000e997          	auipc	s3,0xe
    80000ed4:	ae098993          	addi	s3,s3,-1312 # 8000e9b0 <tickslock>
      initlock(&p->lock, "proc");
    80000ed8:	85da                	mv	a1,s6
    80000eda:	8526                	mv	a0,s1
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	420080e7          	jalr	1056(ra) # 800062fc <initlock>
      p->state = UNUSED;
    80000ee4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ee8:	415487b3          	sub	a5,s1,s5
    80000eec:	8791                	srai	a5,a5,0x4
    80000eee:	000a3703          	ld	a4,0(s4)
    80000ef2:	02e787b3          	mul	a5,a5,a4
    80000ef6:	00d7979b          	slliw	a5,a5,0xd
    80000efa:	40f907b3          	sub	a5,s2,a5
    80000efe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f00:	17048493          	addi	s1,s1,368
    80000f04:	fd349ae3          	bne	s1,s3,80000ed8 <procinit+0x6e>
  }
}
    80000f08:	70e2                	ld	ra,56(sp)
    80000f0a:	7442                	ld	s0,48(sp)
    80000f0c:	74a2                	ld	s1,40(sp)
    80000f0e:	7902                	ld	s2,32(sp)
    80000f10:	69e2                	ld	s3,24(sp)
    80000f12:	6a42                	ld	s4,16(sp)
    80000f14:	6aa2                	ld	s5,8(sp)
    80000f16:	6b02                	ld	s6,0(sp)
    80000f18:	6121                	addi	sp,sp,64
    80000f1a:	8082                	ret

0000000080000f1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f1c:	1141                	addi	sp,sp,-16
    80000f1e:	e422                	sd	s0,8(sp)
    80000f20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f24:	2501                	sext.w	a0,a0
    80000f26:	6422                	ld	s0,8(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret

0000000080000f2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f2c:	1141                	addi	sp,sp,-16
    80000f2e:	e422                	sd	s0,8(sp)
    80000f30:	0800                	addi	s0,sp,16
    80000f32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f34:	2781                	sext.w	a5,a5
    80000f36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f38:	00008517          	auipc	a0,0x8
    80000f3c:	a7850513          	addi	a0,a0,-1416 # 800089b0 <cpus>
    80000f40:	953e                	add	a0,a0,a5
    80000f42:	6422                	ld	s0,8(sp)
    80000f44:	0141                	addi	sp,sp,16
    80000f46:	8082                	ret

0000000080000f48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f48:	1101                	addi	sp,sp,-32
    80000f4a:	ec06                	sd	ra,24(sp)
    80000f4c:	e822                	sd	s0,16(sp)
    80000f4e:	e426                	sd	s1,8(sp)
    80000f50:	1000                	addi	s0,sp,32
  push_off();
    80000f52:	00005097          	auipc	ra,0x5
    80000f56:	3ee080e7          	jalr	1006(ra) # 80006340 <push_off>
    80000f5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f5c:	2781                	sext.w	a5,a5
    80000f5e:	079e                	slli	a5,a5,0x7
    80000f60:	00008717          	auipc	a4,0x8
    80000f64:	a2070713          	addi	a4,a4,-1504 # 80008980 <pid_lock>
    80000f68:	97ba                	add	a5,a5,a4
    80000f6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	474080e7          	jalr	1140(ra) # 800063e0 <pop_off>
  return p;
}
    80000f74:	8526                	mv	a0,s1
    80000f76:	60e2                	ld	ra,24(sp)
    80000f78:	6442                	ld	s0,16(sp)
    80000f7a:	64a2                	ld	s1,8(sp)
    80000f7c:	6105                	addi	sp,sp,32
    80000f7e:	8082                	ret

0000000080000f80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f80:	1141                	addi	sp,sp,-16
    80000f82:	e406                	sd	ra,8(sp)
    80000f84:	e022                	sd	s0,0(sp)
    80000f86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f88:	00000097          	auipc	ra,0x0
    80000f8c:	fc0080e7          	jalr	-64(ra) # 80000f48 <myproc>
    80000f90:	00005097          	auipc	ra,0x5
    80000f94:	4b0080e7          	jalr	1200(ra) # 80006440 <release>

  if (first) {
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	9287a783          	lw	a5,-1752(a5) # 800088c0 <first.1>
    80000fa0:	eb89                	bnez	a5,80000fb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fa2:	00001097          	auipc	ra,0x1
    80000fa6:	d36080e7          	jalr	-714(ra) # 80001cd8 <usertrapret>
}
    80000faa:	60a2                	ld	ra,8(sp)
    80000fac:	6402                	ld	s0,0(sp)
    80000fae:	0141                	addi	sp,sp,16
    80000fb0:	8082                	ret
    first = 0;
    80000fb2:	00008797          	auipc	a5,0x8
    80000fb6:	9007a723          	sw	zero,-1778(a5) # 800088c0 <first.1>
    fsinit(ROOTDEV);
    80000fba:	4505                	li	a0,1
    80000fbc:	00002097          	auipc	ra,0x2
    80000fc0:	b56080e7          	jalr	-1194(ra) # 80002b12 <fsinit>
    80000fc4:	bff9                	j	80000fa2 <forkret+0x22>

0000000080000fc6 <allocpid>:
{
    80000fc6:	1101                	addi	sp,sp,-32
    80000fc8:	ec06                	sd	ra,24(sp)
    80000fca:	e822                	sd	s0,16(sp)
    80000fcc:	e426                	sd	s1,8(sp)
    80000fce:	e04a                	sd	s2,0(sp)
    80000fd0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fd2:	00008917          	auipc	s2,0x8
    80000fd6:	9ae90913          	addi	s2,s2,-1618 # 80008980 <pid_lock>
    80000fda:	854a                	mv	a0,s2
    80000fdc:	00005097          	auipc	ra,0x5
    80000fe0:	3b0080e7          	jalr	944(ra) # 8000638c <acquire>
  pid = nextpid;
    80000fe4:	00008797          	auipc	a5,0x8
    80000fe8:	8e078793          	addi	a5,a5,-1824 # 800088c4 <nextpid>
    80000fec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fee:	0014871b          	addiw	a4,s1,1
    80000ff2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ff4:	854a                	mv	a0,s2
    80000ff6:	00005097          	auipc	ra,0x5
    80000ffa:	44a080e7          	jalr	1098(ra) # 80006440 <release>
}
    80000ffe:	8526                	mv	a0,s1
    80001000:	60e2                	ld	ra,24(sp)
    80001002:	6442                	ld	s0,16(sp)
    80001004:	64a2                	ld	s1,8(sp)
    80001006:	6902                	ld	s2,0(sp)
    80001008:	6105                	addi	sp,sp,32
    8000100a:	8082                	ret

000000008000100c <proc_pagetable>:
{
    8000100c:	1101                	addi	sp,sp,-32
    8000100e:	ec06                	sd	ra,24(sp)
    80001010:	e822                	sd	s0,16(sp)
    80001012:	e426                	sd	s1,8(sp)
    80001014:	e04a                	sd	s2,0(sp)
    80001016:	1000                	addi	s0,sp,32
    80001018:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	7b4080e7          	jalr	1972(ra) # 800007ce <uvmcreate>
    80001022:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001024:	cd39                	beqz	a0,80001082 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001026:	4729                	li	a4,10
    80001028:	00006697          	auipc	a3,0x6
    8000102c:	fd868693          	addi	a3,a3,-40 # 80007000 <_trampoline>
    80001030:	6605                	lui	a2,0x1
    80001032:	040005b7          	lui	a1,0x4000
    80001036:	15fd                	addi	a1,a1,-1
    80001038:	05b2                	slli	a1,a1,0xc
    8000103a:	fffff097          	auipc	ra,0xfffff
    8000103e:	50a080e7          	jalr	1290(ra) # 80000544 <mappages>
    80001042:	04054763          	bltz	a0,80001090 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001046:	4719                	li	a4,6
    80001048:	05893683          	ld	a3,88(s2)
    8000104c:	6605                	lui	a2,0x1
    8000104e:	020005b7          	lui	a1,0x2000
    80001052:	15fd                	addi	a1,a1,-1
    80001054:	05b6                	slli	a1,a1,0xd
    80001056:	8526                	mv	a0,s1
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	4ec080e7          	jalr	1260(ra) # 80000544 <mappages>
    80001060:	04054063          	bltz	a0,800010a0 <proc_pagetable+0x94>
  if (mappages(pagetable, USYSCALL, PGSIZE,
    80001064:	4749                	li	a4,18
    80001066:	16893683          	ld	a3,360(s2)
    8000106a:	6605                	lui	a2,0x1
    8000106c:	040005b7          	lui	a1,0x4000
    80001070:	15f5                	addi	a1,a1,-3
    80001072:	05b2                	slli	a1,a1,0xc
    80001074:	8526                	mv	a0,s1
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	4ce080e7          	jalr	1230(ra) # 80000544 <mappages>
    8000107e:	04054463          	bltz	a0,800010c6 <proc_pagetable+0xba>
}
    80001082:	8526                	mv	a0,s1
    80001084:	60e2                	ld	ra,24(sp)
    80001086:	6442                	ld	s0,16(sp)
    80001088:	64a2                	ld	s1,8(sp)
    8000108a:	6902                	ld	s2,0(sp)
    8000108c:	6105                	addi	sp,sp,32
    8000108e:	8082                	ret
    uvmfree(pagetable, 0);
    80001090:	4581                	li	a1,0
    80001092:	8526                	mv	a0,s1
    80001094:	00000097          	auipc	ra,0x0
    80001098:	93e080e7          	jalr	-1730(ra) # 800009d2 <uvmfree>
    return 0;
    8000109c:	4481                	li	s1,0
    8000109e:	b7d5                	j	80001082 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010a0:	4681                	li	a3,0
    800010a2:	4605                	li	a2,1
    800010a4:	040005b7          	lui	a1,0x4000
    800010a8:	15fd                	addi	a1,a1,-1
    800010aa:	05b2                	slli	a1,a1,0xc
    800010ac:	8526                	mv	a0,s1
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	65c080e7          	jalr	1628(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    800010b6:	4581                	li	a1,0
    800010b8:	8526                	mv	a0,s1
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	918080e7          	jalr	-1768(ra) # 800009d2 <uvmfree>
    return 0;
    800010c2:	4481                	li	s1,0
    800010c4:	bf7d                	j	80001082 <proc_pagetable+0x76>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    800010c6:	4681                	li	a3,0
    800010c8:	4605                	li	a2,1
    800010ca:	04000937          	lui	s2,0x4000
    800010ce:	ffd90593          	addi	a1,s2,-3 # 3fffffd <_entry-0x7c000003>
    800010d2:	05b2                	slli	a1,a1,0xc
    800010d4:	8526                	mv	a0,s1
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	634080e7          	jalr	1588(ra) # 8000070a <uvmunmap>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010de:	4681                	li	a3,0
    800010e0:	4605                	li	a2,1
    800010e2:	fff90593          	addi	a1,s2,-1
    800010e6:	05b2                	slli	a1,a1,0xc
    800010e8:	8526                	mv	a0,s1
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	620080e7          	jalr	1568(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    800010f2:	4581                	li	a1,0
    800010f4:	8526                	mv	a0,s1
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	8dc080e7          	jalr	-1828(ra) # 800009d2 <uvmfree>
    return 0;
    800010fe:	4481                	li	s1,0
    80001100:	b749                	j	80001082 <proc_pagetable+0x76>

0000000080001102 <proc_freepagetable>:
{
    80001102:	7179                	addi	sp,sp,-48
    80001104:	f406                	sd	ra,40(sp)
    80001106:	f022                	sd	s0,32(sp)
    80001108:	ec26                	sd	s1,24(sp)
    8000110a:	e84a                	sd	s2,16(sp)
    8000110c:	e44e                	sd	s3,8(sp)
    8000110e:	1800                	addi	s0,sp,48
    80001110:	84aa                	mv	s1,a0
    80001112:	89ae                	mv	s3,a1
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001114:	4681                	li	a3,0
    80001116:	4605                	li	a2,1
    80001118:	04000937          	lui	s2,0x4000
    8000111c:	ffd90593          	addi	a1,s2,-3 # 3fffffd <_entry-0x7c000003>
    80001120:	05b2                	slli	a1,a1,0xc
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	5e8080e7          	jalr	1512(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000112a:	4681                	li	a3,0
    8000112c:	4605                	li	a2,1
    8000112e:	197d                	addi	s2,s2,-1
    80001130:	00c91593          	slli	a1,s2,0xc
    80001134:	8526                	mv	a0,s1
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	5d4080e7          	jalr	1492(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000113e:	4681                	li	a3,0
    80001140:	4605                	li	a2,1
    80001142:	020005b7          	lui	a1,0x2000
    80001146:	15fd                	addi	a1,a1,-1
    80001148:	05b6                	slli	a1,a1,0xd
    8000114a:	8526                	mv	a0,s1
    8000114c:	fffff097          	auipc	ra,0xfffff
    80001150:	5be080e7          	jalr	1470(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80001154:	85ce                	mv	a1,s3
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	87a080e7          	jalr	-1926(ra) # 800009d2 <uvmfree>
}
    80001160:	70a2                	ld	ra,40(sp)
    80001162:	7402                	ld	s0,32(sp)
    80001164:	64e2                	ld	s1,24(sp)
    80001166:	6942                	ld	s2,16(sp)
    80001168:	69a2                	ld	s3,8(sp)
    8000116a:	6145                	addi	sp,sp,48
    8000116c:	8082                	ret

000000008000116e <freeproc>:
{
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	1000                	addi	s0,sp,32
    80001178:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000117a:	6d28                	ld	a0,88(a0)
    8000117c:	c509                	beqz	a0,80001186 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	e9e080e7          	jalr	-354(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001186:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000118a:	68a8                	ld	a0,80(s1)
    8000118c:	cd11                	beqz	a0,800011a8 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    8000118e:	64ac                	ld	a1,72(s1)
    80001190:	00000097          	auipc	ra,0x0
    80001194:	f72080e7          	jalr	-142(ra) # 80001102 <proc_freepagetable>
  if (p->trapframe)
    80001198:	6cbc                	ld	a5,88(s1)
    8000119a:	c799                	beqz	a5,800011a8 <freeproc+0x3a>
    kfree((void *)p->usyscall);
    8000119c:	1684b503          	ld	a0,360(s1)
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	e7c080e7          	jalr	-388(ra) # 8000001c <kfree>
  p->usyscall=0;
    800011a8:	1604b423          	sd	zero,360(s1)
  p->pagetable = 0;
    800011ac:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011b0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011b4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011b8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011bc:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011c0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011c4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011c8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011cc:	0004ac23          	sw	zero,24(s1)
}
    800011d0:	60e2                	ld	ra,24(sp)
    800011d2:	6442                	ld	s0,16(sp)
    800011d4:	64a2                	ld	s1,8(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret

00000000800011da <allocproc>:
{
    800011da:	1101                	addi	sp,sp,-32
    800011dc:	ec06                	sd	ra,24(sp)
    800011de:	e822                	sd	s0,16(sp)
    800011e0:	e426                	sd	s1,8(sp)
    800011e2:	e04a                	sd	s2,0(sp)
    800011e4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e6:	00008497          	auipc	s1,0x8
    800011ea:	bca48493          	addi	s1,s1,-1078 # 80008db0 <proc>
    800011ee:	0000d917          	auipc	s2,0xd
    800011f2:	7c290913          	addi	s2,s2,1986 # 8000e9b0 <tickslock>
    acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	00005097          	auipc	ra,0x5
    800011fc:	194080e7          	jalr	404(ra) # 8000638c <acquire>
    if(p->state == UNUSED) {
    80001200:	4c9c                	lw	a5,24(s1)
    80001202:	cf81                	beqz	a5,8000121a <allocproc+0x40>
      release(&p->lock);
    80001204:	8526                	mv	a0,s1
    80001206:	00005097          	auipc	ra,0x5
    8000120a:	23a080e7          	jalr	570(ra) # 80006440 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000120e:	17048493          	addi	s1,s1,368
    80001212:	ff2492e3          	bne	s1,s2,800011f6 <allocproc+0x1c>
  return 0;
    80001216:	4481                	li	s1,0
    80001218:	a89d                	j	8000128e <allocproc+0xb4>
  p->pid = allocpid();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	dac080e7          	jalr	-596(ra) # 80000fc6 <allocpid>
    80001222:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001224:	4785                	li	a5,1
    80001226:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	ef0080e7          	jalr	-272(ra) # 80000118 <kalloc>
    80001230:	892a                	mv	s2,a0
    80001232:	eca8                	sd	a0,88(s1)
    80001234:	c525                	beqz	a0,8000129c <allocproc+0xc2>
  p->pagetable = proc_pagetable(p);
    80001236:	8526                	mv	a0,s1
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	dd4080e7          	jalr	-556(ra) # 8000100c <proc_pagetable>
    80001240:	892a                	mv	s2,a0
    80001242:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001244:	c925                	beqz	a0,800012b4 <allocproc+0xda>
  memset(&p->context, 0, sizeof(p->context));
    80001246:	07000613          	li	a2,112
    8000124a:	4581                	li	a1,0
    8000124c:	06048513          	addi	a0,s1,96
    80001250:	fffff097          	auipc	ra,0xfffff
    80001254:	f28080e7          	jalr	-216(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001258:	00000797          	auipc	a5,0x0
    8000125c:	d2878793          	addi	a5,a5,-728 # 80000f80 <forkret>
    80001260:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001262:	60bc                	ld	a5,64(s1)
    80001264:	6705                	lui	a4,0x1
    80001266:	97ba                	add	a5,a5,a4
    80001268:	f4bc                	sd	a5,104(s1)
  if ((p->usyscall = (struct usyscall *)kalloc()) == 0)
    8000126a:	fffff097          	auipc	ra,0xfffff
    8000126e:	eae080e7          	jalr	-338(ra) # 80000118 <kalloc>
    80001272:	892a                	mv	s2,a0
    80001274:	16a4b423          	sd	a0,360(s1)
    80001278:	c931                	beqz	a0,800012cc <allocproc+0xf2>
  p->usyscall->pid=p->pid;
    8000127a:	589c                	lw	a5,48(s1)
    8000127c:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p); 
    8000127e:	8526                	mv	a0,s1
    80001280:	00000097          	auipc	ra,0x0
    80001284:	d8c080e7          	jalr	-628(ra) # 8000100c <proc_pagetable>
    80001288:	892a                	mv	s2,a0
    8000128a:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    8000128c:	cd21                	beqz	a0,800012e4 <allocproc+0x10a>
}
    8000128e:	8526                	mv	a0,s1
    80001290:	60e2                	ld	ra,24(sp)
    80001292:	6442                	ld	s0,16(sp)
    80001294:	64a2                	ld	s1,8(sp)
    80001296:	6902                	ld	s2,0(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret
    freeproc(p);
    8000129c:	8526                	mv	a0,s1
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	ed0080e7          	jalr	-304(ra) # 8000116e <freeproc>
    release(&p->lock);
    800012a6:	8526                	mv	a0,s1
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	198080e7          	jalr	408(ra) # 80006440 <release>
    return 0;
    800012b0:	84ca                	mv	s1,s2
    800012b2:	bff1                	j	8000128e <allocproc+0xb4>
    freeproc(p);
    800012b4:	8526                	mv	a0,s1
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	eb8080e7          	jalr	-328(ra) # 8000116e <freeproc>
    release(&p->lock);
    800012be:	8526                	mv	a0,s1
    800012c0:	00005097          	auipc	ra,0x5
    800012c4:	180080e7          	jalr	384(ra) # 80006440 <release>
    return 0;
    800012c8:	84ca                	mv	s1,s2
    800012ca:	b7d1                	j	8000128e <allocproc+0xb4>
    freeproc(p);
    800012cc:	8526                	mv	a0,s1
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	ea0080e7          	jalr	-352(ra) # 8000116e <freeproc>
    release(&p->lock);
    800012d6:	8526                	mv	a0,s1
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	168080e7          	jalr	360(ra) # 80006440 <release>
    return 0;
    800012e0:	84ca                	mv	s1,s2
    800012e2:	b775                	j	8000128e <allocproc+0xb4>
    freeproc(p);
    800012e4:	8526                	mv	a0,s1
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	e88080e7          	jalr	-376(ra) # 8000116e <freeproc>
    release(&p->lock);
    800012ee:	8526                	mv	a0,s1
    800012f0:	00005097          	auipc	ra,0x5
    800012f4:	150080e7          	jalr	336(ra) # 80006440 <release>
    return 0;
    800012f8:	84ca                	mv	s1,s2
    800012fa:	bf51                	j	8000128e <allocproc+0xb4>

00000000800012fc <userinit>:
{
    800012fc:	1101                	addi	sp,sp,-32
    800012fe:	ec06                	sd	ra,24(sp)
    80001300:	e822                	sd	s0,16(sp)
    80001302:	e426                	sd	s1,8(sp)
    80001304:	1000                	addi	s0,sp,32
  p = allocproc();
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	ed4080e7          	jalr	-300(ra) # 800011da <allocproc>
    8000130e:	84aa                	mv	s1,a0
  initproc = p;
    80001310:	00007797          	auipc	a5,0x7
    80001314:	62a7b823          	sd	a0,1584(a5) # 80008940 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001318:	03400613          	li	a2,52
    8000131c:	00007597          	auipc	a1,0x7
    80001320:	5b458593          	addi	a1,a1,1460 # 800088d0 <initcode>
    80001324:	6928                	ld	a0,80(a0)
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	4d6080e7          	jalr	1238(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000132e:	6785                	lui	a5,0x1
    80001330:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001332:	6cb8                	ld	a4,88(s1)
    80001334:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001338:	6cb8                	ld	a4,88(s1)
    8000133a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000133c:	4641                	li	a2,16
    8000133e:	00007597          	auipc	a1,0x7
    80001342:	e7a58593          	addi	a1,a1,-390 # 800081b8 <etext+0x1b8>
    80001346:	15848513          	addi	a0,s1,344
    8000134a:	fffff097          	auipc	ra,0xfffff
    8000134e:	f78080e7          	jalr	-136(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001352:	00007517          	auipc	a0,0x7
    80001356:	e7650513          	addi	a0,a0,-394 # 800081c8 <etext+0x1c8>
    8000135a:	00002097          	auipc	ra,0x2
    8000135e:	1da080e7          	jalr	474(ra) # 80003534 <namei>
    80001362:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	0d4080e7          	jalr	212(ra) # 80006440 <release>
}
    80001374:	60e2                	ld	ra,24(sp)
    80001376:	6442                	ld	s0,16(sp)
    80001378:	64a2                	ld	s1,8(sp)
    8000137a:	6105                	addi	sp,sp,32
    8000137c:	8082                	ret

000000008000137e <growproc>:
{
    8000137e:	1101                	addi	sp,sp,-32
    80001380:	ec06                	sd	ra,24(sp)
    80001382:	e822                	sd	s0,16(sp)
    80001384:	e426                	sd	s1,8(sp)
    80001386:	e04a                	sd	s2,0(sp)
    80001388:	1000                	addi	s0,sp,32
    8000138a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	bbc080e7          	jalr	-1092(ra) # 80000f48 <myproc>
    80001394:	84aa                	mv	s1,a0
  sz = p->sz;
    80001396:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001398:	01204c63          	bgtz	s2,800013b0 <growproc+0x32>
  } else if(n < 0){
    8000139c:	02094663          	bltz	s2,800013c8 <growproc+0x4a>
  p->sz = sz;
    800013a0:	e4ac                	sd	a1,72(s1)
  return 0;
    800013a2:	4501                	li	a0,0
}
    800013a4:	60e2                	ld	ra,24(sp)
    800013a6:	6442                	ld	s0,16(sp)
    800013a8:	64a2                	ld	s1,8(sp)
    800013aa:	6902                	ld	s2,0(sp)
    800013ac:	6105                	addi	sp,sp,32
    800013ae:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800013b0:	4691                	li	a3,4
    800013b2:	00b90633          	add	a2,s2,a1
    800013b6:	6928                	ld	a0,80(a0)
    800013b8:	fffff097          	auipc	ra,0xfffff
    800013bc:	4fe080e7          	jalr	1278(ra) # 800008b6 <uvmalloc>
    800013c0:	85aa                	mv	a1,a0
    800013c2:	fd79                	bnez	a0,800013a0 <growproc+0x22>
      return -1;
    800013c4:	557d                	li	a0,-1
    800013c6:	bff9                	j	800013a4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013c8:	00b90633          	add	a2,s2,a1
    800013cc:	6928                	ld	a0,80(a0)
    800013ce:	fffff097          	auipc	ra,0xfffff
    800013d2:	4a0080e7          	jalr	1184(ra) # 8000086e <uvmdealloc>
    800013d6:	85aa                	mv	a1,a0
    800013d8:	b7e1                	j	800013a0 <growproc+0x22>

00000000800013da <fork>:
{
    800013da:	7139                	addi	sp,sp,-64
    800013dc:	fc06                	sd	ra,56(sp)
    800013de:	f822                	sd	s0,48(sp)
    800013e0:	f426                	sd	s1,40(sp)
    800013e2:	f04a                	sd	s2,32(sp)
    800013e4:	ec4e                	sd	s3,24(sp)
    800013e6:	e852                	sd	s4,16(sp)
    800013e8:	e456                	sd	s5,8(sp)
    800013ea:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013ec:	00000097          	auipc	ra,0x0
    800013f0:	b5c080e7          	jalr	-1188(ra) # 80000f48 <myproc>
    800013f4:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	de4080e7          	jalr	-540(ra) # 800011da <allocproc>
    800013fe:	10050c63          	beqz	a0,80001516 <fork+0x13c>
    80001402:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001404:	048ab603          	ld	a2,72(s5)
    80001408:	692c                	ld	a1,80(a0)
    8000140a:	050ab503          	ld	a0,80(s5)
    8000140e:	fffff097          	auipc	ra,0xfffff
    80001412:	5fc080e7          	jalr	1532(ra) # 80000a0a <uvmcopy>
    80001416:	04054863          	bltz	a0,80001466 <fork+0x8c>
  np->sz = p->sz;
    8000141a:	048ab783          	ld	a5,72(s5)
    8000141e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001422:	058ab683          	ld	a3,88(s5)
    80001426:	87b6                	mv	a5,a3
    80001428:	058a3703          	ld	a4,88(s4)
    8000142c:	12068693          	addi	a3,a3,288
    80001430:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001434:	6788                	ld	a0,8(a5)
    80001436:	6b8c                	ld	a1,16(a5)
    80001438:	6f90                	ld	a2,24(a5)
    8000143a:	01073023          	sd	a6,0(a4)
    8000143e:	e708                	sd	a0,8(a4)
    80001440:	eb0c                	sd	a1,16(a4)
    80001442:	ef10                	sd	a2,24(a4)
    80001444:	02078793          	addi	a5,a5,32
    80001448:	02070713          	addi	a4,a4,32
    8000144c:	fed792e3          	bne	a5,a3,80001430 <fork+0x56>
  np->trapframe->a0 = 0;
    80001450:	058a3783          	ld	a5,88(s4)
    80001454:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001458:	0d0a8493          	addi	s1,s5,208
    8000145c:	0d0a0913          	addi	s2,s4,208
    80001460:	150a8993          	addi	s3,s5,336
    80001464:	a00d                	j	80001486 <fork+0xac>
    freeproc(np);
    80001466:	8552                	mv	a0,s4
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	d06080e7          	jalr	-762(ra) # 8000116e <freeproc>
    release(&np->lock);
    80001470:	8552                	mv	a0,s4
    80001472:	00005097          	auipc	ra,0x5
    80001476:	fce080e7          	jalr	-50(ra) # 80006440 <release>
    return -1;
    8000147a:	597d                	li	s2,-1
    8000147c:	a059                	j	80001502 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000147e:	04a1                	addi	s1,s1,8
    80001480:	0921                	addi	s2,s2,8
    80001482:	01348b63          	beq	s1,s3,80001498 <fork+0xbe>
    if(p->ofile[i])
    80001486:	6088                	ld	a0,0(s1)
    80001488:	d97d                	beqz	a0,8000147e <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000148a:	00002097          	auipc	ra,0x2
    8000148e:	740080e7          	jalr	1856(ra) # 80003bca <filedup>
    80001492:	00a93023          	sd	a0,0(s2)
    80001496:	b7e5                	j	8000147e <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001498:	150ab503          	ld	a0,336(s5)
    8000149c:	00002097          	auipc	ra,0x2
    800014a0:	8b4080e7          	jalr	-1868(ra) # 80002d50 <idup>
    800014a4:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014a8:	4641                	li	a2,16
    800014aa:	158a8593          	addi	a1,s5,344
    800014ae:	158a0513          	addi	a0,s4,344
    800014b2:	fffff097          	auipc	ra,0xfffff
    800014b6:	e10080e7          	jalr	-496(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800014ba:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800014be:	8552                	mv	a0,s4
    800014c0:	00005097          	auipc	ra,0x5
    800014c4:	f80080e7          	jalr	-128(ra) # 80006440 <release>
  acquire(&wait_lock);
    800014c8:	00007497          	auipc	s1,0x7
    800014cc:	4d048493          	addi	s1,s1,1232 # 80008998 <wait_lock>
    800014d0:	8526                	mv	a0,s1
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	eba080e7          	jalr	-326(ra) # 8000638c <acquire>
  np->parent = p;
    800014da:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014de:	8526                	mv	a0,s1
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	f60080e7          	jalr	-160(ra) # 80006440 <release>
  acquire(&np->lock);
    800014e8:	8552                	mv	a0,s4
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	ea2080e7          	jalr	-350(ra) # 8000638c <acquire>
  np->state = RUNNABLE;
    800014f2:	478d                	li	a5,3
    800014f4:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014f8:	8552                	mv	a0,s4
    800014fa:	00005097          	auipc	ra,0x5
    800014fe:	f46080e7          	jalr	-186(ra) # 80006440 <release>
}
    80001502:	854a                	mv	a0,s2
    80001504:	70e2                	ld	ra,56(sp)
    80001506:	7442                	ld	s0,48(sp)
    80001508:	74a2                	ld	s1,40(sp)
    8000150a:	7902                	ld	s2,32(sp)
    8000150c:	69e2                	ld	s3,24(sp)
    8000150e:	6a42                	ld	s4,16(sp)
    80001510:	6aa2                	ld	s5,8(sp)
    80001512:	6121                	addi	sp,sp,64
    80001514:	8082                	ret
    return -1;
    80001516:	597d                	li	s2,-1
    80001518:	b7ed                	j	80001502 <fork+0x128>

000000008000151a <scheduler>:
{
    8000151a:	7139                	addi	sp,sp,-64
    8000151c:	fc06                	sd	ra,56(sp)
    8000151e:	f822                	sd	s0,48(sp)
    80001520:	f426                	sd	s1,40(sp)
    80001522:	f04a                	sd	s2,32(sp)
    80001524:	ec4e                	sd	s3,24(sp)
    80001526:	e852                	sd	s4,16(sp)
    80001528:	e456                	sd	s5,8(sp)
    8000152a:	e05a                	sd	s6,0(sp)
    8000152c:	0080                	addi	s0,sp,64
    8000152e:	8792                	mv	a5,tp
  int id = r_tp();
    80001530:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001532:	00779a93          	slli	s5,a5,0x7
    80001536:	00007717          	auipc	a4,0x7
    8000153a:	44a70713          	addi	a4,a4,1098 # 80008980 <pid_lock>
    8000153e:	9756                	add	a4,a4,s5
    80001540:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001544:	00007717          	auipc	a4,0x7
    80001548:	47470713          	addi	a4,a4,1140 # 800089b8 <cpus+0x8>
    8000154c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000154e:	498d                	li	s3,3
        p->state = RUNNING;
    80001550:	4b11                	li	s6,4
        c->proc = p;
    80001552:	079e                	slli	a5,a5,0x7
    80001554:	00007a17          	auipc	s4,0x7
    80001558:	42ca0a13          	addi	s4,s4,1068 # 80008980 <pid_lock>
    8000155c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000155e:	0000d917          	auipc	s2,0xd
    80001562:	45290913          	addi	s2,s2,1106 # 8000e9b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001566:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000156a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000156e:	10079073          	csrw	sstatus,a5
    80001572:	00008497          	auipc	s1,0x8
    80001576:	83e48493          	addi	s1,s1,-1986 # 80008db0 <proc>
    8000157a:	a811                	j	8000158e <scheduler+0x74>
      release(&p->lock);
    8000157c:	8526                	mv	a0,s1
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	ec2080e7          	jalr	-318(ra) # 80006440 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001586:	17048493          	addi	s1,s1,368
    8000158a:	fd248ee3          	beq	s1,s2,80001566 <scheduler+0x4c>
      acquire(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	00005097          	auipc	ra,0x5
    80001594:	dfc080e7          	jalr	-516(ra) # 8000638c <acquire>
      if(p->state == RUNNABLE) {
    80001598:	4c9c                	lw	a5,24(s1)
    8000159a:	ff3791e3          	bne	a5,s3,8000157c <scheduler+0x62>
        p->state = RUNNING;
    8000159e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015a2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015a6:	06048593          	addi	a1,s1,96
    800015aa:	8556                	mv	a0,s5
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	682080e7          	jalr	1666(ra) # 80001c2e <swtch>
        c->proc = 0;
    800015b4:	020a3823          	sd	zero,48(s4)
    800015b8:	b7d1                	j	8000157c <scheduler+0x62>

00000000800015ba <sched>:
{
    800015ba:	7179                	addi	sp,sp,-48
    800015bc:	f406                	sd	ra,40(sp)
    800015be:	f022                	sd	s0,32(sp)
    800015c0:	ec26                	sd	s1,24(sp)
    800015c2:	e84a                	sd	s2,16(sp)
    800015c4:	e44e                	sd	s3,8(sp)
    800015c6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015c8:	00000097          	auipc	ra,0x0
    800015cc:	980080e7          	jalr	-1664(ra) # 80000f48 <myproc>
    800015d0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	d40080e7          	jalr	-704(ra) # 80006312 <holding>
    800015da:	c93d                	beqz	a0,80001650 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015dc:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015de:	2781                	sext.w	a5,a5
    800015e0:	079e                	slli	a5,a5,0x7
    800015e2:	00007717          	auipc	a4,0x7
    800015e6:	39e70713          	addi	a4,a4,926 # 80008980 <pid_lock>
    800015ea:	97ba                	add	a5,a5,a4
    800015ec:	0a87a703          	lw	a4,168(a5)
    800015f0:	4785                	li	a5,1
    800015f2:	06f71763          	bne	a4,a5,80001660 <sched+0xa6>
  if(p->state == RUNNING)
    800015f6:	4c98                	lw	a4,24(s1)
    800015f8:	4791                	li	a5,4
    800015fa:	06f70b63          	beq	a4,a5,80001670 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015fe:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001602:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001604:	efb5                	bnez	a5,80001680 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001606:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001608:	00007917          	auipc	s2,0x7
    8000160c:	37890913          	addi	s2,s2,888 # 80008980 <pid_lock>
    80001610:	2781                	sext.w	a5,a5
    80001612:	079e                	slli	a5,a5,0x7
    80001614:	97ca                	add	a5,a5,s2
    80001616:	0ac7a983          	lw	s3,172(a5)
    8000161a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000161c:	2781                	sext.w	a5,a5
    8000161e:	079e                	slli	a5,a5,0x7
    80001620:	00007597          	auipc	a1,0x7
    80001624:	39858593          	addi	a1,a1,920 # 800089b8 <cpus+0x8>
    80001628:	95be                	add	a1,a1,a5
    8000162a:	06048513          	addi	a0,s1,96
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	600080e7          	jalr	1536(ra) # 80001c2e <swtch>
    80001636:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001638:	2781                	sext.w	a5,a5
    8000163a:	079e                	slli	a5,a5,0x7
    8000163c:	97ca                	add	a5,a5,s2
    8000163e:	0b37a623          	sw	s3,172(a5)
}
    80001642:	70a2                	ld	ra,40(sp)
    80001644:	7402                	ld	s0,32(sp)
    80001646:	64e2                	ld	s1,24(sp)
    80001648:	6942                	ld	s2,16(sp)
    8000164a:	69a2                	ld	s3,8(sp)
    8000164c:	6145                	addi	sp,sp,48
    8000164e:	8082                	ret
    panic("sched p->lock");
    80001650:	00007517          	auipc	a0,0x7
    80001654:	b8050513          	addi	a0,a0,-1152 # 800081d0 <etext+0x1d0>
    80001658:	00004097          	auipc	ra,0x4
    8000165c:	7f8080e7          	jalr	2040(ra) # 80005e50 <panic>
    panic("sched locks");
    80001660:	00007517          	auipc	a0,0x7
    80001664:	b8050513          	addi	a0,a0,-1152 # 800081e0 <etext+0x1e0>
    80001668:	00004097          	auipc	ra,0x4
    8000166c:	7e8080e7          	jalr	2024(ra) # 80005e50 <panic>
    panic("sched running");
    80001670:	00007517          	auipc	a0,0x7
    80001674:	b8050513          	addi	a0,a0,-1152 # 800081f0 <etext+0x1f0>
    80001678:	00004097          	auipc	ra,0x4
    8000167c:	7d8080e7          	jalr	2008(ra) # 80005e50 <panic>
    panic("sched interruptible");
    80001680:	00007517          	auipc	a0,0x7
    80001684:	b8050513          	addi	a0,a0,-1152 # 80008200 <etext+0x200>
    80001688:	00004097          	auipc	ra,0x4
    8000168c:	7c8080e7          	jalr	1992(ra) # 80005e50 <panic>

0000000080001690 <yield>:
{
    80001690:	1101                	addi	sp,sp,-32
    80001692:	ec06                	sd	ra,24(sp)
    80001694:	e822                	sd	s0,16(sp)
    80001696:	e426                	sd	s1,8(sp)
    80001698:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	8ae080e7          	jalr	-1874(ra) # 80000f48 <myproc>
    800016a2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	ce8080e7          	jalr	-792(ra) # 8000638c <acquire>
  p->state = RUNNABLE;
    800016ac:	478d                	li	a5,3
    800016ae:	cc9c                	sw	a5,24(s1)
  sched();
    800016b0:	00000097          	auipc	ra,0x0
    800016b4:	f0a080e7          	jalr	-246(ra) # 800015ba <sched>
  release(&p->lock);
    800016b8:	8526                	mv	a0,s1
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	d86080e7          	jalr	-634(ra) # 80006440 <release>
}
    800016c2:	60e2                	ld	ra,24(sp)
    800016c4:	6442                	ld	s0,16(sp)
    800016c6:	64a2                	ld	s1,8(sp)
    800016c8:	6105                	addi	sp,sp,32
    800016ca:	8082                	ret

00000000800016cc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016cc:	7179                	addi	sp,sp,-48
    800016ce:	f406                	sd	ra,40(sp)
    800016d0:	f022                	sd	s0,32(sp)
    800016d2:	ec26                	sd	s1,24(sp)
    800016d4:	e84a                	sd	s2,16(sp)
    800016d6:	e44e                	sd	s3,8(sp)
    800016d8:	1800                	addi	s0,sp,48
    800016da:	89aa                	mv	s3,a0
    800016dc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	86a080e7          	jalr	-1942(ra) # 80000f48 <myproc>
    800016e6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016e8:	00005097          	auipc	ra,0x5
    800016ec:	ca4080e7          	jalr	-860(ra) # 8000638c <acquire>
  release(lk);
    800016f0:	854a                	mv	a0,s2
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	d4e080e7          	jalr	-690(ra) # 80006440 <release>

  // Go to sleep.
  p->chan = chan;
    800016fa:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016fe:	4789                	li	a5,2
    80001700:	cc9c                	sw	a5,24(s1)

  sched();
    80001702:	00000097          	auipc	ra,0x0
    80001706:	eb8080e7          	jalr	-328(ra) # 800015ba <sched>

  // Tidy up.
  p->chan = 0;
    8000170a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000170e:	8526                	mv	a0,s1
    80001710:	00005097          	auipc	ra,0x5
    80001714:	d30080e7          	jalr	-720(ra) # 80006440 <release>
  acquire(lk);
    80001718:	854a                	mv	a0,s2
    8000171a:	00005097          	auipc	ra,0x5
    8000171e:	c72080e7          	jalr	-910(ra) # 8000638c <acquire>
}
    80001722:	70a2                	ld	ra,40(sp)
    80001724:	7402                	ld	s0,32(sp)
    80001726:	64e2                	ld	s1,24(sp)
    80001728:	6942                	ld	s2,16(sp)
    8000172a:	69a2                	ld	s3,8(sp)
    8000172c:	6145                	addi	sp,sp,48
    8000172e:	8082                	ret

0000000080001730 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001730:	7139                	addi	sp,sp,-64
    80001732:	fc06                	sd	ra,56(sp)
    80001734:	f822                	sd	s0,48(sp)
    80001736:	f426                	sd	s1,40(sp)
    80001738:	f04a                	sd	s2,32(sp)
    8000173a:	ec4e                	sd	s3,24(sp)
    8000173c:	e852                	sd	s4,16(sp)
    8000173e:	e456                	sd	s5,8(sp)
    80001740:	0080                	addi	s0,sp,64
    80001742:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001744:	00007497          	auipc	s1,0x7
    80001748:	66c48493          	addi	s1,s1,1644 # 80008db0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000174c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000174e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001750:	0000d917          	auipc	s2,0xd
    80001754:	26090913          	addi	s2,s2,608 # 8000e9b0 <tickslock>
    80001758:	a811                	j	8000176c <wakeup+0x3c>
      }
      release(&p->lock);
    8000175a:	8526                	mv	a0,s1
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	ce4080e7          	jalr	-796(ra) # 80006440 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001764:	17048493          	addi	s1,s1,368
    80001768:	03248663          	beq	s1,s2,80001794 <wakeup+0x64>
    if(p != myproc()){
    8000176c:	fffff097          	auipc	ra,0xfffff
    80001770:	7dc080e7          	jalr	2012(ra) # 80000f48 <myproc>
    80001774:	fea488e3          	beq	s1,a0,80001764 <wakeup+0x34>
      acquire(&p->lock);
    80001778:	8526                	mv	a0,s1
    8000177a:	00005097          	auipc	ra,0x5
    8000177e:	c12080e7          	jalr	-1006(ra) # 8000638c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001782:	4c9c                	lw	a5,24(s1)
    80001784:	fd379be3          	bne	a5,s3,8000175a <wakeup+0x2a>
    80001788:	709c                	ld	a5,32(s1)
    8000178a:	fd4798e3          	bne	a5,s4,8000175a <wakeup+0x2a>
        p->state = RUNNABLE;
    8000178e:	0154ac23          	sw	s5,24(s1)
    80001792:	b7e1                	j	8000175a <wakeup+0x2a>
    }
  }
}
    80001794:	70e2                	ld	ra,56(sp)
    80001796:	7442                	ld	s0,48(sp)
    80001798:	74a2                	ld	s1,40(sp)
    8000179a:	7902                	ld	s2,32(sp)
    8000179c:	69e2                	ld	s3,24(sp)
    8000179e:	6a42                	ld	s4,16(sp)
    800017a0:	6aa2                	ld	s5,8(sp)
    800017a2:	6121                	addi	sp,sp,64
    800017a4:	8082                	ret

00000000800017a6 <reparent>:
{
    800017a6:	7179                	addi	sp,sp,-48
    800017a8:	f406                	sd	ra,40(sp)
    800017aa:	f022                	sd	s0,32(sp)
    800017ac:	ec26                	sd	s1,24(sp)
    800017ae:	e84a                	sd	s2,16(sp)
    800017b0:	e44e                	sd	s3,8(sp)
    800017b2:	e052                	sd	s4,0(sp)
    800017b4:	1800                	addi	s0,sp,48
    800017b6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017b8:	00007497          	auipc	s1,0x7
    800017bc:	5f848493          	addi	s1,s1,1528 # 80008db0 <proc>
      pp->parent = initproc;
    800017c0:	00007a17          	auipc	s4,0x7
    800017c4:	180a0a13          	addi	s4,s4,384 # 80008940 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017c8:	0000d997          	auipc	s3,0xd
    800017cc:	1e898993          	addi	s3,s3,488 # 8000e9b0 <tickslock>
    800017d0:	a029                	j	800017da <reparent+0x34>
    800017d2:	17048493          	addi	s1,s1,368
    800017d6:	01348d63          	beq	s1,s3,800017f0 <reparent+0x4a>
    if(pp->parent == p){
    800017da:	7c9c                	ld	a5,56(s1)
    800017dc:	ff279be3          	bne	a5,s2,800017d2 <reparent+0x2c>
      pp->parent = initproc;
    800017e0:	000a3503          	ld	a0,0(s4)
    800017e4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017e6:	00000097          	auipc	ra,0x0
    800017ea:	f4a080e7          	jalr	-182(ra) # 80001730 <wakeup>
    800017ee:	b7d5                	j	800017d2 <reparent+0x2c>
}
    800017f0:	70a2                	ld	ra,40(sp)
    800017f2:	7402                	ld	s0,32(sp)
    800017f4:	64e2                	ld	s1,24(sp)
    800017f6:	6942                	ld	s2,16(sp)
    800017f8:	69a2                	ld	s3,8(sp)
    800017fa:	6a02                	ld	s4,0(sp)
    800017fc:	6145                	addi	sp,sp,48
    800017fe:	8082                	ret

0000000080001800 <exit>:
{
    80001800:	7179                	addi	sp,sp,-48
    80001802:	f406                	sd	ra,40(sp)
    80001804:	f022                	sd	s0,32(sp)
    80001806:	ec26                	sd	s1,24(sp)
    80001808:	e84a                	sd	s2,16(sp)
    8000180a:	e44e                	sd	s3,8(sp)
    8000180c:	e052                	sd	s4,0(sp)
    8000180e:	1800                	addi	s0,sp,48
    80001810:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001812:	fffff097          	auipc	ra,0xfffff
    80001816:	736080e7          	jalr	1846(ra) # 80000f48 <myproc>
    8000181a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000181c:	00007797          	auipc	a5,0x7
    80001820:	1247b783          	ld	a5,292(a5) # 80008940 <initproc>
    80001824:	0d050493          	addi	s1,a0,208
    80001828:	15050913          	addi	s2,a0,336
    8000182c:	02a79363          	bne	a5,a0,80001852 <exit+0x52>
    panic("init exiting");
    80001830:	00007517          	auipc	a0,0x7
    80001834:	9e850513          	addi	a0,a0,-1560 # 80008218 <etext+0x218>
    80001838:	00004097          	auipc	ra,0x4
    8000183c:	618080e7          	jalr	1560(ra) # 80005e50 <panic>
      fileclose(f);
    80001840:	00002097          	auipc	ra,0x2
    80001844:	3dc080e7          	jalr	988(ra) # 80003c1c <fileclose>
      p->ofile[fd] = 0;
    80001848:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000184c:	04a1                	addi	s1,s1,8
    8000184e:	01248563          	beq	s1,s2,80001858 <exit+0x58>
    if(p->ofile[fd]){
    80001852:	6088                	ld	a0,0(s1)
    80001854:	f575                	bnez	a0,80001840 <exit+0x40>
    80001856:	bfdd                	j	8000184c <exit+0x4c>
  begin_op();
    80001858:	00002097          	auipc	ra,0x2
    8000185c:	ef8080e7          	jalr	-264(ra) # 80003750 <begin_op>
  iput(p->cwd);
    80001860:	1509b503          	ld	a0,336(s3)
    80001864:	00001097          	auipc	ra,0x1
    80001868:	6e4080e7          	jalr	1764(ra) # 80002f48 <iput>
  end_op();
    8000186c:	00002097          	auipc	ra,0x2
    80001870:	f64080e7          	jalr	-156(ra) # 800037d0 <end_op>
  p->cwd = 0;
    80001874:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001878:	00007497          	auipc	s1,0x7
    8000187c:	12048493          	addi	s1,s1,288 # 80008998 <wait_lock>
    80001880:	8526                	mv	a0,s1
    80001882:	00005097          	auipc	ra,0x5
    80001886:	b0a080e7          	jalr	-1270(ra) # 8000638c <acquire>
  reparent(p);
    8000188a:	854e                	mv	a0,s3
    8000188c:	00000097          	auipc	ra,0x0
    80001890:	f1a080e7          	jalr	-230(ra) # 800017a6 <reparent>
  wakeup(p->parent);
    80001894:	0389b503          	ld	a0,56(s3)
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	e98080e7          	jalr	-360(ra) # 80001730 <wakeup>
  acquire(&p->lock);
    800018a0:	854e                	mv	a0,s3
    800018a2:	00005097          	auipc	ra,0x5
    800018a6:	aea080e7          	jalr	-1302(ra) # 8000638c <acquire>
  p->xstate = status;
    800018aa:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018ae:	4795                	li	a5,5
    800018b0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018b4:	8526                	mv	a0,s1
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	b8a080e7          	jalr	-1142(ra) # 80006440 <release>
  sched();
    800018be:	00000097          	auipc	ra,0x0
    800018c2:	cfc080e7          	jalr	-772(ra) # 800015ba <sched>
  panic("zombie exit");
    800018c6:	00007517          	auipc	a0,0x7
    800018ca:	96250513          	addi	a0,a0,-1694 # 80008228 <etext+0x228>
    800018ce:	00004097          	auipc	ra,0x4
    800018d2:	582080e7          	jalr	1410(ra) # 80005e50 <panic>

00000000800018d6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018d6:	7179                	addi	sp,sp,-48
    800018d8:	f406                	sd	ra,40(sp)
    800018da:	f022                	sd	s0,32(sp)
    800018dc:	ec26                	sd	s1,24(sp)
    800018de:	e84a                	sd	s2,16(sp)
    800018e0:	e44e                	sd	s3,8(sp)
    800018e2:	1800                	addi	s0,sp,48
    800018e4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018e6:	00007497          	auipc	s1,0x7
    800018ea:	4ca48493          	addi	s1,s1,1226 # 80008db0 <proc>
    800018ee:	0000d997          	auipc	s3,0xd
    800018f2:	0c298993          	addi	s3,s3,194 # 8000e9b0 <tickslock>
    acquire(&p->lock);
    800018f6:	8526                	mv	a0,s1
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	a94080e7          	jalr	-1388(ra) # 8000638c <acquire>
    if(p->pid == pid){
    80001900:	589c                	lw	a5,48(s1)
    80001902:	01278d63          	beq	a5,s2,8000191c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001906:	8526                	mv	a0,s1
    80001908:	00005097          	auipc	ra,0x5
    8000190c:	b38080e7          	jalr	-1224(ra) # 80006440 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001910:	17048493          	addi	s1,s1,368
    80001914:	ff3491e3          	bne	s1,s3,800018f6 <kill+0x20>
  }
  return -1;
    80001918:	557d                	li	a0,-1
    8000191a:	a829                	j	80001934 <kill+0x5e>
      p->killed = 1;
    8000191c:	4785                	li	a5,1
    8000191e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001920:	4c98                	lw	a4,24(s1)
    80001922:	4789                	li	a5,2
    80001924:	00f70f63          	beq	a4,a5,80001942 <kill+0x6c>
      release(&p->lock);
    80001928:	8526                	mv	a0,s1
    8000192a:	00005097          	auipc	ra,0x5
    8000192e:	b16080e7          	jalr	-1258(ra) # 80006440 <release>
      return 0;
    80001932:	4501                	li	a0,0
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6145                	addi	sp,sp,48
    80001940:	8082                	ret
        p->state = RUNNABLE;
    80001942:	478d                	li	a5,3
    80001944:	cc9c                	sw	a5,24(s1)
    80001946:	b7cd                	j	80001928 <kill+0x52>

0000000080001948 <setkilled>:

void
setkilled(struct proc *p)
{
    80001948:	1101                	addi	sp,sp,-32
    8000194a:	ec06                	sd	ra,24(sp)
    8000194c:	e822                	sd	s0,16(sp)
    8000194e:	e426                	sd	s1,8(sp)
    80001950:	1000                	addi	s0,sp,32
    80001952:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001954:	00005097          	auipc	ra,0x5
    80001958:	a38080e7          	jalr	-1480(ra) # 8000638c <acquire>
  p->killed = 1;
    8000195c:	4785                	li	a5,1
    8000195e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001960:	8526                	mv	a0,s1
    80001962:	00005097          	auipc	ra,0x5
    80001966:	ade080e7          	jalr	-1314(ra) # 80006440 <release>
}
    8000196a:	60e2                	ld	ra,24(sp)
    8000196c:	6442                	ld	s0,16(sp)
    8000196e:	64a2                	ld	s1,8(sp)
    80001970:	6105                	addi	sp,sp,32
    80001972:	8082                	ret

0000000080001974 <killed>:

int
killed(struct proc *p)
{
    80001974:	1101                	addi	sp,sp,-32
    80001976:	ec06                	sd	ra,24(sp)
    80001978:	e822                	sd	s0,16(sp)
    8000197a:	e426                	sd	s1,8(sp)
    8000197c:	e04a                	sd	s2,0(sp)
    8000197e:	1000                	addi	s0,sp,32
    80001980:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001982:	00005097          	auipc	ra,0x5
    80001986:	a0a080e7          	jalr	-1526(ra) # 8000638c <acquire>
  k = p->killed;
    8000198a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000198e:	8526                	mv	a0,s1
    80001990:	00005097          	auipc	ra,0x5
    80001994:	ab0080e7          	jalr	-1360(ra) # 80006440 <release>
  return k;
}
    80001998:	854a                	mv	a0,s2
    8000199a:	60e2                	ld	ra,24(sp)
    8000199c:	6442                	ld	s0,16(sp)
    8000199e:	64a2                	ld	s1,8(sp)
    800019a0:	6902                	ld	s2,0(sp)
    800019a2:	6105                	addi	sp,sp,32
    800019a4:	8082                	ret

00000000800019a6 <wait>:
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
    800019ba:	e062                	sd	s8,0(sp)
    800019bc:	0880                	addi	s0,sp,80
    800019be:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	588080e7          	jalr	1416(ra) # 80000f48 <myproc>
    800019c8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800019ca:	00007517          	auipc	a0,0x7
    800019ce:	fce50513          	addi	a0,a0,-50 # 80008998 <wait_lock>
    800019d2:	00005097          	auipc	ra,0x5
    800019d6:	9ba080e7          	jalr	-1606(ra) # 8000638c <acquire>
    havekids = 0;
    800019da:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019dc:	4a15                	li	s4,5
        havekids = 1;
    800019de:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019e0:	0000d997          	auipc	s3,0xd
    800019e4:	fd098993          	addi	s3,s3,-48 # 8000e9b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019e8:	00007c17          	auipc	s8,0x7
    800019ec:	fb0c0c13          	addi	s8,s8,-80 # 80008998 <wait_lock>
    havekids = 0;
    800019f0:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019f2:	00007497          	auipc	s1,0x7
    800019f6:	3be48493          	addi	s1,s1,958 # 80008db0 <proc>
    800019fa:	a0bd                	j	80001a68 <wait+0xc2>
          pid = pp->pid;
    800019fc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a00:	000b0e63          	beqz	s6,80001a1c <wait+0x76>
    80001a04:	4691                	li	a3,4
    80001a06:	02c48613          	addi	a2,s1,44
    80001a0a:	85da                	mv	a1,s6
    80001a0c:	05093503          	ld	a0,80(s2)
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	0fe080e7          	jalr	254(ra) # 80000b0e <copyout>
    80001a18:	02054563          	bltz	a0,80001a42 <wait+0x9c>
          freeproc(pp);
    80001a1c:	8526                	mv	a0,s1
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	750080e7          	jalr	1872(ra) # 8000116e <freeproc>
          release(&pp->lock);
    80001a26:	8526                	mv	a0,s1
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	a18080e7          	jalr	-1512(ra) # 80006440 <release>
          release(&wait_lock);
    80001a30:	00007517          	auipc	a0,0x7
    80001a34:	f6850513          	addi	a0,a0,-152 # 80008998 <wait_lock>
    80001a38:	00005097          	auipc	ra,0x5
    80001a3c:	a08080e7          	jalr	-1528(ra) # 80006440 <release>
          return pid;
    80001a40:	a0b5                	j	80001aac <wait+0x106>
            release(&pp->lock);
    80001a42:	8526                	mv	a0,s1
    80001a44:	00005097          	auipc	ra,0x5
    80001a48:	9fc080e7          	jalr	-1540(ra) # 80006440 <release>
            release(&wait_lock);
    80001a4c:	00007517          	auipc	a0,0x7
    80001a50:	f4c50513          	addi	a0,a0,-180 # 80008998 <wait_lock>
    80001a54:	00005097          	auipc	ra,0x5
    80001a58:	9ec080e7          	jalr	-1556(ra) # 80006440 <release>
            return -1;
    80001a5c:	59fd                	li	s3,-1
    80001a5e:	a0b9                	j	80001aac <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a60:	17048493          	addi	s1,s1,368
    80001a64:	03348463          	beq	s1,s3,80001a8c <wait+0xe6>
      if(pp->parent == p){
    80001a68:	7c9c                	ld	a5,56(s1)
    80001a6a:	ff279be3          	bne	a5,s2,80001a60 <wait+0xba>
        acquire(&pp->lock);
    80001a6e:	8526                	mv	a0,s1
    80001a70:	00005097          	auipc	ra,0x5
    80001a74:	91c080e7          	jalr	-1764(ra) # 8000638c <acquire>
        if(pp->state == ZOMBIE){
    80001a78:	4c9c                	lw	a5,24(s1)
    80001a7a:	f94781e3          	beq	a5,s4,800019fc <wait+0x56>
        release(&pp->lock);
    80001a7e:	8526                	mv	a0,s1
    80001a80:	00005097          	auipc	ra,0x5
    80001a84:	9c0080e7          	jalr	-1600(ra) # 80006440 <release>
        havekids = 1;
    80001a88:	8756                	mv	a4,s5
    80001a8a:	bfd9                	j	80001a60 <wait+0xba>
    if(!havekids || killed(p)){
    80001a8c:	c719                	beqz	a4,80001a9a <wait+0xf4>
    80001a8e:	854a                	mv	a0,s2
    80001a90:	00000097          	auipc	ra,0x0
    80001a94:	ee4080e7          	jalr	-284(ra) # 80001974 <killed>
    80001a98:	c51d                	beqz	a0,80001ac6 <wait+0x120>
      release(&wait_lock);
    80001a9a:	00007517          	auipc	a0,0x7
    80001a9e:	efe50513          	addi	a0,a0,-258 # 80008998 <wait_lock>
    80001aa2:	00005097          	auipc	ra,0x5
    80001aa6:	99e080e7          	jalr	-1634(ra) # 80006440 <release>
      return -1;
    80001aaa:	59fd                	li	s3,-1
}
    80001aac:	854e                	mv	a0,s3
    80001aae:	60a6                	ld	ra,72(sp)
    80001ab0:	6406                	ld	s0,64(sp)
    80001ab2:	74e2                	ld	s1,56(sp)
    80001ab4:	7942                	ld	s2,48(sp)
    80001ab6:	79a2                	ld	s3,40(sp)
    80001ab8:	7a02                	ld	s4,32(sp)
    80001aba:	6ae2                	ld	s5,24(sp)
    80001abc:	6b42                	ld	s6,16(sp)
    80001abe:	6ba2                	ld	s7,8(sp)
    80001ac0:	6c02                	ld	s8,0(sp)
    80001ac2:	6161                	addi	sp,sp,80
    80001ac4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001ac6:	85e2                	mv	a1,s8
    80001ac8:	854a                	mv	a0,s2
    80001aca:	00000097          	auipc	ra,0x0
    80001ace:	c02080e7          	jalr	-1022(ra) # 800016cc <sleep>
    havekids = 0;
    80001ad2:	bf39                	j	800019f0 <wait+0x4a>

0000000080001ad4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ad4:	7179                	addi	sp,sp,-48
    80001ad6:	f406                	sd	ra,40(sp)
    80001ad8:	f022                	sd	s0,32(sp)
    80001ada:	ec26                	sd	s1,24(sp)
    80001adc:	e84a                	sd	s2,16(sp)
    80001ade:	e44e                	sd	s3,8(sp)
    80001ae0:	e052                	sd	s4,0(sp)
    80001ae2:	1800                	addi	s0,sp,48
    80001ae4:	84aa                	mv	s1,a0
    80001ae6:	892e                	mv	s2,a1
    80001ae8:	89b2                	mv	s3,a2
    80001aea:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aec:	fffff097          	auipc	ra,0xfffff
    80001af0:	45c080e7          	jalr	1116(ra) # 80000f48 <myproc>
  if(user_dst){
    80001af4:	c08d                	beqz	s1,80001b16 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001af6:	86d2                	mv	a3,s4
    80001af8:	864e                	mv	a2,s3
    80001afa:	85ca                	mv	a1,s2
    80001afc:	6928                	ld	a0,80(a0)
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	010080e7          	jalr	16(ra) # 80000b0e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b06:	70a2                	ld	ra,40(sp)
    80001b08:	7402                	ld	s0,32(sp)
    80001b0a:	64e2                	ld	s1,24(sp)
    80001b0c:	6942                	ld	s2,16(sp)
    80001b0e:	69a2                	ld	s3,8(sp)
    80001b10:	6a02                	ld	s4,0(sp)
    80001b12:	6145                	addi	sp,sp,48
    80001b14:	8082                	ret
    memmove((char *)dst, src, len);
    80001b16:	000a061b          	sext.w	a2,s4
    80001b1a:	85ce                	mv	a1,s3
    80001b1c:	854a                	mv	a0,s2
    80001b1e:	ffffe097          	auipc	ra,0xffffe
    80001b22:	6b6080e7          	jalr	1718(ra) # 800001d4 <memmove>
    return 0;
    80001b26:	8526                	mv	a0,s1
    80001b28:	bff9                	j	80001b06 <either_copyout+0x32>

0000000080001b2a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b2a:	7179                	addi	sp,sp,-48
    80001b2c:	f406                	sd	ra,40(sp)
    80001b2e:	f022                	sd	s0,32(sp)
    80001b30:	ec26                	sd	s1,24(sp)
    80001b32:	e84a                	sd	s2,16(sp)
    80001b34:	e44e                	sd	s3,8(sp)
    80001b36:	e052                	sd	s4,0(sp)
    80001b38:	1800                	addi	s0,sp,48
    80001b3a:	892a                	mv	s2,a0
    80001b3c:	84ae                	mv	s1,a1
    80001b3e:	89b2                	mv	s3,a2
    80001b40:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b42:	fffff097          	auipc	ra,0xfffff
    80001b46:	406080e7          	jalr	1030(ra) # 80000f48 <myproc>
  if(user_src){
    80001b4a:	c08d                	beqz	s1,80001b6c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b4c:	86d2                	mv	a3,s4
    80001b4e:	864e                	mv	a2,s3
    80001b50:	85ca                	mv	a1,s2
    80001b52:	6928                	ld	a0,80(a0)
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	046080e7          	jalr	70(ra) # 80000b9a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b5c:	70a2                	ld	ra,40(sp)
    80001b5e:	7402                	ld	s0,32(sp)
    80001b60:	64e2                	ld	s1,24(sp)
    80001b62:	6942                	ld	s2,16(sp)
    80001b64:	69a2                	ld	s3,8(sp)
    80001b66:	6a02                	ld	s4,0(sp)
    80001b68:	6145                	addi	sp,sp,48
    80001b6a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b6c:	000a061b          	sext.w	a2,s4
    80001b70:	85ce                	mv	a1,s3
    80001b72:	854a                	mv	a0,s2
    80001b74:	ffffe097          	auipc	ra,0xffffe
    80001b78:	660080e7          	jalr	1632(ra) # 800001d4 <memmove>
    return 0;
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	bff9                	j	80001b5c <either_copyin+0x32>

0000000080001b80 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b80:	715d                	addi	sp,sp,-80
    80001b82:	e486                	sd	ra,72(sp)
    80001b84:	e0a2                	sd	s0,64(sp)
    80001b86:	fc26                	sd	s1,56(sp)
    80001b88:	f84a                	sd	s2,48(sp)
    80001b8a:	f44e                	sd	s3,40(sp)
    80001b8c:	f052                	sd	s4,32(sp)
    80001b8e:	ec56                	sd	s5,24(sp)
    80001b90:	e85a                	sd	s6,16(sp)
    80001b92:	e45e                	sd	s7,8(sp)
    80001b94:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b96:	00006517          	auipc	a0,0x6
    80001b9a:	4b250513          	addi	a0,a0,1202 # 80008048 <etext+0x48>
    80001b9e:	00004097          	auipc	ra,0x4
    80001ba2:	2fc080e7          	jalr	764(ra) # 80005e9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ba6:	00007497          	auipc	s1,0x7
    80001baa:	36248493          	addi	s1,s1,866 # 80008f08 <proc+0x158>
    80001bae:	0000d917          	auipc	s2,0xd
    80001bb2:	f5a90913          	addi	s2,s2,-166 # 8000eb08 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bb8:	00006997          	auipc	s3,0x6
    80001bbc:	68098993          	addi	s3,s3,1664 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001bc0:	00006a97          	auipc	s5,0x6
    80001bc4:	680a8a93          	addi	s5,s5,1664 # 80008240 <etext+0x240>
    printf("\n");
    80001bc8:	00006a17          	auipc	s4,0x6
    80001bcc:	480a0a13          	addi	s4,s4,1152 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bd0:	00006b97          	auipc	s7,0x6
    80001bd4:	6b0b8b93          	addi	s7,s7,1712 # 80008280 <states.0>
    80001bd8:	a00d                	j	80001bfa <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bda:	ed86a583          	lw	a1,-296(a3)
    80001bde:	8556                	mv	a0,s5
    80001be0:	00004097          	auipc	ra,0x4
    80001be4:	2ba080e7          	jalr	698(ra) # 80005e9a <printf>
    printf("\n");
    80001be8:	8552                	mv	a0,s4
    80001bea:	00004097          	auipc	ra,0x4
    80001bee:	2b0080e7          	jalr	688(ra) # 80005e9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bf2:	17048493          	addi	s1,s1,368
    80001bf6:	03248163          	beq	s1,s2,80001c18 <procdump+0x98>
    if(p->state == UNUSED)
    80001bfa:	86a6                	mv	a3,s1
    80001bfc:	ec04a783          	lw	a5,-320(s1)
    80001c00:	dbed                	beqz	a5,80001bf2 <procdump+0x72>
      state = "???";
    80001c02:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c04:	fcfb6be3          	bltu	s6,a5,80001bda <procdump+0x5a>
    80001c08:	1782                	slli	a5,a5,0x20
    80001c0a:	9381                	srli	a5,a5,0x20
    80001c0c:	078e                	slli	a5,a5,0x3
    80001c0e:	97de                	add	a5,a5,s7
    80001c10:	6390                	ld	a2,0(a5)
    80001c12:	f661                	bnez	a2,80001bda <procdump+0x5a>
      state = "???";
    80001c14:	864e                	mv	a2,s3
    80001c16:	b7d1                	j	80001bda <procdump+0x5a>
  }
}
    80001c18:	60a6                	ld	ra,72(sp)
    80001c1a:	6406                	ld	s0,64(sp)
    80001c1c:	74e2                	ld	s1,56(sp)
    80001c1e:	7942                	ld	s2,48(sp)
    80001c20:	79a2                	ld	s3,40(sp)
    80001c22:	7a02                	ld	s4,32(sp)
    80001c24:	6ae2                	ld	s5,24(sp)
    80001c26:	6b42                	ld	s6,16(sp)
    80001c28:	6ba2                	ld	s7,8(sp)
    80001c2a:	6161                	addi	sp,sp,80
    80001c2c:	8082                	ret

0000000080001c2e <swtch>:
    80001c2e:	00153023          	sd	ra,0(a0)
    80001c32:	00253423          	sd	sp,8(a0)
    80001c36:	e900                	sd	s0,16(a0)
    80001c38:	ed04                	sd	s1,24(a0)
    80001c3a:	03253023          	sd	s2,32(a0)
    80001c3e:	03353423          	sd	s3,40(a0)
    80001c42:	03453823          	sd	s4,48(a0)
    80001c46:	03553c23          	sd	s5,56(a0)
    80001c4a:	05653023          	sd	s6,64(a0)
    80001c4e:	05753423          	sd	s7,72(a0)
    80001c52:	05853823          	sd	s8,80(a0)
    80001c56:	05953c23          	sd	s9,88(a0)
    80001c5a:	07a53023          	sd	s10,96(a0)
    80001c5e:	07b53423          	sd	s11,104(a0)
    80001c62:	0005b083          	ld	ra,0(a1)
    80001c66:	0085b103          	ld	sp,8(a1)
    80001c6a:	6980                	ld	s0,16(a1)
    80001c6c:	6d84                	ld	s1,24(a1)
    80001c6e:	0205b903          	ld	s2,32(a1)
    80001c72:	0285b983          	ld	s3,40(a1)
    80001c76:	0305ba03          	ld	s4,48(a1)
    80001c7a:	0385ba83          	ld	s5,56(a1)
    80001c7e:	0405bb03          	ld	s6,64(a1)
    80001c82:	0485bb83          	ld	s7,72(a1)
    80001c86:	0505bc03          	ld	s8,80(a1)
    80001c8a:	0585bc83          	ld	s9,88(a1)
    80001c8e:	0605bd03          	ld	s10,96(a1)
    80001c92:	0685bd83          	ld	s11,104(a1)
    80001c96:	8082                	ret

0000000080001c98 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c98:	1141                	addi	sp,sp,-16
    80001c9a:	e406                	sd	ra,8(sp)
    80001c9c:	e022                	sd	s0,0(sp)
    80001c9e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ca0:	00006597          	auipc	a1,0x6
    80001ca4:	61058593          	addi	a1,a1,1552 # 800082b0 <states.0+0x30>
    80001ca8:	0000d517          	auipc	a0,0xd
    80001cac:	d0850513          	addi	a0,a0,-760 # 8000e9b0 <tickslock>
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	64c080e7          	jalr	1612(ra) # 800062fc <initlock>
}
    80001cb8:	60a2                	ld	ra,8(sp)
    80001cba:	6402                	ld	s0,0(sp)
    80001cbc:	0141                	addi	sp,sp,16
    80001cbe:	8082                	ret

0000000080001cc0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cc0:	1141                	addi	sp,sp,-16
    80001cc2:	e422                	sd	s0,8(sp)
    80001cc4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc6:	00003797          	auipc	a5,0x3
    80001cca:	5ba78793          	addi	a5,a5,1466 # 80005280 <kernelvec>
    80001cce:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cd2:	6422                	ld	s0,8(sp)
    80001cd4:	0141                	addi	sp,sp,16
    80001cd6:	8082                	ret

0000000080001cd8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cd8:	1141                	addi	sp,sp,-16
    80001cda:	e406                	sd	ra,8(sp)
    80001cdc:	e022                	sd	s0,0(sp)
    80001cde:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	268080e7          	jalr	616(ra) # 80000f48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cee:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cf2:	00005617          	auipc	a2,0x5
    80001cf6:	30e60613          	addi	a2,a2,782 # 80007000 <_trampoline>
    80001cfa:	00005697          	auipc	a3,0x5
    80001cfe:	30668693          	addi	a3,a3,774 # 80007000 <_trampoline>
    80001d02:	8e91                	sub	a3,a3,a2
    80001d04:	040007b7          	lui	a5,0x4000
    80001d08:	17fd                	addi	a5,a5,-1
    80001d0a:	07b2                	slli	a5,a5,0xc
    80001d0c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d0e:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d12:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d14:	180026f3          	csrr	a3,satp
    80001d18:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d1a:	6d38                	ld	a4,88(a0)
    80001d1c:	6134                	ld	a3,64(a0)
    80001d1e:	6585                	lui	a1,0x1
    80001d20:	96ae                	add	a3,a3,a1
    80001d22:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d24:	6d38                	ld	a4,88(a0)
    80001d26:	00000697          	auipc	a3,0x0
    80001d2a:	13068693          	addi	a3,a3,304 # 80001e56 <usertrap>
    80001d2e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d30:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d32:	8692                	mv	a3,tp
    80001d34:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d36:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d3a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d3e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d42:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d46:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d48:	6f18                	ld	a4,24(a4)
    80001d4a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d4e:	6928                	ld	a0,80(a0)
    80001d50:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d52:	00005717          	auipc	a4,0x5
    80001d56:	34a70713          	addi	a4,a4,842 # 8000709c <userret>
    80001d5a:	8f11                	sub	a4,a4,a2
    80001d5c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d5e:	577d                	li	a4,-1
    80001d60:	177e                	slli	a4,a4,0x3f
    80001d62:	8d59                	or	a0,a0,a4
    80001d64:	9782                	jalr	a5
}
    80001d66:	60a2                	ld	ra,8(sp)
    80001d68:	6402                	ld	s0,0(sp)
    80001d6a:	0141                	addi	sp,sp,16
    80001d6c:	8082                	ret

0000000080001d6e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d6e:	1101                	addi	sp,sp,-32
    80001d70:	ec06                	sd	ra,24(sp)
    80001d72:	e822                	sd	s0,16(sp)
    80001d74:	e426                	sd	s1,8(sp)
    80001d76:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d78:	0000d497          	auipc	s1,0xd
    80001d7c:	c3848493          	addi	s1,s1,-968 # 8000e9b0 <tickslock>
    80001d80:	8526                	mv	a0,s1
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	60a080e7          	jalr	1546(ra) # 8000638c <acquire>
  ticks++;
    80001d8a:	00007517          	auipc	a0,0x7
    80001d8e:	bbe50513          	addi	a0,a0,-1090 # 80008948 <ticks>
    80001d92:	411c                	lw	a5,0(a0)
    80001d94:	2785                	addiw	a5,a5,1
    80001d96:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	998080e7          	jalr	-1640(ra) # 80001730 <wakeup>
  release(&tickslock);
    80001da0:	8526                	mv	a0,s1
    80001da2:	00004097          	auipc	ra,0x4
    80001da6:	69e080e7          	jalr	1694(ra) # 80006440 <release>
}
    80001daa:	60e2                	ld	ra,24(sp)
    80001dac:	6442                	ld	s0,16(sp)
    80001dae:	64a2                	ld	s1,8(sp)
    80001db0:	6105                	addi	sp,sp,32
    80001db2:	8082                	ret

0000000080001db4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001db4:	1101                	addi	sp,sp,-32
    80001db6:	ec06                	sd	ra,24(sp)
    80001db8:	e822                	sd	s0,16(sp)
    80001dba:	e426                	sd	s1,8(sp)
    80001dbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dbe:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001dc2:	00074d63          	bltz	a4,80001ddc <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001dc6:	57fd                	li	a5,-1
    80001dc8:	17fe                	slli	a5,a5,0x3f
    80001dca:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dcc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dce:	06f70363          	beq	a4,a5,80001e34 <devintr+0x80>
  }
}
    80001dd2:	60e2                	ld	ra,24(sp)
    80001dd4:	6442                	ld	s0,16(sp)
    80001dd6:	64a2                	ld	s1,8(sp)
    80001dd8:	6105                	addi	sp,sp,32
    80001dda:	8082                	ret
     (scause & 0xff) == 9){
    80001ddc:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001de0:	46a5                	li	a3,9
    80001de2:	fed792e3          	bne	a5,a3,80001dc6 <devintr+0x12>
    int irq = plic_claim();
    80001de6:	00003097          	auipc	ra,0x3
    80001dea:	5a2080e7          	jalr	1442(ra) # 80005388 <plic_claim>
    80001dee:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001df0:	47a9                	li	a5,10
    80001df2:	02f50763          	beq	a0,a5,80001e20 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001df6:	4785                	li	a5,1
    80001df8:	02f50963          	beq	a0,a5,80001e2a <devintr+0x76>
    return 1;
    80001dfc:	4505                	li	a0,1
    } else if(irq){
    80001dfe:	d8f1                	beqz	s1,80001dd2 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e00:	85a6                	mv	a1,s1
    80001e02:	00006517          	auipc	a0,0x6
    80001e06:	4b650513          	addi	a0,a0,1206 # 800082b8 <states.0+0x38>
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	090080e7          	jalr	144(ra) # 80005e9a <printf>
      plic_complete(irq);
    80001e12:	8526                	mv	a0,s1
    80001e14:	00003097          	auipc	ra,0x3
    80001e18:	598080e7          	jalr	1432(ra) # 800053ac <plic_complete>
    return 1;
    80001e1c:	4505                	li	a0,1
    80001e1e:	bf55                	j	80001dd2 <devintr+0x1e>
      uartintr();
    80001e20:	00004097          	auipc	ra,0x4
    80001e24:	48c080e7          	jalr	1164(ra) # 800062ac <uartintr>
    80001e28:	b7ed                	j	80001e12 <devintr+0x5e>
      virtio_disk_intr();
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	a4e080e7          	jalr	-1458(ra) # 80005878 <virtio_disk_intr>
    80001e32:	b7c5                	j	80001e12 <devintr+0x5e>
    if(cpuid() == 0){
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	0e8080e7          	jalr	232(ra) # 80000f1c <cpuid>
    80001e3c:	c901                	beqz	a0,80001e4c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e3e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e42:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e44:	14479073          	csrw	sip,a5
    return 2;
    80001e48:	4509                	li	a0,2
    80001e4a:	b761                	j	80001dd2 <devintr+0x1e>
      clockintr();
    80001e4c:	00000097          	auipc	ra,0x0
    80001e50:	f22080e7          	jalr	-222(ra) # 80001d6e <clockintr>
    80001e54:	b7ed                	j	80001e3e <devintr+0x8a>

0000000080001e56 <usertrap>:
{
    80001e56:	1101                	addi	sp,sp,-32
    80001e58:	ec06                	sd	ra,24(sp)
    80001e5a:	e822                	sd	s0,16(sp)
    80001e5c:	e426                	sd	s1,8(sp)
    80001e5e:	e04a                	sd	s2,0(sp)
    80001e60:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e62:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e66:	1007f793          	andi	a5,a5,256
    80001e6a:	e3b1                	bnez	a5,80001eae <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e6c:	00003797          	auipc	a5,0x3
    80001e70:	41478793          	addi	a5,a5,1044 # 80005280 <kernelvec>
    80001e74:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	0d0080e7          	jalr	208(ra) # 80000f48 <myproc>
    80001e80:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e82:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e84:	14102773          	csrr	a4,sepc
    80001e88:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e8a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e8e:	47a1                	li	a5,8
    80001e90:	02f70763          	beq	a4,a5,80001ebe <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e94:	00000097          	auipc	ra,0x0
    80001e98:	f20080e7          	jalr	-224(ra) # 80001db4 <devintr>
    80001e9c:	892a                	mv	s2,a0
    80001e9e:	c151                	beqz	a0,80001f22 <usertrap+0xcc>
  if(killed(p))
    80001ea0:	8526                	mv	a0,s1
    80001ea2:	00000097          	auipc	ra,0x0
    80001ea6:	ad2080e7          	jalr	-1326(ra) # 80001974 <killed>
    80001eaa:	c929                	beqz	a0,80001efc <usertrap+0xa6>
    80001eac:	a099                	j	80001ef2 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001eae:	00006517          	auipc	a0,0x6
    80001eb2:	42a50513          	addi	a0,a0,1066 # 800082d8 <states.0+0x58>
    80001eb6:	00004097          	auipc	ra,0x4
    80001eba:	f9a080e7          	jalr	-102(ra) # 80005e50 <panic>
    if(killed(p))
    80001ebe:	00000097          	auipc	ra,0x0
    80001ec2:	ab6080e7          	jalr	-1354(ra) # 80001974 <killed>
    80001ec6:	e921                	bnez	a0,80001f16 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001ec8:	6cb8                	ld	a4,88(s1)
    80001eca:	6f1c                	ld	a5,24(a4)
    80001ecc:	0791                	addi	a5,a5,4
    80001ece:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ed4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ed8:	10079073          	csrw	sstatus,a5
    syscall();
    80001edc:	00000097          	auipc	ra,0x0
    80001ee0:	2d4080e7          	jalr	724(ra) # 800021b0 <syscall>
  if(killed(p))
    80001ee4:	8526                	mv	a0,s1
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	a8e080e7          	jalr	-1394(ra) # 80001974 <killed>
    80001eee:	c911                	beqz	a0,80001f02 <usertrap+0xac>
    80001ef0:	4901                	li	s2,0
    exit(-1);
    80001ef2:	557d                	li	a0,-1
    80001ef4:	00000097          	auipc	ra,0x0
    80001ef8:	90c080e7          	jalr	-1780(ra) # 80001800 <exit>
  if(which_dev == 2)
    80001efc:	4789                	li	a5,2
    80001efe:	04f90f63          	beq	s2,a5,80001f5c <usertrap+0x106>
  usertrapret();
    80001f02:	00000097          	auipc	ra,0x0
    80001f06:	dd6080e7          	jalr	-554(ra) # 80001cd8 <usertrapret>
}
    80001f0a:	60e2                	ld	ra,24(sp)
    80001f0c:	6442                	ld	s0,16(sp)
    80001f0e:	64a2                	ld	s1,8(sp)
    80001f10:	6902                	ld	s2,0(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret
      exit(-1);
    80001f16:	557d                	li	a0,-1
    80001f18:	00000097          	auipc	ra,0x0
    80001f1c:	8e8080e7          	jalr	-1816(ra) # 80001800 <exit>
    80001f20:	b765                	j	80001ec8 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f22:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f26:	5890                	lw	a2,48(s1)
    80001f28:	00006517          	auipc	a0,0x6
    80001f2c:	3d050513          	addi	a0,a0,976 # 800082f8 <states.0+0x78>
    80001f30:	00004097          	auipc	ra,0x4
    80001f34:	f6a080e7          	jalr	-150(ra) # 80005e9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f38:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f3c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f40:	00006517          	auipc	a0,0x6
    80001f44:	3e850513          	addi	a0,a0,1000 # 80008328 <states.0+0xa8>
    80001f48:	00004097          	auipc	ra,0x4
    80001f4c:	f52080e7          	jalr	-174(ra) # 80005e9a <printf>
    setkilled(p);
    80001f50:	8526                	mv	a0,s1
    80001f52:	00000097          	auipc	ra,0x0
    80001f56:	9f6080e7          	jalr	-1546(ra) # 80001948 <setkilled>
    80001f5a:	b769                	j	80001ee4 <usertrap+0x8e>
    yield();
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	734080e7          	jalr	1844(ra) # 80001690 <yield>
    80001f64:	bf79                	j	80001f02 <usertrap+0xac>

0000000080001f66 <kerneltrap>:
{
    80001f66:	7179                	addi	sp,sp,-48
    80001f68:	f406                	sd	ra,40(sp)
    80001f6a:	f022                	sd	s0,32(sp)
    80001f6c:	ec26                	sd	s1,24(sp)
    80001f6e:	e84a                	sd	s2,16(sp)
    80001f70:	e44e                	sd	s3,8(sp)
    80001f72:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f74:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f78:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f7c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f80:	1004f793          	andi	a5,s1,256
    80001f84:	cb85                	beqz	a5,80001fb4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f8a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f8c:	ef85                	bnez	a5,80001fc4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	e26080e7          	jalr	-474(ra) # 80001db4 <devintr>
    80001f96:	cd1d                	beqz	a0,80001fd4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f98:	4789                	li	a5,2
    80001f9a:	06f50a63          	beq	a0,a5,8000200e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f9e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fa2:	10049073          	csrw	sstatus,s1
}
    80001fa6:	70a2                	ld	ra,40(sp)
    80001fa8:	7402                	ld	s0,32(sp)
    80001faa:	64e2                	ld	s1,24(sp)
    80001fac:	6942                	ld	s2,16(sp)
    80001fae:	69a2                	ld	s3,8(sp)
    80001fb0:	6145                	addi	sp,sp,48
    80001fb2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fb4:	00006517          	auipc	a0,0x6
    80001fb8:	39450513          	addi	a0,a0,916 # 80008348 <states.0+0xc8>
    80001fbc:	00004097          	auipc	ra,0x4
    80001fc0:	e94080e7          	jalr	-364(ra) # 80005e50 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fc4:	00006517          	auipc	a0,0x6
    80001fc8:	3ac50513          	addi	a0,a0,940 # 80008370 <states.0+0xf0>
    80001fcc:	00004097          	auipc	ra,0x4
    80001fd0:	e84080e7          	jalr	-380(ra) # 80005e50 <panic>
    printf("scause %p\n", scause);
    80001fd4:	85ce                	mv	a1,s3
    80001fd6:	00006517          	auipc	a0,0x6
    80001fda:	3ba50513          	addi	a0,a0,954 # 80008390 <states.0+0x110>
    80001fde:	00004097          	auipc	ra,0x4
    80001fe2:	ebc080e7          	jalr	-324(ra) # 80005e9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fe6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fea:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fee:	00006517          	auipc	a0,0x6
    80001ff2:	3b250513          	addi	a0,a0,946 # 800083a0 <states.0+0x120>
    80001ff6:	00004097          	auipc	ra,0x4
    80001ffa:	ea4080e7          	jalr	-348(ra) # 80005e9a <printf>
    panic("kerneltrap");
    80001ffe:	00006517          	auipc	a0,0x6
    80002002:	3ba50513          	addi	a0,a0,954 # 800083b8 <states.0+0x138>
    80002006:	00004097          	auipc	ra,0x4
    8000200a:	e4a080e7          	jalr	-438(ra) # 80005e50 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	f3a080e7          	jalr	-198(ra) # 80000f48 <myproc>
    80002016:	d541                	beqz	a0,80001f9e <kerneltrap+0x38>
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	f30080e7          	jalr	-208(ra) # 80000f48 <myproc>
    80002020:	4d18                	lw	a4,24(a0)
    80002022:	4791                	li	a5,4
    80002024:	f6f71de3          	bne	a4,a5,80001f9e <kerneltrap+0x38>
    yield();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	668080e7          	jalr	1640(ra) # 80001690 <yield>
    80002030:	b7bd                	j	80001f9e <kerneltrap+0x38>

0000000080002032 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002032:	1101                	addi	sp,sp,-32
    80002034:	ec06                	sd	ra,24(sp)
    80002036:	e822                	sd	s0,16(sp)
    80002038:	e426                	sd	s1,8(sp)
    8000203a:	1000                	addi	s0,sp,32
    8000203c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000203e:	fffff097          	auipc	ra,0xfffff
    80002042:	f0a080e7          	jalr	-246(ra) # 80000f48 <myproc>
  switch (n) {
    80002046:	4795                	li	a5,5
    80002048:	0497e163          	bltu	a5,s1,8000208a <argraw+0x58>
    8000204c:	048a                	slli	s1,s1,0x2
    8000204e:	00006717          	auipc	a4,0x6
    80002052:	3a270713          	addi	a4,a4,930 # 800083f0 <states.0+0x170>
    80002056:	94ba                	add	s1,s1,a4
    80002058:	409c                	lw	a5,0(s1)
    8000205a:	97ba                	add	a5,a5,a4
    8000205c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000205e:	6d3c                	ld	a5,88(a0)
    80002060:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002062:	60e2                	ld	ra,24(sp)
    80002064:	6442                	ld	s0,16(sp)
    80002066:	64a2                	ld	s1,8(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret
    return p->trapframe->a1;
    8000206c:	6d3c                	ld	a5,88(a0)
    8000206e:	7fa8                	ld	a0,120(a5)
    80002070:	bfcd                	j	80002062 <argraw+0x30>
    return p->trapframe->a2;
    80002072:	6d3c                	ld	a5,88(a0)
    80002074:	63c8                	ld	a0,128(a5)
    80002076:	b7f5                	j	80002062 <argraw+0x30>
    return p->trapframe->a3;
    80002078:	6d3c                	ld	a5,88(a0)
    8000207a:	67c8                	ld	a0,136(a5)
    8000207c:	b7dd                	j	80002062 <argraw+0x30>
    return p->trapframe->a4;
    8000207e:	6d3c                	ld	a5,88(a0)
    80002080:	6bc8                	ld	a0,144(a5)
    80002082:	b7c5                	j	80002062 <argraw+0x30>
    return p->trapframe->a5;
    80002084:	6d3c                	ld	a5,88(a0)
    80002086:	6fc8                	ld	a0,152(a5)
    80002088:	bfe9                	j	80002062 <argraw+0x30>
  panic("argraw");
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	33e50513          	addi	a0,a0,830 # 800083c8 <states.0+0x148>
    80002092:	00004097          	auipc	ra,0x4
    80002096:	dbe080e7          	jalr	-578(ra) # 80005e50 <panic>

000000008000209a <fetchaddr>:
{
    8000209a:	1101                	addi	sp,sp,-32
    8000209c:	ec06                	sd	ra,24(sp)
    8000209e:	e822                	sd	s0,16(sp)
    800020a0:	e426                	sd	s1,8(sp)
    800020a2:	e04a                	sd	s2,0(sp)
    800020a4:	1000                	addi	s0,sp,32
    800020a6:	84aa                	mv	s1,a0
    800020a8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020aa:	fffff097          	auipc	ra,0xfffff
    800020ae:	e9e080e7          	jalr	-354(ra) # 80000f48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800020b2:	653c                	ld	a5,72(a0)
    800020b4:	02f4f863          	bgeu	s1,a5,800020e4 <fetchaddr+0x4a>
    800020b8:	00848713          	addi	a4,s1,8
    800020bc:	02e7e663          	bltu	a5,a4,800020e8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020c0:	46a1                	li	a3,8
    800020c2:	8626                	mv	a2,s1
    800020c4:	85ca                	mv	a1,s2
    800020c6:	6928                	ld	a0,80(a0)
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	ad2080e7          	jalr	-1326(ra) # 80000b9a <copyin>
    800020d0:	00a03533          	snez	a0,a0
    800020d4:	40a00533          	neg	a0,a0
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6902                	ld	s2,0(sp)
    800020e0:	6105                	addi	sp,sp,32
    800020e2:	8082                	ret
    return -1;
    800020e4:	557d                	li	a0,-1
    800020e6:	bfcd                	j	800020d8 <fetchaddr+0x3e>
    800020e8:	557d                	li	a0,-1
    800020ea:	b7fd                	j	800020d8 <fetchaddr+0x3e>

00000000800020ec <fetchstr>:
{
    800020ec:	7179                	addi	sp,sp,-48
    800020ee:	f406                	sd	ra,40(sp)
    800020f0:	f022                	sd	s0,32(sp)
    800020f2:	ec26                	sd	s1,24(sp)
    800020f4:	e84a                	sd	s2,16(sp)
    800020f6:	e44e                	sd	s3,8(sp)
    800020f8:	1800                	addi	s0,sp,48
    800020fa:	892a                	mv	s2,a0
    800020fc:	84ae                	mv	s1,a1
    800020fe:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	e48080e7          	jalr	-440(ra) # 80000f48 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002108:	86ce                	mv	a3,s3
    8000210a:	864a                	mv	a2,s2
    8000210c:	85a6                	mv	a1,s1
    8000210e:	6928                	ld	a0,80(a0)
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	b18080e7          	jalr	-1256(ra) # 80000c28 <copyinstr>
    80002118:	00054e63          	bltz	a0,80002134 <fetchstr+0x48>
  return strlen(buf);
    8000211c:	8526                	mv	a0,s1
    8000211e:	ffffe097          	auipc	ra,0xffffe
    80002122:	1d6080e7          	jalr	470(ra) # 800002f4 <strlen>
}
    80002126:	70a2                	ld	ra,40(sp)
    80002128:	7402                	ld	s0,32(sp)
    8000212a:	64e2                	ld	s1,24(sp)
    8000212c:	6942                	ld	s2,16(sp)
    8000212e:	69a2                	ld	s3,8(sp)
    80002130:	6145                	addi	sp,sp,48
    80002132:	8082                	ret
    return -1;
    80002134:	557d                	li	a0,-1
    80002136:	bfc5                	j	80002126 <fetchstr+0x3a>

0000000080002138 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002138:	1101                	addi	sp,sp,-32
    8000213a:	ec06                	sd	ra,24(sp)
    8000213c:	e822                	sd	s0,16(sp)
    8000213e:	e426                	sd	s1,8(sp)
    80002140:	1000                	addi	s0,sp,32
    80002142:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002144:	00000097          	auipc	ra,0x0
    80002148:	eee080e7          	jalr	-274(ra) # 80002032 <argraw>
    8000214c:	c088                	sw	a0,0(s1)
}
    8000214e:	60e2                	ld	ra,24(sp)
    80002150:	6442                	ld	s0,16(sp)
    80002152:	64a2                	ld	s1,8(sp)
    80002154:	6105                	addi	sp,sp,32
    80002156:	8082                	ret

0000000080002158 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002158:	1101                	addi	sp,sp,-32
    8000215a:	ec06                	sd	ra,24(sp)
    8000215c:	e822                	sd	s0,16(sp)
    8000215e:	e426                	sd	s1,8(sp)
    80002160:	1000                	addi	s0,sp,32
    80002162:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002164:	00000097          	auipc	ra,0x0
    80002168:	ece080e7          	jalr	-306(ra) # 80002032 <argraw>
    8000216c:	e088                	sd	a0,0(s1)
}
    8000216e:	60e2                	ld	ra,24(sp)
    80002170:	6442                	ld	s0,16(sp)
    80002172:	64a2                	ld	s1,8(sp)
    80002174:	6105                	addi	sp,sp,32
    80002176:	8082                	ret

0000000080002178 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002178:	7179                	addi	sp,sp,-48
    8000217a:	f406                	sd	ra,40(sp)
    8000217c:	f022                	sd	s0,32(sp)
    8000217e:	ec26                	sd	s1,24(sp)
    80002180:	e84a                	sd	s2,16(sp)
    80002182:	1800                	addi	s0,sp,48
    80002184:	84ae                	mv	s1,a1
    80002186:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002188:	fd840593          	addi	a1,s0,-40
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	fcc080e7          	jalr	-52(ra) # 80002158 <argaddr>
  return fetchstr(addr, buf, max);
    80002194:	864a                	mv	a2,s2
    80002196:	85a6                	mv	a1,s1
    80002198:	fd843503          	ld	a0,-40(s0)
    8000219c:	00000097          	auipc	ra,0x0
    800021a0:	f50080e7          	jalr	-176(ra) # 800020ec <fetchstr>
}
    800021a4:	70a2                	ld	ra,40(sp)
    800021a6:	7402                	ld	s0,32(sp)
    800021a8:	64e2                	ld	s1,24(sp)
    800021aa:	6942                	ld	s2,16(sp)
    800021ac:	6145                	addi	sp,sp,48
    800021ae:	8082                	ret

00000000800021b0 <syscall>:



void
syscall(void)
{
    800021b0:	1101                	addi	sp,sp,-32
    800021b2:	ec06                	sd	ra,24(sp)
    800021b4:	e822                	sd	s0,16(sp)
    800021b6:	e426                	sd	s1,8(sp)
    800021b8:	e04a                	sd	s2,0(sp)
    800021ba:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	d8c080e7          	jalr	-628(ra) # 80000f48 <myproc>
    800021c4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021c6:	05853903          	ld	s2,88(a0)
    800021ca:	0a893783          	ld	a5,168(s2)
    800021ce:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021d2:	37fd                	addiw	a5,a5,-1
    800021d4:	4775                	li	a4,29
    800021d6:	00f76f63          	bltu	a4,a5,800021f4 <syscall+0x44>
    800021da:	00369713          	slli	a4,a3,0x3
    800021de:	00006797          	auipc	a5,0x6
    800021e2:	22a78793          	addi	a5,a5,554 # 80008408 <syscalls>
    800021e6:	97ba                	add	a5,a5,a4
    800021e8:	639c                	ld	a5,0(a5)
    800021ea:	c789                	beqz	a5,800021f4 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021ec:	9782                	jalr	a5
    800021ee:	06a93823          	sd	a0,112(s2)
    800021f2:	a839                	j	80002210 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021f4:	15848613          	addi	a2,s1,344
    800021f8:	588c                	lw	a1,48(s1)
    800021fa:	00006517          	auipc	a0,0x6
    800021fe:	1d650513          	addi	a0,a0,470 # 800083d0 <states.0+0x150>
    80002202:	00004097          	auipc	ra,0x4
    80002206:	c98080e7          	jalr	-872(ra) # 80005e9a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000220a:	6cbc                	ld	a5,88(s1)
    8000220c:	577d                	li	a4,-1
    8000220e:	fbb8                	sd	a4,112(a5)
  }
}
    80002210:	60e2                	ld	ra,24(sp)
    80002212:	6442                	ld	s0,16(sp)
    80002214:	64a2                	ld	s1,8(sp)
    80002216:	6902                	ld	s2,0(sp)
    80002218:	6105                	addi	sp,sp,32
    8000221a:	8082                	ret

000000008000221c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002224:	fec40593          	addi	a1,s0,-20
    80002228:	4501                	li	a0,0
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	f0e080e7          	jalr	-242(ra) # 80002138 <argint>
  exit(n);
    80002232:	fec42503          	lw	a0,-20(s0)
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	5ca080e7          	jalr	1482(ra) # 80001800 <exit>
  return 0;  // not reached
}
    8000223e:	4501                	li	a0,0
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	6105                	addi	sp,sp,32
    80002246:	8082                	ret

0000000080002248 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002248:	1141                	addi	sp,sp,-16
    8000224a:	e406                	sd	ra,8(sp)
    8000224c:	e022                	sd	s0,0(sp)
    8000224e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	cf8080e7          	jalr	-776(ra) # 80000f48 <myproc>
}
    80002258:	5908                	lw	a0,48(a0)
    8000225a:	60a2                	ld	ra,8(sp)
    8000225c:	6402                	ld	s0,0(sp)
    8000225e:	0141                	addi	sp,sp,16
    80002260:	8082                	ret

0000000080002262 <sys_fork>:

uint64
sys_fork(void)
{
    80002262:	1141                	addi	sp,sp,-16
    80002264:	e406                	sd	ra,8(sp)
    80002266:	e022                	sd	s0,0(sp)
    80002268:	0800                	addi	s0,sp,16
  return fork();
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	170080e7          	jalr	368(ra) # 800013da <fork>
}
    80002272:	60a2                	ld	ra,8(sp)
    80002274:	6402                	ld	s0,0(sp)
    80002276:	0141                	addi	sp,sp,16
    80002278:	8082                	ret

000000008000227a <sys_wait>:

uint64
sys_wait(void)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002282:	fe840593          	addi	a1,s0,-24
    80002286:	4501                	li	a0,0
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	ed0080e7          	jalr	-304(ra) # 80002158 <argaddr>
  return wait(p);
    80002290:	fe843503          	ld	a0,-24(s0)
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	712080e7          	jalr	1810(ra) # 800019a6 <wait>
}
    8000229c:	60e2                	ld	ra,24(sp)
    8000229e:	6442                	ld	s0,16(sp)
    800022a0:	6105                	addi	sp,sp,32
    800022a2:	8082                	ret

00000000800022a4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022a4:	7179                	addi	sp,sp,-48
    800022a6:	f406                	sd	ra,40(sp)
    800022a8:	f022                	sd	s0,32(sp)
    800022aa:	ec26                	sd	s1,24(sp)
    800022ac:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800022ae:	fdc40593          	addi	a1,s0,-36
    800022b2:	4501                	li	a0,0
    800022b4:	00000097          	auipc	ra,0x0
    800022b8:	e84080e7          	jalr	-380(ra) # 80002138 <argint>
  addr = myproc()->sz;
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	c8c080e7          	jalr	-884(ra) # 80000f48 <myproc>
    800022c4:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800022c6:	fdc42503          	lw	a0,-36(s0)
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	0b4080e7          	jalr	180(ra) # 8000137e <growproc>
    800022d2:	00054863          	bltz	a0,800022e2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022d6:	8526                	mv	a0,s1
    800022d8:	70a2                	ld	ra,40(sp)
    800022da:	7402                	ld	s0,32(sp)
    800022dc:	64e2                	ld	s1,24(sp)
    800022de:	6145                	addi	sp,sp,48
    800022e0:	8082                	ret
    return -1;
    800022e2:	54fd                	li	s1,-1
    800022e4:	bfcd                	j	800022d6 <sys_sbrk+0x32>

00000000800022e6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022e6:	7139                	addi	sp,sp,-64
    800022e8:	fc06                	sd	ra,56(sp)
    800022ea:	f822                	sd	s0,48(sp)
    800022ec:	f426                	sd	s1,40(sp)
    800022ee:	f04a                	sd	s2,32(sp)
    800022f0:	ec4e                	sd	s3,24(sp)
    800022f2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800022f4:	fcc40593          	addi	a1,s0,-52
    800022f8:	4501                	li	a0,0
    800022fa:	00000097          	auipc	ra,0x0
    800022fe:	e3e080e7          	jalr	-450(ra) # 80002138 <argint>
  acquire(&tickslock);
    80002302:	0000c517          	auipc	a0,0xc
    80002306:	6ae50513          	addi	a0,a0,1710 # 8000e9b0 <tickslock>
    8000230a:	00004097          	auipc	ra,0x4
    8000230e:	082080e7          	jalr	130(ra) # 8000638c <acquire>
  ticks0 = ticks;
    80002312:	00006917          	auipc	s2,0x6
    80002316:	63692903          	lw	s2,1590(s2) # 80008948 <ticks>
  while(ticks - ticks0 < n){
    8000231a:	fcc42783          	lw	a5,-52(s0)
    8000231e:	cf9d                	beqz	a5,8000235c <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002320:	0000c997          	auipc	s3,0xc
    80002324:	69098993          	addi	s3,s3,1680 # 8000e9b0 <tickslock>
    80002328:	00006497          	auipc	s1,0x6
    8000232c:	62048493          	addi	s1,s1,1568 # 80008948 <ticks>
    if(killed(myproc())){
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	c18080e7          	jalr	-1000(ra) # 80000f48 <myproc>
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	63c080e7          	jalr	1596(ra) # 80001974 <killed>
    80002340:	ed15                	bnez	a0,8000237c <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002342:	85ce                	mv	a1,s3
    80002344:	8526                	mv	a0,s1
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	386080e7          	jalr	902(ra) # 800016cc <sleep>
  while(ticks - ticks0 < n){
    8000234e:	409c                	lw	a5,0(s1)
    80002350:	412787bb          	subw	a5,a5,s2
    80002354:	fcc42703          	lw	a4,-52(s0)
    80002358:	fce7ece3          	bltu	a5,a4,80002330 <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000235c:	0000c517          	auipc	a0,0xc
    80002360:	65450513          	addi	a0,a0,1620 # 8000e9b0 <tickslock>
    80002364:	00004097          	auipc	ra,0x4
    80002368:	0dc080e7          	jalr	220(ra) # 80006440 <release>
  return 0;
    8000236c:	4501                	li	a0,0
}
    8000236e:	70e2                	ld	ra,56(sp)
    80002370:	7442                	ld	s0,48(sp)
    80002372:	74a2                	ld	s1,40(sp)
    80002374:	7902                	ld	s2,32(sp)
    80002376:	69e2                	ld	s3,24(sp)
    80002378:	6121                	addi	sp,sp,64
    8000237a:	8082                	ret
      release(&tickslock);
    8000237c:	0000c517          	auipc	a0,0xc
    80002380:	63450513          	addi	a0,a0,1588 # 8000e9b0 <tickslock>
    80002384:	00004097          	auipc	ra,0x4
    80002388:	0bc080e7          	jalr	188(ra) # 80006440 <release>
      return -1;
    8000238c:	557d                	li	a0,-1
    8000238e:	b7c5                	j	8000236e <sys_sleep+0x88>

0000000080002390 <vm_pgacess>:

int vm_pgacess(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;

  if (va >= MAXVA)
    80002390:	57fd                	li	a5,-1
    80002392:	83e9                	srli	a5,a5,0x1a
    80002394:	00b7f463          	bgeu	a5,a1,8000239c <vm_pgacess+0xc>
    return 0;
    80002398:	4501                	li	a0,0
  {
    *pte = *pte & (~PTE_A);//set 0
    return 1;
  }
  return 0;
}
    8000239a:	8082                	ret
{
    8000239c:	1141                	addi	sp,sp,-16
    8000239e:	e406                	sd	ra,8(sp)
    800023a0:	e022                	sd	s0,0(sp)
    800023a2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800023a4:	4601                	li	a2,0
    800023a6:	ffffe097          	auipc	ra,0xffffe
    800023aa:	0b6080e7          	jalr	182(ra) # 8000045c <walk>
    800023ae:	87aa                	mv	a5,a0
  if (pte == 0)
    800023b0:	c115                	beqz	a0,800023d4 <vm_pgacess+0x44>
  if ((*pte & PTE_V) == 0)
    800023b2:	6118                	ld	a4,0(a0)
  if ((*pte & PTE_A) != 0)
    800023b4:	04177613          	andi	a2,a4,65
    800023b8:	04100693          	li	a3,65
  return 0;
    800023bc:	4501                	li	a0,0
  if ((*pte & PTE_A) != 0)
    800023be:	00d60663          	beq	a2,a3,800023ca <vm_pgacess+0x3a>
}
    800023c2:	60a2                	ld	ra,8(sp)
    800023c4:	6402                	ld	s0,0(sp)
    800023c6:	0141                	addi	sp,sp,16
    800023c8:	8082                	ret
    *pte = *pte & (~PTE_A);//set 0
    800023ca:	fbf77713          	andi	a4,a4,-65
    800023ce:	e398                	sd	a4,0(a5)
    return 1;
    800023d0:	4505                	li	a0,1
    800023d2:	bfc5                	j	800023c2 <vm_pgacess+0x32>
    return 0;
    800023d4:	4501                	li	a0,0
    800023d6:	b7f5                	j	800023c2 <vm_pgacess+0x32>

00000000800023d8 <sys_pgaccess>:
#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    800023d8:	7139                	addi	sp,sp,-64
    800023da:	fc06                	sd	ra,56(sp)
    800023dc:	f822                	sd	s0,48(sp)
    800023de:	f426                	sd	s1,40(sp)
    800023e0:	f04a                	sd	s2,32(sp)
    800023e2:	0080                	addi	s0,sp,64
  // lab pgtbl: your code here.
  uint64 addr;
  int len;
  int bitmask;
  //current process p
  struct proc *p = myproc();
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	b64080e7          	jalr	-1180(ra) # 80000f48 <myproc>
    800023ec:	892a                	mv	s2,a0
  argint(1,&len);
    800023ee:	fd440593          	addi	a1,s0,-44
    800023f2:	4505                	li	a0,1
    800023f4:	00000097          	auipc	ra,0x0
    800023f8:	d44080e7          	jalr	-700(ra) # 80002138 <argint>
  argaddr(0,&addr);
    800023fc:	fd840593          	addi	a1,s0,-40
    80002400:	4501                	li	a0,0
    80002402:	00000097          	auipc	ra,0x0
    80002406:	d56080e7          	jalr	-682(ra) # 80002158 <argaddr>
  argint(2,&bitmask);
    8000240a:	fd040593          	addi	a1,s0,-48
    8000240e:	4509                	li	a0,2
    80002410:	00000097          	auipc	ra,0x0
    80002414:	d28080e7          	jalr	-728(ra) # 80002138 <argint>
  int res = 0;
    80002418:	fc042623          	sw	zero,-52(s0)
  //use loop to estimate every bit
  for (int i = 0; i < len; i ++)
    8000241c:	fd442783          	lw	a5,-44(s0)
    80002420:	02f05a63          	blez	a5,80002454 <sys_pgaccess+0x7c>
    80002424:	4481                	li	s1,0
  {
    int va=addr+i*PGSIZE;
    80002426:	00c4959b          	slliw	a1,s1,0xc
    int abit = vm_pgacess(p->pagetable, va);
    8000242a:	fd843783          	ld	a5,-40(s0)
    8000242e:	9dbd                	addw	a1,a1,a5
    80002430:	05093503          	ld	a0,80(s2)
    80002434:	00000097          	auipc	ra,0x0
    80002438:	f5c080e7          	jalr	-164(ra) # 80002390 <vm_pgacess>
    res = res | abit << i; 
    8000243c:	009517bb          	sllw	a5,a0,s1
    80002440:	fcc42703          	lw	a4,-52(s0)
    80002444:	8fd9                	or	a5,a5,a4
    80002446:	fcf42623          	sw	a5,-52(s0)
  for (int i = 0; i < len; i ++)
    8000244a:	2485                	addiw	s1,s1,1
    8000244c:	fd442783          	lw	a5,-44(s0)
    80002450:	fcf4cbe3          	blt	s1,a5,80002426 <sys_pgaccess+0x4e>
  }
  if (copyout(p->pagetable, bitmask, (char *)&res, sizeof(res)) < 0)
    80002454:	4691                	li	a3,4
    80002456:	fcc40613          	addi	a2,s0,-52
    8000245a:	fd042583          	lw	a1,-48(s0)
    8000245e:	05093503          	ld	a0,80(s2)
    80002462:	ffffe097          	auipc	ra,0xffffe
    80002466:	6ac080e7          	jalr	1708(ra) # 80000b0e <copyout>
    return -1;

  return 0;
}
    8000246a:	41f5551b          	sraiw	a0,a0,0x1f
    8000246e:	70e2                	ld	ra,56(sp)
    80002470:	7442                	ld	s0,48(sp)
    80002472:	74a2                	ld	s1,40(sp)
    80002474:	7902                	ld	s2,32(sp)
    80002476:	6121                	addi	sp,sp,64
    80002478:	8082                	ret

000000008000247a <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000247a:	1101                	addi	sp,sp,-32
    8000247c:	ec06                	sd	ra,24(sp)
    8000247e:	e822                	sd	s0,16(sp)
    80002480:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002482:	fec40593          	addi	a1,s0,-20
    80002486:	4501                	li	a0,0
    80002488:	00000097          	auipc	ra,0x0
    8000248c:	cb0080e7          	jalr	-848(ra) # 80002138 <argint>
  return kill(pid);
    80002490:	fec42503          	lw	a0,-20(s0)
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	442080e7          	jalr	1090(ra) # 800018d6 <kill>
}
    8000249c:	60e2                	ld	ra,24(sp)
    8000249e:	6442                	ld	s0,16(sp)
    800024a0:	6105                	addi	sp,sp,32
    800024a2:	8082                	ret

00000000800024a4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024a4:	1101                	addi	sp,sp,-32
    800024a6:	ec06                	sd	ra,24(sp)
    800024a8:	e822                	sd	s0,16(sp)
    800024aa:	e426                	sd	s1,8(sp)
    800024ac:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024ae:	0000c517          	auipc	a0,0xc
    800024b2:	50250513          	addi	a0,a0,1282 # 8000e9b0 <tickslock>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	ed6080e7          	jalr	-298(ra) # 8000638c <acquire>
  xticks = ticks;
    800024be:	00006497          	auipc	s1,0x6
    800024c2:	48a4a483          	lw	s1,1162(s1) # 80008948 <ticks>
  release(&tickslock);
    800024c6:	0000c517          	auipc	a0,0xc
    800024ca:	4ea50513          	addi	a0,a0,1258 # 8000e9b0 <tickslock>
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	f72080e7          	jalr	-142(ra) # 80006440 <release>
  return xticks;
}
    800024d6:	02049513          	slli	a0,s1,0x20
    800024da:	9101                	srli	a0,a0,0x20
    800024dc:	60e2                	ld	ra,24(sp)
    800024de:	6442                	ld	s0,16(sp)
    800024e0:	64a2                	ld	s1,8(sp)
    800024e2:	6105                	addi	sp,sp,32
    800024e4:	8082                	ret

00000000800024e6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024e6:	7179                	addi	sp,sp,-48
    800024e8:	f406                	sd	ra,40(sp)
    800024ea:	f022                	sd	s0,32(sp)
    800024ec:	ec26                	sd	s1,24(sp)
    800024ee:	e84a                	sd	s2,16(sp)
    800024f0:	e44e                	sd	s3,8(sp)
    800024f2:	e052                	sd	s4,0(sp)
    800024f4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024f6:	00006597          	auipc	a1,0x6
    800024fa:	00a58593          	addi	a1,a1,10 # 80008500 <syscalls+0xf8>
    800024fe:	0000c517          	auipc	a0,0xc
    80002502:	4ca50513          	addi	a0,a0,1226 # 8000e9c8 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	df6080e7          	jalr	-522(ra) # 800062fc <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000250e:	00014797          	auipc	a5,0x14
    80002512:	4ba78793          	addi	a5,a5,1210 # 800169c8 <bcache+0x8000>
    80002516:	00014717          	auipc	a4,0x14
    8000251a:	71a70713          	addi	a4,a4,1818 # 80016c30 <bcache+0x8268>
    8000251e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002522:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002526:	0000c497          	auipc	s1,0xc
    8000252a:	4ba48493          	addi	s1,s1,1210 # 8000e9e0 <bcache+0x18>
    b->next = bcache.head.next;
    8000252e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002530:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002532:	00006a17          	auipc	s4,0x6
    80002536:	fd6a0a13          	addi	s4,s4,-42 # 80008508 <syscalls+0x100>
    b->next = bcache.head.next;
    8000253a:	2b893783          	ld	a5,696(s2)
    8000253e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002540:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002544:	85d2                	mv	a1,s4
    80002546:	01048513          	addi	a0,s1,16
    8000254a:	00001097          	auipc	ra,0x1
    8000254e:	4c4080e7          	jalr	1220(ra) # 80003a0e <initsleeplock>
    bcache.head.next->prev = b;
    80002552:	2b893783          	ld	a5,696(s2)
    80002556:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002558:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000255c:	45848493          	addi	s1,s1,1112
    80002560:	fd349de3          	bne	s1,s3,8000253a <binit+0x54>
  }
}
    80002564:	70a2                	ld	ra,40(sp)
    80002566:	7402                	ld	s0,32(sp)
    80002568:	64e2                	ld	s1,24(sp)
    8000256a:	6942                	ld	s2,16(sp)
    8000256c:	69a2                	ld	s3,8(sp)
    8000256e:	6a02                	ld	s4,0(sp)
    80002570:	6145                	addi	sp,sp,48
    80002572:	8082                	ret

0000000080002574 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002574:	7179                	addi	sp,sp,-48
    80002576:	f406                	sd	ra,40(sp)
    80002578:	f022                	sd	s0,32(sp)
    8000257a:	ec26                	sd	s1,24(sp)
    8000257c:	e84a                	sd	s2,16(sp)
    8000257e:	e44e                	sd	s3,8(sp)
    80002580:	1800                	addi	s0,sp,48
    80002582:	892a                	mv	s2,a0
    80002584:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002586:	0000c517          	auipc	a0,0xc
    8000258a:	44250513          	addi	a0,a0,1090 # 8000e9c8 <bcache>
    8000258e:	00004097          	auipc	ra,0x4
    80002592:	dfe080e7          	jalr	-514(ra) # 8000638c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002596:	00014497          	auipc	s1,0x14
    8000259a:	6ea4b483          	ld	s1,1770(s1) # 80016c80 <bcache+0x82b8>
    8000259e:	00014797          	auipc	a5,0x14
    800025a2:	69278793          	addi	a5,a5,1682 # 80016c30 <bcache+0x8268>
    800025a6:	02f48f63          	beq	s1,a5,800025e4 <bread+0x70>
    800025aa:	873e                	mv	a4,a5
    800025ac:	a021                	j	800025b4 <bread+0x40>
    800025ae:	68a4                	ld	s1,80(s1)
    800025b0:	02e48a63          	beq	s1,a4,800025e4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025b4:	449c                	lw	a5,8(s1)
    800025b6:	ff279ce3          	bne	a5,s2,800025ae <bread+0x3a>
    800025ba:	44dc                	lw	a5,12(s1)
    800025bc:	ff3799e3          	bne	a5,s3,800025ae <bread+0x3a>
      b->refcnt++;
    800025c0:	40bc                	lw	a5,64(s1)
    800025c2:	2785                	addiw	a5,a5,1
    800025c4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c6:	0000c517          	auipc	a0,0xc
    800025ca:	40250513          	addi	a0,a0,1026 # 8000e9c8 <bcache>
    800025ce:	00004097          	auipc	ra,0x4
    800025d2:	e72080e7          	jalr	-398(ra) # 80006440 <release>
      acquiresleep(&b->lock);
    800025d6:	01048513          	addi	a0,s1,16
    800025da:	00001097          	auipc	ra,0x1
    800025de:	46e080e7          	jalr	1134(ra) # 80003a48 <acquiresleep>
      return b;
    800025e2:	a8b9                	j	80002640 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025e4:	00014497          	auipc	s1,0x14
    800025e8:	6944b483          	ld	s1,1684(s1) # 80016c78 <bcache+0x82b0>
    800025ec:	00014797          	auipc	a5,0x14
    800025f0:	64478793          	addi	a5,a5,1604 # 80016c30 <bcache+0x8268>
    800025f4:	00f48863          	beq	s1,a5,80002604 <bread+0x90>
    800025f8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025fa:	40bc                	lw	a5,64(s1)
    800025fc:	cf81                	beqz	a5,80002614 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025fe:	64a4                	ld	s1,72(s1)
    80002600:	fee49de3          	bne	s1,a4,800025fa <bread+0x86>
  panic("bget: no buffers");
    80002604:	00006517          	auipc	a0,0x6
    80002608:	f0c50513          	addi	a0,a0,-244 # 80008510 <syscalls+0x108>
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	844080e7          	jalr	-1980(ra) # 80005e50 <panic>
      b->dev = dev;
    80002614:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002618:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000261c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002620:	4785                	li	a5,1
    80002622:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002624:	0000c517          	auipc	a0,0xc
    80002628:	3a450513          	addi	a0,a0,932 # 8000e9c8 <bcache>
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	e14080e7          	jalr	-492(ra) # 80006440 <release>
      acquiresleep(&b->lock);
    80002634:	01048513          	addi	a0,s1,16
    80002638:	00001097          	auipc	ra,0x1
    8000263c:	410080e7          	jalr	1040(ra) # 80003a48 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002640:	409c                	lw	a5,0(s1)
    80002642:	cb89                	beqz	a5,80002654 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002644:	8526                	mv	a0,s1
    80002646:	70a2                	ld	ra,40(sp)
    80002648:	7402                	ld	s0,32(sp)
    8000264a:	64e2                	ld	s1,24(sp)
    8000264c:	6942                	ld	s2,16(sp)
    8000264e:	69a2                	ld	s3,8(sp)
    80002650:	6145                	addi	sp,sp,48
    80002652:	8082                	ret
    virtio_disk_rw(b, 0);
    80002654:	4581                	li	a1,0
    80002656:	8526                	mv	a0,s1
    80002658:	00003097          	auipc	ra,0x3
    8000265c:	fec080e7          	jalr	-20(ra) # 80005644 <virtio_disk_rw>
    b->valid = 1;
    80002660:	4785                	li	a5,1
    80002662:	c09c                	sw	a5,0(s1)
  return b;
    80002664:	b7c5                	j	80002644 <bread+0xd0>

0000000080002666 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002666:	1101                	addi	sp,sp,-32
    80002668:	ec06                	sd	ra,24(sp)
    8000266a:	e822                	sd	s0,16(sp)
    8000266c:	e426                	sd	s1,8(sp)
    8000266e:	1000                	addi	s0,sp,32
    80002670:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002672:	0541                	addi	a0,a0,16
    80002674:	00001097          	auipc	ra,0x1
    80002678:	46e080e7          	jalr	1134(ra) # 80003ae2 <holdingsleep>
    8000267c:	cd01                	beqz	a0,80002694 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000267e:	4585                	li	a1,1
    80002680:	8526                	mv	a0,s1
    80002682:	00003097          	auipc	ra,0x3
    80002686:	fc2080e7          	jalr	-62(ra) # 80005644 <virtio_disk_rw>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6105                	addi	sp,sp,32
    80002692:	8082                	ret
    panic("bwrite");
    80002694:	00006517          	auipc	a0,0x6
    80002698:	e9450513          	addi	a0,a0,-364 # 80008528 <syscalls+0x120>
    8000269c:	00003097          	auipc	ra,0x3
    800026a0:	7b4080e7          	jalr	1972(ra) # 80005e50 <panic>

00000000800026a4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026a4:	1101                	addi	sp,sp,-32
    800026a6:	ec06                	sd	ra,24(sp)
    800026a8:	e822                	sd	s0,16(sp)
    800026aa:	e426                	sd	s1,8(sp)
    800026ac:	e04a                	sd	s2,0(sp)
    800026ae:	1000                	addi	s0,sp,32
    800026b0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026b2:	01050913          	addi	s2,a0,16
    800026b6:	854a                	mv	a0,s2
    800026b8:	00001097          	auipc	ra,0x1
    800026bc:	42a080e7          	jalr	1066(ra) # 80003ae2 <holdingsleep>
    800026c0:	c92d                	beqz	a0,80002732 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026c2:	854a                	mv	a0,s2
    800026c4:	00001097          	auipc	ra,0x1
    800026c8:	3da080e7          	jalr	986(ra) # 80003a9e <releasesleep>

  acquire(&bcache.lock);
    800026cc:	0000c517          	auipc	a0,0xc
    800026d0:	2fc50513          	addi	a0,a0,764 # 8000e9c8 <bcache>
    800026d4:	00004097          	auipc	ra,0x4
    800026d8:	cb8080e7          	jalr	-840(ra) # 8000638c <acquire>
  b->refcnt--;
    800026dc:	40bc                	lw	a5,64(s1)
    800026de:	37fd                	addiw	a5,a5,-1
    800026e0:	0007871b          	sext.w	a4,a5
    800026e4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026e6:	eb05                	bnez	a4,80002716 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026e8:	68bc                	ld	a5,80(s1)
    800026ea:	64b8                	ld	a4,72(s1)
    800026ec:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026ee:	64bc                	ld	a5,72(s1)
    800026f0:	68b8                	ld	a4,80(s1)
    800026f2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026f4:	00014797          	auipc	a5,0x14
    800026f8:	2d478793          	addi	a5,a5,724 # 800169c8 <bcache+0x8000>
    800026fc:	2b87b703          	ld	a4,696(a5)
    80002700:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002702:	00014717          	auipc	a4,0x14
    80002706:	52e70713          	addi	a4,a4,1326 # 80016c30 <bcache+0x8268>
    8000270a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000270c:	2b87b703          	ld	a4,696(a5)
    80002710:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002712:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002716:	0000c517          	auipc	a0,0xc
    8000271a:	2b250513          	addi	a0,a0,690 # 8000e9c8 <bcache>
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	d22080e7          	jalr	-734(ra) # 80006440 <release>
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6902                	ld	s2,0(sp)
    8000272e:	6105                	addi	sp,sp,32
    80002730:	8082                	ret
    panic("brelse");
    80002732:	00006517          	auipc	a0,0x6
    80002736:	dfe50513          	addi	a0,a0,-514 # 80008530 <syscalls+0x128>
    8000273a:	00003097          	auipc	ra,0x3
    8000273e:	716080e7          	jalr	1814(ra) # 80005e50 <panic>

0000000080002742 <bpin>:

void
bpin(struct buf *b) {
    80002742:	1101                	addi	sp,sp,-32
    80002744:	ec06                	sd	ra,24(sp)
    80002746:	e822                	sd	s0,16(sp)
    80002748:	e426                	sd	s1,8(sp)
    8000274a:	1000                	addi	s0,sp,32
    8000274c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000274e:	0000c517          	auipc	a0,0xc
    80002752:	27a50513          	addi	a0,a0,634 # 8000e9c8 <bcache>
    80002756:	00004097          	auipc	ra,0x4
    8000275a:	c36080e7          	jalr	-970(ra) # 8000638c <acquire>
  b->refcnt++;
    8000275e:	40bc                	lw	a5,64(s1)
    80002760:	2785                	addiw	a5,a5,1
    80002762:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002764:	0000c517          	auipc	a0,0xc
    80002768:	26450513          	addi	a0,a0,612 # 8000e9c8 <bcache>
    8000276c:	00004097          	auipc	ra,0x4
    80002770:	cd4080e7          	jalr	-812(ra) # 80006440 <release>
}
    80002774:	60e2                	ld	ra,24(sp)
    80002776:	6442                	ld	s0,16(sp)
    80002778:	64a2                	ld	s1,8(sp)
    8000277a:	6105                	addi	sp,sp,32
    8000277c:	8082                	ret

000000008000277e <bunpin>:

void
bunpin(struct buf *b) {
    8000277e:	1101                	addi	sp,sp,-32
    80002780:	ec06                	sd	ra,24(sp)
    80002782:	e822                	sd	s0,16(sp)
    80002784:	e426                	sd	s1,8(sp)
    80002786:	1000                	addi	s0,sp,32
    80002788:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000278a:	0000c517          	auipc	a0,0xc
    8000278e:	23e50513          	addi	a0,a0,574 # 8000e9c8 <bcache>
    80002792:	00004097          	auipc	ra,0x4
    80002796:	bfa080e7          	jalr	-1030(ra) # 8000638c <acquire>
  b->refcnt--;
    8000279a:	40bc                	lw	a5,64(s1)
    8000279c:	37fd                	addiw	a5,a5,-1
    8000279e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027a0:	0000c517          	auipc	a0,0xc
    800027a4:	22850513          	addi	a0,a0,552 # 8000e9c8 <bcache>
    800027a8:	00004097          	auipc	ra,0x4
    800027ac:	c98080e7          	jalr	-872(ra) # 80006440 <release>
}
    800027b0:	60e2                	ld	ra,24(sp)
    800027b2:	6442                	ld	s0,16(sp)
    800027b4:	64a2                	ld	s1,8(sp)
    800027b6:	6105                	addi	sp,sp,32
    800027b8:	8082                	ret

00000000800027ba <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027ba:	1101                	addi	sp,sp,-32
    800027bc:	ec06                	sd	ra,24(sp)
    800027be:	e822                	sd	s0,16(sp)
    800027c0:	e426                	sd	s1,8(sp)
    800027c2:	e04a                	sd	s2,0(sp)
    800027c4:	1000                	addi	s0,sp,32
    800027c6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027c8:	00d5d59b          	srliw	a1,a1,0xd
    800027cc:	00015797          	auipc	a5,0x15
    800027d0:	8d87a783          	lw	a5,-1832(a5) # 800170a4 <sb+0x1c>
    800027d4:	9dbd                	addw	a1,a1,a5
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	d9e080e7          	jalr	-610(ra) # 80002574 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027de:	0074f713          	andi	a4,s1,7
    800027e2:	4785                	li	a5,1
    800027e4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027e8:	14ce                	slli	s1,s1,0x33
    800027ea:	90d9                	srli	s1,s1,0x36
    800027ec:	00950733          	add	a4,a0,s1
    800027f0:	05874703          	lbu	a4,88(a4)
    800027f4:	00e7f6b3          	and	a3,a5,a4
    800027f8:	c69d                	beqz	a3,80002826 <bfree+0x6c>
    800027fa:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027fc:	94aa                	add	s1,s1,a0
    800027fe:	fff7c793          	not	a5,a5
    80002802:	8ff9                	and	a5,a5,a4
    80002804:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002808:	00001097          	auipc	ra,0x1
    8000280c:	120080e7          	jalr	288(ra) # 80003928 <log_write>
  brelse(bp);
    80002810:	854a                	mv	a0,s2
    80002812:	00000097          	auipc	ra,0x0
    80002816:	e92080e7          	jalr	-366(ra) # 800026a4 <brelse>
}
    8000281a:	60e2                	ld	ra,24(sp)
    8000281c:	6442                	ld	s0,16(sp)
    8000281e:	64a2                	ld	s1,8(sp)
    80002820:	6902                	ld	s2,0(sp)
    80002822:	6105                	addi	sp,sp,32
    80002824:	8082                	ret
    panic("freeing free block");
    80002826:	00006517          	auipc	a0,0x6
    8000282a:	d1250513          	addi	a0,a0,-750 # 80008538 <syscalls+0x130>
    8000282e:	00003097          	auipc	ra,0x3
    80002832:	622080e7          	jalr	1570(ra) # 80005e50 <panic>

0000000080002836 <balloc>:
{
    80002836:	711d                	addi	sp,sp,-96
    80002838:	ec86                	sd	ra,88(sp)
    8000283a:	e8a2                	sd	s0,80(sp)
    8000283c:	e4a6                	sd	s1,72(sp)
    8000283e:	e0ca                	sd	s2,64(sp)
    80002840:	fc4e                	sd	s3,56(sp)
    80002842:	f852                	sd	s4,48(sp)
    80002844:	f456                	sd	s5,40(sp)
    80002846:	f05a                	sd	s6,32(sp)
    80002848:	ec5e                	sd	s7,24(sp)
    8000284a:	e862                	sd	s8,16(sp)
    8000284c:	e466                	sd	s9,8(sp)
    8000284e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002850:	00015797          	auipc	a5,0x15
    80002854:	83c7a783          	lw	a5,-1988(a5) # 8001708c <sb+0x4>
    80002858:	10078163          	beqz	a5,8000295a <balloc+0x124>
    8000285c:	8baa                	mv	s7,a0
    8000285e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002860:	00015b17          	auipc	s6,0x15
    80002864:	828b0b13          	addi	s6,s6,-2008 # 80017088 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002868:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000286a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000286c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000286e:	6c89                	lui	s9,0x2
    80002870:	a061                	j	800028f8 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002872:	974a                	add	a4,a4,s2
    80002874:	8fd5                	or	a5,a5,a3
    80002876:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000287a:	854a                	mv	a0,s2
    8000287c:	00001097          	auipc	ra,0x1
    80002880:	0ac080e7          	jalr	172(ra) # 80003928 <log_write>
        brelse(bp);
    80002884:	854a                	mv	a0,s2
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	e1e080e7          	jalr	-482(ra) # 800026a4 <brelse>
  bp = bread(dev, bno);
    8000288e:	85a6                	mv	a1,s1
    80002890:	855e                	mv	a0,s7
    80002892:	00000097          	auipc	ra,0x0
    80002896:	ce2080e7          	jalr	-798(ra) # 80002574 <bread>
    8000289a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000289c:	40000613          	li	a2,1024
    800028a0:	4581                	li	a1,0
    800028a2:	05850513          	addi	a0,a0,88
    800028a6:	ffffe097          	auipc	ra,0xffffe
    800028aa:	8d2080e7          	jalr	-1838(ra) # 80000178 <memset>
  log_write(bp);
    800028ae:	854a                	mv	a0,s2
    800028b0:	00001097          	auipc	ra,0x1
    800028b4:	078080e7          	jalr	120(ra) # 80003928 <log_write>
  brelse(bp);
    800028b8:	854a                	mv	a0,s2
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	dea080e7          	jalr	-534(ra) # 800026a4 <brelse>
}
    800028c2:	8526                	mv	a0,s1
    800028c4:	60e6                	ld	ra,88(sp)
    800028c6:	6446                	ld	s0,80(sp)
    800028c8:	64a6                	ld	s1,72(sp)
    800028ca:	6906                	ld	s2,64(sp)
    800028cc:	79e2                	ld	s3,56(sp)
    800028ce:	7a42                	ld	s4,48(sp)
    800028d0:	7aa2                	ld	s5,40(sp)
    800028d2:	7b02                	ld	s6,32(sp)
    800028d4:	6be2                	ld	s7,24(sp)
    800028d6:	6c42                	ld	s8,16(sp)
    800028d8:	6ca2                	ld	s9,8(sp)
    800028da:	6125                	addi	sp,sp,96
    800028dc:	8082                	ret
    brelse(bp);
    800028de:	854a                	mv	a0,s2
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	dc4080e7          	jalr	-572(ra) # 800026a4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028e8:	015c87bb          	addw	a5,s9,s5
    800028ec:	00078a9b          	sext.w	s5,a5
    800028f0:	004b2703          	lw	a4,4(s6)
    800028f4:	06eaf363          	bgeu	s5,a4,8000295a <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800028f8:	41fad79b          	sraiw	a5,s5,0x1f
    800028fc:	0137d79b          	srliw	a5,a5,0x13
    80002900:	015787bb          	addw	a5,a5,s5
    80002904:	40d7d79b          	sraiw	a5,a5,0xd
    80002908:	01cb2583          	lw	a1,28(s6)
    8000290c:	9dbd                	addw	a1,a1,a5
    8000290e:	855e                	mv	a0,s7
    80002910:	00000097          	auipc	ra,0x0
    80002914:	c64080e7          	jalr	-924(ra) # 80002574 <bread>
    80002918:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000291a:	004b2503          	lw	a0,4(s6)
    8000291e:	000a849b          	sext.w	s1,s5
    80002922:	8662                	mv	a2,s8
    80002924:	faa4fde3          	bgeu	s1,a0,800028de <balloc+0xa8>
      m = 1 << (bi % 8);
    80002928:	41f6579b          	sraiw	a5,a2,0x1f
    8000292c:	01d7d69b          	srliw	a3,a5,0x1d
    80002930:	00c6873b          	addw	a4,a3,a2
    80002934:	00777793          	andi	a5,a4,7
    80002938:	9f95                	subw	a5,a5,a3
    8000293a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000293e:	4037571b          	sraiw	a4,a4,0x3
    80002942:	00e906b3          	add	a3,s2,a4
    80002946:	0586c683          	lbu	a3,88(a3)
    8000294a:	00d7f5b3          	and	a1,a5,a3
    8000294e:	d195                	beqz	a1,80002872 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002950:	2605                	addiw	a2,a2,1
    80002952:	2485                	addiw	s1,s1,1
    80002954:	fd4618e3          	bne	a2,s4,80002924 <balloc+0xee>
    80002958:	b759                	j	800028de <balloc+0xa8>
  printf("balloc: out of blocks\n");
    8000295a:	00006517          	auipc	a0,0x6
    8000295e:	bf650513          	addi	a0,a0,-1034 # 80008550 <syscalls+0x148>
    80002962:	00003097          	auipc	ra,0x3
    80002966:	538080e7          	jalr	1336(ra) # 80005e9a <printf>
  return 0;
    8000296a:	4481                	li	s1,0
    8000296c:	bf99                	j	800028c2 <balloc+0x8c>

000000008000296e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000296e:	7179                	addi	sp,sp,-48
    80002970:	f406                	sd	ra,40(sp)
    80002972:	f022                	sd	s0,32(sp)
    80002974:	ec26                	sd	s1,24(sp)
    80002976:	e84a                	sd	s2,16(sp)
    80002978:	e44e                	sd	s3,8(sp)
    8000297a:	e052                	sd	s4,0(sp)
    8000297c:	1800                	addi	s0,sp,48
    8000297e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002980:	47ad                	li	a5,11
    80002982:	02b7e763          	bltu	a5,a1,800029b0 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002986:	02059493          	slli	s1,a1,0x20
    8000298a:	9081                	srli	s1,s1,0x20
    8000298c:	048a                	slli	s1,s1,0x2
    8000298e:	94aa                	add	s1,s1,a0
    80002990:	0504a903          	lw	s2,80(s1)
    80002994:	06091e63          	bnez	s2,80002a10 <bmap+0xa2>
      addr = balloc(ip->dev);
    80002998:	4108                	lw	a0,0(a0)
    8000299a:	00000097          	auipc	ra,0x0
    8000299e:	e9c080e7          	jalr	-356(ra) # 80002836 <balloc>
    800029a2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029a6:	06090563          	beqz	s2,80002a10 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800029aa:	0524a823          	sw	s2,80(s1)
    800029ae:	a08d                	j	80002a10 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800029b0:	ff45849b          	addiw	s1,a1,-12
    800029b4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029b8:	0ff00793          	li	a5,255
    800029bc:	08e7e563          	bltu	a5,a4,80002a46 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800029c0:	08052903          	lw	s2,128(a0)
    800029c4:	00091d63          	bnez	s2,800029de <bmap+0x70>
      addr = balloc(ip->dev);
    800029c8:	4108                	lw	a0,0(a0)
    800029ca:	00000097          	auipc	ra,0x0
    800029ce:	e6c080e7          	jalr	-404(ra) # 80002836 <balloc>
    800029d2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029d6:	02090d63          	beqz	s2,80002a10 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029da:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029de:	85ca                	mv	a1,s2
    800029e0:	0009a503          	lw	a0,0(s3)
    800029e4:	00000097          	auipc	ra,0x0
    800029e8:	b90080e7          	jalr	-1136(ra) # 80002574 <bread>
    800029ec:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029ee:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029f2:	02049593          	slli	a1,s1,0x20
    800029f6:	9181                	srli	a1,a1,0x20
    800029f8:	058a                	slli	a1,a1,0x2
    800029fa:	00b784b3          	add	s1,a5,a1
    800029fe:	0004a903          	lw	s2,0(s1)
    80002a02:	02090063          	beqz	s2,80002a22 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a06:	8552                	mv	a0,s4
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	c9c080e7          	jalr	-868(ra) # 800026a4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a10:	854a                	mv	a0,s2
    80002a12:	70a2                	ld	ra,40(sp)
    80002a14:	7402                	ld	s0,32(sp)
    80002a16:	64e2                	ld	s1,24(sp)
    80002a18:	6942                	ld	s2,16(sp)
    80002a1a:	69a2                	ld	s3,8(sp)
    80002a1c:	6a02                	ld	s4,0(sp)
    80002a1e:	6145                	addi	sp,sp,48
    80002a20:	8082                	ret
      addr = balloc(ip->dev);
    80002a22:	0009a503          	lw	a0,0(s3)
    80002a26:	00000097          	auipc	ra,0x0
    80002a2a:	e10080e7          	jalr	-496(ra) # 80002836 <balloc>
    80002a2e:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a32:	fc090ae3          	beqz	s2,80002a06 <bmap+0x98>
        a[bn] = addr;
    80002a36:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a3a:	8552                	mv	a0,s4
    80002a3c:	00001097          	auipc	ra,0x1
    80002a40:	eec080e7          	jalr	-276(ra) # 80003928 <log_write>
    80002a44:	b7c9                	j	80002a06 <bmap+0x98>
  panic("bmap: out of range");
    80002a46:	00006517          	auipc	a0,0x6
    80002a4a:	b2250513          	addi	a0,a0,-1246 # 80008568 <syscalls+0x160>
    80002a4e:	00003097          	auipc	ra,0x3
    80002a52:	402080e7          	jalr	1026(ra) # 80005e50 <panic>

0000000080002a56 <iget>:
{
    80002a56:	7179                	addi	sp,sp,-48
    80002a58:	f406                	sd	ra,40(sp)
    80002a5a:	f022                	sd	s0,32(sp)
    80002a5c:	ec26                	sd	s1,24(sp)
    80002a5e:	e84a                	sd	s2,16(sp)
    80002a60:	e44e                	sd	s3,8(sp)
    80002a62:	e052                	sd	s4,0(sp)
    80002a64:	1800                	addi	s0,sp,48
    80002a66:	89aa                	mv	s3,a0
    80002a68:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a6a:	00014517          	auipc	a0,0x14
    80002a6e:	63e50513          	addi	a0,a0,1598 # 800170a8 <itable>
    80002a72:	00004097          	auipc	ra,0x4
    80002a76:	91a080e7          	jalr	-1766(ra) # 8000638c <acquire>
  empty = 0;
    80002a7a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a7c:	00014497          	auipc	s1,0x14
    80002a80:	64448493          	addi	s1,s1,1604 # 800170c0 <itable+0x18>
    80002a84:	00016697          	auipc	a3,0x16
    80002a88:	0cc68693          	addi	a3,a3,204 # 80018b50 <log>
    80002a8c:	a039                	j	80002a9a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a8e:	02090b63          	beqz	s2,80002ac4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a92:	08848493          	addi	s1,s1,136
    80002a96:	02d48a63          	beq	s1,a3,80002aca <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a9a:	449c                	lw	a5,8(s1)
    80002a9c:	fef059e3          	blez	a5,80002a8e <iget+0x38>
    80002aa0:	4098                	lw	a4,0(s1)
    80002aa2:	ff3716e3          	bne	a4,s3,80002a8e <iget+0x38>
    80002aa6:	40d8                	lw	a4,4(s1)
    80002aa8:	ff4713e3          	bne	a4,s4,80002a8e <iget+0x38>
      ip->ref++;
    80002aac:	2785                	addiw	a5,a5,1
    80002aae:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ab0:	00014517          	auipc	a0,0x14
    80002ab4:	5f850513          	addi	a0,a0,1528 # 800170a8 <itable>
    80002ab8:	00004097          	auipc	ra,0x4
    80002abc:	988080e7          	jalr	-1656(ra) # 80006440 <release>
      return ip;
    80002ac0:	8926                	mv	s2,s1
    80002ac2:	a03d                	j	80002af0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ac4:	f7f9                	bnez	a5,80002a92 <iget+0x3c>
    80002ac6:	8926                	mv	s2,s1
    80002ac8:	b7e9                	j	80002a92 <iget+0x3c>
  if(empty == 0)
    80002aca:	02090c63          	beqz	s2,80002b02 <iget+0xac>
  ip->dev = dev;
    80002ace:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ad2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ad6:	4785                	li	a5,1
    80002ad8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002adc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ae0:	00014517          	auipc	a0,0x14
    80002ae4:	5c850513          	addi	a0,a0,1480 # 800170a8 <itable>
    80002ae8:	00004097          	auipc	ra,0x4
    80002aec:	958080e7          	jalr	-1704(ra) # 80006440 <release>
}
    80002af0:	854a                	mv	a0,s2
    80002af2:	70a2                	ld	ra,40(sp)
    80002af4:	7402                	ld	s0,32(sp)
    80002af6:	64e2                	ld	s1,24(sp)
    80002af8:	6942                	ld	s2,16(sp)
    80002afa:	69a2                	ld	s3,8(sp)
    80002afc:	6a02                	ld	s4,0(sp)
    80002afe:	6145                	addi	sp,sp,48
    80002b00:	8082                	ret
    panic("iget: no inodes");
    80002b02:	00006517          	auipc	a0,0x6
    80002b06:	a7e50513          	addi	a0,a0,-1410 # 80008580 <syscalls+0x178>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	346080e7          	jalr	838(ra) # 80005e50 <panic>

0000000080002b12 <fsinit>:
fsinit(int dev) {
    80002b12:	7179                	addi	sp,sp,-48
    80002b14:	f406                	sd	ra,40(sp)
    80002b16:	f022                	sd	s0,32(sp)
    80002b18:	ec26                	sd	s1,24(sp)
    80002b1a:	e84a                	sd	s2,16(sp)
    80002b1c:	e44e                	sd	s3,8(sp)
    80002b1e:	1800                	addi	s0,sp,48
    80002b20:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b22:	4585                	li	a1,1
    80002b24:	00000097          	auipc	ra,0x0
    80002b28:	a50080e7          	jalr	-1456(ra) # 80002574 <bread>
    80002b2c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b2e:	00014997          	auipc	s3,0x14
    80002b32:	55a98993          	addi	s3,s3,1370 # 80017088 <sb>
    80002b36:	02000613          	li	a2,32
    80002b3a:	05850593          	addi	a1,a0,88
    80002b3e:	854e                	mv	a0,s3
    80002b40:	ffffd097          	auipc	ra,0xffffd
    80002b44:	694080e7          	jalr	1684(ra) # 800001d4 <memmove>
  brelse(bp);
    80002b48:	8526                	mv	a0,s1
    80002b4a:	00000097          	auipc	ra,0x0
    80002b4e:	b5a080e7          	jalr	-1190(ra) # 800026a4 <brelse>
  if(sb.magic != FSMAGIC)
    80002b52:	0009a703          	lw	a4,0(s3)
    80002b56:	102037b7          	lui	a5,0x10203
    80002b5a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b5e:	02f71263          	bne	a4,a5,80002b82 <fsinit+0x70>
  initlog(dev, &sb);
    80002b62:	00014597          	auipc	a1,0x14
    80002b66:	52658593          	addi	a1,a1,1318 # 80017088 <sb>
    80002b6a:	854a                	mv	a0,s2
    80002b6c:	00001097          	auipc	ra,0x1
    80002b70:	b40080e7          	jalr	-1216(ra) # 800036ac <initlog>
}
    80002b74:	70a2                	ld	ra,40(sp)
    80002b76:	7402                	ld	s0,32(sp)
    80002b78:	64e2                	ld	s1,24(sp)
    80002b7a:	6942                	ld	s2,16(sp)
    80002b7c:	69a2                	ld	s3,8(sp)
    80002b7e:	6145                	addi	sp,sp,48
    80002b80:	8082                	ret
    panic("invalid file system");
    80002b82:	00006517          	auipc	a0,0x6
    80002b86:	a0e50513          	addi	a0,a0,-1522 # 80008590 <syscalls+0x188>
    80002b8a:	00003097          	auipc	ra,0x3
    80002b8e:	2c6080e7          	jalr	710(ra) # 80005e50 <panic>

0000000080002b92 <iinit>:
{
    80002b92:	7179                	addi	sp,sp,-48
    80002b94:	f406                	sd	ra,40(sp)
    80002b96:	f022                	sd	s0,32(sp)
    80002b98:	ec26                	sd	s1,24(sp)
    80002b9a:	e84a                	sd	s2,16(sp)
    80002b9c:	e44e                	sd	s3,8(sp)
    80002b9e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ba0:	00006597          	auipc	a1,0x6
    80002ba4:	a0858593          	addi	a1,a1,-1528 # 800085a8 <syscalls+0x1a0>
    80002ba8:	00014517          	auipc	a0,0x14
    80002bac:	50050513          	addi	a0,a0,1280 # 800170a8 <itable>
    80002bb0:	00003097          	auipc	ra,0x3
    80002bb4:	74c080e7          	jalr	1868(ra) # 800062fc <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bb8:	00014497          	auipc	s1,0x14
    80002bbc:	51848493          	addi	s1,s1,1304 # 800170d0 <itable+0x28>
    80002bc0:	00016997          	auipc	s3,0x16
    80002bc4:	fa098993          	addi	s3,s3,-96 # 80018b60 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bc8:	00006917          	auipc	s2,0x6
    80002bcc:	9e890913          	addi	s2,s2,-1560 # 800085b0 <syscalls+0x1a8>
    80002bd0:	85ca                	mv	a1,s2
    80002bd2:	8526                	mv	a0,s1
    80002bd4:	00001097          	auipc	ra,0x1
    80002bd8:	e3a080e7          	jalr	-454(ra) # 80003a0e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bdc:	08848493          	addi	s1,s1,136
    80002be0:	ff3498e3          	bne	s1,s3,80002bd0 <iinit+0x3e>
}
    80002be4:	70a2                	ld	ra,40(sp)
    80002be6:	7402                	ld	s0,32(sp)
    80002be8:	64e2                	ld	s1,24(sp)
    80002bea:	6942                	ld	s2,16(sp)
    80002bec:	69a2                	ld	s3,8(sp)
    80002bee:	6145                	addi	sp,sp,48
    80002bf0:	8082                	ret

0000000080002bf2 <ialloc>:
{
    80002bf2:	715d                	addi	sp,sp,-80
    80002bf4:	e486                	sd	ra,72(sp)
    80002bf6:	e0a2                	sd	s0,64(sp)
    80002bf8:	fc26                	sd	s1,56(sp)
    80002bfa:	f84a                	sd	s2,48(sp)
    80002bfc:	f44e                	sd	s3,40(sp)
    80002bfe:	f052                	sd	s4,32(sp)
    80002c00:	ec56                	sd	s5,24(sp)
    80002c02:	e85a                	sd	s6,16(sp)
    80002c04:	e45e                	sd	s7,8(sp)
    80002c06:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c08:	00014717          	auipc	a4,0x14
    80002c0c:	48c72703          	lw	a4,1164(a4) # 80017094 <sb+0xc>
    80002c10:	4785                	li	a5,1
    80002c12:	04e7fa63          	bgeu	a5,a4,80002c66 <ialloc+0x74>
    80002c16:	8aaa                	mv	s5,a0
    80002c18:	8bae                	mv	s7,a1
    80002c1a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c1c:	00014a17          	auipc	s4,0x14
    80002c20:	46ca0a13          	addi	s4,s4,1132 # 80017088 <sb>
    80002c24:	00048b1b          	sext.w	s6,s1
    80002c28:	0044d793          	srli	a5,s1,0x4
    80002c2c:	018a2583          	lw	a1,24(s4)
    80002c30:	9dbd                	addw	a1,a1,a5
    80002c32:	8556                	mv	a0,s5
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	940080e7          	jalr	-1728(ra) # 80002574 <bread>
    80002c3c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c3e:	05850993          	addi	s3,a0,88
    80002c42:	00f4f793          	andi	a5,s1,15
    80002c46:	079a                	slli	a5,a5,0x6
    80002c48:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c4a:	00099783          	lh	a5,0(s3)
    80002c4e:	c3a1                	beqz	a5,80002c8e <ialloc+0x9c>
    brelse(bp);
    80002c50:	00000097          	auipc	ra,0x0
    80002c54:	a54080e7          	jalr	-1452(ra) # 800026a4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c58:	0485                	addi	s1,s1,1
    80002c5a:	00ca2703          	lw	a4,12(s4)
    80002c5e:	0004879b          	sext.w	a5,s1
    80002c62:	fce7e1e3          	bltu	a5,a4,80002c24 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c66:	00006517          	auipc	a0,0x6
    80002c6a:	95250513          	addi	a0,a0,-1710 # 800085b8 <syscalls+0x1b0>
    80002c6e:	00003097          	auipc	ra,0x3
    80002c72:	22c080e7          	jalr	556(ra) # 80005e9a <printf>
  return 0;
    80002c76:	4501                	li	a0,0
}
    80002c78:	60a6                	ld	ra,72(sp)
    80002c7a:	6406                	ld	s0,64(sp)
    80002c7c:	74e2                	ld	s1,56(sp)
    80002c7e:	7942                	ld	s2,48(sp)
    80002c80:	79a2                	ld	s3,40(sp)
    80002c82:	7a02                	ld	s4,32(sp)
    80002c84:	6ae2                	ld	s5,24(sp)
    80002c86:	6b42                	ld	s6,16(sp)
    80002c88:	6ba2                	ld	s7,8(sp)
    80002c8a:	6161                	addi	sp,sp,80
    80002c8c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c8e:	04000613          	li	a2,64
    80002c92:	4581                	li	a1,0
    80002c94:	854e                	mv	a0,s3
    80002c96:	ffffd097          	auipc	ra,0xffffd
    80002c9a:	4e2080e7          	jalr	1250(ra) # 80000178 <memset>
      dip->type = type;
    80002c9e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ca2:	854a                	mv	a0,s2
    80002ca4:	00001097          	auipc	ra,0x1
    80002ca8:	c84080e7          	jalr	-892(ra) # 80003928 <log_write>
      brelse(bp);
    80002cac:	854a                	mv	a0,s2
    80002cae:	00000097          	auipc	ra,0x0
    80002cb2:	9f6080e7          	jalr	-1546(ra) # 800026a4 <brelse>
      return iget(dev, inum);
    80002cb6:	85da                	mv	a1,s6
    80002cb8:	8556                	mv	a0,s5
    80002cba:	00000097          	auipc	ra,0x0
    80002cbe:	d9c080e7          	jalr	-612(ra) # 80002a56 <iget>
    80002cc2:	bf5d                	j	80002c78 <ialloc+0x86>

0000000080002cc4 <iupdate>:
{
    80002cc4:	1101                	addi	sp,sp,-32
    80002cc6:	ec06                	sd	ra,24(sp)
    80002cc8:	e822                	sd	s0,16(sp)
    80002cca:	e426                	sd	s1,8(sp)
    80002ccc:	e04a                	sd	s2,0(sp)
    80002cce:	1000                	addi	s0,sp,32
    80002cd0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cd2:	415c                	lw	a5,4(a0)
    80002cd4:	0047d79b          	srliw	a5,a5,0x4
    80002cd8:	00014597          	auipc	a1,0x14
    80002cdc:	3c85a583          	lw	a1,968(a1) # 800170a0 <sb+0x18>
    80002ce0:	9dbd                	addw	a1,a1,a5
    80002ce2:	4108                	lw	a0,0(a0)
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	890080e7          	jalr	-1904(ra) # 80002574 <bread>
    80002cec:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cee:	05850793          	addi	a5,a0,88
    80002cf2:	40c8                	lw	a0,4(s1)
    80002cf4:	893d                	andi	a0,a0,15
    80002cf6:	051a                	slli	a0,a0,0x6
    80002cf8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cfa:	04449703          	lh	a4,68(s1)
    80002cfe:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d02:	04649703          	lh	a4,70(s1)
    80002d06:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d0a:	04849703          	lh	a4,72(s1)
    80002d0e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d12:	04a49703          	lh	a4,74(s1)
    80002d16:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d1a:	44f8                	lw	a4,76(s1)
    80002d1c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d1e:	03400613          	li	a2,52
    80002d22:	05048593          	addi	a1,s1,80
    80002d26:	0531                	addi	a0,a0,12
    80002d28:	ffffd097          	auipc	ra,0xffffd
    80002d2c:	4ac080e7          	jalr	1196(ra) # 800001d4 <memmove>
  log_write(bp);
    80002d30:	854a                	mv	a0,s2
    80002d32:	00001097          	auipc	ra,0x1
    80002d36:	bf6080e7          	jalr	-1034(ra) # 80003928 <log_write>
  brelse(bp);
    80002d3a:	854a                	mv	a0,s2
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	968080e7          	jalr	-1688(ra) # 800026a4 <brelse>
}
    80002d44:	60e2                	ld	ra,24(sp)
    80002d46:	6442                	ld	s0,16(sp)
    80002d48:	64a2                	ld	s1,8(sp)
    80002d4a:	6902                	ld	s2,0(sp)
    80002d4c:	6105                	addi	sp,sp,32
    80002d4e:	8082                	ret

0000000080002d50 <idup>:
{
    80002d50:	1101                	addi	sp,sp,-32
    80002d52:	ec06                	sd	ra,24(sp)
    80002d54:	e822                	sd	s0,16(sp)
    80002d56:	e426                	sd	s1,8(sp)
    80002d58:	1000                	addi	s0,sp,32
    80002d5a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d5c:	00014517          	auipc	a0,0x14
    80002d60:	34c50513          	addi	a0,a0,844 # 800170a8 <itable>
    80002d64:	00003097          	auipc	ra,0x3
    80002d68:	628080e7          	jalr	1576(ra) # 8000638c <acquire>
  ip->ref++;
    80002d6c:	449c                	lw	a5,8(s1)
    80002d6e:	2785                	addiw	a5,a5,1
    80002d70:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d72:	00014517          	auipc	a0,0x14
    80002d76:	33650513          	addi	a0,a0,822 # 800170a8 <itable>
    80002d7a:	00003097          	auipc	ra,0x3
    80002d7e:	6c6080e7          	jalr	1734(ra) # 80006440 <release>
}
    80002d82:	8526                	mv	a0,s1
    80002d84:	60e2                	ld	ra,24(sp)
    80002d86:	6442                	ld	s0,16(sp)
    80002d88:	64a2                	ld	s1,8(sp)
    80002d8a:	6105                	addi	sp,sp,32
    80002d8c:	8082                	ret

0000000080002d8e <ilock>:
{
    80002d8e:	1101                	addi	sp,sp,-32
    80002d90:	ec06                	sd	ra,24(sp)
    80002d92:	e822                	sd	s0,16(sp)
    80002d94:	e426                	sd	s1,8(sp)
    80002d96:	e04a                	sd	s2,0(sp)
    80002d98:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d9a:	c115                	beqz	a0,80002dbe <ilock+0x30>
    80002d9c:	84aa                	mv	s1,a0
    80002d9e:	451c                	lw	a5,8(a0)
    80002da0:	00f05f63          	blez	a5,80002dbe <ilock+0x30>
  acquiresleep(&ip->lock);
    80002da4:	0541                	addi	a0,a0,16
    80002da6:	00001097          	auipc	ra,0x1
    80002daa:	ca2080e7          	jalr	-862(ra) # 80003a48 <acquiresleep>
  if(ip->valid == 0){
    80002dae:	40bc                	lw	a5,64(s1)
    80002db0:	cf99                	beqz	a5,80002dce <ilock+0x40>
}
    80002db2:	60e2                	ld	ra,24(sp)
    80002db4:	6442                	ld	s0,16(sp)
    80002db6:	64a2                	ld	s1,8(sp)
    80002db8:	6902                	ld	s2,0(sp)
    80002dba:	6105                	addi	sp,sp,32
    80002dbc:	8082                	ret
    panic("ilock");
    80002dbe:	00006517          	auipc	a0,0x6
    80002dc2:	81250513          	addi	a0,a0,-2030 # 800085d0 <syscalls+0x1c8>
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	08a080e7          	jalr	138(ra) # 80005e50 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dce:	40dc                	lw	a5,4(s1)
    80002dd0:	0047d79b          	srliw	a5,a5,0x4
    80002dd4:	00014597          	auipc	a1,0x14
    80002dd8:	2cc5a583          	lw	a1,716(a1) # 800170a0 <sb+0x18>
    80002ddc:	9dbd                	addw	a1,a1,a5
    80002dde:	4088                	lw	a0,0(s1)
    80002de0:	fffff097          	auipc	ra,0xfffff
    80002de4:	794080e7          	jalr	1940(ra) # 80002574 <bread>
    80002de8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dea:	05850593          	addi	a1,a0,88
    80002dee:	40dc                	lw	a5,4(s1)
    80002df0:	8bbd                	andi	a5,a5,15
    80002df2:	079a                	slli	a5,a5,0x6
    80002df4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002df6:	00059783          	lh	a5,0(a1)
    80002dfa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dfe:	00259783          	lh	a5,2(a1)
    80002e02:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e06:	00459783          	lh	a5,4(a1)
    80002e0a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e0e:	00659783          	lh	a5,6(a1)
    80002e12:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e16:	459c                	lw	a5,8(a1)
    80002e18:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e1a:	03400613          	li	a2,52
    80002e1e:	05b1                	addi	a1,a1,12
    80002e20:	05048513          	addi	a0,s1,80
    80002e24:	ffffd097          	auipc	ra,0xffffd
    80002e28:	3b0080e7          	jalr	944(ra) # 800001d4 <memmove>
    brelse(bp);
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	876080e7          	jalr	-1930(ra) # 800026a4 <brelse>
    ip->valid = 1;
    80002e36:	4785                	li	a5,1
    80002e38:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e3a:	04449783          	lh	a5,68(s1)
    80002e3e:	fbb5                	bnez	a5,80002db2 <ilock+0x24>
      panic("ilock: no type");
    80002e40:	00005517          	auipc	a0,0x5
    80002e44:	79850513          	addi	a0,a0,1944 # 800085d8 <syscalls+0x1d0>
    80002e48:	00003097          	auipc	ra,0x3
    80002e4c:	008080e7          	jalr	8(ra) # 80005e50 <panic>

0000000080002e50 <iunlock>:
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	e426                	sd	s1,8(sp)
    80002e58:	e04a                	sd	s2,0(sp)
    80002e5a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e5c:	c905                	beqz	a0,80002e8c <iunlock+0x3c>
    80002e5e:	84aa                	mv	s1,a0
    80002e60:	01050913          	addi	s2,a0,16
    80002e64:	854a                	mv	a0,s2
    80002e66:	00001097          	auipc	ra,0x1
    80002e6a:	c7c080e7          	jalr	-900(ra) # 80003ae2 <holdingsleep>
    80002e6e:	cd19                	beqz	a0,80002e8c <iunlock+0x3c>
    80002e70:	449c                	lw	a5,8(s1)
    80002e72:	00f05d63          	blez	a5,80002e8c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e76:	854a                	mv	a0,s2
    80002e78:	00001097          	auipc	ra,0x1
    80002e7c:	c26080e7          	jalr	-986(ra) # 80003a9e <releasesleep>
}
    80002e80:	60e2                	ld	ra,24(sp)
    80002e82:	6442                	ld	s0,16(sp)
    80002e84:	64a2                	ld	s1,8(sp)
    80002e86:	6902                	ld	s2,0(sp)
    80002e88:	6105                	addi	sp,sp,32
    80002e8a:	8082                	ret
    panic("iunlock");
    80002e8c:	00005517          	auipc	a0,0x5
    80002e90:	75c50513          	addi	a0,a0,1884 # 800085e8 <syscalls+0x1e0>
    80002e94:	00003097          	auipc	ra,0x3
    80002e98:	fbc080e7          	jalr	-68(ra) # 80005e50 <panic>

0000000080002e9c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e9c:	7179                	addi	sp,sp,-48
    80002e9e:	f406                	sd	ra,40(sp)
    80002ea0:	f022                	sd	s0,32(sp)
    80002ea2:	ec26                	sd	s1,24(sp)
    80002ea4:	e84a                	sd	s2,16(sp)
    80002ea6:	e44e                	sd	s3,8(sp)
    80002ea8:	e052                	sd	s4,0(sp)
    80002eaa:	1800                	addi	s0,sp,48
    80002eac:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002eae:	05050493          	addi	s1,a0,80
    80002eb2:	08050913          	addi	s2,a0,128
    80002eb6:	a021                	j	80002ebe <itrunc+0x22>
    80002eb8:	0491                	addi	s1,s1,4
    80002eba:	01248d63          	beq	s1,s2,80002ed4 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ebe:	408c                	lw	a1,0(s1)
    80002ec0:	dde5                	beqz	a1,80002eb8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ec2:	0009a503          	lw	a0,0(s3)
    80002ec6:	00000097          	auipc	ra,0x0
    80002eca:	8f4080e7          	jalr	-1804(ra) # 800027ba <bfree>
      ip->addrs[i] = 0;
    80002ece:	0004a023          	sw	zero,0(s1)
    80002ed2:	b7dd                	j	80002eb8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ed4:	0809a583          	lw	a1,128(s3)
    80002ed8:	e185                	bnez	a1,80002ef8 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eda:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ede:	854e                	mv	a0,s3
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	de4080e7          	jalr	-540(ra) # 80002cc4 <iupdate>
}
    80002ee8:	70a2                	ld	ra,40(sp)
    80002eea:	7402                	ld	s0,32(sp)
    80002eec:	64e2                	ld	s1,24(sp)
    80002eee:	6942                	ld	s2,16(sp)
    80002ef0:	69a2                	ld	s3,8(sp)
    80002ef2:	6a02                	ld	s4,0(sp)
    80002ef4:	6145                	addi	sp,sp,48
    80002ef6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ef8:	0009a503          	lw	a0,0(s3)
    80002efc:	fffff097          	auipc	ra,0xfffff
    80002f00:	678080e7          	jalr	1656(ra) # 80002574 <bread>
    80002f04:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f06:	05850493          	addi	s1,a0,88
    80002f0a:	45850913          	addi	s2,a0,1112
    80002f0e:	a021                	j	80002f16 <itrunc+0x7a>
    80002f10:	0491                	addi	s1,s1,4
    80002f12:	01248b63          	beq	s1,s2,80002f28 <itrunc+0x8c>
      if(a[j])
    80002f16:	408c                	lw	a1,0(s1)
    80002f18:	dde5                	beqz	a1,80002f10 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002f1a:	0009a503          	lw	a0,0(s3)
    80002f1e:	00000097          	auipc	ra,0x0
    80002f22:	89c080e7          	jalr	-1892(ra) # 800027ba <bfree>
    80002f26:	b7ed                	j	80002f10 <itrunc+0x74>
    brelse(bp);
    80002f28:	8552                	mv	a0,s4
    80002f2a:	fffff097          	auipc	ra,0xfffff
    80002f2e:	77a080e7          	jalr	1914(ra) # 800026a4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f32:	0809a583          	lw	a1,128(s3)
    80002f36:	0009a503          	lw	a0,0(s3)
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	880080e7          	jalr	-1920(ra) # 800027ba <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f42:	0809a023          	sw	zero,128(s3)
    80002f46:	bf51                	j	80002eda <itrunc+0x3e>

0000000080002f48 <iput>:
{
    80002f48:	1101                	addi	sp,sp,-32
    80002f4a:	ec06                	sd	ra,24(sp)
    80002f4c:	e822                	sd	s0,16(sp)
    80002f4e:	e426                	sd	s1,8(sp)
    80002f50:	e04a                	sd	s2,0(sp)
    80002f52:	1000                	addi	s0,sp,32
    80002f54:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f56:	00014517          	auipc	a0,0x14
    80002f5a:	15250513          	addi	a0,a0,338 # 800170a8 <itable>
    80002f5e:	00003097          	auipc	ra,0x3
    80002f62:	42e080e7          	jalr	1070(ra) # 8000638c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f66:	4498                	lw	a4,8(s1)
    80002f68:	4785                	li	a5,1
    80002f6a:	02f70363          	beq	a4,a5,80002f90 <iput+0x48>
  ip->ref--;
    80002f6e:	449c                	lw	a5,8(s1)
    80002f70:	37fd                	addiw	a5,a5,-1
    80002f72:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f74:	00014517          	auipc	a0,0x14
    80002f78:	13450513          	addi	a0,a0,308 # 800170a8 <itable>
    80002f7c:	00003097          	auipc	ra,0x3
    80002f80:	4c4080e7          	jalr	1220(ra) # 80006440 <release>
}
    80002f84:	60e2                	ld	ra,24(sp)
    80002f86:	6442                	ld	s0,16(sp)
    80002f88:	64a2                	ld	s1,8(sp)
    80002f8a:	6902                	ld	s2,0(sp)
    80002f8c:	6105                	addi	sp,sp,32
    80002f8e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f90:	40bc                	lw	a5,64(s1)
    80002f92:	dff1                	beqz	a5,80002f6e <iput+0x26>
    80002f94:	04a49783          	lh	a5,74(s1)
    80002f98:	fbf9                	bnez	a5,80002f6e <iput+0x26>
    acquiresleep(&ip->lock);
    80002f9a:	01048913          	addi	s2,s1,16
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	00001097          	auipc	ra,0x1
    80002fa4:	aa8080e7          	jalr	-1368(ra) # 80003a48 <acquiresleep>
    release(&itable.lock);
    80002fa8:	00014517          	auipc	a0,0x14
    80002fac:	10050513          	addi	a0,a0,256 # 800170a8 <itable>
    80002fb0:	00003097          	auipc	ra,0x3
    80002fb4:	490080e7          	jalr	1168(ra) # 80006440 <release>
    itrunc(ip);
    80002fb8:	8526                	mv	a0,s1
    80002fba:	00000097          	auipc	ra,0x0
    80002fbe:	ee2080e7          	jalr	-286(ra) # 80002e9c <itrunc>
    ip->type = 0;
    80002fc2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	cfc080e7          	jalr	-772(ra) # 80002cc4 <iupdate>
    ip->valid = 0;
    80002fd0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fd4:	854a                	mv	a0,s2
    80002fd6:	00001097          	auipc	ra,0x1
    80002fda:	ac8080e7          	jalr	-1336(ra) # 80003a9e <releasesleep>
    acquire(&itable.lock);
    80002fde:	00014517          	auipc	a0,0x14
    80002fe2:	0ca50513          	addi	a0,a0,202 # 800170a8 <itable>
    80002fe6:	00003097          	auipc	ra,0x3
    80002fea:	3a6080e7          	jalr	934(ra) # 8000638c <acquire>
    80002fee:	b741                	j	80002f6e <iput+0x26>

0000000080002ff0 <iunlockput>:
{
    80002ff0:	1101                	addi	sp,sp,-32
    80002ff2:	ec06                	sd	ra,24(sp)
    80002ff4:	e822                	sd	s0,16(sp)
    80002ff6:	e426                	sd	s1,8(sp)
    80002ff8:	1000                	addi	s0,sp,32
    80002ffa:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ffc:	00000097          	auipc	ra,0x0
    80003000:	e54080e7          	jalr	-428(ra) # 80002e50 <iunlock>
  iput(ip);
    80003004:	8526                	mv	a0,s1
    80003006:	00000097          	auipc	ra,0x0
    8000300a:	f42080e7          	jalr	-190(ra) # 80002f48 <iput>
}
    8000300e:	60e2                	ld	ra,24(sp)
    80003010:	6442                	ld	s0,16(sp)
    80003012:	64a2                	ld	s1,8(sp)
    80003014:	6105                	addi	sp,sp,32
    80003016:	8082                	ret

0000000080003018 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003018:	1141                	addi	sp,sp,-16
    8000301a:	e422                	sd	s0,8(sp)
    8000301c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000301e:	411c                	lw	a5,0(a0)
    80003020:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003022:	415c                	lw	a5,4(a0)
    80003024:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003026:	04451783          	lh	a5,68(a0)
    8000302a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000302e:	04a51783          	lh	a5,74(a0)
    80003032:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003036:	04c56783          	lwu	a5,76(a0)
    8000303a:	e99c                	sd	a5,16(a1)
}
    8000303c:	6422                	ld	s0,8(sp)
    8000303e:	0141                	addi	sp,sp,16
    80003040:	8082                	ret

0000000080003042 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003042:	457c                	lw	a5,76(a0)
    80003044:	0ed7e963          	bltu	a5,a3,80003136 <readi+0xf4>
{
    80003048:	7159                	addi	sp,sp,-112
    8000304a:	f486                	sd	ra,104(sp)
    8000304c:	f0a2                	sd	s0,96(sp)
    8000304e:	eca6                	sd	s1,88(sp)
    80003050:	e8ca                	sd	s2,80(sp)
    80003052:	e4ce                	sd	s3,72(sp)
    80003054:	e0d2                	sd	s4,64(sp)
    80003056:	fc56                	sd	s5,56(sp)
    80003058:	f85a                	sd	s6,48(sp)
    8000305a:	f45e                	sd	s7,40(sp)
    8000305c:	f062                	sd	s8,32(sp)
    8000305e:	ec66                	sd	s9,24(sp)
    80003060:	e86a                	sd	s10,16(sp)
    80003062:	e46e                	sd	s11,8(sp)
    80003064:	1880                	addi	s0,sp,112
    80003066:	8b2a                	mv	s6,a0
    80003068:	8bae                	mv	s7,a1
    8000306a:	8a32                	mv	s4,a2
    8000306c:	84b6                	mv	s1,a3
    8000306e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003070:	9f35                	addw	a4,a4,a3
    return 0;
    80003072:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003074:	0ad76063          	bltu	a4,a3,80003114 <readi+0xd2>
  if(off + n > ip->size)
    80003078:	00e7f463          	bgeu	a5,a4,80003080 <readi+0x3e>
    n = ip->size - off;
    8000307c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003080:	0a0a8963          	beqz	s5,80003132 <readi+0xf0>
    80003084:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003086:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000308a:	5c7d                	li	s8,-1
    8000308c:	a82d                	j	800030c6 <readi+0x84>
    8000308e:	020d1d93          	slli	s11,s10,0x20
    80003092:	020ddd93          	srli	s11,s11,0x20
    80003096:	05890793          	addi	a5,s2,88
    8000309a:	86ee                	mv	a3,s11
    8000309c:	963e                	add	a2,a2,a5
    8000309e:	85d2                	mv	a1,s4
    800030a0:	855e                	mv	a0,s7
    800030a2:	fffff097          	auipc	ra,0xfffff
    800030a6:	a32080e7          	jalr	-1486(ra) # 80001ad4 <either_copyout>
    800030aa:	05850d63          	beq	a0,s8,80003104 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030ae:	854a                	mv	a0,s2
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	5f4080e7          	jalr	1524(ra) # 800026a4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b8:	013d09bb          	addw	s3,s10,s3
    800030bc:	009d04bb          	addw	s1,s10,s1
    800030c0:	9a6e                	add	s4,s4,s11
    800030c2:	0559f763          	bgeu	s3,s5,80003110 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800030c6:	00a4d59b          	srliw	a1,s1,0xa
    800030ca:	855a                	mv	a0,s6
    800030cc:	00000097          	auipc	ra,0x0
    800030d0:	8a2080e7          	jalr	-1886(ra) # 8000296e <bmap>
    800030d4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030d8:	cd85                	beqz	a1,80003110 <readi+0xce>
    bp = bread(ip->dev, addr);
    800030da:	000b2503          	lw	a0,0(s6)
    800030de:	fffff097          	auipc	ra,0xfffff
    800030e2:	496080e7          	jalr	1174(ra) # 80002574 <bread>
    800030e6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030e8:	3ff4f613          	andi	a2,s1,1023
    800030ec:	40cc87bb          	subw	a5,s9,a2
    800030f0:	413a873b          	subw	a4,s5,s3
    800030f4:	8d3e                	mv	s10,a5
    800030f6:	2781                	sext.w	a5,a5
    800030f8:	0007069b          	sext.w	a3,a4
    800030fc:	f8f6f9e3          	bgeu	a3,a5,8000308e <readi+0x4c>
    80003100:	8d3a                	mv	s10,a4
    80003102:	b771                	j	8000308e <readi+0x4c>
      brelse(bp);
    80003104:	854a                	mv	a0,s2
    80003106:	fffff097          	auipc	ra,0xfffff
    8000310a:	59e080e7          	jalr	1438(ra) # 800026a4 <brelse>
      tot = -1;
    8000310e:	59fd                	li	s3,-1
  }
  return tot;
    80003110:	0009851b          	sext.w	a0,s3
}
    80003114:	70a6                	ld	ra,104(sp)
    80003116:	7406                	ld	s0,96(sp)
    80003118:	64e6                	ld	s1,88(sp)
    8000311a:	6946                	ld	s2,80(sp)
    8000311c:	69a6                	ld	s3,72(sp)
    8000311e:	6a06                	ld	s4,64(sp)
    80003120:	7ae2                	ld	s5,56(sp)
    80003122:	7b42                	ld	s6,48(sp)
    80003124:	7ba2                	ld	s7,40(sp)
    80003126:	7c02                	ld	s8,32(sp)
    80003128:	6ce2                	ld	s9,24(sp)
    8000312a:	6d42                	ld	s10,16(sp)
    8000312c:	6da2                	ld	s11,8(sp)
    8000312e:	6165                	addi	sp,sp,112
    80003130:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003132:	89d6                	mv	s3,s5
    80003134:	bff1                	j	80003110 <readi+0xce>
    return 0;
    80003136:	4501                	li	a0,0
}
    80003138:	8082                	ret

000000008000313a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000313a:	457c                	lw	a5,76(a0)
    8000313c:	10d7e863          	bltu	a5,a3,8000324c <writei+0x112>
{
    80003140:	7159                	addi	sp,sp,-112
    80003142:	f486                	sd	ra,104(sp)
    80003144:	f0a2                	sd	s0,96(sp)
    80003146:	eca6                	sd	s1,88(sp)
    80003148:	e8ca                	sd	s2,80(sp)
    8000314a:	e4ce                	sd	s3,72(sp)
    8000314c:	e0d2                	sd	s4,64(sp)
    8000314e:	fc56                	sd	s5,56(sp)
    80003150:	f85a                	sd	s6,48(sp)
    80003152:	f45e                	sd	s7,40(sp)
    80003154:	f062                	sd	s8,32(sp)
    80003156:	ec66                	sd	s9,24(sp)
    80003158:	e86a                	sd	s10,16(sp)
    8000315a:	e46e                	sd	s11,8(sp)
    8000315c:	1880                	addi	s0,sp,112
    8000315e:	8aaa                	mv	s5,a0
    80003160:	8bae                	mv	s7,a1
    80003162:	8a32                	mv	s4,a2
    80003164:	8936                	mv	s2,a3
    80003166:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003168:	00e687bb          	addw	a5,a3,a4
    8000316c:	0ed7e263          	bltu	a5,a3,80003250 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003170:	00043737          	lui	a4,0x43
    80003174:	0ef76063          	bltu	a4,a5,80003254 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003178:	0c0b0863          	beqz	s6,80003248 <writei+0x10e>
    8000317c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000317e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003182:	5c7d                	li	s8,-1
    80003184:	a091                	j	800031c8 <writei+0x8e>
    80003186:	020d1d93          	slli	s11,s10,0x20
    8000318a:	020ddd93          	srli	s11,s11,0x20
    8000318e:	05848793          	addi	a5,s1,88
    80003192:	86ee                	mv	a3,s11
    80003194:	8652                	mv	a2,s4
    80003196:	85de                	mv	a1,s7
    80003198:	953e                	add	a0,a0,a5
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	990080e7          	jalr	-1648(ra) # 80001b2a <either_copyin>
    800031a2:	07850263          	beq	a0,s8,80003206 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031a6:	8526                	mv	a0,s1
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	780080e7          	jalr	1920(ra) # 80003928 <log_write>
    brelse(bp);
    800031b0:	8526                	mv	a0,s1
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	4f2080e7          	jalr	1266(ra) # 800026a4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ba:	013d09bb          	addw	s3,s10,s3
    800031be:	012d093b          	addw	s2,s10,s2
    800031c2:	9a6e                	add	s4,s4,s11
    800031c4:	0569f663          	bgeu	s3,s6,80003210 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800031c8:	00a9559b          	srliw	a1,s2,0xa
    800031cc:	8556                	mv	a0,s5
    800031ce:	fffff097          	auipc	ra,0xfffff
    800031d2:	7a0080e7          	jalr	1952(ra) # 8000296e <bmap>
    800031d6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031da:	c99d                	beqz	a1,80003210 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031dc:	000aa503          	lw	a0,0(s5)
    800031e0:	fffff097          	auipc	ra,0xfffff
    800031e4:	394080e7          	jalr	916(ra) # 80002574 <bread>
    800031e8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031ea:	3ff97513          	andi	a0,s2,1023
    800031ee:	40ac87bb          	subw	a5,s9,a0
    800031f2:	413b073b          	subw	a4,s6,s3
    800031f6:	8d3e                	mv	s10,a5
    800031f8:	2781                	sext.w	a5,a5
    800031fa:	0007069b          	sext.w	a3,a4
    800031fe:	f8f6f4e3          	bgeu	a3,a5,80003186 <writei+0x4c>
    80003202:	8d3a                	mv	s10,a4
    80003204:	b749                	j	80003186 <writei+0x4c>
      brelse(bp);
    80003206:	8526                	mv	a0,s1
    80003208:	fffff097          	auipc	ra,0xfffff
    8000320c:	49c080e7          	jalr	1180(ra) # 800026a4 <brelse>
  }

  if(off > ip->size)
    80003210:	04caa783          	lw	a5,76(s5)
    80003214:	0127f463          	bgeu	a5,s2,8000321c <writei+0xe2>
    ip->size = off;
    80003218:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000321c:	8556                	mv	a0,s5
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	aa6080e7          	jalr	-1370(ra) # 80002cc4 <iupdate>

  return tot;
    80003226:	0009851b          	sext.w	a0,s3
}
    8000322a:	70a6                	ld	ra,104(sp)
    8000322c:	7406                	ld	s0,96(sp)
    8000322e:	64e6                	ld	s1,88(sp)
    80003230:	6946                	ld	s2,80(sp)
    80003232:	69a6                	ld	s3,72(sp)
    80003234:	6a06                	ld	s4,64(sp)
    80003236:	7ae2                	ld	s5,56(sp)
    80003238:	7b42                	ld	s6,48(sp)
    8000323a:	7ba2                	ld	s7,40(sp)
    8000323c:	7c02                	ld	s8,32(sp)
    8000323e:	6ce2                	ld	s9,24(sp)
    80003240:	6d42                	ld	s10,16(sp)
    80003242:	6da2                	ld	s11,8(sp)
    80003244:	6165                	addi	sp,sp,112
    80003246:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003248:	89da                	mv	s3,s6
    8000324a:	bfc9                	j	8000321c <writei+0xe2>
    return -1;
    8000324c:	557d                	li	a0,-1
}
    8000324e:	8082                	ret
    return -1;
    80003250:	557d                	li	a0,-1
    80003252:	bfe1                	j	8000322a <writei+0xf0>
    return -1;
    80003254:	557d                	li	a0,-1
    80003256:	bfd1                	j	8000322a <writei+0xf0>

0000000080003258 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003258:	1141                	addi	sp,sp,-16
    8000325a:	e406                	sd	ra,8(sp)
    8000325c:	e022                	sd	s0,0(sp)
    8000325e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003260:	4639                	li	a2,14
    80003262:	ffffd097          	auipc	ra,0xffffd
    80003266:	fe6080e7          	jalr	-26(ra) # 80000248 <strncmp>
}
    8000326a:	60a2                	ld	ra,8(sp)
    8000326c:	6402                	ld	s0,0(sp)
    8000326e:	0141                	addi	sp,sp,16
    80003270:	8082                	ret

0000000080003272 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003272:	7139                	addi	sp,sp,-64
    80003274:	fc06                	sd	ra,56(sp)
    80003276:	f822                	sd	s0,48(sp)
    80003278:	f426                	sd	s1,40(sp)
    8000327a:	f04a                	sd	s2,32(sp)
    8000327c:	ec4e                	sd	s3,24(sp)
    8000327e:	e852                	sd	s4,16(sp)
    80003280:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003282:	04451703          	lh	a4,68(a0)
    80003286:	4785                	li	a5,1
    80003288:	00f71a63          	bne	a4,a5,8000329c <dirlookup+0x2a>
    8000328c:	892a                	mv	s2,a0
    8000328e:	89ae                	mv	s3,a1
    80003290:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003292:	457c                	lw	a5,76(a0)
    80003294:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003296:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003298:	e79d                	bnez	a5,800032c6 <dirlookup+0x54>
    8000329a:	a8a5                	j	80003312 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000329c:	00005517          	auipc	a0,0x5
    800032a0:	35450513          	addi	a0,a0,852 # 800085f0 <syscalls+0x1e8>
    800032a4:	00003097          	auipc	ra,0x3
    800032a8:	bac080e7          	jalr	-1108(ra) # 80005e50 <panic>
      panic("dirlookup read");
    800032ac:	00005517          	auipc	a0,0x5
    800032b0:	35c50513          	addi	a0,a0,860 # 80008608 <syscalls+0x200>
    800032b4:	00003097          	auipc	ra,0x3
    800032b8:	b9c080e7          	jalr	-1124(ra) # 80005e50 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032bc:	24c1                	addiw	s1,s1,16
    800032be:	04c92783          	lw	a5,76(s2)
    800032c2:	04f4f763          	bgeu	s1,a5,80003310 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c6:	4741                	li	a4,16
    800032c8:	86a6                	mv	a3,s1
    800032ca:	fc040613          	addi	a2,s0,-64
    800032ce:	4581                	li	a1,0
    800032d0:	854a                	mv	a0,s2
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	d70080e7          	jalr	-656(ra) # 80003042 <readi>
    800032da:	47c1                	li	a5,16
    800032dc:	fcf518e3          	bne	a0,a5,800032ac <dirlookup+0x3a>
    if(de.inum == 0)
    800032e0:	fc045783          	lhu	a5,-64(s0)
    800032e4:	dfe1                	beqz	a5,800032bc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032e6:	fc240593          	addi	a1,s0,-62
    800032ea:	854e                	mv	a0,s3
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	f6c080e7          	jalr	-148(ra) # 80003258 <namecmp>
    800032f4:	f561                	bnez	a0,800032bc <dirlookup+0x4a>
      if(poff)
    800032f6:	000a0463          	beqz	s4,800032fe <dirlookup+0x8c>
        *poff = off;
    800032fa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032fe:	fc045583          	lhu	a1,-64(s0)
    80003302:	00092503          	lw	a0,0(s2)
    80003306:	fffff097          	auipc	ra,0xfffff
    8000330a:	750080e7          	jalr	1872(ra) # 80002a56 <iget>
    8000330e:	a011                	j	80003312 <dirlookup+0xa0>
  return 0;
    80003310:	4501                	li	a0,0
}
    80003312:	70e2                	ld	ra,56(sp)
    80003314:	7442                	ld	s0,48(sp)
    80003316:	74a2                	ld	s1,40(sp)
    80003318:	7902                	ld	s2,32(sp)
    8000331a:	69e2                	ld	s3,24(sp)
    8000331c:	6a42                	ld	s4,16(sp)
    8000331e:	6121                	addi	sp,sp,64
    80003320:	8082                	ret

0000000080003322 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003322:	711d                	addi	sp,sp,-96
    80003324:	ec86                	sd	ra,88(sp)
    80003326:	e8a2                	sd	s0,80(sp)
    80003328:	e4a6                	sd	s1,72(sp)
    8000332a:	e0ca                	sd	s2,64(sp)
    8000332c:	fc4e                	sd	s3,56(sp)
    8000332e:	f852                	sd	s4,48(sp)
    80003330:	f456                	sd	s5,40(sp)
    80003332:	f05a                	sd	s6,32(sp)
    80003334:	ec5e                	sd	s7,24(sp)
    80003336:	e862                	sd	s8,16(sp)
    80003338:	e466                	sd	s9,8(sp)
    8000333a:	1080                	addi	s0,sp,96
    8000333c:	84aa                	mv	s1,a0
    8000333e:	8aae                	mv	s5,a1
    80003340:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003342:	00054703          	lbu	a4,0(a0)
    80003346:	02f00793          	li	a5,47
    8000334a:	02f70363          	beq	a4,a5,80003370 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000334e:	ffffe097          	auipc	ra,0xffffe
    80003352:	bfa080e7          	jalr	-1030(ra) # 80000f48 <myproc>
    80003356:	15053503          	ld	a0,336(a0)
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	9f6080e7          	jalr	-1546(ra) # 80002d50 <idup>
    80003362:	89aa                	mv	s3,a0
  while(*path == '/')
    80003364:	02f00913          	li	s2,47
  len = path - s;
    80003368:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000336a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000336c:	4b85                	li	s7,1
    8000336e:	a865                	j	80003426 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003370:	4585                	li	a1,1
    80003372:	4505                	li	a0,1
    80003374:	fffff097          	auipc	ra,0xfffff
    80003378:	6e2080e7          	jalr	1762(ra) # 80002a56 <iget>
    8000337c:	89aa                	mv	s3,a0
    8000337e:	b7dd                	j	80003364 <namex+0x42>
      iunlockput(ip);
    80003380:	854e                	mv	a0,s3
    80003382:	00000097          	auipc	ra,0x0
    80003386:	c6e080e7          	jalr	-914(ra) # 80002ff0 <iunlockput>
      return 0;
    8000338a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000338c:	854e                	mv	a0,s3
    8000338e:	60e6                	ld	ra,88(sp)
    80003390:	6446                	ld	s0,80(sp)
    80003392:	64a6                	ld	s1,72(sp)
    80003394:	6906                	ld	s2,64(sp)
    80003396:	79e2                	ld	s3,56(sp)
    80003398:	7a42                	ld	s4,48(sp)
    8000339a:	7aa2                	ld	s5,40(sp)
    8000339c:	7b02                	ld	s6,32(sp)
    8000339e:	6be2                	ld	s7,24(sp)
    800033a0:	6c42                	ld	s8,16(sp)
    800033a2:	6ca2                	ld	s9,8(sp)
    800033a4:	6125                	addi	sp,sp,96
    800033a6:	8082                	ret
      iunlock(ip);
    800033a8:	854e                	mv	a0,s3
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	aa6080e7          	jalr	-1370(ra) # 80002e50 <iunlock>
      return ip;
    800033b2:	bfe9                	j	8000338c <namex+0x6a>
      iunlockput(ip);
    800033b4:	854e                	mv	a0,s3
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	c3a080e7          	jalr	-966(ra) # 80002ff0 <iunlockput>
      return 0;
    800033be:	89e6                	mv	s3,s9
    800033c0:	b7f1                	j	8000338c <namex+0x6a>
  len = path - s;
    800033c2:	40b48633          	sub	a2,s1,a1
    800033c6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800033ca:	099c5463          	bge	s8,s9,80003452 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033ce:	4639                	li	a2,14
    800033d0:	8552                	mv	a0,s4
    800033d2:	ffffd097          	auipc	ra,0xffffd
    800033d6:	e02080e7          	jalr	-510(ra) # 800001d4 <memmove>
  while(*path == '/')
    800033da:	0004c783          	lbu	a5,0(s1)
    800033de:	01279763          	bne	a5,s2,800033ec <namex+0xca>
    path++;
    800033e2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033e4:	0004c783          	lbu	a5,0(s1)
    800033e8:	ff278de3          	beq	a5,s2,800033e2 <namex+0xc0>
    ilock(ip);
    800033ec:	854e                	mv	a0,s3
    800033ee:	00000097          	auipc	ra,0x0
    800033f2:	9a0080e7          	jalr	-1632(ra) # 80002d8e <ilock>
    if(ip->type != T_DIR){
    800033f6:	04499783          	lh	a5,68(s3)
    800033fa:	f97793e3          	bne	a5,s7,80003380 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033fe:	000a8563          	beqz	s5,80003408 <namex+0xe6>
    80003402:	0004c783          	lbu	a5,0(s1)
    80003406:	d3cd                	beqz	a5,800033a8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003408:	865a                	mv	a2,s6
    8000340a:	85d2                	mv	a1,s4
    8000340c:	854e                	mv	a0,s3
    8000340e:	00000097          	auipc	ra,0x0
    80003412:	e64080e7          	jalr	-412(ra) # 80003272 <dirlookup>
    80003416:	8caa                	mv	s9,a0
    80003418:	dd51                	beqz	a0,800033b4 <namex+0x92>
    iunlockput(ip);
    8000341a:	854e                	mv	a0,s3
    8000341c:	00000097          	auipc	ra,0x0
    80003420:	bd4080e7          	jalr	-1068(ra) # 80002ff0 <iunlockput>
    ip = next;
    80003424:	89e6                	mv	s3,s9
  while(*path == '/')
    80003426:	0004c783          	lbu	a5,0(s1)
    8000342a:	05279763          	bne	a5,s2,80003478 <namex+0x156>
    path++;
    8000342e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003430:	0004c783          	lbu	a5,0(s1)
    80003434:	ff278de3          	beq	a5,s2,8000342e <namex+0x10c>
  if(*path == 0)
    80003438:	c79d                	beqz	a5,80003466 <namex+0x144>
    path++;
    8000343a:	85a6                	mv	a1,s1
  len = path - s;
    8000343c:	8cda                	mv	s9,s6
    8000343e:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003440:	01278963          	beq	a5,s2,80003452 <namex+0x130>
    80003444:	dfbd                	beqz	a5,800033c2 <namex+0xa0>
    path++;
    80003446:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003448:	0004c783          	lbu	a5,0(s1)
    8000344c:	ff279ce3          	bne	a5,s2,80003444 <namex+0x122>
    80003450:	bf8d                	j	800033c2 <namex+0xa0>
    memmove(name, s, len);
    80003452:	2601                	sext.w	a2,a2
    80003454:	8552                	mv	a0,s4
    80003456:	ffffd097          	auipc	ra,0xffffd
    8000345a:	d7e080e7          	jalr	-642(ra) # 800001d4 <memmove>
    name[len] = 0;
    8000345e:	9cd2                	add	s9,s9,s4
    80003460:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003464:	bf9d                	j	800033da <namex+0xb8>
  if(nameiparent){
    80003466:	f20a83e3          	beqz	s5,8000338c <namex+0x6a>
    iput(ip);
    8000346a:	854e                	mv	a0,s3
    8000346c:	00000097          	auipc	ra,0x0
    80003470:	adc080e7          	jalr	-1316(ra) # 80002f48 <iput>
    return 0;
    80003474:	4981                	li	s3,0
    80003476:	bf19                	j	8000338c <namex+0x6a>
  if(*path == 0)
    80003478:	d7fd                	beqz	a5,80003466 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000347a:	0004c783          	lbu	a5,0(s1)
    8000347e:	85a6                	mv	a1,s1
    80003480:	b7d1                	j	80003444 <namex+0x122>

0000000080003482 <dirlink>:
{
    80003482:	7139                	addi	sp,sp,-64
    80003484:	fc06                	sd	ra,56(sp)
    80003486:	f822                	sd	s0,48(sp)
    80003488:	f426                	sd	s1,40(sp)
    8000348a:	f04a                	sd	s2,32(sp)
    8000348c:	ec4e                	sd	s3,24(sp)
    8000348e:	e852                	sd	s4,16(sp)
    80003490:	0080                	addi	s0,sp,64
    80003492:	892a                	mv	s2,a0
    80003494:	8a2e                	mv	s4,a1
    80003496:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003498:	4601                	li	a2,0
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	dd8080e7          	jalr	-552(ra) # 80003272 <dirlookup>
    800034a2:	e93d                	bnez	a0,80003518 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034a4:	04c92483          	lw	s1,76(s2)
    800034a8:	c49d                	beqz	s1,800034d6 <dirlink+0x54>
    800034aa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034ac:	4741                	li	a4,16
    800034ae:	86a6                	mv	a3,s1
    800034b0:	fc040613          	addi	a2,s0,-64
    800034b4:	4581                	li	a1,0
    800034b6:	854a                	mv	a0,s2
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	b8a080e7          	jalr	-1142(ra) # 80003042 <readi>
    800034c0:	47c1                	li	a5,16
    800034c2:	06f51163          	bne	a0,a5,80003524 <dirlink+0xa2>
    if(de.inum == 0)
    800034c6:	fc045783          	lhu	a5,-64(s0)
    800034ca:	c791                	beqz	a5,800034d6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034cc:	24c1                	addiw	s1,s1,16
    800034ce:	04c92783          	lw	a5,76(s2)
    800034d2:	fcf4ede3          	bltu	s1,a5,800034ac <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034d6:	4639                	li	a2,14
    800034d8:	85d2                	mv	a1,s4
    800034da:	fc240513          	addi	a0,s0,-62
    800034de:	ffffd097          	auipc	ra,0xffffd
    800034e2:	da6080e7          	jalr	-602(ra) # 80000284 <strncpy>
  de.inum = inum;
    800034e6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034ea:	4741                	li	a4,16
    800034ec:	86a6                	mv	a3,s1
    800034ee:	fc040613          	addi	a2,s0,-64
    800034f2:	4581                	li	a1,0
    800034f4:	854a                	mv	a0,s2
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	c44080e7          	jalr	-956(ra) # 8000313a <writei>
    800034fe:	1541                	addi	a0,a0,-16
    80003500:	00a03533          	snez	a0,a0
    80003504:	40a00533          	neg	a0,a0
}
    80003508:	70e2                	ld	ra,56(sp)
    8000350a:	7442                	ld	s0,48(sp)
    8000350c:	74a2                	ld	s1,40(sp)
    8000350e:	7902                	ld	s2,32(sp)
    80003510:	69e2                	ld	s3,24(sp)
    80003512:	6a42                	ld	s4,16(sp)
    80003514:	6121                	addi	sp,sp,64
    80003516:	8082                	ret
    iput(ip);
    80003518:	00000097          	auipc	ra,0x0
    8000351c:	a30080e7          	jalr	-1488(ra) # 80002f48 <iput>
    return -1;
    80003520:	557d                	li	a0,-1
    80003522:	b7dd                	j	80003508 <dirlink+0x86>
      panic("dirlink read");
    80003524:	00005517          	auipc	a0,0x5
    80003528:	0f450513          	addi	a0,a0,244 # 80008618 <syscalls+0x210>
    8000352c:	00003097          	auipc	ra,0x3
    80003530:	924080e7          	jalr	-1756(ra) # 80005e50 <panic>

0000000080003534 <namei>:

struct inode*
namei(char *path)
{
    80003534:	1101                	addi	sp,sp,-32
    80003536:	ec06                	sd	ra,24(sp)
    80003538:	e822                	sd	s0,16(sp)
    8000353a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000353c:	fe040613          	addi	a2,s0,-32
    80003540:	4581                	li	a1,0
    80003542:	00000097          	auipc	ra,0x0
    80003546:	de0080e7          	jalr	-544(ra) # 80003322 <namex>
}
    8000354a:	60e2                	ld	ra,24(sp)
    8000354c:	6442                	ld	s0,16(sp)
    8000354e:	6105                	addi	sp,sp,32
    80003550:	8082                	ret

0000000080003552 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003552:	1141                	addi	sp,sp,-16
    80003554:	e406                	sd	ra,8(sp)
    80003556:	e022                	sd	s0,0(sp)
    80003558:	0800                	addi	s0,sp,16
    8000355a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000355c:	4585                	li	a1,1
    8000355e:	00000097          	auipc	ra,0x0
    80003562:	dc4080e7          	jalr	-572(ra) # 80003322 <namex>
}
    80003566:	60a2                	ld	ra,8(sp)
    80003568:	6402                	ld	s0,0(sp)
    8000356a:	0141                	addi	sp,sp,16
    8000356c:	8082                	ret

000000008000356e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000356e:	1101                	addi	sp,sp,-32
    80003570:	ec06                	sd	ra,24(sp)
    80003572:	e822                	sd	s0,16(sp)
    80003574:	e426                	sd	s1,8(sp)
    80003576:	e04a                	sd	s2,0(sp)
    80003578:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000357a:	00015917          	auipc	s2,0x15
    8000357e:	5d690913          	addi	s2,s2,1494 # 80018b50 <log>
    80003582:	01892583          	lw	a1,24(s2)
    80003586:	02892503          	lw	a0,40(s2)
    8000358a:	fffff097          	auipc	ra,0xfffff
    8000358e:	fea080e7          	jalr	-22(ra) # 80002574 <bread>
    80003592:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003594:	02c92683          	lw	a3,44(s2)
    80003598:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000359a:	02d05763          	blez	a3,800035c8 <write_head+0x5a>
    8000359e:	00015797          	auipc	a5,0x15
    800035a2:	5e278793          	addi	a5,a5,1506 # 80018b80 <log+0x30>
    800035a6:	05c50713          	addi	a4,a0,92
    800035aa:	36fd                	addiw	a3,a3,-1
    800035ac:	1682                	slli	a3,a3,0x20
    800035ae:	9281                	srli	a3,a3,0x20
    800035b0:	068a                	slli	a3,a3,0x2
    800035b2:	00015617          	auipc	a2,0x15
    800035b6:	5d260613          	addi	a2,a2,1490 # 80018b84 <log+0x34>
    800035ba:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035bc:	4390                	lw	a2,0(a5)
    800035be:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035c0:	0791                	addi	a5,a5,4
    800035c2:	0711                	addi	a4,a4,4
    800035c4:	fed79ce3          	bne	a5,a3,800035bc <write_head+0x4e>
  }
  bwrite(buf);
    800035c8:	8526                	mv	a0,s1
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	09c080e7          	jalr	156(ra) # 80002666 <bwrite>
  brelse(buf);
    800035d2:	8526                	mv	a0,s1
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	0d0080e7          	jalr	208(ra) # 800026a4 <brelse>
}
    800035dc:	60e2                	ld	ra,24(sp)
    800035de:	6442                	ld	s0,16(sp)
    800035e0:	64a2                	ld	s1,8(sp)
    800035e2:	6902                	ld	s2,0(sp)
    800035e4:	6105                	addi	sp,sp,32
    800035e6:	8082                	ret

00000000800035e8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e8:	00015797          	auipc	a5,0x15
    800035ec:	5947a783          	lw	a5,1428(a5) # 80018b7c <log+0x2c>
    800035f0:	0af05d63          	blez	a5,800036aa <install_trans+0xc2>
{
    800035f4:	7139                	addi	sp,sp,-64
    800035f6:	fc06                	sd	ra,56(sp)
    800035f8:	f822                	sd	s0,48(sp)
    800035fa:	f426                	sd	s1,40(sp)
    800035fc:	f04a                	sd	s2,32(sp)
    800035fe:	ec4e                	sd	s3,24(sp)
    80003600:	e852                	sd	s4,16(sp)
    80003602:	e456                	sd	s5,8(sp)
    80003604:	e05a                	sd	s6,0(sp)
    80003606:	0080                	addi	s0,sp,64
    80003608:	8b2a                	mv	s6,a0
    8000360a:	00015a97          	auipc	s5,0x15
    8000360e:	576a8a93          	addi	s5,s5,1398 # 80018b80 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003612:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003614:	00015997          	auipc	s3,0x15
    80003618:	53c98993          	addi	s3,s3,1340 # 80018b50 <log>
    8000361c:	a00d                	j	8000363e <install_trans+0x56>
    brelse(lbuf);
    8000361e:	854a                	mv	a0,s2
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	084080e7          	jalr	132(ra) # 800026a4 <brelse>
    brelse(dbuf);
    80003628:	8526                	mv	a0,s1
    8000362a:	fffff097          	auipc	ra,0xfffff
    8000362e:	07a080e7          	jalr	122(ra) # 800026a4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003632:	2a05                	addiw	s4,s4,1
    80003634:	0a91                	addi	s5,s5,4
    80003636:	02c9a783          	lw	a5,44(s3)
    8000363a:	04fa5e63          	bge	s4,a5,80003696 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000363e:	0189a583          	lw	a1,24(s3)
    80003642:	014585bb          	addw	a1,a1,s4
    80003646:	2585                	addiw	a1,a1,1
    80003648:	0289a503          	lw	a0,40(s3)
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	f28080e7          	jalr	-216(ra) # 80002574 <bread>
    80003654:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003656:	000aa583          	lw	a1,0(s5)
    8000365a:	0289a503          	lw	a0,40(s3)
    8000365e:	fffff097          	auipc	ra,0xfffff
    80003662:	f16080e7          	jalr	-234(ra) # 80002574 <bread>
    80003666:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003668:	40000613          	li	a2,1024
    8000366c:	05890593          	addi	a1,s2,88
    80003670:	05850513          	addi	a0,a0,88
    80003674:	ffffd097          	auipc	ra,0xffffd
    80003678:	b60080e7          	jalr	-1184(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000367c:	8526                	mv	a0,s1
    8000367e:	fffff097          	auipc	ra,0xfffff
    80003682:	fe8080e7          	jalr	-24(ra) # 80002666 <bwrite>
    if(recovering == 0)
    80003686:	f80b1ce3          	bnez	s6,8000361e <install_trans+0x36>
      bunpin(dbuf);
    8000368a:	8526                	mv	a0,s1
    8000368c:	fffff097          	auipc	ra,0xfffff
    80003690:	0f2080e7          	jalr	242(ra) # 8000277e <bunpin>
    80003694:	b769                	j	8000361e <install_trans+0x36>
}
    80003696:	70e2                	ld	ra,56(sp)
    80003698:	7442                	ld	s0,48(sp)
    8000369a:	74a2                	ld	s1,40(sp)
    8000369c:	7902                	ld	s2,32(sp)
    8000369e:	69e2                	ld	s3,24(sp)
    800036a0:	6a42                	ld	s4,16(sp)
    800036a2:	6aa2                	ld	s5,8(sp)
    800036a4:	6b02                	ld	s6,0(sp)
    800036a6:	6121                	addi	sp,sp,64
    800036a8:	8082                	ret
    800036aa:	8082                	ret

00000000800036ac <initlog>:
{
    800036ac:	7179                	addi	sp,sp,-48
    800036ae:	f406                	sd	ra,40(sp)
    800036b0:	f022                	sd	s0,32(sp)
    800036b2:	ec26                	sd	s1,24(sp)
    800036b4:	e84a                	sd	s2,16(sp)
    800036b6:	e44e                	sd	s3,8(sp)
    800036b8:	1800                	addi	s0,sp,48
    800036ba:	892a                	mv	s2,a0
    800036bc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036be:	00015497          	auipc	s1,0x15
    800036c2:	49248493          	addi	s1,s1,1170 # 80018b50 <log>
    800036c6:	00005597          	auipc	a1,0x5
    800036ca:	f6258593          	addi	a1,a1,-158 # 80008628 <syscalls+0x220>
    800036ce:	8526                	mv	a0,s1
    800036d0:	00003097          	auipc	ra,0x3
    800036d4:	c2c080e7          	jalr	-980(ra) # 800062fc <initlock>
  log.start = sb->logstart;
    800036d8:	0149a583          	lw	a1,20(s3)
    800036dc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036de:	0109a783          	lw	a5,16(s3)
    800036e2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036e4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036e8:	854a                	mv	a0,s2
    800036ea:	fffff097          	auipc	ra,0xfffff
    800036ee:	e8a080e7          	jalr	-374(ra) # 80002574 <bread>
  log.lh.n = lh->n;
    800036f2:	4d34                	lw	a3,88(a0)
    800036f4:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036f6:	02d05563          	blez	a3,80003720 <initlog+0x74>
    800036fa:	05c50793          	addi	a5,a0,92
    800036fe:	00015717          	auipc	a4,0x15
    80003702:	48270713          	addi	a4,a4,1154 # 80018b80 <log+0x30>
    80003706:	36fd                	addiw	a3,a3,-1
    80003708:	1682                	slli	a3,a3,0x20
    8000370a:	9281                	srli	a3,a3,0x20
    8000370c:	068a                	slli	a3,a3,0x2
    8000370e:	06050613          	addi	a2,a0,96
    80003712:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003714:	4390                	lw	a2,0(a5)
    80003716:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003718:	0791                	addi	a5,a5,4
    8000371a:	0711                	addi	a4,a4,4
    8000371c:	fed79ce3          	bne	a5,a3,80003714 <initlog+0x68>
  brelse(buf);
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	f84080e7          	jalr	-124(ra) # 800026a4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003728:	4505                	li	a0,1
    8000372a:	00000097          	auipc	ra,0x0
    8000372e:	ebe080e7          	jalr	-322(ra) # 800035e8 <install_trans>
  log.lh.n = 0;
    80003732:	00015797          	auipc	a5,0x15
    80003736:	4407a523          	sw	zero,1098(a5) # 80018b7c <log+0x2c>
  write_head(); // clear the log
    8000373a:	00000097          	auipc	ra,0x0
    8000373e:	e34080e7          	jalr	-460(ra) # 8000356e <write_head>
}
    80003742:	70a2                	ld	ra,40(sp)
    80003744:	7402                	ld	s0,32(sp)
    80003746:	64e2                	ld	s1,24(sp)
    80003748:	6942                	ld	s2,16(sp)
    8000374a:	69a2                	ld	s3,8(sp)
    8000374c:	6145                	addi	sp,sp,48
    8000374e:	8082                	ret

0000000080003750 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003750:	1101                	addi	sp,sp,-32
    80003752:	ec06                	sd	ra,24(sp)
    80003754:	e822                	sd	s0,16(sp)
    80003756:	e426                	sd	s1,8(sp)
    80003758:	e04a                	sd	s2,0(sp)
    8000375a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000375c:	00015517          	auipc	a0,0x15
    80003760:	3f450513          	addi	a0,a0,1012 # 80018b50 <log>
    80003764:	00003097          	auipc	ra,0x3
    80003768:	c28080e7          	jalr	-984(ra) # 8000638c <acquire>
  while(1){
    if(log.committing){
    8000376c:	00015497          	auipc	s1,0x15
    80003770:	3e448493          	addi	s1,s1,996 # 80018b50 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003774:	4979                	li	s2,30
    80003776:	a039                	j	80003784 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003778:	85a6                	mv	a1,s1
    8000377a:	8526                	mv	a0,s1
    8000377c:	ffffe097          	auipc	ra,0xffffe
    80003780:	f50080e7          	jalr	-176(ra) # 800016cc <sleep>
    if(log.committing){
    80003784:	50dc                	lw	a5,36(s1)
    80003786:	fbed                	bnez	a5,80003778 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003788:	509c                	lw	a5,32(s1)
    8000378a:	0017871b          	addiw	a4,a5,1
    8000378e:	0007069b          	sext.w	a3,a4
    80003792:	0027179b          	slliw	a5,a4,0x2
    80003796:	9fb9                	addw	a5,a5,a4
    80003798:	0017979b          	slliw	a5,a5,0x1
    8000379c:	54d8                	lw	a4,44(s1)
    8000379e:	9fb9                	addw	a5,a5,a4
    800037a0:	00f95963          	bge	s2,a5,800037b2 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037a4:	85a6                	mv	a1,s1
    800037a6:	8526                	mv	a0,s1
    800037a8:	ffffe097          	auipc	ra,0xffffe
    800037ac:	f24080e7          	jalr	-220(ra) # 800016cc <sleep>
    800037b0:	bfd1                	j	80003784 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037b2:	00015517          	auipc	a0,0x15
    800037b6:	39e50513          	addi	a0,a0,926 # 80018b50 <log>
    800037ba:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037bc:	00003097          	auipc	ra,0x3
    800037c0:	c84080e7          	jalr	-892(ra) # 80006440 <release>
      break;
    }
  }
}
    800037c4:	60e2                	ld	ra,24(sp)
    800037c6:	6442                	ld	s0,16(sp)
    800037c8:	64a2                	ld	s1,8(sp)
    800037ca:	6902                	ld	s2,0(sp)
    800037cc:	6105                	addi	sp,sp,32
    800037ce:	8082                	ret

00000000800037d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037d0:	7139                	addi	sp,sp,-64
    800037d2:	fc06                	sd	ra,56(sp)
    800037d4:	f822                	sd	s0,48(sp)
    800037d6:	f426                	sd	s1,40(sp)
    800037d8:	f04a                	sd	s2,32(sp)
    800037da:	ec4e                	sd	s3,24(sp)
    800037dc:	e852                	sd	s4,16(sp)
    800037de:	e456                	sd	s5,8(sp)
    800037e0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037e2:	00015497          	auipc	s1,0x15
    800037e6:	36e48493          	addi	s1,s1,878 # 80018b50 <log>
    800037ea:	8526                	mv	a0,s1
    800037ec:	00003097          	auipc	ra,0x3
    800037f0:	ba0080e7          	jalr	-1120(ra) # 8000638c <acquire>
  log.outstanding -= 1;
    800037f4:	509c                	lw	a5,32(s1)
    800037f6:	37fd                	addiw	a5,a5,-1
    800037f8:	0007891b          	sext.w	s2,a5
    800037fc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037fe:	50dc                	lw	a5,36(s1)
    80003800:	e7b9                	bnez	a5,8000384e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003802:	04091e63          	bnez	s2,8000385e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003806:	00015497          	auipc	s1,0x15
    8000380a:	34a48493          	addi	s1,s1,842 # 80018b50 <log>
    8000380e:	4785                	li	a5,1
    80003810:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003812:	8526                	mv	a0,s1
    80003814:	00003097          	auipc	ra,0x3
    80003818:	c2c080e7          	jalr	-980(ra) # 80006440 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000381c:	54dc                	lw	a5,44(s1)
    8000381e:	06f04763          	bgtz	a5,8000388c <end_op+0xbc>
    acquire(&log.lock);
    80003822:	00015497          	auipc	s1,0x15
    80003826:	32e48493          	addi	s1,s1,814 # 80018b50 <log>
    8000382a:	8526                	mv	a0,s1
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	b60080e7          	jalr	-1184(ra) # 8000638c <acquire>
    log.committing = 0;
    80003834:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003838:	8526                	mv	a0,s1
    8000383a:	ffffe097          	auipc	ra,0xffffe
    8000383e:	ef6080e7          	jalr	-266(ra) # 80001730 <wakeup>
    release(&log.lock);
    80003842:	8526                	mv	a0,s1
    80003844:	00003097          	auipc	ra,0x3
    80003848:	bfc080e7          	jalr	-1028(ra) # 80006440 <release>
}
    8000384c:	a03d                	j	8000387a <end_op+0xaa>
    panic("log.committing");
    8000384e:	00005517          	auipc	a0,0x5
    80003852:	de250513          	addi	a0,a0,-542 # 80008630 <syscalls+0x228>
    80003856:	00002097          	auipc	ra,0x2
    8000385a:	5fa080e7          	jalr	1530(ra) # 80005e50 <panic>
    wakeup(&log);
    8000385e:	00015497          	auipc	s1,0x15
    80003862:	2f248493          	addi	s1,s1,754 # 80018b50 <log>
    80003866:	8526                	mv	a0,s1
    80003868:	ffffe097          	auipc	ra,0xffffe
    8000386c:	ec8080e7          	jalr	-312(ra) # 80001730 <wakeup>
  release(&log.lock);
    80003870:	8526                	mv	a0,s1
    80003872:	00003097          	auipc	ra,0x3
    80003876:	bce080e7          	jalr	-1074(ra) # 80006440 <release>
}
    8000387a:	70e2                	ld	ra,56(sp)
    8000387c:	7442                	ld	s0,48(sp)
    8000387e:	74a2                	ld	s1,40(sp)
    80003880:	7902                	ld	s2,32(sp)
    80003882:	69e2                	ld	s3,24(sp)
    80003884:	6a42                	ld	s4,16(sp)
    80003886:	6aa2                	ld	s5,8(sp)
    80003888:	6121                	addi	sp,sp,64
    8000388a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000388c:	00015a97          	auipc	s5,0x15
    80003890:	2f4a8a93          	addi	s5,s5,756 # 80018b80 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003894:	00015a17          	auipc	s4,0x15
    80003898:	2bca0a13          	addi	s4,s4,700 # 80018b50 <log>
    8000389c:	018a2583          	lw	a1,24(s4)
    800038a0:	012585bb          	addw	a1,a1,s2
    800038a4:	2585                	addiw	a1,a1,1
    800038a6:	028a2503          	lw	a0,40(s4)
    800038aa:	fffff097          	auipc	ra,0xfffff
    800038ae:	cca080e7          	jalr	-822(ra) # 80002574 <bread>
    800038b2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038b4:	000aa583          	lw	a1,0(s5)
    800038b8:	028a2503          	lw	a0,40(s4)
    800038bc:	fffff097          	auipc	ra,0xfffff
    800038c0:	cb8080e7          	jalr	-840(ra) # 80002574 <bread>
    800038c4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038c6:	40000613          	li	a2,1024
    800038ca:	05850593          	addi	a1,a0,88
    800038ce:	05848513          	addi	a0,s1,88
    800038d2:	ffffd097          	auipc	ra,0xffffd
    800038d6:	902080e7          	jalr	-1790(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    800038da:	8526                	mv	a0,s1
    800038dc:	fffff097          	auipc	ra,0xfffff
    800038e0:	d8a080e7          	jalr	-630(ra) # 80002666 <bwrite>
    brelse(from);
    800038e4:	854e                	mv	a0,s3
    800038e6:	fffff097          	auipc	ra,0xfffff
    800038ea:	dbe080e7          	jalr	-578(ra) # 800026a4 <brelse>
    brelse(to);
    800038ee:	8526                	mv	a0,s1
    800038f0:	fffff097          	auipc	ra,0xfffff
    800038f4:	db4080e7          	jalr	-588(ra) # 800026a4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038f8:	2905                	addiw	s2,s2,1
    800038fa:	0a91                	addi	s5,s5,4
    800038fc:	02ca2783          	lw	a5,44(s4)
    80003900:	f8f94ee3          	blt	s2,a5,8000389c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003904:	00000097          	auipc	ra,0x0
    80003908:	c6a080e7          	jalr	-918(ra) # 8000356e <write_head>
    install_trans(0); // Now install writes to home locations
    8000390c:	4501                	li	a0,0
    8000390e:	00000097          	auipc	ra,0x0
    80003912:	cda080e7          	jalr	-806(ra) # 800035e8 <install_trans>
    log.lh.n = 0;
    80003916:	00015797          	auipc	a5,0x15
    8000391a:	2607a323          	sw	zero,614(a5) # 80018b7c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000391e:	00000097          	auipc	ra,0x0
    80003922:	c50080e7          	jalr	-944(ra) # 8000356e <write_head>
    80003926:	bdf5                	j	80003822 <end_op+0x52>

0000000080003928 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003928:	1101                	addi	sp,sp,-32
    8000392a:	ec06                	sd	ra,24(sp)
    8000392c:	e822                	sd	s0,16(sp)
    8000392e:	e426                	sd	s1,8(sp)
    80003930:	e04a                	sd	s2,0(sp)
    80003932:	1000                	addi	s0,sp,32
    80003934:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003936:	00015917          	auipc	s2,0x15
    8000393a:	21a90913          	addi	s2,s2,538 # 80018b50 <log>
    8000393e:	854a                	mv	a0,s2
    80003940:	00003097          	auipc	ra,0x3
    80003944:	a4c080e7          	jalr	-1460(ra) # 8000638c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003948:	02c92603          	lw	a2,44(s2)
    8000394c:	47f5                	li	a5,29
    8000394e:	06c7c563          	blt	a5,a2,800039b8 <log_write+0x90>
    80003952:	00015797          	auipc	a5,0x15
    80003956:	21a7a783          	lw	a5,538(a5) # 80018b6c <log+0x1c>
    8000395a:	37fd                	addiw	a5,a5,-1
    8000395c:	04f65e63          	bge	a2,a5,800039b8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003960:	00015797          	auipc	a5,0x15
    80003964:	2107a783          	lw	a5,528(a5) # 80018b70 <log+0x20>
    80003968:	06f05063          	blez	a5,800039c8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000396c:	4781                	li	a5,0
    8000396e:	06c05563          	blez	a2,800039d8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003972:	44cc                	lw	a1,12(s1)
    80003974:	00015717          	auipc	a4,0x15
    80003978:	20c70713          	addi	a4,a4,524 # 80018b80 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000397c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000397e:	4314                	lw	a3,0(a4)
    80003980:	04b68c63          	beq	a3,a1,800039d8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003984:	2785                	addiw	a5,a5,1
    80003986:	0711                	addi	a4,a4,4
    80003988:	fef61be3          	bne	a2,a5,8000397e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000398c:	0621                	addi	a2,a2,8
    8000398e:	060a                	slli	a2,a2,0x2
    80003990:	00015797          	auipc	a5,0x15
    80003994:	1c078793          	addi	a5,a5,448 # 80018b50 <log>
    80003998:	963e                	add	a2,a2,a5
    8000399a:	44dc                	lw	a5,12(s1)
    8000399c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000399e:	8526                	mv	a0,s1
    800039a0:	fffff097          	auipc	ra,0xfffff
    800039a4:	da2080e7          	jalr	-606(ra) # 80002742 <bpin>
    log.lh.n++;
    800039a8:	00015717          	auipc	a4,0x15
    800039ac:	1a870713          	addi	a4,a4,424 # 80018b50 <log>
    800039b0:	575c                	lw	a5,44(a4)
    800039b2:	2785                	addiw	a5,a5,1
    800039b4:	d75c                	sw	a5,44(a4)
    800039b6:	a835                	j	800039f2 <log_write+0xca>
    panic("too big a transaction");
    800039b8:	00005517          	auipc	a0,0x5
    800039bc:	c8850513          	addi	a0,a0,-888 # 80008640 <syscalls+0x238>
    800039c0:	00002097          	auipc	ra,0x2
    800039c4:	490080e7          	jalr	1168(ra) # 80005e50 <panic>
    panic("log_write outside of trans");
    800039c8:	00005517          	auipc	a0,0x5
    800039cc:	c9050513          	addi	a0,a0,-880 # 80008658 <syscalls+0x250>
    800039d0:	00002097          	auipc	ra,0x2
    800039d4:	480080e7          	jalr	1152(ra) # 80005e50 <panic>
  log.lh.block[i] = b->blockno;
    800039d8:	00878713          	addi	a4,a5,8
    800039dc:	00271693          	slli	a3,a4,0x2
    800039e0:	00015717          	auipc	a4,0x15
    800039e4:	17070713          	addi	a4,a4,368 # 80018b50 <log>
    800039e8:	9736                	add	a4,a4,a3
    800039ea:	44d4                	lw	a3,12(s1)
    800039ec:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039ee:	faf608e3          	beq	a2,a5,8000399e <log_write+0x76>
  }
  release(&log.lock);
    800039f2:	00015517          	auipc	a0,0x15
    800039f6:	15e50513          	addi	a0,a0,350 # 80018b50 <log>
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	a46080e7          	jalr	-1466(ra) # 80006440 <release>
}
    80003a02:	60e2                	ld	ra,24(sp)
    80003a04:	6442                	ld	s0,16(sp)
    80003a06:	64a2                	ld	s1,8(sp)
    80003a08:	6902                	ld	s2,0(sp)
    80003a0a:	6105                	addi	sp,sp,32
    80003a0c:	8082                	ret

0000000080003a0e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a0e:	1101                	addi	sp,sp,-32
    80003a10:	ec06                	sd	ra,24(sp)
    80003a12:	e822                	sd	s0,16(sp)
    80003a14:	e426                	sd	s1,8(sp)
    80003a16:	e04a                	sd	s2,0(sp)
    80003a18:	1000                	addi	s0,sp,32
    80003a1a:	84aa                	mv	s1,a0
    80003a1c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a1e:	00005597          	auipc	a1,0x5
    80003a22:	c5a58593          	addi	a1,a1,-934 # 80008678 <syscalls+0x270>
    80003a26:	0521                	addi	a0,a0,8
    80003a28:	00003097          	auipc	ra,0x3
    80003a2c:	8d4080e7          	jalr	-1836(ra) # 800062fc <initlock>
  lk->name = name;
    80003a30:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a34:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a38:	0204a423          	sw	zero,40(s1)
}
    80003a3c:	60e2                	ld	ra,24(sp)
    80003a3e:	6442                	ld	s0,16(sp)
    80003a40:	64a2                	ld	s1,8(sp)
    80003a42:	6902                	ld	s2,0(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	e04a                	sd	s2,0(sp)
    80003a52:	1000                	addi	s0,sp,32
    80003a54:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a56:	00850913          	addi	s2,a0,8
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	930080e7          	jalr	-1744(ra) # 8000638c <acquire>
  while (lk->locked) {
    80003a64:	409c                	lw	a5,0(s1)
    80003a66:	cb89                	beqz	a5,80003a78 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a68:	85ca                	mv	a1,s2
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	ffffe097          	auipc	ra,0xffffe
    80003a70:	c60080e7          	jalr	-928(ra) # 800016cc <sleep>
  while (lk->locked) {
    80003a74:	409c                	lw	a5,0(s1)
    80003a76:	fbed                	bnez	a5,80003a68 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a78:	4785                	li	a5,1
    80003a7a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	4cc080e7          	jalr	1228(ra) # 80000f48 <myproc>
    80003a84:	591c                	lw	a5,48(a0)
    80003a86:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a88:	854a                	mv	a0,s2
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	9b6080e7          	jalr	-1610(ra) # 80006440 <release>
}
    80003a92:	60e2                	ld	ra,24(sp)
    80003a94:	6442                	ld	s0,16(sp)
    80003a96:	64a2                	ld	s1,8(sp)
    80003a98:	6902                	ld	s2,0(sp)
    80003a9a:	6105                	addi	sp,sp,32
    80003a9c:	8082                	ret

0000000080003a9e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a9e:	1101                	addi	sp,sp,-32
    80003aa0:	ec06                	sd	ra,24(sp)
    80003aa2:	e822                	sd	s0,16(sp)
    80003aa4:	e426                	sd	s1,8(sp)
    80003aa6:	e04a                	sd	s2,0(sp)
    80003aa8:	1000                	addi	s0,sp,32
    80003aaa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003aac:	00850913          	addi	s2,a0,8
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00003097          	auipc	ra,0x3
    80003ab6:	8da080e7          	jalr	-1830(ra) # 8000638c <acquire>
  lk->locked = 0;
    80003aba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003abe:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ac2:	8526                	mv	a0,s1
    80003ac4:	ffffe097          	auipc	ra,0xffffe
    80003ac8:	c6c080e7          	jalr	-916(ra) # 80001730 <wakeup>
  release(&lk->lk);
    80003acc:	854a                	mv	a0,s2
    80003ace:	00003097          	auipc	ra,0x3
    80003ad2:	972080e7          	jalr	-1678(ra) # 80006440 <release>
}
    80003ad6:	60e2                	ld	ra,24(sp)
    80003ad8:	6442                	ld	s0,16(sp)
    80003ada:	64a2                	ld	s1,8(sp)
    80003adc:	6902                	ld	s2,0(sp)
    80003ade:	6105                	addi	sp,sp,32
    80003ae0:	8082                	ret

0000000080003ae2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ae2:	7179                	addi	sp,sp,-48
    80003ae4:	f406                	sd	ra,40(sp)
    80003ae6:	f022                	sd	s0,32(sp)
    80003ae8:	ec26                	sd	s1,24(sp)
    80003aea:	e84a                	sd	s2,16(sp)
    80003aec:	e44e                	sd	s3,8(sp)
    80003aee:	1800                	addi	s0,sp,48
    80003af0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003af2:	00850913          	addi	s2,a0,8
    80003af6:	854a                	mv	a0,s2
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	894080e7          	jalr	-1900(ra) # 8000638c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b00:	409c                	lw	a5,0(s1)
    80003b02:	ef99                	bnez	a5,80003b20 <holdingsleep+0x3e>
    80003b04:	4481                	li	s1,0
  release(&lk->lk);
    80003b06:	854a                	mv	a0,s2
    80003b08:	00003097          	auipc	ra,0x3
    80003b0c:	938080e7          	jalr	-1736(ra) # 80006440 <release>
  return r;
}
    80003b10:	8526                	mv	a0,s1
    80003b12:	70a2                	ld	ra,40(sp)
    80003b14:	7402                	ld	s0,32(sp)
    80003b16:	64e2                	ld	s1,24(sp)
    80003b18:	6942                	ld	s2,16(sp)
    80003b1a:	69a2                	ld	s3,8(sp)
    80003b1c:	6145                	addi	sp,sp,48
    80003b1e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b20:	0284a983          	lw	s3,40(s1)
    80003b24:	ffffd097          	auipc	ra,0xffffd
    80003b28:	424080e7          	jalr	1060(ra) # 80000f48 <myproc>
    80003b2c:	5904                	lw	s1,48(a0)
    80003b2e:	413484b3          	sub	s1,s1,s3
    80003b32:	0014b493          	seqz	s1,s1
    80003b36:	bfc1                	j	80003b06 <holdingsleep+0x24>

0000000080003b38 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b38:	1141                	addi	sp,sp,-16
    80003b3a:	e406                	sd	ra,8(sp)
    80003b3c:	e022                	sd	s0,0(sp)
    80003b3e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b40:	00005597          	auipc	a1,0x5
    80003b44:	b4858593          	addi	a1,a1,-1208 # 80008688 <syscalls+0x280>
    80003b48:	00015517          	auipc	a0,0x15
    80003b4c:	15050513          	addi	a0,a0,336 # 80018c98 <ftable>
    80003b50:	00002097          	auipc	ra,0x2
    80003b54:	7ac080e7          	jalr	1964(ra) # 800062fc <initlock>
}
    80003b58:	60a2                	ld	ra,8(sp)
    80003b5a:	6402                	ld	s0,0(sp)
    80003b5c:	0141                	addi	sp,sp,16
    80003b5e:	8082                	ret

0000000080003b60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b60:	1101                	addi	sp,sp,-32
    80003b62:	ec06                	sd	ra,24(sp)
    80003b64:	e822                	sd	s0,16(sp)
    80003b66:	e426                	sd	s1,8(sp)
    80003b68:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b6a:	00015517          	auipc	a0,0x15
    80003b6e:	12e50513          	addi	a0,a0,302 # 80018c98 <ftable>
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	81a080e7          	jalr	-2022(ra) # 8000638c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b7a:	00015497          	auipc	s1,0x15
    80003b7e:	13648493          	addi	s1,s1,310 # 80018cb0 <ftable+0x18>
    80003b82:	00016717          	auipc	a4,0x16
    80003b86:	0ce70713          	addi	a4,a4,206 # 80019c50 <disk>
    if(f->ref == 0){
    80003b8a:	40dc                	lw	a5,4(s1)
    80003b8c:	cf99                	beqz	a5,80003baa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b8e:	02848493          	addi	s1,s1,40
    80003b92:	fee49ce3          	bne	s1,a4,80003b8a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b96:	00015517          	auipc	a0,0x15
    80003b9a:	10250513          	addi	a0,a0,258 # 80018c98 <ftable>
    80003b9e:	00003097          	auipc	ra,0x3
    80003ba2:	8a2080e7          	jalr	-1886(ra) # 80006440 <release>
  return 0;
    80003ba6:	4481                	li	s1,0
    80003ba8:	a819                	j	80003bbe <filealloc+0x5e>
      f->ref = 1;
    80003baa:	4785                	li	a5,1
    80003bac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bae:	00015517          	auipc	a0,0x15
    80003bb2:	0ea50513          	addi	a0,a0,234 # 80018c98 <ftable>
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	88a080e7          	jalr	-1910(ra) # 80006440 <release>
}
    80003bbe:	8526                	mv	a0,s1
    80003bc0:	60e2                	ld	ra,24(sp)
    80003bc2:	6442                	ld	s0,16(sp)
    80003bc4:	64a2                	ld	s1,8(sp)
    80003bc6:	6105                	addi	sp,sp,32
    80003bc8:	8082                	ret

0000000080003bca <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bca:	1101                	addi	sp,sp,-32
    80003bcc:	ec06                	sd	ra,24(sp)
    80003bce:	e822                	sd	s0,16(sp)
    80003bd0:	e426                	sd	s1,8(sp)
    80003bd2:	1000                	addi	s0,sp,32
    80003bd4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bd6:	00015517          	auipc	a0,0x15
    80003bda:	0c250513          	addi	a0,a0,194 # 80018c98 <ftable>
    80003bde:	00002097          	auipc	ra,0x2
    80003be2:	7ae080e7          	jalr	1966(ra) # 8000638c <acquire>
  if(f->ref < 1)
    80003be6:	40dc                	lw	a5,4(s1)
    80003be8:	02f05263          	blez	a5,80003c0c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bec:	2785                	addiw	a5,a5,1
    80003bee:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bf0:	00015517          	auipc	a0,0x15
    80003bf4:	0a850513          	addi	a0,a0,168 # 80018c98 <ftable>
    80003bf8:	00003097          	auipc	ra,0x3
    80003bfc:	848080e7          	jalr	-1976(ra) # 80006440 <release>
  return f;
}
    80003c00:	8526                	mv	a0,s1
    80003c02:	60e2                	ld	ra,24(sp)
    80003c04:	6442                	ld	s0,16(sp)
    80003c06:	64a2                	ld	s1,8(sp)
    80003c08:	6105                	addi	sp,sp,32
    80003c0a:	8082                	ret
    panic("filedup");
    80003c0c:	00005517          	auipc	a0,0x5
    80003c10:	a8450513          	addi	a0,a0,-1404 # 80008690 <syscalls+0x288>
    80003c14:	00002097          	auipc	ra,0x2
    80003c18:	23c080e7          	jalr	572(ra) # 80005e50 <panic>

0000000080003c1c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c1c:	7139                	addi	sp,sp,-64
    80003c1e:	fc06                	sd	ra,56(sp)
    80003c20:	f822                	sd	s0,48(sp)
    80003c22:	f426                	sd	s1,40(sp)
    80003c24:	f04a                	sd	s2,32(sp)
    80003c26:	ec4e                	sd	s3,24(sp)
    80003c28:	e852                	sd	s4,16(sp)
    80003c2a:	e456                	sd	s5,8(sp)
    80003c2c:	0080                	addi	s0,sp,64
    80003c2e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c30:	00015517          	auipc	a0,0x15
    80003c34:	06850513          	addi	a0,a0,104 # 80018c98 <ftable>
    80003c38:	00002097          	auipc	ra,0x2
    80003c3c:	754080e7          	jalr	1876(ra) # 8000638c <acquire>
  if(f->ref < 1)
    80003c40:	40dc                	lw	a5,4(s1)
    80003c42:	06f05163          	blez	a5,80003ca4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c46:	37fd                	addiw	a5,a5,-1
    80003c48:	0007871b          	sext.w	a4,a5
    80003c4c:	c0dc                	sw	a5,4(s1)
    80003c4e:	06e04363          	bgtz	a4,80003cb4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c52:	0004a903          	lw	s2,0(s1)
    80003c56:	0094ca83          	lbu	s5,9(s1)
    80003c5a:	0104ba03          	ld	s4,16(s1)
    80003c5e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c62:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c66:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c6a:	00015517          	auipc	a0,0x15
    80003c6e:	02e50513          	addi	a0,a0,46 # 80018c98 <ftable>
    80003c72:	00002097          	auipc	ra,0x2
    80003c76:	7ce080e7          	jalr	1998(ra) # 80006440 <release>

  if(ff.type == FD_PIPE){
    80003c7a:	4785                	li	a5,1
    80003c7c:	04f90d63          	beq	s2,a5,80003cd6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c80:	3979                	addiw	s2,s2,-2
    80003c82:	4785                	li	a5,1
    80003c84:	0527e063          	bltu	a5,s2,80003cc4 <fileclose+0xa8>
    begin_op();
    80003c88:	00000097          	auipc	ra,0x0
    80003c8c:	ac8080e7          	jalr	-1336(ra) # 80003750 <begin_op>
    iput(ff.ip);
    80003c90:	854e                	mv	a0,s3
    80003c92:	fffff097          	auipc	ra,0xfffff
    80003c96:	2b6080e7          	jalr	694(ra) # 80002f48 <iput>
    end_op();
    80003c9a:	00000097          	auipc	ra,0x0
    80003c9e:	b36080e7          	jalr	-1226(ra) # 800037d0 <end_op>
    80003ca2:	a00d                	j	80003cc4 <fileclose+0xa8>
    panic("fileclose");
    80003ca4:	00005517          	auipc	a0,0x5
    80003ca8:	9f450513          	addi	a0,a0,-1548 # 80008698 <syscalls+0x290>
    80003cac:	00002097          	auipc	ra,0x2
    80003cb0:	1a4080e7          	jalr	420(ra) # 80005e50 <panic>
    release(&ftable.lock);
    80003cb4:	00015517          	auipc	a0,0x15
    80003cb8:	fe450513          	addi	a0,a0,-28 # 80018c98 <ftable>
    80003cbc:	00002097          	auipc	ra,0x2
    80003cc0:	784080e7          	jalr	1924(ra) # 80006440 <release>
  }
}
    80003cc4:	70e2                	ld	ra,56(sp)
    80003cc6:	7442                	ld	s0,48(sp)
    80003cc8:	74a2                	ld	s1,40(sp)
    80003cca:	7902                	ld	s2,32(sp)
    80003ccc:	69e2                	ld	s3,24(sp)
    80003cce:	6a42                	ld	s4,16(sp)
    80003cd0:	6aa2                	ld	s5,8(sp)
    80003cd2:	6121                	addi	sp,sp,64
    80003cd4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cd6:	85d6                	mv	a1,s5
    80003cd8:	8552                	mv	a0,s4
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	34c080e7          	jalr	844(ra) # 80004026 <pipeclose>
    80003ce2:	b7cd                	j	80003cc4 <fileclose+0xa8>

0000000080003ce4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ce4:	715d                	addi	sp,sp,-80
    80003ce6:	e486                	sd	ra,72(sp)
    80003ce8:	e0a2                	sd	s0,64(sp)
    80003cea:	fc26                	sd	s1,56(sp)
    80003cec:	f84a                	sd	s2,48(sp)
    80003cee:	f44e                	sd	s3,40(sp)
    80003cf0:	0880                	addi	s0,sp,80
    80003cf2:	84aa                	mv	s1,a0
    80003cf4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cf6:	ffffd097          	auipc	ra,0xffffd
    80003cfa:	252080e7          	jalr	594(ra) # 80000f48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cfe:	409c                	lw	a5,0(s1)
    80003d00:	37f9                	addiw	a5,a5,-2
    80003d02:	4705                	li	a4,1
    80003d04:	04f76763          	bltu	a4,a5,80003d52 <filestat+0x6e>
    80003d08:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d0a:	6c88                	ld	a0,24(s1)
    80003d0c:	fffff097          	auipc	ra,0xfffff
    80003d10:	082080e7          	jalr	130(ra) # 80002d8e <ilock>
    stati(f->ip, &st);
    80003d14:	fb840593          	addi	a1,s0,-72
    80003d18:	6c88                	ld	a0,24(s1)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	2fe080e7          	jalr	766(ra) # 80003018 <stati>
    iunlock(f->ip);
    80003d22:	6c88                	ld	a0,24(s1)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	12c080e7          	jalr	300(ra) # 80002e50 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d2c:	46e1                	li	a3,24
    80003d2e:	fb840613          	addi	a2,s0,-72
    80003d32:	85ce                	mv	a1,s3
    80003d34:	05093503          	ld	a0,80(s2)
    80003d38:	ffffd097          	auipc	ra,0xffffd
    80003d3c:	dd6080e7          	jalr	-554(ra) # 80000b0e <copyout>
    80003d40:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d44:	60a6                	ld	ra,72(sp)
    80003d46:	6406                	ld	s0,64(sp)
    80003d48:	74e2                	ld	s1,56(sp)
    80003d4a:	7942                	ld	s2,48(sp)
    80003d4c:	79a2                	ld	s3,40(sp)
    80003d4e:	6161                	addi	sp,sp,80
    80003d50:	8082                	ret
  return -1;
    80003d52:	557d                	li	a0,-1
    80003d54:	bfc5                	j	80003d44 <filestat+0x60>

0000000080003d56 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d56:	7179                	addi	sp,sp,-48
    80003d58:	f406                	sd	ra,40(sp)
    80003d5a:	f022                	sd	s0,32(sp)
    80003d5c:	ec26                	sd	s1,24(sp)
    80003d5e:	e84a                	sd	s2,16(sp)
    80003d60:	e44e                	sd	s3,8(sp)
    80003d62:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d64:	00854783          	lbu	a5,8(a0)
    80003d68:	c3d5                	beqz	a5,80003e0c <fileread+0xb6>
    80003d6a:	84aa                	mv	s1,a0
    80003d6c:	89ae                	mv	s3,a1
    80003d6e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d70:	411c                	lw	a5,0(a0)
    80003d72:	4705                	li	a4,1
    80003d74:	04e78963          	beq	a5,a4,80003dc6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d78:	470d                	li	a4,3
    80003d7a:	04e78d63          	beq	a5,a4,80003dd4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d7e:	4709                	li	a4,2
    80003d80:	06e79e63          	bne	a5,a4,80003dfc <fileread+0xa6>
    ilock(f->ip);
    80003d84:	6d08                	ld	a0,24(a0)
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	008080e7          	jalr	8(ra) # 80002d8e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d8e:	874a                	mv	a4,s2
    80003d90:	5094                	lw	a3,32(s1)
    80003d92:	864e                	mv	a2,s3
    80003d94:	4585                	li	a1,1
    80003d96:	6c88                	ld	a0,24(s1)
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	2aa080e7          	jalr	682(ra) # 80003042 <readi>
    80003da0:	892a                	mv	s2,a0
    80003da2:	00a05563          	blez	a0,80003dac <fileread+0x56>
      f->off += r;
    80003da6:	509c                	lw	a5,32(s1)
    80003da8:	9fa9                	addw	a5,a5,a0
    80003daa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dac:	6c88                	ld	a0,24(s1)
    80003dae:	fffff097          	auipc	ra,0xfffff
    80003db2:	0a2080e7          	jalr	162(ra) # 80002e50 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003db6:	854a                	mv	a0,s2
    80003db8:	70a2                	ld	ra,40(sp)
    80003dba:	7402                	ld	s0,32(sp)
    80003dbc:	64e2                	ld	s1,24(sp)
    80003dbe:	6942                	ld	s2,16(sp)
    80003dc0:	69a2                	ld	s3,8(sp)
    80003dc2:	6145                	addi	sp,sp,48
    80003dc4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003dc6:	6908                	ld	a0,16(a0)
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	3c6080e7          	jalr	966(ra) # 8000418e <piperead>
    80003dd0:	892a                	mv	s2,a0
    80003dd2:	b7d5                	j	80003db6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dd4:	02451783          	lh	a5,36(a0)
    80003dd8:	03079693          	slli	a3,a5,0x30
    80003ddc:	92c1                	srli	a3,a3,0x30
    80003dde:	4725                	li	a4,9
    80003de0:	02d76863          	bltu	a4,a3,80003e10 <fileread+0xba>
    80003de4:	0792                	slli	a5,a5,0x4
    80003de6:	00015717          	auipc	a4,0x15
    80003dea:	e1270713          	addi	a4,a4,-494 # 80018bf8 <devsw>
    80003dee:	97ba                	add	a5,a5,a4
    80003df0:	639c                	ld	a5,0(a5)
    80003df2:	c38d                	beqz	a5,80003e14 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003df4:	4505                	li	a0,1
    80003df6:	9782                	jalr	a5
    80003df8:	892a                	mv	s2,a0
    80003dfa:	bf75                	j	80003db6 <fileread+0x60>
    panic("fileread");
    80003dfc:	00005517          	auipc	a0,0x5
    80003e00:	8ac50513          	addi	a0,a0,-1876 # 800086a8 <syscalls+0x2a0>
    80003e04:	00002097          	auipc	ra,0x2
    80003e08:	04c080e7          	jalr	76(ra) # 80005e50 <panic>
    return -1;
    80003e0c:	597d                	li	s2,-1
    80003e0e:	b765                	j	80003db6 <fileread+0x60>
      return -1;
    80003e10:	597d                	li	s2,-1
    80003e12:	b755                	j	80003db6 <fileread+0x60>
    80003e14:	597d                	li	s2,-1
    80003e16:	b745                	j	80003db6 <fileread+0x60>

0000000080003e18 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e18:	715d                	addi	sp,sp,-80
    80003e1a:	e486                	sd	ra,72(sp)
    80003e1c:	e0a2                	sd	s0,64(sp)
    80003e1e:	fc26                	sd	s1,56(sp)
    80003e20:	f84a                	sd	s2,48(sp)
    80003e22:	f44e                	sd	s3,40(sp)
    80003e24:	f052                	sd	s4,32(sp)
    80003e26:	ec56                	sd	s5,24(sp)
    80003e28:	e85a                	sd	s6,16(sp)
    80003e2a:	e45e                	sd	s7,8(sp)
    80003e2c:	e062                	sd	s8,0(sp)
    80003e2e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e30:	00954783          	lbu	a5,9(a0)
    80003e34:	10078663          	beqz	a5,80003f40 <filewrite+0x128>
    80003e38:	892a                	mv	s2,a0
    80003e3a:	8aae                	mv	s5,a1
    80003e3c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e3e:	411c                	lw	a5,0(a0)
    80003e40:	4705                	li	a4,1
    80003e42:	02e78263          	beq	a5,a4,80003e66 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e46:	470d                	li	a4,3
    80003e48:	02e78663          	beq	a5,a4,80003e74 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e4c:	4709                	li	a4,2
    80003e4e:	0ee79163          	bne	a5,a4,80003f30 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e52:	0ac05d63          	blez	a2,80003f0c <filewrite+0xf4>
    int i = 0;
    80003e56:	4981                	li	s3,0
    80003e58:	6b05                	lui	s6,0x1
    80003e5a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e5e:	6b85                	lui	s7,0x1
    80003e60:	c00b8b9b          	addiw	s7,s7,-1024
    80003e64:	a861                	j	80003efc <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e66:	6908                	ld	a0,16(a0)
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	22e080e7          	jalr	558(ra) # 80004096 <pipewrite>
    80003e70:	8a2a                	mv	s4,a0
    80003e72:	a045                	j	80003f12 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e74:	02451783          	lh	a5,36(a0)
    80003e78:	03079693          	slli	a3,a5,0x30
    80003e7c:	92c1                	srli	a3,a3,0x30
    80003e7e:	4725                	li	a4,9
    80003e80:	0cd76263          	bltu	a4,a3,80003f44 <filewrite+0x12c>
    80003e84:	0792                	slli	a5,a5,0x4
    80003e86:	00015717          	auipc	a4,0x15
    80003e8a:	d7270713          	addi	a4,a4,-654 # 80018bf8 <devsw>
    80003e8e:	97ba                	add	a5,a5,a4
    80003e90:	679c                	ld	a5,8(a5)
    80003e92:	cbdd                	beqz	a5,80003f48 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e94:	4505                	li	a0,1
    80003e96:	9782                	jalr	a5
    80003e98:	8a2a                	mv	s4,a0
    80003e9a:	a8a5                	j	80003f12 <filewrite+0xfa>
    80003e9c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003ea0:	00000097          	auipc	ra,0x0
    80003ea4:	8b0080e7          	jalr	-1872(ra) # 80003750 <begin_op>
      ilock(f->ip);
    80003ea8:	01893503          	ld	a0,24(s2)
    80003eac:	fffff097          	auipc	ra,0xfffff
    80003eb0:	ee2080e7          	jalr	-286(ra) # 80002d8e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003eb4:	8762                	mv	a4,s8
    80003eb6:	02092683          	lw	a3,32(s2)
    80003eba:	01598633          	add	a2,s3,s5
    80003ebe:	4585                	li	a1,1
    80003ec0:	01893503          	ld	a0,24(s2)
    80003ec4:	fffff097          	auipc	ra,0xfffff
    80003ec8:	276080e7          	jalr	630(ra) # 8000313a <writei>
    80003ecc:	84aa                	mv	s1,a0
    80003ece:	00a05763          	blez	a0,80003edc <filewrite+0xc4>
        f->off += r;
    80003ed2:	02092783          	lw	a5,32(s2)
    80003ed6:	9fa9                	addw	a5,a5,a0
    80003ed8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003edc:	01893503          	ld	a0,24(s2)
    80003ee0:	fffff097          	auipc	ra,0xfffff
    80003ee4:	f70080e7          	jalr	-144(ra) # 80002e50 <iunlock>
      end_op();
    80003ee8:	00000097          	auipc	ra,0x0
    80003eec:	8e8080e7          	jalr	-1816(ra) # 800037d0 <end_op>

      if(r != n1){
    80003ef0:	009c1f63          	bne	s8,s1,80003f0e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ef4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ef8:	0149db63          	bge	s3,s4,80003f0e <filewrite+0xf6>
      int n1 = n - i;
    80003efc:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f00:	84be                	mv	s1,a5
    80003f02:	2781                	sext.w	a5,a5
    80003f04:	f8fb5ce3          	bge	s6,a5,80003e9c <filewrite+0x84>
    80003f08:	84de                	mv	s1,s7
    80003f0a:	bf49                	j	80003e9c <filewrite+0x84>
    int i = 0;
    80003f0c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f0e:	013a1f63          	bne	s4,s3,80003f2c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f12:	8552                	mv	a0,s4
    80003f14:	60a6                	ld	ra,72(sp)
    80003f16:	6406                	ld	s0,64(sp)
    80003f18:	74e2                	ld	s1,56(sp)
    80003f1a:	7942                	ld	s2,48(sp)
    80003f1c:	79a2                	ld	s3,40(sp)
    80003f1e:	7a02                	ld	s4,32(sp)
    80003f20:	6ae2                	ld	s5,24(sp)
    80003f22:	6b42                	ld	s6,16(sp)
    80003f24:	6ba2                	ld	s7,8(sp)
    80003f26:	6c02                	ld	s8,0(sp)
    80003f28:	6161                	addi	sp,sp,80
    80003f2a:	8082                	ret
    ret = (i == n ? n : -1);
    80003f2c:	5a7d                	li	s4,-1
    80003f2e:	b7d5                	j	80003f12 <filewrite+0xfa>
    panic("filewrite");
    80003f30:	00004517          	auipc	a0,0x4
    80003f34:	78850513          	addi	a0,a0,1928 # 800086b8 <syscalls+0x2b0>
    80003f38:	00002097          	auipc	ra,0x2
    80003f3c:	f18080e7          	jalr	-232(ra) # 80005e50 <panic>
    return -1;
    80003f40:	5a7d                	li	s4,-1
    80003f42:	bfc1                	j	80003f12 <filewrite+0xfa>
      return -1;
    80003f44:	5a7d                	li	s4,-1
    80003f46:	b7f1                	j	80003f12 <filewrite+0xfa>
    80003f48:	5a7d                	li	s4,-1
    80003f4a:	b7e1                	j	80003f12 <filewrite+0xfa>

0000000080003f4c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f4c:	7179                	addi	sp,sp,-48
    80003f4e:	f406                	sd	ra,40(sp)
    80003f50:	f022                	sd	s0,32(sp)
    80003f52:	ec26                	sd	s1,24(sp)
    80003f54:	e84a                	sd	s2,16(sp)
    80003f56:	e44e                	sd	s3,8(sp)
    80003f58:	e052                	sd	s4,0(sp)
    80003f5a:	1800                	addi	s0,sp,48
    80003f5c:	84aa                	mv	s1,a0
    80003f5e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f60:	0005b023          	sd	zero,0(a1)
    80003f64:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f68:	00000097          	auipc	ra,0x0
    80003f6c:	bf8080e7          	jalr	-1032(ra) # 80003b60 <filealloc>
    80003f70:	e088                	sd	a0,0(s1)
    80003f72:	c551                	beqz	a0,80003ffe <pipealloc+0xb2>
    80003f74:	00000097          	auipc	ra,0x0
    80003f78:	bec080e7          	jalr	-1044(ra) # 80003b60 <filealloc>
    80003f7c:	00aa3023          	sd	a0,0(s4)
    80003f80:	c92d                	beqz	a0,80003ff2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f82:	ffffc097          	auipc	ra,0xffffc
    80003f86:	196080e7          	jalr	406(ra) # 80000118 <kalloc>
    80003f8a:	892a                	mv	s2,a0
    80003f8c:	c125                	beqz	a0,80003fec <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f8e:	4985                	li	s3,1
    80003f90:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f94:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f98:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f9c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fa0:	00004597          	auipc	a1,0x4
    80003fa4:	72858593          	addi	a1,a1,1832 # 800086c8 <syscalls+0x2c0>
    80003fa8:	00002097          	auipc	ra,0x2
    80003fac:	354080e7          	jalr	852(ra) # 800062fc <initlock>
  (*f0)->type = FD_PIPE;
    80003fb0:	609c                	ld	a5,0(s1)
    80003fb2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fb6:	609c                	ld	a5,0(s1)
    80003fb8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fbc:	609c                	ld	a5,0(s1)
    80003fbe:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fc2:	609c                	ld	a5,0(s1)
    80003fc4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fc8:	000a3783          	ld	a5,0(s4)
    80003fcc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fd0:	000a3783          	ld	a5,0(s4)
    80003fd4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fd8:	000a3783          	ld	a5,0(s4)
    80003fdc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fe0:	000a3783          	ld	a5,0(s4)
    80003fe4:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fe8:	4501                	li	a0,0
    80003fea:	a025                	j	80004012 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fec:	6088                	ld	a0,0(s1)
    80003fee:	e501                	bnez	a0,80003ff6 <pipealloc+0xaa>
    80003ff0:	a039                	j	80003ffe <pipealloc+0xb2>
    80003ff2:	6088                	ld	a0,0(s1)
    80003ff4:	c51d                	beqz	a0,80004022 <pipealloc+0xd6>
    fileclose(*f0);
    80003ff6:	00000097          	auipc	ra,0x0
    80003ffa:	c26080e7          	jalr	-986(ra) # 80003c1c <fileclose>
  if(*f1)
    80003ffe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004002:	557d                	li	a0,-1
  if(*f1)
    80004004:	c799                	beqz	a5,80004012 <pipealloc+0xc6>
    fileclose(*f1);
    80004006:	853e                	mv	a0,a5
    80004008:	00000097          	auipc	ra,0x0
    8000400c:	c14080e7          	jalr	-1004(ra) # 80003c1c <fileclose>
  return -1;
    80004010:	557d                	li	a0,-1
}
    80004012:	70a2                	ld	ra,40(sp)
    80004014:	7402                	ld	s0,32(sp)
    80004016:	64e2                	ld	s1,24(sp)
    80004018:	6942                	ld	s2,16(sp)
    8000401a:	69a2                	ld	s3,8(sp)
    8000401c:	6a02                	ld	s4,0(sp)
    8000401e:	6145                	addi	sp,sp,48
    80004020:	8082                	ret
  return -1;
    80004022:	557d                	li	a0,-1
    80004024:	b7fd                	j	80004012 <pipealloc+0xc6>

0000000080004026 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004026:	1101                	addi	sp,sp,-32
    80004028:	ec06                	sd	ra,24(sp)
    8000402a:	e822                	sd	s0,16(sp)
    8000402c:	e426                	sd	s1,8(sp)
    8000402e:	e04a                	sd	s2,0(sp)
    80004030:	1000                	addi	s0,sp,32
    80004032:	84aa                	mv	s1,a0
    80004034:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004036:	00002097          	auipc	ra,0x2
    8000403a:	356080e7          	jalr	854(ra) # 8000638c <acquire>
  if(writable){
    8000403e:	02090d63          	beqz	s2,80004078 <pipeclose+0x52>
    pi->writeopen = 0;
    80004042:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004046:	21848513          	addi	a0,s1,536
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	6e6080e7          	jalr	1766(ra) # 80001730 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004052:	2204b783          	ld	a5,544(s1)
    80004056:	eb95                	bnez	a5,8000408a <pipeclose+0x64>
    release(&pi->lock);
    80004058:	8526                	mv	a0,s1
    8000405a:	00002097          	auipc	ra,0x2
    8000405e:	3e6080e7          	jalr	998(ra) # 80006440 <release>
    kfree((char*)pi);
    80004062:	8526                	mv	a0,s1
    80004064:	ffffc097          	auipc	ra,0xffffc
    80004068:	fb8080e7          	jalr	-72(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000406c:	60e2                	ld	ra,24(sp)
    8000406e:	6442                	ld	s0,16(sp)
    80004070:	64a2                	ld	s1,8(sp)
    80004072:	6902                	ld	s2,0(sp)
    80004074:	6105                	addi	sp,sp,32
    80004076:	8082                	ret
    pi->readopen = 0;
    80004078:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000407c:	21c48513          	addi	a0,s1,540
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	6b0080e7          	jalr	1712(ra) # 80001730 <wakeup>
    80004088:	b7e9                	j	80004052 <pipeclose+0x2c>
    release(&pi->lock);
    8000408a:	8526                	mv	a0,s1
    8000408c:	00002097          	auipc	ra,0x2
    80004090:	3b4080e7          	jalr	948(ra) # 80006440 <release>
}
    80004094:	bfe1                	j	8000406c <pipeclose+0x46>

0000000080004096 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004096:	711d                	addi	sp,sp,-96
    80004098:	ec86                	sd	ra,88(sp)
    8000409a:	e8a2                	sd	s0,80(sp)
    8000409c:	e4a6                	sd	s1,72(sp)
    8000409e:	e0ca                	sd	s2,64(sp)
    800040a0:	fc4e                	sd	s3,56(sp)
    800040a2:	f852                	sd	s4,48(sp)
    800040a4:	f456                	sd	s5,40(sp)
    800040a6:	f05a                	sd	s6,32(sp)
    800040a8:	ec5e                	sd	s7,24(sp)
    800040aa:	e862                	sd	s8,16(sp)
    800040ac:	1080                	addi	s0,sp,96
    800040ae:	84aa                	mv	s1,a0
    800040b0:	8aae                	mv	s5,a1
    800040b2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	e94080e7          	jalr	-364(ra) # 80000f48 <myproc>
    800040bc:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040be:	8526                	mv	a0,s1
    800040c0:	00002097          	auipc	ra,0x2
    800040c4:	2cc080e7          	jalr	716(ra) # 8000638c <acquire>
  while(i < n){
    800040c8:	0b405663          	blez	s4,80004174 <pipewrite+0xde>
  int i = 0;
    800040cc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ce:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040d0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040d4:	21c48b93          	addi	s7,s1,540
    800040d8:	a089                	j	8000411a <pipewrite+0x84>
      release(&pi->lock);
    800040da:	8526                	mv	a0,s1
    800040dc:	00002097          	auipc	ra,0x2
    800040e0:	364080e7          	jalr	868(ra) # 80006440 <release>
      return -1;
    800040e4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040e6:	854a                	mv	a0,s2
    800040e8:	60e6                	ld	ra,88(sp)
    800040ea:	6446                	ld	s0,80(sp)
    800040ec:	64a6                	ld	s1,72(sp)
    800040ee:	6906                	ld	s2,64(sp)
    800040f0:	79e2                	ld	s3,56(sp)
    800040f2:	7a42                	ld	s4,48(sp)
    800040f4:	7aa2                	ld	s5,40(sp)
    800040f6:	7b02                	ld	s6,32(sp)
    800040f8:	6be2                	ld	s7,24(sp)
    800040fa:	6c42                	ld	s8,16(sp)
    800040fc:	6125                	addi	sp,sp,96
    800040fe:	8082                	ret
      wakeup(&pi->nread);
    80004100:	8562                	mv	a0,s8
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	62e080e7          	jalr	1582(ra) # 80001730 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000410a:	85a6                	mv	a1,s1
    8000410c:	855e                	mv	a0,s7
    8000410e:	ffffd097          	auipc	ra,0xffffd
    80004112:	5be080e7          	jalr	1470(ra) # 800016cc <sleep>
  while(i < n){
    80004116:	07495063          	bge	s2,s4,80004176 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000411a:	2204a783          	lw	a5,544(s1)
    8000411e:	dfd5                	beqz	a5,800040da <pipewrite+0x44>
    80004120:	854e                	mv	a0,s3
    80004122:	ffffe097          	auipc	ra,0xffffe
    80004126:	852080e7          	jalr	-1966(ra) # 80001974 <killed>
    8000412a:	f945                	bnez	a0,800040da <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000412c:	2184a783          	lw	a5,536(s1)
    80004130:	21c4a703          	lw	a4,540(s1)
    80004134:	2007879b          	addiw	a5,a5,512
    80004138:	fcf704e3          	beq	a4,a5,80004100 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000413c:	4685                	li	a3,1
    8000413e:	01590633          	add	a2,s2,s5
    80004142:	faf40593          	addi	a1,s0,-81
    80004146:	0509b503          	ld	a0,80(s3)
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	a50080e7          	jalr	-1456(ra) # 80000b9a <copyin>
    80004152:	03650263          	beq	a0,s6,80004176 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004156:	21c4a783          	lw	a5,540(s1)
    8000415a:	0017871b          	addiw	a4,a5,1
    8000415e:	20e4ae23          	sw	a4,540(s1)
    80004162:	1ff7f793          	andi	a5,a5,511
    80004166:	97a6                	add	a5,a5,s1
    80004168:	faf44703          	lbu	a4,-81(s0)
    8000416c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004170:	2905                	addiw	s2,s2,1
    80004172:	b755                	j	80004116 <pipewrite+0x80>
  int i = 0;
    80004174:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004176:	21848513          	addi	a0,s1,536
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	5b6080e7          	jalr	1462(ra) # 80001730 <wakeup>
  release(&pi->lock);
    80004182:	8526                	mv	a0,s1
    80004184:	00002097          	auipc	ra,0x2
    80004188:	2bc080e7          	jalr	700(ra) # 80006440 <release>
  return i;
    8000418c:	bfa9                	j	800040e6 <pipewrite+0x50>

000000008000418e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000418e:	715d                	addi	sp,sp,-80
    80004190:	e486                	sd	ra,72(sp)
    80004192:	e0a2                	sd	s0,64(sp)
    80004194:	fc26                	sd	s1,56(sp)
    80004196:	f84a                	sd	s2,48(sp)
    80004198:	f44e                	sd	s3,40(sp)
    8000419a:	f052                	sd	s4,32(sp)
    8000419c:	ec56                	sd	s5,24(sp)
    8000419e:	e85a                	sd	s6,16(sp)
    800041a0:	0880                	addi	s0,sp,80
    800041a2:	84aa                	mv	s1,a0
    800041a4:	892e                	mv	s2,a1
    800041a6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	da0080e7          	jalr	-608(ra) # 80000f48 <myproc>
    800041b0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041b2:	8526                	mv	a0,s1
    800041b4:	00002097          	auipc	ra,0x2
    800041b8:	1d8080e7          	jalr	472(ra) # 8000638c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041bc:	2184a703          	lw	a4,536(s1)
    800041c0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041c4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041c8:	02f71763          	bne	a4,a5,800041f6 <piperead+0x68>
    800041cc:	2244a783          	lw	a5,548(s1)
    800041d0:	c39d                	beqz	a5,800041f6 <piperead+0x68>
    if(killed(pr)){
    800041d2:	8552                	mv	a0,s4
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	7a0080e7          	jalr	1952(ra) # 80001974 <killed>
    800041dc:	e941                	bnez	a0,8000426c <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041de:	85a6                	mv	a1,s1
    800041e0:	854e                	mv	a0,s3
    800041e2:	ffffd097          	auipc	ra,0xffffd
    800041e6:	4ea080e7          	jalr	1258(ra) # 800016cc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ea:	2184a703          	lw	a4,536(s1)
    800041ee:	21c4a783          	lw	a5,540(s1)
    800041f2:	fcf70de3          	beq	a4,a5,800041cc <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041f6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041f8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041fa:	05505363          	blez	s5,80004240 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800041fe:	2184a783          	lw	a5,536(s1)
    80004202:	21c4a703          	lw	a4,540(s1)
    80004206:	02f70d63          	beq	a4,a5,80004240 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000420a:	0017871b          	addiw	a4,a5,1
    8000420e:	20e4ac23          	sw	a4,536(s1)
    80004212:	1ff7f793          	andi	a5,a5,511
    80004216:	97a6                	add	a5,a5,s1
    80004218:	0187c783          	lbu	a5,24(a5)
    8000421c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004220:	4685                	li	a3,1
    80004222:	fbf40613          	addi	a2,s0,-65
    80004226:	85ca                	mv	a1,s2
    80004228:	050a3503          	ld	a0,80(s4)
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	8e2080e7          	jalr	-1822(ra) # 80000b0e <copyout>
    80004234:	01650663          	beq	a0,s6,80004240 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004238:	2985                	addiw	s3,s3,1
    8000423a:	0905                	addi	s2,s2,1
    8000423c:	fd3a91e3          	bne	s5,s3,800041fe <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004240:	21c48513          	addi	a0,s1,540
    80004244:	ffffd097          	auipc	ra,0xffffd
    80004248:	4ec080e7          	jalr	1260(ra) # 80001730 <wakeup>
  release(&pi->lock);
    8000424c:	8526                	mv	a0,s1
    8000424e:	00002097          	auipc	ra,0x2
    80004252:	1f2080e7          	jalr	498(ra) # 80006440 <release>
  return i;
}
    80004256:	854e                	mv	a0,s3
    80004258:	60a6                	ld	ra,72(sp)
    8000425a:	6406                	ld	s0,64(sp)
    8000425c:	74e2                	ld	s1,56(sp)
    8000425e:	7942                	ld	s2,48(sp)
    80004260:	79a2                	ld	s3,40(sp)
    80004262:	7a02                	ld	s4,32(sp)
    80004264:	6ae2                	ld	s5,24(sp)
    80004266:	6b42                	ld	s6,16(sp)
    80004268:	6161                	addi	sp,sp,80
    8000426a:	8082                	ret
      release(&pi->lock);
    8000426c:	8526                	mv	a0,s1
    8000426e:	00002097          	auipc	ra,0x2
    80004272:	1d2080e7          	jalr	466(ra) # 80006440 <release>
      return -1;
    80004276:	59fd                	li	s3,-1
    80004278:	bff9                	j	80004256 <piperead+0xc8>

000000008000427a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000427a:	1141                	addi	sp,sp,-16
    8000427c:	e422                	sd	s0,8(sp)
    8000427e:	0800                	addi	s0,sp,16
    80004280:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004282:	8905                	andi	a0,a0,1
    80004284:	c111                	beqz	a0,80004288 <flags2perm+0xe>
      perm = PTE_X;
    80004286:	4521                	li	a0,8
    if(flags & 0x2)
    80004288:	8b89                	andi	a5,a5,2
    8000428a:	c399                	beqz	a5,80004290 <flags2perm+0x16>
      perm |= PTE_W;
    8000428c:	00456513          	ori	a0,a0,4
    return perm;
}
    80004290:	6422                	ld	s0,8(sp)
    80004292:	0141                	addi	sp,sp,16
    80004294:	8082                	ret

0000000080004296 <exec>:

int
exec(char *path, char **argv)
{
    80004296:	de010113          	addi	sp,sp,-544
    8000429a:	20113c23          	sd	ra,536(sp)
    8000429e:	20813823          	sd	s0,528(sp)
    800042a2:	20913423          	sd	s1,520(sp)
    800042a6:	21213023          	sd	s2,512(sp)
    800042aa:	ffce                	sd	s3,504(sp)
    800042ac:	fbd2                	sd	s4,496(sp)
    800042ae:	f7d6                	sd	s5,488(sp)
    800042b0:	f3da                	sd	s6,480(sp)
    800042b2:	efde                	sd	s7,472(sp)
    800042b4:	ebe2                	sd	s8,464(sp)
    800042b6:	e7e6                	sd	s9,456(sp)
    800042b8:	e3ea                	sd	s10,448(sp)
    800042ba:	ff6e                	sd	s11,440(sp)
    800042bc:	1400                	addi	s0,sp,544
    800042be:	892a                	mv	s2,a0
    800042c0:	dea43423          	sd	a0,-536(s0)
    800042c4:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042c8:	ffffd097          	auipc	ra,0xffffd
    800042cc:	c80080e7          	jalr	-896(ra) # 80000f48 <myproc>
    800042d0:	84aa                	mv	s1,a0

  begin_op();
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	47e080e7          	jalr	1150(ra) # 80003750 <begin_op>

  if((ip = namei(path)) == 0){
    800042da:	854a                	mv	a0,s2
    800042dc:	fffff097          	auipc	ra,0xfffff
    800042e0:	258080e7          	jalr	600(ra) # 80003534 <namei>
    800042e4:	c93d                	beqz	a0,8000435a <exec+0xc4>
    800042e6:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	aa6080e7          	jalr	-1370(ra) # 80002d8e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042f0:	04000713          	li	a4,64
    800042f4:	4681                	li	a3,0
    800042f6:	e5040613          	addi	a2,s0,-432
    800042fa:	4581                	li	a1,0
    800042fc:	8556                	mv	a0,s5
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	d44080e7          	jalr	-700(ra) # 80003042 <readi>
    80004306:	04000793          	li	a5,64
    8000430a:	00f51a63          	bne	a0,a5,8000431e <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000430e:	e5042703          	lw	a4,-432(s0)
    80004312:	464c47b7          	lui	a5,0x464c4
    80004316:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000431a:	04f70663          	beq	a4,a5,80004366 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000431e:	8556                	mv	a0,s5
    80004320:	fffff097          	auipc	ra,0xfffff
    80004324:	cd0080e7          	jalr	-816(ra) # 80002ff0 <iunlockput>
    end_op();
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	4a8080e7          	jalr	1192(ra) # 800037d0 <end_op>
  }
  return -1;
    80004330:	557d                	li	a0,-1
}
    80004332:	21813083          	ld	ra,536(sp)
    80004336:	21013403          	ld	s0,528(sp)
    8000433a:	20813483          	ld	s1,520(sp)
    8000433e:	20013903          	ld	s2,512(sp)
    80004342:	79fe                	ld	s3,504(sp)
    80004344:	7a5e                	ld	s4,496(sp)
    80004346:	7abe                	ld	s5,488(sp)
    80004348:	7b1e                	ld	s6,480(sp)
    8000434a:	6bfe                	ld	s7,472(sp)
    8000434c:	6c5e                	ld	s8,464(sp)
    8000434e:	6cbe                	ld	s9,456(sp)
    80004350:	6d1e                	ld	s10,448(sp)
    80004352:	7dfa                	ld	s11,440(sp)
    80004354:	22010113          	addi	sp,sp,544
    80004358:	8082                	ret
    end_op();
    8000435a:	fffff097          	auipc	ra,0xfffff
    8000435e:	476080e7          	jalr	1142(ra) # 800037d0 <end_op>
    return -1;
    80004362:	557d                	li	a0,-1
    80004364:	b7f9                	j	80004332 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004366:	8526                	mv	a0,s1
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	ca4080e7          	jalr	-860(ra) # 8000100c <proc_pagetable>
    80004370:	8b2a                	mv	s6,a0
    80004372:	d555                	beqz	a0,8000431e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004374:	e7042783          	lw	a5,-400(s0)
    80004378:	e8845703          	lhu	a4,-376(s0)
    8000437c:	c735                	beqz	a4,800043e8 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000437e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004380:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004384:	6a05                	lui	s4,0x1
    80004386:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000438a:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000438e:	6d85                	lui	s11,0x1
    80004390:	7d7d                	lui	s10,0xfffff
    80004392:	aca1                	j	800045ea <exec+0x354>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004394:	00004517          	auipc	a0,0x4
    80004398:	33c50513          	addi	a0,a0,828 # 800086d0 <syscalls+0x2c8>
    8000439c:	00002097          	auipc	ra,0x2
    800043a0:	ab4080e7          	jalr	-1356(ra) # 80005e50 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043a4:	874a                	mv	a4,s2
    800043a6:	009c86bb          	addw	a3,s9,s1
    800043aa:	4581                	li	a1,0
    800043ac:	8556                	mv	a0,s5
    800043ae:	fffff097          	auipc	ra,0xfffff
    800043b2:	c94080e7          	jalr	-876(ra) # 80003042 <readi>
    800043b6:	2501                	sext.w	a0,a0
    800043b8:	1ca91663          	bne	s2,a0,80004584 <exec+0x2ee>
  for(i = 0; i < sz; i += PGSIZE){
    800043bc:	009d84bb          	addw	s1,s11,s1
    800043c0:	013d09bb          	addw	s3,s10,s3
    800043c4:	2174f363          	bgeu	s1,s7,800045ca <exec+0x334>
    pa = walkaddr(pagetable, va + i);
    800043c8:	02049593          	slli	a1,s1,0x20
    800043cc:	9181                	srli	a1,a1,0x20
    800043ce:	95e2                	add	a1,a1,s8
    800043d0:	855a                	mv	a0,s6
    800043d2:	ffffc097          	auipc	ra,0xffffc
    800043d6:	130080e7          	jalr	304(ra) # 80000502 <walkaddr>
    800043da:	862a                	mv	a2,a0
    if(pa == 0)
    800043dc:	dd45                	beqz	a0,80004394 <exec+0xfe>
      n = PGSIZE;
    800043de:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800043e0:	fd49f2e3          	bgeu	s3,s4,800043a4 <exec+0x10e>
      n = sz - i;
    800043e4:	894e                	mv	s2,s3
    800043e6:	bf7d                	j	800043a4 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043e8:	4901                	li	s2,0
  iunlockput(ip);
    800043ea:	8556                	mv	a0,s5
    800043ec:	fffff097          	auipc	ra,0xfffff
    800043f0:	c04080e7          	jalr	-1020(ra) # 80002ff0 <iunlockput>
  end_op();
    800043f4:	fffff097          	auipc	ra,0xfffff
    800043f8:	3dc080e7          	jalr	988(ra) # 800037d0 <end_op>
  p = myproc();
    800043fc:	ffffd097          	auipc	ra,0xffffd
    80004400:	b4c080e7          	jalr	-1204(ra) # 80000f48 <myproc>
    80004404:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004406:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000440a:	6785                	lui	a5,0x1
    8000440c:	17fd                	addi	a5,a5,-1
    8000440e:	993e                	add	s2,s2,a5
    80004410:	77fd                	lui	a5,0xfffff
    80004412:	00f977b3          	and	a5,s2,a5
    80004416:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000441a:	4691                	li	a3,4
    8000441c:	6609                	lui	a2,0x2
    8000441e:	963e                	add	a2,a2,a5
    80004420:	85be                	mv	a1,a5
    80004422:	855a                	mv	a0,s6
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	492080e7          	jalr	1170(ra) # 800008b6 <uvmalloc>
    8000442c:	8c2a                	mv	s8,a0
  ip = 0;
    8000442e:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004430:	14050a63          	beqz	a0,80004584 <exec+0x2ee>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004434:	75f9                	lui	a1,0xffffe
    80004436:	95aa                	add	a1,a1,a0
    80004438:	855a                	mv	a0,s6
    8000443a:	ffffc097          	auipc	ra,0xffffc
    8000443e:	6a2080e7          	jalr	1698(ra) # 80000adc <uvmclear>
  stackbase = sp - PGSIZE;
    80004442:	7afd                	lui	s5,0xfffff
    80004444:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004446:	df043783          	ld	a5,-528(s0)
    8000444a:	6388                	ld	a0,0(a5)
    8000444c:	c925                	beqz	a0,800044bc <exec+0x226>
    8000444e:	e9040993          	addi	s3,s0,-368
    80004452:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004456:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004458:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	e9a080e7          	jalr	-358(ra) # 800002f4 <strlen>
    80004462:	0015079b          	addiw	a5,a0,1
    80004466:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000446a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000446e:	15596263          	bltu	s2,s5,800045b2 <exec+0x31c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004472:	df043d83          	ld	s11,-528(s0)
    80004476:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000447a:	8552                	mv	a0,s4
    8000447c:	ffffc097          	auipc	ra,0xffffc
    80004480:	e78080e7          	jalr	-392(ra) # 800002f4 <strlen>
    80004484:	0015069b          	addiw	a3,a0,1
    80004488:	8652                	mv	a2,s4
    8000448a:	85ca                	mv	a1,s2
    8000448c:	855a                	mv	a0,s6
    8000448e:	ffffc097          	auipc	ra,0xffffc
    80004492:	680080e7          	jalr	1664(ra) # 80000b0e <copyout>
    80004496:	12054263          	bltz	a0,800045ba <exec+0x324>
    ustack[argc] = sp;
    8000449a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000449e:	0485                	addi	s1,s1,1
    800044a0:	008d8793          	addi	a5,s11,8
    800044a4:	def43823          	sd	a5,-528(s0)
    800044a8:	008db503          	ld	a0,8(s11)
    800044ac:	c911                	beqz	a0,800044c0 <exec+0x22a>
    if(argc >= MAXARG)
    800044ae:	09a1                	addi	s3,s3,8
    800044b0:	fb3c95e3          	bne	s9,s3,8000445a <exec+0x1c4>
  sz = sz1;
    800044b4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044b8:	4a81                	li	s5,0
    800044ba:	a0e9                	j	80004584 <exec+0x2ee>
  sp = sz;
    800044bc:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800044be:	4481                	li	s1,0
  ustack[argc] = 0;
    800044c0:	00349793          	slli	a5,s1,0x3
    800044c4:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdcfc0>
    800044c8:	97a2                	add	a5,a5,s0
    800044ca:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800044ce:	00148693          	addi	a3,s1,1
    800044d2:	068e                	slli	a3,a3,0x3
    800044d4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044d8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044dc:	01597663          	bgeu	s2,s5,800044e8 <exec+0x252>
  sz = sz1;
    800044e0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044e4:	4a81                	li	s5,0
    800044e6:	a879                	j	80004584 <exec+0x2ee>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044e8:	e9040613          	addi	a2,s0,-368
    800044ec:	85ca                	mv	a1,s2
    800044ee:	855a                	mv	a0,s6
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	61e080e7          	jalr	1566(ra) # 80000b0e <copyout>
    800044f8:	0c054563          	bltz	a0,800045c2 <exec+0x32c>
  p->trapframe->a1 = sp;
    800044fc:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004500:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004504:	de843783          	ld	a5,-536(s0)
    80004508:	0007c703          	lbu	a4,0(a5)
    8000450c:	cf11                	beqz	a4,80004528 <exec+0x292>
    8000450e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004510:	02f00693          	li	a3,47
    80004514:	a039                	j	80004522 <exec+0x28c>
      last = s+1;
    80004516:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000451a:	0785                	addi	a5,a5,1
    8000451c:	fff7c703          	lbu	a4,-1(a5)
    80004520:	c701                	beqz	a4,80004528 <exec+0x292>
    if(*s == '/')
    80004522:	fed71ce3          	bne	a4,a3,8000451a <exec+0x284>
    80004526:	bfc5                	j	80004516 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004528:	4641                	li	a2,16
    8000452a:	de843583          	ld	a1,-536(s0)
    8000452e:	158b8513          	addi	a0,s7,344
    80004532:	ffffc097          	auipc	ra,0xffffc
    80004536:	d90080e7          	jalr	-624(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000453a:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000453e:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004542:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004546:	058bb783          	ld	a5,88(s7)
    8000454a:	e6843703          	ld	a4,-408(s0)
    8000454e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004550:	058bb783          	ld	a5,88(s7)
    80004554:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004558:	85ea                	mv	a1,s10
    8000455a:	ffffd097          	auipc	ra,0xffffd
    8000455e:	ba8080e7          	jalr	-1112(ra) # 80001102 <proc_freepagetable>
  if(p->pid==1)
    80004562:	030ba703          	lw	a4,48(s7)
    80004566:	4785                	li	a5,1
    80004568:	00f70563          	beq	a4,a5,80004572 <exec+0x2dc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000456c:	0004851b          	sext.w	a0,s1
    80004570:	b3c9                	j	80004332 <exec+0x9c>
    vmprint(p->pagetable);
    80004572:	050bb503          	ld	a0,80(s7)
    80004576:	ffffd097          	auipc	ra,0xffffd
    8000457a:	82c080e7          	jalr	-2004(ra) # 80000da2 <vmprint>
    8000457e:	b7fd                	j	8000456c <exec+0x2d6>
    80004580:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004584:	df843583          	ld	a1,-520(s0)
    80004588:	855a                	mv	a0,s6
    8000458a:	ffffd097          	auipc	ra,0xffffd
    8000458e:	b78080e7          	jalr	-1160(ra) # 80001102 <proc_freepagetable>
  if(ip){
    80004592:	d80a96e3          	bnez	s5,8000431e <exec+0x88>
  return -1;
    80004596:	557d                	li	a0,-1
    80004598:	bb69                	j	80004332 <exec+0x9c>
    8000459a:	df243c23          	sd	s2,-520(s0)
    8000459e:	b7dd                	j	80004584 <exec+0x2ee>
    800045a0:	df243c23          	sd	s2,-520(s0)
    800045a4:	b7c5                	j	80004584 <exec+0x2ee>
    800045a6:	df243c23          	sd	s2,-520(s0)
    800045aa:	bfe9                	j	80004584 <exec+0x2ee>
    800045ac:	df243c23          	sd	s2,-520(s0)
    800045b0:	bfd1                	j	80004584 <exec+0x2ee>
  sz = sz1;
    800045b2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045b6:	4a81                	li	s5,0
    800045b8:	b7f1                	j	80004584 <exec+0x2ee>
  sz = sz1;
    800045ba:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045be:	4a81                	li	s5,0
    800045c0:	b7d1                	j	80004584 <exec+0x2ee>
  sz = sz1;
    800045c2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045c6:	4a81                	li	s5,0
    800045c8:	bf75                	j	80004584 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045ca:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045ce:	e0843783          	ld	a5,-504(s0)
    800045d2:	0017869b          	addiw	a3,a5,1
    800045d6:	e0d43423          	sd	a3,-504(s0)
    800045da:	e0043783          	ld	a5,-512(s0)
    800045de:	0387879b          	addiw	a5,a5,56
    800045e2:	e8845703          	lhu	a4,-376(s0)
    800045e6:	e0e6d2e3          	bge	a3,a4,800043ea <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045ea:	2781                	sext.w	a5,a5
    800045ec:	e0f43023          	sd	a5,-512(s0)
    800045f0:	03800713          	li	a4,56
    800045f4:	86be                	mv	a3,a5
    800045f6:	e1840613          	addi	a2,s0,-488
    800045fa:	4581                	li	a1,0
    800045fc:	8556                	mv	a0,s5
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	a44080e7          	jalr	-1468(ra) # 80003042 <readi>
    80004606:	03800793          	li	a5,56
    8000460a:	f6f51be3          	bne	a0,a5,80004580 <exec+0x2ea>
    if(ph.type != ELF_PROG_LOAD)
    8000460e:	e1842783          	lw	a5,-488(s0)
    80004612:	4705                	li	a4,1
    80004614:	fae79de3          	bne	a5,a4,800045ce <exec+0x338>
    if(ph.memsz < ph.filesz)
    80004618:	e4043483          	ld	s1,-448(s0)
    8000461c:	e3843783          	ld	a5,-456(s0)
    80004620:	f6f4ede3          	bltu	s1,a5,8000459a <exec+0x304>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004624:	e2843783          	ld	a5,-472(s0)
    80004628:	94be                	add	s1,s1,a5
    8000462a:	f6f4ebe3          	bltu	s1,a5,800045a0 <exec+0x30a>
    if(ph.vaddr % PGSIZE != 0)
    8000462e:	de043703          	ld	a4,-544(s0)
    80004632:	8ff9                	and	a5,a5,a4
    80004634:	fbad                	bnez	a5,800045a6 <exec+0x310>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004636:	e1c42503          	lw	a0,-484(s0)
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	c40080e7          	jalr	-960(ra) # 8000427a <flags2perm>
    80004642:	86aa                	mv	a3,a0
    80004644:	8626                	mv	a2,s1
    80004646:	85ca                	mv	a1,s2
    80004648:	855a                	mv	a0,s6
    8000464a:	ffffc097          	auipc	ra,0xffffc
    8000464e:	26c080e7          	jalr	620(ra) # 800008b6 <uvmalloc>
    80004652:	dea43c23          	sd	a0,-520(s0)
    80004656:	d939                	beqz	a0,800045ac <exec+0x316>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004658:	e2843c03          	ld	s8,-472(s0)
    8000465c:	e2042c83          	lw	s9,-480(s0)
    80004660:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004664:	f60b83e3          	beqz	s7,800045ca <exec+0x334>
    80004668:	89de                	mv	s3,s7
    8000466a:	4481                	li	s1,0
    8000466c:	bbb1                	j	800043c8 <exec+0x132>

000000008000466e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000466e:	7179                	addi	sp,sp,-48
    80004670:	f406                	sd	ra,40(sp)
    80004672:	f022                	sd	s0,32(sp)
    80004674:	ec26                	sd	s1,24(sp)
    80004676:	e84a                	sd	s2,16(sp)
    80004678:	1800                	addi	s0,sp,48
    8000467a:	892e                	mv	s2,a1
    8000467c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000467e:	fdc40593          	addi	a1,s0,-36
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	ab6080e7          	jalr	-1354(ra) # 80002138 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000468a:	fdc42703          	lw	a4,-36(s0)
    8000468e:	47bd                	li	a5,15
    80004690:	02e7eb63          	bltu	a5,a4,800046c6 <argfd+0x58>
    80004694:	ffffd097          	auipc	ra,0xffffd
    80004698:	8b4080e7          	jalr	-1868(ra) # 80000f48 <myproc>
    8000469c:	fdc42703          	lw	a4,-36(s0)
    800046a0:	01a70793          	addi	a5,a4,26
    800046a4:	078e                	slli	a5,a5,0x3
    800046a6:	953e                	add	a0,a0,a5
    800046a8:	611c                	ld	a5,0(a0)
    800046aa:	c385                	beqz	a5,800046ca <argfd+0x5c>
    return -1;
  if(pfd)
    800046ac:	00090463          	beqz	s2,800046b4 <argfd+0x46>
    *pfd = fd;
    800046b0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046b4:	4501                	li	a0,0
  if(pf)
    800046b6:	c091                	beqz	s1,800046ba <argfd+0x4c>
    *pf = f;
    800046b8:	e09c                	sd	a5,0(s1)
}
    800046ba:	70a2                	ld	ra,40(sp)
    800046bc:	7402                	ld	s0,32(sp)
    800046be:	64e2                	ld	s1,24(sp)
    800046c0:	6942                	ld	s2,16(sp)
    800046c2:	6145                	addi	sp,sp,48
    800046c4:	8082                	ret
    return -1;
    800046c6:	557d                	li	a0,-1
    800046c8:	bfcd                	j	800046ba <argfd+0x4c>
    800046ca:	557d                	li	a0,-1
    800046cc:	b7fd                	j	800046ba <argfd+0x4c>

00000000800046ce <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046ce:	1101                	addi	sp,sp,-32
    800046d0:	ec06                	sd	ra,24(sp)
    800046d2:	e822                	sd	s0,16(sp)
    800046d4:	e426                	sd	s1,8(sp)
    800046d6:	1000                	addi	s0,sp,32
    800046d8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046da:	ffffd097          	auipc	ra,0xffffd
    800046de:	86e080e7          	jalr	-1938(ra) # 80000f48 <myproc>
    800046e2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046e4:	0d050793          	addi	a5,a0,208
    800046e8:	4501                	li	a0,0
    800046ea:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046ec:	6398                	ld	a4,0(a5)
    800046ee:	cb19                	beqz	a4,80004704 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046f0:	2505                	addiw	a0,a0,1
    800046f2:	07a1                	addi	a5,a5,8
    800046f4:	fed51ce3          	bne	a0,a3,800046ec <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046f8:	557d                	li	a0,-1
}
    800046fa:	60e2                	ld	ra,24(sp)
    800046fc:	6442                	ld	s0,16(sp)
    800046fe:	64a2                	ld	s1,8(sp)
    80004700:	6105                	addi	sp,sp,32
    80004702:	8082                	ret
      p->ofile[fd] = f;
    80004704:	01a50793          	addi	a5,a0,26
    80004708:	078e                	slli	a5,a5,0x3
    8000470a:	963e                	add	a2,a2,a5
    8000470c:	e204                	sd	s1,0(a2)
      return fd;
    8000470e:	b7f5                	j	800046fa <fdalloc+0x2c>

0000000080004710 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004710:	715d                	addi	sp,sp,-80
    80004712:	e486                	sd	ra,72(sp)
    80004714:	e0a2                	sd	s0,64(sp)
    80004716:	fc26                	sd	s1,56(sp)
    80004718:	f84a                	sd	s2,48(sp)
    8000471a:	f44e                	sd	s3,40(sp)
    8000471c:	f052                	sd	s4,32(sp)
    8000471e:	ec56                	sd	s5,24(sp)
    80004720:	e85a                	sd	s6,16(sp)
    80004722:	0880                	addi	s0,sp,80
    80004724:	8b2e                	mv	s6,a1
    80004726:	89b2                	mv	s3,a2
    80004728:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000472a:	fb040593          	addi	a1,s0,-80
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	e24080e7          	jalr	-476(ra) # 80003552 <nameiparent>
    80004736:	84aa                	mv	s1,a0
    80004738:	14050f63          	beqz	a0,80004896 <create+0x186>
    return 0;

  ilock(dp);
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	652080e7          	jalr	1618(ra) # 80002d8e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004744:	4601                	li	a2,0
    80004746:	fb040593          	addi	a1,s0,-80
    8000474a:	8526                	mv	a0,s1
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	b26080e7          	jalr	-1242(ra) # 80003272 <dirlookup>
    80004754:	8aaa                	mv	s5,a0
    80004756:	c931                	beqz	a0,800047aa <create+0x9a>
    iunlockput(dp);
    80004758:	8526                	mv	a0,s1
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	896080e7          	jalr	-1898(ra) # 80002ff0 <iunlockput>
    ilock(ip);
    80004762:	8556                	mv	a0,s5
    80004764:	ffffe097          	auipc	ra,0xffffe
    80004768:	62a080e7          	jalr	1578(ra) # 80002d8e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000476c:	000b059b          	sext.w	a1,s6
    80004770:	4789                	li	a5,2
    80004772:	02f59563          	bne	a1,a5,8000479c <create+0x8c>
    80004776:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd074>
    8000477a:	37f9                	addiw	a5,a5,-2
    8000477c:	17c2                	slli	a5,a5,0x30
    8000477e:	93c1                	srli	a5,a5,0x30
    80004780:	4705                	li	a4,1
    80004782:	00f76d63          	bltu	a4,a5,8000479c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004786:	8556                	mv	a0,s5
    80004788:	60a6                	ld	ra,72(sp)
    8000478a:	6406                	ld	s0,64(sp)
    8000478c:	74e2                	ld	s1,56(sp)
    8000478e:	7942                	ld	s2,48(sp)
    80004790:	79a2                	ld	s3,40(sp)
    80004792:	7a02                	ld	s4,32(sp)
    80004794:	6ae2                	ld	s5,24(sp)
    80004796:	6b42                	ld	s6,16(sp)
    80004798:	6161                	addi	sp,sp,80
    8000479a:	8082                	ret
    iunlockput(ip);
    8000479c:	8556                	mv	a0,s5
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	852080e7          	jalr	-1966(ra) # 80002ff0 <iunlockput>
    return 0;
    800047a6:	4a81                	li	s5,0
    800047a8:	bff9                	j	80004786 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800047aa:	85da                	mv	a1,s6
    800047ac:	4088                	lw	a0,0(s1)
    800047ae:	ffffe097          	auipc	ra,0xffffe
    800047b2:	444080e7          	jalr	1092(ra) # 80002bf2 <ialloc>
    800047b6:	8a2a                	mv	s4,a0
    800047b8:	c539                	beqz	a0,80004806 <create+0xf6>
  ilock(ip);
    800047ba:	ffffe097          	auipc	ra,0xffffe
    800047be:	5d4080e7          	jalr	1492(ra) # 80002d8e <ilock>
  ip->major = major;
    800047c2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047c6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047ca:	4905                	li	s2,1
    800047cc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800047d0:	8552                	mv	a0,s4
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	4f2080e7          	jalr	1266(ra) # 80002cc4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047da:	000b059b          	sext.w	a1,s6
    800047de:	03258b63          	beq	a1,s2,80004814 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800047e2:	004a2603          	lw	a2,4(s4)
    800047e6:	fb040593          	addi	a1,s0,-80
    800047ea:	8526                	mv	a0,s1
    800047ec:	fffff097          	auipc	ra,0xfffff
    800047f0:	c96080e7          	jalr	-874(ra) # 80003482 <dirlink>
    800047f4:	06054f63          	bltz	a0,80004872 <create+0x162>
  iunlockput(dp);
    800047f8:	8526                	mv	a0,s1
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	7f6080e7          	jalr	2038(ra) # 80002ff0 <iunlockput>
  return ip;
    80004802:	8ad2                	mv	s5,s4
    80004804:	b749                	j	80004786 <create+0x76>
    iunlockput(dp);
    80004806:	8526                	mv	a0,s1
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	7e8080e7          	jalr	2024(ra) # 80002ff0 <iunlockput>
    return 0;
    80004810:	8ad2                	mv	s5,s4
    80004812:	bf95                	j	80004786 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004814:	004a2603          	lw	a2,4(s4)
    80004818:	00004597          	auipc	a1,0x4
    8000481c:	ed858593          	addi	a1,a1,-296 # 800086f0 <syscalls+0x2e8>
    80004820:	8552                	mv	a0,s4
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	c60080e7          	jalr	-928(ra) # 80003482 <dirlink>
    8000482a:	04054463          	bltz	a0,80004872 <create+0x162>
    8000482e:	40d0                	lw	a2,4(s1)
    80004830:	00004597          	auipc	a1,0x4
    80004834:	92858593          	addi	a1,a1,-1752 # 80008158 <etext+0x158>
    80004838:	8552                	mv	a0,s4
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	c48080e7          	jalr	-952(ra) # 80003482 <dirlink>
    80004842:	02054863          	bltz	a0,80004872 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004846:	004a2603          	lw	a2,4(s4)
    8000484a:	fb040593          	addi	a1,s0,-80
    8000484e:	8526                	mv	a0,s1
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	c32080e7          	jalr	-974(ra) # 80003482 <dirlink>
    80004858:	00054d63          	bltz	a0,80004872 <create+0x162>
    dp->nlink++;  // for ".."
    8000485c:	04a4d783          	lhu	a5,74(s1)
    80004860:	2785                	addiw	a5,a5,1
    80004862:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004866:	8526                	mv	a0,s1
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	45c080e7          	jalr	1116(ra) # 80002cc4 <iupdate>
    80004870:	b761                	j	800047f8 <create+0xe8>
  ip->nlink = 0;
    80004872:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004876:	8552                	mv	a0,s4
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	44c080e7          	jalr	1100(ra) # 80002cc4 <iupdate>
  iunlockput(ip);
    80004880:	8552                	mv	a0,s4
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	76e080e7          	jalr	1902(ra) # 80002ff0 <iunlockput>
  iunlockput(dp);
    8000488a:	8526                	mv	a0,s1
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	764080e7          	jalr	1892(ra) # 80002ff0 <iunlockput>
  return 0;
    80004894:	bdcd                	j	80004786 <create+0x76>
    return 0;
    80004896:	8aaa                	mv	s5,a0
    80004898:	b5fd                	j	80004786 <create+0x76>

000000008000489a <sys_dup>:
{
    8000489a:	7179                	addi	sp,sp,-48
    8000489c:	f406                	sd	ra,40(sp)
    8000489e:	f022                	sd	s0,32(sp)
    800048a0:	ec26                	sd	s1,24(sp)
    800048a2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048a4:	fd840613          	addi	a2,s0,-40
    800048a8:	4581                	li	a1,0
    800048aa:	4501                	li	a0,0
    800048ac:	00000097          	auipc	ra,0x0
    800048b0:	dc2080e7          	jalr	-574(ra) # 8000466e <argfd>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048b6:	02054363          	bltz	a0,800048dc <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800048ba:	fd843503          	ld	a0,-40(s0)
    800048be:	00000097          	auipc	ra,0x0
    800048c2:	e10080e7          	jalr	-496(ra) # 800046ce <fdalloc>
    800048c6:	84aa                	mv	s1,a0
    return -1;
    800048c8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048ca:	00054963          	bltz	a0,800048dc <sys_dup+0x42>
  filedup(f);
    800048ce:	fd843503          	ld	a0,-40(s0)
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	2f8080e7          	jalr	760(ra) # 80003bca <filedup>
  return fd;
    800048da:	87a6                	mv	a5,s1
}
    800048dc:	853e                	mv	a0,a5
    800048de:	70a2                	ld	ra,40(sp)
    800048e0:	7402                	ld	s0,32(sp)
    800048e2:	64e2                	ld	s1,24(sp)
    800048e4:	6145                	addi	sp,sp,48
    800048e6:	8082                	ret

00000000800048e8 <sys_read>:
{
    800048e8:	7179                	addi	sp,sp,-48
    800048ea:	f406                	sd	ra,40(sp)
    800048ec:	f022                	sd	s0,32(sp)
    800048ee:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048f0:	fd840593          	addi	a1,s0,-40
    800048f4:	4505                	li	a0,1
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	862080e7          	jalr	-1950(ra) # 80002158 <argaddr>
  argint(2, &n);
    800048fe:	fe440593          	addi	a1,s0,-28
    80004902:	4509                	li	a0,2
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	834080e7          	jalr	-1996(ra) # 80002138 <argint>
  if(argfd(0, 0, &f) < 0)
    8000490c:	fe840613          	addi	a2,s0,-24
    80004910:	4581                	li	a1,0
    80004912:	4501                	li	a0,0
    80004914:	00000097          	auipc	ra,0x0
    80004918:	d5a080e7          	jalr	-678(ra) # 8000466e <argfd>
    8000491c:	87aa                	mv	a5,a0
    return -1;
    8000491e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004920:	0007cc63          	bltz	a5,80004938 <sys_read+0x50>
  return fileread(f, p, n);
    80004924:	fe442603          	lw	a2,-28(s0)
    80004928:	fd843583          	ld	a1,-40(s0)
    8000492c:	fe843503          	ld	a0,-24(s0)
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	426080e7          	jalr	1062(ra) # 80003d56 <fileread>
}
    80004938:	70a2                	ld	ra,40(sp)
    8000493a:	7402                	ld	s0,32(sp)
    8000493c:	6145                	addi	sp,sp,48
    8000493e:	8082                	ret

0000000080004940 <sys_write>:
{
    80004940:	7179                	addi	sp,sp,-48
    80004942:	f406                	sd	ra,40(sp)
    80004944:	f022                	sd	s0,32(sp)
    80004946:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004948:	fd840593          	addi	a1,s0,-40
    8000494c:	4505                	li	a0,1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	80a080e7          	jalr	-2038(ra) # 80002158 <argaddr>
  argint(2, &n);
    80004956:	fe440593          	addi	a1,s0,-28
    8000495a:	4509                	li	a0,2
    8000495c:	ffffd097          	auipc	ra,0xffffd
    80004960:	7dc080e7          	jalr	2012(ra) # 80002138 <argint>
  if(argfd(0, 0, &f) < 0)
    80004964:	fe840613          	addi	a2,s0,-24
    80004968:	4581                	li	a1,0
    8000496a:	4501                	li	a0,0
    8000496c:	00000097          	auipc	ra,0x0
    80004970:	d02080e7          	jalr	-766(ra) # 8000466e <argfd>
    80004974:	87aa                	mv	a5,a0
    return -1;
    80004976:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004978:	0007cc63          	bltz	a5,80004990 <sys_write+0x50>
  return filewrite(f, p, n);
    8000497c:	fe442603          	lw	a2,-28(s0)
    80004980:	fd843583          	ld	a1,-40(s0)
    80004984:	fe843503          	ld	a0,-24(s0)
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	490080e7          	jalr	1168(ra) # 80003e18 <filewrite>
}
    80004990:	70a2                	ld	ra,40(sp)
    80004992:	7402                	ld	s0,32(sp)
    80004994:	6145                	addi	sp,sp,48
    80004996:	8082                	ret

0000000080004998 <sys_close>:
{
    80004998:	1101                	addi	sp,sp,-32
    8000499a:	ec06                	sd	ra,24(sp)
    8000499c:	e822                	sd	s0,16(sp)
    8000499e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049a0:	fe040613          	addi	a2,s0,-32
    800049a4:	fec40593          	addi	a1,s0,-20
    800049a8:	4501                	li	a0,0
    800049aa:	00000097          	auipc	ra,0x0
    800049ae:	cc4080e7          	jalr	-828(ra) # 8000466e <argfd>
    return -1;
    800049b2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049b4:	02054463          	bltz	a0,800049dc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049b8:	ffffc097          	auipc	ra,0xffffc
    800049bc:	590080e7          	jalr	1424(ra) # 80000f48 <myproc>
    800049c0:	fec42783          	lw	a5,-20(s0)
    800049c4:	07e9                	addi	a5,a5,26
    800049c6:	078e                	slli	a5,a5,0x3
    800049c8:	97aa                	add	a5,a5,a0
    800049ca:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800049ce:	fe043503          	ld	a0,-32(s0)
    800049d2:	fffff097          	auipc	ra,0xfffff
    800049d6:	24a080e7          	jalr	586(ra) # 80003c1c <fileclose>
  return 0;
    800049da:	4781                	li	a5,0
}
    800049dc:	853e                	mv	a0,a5
    800049de:	60e2                	ld	ra,24(sp)
    800049e0:	6442                	ld	s0,16(sp)
    800049e2:	6105                	addi	sp,sp,32
    800049e4:	8082                	ret

00000000800049e6 <sys_fstat>:
{
    800049e6:	1101                	addi	sp,sp,-32
    800049e8:	ec06                	sd	ra,24(sp)
    800049ea:	e822                	sd	s0,16(sp)
    800049ec:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049ee:	fe040593          	addi	a1,s0,-32
    800049f2:	4505                	li	a0,1
    800049f4:	ffffd097          	auipc	ra,0xffffd
    800049f8:	764080e7          	jalr	1892(ra) # 80002158 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049fc:	fe840613          	addi	a2,s0,-24
    80004a00:	4581                	li	a1,0
    80004a02:	4501                	li	a0,0
    80004a04:	00000097          	auipc	ra,0x0
    80004a08:	c6a080e7          	jalr	-918(ra) # 8000466e <argfd>
    80004a0c:	87aa                	mv	a5,a0
    return -1;
    80004a0e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a10:	0007ca63          	bltz	a5,80004a24 <sys_fstat+0x3e>
  return filestat(f, st);
    80004a14:	fe043583          	ld	a1,-32(s0)
    80004a18:	fe843503          	ld	a0,-24(s0)
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	2c8080e7          	jalr	712(ra) # 80003ce4 <filestat>
}
    80004a24:	60e2                	ld	ra,24(sp)
    80004a26:	6442                	ld	s0,16(sp)
    80004a28:	6105                	addi	sp,sp,32
    80004a2a:	8082                	ret

0000000080004a2c <sys_link>:
{
    80004a2c:	7169                	addi	sp,sp,-304
    80004a2e:	f606                	sd	ra,296(sp)
    80004a30:	f222                	sd	s0,288(sp)
    80004a32:	ee26                	sd	s1,280(sp)
    80004a34:	ea4a                	sd	s2,272(sp)
    80004a36:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a38:	08000613          	li	a2,128
    80004a3c:	ed040593          	addi	a1,s0,-304
    80004a40:	4501                	li	a0,0
    80004a42:	ffffd097          	auipc	ra,0xffffd
    80004a46:	736080e7          	jalr	1846(ra) # 80002178 <argstr>
    return -1;
    80004a4a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a4c:	10054e63          	bltz	a0,80004b68 <sys_link+0x13c>
    80004a50:	08000613          	li	a2,128
    80004a54:	f5040593          	addi	a1,s0,-176
    80004a58:	4505                	li	a0,1
    80004a5a:	ffffd097          	auipc	ra,0xffffd
    80004a5e:	71e080e7          	jalr	1822(ra) # 80002178 <argstr>
    return -1;
    80004a62:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a64:	10054263          	bltz	a0,80004b68 <sys_link+0x13c>
  begin_op();
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	ce8080e7          	jalr	-792(ra) # 80003750 <begin_op>
  if((ip = namei(old)) == 0){
    80004a70:	ed040513          	addi	a0,s0,-304
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	ac0080e7          	jalr	-1344(ra) # 80003534 <namei>
    80004a7c:	84aa                	mv	s1,a0
    80004a7e:	c551                	beqz	a0,80004b0a <sys_link+0xde>
  ilock(ip);
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	30e080e7          	jalr	782(ra) # 80002d8e <ilock>
  if(ip->type == T_DIR){
    80004a88:	04449703          	lh	a4,68(s1)
    80004a8c:	4785                	li	a5,1
    80004a8e:	08f70463          	beq	a4,a5,80004b16 <sys_link+0xea>
  ip->nlink++;
    80004a92:	04a4d783          	lhu	a5,74(s1)
    80004a96:	2785                	addiw	a5,a5,1
    80004a98:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	226080e7          	jalr	550(ra) # 80002cc4 <iupdate>
  iunlock(ip);
    80004aa6:	8526                	mv	a0,s1
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	3a8080e7          	jalr	936(ra) # 80002e50 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ab0:	fd040593          	addi	a1,s0,-48
    80004ab4:	f5040513          	addi	a0,s0,-176
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	a9a080e7          	jalr	-1382(ra) # 80003552 <nameiparent>
    80004ac0:	892a                	mv	s2,a0
    80004ac2:	c935                	beqz	a0,80004b36 <sys_link+0x10a>
  ilock(dp);
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	2ca080e7          	jalr	714(ra) # 80002d8e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004acc:	00092703          	lw	a4,0(s2)
    80004ad0:	409c                	lw	a5,0(s1)
    80004ad2:	04f71d63          	bne	a4,a5,80004b2c <sys_link+0x100>
    80004ad6:	40d0                	lw	a2,4(s1)
    80004ad8:	fd040593          	addi	a1,s0,-48
    80004adc:	854a                	mv	a0,s2
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	9a4080e7          	jalr	-1628(ra) # 80003482 <dirlink>
    80004ae6:	04054363          	bltz	a0,80004b2c <sys_link+0x100>
  iunlockput(dp);
    80004aea:	854a                	mv	a0,s2
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	504080e7          	jalr	1284(ra) # 80002ff0 <iunlockput>
  iput(ip);
    80004af4:	8526                	mv	a0,s1
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	452080e7          	jalr	1106(ra) # 80002f48 <iput>
  end_op();
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	cd2080e7          	jalr	-814(ra) # 800037d0 <end_op>
  return 0;
    80004b06:	4781                	li	a5,0
    80004b08:	a085                	j	80004b68 <sys_link+0x13c>
    end_op();
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	cc6080e7          	jalr	-826(ra) # 800037d0 <end_op>
    return -1;
    80004b12:	57fd                	li	a5,-1
    80004b14:	a891                	j	80004b68 <sys_link+0x13c>
    iunlockput(ip);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	4d8080e7          	jalr	1240(ra) # 80002ff0 <iunlockput>
    end_op();
    80004b20:	fffff097          	auipc	ra,0xfffff
    80004b24:	cb0080e7          	jalr	-848(ra) # 800037d0 <end_op>
    return -1;
    80004b28:	57fd                	li	a5,-1
    80004b2a:	a83d                	j	80004b68 <sys_link+0x13c>
    iunlockput(dp);
    80004b2c:	854a                	mv	a0,s2
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	4c2080e7          	jalr	1218(ra) # 80002ff0 <iunlockput>
  ilock(ip);
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	256080e7          	jalr	598(ra) # 80002d8e <ilock>
  ip->nlink--;
    80004b40:	04a4d783          	lhu	a5,74(s1)
    80004b44:	37fd                	addiw	a5,a5,-1
    80004b46:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b4a:	8526                	mv	a0,s1
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	178080e7          	jalr	376(ra) # 80002cc4 <iupdate>
  iunlockput(ip);
    80004b54:	8526                	mv	a0,s1
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	49a080e7          	jalr	1178(ra) # 80002ff0 <iunlockput>
  end_op();
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	c72080e7          	jalr	-910(ra) # 800037d0 <end_op>
  return -1;
    80004b66:	57fd                	li	a5,-1
}
    80004b68:	853e                	mv	a0,a5
    80004b6a:	70b2                	ld	ra,296(sp)
    80004b6c:	7412                	ld	s0,288(sp)
    80004b6e:	64f2                	ld	s1,280(sp)
    80004b70:	6952                	ld	s2,272(sp)
    80004b72:	6155                	addi	sp,sp,304
    80004b74:	8082                	ret

0000000080004b76 <sys_unlink>:
{
    80004b76:	7151                	addi	sp,sp,-240
    80004b78:	f586                	sd	ra,232(sp)
    80004b7a:	f1a2                	sd	s0,224(sp)
    80004b7c:	eda6                	sd	s1,216(sp)
    80004b7e:	e9ca                	sd	s2,208(sp)
    80004b80:	e5ce                	sd	s3,200(sp)
    80004b82:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b84:	08000613          	li	a2,128
    80004b88:	f3040593          	addi	a1,s0,-208
    80004b8c:	4501                	li	a0,0
    80004b8e:	ffffd097          	auipc	ra,0xffffd
    80004b92:	5ea080e7          	jalr	1514(ra) # 80002178 <argstr>
    80004b96:	18054163          	bltz	a0,80004d18 <sys_unlink+0x1a2>
  begin_op();
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	bb6080e7          	jalr	-1098(ra) # 80003750 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ba2:	fb040593          	addi	a1,s0,-80
    80004ba6:	f3040513          	addi	a0,s0,-208
    80004baa:	fffff097          	auipc	ra,0xfffff
    80004bae:	9a8080e7          	jalr	-1624(ra) # 80003552 <nameiparent>
    80004bb2:	84aa                	mv	s1,a0
    80004bb4:	c979                	beqz	a0,80004c8a <sys_unlink+0x114>
  ilock(dp);
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	1d8080e7          	jalr	472(ra) # 80002d8e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bbe:	00004597          	auipc	a1,0x4
    80004bc2:	b3258593          	addi	a1,a1,-1230 # 800086f0 <syscalls+0x2e8>
    80004bc6:	fb040513          	addi	a0,s0,-80
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	68e080e7          	jalr	1678(ra) # 80003258 <namecmp>
    80004bd2:	14050a63          	beqz	a0,80004d26 <sys_unlink+0x1b0>
    80004bd6:	00003597          	auipc	a1,0x3
    80004bda:	58258593          	addi	a1,a1,1410 # 80008158 <etext+0x158>
    80004bde:	fb040513          	addi	a0,s0,-80
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	676080e7          	jalr	1654(ra) # 80003258 <namecmp>
    80004bea:	12050e63          	beqz	a0,80004d26 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bee:	f2c40613          	addi	a2,s0,-212
    80004bf2:	fb040593          	addi	a1,s0,-80
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	67a080e7          	jalr	1658(ra) # 80003272 <dirlookup>
    80004c00:	892a                	mv	s2,a0
    80004c02:	12050263          	beqz	a0,80004d26 <sys_unlink+0x1b0>
  ilock(ip);
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	188080e7          	jalr	392(ra) # 80002d8e <ilock>
  if(ip->nlink < 1)
    80004c0e:	04a91783          	lh	a5,74(s2)
    80004c12:	08f05263          	blez	a5,80004c96 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c16:	04491703          	lh	a4,68(s2)
    80004c1a:	4785                	li	a5,1
    80004c1c:	08f70563          	beq	a4,a5,80004ca6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c20:	4641                	li	a2,16
    80004c22:	4581                	li	a1,0
    80004c24:	fc040513          	addi	a0,s0,-64
    80004c28:	ffffb097          	auipc	ra,0xffffb
    80004c2c:	550080e7          	jalr	1360(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c30:	4741                	li	a4,16
    80004c32:	f2c42683          	lw	a3,-212(s0)
    80004c36:	fc040613          	addi	a2,s0,-64
    80004c3a:	4581                	li	a1,0
    80004c3c:	8526                	mv	a0,s1
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	4fc080e7          	jalr	1276(ra) # 8000313a <writei>
    80004c46:	47c1                	li	a5,16
    80004c48:	0af51563          	bne	a0,a5,80004cf2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c4c:	04491703          	lh	a4,68(s2)
    80004c50:	4785                	li	a5,1
    80004c52:	0af70863          	beq	a4,a5,80004d02 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	398080e7          	jalr	920(ra) # 80002ff0 <iunlockput>
  ip->nlink--;
    80004c60:	04a95783          	lhu	a5,74(s2)
    80004c64:	37fd                	addiw	a5,a5,-1
    80004c66:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c6a:	854a                	mv	a0,s2
    80004c6c:	ffffe097          	auipc	ra,0xffffe
    80004c70:	058080e7          	jalr	88(ra) # 80002cc4 <iupdate>
  iunlockput(ip);
    80004c74:	854a                	mv	a0,s2
    80004c76:	ffffe097          	auipc	ra,0xffffe
    80004c7a:	37a080e7          	jalr	890(ra) # 80002ff0 <iunlockput>
  end_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	b52080e7          	jalr	-1198(ra) # 800037d0 <end_op>
  return 0;
    80004c86:	4501                	li	a0,0
    80004c88:	a84d                	j	80004d3a <sys_unlink+0x1c4>
    end_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	b46080e7          	jalr	-1210(ra) # 800037d0 <end_op>
    return -1;
    80004c92:	557d                	li	a0,-1
    80004c94:	a05d                	j	80004d3a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c96:	00004517          	auipc	a0,0x4
    80004c9a:	a6250513          	addi	a0,a0,-1438 # 800086f8 <syscalls+0x2f0>
    80004c9e:	00001097          	auipc	ra,0x1
    80004ca2:	1b2080e7          	jalr	434(ra) # 80005e50 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ca6:	04c92703          	lw	a4,76(s2)
    80004caa:	02000793          	li	a5,32
    80004cae:	f6e7f9e3          	bgeu	a5,a4,80004c20 <sys_unlink+0xaa>
    80004cb2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cb6:	4741                	li	a4,16
    80004cb8:	86ce                	mv	a3,s3
    80004cba:	f1840613          	addi	a2,s0,-232
    80004cbe:	4581                	li	a1,0
    80004cc0:	854a                	mv	a0,s2
    80004cc2:	ffffe097          	auipc	ra,0xffffe
    80004cc6:	380080e7          	jalr	896(ra) # 80003042 <readi>
    80004cca:	47c1                	li	a5,16
    80004ccc:	00f51b63          	bne	a0,a5,80004ce2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cd0:	f1845783          	lhu	a5,-232(s0)
    80004cd4:	e7a1                	bnez	a5,80004d1c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cd6:	29c1                	addiw	s3,s3,16
    80004cd8:	04c92783          	lw	a5,76(s2)
    80004cdc:	fcf9ede3          	bltu	s3,a5,80004cb6 <sys_unlink+0x140>
    80004ce0:	b781                	j	80004c20 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ce2:	00004517          	auipc	a0,0x4
    80004ce6:	a2e50513          	addi	a0,a0,-1490 # 80008710 <syscalls+0x308>
    80004cea:	00001097          	auipc	ra,0x1
    80004cee:	166080e7          	jalr	358(ra) # 80005e50 <panic>
    panic("unlink: writei");
    80004cf2:	00004517          	auipc	a0,0x4
    80004cf6:	a3650513          	addi	a0,a0,-1482 # 80008728 <syscalls+0x320>
    80004cfa:	00001097          	auipc	ra,0x1
    80004cfe:	156080e7          	jalr	342(ra) # 80005e50 <panic>
    dp->nlink--;
    80004d02:	04a4d783          	lhu	a5,74(s1)
    80004d06:	37fd                	addiw	a5,a5,-1
    80004d08:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d0c:	8526                	mv	a0,s1
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	fb6080e7          	jalr	-74(ra) # 80002cc4 <iupdate>
    80004d16:	b781                	j	80004c56 <sys_unlink+0xe0>
    return -1;
    80004d18:	557d                	li	a0,-1
    80004d1a:	a005                	j	80004d3a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d1c:	854a                	mv	a0,s2
    80004d1e:	ffffe097          	auipc	ra,0xffffe
    80004d22:	2d2080e7          	jalr	722(ra) # 80002ff0 <iunlockput>
  iunlockput(dp);
    80004d26:	8526                	mv	a0,s1
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	2c8080e7          	jalr	712(ra) # 80002ff0 <iunlockput>
  end_op();
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	aa0080e7          	jalr	-1376(ra) # 800037d0 <end_op>
  return -1;
    80004d38:	557d                	li	a0,-1
}
    80004d3a:	70ae                	ld	ra,232(sp)
    80004d3c:	740e                	ld	s0,224(sp)
    80004d3e:	64ee                	ld	s1,216(sp)
    80004d40:	694e                	ld	s2,208(sp)
    80004d42:	69ae                	ld	s3,200(sp)
    80004d44:	616d                	addi	sp,sp,240
    80004d46:	8082                	ret

0000000080004d48 <sys_open>:

uint64
sys_open(void)
{
    80004d48:	7131                	addi	sp,sp,-192
    80004d4a:	fd06                	sd	ra,184(sp)
    80004d4c:	f922                	sd	s0,176(sp)
    80004d4e:	f526                	sd	s1,168(sp)
    80004d50:	f14a                	sd	s2,160(sp)
    80004d52:	ed4e                	sd	s3,152(sp)
    80004d54:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d56:	f4c40593          	addi	a1,s0,-180
    80004d5a:	4505                	li	a0,1
    80004d5c:	ffffd097          	auipc	ra,0xffffd
    80004d60:	3dc080e7          	jalr	988(ra) # 80002138 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d64:	08000613          	li	a2,128
    80004d68:	f5040593          	addi	a1,s0,-176
    80004d6c:	4501                	li	a0,0
    80004d6e:	ffffd097          	auipc	ra,0xffffd
    80004d72:	40a080e7          	jalr	1034(ra) # 80002178 <argstr>
    80004d76:	87aa                	mv	a5,a0
    return -1;
    80004d78:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d7a:	0a07c963          	bltz	a5,80004e2c <sys_open+0xe4>

  begin_op();
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	9d2080e7          	jalr	-1582(ra) # 80003750 <begin_op>

  if(omode & O_CREATE){
    80004d86:	f4c42783          	lw	a5,-180(s0)
    80004d8a:	2007f793          	andi	a5,a5,512
    80004d8e:	cfc5                	beqz	a5,80004e46 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d90:	4681                	li	a3,0
    80004d92:	4601                	li	a2,0
    80004d94:	4589                	li	a1,2
    80004d96:	f5040513          	addi	a0,s0,-176
    80004d9a:	00000097          	auipc	ra,0x0
    80004d9e:	976080e7          	jalr	-1674(ra) # 80004710 <create>
    80004da2:	84aa                	mv	s1,a0
    if(ip == 0){
    80004da4:	c959                	beqz	a0,80004e3a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004da6:	04449703          	lh	a4,68(s1)
    80004daa:	478d                	li	a5,3
    80004dac:	00f71763          	bne	a4,a5,80004dba <sys_open+0x72>
    80004db0:	0464d703          	lhu	a4,70(s1)
    80004db4:	47a5                	li	a5,9
    80004db6:	0ce7ed63          	bltu	a5,a4,80004e90 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	da6080e7          	jalr	-602(ra) # 80003b60 <filealloc>
    80004dc2:	89aa                	mv	s3,a0
    80004dc4:	10050363          	beqz	a0,80004eca <sys_open+0x182>
    80004dc8:	00000097          	auipc	ra,0x0
    80004dcc:	906080e7          	jalr	-1786(ra) # 800046ce <fdalloc>
    80004dd0:	892a                	mv	s2,a0
    80004dd2:	0e054763          	bltz	a0,80004ec0 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dd6:	04449703          	lh	a4,68(s1)
    80004dda:	478d                	li	a5,3
    80004ddc:	0cf70563          	beq	a4,a5,80004ea6 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004de0:	4789                	li	a5,2
    80004de2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004de6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dea:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dee:	f4c42783          	lw	a5,-180(s0)
    80004df2:	0017c713          	xori	a4,a5,1
    80004df6:	8b05                	andi	a4,a4,1
    80004df8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dfc:	0037f713          	andi	a4,a5,3
    80004e00:	00e03733          	snez	a4,a4
    80004e04:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e08:	4007f793          	andi	a5,a5,1024
    80004e0c:	c791                	beqz	a5,80004e18 <sys_open+0xd0>
    80004e0e:	04449703          	lh	a4,68(s1)
    80004e12:	4789                	li	a5,2
    80004e14:	0af70063          	beq	a4,a5,80004eb4 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e18:	8526                	mv	a0,s1
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	036080e7          	jalr	54(ra) # 80002e50 <iunlock>
  end_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	9ae080e7          	jalr	-1618(ra) # 800037d0 <end_op>

  return fd;
    80004e2a:	854a                	mv	a0,s2
}
    80004e2c:	70ea                	ld	ra,184(sp)
    80004e2e:	744a                	ld	s0,176(sp)
    80004e30:	74aa                	ld	s1,168(sp)
    80004e32:	790a                	ld	s2,160(sp)
    80004e34:	69ea                	ld	s3,152(sp)
    80004e36:	6129                	addi	sp,sp,192
    80004e38:	8082                	ret
      end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	996080e7          	jalr	-1642(ra) # 800037d0 <end_op>
      return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	b7e5                	j	80004e2c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e46:	f5040513          	addi	a0,s0,-176
    80004e4a:	ffffe097          	auipc	ra,0xffffe
    80004e4e:	6ea080e7          	jalr	1770(ra) # 80003534 <namei>
    80004e52:	84aa                	mv	s1,a0
    80004e54:	c905                	beqz	a0,80004e84 <sys_open+0x13c>
    ilock(ip);
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	f38080e7          	jalr	-200(ra) # 80002d8e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e5e:	04449703          	lh	a4,68(s1)
    80004e62:	4785                	li	a5,1
    80004e64:	f4f711e3          	bne	a4,a5,80004da6 <sys_open+0x5e>
    80004e68:	f4c42783          	lw	a5,-180(s0)
    80004e6c:	d7b9                	beqz	a5,80004dba <sys_open+0x72>
      iunlockput(ip);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	180080e7          	jalr	384(ra) # 80002ff0 <iunlockput>
      end_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	958080e7          	jalr	-1704(ra) # 800037d0 <end_op>
      return -1;
    80004e80:	557d                	li	a0,-1
    80004e82:	b76d                	j	80004e2c <sys_open+0xe4>
      end_op();
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	94c080e7          	jalr	-1716(ra) # 800037d0 <end_op>
      return -1;
    80004e8c:	557d                	li	a0,-1
    80004e8e:	bf79                	j	80004e2c <sys_open+0xe4>
    iunlockput(ip);
    80004e90:	8526                	mv	a0,s1
    80004e92:	ffffe097          	auipc	ra,0xffffe
    80004e96:	15e080e7          	jalr	350(ra) # 80002ff0 <iunlockput>
    end_op();
    80004e9a:	fffff097          	auipc	ra,0xfffff
    80004e9e:	936080e7          	jalr	-1738(ra) # 800037d0 <end_op>
    return -1;
    80004ea2:	557d                	li	a0,-1
    80004ea4:	b761                	j	80004e2c <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ea6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004eaa:	04649783          	lh	a5,70(s1)
    80004eae:	02f99223          	sh	a5,36(s3)
    80004eb2:	bf25                	j	80004dea <sys_open+0xa2>
    itrunc(ip);
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	fe6080e7          	jalr	-26(ra) # 80002e9c <itrunc>
    80004ebe:	bfa9                	j	80004e18 <sys_open+0xd0>
      fileclose(f);
    80004ec0:	854e                	mv	a0,s3
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	d5a080e7          	jalr	-678(ra) # 80003c1c <fileclose>
    iunlockput(ip);
    80004eca:	8526                	mv	a0,s1
    80004ecc:	ffffe097          	auipc	ra,0xffffe
    80004ed0:	124080e7          	jalr	292(ra) # 80002ff0 <iunlockput>
    end_op();
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	8fc080e7          	jalr	-1796(ra) # 800037d0 <end_op>
    return -1;
    80004edc:	557d                	li	a0,-1
    80004ede:	b7b9                	j	80004e2c <sys_open+0xe4>

0000000080004ee0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ee0:	7175                	addi	sp,sp,-144
    80004ee2:	e506                	sd	ra,136(sp)
    80004ee4:	e122                	sd	s0,128(sp)
    80004ee6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ee8:	fffff097          	auipc	ra,0xfffff
    80004eec:	868080e7          	jalr	-1944(ra) # 80003750 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ef0:	08000613          	li	a2,128
    80004ef4:	f7040593          	addi	a1,s0,-144
    80004ef8:	4501                	li	a0,0
    80004efa:	ffffd097          	auipc	ra,0xffffd
    80004efe:	27e080e7          	jalr	638(ra) # 80002178 <argstr>
    80004f02:	02054963          	bltz	a0,80004f34 <sys_mkdir+0x54>
    80004f06:	4681                	li	a3,0
    80004f08:	4601                	li	a2,0
    80004f0a:	4585                	li	a1,1
    80004f0c:	f7040513          	addi	a0,s0,-144
    80004f10:	00000097          	auipc	ra,0x0
    80004f14:	800080e7          	jalr	-2048(ra) # 80004710 <create>
    80004f18:	cd11                	beqz	a0,80004f34 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f1a:	ffffe097          	auipc	ra,0xffffe
    80004f1e:	0d6080e7          	jalr	214(ra) # 80002ff0 <iunlockput>
  end_op();
    80004f22:	fffff097          	auipc	ra,0xfffff
    80004f26:	8ae080e7          	jalr	-1874(ra) # 800037d0 <end_op>
  return 0;
    80004f2a:	4501                	li	a0,0
}
    80004f2c:	60aa                	ld	ra,136(sp)
    80004f2e:	640a                	ld	s0,128(sp)
    80004f30:	6149                	addi	sp,sp,144
    80004f32:	8082                	ret
    end_op();
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	89c080e7          	jalr	-1892(ra) # 800037d0 <end_op>
    return -1;
    80004f3c:	557d                	li	a0,-1
    80004f3e:	b7fd                	j	80004f2c <sys_mkdir+0x4c>

0000000080004f40 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f40:	7135                	addi	sp,sp,-160
    80004f42:	ed06                	sd	ra,152(sp)
    80004f44:	e922                	sd	s0,144(sp)
    80004f46:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	808080e7          	jalr	-2040(ra) # 80003750 <begin_op>
  argint(1, &major);
    80004f50:	f6c40593          	addi	a1,s0,-148
    80004f54:	4505                	li	a0,1
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	1e2080e7          	jalr	482(ra) # 80002138 <argint>
  argint(2, &minor);
    80004f5e:	f6840593          	addi	a1,s0,-152
    80004f62:	4509                	li	a0,2
    80004f64:	ffffd097          	auipc	ra,0xffffd
    80004f68:	1d4080e7          	jalr	468(ra) # 80002138 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f6c:	08000613          	li	a2,128
    80004f70:	f7040593          	addi	a1,s0,-144
    80004f74:	4501                	li	a0,0
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	202080e7          	jalr	514(ra) # 80002178 <argstr>
    80004f7e:	02054b63          	bltz	a0,80004fb4 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f82:	f6841683          	lh	a3,-152(s0)
    80004f86:	f6c41603          	lh	a2,-148(s0)
    80004f8a:	458d                	li	a1,3
    80004f8c:	f7040513          	addi	a0,s0,-144
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	780080e7          	jalr	1920(ra) # 80004710 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f98:	cd11                	beqz	a0,80004fb4 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	056080e7          	jalr	86(ra) # 80002ff0 <iunlockput>
  end_op();
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	82e080e7          	jalr	-2002(ra) # 800037d0 <end_op>
  return 0;
    80004faa:	4501                	li	a0,0
}
    80004fac:	60ea                	ld	ra,152(sp)
    80004fae:	644a                	ld	s0,144(sp)
    80004fb0:	610d                	addi	sp,sp,160
    80004fb2:	8082                	ret
    end_op();
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	81c080e7          	jalr	-2020(ra) # 800037d0 <end_op>
    return -1;
    80004fbc:	557d                	li	a0,-1
    80004fbe:	b7fd                	j	80004fac <sys_mknod+0x6c>

0000000080004fc0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fc0:	7135                	addi	sp,sp,-160
    80004fc2:	ed06                	sd	ra,152(sp)
    80004fc4:	e922                	sd	s0,144(sp)
    80004fc6:	e526                	sd	s1,136(sp)
    80004fc8:	e14a                	sd	s2,128(sp)
    80004fca:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fcc:	ffffc097          	auipc	ra,0xffffc
    80004fd0:	f7c080e7          	jalr	-132(ra) # 80000f48 <myproc>
    80004fd4:	892a                	mv	s2,a0
  
  begin_op();
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	77a080e7          	jalr	1914(ra) # 80003750 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fde:	08000613          	li	a2,128
    80004fe2:	f6040593          	addi	a1,s0,-160
    80004fe6:	4501                	li	a0,0
    80004fe8:	ffffd097          	auipc	ra,0xffffd
    80004fec:	190080e7          	jalr	400(ra) # 80002178 <argstr>
    80004ff0:	04054b63          	bltz	a0,80005046 <sys_chdir+0x86>
    80004ff4:	f6040513          	addi	a0,s0,-160
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	53c080e7          	jalr	1340(ra) # 80003534 <namei>
    80005000:	84aa                	mv	s1,a0
    80005002:	c131                	beqz	a0,80005046 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	d8a080e7          	jalr	-630(ra) # 80002d8e <ilock>
  if(ip->type != T_DIR){
    8000500c:	04449703          	lh	a4,68(s1)
    80005010:	4785                	li	a5,1
    80005012:	04f71063          	bne	a4,a5,80005052 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005016:	8526                	mv	a0,s1
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	e38080e7          	jalr	-456(ra) # 80002e50 <iunlock>
  iput(p->cwd);
    80005020:	15093503          	ld	a0,336(s2)
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	f24080e7          	jalr	-220(ra) # 80002f48 <iput>
  end_op();
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	7a4080e7          	jalr	1956(ra) # 800037d0 <end_op>
  p->cwd = ip;
    80005034:	14993823          	sd	s1,336(s2)
  return 0;
    80005038:	4501                	li	a0,0
}
    8000503a:	60ea                	ld	ra,152(sp)
    8000503c:	644a                	ld	s0,144(sp)
    8000503e:	64aa                	ld	s1,136(sp)
    80005040:	690a                	ld	s2,128(sp)
    80005042:	610d                	addi	sp,sp,160
    80005044:	8082                	ret
    end_op();
    80005046:	ffffe097          	auipc	ra,0xffffe
    8000504a:	78a080e7          	jalr	1930(ra) # 800037d0 <end_op>
    return -1;
    8000504e:	557d                	li	a0,-1
    80005050:	b7ed                	j	8000503a <sys_chdir+0x7a>
    iunlockput(ip);
    80005052:	8526                	mv	a0,s1
    80005054:	ffffe097          	auipc	ra,0xffffe
    80005058:	f9c080e7          	jalr	-100(ra) # 80002ff0 <iunlockput>
    end_op();
    8000505c:	ffffe097          	auipc	ra,0xffffe
    80005060:	774080e7          	jalr	1908(ra) # 800037d0 <end_op>
    return -1;
    80005064:	557d                	li	a0,-1
    80005066:	bfd1                	j	8000503a <sys_chdir+0x7a>

0000000080005068 <sys_exec>:

uint64
sys_exec(void)
{
    80005068:	7145                	addi	sp,sp,-464
    8000506a:	e786                	sd	ra,456(sp)
    8000506c:	e3a2                	sd	s0,448(sp)
    8000506e:	ff26                	sd	s1,440(sp)
    80005070:	fb4a                	sd	s2,432(sp)
    80005072:	f74e                	sd	s3,424(sp)
    80005074:	f352                	sd	s4,416(sp)
    80005076:	ef56                	sd	s5,408(sp)
    80005078:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000507a:	e3840593          	addi	a1,s0,-456
    8000507e:	4505                	li	a0,1
    80005080:	ffffd097          	auipc	ra,0xffffd
    80005084:	0d8080e7          	jalr	216(ra) # 80002158 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005088:	08000613          	li	a2,128
    8000508c:	f4040593          	addi	a1,s0,-192
    80005090:	4501                	li	a0,0
    80005092:	ffffd097          	auipc	ra,0xffffd
    80005096:	0e6080e7          	jalr	230(ra) # 80002178 <argstr>
    8000509a:	87aa                	mv	a5,a0
    return -1;
    8000509c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000509e:	0c07c363          	bltz	a5,80005164 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    800050a2:	10000613          	li	a2,256
    800050a6:	4581                	li	a1,0
    800050a8:	e4040513          	addi	a0,s0,-448
    800050ac:	ffffb097          	auipc	ra,0xffffb
    800050b0:	0cc080e7          	jalr	204(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050b4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050b8:	89a6                	mv	s3,s1
    800050ba:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050bc:	02000a13          	li	s4,32
    800050c0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050c4:	00391793          	slli	a5,s2,0x3
    800050c8:	e3040593          	addi	a1,s0,-464
    800050cc:	e3843503          	ld	a0,-456(s0)
    800050d0:	953e                	add	a0,a0,a5
    800050d2:	ffffd097          	auipc	ra,0xffffd
    800050d6:	fc8080e7          	jalr	-56(ra) # 8000209a <fetchaddr>
    800050da:	02054a63          	bltz	a0,8000510e <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800050de:	e3043783          	ld	a5,-464(s0)
    800050e2:	c3b9                	beqz	a5,80005128 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050e4:	ffffb097          	auipc	ra,0xffffb
    800050e8:	034080e7          	jalr	52(ra) # 80000118 <kalloc>
    800050ec:	85aa                	mv	a1,a0
    800050ee:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050f2:	cd11                	beqz	a0,8000510e <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050f4:	6605                	lui	a2,0x1
    800050f6:	e3043503          	ld	a0,-464(s0)
    800050fa:	ffffd097          	auipc	ra,0xffffd
    800050fe:	ff2080e7          	jalr	-14(ra) # 800020ec <fetchstr>
    80005102:	00054663          	bltz	a0,8000510e <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005106:	0905                	addi	s2,s2,1
    80005108:	09a1                	addi	s3,s3,8
    8000510a:	fb491be3          	bne	s2,s4,800050c0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000510e:	10048913          	addi	s2,s1,256
    80005112:	6088                	ld	a0,0(s1)
    80005114:	c539                	beqz	a0,80005162 <sys_exec+0xfa>
    kfree(argv[i]);
    80005116:	ffffb097          	auipc	ra,0xffffb
    8000511a:	f06080e7          	jalr	-250(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000511e:	04a1                	addi	s1,s1,8
    80005120:	ff2499e3          	bne	s1,s2,80005112 <sys_exec+0xaa>
  return -1;
    80005124:	557d                	li	a0,-1
    80005126:	a83d                	j	80005164 <sys_exec+0xfc>
      argv[i] = 0;
    80005128:	0a8e                	slli	s5,s5,0x3
    8000512a:	fc0a8793          	addi	a5,s5,-64
    8000512e:	00878ab3          	add	s5,a5,s0
    80005132:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005136:	e4040593          	addi	a1,s0,-448
    8000513a:	f4040513          	addi	a0,s0,-192
    8000513e:	fffff097          	auipc	ra,0xfffff
    80005142:	158080e7          	jalr	344(ra) # 80004296 <exec>
    80005146:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005148:	10048993          	addi	s3,s1,256
    8000514c:	6088                	ld	a0,0(s1)
    8000514e:	c901                	beqz	a0,8000515e <sys_exec+0xf6>
    kfree(argv[i]);
    80005150:	ffffb097          	auipc	ra,0xffffb
    80005154:	ecc080e7          	jalr	-308(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005158:	04a1                	addi	s1,s1,8
    8000515a:	ff3499e3          	bne	s1,s3,8000514c <sys_exec+0xe4>
  return ret;
    8000515e:	854a                	mv	a0,s2
    80005160:	a011                	j	80005164 <sys_exec+0xfc>
  return -1;
    80005162:	557d                	li	a0,-1
}
    80005164:	60be                	ld	ra,456(sp)
    80005166:	641e                	ld	s0,448(sp)
    80005168:	74fa                	ld	s1,440(sp)
    8000516a:	795a                	ld	s2,432(sp)
    8000516c:	79ba                	ld	s3,424(sp)
    8000516e:	7a1a                	ld	s4,416(sp)
    80005170:	6afa                	ld	s5,408(sp)
    80005172:	6179                	addi	sp,sp,464
    80005174:	8082                	ret

0000000080005176 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005176:	7139                	addi	sp,sp,-64
    80005178:	fc06                	sd	ra,56(sp)
    8000517a:	f822                	sd	s0,48(sp)
    8000517c:	f426                	sd	s1,40(sp)
    8000517e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	dc8080e7          	jalr	-568(ra) # 80000f48 <myproc>
    80005188:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000518a:	fd840593          	addi	a1,s0,-40
    8000518e:	4501                	li	a0,0
    80005190:	ffffd097          	auipc	ra,0xffffd
    80005194:	fc8080e7          	jalr	-56(ra) # 80002158 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005198:	fc840593          	addi	a1,s0,-56
    8000519c:	fd040513          	addi	a0,s0,-48
    800051a0:	fffff097          	auipc	ra,0xfffff
    800051a4:	dac080e7          	jalr	-596(ra) # 80003f4c <pipealloc>
    return -1;
    800051a8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051aa:	0c054463          	bltz	a0,80005272 <sys_pipe+0xfc>
  fd0 = -1;
    800051ae:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051b2:	fd043503          	ld	a0,-48(s0)
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	518080e7          	jalr	1304(ra) # 800046ce <fdalloc>
    800051be:	fca42223          	sw	a0,-60(s0)
    800051c2:	08054b63          	bltz	a0,80005258 <sys_pipe+0xe2>
    800051c6:	fc843503          	ld	a0,-56(s0)
    800051ca:	fffff097          	auipc	ra,0xfffff
    800051ce:	504080e7          	jalr	1284(ra) # 800046ce <fdalloc>
    800051d2:	fca42023          	sw	a0,-64(s0)
    800051d6:	06054863          	bltz	a0,80005246 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051da:	4691                	li	a3,4
    800051dc:	fc440613          	addi	a2,s0,-60
    800051e0:	fd843583          	ld	a1,-40(s0)
    800051e4:	68a8                	ld	a0,80(s1)
    800051e6:	ffffc097          	auipc	ra,0xffffc
    800051ea:	928080e7          	jalr	-1752(ra) # 80000b0e <copyout>
    800051ee:	02054063          	bltz	a0,8000520e <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051f2:	4691                	li	a3,4
    800051f4:	fc040613          	addi	a2,s0,-64
    800051f8:	fd843583          	ld	a1,-40(s0)
    800051fc:	0591                	addi	a1,a1,4
    800051fe:	68a8                	ld	a0,80(s1)
    80005200:	ffffc097          	auipc	ra,0xffffc
    80005204:	90e080e7          	jalr	-1778(ra) # 80000b0e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005208:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000520a:	06055463          	bgez	a0,80005272 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000520e:	fc442783          	lw	a5,-60(s0)
    80005212:	07e9                	addi	a5,a5,26
    80005214:	078e                	slli	a5,a5,0x3
    80005216:	97a6                	add	a5,a5,s1
    80005218:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000521c:	fc042503          	lw	a0,-64(s0)
    80005220:	0569                	addi	a0,a0,26
    80005222:	050e                	slli	a0,a0,0x3
    80005224:	94aa                	add	s1,s1,a0
    80005226:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000522a:	fd043503          	ld	a0,-48(s0)
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	9ee080e7          	jalr	-1554(ra) # 80003c1c <fileclose>
    fileclose(wf);
    80005236:	fc843503          	ld	a0,-56(s0)
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	9e2080e7          	jalr	-1566(ra) # 80003c1c <fileclose>
    return -1;
    80005242:	57fd                	li	a5,-1
    80005244:	a03d                	j	80005272 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005246:	fc442783          	lw	a5,-60(s0)
    8000524a:	0007c763          	bltz	a5,80005258 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000524e:	07e9                	addi	a5,a5,26
    80005250:	078e                	slli	a5,a5,0x3
    80005252:	94be                	add	s1,s1,a5
    80005254:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005258:	fd043503          	ld	a0,-48(s0)
    8000525c:	fffff097          	auipc	ra,0xfffff
    80005260:	9c0080e7          	jalr	-1600(ra) # 80003c1c <fileclose>
    fileclose(wf);
    80005264:	fc843503          	ld	a0,-56(s0)
    80005268:	fffff097          	auipc	ra,0xfffff
    8000526c:	9b4080e7          	jalr	-1612(ra) # 80003c1c <fileclose>
    return -1;
    80005270:	57fd                	li	a5,-1
}
    80005272:	853e                	mv	a0,a5
    80005274:	70e2                	ld	ra,56(sp)
    80005276:	7442                	ld	s0,48(sp)
    80005278:	74a2                	ld	s1,40(sp)
    8000527a:	6121                	addi	sp,sp,64
    8000527c:	8082                	ret
	...

0000000080005280 <kernelvec>:
    80005280:	7111                	addi	sp,sp,-256
    80005282:	e006                	sd	ra,0(sp)
    80005284:	e40a                	sd	sp,8(sp)
    80005286:	e80e                	sd	gp,16(sp)
    80005288:	ec12                	sd	tp,24(sp)
    8000528a:	f016                	sd	t0,32(sp)
    8000528c:	f41a                	sd	t1,40(sp)
    8000528e:	f81e                	sd	t2,48(sp)
    80005290:	fc22                	sd	s0,56(sp)
    80005292:	e0a6                	sd	s1,64(sp)
    80005294:	e4aa                	sd	a0,72(sp)
    80005296:	e8ae                	sd	a1,80(sp)
    80005298:	ecb2                	sd	a2,88(sp)
    8000529a:	f0b6                	sd	a3,96(sp)
    8000529c:	f4ba                	sd	a4,104(sp)
    8000529e:	f8be                	sd	a5,112(sp)
    800052a0:	fcc2                	sd	a6,120(sp)
    800052a2:	e146                	sd	a7,128(sp)
    800052a4:	e54a                	sd	s2,136(sp)
    800052a6:	e94e                	sd	s3,144(sp)
    800052a8:	ed52                	sd	s4,152(sp)
    800052aa:	f156                	sd	s5,160(sp)
    800052ac:	f55a                	sd	s6,168(sp)
    800052ae:	f95e                	sd	s7,176(sp)
    800052b0:	fd62                	sd	s8,184(sp)
    800052b2:	e1e6                	sd	s9,192(sp)
    800052b4:	e5ea                	sd	s10,200(sp)
    800052b6:	e9ee                	sd	s11,208(sp)
    800052b8:	edf2                	sd	t3,216(sp)
    800052ba:	f1f6                	sd	t4,224(sp)
    800052bc:	f5fa                	sd	t5,232(sp)
    800052be:	f9fe                	sd	t6,240(sp)
    800052c0:	ca7fc0ef          	jal	ra,80001f66 <kerneltrap>
    800052c4:	6082                	ld	ra,0(sp)
    800052c6:	6122                	ld	sp,8(sp)
    800052c8:	61c2                	ld	gp,16(sp)
    800052ca:	7282                	ld	t0,32(sp)
    800052cc:	7322                	ld	t1,40(sp)
    800052ce:	73c2                	ld	t2,48(sp)
    800052d0:	7462                	ld	s0,56(sp)
    800052d2:	6486                	ld	s1,64(sp)
    800052d4:	6526                	ld	a0,72(sp)
    800052d6:	65c6                	ld	a1,80(sp)
    800052d8:	6666                	ld	a2,88(sp)
    800052da:	7686                	ld	a3,96(sp)
    800052dc:	7726                	ld	a4,104(sp)
    800052de:	77c6                	ld	a5,112(sp)
    800052e0:	7866                	ld	a6,120(sp)
    800052e2:	688a                	ld	a7,128(sp)
    800052e4:	692a                	ld	s2,136(sp)
    800052e6:	69ca                	ld	s3,144(sp)
    800052e8:	6a6a                	ld	s4,152(sp)
    800052ea:	7a8a                	ld	s5,160(sp)
    800052ec:	7b2a                	ld	s6,168(sp)
    800052ee:	7bca                	ld	s7,176(sp)
    800052f0:	7c6a                	ld	s8,184(sp)
    800052f2:	6c8e                	ld	s9,192(sp)
    800052f4:	6d2e                	ld	s10,200(sp)
    800052f6:	6dce                	ld	s11,208(sp)
    800052f8:	6e6e                	ld	t3,216(sp)
    800052fa:	7e8e                	ld	t4,224(sp)
    800052fc:	7f2e                	ld	t5,232(sp)
    800052fe:	7fce                	ld	t6,240(sp)
    80005300:	6111                	addi	sp,sp,256
    80005302:	10200073          	sret
    80005306:	00000013          	nop
    8000530a:	00000013          	nop
    8000530e:	0001                	nop

0000000080005310 <timervec>:
    80005310:	34051573          	csrrw	a0,mscratch,a0
    80005314:	e10c                	sd	a1,0(a0)
    80005316:	e510                	sd	a2,8(a0)
    80005318:	e914                	sd	a3,16(a0)
    8000531a:	6d0c                	ld	a1,24(a0)
    8000531c:	7110                	ld	a2,32(a0)
    8000531e:	6194                	ld	a3,0(a1)
    80005320:	96b2                	add	a3,a3,a2
    80005322:	e194                	sd	a3,0(a1)
    80005324:	4589                	li	a1,2
    80005326:	14459073          	csrw	sip,a1
    8000532a:	6914                	ld	a3,16(a0)
    8000532c:	6510                	ld	a2,8(a0)
    8000532e:	610c                	ld	a1,0(a0)
    80005330:	34051573          	csrrw	a0,mscratch,a0
    80005334:	30200073          	mret
	...

000000008000533a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000533a:	1141                	addi	sp,sp,-16
    8000533c:	e422                	sd	s0,8(sp)
    8000533e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005340:	0c0007b7          	lui	a5,0xc000
    80005344:	4705                	li	a4,1
    80005346:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005348:	c3d8                	sw	a4,4(a5)
}
    8000534a:	6422                	ld	s0,8(sp)
    8000534c:	0141                	addi	sp,sp,16
    8000534e:	8082                	ret

0000000080005350 <plicinithart>:

void
plicinithart(void)
{
    80005350:	1141                	addi	sp,sp,-16
    80005352:	e406                	sd	ra,8(sp)
    80005354:	e022                	sd	s0,0(sp)
    80005356:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	bc4080e7          	jalr	-1084(ra) # 80000f1c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005360:	0085171b          	slliw	a4,a0,0x8
    80005364:	0c0027b7          	lui	a5,0xc002
    80005368:	97ba                	add	a5,a5,a4
    8000536a:	40200713          	li	a4,1026
    8000536e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005372:	00d5151b          	slliw	a0,a0,0xd
    80005376:	0c2017b7          	lui	a5,0xc201
    8000537a:	953e                	add	a0,a0,a5
    8000537c:	00052023          	sw	zero,0(a0)
}
    80005380:	60a2                	ld	ra,8(sp)
    80005382:	6402                	ld	s0,0(sp)
    80005384:	0141                	addi	sp,sp,16
    80005386:	8082                	ret

0000000080005388 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005388:	1141                	addi	sp,sp,-16
    8000538a:	e406                	sd	ra,8(sp)
    8000538c:	e022                	sd	s0,0(sp)
    8000538e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005390:	ffffc097          	auipc	ra,0xffffc
    80005394:	b8c080e7          	jalr	-1140(ra) # 80000f1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005398:	00d5179b          	slliw	a5,a0,0xd
    8000539c:	0c201537          	lui	a0,0xc201
    800053a0:	953e                	add	a0,a0,a5
  return irq;
}
    800053a2:	4148                	lw	a0,4(a0)
    800053a4:	60a2                	ld	ra,8(sp)
    800053a6:	6402                	ld	s0,0(sp)
    800053a8:	0141                	addi	sp,sp,16
    800053aa:	8082                	ret

00000000800053ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053ac:	1101                	addi	sp,sp,-32
    800053ae:	ec06                	sd	ra,24(sp)
    800053b0:	e822                	sd	s0,16(sp)
    800053b2:	e426                	sd	s1,8(sp)
    800053b4:	1000                	addi	s0,sp,32
    800053b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053b8:	ffffc097          	auipc	ra,0xffffc
    800053bc:	b64080e7          	jalr	-1180(ra) # 80000f1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053c0:	00d5151b          	slliw	a0,a0,0xd
    800053c4:	0c2017b7          	lui	a5,0xc201
    800053c8:	97aa                	add	a5,a5,a0
    800053ca:	c3c4                	sw	s1,4(a5)
}
    800053cc:	60e2                	ld	ra,24(sp)
    800053ce:	6442                	ld	s0,16(sp)
    800053d0:	64a2                	ld	s1,8(sp)
    800053d2:	6105                	addi	sp,sp,32
    800053d4:	8082                	ret

00000000800053d6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053d6:	1141                	addi	sp,sp,-16
    800053d8:	e406                	sd	ra,8(sp)
    800053da:	e022                	sd	s0,0(sp)
    800053dc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053de:	479d                	li	a5,7
    800053e0:	04a7cc63          	blt	a5,a0,80005438 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053e4:	00015797          	auipc	a5,0x15
    800053e8:	86c78793          	addi	a5,a5,-1940 # 80019c50 <disk>
    800053ec:	97aa                	add	a5,a5,a0
    800053ee:	0187c783          	lbu	a5,24(a5)
    800053f2:	ebb9                	bnez	a5,80005448 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053f4:	00451613          	slli	a2,a0,0x4
    800053f8:	00015797          	auipc	a5,0x15
    800053fc:	85878793          	addi	a5,a5,-1960 # 80019c50 <disk>
    80005400:	6394                	ld	a3,0(a5)
    80005402:	96b2                	add	a3,a3,a2
    80005404:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005408:	6398                	ld	a4,0(a5)
    8000540a:	9732                	add	a4,a4,a2
    8000540c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005410:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005414:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005418:	953e                	add	a0,a0,a5
    8000541a:	4785                	li	a5,1
    8000541c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005420:	00015517          	auipc	a0,0x15
    80005424:	84850513          	addi	a0,a0,-1976 # 80019c68 <disk+0x18>
    80005428:	ffffc097          	auipc	ra,0xffffc
    8000542c:	308080e7          	jalr	776(ra) # 80001730 <wakeup>
}
    80005430:	60a2                	ld	ra,8(sp)
    80005432:	6402                	ld	s0,0(sp)
    80005434:	0141                	addi	sp,sp,16
    80005436:	8082                	ret
    panic("free_desc 1");
    80005438:	00003517          	auipc	a0,0x3
    8000543c:	30050513          	addi	a0,a0,768 # 80008738 <syscalls+0x330>
    80005440:	00001097          	auipc	ra,0x1
    80005444:	a10080e7          	jalr	-1520(ra) # 80005e50 <panic>
    panic("free_desc 2");
    80005448:	00003517          	auipc	a0,0x3
    8000544c:	30050513          	addi	a0,a0,768 # 80008748 <syscalls+0x340>
    80005450:	00001097          	auipc	ra,0x1
    80005454:	a00080e7          	jalr	-1536(ra) # 80005e50 <panic>

0000000080005458 <virtio_disk_init>:
{
    80005458:	1101                	addi	sp,sp,-32
    8000545a:	ec06                	sd	ra,24(sp)
    8000545c:	e822                	sd	s0,16(sp)
    8000545e:	e426                	sd	s1,8(sp)
    80005460:	e04a                	sd	s2,0(sp)
    80005462:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005464:	00003597          	auipc	a1,0x3
    80005468:	2f458593          	addi	a1,a1,756 # 80008758 <syscalls+0x350>
    8000546c:	00015517          	auipc	a0,0x15
    80005470:	90c50513          	addi	a0,a0,-1780 # 80019d78 <disk+0x128>
    80005474:	00001097          	auipc	ra,0x1
    80005478:	e88080e7          	jalr	-376(ra) # 800062fc <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000547c:	100017b7          	lui	a5,0x10001
    80005480:	4398                	lw	a4,0(a5)
    80005482:	2701                	sext.w	a4,a4
    80005484:	747277b7          	lui	a5,0x74727
    80005488:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000548c:	14f71c63          	bne	a4,a5,800055e4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005490:	100017b7          	lui	a5,0x10001
    80005494:	43dc                	lw	a5,4(a5)
    80005496:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005498:	4709                	li	a4,2
    8000549a:	14e79563          	bne	a5,a4,800055e4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000549e:	100017b7          	lui	a5,0x10001
    800054a2:	479c                	lw	a5,8(a5)
    800054a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054a6:	12e79f63          	bne	a5,a4,800055e4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054aa:	100017b7          	lui	a5,0x10001
    800054ae:	47d8                	lw	a4,12(a5)
    800054b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054b2:	554d47b7          	lui	a5,0x554d4
    800054b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054ba:	12f71563          	bne	a4,a5,800055e4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054be:	100017b7          	lui	a5,0x10001
    800054c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c6:	4705                	li	a4,1
    800054c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ca:	470d                	li	a4,3
    800054cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054ce:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054d0:	c7ffe737          	lui	a4,0xc7ffe
    800054d4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc78f>
    800054d8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054da:	2701                	sext.w	a4,a4
    800054dc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054de:	472d                	li	a4,11
    800054e0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054e2:	5bbc                	lw	a5,112(a5)
    800054e4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054e8:	8ba1                	andi	a5,a5,8
    800054ea:	10078563          	beqz	a5,800055f4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054ee:	100017b7          	lui	a5,0x10001
    800054f2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054f6:	43fc                	lw	a5,68(a5)
    800054f8:	2781                	sext.w	a5,a5
    800054fa:	10079563          	bnez	a5,80005604 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054fe:	100017b7          	lui	a5,0x10001
    80005502:	5bdc                	lw	a5,52(a5)
    80005504:	2781                	sext.w	a5,a5
  if(max == 0)
    80005506:	10078763          	beqz	a5,80005614 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000550a:	471d                	li	a4,7
    8000550c:	10f77c63          	bgeu	a4,a5,80005624 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005510:	ffffb097          	auipc	ra,0xffffb
    80005514:	c08080e7          	jalr	-1016(ra) # 80000118 <kalloc>
    80005518:	00014497          	auipc	s1,0x14
    8000551c:	73848493          	addi	s1,s1,1848 # 80019c50 <disk>
    80005520:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005522:	ffffb097          	auipc	ra,0xffffb
    80005526:	bf6080e7          	jalr	-1034(ra) # 80000118 <kalloc>
    8000552a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000552c:	ffffb097          	auipc	ra,0xffffb
    80005530:	bec080e7          	jalr	-1044(ra) # 80000118 <kalloc>
    80005534:	87aa                	mv	a5,a0
    80005536:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005538:	6088                	ld	a0,0(s1)
    8000553a:	cd6d                	beqz	a0,80005634 <virtio_disk_init+0x1dc>
    8000553c:	00014717          	auipc	a4,0x14
    80005540:	71c73703          	ld	a4,1820(a4) # 80019c58 <disk+0x8>
    80005544:	cb65                	beqz	a4,80005634 <virtio_disk_init+0x1dc>
    80005546:	c7fd                	beqz	a5,80005634 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005548:	6605                	lui	a2,0x1
    8000554a:	4581                	li	a1,0
    8000554c:	ffffb097          	auipc	ra,0xffffb
    80005550:	c2c080e7          	jalr	-980(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005554:	00014497          	auipc	s1,0x14
    80005558:	6fc48493          	addi	s1,s1,1788 # 80019c50 <disk>
    8000555c:	6605                	lui	a2,0x1
    8000555e:	4581                	li	a1,0
    80005560:	6488                	ld	a0,8(s1)
    80005562:	ffffb097          	auipc	ra,0xffffb
    80005566:	c16080e7          	jalr	-1002(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000556a:	6605                	lui	a2,0x1
    8000556c:	4581                	li	a1,0
    8000556e:	6888                	ld	a0,16(s1)
    80005570:	ffffb097          	auipc	ra,0xffffb
    80005574:	c08080e7          	jalr	-1016(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005578:	100017b7          	lui	a5,0x10001
    8000557c:	4721                	li	a4,8
    8000557e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005580:	4098                	lw	a4,0(s1)
    80005582:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005586:	40d8                	lw	a4,4(s1)
    80005588:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000558c:	6498                	ld	a4,8(s1)
    8000558e:	0007069b          	sext.w	a3,a4
    80005592:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005596:	9701                	srai	a4,a4,0x20
    80005598:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000559c:	6898                	ld	a4,16(s1)
    8000559e:	0007069b          	sext.w	a3,a4
    800055a2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055a6:	9701                	srai	a4,a4,0x20
    800055a8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055ac:	4705                	li	a4,1
    800055ae:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800055b0:	00e48c23          	sb	a4,24(s1)
    800055b4:	00e48ca3          	sb	a4,25(s1)
    800055b8:	00e48d23          	sb	a4,26(s1)
    800055bc:	00e48da3          	sb	a4,27(s1)
    800055c0:	00e48e23          	sb	a4,28(s1)
    800055c4:	00e48ea3          	sb	a4,29(s1)
    800055c8:	00e48f23          	sb	a4,30(s1)
    800055cc:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055d0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055d4:	0727a823          	sw	s2,112(a5)
}
    800055d8:	60e2                	ld	ra,24(sp)
    800055da:	6442                	ld	s0,16(sp)
    800055dc:	64a2                	ld	s1,8(sp)
    800055de:	6902                	ld	s2,0(sp)
    800055e0:	6105                	addi	sp,sp,32
    800055e2:	8082                	ret
    panic("could not find virtio disk");
    800055e4:	00003517          	auipc	a0,0x3
    800055e8:	18450513          	addi	a0,a0,388 # 80008768 <syscalls+0x360>
    800055ec:	00001097          	auipc	ra,0x1
    800055f0:	864080e7          	jalr	-1948(ra) # 80005e50 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055f4:	00003517          	auipc	a0,0x3
    800055f8:	19450513          	addi	a0,a0,404 # 80008788 <syscalls+0x380>
    800055fc:	00001097          	auipc	ra,0x1
    80005600:	854080e7          	jalr	-1964(ra) # 80005e50 <panic>
    panic("virtio disk should not be ready");
    80005604:	00003517          	auipc	a0,0x3
    80005608:	1a450513          	addi	a0,a0,420 # 800087a8 <syscalls+0x3a0>
    8000560c:	00001097          	auipc	ra,0x1
    80005610:	844080e7          	jalr	-1980(ra) # 80005e50 <panic>
    panic("virtio disk has no queue 0");
    80005614:	00003517          	auipc	a0,0x3
    80005618:	1b450513          	addi	a0,a0,436 # 800087c8 <syscalls+0x3c0>
    8000561c:	00001097          	auipc	ra,0x1
    80005620:	834080e7          	jalr	-1996(ra) # 80005e50 <panic>
    panic("virtio disk max queue too short");
    80005624:	00003517          	auipc	a0,0x3
    80005628:	1c450513          	addi	a0,a0,452 # 800087e8 <syscalls+0x3e0>
    8000562c:	00001097          	auipc	ra,0x1
    80005630:	824080e7          	jalr	-2012(ra) # 80005e50 <panic>
    panic("virtio disk kalloc");
    80005634:	00003517          	auipc	a0,0x3
    80005638:	1d450513          	addi	a0,a0,468 # 80008808 <syscalls+0x400>
    8000563c:	00001097          	auipc	ra,0x1
    80005640:	814080e7          	jalr	-2028(ra) # 80005e50 <panic>

0000000080005644 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005644:	7119                	addi	sp,sp,-128
    80005646:	fc86                	sd	ra,120(sp)
    80005648:	f8a2                	sd	s0,112(sp)
    8000564a:	f4a6                	sd	s1,104(sp)
    8000564c:	f0ca                	sd	s2,96(sp)
    8000564e:	ecce                	sd	s3,88(sp)
    80005650:	e8d2                	sd	s4,80(sp)
    80005652:	e4d6                	sd	s5,72(sp)
    80005654:	e0da                	sd	s6,64(sp)
    80005656:	fc5e                	sd	s7,56(sp)
    80005658:	f862                	sd	s8,48(sp)
    8000565a:	f466                	sd	s9,40(sp)
    8000565c:	f06a                	sd	s10,32(sp)
    8000565e:	ec6e                	sd	s11,24(sp)
    80005660:	0100                	addi	s0,sp,128
    80005662:	8aaa                	mv	s5,a0
    80005664:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005666:	00c52d03          	lw	s10,12(a0)
    8000566a:	001d1d1b          	slliw	s10,s10,0x1
    8000566e:	1d02                	slli	s10,s10,0x20
    80005670:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005674:	00014517          	auipc	a0,0x14
    80005678:	70450513          	addi	a0,a0,1796 # 80019d78 <disk+0x128>
    8000567c:	00001097          	auipc	ra,0x1
    80005680:	d10080e7          	jalr	-752(ra) # 8000638c <acquire>
  for(int i = 0; i < 3; i++){
    80005684:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005686:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005688:	00014b97          	auipc	s7,0x14
    8000568c:	5c8b8b93          	addi	s7,s7,1480 # 80019c50 <disk>
  for(int i = 0; i < 3; i++){
    80005690:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005692:	00014c97          	auipc	s9,0x14
    80005696:	6e6c8c93          	addi	s9,s9,1766 # 80019d78 <disk+0x128>
    8000569a:	a08d                	j	800056fc <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000569c:	00fb8733          	add	a4,s7,a5
    800056a0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056a4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056a6:	0207c563          	bltz	a5,800056d0 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800056aa:	2905                	addiw	s2,s2,1
    800056ac:	0611                	addi	a2,a2,4
    800056ae:	05690c63          	beq	s2,s6,80005706 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800056b2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056b4:	00014717          	auipc	a4,0x14
    800056b8:	59c70713          	addi	a4,a4,1436 # 80019c50 <disk>
    800056bc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056be:	01874683          	lbu	a3,24(a4)
    800056c2:	fee9                	bnez	a3,8000569c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800056c4:	2785                	addiw	a5,a5,1
    800056c6:	0705                	addi	a4,a4,1
    800056c8:	fe979be3          	bne	a5,s1,800056be <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800056cc:	57fd                	li	a5,-1
    800056ce:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056d0:	01205d63          	blez	s2,800056ea <virtio_disk_rw+0xa6>
    800056d4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800056d6:	000a2503          	lw	a0,0(s4)
    800056da:	00000097          	auipc	ra,0x0
    800056de:	cfc080e7          	jalr	-772(ra) # 800053d6 <free_desc>
      for(int j = 0; j < i; j++)
    800056e2:	2d85                	addiw	s11,s11,1
    800056e4:	0a11                	addi	s4,s4,4
    800056e6:	ffb918e3          	bne	s2,s11,800056d6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056ea:	85e6                	mv	a1,s9
    800056ec:	00014517          	auipc	a0,0x14
    800056f0:	57c50513          	addi	a0,a0,1404 # 80019c68 <disk+0x18>
    800056f4:	ffffc097          	auipc	ra,0xffffc
    800056f8:	fd8080e7          	jalr	-40(ra) # 800016cc <sleep>
  for(int i = 0; i < 3; i++){
    800056fc:	f8040a13          	addi	s4,s0,-128
{
    80005700:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005702:	894e                	mv	s2,s3
    80005704:	b77d                	j	800056b2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005706:	f8042583          	lw	a1,-128(s0)
    8000570a:	00a58793          	addi	a5,a1,10
    8000570e:	0792                	slli	a5,a5,0x4

  if(write)
    80005710:	00014617          	auipc	a2,0x14
    80005714:	54060613          	addi	a2,a2,1344 # 80019c50 <disk>
    80005718:	00f60733          	add	a4,a2,a5
    8000571c:	018036b3          	snez	a3,s8
    80005720:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005722:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005726:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000572a:	f6078693          	addi	a3,a5,-160
    8000572e:	6218                	ld	a4,0(a2)
    80005730:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005732:	00878513          	addi	a0,a5,8
    80005736:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005738:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000573a:	6208                	ld	a0,0(a2)
    8000573c:	96aa                	add	a3,a3,a0
    8000573e:	4741                	li	a4,16
    80005740:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005742:	4705                	li	a4,1
    80005744:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005748:	f8442703          	lw	a4,-124(s0)
    8000574c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005750:	0712                	slli	a4,a4,0x4
    80005752:	953a                	add	a0,a0,a4
    80005754:	058a8693          	addi	a3,s5,88
    80005758:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000575a:	6208                	ld	a0,0(a2)
    8000575c:	972a                	add	a4,a4,a0
    8000575e:	40000693          	li	a3,1024
    80005762:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005764:	001c3c13          	seqz	s8,s8
    80005768:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000576a:	001c6c13          	ori	s8,s8,1
    8000576e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005772:	f8842603          	lw	a2,-120(s0)
    80005776:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000577a:	00014697          	auipc	a3,0x14
    8000577e:	4d668693          	addi	a3,a3,1238 # 80019c50 <disk>
    80005782:	00258713          	addi	a4,a1,2
    80005786:	0712                	slli	a4,a4,0x4
    80005788:	9736                	add	a4,a4,a3
    8000578a:	587d                	li	a6,-1
    8000578c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005790:	0612                	slli	a2,a2,0x4
    80005792:	9532                	add	a0,a0,a2
    80005794:	f9078793          	addi	a5,a5,-112
    80005798:	97b6                	add	a5,a5,a3
    8000579a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000579c:	629c                	ld	a5,0(a3)
    8000579e:	97b2                	add	a5,a5,a2
    800057a0:	4605                	li	a2,1
    800057a2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057a4:	4509                	li	a0,2
    800057a6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800057aa:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057ae:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800057b2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057b6:	6698                	ld	a4,8(a3)
    800057b8:	00275783          	lhu	a5,2(a4)
    800057bc:	8b9d                	andi	a5,a5,7
    800057be:	0786                	slli	a5,a5,0x1
    800057c0:	97ba                	add	a5,a5,a4
    800057c2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800057c6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ca:	6698                	ld	a4,8(a3)
    800057cc:	00275783          	lhu	a5,2(a4)
    800057d0:	2785                	addiw	a5,a5,1
    800057d2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057d6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057da:	100017b7          	lui	a5,0x10001
    800057de:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057e2:	004aa783          	lw	a5,4(s5)
    800057e6:	02c79163          	bne	a5,a2,80005808 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800057ea:	00014917          	auipc	s2,0x14
    800057ee:	58e90913          	addi	s2,s2,1422 # 80019d78 <disk+0x128>
  while(b->disk == 1) {
    800057f2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057f4:	85ca                	mv	a1,s2
    800057f6:	8556                	mv	a0,s5
    800057f8:	ffffc097          	auipc	ra,0xffffc
    800057fc:	ed4080e7          	jalr	-300(ra) # 800016cc <sleep>
  while(b->disk == 1) {
    80005800:	004aa783          	lw	a5,4(s5)
    80005804:	fe9788e3          	beq	a5,s1,800057f4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005808:	f8042903          	lw	s2,-128(s0)
    8000580c:	00290793          	addi	a5,s2,2
    80005810:	00479713          	slli	a4,a5,0x4
    80005814:	00014797          	auipc	a5,0x14
    80005818:	43c78793          	addi	a5,a5,1084 # 80019c50 <disk>
    8000581c:	97ba                	add	a5,a5,a4
    8000581e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005822:	00014997          	auipc	s3,0x14
    80005826:	42e98993          	addi	s3,s3,1070 # 80019c50 <disk>
    8000582a:	00491713          	slli	a4,s2,0x4
    8000582e:	0009b783          	ld	a5,0(s3)
    80005832:	97ba                	add	a5,a5,a4
    80005834:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005838:	854a                	mv	a0,s2
    8000583a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000583e:	00000097          	auipc	ra,0x0
    80005842:	b98080e7          	jalr	-1128(ra) # 800053d6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005846:	8885                	andi	s1,s1,1
    80005848:	f0ed                	bnez	s1,8000582a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000584a:	00014517          	auipc	a0,0x14
    8000584e:	52e50513          	addi	a0,a0,1326 # 80019d78 <disk+0x128>
    80005852:	00001097          	auipc	ra,0x1
    80005856:	bee080e7          	jalr	-1042(ra) # 80006440 <release>
}
    8000585a:	70e6                	ld	ra,120(sp)
    8000585c:	7446                	ld	s0,112(sp)
    8000585e:	74a6                	ld	s1,104(sp)
    80005860:	7906                	ld	s2,96(sp)
    80005862:	69e6                	ld	s3,88(sp)
    80005864:	6a46                	ld	s4,80(sp)
    80005866:	6aa6                	ld	s5,72(sp)
    80005868:	6b06                	ld	s6,64(sp)
    8000586a:	7be2                	ld	s7,56(sp)
    8000586c:	7c42                	ld	s8,48(sp)
    8000586e:	7ca2                	ld	s9,40(sp)
    80005870:	7d02                	ld	s10,32(sp)
    80005872:	6de2                	ld	s11,24(sp)
    80005874:	6109                	addi	sp,sp,128
    80005876:	8082                	ret

0000000080005878 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005878:	1101                	addi	sp,sp,-32
    8000587a:	ec06                	sd	ra,24(sp)
    8000587c:	e822                	sd	s0,16(sp)
    8000587e:	e426                	sd	s1,8(sp)
    80005880:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005882:	00014497          	auipc	s1,0x14
    80005886:	3ce48493          	addi	s1,s1,974 # 80019c50 <disk>
    8000588a:	00014517          	auipc	a0,0x14
    8000588e:	4ee50513          	addi	a0,a0,1262 # 80019d78 <disk+0x128>
    80005892:	00001097          	auipc	ra,0x1
    80005896:	afa080e7          	jalr	-1286(ra) # 8000638c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000589a:	10001737          	lui	a4,0x10001
    8000589e:	533c                	lw	a5,96(a4)
    800058a0:	8b8d                	andi	a5,a5,3
    800058a2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058a4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058a8:	689c                	ld	a5,16(s1)
    800058aa:	0204d703          	lhu	a4,32(s1)
    800058ae:	0027d783          	lhu	a5,2(a5)
    800058b2:	04f70863          	beq	a4,a5,80005902 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058b6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058ba:	6898                	ld	a4,16(s1)
    800058bc:	0204d783          	lhu	a5,32(s1)
    800058c0:	8b9d                	andi	a5,a5,7
    800058c2:	078e                	slli	a5,a5,0x3
    800058c4:	97ba                	add	a5,a5,a4
    800058c6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058c8:	00278713          	addi	a4,a5,2
    800058cc:	0712                	slli	a4,a4,0x4
    800058ce:	9726                	add	a4,a4,s1
    800058d0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058d4:	e721                	bnez	a4,8000591c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058d6:	0789                	addi	a5,a5,2
    800058d8:	0792                	slli	a5,a5,0x4
    800058da:	97a6                	add	a5,a5,s1
    800058dc:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058de:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058e2:	ffffc097          	auipc	ra,0xffffc
    800058e6:	e4e080e7          	jalr	-434(ra) # 80001730 <wakeup>

    disk.used_idx += 1;
    800058ea:	0204d783          	lhu	a5,32(s1)
    800058ee:	2785                	addiw	a5,a5,1
    800058f0:	17c2                	slli	a5,a5,0x30
    800058f2:	93c1                	srli	a5,a5,0x30
    800058f4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058f8:	6898                	ld	a4,16(s1)
    800058fa:	00275703          	lhu	a4,2(a4)
    800058fe:	faf71ce3          	bne	a4,a5,800058b6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005902:	00014517          	auipc	a0,0x14
    80005906:	47650513          	addi	a0,a0,1142 # 80019d78 <disk+0x128>
    8000590a:	00001097          	auipc	ra,0x1
    8000590e:	b36080e7          	jalr	-1226(ra) # 80006440 <release>
}
    80005912:	60e2                	ld	ra,24(sp)
    80005914:	6442                	ld	s0,16(sp)
    80005916:	64a2                	ld	s1,8(sp)
    80005918:	6105                	addi	sp,sp,32
    8000591a:	8082                	ret
      panic("virtio_disk_intr status");
    8000591c:	00003517          	auipc	a0,0x3
    80005920:	f0450513          	addi	a0,a0,-252 # 80008820 <syscalls+0x418>
    80005924:	00000097          	auipc	ra,0x0
    80005928:	52c080e7          	jalr	1324(ra) # 80005e50 <panic>

000000008000592c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000592c:	1141                	addi	sp,sp,-16
    8000592e:	e422                	sd	s0,8(sp)
    80005930:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005932:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005936:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000593a:	0037979b          	slliw	a5,a5,0x3
    8000593e:	02004737          	lui	a4,0x2004
    80005942:	97ba                	add	a5,a5,a4
    80005944:	0200c737          	lui	a4,0x200c
    80005948:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000594c:	000f4637          	lui	a2,0xf4
    80005950:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005954:	95b2                	add	a1,a1,a2
    80005956:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005958:	00269713          	slli	a4,a3,0x2
    8000595c:	9736                	add	a4,a4,a3
    8000595e:	00371693          	slli	a3,a4,0x3
    80005962:	00014717          	auipc	a4,0x14
    80005966:	42e70713          	addi	a4,a4,1070 # 80019d90 <timer_scratch>
    8000596a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000596c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000596e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005970:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005974:	00000797          	auipc	a5,0x0
    80005978:	99c78793          	addi	a5,a5,-1636 # 80005310 <timervec>
    8000597c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005980:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005984:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005988:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000598c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005990:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005994:	30479073          	csrw	mie,a5
}
    80005998:	6422                	ld	s0,8(sp)
    8000599a:	0141                	addi	sp,sp,16
    8000599c:	8082                	ret

000000008000599e <start>:
{
    8000599e:	1141                	addi	sp,sp,-16
    800059a0:	e406                	sd	ra,8(sp)
    800059a2:	e022                	sd	s0,0(sp)
    800059a4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059a6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059aa:	7779                	lui	a4,0xffffe
    800059ac:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc82f>
    800059b0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059b2:	6705                	lui	a4,0x1
    800059b4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059ba:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059be:	ffffb797          	auipc	a5,0xffffb
    800059c2:	96078793          	addi	a5,a5,-1696 # 8000031e <main>
    800059c6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059ca:	4781                	li	a5,0
    800059cc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059d0:	67c1                	lui	a5,0x10
    800059d2:	17fd                	addi	a5,a5,-1
    800059d4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059d8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059dc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059e0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059e4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059e8:	57fd                	li	a5,-1
    800059ea:	83a9                	srli	a5,a5,0xa
    800059ec:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059f0:	47bd                	li	a5,15
    800059f2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059f6:	00000097          	auipc	ra,0x0
    800059fa:	f36080e7          	jalr	-202(ra) # 8000592c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059fe:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a02:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a04:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a06:	30200073          	mret
}
    80005a0a:	60a2                	ld	ra,8(sp)
    80005a0c:	6402                	ld	s0,0(sp)
    80005a0e:	0141                	addi	sp,sp,16
    80005a10:	8082                	ret

0000000080005a12 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a12:	715d                	addi	sp,sp,-80
    80005a14:	e486                	sd	ra,72(sp)
    80005a16:	e0a2                	sd	s0,64(sp)
    80005a18:	fc26                	sd	s1,56(sp)
    80005a1a:	f84a                	sd	s2,48(sp)
    80005a1c:	f44e                	sd	s3,40(sp)
    80005a1e:	f052                	sd	s4,32(sp)
    80005a20:	ec56                	sd	s5,24(sp)
    80005a22:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a24:	04c05663          	blez	a2,80005a70 <consolewrite+0x5e>
    80005a28:	8a2a                	mv	s4,a0
    80005a2a:	84ae                	mv	s1,a1
    80005a2c:	89b2                	mv	s3,a2
    80005a2e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a30:	5afd                	li	s5,-1
    80005a32:	4685                	li	a3,1
    80005a34:	8626                	mv	a2,s1
    80005a36:	85d2                	mv	a1,s4
    80005a38:	fbf40513          	addi	a0,s0,-65
    80005a3c:	ffffc097          	auipc	ra,0xffffc
    80005a40:	0ee080e7          	jalr	238(ra) # 80001b2a <either_copyin>
    80005a44:	01550c63          	beq	a0,s5,80005a5c <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a48:	fbf44503          	lbu	a0,-65(s0)
    80005a4c:	00000097          	auipc	ra,0x0
    80005a50:	782080e7          	jalr	1922(ra) # 800061ce <uartputc>
  for(i = 0; i < n; i++){
    80005a54:	2905                	addiw	s2,s2,1
    80005a56:	0485                	addi	s1,s1,1
    80005a58:	fd299de3          	bne	s3,s2,80005a32 <consolewrite+0x20>
  }

  return i;
}
    80005a5c:	854a                	mv	a0,s2
    80005a5e:	60a6                	ld	ra,72(sp)
    80005a60:	6406                	ld	s0,64(sp)
    80005a62:	74e2                	ld	s1,56(sp)
    80005a64:	7942                	ld	s2,48(sp)
    80005a66:	79a2                	ld	s3,40(sp)
    80005a68:	7a02                	ld	s4,32(sp)
    80005a6a:	6ae2                	ld	s5,24(sp)
    80005a6c:	6161                	addi	sp,sp,80
    80005a6e:	8082                	ret
  for(i = 0; i < n; i++){
    80005a70:	4901                	li	s2,0
    80005a72:	b7ed                	j	80005a5c <consolewrite+0x4a>

0000000080005a74 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a74:	7159                	addi	sp,sp,-112
    80005a76:	f486                	sd	ra,104(sp)
    80005a78:	f0a2                	sd	s0,96(sp)
    80005a7a:	eca6                	sd	s1,88(sp)
    80005a7c:	e8ca                	sd	s2,80(sp)
    80005a7e:	e4ce                	sd	s3,72(sp)
    80005a80:	e0d2                	sd	s4,64(sp)
    80005a82:	fc56                	sd	s5,56(sp)
    80005a84:	f85a                	sd	s6,48(sp)
    80005a86:	f45e                	sd	s7,40(sp)
    80005a88:	f062                	sd	s8,32(sp)
    80005a8a:	ec66                	sd	s9,24(sp)
    80005a8c:	e86a                	sd	s10,16(sp)
    80005a8e:	1880                	addi	s0,sp,112
    80005a90:	8aaa                	mv	s5,a0
    80005a92:	8a2e                	mv	s4,a1
    80005a94:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a96:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a9a:	0001c517          	auipc	a0,0x1c
    80005a9e:	43650513          	addi	a0,a0,1078 # 80021ed0 <cons>
    80005aa2:	00001097          	auipc	ra,0x1
    80005aa6:	8ea080e7          	jalr	-1814(ra) # 8000638c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005aaa:	0001c497          	auipc	s1,0x1c
    80005aae:	42648493          	addi	s1,s1,1062 # 80021ed0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ab2:	0001c917          	auipc	s2,0x1c
    80005ab6:	4b690913          	addi	s2,s2,1206 # 80021f68 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005aba:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005abc:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005abe:	4ca9                	li	s9,10
  while(n > 0){
    80005ac0:	07305b63          	blez	s3,80005b36 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005ac4:	0984a783          	lw	a5,152(s1)
    80005ac8:	09c4a703          	lw	a4,156(s1)
    80005acc:	02f71763          	bne	a4,a5,80005afa <consoleread+0x86>
      if(killed(myproc())){
    80005ad0:	ffffb097          	auipc	ra,0xffffb
    80005ad4:	478080e7          	jalr	1144(ra) # 80000f48 <myproc>
    80005ad8:	ffffc097          	auipc	ra,0xffffc
    80005adc:	e9c080e7          	jalr	-356(ra) # 80001974 <killed>
    80005ae0:	e535                	bnez	a0,80005b4c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005ae2:	85a6                	mv	a1,s1
    80005ae4:	854a                	mv	a0,s2
    80005ae6:	ffffc097          	auipc	ra,0xffffc
    80005aea:	be6080e7          	jalr	-1050(ra) # 800016cc <sleep>
    while(cons.r == cons.w){
    80005aee:	0984a783          	lw	a5,152(s1)
    80005af2:	09c4a703          	lw	a4,156(s1)
    80005af6:	fcf70de3          	beq	a4,a5,80005ad0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005afa:	0017871b          	addiw	a4,a5,1
    80005afe:	08e4ac23          	sw	a4,152(s1)
    80005b02:	07f7f713          	andi	a4,a5,127
    80005b06:	9726                	add	a4,a4,s1
    80005b08:	01874703          	lbu	a4,24(a4)
    80005b0c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005b10:	077d0563          	beq	s10,s7,80005b7a <consoleread+0x106>
    cbuf = c;
    80005b14:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b18:	4685                	li	a3,1
    80005b1a:	f9f40613          	addi	a2,s0,-97
    80005b1e:	85d2                	mv	a1,s4
    80005b20:	8556                	mv	a0,s5
    80005b22:	ffffc097          	auipc	ra,0xffffc
    80005b26:	fb2080e7          	jalr	-78(ra) # 80001ad4 <either_copyout>
    80005b2a:	01850663          	beq	a0,s8,80005b36 <consoleread+0xc2>
    dst++;
    80005b2e:	0a05                	addi	s4,s4,1
    --n;
    80005b30:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005b32:	f99d17e3          	bne	s10,s9,80005ac0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b36:	0001c517          	auipc	a0,0x1c
    80005b3a:	39a50513          	addi	a0,a0,922 # 80021ed0 <cons>
    80005b3e:	00001097          	auipc	ra,0x1
    80005b42:	902080e7          	jalr	-1790(ra) # 80006440 <release>

  return target - n;
    80005b46:	413b053b          	subw	a0,s6,s3
    80005b4a:	a811                	j	80005b5e <consoleread+0xea>
        release(&cons.lock);
    80005b4c:	0001c517          	auipc	a0,0x1c
    80005b50:	38450513          	addi	a0,a0,900 # 80021ed0 <cons>
    80005b54:	00001097          	auipc	ra,0x1
    80005b58:	8ec080e7          	jalr	-1812(ra) # 80006440 <release>
        return -1;
    80005b5c:	557d                	li	a0,-1
}
    80005b5e:	70a6                	ld	ra,104(sp)
    80005b60:	7406                	ld	s0,96(sp)
    80005b62:	64e6                	ld	s1,88(sp)
    80005b64:	6946                	ld	s2,80(sp)
    80005b66:	69a6                	ld	s3,72(sp)
    80005b68:	6a06                	ld	s4,64(sp)
    80005b6a:	7ae2                	ld	s5,56(sp)
    80005b6c:	7b42                	ld	s6,48(sp)
    80005b6e:	7ba2                	ld	s7,40(sp)
    80005b70:	7c02                	ld	s8,32(sp)
    80005b72:	6ce2                	ld	s9,24(sp)
    80005b74:	6d42                	ld	s10,16(sp)
    80005b76:	6165                	addi	sp,sp,112
    80005b78:	8082                	ret
      if(n < target){
    80005b7a:	0009871b          	sext.w	a4,s3
    80005b7e:	fb677ce3          	bgeu	a4,s6,80005b36 <consoleread+0xc2>
        cons.r--;
    80005b82:	0001c717          	auipc	a4,0x1c
    80005b86:	3ef72323          	sw	a5,998(a4) # 80021f68 <cons+0x98>
    80005b8a:	b775                	j	80005b36 <consoleread+0xc2>

0000000080005b8c <consputc>:
{
    80005b8c:	1141                	addi	sp,sp,-16
    80005b8e:	e406                	sd	ra,8(sp)
    80005b90:	e022                	sd	s0,0(sp)
    80005b92:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b94:	10000793          	li	a5,256
    80005b98:	00f50a63          	beq	a0,a5,80005bac <consputc+0x20>
    uartputc_sync(c);
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	560080e7          	jalr	1376(ra) # 800060fc <uartputc_sync>
}
    80005ba4:	60a2                	ld	ra,8(sp)
    80005ba6:	6402                	ld	s0,0(sp)
    80005ba8:	0141                	addi	sp,sp,16
    80005baa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005bac:	4521                	li	a0,8
    80005bae:	00000097          	auipc	ra,0x0
    80005bb2:	54e080e7          	jalr	1358(ra) # 800060fc <uartputc_sync>
    80005bb6:	02000513          	li	a0,32
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	542080e7          	jalr	1346(ra) # 800060fc <uartputc_sync>
    80005bc2:	4521                	li	a0,8
    80005bc4:	00000097          	auipc	ra,0x0
    80005bc8:	538080e7          	jalr	1336(ra) # 800060fc <uartputc_sync>
    80005bcc:	bfe1                	j	80005ba4 <consputc+0x18>

0000000080005bce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bce:	1101                	addi	sp,sp,-32
    80005bd0:	ec06                	sd	ra,24(sp)
    80005bd2:	e822                	sd	s0,16(sp)
    80005bd4:	e426                	sd	s1,8(sp)
    80005bd6:	e04a                	sd	s2,0(sp)
    80005bd8:	1000                	addi	s0,sp,32
    80005bda:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bdc:	0001c517          	auipc	a0,0x1c
    80005be0:	2f450513          	addi	a0,a0,756 # 80021ed0 <cons>
    80005be4:	00000097          	auipc	ra,0x0
    80005be8:	7a8080e7          	jalr	1960(ra) # 8000638c <acquire>

  switch(c){
    80005bec:	47d5                	li	a5,21
    80005bee:	0af48663          	beq	s1,a5,80005c9a <consoleintr+0xcc>
    80005bf2:	0297ca63          	blt	a5,s1,80005c26 <consoleintr+0x58>
    80005bf6:	47a1                	li	a5,8
    80005bf8:	0ef48763          	beq	s1,a5,80005ce6 <consoleintr+0x118>
    80005bfc:	47c1                	li	a5,16
    80005bfe:	10f49a63          	bne	s1,a5,80005d12 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c02:	ffffc097          	auipc	ra,0xffffc
    80005c06:	f7e080e7          	jalr	-130(ra) # 80001b80 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c0a:	0001c517          	auipc	a0,0x1c
    80005c0e:	2c650513          	addi	a0,a0,710 # 80021ed0 <cons>
    80005c12:	00001097          	auipc	ra,0x1
    80005c16:	82e080e7          	jalr	-2002(ra) # 80006440 <release>
}
    80005c1a:	60e2                	ld	ra,24(sp)
    80005c1c:	6442                	ld	s0,16(sp)
    80005c1e:	64a2                	ld	s1,8(sp)
    80005c20:	6902                	ld	s2,0(sp)
    80005c22:	6105                	addi	sp,sp,32
    80005c24:	8082                	ret
  switch(c){
    80005c26:	07f00793          	li	a5,127
    80005c2a:	0af48e63          	beq	s1,a5,80005ce6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c2e:	0001c717          	auipc	a4,0x1c
    80005c32:	2a270713          	addi	a4,a4,674 # 80021ed0 <cons>
    80005c36:	0a072783          	lw	a5,160(a4)
    80005c3a:	09872703          	lw	a4,152(a4)
    80005c3e:	9f99                	subw	a5,a5,a4
    80005c40:	07f00713          	li	a4,127
    80005c44:	fcf763e3          	bltu	a4,a5,80005c0a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c48:	47b5                	li	a5,13
    80005c4a:	0cf48763          	beq	s1,a5,80005d18 <consoleintr+0x14a>
      consputc(c);
    80005c4e:	8526                	mv	a0,s1
    80005c50:	00000097          	auipc	ra,0x0
    80005c54:	f3c080e7          	jalr	-196(ra) # 80005b8c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c58:	0001c797          	auipc	a5,0x1c
    80005c5c:	27878793          	addi	a5,a5,632 # 80021ed0 <cons>
    80005c60:	0a07a683          	lw	a3,160(a5)
    80005c64:	0016871b          	addiw	a4,a3,1
    80005c68:	0007061b          	sext.w	a2,a4
    80005c6c:	0ae7a023          	sw	a4,160(a5)
    80005c70:	07f6f693          	andi	a3,a3,127
    80005c74:	97b6                	add	a5,a5,a3
    80005c76:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c7a:	47a9                	li	a5,10
    80005c7c:	0cf48563          	beq	s1,a5,80005d46 <consoleintr+0x178>
    80005c80:	4791                	li	a5,4
    80005c82:	0cf48263          	beq	s1,a5,80005d46 <consoleintr+0x178>
    80005c86:	0001c797          	auipc	a5,0x1c
    80005c8a:	2e27a783          	lw	a5,738(a5) # 80021f68 <cons+0x98>
    80005c8e:	9f1d                	subw	a4,a4,a5
    80005c90:	08000793          	li	a5,128
    80005c94:	f6f71be3          	bne	a4,a5,80005c0a <consoleintr+0x3c>
    80005c98:	a07d                	j	80005d46 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c9a:	0001c717          	auipc	a4,0x1c
    80005c9e:	23670713          	addi	a4,a4,566 # 80021ed0 <cons>
    80005ca2:	0a072783          	lw	a5,160(a4)
    80005ca6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005caa:	0001c497          	auipc	s1,0x1c
    80005cae:	22648493          	addi	s1,s1,550 # 80021ed0 <cons>
    while(cons.e != cons.w &&
    80005cb2:	4929                	li	s2,10
    80005cb4:	f4f70be3          	beq	a4,a5,80005c0a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cb8:	37fd                	addiw	a5,a5,-1
    80005cba:	07f7f713          	andi	a4,a5,127
    80005cbe:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cc0:	01874703          	lbu	a4,24(a4)
    80005cc4:	f52703e3          	beq	a4,s2,80005c0a <consoleintr+0x3c>
      cons.e--;
    80005cc8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ccc:	10000513          	li	a0,256
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	ebc080e7          	jalr	-324(ra) # 80005b8c <consputc>
    while(cons.e != cons.w &&
    80005cd8:	0a04a783          	lw	a5,160(s1)
    80005cdc:	09c4a703          	lw	a4,156(s1)
    80005ce0:	fcf71ce3          	bne	a4,a5,80005cb8 <consoleintr+0xea>
    80005ce4:	b71d                	j	80005c0a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ce6:	0001c717          	auipc	a4,0x1c
    80005cea:	1ea70713          	addi	a4,a4,490 # 80021ed0 <cons>
    80005cee:	0a072783          	lw	a5,160(a4)
    80005cf2:	09c72703          	lw	a4,156(a4)
    80005cf6:	f0f70ae3          	beq	a4,a5,80005c0a <consoleintr+0x3c>
      cons.e--;
    80005cfa:	37fd                	addiw	a5,a5,-1
    80005cfc:	0001c717          	auipc	a4,0x1c
    80005d00:	26f72a23          	sw	a5,628(a4) # 80021f70 <cons+0xa0>
      consputc(BACKSPACE);
    80005d04:	10000513          	li	a0,256
    80005d08:	00000097          	auipc	ra,0x0
    80005d0c:	e84080e7          	jalr	-380(ra) # 80005b8c <consputc>
    80005d10:	bded                	j	80005c0a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d12:	ee048ce3          	beqz	s1,80005c0a <consoleintr+0x3c>
    80005d16:	bf21                	j	80005c2e <consoleintr+0x60>
      consputc(c);
    80005d18:	4529                	li	a0,10
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	e72080e7          	jalr	-398(ra) # 80005b8c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d22:	0001c797          	auipc	a5,0x1c
    80005d26:	1ae78793          	addi	a5,a5,430 # 80021ed0 <cons>
    80005d2a:	0a07a703          	lw	a4,160(a5)
    80005d2e:	0017069b          	addiw	a3,a4,1
    80005d32:	0006861b          	sext.w	a2,a3
    80005d36:	0ad7a023          	sw	a3,160(a5)
    80005d3a:	07f77713          	andi	a4,a4,127
    80005d3e:	97ba                	add	a5,a5,a4
    80005d40:	4729                	li	a4,10
    80005d42:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d46:	0001c797          	auipc	a5,0x1c
    80005d4a:	22c7a323          	sw	a2,550(a5) # 80021f6c <cons+0x9c>
        wakeup(&cons.r);
    80005d4e:	0001c517          	auipc	a0,0x1c
    80005d52:	21a50513          	addi	a0,a0,538 # 80021f68 <cons+0x98>
    80005d56:	ffffc097          	auipc	ra,0xffffc
    80005d5a:	9da080e7          	jalr	-1574(ra) # 80001730 <wakeup>
    80005d5e:	b575                	j	80005c0a <consoleintr+0x3c>

0000000080005d60 <consoleinit>:

void
consoleinit(void)
{
    80005d60:	1141                	addi	sp,sp,-16
    80005d62:	e406                	sd	ra,8(sp)
    80005d64:	e022                	sd	s0,0(sp)
    80005d66:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d68:	00003597          	auipc	a1,0x3
    80005d6c:	ad058593          	addi	a1,a1,-1328 # 80008838 <syscalls+0x430>
    80005d70:	0001c517          	auipc	a0,0x1c
    80005d74:	16050513          	addi	a0,a0,352 # 80021ed0 <cons>
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	584080e7          	jalr	1412(ra) # 800062fc <initlock>

  uartinit();
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	32c080e7          	jalr	812(ra) # 800060ac <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d88:	00013797          	auipc	a5,0x13
    80005d8c:	e7078793          	addi	a5,a5,-400 # 80018bf8 <devsw>
    80005d90:	00000717          	auipc	a4,0x0
    80005d94:	ce470713          	addi	a4,a4,-796 # 80005a74 <consoleread>
    80005d98:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d9a:	00000717          	auipc	a4,0x0
    80005d9e:	c7870713          	addi	a4,a4,-904 # 80005a12 <consolewrite>
    80005da2:	ef98                	sd	a4,24(a5)
}
    80005da4:	60a2                	ld	ra,8(sp)
    80005da6:	6402                	ld	s0,0(sp)
    80005da8:	0141                	addi	sp,sp,16
    80005daa:	8082                	ret

0000000080005dac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005dac:	7179                	addi	sp,sp,-48
    80005dae:	f406                	sd	ra,40(sp)
    80005db0:	f022                	sd	s0,32(sp)
    80005db2:	ec26                	sd	s1,24(sp)
    80005db4:	e84a                	sd	s2,16(sp)
    80005db6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005db8:	c219                	beqz	a2,80005dbe <printint+0x12>
    80005dba:	08054763          	bltz	a0,80005e48 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005dbe:	2501                	sext.w	a0,a0
    80005dc0:	4881                	li	a7,0
    80005dc2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dc6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dc8:	2581                	sext.w	a1,a1
    80005dca:	00003617          	auipc	a2,0x3
    80005dce:	a9e60613          	addi	a2,a2,-1378 # 80008868 <digits>
    80005dd2:	883a                	mv	a6,a4
    80005dd4:	2705                	addiw	a4,a4,1
    80005dd6:	02b577bb          	remuw	a5,a0,a1
    80005dda:	1782                	slli	a5,a5,0x20
    80005ddc:	9381                	srli	a5,a5,0x20
    80005dde:	97b2                	add	a5,a5,a2
    80005de0:	0007c783          	lbu	a5,0(a5)
    80005de4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005de8:	0005079b          	sext.w	a5,a0
    80005dec:	02b5553b          	divuw	a0,a0,a1
    80005df0:	0685                	addi	a3,a3,1
    80005df2:	feb7f0e3          	bgeu	a5,a1,80005dd2 <printint+0x26>

  if(sign)
    80005df6:	00088c63          	beqz	a7,80005e0e <printint+0x62>
    buf[i++] = '-';
    80005dfa:	fe070793          	addi	a5,a4,-32
    80005dfe:	00878733          	add	a4,a5,s0
    80005e02:	02d00793          	li	a5,45
    80005e06:	fef70823          	sb	a5,-16(a4)
    80005e0a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e0e:	02e05763          	blez	a4,80005e3c <printint+0x90>
    80005e12:	fd040793          	addi	a5,s0,-48
    80005e16:	00e784b3          	add	s1,a5,a4
    80005e1a:	fff78913          	addi	s2,a5,-1
    80005e1e:	993a                	add	s2,s2,a4
    80005e20:	377d                	addiw	a4,a4,-1
    80005e22:	1702                	slli	a4,a4,0x20
    80005e24:	9301                	srli	a4,a4,0x20
    80005e26:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e2a:	fff4c503          	lbu	a0,-1(s1)
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	d5e080e7          	jalr	-674(ra) # 80005b8c <consputc>
  while(--i >= 0)
    80005e36:	14fd                	addi	s1,s1,-1
    80005e38:	ff2499e3          	bne	s1,s2,80005e2a <printint+0x7e>
}
    80005e3c:	70a2                	ld	ra,40(sp)
    80005e3e:	7402                	ld	s0,32(sp)
    80005e40:	64e2                	ld	s1,24(sp)
    80005e42:	6942                	ld	s2,16(sp)
    80005e44:	6145                	addi	sp,sp,48
    80005e46:	8082                	ret
    x = -xx;
    80005e48:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e4c:	4885                	li	a7,1
    x = -xx;
    80005e4e:	bf95                	j	80005dc2 <printint+0x16>

0000000080005e50 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e50:	1101                	addi	sp,sp,-32
    80005e52:	ec06                	sd	ra,24(sp)
    80005e54:	e822                	sd	s0,16(sp)
    80005e56:	e426                	sd	s1,8(sp)
    80005e58:	1000                	addi	s0,sp,32
    80005e5a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e5c:	0001c797          	auipc	a5,0x1c
    80005e60:	1207aa23          	sw	zero,308(a5) # 80021f90 <pr+0x18>
  printf("panic: ");
    80005e64:	00003517          	auipc	a0,0x3
    80005e68:	9dc50513          	addi	a0,a0,-1572 # 80008840 <syscalls+0x438>
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	02e080e7          	jalr	46(ra) # 80005e9a <printf>
  printf(s);
    80005e74:	8526                	mv	a0,s1
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	024080e7          	jalr	36(ra) # 80005e9a <printf>
  printf("\n");
    80005e7e:	00002517          	auipc	a0,0x2
    80005e82:	1ca50513          	addi	a0,a0,458 # 80008048 <etext+0x48>
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	014080e7          	jalr	20(ra) # 80005e9a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e8e:	4785                	li	a5,1
    80005e90:	00003717          	auipc	a4,0x3
    80005e94:	aaf72e23          	sw	a5,-1348(a4) # 8000894c <panicked>
  for(;;)
    80005e98:	a001                	j	80005e98 <panic+0x48>

0000000080005e9a <printf>:
{
    80005e9a:	7131                	addi	sp,sp,-192
    80005e9c:	fc86                	sd	ra,120(sp)
    80005e9e:	f8a2                	sd	s0,112(sp)
    80005ea0:	f4a6                	sd	s1,104(sp)
    80005ea2:	f0ca                	sd	s2,96(sp)
    80005ea4:	ecce                	sd	s3,88(sp)
    80005ea6:	e8d2                	sd	s4,80(sp)
    80005ea8:	e4d6                	sd	s5,72(sp)
    80005eaa:	e0da                	sd	s6,64(sp)
    80005eac:	fc5e                	sd	s7,56(sp)
    80005eae:	f862                	sd	s8,48(sp)
    80005eb0:	f466                	sd	s9,40(sp)
    80005eb2:	f06a                	sd	s10,32(sp)
    80005eb4:	ec6e                	sd	s11,24(sp)
    80005eb6:	0100                	addi	s0,sp,128
    80005eb8:	8a2a                	mv	s4,a0
    80005eba:	e40c                	sd	a1,8(s0)
    80005ebc:	e810                	sd	a2,16(s0)
    80005ebe:	ec14                	sd	a3,24(s0)
    80005ec0:	f018                	sd	a4,32(s0)
    80005ec2:	f41c                	sd	a5,40(s0)
    80005ec4:	03043823          	sd	a6,48(s0)
    80005ec8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ecc:	0001cd97          	auipc	s11,0x1c
    80005ed0:	0c4dad83          	lw	s11,196(s11) # 80021f90 <pr+0x18>
  if(locking)
    80005ed4:	020d9b63          	bnez	s11,80005f0a <printf+0x70>
  if (fmt == 0)
    80005ed8:	040a0263          	beqz	s4,80005f1c <printf+0x82>
  va_start(ap, fmt);
    80005edc:	00840793          	addi	a5,s0,8
    80005ee0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ee4:	000a4503          	lbu	a0,0(s4)
    80005ee8:	14050f63          	beqz	a0,80006046 <printf+0x1ac>
    80005eec:	4981                	li	s3,0
    if(c != '%'){
    80005eee:	02500a93          	li	s5,37
    switch(c){
    80005ef2:	07000b93          	li	s7,112
  consputc('x');
    80005ef6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ef8:	00003b17          	auipc	s6,0x3
    80005efc:	970b0b13          	addi	s6,s6,-1680 # 80008868 <digits>
    switch(c){
    80005f00:	07300c93          	li	s9,115
    80005f04:	06400c13          	li	s8,100
    80005f08:	a82d                	j	80005f42 <printf+0xa8>
    acquire(&pr.lock);
    80005f0a:	0001c517          	auipc	a0,0x1c
    80005f0e:	06e50513          	addi	a0,a0,110 # 80021f78 <pr>
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	47a080e7          	jalr	1146(ra) # 8000638c <acquire>
    80005f1a:	bf7d                	j	80005ed8 <printf+0x3e>
    panic("null fmt");
    80005f1c:	00003517          	auipc	a0,0x3
    80005f20:	93450513          	addi	a0,a0,-1740 # 80008850 <syscalls+0x448>
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	f2c080e7          	jalr	-212(ra) # 80005e50 <panic>
      consputc(c);
    80005f2c:	00000097          	auipc	ra,0x0
    80005f30:	c60080e7          	jalr	-928(ra) # 80005b8c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f34:	2985                	addiw	s3,s3,1
    80005f36:	013a07b3          	add	a5,s4,s3
    80005f3a:	0007c503          	lbu	a0,0(a5)
    80005f3e:	10050463          	beqz	a0,80006046 <printf+0x1ac>
    if(c != '%'){
    80005f42:	ff5515e3          	bne	a0,s5,80005f2c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f46:	2985                	addiw	s3,s3,1
    80005f48:	013a07b3          	add	a5,s4,s3
    80005f4c:	0007c783          	lbu	a5,0(a5)
    80005f50:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f54:	cbed                	beqz	a5,80006046 <printf+0x1ac>
    switch(c){
    80005f56:	05778a63          	beq	a5,s7,80005faa <printf+0x110>
    80005f5a:	02fbf663          	bgeu	s7,a5,80005f86 <printf+0xec>
    80005f5e:	09978863          	beq	a5,s9,80005fee <printf+0x154>
    80005f62:	07800713          	li	a4,120
    80005f66:	0ce79563          	bne	a5,a4,80006030 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005f6a:	f8843783          	ld	a5,-120(s0)
    80005f6e:	00878713          	addi	a4,a5,8
    80005f72:	f8e43423          	sd	a4,-120(s0)
    80005f76:	4605                	li	a2,1
    80005f78:	85ea                	mv	a1,s10
    80005f7a:	4388                	lw	a0,0(a5)
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	e30080e7          	jalr	-464(ra) # 80005dac <printint>
      break;
    80005f84:	bf45                	j	80005f34 <printf+0x9a>
    switch(c){
    80005f86:	09578f63          	beq	a5,s5,80006024 <printf+0x18a>
    80005f8a:	0b879363          	bne	a5,s8,80006030 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005f8e:	f8843783          	ld	a5,-120(s0)
    80005f92:	00878713          	addi	a4,a5,8
    80005f96:	f8e43423          	sd	a4,-120(s0)
    80005f9a:	4605                	li	a2,1
    80005f9c:	45a9                	li	a1,10
    80005f9e:	4388                	lw	a0,0(a5)
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	e0c080e7          	jalr	-500(ra) # 80005dac <printint>
      break;
    80005fa8:	b771                	j	80005f34 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005faa:	f8843783          	ld	a5,-120(s0)
    80005fae:	00878713          	addi	a4,a5,8
    80005fb2:	f8e43423          	sd	a4,-120(s0)
    80005fb6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005fba:	03000513          	li	a0,48
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	bce080e7          	jalr	-1074(ra) # 80005b8c <consputc>
  consputc('x');
    80005fc6:	07800513          	li	a0,120
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	bc2080e7          	jalr	-1086(ra) # 80005b8c <consputc>
    80005fd2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fd4:	03c95793          	srli	a5,s2,0x3c
    80005fd8:	97da                	add	a5,a5,s6
    80005fda:	0007c503          	lbu	a0,0(a5)
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	bae080e7          	jalr	-1106(ra) # 80005b8c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fe6:	0912                	slli	s2,s2,0x4
    80005fe8:	34fd                	addiw	s1,s1,-1
    80005fea:	f4ed                	bnez	s1,80005fd4 <printf+0x13a>
    80005fec:	b7a1                	j	80005f34 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fee:	f8843783          	ld	a5,-120(s0)
    80005ff2:	00878713          	addi	a4,a5,8
    80005ff6:	f8e43423          	sd	a4,-120(s0)
    80005ffa:	6384                	ld	s1,0(a5)
    80005ffc:	cc89                	beqz	s1,80006016 <printf+0x17c>
      for(; *s; s++)
    80005ffe:	0004c503          	lbu	a0,0(s1)
    80006002:	d90d                	beqz	a0,80005f34 <printf+0x9a>
        consputc(*s);
    80006004:	00000097          	auipc	ra,0x0
    80006008:	b88080e7          	jalr	-1144(ra) # 80005b8c <consputc>
      for(; *s; s++)
    8000600c:	0485                	addi	s1,s1,1
    8000600e:	0004c503          	lbu	a0,0(s1)
    80006012:	f96d                	bnez	a0,80006004 <printf+0x16a>
    80006014:	b705                	j	80005f34 <printf+0x9a>
        s = "(null)";
    80006016:	00003497          	auipc	s1,0x3
    8000601a:	83248493          	addi	s1,s1,-1998 # 80008848 <syscalls+0x440>
      for(; *s; s++)
    8000601e:	02800513          	li	a0,40
    80006022:	b7cd                	j	80006004 <printf+0x16a>
      consputc('%');
    80006024:	8556                	mv	a0,s5
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	b66080e7          	jalr	-1178(ra) # 80005b8c <consputc>
      break;
    8000602e:	b719                	j	80005f34 <printf+0x9a>
      consputc('%');
    80006030:	8556                	mv	a0,s5
    80006032:	00000097          	auipc	ra,0x0
    80006036:	b5a080e7          	jalr	-1190(ra) # 80005b8c <consputc>
      consputc(c);
    8000603a:	8526                	mv	a0,s1
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	b50080e7          	jalr	-1200(ra) # 80005b8c <consputc>
      break;
    80006044:	bdc5                	j	80005f34 <printf+0x9a>
  if(locking)
    80006046:	020d9163          	bnez	s11,80006068 <printf+0x1ce>
}
    8000604a:	70e6                	ld	ra,120(sp)
    8000604c:	7446                	ld	s0,112(sp)
    8000604e:	74a6                	ld	s1,104(sp)
    80006050:	7906                	ld	s2,96(sp)
    80006052:	69e6                	ld	s3,88(sp)
    80006054:	6a46                	ld	s4,80(sp)
    80006056:	6aa6                	ld	s5,72(sp)
    80006058:	6b06                	ld	s6,64(sp)
    8000605a:	7be2                	ld	s7,56(sp)
    8000605c:	7c42                	ld	s8,48(sp)
    8000605e:	7ca2                	ld	s9,40(sp)
    80006060:	7d02                	ld	s10,32(sp)
    80006062:	6de2                	ld	s11,24(sp)
    80006064:	6129                	addi	sp,sp,192
    80006066:	8082                	ret
    release(&pr.lock);
    80006068:	0001c517          	auipc	a0,0x1c
    8000606c:	f1050513          	addi	a0,a0,-240 # 80021f78 <pr>
    80006070:	00000097          	auipc	ra,0x0
    80006074:	3d0080e7          	jalr	976(ra) # 80006440 <release>
}
    80006078:	bfc9                	j	8000604a <printf+0x1b0>

000000008000607a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000607a:	1101                	addi	sp,sp,-32
    8000607c:	ec06                	sd	ra,24(sp)
    8000607e:	e822                	sd	s0,16(sp)
    80006080:	e426                	sd	s1,8(sp)
    80006082:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006084:	0001c497          	auipc	s1,0x1c
    80006088:	ef448493          	addi	s1,s1,-268 # 80021f78 <pr>
    8000608c:	00002597          	auipc	a1,0x2
    80006090:	7d458593          	addi	a1,a1,2004 # 80008860 <syscalls+0x458>
    80006094:	8526                	mv	a0,s1
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	266080e7          	jalr	614(ra) # 800062fc <initlock>
  pr.locking = 1;
    8000609e:	4785                	li	a5,1
    800060a0:	cc9c                	sw	a5,24(s1)
}
    800060a2:	60e2                	ld	ra,24(sp)
    800060a4:	6442                	ld	s0,16(sp)
    800060a6:	64a2                	ld	s1,8(sp)
    800060a8:	6105                	addi	sp,sp,32
    800060aa:	8082                	ret

00000000800060ac <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060ac:	1141                	addi	sp,sp,-16
    800060ae:	e406                	sd	ra,8(sp)
    800060b0:	e022                	sd	s0,0(sp)
    800060b2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060b4:	100007b7          	lui	a5,0x10000
    800060b8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060bc:	f8000713          	li	a4,-128
    800060c0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060c4:	470d                	li	a4,3
    800060c6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060ca:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060ce:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060d2:	469d                	li	a3,7
    800060d4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060d8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060dc:	00002597          	auipc	a1,0x2
    800060e0:	7a458593          	addi	a1,a1,1956 # 80008880 <digits+0x18>
    800060e4:	0001c517          	auipc	a0,0x1c
    800060e8:	eb450513          	addi	a0,a0,-332 # 80021f98 <uart_tx_lock>
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	210080e7          	jalr	528(ra) # 800062fc <initlock>
}
    800060f4:	60a2                	ld	ra,8(sp)
    800060f6:	6402                	ld	s0,0(sp)
    800060f8:	0141                	addi	sp,sp,16
    800060fa:	8082                	ret

00000000800060fc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060fc:	1101                	addi	sp,sp,-32
    800060fe:	ec06                	sd	ra,24(sp)
    80006100:	e822                	sd	s0,16(sp)
    80006102:	e426                	sd	s1,8(sp)
    80006104:	1000                	addi	s0,sp,32
    80006106:	84aa                	mv	s1,a0
  push_off();
    80006108:	00000097          	auipc	ra,0x0
    8000610c:	238080e7          	jalr	568(ra) # 80006340 <push_off>

  if(panicked){
    80006110:	00003797          	auipc	a5,0x3
    80006114:	83c7a783          	lw	a5,-1988(a5) # 8000894c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006118:	10000737          	lui	a4,0x10000
  if(panicked){
    8000611c:	c391                	beqz	a5,80006120 <uartputc_sync+0x24>
    for(;;)
    8000611e:	a001                	j	8000611e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006120:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006124:	0207f793          	andi	a5,a5,32
    80006128:	dfe5                	beqz	a5,80006120 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000612a:	0ff4f513          	andi	a0,s1,255
    8000612e:	100007b7          	lui	a5,0x10000
    80006132:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006136:	00000097          	auipc	ra,0x0
    8000613a:	2aa080e7          	jalr	682(ra) # 800063e0 <pop_off>
}
    8000613e:	60e2                	ld	ra,24(sp)
    80006140:	6442                	ld	s0,16(sp)
    80006142:	64a2                	ld	s1,8(sp)
    80006144:	6105                	addi	sp,sp,32
    80006146:	8082                	ret

0000000080006148 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006148:	00003797          	auipc	a5,0x3
    8000614c:	8087b783          	ld	a5,-2040(a5) # 80008950 <uart_tx_r>
    80006150:	00003717          	auipc	a4,0x3
    80006154:	80873703          	ld	a4,-2040(a4) # 80008958 <uart_tx_w>
    80006158:	06f70a63          	beq	a4,a5,800061cc <uartstart+0x84>
{
    8000615c:	7139                	addi	sp,sp,-64
    8000615e:	fc06                	sd	ra,56(sp)
    80006160:	f822                	sd	s0,48(sp)
    80006162:	f426                	sd	s1,40(sp)
    80006164:	f04a                	sd	s2,32(sp)
    80006166:	ec4e                	sd	s3,24(sp)
    80006168:	e852                	sd	s4,16(sp)
    8000616a:	e456                	sd	s5,8(sp)
    8000616c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000616e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006172:	0001ca17          	auipc	s4,0x1c
    80006176:	e26a0a13          	addi	s4,s4,-474 # 80021f98 <uart_tx_lock>
    uart_tx_r += 1;
    8000617a:	00002497          	auipc	s1,0x2
    8000617e:	7d648493          	addi	s1,s1,2006 # 80008950 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006182:	00002997          	auipc	s3,0x2
    80006186:	7d698993          	addi	s3,s3,2006 # 80008958 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000618a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000618e:	02077713          	andi	a4,a4,32
    80006192:	c705                	beqz	a4,800061ba <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006194:	01f7f713          	andi	a4,a5,31
    80006198:	9752                	add	a4,a4,s4
    8000619a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000619e:	0785                	addi	a5,a5,1
    800061a0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061a2:	8526                	mv	a0,s1
    800061a4:	ffffb097          	auipc	ra,0xffffb
    800061a8:	58c080e7          	jalr	1420(ra) # 80001730 <wakeup>
    
    WriteReg(THR, c);
    800061ac:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061b0:	609c                	ld	a5,0(s1)
    800061b2:	0009b703          	ld	a4,0(s3)
    800061b6:	fcf71ae3          	bne	a4,a5,8000618a <uartstart+0x42>
  }
}
    800061ba:	70e2                	ld	ra,56(sp)
    800061bc:	7442                	ld	s0,48(sp)
    800061be:	74a2                	ld	s1,40(sp)
    800061c0:	7902                	ld	s2,32(sp)
    800061c2:	69e2                	ld	s3,24(sp)
    800061c4:	6a42                	ld	s4,16(sp)
    800061c6:	6aa2                	ld	s5,8(sp)
    800061c8:	6121                	addi	sp,sp,64
    800061ca:	8082                	ret
    800061cc:	8082                	ret

00000000800061ce <uartputc>:
{
    800061ce:	7179                	addi	sp,sp,-48
    800061d0:	f406                	sd	ra,40(sp)
    800061d2:	f022                	sd	s0,32(sp)
    800061d4:	ec26                	sd	s1,24(sp)
    800061d6:	e84a                	sd	s2,16(sp)
    800061d8:	e44e                	sd	s3,8(sp)
    800061da:	e052                	sd	s4,0(sp)
    800061dc:	1800                	addi	s0,sp,48
    800061de:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061e0:	0001c517          	auipc	a0,0x1c
    800061e4:	db850513          	addi	a0,a0,-584 # 80021f98 <uart_tx_lock>
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	1a4080e7          	jalr	420(ra) # 8000638c <acquire>
  if(panicked){
    800061f0:	00002797          	auipc	a5,0x2
    800061f4:	75c7a783          	lw	a5,1884(a5) # 8000894c <panicked>
    800061f8:	e7c9                	bnez	a5,80006282 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061fa:	00002717          	auipc	a4,0x2
    800061fe:	75e73703          	ld	a4,1886(a4) # 80008958 <uart_tx_w>
    80006202:	00002797          	auipc	a5,0x2
    80006206:	74e7b783          	ld	a5,1870(a5) # 80008950 <uart_tx_r>
    8000620a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000620e:	0001c997          	auipc	s3,0x1c
    80006212:	d8a98993          	addi	s3,s3,-630 # 80021f98 <uart_tx_lock>
    80006216:	00002497          	auipc	s1,0x2
    8000621a:	73a48493          	addi	s1,s1,1850 # 80008950 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000621e:	00002917          	auipc	s2,0x2
    80006222:	73a90913          	addi	s2,s2,1850 # 80008958 <uart_tx_w>
    80006226:	00e79f63          	bne	a5,a4,80006244 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000622a:	85ce                	mv	a1,s3
    8000622c:	8526                	mv	a0,s1
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	49e080e7          	jalr	1182(ra) # 800016cc <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006236:	00093703          	ld	a4,0(s2)
    8000623a:	609c                	ld	a5,0(s1)
    8000623c:	02078793          	addi	a5,a5,32
    80006240:	fee785e3          	beq	a5,a4,8000622a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006244:	0001c497          	auipc	s1,0x1c
    80006248:	d5448493          	addi	s1,s1,-684 # 80021f98 <uart_tx_lock>
    8000624c:	01f77793          	andi	a5,a4,31
    80006250:	97a6                	add	a5,a5,s1
    80006252:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006256:	0705                	addi	a4,a4,1
    80006258:	00002797          	auipc	a5,0x2
    8000625c:	70e7b023          	sd	a4,1792(a5) # 80008958 <uart_tx_w>
  uartstart();
    80006260:	00000097          	auipc	ra,0x0
    80006264:	ee8080e7          	jalr	-280(ra) # 80006148 <uartstart>
  release(&uart_tx_lock);
    80006268:	8526                	mv	a0,s1
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	1d6080e7          	jalr	470(ra) # 80006440 <release>
}
    80006272:	70a2                	ld	ra,40(sp)
    80006274:	7402                	ld	s0,32(sp)
    80006276:	64e2                	ld	s1,24(sp)
    80006278:	6942                	ld	s2,16(sp)
    8000627a:	69a2                	ld	s3,8(sp)
    8000627c:	6a02                	ld	s4,0(sp)
    8000627e:	6145                	addi	sp,sp,48
    80006280:	8082                	ret
    for(;;)
    80006282:	a001                	j	80006282 <uartputc+0xb4>

0000000080006284 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006284:	1141                	addi	sp,sp,-16
    80006286:	e422                	sd	s0,8(sp)
    80006288:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000628a:	100007b7          	lui	a5,0x10000
    8000628e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006292:	8b85                	andi	a5,a5,1
    80006294:	cb91                	beqz	a5,800062a8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006296:	100007b7          	lui	a5,0x10000
    8000629a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000629e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062a2:	6422                	ld	s0,8(sp)
    800062a4:	0141                	addi	sp,sp,16
    800062a6:	8082                	ret
    return -1;
    800062a8:	557d                	li	a0,-1
    800062aa:	bfe5                	j	800062a2 <uartgetc+0x1e>

00000000800062ac <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062ac:	1101                	addi	sp,sp,-32
    800062ae:	ec06                	sd	ra,24(sp)
    800062b0:	e822                	sd	s0,16(sp)
    800062b2:	e426                	sd	s1,8(sp)
    800062b4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062b6:	54fd                	li	s1,-1
    800062b8:	a029                	j	800062c2 <uartintr+0x16>
      break;
    consoleintr(c);
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	914080e7          	jalr	-1772(ra) # 80005bce <consoleintr>
    int c = uartgetc();
    800062c2:	00000097          	auipc	ra,0x0
    800062c6:	fc2080e7          	jalr	-62(ra) # 80006284 <uartgetc>
    if(c == -1)
    800062ca:	fe9518e3          	bne	a0,s1,800062ba <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062ce:	0001c497          	auipc	s1,0x1c
    800062d2:	cca48493          	addi	s1,s1,-822 # 80021f98 <uart_tx_lock>
    800062d6:	8526                	mv	a0,s1
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	0b4080e7          	jalr	180(ra) # 8000638c <acquire>
  uartstart();
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	e68080e7          	jalr	-408(ra) # 80006148 <uartstart>
  release(&uart_tx_lock);
    800062e8:	8526                	mv	a0,s1
    800062ea:	00000097          	auipc	ra,0x0
    800062ee:	156080e7          	jalr	342(ra) # 80006440 <release>
}
    800062f2:	60e2                	ld	ra,24(sp)
    800062f4:	6442                	ld	s0,16(sp)
    800062f6:	64a2                	ld	s1,8(sp)
    800062f8:	6105                	addi	sp,sp,32
    800062fa:	8082                	ret

00000000800062fc <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062fc:	1141                	addi	sp,sp,-16
    800062fe:	e422                	sd	s0,8(sp)
    80006300:	0800                	addi	s0,sp,16
  lk->name = name;
    80006302:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006304:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006308:	00053823          	sd	zero,16(a0)
}
    8000630c:	6422                	ld	s0,8(sp)
    8000630e:	0141                	addi	sp,sp,16
    80006310:	8082                	ret

0000000080006312 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006312:	411c                	lw	a5,0(a0)
    80006314:	e399                	bnez	a5,8000631a <holding+0x8>
    80006316:	4501                	li	a0,0
  return r;
}
    80006318:	8082                	ret
{
    8000631a:	1101                	addi	sp,sp,-32
    8000631c:	ec06                	sd	ra,24(sp)
    8000631e:	e822                	sd	s0,16(sp)
    80006320:	e426                	sd	s1,8(sp)
    80006322:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006324:	6904                	ld	s1,16(a0)
    80006326:	ffffb097          	auipc	ra,0xffffb
    8000632a:	c06080e7          	jalr	-1018(ra) # 80000f2c <mycpu>
    8000632e:	40a48533          	sub	a0,s1,a0
    80006332:	00153513          	seqz	a0,a0
}
    80006336:	60e2                	ld	ra,24(sp)
    80006338:	6442                	ld	s0,16(sp)
    8000633a:	64a2                	ld	s1,8(sp)
    8000633c:	6105                	addi	sp,sp,32
    8000633e:	8082                	ret

0000000080006340 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006340:	1101                	addi	sp,sp,-32
    80006342:	ec06                	sd	ra,24(sp)
    80006344:	e822                	sd	s0,16(sp)
    80006346:	e426                	sd	s1,8(sp)
    80006348:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000634a:	100024f3          	csrr	s1,sstatus
    8000634e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006352:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006354:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006358:	ffffb097          	auipc	ra,0xffffb
    8000635c:	bd4080e7          	jalr	-1068(ra) # 80000f2c <mycpu>
    80006360:	5d3c                	lw	a5,120(a0)
    80006362:	cf89                	beqz	a5,8000637c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006364:	ffffb097          	auipc	ra,0xffffb
    80006368:	bc8080e7          	jalr	-1080(ra) # 80000f2c <mycpu>
    8000636c:	5d3c                	lw	a5,120(a0)
    8000636e:	2785                	addiw	a5,a5,1
    80006370:	dd3c                	sw	a5,120(a0)
}
    80006372:	60e2                	ld	ra,24(sp)
    80006374:	6442                	ld	s0,16(sp)
    80006376:	64a2                	ld	s1,8(sp)
    80006378:	6105                	addi	sp,sp,32
    8000637a:	8082                	ret
    mycpu()->intena = old;
    8000637c:	ffffb097          	auipc	ra,0xffffb
    80006380:	bb0080e7          	jalr	-1104(ra) # 80000f2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006384:	8085                	srli	s1,s1,0x1
    80006386:	8885                	andi	s1,s1,1
    80006388:	dd64                	sw	s1,124(a0)
    8000638a:	bfe9                	j	80006364 <push_off+0x24>

000000008000638c <acquire>:
{
    8000638c:	1101                	addi	sp,sp,-32
    8000638e:	ec06                	sd	ra,24(sp)
    80006390:	e822                	sd	s0,16(sp)
    80006392:	e426                	sd	s1,8(sp)
    80006394:	1000                	addi	s0,sp,32
    80006396:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	fa8080e7          	jalr	-88(ra) # 80006340 <push_off>
  if(holding(lk))
    800063a0:	8526                	mv	a0,s1
    800063a2:	00000097          	auipc	ra,0x0
    800063a6:	f70080e7          	jalr	-144(ra) # 80006312 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063aa:	4705                	li	a4,1
  if(holding(lk))
    800063ac:	e115                	bnez	a0,800063d0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ae:	87ba                	mv	a5,a4
    800063b0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063b4:	2781                	sext.w	a5,a5
    800063b6:	ffe5                	bnez	a5,800063ae <acquire+0x22>
  __sync_synchronize();
    800063b8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063bc:	ffffb097          	auipc	ra,0xffffb
    800063c0:	b70080e7          	jalr	-1168(ra) # 80000f2c <mycpu>
    800063c4:	e888                	sd	a0,16(s1)
}
    800063c6:	60e2                	ld	ra,24(sp)
    800063c8:	6442                	ld	s0,16(sp)
    800063ca:	64a2                	ld	s1,8(sp)
    800063cc:	6105                	addi	sp,sp,32
    800063ce:	8082                	ret
    panic("acquire");
    800063d0:	00002517          	auipc	a0,0x2
    800063d4:	4b850513          	addi	a0,a0,1208 # 80008888 <digits+0x20>
    800063d8:	00000097          	auipc	ra,0x0
    800063dc:	a78080e7          	jalr	-1416(ra) # 80005e50 <panic>

00000000800063e0 <pop_off>:

void
pop_off(void)
{
    800063e0:	1141                	addi	sp,sp,-16
    800063e2:	e406                	sd	ra,8(sp)
    800063e4:	e022                	sd	s0,0(sp)
    800063e6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063e8:	ffffb097          	auipc	ra,0xffffb
    800063ec:	b44080e7          	jalr	-1212(ra) # 80000f2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063f4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063f6:	e78d                	bnez	a5,80006420 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063f8:	5d3c                	lw	a5,120(a0)
    800063fa:	02f05b63          	blez	a5,80006430 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063fe:	37fd                	addiw	a5,a5,-1
    80006400:	0007871b          	sext.w	a4,a5
    80006404:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006406:	eb09                	bnez	a4,80006418 <pop_off+0x38>
    80006408:	5d7c                	lw	a5,124(a0)
    8000640a:	c799                	beqz	a5,80006418 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000640c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006410:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006414:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006418:	60a2                	ld	ra,8(sp)
    8000641a:	6402                	ld	s0,0(sp)
    8000641c:	0141                	addi	sp,sp,16
    8000641e:	8082                	ret
    panic("pop_off - interruptible");
    80006420:	00002517          	auipc	a0,0x2
    80006424:	47050513          	addi	a0,a0,1136 # 80008890 <digits+0x28>
    80006428:	00000097          	auipc	ra,0x0
    8000642c:	a28080e7          	jalr	-1496(ra) # 80005e50 <panic>
    panic("pop_off");
    80006430:	00002517          	auipc	a0,0x2
    80006434:	47850513          	addi	a0,a0,1144 # 800088a8 <digits+0x40>
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	a18080e7          	jalr	-1512(ra) # 80005e50 <panic>

0000000080006440 <release>:
{
    80006440:	1101                	addi	sp,sp,-32
    80006442:	ec06                	sd	ra,24(sp)
    80006444:	e822                	sd	s0,16(sp)
    80006446:	e426                	sd	s1,8(sp)
    80006448:	1000                	addi	s0,sp,32
    8000644a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000644c:	00000097          	auipc	ra,0x0
    80006450:	ec6080e7          	jalr	-314(ra) # 80006312 <holding>
    80006454:	c115                	beqz	a0,80006478 <release+0x38>
  lk->cpu = 0;
    80006456:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000645a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000645e:	0f50000f          	fence	iorw,ow
    80006462:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006466:	00000097          	auipc	ra,0x0
    8000646a:	f7a080e7          	jalr	-134(ra) # 800063e0 <pop_off>
}
    8000646e:	60e2                	ld	ra,24(sp)
    80006470:	6442                	ld	s0,16(sp)
    80006472:	64a2                	ld	s1,8(sp)
    80006474:	6105                	addi	sp,sp,32
    80006476:	8082                	ret
    panic("release");
    80006478:	00002517          	auipc	a0,0x2
    8000647c:	43850513          	addi	a0,a0,1080 # 800088b0 <digits+0x48>
    80006480:	00000097          	auipc	ra,0x0
    80006484:	9d0080e7          	jalr	-1584(ra) # 80005e50 <panic>
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
