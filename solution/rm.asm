
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	bf 01 00 00 00       	mov    $0x1,%edi
  13:	56                   	push   %esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  1c:	8b 31                	mov    (%ecx),%esi
  1e:	83 c3 04             	add    $0x4,%ebx
  21:	83 fe 01             	cmp    $0x1,%esi
  24:	7e 3e                	jle    64 <main+0x64>
  26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2d:	8d 76 00             	lea    0x0(%esi),%esi
  30:	83 ec 0c             	sub    $0xc,%esp
  33:	ff 33                	push   (%ebx)
  35:	e8 e9 02 00 00       	call   323 <unlink>
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 c0                	test   %eax,%eax
  3f:	78 0f                	js     50 <main+0x50>
  41:	83 c7 01             	add    $0x1,%edi
  44:	83 c3 04             	add    $0x4,%ebx
  47:	39 fe                	cmp    %edi,%esi
  49:	75 e5                	jne    30 <main+0x30>
  4b:	e8 83 02 00 00       	call   2d3 <exit>
  50:	50                   	push   %eax
  51:	ff 33                	push   (%ebx)
  53:	68 60 09 00 00       	push   $0x960
  58:	6a 02                	push   $0x2
  5a:	e8 e1 03 00 00       	call   440 <printf>
  5f:	83 c4 10             	add    $0x10,%esp
  62:	eb e7                	jmp    4b <main+0x4b>
  64:	52                   	push   %edx
  65:	52                   	push   %edx
  66:	68 4c 09 00 00       	push   $0x94c
  6b:	6a 02                	push   $0x2
  6d:	e8 ce 03 00 00       	call   440 <printf>
  72:	e8 5c 02 00 00       	call   2d3 <exit>
  77:	66 90                	xchg   %ax,%ax
  79:	66 90                	xchg   %ax,%ax
  7b:	66 90                	xchg   %ax,%ax
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <strcpy>:
  80:	55                   	push   %ebp
  81:	31 c0                	xor    %eax,%eax
  83:	89 e5                	mov    %esp,%ebp
  85:	53                   	push   %ebx
  86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  90:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  94:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  97:	83 c0 01             	add    $0x1,%eax
  9a:	84 d2                	test   %dl,%dl
  9c:	75 f2                	jne    90 <strcpy+0x10>
  9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a1:	89 c8                	mov    %ecx,%eax
  a3:	c9                   	leave  
  a4:	c3                   	ret    
  a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000b0 <strcmp>:
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 55 08             	mov    0x8(%ebp),%edx
  b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ba:	0f b6 02             	movzbl (%edx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 17                	jne    d8 <strcmp+0x28>
  c1:	eb 3a                	jmp    fd <strcmp+0x4d>
  c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  c7:	90                   	nop
  c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  cc:	83 c2 01             	add    $0x1,%edx
  cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  d2:	84 c0                	test   %al,%al
  d4:	74 1a                	je     f0 <strcmp+0x40>
  d6:	89 d9                	mov    %ebx,%ecx
  d8:	0f b6 19             	movzbl (%ecx),%ebx
  db:	38 c3                	cmp    %al,%bl
  dd:	74 e9                	je     c8 <strcmp+0x18>
  df:	29 d8                	sub    %ebx,%eax
  e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  e4:	c9                   	leave  
  e5:	c3                   	ret    
  e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  f4:	31 c0                	xor    %eax,%eax
  f6:	29 d8                	sub    %ebx,%eax
  f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  fb:	c9                   	leave  
  fc:	c3                   	ret    
  fd:	0f b6 19             	movzbl (%ecx),%ebx
 100:	31 c0                	xor    %eax,%eax
 102:	eb db                	jmp    df <strcmp+0x2f>
 104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 10f:	90                   	nop

00000110 <strlen>:
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
 116:	80 3a 00             	cmpb   $0x0,(%edx)
 119:	74 15                	je     130 <strlen+0x20>
 11b:	31 c0                	xor    %eax,%eax
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	83 c0 01             	add    $0x1,%eax
 123:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 127:	89 c1                	mov    %eax,%ecx
 129:	75 f5                	jne    120 <strlen+0x10>
 12b:	89 c8                	mov    %ecx,%eax
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
 12f:	90                   	nop
 130:	31 c9                	xor    %ecx,%ecx
 132:	5d                   	pop    %ebp
 133:	89 c8                	mov    %ecx,%eax
 135:	c3                   	ret    
 136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13d:	8d 76 00             	lea    0x0(%esi),%esi

00000140 <memset>:
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	8b 55 08             	mov    0x8(%ebp),%edx
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
 152:	8b 7d fc             	mov    -0x4(%ebp),%edi
 155:	89 d0                	mov    %edx,%eax
 157:	c9                   	leave  
 158:	c3                   	ret    
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000160 <strchr>:
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	75 12                	jne    183 <strchr+0x23>
 171:	eb 1d                	jmp    190 <strchr+0x30>
 173:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 177:	90                   	nop
 178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 17c:	83 c0 01             	add    $0x1,%eax
 17f:	84 d2                	test   %dl,%dl
 181:	74 0d                	je     190 <strchr+0x30>
 183:	38 d1                	cmp    %dl,%cl
 185:	75 f1                	jne    178 <strchr+0x18>
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 190:	31 c0                	xor    %eax,%eax
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    
 194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 19f:	90                   	nop

000001a0 <gets>:
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	8d 7d e7             	lea    -0x19(%ebp),%edi
 1a8:	53                   	push   %ebx
 1a9:	31 db                	xor    %ebx,%ebx
 1ab:	83 ec 1c             	sub    $0x1c,%esp
 1ae:	eb 27                	jmp    1d7 <gets+0x37>
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	6a 01                	push   $0x1
 1b5:	57                   	push   %edi
 1b6:	6a 00                	push   $0x0
 1b8:	e8 2e 01 00 00       	call   2eb <read>
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	85 c0                	test   %eax,%eax
 1c2:	7e 1d                	jle    1e1 <gets+0x41>
 1c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c8:	8b 55 08             	mov    0x8(%ebp),%edx
 1cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
 1cf:	3c 0a                	cmp    $0xa,%al
 1d1:	74 1d                	je     1f0 <gets+0x50>
 1d3:	3c 0d                	cmp    $0xd,%al
 1d5:	74 19                	je     1f0 <gets+0x50>
 1d7:	89 de                	mov    %ebx,%esi
 1d9:	83 c3 01             	add    $0x1,%ebx
 1dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1df:	7c cf                	jl     1b0 <gets+0x10>
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 1e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1eb:	5b                   	pop    %ebx
 1ec:	5e                   	pop    %esi
 1ed:	5f                   	pop    %edi
 1ee:	5d                   	pop    %ebp
 1ef:	c3                   	ret    
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	89 de                	mov    %ebx,%esi
 1f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 1f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1fc:	5b                   	pop    %ebx
 1fd:	5e                   	pop    %esi
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20f:	90                   	nop

00000210 <stat>:
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
 215:	83 ec 08             	sub    $0x8,%esp
 218:	6a 00                	push   $0x0
 21a:	ff 75 08             	push   0x8(%ebp)
 21d:	e8 f1 00 00 00       	call   313 <open>
 222:	83 c4 10             	add    $0x10,%esp
 225:	85 c0                	test   %eax,%eax
 227:	78 27                	js     250 <stat+0x40>
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	ff 75 0c             	push   0xc(%ebp)
 22f:	89 c3                	mov    %eax,%ebx
 231:	50                   	push   %eax
 232:	e8 f4 00 00 00       	call   32b <fstat>
 237:	89 1c 24             	mov    %ebx,(%esp)
 23a:	89 c6                	mov    %eax,%esi
 23c:	e8 ba 00 00 00       	call   2fb <close>
 241:	83 c4 10             	add    $0x10,%esp
 244:	8d 65 f8             	lea    -0x8(%ebp),%esp
 247:	89 f0                	mov    %esi,%eax
 249:	5b                   	pop    %ebx
 24a:	5e                   	pop    %esi
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi
 250:	be ff ff ff ff       	mov    $0xffffffff,%esi
 255:	eb ed                	jmp    244 <stat+0x34>
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax

00000260 <atoi>:
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 55 08             	mov    0x8(%ebp),%edx
 267:	0f be 02             	movsbl (%edx),%eax
 26a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 26d:	80 f9 09             	cmp    $0x9,%cl
 270:	b9 00 00 00 00       	mov    $0x0,%ecx
 275:	77 1e                	ja     295 <atoi+0x35>
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax
 280:	83 c2 01             	add    $0x1,%edx
 283:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 286:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 28a:	0f be 02             	movsbl (%edx),%eax
 28d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 290:	80 fb 09             	cmp    $0x9,%bl
 293:	76 eb                	jbe    280 <atoi+0x20>
 295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 298:	89 c8                	mov    %ecx,%eax
 29a:	c9                   	leave  
 29b:	c3                   	ret    
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <memmove>:
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	8b 45 10             	mov    0x10(%ebp),%eax
 2a7:	8b 55 08             	mov    0x8(%ebp),%edx
 2aa:	56                   	push   %esi
 2ab:	8b 75 0c             	mov    0xc(%ebp),%esi
 2ae:	85 c0                	test   %eax,%eax
 2b0:	7e 13                	jle    2c5 <memmove+0x25>
 2b2:	01 d0                	add    %edx,%eax
 2b4:	89 d7                	mov    %edx,%edi
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
 2c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 2c1:	39 f8                	cmp    %edi,%eax
 2c3:	75 fb                	jne    2c0 <memmove+0x20>
 2c5:	5e                   	pop    %esi
 2c6:	89 d0                	mov    %edx,%eax
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    

000002cb <fork>:
 2cb:	b8 01 00 00 00       	mov    $0x1,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <exit>:
 2d3:	b8 02 00 00 00       	mov    $0x2,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <wait>:
 2db:	b8 03 00 00 00       	mov    $0x3,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <pipe>:
 2e3:	b8 04 00 00 00       	mov    $0x4,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <read>:
 2eb:	b8 05 00 00 00       	mov    $0x5,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <write>:
 2f3:	b8 10 00 00 00       	mov    $0x10,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <close>:
 2fb:	b8 15 00 00 00       	mov    $0x15,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <kill>:
 303:	b8 06 00 00 00       	mov    $0x6,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <exec>:
 30b:	b8 07 00 00 00       	mov    $0x7,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <open>:
 313:	b8 0f 00 00 00       	mov    $0xf,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mknod>:
 31b:	b8 11 00 00 00       	mov    $0x11,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <unlink>:
 323:	b8 12 00 00 00       	mov    $0x12,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <fstat>:
 32b:	b8 08 00 00 00       	mov    $0x8,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <link>:
 333:	b8 13 00 00 00       	mov    $0x13,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mkdir>:
 33b:	b8 14 00 00 00       	mov    $0x14,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <chdir>:
 343:	b8 09 00 00 00       	mov    $0x9,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <dup>:
 34b:	b8 0a 00 00 00       	mov    $0xa,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <getpid>:
 353:	b8 0b 00 00 00       	mov    $0xb,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sbrk>:
 35b:	b8 0c 00 00 00       	mov    $0xc,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <sleep>:
 363:	b8 0d 00 00 00       	mov    $0xd,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <uptime>:
 36b:	b8 0e 00 00 00       	mov    $0xe,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <printhugepde>:
 373:	b8 16 00 00 00       	mov    $0x16,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <procpgdirinfo>:
 37b:	b8 17 00 00 00       	mov    $0x17,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <shugebrk>:
 383:	b8 18 00 00 00       	mov    $0x18,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    
 38b:	66 90                	xchg   %ax,%ax
 38d:	66 90                	xchg   %ax,%ax
 38f:	90                   	nop

00000390 <printint>:
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 3c             	sub    $0x3c,%esp
 399:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 39c:	89 d1                	mov    %edx,%ecx
 39e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 3a1:	85 d2                	test   %edx,%edx
 3a3:	0f 89 7f 00 00 00    	jns    428 <printint+0x98>
 3a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ad:	74 79                	je     428 <printint+0x98>
 3af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 3b6:	f7 d9                	neg    %ecx
 3b8:	31 db                	xor    %ebx,%ebx
 3ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	89 c8                	mov    %ecx,%eax
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	89 cf                	mov    %ecx,%edi
 3c6:	f7 75 c4             	divl   -0x3c(%ebp)
 3c9:	0f b6 92 d8 09 00 00 	movzbl 0x9d8(%edx),%edx
 3d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3d3:	89 d8                	mov    %ebx,%eax
 3d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
 3d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 3db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 3de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3e1:	76 dd                	jbe    3c0 <printint+0x30>
 3e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3e6:	85 c9                	test   %ecx,%ecx
 3e8:	74 0c                	je     3f6 <printint+0x66>
 3ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ef:	89 d8                	mov    %ebx,%eax
 3f1:	ba 2d 00 00 00       	mov    $0x2d,%edx
 3f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3fd:	eb 07                	jmp    406 <printint+0x76>
 3ff:	90                   	nop
 400:	0f b6 13             	movzbl (%ebx),%edx
 403:	83 eb 01             	sub    $0x1,%ebx
 406:	83 ec 04             	sub    $0x4,%esp
 409:	88 55 d7             	mov    %dl,-0x29(%ebp)
 40c:	6a 01                	push   $0x1
 40e:	56                   	push   %esi
 40f:	57                   	push   %edi
 410:	e8 de fe ff ff       	call   2f3 <write>
 415:	83 c4 10             	add    $0x10,%esp
 418:	39 de                	cmp    %ebx,%esi
 41a:	75 e4                	jne    400 <printint+0x70>
 41c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41f:	5b                   	pop    %ebx
 420:	5e                   	pop    %esi
 421:	5f                   	pop    %edi
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
 424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 428:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 42f:	eb 87                	jmp    3b8 <printint+0x28>
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop

00000440 <printf>:
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 2c             	sub    $0x2c,%esp
 449:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 44c:	8b 75 08             	mov    0x8(%ebp),%esi
 44f:	0f b6 13             	movzbl (%ebx),%edx
 452:	84 d2                	test   %dl,%dl
 454:	74 6a                	je     4c0 <printf+0x80>
 456:	8d 45 10             	lea    0x10(%ebp),%eax
 459:	83 c3 01             	add    $0x1,%ebx
 45c:	8d 7d e7             	lea    -0x19(%ebp),%edi
 45f:	31 c9                	xor    %ecx,%ecx
 461:	89 45 d0             	mov    %eax,-0x30(%ebp)
 464:	eb 36                	jmp    49c <printf+0x5c>
 466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi
 470:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 473:	b9 25 00 00 00       	mov    $0x25,%ecx
 478:	83 f8 25             	cmp    $0x25,%eax
 47b:	74 15                	je     492 <printf+0x52>
 47d:	83 ec 04             	sub    $0x4,%esp
 480:	88 55 e7             	mov    %dl,-0x19(%ebp)
 483:	6a 01                	push   $0x1
 485:	57                   	push   %edi
 486:	56                   	push   %esi
 487:	e8 67 fe ff ff       	call   2f3 <write>
 48c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 48f:	83 c4 10             	add    $0x10,%esp
 492:	0f b6 13             	movzbl (%ebx),%edx
 495:	83 c3 01             	add    $0x1,%ebx
 498:	84 d2                	test   %dl,%dl
 49a:	74 24                	je     4c0 <printf+0x80>
 49c:	0f b6 c2             	movzbl %dl,%eax
 49f:	85 c9                	test   %ecx,%ecx
 4a1:	74 cd                	je     470 <printf+0x30>
 4a3:	83 f9 25             	cmp    $0x25,%ecx
 4a6:	75 ea                	jne    492 <printf+0x52>
 4a8:	83 f8 25             	cmp    $0x25,%eax
 4ab:	0f 84 07 01 00 00    	je     5b8 <printf+0x178>
 4b1:	83 e8 63             	sub    $0x63,%eax
 4b4:	83 f8 15             	cmp    $0x15,%eax
 4b7:	77 17                	ja     4d0 <printf+0x90>
 4b9:	ff 24 85 80 09 00 00 	jmp    *0x980(,%eax,4)
 4c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c3:	5b                   	pop    %ebx
 4c4:	5e                   	pop    %esi
 4c5:	5f                   	pop    %edi
 4c6:	5d                   	pop    %ebp
 4c7:	c3                   	ret    
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 4d6:	6a 01                	push   $0x1
 4d8:	57                   	push   %edi
 4d9:	56                   	push   %esi
 4da:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4de:	e8 10 fe ff ff       	call   2f3 <write>
 4e3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
 4e7:	83 c4 0c             	add    $0xc,%esp
 4ea:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4ed:	6a 01                	push   $0x1
 4ef:	57                   	push   %edi
 4f0:	56                   	push   %esi
 4f1:	e8 fd fd ff ff       	call   2f3 <write>
 4f6:	83 c4 10             	add    $0x10,%esp
 4f9:	31 c9                	xor    %ecx,%ecx
 4fb:	eb 95                	jmp    492 <printf+0x52>
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
 500:	83 ec 0c             	sub    $0xc,%esp
 503:	b9 10 00 00 00       	mov    $0x10,%ecx
 508:	6a 00                	push   $0x0
 50a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 50d:	8b 10                	mov    (%eax),%edx
 50f:	89 f0                	mov    %esi,%eax
 511:	e8 7a fe ff ff       	call   390 <printint>
 516:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 51a:	83 c4 10             	add    $0x10,%esp
 51d:	31 c9                	xor    %ecx,%ecx
 51f:	e9 6e ff ff ff       	jmp    492 <printf+0x52>
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 528:	8b 45 d0             	mov    -0x30(%ebp),%eax
 52b:	8b 10                	mov    (%eax),%edx
 52d:	83 c0 04             	add    $0x4,%eax
 530:	89 45 d0             	mov    %eax,-0x30(%ebp)
 533:	85 d2                	test   %edx,%edx
 535:	0f 84 8d 00 00 00    	je     5c8 <printf+0x188>
 53b:	0f b6 02             	movzbl (%edx),%eax
 53e:	31 c9                	xor    %ecx,%ecx
 540:	84 c0                	test   %al,%al
 542:	0f 84 4a ff ff ff    	je     492 <printf+0x52>
 548:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 54b:	89 d3                	mov    %edx,%ebx
 54d:	8d 76 00             	lea    0x0(%esi),%esi
 550:	83 ec 04             	sub    $0x4,%esp
 553:	83 c3 01             	add    $0x1,%ebx
 556:	88 45 e7             	mov    %al,-0x19(%ebp)
 559:	6a 01                	push   $0x1
 55b:	57                   	push   %edi
 55c:	56                   	push   %esi
 55d:	e8 91 fd ff ff       	call   2f3 <write>
 562:	0f b6 03             	movzbl (%ebx),%eax
 565:	83 c4 10             	add    $0x10,%esp
 568:	84 c0                	test   %al,%al
 56a:	75 e4                	jne    550 <printf+0x110>
 56c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 56f:	31 c9                	xor    %ecx,%ecx
 571:	e9 1c ff ff ff       	jmp    492 <printf+0x52>
 576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
 580:	83 ec 0c             	sub    $0xc,%esp
 583:	b9 0a 00 00 00       	mov    $0xa,%ecx
 588:	6a 01                	push   $0x1
 58a:	e9 7b ff ff ff       	jmp    50a <printf+0xca>
 58f:	90                   	nop
 590:	8b 45 d0             	mov    -0x30(%ebp),%eax
 593:	83 ec 04             	sub    $0x4,%esp
 596:	8b 00                	mov    (%eax),%eax
 598:	6a 01                	push   $0x1
 59a:	57                   	push   %edi
 59b:	56                   	push   %esi
 59c:	88 45 e7             	mov    %al,-0x19(%ebp)
 59f:	e8 4f fd ff ff       	call   2f3 <write>
 5a4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5a8:	83 c4 10             	add    $0x10,%esp
 5ab:	31 c9                	xor    %ecx,%ecx
 5ad:	e9 e0 fe ff ff       	jmp    492 <printf+0x52>
 5b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5b8:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5bb:	83 ec 04             	sub    $0x4,%esp
 5be:	e9 2a ff ff ff       	jmp    4ed <printf+0xad>
 5c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5c7:	90                   	nop
 5c8:	ba 79 09 00 00       	mov    $0x979,%edx
 5cd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5d0:	b8 28 00 00 00       	mov    $0x28,%eax
 5d5:	89 d3                	mov    %edx,%ebx
 5d7:	e9 74 ff ff ff       	jmp    550 <printf+0x110>
 5dc:	66 90                	xchg   %ax,%ax
 5de:	66 90                	xchg   %ax,%ax

000005e0 <free>:
 5e0:	55                   	push   %ebp
 5e1:	a1 30 0d 00 00       	mov    0xd30,%eax
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f8:	89 c2                	mov    %eax,%edx
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	39 ca                	cmp    %ecx,%edx
 5fe:	73 30                	jae    630 <free+0x50>
 600:	39 c1                	cmp    %eax,%ecx
 602:	72 04                	jb     608 <free+0x28>
 604:	39 c2                	cmp    %eax,%edx
 606:	72 f0                	jb     5f8 <free+0x18>
 608:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 f8                	cmp    %edi,%eax
 610:	74 30                	je     642 <free+0x62>
 612:	89 43 f8             	mov    %eax,-0x8(%ebx)
 615:	8b 42 04             	mov    0x4(%edx),%eax
 618:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 61b:	39 f1                	cmp    %esi,%ecx
 61d:	74 3a                	je     659 <free+0x79>
 61f:	89 0a                	mov    %ecx,(%edx)
 621:	5b                   	pop    %ebx
 622:	89 15 30 0d 00 00    	mov    %edx,0xd30
 628:	5e                   	pop    %esi
 629:	5f                   	pop    %edi
 62a:	5d                   	pop    %ebp
 62b:	c3                   	ret    
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 630:	39 c2                	cmp    %eax,%edx
 632:	72 c4                	jb     5f8 <free+0x18>
 634:	39 c1                	cmp    %eax,%ecx
 636:	73 c0                	jae    5f8 <free+0x18>
 638:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63e:	39 f8                	cmp    %edi,%eax
 640:	75 d0                	jne    612 <free+0x32>
 642:	03 70 04             	add    0x4(%eax),%esi
 645:	89 73 fc             	mov    %esi,-0x4(%ebx)
 648:	8b 02                	mov    (%edx),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	89 43 f8             	mov    %eax,-0x8(%ebx)
 64f:	8b 42 04             	mov    0x4(%edx),%eax
 652:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 655:	39 f1                	cmp    %esi,%ecx
 657:	75 c6                	jne    61f <free+0x3f>
 659:	03 43 fc             	add    -0x4(%ebx),%eax
 65c:	89 15 30 0d 00 00    	mov    %edx,0xd30
 662:	89 42 04             	mov    %eax,0x4(%edx)
 665:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 668:	89 0a                	mov    %ecx,(%edx)
 66a:	5b                   	pop    %ebx
 66b:	5e                   	pop    %esi
 66c:	5f                   	pop    %edi
 66d:	5d                   	pop    %ebp
 66e:	c3                   	ret    
 66f:	90                   	nop

00000670 <vfree>:
 670:	55                   	push   %ebp
 671:	a1 24 0d 00 00       	mov    0xd24,%eax
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	8b 55 0c             	mov    0xc(%ebp),%edx
 67c:	56                   	push   %esi
 67d:	53                   	push   %ebx
 67e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 681:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 684:	85 d2                	test   %edx,%edx
 686:	0f 84 94 00 00 00    	je     720 <vfree+0xb0>
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 690:	89 c2                	mov    %eax,%edx
 692:	8b 00                	mov    (%eax),%eax
 694:	39 ca                	cmp    %ecx,%edx
 696:	73 30                	jae    6c8 <vfree+0x58>
 698:	39 c1                	cmp    %eax,%ecx
 69a:	72 04                	jb     6a0 <vfree+0x30>
 69c:	39 c2                	cmp    %eax,%edx
 69e:	72 f0                	jb     690 <vfree+0x20>
 6a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6a3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6a6:	39 f8                	cmp    %edi,%eax
 6a8:	74 56                	je     700 <vfree+0x90>
 6aa:	89 43 f8             	mov    %eax,-0x8(%ebx)
 6ad:	8b 42 04             	mov    0x4(%edx),%eax
 6b0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6b3:	39 f1                	cmp    %esi,%ecx
 6b5:	74 29                	je     6e0 <vfree+0x70>
 6b7:	89 0a                	mov    %ecx,(%edx)
 6b9:	5b                   	pop    %ebx
 6ba:	89 15 24 0d 00 00    	mov    %edx,0xd24
 6c0:	5e                   	pop    %esi
 6c1:	5f                   	pop    %edi
 6c2:	5d                   	pop    %ebp
 6c3:	c3                   	ret    
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6c8:	39 c2                	cmp    %eax,%edx
 6ca:	72 c4                	jb     690 <vfree+0x20>
 6cc:	39 c1                	cmp    %eax,%ecx
 6ce:	73 c0                	jae    690 <vfree+0x20>
 6d0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6d3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6d6:	39 f8                	cmp    %edi,%eax
 6d8:	75 d0                	jne    6aa <vfree+0x3a>
 6da:	eb 24                	jmp    700 <vfree+0x90>
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e0:	03 43 fc             	add    -0x4(%ebx),%eax
 6e3:	89 15 24 0d 00 00    	mov    %edx,0xd24
 6e9:	89 42 04             	mov    %eax,0x4(%edx)
 6ec:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6ef:	89 0a                	mov    %ecx,(%edx)
 6f1:	5b                   	pop    %ebx
 6f2:	5e                   	pop    %esi
 6f3:	5f                   	pop    %edi
 6f4:	5d                   	pop    %ebp
 6f5:	c3                   	ret    
 6f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
 700:	03 70 04             	add    0x4(%eax),%esi
 703:	89 73 fc             	mov    %esi,-0x4(%ebx)
 706:	8b 02                	mov    (%edx),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	89 43 f8             	mov    %eax,-0x8(%ebx)
 70d:	8b 42 04             	mov    0x4(%edx),%eax
 710:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 713:	39 f1                	cmp    %esi,%ecx
 715:	75 a0                	jne    6b7 <vfree+0x47>
 717:	eb c7                	jmp    6e0 <vfree+0x70>
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 720:	5b                   	pop    %ebx
 721:	5e                   	pop    %esi
 722:	5f                   	pop    %edi
 723:	5d                   	pop    %ebp
 724:	e9 b7 fe ff ff       	jmp    5e0 <free>
 729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000730 <malloc>:
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 1c             	sub    $0x1c,%esp
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	8b 3d 30 0d 00 00    	mov    0xd30,%edi
 742:	8d 70 07             	lea    0x7(%eax),%esi
 745:	c1 ee 03             	shr    $0x3,%esi
 748:	83 c6 01             	add    $0x1,%esi
 74b:	85 ff                	test   %edi,%edi
 74d:	0f 84 9d 00 00 00    	je     7f0 <malloc+0xc0>
 753:	8b 17                	mov    (%edi),%edx
 755:	8b 4a 04             	mov    0x4(%edx),%ecx
 758:	39 f1                	cmp    %esi,%ecx
 75a:	73 6a                	jae    7c6 <malloc+0x96>
 75c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 761:	39 de                	cmp    %ebx,%esi
 763:	0f 43 de             	cmovae %esi,%ebx
 766:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 76d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 770:	eb 17                	jmp    789 <malloc+0x59>
 772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 778:	8b 02                	mov    (%edx),%eax
 77a:	8b 48 04             	mov    0x4(%eax),%ecx
 77d:	39 f1                	cmp    %esi,%ecx
 77f:	73 4f                	jae    7d0 <malloc+0xa0>
 781:	8b 3d 30 0d 00 00    	mov    0xd30,%edi
 787:	89 c2                	mov    %eax,%edx
 789:	39 d7                	cmp    %edx,%edi
 78b:	75 eb                	jne    778 <malloc+0x48>
 78d:	83 ec 0c             	sub    $0xc,%esp
 790:	ff 75 e4             	push   -0x1c(%ebp)
 793:	e8 c3 fb ff ff       	call   35b <sbrk>
 798:	83 c4 10             	add    $0x10,%esp
 79b:	83 f8 ff             	cmp    $0xffffffff,%eax
 79e:	74 1c                	je     7bc <malloc+0x8c>
 7a0:	89 58 04             	mov    %ebx,0x4(%eax)
 7a3:	83 ec 0c             	sub    $0xc,%esp
 7a6:	83 c0 08             	add    $0x8,%eax
 7a9:	50                   	push   %eax
 7aa:	e8 31 fe ff ff       	call   5e0 <free>
 7af:	8b 15 30 0d 00 00    	mov    0xd30,%edx
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	85 d2                	test   %edx,%edx
 7ba:	75 bc                	jne    778 <malloc+0x48>
 7bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7bf:	31 c0                	xor    %eax,%eax
 7c1:	5b                   	pop    %ebx
 7c2:	5e                   	pop    %esi
 7c3:	5f                   	pop    %edi
 7c4:	5d                   	pop    %ebp
 7c5:	c3                   	ret    
 7c6:	89 d0                	mov    %edx,%eax
 7c8:	89 fa                	mov    %edi,%edx
 7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7d0:	39 ce                	cmp    %ecx,%esi
 7d2:	74 4c                	je     820 <malloc+0xf0>
 7d4:	29 f1                	sub    %esi,%ecx
 7d6:	89 48 04             	mov    %ecx,0x4(%eax)
 7d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 7dc:	89 70 04             	mov    %esi,0x4(%eax)
 7df:	89 15 30 0d 00 00    	mov    %edx,0xd30
 7e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7e8:	83 c0 08             	add    $0x8,%eax
 7eb:	5b                   	pop    %ebx
 7ec:	5e                   	pop    %esi
 7ed:	5f                   	pop    %edi
 7ee:	5d                   	pop    %ebp
 7ef:	c3                   	ret    
 7f0:	c7 05 30 0d 00 00 34 	movl   $0xd34,0xd30
 7f7:	0d 00 00 
 7fa:	bf 34 0d 00 00       	mov    $0xd34,%edi
 7ff:	c7 05 34 0d 00 00 34 	movl   $0xd34,0xd34
 806:	0d 00 00 
 809:	89 fa                	mov    %edi,%edx
 80b:	c7 05 38 0d 00 00 00 	movl   $0x0,0xd38
 812:	00 00 00 
 815:	e9 42 ff ff ff       	jmp    75c <malloc+0x2c>
 81a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 820:	8b 08                	mov    (%eax),%ecx
 822:	89 0a                	mov    %ecx,(%edx)
 824:	eb b9                	jmp    7df <malloc+0xaf>
 826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82d:	8d 76 00             	lea    0x0(%esi),%esi

00000830 <vmalloc>:
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	57                   	push   %edi
 834:	56                   	push   %esi
 835:	53                   	push   %ebx
 836:	83 ec 1c             	sub    $0x1c,%esp
 839:	8b 45 0c             	mov    0xc(%ebp),%eax
 83c:	8b 75 08             	mov    0x8(%ebp),%esi
 83f:	85 c0                	test   %eax,%eax
 841:	0f 84 f9 00 00 00    	je     940 <vmalloc+0x110>
 847:	83 c6 07             	add    $0x7,%esi
 84a:	8b 3d 24 0d 00 00    	mov    0xd24,%edi
 850:	c1 ee 03             	shr    $0x3,%esi
 853:	83 c6 01             	add    $0x1,%esi
 856:	85 ff                	test   %edi,%edi
 858:	0f 84 b2 00 00 00    	je     910 <vmalloc+0xe0>
 85e:	8b 17                	mov    (%edi),%edx
 860:	8b 4a 04             	mov    0x4(%edx),%ecx
 863:	39 f1                	cmp    %esi,%ecx
 865:	73 67                	jae    8ce <vmalloc+0x9e>
 867:	bb 00 00 08 00       	mov    $0x80000,%ebx
 86c:	39 de                	cmp    %ebx,%esi
 86e:	0f 43 de             	cmovae %esi,%ebx
 871:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 878:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 87b:	eb 14                	jmp    891 <vmalloc+0x61>
 87d:	8d 76 00             	lea    0x0(%esi),%esi
 880:	8b 02                	mov    (%edx),%eax
 882:	8b 48 04             	mov    0x4(%eax),%ecx
 885:	39 f1                	cmp    %esi,%ecx
 887:	73 4f                	jae    8d8 <vmalloc+0xa8>
 889:	8b 3d 24 0d 00 00    	mov    0xd24,%edi
 88f:	89 c2                	mov    %eax,%edx
 891:	39 d7                	cmp    %edx,%edi
 893:	75 eb                	jne    880 <vmalloc+0x50>
 895:	83 ec 0c             	sub    $0xc,%esp
 898:	ff 75 e4             	push   -0x1c(%ebp)
 89b:	e8 e3 fa ff ff       	call   383 <shugebrk>
 8a0:	83 c4 10             	add    $0x10,%esp
 8a3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8a6:	74 1c                	je     8c4 <vmalloc+0x94>
 8a8:	89 58 04             	mov    %ebx,0x4(%eax)
 8ab:	83 ec 0c             	sub    $0xc,%esp
 8ae:	83 c0 08             	add    $0x8,%eax
 8b1:	50                   	push   %eax
 8b2:	e8 29 fd ff ff       	call   5e0 <free>
 8b7:	8b 15 24 0d 00 00    	mov    0xd24,%edx
 8bd:	83 c4 10             	add    $0x10,%esp
 8c0:	85 d2                	test   %edx,%edx
 8c2:	75 bc                	jne    880 <vmalloc+0x50>
 8c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8c7:	31 c0                	xor    %eax,%eax
 8c9:	5b                   	pop    %ebx
 8ca:	5e                   	pop    %esi
 8cb:	5f                   	pop    %edi
 8cc:	5d                   	pop    %ebp
 8cd:	c3                   	ret    
 8ce:	89 d0                	mov    %edx,%eax
 8d0:	89 fa                	mov    %edi,%edx
 8d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8d8:	39 ce                	cmp    %ecx,%esi
 8da:	74 24                	je     900 <vmalloc+0xd0>
 8dc:	29 f1                	sub    %esi,%ecx
 8de:	89 48 04             	mov    %ecx,0x4(%eax)
 8e1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 8e4:	89 70 04             	mov    %esi,0x4(%eax)
 8e7:	89 15 24 0d 00 00    	mov    %edx,0xd24
 8ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8f0:	83 c0 08             	add    $0x8,%eax
 8f3:	5b                   	pop    %ebx
 8f4:	5e                   	pop    %esi
 8f5:	5f                   	pop    %edi
 8f6:	5d                   	pop    %ebp
 8f7:	c3                   	ret    
 8f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ff:	90                   	nop
 900:	8b 08                	mov    (%eax),%ecx
 902:	89 0a                	mov    %ecx,(%edx)
 904:	eb e1                	jmp    8e7 <vmalloc+0xb7>
 906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 90d:	8d 76 00             	lea    0x0(%esi),%esi
 910:	c7 05 24 0d 00 00 28 	movl   $0xd28,0xd24
 917:	0d 00 00 
 91a:	bf 28 0d 00 00       	mov    $0xd28,%edi
 91f:	c7 05 28 0d 00 00 28 	movl   $0xd28,0xd28
 926:	0d 00 00 
 929:	89 fa                	mov    %edi,%edx
 92b:	c7 05 2c 0d 00 00 00 	movl   $0x0,0xd2c
 932:	00 00 00 
 935:	e9 2d ff ff ff       	jmp    867 <vmalloc+0x37>
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 940:	8d 65 f4             	lea    -0xc(%ebp),%esp
 943:	5b                   	pop    %ebx
 944:	5e                   	pop    %esi
 945:	5f                   	pop    %edi
 946:	5d                   	pop    %ebp
 947:	e9 e4 fd ff ff       	jmp    730 <malloc>
