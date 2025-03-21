
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc f0 65 11 80       	mov    $0x801165f0,%esp
8010002d:	b8 70 32 10 80       	mov    $0x80103270,%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 74 b5 10 80       	mov    $0x8010b574,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 78 10 80       	push   $0x80107840
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 25 46 00 00       	call   80104680 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 3c fc 10 80       	mov    $0x8010fc3c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 8c fc 10 80 3c 	movl   $0x8010fc3c,0x8010fc8c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 90 fc 10 80 3c 	movl   $0x8010fc3c,0x8010fc90
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 3c fc 10 80 	movl   $0x8010fc3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 78 10 80       	push   $0x80107847
80100097:	50                   	push   %eax
80100098:	e8 b3 44 00 00       	call   80104550 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 90 fc 10 80    	mov    %ebx,0x8010fc90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb e0 f9 10 80    	cmp    $0x8010f9e0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 40 b5 10 80       	push   $0x8010b540
801000e4:	e8 67 47 00 00       	call   80104850 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 90 fc 10 80    	mov    0x8010fc90,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 8c fc 10 80    	mov    0x8010fc8c,%ebx
80100126:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 40 b5 10 80       	push   $0x8010b540
80100162:	e8 89 46 00 00       	call   801047f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 44 00 00       	call   80104590 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 21 00 00       	call   801022f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 78 10 80       	push   $0x8010784e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 44 00 00       	call   80104630 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 78 10 80       	push   $0x8010785f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 44 00 00       	call   80104630 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 43 00 00       	call   801045f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 30 46 00 00       	call   80104850 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 3c fc 10 80 	movl   $0x8010fc3c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 90 fc 10 80    	mov    %ebx,0x8010fc90
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 40 b5 10 80 	movl   $0x8010b540,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 7f 45 00 00       	jmp    801047f0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 78 10 80       	push   $0x80107866
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 15 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801002a0:	e8 ab 45 00 00       	call   80104850 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002b5:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 40 ff 10 80       	push   $0x8010ff40
801002c8:	68 20 ff 10 80       	push   $0x8010ff20
801002cd:	e8 1e 40 00 00       	call   801042f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 38 00 00       	call   80103b90 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 f5 44 00 00       	call   801047f0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 14 00 00       	call   80101790 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 20 ff 10 80    	mov    %edx,0x8010ff20
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a a0 fe 10 80 	movsbl -0x7fef0160(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 40 ff 10 80       	push   $0x8010ff40
8010034c:	e8 9f 44 00 00       	call   801047f0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 14 00 00       	call   80101790 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 20 ff 10 80       	mov    %eax,0x8010ff20
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 74 ff 10 80 00 	movl   $0x0,0x8010ff74
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 27 00 00       	call   80102b00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 78 10 80       	push   $0x8010786d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 bb 81 10 80 	movl   $0x801081bb,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 d3 42 00 00       	call   801046a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 78 10 80       	push   $0x80107881
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 ff 10 80 01 	movl   $0x1,0x8010ff78
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 c1 5c 00 00       	call   801060e0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 d6 5b 00 00       	call   801060e0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ca 5b 00 00       	call   801060e0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 be 5b 00 00       	call   801060e0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 5a 44 00 00       	call   801049b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 a5 43 00 00       	call   80104910 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 78 10 80       	push   $0x80107885
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 cc 12 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801005ab:	e8 a0 42 00 00       	call   80104850 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 40 ff 10 80       	push   $0x8010ff40
801005e4:	e8 07 42 00 00       	call   801047f0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 9e 11 00 00       	call   80101790 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 b0 78 10 80 	movzbl -0x7fef8750(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 74 ff 10 80       	mov    0x8010ff74,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 78 ff 10 80    	mov    0x8010ff78,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 40 ff 10 80       	push   $0x8010ff40
801007e8:	e8 63 40 00 00       	call   80104850 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 78 ff 10 80    	mov    0x8010ff78,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 98 78 10 80       	mov    $0x80107898,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 ff 10 80       	push   $0x8010ff40
8010085b:	e8 90 3f 00 00       	call   801047f0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 78 10 80       	push   $0x8010789f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 40 ff 10 80       	push   $0x8010ff40
80100893:	e8 b8 3f 00 00       	call   80104850 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 20 ff 10 80    	sub    0x8010ff20,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 28 ff 10 80    	mov    %ecx,0x8010ff28
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 a0 fe 10 80    	mov    %bl,-0x7fef0160(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 28 ff 10 80    	cmp    %eax,0x8010ff28
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100945:	39 05 24 ff 10 80    	cmp    %eax,0x8010ff24
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba a0 fe 10 80 0a 	cmpb   $0xa,-0x7fef0160(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
        input.e--;
8010096c:	a3 28 ff 10 80       	mov    %eax,0x8010ff28
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100985:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 28 ff 10 80       	mov    %eax,0x8010ff28
  if(panicked){
80100999:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
801009b7:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 40 ff 10 80       	push   $0x8010ff40
801009d0:	e8 1b 3e 00 00       	call   801047f0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 7d 3a 00 00       	jmp    80104490 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 a0 fe 10 80 0a 	movb   $0xa,-0x7fef0160(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 24 ff 10 80       	mov    %eax,0x8010ff24
          wakeup(&input.r);
80100a3f:	68 20 ff 10 80       	push   $0x8010ff20
80100a44:	e8 67 39 00 00       	call   801043b0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 a8 78 10 80       	push   $0x801078a8
80100a6b:	68 40 ff 10 80       	push   $0x8010ff40
80100a70:	e8 0b 3c 00 00       	call   80104680 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 2c 09 11 80 90 	movl   $0x80100590,0x8011092c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 28 09 11 80 80 	movl   $0x80100280,0x80110928
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 74 ff 10 80 01 	movl   $0x1,0x8010ff74
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 f2 19 00 00       	call   80102490 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 cf 30 00 00       	call   80103b90 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 24 00 00       	call   80102f70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 15 00 00       	call   801020b0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 09 03 00 00    	je     80100deb <exec+0x33b>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 a3 0c 00 00       	call   80101790 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 a2 0f 00 00       	call   80101aa0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 11 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100b0f:	e8 cc 24 00 00       	call   80102fe0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 b7 69 00 00       	call   801074f0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 b3 02 00 00    	je     80100e0a <exec+0x35a>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 28 66 00 00       	call   801071d0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 02 65 00 00       	call   801070e0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 9a 0e 00 00       	call   80101aa0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 50 68 00 00       	call   80107470 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 cf 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c51:	e8 8a 23 00 00       	call   80102fe0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 69 65 00 00       	call   801071d0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 08 69 00 00       	call   80107590 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 38 3e 00 00       	call   80104b10 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 24 3e 00 00       	call   80104b10 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 63 6a 00 00       	call   80107760 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 5a 67 00 00       	call   80107470 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 f8 69 00 00       	call   80107760 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 70             	add    $0x70,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 2a 3d 00 00       	call   80104ad0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 1c             	mov    0x1c(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->hugesz = 0;
80100dca:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
  switchuvm(curproc);
80100dd1:	89 0c 24             	mov    %ecx,(%esp)
80100dd4:	e8 47 61 00 00       	call   80106f20 <switchuvm>
  freevm(oldpgdir);
80100dd9:	89 3c 24             	mov    %edi,(%esp)
80100ddc:	e8 8f 66 00 00       	call   80107470 <freevm>
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	31 c0                	xor    %eax,%eax
80100de6:	e9 31 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100deb:	e8 f0 21 00 00       	call   80102fe0 <end_op>
    cprintf("exec: fail\n");
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	68 c1 78 10 80       	push   $0x801078c1
80100df8:	e8 a3 f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100dfd:	83 c4 10             	add    $0x10,%esp
80100e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e05:	e9 12 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e0a:	be 00 20 00 00       	mov    $0x2000,%esi
80100e0f:	31 ff                	xor    %edi,%edi
80100e11:	e9 32 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e16:	66 90                	xchg   %ax,%ax
80100e18:	66 90                	xchg   %ax,%ax
80100e1a:	66 90                	xchg   %ax,%ax
80100e1c:	66 90                	xchg   %ax,%ax
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e26:	68 cd 78 10 80       	push   $0x801078cd
80100e2b:	68 80 ff 10 80       	push   $0x8010ff80
80100e30:	e8 4b 38 00 00       	call   80104680 <initlock>
}
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	c9                   	leave  
80100e39:	c3                   	ret    
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e44:	bb b4 ff 10 80       	mov    $0x8010ffb4,%ebx
{
80100e49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e4c:	68 80 ff 10 80       	push   $0x8010ff80
80100e51:	e8 fa 39 00 00       	call   80104850 <acquire>
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	eb 10                	jmp    80100e6b <filealloc+0x2b>
80100e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb 14 09 11 80    	cmp    $0x80110914,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 80 ff 10 80       	push   $0x8010ff80
80100e81:	e8 6a 39 00 00       	call   801047f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 80 ff 10 80       	push   $0x8010ff80
80100e9a:	e8 51 39 00 00       	call   801047f0 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 10             	sub    $0x10,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eba:	68 80 ff 10 80       	push   $0x8010ff80
80100ebf:	e8 8c 39 00 00       	call   80104850 <acquire>
  if(f->ref < 1)
80100ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 1a                	jle    80100ee8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ece:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ed7:	68 80 ff 10 80       	push   $0x8010ff80
80100edc:	e8 0f 39 00 00       	call   801047f0 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 d4 78 10 80       	push   $0x801078d4
80100ef0:	e8 8b f4 ff ff       	call   80100380 <panic>
80100ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 28             	sub    $0x28,%esp
80100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f0c:	68 80 ff 10 80       	push   $0x8010ff80
80100f11:	e8 3a 39 00 00       	call   80104850 <acquire>
  if(f->ref < 1)
80100f16:	8b 53 04             	mov    0x4(%ebx),%edx
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 d2                	test   %edx,%edx
80100f1e:	0f 8e a5 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f24:	83 ea 01             	sub    $0x1,%edx
80100f27:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2a:	75 44                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f2c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f30:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f33:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f44:	68 80 ff 10 80       	push   $0x8010ff80
  ff = *f;
80100f49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f4c:	e8 9f 38 00 00       	call   801047f0 <release>

  if(ff.type == FD_PIPE)
80100f51:	83 c4 10             	add    $0x10,%esp
80100f54:	83 ff 01             	cmp    $0x1,%edi
80100f57:	74 57                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f59:	83 ff 02             	cmp    $0x2,%edi
80100f5c:	74 2a                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5f                   	pop    %edi
80100f64:	5d                   	pop    %ebp
80100f65:	c3                   	ret    
80100f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 80 ff 10 80 	movl   $0x8010ff80,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 6d 38 00 00       	jmp    801047f0 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 e3 1f 00 00       	call   80102f70 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	push   -0x20(%ebp)
80100f93:	e8 28 09 00 00       	call   801018c0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 39 20 00 00       	jmp    80102fe0 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 92 27 00 00       	call   80103750 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 dc 78 10 80       	push   $0x801078dc
80100fd1:	e8 aa f3 ff ff       	call   80100380 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	push   0x10(%ebx)
80100ff5:	e8 96 07 00 00       	call   80101790 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	push   0xc(%ebp)
80100fff:	ff 73 10             	push   0x10(%ebx)
80101002:	e8 69 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	push   0x10(%ebx)
8010100b:	e8 60 08 00 00       	call   80101870 <iunlock>
    return 0;
  }
  return -1;
}
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101013:	83 c4 10             	add    $0x10,%esp
80101016:	31 c0                	xor    %eax,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	push   0x10(%ebx)
8010105a:	e8 31 07 00 00       	call   80101790 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	push   0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	push   0x10(%ebx)
80101067:	e8 34 0a 00 00       	call   80101aa0 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	89 c6                	mov    %eax,%esi
80101071:	85 c0                	test   %eax,%eax
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	push   0x10(%ebx)
8010107e:	e8 ed 07 00 00       	call   80101870 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	89 f0                	mov    %esi,%eax
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010109d:	e9 4e 28 00 00       	jmp    801038f0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 e6 78 10 80       	push   $0x801078e6
801010b7:	e8 c4 f2 ff ff       	call   80100380 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010dc:	0f 84 bd 00 00 00    	je     8010119f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 bf 00 00 00    	je     801011ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 c8 00 00 00    	jne    801011be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 30                	jg     8010112f <filewrite+0x6f>
801010ff:	e9 94 00 00 00       	jmp    80101198 <filewrite+0xd8>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 57 07 00 00       	call   80101870 <iunlock>
      end_op();
80101119:	e8 c2 1e 00 00       	call   80102fe0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp
80101124:	39 c7                	cmp    %eax,%edi
80101126:	75 5c                	jne    80101184 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101128:	01 fe                	add    %edi,%esi
    while(i < n){
8010112a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010112d:	7e 69                	jle    80101198 <filewrite+0xd8>
      int n1 = n - i;
8010112f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101132:	b8 00 06 00 00       	mov    $0x600,%eax
80101137:	29 f7                	sub    %esi,%edi
80101139:	39 c7                	cmp    %eax,%edi
8010113b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010113e:	e8 2d 1e 00 00       	call   80102f70 <begin_op>
      ilock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 73 10             	push   0x10(%ebx)
80101149:	e8 42 06 00 00       	call   80101790 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101151:	57                   	push   %edi
80101152:	ff 73 14             	push   0x14(%ebx)
80101155:	01 f0                	add    %esi,%eax
80101157:	50                   	push   %eax
80101158:	ff 73 10             	push   0x10(%ebx)
8010115b:	e8 40 0a 00 00       	call   80101ba0 <writei>
80101160:	83 c4 20             	add    $0x20,%esp
80101163:	85 c0                	test   %eax,%eax
80101165:	7f a1                	jg     80101108 <filewrite+0x48>
      iunlock(f->ip);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	ff 73 10             	push   0x10(%ebx)
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	e8 fb 06 00 00       	call   80101870 <iunlock>
      end_op();
80101175:	e8 66 1e 00 00       	call   80102fe0 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 ef 78 10 80       	push   $0x801078ef
8010118c:	e8 ef f1 ff ff       	call   80100380 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101198:	89 f0                	mov    %esi,%eax
8010119a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010119d:	74 05                	je     801011a4 <filewrite+0xe4>
8010119f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a7:	5b                   	pop    %ebx
801011a8:	5e                   	pop    %esi
801011a9:	5f                   	pop    %edi
801011aa:	5d                   	pop    %ebp
801011ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801011af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b9:	e9 32 26 00 00       	jmp    801037f0 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 f5 78 10 80       	push   $0x801078f5
801011c6:	e8 b5 f1 ff ff       	call   80100380 <panic>
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 ec 25 11 80    	add    0x801125ec,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
801011f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011f8:	83 e1 07             	and    $0x7,%ecx
801011fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101200:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101206:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101208:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010120d:	85 c1                	test   %eax,%ecx
8010120f:	74 23                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101211:	f7 d0                	not    %eax
  log_write(bp);
80101213:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101216:	21 c8                	and    %ecx,%eax
80101218:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010121c:	56                   	push   %esi
8010121d:	e8 2e 1f 00 00       	call   80103150 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 ff 78 10 80       	push   $0x801078ff
8010123c:	e8 3f f1 ff ff       	call   80100380 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d d4 25 11 80    	mov    0x801125d4,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 ec 25 11 80    	add    0x801125ec,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	push   -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 d4 25 11 80       	mov    0x801125d4,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	push   -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 d4 25 11 80    	cmp    %eax,0x801125d4
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 12 79 10 80       	push   $0x80107912
801012f9:	e8 82 f0 ff ff       	call   80100380 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 3e 1e 00 00       	call   80103150 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	push   -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 d6 35 00 00       	call   80104910 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 0e 1e 00 00       	call   80103150 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb b4 09 11 80       	mov    $0x801109b4,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 80 09 11 80       	push   $0x80110980
8010137a:	e8 d1 34 00 00       	call   80104850 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
801013b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
801013bf:	72 e1                	jb     801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 80 09 11 80       	push   $0x80110980
801013e7:	e8 04 34 00 00       	call   801047f0 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c0 01             	add    $0x1,%eax
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 80 09 11 80       	push   $0x80110980
      ip->ref++;
80101412:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 d6 33 00 00       	call   801047f0 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
80101433:	73 10                	jae    80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 28 79 10 80       	push   $0x80107928
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101460 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	89 c6                	mov    %eax,%esi
80101467:	53                   	push   %ebx
80101468:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	0f 86 8c 00 00 00    	jbe    80101500 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101474:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101477:	83 fb 7f             	cmp    $0x7f,%ebx
8010147a:	0f 87 a2 00 00 00    	ja     80101522 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101486:	85 c0                	test   %eax,%eax
80101488:	74 5e                	je     801014e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010148a:	83 ec 08             	sub    $0x8,%esp
8010148d:	50                   	push   %eax
8010148e:	ff 36                	push   (%esi)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101495:	83 c4 10             	add    $0x10,%esp
80101498:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010149c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010149e:	8b 3b                	mov    (%ebx),%edi
801014a0:	85 ff                	test   %edi,%edi
801014a2:	74 1c                	je     801014c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	52                   	push   %edx
801014a8:	e8 43 ed ff ff       	call   801001f0 <brelse>
801014ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b3:	89 f8                	mov    %edi,%eax
801014b5:	5b                   	pop    %ebx
801014b6:	5e                   	pop    %esi
801014b7:	5f                   	pop    %edi
801014b8:	5d                   	pop    %ebp
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014c3:	8b 06                	mov    (%esi),%eax
801014c5:	e8 86 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014d0:	89 03                	mov    %eax,(%ebx)
801014d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014d4:	52                   	push   %edx
801014d5:	e8 76 1c 00 00       	call   80103150 <log_write>
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 c4 10             	add    $0x10,%esp
801014e0:	eb c2                	jmp    801014a4 <bmap+0x44>
801014e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e8:	8b 06                	mov    (%esi),%eax
801014ea:	e8 61 fd ff ff       	call   80101250 <balloc>
801014ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014f5:	eb 93                	jmp    8010148a <bmap+0x2a>
801014f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101500:	8d 5a 14             	lea    0x14(%edx),%ebx
80101503:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101507:	85 ff                	test   %edi,%edi
80101509:	75 a5                	jne    801014b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010150b:	8b 00                	mov    (%eax),%eax
8010150d:	e8 3e fd ff ff       	call   80101250 <balloc>
80101512:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101516:	89 c7                	mov    %eax,%edi
}
80101518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151b:	5b                   	pop    %ebx
8010151c:	89 f8                	mov    %edi,%eax
8010151e:	5e                   	pop    %esi
8010151f:	5f                   	pop    %edi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
  panic("bmap: out of range");
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	68 38 79 10 80       	push   $0x80107938
8010152a:	e8 51 ee ff ff       	call   80100380 <panic>
8010152f:	90                   	nop

80101530 <readsb>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	6a 01                	push   $0x1
8010153d:	ff 75 08             	push   0x8(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101545:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101548:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010154a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154d:	6a 1c                	push   $0x1c
8010154f:	50                   	push   %eax
80101550:	56                   	push   %esi
80101551:	e8 5a 34 00 00       	call   801049b0 <memmove>
  brelse(bp);
80101556:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101559:	83 c4 10             	add    $0x10,%esp
}
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
  brelse(bp);
80101562:	e9 89 ec ff ff       	jmp    801001f0 <brelse>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax

80101570 <iinit>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb c0 09 11 80       	mov    $0x801109c0,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010157c:	68 4b 79 10 80       	push   $0x8010794b
80101581:	68 80 09 11 80       	push   $0x80110980
80101586:	e8 f5 30 00 00       	call   80104680 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 52 79 10 80       	push   $0x80107952
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 ac 2f 00 00       	call   80104550 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb e0 25 11 80    	cmp    $0x801125e0,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
  bp = bread(dev, 1);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	6a 01                	push   $0x1
801015b4:	ff 75 08             	push   0x8(%ebp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015c4:	6a 1c                	push   $0x1c
801015c6:	50                   	push   %eax
801015c7:	68 d4 25 11 80       	push   $0x801125d4
801015cc:	e8 df 33 00 00       	call   801049b0 <memmove>
  brelse(bp);
801015d1:	89 1c 24             	mov    %ebx,(%esp)
801015d4:	e8 17 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d9:	ff 35 ec 25 11 80    	push   0x801125ec
801015df:	ff 35 e8 25 11 80    	push   0x801125e8
801015e5:	ff 35 e4 25 11 80    	push   0x801125e4
801015eb:	ff 35 e0 25 11 80    	push   0x801125e0
801015f1:	ff 35 dc 25 11 80    	push   0x801125dc
801015f7:	ff 35 d8 25 11 80    	push   0x801125d8
801015fd:	ff 35 d4 25 11 80    	push   0x801125d4
80101603:	68 b8 79 10 80       	push   $0x801079b8
80101608:	e8 93 f0 ff ff       	call   801006a0 <cprintf>
}
8010160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101610:	83 c4 30             	add    $0x30,%esp
80101613:	c9                   	leave  
80101614:	c3                   	ret    
80101615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <ialloc>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	83 ec 1c             	sub    $0x1c,%esp
80101629:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 3d dc 25 11 80 01 	cmpl   $0x1,0x801125dc
{
80101633:	8b 75 08             	mov    0x8(%ebp),%esi
80101636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101639:	0f 86 91 00 00 00    	jbe    801016d0 <ialloc+0xb0>
8010163f:	bf 01 00 00 00       	mov    $0x1,%edi
80101644:	eb 21                	jmp    80101667 <ialloc+0x47>
80101646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101653:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101656:	53                   	push   %ebx
80101657:	e8 94 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 c4 10             	add    $0x10,%esp
8010165f:	3b 3d dc 25 11 80    	cmp    0x801125dc,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 e8 25 11 80    	add    0x801125e8,%eax
80101675:	50                   	push   %eax
80101676:	56                   	push   %esi
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010167c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010167f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101681:	89 f8                	mov    %edi,%eax
80101683:	83 e0 07             	and    $0x7,%eax
80101686:	c1 e0 06             	shl    $0x6,%eax
80101689:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010168d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101691:	75 bd                	jne    80101650 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101693:	83 ec 04             	sub    $0x4,%esp
80101696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101699:	6a 40                	push   $0x40
8010169b:	6a 00                	push   $0x0
8010169d:	51                   	push   %ecx
8010169e:	e8 6d 32 00 00       	call   80104910 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 9b 1a 00 00       	call   80103150 <log_write>
      brelse(bp);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 33 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016bd:	83 c4 10             	add    $0x10,%esp
}
801016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016c3:	89 fa                	mov    %edi,%edx
}
801016c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016c6:	89 f0                	mov    %esi,%eax
}
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801016cb:	e9 90 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 58 79 10 80       	push   $0x80107958
801016d8:	e8 a3 ec ff ff       	call   80100380 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi

801016e0 <iupdate>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ee:	83 ec 08             	sub    $0x8,%esp
801016f1:	c1 e8 03             	shr    $0x3,%eax
801016f4:	03 05 e8 25 11 80    	add    0x801125e8,%eax
801016fa:	50                   	push   %eax
801016fb:	ff 73 a4             	push   -0x5c(%ebx)
801016fe:	e8 cd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101703:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101707:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101719:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010171c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101720:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101723:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101727:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010172b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010172f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101733:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101737:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010173a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173d:	6a 34                	push   $0x34
8010173f:	53                   	push   %ebx
80101740:	50                   	push   %eax
80101741:	e8 6a 32 00 00       	call   801049b0 <memmove>
  log_write(bp);
80101746:	89 34 24             	mov    %esi,(%esp)
80101749:	e8 02 1a 00 00       	call   80103150 <log_write>
  brelse(bp);
8010174e:	89 75 08             	mov    %esi,0x8(%ebp)
80101751:	83 c4 10             	add    $0x10,%esp
}
80101754:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101757:	5b                   	pop    %ebx
80101758:	5e                   	pop    %esi
80101759:	5d                   	pop    %ebp
  brelse(bp);
8010175a:	e9 91 ea ff ff       	jmp    801001f0 <brelse>
8010175f:	90                   	nop

80101760 <idup>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	83 ec 10             	sub    $0x10,%esp
80101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010176a:	68 80 09 11 80       	push   $0x80110980
8010176f:	e8 dc 30 00 00       	call   80104850 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010177f:	e8 6c 30 00 00       	call   801047f0 <release>
}
80101784:	89 d8                	mov    %ebx,%eax
80101786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101789:	c9                   	leave  
8010178a:	c3                   	ret    
8010178b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010178f:	90                   	nop

80101790 <ilock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	0f 84 b7 00 00 00    	je     80101857 <ilock+0xc7>
801017a0:	8b 53 08             	mov    0x8(%ebx),%edx
801017a3:	85 d2                	test   %edx,%edx
801017a5:	0f 8e ac 00 00 00    	jle    80101857 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801017b1:	50                   	push   %eax
801017b2:	e8 d9 2d 00 00       	call   80104590 <acquiresleep>
  if(ip->valid == 0){
801017b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ba:	83 c4 10             	add    $0x10,%esp
801017bd:	85 c0                	test   %eax,%eax
801017bf:	74 0f                	je     801017d0 <ilock+0x40>
}
801017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c4:	5b                   	pop    %ebx
801017c5:	5e                   	pop    %esi
801017c6:	5d                   	pop    %ebp
801017c7:	c3                   	ret    
801017c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d0:	8b 43 04             	mov    0x4(%ebx),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	c1 e8 03             	shr    $0x3,%eax
801017d9:	03 05 e8 25 11 80    	add    0x801125e8,%eax
801017df:	50                   	push   %eax
801017e0:	ff 33                	push   (%ebx)
801017e2:	e8 e9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 04             	mov    0x4(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101803:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101807:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010180b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010180f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101813:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101817:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010181b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010181e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101821:	6a 34                	push   $0x34
80101823:	50                   	push   %eax
80101824:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101827:	50                   	push   %eax
80101828:	e8 83 31 00 00       	call   801049b0 <memmove>
    brelse(bp);
8010182d:	89 34 24             	mov    %esi,(%esp)
80101830:	e8 bb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101835:	83 c4 10             	add    $0x10,%esp
80101838:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010183d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101844:	0f 85 77 ff ff ff    	jne    801017c1 <ilock+0x31>
      panic("ilock: no type");
8010184a:	83 ec 0c             	sub    $0xc,%esp
8010184d:	68 70 79 10 80       	push   $0x80107970
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 6a 79 10 80       	push   $0x8010796a
8010185f:	e8 1c eb ff ff       	call   80100380 <panic>
80101864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop

80101870 <iunlock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	74 28                	je     801018a4 <iunlock+0x34>
8010187c:	83 ec 0c             	sub    $0xc,%esp
8010187f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101882:	56                   	push   %esi
80101883:	e8 a8 2d 00 00       	call   80104630 <holdingsleep>
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 c0                	test   %eax,%eax
8010188d:	74 15                	je     801018a4 <iunlock+0x34>
8010188f:	8b 43 08             	mov    0x8(%ebx),%eax
80101892:	85 c0                	test   %eax,%eax
80101894:	7e 0e                	jle    801018a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101896:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101899:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010189f:	e9 4c 2d 00 00       	jmp    801045f0 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 7f 79 10 80       	push   $0x8010797f
801018ac:	e8 cf ea ff ff       	call   80100380 <panic>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <iput>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 28             	sub    $0x28,%esp
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018cf:	57                   	push   %edi
801018d0:	e8 bb 2c 00 00       	call   80104590 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 d2                	test   %edx,%edx
801018dd:	74 07                	je     801018e6 <iput+0x26>
801018df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018e4:	74 32                	je     80101918 <iput+0x58>
  releasesleep(&ip->lock);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	57                   	push   %edi
801018ea:	e8 01 2d 00 00       	call   801045f0 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
801018f6:	e8 55 2f 00 00       	call   80104850 <acquire>
  ip->ref--;
801018fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	c7 45 08 80 09 11 80 	movl   $0x80110980,0x8(%ebp)
}
80101909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5f                   	pop    %edi
8010190f:	5d                   	pop    %ebp
  release(&icache.lock);
80101910:	e9 db 2e 00 00       	jmp    801047f0 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 80 09 11 80       	push   $0x80110980
80101920:	e8 2b 2f 00 00       	call   80104850 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010192f:	e8 bc 2e 00 00       	call   801047f0 <release>
    if(r == 1){
80101934:	83 c4 10             	add    $0x10,%esp
80101937:	83 fe 01             	cmp    $0x1,%esi
8010193a:	75 aa                	jne    801018e6 <iput+0x26>
8010193c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101942:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101945:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101948:	89 cf                	mov    %ecx,%edi
8010194a:	eb 0b                	jmp    80101957 <iput+0x97>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101950:	83 c6 04             	add    $0x4,%esi
80101953:	39 fe                	cmp    %edi,%esi
80101955:	74 19                	je     80101970 <iput+0xb0>
    if(ip->addrs[i]){
80101957:	8b 16                	mov    (%esi),%edx
80101959:	85 d2                	test   %edx,%edx
8010195b:	74 f3                	je     80101950 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010195d:	8b 03                	mov    (%ebx),%eax
8010195f:	e8 6c f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
80101964:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010196a:	eb e4                	jmp    80101950 <iput+0x90>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101970:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101976:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101979:	85 c0                	test   %eax,%eax
8010197b:	75 2d                	jne    801019aa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010197d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101980:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101987:	53                   	push   %ebx
80101988:	e8 53 fd ff ff       	call   801016e0 <iupdate>
      ip->type = 0;
8010198d:	31 c0                	xor    %eax,%eax
8010198f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101993:	89 1c 24             	mov    %ebx,(%esp)
80101996:	e8 45 fd ff ff       	call   801016e0 <iupdate>
      ip->valid = 0;
8010199b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019a2:	83 c4 10             	add    $0x10,%esp
801019a5:	e9 3c ff ff ff       	jmp    801018e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019aa:	83 ec 08             	sub    $0x8,%esp
801019ad:	50                   	push   %eax
801019ae:	ff 33                	push   (%ebx)
801019b0:	e8 1b e7 ff ff       	call   801000d0 <bread>
801019b5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c7:	89 cf                	mov    %ecx,%edi
801019c9:	eb 0c                	jmp    801019d7 <iput+0x117>
801019cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019cf:	90                   	nop
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 0f                	je     801019e6 <iput+0x126>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 ec f7 ff ff       	call   801011d0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x110>
    brelse(bp);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	ff 75 e4             	push   -0x1c(%ebp)
801019ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ef:	e8 fc e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019f4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019fa:	8b 03                	mov    (%ebx),%eax
801019fc:	e8 cf f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a01:	83 c4 10             	add    $0x10,%esp
80101a04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a0b:	00 00 00 
80101a0e:	e9 6a ff ff ff       	jmp    8010197d <iput+0xbd>
80101a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a20 <iunlockput>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 34                	je     80101a60 <iunlockput+0x40>
80101a2c:	83 ec 0c             	sub    $0xc,%esp
80101a2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a32:	56                   	push   %esi
80101a33:	e8 f8 2b 00 00       	call   80104630 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 a1 2b 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101a4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a52:	83 c4 10             	add    $0x10,%esp
}
80101a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5d                   	pop    %ebp
  iput(ip);
80101a5b:	e9 60 fe ff ff       	jmp    801018c0 <iput>
    panic("iunlock");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 7f 79 10 80       	push   $0x8010797f
80101a68:	e8 13 e9 ff ff       	call   80100380 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a79:	8b 0a                	mov    (%edx),%ecx
80101a7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a93:	8b 52 58             	mov    0x58(%edx),%edx
80101a96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a9f:	90                   	nop

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 a7 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	8b 40 58             	mov    0x58(%eax),%eax
80101acf:	39 c6                	cmp    %eax,%esi
80101ad1:	0f 87 ba 00 00 00    	ja     80101b91 <readi+0xf1>
80101ad7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ada:	31 c9                	xor    %ecx,%ecx
80101adc:	89 da                	mov    %ebx,%edx
80101ade:	01 f2                	add    %esi,%edx
80101ae0:	0f 92 c1             	setb   %cl
80101ae3:	89 cf                	mov    %ecx,%edi
80101ae5:	0f 82 a6 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aeb:	89 c1                	mov    %eax,%ecx
80101aed:	29 f1                	sub    %esi,%ecx
80101aef:	39 d0                	cmp    %edx,%eax
80101af1:	0f 43 cb             	cmovae %ebx,%ecx
80101af4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	85 c9                	test   %ecx,%ecx
80101af9:	74 67                	je     80101b62 <readi+0xc2>
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 51 f9 ff ff       	call   80101460 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	push   (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b24:	89 f0                	mov    %esi,%eax
80101b26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b36:	39 d9                	cmp    %ebx,%ecx
80101b38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3b:	83 c4 0c             	add    $0xc,%esp
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	push   -0x20(%ebp)
80101b47:	e8 64 2e 00 00       	call   801049b0 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 20 09 11 80 	mov    -0x7feef6e0(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 b7 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	0f 87 e7 00 00 00    	ja     80101cbc <writei+0x11c>
80101bd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bd8:	31 d2                	xor    %edx,%edx
80101bda:	89 f8                	mov    %edi,%eax
80101bdc:	01 f0                	add    %esi,%eax
80101bde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101be6:	0f 87 d0 00 00 00    	ja     80101cbc <writei+0x11c>
80101bec:	85 d2                	test   %edx,%edx
80101bee:	0f 85 c8 00 00 00    	jne    80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bfb:	85 ff                	test   %edi,%edi
80101bfd:	74 72                	je     80101c71 <writei+0xd1>
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 51 f8 ff ff       	call   80101460 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	push   (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c30:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c34:	39 d9                	cmp    %ebx,%ecx
80101c36:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c39:	83 c4 0c             	add    $0xc,%esp
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	push   -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 68 2d 00 00       	call   801049b0 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 00 15 00 00       	call   80103150 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 24 09 11 80 	mov    -0x7feef6dc(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 29 fa ff ff       	call   801016e0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 3d 2d 00 00       	call   80104a20 <strncmp>
}
80101ce3:	c9                   	leave  
80101ce4:	c3                   	ret    
80101ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 7e fd ff ff       	call   80101aa0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 de 2c 00 00       	call   80104a20 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret    
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 e9 f5 ff ff       	call   80101360 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret    
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 99 79 10 80       	push   $0x80107999
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 87 79 10 80       	push   $0x80107987
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 64 01 00 00    	je     80101f1e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 d1 1d 00 00       	call   80103b90 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 80 09 11 80       	push   $0x80110980
80101dca:	e8 81 2a 00 00       	call   80104850 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101dda:	e8 11 2a 00 00       	call   801047f0 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
    path++;
80101e32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 74 2b 00 00       	call   801049b0 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 37 f9 ff ff       	call   80101790 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 cd 00 00 00    	jne    80101f34 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 22 01 00 00    	je     80101f99 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	89 c7                	mov    %eax,%edi
80101e8d:	85 c0                	test   %eax,%eax
80101e8f:	0f 84 e1 00 00 00    	je     80101f76 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e9b:	52                   	push   %edx
80101e9c:	e8 8f 27 00 00       	call   80104630 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 30 01 00 00    	je     80101fdc <namex+0x23c>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e 25 01 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101eb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	52                   	push   %edx
80101ebe:	e8 2d 27 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
80101ec6:	89 fe                	mov    %edi,%esi
80101ec8:	e8 f3 f9 ff ff       	call   801018c0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101edb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 c0 2a 00 00       	call   801049b0 <memmove>
    name[len] = 0;
80101ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 02 00             	movb   $0x0,(%edx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 be 00 00 00    	jne    80101fc9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f1e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f23:	b8 01 00 00 00       	mov    $0x1,%eax
80101f28:	e8 33 f4 ff ff       	call   80101360 <iget>
80101f2d:	89 c6                	mov    %eax,%esi
80101f2f:	e9 b7 fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f3a:	53                   	push   %ebx
80101f3b:	e8 f0 26 00 00       	call   80104630 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 91 26 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101f5f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f62:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f64:	e8 57 f9 ff ff       	call   801018c0 <iput>
      return 0;
80101f69:	83 c4 10             	add    $0x10,%esp
}
80101f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6f:	89 f0                	mov    %esi,%eax
80101f71:	5b                   	pop    %ebx
80101f72:	5e                   	pop    %esi
80101f73:	5f                   	pop    %edi
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f76:	83 ec 0c             	sub    $0xc,%esp
80101f79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f7c:	52                   	push   %edx
80101f7d:	e8 ae 26 00 00       	call   80104630 <holdingsleep>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	85 c0                	test   %eax,%eax
80101f87:	74 53                	je     80101fdc <namex+0x23c>
80101f89:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f8c:	85 c9                	test   %ecx,%ecx
80101f8e:	7e 4c                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f93:	83 ec 0c             	sub    $0xc,%esp
80101f96:	52                   	push   %edx
80101f97:	eb c1                	jmp    80101f5a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9f:	53                   	push   %ebx
80101fa0:	e8 8b 26 00 00       	call   80104630 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 34 26 00 00       	call   801045f0 <releasesleep>
}
80101fbc:	83 c4 10             	add    $0x10,%esp
}
80101fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	5b                   	pop    %ebx
80101fc5:	5e                   	pop    %esi
80101fc6:	5f                   	pop    %edi
80101fc7:	5d                   	pop    %ebp
80101fc8:	c3                   	ret    
    iput(ip);
80101fc9:	83 ec 0c             	sub    $0xc,%esp
80101fcc:	56                   	push   %esi
    return 0;
80101fcd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fcf:	e8 ec f8 ff ff       	call   801018c0 <iput>
    return 0;
80101fd4:	83 c4 10             	add    $0x10,%esp
80101fd7:	e9 2f ff ff ff       	jmp    80101f0b <namex+0x16b>
    panic("iunlock");
80101fdc:	83 ec 0c             	sub    $0xc,%esp
80101fdf:	68 7f 79 10 80       	push   $0x8010797f
80101fe4:	e8 97 e3 ff ff       	call   80100380 <panic>
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 e9 fc ff ff       	call   80101cf0 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 6e fa ff ff       	call   80101aa0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 1e 2a 00 00       	call   80104a70 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102052:	6a 10                	push   $0x10
  de.inum = inum;
80102054:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
  de.inum = inum;
8010205a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010205e:	e8 3d fb ff ff       	call   80101ba0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret    
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 42 f8 ff ff       	call   801018c0 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 a8 79 10 80       	push   $0x801079a8
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 8a 7f 10 80       	push   $0x80107f8a
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 dd fc ff ff       	call   80101da0 <namex>
}
801020c3:	c9                   	leave  
801020c4:	c3                   	ret    
801020c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 bc fc ff ff       	jmp    80101da0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211e:	66 90                	xchg   %ax,%ax
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret    
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld    
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret    
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 14 7a 10 80       	push   $0x80107a14
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 0b 7a 10 80       	push   $0x80107a0b
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 26 7a 10 80       	push   $0x80107a26
801021db:	68 20 26 11 80       	push   $0x80112620
801021e0:	e8 9b 24 00 00       	call   80104680 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 a4 27 11 80       	mov    0x801127a4,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 20 26 11 80       	push   $0x80112620
8010225e:	e8 ed 25 00 00       	call   80104850 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d 04 26 11 80    	mov    0x80112604,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 63                	je     801022d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 04 26 11 80       	mov    %eax,0x80112604

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 33                	mov    (%ebx),%esi
8010227a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102280:	75 2f                	jne    801022b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 12                	jne    801022b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld    
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b7:	83 ce 02             	or     $0x2,%esi
801022ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022bc:	53                   	push   %ebx
801022bd:	e8 ee 20 00 00       	call   801043b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c2:	a1 04 26 11 80       	mov    0x80112604,%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	74 05                	je     801022d3 <ideintr+0x83>
    idestart(idequeue);
801022ce:	e8 1d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	68 20 26 11 80       	push   $0x80112620
801022db:	e8 10 25 00 00       	call   801047f0 <release>

  release(&idelock);
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret    
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 2d 23 00 00       	call   80104630 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c3 00 00 00    	je     801023d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 a8 00 00 00    	je     801023c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 00 26 11 80       	mov    0x80112600,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 87 00 00 00    	je     801023b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 20 26 11 80       	push   $0x80112620
80102338:	e8 13 25 00 00       	call   80104850 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	a1 04 26 11 80       	mov    0x80112604,%eax
  b->qnext = 0;
80102342:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 c0                	test   %eax,%eax
8010234e:	74 60                	je     801023b0 <iderw+0xc0>
80102350:	89 c2                	mov    %eax,%edx
80102352:	8b 40 58             	mov    0x58(%eax),%eax
80102355:	85 c0                	test   %eax,%eax
80102357:	75 f7                	jne    80102350 <iderw+0x60>
80102359:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010235c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010235e:	39 1d 04 26 11 80    	cmp    %ebx,0x80112604
80102364:	74 3a                	je     801023a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102366:	8b 03                	mov    (%ebx),%eax
80102368:	83 e0 06             	and    $0x6,%eax
8010236b:	83 f8 02             	cmp    $0x2,%eax
8010236e:	74 1b                	je     8010238b <iderw+0x9b>
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 20 26 11 80       	push   $0x80112620
80102378:	53                   	push   %ebx
80102379:	e8 72 1f 00 00       	call   801042f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x80>
  }


  release(&idelock);
8010238b:	c7 45 08 20 26 11 80 	movl   $0x80112620,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave  
  release(&idelock);
80102396:	e9 55 24 00 00       	jmp    801047f0 <release>
8010239b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 49 fd ff ff       	call   801020f0 <idestart>
801023a7:	eb bd                	jmp    80102366 <iderw+0x76>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba 04 26 11 80       	mov    $0x80112604,%edx
801023b5:	eb a5                	jmp    8010235c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 55 7a 10 80       	push   $0x80107a55
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 40 7a 10 80       	push   $0x80107a40
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 2a 7a 10 80       	push   $0x80107a2a
801023d9:	e8 a2 df ff ff       	call   80100380 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801023e8:	00 c0 fe 
{
801023eb:	89 e5                	mov    %esp,%ebp
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801023ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102402:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102408:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240e:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102415:	c1 ee 10             	shr    $0x10,%esi
80102418:	89 f0                	mov    %esi,%eax
8010241a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010241d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102420:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102423:	39 c2                	cmp    %eax,%edx
80102425:	74 16                	je     8010243d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 74 7a 10 80       	push   $0x80107a74
8010242f:	e8 6c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102434:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010243a:	83 c4 10             	add    $0x10,%esp
8010243d:	83 c6 21             	add    $0x21,%esi
{
80102440:	ba 10 00 00 00       	mov    $0x10,%edx
80102445:	b8 20 00 00 00       	mov    $0x20,%eax
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102452:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102454:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  for(i = 0; i <= maxintr; i++){
8010245a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010245d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102463:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102466:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102469:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010246c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010246e:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102474:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247b:	39 f0                	cmp    %esi,%eax
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret    
80102486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248d:	8d 76 00             	lea    0x0(%esi),%esi

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
//  Free the page of physical memory pointed at by v,
//  which normally should have been returned by a
//  call to kalloc().  (The exception is when
//  initializing the allocator; see kinit above.)
void kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb f0 65 11 80    	cmp    $0x801165f0,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 09 24 00 00       	call   80104910 <memset>

  if (kmem.use_lock)
80102507:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
80102514:	a1 98 26 11 80       	mov    0x80112698,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if (kmem.use_lock)
8010251b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102520:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if (kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave  
8010252e:	c3                   	ret    
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 60 26 11 80       	push   $0x80112660
80102538:	e8 13 23 00 00       	call   80104850 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 98 22 00 00       	jmp    801047f0 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 a6 7a 10 80       	push   $0x80107aa6
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
  p = (char *)PGROUNDUP((uint)vstart);
80102574:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102577:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257a:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char *)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    
80102615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 ac 7a 10 80       	push   $0x80107aac
80102630:	68 60 26 11 80       	push   $0x80112660
80102635:	e8 46 20 00 00       	call   80104680 <initlock>
  p = (char *)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102647:	00 00 00 
  p = (char *)PGROUNDUP((uint)vstart);
8010264a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265c:	39 de                	cmp    %ebx,%esi
8010265e:	72 1c                	jb     8010267c <kinit1+0x5c>
    kfree(p);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010266f:	50                   	push   %eax
80102670:	e8 5b fe ff ff       	call   801024d0 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	39 de                	cmp    %ebx,%esi
8010267a:	73 e4                	jae    80102660 <kinit1+0x40>
}
8010267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010267f:	5b                   	pop    %ebx
80102680:	5e                   	pop    %esi
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102690 <khugefree>:
// part 1
// I basically just copy-pasted kfree() and replaced every PGSIZE with HUGE_PAGE_SIZE
// also replaced PHYSTOP with HUGE_PAGE_END
// ? also replaced end with HUGE_PAGE_START (???) this might not be correct
void khugefree(char *v)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	53                   	push   %ebx
80102694:	83 ec 04             	sub    $0x4,%esp
80102697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if ((uint)v % HUGE_PAGE_SIZE || V2P(v) < HUGE_PAGE_START || V2P(v) >= HUGE_PAGE_END)
8010269a:	f7 c3 ff ff 3f 00    	test   $0x3fffff,%ebx
801026a0:	75 76                	jne    80102718 <khugefree+0x88>
801026a2:	8d 83 00 00 00 62    	lea    0x62000000(%ebx),%eax
801026a8:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
801026ad:	77 69                	ja     80102718 <khugefree+0x88>
    panic("khugefree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, HUGE_PAGE_SIZE);
801026af:	83 ec 04             	sub    $0x4,%esp
801026b2:	68 00 00 40 00       	push   $0x400000
801026b7:	6a 01                	push   $0x1
801026b9:	53                   	push   %ebx
801026ba:	e8 51 22 00 00       	call   80104910 <memset>

  if (kmem.use_lock)
801026bf:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	85 d2                	test   %edx,%edx
801026ca:	75 24                	jne    801026f0 <khugefree+0x60>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freehugelist;
801026cc:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026d1:	89 03                	mov    %eax,(%ebx)
  kmem.freehugelist = r;
  if (kmem.use_lock)
801026d3:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freehugelist = r;
801026d8:	89 1d 9c 26 11 80    	mov    %ebx,0x8011269c
  if (kmem.use_lock)
801026de:	85 c0                	test   %eax,%eax
801026e0:	75 26                	jne    80102708 <khugefree+0x78>
    release(&kmem.lock);
}
801026e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026e5:	c9                   	leave  
801026e6:	c3                   	ret    
801026e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ee:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	68 60 26 11 80       	push   $0x80112660
801026f8:	e8 53 21 00 00       	call   80104850 <acquire>
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	eb ca                	jmp    801026cc <khugefree+0x3c>
80102702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102708:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010270f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102712:	c9                   	leave  
    release(&kmem.lock);
80102713:	e9 d8 20 00 00       	jmp    801047f0 <release>
    panic("khugefree");
80102718:	83 ec 0c             	sub    $0xc,%esp
8010271b:	68 b1 7a 10 80       	push   $0x80107ab1
80102720:	e8 5b dc ff ff       	call   80100380 <panic>
80102725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102730 <freehugerange>:
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	56                   	push   %esi
  p = (char *)HUGEPGROUNDUP((uint)vstart);
80102734:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102737:	8b 75 0c             	mov    0xc(%ebp),%esi
8010273a:	53                   	push   %ebx
  p = (char *)HUGEPGROUNDUP((uint)vstart);
8010273b:	8d 98 ff ff 3f 00    	lea    0x3fffff(%eax),%ebx
80102741:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
80102747:	81 c3 00 00 40 00    	add    $0x400000,%ebx
8010274d:	39 de                	cmp    %ebx,%esi
8010274f:	72 23                	jb     80102774 <freehugerange+0x44>
80102751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    khugefree(p);
80102758:	83 ec 0c             	sub    $0xc,%esp
8010275b:	8d 83 00 00 c0 ff    	lea    -0x400000(%ebx),%eax
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
80102761:	81 c3 00 00 40 00    	add    $0x400000,%ebx
    khugefree(p);
80102767:	50                   	push   %eax
80102768:	e8 23 ff ff ff       	call   80102690 <khugefree>
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	39 f3                	cmp    %esi,%ebx
80102772:	76 e4                	jbe    80102758 <freehugerange+0x28>
}
80102774:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102777:	5b                   	pop    %ebx
80102778:	5e                   	pop    %esi
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop

80102780 <khugeinit>:
{
80102780:	55                   	push   %ebp
  if (kmem.use_lock)
80102781:	8b 15 94 26 11 80    	mov    0x80112694,%edx
{
80102787:	89 e5                	mov    %esp,%ebp
80102789:	56                   	push   %esi
  p = (char *)HUGEPGROUNDUP((uint)vstart);
8010278a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010278d:	8b 75 0c             	mov    0xc(%ebp),%esi
80102790:	53                   	push   %ebx
  p = (char *)HUGEPGROUNDUP((uint)vstart);
80102791:	8d 98 ff ff 3f 00    	lea    0x3fffff(%eax),%ebx
80102797:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
8010279d:	81 c3 00 00 40 00    	add    $0x400000,%ebx
  if (kmem.use_lock)
801027a3:	85 d2                	test   %edx,%edx
801027a5:	75 39                	jne    801027e0 <khugeinit+0x60>
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027a7:	39 de                	cmp    %ebx,%esi
801027a9:	72 2a                	jb     801027d5 <khugeinit+0x55>
801027ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027af:	90                   	nop
    khugefree(p);
801027b0:	83 ec 0c             	sub    $0xc,%esp
801027b3:	8d 83 00 00 c0 ff    	lea    -0x400000(%ebx),%eax
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027b9:	81 c3 00 00 40 00    	add    $0x400000,%ebx
    khugefree(p);
801027bf:	50                   	push   %eax
801027c0:	e8 cb fe ff ff       	call   80102690 <khugefree>
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027c5:	83 c4 10             	add    $0x10,%esp
801027c8:	39 de                	cmp    %ebx,%esi
801027ca:	73 e4                	jae    801027b0 <khugeinit+0x30>
  if (kmem.use_lock)
801027cc:	a1 94 26 11 80       	mov    0x80112694,%eax
801027d1:	85 c0                	test   %eax,%eax
801027d3:	75 2b                	jne    80102800 <khugeinit+0x80>
}
801027d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027d8:	5b                   	pop    %ebx
801027d9:	5e                   	pop    %esi
801027da:	5d                   	pop    %ebp
801027db:	c3                   	ret    
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	68 60 26 11 80       	push   $0x80112660
801027e8:	e8 63 20 00 00       	call   80104850 <acquire>
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027ed:	83 c4 10             	add    $0x10,%esp
801027f0:	39 de                	cmp    %ebx,%esi
801027f2:	73 bc                	jae    801027b0 <khugeinit+0x30>
801027f4:	eb d6                	jmp    801027cc <khugeinit+0x4c>
801027f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027fd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102800:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102807:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010280a:	5b                   	pop    %ebx
8010280b:	5e                   	pop    %esi
8010280c:	5d                   	pop    %ebp
    release(&kmem.lock);
8010280d:	e9 de 1f 00 00       	jmp    801047f0 <release>
80102812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102820 <kalloc>:
char *
kalloc(void)
{
  struct run *r;

  if (kmem.use_lock)
80102820:	a1 94 26 11 80       	mov    0x80112694,%eax
80102825:	85 c0                	test   %eax,%eax
80102827:	75 1f                	jne    80102848 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102829:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (r)
8010282e:	85 c0                	test   %eax,%eax
80102830:	74 0e                	je     80102840 <kalloc+0x20>
    kmem.freelist = r->next;
80102832:	8b 10                	mov    (%eax),%edx
80102834:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if (kmem.use_lock)
8010283a:	c3                   	ret    
8010283b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010283f:	90                   	nop
    release(&kmem.lock);
  return (char *)r;
}
80102840:	c3                   	ret    
80102841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102848:	55                   	push   %ebp
80102849:	89 e5                	mov    %esp,%ebp
8010284b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010284e:	68 60 26 11 80       	push   $0x80112660
80102853:	e8 f8 1f 00 00       	call   80104850 <acquire>
  r = kmem.freelist;
80102858:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (kmem.use_lock)
8010285d:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if (r)
80102863:	83 c4 10             	add    $0x10,%esp
80102866:	85 c0                	test   %eax,%eax
80102868:	74 08                	je     80102872 <kalloc+0x52>
    kmem.freelist = r->next;
8010286a:	8b 08                	mov    (%eax),%ecx
8010286c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if (kmem.use_lock)
80102872:	85 d2                	test   %edx,%edx
80102874:	74 16                	je     8010288c <kalloc+0x6c>
    release(&kmem.lock);
80102876:	83 ec 0c             	sub    $0xc,%esp
80102879:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010287c:	68 60 26 11 80       	push   $0x80112660
80102881:	e8 6a 1f 00 00       	call   801047f0 <release>
  return (char *)r;
80102886:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102889:	83 c4 10             	add    $0x10,%esp
}
8010288c:	c9                   	leave  
8010288d:	c3                   	ret    
8010288e:	66 90                	xchg   %ax,%ax

80102890 <khugealloc>:
{
  struct run *r;
  
  //r = (struct run *)HUGE_VA_OFFSET;
  
  if (kmem.use_lock)
80102890:	a1 94 26 11 80       	mov    0x80112694,%eax
80102895:	85 c0                	test   %eax,%eax
80102897:	75 1f                	jne    801028b8 <khugealloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freehugelist;
80102899:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  if (r)
8010289e:	85 c0                	test   %eax,%eax
801028a0:	74 0e                	je     801028b0 <khugealloc+0x20>
    kmem.freehugelist = r->next;
801028a2:	8b 10                	mov    (%eax),%edx
801028a4:	89 15 9c 26 11 80    	mov    %edx,0x8011269c
  if (kmem.use_lock)
801028aa:	c3                   	ret    
801028ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop
    release(&kmem.lock);

  return (char *)r;
}
801028b0:	c3                   	ret    
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801028b8:	55                   	push   %ebp
801028b9:	89 e5                	mov    %esp,%ebp
801028bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801028be:	68 60 26 11 80       	push   $0x80112660
801028c3:	e8 88 1f 00 00       	call   80104850 <acquire>
  r = kmem.freehugelist;
801028c8:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  if (kmem.use_lock)
801028cd:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if (r)
801028d3:	83 c4 10             	add    $0x10,%esp
801028d6:	85 c0                	test   %eax,%eax
801028d8:	74 08                	je     801028e2 <khugealloc+0x52>
    kmem.freehugelist = r->next;
801028da:	8b 08                	mov    (%eax),%ecx
801028dc:	89 0d 9c 26 11 80    	mov    %ecx,0x8011269c
  if (kmem.use_lock)
801028e2:	85 d2                	test   %edx,%edx
801028e4:	74 16                	je     801028fc <khugealloc+0x6c>
    release(&kmem.lock);
801028e6:	83 ec 0c             	sub    $0xc,%esp
801028e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028ec:	68 60 26 11 80       	push   $0x80112660
801028f1:	e8 fa 1e 00 00       	call   801047f0 <release>
  return (char *)r;
801028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028f9:	83 c4 10             	add    $0x10,%esp
}
801028fc:	c9                   	leave  
801028fd:	c3                   	ret    
801028fe:	66 90                	xchg   %ax,%ax

80102900 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102900:	ba 64 00 00 00       	mov    $0x64,%edx
80102905:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102906:	a8 01                	test   $0x1,%al
80102908:	0f 84 c2 00 00 00    	je     801029d0 <kbdgetc+0xd0>
{
8010290e:	55                   	push   %ebp
8010290f:	ba 60 00 00 00       	mov    $0x60,%edx
80102914:	89 e5                	mov    %esp,%ebp
80102916:	53                   	push   %ebx
80102917:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102918:	8b 1d a0 26 11 80    	mov    0x801126a0,%ebx
  data = inb(KBDATAP);
8010291e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102921:	3c e0                	cmp    $0xe0,%al
80102923:	74 5b                	je     80102980 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102925:	89 da                	mov    %ebx,%edx
80102927:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010292a:	84 c0                	test   %al,%al
8010292c:	78 62                	js     80102990 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010292e:	85 d2                	test   %edx,%edx
80102930:	74 09                	je     8010293b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102932:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102935:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102938:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010293b:	0f b6 91 e0 7b 10 80 	movzbl -0x7fef8420(%ecx),%edx
  shift ^= togglecode[data];
80102942:	0f b6 81 e0 7a 10 80 	movzbl -0x7fef8520(%ecx),%eax
  shift |= shiftcode[data];
80102949:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010294b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010294d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010294f:	89 15 a0 26 11 80    	mov    %edx,0x801126a0
  c = charcode[shift & (CTL | SHIFT)][data];
80102955:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102958:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010295b:	8b 04 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%eax
80102962:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102966:	74 0b                	je     80102973 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102968:	8d 50 9f             	lea    -0x61(%eax),%edx
8010296b:	83 fa 19             	cmp    $0x19,%edx
8010296e:	77 48                	ja     801029b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102970:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102976:	c9                   	leave  
80102977:	c3                   	ret    
80102978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297f:	90                   	nop
    shift |= E0ESC;
80102980:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102983:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102985:	89 1d a0 26 11 80    	mov    %ebx,0x801126a0
}
8010298b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010298e:	c9                   	leave  
8010298f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102990:	83 e0 7f             	and    $0x7f,%eax
80102993:	85 d2                	test   %edx,%edx
80102995:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102998:	0f b6 81 e0 7b 10 80 	movzbl -0x7fef8420(%ecx),%eax
8010299f:	83 c8 40             	or     $0x40,%eax
801029a2:	0f b6 c0             	movzbl %al,%eax
801029a5:	f7 d0                	not    %eax
801029a7:	21 d8                	and    %ebx,%eax
}
801029a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801029ac:	a3 a0 26 11 80       	mov    %eax,0x801126a0
    return 0;
801029b1:	31 c0                	xor    %eax,%eax
}
801029b3:	c9                   	leave  
801029b4:	c3                   	ret    
801029b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801029b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801029be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029c1:	c9                   	leave  
      c += 'a' - 'A';
801029c2:	83 f9 1a             	cmp    $0x1a,%ecx
801029c5:	0f 42 c2             	cmovb  %edx,%eax
}
801029c8:	c3                   	ret    
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029d5:	c3                   	ret    
801029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029dd:	8d 76 00             	lea    0x0(%esi),%esi

801029e0 <kbdintr>:

void
kbdintr(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
801029e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029e6:	68 00 29 10 80       	push   $0x80102900
801029eb:	e8 90 de ff ff       	call   80100880 <consoleintr>
}
801029f0:	83 c4 10             	add    $0x10,%esp
801029f3:	c9                   	leave  
801029f4:	c3                   	ret    
801029f5:	66 90                	xchg   %ax,%ax
801029f7:	66 90                	xchg   %ax,%ax
801029f9:	66 90                	xchg   %ax,%ax
801029fb:	66 90                	xchg   %ax,%ax
801029fd:	66 90                	xchg   %ax,%ax
801029ff:	90                   	nop

80102a00 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a00:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	0f 84 cb 00 00 00    	je     80102ad8 <lapicinit+0xd8>
  lapic[index] = value;
80102a0d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a14:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a1a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a21:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a24:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a27:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a2e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a31:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a34:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a3b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a41:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a48:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a55:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a58:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a5b:	8b 50 30             	mov    0x30(%eax),%edx
80102a5e:	c1 ea 10             	shr    $0x10,%edx
80102a61:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a67:	75 77                	jne    80102ae0 <lapicinit+0xe0>
  lapic[index] = value;
80102a69:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a73:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a76:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a7d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a80:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a83:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a90:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a97:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102aa4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aaa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ab1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab4:	8b 50 20             	mov    0x20(%eax),%edx
80102ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ac0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ac6:	80 e6 10             	and    $0x10,%dh
80102ac9:	75 f5                	jne    80102ac0 <lapicinit+0xc0>
  lapic[index] = value;
80102acb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ad2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ad8:	c3                   	ret    
80102ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ae0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ae7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aea:	8b 50 20             	mov    0x20(%eax),%edx
}
80102aed:	e9 77 ff ff ff       	jmp    80102a69 <lapicinit+0x69>
80102af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b00:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102b05:	85 c0                	test   %eax,%eax
80102b07:	74 07                	je     80102b10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102b09:	8b 40 20             	mov    0x20(%eax),%eax
80102b0c:	c1 e8 18             	shr    $0x18,%eax
80102b0f:	c3                   	ret    
    return 0;
80102b10:	31 c0                	xor    %eax,%eax
}
80102b12:	c3                   	ret    
80102b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b20:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102b25:	85 c0                	test   %eax,%eax
80102b27:	74 0d                	je     80102b36 <lapiceoi+0x16>
  lapic[index] = value;
80102b29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b36:	c3                   	ret    
80102b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3e:	66 90                	xchg   %ax,%ax

80102b40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b40:	c3                   	ret    
80102b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b4f:	90                   	nop

80102b50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b56:	ba 70 00 00 00       	mov    $0x70,%edx
80102b5b:	89 e5                	mov    %esp,%ebp
80102b5d:	53                   	push   %ebx
80102b5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b64:	ee                   	out    %al,(%dx)
80102b65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b8e:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102b93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ba3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ba9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102bb0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bb6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bbc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bbf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bc8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bd7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102bda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bdd:	c9                   	leave  
80102bde:	c3                   	ret    
80102bdf:	90                   	nop

80102be0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102be0:	55                   	push   %ebp
80102be1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102be6:	ba 70 00 00 00       	mov    $0x70,%edx
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	57                   	push   %edi
80102bee:	56                   	push   %esi
80102bef:	53                   	push   %ebx
80102bf0:	83 ec 4c             	sub    $0x4c,%esp
80102bf3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bf9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bfa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bfd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c05:	8d 76 00             	lea    0x0(%esi),%esi
80102c08:	31 c0                	xor    %eax,%eax
80102c0a:	89 da                	mov    %ebx,%edx
80102c0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c12:	89 ca                	mov    %ecx,%edx
80102c14:	ec                   	in     (%dx),%al
80102c15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c18:	89 da                	mov    %ebx,%edx
80102c1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c20:	89 ca                	mov    %ecx,%edx
80102c22:	ec                   	in     (%dx),%al
80102c23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c26:	89 da                	mov    %ebx,%edx
80102c28:	b8 04 00 00 00       	mov    $0x4,%eax
80102c2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2e:	89 ca                	mov    %ecx,%edx
80102c30:	ec                   	in     (%dx),%al
80102c31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c34:	89 da                	mov    %ebx,%edx
80102c36:	b8 07 00 00 00       	mov    $0x7,%eax
80102c3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
80102c3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 da                	mov    %ebx,%edx
80102c44:	b8 08 00 00 00       	mov    $0x8,%eax
80102c49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4a:	89 ca                	mov    %ecx,%edx
80102c4c:	ec                   	in     (%dx),%al
80102c4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4f:	89 da                	mov    %ebx,%edx
80102c51:	b8 09 00 00 00       	mov    $0x9,%eax
80102c56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c57:	89 ca                	mov    %ecx,%edx
80102c59:	ec                   	in     (%dx),%al
80102c5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5c:	89 da                	mov    %ebx,%edx
80102c5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c64:	89 ca                	mov    %ecx,%edx
80102c66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c67:	84 c0                	test   %al,%al
80102c69:	78 9d                	js     80102c08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c6f:	89 fa                	mov    %edi,%edx
80102c71:	0f b6 fa             	movzbl %dl,%edi
80102c74:	89 f2                	mov    %esi,%edx
80102c76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c80:	89 da                	mov    %ebx,%edx
80102c82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c99:	31 c0                	xor    %eax,%eax
80102c9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9c:	89 ca                	mov    %ecx,%edx
80102c9e:	ec                   	in     (%dx),%al
80102c9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca2:	89 da                	mov    %ebx,%edx
80102ca4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ca7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cad:	89 ca                	mov    %ecx,%edx
80102caf:	ec                   	in     (%dx),%al
80102cb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb3:	89 da                	mov    %ebx,%edx
80102cb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbe:	89 ca                	mov    %ecx,%edx
80102cc0:	ec                   	in     (%dx),%al
80102cc1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc4:	89 da                	mov    %ebx,%edx
80102cc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccf:	89 ca                	mov    %ecx,%edx
80102cd1:	ec                   	in     (%dx),%al
80102cd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd5:	89 da                	mov    %ebx,%edx
80102cd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cda:	b8 08 00 00 00       	mov    $0x8,%eax
80102cdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce0:	89 ca                	mov    %ecx,%edx
80102ce2:	ec                   	in     (%dx),%al
80102ce3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce6:	89 da                	mov    %ebx,%edx
80102ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ceb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cf0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf1:	89 ca                	mov    %ecx,%edx
80102cf3:	ec                   	in     (%dx),%al
80102cf4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cf7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cfd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d00:	6a 18                	push   $0x18
80102d02:	50                   	push   %eax
80102d03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d06:	50                   	push   %eax
80102d07:	e8 54 1c 00 00       	call   80104960 <memcmp>
80102d0c:	83 c4 10             	add    $0x10,%esp
80102d0f:	85 c0                	test   %eax,%eax
80102d11:	0f 85 f1 fe ff ff    	jne    80102c08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d1b:	75 78                	jne    80102d95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d20:	89 c2                	mov    %eax,%edx
80102d22:	83 e0 0f             	and    $0xf,%eax
80102d25:	c1 ea 04             	shr    $0x4,%edx
80102d28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d34:	89 c2                	mov    %eax,%edx
80102d36:	83 e0 0f             	and    $0xf,%eax
80102d39:	c1 ea 04             	shr    $0x4,%edx
80102d3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d48:	89 c2                	mov    %eax,%edx
80102d4a:	83 e0 0f             	and    $0xf,%eax
80102d4d:	c1 ea 04             	shr    $0x4,%edx
80102d50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d5c:	89 c2                	mov    %eax,%edx
80102d5e:	83 e0 0f             	and    $0xf,%eax
80102d61:	c1 ea 04             	shr    $0x4,%edx
80102d64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d70:	89 c2                	mov    %eax,%edx
80102d72:	83 e0 0f             	and    $0xf,%eax
80102d75:	c1 ea 04             	shr    $0x4,%edx
80102d78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d84:	89 c2                	mov    %eax,%edx
80102d86:	83 e0 0f             	and    $0xf,%eax
80102d89:	c1 ea 04             	shr    $0x4,%edx
80102d8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d95:	8b 75 08             	mov    0x8(%ebp),%esi
80102d98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d9b:	89 06                	mov    %eax,(%esi)
80102d9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102da0:	89 46 04             	mov    %eax,0x4(%esi)
80102da3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102da6:	89 46 08             	mov    %eax,0x8(%esi)
80102da9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dac:	89 46 0c             	mov    %eax,0xc(%esi)
80102daf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102db2:	89 46 10             	mov    %eax,0x10(%esi)
80102db5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102db8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102dbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc5:	5b                   	pop    %ebx
80102dc6:	5e                   	pop    %esi
80102dc7:	5f                   	pop    %edi
80102dc8:	5d                   	pop    %ebp
80102dc9:	c3                   	ret    
80102dca:	66 90                	xchg   %ax,%ax
80102dcc:	66 90                	xchg   %ax,%ax
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dd0:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102dd6:	85 c9                	test   %ecx,%ecx
80102dd8:	0f 8e 8a 00 00 00    	jle    80102e68 <install_trans+0x98>
{
80102dde:	55                   	push   %ebp
80102ddf:	89 e5                	mov    %esp,%ebp
80102de1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102de2:	31 ff                	xor    %edi,%edi
{
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102df0:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102df5:	83 ec 08             	sub    $0x8,%esp
80102df8:	01 f8                	add    %edi,%eax
80102dfa:	83 c0 01             	add    $0x1,%eax
80102dfd:	50                   	push   %eax
80102dfe:	ff 35 04 27 11 80    	push   0x80112704
80102e04:	e8 c7 d2 ff ff       	call   801000d0 <bread>
80102e09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e0b:	58                   	pop    %eax
80102e0c:	5a                   	pop    %edx
80102e0d:	ff 34 bd 0c 27 11 80 	push   -0x7feed8f4(,%edi,4)
80102e14:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102e1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e1d:	e8 ae d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e2a:	68 00 02 00 00       	push   $0x200
80102e2f:	50                   	push   %eax
80102e30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e33:	50                   	push   %eax
80102e34:	e8 77 1b 00 00       	call   801049b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e39:	89 1c 24             	mov    %ebx,(%esp)
80102e3c:	e8 6f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e41:	89 34 24             	mov    %esi,(%esp)
80102e44:	e8 a7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e49:	89 1c 24             	mov    %ebx,(%esp)
80102e4c:	e8 9f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e51:	83 c4 10             	add    $0x10,%esp
80102e54:	39 3d 08 27 11 80    	cmp    %edi,0x80112708
80102e5a:	7f 94                	jg     80102df0 <install_trans+0x20>
  }
}
80102e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e5f:	5b                   	pop    %ebx
80102e60:	5e                   	pop    %esi
80102e61:	5f                   	pop    %edi
80102e62:	5d                   	pop    %ebp
80102e63:	c3                   	ret    
80102e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e68:	c3                   	ret    
80102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e77:	ff 35 f4 26 11 80    	push   0x801126f4
80102e7d:	ff 35 04 27 11 80    	push   0x80112704
80102e83:	e8 48 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e8d:	a1 08 27 11 80       	mov    0x80112708,%eax
80102e92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e95:	85 c0                	test   %eax,%eax
80102e97:	7e 19                	jle    80102eb2 <write_head+0x42>
80102e99:	31 d2                	xor    %edx,%edx
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ea0:	8b 0c 95 0c 27 11 80 	mov    -0x7feed8f4(,%edx,4),%ecx
80102ea7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102eab:	83 c2 01             	add    $0x1,%edx
80102eae:	39 d0                	cmp    %edx,%eax
80102eb0:	75 ee                	jne    80102ea0 <write_head+0x30>
  }
  bwrite(buf);
80102eb2:	83 ec 0c             	sub    $0xc,%esp
80102eb5:	53                   	push   %ebx
80102eb6:	e8 f5 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ebb:	89 1c 24             	mov    %ebx,(%esp)
80102ebe:	e8 2d d3 ff ff       	call   801001f0 <brelse>
}
80102ec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ec6:	83 c4 10             	add    $0x10,%esp
80102ec9:	c9                   	leave  
80102eca:	c3                   	ret    
80102ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ecf:	90                   	nop

80102ed0 <initlog>:
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 2c             	sub    $0x2c,%esp
80102ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eda:	68 e0 7c 10 80       	push   $0x80107ce0
80102edf:	68 c0 26 11 80       	push   $0x801126c0
80102ee4:	e8 97 17 00 00       	call   80104680 <initlock>
  readsb(dev, &sb);
80102ee9:	58                   	pop    %eax
80102eea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102eed:	5a                   	pop    %edx
80102eee:	50                   	push   %eax
80102eef:	53                   	push   %ebx
80102ef0:	e8 3b e6 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ef8:	59                   	pop    %ecx
  log.dev = dev;
80102ef9:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
80102eff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f02:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  log.size = sb.nlog;
80102f07:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  struct buf *buf = bread(log.dev, log.start);
80102f0d:	5a                   	pop    %edx
80102f0e:	50                   	push   %eax
80102f0f:	53                   	push   %ebx
80102f10:	e8 bb d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102f15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102f18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102f1b:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
80102f21:	85 db                	test   %ebx,%ebx
80102f23:	7e 1d                	jle    80102f42 <initlog+0x72>
80102f25:	31 d2                	xor    %edx,%edx
80102f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102f34:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f3b:	83 c2 01             	add    $0x1,%edx
80102f3e:	39 d3                	cmp    %edx,%ebx
80102f40:	75 ee                	jne    80102f30 <initlog+0x60>
  brelse(buf);
80102f42:	83 ec 0c             	sub    $0xc,%esp
80102f45:	50                   	push   %eax
80102f46:	e8 a5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f4b:	e8 80 fe ff ff       	call   80102dd0 <install_trans>
  log.lh.n = 0;
80102f50:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102f57:	00 00 00 
  write_head(); // clear the log
80102f5a:	e8 11 ff ff ff       	call   80102e70 <write_head>
}
80102f5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f62:	83 c4 10             	add    $0x10,%esp
80102f65:	c9                   	leave  
80102f66:	c3                   	ret    
80102f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f76:	68 c0 26 11 80       	push   $0x801126c0
80102f7b:	e8 d0 18 00 00       	call   80104850 <acquire>
80102f80:	83 c4 10             	add    $0x10,%esp
80102f83:	eb 18                	jmp    80102f9d <begin_op+0x2d>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f88:	83 ec 08             	sub    $0x8,%esp
80102f8b:	68 c0 26 11 80       	push   $0x801126c0
80102f90:	68 c0 26 11 80       	push   $0x801126c0
80102f95:	e8 56 13 00 00       	call   801042f0 <sleep>
80102f9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f9d:	a1 00 27 11 80       	mov    0x80112700,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	75 e2                	jne    80102f88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fa6:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102fab:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102fb1:	83 c0 01             	add    $0x1,%eax
80102fb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fba:	83 fa 1e             	cmp    $0x1e,%edx
80102fbd:	7f c9                	jg     80102f88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102fc2:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80102fc7:	68 c0 26 11 80       	push   $0x801126c0
80102fcc:	e8 1f 18 00 00       	call   801047f0 <release>
      break;
    }
  }
}
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	c9                   	leave  
80102fd5:	c3                   	ret    
80102fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fdd:	8d 76 00             	lea    0x0(%esi),%esi

80102fe0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
80102fe5:	53                   	push   %ebx
80102fe6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fe9:	68 c0 26 11 80       	push   $0x801126c0
80102fee:	e8 5d 18 00 00       	call   80104850 <acquire>
  log.outstanding -= 1;
80102ff3:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80102ff8:	8b 35 00 27 11 80    	mov    0x80112700,%esi
80102ffe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103001:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103004:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
8010300a:	85 f6                	test   %esi,%esi
8010300c:	0f 85 22 01 00 00    	jne    80103134 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103012:	85 db                	test   %ebx,%ebx
80103014:	0f 85 f6 00 00 00    	jne    80103110 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010301a:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
80103021:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103024:	83 ec 0c             	sub    $0xc,%esp
80103027:	68 c0 26 11 80       	push   $0x801126c0
8010302c:	e8 bf 17 00 00       	call   801047f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103031:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80103037:	83 c4 10             	add    $0x10,%esp
8010303a:	85 c9                	test   %ecx,%ecx
8010303c:	7f 42                	jg     80103080 <end_op+0xa0>
    acquire(&log.lock);
8010303e:	83 ec 0c             	sub    $0xc,%esp
80103041:	68 c0 26 11 80       	push   $0x801126c0
80103046:	e8 05 18 00 00       	call   80104850 <acquire>
    wakeup(&log);
8010304b:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
    log.committing = 0;
80103052:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80103059:	00 00 00 
    wakeup(&log);
8010305c:	e8 4f 13 00 00       	call   801043b0 <wakeup>
    release(&log.lock);
80103061:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80103068:	e8 83 17 00 00       	call   801047f0 <release>
8010306d:	83 c4 10             	add    $0x10,%esp
}
80103070:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103073:	5b                   	pop    %ebx
80103074:	5e                   	pop    %esi
80103075:	5f                   	pop    %edi
80103076:	5d                   	pop    %ebp
80103077:	c3                   	ret    
80103078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010307f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103080:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80103085:	83 ec 08             	sub    $0x8,%esp
80103088:	01 d8                	add    %ebx,%eax
8010308a:	83 c0 01             	add    $0x1,%eax
8010308d:	50                   	push   %eax
8010308e:	ff 35 04 27 11 80    	push   0x80112704
80103094:	e8 37 d0 ff ff       	call   801000d0 <bread>
80103099:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010309b:	58                   	pop    %eax
8010309c:	5a                   	pop    %edx
8010309d:	ff 34 9d 0c 27 11 80 	push   -0x7feed8f4(,%ebx,4)
801030a4:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
801030aa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ad:	e8 1e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801030b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030b5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801030ba:	68 00 02 00 00       	push   $0x200
801030bf:	50                   	push   %eax
801030c0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030c3:	50                   	push   %eax
801030c4:	e8 e7 18 00 00       	call   801049b0 <memmove>
    bwrite(to);  // write the log
801030c9:	89 34 24             	mov    %esi,(%esp)
801030cc:	e8 df d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030d1:	89 3c 24             	mov    %edi,(%esp)
801030d4:	e8 17 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030d9:	89 34 24             	mov    %esi,(%esp)
801030dc:	e8 0f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030e1:	83 c4 10             	add    $0x10,%esp
801030e4:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
801030ea:	7c 94                	jl     80103080 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030ec:	e8 7f fd ff ff       	call   80102e70 <write_head>
    install_trans(); // Now install writes to home locations
801030f1:	e8 da fc ff ff       	call   80102dd0 <install_trans>
    log.lh.n = 0;
801030f6:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
801030fd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103100:	e8 6b fd ff ff       	call   80102e70 <write_head>
80103105:	e9 34 ff ff ff       	jmp    8010303e <end_op+0x5e>
8010310a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103110:	83 ec 0c             	sub    $0xc,%esp
80103113:	68 c0 26 11 80       	push   $0x801126c0
80103118:	e8 93 12 00 00       	call   801043b0 <wakeup>
  release(&log.lock);
8010311d:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80103124:	e8 c7 16 00 00       	call   801047f0 <release>
80103129:	83 c4 10             	add    $0x10,%esp
}
8010312c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312f:	5b                   	pop    %ebx
80103130:	5e                   	pop    %esi
80103131:	5f                   	pop    %edi
80103132:	5d                   	pop    %ebp
80103133:	c3                   	ret    
    panic("log.committing");
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 e4 7c 10 80       	push   $0x80107ce4
8010313c:	e8 3f d2 ff ff       	call   80100380 <panic>
80103141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop

80103150 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103157:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
8010315d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103160:	83 fa 1d             	cmp    $0x1d,%edx
80103163:	0f 8f 85 00 00 00    	jg     801031ee <log_write+0x9e>
80103169:	a1 f8 26 11 80       	mov    0x801126f8,%eax
8010316e:	83 e8 01             	sub    $0x1,%eax
80103171:	39 c2                	cmp    %eax,%edx
80103173:	7d 79                	jge    801031ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103175:	a1 fc 26 11 80       	mov    0x801126fc,%eax
8010317a:	85 c0                	test   %eax,%eax
8010317c:	7e 7d                	jle    801031fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010317e:	83 ec 0c             	sub    $0xc,%esp
80103181:	68 c0 26 11 80       	push   $0x801126c0
80103186:	e8 c5 16 00 00       	call   80104850 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010318b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80103191:	83 c4 10             	add    $0x10,%esp
80103194:	85 d2                	test   %edx,%edx
80103196:	7e 4a                	jle    801031e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103198:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010319b:	31 c0                	xor    %eax,%eax
8010319d:	eb 08                	jmp    801031a7 <log_write+0x57>
8010319f:	90                   	nop
801031a0:	83 c0 01             	add    $0x1,%eax
801031a3:	39 c2                	cmp    %eax,%edx
801031a5:	74 29                	je     801031d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031a7:	39 0c 85 0c 27 11 80 	cmp    %ecx,-0x7feed8f4(,%eax,4)
801031ae:	75 f0                	jne    801031a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801031b0:	89 0c 85 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801031b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801031ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801031bd:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
801031c4:	c9                   	leave  
  release(&log.lock);
801031c5:	e9 26 16 00 00       	jmp    801047f0 <release>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031d0:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
    log.lh.n++;
801031d7:	83 c2 01             	add    $0x1,%edx
801031da:	89 15 08 27 11 80    	mov    %edx,0x80112708
801031e0:	eb d5                	jmp    801031b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801031e2:	8b 43 08             	mov    0x8(%ebx),%eax
801031e5:	a3 0c 27 11 80       	mov    %eax,0x8011270c
  if (i == log.lh.n)
801031ea:	75 cb                	jne    801031b7 <log_write+0x67>
801031ec:	eb e9                	jmp    801031d7 <log_write+0x87>
    panic("too big a transaction");
801031ee:	83 ec 0c             	sub    $0xc,%esp
801031f1:	68 f3 7c 10 80       	push   $0x80107cf3
801031f6:	e8 85 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031fb:	83 ec 0c             	sub    $0xc,%esp
801031fe:	68 09 7d 10 80       	push   $0x80107d09
80103203:	e8 78 d1 ff ff       	call   80100380 <panic>
80103208:	66 90                	xchg   %ax,%ax
8010320a:	66 90                	xchg   %ax,%ax
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	53                   	push   %ebx
80103214:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103217:	e8 54 09 00 00       	call   80103b70 <cpuid>
8010321c:	89 c3                	mov    %eax,%ebx
8010321e:	e8 4d 09 00 00       	call   80103b70 <cpuid>
80103223:	83 ec 04             	sub    $0x4,%esp
80103226:	53                   	push   %ebx
80103227:	50                   	push   %eax
80103228:	68 24 7d 10 80       	push   $0x80107d24
8010322d:	e8 6e d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103232:	e8 d9 2a 00 00       	call   80105d10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103237:	e8 d4 08 00 00       	call   80103b10 <mycpu>
8010323c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010323e:	b8 01 00 00 00       	mov    $0x1,%eax
80103243:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010324a:	e8 91 0c 00 00       	call   80103ee0 <scheduler>
8010324f:	90                   	nop

80103250 <mpenter>:
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103256:	e8 b5 3c 00 00       	call   80106f10 <switchkvm>
  seginit();
8010325b:	e8 20 3c 00 00       	call   80106e80 <seginit>
  lapicinit();
80103260:	e8 9b f7 ff ff       	call   80102a00 <lapicinit>
  mpmain();
80103265:	e8 a6 ff ff ff       	call   80103210 <mpmain>
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <main>:
{
80103270:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103274:	83 e4 f0             	and    $0xfffffff0,%esp
80103277:	ff 71 fc             	push   -0x4(%ecx)
8010327a:	55                   	push   %ebp
8010327b:	89 e5                	mov    %esp,%ebp
8010327d:	53                   	push   %ebx
8010327e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010327f:	83 ec 08             	sub    $0x8,%esp
80103282:	68 00 00 40 80       	push   $0x80400000
80103287:	68 f0 65 11 80       	push   $0x801165f0
8010328c:	e8 8f f3 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103291:	e8 da 42 00 00       	call   80107570 <kvmalloc>
  mpinit();        // detect other processors
80103296:	e8 95 01 00 00       	call   80103430 <mpinit>
  lapicinit();     // interrupt controller
8010329b:	e8 60 f7 ff ff       	call   80102a00 <lapicinit>
  seginit();       // segment descriptors
801032a0:	e8 db 3b 00 00       	call   80106e80 <seginit>
  picinit();       // disable pic
801032a5:	e8 86 03 00 00       	call   80103630 <picinit>
  ioapicinit();    // another interrupt controller
801032aa:	e8 31 f1 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801032af:	e8 ac d7 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801032b4:	e8 47 2d 00 00       	call   80106000 <uartinit>
  pinit();         // process table
801032b9:	e8 32 08 00 00       	call   80103af0 <pinit>
  tvinit();        // trap vectors
801032be:	e8 cd 29 00 00       	call   80105c90 <tvinit>
  binit();         // buffer cache
801032c3:	e8 78 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032c8:	e8 53 db ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801032cd:	e8 fe ee ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032d2:	83 c4 0c             	add    $0xc,%esp
801032d5:	68 8a 00 00 00       	push   $0x8a
801032da:	68 9c b4 10 80       	push   $0x8010b49c
801032df:	68 00 70 00 80       	push   $0x80007000
801032e4:	e8 c7 16 00 00       	call   801049b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032e9:	83 c4 10             	add    $0x10,%esp
801032ec:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
801032f3:	00 00 00 
801032f6:	05 c0 27 11 80       	add    $0x801127c0,%eax
801032fb:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
80103300:	76 7e                	jbe    80103380 <main+0x110>
80103302:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
80103307:	eb 20                	jmp    80103329 <main+0xb9>
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103310:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
80103317:	00 00 00 
8010331a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103320:	05 c0 27 11 80       	add    $0x801127c0,%eax
80103325:	39 c3                	cmp    %eax,%ebx
80103327:	73 57                	jae    80103380 <main+0x110>
    if(c == mycpu())  // We've started already.
80103329:	e8 e2 07 00 00       	call   80103b10 <mycpu>
8010332e:	39 c3                	cmp    %eax,%ebx
80103330:	74 de                	je     80103310 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103332:	e8 e9 f4 ff ff       	call   80102820 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103337:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010333a:	c7 05 f8 6f 00 80 50 	movl   $0x80103250,0x80006ff8
80103341:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103344:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010334b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010334e:	05 00 10 00 00       	add    $0x1000,%eax
80103353:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103358:	0f b6 03             	movzbl (%ebx),%eax
8010335b:	68 00 70 00 00       	push   $0x7000
80103360:	50                   	push   %eax
80103361:	e8 ea f7 ff ff       	call   80102b50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103366:	83 c4 10             	add    $0x10,%esp
80103369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103370:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103376:	85 c0                	test   %eax,%eax
80103378:	74 f6                	je     80103370 <main+0x100>
8010337a:	eb 94                	jmp    80103310 <main+0xa0>
8010337c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103380:	83 ec 08             	sub    $0x8,%esp
80103383:	68 00 00 00 8e       	push   $0x8e000000
80103388:	68 00 00 40 80       	push   $0x80400000
8010338d:	e8 2e f2 ff ff       	call   801025c0 <kinit2>
  khugeinit(P2V(HUGE_PAGE_START), P2V(HUGE_PAGE_END));
80103392:	58                   	pop    %eax
80103393:	5a                   	pop    %edx
80103394:	68 00 00 00 be       	push   $0xbe000000
80103399:	68 00 00 00 9e       	push   $0x9e000000
8010339e:	e8 dd f3 ff ff       	call   80102780 <khugeinit>
  userinit();      // first user process
801033a3:	e8 18 08 00 00       	call   80103bc0 <userinit>
  mpmain();        // finish this processor's setup
801033a8:	e8 63 fe ff ff       	call   80103210 <mpmain>
801033ad:	66 90                	xchg   %ax,%ax
801033af:	90                   	nop

801033b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	57                   	push   %edi
801033b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801033bb:	53                   	push   %ebx
  e = addr+len;
801033bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801033bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033c2:	39 de                	cmp    %ebx,%esi
801033c4:	72 10                	jb     801033d6 <mpsearch1+0x26>
801033c6:	eb 50                	jmp    80103418 <mpsearch1+0x68>
801033c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033cf:	90                   	nop
801033d0:	89 fe                	mov    %edi,%esi
801033d2:	39 fb                	cmp    %edi,%ebx
801033d4:	76 42                	jbe    80103418 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033d6:	83 ec 04             	sub    $0x4,%esp
801033d9:	8d 7e 10             	lea    0x10(%esi),%edi
801033dc:	6a 04                	push   $0x4
801033de:	68 38 7d 10 80       	push   $0x80107d38
801033e3:	56                   	push   %esi
801033e4:	e8 77 15 00 00       	call   80104960 <memcmp>
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	85 c0                	test   %eax,%eax
801033ee:	75 e0                	jne    801033d0 <mpsearch1+0x20>
801033f0:	89 f2                	mov    %esi,%edx
801033f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033f8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033fb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103400:	39 fa                	cmp    %edi,%edx
80103402:	75 f4                	jne    801033f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103404:	84 c0                	test   %al,%al
80103406:	75 c8                	jne    801033d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103408:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010340b:	89 f0                	mov    %esi,%eax
8010340d:	5b                   	pop    %ebx
8010340e:	5e                   	pop    %esi
8010340f:	5f                   	pop    %edi
80103410:	5d                   	pop    %ebp
80103411:	c3                   	ret    
80103412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010341b:	31 f6                	xor    %esi,%esi
}
8010341d:	5b                   	pop    %ebx
8010341e:	89 f0                	mov    %esi,%eax
80103420:	5e                   	pop    %esi
80103421:	5f                   	pop    %edi
80103422:	5d                   	pop    %ebp
80103423:	c3                   	ret    
80103424:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010342b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010342f:	90                   	nop

80103430 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103439:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103440:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103447:	c1 e0 08             	shl    $0x8,%eax
8010344a:	09 d0                	or     %edx,%eax
8010344c:	c1 e0 04             	shl    $0x4,%eax
8010344f:	75 1b                	jne    8010346c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103451:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103458:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010345f:	c1 e0 08             	shl    $0x8,%eax
80103462:	09 d0                	or     %edx,%eax
80103464:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103467:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010346c:	ba 00 04 00 00       	mov    $0x400,%edx
80103471:	e8 3a ff ff ff       	call   801033b0 <mpsearch1>
80103476:	89 c3                	mov    %eax,%ebx
80103478:	85 c0                	test   %eax,%eax
8010347a:	0f 84 40 01 00 00    	je     801035c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103480:	8b 73 04             	mov    0x4(%ebx),%esi
80103483:	85 f6                	test   %esi,%esi
80103485:	0f 84 25 01 00 00    	je     801035b0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010348b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010348e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103494:	6a 04                	push   $0x4
80103496:	68 3d 7d 10 80       	push   $0x80107d3d
8010349b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010349c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010349f:	e8 bc 14 00 00       	call   80104960 <memcmp>
801034a4:	83 c4 10             	add    $0x10,%esp
801034a7:	85 c0                	test   %eax,%eax
801034a9:	0f 85 01 01 00 00    	jne    801035b0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801034af:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801034b6:	3c 01                	cmp    $0x1,%al
801034b8:	74 08                	je     801034c2 <mpinit+0x92>
801034ba:	3c 04                	cmp    $0x4,%al
801034bc:	0f 85 ee 00 00 00    	jne    801035b0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801034c2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801034c9:	66 85 d2             	test   %dx,%dx
801034cc:	74 22                	je     801034f0 <mpinit+0xc0>
801034ce:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801034d1:	89 f0                	mov    %esi,%eax
  sum = 0;
801034d3:	31 d2                	xor    %edx,%edx
801034d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801034df:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034e4:	39 c7                	cmp    %eax,%edi
801034e6:	75 f0                	jne    801034d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034e8:	84 d2                	test   %dl,%dl
801034ea:	0f 85 c0 00 00 00    	jne    801035b0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034f0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801034f6:	a3 a4 26 11 80       	mov    %eax,0x801126a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034fb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103502:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103508:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010350d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103510:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103517:	90                   	nop
80103518:	39 d0                	cmp    %edx,%eax
8010351a:	73 15                	jae    80103531 <mpinit+0x101>
    switch(*p){
8010351c:	0f b6 08             	movzbl (%eax),%ecx
8010351f:	80 f9 02             	cmp    $0x2,%cl
80103522:	74 4c                	je     80103570 <mpinit+0x140>
80103524:	77 3a                	ja     80103560 <mpinit+0x130>
80103526:	84 c9                	test   %cl,%cl
80103528:	74 56                	je     80103580 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010352a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010352d:	39 d0                	cmp    %edx,%eax
8010352f:	72 eb                	jb     8010351c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103531:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103534:	85 f6                	test   %esi,%esi
80103536:	0f 84 d9 00 00 00    	je     80103615 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010353c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103540:	74 15                	je     80103557 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103542:	b8 70 00 00 00       	mov    $0x70,%eax
80103547:	ba 22 00 00 00       	mov    $0x22,%edx
8010354c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010354d:	ba 23 00 00 00       	mov    $0x23,%edx
80103552:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103553:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103556:	ee                   	out    %al,(%dx)
  }
}
80103557:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010355a:	5b                   	pop    %ebx
8010355b:	5e                   	pop    %esi
8010355c:	5f                   	pop    %edi
8010355d:	5d                   	pop    %ebp
8010355e:	c3                   	ret    
8010355f:	90                   	nop
    switch(*p){
80103560:	83 e9 03             	sub    $0x3,%ecx
80103563:	80 f9 01             	cmp    $0x1,%cl
80103566:	76 c2                	jbe    8010352a <mpinit+0xfa>
80103568:	31 f6                	xor    %esi,%esi
8010356a:	eb ac                	jmp    80103518 <mpinit+0xe8>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103570:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103574:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103577:	88 0d a0 27 11 80    	mov    %cl,0x801127a0
      continue;
8010357d:	eb 99                	jmp    80103518 <mpinit+0xe8>
8010357f:	90                   	nop
      if(ncpu < NCPU) {
80103580:	8b 0d a4 27 11 80    	mov    0x801127a4,%ecx
80103586:	83 f9 07             	cmp    $0x7,%ecx
80103589:	7f 19                	jg     801035a4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010358b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103591:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103595:	83 c1 01             	add    $0x1,%ecx
80103598:	89 0d a4 27 11 80    	mov    %ecx,0x801127a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010359e:	88 9f c0 27 11 80    	mov    %bl,-0x7feed840(%edi)
      p += sizeof(struct mpproc);
801035a4:	83 c0 14             	add    $0x14,%eax
      continue;
801035a7:	e9 6c ff ff ff       	jmp    80103518 <mpinit+0xe8>
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	68 42 7d 10 80       	push   $0x80107d42
801035b8:	e8 c3 cd ff ff       	call   80100380 <panic>
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
{
801035c0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801035c5:	eb 13                	jmp    801035da <mpinit+0x1aa>
801035c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ce:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801035d0:	89 f3                	mov    %esi,%ebx
801035d2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801035d8:	74 d6                	je     801035b0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035da:	83 ec 04             	sub    $0x4,%esp
801035dd:	8d 73 10             	lea    0x10(%ebx),%esi
801035e0:	6a 04                	push   $0x4
801035e2:	68 38 7d 10 80       	push   $0x80107d38
801035e7:	53                   	push   %ebx
801035e8:	e8 73 13 00 00       	call   80104960 <memcmp>
801035ed:	83 c4 10             	add    $0x10,%esp
801035f0:	85 c0                	test   %eax,%eax
801035f2:	75 dc                	jne    801035d0 <mpinit+0x1a0>
801035f4:	89 da                	mov    %ebx,%edx
801035f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103600:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103603:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103606:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103608:	39 d6                	cmp    %edx,%esi
8010360a:	75 f4                	jne    80103600 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010360c:	84 c0                	test   %al,%al
8010360e:	75 c0                	jne    801035d0 <mpinit+0x1a0>
80103610:	e9 6b fe ff ff       	jmp    80103480 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103615:	83 ec 0c             	sub    $0xc,%esp
80103618:	68 5c 7d 10 80       	push   $0x80107d5c
8010361d:	e8 5e cd ff ff       	call   80100380 <panic>
80103622:	66 90                	xchg   %ax,%ax
80103624:	66 90                	xchg   %ax,%ax
80103626:	66 90                	xchg   %ax,%ax
80103628:	66 90                	xchg   %ax,%ax
8010362a:	66 90                	xchg   %ax,%ax
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <picinit>:
80103630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103635:	ba 21 00 00 00       	mov    $0x21,%edx
8010363a:	ee                   	out    %al,(%dx)
8010363b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103640:	ee                   	out    %al,(%dx)
80103641:	c3                   	ret    
80103642:	66 90                	xchg   %ax,%ax
80103644:	66 90                	xchg   %ax,%ax
80103646:	66 90                	xchg   %ax,%ax
80103648:	66 90                	xchg   %ax,%ax
8010364a:	66 90                	xchg   %ax,%ax
8010364c:	66 90                	xchg   %ax,%ax
8010364e:	66 90                	xchg   %ax,%ax

80103650 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010365c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010365f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103665:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010366b:	e8 d0 d7 ff ff       	call   80100e40 <filealloc>
80103670:	89 03                	mov    %eax,(%ebx)
80103672:	85 c0                	test   %eax,%eax
80103674:	0f 84 a8 00 00 00    	je     80103722 <pipealloc+0xd2>
8010367a:	e8 c1 d7 ff ff       	call   80100e40 <filealloc>
8010367f:	89 06                	mov    %eax,(%esi)
80103681:	85 c0                	test   %eax,%eax
80103683:	0f 84 87 00 00 00    	je     80103710 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103689:	e8 92 f1 ff ff       	call   80102820 <kalloc>
8010368e:	89 c7                	mov    %eax,%edi
80103690:	85 c0                	test   %eax,%eax
80103692:	0f 84 b0 00 00 00    	je     80103748 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103698:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010369f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801036a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801036a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801036ac:	00 00 00 
  p->nwrite = 0;
801036af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036b6:	00 00 00 
  p->nread = 0;
801036b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036c0:	00 00 00 
  initlock(&p->lock, "pipe");
801036c3:	68 7b 7d 10 80       	push   $0x80107d7b
801036c8:	50                   	push   %eax
801036c9:	e8 b2 0f 00 00       	call   80104680 <initlock>
  (*f0)->type = FD_PIPE;
801036ce:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036d9:	8b 03                	mov    (%ebx),%eax
801036db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036df:	8b 03                	mov    (%ebx),%eax
801036e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036e5:	8b 03                	mov    (%ebx),%eax
801036e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ea:	8b 06                	mov    (%esi),%eax
801036ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036f2:	8b 06                	mov    (%esi),%eax
801036f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036f8:	8b 06                	mov    (%esi),%eax
801036fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036fe:	8b 06                	mov    (%esi),%eax
80103700:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103703:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103706:	31 c0                	xor    %eax,%eax
}
80103708:	5b                   	pop    %ebx
80103709:	5e                   	pop    %esi
8010370a:	5f                   	pop    %edi
8010370b:	5d                   	pop    %ebp
8010370c:	c3                   	ret    
8010370d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103710:	8b 03                	mov    (%ebx),%eax
80103712:	85 c0                	test   %eax,%eax
80103714:	74 1e                	je     80103734 <pipealloc+0xe4>
    fileclose(*f0);
80103716:	83 ec 0c             	sub    $0xc,%esp
80103719:	50                   	push   %eax
8010371a:	e8 e1 d7 ff ff       	call   80100f00 <fileclose>
8010371f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103722:	8b 06                	mov    (%esi),%eax
80103724:	85 c0                	test   %eax,%eax
80103726:	74 0c                	je     80103734 <pipealloc+0xe4>
    fileclose(*f1);
80103728:	83 ec 0c             	sub    $0xc,%esp
8010372b:	50                   	push   %eax
8010372c:	e8 cf d7 ff ff       	call   80100f00 <fileclose>
80103731:	83 c4 10             	add    $0x10,%esp
}
80103734:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103737:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010373c:	5b                   	pop    %ebx
8010373d:	5e                   	pop    %esi
8010373e:	5f                   	pop    %edi
8010373f:	5d                   	pop    %ebp
80103740:	c3                   	ret    
80103741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103748:	8b 03                	mov    (%ebx),%eax
8010374a:	85 c0                	test   %eax,%eax
8010374c:	75 c8                	jne    80103716 <pipealloc+0xc6>
8010374e:	eb d2                	jmp    80103722 <pipealloc+0xd2>

80103750 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx
80103755:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103758:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010375b:	83 ec 0c             	sub    $0xc,%esp
8010375e:	53                   	push   %ebx
8010375f:	e8 ec 10 00 00       	call   80104850 <acquire>
  if(writable){
80103764:	83 c4 10             	add    $0x10,%esp
80103767:	85 f6                	test   %esi,%esi
80103769:	74 65                	je     801037d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010376b:	83 ec 0c             	sub    $0xc,%esp
8010376e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103774:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010377b:	00 00 00 
    wakeup(&p->nread);
8010377e:	50                   	push   %eax
8010377f:	e8 2c 0c 00 00       	call   801043b0 <wakeup>
80103784:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103787:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010378d:	85 d2                	test   %edx,%edx
8010378f:	75 0a                	jne    8010379b <pipeclose+0x4b>
80103791:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103797:	85 c0                	test   %eax,%eax
80103799:	74 15                	je     801037b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010379b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010379e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a1:	5b                   	pop    %ebx
801037a2:	5e                   	pop    %esi
801037a3:	5d                   	pop    %ebp
    release(&p->lock);
801037a4:	e9 47 10 00 00       	jmp    801047f0 <release>
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	53                   	push   %ebx
801037b4:	e8 37 10 00 00       	call   801047f0 <release>
    kfree((char*)p);
801037b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037bc:	83 c4 10             	add    $0x10,%esp
}
801037bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037c2:	5b                   	pop    %ebx
801037c3:	5e                   	pop    %esi
801037c4:	5d                   	pop    %ebp
    kfree((char*)p);
801037c5:	e9 06 ed ff ff       	jmp    801024d0 <kfree>
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037e0:	00 00 00 
    wakeup(&p->nwrite);
801037e3:	50                   	push   %eax
801037e4:	e8 c7 0b 00 00       	call   801043b0 <wakeup>
801037e9:	83 c4 10             	add    $0x10,%esp
801037ec:	eb 99                	jmp    80103787 <pipeclose+0x37>
801037ee:	66 90                	xchg   %ax,%ax

801037f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
801037f5:	53                   	push   %ebx
801037f6:	83 ec 28             	sub    $0x28,%esp
801037f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037fc:	53                   	push   %ebx
801037fd:	e8 4e 10 00 00       	call   80104850 <acquire>
  for(i = 0; i < n; i++){
80103802:	8b 45 10             	mov    0x10(%ebp),%eax
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	85 c0                	test   %eax,%eax
8010380a:	0f 8e c0 00 00 00    	jle    801038d0 <pipewrite+0xe0>
80103810:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103813:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103819:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010381f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103822:	03 45 10             	add    0x10(%ebp),%eax
80103825:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103828:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010382e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103834:	89 ca                	mov    %ecx,%edx
80103836:	05 00 02 00 00       	add    $0x200,%eax
8010383b:	39 c1                	cmp    %eax,%ecx
8010383d:	74 3f                	je     8010387e <pipewrite+0x8e>
8010383f:	eb 67                	jmp    801038a8 <pipewrite+0xb8>
80103841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103848:	e8 43 03 00 00       	call   80103b90 <myproc>
8010384d:	8b 48 28             	mov    0x28(%eax),%ecx
80103850:	85 c9                	test   %ecx,%ecx
80103852:	75 34                	jne    80103888 <pipewrite+0x98>
      wakeup(&p->nread);
80103854:	83 ec 0c             	sub    $0xc,%esp
80103857:	57                   	push   %edi
80103858:	e8 53 0b 00 00       	call   801043b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010385d:	58                   	pop    %eax
8010385e:	5a                   	pop    %edx
8010385f:	53                   	push   %ebx
80103860:	56                   	push   %esi
80103861:	e8 8a 0a 00 00       	call   801042f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103866:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010386c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103872:	83 c4 10             	add    $0x10,%esp
80103875:	05 00 02 00 00       	add    $0x200,%eax
8010387a:	39 c2                	cmp    %eax,%edx
8010387c:	75 2a                	jne    801038a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010387e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103884:	85 c0                	test   %eax,%eax
80103886:	75 c0                	jne    80103848 <pipewrite+0x58>
        release(&p->lock);
80103888:	83 ec 0c             	sub    $0xc,%esp
8010388b:	53                   	push   %ebx
8010388c:	e8 5f 0f 00 00       	call   801047f0 <release>
        return -1;
80103891:	83 c4 10             	add    $0x10,%esp
80103894:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010389c:	5b                   	pop    %ebx
8010389d:	5e                   	pop    %esi
8010389e:	5f                   	pop    %edi
8010389f:	5d                   	pop    %ebp
801038a0:	c3                   	ret    
801038a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801038ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801038ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801038ba:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801038bd:	83 c6 01             	add    $0x1,%esi
801038c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801038ca:	0f 85 58 ff ff ff    	jne    80103828 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038d9:	50                   	push   %eax
801038da:	e8 d1 0a 00 00       	call   801043b0 <wakeup>
  release(&p->lock);
801038df:	89 1c 24             	mov    %ebx,(%esp)
801038e2:	e8 09 0f 00 00       	call   801047f0 <release>
  return n;
801038e7:	8b 45 10             	mov    0x10(%ebp),%eax
801038ea:	83 c4 10             	add    $0x10,%esp
801038ed:	eb aa                	jmp    80103899 <pipewrite+0xa9>
801038ef:	90                   	nop

801038f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	57                   	push   %edi
801038f4:	56                   	push   %esi
801038f5:	53                   	push   %ebx
801038f6:	83 ec 18             	sub    $0x18,%esp
801038f9:	8b 75 08             	mov    0x8(%ebp),%esi
801038fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038ff:	56                   	push   %esi
80103900:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103906:	e8 45 0f 00 00       	call   80104850 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010390b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103911:	83 c4 10             	add    $0x10,%esp
80103914:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010391a:	74 2f                	je     8010394b <piperead+0x5b>
8010391c:	eb 37                	jmp    80103955 <piperead+0x65>
8010391e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103920:	e8 6b 02 00 00       	call   80103b90 <myproc>
80103925:	8b 48 28             	mov    0x28(%eax),%ecx
80103928:	85 c9                	test   %ecx,%ecx
8010392a:	0f 85 80 00 00 00    	jne    801039b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103930:	83 ec 08             	sub    $0x8,%esp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx
80103935:	e8 b6 09 00 00       	call   801042f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010393a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103940:	83 c4 10             	add    $0x10,%esp
80103943:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103949:	75 0a                	jne    80103955 <piperead+0x65>
8010394b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103951:	85 c0                	test   %eax,%eax
80103953:	75 cb                	jne    80103920 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103955:	8b 55 10             	mov    0x10(%ebp),%edx
80103958:	31 db                	xor    %ebx,%ebx
8010395a:	85 d2                	test   %edx,%edx
8010395c:	7f 20                	jg     8010397e <piperead+0x8e>
8010395e:	eb 2c                	jmp    8010398c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103960:	8d 48 01             	lea    0x1(%eax),%ecx
80103963:	25 ff 01 00 00       	and    $0x1ff,%eax
80103968:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010396e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103973:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103976:	83 c3 01             	add    $0x1,%ebx
80103979:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010397c:	74 0e                	je     8010398c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010397e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103984:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010398a:	75 d4                	jne    80103960 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010398c:	83 ec 0c             	sub    $0xc,%esp
8010398f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103995:	50                   	push   %eax
80103996:	e8 15 0a 00 00       	call   801043b0 <wakeup>
  release(&p->lock);
8010399b:	89 34 24             	mov    %esi,(%esp)
8010399e:	e8 4d 0e 00 00       	call   801047f0 <release>
  return i;
801039a3:	83 c4 10             	add    $0x10,%esp
}
801039a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039a9:	89 d8                	mov    %ebx,%eax
801039ab:	5b                   	pop    %ebx
801039ac:	5e                   	pop    %esi
801039ad:	5f                   	pop    %edi
801039ae:	5d                   	pop    %ebp
801039af:	c3                   	ret    
      release(&p->lock);
801039b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039b8:	56                   	push   %esi
801039b9:	e8 32 0e 00 00       	call   801047f0 <release>
      return -1;
801039be:	83 c4 10             	add    $0x10,%esp
}
801039c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039c4:	89 d8                	mov    %ebx,%eax
801039c6:	5b                   	pop    %ebx
801039c7:	5e                   	pop    %esi
801039c8:	5f                   	pop    %edi
801039c9:	5d                   	pop    %ebp
801039ca:	c3                   	ret    
801039cb:	66 90                	xchg   %ax,%ax
801039cd:	66 90                	xchg   %ax,%ax
801039cf:	90                   	nop

801039d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
801039d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039dc:	68 40 2d 11 80       	push   $0x80112d40
801039e1:	e8 6a 0e 00 00       	call   80104850 <acquire>
801039e6:	83 c4 10             	add    $0x10,%esp
801039e9:	eb 10                	jmp    801039fb <allocproc+0x2b>
801039eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039ef:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039f0:	83 eb 80             	sub    $0xffffff80,%ebx
801039f3:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
801039f9:	74 75                	je     80103a70 <allocproc+0xa0>
    if(p->state == UNUSED)
801039fb:	8b 43 10             	mov    0x10(%ebx),%eax
801039fe:	85 c0                	test   %eax,%eax
80103a00:	75 ee                	jne    801039f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a02:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103a07:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103a0a:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
80103a11:	89 43 14             	mov    %eax,0x14(%ebx)
80103a14:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103a17:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
80103a1c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103a22:	e8 c9 0d 00 00       	call   801047f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a27:	e8 f4 ed ff ff       	call   80102820 <kalloc>
80103a2c:	83 c4 10             	add    $0x10,%esp
80103a2f:	89 43 0c             	mov    %eax,0xc(%ebx)
80103a32:	85 c0                	test   %eax,%eax
80103a34:	74 53                	je     80103a89 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a36:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a3c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a3f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a44:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103a47:	c7 40 14 80 5c 10 80 	movl   $0x80105c80,0x14(%eax)
  p->context = (struct context*)sp;
80103a4e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a51:	6a 14                	push   $0x14
80103a53:	6a 00                	push   $0x0
80103a55:	50                   	push   %eax
80103a56:	e8 b5 0e 00 00       	call   80104910 <memset>
  p->context->eip = (uint)forkret;
80103a5b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103a5e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a61:	c7 40 10 a0 3a 10 80 	movl   $0x80103aa0,0x10(%eax)
}
80103a68:	89 d8                	mov    %ebx,%eax
80103a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a6d:	c9                   	leave  
80103a6e:	c3                   	ret    
80103a6f:	90                   	nop
  release(&ptable.lock);
80103a70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a73:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a75:	68 40 2d 11 80       	push   $0x80112d40
80103a7a:	e8 71 0d 00 00       	call   801047f0 <release>
}
80103a7f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a81:	83 c4 10             	add    $0x10,%esp
}
80103a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a87:	c9                   	leave  
80103a88:	c3                   	ret    
    p->state = UNUSED;
80103a89:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103a90:	31 db                	xor    %ebx,%ebx
}
80103a92:	89 d8                	mov    %ebx,%eax
80103a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a97:	c9                   	leave  
80103a98:	c3                   	ret    
80103a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103aa0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103aa6:	68 40 2d 11 80       	push   $0x80112d40
80103aab:	e8 40 0d 00 00       	call   801047f0 <release>

  if (first) {
80103ab0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103ab5:	83 c4 10             	add    $0x10,%esp
80103ab8:	85 c0                	test   %eax,%eax
80103aba:	75 04                	jne    80103ac0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103abc:	c9                   	leave  
80103abd:	c3                   	ret    
80103abe:	66 90                	xchg   %ax,%ax
    first = 0;
80103ac0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103ac7:	00 00 00 
    iinit(ROOTDEV);
80103aca:	83 ec 0c             	sub    $0xc,%esp
80103acd:	6a 01                	push   $0x1
80103acf:	e8 9c da ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103adb:	e8 f0 f3 ff ff       	call   80102ed0 <initlog>
}
80103ae0:	83 c4 10             	add    $0x10,%esp
80103ae3:	c9                   	leave  
80103ae4:	c3                   	ret    
80103ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103af0 <pinit>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103af6:	68 80 7d 10 80       	push   $0x80107d80
80103afb:	68 40 2d 11 80       	push   $0x80112d40
80103b00:	e8 7b 0b 00 00       	call   80104680 <initlock>
}
80103b05:	83 c4 10             	add    $0x10,%esp
80103b08:	c9                   	leave  
80103b09:	c3                   	ret    
80103b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b10 <mycpu>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b15:	9c                   	pushf  
80103b16:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b17:	f6 c4 02             	test   $0x2,%ah
80103b1a:	75 46                	jne    80103b62 <mycpu+0x52>
  apicid = lapicid();
80103b1c:	e8 df ef ff ff       	call   80102b00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b21:	8b 35 a4 27 11 80    	mov    0x801127a4,%esi
80103b27:	85 f6                	test   %esi,%esi
80103b29:	7e 2a                	jle    80103b55 <mycpu+0x45>
80103b2b:	31 d2                	xor    %edx,%edx
80103b2d:	eb 08                	jmp    80103b37 <mycpu+0x27>
80103b2f:	90                   	nop
80103b30:	83 c2 01             	add    $0x1,%edx
80103b33:	39 f2                	cmp    %esi,%edx
80103b35:	74 1e                	je     80103b55 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103b37:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b3d:	0f b6 99 c0 27 11 80 	movzbl -0x7feed840(%ecx),%ebx
80103b44:	39 c3                	cmp    %eax,%ebx
80103b46:	75 e8                	jne    80103b30 <mycpu+0x20>
}
80103b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b4b:	8d 81 c0 27 11 80    	lea    -0x7feed840(%ecx),%eax
}
80103b51:	5b                   	pop    %ebx
80103b52:	5e                   	pop    %esi
80103b53:	5d                   	pop    %ebp
80103b54:	c3                   	ret    
  panic("unknown apicid\n");
80103b55:	83 ec 0c             	sub    $0xc,%esp
80103b58:	68 87 7d 10 80       	push   $0x80107d87
80103b5d:	e8 1e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b62:	83 ec 0c             	sub    $0xc,%esp
80103b65:	68 64 7e 10 80       	push   $0x80107e64
80103b6a:	e8 11 c8 ff ff       	call   80100380 <panic>
80103b6f:	90                   	nop

80103b70 <cpuid>:
cpuid() {
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b76:	e8 95 ff ff ff       	call   80103b10 <mycpu>
}
80103b7b:	c9                   	leave  
  return mycpu()-cpus;
80103b7c:	2d c0 27 11 80       	sub    $0x801127c0,%eax
80103b81:	c1 f8 04             	sar    $0x4,%eax
80103b84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b8a:	c3                   	ret    
80103b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <myproc>:
myproc(void) {
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	53                   	push   %ebx
80103b94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b97:	e8 64 0b 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103b9c:	e8 6f ff ff ff       	call   80103b10 <mycpu>
  p = c->proc;
80103ba1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ba7:	e8 a4 0b 00 00       	call   80104750 <popcli>
}
80103bac:	89 d8                	mov    %ebx,%eax
80103bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb1:	c9                   	leave  
80103bb2:	c3                   	ret    
80103bb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bc0 <userinit>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	53                   	push   %ebx
80103bc4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bc7:	e8 04 fe ff ff       	call   801039d0 <allocproc>
80103bcc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bce:	a3 74 4d 11 80       	mov    %eax,0x80114d74
  if((p->pgdir = setupkvm()) == 0)
80103bd3:	e8 18 39 00 00       	call   801074f0 <setupkvm>
80103bd8:	89 43 08             	mov    %eax,0x8(%ebx)
80103bdb:	85 c0                	test   %eax,%eax
80103bdd:	0f 84 bd 00 00 00    	je     80103ca0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103be3:	83 ec 04             	sub    $0x4,%esp
80103be6:	68 2c 00 00 00       	push   $0x2c
80103beb:	68 70 b4 10 80       	push   $0x8010b470
80103bf0:	50                   	push   %eax
80103bf1:	e8 3a 34 00 00       	call   80107030 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bf6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bf9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bff:	6a 4c                	push   $0x4c
80103c01:	6a 00                	push   $0x0
80103c03:	ff 73 1c             	push   0x1c(%ebx)
80103c06:	e8 05 0d 00 00       	call   80104910 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c1f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c26:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c31:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c3c:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c46:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c50:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c5a:	8d 43 70             	lea    0x70(%ebx),%eax
80103c5d:	6a 10                	push   $0x10
80103c5f:	68 b0 7d 10 80       	push   $0x80107db0
80103c64:	50                   	push   %eax
80103c65:	e8 66 0e 00 00       	call   80104ad0 <safestrcpy>
  p->cwd = namei("/");
80103c6a:	c7 04 24 b9 7d 10 80 	movl   $0x80107db9,(%esp)
80103c71:	e8 3a e4 ff ff       	call   801020b0 <namei>
80103c76:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c79:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c80:	e8 cb 0b 00 00       	call   80104850 <acquire>
  p->state = RUNNABLE;
80103c85:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c8c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c93:	e8 58 0b 00 00       	call   801047f0 <release>
}
80103c98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c9b:	83 c4 10             	add    $0x10,%esp
80103c9e:	c9                   	leave  
80103c9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	68 97 7d 10 80       	push   $0x80107d97
80103ca8:	e8 d3 c6 ff ff       	call   80100380 <panic>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi

80103cb0 <growproc>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	56                   	push   %esi
80103cb4:	53                   	push   %ebx
80103cb5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cb8:	e8 43 0a 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103cbd:	e8 4e fe ff ff       	call   80103b10 <mycpu>
  p = c->proc;
80103cc2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc8:	e8 83 0a 00 00       	call   80104750 <popcli>
  sz = curproc->sz;
80103ccd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ccf:	85 f6                	test   %esi,%esi
80103cd1:	7f 1d                	jg     80103cf0 <growproc+0x40>
  } else if(n < 0){
80103cd3:	75 3b                	jne    80103d10 <growproc+0x60>
  switchuvm(curproc);
80103cd5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cd8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cda:	53                   	push   %ebx
80103cdb:	e8 40 32 00 00       	call   80106f20 <switchuvm>
  return 0;
80103ce0:	83 c4 10             	add    $0x10,%esp
80103ce3:	31 c0                	xor    %eax,%eax
}
80103ce5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ce8:	5b                   	pop    %ebx
80103ce9:	5e                   	pop    %esi
80103cea:	5d                   	pop    %ebp
80103ceb:	c3                   	ret    
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cf0:	83 ec 04             	sub    $0x4,%esp
80103cf3:	01 c6                	add    %eax,%esi
80103cf5:	56                   	push   %esi
80103cf6:	50                   	push   %eax
80103cf7:	ff 73 08             	push   0x8(%ebx)
80103cfa:	e8 d1 34 00 00       	call   801071d0 <allocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	85 c0                	test   %eax,%eax
80103d04:	75 cf                	jne    80103cd5 <growproc+0x25>
      return -1;
80103d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d0b:	eb d8                	jmp    80103ce5 <growproc+0x35>
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d10:	83 ec 04             	sub    $0x4,%esp
80103d13:	01 c6                	add    %eax,%esi
80103d15:	56                   	push   %esi
80103d16:	50                   	push   %eax
80103d17:	ff 73 08             	push   0x8(%ebx)
80103d1a:	e8 f1 36 00 00       	call   80107410 <deallocuvm>
80103d1f:	83 c4 10             	add    $0x10,%esp
80103d22:	85 c0                	test   %eax,%eax
80103d24:	75 af                	jne    80103cd5 <growproc+0x25>
80103d26:	eb de                	jmp    80103d06 <growproc+0x56>
80103d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2f:	90                   	nop

80103d30 <growhugeproc>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
80103d35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d38:	e8 c3 09 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103d3d:	e8 ce fd ff ff       	call   80103b10 <mycpu>
  p = c->proc;
80103d42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d48:	e8 03 0a 00 00       	call   80104750 <popcli>
  sz = curproc->hugesz;
80103d4d:	8b 43 04             	mov    0x4(%ebx),%eax
  if(n > 0){
80103d50:	85 f6                	test   %esi,%esi
80103d52:	7f 24                	jg     80103d78 <growhugeproc+0x48>
  } else if(n < 0){
80103d54:	75 4a                	jne    80103da0 <growhugeproc+0x70>
  curproc->hugesz = sz - HUGE_VA_OFFSET;
80103d56:	2d 00 00 00 1e       	sub    $0x1e000000,%eax
  switchuvm(curproc);
80103d5b:	83 ec 0c             	sub    $0xc,%esp
  curproc->hugesz = sz - HUGE_VA_OFFSET;
80103d5e:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103d61:	53                   	push   %ebx
80103d62:	e8 b9 31 00 00       	call   80106f20 <switchuvm>
  return 0;
80103d67:	83 c4 10             	add    $0x10,%esp
80103d6a:	31 c0                	xor    %eax,%eax
}
80103d6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d6f:	5b                   	pop    %ebx
80103d70:	5e                   	pop    %esi
80103d71:	5d                   	pop    %ebp
80103d72:	c3                   	ret    
80103d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d77:	90                   	nop
    if((sz = allochugeuvm(curproc->pgdir, sz + HUGE_VA_OFFSET, sz + n + HUGE_VA_OFFSET)) == 0)
80103d78:	83 ec 04             	sub    $0x4,%esp
80103d7b:	8d 94 30 00 00 00 1e 	lea    0x1e000000(%eax,%esi,1),%edx
80103d82:	05 00 00 00 1e       	add    $0x1e000000,%eax
80103d87:	52                   	push   %edx
80103d88:	50                   	push   %eax
80103d89:	ff 73 08             	push   0x8(%ebx)
80103d8c:	e8 6f 35 00 00       	call   80107300 <allochugeuvm>
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	85 c0                	test   %eax,%eax
80103d96:	75 be                	jne    80103d56 <growhugeproc+0x26>
      return -1;
80103d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d9d:	eb cd                	jmp    80103d6c <growhugeproc+0x3c>
80103d9f:	90                   	nop
    if((sz = deallochugeuvm(curproc->pgdir, sz, sz + n)) == 0)
80103da0:	83 ec 04             	sub    $0x4,%esp
80103da3:	01 c6                	add    %eax,%esi
80103da5:	56                   	push   %esi
80103da6:	50                   	push   %eax
80103da7:	ff 73 08             	push   0x8(%ebx)
80103daa:	e8 91 36 00 00       	call   80107440 <deallochugeuvm>
80103daf:	83 c4 10             	add    $0x10,%esp
80103db2:	85 c0                	test   %eax,%eax
80103db4:	75 a0                	jne    80103d56 <growhugeproc+0x26>
80103db6:	eb e0                	jmp    80103d98 <growhugeproc+0x68>
80103db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbf:	90                   	nop

80103dc0 <fork>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103dc9:	e8 32 09 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103dce:	e8 3d fd ff ff       	call   80103b10 <mycpu>
  p = c->proc;
80103dd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dd9:	e8 72 09 00 00       	call   80104750 <popcli>
  if((np = allocproc()) == 0){
80103dde:	e8 ed fb ff ff       	call   801039d0 <allocproc>
80103de3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103de6:	85 c0                	test   %eax,%eax
80103de8:	0f 84 b7 00 00 00    	je     80103ea5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dee:	83 ec 08             	sub    $0x8,%esp
80103df1:	ff 33                	push   (%ebx)
80103df3:	89 c7                	mov    %eax,%edi
80103df5:	ff 73 08             	push   0x8(%ebx)
80103df8:	e8 e3 37 00 00       	call   801075e0 <copyuvm>
80103dfd:	83 c4 10             	add    $0x10,%esp
80103e00:	89 47 08             	mov    %eax,0x8(%edi)
80103e03:	85 c0                	test   %eax,%eax
80103e05:	0f 84 a1 00 00 00    	je     80103eac <fork+0xec>
  np->sz = curproc->sz;
80103e0b:	8b 03                	mov    (%ebx),%eax
80103e0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e10:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e12:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103e15:	89 c8                	mov    %ecx,%eax
80103e17:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103e1a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e1f:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103e22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e26:	8b 40 1c             	mov    0x1c(%eax),%eax
80103e29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e30:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103e34:	85 c0                	test   %eax,%eax
80103e36:	74 13                	je     80103e4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e38:	83 ec 0c             	sub    $0xc,%esp
80103e3b:	50                   	push   %eax
80103e3c:	e8 6f d0 ff ff       	call   80100eb0 <filedup>
80103e41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e44:	83 c4 10             	add    $0x10,%esp
80103e47:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e4b:	83 c6 01             	add    $0x1,%esi
80103e4e:	83 fe 10             	cmp    $0x10,%esi
80103e51:	75 dd                	jne    80103e30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e59:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103e5c:	e8 ff d8 ff ff       	call   80101760 <idup>
80103e61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e67:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e6a:	8d 47 70             	lea    0x70(%edi),%eax
80103e6d:	6a 10                	push   $0x10
80103e6f:	53                   	push   %ebx
80103e70:	50                   	push   %eax
80103e71:	e8 5a 0c 00 00       	call   80104ad0 <safestrcpy>
  pid = np->pid;
80103e76:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103e79:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e80:	e8 cb 09 00 00       	call   80104850 <acquire>
  np->state = RUNNABLE;
80103e85:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103e8c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e93:	e8 58 09 00 00       	call   801047f0 <release>
  return pid;
80103e98:	83 c4 10             	add    $0x10,%esp
}
80103e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e9e:	89 d8                	mov    %ebx,%eax
80103ea0:	5b                   	pop    %ebx
80103ea1:	5e                   	pop    %esi
80103ea2:	5f                   	pop    %edi
80103ea3:	5d                   	pop    %ebp
80103ea4:	c3                   	ret    
    return -1;
80103ea5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eaa:	eb ef                	jmp    80103e9b <fork+0xdb>
    kfree(np->kstack);
80103eac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103eaf:	83 ec 0c             	sub    $0xc,%esp
80103eb2:	ff 73 0c             	push   0xc(%ebx)
80103eb5:	e8 16 e6 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103eba:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ec1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ec4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103ecb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ed0:	eb c9                	jmp    80103e9b <fork+0xdb>
80103ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ee0 <scheduler>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ee9:	e8 22 fc ff ff       	call   80103b10 <mycpu>
  c->proc = 0;
80103eee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ef5:	00 00 00 
  struct cpu *c = mycpu();
80103ef8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103efa:	8d 78 04             	lea    0x4(%eax),%edi
80103efd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f00:	fb                   	sti    
    acquire(&ptable.lock);
80103f01:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f04:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
80103f09:	68 40 2d 11 80       	push   $0x80112d40
80103f0e:	e8 3d 09 00 00       	call   80104850 <acquire>
80103f13:	83 c4 10             	add    $0x10,%esp
80103f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f20:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103f24:	75 33                	jne    80103f59 <scheduler+0x79>
      switchuvm(p);
80103f26:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f2f:	53                   	push   %ebx
80103f30:	e8 eb 2f 00 00       	call   80106f20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f35:	58                   	pop    %eax
80103f36:	5a                   	pop    %edx
80103f37:	ff 73 20             	push   0x20(%ebx)
80103f3a:	57                   	push   %edi
      p->state = RUNNING;
80103f3b:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103f42:	e8 e4 0b 00 00       	call   80104b2b <swtch>
      switchkvm();
80103f47:	e8 c4 2f 00 00       	call   80106f10 <switchkvm>
      c->proc = 0;
80103f4c:	83 c4 10             	add    $0x10,%esp
80103f4f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f56:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f59:	83 eb 80             	sub    $0xffffff80,%ebx
80103f5c:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80103f62:	75 bc                	jne    80103f20 <scheduler+0x40>
    release(&ptable.lock);
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 40 2d 11 80       	push   $0x80112d40
80103f6c:	e8 7f 08 00 00       	call   801047f0 <release>
    sti();
80103f71:	83 c4 10             	add    $0x10,%esp
80103f74:	eb 8a                	jmp    80103f00 <scheduler+0x20>
80103f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi

80103f80 <sched>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
  pushcli();
80103f85:	e8 76 07 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103f8a:	e8 81 fb ff ff       	call   80103b10 <mycpu>
  p = c->proc;
80103f8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f95:	e8 b6 07 00 00       	call   80104750 <popcli>
  if(!holding(&ptable.lock))
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 40 2d 11 80       	push   $0x80112d40
80103fa2:	e8 09 08 00 00       	call   801047b0 <holding>
80103fa7:	83 c4 10             	add    $0x10,%esp
80103faa:	85 c0                	test   %eax,%eax
80103fac:	74 4f                	je     80103ffd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fae:	e8 5d fb ff ff       	call   80103b10 <mycpu>
80103fb3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fba:	75 68                	jne    80104024 <sched+0xa4>
  if(p->state == RUNNING)
80103fbc:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103fc0:	74 55                	je     80104017 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fc2:	9c                   	pushf  
80103fc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fc4:	f6 c4 02             	test   $0x2,%ah
80103fc7:	75 41                	jne    8010400a <sched+0x8a>
  intena = mycpu()->intena;
80103fc9:	e8 42 fb ff ff       	call   80103b10 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fce:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103fd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fd7:	e8 34 fb ff ff       	call   80103b10 <mycpu>
80103fdc:	83 ec 08             	sub    $0x8,%esp
80103fdf:	ff 70 04             	push   0x4(%eax)
80103fe2:	53                   	push   %ebx
80103fe3:	e8 43 0b 00 00       	call   80104b2b <swtch>
  mycpu()->intena = intena;
80103fe8:	e8 23 fb ff ff       	call   80103b10 <mycpu>
}
80103fed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ff0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ff6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff9:	5b                   	pop    %ebx
80103ffa:	5e                   	pop    %esi
80103ffb:	5d                   	pop    %ebp
80103ffc:	c3                   	ret    
    panic("sched ptable.lock");
80103ffd:	83 ec 0c             	sub    $0xc,%esp
80104000:	68 bb 7d 10 80       	push   $0x80107dbb
80104005:	e8 76 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	68 e7 7d 10 80       	push   $0x80107de7
80104012:	e8 69 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104017:	83 ec 0c             	sub    $0xc,%esp
8010401a:	68 d9 7d 10 80       	push   $0x80107dd9
8010401f:	e8 5c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104024:	83 ec 0c             	sub    $0xc,%esp
80104027:	68 cd 7d 10 80       	push   $0x80107dcd
8010402c:	e8 4f c3 ff ff       	call   80100380 <panic>
80104031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403f:	90                   	nop

80104040 <exit>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104049:	e8 42 fb ff ff       	call   80103b90 <myproc>
  if(curproc == initproc)
8010404e:	39 05 74 4d 11 80    	cmp    %eax,0x80114d74
80104054:	0f 84 fd 00 00 00    	je     80104157 <exit+0x117>
8010405a:	89 c3                	mov    %eax,%ebx
8010405c:	8d 70 2c             	lea    0x2c(%eax),%esi
8010405f:	8d 78 6c             	lea    0x6c(%eax),%edi
80104062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104068:	8b 06                	mov    (%esi),%eax
8010406a:	85 c0                	test   %eax,%eax
8010406c:	74 12                	je     80104080 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010406e:	83 ec 0c             	sub    $0xc,%esp
80104071:	50                   	push   %eax
80104072:	e8 89 ce ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80104077:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010407d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104080:	83 c6 04             	add    $0x4,%esi
80104083:	39 f7                	cmp    %esi,%edi
80104085:	75 e1                	jne    80104068 <exit+0x28>
  begin_op();
80104087:	e8 e4 ee ff ff       	call   80102f70 <begin_op>
  iput(curproc->cwd);
8010408c:	83 ec 0c             	sub    $0xc,%esp
8010408f:	ff 73 6c             	push   0x6c(%ebx)
80104092:	e8 29 d8 ff ff       	call   801018c0 <iput>
  end_op();
80104097:	e8 44 ef ff ff       	call   80102fe0 <end_op>
  curproc->cwd = 0;
8010409c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
801040a3:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801040aa:	e8 a1 07 00 00       	call   80104850 <acquire>
  wakeup1(curproc->parent);
801040af:	8b 53 18             	mov    0x18(%ebx),%edx
801040b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b5:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801040ba:	eb 0e                	jmp    801040ca <exit+0x8a>
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c0:	83 e8 80             	sub    $0xffffff80,%eax
801040c3:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801040c8:	74 1c                	je     801040e6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801040ca:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040ce:	75 f0                	jne    801040c0 <exit+0x80>
801040d0:	3b 50 24             	cmp    0x24(%eax),%edx
801040d3:	75 eb                	jne    801040c0 <exit+0x80>
      p->state = RUNNABLE;
801040d5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040dc:	83 e8 80             	sub    $0xffffff80,%eax
801040df:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801040e4:	75 e4                	jne    801040ca <exit+0x8a>
      p->parent = initproc;
801040e6:	8b 0d 74 4d 11 80    	mov    0x80114d74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ec:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
801040f1:	eb 10                	jmp    80104103 <exit+0xc3>
801040f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040f7:	90                   	nop
801040f8:	83 ea 80             	sub    $0xffffff80,%edx
801040fb:	81 fa 74 4d 11 80    	cmp    $0x80114d74,%edx
80104101:	74 3b                	je     8010413e <exit+0xfe>
    if(p->parent == curproc){
80104103:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104106:	75 f0                	jne    801040f8 <exit+0xb8>
      if(p->state == ZOMBIE)
80104108:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
8010410c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010410f:	75 e7                	jne    801040f8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104111:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80104116:	eb 12                	jmp    8010412a <exit+0xea>
80104118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop
80104120:	83 e8 80             	sub    $0xffffff80,%eax
80104123:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104128:	74 ce                	je     801040f8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010412a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010412e:	75 f0                	jne    80104120 <exit+0xe0>
80104130:	3b 48 24             	cmp    0x24(%eax),%ecx
80104133:	75 eb                	jne    80104120 <exit+0xe0>
      p->state = RUNNABLE;
80104135:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010413c:	eb e2                	jmp    80104120 <exit+0xe0>
  curproc->state = ZOMBIE;
8010413e:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80104145:	e8 36 fe ff ff       	call   80103f80 <sched>
  panic("zombie exit");
8010414a:	83 ec 0c             	sub    $0xc,%esp
8010414d:	68 08 7e 10 80       	push   $0x80107e08
80104152:	e8 29 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104157:	83 ec 0c             	sub    $0xc,%esp
8010415a:	68 fb 7d 10 80       	push   $0x80107dfb
8010415f:	e8 1c c2 ff ff       	call   80100380 <panic>
80104164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010416f:	90                   	nop

80104170 <wait>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
  pushcli();
80104175:	e8 86 05 00 00       	call   80104700 <pushcli>
  c = mycpu();
8010417a:	e8 91 f9 ff ff       	call   80103b10 <mycpu>
  p = c->proc;
8010417f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104185:	e8 c6 05 00 00       	call   80104750 <popcli>
  acquire(&ptable.lock);
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	68 40 2d 11 80       	push   $0x80112d40
80104192:	e8 b9 06 00 00       	call   80104850 <acquire>
80104197:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010419a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010419c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
801041a1:	eb 10                	jmp    801041b3 <wait+0x43>
801041a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a7:	90                   	nop
801041a8:	83 eb 80             	sub    $0xffffff80,%ebx
801041ab:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
801041b1:	74 1b                	je     801041ce <wait+0x5e>
      if(p->parent != curproc)
801041b3:	39 73 18             	cmp    %esi,0x18(%ebx)
801041b6:	75 f0                	jne    801041a8 <wait+0x38>
      if(p->state == ZOMBIE){
801041b8:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801041bc:	74 62                	je     80104220 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041be:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
801041c1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c6:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
801041cc:	75 e5                	jne    801041b3 <wait+0x43>
    if(!havekids || curproc->killed){
801041ce:	85 c0                	test   %eax,%eax
801041d0:	0f 84 a0 00 00 00    	je     80104276 <wait+0x106>
801041d6:	8b 46 28             	mov    0x28(%esi),%eax
801041d9:	85 c0                	test   %eax,%eax
801041db:	0f 85 95 00 00 00    	jne    80104276 <wait+0x106>
  pushcli();
801041e1:	e8 1a 05 00 00       	call   80104700 <pushcli>
  c = mycpu();
801041e6:	e8 25 f9 ff ff       	call   80103b10 <mycpu>
  p = c->proc;
801041eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f1:	e8 5a 05 00 00       	call   80104750 <popcli>
  if(p == 0)
801041f6:	85 db                	test   %ebx,%ebx
801041f8:	0f 84 8f 00 00 00    	je     8010428d <wait+0x11d>
  p->chan = chan;
801041fe:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
80104201:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104208:	e8 73 fd ff ff       	call   80103f80 <sched>
  p->chan = 0;
8010420d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80104214:	eb 84                	jmp    8010419a <wait+0x2a>
80104216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104220:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104223:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104226:	ff 73 0c             	push   0xc(%ebx)
80104229:	e8 a2 e2 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
8010422e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80104235:	5a                   	pop    %edx
80104236:	ff 73 08             	push   0x8(%ebx)
80104239:	e8 32 32 00 00       	call   80107470 <freevm>
        p->pid = 0;
8010423e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104245:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010424c:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104250:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104257:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010425e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104265:	e8 86 05 00 00       	call   801047f0 <release>
        return pid;
8010426a:	83 c4 10             	add    $0x10,%esp
}
8010426d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104270:	89 f0                	mov    %esi,%eax
80104272:	5b                   	pop    %ebx
80104273:	5e                   	pop    %esi
80104274:	5d                   	pop    %ebp
80104275:	c3                   	ret    
      release(&ptable.lock);
80104276:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104279:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010427e:	68 40 2d 11 80       	push   $0x80112d40
80104283:	e8 68 05 00 00       	call   801047f0 <release>
      return -1;
80104288:	83 c4 10             	add    $0x10,%esp
8010428b:	eb e0                	jmp    8010426d <wait+0xfd>
    panic("sleep");
8010428d:	83 ec 0c             	sub    $0xc,%esp
80104290:	68 14 7e 10 80       	push   $0x80107e14
80104295:	e8 e6 c0 ff ff       	call   80100380 <panic>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042a0 <yield>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042a7:	68 40 2d 11 80       	push   $0x80112d40
801042ac:	e8 9f 05 00 00       	call   80104850 <acquire>
  pushcli();
801042b1:	e8 4a 04 00 00       	call   80104700 <pushcli>
  c = mycpu();
801042b6:	e8 55 f8 ff ff       	call   80103b10 <mycpu>
  p = c->proc;
801042bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c1:	e8 8a 04 00 00       	call   80104750 <popcli>
  myproc()->state = RUNNABLE;
801042c6:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
801042cd:	e8 ae fc ff ff       	call   80103f80 <sched>
  release(&ptable.lock);
801042d2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801042d9:	e8 12 05 00 00       	call   801047f0 <release>
}
801042de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e1:	83 c4 10             	add    $0x10,%esp
801042e4:	c9                   	leave  
801042e5:	c3                   	ret    
801042e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ed:	8d 76 00             	lea    0x0(%esi),%esi

801042f0 <sleep>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042ff:	e8 fc 03 00 00       	call   80104700 <pushcli>
  c = mycpu();
80104304:	e8 07 f8 ff ff       	call   80103b10 <mycpu>
  p = c->proc;
80104309:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010430f:	e8 3c 04 00 00       	call   80104750 <popcli>
  if(p == 0)
80104314:	85 db                	test   %ebx,%ebx
80104316:	0f 84 87 00 00 00    	je     801043a3 <sleep+0xb3>
  if(lk == 0)
8010431c:	85 f6                	test   %esi,%esi
8010431e:	74 76                	je     80104396 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104320:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80104326:	74 50                	je     80104378 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 40 2d 11 80       	push   $0x80112d40
80104330:	e8 1b 05 00 00       	call   80104850 <acquire>
    release(lk);
80104335:	89 34 24             	mov    %esi,(%esp)
80104338:	e8 b3 04 00 00       	call   801047f0 <release>
  p->chan = chan;
8010433d:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80104340:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104347:	e8 34 fc ff ff       	call   80103f80 <sched>
  p->chan = 0;
8010434c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104353:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010435a:	e8 91 04 00 00       	call   801047f0 <release>
    acquire(lk);
8010435f:	89 75 08             	mov    %esi,0x8(%ebp)
80104362:	83 c4 10             	add    $0x10,%esp
}
80104365:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104368:	5b                   	pop    %ebx
80104369:	5e                   	pop    %esi
8010436a:	5f                   	pop    %edi
8010436b:	5d                   	pop    %ebp
    acquire(lk);
8010436c:	e9 df 04 00 00       	jmp    80104850 <acquire>
80104371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104378:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010437b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104382:	e8 f9 fb ff ff       	call   80103f80 <sched>
  p->chan = 0;
80104387:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010438e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104391:	5b                   	pop    %ebx
80104392:	5e                   	pop    %esi
80104393:	5f                   	pop    %edi
80104394:	5d                   	pop    %ebp
80104395:	c3                   	ret    
    panic("sleep without lk");
80104396:	83 ec 0c             	sub    $0xc,%esp
80104399:	68 1a 7e 10 80       	push   $0x80107e1a
8010439e:	e8 dd bf ff ff       	call   80100380 <panic>
    panic("sleep");
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	68 14 7e 10 80       	push   $0x80107e14
801043ab:	e8 d0 bf ff ff       	call   80100380 <panic>

801043b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 10             	sub    $0x10,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ba:	68 40 2d 11 80       	push   $0x80112d40
801043bf:	e8 8c 04 00 00       	call   80104850 <acquire>
801043c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801043cc:	eb 0c                	jmp    801043da <wakeup+0x2a>
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	83 e8 80             	sub    $0xffffff80,%eax
801043d3:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801043d8:	74 1c                	je     801043f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801043da:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801043de:	75 f0                	jne    801043d0 <wakeup+0x20>
801043e0:	3b 58 24             	cmp    0x24(%eax),%ebx
801043e3:	75 eb                	jne    801043d0 <wakeup+0x20>
      p->state = RUNNABLE;
801043e5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ec:	83 e8 80             	sub    $0xffffff80,%eax
801043ef:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801043f4:	75 e4                	jne    801043da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801043f6:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
801043fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104400:	c9                   	leave  
  release(&ptable.lock);
80104401:	e9 ea 03 00 00       	jmp    801047f0 <release>
80104406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440d:	8d 76 00             	lea    0x0(%esi),%esi

80104410 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 10             	sub    $0x10,%esp
80104417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010441a:	68 40 2d 11 80       	push   $0x80112d40
8010441f:	e8 2c 04 00 00       	call   80104850 <acquire>
80104424:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104427:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010442c:	eb 0c                	jmp    8010443a <kill+0x2a>
8010442e:	66 90                	xchg   %ax,%ax
80104430:	83 e8 80             	sub    $0xffffff80,%eax
80104433:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104438:	74 36                	je     80104470 <kill+0x60>
    if(p->pid == pid){
8010443a:	39 58 14             	cmp    %ebx,0x14(%eax)
8010443d:	75 f1                	jne    80104430 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010443f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
80104443:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
8010444a:	75 07                	jne    80104453 <kill+0x43>
        p->state = RUNNABLE;
8010444c:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 40 2d 11 80       	push   $0x80112d40
8010445b:	e8 90 03 00 00       	call   801047f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104463:	83 c4 10             	add    $0x10,%esp
80104466:	31 c0                	xor    %eax,%eax
}
80104468:	c9                   	leave  
80104469:	c3                   	ret    
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104470:	83 ec 0c             	sub    $0xc,%esp
80104473:	68 40 2d 11 80       	push   $0x80112d40
80104478:	e8 73 03 00 00       	call   801047f0 <release>
}
8010447d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104480:	83 c4 10             	add    $0x10,%esp
80104483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104488:	c9                   	leave  
80104489:	c3                   	ret    
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104498:	53                   	push   %ebx
80104499:	bb e4 2d 11 80       	mov    $0x80112de4,%ebx
8010449e:	83 ec 3c             	sub    $0x3c,%esp
801044a1:	eb 24                	jmp    801044c7 <procdump+0x37>
801044a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	68 bb 81 10 80       	push   $0x801081bb
801044b0:	e8 eb c1 ff ff       	call   801006a0 <cprintf>
801044b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b8:	83 eb 80             	sub    $0xffffff80,%ebx
801044bb:	81 fb e4 4d 11 80    	cmp    $0x80114de4,%ebx
801044c1:	0f 84 81 00 00 00    	je     80104548 <procdump+0xb8>
    if(p->state == UNUSED)
801044c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044ca:	85 c0                	test   %eax,%eax
801044cc:	74 ea                	je     801044b8 <procdump+0x28>
      state = "???";
801044ce:	ba 2b 7e 10 80       	mov    $0x80107e2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044d3:	83 f8 05             	cmp    $0x5,%eax
801044d6:	77 11                	ja     801044e9 <procdump+0x59>
801044d8:	8b 14 85 8c 7e 10 80 	mov    -0x7fef8174(,%eax,4),%edx
      state = "???";
801044df:	b8 2b 7e 10 80       	mov    $0x80107e2b,%eax
801044e4:	85 d2                	test   %edx,%edx
801044e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044e9:	53                   	push   %ebx
801044ea:	52                   	push   %edx
801044eb:	ff 73 a4             	push   -0x5c(%ebx)
801044ee:	68 2f 7e 10 80       	push   $0x80107e2f
801044f3:	e8 a8 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801044f8:	83 c4 10             	add    $0x10,%esp
801044fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044ff:	75 a7                	jne    801044a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104501:	83 ec 08             	sub    $0x8,%esp
80104504:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104507:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010450a:	50                   	push   %eax
8010450b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010450e:	8b 40 0c             	mov    0xc(%eax),%eax
80104511:	83 c0 08             	add    $0x8,%eax
80104514:	50                   	push   %eax
80104515:	e8 86 01 00 00       	call   801046a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
80104520:	8b 17                	mov    (%edi),%edx
80104522:	85 d2                	test   %edx,%edx
80104524:	74 82                	je     801044a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104526:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104529:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010452c:	52                   	push   %edx
8010452d:	68 81 78 10 80       	push   $0x80107881
80104532:	e8 69 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104537:	83 c4 10             	add    $0x10,%esp
8010453a:	39 fe                	cmp    %edi,%esi
8010453c:	75 e2                	jne    80104520 <procdump+0x90>
8010453e:	e9 65 ff ff ff       	jmp    801044a8 <procdump+0x18>
80104543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104547:	90                   	nop
  }
}
80104548:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010454b:	5b                   	pop    %ebx
8010454c:	5e                   	pop    %esi
8010454d:	5f                   	pop    %edi
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret    

80104550 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 0c             	sub    $0xc,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010455a:	68 a4 7e 10 80       	push   $0x80107ea4
8010455f:	8d 43 04             	lea    0x4(%ebx),%eax
80104562:	50                   	push   %eax
80104563:	e8 18 01 00 00       	call   80104680 <initlock>
  lk->name = name;
80104568:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010456b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104571:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104574:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010457b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010457e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104581:	c9                   	leave  
80104582:	c3                   	ret    
80104583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	8d 73 04             	lea    0x4(%ebx),%esi
8010459b:	83 ec 0c             	sub    $0xc,%esp
8010459e:	56                   	push   %esi
8010459f:	e8 ac 02 00 00       	call   80104850 <acquire>
  while (lk->locked) {
801045a4:	8b 13                	mov    (%ebx),%edx
801045a6:	83 c4 10             	add    $0x10,%esp
801045a9:	85 d2                	test   %edx,%edx
801045ab:	74 16                	je     801045c3 <acquiresleep+0x33>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045b0:	83 ec 08             	sub    $0x8,%esp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	e8 36 fd ff ff       	call   801042f0 <sleep>
  while (lk->locked) {
801045ba:	8b 03                	mov    (%ebx),%eax
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	85 c0                	test   %eax,%eax
801045c1:	75 ed                	jne    801045b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045c9:	e8 c2 f5 ff ff       	call   80103b90 <myproc>
801045ce:	8b 40 14             	mov    0x14(%eax),%eax
801045d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045da:	5b                   	pop    %ebx
801045db:	5e                   	pop    %esi
801045dc:	5d                   	pop    %ebp
  release(&lk->lk);
801045dd:	e9 0e 02 00 00       	jmp    801047f0 <release>
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045f8:	8d 73 04             	lea    0x4(%ebx),%esi
801045fb:	83 ec 0c             	sub    $0xc,%esp
801045fe:	56                   	push   %esi
801045ff:	e8 4c 02 00 00       	call   80104850 <acquire>
  lk->locked = 0;
80104604:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010460a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104611:	89 1c 24             	mov    %ebx,(%esp)
80104614:	e8 97 fd ff ff       	call   801043b0 <wakeup>
  release(&lk->lk);
80104619:	89 75 08             	mov    %esi,0x8(%ebp)
8010461c:	83 c4 10             	add    $0x10,%esp
}
8010461f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104622:	5b                   	pop    %ebx
80104623:	5e                   	pop    %esi
80104624:	5d                   	pop    %ebp
  release(&lk->lk);
80104625:	e9 c6 01 00 00       	jmp    801047f0 <release>
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	57                   	push   %edi
80104634:	31 ff                	xor    %edi,%edi
80104636:	56                   	push   %esi
80104637:	53                   	push   %ebx
80104638:	83 ec 18             	sub    $0x18,%esp
8010463b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010463e:	8d 73 04             	lea    0x4(%ebx),%esi
80104641:	56                   	push   %esi
80104642:	e8 09 02 00 00       	call   80104850 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104647:	8b 03                	mov    (%ebx),%eax
80104649:	83 c4 10             	add    $0x10,%esp
8010464c:	85 c0                	test   %eax,%eax
8010464e:	75 18                	jne    80104668 <holdingsleep+0x38>
  release(&lk->lk);
80104650:	83 ec 0c             	sub    $0xc,%esp
80104653:	56                   	push   %esi
80104654:	e8 97 01 00 00       	call   801047f0 <release>
  return r;
}
80104659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010465c:	89 f8                	mov    %edi,%eax
8010465e:	5b                   	pop    %ebx
8010465f:	5e                   	pop    %esi
80104660:	5f                   	pop    %edi
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    
80104663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104667:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104668:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010466b:	e8 20 f5 ff ff       	call   80103b90 <myproc>
80104670:	39 58 14             	cmp    %ebx,0x14(%eax)
80104673:	0f 94 c0             	sete   %al
80104676:	0f b6 c0             	movzbl %al,%eax
80104679:	89 c7                	mov    %eax,%edi
8010467b:	eb d3                	jmp    80104650 <holdingsleep+0x20>
8010467d:	66 90                	xchg   %ax,%ax
8010467f:	90                   	nop

80104680 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104686:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010468f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104692:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104699:	5d                   	pop    %ebp
8010469a:	c3                   	ret    
8010469b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010469f:	90                   	nop

801046a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046a0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046a1:	31 d2                	xor    %edx,%edx
{
801046a3:	89 e5                	mov    %esp,%ebp
801046a5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046a6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046ac:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046b0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046bc:	77 1a                	ja     801046d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046be:	8b 58 04             	mov    0x4(%eax),%ebx
801046c1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046c4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046c7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046c9:	83 fa 0a             	cmp    $0xa,%edx
801046cc:	75 e2                	jne    801046b0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d1:	c9                   	leave  
801046d2:	c3                   	ret    
801046d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d7:	90                   	nop
  for(; i < 10; i++)
801046d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046db:	8d 51 28             	lea    0x28(%ecx),%edx
801046de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046e6:	83 c0 04             	add    $0x4,%eax
801046e9:	39 d0                	cmp    %edx,%eax
801046eb:	75 f3                	jne    801046e0 <getcallerpcs+0x40>
}
801046ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 04             	sub    $0x4,%esp
80104707:	9c                   	pushf  
80104708:	5b                   	pop    %ebx
  asm volatile("cli");
80104709:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010470a:	e8 01 f4 ff ff       	call   80103b10 <mycpu>
8010470f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104715:	85 c0                	test   %eax,%eax
80104717:	74 17                	je     80104730 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104719:	e8 f2 f3 ff ff       	call   80103b10 <mycpu>
8010471e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104728:	c9                   	leave  
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104730:	e8 db f3 ff ff       	call   80103b10 <mycpu>
80104735:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010473b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104741:	eb d6                	jmp    80104719 <pushcli+0x19>
80104743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <popcli>:

void
popcli(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104756:	9c                   	pushf  
80104757:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104758:	f6 c4 02             	test   $0x2,%ah
8010475b:	75 35                	jne    80104792 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010475d:	e8 ae f3 ff ff       	call   80103b10 <mycpu>
80104762:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104769:	78 34                	js     8010479f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010476b:	e8 a0 f3 ff ff       	call   80103b10 <mycpu>
80104770:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104776:	85 d2                	test   %edx,%edx
80104778:	74 06                	je     80104780 <popcli+0x30>
    sti();
}
8010477a:	c9                   	leave  
8010477b:	c3                   	ret    
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104780:	e8 8b f3 ff ff       	call   80103b10 <mycpu>
80104785:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010478b:	85 c0                	test   %eax,%eax
8010478d:	74 eb                	je     8010477a <popcli+0x2a>
  asm volatile("sti");
8010478f:	fb                   	sti    
}
80104790:	c9                   	leave  
80104791:	c3                   	ret    
    panic("popcli - interruptible");
80104792:	83 ec 0c             	sub    $0xc,%esp
80104795:	68 af 7e 10 80       	push   $0x80107eaf
8010479a:	e8 e1 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010479f:	83 ec 0c             	sub    $0xc,%esp
801047a2:	68 c6 7e 10 80       	push   $0x80107ec6
801047a7:	e8 d4 bb ff ff       	call   80100380 <panic>
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <holding>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 75 08             	mov    0x8(%ebp),%esi
801047b8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047ba:	e8 41 ff ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047bf:	8b 06                	mov    (%esi),%eax
801047c1:	85 c0                	test   %eax,%eax
801047c3:	75 0b                	jne    801047d0 <holding+0x20>
  popcli();
801047c5:	e8 86 ff ff ff       	call   80104750 <popcli>
}
801047ca:	89 d8                	mov    %ebx,%eax
801047cc:	5b                   	pop    %ebx
801047cd:	5e                   	pop    %esi
801047ce:	5d                   	pop    %ebp
801047cf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801047d0:	8b 5e 08             	mov    0x8(%esi),%ebx
801047d3:	e8 38 f3 ff ff       	call   80103b10 <mycpu>
801047d8:	39 c3                	cmp    %eax,%ebx
801047da:	0f 94 c3             	sete   %bl
  popcli();
801047dd:	e8 6e ff ff ff       	call   80104750 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801047e2:	0f b6 db             	movzbl %bl,%ebx
}
801047e5:	89 d8                	mov    %ebx,%eax
801047e7:	5b                   	pop    %ebx
801047e8:	5e                   	pop    %esi
801047e9:	5d                   	pop    %ebp
801047ea:	c3                   	ret    
801047eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ef:	90                   	nop

801047f0 <release>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047f8:	e8 03 ff ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047fd:	8b 03                	mov    (%ebx),%eax
801047ff:	85 c0                	test   %eax,%eax
80104801:	75 15                	jne    80104818 <release+0x28>
  popcli();
80104803:	e8 48 ff ff ff       	call   80104750 <popcli>
    panic("release");
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	68 cd 7e 10 80       	push   $0x80107ecd
80104810:	e8 6b bb ff ff       	call   80100380 <panic>
80104815:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104818:	8b 73 08             	mov    0x8(%ebx),%esi
8010481b:	e8 f0 f2 ff ff       	call   80103b10 <mycpu>
80104820:	39 c6                	cmp    %eax,%esi
80104822:	75 df                	jne    80104803 <release+0x13>
  popcli();
80104824:	e8 27 ff ff ff       	call   80104750 <popcli>
  lk->pcs[0] = 0;
80104829:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104830:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104837:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010483c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104842:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104845:	5b                   	pop    %ebx
80104846:	5e                   	pop    %esi
80104847:	5d                   	pop    %ebp
  popcli();
80104848:	e9 03 ff ff ff       	jmp    80104750 <popcli>
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

80104850 <acquire>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
80104854:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104857:	e8 a4 fe ff ff       	call   80104700 <pushcli>
  if(holding(lk))
8010485c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010485f:	e8 9c fe ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104864:	8b 03                	mov    (%ebx),%eax
80104866:	85 c0                	test   %eax,%eax
80104868:	75 7e                	jne    801048e8 <acquire+0x98>
  popcli();
8010486a:	e8 e1 fe ff ff       	call   80104750 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010486f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104878:	8b 55 08             	mov    0x8(%ebp),%edx
8010487b:	89 c8                	mov    %ecx,%eax
8010487d:	f0 87 02             	lock xchg %eax,(%edx)
80104880:	85 c0                	test   %eax,%eax
80104882:	75 f4                	jne    80104878 <acquire+0x28>
  __sync_synchronize();
80104884:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104889:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010488c:	e8 7f f2 ff ff       	call   80103b10 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104891:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104894:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104896:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104899:	31 c0                	xor    %eax,%eax
8010489b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010489f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048ac:	77 1a                	ja     801048c8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801048ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801048b1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048b5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048b8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048ba:	83 f8 0a             	cmp    $0xa,%eax
801048bd:	75 e1                	jne    801048a0 <acquire+0x50>
}
801048bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c2:	c9                   	leave  
801048c3:	c3                   	ret    
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801048c8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801048cc:	8d 51 34             	lea    0x34(%ecx),%edx
801048cf:	90                   	nop
    pcs[i] = 0;
801048d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048d6:	83 c0 04             	add    $0x4,%eax
801048d9:	39 c2                	cmp    %eax,%edx
801048db:	75 f3                	jne    801048d0 <acquire+0x80>
}
801048dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e0:	c9                   	leave  
801048e1:	c3                   	ret    
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048e8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801048eb:	e8 20 f2 ff ff       	call   80103b10 <mycpu>
801048f0:	39 c3                	cmp    %eax,%ebx
801048f2:	0f 85 72 ff ff ff    	jne    8010486a <acquire+0x1a>
  popcli();
801048f8:	e8 53 fe ff ff       	call   80104750 <popcli>
    panic("acquire");
801048fd:	83 ec 0c             	sub    $0xc,%esp
80104900:	68 d5 7e 10 80       	push   $0x80107ed5
80104905:	e8 76 ba ff ff       	call   80100380 <panic>
8010490a:	66 90                	xchg   %ax,%ax
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <memset>:
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	8b 55 08             	mov    0x8(%ebp),%edx
80104917:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010491a:	53                   	push   %ebx
8010491b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010491e:	89 d7                	mov    %edx,%edi
80104920:	09 cf                	or     %ecx,%edi
80104922:	83 e7 03             	and    $0x3,%edi
80104925:	75 29                	jne    80104950 <memset+0x40>
80104927:	0f b6 f8             	movzbl %al,%edi
8010492a:	c1 e0 18             	shl    $0x18,%eax
8010492d:	89 fb                	mov    %edi,%ebx
8010492f:	c1 e9 02             	shr    $0x2,%ecx
80104932:	c1 e3 10             	shl    $0x10,%ebx
80104935:	09 d8                	or     %ebx,%eax
80104937:	09 f8                	or     %edi,%eax
80104939:	c1 e7 08             	shl    $0x8,%edi
8010493c:	09 f8                	or     %edi,%eax
8010493e:	89 d7                	mov    %edx,%edi
80104940:	fc                   	cld    
80104941:	f3 ab                	rep stos %eax,%es:(%edi)
80104943:	5b                   	pop    %ebx
80104944:	89 d0                	mov    %edx,%eax
80104946:	5f                   	pop    %edi
80104947:	5d                   	pop    %ebp
80104948:	c3                   	ret    
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104950:	89 d7                	mov    %edx,%edi
80104952:	fc                   	cld    
80104953:	f3 aa                	rep stos %al,%es:(%edi)
80104955:	5b                   	pop    %ebx
80104956:	89 d0                	mov    %edx,%eax
80104958:	5f                   	pop    %edi
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret    
8010495b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop

80104960 <memcmp>:
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	8b 75 10             	mov    0x10(%ebp),%esi
80104967:	8b 55 08             	mov    0x8(%ebp),%edx
8010496a:	53                   	push   %ebx
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010496e:	85 f6                	test   %esi,%esi
80104970:	74 2e                	je     801049a0 <memcmp+0x40>
80104972:	01 c6                	add    %eax,%esi
80104974:	eb 14                	jmp    8010498a <memcmp+0x2a>
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	83 c2 01             	add    $0x1,%edx
80104986:	39 f0                	cmp    %esi,%eax
80104988:	74 16                	je     801049a0 <memcmp+0x40>
8010498a:	0f b6 0a             	movzbl (%edx),%ecx
8010498d:	0f b6 18             	movzbl (%eax),%ebx
80104990:	38 d9                	cmp    %bl,%cl
80104992:	74 ec                	je     80104980 <memcmp+0x20>
80104994:	0f b6 c1             	movzbl %cl,%eax
80104997:	29 d8                	sub    %ebx,%eax
80104999:	5b                   	pop    %ebx
8010499a:	5e                   	pop    %esi
8010499b:	5d                   	pop    %ebp
8010499c:	c3                   	ret    
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
801049a0:	5b                   	pop    %ebx
801049a1:	31 c0                	xor    %eax,%eax
801049a3:	5e                   	pop    %esi
801049a4:	5d                   	pop    %ebp
801049a5:	c3                   	ret    
801049a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ad:	8d 76 00             	lea    0x0(%esi),%esi

801049b0 <memmove>:
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	8b 55 08             	mov    0x8(%ebp),%edx
801049b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ba:	56                   	push   %esi
801049bb:	8b 75 0c             	mov    0xc(%ebp),%esi
801049be:	39 d6                	cmp    %edx,%esi
801049c0:	73 26                	jae    801049e8 <memmove+0x38>
801049c2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801049c5:	39 fa                	cmp    %edi,%edx
801049c7:	73 1f                	jae    801049e8 <memmove+0x38>
801049c9:	8d 41 ff             	lea    -0x1(%ecx),%eax
801049cc:	85 c9                	test   %ecx,%ecx
801049ce:	74 0c                	je     801049dc <memmove+0x2c>
801049d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049d4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
801049d7:	83 e8 01             	sub    $0x1,%eax
801049da:	73 f4                	jae    801049d0 <memmove+0x20>
801049dc:	5e                   	pop    %esi
801049dd:	89 d0                	mov    %edx,%eax
801049df:	5f                   	pop    %edi
801049e0:	5d                   	pop    %ebp
801049e1:	c3                   	ret    
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049e8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801049eb:	89 d7                	mov    %edx,%edi
801049ed:	85 c9                	test   %ecx,%ecx
801049ef:	74 eb                	je     801049dc <memmove+0x2c>
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
801049f9:	39 c6                	cmp    %eax,%esi
801049fb:	75 fb                	jne    801049f8 <memmove+0x48>
801049fd:	5e                   	pop    %esi
801049fe:	89 d0                	mov    %edx,%eax
80104a00:	5f                   	pop    %edi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a10 <memcpy>:
80104a10:	eb 9e                	jmp    801049b0 <memmove>
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a20 <strncmp>:
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	8b 75 10             	mov    0x10(%ebp),%esi
80104a27:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a2a:	53                   	push   %ebx
80104a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a2e:	85 f6                	test   %esi,%esi
80104a30:	74 2e                	je     80104a60 <strncmp+0x40>
80104a32:	01 d6                	add    %edx,%esi
80104a34:	eb 18                	jmp    80104a4e <strncmp+0x2e>
80104a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	38 d8                	cmp    %bl,%al
80104a42:	75 14                	jne    80104a58 <strncmp+0x38>
80104a44:	83 c2 01             	add    $0x1,%edx
80104a47:	83 c1 01             	add    $0x1,%ecx
80104a4a:	39 f2                	cmp    %esi,%edx
80104a4c:	74 12                	je     80104a60 <strncmp+0x40>
80104a4e:	0f b6 01             	movzbl (%ecx),%eax
80104a51:	0f b6 1a             	movzbl (%edx),%ebx
80104a54:	84 c0                	test   %al,%al
80104a56:	75 e8                	jne    80104a40 <strncmp+0x20>
80104a58:	29 d8                	sub    %ebx,%eax
80104a5a:	5b                   	pop    %ebx
80104a5b:	5e                   	pop    %esi
80104a5c:	5d                   	pop    %ebp
80104a5d:	c3                   	ret    
80104a5e:	66 90                	xchg   %ax,%ax
80104a60:	5b                   	pop    %ebx
80104a61:	31 c0                	xor    %eax,%eax
80104a63:	5e                   	pop    %esi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
80104a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <strncpy>:
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	8b 75 08             	mov    0x8(%ebp),%esi
80104a78:	53                   	push   %ebx
80104a79:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a7c:	89 f0                	mov    %esi,%eax
80104a7e:	eb 15                	jmp    80104a95 <strncpy+0x25>
80104a80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a84:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a87:	83 c0 01             	add    $0x1,%eax
80104a8a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a8e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a91:	84 d2                	test   %dl,%dl
80104a93:	74 09                	je     80104a9e <strncpy+0x2e>
80104a95:	89 cb                	mov    %ecx,%ebx
80104a97:	83 e9 01             	sub    $0x1,%ecx
80104a9a:	85 db                	test   %ebx,%ebx
80104a9c:	7f e2                	jg     80104a80 <strncpy+0x10>
80104a9e:	89 c2                	mov    %eax,%edx
80104aa0:	85 c9                	test   %ecx,%ecx
80104aa2:	7e 17                	jle    80104abb <strncpy+0x4b>
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aa8:	83 c2 01             	add    $0x1,%edx
80104aab:	89 c1                	mov    %eax,%ecx
80104aad:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80104ab1:	29 d1                	sub    %edx,%ecx
80104ab3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104ab7:	85 c9                	test   %ecx,%ecx
80104ab9:	7f ed                	jg     80104aa8 <strncpy+0x38>
80104abb:	5b                   	pop    %ebx
80104abc:	89 f0                	mov    %esi,%eax
80104abe:	5e                   	pop    %esi
80104abf:	5f                   	pop    %edi
80104ac0:	5d                   	pop    %ebp
80104ac1:	c3                   	ret    
80104ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <safestrcpy>:
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ad7:	8b 75 08             	mov    0x8(%ebp),%esi
80104ada:	53                   	push   %ebx
80104adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ade:	85 d2                	test   %edx,%edx
80104ae0:	7e 25                	jle    80104b07 <safestrcpy+0x37>
80104ae2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ae6:	89 f2                	mov    %esi,%edx
80104ae8:	eb 16                	jmp    80104b00 <safestrcpy+0x30>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af0:	0f b6 08             	movzbl (%eax),%ecx
80104af3:	83 c0 01             	add    $0x1,%eax
80104af6:	83 c2 01             	add    $0x1,%edx
80104af9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104afc:	84 c9                	test   %cl,%cl
80104afe:	74 04                	je     80104b04 <safestrcpy+0x34>
80104b00:	39 d8                	cmp    %ebx,%eax
80104b02:	75 ec                	jne    80104af0 <safestrcpy+0x20>
80104b04:	c6 02 00             	movb   $0x0,(%edx)
80104b07:	89 f0                	mov    %esi,%eax
80104b09:	5b                   	pop    %ebx
80104b0a:	5e                   	pop    %esi
80104b0b:	5d                   	pop    %ebp
80104b0c:	c3                   	ret    
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <strlen>:
80104b10:	55                   	push   %ebp
80104b11:	31 c0                	xor    %eax,%eax
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	8b 55 08             	mov    0x8(%ebp),%edx
80104b18:	80 3a 00             	cmpb   $0x0,(%edx)
80104b1b:	74 0c                	je     80104b29 <strlen+0x19>
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
80104b20:	83 c0 01             	add    $0x1,%eax
80104b23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b27:	75 f7                	jne    80104b20 <strlen+0x10>
80104b29:	5d                   	pop    %ebp
80104b2a:	c3                   	ret    

80104b2b <swtch>:
80104b2b:	8b 44 24 04          	mov    0x4(%esp),%eax
80104b2f:	8b 54 24 08          	mov    0x8(%esp),%edx
80104b33:	55                   	push   %ebp
80104b34:	53                   	push   %ebx
80104b35:	56                   	push   %esi
80104b36:	57                   	push   %edi
80104b37:	89 20                	mov    %esp,(%eax)
80104b39:	89 d4                	mov    %edx,%esp
80104b3b:	5f                   	pop    %edi
80104b3c:	5e                   	pop    %esi
80104b3d:	5b                   	pop    %ebx
80104b3e:	5d                   	pop    %ebp
80104b3f:	c3                   	ret    

80104b40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	53                   	push   %ebx
80104b44:	83 ec 04             	sub    $0x4,%esp
80104b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b4a:	e8 41 f0 ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b4f:	8b 00                	mov    (%eax),%eax
80104b51:	39 d8                	cmp    %ebx,%eax
80104b53:	76 1b                	jbe    80104b70 <fetchint+0x30>
80104b55:	8d 53 04             	lea    0x4(%ebx),%edx
80104b58:	39 d0                	cmp    %edx,%eax
80104b5a:	72 14                	jb     80104b70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5f:	8b 13                	mov    (%ebx),%edx
80104b61:	89 10                	mov    %edx,(%eax)
  return 0;
80104b63:	31 c0                	xor    %eax,%eax
}
80104b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b68:	c9                   	leave  
80104b69:	c3                   	ret    
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b75:	eb ee                	jmp    80104b65 <fetchint+0x25>
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b8a:	e8 01 f0 ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz)
80104b8f:	39 18                	cmp    %ebx,(%eax)
80104b91:	76 2d                	jbe    80104bc0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b93:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b96:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b98:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b9a:	39 d3                	cmp    %edx,%ebx
80104b9c:	73 22                	jae    80104bc0 <fetchstr+0x40>
80104b9e:	89 d8                	mov    %ebx,%eax
80104ba0:	eb 0d                	jmp    80104baf <fetchstr+0x2f>
80104ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ba8:	83 c0 01             	add    $0x1,%eax
80104bab:	39 c2                	cmp    %eax,%edx
80104bad:	76 11                	jbe    80104bc0 <fetchstr+0x40>
    if(*s == 0)
80104baf:	80 38 00             	cmpb   $0x0,(%eax)
80104bb2:	75 f4                	jne    80104ba8 <fetchstr+0x28>
      return s - *pp;
80104bb4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104bb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb9:	c9                   	leave  
80104bba:	c3                   	ret    
80104bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop
80104bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd5:	e8 b6 ef ff ff       	call   80103b90 <myproc>
80104bda:	8b 55 08             	mov    0x8(%ebp),%edx
80104bdd:	8b 40 1c             	mov    0x1c(%eax),%eax
80104be0:	8b 40 44             	mov    0x44(%eax),%eax
80104be3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104be6:	e8 a5 ef ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104beb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bee:	8b 00                	mov    (%eax),%eax
80104bf0:	39 c6                	cmp    %eax,%esi
80104bf2:	73 1c                	jae    80104c10 <argint+0x40>
80104bf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bf7:	39 d0                	cmp    %edx,%eax
80104bf9:	72 15                	jb     80104c10 <argint+0x40>
  *ip = *(int*)(addr);
80104bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bfe:	8b 53 04             	mov    0x4(%ebx),%edx
80104c01:	89 10                	mov    %edx,(%eax)
  return 0;
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	5b                   	pop    %ebx
80104c06:	5e                   	pop    %esi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	eb ee                	jmp    80104c05 <argint+0x35>
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	56                   	push   %esi
80104c25:	53                   	push   %ebx
80104c26:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c29:	e8 62 ef ff ff       	call   80103b90 <myproc>
80104c2e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c30:	e8 5b ef ff ff       	call   80103b90 <myproc>
80104c35:	8b 55 08             	mov    0x8(%ebp),%edx
80104c38:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c3b:	8b 40 44             	mov    0x44(%eax),%eax
80104c3e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c41:	e8 4a ef ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c46:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c49:	8b 00                	mov    (%eax),%eax
80104c4b:	39 c7                	cmp    %eax,%edi
80104c4d:	73 31                	jae    80104c80 <argptr+0x60>
80104c4f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c52:	39 c8                	cmp    %ecx,%eax
80104c54:	72 2a                	jb     80104c80 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c56:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c59:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c5c:	85 d2                	test   %edx,%edx
80104c5e:	78 20                	js     80104c80 <argptr+0x60>
80104c60:	8b 16                	mov    (%esi),%edx
80104c62:	39 c2                	cmp    %eax,%edx
80104c64:	76 1a                	jbe    80104c80 <argptr+0x60>
80104c66:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c69:	01 c3                	add    %eax,%ebx
80104c6b:	39 da                	cmp    %ebx,%edx
80104c6d:	72 11                	jb     80104c80 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c72:	89 02                	mov    %eax,(%edx)
  return 0;
80104c74:	31 c0                	xor    %eax,%eax
}
80104c76:	83 c4 0c             	add    $0xc,%esp
80104c79:	5b                   	pop    %ebx
80104c7a:	5e                   	pop    %esi
80104c7b:	5f                   	pop    %edi
80104c7c:	5d                   	pop    %ebp
80104c7d:	c3                   	ret    
80104c7e:	66 90                	xchg   %ax,%ax
    return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c85:	eb ef                	jmp    80104c76 <argptr+0x56>
80104c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c95:	e8 f6 ee ff ff       	call   80103b90 <myproc>
80104c9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c9d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ca0:	8b 40 44             	mov    0x44(%eax),%eax
80104ca3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ca6:	e8 e5 ee ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cae:	8b 00                	mov    (%eax),%eax
80104cb0:	39 c6                	cmp    %eax,%esi
80104cb2:	73 44                	jae    80104cf8 <argstr+0x68>
80104cb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cb7:	39 d0                	cmp    %edx,%eax
80104cb9:	72 3d                	jb     80104cf8 <argstr+0x68>
  *ip = *(int*)(addr);
80104cbb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104cbe:	e8 cd ee ff ff       	call   80103b90 <myproc>
  if(addr >= curproc->sz)
80104cc3:	3b 18                	cmp    (%eax),%ebx
80104cc5:	73 31                	jae    80104cf8 <argstr+0x68>
  *pp = (char*)addr;
80104cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ccc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cce:	39 d3                	cmp    %edx,%ebx
80104cd0:	73 26                	jae    80104cf8 <argstr+0x68>
80104cd2:	89 d8                	mov    %ebx,%eax
80104cd4:	eb 11                	jmp    80104ce7 <argstr+0x57>
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
80104ce0:	83 c0 01             	add    $0x1,%eax
80104ce3:	39 c2                	cmp    %eax,%edx
80104ce5:	76 11                	jbe    80104cf8 <argstr+0x68>
    if(*s == 0)
80104ce7:	80 38 00             	cmpb   $0x0,(%eax)
80104cea:	75 f4                	jne    80104ce0 <argstr+0x50>
      return s - *pp;
80104cec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cee:	5b                   	pop    %ebx
80104cef:	5e                   	pop    %esi
80104cf0:	5d                   	pop    %ebp
80104cf1:	c3                   	ret    
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf8:	5b                   	pop    %ebx
    return -1;
80104cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cfe:	5e                   	pop    %esi
80104cff:	5d                   	pop    %ebp
80104d00:	c3                   	ret    
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop

80104d10 <syscall>:
[SYS_shugebrk] sys_shugebrk, // part 2
};

void
syscall(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
80104d14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d17:	e8 74 ee ff ff       	call   80103b90 <myproc>
80104d1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d1e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d27:	83 fa 17             	cmp    $0x17,%edx
80104d2a:	77 24                	ja     80104d50 <syscall+0x40>
80104d2c:	8b 14 85 00 7f 10 80 	mov    -0x7fef8100(,%eax,4),%edx
80104d33:	85 d2                	test   %edx,%edx
80104d35:	74 19                	je     80104d50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d37:	ff d2                	call   *%edx
80104d39:	89 c2                	mov    %eax,%edx
80104d3b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d3e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d44:	c9                   	leave  
80104d45:	c3                   	ret    
80104d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d51:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d54:	50                   	push   %eax
80104d55:	ff 73 14             	push   0x14(%ebx)
80104d58:	68 dd 7e 10 80       	push   $0x80107edd
80104d5d:	e8 3e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d62:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d65:	83 c4 10             	add    $0x10,%esp
80104d68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d72:	c9                   	leave  
80104d73:	c3                   	ret    
80104d74:	66 90                	xchg   %ax,%ax
80104d76:	66 90                	xchg   %ax,%ax
80104d78:	66 90                	xchg   %ax,%ax
80104d7a:	66 90                	xchg   %ax,%ax
80104d7c:	66 90                	xchg   %ax,%ax
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d88:	53                   	push   %ebx
80104d89:	83 ec 34             	sub    $0x34,%esp
80104d8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d92:	57                   	push   %edi
80104d93:	50                   	push   %eax
{
80104d94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d9a:	e8 31 d3 ff ff       	call   801020d0 <nameiparent>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	0f 84 46 01 00 00    	je     80104ef0 <create+0x170>
    return 0;
  ilock(dp);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	89 c3                	mov    %eax,%ebx
80104daf:	50                   	push   %eax
80104db0:	e8 db c9 ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104db5:	83 c4 0c             	add    $0xc,%esp
80104db8:	6a 00                	push   $0x0
80104dba:	57                   	push   %edi
80104dbb:	53                   	push   %ebx
80104dbc:	e8 2f cf ff ff       	call   80101cf0 <dirlookup>
80104dc1:	83 c4 10             	add    $0x10,%esp
80104dc4:	89 c6                	mov    %eax,%esi
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	74 56                	je     80104e20 <create+0xa0>
    iunlockput(dp);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	53                   	push   %ebx
80104dce:	e8 4d cc ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104dd3:	89 34 24             	mov    %esi,(%esp)
80104dd6:	e8 b5 c9 ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ddb:	83 c4 10             	add    $0x10,%esp
80104dde:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104de3:	75 1b                	jne    80104e00 <create+0x80>
80104de5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dea:	75 14                	jne    80104e00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104def:	89 f0                	mov    %esi,%eax
80104df1:	5b                   	pop    %ebx
80104df2:	5e                   	pop    %esi
80104df3:	5f                   	pop    %edi
80104df4:	5d                   	pop    %ebp
80104df5:	c3                   	ret    
80104df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	56                   	push   %esi
    return 0;
80104e04:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e06:	e8 15 cc ff ff       	call   80101a20 <iunlockput>
    return 0;
80104e0b:	83 c4 10             	add    $0x10,%esp
}
80104e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e11:	89 f0                	mov    %esi,%eax
80104e13:	5b                   	pop    %ebx
80104e14:	5e                   	pop    %esi
80104e15:	5f                   	pop    %edi
80104e16:	5d                   	pop    %ebp
80104e17:	c3                   	ret    
80104e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	50                   	push   %eax
80104e28:	ff 33                	push   (%ebx)
80104e2a:	e8 f1 c7 ff ff       	call   80101620 <ialloc>
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	89 c6                	mov    %eax,%esi
80104e34:	85 c0                	test   %eax,%eax
80104e36:	0f 84 cd 00 00 00    	je     80104f09 <create+0x189>
  ilock(ip);
80104e3c:	83 ec 0c             	sub    $0xc,%esp
80104e3f:	50                   	push   %eax
80104e40:	e8 4b c9 ff ff       	call   80101790 <ilock>
  ip->major = major;
80104e45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e49:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e51:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e55:	b8 01 00 00 00       	mov    $0x1,%eax
80104e5a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e5e:	89 34 24             	mov    %esi,(%esp)
80104e61:	e8 7a c8 ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e66:	83 c4 10             	add    $0x10,%esp
80104e69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e6e:	74 30                	je     80104ea0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e70:	83 ec 04             	sub    $0x4,%esp
80104e73:	ff 76 04             	push   0x4(%esi)
80104e76:	57                   	push   %edi
80104e77:	53                   	push   %ebx
80104e78:	e8 73 d1 ff ff       	call   80101ff0 <dirlink>
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 78                	js     80104efc <create+0x17c>
  iunlockput(dp);
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	53                   	push   %ebx
80104e88:	e8 93 cb ff ff       	call   80101a20 <iunlockput>
  return ip;
80104e8d:	83 c4 10             	add    $0x10,%esp
}
80104e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e93:	89 f0                	mov    %esi,%eax
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5f                   	pop    %edi
80104e98:	5d                   	pop    %ebp
80104e99:	c3                   	ret    
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ea3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ea8:	53                   	push   %ebx
80104ea9:	e8 32 c8 ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eae:	83 c4 0c             	add    $0xc,%esp
80104eb1:	ff 76 04             	push   0x4(%esi)
80104eb4:	68 80 7f 10 80       	push   $0x80107f80
80104eb9:	56                   	push   %esi
80104eba:	e8 31 d1 ff ff       	call   80101ff0 <dirlink>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	78 18                	js     80104ede <create+0x15e>
80104ec6:	83 ec 04             	sub    $0x4,%esp
80104ec9:	ff 73 04             	push   0x4(%ebx)
80104ecc:	68 7f 7f 10 80       	push   $0x80107f7f
80104ed1:	56                   	push   %esi
80104ed2:	e8 19 d1 ff ff       	call   80101ff0 <dirlink>
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	85 c0                	test   %eax,%eax
80104edc:	79 92                	jns    80104e70 <create+0xf0>
      panic("create dots");
80104ede:	83 ec 0c             	sub    $0xc,%esp
80104ee1:	68 73 7f 10 80       	push   $0x80107f73
80104ee6:	e8 95 b4 ff ff       	call   80100380 <panic>
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ef3:	31 f6                	xor    %esi,%esi
}
80104ef5:	5b                   	pop    %ebx
80104ef6:	89 f0                	mov    %esi,%eax
80104ef8:	5e                   	pop    %esi
80104ef9:	5f                   	pop    %edi
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret    
    panic("create: dirlink");
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	68 82 7f 10 80       	push   $0x80107f82
80104f04:	e8 77 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	68 64 7f 10 80       	push   $0x80107f64
80104f11:	e8 6a b4 ff ff       	call   80100380 <panic>
80104f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi

80104f20 <sys_dup>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	50                   	push   %eax
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 9d fc ff ff       	call   80104bd0 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 36                	js     80104f70 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 30                	ja     80104f70 <sys_dup+0x50>
80104f40:	e8 4b ec ff ff       	call   80103b90 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 20                	je     80104f70 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f50:	e8 3b ec ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f55:	31 db                	xor    %ebx,%ebx
80104f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f60:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104f64:	85 d2                	test   %edx,%edx
80104f66:	74 18                	je     80104f80 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	83 fb 10             	cmp    $0x10,%ebx
80104f6e:	75 f0                	jne    80104f60 <sys_dup+0x40>
}
80104f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f78:	89 d8                	mov    %ebx,%eax
80104f7a:	5b                   	pop    %ebx
80104f7b:	5e                   	pop    %esi
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret    
80104f7e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f80:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f83:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104f87:	56                   	push   %esi
80104f88:	e8 23 bf ff ff       	call   80100eb0 <filedup>
  return fd;
80104f8d:	83 c4 10             	add    $0x10,%esp
}
80104f90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f93:	89 d8                	mov    %ebx,%eax
80104f95:	5b                   	pop    %ebx
80104f96:	5e                   	pop    %esi
80104f97:	5d                   	pop    %ebp
80104f98:	c3                   	ret    
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <sys_read>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 1d fc ff ff       	call   80104bd0 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 5e                	js     80105018 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 58                	ja     80105018 <sys_read+0x78>
80104fc0:	e8 cb eb ff ff       	call   80103b90 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 48                	je     80105018 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	6a 02                	push   $0x2
80104fd9:	e8 f2 fb ff ff       	call   80104bd0 <argint>
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 33                	js     80105018 <sys_read+0x78>
80104fe5:	83 ec 04             	sub    $0x4,%esp
80104fe8:	ff 75 f0             	push   -0x10(%ebp)
80104feb:	53                   	push   %ebx
80104fec:	6a 01                	push   $0x1
80104fee:	e8 2d fc ff ff       	call   80104c20 <argptr>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 1e                	js     80105018 <sys_read+0x78>
  return fileread(f, p, n);
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	ff 75 f0             	push   -0x10(%ebp)
80105000:	ff 75 f4             	push   -0xc(%ebp)
80105003:	56                   	push   %esi
80105004:	e8 27 c0 ff ff       	call   80101030 <fileread>
80105009:	83 c4 10             	add    $0x10,%esp
}
8010500c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105017:	90                   	nop
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ed                	jmp    8010500c <sys_read+0x6c>
8010501f:	90                   	nop

80105020 <sys_write>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	53                   	push   %ebx
8010502c:	6a 00                	push   $0x0
8010502e:	e8 9d fb ff ff       	call   80104bd0 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 5e                	js     80105098 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 58                	ja     80105098 <sys_write+0x78>
80105040:	e8 4b eb ff ff       	call   80103b90 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010504c:	85 f6                	test   %esi,%esi
8010504e:	74 48                	je     80105098 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105050:	83 ec 08             	sub    $0x8,%esp
80105053:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105056:	50                   	push   %eax
80105057:	6a 02                	push   $0x2
80105059:	e8 72 fb ff ff       	call   80104bd0 <argint>
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	85 c0                	test   %eax,%eax
80105063:	78 33                	js     80105098 <sys_write+0x78>
80105065:	83 ec 04             	sub    $0x4,%esp
80105068:	ff 75 f0             	push   -0x10(%ebp)
8010506b:	53                   	push   %ebx
8010506c:	6a 01                	push   $0x1
8010506e:	e8 ad fb ff ff       	call   80104c20 <argptr>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 1e                	js     80105098 <sys_write+0x78>
  return filewrite(f, p, n);
8010507a:	83 ec 04             	sub    $0x4,%esp
8010507d:	ff 75 f0             	push   -0x10(%ebp)
80105080:	ff 75 f4             	push   -0xc(%ebp)
80105083:	56                   	push   %esi
80105084:	e8 37 c0 ff ff       	call   801010c0 <filewrite>
80105089:	83 c4 10             	add    $0x10,%esp
}
8010508c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010508f:	5b                   	pop    %ebx
80105090:	5e                   	pop    %esi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret    
80105093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105097:	90                   	nop
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb ed                	jmp    8010508c <sys_write+0x6c>
8010509f:	90                   	nop

801050a0 <sys_close>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ab:	50                   	push   %eax
801050ac:	6a 00                	push   $0x0
801050ae:	e8 1d fb ff ff       	call   80104bd0 <argint>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 3e                	js     801050f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050be:	77 38                	ja     801050f8 <sys_close+0x58>
801050c0:	e8 cb ea ff ff       	call   80103b90 <myproc>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801050cb:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
801050cf:	85 f6                	test   %esi,%esi
801050d1:	74 25                	je     801050f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050d3:	e8 b8 ea ff ff       	call   80103b90 <myproc>
  fileclose(f);
801050d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050db:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
801050e2:	00 
  fileclose(f);
801050e3:	56                   	push   %esi
801050e4:	e8 17 be ff ff       	call   80100f00 <fileclose>
  return 0;
801050e9:	83 c4 10             	add    $0x10,%esp
801050ec:	31 c0                	xor    %eax,%eax
}
801050ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f1:	5b                   	pop    %ebx
801050f2:	5e                   	pop    %esi
801050f3:	5d                   	pop    %ebp
801050f4:	c3                   	ret    
801050f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fd:	eb ef                	jmp    801050ee <sys_close+0x4e>
801050ff:	90                   	nop

80105100 <sys_fstat>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105105:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105108:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010510b:	53                   	push   %ebx
8010510c:	6a 00                	push   $0x0
8010510e:	e8 bd fa ff ff       	call   80104bd0 <argint>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 46                	js     80105160 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010511a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010511e:	77 40                	ja     80105160 <sys_fstat+0x60>
80105120:	e8 6b ea ff ff       	call   80103b90 <myproc>
80105125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105128:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010512c:	85 f6                	test   %esi,%esi
8010512e:	74 30                	je     80105160 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105130:	83 ec 04             	sub    $0x4,%esp
80105133:	6a 14                	push   $0x14
80105135:	53                   	push   %ebx
80105136:	6a 01                	push   $0x1
80105138:	e8 e3 fa ff ff       	call   80104c20 <argptr>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	78 1c                	js     80105160 <sys_fstat+0x60>
  return filestat(f, st);
80105144:	83 ec 08             	sub    $0x8,%esp
80105147:	ff 75 f4             	push   -0xc(%ebp)
8010514a:	56                   	push   %esi
8010514b:	e8 90 be ff ff       	call   80100fe0 <filestat>
80105150:	83 c4 10             	add    $0x10,%esp
}
80105153:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105156:	5b                   	pop    %ebx
80105157:	5e                   	pop    %esi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb ec                	jmp    80105153 <sys_fstat+0x53>
80105167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516e:	66 90                	xchg   %ax,%ax

80105170 <sys_link>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105175:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105178:	53                   	push   %ebx
80105179:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010517c:	50                   	push   %eax
8010517d:	6a 00                	push   $0x0
8010517f:	e8 0c fb ff ff       	call   80104c90 <argstr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	0f 88 fb 00 00 00    	js     8010528a <sys_link+0x11a>
8010518f:	83 ec 08             	sub    $0x8,%esp
80105192:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105195:	50                   	push   %eax
80105196:	6a 01                	push   $0x1
80105198:	e8 f3 fa ff ff       	call   80104c90 <argstr>
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	0f 88 e2 00 00 00    	js     8010528a <sys_link+0x11a>
  begin_op();
801051a8:	e8 c3 dd ff ff       	call   80102f70 <begin_op>
  if((ip = namei(old)) == 0){
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	ff 75 d4             	push   -0x2c(%ebp)
801051b3:	e8 f8 ce ff ff       	call   801020b0 <namei>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	89 c3                	mov    %eax,%ebx
801051bd:	85 c0                	test   %eax,%eax
801051bf:	0f 84 e4 00 00 00    	je     801052a9 <sys_link+0x139>
  ilock(ip);
801051c5:	83 ec 0c             	sub    $0xc,%esp
801051c8:	50                   	push   %eax
801051c9:	e8 c2 c5 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d6:	0f 84 b5 00 00 00    	je     80105291 <sys_link+0x121>
  iupdate(ip);
801051dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051e7:	53                   	push   %ebx
801051e8:	e8 f3 c4 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
801051ed:	89 1c 24             	mov    %ebx,(%esp)
801051f0:	e8 7b c6 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051f5:	58                   	pop    %eax
801051f6:	5a                   	pop    %edx
801051f7:	57                   	push   %edi
801051f8:	ff 75 d0             	push   -0x30(%ebp)
801051fb:	e8 d0 ce ff ff       	call   801020d0 <nameiparent>
80105200:	83 c4 10             	add    $0x10,%esp
80105203:	89 c6                	mov    %eax,%esi
80105205:	85 c0                	test   %eax,%eax
80105207:	74 5b                	je     80105264 <sys_link+0xf4>
  ilock(dp);
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	50                   	push   %eax
8010520d:	e8 7e c5 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105212:	8b 03                	mov    (%ebx),%eax
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	39 06                	cmp    %eax,(%esi)
80105219:	75 3d                	jne    80105258 <sys_link+0xe8>
8010521b:	83 ec 04             	sub    $0x4,%esp
8010521e:	ff 73 04             	push   0x4(%ebx)
80105221:	57                   	push   %edi
80105222:	56                   	push   %esi
80105223:	e8 c8 cd ff ff       	call   80101ff0 <dirlink>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	78 29                	js     80105258 <sys_link+0xe8>
  iunlockput(dp);
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	56                   	push   %esi
80105233:	e8 e8 c7 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
80105238:	89 1c 24             	mov    %ebx,(%esp)
8010523b:	e8 80 c6 ff ff       	call   801018c0 <iput>
  end_op();
80105240:	e8 9b dd ff ff       	call   80102fe0 <end_op>
  return 0;
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	31 c0                	xor    %eax,%eax
}
8010524a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010524d:	5b                   	pop    %ebx
8010524e:	5e                   	pop    %esi
8010524f:	5f                   	pop    %edi
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret    
80105252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	56                   	push   %esi
8010525c:	e8 bf c7 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105261:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	53                   	push   %ebx
80105268:	e8 23 c5 ff ff       	call   80101790 <ilock>
  ip->nlink--;
8010526d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105272:	89 1c 24             	mov    %ebx,(%esp)
80105275:	e8 66 c4 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010527a:	89 1c 24             	mov    %ebx,(%esp)
8010527d:	e8 9e c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105282:	e8 59 dd ff ff       	call   80102fe0 <end_op>
  return -1;
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528f:	eb b9                	jmp    8010524a <sys_link+0xda>
    iunlockput(ip);
80105291:	83 ec 0c             	sub    $0xc,%esp
80105294:	53                   	push   %ebx
80105295:	e8 86 c7 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010529a:	e8 41 dd ff ff       	call   80102fe0 <end_op>
    return -1;
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a7:	eb a1                	jmp    8010524a <sys_link+0xda>
    end_op();
801052a9:	e8 32 dd ff ff       	call   80102fe0 <end_op>
    return -1;
801052ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b3:	eb 95                	jmp    8010524a <sys_link+0xda>
801052b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_unlink>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 bc f9 ff ff       	call   80104c90 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 7a 01 00 00    	js     80105459 <sys_unlink+0x199>
  begin_op();
801052df:	e8 8c dc ff ff       	call   80102f70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	53                   	push   %ebx
801052eb:	ff 75 c0             	push   -0x40(%ebp)
801052ee:	e8 dd cd ff ff       	call   801020d0 <nameiparent>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052f9:	85 c0                	test   %eax,%eax
801052fb:	0f 84 62 01 00 00    	je     80105463 <sys_unlink+0x1a3>
  ilock(dp);
80105301:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	57                   	push   %edi
80105308:	e8 83 c4 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010530d:	58                   	pop    %eax
8010530e:	5a                   	pop    %edx
8010530f:	68 80 7f 10 80       	push   $0x80107f80
80105314:	53                   	push   %ebx
80105315:	e8 b6 c9 ff ff       	call   80101cd0 <namecmp>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	0f 84 fb 00 00 00    	je     80105420 <sys_unlink+0x160>
80105325:	83 ec 08             	sub    $0x8,%esp
80105328:	68 7f 7f 10 80       	push   $0x80107f7f
8010532d:	53                   	push   %ebx
8010532e:	e8 9d c9 ff ff       	call   80101cd0 <namecmp>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	0f 84 e2 00 00 00    	je     80105420 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010533e:	83 ec 04             	sub    $0x4,%esp
80105341:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105344:	50                   	push   %eax
80105345:	53                   	push   %ebx
80105346:	57                   	push   %edi
80105347:	e8 a4 c9 ff ff       	call   80101cf0 <dirlookup>
8010534c:	83 c4 10             	add    $0x10,%esp
8010534f:	89 c3                	mov    %eax,%ebx
80105351:	85 c0                	test   %eax,%eax
80105353:	0f 84 c7 00 00 00    	je     80105420 <sys_unlink+0x160>
  ilock(ip);
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	50                   	push   %eax
8010535d:	e8 2e c4 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010536a:	0f 8e 1c 01 00 00    	jle    8010548c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105370:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105375:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105378:	74 66                	je     801053e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010537a:	83 ec 04             	sub    $0x4,%esp
8010537d:	6a 10                	push   $0x10
8010537f:	6a 00                	push   $0x0
80105381:	57                   	push   %edi
80105382:	e8 89 f5 ff ff       	call   80104910 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105387:	6a 10                	push   $0x10
80105389:	ff 75 c4             	push   -0x3c(%ebp)
8010538c:	57                   	push   %edi
8010538d:	ff 75 b4             	push   -0x4c(%ebp)
80105390:	e8 0b c8 ff ff       	call   80101ba0 <writei>
80105395:	83 c4 20             	add    $0x20,%esp
80105398:	83 f8 10             	cmp    $0x10,%eax
8010539b:	0f 85 de 00 00 00    	jne    8010547f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053a6:	0f 84 94 00 00 00    	je     80105440 <sys_unlink+0x180>
  iunlockput(dp);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	ff 75 b4             	push   -0x4c(%ebp)
801053b2:	e8 69 c6 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
801053b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053bc:	89 1c 24             	mov    %ebx,(%esp)
801053bf:	e8 1c c3 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
801053c4:	89 1c 24             	mov    %ebx,(%esp)
801053c7:	e8 54 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
801053cc:	e8 0f dc ff ff       	call   80102fe0 <end_op>
  return 0;
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	31 c0                	xor    %eax,%eax
}
801053d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d9:	5b                   	pop    %ebx
801053da:	5e                   	pop    %esi
801053db:	5f                   	pop    %edi
801053dc:	5d                   	pop    %ebp
801053dd:	c3                   	ret    
801053de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053e4:	76 94                	jbe    8010537a <sys_unlink+0xba>
801053e6:	be 20 00 00 00       	mov    $0x20,%esi
801053eb:	eb 0b                	jmp    801053f8 <sys_unlink+0x138>
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
801053f0:	83 c6 10             	add    $0x10,%esi
801053f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053f6:	73 82                	jae    8010537a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053f8:	6a 10                	push   $0x10
801053fa:	56                   	push   %esi
801053fb:	57                   	push   %edi
801053fc:	53                   	push   %ebx
801053fd:	e8 9e c6 ff ff       	call   80101aa0 <readi>
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	83 f8 10             	cmp    $0x10,%eax
80105408:	75 68                	jne    80105472 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010540a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010540f:	74 df                	je     801053f0 <sys_unlink+0x130>
    iunlockput(ip);
80105411:	83 ec 0c             	sub    $0xc,%esp
80105414:	53                   	push   %ebx
80105415:	e8 06 c6 ff ff       	call   80101a20 <iunlockput>
    goto bad;
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	ff 75 b4             	push   -0x4c(%ebp)
80105426:	e8 f5 c5 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010542b:	e8 b0 db ff ff       	call   80102fe0 <end_op>
  return -1;
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105438:	eb 9c                	jmp    801053d6 <sys_unlink+0x116>
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105440:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105443:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105446:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010544b:	50                   	push   %eax
8010544c:	e8 8f c2 ff ff       	call   801016e0 <iupdate>
80105451:	83 c4 10             	add    $0x10,%esp
80105454:	e9 53 ff ff ff       	jmp    801053ac <sys_unlink+0xec>
    return -1;
80105459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545e:	e9 73 ff ff ff       	jmp    801053d6 <sys_unlink+0x116>
    end_op();
80105463:	e8 78 db ff ff       	call   80102fe0 <end_op>
    return -1;
80105468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546d:	e9 64 ff ff ff       	jmp    801053d6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105472:	83 ec 0c             	sub    $0xc,%esp
80105475:	68 a4 7f 10 80       	push   $0x80107fa4
8010547a:	e8 01 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	68 b6 7f 10 80       	push   $0x80107fb6
80105487:	e8 f4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 92 7f 10 80       	push   $0x80107f92
80105494:	e8 e7 ae ff ff       	call   80100380 <panic>
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_open>:

int
sys_open(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054a8:	53                   	push   %ebx
801054a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ac:	50                   	push   %eax
801054ad:	6a 00                	push   $0x0
801054af:	e8 dc f7 ff ff       	call   80104c90 <argstr>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	0f 88 8e 00 00 00    	js     8010554d <sys_open+0xad>
801054bf:	83 ec 08             	sub    $0x8,%esp
801054c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054c5:	50                   	push   %eax
801054c6:	6a 01                	push   $0x1
801054c8:	e8 03 f7 ff ff       	call   80104bd0 <argint>
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	85 c0                	test   %eax,%eax
801054d2:	78 79                	js     8010554d <sys_open+0xad>
    return -1;

  begin_op();
801054d4:	e8 97 da ff ff       	call   80102f70 <begin_op>

  if(omode & O_CREATE){
801054d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054dd:	75 79                	jne    80105558 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054df:	83 ec 0c             	sub    $0xc,%esp
801054e2:	ff 75 e0             	push   -0x20(%ebp)
801054e5:	e8 c6 cb ff ff       	call   801020b0 <namei>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	89 c6                	mov    %eax,%esi
801054ef:	85 c0                	test   %eax,%eax
801054f1:	0f 84 7e 00 00 00    	je     80105575 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054f7:	83 ec 0c             	sub    $0xc,%esp
801054fa:	50                   	push   %eax
801054fb:	e8 90 c2 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105500:	83 c4 10             	add    $0x10,%esp
80105503:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105508:	0f 84 c2 00 00 00    	je     801055d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010550e:	e8 2d b9 ff ff       	call   80100e40 <filealloc>
80105513:	89 c7                	mov    %eax,%edi
80105515:	85 c0                	test   %eax,%eax
80105517:	74 23                	je     8010553c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105519:	e8 72 e6 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010551e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105520:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105524:	85 d2                	test   %edx,%edx
80105526:	74 60                	je     80105588 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105528:	83 c3 01             	add    $0x1,%ebx
8010552b:	83 fb 10             	cmp    $0x10,%ebx
8010552e:	75 f0                	jne    80105520 <sys_open+0x80>
    if(f)
      fileclose(f);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	57                   	push   %edi
80105534:	e8 c7 b9 ff ff       	call   80100f00 <fileclose>
80105539:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	56                   	push   %esi
80105540:	e8 db c4 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105545:	e8 96 da ff ff       	call   80102fe0 <end_op>
    return -1;
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105552:	eb 6d                	jmp    801055c1 <sys_open+0x121>
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010555e:	31 c9                	xor    %ecx,%ecx
80105560:	ba 02 00 00 00       	mov    $0x2,%edx
80105565:	6a 00                	push   $0x0
80105567:	e8 14 f8 ff ff       	call   80104d80 <create>
    if(ip == 0){
8010556c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010556f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105571:	85 c0                	test   %eax,%eax
80105573:	75 99                	jne    8010550e <sys_open+0x6e>
      end_op();
80105575:	e8 66 da ff ff       	call   80102fe0 <end_op>
      return -1;
8010557a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010557f:	eb 40                	jmp    801055c1 <sys_open+0x121>
80105581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105588:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010558b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010558f:	56                   	push   %esi
80105590:	e8 db c2 ff ff       	call   80101870 <iunlock>
  end_op();
80105595:	e8 46 da ff ff       	call   80102fe0 <end_op>

  f->type = FD_INODE;
8010559a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055b2:	f7 d0                	not    %eax
801055b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c4:	89 d8                	mov    %ebx,%eax
801055c6:	5b                   	pop    %ebx
801055c7:	5e                   	pop    %esi
801055c8:	5f                   	pop    %edi
801055c9:	5d                   	pop    %ebp
801055ca:	c3                   	ret    
801055cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801055d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055d3:	85 c9                	test   %ecx,%ecx
801055d5:	0f 84 33 ff ff ff    	je     8010550e <sys_open+0x6e>
801055db:	e9 5c ff ff ff       	jmp    8010553c <sys_open+0x9c>

801055e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055e6:	e8 85 d9 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f1:	50                   	push   %eax
801055f2:	6a 00                	push   $0x0
801055f4:	e8 97 f6 ff ff       	call   80104c90 <argstr>
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	85 c0                	test   %eax,%eax
801055fe:	78 30                	js     80105630 <sys_mkdir+0x50>
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105606:	31 c9                	xor    %ecx,%ecx
80105608:	ba 01 00 00 00       	mov    $0x1,%edx
8010560d:	6a 00                	push   $0x0
8010560f:	e8 6c f7 ff ff       	call   80104d80 <create>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	85 c0                	test   %eax,%eax
80105619:	74 15                	je     80105630 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010561b:	83 ec 0c             	sub    $0xc,%esp
8010561e:	50                   	push   %eax
8010561f:	e8 fc c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105624:	e8 b7 d9 ff ff       	call   80102fe0 <end_op>
  return 0;
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	31 c0                	xor    %eax,%eax
}
8010562e:	c9                   	leave  
8010562f:	c3                   	ret    
    end_op();
80105630:	e8 ab d9 ff ff       	call   80102fe0 <end_op>
    return -1;
80105635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010563a:	c9                   	leave  
8010563b:	c3                   	ret    
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_mknod>:

int
sys_mknod(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105646:	e8 25 d9 ff ff       	call   80102f70 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010564b:	83 ec 08             	sub    $0x8,%esp
8010564e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105651:	50                   	push   %eax
80105652:	6a 00                	push   $0x0
80105654:	e8 37 f6 ff ff       	call   80104c90 <argstr>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	85 c0                	test   %eax,%eax
8010565e:	78 60                	js     801056c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105660:	83 ec 08             	sub    $0x8,%esp
80105663:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105666:	50                   	push   %eax
80105667:	6a 01                	push   $0x1
80105669:	e8 62 f5 ff ff       	call   80104bd0 <argint>
  if((argstr(0, &path)) < 0 ||
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	78 4b                	js     801056c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105675:	83 ec 08             	sub    $0x8,%esp
80105678:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567b:	50                   	push   %eax
8010567c:	6a 02                	push   $0x2
8010567e:	e8 4d f5 ff ff       	call   80104bd0 <argint>
     argint(1, &major) < 0 ||
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	85 c0                	test   %eax,%eax
80105688:	78 36                	js     801056c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010568a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010568e:	83 ec 0c             	sub    $0xc,%esp
80105691:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105695:	ba 03 00 00 00       	mov    $0x3,%edx
8010569a:	50                   	push   %eax
8010569b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010569e:	e8 dd f6 ff ff       	call   80104d80 <create>
     argint(2, &minor) < 0 ||
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	74 16                	je     801056c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	50                   	push   %eax
801056ae:	e8 6d c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
801056b3:	e8 28 d9 ff ff       	call   80102fe0 <end_op>
  return 0;
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	31 c0                	xor    %eax,%eax
}
801056bd:	c9                   	leave  
801056be:	c3                   	ret    
801056bf:	90                   	nop
    end_op();
801056c0:	e8 1b d9 ff ff       	call   80102fe0 <end_op>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ca:	c9                   	leave  
801056cb:	c3                   	ret    
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_chdir>:

int
sys_chdir(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	56                   	push   %esi
801056d4:	53                   	push   %ebx
801056d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056d8:	e8 b3 e4 ff ff       	call   80103b90 <myproc>
801056dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056df:	e8 8c d8 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ea:	50                   	push   %eax
801056eb:	6a 00                	push   $0x0
801056ed:	e8 9e f5 ff ff       	call   80104c90 <argstr>
801056f2:	83 c4 10             	add    $0x10,%esp
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 77                	js     80105770 <sys_chdir+0xa0>
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	ff 75 f4             	push   -0xc(%ebp)
801056ff:	e8 ac c9 ff ff       	call   801020b0 <namei>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	89 c3                	mov    %eax,%ebx
80105709:	85 c0                	test   %eax,%eax
8010570b:	74 63                	je     80105770 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	50                   	push   %eax
80105711:	e8 7a c0 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010571e:	75 30                	jne    80105750 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 47 c1 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
80105729:	58                   	pop    %eax
8010572a:	ff 76 6c             	push   0x6c(%esi)
8010572d:	e8 8e c1 ff ff       	call   801018c0 <iput>
  end_op();
80105732:	e8 a9 d8 ff ff       	call   80102fe0 <end_op>
  curproc->cwd = ip;
80105737:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	31 c0                	xor    %eax,%eax
}
8010573f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105742:	5b                   	pop    %ebx
80105743:	5e                   	pop    %esi
80105744:	5d                   	pop    %ebp
80105745:	c3                   	ret    
80105746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	53                   	push   %ebx
80105754:	e8 c7 c2 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105759:	e8 82 d8 ff ff       	call   80102fe0 <end_op>
    return -1;
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105766:	eb d7                	jmp    8010573f <sys_chdir+0x6f>
80105768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
    end_op();
80105770:	e8 6b d8 ff ff       	call   80102fe0 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577a:	eb c3                	jmp    8010573f <sys_chdir+0x6f>
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_exec>:

int
sys_exec(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105785:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010578b:	53                   	push   %ebx
8010578c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105792:	50                   	push   %eax
80105793:	6a 00                	push   $0x0
80105795:	e8 f6 f4 ff ff       	call   80104c90 <argstr>
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	85 c0                	test   %eax,%eax
8010579f:	0f 88 87 00 00 00    	js     8010582c <sys_exec+0xac>
801057a5:	83 ec 08             	sub    $0x8,%esp
801057a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057ae:	50                   	push   %eax
801057af:	6a 01                	push   $0x1
801057b1:	e8 1a f4 ff ff       	call   80104bd0 <argint>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 6f                	js     8010582c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057bd:	83 ec 04             	sub    $0x4,%esp
801057c0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801057c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057c8:	68 80 00 00 00       	push   $0x80
801057cd:	6a 00                	push   $0x0
801057cf:	56                   	push   %esi
801057d0:	e8 3b f1 ff ff       	call   80104910 <memset>
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057df:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057e0:	83 ec 08             	sub    $0x8,%esp
801057e3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057e9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057f0:	50                   	push   %eax
801057f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057f7:	01 f8                	add    %edi,%eax
801057f9:	50                   	push   %eax
801057fa:	e8 41 f3 ff ff       	call   80104b40 <fetchint>
801057ff:	83 c4 10             	add    $0x10,%esp
80105802:	85 c0                	test   %eax,%eax
80105804:	78 26                	js     8010582c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105806:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010580c:	85 c0                	test   %eax,%eax
8010580e:	74 30                	je     80105840 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105810:	83 ec 08             	sub    $0x8,%esp
80105813:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105816:	52                   	push   %edx
80105817:	50                   	push   %eax
80105818:	e8 63 f3 ff ff       	call   80104b80 <fetchstr>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 08                	js     8010582c <sys_exec+0xac>
  for(i=0;; i++){
80105824:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105827:	83 fb 20             	cmp    $0x20,%ebx
8010582a:	75 b4                	jne    801057e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010582c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010582f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
80105838:	c3                   	ret    
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105840:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105847:	00 00 00 00 
  return exec(path, argv);
8010584b:	83 ec 08             	sub    $0x8,%esp
8010584e:	56                   	push   %esi
8010584f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105855:	e8 56 b2 ff ff       	call   80100ab0 <exec>
8010585a:	83 c4 10             	add    $0x10,%esp
}
8010585d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105860:	5b                   	pop    %ebx
80105861:	5e                   	pop    %esi
80105862:	5f                   	pop    %edi
80105863:	5d                   	pop    %ebp
80105864:	c3                   	ret    
80105865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_pipe>:

int
sys_pipe(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105875:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105878:	53                   	push   %ebx
80105879:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010587c:	6a 08                	push   $0x8
8010587e:	50                   	push   %eax
8010587f:	6a 00                	push   $0x0
80105881:	e8 9a f3 ff ff       	call   80104c20 <argptr>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	78 4a                	js     801058d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010588d:	83 ec 08             	sub    $0x8,%esp
80105890:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105893:	50                   	push   %eax
80105894:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105897:	50                   	push   %eax
80105898:	e8 b3 dd ff ff       	call   80103650 <pipealloc>
8010589d:	83 c4 10             	add    $0x10,%esp
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 33                	js     801058d7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058a7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058a9:	e8 e2 e2 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058b0:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
801058b4:	85 f6                	test   %esi,%esi
801058b6:	74 28                	je     801058e0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058b8:	83 c3 01             	add    $0x1,%ebx
801058bb:	83 fb 10             	cmp    $0x10,%ebx
801058be:	75 f0                	jne    801058b0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	ff 75 e0             	push   -0x20(%ebp)
801058c6:	e8 35 b6 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
801058cb:	58                   	pop    %eax
801058cc:	ff 75 e4             	push   -0x1c(%ebp)
801058cf:	e8 2c b6 ff ff       	call   80100f00 <fileclose>
    return -1;
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dc:	eb 53                	jmp    80105931 <sys_pipe+0xc1>
801058de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058e0:	8d 73 08             	lea    0x8(%ebx),%esi
801058e3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ea:	e8 a1 e2 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ef:	31 d2                	xor    %edx,%edx
801058f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058f8:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
801058fc:	85 c9                	test   %ecx,%ecx
801058fe:	74 20                	je     80105920 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105900:	83 c2 01             	add    $0x1,%edx
80105903:	83 fa 10             	cmp    $0x10,%edx
80105906:	75 f0                	jne    801058f8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105908:	e8 83 e2 ff ff       	call   80103b90 <myproc>
8010590d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105914:	00 
80105915:	eb a9                	jmp    801058c0 <sys_pipe+0x50>
80105917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105920:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105924:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105927:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105929:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010592c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010592f:	31 c0                	xor    %eax,%eax
}
80105931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105934:	5b                   	pop    %ebx
80105935:	5e                   	pop    %esi
80105936:	5f                   	pop    %edi
80105937:	5d                   	pop    %ebp
80105938:	c3                   	ret    
80105939:	66 90                	xchg   %ax,%ax
8010593b:	66 90                	xchg   %ax,%ax
8010593d:	66 90                	xchg   %ax,%ax
8010593f:	90                   	nop

80105940 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105940:	e9 7b e4 ff ff       	jmp    80103dc0 <fork>
80105945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_exit>:
}

int
sys_exit(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 08             	sub    $0x8,%esp
  exit();
80105956:	e8 e5 e6 ff ff       	call   80104040 <exit>
  return 0;  // not reached
}
8010595b:	31 c0                	xor    %eax,%eax
8010595d:	c9                   	leave  
8010595e:	c3                   	ret    
8010595f:	90                   	nop

80105960 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105960:	e9 0b e8 ff ff       	jmp    80104170 <wait>
80105965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_kill>:
}

int
sys_kill(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105976:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105979:	50                   	push   %eax
8010597a:	6a 00                	push   $0x0
8010597c:	e8 4f f2 ff ff       	call   80104bd0 <argint>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	85 c0                	test   %eax,%eax
80105986:	78 18                	js     801059a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	ff 75 f4             	push   -0xc(%ebp)
8010598e:	e8 7d ea ff ff       	call   80104410 <kill>
80105993:	83 c4 10             	add    $0x10,%esp
}
80105996:	c9                   	leave  
80105997:	c3                   	ret    
80105998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop
801059a0:	c9                   	leave  
    return -1;
801059a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059a6:	c3                   	ret    
801059a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_getpid>:

int
sys_getpid(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059b6:	e8 d5 e1 ff ff       	call   80103b90 <myproc>
801059bb:	8b 40 14             	mov    0x14(%eax),%eax
}
801059be:	c9                   	leave  
801059bf:	c3                   	ret    

801059c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ca:	50                   	push   %eax
801059cb:	6a 00                	push   $0x0
801059cd:	e8 fe f1 ff ff       	call   80104bd0 <argint>
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	85 c0                	test   %eax,%eax
801059d7:	78 27                	js     80105a00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059d9:	e8 b2 e1 ff ff       	call   80103b90 <myproc>
  if(growproc(n) < 0)
801059de:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059e1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059e3:	ff 75 f4             	push   -0xc(%ebp)
801059e6:	e8 c5 e2 ff ff       	call   80103cb0 <growproc>
801059eb:	83 c4 10             	add    $0x10,%esp
801059ee:	85 c0                	test   %eax,%eax
801059f0:	78 0e                	js     80105a00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059f2:	89 d8                	mov    %ebx,%eax
801059f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059f7:	c9                   	leave  
801059f8:	c3                   	ret    
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a05:	eb eb                	jmp    801059f2 <sys_sbrk+0x32>
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_shugebrk>:
// TODO: implement this
// part 2
// TODO: add growhugeproc
int
sys_shugebrk(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a1a:	50                   	push   %eax
80105a1b:	6a 00                	push   $0x0
80105a1d:	e8 ae f1 ff ff       	call   80104bd0 <argint>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	78 27                	js     80105a50 <sys_shugebrk+0x40>
    return -1;
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
80105a29:	e8 62 e1 ff ff       	call   80103b90 <myproc>
  if(growhugeproc(n) < 0)
80105a2e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
80105a31:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growhugeproc(n) < 0)
80105a34:	ff 75 f4             	push   -0xc(%ebp)
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
80105a37:	81 c3 00 00 00 1e    	add    $0x1e000000,%ebx
  if(growhugeproc(n) < 0)
80105a3d:	e8 ee e2 ff ff       	call   80103d30 <growhugeproc>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	78 07                	js     80105a50 <sys_shugebrk+0x40>
    return -1;
  return addr;
}
80105a49:	89 d8                	mov    %ebx,%eax
80105a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a4e:	c9                   	leave  
80105a4f:	c3                   	ret    
    return -1;
80105a50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a55:	eb f2                	jmp    80105a49 <sys_shugebrk+0x39>
80105a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5e:	66 90                	xchg   %ax,%ax

80105a60 <sys_sleep>:

int
sys_sleep(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a6a:	50                   	push   %eax
80105a6b:	6a 00                	push   $0x0
80105a6d:	e8 5e f1 ff ff       	call   80104bd0 <argint>
80105a72:	83 c4 10             	add    $0x10,%esp
80105a75:	85 c0                	test   %eax,%eax
80105a77:	0f 88 8a 00 00 00    	js     80105b07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	68 a0 4d 11 80       	push   $0x80114da0
80105a85:	e8 c6 ed ff ff       	call   80104850 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a8d:	8b 1d 80 4d 11 80    	mov    0x80114d80,%ebx
  while(ticks - ticks0 < n){
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 d2                	test   %edx,%edx
80105a98:	75 27                	jne    80105ac1 <sys_sleep+0x61>
80105a9a:	eb 54                	jmp    80105af0 <sys_sleep+0x90>
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105aa0:	83 ec 08             	sub    $0x8,%esp
80105aa3:	68 a0 4d 11 80       	push   $0x80114da0
80105aa8:	68 80 4d 11 80       	push   $0x80114d80
80105aad:	e8 3e e8 ff ff       	call   801042f0 <sleep>
  while(ticks - ticks0 < n){
80105ab2:	a1 80 4d 11 80       	mov    0x80114d80,%eax
80105ab7:	83 c4 10             	add    $0x10,%esp
80105aba:	29 d8                	sub    %ebx,%eax
80105abc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105abf:	73 2f                	jae    80105af0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ac1:	e8 ca e0 ff ff       	call   80103b90 <myproc>
80105ac6:	8b 40 28             	mov    0x28(%eax),%eax
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	74 d3                	je     80105aa0 <sys_sleep+0x40>
      release(&tickslock);
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	68 a0 4d 11 80       	push   $0x80114da0
80105ad5:	e8 16 ed ff ff       	call   801047f0 <release>
  }
  release(&tickslock);
  return 0;
}
80105ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ae5:	c9                   	leave  
80105ae6:	c3                   	ret    
80105ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	68 a0 4d 11 80       	push   $0x80114da0
80105af8:	e8 f3 ec ff ff       	call   801047f0 <release>
  return 0;
80105afd:	83 c4 10             	add    $0x10,%esp
80105b00:	31 c0                	xor    %eax,%eax
}
80105b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
    return -1;
80105b07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0c:	eb f4                	jmp    80105b02 <sys_sleep+0xa2>
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
80105b14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b17:	68 a0 4d 11 80       	push   $0x80114da0
80105b1c:	e8 2f ed ff ff       	call   80104850 <acquire>
  xticks = ticks;
80105b21:	8b 1d 80 4d 11 80    	mov    0x80114d80,%ebx
  release(&tickslock);
80105b27:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80105b2e:	e8 bd ec ff ff       	call   801047f0 <release>
  return xticks;
}
80105b33:	89 d8                	mov    %ebx,%eax
80105b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b38:	c9                   	leave  
80105b39:	c3                   	ret    
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b40 <sys_printhugepde>:

// System calls for debugging huge page allocations/mappings
int
sys_printhugepde()
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
80105b45:	53                   	push   %ebx
  pde_t *pgdir = myproc()->pgdir;
  int pid = myproc()->pid;
  int i = 0;
  for (i = 0; i < 1024; i++) {
80105b46:	31 db                	xor    %ebx,%ebx
{
80105b48:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pgdir = myproc()->pgdir;
80105b4b:	e8 40 e0 ff ff       	call   80103b90 <myproc>
80105b50:	8b 78 08             	mov    0x8(%eax),%edi
  int pid = myproc()->pid;
80105b53:	e8 38 e0 ff ff       	call   80103b90 <myproc>
80105b58:	8b 70 14             	mov    0x14(%eax),%esi
  for (i = 0; i < 1024; i++) {
80105b5b:	eb 0e                	jmp    80105b6b <sys_printhugepde+0x2b>
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi
80105b60:	83 c3 01             	add    $0x1,%ebx
80105b63:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b69:	74 2e                	je     80105b99 <sys_printhugepde+0x59>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P))
80105b6b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80105b6e:	89 c2                	mov    %eax,%edx
80105b70:	81 e2 85 00 00 00    	and    $0x85,%edx
80105b76:	81 fa 85 00 00 00    	cmp    $0x85,%edx
80105b7c:	75 e2                	jne    80105b60 <sys_printhugepde+0x20>
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b7e:	50                   	push   %eax
80105b7f:	53                   	push   %ebx
  for (i = 0; i < 1024; i++) {
80105b80:	83 c3 01             	add    $0x1,%ebx
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b83:	56                   	push   %esi
80105b84:	68 c5 7f 10 80       	push   $0x80107fc5
80105b89:	e8 12 ab ff ff       	call   801006a0 <cprintf>
80105b8e:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 1024; i++) {
80105b91:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b97:	75 d2                	jne    80105b6b <sys_printhugepde+0x2b>
  }
  return 0;
}
80105b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b9c:	31 c0                	xor    %eax,%eax
80105b9e:	5b                   	pop    %ebx
80105b9f:	5e                   	pop    %esi
80105ba0:	5f                   	pop    %edi
80105ba1:	5d                   	pop    %ebp
80105ba2:	c3                   	ret    
80105ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bb0 <sys_procpgdirinfo>:

int
sys_procpgdirinfo()
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	57                   	push   %edi
80105bb4:	56                   	push   %esi
  int *buf;
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105bb5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105bb8:	53                   	push   %ebx
80105bb9:	83 ec 30             	sub    $0x30,%esp
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105bbc:	6a 08                	push   $0x8
80105bbe:	50                   	push   %eax
80105bbf:	6a 00                	push   $0x0
80105bc1:	e8 5a f0 ff ff       	call   80104c20 <argptr>
80105bc6:	83 c4 10             	add    $0x10,%esp
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	0f 88 90 00 00 00    	js     80105c61 <sys_procpgdirinfo+0xb1>
    return -1;
  pde_t *pgdir = myproc()->pgdir;
80105bd1:	e8 ba df ff ff       	call   80103b90 <myproc>
  int base_cnt = 0; // base page count
  int huge_cnt = 0; // huge page count
80105bd6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  int base_cnt = 0; // base page count
80105bdd:	31 c9                	xor    %ecx,%ecx
80105bdf:	8b 70 08             	mov    0x8(%eax),%esi
80105be2:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105be8:	eb 12                	jmp    80105bfc <sys_procpgdirinfo+0x4c>
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i = 0;
  int j = 0;
  for (i = 0; i < 1024; i++) {
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
      ++huge_cnt;
    if((pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) && ((pgdir[i] & PTE_PS) == 0) /*Only PTE_P and PTE_U should be set for base pages*/) {
80105bf0:	83 f8 05             	cmp    $0x5,%eax
80105bf3:	74 3a                	je     80105c2f <sys_procpgdirinfo+0x7f>
  for (i = 0; i < 1024; i++) {
80105bf5:	83 c6 04             	add    $0x4,%esi
80105bf8:	39 f7                	cmp    %esi,%edi
80105bfa:	74 1b                	je     80105c17 <sys_procpgdirinfo+0x67>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
80105bfc:	8b 1e                	mov    (%esi),%ebx
80105bfe:	89 d8                	mov    %ebx,%eax
80105c00:	25 85 00 00 00       	and    $0x85,%eax
80105c05:	3d 85 00 00 00       	cmp    $0x85,%eax
80105c0a:	75 e4                	jne    80105bf0 <sys_procpgdirinfo+0x40>
  for (i = 0; i < 1024; i++) {
80105c0c:	83 c6 04             	add    $0x4,%esi
      ++huge_cnt;
80105c0f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  for (i = 0; i < 1024; i++) {
80105c13:	39 f7                	cmp    %esi,%edi
80105c15:	75 e5                	jne    80105bfc <sys_procpgdirinfo+0x4c>
          ++base_cnt;
        }
      }
    }
  }
  buf[0] = base_cnt; // base page count
80105c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  buf[1] = huge_cnt; // huge page count
80105c1a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  buf[0] = base_cnt; // base page count
80105c1d:	89 08                	mov    %ecx,(%eax)
  buf[1] = huge_cnt; // huge page count
80105c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c22:	89 78 04             	mov    %edi,0x4(%eax)
  return 0;
80105c25:	31 c0                	xor    %eax,%eax
}
80105c27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c2a:	5b                   	pop    %ebx
80105c2b:	5e                   	pop    %esi
80105c2c:	5f                   	pop    %edi
80105c2d:	5d                   	pop    %ebp
80105c2e:	c3                   	ret    
      uint* pgtab = (uint*)P2V(PTE_ADDR(pgdir[i]));
80105c2f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105c35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
      for (j = 0; j < 1024; j++) {
80105c3b:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
80105c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((pgtab[j] & PTE_U) && (pgtab[j] & PTE_P)) {
80105c48:	8b 10                	mov    (%eax),%edx
80105c4a:	83 e2 05             	and    $0x5,%edx
          ++base_cnt;
80105c4d:	83 fa 05             	cmp    $0x5,%edx
80105c50:	0f 94 c2             	sete   %dl
      for (j = 0; j < 1024; j++) {
80105c53:	83 c0 04             	add    $0x4,%eax
          ++base_cnt;
80105c56:	0f b6 d2             	movzbl %dl,%edx
80105c59:	01 d1                	add    %edx,%ecx
      for (j = 0; j < 1024; j++) {
80105c5b:	39 d8                	cmp    %ebx,%eax
80105c5d:	75 e9                	jne    80105c48 <sys_procpgdirinfo+0x98>
80105c5f:	eb 94                	jmp    80105bf5 <sys_procpgdirinfo+0x45>
    return -1;
80105c61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c66:	eb bf                	jmp    80105c27 <sys_procpgdirinfo+0x77>

80105c68 <alltraps>:
80105c68:	1e                   	push   %ds
80105c69:	06                   	push   %es
80105c6a:	0f a0                	push   %fs
80105c6c:	0f a8                	push   %gs
80105c6e:	60                   	pusha  
80105c6f:	66 b8 10 00          	mov    $0x10,%ax
80105c73:	8e d8                	mov    %eax,%ds
80105c75:	8e c0                	mov    %eax,%es
80105c77:	54                   	push   %esp
80105c78:	e8 c3 00 00 00       	call   80105d40 <trap>
80105c7d:	83 c4 04             	add    $0x4,%esp

80105c80 <trapret>:
80105c80:	61                   	popa   
80105c81:	0f a9                	pop    %gs
80105c83:	0f a1                	pop    %fs
80105c85:	07                   	pop    %es
80105c86:	1f                   	pop    %ds
80105c87:	83 c4 08             	add    $0x8,%esp
80105c8a:	cf                   	iret   
80105c8b:	66 90                	xchg   %ax,%ax
80105c8d:	66 90                	xchg   %ax,%ax
80105c8f:	90                   	nop

80105c90 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c90:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c91:	31 c0                	xor    %eax,%eax
{
80105c93:	89 e5                	mov    %esp,%ebp
80105c95:	83 ec 08             	sub    $0x8,%esp
80105c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ca0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ca7:	c7 04 c5 e2 4d 11 80 	movl   $0x8e000008,-0x7feeb21e(,%eax,8)
80105cae:	08 00 00 8e 
80105cb2:	66 89 14 c5 e0 4d 11 	mov    %dx,-0x7feeb220(,%eax,8)
80105cb9:	80 
80105cba:	c1 ea 10             	shr    $0x10,%edx
80105cbd:	66 89 14 c5 e6 4d 11 	mov    %dx,-0x7feeb21a(,%eax,8)
80105cc4:	80 
  for(i = 0; i < 256; i++)
80105cc5:	83 c0 01             	add    $0x1,%eax
80105cc8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ccd:	75 d1                	jne    80105ca0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105ccf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cd2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105cd7:	c7 05 e2 4f 11 80 08 	movl   $0xef000008,0x80114fe2
80105cde:	00 00 ef 
  initlock(&tickslock, "time");
80105ce1:	68 de 7f 10 80       	push   $0x80107fde
80105ce6:	68 a0 4d 11 80       	push   $0x80114da0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ceb:	66 a3 e0 4f 11 80    	mov    %ax,0x80114fe0
80105cf1:	c1 e8 10             	shr    $0x10,%eax
80105cf4:	66 a3 e6 4f 11 80    	mov    %ax,0x80114fe6
  initlock(&tickslock, "time");
80105cfa:	e8 81 e9 ff ff       	call   80104680 <initlock>
}
80105cff:	83 c4 10             	add    $0x10,%esp
80105d02:	c9                   	leave  
80105d03:	c3                   	ret    
80105d04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop

80105d10 <idtinit>:

void
idtinit(void)
{
80105d10:	55                   	push   %ebp
  pd[0] = size-1;
80105d11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d16:	89 e5                	mov    %esp,%ebp
80105d18:	83 ec 10             	sub    $0x10,%esp
80105d1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d1f:	b8 e0 4d 11 80       	mov    $0x80114de0,%eax
80105d24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d28:	c1 e8 10             	shr    $0x10,%eax
80105d2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d35:	c9                   	leave  
80105d36:	c3                   	ret    
80105d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	57                   	push   %edi
80105d44:	56                   	push   %esi
80105d45:	53                   	push   %ebx
80105d46:	83 ec 1c             	sub    $0x1c,%esp
80105d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d4c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d4f:	83 f8 40             	cmp    $0x40,%eax
80105d52:	0f 84 68 01 00 00    	je     80105ec0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d58:	83 e8 20             	sub    $0x20,%eax
80105d5b:	83 f8 1f             	cmp    $0x1f,%eax
80105d5e:	0f 87 8c 00 00 00    	ja     80105df0 <trap+0xb0>
80105d64:	ff 24 85 84 80 10 80 	jmp    *-0x7fef7f7c(,%eax,4)
80105d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105d70:	e8 db c4 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105d75:	e8 a6 cd ff ff       	call   80102b20 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d7a:	e8 11 de ff ff       	call   80103b90 <myproc>
80105d7f:	85 c0                	test   %eax,%eax
80105d81:	74 1d                	je     80105da0 <trap+0x60>
80105d83:	e8 08 de ff ff       	call   80103b90 <myproc>
80105d88:	8b 50 28             	mov    0x28(%eax),%edx
80105d8b:	85 d2                	test   %edx,%edx
80105d8d:	74 11                	je     80105da0 <trap+0x60>
80105d8f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d93:	83 e0 03             	and    $0x3,%eax
80105d96:	66 83 f8 03          	cmp    $0x3,%ax
80105d9a:	0f 84 e8 01 00 00    	je     80105f88 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105da0:	e8 eb dd ff ff       	call   80103b90 <myproc>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	74 0f                	je     80105db8 <trap+0x78>
80105da9:	e8 e2 dd ff ff       	call   80103b90 <myproc>
80105dae:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105db2:	0f 84 b8 00 00 00    	je     80105e70 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105db8:	e8 d3 dd ff ff       	call   80103b90 <myproc>
80105dbd:	85 c0                	test   %eax,%eax
80105dbf:	74 1d                	je     80105dde <trap+0x9e>
80105dc1:	e8 ca dd ff ff       	call   80103b90 <myproc>
80105dc6:	8b 40 28             	mov    0x28(%eax),%eax
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	74 11                	je     80105dde <trap+0x9e>
80105dcd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105dd1:	83 e0 03             	and    $0x3,%eax
80105dd4:	66 83 f8 03          	cmp    $0x3,%ax
80105dd8:	0f 84 0f 01 00 00    	je     80105eed <trap+0x1ad>
    exit();
}
80105dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de1:	5b                   	pop    %ebx
80105de2:	5e                   	pop    %esi
80105de3:	5f                   	pop    %edi
80105de4:	5d                   	pop    %ebp
80105de5:	c3                   	ret    
80105de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ded:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105df0:	e8 9b dd ff ff       	call   80103b90 <myproc>
80105df5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105df8:	85 c0                	test   %eax,%eax
80105dfa:	0f 84 a2 01 00 00    	je     80105fa2 <trap+0x262>
80105e00:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e04:	0f 84 98 01 00 00    	je     80105fa2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e0a:	0f 20 d1             	mov    %cr2,%ecx
80105e0d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e10:	e8 5b dd ff ff       	call   80103b70 <cpuid>
80105e15:	8b 73 30             	mov    0x30(%ebx),%esi
80105e18:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e1b:	8b 43 34             	mov    0x34(%ebx),%eax
80105e1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e21:	e8 6a dd ff ff       	call   80103b90 <myproc>
80105e26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e29:	e8 62 dd ff ff       	call   80103b90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e2e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e31:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e34:	51                   	push   %ecx
80105e35:	57                   	push   %edi
80105e36:	52                   	push   %edx
80105e37:	ff 75 e4             	push   -0x1c(%ebp)
80105e3a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e3b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e3e:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e41:	56                   	push   %esi
80105e42:	ff 70 14             	push   0x14(%eax)
80105e45:	68 40 80 10 80       	push   $0x80108040
80105e4a:	e8 51 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105e4f:	83 c4 20             	add    $0x20,%esp
80105e52:	e8 39 dd ff ff       	call   80103b90 <myproc>
80105e57:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e5e:	e8 2d dd ff ff       	call   80103b90 <myproc>
80105e63:	85 c0                	test   %eax,%eax
80105e65:	0f 85 18 ff ff ff    	jne    80105d83 <trap+0x43>
80105e6b:	e9 30 ff ff ff       	jmp    80105da0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105e70:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e74:	0f 85 3e ff ff ff    	jne    80105db8 <trap+0x78>
    yield();
80105e7a:	e8 21 e4 ff ff       	call   801042a0 <yield>
80105e7f:	e9 34 ff ff ff       	jmp    80105db8 <trap+0x78>
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e88:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e8b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e8f:	e8 dc dc ff ff       	call   80103b70 <cpuid>
80105e94:	57                   	push   %edi
80105e95:	56                   	push   %esi
80105e96:	50                   	push   %eax
80105e97:	68 e8 7f 10 80       	push   $0x80107fe8
80105e9c:	e8 ff a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105ea1:	e8 7a cc ff ff       	call   80102b20 <lapiceoi>
    break;
80105ea6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ea9:	e8 e2 dc ff ff       	call   80103b90 <myproc>
80105eae:	85 c0                	test   %eax,%eax
80105eb0:	0f 85 cd fe ff ff    	jne    80105d83 <trap+0x43>
80105eb6:	e9 e5 fe ff ff       	jmp    80105da0 <trap+0x60>
80105ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop
    if(myproc()->killed)
80105ec0:	e8 cb dc ff ff       	call   80103b90 <myproc>
80105ec5:	8b 70 28             	mov    0x28(%eax),%esi
80105ec8:	85 f6                	test   %esi,%esi
80105eca:	0f 85 c8 00 00 00    	jne    80105f98 <trap+0x258>
    myproc()->tf = tf;
80105ed0:	e8 bb dc ff ff       	call   80103b90 <myproc>
80105ed5:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105ed8:	e8 33 ee ff ff       	call   80104d10 <syscall>
    if(myproc()->killed)
80105edd:	e8 ae dc ff ff       	call   80103b90 <myproc>
80105ee2:	8b 48 28             	mov    0x28(%eax),%ecx
80105ee5:	85 c9                	test   %ecx,%ecx
80105ee7:	0f 84 f1 fe ff ff    	je     80105dde <trap+0x9e>
}
80105eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ef0:	5b                   	pop    %ebx
80105ef1:	5e                   	pop    %esi
80105ef2:	5f                   	pop    %edi
80105ef3:	5d                   	pop    %ebp
      exit();
80105ef4:	e9 47 e1 ff ff       	jmp    80104040 <exit>
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f00:	e8 3b 02 00 00       	call   80106140 <uartintr>
    lapiceoi();
80105f05:	e8 16 cc ff ff       	call   80102b20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f0a:	e8 81 dc ff ff       	call   80103b90 <myproc>
80105f0f:	85 c0                	test   %eax,%eax
80105f11:	0f 85 6c fe ff ff    	jne    80105d83 <trap+0x43>
80105f17:	e9 84 fe ff ff       	jmp    80105da0 <trap+0x60>
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105f20:	e8 bb ca ff ff       	call   801029e0 <kbdintr>
    lapiceoi();
80105f25:	e8 f6 cb ff ff       	call   80102b20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f2a:	e8 61 dc ff ff       	call   80103b90 <myproc>
80105f2f:	85 c0                	test   %eax,%eax
80105f31:	0f 85 4c fe ff ff    	jne    80105d83 <trap+0x43>
80105f37:	e9 64 fe ff ff       	jmp    80105da0 <trap+0x60>
80105f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105f40:	e8 2b dc ff ff       	call   80103b70 <cpuid>
80105f45:	85 c0                	test   %eax,%eax
80105f47:	0f 85 28 fe ff ff    	jne    80105d75 <trap+0x35>
      acquire(&tickslock);
80105f4d:	83 ec 0c             	sub    $0xc,%esp
80105f50:	68 a0 4d 11 80       	push   $0x80114da0
80105f55:	e8 f6 e8 ff ff       	call   80104850 <acquire>
      wakeup(&ticks);
80105f5a:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
      ticks++;
80105f61:	83 05 80 4d 11 80 01 	addl   $0x1,0x80114d80
      wakeup(&ticks);
80105f68:	e8 43 e4 ff ff       	call   801043b0 <wakeup>
      release(&tickslock);
80105f6d:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80105f74:	e8 77 e8 ff ff       	call   801047f0 <release>
80105f79:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f7c:	e9 f4 fd ff ff       	jmp    80105d75 <trap+0x35>
80105f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f88:	e8 b3 e0 ff ff       	call   80104040 <exit>
80105f8d:	e9 0e fe ff ff       	jmp    80105da0 <trap+0x60>
80105f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f98:	e8 a3 e0 ff ff       	call   80104040 <exit>
80105f9d:	e9 2e ff ff ff       	jmp    80105ed0 <trap+0x190>
80105fa2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fa5:	e8 c6 db ff ff       	call   80103b70 <cpuid>
80105faa:	83 ec 0c             	sub    $0xc,%esp
80105fad:	56                   	push   %esi
80105fae:	57                   	push   %edi
80105faf:	50                   	push   %eax
80105fb0:	ff 73 30             	push   0x30(%ebx)
80105fb3:	68 0c 80 10 80       	push   $0x8010800c
80105fb8:	e8 e3 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105fbd:	83 c4 14             	add    $0x14,%esp
80105fc0:	68 e3 7f 10 80       	push   $0x80107fe3
80105fc5:	e8 b6 a3 ff ff       	call   80100380 <panic>
80105fca:	66 90                	xchg   %ax,%ax
80105fcc:	66 90                	xchg   %ax,%ax
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fd0:	a1 e0 55 11 80       	mov    0x801155e0,%eax
80105fd5:	85 c0                	test   %eax,%eax
80105fd7:	74 17                	je     80105ff0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fd9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fde:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fdf:	a8 01                	test   $0x1,%al
80105fe1:	74 0d                	je     80105ff0 <uartgetc+0x20>
80105fe3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fe8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fe9:	0f b6 c0             	movzbl %al,%eax
80105fec:	c3                   	ret    
80105fed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ff5:	c3                   	ret    
80105ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffd:	8d 76 00             	lea    0x0(%esi),%esi

80106000 <uartinit>:
{
80106000:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106001:	31 c9                	xor    %ecx,%ecx
80106003:	89 c8                	mov    %ecx,%eax
80106005:	89 e5                	mov    %esp,%ebp
80106007:	57                   	push   %edi
80106008:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010600d:	56                   	push   %esi
8010600e:	89 fa                	mov    %edi,%edx
80106010:	53                   	push   %ebx
80106011:	83 ec 1c             	sub    $0x1c,%esp
80106014:	ee                   	out    %al,(%dx)
80106015:	be fb 03 00 00       	mov    $0x3fb,%esi
8010601a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010601f:	89 f2                	mov    %esi,%edx
80106021:	ee                   	out    %al,(%dx)
80106022:	b8 0c 00 00 00       	mov    $0xc,%eax
80106027:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010602c:	ee                   	out    %al,(%dx)
8010602d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106032:	89 c8                	mov    %ecx,%eax
80106034:	89 da                	mov    %ebx,%edx
80106036:	ee                   	out    %al,(%dx)
80106037:	b8 03 00 00 00       	mov    $0x3,%eax
8010603c:	89 f2                	mov    %esi,%edx
8010603e:	ee                   	out    %al,(%dx)
8010603f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106044:	89 c8                	mov    %ecx,%eax
80106046:	ee                   	out    %al,(%dx)
80106047:	b8 01 00 00 00       	mov    $0x1,%eax
8010604c:	89 da                	mov    %ebx,%edx
8010604e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010604f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106054:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106055:	3c ff                	cmp    $0xff,%al
80106057:	74 78                	je     801060d1 <uartinit+0xd1>
  uart = 1;
80106059:	c7 05 e0 55 11 80 01 	movl   $0x1,0x801155e0
80106060:	00 00 00 
80106063:	89 fa                	mov    %edi,%edx
80106065:	ec                   	in     (%dx),%al
80106066:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010606b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010606c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010606f:	bf 04 81 10 80       	mov    $0x80108104,%edi
80106074:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106079:	6a 00                	push   $0x0
8010607b:	6a 04                	push   $0x4
8010607d:	e8 0e c4 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106082:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106090:	a1 e0 55 11 80       	mov    0x801155e0,%eax
80106095:	bb 80 00 00 00       	mov    $0x80,%ebx
8010609a:	85 c0                	test   %eax,%eax
8010609c:	75 14                	jne    801060b2 <uartinit+0xb2>
8010609e:	eb 23                	jmp    801060c3 <uartinit+0xc3>
    microdelay(10);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	6a 0a                	push   $0xa
801060a5:	e8 96 ca ff ff       	call   80102b40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060aa:	83 c4 10             	add    $0x10,%esp
801060ad:	83 eb 01             	sub    $0x1,%ebx
801060b0:	74 07                	je     801060b9 <uartinit+0xb9>
801060b2:	89 f2                	mov    %esi,%edx
801060b4:	ec                   	in     (%dx),%al
801060b5:	a8 20                	test   $0x20,%al
801060b7:	74 e7                	je     801060a0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060b9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801060bd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060c2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801060c3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801060c7:	83 c7 01             	add    $0x1,%edi
801060ca:	88 45 e7             	mov    %al,-0x19(%ebp)
801060cd:	84 c0                	test   %al,%al
801060cf:	75 bf                	jne    80106090 <uartinit+0x90>
}
801060d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060d4:	5b                   	pop    %ebx
801060d5:	5e                   	pop    %esi
801060d6:	5f                   	pop    %edi
801060d7:	5d                   	pop    %ebp
801060d8:	c3                   	ret    
801060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060e0 <uartputc>:
  if(!uart)
801060e0:	a1 e0 55 11 80       	mov    0x801155e0,%eax
801060e5:	85 c0                	test   %eax,%eax
801060e7:	74 47                	je     80106130 <uartputc+0x50>
{
801060e9:	55                   	push   %ebp
801060ea:	89 e5                	mov    %esp,%ebp
801060ec:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801060f2:	53                   	push   %ebx
801060f3:	bb 80 00 00 00       	mov    $0x80,%ebx
801060f8:	eb 18                	jmp    80106112 <uartputc+0x32>
801060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106100:	83 ec 0c             	sub    $0xc,%esp
80106103:	6a 0a                	push   $0xa
80106105:	e8 36 ca ff ff       	call   80102b40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010610a:	83 c4 10             	add    $0x10,%esp
8010610d:	83 eb 01             	sub    $0x1,%ebx
80106110:	74 07                	je     80106119 <uartputc+0x39>
80106112:	89 f2                	mov    %esi,%edx
80106114:	ec                   	in     (%dx),%al
80106115:	a8 20                	test   $0x20,%al
80106117:	74 e7                	je     80106100 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106119:	8b 45 08             	mov    0x8(%ebp),%eax
8010611c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106121:	ee                   	out    %al,(%dx)
}
80106122:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106125:	5b                   	pop    %ebx
80106126:	5e                   	pop    %esi
80106127:	5d                   	pop    %ebp
80106128:	c3                   	ret    
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106130:	c3                   	ret    
80106131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop

80106140 <uartintr>:

void
uartintr(void)
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106146:	68 d0 5f 10 80       	push   $0x80105fd0
8010614b:	e8 30 a7 ff ff       	call   80100880 <consoleintr>
}
80106150:	83 c4 10             	add    $0x10,%esp
80106153:	c9                   	leave  
80106154:	c3                   	ret    

80106155 <vector0>:
80106155:	6a 00                	push   $0x0
80106157:	6a 00                	push   $0x0
80106159:	e9 0a fb ff ff       	jmp    80105c68 <alltraps>

8010615e <vector1>:
8010615e:	6a 00                	push   $0x0
80106160:	6a 01                	push   $0x1
80106162:	e9 01 fb ff ff       	jmp    80105c68 <alltraps>

80106167 <vector2>:
80106167:	6a 00                	push   $0x0
80106169:	6a 02                	push   $0x2
8010616b:	e9 f8 fa ff ff       	jmp    80105c68 <alltraps>

80106170 <vector3>:
80106170:	6a 00                	push   $0x0
80106172:	6a 03                	push   $0x3
80106174:	e9 ef fa ff ff       	jmp    80105c68 <alltraps>

80106179 <vector4>:
80106179:	6a 00                	push   $0x0
8010617b:	6a 04                	push   $0x4
8010617d:	e9 e6 fa ff ff       	jmp    80105c68 <alltraps>

80106182 <vector5>:
80106182:	6a 00                	push   $0x0
80106184:	6a 05                	push   $0x5
80106186:	e9 dd fa ff ff       	jmp    80105c68 <alltraps>

8010618b <vector6>:
8010618b:	6a 00                	push   $0x0
8010618d:	6a 06                	push   $0x6
8010618f:	e9 d4 fa ff ff       	jmp    80105c68 <alltraps>

80106194 <vector7>:
80106194:	6a 00                	push   $0x0
80106196:	6a 07                	push   $0x7
80106198:	e9 cb fa ff ff       	jmp    80105c68 <alltraps>

8010619d <vector8>:
8010619d:	6a 08                	push   $0x8
8010619f:	e9 c4 fa ff ff       	jmp    80105c68 <alltraps>

801061a4 <vector9>:
801061a4:	6a 00                	push   $0x0
801061a6:	6a 09                	push   $0x9
801061a8:	e9 bb fa ff ff       	jmp    80105c68 <alltraps>

801061ad <vector10>:
801061ad:	6a 0a                	push   $0xa
801061af:	e9 b4 fa ff ff       	jmp    80105c68 <alltraps>

801061b4 <vector11>:
801061b4:	6a 0b                	push   $0xb
801061b6:	e9 ad fa ff ff       	jmp    80105c68 <alltraps>

801061bb <vector12>:
801061bb:	6a 0c                	push   $0xc
801061bd:	e9 a6 fa ff ff       	jmp    80105c68 <alltraps>

801061c2 <vector13>:
801061c2:	6a 0d                	push   $0xd
801061c4:	e9 9f fa ff ff       	jmp    80105c68 <alltraps>

801061c9 <vector14>:
801061c9:	6a 0e                	push   $0xe
801061cb:	e9 98 fa ff ff       	jmp    80105c68 <alltraps>

801061d0 <vector15>:
801061d0:	6a 00                	push   $0x0
801061d2:	6a 0f                	push   $0xf
801061d4:	e9 8f fa ff ff       	jmp    80105c68 <alltraps>

801061d9 <vector16>:
801061d9:	6a 00                	push   $0x0
801061db:	6a 10                	push   $0x10
801061dd:	e9 86 fa ff ff       	jmp    80105c68 <alltraps>

801061e2 <vector17>:
801061e2:	6a 11                	push   $0x11
801061e4:	e9 7f fa ff ff       	jmp    80105c68 <alltraps>

801061e9 <vector18>:
801061e9:	6a 00                	push   $0x0
801061eb:	6a 12                	push   $0x12
801061ed:	e9 76 fa ff ff       	jmp    80105c68 <alltraps>

801061f2 <vector19>:
801061f2:	6a 00                	push   $0x0
801061f4:	6a 13                	push   $0x13
801061f6:	e9 6d fa ff ff       	jmp    80105c68 <alltraps>

801061fb <vector20>:
801061fb:	6a 00                	push   $0x0
801061fd:	6a 14                	push   $0x14
801061ff:	e9 64 fa ff ff       	jmp    80105c68 <alltraps>

80106204 <vector21>:
80106204:	6a 00                	push   $0x0
80106206:	6a 15                	push   $0x15
80106208:	e9 5b fa ff ff       	jmp    80105c68 <alltraps>

8010620d <vector22>:
8010620d:	6a 00                	push   $0x0
8010620f:	6a 16                	push   $0x16
80106211:	e9 52 fa ff ff       	jmp    80105c68 <alltraps>

80106216 <vector23>:
80106216:	6a 00                	push   $0x0
80106218:	6a 17                	push   $0x17
8010621a:	e9 49 fa ff ff       	jmp    80105c68 <alltraps>

8010621f <vector24>:
8010621f:	6a 00                	push   $0x0
80106221:	6a 18                	push   $0x18
80106223:	e9 40 fa ff ff       	jmp    80105c68 <alltraps>

80106228 <vector25>:
80106228:	6a 00                	push   $0x0
8010622a:	6a 19                	push   $0x19
8010622c:	e9 37 fa ff ff       	jmp    80105c68 <alltraps>

80106231 <vector26>:
80106231:	6a 00                	push   $0x0
80106233:	6a 1a                	push   $0x1a
80106235:	e9 2e fa ff ff       	jmp    80105c68 <alltraps>

8010623a <vector27>:
8010623a:	6a 00                	push   $0x0
8010623c:	6a 1b                	push   $0x1b
8010623e:	e9 25 fa ff ff       	jmp    80105c68 <alltraps>

80106243 <vector28>:
80106243:	6a 00                	push   $0x0
80106245:	6a 1c                	push   $0x1c
80106247:	e9 1c fa ff ff       	jmp    80105c68 <alltraps>

8010624c <vector29>:
8010624c:	6a 00                	push   $0x0
8010624e:	6a 1d                	push   $0x1d
80106250:	e9 13 fa ff ff       	jmp    80105c68 <alltraps>

80106255 <vector30>:
80106255:	6a 00                	push   $0x0
80106257:	6a 1e                	push   $0x1e
80106259:	e9 0a fa ff ff       	jmp    80105c68 <alltraps>

8010625e <vector31>:
8010625e:	6a 00                	push   $0x0
80106260:	6a 1f                	push   $0x1f
80106262:	e9 01 fa ff ff       	jmp    80105c68 <alltraps>

80106267 <vector32>:
80106267:	6a 00                	push   $0x0
80106269:	6a 20                	push   $0x20
8010626b:	e9 f8 f9 ff ff       	jmp    80105c68 <alltraps>

80106270 <vector33>:
80106270:	6a 00                	push   $0x0
80106272:	6a 21                	push   $0x21
80106274:	e9 ef f9 ff ff       	jmp    80105c68 <alltraps>

80106279 <vector34>:
80106279:	6a 00                	push   $0x0
8010627b:	6a 22                	push   $0x22
8010627d:	e9 e6 f9 ff ff       	jmp    80105c68 <alltraps>

80106282 <vector35>:
80106282:	6a 00                	push   $0x0
80106284:	6a 23                	push   $0x23
80106286:	e9 dd f9 ff ff       	jmp    80105c68 <alltraps>

8010628b <vector36>:
8010628b:	6a 00                	push   $0x0
8010628d:	6a 24                	push   $0x24
8010628f:	e9 d4 f9 ff ff       	jmp    80105c68 <alltraps>

80106294 <vector37>:
80106294:	6a 00                	push   $0x0
80106296:	6a 25                	push   $0x25
80106298:	e9 cb f9 ff ff       	jmp    80105c68 <alltraps>

8010629d <vector38>:
8010629d:	6a 00                	push   $0x0
8010629f:	6a 26                	push   $0x26
801062a1:	e9 c2 f9 ff ff       	jmp    80105c68 <alltraps>

801062a6 <vector39>:
801062a6:	6a 00                	push   $0x0
801062a8:	6a 27                	push   $0x27
801062aa:	e9 b9 f9 ff ff       	jmp    80105c68 <alltraps>

801062af <vector40>:
801062af:	6a 00                	push   $0x0
801062b1:	6a 28                	push   $0x28
801062b3:	e9 b0 f9 ff ff       	jmp    80105c68 <alltraps>

801062b8 <vector41>:
801062b8:	6a 00                	push   $0x0
801062ba:	6a 29                	push   $0x29
801062bc:	e9 a7 f9 ff ff       	jmp    80105c68 <alltraps>

801062c1 <vector42>:
801062c1:	6a 00                	push   $0x0
801062c3:	6a 2a                	push   $0x2a
801062c5:	e9 9e f9 ff ff       	jmp    80105c68 <alltraps>

801062ca <vector43>:
801062ca:	6a 00                	push   $0x0
801062cc:	6a 2b                	push   $0x2b
801062ce:	e9 95 f9 ff ff       	jmp    80105c68 <alltraps>

801062d3 <vector44>:
801062d3:	6a 00                	push   $0x0
801062d5:	6a 2c                	push   $0x2c
801062d7:	e9 8c f9 ff ff       	jmp    80105c68 <alltraps>

801062dc <vector45>:
801062dc:	6a 00                	push   $0x0
801062de:	6a 2d                	push   $0x2d
801062e0:	e9 83 f9 ff ff       	jmp    80105c68 <alltraps>

801062e5 <vector46>:
801062e5:	6a 00                	push   $0x0
801062e7:	6a 2e                	push   $0x2e
801062e9:	e9 7a f9 ff ff       	jmp    80105c68 <alltraps>

801062ee <vector47>:
801062ee:	6a 00                	push   $0x0
801062f0:	6a 2f                	push   $0x2f
801062f2:	e9 71 f9 ff ff       	jmp    80105c68 <alltraps>

801062f7 <vector48>:
801062f7:	6a 00                	push   $0x0
801062f9:	6a 30                	push   $0x30
801062fb:	e9 68 f9 ff ff       	jmp    80105c68 <alltraps>

80106300 <vector49>:
80106300:	6a 00                	push   $0x0
80106302:	6a 31                	push   $0x31
80106304:	e9 5f f9 ff ff       	jmp    80105c68 <alltraps>

80106309 <vector50>:
80106309:	6a 00                	push   $0x0
8010630b:	6a 32                	push   $0x32
8010630d:	e9 56 f9 ff ff       	jmp    80105c68 <alltraps>

80106312 <vector51>:
80106312:	6a 00                	push   $0x0
80106314:	6a 33                	push   $0x33
80106316:	e9 4d f9 ff ff       	jmp    80105c68 <alltraps>

8010631b <vector52>:
8010631b:	6a 00                	push   $0x0
8010631d:	6a 34                	push   $0x34
8010631f:	e9 44 f9 ff ff       	jmp    80105c68 <alltraps>

80106324 <vector53>:
80106324:	6a 00                	push   $0x0
80106326:	6a 35                	push   $0x35
80106328:	e9 3b f9 ff ff       	jmp    80105c68 <alltraps>

8010632d <vector54>:
8010632d:	6a 00                	push   $0x0
8010632f:	6a 36                	push   $0x36
80106331:	e9 32 f9 ff ff       	jmp    80105c68 <alltraps>

80106336 <vector55>:
80106336:	6a 00                	push   $0x0
80106338:	6a 37                	push   $0x37
8010633a:	e9 29 f9 ff ff       	jmp    80105c68 <alltraps>

8010633f <vector56>:
8010633f:	6a 00                	push   $0x0
80106341:	6a 38                	push   $0x38
80106343:	e9 20 f9 ff ff       	jmp    80105c68 <alltraps>

80106348 <vector57>:
80106348:	6a 00                	push   $0x0
8010634a:	6a 39                	push   $0x39
8010634c:	e9 17 f9 ff ff       	jmp    80105c68 <alltraps>

80106351 <vector58>:
80106351:	6a 00                	push   $0x0
80106353:	6a 3a                	push   $0x3a
80106355:	e9 0e f9 ff ff       	jmp    80105c68 <alltraps>

8010635a <vector59>:
8010635a:	6a 00                	push   $0x0
8010635c:	6a 3b                	push   $0x3b
8010635e:	e9 05 f9 ff ff       	jmp    80105c68 <alltraps>

80106363 <vector60>:
80106363:	6a 00                	push   $0x0
80106365:	6a 3c                	push   $0x3c
80106367:	e9 fc f8 ff ff       	jmp    80105c68 <alltraps>

8010636c <vector61>:
8010636c:	6a 00                	push   $0x0
8010636e:	6a 3d                	push   $0x3d
80106370:	e9 f3 f8 ff ff       	jmp    80105c68 <alltraps>

80106375 <vector62>:
80106375:	6a 00                	push   $0x0
80106377:	6a 3e                	push   $0x3e
80106379:	e9 ea f8 ff ff       	jmp    80105c68 <alltraps>

8010637e <vector63>:
8010637e:	6a 00                	push   $0x0
80106380:	6a 3f                	push   $0x3f
80106382:	e9 e1 f8 ff ff       	jmp    80105c68 <alltraps>

80106387 <vector64>:
80106387:	6a 00                	push   $0x0
80106389:	6a 40                	push   $0x40
8010638b:	e9 d8 f8 ff ff       	jmp    80105c68 <alltraps>

80106390 <vector65>:
80106390:	6a 00                	push   $0x0
80106392:	6a 41                	push   $0x41
80106394:	e9 cf f8 ff ff       	jmp    80105c68 <alltraps>

80106399 <vector66>:
80106399:	6a 00                	push   $0x0
8010639b:	6a 42                	push   $0x42
8010639d:	e9 c6 f8 ff ff       	jmp    80105c68 <alltraps>

801063a2 <vector67>:
801063a2:	6a 00                	push   $0x0
801063a4:	6a 43                	push   $0x43
801063a6:	e9 bd f8 ff ff       	jmp    80105c68 <alltraps>

801063ab <vector68>:
801063ab:	6a 00                	push   $0x0
801063ad:	6a 44                	push   $0x44
801063af:	e9 b4 f8 ff ff       	jmp    80105c68 <alltraps>

801063b4 <vector69>:
801063b4:	6a 00                	push   $0x0
801063b6:	6a 45                	push   $0x45
801063b8:	e9 ab f8 ff ff       	jmp    80105c68 <alltraps>

801063bd <vector70>:
801063bd:	6a 00                	push   $0x0
801063bf:	6a 46                	push   $0x46
801063c1:	e9 a2 f8 ff ff       	jmp    80105c68 <alltraps>

801063c6 <vector71>:
801063c6:	6a 00                	push   $0x0
801063c8:	6a 47                	push   $0x47
801063ca:	e9 99 f8 ff ff       	jmp    80105c68 <alltraps>

801063cf <vector72>:
801063cf:	6a 00                	push   $0x0
801063d1:	6a 48                	push   $0x48
801063d3:	e9 90 f8 ff ff       	jmp    80105c68 <alltraps>

801063d8 <vector73>:
801063d8:	6a 00                	push   $0x0
801063da:	6a 49                	push   $0x49
801063dc:	e9 87 f8 ff ff       	jmp    80105c68 <alltraps>

801063e1 <vector74>:
801063e1:	6a 00                	push   $0x0
801063e3:	6a 4a                	push   $0x4a
801063e5:	e9 7e f8 ff ff       	jmp    80105c68 <alltraps>

801063ea <vector75>:
801063ea:	6a 00                	push   $0x0
801063ec:	6a 4b                	push   $0x4b
801063ee:	e9 75 f8 ff ff       	jmp    80105c68 <alltraps>

801063f3 <vector76>:
801063f3:	6a 00                	push   $0x0
801063f5:	6a 4c                	push   $0x4c
801063f7:	e9 6c f8 ff ff       	jmp    80105c68 <alltraps>

801063fc <vector77>:
801063fc:	6a 00                	push   $0x0
801063fe:	6a 4d                	push   $0x4d
80106400:	e9 63 f8 ff ff       	jmp    80105c68 <alltraps>

80106405 <vector78>:
80106405:	6a 00                	push   $0x0
80106407:	6a 4e                	push   $0x4e
80106409:	e9 5a f8 ff ff       	jmp    80105c68 <alltraps>

8010640e <vector79>:
8010640e:	6a 00                	push   $0x0
80106410:	6a 4f                	push   $0x4f
80106412:	e9 51 f8 ff ff       	jmp    80105c68 <alltraps>

80106417 <vector80>:
80106417:	6a 00                	push   $0x0
80106419:	6a 50                	push   $0x50
8010641b:	e9 48 f8 ff ff       	jmp    80105c68 <alltraps>

80106420 <vector81>:
80106420:	6a 00                	push   $0x0
80106422:	6a 51                	push   $0x51
80106424:	e9 3f f8 ff ff       	jmp    80105c68 <alltraps>

80106429 <vector82>:
80106429:	6a 00                	push   $0x0
8010642b:	6a 52                	push   $0x52
8010642d:	e9 36 f8 ff ff       	jmp    80105c68 <alltraps>

80106432 <vector83>:
80106432:	6a 00                	push   $0x0
80106434:	6a 53                	push   $0x53
80106436:	e9 2d f8 ff ff       	jmp    80105c68 <alltraps>

8010643b <vector84>:
8010643b:	6a 00                	push   $0x0
8010643d:	6a 54                	push   $0x54
8010643f:	e9 24 f8 ff ff       	jmp    80105c68 <alltraps>

80106444 <vector85>:
80106444:	6a 00                	push   $0x0
80106446:	6a 55                	push   $0x55
80106448:	e9 1b f8 ff ff       	jmp    80105c68 <alltraps>

8010644d <vector86>:
8010644d:	6a 00                	push   $0x0
8010644f:	6a 56                	push   $0x56
80106451:	e9 12 f8 ff ff       	jmp    80105c68 <alltraps>

80106456 <vector87>:
80106456:	6a 00                	push   $0x0
80106458:	6a 57                	push   $0x57
8010645a:	e9 09 f8 ff ff       	jmp    80105c68 <alltraps>

8010645f <vector88>:
8010645f:	6a 00                	push   $0x0
80106461:	6a 58                	push   $0x58
80106463:	e9 00 f8 ff ff       	jmp    80105c68 <alltraps>

80106468 <vector89>:
80106468:	6a 00                	push   $0x0
8010646a:	6a 59                	push   $0x59
8010646c:	e9 f7 f7 ff ff       	jmp    80105c68 <alltraps>

80106471 <vector90>:
80106471:	6a 00                	push   $0x0
80106473:	6a 5a                	push   $0x5a
80106475:	e9 ee f7 ff ff       	jmp    80105c68 <alltraps>

8010647a <vector91>:
8010647a:	6a 00                	push   $0x0
8010647c:	6a 5b                	push   $0x5b
8010647e:	e9 e5 f7 ff ff       	jmp    80105c68 <alltraps>

80106483 <vector92>:
80106483:	6a 00                	push   $0x0
80106485:	6a 5c                	push   $0x5c
80106487:	e9 dc f7 ff ff       	jmp    80105c68 <alltraps>

8010648c <vector93>:
8010648c:	6a 00                	push   $0x0
8010648e:	6a 5d                	push   $0x5d
80106490:	e9 d3 f7 ff ff       	jmp    80105c68 <alltraps>

80106495 <vector94>:
80106495:	6a 00                	push   $0x0
80106497:	6a 5e                	push   $0x5e
80106499:	e9 ca f7 ff ff       	jmp    80105c68 <alltraps>

8010649e <vector95>:
8010649e:	6a 00                	push   $0x0
801064a0:	6a 5f                	push   $0x5f
801064a2:	e9 c1 f7 ff ff       	jmp    80105c68 <alltraps>

801064a7 <vector96>:
801064a7:	6a 00                	push   $0x0
801064a9:	6a 60                	push   $0x60
801064ab:	e9 b8 f7 ff ff       	jmp    80105c68 <alltraps>

801064b0 <vector97>:
801064b0:	6a 00                	push   $0x0
801064b2:	6a 61                	push   $0x61
801064b4:	e9 af f7 ff ff       	jmp    80105c68 <alltraps>

801064b9 <vector98>:
801064b9:	6a 00                	push   $0x0
801064bb:	6a 62                	push   $0x62
801064bd:	e9 a6 f7 ff ff       	jmp    80105c68 <alltraps>

801064c2 <vector99>:
801064c2:	6a 00                	push   $0x0
801064c4:	6a 63                	push   $0x63
801064c6:	e9 9d f7 ff ff       	jmp    80105c68 <alltraps>

801064cb <vector100>:
801064cb:	6a 00                	push   $0x0
801064cd:	6a 64                	push   $0x64
801064cf:	e9 94 f7 ff ff       	jmp    80105c68 <alltraps>

801064d4 <vector101>:
801064d4:	6a 00                	push   $0x0
801064d6:	6a 65                	push   $0x65
801064d8:	e9 8b f7 ff ff       	jmp    80105c68 <alltraps>

801064dd <vector102>:
801064dd:	6a 00                	push   $0x0
801064df:	6a 66                	push   $0x66
801064e1:	e9 82 f7 ff ff       	jmp    80105c68 <alltraps>

801064e6 <vector103>:
801064e6:	6a 00                	push   $0x0
801064e8:	6a 67                	push   $0x67
801064ea:	e9 79 f7 ff ff       	jmp    80105c68 <alltraps>

801064ef <vector104>:
801064ef:	6a 00                	push   $0x0
801064f1:	6a 68                	push   $0x68
801064f3:	e9 70 f7 ff ff       	jmp    80105c68 <alltraps>

801064f8 <vector105>:
801064f8:	6a 00                	push   $0x0
801064fa:	6a 69                	push   $0x69
801064fc:	e9 67 f7 ff ff       	jmp    80105c68 <alltraps>

80106501 <vector106>:
80106501:	6a 00                	push   $0x0
80106503:	6a 6a                	push   $0x6a
80106505:	e9 5e f7 ff ff       	jmp    80105c68 <alltraps>

8010650a <vector107>:
8010650a:	6a 00                	push   $0x0
8010650c:	6a 6b                	push   $0x6b
8010650e:	e9 55 f7 ff ff       	jmp    80105c68 <alltraps>

80106513 <vector108>:
80106513:	6a 00                	push   $0x0
80106515:	6a 6c                	push   $0x6c
80106517:	e9 4c f7 ff ff       	jmp    80105c68 <alltraps>

8010651c <vector109>:
8010651c:	6a 00                	push   $0x0
8010651e:	6a 6d                	push   $0x6d
80106520:	e9 43 f7 ff ff       	jmp    80105c68 <alltraps>

80106525 <vector110>:
80106525:	6a 00                	push   $0x0
80106527:	6a 6e                	push   $0x6e
80106529:	e9 3a f7 ff ff       	jmp    80105c68 <alltraps>

8010652e <vector111>:
8010652e:	6a 00                	push   $0x0
80106530:	6a 6f                	push   $0x6f
80106532:	e9 31 f7 ff ff       	jmp    80105c68 <alltraps>

80106537 <vector112>:
80106537:	6a 00                	push   $0x0
80106539:	6a 70                	push   $0x70
8010653b:	e9 28 f7 ff ff       	jmp    80105c68 <alltraps>

80106540 <vector113>:
80106540:	6a 00                	push   $0x0
80106542:	6a 71                	push   $0x71
80106544:	e9 1f f7 ff ff       	jmp    80105c68 <alltraps>

80106549 <vector114>:
80106549:	6a 00                	push   $0x0
8010654b:	6a 72                	push   $0x72
8010654d:	e9 16 f7 ff ff       	jmp    80105c68 <alltraps>

80106552 <vector115>:
80106552:	6a 00                	push   $0x0
80106554:	6a 73                	push   $0x73
80106556:	e9 0d f7 ff ff       	jmp    80105c68 <alltraps>

8010655b <vector116>:
8010655b:	6a 00                	push   $0x0
8010655d:	6a 74                	push   $0x74
8010655f:	e9 04 f7 ff ff       	jmp    80105c68 <alltraps>

80106564 <vector117>:
80106564:	6a 00                	push   $0x0
80106566:	6a 75                	push   $0x75
80106568:	e9 fb f6 ff ff       	jmp    80105c68 <alltraps>

8010656d <vector118>:
8010656d:	6a 00                	push   $0x0
8010656f:	6a 76                	push   $0x76
80106571:	e9 f2 f6 ff ff       	jmp    80105c68 <alltraps>

80106576 <vector119>:
80106576:	6a 00                	push   $0x0
80106578:	6a 77                	push   $0x77
8010657a:	e9 e9 f6 ff ff       	jmp    80105c68 <alltraps>

8010657f <vector120>:
8010657f:	6a 00                	push   $0x0
80106581:	6a 78                	push   $0x78
80106583:	e9 e0 f6 ff ff       	jmp    80105c68 <alltraps>

80106588 <vector121>:
80106588:	6a 00                	push   $0x0
8010658a:	6a 79                	push   $0x79
8010658c:	e9 d7 f6 ff ff       	jmp    80105c68 <alltraps>

80106591 <vector122>:
80106591:	6a 00                	push   $0x0
80106593:	6a 7a                	push   $0x7a
80106595:	e9 ce f6 ff ff       	jmp    80105c68 <alltraps>

8010659a <vector123>:
8010659a:	6a 00                	push   $0x0
8010659c:	6a 7b                	push   $0x7b
8010659e:	e9 c5 f6 ff ff       	jmp    80105c68 <alltraps>

801065a3 <vector124>:
801065a3:	6a 00                	push   $0x0
801065a5:	6a 7c                	push   $0x7c
801065a7:	e9 bc f6 ff ff       	jmp    80105c68 <alltraps>

801065ac <vector125>:
801065ac:	6a 00                	push   $0x0
801065ae:	6a 7d                	push   $0x7d
801065b0:	e9 b3 f6 ff ff       	jmp    80105c68 <alltraps>

801065b5 <vector126>:
801065b5:	6a 00                	push   $0x0
801065b7:	6a 7e                	push   $0x7e
801065b9:	e9 aa f6 ff ff       	jmp    80105c68 <alltraps>

801065be <vector127>:
801065be:	6a 00                	push   $0x0
801065c0:	6a 7f                	push   $0x7f
801065c2:	e9 a1 f6 ff ff       	jmp    80105c68 <alltraps>

801065c7 <vector128>:
801065c7:	6a 00                	push   $0x0
801065c9:	68 80 00 00 00       	push   $0x80
801065ce:	e9 95 f6 ff ff       	jmp    80105c68 <alltraps>

801065d3 <vector129>:
801065d3:	6a 00                	push   $0x0
801065d5:	68 81 00 00 00       	push   $0x81
801065da:	e9 89 f6 ff ff       	jmp    80105c68 <alltraps>

801065df <vector130>:
801065df:	6a 00                	push   $0x0
801065e1:	68 82 00 00 00       	push   $0x82
801065e6:	e9 7d f6 ff ff       	jmp    80105c68 <alltraps>

801065eb <vector131>:
801065eb:	6a 00                	push   $0x0
801065ed:	68 83 00 00 00       	push   $0x83
801065f2:	e9 71 f6 ff ff       	jmp    80105c68 <alltraps>

801065f7 <vector132>:
801065f7:	6a 00                	push   $0x0
801065f9:	68 84 00 00 00       	push   $0x84
801065fe:	e9 65 f6 ff ff       	jmp    80105c68 <alltraps>

80106603 <vector133>:
80106603:	6a 00                	push   $0x0
80106605:	68 85 00 00 00       	push   $0x85
8010660a:	e9 59 f6 ff ff       	jmp    80105c68 <alltraps>

8010660f <vector134>:
8010660f:	6a 00                	push   $0x0
80106611:	68 86 00 00 00       	push   $0x86
80106616:	e9 4d f6 ff ff       	jmp    80105c68 <alltraps>

8010661b <vector135>:
8010661b:	6a 00                	push   $0x0
8010661d:	68 87 00 00 00       	push   $0x87
80106622:	e9 41 f6 ff ff       	jmp    80105c68 <alltraps>

80106627 <vector136>:
80106627:	6a 00                	push   $0x0
80106629:	68 88 00 00 00       	push   $0x88
8010662e:	e9 35 f6 ff ff       	jmp    80105c68 <alltraps>

80106633 <vector137>:
80106633:	6a 00                	push   $0x0
80106635:	68 89 00 00 00       	push   $0x89
8010663a:	e9 29 f6 ff ff       	jmp    80105c68 <alltraps>

8010663f <vector138>:
8010663f:	6a 00                	push   $0x0
80106641:	68 8a 00 00 00       	push   $0x8a
80106646:	e9 1d f6 ff ff       	jmp    80105c68 <alltraps>

8010664b <vector139>:
8010664b:	6a 00                	push   $0x0
8010664d:	68 8b 00 00 00       	push   $0x8b
80106652:	e9 11 f6 ff ff       	jmp    80105c68 <alltraps>

80106657 <vector140>:
80106657:	6a 00                	push   $0x0
80106659:	68 8c 00 00 00       	push   $0x8c
8010665e:	e9 05 f6 ff ff       	jmp    80105c68 <alltraps>

80106663 <vector141>:
80106663:	6a 00                	push   $0x0
80106665:	68 8d 00 00 00       	push   $0x8d
8010666a:	e9 f9 f5 ff ff       	jmp    80105c68 <alltraps>

8010666f <vector142>:
8010666f:	6a 00                	push   $0x0
80106671:	68 8e 00 00 00       	push   $0x8e
80106676:	e9 ed f5 ff ff       	jmp    80105c68 <alltraps>

8010667b <vector143>:
8010667b:	6a 00                	push   $0x0
8010667d:	68 8f 00 00 00       	push   $0x8f
80106682:	e9 e1 f5 ff ff       	jmp    80105c68 <alltraps>

80106687 <vector144>:
80106687:	6a 00                	push   $0x0
80106689:	68 90 00 00 00       	push   $0x90
8010668e:	e9 d5 f5 ff ff       	jmp    80105c68 <alltraps>

80106693 <vector145>:
80106693:	6a 00                	push   $0x0
80106695:	68 91 00 00 00       	push   $0x91
8010669a:	e9 c9 f5 ff ff       	jmp    80105c68 <alltraps>

8010669f <vector146>:
8010669f:	6a 00                	push   $0x0
801066a1:	68 92 00 00 00       	push   $0x92
801066a6:	e9 bd f5 ff ff       	jmp    80105c68 <alltraps>

801066ab <vector147>:
801066ab:	6a 00                	push   $0x0
801066ad:	68 93 00 00 00       	push   $0x93
801066b2:	e9 b1 f5 ff ff       	jmp    80105c68 <alltraps>

801066b7 <vector148>:
801066b7:	6a 00                	push   $0x0
801066b9:	68 94 00 00 00       	push   $0x94
801066be:	e9 a5 f5 ff ff       	jmp    80105c68 <alltraps>

801066c3 <vector149>:
801066c3:	6a 00                	push   $0x0
801066c5:	68 95 00 00 00       	push   $0x95
801066ca:	e9 99 f5 ff ff       	jmp    80105c68 <alltraps>

801066cf <vector150>:
801066cf:	6a 00                	push   $0x0
801066d1:	68 96 00 00 00       	push   $0x96
801066d6:	e9 8d f5 ff ff       	jmp    80105c68 <alltraps>

801066db <vector151>:
801066db:	6a 00                	push   $0x0
801066dd:	68 97 00 00 00       	push   $0x97
801066e2:	e9 81 f5 ff ff       	jmp    80105c68 <alltraps>

801066e7 <vector152>:
801066e7:	6a 00                	push   $0x0
801066e9:	68 98 00 00 00       	push   $0x98
801066ee:	e9 75 f5 ff ff       	jmp    80105c68 <alltraps>

801066f3 <vector153>:
801066f3:	6a 00                	push   $0x0
801066f5:	68 99 00 00 00       	push   $0x99
801066fa:	e9 69 f5 ff ff       	jmp    80105c68 <alltraps>

801066ff <vector154>:
801066ff:	6a 00                	push   $0x0
80106701:	68 9a 00 00 00       	push   $0x9a
80106706:	e9 5d f5 ff ff       	jmp    80105c68 <alltraps>

8010670b <vector155>:
8010670b:	6a 00                	push   $0x0
8010670d:	68 9b 00 00 00       	push   $0x9b
80106712:	e9 51 f5 ff ff       	jmp    80105c68 <alltraps>

80106717 <vector156>:
80106717:	6a 00                	push   $0x0
80106719:	68 9c 00 00 00       	push   $0x9c
8010671e:	e9 45 f5 ff ff       	jmp    80105c68 <alltraps>

80106723 <vector157>:
80106723:	6a 00                	push   $0x0
80106725:	68 9d 00 00 00       	push   $0x9d
8010672a:	e9 39 f5 ff ff       	jmp    80105c68 <alltraps>

8010672f <vector158>:
8010672f:	6a 00                	push   $0x0
80106731:	68 9e 00 00 00       	push   $0x9e
80106736:	e9 2d f5 ff ff       	jmp    80105c68 <alltraps>

8010673b <vector159>:
8010673b:	6a 00                	push   $0x0
8010673d:	68 9f 00 00 00       	push   $0x9f
80106742:	e9 21 f5 ff ff       	jmp    80105c68 <alltraps>

80106747 <vector160>:
80106747:	6a 00                	push   $0x0
80106749:	68 a0 00 00 00       	push   $0xa0
8010674e:	e9 15 f5 ff ff       	jmp    80105c68 <alltraps>

80106753 <vector161>:
80106753:	6a 00                	push   $0x0
80106755:	68 a1 00 00 00       	push   $0xa1
8010675a:	e9 09 f5 ff ff       	jmp    80105c68 <alltraps>

8010675f <vector162>:
8010675f:	6a 00                	push   $0x0
80106761:	68 a2 00 00 00       	push   $0xa2
80106766:	e9 fd f4 ff ff       	jmp    80105c68 <alltraps>

8010676b <vector163>:
8010676b:	6a 00                	push   $0x0
8010676d:	68 a3 00 00 00       	push   $0xa3
80106772:	e9 f1 f4 ff ff       	jmp    80105c68 <alltraps>

80106777 <vector164>:
80106777:	6a 00                	push   $0x0
80106779:	68 a4 00 00 00       	push   $0xa4
8010677e:	e9 e5 f4 ff ff       	jmp    80105c68 <alltraps>

80106783 <vector165>:
80106783:	6a 00                	push   $0x0
80106785:	68 a5 00 00 00       	push   $0xa5
8010678a:	e9 d9 f4 ff ff       	jmp    80105c68 <alltraps>

8010678f <vector166>:
8010678f:	6a 00                	push   $0x0
80106791:	68 a6 00 00 00       	push   $0xa6
80106796:	e9 cd f4 ff ff       	jmp    80105c68 <alltraps>

8010679b <vector167>:
8010679b:	6a 00                	push   $0x0
8010679d:	68 a7 00 00 00       	push   $0xa7
801067a2:	e9 c1 f4 ff ff       	jmp    80105c68 <alltraps>

801067a7 <vector168>:
801067a7:	6a 00                	push   $0x0
801067a9:	68 a8 00 00 00       	push   $0xa8
801067ae:	e9 b5 f4 ff ff       	jmp    80105c68 <alltraps>

801067b3 <vector169>:
801067b3:	6a 00                	push   $0x0
801067b5:	68 a9 00 00 00       	push   $0xa9
801067ba:	e9 a9 f4 ff ff       	jmp    80105c68 <alltraps>

801067bf <vector170>:
801067bf:	6a 00                	push   $0x0
801067c1:	68 aa 00 00 00       	push   $0xaa
801067c6:	e9 9d f4 ff ff       	jmp    80105c68 <alltraps>

801067cb <vector171>:
801067cb:	6a 00                	push   $0x0
801067cd:	68 ab 00 00 00       	push   $0xab
801067d2:	e9 91 f4 ff ff       	jmp    80105c68 <alltraps>

801067d7 <vector172>:
801067d7:	6a 00                	push   $0x0
801067d9:	68 ac 00 00 00       	push   $0xac
801067de:	e9 85 f4 ff ff       	jmp    80105c68 <alltraps>

801067e3 <vector173>:
801067e3:	6a 00                	push   $0x0
801067e5:	68 ad 00 00 00       	push   $0xad
801067ea:	e9 79 f4 ff ff       	jmp    80105c68 <alltraps>

801067ef <vector174>:
801067ef:	6a 00                	push   $0x0
801067f1:	68 ae 00 00 00       	push   $0xae
801067f6:	e9 6d f4 ff ff       	jmp    80105c68 <alltraps>

801067fb <vector175>:
801067fb:	6a 00                	push   $0x0
801067fd:	68 af 00 00 00       	push   $0xaf
80106802:	e9 61 f4 ff ff       	jmp    80105c68 <alltraps>

80106807 <vector176>:
80106807:	6a 00                	push   $0x0
80106809:	68 b0 00 00 00       	push   $0xb0
8010680e:	e9 55 f4 ff ff       	jmp    80105c68 <alltraps>

80106813 <vector177>:
80106813:	6a 00                	push   $0x0
80106815:	68 b1 00 00 00       	push   $0xb1
8010681a:	e9 49 f4 ff ff       	jmp    80105c68 <alltraps>

8010681f <vector178>:
8010681f:	6a 00                	push   $0x0
80106821:	68 b2 00 00 00       	push   $0xb2
80106826:	e9 3d f4 ff ff       	jmp    80105c68 <alltraps>

8010682b <vector179>:
8010682b:	6a 00                	push   $0x0
8010682d:	68 b3 00 00 00       	push   $0xb3
80106832:	e9 31 f4 ff ff       	jmp    80105c68 <alltraps>

80106837 <vector180>:
80106837:	6a 00                	push   $0x0
80106839:	68 b4 00 00 00       	push   $0xb4
8010683e:	e9 25 f4 ff ff       	jmp    80105c68 <alltraps>

80106843 <vector181>:
80106843:	6a 00                	push   $0x0
80106845:	68 b5 00 00 00       	push   $0xb5
8010684a:	e9 19 f4 ff ff       	jmp    80105c68 <alltraps>

8010684f <vector182>:
8010684f:	6a 00                	push   $0x0
80106851:	68 b6 00 00 00       	push   $0xb6
80106856:	e9 0d f4 ff ff       	jmp    80105c68 <alltraps>

8010685b <vector183>:
8010685b:	6a 00                	push   $0x0
8010685d:	68 b7 00 00 00       	push   $0xb7
80106862:	e9 01 f4 ff ff       	jmp    80105c68 <alltraps>

80106867 <vector184>:
80106867:	6a 00                	push   $0x0
80106869:	68 b8 00 00 00       	push   $0xb8
8010686e:	e9 f5 f3 ff ff       	jmp    80105c68 <alltraps>

80106873 <vector185>:
80106873:	6a 00                	push   $0x0
80106875:	68 b9 00 00 00       	push   $0xb9
8010687a:	e9 e9 f3 ff ff       	jmp    80105c68 <alltraps>

8010687f <vector186>:
8010687f:	6a 00                	push   $0x0
80106881:	68 ba 00 00 00       	push   $0xba
80106886:	e9 dd f3 ff ff       	jmp    80105c68 <alltraps>

8010688b <vector187>:
8010688b:	6a 00                	push   $0x0
8010688d:	68 bb 00 00 00       	push   $0xbb
80106892:	e9 d1 f3 ff ff       	jmp    80105c68 <alltraps>

80106897 <vector188>:
80106897:	6a 00                	push   $0x0
80106899:	68 bc 00 00 00       	push   $0xbc
8010689e:	e9 c5 f3 ff ff       	jmp    80105c68 <alltraps>

801068a3 <vector189>:
801068a3:	6a 00                	push   $0x0
801068a5:	68 bd 00 00 00       	push   $0xbd
801068aa:	e9 b9 f3 ff ff       	jmp    80105c68 <alltraps>

801068af <vector190>:
801068af:	6a 00                	push   $0x0
801068b1:	68 be 00 00 00       	push   $0xbe
801068b6:	e9 ad f3 ff ff       	jmp    80105c68 <alltraps>

801068bb <vector191>:
801068bb:	6a 00                	push   $0x0
801068bd:	68 bf 00 00 00       	push   $0xbf
801068c2:	e9 a1 f3 ff ff       	jmp    80105c68 <alltraps>

801068c7 <vector192>:
801068c7:	6a 00                	push   $0x0
801068c9:	68 c0 00 00 00       	push   $0xc0
801068ce:	e9 95 f3 ff ff       	jmp    80105c68 <alltraps>

801068d3 <vector193>:
801068d3:	6a 00                	push   $0x0
801068d5:	68 c1 00 00 00       	push   $0xc1
801068da:	e9 89 f3 ff ff       	jmp    80105c68 <alltraps>

801068df <vector194>:
801068df:	6a 00                	push   $0x0
801068e1:	68 c2 00 00 00       	push   $0xc2
801068e6:	e9 7d f3 ff ff       	jmp    80105c68 <alltraps>

801068eb <vector195>:
801068eb:	6a 00                	push   $0x0
801068ed:	68 c3 00 00 00       	push   $0xc3
801068f2:	e9 71 f3 ff ff       	jmp    80105c68 <alltraps>

801068f7 <vector196>:
801068f7:	6a 00                	push   $0x0
801068f9:	68 c4 00 00 00       	push   $0xc4
801068fe:	e9 65 f3 ff ff       	jmp    80105c68 <alltraps>

80106903 <vector197>:
80106903:	6a 00                	push   $0x0
80106905:	68 c5 00 00 00       	push   $0xc5
8010690a:	e9 59 f3 ff ff       	jmp    80105c68 <alltraps>

8010690f <vector198>:
8010690f:	6a 00                	push   $0x0
80106911:	68 c6 00 00 00       	push   $0xc6
80106916:	e9 4d f3 ff ff       	jmp    80105c68 <alltraps>

8010691b <vector199>:
8010691b:	6a 00                	push   $0x0
8010691d:	68 c7 00 00 00       	push   $0xc7
80106922:	e9 41 f3 ff ff       	jmp    80105c68 <alltraps>

80106927 <vector200>:
80106927:	6a 00                	push   $0x0
80106929:	68 c8 00 00 00       	push   $0xc8
8010692e:	e9 35 f3 ff ff       	jmp    80105c68 <alltraps>

80106933 <vector201>:
80106933:	6a 00                	push   $0x0
80106935:	68 c9 00 00 00       	push   $0xc9
8010693a:	e9 29 f3 ff ff       	jmp    80105c68 <alltraps>

8010693f <vector202>:
8010693f:	6a 00                	push   $0x0
80106941:	68 ca 00 00 00       	push   $0xca
80106946:	e9 1d f3 ff ff       	jmp    80105c68 <alltraps>

8010694b <vector203>:
8010694b:	6a 00                	push   $0x0
8010694d:	68 cb 00 00 00       	push   $0xcb
80106952:	e9 11 f3 ff ff       	jmp    80105c68 <alltraps>

80106957 <vector204>:
80106957:	6a 00                	push   $0x0
80106959:	68 cc 00 00 00       	push   $0xcc
8010695e:	e9 05 f3 ff ff       	jmp    80105c68 <alltraps>

80106963 <vector205>:
80106963:	6a 00                	push   $0x0
80106965:	68 cd 00 00 00       	push   $0xcd
8010696a:	e9 f9 f2 ff ff       	jmp    80105c68 <alltraps>

8010696f <vector206>:
8010696f:	6a 00                	push   $0x0
80106971:	68 ce 00 00 00       	push   $0xce
80106976:	e9 ed f2 ff ff       	jmp    80105c68 <alltraps>

8010697b <vector207>:
8010697b:	6a 00                	push   $0x0
8010697d:	68 cf 00 00 00       	push   $0xcf
80106982:	e9 e1 f2 ff ff       	jmp    80105c68 <alltraps>

80106987 <vector208>:
80106987:	6a 00                	push   $0x0
80106989:	68 d0 00 00 00       	push   $0xd0
8010698e:	e9 d5 f2 ff ff       	jmp    80105c68 <alltraps>

80106993 <vector209>:
80106993:	6a 00                	push   $0x0
80106995:	68 d1 00 00 00       	push   $0xd1
8010699a:	e9 c9 f2 ff ff       	jmp    80105c68 <alltraps>

8010699f <vector210>:
8010699f:	6a 00                	push   $0x0
801069a1:	68 d2 00 00 00       	push   $0xd2
801069a6:	e9 bd f2 ff ff       	jmp    80105c68 <alltraps>

801069ab <vector211>:
801069ab:	6a 00                	push   $0x0
801069ad:	68 d3 00 00 00       	push   $0xd3
801069b2:	e9 b1 f2 ff ff       	jmp    80105c68 <alltraps>

801069b7 <vector212>:
801069b7:	6a 00                	push   $0x0
801069b9:	68 d4 00 00 00       	push   $0xd4
801069be:	e9 a5 f2 ff ff       	jmp    80105c68 <alltraps>

801069c3 <vector213>:
801069c3:	6a 00                	push   $0x0
801069c5:	68 d5 00 00 00       	push   $0xd5
801069ca:	e9 99 f2 ff ff       	jmp    80105c68 <alltraps>

801069cf <vector214>:
801069cf:	6a 00                	push   $0x0
801069d1:	68 d6 00 00 00       	push   $0xd6
801069d6:	e9 8d f2 ff ff       	jmp    80105c68 <alltraps>

801069db <vector215>:
801069db:	6a 00                	push   $0x0
801069dd:	68 d7 00 00 00       	push   $0xd7
801069e2:	e9 81 f2 ff ff       	jmp    80105c68 <alltraps>

801069e7 <vector216>:
801069e7:	6a 00                	push   $0x0
801069e9:	68 d8 00 00 00       	push   $0xd8
801069ee:	e9 75 f2 ff ff       	jmp    80105c68 <alltraps>

801069f3 <vector217>:
801069f3:	6a 00                	push   $0x0
801069f5:	68 d9 00 00 00       	push   $0xd9
801069fa:	e9 69 f2 ff ff       	jmp    80105c68 <alltraps>

801069ff <vector218>:
801069ff:	6a 00                	push   $0x0
80106a01:	68 da 00 00 00       	push   $0xda
80106a06:	e9 5d f2 ff ff       	jmp    80105c68 <alltraps>

80106a0b <vector219>:
80106a0b:	6a 00                	push   $0x0
80106a0d:	68 db 00 00 00       	push   $0xdb
80106a12:	e9 51 f2 ff ff       	jmp    80105c68 <alltraps>

80106a17 <vector220>:
80106a17:	6a 00                	push   $0x0
80106a19:	68 dc 00 00 00       	push   $0xdc
80106a1e:	e9 45 f2 ff ff       	jmp    80105c68 <alltraps>

80106a23 <vector221>:
80106a23:	6a 00                	push   $0x0
80106a25:	68 dd 00 00 00       	push   $0xdd
80106a2a:	e9 39 f2 ff ff       	jmp    80105c68 <alltraps>

80106a2f <vector222>:
80106a2f:	6a 00                	push   $0x0
80106a31:	68 de 00 00 00       	push   $0xde
80106a36:	e9 2d f2 ff ff       	jmp    80105c68 <alltraps>

80106a3b <vector223>:
80106a3b:	6a 00                	push   $0x0
80106a3d:	68 df 00 00 00       	push   $0xdf
80106a42:	e9 21 f2 ff ff       	jmp    80105c68 <alltraps>

80106a47 <vector224>:
80106a47:	6a 00                	push   $0x0
80106a49:	68 e0 00 00 00       	push   $0xe0
80106a4e:	e9 15 f2 ff ff       	jmp    80105c68 <alltraps>

80106a53 <vector225>:
80106a53:	6a 00                	push   $0x0
80106a55:	68 e1 00 00 00       	push   $0xe1
80106a5a:	e9 09 f2 ff ff       	jmp    80105c68 <alltraps>

80106a5f <vector226>:
80106a5f:	6a 00                	push   $0x0
80106a61:	68 e2 00 00 00       	push   $0xe2
80106a66:	e9 fd f1 ff ff       	jmp    80105c68 <alltraps>

80106a6b <vector227>:
80106a6b:	6a 00                	push   $0x0
80106a6d:	68 e3 00 00 00       	push   $0xe3
80106a72:	e9 f1 f1 ff ff       	jmp    80105c68 <alltraps>

80106a77 <vector228>:
80106a77:	6a 00                	push   $0x0
80106a79:	68 e4 00 00 00       	push   $0xe4
80106a7e:	e9 e5 f1 ff ff       	jmp    80105c68 <alltraps>

80106a83 <vector229>:
80106a83:	6a 00                	push   $0x0
80106a85:	68 e5 00 00 00       	push   $0xe5
80106a8a:	e9 d9 f1 ff ff       	jmp    80105c68 <alltraps>

80106a8f <vector230>:
80106a8f:	6a 00                	push   $0x0
80106a91:	68 e6 00 00 00       	push   $0xe6
80106a96:	e9 cd f1 ff ff       	jmp    80105c68 <alltraps>

80106a9b <vector231>:
80106a9b:	6a 00                	push   $0x0
80106a9d:	68 e7 00 00 00       	push   $0xe7
80106aa2:	e9 c1 f1 ff ff       	jmp    80105c68 <alltraps>

80106aa7 <vector232>:
80106aa7:	6a 00                	push   $0x0
80106aa9:	68 e8 00 00 00       	push   $0xe8
80106aae:	e9 b5 f1 ff ff       	jmp    80105c68 <alltraps>

80106ab3 <vector233>:
80106ab3:	6a 00                	push   $0x0
80106ab5:	68 e9 00 00 00       	push   $0xe9
80106aba:	e9 a9 f1 ff ff       	jmp    80105c68 <alltraps>

80106abf <vector234>:
80106abf:	6a 00                	push   $0x0
80106ac1:	68 ea 00 00 00       	push   $0xea
80106ac6:	e9 9d f1 ff ff       	jmp    80105c68 <alltraps>

80106acb <vector235>:
80106acb:	6a 00                	push   $0x0
80106acd:	68 eb 00 00 00       	push   $0xeb
80106ad2:	e9 91 f1 ff ff       	jmp    80105c68 <alltraps>

80106ad7 <vector236>:
80106ad7:	6a 00                	push   $0x0
80106ad9:	68 ec 00 00 00       	push   $0xec
80106ade:	e9 85 f1 ff ff       	jmp    80105c68 <alltraps>

80106ae3 <vector237>:
80106ae3:	6a 00                	push   $0x0
80106ae5:	68 ed 00 00 00       	push   $0xed
80106aea:	e9 79 f1 ff ff       	jmp    80105c68 <alltraps>

80106aef <vector238>:
80106aef:	6a 00                	push   $0x0
80106af1:	68 ee 00 00 00       	push   $0xee
80106af6:	e9 6d f1 ff ff       	jmp    80105c68 <alltraps>

80106afb <vector239>:
80106afb:	6a 00                	push   $0x0
80106afd:	68 ef 00 00 00       	push   $0xef
80106b02:	e9 61 f1 ff ff       	jmp    80105c68 <alltraps>

80106b07 <vector240>:
80106b07:	6a 00                	push   $0x0
80106b09:	68 f0 00 00 00       	push   $0xf0
80106b0e:	e9 55 f1 ff ff       	jmp    80105c68 <alltraps>

80106b13 <vector241>:
80106b13:	6a 00                	push   $0x0
80106b15:	68 f1 00 00 00       	push   $0xf1
80106b1a:	e9 49 f1 ff ff       	jmp    80105c68 <alltraps>

80106b1f <vector242>:
80106b1f:	6a 00                	push   $0x0
80106b21:	68 f2 00 00 00       	push   $0xf2
80106b26:	e9 3d f1 ff ff       	jmp    80105c68 <alltraps>

80106b2b <vector243>:
80106b2b:	6a 00                	push   $0x0
80106b2d:	68 f3 00 00 00       	push   $0xf3
80106b32:	e9 31 f1 ff ff       	jmp    80105c68 <alltraps>

80106b37 <vector244>:
80106b37:	6a 00                	push   $0x0
80106b39:	68 f4 00 00 00       	push   $0xf4
80106b3e:	e9 25 f1 ff ff       	jmp    80105c68 <alltraps>

80106b43 <vector245>:
80106b43:	6a 00                	push   $0x0
80106b45:	68 f5 00 00 00       	push   $0xf5
80106b4a:	e9 19 f1 ff ff       	jmp    80105c68 <alltraps>

80106b4f <vector246>:
80106b4f:	6a 00                	push   $0x0
80106b51:	68 f6 00 00 00       	push   $0xf6
80106b56:	e9 0d f1 ff ff       	jmp    80105c68 <alltraps>

80106b5b <vector247>:
80106b5b:	6a 00                	push   $0x0
80106b5d:	68 f7 00 00 00       	push   $0xf7
80106b62:	e9 01 f1 ff ff       	jmp    80105c68 <alltraps>

80106b67 <vector248>:
80106b67:	6a 00                	push   $0x0
80106b69:	68 f8 00 00 00       	push   $0xf8
80106b6e:	e9 f5 f0 ff ff       	jmp    80105c68 <alltraps>

80106b73 <vector249>:
80106b73:	6a 00                	push   $0x0
80106b75:	68 f9 00 00 00       	push   $0xf9
80106b7a:	e9 e9 f0 ff ff       	jmp    80105c68 <alltraps>

80106b7f <vector250>:
80106b7f:	6a 00                	push   $0x0
80106b81:	68 fa 00 00 00       	push   $0xfa
80106b86:	e9 dd f0 ff ff       	jmp    80105c68 <alltraps>

80106b8b <vector251>:
80106b8b:	6a 00                	push   $0x0
80106b8d:	68 fb 00 00 00       	push   $0xfb
80106b92:	e9 d1 f0 ff ff       	jmp    80105c68 <alltraps>

80106b97 <vector252>:
80106b97:	6a 00                	push   $0x0
80106b99:	68 fc 00 00 00       	push   $0xfc
80106b9e:	e9 c5 f0 ff ff       	jmp    80105c68 <alltraps>

80106ba3 <vector253>:
80106ba3:	6a 00                	push   $0x0
80106ba5:	68 fd 00 00 00       	push   $0xfd
80106baa:	e9 b9 f0 ff ff       	jmp    80105c68 <alltraps>

80106baf <vector254>:
80106baf:	6a 00                	push   $0x0
80106bb1:	68 fe 00 00 00       	push   $0xfe
80106bb6:	e9 ad f0 ff ff       	jmp    80105c68 <alltraps>

80106bbb <vector255>:
80106bbb:	6a 00                	push   $0x0
80106bbd:	68 ff 00 00 00       	push   $0xff
80106bc2:	e9 a1 f0 ff ff       	jmp    80105c68 <alltraps>
80106bc7:	66 90                	xchg   %ax,%ax
80106bc9:	66 90                	xchg   %ax,%ax
80106bcb:	66 90                	xchg   %ax,%ax
80106bcd:	66 90                	xchg   %ax,%ax
80106bcf:	90                   	nop

80106bd0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106bd7:	c1 ea 16             	shr    $0x16,%edx
{
80106bda:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106bdb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106bde:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106be1:	8b 1f                	mov    (%edi),%ebx
80106be3:	f6 c3 01             	test   $0x1,%bl
80106be6:	74 28                	je     80106c10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106be8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106bee:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106bf4:	89 f0                	mov    %esi,%eax
}
80106bf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106bf9:	c1 e8 0a             	shr    $0xa,%eax
80106bfc:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c01:	01 d8                	add    %ebx,%eax
}
80106c03:	5b                   	pop    %ebx
80106c04:	5e                   	pop    %esi
80106c05:	5f                   	pop    %edi
80106c06:	5d                   	pop    %ebp
80106c07:	c3                   	ret    
80106c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c0f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c10:	85 c9                	test   %ecx,%ecx
80106c12:	74 2c                	je     80106c40 <walkpgdir+0x70>
80106c14:	e8 07 bc ff ff       	call   80102820 <kalloc>
80106c19:	89 c3                	mov    %eax,%ebx
80106c1b:	85 c0                	test   %eax,%eax
80106c1d:	74 21                	je     80106c40 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c1f:	83 ec 04             	sub    $0x4,%esp
80106c22:	68 00 10 00 00       	push   $0x1000
80106c27:	6a 00                	push   $0x0
80106c29:	50                   	push   %eax
80106c2a:	e8 e1 dc ff ff       	call   80104910 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c2f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c35:	83 c4 10             	add    $0x10,%esp
80106c38:	83 c8 07             	or     $0x7,%eax
80106c3b:	89 07                	mov    %eax,(%edi)
80106c3d:	eb b5                	jmp    80106bf4 <walkpgdir+0x24>
80106c3f:	90                   	nop
}
80106c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c43:	31 c0                	xor    %eax,%eax
}
80106c45:	5b                   	pop    %ebx
80106c46:	5e                   	pop    %esi
80106c47:	5f                   	pop    %edi
80106c48:	5d                   	pop    %ebp
80106c49:	c3                   	ret    
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c50:	55                   	push   %ebp
  // if physical address is in huge range,
  if (pa >= HUGE_PAGE_START && pa <= HUGE_PAGE_END)
  {
    // huge code
    a = (char*)HUGEPGROUNDDOWN((uint)va);
    last = (char*)HUGEPGROUNDDOWN(((uint)va) + size - 1);
80106c51:	8d 4c 0a ff          	lea    -0x1(%edx,%ecx,1),%ecx
{
80106c55:	89 e5                	mov    %esp,%ebp
80106c57:	57                   	push   %edi
80106c58:	89 c7                	mov    %eax,%edi
80106c5a:	56                   	push   %esi
80106c5b:	53                   	push   %ebx
80106c5c:	83 ec 1c             	sub    $0x1c,%esp
80106c5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (pa >= HUGE_PAGE_START && pa <= HUGE_PAGE_END)
80106c62:	8d 83 00 00 00 e2    	lea    -0x1e000000(%ebx),%eax
80106c68:	3d 00 00 00 20       	cmp    $0x20000000,%eax
80106c6d:	77 41                	ja     80106cb0 <mappages+0x60>
    a = (char*)HUGEPGROUNDDOWN((uint)va);
80106c6f:	89 d0                	mov    %edx,%eax
    for(;;)
    {
      pde = &pgdir[PDX(va)];
80106c71:	c1 ea 16             	shr    $0x16,%edx
    last = (char*)HUGEPGROUNDDOWN(((uint)va) + size - 1);
80106c74:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
      pde = &pgdir[PDX(va)];
80106c7a:	8d 14 97             	lea    (%edi,%edx,4),%edx
      // mapping to a huge page
      *pde = pa | perm | PTE_P | PTE_PS;
80106c7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
    a = (char*)HUGEPGROUNDDOWN((uint)va);
80106c80:	25 00 00 c0 ff       	and    $0xffc00000,%eax
      *pde = pa | perm | PTE_P | PTE_PS;
80106c85:	09 df                	or     %ebx,%edi
80106c87:	81 cf 81 00 00 00    	or     $0x81,%edi
80106c8d:	89 3a                	mov    %edi,(%edx)
      if(a == last)
80106c8f:	39 c8                	cmp    %ecx,%eax
80106c91:	74 0c                	je     80106c9f <mappages+0x4f>
        break;
      a += HUGE_PAGE_SIZE;
      pa += HUGE_PAGE_SIZE;
80106c93:	29 c1                	sub    %eax,%ecx
80106c95:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
      *pde = pa | perm | PTE_P | PTE_PS;
80106c98:	0b 45 0c             	or     0xc(%ebp),%eax
80106c9b:	0c 81                	or     $0x81,%al
80106c9d:	89 02                	mov    %eax,(%edx)
      a += PGSIZE;
      pa += PGSIZE;
    }
  }
  return 0;
}
80106c9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ca2:	31 c0                	xor    %eax,%eax
}
80106ca4:	5b                   	pop    %ebx
80106ca5:	5e                   	pop    %esi
80106ca6:	5f                   	pop    %edi
80106ca7:	5d                   	pop    %ebp
80106ca8:	c3                   	ret    
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    a = (char*)PGROUNDDOWN((uint)va);
80106cb0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cb6:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106cbc:	29 d3                	sub    %edx,%ebx
80106cbe:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    a = (char*)PGROUNDDOWN((uint)va);
80106cc1:	89 d6                	mov    %edx,%esi
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cc3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106cc6:	eb 20                	jmp    80106ce8 <mappages+0x98>
80106cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ccf:	90                   	nop
      if(*pte & PTE_P)
80106cd0:	f6 00 01             	testb  $0x1,(%eax)
80106cd3:	75 38                	jne    80106d0d <mappages+0xbd>
      *pte = pa | perm | PTE_P;
80106cd5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106cd8:	83 cb 01             	or     $0x1,%ebx
80106cdb:	89 18                	mov    %ebx,(%eax)
      if(a == last)
80106cdd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106ce0:	74 bd                	je     80106c9f <mappages+0x4f>
      a += PGSIZE;
80106ce2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    for(;;){
80106ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ceb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106cf0:	89 f2                	mov    %esi,%edx
80106cf2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106cf5:	89 f8                	mov    %edi,%eax
80106cf7:	e8 d4 fe ff ff       	call   80106bd0 <walkpgdir>
80106cfc:	85 c0                	test   %eax,%eax
80106cfe:	75 d0                	jne    80106cd0 <mappages+0x80>
}
80106d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80106d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d08:	5b                   	pop    %ebx
80106d09:	5e                   	pop    %esi
80106d0a:	5f                   	pop    %edi
80106d0b:	5d                   	pop    %ebp
80106d0c:	c3                   	ret    
        panic("remap");
80106d0d:	83 ec 0c             	sub    $0xc,%esp
80106d10:	68 0c 81 10 80       	push   $0x8010810c
80106d15:	e8 66 96 ff ff       	call   80100380 <panic>
80106d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106d2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d32:	83 ec 1c             	sub    $0x1c,%esp
80106d35:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d38:	39 d3                	cmp    %edx,%ebx
80106d3a:	73 49                	jae    80106d85 <deallocuvm.part.0+0x65>
80106d3c:	89 c7                	mov    %eax,%edi
80106d3e:	eb 0c                	jmp    80106d4c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d40:	83 c0 01             	add    $0x1,%eax
80106d43:	c1 e0 16             	shl    $0x16,%eax
80106d46:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d48:	39 da                	cmp    %ebx,%edx
80106d4a:	76 39                	jbe    80106d85 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106d4c:	89 d8                	mov    %ebx,%eax
80106d4e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106d51:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106d54:	f6 c1 01             	test   $0x1,%cl
80106d57:	74 e7                	je     80106d40 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106d59:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d5b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d61:	c1 ee 0a             	shr    $0xa,%esi
80106d64:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106d6a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106d71:	85 f6                	test   %esi,%esi
80106d73:	74 cb                	je     80106d40 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106d75:	8b 06                	mov    (%esi),%eax
80106d77:	a8 01                	test   $0x1,%al
80106d79:	75 15                	jne    80106d90 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106d7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d81:	39 da                	cmp    %ebx,%edx
80106d83:	77 c7                	ja     80106d4c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d8b:	5b                   	pop    %ebx
80106d8c:	5e                   	pop    %esi
80106d8d:	5f                   	pop    %edi
80106d8e:	5d                   	pop    %ebp
80106d8f:	c3                   	ret    
      if(pa == 0)
80106d90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d95:	74 25                	je     80106dbc <deallocuvm.part.0+0x9c>
      kfree(v);
80106d97:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d9a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106da2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106da8:	50                   	push   %eax
80106da9:	e8 22 b7 ff ff       	call   801024d0 <kfree>
      *pte = 0;
80106dae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106db4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106db7:	83 c4 10             	add    $0x10,%esp
80106dba:	eb 8c                	jmp    80106d48 <deallocuvm.part.0+0x28>
        panic("kfree");
80106dbc:	83 ec 0c             	sub    $0xc,%esp
80106dbf:	68 a6 7a 10 80       	push   $0x80107aa6
80106dc4:	e8 b7 95 ff ff       	call   80100380 <panic>
80106dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dd0 <deallochugeuvm.part.0>:

// TODO: implement this
// part 2
// I havent touched this, only copy paste
int
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	89 d7                	mov    %edx,%edi
80106dd6:	56                   	push   %esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = HUGEPGROUNDUP(newsz);
80106dd7:	8d b1 ff ff 3f 00    	lea    0x3fffff(%ecx),%esi
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ddd:	53                   	push   %ebx
  a = HUGEPGROUNDUP(newsz);
80106dde:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106de4:	83 ec 1c             	sub    $0x1c,%esp
80106de7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106dea:	39 d6                	cmp    %edx,%esi
80106dec:	72 0e                	jb     80106dfc <deallochugeuvm.part.0+0x2c>
80106dee:	eb 3c                	jmp    80106e2c <deallochugeuvm.part.0+0x5c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
80106df0:	83 c1 01             	add    $0x1,%ecx
80106df3:	89 ce                	mov    %ecx,%esi
80106df5:	c1 e6 16             	shl    $0x16,%esi
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106df8:	39 f7                	cmp    %esi,%edi
80106dfa:	76 30                	jbe    80106e2c <deallochugeuvm.part.0+0x5c>
  pde = &pgdir[PDX(va)];
80106dfc:	89 f1                	mov    %esi,%ecx
80106dfe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106e01:	8b 1c 88             	mov    (%eax,%ecx,4),%ebx
80106e04:	f6 c3 01             	test   $0x1,%bl
80106e07:	74 e7                	je     80106df0 <deallochugeuvm.part.0+0x20>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e09:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(!pte)
80106e0f:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80106e15:	74 d9                	je     80106df0 <deallochugeuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106e17:	8b 8b 00 00 00 80    	mov    -0x80000000(%ebx),%ecx
80106e1d:	f6 c1 01             	test   $0x1,%cl
80106e20:	75 1e                	jne    80106e40 <deallochugeuvm.part.0+0x70>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106e22:	81 c6 00 00 40 00    	add    $0x400000,%esi
80106e28:	39 f7                	cmp    %esi,%edi
80106e2a:	77 d0                	ja     80106dfc <deallochugeuvm.part.0+0x2c>
      khugefree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e32:	5b                   	pop    %ebx
80106e33:	5e                   	pop    %esi
80106e34:	5f                   	pop    %edi
80106e35:	5d                   	pop    %ebp
80106e36:	c3                   	ret    
80106e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3e:	66 90                	xchg   %ax,%ax
      if(pa == 0)
80106e40:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106e46:	74 2a                	je     80106e72 <deallochugeuvm.part.0+0xa2>
      khugefree(v);
80106e48:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106e4b:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80106e51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106e54:	81 c6 00 00 40 00    	add    $0x400000,%esi
      khugefree(v);
80106e5a:	51                   	push   %ecx
80106e5b:	e8 30 b8 ff ff       	call   80102690 <khugefree>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106e60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e63:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106e66:	c7 83 00 00 00 80 00 	movl   $0x0,-0x80000000(%ebx)
80106e6d:	00 00 00 
80106e70:	eb 86                	jmp    80106df8 <deallochugeuvm.part.0+0x28>
        panic("khugefree");
80106e72:	83 ec 0c             	sub    $0xc,%esp
80106e75:	68 b1 7a 10 80       	push   $0x80107ab1
80106e7a:	e8 01 95 ff ff       	call   80100380 <panic>
80106e7f:	90                   	nop

80106e80 <seginit>:
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e86:	e8 e5 cc ff ff       	call   80103b70 <cpuid>
  pd[0] = size-1;
80106e8b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e90:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e96:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e9a:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80106ea1:	ff 00 00 
80106ea4:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
80106eab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eae:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80106eb5:	ff 00 00 
80106eb8:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
80106ebf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ec2:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
80106ec9:	ff 00 00 
80106ecc:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
80106ed3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ed6:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
80106edd:	ff 00 00 
80106ee0:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
80106ee7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eea:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
80106eef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ef3:	c1 e8 10             	shr    $0x10,%eax
80106ef6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106efa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106efd:	0f 01 10             	lgdtl  (%eax)
}
80106f00:	c9                   	leave  
80106f01:	c3                   	ret    
80106f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f10:	a1 e4 55 11 80       	mov    0x801155e4,%eax
80106f15:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f1a:	0f 22 d8             	mov    %eax,%cr3
}
80106f1d:	c3                   	ret    
80106f1e:	66 90                	xchg   %ax,%ax

80106f20 <switchuvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f2c:	85 f6                	test   %esi,%esi
80106f2e:	0f 84 cb 00 00 00    	je     80106fff <switchuvm+0xdf>
  if(p->kstack == 0)
80106f34:	8b 46 0c             	mov    0xc(%esi),%eax
80106f37:	85 c0                	test   %eax,%eax
80106f39:	0f 84 da 00 00 00    	je     80107019 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f3f:	8b 46 08             	mov    0x8(%esi),%eax
80106f42:	85 c0                	test   %eax,%eax
80106f44:	0f 84 c2 00 00 00    	je     8010700c <switchuvm+0xec>
  pushcli();
80106f4a:	e8 b1 d7 ff ff       	call   80104700 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f4f:	e8 bc cb ff ff       	call   80103b10 <mycpu>
80106f54:	89 c3                	mov    %eax,%ebx
80106f56:	e8 b5 cb ff ff       	call   80103b10 <mycpu>
80106f5b:	89 c7                	mov    %eax,%edi
80106f5d:	e8 ae cb ff ff       	call   80103b10 <mycpu>
80106f62:	83 c7 08             	add    $0x8,%edi
80106f65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f68:	e8 a3 cb ff ff       	call   80103b10 <mycpu>
80106f6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f70:	ba 67 00 00 00       	mov    $0x67,%edx
80106f75:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f7c:	83 c0 08             	add    $0x8,%eax
80106f7f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f86:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f8b:	83 c1 08             	add    $0x8,%ecx
80106f8e:	c1 e8 18             	shr    $0x18,%eax
80106f91:	c1 e9 10             	shr    $0x10,%ecx
80106f94:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f9a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106fa0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106fa5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fac:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106fb1:	e8 5a cb ff ff       	call   80103b10 <mycpu>
80106fb6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fbd:	e8 4e cb ff ff       	call   80103b10 <mycpu>
80106fc2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fc6:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106fc9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fcf:	e8 3c cb ff ff       	call   80103b10 <mycpu>
80106fd4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fd7:	e8 34 cb ff ff       	call   80103b10 <mycpu>
80106fdc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fe0:	b8 28 00 00 00       	mov    $0x28,%eax
80106fe5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fe8:	8b 46 08             	mov    0x8(%esi),%eax
80106feb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ff0:	0f 22 d8             	mov    %eax,%cr3
}
80106ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ff6:	5b                   	pop    %ebx
80106ff7:	5e                   	pop    %esi
80106ff8:	5f                   	pop    %edi
80106ff9:	5d                   	pop    %ebp
  popcli();
80106ffa:	e9 51 d7 ff ff       	jmp    80104750 <popcli>
    panic("switchuvm: no process");
80106fff:	83 ec 0c             	sub    $0xc,%esp
80107002:	68 12 81 10 80       	push   $0x80108112
80107007:	e8 74 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010700c:	83 ec 0c             	sub    $0xc,%esp
8010700f:	68 3d 81 10 80       	push   $0x8010813d
80107014:	e8 67 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107019:	83 ec 0c             	sub    $0xc,%esp
8010701c:	68 28 81 10 80       	push   $0x80108128
80107021:	e8 5a 93 ff ff       	call   80100380 <panic>
80107026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702d:	8d 76 00             	lea    0x0(%esi),%esi

80107030 <inituvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
80107039:	8b 45 0c             	mov    0xc(%ebp),%eax
8010703c:	8b 75 08             	mov    0x8(%ebp),%esi
8010703f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107042:	8b 45 10             	mov    0x10(%ebp),%eax
80107045:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(sz >= PGSIZE)
80107048:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010704d:	77 7d                	ja     801070cc <inituvm+0x9c>
  mem = kalloc();
8010704f:	e8 cc b7 ff ff       	call   80102820 <kalloc>
  memset(mem, 0, PGSIZE);
80107054:	83 ec 04             	sub    $0x4,%esp
80107057:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010705c:	89 c7                	mov    %eax,%edi
  memset(mem, 0, PGSIZE);
8010705e:	6a 00                	push   $0x0
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107060:	8d 9f 00 00 00 80    	lea    -0x80000000(%edi),%ebx
  memset(mem, 0, PGSIZE);
80107066:	50                   	push   %eax
80107067:	e8 a4 d8 ff ff       	call   80104910 <memset>
  if (pa >= HUGE_PAGE_START && pa <= HUGE_PAGE_END)
8010706c:	8d 87 00 00 00 62    	lea    0x62000000(%edi),%eax
80107072:	83 c4 10             	add    $0x10,%esp
80107075:	3d 00 00 00 20       	cmp    $0x20000000,%eax
8010707a:	76 3c                	jbe    801070b8 <inituvm+0x88>
      if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010707c:	31 d2                	xor    %edx,%edx
8010707e:	b9 01 00 00 00       	mov    $0x1,%ecx
80107083:	89 f0                	mov    %esi,%eax
80107085:	e8 46 fb ff ff       	call   80106bd0 <walkpgdir>
8010708a:	85 c0                	test   %eax,%eax
8010708c:	74 0a                	je     80107098 <inituvm+0x68>
      if(*pte & PTE_P)
8010708e:	f6 00 01             	testb  $0x1,(%eax)
80107091:	75 2c                	jne    801070bf <inituvm+0x8f>
      *pte = pa | perm | PTE_P;
80107093:	83 cb 07             	or     $0x7,%ebx
80107096:	89 18                	mov    %ebx,(%eax)
  memmove(mem, init, sz);
80107098:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010709b:	89 7d 08             	mov    %edi,0x8(%ebp)
8010709e:	89 45 10             	mov    %eax,0x10(%ebp)
801070a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070a4:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801070a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070aa:	5b                   	pop    %ebx
801070ab:	5e                   	pop    %esi
801070ac:	5f                   	pop    %edi
801070ad:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070ae:	e9 fd d8 ff ff       	jmp    801049b0 <memmove>
801070b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070b7:	90                   	nop
      *pde = pa | perm | PTE_P | PTE_PS;
801070b8:	80 cb 87             	or     $0x87,%bl
801070bb:	89 1e                	mov    %ebx,(%esi)
      if(a == last)
801070bd:	eb d9                	jmp    80107098 <inituvm+0x68>
        panic("remap");
801070bf:	83 ec 0c             	sub    $0xc,%esp
801070c2:	68 0c 81 10 80       	push   $0x8010810c
801070c7:	e8 b4 92 ff ff       	call   80100380 <panic>
    panic("inituvm: more than a page");
801070cc:	83 ec 0c             	sub    $0xc,%esp
801070cf:	68 51 81 10 80       	push   $0x80108151
801070d4:	e8 a7 92 ff ff       	call   80100380 <panic>
801070d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070e0 <loaduvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070ec:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801070ef:	a9 ff 0f 00 00       	test   $0xfff,%eax
801070f4:	0f 85 bb 00 00 00    	jne    801071b5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801070fa:	01 f0                	add    %esi,%eax
801070fc:	89 f3                	mov    %esi,%ebx
801070fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107101:	8b 45 14             	mov    0x14(%ebp),%eax
80107104:	01 f0                	add    %esi,%eax
80107106:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107109:	85 f6                	test   %esi,%esi
8010710b:	0f 84 87 00 00 00    	je     80107198 <loaduvm+0xb8>
80107111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010711b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010711e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107120:	89 c2                	mov    %eax,%edx
80107122:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107125:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107128:	f6 c2 01             	test   $0x1,%dl
8010712b:	75 13                	jne    80107140 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010712d:	83 ec 0c             	sub    $0xc,%esp
80107130:	68 6b 81 10 80       	push   $0x8010816b
80107135:	e8 46 92 ff ff       	call   80100380 <panic>
8010713a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107140:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107143:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107149:	25 fc 0f 00 00       	and    $0xffc,%eax
8010714e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107155:	85 c0                	test   %eax,%eax
80107157:	74 d4                	je     8010712d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107159:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010715b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010715e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107163:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107168:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010716e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107171:	29 d9                	sub    %ebx,%ecx
80107173:	05 00 00 00 80       	add    $0x80000000,%eax
80107178:	57                   	push   %edi
80107179:	51                   	push   %ecx
8010717a:	50                   	push   %eax
8010717b:	ff 75 10             	push   0x10(%ebp)
8010717e:	e8 1d a9 ff ff       	call   80101aa0 <readi>
80107183:	83 c4 10             	add    $0x10,%esp
80107186:	39 f8                	cmp    %edi,%eax
80107188:	75 1e                	jne    801071a8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010718a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107190:	89 f0                	mov    %esi,%eax
80107192:	29 d8                	sub    %ebx,%eax
80107194:	39 c6                	cmp    %eax,%esi
80107196:	77 80                	ja     80107118 <loaduvm+0x38>
}
80107198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010719b:	31 c0                	xor    %eax,%eax
}
8010719d:	5b                   	pop    %ebx
8010719e:	5e                   	pop    %esi
8010719f:	5f                   	pop    %edi
801071a0:	5d                   	pop    %ebp
801071a1:	c3                   	ret    
801071a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071b0:	5b                   	pop    %ebx
801071b1:	5e                   	pop    %esi
801071b2:	5f                   	pop    %edi
801071b3:	5d                   	pop    %ebp
801071b4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801071b5:	83 ec 0c             	sub    $0xc,%esp
801071b8:	68 28 82 10 80       	push   $0x80108228
801071bd:	e8 be 91 ff ff       	call   80100380 <panic>
801071c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071d0 <allocuvm>:
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	57                   	push   %edi
801071d4:	56                   	push   %esi
801071d5:	53                   	push   %ebx
801071d6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071d9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801071dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071e2:	85 c0                	test   %eax,%eax
801071e4:	0f 88 b6 00 00 00    	js     801072a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801071ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801071ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801071f0:	0f 82 9a 00 00 00    	jb     80107290 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801071f6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801071fc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107202:	39 75 10             	cmp    %esi,0x10(%ebp)
80107205:	77 44                	ja     8010724b <allocuvm+0x7b>
80107207:	e9 87 00 00 00       	jmp    80107293 <allocuvm+0xc3>
8010720c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107210:	83 ec 04             	sub    $0x4,%esp
80107213:	68 00 10 00 00       	push   $0x1000
80107218:	6a 00                	push   $0x0
8010721a:	50                   	push   %eax
8010721b:	e8 f0 d6 ff ff       	call   80104910 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107220:	58                   	pop    %eax
80107221:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107227:	5a                   	pop    %edx
80107228:	6a 06                	push   $0x6
8010722a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010722f:	89 f2                	mov    %esi,%edx
80107231:	50                   	push   %eax
80107232:	89 f8                	mov    %edi,%eax
80107234:	e8 17 fa ff ff       	call   80106c50 <mappages>
80107239:	83 c4 10             	add    $0x10,%esp
8010723c:	85 c0                	test   %eax,%eax
8010723e:	78 78                	js     801072b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107240:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107246:	39 75 10             	cmp    %esi,0x10(%ebp)
80107249:	76 48                	jbe    80107293 <allocuvm+0xc3>
    mem = kalloc();
8010724b:	e8 d0 b5 ff ff       	call   80102820 <kalloc>
80107250:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107252:	85 c0                	test   %eax,%eax
80107254:	75 ba                	jne    80107210 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107256:	83 ec 0c             	sub    $0xc,%esp
80107259:	68 89 81 10 80       	push   $0x80108189
8010725e:	e8 3d 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107263:	8b 45 0c             	mov    0xc(%ebp),%eax
80107266:	83 c4 10             	add    $0x10,%esp
80107269:	39 45 10             	cmp    %eax,0x10(%ebp)
8010726c:	74 32                	je     801072a0 <allocuvm+0xd0>
8010726e:	8b 55 10             	mov    0x10(%ebp),%edx
80107271:	89 c1                	mov    %eax,%ecx
80107273:	89 f8                	mov    %edi,%eax
80107275:	e8 a6 fa ff ff       	call   80106d20 <deallocuvm.part.0>
      return 0;
8010727a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107281:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107284:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107287:	5b                   	pop    %ebx
80107288:	5e                   	pop    %esi
80107289:	5f                   	pop    %edi
8010728a:	5d                   	pop    %ebp
8010728b:	c3                   	ret    
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107290:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107296:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107299:	5b                   	pop    %ebx
8010729a:	5e                   	pop    %esi
8010729b:	5f                   	pop    %edi
8010729c:	5d                   	pop    %ebp
8010729d:	c3                   	ret    
8010729e:	66 90                	xchg   %ax,%ax
    return 0;
801072a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ad:	5b                   	pop    %ebx
801072ae:	5e                   	pop    %esi
801072af:	5f                   	pop    %edi
801072b0:	5d                   	pop    %ebp
801072b1:	c3                   	ret    
801072b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072b8:	83 ec 0c             	sub    $0xc,%esp
801072bb:	68 a1 81 10 80       	push   $0x801081a1
801072c0:	e8 db 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072c8:	83 c4 10             	add    $0x10,%esp
801072cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801072ce:	74 0c                	je     801072dc <allocuvm+0x10c>
801072d0:	8b 55 10             	mov    0x10(%ebp),%edx
801072d3:	89 c1                	mov    %eax,%ecx
801072d5:	89 f8                	mov    %edi,%eax
801072d7:	e8 44 fa ff ff       	call   80106d20 <deallocuvm.part.0>
      kfree(mem);
801072dc:	83 ec 0c             	sub    $0xc,%esp
801072df:	53                   	push   %ebx
801072e0:	e8 eb b1 ff ff       	call   801024d0 <kfree>
      return 0;
801072e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072ec:	83 c4 10             	add    $0x10,%esp
}
801072ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f5:	5b                   	pop    %ebx
801072f6:	5e                   	pop    %esi
801072f7:	5f                   	pop    %edi
801072f8:	5d                   	pop    %ebp
801072f9:	c3                   	ret    
801072fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107300 <allochugeuvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 0c             	sub    $0xc,%esp
  if(newsz < oldsz)
80107309:	8b 45 0c             	mov    0xc(%ebp),%eax
{
8010730c:	8b 7d 08             	mov    0x8(%ebp),%edi
    return oldsz;
8010730f:	89 c3                	mov    %eax,%ebx
  if(newsz < oldsz)
80107311:	39 45 10             	cmp    %eax,0x10(%ebp)
80107314:	0f 82 8f 00 00 00    	jb     801073a9 <allochugeuvm+0xa9>
  a = HUGEPGROUNDUP(oldsz);
8010731a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010731d:	8d b0 ff ff 3f 00    	lea    0x3fffff(%eax),%esi
80107323:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
  for(; a < newsz; a += HUGE_PAGE_SIZE){
80107329:	39 75 10             	cmp    %esi,0x10(%ebp)
8010732c:	77 4c                	ja     8010737a <allochugeuvm+0x7a>
8010732e:	e9 85 00 00 00       	jmp    801073b8 <allochugeuvm+0xb8>
80107333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107337:	90                   	nop
    memset(mem, 0, HUGE_PAGE_SIZE);
80107338:	83 ec 04             	sub    $0x4,%esp
8010733b:	68 00 00 40 00       	push   $0x400000
80107340:	6a 00                	push   $0x0
80107342:	50                   	push   %eax
80107343:	e8 c8 d5 ff ff       	call   80104910 <memset>
    if(mappages(pgdir, (char*)a + HUGE_VA_OFFSET, HUGE_PAGE_SIZE, V2P(mem), PTE_PS|PTE_W|PTE_U) < 0){
80107348:	58                   	pop    %eax
80107349:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010734f:	59                   	pop    %ecx
80107350:	68 86 00 00 00       	push   $0x86
80107355:	8d 96 00 00 00 1e    	lea    0x1e000000(%esi),%edx
8010735b:	b9 00 00 40 00       	mov    $0x400000,%ecx
80107360:	50                   	push   %eax
80107361:	89 f8                	mov    %edi,%eax
80107363:	e8 e8 f8 ff ff       	call   80106c50 <mappages>
80107368:	83 c4 10             	add    $0x10,%esp
8010736b:	85 c0                	test   %eax,%eax
8010736d:	78 59                	js     801073c8 <allochugeuvm+0xc8>
  for(; a < newsz; a += HUGE_PAGE_SIZE){
8010736f:	81 c6 00 00 40 00    	add    $0x400000,%esi
80107375:	39 75 10             	cmp    %esi,0x10(%ebp)
80107378:	76 3e                	jbe    801073b8 <allochugeuvm+0xb8>
    mem = khugealloc();
8010737a:	e8 11 b5 ff ff       	call   80102890 <khugealloc>
8010737f:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107381:	85 c0                	test   %eax,%eax
80107383:	75 b3                	jne    80107338 <allochugeuvm+0x38>
      cprintf("allochugeuvm out of memory\n");
80107385:	83 ec 0c             	sub    $0xc,%esp
80107388:	68 bd 81 10 80       	push   $0x801081bd
8010738d:	e8 0e 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107392:	8b 45 0c             	mov    0xc(%ebp),%eax
80107395:	83 c4 10             	add    $0x10,%esp
80107398:	39 45 10             	cmp    %eax,0x10(%ebp)
8010739b:	74 0c                	je     801073a9 <allochugeuvm+0xa9>
8010739d:	8b 55 10             	mov    0x10(%ebp),%edx
801073a0:	89 c1                	mov    %eax,%ecx
801073a2:	89 f8                	mov    %edi,%eax
801073a4:	e8 27 fa ff ff       	call   80106dd0 <deallochugeuvm.part.0>
}
801073a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ac:	89 d8                	mov    %ebx,%eax
801073ae:	5b                   	pop    %ebx
801073af:	5e                   	pop    %esi
801073b0:	5f                   	pop    %edi
801073b1:	5d                   	pop    %ebp
801073b2:	c3                   	ret    
801073b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073b7:	90                   	nop
  return newsz;
801073b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
}
801073bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073be:	89 d8                	mov    %ebx,%eax
801073c0:	5b                   	pop    %ebx
801073c1:	5e                   	pop    %esi
801073c2:	5f                   	pop    %edi
801073c3:	5d                   	pop    %ebp
801073c4:	c3                   	ret    
801073c5:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allochugeuvm out of memory (2)\n");
801073c8:	83 ec 0c             	sub    $0xc,%esp
801073cb:	68 4c 82 10 80       	push   $0x8010824c
801073d0:	e8 cb 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801073d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801073d8:	83 c4 10             	add    $0x10,%esp
801073db:	39 45 10             	cmp    %eax,0x10(%ebp)
801073de:	74 0c                	je     801073ec <allochugeuvm+0xec>
801073e0:	8b 55 10             	mov    0x10(%ebp),%edx
801073e3:	89 c1                	mov    %eax,%ecx
801073e5:	89 f8                	mov    %edi,%eax
801073e7:	e8 e4 f9 ff ff       	call   80106dd0 <deallochugeuvm.part.0>
      kfree(mem);
801073ec:	83 ec 0c             	sub    $0xc,%esp
801073ef:	53                   	push   %ebx
      return 0;
801073f0:	31 db                	xor    %ebx,%ebx
      kfree(mem);
801073f2:	e8 d9 b0 ff ff       	call   801024d0 <kfree>
      return 0;
801073f7:	83 c4 10             	add    $0x10,%esp
}
801073fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073fd:	89 d8                	mov    %ebx,%eax
801073ff:	5b                   	pop    %ebx
80107400:	5e                   	pop    %esi
80107401:	5f                   	pop    %edi
80107402:	5d                   	pop    %ebp
80107403:	c3                   	ret    
80107404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010740f:	90                   	nop

80107410 <deallocuvm>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	8b 55 0c             	mov    0xc(%ebp),%edx
80107416:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107419:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010741c:	39 d1                	cmp    %edx,%ecx
8010741e:	73 10                	jae    80107430 <deallocuvm+0x20>
}
80107420:	5d                   	pop    %ebp
80107421:	e9 fa f8 ff ff       	jmp    80106d20 <deallocuvm.part.0>
80107426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010742d:	8d 76 00             	lea    0x0(%esi),%esi
80107430:	89 d0                	mov    %edx,%eax
80107432:	5d                   	pop    %ebp
80107433:	c3                   	ret    
80107434:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010743f:	90                   	nop

80107440 <deallochugeuvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	8b 55 0c             	mov    0xc(%ebp),%edx
80107446:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107449:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010744c:	39 d1                	cmp    %edx,%ecx
8010744e:	73 10                	jae    80107460 <deallochugeuvm+0x20>
}
80107450:	5d                   	pop    %ebp
80107451:	e9 7a f9 ff ff       	jmp    80106dd0 <deallochugeuvm.part.0>
80107456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745d:	8d 76 00             	lea    0x0(%esi),%esi
80107460:	89 d0                	mov    %edx,%eax
80107462:	5d                   	pop    %ebp
80107463:	c3                   	ret    
80107464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop

80107470 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	57                   	push   %edi
80107474:	56                   	push   %esi
80107475:	53                   	push   %ebx
80107476:	83 ec 0c             	sub    $0xc,%esp
80107479:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010747c:	85 f6                	test   %esi,%esi
8010747e:	74 59                	je     801074d9 <freevm+0x69>
  if(newsz >= oldsz)
80107480:	31 c9                	xor    %ecx,%ecx
80107482:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107487:	89 f0                	mov    %esi,%eax
80107489:	89 f3                	mov    %esi,%ebx
8010748b:	e8 90 f8 ff ff       	call   80106d20 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107490:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107496:	eb 0f                	jmp    801074a7 <freevm+0x37>
80107498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749f:	90                   	nop
801074a0:	83 c3 04             	add    $0x4,%ebx
801074a3:	39 df                	cmp    %ebx,%edi
801074a5:	74 23                	je     801074ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074a7:	8b 03                	mov    (%ebx),%eax
801074a9:	a8 01                	test   $0x1,%al
801074ab:	74 f3                	je     801074a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801074b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801074bd:	50                   	push   %eax
801074be:	e8 0d b0 ff ff       	call   801024d0 <kfree>
801074c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074c6:	39 df                	cmp    %ebx,%edi
801074c8:	75 dd                	jne    801074a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801074ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d0:	5b                   	pop    %ebx
801074d1:	5e                   	pop    %esi
801074d2:	5f                   	pop    %edi
801074d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801074d4:	e9 f7 af ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
801074d9:	83 ec 0c             	sub    $0xc,%esp
801074dc:	68 d9 81 10 80       	push   $0x801081d9
801074e1:	e8 9a 8e ff ff       	call   80100380 <panic>
801074e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ed:	8d 76 00             	lea    0x0(%esi),%esi

801074f0 <setupkvm>:
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	56                   	push   %esi
801074f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801074f5:	e8 26 b3 ff ff       	call   80102820 <kalloc>
801074fa:	89 c6                	mov    %eax,%esi
801074fc:	85 c0                	test   %eax,%eax
801074fe:	74 42                	je     80107542 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107500:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107503:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107508:	68 00 10 00 00       	push   $0x1000
8010750d:	6a 00                	push   $0x0
8010750f:	50                   	push   %eax
80107510:	e8 fb d3 ff ff       	call   80104910 <memset>
80107515:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107518:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010751b:	83 ec 08             	sub    $0x8,%esp
8010751e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107521:	ff 73 0c             	push   0xc(%ebx)
80107524:	8b 13                	mov    (%ebx),%edx
80107526:	50                   	push   %eax
80107527:	29 c1                	sub    %eax,%ecx
80107529:	89 f0                	mov    %esi,%eax
8010752b:	e8 20 f7 ff ff       	call   80106c50 <mappages>
80107530:	83 c4 10             	add    $0x10,%esp
80107533:	85 c0                	test   %eax,%eax
80107535:	78 19                	js     80107550 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107537:	83 c3 10             	add    $0x10,%ebx
8010753a:	81 fb 70 b4 10 80    	cmp    $0x8010b470,%ebx
80107540:	75 d6                	jne    80107518 <setupkvm+0x28>
}
80107542:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107545:	89 f0                	mov    %esi,%eax
80107547:	5b                   	pop    %ebx
80107548:	5e                   	pop    %esi
80107549:	5d                   	pop    %ebp
8010754a:	c3                   	ret    
8010754b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010754f:	90                   	nop
      freevm(pgdir);
80107550:	83 ec 0c             	sub    $0xc,%esp
80107553:	56                   	push   %esi
      return 0;
80107554:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107556:	e8 15 ff ff ff       	call   80107470 <freevm>
      return 0;
8010755b:	83 c4 10             	add    $0x10,%esp
}
8010755e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107561:	89 f0                	mov    %esi,%eax
80107563:	5b                   	pop    %ebx
80107564:	5e                   	pop    %esi
80107565:	5d                   	pop    %ebp
80107566:	c3                   	ret    
80107567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756e:	66 90                	xchg   %ax,%ax

80107570 <kvmalloc>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107576:	e8 75 ff ff ff       	call   801074f0 <setupkvm>
8010757b:	a3 e4 55 11 80       	mov    %eax,0x801155e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107580:	05 00 00 00 80       	add    $0x80000000,%eax
80107585:	0f 22 d8             	mov    %eax,%cr3
}
80107588:	c9                   	leave  
80107589:	c3                   	ret    
8010758a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107590 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	83 ec 08             	sub    $0x8,%esp
80107596:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107599:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010759c:	89 c1                	mov    %eax,%ecx
8010759e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075a4:	f6 c2 01             	test   $0x1,%dl
801075a7:	75 17                	jne    801075c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801075a9:	83 ec 0c             	sub    $0xc,%esp
801075ac:	68 ea 81 10 80       	push   $0x801081ea
801075b1:	e8 ca 8d ff ff       	call   80100380 <panic>
801075b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801075c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801075c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801075ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801075d5:	85 c0                	test   %eax,%eax
801075d7:	74 d0                	je     801075a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801075d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075dc:	c9                   	leave  
801075dd:	c3                   	ret    
801075de:	66 90                	xchg   %ax,%ax

801075e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	57                   	push   %edi
801075e4:	56                   	push   %esi
801075e5:	53                   	push   %ebx
801075e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801075e9:	e8 02 ff ff ff       	call   801074f0 <setupkvm>
801075ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075f1:	85 c0                	test   %eax,%eax
801075f3:	0f 84 bd 00 00 00    	je     801076b6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801075f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075fc:	85 c9                	test   %ecx,%ecx
801075fe:	0f 84 b2 00 00 00    	je     801076b6 <copyuvm+0xd6>
80107604:	31 f6                	xor    %esi,%esi
80107606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107610:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107613:	89 f0                	mov    %esi,%eax
80107615:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107618:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010761b:	a8 01                	test   $0x1,%al
8010761d:	75 11                	jne    80107630 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010761f:	83 ec 0c             	sub    $0xc,%esp
80107622:	68 f4 81 10 80       	push   $0x801081f4
80107627:	e8 54 8d ff ff       	call   80100380 <panic>
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107630:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107632:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107637:	c1 ea 0a             	shr    $0xa,%edx
8010763a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107640:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107647:	85 c0                	test   %eax,%eax
80107649:	74 d4                	je     8010761f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010764b:	8b 00                	mov    (%eax),%eax
8010764d:	a8 01                	test   $0x1,%al
8010764f:	0f 84 9f 00 00 00    	je     801076f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107655:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107657:	25 ff 0f 00 00       	and    $0xfff,%eax
8010765c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010765f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107665:	e8 b6 b1 ff ff       	call   80102820 <kalloc>
8010766a:	89 c3                	mov    %eax,%ebx
8010766c:	85 c0                	test   %eax,%eax
8010766e:	74 64                	je     801076d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107670:	83 ec 04             	sub    $0x4,%esp
80107673:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107679:	68 00 10 00 00       	push   $0x1000
8010767e:	57                   	push   %edi
8010767f:	50                   	push   %eax
80107680:	e8 2b d3 ff ff       	call   801049b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107685:	58                   	pop    %eax
80107686:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010768c:	5a                   	pop    %edx
8010768d:	ff 75 e4             	push   -0x1c(%ebp)
80107690:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107695:	89 f2                	mov    %esi,%edx
80107697:	50                   	push   %eax
80107698:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010769b:	e8 b0 f5 ff ff       	call   80106c50 <mappages>
801076a0:	83 c4 10             	add    $0x10,%esp
801076a3:	85 c0                	test   %eax,%eax
801076a5:	78 21                	js     801076c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801076a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801076b0:	0f 87 5a ff ff ff    	ja     80107610 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801076b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076bc:	5b                   	pop    %ebx
801076bd:	5e                   	pop    %esi
801076be:	5f                   	pop    %edi
801076bf:	5d                   	pop    %ebp
801076c0:	c3                   	ret    
801076c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801076c8:	83 ec 0c             	sub    $0xc,%esp
801076cb:	53                   	push   %ebx
801076cc:	e8 ff ad ff ff       	call   801024d0 <kfree>
      goto bad;
801076d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801076d4:	83 ec 0c             	sub    $0xc,%esp
801076d7:	ff 75 e0             	push   -0x20(%ebp)
801076da:	e8 91 fd ff ff       	call   80107470 <freevm>
  return 0;
801076df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801076e6:	83 c4 10             	add    $0x10,%esp
}
801076e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076ef:	5b                   	pop    %ebx
801076f0:	5e                   	pop    %esi
801076f1:	5f                   	pop    %edi
801076f2:	5d                   	pop    %ebp
801076f3:	c3                   	ret    
      panic("copyuvm: page not present");
801076f4:	83 ec 0c             	sub    $0xc,%esp
801076f7:	68 0e 82 10 80       	push   $0x8010820e
801076fc:	e8 7f 8c ff ff       	call   80100380 <panic>
80107701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107716:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107719:	89 c1                	mov    %eax,%ecx
8010771b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010771e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107721:	f6 c2 01             	test   $0x1,%dl
80107724:	0f 84 00 01 00 00    	je     8010782a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010772a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010772d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107733:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107734:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107739:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107740:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107742:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107747:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010774a:	05 00 00 00 80       	add    $0x80000000,%eax
8010774f:	83 fa 05             	cmp    $0x5,%edx
80107752:	ba 00 00 00 00       	mov    $0x0,%edx
80107757:	0f 45 c2             	cmovne %edx,%eax
}
8010775a:	c3                   	ret    
8010775b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010775f:	90                   	nop

80107760 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	57                   	push   %edi
80107764:	56                   	push   %esi
80107765:	53                   	push   %ebx
80107766:	83 ec 0c             	sub    $0xc,%esp
80107769:	8b 75 14             	mov    0x14(%ebp),%esi
8010776c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010776f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107772:	85 f6                	test   %esi,%esi
80107774:	75 51                	jne    801077c7 <copyout+0x67>
80107776:	e9 a5 00 00 00       	jmp    80107820 <copyout+0xc0>
8010777b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010777f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107780:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107786:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010778c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107792:	74 75                	je     80107809 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107794:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107796:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107799:	29 c3                	sub    %eax,%ebx
8010779b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077a1:	39 f3                	cmp    %esi,%ebx
801077a3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801077a6:	29 f8                	sub    %edi,%eax
801077a8:	83 ec 04             	sub    $0x4,%esp
801077ab:	01 c1                	add    %eax,%ecx
801077ad:	53                   	push   %ebx
801077ae:	52                   	push   %edx
801077af:	51                   	push   %ecx
801077b0:	e8 fb d1 ff ff       	call   801049b0 <memmove>
    len -= n;
    buf += n;
801077b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801077b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801077be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801077c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801077c3:	29 de                	sub    %ebx,%esi
801077c5:	74 59                	je     80107820 <copyout+0xc0>
  if(*pde & PTE_P){
801077c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801077ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801077cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801077ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801077d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801077d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801077da:	f6 c1 01             	test   $0x1,%cl
801077dd:	0f 84 4e 00 00 00    	je     80107831 <copyout.cold>
  return &pgtab[PTX(va)];
801077e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801077eb:	c1 eb 0c             	shr    $0xc,%ebx
801077ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801077f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801077fb:	89 d9                	mov    %ebx,%ecx
801077fd:	83 e1 05             	and    $0x5,%ecx
80107800:	83 f9 05             	cmp    $0x5,%ecx
80107803:	0f 84 77 ff ff ff    	je     80107780 <copyout+0x20>
  }
  return 0;
}
80107809:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010780c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107811:	5b                   	pop    %ebx
80107812:	5e                   	pop    %esi
80107813:	5f                   	pop    %edi
80107814:	5d                   	pop    %ebp
80107815:	c3                   	ret    
80107816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010781d:	8d 76 00             	lea    0x0(%esi),%esi
80107820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107823:	31 c0                	xor    %eax,%eax
}
80107825:	5b                   	pop    %ebx
80107826:	5e                   	pop    %esi
80107827:	5f                   	pop    %edi
80107828:	5d                   	pop    %ebp
80107829:	c3                   	ret    

8010782a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010782a:	a1 00 00 00 00       	mov    0x0,%eax
8010782f:	0f 0b                	ud2    

80107831 <copyout.cold>:
80107831:	a1 00 00 00 00       	mov    0x0,%eax
80107836:	0f 0b                	ud2    
