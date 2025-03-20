
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
8010002d:	b8 20 32 10 80       	mov    $0x80103220,%eax
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
8010004c:	68 00 78 10 80       	push   $0x80107800
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 d5 45 00 00       	call   80104630 <initlock>
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
80100092:	68 07 78 10 80       	push   $0x80107807
80100097:	50                   	push   %eax
80100098:	e8 63 44 00 00       	call   80104500 <initsleeplock>
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
801000e4:	e8 17 47 00 00       	call   80104800 <acquire>
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
80100162:	e8 39 46 00 00       	call   801047a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 43 00 00       	call   80104540 <acquiresleep>
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
801001a1:	68 0e 78 10 80       	push   $0x8010780e
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
801001be:	e8 1d 44 00 00       	call   801045e0 <holdingsleep>
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
801001dc:	68 1f 78 10 80       	push   $0x8010781f
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
801001ff:	e8 dc 43 00 00       	call   801045e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 43 00 00       	call   801045a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 e0 45 00 00       	call   80104800 <acquire>
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
8010026c:	e9 2f 45 00 00       	jmp    801047a0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 78 10 80       	push   $0x80107826
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
801002a0:	e8 5b 45 00 00       	call   80104800 <acquire>
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
801002cd:	e8 ce 3f 00 00       	call   801042a0 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 59 38 00 00       	call   80103b40 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 a5 44 00 00       	call   801047a0 <release>
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
8010034c:	e8 4f 44 00 00       	call   801047a0 <release>
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
80100399:	e8 12 27 00 00       	call   80102ab0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 78 10 80       	push   $0x8010782d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 7b 81 10 80 	movl   $0x8010817b,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 83 42 00 00       	call   80104650 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 78 10 80       	push   $0x80107841
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
8010041a:	e8 71 5c 00 00       	call   80106090 <uartputc>
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
80100505:	e8 86 5b 00 00       	call   80106090 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 7a 5b 00 00       	call   80106090 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 6e 5b 00 00       	call   80106090 <uartputc>
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
80100551:	e8 0a 44 00 00       	call   80104960 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 55 43 00 00       	call   801048c0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 45 78 10 80       	push   $0x80107845
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
801005ab:	e8 50 42 00 00       	call   80104800 <acquire>
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
801005e4:	e8 b7 41 00 00       	call   801047a0 <release>
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
80100636:	0f b6 92 70 78 10 80 	movzbl -0x7fef8790(%edx),%edx
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
801007e8:	e8 13 40 00 00       	call   80104800 <acquire>
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
80100838:	bf 58 78 10 80       	mov    $0x80107858,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 ff 10 80       	push   $0x8010ff40
8010085b:	e8 40 3f 00 00       	call   801047a0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 5f 78 10 80       	push   $0x8010785f
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
80100893:	e8 68 3f 00 00       	call   80104800 <acquire>
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
801009d0:	e8 cb 3d 00 00       	call   801047a0 <release>
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
80100a0e:	e9 2d 3a 00 00       	jmp    80104440 <procdump>
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
80100a44:	e8 17 39 00 00       	call   80104360 <wakeup>
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
80100a66:	68 68 78 10 80       	push   $0x80107868
80100a6b:	68 40 ff 10 80       	push   $0x8010ff40
80100a70:	e8 bb 3b 00 00       	call   80104630 <initlock>

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
80100abc:	e8 7f 30 00 00       	call   80103b40 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 54 24 00 00       	call   80102f20 <begin_op>

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
80100b0f:	e8 7c 24 00 00       	call   80102f90 <end_op>
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
80100b34:	e8 67 69 00 00       	call   801074a0 <setupkvm>
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
80100ba3:	e8 d8 65 00 00       	call   80107180 <allocuvm>
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
80100bd9:	e8 b2 64 00 00       	call   80107090 <loaduvm>
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
80100c1b:	e8 00 68 00 00       	call   80107420 <freevm>
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
80100c51:	e8 3a 23 00 00       	call   80102f90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 19 65 00 00       	call   80107180 <allocuvm>
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
80100c83:	e8 b8 68 00 00       	call   80107540 <clearpteu>
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
80100cd3:	e8 e8 3d 00 00       	call   80104ac0 <strlen>
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
80100ce7:	e8 d4 3d 00 00       	call   80104ac0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 13 6a 00 00       	call   80107710 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 0a 67 00 00       	call   80107420 <freevm>
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
80100d63:	e8 a8 69 00 00       	call   80107710 <copyout>
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
80100da1:	e8 da 3c 00 00       	call   80104a80 <safestrcpy>
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
80100dd4:	e8 f7 60 00 00       	call   80106ed0 <switchuvm>
  freevm(oldpgdir);
80100dd9:	89 3c 24             	mov    %edi,(%esp)
80100ddc:	e8 3f 66 00 00       	call   80107420 <freevm>
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	31 c0                	xor    %eax,%eax
80100de6:	e9 31 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100deb:	e8 a0 21 00 00       	call   80102f90 <end_op>
    cprintf("exec: fail\n");
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	68 81 78 10 80       	push   $0x80107881
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
80100e26:	68 8d 78 10 80       	push   $0x8010788d
80100e2b:	68 80 ff 10 80       	push   $0x8010ff80
80100e30:	e8 fb 37 00 00       	call   80104630 <initlock>
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
80100e51:	e8 aa 39 00 00       	call   80104800 <acquire>
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
80100e81:	e8 1a 39 00 00       	call   801047a0 <release>
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
80100e9a:	e8 01 39 00 00       	call   801047a0 <release>
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
80100ebf:	e8 3c 39 00 00       	call   80104800 <acquire>
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
80100edc:	e8 bf 38 00 00       	call   801047a0 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 94 78 10 80       	push   $0x80107894
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
80100f11:	e8 ea 38 00 00       	call   80104800 <acquire>
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
80100f4c:	e8 4f 38 00 00       	call   801047a0 <release>

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
80100f7e:	e9 1d 38 00 00       	jmp    801047a0 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 93 1f 00 00       	call   80102f20 <begin_op>
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
80100fa2:	e9 e9 1f 00 00       	jmp    80102f90 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 42 27 00 00       	call   80103700 <pipeclose>
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
80100fcc:	68 9c 78 10 80       	push   $0x8010789c
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
8010109d:	e9 fe 27 00 00       	jmp    801038a0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 a6 78 10 80       	push   $0x801078a6
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
80101119:	e8 72 1e 00 00       	call   80102f90 <end_op>

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
8010113e:	e8 dd 1d 00 00       	call   80102f20 <begin_op>
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
80101175:	e8 16 1e 00 00       	call   80102f90 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 af 78 10 80       	push   $0x801078af
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
801011b9:	e9 e2 25 00 00       	jmp    801037a0 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 b5 78 10 80       	push   $0x801078b5
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
8010121d:	e8 de 1e 00 00       	call   80103100 <log_write>
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
80101237:	68 bf 78 10 80       	push   $0x801078bf
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
801012f4:	68 d2 78 10 80       	push   $0x801078d2
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
8010130d:	e8 ee 1d 00 00       	call   80103100 <log_write>
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
80101335:	e8 86 35 00 00       	call   801048c0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 be 1d 00 00       	call   80103100 <log_write>
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
8010137a:	e8 81 34 00 00       	call   80104800 <acquire>
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
801013e7:	e8 b4 33 00 00       	call   801047a0 <release>

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
80101415:	e8 86 33 00 00       	call   801047a0 <release>
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
80101448:	68 e8 78 10 80       	push   $0x801078e8
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
801014d5:	e8 26 1c 00 00       	call   80103100 <log_write>
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
80101525:	68 f8 78 10 80       	push   $0x801078f8
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
80101551:	e8 0a 34 00 00       	call   80104960 <memmove>
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
8010157c:	68 0b 79 10 80       	push   $0x8010790b
80101581:	68 80 09 11 80       	push   $0x80110980
80101586:	e8 a5 30 00 00       	call   80104630 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 12 79 10 80       	push   $0x80107912
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 5c 2f 00 00       	call   80104500 <initsleeplock>
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
801015cc:	e8 8f 33 00 00       	call   80104960 <memmove>
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
80101603:	68 78 79 10 80       	push   $0x80107978
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
8010169e:	e8 1d 32 00 00       	call   801048c0 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 4b 1a 00 00       	call   80103100 <log_write>
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
801016d3:	68 18 79 10 80       	push   $0x80107918
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
80101741:	e8 1a 32 00 00       	call   80104960 <memmove>
  log_write(bp);
80101746:	89 34 24             	mov    %esi,(%esp)
80101749:	e8 b2 19 00 00       	call   80103100 <log_write>
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
8010176f:	e8 8c 30 00 00       	call   80104800 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010177f:	e8 1c 30 00 00       	call   801047a0 <release>
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
801017b2:	e8 89 2d 00 00       	call   80104540 <acquiresleep>
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
80101828:	e8 33 31 00 00       	call   80104960 <memmove>
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
8010184d:	68 30 79 10 80       	push   $0x80107930
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 2a 79 10 80       	push   $0x8010792a
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
80101883:	e8 58 2d 00 00       	call   801045e0 <holdingsleep>
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
8010189f:	e9 fc 2c 00 00       	jmp    801045a0 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 3f 79 10 80       	push   $0x8010793f
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
801018d0:	e8 6b 2c 00 00       	call   80104540 <acquiresleep>
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
801018ea:	e8 b1 2c 00 00       	call   801045a0 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
801018f6:	e8 05 2f 00 00       	call   80104800 <acquire>
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
80101910:	e9 8b 2e 00 00       	jmp    801047a0 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 80 09 11 80       	push   $0x80110980
80101920:	e8 db 2e 00 00       	call   80104800 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010192f:	e8 6c 2e 00 00       	call   801047a0 <release>
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
80101a33:	e8 a8 2b 00 00       	call   801045e0 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 51 2b 00 00       	call   801045a0 <releasesleep>
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
80101a63:	68 3f 79 10 80       	push   $0x8010793f
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
80101b47:	e8 14 2e 00 00       	call   80104960 <memmove>
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
80101c43:	e8 18 2d 00 00       	call   80104960 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 b0 14 00 00       	call   80103100 <log_write>
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
80101cde:	e8 ed 2c 00 00       	call   801049d0 <strncmp>
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
80101d3d:	e8 8e 2c 00 00       	call   801049d0 <strncmp>
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
80101d82:	68 59 79 10 80       	push   $0x80107959
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 47 79 10 80       	push   $0x80107947
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
80101dba:	e8 81 1d 00 00       	call   80103b40 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 80 09 11 80       	push   $0x80110980
80101dca:	e8 31 2a 00 00       	call   80104800 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101dda:	e8 c1 29 00 00       	call   801047a0 <release>
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
80101e37:	e8 24 2b 00 00       	call   80104960 <memmove>
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
80101e9c:	e8 3f 27 00 00       	call   801045e0 <holdingsleep>
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
80101ebe:	e8 dd 26 00 00       	call   801045a0 <releasesleep>
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
80101eeb:	e8 70 2a 00 00       	call   80104960 <memmove>
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
80101f3b:	e8 a0 26 00 00       	call   801045e0 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 41 26 00 00       	call   801045a0 <releasesleep>
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
80101f7d:	e8 5e 26 00 00       	call   801045e0 <holdingsleep>
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
80101fa0:	e8 3b 26 00 00       	call   801045e0 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 e4 25 00 00       	call   801045a0 <releasesleep>
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
80101fdf:	68 3f 79 10 80       	push   $0x8010793f
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
8010204d:	e8 ce 29 00 00       	call   80104a20 <strncpy>
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
8010208b:	68 68 79 10 80       	push   $0x80107968
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 4a 7f 10 80       	push   $0x80107f4a
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
801021ab:	68 d4 79 10 80       	push   $0x801079d4
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 cb 79 10 80       	push   $0x801079cb
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 e6 79 10 80       	push   $0x801079e6
801021db:	68 20 26 11 80       	push   $0x80112620
801021e0:	e8 4b 24 00 00       	call   80104630 <initlock>
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
8010225e:	e8 9d 25 00 00       	call   80104800 <acquire>

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
801022bd:	e8 9e 20 00 00       	call   80104360 <wakeup>

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
801022db:	e8 c0 24 00 00       	call   801047a0 <release>

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
801022fe:	e8 dd 22 00 00       	call   801045e0 <holdingsleep>
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
80102338:	e8 c3 24 00 00       	call   80104800 <acquire>

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
80102379:	e8 22 1f 00 00       	call   801042a0 <sleep>
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
80102396:	e9 05 24 00 00       	jmp    801047a0 <release>
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
801023ba:	68 15 7a 10 80       	push   $0x80107a15
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 00 7a 10 80       	push   $0x80107a00
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 ea 79 10 80       	push   $0x801079ea
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
8010242a:	68 34 7a 10 80       	push   $0x80107a34
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
80102502:	e8 b9 23 00 00       	call   801048c0 <memset>

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
80102538:	e8 c3 22 00 00       	call   80104800 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 48 22 00 00       	jmp    801047a0 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 66 7a 10 80       	push   $0x80107a66
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
8010262b:	68 6c 7a 10 80       	push   $0x80107a6c
80102630:	68 60 26 11 80       	push   $0x80112660
80102635:	e8 f6 1f 00 00       	call   80104630 <initlock>
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
801026ba:	e8 01 22 00 00       	call   801048c0 <memset>

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
801026f8:	e8 03 21 00 00       	call   80104800 <acquire>
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	eb ca                	jmp    801026cc <khugefree+0x3c>
80102702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102708:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010270f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102712:	c9                   	leave  
    release(&kmem.lock);
80102713:	e9 88 20 00 00       	jmp    801047a0 <release>
    panic("khugefree");
80102718:	83 ec 0c             	sub    $0xc,%esp
8010271b:	68 71 7a 10 80       	push   $0x80107a71
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
80102781:	89 e5                	mov    %esp,%ebp
80102783:	56                   	push   %esi
  p = (char *)HUGEPGROUNDUP((uint)vstart);
80102784:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102787:	8b 75 0c             	mov    0xc(%ebp),%esi
8010278a:	53                   	push   %ebx
  p = (char *)HUGEPGROUNDUP((uint)vstart);
8010278b:	8d 98 ff ff 3f 00    	lea    0x3fffff(%eax),%ebx
80102791:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
80102797:	81 c3 00 00 40 00    	add    $0x400000,%ebx
8010279d:	39 de                	cmp    %ebx,%esi
8010279f:	72 23                	jb     801027c4 <khugeinit+0x44>
801027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    khugefree(p);
801027a8:	83 ec 0c             	sub    $0xc,%esp
801027ab:	8d 83 00 00 c0 ff    	lea    -0x400000(%ebx),%eax
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027b1:	81 c3 00 00 40 00    	add    $0x400000,%ebx
    khugefree(p);
801027b7:	50                   	push   %eax
801027b8:	e8 d3 fe ff ff       	call   80102690 <khugefree>
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027bd:	83 c4 10             	add    $0x10,%esp
801027c0:	39 de                	cmp    %ebx,%esi
801027c2:	73 e4                	jae    801027a8 <khugeinit+0x28>
}
801027c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027c7:	5b                   	pop    %ebx
801027c8:	5e                   	pop    %esi
801027c9:	5d                   	pop    %ebp
801027ca:	c3                   	ret    
801027cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027cf:	90                   	nop

801027d0 <kalloc>:
char *
kalloc(void)
{
  struct run *r;

  if (kmem.use_lock)
801027d0:	a1 94 26 11 80       	mov    0x80112694,%eax
801027d5:	85 c0                	test   %eax,%eax
801027d7:	75 1f                	jne    801027f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027d9:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (r)
801027de:	85 c0                	test   %eax,%eax
801027e0:	74 0e                	je     801027f0 <kalloc+0x20>
    kmem.freelist = r->next;
801027e2:	8b 10                	mov    (%eax),%edx
801027e4:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if (kmem.use_lock)
801027ea:	c3                   	ret    
801027eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027ef:	90                   	nop
    release(&kmem.lock);
  return (char *)r;
}
801027f0:	c3                   	ret    
801027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027f8:	55                   	push   %ebp
801027f9:	89 e5                	mov    %esp,%ebp
801027fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027fe:	68 60 26 11 80       	push   $0x80112660
80102803:	e8 f8 1f 00 00       	call   80104800 <acquire>
  r = kmem.freelist;
80102808:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (kmem.use_lock)
8010280d:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if (r)
80102813:	83 c4 10             	add    $0x10,%esp
80102816:	85 c0                	test   %eax,%eax
80102818:	74 08                	je     80102822 <kalloc+0x52>
    kmem.freelist = r->next;
8010281a:	8b 08                	mov    (%eax),%ecx
8010281c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if (kmem.use_lock)
80102822:	85 d2                	test   %edx,%edx
80102824:	74 16                	je     8010283c <kalloc+0x6c>
    release(&kmem.lock);
80102826:	83 ec 0c             	sub    $0xc,%esp
80102829:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010282c:	68 60 26 11 80       	push   $0x80112660
80102831:	e8 6a 1f 00 00       	call   801047a0 <release>
  return (char *)r;
80102836:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102839:	83 c4 10             	add    $0x10,%esp
}
8010283c:	c9                   	leave  
8010283d:	c3                   	ret    
8010283e:	66 90                	xchg   %ax,%ax

80102840 <khugealloc>:
{
  struct run *r;
  
  //r = (struct run *)HUGE_VA_OFFSET;
  
  if (kmem.use_lock)
80102840:	a1 94 26 11 80       	mov    0x80112694,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	75 1f                	jne    80102868 <khugealloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freehugelist;
80102849:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  if (r)
8010284e:	85 c0                	test   %eax,%eax
80102850:	74 0e                	je     80102860 <khugealloc+0x20>
    kmem.freehugelist = r->next;
80102852:	8b 10                	mov    (%eax),%edx
80102854:	89 15 9c 26 11 80    	mov    %edx,0x8011269c
  if (kmem.use_lock)
8010285a:	c3                   	ret    
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
    release(&kmem.lock);

  return (char *)r;
}
80102860:	c3                   	ret    
80102861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102868:	55                   	push   %ebp
80102869:	89 e5                	mov    %esp,%ebp
8010286b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010286e:	68 60 26 11 80       	push   $0x80112660
80102873:	e8 88 1f 00 00       	call   80104800 <acquire>
  r = kmem.freehugelist;
80102878:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  if (kmem.use_lock)
8010287d:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if (r)
80102883:	83 c4 10             	add    $0x10,%esp
80102886:	85 c0                	test   %eax,%eax
80102888:	74 08                	je     80102892 <khugealloc+0x52>
    kmem.freehugelist = r->next;
8010288a:	8b 08                	mov    (%eax),%ecx
8010288c:	89 0d 9c 26 11 80    	mov    %ecx,0x8011269c
  if (kmem.use_lock)
80102892:	85 d2                	test   %edx,%edx
80102894:	74 16                	je     801028ac <khugealloc+0x6c>
    release(&kmem.lock);
80102896:	83 ec 0c             	sub    $0xc,%esp
80102899:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010289c:	68 60 26 11 80       	push   $0x80112660
801028a1:	e8 fa 1e 00 00       	call   801047a0 <release>
  return (char *)r;
801028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028a9:	83 c4 10             	add    $0x10,%esp
}
801028ac:	c9                   	leave  
801028ad:	c3                   	ret    
801028ae:	66 90                	xchg   %ax,%ax

801028b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b0:	ba 64 00 00 00       	mov    $0x64,%edx
801028b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028b6:	a8 01                	test   $0x1,%al
801028b8:	0f 84 c2 00 00 00    	je     80102980 <kbdgetc+0xd0>
{
801028be:	55                   	push   %ebp
801028bf:	ba 60 00 00 00       	mov    $0x60,%edx
801028c4:	89 e5                	mov    %esp,%ebp
801028c6:	53                   	push   %ebx
801028c7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028c8:	8b 1d a0 26 11 80    	mov    0x801126a0,%ebx
  data = inb(KBDATAP);
801028ce:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028d1:	3c e0                	cmp    $0xe0,%al
801028d3:	74 5b                	je     80102930 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028d5:	89 da                	mov    %ebx,%edx
801028d7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028da:	84 c0                	test   %al,%al
801028dc:	78 62                	js     80102940 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028de:	85 d2                	test   %edx,%edx
801028e0:	74 09                	je     801028eb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028e2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028e5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028e8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801028eb:	0f b6 91 a0 7b 10 80 	movzbl -0x7fef8460(%ecx),%edx
  shift ^= togglecode[data];
801028f2:	0f b6 81 a0 7a 10 80 	movzbl -0x7fef8560(%ecx),%eax
  shift |= shiftcode[data];
801028f9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028fb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028fd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028ff:	89 15 a0 26 11 80    	mov    %edx,0x801126a0
  c = charcode[shift & (CTL | SHIFT)][data];
80102905:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102908:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010290b:	8b 04 85 80 7a 10 80 	mov    -0x7fef8580(,%eax,4),%eax
80102912:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102916:	74 0b                	je     80102923 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102918:	8d 50 9f             	lea    -0x61(%eax),%edx
8010291b:	83 fa 19             	cmp    $0x19,%edx
8010291e:	77 48                	ja     80102968 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102920:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102926:	c9                   	leave  
80102927:	c3                   	ret    
80102928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292f:	90                   	nop
    shift |= E0ESC;
80102930:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102933:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102935:	89 1d a0 26 11 80    	mov    %ebx,0x801126a0
}
8010293b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010293e:	c9                   	leave  
8010293f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102940:	83 e0 7f             	and    $0x7f,%eax
80102943:	85 d2                	test   %edx,%edx
80102945:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102948:	0f b6 81 a0 7b 10 80 	movzbl -0x7fef8460(%ecx),%eax
8010294f:	83 c8 40             	or     $0x40,%eax
80102952:	0f b6 c0             	movzbl %al,%eax
80102955:	f7 d0                	not    %eax
80102957:	21 d8                	and    %ebx,%eax
}
80102959:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010295c:	a3 a0 26 11 80       	mov    %eax,0x801126a0
    return 0;
80102961:	31 c0                	xor    %eax,%eax
}
80102963:	c9                   	leave  
80102964:	c3                   	ret    
80102965:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102968:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010296b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010296e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102971:	c9                   	leave  
      c += 'a' - 'A';
80102972:	83 f9 1a             	cmp    $0x1a,%ecx
80102975:	0f 42 c2             	cmovb  %edx,%eax
}
80102978:	c3                   	ret    
80102979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102985:	c3                   	ret    
80102986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298d:	8d 76 00             	lea    0x0(%esi),%esi

80102990 <kbdintr>:

void
kbdintr(void)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102996:	68 b0 28 10 80       	push   $0x801028b0
8010299b:	e8 e0 de ff ff       	call   80100880 <consoleintr>
}
801029a0:	83 c4 10             	add    $0x10,%esp
801029a3:	c9                   	leave  
801029a4:	c3                   	ret    
801029a5:	66 90                	xchg   %ax,%ax
801029a7:	66 90                	xchg   %ax,%ax
801029a9:	66 90                	xchg   %ax,%ax
801029ab:	66 90                	xchg   %ax,%ax
801029ad:	66 90                	xchg   %ax,%ax
801029af:	90                   	nop

801029b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029b0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
801029b5:	85 c0                	test   %eax,%eax
801029b7:	0f 84 cb 00 00 00    	je     80102a88 <lapicinit+0xd8>
  lapic[index] = value;
801029bd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029c4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ca:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029d1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029de:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029eb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a05:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a08:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a0b:	8b 50 30             	mov    0x30(%eax),%edx
80102a0e:	c1 ea 10             	shr    $0x10,%edx
80102a11:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a17:	75 77                	jne    80102a90 <lapicinit+0xe0>
  lapic[index] = value;
80102a19:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a23:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a26:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a2d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a30:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a33:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a40:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a47:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a5a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a61:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a64:	8b 50 20             	mov    0x20(%eax),%edx
80102a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a6e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a70:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a76:	80 e6 10             	and    $0x10,%dh
80102a79:	75 f5                	jne    80102a70 <lapicinit+0xc0>
  lapic[index] = value;
80102a7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a82:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a85:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a88:	c3                   	ret    
80102a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a90:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a97:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a9d:	e9 77 ff ff ff       	jmp    80102a19 <lapicinit+0x69>
80102aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ab0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ab0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102ab5:	85 c0                	test   %eax,%eax
80102ab7:	74 07                	je     80102ac0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102ab9:	8b 40 20             	mov    0x20(%eax),%eax
80102abc:	c1 e8 18             	shr    $0x18,%eax
80102abf:	c3                   	ret    
    return 0;
80102ac0:	31 c0                	xor    %eax,%eax
}
80102ac2:	c3                   	ret    
80102ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ad0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ad0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	74 0d                	je     80102ae6 <lapiceoi+0x16>
  lapic[index] = value;
80102ad9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ae0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ae6:	c3                   	ret    
80102ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aee:	66 90                	xchg   %ax,%ax

80102af0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102af0:	c3                   	ret    
80102af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aff:	90                   	nop

80102b00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b01:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b06:	ba 70 00 00 00       	mov    $0x70,%edx
80102b0b:	89 e5                	mov    %esp,%ebp
80102b0d:	53                   	push   %ebx
80102b0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b14:	ee                   	out    %al,(%dx)
80102b15:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b1a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b20:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b22:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b2d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b30:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b32:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b35:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b38:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b3e:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102b43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b56:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b63:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b75:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b87:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b8d:	c9                   	leave  
80102b8e:	c3                   	ret    
80102b8f:	90                   	nop

80102b90 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b90:	55                   	push   %ebp
80102b91:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b96:	ba 70 00 00 00       	mov    $0x70,%edx
80102b9b:	89 e5                	mov    %esp,%ebp
80102b9d:	57                   	push   %edi
80102b9e:	56                   	push   %esi
80102b9f:	53                   	push   %ebx
80102ba0:	83 ec 4c             	sub    $0x4c,%esp
80102ba3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ba9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102baa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bad:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bb2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
80102bb8:	31 c0                	xor    %eax,%eax
80102bba:	89 da                	mov    %ebx,%edx
80102bbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bc2:	89 ca                	mov    %ecx,%edx
80102bc4:	ec                   	in     (%dx),%al
80102bc5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc8:	89 da                	mov    %ebx,%edx
80102bca:	b8 02 00 00 00       	mov    $0x2,%eax
80102bcf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd0:	89 ca                	mov    %ecx,%edx
80102bd2:	ec                   	in     (%dx),%al
80102bd3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd6:	89 da                	mov    %ebx,%edx
80102bd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bdd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bde:	89 ca                	mov    %ecx,%edx
80102be0:	ec                   	in     (%dx),%al
80102be1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be4:	89 da                	mov    %ebx,%edx
80102be6:	b8 07 00 00 00       	mov    $0x7,%eax
80102beb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bec:	89 ca                	mov    %ecx,%edx
80102bee:	ec                   	in     (%dx),%al
80102bef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf2:	89 da                	mov    %ebx,%edx
80102bf4:	b8 08 00 00 00       	mov    $0x8,%eax
80102bf9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfa:	89 ca                	mov    %ecx,%edx
80102bfc:	ec                   	in     (%dx),%al
80102bfd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bff:	89 da                	mov    %ebx,%edx
80102c01:	b8 09 00 00 00       	mov    $0x9,%eax
80102c06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c07:	89 ca                	mov    %ecx,%edx
80102c09:	ec                   	in     (%dx),%al
80102c0a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c0c:	89 da                	mov    %ebx,%edx
80102c0e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c14:	89 ca                	mov    %ecx,%edx
80102c16:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c17:	84 c0                	test   %al,%al
80102c19:	78 9d                	js     80102bb8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c1b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c1f:	89 fa                	mov    %edi,%edx
80102c21:	0f b6 fa             	movzbl %dl,%edi
80102c24:	89 f2                	mov    %esi,%edx
80102c26:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c29:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c2d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c30:	89 da                	mov    %ebx,%edx
80102c32:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c35:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c38:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c3c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c42:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c49:	31 c0                	xor    %eax,%eax
80102c4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4c:	89 ca                	mov    %ecx,%edx
80102c4e:	ec                   	in     (%dx),%al
80102c4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c52:	89 da                	mov    %ebx,%edx
80102c54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c57:	b8 02 00 00 00       	mov    $0x2,%eax
80102c5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5d:	89 ca                	mov    %ecx,%edx
80102c5f:	ec                   	in     (%dx),%al
80102c60:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c63:	89 da                	mov    %ebx,%edx
80102c65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c68:	b8 04 00 00 00       	mov    $0x4,%eax
80102c6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6e:	89 ca                	mov    %ecx,%edx
80102c70:	ec                   	in     (%dx),%al
80102c71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c74:	89 da                	mov    %ebx,%edx
80102c76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c79:	b8 07 00 00 00       	mov    $0x7,%eax
80102c7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7f:	89 ca                	mov    %ecx,%edx
80102c81:	ec                   	in     (%dx),%al
80102c82:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c85:	89 da                	mov    %ebx,%edx
80102c87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c90:	89 ca                	mov    %ecx,%edx
80102c92:	ec                   	in     (%dx),%al
80102c93:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c96:	89 da                	mov    %ebx,%edx
80102c98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102ca0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca1:	89 ca                	mov    %ecx,%edx
80102ca3:	ec                   	in     (%dx),%al
80102ca4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ca7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102caa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cad:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cb0:	6a 18                	push   $0x18
80102cb2:	50                   	push   %eax
80102cb3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cb6:	50                   	push   %eax
80102cb7:	e8 54 1c 00 00       	call   80104910 <memcmp>
80102cbc:	83 c4 10             	add    $0x10,%esp
80102cbf:	85 c0                	test   %eax,%eax
80102cc1:	0f 85 f1 fe ff ff    	jne    80102bb8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102cc7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ccb:	75 78                	jne    80102d45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ccd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cd0:	89 c2                	mov    %eax,%edx
80102cd2:	83 e0 0f             	and    $0xf,%eax
80102cd5:	c1 ea 04             	shr    $0x4,%edx
80102cd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cde:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ce1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ce4:	89 c2                	mov    %eax,%edx
80102ce6:	83 e0 0f             	and    $0xf,%eax
80102ce9:	c1 ea 04             	shr    $0x4,%edx
80102cec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cf5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cf8:	89 c2                	mov    %eax,%edx
80102cfa:	83 e0 0f             	and    $0xf,%eax
80102cfd:	c1 ea 04             	shr    $0x4,%edx
80102d00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d0c:	89 c2                	mov    %eax,%edx
80102d0e:	83 e0 0f             	and    $0xf,%eax
80102d11:	c1 ea 04             	shr    $0x4,%edx
80102d14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d20:	89 c2                	mov    %eax,%edx
80102d22:	83 e0 0f             	and    $0xf,%eax
80102d25:	c1 ea 04             	shr    $0x4,%edx
80102d28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d34:	89 c2                	mov    %eax,%edx
80102d36:	83 e0 0f             	and    $0xf,%eax
80102d39:	c1 ea 04             	shr    $0x4,%edx
80102d3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d45:	8b 75 08             	mov    0x8(%ebp),%esi
80102d48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d4b:	89 06                	mov    %eax,(%esi)
80102d4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d50:	89 46 04             	mov    %eax,0x4(%esi)
80102d53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d56:	89 46 08             	mov    %eax,0x8(%esi)
80102d59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d62:	89 46 10             	mov    %eax,0x10(%esi)
80102d65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d75:	5b                   	pop    %ebx
80102d76:	5e                   	pop    %esi
80102d77:	5f                   	pop    %edi
80102d78:	5d                   	pop    %ebp
80102d79:	c3                   	ret    
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d80:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102d86:	85 c9                	test   %ecx,%ecx
80102d88:	0f 8e 8a 00 00 00    	jle    80102e18 <install_trans+0x98>
{
80102d8e:	55                   	push   %ebp
80102d8f:	89 e5                	mov    %esp,%ebp
80102d91:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d92:	31 ff                	xor    %edi,%edi
{
80102d94:	56                   	push   %esi
80102d95:	53                   	push   %ebx
80102d96:	83 ec 0c             	sub    $0xc,%esp
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102da0:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102da5:	83 ec 08             	sub    $0x8,%esp
80102da8:	01 f8                	add    %edi,%eax
80102daa:	83 c0 01             	add    $0x1,%eax
80102dad:	50                   	push   %eax
80102dae:	ff 35 04 27 11 80    	push   0x80112704
80102db4:	e8 17 d3 ff ff       	call   801000d0 <bread>
80102db9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbb:	58                   	pop    %eax
80102dbc:	5a                   	pop    %edx
80102dbd:	ff 34 bd 0c 27 11 80 	push   -0x7feed8f4(,%edi,4)
80102dc4:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102dca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dcd:	e8 fe d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dd5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dd7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dda:	68 00 02 00 00       	push   $0x200
80102ddf:	50                   	push   %eax
80102de0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102de3:	50                   	push   %eax
80102de4:	e8 77 1b 00 00       	call   80104960 <memmove>
    bwrite(dbuf);  // write dst to disk
80102de9:	89 1c 24             	mov    %ebx,(%esp)
80102dec:	e8 bf d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102df1:	89 34 24             	mov    %esi,(%esp)
80102df4:	e8 f7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102df9:	89 1c 24             	mov    %ebx,(%esp)
80102dfc:	e8 ef d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	39 3d 08 27 11 80    	cmp    %edi,0x80112708
80102e0a:	7f 94                	jg     80102da0 <install_trans+0x20>
  }
}
80102e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e0f:	5b                   	pop    %ebx
80102e10:	5e                   	pop    %esi
80102e11:	5f                   	pop    %edi
80102e12:	5d                   	pop    %ebp
80102e13:	c3                   	ret    
80102e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e18:	c3                   	ret    
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e27:	ff 35 f4 26 11 80    	push   0x801126f4
80102e2d:	ff 35 04 27 11 80    	push   0x80112704
80102e33:	e8 98 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e38:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e3b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e3d:	a1 08 27 11 80       	mov    0x80112708,%eax
80102e42:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e45:	85 c0                	test   %eax,%eax
80102e47:	7e 19                	jle    80102e62 <write_head+0x42>
80102e49:	31 d2                	xor    %edx,%edx
80102e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e50:	8b 0c 95 0c 27 11 80 	mov    -0x7feed8f4(,%edx,4),%ecx
80102e57:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e5b:	83 c2 01             	add    $0x1,%edx
80102e5e:	39 d0                	cmp    %edx,%eax
80102e60:	75 ee                	jne    80102e50 <write_head+0x30>
  }
  bwrite(buf);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	53                   	push   %ebx
80102e66:	e8 45 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e6b:	89 1c 24             	mov    %ebx,(%esp)
80102e6e:	e8 7d d3 ff ff       	call   801001f0 <brelse>
}
80102e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e76:	83 c4 10             	add    $0x10,%esp
80102e79:	c9                   	leave  
80102e7a:	c3                   	ret    
80102e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop

80102e80 <initlog>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 2c             	sub    $0x2c,%esp
80102e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e8a:	68 a0 7c 10 80       	push   $0x80107ca0
80102e8f:	68 c0 26 11 80       	push   $0x801126c0
80102e94:	e8 97 17 00 00       	call   80104630 <initlock>
  readsb(dev, &sb);
80102e99:	58                   	pop    %eax
80102e9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e9d:	5a                   	pop    %edx
80102e9e:	50                   	push   %eax
80102e9f:	53                   	push   %ebx
80102ea0:	e8 8b e6 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ea8:	59                   	pop    %ecx
  log.dev = dev;
80102ea9:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
80102eaf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102eb2:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  log.size = sb.nlog;
80102eb7:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  struct buf *buf = bread(log.dev, log.start);
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 0b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ec5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ec8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ecb:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
80102ed1:	85 db                	test   %ebx,%ebx
80102ed3:	7e 1d                	jle    80102ef2 <initlog+0x72>
80102ed5:	31 d2                	xor    %edx,%edx
80102ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ede:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ee0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ee4:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102eeb:	83 c2 01             	add    $0x1,%edx
80102eee:	39 d3                	cmp    %edx,%ebx
80102ef0:	75 ee                	jne    80102ee0 <initlog+0x60>
  brelse(buf);
80102ef2:	83 ec 0c             	sub    $0xc,%esp
80102ef5:	50                   	push   %eax
80102ef6:	e8 f5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102efb:	e8 80 fe ff ff       	call   80102d80 <install_trans>
  log.lh.n = 0;
80102f00:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102f07:	00 00 00 
  write_head(); // clear the log
80102f0a:	e8 11 ff ff ff       	call   80102e20 <write_head>
}
80102f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f12:	83 c4 10             	add    $0x10,%esp
80102f15:	c9                   	leave  
80102f16:	c3                   	ret    
80102f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1e:	66 90                	xchg   %ax,%ax

80102f20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f26:	68 c0 26 11 80       	push   $0x801126c0
80102f2b:	e8 d0 18 00 00       	call   80104800 <acquire>
80102f30:	83 c4 10             	add    $0x10,%esp
80102f33:	eb 18                	jmp    80102f4d <begin_op+0x2d>
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f38:	83 ec 08             	sub    $0x8,%esp
80102f3b:	68 c0 26 11 80       	push   $0x801126c0
80102f40:	68 c0 26 11 80       	push   $0x801126c0
80102f45:	e8 56 13 00 00       	call   801042a0 <sleep>
80102f4a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f4d:	a1 00 27 11 80       	mov    0x80112700,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	75 e2                	jne    80102f38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f56:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102f5b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102f61:	83 c0 01             	add    $0x1,%eax
80102f64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f6a:	83 fa 1e             	cmp    $0x1e,%edx
80102f6d:	7f c9                	jg     80102f38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f6f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f72:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80102f77:	68 c0 26 11 80       	push   $0x801126c0
80102f7c:	e8 1f 18 00 00       	call   801047a0 <release>
      break;
    }
  }
}
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	c9                   	leave  
80102f85:	c3                   	ret    
80102f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f8d:	8d 76 00             	lea    0x0(%esi),%esi

80102f90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f99:	68 c0 26 11 80       	push   $0x801126c0
80102f9e:	e8 5d 18 00 00       	call   80104800 <acquire>
  log.outstanding -= 1;
80102fa3:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80102fa8:	8b 35 00 27 11 80    	mov    0x80112700,%esi
80102fae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fb1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fb4:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
80102fba:	85 f6                	test   %esi,%esi
80102fbc:	0f 85 22 01 00 00    	jne    801030e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fc2:	85 db                	test   %ebx,%ebx
80102fc4:	0f 85 f6 00 00 00    	jne    801030c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fca:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
80102fd1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fd4:	83 ec 0c             	sub    $0xc,%esp
80102fd7:	68 c0 26 11 80       	push   $0x801126c0
80102fdc:	e8 bf 17 00 00       	call   801047a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fe1:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102fe7:	83 c4 10             	add    $0x10,%esp
80102fea:	85 c9                	test   %ecx,%ecx
80102fec:	7f 42                	jg     80103030 <end_op+0xa0>
    acquire(&log.lock);
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 c0 26 11 80       	push   $0x801126c0
80102ff6:	e8 05 18 00 00       	call   80104800 <acquire>
    wakeup(&log);
80102ffb:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
    log.committing = 0;
80103002:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80103009:	00 00 00 
    wakeup(&log);
8010300c:	e8 4f 13 00 00       	call   80104360 <wakeup>
    release(&log.lock);
80103011:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80103018:	e8 83 17 00 00       	call   801047a0 <release>
8010301d:	83 c4 10             	add    $0x10,%esp
}
80103020:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103023:	5b                   	pop    %ebx
80103024:	5e                   	pop    %esi
80103025:	5f                   	pop    %edi
80103026:	5d                   	pop    %ebp
80103027:	c3                   	ret    
80103028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103030:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80103035:	83 ec 08             	sub    $0x8,%esp
80103038:	01 d8                	add    %ebx,%eax
8010303a:	83 c0 01             	add    $0x1,%eax
8010303d:	50                   	push   %eax
8010303e:	ff 35 04 27 11 80    	push   0x80112704
80103044:	e8 87 d0 ff ff       	call   801000d0 <bread>
80103049:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010304b:	58                   	pop    %eax
8010304c:	5a                   	pop    %edx
8010304d:	ff 34 9d 0c 27 11 80 	push   -0x7feed8f4(,%ebx,4)
80103054:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
8010305a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010305d:	e8 6e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103062:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103065:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103067:	8d 40 5c             	lea    0x5c(%eax),%eax
8010306a:	68 00 02 00 00       	push   $0x200
8010306f:	50                   	push   %eax
80103070:	8d 46 5c             	lea    0x5c(%esi),%eax
80103073:	50                   	push   %eax
80103074:	e8 e7 18 00 00       	call   80104960 <memmove>
    bwrite(to);  // write the log
80103079:	89 34 24             	mov    %esi,(%esp)
8010307c:	e8 2f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103081:	89 3c 24             	mov    %edi,(%esp)
80103084:	e8 67 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103089:	89 34 24             	mov    %esi,(%esp)
8010308c:	e8 5f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
8010309a:	7c 94                	jl     80103030 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010309c:	e8 7f fd ff ff       	call   80102e20 <write_head>
    install_trans(); // Now install writes to home locations
801030a1:	e8 da fc ff ff       	call   80102d80 <install_trans>
    log.lh.n = 0;
801030a6:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
801030ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801030b0:	e8 6b fd ff ff       	call   80102e20 <write_head>
801030b5:	e9 34 ff ff ff       	jmp    80102fee <end_op+0x5e>
801030ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030c0:	83 ec 0c             	sub    $0xc,%esp
801030c3:	68 c0 26 11 80       	push   $0x801126c0
801030c8:	e8 93 12 00 00       	call   80104360 <wakeup>
  release(&log.lock);
801030cd:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
801030d4:	e8 c7 16 00 00       	call   801047a0 <release>
801030d9:	83 c4 10             	add    $0x10,%esp
}
801030dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030df:	5b                   	pop    %ebx
801030e0:	5e                   	pop    %esi
801030e1:	5f                   	pop    %edi
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret    
    panic("log.committing");
801030e4:	83 ec 0c             	sub    $0xc,%esp
801030e7:	68 a4 7c 10 80       	push   $0x80107ca4
801030ec:	e8 8f d2 ff ff       	call   80100380 <panic>
801030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ff:	90                   	nop

80103100 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	53                   	push   %ebx
80103104:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103107:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
8010310d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103110:	83 fa 1d             	cmp    $0x1d,%edx
80103113:	0f 8f 85 00 00 00    	jg     8010319e <log_write+0x9e>
80103119:	a1 f8 26 11 80       	mov    0x801126f8,%eax
8010311e:	83 e8 01             	sub    $0x1,%eax
80103121:	39 c2                	cmp    %eax,%edx
80103123:	7d 79                	jge    8010319e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103125:	a1 fc 26 11 80       	mov    0x801126fc,%eax
8010312a:	85 c0                	test   %eax,%eax
8010312c:	7e 7d                	jle    801031ab <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010312e:	83 ec 0c             	sub    $0xc,%esp
80103131:	68 c0 26 11 80       	push   $0x801126c0
80103136:	e8 c5 16 00 00       	call   80104800 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010313b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80103141:	83 c4 10             	add    $0x10,%esp
80103144:	85 d2                	test   %edx,%edx
80103146:	7e 4a                	jle    80103192 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103148:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010314b:	31 c0                	xor    %eax,%eax
8010314d:	eb 08                	jmp    80103157 <log_write+0x57>
8010314f:	90                   	nop
80103150:	83 c0 01             	add    $0x1,%eax
80103153:	39 c2                	cmp    %eax,%edx
80103155:	74 29                	je     80103180 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103157:	39 0c 85 0c 27 11 80 	cmp    %ecx,-0x7feed8f4(,%eax,4)
8010315e:	75 f0                	jne    80103150 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103160:	89 0c 85 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103167:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010316a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010316d:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80103174:	c9                   	leave  
  release(&log.lock);
80103175:	e9 26 16 00 00       	jmp    801047a0 <release>
8010317a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103180:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
    log.lh.n++;
80103187:	83 c2 01             	add    $0x1,%edx
8010318a:	89 15 08 27 11 80    	mov    %edx,0x80112708
80103190:	eb d5                	jmp    80103167 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103192:	8b 43 08             	mov    0x8(%ebx),%eax
80103195:	a3 0c 27 11 80       	mov    %eax,0x8011270c
  if (i == log.lh.n)
8010319a:	75 cb                	jne    80103167 <log_write+0x67>
8010319c:	eb e9                	jmp    80103187 <log_write+0x87>
    panic("too big a transaction");
8010319e:	83 ec 0c             	sub    $0xc,%esp
801031a1:	68 b3 7c 10 80       	push   $0x80107cb3
801031a6:	e8 d5 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031ab:	83 ec 0c             	sub    $0xc,%esp
801031ae:	68 c9 7c 10 80       	push   $0x80107cc9
801031b3:	e8 c8 d1 ff ff       	call   80100380 <panic>
801031b8:	66 90                	xchg   %ax,%ax
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031c7:	e8 54 09 00 00       	call   80103b20 <cpuid>
801031cc:	89 c3                	mov    %eax,%ebx
801031ce:	e8 4d 09 00 00       	call   80103b20 <cpuid>
801031d3:	83 ec 04             	sub    $0x4,%esp
801031d6:	53                   	push   %ebx
801031d7:	50                   	push   %eax
801031d8:	68 e4 7c 10 80       	push   $0x80107ce4
801031dd:	e8 be d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801031e2:	e8 d9 2a 00 00       	call   80105cc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031e7:	e8 d4 08 00 00       	call   80103ac0 <mycpu>
801031ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031ee:	b8 01 00 00 00       	mov    $0x1,%eax
801031f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031fa:	e8 91 0c 00 00       	call   80103e90 <scheduler>
801031ff:	90                   	nop

80103200 <mpenter>:
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103206:	e8 b5 3c 00 00       	call   80106ec0 <switchkvm>
  seginit();
8010320b:	e8 20 3c 00 00       	call   80106e30 <seginit>
  lapicinit();
80103210:	e8 9b f7 ff ff       	call   801029b0 <lapicinit>
  mpmain();
80103215:	e8 a6 ff ff ff       	call   801031c0 <mpmain>
8010321a:	66 90                	xchg   %ax,%ax
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <main>:
{
80103220:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103224:	83 e4 f0             	and    $0xfffffff0,%esp
80103227:	ff 71 fc             	push   -0x4(%ecx)
8010322a:	55                   	push   %ebp
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	53                   	push   %ebx
8010322e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010322f:	83 ec 08             	sub    $0x8,%esp
80103232:	68 00 00 40 80       	push   $0x80400000
80103237:	68 f0 65 11 80       	push   $0x801165f0
8010323c:	e8 df f3 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103241:	e8 da 42 00 00       	call   80107520 <kvmalloc>
  mpinit();        // detect other processors
80103246:	e8 95 01 00 00       	call   801033e0 <mpinit>
  lapicinit();     // interrupt controller
8010324b:	e8 60 f7 ff ff       	call   801029b0 <lapicinit>
  seginit();       // segment descriptors
80103250:	e8 db 3b 00 00       	call   80106e30 <seginit>
  picinit();       // disable pic
80103255:	e8 86 03 00 00       	call   801035e0 <picinit>
  ioapicinit();    // another interrupt controller
8010325a:	e8 81 f1 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
8010325f:	e8 fc d7 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103264:	e8 47 2d 00 00       	call   80105fb0 <uartinit>
  pinit();         // process table
80103269:	e8 32 08 00 00       	call   80103aa0 <pinit>
  tvinit();        // trap vectors
8010326e:	e8 cd 29 00 00       	call   80105c40 <tvinit>
  binit();         // buffer cache
80103273:	e8 c8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103278:	e8 a3 db ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
8010327d:	e8 4e ef ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103282:	83 c4 0c             	add    $0xc,%esp
80103285:	68 8a 00 00 00       	push   $0x8a
8010328a:	68 9c b4 10 80       	push   $0x8010b49c
8010328f:	68 00 70 00 80       	push   $0x80007000
80103294:	e8 c7 16 00 00       	call   80104960 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
801032a3:	00 00 00 
801032a6:	05 c0 27 11 80       	add    $0x801127c0,%eax
801032ab:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
801032b0:	76 7e                	jbe    80103330 <main+0x110>
801032b2:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
801032b7:	eb 20                	jmp    801032d9 <main+0xb9>
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032c0:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
801032c7:	00 00 00 
801032ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032d0:	05 c0 27 11 80       	add    $0x801127c0,%eax
801032d5:	39 c3                	cmp    %eax,%ebx
801032d7:	73 57                	jae    80103330 <main+0x110>
    if(c == mycpu())  // We've started already.
801032d9:	e8 e2 07 00 00       	call   80103ac0 <mycpu>
801032de:	39 c3                	cmp    %eax,%ebx
801032e0:	74 de                	je     801032c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032e2:	e8 e9 f4 ff ff       	call   801027d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103200,0x80006ff8
801032f1:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032f4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032fb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032fe:	05 00 10 00 00       	add    $0x1000,%eax
80103303:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103308:	0f b6 03             	movzbl (%ebx),%eax
8010330b:	68 00 70 00 00       	push   $0x7000
80103310:	50                   	push   %eax
80103311:	e8 ea f7 ff ff       	call   80102b00 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103316:	83 c4 10             	add    $0x10,%esp
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103320:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103326:	85 c0                	test   %eax,%eax
80103328:	74 f6                	je     80103320 <main+0x100>
8010332a:	eb 94                	jmp    801032c0 <main+0xa0>
8010332c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103330:	83 ec 08             	sub    $0x8,%esp
80103333:	68 00 00 00 8e       	push   $0x8e000000
80103338:	68 00 00 40 80       	push   $0x80400000
8010333d:	e8 7e f2 ff ff       	call   801025c0 <kinit2>
  khugeinit(P2V(HUGE_PAGE_START), P2V(HUGE_PAGE_END));
80103342:	58                   	pop    %eax
80103343:	5a                   	pop    %edx
80103344:	68 00 00 00 be       	push   $0xbe000000
80103349:	68 00 00 00 9e       	push   $0x9e000000
8010334e:	e8 2d f4 ff ff       	call   80102780 <khugeinit>
  userinit();      // first user process
80103353:	e8 18 08 00 00       	call   80103b70 <userinit>
  mpmain();        // finish this processor's setup
80103358:	e8 63 fe ff ff       	call   801031c0 <mpmain>
8010335d:	66 90                	xchg   %ax,%ax
8010335f:	90                   	nop

80103360 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103365:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010336b:	53                   	push   %ebx
  e = addr+len;
8010336c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010336f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103372:	39 de                	cmp    %ebx,%esi
80103374:	72 10                	jb     80103386 <mpsearch1+0x26>
80103376:	eb 50                	jmp    801033c8 <mpsearch1+0x68>
80103378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337f:	90                   	nop
80103380:	89 fe                	mov    %edi,%esi
80103382:	39 fb                	cmp    %edi,%ebx
80103384:	76 42                	jbe    801033c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103386:	83 ec 04             	sub    $0x4,%esp
80103389:	8d 7e 10             	lea    0x10(%esi),%edi
8010338c:	6a 04                	push   $0x4
8010338e:	68 f8 7c 10 80       	push   $0x80107cf8
80103393:	56                   	push   %esi
80103394:	e8 77 15 00 00       	call   80104910 <memcmp>
80103399:	83 c4 10             	add    $0x10,%esp
8010339c:	85 c0                	test   %eax,%eax
8010339e:	75 e0                	jne    80103380 <mpsearch1+0x20>
801033a0:	89 f2                	mov    %esi,%edx
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033b0:	39 fa                	cmp    %edi,%edx
801033b2:	75 f4                	jne    801033a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b4:	84 c0                	test   %al,%al
801033b6:	75 c8                	jne    80103380 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bb:	89 f0                	mov    %esi,%eax
801033bd:	5b                   	pop    %ebx
801033be:	5e                   	pop    %esi
801033bf:	5f                   	pop    %edi
801033c0:	5d                   	pop    %ebp
801033c1:	c3                   	ret    
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033cb:	31 f6                	xor    %esi,%esi
}
801033cd:	5b                   	pop    %ebx
801033ce:	89 f0                	mov    %esi,%eax
801033d0:	5e                   	pop    %esi
801033d1:	5f                   	pop    %edi
801033d2:	5d                   	pop    %ebp
801033d3:	c3                   	ret    
801033d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop

801033e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033f7:	c1 e0 08             	shl    $0x8,%eax
801033fa:	09 d0                	or     %edx,%eax
801033fc:	c1 e0 04             	shl    $0x4,%eax
801033ff:	75 1b                	jne    8010341c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103401:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103408:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010340f:	c1 e0 08             	shl    $0x8,%eax
80103412:	09 d0                	or     %edx,%eax
80103414:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103417:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010341c:	ba 00 04 00 00       	mov    $0x400,%edx
80103421:	e8 3a ff ff ff       	call   80103360 <mpsearch1>
80103426:	89 c3                	mov    %eax,%ebx
80103428:	85 c0                	test   %eax,%eax
8010342a:	0f 84 40 01 00 00    	je     80103570 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103430:	8b 73 04             	mov    0x4(%ebx),%esi
80103433:	85 f6                	test   %esi,%esi
80103435:	0f 84 25 01 00 00    	je     80103560 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010343b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010343e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103444:	6a 04                	push   $0x4
80103446:	68 fd 7c 10 80       	push   $0x80107cfd
8010344b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010344c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010344f:	e8 bc 14 00 00       	call   80104910 <memcmp>
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	85 c0                	test   %eax,%eax
80103459:	0f 85 01 01 00 00    	jne    80103560 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010345f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103466:	3c 01                	cmp    $0x1,%al
80103468:	74 08                	je     80103472 <mpinit+0x92>
8010346a:	3c 04                	cmp    $0x4,%al
8010346c:	0f 85 ee 00 00 00    	jne    80103560 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103472:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103479:	66 85 d2             	test   %dx,%dx
8010347c:	74 22                	je     801034a0 <mpinit+0xc0>
8010347e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103481:	89 f0                	mov    %esi,%eax
  sum = 0;
80103483:	31 d2                	xor    %edx,%edx
80103485:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103488:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010348f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103492:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103494:	39 c7                	cmp    %eax,%edi
80103496:	75 f0                	jne    80103488 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103498:	84 d2                	test   %dl,%dl
8010349a:	0f 85 c0 00 00 00    	jne    80103560 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034a0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801034a6:	a3 a4 26 11 80       	mov    %eax,0x801126a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ab:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034b2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034b8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034bd:	03 55 e4             	add    -0x1c(%ebp),%edx
801034c0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034c7:	90                   	nop
801034c8:	39 d0                	cmp    %edx,%eax
801034ca:	73 15                	jae    801034e1 <mpinit+0x101>
    switch(*p){
801034cc:	0f b6 08             	movzbl (%eax),%ecx
801034cf:	80 f9 02             	cmp    $0x2,%cl
801034d2:	74 4c                	je     80103520 <mpinit+0x140>
801034d4:	77 3a                	ja     80103510 <mpinit+0x130>
801034d6:	84 c9                	test   %cl,%cl
801034d8:	74 56                	je     80103530 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034da:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034dd:	39 d0                	cmp    %edx,%eax
801034df:	72 eb                	jb     801034cc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034e4:	85 f6                	test   %esi,%esi
801034e6:	0f 84 d9 00 00 00    	je     801035c5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034ec:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034f0:	74 15                	je     80103507 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f2:	b8 70 00 00 00       	mov    $0x70,%eax
801034f7:	ba 22 00 00 00       	mov    $0x22,%edx
801034fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034fd:	ba 23 00 00 00       	mov    $0x23,%edx
80103502:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103503:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103506:	ee                   	out    %al,(%dx)
  }
}
80103507:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010350a:	5b                   	pop    %ebx
8010350b:	5e                   	pop    %esi
8010350c:	5f                   	pop    %edi
8010350d:	5d                   	pop    %ebp
8010350e:	c3                   	ret    
8010350f:	90                   	nop
    switch(*p){
80103510:	83 e9 03             	sub    $0x3,%ecx
80103513:	80 f9 01             	cmp    $0x1,%cl
80103516:	76 c2                	jbe    801034da <mpinit+0xfa>
80103518:	31 f6                	xor    %esi,%esi
8010351a:	eb ac                	jmp    801034c8 <mpinit+0xe8>
8010351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103520:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103524:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103527:	88 0d a0 27 11 80    	mov    %cl,0x801127a0
      continue;
8010352d:	eb 99                	jmp    801034c8 <mpinit+0xe8>
8010352f:	90                   	nop
      if(ncpu < NCPU) {
80103530:	8b 0d a4 27 11 80    	mov    0x801127a4,%ecx
80103536:	83 f9 07             	cmp    $0x7,%ecx
80103539:	7f 19                	jg     80103554 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010353b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103541:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103545:	83 c1 01             	add    $0x1,%ecx
80103548:	89 0d a4 27 11 80    	mov    %ecx,0x801127a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010354e:	88 9f c0 27 11 80    	mov    %bl,-0x7feed840(%edi)
      p += sizeof(struct mpproc);
80103554:	83 c0 14             	add    $0x14,%eax
      continue;
80103557:	e9 6c ff ff ff       	jmp    801034c8 <mpinit+0xe8>
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	68 02 7d 10 80       	push   $0x80107d02
80103568:	e8 13 ce ff ff       	call   80100380 <panic>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103570:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103575:	eb 13                	jmp    8010358a <mpinit+0x1aa>
80103577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010357e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103580:	89 f3                	mov    %esi,%ebx
80103582:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103588:	74 d6                	je     80103560 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010358a:	83 ec 04             	sub    $0x4,%esp
8010358d:	8d 73 10             	lea    0x10(%ebx),%esi
80103590:	6a 04                	push   $0x4
80103592:	68 f8 7c 10 80       	push   $0x80107cf8
80103597:	53                   	push   %ebx
80103598:	e8 73 13 00 00       	call   80104910 <memcmp>
8010359d:	83 c4 10             	add    $0x10,%esp
801035a0:	85 c0                	test   %eax,%eax
801035a2:	75 dc                	jne    80103580 <mpinit+0x1a0>
801035a4:	89 da                	mov    %ebx,%edx
801035a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035b0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035b3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035b6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035b8:	39 d6                	cmp    %edx,%esi
801035ba:	75 f4                	jne    801035b0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035bc:	84 c0                	test   %al,%al
801035be:	75 c0                	jne    80103580 <mpinit+0x1a0>
801035c0:	e9 6b fe ff ff       	jmp    80103430 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035c5:	83 ec 0c             	sub    $0xc,%esp
801035c8:	68 1c 7d 10 80       	push   $0x80107d1c
801035cd:	e8 ae cd ff ff       	call   80100380 <panic>
801035d2:	66 90                	xchg   %ax,%ax
801035d4:	66 90                	xchg   %ax,%ax
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <picinit>:
801035e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035e5:	ba 21 00 00 00       	mov    $0x21,%edx
801035ea:	ee                   	out    %al,(%dx)
801035eb:	ba a1 00 00 00       	mov    $0xa1,%edx
801035f0:	ee                   	out    %al,(%dx)
801035f1:	c3                   	ret    
801035f2:	66 90                	xchg   %ax,%ax
801035f4:	66 90                	xchg   %ax,%ax
801035f6:	66 90                	xchg   %ax,%ax
801035f8:	66 90                	xchg   %ax,%ax
801035fa:	66 90                	xchg   %ax,%ax
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010360c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010360f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103615:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010361b:	e8 20 d8 ff ff       	call   80100e40 <filealloc>
80103620:	89 03                	mov    %eax,(%ebx)
80103622:	85 c0                	test   %eax,%eax
80103624:	0f 84 a8 00 00 00    	je     801036d2 <pipealloc+0xd2>
8010362a:	e8 11 d8 ff ff       	call   80100e40 <filealloc>
8010362f:	89 06                	mov    %eax,(%esi)
80103631:	85 c0                	test   %eax,%eax
80103633:	0f 84 87 00 00 00    	je     801036c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103639:	e8 92 f1 ff ff       	call   801027d0 <kalloc>
8010363e:	89 c7                	mov    %eax,%edi
80103640:	85 c0                	test   %eax,%eax
80103642:	0f 84 b0 00 00 00    	je     801036f8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103648:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010364f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103652:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103655:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010365c:	00 00 00 
  p->nwrite = 0;
8010365f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103666:	00 00 00 
  p->nread = 0;
80103669:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103670:	00 00 00 
  initlock(&p->lock, "pipe");
80103673:	68 3b 7d 10 80       	push   $0x80107d3b
80103678:	50                   	push   %eax
80103679:	e8 b2 0f 00 00       	call   80104630 <initlock>
  (*f0)->type = FD_PIPE;
8010367e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103680:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103683:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103689:	8b 03                	mov    (%ebx),%eax
8010368b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010368f:	8b 03                	mov    (%ebx),%eax
80103691:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103695:	8b 03                	mov    (%ebx),%eax
80103697:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010369a:	8b 06                	mov    (%esi),%eax
8010369c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036a2:	8b 06                	mov    (%esi),%eax
801036a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036a8:	8b 06                	mov    (%esi),%eax
801036aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036ae:	8b 06                	mov    (%esi),%eax
801036b0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036b6:	31 c0                	xor    %eax,%eax
}
801036b8:	5b                   	pop    %ebx
801036b9:	5e                   	pop    %esi
801036ba:	5f                   	pop    %edi
801036bb:	5d                   	pop    %ebp
801036bc:	c3                   	ret    
801036bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801036c0:	8b 03                	mov    (%ebx),%eax
801036c2:	85 c0                	test   %eax,%eax
801036c4:	74 1e                	je     801036e4 <pipealloc+0xe4>
    fileclose(*f0);
801036c6:	83 ec 0c             	sub    $0xc,%esp
801036c9:	50                   	push   %eax
801036ca:	e8 31 d8 ff ff       	call   80100f00 <fileclose>
801036cf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036d2:	8b 06                	mov    (%esi),%eax
801036d4:	85 c0                	test   %eax,%eax
801036d6:	74 0c                	je     801036e4 <pipealloc+0xe4>
    fileclose(*f1);
801036d8:	83 ec 0c             	sub    $0xc,%esp
801036db:	50                   	push   %eax
801036dc:	e8 1f d8 ff ff       	call   80100f00 <fileclose>
801036e1:	83 c4 10             	add    $0x10,%esp
}
801036e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036ec:	5b                   	pop    %ebx
801036ed:	5e                   	pop    %esi
801036ee:	5f                   	pop    %edi
801036ef:	5d                   	pop    %ebp
801036f0:	c3                   	ret    
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801036f8:	8b 03                	mov    (%ebx),%eax
801036fa:	85 c0                	test   %eax,%eax
801036fc:	75 c8                	jne    801036c6 <pipealloc+0xc6>
801036fe:	eb d2                	jmp    801036d2 <pipealloc+0xd2>

80103700 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
80103705:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103708:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	53                   	push   %ebx
8010370f:	e8 ec 10 00 00       	call   80104800 <acquire>
  if(writable){
80103714:	83 c4 10             	add    $0x10,%esp
80103717:	85 f6                	test   %esi,%esi
80103719:	74 65                	je     80103780 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010371b:	83 ec 0c             	sub    $0xc,%esp
8010371e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103724:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010372b:	00 00 00 
    wakeup(&p->nread);
8010372e:	50                   	push   %eax
8010372f:	e8 2c 0c 00 00       	call   80104360 <wakeup>
80103734:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103737:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010373d:	85 d2                	test   %edx,%edx
8010373f:	75 0a                	jne    8010374b <pipeclose+0x4b>
80103741:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103747:	85 c0                	test   %eax,%eax
80103749:	74 15                	je     80103760 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010374b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010374e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103751:	5b                   	pop    %ebx
80103752:	5e                   	pop    %esi
80103753:	5d                   	pop    %ebp
    release(&p->lock);
80103754:	e9 47 10 00 00       	jmp    801047a0 <release>
80103759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	53                   	push   %ebx
80103764:	e8 37 10 00 00       	call   801047a0 <release>
    kfree((char*)p);
80103769:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010376c:	83 c4 10             	add    $0x10,%esp
}
8010376f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103772:	5b                   	pop    %ebx
80103773:	5e                   	pop    %esi
80103774:	5d                   	pop    %ebp
    kfree((char*)p);
80103775:	e9 56 ed ff ff       	jmp    801024d0 <kfree>
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103780:	83 ec 0c             	sub    $0xc,%esp
80103783:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103789:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103790:	00 00 00 
    wakeup(&p->nwrite);
80103793:	50                   	push   %eax
80103794:	e8 c7 0b 00 00       	call   80104360 <wakeup>
80103799:	83 c4 10             	add    $0x10,%esp
8010379c:	eb 99                	jmp    80103737 <pipeclose+0x37>
8010379e:	66 90                	xchg   %ax,%ax

801037a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	57                   	push   %edi
801037a4:	56                   	push   %esi
801037a5:	53                   	push   %ebx
801037a6:	83 ec 28             	sub    $0x28,%esp
801037a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037ac:	53                   	push   %ebx
801037ad:	e8 4e 10 00 00       	call   80104800 <acquire>
  for(i = 0; i < n; i++){
801037b2:	8b 45 10             	mov    0x10(%ebp),%eax
801037b5:	83 c4 10             	add    $0x10,%esp
801037b8:	85 c0                	test   %eax,%eax
801037ba:	0f 8e c0 00 00 00    	jle    80103880 <pipewrite+0xe0>
801037c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037d2:	03 45 10             	add    0x10(%ebp),%eax
801037d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037de:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037e4:	89 ca                	mov    %ecx,%edx
801037e6:	05 00 02 00 00       	add    $0x200,%eax
801037eb:	39 c1                	cmp    %eax,%ecx
801037ed:	74 3f                	je     8010382e <pipewrite+0x8e>
801037ef:	eb 67                	jmp    80103858 <pipewrite+0xb8>
801037f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801037f8:	e8 43 03 00 00       	call   80103b40 <myproc>
801037fd:	8b 48 28             	mov    0x28(%eax),%ecx
80103800:	85 c9                	test   %ecx,%ecx
80103802:	75 34                	jne    80103838 <pipewrite+0x98>
      wakeup(&p->nread);
80103804:	83 ec 0c             	sub    $0xc,%esp
80103807:	57                   	push   %edi
80103808:	e8 53 0b 00 00       	call   80104360 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010380d:	58                   	pop    %eax
8010380e:	5a                   	pop    %edx
8010380f:	53                   	push   %ebx
80103810:	56                   	push   %esi
80103811:	e8 8a 0a 00 00       	call   801042a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103816:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010381c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103822:	83 c4 10             	add    $0x10,%esp
80103825:	05 00 02 00 00       	add    $0x200,%eax
8010382a:	39 c2                	cmp    %eax,%edx
8010382c:	75 2a                	jne    80103858 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010382e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103834:	85 c0                	test   %eax,%eax
80103836:	75 c0                	jne    801037f8 <pipewrite+0x58>
        release(&p->lock);
80103838:	83 ec 0c             	sub    $0xc,%esp
8010383b:	53                   	push   %ebx
8010383c:	e8 5f 0f 00 00       	call   801047a0 <release>
        return -1;
80103841:	83 c4 10             	add    $0x10,%esp
80103844:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103849:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010384c:	5b                   	pop    %ebx
8010384d:	5e                   	pop    %esi
8010384e:	5f                   	pop    %edi
8010384f:	5d                   	pop    %ebp
80103850:	c3                   	ret    
80103851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103858:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010385b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010385e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103864:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010386a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010386d:	83 c6 01             	add    $0x1,%esi
80103870:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103873:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103877:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010387a:	0f 85 58 ff ff ff    	jne    801037d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103889:	50                   	push   %eax
8010388a:	e8 d1 0a 00 00       	call   80104360 <wakeup>
  release(&p->lock);
8010388f:	89 1c 24             	mov    %ebx,(%esp)
80103892:	e8 09 0f 00 00       	call   801047a0 <release>
  return n;
80103897:	8b 45 10             	mov    0x10(%ebp),%eax
8010389a:	83 c4 10             	add    $0x10,%esp
8010389d:	eb aa                	jmp    80103849 <pipewrite+0xa9>
8010389f:	90                   	nop

801038a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 18             	sub    $0x18,%esp
801038a9:	8b 75 08             	mov    0x8(%ebp),%esi
801038ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038af:	56                   	push   %esi
801038b0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038b6:	e8 45 0f 00 00       	call   80104800 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038bb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038c1:	83 c4 10             	add    $0x10,%esp
801038c4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038ca:	74 2f                	je     801038fb <piperead+0x5b>
801038cc:	eb 37                	jmp    80103905 <piperead+0x65>
801038ce:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038d0:	e8 6b 02 00 00       	call   80103b40 <myproc>
801038d5:	8b 48 28             	mov    0x28(%eax),%ecx
801038d8:	85 c9                	test   %ecx,%ecx
801038da:	0f 85 80 00 00 00    	jne    80103960 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038e0:	83 ec 08             	sub    $0x8,%esp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
801038e5:	e8 b6 09 00 00       	call   801042a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ea:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801038f9:	75 0a                	jne    80103905 <piperead+0x65>
801038fb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103901:	85 c0                	test   %eax,%eax
80103903:	75 cb                	jne    801038d0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103905:	8b 55 10             	mov    0x10(%ebp),%edx
80103908:	31 db                	xor    %ebx,%ebx
8010390a:	85 d2                	test   %edx,%edx
8010390c:	7f 20                	jg     8010392e <piperead+0x8e>
8010390e:	eb 2c                	jmp    8010393c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103910:	8d 48 01             	lea    0x1(%eax),%ecx
80103913:	25 ff 01 00 00       	and    $0x1ff,%eax
80103918:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010391e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103923:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103926:	83 c3 01             	add    $0x1,%ebx
80103929:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010392c:	74 0e                	je     8010393c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010392e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103934:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010393a:	75 d4                	jne    80103910 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010393c:	83 ec 0c             	sub    $0xc,%esp
8010393f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103945:	50                   	push   %eax
80103946:	e8 15 0a 00 00       	call   80104360 <wakeup>
  release(&p->lock);
8010394b:	89 34 24             	mov    %esi,(%esp)
8010394e:	e8 4d 0e 00 00       	call   801047a0 <release>
  return i;
80103953:	83 c4 10             	add    $0x10,%esp
}
80103956:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103959:	89 d8                	mov    %ebx,%eax
8010395b:	5b                   	pop    %ebx
8010395c:	5e                   	pop    %esi
8010395d:	5f                   	pop    %edi
8010395e:	5d                   	pop    %ebp
8010395f:	c3                   	ret    
      release(&p->lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103963:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103968:	56                   	push   %esi
80103969:	e8 32 0e 00 00       	call   801047a0 <release>
      return -1;
8010396e:	83 c4 10             	add    $0x10,%esp
}
80103971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103974:	89 d8                	mov    %ebx,%eax
80103976:	5b                   	pop    %ebx
80103977:	5e                   	pop    %esi
80103978:	5f                   	pop    %edi
80103979:	5d                   	pop    %ebp
8010397a:	c3                   	ret    
8010397b:	66 90                	xchg   %ax,%ax
8010397d:	66 90                	xchg   %ax,%ax
8010397f:	90                   	nop

80103980 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103984:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
80103989:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010398c:	68 40 2d 11 80       	push   $0x80112d40
80103991:	e8 6a 0e 00 00       	call   80104800 <acquire>
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	eb 10                	jmp    801039ab <allocproc+0x2b>
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a0:	83 eb 80             	sub    $0xffffff80,%ebx
801039a3:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
801039a9:	74 75                	je     80103a20 <allocproc+0xa0>
    if(p->state == UNUSED)
801039ab:	8b 43 10             	mov    0x10(%ebx),%eax
801039ae:	85 c0                	test   %eax,%eax
801039b0:	75 ee                	jne    801039a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039b2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039b7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039ba:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039c1:	89 43 14             	mov    %eax,0x14(%ebx)
801039c4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039c7:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
801039cc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039d2:	e8 c9 0d 00 00       	call   801047a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039d7:	e8 f4 ed ff ff       	call   801027d0 <kalloc>
801039dc:	83 c4 10             	add    $0x10,%esp
801039df:	89 43 0c             	mov    %eax,0xc(%ebx)
801039e2:	85 c0                	test   %eax,%eax
801039e4:	74 53                	je     80103a39 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039ec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039f4:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
801039f7:	c7 40 14 30 5c 10 80 	movl   $0x80105c30,0x14(%eax)
  p->context = (struct context*)sp;
801039fe:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a01:	6a 14                	push   $0x14
80103a03:	6a 00                	push   $0x0
80103a05:	50                   	push   %eax
80103a06:	e8 b5 0e 00 00       	call   801048c0 <memset>
  p->context->eip = (uint)forkret;
80103a0b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103a0e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a11:	c7 40 10 50 3a 10 80 	movl   $0x80103a50,0x10(%eax)
}
80103a18:	89 d8                	mov    %ebx,%eax
80103a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a1d:	c9                   	leave  
80103a1e:	c3                   	ret    
80103a1f:	90                   	nop
  release(&ptable.lock);
80103a20:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a23:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a25:	68 40 2d 11 80       	push   $0x80112d40
80103a2a:	e8 71 0d 00 00       	call   801047a0 <release>
}
80103a2f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a31:	83 c4 10             	add    $0x10,%esp
}
80103a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a37:	c9                   	leave  
80103a38:	c3                   	ret    
    p->state = UNUSED;
80103a39:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103a40:	31 db                	xor    %ebx,%ebx
}
80103a42:	89 d8                	mov    %ebx,%eax
80103a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a47:	c9                   	leave  
80103a48:	c3                   	ret    
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a56:	68 40 2d 11 80       	push   $0x80112d40
80103a5b:	e8 40 0d 00 00       	call   801047a0 <release>

  if (first) {
80103a60:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	85 c0                	test   %eax,%eax
80103a6a:	75 04                	jne    80103a70 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a6c:	c9                   	leave  
80103a6d:	c3                   	ret    
80103a6e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a70:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a77:	00 00 00 
    iinit(ROOTDEV);
80103a7a:	83 ec 0c             	sub    $0xc,%esp
80103a7d:	6a 01                	push   $0x1
80103a7f:	e8 ec da ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103a84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a8b:	e8 f0 f3 ff ff       	call   80102e80 <initlog>
}
80103a90:	83 c4 10             	add    $0x10,%esp
80103a93:	c9                   	leave  
80103a94:	c3                   	ret    
80103a95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103aa0 <pinit>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103aa6:	68 40 7d 10 80       	push   $0x80107d40
80103aab:	68 40 2d 11 80       	push   $0x80112d40
80103ab0:	e8 7b 0b 00 00       	call   80104630 <initlock>
}
80103ab5:	83 c4 10             	add    $0x10,%esp
80103ab8:	c9                   	leave  
80103ab9:	c3                   	ret    
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ac0 <mycpu>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ac5:	9c                   	pushf  
80103ac6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ac7:	f6 c4 02             	test   $0x2,%ah
80103aca:	75 46                	jne    80103b12 <mycpu+0x52>
  apicid = lapicid();
80103acc:	e8 df ef ff ff       	call   80102ab0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ad1:	8b 35 a4 27 11 80    	mov    0x801127a4,%esi
80103ad7:	85 f6                	test   %esi,%esi
80103ad9:	7e 2a                	jle    80103b05 <mycpu+0x45>
80103adb:	31 d2                	xor    %edx,%edx
80103add:	eb 08                	jmp    80103ae7 <mycpu+0x27>
80103adf:	90                   	nop
80103ae0:	83 c2 01             	add    $0x1,%edx
80103ae3:	39 f2                	cmp    %esi,%edx
80103ae5:	74 1e                	je     80103b05 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ae7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103aed:	0f b6 99 c0 27 11 80 	movzbl -0x7feed840(%ecx),%ebx
80103af4:	39 c3                	cmp    %eax,%ebx
80103af6:	75 e8                	jne    80103ae0 <mycpu+0x20>
}
80103af8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103afb:	8d 81 c0 27 11 80    	lea    -0x7feed840(%ecx),%eax
}
80103b01:	5b                   	pop    %ebx
80103b02:	5e                   	pop    %esi
80103b03:	5d                   	pop    %ebp
80103b04:	c3                   	ret    
  panic("unknown apicid\n");
80103b05:	83 ec 0c             	sub    $0xc,%esp
80103b08:	68 47 7d 10 80       	push   $0x80107d47
80103b0d:	e8 6e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b12:	83 ec 0c             	sub    $0xc,%esp
80103b15:	68 24 7e 10 80       	push   $0x80107e24
80103b1a:	e8 61 c8 ff ff       	call   80100380 <panic>
80103b1f:	90                   	nop

80103b20 <cpuid>:
cpuid() {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b26:	e8 95 ff ff ff       	call   80103ac0 <mycpu>
}
80103b2b:	c9                   	leave  
  return mycpu()-cpus;
80103b2c:	2d c0 27 11 80       	sub    $0x801127c0,%eax
80103b31:	c1 f8 04             	sar    $0x4,%eax
80103b34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b3a:	c3                   	ret    
80103b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop

80103b40 <myproc>:
myproc(void) {
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b47:	e8 64 0b 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103b4c:	e8 6f ff ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103b51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b57:	e8 a4 0b 00 00       	call   80104700 <popcli>
}
80103b5c:	89 d8                	mov    %ebx,%eax
80103b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b61:	c9                   	leave  
80103b62:	c3                   	ret    
80103b63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b70 <userinit>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	53                   	push   %ebx
80103b74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b77:	e8 04 fe ff ff       	call   80103980 <allocproc>
80103b7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b7e:	a3 74 4d 11 80       	mov    %eax,0x80114d74
  if((p->pgdir = setupkvm()) == 0)
80103b83:	e8 18 39 00 00       	call   801074a0 <setupkvm>
80103b88:	89 43 08             	mov    %eax,0x8(%ebx)
80103b8b:	85 c0                	test   %eax,%eax
80103b8d:	0f 84 bd 00 00 00    	je     80103c50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b93:	83 ec 04             	sub    $0x4,%esp
80103b96:	68 2c 00 00 00       	push   $0x2c
80103b9b:	68 70 b4 10 80       	push   $0x8010b470
80103ba0:	50                   	push   %eax
80103ba1:	e8 3a 34 00 00       	call   80106fe0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ba6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ba9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103baf:	6a 4c                	push   $0x4c
80103bb1:	6a 00                	push   $0x0
80103bb3:	ff 73 1c             	push   0x1c(%ebx)
80103bb6:	e8 05 0d 00 00       	call   801048c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bbe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bc3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bc6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bcf:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bd6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bdd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103be1:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103be8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bec:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bf6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bf9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c00:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c0a:	8d 43 70             	lea    0x70(%ebx),%eax
80103c0d:	6a 10                	push   $0x10
80103c0f:	68 70 7d 10 80       	push   $0x80107d70
80103c14:	50                   	push   %eax
80103c15:	e8 66 0e 00 00       	call   80104a80 <safestrcpy>
  p->cwd = namei("/");
80103c1a:	c7 04 24 79 7d 10 80 	movl   $0x80107d79,(%esp)
80103c21:	e8 8a e4 ff ff       	call   801020b0 <namei>
80103c26:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c29:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c30:	e8 cb 0b 00 00       	call   80104800 <acquire>
  p->state = RUNNABLE;
80103c35:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c3c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c43:	e8 58 0b 00 00       	call   801047a0 <release>
}
80103c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c4b:	83 c4 10             	add    $0x10,%esp
80103c4e:	c9                   	leave  
80103c4f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c50:	83 ec 0c             	sub    $0xc,%esp
80103c53:	68 57 7d 10 80       	push   $0x80107d57
80103c58:	e8 23 c7 ff ff       	call   80100380 <panic>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi

80103c60 <growproc>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	53                   	push   %ebx
80103c65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c68:	e8 43 0a 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103c6d:	e8 4e fe ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103c72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c78:	e8 83 0a 00 00       	call   80104700 <popcli>
  sz = curproc->sz;
80103c7d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c7f:	85 f6                	test   %esi,%esi
80103c81:	7f 1d                	jg     80103ca0 <growproc+0x40>
  } else if(n < 0){
80103c83:	75 3b                	jne    80103cc0 <growproc+0x60>
  switchuvm(curproc);
80103c85:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c88:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c8a:	53                   	push   %ebx
80103c8b:	e8 40 32 00 00       	call   80106ed0 <switchuvm>
  return 0;
80103c90:	83 c4 10             	add    $0x10,%esp
80103c93:	31 c0                	xor    %eax,%eax
}
80103c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c98:	5b                   	pop    %ebx
80103c99:	5e                   	pop    %esi
80103c9a:	5d                   	pop    %ebp
80103c9b:	c3                   	ret    
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca0:	83 ec 04             	sub    $0x4,%esp
80103ca3:	01 c6                	add    %eax,%esi
80103ca5:	56                   	push   %esi
80103ca6:	50                   	push   %eax
80103ca7:	ff 73 08             	push   0x8(%ebx)
80103caa:	e8 d1 34 00 00       	call   80107180 <allocuvm>
80103caf:	83 c4 10             	add    $0x10,%esp
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	75 cf                	jne    80103c85 <growproc+0x25>
      return -1;
80103cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cbb:	eb d8                	jmp    80103c95 <growproc+0x35>
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc0:	83 ec 04             	sub    $0x4,%esp
80103cc3:	01 c6                	add    %eax,%esi
80103cc5:	56                   	push   %esi
80103cc6:	50                   	push   %eax
80103cc7:	ff 73 08             	push   0x8(%ebx)
80103cca:	e8 f1 36 00 00       	call   801073c0 <deallocuvm>
80103ccf:	83 c4 10             	add    $0x10,%esp
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	75 af                	jne    80103c85 <growproc+0x25>
80103cd6:	eb de                	jmp    80103cb6 <growproc+0x56>
80103cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop

80103ce0 <growhugeproc>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
80103ce5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ce8:	e8 c3 09 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103ced:	e8 ce fd ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103cf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf8:	e8 03 0a 00 00       	call   80104700 <popcli>
  sz = curproc->hugesz;
80103cfd:	8b 43 04             	mov    0x4(%ebx),%eax
  if(n > 0){
80103d00:	85 f6                	test   %esi,%esi
80103d02:	7f 24                	jg     80103d28 <growhugeproc+0x48>
  } else if(n < 0){
80103d04:	75 4a                	jne    80103d50 <growhugeproc+0x70>
  curproc->hugesz = sz - HUGE_VA_OFFSET;
80103d06:	2d 00 00 00 1e       	sub    $0x1e000000,%eax
  switchuvm(curproc);
80103d0b:	83 ec 0c             	sub    $0xc,%esp
  curproc->hugesz = sz - HUGE_VA_OFFSET;
80103d0e:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103d11:	53                   	push   %ebx
80103d12:	e8 b9 31 00 00       	call   80106ed0 <switchuvm>
  return 0;
80103d17:	83 c4 10             	add    $0x10,%esp
80103d1a:	31 c0                	xor    %eax,%eax
}
80103d1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d1f:	5b                   	pop    %ebx
80103d20:	5e                   	pop    %esi
80103d21:	5d                   	pop    %ebp
80103d22:	c3                   	ret    
80103d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d27:	90                   	nop
    if((sz = allochugeuvm(curproc->pgdir, sz + HUGE_VA_OFFSET, sz + n + HUGE_VA_OFFSET)) == 0)
80103d28:	83 ec 04             	sub    $0x4,%esp
80103d2b:	8d 94 30 00 00 00 1e 	lea    0x1e000000(%eax,%esi,1),%edx
80103d32:	05 00 00 00 1e       	add    $0x1e000000,%eax
80103d37:	52                   	push   %edx
80103d38:	50                   	push   %eax
80103d39:	ff 73 08             	push   0x8(%ebx)
80103d3c:	e8 6f 35 00 00       	call   801072b0 <allochugeuvm>
80103d41:	83 c4 10             	add    $0x10,%esp
80103d44:	85 c0                	test   %eax,%eax
80103d46:	75 be                	jne    80103d06 <growhugeproc+0x26>
      return -1;
80103d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d4d:	eb cd                	jmp    80103d1c <growhugeproc+0x3c>
80103d4f:	90                   	nop
    if((sz = deallochugeuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d50:	83 ec 04             	sub    $0x4,%esp
80103d53:	01 c6                	add    %eax,%esi
80103d55:	56                   	push   %esi
80103d56:	50                   	push   %eax
80103d57:	ff 73 08             	push   0x8(%ebx)
80103d5a:	e8 91 36 00 00       	call   801073f0 <deallochugeuvm>
80103d5f:	83 c4 10             	add    $0x10,%esp
80103d62:	85 c0                	test   %eax,%eax
80103d64:	75 a0                	jne    80103d06 <growhugeproc+0x26>
80103d66:	eb e0                	jmp    80103d48 <growhugeproc+0x68>
80103d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d6f:	90                   	nop

80103d70 <fork>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d79:	e8 32 09 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103d7e:	e8 3d fd ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103d83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d89:	e8 72 09 00 00       	call   80104700 <popcli>
  if((np = allocproc()) == 0){
80103d8e:	e8 ed fb ff ff       	call   80103980 <allocproc>
80103d93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d96:	85 c0                	test   %eax,%eax
80103d98:	0f 84 b7 00 00 00    	je     80103e55 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d9e:	83 ec 08             	sub    $0x8,%esp
80103da1:	ff 33                	push   (%ebx)
80103da3:	89 c7                	mov    %eax,%edi
80103da5:	ff 73 08             	push   0x8(%ebx)
80103da8:	e8 e3 37 00 00       	call   80107590 <copyuvm>
80103dad:	83 c4 10             	add    $0x10,%esp
80103db0:	89 47 08             	mov    %eax,0x8(%edi)
80103db3:	85 c0                	test   %eax,%eax
80103db5:	0f 84 a1 00 00 00    	je     80103e5c <fork+0xec>
  np->sz = curproc->sz;
80103dbb:	8b 03                	mov    (%ebx),%eax
80103dbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103dc0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103dc2:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103dc5:	89 c8                	mov    %ecx,%eax
80103dc7:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103dca:	b9 13 00 00 00       	mov    $0x13,%ecx
80103dcf:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103dd2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103dd4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103dd6:	8b 40 1c             	mov    0x1c(%eax),%eax
80103dd9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103de0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103de4:	85 c0                	test   %eax,%eax
80103de6:	74 13                	je     80103dfb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103de8:	83 ec 0c             	sub    $0xc,%esp
80103deb:	50                   	push   %eax
80103dec:	e8 bf d0 ff ff       	call   80100eb0 <filedup>
80103df1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103df4:	83 c4 10             	add    $0x10,%esp
80103df7:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dfb:	83 c6 01             	add    $0x1,%esi
80103dfe:	83 fe 10             	cmp    $0x10,%esi
80103e01:	75 dd                	jne    80103de0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e03:	83 ec 0c             	sub    $0xc,%esp
80103e06:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e09:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103e0c:	e8 4f d9 ff ff       	call   80101760 <idup>
80103e11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e17:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e1a:	8d 47 70             	lea    0x70(%edi),%eax
80103e1d:	6a 10                	push   $0x10
80103e1f:	53                   	push   %ebx
80103e20:	50                   	push   %eax
80103e21:	e8 5a 0c 00 00       	call   80104a80 <safestrcpy>
  pid = np->pid;
80103e26:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103e29:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e30:	e8 cb 09 00 00       	call   80104800 <acquire>
  np->state = RUNNABLE;
80103e35:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103e3c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e43:	e8 58 09 00 00       	call   801047a0 <release>
  return pid;
80103e48:	83 c4 10             	add    $0x10,%esp
}
80103e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e4e:	89 d8                	mov    %ebx,%eax
80103e50:	5b                   	pop    %ebx
80103e51:	5e                   	pop    %esi
80103e52:	5f                   	pop    %edi
80103e53:	5d                   	pop    %ebp
80103e54:	c3                   	ret    
    return -1;
80103e55:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e5a:	eb ef                	jmp    80103e4b <fork+0xdb>
    kfree(np->kstack);
80103e5c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e5f:	83 ec 0c             	sub    $0xc,%esp
80103e62:	ff 73 0c             	push   0xc(%ebx)
80103e65:	e8 66 e6 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103e6a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e71:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e74:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103e7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e80:	eb c9                	jmp    80103e4b <fork+0xdb>
80103e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e90 <scheduler>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e99:	e8 22 fc ff ff       	call   80103ac0 <mycpu>
  c->proc = 0;
80103e9e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ea5:	00 00 00 
  struct cpu *c = mycpu();
80103ea8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103eaa:	8d 78 04             	lea    0x4(%eax),%edi
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103eb0:	fb                   	sti    
    acquire(&ptable.lock);
80103eb1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
80103eb9:	68 40 2d 11 80       	push   $0x80112d40
80103ebe:	e8 3d 09 00 00       	call   80104800 <acquire>
80103ec3:	83 c4 10             	add    $0x10,%esp
80103ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ed0:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103ed4:	75 33                	jne    80103f09 <scheduler+0x79>
      switchuvm(p);
80103ed6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ed9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103edf:	53                   	push   %ebx
80103ee0:	e8 eb 2f 00 00       	call   80106ed0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ee5:	58                   	pop    %eax
80103ee6:	5a                   	pop    %edx
80103ee7:	ff 73 20             	push   0x20(%ebx)
80103eea:	57                   	push   %edi
      p->state = RUNNING;
80103eeb:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103ef2:	e8 e4 0b 00 00       	call   80104adb <swtch>
      switchkvm();
80103ef7:	e8 c4 2f 00 00       	call   80106ec0 <switchkvm>
      c->proc = 0;
80103efc:	83 c4 10             	add    $0x10,%esp
80103eff:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f06:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f09:	83 eb 80             	sub    $0xffffff80,%ebx
80103f0c:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80103f12:	75 bc                	jne    80103ed0 <scheduler+0x40>
    release(&ptable.lock);
80103f14:	83 ec 0c             	sub    $0xc,%esp
80103f17:	68 40 2d 11 80       	push   $0x80112d40
80103f1c:	e8 7f 08 00 00       	call   801047a0 <release>
    sti();
80103f21:	83 c4 10             	add    $0x10,%esp
80103f24:	eb 8a                	jmp    80103eb0 <scheduler+0x20>
80103f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi

80103f30 <sched>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
  pushcli();
80103f35:	e8 76 07 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103f3a:	e8 81 fb ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103f3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f45:	e8 b6 07 00 00       	call   80104700 <popcli>
  if(!holding(&ptable.lock))
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 40 2d 11 80       	push   $0x80112d40
80103f52:	e8 09 08 00 00       	call   80104760 <holding>
80103f57:	83 c4 10             	add    $0x10,%esp
80103f5a:	85 c0                	test   %eax,%eax
80103f5c:	74 4f                	je     80103fad <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f5e:	e8 5d fb ff ff       	call   80103ac0 <mycpu>
80103f63:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f6a:	75 68                	jne    80103fd4 <sched+0xa4>
  if(p->state == RUNNING)
80103f6c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f70:	74 55                	je     80103fc7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f72:	9c                   	pushf  
80103f73:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f74:	f6 c4 02             	test   $0x2,%ah
80103f77:	75 41                	jne    80103fba <sched+0x8a>
  intena = mycpu()->intena;
80103f79:	e8 42 fb ff ff       	call   80103ac0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f7e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103f81:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f87:	e8 34 fb ff ff       	call   80103ac0 <mycpu>
80103f8c:	83 ec 08             	sub    $0x8,%esp
80103f8f:	ff 70 04             	push   0x4(%eax)
80103f92:	53                   	push   %ebx
80103f93:	e8 43 0b 00 00       	call   80104adb <swtch>
  mycpu()->intena = intena;
80103f98:	e8 23 fb ff ff       	call   80103ac0 <mycpu>
}
80103f9d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fa0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fa9:	5b                   	pop    %ebx
80103faa:	5e                   	pop    %esi
80103fab:	5d                   	pop    %ebp
80103fac:	c3                   	ret    
    panic("sched ptable.lock");
80103fad:	83 ec 0c             	sub    $0xc,%esp
80103fb0:	68 7b 7d 10 80       	push   $0x80107d7b
80103fb5:	e8 c6 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 a7 7d 10 80       	push   $0x80107da7
80103fc2:	e8 b9 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80103fc7:	83 ec 0c             	sub    $0xc,%esp
80103fca:	68 99 7d 10 80       	push   $0x80107d99
80103fcf:	e8 ac c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103fd4:	83 ec 0c             	sub    $0xc,%esp
80103fd7:	68 8d 7d 10 80       	push   $0x80107d8d
80103fdc:	e8 9f c3 ff ff       	call   80100380 <panic>
80103fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fef:	90                   	nop

80103ff0 <exit>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
80103ff6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ff9:	e8 42 fb ff ff       	call   80103b40 <myproc>
  if(curproc == initproc)
80103ffe:	39 05 74 4d 11 80    	cmp    %eax,0x80114d74
80104004:	0f 84 fd 00 00 00    	je     80104107 <exit+0x117>
8010400a:	89 c3                	mov    %eax,%ebx
8010400c:	8d 70 2c             	lea    0x2c(%eax),%esi
8010400f:	8d 78 6c             	lea    0x6c(%eax),%edi
80104012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104018:	8b 06                	mov    (%esi),%eax
8010401a:	85 c0                	test   %eax,%eax
8010401c:	74 12                	je     80104030 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010401e:	83 ec 0c             	sub    $0xc,%esp
80104021:	50                   	push   %eax
80104022:	e8 d9 ce ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80104027:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010402d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104030:	83 c6 04             	add    $0x4,%esi
80104033:	39 f7                	cmp    %esi,%edi
80104035:	75 e1                	jne    80104018 <exit+0x28>
  begin_op();
80104037:	e8 e4 ee ff ff       	call   80102f20 <begin_op>
  iput(curproc->cwd);
8010403c:	83 ec 0c             	sub    $0xc,%esp
8010403f:	ff 73 6c             	push   0x6c(%ebx)
80104042:	e8 79 d8 ff ff       	call   801018c0 <iput>
  end_op();
80104047:	e8 44 ef ff ff       	call   80102f90 <end_op>
  curproc->cwd = 0;
8010404c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104053:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010405a:	e8 a1 07 00 00       	call   80104800 <acquire>
  wakeup1(curproc->parent);
8010405f:	8b 53 18             	mov    0x18(%ebx),%edx
80104062:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104065:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010406a:	eb 0e                	jmp    8010407a <exit+0x8a>
8010406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104070:	83 e8 80             	sub    $0xffffff80,%eax
80104073:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104078:	74 1c                	je     80104096 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010407a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010407e:	75 f0                	jne    80104070 <exit+0x80>
80104080:	3b 50 24             	cmp    0x24(%eax),%edx
80104083:	75 eb                	jne    80104070 <exit+0x80>
      p->state = RUNNABLE;
80104085:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010408c:	83 e8 80             	sub    $0xffffff80,%eax
8010408f:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104094:	75 e4                	jne    8010407a <exit+0x8a>
      p->parent = initproc;
80104096:	8b 0d 74 4d 11 80    	mov    0x80114d74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409c:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
801040a1:	eb 10                	jmp    801040b3 <exit+0xc3>
801040a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040a7:	90                   	nop
801040a8:	83 ea 80             	sub    $0xffffff80,%edx
801040ab:	81 fa 74 4d 11 80    	cmp    $0x80114d74,%edx
801040b1:	74 3b                	je     801040ee <exit+0xfe>
    if(p->parent == curproc){
801040b3:	39 5a 18             	cmp    %ebx,0x18(%edx)
801040b6:	75 f0                	jne    801040a8 <exit+0xb8>
      if(p->state == ZOMBIE)
801040b8:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
801040bc:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
801040bf:	75 e7                	jne    801040a8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c1:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801040c6:	eb 12                	jmp    801040da <exit+0xea>
801040c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop
801040d0:	83 e8 80             	sub    $0xffffff80,%eax
801040d3:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801040d8:	74 ce                	je     801040a8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801040da:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040de:	75 f0                	jne    801040d0 <exit+0xe0>
801040e0:	3b 48 24             	cmp    0x24(%eax),%ecx
801040e3:	75 eb                	jne    801040d0 <exit+0xe0>
      p->state = RUNNABLE;
801040e5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
801040ec:	eb e2                	jmp    801040d0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040ee:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
801040f5:	e8 36 fe ff ff       	call   80103f30 <sched>
  panic("zombie exit");
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	68 c8 7d 10 80       	push   $0x80107dc8
80104102:	e8 79 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104107:	83 ec 0c             	sub    $0xc,%esp
8010410a:	68 bb 7d 10 80       	push   $0x80107dbb
8010410f:	e8 6c c2 ff ff       	call   80100380 <panic>
80104114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop

80104120 <wait>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
  pushcli();
80104125:	e8 86 05 00 00       	call   801046b0 <pushcli>
  c = mycpu();
8010412a:	e8 91 f9 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
8010412f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104135:	e8 c6 05 00 00       	call   80104700 <popcli>
  acquire(&ptable.lock);
8010413a:	83 ec 0c             	sub    $0xc,%esp
8010413d:	68 40 2d 11 80       	push   $0x80112d40
80104142:	e8 b9 06 00 00       	call   80104800 <acquire>
80104147:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010414a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80104151:	eb 10                	jmp    80104163 <wait+0x43>
80104153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104157:	90                   	nop
80104158:	83 eb 80             	sub    $0xffffff80,%ebx
8010415b:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80104161:	74 1b                	je     8010417e <wait+0x5e>
      if(p->parent != curproc)
80104163:	39 73 18             	cmp    %esi,0x18(%ebx)
80104166:	75 f0                	jne    80104158 <wait+0x38>
      if(p->state == ZOMBIE){
80104168:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010416c:	74 62                	je     801041d0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010416e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104171:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104176:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
8010417c:	75 e5                	jne    80104163 <wait+0x43>
    if(!havekids || curproc->killed){
8010417e:	85 c0                	test   %eax,%eax
80104180:	0f 84 a0 00 00 00    	je     80104226 <wait+0x106>
80104186:	8b 46 28             	mov    0x28(%esi),%eax
80104189:	85 c0                	test   %eax,%eax
8010418b:	0f 85 95 00 00 00    	jne    80104226 <wait+0x106>
  pushcli();
80104191:	e8 1a 05 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80104196:	e8 25 f9 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
8010419b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a1:	e8 5a 05 00 00       	call   80104700 <popcli>
  if(p == 0)
801041a6:	85 db                	test   %ebx,%ebx
801041a8:	0f 84 8f 00 00 00    	je     8010423d <wait+0x11d>
  p->chan = chan;
801041ae:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
801041b1:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801041b8:	e8 73 fd ff ff       	call   80103f30 <sched>
  p->chan = 0;
801041bd:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801041c4:	eb 84                	jmp    8010414a <wait+0x2a>
801041c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801041d0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041d3:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801041d6:	ff 73 0c             	push   0xc(%ebx)
801041d9:	e8 f2 e2 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
801041de:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
801041e5:	5a                   	pop    %edx
801041e6:	ff 73 08             	push   0x8(%ebx)
801041e9:	e8 32 32 00 00       	call   80107420 <freevm>
        p->pid = 0;
801041ee:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041f5:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041fc:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104200:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104207:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010420e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104215:	e8 86 05 00 00       	call   801047a0 <release>
        return pid;
8010421a:	83 c4 10             	add    $0x10,%esp
}
8010421d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104220:	89 f0                	mov    %esi,%eax
80104222:	5b                   	pop    %ebx
80104223:	5e                   	pop    %esi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret    
      release(&ptable.lock);
80104226:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104229:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010422e:	68 40 2d 11 80       	push   $0x80112d40
80104233:	e8 68 05 00 00       	call   801047a0 <release>
      return -1;
80104238:	83 c4 10             	add    $0x10,%esp
8010423b:	eb e0                	jmp    8010421d <wait+0xfd>
    panic("sleep");
8010423d:	83 ec 0c             	sub    $0xc,%esp
80104240:	68 d4 7d 10 80       	push   $0x80107dd4
80104245:	e8 36 c1 ff ff       	call   80100380 <panic>
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <yield>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104257:	68 40 2d 11 80       	push   $0x80112d40
8010425c:	e8 9f 05 00 00       	call   80104800 <acquire>
  pushcli();
80104261:	e8 4a 04 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80104266:	e8 55 f8 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
8010426b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104271:	e8 8a 04 00 00       	call   80104700 <popcli>
  myproc()->state = RUNNABLE;
80104276:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010427d:	e8 ae fc ff ff       	call   80103f30 <sched>
  release(&ptable.lock);
80104282:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104289:	e8 12 05 00 00       	call   801047a0 <release>
}
8010428e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104291:	83 c4 10             	add    $0x10,%esp
80104294:	c9                   	leave  
80104295:	c3                   	ret    
80104296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010429d:	8d 76 00             	lea    0x0(%esi),%esi

801042a0 <sleep>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	53                   	push   %ebx
801042a6:	83 ec 0c             	sub    $0xc,%esp
801042a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042af:	e8 fc 03 00 00       	call   801046b0 <pushcli>
  c = mycpu();
801042b4:	e8 07 f8 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
801042b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042bf:	e8 3c 04 00 00       	call   80104700 <popcli>
  if(p == 0)
801042c4:	85 db                	test   %ebx,%ebx
801042c6:	0f 84 87 00 00 00    	je     80104353 <sleep+0xb3>
  if(lk == 0)
801042cc:	85 f6                	test   %esi,%esi
801042ce:	74 76                	je     80104346 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042d0:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
801042d6:	74 50                	je     80104328 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	68 40 2d 11 80       	push   $0x80112d40
801042e0:	e8 1b 05 00 00       	call   80104800 <acquire>
    release(lk);
801042e5:	89 34 24             	mov    %esi,(%esp)
801042e8:	e8 b3 04 00 00       	call   801047a0 <release>
  p->chan = chan;
801042ed:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042f0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042f7:	e8 34 fc ff ff       	call   80103f30 <sched>
  p->chan = 0;
801042fc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104303:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010430a:	e8 91 04 00 00       	call   801047a0 <release>
    acquire(lk);
8010430f:	89 75 08             	mov    %esi,0x8(%ebp)
80104312:	83 c4 10             	add    $0x10,%esp
}
80104315:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104318:	5b                   	pop    %ebx
80104319:	5e                   	pop    %esi
8010431a:	5f                   	pop    %edi
8010431b:	5d                   	pop    %ebp
    acquire(lk);
8010431c:	e9 df 04 00 00       	jmp    80104800 <acquire>
80104321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104328:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010432b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104332:	e8 f9 fb ff ff       	call   80103f30 <sched>
  p->chan = 0;
80104337:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010433e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104341:	5b                   	pop    %ebx
80104342:	5e                   	pop    %esi
80104343:	5f                   	pop    %edi
80104344:	5d                   	pop    %ebp
80104345:	c3                   	ret    
    panic("sleep without lk");
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	68 da 7d 10 80       	push   $0x80107dda
8010434e:	e8 2d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104353:	83 ec 0c             	sub    $0xc,%esp
80104356:	68 d4 7d 10 80       	push   $0x80107dd4
8010435b:	e8 20 c0 ff ff       	call   80100380 <panic>

80104360 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010436a:	68 40 2d 11 80       	push   $0x80112d40
8010436f:	e8 8c 04 00 00       	call   80104800 <acquire>
80104374:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104377:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010437c:	eb 0c                	jmp    8010438a <wakeup+0x2a>
8010437e:	66 90                	xchg   %ax,%ax
80104380:	83 e8 80             	sub    $0xffffff80,%eax
80104383:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104388:	74 1c                	je     801043a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010438a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010438e:	75 f0                	jne    80104380 <wakeup+0x20>
80104390:	3b 58 24             	cmp    0x24(%eax),%ebx
80104393:	75 eb                	jne    80104380 <wakeup+0x20>
      p->state = RUNNABLE;
80104395:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010439c:	83 e8 80             	sub    $0xffffff80,%eax
8010439f:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801043a4:	75 e4                	jne    8010438a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801043a6:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
801043ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b0:	c9                   	leave  
  release(&ptable.lock);
801043b1:	e9 ea 03 00 00       	jmp    801047a0 <release>
801043b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043bd:	8d 76 00             	lea    0x0(%esi),%esi

801043c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ca:	68 40 2d 11 80       	push   $0x80112d40
801043cf:	e8 2c 04 00 00       	call   80104800 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801043dc:	eb 0c                	jmp    801043ea <kill+0x2a>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	83 e8 80             	sub    $0xffffff80,%eax
801043e3:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801043e8:	74 36                	je     80104420 <kill+0x60>
    if(p->pid == pid){
801043ea:	39 58 14             	cmp    %ebx,0x14(%eax)
801043ed:	75 f1                	jne    801043e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043ef:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801043f3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801043fa:	75 07                	jne    80104403 <kill+0x43>
        p->state = RUNNABLE;
801043fc:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	68 40 2d 11 80       	push   $0x80112d40
8010440b:	e8 90 03 00 00       	call   801047a0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104413:	83 c4 10             	add    $0x10,%esp
80104416:	31 c0                	xor    %eax,%eax
}
80104418:	c9                   	leave  
80104419:	c3                   	ret    
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 40 2d 11 80       	push   $0x80112d40
80104428:	e8 73 03 00 00       	call   801047a0 <release>
}
8010442d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104430:	83 c4 10             	add    $0x10,%esp
80104433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104438:	c9                   	leave  
80104439:	c3                   	ret    
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
80104445:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104448:	53                   	push   %ebx
80104449:	bb e4 2d 11 80       	mov    $0x80112de4,%ebx
8010444e:	83 ec 3c             	sub    $0x3c,%esp
80104451:	eb 24                	jmp    80104477 <procdump+0x37>
80104453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104457:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	68 7b 81 10 80       	push   $0x8010817b
80104460:	e8 3b c2 ff ff       	call   801006a0 <cprintf>
80104465:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104468:	83 eb 80             	sub    $0xffffff80,%ebx
8010446b:	81 fb e4 4d 11 80    	cmp    $0x80114de4,%ebx
80104471:	0f 84 81 00 00 00    	je     801044f8 <procdump+0xb8>
    if(p->state == UNUSED)
80104477:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010447a:	85 c0                	test   %eax,%eax
8010447c:	74 ea                	je     80104468 <procdump+0x28>
      state = "???";
8010447e:	ba eb 7d 10 80       	mov    $0x80107deb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104483:	83 f8 05             	cmp    $0x5,%eax
80104486:	77 11                	ja     80104499 <procdump+0x59>
80104488:	8b 14 85 4c 7e 10 80 	mov    -0x7fef81b4(,%eax,4),%edx
      state = "???";
8010448f:	b8 eb 7d 10 80       	mov    $0x80107deb,%eax
80104494:	85 d2                	test   %edx,%edx
80104496:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104499:	53                   	push   %ebx
8010449a:	52                   	push   %edx
8010449b:	ff 73 a4             	push   -0x5c(%ebx)
8010449e:	68 ef 7d 10 80       	push   $0x80107def
801044a3:	e8 f8 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801044a8:	83 c4 10             	add    $0x10,%esp
801044ab:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044af:	75 a7                	jne    80104458 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044b1:	83 ec 08             	sub    $0x8,%esp
801044b4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044b7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044ba:	50                   	push   %eax
801044bb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044be:	8b 40 0c             	mov    0xc(%eax),%eax
801044c1:	83 c0 08             	add    $0x8,%eax
801044c4:	50                   	push   %eax
801044c5:	e8 86 01 00 00       	call   80104650 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044ca:	83 c4 10             	add    $0x10,%esp
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
801044d0:	8b 17                	mov    (%edi),%edx
801044d2:	85 d2                	test   %edx,%edx
801044d4:	74 82                	je     80104458 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044dc:	52                   	push   %edx
801044dd:	68 41 78 10 80       	push   $0x80107841
801044e2:	e8 b9 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044e7:	83 c4 10             	add    $0x10,%esp
801044ea:	39 fe                	cmp    %edi,%esi
801044ec:	75 e2                	jne    801044d0 <procdump+0x90>
801044ee:	e9 65 ff ff ff       	jmp    80104458 <procdump+0x18>
801044f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f7:	90                   	nop
  }
}
801044f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044fb:	5b                   	pop    %ebx
801044fc:	5e                   	pop    %esi
801044fd:	5f                   	pop    %edi
801044fe:	5d                   	pop    %ebp
801044ff:	c3                   	ret    

80104500 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
80104504:	83 ec 0c             	sub    $0xc,%esp
80104507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010450a:	68 64 7e 10 80       	push   $0x80107e64
8010450f:	8d 43 04             	lea    0x4(%ebx),%eax
80104512:	50                   	push   %eax
80104513:	e8 18 01 00 00       	call   80104630 <initlock>
  lk->name = name;
80104518:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010451b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104521:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104524:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010452b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010452e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104531:	c9                   	leave  
80104532:	c3                   	ret    
80104533:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	56                   	push   %esi
80104544:	53                   	push   %ebx
80104545:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104548:	8d 73 04             	lea    0x4(%ebx),%esi
8010454b:	83 ec 0c             	sub    $0xc,%esp
8010454e:	56                   	push   %esi
8010454f:	e8 ac 02 00 00       	call   80104800 <acquire>
  while (lk->locked) {
80104554:	8b 13                	mov    (%ebx),%edx
80104556:	83 c4 10             	add    $0x10,%esp
80104559:	85 d2                	test   %edx,%edx
8010455b:	74 16                	je     80104573 <acquiresleep+0x33>
8010455d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104560:	83 ec 08             	sub    $0x8,%esp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	e8 36 fd ff ff       	call   801042a0 <sleep>
  while (lk->locked) {
8010456a:	8b 03                	mov    (%ebx),%eax
8010456c:	83 c4 10             	add    $0x10,%esp
8010456f:	85 c0                	test   %eax,%eax
80104571:	75 ed                	jne    80104560 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104573:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104579:	e8 c2 f5 ff ff       	call   80103b40 <myproc>
8010457e:	8b 40 14             	mov    0x14(%eax),%eax
80104581:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104584:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104587:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010458a:	5b                   	pop    %ebx
8010458b:	5e                   	pop    %esi
8010458c:	5d                   	pop    %ebp
  release(&lk->lk);
8010458d:	e9 0e 02 00 00       	jmp    801047a0 <release>
80104592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045a8:	8d 73 04             	lea    0x4(%ebx),%esi
801045ab:	83 ec 0c             	sub    $0xc,%esp
801045ae:	56                   	push   %esi
801045af:	e8 4c 02 00 00       	call   80104800 <acquire>
  lk->locked = 0;
801045b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045c1:	89 1c 24             	mov    %ebx,(%esp)
801045c4:	e8 97 fd ff ff       	call   80104360 <wakeup>
  release(&lk->lk);
801045c9:	89 75 08             	mov    %esi,0x8(%ebp)
801045cc:	83 c4 10             	add    $0x10,%esp
}
801045cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045d2:	5b                   	pop    %ebx
801045d3:	5e                   	pop    %esi
801045d4:	5d                   	pop    %ebp
  release(&lk->lk);
801045d5:	e9 c6 01 00 00       	jmp    801047a0 <release>
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	31 ff                	xor    %edi,%edi
801045e6:	56                   	push   %esi
801045e7:	53                   	push   %ebx
801045e8:	83 ec 18             	sub    $0x18,%esp
801045eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045ee:	8d 73 04             	lea    0x4(%ebx),%esi
801045f1:	56                   	push   %esi
801045f2:	e8 09 02 00 00       	call   80104800 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045f7:	8b 03                	mov    (%ebx),%eax
801045f9:	83 c4 10             	add    $0x10,%esp
801045fc:	85 c0                	test   %eax,%eax
801045fe:	75 18                	jne    80104618 <holdingsleep+0x38>
  release(&lk->lk);
80104600:	83 ec 0c             	sub    $0xc,%esp
80104603:	56                   	push   %esi
80104604:	e8 97 01 00 00       	call   801047a0 <release>
  return r;
}
80104609:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010460c:	89 f8                	mov    %edi,%eax
8010460e:	5b                   	pop    %ebx
8010460f:	5e                   	pop    %esi
80104610:	5f                   	pop    %edi
80104611:	5d                   	pop    %ebp
80104612:	c3                   	ret    
80104613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104617:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104618:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010461b:	e8 20 f5 ff ff       	call   80103b40 <myproc>
80104620:	39 58 14             	cmp    %ebx,0x14(%eax)
80104623:	0f 94 c0             	sete   %al
80104626:	0f b6 c0             	movzbl %al,%eax
80104629:	89 c7                	mov    %eax,%edi
8010462b:	eb d3                	jmp    80104600 <holdingsleep+0x20>
8010462d:	66 90                	xchg   %ax,%ax
8010462f:	90                   	nop

80104630 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104636:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104639:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010463f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104642:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104649:	5d                   	pop    %ebp
8010464a:	c3                   	ret    
8010464b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop

80104650 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104650:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104651:	31 d2                	xor    %edx,%edx
{
80104653:	89 e5                	mov    %esp,%ebp
80104655:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104656:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104659:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010465c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010465f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104660:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104666:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010466c:	77 1a                	ja     80104688 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010466e:	8b 58 04             	mov    0x4(%eax),%ebx
80104671:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104674:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104677:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104679:	83 fa 0a             	cmp    $0xa,%edx
8010467c:	75 e2                	jne    80104660 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010467e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104681:	c9                   	leave  
80104682:	c3                   	ret    
80104683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104687:	90                   	nop
  for(; i < 10; i++)
80104688:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010468b:	8d 51 28             	lea    0x28(%ecx),%edx
8010468e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104696:	83 c0 04             	add    $0x4,%eax
80104699:	39 d0                	cmp    %edx,%eax
8010469b:	75 f3                	jne    80104690 <getcallerpcs+0x40>
}
8010469d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a0:	c9                   	leave  
801046a1:	c3                   	ret    
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 04             	sub    $0x4,%esp
801046b7:	9c                   	pushf  
801046b8:	5b                   	pop    %ebx
  asm volatile("cli");
801046b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801046ba:	e8 01 f4 ff ff       	call   80103ac0 <mycpu>
801046bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046c5:	85 c0                	test   %eax,%eax
801046c7:	74 17                	je     801046e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046c9:	e8 f2 f3 ff ff       	call   80103ac0 <mycpu>
801046ce:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d8:	c9                   	leave  
801046d9:	c3                   	ret    
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046e0:	e8 db f3 ff ff       	call   80103ac0 <mycpu>
801046e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046f1:	eb d6                	jmp    801046c9 <pushcli+0x19>
801046f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104700 <popcli>:

void
popcli(void)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104706:	9c                   	pushf  
80104707:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104708:	f6 c4 02             	test   $0x2,%ah
8010470b:	75 35                	jne    80104742 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010470d:	e8 ae f3 ff ff       	call   80103ac0 <mycpu>
80104712:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104719:	78 34                	js     8010474f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010471b:	e8 a0 f3 ff ff       	call   80103ac0 <mycpu>
80104720:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104726:	85 d2                	test   %edx,%edx
80104728:	74 06                	je     80104730 <popcli+0x30>
    sti();
}
8010472a:	c9                   	leave  
8010472b:	c3                   	ret    
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104730:	e8 8b f3 ff ff       	call   80103ac0 <mycpu>
80104735:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010473b:	85 c0                	test   %eax,%eax
8010473d:	74 eb                	je     8010472a <popcli+0x2a>
  asm volatile("sti");
8010473f:	fb                   	sti    
}
80104740:	c9                   	leave  
80104741:	c3                   	ret    
    panic("popcli - interruptible");
80104742:	83 ec 0c             	sub    $0xc,%esp
80104745:	68 6f 7e 10 80       	push   $0x80107e6f
8010474a:	e8 31 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010474f:	83 ec 0c             	sub    $0xc,%esp
80104752:	68 86 7e 10 80       	push   $0x80107e86
80104757:	e8 24 bc ff ff       	call   80100380 <panic>
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <holding>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
80104765:	8b 75 08             	mov    0x8(%ebp),%esi
80104768:	31 db                	xor    %ebx,%ebx
  pushcli();
8010476a:	e8 41 ff ff ff       	call   801046b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010476f:	8b 06                	mov    (%esi),%eax
80104771:	85 c0                	test   %eax,%eax
80104773:	75 0b                	jne    80104780 <holding+0x20>
  popcli();
80104775:	e8 86 ff ff ff       	call   80104700 <popcli>
}
8010477a:	89 d8                	mov    %ebx,%eax
8010477c:	5b                   	pop    %ebx
8010477d:	5e                   	pop    %esi
8010477e:	5d                   	pop    %ebp
8010477f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104780:	8b 5e 08             	mov    0x8(%esi),%ebx
80104783:	e8 38 f3 ff ff       	call   80103ac0 <mycpu>
80104788:	39 c3                	cmp    %eax,%ebx
8010478a:	0f 94 c3             	sete   %bl
  popcli();
8010478d:	e8 6e ff ff ff       	call   80104700 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104792:	0f b6 db             	movzbl %bl,%ebx
}
80104795:	89 d8                	mov    %ebx,%eax
80104797:	5b                   	pop    %ebx
80104798:	5e                   	pop    %esi
80104799:	5d                   	pop    %ebp
8010479a:	c3                   	ret    
8010479b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop

801047a0 <release>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047a8:	e8 03 ff ff ff       	call   801046b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047ad:	8b 03                	mov    (%ebx),%eax
801047af:	85 c0                	test   %eax,%eax
801047b1:	75 15                	jne    801047c8 <release+0x28>
  popcli();
801047b3:	e8 48 ff ff ff       	call   80104700 <popcli>
    panic("release");
801047b8:	83 ec 0c             	sub    $0xc,%esp
801047bb:	68 8d 7e 10 80       	push   $0x80107e8d
801047c0:	e8 bb bb ff ff       	call   80100380 <panic>
801047c5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047c8:	8b 73 08             	mov    0x8(%ebx),%esi
801047cb:	e8 f0 f2 ff ff       	call   80103ac0 <mycpu>
801047d0:	39 c6                	cmp    %eax,%esi
801047d2:	75 df                	jne    801047b3 <release+0x13>
  popcli();
801047d4:	e8 27 ff ff ff       	call   80104700 <popcli>
  lk->pcs[0] = 0;
801047d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047e0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047e7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047f5:	5b                   	pop    %ebx
801047f6:	5e                   	pop    %esi
801047f7:	5d                   	pop    %ebp
  popcli();
801047f8:	e9 03 ff ff ff       	jmp    80104700 <popcli>
801047fd:	8d 76 00             	lea    0x0(%esi),%esi

80104800 <acquire>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104807:	e8 a4 fe ff ff       	call   801046b0 <pushcli>
  if(holding(lk))
8010480c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010480f:	e8 9c fe ff ff       	call   801046b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104814:	8b 03                	mov    (%ebx),%eax
80104816:	85 c0                	test   %eax,%eax
80104818:	75 7e                	jne    80104898 <acquire+0x98>
  popcli();
8010481a:	e8 e1 fe ff ff       	call   80104700 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010481f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104828:	8b 55 08             	mov    0x8(%ebp),%edx
8010482b:	89 c8                	mov    %ecx,%eax
8010482d:	f0 87 02             	lock xchg %eax,(%edx)
80104830:	85 c0                	test   %eax,%eax
80104832:	75 f4                	jne    80104828 <acquire+0x28>
  __sync_synchronize();
80104834:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104839:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010483c:	e8 7f f2 ff ff       	call   80103ac0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104841:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104844:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104846:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104849:	31 c0                	xor    %eax,%eax
8010484b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104850:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104856:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010485c:	77 1a                	ja     80104878 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010485e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104861:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104865:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104868:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010486a:	83 f8 0a             	cmp    $0xa,%eax
8010486d:	75 e1                	jne    80104850 <acquire+0x50>
}
8010486f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104872:	c9                   	leave  
80104873:	c3                   	ret    
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104878:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010487c:	8d 51 34             	lea    0x34(%ecx),%edx
8010487f:	90                   	nop
    pcs[i] = 0;
80104880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104886:	83 c0 04             	add    $0x4,%eax
80104889:	39 c2                	cmp    %eax,%edx
8010488b:	75 f3                	jne    80104880 <acquire+0x80>
}
8010488d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104890:	c9                   	leave  
80104891:	c3                   	ret    
80104892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104898:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010489b:	e8 20 f2 ff ff       	call   80103ac0 <mycpu>
801048a0:	39 c3                	cmp    %eax,%ebx
801048a2:	0f 85 72 ff ff ff    	jne    8010481a <acquire+0x1a>
  popcli();
801048a8:	e8 53 fe ff ff       	call   80104700 <popcli>
    panic("acquire");
801048ad:	83 ec 0c             	sub    $0xc,%esp
801048b0:	68 95 7e 10 80       	push   $0x80107e95
801048b5:	e8 c6 ba ff ff       	call   80100380 <panic>
801048ba:	66 90                	xchg   %ax,%ax
801048bc:	66 90                	xchg   %ax,%ax
801048be:	66 90                	xchg   %ax,%ax

801048c0 <memset>:
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	8b 55 08             	mov    0x8(%ebp),%edx
801048c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ca:	53                   	push   %ebx
801048cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ce:	89 d7                	mov    %edx,%edi
801048d0:	09 cf                	or     %ecx,%edi
801048d2:	83 e7 03             	and    $0x3,%edi
801048d5:	75 29                	jne    80104900 <memset+0x40>
801048d7:	0f b6 f8             	movzbl %al,%edi
801048da:	c1 e0 18             	shl    $0x18,%eax
801048dd:	89 fb                	mov    %edi,%ebx
801048df:	c1 e9 02             	shr    $0x2,%ecx
801048e2:	c1 e3 10             	shl    $0x10,%ebx
801048e5:	09 d8                	or     %ebx,%eax
801048e7:	09 f8                	or     %edi,%eax
801048e9:	c1 e7 08             	shl    $0x8,%edi
801048ec:	09 f8                	or     %edi,%eax
801048ee:	89 d7                	mov    %edx,%edi
801048f0:	fc                   	cld    
801048f1:	f3 ab                	rep stos %eax,%es:(%edi)
801048f3:	5b                   	pop    %ebx
801048f4:	89 d0                	mov    %edx,%eax
801048f6:	5f                   	pop    %edi
801048f7:	5d                   	pop    %ebp
801048f8:	c3                   	ret    
801048f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104900:	89 d7                	mov    %edx,%edi
80104902:	fc                   	cld    
80104903:	f3 aa                	rep stos %al,%es:(%edi)
80104905:	5b                   	pop    %ebx
80104906:	89 d0                	mov    %edx,%eax
80104908:	5f                   	pop    %edi
80104909:	5d                   	pop    %ebp
8010490a:	c3                   	ret    
8010490b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010490f:	90                   	nop

80104910 <memcmp>:
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	56                   	push   %esi
80104914:	8b 75 10             	mov    0x10(%ebp),%esi
80104917:	8b 55 08             	mov    0x8(%ebp),%edx
8010491a:	53                   	push   %ebx
8010491b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010491e:	85 f6                	test   %esi,%esi
80104920:	74 2e                	je     80104950 <memcmp+0x40>
80104922:	01 c6                	add    %eax,%esi
80104924:	eb 14                	jmp    8010493a <memcmp+0x2a>
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
80104930:	83 c0 01             	add    $0x1,%eax
80104933:	83 c2 01             	add    $0x1,%edx
80104936:	39 f0                	cmp    %esi,%eax
80104938:	74 16                	je     80104950 <memcmp+0x40>
8010493a:	0f b6 0a             	movzbl (%edx),%ecx
8010493d:	0f b6 18             	movzbl (%eax),%ebx
80104940:	38 d9                	cmp    %bl,%cl
80104942:	74 ec                	je     80104930 <memcmp+0x20>
80104944:	0f b6 c1             	movzbl %cl,%eax
80104947:	29 d8                	sub    %ebx,%eax
80104949:	5b                   	pop    %ebx
8010494a:	5e                   	pop    %esi
8010494b:	5d                   	pop    %ebp
8010494c:	c3                   	ret    
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
80104950:	5b                   	pop    %ebx
80104951:	31 c0                	xor    %eax,%eax
80104953:	5e                   	pop    %esi
80104954:	5d                   	pop    %ebp
80104955:	c3                   	ret    
80104956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495d:	8d 76 00             	lea    0x0(%esi),%esi

80104960 <memmove>:
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	8b 55 08             	mov    0x8(%ebp),%edx
80104967:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010496a:	56                   	push   %esi
8010496b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010496e:	39 d6                	cmp    %edx,%esi
80104970:	73 26                	jae    80104998 <memmove+0x38>
80104972:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104975:	39 fa                	cmp    %edi,%edx
80104977:	73 1f                	jae    80104998 <memmove+0x38>
80104979:	8d 41 ff             	lea    -0x1(%ecx),%eax
8010497c:	85 c9                	test   %ecx,%ecx
8010497e:	74 0c                	je     8010498c <memmove+0x2c>
80104980:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104984:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104987:	83 e8 01             	sub    $0x1,%eax
8010498a:	73 f4                	jae    80104980 <memmove+0x20>
8010498c:	5e                   	pop    %esi
8010498d:	89 d0                	mov    %edx,%eax
8010498f:	5f                   	pop    %edi
80104990:	5d                   	pop    %ebp
80104991:	c3                   	ret    
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104998:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010499b:	89 d7                	mov    %edx,%edi
8010499d:	85 c9                	test   %ecx,%ecx
8010499f:	74 eb                	je     8010498c <memmove+0x2c>
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
801049a9:	39 c6                	cmp    %eax,%esi
801049ab:	75 fb                	jne    801049a8 <memmove+0x48>
801049ad:	5e                   	pop    %esi
801049ae:	89 d0                	mov    %edx,%eax
801049b0:	5f                   	pop    %edi
801049b1:	5d                   	pop    %ebp
801049b2:	c3                   	ret    
801049b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <memcpy>:
801049c0:	eb 9e                	jmp    80104960 <memmove>
801049c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049d0 <strncmp>:
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	8b 75 10             	mov    0x10(%ebp),%esi
801049d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049da:	53                   	push   %ebx
801049db:	8b 55 0c             	mov    0xc(%ebp),%edx
801049de:	85 f6                	test   %esi,%esi
801049e0:	74 2e                	je     80104a10 <strncmp+0x40>
801049e2:	01 d6                	add    %edx,%esi
801049e4:	eb 18                	jmp    801049fe <strncmp+0x2e>
801049e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
801049f0:	38 d8                	cmp    %bl,%al
801049f2:	75 14                	jne    80104a08 <strncmp+0x38>
801049f4:	83 c2 01             	add    $0x1,%edx
801049f7:	83 c1 01             	add    $0x1,%ecx
801049fa:	39 f2                	cmp    %esi,%edx
801049fc:	74 12                	je     80104a10 <strncmp+0x40>
801049fe:	0f b6 01             	movzbl (%ecx),%eax
80104a01:	0f b6 1a             	movzbl (%edx),%ebx
80104a04:	84 c0                	test   %al,%al
80104a06:	75 e8                	jne    801049f0 <strncmp+0x20>
80104a08:	29 d8                	sub    %ebx,%eax
80104a0a:	5b                   	pop    %ebx
80104a0b:	5e                   	pop    %esi
80104a0c:	5d                   	pop    %ebp
80104a0d:	c3                   	ret    
80104a0e:	66 90                	xchg   %ax,%ax
80104a10:	5b                   	pop    %ebx
80104a11:	31 c0                	xor    %eax,%eax
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
80104a15:	c3                   	ret    
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi

80104a20 <strncpy>:
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	8b 75 08             	mov    0x8(%ebp),%esi
80104a28:	53                   	push   %ebx
80104a29:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a2c:	89 f0                	mov    %esi,%eax
80104a2e:	eb 15                	jmp    80104a45 <strncpy+0x25>
80104a30:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a34:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a37:	83 c0 01             	add    $0x1,%eax
80104a3a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a3e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a41:	84 d2                	test   %dl,%dl
80104a43:	74 09                	je     80104a4e <strncpy+0x2e>
80104a45:	89 cb                	mov    %ecx,%ebx
80104a47:	83 e9 01             	sub    $0x1,%ecx
80104a4a:	85 db                	test   %ebx,%ebx
80104a4c:	7f e2                	jg     80104a30 <strncpy+0x10>
80104a4e:	89 c2                	mov    %eax,%edx
80104a50:	85 c9                	test   %ecx,%ecx
80104a52:	7e 17                	jle    80104a6b <strncpy+0x4b>
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a58:	83 c2 01             	add    $0x1,%edx
80104a5b:	89 c1                	mov    %eax,%ecx
80104a5d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80104a61:	29 d1                	sub    %edx,%ecx
80104a63:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a67:	85 c9                	test   %ecx,%ecx
80104a69:	7f ed                	jg     80104a58 <strncpy+0x38>
80104a6b:	5b                   	pop    %ebx
80104a6c:	89 f0                	mov    %esi,%eax
80104a6e:	5e                   	pop    %esi
80104a6f:	5f                   	pop    %edi
80104a70:	5d                   	pop    %ebp
80104a71:	c3                   	ret    
80104a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a80 <safestrcpy>:
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	8b 55 10             	mov    0x10(%ebp),%edx
80104a87:	8b 75 08             	mov    0x8(%ebp),%esi
80104a8a:	53                   	push   %ebx
80104a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8e:	85 d2                	test   %edx,%edx
80104a90:	7e 25                	jle    80104ab7 <safestrcpy+0x37>
80104a92:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a96:	89 f2                	mov    %esi,%edx
80104a98:	eb 16                	jmp    80104ab0 <safestrcpy+0x30>
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa0:	0f b6 08             	movzbl (%eax),%ecx
80104aa3:	83 c0 01             	add    $0x1,%eax
80104aa6:	83 c2 01             	add    $0x1,%edx
80104aa9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104aac:	84 c9                	test   %cl,%cl
80104aae:	74 04                	je     80104ab4 <safestrcpy+0x34>
80104ab0:	39 d8                	cmp    %ebx,%eax
80104ab2:	75 ec                	jne    80104aa0 <safestrcpy+0x20>
80104ab4:	c6 02 00             	movb   $0x0,(%edx)
80104ab7:	89 f0                	mov    %esi,%eax
80104ab9:	5b                   	pop    %ebx
80104aba:	5e                   	pop    %esi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi

80104ac0 <strlen>:
80104ac0:	55                   	push   %ebp
80104ac1:	31 c0                	xor    %eax,%eax
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ac8:	80 3a 00             	cmpb   $0x0,(%edx)
80104acb:	74 0c                	je     80104ad9 <strlen+0x19>
80104acd:	8d 76 00             	lea    0x0(%esi),%esi
80104ad0:	83 c0 01             	add    $0x1,%eax
80104ad3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ad7:	75 f7                	jne    80104ad0 <strlen+0x10>
80104ad9:	5d                   	pop    %ebp
80104ada:	c3                   	ret    

80104adb <swtch>:
80104adb:	8b 44 24 04          	mov    0x4(%esp),%eax
80104adf:	8b 54 24 08          	mov    0x8(%esp),%edx
80104ae3:	55                   	push   %ebp
80104ae4:	53                   	push   %ebx
80104ae5:	56                   	push   %esi
80104ae6:	57                   	push   %edi
80104ae7:	89 20                	mov    %esp,(%eax)
80104ae9:	89 d4                	mov    %edx,%esp
80104aeb:	5f                   	pop    %edi
80104aec:	5e                   	pop    %esi
80104aed:	5b                   	pop    %ebx
80104aee:	5d                   	pop    %ebp
80104aef:	c3                   	ret    

80104af0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
80104af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104afa:	e8 41 f0 ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aff:	8b 00                	mov    (%eax),%eax
80104b01:	39 d8                	cmp    %ebx,%eax
80104b03:	76 1b                	jbe    80104b20 <fetchint+0x30>
80104b05:	8d 53 04             	lea    0x4(%ebx),%edx
80104b08:	39 d0                	cmp    %edx,%eax
80104b0a:	72 14                	jb     80104b20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b0f:	8b 13                	mov    (%ebx),%edx
80104b11:	89 10                	mov    %edx,(%eax)
  return 0;
80104b13:	31 c0                	xor    %eax,%eax
}
80104b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b18:	c9                   	leave  
80104b19:	c3                   	ret    
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b25:	eb ee                	jmp    80104b15 <fetchint+0x25>
80104b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
80104b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b3a:	e8 01 f0 ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz)
80104b3f:	39 18                	cmp    %ebx,(%eax)
80104b41:	76 2d                	jbe    80104b70 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b43:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b46:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b48:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b4a:	39 d3                	cmp    %edx,%ebx
80104b4c:	73 22                	jae    80104b70 <fetchstr+0x40>
80104b4e:	89 d8                	mov    %ebx,%eax
80104b50:	eb 0d                	jmp    80104b5f <fetchstr+0x2f>
80104b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b58:	83 c0 01             	add    $0x1,%eax
80104b5b:	39 c2                	cmp    %eax,%edx
80104b5d:	76 11                	jbe    80104b70 <fetchstr+0x40>
    if(*s == 0)
80104b5f:	80 38 00             	cmpb   $0x0,(%eax)
80104b62:	75 f4                	jne    80104b58 <fetchstr+0x28>
      return s - *pp;
80104b64:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b69:	c9                   	leave  
80104b6a:	c3                   	ret    
80104b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b6f:	90                   	nop
80104b70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b78:	c9                   	leave  
80104b79:	c3                   	ret    
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b85:	e8 b6 ef ff ff       	call   80103b40 <myproc>
80104b8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b8d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b90:	8b 40 44             	mov    0x44(%eax),%eax
80104b93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b96:	e8 a5 ef ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b9e:	8b 00                	mov    (%eax),%eax
80104ba0:	39 c6                	cmp    %eax,%esi
80104ba2:	73 1c                	jae    80104bc0 <argint+0x40>
80104ba4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ba7:	39 d0                	cmp    %edx,%eax
80104ba9:	72 15                	jb     80104bc0 <argint+0x40>
  *ip = *(int*)(addr);
80104bab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bae:	8b 53 04             	mov    0x4(%ebx),%edx
80104bb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bb3:	31 c0                	xor    %eax,%eax
}
80104bb5:	5b                   	pop    %ebx
80104bb6:	5e                   	pop    %esi
80104bb7:	5d                   	pop    %ebp
80104bb8:	c3                   	ret    
80104bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc5:	eb ee                	jmp    80104bb5 <argint+0x35>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
80104bd6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104bd9:	e8 62 ef ff ff       	call   80103b40 <myproc>
80104bde:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be0:	e8 5b ef ff ff       	call   80103b40 <myproc>
80104be5:	8b 55 08             	mov    0x8(%ebp),%edx
80104be8:	8b 40 1c             	mov    0x1c(%eax),%eax
80104beb:	8b 40 44             	mov    0x44(%eax),%eax
80104bee:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bf1:	e8 4a ef ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bf6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bf9:	8b 00                	mov    (%eax),%eax
80104bfb:	39 c7                	cmp    %eax,%edi
80104bfd:	73 31                	jae    80104c30 <argptr+0x60>
80104bff:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c02:	39 c8                	cmp    %ecx,%eax
80104c04:	72 2a                	jb     80104c30 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c06:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c09:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c0c:	85 d2                	test   %edx,%edx
80104c0e:	78 20                	js     80104c30 <argptr+0x60>
80104c10:	8b 16                	mov    (%esi),%edx
80104c12:	39 c2                	cmp    %eax,%edx
80104c14:	76 1a                	jbe    80104c30 <argptr+0x60>
80104c16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c19:	01 c3                	add    %eax,%ebx
80104c1b:	39 da                	cmp    %ebx,%edx
80104c1d:	72 11                	jb     80104c30 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c22:	89 02                	mov    %eax,(%edx)
  return 0;
80104c24:	31 c0                	xor    %eax,%eax
}
80104c26:	83 c4 0c             	add    $0xc,%esp
80104c29:	5b                   	pop    %ebx
80104c2a:	5e                   	pop    %esi
80104c2b:	5f                   	pop    %edi
80104c2c:	5d                   	pop    %ebp
80104c2d:	c3                   	ret    
80104c2e:	66 90                	xchg   %ax,%ax
    return -1;
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c35:	eb ef                	jmp    80104c26 <argptr+0x56>
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c45:	e8 f6 ee ff ff       	call   80103b40 <myproc>
80104c4a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c4d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c50:	8b 40 44             	mov    0x44(%eax),%eax
80104c53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c56:	e8 e5 ee ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c5e:	8b 00                	mov    (%eax),%eax
80104c60:	39 c6                	cmp    %eax,%esi
80104c62:	73 44                	jae    80104ca8 <argstr+0x68>
80104c64:	8d 53 08             	lea    0x8(%ebx),%edx
80104c67:	39 d0                	cmp    %edx,%eax
80104c69:	72 3d                	jb     80104ca8 <argstr+0x68>
  *ip = *(int*)(addr);
80104c6b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c6e:	e8 cd ee ff ff       	call   80103b40 <myproc>
  if(addr >= curproc->sz)
80104c73:	3b 18                	cmp    (%eax),%ebx
80104c75:	73 31                	jae    80104ca8 <argstr+0x68>
  *pp = (char*)addr;
80104c77:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c7a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c7c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c7e:	39 d3                	cmp    %edx,%ebx
80104c80:	73 26                	jae    80104ca8 <argstr+0x68>
80104c82:	89 d8                	mov    %ebx,%eax
80104c84:	eb 11                	jmp    80104c97 <argstr+0x57>
80104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi
80104c90:	83 c0 01             	add    $0x1,%eax
80104c93:	39 c2                	cmp    %eax,%edx
80104c95:	76 11                	jbe    80104ca8 <argstr+0x68>
    if(*s == 0)
80104c97:	80 38 00             	cmpb   $0x0,(%eax)
80104c9a:	75 f4                	jne    80104c90 <argstr+0x50>
      return s - *pp;
80104c9c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c9e:	5b                   	pop    %ebx
80104c9f:	5e                   	pop    %esi
80104ca0:	5d                   	pop    %ebp
80104ca1:	c3                   	ret    
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ca8:	5b                   	pop    %ebx
    return -1;
80104ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cae:	5e                   	pop    %esi
80104caf:	5d                   	pop    %ebp
80104cb0:	c3                   	ret    
80104cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbf:	90                   	nop

80104cc0 <syscall>:
[SYS_shugebrk] sys_shugebrk, // part 2
};

void
syscall(void)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104cc7:	e8 74 ee ff ff       	call   80103b40 <myproc>
80104ccc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cce:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cd1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cd4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cd7:	83 fa 17             	cmp    $0x17,%edx
80104cda:	77 24                	ja     80104d00 <syscall+0x40>
80104cdc:	8b 14 85 c0 7e 10 80 	mov    -0x7fef8140(,%eax,4),%edx
80104ce3:	85 d2                	test   %edx,%edx
80104ce5:	74 19                	je     80104d00 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ce7:	ff d2                	call   *%edx
80104ce9:	89 c2                	mov    %eax,%edx
80104ceb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104cee:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf4:	c9                   	leave  
80104cf5:	c3                   	ret    
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d00:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d01:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d04:	50                   	push   %eax
80104d05:	ff 73 14             	push   0x14(%ebx)
80104d08:	68 9d 7e 10 80       	push   $0x80107e9d
80104d0d:	e8 8e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d12:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d15:	83 c4 10             	add    $0x10,%esp
80104d18:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d22:	c9                   	leave  
80104d23:	c3                   	ret    
80104d24:	66 90                	xchg   %ax,%ax
80104d26:	66 90                	xchg   %ax,%ax
80104d28:	66 90                	xchg   %ax,%ax
80104d2a:	66 90                	xchg   %ax,%ax
80104d2c:	66 90                	xchg   %ax,%ax
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d35:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d38:	53                   	push   %ebx
80104d39:	83 ec 34             	sub    $0x34,%esp
80104d3c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d42:	57                   	push   %edi
80104d43:	50                   	push   %eax
{
80104d44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d47:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d4a:	e8 81 d3 ff ff       	call   801020d0 <nameiparent>
80104d4f:	83 c4 10             	add    $0x10,%esp
80104d52:	85 c0                	test   %eax,%eax
80104d54:	0f 84 46 01 00 00    	je     80104ea0 <create+0x170>
    return 0;
  ilock(dp);
80104d5a:	83 ec 0c             	sub    $0xc,%esp
80104d5d:	89 c3                	mov    %eax,%ebx
80104d5f:	50                   	push   %eax
80104d60:	e8 2b ca ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d65:	83 c4 0c             	add    $0xc,%esp
80104d68:	6a 00                	push   $0x0
80104d6a:	57                   	push   %edi
80104d6b:	53                   	push   %ebx
80104d6c:	e8 7f cf ff ff       	call   80101cf0 <dirlookup>
80104d71:	83 c4 10             	add    $0x10,%esp
80104d74:	89 c6                	mov    %eax,%esi
80104d76:	85 c0                	test   %eax,%eax
80104d78:	74 56                	je     80104dd0 <create+0xa0>
    iunlockput(dp);
80104d7a:	83 ec 0c             	sub    $0xc,%esp
80104d7d:	53                   	push   %ebx
80104d7e:	e8 9d cc ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104d83:	89 34 24             	mov    %esi,(%esp)
80104d86:	e8 05 ca ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d8b:	83 c4 10             	add    $0x10,%esp
80104d8e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d93:	75 1b                	jne    80104db0 <create+0x80>
80104d95:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d9a:	75 14                	jne    80104db0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d9f:	89 f0                	mov    %esi,%eax
80104da1:	5b                   	pop    %ebx
80104da2:	5e                   	pop    %esi
80104da3:	5f                   	pop    %edi
80104da4:	5d                   	pop    %ebp
80104da5:	c3                   	ret    
80104da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104db0:	83 ec 0c             	sub    $0xc,%esp
80104db3:	56                   	push   %esi
    return 0;
80104db4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104db6:	e8 65 cc ff ff       	call   80101a20 <iunlockput>
    return 0;
80104dbb:	83 c4 10             	add    $0x10,%esp
}
80104dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc1:	89 f0                	mov    %esi,%eax
80104dc3:	5b                   	pop    %ebx
80104dc4:	5e                   	pop    %esi
80104dc5:	5f                   	pop    %edi
80104dc6:	5d                   	pop    %ebp
80104dc7:	c3                   	ret    
80104dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104dd0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104dd4:	83 ec 08             	sub    $0x8,%esp
80104dd7:	50                   	push   %eax
80104dd8:	ff 33                	push   (%ebx)
80104dda:	e8 41 c8 ff ff       	call   80101620 <ialloc>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	89 c6                	mov    %eax,%esi
80104de4:	85 c0                	test   %eax,%eax
80104de6:	0f 84 cd 00 00 00    	je     80104eb9 <create+0x189>
  ilock(ip);
80104dec:	83 ec 0c             	sub    $0xc,%esp
80104def:	50                   	push   %eax
80104df0:	e8 9b c9 ff ff       	call   80101790 <ilock>
  ip->major = major;
80104df5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104df9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104dfd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e01:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e05:	b8 01 00 00 00       	mov    $0x1,%eax
80104e0a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e0e:	89 34 24             	mov    %esi,(%esp)
80104e11:	e8 ca c8 ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e16:	83 c4 10             	add    $0x10,%esp
80104e19:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e1e:	74 30                	je     80104e50 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e20:	83 ec 04             	sub    $0x4,%esp
80104e23:	ff 76 04             	push   0x4(%esi)
80104e26:	57                   	push   %edi
80104e27:	53                   	push   %ebx
80104e28:	e8 c3 d1 ff ff       	call   80101ff0 <dirlink>
80104e2d:	83 c4 10             	add    $0x10,%esp
80104e30:	85 c0                	test   %eax,%eax
80104e32:	78 78                	js     80104eac <create+0x17c>
  iunlockput(dp);
80104e34:	83 ec 0c             	sub    $0xc,%esp
80104e37:	53                   	push   %ebx
80104e38:	e8 e3 cb ff ff       	call   80101a20 <iunlockput>
  return ip;
80104e3d:	83 c4 10             	add    $0x10,%esp
}
80104e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e43:	89 f0                	mov    %esi,%eax
80104e45:	5b                   	pop    %ebx
80104e46:	5e                   	pop    %esi
80104e47:	5f                   	pop    %edi
80104e48:	5d                   	pop    %ebp
80104e49:	c3                   	ret    
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e50:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e53:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e58:	53                   	push   %ebx
80104e59:	e8 82 c8 ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e5e:	83 c4 0c             	add    $0xc,%esp
80104e61:	ff 76 04             	push   0x4(%esi)
80104e64:	68 40 7f 10 80       	push   $0x80107f40
80104e69:	56                   	push   %esi
80104e6a:	e8 81 d1 ff ff       	call   80101ff0 <dirlink>
80104e6f:	83 c4 10             	add    $0x10,%esp
80104e72:	85 c0                	test   %eax,%eax
80104e74:	78 18                	js     80104e8e <create+0x15e>
80104e76:	83 ec 04             	sub    $0x4,%esp
80104e79:	ff 73 04             	push   0x4(%ebx)
80104e7c:	68 3f 7f 10 80       	push   $0x80107f3f
80104e81:	56                   	push   %esi
80104e82:	e8 69 d1 ff ff       	call   80101ff0 <dirlink>
80104e87:	83 c4 10             	add    $0x10,%esp
80104e8a:	85 c0                	test   %eax,%eax
80104e8c:	79 92                	jns    80104e20 <create+0xf0>
      panic("create dots");
80104e8e:	83 ec 0c             	sub    $0xc,%esp
80104e91:	68 33 7f 10 80       	push   $0x80107f33
80104e96:	e8 e5 b4 ff ff       	call   80100380 <panic>
80104e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e9f:	90                   	nop
}
80104ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ea3:	31 f6                	xor    %esi,%esi
}
80104ea5:	5b                   	pop    %ebx
80104ea6:	89 f0                	mov    %esi,%eax
80104ea8:	5e                   	pop    %esi
80104ea9:	5f                   	pop    %edi
80104eaa:	5d                   	pop    %ebp
80104eab:	c3                   	ret    
    panic("create: dirlink");
80104eac:	83 ec 0c             	sub    $0xc,%esp
80104eaf:	68 42 7f 10 80       	push   $0x80107f42
80104eb4:	e8 c7 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104eb9:	83 ec 0c             	sub    $0xc,%esp
80104ebc:	68 24 7f 10 80       	push   $0x80107f24
80104ec1:	e8 ba b4 ff ff       	call   80100380 <panic>
80104ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi

80104ed0 <sys_dup>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ed8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104edb:	50                   	push   %eax
80104edc:	6a 00                	push   $0x0
80104ede:	e8 9d fc ff ff       	call   80104b80 <argint>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	78 36                	js     80104f20 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eee:	77 30                	ja     80104f20 <sys_dup+0x50>
80104ef0:	e8 4b ec ff ff       	call   80103b40 <myproc>
80104ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ef8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104efc:	85 f6                	test   %esi,%esi
80104efe:	74 20                	je     80104f20 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f00:	e8 3b ec ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f05:	31 db                	xor    %ebx,%ebx
80104f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f10:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104f14:	85 d2                	test   %edx,%edx
80104f16:	74 18                	je     80104f30 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f18:	83 c3 01             	add    $0x1,%ebx
80104f1b:	83 fb 10             	cmp    $0x10,%ebx
80104f1e:	75 f0                	jne    80104f10 <sys_dup+0x40>
}
80104f20:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f28:	89 d8                	mov    %ebx,%eax
80104f2a:	5b                   	pop    %ebx
80104f2b:	5e                   	pop    %esi
80104f2c:	5d                   	pop    %ebp
80104f2d:	c3                   	ret    
80104f2e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f30:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f33:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104f37:	56                   	push   %esi
80104f38:	e8 73 bf ff ff       	call   80100eb0 <filedup>
  return fd;
80104f3d:	83 c4 10             	add    $0x10,%esp
}
80104f40:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f43:	89 d8                	mov    %ebx,%eax
80104f45:	5b                   	pop    %ebx
80104f46:	5e                   	pop    %esi
80104f47:	5d                   	pop    %ebp
80104f48:	c3                   	ret    
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f50 <sys_read>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f5b:	53                   	push   %ebx
80104f5c:	6a 00                	push   $0x0
80104f5e:	e8 1d fc ff ff       	call   80104b80 <argint>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 5e                	js     80104fc8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f6e:	77 58                	ja     80104fc8 <sys_read+0x78>
80104f70:	e8 cb eb ff ff       	call   80103b40 <myproc>
80104f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f78:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104f7c:	85 f6                	test   %esi,%esi
80104f7e:	74 48                	je     80104fc8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f80:	83 ec 08             	sub    $0x8,%esp
80104f83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f86:	50                   	push   %eax
80104f87:	6a 02                	push   $0x2
80104f89:	e8 f2 fb ff ff       	call   80104b80 <argint>
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	85 c0                	test   %eax,%eax
80104f93:	78 33                	js     80104fc8 <sys_read+0x78>
80104f95:	83 ec 04             	sub    $0x4,%esp
80104f98:	ff 75 f0             	push   -0x10(%ebp)
80104f9b:	53                   	push   %ebx
80104f9c:	6a 01                	push   $0x1
80104f9e:	e8 2d fc ff ff       	call   80104bd0 <argptr>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	78 1e                	js     80104fc8 <sys_read+0x78>
  return fileread(f, p, n);
80104faa:	83 ec 04             	sub    $0x4,%esp
80104fad:	ff 75 f0             	push   -0x10(%ebp)
80104fb0:	ff 75 f4             	push   -0xc(%ebp)
80104fb3:	56                   	push   %esi
80104fb4:	e8 77 c0 ff ff       	call   80101030 <fileread>
80104fb9:	83 c4 10             	add    $0x10,%esp
}
80104fbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fbf:	5b                   	pop    %ebx
80104fc0:	5e                   	pop    %esi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fc7:	90                   	nop
    return -1;
80104fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fcd:	eb ed                	jmp    80104fbc <sys_read+0x6c>
80104fcf:	90                   	nop

80104fd0 <sys_write>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fd5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fdb:	53                   	push   %ebx
80104fdc:	6a 00                	push   $0x0
80104fde:	e8 9d fb ff ff       	call   80104b80 <argint>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	78 5e                	js     80105048 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fee:	77 58                	ja     80105048 <sys_write+0x78>
80104ff0:	e8 4b eb ff ff       	call   80103b40 <myproc>
80104ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ff8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104ffc:	85 f6                	test   %esi,%esi
80104ffe:	74 48                	je     80105048 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105000:	83 ec 08             	sub    $0x8,%esp
80105003:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105006:	50                   	push   %eax
80105007:	6a 02                	push   $0x2
80105009:	e8 72 fb ff ff       	call   80104b80 <argint>
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	85 c0                	test   %eax,%eax
80105013:	78 33                	js     80105048 <sys_write+0x78>
80105015:	83 ec 04             	sub    $0x4,%esp
80105018:	ff 75 f0             	push   -0x10(%ebp)
8010501b:	53                   	push   %ebx
8010501c:	6a 01                	push   $0x1
8010501e:	e8 ad fb ff ff       	call   80104bd0 <argptr>
80105023:	83 c4 10             	add    $0x10,%esp
80105026:	85 c0                	test   %eax,%eax
80105028:	78 1e                	js     80105048 <sys_write+0x78>
  return filewrite(f, p, n);
8010502a:	83 ec 04             	sub    $0x4,%esp
8010502d:	ff 75 f0             	push   -0x10(%ebp)
80105030:	ff 75 f4             	push   -0xc(%ebp)
80105033:	56                   	push   %esi
80105034:	e8 87 c0 ff ff       	call   801010c0 <filewrite>
80105039:	83 c4 10             	add    $0x10,%esp
}
8010503c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010503f:	5b                   	pop    %ebx
80105040:	5e                   	pop    %esi
80105041:	5d                   	pop    %ebp
80105042:	c3                   	ret    
80105043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105047:	90                   	nop
    return -1;
80105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504d:	eb ed                	jmp    8010503c <sys_write+0x6c>
8010504f:	90                   	nop

80105050 <sys_close>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105055:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105058:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010505b:	50                   	push   %eax
8010505c:	6a 00                	push   $0x0
8010505e:	e8 1d fb ff ff       	call   80104b80 <argint>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	85 c0                	test   %eax,%eax
80105068:	78 3e                	js     801050a8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010506a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010506e:	77 38                	ja     801050a8 <sys_close+0x58>
80105070:	e8 cb ea ff ff       	call   80103b40 <myproc>
80105075:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105078:	8d 5a 08             	lea    0x8(%edx),%ebx
8010507b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010507f:	85 f6                	test   %esi,%esi
80105081:	74 25                	je     801050a8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105083:	e8 b8 ea ff ff       	call   80103b40 <myproc>
  fileclose(f);
80105088:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010508b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
80105092:	00 
  fileclose(f);
80105093:	56                   	push   %esi
80105094:	e8 67 be ff ff       	call   80100f00 <fileclose>
  return 0;
80105099:	83 c4 10             	add    $0x10,%esp
8010509c:	31 c0                	xor    %eax,%eax
}
8010509e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a1:	5b                   	pop    %ebx
801050a2:	5e                   	pop    %esi
801050a3:	5d                   	pop    %ebp
801050a4:	c3                   	ret    
801050a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ad:	eb ef                	jmp    8010509e <sys_close+0x4e>
801050af:	90                   	nop

801050b0 <sys_fstat>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050bb:	53                   	push   %ebx
801050bc:	6a 00                	push   $0x0
801050be:	e8 bd fa ff ff       	call   80104b80 <argint>
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	78 46                	js     80105110 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ce:	77 40                	ja     80105110 <sys_fstat+0x60>
801050d0:	e8 6b ea ff ff       	call   80103b40 <myproc>
801050d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050d8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801050dc:	85 f6                	test   %esi,%esi
801050de:	74 30                	je     80105110 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050e0:	83 ec 04             	sub    $0x4,%esp
801050e3:	6a 14                	push   $0x14
801050e5:	53                   	push   %ebx
801050e6:	6a 01                	push   $0x1
801050e8:	e8 e3 fa ff ff       	call   80104bd0 <argptr>
801050ed:	83 c4 10             	add    $0x10,%esp
801050f0:	85 c0                	test   %eax,%eax
801050f2:	78 1c                	js     80105110 <sys_fstat+0x60>
  return filestat(f, st);
801050f4:	83 ec 08             	sub    $0x8,%esp
801050f7:	ff 75 f4             	push   -0xc(%ebp)
801050fa:	56                   	push   %esi
801050fb:	e8 e0 be ff ff       	call   80100fe0 <filestat>
80105100:	83 c4 10             	add    $0x10,%esp
}
80105103:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105106:	5b                   	pop    %ebx
80105107:	5e                   	pop    %esi
80105108:	5d                   	pop    %ebp
80105109:	c3                   	ret    
8010510a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb ec                	jmp    80105103 <sys_fstat+0x53>
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <sys_link>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105125:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105128:	53                   	push   %ebx
80105129:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010512c:	50                   	push   %eax
8010512d:	6a 00                	push   $0x0
8010512f:	e8 0c fb ff ff       	call   80104c40 <argstr>
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	0f 88 fb 00 00 00    	js     8010523a <sys_link+0x11a>
8010513f:	83 ec 08             	sub    $0x8,%esp
80105142:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105145:	50                   	push   %eax
80105146:	6a 01                	push   $0x1
80105148:	e8 f3 fa ff ff       	call   80104c40 <argstr>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	0f 88 e2 00 00 00    	js     8010523a <sys_link+0x11a>
  begin_op();
80105158:	e8 c3 dd ff ff       	call   80102f20 <begin_op>
  if((ip = namei(old)) == 0){
8010515d:	83 ec 0c             	sub    $0xc,%esp
80105160:	ff 75 d4             	push   -0x2c(%ebp)
80105163:	e8 48 cf ff ff       	call   801020b0 <namei>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	89 c3                	mov    %eax,%ebx
8010516d:	85 c0                	test   %eax,%eax
8010516f:	0f 84 e4 00 00 00    	je     80105259 <sys_link+0x139>
  ilock(ip);
80105175:	83 ec 0c             	sub    $0xc,%esp
80105178:	50                   	push   %eax
80105179:	e8 12 c6 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105186:	0f 84 b5 00 00 00    	je     80105241 <sys_link+0x121>
  iupdate(ip);
8010518c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010518f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105194:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105197:	53                   	push   %ebx
80105198:	e8 43 c5 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
8010519d:	89 1c 24             	mov    %ebx,(%esp)
801051a0:	e8 cb c6 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051a5:	58                   	pop    %eax
801051a6:	5a                   	pop    %edx
801051a7:	57                   	push   %edi
801051a8:	ff 75 d0             	push   -0x30(%ebp)
801051ab:	e8 20 cf ff ff       	call   801020d0 <nameiparent>
801051b0:	83 c4 10             	add    $0x10,%esp
801051b3:	89 c6                	mov    %eax,%esi
801051b5:	85 c0                	test   %eax,%eax
801051b7:	74 5b                	je     80105214 <sys_link+0xf4>
  ilock(dp);
801051b9:	83 ec 0c             	sub    $0xc,%esp
801051bc:	50                   	push   %eax
801051bd:	e8 ce c5 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051c2:	8b 03                	mov    (%ebx),%eax
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	39 06                	cmp    %eax,(%esi)
801051c9:	75 3d                	jne    80105208 <sys_link+0xe8>
801051cb:	83 ec 04             	sub    $0x4,%esp
801051ce:	ff 73 04             	push   0x4(%ebx)
801051d1:	57                   	push   %edi
801051d2:	56                   	push   %esi
801051d3:	e8 18 ce ff ff       	call   80101ff0 <dirlink>
801051d8:	83 c4 10             	add    $0x10,%esp
801051db:	85 c0                	test   %eax,%eax
801051dd:	78 29                	js     80105208 <sys_link+0xe8>
  iunlockput(dp);
801051df:	83 ec 0c             	sub    $0xc,%esp
801051e2:	56                   	push   %esi
801051e3:	e8 38 c8 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
801051e8:	89 1c 24             	mov    %ebx,(%esp)
801051eb:	e8 d0 c6 ff ff       	call   801018c0 <iput>
  end_op();
801051f0:	e8 9b dd ff ff       	call   80102f90 <end_op>
  return 0;
801051f5:	83 c4 10             	add    $0x10,%esp
801051f8:	31 c0                	xor    %eax,%eax
}
801051fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051fd:	5b                   	pop    %ebx
801051fe:	5e                   	pop    %esi
801051ff:	5f                   	pop    %edi
80105200:	5d                   	pop    %ebp
80105201:	c3                   	ret    
80105202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105208:	83 ec 0c             	sub    $0xc,%esp
8010520b:	56                   	push   %esi
8010520c:	e8 0f c8 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105211:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105214:	83 ec 0c             	sub    $0xc,%esp
80105217:	53                   	push   %ebx
80105218:	e8 73 c5 ff ff       	call   80101790 <ilock>
  ip->nlink--;
8010521d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105222:	89 1c 24             	mov    %ebx,(%esp)
80105225:	e8 b6 c4 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010522a:	89 1c 24             	mov    %ebx,(%esp)
8010522d:	e8 ee c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105232:	e8 59 dd ff ff       	call   80102f90 <end_op>
  return -1;
80105237:	83 c4 10             	add    $0x10,%esp
8010523a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523f:	eb b9                	jmp    801051fa <sys_link+0xda>
    iunlockput(ip);
80105241:	83 ec 0c             	sub    $0xc,%esp
80105244:	53                   	push   %ebx
80105245:	e8 d6 c7 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010524a:	e8 41 dd ff ff       	call   80102f90 <end_op>
    return -1;
8010524f:	83 c4 10             	add    $0x10,%esp
80105252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105257:	eb a1                	jmp    801051fa <sys_link+0xda>
    end_op();
80105259:	e8 32 dd ff ff       	call   80102f90 <end_op>
    return -1;
8010525e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105263:	eb 95                	jmp    801051fa <sys_link+0xda>
80105265:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_unlink>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105275:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105278:	53                   	push   %ebx
80105279:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010527c:	50                   	push   %eax
8010527d:	6a 00                	push   $0x0
8010527f:	e8 bc f9 ff ff       	call   80104c40 <argstr>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
80105289:	0f 88 7a 01 00 00    	js     80105409 <sys_unlink+0x199>
  begin_op();
8010528f:	e8 8c dc ff ff       	call   80102f20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105294:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105297:	83 ec 08             	sub    $0x8,%esp
8010529a:	53                   	push   %ebx
8010529b:	ff 75 c0             	push   -0x40(%ebp)
8010529e:	e8 2d ce ff ff       	call   801020d0 <nameiparent>
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052a9:	85 c0                	test   %eax,%eax
801052ab:	0f 84 62 01 00 00    	je     80105413 <sys_unlink+0x1a3>
  ilock(dp);
801052b1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052b4:	83 ec 0c             	sub    $0xc,%esp
801052b7:	57                   	push   %edi
801052b8:	e8 d3 c4 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052bd:	58                   	pop    %eax
801052be:	5a                   	pop    %edx
801052bf:	68 40 7f 10 80       	push   $0x80107f40
801052c4:	53                   	push   %ebx
801052c5:	e8 06 ca ff ff       	call   80101cd0 <namecmp>
801052ca:	83 c4 10             	add    $0x10,%esp
801052cd:	85 c0                	test   %eax,%eax
801052cf:	0f 84 fb 00 00 00    	je     801053d0 <sys_unlink+0x160>
801052d5:	83 ec 08             	sub    $0x8,%esp
801052d8:	68 3f 7f 10 80       	push   $0x80107f3f
801052dd:	53                   	push   %ebx
801052de:	e8 ed c9 ff ff       	call   80101cd0 <namecmp>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	0f 84 e2 00 00 00    	je     801053d0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052ee:	83 ec 04             	sub    $0x4,%esp
801052f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052f4:	50                   	push   %eax
801052f5:	53                   	push   %ebx
801052f6:	57                   	push   %edi
801052f7:	e8 f4 c9 ff ff       	call   80101cf0 <dirlookup>
801052fc:	83 c4 10             	add    $0x10,%esp
801052ff:	89 c3                	mov    %eax,%ebx
80105301:	85 c0                	test   %eax,%eax
80105303:	0f 84 c7 00 00 00    	je     801053d0 <sys_unlink+0x160>
  ilock(ip);
80105309:	83 ec 0c             	sub    $0xc,%esp
8010530c:	50                   	push   %eax
8010530d:	e8 7e c4 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010531a:	0f 8e 1c 01 00 00    	jle    8010543c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105320:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105325:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105328:	74 66                	je     80105390 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010532a:	83 ec 04             	sub    $0x4,%esp
8010532d:	6a 10                	push   $0x10
8010532f:	6a 00                	push   $0x0
80105331:	57                   	push   %edi
80105332:	e8 89 f5 ff ff       	call   801048c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105337:	6a 10                	push   $0x10
80105339:	ff 75 c4             	push   -0x3c(%ebp)
8010533c:	57                   	push   %edi
8010533d:	ff 75 b4             	push   -0x4c(%ebp)
80105340:	e8 5b c8 ff ff       	call   80101ba0 <writei>
80105345:	83 c4 20             	add    $0x20,%esp
80105348:	83 f8 10             	cmp    $0x10,%eax
8010534b:	0f 85 de 00 00 00    	jne    8010542f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105351:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105356:	0f 84 94 00 00 00    	je     801053f0 <sys_unlink+0x180>
  iunlockput(dp);
8010535c:	83 ec 0c             	sub    $0xc,%esp
8010535f:	ff 75 b4             	push   -0x4c(%ebp)
80105362:	e8 b9 c6 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105367:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010536c:	89 1c 24             	mov    %ebx,(%esp)
8010536f:	e8 6c c3 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105374:	89 1c 24             	mov    %ebx,(%esp)
80105377:	e8 a4 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010537c:	e8 0f dc ff ff       	call   80102f90 <end_op>
  return 0;
80105381:	83 c4 10             	add    $0x10,%esp
80105384:	31 c0                	xor    %eax,%eax
}
80105386:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105389:	5b                   	pop    %ebx
8010538a:	5e                   	pop    %esi
8010538b:	5f                   	pop    %edi
8010538c:	5d                   	pop    %ebp
8010538d:	c3                   	ret    
8010538e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105390:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105394:	76 94                	jbe    8010532a <sys_unlink+0xba>
80105396:	be 20 00 00 00       	mov    $0x20,%esi
8010539b:	eb 0b                	jmp    801053a8 <sys_unlink+0x138>
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
801053a0:	83 c6 10             	add    $0x10,%esi
801053a3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053a6:	73 82                	jae    8010532a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053a8:	6a 10                	push   $0x10
801053aa:	56                   	push   %esi
801053ab:	57                   	push   %edi
801053ac:	53                   	push   %ebx
801053ad:	e8 ee c6 ff ff       	call   80101aa0 <readi>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	83 f8 10             	cmp    $0x10,%eax
801053b8:	75 68                	jne    80105422 <sys_unlink+0x1b2>
    if(de.inum != 0)
801053ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053bf:	74 df                	je     801053a0 <sys_unlink+0x130>
    iunlockput(ip);
801053c1:	83 ec 0c             	sub    $0xc,%esp
801053c4:	53                   	push   %ebx
801053c5:	e8 56 c6 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	ff 75 b4             	push   -0x4c(%ebp)
801053d6:	e8 45 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
801053db:	e8 b0 db ff ff       	call   80102f90 <end_op>
  return -1;
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e8:	eb 9c                	jmp    80105386 <sys_unlink+0x116>
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053f3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053f6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053fb:	50                   	push   %eax
801053fc:	e8 df c2 ff ff       	call   801016e0 <iupdate>
80105401:	83 c4 10             	add    $0x10,%esp
80105404:	e9 53 ff ff ff       	jmp    8010535c <sys_unlink+0xec>
    return -1;
80105409:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540e:	e9 73 ff ff ff       	jmp    80105386 <sys_unlink+0x116>
    end_op();
80105413:	e8 78 db ff ff       	call   80102f90 <end_op>
    return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	e9 64 ff ff ff       	jmp    80105386 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105422:	83 ec 0c             	sub    $0xc,%esp
80105425:	68 64 7f 10 80       	push   $0x80107f64
8010542a:	e8 51 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	68 76 7f 10 80       	push   $0x80107f76
80105437:	e8 44 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	68 52 7f 10 80       	push   $0x80107f52
80105444:	e8 37 af ff ff       	call   80100380 <panic>
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_open>:

int
sys_open(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105455:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105458:	53                   	push   %ebx
80105459:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010545c:	50                   	push   %eax
8010545d:	6a 00                	push   $0x0
8010545f:	e8 dc f7 ff ff       	call   80104c40 <argstr>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	85 c0                	test   %eax,%eax
80105469:	0f 88 8e 00 00 00    	js     801054fd <sys_open+0xad>
8010546f:	83 ec 08             	sub    $0x8,%esp
80105472:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105475:	50                   	push   %eax
80105476:	6a 01                	push   $0x1
80105478:	e8 03 f7 ff ff       	call   80104b80 <argint>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	78 79                	js     801054fd <sys_open+0xad>
    return -1;

  begin_op();
80105484:	e8 97 da ff ff       	call   80102f20 <begin_op>

  if(omode & O_CREATE){
80105489:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010548d:	75 79                	jne    80105508 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010548f:	83 ec 0c             	sub    $0xc,%esp
80105492:	ff 75 e0             	push   -0x20(%ebp)
80105495:	e8 16 cc ff ff       	call   801020b0 <namei>
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	89 c6                	mov    %eax,%esi
8010549f:	85 c0                	test   %eax,%eax
801054a1:	0f 84 7e 00 00 00    	je     80105525 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054a7:	83 ec 0c             	sub    $0xc,%esp
801054aa:	50                   	push   %eax
801054ab:	e8 e0 c2 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054b0:	83 c4 10             	add    $0x10,%esp
801054b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054b8:	0f 84 c2 00 00 00    	je     80105580 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054be:	e8 7d b9 ff ff       	call   80100e40 <filealloc>
801054c3:	89 c7                	mov    %eax,%edi
801054c5:	85 c0                	test   %eax,%eax
801054c7:	74 23                	je     801054ec <sys_open+0x9c>
  struct proc *curproc = myproc();
801054c9:	e8 72 e6 ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054d0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801054d4:	85 d2                	test   %edx,%edx
801054d6:	74 60                	je     80105538 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054d8:	83 c3 01             	add    $0x1,%ebx
801054db:	83 fb 10             	cmp    $0x10,%ebx
801054de:	75 f0                	jne    801054d0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	57                   	push   %edi
801054e4:	e8 17 ba ff ff       	call   80100f00 <fileclose>
801054e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054ec:	83 ec 0c             	sub    $0xc,%esp
801054ef:	56                   	push   %esi
801054f0:	e8 2b c5 ff ff       	call   80101a20 <iunlockput>
    end_op();
801054f5:	e8 96 da ff ff       	call   80102f90 <end_op>
    return -1;
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105502:	eb 6d                	jmp    80105571 <sys_open+0x121>
80105504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105508:	83 ec 0c             	sub    $0xc,%esp
8010550b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010550e:	31 c9                	xor    %ecx,%ecx
80105510:	ba 02 00 00 00       	mov    $0x2,%edx
80105515:	6a 00                	push   $0x0
80105517:	e8 14 f8 ff ff       	call   80104d30 <create>
    if(ip == 0){
8010551c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010551f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105521:	85 c0                	test   %eax,%eax
80105523:	75 99                	jne    801054be <sys_open+0x6e>
      end_op();
80105525:	e8 66 da ff ff       	call   80102f90 <end_op>
      return -1;
8010552a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010552f:	eb 40                	jmp    80105571 <sys_open+0x121>
80105531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105538:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010553b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010553f:	56                   	push   %esi
80105540:	e8 2b c3 ff ff       	call   80101870 <iunlock>
  end_op();
80105545:	e8 46 da ff ff       	call   80102f90 <end_op>

  f->type = FD_INODE;
8010554a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105550:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105553:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105556:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105559:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010555b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105562:	f7 d0                	not    %eax
80105564:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105567:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010556a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010556d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105574:	89 d8                	mov    %ebx,%eax
80105576:	5b                   	pop    %ebx
80105577:	5e                   	pop    %esi
80105578:	5f                   	pop    %edi
80105579:	5d                   	pop    %ebp
8010557a:	c3                   	ret    
8010557b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010557f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105580:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105583:	85 c9                	test   %ecx,%ecx
80105585:	0f 84 33 ff ff ff    	je     801054be <sys_open+0x6e>
8010558b:	e9 5c ff ff ff       	jmp    801054ec <sys_open+0x9c>

80105590 <sys_mkdir>:

int
sys_mkdir(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105596:	e8 85 d9 ff ff       	call   80102f20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010559b:	83 ec 08             	sub    $0x8,%esp
8010559e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055a1:	50                   	push   %eax
801055a2:	6a 00                	push   $0x0
801055a4:	e8 97 f6 ff ff       	call   80104c40 <argstr>
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	85 c0                	test   %eax,%eax
801055ae:	78 30                	js     801055e0 <sys_mkdir+0x50>
801055b0:	83 ec 0c             	sub    $0xc,%esp
801055b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b6:	31 c9                	xor    %ecx,%ecx
801055b8:	ba 01 00 00 00       	mov    $0x1,%edx
801055bd:	6a 00                	push   $0x0
801055bf:	e8 6c f7 ff ff       	call   80104d30 <create>
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	85 c0                	test   %eax,%eax
801055c9:	74 15                	je     801055e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055cb:	83 ec 0c             	sub    $0xc,%esp
801055ce:	50                   	push   %eax
801055cf:	e8 4c c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
801055d4:	e8 b7 d9 ff ff       	call   80102f90 <end_op>
  return 0;
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	31 c0                	xor    %eax,%eax
}
801055de:	c9                   	leave  
801055df:	c3                   	ret    
    end_op();
801055e0:	e8 ab d9 ff ff       	call   80102f90 <end_op>
    return -1;
801055e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ea:	c9                   	leave  
801055eb:	c3                   	ret    
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055f0 <sys_mknod>:

int
sys_mknod(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055f6:	e8 25 d9 ff ff       	call   80102f20 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055fb:	83 ec 08             	sub    $0x8,%esp
801055fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105601:	50                   	push   %eax
80105602:	6a 00                	push   $0x0
80105604:	e8 37 f6 ff ff       	call   80104c40 <argstr>
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	85 c0                	test   %eax,%eax
8010560e:	78 60                	js     80105670 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105610:	83 ec 08             	sub    $0x8,%esp
80105613:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105616:	50                   	push   %eax
80105617:	6a 01                	push   $0x1
80105619:	e8 62 f5 ff ff       	call   80104b80 <argint>
  if((argstr(0, &path)) < 0 ||
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	85 c0                	test   %eax,%eax
80105623:	78 4b                	js     80105670 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105625:	83 ec 08             	sub    $0x8,%esp
80105628:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010562b:	50                   	push   %eax
8010562c:	6a 02                	push   $0x2
8010562e:	e8 4d f5 ff ff       	call   80104b80 <argint>
     argint(1, &major) < 0 ||
80105633:	83 c4 10             	add    $0x10,%esp
80105636:	85 c0                	test   %eax,%eax
80105638:	78 36                	js     80105670 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010563a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010563e:	83 ec 0c             	sub    $0xc,%esp
80105641:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105645:	ba 03 00 00 00       	mov    $0x3,%edx
8010564a:	50                   	push   %eax
8010564b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010564e:	e8 dd f6 ff ff       	call   80104d30 <create>
     argint(2, &minor) < 0 ||
80105653:	83 c4 10             	add    $0x10,%esp
80105656:	85 c0                	test   %eax,%eax
80105658:	74 16                	je     80105670 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010565a:	83 ec 0c             	sub    $0xc,%esp
8010565d:	50                   	push   %eax
8010565e:	e8 bd c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105663:	e8 28 d9 ff ff       	call   80102f90 <end_op>
  return 0;
80105668:	83 c4 10             	add    $0x10,%esp
8010566b:	31 c0                	xor    %eax,%eax
}
8010566d:	c9                   	leave  
8010566e:	c3                   	ret    
8010566f:	90                   	nop
    end_op();
80105670:	e8 1b d9 ff ff       	call   80102f90 <end_op>
    return -1;
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_chdir>:

int
sys_chdir(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	56                   	push   %esi
80105684:	53                   	push   %ebx
80105685:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105688:	e8 b3 e4 ff ff       	call   80103b40 <myproc>
8010568d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010568f:	e8 8c d8 ff ff       	call   80102f20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105694:	83 ec 08             	sub    $0x8,%esp
80105697:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010569a:	50                   	push   %eax
8010569b:	6a 00                	push   $0x0
8010569d:	e8 9e f5 ff ff       	call   80104c40 <argstr>
801056a2:	83 c4 10             	add    $0x10,%esp
801056a5:	85 c0                	test   %eax,%eax
801056a7:	78 77                	js     80105720 <sys_chdir+0xa0>
801056a9:	83 ec 0c             	sub    $0xc,%esp
801056ac:	ff 75 f4             	push   -0xc(%ebp)
801056af:	e8 fc c9 ff ff       	call   801020b0 <namei>
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	89 c3                	mov    %eax,%ebx
801056b9:	85 c0                	test   %eax,%eax
801056bb:	74 63                	je     80105720 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056bd:	83 ec 0c             	sub    $0xc,%esp
801056c0:	50                   	push   %eax
801056c1:	e8 ca c0 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
801056c6:	83 c4 10             	add    $0x10,%esp
801056c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ce:	75 30                	jne    80105700 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 97 c1 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
801056d9:	58                   	pop    %eax
801056da:	ff 76 6c             	push   0x6c(%esi)
801056dd:	e8 de c1 ff ff       	call   801018c0 <iput>
  end_op();
801056e2:	e8 a9 d8 ff ff       	call   80102f90 <end_op>
  curproc->cwd = ip;
801056e7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	31 c0                	xor    %eax,%eax
}
801056ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056f2:	5b                   	pop    %ebx
801056f3:	5e                   	pop    %esi
801056f4:	5d                   	pop    %ebp
801056f5:	c3                   	ret    
801056f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	53                   	push   %ebx
80105704:	e8 17 c3 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105709:	e8 82 d8 ff ff       	call   80102f90 <end_op>
    return -1;
8010570e:	83 c4 10             	add    $0x10,%esp
80105711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105716:	eb d7                	jmp    801056ef <sys_chdir+0x6f>
80105718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571f:	90                   	nop
    end_op();
80105720:	e8 6b d8 ff ff       	call   80102f90 <end_op>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572a:	eb c3                	jmp    801056ef <sys_chdir+0x6f>
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_exec>:

int
sys_exec(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105735:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010573b:	53                   	push   %ebx
8010573c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105742:	50                   	push   %eax
80105743:	6a 00                	push   $0x0
80105745:	e8 f6 f4 ff ff       	call   80104c40 <argstr>
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	85 c0                	test   %eax,%eax
8010574f:	0f 88 87 00 00 00    	js     801057dc <sys_exec+0xac>
80105755:	83 ec 08             	sub    $0x8,%esp
80105758:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010575e:	50                   	push   %eax
8010575f:	6a 01                	push   $0x1
80105761:	e8 1a f4 ff ff       	call   80104b80 <argint>
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	85 c0                	test   %eax,%eax
8010576b:	78 6f                	js     801057dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010576d:	83 ec 04             	sub    $0x4,%esp
80105770:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105776:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105778:	68 80 00 00 00       	push   $0x80
8010577d:	6a 00                	push   $0x0
8010577f:	56                   	push   %esi
80105780:	e8 3b f1 ff ff       	call   801048c0 <memset>
80105785:	83 c4 10             	add    $0x10,%esp
80105788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105790:	83 ec 08             	sub    $0x8,%esp
80105793:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105799:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057a0:	50                   	push   %eax
801057a1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057a7:	01 f8                	add    %edi,%eax
801057a9:	50                   	push   %eax
801057aa:	e8 41 f3 ff ff       	call   80104af0 <fetchint>
801057af:	83 c4 10             	add    $0x10,%esp
801057b2:	85 c0                	test   %eax,%eax
801057b4:	78 26                	js     801057dc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057b6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057bc:	85 c0                	test   %eax,%eax
801057be:	74 30                	je     801057f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057c0:	83 ec 08             	sub    $0x8,%esp
801057c3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057c6:	52                   	push   %edx
801057c7:	50                   	push   %eax
801057c8:	e8 63 f3 ff ff       	call   80104b30 <fetchstr>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 08                	js     801057dc <sys_exec+0xac>
  for(i=0;; i++){
801057d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057d7:	83 fb 20             	cmp    $0x20,%ebx
801057da:	75 b4                	jne    80105790 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e4:	5b                   	pop    %ebx
801057e5:	5e                   	pop    %esi
801057e6:	5f                   	pop    %edi
801057e7:	5d                   	pop    %ebp
801057e8:	c3                   	ret    
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057f0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057f7:	00 00 00 00 
  return exec(path, argv);
801057fb:	83 ec 08             	sub    $0x8,%esp
801057fe:	56                   	push   %esi
801057ff:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105805:	e8 a6 b2 ff ff       	call   80100ab0 <exec>
8010580a:	83 c4 10             	add    $0x10,%esp
}
8010580d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105810:	5b                   	pop    %ebx
80105811:	5e                   	pop    %esi
80105812:	5f                   	pop    %edi
80105813:	5d                   	pop    %ebp
80105814:	c3                   	ret    
80105815:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_pipe>:

int
sys_pipe(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	57                   	push   %edi
80105824:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105825:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105828:	53                   	push   %ebx
80105829:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010582c:	6a 08                	push   $0x8
8010582e:	50                   	push   %eax
8010582f:	6a 00                	push   $0x0
80105831:	e8 9a f3 ff ff       	call   80104bd0 <argptr>
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	85 c0                	test   %eax,%eax
8010583b:	78 4a                	js     80105887 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010583d:	83 ec 08             	sub    $0x8,%esp
80105840:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105843:	50                   	push   %eax
80105844:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105847:	50                   	push   %eax
80105848:	e8 b3 dd ff ff       	call   80103600 <pipealloc>
8010584d:	83 c4 10             	add    $0x10,%esp
80105850:	85 c0                	test   %eax,%eax
80105852:	78 33                	js     80105887 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105854:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105857:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105859:	e8 e2 e2 ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010585e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105860:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105864:	85 f6                	test   %esi,%esi
80105866:	74 28                	je     80105890 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105868:	83 c3 01             	add    $0x1,%ebx
8010586b:	83 fb 10             	cmp    $0x10,%ebx
8010586e:	75 f0                	jne    80105860 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	ff 75 e0             	push   -0x20(%ebp)
80105876:	e8 85 b6 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
8010587b:	58                   	pop    %eax
8010587c:	ff 75 e4             	push   -0x1c(%ebp)
8010587f:	e8 7c b6 ff ff       	call   80100f00 <fileclose>
    return -1;
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588c:	eb 53                	jmp    801058e1 <sys_pipe+0xc1>
8010588e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105890:	8d 73 08             	lea    0x8(%ebx),%esi
80105893:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105897:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010589a:	e8 a1 e2 ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010589f:	31 d2                	xor    %edx,%edx
801058a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058a8:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
801058ac:	85 c9                	test   %ecx,%ecx
801058ae:	74 20                	je     801058d0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801058b0:	83 c2 01             	add    $0x1,%edx
801058b3:	83 fa 10             	cmp    $0x10,%edx
801058b6:	75 f0                	jne    801058a8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801058b8:	e8 83 e2 ff ff       	call   80103b40 <myproc>
801058bd:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
801058c4:	00 
801058c5:	eb a9                	jmp    80105870 <sys_pipe+0x50>
801058c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058d0:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
801058d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058d7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058df:	31 c0                	xor    %eax,%eax
}
801058e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058e4:	5b                   	pop    %ebx
801058e5:	5e                   	pop    %esi
801058e6:	5f                   	pop    %edi
801058e7:	5d                   	pop    %ebp
801058e8:	c3                   	ret    
801058e9:	66 90                	xchg   %ax,%ax
801058eb:	66 90                	xchg   %ax,%ax
801058ed:	66 90                	xchg   %ax,%ax
801058ef:	90                   	nop

801058f0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801058f0:	e9 7b e4 ff ff       	jmp    80103d70 <fork>
801058f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_exit>:
}

int
sys_exit(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 08             	sub    $0x8,%esp
  exit();
80105906:	e8 e5 e6 ff ff       	call   80103ff0 <exit>
  return 0;  // not reached
}
8010590b:	31 c0                	xor    %eax,%eax
8010590d:	c9                   	leave  
8010590e:	c3                   	ret    
8010590f:	90                   	nop

80105910 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105910:	e9 0b e8 ff ff       	jmp    80104120 <wait>
80105915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105920 <sys_kill>:
}

int
sys_kill(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105926:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105929:	50                   	push   %eax
8010592a:	6a 00                	push   $0x0
8010592c:	e8 4f f2 ff ff       	call   80104b80 <argint>
80105931:	83 c4 10             	add    $0x10,%esp
80105934:	85 c0                	test   %eax,%eax
80105936:	78 18                	js     80105950 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105938:	83 ec 0c             	sub    $0xc,%esp
8010593b:	ff 75 f4             	push   -0xc(%ebp)
8010593e:	e8 7d ea ff ff       	call   801043c0 <kill>
80105943:	83 c4 10             	add    $0x10,%esp
}
80105946:	c9                   	leave  
80105947:	c3                   	ret    
80105948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594f:	90                   	nop
80105950:	c9                   	leave  
    return -1;
80105951:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105956:	c3                   	ret    
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax

80105960 <sys_getpid>:

int
sys_getpid(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105966:	e8 d5 e1 ff ff       	call   80103b40 <myproc>
8010596b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010596e:	c9                   	leave  
8010596f:	c3                   	ret    

80105970 <sys_sbrk>:

int
sys_sbrk(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105974:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105977:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010597a:	50                   	push   %eax
8010597b:	6a 00                	push   $0x0
8010597d:	e8 fe f1 ff ff       	call   80104b80 <argint>
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	85 c0                	test   %eax,%eax
80105987:	78 27                	js     801059b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105989:	e8 b2 e1 ff ff       	call   80103b40 <myproc>
  if(growproc(n) < 0)
8010598e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105991:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105993:	ff 75 f4             	push   -0xc(%ebp)
80105996:	e8 c5 e2 ff ff       	call   80103c60 <growproc>
8010599b:	83 c4 10             	add    $0x10,%esp
8010599e:	85 c0                	test   %eax,%eax
801059a0:	78 0e                	js     801059b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059a2:	89 d8                	mov    %ebx,%eax
801059a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a7:	c9                   	leave  
801059a8:	c3                   	ret    
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059b5:	eb eb                	jmp    801059a2 <sys_sbrk+0x32>
801059b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059be:	66 90                	xchg   %ax,%ax

801059c0 <sys_shugebrk>:
// TODO: implement this
// part 2
// TODO: add growhugeproc
int
sys_shugebrk(void)
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
801059cd:	e8 ae f1 ff ff       	call   80104b80 <argint>
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	85 c0                	test   %eax,%eax
801059d7:	78 27                	js     80105a00 <sys_shugebrk+0x40>
    return -1;
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
801059d9:	e8 62 e1 ff ff       	call   80103b40 <myproc>
  if(growhugeproc(n) < 0)
801059de:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
801059e1:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growhugeproc(n) < 0)
801059e4:	ff 75 f4             	push   -0xc(%ebp)
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
801059e7:	81 c3 00 00 00 1e    	add    $0x1e000000,%ebx
  if(growhugeproc(n) < 0)
801059ed:	e8 ee e2 ff ff       	call   80103ce0 <growhugeproc>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 07                	js     80105a00 <sys_shugebrk+0x40>
    return -1;
  return addr;
}
801059f9:	89 d8                	mov    %ebx,%eax
801059fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059fe:	c9                   	leave  
801059ff:	c3                   	ret    
    return -1;
80105a00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a05:	eb f2                	jmp    801059f9 <sys_shugebrk+0x39>
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_sleep>:

int
sys_sleep(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a1a:	50                   	push   %eax
80105a1b:	6a 00                	push   $0x0
80105a1d:	e8 5e f1 ff ff       	call   80104b80 <argint>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	0f 88 8a 00 00 00    	js     80105ab7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a2d:	83 ec 0c             	sub    $0xc,%esp
80105a30:	68 a0 4d 11 80       	push   $0x80114da0
80105a35:	e8 c6 ed ff ff       	call   80104800 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a3d:	8b 1d 80 4d 11 80    	mov    0x80114d80,%ebx
  while(ticks - ticks0 < n){
80105a43:	83 c4 10             	add    $0x10,%esp
80105a46:	85 d2                	test   %edx,%edx
80105a48:	75 27                	jne    80105a71 <sys_sleep+0x61>
80105a4a:	eb 54                	jmp    80105aa0 <sys_sleep+0x90>
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a50:	83 ec 08             	sub    $0x8,%esp
80105a53:	68 a0 4d 11 80       	push   $0x80114da0
80105a58:	68 80 4d 11 80       	push   $0x80114d80
80105a5d:	e8 3e e8 ff ff       	call   801042a0 <sleep>
  while(ticks - ticks0 < n){
80105a62:	a1 80 4d 11 80       	mov    0x80114d80,%eax
80105a67:	83 c4 10             	add    $0x10,%esp
80105a6a:	29 d8                	sub    %ebx,%eax
80105a6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a6f:	73 2f                	jae    80105aa0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a71:	e8 ca e0 ff ff       	call   80103b40 <myproc>
80105a76:	8b 40 28             	mov    0x28(%eax),%eax
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	74 d3                	je     80105a50 <sys_sleep+0x40>
      release(&tickslock);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	68 a0 4d 11 80       	push   $0x80114da0
80105a85:	e8 16 ed ff ff       	call   801047a0 <release>
  }
  release(&tickslock);
  return 0;
}
80105a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	68 a0 4d 11 80       	push   $0x80114da0
80105aa8:	e8 f3 ec ff ff       	call   801047a0 <release>
  return 0;
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	31 c0                	xor    %eax,%eax
}
80105ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    
    return -1;
80105ab7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abc:	eb f4                	jmp    80105ab2 <sys_sleep+0xa2>
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
80105ac4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ac7:	68 a0 4d 11 80       	push   $0x80114da0
80105acc:	e8 2f ed ff ff       	call   80104800 <acquire>
  xticks = ticks;
80105ad1:	8b 1d 80 4d 11 80    	mov    0x80114d80,%ebx
  release(&tickslock);
80105ad7:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80105ade:	e8 bd ec ff ff       	call   801047a0 <release>
  return xticks;
}
80105ae3:	89 d8                	mov    %ebx,%eax
80105ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae8:	c9                   	leave  
80105ae9:	c3                   	ret    
80105aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105af0 <sys_printhugepde>:

// System calls for debugging huge page allocations/mappings
int
sys_printhugepde()
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
  pde_t *pgdir = myproc()->pgdir;
  int pid = myproc()->pid;
  int i = 0;
  for (i = 0; i < 1024; i++) {
80105af6:	31 db                	xor    %ebx,%ebx
{
80105af8:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pgdir = myproc()->pgdir;
80105afb:	e8 40 e0 ff ff       	call   80103b40 <myproc>
80105b00:	8b 78 08             	mov    0x8(%eax),%edi
  int pid = myproc()->pid;
80105b03:	e8 38 e0 ff ff       	call   80103b40 <myproc>
80105b08:	8b 70 14             	mov    0x14(%eax),%esi
  for (i = 0; i < 1024; i++) {
80105b0b:	eb 0e                	jmp    80105b1b <sys_printhugepde+0x2b>
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi
80105b10:	83 c3 01             	add    $0x1,%ebx
80105b13:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b19:	74 2e                	je     80105b49 <sys_printhugepde+0x59>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P))
80105b1b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80105b1e:	89 c2                	mov    %eax,%edx
80105b20:	81 e2 85 00 00 00    	and    $0x85,%edx
80105b26:	81 fa 85 00 00 00    	cmp    $0x85,%edx
80105b2c:	75 e2                	jne    80105b10 <sys_printhugepde+0x20>
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b2e:	50                   	push   %eax
80105b2f:	53                   	push   %ebx
  for (i = 0; i < 1024; i++) {
80105b30:	83 c3 01             	add    $0x1,%ebx
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b33:	56                   	push   %esi
80105b34:	68 85 7f 10 80       	push   $0x80107f85
80105b39:	e8 62 ab ff ff       	call   801006a0 <cprintf>
80105b3e:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 1024; i++) {
80105b41:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b47:	75 d2                	jne    80105b1b <sys_printhugepde+0x2b>
  }
  return 0;
}
80105b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b4c:	31 c0                	xor    %eax,%eax
80105b4e:	5b                   	pop    %ebx
80105b4f:	5e                   	pop    %esi
80105b50:	5f                   	pop    %edi
80105b51:	5d                   	pop    %ebp
80105b52:	c3                   	ret    
80105b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b60 <sys_procpgdirinfo>:

int
sys_procpgdirinfo()
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
  int *buf;
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b65:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105b68:	53                   	push   %ebx
80105b69:	83 ec 30             	sub    $0x30,%esp
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b6c:	6a 08                	push   $0x8
80105b6e:	50                   	push   %eax
80105b6f:	6a 00                	push   $0x0
80105b71:	e8 5a f0 ff ff       	call   80104bd0 <argptr>
80105b76:	83 c4 10             	add    $0x10,%esp
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	0f 88 90 00 00 00    	js     80105c11 <sys_procpgdirinfo+0xb1>
    return -1;
  pde_t *pgdir = myproc()->pgdir;
80105b81:	e8 ba df ff ff       	call   80103b40 <myproc>
  int base_cnt = 0; // base page count
  int huge_cnt = 0; // huge page count
80105b86:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  int base_cnt = 0; // base page count
80105b8d:	31 c9                	xor    %ecx,%ecx
80105b8f:	8b 70 08             	mov    0x8(%eax),%esi
80105b92:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105b98:	eb 12                	jmp    80105bac <sys_procpgdirinfo+0x4c>
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i = 0;
  int j = 0;
  for (i = 0; i < 1024; i++) {
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
      ++huge_cnt;
    if((pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) && ((pgdir[i] & PTE_PS) == 0) /*Only PTE_P and PTE_U should be set for base pages*/) {
80105ba0:	83 f8 05             	cmp    $0x5,%eax
80105ba3:	74 3a                	je     80105bdf <sys_procpgdirinfo+0x7f>
  for (i = 0; i < 1024; i++) {
80105ba5:	83 c6 04             	add    $0x4,%esi
80105ba8:	39 f7                	cmp    %esi,%edi
80105baa:	74 1b                	je     80105bc7 <sys_procpgdirinfo+0x67>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
80105bac:	8b 1e                	mov    (%esi),%ebx
80105bae:	89 d8                	mov    %ebx,%eax
80105bb0:	25 85 00 00 00       	and    $0x85,%eax
80105bb5:	3d 85 00 00 00       	cmp    $0x85,%eax
80105bba:	75 e4                	jne    80105ba0 <sys_procpgdirinfo+0x40>
  for (i = 0; i < 1024; i++) {
80105bbc:	83 c6 04             	add    $0x4,%esi
      ++huge_cnt;
80105bbf:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  for (i = 0; i < 1024; i++) {
80105bc3:	39 f7                	cmp    %esi,%edi
80105bc5:	75 e5                	jne    80105bac <sys_procpgdirinfo+0x4c>
          ++base_cnt;
        }
      }
    }
  }
  buf[0] = base_cnt; // base page count
80105bc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  buf[1] = huge_cnt; // huge page count
80105bca:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  buf[0] = base_cnt; // base page count
80105bcd:	89 08                	mov    %ecx,(%eax)
  buf[1] = huge_cnt; // huge page count
80105bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bd2:	89 78 04             	mov    %edi,0x4(%eax)
  return 0;
80105bd5:	31 c0                	xor    %eax,%eax
}
80105bd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bda:	5b                   	pop    %ebx
80105bdb:	5e                   	pop    %esi
80105bdc:	5f                   	pop    %edi
80105bdd:	5d                   	pop    %ebp
80105bde:	c3                   	ret    
      uint* pgtab = (uint*)P2V(PTE_ADDR(pgdir[i]));
80105bdf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105be5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
      for (j = 0; j < 1024; j++) {
80105beb:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
80105bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((pgtab[j] & PTE_U) && (pgtab[j] & PTE_P)) {
80105bf8:	8b 10                	mov    (%eax),%edx
80105bfa:	83 e2 05             	and    $0x5,%edx
          ++base_cnt;
80105bfd:	83 fa 05             	cmp    $0x5,%edx
80105c00:	0f 94 c2             	sete   %dl
      for (j = 0; j < 1024; j++) {
80105c03:	83 c0 04             	add    $0x4,%eax
          ++base_cnt;
80105c06:	0f b6 d2             	movzbl %dl,%edx
80105c09:	01 d1                	add    %edx,%ecx
      for (j = 0; j < 1024; j++) {
80105c0b:	39 d8                	cmp    %ebx,%eax
80105c0d:	75 e9                	jne    80105bf8 <sys_procpgdirinfo+0x98>
80105c0f:	eb 94                	jmp    80105ba5 <sys_procpgdirinfo+0x45>
    return -1;
80105c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c16:	eb bf                	jmp    80105bd7 <sys_procpgdirinfo+0x77>

80105c18 <alltraps>:
80105c18:	1e                   	push   %ds
80105c19:	06                   	push   %es
80105c1a:	0f a0                	push   %fs
80105c1c:	0f a8                	push   %gs
80105c1e:	60                   	pusha  
80105c1f:	66 b8 10 00          	mov    $0x10,%ax
80105c23:	8e d8                	mov    %eax,%ds
80105c25:	8e c0                	mov    %eax,%es
80105c27:	54                   	push   %esp
80105c28:	e8 c3 00 00 00       	call   80105cf0 <trap>
80105c2d:	83 c4 04             	add    $0x4,%esp

80105c30 <trapret>:
80105c30:	61                   	popa   
80105c31:	0f a9                	pop    %gs
80105c33:	0f a1                	pop    %fs
80105c35:	07                   	pop    %es
80105c36:	1f                   	pop    %ds
80105c37:	83 c4 08             	add    $0x8,%esp
80105c3a:	cf                   	iret   
80105c3b:	66 90                	xchg   %ax,%ax
80105c3d:	66 90                	xchg   %ax,%ax
80105c3f:	90                   	nop

80105c40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c41:	31 c0                	xor    %eax,%eax
{
80105c43:	89 e5                	mov    %esp,%ebp
80105c45:	83 ec 08             	sub    $0x8,%esp
80105c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c57:	c7 04 c5 e2 4d 11 80 	movl   $0x8e000008,-0x7feeb21e(,%eax,8)
80105c5e:	08 00 00 8e 
80105c62:	66 89 14 c5 e0 4d 11 	mov    %dx,-0x7feeb220(,%eax,8)
80105c69:	80 
80105c6a:	c1 ea 10             	shr    $0x10,%edx
80105c6d:	66 89 14 c5 e6 4d 11 	mov    %dx,-0x7feeb21a(,%eax,8)
80105c74:	80 
  for(i = 0; i < 256; i++)
80105c75:	83 c0 01             	add    $0x1,%eax
80105c78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c7d:	75 d1                	jne    80105c50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c82:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105c87:	c7 05 e2 4f 11 80 08 	movl   $0xef000008,0x80114fe2
80105c8e:	00 00 ef 
  initlock(&tickslock, "time");
80105c91:	68 9e 7f 10 80       	push   $0x80107f9e
80105c96:	68 a0 4d 11 80       	push   $0x80114da0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c9b:	66 a3 e0 4f 11 80    	mov    %ax,0x80114fe0
80105ca1:	c1 e8 10             	shr    $0x10,%eax
80105ca4:	66 a3 e6 4f 11 80    	mov    %ax,0x80114fe6
  initlock(&tickslock, "time");
80105caa:	e8 81 e9 ff ff       	call   80104630 <initlock>
}
80105caf:	83 c4 10             	add    $0x10,%esp
80105cb2:	c9                   	leave  
80105cb3:	c3                   	ret    
80105cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop

80105cc0 <idtinit>:

void
idtinit(void)
{
80105cc0:	55                   	push   %ebp
  pd[0] = size-1;
80105cc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cc6:	89 e5                	mov    %esp,%ebp
80105cc8:	83 ec 10             	sub    $0x10,%esp
80105ccb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ccf:	b8 e0 4d 11 80       	mov    $0x80114de0,%eax
80105cd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cd8:	c1 e8 10             	shr    $0x10,%eax
80105cdb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cdf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ce2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ce5:	c9                   	leave  
80105ce6:	c3                   	ret    
80105ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cee:	66 90                	xchg   %ax,%ax

80105cf0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	57                   	push   %edi
80105cf4:	56                   	push   %esi
80105cf5:	53                   	push   %ebx
80105cf6:	83 ec 1c             	sub    $0x1c,%esp
80105cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105cfc:	8b 43 30             	mov    0x30(%ebx),%eax
80105cff:	83 f8 40             	cmp    $0x40,%eax
80105d02:	0f 84 68 01 00 00    	je     80105e70 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d08:	83 e8 20             	sub    $0x20,%eax
80105d0b:	83 f8 1f             	cmp    $0x1f,%eax
80105d0e:	0f 87 8c 00 00 00    	ja     80105da0 <trap+0xb0>
80105d14:	ff 24 85 44 80 10 80 	jmp    *-0x7fef7fbc(,%eax,4)
80105d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d1f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105d20:	e8 2b c5 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105d25:	e8 a6 cd ff ff       	call   80102ad0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d2a:	e8 11 de ff ff       	call   80103b40 <myproc>
80105d2f:	85 c0                	test   %eax,%eax
80105d31:	74 1d                	je     80105d50 <trap+0x60>
80105d33:	e8 08 de ff ff       	call   80103b40 <myproc>
80105d38:	8b 50 28             	mov    0x28(%eax),%edx
80105d3b:	85 d2                	test   %edx,%edx
80105d3d:	74 11                	je     80105d50 <trap+0x60>
80105d3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d43:	83 e0 03             	and    $0x3,%eax
80105d46:	66 83 f8 03          	cmp    $0x3,%ax
80105d4a:	0f 84 e8 01 00 00    	je     80105f38 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d50:	e8 eb dd ff ff       	call   80103b40 <myproc>
80105d55:	85 c0                	test   %eax,%eax
80105d57:	74 0f                	je     80105d68 <trap+0x78>
80105d59:	e8 e2 dd ff ff       	call   80103b40 <myproc>
80105d5e:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105d62:	0f 84 b8 00 00 00    	je     80105e20 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d68:	e8 d3 dd ff ff       	call   80103b40 <myproc>
80105d6d:	85 c0                	test   %eax,%eax
80105d6f:	74 1d                	je     80105d8e <trap+0x9e>
80105d71:	e8 ca dd ff ff       	call   80103b40 <myproc>
80105d76:	8b 40 28             	mov    0x28(%eax),%eax
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	74 11                	je     80105d8e <trap+0x9e>
80105d7d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d81:	83 e0 03             	and    $0x3,%eax
80105d84:	66 83 f8 03          	cmp    $0x3,%ax
80105d88:	0f 84 0f 01 00 00    	je     80105e9d <trap+0x1ad>
    exit();
}
80105d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d91:	5b                   	pop    %ebx
80105d92:	5e                   	pop    %esi
80105d93:	5f                   	pop    %edi
80105d94:	5d                   	pop    %ebp
80105d95:	c3                   	ret    
80105d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105da0:	e8 9b dd ff ff       	call   80103b40 <myproc>
80105da5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105da8:	85 c0                	test   %eax,%eax
80105daa:	0f 84 a2 01 00 00    	je     80105f52 <trap+0x262>
80105db0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105db4:	0f 84 98 01 00 00    	je     80105f52 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105dba:	0f 20 d1             	mov    %cr2,%ecx
80105dbd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dc0:	e8 5b dd ff ff       	call   80103b20 <cpuid>
80105dc5:	8b 73 30             	mov    0x30(%ebx),%esi
80105dc8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dcb:	8b 43 34             	mov    0x34(%ebx),%eax
80105dce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105dd1:	e8 6a dd ff ff       	call   80103b40 <myproc>
80105dd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105dd9:	e8 62 dd ff ff       	call   80103b40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105de4:	51                   	push   %ecx
80105de5:	57                   	push   %edi
80105de6:	52                   	push   %edx
80105de7:	ff 75 e4             	push   -0x1c(%ebp)
80105dea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105deb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105dee:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105df1:	56                   	push   %esi
80105df2:	ff 70 14             	push   0x14(%eax)
80105df5:	68 00 80 10 80       	push   $0x80108000
80105dfa:	e8 a1 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105dff:	83 c4 20             	add    $0x20,%esp
80105e02:	e8 39 dd ff ff       	call   80103b40 <myproc>
80105e07:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e0e:	e8 2d dd ff ff       	call   80103b40 <myproc>
80105e13:	85 c0                	test   %eax,%eax
80105e15:	0f 85 18 ff ff ff    	jne    80105d33 <trap+0x43>
80105e1b:	e9 30 ff ff ff       	jmp    80105d50 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105e20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e24:	0f 85 3e ff ff ff    	jne    80105d68 <trap+0x78>
    yield();
80105e2a:	e8 21 e4 ff ff       	call   80104250 <yield>
80105e2f:	e9 34 ff ff ff       	jmp    80105d68 <trap+0x78>
80105e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e38:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e3b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e3f:	e8 dc dc ff ff       	call   80103b20 <cpuid>
80105e44:	57                   	push   %edi
80105e45:	56                   	push   %esi
80105e46:	50                   	push   %eax
80105e47:	68 a8 7f 10 80       	push   $0x80107fa8
80105e4c:	e8 4f a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105e51:	e8 7a cc ff ff       	call   80102ad0 <lapiceoi>
    break;
80105e56:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e59:	e8 e2 dc ff ff       	call   80103b40 <myproc>
80105e5e:	85 c0                	test   %eax,%eax
80105e60:	0f 85 cd fe ff ff    	jne    80105d33 <trap+0x43>
80105e66:	e9 e5 fe ff ff       	jmp    80105d50 <trap+0x60>
80105e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop
    if(myproc()->killed)
80105e70:	e8 cb dc ff ff       	call   80103b40 <myproc>
80105e75:	8b 70 28             	mov    0x28(%eax),%esi
80105e78:	85 f6                	test   %esi,%esi
80105e7a:	0f 85 c8 00 00 00    	jne    80105f48 <trap+0x258>
    myproc()->tf = tf;
80105e80:	e8 bb dc ff ff       	call   80103b40 <myproc>
80105e85:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105e88:	e8 33 ee ff ff       	call   80104cc0 <syscall>
    if(myproc()->killed)
80105e8d:	e8 ae dc ff ff       	call   80103b40 <myproc>
80105e92:	8b 48 28             	mov    0x28(%eax),%ecx
80105e95:	85 c9                	test   %ecx,%ecx
80105e97:	0f 84 f1 fe ff ff    	je     80105d8e <trap+0x9e>
}
80105e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea0:	5b                   	pop    %ebx
80105ea1:	5e                   	pop    %esi
80105ea2:	5f                   	pop    %edi
80105ea3:	5d                   	pop    %ebp
      exit();
80105ea4:	e9 47 e1 ff ff       	jmp    80103ff0 <exit>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105eb0:	e8 3b 02 00 00       	call   801060f0 <uartintr>
    lapiceoi();
80105eb5:	e8 16 cc ff ff       	call   80102ad0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eba:	e8 81 dc ff ff       	call   80103b40 <myproc>
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	0f 85 6c fe ff ff    	jne    80105d33 <trap+0x43>
80105ec7:	e9 84 fe ff ff       	jmp    80105d50 <trap+0x60>
80105ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ed0:	e8 bb ca ff ff       	call   80102990 <kbdintr>
    lapiceoi();
80105ed5:	e8 f6 cb ff ff       	call   80102ad0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eda:	e8 61 dc ff ff       	call   80103b40 <myproc>
80105edf:	85 c0                	test   %eax,%eax
80105ee1:	0f 85 4c fe ff ff    	jne    80105d33 <trap+0x43>
80105ee7:	e9 64 fe ff ff       	jmp    80105d50 <trap+0x60>
80105eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ef0:	e8 2b dc ff ff       	call   80103b20 <cpuid>
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	0f 85 28 fe ff ff    	jne    80105d25 <trap+0x35>
      acquire(&tickslock);
80105efd:	83 ec 0c             	sub    $0xc,%esp
80105f00:	68 a0 4d 11 80       	push   $0x80114da0
80105f05:	e8 f6 e8 ff ff       	call   80104800 <acquire>
      wakeup(&ticks);
80105f0a:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
      ticks++;
80105f11:	83 05 80 4d 11 80 01 	addl   $0x1,0x80114d80
      wakeup(&ticks);
80105f18:	e8 43 e4 ff ff       	call   80104360 <wakeup>
      release(&tickslock);
80105f1d:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80105f24:	e8 77 e8 ff ff       	call   801047a0 <release>
80105f29:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f2c:	e9 f4 fd ff ff       	jmp    80105d25 <trap+0x35>
80105f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f38:	e8 b3 e0 ff ff       	call   80103ff0 <exit>
80105f3d:	e9 0e fe ff ff       	jmp    80105d50 <trap+0x60>
80105f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f48:	e8 a3 e0 ff ff       	call   80103ff0 <exit>
80105f4d:	e9 2e ff ff ff       	jmp    80105e80 <trap+0x190>
80105f52:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f55:	e8 c6 db ff ff       	call   80103b20 <cpuid>
80105f5a:	83 ec 0c             	sub    $0xc,%esp
80105f5d:	56                   	push   %esi
80105f5e:	57                   	push   %edi
80105f5f:	50                   	push   %eax
80105f60:	ff 73 30             	push   0x30(%ebx)
80105f63:	68 cc 7f 10 80       	push   $0x80107fcc
80105f68:	e8 33 a7 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105f6d:	83 c4 14             	add    $0x14,%esp
80105f70:	68 a3 7f 10 80       	push   $0x80107fa3
80105f75:	e8 06 a4 ff ff       	call   80100380 <panic>
80105f7a:	66 90                	xchg   %ax,%ax
80105f7c:	66 90                	xchg   %ax,%ax
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f80:	a1 e0 55 11 80       	mov    0x801155e0,%eax
80105f85:	85 c0                	test   %eax,%eax
80105f87:	74 17                	je     80105fa0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f89:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f8e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f8f:	a8 01                	test   $0x1,%al
80105f91:	74 0d                	je     80105fa0 <uartgetc+0x20>
80105f93:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f98:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f99:	0f b6 c0             	movzbl %al,%eax
80105f9c:	c3                   	ret    
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fa5:	c3                   	ret    
80105fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fad:	8d 76 00             	lea    0x0(%esi),%esi

80105fb0 <uartinit>:
{
80105fb0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fb1:	31 c9                	xor    %ecx,%ecx
80105fb3:	89 c8                	mov    %ecx,%eax
80105fb5:	89 e5                	mov    %esp,%ebp
80105fb7:	57                   	push   %edi
80105fb8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105fbd:	56                   	push   %esi
80105fbe:	89 fa                	mov    %edi,%edx
80105fc0:	53                   	push   %ebx
80105fc1:	83 ec 1c             	sub    $0x1c,%esp
80105fc4:	ee                   	out    %al,(%dx)
80105fc5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105fca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105fcf:	89 f2                	mov    %esi,%edx
80105fd1:	ee                   	out    %al,(%dx)
80105fd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fdc:	ee                   	out    %al,(%dx)
80105fdd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105fe2:	89 c8                	mov    %ecx,%eax
80105fe4:	89 da                	mov    %ebx,%edx
80105fe6:	ee                   	out    %al,(%dx)
80105fe7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fec:	89 f2                	mov    %esi,%edx
80105fee:	ee                   	out    %al,(%dx)
80105fef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ff4:	89 c8                	mov    %ecx,%eax
80105ff6:	ee                   	out    %al,(%dx)
80105ff7:	b8 01 00 00 00       	mov    $0x1,%eax
80105ffc:	89 da                	mov    %ebx,%edx
80105ffe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106004:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106005:	3c ff                	cmp    $0xff,%al
80106007:	74 78                	je     80106081 <uartinit+0xd1>
  uart = 1;
80106009:	c7 05 e0 55 11 80 01 	movl   $0x1,0x801155e0
80106010:	00 00 00 
80106013:	89 fa                	mov    %edi,%edx
80106015:	ec                   	in     (%dx),%al
80106016:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010601b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010601c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010601f:	bf c4 80 10 80       	mov    $0x801080c4,%edi
80106024:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106029:	6a 00                	push   $0x0
8010602b:	6a 04                	push   $0x4
8010602d:	e8 5e c4 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106032:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106036:	83 c4 10             	add    $0x10,%esp
80106039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106040:	a1 e0 55 11 80       	mov    0x801155e0,%eax
80106045:	bb 80 00 00 00       	mov    $0x80,%ebx
8010604a:	85 c0                	test   %eax,%eax
8010604c:	75 14                	jne    80106062 <uartinit+0xb2>
8010604e:	eb 23                	jmp    80106073 <uartinit+0xc3>
    microdelay(10);
80106050:	83 ec 0c             	sub    $0xc,%esp
80106053:	6a 0a                	push   $0xa
80106055:	e8 96 ca ff ff       	call   80102af0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	83 eb 01             	sub    $0x1,%ebx
80106060:	74 07                	je     80106069 <uartinit+0xb9>
80106062:	89 f2                	mov    %esi,%edx
80106064:	ec                   	in     (%dx),%al
80106065:	a8 20                	test   $0x20,%al
80106067:	74 e7                	je     80106050 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106069:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010606d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106072:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106073:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106077:	83 c7 01             	add    $0x1,%edi
8010607a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010607d:	84 c0                	test   %al,%al
8010607f:	75 bf                	jne    80106040 <uartinit+0x90>
}
80106081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106084:	5b                   	pop    %ebx
80106085:	5e                   	pop    %esi
80106086:	5f                   	pop    %edi
80106087:	5d                   	pop    %ebp
80106088:	c3                   	ret    
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106090 <uartputc>:
  if(!uart)
80106090:	a1 e0 55 11 80       	mov    0x801155e0,%eax
80106095:	85 c0                	test   %eax,%eax
80106097:	74 47                	je     801060e0 <uartputc+0x50>
{
80106099:	55                   	push   %ebp
8010609a:	89 e5                	mov    %esp,%ebp
8010609c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010609d:	be fd 03 00 00       	mov    $0x3fd,%esi
801060a2:	53                   	push   %ebx
801060a3:	bb 80 00 00 00       	mov    $0x80,%ebx
801060a8:	eb 18                	jmp    801060c2 <uartputc+0x32>
801060aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801060b0:	83 ec 0c             	sub    $0xc,%esp
801060b3:	6a 0a                	push   $0xa
801060b5:	e8 36 ca ff ff       	call   80102af0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060ba:	83 c4 10             	add    $0x10,%esp
801060bd:	83 eb 01             	sub    $0x1,%ebx
801060c0:	74 07                	je     801060c9 <uartputc+0x39>
801060c2:	89 f2                	mov    %esi,%edx
801060c4:	ec                   	in     (%dx),%al
801060c5:	a8 20                	test   $0x20,%al
801060c7:	74 e7                	je     801060b0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060c9:	8b 45 08             	mov    0x8(%ebp),%eax
801060cc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060d1:	ee                   	out    %al,(%dx)
}
801060d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060d5:	5b                   	pop    %ebx
801060d6:	5e                   	pop    %esi
801060d7:	5d                   	pop    %ebp
801060d8:	c3                   	ret    
801060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060e0:	c3                   	ret    
801060e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ef:	90                   	nop

801060f0 <uartintr>:

void
uartintr(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060f6:	68 80 5f 10 80       	push   $0x80105f80
801060fb:	e8 80 a7 ff ff       	call   80100880 <consoleintr>
}
80106100:	83 c4 10             	add    $0x10,%esp
80106103:	c9                   	leave  
80106104:	c3                   	ret    

80106105 <vector0>:
80106105:	6a 00                	push   $0x0
80106107:	6a 00                	push   $0x0
80106109:	e9 0a fb ff ff       	jmp    80105c18 <alltraps>

8010610e <vector1>:
8010610e:	6a 00                	push   $0x0
80106110:	6a 01                	push   $0x1
80106112:	e9 01 fb ff ff       	jmp    80105c18 <alltraps>

80106117 <vector2>:
80106117:	6a 00                	push   $0x0
80106119:	6a 02                	push   $0x2
8010611b:	e9 f8 fa ff ff       	jmp    80105c18 <alltraps>

80106120 <vector3>:
80106120:	6a 00                	push   $0x0
80106122:	6a 03                	push   $0x3
80106124:	e9 ef fa ff ff       	jmp    80105c18 <alltraps>

80106129 <vector4>:
80106129:	6a 00                	push   $0x0
8010612b:	6a 04                	push   $0x4
8010612d:	e9 e6 fa ff ff       	jmp    80105c18 <alltraps>

80106132 <vector5>:
80106132:	6a 00                	push   $0x0
80106134:	6a 05                	push   $0x5
80106136:	e9 dd fa ff ff       	jmp    80105c18 <alltraps>

8010613b <vector6>:
8010613b:	6a 00                	push   $0x0
8010613d:	6a 06                	push   $0x6
8010613f:	e9 d4 fa ff ff       	jmp    80105c18 <alltraps>

80106144 <vector7>:
80106144:	6a 00                	push   $0x0
80106146:	6a 07                	push   $0x7
80106148:	e9 cb fa ff ff       	jmp    80105c18 <alltraps>

8010614d <vector8>:
8010614d:	6a 08                	push   $0x8
8010614f:	e9 c4 fa ff ff       	jmp    80105c18 <alltraps>

80106154 <vector9>:
80106154:	6a 00                	push   $0x0
80106156:	6a 09                	push   $0x9
80106158:	e9 bb fa ff ff       	jmp    80105c18 <alltraps>

8010615d <vector10>:
8010615d:	6a 0a                	push   $0xa
8010615f:	e9 b4 fa ff ff       	jmp    80105c18 <alltraps>

80106164 <vector11>:
80106164:	6a 0b                	push   $0xb
80106166:	e9 ad fa ff ff       	jmp    80105c18 <alltraps>

8010616b <vector12>:
8010616b:	6a 0c                	push   $0xc
8010616d:	e9 a6 fa ff ff       	jmp    80105c18 <alltraps>

80106172 <vector13>:
80106172:	6a 0d                	push   $0xd
80106174:	e9 9f fa ff ff       	jmp    80105c18 <alltraps>

80106179 <vector14>:
80106179:	6a 0e                	push   $0xe
8010617b:	e9 98 fa ff ff       	jmp    80105c18 <alltraps>

80106180 <vector15>:
80106180:	6a 00                	push   $0x0
80106182:	6a 0f                	push   $0xf
80106184:	e9 8f fa ff ff       	jmp    80105c18 <alltraps>

80106189 <vector16>:
80106189:	6a 00                	push   $0x0
8010618b:	6a 10                	push   $0x10
8010618d:	e9 86 fa ff ff       	jmp    80105c18 <alltraps>

80106192 <vector17>:
80106192:	6a 11                	push   $0x11
80106194:	e9 7f fa ff ff       	jmp    80105c18 <alltraps>

80106199 <vector18>:
80106199:	6a 00                	push   $0x0
8010619b:	6a 12                	push   $0x12
8010619d:	e9 76 fa ff ff       	jmp    80105c18 <alltraps>

801061a2 <vector19>:
801061a2:	6a 00                	push   $0x0
801061a4:	6a 13                	push   $0x13
801061a6:	e9 6d fa ff ff       	jmp    80105c18 <alltraps>

801061ab <vector20>:
801061ab:	6a 00                	push   $0x0
801061ad:	6a 14                	push   $0x14
801061af:	e9 64 fa ff ff       	jmp    80105c18 <alltraps>

801061b4 <vector21>:
801061b4:	6a 00                	push   $0x0
801061b6:	6a 15                	push   $0x15
801061b8:	e9 5b fa ff ff       	jmp    80105c18 <alltraps>

801061bd <vector22>:
801061bd:	6a 00                	push   $0x0
801061bf:	6a 16                	push   $0x16
801061c1:	e9 52 fa ff ff       	jmp    80105c18 <alltraps>

801061c6 <vector23>:
801061c6:	6a 00                	push   $0x0
801061c8:	6a 17                	push   $0x17
801061ca:	e9 49 fa ff ff       	jmp    80105c18 <alltraps>

801061cf <vector24>:
801061cf:	6a 00                	push   $0x0
801061d1:	6a 18                	push   $0x18
801061d3:	e9 40 fa ff ff       	jmp    80105c18 <alltraps>

801061d8 <vector25>:
801061d8:	6a 00                	push   $0x0
801061da:	6a 19                	push   $0x19
801061dc:	e9 37 fa ff ff       	jmp    80105c18 <alltraps>

801061e1 <vector26>:
801061e1:	6a 00                	push   $0x0
801061e3:	6a 1a                	push   $0x1a
801061e5:	e9 2e fa ff ff       	jmp    80105c18 <alltraps>

801061ea <vector27>:
801061ea:	6a 00                	push   $0x0
801061ec:	6a 1b                	push   $0x1b
801061ee:	e9 25 fa ff ff       	jmp    80105c18 <alltraps>

801061f3 <vector28>:
801061f3:	6a 00                	push   $0x0
801061f5:	6a 1c                	push   $0x1c
801061f7:	e9 1c fa ff ff       	jmp    80105c18 <alltraps>

801061fc <vector29>:
801061fc:	6a 00                	push   $0x0
801061fe:	6a 1d                	push   $0x1d
80106200:	e9 13 fa ff ff       	jmp    80105c18 <alltraps>

80106205 <vector30>:
80106205:	6a 00                	push   $0x0
80106207:	6a 1e                	push   $0x1e
80106209:	e9 0a fa ff ff       	jmp    80105c18 <alltraps>

8010620e <vector31>:
8010620e:	6a 00                	push   $0x0
80106210:	6a 1f                	push   $0x1f
80106212:	e9 01 fa ff ff       	jmp    80105c18 <alltraps>

80106217 <vector32>:
80106217:	6a 00                	push   $0x0
80106219:	6a 20                	push   $0x20
8010621b:	e9 f8 f9 ff ff       	jmp    80105c18 <alltraps>

80106220 <vector33>:
80106220:	6a 00                	push   $0x0
80106222:	6a 21                	push   $0x21
80106224:	e9 ef f9 ff ff       	jmp    80105c18 <alltraps>

80106229 <vector34>:
80106229:	6a 00                	push   $0x0
8010622b:	6a 22                	push   $0x22
8010622d:	e9 e6 f9 ff ff       	jmp    80105c18 <alltraps>

80106232 <vector35>:
80106232:	6a 00                	push   $0x0
80106234:	6a 23                	push   $0x23
80106236:	e9 dd f9 ff ff       	jmp    80105c18 <alltraps>

8010623b <vector36>:
8010623b:	6a 00                	push   $0x0
8010623d:	6a 24                	push   $0x24
8010623f:	e9 d4 f9 ff ff       	jmp    80105c18 <alltraps>

80106244 <vector37>:
80106244:	6a 00                	push   $0x0
80106246:	6a 25                	push   $0x25
80106248:	e9 cb f9 ff ff       	jmp    80105c18 <alltraps>

8010624d <vector38>:
8010624d:	6a 00                	push   $0x0
8010624f:	6a 26                	push   $0x26
80106251:	e9 c2 f9 ff ff       	jmp    80105c18 <alltraps>

80106256 <vector39>:
80106256:	6a 00                	push   $0x0
80106258:	6a 27                	push   $0x27
8010625a:	e9 b9 f9 ff ff       	jmp    80105c18 <alltraps>

8010625f <vector40>:
8010625f:	6a 00                	push   $0x0
80106261:	6a 28                	push   $0x28
80106263:	e9 b0 f9 ff ff       	jmp    80105c18 <alltraps>

80106268 <vector41>:
80106268:	6a 00                	push   $0x0
8010626a:	6a 29                	push   $0x29
8010626c:	e9 a7 f9 ff ff       	jmp    80105c18 <alltraps>

80106271 <vector42>:
80106271:	6a 00                	push   $0x0
80106273:	6a 2a                	push   $0x2a
80106275:	e9 9e f9 ff ff       	jmp    80105c18 <alltraps>

8010627a <vector43>:
8010627a:	6a 00                	push   $0x0
8010627c:	6a 2b                	push   $0x2b
8010627e:	e9 95 f9 ff ff       	jmp    80105c18 <alltraps>

80106283 <vector44>:
80106283:	6a 00                	push   $0x0
80106285:	6a 2c                	push   $0x2c
80106287:	e9 8c f9 ff ff       	jmp    80105c18 <alltraps>

8010628c <vector45>:
8010628c:	6a 00                	push   $0x0
8010628e:	6a 2d                	push   $0x2d
80106290:	e9 83 f9 ff ff       	jmp    80105c18 <alltraps>

80106295 <vector46>:
80106295:	6a 00                	push   $0x0
80106297:	6a 2e                	push   $0x2e
80106299:	e9 7a f9 ff ff       	jmp    80105c18 <alltraps>

8010629e <vector47>:
8010629e:	6a 00                	push   $0x0
801062a0:	6a 2f                	push   $0x2f
801062a2:	e9 71 f9 ff ff       	jmp    80105c18 <alltraps>

801062a7 <vector48>:
801062a7:	6a 00                	push   $0x0
801062a9:	6a 30                	push   $0x30
801062ab:	e9 68 f9 ff ff       	jmp    80105c18 <alltraps>

801062b0 <vector49>:
801062b0:	6a 00                	push   $0x0
801062b2:	6a 31                	push   $0x31
801062b4:	e9 5f f9 ff ff       	jmp    80105c18 <alltraps>

801062b9 <vector50>:
801062b9:	6a 00                	push   $0x0
801062bb:	6a 32                	push   $0x32
801062bd:	e9 56 f9 ff ff       	jmp    80105c18 <alltraps>

801062c2 <vector51>:
801062c2:	6a 00                	push   $0x0
801062c4:	6a 33                	push   $0x33
801062c6:	e9 4d f9 ff ff       	jmp    80105c18 <alltraps>

801062cb <vector52>:
801062cb:	6a 00                	push   $0x0
801062cd:	6a 34                	push   $0x34
801062cf:	e9 44 f9 ff ff       	jmp    80105c18 <alltraps>

801062d4 <vector53>:
801062d4:	6a 00                	push   $0x0
801062d6:	6a 35                	push   $0x35
801062d8:	e9 3b f9 ff ff       	jmp    80105c18 <alltraps>

801062dd <vector54>:
801062dd:	6a 00                	push   $0x0
801062df:	6a 36                	push   $0x36
801062e1:	e9 32 f9 ff ff       	jmp    80105c18 <alltraps>

801062e6 <vector55>:
801062e6:	6a 00                	push   $0x0
801062e8:	6a 37                	push   $0x37
801062ea:	e9 29 f9 ff ff       	jmp    80105c18 <alltraps>

801062ef <vector56>:
801062ef:	6a 00                	push   $0x0
801062f1:	6a 38                	push   $0x38
801062f3:	e9 20 f9 ff ff       	jmp    80105c18 <alltraps>

801062f8 <vector57>:
801062f8:	6a 00                	push   $0x0
801062fa:	6a 39                	push   $0x39
801062fc:	e9 17 f9 ff ff       	jmp    80105c18 <alltraps>

80106301 <vector58>:
80106301:	6a 00                	push   $0x0
80106303:	6a 3a                	push   $0x3a
80106305:	e9 0e f9 ff ff       	jmp    80105c18 <alltraps>

8010630a <vector59>:
8010630a:	6a 00                	push   $0x0
8010630c:	6a 3b                	push   $0x3b
8010630e:	e9 05 f9 ff ff       	jmp    80105c18 <alltraps>

80106313 <vector60>:
80106313:	6a 00                	push   $0x0
80106315:	6a 3c                	push   $0x3c
80106317:	e9 fc f8 ff ff       	jmp    80105c18 <alltraps>

8010631c <vector61>:
8010631c:	6a 00                	push   $0x0
8010631e:	6a 3d                	push   $0x3d
80106320:	e9 f3 f8 ff ff       	jmp    80105c18 <alltraps>

80106325 <vector62>:
80106325:	6a 00                	push   $0x0
80106327:	6a 3e                	push   $0x3e
80106329:	e9 ea f8 ff ff       	jmp    80105c18 <alltraps>

8010632e <vector63>:
8010632e:	6a 00                	push   $0x0
80106330:	6a 3f                	push   $0x3f
80106332:	e9 e1 f8 ff ff       	jmp    80105c18 <alltraps>

80106337 <vector64>:
80106337:	6a 00                	push   $0x0
80106339:	6a 40                	push   $0x40
8010633b:	e9 d8 f8 ff ff       	jmp    80105c18 <alltraps>

80106340 <vector65>:
80106340:	6a 00                	push   $0x0
80106342:	6a 41                	push   $0x41
80106344:	e9 cf f8 ff ff       	jmp    80105c18 <alltraps>

80106349 <vector66>:
80106349:	6a 00                	push   $0x0
8010634b:	6a 42                	push   $0x42
8010634d:	e9 c6 f8 ff ff       	jmp    80105c18 <alltraps>

80106352 <vector67>:
80106352:	6a 00                	push   $0x0
80106354:	6a 43                	push   $0x43
80106356:	e9 bd f8 ff ff       	jmp    80105c18 <alltraps>

8010635b <vector68>:
8010635b:	6a 00                	push   $0x0
8010635d:	6a 44                	push   $0x44
8010635f:	e9 b4 f8 ff ff       	jmp    80105c18 <alltraps>

80106364 <vector69>:
80106364:	6a 00                	push   $0x0
80106366:	6a 45                	push   $0x45
80106368:	e9 ab f8 ff ff       	jmp    80105c18 <alltraps>

8010636d <vector70>:
8010636d:	6a 00                	push   $0x0
8010636f:	6a 46                	push   $0x46
80106371:	e9 a2 f8 ff ff       	jmp    80105c18 <alltraps>

80106376 <vector71>:
80106376:	6a 00                	push   $0x0
80106378:	6a 47                	push   $0x47
8010637a:	e9 99 f8 ff ff       	jmp    80105c18 <alltraps>

8010637f <vector72>:
8010637f:	6a 00                	push   $0x0
80106381:	6a 48                	push   $0x48
80106383:	e9 90 f8 ff ff       	jmp    80105c18 <alltraps>

80106388 <vector73>:
80106388:	6a 00                	push   $0x0
8010638a:	6a 49                	push   $0x49
8010638c:	e9 87 f8 ff ff       	jmp    80105c18 <alltraps>

80106391 <vector74>:
80106391:	6a 00                	push   $0x0
80106393:	6a 4a                	push   $0x4a
80106395:	e9 7e f8 ff ff       	jmp    80105c18 <alltraps>

8010639a <vector75>:
8010639a:	6a 00                	push   $0x0
8010639c:	6a 4b                	push   $0x4b
8010639e:	e9 75 f8 ff ff       	jmp    80105c18 <alltraps>

801063a3 <vector76>:
801063a3:	6a 00                	push   $0x0
801063a5:	6a 4c                	push   $0x4c
801063a7:	e9 6c f8 ff ff       	jmp    80105c18 <alltraps>

801063ac <vector77>:
801063ac:	6a 00                	push   $0x0
801063ae:	6a 4d                	push   $0x4d
801063b0:	e9 63 f8 ff ff       	jmp    80105c18 <alltraps>

801063b5 <vector78>:
801063b5:	6a 00                	push   $0x0
801063b7:	6a 4e                	push   $0x4e
801063b9:	e9 5a f8 ff ff       	jmp    80105c18 <alltraps>

801063be <vector79>:
801063be:	6a 00                	push   $0x0
801063c0:	6a 4f                	push   $0x4f
801063c2:	e9 51 f8 ff ff       	jmp    80105c18 <alltraps>

801063c7 <vector80>:
801063c7:	6a 00                	push   $0x0
801063c9:	6a 50                	push   $0x50
801063cb:	e9 48 f8 ff ff       	jmp    80105c18 <alltraps>

801063d0 <vector81>:
801063d0:	6a 00                	push   $0x0
801063d2:	6a 51                	push   $0x51
801063d4:	e9 3f f8 ff ff       	jmp    80105c18 <alltraps>

801063d9 <vector82>:
801063d9:	6a 00                	push   $0x0
801063db:	6a 52                	push   $0x52
801063dd:	e9 36 f8 ff ff       	jmp    80105c18 <alltraps>

801063e2 <vector83>:
801063e2:	6a 00                	push   $0x0
801063e4:	6a 53                	push   $0x53
801063e6:	e9 2d f8 ff ff       	jmp    80105c18 <alltraps>

801063eb <vector84>:
801063eb:	6a 00                	push   $0x0
801063ed:	6a 54                	push   $0x54
801063ef:	e9 24 f8 ff ff       	jmp    80105c18 <alltraps>

801063f4 <vector85>:
801063f4:	6a 00                	push   $0x0
801063f6:	6a 55                	push   $0x55
801063f8:	e9 1b f8 ff ff       	jmp    80105c18 <alltraps>

801063fd <vector86>:
801063fd:	6a 00                	push   $0x0
801063ff:	6a 56                	push   $0x56
80106401:	e9 12 f8 ff ff       	jmp    80105c18 <alltraps>

80106406 <vector87>:
80106406:	6a 00                	push   $0x0
80106408:	6a 57                	push   $0x57
8010640a:	e9 09 f8 ff ff       	jmp    80105c18 <alltraps>

8010640f <vector88>:
8010640f:	6a 00                	push   $0x0
80106411:	6a 58                	push   $0x58
80106413:	e9 00 f8 ff ff       	jmp    80105c18 <alltraps>

80106418 <vector89>:
80106418:	6a 00                	push   $0x0
8010641a:	6a 59                	push   $0x59
8010641c:	e9 f7 f7 ff ff       	jmp    80105c18 <alltraps>

80106421 <vector90>:
80106421:	6a 00                	push   $0x0
80106423:	6a 5a                	push   $0x5a
80106425:	e9 ee f7 ff ff       	jmp    80105c18 <alltraps>

8010642a <vector91>:
8010642a:	6a 00                	push   $0x0
8010642c:	6a 5b                	push   $0x5b
8010642e:	e9 e5 f7 ff ff       	jmp    80105c18 <alltraps>

80106433 <vector92>:
80106433:	6a 00                	push   $0x0
80106435:	6a 5c                	push   $0x5c
80106437:	e9 dc f7 ff ff       	jmp    80105c18 <alltraps>

8010643c <vector93>:
8010643c:	6a 00                	push   $0x0
8010643e:	6a 5d                	push   $0x5d
80106440:	e9 d3 f7 ff ff       	jmp    80105c18 <alltraps>

80106445 <vector94>:
80106445:	6a 00                	push   $0x0
80106447:	6a 5e                	push   $0x5e
80106449:	e9 ca f7 ff ff       	jmp    80105c18 <alltraps>

8010644e <vector95>:
8010644e:	6a 00                	push   $0x0
80106450:	6a 5f                	push   $0x5f
80106452:	e9 c1 f7 ff ff       	jmp    80105c18 <alltraps>

80106457 <vector96>:
80106457:	6a 00                	push   $0x0
80106459:	6a 60                	push   $0x60
8010645b:	e9 b8 f7 ff ff       	jmp    80105c18 <alltraps>

80106460 <vector97>:
80106460:	6a 00                	push   $0x0
80106462:	6a 61                	push   $0x61
80106464:	e9 af f7 ff ff       	jmp    80105c18 <alltraps>

80106469 <vector98>:
80106469:	6a 00                	push   $0x0
8010646b:	6a 62                	push   $0x62
8010646d:	e9 a6 f7 ff ff       	jmp    80105c18 <alltraps>

80106472 <vector99>:
80106472:	6a 00                	push   $0x0
80106474:	6a 63                	push   $0x63
80106476:	e9 9d f7 ff ff       	jmp    80105c18 <alltraps>

8010647b <vector100>:
8010647b:	6a 00                	push   $0x0
8010647d:	6a 64                	push   $0x64
8010647f:	e9 94 f7 ff ff       	jmp    80105c18 <alltraps>

80106484 <vector101>:
80106484:	6a 00                	push   $0x0
80106486:	6a 65                	push   $0x65
80106488:	e9 8b f7 ff ff       	jmp    80105c18 <alltraps>

8010648d <vector102>:
8010648d:	6a 00                	push   $0x0
8010648f:	6a 66                	push   $0x66
80106491:	e9 82 f7 ff ff       	jmp    80105c18 <alltraps>

80106496 <vector103>:
80106496:	6a 00                	push   $0x0
80106498:	6a 67                	push   $0x67
8010649a:	e9 79 f7 ff ff       	jmp    80105c18 <alltraps>

8010649f <vector104>:
8010649f:	6a 00                	push   $0x0
801064a1:	6a 68                	push   $0x68
801064a3:	e9 70 f7 ff ff       	jmp    80105c18 <alltraps>

801064a8 <vector105>:
801064a8:	6a 00                	push   $0x0
801064aa:	6a 69                	push   $0x69
801064ac:	e9 67 f7 ff ff       	jmp    80105c18 <alltraps>

801064b1 <vector106>:
801064b1:	6a 00                	push   $0x0
801064b3:	6a 6a                	push   $0x6a
801064b5:	e9 5e f7 ff ff       	jmp    80105c18 <alltraps>

801064ba <vector107>:
801064ba:	6a 00                	push   $0x0
801064bc:	6a 6b                	push   $0x6b
801064be:	e9 55 f7 ff ff       	jmp    80105c18 <alltraps>

801064c3 <vector108>:
801064c3:	6a 00                	push   $0x0
801064c5:	6a 6c                	push   $0x6c
801064c7:	e9 4c f7 ff ff       	jmp    80105c18 <alltraps>

801064cc <vector109>:
801064cc:	6a 00                	push   $0x0
801064ce:	6a 6d                	push   $0x6d
801064d0:	e9 43 f7 ff ff       	jmp    80105c18 <alltraps>

801064d5 <vector110>:
801064d5:	6a 00                	push   $0x0
801064d7:	6a 6e                	push   $0x6e
801064d9:	e9 3a f7 ff ff       	jmp    80105c18 <alltraps>

801064de <vector111>:
801064de:	6a 00                	push   $0x0
801064e0:	6a 6f                	push   $0x6f
801064e2:	e9 31 f7 ff ff       	jmp    80105c18 <alltraps>

801064e7 <vector112>:
801064e7:	6a 00                	push   $0x0
801064e9:	6a 70                	push   $0x70
801064eb:	e9 28 f7 ff ff       	jmp    80105c18 <alltraps>

801064f0 <vector113>:
801064f0:	6a 00                	push   $0x0
801064f2:	6a 71                	push   $0x71
801064f4:	e9 1f f7 ff ff       	jmp    80105c18 <alltraps>

801064f9 <vector114>:
801064f9:	6a 00                	push   $0x0
801064fb:	6a 72                	push   $0x72
801064fd:	e9 16 f7 ff ff       	jmp    80105c18 <alltraps>

80106502 <vector115>:
80106502:	6a 00                	push   $0x0
80106504:	6a 73                	push   $0x73
80106506:	e9 0d f7 ff ff       	jmp    80105c18 <alltraps>

8010650b <vector116>:
8010650b:	6a 00                	push   $0x0
8010650d:	6a 74                	push   $0x74
8010650f:	e9 04 f7 ff ff       	jmp    80105c18 <alltraps>

80106514 <vector117>:
80106514:	6a 00                	push   $0x0
80106516:	6a 75                	push   $0x75
80106518:	e9 fb f6 ff ff       	jmp    80105c18 <alltraps>

8010651d <vector118>:
8010651d:	6a 00                	push   $0x0
8010651f:	6a 76                	push   $0x76
80106521:	e9 f2 f6 ff ff       	jmp    80105c18 <alltraps>

80106526 <vector119>:
80106526:	6a 00                	push   $0x0
80106528:	6a 77                	push   $0x77
8010652a:	e9 e9 f6 ff ff       	jmp    80105c18 <alltraps>

8010652f <vector120>:
8010652f:	6a 00                	push   $0x0
80106531:	6a 78                	push   $0x78
80106533:	e9 e0 f6 ff ff       	jmp    80105c18 <alltraps>

80106538 <vector121>:
80106538:	6a 00                	push   $0x0
8010653a:	6a 79                	push   $0x79
8010653c:	e9 d7 f6 ff ff       	jmp    80105c18 <alltraps>

80106541 <vector122>:
80106541:	6a 00                	push   $0x0
80106543:	6a 7a                	push   $0x7a
80106545:	e9 ce f6 ff ff       	jmp    80105c18 <alltraps>

8010654a <vector123>:
8010654a:	6a 00                	push   $0x0
8010654c:	6a 7b                	push   $0x7b
8010654e:	e9 c5 f6 ff ff       	jmp    80105c18 <alltraps>

80106553 <vector124>:
80106553:	6a 00                	push   $0x0
80106555:	6a 7c                	push   $0x7c
80106557:	e9 bc f6 ff ff       	jmp    80105c18 <alltraps>

8010655c <vector125>:
8010655c:	6a 00                	push   $0x0
8010655e:	6a 7d                	push   $0x7d
80106560:	e9 b3 f6 ff ff       	jmp    80105c18 <alltraps>

80106565 <vector126>:
80106565:	6a 00                	push   $0x0
80106567:	6a 7e                	push   $0x7e
80106569:	e9 aa f6 ff ff       	jmp    80105c18 <alltraps>

8010656e <vector127>:
8010656e:	6a 00                	push   $0x0
80106570:	6a 7f                	push   $0x7f
80106572:	e9 a1 f6 ff ff       	jmp    80105c18 <alltraps>

80106577 <vector128>:
80106577:	6a 00                	push   $0x0
80106579:	68 80 00 00 00       	push   $0x80
8010657e:	e9 95 f6 ff ff       	jmp    80105c18 <alltraps>

80106583 <vector129>:
80106583:	6a 00                	push   $0x0
80106585:	68 81 00 00 00       	push   $0x81
8010658a:	e9 89 f6 ff ff       	jmp    80105c18 <alltraps>

8010658f <vector130>:
8010658f:	6a 00                	push   $0x0
80106591:	68 82 00 00 00       	push   $0x82
80106596:	e9 7d f6 ff ff       	jmp    80105c18 <alltraps>

8010659b <vector131>:
8010659b:	6a 00                	push   $0x0
8010659d:	68 83 00 00 00       	push   $0x83
801065a2:	e9 71 f6 ff ff       	jmp    80105c18 <alltraps>

801065a7 <vector132>:
801065a7:	6a 00                	push   $0x0
801065a9:	68 84 00 00 00       	push   $0x84
801065ae:	e9 65 f6 ff ff       	jmp    80105c18 <alltraps>

801065b3 <vector133>:
801065b3:	6a 00                	push   $0x0
801065b5:	68 85 00 00 00       	push   $0x85
801065ba:	e9 59 f6 ff ff       	jmp    80105c18 <alltraps>

801065bf <vector134>:
801065bf:	6a 00                	push   $0x0
801065c1:	68 86 00 00 00       	push   $0x86
801065c6:	e9 4d f6 ff ff       	jmp    80105c18 <alltraps>

801065cb <vector135>:
801065cb:	6a 00                	push   $0x0
801065cd:	68 87 00 00 00       	push   $0x87
801065d2:	e9 41 f6 ff ff       	jmp    80105c18 <alltraps>

801065d7 <vector136>:
801065d7:	6a 00                	push   $0x0
801065d9:	68 88 00 00 00       	push   $0x88
801065de:	e9 35 f6 ff ff       	jmp    80105c18 <alltraps>

801065e3 <vector137>:
801065e3:	6a 00                	push   $0x0
801065e5:	68 89 00 00 00       	push   $0x89
801065ea:	e9 29 f6 ff ff       	jmp    80105c18 <alltraps>

801065ef <vector138>:
801065ef:	6a 00                	push   $0x0
801065f1:	68 8a 00 00 00       	push   $0x8a
801065f6:	e9 1d f6 ff ff       	jmp    80105c18 <alltraps>

801065fb <vector139>:
801065fb:	6a 00                	push   $0x0
801065fd:	68 8b 00 00 00       	push   $0x8b
80106602:	e9 11 f6 ff ff       	jmp    80105c18 <alltraps>

80106607 <vector140>:
80106607:	6a 00                	push   $0x0
80106609:	68 8c 00 00 00       	push   $0x8c
8010660e:	e9 05 f6 ff ff       	jmp    80105c18 <alltraps>

80106613 <vector141>:
80106613:	6a 00                	push   $0x0
80106615:	68 8d 00 00 00       	push   $0x8d
8010661a:	e9 f9 f5 ff ff       	jmp    80105c18 <alltraps>

8010661f <vector142>:
8010661f:	6a 00                	push   $0x0
80106621:	68 8e 00 00 00       	push   $0x8e
80106626:	e9 ed f5 ff ff       	jmp    80105c18 <alltraps>

8010662b <vector143>:
8010662b:	6a 00                	push   $0x0
8010662d:	68 8f 00 00 00       	push   $0x8f
80106632:	e9 e1 f5 ff ff       	jmp    80105c18 <alltraps>

80106637 <vector144>:
80106637:	6a 00                	push   $0x0
80106639:	68 90 00 00 00       	push   $0x90
8010663e:	e9 d5 f5 ff ff       	jmp    80105c18 <alltraps>

80106643 <vector145>:
80106643:	6a 00                	push   $0x0
80106645:	68 91 00 00 00       	push   $0x91
8010664a:	e9 c9 f5 ff ff       	jmp    80105c18 <alltraps>

8010664f <vector146>:
8010664f:	6a 00                	push   $0x0
80106651:	68 92 00 00 00       	push   $0x92
80106656:	e9 bd f5 ff ff       	jmp    80105c18 <alltraps>

8010665b <vector147>:
8010665b:	6a 00                	push   $0x0
8010665d:	68 93 00 00 00       	push   $0x93
80106662:	e9 b1 f5 ff ff       	jmp    80105c18 <alltraps>

80106667 <vector148>:
80106667:	6a 00                	push   $0x0
80106669:	68 94 00 00 00       	push   $0x94
8010666e:	e9 a5 f5 ff ff       	jmp    80105c18 <alltraps>

80106673 <vector149>:
80106673:	6a 00                	push   $0x0
80106675:	68 95 00 00 00       	push   $0x95
8010667a:	e9 99 f5 ff ff       	jmp    80105c18 <alltraps>

8010667f <vector150>:
8010667f:	6a 00                	push   $0x0
80106681:	68 96 00 00 00       	push   $0x96
80106686:	e9 8d f5 ff ff       	jmp    80105c18 <alltraps>

8010668b <vector151>:
8010668b:	6a 00                	push   $0x0
8010668d:	68 97 00 00 00       	push   $0x97
80106692:	e9 81 f5 ff ff       	jmp    80105c18 <alltraps>

80106697 <vector152>:
80106697:	6a 00                	push   $0x0
80106699:	68 98 00 00 00       	push   $0x98
8010669e:	e9 75 f5 ff ff       	jmp    80105c18 <alltraps>

801066a3 <vector153>:
801066a3:	6a 00                	push   $0x0
801066a5:	68 99 00 00 00       	push   $0x99
801066aa:	e9 69 f5 ff ff       	jmp    80105c18 <alltraps>

801066af <vector154>:
801066af:	6a 00                	push   $0x0
801066b1:	68 9a 00 00 00       	push   $0x9a
801066b6:	e9 5d f5 ff ff       	jmp    80105c18 <alltraps>

801066bb <vector155>:
801066bb:	6a 00                	push   $0x0
801066bd:	68 9b 00 00 00       	push   $0x9b
801066c2:	e9 51 f5 ff ff       	jmp    80105c18 <alltraps>

801066c7 <vector156>:
801066c7:	6a 00                	push   $0x0
801066c9:	68 9c 00 00 00       	push   $0x9c
801066ce:	e9 45 f5 ff ff       	jmp    80105c18 <alltraps>

801066d3 <vector157>:
801066d3:	6a 00                	push   $0x0
801066d5:	68 9d 00 00 00       	push   $0x9d
801066da:	e9 39 f5 ff ff       	jmp    80105c18 <alltraps>

801066df <vector158>:
801066df:	6a 00                	push   $0x0
801066e1:	68 9e 00 00 00       	push   $0x9e
801066e6:	e9 2d f5 ff ff       	jmp    80105c18 <alltraps>

801066eb <vector159>:
801066eb:	6a 00                	push   $0x0
801066ed:	68 9f 00 00 00       	push   $0x9f
801066f2:	e9 21 f5 ff ff       	jmp    80105c18 <alltraps>

801066f7 <vector160>:
801066f7:	6a 00                	push   $0x0
801066f9:	68 a0 00 00 00       	push   $0xa0
801066fe:	e9 15 f5 ff ff       	jmp    80105c18 <alltraps>

80106703 <vector161>:
80106703:	6a 00                	push   $0x0
80106705:	68 a1 00 00 00       	push   $0xa1
8010670a:	e9 09 f5 ff ff       	jmp    80105c18 <alltraps>

8010670f <vector162>:
8010670f:	6a 00                	push   $0x0
80106711:	68 a2 00 00 00       	push   $0xa2
80106716:	e9 fd f4 ff ff       	jmp    80105c18 <alltraps>

8010671b <vector163>:
8010671b:	6a 00                	push   $0x0
8010671d:	68 a3 00 00 00       	push   $0xa3
80106722:	e9 f1 f4 ff ff       	jmp    80105c18 <alltraps>

80106727 <vector164>:
80106727:	6a 00                	push   $0x0
80106729:	68 a4 00 00 00       	push   $0xa4
8010672e:	e9 e5 f4 ff ff       	jmp    80105c18 <alltraps>

80106733 <vector165>:
80106733:	6a 00                	push   $0x0
80106735:	68 a5 00 00 00       	push   $0xa5
8010673a:	e9 d9 f4 ff ff       	jmp    80105c18 <alltraps>

8010673f <vector166>:
8010673f:	6a 00                	push   $0x0
80106741:	68 a6 00 00 00       	push   $0xa6
80106746:	e9 cd f4 ff ff       	jmp    80105c18 <alltraps>

8010674b <vector167>:
8010674b:	6a 00                	push   $0x0
8010674d:	68 a7 00 00 00       	push   $0xa7
80106752:	e9 c1 f4 ff ff       	jmp    80105c18 <alltraps>

80106757 <vector168>:
80106757:	6a 00                	push   $0x0
80106759:	68 a8 00 00 00       	push   $0xa8
8010675e:	e9 b5 f4 ff ff       	jmp    80105c18 <alltraps>

80106763 <vector169>:
80106763:	6a 00                	push   $0x0
80106765:	68 a9 00 00 00       	push   $0xa9
8010676a:	e9 a9 f4 ff ff       	jmp    80105c18 <alltraps>

8010676f <vector170>:
8010676f:	6a 00                	push   $0x0
80106771:	68 aa 00 00 00       	push   $0xaa
80106776:	e9 9d f4 ff ff       	jmp    80105c18 <alltraps>

8010677b <vector171>:
8010677b:	6a 00                	push   $0x0
8010677d:	68 ab 00 00 00       	push   $0xab
80106782:	e9 91 f4 ff ff       	jmp    80105c18 <alltraps>

80106787 <vector172>:
80106787:	6a 00                	push   $0x0
80106789:	68 ac 00 00 00       	push   $0xac
8010678e:	e9 85 f4 ff ff       	jmp    80105c18 <alltraps>

80106793 <vector173>:
80106793:	6a 00                	push   $0x0
80106795:	68 ad 00 00 00       	push   $0xad
8010679a:	e9 79 f4 ff ff       	jmp    80105c18 <alltraps>

8010679f <vector174>:
8010679f:	6a 00                	push   $0x0
801067a1:	68 ae 00 00 00       	push   $0xae
801067a6:	e9 6d f4 ff ff       	jmp    80105c18 <alltraps>

801067ab <vector175>:
801067ab:	6a 00                	push   $0x0
801067ad:	68 af 00 00 00       	push   $0xaf
801067b2:	e9 61 f4 ff ff       	jmp    80105c18 <alltraps>

801067b7 <vector176>:
801067b7:	6a 00                	push   $0x0
801067b9:	68 b0 00 00 00       	push   $0xb0
801067be:	e9 55 f4 ff ff       	jmp    80105c18 <alltraps>

801067c3 <vector177>:
801067c3:	6a 00                	push   $0x0
801067c5:	68 b1 00 00 00       	push   $0xb1
801067ca:	e9 49 f4 ff ff       	jmp    80105c18 <alltraps>

801067cf <vector178>:
801067cf:	6a 00                	push   $0x0
801067d1:	68 b2 00 00 00       	push   $0xb2
801067d6:	e9 3d f4 ff ff       	jmp    80105c18 <alltraps>

801067db <vector179>:
801067db:	6a 00                	push   $0x0
801067dd:	68 b3 00 00 00       	push   $0xb3
801067e2:	e9 31 f4 ff ff       	jmp    80105c18 <alltraps>

801067e7 <vector180>:
801067e7:	6a 00                	push   $0x0
801067e9:	68 b4 00 00 00       	push   $0xb4
801067ee:	e9 25 f4 ff ff       	jmp    80105c18 <alltraps>

801067f3 <vector181>:
801067f3:	6a 00                	push   $0x0
801067f5:	68 b5 00 00 00       	push   $0xb5
801067fa:	e9 19 f4 ff ff       	jmp    80105c18 <alltraps>

801067ff <vector182>:
801067ff:	6a 00                	push   $0x0
80106801:	68 b6 00 00 00       	push   $0xb6
80106806:	e9 0d f4 ff ff       	jmp    80105c18 <alltraps>

8010680b <vector183>:
8010680b:	6a 00                	push   $0x0
8010680d:	68 b7 00 00 00       	push   $0xb7
80106812:	e9 01 f4 ff ff       	jmp    80105c18 <alltraps>

80106817 <vector184>:
80106817:	6a 00                	push   $0x0
80106819:	68 b8 00 00 00       	push   $0xb8
8010681e:	e9 f5 f3 ff ff       	jmp    80105c18 <alltraps>

80106823 <vector185>:
80106823:	6a 00                	push   $0x0
80106825:	68 b9 00 00 00       	push   $0xb9
8010682a:	e9 e9 f3 ff ff       	jmp    80105c18 <alltraps>

8010682f <vector186>:
8010682f:	6a 00                	push   $0x0
80106831:	68 ba 00 00 00       	push   $0xba
80106836:	e9 dd f3 ff ff       	jmp    80105c18 <alltraps>

8010683b <vector187>:
8010683b:	6a 00                	push   $0x0
8010683d:	68 bb 00 00 00       	push   $0xbb
80106842:	e9 d1 f3 ff ff       	jmp    80105c18 <alltraps>

80106847 <vector188>:
80106847:	6a 00                	push   $0x0
80106849:	68 bc 00 00 00       	push   $0xbc
8010684e:	e9 c5 f3 ff ff       	jmp    80105c18 <alltraps>

80106853 <vector189>:
80106853:	6a 00                	push   $0x0
80106855:	68 bd 00 00 00       	push   $0xbd
8010685a:	e9 b9 f3 ff ff       	jmp    80105c18 <alltraps>

8010685f <vector190>:
8010685f:	6a 00                	push   $0x0
80106861:	68 be 00 00 00       	push   $0xbe
80106866:	e9 ad f3 ff ff       	jmp    80105c18 <alltraps>

8010686b <vector191>:
8010686b:	6a 00                	push   $0x0
8010686d:	68 bf 00 00 00       	push   $0xbf
80106872:	e9 a1 f3 ff ff       	jmp    80105c18 <alltraps>

80106877 <vector192>:
80106877:	6a 00                	push   $0x0
80106879:	68 c0 00 00 00       	push   $0xc0
8010687e:	e9 95 f3 ff ff       	jmp    80105c18 <alltraps>

80106883 <vector193>:
80106883:	6a 00                	push   $0x0
80106885:	68 c1 00 00 00       	push   $0xc1
8010688a:	e9 89 f3 ff ff       	jmp    80105c18 <alltraps>

8010688f <vector194>:
8010688f:	6a 00                	push   $0x0
80106891:	68 c2 00 00 00       	push   $0xc2
80106896:	e9 7d f3 ff ff       	jmp    80105c18 <alltraps>

8010689b <vector195>:
8010689b:	6a 00                	push   $0x0
8010689d:	68 c3 00 00 00       	push   $0xc3
801068a2:	e9 71 f3 ff ff       	jmp    80105c18 <alltraps>

801068a7 <vector196>:
801068a7:	6a 00                	push   $0x0
801068a9:	68 c4 00 00 00       	push   $0xc4
801068ae:	e9 65 f3 ff ff       	jmp    80105c18 <alltraps>

801068b3 <vector197>:
801068b3:	6a 00                	push   $0x0
801068b5:	68 c5 00 00 00       	push   $0xc5
801068ba:	e9 59 f3 ff ff       	jmp    80105c18 <alltraps>

801068bf <vector198>:
801068bf:	6a 00                	push   $0x0
801068c1:	68 c6 00 00 00       	push   $0xc6
801068c6:	e9 4d f3 ff ff       	jmp    80105c18 <alltraps>

801068cb <vector199>:
801068cb:	6a 00                	push   $0x0
801068cd:	68 c7 00 00 00       	push   $0xc7
801068d2:	e9 41 f3 ff ff       	jmp    80105c18 <alltraps>

801068d7 <vector200>:
801068d7:	6a 00                	push   $0x0
801068d9:	68 c8 00 00 00       	push   $0xc8
801068de:	e9 35 f3 ff ff       	jmp    80105c18 <alltraps>

801068e3 <vector201>:
801068e3:	6a 00                	push   $0x0
801068e5:	68 c9 00 00 00       	push   $0xc9
801068ea:	e9 29 f3 ff ff       	jmp    80105c18 <alltraps>

801068ef <vector202>:
801068ef:	6a 00                	push   $0x0
801068f1:	68 ca 00 00 00       	push   $0xca
801068f6:	e9 1d f3 ff ff       	jmp    80105c18 <alltraps>

801068fb <vector203>:
801068fb:	6a 00                	push   $0x0
801068fd:	68 cb 00 00 00       	push   $0xcb
80106902:	e9 11 f3 ff ff       	jmp    80105c18 <alltraps>

80106907 <vector204>:
80106907:	6a 00                	push   $0x0
80106909:	68 cc 00 00 00       	push   $0xcc
8010690e:	e9 05 f3 ff ff       	jmp    80105c18 <alltraps>

80106913 <vector205>:
80106913:	6a 00                	push   $0x0
80106915:	68 cd 00 00 00       	push   $0xcd
8010691a:	e9 f9 f2 ff ff       	jmp    80105c18 <alltraps>

8010691f <vector206>:
8010691f:	6a 00                	push   $0x0
80106921:	68 ce 00 00 00       	push   $0xce
80106926:	e9 ed f2 ff ff       	jmp    80105c18 <alltraps>

8010692b <vector207>:
8010692b:	6a 00                	push   $0x0
8010692d:	68 cf 00 00 00       	push   $0xcf
80106932:	e9 e1 f2 ff ff       	jmp    80105c18 <alltraps>

80106937 <vector208>:
80106937:	6a 00                	push   $0x0
80106939:	68 d0 00 00 00       	push   $0xd0
8010693e:	e9 d5 f2 ff ff       	jmp    80105c18 <alltraps>

80106943 <vector209>:
80106943:	6a 00                	push   $0x0
80106945:	68 d1 00 00 00       	push   $0xd1
8010694a:	e9 c9 f2 ff ff       	jmp    80105c18 <alltraps>

8010694f <vector210>:
8010694f:	6a 00                	push   $0x0
80106951:	68 d2 00 00 00       	push   $0xd2
80106956:	e9 bd f2 ff ff       	jmp    80105c18 <alltraps>

8010695b <vector211>:
8010695b:	6a 00                	push   $0x0
8010695d:	68 d3 00 00 00       	push   $0xd3
80106962:	e9 b1 f2 ff ff       	jmp    80105c18 <alltraps>

80106967 <vector212>:
80106967:	6a 00                	push   $0x0
80106969:	68 d4 00 00 00       	push   $0xd4
8010696e:	e9 a5 f2 ff ff       	jmp    80105c18 <alltraps>

80106973 <vector213>:
80106973:	6a 00                	push   $0x0
80106975:	68 d5 00 00 00       	push   $0xd5
8010697a:	e9 99 f2 ff ff       	jmp    80105c18 <alltraps>

8010697f <vector214>:
8010697f:	6a 00                	push   $0x0
80106981:	68 d6 00 00 00       	push   $0xd6
80106986:	e9 8d f2 ff ff       	jmp    80105c18 <alltraps>

8010698b <vector215>:
8010698b:	6a 00                	push   $0x0
8010698d:	68 d7 00 00 00       	push   $0xd7
80106992:	e9 81 f2 ff ff       	jmp    80105c18 <alltraps>

80106997 <vector216>:
80106997:	6a 00                	push   $0x0
80106999:	68 d8 00 00 00       	push   $0xd8
8010699e:	e9 75 f2 ff ff       	jmp    80105c18 <alltraps>

801069a3 <vector217>:
801069a3:	6a 00                	push   $0x0
801069a5:	68 d9 00 00 00       	push   $0xd9
801069aa:	e9 69 f2 ff ff       	jmp    80105c18 <alltraps>

801069af <vector218>:
801069af:	6a 00                	push   $0x0
801069b1:	68 da 00 00 00       	push   $0xda
801069b6:	e9 5d f2 ff ff       	jmp    80105c18 <alltraps>

801069bb <vector219>:
801069bb:	6a 00                	push   $0x0
801069bd:	68 db 00 00 00       	push   $0xdb
801069c2:	e9 51 f2 ff ff       	jmp    80105c18 <alltraps>

801069c7 <vector220>:
801069c7:	6a 00                	push   $0x0
801069c9:	68 dc 00 00 00       	push   $0xdc
801069ce:	e9 45 f2 ff ff       	jmp    80105c18 <alltraps>

801069d3 <vector221>:
801069d3:	6a 00                	push   $0x0
801069d5:	68 dd 00 00 00       	push   $0xdd
801069da:	e9 39 f2 ff ff       	jmp    80105c18 <alltraps>

801069df <vector222>:
801069df:	6a 00                	push   $0x0
801069e1:	68 de 00 00 00       	push   $0xde
801069e6:	e9 2d f2 ff ff       	jmp    80105c18 <alltraps>

801069eb <vector223>:
801069eb:	6a 00                	push   $0x0
801069ed:	68 df 00 00 00       	push   $0xdf
801069f2:	e9 21 f2 ff ff       	jmp    80105c18 <alltraps>

801069f7 <vector224>:
801069f7:	6a 00                	push   $0x0
801069f9:	68 e0 00 00 00       	push   $0xe0
801069fe:	e9 15 f2 ff ff       	jmp    80105c18 <alltraps>

80106a03 <vector225>:
80106a03:	6a 00                	push   $0x0
80106a05:	68 e1 00 00 00       	push   $0xe1
80106a0a:	e9 09 f2 ff ff       	jmp    80105c18 <alltraps>

80106a0f <vector226>:
80106a0f:	6a 00                	push   $0x0
80106a11:	68 e2 00 00 00       	push   $0xe2
80106a16:	e9 fd f1 ff ff       	jmp    80105c18 <alltraps>

80106a1b <vector227>:
80106a1b:	6a 00                	push   $0x0
80106a1d:	68 e3 00 00 00       	push   $0xe3
80106a22:	e9 f1 f1 ff ff       	jmp    80105c18 <alltraps>

80106a27 <vector228>:
80106a27:	6a 00                	push   $0x0
80106a29:	68 e4 00 00 00       	push   $0xe4
80106a2e:	e9 e5 f1 ff ff       	jmp    80105c18 <alltraps>

80106a33 <vector229>:
80106a33:	6a 00                	push   $0x0
80106a35:	68 e5 00 00 00       	push   $0xe5
80106a3a:	e9 d9 f1 ff ff       	jmp    80105c18 <alltraps>

80106a3f <vector230>:
80106a3f:	6a 00                	push   $0x0
80106a41:	68 e6 00 00 00       	push   $0xe6
80106a46:	e9 cd f1 ff ff       	jmp    80105c18 <alltraps>

80106a4b <vector231>:
80106a4b:	6a 00                	push   $0x0
80106a4d:	68 e7 00 00 00       	push   $0xe7
80106a52:	e9 c1 f1 ff ff       	jmp    80105c18 <alltraps>

80106a57 <vector232>:
80106a57:	6a 00                	push   $0x0
80106a59:	68 e8 00 00 00       	push   $0xe8
80106a5e:	e9 b5 f1 ff ff       	jmp    80105c18 <alltraps>

80106a63 <vector233>:
80106a63:	6a 00                	push   $0x0
80106a65:	68 e9 00 00 00       	push   $0xe9
80106a6a:	e9 a9 f1 ff ff       	jmp    80105c18 <alltraps>

80106a6f <vector234>:
80106a6f:	6a 00                	push   $0x0
80106a71:	68 ea 00 00 00       	push   $0xea
80106a76:	e9 9d f1 ff ff       	jmp    80105c18 <alltraps>

80106a7b <vector235>:
80106a7b:	6a 00                	push   $0x0
80106a7d:	68 eb 00 00 00       	push   $0xeb
80106a82:	e9 91 f1 ff ff       	jmp    80105c18 <alltraps>

80106a87 <vector236>:
80106a87:	6a 00                	push   $0x0
80106a89:	68 ec 00 00 00       	push   $0xec
80106a8e:	e9 85 f1 ff ff       	jmp    80105c18 <alltraps>

80106a93 <vector237>:
80106a93:	6a 00                	push   $0x0
80106a95:	68 ed 00 00 00       	push   $0xed
80106a9a:	e9 79 f1 ff ff       	jmp    80105c18 <alltraps>

80106a9f <vector238>:
80106a9f:	6a 00                	push   $0x0
80106aa1:	68 ee 00 00 00       	push   $0xee
80106aa6:	e9 6d f1 ff ff       	jmp    80105c18 <alltraps>

80106aab <vector239>:
80106aab:	6a 00                	push   $0x0
80106aad:	68 ef 00 00 00       	push   $0xef
80106ab2:	e9 61 f1 ff ff       	jmp    80105c18 <alltraps>

80106ab7 <vector240>:
80106ab7:	6a 00                	push   $0x0
80106ab9:	68 f0 00 00 00       	push   $0xf0
80106abe:	e9 55 f1 ff ff       	jmp    80105c18 <alltraps>

80106ac3 <vector241>:
80106ac3:	6a 00                	push   $0x0
80106ac5:	68 f1 00 00 00       	push   $0xf1
80106aca:	e9 49 f1 ff ff       	jmp    80105c18 <alltraps>

80106acf <vector242>:
80106acf:	6a 00                	push   $0x0
80106ad1:	68 f2 00 00 00       	push   $0xf2
80106ad6:	e9 3d f1 ff ff       	jmp    80105c18 <alltraps>

80106adb <vector243>:
80106adb:	6a 00                	push   $0x0
80106add:	68 f3 00 00 00       	push   $0xf3
80106ae2:	e9 31 f1 ff ff       	jmp    80105c18 <alltraps>

80106ae7 <vector244>:
80106ae7:	6a 00                	push   $0x0
80106ae9:	68 f4 00 00 00       	push   $0xf4
80106aee:	e9 25 f1 ff ff       	jmp    80105c18 <alltraps>

80106af3 <vector245>:
80106af3:	6a 00                	push   $0x0
80106af5:	68 f5 00 00 00       	push   $0xf5
80106afa:	e9 19 f1 ff ff       	jmp    80105c18 <alltraps>

80106aff <vector246>:
80106aff:	6a 00                	push   $0x0
80106b01:	68 f6 00 00 00       	push   $0xf6
80106b06:	e9 0d f1 ff ff       	jmp    80105c18 <alltraps>

80106b0b <vector247>:
80106b0b:	6a 00                	push   $0x0
80106b0d:	68 f7 00 00 00       	push   $0xf7
80106b12:	e9 01 f1 ff ff       	jmp    80105c18 <alltraps>

80106b17 <vector248>:
80106b17:	6a 00                	push   $0x0
80106b19:	68 f8 00 00 00       	push   $0xf8
80106b1e:	e9 f5 f0 ff ff       	jmp    80105c18 <alltraps>

80106b23 <vector249>:
80106b23:	6a 00                	push   $0x0
80106b25:	68 f9 00 00 00       	push   $0xf9
80106b2a:	e9 e9 f0 ff ff       	jmp    80105c18 <alltraps>

80106b2f <vector250>:
80106b2f:	6a 00                	push   $0x0
80106b31:	68 fa 00 00 00       	push   $0xfa
80106b36:	e9 dd f0 ff ff       	jmp    80105c18 <alltraps>

80106b3b <vector251>:
80106b3b:	6a 00                	push   $0x0
80106b3d:	68 fb 00 00 00       	push   $0xfb
80106b42:	e9 d1 f0 ff ff       	jmp    80105c18 <alltraps>

80106b47 <vector252>:
80106b47:	6a 00                	push   $0x0
80106b49:	68 fc 00 00 00       	push   $0xfc
80106b4e:	e9 c5 f0 ff ff       	jmp    80105c18 <alltraps>

80106b53 <vector253>:
80106b53:	6a 00                	push   $0x0
80106b55:	68 fd 00 00 00       	push   $0xfd
80106b5a:	e9 b9 f0 ff ff       	jmp    80105c18 <alltraps>

80106b5f <vector254>:
80106b5f:	6a 00                	push   $0x0
80106b61:	68 fe 00 00 00       	push   $0xfe
80106b66:	e9 ad f0 ff ff       	jmp    80105c18 <alltraps>

80106b6b <vector255>:
80106b6b:	6a 00                	push   $0x0
80106b6d:	68 ff 00 00 00       	push   $0xff
80106b72:	e9 a1 f0 ff ff       	jmp    80105c18 <alltraps>
80106b77:	66 90                	xchg   %ax,%ax
80106b79:	66 90                	xchg   %ax,%ax
80106b7b:	66 90                	xchg   %ax,%ax
80106b7d:	66 90                	xchg   %ax,%ax
80106b7f:	90                   	nop

80106b80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b87:	c1 ea 16             	shr    $0x16,%edx
{
80106b8a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106b8b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106b8e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106b91:	8b 1f                	mov    (%edi),%ebx
80106b93:	f6 c3 01             	test   $0x1,%bl
80106b96:	74 28                	je     80106bc0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106b9e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ba4:	89 f0                	mov    %esi,%eax
}
80106ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106ba9:	c1 e8 0a             	shr    $0xa,%eax
80106bac:	25 fc 0f 00 00       	and    $0xffc,%eax
80106bb1:	01 d8                	add    %ebx,%eax
}
80106bb3:	5b                   	pop    %ebx
80106bb4:	5e                   	pop    %esi
80106bb5:	5f                   	pop    %edi
80106bb6:	5d                   	pop    %ebp
80106bb7:	c3                   	ret    
80106bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bbf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bc0:	85 c9                	test   %ecx,%ecx
80106bc2:	74 2c                	je     80106bf0 <walkpgdir+0x70>
80106bc4:	e8 07 bc ff ff       	call   801027d0 <kalloc>
80106bc9:	89 c3                	mov    %eax,%ebx
80106bcb:	85 c0                	test   %eax,%eax
80106bcd:	74 21                	je     80106bf0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106bcf:	83 ec 04             	sub    $0x4,%esp
80106bd2:	68 00 10 00 00       	push   $0x1000
80106bd7:	6a 00                	push   $0x0
80106bd9:	50                   	push   %eax
80106bda:	e8 e1 dc ff ff       	call   801048c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bdf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106be5:	83 c4 10             	add    $0x10,%esp
80106be8:	83 c8 07             	or     $0x7,%eax
80106beb:	89 07                	mov    %eax,(%edi)
80106bed:	eb b5                	jmp    80106ba4 <walkpgdir+0x24>
80106bef:	90                   	nop
}
80106bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106bf3:	31 c0                	xor    %eax,%eax
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c00 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c00:	55                   	push   %ebp
  // if physical address is in huge range,
  if (pa >= HUGE_PAGE_START && pa <= HUGE_PAGE_END)
  {
    // huge code
    a = (char*)HUGEPGROUNDDOWN((uint)va);
    last = (char*)HUGEPGROUNDDOWN(((uint)va) + size - 1);
80106c01:	8d 4c 0a ff          	lea    -0x1(%edx,%ecx,1),%ecx
{
80106c05:	89 e5                	mov    %esp,%ebp
80106c07:	57                   	push   %edi
80106c08:	89 c7                	mov    %eax,%edi
80106c0a:	56                   	push   %esi
80106c0b:	53                   	push   %ebx
80106c0c:	83 ec 1c             	sub    $0x1c,%esp
80106c0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (pa >= HUGE_PAGE_START && pa <= HUGE_PAGE_END)
80106c12:	8d 83 00 00 00 e2    	lea    -0x1e000000(%ebx),%eax
80106c18:	3d 00 00 00 20       	cmp    $0x20000000,%eax
80106c1d:	77 41                	ja     80106c60 <mappages+0x60>
    a = (char*)HUGEPGROUNDDOWN((uint)va);
80106c1f:	89 d0                	mov    %edx,%eax
    for(;;)
    {
      pde = &pgdir[PDX(va)];
80106c21:	c1 ea 16             	shr    $0x16,%edx
    last = (char*)HUGEPGROUNDDOWN(((uint)va) + size - 1);
80106c24:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
      pde = &pgdir[PDX(va)];
80106c2a:	8d 14 97             	lea    (%edi,%edx,4),%edx
      // mapping to a huge page
      *pde = pa | perm | PTE_P | PTE_PS;
80106c2d:	8b 7d 0c             	mov    0xc(%ebp),%edi
    a = (char*)HUGEPGROUNDDOWN((uint)va);
80106c30:	25 00 00 c0 ff       	and    $0xffc00000,%eax
      *pde = pa | perm | PTE_P | PTE_PS;
80106c35:	09 df                	or     %ebx,%edi
80106c37:	81 cf 81 00 00 00    	or     $0x81,%edi
80106c3d:	89 3a                	mov    %edi,(%edx)
      if(a == last)
80106c3f:	39 c8                	cmp    %ecx,%eax
80106c41:	74 0c                	je     80106c4f <mappages+0x4f>
        break;
      a += HUGE_PAGE_SIZE;
      pa += HUGE_PAGE_SIZE;
80106c43:	29 c1                	sub    %eax,%ecx
80106c45:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
      *pde = pa | perm | PTE_P | PTE_PS;
80106c48:	0b 45 0c             	or     0xc(%ebp),%eax
80106c4b:	0c 81                	or     $0x81,%al
80106c4d:	89 02                	mov    %eax,(%edx)
      a += PGSIZE;
      pa += PGSIZE;
    }
  }
  return 0;
}
80106c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c52:	31 c0                	xor    %eax,%eax
}
80106c54:	5b                   	pop    %ebx
80106c55:	5e                   	pop    %esi
80106c56:	5f                   	pop    %edi
80106c57:	5d                   	pop    %ebp
80106c58:	c3                   	ret    
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    a = (char*)PGROUNDDOWN((uint)va);
80106c60:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c66:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106c6c:	29 d3                	sub    %edx,%ebx
80106c6e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    a = (char*)PGROUNDDOWN((uint)va);
80106c71:	89 d6                	mov    %edx,%esi
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c73:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106c76:	eb 20                	jmp    80106c98 <mappages+0x98>
80106c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c7f:	90                   	nop
      if(*pte & PTE_P)
80106c80:	f6 00 01             	testb  $0x1,(%eax)
80106c83:	75 38                	jne    80106cbd <mappages+0xbd>
      *pte = pa | perm | PTE_P;
80106c85:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106c88:	83 cb 01             	or     $0x1,%ebx
80106c8b:	89 18                	mov    %ebx,(%eax)
      if(a == last)
80106c8d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106c90:	74 bd                	je     80106c4f <mappages+0x4f>
      a += PGSIZE;
80106c92:	81 c6 00 10 00 00    	add    $0x1000,%esi
    for(;;){
80106c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c9b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106ca0:	89 f2                	mov    %esi,%edx
80106ca2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106ca5:	89 f8                	mov    %edi,%eax
80106ca7:	e8 d4 fe ff ff       	call   80106b80 <walkpgdir>
80106cac:	85 c0                	test   %eax,%eax
80106cae:	75 d0                	jne    80106c80 <mappages+0x80>
}
80106cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80106cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cb8:	5b                   	pop    %ebx
80106cb9:	5e                   	pop    %esi
80106cba:	5f                   	pop    %edi
80106cbb:	5d                   	pop    %ebp
80106cbc:	c3                   	ret    
        panic("remap");
80106cbd:	83 ec 0c             	sub    $0xc,%esp
80106cc0:	68 cc 80 10 80       	push   $0x801080cc
80106cc5:	e8 b6 96 ff ff       	call   80100380 <panic>
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106cd6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106cdc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ce2:	83 ec 1c             	sub    $0x1c,%esp
80106ce5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ce8:	39 d3                	cmp    %edx,%ebx
80106cea:	73 49                	jae    80106d35 <deallocuvm.part.0+0x65>
80106cec:	89 c7                	mov    %eax,%edi
80106cee:	eb 0c                	jmp    80106cfc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cf0:	83 c0 01             	add    $0x1,%eax
80106cf3:	c1 e0 16             	shl    $0x16,%eax
80106cf6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cf8:	39 da                	cmp    %ebx,%edx
80106cfa:	76 39                	jbe    80106d35 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106cfc:	89 d8                	mov    %ebx,%eax
80106cfe:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106d01:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106d04:	f6 c1 01             	test   $0x1,%cl
80106d07:	74 e7                	je     80106cf0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106d09:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d0b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d11:	c1 ee 0a             	shr    $0xa,%esi
80106d14:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106d1a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106d21:	85 f6                	test   %esi,%esi
80106d23:	74 cb                	je     80106cf0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106d25:	8b 06                	mov    (%esi),%eax
80106d27:	a8 01                	test   $0x1,%al
80106d29:	75 15                	jne    80106d40 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106d2b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d31:	39 da                	cmp    %ebx,%edx
80106d33:	77 c7                	ja     80106cfc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d3b:	5b                   	pop    %ebx
80106d3c:	5e                   	pop    %esi
80106d3d:	5f                   	pop    %edi
80106d3e:	5d                   	pop    %ebp
80106d3f:	c3                   	ret    
      if(pa == 0)
80106d40:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d45:	74 25                	je     80106d6c <deallocuvm.part.0+0x9c>
      kfree(v);
80106d47:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d4a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d4f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d52:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d58:	50                   	push   %eax
80106d59:	e8 72 b7 ff ff       	call   801024d0 <kfree>
      *pte = 0;
80106d5e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106d64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d67:	83 c4 10             	add    $0x10,%esp
80106d6a:	eb 8c                	jmp    80106cf8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106d6c:	83 ec 0c             	sub    $0xc,%esp
80106d6f:	68 66 7a 10 80       	push   $0x80107a66
80106d74:	e8 07 96 ff ff       	call   80100380 <panic>
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d80 <deallochugeuvm.part.0>:

// TODO: implement this
// part 2
// I havent touched this, only copy paste
int
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	89 d7                	mov    %edx,%edi
80106d86:	56                   	push   %esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = HUGEPGROUNDUP(newsz);
80106d87:	8d b1 ff ff 3f 00    	lea    0x3fffff(%ecx),%esi
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d8d:	53                   	push   %ebx
  a = HUGEPGROUNDUP(newsz);
80106d8e:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d94:	83 ec 1c             	sub    $0x1c,%esp
80106d97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106d9a:	39 d6                	cmp    %edx,%esi
80106d9c:	72 0e                	jb     80106dac <deallochugeuvm.part.0+0x2c>
80106d9e:	eb 3c                	jmp    80106ddc <deallochugeuvm.part.0+0x5c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
80106da0:	83 c1 01             	add    $0x1,%ecx
80106da3:	89 ce                	mov    %ecx,%esi
80106da5:	c1 e6 16             	shl    $0x16,%esi
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106da8:	39 f7                	cmp    %esi,%edi
80106daa:	76 30                	jbe    80106ddc <deallochugeuvm.part.0+0x5c>
  pde = &pgdir[PDX(va)];
80106dac:	89 f1                	mov    %esi,%ecx
80106dae:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106db1:	8b 1c 88             	mov    (%eax,%ecx,4),%ebx
80106db4:	f6 c3 01             	test   $0x1,%bl
80106db7:	74 e7                	je     80106da0 <deallochugeuvm.part.0+0x20>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106db9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(!pte)
80106dbf:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80106dc5:	74 d9                	je     80106da0 <deallochugeuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106dc7:	8b 8b 00 00 00 80    	mov    -0x80000000(%ebx),%ecx
80106dcd:	f6 c1 01             	test   $0x1,%cl
80106dd0:	75 1e                	jne    80106df0 <deallochugeuvm.part.0+0x70>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106dd2:	81 c6 00 00 40 00    	add    $0x400000,%esi
80106dd8:	39 f7                	cmp    %esi,%edi
80106dda:	77 d0                	ja     80106dac <deallochugeuvm.part.0+0x2c>
      khugefree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de2:	5b                   	pop    %ebx
80106de3:	5e                   	pop    %esi
80106de4:	5f                   	pop    %edi
80106de5:	5d                   	pop    %ebp
80106de6:	c3                   	ret    
80106de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dee:	66 90                	xchg   %ax,%ax
      if(pa == 0)
80106df0:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106df6:	74 2a                	je     80106e22 <deallochugeuvm.part.0+0xa2>
      khugefree(v);
80106df8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106dfb:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80106e01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106e04:	81 c6 00 00 40 00    	add    $0x400000,%esi
      khugefree(v);
80106e0a:	51                   	push   %ecx
80106e0b:	e8 80 b8 ff ff       	call   80102690 <khugefree>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e13:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106e16:	c7 83 00 00 00 80 00 	movl   $0x0,-0x80000000(%ebx)
80106e1d:	00 00 00 
80106e20:	eb 86                	jmp    80106da8 <deallochugeuvm.part.0+0x28>
        panic("khugefree");
80106e22:	83 ec 0c             	sub    $0xc,%esp
80106e25:	68 71 7a 10 80       	push   $0x80107a71
80106e2a:	e8 51 95 ff ff       	call   80100380 <panic>
80106e2f:	90                   	nop

80106e30 <seginit>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e36:	e8 e5 cc ff ff       	call   80103b20 <cpuid>
  pd[0] = size-1;
80106e3b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e40:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e46:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e4a:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80106e51:	ff 00 00 
80106e54:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
80106e5b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e5e:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80106e65:	ff 00 00 
80106e68:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
80106e6f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e72:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
80106e79:	ff 00 00 
80106e7c:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
80106e83:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e86:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
80106e8d:	ff 00 00 
80106e90:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
80106e97:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e9a:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
80106e9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ea3:	c1 e8 10             	shr    $0x10,%eax
80106ea6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eaa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ead:	0f 01 10             	lgdtl  (%eax)
}
80106eb0:	c9                   	leave  
80106eb1:	c3                   	ret    
80106eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ec0:	a1 e4 55 11 80       	mov    0x801155e4,%eax
80106ec5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eca:	0f 22 d8             	mov    %eax,%cr3
}
80106ecd:	c3                   	ret    
80106ece:	66 90                	xchg   %ax,%ax

80106ed0 <switchuvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106edc:	85 f6                	test   %esi,%esi
80106ede:	0f 84 cb 00 00 00    	je     80106faf <switchuvm+0xdf>
  if(p->kstack == 0)
80106ee4:	8b 46 0c             	mov    0xc(%esi),%eax
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	0f 84 da 00 00 00    	je     80106fc9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106eef:	8b 46 08             	mov    0x8(%esi),%eax
80106ef2:	85 c0                	test   %eax,%eax
80106ef4:	0f 84 c2 00 00 00    	je     80106fbc <switchuvm+0xec>
  pushcli();
80106efa:	e8 b1 d7 ff ff       	call   801046b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eff:	e8 bc cb ff ff       	call   80103ac0 <mycpu>
80106f04:	89 c3                	mov    %eax,%ebx
80106f06:	e8 b5 cb ff ff       	call   80103ac0 <mycpu>
80106f0b:	89 c7                	mov    %eax,%edi
80106f0d:	e8 ae cb ff ff       	call   80103ac0 <mycpu>
80106f12:	83 c7 08             	add    $0x8,%edi
80106f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f18:	e8 a3 cb ff ff       	call   80103ac0 <mycpu>
80106f1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f20:	ba 67 00 00 00       	mov    $0x67,%edx
80106f25:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f2c:	83 c0 08             	add    $0x8,%eax
80106f2f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f36:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f3b:	83 c1 08             	add    $0x8,%ecx
80106f3e:	c1 e8 18             	shr    $0x18,%eax
80106f41:	c1 e9 10             	shr    $0x10,%ecx
80106f44:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f4a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f50:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f55:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f5c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f61:	e8 5a cb ff ff       	call   80103ac0 <mycpu>
80106f66:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f6d:	e8 4e cb ff ff       	call   80103ac0 <mycpu>
80106f72:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f76:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106f79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f7f:	e8 3c cb ff ff       	call   80103ac0 <mycpu>
80106f84:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f87:	e8 34 cb ff ff       	call   80103ac0 <mycpu>
80106f8c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f90:	b8 28 00 00 00       	mov    $0x28,%eax
80106f95:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f98:	8b 46 08             	mov    0x8(%esi),%eax
80106f9b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fa0:	0f 22 d8             	mov    %eax,%cr3
}
80106fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa6:	5b                   	pop    %ebx
80106fa7:	5e                   	pop    %esi
80106fa8:	5f                   	pop    %edi
80106fa9:	5d                   	pop    %ebp
  popcli();
80106faa:	e9 51 d7 ff ff       	jmp    80104700 <popcli>
    panic("switchuvm: no process");
80106faf:	83 ec 0c             	sub    $0xc,%esp
80106fb2:	68 d2 80 10 80       	push   $0x801080d2
80106fb7:	e8 c4 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106fbc:	83 ec 0c             	sub    $0xc,%esp
80106fbf:	68 fd 80 10 80       	push   $0x801080fd
80106fc4:	e8 b7 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106fc9:	83 ec 0c             	sub    $0xc,%esp
80106fcc:	68 e8 80 10 80       	push   $0x801080e8
80106fd1:	e8 aa 93 ff ff       	call   80100380 <panic>
80106fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi

80106fe0 <inituvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 1c             	sub    $0x1c,%esp
80106fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fec:	8b 75 08             	mov    0x8(%ebp),%esi
80106fef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ff2:	8b 45 10             	mov    0x10(%ebp),%eax
80106ff5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(sz >= PGSIZE)
80106ff8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80106ffd:	77 7d                	ja     8010707c <inituvm+0x9c>
  mem = kalloc();
80106fff:	e8 cc b7 ff ff       	call   801027d0 <kalloc>
  memset(mem, 0, PGSIZE);
80107004:	83 ec 04             	sub    $0x4,%esp
80107007:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010700c:	89 c7                	mov    %eax,%edi
  memset(mem, 0, PGSIZE);
8010700e:	6a 00                	push   $0x0
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107010:	8d 9f 00 00 00 80    	lea    -0x80000000(%edi),%ebx
  memset(mem, 0, PGSIZE);
80107016:	50                   	push   %eax
80107017:	e8 a4 d8 ff ff       	call   801048c0 <memset>
  if (pa >= HUGE_PAGE_START && pa <= HUGE_PAGE_END)
8010701c:	8d 87 00 00 00 62    	lea    0x62000000(%edi),%eax
80107022:	83 c4 10             	add    $0x10,%esp
80107025:	3d 00 00 00 20       	cmp    $0x20000000,%eax
8010702a:	76 3c                	jbe    80107068 <inituvm+0x88>
      if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010702c:	31 d2                	xor    %edx,%edx
8010702e:	b9 01 00 00 00       	mov    $0x1,%ecx
80107033:	89 f0                	mov    %esi,%eax
80107035:	e8 46 fb ff ff       	call   80106b80 <walkpgdir>
8010703a:	85 c0                	test   %eax,%eax
8010703c:	74 0a                	je     80107048 <inituvm+0x68>
      if(*pte & PTE_P)
8010703e:	f6 00 01             	testb  $0x1,(%eax)
80107041:	75 2c                	jne    8010706f <inituvm+0x8f>
      *pte = pa | perm | PTE_P;
80107043:	83 cb 07             	or     $0x7,%ebx
80107046:	89 18                	mov    %ebx,(%eax)
  memmove(mem, init, sz);
80107048:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010704b:	89 7d 08             	mov    %edi,0x8(%ebp)
8010704e:	89 45 10             	mov    %eax,0x10(%ebp)
80107051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107054:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107057:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010705a:	5b                   	pop    %ebx
8010705b:	5e                   	pop    %esi
8010705c:	5f                   	pop    %edi
8010705d:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010705e:	e9 fd d8 ff ff       	jmp    80104960 <memmove>
80107063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107067:	90                   	nop
      *pde = pa | perm | PTE_P | PTE_PS;
80107068:	80 cb 87             	or     $0x87,%bl
8010706b:	89 1e                	mov    %ebx,(%esi)
      if(a == last)
8010706d:	eb d9                	jmp    80107048 <inituvm+0x68>
        panic("remap");
8010706f:	83 ec 0c             	sub    $0xc,%esp
80107072:	68 cc 80 10 80       	push   $0x801080cc
80107077:	e8 04 93 ff ff       	call   80100380 <panic>
    panic("inituvm: more than a page");
8010707c:	83 ec 0c             	sub    $0xc,%esp
8010707f:	68 11 81 10 80       	push   $0x80108111
80107084:	e8 f7 92 ff ff       	call   80100380 <panic>
80107089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107090 <loaduvm>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
80107096:	83 ec 1c             	sub    $0x1c,%esp
80107099:	8b 45 0c             	mov    0xc(%ebp),%eax
8010709c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010709f:	a9 ff 0f 00 00       	test   $0xfff,%eax
801070a4:	0f 85 bb 00 00 00    	jne    80107165 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801070aa:	01 f0                	add    %esi,%eax
801070ac:	89 f3                	mov    %esi,%ebx
801070ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070b1:	8b 45 14             	mov    0x14(%ebp),%eax
801070b4:	01 f0                	add    %esi,%eax
801070b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801070b9:	85 f6                	test   %esi,%esi
801070bb:	0f 84 87 00 00 00    	je     80107148 <loaduvm+0xb8>
801070c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801070c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801070cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801070ce:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801070d0:	89 c2                	mov    %eax,%edx
801070d2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801070d5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801070d8:	f6 c2 01             	test   $0x1,%dl
801070db:	75 13                	jne    801070f0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801070dd:	83 ec 0c             	sub    $0xc,%esp
801070e0:	68 2b 81 10 80       	push   $0x8010812b
801070e5:	e8 96 92 ff ff       	call   80100380 <panic>
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801070f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801070fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107105:	85 c0                	test   %eax,%eax
80107107:	74 d4                	je     801070dd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107109:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010710b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010710e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107113:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107118:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010711e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107121:	29 d9                	sub    %ebx,%ecx
80107123:	05 00 00 00 80       	add    $0x80000000,%eax
80107128:	57                   	push   %edi
80107129:	51                   	push   %ecx
8010712a:	50                   	push   %eax
8010712b:	ff 75 10             	push   0x10(%ebp)
8010712e:	e8 6d a9 ff ff       	call   80101aa0 <readi>
80107133:	83 c4 10             	add    $0x10,%esp
80107136:	39 f8                	cmp    %edi,%eax
80107138:	75 1e                	jne    80107158 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010713a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107140:	89 f0                	mov    %esi,%eax
80107142:	29 d8                	sub    %ebx,%eax
80107144:	39 c6                	cmp    %eax,%esi
80107146:	77 80                	ja     801070c8 <loaduvm+0x38>
}
80107148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010714b:	31 c0                	xor    %eax,%eax
}
8010714d:	5b                   	pop    %ebx
8010714e:	5e                   	pop    %esi
8010714f:	5f                   	pop    %edi
80107150:	5d                   	pop    %ebp
80107151:	c3                   	ret    
80107152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107158:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010715b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107160:	5b                   	pop    %ebx
80107161:	5e                   	pop    %esi
80107162:	5f                   	pop    %edi
80107163:	5d                   	pop    %ebp
80107164:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107165:	83 ec 0c             	sub    $0xc,%esp
80107168:	68 e8 81 10 80       	push   $0x801081e8
8010716d:	e8 0e 92 ff ff       	call   80100380 <panic>
80107172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107180 <allocuvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107189:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010718c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010718f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107192:	85 c0                	test   %eax,%eax
80107194:	0f 88 b6 00 00 00    	js     80107250 <allocuvm+0xd0>
  if(newsz < oldsz)
8010719a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010719d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801071a0:	0f 82 9a 00 00 00    	jb     80107240 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801071a6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801071ac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801071b2:	39 75 10             	cmp    %esi,0x10(%ebp)
801071b5:	77 44                	ja     801071fb <allocuvm+0x7b>
801071b7:	e9 87 00 00 00       	jmp    80107243 <allocuvm+0xc3>
801071bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801071c0:	83 ec 04             	sub    $0x4,%esp
801071c3:	68 00 10 00 00       	push   $0x1000
801071c8:	6a 00                	push   $0x0
801071ca:	50                   	push   %eax
801071cb:	e8 f0 d6 ff ff       	call   801048c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071d0:	58                   	pop    %eax
801071d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071d7:	5a                   	pop    %edx
801071d8:	6a 06                	push   $0x6
801071da:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071df:	89 f2                	mov    %esi,%edx
801071e1:	50                   	push   %eax
801071e2:	89 f8                	mov    %edi,%eax
801071e4:	e8 17 fa ff ff       	call   80106c00 <mappages>
801071e9:	83 c4 10             	add    $0x10,%esp
801071ec:	85 c0                	test   %eax,%eax
801071ee:	78 78                	js     80107268 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801071f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801071f9:	76 48                	jbe    80107243 <allocuvm+0xc3>
    mem = kalloc();
801071fb:	e8 d0 b5 ff ff       	call   801027d0 <kalloc>
80107200:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107202:	85 c0                	test   %eax,%eax
80107204:	75 ba                	jne    801071c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	68 49 81 10 80       	push   $0x80108149
8010720e:	e8 8d 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107213:	8b 45 0c             	mov    0xc(%ebp),%eax
80107216:	83 c4 10             	add    $0x10,%esp
80107219:	39 45 10             	cmp    %eax,0x10(%ebp)
8010721c:	74 32                	je     80107250 <allocuvm+0xd0>
8010721e:	8b 55 10             	mov    0x10(%ebp),%edx
80107221:	89 c1                	mov    %eax,%ecx
80107223:	89 f8                	mov    %edi,%eax
80107225:	e8 a6 fa ff ff       	call   80106cd0 <deallocuvm.part.0>
      return 0;
8010722a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107234:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107237:	5b                   	pop    %ebx
80107238:	5e                   	pop    %esi
80107239:	5f                   	pop    %edi
8010723a:	5d                   	pop    %ebp
8010723b:	c3                   	ret    
8010723c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107240:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107246:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107249:	5b                   	pop    %ebx
8010724a:	5e                   	pop    %esi
8010724b:	5f                   	pop    %edi
8010724c:	5d                   	pop    %ebp
8010724d:	c3                   	ret    
8010724e:	66 90                	xchg   %ax,%ax
    return 0;
80107250:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010725a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010725d:	5b                   	pop    %ebx
8010725e:	5e                   	pop    %esi
8010725f:	5f                   	pop    %edi
80107260:	5d                   	pop    %ebp
80107261:	c3                   	ret    
80107262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107268:	83 ec 0c             	sub    $0xc,%esp
8010726b:	68 61 81 10 80       	push   $0x80108161
80107270:	e8 2b 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107275:	8b 45 0c             	mov    0xc(%ebp),%eax
80107278:	83 c4 10             	add    $0x10,%esp
8010727b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010727e:	74 0c                	je     8010728c <allocuvm+0x10c>
80107280:	8b 55 10             	mov    0x10(%ebp),%edx
80107283:	89 c1                	mov    %eax,%ecx
80107285:	89 f8                	mov    %edi,%eax
80107287:	e8 44 fa ff ff       	call   80106cd0 <deallocuvm.part.0>
      kfree(mem);
8010728c:	83 ec 0c             	sub    $0xc,%esp
8010728f:	53                   	push   %ebx
80107290:	e8 3b b2 ff ff       	call   801024d0 <kfree>
      return 0;
80107295:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010729c:	83 c4 10             	add    $0x10,%esp
}
8010729f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a5:	5b                   	pop    %ebx
801072a6:	5e                   	pop    %esi
801072a7:	5f                   	pop    %edi
801072a8:	5d                   	pop    %ebp
801072a9:	c3                   	ret    
801072aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072b0 <allochugeuvm>:
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 0c             	sub    $0xc,%esp
  if(newsz < oldsz)
801072b9:	8b 45 0c             	mov    0xc(%ebp),%eax
{
801072bc:	8b 7d 08             	mov    0x8(%ebp),%edi
    return oldsz;
801072bf:	89 c3                	mov    %eax,%ebx
  if(newsz < oldsz)
801072c1:	39 45 10             	cmp    %eax,0x10(%ebp)
801072c4:	0f 82 8f 00 00 00    	jb     80107359 <allochugeuvm+0xa9>
  a = HUGEPGROUNDUP(oldsz);
801072ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801072cd:	8d b0 ff ff 3f 00    	lea    0x3fffff(%eax),%esi
801072d3:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
  for(; a < newsz; a += HUGE_PAGE_SIZE){
801072d9:	39 75 10             	cmp    %esi,0x10(%ebp)
801072dc:	77 4c                	ja     8010732a <allochugeuvm+0x7a>
801072de:	e9 85 00 00 00       	jmp    80107368 <allochugeuvm+0xb8>
801072e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072e7:	90                   	nop
    memset(mem, 0, HUGE_PAGE_SIZE);
801072e8:	83 ec 04             	sub    $0x4,%esp
801072eb:	68 00 00 40 00       	push   $0x400000
801072f0:	6a 00                	push   $0x0
801072f2:	50                   	push   %eax
801072f3:	e8 c8 d5 ff ff       	call   801048c0 <memset>
    if(mappages(pgdir, (char*)a + HUGE_VA_OFFSET, HUGE_PAGE_SIZE, V2P(mem), PTE_PS|PTE_W|PTE_U) < 0){
801072f8:	58                   	pop    %eax
801072f9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072ff:	59                   	pop    %ecx
80107300:	68 86 00 00 00       	push   $0x86
80107305:	8d 96 00 00 00 1e    	lea    0x1e000000(%esi),%edx
8010730b:	b9 00 00 40 00       	mov    $0x400000,%ecx
80107310:	50                   	push   %eax
80107311:	89 f8                	mov    %edi,%eax
80107313:	e8 e8 f8 ff ff       	call   80106c00 <mappages>
80107318:	83 c4 10             	add    $0x10,%esp
8010731b:	85 c0                	test   %eax,%eax
8010731d:	78 59                	js     80107378 <allochugeuvm+0xc8>
  for(; a < newsz; a += HUGE_PAGE_SIZE){
8010731f:	81 c6 00 00 40 00    	add    $0x400000,%esi
80107325:	39 75 10             	cmp    %esi,0x10(%ebp)
80107328:	76 3e                	jbe    80107368 <allochugeuvm+0xb8>
    mem = khugealloc();
8010732a:	e8 11 b5 ff ff       	call   80102840 <khugealloc>
8010732f:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107331:	85 c0                	test   %eax,%eax
80107333:	75 b3                	jne    801072e8 <allochugeuvm+0x38>
      cprintf("allochugeuvm out of memory\n");
80107335:	83 ec 0c             	sub    $0xc,%esp
80107338:	68 7d 81 10 80       	push   $0x8010817d
8010733d:	e8 5e 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107342:	8b 45 0c             	mov    0xc(%ebp),%eax
80107345:	83 c4 10             	add    $0x10,%esp
80107348:	39 45 10             	cmp    %eax,0x10(%ebp)
8010734b:	74 0c                	je     80107359 <allochugeuvm+0xa9>
8010734d:	8b 55 10             	mov    0x10(%ebp),%edx
80107350:	89 c1                	mov    %eax,%ecx
80107352:	89 f8                	mov    %edi,%eax
80107354:	e8 27 fa ff ff       	call   80106d80 <deallochugeuvm.part.0>
}
80107359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010735c:	89 d8                	mov    %ebx,%eax
8010735e:	5b                   	pop    %ebx
8010735f:	5e                   	pop    %esi
80107360:	5f                   	pop    %edi
80107361:	5d                   	pop    %ebp
80107362:	c3                   	ret    
80107363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107367:	90                   	nop
  return newsz;
80107368:	8b 5d 10             	mov    0x10(%ebp),%ebx
}
8010736b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010736e:	89 d8                	mov    %ebx,%eax
80107370:	5b                   	pop    %ebx
80107371:	5e                   	pop    %esi
80107372:	5f                   	pop    %edi
80107373:	5d                   	pop    %ebp
80107374:	c3                   	ret    
80107375:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allochugeuvm out of memory (2)\n");
80107378:	83 ec 0c             	sub    $0xc,%esp
8010737b:	68 0c 82 10 80       	push   $0x8010820c
80107380:	e8 1b 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107385:	8b 45 0c             	mov    0xc(%ebp),%eax
80107388:	83 c4 10             	add    $0x10,%esp
8010738b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010738e:	74 0c                	je     8010739c <allochugeuvm+0xec>
80107390:	8b 55 10             	mov    0x10(%ebp),%edx
80107393:	89 c1                	mov    %eax,%ecx
80107395:	89 f8                	mov    %edi,%eax
80107397:	e8 e4 f9 ff ff       	call   80106d80 <deallochugeuvm.part.0>
      kfree(mem);
8010739c:	83 ec 0c             	sub    $0xc,%esp
8010739f:	53                   	push   %ebx
      return 0;
801073a0:	31 db                	xor    %ebx,%ebx
      kfree(mem);
801073a2:	e8 29 b1 ff ff       	call   801024d0 <kfree>
      return 0;
801073a7:	83 c4 10             	add    $0x10,%esp
}
801073aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ad:	89 d8                	mov    %ebx,%eax
801073af:	5b                   	pop    %ebx
801073b0:	5e                   	pop    %esi
801073b1:	5f                   	pop    %edi
801073b2:	5d                   	pop    %ebp
801073b3:	c3                   	ret    
801073b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073bf:	90                   	nop

801073c0 <deallocuvm>:
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801073c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801073cc:	39 d1                	cmp    %edx,%ecx
801073ce:	73 10                	jae    801073e0 <deallocuvm+0x20>
}
801073d0:	5d                   	pop    %ebp
801073d1:	e9 fa f8 ff ff       	jmp    80106cd0 <deallocuvm.part.0>
801073d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dd:	8d 76 00             	lea    0x0(%esi),%esi
801073e0:	89 d0                	mov    %edx,%eax
801073e2:	5d                   	pop    %ebp
801073e3:	c3                   	ret    
801073e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073ef:	90                   	nop

801073f0 <deallochugeuvm>:
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801073f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801073fc:	39 d1                	cmp    %edx,%ecx
801073fe:	73 10                	jae    80107410 <deallochugeuvm+0x20>
}
80107400:	5d                   	pop    %ebp
80107401:	e9 7a f9 ff ff       	jmp    80106d80 <deallochugeuvm.part.0>
80107406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740d:	8d 76 00             	lea    0x0(%esi),%esi
80107410:	89 d0                	mov    %edx,%eax
80107412:	5d                   	pop    %ebp
80107413:	c3                   	ret    
80107414:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010741b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010741f:	90                   	nop

80107420 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 0c             	sub    $0xc,%esp
80107429:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010742c:	85 f6                	test   %esi,%esi
8010742e:	74 59                	je     80107489 <freevm+0x69>
  if(newsz >= oldsz)
80107430:	31 c9                	xor    %ecx,%ecx
80107432:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107437:	89 f0                	mov    %esi,%eax
80107439:	89 f3                	mov    %esi,%ebx
8010743b:	e8 90 f8 ff ff       	call   80106cd0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107440:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107446:	eb 0f                	jmp    80107457 <freevm+0x37>
80107448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744f:	90                   	nop
80107450:	83 c3 04             	add    $0x4,%ebx
80107453:	39 df                	cmp    %ebx,%edi
80107455:	74 23                	je     8010747a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107457:	8b 03                	mov    (%ebx),%eax
80107459:	a8 01                	test   $0x1,%al
8010745b:	74 f3                	je     80107450 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010745d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107462:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107465:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107468:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010746d:	50                   	push   %eax
8010746e:	e8 5d b0 ff ff       	call   801024d0 <kfree>
80107473:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107476:	39 df                	cmp    %ebx,%edi
80107478:	75 dd                	jne    80107457 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010747a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010747d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107480:	5b                   	pop    %ebx
80107481:	5e                   	pop    %esi
80107482:	5f                   	pop    %edi
80107483:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107484:	e9 47 b0 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
80107489:	83 ec 0c             	sub    $0xc,%esp
8010748c:	68 99 81 10 80       	push   $0x80108199
80107491:	e8 ea 8e ff ff       	call   80100380 <panic>
80107496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749d:	8d 76 00             	lea    0x0(%esi),%esi

801074a0 <setupkvm>:
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	56                   	push   %esi
801074a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801074a5:	e8 26 b3 ff ff       	call   801027d0 <kalloc>
801074aa:	89 c6                	mov    %eax,%esi
801074ac:	85 c0                	test   %eax,%eax
801074ae:	74 42                	je     801074f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801074b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801074b8:	68 00 10 00 00       	push   $0x1000
801074bd:	6a 00                	push   $0x0
801074bf:	50                   	push   %eax
801074c0:	e8 fb d3 ff ff       	call   801048c0 <memset>
801074c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801074c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801074cb:	83 ec 08             	sub    $0x8,%esp
801074ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801074d1:	ff 73 0c             	push   0xc(%ebx)
801074d4:	8b 13                	mov    (%ebx),%edx
801074d6:	50                   	push   %eax
801074d7:	29 c1                	sub    %eax,%ecx
801074d9:	89 f0                	mov    %esi,%eax
801074db:	e8 20 f7 ff ff       	call   80106c00 <mappages>
801074e0:	83 c4 10             	add    $0x10,%esp
801074e3:	85 c0                	test   %eax,%eax
801074e5:	78 19                	js     80107500 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074e7:	83 c3 10             	add    $0x10,%ebx
801074ea:	81 fb 70 b4 10 80    	cmp    $0x8010b470,%ebx
801074f0:	75 d6                	jne    801074c8 <setupkvm+0x28>
}
801074f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074f5:	89 f0                	mov    %esi,%eax
801074f7:	5b                   	pop    %ebx
801074f8:	5e                   	pop    %esi
801074f9:	5d                   	pop    %ebp
801074fa:	c3                   	ret    
801074fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074ff:	90                   	nop
      freevm(pgdir);
80107500:	83 ec 0c             	sub    $0xc,%esp
80107503:	56                   	push   %esi
      return 0;
80107504:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107506:	e8 15 ff ff ff       	call   80107420 <freevm>
      return 0;
8010750b:	83 c4 10             	add    $0x10,%esp
}
8010750e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107511:	89 f0                	mov    %esi,%eax
80107513:	5b                   	pop    %ebx
80107514:	5e                   	pop    %esi
80107515:	5d                   	pop    %ebp
80107516:	c3                   	ret    
80107517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751e:	66 90                	xchg   %ax,%ax

80107520 <kvmalloc>:
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107526:	e8 75 ff ff ff       	call   801074a0 <setupkvm>
8010752b:	a3 e4 55 11 80       	mov    %eax,0x801155e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107530:	05 00 00 00 80       	add    $0x80000000,%eax
80107535:	0f 22 d8             	mov    %eax,%cr3
}
80107538:	c9                   	leave  
80107539:	c3                   	ret    
8010753a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107540 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	83 ec 08             	sub    $0x8,%esp
80107546:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107549:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010754c:	89 c1                	mov    %eax,%ecx
8010754e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107551:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107554:	f6 c2 01             	test   $0x1,%dl
80107557:	75 17                	jne    80107570 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107559:	83 ec 0c             	sub    $0xc,%esp
8010755c:	68 aa 81 10 80       	push   $0x801081aa
80107561:	e8 1a 8e ff ff       	call   80100380 <panic>
80107566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107570:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107573:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107579:	25 fc 0f 00 00       	and    $0xffc,%eax
8010757e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107585:	85 c0                	test   %eax,%eax
80107587:	74 d0                	je     80107559 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107589:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010758c:	c9                   	leave  
8010758d:	c3                   	ret    
8010758e:	66 90                	xchg   %ax,%ax

80107590 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	57                   	push   %edi
80107594:	56                   	push   %esi
80107595:	53                   	push   %ebx
80107596:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107599:	e8 02 ff ff ff       	call   801074a0 <setupkvm>
8010759e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075a1:	85 c0                	test   %eax,%eax
801075a3:	0f 84 bd 00 00 00    	je     80107666 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801075a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075ac:	85 c9                	test   %ecx,%ecx
801075ae:	0f 84 b2 00 00 00    	je     80107666 <copyuvm+0xd6>
801075b4:	31 f6                	xor    %esi,%esi
801075b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801075c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801075c3:	89 f0                	mov    %esi,%eax
801075c5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801075c8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801075cb:	a8 01                	test   $0x1,%al
801075cd:	75 11                	jne    801075e0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801075cf:	83 ec 0c             	sub    $0xc,%esp
801075d2:	68 b4 81 10 80       	push   $0x801081b4
801075d7:	e8 a4 8d ff ff       	call   80100380 <panic>
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801075e0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801075e7:	c1 ea 0a             	shr    $0xa,%edx
801075ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801075f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801075f7:	85 c0                	test   %eax,%eax
801075f9:	74 d4                	je     801075cf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801075fb:	8b 00                	mov    (%eax),%eax
801075fd:	a8 01                	test   $0x1,%al
801075ff:	0f 84 9f 00 00 00    	je     801076a4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107605:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107607:	25 ff 0f 00 00       	and    $0xfff,%eax
8010760c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010760f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107615:	e8 b6 b1 ff ff       	call   801027d0 <kalloc>
8010761a:	89 c3                	mov    %eax,%ebx
8010761c:	85 c0                	test   %eax,%eax
8010761e:	74 64                	je     80107684 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107620:	83 ec 04             	sub    $0x4,%esp
80107623:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107629:	68 00 10 00 00       	push   $0x1000
8010762e:	57                   	push   %edi
8010762f:	50                   	push   %eax
80107630:	e8 2b d3 ff ff       	call   80104960 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107635:	58                   	pop    %eax
80107636:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010763c:	5a                   	pop    %edx
8010763d:	ff 75 e4             	push   -0x1c(%ebp)
80107640:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107645:	89 f2                	mov    %esi,%edx
80107647:	50                   	push   %eax
80107648:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010764b:	e8 b0 f5 ff ff       	call   80106c00 <mappages>
80107650:	83 c4 10             	add    $0x10,%esp
80107653:	85 c0                	test   %eax,%eax
80107655:	78 21                	js     80107678 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107657:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010765d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107660:	0f 87 5a ff ff ff    	ja     801075c0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107666:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107669:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010766c:	5b                   	pop    %ebx
8010766d:	5e                   	pop    %esi
8010766e:	5f                   	pop    %edi
8010766f:	5d                   	pop    %ebp
80107670:	c3                   	ret    
80107671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107678:	83 ec 0c             	sub    $0xc,%esp
8010767b:	53                   	push   %ebx
8010767c:	e8 4f ae ff ff       	call   801024d0 <kfree>
      goto bad;
80107681:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107684:	83 ec 0c             	sub    $0xc,%esp
80107687:	ff 75 e0             	push   -0x20(%ebp)
8010768a:	e8 91 fd ff ff       	call   80107420 <freevm>
  return 0;
8010768f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107696:	83 c4 10             	add    $0x10,%esp
}
80107699:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010769c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010769f:	5b                   	pop    %ebx
801076a0:	5e                   	pop    %esi
801076a1:	5f                   	pop    %edi
801076a2:	5d                   	pop    %ebp
801076a3:	c3                   	ret    
      panic("copyuvm: page not present");
801076a4:	83 ec 0c             	sub    $0xc,%esp
801076a7:	68 ce 81 10 80       	push   $0x801081ce
801076ac:	e8 cf 8c ff ff       	call   80100380 <panic>
801076b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076bf:	90                   	nop

801076c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076c0:	55                   	push   %ebp
801076c1:	89 e5                	mov    %esp,%ebp
801076c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801076c6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801076c9:	89 c1                	mov    %eax,%ecx
801076cb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801076ce:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801076d1:	f6 c2 01             	test   $0x1,%dl
801076d4:	0f 84 00 01 00 00    	je     801077da <uva2ka.cold>
  return &pgtab[PTX(va)];
801076da:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076dd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801076e3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801076e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801076e9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801076f0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801076f7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076fa:	05 00 00 00 80       	add    $0x80000000,%eax
801076ff:	83 fa 05             	cmp    $0x5,%edx
80107702:	ba 00 00 00 00       	mov    $0x0,%edx
80107707:	0f 45 c2             	cmovne %edx,%eax
}
8010770a:	c3                   	ret    
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 0c             	sub    $0xc,%esp
80107719:	8b 75 14             	mov    0x14(%ebp),%esi
8010771c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010771f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107722:	85 f6                	test   %esi,%esi
80107724:	75 51                	jne    80107777 <copyout+0x67>
80107726:	e9 a5 00 00 00       	jmp    801077d0 <copyout+0xc0>
8010772b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010772f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107730:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107736:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010773c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107742:	74 75                	je     801077b9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107744:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107746:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107749:	29 c3                	sub    %eax,%ebx
8010774b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107751:	39 f3                	cmp    %esi,%ebx
80107753:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107756:	29 f8                	sub    %edi,%eax
80107758:	83 ec 04             	sub    $0x4,%esp
8010775b:	01 c1                	add    %eax,%ecx
8010775d:	53                   	push   %ebx
8010775e:	52                   	push   %edx
8010775f:	51                   	push   %ecx
80107760:	e8 fb d1 ff ff       	call   80104960 <memmove>
    len -= n;
    buf += n;
80107765:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107768:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010776e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107771:	01 da                	add    %ebx,%edx
  while(len > 0){
80107773:	29 de                	sub    %ebx,%esi
80107775:	74 59                	je     801077d0 <copyout+0xc0>
  if(*pde & PTE_P){
80107777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010777a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010777c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010777e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107781:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107787:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010778a:	f6 c1 01             	test   $0x1,%cl
8010778d:	0f 84 4e 00 00 00    	je     801077e1 <copyout.cold>
  return &pgtab[PTX(va)];
80107793:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107795:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010779b:	c1 eb 0c             	shr    $0xc,%ebx
8010779e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801077a4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801077ab:	89 d9                	mov    %ebx,%ecx
801077ad:	83 e1 05             	and    $0x5,%ecx
801077b0:	83 f9 05             	cmp    $0x5,%ecx
801077b3:	0f 84 77 ff ff ff    	je     80107730 <copyout+0x20>
  }
  return 0;
}
801077b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077c1:	5b                   	pop    %ebx
801077c2:	5e                   	pop    %esi
801077c3:	5f                   	pop    %edi
801077c4:	5d                   	pop    %ebp
801077c5:	c3                   	ret    
801077c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077cd:	8d 76 00             	lea    0x0(%esi),%esi
801077d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077d3:	31 c0                	xor    %eax,%eax
}
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5f                   	pop    %edi
801077d8:	5d                   	pop    %ebp
801077d9:	c3                   	ret    

801077da <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801077da:	a1 00 00 00 00       	mov    0x0,%eax
801077df:	0f 0b                	ud2    

801077e1 <copyout.cold>:
801077e1:	a1 00 00 00 00       	mov    0x0,%eax
801077e6:	0f 0b                	ud2    
