
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
  if(argc != 3){
   a:	83 39 03             	cmpl   $0x3,(%ecx)
{
   d:	55                   	push   %ebp
   e:	89 e5                	mov    %esp,%ebp
  10:	53                   	push   %ebx
  11:	51                   	push   %ecx
  12:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  15:	74 13                	je     2a <main+0x2a>
    printf(2, "Usage: ln old new\n");
  17:	52                   	push   %edx
  18:	52                   	push   %edx
  19:	68 48 09 00 00       	push   $0x948
  1e:	6a 02                	push   $0x2
  20:	e8 0b 04 00 00       	call   430 <printf>
    exit();
  25:	e8 89 02 00 00       	call   2b3 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2a:	50                   	push   %eax
  2b:	50                   	push   %eax
  2c:	ff 73 08             	push   0x8(%ebx)
  2f:	ff 73 04             	push   0x4(%ebx)
  32:	e8 dc 02 00 00       	call   313 <link>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	85 c0                	test   %eax,%eax
  3c:	78 05                	js     43 <main+0x43>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  3e:	e8 70 02 00 00       	call   2b3 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  43:	ff 73 08             	push   0x8(%ebx)
  46:	ff 73 04             	push   0x4(%ebx)
  49:	68 5b 09 00 00       	push   $0x95b
  4e:	6a 02                	push   $0x2
  50:	e8 db 03 00 00       	call   430 <printf>
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e4                	jmp    3e <main+0x3e>
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  61:	31 c0                	xor    %eax,%eax
{
  63:	89 e5                	mov    %esp,%ebp
  65:	53                   	push   %ebx
  66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  70:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  74:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  77:	83 c0 01             	add    $0x1,%eax
  7a:	84 d2                	test   %dl,%dl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  81:	89 c8                	mov    %ecx,%eax
  83:	c9                   	leave  
  84:	c3                   	ret    
  85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 17                	jne    b8 <strcmp+0x28>
  a1:	eb 3a                	jmp    dd <strcmp+0x4d>
  a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a7:	90                   	nop
  a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  ac:	83 c2 01             	add    $0x1,%edx
  af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  b2:	84 c0                	test   %al,%al
  b4:	74 1a                	je     d0 <strcmp+0x40>
    p++, q++;
  b6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  b8:	0f b6 19             	movzbl (%ecx),%ebx
  bb:	38 c3                	cmp    %al,%bl
  bd:	74 e9                	je     a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  bf:	29 d8                	sub    %ebx,%eax
}
  c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c4:	c9                   	leave  
  c5:	c3                   	ret    
  c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  d4:	31 c0                	xor    %eax,%eax
  d6:	29 d8                	sub    %ebx,%eax
}
  d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  db:	c9                   	leave  
  dc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
  dd:	0f b6 19             	movzbl (%ecx),%ebx
  e0:	31 c0                	xor    %eax,%eax
  e2:	eb db                	jmp    bf <strcmp+0x2f>
  e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ef:	90                   	nop

000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 3a 00             	cmpb   $0x0,(%edx)
  f9:	74 15                	je     110 <strlen+0x20>
  fb:	31 c0                	xor    %eax,%eax
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	83 c0 01             	add    $0x1,%eax
 103:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 107:	89 c1                	mov    %eax,%ecx
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	89 c8                	mov    %ecx,%eax
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    
 10f:	90                   	nop
  for(n = 0; s[n]; n++)
 110:	31 c9                	xor    %ecx,%ecx
}
 112:	5d                   	pop    %ebp
 113:	89 c8                	mov    %ecx,%eax
 115:	c3                   	ret    
 116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	8b 7d fc             	mov    -0x4(%ebp),%edi
 135:	89 d0                	mov    %edx,%eax
 137:	c9                   	leave  
 138:	c3                   	ret    
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 12                	jne    163 <strchr+0x23>
 151:	eb 1d                	jmp    170 <strchr+0x30>
 153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 157:	90                   	nop
 158:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 15c:	83 c0 01             	add    $0x1,%eax
 15f:	84 d2                	test   %dl,%dl
 161:	74 0d                	je     170 <strchr+0x30>
    if(*s == c)
 163:	38 d1                	cmp    %dl,%cl
 165:	75 f1                	jne    158 <strchr+0x18>
      return (char*)s;
  return 0;
}
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 170:	31 c0                	xor    %eax,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 185:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 188:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 189:	31 db                	xor    %ebx,%ebx
{
 18b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 18e:	eb 27                	jmp    1b7 <gets+0x37>
    cc = read(0, &c, 1);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	6a 01                	push   $0x1
 195:	57                   	push   %edi
 196:	6a 00                	push   $0x0
 198:	e8 2e 01 00 00       	call   2cb <read>
    if(cc < 1)
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	85 c0                	test   %eax,%eax
 1a2:	7e 1d                	jle    1c1 <gets+0x41>
      break;
    buf[i++] = c;
 1a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a8:	8b 55 08             	mov    0x8(%ebp),%edx
 1ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1af:	3c 0a                	cmp    $0xa,%al
 1b1:	74 1d                	je     1d0 <gets+0x50>
 1b3:	3c 0d                	cmp    $0xd,%al
 1b5:	74 19                	je     1d0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1b7:	89 de                	mov    %ebx,%esi
 1b9:	83 c3 01             	add    $0x1,%ebx
 1bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1bf:	7c cf                	jl     190 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cb:	5b                   	pop    %ebx
 1cc:	5e                   	pop    %esi
 1cd:	5f                   	pop    %edi
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    
  buf[i] = '\0';
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	89 de                	mov    %ebx,%esi
 1d5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    
 1e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	push   0x8(%ebp)
 1fd:	e8 f1 00 00 00       	call   2f3 <open>
  if(fd < 0)
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	push   0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 f4 00 00 00       	call   30b <fstat>
  close(fd);
 217:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 21a:	89 c6                	mov    %eax,%esi
  close(fd);
 21c:	e8 ba 00 00 00       	call   2db <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23e:	66 90                	xchg   %ax,%ax

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	0f be 02             	movsbl (%edx),%eax
 24a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 24d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 250:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 255:	77 1e                	ja     275 <atoi+0x35>
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 260:	83 c2 01             	add    $0x1,%edx
 263:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 266:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 26a:	0f be 02             	movsbl (%edx),%eax
 26d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
  return n;
}
 275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 278:	89 c8                	mov    %ecx,%eax
 27a:	c9                   	leave  
 27b:	c3                   	ret    
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	8b 45 10             	mov    0x10(%ebp),%eax
 287:	8b 55 08             	mov    0x8(%ebp),%edx
 28a:	56                   	push   %esi
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 c0                	test   %eax,%eax
 290:	7e 13                	jle    2a5 <memmove+0x25>
 292:	01 d0                	add    %edx,%eax
  dst = vdst;
 294:	89 d7                	mov    %edx,%edi
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2a1:	39 f8                	cmp    %edi,%eax
 2a3:	75 fb                	jne    2a0 <memmove+0x20>
  return vdst;
}
 2a5:	5e                   	pop    %esi
 2a6:	89 d0                	mov    %edx,%eax
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <printhugepde>:
SYSCALL(printhugepde)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <procpgdirinfo>:
SYSCALL(procpgdirinfo)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <shugebrk>:
SYSCALL(shugebrk)
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <setthp>:
SYSCALL(setthp)
 36b:	b8 19 00 00 00       	mov    $0x19,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getthp>:
SYSCALL(getthp)
 373:	b8 1a 00 00 00       	mov    $0x1a,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    
 37b:	66 90                	xchg   %ax,%ax
 37d:	66 90                	xchg   %ax,%ax
 37f:	90                   	nop

00000380 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	83 ec 3c             	sub    $0x3c,%esp
 389:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 38c:	89 d1                	mov    %edx,%ecx
{
 38e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 391:	85 d2                	test   %edx,%edx
 393:	0f 89 7f 00 00 00    	jns    418 <printint+0x98>
 399:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 39d:	74 79                	je     418 <printint+0x98>
    neg = 1;
 39f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3a8:	31 db                	xor    %ebx,%ebx
 3aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3b0:	89 c8                	mov    %ecx,%eax
 3b2:	31 d2                	xor    %edx,%edx
 3b4:	89 cf                	mov    %ecx,%edi
 3b6:	f7 75 c4             	divl   -0x3c(%ebp)
 3b9:	0f b6 92 d0 09 00 00 	movzbl 0x9d0(%edx),%edx
 3c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3c3:	89 d8                	mov    %ebx,%eax
 3c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3d1:	76 dd                	jbe    3b0 <printint+0x30>
  if(neg)
 3d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3d6:	85 c9                	test   %ecx,%ecx
 3d8:	74 0c                	je     3e6 <printint+0x66>
    buf[i++] = '-';
 3da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 3df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 3e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 3e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3ed:	eb 07                	jmp    3f6 <printint+0x76>
 3ef:	90                   	nop
    putc(fd, buf[i]);
 3f0:	0f b6 13             	movzbl (%ebx),%edx
 3f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 3f6:	83 ec 04             	sub    $0x4,%esp
 3f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3fc:	6a 01                	push   $0x1
 3fe:	56                   	push   %esi
 3ff:	57                   	push   %edi
 400:	e8 ce fe ff ff       	call   2d3 <write>
  while(--i >= 0)
 405:	83 c4 10             	add    $0x10,%esp
 408:	39 de                	cmp    %ebx,%esi
 40a:	75 e4                	jne    3f0 <printint+0x70>
}
 40c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40f:	5b                   	pop    %ebx
 410:	5e                   	pop    %esi
 411:	5f                   	pop    %edi
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 418:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 41f:	eb 87                	jmp    3a8 <printint+0x28>
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 439:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 43c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 43f:	0f b6 13             	movzbl (%ebx),%edx
 442:	84 d2                	test   %dl,%dl
 444:	74 6a                	je     4b0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 446:	8d 45 10             	lea    0x10(%ebp),%eax
 449:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 44c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 44f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 451:	89 45 d0             	mov    %eax,-0x30(%ebp)
 454:	eb 36                	jmp    48c <printf+0x5c>
 456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
 460:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 463:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 468:	83 f8 25             	cmp    $0x25,%eax
 46b:	74 15                	je     482 <printf+0x52>
  write(fd, &c, 1);
 46d:	83 ec 04             	sub    $0x4,%esp
 470:	88 55 e7             	mov    %dl,-0x19(%ebp)
 473:	6a 01                	push   $0x1
 475:	57                   	push   %edi
 476:	56                   	push   %esi
 477:	e8 57 fe ff ff       	call   2d3 <write>
 47c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 47f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 482:	0f b6 13             	movzbl (%ebx),%edx
 485:	83 c3 01             	add    $0x1,%ebx
 488:	84 d2                	test   %dl,%dl
 48a:	74 24                	je     4b0 <printf+0x80>
    c = fmt[i] & 0xff;
 48c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 48f:	85 c9                	test   %ecx,%ecx
 491:	74 cd                	je     460 <printf+0x30>
      }
    } else if(state == '%'){
 493:	83 f9 25             	cmp    $0x25,%ecx
 496:	75 ea                	jne    482 <printf+0x52>
      if(c == 'd'){
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	0f 84 07 01 00 00    	je     5a8 <printf+0x178>
 4a1:	83 e8 63             	sub    $0x63,%eax
 4a4:	83 f8 15             	cmp    $0x15,%eax
 4a7:	77 17                	ja     4c0 <printf+0x90>
 4a9:	ff 24 85 78 09 00 00 	jmp    *0x978(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
 4b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop
  write(fd, &c, 1);
 4c0:	83 ec 04             	sub    $0x4,%esp
 4c3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 4c6:	6a 01                	push   $0x1
 4c8:	57                   	push   %edi
 4c9:	56                   	push   %esi
 4ca:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ce:	e8 00 fe ff ff       	call   2d3 <write>
        putc(fd, c);
 4d3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 4d7:	83 c4 0c             	add    $0xc,%esp
 4da:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4dd:	6a 01                	push   $0x1
 4df:	57                   	push   %edi
 4e0:	56                   	push   %esi
 4e1:	e8 ed fd ff ff       	call   2d3 <write>
        putc(fd, c);
 4e6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e9:	31 c9                	xor    %ecx,%ecx
 4eb:	eb 95                	jmp    482 <printf+0x52>
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 4f0:	83 ec 0c             	sub    $0xc,%esp
 4f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f8:	6a 00                	push   $0x0
 4fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4fd:	8b 10                	mov    (%eax),%edx
 4ff:	89 f0                	mov    %esi,%eax
 501:	e8 7a fe ff ff       	call   380 <printint>
        ap++;
 506:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 50a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50d:	31 c9                	xor    %ecx,%ecx
 50f:	e9 6e ff ff ff       	jmp    482 <printf+0x52>
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 518:	8b 45 d0             	mov    -0x30(%ebp),%eax
 51b:	8b 10                	mov    (%eax),%edx
        ap++;
 51d:	83 c0 04             	add    $0x4,%eax
 520:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 523:	85 d2                	test   %edx,%edx
 525:	0f 84 8d 00 00 00    	je     5b8 <printf+0x188>
        while(*s != 0){
 52b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 52e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 530:	84 c0                	test   %al,%al
 532:	0f 84 4a ff ff ff    	je     482 <printf+0x52>
 538:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 53b:	89 d3                	mov    %edx,%ebx
 53d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 540:	83 ec 04             	sub    $0x4,%esp
          s++;
 543:	83 c3 01             	add    $0x1,%ebx
 546:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 549:	6a 01                	push   $0x1
 54b:	57                   	push   %edi
 54c:	56                   	push   %esi
 54d:	e8 81 fd ff ff       	call   2d3 <write>
        while(*s != 0){
 552:	0f b6 03             	movzbl (%ebx),%eax
 555:	83 c4 10             	add    $0x10,%esp
 558:	84 c0                	test   %al,%al
 55a:	75 e4                	jne    540 <printf+0x110>
      state = 0;
 55c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 55f:	31 c9                	xor    %ecx,%ecx
 561:	e9 1c ff ff ff       	jmp    482 <printf+0x52>
 566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 0a 00 00 00       	mov    $0xa,%ecx
 578:	6a 01                	push   $0x1
 57a:	e9 7b ff ff ff       	jmp    4fa <printf+0xca>
 57f:	90                   	nop
        putc(fd, *ap);
 580:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 583:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 586:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 588:	6a 01                	push   $0x1
 58a:	57                   	push   %edi
 58b:	56                   	push   %esi
        putc(fd, *ap);
 58c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 58f:	e8 3f fd ff ff       	call   2d3 <write>
        ap++;
 594:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 598:	83 c4 10             	add    $0x10,%esp
      state = 0;
 59b:	31 c9                	xor    %ecx,%ecx
 59d:	e9 e0 fe ff ff       	jmp    482 <printf+0x52>
 5a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 5a8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5ab:	83 ec 04             	sub    $0x4,%esp
 5ae:	e9 2a ff ff ff       	jmp    4dd <printf+0xad>
 5b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5b7:	90                   	nop
          s = "(null)";
 5b8:	ba 6f 09 00 00       	mov    $0x96f,%edx
        while(*s != 0){
 5bd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5c0:	b8 28 00 00 00       	mov    $0x28,%eax
 5c5:	89 d3                	mov    %edx,%ebx
 5c7:	e9 74 ff ff ff       	jmp    540 <printf+0x110>
 5cc:	66 90                	xchg   %ax,%ax
 5ce:	66 90                	xchg   %ax,%ax

000005d0 <vfree>:

// TODO: implement this
// part 2
void
vfree(void *ap)
{
 5d0:	55                   	push   %ebp
  if(flag == VMALLOC_SIZE_BASE)
  {
    // free regular pages
    Header *bp, *p;
    bp = (Header*)ap - 1;
    for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr){
 5d1:	a1 ec 0c 00 00       	mov    0xcec,%eax
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = (Header*)ap - 1;
 5de:	8d 53 f8             	lea    -0x8(%ebx),%edx
  if (((uint) ap) >= ((uint) HUGE_PAGE_START)) {
 5e1:	81 fb ff ff ff 1d    	cmp    $0x1dffffff,%ebx
 5e7:	76 4f                	jbe    638 <vfree+0x68>
  {
    // free huge pages
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for(p = hugefreep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e9:	a1 e0 0c 00 00       	mov    0xce0,%eax
 5ee:	66 90                	xchg   %ax,%ax
 5f0:	89 c1                	mov    %eax,%ecx
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	39 d1                	cmp    %edx,%ecx
 5f6:	73 78                	jae    670 <vfree+0xa0>
 5f8:	39 d0                	cmp    %edx,%eax
 5fa:	77 04                	ja     600 <vfree+0x30>
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fc:	39 c1                	cmp    %eax,%ecx
 5fe:	72 f0                	jb     5f0 <vfree+0x20>
        break;
    if(bp + bp->s.size == p->s.ptr){
 600:	8b 73 fc             	mov    -0x4(%ebx),%esi
 603:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 606:	39 f8                	cmp    %edi,%eax
 608:	0f 84 c2 00 00 00    	je     6d0 <vfree+0x100>
      bp->s.size += p->s.ptr->s.size;
      bp->s.ptr = p->s.ptr->s.ptr;
 60e:	89 43 f8             	mov    %eax,-0x8(%ebx)
    } else
      bp->s.ptr = p->s.ptr;
    if(p + p->s.size == bp){
 611:	8b 41 04             	mov    0x4(%ecx),%eax
 614:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 617:	39 f2                	cmp    %esi,%edx
 619:	74 75                	je     690 <vfree+0xc0>
      p->s.size += bp->s.size;
      p->s.ptr = bp->s.ptr;
 61b:	89 11                	mov    %edx,(%ecx)
    } else
      p->s.ptr = bp;
    hugefreep = p;
 61d:	89 0d e0 0c 00 00    	mov    %ecx,0xce0
  }
}
 623:	5b                   	pop    %ebx
 624:	5e                   	pop    %esi
 625:	5f                   	pop    %edi
 626:	5d                   	pop    %ebp
 627:	c3                   	ret    
 628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	39 c1                	cmp    %eax,%ecx
 632:	72 04                	jb     638 <vfree+0x68>
 634:	39 d0                	cmp    %edx,%eax
 636:	77 10                	ja     648 <vfree+0x78>
    for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr){
 638:	89 c1                	mov    %eax,%ecx
 63a:	8b 00                	mov    (%eax),%eax
 63c:	39 d1                	cmp    %edx,%ecx
 63e:	73 f0                	jae    630 <vfree+0x60>
 640:	39 d0                	cmp    %edx,%eax
 642:	77 04                	ja     648 <vfree+0x78>
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 644:	39 c1                	cmp    %eax,%ecx
 646:	72 f0                	jb     638 <vfree+0x68>
    if(bp + bp->s.size == p->s.ptr){
 648:	8b 73 fc             	mov    -0x4(%ebx),%esi
 64b:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 64e:	39 f8                	cmp    %edi,%eax
 650:	74 56                	je     6a8 <vfree+0xd8>
      bp->s.ptr = p->s.ptr->s.ptr;
 652:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 655:	8b 41 04             	mov    0x4(%ecx),%eax
 658:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 65b:	39 f2                	cmp    %esi,%edx
 65d:	74 60                	je     6bf <vfree+0xef>
      p->s.ptr = bp->s.ptr;
 65f:	89 11                	mov    %edx,(%ecx)
}
 661:	5b                   	pop    %ebx
    freep = p;
 662:	89 0d ec 0c 00 00    	mov    %ecx,0xcec
}
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret    
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 670:	39 c1                	cmp    %eax,%ecx
 672:	0f 82 78 ff ff ff    	jb     5f0 <vfree+0x20>
 678:	39 d0                	cmp    %edx,%eax
 67a:	0f 86 70 ff ff ff    	jbe    5f0 <vfree+0x20>
    if(bp + bp->s.size == p->s.ptr){
 680:	8b 73 fc             	mov    -0x4(%ebx),%esi
 683:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 686:	39 f8                	cmp    %edi,%eax
 688:	75 84                	jne    60e <vfree+0x3e>
 68a:	eb 44                	jmp    6d0 <vfree+0x100>
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p->s.size += bp->s.size;
 690:	03 43 fc             	add    -0x4(%ebx),%eax
    hugefreep = p;
 693:	89 0d e0 0c 00 00    	mov    %ecx,0xce0
      p->s.size += bp->s.size;
 699:	89 41 04             	mov    %eax,0x4(%ecx)
      p->s.ptr = bp->s.ptr;
 69c:	8b 53 f8             	mov    -0x8(%ebx),%edx
 69f:	89 11                	mov    %edx,(%ecx)
    hugefreep = p;
 6a1:	eb 80                	jmp    623 <vfree+0x53>
 6a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6a7:	90                   	nop
      bp->s.size += p->s.ptr->s.size;
 6a8:	03 70 04             	add    0x4(%eax),%esi
 6ab:	89 73 fc             	mov    %esi,-0x4(%ebx)
      bp->s.ptr = p->s.ptr->s.ptr;
 6ae:	8b 01                	mov    (%ecx),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 6b5:	8b 41 04             	mov    0x4(%ecx),%eax
 6b8:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 6bb:	39 f2                	cmp    %esi,%edx
 6bd:	75 a0                	jne    65f <vfree+0x8f>
      p->s.size += bp->s.size;
 6bf:	03 43 fc             	add    -0x4(%ebx),%eax
 6c2:	89 41 04             	mov    %eax,0x4(%ecx)
      p->s.ptr = bp->s.ptr;
 6c5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6c8:	eb 95                	jmp    65f <vfree+0x8f>
 6ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      bp->s.size += p->s.ptr->s.size;
 6d0:	03 70 04             	add    0x4(%eax),%esi
 6d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
      bp->s.ptr = p->s.ptr->s.ptr;
 6d6:	8b 01                	mov    (%ecx),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 6dd:	8b 41 04             	mov    0x4(%ecx),%eax
 6e0:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 6e3:	39 f2                	cmp    %esi,%edx
 6e5:	0f 85 30 ff ff ff    	jne    61b <vfree+0x4b>
 6eb:	eb a3                	jmp    690 <vfree+0xc0>
 6ed:	8d 76 00             	lea    0x0(%esi),%esi

000006f0 <free>:
 vfree(ap);
 6f0:	e9 db fe ff ff       	jmp    5d0 <vfree>
 6f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000700 <vmalloc>:
// TODO: implement this
// part 2

void*
vmalloc(uint nbytes, uint flag)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 1c             	sub    $0x1c,%esp
  if(flag == VMALLOC_SIZE_BASE)
 709:	8b 45 0c             	mov    0xc(%ebp),%eax
{
 70c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(flag == VMALLOC_SIZE_BASE)
 70f:	85 c0                	test   %eax,%eax
 711:	0f 84 f9 00 00 00    	je     810 <vmalloc+0x110>
  {
    // alloc huge pages
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 717:	83 c6 07             	add    $0x7,%esi
    if((prevp = hugefreep) == 0){
 71a:	8b 3d e0 0c 00 00    	mov    0xce0,%edi
    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 720:	c1 ee 03             	shr    $0x3,%esi
 723:	83 c6 01             	add    $0x1,%esi
    if((prevp = hugefreep) == 0){
 726:	85 ff                	test   %edi,%edi
 728:	0f 84 b2 00 00 00    	je     7e0 <vmalloc+0xe0>
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
      hugebase.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	8b 17                	mov    (%edi),%edx
      if(p->s.size >= nunits){
 730:	8b 4a 04             	mov    0x4(%edx),%ecx
 733:	39 f1                	cmp    %esi,%ecx
 735:	73 67                	jae    79e <vmalloc+0x9e>
 737:	bb 00 00 08 00       	mov    $0x80000,%ebx
 73c:	39 de                	cmp    %ebx,%esi
 73e:	0f 43 de             	cmovae %esi,%ebx
  p = shugebrk(nu * sizeof(Header));
 741:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 748:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 74b:	eb 14                	jmp    761 <vmalloc+0x61>
 74d:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 750:	8b 02                	mov    (%edx),%eax
      if(p->s.size >= nunits){
 752:	8b 48 04             	mov    0x4(%eax),%ecx
 755:	39 f1                	cmp    %esi,%ecx
 757:	73 4f                	jae    7a8 <vmalloc+0xa8>
          p->s.size = nunits;
        }
        hugefreep = prevp;
        return (void*)(p + 1);
      }
      if(p == hugefreep)
 759:	8b 3d e0 0c 00 00    	mov    0xce0,%edi
 75f:	89 c2                	mov    %eax,%edx
 761:	39 d7                	cmp    %edx,%edi
 763:	75 eb                	jne    750 <vmalloc+0x50>
  p = shugebrk(nu * sizeof(Header));
 765:	83 ec 0c             	sub    $0xc,%esp
 768:	ff 75 e4             	push   -0x1c(%ebp)
 76b:	e8 f3 fb ff ff       	call   363 <shugebrk>
  if(p == (char*)-1)
 770:	83 c4 10             	add    $0x10,%esp
 773:	83 f8 ff             	cmp    $0xffffffff,%eax
 776:	74 1c                	je     794 <vmalloc+0x94>
  hp->s.size = nu;
 778:	89 58 04             	mov    %ebx,0x4(%eax)
  vfree((void*)(hp + 1));
 77b:	83 ec 0c             	sub    $0xc,%esp
 77e:	83 c0 08             	add    $0x8,%eax
 781:	50                   	push   %eax
 782:	e8 49 fe ff ff       	call   5d0 <vfree>
  return hugefreep;
 787:	8b 15 e0 0c 00 00    	mov    0xce0,%edx
        if((p = morehugecore(nunits)) == 0)
 78d:	83 c4 10             	add    $0x10,%esp
 790:	85 d2                	test   %edx,%edx
 792:	75 bc                	jne    750 <vmalloc+0x50>
          return 0;
    }
  }
 794:	8d 65 f4             	lea    -0xc(%ebp),%esp
          return 0;
 797:	31 c0                	xor    %eax,%eax
 799:	5b                   	pop    %ebx
 79a:	5e                   	pop    %esi
 79b:	5f                   	pop    %edi
 79c:	5d                   	pop    %ebp
 79d:	c3                   	ret    
      if(p->s.size >= nunits){
 79e:	89 d0                	mov    %edx,%eax
 7a0:	89 fa                	mov    %edi,%edx
 7a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(p->s.size == nunits)
 7a8:	39 ce                	cmp    %ecx,%esi
 7aa:	74 24                	je     7d0 <vmalloc+0xd0>
          p->s.size -= nunits;
 7ac:	29 f1                	sub    %esi,%ecx
 7ae:	89 48 04             	mov    %ecx,0x4(%eax)
          p += p->s.size;
 7b1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
          p->s.size = nunits;
 7b4:	89 70 04             	mov    %esi,0x4(%eax)
        hugefreep = prevp;
 7b7:	89 15 e0 0c 00 00    	mov    %edx,0xce0
 7bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return (void*)(p + 1);
 7c0:	83 c0 08             	add    $0x8,%eax
 7c3:	5b                   	pop    %ebx
 7c4:	5e                   	pop    %esi
 7c5:	5f                   	pop    %edi
 7c6:	5d                   	pop    %ebp
 7c7:	c3                   	ret    
 7c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7cf:	90                   	nop
          prevp->s.ptr = p->s.ptr;
 7d0:	8b 08                	mov    (%eax),%ecx
 7d2:	89 0a                	mov    %ecx,(%edx)
 7d4:	eb e1                	jmp    7b7 <vmalloc+0xb7>
 7d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
 7e0:	c7 05 e0 0c 00 00 e4 	movl   $0xce4,0xce0
 7e7:	0c 00 00 
      hugebase.s.size = 0;
 7ea:	bf e4 0c 00 00       	mov    $0xce4,%edi
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
 7ef:	c7 05 e4 0c 00 00 e4 	movl   $0xce4,0xce4
 7f6:	0c 00 00 
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	89 fa                	mov    %edi,%edx
      hugebase.s.size = 0;
 7fb:	c7 05 e8 0c 00 00 00 	movl   $0x0,0xce8
 802:	00 00 00 
      if(p->s.size >= nunits){
 805:	e9 2d ff ff ff       	jmp    737 <vmalloc+0x37>
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 810:	8d 65 f4             	lea    -0xc(%ebp),%esp
 813:	5b                   	pop    %ebx
 814:	5e                   	pop    %esi
 815:	5f                   	pop    %edi
 816:	5d                   	pop    %ebp
    return malloc(nbytes);
 817:	eb 07                	jmp    820 <malloc>
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000820 <malloc>:
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
 826:	83 ec 1c             	sub    $0x1c,%esp
 829:	8b 75 08             	mov    0x8(%ebp),%esi
  if(nbytes > 1000000 && (getthp() != 0)){
 82c:	81 fe 40 42 0f 00    	cmp    $0xf4240,%esi
 832:	0f 87 b8 00 00 00    	ja     8f0 <malloc+0xd0>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 838:	83 c6 07             	add    $0x7,%esi
  if((prevp = freep) == 0){
 83b:	8b 3d ec 0c 00 00    	mov    0xcec,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 841:	c1 ee 03             	shr    $0x3,%esi
 844:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 847:	85 ff                	test   %edi,%edi
 849:	0f 84 c1 00 00 00    	je     910 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84f:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 851:	8b 4a 04             	mov    0x4(%edx),%ecx
 854:	39 f1                	cmp    %esi,%ecx
 856:	73 66                	jae    8be <malloc+0x9e>
 858:	bb 00 10 00 00       	mov    $0x1000,%ebx
 85d:	39 de                	cmp    %ebx,%esi
 85f:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 862:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 86c:	eb 13                	jmp    881 <malloc+0x61>
 86e:	66 90                	xchg   %ax,%ax
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 872:	8b 48 04             	mov    0x4(%eax),%ecx
 875:	39 f1                	cmp    %esi,%ecx
 877:	73 4f                	jae    8c8 <malloc+0xa8>
    if(p == freep)
 879:	8b 3d ec 0c 00 00    	mov    0xcec,%edi
 87f:	89 c2                	mov    %eax,%edx
 881:	39 d7                	cmp    %edx,%edi
 883:	75 eb                	jne    870 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 885:	83 ec 0c             	sub    $0xc,%esp
 888:	ff 75 e4             	push   -0x1c(%ebp)
 88b:	e8 ab fa ff ff       	call   33b <sbrk>
  if(p == (char*)-1)
 890:	83 c4 10             	add    $0x10,%esp
 893:	83 f8 ff             	cmp    $0xffffffff,%eax
 896:	74 1c                	je     8b4 <malloc+0x94>
  hp->s.size = nu;
 898:	89 58 04             	mov    %ebx,0x4(%eax)
  vfree((void*)(hp + 1));
 89b:	83 ec 0c             	sub    $0xc,%esp
 89e:	83 c0 08             	add    $0x8,%eax
 8a1:	50                   	push   %eax
 8a2:	e8 29 fd ff ff       	call   5d0 <vfree>
  return freep;
 8a7:	8b 15 ec 0c 00 00    	mov    0xcec,%edx
      if((p = morecore(nunits)) == 0)
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	85 d2                	test   %edx,%edx
 8b2:	75 bc                	jne    870 <malloc+0x50>
}
 8b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8b7:	31 c0                	xor    %eax,%eax
}
 8b9:	5b                   	pop    %ebx
 8ba:	5e                   	pop    %esi
 8bb:	5f                   	pop    %edi
 8bc:	5d                   	pop    %ebp
 8bd:	c3                   	ret    
    if(p->s.size >= nunits){
 8be:	89 d0                	mov    %edx,%eax
 8c0:	89 fa                	mov    %edi,%edx
 8c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8c8:	39 ce                	cmp    %ecx,%esi
 8ca:	74 74                	je     940 <malloc+0x120>
        p->s.size -= nunits;
 8cc:	29 f1                	sub    %esi,%ecx
 8ce:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8d1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8d4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 8d7:	89 15 ec 0c 00 00    	mov    %edx,0xcec
      return (void*)(p + 1);
 8dd:	83 c0 08             	add    $0x8,%eax
}
 8e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8e3:	5b                   	pop    %ebx
 8e4:	5e                   	pop    %esi
 8e5:	5f                   	pop    %edi
 8e6:	5d                   	pop    %ebp
 8e7:	c3                   	ret    
 8e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ef:	90                   	nop
  if(nbytes > 1000000 && (getthp() != 0)){
 8f0:	e8 7e fa ff ff       	call   373 <getthp>
 8f5:	85 c0                	test   %eax,%eax
 8f7:	0f 84 3b ff ff ff    	je     838 <malloc+0x18>
    vmalloc(nbytes, VMALLOC_SIZE_HUGE);
 8fd:	83 ec 08             	sub    $0x8,%esp
 900:	6a 01                	push   $0x1
 902:	56                   	push   %esi
 903:	e8 f8 fd ff ff       	call   700 <vmalloc>
    return 0;
 908:	83 c4 10             	add    $0x10,%esp
 90b:	31 c0                	xor    %eax,%eax
 90d:	eb d1                	jmp    8e0 <malloc+0xc0>
 90f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 910:	c7 05 ec 0c 00 00 f0 	movl   $0xcf0,0xcec
 917:	0c 00 00 
    base.s.size = 0;
 91a:	bf f0 0c 00 00       	mov    $0xcf0,%edi
    base.s.ptr = freep = prevp = &base;
 91f:	c7 05 f0 0c 00 00 f0 	movl   $0xcf0,0xcf0
 926:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 929:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 92b:	c7 05 f4 0c 00 00 00 	movl   $0x0,0xcf4
 932:	00 00 00 
    if(p->s.size >= nunits){
 935:	e9 1e ff ff ff       	jmp    858 <malloc+0x38>
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 940:	8b 08                	mov    (%eax),%ecx
 942:	89 0a                	mov    %ecx,(%edx)
 944:	eb 91                	jmp    8d7 <malloc+0xb7>
