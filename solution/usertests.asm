
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main() {
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
int main() {
  12:	83 ec 1c             	sub    $0x1c,%esp
  if(procpgdirinfo(original_page_cnt) == -1) {
  15:	50                   	push   %eax
  16:	e8 50 05 00 00       	call   56b <procpgdirinfo>
  1b:	83 c4 10             	add    $0x10,%esp
  1e:	83 f8 ff             	cmp    $0xffffffff,%eax
  21:	0f 84 fa 01 00 00    	je     221 <main+0x221>
    printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
  }
  printf(1, "Start of program - base pages:%d huge pages:%d\n", original_page_cnt[0], original_page_cnt[1]);
  27:	ff 75 ec             	push   -0x14(%ebp)
  char * a, *b;
  // 100000 bytes in base page heap
  a = (char *)malloc(1048576);
  memset(a, 0, 1048576);
  if(procpgdirinfo(page_cnt) == -1) {
  2a:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  printf(1, "Start of program - base pages:%d huge pages:%d\n", original_page_cnt[0], original_page_cnt[1]);
  2d:	ff 75 e8             	push   -0x18(%ebp)
  30:	68 9c 0b 00 00       	push   $0xb9c
  35:	6a 01                	push   $0x1
  37:	e8 04 06 00 00       	call   640 <printf>
  a = (char *)malloc(1048576);
  3c:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
  43:	e8 e8 09 00 00       	call   a30 <malloc>
  memset(a, 0, 1048576);
  48:	83 c4 0c             	add    $0xc,%esp
  4b:	68 00 00 10 00       	push   $0x100000
  50:	6a 00                	push   $0x0
  52:	50                   	push   %eax
  53:	e8 d8 02 00 00       	call   330 <memset>
  if(procpgdirinfo(page_cnt) == -1) {
  58:	89 1c 24             	mov    %ebx,(%esp)
  5b:	e8 0b 05 00 00       	call   56b <procpgdirinfo>
  60:	83 c4 10             	add    $0x10,%esp
  63:	83 f8 ff             	cmp    $0xffffffff,%eax
  66:	0f 84 9f 01 00 00    	je     20b <main+0x20b>
    printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
  }
  printf(1, "XV6_TEST_OUTPUT After malloc with THP disabled, 1 MB - program base pages:%d huge pages:%d\n", page_cnt[0] - original_page_cnt[0], page_cnt[1] - original_page_cnt[1]);
  6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  72:	50                   	push   %eax
  73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  76:	2b 45 e8             	sub    -0x18(%ebp),%eax
  79:	50                   	push   %eax
  7a:	68 cc 0b 00 00       	push   $0xbcc
  7f:	6a 01                	push   $0x1
  81:	e8 ba 05 00 00       	call   640 <printf>
  printf(1, "XV6_TEST_OUTPUT Now enabling THP\n");
  86:	58                   	pop    %eax
  87:	5a                   	pop    %edx
  88:	68 28 0c 00 00       	push   $0xc28
  8d:	6a 01                	push   $0x1
  8f:	e8 ac 05 00 00       	call   640 <printf>
  if(setthp(1) == -1) {
  94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9b:	e8 db 04 00 00       	call   57b <setthp>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	83 f8 ff             	cmp    $0xffffffff,%eax
  a6:	0f 84 49 01 00 00    	je     1f5 <main+0x1f5>
    printf(1,"XV6_TEST_ERROR Error, setthp returned -1\n");
  }
  // 2 MB in huge page heap
  b = (char *)malloc(2097152);
  ac:	83 ec 0c             	sub    $0xc,%esp
  af:	68 00 00 20 00       	push   $0x200000
  b4:	e8 77 09 00 00       	call   a30 <malloc>
  memset(b, 0, 2097152);
  b9:	83 c4 0c             	add    $0xc,%esp
  bc:	68 00 00 20 00       	push   $0x200000
  c1:	6a 00                	push   $0x0
  c3:	50                   	push   %eax
  c4:	e8 67 02 00 00       	call   330 <memset>
  if(procpgdirinfo(page_cnt) == -1) {
  c9:	89 1c 24             	mov    %ebx,(%esp)
  cc:	e8 9a 04 00 00       	call   56b <procpgdirinfo>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	83 f8 ff             	cmp    $0xffffffff,%eax
  d7:	0f 84 02 01 00 00    	je     1df <main+0x1df>
    printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
  }
  printf(1, "XV6_TEST_OUTPUT After malloc with THP, 2MB - program base pages:%d huge pages:%d\n", page_cnt[0] - original_page_cnt[0], page_cnt[1] - original_page_cnt[1]);
  dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  e3:	50                   	push   %eax
  e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  ea:	50                   	push   %eax
  eb:	68 78 0c 00 00       	push   $0xc78
  f0:	6a 01                	push   $0x1
  f2:	e8 49 05 00 00       	call   640 <printf>
  printf(1, "Now testing THP\n");
  f7:	58                   	pop    %eax
  f8:	5a                   	pop    %edx
  f9:	68 64 0d 00 00       	push   $0xd64
  fe:	6a 01                	push   $0x1
 100:	e8 3b 05 00 00       	call   640 <printf>
  if(setthp(0) == -1) {
 105:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 10c:	e8 6a 04 00 00       	call   57b <setthp>
 111:	83 c4 10             	add    $0x10,%esp
 114:	83 f8 ff             	cmp    $0xffffffff,%eax
 117:	0f 84 ac 00 00 00    	je     1c9 <main+0x1c9>
    printf(1,"XV6_TEST_ERROR Error, setthp returned -1\n");
  }

  // Test fork
  int pid = fork();
 11d:	e8 99 03 00 00       	call   4bb <fork>
  if(pid < 0) {
 122:	85 c0                	test   %eax,%eax
 124:	0f 88 8c 00 00 00    	js     1b6 <main+0x1b6>
      printf(2, "Fork failed\n");
      exit();
  }
  if(pid == 0) {
 12a:	74 49                	je     175 <main+0x175>
      if(procpgdirinfo(page_cnt) == -1) {
          printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
      }
      printf(1, "XV6_TEST_OUTPUT Child program base pages:%d huge pages:%d\n", page_cnt[0] - original_page_cnt[0], page_cnt[1] - original_page_cnt[1]);
  } else {
      wait();
 12c:	e8 9a 03 00 00       	call   4cb <wait>
      printf(1, "XV6_TEST_OUTPUT Parent stats:\n");
 131:	52                   	push   %edx
 132:	52                   	push   %edx
 133:	68 08 0d 00 00       	push   $0xd08
 138:	6a 01                	push   $0x1
 13a:	e8 01 05 00 00       	call   640 <printf>
      if(procpgdirinfo(page_cnt) == -1) {
 13f:	89 1c 24             	mov    %ebx,(%esp)
 142:	e8 24 04 00 00       	call   56b <procpgdirinfo>
 147:	83 c4 10             	add    $0x10,%esp
 14a:	83 c0 01             	add    $0x1,%eax
 14d:	0f 84 e4 00 00 00    	je     237 <main+0x237>
          printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
      }
      printf(1, "XV6_TEST_OUTPUT Parent program base pages:%d huge pages:%d\n", page_cnt[0] - original_page_cnt[0], page_cnt[1] - original_page_cnt[1]);
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	2b 45 ec             	sub    -0x14(%ebp),%eax
 159:	50                   	push   %eax
 15a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 15d:	2b 45 e8             	sub    -0x18(%ebp),%eax
 160:	50                   	push   %eax
 161:	68 28 0d 00 00       	push   $0xd28
 166:	6a 01                	push   $0x1
 168:	e8 d3 04 00 00       	call   640 <printf>
 16d:	83 c4 10             	add    $0x10,%esp
  }
  exit();
 170:	e8 4e 03 00 00       	call   4c3 <exit>
      printf(1, "XV6_TEST_OUTPUT Child stats:\n");
 175:	50                   	push   %eax
 176:	50                   	push   %eax
 177:	68 82 0d 00 00       	push   $0xd82
 17c:	6a 01                	push   $0x1
 17e:	e8 bd 04 00 00       	call   640 <printf>
      if(procpgdirinfo(page_cnt) == -1) {
 183:	89 1c 24             	mov    %ebx,(%esp)
 186:	e8 e0 03 00 00       	call   56b <procpgdirinfo>
 18b:	83 c4 10             	add    $0x10,%esp
 18e:	83 c0 01             	add    $0x1,%eax
 191:	0f 84 b6 00 00 00    	je     24d <main+0x24d>
      printf(1, "XV6_TEST_OUTPUT Child program base pages:%d huge pages:%d\n", page_cnt[0] - original_page_cnt[0], page_cnt[1] - original_page_cnt[1]);
 197:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 19d:	50                   	push   %eax
 19e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1a1:	2b 45 e8             	sub    -0x18(%ebp),%eax
 1a4:	50                   	push   %eax
 1a5:	68 cc 0c 00 00       	push   $0xccc
 1aa:	6a 01                	push   $0x1
 1ac:	e8 8f 04 00 00       	call   640 <printf>
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	eb ba                	jmp    170 <main+0x170>
      printf(2, "Fork failed\n");
 1b6:	50                   	push   %eax
 1b7:	50                   	push   %eax
 1b8:	68 75 0d 00 00       	push   $0xd75
 1bd:	6a 02                	push   $0x2
 1bf:	e8 7c 04 00 00       	call   640 <printf>
      exit();
 1c4:	e8 fa 02 00 00       	call   4c3 <exit>
    printf(1,"XV6_TEST_ERROR Error, setthp returned -1\n");
 1c9:	50                   	push   %eax
 1ca:	50                   	push   %eax
 1cb:	68 4c 0c 00 00       	push   $0xc4c
 1d0:	6a 01                	push   $0x1
 1d2:	e8 69 04 00 00       	call   640 <printf>
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	e9 3e ff ff ff       	jmp    11d <main+0x11d>
    printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
 1df:	51                   	push   %ecx
 1e0:	51                   	push   %ecx
 1e1:	68 68 0b 00 00       	push   $0xb68
 1e6:	6a 01                	push   $0x1
 1e8:	e8 53 04 00 00       	call   640 <printf>
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	e9 e8 fe ff ff       	jmp    dd <main+0xdd>
    printf(1,"XV6_TEST_ERROR Error, setthp returned -1\n");
 1f5:	50                   	push   %eax
 1f6:	50                   	push   %eax
 1f7:	68 4c 0c 00 00       	push   $0xc4c
 1fc:	6a 01                	push   $0x1
 1fe:	e8 3d 04 00 00       	call   640 <printf>
 203:	83 c4 10             	add    $0x10,%esp
 206:	e9 a1 fe ff ff       	jmp    ac <main+0xac>
    printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
 20b:	51                   	push   %ecx
 20c:	51                   	push   %ecx
 20d:	68 68 0b 00 00       	push   $0xb68
 212:	6a 01                	push   $0x1
 214:	e8 27 04 00 00       	call   640 <printf>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	e9 4b fe ff ff       	jmp    6c <main+0x6c>
    printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
 221:	53                   	push   %ebx
 222:	53                   	push   %ebx
 223:	68 68 0b 00 00       	push   $0xb68
 228:	6a 01                	push   $0x1
 22a:	e8 11 04 00 00       	call   640 <printf>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	e9 f0 fd ff ff       	jmp    27 <main+0x27>
          printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
 237:	50                   	push   %eax
 238:	50                   	push   %eax
 239:	68 68 0b 00 00       	push   $0xb68
 23e:	6a 01                	push   $0x1
 240:	e8 fb 03 00 00       	call   640 <printf>
 245:	83 c4 10             	add    $0x10,%esp
 248:	e9 06 ff ff ff       	jmp    153 <main+0x153>
          printf(1,"XV6_TEST_ERROR Error, procpgdirinfo returned -1\n");
 24d:	51                   	push   %ecx
 24e:	51                   	push   %ecx
 24f:	68 68 0b 00 00       	push   $0xb68
 254:	6a 01                	push   $0x1
 256:	e8 e5 03 00 00       	call   640 <printf>
 25b:	83 c4 10             	add    $0x10,%esp
 25e:	e9 34 ff ff ff       	jmp    197 <main+0x197>
 263:	66 90                	xchg   %ax,%ax
 265:	66 90                	xchg   %ax,%ax
 267:	66 90                	xchg   %ax,%ax
 269:	66 90                	xchg   %ax,%ax
 26b:	66 90                	xchg   %ax,%ax
 26d:	66 90                	xchg   %ax,%ax
 26f:	90                   	nop

00000270 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 270:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 271:	31 c0                	xor    %eax,%eax
{
 273:	89 e5                	mov    %esp,%ebp
 275:	53                   	push   %ebx
 276:	8b 4d 08             	mov    0x8(%ebp),%ecx
 279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 280:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 284:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 287:	83 c0 01             	add    $0x1,%eax
 28a:	84 d2                	test   %dl,%dl
 28c:	75 f2                	jne    280 <strcpy+0x10>
    ;
  return os;
}
 28e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 291:	89 c8                	mov    %ecx,%eax
 293:	c9                   	leave  
 294:	c3                   	ret    
 295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2aa:	0f b6 02             	movzbl (%edx),%eax
 2ad:	84 c0                	test   %al,%al
 2af:	75 17                	jne    2c8 <strcmp+0x28>
 2b1:	eb 3a                	jmp    2ed <strcmp+0x4d>
 2b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b7:	90                   	nop
 2b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2bc:	83 c2 01             	add    $0x1,%edx
 2bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2c2:	84 c0                	test   %al,%al
 2c4:	74 1a                	je     2e0 <strcmp+0x40>
    p++, q++;
 2c6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 2c8:	0f b6 19             	movzbl (%ecx),%ebx
 2cb:	38 c3                	cmp    %al,%bl
 2cd:	74 e9                	je     2b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2cf:	29 d8                	sub    %ebx,%eax
}
 2d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2d4:	c9                   	leave  
 2d5:	c3                   	ret    
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 2e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2e4:	31 c0                	xor    %eax,%eax
 2e6:	29 d8                	sub    %ebx,%eax
}
 2e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 2ed:	0f b6 19             	movzbl (%ecx),%ebx
 2f0:	31 c0                	xor    %eax,%eax
 2f2:	eb db                	jmp    2cf <strcmp+0x2f>
 2f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <strlen>:

uint
strlen(const char *s)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 306:	80 3a 00             	cmpb   $0x0,(%edx)
 309:	74 15                	je     320 <strlen+0x20>
 30b:	31 c0                	xor    %eax,%eax
 30d:	8d 76 00             	lea    0x0(%esi),%esi
 310:	83 c0 01             	add    $0x1,%eax
 313:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 317:	89 c1                	mov    %eax,%ecx
 319:	75 f5                	jne    310 <strlen+0x10>
    ;
  return n;
}
 31b:	89 c8                	mov    %ecx,%eax
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    
 31f:	90                   	nop
  for(n = 0; s[n]; n++)
 320:	31 c9                	xor    %ecx,%ecx
}
 322:	5d                   	pop    %ebp
 323:	89 c8                	mov    %ecx,%eax
 325:	c3                   	ret    
 326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32d:	8d 76 00             	lea    0x0(%esi),%esi

00000330 <memset>:

void*
memset(void *dst, int c, uint n)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 337:	8b 4d 10             	mov    0x10(%ebp),%ecx
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 d7                	mov    %edx,%edi
 33f:	fc                   	cld    
 340:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 342:	8b 7d fc             	mov    -0x4(%ebp),%edi
 345:	89 d0                	mov    %edx,%eax
 347:	c9                   	leave  
 348:	c3                   	ret    
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000350 <strchr>:

char*
strchr(const char *s, char c)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 35a:	0f b6 10             	movzbl (%eax),%edx
 35d:	84 d2                	test   %dl,%dl
 35f:	75 12                	jne    373 <strchr+0x23>
 361:	eb 1d                	jmp    380 <strchr+0x30>
 363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 367:	90                   	nop
 368:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 36c:	83 c0 01             	add    $0x1,%eax
 36f:	84 d2                	test   %dl,%dl
 371:	74 0d                	je     380 <strchr+0x30>
    if(*s == c)
 373:	38 d1                	cmp    %dl,%cl
 375:	75 f1                	jne    368 <strchr+0x18>
      return (char*)s;
  return 0;
}
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 380:	31 c0                	xor    %eax,%eax
}
 382:	5d                   	pop    %ebp
 383:	c3                   	ret    
 384:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 38f:	90                   	nop

00000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 395:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 398:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 399:	31 db                	xor    %ebx,%ebx
{
 39b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 39e:	eb 27                	jmp    3c7 <gets+0x37>
    cc = read(0, &c, 1);
 3a0:	83 ec 04             	sub    $0x4,%esp
 3a3:	6a 01                	push   $0x1
 3a5:	57                   	push   %edi
 3a6:	6a 00                	push   $0x0
 3a8:	e8 2e 01 00 00       	call   4db <read>
    if(cc < 1)
 3ad:	83 c4 10             	add    $0x10,%esp
 3b0:	85 c0                	test   %eax,%eax
 3b2:	7e 1d                	jle    3d1 <gets+0x41>
      break;
    buf[i++] = c;
 3b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b8:	8b 55 08             	mov    0x8(%ebp),%edx
 3bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3bf:	3c 0a                	cmp    $0xa,%al
 3c1:	74 1d                	je     3e0 <gets+0x50>
 3c3:	3c 0d                	cmp    $0xd,%al
 3c5:	74 19                	je     3e0 <gets+0x50>
  for(i=0; i+1 < max; ){
 3c7:	89 de                	mov    %ebx,%esi
 3c9:	83 c3 01             	add    $0x1,%ebx
 3cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3cf:	7c cf                	jl     3a0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3db:	5b                   	pop    %ebx
 3dc:	5e                   	pop    %esi
 3dd:	5f                   	pop    %edi
 3de:	5d                   	pop    %ebp
 3df:	c3                   	ret    
  buf[i] = '\0';
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	89 de                	mov    %ebx,%esi
 3e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 3e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ec:	5b                   	pop    %ebx
 3ed:	5e                   	pop    %esi
 3ee:	5f                   	pop    %edi
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	push   0x8(%ebp)
 40d:	e8 f1 00 00 00       	call   503 <open>
  if(fd < 0)
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 419:	83 ec 08             	sub    $0x8,%esp
 41c:	ff 75 0c             	push   0xc(%ebp)
 41f:	89 c3                	mov    %eax,%ebx
 421:	50                   	push   %eax
 422:	e8 f4 00 00 00       	call   51b <fstat>
  close(fd);
 427:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 42a:	89 c6                	mov    %eax,%esi
  close(fd);
 42c:	e8 ba 00 00 00       	call   4eb <close>
  return r;
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	8d 65 f8             	lea    -0x8(%ebp),%esp
 437:	89 f0                	mov    %esi,%eax
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44e:	66 90                	xchg   %ax,%ax

00000450 <atoi>:

int
atoi(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 457:	0f be 02             	movsbl (%edx),%eax
 45a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 45d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 460:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 465:	77 1e                	ja     485 <atoi+0x35>
 467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 470:	83 c2 01             	add    $0x1,%edx
 473:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 476:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 47a:	0f be 02             	movsbl (%edx),%eax
 47d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x20>
  return n;
}
 485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 488:	89 c8                	mov    %ecx,%eax
 48a:	c9                   	leave  
 48b:	c3                   	ret    
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	8b 45 10             	mov    0x10(%ebp),%eax
 497:	8b 55 08             	mov    0x8(%ebp),%edx
 49a:	56                   	push   %esi
 49b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49e:	85 c0                	test   %eax,%eax
 4a0:	7e 13                	jle    4b5 <memmove+0x25>
 4a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4a4:	89 d7                	mov    %edx,%edi
 4a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4b1:	39 f8                	cmp    %edi,%eax
 4b3:	75 fb                	jne    4b0 <memmove+0x20>
  return vdst;
}
 4b5:	5e                   	pop    %esi
 4b6:	89 d0                	mov    %edx,%eax
 4b8:	5f                   	pop    %edi
 4b9:	5d                   	pop    %ebp
 4ba:	c3                   	ret    

000004bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4bb:	b8 01 00 00 00       	mov    $0x1,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <exit>:
SYSCALL(exit)
 4c3:	b8 02 00 00 00       	mov    $0x2,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <wait>:
SYSCALL(wait)
 4cb:	b8 03 00 00 00       	mov    $0x3,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <pipe>:
SYSCALL(pipe)
 4d3:	b8 04 00 00 00       	mov    $0x4,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <read>:
SYSCALL(read)
 4db:	b8 05 00 00 00       	mov    $0x5,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <write>:
SYSCALL(write)
 4e3:	b8 10 00 00 00       	mov    $0x10,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <close>:
SYSCALL(close)
 4eb:	b8 15 00 00 00       	mov    $0x15,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <kill>:
SYSCALL(kill)
 4f3:	b8 06 00 00 00       	mov    $0x6,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <exec>:
SYSCALL(exec)
 4fb:	b8 07 00 00 00       	mov    $0x7,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <open>:
SYSCALL(open)
 503:	b8 0f 00 00 00       	mov    $0xf,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <mknod>:
SYSCALL(mknod)
 50b:	b8 11 00 00 00       	mov    $0x11,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <unlink>:
SYSCALL(unlink)
 513:	b8 12 00 00 00       	mov    $0x12,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <fstat>:
SYSCALL(fstat)
 51b:	b8 08 00 00 00       	mov    $0x8,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <link>:
SYSCALL(link)
 523:	b8 13 00 00 00       	mov    $0x13,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <mkdir>:
SYSCALL(mkdir)
 52b:	b8 14 00 00 00       	mov    $0x14,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <chdir>:
SYSCALL(chdir)
 533:	b8 09 00 00 00       	mov    $0x9,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <dup>:
SYSCALL(dup)
 53b:	b8 0a 00 00 00       	mov    $0xa,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <getpid>:
SYSCALL(getpid)
 543:	b8 0b 00 00 00       	mov    $0xb,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <sbrk>:
SYSCALL(sbrk)
 54b:	b8 0c 00 00 00       	mov    $0xc,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <sleep>:
SYSCALL(sleep)
 553:	b8 0d 00 00 00       	mov    $0xd,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <uptime>:
SYSCALL(uptime)
 55b:	b8 0e 00 00 00       	mov    $0xe,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <printhugepde>:
SYSCALL(printhugepde)
 563:	b8 16 00 00 00       	mov    $0x16,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <procpgdirinfo>:
SYSCALL(procpgdirinfo)
 56b:	b8 17 00 00 00       	mov    $0x17,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <shugebrk>:
SYSCALL(shugebrk)
 573:	b8 18 00 00 00       	mov    $0x18,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <setthp>:
SYSCALL(setthp)
 57b:	b8 19 00 00 00       	mov    $0x19,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <getthp>:
SYSCALL(getthp)
 583:	b8 1a 00 00 00       	mov    $0x1a,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    
 58b:	66 90                	xchg   %ax,%ax
 58d:	66 90                	xchg   %ax,%ax
 58f:	90                   	nop

00000590 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 3c             	sub    $0x3c,%esp
 599:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 59c:	89 d1                	mov    %edx,%ecx
{
 59e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 5a1:	85 d2                	test   %edx,%edx
 5a3:	0f 89 7f 00 00 00    	jns    628 <printint+0x98>
 5a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5ad:	74 79                	je     628 <printint+0x98>
    neg = 1;
 5af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 5b6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 5b8:	31 db                	xor    %ebx,%ebx
 5ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5c0:	89 c8                	mov    %ecx,%eax
 5c2:	31 d2                	xor    %edx,%edx
 5c4:	89 cf                	mov    %ecx,%edi
 5c6:	f7 75 c4             	divl   -0x3c(%ebp)
 5c9:	0f b6 92 00 0e 00 00 	movzbl 0xe00(%edx),%edx
 5d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 5d3:	89 d8                	mov    %ebx,%eax
 5d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 5d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 5db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 5de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5e1:	76 dd                	jbe    5c0 <printint+0x30>
  if(neg)
 5e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5e6:	85 c9                	test   %ecx,%ecx
 5e8:	74 0c                	je     5f6 <printint+0x66>
    buf[i++] = '-';
 5ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 5ef:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5f1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5fd:	eb 07                	jmp    606 <printint+0x76>
 5ff:	90                   	nop
    putc(fd, buf[i]);
 600:	0f b6 13             	movzbl (%ebx),%edx
 603:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 606:	83 ec 04             	sub    $0x4,%esp
 609:	88 55 d7             	mov    %dl,-0x29(%ebp)
 60c:	6a 01                	push   $0x1
 60e:	56                   	push   %esi
 60f:	57                   	push   %edi
 610:	e8 ce fe ff ff       	call   4e3 <write>
  while(--i >= 0)
 615:	83 c4 10             	add    $0x10,%esp
 618:	39 de                	cmp    %ebx,%esi
 61a:	75 e4                	jne    600 <printint+0x70>
}
 61c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 628:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 62f:	eb 87                	jmp    5b8 <printint+0x28>
 631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop

00000640 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 649:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 64c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 64f:	0f b6 13             	movzbl (%ebx),%edx
 652:	84 d2                	test   %dl,%dl
 654:	74 6a                	je     6c0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 656:	8d 45 10             	lea    0x10(%ebp),%eax
 659:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 65c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 65f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 661:	89 45 d0             	mov    %eax,-0x30(%ebp)
 664:	eb 36                	jmp    69c <printf+0x5c>
 666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66d:	8d 76 00             	lea    0x0(%esi),%esi
 670:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 673:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 678:	83 f8 25             	cmp    $0x25,%eax
 67b:	74 15                	je     692 <printf+0x52>
  write(fd, &c, 1);
 67d:	83 ec 04             	sub    $0x4,%esp
 680:	88 55 e7             	mov    %dl,-0x19(%ebp)
 683:	6a 01                	push   $0x1
 685:	57                   	push   %edi
 686:	56                   	push   %esi
 687:	e8 57 fe ff ff       	call   4e3 <write>
 68c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 68f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 692:	0f b6 13             	movzbl (%ebx),%edx
 695:	83 c3 01             	add    $0x1,%ebx
 698:	84 d2                	test   %dl,%dl
 69a:	74 24                	je     6c0 <printf+0x80>
    c = fmt[i] & 0xff;
 69c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 69f:	85 c9                	test   %ecx,%ecx
 6a1:	74 cd                	je     670 <printf+0x30>
      }
    } else if(state == '%'){
 6a3:	83 f9 25             	cmp    $0x25,%ecx
 6a6:	75 ea                	jne    692 <printf+0x52>
      if(c == 'd'){
 6a8:	83 f8 25             	cmp    $0x25,%eax
 6ab:	0f 84 07 01 00 00    	je     7b8 <printf+0x178>
 6b1:	83 e8 63             	sub    $0x63,%eax
 6b4:	83 f8 15             	cmp    $0x15,%eax
 6b7:	77 17                	ja     6d0 <printf+0x90>
 6b9:	ff 24 85 a8 0d 00 00 	jmp    *0xda8(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c3:	5b                   	pop    %ebx
 6c4:	5e                   	pop    %esi
 6c5:	5f                   	pop    %edi
 6c6:	5d                   	pop    %ebp
 6c7:	c3                   	ret    
 6c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cf:	90                   	nop
  write(fd, &c, 1);
 6d0:	83 ec 04             	sub    $0x4,%esp
 6d3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 6d6:	6a 01                	push   $0x1
 6d8:	57                   	push   %edi
 6d9:	56                   	push   %esi
 6da:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6de:	e8 00 fe ff ff       	call   4e3 <write>
        putc(fd, c);
 6e3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 6e7:	83 c4 0c             	add    $0xc,%esp
 6ea:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6ed:	6a 01                	push   $0x1
 6ef:	57                   	push   %edi
 6f0:	56                   	push   %esi
 6f1:	e8 ed fd ff ff       	call   4e3 <write>
        putc(fd, c);
 6f6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f9:	31 c9                	xor    %ecx,%ecx
 6fb:	eb 95                	jmp    692 <printf+0x52>
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	b9 10 00 00 00       	mov    $0x10,%ecx
 708:	6a 00                	push   $0x0
 70a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 70d:	8b 10                	mov    (%eax),%edx
 70f:	89 f0                	mov    %esi,%eax
 711:	e8 7a fe ff ff       	call   590 <printint>
        ap++;
 716:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 71a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71d:	31 c9                	xor    %ecx,%ecx
 71f:	e9 6e ff ff ff       	jmp    692 <printf+0x52>
 724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 728:	8b 45 d0             	mov    -0x30(%ebp),%eax
 72b:	8b 10                	mov    (%eax),%edx
        ap++;
 72d:	83 c0 04             	add    $0x4,%eax
 730:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 733:	85 d2                	test   %edx,%edx
 735:	0f 84 8d 00 00 00    	je     7c8 <printf+0x188>
        while(*s != 0){
 73b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 73e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 740:	84 c0                	test   %al,%al
 742:	0f 84 4a ff ff ff    	je     692 <printf+0x52>
 748:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 74b:	89 d3                	mov    %edx,%ebx
 74d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
          s++;
 753:	83 c3 01             	add    $0x1,%ebx
 756:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 759:	6a 01                	push   $0x1
 75b:	57                   	push   %edi
 75c:	56                   	push   %esi
 75d:	e8 81 fd ff ff       	call   4e3 <write>
        while(*s != 0){
 762:	0f b6 03             	movzbl (%ebx),%eax
 765:	83 c4 10             	add    $0x10,%esp
 768:	84 c0                	test   %al,%al
 76a:	75 e4                	jne    750 <printf+0x110>
      state = 0;
 76c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 76f:	31 c9                	xor    %ecx,%ecx
 771:	e9 1c ff ff ff       	jmp    692 <printf+0x52>
 776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 0a 00 00 00       	mov    $0xa,%ecx
 788:	6a 01                	push   $0x1
 78a:	e9 7b ff ff ff       	jmp    70a <printf+0xca>
 78f:	90                   	nop
        putc(fd, *ap);
 790:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 793:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 796:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 798:	6a 01                	push   $0x1
 79a:	57                   	push   %edi
 79b:	56                   	push   %esi
        putc(fd, *ap);
 79c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 79f:	e8 3f fd ff ff       	call   4e3 <write>
        ap++;
 7a4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7a8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7ab:	31 c9                	xor    %ecx,%ecx
 7ad:	e9 e0 fe ff ff       	jmp    692 <printf+0x52>
 7b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 7b8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 7bb:	83 ec 04             	sub    $0x4,%esp
 7be:	e9 2a ff ff ff       	jmp    6ed <printf+0xad>
 7c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7c7:	90                   	nop
          s = "(null)";
 7c8:	ba a0 0d 00 00       	mov    $0xda0,%edx
        while(*s != 0){
 7cd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 7d0:	b8 28 00 00 00       	mov    $0x28,%eax
 7d5:	89 d3                	mov    %edx,%ebx
 7d7:	e9 74 ff ff ff       	jmp    750 <printf+0x110>
 7dc:	66 90                	xchg   %ax,%ax
 7de:	66 90                	xchg   %ax,%ax

000007e0 <vfree>:

// TODO: implement this
// part 2
void
vfree(void *ap)
{
 7e0:	55                   	push   %ebp
  if(flag == VMALLOC_SIZE_BASE)
  {
    // free regular pages
    Header *bp, *p;
    bp = (Header*)ap - 1;
    for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr){
 7e1:	a1 28 11 00 00       	mov    0x1128,%eax
{
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	57                   	push   %edi
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = (Header*)ap - 1;
 7ee:	8d 53 f8             	lea    -0x8(%ebx),%edx
  if (((uint) ap) >= ((uint) HUGE_PAGE_START)) {
 7f1:	81 fb ff ff ff 1d    	cmp    $0x1dffffff,%ebx
 7f7:	76 4f                	jbe    848 <vfree+0x68>
  {
    // free huge pages
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for(p = hugefreep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f9:	a1 1c 11 00 00       	mov    0x111c,%eax
 7fe:	66 90                	xchg   %ax,%ax
 800:	89 c1                	mov    %eax,%ecx
 802:	8b 00                	mov    (%eax),%eax
 804:	39 d1                	cmp    %edx,%ecx
 806:	73 78                	jae    880 <vfree+0xa0>
 808:	39 d0                	cmp    %edx,%eax
 80a:	77 04                	ja     810 <vfree+0x30>
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80c:	39 c1                	cmp    %eax,%ecx
 80e:	72 f0                	jb     800 <vfree+0x20>
        break;
    if(bp + bp->s.size == p->s.ptr){
 810:	8b 73 fc             	mov    -0x4(%ebx),%esi
 813:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 816:	39 f8                	cmp    %edi,%eax
 818:	0f 84 c2 00 00 00    	je     8e0 <vfree+0x100>
      bp->s.size += p->s.ptr->s.size;
      bp->s.ptr = p->s.ptr->s.ptr;
 81e:	89 43 f8             	mov    %eax,-0x8(%ebx)
    } else
      bp->s.ptr = p->s.ptr;
    if(p + p->s.size == bp){
 821:	8b 41 04             	mov    0x4(%ecx),%eax
 824:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 827:	39 f2                	cmp    %esi,%edx
 829:	74 75                	je     8a0 <vfree+0xc0>
      p->s.size += bp->s.size;
      p->s.ptr = bp->s.ptr;
 82b:	89 11                	mov    %edx,(%ecx)
    } else
      p->s.ptr = bp;
    hugefreep = p;
 82d:	89 0d 1c 11 00 00    	mov    %ecx,0x111c
  }
}
 833:	5b                   	pop    %ebx
 834:	5e                   	pop    %esi
 835:	5f                   	pop    %edi
 836:	5d                   	pop    %ebp
 837:	c3                   	ret    
 838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 83f:	90                   	nop
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	39 c1                	cmp    %eax,%ecx
 842:	72 04                	jb     848 <vfree+0x68>
 844:	39 d0                	cmp    %edx,%eax
 846:	77 10                	ja     858 <vfree+0x78>
    for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr){
 848:	89 c1                	mov    %eax,%ecx
 84a:	8b 00                	mov    (%eax),%eax
 84c:	39 d1                	cmp    %edx,%ecx
 84e:	73 f0                	jae    840 <vfree+0x60>
 850:	39 d0                	cmp    %edx,%eax
 852:	77 04                	ja     858 <vfree+0x78>
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	39 c1                	cmp    %eax,%ecx
 856:	72 f0                	jb     848 <vfree+0x68>
    if(bp + bp->s.size == p->s.ptr){
 858:	8b 73 fc             	mov    -0x4(%ebx),%esi
 85b:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 85e:	39 f8                	cmp    %edi,%eax
 860:	74 56                	je     8b8 <vfree+0xd8>
      bp->s.ptr = p->s.ptr->s.ptr;
 862:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 865:	8b 41 04             	mov    0x4(%ecx),%eax
 868:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 86b:	39 f2                	cmp    %esi,%edx
 86d:	74 60                	je     8cf <vfree+0xef>
      p->s.ptr = bp->s.ptr;
 86f:	89 11                	mov    %edx,(%ecx)
}
 871:	5b                   	pop    %ebx
    freep = p;
 872:	89 0d 28 11 00 00    	mov    %ecx,0x1128
}
 878:	5e                   	pop    %esi
 879:	5f                   	pop    %edi
 87a:	5d                   	pop    %ebp
 87b:	c3                   	ret    
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 880:	39 c1                	cmp    %eax,%ecx
 882:	0f 82 78 ff ff ff    	jb     800 <vfree+0x20>
 888:	39 d0                	cmp    %edx,%eax
 88a:	0f 86 70 ff ff ff    	jbe    800 <vfree+0x20>
    if(bp + bp->s.size == p->s.ptr){
 890:	8b 73 fc             	mov    -0x4(%ebx),%esi
 893:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 896:	39 f8                	cmp    %edi,%eax
 898:	75 84                	jne    81e <vfree+0x3e>
 89a:	eb 44                	jmp    8e0 <vfree+0x100>
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p->s.size += bp->s.size;
 8a0:	03 43 fc             	add    -0x4(%ebx),%eax
    hugefreep = p;
 8a3:	89 0d 1c 11 00 00    	mov    %ecx,0x111c
      p->s.size += bp->s.size;
 8a9:	89 41 04             	mov    %eax,0x4(%ecx)
      p->s.ptr = bp->s.ptr;
 8ac:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8af:	89 11                	mov    %edx,(%ecx)
    hugefreep = p;
 8b1:	eb 80                	jmp    833 <vfree+0x53>
 8b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8b7:	90                   	nop
      bp->s.size += p->s.ptr->s.size;
 8b8:	03 70 04             	add    0x4(%eax),%esi
 8bb:	89 73 fc             	mov    %esi,-0x4(%ebx)
      bp->s.ptr = p->s.ptr->s.ptr;
 8be:	8b 01                	mov    (%ecx),%eax
 8c0:	8b 00                	mov    (%eax),%eax
 8c2:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 8c5:	8b 41 04             	mov    0x4(%ecx),%eax
 8c8:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 8cb:	39 f2                	cmp    %esi,%edx
 8cd:	75 a0                	jne    86f <vfree+0x8f>
      p->s.size += bp->s.size;
 8cf:	03 43 fc             	add    -0x4(%ebx),%eax
 8d2:	89 41 04             	mov    %eax,0x4(%ecx)
      p->s.ptr = bp->s.ptr;
 8d5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8d8:	eb 95                	jmp    86f <vfree+0x8f>
 8da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      bp->s.size += p->s.ptr->s.size;
 8e0:	03 70 04             	add    0x4(%eax),%esi
 8e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
      bp->s.ptr = p->s.ptr->s.ptr;
 8e6:	8b 01                	mov    (%ecx),%eax
 8e8:	8b 00                	mov    (%eax),%eax
 8ea:	89 43 f8             	mov    %eax,-0x8(%ebx)
    if(p + p->s.size == bp){
 8ed:	8b 41 04             	mov    0x4(%ecx),%eax
 8f0:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
 8f3:	39 f2                	cmp    %esi,%edx
 8f5:	0f 85 30 ff ff ff    	jne    82b <vfree+0x4b>
 8fb:	eb a3                	jmp    8a0 <vfree+0xc0>
 8fd:	8d 76 00             	lea    0x0(%esi),%esi

00000900 <free>:
 vfree(ap);
 900:	e9 db fe ff ff       	jmp    7e0 <vfree>
 905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 90c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000910 <vmalloc>:
// TODO: implement this
// part 2

void*
vmalloc(uint nbytes, uint flag)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	57                   	push   %edi
 914:	56                   	push   %esi
 915:	53                   	push   %ebx
 916:	83 ec 1c             	sub    $0x1c,%esp
  if(flag == VMALLOC_SIZE_BASE)
 919:	8b 45 0c             	mov    0xc(%ebp),%eax
{
 91c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(flag == VMALLOC_SIZE_BASE)
 91f:	85 c0                	test   %eax,%eax
 921:	0f 84 f9 00 00 00    	je     a20 <vmalloc+0x110>
  {
    // alloc huge pages
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 927:	83 c6 07             	add    $0x7,%esi
    if((prevp = hugefreep) == 0){
 92a:	8b 3d 1c 11 00 00    	mov    0x111c,%edi
    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 930:	c1 ee 03             	shr    $0x3,%esi
 933:	83 c6 01             	add    $0x1,%esi
    if((prevp = hugefreep) == 0){
 936:	85 ff                	test   %edi,%edi
 938:	0f 84 b2 00 00 00    	je     9f0 <vmalloc+0xe0>
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
      hugebase.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	8b 17                	mov    (%edi),%edx
      if(p->s.size >= nunits){
 940:	8b 4a 04             	mov    0x4(%edx),%ecx
 943:	39 f1                	cmp    %esi,%ecx
 945:	73 67                	jae    9ae <vmalloc+0x9e>
 947:	bb 00 00 08 00       	mov    $0x80000,%ebx
 94c:	39 de                	cmp    %ebx,%esi
 94e:	0f 43 de             	cmovae %esi,%ebx
  p = shugebrk(nu * sizeof(Header));
 951:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 958:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 95b:	eb 14                	jmp    971 <vmalloc+0x61>
 95d:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 960:	8b 02                	mov    (%edx),%eax
      if(p->s.size >= nunits){
 962:	8b 48 04             	mov    0x4(%eax),%ecx
 965:	39 f1                	cmp    %esi,%ecx
 967:	73 4f                	jae    9b8 <vmalloc+0xa8>
          p->s.size = nunits;
        }
        hugefreep = prevp;
        return (void*)(p + 1);
      }
      if(p == hugefreep)
 969:	8b 3d 1c 11 00 00    	mov    0x111c,%edi
 96f:	89 c2                	mov    %eax,%edx
 971:	39 d7                	cmp    %edx,%edi
 973:	75 eb                	jne    960 <vmalloc+0x50>
  p = shugebrk(nu * sizeof(Header));
 975:	83 ec 0c             	sub    $0xc,%esp
 978:	ff 75 e4             	push   -0x1c(%ebp)
 97b:	e8 f3 fb ff ff       	call   573 <shugebrk>
  if(p == (char*)-1)
 980:	83 c4 10             	add    $0x10,%esp
 983:	83 f8 ff             	cmp    $0xffffffff,%eax
 986:	74 1c                	je     9a4 <vmalloc+0x94>
  hp->s.size = nu;
 988:	89 58 04             	mov    %ebx,0x4(%eax)
  vfree((void*)(hp + 1));
 98b:	83 ec 0c             	sub    $0xc,%esp
 98e:	83 c0 08             	add    $0x8,%eax
 991:	50                   	push   %eax
 992:	e8 49 fe ff ff       	call   7e0 <vfree>
  return hugefreep;
 997:	8b 15 1c 11 00 00    	mov    0x111c,%edx
        if((p = morehugecore(nunits)) == 0)
 99d:	83 c4 10             	add    $0x10,%esp
 9a0:	85 d2                	test   %edx,%edx
 9a2:	75 bc                	jne    960 <vmalloc+0x50>
          return 0;
    }
  }
 9a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
          return 0;
 9a7:	31 c0                	xor    %eax,%eax
 9a9:	5b                   	pop    %ebx
 9aa:	5e                   	pop    %esi
 9ab:	5f                   	pop    %edi
 9ac:	5d                   	pop    %ebp
 9ad:	c3                   	ret    
      if(p->s.size >= nunits){
 9ae:	89 d0                	mov    %edx,%eax
 9b0:	89 fa                	mov    %edi,%edx
 9b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(p->s.size == nunits)
 9b8:	39 ce                	cmp    %ecx,%esi
 9ba:	74 24                	je     9e0 <vmalloc+0xd0>
          p->s.size -= nunits;
 9bc:	29 f1                	sub    %esi,%ecx
 9be:	89 48 04             	mov    %ecx,0x4(%eax)
          p += p->s.size;
 9c1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
          p->s.size = nunits;
 9c4:	89 70 04             	mov    %esi,0x4(%eax)
        hugefreep = prevp;
 9c7:	89 15 1c 11 00 00    	mov    %edx,0x111c
 9cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return (void*)(p + 1);
 9d0:	83 c0 08             	add    $0x8,%eax
 9d3:	5b                   	pop    %ebx
 9d4:	5e                   	pop    %esi
 9d5:	5f                   	pop    %edi
 9d6:	5d                   	pop    %ebp
 9d7:	c3                   	ret    
 9d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9df:	90                   	nop
          prevp->s.ptr = p->s.ptr;
 9e0:	8b 08                	mov    (%eax),%ecx
 9e2:	89 0a                	mov    %ecx,(%edx)
 9e4:	eb e1                	jmp    9c7 <vmalloc+0xb7>
 9e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ed:	8d 76 00             	lea    0x0(%esi),%esi
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
 9f0:	c7 05 1c 11 00 00 20 	movl   $0x1120,0x111c
 9f7:	11 00 00 
      hugebase.s.size = 0;
 9fa:	bf 20 11 00 00       	mov    $0x1120,%edi
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
 9ff:	c7 05 20 11 00 00 20 	movl   $0x1120,0x1120
 a06:	11 00 00 
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a09:	89 fa                	mov    %edi,%edx
      hugebase.s.size = 0;
 a0b:	c7 05 24 11 00 00 00 	movl   $0x0,0x1124
 a12:	00 00 00 
      if(p->s.size >= nunits){
 a15:	e9 2d ff ff ff       	jmp    947 <vmalloc+0x37>
 a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a23:	5b                   	pop    %ebx
 a24:	5e                   	pop    %esi
 a25:	5f                   	pop    %edi
 a26:	5d                   	pop    %ebp
    return malloc(nbytes);
 a27:	eb 07                	jmp    a30 <malloc>
 a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a30 <malloc>:
{
 a30:	55                   	push   %ebp
 a31:	89 e5                	mov    %esp,%ebp
 a33:	57                   	push   %edi
 a34:	56                   	push   %esi
 a35:	53                   	push   %ebx
 a36:	83 ec 1c             	sub    $0x1c,%esp
 a39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(nbytes > 1000000 && (getthp() != 0)){
 a3c:	81 fe 40 42 0f 00    	cmp    $0xf4240,%esi
 a42:	0f 87 b8 00 00 00    	ja     b00 <malloc+0xd0>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a48:	83 c6 07             	add    $0x7,%esi
  if((prevp = freep) == 0){
 a4b:	8b 3d 28 11 00 00    	mov    0x1128,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a51:	c1 ee 03             	shr    $0x3,%esi
 a54:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 a57:	85 ff                	test   %edi,%edi
 a59:	0f 84 d1 00 00 00    	je     b30 <malloc+0x100>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5f:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 a61:	8b 4a 04             	mov    0x4(%edx),%ecx
 a64:	39 f1                	cmp    %esi,%ecx
 a66:	73 66                	jae    ace <malloc+0x9e>
 a68:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a6d:	39 de                	cmp    %ebx,%esi
 a6f:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 a72:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a7c:	eb 13                	jmp    a91 <malloc+0x61>
 a7e:	66 90                	xchg   %ax,%ax
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a80:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a82:	8b 48 04             	mov    0x4(%eax),%ecx
 a85:	39 f1                	cmp    %esi,%ecx
 a87:	73 4f                	jae    ad8 <malloc+0xa8>
    if(p == freep)
 a89:	8b 3d 28 11 00 00    	mov    0x1128,%edi
 a8f:	89 c2                	mov    %eax,%edx
 a91:	39 d7                	cmp    %edx,%edi
 a93:	75 eb                	jne    a80 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 a95:	83 ec 0c             	sub    $0xc,%esp
 a98:	ff 75 e4             	push   -0x1c(%ebp)
 a9b:	e8 ab fa ff ff       	call   54b <sbrk>
  if(p == (char*)-1)
 aa0:	83 c4 10             	add    $0x10,%esp
 aa3:	83 f8 ff             	cmp    $0xffffffff,%eax
 aa6:	74 1c                	je     ac4 <malloc+0x94>
  hp->s.size = nu;
 aa8:	89 58 04             	mov    %ebx,0x4(%eax)
  vfree((void*)(hp + 1));
 aab:	83 ec 0c             	sub    $0xc,%esp
 aae:	83 c0 08             	add    $0x8,%eax
 ab1:	50                   	push   %eax
 ab2:	e8 29 fd ff ff       	call   7e0 <vfree>
  return freep;
 ab7:	8b 15 28 11 00 00    	mov    0x1128,%edx
      if((p = morecore(nunits)) == 0)
 abd:	83 c4 10             	add    $0x10,%esp
 ac0:	85 d2                	test   %edx,%edx
 ac2:	75 bc                	jne    a80 <malloc+0x50>
}
 ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 ac7:	31 c0                	xor    %eax,%eax
}
 ac9:	5b                   	pop    %ebx
 aca:	5e                   	pop    %esi
 acb:	5f                   	pop    %edi
 acc:	5d                   	pop    %ebp
 acd:	c3                   	ret    
    if(p->s.size >= nunits){
 ace:	89 d0                	mov    %edx,%eax
 ad0:	89 fa                	mov    %edi,%edx
 ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 ad8:	39 ce                	cmp    %ecx,%esi
 ada:	0f 84 80 00 00 00    	je     b60 <malloc+0x130>
        p->s.size -= nunits;
 ae0:	29 f1                	sub    %esi,%ecx
 ae2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ae5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 ae8:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 aeb:	89 15 28 11 00 00    	mov    %edx,0x1128
      return (void*)(p + 1);
 af1:	83 c0 08             	add    $0x8,%eax
}
 af4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 af7:	5b                   	pop    %ebx
 af8:	5e                   	pop    %esi
 af9:	5f                   	pop    %edi
 afa:	5d                   	pop    %ebp
 afb:	c3                   	ret    
 afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(nbytes > 1000000 && (getthp() != 0)){
 b00:	e8 7e fa ff ff       	call   583 <getthp>
 b05:	85 c0                	test   %eax,%eax
 b07:	0f 84 3b ff ff ff    	je     a48 <malloc+0x18>
    printf(1, "Triggered thp\n");
 b0d:	83 ec 08             	sub    $0x8,%esp
 b10:	68 11 0e 00 00       	push   $0xe11
 b15:	6a 01                	push   $0x1
 b17:	e8 24 fb ff ff       	call   640 <printf>
    return vmalloc(nbytes, VMALLOC_SIZE_HUGE);
 b1c:	58                   	pop    %eax
 b1d:	5a                   	pop    %edx
 b1e:	6a 01                	push   $0x1
 b20:	56                   	push   %esi
 b21:	e8 ea fd ff ff       	call   910 <vmalloc>
 b26:	83 c4 10             	add    $0x10,%esp
 b29:	eb c9                	jmp    af4 <malloc+0xc4>
 b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b2f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 b30:	c7 05 28 11 00 00 2c 	movl   $0x112c,0x1128
 b37:	11 00 00 
    base.s.size = 0;
 b3a:	bf 2c 11 00 00       	mov    $0x112c,%edi
    base.s.ptr = freep = prevp = &base;
 b3f:	c7 05 2c 11 00 00 2c 	movl   $0x112c,0x112c
 b46:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b49:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 b4b:	c7 05 30 11 00 00 00 	movl   $0x0,0x1130
 b52:	00 00 00 
    if(p->s.size >= nunits){
 b55:	e9 0e ff ff ff       	jmp    a68 <malloc+0x38>
 b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 b60:	8b 08                	mov    (%eax),%ecx
 b62:	89 0a                	mov    %ecx,(%edx)
 b64:	eb 85                	jmp    aeb <malloc+0xbb>
