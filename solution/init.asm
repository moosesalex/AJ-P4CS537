
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 d8 09 00 00       	push   $0x9d8
  19:	e8 65 03 00 00       	call   383 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 9f 00 00 00    	js     c8 <main+0xc8>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 88 03 00 00       	call   3bb <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 7c 03 00 00       	call   3bb <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 e0 09 00 00       	push   $0x9e0
  50:	6a 01                	push   $0x1
  52:	e8 69 04 00 00       	call   4c0 <printf>
    pid = fork();
  57:	e8 df 02 00 00       	call   33b <fork>
    if(pid < 0){
  5c:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  5f:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  61:	85 c0                	test   %eax,%eax
  63:	78 2c                	js     91 <main+0x91>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  65:	74 3d                	je     a4 <main+0xa4>
  67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6e:	66 90                	xchg   %ax,%ax
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  70:	e8 d6 02 00 00       	call   34b <wait>
  75:	85 c0                	test   %eax,%eax
  77:	78 cf                	js     48 <main+0x48>
  79:	39 c3                	cmp    %eax,%ebx
  7b:	74 cb                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  7d:	83 ec 08             	sub    $0x8,%esp
  80:	68 1f 0a 00 00       	push   $0xa1f
  85:	6a 01                	push   $0x1
  87:	e8 34 04 00 00       	call   4c0 <printf>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	eb df                	jmp    70 <main+0x70>
      printf(1, "init: fork failed\n");
  91:	53                   	push   %ebx
  92:	53                   	push   %ebx
  93:	68 f3 09 00 00       	push   $0x9f3
  98:	6a 01                	push   $0x1
  9a:	e8 21 04 00 00       	call   4c0 <printf>
      exit();
  9f:	e8 9f 02 00 00       	call   343 <exit>
      exec("sh", argv);
  a4:	50                   	push   %eax
  a5:	50                   	push   %eax
  a6:	68 98 0d 00 00       	push   $0xd98
  ab:	68 06 0a 00 00       	push   $0xa06
  b0:	e8 c6 02 00 00       	call   37b <exec>
      printf(1, "init: exec sh failed\n");
  b5:	5a                   	pop    %edx
  b6:	59                   	pop    %ecx
  b7:	68 09 0a 00 00       	push   $0xa09
  bc:	6a 01                	push   $0x1
  be:	e8 fd 03 00 00       	call   4c0 <printf>
      exit();
  c3:	e8 7b 02 00 00       	call   343 <exit>
    mknod("console", 1, 1);
  c8:	50                   	push   %eax
  c9:	6a 01                	push   $0x1
  cb:	6a 01                	push   $0x1
  cd:	68 d8 09 00 00       	push   $0x9d8
  d2:	e8 b4 02 00 00       	call   38b <mknod>
    open("console", O_RDWR);
  d7:	58                   	pop    %eax
  d8:	5a                   	pop    %edx
  d9:	6a 02                	push   $0x2
  db:	68 d8 09 00 00       	push   $0x9d8
  e0:	e8 9e 02 00 00       	call   383 <open>
  e5:	83 c4 10             	add    $0x10,%esp
  e8:	e9 3c ff ff ff       	jmp    29 <main+0x29>
  ed:	66 90                	xchg   %ax,%ax
  ef:	90                   	nop

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f1:	31 c0                	xor    %eax,%eax
{
  f3:	89 e5                	mov    %esp,%ebp
  f5:	53                   	push   %ebx
  f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 100:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 104:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 107:	83 c0 01             	add    $0x1,%eax
 10a:	84 d2                	test   %dl,%dl
 10c:	75 f2                	jne    100 <strcpy+0x10>
    ;
  return os;
}
 10e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 111:	89 c8                	mov    %ecx,%eax
 113:	c9                   	leave  
 114:	c3                   	ret    
 115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 55 08             	mov    0x8(%ebp),%edx
 127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 12a:	0f b6 02             	movzbl (%edx),%eax
 12d:	84 c0                	test   %al,%al
 12f:	75 17                	jne    148 <strcmp+0x28>
 131:	eb 3a                	jmp    16d <strcmp+0x4d>
 133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 137:	90                   	nop
 138:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 13c:	83 c2 01             	add    $0x1,%edx
 13f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 142:	84 c0                	test   %al,%al
 144:	74 1a                	je     160 <strcmp+0x40>
    p++, q++;
 146:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 148:	0f b6 19             	movzbl (%ecx),%ebx
 14b:	38 c3                	cmp    %al,%bl
 14d:	74 e9                	je     138 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 14f:	29 d8                	sub    %ebx,%eax
}
 151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 154:	c9                   	leave  
 155:	c3                   	ret    
 156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 160:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 164:	31 c0                	xor    %eax,%eax
 166:	29 d8                	sub    %ebx,%eax
}
 168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 16b:	c9                   	leave  
 16c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 16d:	0f b6 19             	movzbl (%ecx),%ebx
 170:	31 c0                	xor    %eax,%eax
 172:	eb db                	jmp    14f <strcmp+0x2f>
 174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop

00000180 <strlen>:

uint
strlen(const char *s)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 186:	80 3a 00             	cmpb   $0x0,(%edx)
 189:	74 15                	je     1a0 <strlen+0x20>
 18b:	31 c0                	xor    %eax,%eax
 18d:	8d 76 00             	lea    0x0(%esi),%esi
 190:	83 c0 01             	add    $0x1,%eax
 193:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 197:	89 c1                	mov    %eax,%ecx
 199:	75 f5                	jne    190 <strlen+0x10>
    ;
  return n;
}
 19b:	89 c8                	mov    %ecx,%eax
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret    
 19f:	90                   	nop
  for(n = 0; s[n]; n++)
 1a0:	31 c9                	xor    %ecx,%ecx
}
 1a2:	5d                   	pop    %ebp
 1a3:	89 c8                	mov    %ecx,%eax
 1a5:	c3                   	ret    
 1a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ad:	8d 76 00             	lea    0x0(%esi),%esi

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	89 d7                	mov    %edx,%edi
 1bf:	fc                   	cld    
 1c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1c5:	89 d0                	mov    %edx,%eax
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1da:	0f b6 10             	movzbl (%eax),%edx
 1dd:	84 d2                	test   %dl,%dl
 1df:	75 12                	jne    1f3 <strchr+0x23>
 1e1:	eb 1d                	jmp    200 <strchr+0x30>
 1e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e7:	90                   	nop
 1e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1ec:	83 c0 01             	add    $0x1,%eax
 1ef:	84 d2                	test   %dl,%dl
 1f1:	74 0d                	je     200 <strchr+0x30>
    if(*s == c)
 1f3:	38 d1                	cmp    %dl,%cl
 1f5:	75 f1                	jne    1e8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 200:	31 c0                	xor    %eax,%eax
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 20f:	90                   	nop

00000210 <gets>:

char*
gets(char *buf, int max)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 215:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 218:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 219:	31 db                	xor    %ebx,%ebx
{
 21b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 21e:	eb 27                	jmp    247 <gets+0x37>
    cc = read(0, &c, 1);
 220:	83 ec 04             	sub    $0x4,%esp
 223:	6a 01                	push   $0x1
 225:	57                   	push   %edi
 226:	6a 00                	push   $0x0
 228:	e8 2e 01 00 00       	call   35b <read>
    if(cc < 1)
 22d:	83 c4 10             	add    $0x10,%esp
 230:	85 c0                	test   %eax,%eax
 232:	7e 1d                	jle    251 <gets+0x41>
      break;
    buf[i++] = c;
 234:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 238:	8b 55 08             	mov    0x8(%ebp),%edx
 23b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 23f:	3c 0a                	cmp    $0xa,%al
 241:	74 1d                	je     260 <gets+0x50>
 243:	3c 0d                	cmp    $0xd,%al
 245:	74 19                	je     260 <gets+0x50>
  for(i=0; i+1 < max; ){
 247:	89 de                	mov    %ebx,%esi
 249:	83 c3 01             	add    $0x1,%ebx
 24c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 24f:	7c cf                	jl     220 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 258:	8d 65 f4             	lea    -0xc(%ebp),%esp
 25b:	5b                   	pop    %ebx
 25c:	5e                   	pop    %esi
 25d:	5f                   	pop    %edi
 25e:	5d                   	pop    %ebp
 25f:	c3                   	ret    
  buf[i] = '\0';
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	89 de                	mov    %ebx,%esi
 265:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 269:	8d 65 f4             	lea    -0xc(%ebp),%esp
 26c:	5b                   	pop    %ebx
 26d:	5e                   	pop    %esi
 26e:	5f                   	pop    %edi
 26f:	5d                   	pop    %ebp
 270:	c3                   	ret    
 271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27f:	90                   	nop

00000280 <stat>:

int
stat(const char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	6a 00                	push   $0x0
 28a:	ff 75 08             	push   0x8(%ebp)
 28d:	e8 f1 00 00 00       	call   383 <open>
  if(fd < 0)
 292:	83 c4 10             	add    $0x10,%esp
 295:	85 c0                	test   %eax,%eax
 297:	78 27                	js     2c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	ff 75 0c             	push   0xc(%ebp)
 29f:	89 c3                	mov    %eax,%ebx
 2a1:	50                   	push   %eax
 2a2:	e8 f4 00 00 00       	call   39b <fstat>
  close(fd);
 2a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2aa:	89 c6                	mov    %eax,%esi
  close(fd);
 2ac:	e8 ba 00 00 00       	call   36b <close>
  return r;
 2b1:	83 c4 10             	add    $0x10,%esp
}
 2b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b7:	89 f0                	mov    %esi,%eax
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2c5:	eb ed                	jmp    2b4 <stat+0x34>
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax

000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d7:	0f be 02             	movsbl (%edx),%eax
 2da:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2dd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2e5:	77 1e                	ja     305 <atoi+0x35>
 2e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ee:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2f0:	83 c2 01             	add    $0x1,%edx
 2f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2fa:	0f be 02             	movsbl (%edx),%eax
 2fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 300:	80 fb 09             	cmp    $0x9,%bl
 303:	76 eb                	jbe    2f0 <atoi+0x20>
  return n;
}
 305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 308:	89 c8                	mov    %ecx,%eax
 30a:	c9                   	leave  
 30b:	c3                   	ret    
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	8b 45 10             	mov    0x10(%ebp),%eax
 317:	8b 55 08             	mov    0x8(%ebp),%edx
 31a:	56                   	push   %esi
 31b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31e:	85 c0                	test   %eax,%eax
 320:	7e 13                	jle    335 <memmove+0x25>
 322:	01 d0                	add    %edx,%eax
  dst = vdst;
 324:	89 d7                	mov    %edx,%edi
 326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 330:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 331:	39 f8                	cmp    %edi,%eax
 333:	75 fb                	jne    330 <memmove+0x20>
  return vdst;
}
 335:	5e                   	pop    %esi
 336:	89 d0                	mov    %edx,%eax
 338:	5f                   	pop    %edi
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret    

0000033b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33b:	b8 01 00 00 00       	mov    $0x1,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <exit>:
SYSCALL(exit)
 343:	b8 02 00 00 00       	mov    $0x2,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <wait>:
SYSCALL(wait)
 34b:	b8 03 00 00 00       	mov    $0x3,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <pipe>:
SYSCALL(pipe)
 353:	b8 04 00 00 00       	mov    $0x4,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <read>:
SYSCALL(read)
 35b:	b8 05 00 00 00       	mov    $0x5,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <write>:
SYSCALL(write)
 363:	b8 10 00 00 00       	mov    $0x10,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <close>:
SYSCALL(close)
 36b:	b8 15 00 00 00       	mov    $0x15,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <kill>:
SYSCALL(kill)
 373:	b8 06 00 00 00       	mov    $0x6,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <exec>:
SYSCALL(exec)
 37b:	b8 07 00 00 00       	mov    $0x7,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <open>:
SYSCALL(open)
 383:	b8 0f 00 00 00       	mov    $0xf,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <mknod>:
SYSCALL(mknod)
 38b:	b8 11 00 00 00       	mov    $0x11,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <unlink>:
SYSCALL(unlink)
 393:	b8 12 00 00 00       	mov    $0x12,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <fstat>:
SYSCALL(fstat)
 39b:	b8 08 00 00 00       	mov    $0x8,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <link>:
SYSCALL(link)
 3a3:	b8 13 00 00 00       	mov    $0x13,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <mkdir>:
SYSCALL(mkdir)
 3ab:	b8 14 00 00 00       	mov    $0x14,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <chdir>:
SYSCALL(chdir)
 3b3:	b8 09 00 00 00       	mov    $0x9,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <dup>:
SYSCALL(dup)
 3bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <getpid>:
SYSCALL(getpid)
 3c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <sbrk>:
SYSCALL(sbrk)
 3cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <sleep>:
SYSCALL(sleep)
 3d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <uptime>:
SYSCALL(uptime)
 3db:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <printhugepde>:
SYSCALL(printhugepde)
 3e3:	b8 16 00 00 00       	mov    $0x16,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <procpgdirinfo>:
SYSCALL(procpgdirinfo)
 3eb:	b8 17 00 00 00       	mov    $0x17,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <shugebrk>:
SYSCALL(shugebrk)
 3f3:	b8 18 00 00 00       	mov    $0x18,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <setthp>:
SYSCALL(setthp)
 3fb:	b8 19 00 00 00       	mov    $0x19,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <getthp>:
SYSCALL(getthp)
 403:	b8 1a 00 00 00       	mov    $0x1a,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    
 40b:	66 90                	xchg   %ax,%ax
 40d:	66 90                	xchg   %ax,%ax
 40f:	90                   	nop

00000410 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 3c             	sub    $0x3c,%esp
 419:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 41c:	89 d1                	mov    %edx,%ecx
{
 41e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 421:	85 d2                	test   %edx,%edx
 423:	0f 89 7f 00 00 00    	jns    4a8 <printint+0x98>
 429:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 42d:	74 79                	je     4a8 <printint+0x98>
    neg = 1;
 42f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 436:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 438:	31 db                	xor    %ebx,%ebx
 43a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 43d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 440:	89 c8                	mov    %ecx,%eax
 442:	31 d2                	xor    %edx,%edx
 444:	89 cf                	mov    %ecx,%edi
 446:	f7 75 c4             	divl   -0x3c(%ebp)
 449:	0f b6 92 88 0a 00 00 	movzbl 0xa88(%edx),%edx
 450:	89 45 c0             	mov    %eax,-0x40(%ebp)
 453:	89 d8                	mov    %ebx,%eax
 455:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 458:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 45b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 45e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 461:	76 dd                	jbe    440 <printint+0x30>
  if(neg)
 463:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 466:	85 c9                	test   %ecx,%ecx
 468:	74 0c                	je     476 <printint+0x66>
    buf[i++] = '-';
 46a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 46f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 471:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 476:	8b 7d b8             	mov    -0x48(%ebp),%edi
 479:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 47d:	eb 07                	jmp    486 <printint+0x76>
 47f:	90                   	nop
    putc(fd, buf[i]);
 480:	0f b6 13             	movzbl (%ebx),%edx
 483:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 486:	83 ec 04             	sub    $0x4,%esp
 489:	88 55 d7             	mov    %dl,-0x29(%ebp)
 48c:	6a 01                	push   $0x1
 48e:	56                   	push   %esi
 48f:	57                   	push   %edi
 490:	e8 ce fe ff ff       	call   363 <write>
  while(--i >= 0)
 495:	83 c4 10             	add    $0x10,%esp
 498:	39 de                	cmp    %ebx,%esi
 49a:	75 e4                	jne    480 <printint+0x70>
}
 49c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 49f:	5b                   	pop    %ebx
 4a0:	5e                   	pop    %esi
 4a1:	5f                   	pop    %edi
 4a2:	5d                   	pop    %ebp
 4a3:	c3                   	ret    
 4a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4af:	eb 87                	jmp    438 <printint+0x28>
 4b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop

000004c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
 4c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4cc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4cf:	0f b6 13             	movzbl (%ebx),%edx
 4d2:	84 d2                	test   %dl,%dl
 4d4:	74 6a                	je     540 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 4d6:	8d 45 10             	lea    0x10(%ebp),%eax
 4d9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4dc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4df:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 4e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4e4:	eb 36                	jmp    51c <printf+0x5c>
 4e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
 4f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4f3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 4f8:	83 f8 25             	cmp    $0x25,%eax
 4fb:	74 15                	je     512 <printf+0x52>
  write(fd, &c, 1);
 4fd:	83 ec 04             	sub    $0x4,%esp
 500:	88 55 e7             	mov    %dl,-0x19(%ebp)
 503:	6a 01                	push   $0x1
 505:	57                   	push   %edi
 506:	56                   	push   %esi
 507:	e8 57 fe ff ff       	call   363 <write>
 50c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 50f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 512:	0f b6 13             	movzbl (%ebx),%edx
 515:	83 c3 01             	add    $0x1,%ebx
 518:	84 d2                	test   %dl,%dl
 51a:	74 24                	je     540 <printf+0x80>
    c = fmt[i] & 0xff;
 51c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 51f:	85 c9                	test   %ecx,%ecx
 521:	74 cd                	je     4f0 <printf+0x30>
      }
    } else if(state == '%'){
 523:	83 f9 25             	cmp    $0x25,%ecx
 526:	75 ea                	jne    512 <printf+0x52>
      if(c == 'd'){
 528:	83 f8 25             	cmp    $0x25,%eax
 52b:	0f 84 07 01 00 00    	je     638 <printf+0x178>
 531:	83 e8 63             	sub    $0x63,%eax
 534:	83 f8 15             	cmp    $0x15,%eax
 537:	77 17                	ja     550 <printf+0x90>
 539:	ff 24 85 30 0a 00 00 	jmp    *0xa30(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 540:	8d 65 f4             	lea    -0xc(%ebp),%esp
 543:	5b                   	pop    %ebx
 544:	5e                   	pop    %esi
 545:	5f                   	pop    %edi
 546:	5d                   	pop    %ebp
 547:	c3                   	ret    
 548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54f:	90                   	nop
  write(fd, &c, 1);
 550:	83 ec 04             	sub    $0x4,%esp
 553:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 556:	6a 01                	push   $0x1
 558:	57                   	push   %edi
 559:	56                   	push   %esi
 55a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 55e:	e8 00 fe ff ff       	call   363 <write>
        putc(fd, c);
 563:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 567:	83 c4 0c             	add    $0xc,%esp
 56a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 56d:	6a 01                	push   $0x1
 56f:	57                   	push   %edi
 570:	56                   	push   %esi
 571:	e8 ed fd ff ff       	call   363 <write>
        putc(fd, c);
 576:	83 c4 10             	add    $0x10,%esp
      state = 0;
 579:	31 c9                	xor    %ecx,%ecx
 57b:	eb 95                	jmp    512 <printf+0x52>
 57d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 580:	83 ec 0c             	sub    $0xc,%esp
 583:	b9 10 00 00 00       	mov    $0x10,%ecx
 588:	6a 00                	push   $0x0
 58a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 58d:	8b 10                	mov    (%eax),%edx
 58f:	89 f0                	mov    %esi,%eax
 591:	e8 7a fe ff ff       	call   410 <printint>
        ap++;
 596:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 59a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 59d:	31 c9                	xor    %ecx,%ecx
 59f:	e9 6e ff ff ff       	jmp    512 <printf+0x52>
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5ab:	8b 10                	mov    (%eax),%edx
        ap++;
 5ad:	83 c0 04             	add    $0x4,%eax
 5b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5b3:	85 d2                	test   %edx,%edx
 5b5:	0f 84 8d 00 00 00    	je     648 <printf+0x188>
        while(*s != 0){
 5bb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5be:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 5c0:	84 c0                	test   %al,%al
 5c2:	0f 84 4a ff ff ff    	je     512 <printf+0x52>
 5c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5cb:	89 d3                	mov    %edx,%ebx
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5d0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5d3:	83 c3 01             	add    $0x1,%ebx
 5d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5d9:	6a 01                	push   $0x1
 5db:	57                   	push   %edi
 5dc:	56                   	push   %esi
 5dd:	e8 81 fd ff ff       	call   363 <write>
        while(*s != 0){
 5e2:	0f b6 03             	movzbl (%ebx),%eax
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	84 c0                	test   %al,%al
 5ea:	75 e4                	jne    5d0 <printf+0x110>
      state = 0;
 5ec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5ef:	31 c9                	xor    %ecx,%ecx
 5f1:	e9 1c ff ff ff       	jmp    512 <printf+0x52>
 5f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
 608:	6a 01                	push   $0x1
 60a:	e9 7b ff ff ff       	jmp    58a <printf+0xca>
 60f:	90                   	nop
        putc(fd, *ap);
 610:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 613:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 616:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 618:	6a 01                	push   $0x1
 61a:	57                   	push   %edi
 61b:	56                   	push   %esi
        putc(fd, *ap);
 61c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 61f:	e8 3f fd ff ff       	call   363 <write>
        ap++;
 624:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 628:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62b:	31 c9                	xor    %ecx,%ecx
 62d:	e9 e0 fe ff ff       	jmp    512 <printf+0x52>
 632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 638:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 63b:	83 ec 04             	sub    $0x4,%esp
 63e:	e9 2a ff ff ff       	jmp    56d <printf+0xad>
 643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 647:	90                   	nop
          s = "(null)";
 648:	ba 28 0a 00 00       	mov    $0xa28,%edx
        while(*s != 0){
 64d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 650:	b8 28 00 00 00       	mov    $0x28,%eax
 655:	89 d3                	mov    %edx,%ebx
 657:	e9 74 ff ff ff       	jmp    5d0 <printf+0x110>
 65c:	66 90                	xchg   %ax,%ax
 65e:	66 90                	xchg   %ax,%ax

00000660 <vfree>:

// TODO: implement this
// part 2
void
vfree(void *ap)
{
 660:	55                   	push   %ebp
  if(flag == VMALLOC_SIZE_BASE)
  {
    // free regular pages
    Header *bp, *p;
    bp = (Header*)ap - 1;
    for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr){
 661:	a1 ac 0d 00 00       	mov    0xdac,%eax
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = (Header*)ap - 1;
 66e:	8d 53 f8             	lea    -0x8(%ebx),%edx
  if (((uint) ap) >= ((uint) HUGE_PAGE_START)) {
 671:	81 fb ff ff ff 1d    	cmp    $0x1dffffff,%ebx
 677:	76 4f                	jbe    6c8 <vfree+0x68>
  {
    // free huge pages
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for(p = hugefreep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 679:	a1 a0 0d 00 00       	mov    0xda0,%eax
 67e:	66 90                	xchg   %ax,%ax
 680:	89 c1                	mov    %eax,%ecx
 682:	8b 00                	mov    (%eax),%eax
 684:	39 d1                	cmp    %edx,%ecx
 686:	73 78                	jae    700 <vfree+0xa0>
 688:	39 d0                	cmp    %edx,%eax
 68a:	77 04                	ja     690 <vfree+0x30>
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68c:	39 c1                	cmp    %eax,%ecx
 68e:	72 f0                	jb     680 <vfree+0x20>
        break;
    if(bp + bp->s.size == p->s.ptr){
 690:	8b 73 fc             	mov    -0x4(%ebx),%esi
 693:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 696:	39 f8                	cmp    %edi,%eax
 698:	0f 84 c2 00 00 00    	je     760 <vfree+0x100>
      bp->s.size += p->s.ptr->s.size;
      bp->s.ptr = p->s.ptr->s.ptr;
 69e:	89 43 f8             	mov    %eax,-0x8(%ebx)
    } else
      bp->s.ptr = p->s.ptr;
    if(p + p->s.size == bp){
 6a1:	8b 41 04             	mov    0x4(%ecx),%eax
 6a4:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 6a7:	39 f2                	cmp    %esi,%edx
 6a9:	74 75                	je     720 <vfree+0xc0>
      p->s.size += bp->s.size;
      p->s.ptr = bp->s.ptr;
 6ab:	89 11                	mov    %edx,(%ecx)
    } else
      p->s.ptr = bp;
    hugefreep = p;
 6ad:	89 0d a0 0d 00 00    	mov    %ecx,0xda0
  }
}
 6b3:	5b                   	pop    %ebx
 6b4:	5e                   	pop    %esi
 6b5:	5f                   	pop    %edi
 6b6:	5d                   	pop    %ebp
 6b7:	c3                   	ret    
 6b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c0:	39 c1                	cmp    %eax,%ecx
 6c2:	72 04                	jb     6c8 <vfree+0x68>
 6c4:	39 d0                	cmp    %edx,%eax
 6c6:	77 10                	ja     6d8 <vfree+0x78>
    for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr){
 6c8:	89 c1                	mov    %eax,%ecx
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	39 d1                	cmp    %edx,%ecx
 6ce:	73 f0                	jae    6c0 <vfree+0x60>
 6d0:	39 d0                	cmp    %edx,%eax
 6d2:	77 04                	ja     6d8 <vfree+0x78>
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d4:	39 c1                	cmp    %eax,%ecx
 6d6:	72 f0                	jb     6c8 <vfree+0x68>
    if(bp + bp->s.size == p->s.ptr){
 6d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6db:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 6de:	39 f8                	cmp    %edi,%eax
 6e0:	74 56                	je     738 <vfree+0xd8>
      bp->s.ptr = p->s.ptr->s.ptr;
 6e2:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 6e5:	8b 41 04             	mov    0x4(%ecx),%eax
 6e8:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 6eb:	39 f2                	cmp    %esi,%edx
 6ed:	74 60                	je     74f <vfree+0xef>
      p->s.ptr = bp->s.ptr;
 6ef:	89 11                	mov    %edx,(%ecx)
}
 6f1:	5b                   	pop    %ebx
    freep = p;
 6f2:	89 0d ac 0d 00 00    	mov    %ecx,0xdac
}
 6f8:	5e                   	pop    %esi
 6f9:	5f                   	pop    %edi
 6fa:	5d                   	pop    %ebp
 6fb:	c3                   	ret    
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 700:	39 c1                	cmp    %eax,%ecx
 702:	0f 82 78 ff ff ff    	jb     680 <vfree+0x20>
 708:	39 d0                	cmp    %edx,%eax
 70a:	0f 86 70 ff ff ff    	jbe    680 <vfree+0x20>
    if(bp + bp->s.size == p->s.ptr){
 710:	8b 73 fc             	mov    -0x4(%ebx),%esi
 713:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 716:	39 f8                	cmp    %edi,%eax
 718:	75 84                	jne    69e <vfree+0x3e>
 71a:	eb 44                	jmp    760 <vfree+0x100>
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p->s.size += bp->s.size;
 720:	03 43 fc             	add    -0x4(%ebx),%eax
    hugefreep = p;
 723:	89 0d a0 0d 00 00    	mov    %ecx,0xda0
      p->s.size += bp->s.size;
 729:	89 41 04             	mov    %eax,0x4(%ecx)
      p->s.ptr = bp->s.ptr;
 72c:	8b 53 f8             	mov    -0x8(%ebx),%edx
 72f:	89 11                	mov    %edx,(%ecx)
    hugefreep = p;
 731:	eb 80                	jmp    6b3 <vfree+0x53>
 733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 737:	90                   	nop
      bp->s.size += p->s.ptr->s.size;
 738:	03 70 04             	add    0x4(%eax),%esi
 73b:	89 73 fc             	mov    %esi,-0x4(%ebx)
      bp->s.ptr = p->s.ptr->s.ptr;
 73e:	8b 01                	mov    (%ecx),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 745:	8b 41 04             	mov    0x4(%ecx),%eax
 748:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 74b:	39 f2                	cmp    %esi,%edx
 74d:	75 a0                	jne    6ef <vfree+0x8f>
      p->s.size += bp->s.size;
 74f:	03 43 fc             	add    -0x4(%ebx),%eax
 752:	89 41 04             	mov    %eax,0x4(%ecx)
      p->s.ptr = bp->s.ptr;
 755:	8b 53 f8             	mov    -0x8(%ebx),%edx
 758:	eb 95                	jmp    6ef <vfree+0x8f>
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      bp->s.size += p->s.ptr->s.size;
 760:	03 70 04             	add    0x4(%eax),%esi
 763:	89 73 fc             	mov    %esi,-0x4(%ebx)
      bp->s.ptr = p->s.ptr->s.ptr;
 766:	8b 01                	mov    (%ecx),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 76d:	8b 41 04             	mov    0x4(%ecx),%eax
 770:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 773:	39 f2                	cmp    %esi,%edx
 775:	0f 85 30 ff ff ff    	jne    6ab <vfree+0x4b>
 77b:	eb a3                	jmp    720 <vfree+0xc0>
 77d:	8d 76 00             	lea    0x0(%esi),%esi

00000780 <free>:
 vfree(ap);
 780:	e9 db fe ff ff       	jmp    660 <vfree>
 785:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000790 <vmalloc>:
// TODO: implement this
// part 2

void*
vmalloc(uint nbytes, uint flag)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	83 ec 1c             	sub    $0x1c,%esp
  if(flag == VMALLOC_SIZE_BASE)
 799:	8b 45 0c             	mov    0xc(%ebp),%eax
{
 79c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(flag == VMALLOC_SIZE_BASE)
 79f:	85 c0                	test   %eax,%eax
 7a1:	0f 84 f9 00 00 00    	je     8a0 <vmalloc+0x110>
  {
    // alloc huge pages
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a7:	83 c6 07             	add    $0x7,%esi
    if((prevp = hugefreep) == 0){
 7aa:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b0:	c1 ee 03             	shr    $0x3,%esi
 7b3:	83 c6 01             	add    $0x1,%esi
    if((prevp = hugefreep) == 0){
 7b6:	85 ff                	test   %edi,%edi
 7b8:	0f 84 b2 00 00 00    	je     870 <vmalloc+0xe0>
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
      hugebase.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	8b 17                	mov    (%edi),%edx
      if(p->s.size >= nunits){
 7c0:	8b 4a 04             	mov    0x4(%edx),%ecx
 7c3:	39 f1                	cmp    %esi,%ecx
 7c5:	73 67                	jae    82e <vmalloc+0x9e>
 7c7:	bb 00 00 08 00       	mov    $0x80000,%ebx
 7cc:	39 de                	cmp    %ebx,%esi
 7ce:	0f 43 de             	cmovae %esi,%ebx
  p = shugebrk(nu * sizeof(Header));
 7d1:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7db:	eb 14                	jmp    7f1 <vmalloc+0x61>
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	8b 02                	mov    (%edx),%eax
      if(p->s.size >= nunits){
 7e2:	8b 48 04             	mov    0x4(%eax),%ecx
 7e5:	39 f1                	cmp    %esi,%ecx
 7e7:	73 4f                	jae    838 <vmalloc+0xa8>
          p->s.size = nunits;
        }
        hugefreep = prevp;
        return (void*)(p + 1);
      }
      if(p == hugefreep)
 7e9:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
 7ef:	89 c2                	mov    %eax,%edx
 7f1:	39 d7                	cmp    %edx,%edi
 7f3:	75 eb                	jne    7e0 <vmalloc+0x50>
  p = shugebrk(nu * sizeof(Header));
 7f5:	83 ec 0c             	sub    $0xc,%esp
 7f8:	ff 75 e4             	push   -0x1c(%ebp)
 7fb:	e8 f3 fb ff ff       	call   3f3 <shugebrk>
  if(p == (char*)-1)
 800:	83 c4 10             	add    $0x10,%esp
 803:	83 f8 ff             	cmp    $0xffffffff,%eax
 806:	74 1c                	je     824 <vmalloc+0x94>
  hp->s.size = nu;
 808:	89 58 04             	mov    %ebx,0x4(%eax)
  vfree((void*)(hp + 1));
 80b:	83 ec 0c             	sub    $0xc,%esp
 80e:	83 c0 08             	add    $0x8,%eax
 811:	50                   	push   %eax
 812:	e8 49 fe ff ff       	call   660 <vfree>
  return hugefreep;
 817:	8b 15 a0 0d 00 00    	mov    0xda0,%edx
        if((p = morehugecore(nunits)) == 0)
 81d:	83 c4 10             	add    $0x10,%esp
 820:	85 d2                	test   %edx,%edx
 822:	75 bc                	jne    7e0 <vmalloc+0x50>
          return 0;
    }
  }
 824:	8d 65 f4             	lea    -0xc(%ebp),%esp
          return 0;
 827:	31 c0                	xor    %eax,%eax
 829:	5b                   	pop    %ebx
 82a:	5e                   	pop    %esi
 82b:	5f                   	pop    %edi
 82c:	5d                   	pop    %ebp
 82d:	c3                   	ret    
      if(p->s.size >= nunits){
 82e:	89 d0                	mov    %edx,%eax
 830:	89 fa                	mov    %edi,%edx
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(p->s.size == nunits)
 838:	39 ce                	cmp    %ecx,%esi
 83a:	74 24                	je     860 <vmalloc+0xd0>
          p->s.size -= nunits;
 83c:	29 f1                	sub    %esi,%ecx
 83e:	89 48 04             	mov    %ecx,0x4(%eax)
          p += p->s.size;
 841:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
          p->s.size = nunits;
 844:	89 70 04             	mov    %esi,0x4(%eax)
        hugefreep = prevp;
 847:	89 15 a0 0d 00 00    	mov    %edx,0xda0
 84d:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return (void*)(p + 1);
 850:	83 c0 08             	add    $0x8,%eax
 853:	5b                   	pop    %ebx
 854:	5e                   	pop    %esi
 855:	5f                   	pop    %edi
 856:	5d                   	pop    %ebp
 857:	c3                   	ret    
 858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85f:	90                   	nop
          prevp->s.ptr = p->s.ptr;
 860:	8b 08                	mov    (%eax),%ecx
 862:	89 0a                	mov    %ecx,(%edx)
 864:	eb e1                	jmp    847 <vmalloc+0xb7>
 866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 86d:	8d 76 00             	lea    0x0(%esi),%esi
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
 870:	c7 05 a0 0d 00 00 a4 	movl   $0xda4,0xda0
 877:	0d 00 00 
      hugebase.s.size = 0;
 87a:	bf a4 0d 00 00       	mov    $0xda4,%edi
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
 87f:	c7 05 a4 0d 00 00 a4 	movl   $0xda4,0xda4
 886:	0d 00 00 
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 889:	89 fa                	mov    %edi,%edx
      hugebase.s.size = 0;
 88b:	c7 05 a8 0d 00 00 00 	movl   $0x0,0xda8
 892:	00 00 00 
      if(p->s.size >= nunits){
 895:	e9 2d ff ff ff       	jmp    7c7 <vmalloc+0x37>
 89a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8a3:	5b                   	pop    %ebx
 8a4:	5e                   	pop    %esi
 8a5:	5f                   	pop    %edi
 8a6:	5d                   	pop    %ebp
    return malloc(nbytes);
 8a7:	eb 07                	jmp    8b0 <malloc>
 8a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008b0 <malloc>:
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	57                   	push   %edi
 8b4:	56                   	push   %esi
 8b5:	53                   	push   %ebx
 8b6:	83 ec 1c             	sub    $0x1c,%esp
 8b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(nbytes > 1000000 && (getthp() != 0)){
 8bc:	81 fe 40 42 0f 00    	cmp    $0xf4240,%esi
 8c2:	0f 87 b8 00 00 00    	ja     980 <malloc+0xd0>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c8:	83 c6 07             	add    $0x7,%esi
  if((prevp = freep) == 0){
 8cb:	8b 3d ac 0d 00 00    	mov    0xdac,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d1:	c1 ee 03             	shr    $0x3,%esi
 8d4:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8d7:	85 ff                	test   %edi,%edi
 8d9:	0f 84 c1 00 00 00    	je     9a0 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8df:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 8e1:	8b 4a 04             	mov    0x4(%edx),%ecx
 8e4:	39 f1                	cmp    %esi,%ecx
 8e6:	73 66                	jae    94e <malloc+0x9e>
 8e8:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8ed:	39 de                	cmp    %ebx,%esi
 8ef:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8f2:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8fc:	eb 13                	jmp    911 <malloc+0x61>
 8fe:	66 90                	xchg   %ax,%ax
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 900:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 902:	8b 48 04             	mov    0x4(%eax),%ecx
 905:	39 f1                	cmp    %esi,%ecx
 907:	73 4f                	jae    958 <malloc+0xa8>
    if(p == freep)
 909:	8b 3d ac 0d 00 00    	mov    0xdac,%edi
 90f:	89 c2                	mov    %eax,%edx
 911:	39 d7                	cmp    %edx,%edi
 913:	75 eb                	jne    900 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 915:	83 ec 0c             	sub    $0xc,%esp
 918:	ff 75 e4             	push   -0x1c(%ebp)
 91b:	e8 ab fa ff ff       	call   3cb <sbrk>
  if(p == (char*)-1)
 920:	83 c4 10             	add    $0x10,%esp
 923:	83 f8 ff             	cmp    $0xffffffff,%eax
 926:	74 1c                	je     944 <malloc+0x94>
  hp->s.size = nu;
 928:	89 58 04             	mov    %ebx,0x4(%eax)
  vfree((void*)(hp + 1));
 92b:	83 ec 0c             	sub    $0xc,%esp
 92e:	83 c0 08             	add    $0x8,%eax
 931:	50                   	push   %eax
 932:	e8 29 fd ff ff       	call   660 <vfree>
  return freep;
 937:	8b 15 ac 0d 00 00    	mov    0xdac,%edx
      if((p = morecore(nunits)) == 0)
 93d:	83 c4 10             	add    $0x10,%esp
 940:	85 d2                	test   %edx,%edx
 942:	75 bc                	jne    900 <malloc+0x50>
}
 944:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 947:	31 c0                	xor    %eax,%eax
}
 949:	5b                   	pop    %ebx
 94a:	5e                   	pop    %esi
 94b:	5f                   	pop    %edi
 94c:	5d                   	pop    %ebp
 94d:	c3                   	ret    
    if(p->s.size >= nunits){
 94e:	89 d0                	mov    %edx,%eax
 950:	89 fa                	mov    %edi,%edx
 952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 958:	39 ce                	cmp    %ecx,%esi
 95a:	74 74                	je     9d0 <malloc+0x120>
        p->s.size -= nunits;
 95c:	29 f1                	sub    %esi,%ecx
 95e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 961:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 964:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 967:	89 15 ac 0d 00 00    	mov    %edx,0xdac
      return (void*)(p + 1);
 96d:	83 c0 08             	add    $0x8,%eax
}
 970:	8d 65 f4             	lea    -0xc(%ebp),%esp
 973:	5b                   	pop    %ebx
 974:	5e                   	pop    %esi
 975:	5f                   	pop    %edi
 976:	5d                   	pop    %ebp
 977:	c3                   	ret    
 978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 97f:	90                   	nop
  if(nbytes > 1000000 && (getthp() != 0)){
 980:	e8 7e fa ff ff       	call   403 <getthp>
 985:	85 c0                	test   %eax,%eax
 987:	0f 84 3b ff ff ff    	je     8c8 <malloc+0x18>
    vmalloc(nbytes, VMALLOC_SIZE_HUGE);
 98d:	83 ec 08             	sub    $0x8,%esp
 990:	6a 01                	push   $0x1
 992:	56                   	push   %esi
 993:	e8 f8 fd ff ff       	call   790 <vmalloc>
    return 0;
 998:	83 c4 10             	add    $0x10,%esp
 99b:	31 c0                	xor    %eax,%eax
 99d:	eb d1                	jmp    970 <malloc+0xc0>
 99f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 9a0:	c7 05 ac 0d 00 00 b0 	movl   $0xdb0,0xdac
 9a7:	0d 00 00 
    base.s.size = 0;
 9aa:	bf b0 0d 00 00       	mov    $0xdb0,%edi
    base.s.ptr = freep = prevp = &base;
 9af:	c7 05 b0 0d 00 00 b0 	movl   $0xdb0,0xdb0
 9b6:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 9bb:	c7 05 b4 0d 00 00 00 	movl   $0x0,0xdb4
 9c2:	00 00 00 
    if(p->s.size >= nunits){
 9c5:	e9 1e ff ff ff       	jmp    8e8 <malloc+0x38>
 9ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9d0:	8b 08                	mov    (%eax),%ecx
 9d2:	89 0a                	mov    %ecx,(%edx)
 9d4:	eb 91                	jmp    967 <malloc+0xb7>
