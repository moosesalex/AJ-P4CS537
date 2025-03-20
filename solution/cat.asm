
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	be 01 00 00 00       	mov    $0x1,%esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 18             	sub    $0x18,%esp
  19:	8b 01                	mov    (%ecx),%eax
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
  1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  21:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  24:	83 f8 01             	cmp    $0x1,%eax
  27:	7e 54                	jle    7d <main+0x7d>
  29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  30:	83 ec 08             	sub    $0x8,%esp
  33:	6a 00                	push   $0x0
  35:	ff 33                	push   (%ebx)
  37:	e8 67 03 00 00       	call   3a3 <open>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 c7                	mov    %eax,%edi
  41:	85 c0                	test   %eax,%eax
  43:	78 24                	js     69 <main+0x69>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  45:	83 ec 0c             	sub    $0xc,%esp
  for(i = 1; i < argc; i++){
  48:	83 c6 01             	add    $0x1,%esi
  4b:	83 c3 04             	add    $0x4,%ebx
    cat(fd);
  4e:	50                   	push   %eax
  4f:	e8 3c 00 00 00       	call   90 <cat>
    close(fd);
  54:	89 3c 24             	mov    %edi,(%esp)
  57:	e8 2f 03 00 00       	call   38b <close>
  for(i = 1; i < argc; i++){
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  62:	75 cc                	jne    30 <main+0x30>
  }
  exit();
  64:	e8 fa 02 00 00       	call   363 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  69:	50                   	push   %eax
  6a:	ff 33                	push   (%ebx)
  6c:	68 ff 09 00 00       	push   $0x9ff
  71:	6a 01                	push   $0x1
  73:	e8 58 04 00 00       	call   4d0 <printf>
      exit();
  78:	e8 e6 02 00 00       	call   363 <exit>
    cat(0);
  7d:	83 ec 0c             	sub    $0xc,%esp
  80:	6a 00                	push   $0x0
  82:	e8 09 00 00 00       	call   90 <cat>
    exit();
  87:	e8 d7 02 00 00       	call   363 <exit>
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <cat>:
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	56                   	push   %esi
  94:	8b 75 08             	mov    0x8(%ebp),%esi
  97:	53                   	push   %ebx
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  98:	eb 1d                	jmp    b7 <cat+0x27>
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (write(1, buf, n) != n) {
  a0:	83 ec 04             	sub    $0x4,%esp
  a3:	53                   	push   %ebx
  a4:	68 00 0e 00 00       	push   $0xe00
  a9:	6a 01                	push   $0x1
  ab:	e8 d3 02 00 00       	call   383 <write>
  b0:	83 c4 10             	add    $0x10,%esp
  b3:	39 d8                	cmp    %ebx,%eax
  b5:	75 25                	jne    dc <cat+0x4c>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  b7:	83 ec 04             	sub    $0x4,%esp
  ba:	68 00 02 00 00       	push   $0x200
  bf:	68 00 0e 00 00       	push   $0xe00
  c4:	56                   	push   %esi
  c5:	e8 b1 02 00 00       	call   37b <read>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	89 c3                	mov    %eax,%ebx
  cf:	85 c0                	test   %eax,%eax
  d1:	7f cd                	jg     a0 <cat+0x10>
  if(n < 0){
  d3:	75 1b                	jne    f0 <cat+0x60>
}
  d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  d8:	5b                   	pop    %ebx
  d9:	5e                   	pop    %esi
  da:	5d                   	pop    %ebp
  db:	c3                   	ret    
      printf(1, "cat: write error\n");
  dc:	83 ec 08             	sub    $0x8,%esp
  df:	68 dc 09 00 00       	push   $0x9dc
  e4:	6a 01                	push   $0x1
  e6:	e8 e5 03 00 00       	call   4d0 <printf>
      exit();
  eb:	e8 73 02 00 00       	call   363 <exit>
    printf(1, "cat: read error\n");
  f0:	50                   	push   %eax
  f1:	50                   	push   %eax
  f2:	68 ee 09 00 00       	push   $0x9ee
  f7:	6a 01                	push   $0x1
  f9:	e8 d2 03 00 00       	call   4d0 <printf>
    exit();
  fe:	e8 60 02 00 00       	call   363 <exit>
 103:	66 90                	xchg   %ax,%ax
 105:	66 90                	xchg   %ax,%ax
 107:	66 90                	xchg   %ax,%ax
 109:	66 90                	xchg   %ax,%ax
 10b:	66 90                	xchg   %ax,%ax
 10d:	66 90                	xchg   %ax,%ax
 10f:	90                   	nop

00000110 <strcpy>:
 110:	55                   	push   %ebp
 111:	31 c0                	xor    %eax,%eax
 113:	89 e5                	mov    %esp,%ebp
 115:	53                   	push   %ebx
 116:	8b 4d 08             	mov    0x8(%ebp),%ecx
 119:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 120:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 124:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 127:	83 c0 01             	add    $0x1,%eax
 12a:	84 d2                	test   %dl,%dl
 12c:	75 f2                	jne    120 <strcpy+0x10>
 12e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 131:	89 c8                	mov    %ecx,%eax
 133:	c9                   	leave  
 134:	c3                   	ret    
 135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000140 <strcmp>:
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 55 08             	mov    0x8(%ebp),%edx
 147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 14a:	0f b6 02             	movzbl (%edx),%eax
 14d:	84 c0                	test   %al,%al
 14f:	75 17                	jne    168 <strcmp+0x28>
 151:	eb 3a                	jmp    18d <strcmp+0x4d>
 153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 157:	90                   	nop
 158:	0f b6 42 01          	movzbl 0x1(%edx),%eax
 15c:	83 c2 01             	add    $0x1,%edx
 15f:	8d 59 01             	lea    0x1(%ecx),%ebx
 162:	84 c0                	test   %al,%al
 164:	74 1a                	je     180 <strcmp+0x40>
 166:	89 d9                	mov    %ebx,%ecx
 168:	0f b6 19             	movzbl (%ecx),%ebx
 16b:	38 c3                	cmp    %al,%bl
 16d:	74 e9                	je     158 <strcmp+0x18>
 16f:	29 d8                	sub    %ebx,%eax
 171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 174:	c9                   	leave  
 175:	c3                   	ret    
 176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 184:	31 c0                	xor    %eax,%eax
 186:	29 d8                	sub    %ebx,%eax
 188:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 18b:	c9                   	leave  
 18c:	c3                   	ret    
 18d:	0f b6 19             	movzbl (%ecx),%ebx
 190:	31 c0                	xor    %eax,%eax
 192:	eb db                	jmp    16f <strcmp+0x2f>
 194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 19f:	90                   	nop

000001a0 <strlen>:
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 55 08             	mov    0x8(%ebp),%edx
 1a6:	80 3a 00             	cmpb   $0x0,(%edx)
 1a9:	74 15                	je     1c0 <strlen+0x20>
 1ab:	31 c0                	xor    %eax,%eax
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
 1b0:	83 c0 01             	add    $0x1,%eax
 1b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1b7:	89 c1                	mov    %eax,%ecx
 1b9:	75 f5                	jne    1b0 <strlen+0x10>
 1bb:	89 c8                	mov    %ecx,%eax
 1bd:	5d                   	pop    %ebp
 1be:	c3                   	ret    
 1bf:	90                   	nop
 1c0:	31 c9                	xor    %ecx,%ecx
 1c2:	5d                   	pop    %ebp
 1c3:	89 c8                	mov    %ecx,%eax
 1c5:	c3                   	ret    
 1c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cd:	8d 76 00             	lea    0x0(%esi),%esi

000001d0 <memset>:
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	8b 55 08             	mov    0x8(%ebp),%edx
 1d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	89 d7                	mov    %edx,%edi
 1df:	fc                   	cld    
 1e0:	f3 aa                	rep stos %al,%es:(%edi)
 1e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1e5:	89 d0                	mov    %edx,%eax
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001f0 <strchr>:
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 1fa:	0f b6 10             	movzbl (%eax),%edx
 1fd:	84 d2                	test   %dl,%dl
 1ff:	75 12                	jne    213 <strchr+0x23>
 201:	eb 1d                	jmp    220 <strchr+0x30>
 203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 207:	90                   	nop
 208:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 20c:	83 c0 01             	add    $0x1,%eax
 20f:	84 d2                	test   %dl,%dl
 211:	74 0d                	je     220 <strchr+0x30>
 213:	38 d1                	cmp    %dl,%cl
 215:	75 f1                	jne    208 <strchr+0x18>
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 220:	31 c0                	xor    %eax,%eax
 222:	5d                   	pop    %ebp
 223:	c3                   	ret    
 224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop

00000230 <gets>:
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	8d 7d e7             	lea    -0x19(%ebp),%edi
 238:	53                   	push   %ebx
 239:	31 db                	xor    %ebx,%ebx
 23b:	83 ec 1c             	sub    $0x1c,%esp
 23e:	eb 27                	jmp    267 <gets+0x37>
 240:	83 ec 04             	sub    $0x4,%esp
 243:	6a 01                	push   $0x1
 245:	57                   	push   %edi
 246:	6a 00                	push   $0x0
 248:	e8 2e 01 00 00       	call   37b <read>
 24d:	83 c4 10             	add    $0x10,%esp
 250:	85 c0                	test   %eax,%eax
 252:	7e 1d                	jle    271 <gets+0x41>
 254:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 258:	8b 55 08             	mov    0x8(%ebp),%edx
 25b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
 25f:	3c 0a                	cmp    $0xa,%al
 261:	74 1d                	je     280 <gets+0x50>
 263:	3c 0d                	cmp    $0xd,%al
 265:	74 19                	je     280 <gets+0x50>
 267:	89 de                	mov    %ebx,%esi
 269:	83 c3 01             	add    $0x1,%ebx
 26c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 26f:	7c cf                	jl     240 <gets+0x10>
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 278:	8d 65 f4             	lea    -0xc(%ebp),%esp
 27b:	5b                   	pop    %ebx
 27c:	5e                   	pop    %esi
 27d:	5f                   	pop    %edi
 27e:	5d                   	pop    %ebp
 27f:	c3                   	ret    
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	89 de                	mov    %ebx,%esi
 285:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 289:	8d 65 f4             	lea    -0xc(%ebp),%esp
 28c:	5b                   	pop    %ebx
 28d:	5e                   	pop    %esi
 28e:	5f                   	pop    %edi
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
 291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop

000002a0 <stat>:
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
 2a5:	83 ec 08             	sub    $0x8,%esp
 2a8:	6a 00                	push   $0x0
 2aa:	ff 75 08             	push   0x8(%ebp)
 2ad:	e8 f1 00 00 00       	call   3a3 <open>
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	85 c0                	test   %eax,%eax
 2b7:	78 27                	js     2e0 <stat+0x40>
 2b9:	83 ec 08             	sub    $0x8,%esp
 2bc:	ff 75 0c             	push   0xc(%ebp)
 2bf:	89 c3                	mov    %eax,%ebx
 2c1:	50                   	push   %eax
 2c2:	e8 f4 00 00 00       	call   3bb <fstat>
 2c7:	89 1c 24             	mov    %ebx,(%esp)
 2ca:	89 c6                	mov    %eax,%esi
 2cc:	e8 ba 00 00 00       	call   38b <close>
 2d1:	83 c4 10             	add    $0x10,%esp
 2d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2d7:	89 f0                	mov    %esi,%eax
 2d9:	5b                   	pop    %ebx
 2da:	5e                   	pop    %esi
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2e5:	eb ed                	jmp    2d4 <stat+0x34>
 2e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ee:	66 90                	xchg   %ax,%ax

000002f0 <atoi>:
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	53                   	push   %ebx
 2f4:	8b 55 08             	mov    0x8(%ebp),%edx
 2f7:	0f be 02             	movsbl (%edx),%eax
 2fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2fd:	80 f9 09             	cmp    $0x9,%cl
 300:	b9 00 00 00 00       	mov    $0x0,%ecx
 305:	77 1e                	ja     325 <atoi+0x35>
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax
 310:	83 c2 01             	add    $0x1,%edx
 313:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 316:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 31a:	0f be 02             	movsbl (%edx),%eax
 31d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 320:	80 fb 09             	cmp    $0x9,%bl
 323:	76 eb                	jbe    310 <atoi+0x20>
 325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 328:	89 c8                	mov    %ecx,%eax
 32a:	c9                   	leave  
 32b:	c3                   	ret    
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000330 <memmove>:
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	8b 45 10             	mov    0x10(%ebp),%eax
 337:	8b 55 08             	mov    0x8(%ebp),%edx
 33a:	56                   	push   %esi
 33b:	8b 75 0c             	mov    0xc(%ebp),%esi
 33e:	85 c0                	test   %eax,%eax
 340:	7e 13                	jle    355 <memmove+0x25>
 342:	01 d0                	add    %edx,%eax
 344:	89 d7                	mov    %edx,%edi
 346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34d:	8d 76 00             	lea    0x0(%esi),%esi
 350:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 351:	39 f8                	cmp    %edi,%eax
 353:	75 fb                	jne    350 <memmove+0x20>
 355:	5e                   	pop    %esi
 356:	89 d0                	mov    %edx,%eax
 358:	5f                   	pop    %edi
 359:	5d                   	pop    %ebp
 35a:	c3                   	ret    

0000035b <fork>:
 35b:	b8 01 00 00 00       	mov    $0x1,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <exit>:
 363:	b8 02 00 00 00       	mov    $0x2,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <wait>:
 36b:	b8 03 00 00 00       	mov    $0x3,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <pipe>:
 373:	b8 04 00 00 00       	mov    $0x4,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <read>:
 37b:	b8 05 00 00 00       	mov    $0x5,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <write>:
 383:	b8 10 00 00 00       	mov    $0x10,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <close>:
 38b:	b8 15 00 00 00       	mov    $0x15,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <kill>:
 393:	b8 06 00 00 00       	mov    $0x6,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <exec>:
 39b:	b8 07 00 00 00       	mov    $0x7,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <open>:
 3a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <mknod>:
 3ab:	b8 11 00 00 00       	mov    $0x11,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <unlink>:
 3b3:	b8 12 00 00 00       	mov    $0x12,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <fstat>:
 3bb:	b8 08 00 00 00       	mov    $0x8,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <link>:
 3c3:	b8 13 00 00 00       	mov    $0x13,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mkdir>:
 3cb:	b8 14 00 00 00       	mov    $0x14,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <chdir>:
 3d3:	b8 09 00 00 00       	mov    $0x9,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <dup>:
 3db:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <getpid>:
 3e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <sbrk>:
 3eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <sleep>:
 3f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <uptime>:
 3fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <printhugepde>:
 403:	b8 16 00 00 00       	mov    $0x16,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <procpgdirinfo>:
 40b:	b8 17 00 00 00       	mov    $0x17,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <shugebrk>:
 413:	b8 18 00 00 00       	mov    $0x18,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    
 41b:	66 90                	xchg   %ax,%ax
 41d:	66 90                	xchg   %ax,%ax
 41f:	90                   	nop

00000420 <printint>:
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 3c             	sub    $0x3c,%esp
 429:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 42c:	89 d1                	mov    %edx,%ecx
 42e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 431:	85 d2                	test   %edx,%edx
 433:	0f 89 7f 00 00 00    	jns    4b8 <printint+0x98>
 439:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 43d:	74 79                	je     4b8 <printint+0x98>
 43f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 446:	f7 d9                	neg    %ecx
 448:	31 db                	xor    %ebx,%ebx
 44a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	89 c8                	mov    %ecx,%eax
 452:	31 d2                	xor    %edx,%edx
 454:	89 cf                	mov    %ecx,%edi
 456:	f7 75 c4             	divl   -0x3c(%ebp)
 459:	0f b6 92 74 0a 00 00 	movzbl 0xa74(%edx),%edx
 460:	89 45 c0             	mov    %eax,-0x40(%ebp)
 463:	89 d8                	mov    %ebx,%eax
 465:	8d 5b 01             	lea    0x1(%ebx),%ebx
 468:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 46b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 46e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 471:	76 dd                	jbe    450 <printint+0x30>
 473:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 476:	85 c9                	test   %ecx,%ecx
 478:	74 0c                	je     486 <printint+0x66>
 47a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 47f:	89 d8                	mov    %ebx,%eax
 481:	ba 2d 00 00 00       	mov    $0x2d,%edx
 486:	8b 7d b8             	mov    -0x48(%ebp),%edi
 489:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 48d:	eb 07                	jmp    496 <printint+0x76>
 48f:	90                   	nop
 490:	0f b6 13             	movzbl (%ebx),%edx
 493:	83 eb 01             	sub    $0x1,%ebx
 496:	83 ec 04             	sub    $0x4,%esp
 499:	88 55 d7             	mov    %dl,-0x29(%ebp)
 49c:	6a 01                	push   $0x1
 49e:	56                   	push   %esi
 49f:	57                   	push   %edi
 4a0:	e8 de fe ff ff       	call   383 <write>
 4a5:	83 c4 10             	add    $0x10,%esp
 4a8:	39 de                	cmp    %ebx,%esi
 4aa:	75 e4                	jne    490 <printint+0x70>
 4ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4af:	5b                   	pop    %ebx
 4b0:	5e                   	pop    %esi
 4b1:	5f                   	pop    %edi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4bf:	eb 87                	jmp    448 <printint+0x28>
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop

000004d0 <printf>:
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 2c             	sub    $0x2c,%esp
 4d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4dc:	8b 75 08             	mov    0x8(%ebp),%esi
 4df:	0f b6 13             	movzbl (%ebx),%edx
 4e2:	84 d2                	test   %dl,%dl
 4e4:	74 6a                	je     550 <printf+0x80>
 4e6:	8d 45 10             	lea    0x10(%ebp),%eax
 4e9:	83 c3 01             	add    $0x1,%ebx
 4ec:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4ef:	31 c9                	xor    %ecx,%ecx
 4f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4f4:	eb 36                	jmp    52c <printf+0x5c>
 4f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
 500:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 503:	b9 25 00 00 00       	mov    $0x25,%ecx
 508:	83 f8 25             	cmp    $0x25,%eax
 50b:	74 15                	je     522 <printf+0x52>
 50d:	83 ec 04             	sub    $0x4,%esp
 510:	88 55 e7             	mov    %dl,-0x19(%ebp)
 513:	6a 01                	push   $0x1
 515:	57                   	push   %edi
 516:	56                   	push   %esi
 517:	e8 67 fe ff ff       	call   383 <write>
 51c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 51f:	83 c4 10             	add    $0x10,%esp
 522:	0f b6 13             	movzbl (%ebx),%edx
 525:	83 c3 01             	add    $0x1,%ebx
 528:	84 d2                	test   %dl,%dl
 52a:	74 24                	je     550 <printf+0x80>
 52c:	0f b6 c2             	movzbl %dl,%eax
 52f:	85 c9                	test   %ecx,%ecx
 531:	74 cd                	je     500 <printf+0x30>
 533:	83 f9 25             	cmp    $0x25,%ecx
 536:	75 ea                	jne    522 <printf+0x52>
 538:	83 f8 25             	cmp    $0x25,%eax
 53b:	0f 84 07 01 00 00    	je     648 <printf+0x178>
 541:	83 e8 63             	sub    $0x63,%eax
 544:	83 f8 15             	cmp    $0x15,%eax
 547:	77 17                	ja     560 <printf+0x90>
 549:	ff 24 85 1c 0a 00 00 	jmp    *0xa1c(,%eax,4)
 550:	8d 65 f4             	lea    -0xc(%ebp),%esp
 553:	5b                   	pop    %ebx
 554:	5e                   	pop    %esi
 555:	5f                   	pop    %edi
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    
 558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop
 560:	83 ec 04             	sub    $0x4,%esp
 563:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 566:	6a 01                	push   $0x1
 568:	57                   	push   %edi
 569:	56                   	push   %esi
 56a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 56e:	e8 10 fe ff ff       	call   383 <write>
 573:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
 577:	83 c4 0c             	add    $0xc,%esp
 57a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 57d:	6a 01                	push   $0x1
 57f:	57                   	push   %edi
 580:	56                   	push   %esi
 581:	e8 fd fd ff ff       	call   383 <write>
 586:	83 c4 10             	add    $0x10,%esp
 589:	31 c9                	xor    %ecx,%ecx
 58b:	eb 95                	jmp    522 <printf+0x52>
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	83 ec 0c             	sub    $0xc,%esp
 593:	b9 10 00 00 00       	mov    $0x10,%ecx
 598:	6a 00                	push   $0x0
 59a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 59d:	8b 10                	mov    (%eax),%edx
 59f:	89 f0                	mov    %esi,%eax
 5a1:	e8 7a fe ff ff       	call   420 <printint>
 5a6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5aa:	83 c4 10             	add    $0x10,%esp
 5ad:	31 c9                	xor    %ecx,%ecx
 5af:	e9 6e ff ff ff       	jmp    522 <printf+0x52>
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5bb:	8b 10                	mov    (%eax),%edx
 5bd:	83 c0 04             	add    $0x4,%eax
 5c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5c3:	85 d2                	test   %edx,%edx
 5c5:	0f 84 8d 00 00 00    	je     658 <printf+0x188>
 5cb:	0f b6 02             	movzbl (%edx),%eax
 5ce:	31 c9                	xor    %ecx,%ecx
 5d0:	84 c0                	test   %al,%al
 5d2:	0f 84 4a ff ff ff    	je     522 <printf+0x52>
 5d8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5db:	89 d3                	mov    %edx,%ebx
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
 5e0:	83 ec 04             	sub    $0x4,%esp
 5e3:	83 c3 01             	add    $0x1,%ebx
 5e6:	88 45 e7             	mov    %al,-0x19(%ebp)
 5e9:	6a 01                	push   $0x1
 5eb:	57                   	push   %edi
 5ec:	56                   	push   %esi
 5ed:	e8 91 fd ff ff       	call   383 <write>
 5f2:	0f b6 03             	movzbl (%ebx),%eax
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	84 c0                	test   %al,%al
 5fa:	75 e4                	jne    5e0 <printf+0x110>
 5fc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5ff:	31 c9                	xor    %ecx,%ecx
 601:	e9 1c ff ff ff       	jmp    522 <printf+0x52>
 606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60d:	8d 76 00             	lea    0x0(%esi),%esi
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	b9 0a 00 00 00       	mov    $0xa,%ecx
 618:	6a 01                	push   $0x1
 61a:	e9 7b ff ff ff       	jmp    59a <printf+0xca>
 61f:	90                   	nop
 620:	8b 45 d0             	mov    -0x30(%ebp),%eax
 623:	83 ec 04             	sub    $0x4,%esp
 626:	8b 00                	mov    (%eax),%eax
 628:	6a 01                	push   $0x1
 62a:	57                   	push   %edi
 62b:	56                   	push   %esi
 62c:	88 45 e7             	mov    %al,-0x19(%ebp)
 62f:	e8 4f fd ff ff       	call   383 <write>
 634:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 638:	83 c4 10             	add    $0x10,%esp
 63b:	31 c9                	xor    %ecx,%ecx
 63d:	e9 e0 fe ff ff       	jmp    522 <printf+0x52>
 642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 648:	88 55 e7             	mov    %dl,-0x19(%ebp)
 64b:	83 ec 04             	sub    $0x4,%esp
 64e:	e9 2a ff ff ff       	jmp    57d <printf+0xad>
 653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 657:	90                   	nop
 658:	ba 14 0a 00 00       	mov    $0xa14,%edx
 65d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 660:	b8 28 00 00 00       	mov    $0x28,%eax
 665:	89 d3                	mov    %edx,%ebx
 667:	e9 74 ff ff ff       	jmp    5e0 <printf+0x110>
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <free>:
 670:	55                   	push   %ebp
 671:	a1 0c 10 00 00       	mov    0x100c,%eax
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	53                   	push   %ebx
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 67e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 688:	89 c2                	mov    %eax,%edx
 68a:	8b 00                	mov    (%eax),%eax
 68c:	39 ca                	cmp    %ecx,%edx
 68e:	73 30                	jae    6c0 <free+0x50>
 690:	39 c1                	cmp    %eax,%ecx
 692:	72 04                	jb     698 <free+0x28>
 694:	39 c2                	cmp    %eax,%edx
 696:	72 f0                	jb     688 <free+0x18>
 698:	8b 73 fc             	mov    -0x4(%ebx),%esi
 69b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69e:	39 f8                	cmp    %edi,%eax
 6a0:	74 30                	je     6d2 <free+0x62>
 6a2:	89 43 f8             	mov    %eax,-0x8(%ebx)
 6a5:	8b 42 04             	mov    0x4(%edx),%eax
 6a8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6ab:	39 f1                	cmp    %esi,%ecx
 6ad:	74 3a                	je     6e9 <free+0x79>
 6af:	89 0a                	mov    %ecx,(%edx)
 6b1:	5b                   	pop    %ebx
 6b2:	89 15 0c 10 00 00    	mov    %edx,0x100c
 6b8:	5e                   	pop    %esi
 6b9:	5f                   	pop    %edi
 6ba:	5d                   	pop    %ebp
 6bb:	c3                   	ret    
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6c0:	39 c2                	cmp    %eax,%edx
 6c2:	72 c4                	jb     688 <free+0x18>
 6c4:	39 c1                	cmp    %eax,%ecx
 6c6:	73 c0                	jae    688 <free+0x18>
 6c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ce:	39 f8                	cmp    %edi,%eax
 6d0:	75 d0                	jne    6a2 <free+0x32>
 6d2:	03 70 04             	add    0x4(%eax),%esi
 6d5:	89 73 fc             	mov    %esi,-0x4(%ebx)
 6d8:	8b 02                	mov    (%edx),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	89 43 f8             	mov    %eax,-0x8(%ebx)
 6df:	8b 42 04             	mov    0x4(%edx),%eax
 6e2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6e5:	39 f1                	cmp    %esi,%ecx
 6e7:	75 c6                	jne    6af <free+0x3f>
 6e9:	03 43 fc             	add    -0x4(%ebx),%eax
 6ec:	89 15 0c 10 00 00    	mov    %edx,0x100c
 6f2:	89 42 04             	mov    %eax,0x4(%edx)
 6f5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6f8:	89 0a                	mov    %ecx,(%edx)
 6fa:	5b                   	pop    %ebx
 6fb:	5e                   	pop    %esi
 6fc:	5f                   	pop    %edi
 6fd:	5d                   	pop    %ebp
 6fe:	c3                   	ret    
 6ff:	90                   	nop

00000700 <vfree>:
 700:	55                   	push   %ebp
 701:	a1 00 10 00 00       	mov    0x1000,%eax
 706:	89 e5                	mov    %esp,%ebp
 708:	57                   	push   %edi
 709:	8b 55 0c             	mov    0xc(%ebp),%edx
 70c:	56                   	push   %esi
 70d:	53                   	push   %ebx
 70e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 711:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 714:	85 d2                	test   %edx,%edx
 716:	0f 84 94 00 00 00    	je     7b0 <vfree+0xb0>
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 720:	89 c2                	mov    %eax,%edx
 722:	8b 00                	mov    (%eax),%eax
 724:	39 ca                	cmp    %ecx,%edx
 726:	73 30                	jae    758 <vfree+0x58>
 728:	39 c1                	cmp    %eax,%ecx
 72a:	72 04                	jb     730 <vfree+0x30>
 72c:	39 c2                	cmp    %eax,%edx
 72e:	72 f0                	jb     720 <vfree+0x20>
 730:	8b 73 fc             	mov    -0x4(%ebx),%esi
 733:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 736:	39 f8                	cmp    %edi,%eax
 738:	74 56                	je     790 <vfree+0x90>
 73a:	89 43 f8             	mov    %eax,-0x8(%ebx)
 73d:	8b 42 04             	mov    0x4(%edx),%eax
 740:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 743:	39 f1                	cmp    %esi,%ecx
 745:	74 29                	je     770 <vfree+0x70>
 747:	89 0a                	mov    %ecx,(%edx)
 749:	5b                   	pop    %ebx
 74a:	89 15 00 10 00 00    	mov    %edx,0x1000
 750:	5e                   	pop    %esi
 751:	5f                   	pop    %edi
 752:	5d                   	pop    %ebp
 753:	c3                   	ret    
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 758:	39 c2                	cmp    %eax,%edx
 75a:	72 c4                	jb     720 <vfree+0x20>
 75c:	39 c1                	cmp    %eax,%ecx
 75e:	73 c0                	jae    720 <vfree+0x20>
 760:	8b 73 fc             	mov    -0x4(%ebx),%esi
 763:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 766:	39 f8                	cmp    %edi,%eax
 768:	75 d0                	jne    73a <vfree+0x3a>
 76a:	eb 24                	jmp    790 <vfree+0x90>
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 770:	03 43 fc             	add    -0x4(%ebx),%eax
 773:	89 15 00 10 00 00    	mov    %edx,0x1000
 779:	89 42 04             	mov    %eax,0x4(%edx)
 77c:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 77f:	89 0a                	mov    %ecx,(%edx)
 781:	5b                   	pop    %ebx
 782:	5e                   	pop    %esi
 783:	5f                   	pop    %edi
 784:	5d                   	pop    %ebp
 785:	c3                   	ret    
 786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78d:	8d 76 00             	lea    0x0(%esi),%esi
 790:	03 70 04             	add    0x4(%eax),%esi
 793:	89 73 fc             	mov    %esi,-0x4(%ebx)
 796:	8b 02                	mov    (%edx),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	89 43 f8             	mov    %eax,-0x8(%ebx)
 79d:	8b 42 04             	mov    0x4(%edx),%eax
 7a0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7a3:	39 f1                	cmp    %esi,%ecx
 7a5:	75 a0                	jne    747 <vfree+0x47>
 7a7:	eb c7                	jmp    770 <vfree+0x70>
 7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7b0:	5b                   	pop    %ebx
 7b1:	5e                   	pop    %esi
 7b2:	5f                   	pop    %edi
 7b3:	5d                   	pop    %ebp
 7b4:	e9 b7 fe ff ff       	jmp    670 <free>
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000007c0 <malloc>:
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 1c             	sub    $0x1c,%esp
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
 7cc:	8b 3d 0c 10 00 00    	mov    0x100c,%edi
 7d2:	8d 70 07             	lea    0x7(%eax),%esi
 7d5:	c1 ee 03             	shr    $0x3,%esi
 7d8:	83 c6 01             	add    $0x1,%esi
 7db:	85 ff                	test   %edi,%edi
 7dd:	0f 84 9d 00 00 00    	je     880 <malloc+0xc0>
 7e3:	8b 17                	mov    (%edi),%edx
 7e5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7e8:	39 f1                	cmp    %esi,%ecx
 7ea:	73 6a                	jae    856 <malloc+0x96>
 7ec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7f1:	39 de                	cmp    %ebx,%esi
 7f3:	0f 43 de             	cmovae %esi,%ebx
 7f6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 800:	eb 17                	jmp    819 <malloc+0x59>
 802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 808:	8b 02                	mov    (%edx),%eax
 80a:	8b 48 04             	mov    0x4(%eax),%ecx
 80d:	39 f1                	cmp    %esi,%ecx
 80f:	73 4f                	jae    860 <malloc+0xa0>
 811:	8b 3d 0c 10 00 00    	mov    0x100c,%edi
 817:	89 c2                	mov    %eax,%edx
 819:	39 d7                	cmp    %edx,%edi
 81b:	75 eb                	jne    808 <malloc+0x48>
 81d:	83 ec 0c             	sub    $0xc,%esp
 820:	ff 75 e4             	push   -0x1c(%ebp)
 823:	e8 c3 fb ff ff       	call   3eb <sbrk>
 828:	83 c4 10             	add    $0x10,%esp
 82b:	83 f8 ff             	cmp    $0xffffffff,%eax
 82e:	74 1c                	je     84c <malloc+0x8c>
 830:	89 58 04             	mov    %ebx,0x4(%eax)
 833:	83 ec 0c             	sub    $0xc,%esp
 836:	83 c0 08             	add    $0x8,%eax
 839:	50                   	push   %eax
 83a:	e8 31 fe ff ff       	call   670 <free>
 83f:	8b 15 0c 10 00 00    	mov    0x100c,%edx
 845:	83 c4 10             	add    $0x10,%esp
 848:	85 d2                	test   %edx,%edx
 84a:	75 bc                	jne    808 <malloc+0x48>
 84c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 84f:	31 c0                	xor    %eax,%eax
 851:	5b                   	pop    %ebx
 852:	5e                   	pop    %esi
 853:	5f                   	pop    %edi
 854:	5d                   	pop    %ebp
 855:	c3                   	ret    
 856:	89 d0                	mov    %edx,%eax
 858:	89 fa                	mov    %edi,%edx
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 860:	39 ce                	cmp    %ecx,%esi
 862:	74 4c                	je     8b0 <malloc+0xf0>
 864:	29 f1                	sub    %esi,%ecx
 866:	89 48 04             	mov    %ecx,0x4(%eax)
 869:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 86c:	89 70 04             	mov    %esi,0x4(%eax)
 86f:	89 15 0c 10 00 00    	mov    %edx,0x100c
 875:	8d 65 f4             	lea    -0xc(%ebp),%esp
 878:	83 c0 08             	add    $0x8,%eax
 87b:	5b                   	pop    %ebx
 87c:	5e                   	pop    %esi
 87d:	5f                   	pop    %edi
 87e:	5d                   	pop    %ebp
 87f:	c3                   	ret    
 880:	c7 05 0c 10 00 00 10 	movl   $0x1010,0x100c
 887:	10 00 00 
 88a:	bf 10 10 00 00       	mov    $0x1010,%edi
 88f:	c7 05 10 10 00 00 10 	movl   $0x1010,0x1010
 896:	10 00 00 
 899:	89 fa                	mov    %edi,%edx
 89b:	c7 05 14 10 00 00 00 	movl   $0x0,0x1014
 8a2:	00 00 00 
 8a5:	e9 42 ff ff ff       	jmp    7ec <malloc+0x2c>
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8b0:	8b 08                	mov    (%eax),%ecx
 8b2:	89 0a                	mov    %ecx,(%edx)
 8b4:	eb b9                	jmp    86f <malloc+0xaf>
 8b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8bd:	8d 76 00             	lea    0x0(%esi),%esi

000008c0 <vmalloc>:
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	57                   	push   %edi
 8c4:	56                   	push   %esi
 8c5:	53                   	push   %ebx
 8c6:	83 ec 1c             	sub    $0x1c,%esp
 8c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 8cc:	8b 75 08             	mov    0x8(%ebp),%esi
 8cf:	85 c0                	test   %eax,%eax
 8d1:	0f 84 f9 00 00 00    	je     9d0 <vmalloc+0x110>
 8d7:	83 c6 07             	add    $0x7,%esi
 8da:	8b 3d 00 10 00 00    	mov    0x1000,%edi
 8e0:	c1 ee 03             	shr    $0x3,%esi
 8e3:	83 c6 01             	add    $0x1,%esi
 8e6:	85 ff                	test   %edi,%edi
 8e8:	0f 84 b2 00 00 00    	je     9a0 <vmalloc+0xe0>
 8ee:	8b 17                	mov    (%edi),%edx
 8f0:	8b 4a 04             	mov    0x4(%edx),%ecx
 8f3:	39 f1                	cmp    %esi,%ecx
 8f5:	73 67                	jae    95e <vmalloc+0x9e>
 8f7:	bb 00 00 08 00       	mov    $0x80000,%ebx
 8fc:	39 de                	cmp    %ebx,%esi
 8fe:	0f 43 de             	cmovae %esi,%ebx
 901:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 908:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 90b:	eb 14                	jmp    921 <vmalloc+0x61>
 90d:	8d 76 00             	lea    0x0(%esi),%esi
 910:	8b 02                	mov    (%edx),%eax
 912:	8b 48 04             	mov    0x4(%eax),%ecx
 915:	39 f1                	cmp    %esi,%ecx
 917:	73 4f                	jae    968 <vmalloc+0xa8>
 919:	8b 3d 00 10 00 00    	mov    0x1000,%edi
 91f:	89 c2                	mov    %eax,%edx
 921:	39 d7                	cmp    %edx,%edi
 923:	75 eb                	jne    910 <vmalloc+0x50>
 925:	83 ec 0c             	sub    $0xc,%esp
 928:	ff 75 e4             	push   -0x1c(%ebp)
 92b:	e8 e3 fa ff ff       	call   413 <shugebrk>
 930:	83 c4 10             	add    $0x10,%esp
 933:	83 f8 ff             	cmp    $0xffffffff,%eax
 936:	74 1c                	je     954 <vmalloc+0x94>
 938:	89 58 04             	mov    %ebx,0x4(%eax)
 93b:	83 ec 0c             	sub    $0xc,%esp
 93e:	83 c0 08             	add    $0x8,%eax
 941:	50                   	push   %eax
 942:	e8 29 fd ff ff       	call   670 <free>
 947:	8b 15 00 10 00 00    	mov    0x1000,%edx
 94d:	83 c4 10             	add    $0x10,%esp
 950:	85 d2                	test   %edx,%edx
 952:	75 bc                	jne    910 <vmalloc+0x50>
 954:	8d 65 f4             	lea    -0xc(%ebp),%esp
 957:	31 c0                	xor    %eax,%eax
 959:	5b                   	pop    %ebx
 95a:	5e                   	pop    %esi
 95b:	5f                   	pop    %edi
 95c:	5d                   	pop    %ebp
 95d:	c3                   	ret    
 95e:	89 d0                	mov    %edx,%eax
 960:	89 fa                	mov    %edi,%edx
 962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 968:	39 ce                	cmp    %ecx,%esi
 96a:	74 24                	je     990 <vmalloc+0xd0>
 96c:	29 f1                	sub    %esi,%ecx
 96e:	89 48 04             	mov    %ecx,0x4(%eax)
 971:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 974:	89 70 04             	mov    %esi,0x4(%eax)
 977:	89 15 00 10 00 00    	mov    %edx,0x1000
 97d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 980:	83 c0 08             	add    $0x8,%eax
 983:	5b                   	pop    %ebx
 984:	5e                   	pop    %esi
 985:	5f                   	pop    %edi
 986:	5d                   	pop    %ebp
 987:	c3                   	ret    
 988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 98f:	90                   	nop
 990:	8b 08                	mov    (%eax),%ecx
 992:	89 0a                	mov    %ecx,(%edx)
 994:	eb e1                	jmp    977 <vmalloc+0xb7>
 996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 99d:	8d 76 00             	lea    0x0(%esi),%esi
 9a0:	c7 05 00 10 00 00 04 	movl   $0x1004,0x1000
 9a7:	10 00 00 
 9aa:	bf 04 10 00 00       	mov    $0x1004,%edi
 9af:	c7 05 04 10 00 00 04 	movl   $0x1004,0x1004
 9b6:	10 00 00 
 9b9:	89 fa                	mov    %edi,%edx
 9bb:	c7 05 08 10 00 00 00 	movl   $0x0,0x1008
 9c2:	00 00 00 
 9c5:	e9 2d ff ff ff       	jmp    8f7 <vmalloc+0x37>
 9ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9d3:	5b                   	pop    %ebx
 9d4:	5e                   	pop    %esi
 9d5:	5f                   	pop    %edi
 9d6:	5d                   	pop    %ebp
 9d7:	e9 e4 fd ff ff       	jmp    7c0 <malloc>
