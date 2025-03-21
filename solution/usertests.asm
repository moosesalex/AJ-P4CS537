
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char* argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx

  int original_page_cnt[2];
  int page_cnt[2];
  if(procpgdirinfo(original_page_cnt) == -1) {
   f:	8d 45 e8             	lea    -0x18(%ebp),%eax
int main(int argc, char* argv[]) {
  12:	83 ec 1c             	sub    $0x1c,%esp
  if(procpgdirinfo(original_page_cnt) == -1) {
  15:	50                   	push   %eax
  16:	e8 90 03 00 00       	call   3ab <procpgdirinfo>
  1b:	83 c4 10             	add    $0x10,%esp
  1e:	83 f8 ff             	cmp    $0xffffffff,%eax
  21:	74 61                	je     84 <main+0x84>
    printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
  }
  // printf(1, "XV6_TEST_OUTPUT Start of program\n");
  // printf(1, "XV6_TEST_OUTPUT Start of program - base pages:%d huge pages:%d\n", original_page_cnt[0], original_page_cnt[1]);
  char *a = (char *)vmalloc(200, VMALLOC_SIZE_HUGE);
  23:	83 ec 08             	sub    $0x8,%esp
  26:	6a 01                	push   $0x1
  28:	68 c8 00 00 00       	push   $0xc8
  2d:	e8 1e 07 00 00       	call   750 <vmalloc>
  printf(1, "Done with malloc\n");
  32:	5a                   	pop    %edx
  33:	59                   	pop    %ecx
  34:	68 61 0a 00 00       	push   $0xa61
  39:	6a 01                	push   $0x1
  char *a = (char *)vmalloc(200, VMALLOC_SIZE_HUGE);
  3b:	89 c3                	mov    %eax,%ebx
  printf(1, "Done with malloc\n");
  3d:	e8 3e 04 00 00       	call   480 <printf>
  memset(a, 0, 200);
  42:	83 c4 0c             	add    $0xc,%esp
  45:	68 c8 00 00 00       	push   $0xc8
  4a:	6a 00                	push   $0x0
  4c:	53                   	push   %ebx
  4d:	e8 1e 01 00 00       	call   170 <memset>
  if(procpgdirinfo(page_cnt) == -1) {
  52:	8d 45 f0             	lea    -0x10(%ebp),%eax
  55:	89 04 24             	mov    %eax,(%esp)
  58:	e8 4e 03 00 00       	call   3ab <procpgdirinfo>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	83 f8 ff             	cmp    $0xffffffff,%eax
  63:	74 32                	je     97 <main+0x97>
    printf(1,"XV6_TEST_ERROR XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
  }
  printf(1, "XV6_TEST_OUTPUT After vmalloc huge, 200 bytes - program base pages:%d huge pages:%d\n", page_cnt[0] - original_page_cnt[0], page_cnt[1] - original_page_cnt[1]);
  65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  68:	2b 45 ec             	sub    -0x14(%ebp),%eax
  6b:	50                   	push   %eax
  6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  6f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  72:	50                   	push   %eax
  73:	68 0c 0a 00 00       	push   $0xa0c
  78:	6a 01                	push   $0x1
  7a:	e8 01 04 00 00       	call   480 <printf>
  exit();
  7f:	e8 7f 02 00 00       	call   303 <exit>
    printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
  84:	53                   	push   %ebx
  85:	53                   	push   %ebx
  86:	68 98 09 00 00       	push   $0x998
  8b:	6a 01                	push   $0x1
  8d:	e8 ee 03 00 00       	call   480 <printf>
  92:	83 c4 10             	add    $0x10,%esp
  95:	eb 8c                	jmp    23 <main+0x23>
    printf(1,"XV6_TEST_ERROR XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
  97:	50                   	push   %eax
  98:	50                   	push   %eax
  99:	68 cc 09 00 00       	push   $0x9cc
  9e:	6a 01                	push   $0x1
  a0:	e8 db 03 00 00       	call   480 <printf>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	eb bb                	jmp    65 <main+0x65>
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b1:	31 c0                	xor    %eax,%eax
{
  b3:	89 e5                	mov    %esp,%ebp
  b5:	53                   	push   %ebx
  b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  c7:	83 c0 01             	add    $0x1,%eax
  ca:	84 d2                	test   %dl,%dl
  cc:	75 f2                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d1:	89 c8                	mov    %ecx,%eax
  d3:	c9                   	leave  
  d4:	c3                   	ret    
  d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 55 08             	mov    0x8(%ebp),%edx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ea:	0f b6 02             	movzbl (%edx),%eax
  ed:	84 c0                	test   %al,%al
  ef:	75 17                	jne    108 <strcmp+0x28>
  f1:	eb 3a                	jmp    12d <strcmp+0x4d>
  f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f7:	90                   	nop
  f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  fc:	83 c2 01             	add    $0x1,%edx
  ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 102:	84 c0                	test   %al,%al
 104:	74 1a                	je     120 <strcmp+0x40>
    p++, q++;
 106:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 108:	0f b6 19             	movzbl (%ecx),%ebx
 10b:	38 c3                	cmp    %al,%bl
 10d:	74 e9                	je     f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 10f:	29 d8                	sub    %ebx,%eax
}
 111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 114:	c9                   	leave  
 115:	c3                   	ret    
 116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 120:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 124:	31 c0                	xor    %eax,%eax
 126:	29 d8                	sub    %ebx,%eax
}
 128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 12b:	c9                   	leave  
 12c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 12d:	0f b6 19             	movzbl (%ecx),%ebx
 130:	31 c0                	xor    %eax,%eax
 132:	eb db                	jmp    10f <strcmp+0x2f>
 134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 13f:	90                   	nop

00000140 <strlen>:

uint
strlen(const char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 3a 00             	cmpb   $0x0,(%edx)
 149:	74 15                	je     160 <strlen+0x20>
 14b:	31 c0                	xor    %eax,%eax
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	83 c0 01             	add    $0x1,%eax
 153:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 157:	89 c1                	mov    %eax,%ecx
 159:	75 f5                	jne    150 <strlen+0x10>
    ;
  return n;
}
 15b:	89 c8                	mov    %ecx,%eax
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret    
 15f:	90                   	nop
  for(n = 0; s[n]; n++)
 160:	31 c9                	xor    %ecx,%ecx
}
 162:	5d                   	pop    %ebp
 163:	89 c8                	mov    %ecx,%eax
 165:	c3                   	ret    
 166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16d:	8d 76 00             	lea    0x0(%esi),%esi

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld    
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	8b 7d fc             	mov    -0x4(%ebp),%edi
 185:	89 d0                	mov    %edx,%eax
 187:	c9                   	leave  
 188:	c3                   	ret    
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 19a:	0f b6 10             	movzbl (%eax),%edx
 19d:	84 d2                	test   %dl,%dl
 19f:	75 12                	jne    1b3 <strchr+0x23>
 1a1:	eb 1d                	jmp    1c0 <strchr+0x30>
 1a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a7:	90                   	nop
 1a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1ac:	83 c0 01             	add    $0x1,%eax
 1af:	84 d2                	test   %dl,%dl
 1b1:	74 0d                	je     1c0 <strchr+0x30>
    if(*s == c)
 1b3:	38 d1                	cmp    %dl,%cl
 1b5:	75 f1                	jne    1a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1c0:	31 c0                	xor    %eax,%eax
}
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1cf:	90                   	nop

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1d5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1d9:	31 db                	xor    %ebx,%ebx
{
 1db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1de:	eb 27                	jmp    207 <gets+0x37>
    cc = read(0, &c, 1);
 1e0:	83 ec 04             	sub    $0x4,%esp
 1e3:	6a 01                	push   $0x1
 1e5:	57                   	push   %edi
 1e6:	6a 00                	push   $0x0
 1e8:	e8 2e 01 00 00       	call   31b <read>
    if(cc < 1)
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	85 c0                	test   %eax,%eax
 1f2:	7e 1d                	jle    211 <gets+0x41>
      break;
    buf[i++] = c;
 1f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f8:	8b 55 08             	mov    0x8(%ebp),%edx
 1fb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1ff:	3c 0a                	cmp    $0xa,%al
 201:	74 1d                	je     220 <gets+0x50>
 203:	3c 0d                	cmp    $0xd,%al
 205:	74 19                	je     220 <gets+0x50>
  for(i=0; i+1 < max; ){
 207:	89 de                	mov    %ebx,%esi
 209:	83 c3 01             	add    $0x1,%ebx
 20c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 20f:	7c cf                	jl     1e0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 218:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21b:	5b                   	pop    %ebx
 21c:	5e                   	pop    %esi
 21d:	5f                   	pop    %edi
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    
  buf[i] = '\0';
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	89 de                	mov    %ebx,%esi
 225:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 229:	8d 65 f4             	lea    -0xc(%ebp),%esp
 22c:	5b                   	pop    %ebx
 22d:	5e                   	pop    %esi
 22e:	5f                   	pop    %edi
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    
 231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop

00000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	56                   	push   %esi
 244:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 245:	83 ec 08             	sub    $0x8,%esp
 248:	6a 00                	push   $0x0
 24a:	ff 75 08             	push   0x8(%ebp)
 24d:	e8 f1 00 00 00       	call   343 <open>
  if(fd < 0)
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	78 27                	js     280 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	ff 75 0c             	push   0xc(%ebp)
 25f:	89 c3                	mov    %eax,%ebx
 261:	50                   	push   %eax
 262:	e8 f4 00 00 00       	call   35b <fstat>
  close(fd);
 267:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 26a:	89 c6                	mov    %eax,%esi
  close(fd);
 26c:	e8 ba 00 00 00       	call   32b <close>
  return r;
 271:	83 c4 10             	add    $0x10,%esp
}
 274:	8d 65 f8             	lea    -0x8(%ebp),%esp
 277:	89 f0                	mov    %esi,%eax
 279:	5b                   	pop    %ebx
 27a:	5e                   	pop    %esi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 280:	be ff ff ff ff       	mov    $0xffffffff,%esi
 285:	eb ed                	jmp    274 <stat+0x34>
 287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28e:	66 90                	xchg   %ax,%ax

00000290 <atoi>:

int
atoi(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 297:	0f be 02             	movsbl (%edx),%eax
 29a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 29d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2a5:	77 1e                	ja     2c5 <atoi+0x35>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2b0:	83 c2 01             	add    $0x1,%edx
 2b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2ba:	0f be 02             	movsbl (%edx),%eax
 2bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2c0:	80 fb 09             	cmp    $0x9,%bl
 2c3:	76 eb                	jbe    2b0 <atoi+0x20>
  return n;
}
 2c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c8:	89 c8                	mov    %ecx,%eax
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	8b 45 10             	mov    0x10(%ebp),%eax
 2d7:	8b 55 08             	mov    0x8(%ebp),%edx
 2da:	56                   	push   %esi
 2db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	85 c0                	test   %eax,%eax
 2e0:	7e 13                	jle    2f5 <memmove+0x25>
 2e2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2e4:	89 d7                	mov    %edx,%edi
 2e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2f1:	39 f8                	cmp    %edi,%eax
 2f3:	75 fb                	jne    2f0 <memmove+0x20>
  return vdst;
}
 2f5:	5e                   	pop    %esi
 2f6:	89 d0                	mov    %edx,%eax
 2f8:	5f                   	pop    %edi
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    

000002fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fb:	b8 01 00 00 00       	mov    $0x1,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exit>:
SYSCALL(exit)
 303:	b8 02 00 00 00       	mov    $0x2,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <wait>:
SYSCALL(wait)
 30b:	b8 03 00 00 00       	mov    $0x3,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <pipe>:
SYSCALL(pipe)
 313:	b8 04 00 00 00       	mov    $0x4,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <read>:
SYSCALL(read)
 31b:	b8 05 00 00 00       	mov    $0x5,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <write>:
SYSCALL(write)
 323:	b8 10 00 00 00       	mov    $0x10,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <close>:
SYSCALL(close)
 32b:	b8 15 00 00 00       	mov    $0x15,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <kill>:
SYSCALL(kill)
 333:	b8 06 00 00 00       	mov    $0x6,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <exec>:
SYSCALL(exec)
 33b:	b8 07 00 00 00       	mov    $0x7,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <open>:
SYSCALL(open)
 343:	b8 0f 00 00 00       	mov    $0xf,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <mknod>:
SYSCALL(mknod)
 34b:	b8 11 00 00 00       	mov    $0x11,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <unlink>:
SYSCALL(unlink)
 353:	b8 12 00 00 00       	mov    $0x12,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <fstat>:
SYSCALL(fstat)
 35b:	b8 08 00 00 00       	mov    $0x8,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <link>:
SYSCALL(link)
 363:	b8 13 00 00 00       	mov    $0x13,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mkdir>:
SYSCALL(mkdir)
 36b:	b8 14 00 00 00       	mov    $0x14,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <chdir>:
SYSCALL(chdir)
 373:	b8 09 00 00 00       	mov    $0x9,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <dup>:
SYSCALL(dup)
 37b:	b8 0a 00 00 00       	mov    $0xa,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getpid>:
SYSCALL(getpid)
 383:	b8 0b 00 00 00       	mov    $0xb,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <sbrk>:
SYSCALL(sbrk)
 38b:	b8 0c 00 00 00       	mov    $0xc,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <sleep>:
SYSCALL(sleep)
 393:	b8 0d 00 00 00       	mov    $0xd,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <uptime>:
SYSCALL(uptime)
 39b:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <printhugepde>:
SYSCALL(printhugepde)
 3a3:	b8 16 00 00 00       	mov    $0x16,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <procpgdirinfo>:
SYSCALL(procpgdirinfo)
 3ab:	b8 17 00 00 00       	mov    $0x17,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <shugebrk>:
SYSCALL(shugebrk)
 3b3:	b8 18 00 00 00       	mov    $0x18,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <setthp>:
SYSCALL(setthp)
 3bb:	b8 19 00 00 00       	mov    $0x19,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <getthp>:
SYSCALL(getthp)
 3c3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    
 3cb:	66 90                	xchg   %ax,%ax
 3cd:	66 90                	xchg   %ax,%ax
 3cf:	90                   	nop

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 3c             	sub    $0x3c,%esp
 3d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3dc:	89 d1                	mov    %edx,%ecx
{
 3de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3e1:	85 d2                	test   %edx,%edx
 3e3:	0f 89 7f 00 00 00    	jns    468 <printint+0x98>
 3e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ed:	74 79                	je     468 <printint+0x98>
    neg = 1;
 3ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3f8:	31 db                	xor    %ebx,%ebx
 3fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 400:	89 c8                	mov    %ecx,%eax
 402:	31 d2                	xor    %edx,%edx
 404:	89 cf                	mov    %ecx,%edi
 406:	f7 75 c4             	divl   -0x3c(%ebp)
 409:	0f b6 92 d4 0a 00 00 	movzbl 0xad4(%edx),%edx
 410:	89 45 c0             	mov    %eax,-0x40(%ebp)
 413:	89 d8                	mov    %ebx,%eax
 415:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 418:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 41b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 41e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 421:	76 dd                	jbe    400 <printint+0x30>
  if(neg)
 423:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 426:	85 c9                	test   %ecx,%ecx
 428:	74 0c                	je     436 <printint+0x66>
    buf[i++] = '-';
 42a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 42f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 431:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 436:	8b 7d b8             	mov    -0x48(%ebp),%edi
 439:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 43d:	eb 07                	jmp    446 <printint+0x76>
 43f:	90                   	nop
    putc(fd, buf[i]);
 440:	0f b6 13             	movzbl (%ebx),%edx
 443:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 446:	83 ec 04             	sub    $0x4,%esp
 449:	88 55 d7             	mov    %dl,-0x29(%ebp)
 44c:	6a 01                	push   $0x1
 44e:	56                   	push   %esi
 44f:	57                   	push   %edi
 450:	e8 ce fe ff ff       	call   323 <write>
  while(--i >= 0)
 455:	83 c4 10             	add    $0x10,%esp
 458:	39 de                	cmp    %ebx,%esi
 45a:	75 e4                	jne    440 <printint+0x70>
}
 45c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45f:	5b                   	pop    %ebx
 460:	5e                   	pop    %esi
 461:	5f                   	pop    %edi
 462:	5d                   	pop    %ebp
 463:	c3                   	ret    
 464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 468:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 46f:	eb 87                	jmp    3f8 <printint+0x28>
 471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47f:	90                   	nop

00000480 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 48c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 48f:	0f b6 13             	movzbl (%ebx),%edx
 492:	84 d2                	test   %dl,%dl
 494:	74 6a                	je     500 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 496:	8d 45 10             	lea    0x10(%ebp),%eax
 499:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 49c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 49f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 4a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4a4:	eb 36                	jmp    4dc <printf+0x5c>
 4a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
 4b0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4b3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 4b8:	83 f8 25             	cmp    $0x25,%eax
 4bb:	74 15                	je     4d2 <printf+0x52>
  write(fd, &c, 1);
 4bd:	83 ec 04             	sub    $0x4,%esp
 4c0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4c3:	6a 01                	push   $0x1
 4c5:	57                   	push   %edi
 4c6:	56                   	push   %esi
 4c7:	e8 57 fe ff ff       	call   323 <write>
 4cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 4cf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4d2:	0f b6 13             	movzbl (%ebx),%edx
 4d5:	83 c3 01             	add    $0x1,%ebx
 4d8:	84 d2                	test   %dl,%dl
 4da:	74 24                	je     500 <printf+0x80>
    c = fmt[i] & 0xff;
 4dc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 4df:	85 c9                	test   %ecx,%ecx
 4e1:	74 cd                	je     4b0 <printf+0x30>
      }
    } else if(state == '%'){
 4e3:	83 f9 25             	cmp    $0x25,%ecx
 4e6:	75 ea                	jne    4d2 <printf+0x52>
      if(c == 'd'){
 4e8:	83 f8 25             	cmp    $0x25,%eax
 4eb:	0f 84 07 01 00 00    	je     5f8 <printf+0x178>
 4f1:	83 e8 63             	sub    $0x63,%eax
 4f4:	83 f8 15             	cmp    $0x15,%eax
 4f7:	77 17                	ja     510 <printf+0x90>
 4f9:	ff 24 85 7c 0a 00 00 	jmp    *0xa7c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 500:	8d 65 f4             	lea    -0xc(%ebp),%esp
 503:	5b                   	pop    %ebx
 504:	5e                   	pop    %esi
 505:	5f                   	pop    %edi
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    
 508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50f:	90                   	nop
  write(fd, &c, 1);
 510:	83 ec 04             	sub    $0x4,%esp
 513:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 516:	6a 01                	push   $0x1
 518:	57                   	push   %edi
 519:	56                   	push   %esi
 51a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 51e:	e8 00 fe ff ff       	call   323 <write>
        putc(fd, c);
 523:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 527:	83 c4 0c             	add    $0xc,%esp
 52a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 52d:	6a 01                	push   $0x1
 52f:	57                   	push   %edi
 530:	56                   	push   %esi
 531:	e8 ed fd ff ff       	call   323 <write>
        putc(fd, c);
 536:	83 c4 10             	add    $0x10,%esp
      state = 0;
 539:	31 c9                	xor    %ecx,%ecx
 53b:	eb 95                	jmp    4d2 <printf+0x52>
 53d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	b9 10 00 00 00       	mov    $0x10,%ecx
 548:	6a 00                	push   $0x0
 54a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 54d:	8b 10                	mov    (%eax),%edx
 54f:	89 f0                	mov    %esi,%eax
 551:	e8 7a fe ff ff       	call   3d0 <printint>
        ap++;
 556:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 55a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55d:	31 c9                	xor    %ecx,%ecx
 55f:	e9 6e ff ff ff       	jmp    4d2 <printf+0x52>
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 568:	8b 45 d0             	mov    -0x30(%ebp),%eax
 56b:	8b 10                	mov    (%eax),%edx
        ap++;
 56d:	83 c0 04             	add    $0x4,%eax
 570:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 573:	85 d2                	test   %edx,%edx
 575:	0f 84 8d 00 00 00    	je     608 <printf+0x188>
        while(*s != 0){
 57b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 57e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 580:	84 c0                	test   %al,%al
 582:	0f 84 4a ff ff ff    	je     4d2 <printf+0x52>
 588:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 58b:	89 d3                	mov    %edx,%ebx
 58d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
          s++;
 593:	83 c3 01             	add    $0x1,%ebx
 596:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 599:	6a 01                	push   $0x1
 59b:	57                   	push   %edi
 59c:	56                   	push   %esi
 59d:	e8 81 fd ff ff       	call   323 <write>
        while(*s != 0){
 5a2:	0f b6 03             	movzbl (%ebx),%eax
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	84 c0                	test   %al,%al
 5aa:	75 e4                	jne    590 <printf+0x110>
      state = 0;
 5ac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5af:	31 c9                	xor    %ecx,%ecx
 5b1:	e9 1c ff ff ff       	jmp    4d2 <printf+0x52>
 5b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5c8:	6a 01                	push   $0x1
 5ca:	e9 7b ff ff ff       	jmp    54a <printf+0xca>
 5cf:	90                   	nop
        putc(fd, *ap);
 5d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5d6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 5d8:	6a 01                	push   $0x1
 5da:	57                   	push   %edi
 5db:	56                   	push   %esi
        putc(fd, *ap);
 5dc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5df:	e8 3f fd ff ff       	call   323 <write>
        ap++;
 5e4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5eb:	31 c9                	xor    %ecx,%ecx
 5ed:	e9 e0 fe ff ff       	jmp    4d2 <printf+0x52>
 5f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 5f8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5fb:	83 ec 04             	sub    $0x4,%esp
 5fe:	e9 2a ff ff ff       	jmp    52d <printf+0xad>
 603:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 607:	90                   	nop
          s = "(null)";
 608:	ba 73 0a 00 00       	mov    $0xa73,%edx
        while(*s != 0){
 60d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 610:	b8 28 00 00 00       	mov    $0x28,%eax
 615:	89 d3                	mov    %edx,%ebx
 617:	e9 74 ff ff ff       	jmp    590 <printf+0x110>
 61c:	66 90                	xchg   %ax,%ax
 61e:	66 90                	xchg   %ax,%ax

00000620 <vfree>:

// TODO: implement this
// part 2
void
vfree(void *ap)
{
 620:	55                   	push   %ebp
  if(flag == VMALLOC_SIZE_BASE)
  {
    // free regular pages
    Header *bp, *p;
    bp = (Header*)ap - 1;
    for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr){
 621:	a1 f0 0d 00 00       	mov    0xdf0,%eax
{
 626:	89 e5                	mov    %esp,%ebp
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = (Header*)ap - 1;
 62e:	8d 53 f8             	lea    -0x8(%ebx),%edx
  if (((uint) ap) >= ((uint) HUGE_PAGE_START)) {
 631:	81 fb ff ff ff 1d    	cmp    $0x1dffffff,%ebx
 637:	76 4f                	jbe    688 <vfree+0x68>
  {
    // free huge pages
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for(p = hugefreep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	a1 e4 0d 00 00       	mov    0xde4,%eax
 63e:	66 90                	xchg   %ax,%ax
 640:	89 c1                	mov    %eax,%ecx
 642:	8b 00                	mov    (%eax),%eax
 644:	39 d1                	cmp    %edx,%ecx
 646:	73 78                	jae    6c0 <vfree+0xa0>
 648:	39 d0                	cmp    %edx,%eax
 64a:	77 04                	ja     650 <vfree+0x30>
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64c:	39 c1                	cmp    %eax,%ecx
 64e:	72 f0                	jb     640 <vfree+0x20>
        break;
    if(bp + bp->s.size == p->s.ptr){
 650:	8b 73 fc             	mov    -0x4(%ebx),%esi
 653:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 656:	39 f8                	cmp    %edi,%eax
 658:	0f 84 c2 00 00 00    	je     720 <vfree+0x100>
      bp->s.size += p->s.ptr->s.size;
      bp->s.ptr = p->s.ptr->s.ptr;
 65e:	89 43 f8             	mov    %eax,-0x8(%ebx)
    } else
      bp->s.ptr = p->s.ptr;
    if(p + p->s.size == bp){
 661:	8b 41 04             	mov    0x4(%ecx),%eax
 664:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 667:	39 f2                	cmp    %esi,%edx
 669:	74 75                	je     6e0 <vfree+0xc0>
      p->s.size += bp->s.size;
      p->s.ptr = bp->s.ptr;
 66b:	89 11                	mov    %edx,(%ecx)
    } else
      p->s.ptr = bp;
    hugefreep = p;
 66d:	89 0d e4 0d 00 00    	mov    %ecx,0xde4
  }
}
 673:	5b                   	pop    %ebx
 674:	5e                   	pop    %esi
 675:	5f                   	pop    %edi
 676:	5d                   	pop    %ebp
 677:	c3                   	ret    
 678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 680:	39 c1                	cmp    %eax,%ecx
 682:	72 04                	jb     688 <vfree+0x68>
 684:	39 d0                	cmp    %edx,%eax
 686:	77 10                	ja     698 <vfree+0x78>
    for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr){
 688:	89 c1                	mov    %eax,%ecx
 68a:	8b 00                	mov    (%eax),%eax
 68c:	39 d1                	cmp    %edx,%ecx
 68e:	73 f0                	jae    680 <vfree+0x60>
 690:	39 d0                	cmp    %edx,%eax
 692:	77 04                	ja     698 <vfree+0x78>
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	39 c1                	cmp    %eax,%ecx
 696:	72 f0                	jb     688 <vfree+0x68>
    if(bp + bp->s.size == p->s.ptr){
 698:	8b 73 fc             	mov    -0x4(%ebx),%esi
 69b:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 69e:	39 f8                	cmp    %edi,%eax
 6a0:	74 56                	je     6f8 <vfree+0xd8>
      bp->s.ptr = p->s.ptr->s.ptr;
 6a2:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 6a5:	8b 41 04             	mov    0x4(%ecx),%eax
 6a8:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 6ab:	39 f2                	cmp    %esi,%edx
 6ad:	74 60                	je     70f <vfree+0xef>
      p->s.ptr = bp->s.ptr;
 6af:	89 11                	mov    %edx,(%ecx)
}
 6b1:	5b                   	pop    %ebx
    freep = p;
 6b2:	89 0d f0 0d 00 00    	mov    %ecx,0xdf0
}
 6b8:	5e                   	pop    %esi
 6b9:	5f                   	pop    %edi
 6ba:	5d                   	pop    %ebp
 6bb:	c3                   	ret    
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c0:	39 c1                	cmp    %eax,%ecx
 6c2:	0f 82 78 ff ff ff    	jb     640 <vfree+0x20>
 6c8:	39 d0                	cmp    %edx,%eax
 6ca:	0f 86 70 ff ff ff    	jbe    640 <vfree+0x20>
    if(bp + bp->s.size == p->s.ptr){
 6d0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6d3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 6d6:	39 f8                	cmp    %edi,%eax
 6d8:	75 84                	jne    65e <vfree+0x3e>
 6da:	eb 44                	jmp    720 <vfree+0x100>
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p->s.size += bp->s.size;
 6e0:	03 43 fc             	add    -0x4(%ebx),%eax
    hugefreep = p;
 6e3:	89 0d e4 0d 00 00    	mov    %ecx,0xde4
      p->s.size += bp->s.size;
 6e9:	89 41 04             	mov    %eax,0x4(%ecx)
      p->s.ptr = bp->s.ptr;
 6ec:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6ef:	89 11                	mov    %edx,(%ecx)
    hugefreep = p;
 6f1:	eb 80                	jmp    673 <vfree+0x53>
 6f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6f7:	90                   	nop
      bp->s.size += p->s.ptr->s.size;
 6f8:	03 70 04             	add    0x4(%eax),%esi
 6fb:	89 73 fc             	mov    %esi,-0x4(%ebx)
      bp->s.ptr = p->s.ptr->s.ptr;
 6fe:	8b 01                	mov    (%ecx),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 705:	8b 41 04             	mov    0x4(%ecx),%eax
 708:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 70b:	39 f2                	cmp    %esi,%edx
 70d:	75 a0                	jne    6af <vfree+0x8f>
      p->s.size += bp->s.size;
 70f:	03 43 fc             	add    -0x4(%ebx),%eax
 712:	89 41 04             	mov    %eax,0x4(%ecx)
      p->s.ptr = bp->s.ptr;
 715:	8b 53 f8             	mov    -0x8(%ebx),%edx
 718:	eb 95                	jmp    6af <vfree+0x8f>
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      bp->s.size += p->s.ptr->s.size;
 720:	03 70 04             	add    0x4(%eax),%esi
 723:	89 73 fc             	mov    %esi,-0x4(%ebx)
      bp->s.ptr = p->s.ptr->s.ptr;
 726:	8b 01                	mov    (%ecx),%eax
 728:	8b 00                	mov    (%eax),%eax
 72a:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 72d:	8b 41 04             	mov    0x4(%ecx),%eax
 730:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 733:	39 f2                	cmp    %esi,%edx
 735:	0f 85 30 ff ff ff    	jne    66b <vfree+0x4b>
 73b:	eb a3                	jmp    6e0 <vfree+0xc0>
 73d:	8d 76 00             	lea    0x0(%esi),%esi

00000740 <free>:
 vfree(ap);
 740:	e9 db fe ff ff       	jmp    620 <vfree>
 745:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000750 <vmalloc>:
// TODO: implement this
// part 2

void*
vmalloc(uint nbytes, uint flag)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 1c             	sub    $0x1c,%esp
  if(flag == VMALLOC_SIZE_BASE)
 759:	8b 45 0c             	mov    0xc(%ebp),%eax
{
 75c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(flag == VMALLOC_SIZE_BASE)
 75f:	85 c0                	test   %eax,%eax
 761:	0f 84 f9 00 00 00    	je     860 <vmalloc+0x110>
  {
    // alloc huge pages
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 767:	83 c6 07             	add    $0x7,%esi
    if((prevp = hugefreep) == 0){
 76a:	8b 3d e4 0d 00 00    	mov    0xde4,%edi
    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 770:	c1 ee 03             	shr    $0x3,%esi
 773:	83 c6 01             	add    $0x1,%esi
    if((prevp = hugefreep) == 0){
 776:	85 ff                	test   %edi,%edi
 778:	0f 84 b2 00 00 00    	je     830 <vmalloc+0xe0>
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
      hugebase.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77e:	8b 17                	mov    (%edi),%edx
      if(p->s.size >= nunits){
 780:	8b 4a 04             	mov    0x4(%edx),%ecx
 783:	39 f1                	cmp    %esi,%ecx
 785:	73 67                	jae    7ee <vmalloc+0x9e>
 787:	bb 00 00 08 00       	mov    $0x80000,%ebx
 78c:	39 de                	cmp    %ebx,%esi
 78e:	0f 43 de             	cmovae %esi,%ebx
  p = shugebrk(nu * sizeof(Header));
 791:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 798:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 79b:	eb 14                	jmp    7b1 <vmalloc+0x61>
 79d:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	8b 02                	mov    (%edx),%eax
      if(p->s.size >= nunits){
 7a2:	8b 48 04             	mov    0x4(%eax),%ecx
 7a5:	39 f1                	cmp    %esi,%ecx
 7a7:	73 4f                	jae    7f8 <vmalloc+0xa8>
          p->s.size = nunits;
        }
        hugefreep = prevp;
        return (void*)(p + 1);
      }
      if(p == hugefreep)
 7a9:	8b 3d e4 0d 00 00    	mov    0xde4,%edi
 7af:	89 c2                	mov    %eax,%edx
 7b1:	39 d7                	cmp    %edx,%edi
 7b3:	75 eb                	jne    7a0 <vmalloc+0x50>
  p = shugebrk(nu * sizeof(Header));
 7b5:	83 ec 0c             	sub    $0xc,%esp
 7b8:	ff 75 e4             	push   -0x1c(%ebp)
 7bb:	e8 f3 fb ff ff       	call   3b3 <shugebrk>
  if(p == (char*)-1)
 7c0:	83 c4 10             	add    $0x10,%esp
 7c3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7c6:	74 1c                	je     7e4 <vmalloc+0x94>
  hp->s.size = nu;
 7c8:	89 58 04             	mov    %ebx,0x4(%eax)
  vfree((void*)(hp + 1));
 7cb:	83 ec 0c             	sub    $0xc,%esp
 7ce:	83 c0 08             	add    $0x8,%eax
 7d1:	50                   	push   %eax
 7d2:	e8 49 fe ff ff       	call   620 <vfree>
  return hugefreep;
 7d7:	8b 15 e4 0d 00 00    	mov    0xde4,%edx
        if((p = morehugecore(nunits)) == 0)
 7dd:	83 c4 10             	add    $0x10,%esp
 7e0:	85 d2                	test   %edx,%edx
 7e2:	75 bc                	jne    7a0 <vmalloc+0x50>
          return 0;
    }
  }
 7e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
          return 0;
 7e7:	31 c0                	xor    %eax,%eax
 7e9:	5b                   	pop    %ebx
 7ea:	5e                   	pop    %esi
 7eb:	5f                   	pop    %edi
 7ec:	5d                   	pop    %ebp
 7ed:	c3                   	ret    
      if(p->s.size >= nunits){
 7ee:	89 d0                	mov    %edx,%eax
 7f0:	89 fa                	mov    %edi,%edx
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(p->s.size == nunits)
 7f8:	39 ce                	cmp    %ecx,%esi
 7fa:	74 24                	je     820 <vmalloc+0xd0>
          p->s.size -= nunits;
 7fc:	29 f1                	sub    %esi,%ecx
 7fe:	89 48 04             	mov    %ecx,0x4(%eax)
          p += p->s.size;
 801:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
          p->s.size = nunits;
 804:	89 70 04             	mov    %esi,0x4(%eax)
        hugefreep = prevp;
 807:	89 15 e4 0d 00 00    	mov    %edx,0xde4
 80d:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return (void*)(p + 1);
 810:	83 c0 08             	add    $0x8,%eax
 813:	5b                   	pop    %ebx
 814:	5e                   	pop    %esi
 815:	5f                   	pop    %edi
 816:	5d                   	pop    %ebp
 817:	c3                   	ret    
 818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 81f:	90                   	nop
          prevp->s.ptr = p->s.ptr;
 820:	8b 08                	mov    (%eax),%ecx
 822:	89 0a                	mov    %ecx,(%edx)
 824:	eb e1                	jmp    807 <vmalloc+0xb7>
 826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82d:	8d 76 00             	lea    0x0(%esi),%esi
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
 830:	c7 05 e4 0d 00 00 e8 	movl   $0xde8,0xde4
 837:	0d 00 00 
      hugebase.s.size = 0;
 83a:	bf e8 0d 00 00       	mov    $0xde8,%edi
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
 83f:	c7 05 e8 0d 00 00 e8 	movl   $0xde8,0xde8
 846:	0d 00 00 
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 849:	89 fa                	mov    %edi,%edx
      hugebase.s.size = 0;
 84b:	c7 05 ec 0d 00 00 00 	movl   $0x0,0xdec
 852:	00 00 00 
      if(p->s.size >= nunits){
 855:	e9 2d ff ff ff       	jmp    787 <vmalloc+0x37>
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 860:	8d 65 f4             	lea    -0xc(%ebp),%esp
 863:	5b                   	pop    %ebx
 864:	5e                   	pop    %esi
 865:	5f                   	pop    %edi
 866:	5d                   	pop    %ebp
    return malloc(nbytes);
 867:	eb 07                	jmp    870 <malloc>
 869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 1c             	sub    $0x1c,%esp
 879:	8b 75 08             	mov    0x8(%ebp),%esi
  if(nbytes > 1000000 && (getthp() != 0)){
 87c:	81 fe 40 42 0f 00    	cmp    $0xf4240,%esi
 882:	0f 87 b8 00 00 00    	ja     940 <malloc+0xd0>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 888:	83 c6 07             	add    $0x7,%esi
  if((prevp = freep) == 0){
 88b:	8b 3d f0 0d 00 00    	mov    0xdf0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 891:	c1 ee 03             	shr    $0x3,%esi
 894:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 897:	85 ff                	test   %edi,%edi
 899:	0f 84 c1 00 00 00    	je     960 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89f:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 8a1:	8b 4a 04             	mov    0x4(%edx),%ecx
 8a4:	39 f1                	cmp    %esi,%ecx
 8a6:	73 66                	jae    90e <malloc+0x9e>
 8a8:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8ad:	39 de                	cmp    %ebx,%esi
 8af:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8b2:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8bc:	eb 13                	jmp    8d1 <malloc+0x61>
 8be:	66 90                	xchg   %ax,%ax
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8c2:	8b 48 04             	mov    0x4(%eax),%ecx
 8c5:	39 f1                	cmp    %esi,%ecx
 8c7:	73 4f                	jae    918 <malloc+0xa8>
    if(p == freep)
 8c9:	8b 3d f0 0d 00 00    	mov    0xdf0,%edi
 8cf:	89 c2                	mov    %eax,%edx
 8d1:	39 d7                	cmp    %edx,%edi
 8d3:	75 eb                	jne    8c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8d5:	83 ec 0c             	sub    $0xc,%esp
 8d8:	ff 75 e4             	push   -0x1c(%ebp)
 8db:	e8 ab fa ff ff       	call   38b <sbrk>
  if(p == (char*)-1)
 8e0:	83 c4 10             	add    $0x10,%esp
 8e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8e6:	74 1c                	je     904 <malloc+0x94>
  hp->s.size = nu;
 8e8:	89 58 04             	mov    %ebx,0x4(%eax)
  vfree((void*)(hp + 1));
 8eb:	83 ec 0c             	sub    $0xc,%esp
 8ee:	83 c0 08             	add    $0x8,%eax
 8f1:	50                   	push   %eax
 8f2:	e8 29 fd ff ff       	call   620 <vfree>
  return freep;
 8f7:	8b 15 f0 0d 00 00    	mov    0xdf0,%edx
      if((p = morecore(nunits)) == 0)
 8fd:	83 c4 10             	add    $0x10,%esp
 900:	85 d2                	test   %edx,%edx
 902:	75 bc                	jne    8c0 <malloc+0x50>
}
 904:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 907:	31 c0                	xor    %eax,%eax
}
 909:	5b                   	pop    %ebx
 90a:	5e                   	pop    %esi
 90b:	5f                   	pop    %edi
 90c:	5d                   	pop    %ebp
 90d:	c3                   	ret    
    if(p->s.size >= nunits){
 90e:	89 d0                	mov    %edx,%eax
 910:	89 fa                	mov    %edi,%edx
 912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 918:	39 ce                	cmp    %ecx,%esi
 91a:	74 74                	je     990 <malloc+0x120>
        p->s.size -= nunits;
 91c:	29 f1                	sub    %esi,%ecx
 91e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 921:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 924:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 927:	89 15 f0 0d 00 00    	mov    %edx,0xdf0
      return (void*)(p + 1);
 92d:	83 c0 08             	add    $0x8,%eax
}
 930:	8d 65 f4             	lea    -0xc(%ebp),%esp
 933:	5b                   	pop    %ebx
 934:	5e                   	pop    %esi
 935:	5f                   	pop    %edi
 936:	5d                   	pop    %ebp
 937:	c3                   	ret    
 938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93f:	90                   	nop
  if(nbytes > 1000000 && (getthp() != 0)){
 940:	e8 7e fa ff ff       	call   3c3 <getthp>
 945:	85 c0                	test   %eax,%eax
 947:	0f 84 3b ff ff ff    	je     888 <malloc+0x18>
    vmalloc(nbytes, VMALLOC_SIZE_HUGE);
 94d:	83 ec 08             	sub    $0x8,%esp
 950:	6a 01                	push   $0x1
 952:	56                   	push   %esi
 953:	e8 f8 fd ff ff       	call   750 <vmalloc>
    return 0;
 958:	83 c4 10             	add    $0x10,%esp
 95b:	31 c0                	xor    %eax,%eax
 95d:	eb d1                	jmp    930 <malloc+0xc0>
 95f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 960:	c7 05 f0 0d 00 00 f4 	movl   $0xdf4,0xdf0
 967:	0d 00 00 
    base.s.size = 0;
 96a:	bf f4 0d 00 00       	mov    $0xdf4,%edi
    base.s.ptr = freep = prevp = &base;
 96f:	c7 05 f4 0d 00 00 f4 	movl   $0xdf4,0xdf4
 976:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 979:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 97b:	c7 05 f8 0d 00 00 00 	movl   $0x0,0xdf8
 982:	00 00 00 
    if(p->s.size >= nunits){
 985:	e9 1e ff ff ff       	jmp    8a8 <malloc+0x38>
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 990:	8b 08                	mov    (%eax),%ecx
 992:	89 0a                	mov    %ecx,(%edx)
 994:	eb 91                	jmp    927 <malloc+0xb7>
