
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
80100028:	bc 30 66 11 80       	mov    $0x80116630,%esp
8010002d:	b8 40 32 10 80       	mov    $0x80103240,%eax
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
8010004c:	68 c0 78 10 80       	push   $0x801078c0
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 f5 45 00 00       	call   80104650 <initlock>
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
80100092:	68 c7 78 10 80       	push   $0x801078c7
80100097:	50                   	push   %eax
80100098:	e8 83 44 00 00       	call   80104520 <initsleeplock>
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
801000e4:	e8 37 47 00 00       	call   80104820 <acquire>
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
80100162:	e8 59 46 00 00       	call   801047c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 43 00 00       	call   80104560 <acquiresleep>
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
801001a1:	68 ce 78 10 80       	push   $0x801078ce
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
801001be:	e8 3d 44 00 00       	call   80104600 <holdingsleep>
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
801001dc:	68 df 78 10 80       	push   $0x801078df
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
801001ff:	e8 fc 43 00 00       	call   80104600 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ac 43 00 00       	call   801045c0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 00 46 00 00       	call   80104820 <acquire>
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
8010026c:	e9 4f 45 00 00       	jmp    801047c0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 78 10 80       	push   $0x801078e6
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
801002a0:	e8 7b 45 00 00       	call   80104820 <acquire>
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
801002cd:	e8 ee 3f 00 00       	call   801042c0 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 38 00 00       	call   80103b60 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 c5 44 00 00       	call   801047c0 <release>
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
8010034c:	e8 6f 44 00 00       	call   801047c0 <release>
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
80100399:	e8 32 27 00 00       	call   80102ad0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 78 10 80       	push   $0x801078ed
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 5b 82 10 80 	movl   $0x8010825b,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 a3 42 00 00       	call   80104670 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 79 10 80       	push   $0x80107901
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
8010041a:	e8 91 5c 00 00       	call   801060b0 <uartputc>
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
80100505:	e8 a6 5b 00 00       	call   801060b0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 9a 5b 00 00       	call   801060b0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 8e 5b 00 00       	call   801060b0 <uartputc>
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
80100551:	e8 2a 44 00 00       	call   80104980 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 75 43 00 00       	call   801048e0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 79 10 80       	push   $0x80107905
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
801005ab:	e8 70 42 00 00       	call   80104820 <acquire>
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
801005e4:	e8 d7 41 00 00       	call   801047c0 <release>
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
80100636:	0f b6 92 30 79 10 80 	movzbl -0x7fef86d0(%edx),%edx
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
801007e8:	e8 33 40 00 00       	call   80104820 <acquire>
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
80100838:	bf 18 79 10 80       	mov    $0x80107918,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 ff 10 80       	push   $0x8010ff40
8010085b:	e8 60 3f 00 00       	call   801047c0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 1f 79 10 80       	push   $0x8010791f
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
80100893:	e8 88 3f 00 00       	call   80104820 <acquire>
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
801009d0:	e8 eb 3d 00 00       	call   801047c0 <release>
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
80100a0e:	e9 4d 3a 00 00       	jmp    80104460 <procdump>
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
80100a44:	e8 37 39 00 00       	call   80104380 <wakeup>
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
80100a66:	68 28 79 10 80       	push   $0x80107928
80100a6b:	68 40 ff 10 80       	push   $0x8010ff40
80100a70:	e8 db 3b 00 00       	call   80104650 <initlock>

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
80100abc:	e8 9f 30 00 00       	call   80103b60 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 74 24 00 00       	call   80102f40 <begin_op>

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
80100b0f:	e8 9c 24 00 00       	call   80102fb0 <end_op>
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
80100b34:	e8 37 6a 00 00       	call   80107570 <setupkvm>
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
80100ba3:	e8 18 66 00 00       	call   801071c0 <allocuvm>
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
80100bd9:	e8 f2 64 00 00       	call   801070d0 <loaduvm>
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
80100c1b:	e8 d0 68 00 00       	call   801074f0 <freevm>
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
80100c51:	e8 5a 23 00 00       	call   80102fb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 59 65 00 00       	call   801071c0 <allocuvm>
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
80100c83:	e8 88 69 00 00       	call   80107610 <clearpteu>
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
80100cd3:	e8 08 3e 00 00       	call   80104ae0 <strlen>
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
80100ce7:	e8 f4 3d 00 00       	call   80104ae0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 e3 6a 00 00       	call   801077e0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 da 67 00 00       	call   801074f0 <freevm>
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
80100d63:	e8 78 6a 00 00       	call   801077e0 <copyout>
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
80100da1:	e8 fa 3c 00 00       	call   80104aa0 <safestrcpy>
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
80100dd4:	e8 37 61 00 00       	call   80106f10 <switchuvm>
  freevm(oldpgdir);
80100dd9:	89 3c 24             	mov    %edi,(%esp)
80100ddc:	e8 0f 67 00 00       	call   801074f0 <freevm>
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	31 c0                	xor    %eax,%eax
80100de6:	e9 31 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100deb:	e8 c0 21 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	68 41 79 10 80       	push   $0x80107941
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
80100e26:	68 4d 79 10 80       	push   $0x8010794d
80100e2b:	68 80 ff 10 80       	push   $0x8010ff80
80100e30:	e8 1b 38 00 00       	call   80104650 <initlock>
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
80100e51:	e8 ca 39 00 00       	call   80104820 <acquire>
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
80100e81:	e8 3a 39 00 00       	call   801047c0 <release>
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
80100e9a:	e8 21 39 00 00       	call   801047c0 <release>
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
80100ebf:	e8 5c 39 00 00       	call   80104820 <acquire>
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
80100edc:	e8 df 38 00 00       	call   801047c0 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 54 79 10 80       	push   $0x80107954
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
80100f11:	e8 0a 39 00 00       	call   80104820 <acquire>
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
80100f4c:	e8 6f 38 00 00       	call   801047c0 <release>

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
80100f7e:	e9 3d 38 00 00       	jmp    801047c0 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 b3 1f 00 00       	call   80102f40 <begin_op>
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
80100fa2:	e9 09 20 00 00       	jmp    80102fb0 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 62 27 00 00       	call   80103720 <pipeclose>
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
80100fcc:	68 5c 79 10 80       	push   $0x8010795c
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
8010109d:	e9 1e 28 00 00       	jmp    801038c0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 66 79 10 80       	push   $0x80107966
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
80101119:	e8 92 1e 00 00       	call   80102fb0 <end_op>

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
8010113e:	e8 fd 1d 00 00       	call   80102f40 <begin_op>
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
80101175:	e8 36 1e 00 00       	call   80102fb0 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 6f 79 10 80       	push   $0x8010796f
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
801011b9:	e9 02 26 00 00       	jmp    801037c0 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 75 79 10 80       	push   $0x80107975
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
8010121d:	e8 fe 1e 00 00       	call   80103120 <log_write>
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
80101237:	68 7f 79 10 80       	push   $0x8010797f
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
801012f4:	68 92 79 10 80       	push   $0x80107992
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
8010130d:	e8 0e 1e 00 00       	call   80103120 <log_write>
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
80101335:	e8 a6 35 00 00       	call   801048e0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 de 1d 00 00       	call   80103120 <log_write>
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
8010137a:	e8 a1 34 00 00       	call   80104820 <acquire>
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
801013e7:	e8 d4 33 00 00       	call   801047c0 <release>

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
80101415:	e8 a6 33 00 00       	call   801047c0 <release>
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
80101448:	68 a8 79 10 80       	push   $0x801079a8
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
801014d5:	e8 46 1c 00 00       	call   80103120 <log_write>
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
80101525:	68 b8 79 10 80       	push   $0x801079b8
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
80101551:	e8 2a 34 00 00       	call   80104980 <memmove>
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
8010157c:	68 cb 79 10 80       	push   $0x801079cb
80101581:	68 80 09 11 80       	push   $0x80110980
80101586:	e8 c5 30 00 00       	call   80104650 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 d2 79 10 80       	push   $0x801079d2
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 7c 2f 00 00       	call   80104520 <initsleeplock>
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
801015cc:	e8 af 33 00 00       	call   80104980 <memmove>
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
80101603:	68 38 7a 10 80       	push   $0x80107a38
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
8010169e:	e8 3d 32 00 00       	call   801048e0 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 6b 1a 00 00       	call   80103120 <log_write>
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
801016d3:	68 d8 79 10 80       	push   $0x801079d8
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
80101741:	e8 3a 32 00 00       	call   80104980 <memmove>
  log_write(bp);
80101746:	89 34 24             	mov    %esi,(%esp)
80101749:	e8 d2 19 00 00       	call   80103120 <log_write>
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
8010176f:	e8 ac 30 00 00       	call   80104820 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010177f:	e8 3c 30 00 00       	call   801047c0 <release>
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
801017b2:	e8 a9 2d 00 00       	call   80104560 <acquiresleep>
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
80101828:	e8 53 31 00 00       	call   80104980 <memmove>
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
8010184d:	68 f0 79 10 80       	push   $0x801079f0
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 ea 79 10 80       	push   $0x801079ea
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
80101883:	e8 78 2d 00 00       	call   80104600 <holdingsleep>
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
8010189f:	e9 1c 2d 00 00       	jmp    801045c0 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 ff 79 10 80       	push   $0x801079ff
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
801018d0:	e8 8b 2c 00 00       	call   80104560 <acquiresleep>
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
801018ea:	e8 d1 2c 00 00       	call   801045c0 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
801018f6:	e8 25 2f 00 00       	call   80104820 <acquire>
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
80101910:	e9 ab 2e 00 00       	jmp    801047c0 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 80 09 11 80       	push   $0x80110980
80101920:	e8 fb 2e 00 00       	call   80104820 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010192f:	e8 8c 2e 00 00       	call   801047c0 <release>
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
80101a33:	e8 c8 2b 00 00       	call   80104600 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 71 2b 00 00       	call   801045c0 <releasesleep>
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
80101a63:	68 ff 79 10 80       	push   $0x801079ff
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
80101b47:	e8 34 2e 00 00       	call   80104980 <memmove>
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
80101c43:	e8 38 2d 00 00       	call   80104980 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 d0 14 00 00       	call   80103120 <log_write>
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
80101cde:	e8 0d 2d 00 00       	call   801049f0 <strncmp>
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
80101d3d:	e8 ae 2c 00 00       	call   801049f0 <strncmp>
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
80101d82:	68 19 7a 10 80       	push   $0x80107a19
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 07 7a 10 80       	push   $0x80107a07
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
80101dba:	e8 a1 1d 00 00       	call   80103b60 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 80 09 11 80       	push   $0x80110980
80101dca:	e8 51 2a 00 00       	call   80104820 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101dda:	e8 e1 29 00 00       	call   801047c0 <release>
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
80101e37:	e8 44 2b 00 00       	call   80104980 <memmove>
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
80101e9c:	e8 5f 27 00 00       	call   80104600 <holdingsleep>
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
80101ebe:	e8 fd 26 00 00       	call   801045c0 <releasesleep>
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
80101eeb:	e8 90 2a 00 00       	call   80104980 <memmove>
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
80101f3b:	e8 c0 26 00 00       	call   80104600 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 61 26 00 00       	call   801045c0 <releasesleep>
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
80101f7d:	e8 7e 26 00 00       	call   80104600 <holdingsleep>
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
80101fa0:	e8 5b 26 00 00       	call   80104600 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 04 26 00 00       	call   801045c0 <releasesleep>
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
80101fdf:	68 ff 79 10 80       	push   $0x801079ff
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
8010204d:	e8 ee 29 00 00       	call   80104a40 <strncpy>
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
8010208b:	68 28 7a 10 80       	push   $0x80107a28
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 2a 80 10 80       	push   $0x8010802a
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
801021ab:	68 94 7a 10 80       	push   $0x80107a94
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 8b 7a 10 80       	push   $0x80107a8b
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 a6 7a 10 80       	push   $0x80107aa6
801021db:	68 20 26 11 80       	push   $0x80112620
801021e0:	e8 6b 24 00 00       	call   80104650 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 e4 27 11 80       	mov    0x801127e4,%eax
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
8010225e:	e8 bd 25 00 00       	call   80104820 <acquire>

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
801022bd:	e8 be 20 00 00       	call   80104380 <wakeup>

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
801022db:	e8 e0 24 00 00       	call   801047c0 <release>

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
801022fe:	e8 fd 22 00 00       	call   80104600 <holdingsleep>
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
80102338:	e8 e3 24 00 00       	call   80104820 <acquire>

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
80102379:	e8 42 1f 00 00       	call   801042c0 <sleep>
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
80102396:	e9 25 24 00 00       	jmp    801047c0 <release>
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
801023ba:	68 d5 7a 10 80       	push   $0x80107ad5
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 c0 7a 10 80       	push   $0x80107ac0
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 aa 7a 10 80       	push   $0x80107aaa
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
8010240e:	0f b6 15 e0 27 11 80 	movzbl 0x801127e0,%edx
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
8010242a:	68 f4 7a 10 80       	push   $0x80107af4
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
801024e2:	81 fb 30 66 11 80    	cmp    $0x80116630,%ebx
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
80102502:	e8 d9 23 00 00       	call   801048e0 <memset>

  if (kmem.use_lock)
80102507:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
80102514:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if (kmem.use_lock)
8010251b:	a1 d4 26 11 80       	mov    0x801126d4,%eax
  kmem.freelist = r;
80102520:	89 1d d8 26 11 80    	mov    %ebx,0x801126d8
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
80102533:	68 a0 26 11 80       	push   $0x801126a0
80102538:	e8 e3 22 00 00       	call   80104820 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 68 22 00 00       	jmp    801047c0 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 26 7b 10 80       	push   $0x80107b26
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
80102604:	c7 05 d4 26 11 80 01 	movl   $0x1,0x801126d4
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
8010262b:	68 2c 7b 10 80       	push   $0x80107b2c
80102630:	68 a0 26 11 80       	push   $0x801126a0
80102635:	e8 16 20 00 00       	call   80104650 <initlock>
  p = (char *)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 d4 26 11 80 00 	movl   $0x0,0x801126d4
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
801026ba:	e8 21 22 00 00       	call   801048e0 <memset>

  if (khugemem.use_lock)
801026bf:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	85 d2                	test   %edx,%edx
801026ca:	75 24                	jne    801026f0 <khugefree+0x60>
    acquire(&khugemem.lock);
  r = (struct run *)v;
  r->next = khugemem.freehugelist;
801026cc:	a1 98 26 11 80       	mov    0x80112698,%eax
801026d1:	89 03                	mov    %eax,(%ebx)
  khugemem.freehugelist = r;
  if (khugemem.use_lock)
801026d3:	a1 94 26 11 80       	mov    0x80112694,%eax
  khugemem.freehugelist = r;
801026d8:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if (khugemem.use_lock)
801026de:	85 c0                	test   %eax,%eax
801026e0:	75 26                	jne    80102708 <khugefree+0x78>
    release(&khugemem.lock);
}
801026e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026e5:	c9                   	leave  
801026e6:	c3                   	ret    
801026e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ee:	66 90                	xchg   %ax,%ax
    acquire(&khugemem.lock);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	68 60 26 11 80       	push   $0x80112660
801026f8:	e8 23 21 00 00       	call   80104820 <acquire>
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	eb ca                	jmp    801026cc <khugefree+0x3c>
80102702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&khugemem.lock);
80102708:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010270f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102712:	c9                   	leave  
    release(&khugemem.lock);
80102713:	e9 a8 20 00 00       	jmp    801047c0 <release>
    panic("khugefree");
80102718:	83 ec 0c             	sub    $0xc,%esp
8010271b:	68 31 7b 10 80       	push   $0x80107b31
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
80102784:	53                   	push   %ebx
80102785:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&khugemem.lock, "khugemem");
80102788:	83 ec 08             	sub    $0x8,%esp
8010278b:	68 3b 7b 10 80       	push   $0x80107b3b
80102790:	68 60 26 11 80       	push   $0x80112660
80102795:	e8 b6 1e 00 00       	call   80104650 <initlock>
  p = (char *)HUGEPGROUNDUP((uint)vstart);
8010279a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
8010279d:	83 c4 10             	add    $0x10,%esp
  khugemem.use_lock=0;
801027a0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801027a7:	00 00 00 
  p = (char *)HUGEPGROUNDUP((uint)vstart);
801027aa:	8d 98 ff ff 3f 00    	lea    0x3fffff(%eax),%ebx
801027b0:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027b6:	81 c3 00 00 40 00    	add    $0x400000,%ebx
801027bc:	39 de                	cmp    %ebx,%esi
801027be:	72 1c                	jb     801027dc <khugeinit+0x5c>
    khugefree(p);
801027c0:	83 ec 0c             	sub    $0xc,%esp
801027c3:	8d 83 00 00 c0 ff    	lea    -0x400000(%ebx),%eax
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027c9:	81 c3 00 00 40 00    	add    $0x400000,%ebx
    khugefree(p);
801027cf:	50                   	push   %eax
801027d0:	e8 bb fe ff ff       	call   80102690 <khugefree>
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027d5:	83 c4 10             	add    $0x10,%esp
801027d8:	39 de                	cmp    %ebx,%esi
801027da:	73 e4                	jae    801027c0 <khugeinit+0x40>
  khugemem.use_lock=1;
801027dc:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801027e3:	00 00 00 
}
801027e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e9:	5b                   	pop    %ebx
801027ea:	5e                   	pop    %esi
801027eb:	5d                   	pop    %ebp
801027ec:	c3                   	ret    
801027ed:	8d 76 00             	lea    0x0(%esi),%esi

801027f0 <kalloc>:
char *
kalloc(void)
{
  struct run *r;

  if (kmem.use_lock)
801027f0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	75 1f                	jne    80102818 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027f9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
  if (r)
801027fe:	85 c0                	test   %eax,%eax
80102800:	74 0e                	je     80102810 <kalloc+0x20>
    kmem.freelist = r->next;
80102802:	8b 10                	mov    (%eax),%edx
80102804:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  if (kmem.use_lock)
8010280a:	c3                   	ret    
8010280b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010280f:	90                   	nop
    release(&kmem.lock);
  return (char *)r;
}
80102810:	c3                   	ret    
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102818:	55                   	push   %ebp
80102819:	89 e5                	mov    %esp,%ebp
8010281b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010281e:	68 a0 26 11 80       	push   $0x801126a0
80102823:	e8 f8 1f 00 00       	call   80104820 <acquire>
  r = kmem.freelist;
80102828:	a1 d8 26 11 80       	mov    0x801126d8,%eax
  if (kmem.use_lock)
8010282d:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
  if (r)
80102833:	83 c4 10             	add    $0x10,%esp
80102836:	85 c0                	test   %eax,%eax
80102838:	74 08                	je     80102842 <kalloc+0x52>
    kmem.freelist = r->next;
8010283a:	8b 08                	mov    (%eax),%ecx
8010283c:	89 0d d8 26 11 80    	mov    %ecx,0x801126d8
  if (kmem.use_lock)
80102842:	85 d2                	test   %edx,%edx
80102844:	74 16                	je     8010285c <kalloc+0x6c>
    release(&kmem.lock);
80102846:	83 ec 0c             	sub    $0xc,%esp
80102849:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010284c:	68 a0 26 11 80       	push   $0x801126a0
80102851:	e8 6a 1f 00 00       	call   801047c0 <release>
  return (char *)r;
80102856:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102859:	83 c4 10             	add    $0x10,%esp
}
8010285c:	c9                   	leave  
8010285d:	c3                   	ret    
8010285e:	66 90                	xchg   %ax,%ax

80102860 <khugealloc>:
{
  struct run *r;
  
  //r = (struct run *)HUGE_VA_OFFSET;
  
  if (khugemem.use_lock)
80102860:	a1 94 26 11 80       	mov    0x80112694,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	75 1f                	jne    80102888 <khugealloc+0x28>
    acquire(&khugemem.lock);
  r = khugemem.freehugelist;
80102869:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (r)
8010286e:	85 c0                	test   %eax,%eax
80102870:	74 0e                	je     80102880 <khugealloc+0x20>
    khugemem.freehugelist = r->next;
80102872:	8b 10                	mov    (%eax),%edx
80102874:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if (khugemem.use_lock)
8010287a:	c3                   	ret    
8010287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
    release(&khugemem.lock);

  return (char *)r;
}
80102880:	c3                   	ret    
80102881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102888:	55                   	push   %ebp
80102889:	89 e5                	mov    %esp,%ebp
8010288b:	83 ec 24             	sub    $0x24,%esp
    acquire(&khugemem.lock);
8010288e:	68 60 26 11 80       	push   $0x80112660
80102893:	e8 88 1f 00 00       	call   80104820 <acquire>
  r = khugemem.freehugelist;
80102898:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (khugemem.use_lock)
8010289d:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if (r)
801028a3:	83 c4 10             	add    $0x10,%esp
801028a6:	85 c0                	test   %eax,%eax
801028a8:	74 08                	je     801028b2 <khugealloc+0x52>
    khugemem.freehugelist = r->next;
801028aa:	8b 08                	mov    (%eax),%ecx
801028ac:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if (khugemem.use_lock)
801028b2:	85 d2                	test   %edx,%edx
801028b4:	74 16                	je     801028cc <khugealloc+0x6c>
    release(&khugemem.lock);
801028b6:	83 ec 0c             	sub    $0xc,%esp
801028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028bc:	68 60 26 11 80       	push   $0x80112660
801028c1:	e8 fa 1e 00 00       	call   801047c0 <release>
  return (char *)r;
801028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&khugemem.lock);
801028c9:	83 c4 10             	add    $0x10,%esp
}
801028cc:	c9                   	leave  
801028cd:	c3                   	ret    
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	ba 64 00 00 00       	mov    $0x64,%edx
801028d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028d6:	a8 01                	test   $0x1,%al
801028d8:	0f 84 c2 00 00 00    	je     801029a0 <kbdgetc+0xd0>
{
801028de:	55                   	push   %ebp
801028df:	ba 60 00 00 00       	mov    $0x60,%edx
801028e4:	89 e5                	mov    %esp,%ebp
801028e6:	53                   	push   %ebx
801028e7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028e8:	8b 1d dc 26 11 80    	mov    0x801126dc,%ebx
  data = inb(KBDATAP);
801028ee:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028f1:	3c e0                	cmp    $0xe0,%al
801028f3:	74 5b                	je     80102950 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028f5:	89 da                	mov    %ebx,%edx
801028f7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028fa:	84 c0                	test   %al,%al
801028fc:	78 62                	js     80102960 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028fe:	85 d2                	test   %edx,%edx
80102900:	74 09                	je     8010290b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102902:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102905:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102908:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010290b:	0f b6 91 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%edx
  shift ^= togglecode[data];
80102912:	0f b6 81 80 7b 10 80 	movzbl -0x7fef8480(%ecx),%eax
  shift |= shiftcode[data];
80102919:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010291b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010291d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010291f:	89 15 dc 26 11 80    	mov    %edx,0x801126dc
  c = charcode[shift & (CTL | SHIFT)][data];
80102925:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102928:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010292b:	8b 04 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%eax
80102932:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102936:	74 0b                	je     80102943 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102938:	8d 50 9f             	lea    -0x61(%eax),%edx
8010293b:	83 fa 19             	cmp    $0x19,%edx
8010293e:	77 48                	ja     80102988 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102940:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102946:	c9                   	leave  
80102947:	c3                   	ret    
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop
    shift |= E0ESC;
80102950:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102953:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102955:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
}
8010295b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010295e:	c9                   	leave  
8010295f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102960:	83 e0 7f             	and    $0x7f,%eax
80102963:	85 d2                	test   %edx,%edx
80102965:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102968:	0f b6 81 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%eax
8010296f:	83 c8 40             	or     $0x40,%eax
80102972:	0f b6 c0             	movzbl %al,%eax
80102975:	f7 d0                	not    %eax
80102977:	21 d8                	and    %ebx,%eax
}
80102979:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010297c:	a3 dc 26 11 80       	mov    %eax,0x801126dc
    return 0;
80102981:	31 c0                	xor    %eax,%eax
}
80102983:	c9                   	leave  
80102984:	c3                   	ret    
80102985:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102988:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010298b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010298e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102991:	c9                   	leave  
      c += 'a' - 'A';
80102992:	83 f9 1a             	cmp    $0x1a,%ecx
80102995:	0f 42 c2             	cmovb  %edx,%eax
}
80102998:	c3                   	ret    
80102999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029a5:	c3                   	ret    
801029a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ad:	8d 76 00             	lea    0x0(%esi),%esi

801029b0 <kbdintr>:

void
kbdintr(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029b6:	68 d0 28 10 80       	push   $0x801028d0
801029bb:	e8 c0 de ff ff       	call   80100880 <consoleintr>
}
801029c0:	83 c4 10             	add    $0x10,%esp
801029c3:	c9                   	leave  
801029c4:	c3                   	ret    
801029c5:	66 90                	xchg   %ax,%ax
801029c7:	66 90                	xchg   %ax,%ax
801029c9:	66 90                	xchg   %ax,%ax
801029cb:	66 90                	xchg   %ax,%ax
801029cd:	66 90                	xchg   %ax,%ax
801029cf:	90                   	nop

801029d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029d0:	a1 e0 26 11 80       	mov    0x801126e0,%eax
801029d5:	85 c0                	test   %eax,%eax
801029d7:	0f 84 cb 00 00 00    	je     80102aa8 <lapicinit+0xd8>
  lapic[index] = value;
801029dd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029e4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ea:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029f1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029fe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a01:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a04:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a0b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a11:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a18:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a1e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a25:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a28:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a2b:	8b 50 30             	mov    0x30(%eax),%edx
80102a2e:	c1 ea 10             	shr    $0x10,%edx
80102a31:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a37:	75 77                	jne    80102ab0 <lapicinit+0xe0>
  lapic[index] = value;
80102a39:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a43:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a46:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a50:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a53:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a5a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a60:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a67:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a7a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a81:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a84:	8b 50 20             	mov    0x20(%eax),%edx
80102a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a90:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a96:	80 e6 10             	and    $0x10,%dh
80102a99:	75 f5                	jne    80102a90 <lapicinit+0xc0>
  lapic[index] = value;
80102a9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102aa2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102aa8:	c3                   	ret    
80102aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ab0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ab7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aba:	8b 50 20             	mov    0x20(%eax),%edx
}
80102abd:	e9 77 ff ff ff       	jmp    80102a39 <lapicinit+0x69>
80102ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ad0:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	74 07                	je     80102ae0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102ad9:	8b 40 20             	mov    0x20(%eax),%eax
80102adc:	c1 e8 18             	shr    $0x18,%eax
80102adf:	c3                   	ret    
    return 0;
80102ae0:	31 c0                	xor    %eax,%eax
}
80102ae2:	c3                   	ret    
80102ae3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102af0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102af0:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	74 0d                	je     80102b06 <lapiceoi+0x16>
  lapic[index] = value;
80102af9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b03:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b06:	c3                   	ret    
80102b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0e:	66 90                	xchg   %ax,%ax

80102b10 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b10:	c3                   	ret    
80102b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1f:	90                   	nop

80102b20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b21:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b26:	ba 70 00 00 00       	mov    $0x70,%edx
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	53                   	push   %ebx
80102b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b34:	ee                   	out    %al,(%dx)
80102b35:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b3a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b40:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b4d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b50:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b52:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b5e:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102b63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bad:	c9                   	leave  
80102bae:	c3                   	ret    
80102baf:	90                   	nop

80102bb0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bb0:	55                   	push   %ebp
80102bb1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bb6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bbb:	89 e5                	mov    %esp,%ebp
80102bbd:	57                   	push   %edi
80102bbe:	56                   	push   %esi
80102bbf:	53                   	push   %ebx
80102bc0:	83 ec 4c             	sub    $0x4c,%esp
80102bc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bc9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bd2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
80102bd8:	31 c0                	xor    %eax,%eax
80102bda:	89 da                	mov    %ebx,%edx
80102bdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102be2:	89 ca                	mov    %ecx,%edx
80102be4:	ec                   	in     (%dx),%al
80102be5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be8:	89 da                	mov    %ebx,%edx
80102bea:	b8 02 00 00 00       	mov    $0x2,%eax
80102bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	89 ca                	mov    %ecx,%edx
80102bf2:	ec                   	in     (%dx),%al
80102bf3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf6:	89 da                	mov    %ebx,%edx
80102bf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
80102c01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 da                	mov    %ebx,%edx
80102c06:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al
80102c0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c12:	89 da                	mov    %ebx,%edx
80102c14:	b8 08 00 00 00       	mov    $0x8,%eax
80102c19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1a:	89 ca                	mov    %ecx,%edx
80102c1c:	ec                   	in     (%dx),%al
80102c1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1f:	89 da                	mov    %ebx,%edx
80102c21:	b8 09 00 00 00       	mov    $0x9,%eax
80102c26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c27:	89 ca                	mov    %ecx,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2c:	89 da                	mov    %ebx,%edx
80102c2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c34:	89 ca                	mov    %ecx,%edx
80102c36:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c37:	84 c0                	test   %al,%al
80102c39:	78 9d                	js     80102bd8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c3f:	89 fa                	mov    %edi,%edx
80102c41:	0f b6 fa             	movzbl %dl,%edi
80102c44:	89 f2                	mov    %esi,%edx
80102c46:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c49:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c4d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c50:	89 da                	mov    %ebx,%edx
80102c52:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c55:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c58:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c5c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c69:	31 c0                	xor    %eax,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 da                	mov    %ebx,%edx
80102c74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c77:	b8 02 00 00 00       	mov    $0x2,%eax
80102c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
80102c80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c83:	89 da                	mov    %ebx,%edx
80102c85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c88:	b8 04 00 00 00       	mov    $0x4,%eax
80102c8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8e:	89 ca                	mov    %ecx,%edx
80102c90:	ec                   	in     (%dx),%al
80102c91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c94:	89 da                	mov    %ebx,%edx
80102c96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c99:	b8 07 00 00 00       	mov    $0x7,%eax
80102c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9f:	89 ca                	mov    %ecx,%edx
80102ca1:	ec                   	in     (%dx),%al
80102ca2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca5:	89 da                	mov    %ebx,%edx
80102ca7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102caa:	b8 08 00 00 00       	mov    $0x8,%eax
80102caf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
80102cb3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	89 da                	mov    %ebx,%edx
80102cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cbb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cc0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc1:	89 ca                	mov    %ecx,%edx
80102cc3:	ec                   	in     (%dx),%al
80102cc4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cc7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ccd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cd0:	6a 18                	push   $0x18
80102cd2:	50                   	push   %eax
80102cd3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cd6:	50                   	push   %eax
80102cd7:	e8 54 1c 00 00       	call   80104930 <memcmp>
80102cdc:	83 c4 10             	add    $0x10,%esp
80102cdf:	85 c0                	test   %eax,%eax
80102ce1:	0f 85 f1 fe ff ff    	jne    80102bd8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ce7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ceb:	75 78                	jne    80102d65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ced:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cf0:	89 c2                	mov    %eax,%edx
80102cf2:	83 e0 0f             	and    $0xf,%eax
80102cf5:	c1 ea 04             	shr    $0x4,%edx
80102cf8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d04:	89 c2                	mov    %eax,%edx
80102d06:	83 e0 0f             	and    $0xf,%eax
80102d09:	c1 ea 04             	shr    $0x4,%edx
80102d0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d18:	89 c2                	mov    %eax,%edx
80102d1a:	83 e0 0f             	and    $0xf,%eax
80102d1d:	c1 ea 04             	shr    $0x4,%edx
80102d20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d2c:	89 c2                	mov    %eax,%edx
80102d2e:	83 e0 0f             	and    $0xf,%eax
80102d31:	c1 ea 04             	shr    $0x4,%edx
80102d34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d40:	89 c2                	mov    %eax,%edx
80102d42:	83 e0 0f             	and    $0xf,%eax
80102d45:	c1 ea 04             	shr    $0x4,%edx
80102d48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d54:	89 c2                	mov    %eax,%edx
80102d56:	83 e0 0f             	and    $0xf,%eax
80102d59:	c1 ea 04             	shr    $0x4,%edx
80102d5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d65:	8b 75 08             	mov    0x8(%ebp),%esi
80102d68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d6b:	89 06                	mov    %eax,(%esi)
80102d6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d70:	89 46 04             	mov    %eax,0x4(%esi)
80102d73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d76:	89 46 08             	mov    %eax,0x8(%esi)
80102d79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d82:	89 46 10             	mov    %eax,0x10(%esi)
80102d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d95:	5b                   	pop    %ebx
80102d96:	5e                   	pop    %esi
80102d97:	5f                   	pop    %edi
80102d98:	5d                   	pop    %ebp
80102d99:	c3                   	ret    
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	8b 0d 48 27 11 80    	mov    0x80112748,%ecx
80102da6:	85 c9                	test   %ecx,%ecx
80102da8:	0f 8e 8a 00 00 00    	jle    80102e38 <install_trans+0x98>
{
80102dae:	55                   	push   %ebp
80102daf:	89 e5                	mov    %esp,%ebp
80102db1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102db2:	31 ff                	xor    %edi,%edi
{
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102dc0:	a1 34 27 11 80       	mov    0x80112734,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 f8                	add    %edi,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 44 27 11 80    	push   0x80112744
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 bd 4c 27 11 80 	push   -0x7feed8b4(,%edi,4)
80102de4:	ff 35 44 27 11 80    	push   0x80112744
  for (tail = 0; tail < log.lh.n; tail++) {
80102dea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ded:	e8 de d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102df5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dfa:	68 00 02 00 00       	push   $0x200
80102dff:	50                   	push   %eax
80102e00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e03:	50                   	push   %eax
80102e04:	e8 77 1b 00 00       	call   80104980 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e09:	89 1c 24             	mov    %ebx,(%esp)
80102e0c:	e8 9f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e11:	89 34 24             	mov    %esi,(%esp)
80102e14:	e8 d7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e19:	89 1c 24             	mov    %ebx,(%esp)
80102e1c:	e8 cf d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	39 3d 48 27 11 80    	cmp    %edi,0x80112748
80102e2a:	7f 94                	jg     80102dc0 <install_trans+0x20>
  }
}
80102e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2f:	5b                   	pop    %ebx
80102e30:	5e                   	pop    %esi
80102e31:	5f                   	pop    %edi
80102e32:	5d                   	pop    %ebp
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e38:	c3                   	ret    
80102e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e47:	ff 35 34 27 11 80    	push   0x80112734
80102e4d:	ff 35 44 27 11 80    	push   0x80112744
80102e53:	e8 78 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e5d:	a1 48 27 11 80       	mov    0x80112748,%eax
80102e62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e65:	85 c0                	test   %eax,%eax
80102e67:	7e 19                	jle    80102e82 <write_head+0x42>
80102e69:	31 d2                	xor    %edx,%edx
80102e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e70:	8b 0c 95 4c 27 11 80 	mov    -0x7feed8b4(,%edx,4),%ecx
80102e77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e7b:	83 c2 01             	add    $0x1,%edx
80102e7e:	39 d0                	cmp    %edx,%eax
80102e80:	75 ee                	jne    80102e70 <write_head+0x30>
  }
  bwrite(buf);
80102e82:	83 ec 0c             	sub    $0xc,%esp
80102e85:	53                   	push   %ebx
80102e86:	e8 25 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e8b:	89 1c 24             	mov    %ebx,(%esp)
80102e8e:	e8 5d d3 ff ff       	call   801001f0 <brelse>
}
80102e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e96:	83 c4 10             	add    $0x10,%esp
80102e99:	c9                   	leave  
80102e9a:	c3                   	ret    
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop

80102ea0 <initlog>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 2c             	sub    $0x2c,%esp
80102ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eaa:	68 80 7d 10 80       	push   $0x80107d80
80102eaf:	68 00 27 11 80       	push   $0x80112700
80102eb4:	e8 97 17 00 00       	call   80104650 <initlock>
  readsb(dev, &sb);
80102eb9:	58                   	pop    %eax
80102eba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 6b e6 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ec8:	59                   	pop    %ecx
  log.dev = dev;
80102ec9:	89 1d 44 27 11 80    	mov    %ebx,0x80112744
  log.size = sb.nlog;
80102ecf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ed2:	a3 34 27 11 80       	mov    %eax,0x80112734
  log.size = sb.nlog;
80102ed7:	89 15 38 27 11 80    	mov    %edx,0x80112738
  struct buf *buf = bread(log.dev, log.start);
80102edd:	5a                   	pop    %edx
80102ede:	50                   	push   %eax
80102edf:	53                   	push   %ebx
80102ee0:	e8 eb d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ee5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ee8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102eeb:	89 1d 48 27 11 80    	mov    %ebx,0x80112748
  for (i = 0; i < log.lh.n; i++) {
80102ef1:	85 db                	test   %ebx,%ebx
80102ef3:	7e 1d                	jle    80102f12 <initlog+0x72>
80102ef5:	31 d2                	xor    %edx,%edx
80102ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102efe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102f04:	89 0c 95 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f0b:	83 c2 01             	add    $0x1,%edx
80102f0e:	39 d3                	cmp    %edx,%ebx
80102f10:	75 ee                	jne    80102f00 <initlog+0x60>
  brelse(buf);
80102f12:	83 ec 0c             	sub    $0xc,%esp
80102f15:	50                   	push   %eax
80102f16:	e8 d5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f1b:	e8 80 fe ff ff       	call   80102da0 <install_trans>
  log.lh.n = 0;
80102f20:	c7 05 48 27 11 80 00 	movl   $0x0,0x80112748
80102f27:	00 00 00 
  write_head(); // clear the log
80102f2a:	e8 11 ff ff ff       	call   80102e40 <write_head>
}
80102f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f32:	83 c4 10             	add    $0x10,%esp
80102f35:	c9                   	leave  
80102f36:	c3                   	ret    
80102f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3e:	66 90                	xchg   %ax,%ax

80102f40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f46:	68 00 27 11 80       	push   $0x80112700
80102f4b:	e8 d0 18 00 00       	call   80104820 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 00 27 11 80       	push   $0x80112700
80102f60:	68 00 27 11 80       	push   $0x80112700
80102f65:	e8 56 13 00 00       	call   801042c0 <sleep>
80102f6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f6d:	a1 40 27 11 80       	mov    0x80112740,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 e2                	jne    80102f58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f76:	a1 3c 27 11 80       	mov    0x8011273c,%eax
80102f7b:	8b 15 48 27 11 80    	mov    0x80112748,%edx
80102f81:	83 c0 01             	add    $0x1,%eax
80102f84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f8a:	83 fa 1e             	cmp    $0x1e,%edx
80102f8d:	7f c9                	jg     80102f58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f92:	a3 3c 27 11 80       	mov    %eax,0x8011273c
      release(&log.lock);
80102f97:	68 00 27 11 80       	push   $0x80112700
80102f9c:	e8 1f 18 00 00       	call   801047c0 <release>
      break;
    }
  }
}
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	c9                   	leave  
80102fa5:	c3                   	ret    
80102fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fad:	8d 76 00             	lea    0x0(%esi),%esi

80102fb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fb9:	68 00 27 11 80       	push   $0x80112700
80102fbe:	e8 5d 18 00 00       	call   80104820 <acquire>
  log.outstanding -= 1;
80102fc3:	a1 3c 27 11 80       	mov    0x8011273c,%eax
  if(log.committing)
80102fc8:	8b 35 40 27 11 80    	mov    0x80112740,%esi
80102fce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fd4:	89 1d 3c 27 11 80    	mov    %ebx,0x8011273c
  if(log.committing)
80102fda:	85 f6                	test   %esi,%esi
80102fdc:	0f 85 22 01 00 00    	jne    80103104 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fe2:	85 db                	test   %ebx,%ebx
80102fe4:	0f 85 f6 00 00 00    	jne    801030e0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fea:	c7 05 40 27 11 80 01 	movl   $0x1,0x80112740
80102ff1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ff4:	83 ec 0c             	sub    $0xc,%esp
80102ff7:	68 00 27 11 80       	push   $0x80112700
80102ffc:	e8 bf 17 00 00       	call   801047c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103001:	8b 0d 48 27 11 80    	mov    0x80112748,%ecx
80103007:	83 c4 10             	add    $0x10,%esp
8010300a:	85 c9                	test   %ecx,%ecx
8010300c:	7f 42                	jg     80103050 <end_op+0xa0>
    acquire(&log.lock);
8010300e:	83 ec 0c             	sub    $0xc,%esp
80103011:	68 00 27 11 80       	push   $0x80112700
80103016:	e8 05 18 00 00       	call   80104820 <acquire>
    wakeup(&log);
8010301b:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
    log.committing = 0;
80103022:	c7 05 40 27 11 80 00 	movl   $0x0,0x80112740
80103029:	00 00 00 
    wakeup(&log);
8010302c:	e8 4f 13 00 00       	call   80104380 <wakeup>
    release(&log.lock);
80103031:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
80103038:	e8 83 17 00 00       	call   801047c0 <release>
8010303d:	83 c4 10             	add    $0x10,%esp
}
80103040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103043:	5b                   	pop    %ebx
80103044:	5e                   	pop    %esi
80103045:	5f                   	pop    %edi
80103046:	5d                   	pop    %ebp
80103047:	c3                   	ret    
80103048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103050:	a1 34 27 11 80       	mov    0x80112734,%eax
80103055:	83 ec 08             	sub    $0x8,%esp
80103058:	01 d8                	add    %ebx,%eax
8010305a:	83 c0 01             	add    $0x1,%eax
8010305d:	50                   	push   %eax
8010305e:	ff 35 44 27 11 80    	push   0x80112744
80103064:	e8 67 d0 ff ff       	call   801000d0 <bread>
80103069:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010306b:	58                   	pop    %eax
8010306c:	5a                   	pop    %edx
8010306d:	ff 34 9d 4c 27 11 80 	push   -0x7feed8b4(,%ebx,4)
80103074:	ff 35 44 27 11 80    	push   0x80112744
  for (tail = 0; tail < log.lh.n; tail++) {
8010307a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010307d:	e8 4e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103082:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103085:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103087:	8d 40 5c             	lea    0x5c(%eax),%eax
8010308a:	68 00 02 00 00       	push   $0x200
8010308f:	50                   	push   %eax
80103090:	8d 46 5c             	lea    0x5c(%esi),%eax
80103093:	50                   	push   %eax
80103094:	e8 e7 18 00 00       	call   80104980 <memmove>
    bwrite(to);  // write the log
80103099:	89 34 24             	mov    %esi,(%esp)
8010309c:	e8 0f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030a1:	89 3c 24             	mov    %edi,(%esp)
801030a4:	e8 47 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030a9:	89 34 24             	mov    %esi,(%esp)
801030ac:	e8 3f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	3b 1d 48 27 11 80    	cmp    0x80112748,%ebx
801030ba:	7c 94                	jl     80103050 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030bc:	e8 7f fd ff ff       	call   80102e40 <write_head>
    install_trans(); // Now install writes to home locations
801030c1:	e8 da fc ff ff       	call   80102da0 <install_trans>
    log.lh.n = 0;
801030c6:	c7 05 48 27 11 80 00 	movl   $0x0,0x80112748
801030cd:	00 00 00 
    write_head();    // Erase the transaction from the log
801030d0:	e8 6b fd ff ff       	call   80102e40 <write_head>
801030d5:	e9 34 ff ff ff       	jmp    8010300e <end_op+0x5e>
801030da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030e0:	83 ec 0c             	sub    $0xc,%esp
801030e3:	68 00 27 11 80       	push   $0x80112700
801030e8:	e8 93 12 00 00       	call   80104380 <wakeup>
  release(&log.lock);
801030ed:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
801030f4:	e8 c7 16 00 00       	call   801047c0 <release>
801030f9:	83 c4 10             	add    $0x10,%esp
}
801030fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ff:	5b                   	pop    %ebx
80103100:	5e                   	pop    %esi
80103101:	5f                   	pop    %edi
80103102:	5d                   	pop    %ebp
80103103:	c3                   	ret    
    panic("log.committing");
80103104:	83 ec 0c             	sub    $0xc,%esp
80103107:	68 84 7d 10 80       	push   $0x80107d84
8010310c:	e8 6f d2 ff ff       	call   80100380 <panic>
80103111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010311f:	90                   	nop

80103120 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103127:	8b 15 48 27 11 80    	mov    0x80112748,%edx
{
8010312d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103130:	83 fa 1d             	cmp    $0x1d,%edx
80103133:	0f 8f 85 00 00 00    	jg     801031be <log_write+0x9e>
80103139:	a1 38 27 11 80       	mov    0x80112738,%eax
8010313e:	83 e8 01             	sub    $0x1,%eax
80103141:	39 c2                	cmp    %eax,%edx
80103143:	7d 79                	jge    801031be <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103145:	a1 3c 27 11 80       	mov    0x8011273c,%eax
8010314a:	85 c0                	test   %eax,%eax
8010314c:	7e 7d                	jle    801031cb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010314e:	83 ec 0c             	sub    $0xc,%esp
80103151:	68 00 27 11 80       	push   $0x80112700
80103156:	e8 c5 16 00 00       	call   80104820 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010315b:	8b 15 48 27 11 80    	mov    0x80112748,%edx
80103161:	83 c4 10             	add    $0x10,%esp
80103164:	85 d2                	test   %edx,%edx
80103166:	7e 4a                	jle    801031b2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103168:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010316b:	31 c0                	xor    %eax,%eax
8010316d:	eb 08                	jmp    80103177 <log_write+0x57>
8010316f:	90                   	nop
80103170:	83 c0 01             	add    $0x1,%eax
80103173:	39 c2                	cmp    %eax,%edx
80103175:	74 29                	je     801031a0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103177:	39 0c 85 4c 27 11 80 	cmp    %ecx,-0x7feed8b4(,%eax,4)
8010317e:	75 f0                	jne    80103170 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103180:	89 0c 85 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103187:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010318a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010318d:	c7 45 08 00 27 11 80 	movl   $0x80112700,0x8(%ebp)
}
80103194:	c9                   	leave  
  release(&log.lock);
80103195:	e9 26 16 00 00       	jmp    801047c0 <release>
8010319a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031a0:	89 0c 95 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%edx,4)
    log.lh.n++;
801031a7:	83 c2 01             	add    $0x1,%edx
801031aa:	89 15 48 27 11 80    	mov    %edx,0x80112748
801031b0:	eb d5                	jmp    80103187 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801031b2:	8b 43 08             	mov    0x8(%ebx),%eax
801031b5:	a3 4c 27 11 80       	mov    %eax,0x8011274c
  if (i == log.lh.n)
801031ba:	75 cb                	jne    80103187 <log_write+0x67>
801031bc:	eb e9                	jmp    801031a7 <log_write+0x87>
    panic("too big a transaction");
801031be:	83 ec 0c             	sub    $0xc,%esp
801031c1:	68 93 7d 10 80       	push   $0x80107d93
801031c6:	e8 b5 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031cb:	83 ec 0c             	sub    $0xc,%esp
801031ce:	68 a9 7d 10 80       	push   $0x80107da9
801031d3:	e8 a8 d1 ff ff       	call   80100380 <panic>
801031d8:	66 90                	xchg   %ax,%ax
801031da:	66 90                	xchg   %ax,%ax
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	53                   	push   %ebx
801031e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031e7:	e8 54 09 00 00       	call   80103b40 <cpuid>
801031ec:	89 c3                	mov    %eax,%ebx
801031ee:	e8 4d 09 00 00       	call   80103b40 <cpuid>
801031f3:	83 ec 04             	sub    $0x4,%esp
801031f6:	53                   	push   %ebx
801031f7:	50                   	push   %eax
801031f8:	68 c4 7d 10 80       	push   $0x80107dc4
801031fd:	e8 9e d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103202:	e8 d9 2a 00 00       	call   80105ce0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103207:	e8 d4 08 00 00       	call   80103ae0 <mycpu>
8010320c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010320e:	b8 01 00 00 00       	mov    $0x1,%eax
80103213:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010321a:	e8 91 0c 00 00       	call   80103eb0 <scheduler>
8010321f:	90                   	nop

80103220 <mpenter>:
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103226:	e8 d5 3c 00 00       	call   80106f00 <switchkvm>
  seginit();
8010322b:	e8 40 3c 00 00       	call   80106e70 <seginit>
  lapicinit();
80103230:	e8 9b f7 ff ff       	call   801029d0 <lapicinit>
  mpmain();
80103235:	e8 a6 ff ff ff       	call   801031e0 <mpmain>
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <main>:
{
80103240:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103244:	83 e4 f0             	and    $0xfffffff0,%esp
80103247:	ff 71 fc             	push   -0x4(%ecx)
8010324a:	55                   	push   %ebp
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	53                   	push   %ebx
8010324e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010324f:	83 ec 08             	sub    $0x8,%esp
80103252:	68 00 00 40 80       	push   $0x80400000
80103257:	68 30 66 11 80       	push   $0x80116630
8010325c:	e8 bf f3 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103261:	e8 8a 43 00 00       	call   801075f0 <kvmalloc>
  mpinit();        // detect other processors
80103266:	e8 95 01 00 00       	call   80103400 <mpinit>
  lapicinit();     // interrupt controller
8010326b:	e8 60 f7 ff ff       	call   801029d0 <lapicinit>
  seginit();       // segment descriptors
80103270:	e8 fb 3b 00 00       	call   80106e70 <seginit>
  picinit();       // disable pic
80103275:	e8 86 03 00 00       	call   80103600 <picinit>
  ioapicinit();    // another interrupt controller
8010327a:	e8 61 f1 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
8010327f:	e8 dc d7 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103284:	e8 47 2d 00 00       	call   80105fd0 <uartinit>
  pinit();         // process table
80103289:	e8 32 08 00 00       	call   80103ac0 <pinit>
  tvinit();        // trap vectors
8010328e:	e8 cd 29 00 00       	call   80105c60 <tvinit>
  binit();         // buffer cache
80103293:	e8 a8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103298:	e8 83 db ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
8010329d:	e8 2e ef ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032a2:	83 c4 0c             	add    $0xc,%esp
801032a5:	68 8a 00 00 00       	push   $0x8a
801032aa:	68 9c b4 10 80       	push   $0x8010b49c
801032af:	68 00 70 00 80       	push   $0x80007000
801032b4:	e8 c7 16 00 00       	call   80104980 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	69 05 e4 27 11 80 b0 	imul   $0xb0,0x801127e4,%eax
801032c3:	00 00 00 
801032c6:	05 00 28 11 80       	add    $0x80112800,%eax
801032cb:	3d 00 28 11 80       	cmp    $0x80112800,%eax
801032d0:	76 7e                	jbe    80103350 <main+0x110>
801032d2:	bb 00 28 11 80       	mov    $0x80112800,%ebx
801032d7:	eb 20                	jmp    801032f9 <main+0xb9>
801032d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032e0:	69 05 e4 27 11 80 b0 	imul   $0xb0,0x801127e4,%eax
801032e7:	00 00 00 
801032ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032f0:	05 00 28 11 80       	add    $0x80112800,%eax
801032f5:	39 c3                	cmp    %eax,%ebx
801032f7:	73 57                	jae    80103350 <main+0x110>
    if(c == mycpu())  // We've started already.
801032f9:	e8 e2 07 00 00       	call   80103ae0 <mycpu>
801032fe:	39 c3                	cmp    %eax,%ebx
80103300:	74 de                	je     801032e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103302:	e8 e9 f4 ff ff       	call   801027f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103307:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010330a:	c7 05 f8 6f 00 80 20 	movl   $0x80103220,0x80006ff8
80103311:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103314:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010331b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010331e:	05 00 10 00 00       	add    $0x1000,%eax
80103323:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103328:	0f b6 03             	movzbl (%ebx),%eax
8010332b:	68 00 70 00 00       	push   $0x7000
80103330:	50                   	push   %eax
80103331:	e8 ea f7 ff ff       	call   80102b20 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103336:	83 c4 10             	add    $0x10,%esp
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103340:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103346:	85 c0                	test   %eax,%eax
80103348:	74 f6                	je     80103340 <main+0x100>
8010334a:	eb 94                	jmp    801032e0 <main+0xa0>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103350:	83 ec 08             	sub    $0x8,%esp
80103353:	68 00 00 00 8e       	push   $0x8e000000
80103358:	68 00 00 40 80       	push   $0x80400000
8010335d:	e8 5e f2 ff ff       	call   801025c0 <kinit2>
  khugeinit(P2V(HUGE_PAGE_START), P2V(HUGE_PAGE_END));
80103362:	58                   	pop    %eax
80103363:	5a                   	pop    %edx
80103364:	68 00 00 00 be       	push   $0xbe000000
80103369:	68 00 00 00 9e       	push   $0x9e000000
8010336e:	e8 0d f4 ff ff       	call   80102780 <khugeinit>
  userinit();      // first user process
80103373:	e8 18 08 00 00       	call   80103b90 <userinit>
  mpmain();        // finish this processor's setup
80103378:	e8 63 fe ff ff       	call   801031e0 <mpmain>
8010337d:	66 90                	xchg   %ax,%ax
8010337f:	90                   	nop

80103380 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103385:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010338b:	53                   	push   %ebx
  e = addr+len;
8010338c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010338f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103392:	39 de                	cmp    %ebx,%esi
80103394:	72 10                	jb     801033a6 <mpsearch1+0x26>
80103396:	eb 50                	jmp    801033e8 <mpsearch1+0x68>
80103398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010339f:	90                   	nop
801033a0:	89 fe                	mov    %edi,%esi
801033a2:	39 fb                	cmp    %edi,%ebx
801033a4:	76 42                	jbe    801033e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033a6:	83 ec 04             	sub    $0x4,%esp
801033a9:	8d 7e 10             	lea    0x10(%esi),%edi
801033ac:	6a 04                	push   $0x4
801033ae:	68 d8 7d 10 80       	push   $0x80107dd8
801033b3:	56                   	push   %esi
801033b4:	e8 77 15 00 00       	call   80104930 <memcmp>
801033b9:	83 c4 10             	add    $0x10,%esp
801033bc:	85 c0                	test   %eax,%eax
801033be:	75 e0                	jne    801033a0 <mpsearch1+0x20>
801033c0:	89 f2                	mov    %esi,%edx
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033c8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033cb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033d0:	39 fa                	cmp    %edi,%edx
801033d2:	75 f4                	jne    801033c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033d4:	84 c0                	test   %al,%al
801033d6:	75 c8                	jne    801033a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033db:	89 f0                	mov    %esi,%eax
801033dd:	5b                   	pop    %ebx
801033de:	5e                   	pop    %esi
801033df:	5f                   	pop    %edi
801033e0:	5d                   	pop    %ebp
801033e1:	c3                   	ret    
801033e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033eb:	31 f6                	xor    %esi,%esi
}
801033ed:	5b                   	pop    %ebx
801033ee:	89 f0                	mov    %esi,%eax
801033f0:	5e                   	pop    %esi
801033f1:	5f                   	pop    %edi
801033f2:	5d                   	pop    %ebp
801033f3:	c3                   	ret    
801033f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033ff:	90                   	nop

80103400 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103409:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103410:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103417:	c1 e0 08             	shl    $0x8,%eax
8010341a:	09 d0                	or     %edx,%eax
8010341c:	c1 e0 04             	shl    $0x4,%eax
8010341f:	75 1b                	jne    8010343c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103421:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103428:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010342f:	c1 e0 08             	shl    $0x8,%eax
80103432:	09 d0                	or     %edx,%eax
80103434:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103437:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010343c:	ba 00 04 00 00       	mov    $0x400,%edx
80103441:	e8 3a ff ff ff       	call   80103380 <mpsearch1>
80103446:	89 c3                	mov    %eax,%ebx
80103448:	85 c0                	test   %eax,%eax
8010344a:	0f 84 40 01 00 00    	je     80103590 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103450:	8b 73 04             	mov    0x4(%ebx),%esi
80103453:	85 f6                	test   %esi,%esi
80103455:	0f 84 25 01 00 00    	je     80103580 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010345b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010345e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103464:	6a 04                	push   $0x4
80103466:	68 dd 7d 10 80       	push   $0x80107ddd
8010346b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010346c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010346f:	e8 bc 14 00 00       	call   80104930 <memcmp>
80103474:	83 c4 10             	add    $0x10,%esp
80103477:	85 c0                	test   %eax,%eax
80103479:	0f 85 01 01 00 00    	jne    80103580 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010347f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103486:	3c 01                	cmp    $0x1,%al
80103488:	74 08                	je     80103492 <mpinit+0x92>
8010348a:	3c 04                	cmp    $0x4,%al
8010348c:	0f 85 ee 00 00 00    	jne    80103580 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103492:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103499:	66 85 d2             	test   %dx,%dx
8010349c:	74 22                	je     801034c0 <mpinit+0xc0>
8010349e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801034a1:	89 f0                	mov    %esi,%eax
  sum = 0;
801034a3:	31 d2                	xor    %edx,%edx
801034a5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034a8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801034af:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034b2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034b4:	39 c7                	cmp    %eax,%edi
801034b6:	75 f0                	jne    801034a8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034b8:	84 d2                	test   %dl,%dl
801034ba:	0f 85 c0 00 00 00    	jne    80103580 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034c0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801034c6:	a3 e0 26 11 80       	mov    %eax,0x801126e0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034cb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034d2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034d8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034dd:	03 55 e4             	add    -0x1c(%ebp),%edx
801034e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e7:	90                   	nop
801034e8:	39 d0                	cmp    %edx,%eax
801034ea:	73 15                	jae    80103501 <mpinit+0x101>
    switch(*p){
801034ec:	0f b6 08             	movzbl (%eax),%ecx
801034ef:	80 f9 02             	cmp    $0x2,%cl
801034f2:	74 4c                	je     80103540 <mpinit+0x140>
801034f4:	77 3a                	ja     80103530 <mpinit+0x130>
801034f6:	84 c9                	test   %cl,%cl
801034f8:	74 56                	je     80103550 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034fa:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034fd:	39 d0                	cmp    %edx,%eax
801034ff:	72 eb                	jb     801034ec <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103501:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103504:	85 f6                	test   %esi,%esi
80103506:	0f 84 d9 00 00 00    	je     801035e5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010350c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103510:	74 15                	je     80103527 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103512:	b8 70 00 00 00       	mov    $0x70,%eax
80103517:	ba 22 00 00 00       	mov    $0x22,%edx
8010351c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010351d:	ba 23 00 00 00       	mov    $0x23,%edx
80103522:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103523:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103526:	ee                   	out    %al,(%dx)
  }
}
80103527:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010352a:	5b                   	pop    %ebx
8010352b:	5e                   	pop    %esi
8010352c:	5f                   	pop    %edi
8010352d:	5d                   	pop    %ebp
8010352e:	c3                   	ret    
8010352f:	90                   	nop
    switch(*p){
80103530:	83 e9 03             	sub    $0x3,%ecx
80103533:	80 f9 01             	cmp    $0x1,%cl
80103536:	76 c2                	jbe    801034fa <mpinit+0xfa>
80103538:	31 f6                	xor    %esi,%esi
8010353a:	eb ac                	jmp    801034e8 <mpinit+0xe8>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103540:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103544:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103547:	88 0d e0 27 11 80    	mov    %cl,0x801127e0
      continue;
8010354d:	eb 99                	jmp    801034e8 <mpinit+0xe8>
8010354f:	90                   	nop
      if(ncpu < NCPU) {
80103550:	8b 0d e4 27 11 80    	mov    0x801127e4,%ecx
80103556:	83 f9 07             	cmp    $0x7,%ecx
80103559:	7f 19                	jg     80103574 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010355b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103561:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103565:	83 c1 01             	add    $0x1,%ecx
80103568:	89 0d e4 27 11 80    	mov    %ecx,0x801127e4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010356e:	88 9f 00 28 11 80    	mov    %bl,-0x7feed800(%edi)
      p += sizeof(struct mpproc);
80103574:	83 c0 14             	add    $0x14,%eax
      continue;
80103577:	e9 6c ff ff ff       	jmp    801034e8 <mpinit+0xe8>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	68 e2 7d 10 80       	push   $0x80107de2
80103588:	e8 f3 cd ff ff       	call   80100380 <panic>
8010358d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103590:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103595:	eb 13                	jmp    801035aa <mpinit+0x1aa>
80103597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010359e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801035a0:	89 f3                	mov    %esi,%ebx
801035a2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801035a8:	74 d6                	je     80103580 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035aa:	83 ec 04             	sub    $0x4,%esp
801035ad:	8d 73 10             	lea    0x10(%ebx),%esi
801035b0:	6a 04                	push   $0x4
801035b2:	68 d8 7d 10 80       	push   $0x80107dd8
801035b7:	53                   	push   %ebx
801035b8:	e8 73 13 00 00       	call   80104930 <memcmp>
801035bd:	83 c4 10             	add    $0x10,%esp
801035c0:	85 c0                	test   %eax,%eax
801035c2:	75 dc                	jne    801035a0 <mpinit+0x1a0>
801035c4:	89 da                	mov    %ebx,%edx
801035c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035cd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035d0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035d3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035d6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035d8:	39 d6                	cmp    %edx,%esi
801035da:	75 f4                	jne    801035d0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035dc:	84 c0                	test   %al,%al
801035de:	75 c0                	jne    801035a0 <mpinit+0x1a0>
801035e0:	e9 6b fe ff ff       	jmp    80103450 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035e5:	83 ec 0c             	sub    $0xc,%esp
801035e8:	68 fc 7d 10 80       	push   $0x80107dfc
801035ed:	e8 8e cd ff ff       	call   80100380 <panic>
801035f2:	66 90                	xchg   %ax,%ax
801035f4:	66 90                	xchg   %ax,%ax
801035f6:	66 90                	xchg   %ax,%ax
801035f8:	66 90                	xchg   %ax,%ax
801035fa:	66 90                	xchg   %ax,%ax
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <picinit>:
80103600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103605:	ba 21 00 00 00       	mov    $0x21,%edx
8010360a:	ee                   	out    %al,(%dx)
8010360b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103610:	ee                   	out    %al,(%dx)
80103611:	c3                   	ret    
80103612:	66 90                	xchg   %ax,%ax
80103614:	66 90                	xchg   %ax,%ax
80103616:	66 90                	xchg   %ax,%ax
80103618:	66 90                	xchg   %ax,%ax
8010361a:	66 90                	xchg   %ax,%ax
8010361c:	66 90                	xchg   %ax,%ax
8010361e:	66 90                	xchg   %ax,%ax

80103620 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	57                   	push   %edi
80103624:	56                   	push   %esi
80103625:	53                   	push   %ebx
80103626:	83 ec 0c             	sub    $0xc,%esp
80103629:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010362c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010362f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103635:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010363b:	e8 00 d8 ff ff       	call   80100e40 <filealloc>
80103640:	89 03                	mov    %eax,(%ebx)
80103642:	85 c0                	test   %eax,%eax
80103644:	0f 84 a8 00 00 00    	je     801036f2 <pipealloc+0xd2>
8010364a:	e8 f1 d7 ff ff       	call   80100e40 <filealloc>
8010364f:	89 06                	mov    %eax,(%esi)
80103651:	85 c0                	test   %eax,%eax
80103653:	0f 84 87 00 00 00    	je     801036e0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103659:	e8 92 f1 ff ff       	call   801027f0 <kalloc>
8010365e:	89 c7                	mov    %eax,%edi
80103660:	85 c0                	test   %eax,%eax
80103662:	0f 84 b0 00 00 00    	je     80103718 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103668:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010366f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103672:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103675:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010367c:	00 00 00 
  p->nwrite = 0;
8010367f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103686:	00 00 00 
  p->nread = 0;
80103689:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103690:	00 00 00 
  initlock(&p->lock, "pipe");
80103693:	68 1b 7e 10 80       	push   $0x80107e1b
80103698:	50                   	push   %eax
80103699:	e8 b2 0f 00 00       	call   80104650 <initlock>
  (*f0)->type = FD_PIPE;
8010369e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036a0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036a9:	8b 03                	mov    (%ebx),%eax
801036ab:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036af:	8b 03                	mov    (%ebx),%eax
801036b1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036b5:	8b 03                	mov    (%ebx),%eax
801036b7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ba:	8b 06                	mov    (%esi),%eax
801036bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036c2:	8b 06                	mov    (%esi),%eax
801036c4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036c8:	8b 06                	mov    (%esi),%eax
801036ca:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036ce:	8b 06                	mov    (%esi),%eax
801036d0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036d6:	31 c0                	xor    %eax,%eax
}
801036d8:	5b                   	pop    %ebx
801036d9:	5e                   	pop    %esi
801036da:	5f                   	pop    %edi
801036db:	5d                   	pop    %ebp
801036dc:	c3                   	ret    
801036dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801036e0:	8b 03                	mov    (%ebx),%eax
801036e2:	85 c0                	test   %eax,%eax
801036e4:	74 1e                	je     80103704 <pipealloc+0xe4>
    fileclose(*f0);
801036e6:	83 ec 0c             	sub    $0xc,%esp
801036e9:	50                   	push   %eax
801036ea:	e8 11 d8 ff ff       	call   80100f00 <fileclose>
801036ef:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036f2:	8b 06                	mov    (%esi),%eax
801036f4:	85 c0                	test   %eax,%eax
801036f6:	74 0c                	je     80103704 <pipealloc+0xe4>
    fileclose(*f1);
801036f8:	83 ec 0c             	sub    $0xc,%esp
801036fb:	50                   	push   %eax
801036fc:	e8 ff d7 ff ff       	call   80100f00 <fileclose>
80103701:	83 c4 10             	add    $0x10,%esp
}
80103704:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103707:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010370c:	5b                   	pop    %ebx
8010370d:	5e                   	pop    %esi
8010370e:	5f                   	pop    %edi
8010370f:	5d                   	pop    %ebp
80103710:	c3                   	ret    
80103711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103718:	8b 03                	mov    (%ebx),%eax
8010371a:	85 c0                	test   %eax,%eax
8010371c:	75 c8                	jne    801036e6 <pipealloc+0xc6>
8010371e:	eb d2                	jmp    801036f2 <pipealloc+0xd2>

80103720 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103728:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	53                   	push   %ebx
8010372f:	e8 ec 10 00 00       	call   80104820 <acquire>
  if(writable){
80103734:	83 c4 10             	add    $0x10,%esp
80103737:	85 f6                	test   %esi,%esi
80103739:	74 65                	je     801037a0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103744:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010374b:	00 00 00 
    wakeup(&p->nread);
8010374e:	50                   	push   %eax
8010374f:	e8 2c 0c 00 00       	call   80104380 <wakeup>
80103754:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103757:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010375d:	85 d2                	test   %edx,%edx
8010375f:	75 0a                	jne    8010376b <pipeclose+0x4b>
80103761:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103767:	85 c0                	test   %eax,%eax
80103769:	74 15                	je     80103780 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010376b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010376e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103771:	5b                   	pop    %ebx
80103772:	5e                   	pop    %esi
80103773:	5d                   	pop    %ebp
    release(&p->lock);
80103774:	e9 47 10 00 00       	jmp    801047c0 <release>
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
80103783:	53                   	push   %ebx
80103784:	e8 37 10 00 00       	call   801047c0 <release>
    kfree((char*)p);
80103789:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010378c:	83 c4 10             	add    $0x10,%esp
}
8010378f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103792:	5b                   	pop    %ebx
80103793:	5e                   	pop    %esi
80103794:	5d                   	pop    %ebp
    kfree((char*)p);
80103795:	e9 36 ed ff ff       	jmp    801024d0 <kfree>
8010379a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037b0:	00 00 00 
    wakeup(&p->nwrite);
801037b3:	50                   	push   %eax
801037b4:	e8 c7 0b 00 00       	call   80104380 <wakeup>
801037b9:	83 c4 10             	add    $0x10,%esp
801037bc:	eb 99                	jmp    80103757 <pipeclose+0x37>
801037be:	66 90                	xchg   %ax,%ax

801037c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	57                   	push   %edi
801037c4:	56                   	push   %esi
801037c5:	53                   	push   %ebx
801037c6:	83 ec 28             	sub    $0x28,%esp
801037c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037cc:	53                   	push   %ebx
801037cd:	e8 4e 10 00 00       	call   80104820 <acquire>
  for(i = 0; i < n; i++){
801037d2:	8b 45 10             	mov    0x10(%ebp),%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	85 c0                	test   %eax,%eax
801037da:	0f 8e c0 00 00 00    	jle    801038a0 <pipewrite+0xe0>
801037e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037e3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037e9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037f2:	03 45 10             	add    0x10(%ebp),%eax
801037f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037fe:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103804:	89 ca                	mov    %ecx,%edx
80103806:	05 00 02 00 00       	add    $0x200,%eax
8010380b:	39 c1                	cmp    %eax,%ecx
8010380d:	74 3f                	je     8010384e <pipewrite+0x8e>
8010380f:	eb 67                	jmp    80103878 <pipewrite+0xb8>
80103811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103818:	e8 43 03 00 00       	call   80103b60 <myproc>
8010381d:	8b 48 28             	mov    0x28(%eax),%ecx
80103820:	85 c9                	test   %ecx,%ecx
80103822:	75 34                	jne    80103858 <pipewrite+0x98>
      wakeup(&p->nread);
80103824:	83 ec 0c             	sub    $0xc,%esp
80103827:	57                   	push   %edi
80103828:	e8 53 0b 00 00       	call   80104380 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010382d:	58                   	pop    %eax
8010382e:	5a                   	pop    %edx
8010382f:	53                   	push   %ebx
80103830:	56                   	push   %esi
80103831:	e8 8a 0a 00 00       	call   801042c0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103836:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010383c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103842:	83 c4 10             	add    $0x10,%esp
80103845:	05 00 02 00 00       	add    $0x200,%eax
8010384a:	39 c2                	cmp    %eax,%edx
8010384c:	75 2a                	jne    80103878 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010384e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103854:	85 c0                	test   %eax,%eax
80103856:	75 c0                	jne    80103818 <pipewrite+0x58>
        release(&p->lock);
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	53                   	push   %ebx
8010385c:	e8 5f 0f 00 00       	call   801047c0 <release>
        return -1;
80103861:	83 c4 10             	add    $0x10,%esp
80103864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386c:	5b                   	pop    %ebx
8010386d:	5e                   	pop    %esi
8010386e:	5f                   	pop    %edi
8010386f:	5d                   	pop    %ebp
80103870:	c3                   	ret    
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103878:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010387b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010387e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103884:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010388a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010388d:	83 c6 01             	add    $0x1,%esi
80103890:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103893:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103897:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010389a:	0f 85 58 ff ff ff    	jne    801037f8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038a9:	50                   	push   %eax
801038aa:	e8 d1 0a 00 00       	call   80104380 <wakeup>
  release(&p->lock);
801038af:	89 1c 24             	mov    %ebx,(%esp)
801038b2:	e8 09 0f 00 00       	call   801047c0 <release>
  return n;
801038b7:	8b 45 10             	mov    0x10(%ebp),%eax
801038ba:	83 c4 10             	add    $0x10,%esp
801038bd:	eb aa                	jmp    80103869 <pipewrite+0xa9>
801038bf:	90                   	nop

801038c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	57                   	push   %edi
801038c4:	56                   	push   %esi
801038c5:	53                   	push   %ebx
801038c6:	83 ec 18             	sub    $0x18,%esp
801038c9:	8b 75 08             	mov    0x8(%ebp),%esi
801038cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038cf:	56                   	push   %esi
801038d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038d6:	e8 45 0f 00 00       	call   80104820 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038e1:	83 c4 10             	add    $0x10,%esp
801038e4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038ea:	74 2f                	je     8010391b <piperead+0x5b>
801038ec:	eb 37                	jmp    80103925 <piperead+0x65>
801038ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038f0:	e8 6b 02 00 00       	call   80103b60 <myproc>
801038f5:	8b 48 28             	mov    0x28(%eax),%ecx
801038f8:	85 c9                	test   %ecx,%ecx
801038fa:	0f 85 80 00 00 00    	jne    80103980 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103900:	83 ec 08             	sub    $0x8,%esp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
80103905:	e8 b6 09 00 00       	call   801042c0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010390a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103910:	83 c4 10             	add    $0x10,%esp
80103913:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103919:	75 0a                	jne    80103925 <piperead+0x65>
8010391b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103921:	85 c0                	test   %eax,%eax
80103923:	75 cb                	jne    801038f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103925:	8b 55 10             	mov    0x10(%ebp),%edx
80103928:	31 db                	xor    %ebx,%ebx
8010392a:	85 d2                	test   %edx,%edx
8010392c:	7f 20                	jg     8010394e <piperead+0x8e>
8010392e:	eb 2c                	jmp    8010395c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103930:	8d 48 01             	lea    0x1(%eax),%ecx
80103933:	25 ff 01 00 00       	and    $0x1ff,%eax
80103938:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010393e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103943:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103946:	83 c3 01             	add    $0x1,%ebx
80103949:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010394c:	74 0e                	je     8010395c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010394e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103954:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010395a:	75 d4                	jne    80103930 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010395c:	83 ec 0c             	sub    $0xc,%esp
8010395f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103965:	50                   	push   %eax
80103966:	e8 15 0a 00 00       	call   80104380 <wakeup>
  release(&p->lock);
8010396b:	89 34 24             	mov    %esi,(%esp)
8010396e:	e8 4d 0e 00 00       	call   801047c0 <release>
  return i;
80103973:	83 c4 10             	add    $0x10,%esp
}
80103976:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103979:	89 d8                	mov    %ebx,%eax
8010397b:	5b                   	pop    %ebx
8010397c:	5e                   	pop    %esi
8010397d:	5f                   	pop    %edi
8010397e:	5d                   	pop    %ebp
8010397f:	c3                   	ret    
      release(&p->lock);
80103980:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103983:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103988:	56                   	push   %esi
80103989:	e8 32 0e 00 00       	call   801047c0 <release>
      return -1;
8010398e:	83 c4 10             	add    $0x10,%esp
}
80103991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103994:	89 d8                	mov    %ebx,%eax
80103996:	5b                   	pop    %ebx
80103997:	5e                   	pop    %esi
80103998:	5f                   	pop    %edi
80103999:	5d                   	pop    %ebp
8010399a:	c3                   	ret    
8010399b:	66 90                	xchg   %ax,%ax
8010399d:	66 90                	xchg   %ax,%ax
8010399f:	90                   	nop

801039a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a4:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
{
801039a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ac:	68 80 2d 11 80       	push   $0x80112d80
801039b1:	e8 6a 0e 00 00       	call   80104820 <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	eb 10                	jmp    801039cb <allocproc+0x2b>
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c0:	83 eb 80             	sub    $0xffffff80,%ebx
801039c3:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
801039c9:	74 75                	je     80103a40 <allocproc+0xa0>
    if(p->state == UNUSED)
801039cb:	8b 43 10             	mov    0x10(%ebx),%eax
801039ce:	85 c0                	test   %eax,%eax
801039d0:	75 ee                	jne    801039c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039d2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039da:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039e1:	89 43 14             	mov    %eax,0x14(%ebx)
801039e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039e7:	68 80 2d 11 80       	push   $0x80112d80
  p->pid = nextpid++;
801039ec:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039f2:	e8 c9 0d 00 00       	call   801047c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039f7:	e8 f4 ed ff ff       	call   801027f0 <kalloc>
801039fc:	83 c4 10             	add    $0x10,%esp
801039ff:	89 43 0c             	mov    %eax,0xc(%ebx)
80103a02:	85 c0                	test   %eax,%eax
80103a04:	74 53                	je     80103a59 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a06:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a0c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a0f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a14:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103a17:	c7 40 14 50 5c 10 80 	movl   $0x80105c50,0x14(%eax)
  p->context = (struct context*)sp;
80103a1e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a21:	6a 14                	push   $0x14
80103a23:	6a 00                	push   $0x0
80103a25:	50                   	push   %eax
80103a26:	e8 b5 0e 00 00       	call   801048e0 <memset>
  p->context->eip = (uint)forkret;
80103a2b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103a2e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a31:	c7 40 10 70 3a 10 80 	movl   $0x80103a70,0x10(%eax)
}
80103a38:	89 d8                	mov    %ebx,%eax
80103a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3d:	c9                   	leave  
80103a3e:	c3                   	ret    
80103a3f:	90                   	nop
  release(&ptable.lock);
80103a40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a43:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a45:	68 80 2d 11 80       	push   $0x80112d80
80103a4a:	e8 71 0d 00 00       	call   801047c0 <release>
}
80103a4f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a51:	83 c4 10             	add    $0x10,%esp
}
80103a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a57:	c9                   	leave  
80103a58:	c3                   	ret    
    p->state = UNUSED;
80103a59:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103a60:	31 db                	xor    %ebx,%ebx
}
80103a62:	89 d8                	mov    %ebx,%eax
80103a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a67:	c9                   	leave  
80103a68:	c3                   	ret    
80103a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a76:	68 80 2d 11 80       	push   $0x80112d80
80103a7b:	e8 40 0d 00 00       	call   801047c0 <release>

  if (first) {
80103a80:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	85 c0                	test   %eax,%eax
80103a8a:	75 04                	jne    80103a90 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a8c:	c9                   	leave  
80103a8d:	c3                   	ret    
80103a8e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a90:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a97:	00 00 00 
    iinit(ROOTDEV);
80103a9a:	83 ec 0c             	sub    $0xc,%esp
80103a9d:	6a 01                	push   $0x1
80103a9f:	e8 cc da ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103aa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aab:	e8 f0 f3 ff ff       	call   80102ea0 <initlog>
}
80103ab0:	83 c4 10             	add    $0x10,%esp
80103ab3:	c9                   	leave  
80103ab4:	c3                   	ret    
80103ab5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <pinit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ac6:	68 20 7e 10 80       	push   $0x80107e20
80103acb:	68 80 2d 11 80       	push   $0x80112d80
80103ad0:	e8 7b 0b 00 00       	call   80104650 <initlock>
}
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	c9                   	leave  
80103ad9:	c3                   	ret    
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ae0 <mycpu>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ae5:	9c                   	pushf  
80103ae6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ae7:	f6 c4 02             	test   $0x2,%ah
80103aea:	75 46                	jne    80103b32 <mycpu+0x52>
  apicid = lapicid();
80103aec:	e8 df ef ff ff       	call   80102ad0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103af1:	8b 35 e4 27 11 80    	mov    0x801127e4,%esi
80103af7:	85 f6                	test   %esi,%esi
80103af9:	7e 2a                	jle    80103b25 <mycpu+0x45>
80103afb:	31 d2                	xor    %edx,%edx
80103afd:	eb 08                	jmp    80103b07 <mycpu+0x27>
80103aff:	90                   	nop
80103b00:	83 c2 01             	add    $0x1,%edx
80103b03:	39 f2                	cmp    %esi,%edx
80103b05:	74 1e                	je     80103b25 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103b07:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b0d:	0f b6 99 00 28 11 80 	movzbl -0x7feed800(%ecx),%ebx
80103b14:	39 c3                	cmp    %eax,%ebx
80103b16:	75 e8                	jne    80103b00 <mycpu+0x20>
}
80103b18:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b1b:	8d 81 00 28 11 80    	lea    -0x7feed800(%ecx),%eax
}
80103b21:	5b                   	pop    %ebx
80103b22:	5e                   	pop    %esi
80103b23:	5d                   	pop    %ebp
80103b24:	c3                   	ret    
  panic("unknown apicid\n");
80103b25:	83 ec 0c             	sub    $0xc,%esp
80103b28:	68 27 7e 10 80       	push   $0x80107e27
80103b2d:	e8 4e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b32:	83 ec 0c             	sub    $0xc,%esp
80103b35:	68 04 7f 10 80       	push   $0x80107f04
80103b3a:	e8 41 c8 ff ff       	call   80100380 <panic>
80103b3f:	90                   	nop

80103b40 <cpuid>:
cpuid() {
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b46:	e8 95 ff ff ff       	call   80103ae0 <mycpu>
}
80103b4b:	c9                   	leave  
  return mycpu()-cpus;
80103b4c:	2d 00 28 11 80       	sub    $0x80112800,%eax
80103b51:	c1 f8 04             	sar    $0x4,%eax
80103b54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b5a:	c3                   	ret    
80103b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <myproc>:
myproc(void) {
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b67:	e8 64 0b 00 00       	call   801046d0 <pushcli>
  c = mycpu();
80103b6c:	e8 6f ff ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103b71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b77:	e8 a4 0b 00 00       	call   80104720 <popcli>
}
80103b7c:	89 d8                	mov    %ebx,%eax
80103b7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b81:	c9                   	leave  
80103b82:	c3                   	ret    
80103b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b90 <userinit>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	53                   	push   %ebx
80103b94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b97:	e8 04 fe ff ff       	call   801039a0 <allocproc>
80103b9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b9e:	a3 b4 4d 11 80       	mov    %eax,0x80114db4
  if((p->pgdir = setupkvm()) == 0)
80103ba3:	e8 c8 39 00 00       	call   80107570 <setupkvm>
80103ba8:	89 43 08             	mov    %eax,0x8(%ebx)
80103bab:	85 c0                	test   %eax,%eax
80103bad:	0f 84 bd 00 00 00    	je     80103c70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bb3:	83 ec 04             	sub    $0x4,%esp
80103bb6:	68 2c 00 00 00       	push   $0x2c
80103bbb:	68 70 b4 10 80       	push   $0x8010b470
80103bc0:	50                   	push   %eax
80103bc1:	e8 5a 34 00 00       	call   80107020 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bc6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bcf:	6a 4c                	push   $0x4c
80103bd1:	6a 00                	push   $0x0
80103bd3:	ff 73 1c             	push   0x1c(%ebx)
80103bd6:	e8 05 0d 00 00       	call   801048e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bdb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103be3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103be6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103beb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bef:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bf2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bf6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bf9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c01:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c0c:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c16:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c20:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c2a:	8d 43 70             	lea    0x70(%ebx),%eax
80103c2d:	6a 10                	push   $0x10
80103c2f:	68 50 7e 10 80       	push   $0x80107e50
80103c34:	50                   	push   %eax
80103c35:	e8 66 0e 00 00       	call   80104aa0 <safestrcpy>
  p->cwd = namei("/");
80103c3a:	c7 04 24 59 7e 10 80 	movl   $0x80107e59,(%esp)
80103c41:	e8 6a e4 ff ff       	call   801020b0 <namei>
80103c46:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c49:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103c50:	e8 cb 0b 00 00       	call   80104820 <acquire>
  p->state = RUNNABLE;
80103c55:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c5c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103c63:	e8 58 0b 00 00       	call   801047c0 <release>
}
80103c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c6b:	83 c4 10             	add    $0x10,%esp
80103c6e:	c9                   	leave  
80103c6f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c70:	83 ec 0c             	sub    $0xc,%esp
80103c73:	68 37 7e 10 80       	push   $0x80107e37
80103c78:	e8 03 c7 ff ff       	call   80100380 <panic>
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi

80103c80 <growproc>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	56                   	push   %esi
80103c84:	53                   	push   %ebx
80103c85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c88:	e8 43 0a 00 00       	call   801046d0 <pushcli>
  c = mycpu();
80103c8d:	e8 4e fe ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103c92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c98:	e8 83 0a 00 00       	call   80104720 <popcli>
  sz = curproc->sz;
80103c9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c9f:	85 f6                	test   %esi,%esi
80103ca1:	7f 1d                	jg     80103cc0 <growproc+0x40>
  } else if(n < 0){
80103ca3:	75 3b                	jne    80103ce0 <growproc+0x60>
  switchuvm(curproc);
80103ca5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ca8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103caa:	53                   	push   %ebx
80103cab:	e8 60 32 00 00       	call   80106f10 <switchuvm>
  return 0;
80103cb0:	83 c4 10             	add    $0x10,%esp
80103cb3:	31 c0                	xor    %eax,%eax
}
80103cb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cb8:	5b                   	pop    %ebx
80103cb9:	5e                   	pop    %esi
80103cba:	5d                   	pop    %ebp
80103cbb:	c3                   	ret    
80103cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc0:	83 ec 04             	sub    $0x4,%esp
80103cc3:	01 c6                	add    %eax,%esi
80103cc5:	56                   	push   %esi
80103cc6:	50                   	push   %eax
80103cc7:	ff 73 08             	push   0x8(%ebx)
80103cca:	e8 f1 34 00 00       	call   801071c0 <allocuvm>
80103ccf:	83 c4 10             	add    $0x10,%esp
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	75 cf                	jne    80103ca5 <growproc+0x25>
      return -1;
80103cd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cdb:	eb d8                	jmp    80103cb5 <growproc+0x35>
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce0:	83 ec 04             	sub    $0x4,%esp
80103ce3:	01 c6                	add    %eax,%esi
80103ce5:	56                   	push   %esi
80103ce6:	50                   	push   %eax
80103ce7:	ff 73 08             	push   0x8(%ebx)
80103cea:	e8 11 37 00 00       	call   80107400 <deallocuvm>
80103cef:	83 c4 10             	add    $0x10,%esp
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	75 af                	jne    80103ca5 <growproc+0x25>
80103cf6:	eb de                	jmp    80103cd6 <growproc+0x56>
80103cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop

80103d00 <growhugeproc>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d08:	e8 c3 09 00 00       	call   801046d0 <pushcli>
  c = mycpu();
80103d0d:	e8 ce fd ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103d12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d18:	e8 03 0a 00 00       	call   80104720 <popcli>
  sz = curproc->hugesz;
80103d1d:	8b 43 04             	mov    0x4(%ebx),%eax
  if(n > 0){
80103d20:	85 f6                	test   %esi,%esi
80103d22:	7f 24                	jg     80103d48 <growhugeproc+0x48>
  } else if(n < 0){
80103d24:	75 4a                	jne    80103d70 <growhugeproc+0x70>
  curproc->hugesz = sz - HUGE_VA_OFFSET;
80103d26:	2d 00 00 00 1e       	sub    $0x1e000000,%eax
  switchuvm(curproc);
80103d2b:	83 ec 0c             	sub    $0xc,%esp
  curproc->hugesz = sz - HUGE_VA_OFFSET;
80103d2e:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103d31:	53                   	push   %ebx
80103d32:	e8 d9 31 00 00       	call   80106f10 <switchuvm>
  return 0;
80103d37:	83 c4 10             	add    $0x10,%esp
80103d3a:	31 c0                	xor    %eax,%eax
}
80103d3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d3f:	5b                   	pop    %ebx
80103d40:	5e                   	pop    %esi
80103d41:	5d                   	pop    %ebp
80103d42:	c3                   	ret    
80103d43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d47:	90                   	nop
    if((sz = allochugeuvm(curproc->pgdir, sz + HUGE_VA_OFFSET, sz + n + HUGE_VA_OFFSET)) == 0)
80103d48:	83 ec 04             	sub    $0x4,%esp
80103d4b:	8d 94 30 00 00 00 1e 	lea    0x1e000000(%eax,%esi,1),%edx
80103d52:	05 00 00 00 1e       	add    $0x1e000000,%eax
80103d57:	52                   	push   %edx
80103d58:	50                   	push   %eax
80103d59:	ff 73 08             	push   0x8(%ebx)
80103d5c:	e8 8f 35 00 00       	call   801072f0 <allochugeuvm>
80103d61:	83 c4 10             	add    $0x10,%esp
80103d64:	85 c0                	test   %eax,%eax
80103d66:	75 be                	jne    80103d26 <growhugeproc+0x26>
      return -1;
80103d68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d6d:	eb cd                	jmp    80103d3c <growhugeproc+0x3c>
80103d6f:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d70:	83 ec 04             	sub    $0x4,%esp
80103d73:	01 c6                	add    %eax,%esi
80103d75:	56                   	push   %esi
80103d76:	50                   	push   %eax
80103d77:	ff 73 08             	push   0x8(%ebx)
80103d7a:	e8 81 36 00 00       	call   80107400 <deallocuvm>
80103d7f:	83 c4 10             	add    $0x10,%esp
80103d82:	85 c0                	test   %eax,%eax
80103d84:	75 a0                	jne    80103d26 <growhugeproc+0x26>
80103d86:	eb e0                	jmp    80103d68 <growhugeproc+0x68>
80103d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d8f:	90                   	nop

80103d90 <fork>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d99:	e8 32 09 00 00       	call   801046d0 <pushcli>
  c = mycpu();
80103d9e:	e8 3d fd ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103da3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da9:	e8 72 09 00 00       	call   80104720 <popcli>
  if((np = allocproc()) == 0){
80103dae:	e8 ed fb ff ff       	call   801039a0 <allocproc>
80103db3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103db6:	85 c0                	test   %eax,%eax
80103db8:	0f 84 b7 00 00 00    	je     80103e75 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dbe:	83 ec 08             	sub    $0x8,%esp
80103dc1:	ff 33                	push   (%ebx)
80103dc3:	89 c7                	mov    %eax,%edi
80103dc5:	ff 73 08             	push   0x8(%ebx)
80103dc8:	e8 93 38 00 00       	call   80107660 <copyuvm>
80103dcd:	83 c4 10             	add    $0x10,%esp
80103dd0:	89 47 08             	mov    %eax,0x8(%edi)
80103dd3:	85 c0                	test   %eax,%eax
80103dd5:	0f 84 a1 00 00 00    	je     80103e7c <fork+0xec>
  np->sz = curproc->sz;
80103ddb:	8b 03                	mov    (%ebx),%eax
80103ddd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103de0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103de2:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103de5:	89 c8                	mov    %ecx,%eax
80103de7:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103dea:	b9 13 00 00 00       	mov    $0x13,%ecx
80103def:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103df2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103df4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103df6:	8b 40 1c             	mov    0x1c(%eax),%eax
80103df9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e00:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103e04:	85 c0                	test   %eax,%eax
80103e06:	74 13                	je     80103e1b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e08:	83 ec 0c             	sub    $0xc,%esp
80103e0b:	50                   	push   %eax
80103e0c:	e8 9f d0 ff ff       	call   80100eb0 <filedup>
80103e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e14:	83 c4 10             	add    $0x10,%esp
80103e17:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e1b:	83 c6 01             	add    $0x1,%esi
80103e1e:	83 fe 10             	cmp    $0x10,%esi
80103e21:	75 dd                	jne    80103e00 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e23:	83 ec 0c             	sub    $0xc,%esp
80103e26:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e29:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103e2c:	e8 2f d9 ff ff       	call   80101760 <idup>
80103e31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e37:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e3a:	8d 47 70             	lea    0x70(%edi),%eax
80103e3d:	6a 10                	push   $0x10
80103e3f:	53                   	push   %ebx
80103e40:	50                   	push   %eax
80103e41:	e8 5a 0c 00 00       	call   80104aa0 <safestrcpy>
  pid = np->pid;
80103e46:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103e49:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e50:	e8 cb 09 00 00       	call   80104820 <acquire>
  np->state = RUNNABLE;
80103e55:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103e5c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e63:	e8 58 09 00 00       	call   801047c0 <release>
  return pid;
80103e68:	83 c4 10             	add    $0x10,%esp
}
80103e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e6e:	89 d8                	mov    %ebx,%eax
80103e70:	5b                   	pop    %ebx
80103e71:	5e                   	pop    %esi
80103e72:	5f                   	pop    %edi
80103e73:	5d                   	pop    %ebp
80103e74:	c3                   	ret    
    return -1;
80103e75:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e7a:	eb ef                	jmp    80103e6b <fork+0xdb>
    kfree(np->kstack);
80103e7c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e7f:	83 ec 0c             	sub    $0xc,%esp
80103e82:	ff 73 0c             	push   0xc(%ebx)
80103e85:	e8 46 e6 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103e8a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e91:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e94:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103e9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ea0:	eb c9                	jmp    80103e6b <fork+0xdb>
80103ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103eb0 <scheduler>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103eb9:	e8 22 fc ff ff       	call   80103ae0 <mycpu>
  c->proc = 0;
80103ebe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ec5:	00 00 00 
  struct cpu *c = mycpu();
80103ec8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103eca:	8d 78 04             	lea    0x4(%eax),%edi
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ed0:	fb                   	sti    
    acquire(&ptable.lock);
80103ed1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed4:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
    acquire(&ptable.lock);
80103ed9:	68 80 2d 11 80       	push   $0x80112d80
80103ede:	e8 3d 09 00 00       	call   80104820 <acquire>
80103ee3:	83 c4 10             	add    $0x10,%esp
80103ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eed:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ef0:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103ef4:	75 33                	jne    80103f29 <scheduler+0x79>
      switchuvm(p);
80103ef6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ef9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103eff:	53                   	push   %ebx
80103f00:	e8 0b 30 00 00       	call   80106f10 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f05:	58                   	pop    %eax
80103f06:	5a                   	pop    %edx
80103f07:	ff 73 20             	push   0x20(%ebx)
80103f0a:	57                   	push   %edi
      p->state = RUNNING;
80103f0b:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103f12:	e8 e4 0b 00 00       	call   80104afb <swtch>
      switchkvm();
80103f17:	e8 e4 2f 00 00       	call   80106f00 <switchkvm>
      c->proc = 0;
80103f1c:	83 c4 10             	add    $0x10,%esp
80103f1f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f26:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f29:	83 eb 80             	sub    $0xffffff80,%ebx
80103f2c:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80103f32:	75 bc                	jne    80103ef0 <scheduler+0x40>
    release(&ptable.lock);
80103f34:	83 ec 0c             	sub    $0xc,%esp
80103f37:	68 80 2d 11 80       	push   $0x80112d80
80103f3c:	e8 7f 08 00 00       	call   801047c0 <release>
    sti();
80103f41:	83 c4 10             	add    $0x10,%esp
80103f44:	eb 8a                	jmp    80103ed0 <scheduler+0x20>
80103f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi

80103f50 <sched>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
  pushcli();
80103f55:	e8 76 07 00 00       	call   801046d0 <pushcli>
  c = mycpu();
80103f5a:	e8 81 fb ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103f5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f65:	e8 b6 07 00 00       	call   80104720 <popcli>
  if(!holding(&ptable.lock))
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 80 2d 11 80       	push   $0x80112d80
80103f72:	e8 09 08 00 00       	call   80104780 <holding>
80103f77:	83 c4 10             	add    $0x10,%esp
80103f7a:	85 c0                	test   %eax,%eax
80103f7c:	74 4f                	je     80103fcd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f7e:	e8 5d fb ff ff       	call   80103ae0 <mycpu>
80103f83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f8a:	75 68                	jne    80103ff4 <sched+0xa4>
  if(p->state == RUNNING)
80103f8c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f90:	74 55                	je     80103fe7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f92:	9c                   	pushf  
80103f93:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f94:	f6 c4 02             	test   $0x2,%ah
80103f97:	75 41                	jne    80103fda <sched+0x8a>
  intena = mycpu()->intena;
80103f99:	e8 42 fb ff ff       	call   80103ae0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f9e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103fa1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fa7:	e8 34 fb ff ff       	call   80103ae0 <mycpu>
80103fac:	83 ec 08             	sub    $0x8,%esp
80103faf:	ff 70 04             	push   0x4(%eax)
80103fb2:	53                   	push   %ebx
80103fb3:	e8 43 0b 00 00       	call   80104afb <swtch>
  mycpu()->intena = intena;
80103fb8:	e8 23 fb ff ff       	call   80103ae0 <mycpu>
}
80103fbd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fc0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fc9:	5b                   	pop    %ebx
80103fca:	5e                   	pop    %esi
80103fcb:	5d                   	pop    %ebp
80103fcc:	c3                   	ret    
    panic("sched ptable.lock");
80103fcd:	83 ec 0c             	sub    $0xc,%esp
80103fd0:	68 5b 7e 10 80       	push   $0x80107e5b
80103fd5:	e8 a6 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 87 7e 10 80       	push   $0x80107e87
80103fe2:	e8 99 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	68 79 7e 10 80       	push   $0x80107e79
80103fef:	e8 8c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	68 6d 7e 10 80       	push   $0x80107e6d
80103ffc:	e8 7f c3 ff ff       	call   80100380 <panic>
80104001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop

80104010 <exit>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	57                   	push   %edi
80104014:	56                   	push   %esi
80104015:	53                   	push   %ebx
80104016:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104019:	e8 42 fb ff ff       	call   80103b60 <myproc>
  if(curproc == initproc)
8010401e:	39 05 b4 4d 11 80    	cmp    %eax,0x80114db4
80104024:	0f 84 fd 00 00 00    	je     80104127 <exit+0x117>
8010402a:	89 c3                	mov    %eax,%ebx
8010402c:	8d 70 2c             	lea    0x2c(%eax),%esi
8010402f:	8d 78 6c             	lea    0x6c(%eax),%edi
80104032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104038:	8b 06                	mov    (%esi),%eax
8010403a:	85 c0                	test   %eax,%eax
8010403c:	74 12                	je     80104050 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010403e:	83 ec 0c             	sub    $0xc,%esp
80104041:	50                   	push   %eax
80104042:	e8 b9 ce ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80104047:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010404d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104050:	83 c6 04             	add    $0x4,%esi
80104053:	39 f7                	cmp    %esi,%edi
80104055:	75 e1                	jne    80104038 <exit+0x28>
  begin_op();
80104057:	e8 e4 ee ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
8010405c:	83 ec 0c             	sub    $0xc,%esp
8010405f:	ff 73 6c             	push   0x6c(%ebx)
80104062:	e8 59 d8 ff ff       	call   801018c0 <iput>
  end_op();
80104067:	e8 44 ef ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
8010406c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104073:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010407a:	e8 a1 07 00 00       	call   80104820 <acquire>
  wakeup1(curproc->parent);
8010407f:	8b 53 18             	mov    0x18(%ebx),%edx
80104082:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104085:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010408a:	eb 0e                	jmp    8010409a <exit+0x8a>
8010408c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104090:	83 e8 80             	sub    $0xffffff80,%eax
80104093:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104098:	74 1c                	je     801040b6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010409a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010409e:	75 f0                	jne    80104090 <exit+0x80>
801040a0:	3b 50 24             	cmp    0x24(%eax),%edx
801040a3:	75 eb                	jne    80104090 <exit+0x80>
      p->state = RUNNABLE;
801040a5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ac:	83 e8 80             	sub    $0xffffff80,%eax
801040af:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801040b4:	75 e4                	jne    8010409a <exit+0x8a>
      p->parent = initproc;
801040b6:	8b 0d b4 4d 11 80    	mov    0x80114db4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bc:	ba b4 2d 11 80       	mov    $0x80112db4,%edx
801040c1:	eb 10                	jmp    801040d3 <exit+0xc3>
801040c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c7:	90                   	nop
801040c8:	83 ea 80             	sub    $0xffffff80,%edx
801040cb:	81 fa b4 4d 11 80    	cmp    $0x80114db4,%edx
801040d1:	74 3b                	je     8010410e <exit+0xfe>
    if(p->parent == curproc){
801040d3:	39 5a 18             	cmp    %ebx,0x18(%edx)
801040d6:	75 f0                	jne    801040c8 <exit+0xb8>
      if(p->state == ZOMBIE)
801040d8:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
801040dc:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
801040df:	75 e7                	jne    801040c8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e1:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801040e6:	eb 12                	jmp    801040fa <exit+0xea>
801040e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop
801040f0:	83 e8 80             	sub    $0xffffff80,%eax
801040f3:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801040f8:	74 ce                	je     801040c8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801040fa:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040fe:	75 f0                	jne    801040f0 <exit+0xe0>
80104100:	3b 48 24             	cmp    0x24(%eax),%ecx
80104103:	75 eb                	jne    801040f0 <exit+0xe0>
      p->state = RUNNABLE;
80104105:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010410c:	eb e2                	jmp    801040f0 <exit+0xe0>
  curproc->state = ZOMBIE;
8010410e:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80104115:	e8 36 fe ff ff       	call   80103f50 <sched>
  panic("zombie exit");
8010411a:	83 ec 0c             	sub    $0xc,%esp
8010411d:	68 a8 7e 10 80       	push   $0x80107ea8
80104122:	e8 59 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104127:	83 ec 0c             	sub    $0xc,%esp
8010412a:	68 9b 7e 10 80       	push   $0x80107e9b
8010412f:	e8 4c c2 ff ff       	call   80100380 <panic>
80104134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop

80104140 <wait>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	56                   	push   %esi
80104144:	53                   	push   %ebx
  pushcli();
80104145:	e8 86 05 00 00       	call   801046d0 <pushcli>
  c = mycpu();
8010414a:	e8 91 f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
8010414f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104155:	e8 c6 05 00 00       	call   80104720 <popcli>
  acquire(&ptable.lock);
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	68 80 2d 11 80       	push   $0x80112d80
80104162:	e8 b9 06 00 00       	call   80104820 <acquire>
80104167:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010416a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010416c:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
80104171:	eb 10                	jmp    80104183 <wait+0x43>
80104173:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104177:	90                   	nop
80104178:	83 eb 80             	sub    $0xffffff80,%ebx
8010417b:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80104181:	74 1b                	je     8010419e <wait+0x5e>
      if(p->parent != curproc)
80104183:	39 73 18             	cmp    %esi,0x18(%ebx)
80104186:	75 f0                	jne    80104178 <wait+0x38>
      if(p->state == ZOMBIE){
80104188:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010418c:	74 62                	je     801041f0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010418e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104191:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104196:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
8010419c:	75 e5                	jne    80104183 <wait+0x43>
    if(!havekids || curproc->killed){
8010419e:	85 c0                	test   %eax,%eax
801041a0:	0f 84 a0 00 00 00    	je     80104246 <wait+0x106>
801041a6:	8b 46 28             	mov    0x28(%esi),%eax
801041a9:	85 c0                	test   %eax,%eax
801041ab:	0f 85 95 00 00 00    	jne    80104246 <wait+0x106>
  pushcli();
801041b1:	e8 1a 05 00 00       	call   801046d0 <pushcli>
  c = mycpu();
801041b6:	e8 25 f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801041bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041c1:	e8 5a 05 00 00       	call   80104720 <popcli>
  if(p == 0)
801041c6:	85 db                	test   %ebx,%ebx
801041c8:	0f 84 8f 00 00 00    	je     8010425d <wait+0x11d>
  p->chan = chan;
801041ce:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
801041d1:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801041d8:	e8 73 fd ff ff       	call   80103f50 <sched>
  p->chan = 0;
801041dd:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801041e4:	eb 84                	jmp    8010416a <wait+0x2a>
801041e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ed:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801041f0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041f3:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801041f6:	ff 73 0c             	push   0xc(%ebx)
801041f9:	e8 d2 e2 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
801041fe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80104205:	5a                   	pop    %edx
80104206:	ff 73 08             	push   0x8(%ebx)
80104209:	e8 e2 32 00 00       	call   801074f0 <freevm>
        p->pid = 0;
8010420e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104215:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010421c:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104220:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104227:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010422e:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80104235:	e8 86 05 00 00       	call   801047c0 <release>
        return pid;
8010423a:	83 c4 10             	add    $0x10,%esp
}
8010423d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104240:	89 f0                	mov    %esi,%eax
80104242:	5b                   	pop    %ebx
80104243:	5e                   	pop    %esi
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret    
      release(&ptable.lock);
80104246:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104249:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010424e:	68 80 2d 11 80       	push   $0x80112d80
80104253:	e8 68 05 00 00       	call   801047c0 <release>
      return -1;
80104258:	83 c4 10             	add    $0x10,%esp
8010425b:	eb e0                	jmp    8010423d <wait+0xfd>
    panic("sleep");
8010425d:	83 ec 0c             	sub    $0xc,%esp
80104260:	68 b4 7e 10 80       	push   $0x80107eb4
80104265:	e8 16 c1 ff ff       	call   80100380 <panic>
8010426a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104270 <yield>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	53                   	push   %ebx
80104274:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104277:	68 80 2d 11 80       	push   $0x80112d80
8010427c:	e8 9f 05 00 00       	call   80104820 <acquire>
  pushcli();
80104281:	e8 4a 04 00 00       	call   801046d0 <pushcli>
  c = mycpu();
80104286:	e8 55 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
8010428b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104291:	e8 8a 04 00 00       	call   80104720 <popcli>
  myproc()->state = RUNNABLE;
80104296:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010429d:	e8 ae fc ff ff       	call   80103f50 <sched>
  release(&ptable.lock);
801042a2:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801042a9:	e8 12 05 00 00       	call   801047c0 <release>
}
801042ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b1:	83 c4 10             	add    $0x10,%esp
801042b4:	c9                   	leave  
801042b5:	c3                   	ret    
801042b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bd:	8d 76 00             	lea    0x0(%esi),%esi

801042c0 <sleep>:
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	57                   	push   %edi
801042c4:	56                   	push   %esi
801042c5:	53                   	push   %ebx
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042cf:	e8 fc 03 00 00       	call   801046d0 <pushcli>
  c = mycpu();
801042d4:	e8 07 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801042d9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042df:	e8 3c 04 00 00       	call   80104720 <popcli>
  if(p == 0)
801042e4:	85 db                	test   %ebx,%ebx
801042e6:	0f 84 87 00 00 00    	je     80104373 <sleep+0xb3>
  if(lk == 0)
801042ec:	85 f6                	test   %esi,%esi
801042ee:	74 76                	je     80104366 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042f0:	81 fe 80 2d 11 80    	cmp    $0x80112d80,%esi
801042f6:	74 50                	je     80104348 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	68 80 2d 11 80       	push   $0x80112d80
80104300:	e8 1b 05 00 00       	call   80104820 <acquire>
    release(lk);
80104305:	89 34 24             	mov    %esi,(%esp)
80104308:	e8 b3 04 00 00       	call   801047c0 <release>
  p->chan = chan;
8010430d:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80104310:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104317:	e8 34 fc ff ff       	call   80103f50 <sched>
  p->chan = 0;
8010431c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104323:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010432a:	e8 91 04 00 00       	call   801047c0 <release>
    acquire(lk);
8010432f:	89 75 08             	mov    %esi,0x8(%ebp)
80104332:	83 c4 10             	add    $0x10,%esp
}
80104335:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104338:	5b                   	pop    %ebx
80104339:	5e                   	pop    %esi
8010433a:	5f                   	pop    %edi
8010433b:	5d                   	pop    %ebp
    acquire(lk);
8010433c:	e9 df 04 00 00       	jmp    80104820 <acquire>
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104348:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010434b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104352:	e8 f9 fb ff ff       	call   80103f50 <sched>
  p->chan = 0;
80104357:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010435e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104361:	5b                   	pop    %ebx
80104362:	5e                   	pop    %esi
80104363:	5f                   	pop    %edi
80104364:	5d                   	pop    %ebp
80104365:	c3                   	ret    
    panic("sleep without lk");
80104366:	83 ec 0c             	sub    $0xc,%esp
80104369:	68 ba 7e 10 80       	push   $0x80107eba
8010436e:	e8 0d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104373:	83 ec 0c             	sub    $0xc,%esp
80104376:	68 b4 7e 10 80       	push   $0x80107eb4
8010437b:	e8 00 c0 ff ff       	call   80100380 <panic>

80104380 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
80104387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010438a:	68 80 2d 11 80       	push   $0x80112d80
8010438f:	e8 8c 04 00 00       	call   80104820 <acquire>
80104394:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104397:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010439c:	eb 0c                	jmp    801043aa <wakeup+0x2a>
8010439e:	66 90                	xchg   %ax,%ax
801043a0:	83 e8 80             	sub    $0xffffff80,%eax
801043a3:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801043a8:	74 1c                	je     801043c6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801043aa:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801043ae:	75 f0                	jne    801043a0 <wakeup+0x20>
801043b0:	3b 58 24             	cmp    0x24(%eax),%ebx
801043b3:	75 eb                	jne    801043a0 <wakeup+0x20>
      p->state = RUNNABLE;
801043b5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043bc:	83 e8 80             	sub    $0xffffff80,%eax
801043bf:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801043c4:	75 e4                	jne    801043aa <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801043c6:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
801043cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d0:	c9                   	leave  
  release(&ptable.lock);
801043d1:	e9 ea 03 00 00       	jmp    801047c0 <release>
801043d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043dd:	8d 76 00             	lea    0x0(%esi),%esi

801043e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 10             	sub    $0x10,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ea:	68 80 2d 11 80       	push   $0x80112d80
801043ef:	e8 2c 04 00 00       	call   80104820 <acquire>
801043f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043f7:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801043fc:	eb 0c                	jmp    8010440a <kill+0x2a>
801043fe:	66 90                	xchg   %ax,%ax
80104400:	83 e8 80             	sub    $0xffffff80,%eax
80104403:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104408:	74 36                	je     80104440 <kill+0x60>
    if(p->pid == pid){
8010440a:	39 58 14             	cmp    %ebx,0x14(%eax)
8010440d:	75 f1                	jne    80104400 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010440f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
80104413:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
8010441a:	75 07                	jne    80104423 <kill+0x43>
        p->state = RUNNABLE;
8010441c:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104423:	83 ec 0c             	sub    $0xc,%esp
80104426:	68 80 2d 11 80       	push   $0x80112d80
8010442b:	e8 90 03 00 00       	call   801047c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104433:	83 c4 10             	add    $0x10,%esp
80104436:	31 c0                	xor    %eax,%eax
}
80104438:	c9                   	leave  
80104439:	c3                   	ret    
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	68 80 2d 11 80       	push   $0x80112d80
80104448:	e8 73 03 00 00       	call   801047c0 <release>
}
8010444d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104450:	83 c4 10             	add    $0x10,%esp
80104453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104458:	c9                   	leave  
80104459:	c3                   	ret    
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104460 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104468:	53                   	push   %ebx
80104469:	bb 24 2e 11 80       	mov    $0x80112e24,%ebx
8010446e:	83 ec 3c             	sub    $0x3c,%esp
80104471:	eb 24                	jmp    80104497 <procdump+0x37>
80104473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104477:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	68 5b 82 10 80       	push   $0x8010825b
80104480:	e8 1b c2 ff ff       	call   801006a0 <cprintf>
80104485:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104488:	83 eb 80             	sub    $0xffffff80,%ebx
8010448b:	81 fb 24 4e 11 80    	cmp    $0x80114e24,%ebx
80104491:	0f 84 81 00 00 00    	je     80104518 <procdump+0xb8>
    if(p->state == UNUSED)
80104497:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010449a:	85 c0                	test   %eax,%eax
8010449c:	74 ea                	je     80104488 <procdump+0x28>
      state = "???";
8010449e:	ba cb 7e 10 80       	mov    $0x80107ecb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044a3:	83 f8 05             	cmp    $0x5,%eax
801044a6:	77 11                	ja     801044b9 <procdump+0x59>
801044a8:	8b 14 85 2c 7f 10 80 	mov    -0x7fef80d4(,%eax,4),%edx
      state = "???";
801044af:	b8 cb 7e 10 80       	mov    $0x80107ecb,%eax
801044b4:	85 d2                	test   %edx,%edx
801044b6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044b9:	53                   	push   %ebx
801044ba:	52                   	push   %edx
801044bb:	ff 73 a4             	push   -0x5c(%ebx)
801044be:	68 cf 7e 10 80       	push   $0x80107ecf
801044c3:	e8 d8 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801044c8:	83 c4 10             	add    $0x10,%esp
801044cb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044cf:	75 a7                	jne    80104478 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044d1:	83 ec 08             	sub    $0x8,%esp
801044d4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044d7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044da:	50                   	push   %eax
801044db:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044de:	8b 40 0c             	mov    0xc(%eax),%eax
801044e1:	83 c0 08             	add    $0x8,%eax
801044e4:	50                   	push   %eax
801044e5:	e8 86 01 00 00       	call   80104670 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044ea:	83 c4 10             	add    $0x10,%esp
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
801044f0:	8b 17                	mov    (%edi),%edx
801044f2:	85 d2                	test   %edx,%edx
801044f4:	74 82                	je     80104478 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044f6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044f9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044fc:	52                   	push   %edx
801044fd:	68 01 79 10 80       	push   $0x80107901
80104502:	e8 99 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104507:	83 c4 10             	add    $0x10,%esp
8010450a:	39 fe                	cmp    %edi,%esi
8010450c:	75 e2                	jne    801044f0 <procdump+0x90>
8010450e:	e9 65 ff ff ff       	jmp    80104478 <procdump+0x18>
80104513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104517:	90                   	nop
  }
}
80104518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010451b:	5b                   	pop    %ebx
8010451c:	5e                   	pop    %esi
8010451d:	5f                   	pop    %edi
8010451e:	5d                   	pop    %ebp
8010451f:	c3                   	ret    

80104520 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 0c             	sub    $0xc,%esp
80104527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010452a:	68 44 7f 10 80       	push   $0x80107f44
8010452f:	8d 43 04             	lea    0x4(%ebx),%eax
80104532:	50                   	push   %eax
80104533:	e8 18 01 00 00       	call   80104650 <initlock>
  lk->name = name;
80104538:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010453b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104541:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104544:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010454b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010454e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104551:	c9                   	leave  
80104552:	c3                   	ret    
80104553:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104560 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104568:	8d 73 04             	lea    0x4(%ebx),%esi
8010456b:	83 ec 0c             	sub    $0xc,%esp
8010456e:	56                   	push   %esi
8010456f:	e8 ac 02 00 00       	call   80104820 <acquire>
  while (lk->locked) {
80104574:	8b 13                	mov    (%ebx),%edx
80104576:	83 c4 10             	add    $0x10,%esp
80104579:	85 d2                	test   %edx,%edx
8010457b:	74 16                	je     80104593 <acquiresleep+0x33>
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104580:	83 ec 08             	sub    $0x8,%esp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	e8 36 fd ff ff       	call   801042c0 <sleep>
  while (lk->locked) {
8010458a:	8b 03                	mov    (%ebx),%eax
8010458c:	83 c4 10             	add    $0x10,%esp
8010458f:	85 c0                	test   %eax,%eax
80104591:	75 ed                	jne    80104580 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104593:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104599:	e8 c2 f5 ff ff       	call   80103b60 <myproc>
8010459e:	8b 40 14             	mov    0x14(%eax),%eax
801045a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045aa:	5b                   	pop    %ebx
801045ab:	5e                   	pop    %esi
801045ac:	5d                   	pop    %ebp
  release(&lk->lk);
801045ad:	e9 0e 02 00 00       	jmp    801047c0 <release>
801045b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045c8:	8d 73 04             	lea    0x4(%ebx),%esi
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	56                   	push   %esi
801045cf:	e8 4c 02 00 00       	call   80104820 <acquire>
  lk->locked = 0;
801045d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045e1:	89 1c 24             	mov    %ebx,(%esp)
801045e4:	e8 97 fd ff ff       	call   80104380 <wakeup>
  release(&lk->lk);
801045e9:	89 75 08             	mov    %esi,0x8(%ebp)
801045ec:	83 c4 10             	add    $0x10,%esp
}
801045ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f2:	5b                   	pop    %ebx
801045f3:	5e                   	pop    %esi
801045f4:	5d                   	pop    %ebp
  release(&lk->lk);
801045f5:	e9 c6 01 00 00       	jmp    801047c0 <release>
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	31 ff                	xor    %edi,%edi
80104606:	56                   	push   %esi
80104607:	53                   	push   %ebx
80104608:	83 ec 18             	sub    $0x18,%esp
8010460b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010460e:	8d 73 04             	lea    0x4(%ebx),%esi
80104611:	56                   	push   %esi
80104612:	e8 09 02 00 00       	call   80104820 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104617:	8b 03                	mov    (%ebx),%eax
80104619:	83 c4 10             	add    $0x10,%esp
8010461c:	85 c0                	test   %eax,%eax
8010461e:	75 18                	jne    80104638 <holdingsleep+0x38>
  release(&lk->lk);
80104620:	83 ec 0c             	sub    $0xc,%esp
80104623:	56                   	push   %esi
80104624:	e8 97 01 00 00       	call   801047c0 <release>
  return r;
}
80104629:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010462c:	89 f8                	mov    %edi,%eax
8010462e:	5b                   	pop    %ebx
8010462f:	5e                   	pop    %esi
80104630:	5f                   	pop    %edi
80104631:	5d                   	pop    %ebp
80104632:	c3                   	ret    
80104633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104637:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104638:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010463b:	e8 20 f5 ff ff       	call   80103b60 <myproc>
80104640:	39 58 14             	cmp    %ebx,0x14(%eax)
80104643:	0f 94 c0             	sete   %al
80104646:	0f b6 c0             	movzbl %al,%eax
80104649:	89 c7                	mov    %eax,%edi
8010464b:	eb d3                	jmp    80104620 <holdingsleep+0x20>
8010464d:	66 90                	xchg   %ax,%ax
8010464f:	90                   	nop

80104650 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104656:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104659:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010465f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104662:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104669:	5d                   	pop    %ebp
8010466a:	c3                   	ret    
8010466b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010466f:	90                   	nop

80104670 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104670:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104671:	31 d2                	xor    %edx,%edx
{
80104673:	89 e5                	mov    %esp,%ebp
80104675:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104676:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104679:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010467c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010467f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104680:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104686:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010468c:	77 1a                	ja     801046a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010468e:	8b 58 04             	mov    0x4(%eax),%ebx
80104691:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104694:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104697:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104699:	83 fa 0a             	cmp    $0xa,%edx
8010469c:	75 e2                	jne    80104680 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010469e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a1:	c9                   	leave  
801046a2:	c3                   	ret    
801046a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a7:	90                   	nop
  for(; i < 10; i++)
801046a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046ab:	8d 51 28             	lea    0x28(%ecx),%edx
801046ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046b6:	83 c0 04             	add    $0x4,%eax
801046b9:	39 d0                	cmp    %edx,%eax
801046bb:	75 f3                	jne    801046b0 <getcallerpcs+0x40>
}
801046bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c0:	c9                   	leave  
801046c1:	c3                   	ret    
801046c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 04             	sub    $0x4,%esp
801046d7:	9c                   	pushf  
801046d8:	5b                   	pop    %ebx
  asm volatile("cli");
801046d9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801046da:	e8 01 f4 ff ff       	call   80103ae0 <mycpu>
801046df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046e5:	85 c0                	test   %eax,%eax
801046e7:	74 17                	je     80104700 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046e9:	e8 f2 f3 ff ff       	call   80103ae0 <mycpu>
801046ee:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f8:	c9                   	leave  
801046f9:	c3                   	ret    
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104700:	e8 db f3 ff ff       	call   80103ae0 <mycpu>
80104705:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010470b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104711:	eb d6                	jmp    801046e9 <pushcli+0x19>
80104713:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104720 <popcli>:

void
popcli(void)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104726:	9c                   	pushf  
80104727:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104728:	f6 c4 02             	test   $0x2,%ah
8010472b:	75 35                	jne    80104762 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010472d:	e8 ae f3 ff ff       	call   80103ae0 <mycpu>
80104732:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104739:	78 34                	js     8010476f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010473b:	e8 a0 f3 ff ff       	call   80103ae0 <mycpu>
80104740:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104746:	85 d2                	test   %edx,%edx
80104748:	74 06                	je     80104750 <popcli+0x30>
    sti();
}
8010474a:	c9                   	leave  
8010474b:	c3                   	ret    
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104750:	e8 8b f3 ff ff       	call   80103ae0 <mycpu>
80104755:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010475b:	85 c0                	test   %eax,%eax
8010475d:	74 eb                	je     8010474a <popcli+0x2a>
  asm volatile("sti");
8010475f:	fb                   	sti    
}
80104760:	c9                   	leave  
80104761:	c3                   	ret    
    panic("popcli - interruptible");
80104762:	83 ec 0c             	sub    $0xc,%esp
80104765:	68 4f 7f 10 80       	push   $0x80107f4f
8010476a:	e8 11 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010476f:	83 ec 0c             	sub    $0xc,%esp
80104772:	68 66 7f 10 80       	push   $0x80107f66
80104777:	e8 04 bc ff ff       	call   80100380 <panic>
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104780 <holding>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 75 08             	mov    0x8(%ebp),%esi
80104788:	31 db                	xor    %ebx,%ebx
  pushcli();
8010478a:	e8 41 ff ff ff       	call   801046d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010478f:	8b 06                	mov    (%esi),%eax
80104791:	85 c0                	test   %eax,%eax
80104793:	75 0b                	jne    801047a0 <holding+0x20>
  popcli();
80104795:	e8 86 ff ff ff       	call   80104720 <popcli>
}
8010479a:	89 d8                	mov    %ebx,%eax
8010479c:	5b                   	pop    %ebx
8010479d:	5e                   	pop    %esi
8010479e:	5d                   	pop    %ebp
8010479f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801047a0:	8b 5e 08             	mov    0x8(%esi),%ebx
801047a3:	e8 38 f3 ff ff       	call   80103ae0 <mycpu>
801047a8:	39 c3                	cmp    %eax,%ebx
801047aa:	0f 94 c3             	sete   %bl
  popcli();
801047ad:	e8 6e ff ff ff       	call   80104720 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801047b2:	0f b6 db             	movzbl %bl,%ebx
}
801047b5:	89 d8                	mov    %ebx,%eax
801047b7:	5b                   	pop    %ebx
801047b8:	5e                   	pop    %esi
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
801047bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop

801047c0 <release>:
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
801047c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047c8:	e8 03 ff ff ff       	call   801046d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047cd:	8b 03                	mov    (%ebx),%eax
801047cf:	85 c0                	test   %eax,%eax
801047d1:	75 15                	jne    801047e8 <release+0x28>
  popcli();
801047d3:	e8 48 ff ff ff       	call   80104720 <popcli>
    panic("release");
801047d8:	83 ec 0c             	sub    $0xc,%esp
801047db:	68 6d 7f 10 80       	push   $0x80107f6d
801047e0:	e8 9b bb ff ff       	call   80100380 <panic>
801047e5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047e8:	8b 73 08             	mov    0x8(%ebx),%esi
801047eb:	e8 f0 f2 ff ff       	call   80103ae0 <mycpu>
801047f0:	39 c6                	cmp    %eax,%esi
801047f2:	75 df                	jne    801047d3 <release+0x13>
  popcli();
801047f4:	e8 27 ff ff ff       	call   80104720 <popcli>
  lk->pcs[0] = 0;
801047f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104800:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104807:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010480c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104812:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104815:	5b                   	pop    %ebx
80104816:	5e                   	pop    %esi
80104817:	5d                   	pop    %ebp
  popcli();
80104818:	e9 03 ff ff ff       	jmp    80104720 <popcli>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi

80104820 <acquire>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104827:	e8 a4 fe ff ff       	call   801046d0 <pushcli>
  if(holding(lk))
8010482c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010482f:	e8 9c fe ff ff       	call   801046d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104834:	8b 03                	mov    (%ebx),%eax
80104836:	85 c0                	test   %eax,%eax
80104838:	75 7e                	jne    801048b8 <acquire+0x98>
  popcli();
8010483a:	e8 e1 fe ff ff       	call   80104720 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010483f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104848:	8b 55 08             	mov    0x8(%ebp),%edx
8010484b:	89 c8                	mov    %ecx,%eax
8010484d:	f0 87 02             	lock xchg %eax,(%edx)
80104850:	85 c0                	test   %eax,%eax
80104852:	75 f4                	jne    80104848 <acquire+0x28>
  __sync_synchronize();
80104854:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104859:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010485c:	e8 7f f2 ff ff       	call   80103ae0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104861:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104864:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104866:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104869:	31 c0                	xor    %eax,%eax
8010486b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010486f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104870:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104876:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010487c:	77 1a                	ja     80104898 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010487e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104881:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104885:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104888:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010488a:	83 f8 0a             	cmp    $0xa,%eax
8010488d:	75 e1                	jne    80104870 <acquire+0x50>
}
8010488f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104892:	c9                   	leave  
80104893:	c3                   	ret    
80104894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104898:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010489c:	8d 51 34             	lea    0x34(%ecx),%edx
8010489f:	90                   	nop
    pcs[i] = 0;
801048a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048a6:	83 c0 04             	add    $0x4,%eax
801048a9:	39 c2                	cmp    %eax,%edx
801048ab:	75 f3                	jne    801048a0 <acquire+0x80>
}
801048ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048b0:	c9                   	leave  
801048b1:	c3                   	ret    
801048b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048b8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801048bb:	e8 20 f2 ff ff       	call   80103ae0 <mycpu>
801048c0:	39 c3                	cmp    %eax,%ebx
801048c2:	0f 85 72 ff ff ff    	jne    8010483a <acquire+0x1a>
  popcli();
801048c8:	e8 53 fe ff ff       	call   80104720 <popcli>
    panic("acquire");
801048cd:	83 ec 0c             	sub    $0xc,%esp
801048d0:	68 75 7f 10 80       	push   $0x80107f75
801048d5:	e8 a6 ba ff ff       	call   80100380 <panic>
801048da:	66 90                	xchg   %ax,%ax
801048dc:	66 90                	xchg   %ax,%ax
801048de:	66 90                	xchg   %ax,%ax

801048e0 <memset>:
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	8b 55 08             	mov    0x8(%ebp),%edx
801048e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ea:	53                   	push   %ebx
801048eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ee:	89 d7                	mov    %edx,%edi
801048f0:	09 cf                	or     %ecx,%edi
801048f2:	83 e7 03             	and    $0x3,%edi
801048f5:	75 29                	jne    80104920 <memset+0x40>
801048f7:	0f b6 f8             	movzbl %al,%edi
801048fa:	c1 e0 18             	shl    $0x18,%eax
801048fd:	89 fb                	mov    %edi,%ebx
801048ff:	c1 e9 02             	shr    $0x2,%ecx
80104902:	c1 e3 10             	shl    $0x10,%ebx
80104905:	09 d8                	or     %ebx,%eax
80104907:	09 f8                	or     %edi,%eax
80104909:	c1 e7 08             	shl    $0x8,%edi
8010490c:	09 f8                	or     %edi,%eax
8010490e:	89 d7                	mov    %edx,%edi
80104910:	fc                   	cld    
80104911:	f3 ab                	rep stos %eax,%es:(%edi)
80104913:	5b                   	pop    %ebx
80104914:	89 d0                	mov    %edx,%eax
80104916:	5f                   	pop    %edi
80104917:	5d                   	pop    %ebp
80104918:	c3                   	ret    
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104920:	89 d7                	mov    %edx,%edi
80104922:	fc                   	cld    
80104923:	f3 aa                	rep stos %al,%es:(%edi)
80104925:	5b                   	pop    %ebx
80104926:	89 d0                	mov    %edx,%eax
80104928:	5f                   	pop    %edi
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010492f:	90                   	nop

80104930 <memcmp>:
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	8b 75 10             	mov    0x10(%ebp),%esi
80104937:	8b 55 08             	mov    0x8(%ebp),%edx
8010493a:	53                   	push   %ebx
8010493b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010493e:	85 f6                	test   %esi,%esi
80104940:	74 2e                	je     80104970 <memcmp+0x40>
80104942:	01 c6                	add    %eax,%esi
80104944:	eb 14                	jmp    8010495a <memcmp+0x2a>
80104946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
80104950:	83 c0 01             	add    $0x1,%eax
80104953:	83 c2 01             	add    $0x1,%edx
80104956:	39 f0                	cmp    %esi,%eax
80104958:	74 16                	je     80104970 <memcmp+0x40>
8010495a:	0f b6 0a             	movzbl (%edx),%ecx
8010495d:	0f b6 18             	movzbl (%eax),%ebx
80104960:	38 d9                	cmp    %bl,%cl
80104962:	74 ec                	je     80104950 <memcmp+0x20>
80104964:	0f b6 c1             	movzbl %cl,%eax
80104967:	29 d8                	sub    %ebx,%eax
80104969:	5b                   	pop    %ebx
8010496a:	5e                   	pop    %esi
8010496b:	5d                   	pop    %ebp
8010496c:	c3                   	ret    
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
80104970:	5b                   	pop    %ebx
80104971:	31 c0                	xor    %eax,%eax
80104973:	5e                   	pop    %esi
80104974:	5d                   	pop    %ebp
80104975:	c3                   	ret    
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi

80104980 <memmove>:
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	8b 55 08             	mov    0x8(%ebp),%edx
80104987:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010498a:	56                   	push   %esi
8010498b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010498e:	39 d6                	cmp    %edx,%esi
80104990:	73 26                	jae    801049b8 <memmove+0x38>
80104992:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104995:	39 fa                	cmp    %edi,%edx
80104997:	73 1f                	jae    801049b8 <memmove+0x38>
80104999:	8d 41 ff             	lea    -0x1(%ecx),%eax
8010499c:	85 c9                	test   %ecx,%ecx
8010499e:	74 0c                	je     801049ac <memmove+0x2c>
801049a0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049a4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
801049a7:	83 e8 01             	sub    $0x1,%eax
801049aa:	73 f4                	jae    801049a0 <memmove+0x20>
801049ac:	5e                   	pop    %esi
801049ad:	89 d0                	mov    %edx,%eax
801049af:	5f                   	pop    %edi
801049b0:	5d                   	pop    %ebp
801049b1:	c3                   	ret    
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049b8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801049bb:	89 d7                	mov    %edx,%edi
801049bd:	85 c9                	test   %ecx,%ecx
801049bf:	74 eb                	je     801049ac <memmove+0x2c>
801049c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
801049c9:	39 c6                	cmp    %eax,%esi
801049cb:	75 fb                	jne    801049c8 <memmove+0x48>
801049cd:	5e                   	pop    %esi
801049ce:	89 d0                	mov    %edx,%eax
801049d0:	5f                   	pop    %edi
801049d1:	5d                   	pop    %ebp
801049d2:	c3                   	ret    
801049d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049e0 <memcpy>:
801049e0:	eb 9e                	jmp    80104980 <memmove>
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049f0 <strncmp>:
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	8b 75 10             	mov    0x10(%ebp),%esi
801049f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049fa:	53                   	push   %ebx
801049fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801049fe:	85 f6                	test   %esi,%esi
80104a00:	74 2e                	je     80104a30 <strncmp+0x40>
80104a02:	01 d6                	add    %edx,%esi
80104a04:	eb 18                	jmp    80104a1e <strncmp+0x2e>
80104a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi
80104a10:	38 d8                	cmp    %bl,%al
80104a12:	75 14                	jne    80104a28 <strncmp+0x38>
80104a14:	83 c2 01             	add    $0x1,%edx
80104a17:	83 c1 01             	add    $0x1,%ecx
80104a1a:	39 f2                	cmp    %esi,%edx
80104a1c:	74 12                	je     80104a30 <strncmp+0x40>
80104a1e:	0f b6 01             	movzbl (%ecx),%eax
80104a21:	0f b6 1a             	movzbl (%edx),%ebx
80104a24:	84 c0                	test   %al,%al
80104a26:	75 e8                	jne    80104a10 <strncmp+0x20>
80104a28:	29 d8                	sub    %ebx,%eax
80104a2a:	5b                   	pop    %ebx
80104a2b:	5e                   	pop    %esi
80104a2c:	5d                   	pop    %ebp
80104a2d:	c3                   	ret    
80104a2e:	66 90                	xchg   %ax,%ax
80104a30:	5b                   	pop    %ebx
80104a31:	31 c0                	xor    %eax,%eax
80104a33:	5e                   	pop    %esi
80104a34:	5d                   	pop    %ebp
80104a35:	c3                   	ret    
80104a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi

80104a40 <strncpy>:
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	8b 75 08             	mov    0x8(%ebp),%esi
80104a48:	53                   	push   %ebx
80104a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a4c:	89 f0                	mov    %esi,%eax
80104a4e:	eb 15                	jmp    80104a65 <strncpy+0x25>
80104a50:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a54:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a57:	83 c0 01             	add    $0x1,%eax
80104a5a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a5e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a61:	84 d2                	test   %dl,%dl
80104a63:	74 09                	je     80104a6e <strncpy+0x2e>
80104a65:	89 cb                	mov    %ecx,%ebx
80104a67:	83 e9 01             	sub    $0x1,%ecx
80104a6a:	85 db                	test   %ebx,%ebx
80104a6c:	7f e2                	jg     80104a50 <strncpy+0x10>
80104a6e:	89 c2                	mov    %eax,%edx
80104a70:	85 c9                	test   %ecx,%ecx
80104a72:	7e 17                	jle    80104a8b <strncpy+0x4b>
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a78:	83 c2 01             	add    $0x1,%edx
80104a7b:	89 c1                	mov    %eax,%ecx
80104a7d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80104a81:	29 d1                	sub    %edx,%ecx
80104a83:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a87:	85 c9                	test   %ecx,%ecx
80104a89:	7f ed                	jg     80104a78 <strncpy+0x38>
80104a8b:	5b                   	pop    %ebx
80104a8c:	89 f0                	mov    %esi,%eax
80104a8e:	5e                   	pop    %esi
80104a8f:	5f                   	pop    %edi
80104a90:	5d                   	pop    %ebp
80104a91:	c3                   	ret    
80104a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104aa0 <safestrcpy>:
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	8b 55 10             	mov    0x10(%ebp),%edx
80104aa7:	8b 75 08             	mov    0x8(%ebp),%esi
80104aaa:	53                   	push   %ebx
80104aab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aae:	85 d2                	test   %edx,%edx
80104ab0:	7e 25                	jle    80104ad7 <safestrcpy+0x37>
80104ab2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ab6:	89 f2                	mov    %esi,%edx
80104ab8:	eb 16                	jmp    80104ad0 <safestrcpy+0x30>
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac0:	0f b6 08             	movzbl (%eax),%ecx
80104ac3:	83 c0 01             	add    $0x1,%eax
80104ac6:	83 c2 01             	add    $0x1,%edx
80104ac9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104acc:	84 c9                	test   %cl,%cl
80104ace:	74 04                	je     80104ad4 <safestrcpy+0x34>
80104ad0:	39 d8                	cmp    %ebx,%eax
80104ad2:	75 ec                	jne    80104ac0 <safestrcpy+0x20>
80104ad4:	c6 02 00             	movb   $0x0,(%edx)
80104ad7:	89 f0                	mov    %esi,%eax
80104ad9:	5b                   	pop    %ebx
80104ada:	5e                   	pop    %esi
80104adb:	5d                   	pop    %ebp
80104adc:	c3                   	ret    
80104add:	8d 76 00             	lea    0x0(%esi),%esi

80104ae0 <strlen>:
80104ae0:	55                   	push   %ebp
80104ae1:	31 c0                	xor    %eax,%eax
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ae8:	80 3a 00             	cmpb   $0x0,(%edx)
80104aeb:	74 0c                	je     80104af9 <strlen+0x19>
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
80104af0:	83 c0 01             	add    $0x1,%eax
80104af3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104af7:	75 f7                	jne    80104af0 <strlen+0x10>
80104af9:	5d                   	pop    %ebp
80104afa:	c3                   	ret    

80104afb <swtch>:
80104afb:	8b 44 24 04          	mov    0x4(%esp),%eax
80104aff:	8b 54 24 08          	mov    0x8(%esp),%edx
80104b03:	55                   	push   %ebp
80104b04:	53                   	push   %ebx
80104b05:	56                   	push   %esi
80104b06:	57                   	push   %edi
80104b07:	89 20                	mov    %esp,(%eax)
80104b09:	89 d4                	mov    %edx,%esp
80104b0b:	5f                   	pop    %edi
80104b0c:	5e                   	pop    %esi
80104b0d:	5b                   	pop    %ebx
80104b0e:	5d                   	pop    %ebp
80104b0f:	c3                   	ret    

80104b10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
80104b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b1a:	e8 41 f0 ff ff       	call   80103b60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b1f:	8b 00                	mov    (%eax),%eax
80104b21:	39 d8                	cmp    %ebx,%eax
80104b23:	76 1b                	jbe    80104b40 <fetchint+0x30>
80104b25:	8d 53 04             	lea    0x4(%ebx),%edx
80104b28:	39 d0                	cmp    %edx,%eax
80104b2a:	72 14                	jb     80104b40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b2f:	8b 13                	mov    (%ebx),%edx
80104b31:	89 10                	mov    %edx,(%eax)
  return 0;
80104b33:	31 c0                	xor    %eax,%eax
}
80104b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b38:	c9                   	leave  
80104b39:	c3                   	ret    
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b45:	eb ee                	jmp    80104b35 <fetchint+0x25>
80104b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	83 ec 04             	sub    $0x4,%esp
80104b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b5a:	e8 01 f0 ff ff       	call   80103b60 <myproc>

  if(addr >= curproc->sz)
80104b5f:	39 18                	cmp    %ebx,(%eax)
80104b61:	76 2d                	jbe    80104b90 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b63:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b66:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b68:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b6a:	39 d3                	cmp    %edx,%ebx
80104b6c:	73 22                	jae    80104b90 <fetchstr+0x40>
80104b6e:	89 d8                	mov    %ebx,%eax
80104b70:	eb 0d                	jmp    80104b7f <fetchstr+0x2f>
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b78:	83 c0 01             	add    $0x1,%eax
80104b7b:	39 c2                	cmp    %eax,%edx
80104b7d:	76 11                	jbe    80104b90 <fetchstr+0x40>
    if(*s == 0)
80104b7f:	80 38 00             	cmpb   $0x0,(%eax)
80104b82:	75 f4                	jne    80104b78 <fetchstr+0x28>
      return s - *pp;
80104b84:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b89:	c9                   	leave  
80104b8a:	c3                   	ret    
80104b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b8f:	90                   	nop
80104b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b98:	c9                   	leave  
80104b99:	c3                   	ret    
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ba0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ba5:	e8 b6 ef ff ff       	call   80103b60 <myproc>
80104baa:	8b 55 08             	mov    0x8(%ebp),%edx
80104bad:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bb0:	8b 40 44             	mov    0x44(%eax),%eax
80104bb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bb6:	e8 a5 ef ff ff       	call   80103b60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bbb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bbe:	8b 00                	mov    (%eax),%eax
80104bc0:	39 c6                	cmp    %eax,%esi
80104bc2:	73 1c                	jae    80104be0 <argint+0x40>
80104bc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bc7:	39 d0                	cmp    %edx,%eax
80104bc9:	72 15                	jb     80104be0 <argint+0x40>
  *ip = *(int*)(addr);
80104bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bce:	8b 53 04             	mov    0x4(%ebx),%edx
80104bd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	5b                   	pop    %ebx
80104bd6:	5e                   	pop    %esi
80104bd7:	5d                   	pop    %ebp
80104bd8:	c3                   	ret    
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be5:	eb ee                	jmp    80104bd5 <argint+0x35>
80104be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
80104bf5:	53                   	push   %ebx
80104bf6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104bf9:	e8 62 ef ff ff       	call   80103b60 <myproc>
80104bfe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c00:	e8 5b ef ff ff       	call   80103b60 <myproc>
80104c05:	8b 55 08             	mov    0x8(%ebp),%edx
80104c08:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c0b:	8b 40 44             	mov    0x44(%eax),%eax
80104c0e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c11:	e8 4a ef ff ff       	call   80103b60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c16:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c19:	8b 00                	mov    (%eax),%eax
80104c1b:	39 c7                	cmp    %eax,%edi
80104c1d:	73 31                	jae    80104c50 <argptr+0x60>
80104c1f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c22:	39 c8                	cmp    %ecx,%eax
80104c24:	72 2a                	jb     80104c50 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c26:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c29:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c2c:	85 d2                	test   %edx,%edx
80104c2e:	78 20                	js     80104c50 <argptr+0x60>
80104c30:	8b 16                	mov    (%esi),%edx
80104c32:	39 c2                	cmp    %eax,%edx
80104c34:	76 1a                	jbe    80104c50 <argptr+0x60>
80104c36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c39:	01 c3                	add    %eax,%ebx
80104c3b:	39 da                	cmp    %ebx,%edx
80104c3d:	72 11                	jb     80104c50 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c42:	89 02                	mov    %eax,(%edx)
  return 0;
80104c44:	31 c0                	xor    %eax,%eax
}
80104c46:	83 c4 0c             	add    $0xc,%esp
80104c49:	5b                   	pop    %ebx
80104c4a:	5e                   	pop    %esi
80104c4b:	5f                   	pop    %edi
80104c4c:	5d                   	pop    %ebp
80104c4d:	c3                   	ret    
80104c4e:	66 90                	xchg   %ax,%ax
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c55:	eb ef                	jmp    80104c46 <argptr+0x56>
80104c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c65:	e8 f6 ee ff ff       	call   80103b60 <myproc>
80104c6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c6d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c70:	8b 40 44             	mov    0x44(%eax),%eax
80104c73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c76:	e8 e5 ee ff ff       	call   80103b60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c7e:	8b 00                	mov    (%eax),%eax
80104c80:	39 c6                	cmp    %eax,%esi
80104c82:	73 44                	jae    80104cc8 <argstr+0x68>
80104c84:	8d 53 08             	lea    0x8(%ebx),%edx
80104c87:	39 d0                	cmp    %edx,%eax
80104c89:	72 3d                	jb     80104cc8 <argstr+0x68>
  *ip = *(int*)(addr);
80104c8b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c8e:	e8 cd ee ff ff       	call   80103b60 <myproc>
  if(addr >= curproc->sz)
80104c93:	3b 18                	cmp    (%eax),%ebx
80104c95:	73 31                	jae    80104cc8 <argstr+0x68>
  *pp = (char*)addr;
80104c97:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c9e:	39 d3                	cmp    %edx,%ebx
80104ca0:	73 26                	jae    80104cc8 <argstr+0x68>
80104ca2:	89 d8                	mov    %ebx,%eax
80104ca4:	eb 11                	jmp    80104cb7 <argstr+0x57>
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
80104cb0:	83 c0 01             	add    $0x1,%eax
80104cb3:	39 c2                	cmp    %eax,%edx
80104cb5:	76 11                	jbe    80104cc8 <argstr+0x68>
    if(*s == 0)
80104cb7:	80 38 00             	cmpb   $0x0,(%eax)
80104cba:	75 f4                	jne    80104cb0 <argstr+0x50>
      return s - *pp;
80104cbc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cbe:	5b                   	pop    %ebx
80104cbf:	5e                   	pop    %esi
80104cc0:	5d                   	pop    %ebp
80104cc1:	c3                   	ret    
80104cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cc8:	5b                   	pop    %ebx
    return -1;
80104cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cce:	5e                   	pop    %esi
80104ccf:	5d                   	pop    %ebp
80104cd0:	c3                   	ret    
80104cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdf:	90                   	nop

80104ce0 <syscall>:
[SYS_shugebrk] sys_shugebrk, // part 2
};

void
syscall(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ce7:	e8 74 ee ff ff       	call   80103b60 <myproc>
80104cec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cee:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cf1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cf4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cf7:	83 fa 17             	cmp    $0x17,%edx
80104cfa:	77 24                	ja     80104d20 <syscall+0x40>
80104cfc:	8b 14 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%edx
80104d03:	85 d2                	test   %edx,%edx
80104d05:	74 19                	je     80104d20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d07:	ff d2                	call   *%edx
80104d09:	89 c2                	mov    %eax,%edx
80104d0b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d0e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d14:	c9                   	leave  
80104d15:	c3                   	ret    
80104d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d20:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d21:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d24:	50                   	push   %eax
80104d25:	ff 73 14             	push   0x14(%ebx)
80104d28:	68 7d 7f 10 80       	push   $0x80107f7d
80104d2d:	e8 6e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d32:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d35:	83 c4 10             	add    $0x10,%esp
80104d38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d42:	c9                   	leave  
80104d43:	c3                   	ret    
80104d44:	66 90                	xchg   %ax,%ax
80104d46:	66 90                	xchg   %ax,%ax
80104d48:	66 90                	xchg   %ax,%ax
80104d4a:	66 90                	xchg   %ax,%ax
80104d4c:	66 90                	xchg   %ax,%ax
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d58:	53                   	push   %ebx
80104d59:	83 ec 34             	sub    $0x34,%esp
80104d5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d62:	57                   	push   %edi
80104d63:	50                   	push   %eax
{
80104d64:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d67:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d6a:	e8 61 d3 ff ff       	call   801020d0 <nameiparent>
80104d6f:	83 c4 10             	add    $0x10,%esp
80104d72:	85 c0                	test   %eax,%eax
80104d74:	0f 84 46 01 00 00    	je     80104ec0 <create+0x170>
    return 0;
  ilock(dp);
80104d7a:	83 ec 0c             	sub    $0xc,%esp
80104d7d:	89 c3                	mov    %eax,%ebx
80104d7f:	50                   	push   %eax
80104d80:	e8 0b ca ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d85:	83 c4 0c             	add    $0xc,%esp
80104d88:	6a 00                	push   $0x0
80104d8a:	57                   	push   %edi
80104d8b:	53                   	push   %ebx
80104d8c:	e8 5f cf ff ff       	call   80101cf0 <dirlookup>
80104d91:	83 c4 10             	add    $0x10,%esp
80104d94:	89 c6                	mov    %eax,%esi
80104d96:	85 c0                	test   %eax,%eax
80104d98:	74 56                	je     80104df0 <create+0xa0>
    iunlockput(dp);
80104d9a:	83 ec 0c             	sub    $0xc,%esp
80104d9d:	53                   	push   %ebx
80104d9e:	e8 7d cc ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104da3:	89 34 24             	mov    %esi,(%esp)
80104da6:	e8 e5 c9 ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104dab:	83 c4 10             	add    $0x10,%esp
80104dae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104db3:	75 1b                	jne    80104dd0 <create+0x80>
80104db5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dba:	75 14                	jne    80104dd0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dbf:	89 f0                	mov    %esi,%eax
80104dc1:	5b                   	pop    %ebx
80104dc2:	5e                   	pop    %esi
80104dc3:	5f                   	pop    %edi
80104dc4:	5d                   	pop    %ebp
80104dc5:	c3                   	ret    
80104dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
80104dd3:	56                   	push   %esi
    return 0;
80104dd4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104dd6:	e8 45 cc ff ff       	call   80101a20 <iunlockput>
    return 0;
80104ddb:	83 c4 10             	add    $0x10,%esp
}
80104dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104de1:	89 f0                	mov    %esi,%eax
80104de3:	5b                   	pop    %ebx
80104de4:	5e                   	pop    %esi
80104de5:	5f                   	pop    %edi
80104de6:	5d                   	pop    %ebp
80104de7:	c3                   	ret    
80104de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104df0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104df4:	83 ec 08             	sub    $0x8,%esp
80104df7:	50                   	push   %eax
80104df8:	ff 33                	push   (%ebx)
80104dfa:	e8 21 c8 ff ff       	call   80101620 <ialloc>
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	89 c6                	mov    %eax,%esi
80104e04:	85 c0                	test   %eax,%eax
80104e06:	0f 84 cd 00 00 00    	je     80104ed9 <create+0x189>
  ilock(ip);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	50                   	push   %eax
80104e10:	e8 7b c9 ff ff       	call   80101790 <ilock>
  ip->major = major;
80104e15:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e19:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e1d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e21:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e25:	b8 01 00 00 00       	mov    $0x1,%eax
80104e2a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e2e:	89 34 24             	mov    %esi,(%esp)
80104e31:	e8 aa c8 ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e36:	83 c4 10             	add    $0x10,%esp
80104e39:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e3e:	74 30                	je     80104e70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e40:	83 ec 04             	sub    $0x4,%esp
80104e43:	ff 76 04             	push   0x4(%esi)
80104e46:	57                   	push   %edi
80104e47:	53                   	push   %ebx
80104e48:	e8 a3 d1 ff ff       	call   80101ff0 <dirlink>
80104e4d:	83 c4 10             	add    $0x10,%esp
80104e50:	85 c0                	test   %eax,%eax
80104e52:	78 78                	js     80104ecc <create+0x17c>
  iunlockput(dp);
80104e54:	83 ec 0c             	sub    $0xc,%esp
80104e57:	53                   	push   %ebx
80104e58:	e8 c3 cb ff ff       	call   80101a20 <iunlockput>
  return ip;
80104e5d:	83 c4 10             	add    $0x10,%esp
}
80104e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e63:	89 f0                	mov    %esi,%eax
80104e65:	5b                   	pop    %ebx
80104e66:	5e                   	pop    %esi
80104e67:	5f                   	pop    %edi
80104e68:	5d                   	pop    %ebp
80104e69:	c3                   	ret    
80104e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e73:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e78:	53                   	push   %ebx
80104e79:	e8 62 c8 ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e7e:	83 c4 0c             	add    $0xc,%esp
80104e81:	ff 76 04             	push   0x4(%esi)
80104e84:	68 20 80 10 80       	push   $0x80108020
80104e89:	56                   	push   %esi
80104e8a:	e8 61 d1 ff ff       	call   80101ff0 <dirlink>
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	85 c0                	test   %eax,%eax
80104e94:	78 18                	js     80104eae <create+0x15e>
80104e96:	83 ec 04             	sub    $0x4,%esp
80104e99:	ff 73 04             	push   0x4(%ebx)
80104e9c:	68 1f 80 10 80       	push   $0x8010801f
80104ea1:	56                   	push   %esi
80104ea2:	e8 49 d1 ff ff       	call   80101ff0 <dirlink>
80104ea7:	83 c4 10             	add    $0x10,%esp
80104eaa:	85 c0                	test   %eax,%eax
80104eac:	79 92                	jns    80104e40 <create+0xf0>
      panic("create dots");
80104eae:	83 ec 0c             	sub    $0xc,%esp
80104eb1:	68 13 80 10 80       	push   $0x80108013
80104eb6:	e8 c5 b4 ff ff       	call   80100380 <panic>
80104ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ebf:	90                   	nop
}
80104ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ec3:	31 f6                	xor    %esi,%esi
}
80104ec5:	5b                   	pop    %ebx
80104ec6:	89 f0                	mov    %esi,%eax
80104ec8:	5e                   	pop    %esi
80104ec9:	5f                   	pop    %edi
80104eca:	5d                   	pop    %ebp
80104ecb:	c3                   	ret    
    panic("create: dirlink");
80104ecc:	83 ec 0c             	sub    $0xc,%esp
80104ecf:	68 22 80 10 80       	push   $0x80108022
80104ed4:	e8 a7 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104ed9:	83 ec 0c             	sub    $0xc,%esp
80104edc:	68 04 80 10 80       	push   $0x80108004
80104ee1:	e8 9a b4 ff ff       	call   80100380 <panic>
80104ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eed:	8d 76 00             	lea    0x0(%esi),%esi

80104ef0 <sys_dup>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ef8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104efb:	50                   	push   %eax
80104efc:	6a 00                	push   $0x0
80104efe:	e8 9d fc ff ff       	call   80104ba0 <argint>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	78 36                	js     80104f40 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f0e:	77 30                	ja     80104f40 <sys_dup+0x50>
80104f10:	e8 4b ec ff ff       	call   80103b60 <myproc>
80104f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f18:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104f1c:	85 f6                	test   %esi,%esi
80104f1e:	74 20                	je     80104f40 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f20:	e8 3b ec ff ff       	call   80103b60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f25:	31 db                	xor    %ebx,%ebx
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f30:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104f34:	85 d2                	test   %edx,%edx
80104f36:	74 18                	je     80104f50 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f38:	83 c3 01             	add    $0x1,%ebx
80104f3b:	83 fb 10             	cmp    $0x10,%ebx
80104f3e:	75 f0                	jne    80104f30 <sys_dup+0x40>
}
80104f40:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f48:	89 d8                	mov    %ebx,%eax
80104f4a:	5b                   	pop    %ebx
80104f4b:	5e                   	pop    %esi
80104f4c:	5d                   	pop    %ebp
80104f4d:	c3                   	ret    
80104f4e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f50:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f53:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104f57:	56                   	push   %esi
80104f58:	e8 53 bf ff ff       	call   80100eb0 <filedup>
  return fd;
80104f5d:	83 c4 10             	add    $0x10,%esp
}
80104f60:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f63:	89 d8                	mov    %ebx,%eax
80104f65:	5b                   	pop    %ebx
80104f66:	5e                   	pop    %esi
80104f67:	5d                   	pop    %ebp
80104f68:	c3                   	ret    
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f70 <sys_read>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f75:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f7b:	53                   	push   %ebx
80104f7c:	6a 00                	push   $0x0
80104f7e:	e8 1d fc ff ff       	call   80104ba0 <argint>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 5e                	js     80104fe8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f8e:	77 58                	ja     80104fe8 <sys_read+0x78>
80104f90:	e8 cb eb ff ff       	call   80103b60 <myproc>
80104f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f98:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104f9c:	85 f6                	test   %esi,%esi
80104f9e:	74 48                	je     80104fe8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fa0:	83 ec 08             	sub    $0x8,%esp
80104fa3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa6:	50                   	push   %eax
80104fa7:	6a 02                	push   $0x2
80104fa9:	e8 f2 fb ff ff       	call   80104ba0 <argint>
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	78 33                	js     80104fe8 <sys_read+0x78>
80104fb5:	83 ec 04             	sub    $0x4,%esp
80104fb8:	ff 75 f0             	push   -0x10(%ebp)
80104fbb:	53                   	push   %ebx
80104fbc:	6a 01                	push   $0x1
80104fbe:	e8 2d fc ff ff       	call   80104bf0 <argptr>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 1e                	js     80104fe8 <sys_read+0x78>
  return fileread(f, p, n);
80104fca:	83 ec 04             	sub    $0x4,%esp
80104fcd:	ff 75 f0             	push   -0x10(%ebp)
80104fd0:	ff 75 f4             	push   -0xc(%ebp)
80104fd3:	56                   	push   %esi
80104fd4:	e8 57 c0 ff ff       	call   80101030 <fileread>
80104fd9:	83 c4 10             	add    $0x10,%esp
}
80104fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fdf:	5b                   	pop    %ebx
80104fe0:	5e                   	pop    %esi
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret    
80104fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fe7:	90                   	nop
    return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fed:	eb ed                	jmp    80104fdc <sys_read+0x6c>
80104fef:	90                   	nop

80104ff0 <sys_write>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ff5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ff8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ffb:	53                   	push   %ebx
80104ffc:	6a 00                	push   $0x0
80104ffe:	e8 9d fb ff ff       	call   80104ba0 <argint>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 5e                	js     80105068 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010500e:	77 58                	ja     80105068 <sys_write+0x78>
80105010:	e8 4b eb ff ff       	call   80103b60 <myproc>
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010501c:	85 f6                	test   %esi,%esi
8010501e:	74 48                	je     80105068 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105020:	83 ec 08             	sub    $0x8,%esp
80105023:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105026:	50                   	push   %eax
80105027:	6a 02                	push   $0x2
80105029:	e8 72 fb ff ff       	call   80104ba0 <argint>
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	85 c0                	test   %eax,%eax
80105033:	78 33                	js     80105068 <sys_write+0x78>
80105035:	83 ec 04             	sub    $0x4,%esp
80105038:	ff 75 f0             	push   -0x10(%ebp)
8010503b:	53                   	push   %ebx
8010503c:	6a 01                	push   $0x1
8010503e:	e8 ad fb ff ff       	call   80104bf0 <argptr>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 1e                	js     80105068 <sys_write+0x78>
  return filewrite(f, p, n);
8010504a:	83 ec 04             	sub    $0x4,%esp
8010504d:	ff 75 f0             	push   -0x10(%ebp)
80105050:	ff 75 f4             	push   -0xc(%ebp)
80105053:	56                   	push   %esi
80105054:	e8 67 c0 ff ff       	call   801010c0 <filewrite>
80105059:	83 c4 10             	add    $0x10,%esp
}
8010505c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105067:	90                   	nop
    return -1;
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506d:	eb ed                	jmp    8010505c <sys_write+0x6c>
8010506f:	90                   	nop

80105070 <sys_close>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105075:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105078:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010507b:	50                   	push   %eax
8010507c:	6a 00                	push   $0x0
8010507e:	e8 1d fb ff ff       	call   80104ba0 <argint>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	78 3e                	js     801050c8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010508a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010508e:	77 38                	ja     801050c8 <sys_close+0x58>
80105090:	e8 cb ea ff ff       	call   80103b60 <myproc>
80105095:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105098:	8d 5a 08             	lea    0x8(%edx),%ebx
8010509b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010509f:	85 f6                	test   %esi,%esi
801050a1:	74 25                	je     801050c8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050a3:	e8 b8 ea ff ff       	call   80103b60 <myproc>
  fileclose(f);
801050a8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050ab:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
801050b2:	00 
  fileclose(f);
801050b3:	56                   	push   %esi
801050b4:	e8 47 be ff ff       	call   80100f00 <fileclose>
  return 0;
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	31 c0                	xor    %eax,%eax
}
801050be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050c1:	5b                   	pop    %ebx
801050c2:	5e                   	pop    %esi
801050c3:	5d                   	pop    %ebp
801050c4:	c3                   	ret    
801050c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cd:	eb ef                	jmp    801050be <sys_close+0x4e>
801050cf:	90                   	nop

801050d0 <sys_fstat>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050db:	53                   	push   %ebx
801050dc:	6a 00                	push   $0x0
801050de:	e8 bd fa ff ff       	call   80104ba0 <argint>
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	78 46                	js     80105130 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ee:	77 40                	ja     80105130 <sys_fstat+0x60>
801050f0:	e8 6b ea ff ff       	call   80103b60 <myproc>
801050f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050f8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801050fc:	85 f6                	test   %esi,%esi
801050fe:	74 30                	je     80105130 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105100:	83 ec 04             	sub    $0x4,%esp
80105103:	6a 14                	push   $0x14
80105105:	53                   	push   %ebx
80105106:	6a 01                	push   $0x1
80105108:	e8 e3 fa ff ff       	call   80104bf0 <argptr>
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	85 c0                	test   %eax,%eax
80105112:	78 1c                	js     80105130 <sys_fstat+0x60>
  return filestat(f, st);
80105114:	83 ec 08             	sub    $0x8,%esp
80105117:	ff 75 f4             	push   -0xc(%ebp)
8010511a:	56                   	push   %esi
8010511b:	e8 c0 be ff ff       	call   80100fe0 <filestat>
80105120:	83 c4 10             	add    $0x10,%esp
}
80105123:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105126:	5b                   	pop    %ebx
80105127:	5e                   	pop    %esi
80105128:	5d                   	pop    %ebp
80105129:	c3                   	ret    
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	eb ec                	jmp    80105123 <sys_fstat+0x53>
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <sys_link>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105145:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105148:	53                   	push   %ebx
80105149:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010514c:	50                   	push   %eax
8010514d:	6a 00                	push   $0x0
8010514f:	e8 0c fb ff ff       	call   80104c60 <argstr>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
80105159:	0f 88 fb 00 00 00    	js     8010525a <sys_link+0x11a>
8010515f:	83 ec 08             	sub    $0x8,%esp
80105162:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105165:	50                   	push   %eax
80105166:	6a 01                	push   $0x1
80105168:	e8 f3 fa ff ff       	call   80104c60 <argstr>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	85 c0                	test   %eax,%eax
80105172:	0f 88 e2 00 00 00    	js     8010525a <sys_link+0x11a>
  begin_op();
80105178:	e8 c3 dd ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
8010517d:	83 ec 0c             	sub    $0xc,%esp
80105180:	ff 75 d4             	push   -0x2c(%ebp)
80105183:	e8 28 cf ff ff       	call   801020b0 <namei>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	89 c3                	mov    %eax,%ebx
8010518d:	85 c0                	test   %eax,%eax
8010518f:	0f 84 e4 00 00 00    	je     80105279 <sys_link+0x139>
  ilock(ip);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	50                   	push   %eax
80105199:	e8 f2 c5 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051a6:	0f 84 b5 00 00 00    	je     80105261 <sys_link+0x121>
  iupdate(ip);
801051ac:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051af:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051b4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051b7:	53                   	push   %ebx
801051b8:	e8 23 c5 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
801051bd:	89 1c 24             	mov    %ebx,(%esp)
801051c0:	e8 ab c6 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051c5:	58                   	pop    %eax
801051c6:	5a                   	pop    %edx
801051c7:	57                   	push   %edi
801051c8:	ff 75 d0             	push   -0x30(%ebp)
801051cb:	e8 00 cf ff ff       	call   801020d0 <nameiparent>
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	89 c6                	mov    %eax,%esi
801051d5:	85 c0                	test   %eax,%eax
801051d7:	74 5b                	je     80105234 <sys_link+0xf4>
  ilock(dp);
801051d9:	83 ec 0c             	sub    $0xc,%esp
801051dc:	50                   	push   %eax
801051dd:	e8 ae c5 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051e2:	8b 03                	mov    (%ebx),%eax
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	39 06                	cmp    %eax,(%esi)
801051e9:	75 3d                	jne    80105228 <sys_link+0xe8>
801051eb:	83 ec 04             	sub    $0x4,%esp
801051ee:	ff 73 04             	push   0x4(%ebx)
801051f1:	57                   	push   %edi
801051f2:	56                   	push   %esi
801051f3:	e8 f8 cd ff ff       	call   80101ff0 <dirlink>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	78 29                	js     80105228 <sys_link+0xe8>
  iunlockput(dp);
801051ff:	83 ec 0c             	sub    $0xc,%esp
80105202:	56                   	push   %esi
80105203:	e8 18 c8 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
80105208:	89 1c 24             	mov    %ebx,(%esp)
8010520b:	e8 b0 c6 ff ff       	call   801018c0 <iput>
  end_op();
80105210:	e8 9b dd ff ff       	call   80102fb0 <end_op>
  return 0;
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	31 c0                	xor    %eax,%eax
}
8010521a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010521d:	5b                   	pop    %ebx
8010521e:	5e                   	pop    %esi
8010521f:	5f                   	pop    %edi
80105220:	5d                   	pop    %ebp
80105221:	c3                   	ret    
80105222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105228:	83 ec 0c             	sub    $0xc,%esp
8010522b:	56                   	push   %esi
8010522c:	e8 ef c7 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105231:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	53                   	push   %ebx
80105238:	e8 53 c5 ff ff       	call   80101790 <ilock>
  ip->nlink--;
8010523d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105242:	89 1c 24             	mov    %ebx,(%esp)
80105245:	e8 96 c4 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010524a:	89 1c 24             	mov    %ebx,(%esp)
8010524d:	e8 ce c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105252:	e8 59 dd ff ff       	call   80102fb0 <end_op>
  return -1;
80105257:	83 c4 10             	add    $0x10,%esp
8010525a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525f:	eb b9                	jmp    8010521a <sys_link+0xda>
    iunlockput(ip);
80105261:	83 ec 0c             	sub    $0xc,%esp
80105264:	53                   	push   %ebx
80105265:	e8 b6 c7 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010526a:	e8 41 dd ff ff       	call   80102fb0 <end_op>
    return -1;
8010526f:	83 c4 10             	add    $0x10,%esp
80105272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105277:	eb a1                	jmp    8010521a <sys_link+0xda>
    end_op();
80105279:	e8 32 dd ff ff       	call   80102fb0 <end_op>
    return -1;
8010527e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105283:	eb 95                	jmp    8010521a <sys_link+0xda>
80105285:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_unlink>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	57                   	push   %edi
80105294:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105295:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105298:	53                   	push   %ebx
80105299:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010529c:	50                   	push   %eax
8010529d:	6a 00                	push   $0x0
8010529f:	e8 bc f9 ff ff       	call   80104c60 <argstr>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	0f 88 7a 01 00 00    	js     80105429 <sys_unlink+0x199>
  begin_op();
801052af:	e8 8c dc ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052b4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052b7:	83 ec 08             	sub    $0x8,%esp
801052ba:	53                   	push   %ebx
801052bb:	ff 75 c0             	push   -0x40(%ebp)
801052be:	e8 0d ce ff ff       	call   801020d0 <nameiparent>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052c9:	85 c0                	test   %eax,%eax
801052cb:	0f 84 62 01 00 00    	je     80105433 <sys_unlink+0x1a3>
  ilock(dp);
801052d1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	57                   	push   %edi
801052d8:	e8 b3 c4 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052dd:	58                   	pop    %eax
801052de:	5a                   	pop    %edx
801052df:	68 20 80 10 80       	push   $0x80108020
801052e4:	53                   	push   %ebx
801052e5:	e8 e6 c9 ff ff       	call   80101cd0 <namecmp>
801052ea:	83 c4 10             	add    $0x10,%esp
801052ed:	85 c0                	test   %eax,%eax
801052ef:	0f 84 fb 00 00 00    	je     801053f0 <sys_unlink+0x160>
801052f5:	83 ec 08             	sub    $0x8,%esp
801052f8:	68 1f 80 10 80       	push   $0x8010801f
801052fd:	53                   	push   %ebx
801052fe:	e8 cd c9 ff ff       	call   80101cd0 <namecmp>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	0f 84 e2 00 00 00    	je     801053f0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010530e:	83 ec 04             	sub    $0x4,%esp
80105311:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105314:	50                   	push   %eax
80105315:	53                   	push   %ebx
80105316:	57                   	push   %edi
80105317:	e8 d4 c9 ff ff       	call   80101cf0 <dirlookup>
8010531c:	83 c4 10             	add    $0x10,%esp
8010531f:	89 c3                	mov    %eax,%ebx
80105321:	85 c0                	test   %eax,%eax
80105323:	0f 84 c7 00 00 00    	je     801053f0 <sys_unlink+0x160>
  ilock(ip);
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	50                   	push   %eax
8010532d:	e8 5e c4 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010533a:	0f 8e 1c 01 00 00    	jle    8010545c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105340:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105345:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105348:	74 66                	je     801053b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010534a:	83 ec 04             	sub    $0x4,%esp
8010534d:	6a 10                	push   $0x10
8010534f:	6a 00                	push   $0x0
80105351:	57                   	push   %edi
80105352:	e8 89 f5 ff ff       	call   801048e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105357:	6a 10                	push   $0x10
80105359:	ff 75 c4             	push   -0x3c(%ebp)
8010535c:	57                   	push   %edi
8010535d:	ff 75 b4             	push   -0x4c(%ebp)
80105360:	e8 3b c8 ff ff       	call   80101ba0 <writei>
80105365:	83 c4 20             	add    $0x20,%esp
80105368:	83 f8 10             	cmp    $0x10,%eax
8010536b:	0f 85 de 00 00 00    	jne    8010544f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105371:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105376:	0f 84 94 00 00 00    	je     80105410 <sys_unlink+0x180>
  iunlockput(dp);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	ff 75 b4             	push   -0x4c(%ebp)
80105382:	e8 99 c6 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105387:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010538c:	89 1c 24             	mov    %ebx,(%esp)
8010538f:	e8 4c c3 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105394:	89 1c 24             	mov    %ebx,(%esp)
80105397:	e8 84 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010539c:	e8 0f dc ff ff       	call   80102fb0 <end_op>
  return 0;
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	31 c0                	xor    %eax,%eax
}
801053a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a9:	5b                   	pop    %ebx
801053aa:	5e                   	pop    %esi
801053ab:	5f                   	pop    %edi
801053ac:	5d                   	pop    %ebp
801053ad:	c3                   	ret    
801053ae:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053b4:	76 94                	jbe    8010534a <sys_unlink+0xba>
801053b6:	be 20 00 00 00       	mov    $0x20,%esi
801053bb:	eb 0b                	jmp    801053c8 <sys_unlink+0x138>
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
801053c0:	83 c6 10             	add    $0x10,%esi
801053c3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053c6:	73 82                	jae    8010534a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053c8:	6a 10                	push   $0x10
801053ca:	56                   	push   %esi
801053cb:	57                   	push   %edi
801053cc:	53                   	push   %ebx
801053cd:	e8 ce c6 ff ff       	call   80101aa0 <readi>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	83 f8 10             	cmp    $0x10,%eax
801053d8:	75 68                	jne    80105442 <sys_unlink+0x1b2>
    if(de.inum != 0)
801053da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053df:	74 df                	je     801053c0 <sys_unlink+0x130>
    iunlockput(ip);
801053e1:	83 ec 0c             	sub    $0xc,%esp
801053e4:	53                   	push   %ebx
801053e5:	e8 36 c6 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	ff 75 b4             	push   -0x4c(%ebp)
801053f6:	e8 25 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
801053fb:	e8 b0 db ff ff       	call   80102fb0 <end_op>
  return -1;
80105400:	83 c4 10             	add    $0x10,%esp
80105403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105408:	eb 9c                	jmp    801053a6 <sys_unlink+0x116>
8010540a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105410:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105413:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105416:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010541b:	50                   	push   %eax
8010541c:	e8 bf c2 ff ff       	call   801016e0 <iupdate>
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	e9 53 ff ff ff       	jmp    8010537c <sys_unlink+0xec>
    return -1;
80105429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542e:	e9 73 ff ff ff       	jmp    801053a6 <sys_unlink+0x116>
    end_op();
80105433:	e8 78 db ff ff       	call   80102fb0 <end_op>
    return -1;
80105438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543d:	e9 64 ff ff ff       	jmp    801053a6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105442:	83 ec 0c             	sub    $0xc,%esp
80105445:	68 44 80 10 80       	push   $0x80108044
8010544a:	e8 31 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	68 56 80 10 80       	push   $0x80108056
80105457:	e8 24 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	68 32 80 10 80       	push   $0x80108032
80105464:	e8 17 af ff ff       	call   80100380 <panic>
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_open>:

int
sys_open(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105475:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105478:	53                   	push   %ebx
80105479:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010547c:	50                   	push   %eax
8010547d:	6a 00                	push   $0x0
8010547f:	e8 dc f7 ff ff       	call   80104c60 <argstr>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	0f 88 8e 00 00 00    	js     8010551d <sys_open+0xad>
8010548f:	83 ec 08             	sub    $0x8,%esp
80105492:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105495:	50                   	push   %eax
80105496:	6a 01                	push   $0x1
80105498:	e8 03 f7 ff ff       	call   80104ba0 <argint>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 79                	js     8010551d <sys_open+0xad>
    return -1;

  begin_op();
801054a4:	e8 97 da ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
801054a9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054ad:	75 79                	jne    80105528 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054af:	83 ec 0c             	sub    $0xc,%esp
801054b2:	ff 75 e0             	push   -0x20(%ebp)
801054b5:	e8 f6 cb ff ff       	call   801020b0 <namei>
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	89 c6                	mov    %eax,%esi
801054bf:	85 c0                	test   %eax,%eax
801054c1:	0f 84 7e 00 00 00    	je     80105545 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054c7:	83 ec 0c             	sub    $0xc,%esp
801054ca:	50                   	push   %eax
801054cb:	e8 c0 c2 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054d8:	0f 84 c2 00 00 00    	je     801055a0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054de:	e8 5d b9 ff ff       	call   80100e40 <filealloc>
801054e3:	89 c7                	mov    %eax,%edi
801054e5:	85 c0                	test   %eax,%eax
801054e7:	74 23                	je     8010550c <sys_open+0x9c>
  struct proc *curproc = myproc();
801054e9:	e8 72 e6 ff ff       	call   80103b60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054f0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801054f4:	85 d2                	test   %edx,%edx
801054f6:	74 60                	je     80105558 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054f8:	83 c3 01             	add    $0x1,%ebx
801054fb:	83 fb 10             	cmp    $0x10,%ebx
801054fe:	75 f0                	jne    801054f0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	57                   	push   %edi
80105504:	e8 f7 b9 ff ff       	call   80100f00 <fileclose>
80105509:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010550c:	83 ec 0c             	sub    $0xc,%esp
8010550f:	56                   	push   %esi
80105510:	e8 0b c5 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105515:	e8 96 da ff ff       	call   80102fb0 <end_op>
    return -1;
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105522:	eb 6d                	jmp    80105591 <sys_open+0x121>
80105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105528:	83 ec 0c             	sub    $0xc,%esp
8010552b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010552e:	31 c9                	xor    %ecx,%ecx
80105530:	ba 02 00 00 00       	mov    $0x2,%edx
80105535:	6a 00                	push   $0x0
80105537:	e8 14 f8 ff ff       	call   80104d50 <create>
    if(ip == 0){
8010553c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010553f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105541:	85 c0                	test   %eax,%eax
80105543:	75 99                	jne    801054de <sys_open+0x6e>
      end_op();
80105545:	e8 66 da ff ff       	call   80102fb0 <end_op>
      return -1;
8010554a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010554f:	eb 40                	jmp    80105591 <sys_open+0x121>
80105551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105558:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010555b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010555f:	56                   	push   %esi
80105560:	e8 0b c3 ff ff       	call   80101870 <iunlock>
  end_op();
80105565:	e8 46 da ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
8010556a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105573:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105576:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105579:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010557b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105582:	f7 d0                	not    %eax
80105584:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105587:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010558a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010558d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105594:	89 d8                	mov    %ebx,%eax
80105596:	5b                   	pop    %ebx
80105597:	5e                   	pop    %esi
80105598:	5f                   	pop    %edi
80105599:	5d                   	pop    %ebp
8010559a:	c3                   	ret    
8010559b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055a3:	85 c9                	test   %ecx,%ecx
801055a5:	0f 84 33 ff ff ff    	je     801054de <sys_open+0x6e>
801055ab:	e9 5c ff ff ff       	jmp    8010550c <sys_open+0x9c>

801055b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055b6:	e8 85 d9 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055bb:	83 ec 08             	sub    $0x8,%esp
801055be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c1:	50                   	push   %eax
801055c2:	6a 00                	push   $0x0
801055c4:	e8 97 f6 ff ff       	call   80104c60 <argstr>
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	85 c0                	test   %eax,%eax
801055ce:	78 30                	js     80105600 <sys_mkdir+0x50>
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d6:	31 c9                	xor    %ecx,%ecx
801055d8:	ba 01 00 00 00       	mov    $0x1,%edx
801055dd:	6a 00                	push   $0x0
801055df:	e8 6c f7 ff ff       	call   80104d50 <create>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	74 15                	je     80105600 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055eb:	83 ec 0c             	sub    $0xc,%esp
801055ee:	50                   	push   %eax
801055ef:	e8 2c c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
801055f4:	e8 b7 d9 ff ff       	call   80102fb0 <end_op>
  return 0;
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	31 c0                	xor    %eax,%eax
}
801055fe:	c9                   	leave  
801055ff:	c3                   	ret    
    end_op();
80105600:	e8 ab d9 ff ff       	call   80102fb0 <end_op>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_mknod>:

int
sys_mknod(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105616:	e8 25 d9 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010561b:	83 ec 08             	sub    $0x8,%esp
8010561e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105621:	50                   	push   %eax
80105622:	6a 00                	push   $0x0
80105624:	e8 37 f6 ff ff       	call   80104c60 <argstr>
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	85 c0                	test   %eax,%eax
8010562e:	78 60                	js     80105690 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105636:	50                   	push   %eax
80105637:	6a 01                	push   $0x1
80105639:	e8 62 f5 ff ff       	call   80104ba0 <argint>
  if((argstr(0, &path)) < 0 ||
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	85 c0                	test   %eax,%eax
80105643:	78 4b                	js     80105690 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105645:	83 ec 08             	sub    $0x8,%esp
80105648:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010564b:	50                   	push   %eax
8010564c:	6a 02                	push   $0x2
8010564e:	e8 4d f5 ff ff       	call   80104ba0 <argint>
     argint(1, &major) < 0 ||
80105653:	83 c4 10             	add    $0x10,%esp
80105656:	85 c0                	test   %eax,%eax
80105658:	78 36                	js     80105690 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010565a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010565e:	83 ec 0c             	sub    $0xc,%esp
80105661:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105665:	ba 03 00 00 00       	mov    $0x3,%edx
8010566a:	50                   	push   %eax
8010566b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010566e:	e8 dd f6 ff ff       	call   80104d50 <create>
     argint(2, &minor) < 0 ||
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	74 16                	je     80105690 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010567a:	83 ec 0c             	sub    $0xc,%esp
8010567d:	50                   	push   %eax
8010567e:	e8 9d c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105683:	e8 28 d9 ff ff       	call   80102fb0 <end_op>
  return 0;
80105688:	83 c4 10             	add    $0x10,%esp
8010568b:	31 c0                	xor    %eax,%eax
}
8010568d:	c9                   	leave  
8010568e:	c3                   	ret    
8010568f:	90                   	nop
    end_op();
80105690:	e8 1b d9 ff ff       	call   80102fb0 <end_op>
    return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569a:	c9                   	leave  
8010569b:	c3                   	ret    
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_chdir>:

int
sys_chdir(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	56                   	push   %esi
801056a4:	53                   	push   %ebx
801056a5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056a8:	e8 b3 e4 ff ff       	call   80103b60 <myproc>
801056ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056af:	e8 8c d8 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056b4:	83 ec 08             	sub    $0x8,%esp
801056b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ba:	50                   	push   %eax
801056bb:	6a 00                	push   $0x0
801056bd:	e8 9e f5 ff ff       	call   80104c60 <argstr>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 77                	js     80105740 <sys_chdir+0xa0>
801056c9:	83 ec 0c             	sub    $0xc,%esp
801056cc:	ff 75 f4             	push   -0xc(%ebp)
801056cf:	e8 dc c9 ff ff       	call   801020b0 <namei>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	89 c3                	mov    %eax,%ebx
801056d9:	85 c0                	test   %eax,%eax
801056db:	74 63                	je     80105740 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	50                   	push   %eax
801056e1:	e8 aa c0 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ee:	75 30                	jne    80105720 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	53                   	push   %ebx
801056f4:	e8 77 c1 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
801056f9:	58                   	pop    %eax
801056fa:	ff 76 6c             	push   0x6c(%esi)
801056fd:	e8 be c1 ff ff       	call   801018c0 <iput>
  end_op();
80105702:	e8 a9 d8 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105707:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	31 c0                	xor    %eax,%eax
}
8010570f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105712:	5b                   	pop    %ebx
80105713:	5e                   	pop    %esi
80105714:	5d                   	pop    %ebp
80105715:	c3                   	ret    
80105716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 f7 c2 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105729:	e8 82 d8 ff ff       	call   80102fb0 <end_op>
    return -1;
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105736:	eb d7                	jmp    8010570f <sys_chdir+0x6f>
80105738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573f:	90                   	nop
    end_op();
80105740:	e8 6b d8 ff ff       	call   80102fb0 <end_op>
    return -1;
80105745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574a:	eb c3                	jmp    8010570f <sys_chdir+0x6f>
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_exec>:

int
sys_exec(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	57                   	push   %edi
80105754:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105755:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010575b:	53                   	push   %ebx
8010575c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105762:	50                   	push   %eax
80105763:	6a 00                	push   $0x0
80105765:	e8 f6 f4 ff ff       	call   80104c60 <argstr>
8010576a:	83 c4 10             	add    $0x10,%esp
8010576d:	85 c0                	test   %eax,%eax
8010576f:	0f 88 87 00 00 00    	js     801057fc <sys_exec+0xac>
80105775:	83 ec 08             	sub    $0x8,%esp
80105778:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010577e:	50                   	push   %eax
8010577f:	6a 01                	push   $0x1
80105781:	e8 1a f4 ff ff       	call   80104ba0 <argint>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	78 6f                	js     801057fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010578d:	83 ec 04             	sub    $0x4,%esp
80105790:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105796:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105798:	68 80 00 00 00       	push   $0x80
8010579d:	6a 00                	push   $0x0
8010579f:	56                   	push   %esi
801057a0:	e8 3b f1 ff ff       	call   801048e0 <memset>
801057a5:	83 c4 10             	add    $0x10,%esp
801057a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057b0:	83 ec 08             	sub    $0x8,%esp
801057b3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057b9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057c0:	50                   	push   %eax
801057c1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057c7:	01 f8                	add    %edi,%eax
801057c9:	50                   	push   %eax
801057ca:	e8 41 f3 ff ff       	call   80104b10 <fetchint>
801057cf:	83 c4 10             	add    $0x10,%esp
801057d2:	85 c0                	test   %eax,%eax
801057d4:	78 26                	js     801057fc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057d6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057dc:	85 c0                	test   %eax,%eax
801057de:	74 30                	je     80105810 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057e0:	83 ec 08             	sub    $0x8,%esp
801057e3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057e6:	52                   	push   %edx
801057e7:	50                   	push   %eax
801057e8:	e8 63 f3 ff ff       	call   80104b50 <fetchstr>
801057ed:	83 c4 10             	add    $0x10,%esp
801057f0:	85 c0                	test   %eax,%eax
801057f2:	78 08                	js     801057fc <sys_exec+0xac>
  for(i=0;; i++){
801057f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057f7:	83 fb 20             	cmp    $0x20,%ebx
801057fa:	75 b4                	jne    801057b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105804:	5b                   	pop    %ebx
80105805:	5e                   	pop    %esi
80105806:	5f                   	pop    %edi
80105807:	5d                   	pop    %ebp
80105808:	c3                   	ret    
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105810:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105817:	00 00 00 00 
  return exec(path, argv);
8010581b:	83 ec 08             	sub    $0x8,%esp
8010581e:	56                   	push   %esi
8010581f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105825:	e8 86 b2 ff ff       	call   80100ab0 <exec>
8010582a:	83 c4 10             	add    $0x10,%esp
}
8010582d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105830:	5b                   	pop    %ebx
80105831:	5e                   	pop    %esi
80105832:	5f                   	pop    %edi
80105833:	5d                   	pop    %ebp
80105834:	c3                   	ret    
80105835:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_pipe>:

int
sys_pipe(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105845:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105848:	53                   	push   %ebx
80105849:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010584c:	6a 08                	push   $0x8
8010584e:	50                   	push   %eax
8010584f:	6a 00                	push   $0x0
80105851:	e8 9a f3 ff ff       	call   80104bf0 <argptr>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 c0                	test   %eax,%eax
8010585b:	78 4a                	js     801058a7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010585d:	83 ec 08             	sub    $0x8,%esp
80105860:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105863:	50                   	push   %eax
80105864:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105867:	50                   	push   %eax
80105868:	e8 b3 dd ff ff       	call   80103620 <pipealloc>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	78 33                	js     801058a7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105874:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105877:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105879:	e8 e2 e2 ff ff       	call   80103b60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010587e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105880:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105884:	85 f6                	test   %esi,%esi
80105886:	74 28                	je     801058b0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105888:	83 c3 01             	add    $0x1,%ebx
8010588b:	83 fb 10             	cmp    $0x10,%ebx
8010588e:	75 f0                	jne    80105880 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	ff 75 e0             	push   -0x20(%ebp)
80105896:	e8 65 b6 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
8010589b:	58                   	pop    %eax
8010589c:	ff 75 e4             	push   -0x1c(%ebp)
8010589f:	e8 5c b6 ff ff       	call   80100f00 <fileclose>
    return -1;
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ac:	eb 53                	jmp    80105901 <sys_pipe+0xc1>
801058ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058b0:	8d 73 08             	lea    0x8(%ebx),%esi
801058b3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ba:	e8 a1 e2 ff ff       	call   80103b60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058bf:	31 d2                	xor    %edx,%edx
801058c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058c8:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
801058cc:	85 c9                	test   %ecx,%ecx
801058ce:	74 20                	je     801058f0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801058d0:	83 c2 01             	add    $0x1,%edx
801058d3:	83 fa 10             	cmp    $0x10,%edx
801058d6:	75 f0                	jne    801058c8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801058d8:	e8 83 e2 ff ff       	call   80103b60 <myproc>
801058dd:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
801058e4:	00 
801058e5:	eb a9                	jmp    80105890 <sys_pipe+0x50>
801058e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ee:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058f0:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
801058f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058f7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058fc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058ff:	31 c0                	xor    %eax,%eax
}
80105901:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105904:	5b                   	pop    %ebx
80105905:	5e                   	pop    %esi
80105906:	5f                   	pop    %edi
80105907:	5d                   	pop    %ebp
80105908:	c3                   	ret    
80105909:	66 90                	xchg   %ax,%ax
8010590b:	66 90                	xchg   %ax,%ax
8010590d:	66 90                	xchg   %ax,%ax
8010590f:	90                   	nop

80105910 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105910:	e9 7b e4 ff ff       	jmp    80103d90 <fork>
80105915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105920 <sys_exit>:
}

int
sys_exit(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 08             	sub    $0x8,%esp
  exit();
80105926:	e8 e5 e6 ff ff       	call   80104010 <exit>
  return 0;  // not reached
}
8010592b:	31 c0                	xor    %eax,%eax
8010592d:	c9                   	leave  
8010592e:	c3                   	ret    
8010592f:	90                   	nop

80105930 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105930:	e9 0b e8 ff ff       	jmp    80104140 <wait>
80105935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_kill>:
}

int
sys_kill(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105946:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105949:	50                   	push   %eax
8010594a:	6a 00                	push   $0x0
8010594c:	e8 4f f2 ff ff       	call   80104ba0 <argint>
80105951:	83 c4 10             	add    $0x10,%esp
80105954:	85 c0                	test   %eax,%eax
80105956:	78 18                	js     80105970 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	ff 75 f4             	push   -0xc(%ebp)
8010595e:	e8 7d ea ff ff       	call   801043e0 <kill>
80105963:	83 c4 10             	add    $0x10,%esp
}
80105966:	c9                   	leave  
80105967:	c3                   	ret    
80105968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop
80105970:	c9                   	leave  
    return -1;
80105971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105976:	c3                   	ret    
80105977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597e:	66 90                	xchg   %ax,%ax

80105980 <sys_getpid>:

int
sys_getpid(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105986:	e8 d5 e1 ff ff       	call   80103b60 <myproc>
8010598b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010598e:	c9                   	leave  
8010598f:	c3                   	ret    

80105990 <sys_sbrk>:

int
sys_sbrk(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105994:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105997:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010599a:	50                   	push   %eax
8010599b:	6a 00                	push   $0x0
8010599d:	e8 fe f1 ff ff       	call   80104ba0 <argint>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	85 c0                	test   %eax,%eax
801059a7:	78 27                	js     801059d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059a9:	e8 b2 e1 ff ff       	call   80103b60 <myproc>
  if(growproc(n) < 0)
801059ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059b3:	ff 75 f4             	push   -0xc(%ebp)
801059b6:	e8 c5 e2 ff ff       	call   80103c80 <growproc>
801059bb:	83 c4 10             	add    $0x10,%esp
801059be:	85 c0                	test   %eax,%eax
801059c0:	78 0e                	js     801059d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059c2:	89 d8                	mov    %ebx,%eax
801059c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059c7:	c9                   	leave  
801059c8:	c3                   	ret    
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059d5:	eb eb                	jmp    801059c2 <sys_sbrk+0x32>
801059d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059de:	66 90                	xchg   %ax,%ax

801059e0 <sys_shugebrk>:
// TODO: implement this
// part 2
// TODO: add growhugeproc
int
sys_shugebrk(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 ae f1 ff ff       	call   80104ba0 <argint>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 27                	js     80105a20 <sys_shugebrk+0x40>
    return -1;
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
801059f9:	e8 62 e1 ff ff       	call   80103b60 <myproc>
  if(growhugeproc(n) < 0)
801059fe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
80105a01:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growhugeproc(n) < 0)
80105a04:	ff 75 f4             	push   -0xc(%ebp)
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
80105a07:	81 c3 00 00 00 1e    	add    $0x1e000000,%ebx
  if(growhugeproc(n) < 0)
80105a0d:	e8 ee e2 ff ff       	call   80103d00 <growhugeproc>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	85 c0                	test   %eax,%eax
80105a17:	78 07                	js     80105a20 <sys_shugebrk+0x40>
    return -1;
  return addr;
}
80105a19:	89 d8                	mov    %ebx,%eax
80105a1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    
    return -1;
80105a20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a25:	eb f2                	jmp    80105a19 <sys_shugebrk+0x39>
80105a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2e:	66 90                	xchg   %ax,%ax

80105a30 <sys_sleep>:

int
sys_sleep(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a3a:	50                   	push   %eax
80105a3b:	6a 00                	push   $0x0
80105a3d:	e8 5e f1 ff ff       	call   80104ba0 <argint>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	0f 88 8a 00 00 00    	js     80105ad7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a4d:	83 ec 0c             	sub    $0xc,%esp
80105a50:	68 e0 4d 11 80       	push   $0x80114de0
80105a55:	e8 c6 ed ff ff       	call   80104820 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a5d:	8b 1d c0 4d 11 80    	mov    0x80114dc0,%ebx
  while(ticks - ticks0 < n){
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 d2                	test   %edx,%edx
80105a68:	75 27                	jne    80105a91 <sys_sleep+0x61>
80105a6a:	eb 54                	jmp    80105ac0 <sys_sleep+0x90>
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a70:	83 ec 08             	sub    $0x8,%esp
80105a73:	68 e0 4d 11 80       	push   $0x80114de0
80105a78:	68 c0 4d 11 80       	push   $0x80114dc0
80105a7d:	e8 3e e8 ff ff       	call   801042c0 <sleep>
  while(ticks - ticks0 < n){
80105a82:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80105a87:	83 c4 10             	add    $0x10,%esp
80105a8a:	29 d8                	sub    %ebx,%eax
80105a8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a8f:	73 2f                	jae    80105ac0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a91:	e8 ca e0 ff ff       	call   80103b60 <myproc>
80105a96:	8b 40 28             	mov    0x28(%eax),%eax
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	74 d3                	je     80105a70 <sys_sleep+0x40>
      release(&tickslock);
80105a9d:	83 ec 0c             	sub    $0xc,%esp
80105aa0:	68 e0 4d 11 80       	push   $0x80114de0
80105aa5:	e8 16 ed ff ff       	call   801047c0 <release>
  }
  release(&tickslock);
  return 0;
}
80105aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    
80105ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105abe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	68 e0 4d 11 80       	push   $0x80114de0
80105ac8:	e8 f3 ec ff ff       	call   801047c0 <release>
  return 0;
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	31 c0                	xor    %eax,%eax
}
80105ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad5:	c9                   	leave  
80105ad6:	c3                   	ret    
    return -1;
80105ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105adc:	eb f4                	jmp    80105ad2 <sys_sleep+0xa2>
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	53                   	push   %ebx
80105ae4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ae7:	68 e0 4d 11 80       	push   $0x80114de0
80105aec:	e8 2f ed ff ff       	call   80104820 <acquire>
  xticks = ticks;
80105af1:	8b 1d c0 4d 11 80    	mov    0x80114dc0,%ebx
  release(&tickslock);
80105af7:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105afe:	e8 bd ec ff ff       	call   801047c0 <release>
  return xticks;
}
80105b03:	89 d8                	mov    %ebx,%eax
80105b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b08:	c9                   	leave  
80105b09:	c3                   	ret    
80105b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b10 <sys_printhugepde>:

// System calls for debugging huge page allocations/mappings
int
sys_printhugepde()
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
80105b15:	53                   	push   %ebx
  pde_t *pgdir = myproc()->pgdir;
  int pid = myproc()->pid;
  int i = 0;
  for (i = 0; i < 1024; i++) {
80105b16:	31 db                	xor    %ebx,%ebx
{
80105b18:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pgdir = myproc()->pgdir;
80105b1b:	e8 40 e0 ff ff       	call   80103b60 <myproc>
80105b20:	8b 78 08             	mov    0x8(%eax),%edi
  int pid = myproc()->pid;
80105b23:	e8 38 e0 ff ff       	call   80103b60 <myproc>
80105b28:	8b 70 14             	mov    0x14(%eax),%esi
  for (i = 0; i < 1024; i++) {
80105b2b:	eb 0e                	jmp    80105b3b <sys_printhugepde+0x2b>
80105b2d:	8d 76 00             	lea    0x0(%esi),%esi
80105b30:	83 c3 01             	add    $0x1,%ebx
80105b33:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b39:	74 2e                	je     80105b69 <sys_printhugepde+0x59>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P))
80105b3b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80105b3e:	89 c2                	mov    %eax,%edx
80105b40:	81 e2 85 00 00 00    	and    $0x85,%edx
80105b46:	81 fa 85 00 00 00    	cmp    $0x85,%edx
80105b4c:	75 e2                	jne    80105b30 <sys_printhugepde+0x20>
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b4e:	50                   	push   %eax
80105b4f:	53                   	push   %ebx
  for (i = 0; i < 1024; i++) {
80105b50:	83 c3 01             	add    $0x1,%ebx
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b53:	56                   	push   %esi
80105b54:	68 65 80 10 80       	push   $0x80108065
80105b59:	e8 42 ab ff ff       	call   801006a0 <cprintf>
80105b5e:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 1024; i++) {
80105b61:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b67:	75 d2                	jne    80105b3b <sys_printhugepde+0x2b>
  }
  return 0;
}
80105b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b6c:	31 c0                	xor    %eax,%eax
80105b6e:	5b                   	pop    %ebx
80105b6f:	5e                   	pop    %esi
80105b70:	5f                   	pop    %edi
80105b71:	5d                   	pop    %ebp
80105b72:	c3                   	ret    
80105b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b80 <sys_procpgdirinfo>:

int
sys_procpgdirinfo()
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
  int *buf;
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b85:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105b88:	53                   	push   %ebx
80105b89:	83 ec 30             	sub    $0x30,%esp
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b8c:	6a 08                	push   $0x8
80105b8e:	50                   	push   %eax
80105b8f:	6a 00                	push   $0x0
80105b91:	e8 5a f0 ff ff       	call   80104bf0 <argptr>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	0f 88 90 00 00 00    	js     80105c31 <sys_procpgdirinfo+0xb1>
    return -1;
  pde_t *pgdir = myproc()->pgdir;
80105ba1:	e8 ba df ff ff       	call   80103b60 <myproc>
  int base_cnt = 0; // base page count
  int huge_cnt = 0; // huge page count
80105ba6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  int base_cnt = 0; // base page count
80105bad:	31 c9                	xor    %ecx,%ecx
80105baf:	8b 70 08             	mov    0x8(%eax),%esi
80105bb2:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105bb8:	eb 12                	jmp    80105bcc <sys_procpgdirinfo+0x4c>
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i = 0;
  int j = 0;
  for (i = 0; i < 1024; i++) {
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
      ++huge_cnt;
    if((pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) && ((pgdir[i] & PTE_PS) == 0) /*Only PTE_P and PTE_U should be set for base pages*/) {
80105bc0:	83 f8 05             	cmp    $0x5,%eax
80105bc3:	74 3a                	je     80105bff <sys_procpgdirinfo+0x7f>
  for (i = 0; i < 1024; i++) {
80105bc5:	83 c6 04             	add    $0x4,%esi
80105bc8:	39 f7                	cmp    %esi,%edi
80105bca:	74 1b                	je     80105be7 <sys_procpgdirinfo+0x67>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
80105bcc:	8b 1e                	mov    (%esi),%ebx
80105bce:	89 d8                	mov    %ebx,%eax
80105bd0:	25 85 00 00 00       	and    $0x85,%eax
80105bd5:	3d 85 00 00 00       	cmp    $0x85,%eax
80105bda:	75 e4                	jne    80105bc0 <sys_procpgdirinfo+0x40>
  for (i = 0; i < 1024; i++) {
80105bdc:	83 c6 04             	add    $0x4,%esi
      ++huge_cnt;
80105bdf:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  for (i = 0; i < 1024; i++) {
80105be3:	39 f7                	cmp    %esi,%edi
80105be5:	75 e5                	jne    80105bcc <sys_procpgdirinfo+0x4c>
          ++base_cnt;
        }
      }
    }
  }
  buf[0] = base_cnt; // base page count
80105be7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  buf[1] = huge_cnt; // huge page count
80105bea:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  buf[0] = base_cnt; // base page count
80105bed:	89 08                	mov    %ecx,(%eax)
  buf[1] = huge_cnt; // huge page count
80105bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bf2:	89 78 04             	mov    %edi,0x4(%eax)
  return 0;
80105bf5:	31 c0                	xor    %eax,%eax
}
80105bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bfa:	5b                   	pop    %ebx
80105bfb:	5e                   	pop    %esi
80105bfc:	5f                   	pop    %edi
80105bfd:	5d                   	pop    %ebp
80105bfe:	c3                   	ret    
      uint* pgtab = (uint*)P2V(PTE_ADDR(pgdir[i]));
80105bff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105c05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
      for (j = 0; j < 1024; j++) {
80105c0b:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
80105c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((pgtab[j] & PTE_U) && (pgtab[j] & PTE_P)) {
80105c18:	8b 10                	mov    (%eax),%edx
80105c1a:	83 e2 05             	and    $0x5,%edx
          ++base_cnt;
80105c1d:	83 fa 05             	cmp    $0x5,%edx
80105c20:	0f 94 c2             	sete   %dl
      for (j = 0; j < 1024; j++) {
80105c23:	83 c0 04             	add    $0x4,%eax
          ++base_cnt;
80105c26:	0f b6 d2             	movzbl %dl,%edx
80105c29:	01 d1                	add    %edx,%ecx
      for (j = 0; j < 1024; j++) {
80105c2b:	39 d8                	cmp    %ebx,%eax
80105c2d:	75 e9                	jne    80105c18 <sys_procpgdirinfo+0x98>
80105c2f:	eb 94                	jmp    80105bc5 <sys_procpgdirinfo+0x45>
    return -1;
80105c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c36:	eb bf                	jmp    80105bf7 <sys_procpgdirinfo+0x77>

80105c38 <alltraps>:
80105c38:	1e                   	push   %ds
80105c39:	06                   	push   %es
80105c3a:	0f a0                	push   %fs
80105c3c:	0f a8                	push   %gs
80105c3e:	60                   	pusha  
80105c3f:	66 b8 10 00          	mov    $0x10,%ax
80105c43:	8e d8                	mov    %eax,%ds
80105c45:	8e c0                	mov    %eax,%es
80105c47:	54                   	push   %esp
80105c48:	e8 c3 00 00 00       	call   80105d10 <trap>
80105c4d:	83 c4 04             	add    $0x4,%esp

80105c50 <trapret>:
80105c50:	61                   	popa   
80105c51:	0f a9                	pop    %gs
80105c53:	0f a1                	pop    %fs
80105c55:	07                   	pop    %es
80105c56:	1f                   	pop    %ds
80105c57:	83 c4 08             	add    $0x8,%esp
80105c5a:	cf                   	iret   
80105c5b:	66 90                	xchg   %ax,%ax
80105c5d:	66 90                	xchg   %ax,%ax
80105c5f:	90                   	nop

80105c60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c60:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c61:	31 c0                	xor    %eax,%eax
{
80105c63:	89 e5                	mov    %esp,%ebp
80105c65:	83 ec 08             	sub    $0x8,%esp
80105c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c70:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c77:	c7 04 c5 22 4e 11 80 	movl   $0x8e000008,-0x7feeb1de(,%eax,8)
80105c7e:	08 00 00 8e 
80105c82:	66 89 14 c5 20 4e 11 	mov    %dx,-0x7feeb1e0(,%eax,8)
80105c89:	80 
80105c8a:	c1 ea 10             	shr    $0x10,%edx
80105c8d:	66 89 14 c5 26 4e 11 	mov    %dx,-0x7feeb1da(,%eax,8)
80105c94:	80 
  for(i = 0; i < 256; i++)
80105c95:	83 c0 01             	add    $0x1,%eax
80105c98:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c9d:	75 d1                	jne    80105c70 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c9f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ca2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105ca7:	c7 05 22 50 11 80 08 	movl   $0xef000008,0x80115022
80105cae:	00 00 ef 
  initlock(&tickslock, "time");
80105cb1:	68 7e 80 10 80       	push   $0x8010807e
80105cb6:	68 e0 4d 11 80       	push   $0x80114de0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cbb:	66 a3 20 50 11 80    	mov    %ax,0x80115020
80105cc1:	c1 e8 10             	shr    $0x10,%eax
80105cc4:	66 a3 26 50 11 80    	mov    %ax,0x80115026
  initlock(&tickslock, "time");
80105cca:	e8 81 e9 ff ff       	call   80104650 <initlock>
}
80105ccf:	83 c4 10             	add    $0x10,%esp
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    
80105cd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop

80105ce0 <idtinit>:

void
idtinit(void)
{
80105ce0:	55                   	push   %ebp
  pd[0] = size-1;
80105ce1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ce6:	89 e5                	mov    %esp,%ebp
80105ce8:	83 ec 10             	sub    $0x10,%esp
80105ceb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cef:	b8 20 4e 11 80       	mov    $0x80114e20,%eax
80105cf4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cf8:	c1 e8 10             	shr    $0x10,%eax
80105cfb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
80105d15:	53                   	push   %ebx
80105d16:	83 ec 1c             	sub    $0x1c,%esp
80105d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d1c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d1f:	83 f8 40             	cmp    $0x40,%eax
80105d22:	0f 84 68 01 00 00    	je     80105e90 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d28:	83 e8 20             	sub    $0x20,%eax
80105d2b:	83 f8 1f             	cmp    $0x1f,%eax
80105d2e:	0f 87 8c 00 00 00    	ja     80105dc0 <trap+0xb0>
80105d34:	ff 24 85 24 81 10 80 	jmp    *-0x7fef7edc(,%eax,4)
80105d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d3f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105d40:	e8 0b c5 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105d45:	e8 a6 cd ff ff       	call   80102af0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d4a:	e8 11 de ff ff       	call   80103b60 <myproc>
80105d4f:	85 c0                	test   %eax,%eax
80105d51:	74 1d                	je     80105d70 <trap+0x60>
80105d53:	e8 08 de ff ff       	call   80103b60 <myproc>
80105d58:	8b 50 28             	mov    0x28(%eax),%edx
80105d5b:	85 d2                	test   %edx,%edx
80105d5d:	74 11                	je     80105d70 <trap+0x60>
80105d5f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d63:	83 e0 03             	and    $0x3,%eax
80105d66:	66 83 f8 03          	cmp    $0x3,%ax
80105d6a:	0f 84 e8 01 00 00    	je     80105f58 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d70:	e8 eb dd ff ff       	call   80103b60 <myproc>
80105d75:	85 c0                	test   %eax,%eax
80105d77:	74 0f                	je     80105d88 <trap+0x78>
80105d79:	e8 e2 dd ff ff       	call   80103b60 <myproc>
80105d7e:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105d82:	0f 84 b8 00 00 00    	je     80105e40 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d88:	e8 d3 dd ff ff       	call   80103b60 <myproc>
80105d8d:	85 c0                	test   %eax,%eax
80105d8f:	74 1d                	je     80105dae <trap+0x9e>
80105d91:	e8 ca dd ff ff       	call   80103b60 <myproc>
80105d96:	8b 40 28             	mov    0x28(%eax),%eax
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	74 11                	je     80105dae <trap+0x9e>
80105d9d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105da1:	83 e0 03             	and    $0x3,%eax
80105da4:	66 83 f8 03          	cmp    $0x3,%ax
80105da8:	0f 84 0f 01 00 00    	je     80105ebd <trap+0x1ad>
    exit();
}
80105dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db1:	5b                   	pop    %ebx
80105db2:	5e                   	pop    %esi
80105db3:	5f                   	pop    %edi
80105db4:	5d                   	pop    %ebp
80105db5:	c3                   	ret    
80105db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105dc0:	e8 9b dd ff ff       	call   80103b60 <myproc>
80105dc5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dc8:	85 c0                	test   %eax,%eax
80105dca:	0f 84 a2 01 00 00    	je     80105f72 <trap+0x262>
80105dd0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105dd4:	0f 84 98 01 00 00    	je     80105f72 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105dda:	0f 20 d1             	mov    %cr2,%ecx
80105ddd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105de0:	e8 5b dd ff ff       	call   80103b40 <cpuid>
80105de5:	8b 73 30             	mov    0x30(%ebx),%esi
80105de8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105deb:	8b 43 34             	mov    0x34(%ebx),%eax
80105dee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105df1:	e8 6a dd ff ff       	call   80103b60 <myproc>
80105df6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105df9:	e8 62 dd ff ff       	call   80103b60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dfe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e04:	51                   	push   %ecx
80105e05:	57                   	push   %edi
80105e06:	52                   	push   %edx
80105e07:	ff 75 e4             	push   -0x1c(%ebp)
80105e0a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e0b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e0e:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e11:	56                   	push   %esi
80105e12:	ff 70 14             	push   0x14(%eax)
80105e15:	68 e0 80 10 80       	push   $0x801080e0
80105e1a:	e8 81 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105e1f:	83 c4 20             	add    $0x20,%esp
80105e22:	e8 39 dd ff ff       	call   80103b60 <myproc>
80105e27:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e2e:	e8 2d dd ff ff       	call   80103b60 <myproc>
80105e33:	85 c0                	test   %eax,%eax
80105e35:	0f 85 18 ff ff ff    	jne    80105d53 <trap+0x43>
80105e3b:	e9 30 ff ff ff       	jmp    80105d70 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105e40:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e44:	0f 85 3e ff ff ff    	jne    80105d88 <trap+0x78>
    yield();
80105e4a:	e8 21 e4 ff ff       	call   80104270 <yield>
80105e4f:	e9 34 ff ff ff       	jmp    80105d88 <trap+0x78>
80105e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e58:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e5b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e5f:	e8 dc dc ff ff       	call   80103b40 <cpuid>
80105e64:	57                   	push   %edi
80105e65:	56                   	push   %esi
80105e66:	50                   	push   %eax
80105e67:	68 88 80 10 80       	push   $0x80108088
80105e6c:	e8 2f a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105e71:	e8 7a cc ff ff       	call   80102af0 <lapiceoi>
    break;
80105e76:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e79:	e8 e2 dc ff ff       	call   80103b60 <myproc>
80105e7e:	85 c0                	test   %eax,%eax
80105e80:	0f 85 cd fe ff ff    	jne    80105d53 <trap+0x43>
80105e86:	e9 e5 fe ff ff       	jmp    80105d70 <trap+0x60>
80105e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e8f:	90                   	nop
    if(myproc()->killed)
80105e90:	e8 cb dc ff ff       	call   80103b60 <myproc>
80105e95:	8b 70 28             	mov    0x28(%eax),%esi
80105e98:	85 f6                	test   %esi,%esi
80105e9a:	0f 85 c8 00 00 00    	jne    80105f68 <trap+0x258>
    myproc()->tf = tf;
80105ea0:	e8 bb dc ff ff       	call   80103b60 <myproc>
80105ea5:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105ea8:	e8 33 ee ff ff       	call   80104ce0 <syscall>
    if(myproc()->killed)
80105ead:	e8 ae dc ff ff       	call   80103b60 <myproc>
80105eb2:	8b 48 28             	mov    0x28(%eax),%ecx
80105eb5:	85 c9                	test   %ecx,%ecx
80105eb7:	0f 84 f1 fe ff ff    	je     80105dae <trap+0x9e>
}
80105ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec0:	5b                   	pop    %ebx
80105ec1:	5e                   	pop    %esi
80105ec2:	5f                   	pop    %edi
80105ec3:	5d                   	pop    %ebp
      exit();
80105ec4:	e9 47 e1 ff ff       	jmp    80104010 <exit>
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ed0:	e8 3b 02 00 00       	call   80106110 <uartintr>
    lapiceoi();
80105ed5:	e8 16 cc ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eda:	e8 81 dc ff ff       	call   80103b60 <myproc>
80105edf:	85 c0                	test   %eax,%eax
80105ee1:	0f 85 6c fe ff ff    	jne    80105d53 <trap+0x43>
80105ee7:	e9 84 fe ff ff       	jmp    80105d70 <trap+0x60>
80105eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ef0:	e8 bb ca ff ff       	call   801029b0 <kbdintr>
    lapiceoi();
80105ef5:	e8 f6 cb ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105efa:	e8 61 dc ff ff       	call   80103b60 <myproc>
80105eff:	85 c0                	test   %eax,%eax
80105f01:	0f 85 4c fe ff ff    	jne    80105d53 <trap+0x43>
80105f07:	e9 64 fe ff ff       	jmp    80105d70 <trap+0x60>
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105f10:	e8 2b dc ff ff       	call   80103b40 <cpuid>
80105f15:	85 c0                	test   %eax,%eax
80105f17:	0f 85 28 fe ff ff    	jne    80105d45 <trap+0x35>
      acquire(&tickslock);
80105f1d:	83 ec 0c             	sub    $0xc,%esp
80105f20:	68 e0 4d 11 80       	push   $0x80114de0
80105f25:	e8 f6 e8 ff ff       	call   80104820 <acquire>
      wakeup(&ticks);
80105f2a:	c7 04 24 c0 4d 11 80 	movl   $0x80114dc0,(%esp)
      ticks++;
80105f31:	83 05 c0 4d 11 80 01 	addl   $0x1,0x80114dc0
      wakeup(&ticks);
80105f38:	e8 43 e4 ff ff       	call   80104380 <wakeup>
      release(&tickslock);
80105f3d:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105f44:	e8 77 e8 ff ff       	call   801047c0 <release>
80105f49:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f4c:	e9 f4 fd ff ff       	jmp    80105d45 <trap+0x35>
80105f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f58:	e8 b3 e0 ff ff       	call   80104010 <exit>
80105f5d:	e9 0e fe ff ff       	jmp    80105d70 <trap+0x60>
80105f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f68:	e8 a3 e0 ff ff       	call   80104010 <exit>
80105f6d:	e9 2e ff ff ff       	jmp    80105ea0 <trap+0x190>
80105f72:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f75:	e8 c6 db ff ff       	call   80103b40 <cpuid>
80105f7a:	83 ec 0c             	sub    $0xc,%esp
80105f7d:	56                   	push   %esi
80105f7e:	57                   	push   %edi
80105f7f:	50                   	push   %eax
80105f80:	ff 73 30             	push   0x30(%ebx)
80105f83:	68 ac 80 10 80       	push   $0x801080ac
80105f88:	e8 13 a7 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105f8d:	83 c4 14             	add    $0x14,%esp
80105f90:	68 83 80 10 80       	push   $0x80108083
80105f95:	e8 e6 a3 ff ff       	call   80100380 <panic>
80105f9a:	66 90                	xchg   %ax,%ax
80105f9c:	66 90                	xchg   %ax,%ax
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fa0:	a1 20 56 11 80       	mov    0x80115620,%eax
80105fa5:	85 c0                	test   %eax,%eax
80105fa7:	74 17                	je     80105fc0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fa9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105faf:	a8 01                	test   $0x1,%al
80105fb1:	74 0d                	je     80105fc0 <uartgetc+0x20>
80105fb3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fb8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fb9:	0f b6 c0             	movzbl %al,%eax
80105fbc:	c3                   	ret    
80105fbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc5:	c3                   	ret    
80105fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fcd:	8d 76 00             	lea    0x0(%esi),%esi

80105fd0 <uartinit>:
{
80105fd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fd1:	31 c9                	xor    %ecx,%ecx
80105fd3:	89 c8                	mov    %ecx,%eax
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	57                   	push   %edi
80105fd8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105fdd:	56                   	push   %esi
80105fde:	89 fa                	mov    %edi,%edx
80105fe0:	53                   	push   %ebx
80105fe1:	83 ec 1c             	sub    $0x1c,%esp
80105fe4:	ee                   	out    %al,(%dx)
80105fe5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105fea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105fef:	89 f2                	mov    %esi,%edx
80105ff1:	ee                   	out    %al,(%dx)
80105ff2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ff7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffc:	ee                   	out    %al,(%dx)
80105ffd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106002:	89 c8                	mov    %ecx,%eax
80106004:	89 da                	mov    %ebx,%edx
80106006:	ee                   	out    %al,(%dx)
80106007:	b8 03 00 00 00       	mov    $0x3,%eax
8010600c:	89 f2                	mov    %esi,%edx
8010600e:	ee                   	out    %al,(%dx)
8010600f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106014:	89 c8                	mov    %ecx,%eax
80106016:	ee                   	out    %al,(%dx)
80106017:	b8 01 00 00 00       	mov    $0x1,%eax
8010601c:	89 da                	mov    %ebx,%edx
8010601e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010601f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106024:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106025:	3c ff                	cmp    $0xff,%al
80106027:	74 78                	je     801060a1 <uartinit+0xd1>
  uart = 1;
80106029:	c7 05 20 56 11 80 01 	movl   $0x1,0x80115620
80106030:	00 00 00 
80106033:	89 fa                	mov    %edi,%edx
80106035:	ec                   	in     (%dx),%al
80106036:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010603b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010603c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010603f:	bf a4 81 10 80       	mov    $0x801081a4,%edi
80106044:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106049:	6a 00                	push   $0x0
8010604b:	6a 04                	push   $0x4
8010604d:	e8 3e c4 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106052:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106056:	83 c4 10             	add    $0x10,%esp
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106060:	a1 20 56 11 80       	mov    0x80115620,%eax
80106065:	bb 80 00 00 00       	mov    $0x80,%ebx
8010606a:	85 c0                	test   %eax,%eax
8010606c:	75 14                	jne    80106082 <uartinit+0xb2>
8010606e:	eb 23                	jmp    80106093 <uartinit+0xc3>
    microdelay(10);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	6a 0a                	push   $0xa
80106075:	e8 96 ca ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010607a:	83 c4 10             	add    $0x10,%esp
8010607d:	83 eb 01             	sub    $0x1,%ebx
80106080:	74 07                	je     80106089 <uartinit+0xb9>
80106082:	89 f2                	mov    %esi,%edx
80106084:	ec                   	in     (%dx),%al
80106085:	a8 20                	test   $0x20,%al
80106087:	74 e7                	je     80106070 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106089:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010608d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106092:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106093:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106097:	83 c7 01             	add    $0x1,%edi
8010609a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010609d:	84 c0                	test   %al,%al
8010609f:	75 bf                	jne    80106060 <uartinit+0x90>
}
801060a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a4:	5b                   	pop    %ebx
801060a5:	5e                   	pop    %esi
801060a6:	5f                   	pop    %edi
801060a7:	5d                   	pop    %ebp
801060a8:	c3                   	ret    
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060b0 <uartputc>:
  if(!uart)
801060b0:	a1 20 56 11 80       	mov    0x80115620,%eax
801060b5:	85 c0                	test   %eax,%eax
801060b7:	74 47                	je     80106100 <uartputc+0x50>
{
801060b9:	55                   	push   %ebp
801060ba:	89 e5                	mov    %esp,%ebp
801060bc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801060c2:	53                   	push   %ebx
801060c3:	bb 80 00 00 00       	mov    $0x80,%ebx
801060c8:	eb 18                	jmp    801060e2 <uartputc+0x32>
801060ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	6a 0a                	push   $0xa
801060d5:	e8 36 ca ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060da:	83 c4 10             	add    $0x10,%esp
801060dd:	83 eb 01             	sub    $0x1,%ebx
801060e0:	74 07                	je     801060e9 <uartputc+0x39>
801060e2:	89 f2                	mov    %esi,%edx
801060e4:	ec                   	in     (%dx),%al
801060e5:	a8 20                	test   $0x20,%al
801060e7:	74 e7                	je     801060d0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060e9:	8b 45 08             	mov    0x8(%ebp),%eax
801060ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060f1:	ee                   	out    %al,(%dx)
}
801060f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060f5:	5b                   	pop    %ebx
801060f6:	5e                   	pop    %esi
801060f7:	5d                   	pop    %ebp
801060f8:	c3                   	ret    
801060f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106100:	c3                   	ret    
80106101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610f:	90                   	nop

80106110 <uartintr>:

void
uartintr(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106116:	68 a0 5f 10 80       	push   $0x80105fa0
8010611b:	e8 60 a7 ff ff       	call   80100880 <consoleintr>
}
80106120:	83 c4 10             	add    $0x10,%esp
80106123:	c9                   	leave  
80106124:	c3                   	ret    

80106125 <vector0>:
80106125:	6a 00                	push   $0x0
80106127:	6a 00                	push   $0x0
80106129:	e9 0a fb ff ff       	jmp    80105c38 <alltraps>

8010612e <vector1>:
8010612e:	6a 00                	push   $0x0
80106130:	6a 01                	push   $0x1
80106132:	e9 01 fb ff ff       	jmp    80105c38 <alltraps>

80106137 <vector2>:
80106137:	6a 00                	push   $0x0
80106139:	6a 02                	push   $0x2
8010613b:	e9 f8 fa ff ff       	jmp    80105c38 <alltraps>

80106140 <vector3>:
80106140:	6a 00                	push   $0x0
80106142:	6a 03                	push   $0x3
80106144:	e9 ef fa ff ff       	jmp    80105c38 <alltraps>

80106149 <vector4>:
80106149:	6a 00                	push   $0x0
8010614b:	6a 04                	push   $0x4
8010614d:	e9 e6 fa ff ff       	jmp    80105c38 <alltraps>

80106152 <vector5>:
80106152:	6a 00                	push   $0x0
80106154:	6a 05                	push   $0x5
80106156:	e9 dd fa ff ff       	jmp    80105c38 <alltraps>

8010615b <vector6>:
8010615b:	6a 00                	push   $0x0
8010615d:	6a 06                	push   $0x6
8010615f:	e9 d4 fa ff ff       	jmp    80105c38 <alltraps>

80106164 <vector7>:
80106164:	6a 00                	push   $0x0
80106166:	6a 07                	push   $0x7
80106168:	e9 cb fa ff ff       	jmp    80105c38 <alltraps>

8010616d <vector8>:
8010616d:	6a 08                	push   $0x8
8010616f:	e9 c4 fa ff ff       	jmp    80105c38 <alltraps>

80106174 <vector9>:
80106174:	6a 00                	push   $0x0
80106176:	6a 09                	push   $0x9
80106178:	e9 bb fa ff ff       	jmp    80105c38 <alltraps>

8010617d <vector10>:
8010617d:	6a 0a                	push   $0xa
8010617f:	e9 b4 fa ff ff       	jmp    80105c38 <alltraps>

80106184 <vector11>:
80106184:	6a 0b                	push   $0xb
80106186:	e9 ad fa ff ff       	jmp    80105c38 <alltraps>

8010618b <vector12>:
8010618b:	6a 0c                	push   $0xc
8010618d:	e9 a6 fa ff ff       	jmp    80105c38 <alltraps>

80106192 <vector13>:
80106192:	6a 0d                	push   $0xd
80106194:	e9 9f fa ff ff       	jmp    80105c38 <alltraps>

80106199 <vector14>:
80106199:	6a 0e                	push   $0xe
8010619b:	e9 98 fa ff ff       	jmp    80105c38 <alltraps>

801061a0 <vector15>:
801061a0:	6a 00                	push   $0x0
801061a2:	6a 0f                	push   $0xf
801061a4:	e9 8f fa ff ff       	jmp    80105c38 <alltraps>

801061a9 <vector16>:
801061a9:	6a 00                	push   $0x0
801061ab:	6a 10                	push   $0x10
801061ad:	e9 86 fa ff ff       	jmp    80105c38 <alltraps>

801061b2 <vector17>:
801061b2:	6a 11                	push   $0x11
801061b4:	e9 7f fa ff ff       	jmp    80105c38 <alltraps>

801061b9 <vector18>:
801061b9:	6a 00                	push   $0x0
801061bb:	6a 12                	push   $0x12
801061bd:	e9 76 fa ff ff       	jmp    80105c38 <alltraps>

801061c2 <vector19>:
801061c2:	6a 00                	push   $0x0
801061c4:	6a 13                	push   $0x13
801061c6:	e9 6d fa ff ff       	jmp    80105c38 <alltraps>

801061cb <vector20>:
801061cb:	6a 00                	push   $0x0
801061cd:	6a 14                	push   $0x14
801061cf:	e9 64 fa ff ff       	jmp    80105c38 <alltraps>

801061d4 <vector21>:
801061d4:	6a 00                	push   $0x0
801061d6:	6a 15                	push   $0x15
801061d8:	e9 5b fa ff ff       	jmp    80105c38 <alltraps>

801061dd <vector22>:
801061dd:	6a 00                	push   $0x0
801061df:	6a 16                	push   $0x16
801061e1:	e9 52 fa ff ff       	jmp    80105c38 <alltraps>

801061e6 <vector23>:
801061e6:	6a 00                	push   $0x0
801061e8:	6a 17                	push   $0x17
801061ea:	e9 49 fa ff ff       	jmp    80105c38 <alltraps>

801061ef <vector24>:
801061ef:	6a 00                	push   $0x0
801061f1:	6a 18                	push   $0x18
801061f3:	e9 40 fa ff ff       	jmp    80105c38 <alltraps>

801061f8 <vector25>:
801061f8:	6a 00                	push   $0x0
801061fa:	6a 19                	push   $0x19
801061fc:	e9 37 fa ff ff       	jmp    80105c38 <alltraps>

80106201 <vector26>:
80106201:	6a 00                	push   $0x0
80106203:	6a 1a                	push   $0x1a
80106205:	e9 2e fa ff ff       	jmp    80105c38 <alltraps>

8010620a <vector27>:
8010620a:	6a 00                	push   $0x0
8010620c:	6a 1b                	push   $0x1b
8010620e:	e9 25 fa ff ff       	jmp    80105c38 <alltraps>

80106213 <vector28>:
80106213:	6a 00                	push   $0x0
80106215:	6a 1c                	push   $0x1c
80106217:	e9 1c fa ff ff       	jmp    80105c38 <alltraps>

8010621c <vector29>:
8010621c:	6a 00                	push   $0x0
8010621e:	6a 1d                	push   $0x1d
80106220:	e9 13 fa ff ff       	jmp    80105c38 <alltraps>

80106225 <vector30>:
80106225:	6a 00                	push   $0x0
80106227:	6a 1e                	push   $0x1e
80106229:	e9 0a fa ff ff       	jmp    80105c38 <alltraps>

8010622e <vector31>:
8010622e:	6a 00                	push   $0x0
80106230:	6a 1f                	push   $0x1f
80106232:	e9 01 fa ff ff       	jmp    80105c38 <alltraps>

80106237 <vector32>:
80106237:	6a 00                	push   $0x0
80106239:	6a 20                	push   $0x20
8010623b:	e9 f8 f9 ff ff       	jmp    80105c38 <alltraps>

80106240 <vector33>:
80106240:	6a 00                	push   $0x0
80106242:	6a 21                	push   $0x21
80106244:	e9 ef f9 ff ff       	jmp    80105c38 <alltraps>

80106249 <vector34>:
80106249:	6a 00                	push   $0x0
8010624b:	6a 22                	push   $0x22
8010624d:	e9 e6 f9 ff ff       	jmp    80105c38 <alltraps>

80106252 <vector35>:
80106252:	6a 00                	push   $0x0
80106254:	6a 23                	push   $0x23
80106256:	e9 dd f9 ff ff       	jmp    80105c38 <alltraps>

8010625b <vector36>:
8010625b:	6a 00                	push   $0x0
8010625d:	6a 24                	push   $0x24
8010625f:	e9 d4 f9 ff ff       	jmp    80105c38 <alltraps>

80106264 <vector37>:
80106264:	6a 00                	push   $0x0
80106266:	6a 25                	push   $0x25
80106268:	e9 cb f9 ff ff       	jmp    80105c38 <alltraps>

8010626d <vector38>:
8010626d:	6a 00                	push   $0x0
8010626f:	6a 26                	push   $0x26
80106271:	e9 c2 f9 ff ff       	jmp    80105c38 <alltraps>

80106276 <vector39>:
80106276:	6a 00                	push   $0x0
80106278:	6a 27                	push   $0x27
8010627a:	e9 b9 f9 ff ff       	jmp    80105c38 <alltraps>

8010627f <vector40>:
8010627f:	6a 00                	push   $0x0
80106281:	6a 28                	push   $0x28
80106283:	e9 b0 f9 ff ff       	jmp    80105c38 <alltraps>

80106288 <vector41>:
80106288:	6a 00                	push   $0x0
8010628a:	6a 29                	push   $0x29
8010628c:	e9 a7 f9 ff ff       	jmp    80105c38 <alltraps>

80106291 <vector42>:
80106291:	6a 00                	push   $0x0
80106293:	6a 2a                	push   $0x2a
80106295:	e9 9e f9 ff ff       	jmp    80105c38 <alltraps>

8010629a <vector43>:
8010629a:	6a 00                	push   $0x0
8010629c:	6a 2b                	push   $0x2b
8010629e:	e9 95 f9 ff ff       	jmp    80105c38 <alltraps>

801062a3 <vector44>:
801062a3:	6a 00                	push   $0x0
801062a5:	6a 2c                	push   $0x2c
801062a7:	e9 8c f9 ff ff       	jmp    80105c38 <alltraps>

801062ac <vector45>:
801062ac:	6a 00                	push   $0x0
801062ae:	6a 2d                	push   $0x2d
801062b0:	e9 83 f9 ff ff       	jmp    80105c38 <alltraps>

801062b5 <vector46>:
801062b5:	6a 00                	push   $0x0
801062b7:	6a 2e                	push   $0x2e
801062b9:	e9 7a f9 ff ff       	jmp    80105c38 <alltraps>

801062be <vector47>:
801062be:	6a 00                	push   $0x0
801062c0:	6a 2f                	push   $0x2f
801062c2:	e9 71 f9 ff ff       	jmp    80105c38 <alltraps>

801062c7 <vector48>:
801062c7:	6a 00                	push   $0x0
801062c9:	6a 30                	push   $0x30
801062cb:	e9 68 f9 ff ff       	jmp    80105c38 <alltraps>

801062d0 <vector49>:
801062d0:	6a 00                	push   $0x0
801062d2:	6a 31                	push   $0x31
801062d4:	e9 5f f9 ff ff       	jmp    80105c38 <alltraps>

801062d9 <vector50>:
801062d9:	6a 00                	push   $0x0
801062db:	6a 32                	push   $0x32
801062dd:	e9 56 f9 ff ff       	jmp    80105c38 <alltraps>

801062e2 <vector51>:
801062e2:	6a 00                	push   $0x0
801062e4:	6a 33                	push   $0x33
801062e6:	e9 4d f9 ff ff       	jmp    80105c38 <alltraps>

801062eb <vector52>:
801062eb:	6a 00                	push   $0x0
801062ed:	6a 34                	push   $0x34
801062ef:	e9 44 f9 ff ff       	jmp    80105c38 <alltraps>

801062f4 <vector53>:
801062f4:	6a 00                	push   $0x0
801062f6:	6a 35                	push   $0x35
801062f8:	e9 3b f9 ff ff       	jmp    80105c38 <alltraps>

801062fd <vector54>:
801062fd:	6a 00                	push   $0x0
801062ff:	6a 36                	push   $0x36
80106301:	e9 32 f9 ff ff       	jmp    80105c38 <alltraps>

80106306 <vector55>:
80106306:	6a 00                	push   $0x0
80106308:	6a 37                	push   $0x37
8010630a:	e9 29 f9 ff ff       	jmp    80105c38 <alltraps>

8010630f <vector56>:
8010630f:	6a 00                	push   $0x0
80106311:	6a 38                	push   $0x38
80106313:	e9 20 f9 ff ff       	jmp    80105c38 <alltraps>

80106318 <vector57>:
80106318:	6a 00                	push   $0x0
8010631a:	6a 39                	push   $0x39
8010631c:	e9 17 f9 ff ff       	jmp    80105c38 <alltraps>

80106321 <vector58>:
80106321:	6a 00                	push   $0x0
80106323:	6a 3a                	push   $0x3a
80106325:	e9 0e f9 ff ff       	jmp    80105c38 <alltraps>

8010632a <vector59>:
8010632a:	6a 00                	push   $0x0
8010632c:	6a 3b                	push   $0x3b
8010632e:	e9 05 f9 ff ff       	jmp    80105c38 <alltraps>

80106333 <vector60>:
80106333:	6a 00                	push   $0x0
80106335:	6a 3c                	push   $0x3c
80106337:	e9 fc f8 ff ff       	jmp    80105c38 <alltraps>

8010633c <vector61>:
8010633c:	6a 00                	push   $0x0
8010633e:	6a 3d                	push   $0x3d
80106340:	e9 f3 f8 ff ff       	jmp    80105c38 <alltraps>

80106345 <vector62>:
80106345:	6a 00                	push   $0x0
80106347:	6a 3e                	push   $0x3e
80106349:	e9 ea f8 ff ff       	jmp    80105c38 <alltraps>

8010634e <vector63>:
8010634e:	6a 00                	push   $0x0
80106350:	6a 3f                	push   $0x3f
80106352:	e9 e1 f8 ff ff       	jmp    80105c38 <alltraps>

80106357 <vector64>:
80106357:	6a 00                	push   $0x0
80106359:	6a 40                	push   $0x40
8010635b:	e9 d8 f8 ff ff       	jmp    80105c38 <alltraps>

80106360 <vector65>:
80106360:	6a 00                	push   $0x0
80106362:	6a 41                	push   $0x41
80106364:	e9 cf f8 ff ff       	jmp    80105c38 <alltraps>

80106369 <vector66>:
80106369:	6a 00                	push   $0x0
8010636b:	6a 42                	push   $0x42
8010636d:	e9 c6 f8 ff ff       	jmp    80105c38 <alltraps>

80106372 <vector67>:
80106372:	6a 00                	push   $0x0
80106374:	6a 43                	push   $0x43
80106376:	e9 bd f8 ff ff       	jmp    80105c38 <alltraps>

8010637b <vector68>:
8010637b:	6a 00                	push   $0x0
8010637d:	6a 44                	push   $0x44
8010637f:	e9 b4 f8 ff ff       	jmp    80105c38 <alltraps>

80106384 <vector69>:
80106384:	6a 00                	push   $0x0
80106386:	6a 45                	push   $0x45
80106388:	e9 ab f8 ff ff       	jmp    80105c38 <alltraps>

8010638d <vector70>:
8010638d:	6a 00                	push   $0x0
8010638f:	6a 46                	push   $0x46
80106391:	e9 a2 f8 ff ff       	jmp    80105c38 <alltraps>

80106396 <vector71>:
80106396:	6a 00                	push   $0x0
80106398:	6a 47                	push   $0x47
8010639a:	e9 99 f8 ff ff       	jmp    80105c38 <alltraps>

8010639f <vector72>:
8010639f:	6a 00                	push   $0x0
801063a1:	6a 48                	push   $0x48
801063a3:	e9 90 f8 ff ff       	jmp    80105c38 <alltraps>

801063a8 <vector73>:
801063a8:	6a 00                	push   $0x0
801063aa:	6a 49                	push   $0x49
801063ac:	e9 87 f8 ff ff       	jmp    80105c38 <alltraps>

801063b1 <vector74>:
801063b1:	6a 00                	push   $0x0
801063b3:	6a 4a                	push   $0x4a
801063b5:	e9 7e f8 ff ff       	jmp    80105c38 <alltraps>

801063ba <vector75>:
801063ba:	6a 00                	push   $0x0
801063bc:	6a 4b                	push   $0x4b
801063be:	e9 75 f8 ff ff       	jmp    80105c38 <alltraps>

801063c3 <vector76>:
801063c3:	6a 00                	push   $0x0
801063c5:	6a 4c                	push   $0x4c
801063c7:	e9 6c f8 ff ff       	jmp    80105c38 <alltraps>

801063cc <vector77>:
801063cc:	6a 00                	push   $0x0
801063ce:	6a 4d                	push   $0x4d
801063d0:	e9 63 f8 ff ff       	jmp    80105c38 <alltraps>

801063d5 <vector78>:
801063d5:	6a 00                	push   $0x0
801063d7:	6a 4e                	push   $0x4e
801063d9:	e9 5a f8 ff ff       	jmp    80105c38 <alltraps>

801063de <vector79>:
801063de:	6a 00                	push   $0x0
801063e0:	6a 4f                	push   $0x4f
801063e2:	e9 51 f8 ff ff       	jmp    80105c38 <alltraps>

801063e7 <vector80>:
801063e7:	6a 00                	push   $0x0
801063e9:	6a 50                	push   $0x50
801063eb:	e9 48 f8 ff ff       	jmp    80105c38 <alltraps>

801063f0 <vector81>:
801063f0:	6a 00                	push   $0x0
801063f2:	6a 51                	push   $0x51
801063f4:	e9 3f f8 ff ff       	jmp    80105c38 <alltraps>

801063f9 <vector82>:
801063f9:	6a 00                	push   $0x0
801063fb:	6a 52                	push   $0x52
801063fd:	e9 36 f8 ff ff       	jmp    80105c38 <alltraps>

80106402 <vector83>:
80106402:	6a 00                	push   $0x0
80106404:	6a 53                	push   $0x53
80106406:	e9 2d f8 ff ff       	jmp    80105c38 <alltraps>

8010640b <vector84>:
8010640b:	6a 00                	push   $0x0
8010640d:	6a 54                	push   $0x54
8010640f:	e9 24 f8 ff ff       	jmp    80105c38 <alltraps>

80106414 <vector85>:
80106414:	6a 00                	push   $0x0
80106416:	6a 55                	push   $0x55
80106418:	e9 1b f8 ff ff       	jmp    80105c38 <alltraps>

8010641d <vector86>:
8010641d:	6a 00                	push   $0x0
8010641f:	6a 56                	push   $0x56
80106421:	e9 12 f8 ff ff       	jmp    80105c38 <alltraps>

80106426 <vector87>:
80106426:	6a 00                	push   $0x0
80106428:	6a 57                	push   $0x57
8010642a:	e9 09 f8 ff ff       	jmp    80105c38 <alltraps>

8010642f <vector88>:
8010642f:	6a 00                	push   $0x0
80106431:	6a 58                	push   $0x58
80106433:	e9 00 f8 ff ff       	jmp    80105c38 <alltraps>

80106438 <vector89>:
80106438:	6a 00                	push   $0x0
8010643a:	6a 59                	push   $0x59
8010643c:	e9 f7 f7 ff ff       	jmp    80105c38 <alltraps>

80106441 <vector90>:
80106441:	6a 00                	push   $0x0
80106443:	6a 5a                	push   $0x5a
80106445:	e9 ee f7 ff ff       	jmp    80105c38 <alltraps>

8010644a <vector91>:
8010644a:	6a 00                	push   $0x0
8010644c:	6a 5b                	push   $0x5b
8010644e:	e9 e5 f7 ff ff       	jmp    80105c38 <alltraps>

80106453 <vector92>:
80106453:	6a 00                	push   $0x0
80106455:	6a 5c                	push   $0x5c
80106457:	e9 dc f7 ff ff       	jmp    80105c38 <alltraps>

8010645c <vector93>:
8010645c:	6a 00                	push   $0x0
8010645e:	6a 5d                	push   $0x5d
80106460:	e9 d3 f7 ff ff       	jmp    80105c38 <alltraps>

80106465 <vector94>:
80106465:	6a 00                	push   $0x0
80106467:	6a 5e                	push   $0x5e
80106469:	e9 ca f7 ff ff       	jmp    80105c38 <alltraps>

8010646e <vector95>:
8010646e:	6a 00                	push   $0x0
80106470:	6a 5f                	push   $0x5f
80106472:	e9 c1 f7 ff ff       	jmp    80105c38 <alltraps>

80106477 <vector96>:
80106477:	6a 00                	push   $0x0
80106479:	6a 60                	push   $0x60
8010647b:	e9 b8 f7 ff ff       	jmp    80105c38 <alltraps>

80106480 <vector97>:
80106480:	6a 00                	push   $0x0
80106482:	6a 61                	push   $0x61
80106484:	e9 af f7 ff ff       	jmp    80105c38 <alltraps>

80106489 <vector98>:
80106489:	6a 00                	push   $0x0
8010648b:	6a 62                	push   $0x62
8010648d:	e9 a6 f7 ff ff       	jmp    80105c38 <alltraps>

80106492 <vector99>:
80106492:	6a 00                	push   $0x0
80106494:	6a 63                	push   $0x63
80106496:	e9 9d f7 ff ff       	jmp    80105c38 <alltraps>

8010649b <vector100>:
8010649b:	6a 00                	push   $0x0
8010649d:	6a 64                	push   $0x64
8010649f:	e9 94 f7 ff ff       	jmp    80105c38 <alltraps>

801064a4 <vector101>:
801064a4:	6a 00                	push   $0x0
801064a6:	6a 65                	push   $0x65
801064a8:	e9 8b f7 ff ff       	jmp    80105c38 <alltraps>

801064ad <vector102>:
801064ad:	6a 00                	push   $0x0
801064af:	6a 66                	push   $0x66
801064b1:	e9 82 f7 ff ff       	jmp    80105c38 <alltraps>

801064b6 <vector103>:
801064b6:	6a 00                	push   $0x0
801064b8:	6a 67                	push   $0x67
801064ba:	e9 79 f7 ff ff       	jmp    80105c38 <alltraps>

801064bf <vector104>:
801064bf:	6a 00                	push   $0x0
801064c1:	6a 68                	push   $0x68
801064c3:	e9 70 f7 ff ff       	jmp    80105c38 <alltraps>

801064c8 <vector105>:
801064c8:	6a 00                	push   $0x0
801064ca:	6a 69                	push   $0x69
801064cc:	e9 67 f7 ff ff       	jmp    80105c38 <alltraps>

801064d1 <vector106>:
801064d1:	6a 00                	push   $0x0
801064d3:	6a 6a                	push   $0x6a
801064d5:	e9 5e f7 ff ff       	jmp    80105c38 <alltraps>

801064da <vector107>:
801064da:	6a 00                	push   $0x0
801064dc:	6a 6b                	push   $0x6b
801064de:	e9 55 f7 ff ff       	jmp    80105c38 <alltraps>

801064e3 <vector108>:
801064e3:	6a 00                	push   $0x0
801064e5:	6a 6c                	push   $0x6c
801064e7:	e9 4c f7 ff ff       	jmp    80105c38 <alltraps>

801064ec <vector109>:
801064ec:	6a 00                	push   $0x0
801064ee:	6a 6d                	push   $0x6d
801064f0:	e9 43 f7 ff ff       	jmp    80105c38 <alltraps>

801064f5 <vector110>:
801064f5:	6a 00                	push   $0x0
801064f7:	6a 6e                	push   $0x6e
801064f9:	e9 3a f7 ff ff       	jmp    80105c38 <alltraps>

801064fe <vector111>:
801064fe:	6a 00                	push   $0x0
80106500:	6a 6f                	push   $0x6f
80106502:	e9 31 f7 ff ff       	jmp    80105c38 <alltraps>

80106507 <vector112>:
80106507:	6a 00                	push   $0x0
80106509:	6a 70                	push   $0x70
8010650b:	e9 28 f7 ff ff       	jmp    80105c38 <alltraps>

80106510 <vector113>:
80106510:	6a 00                	push   $0x0
80106512:	6a 71                	push   $0x71
80106514:	e9 1f f7 ff ff       	jmp    80105c38 <alltraps>

80106519 <vector114>:
80106519:	6a 00                	push   $0x0
8010651b:	6a 72                	push   $0x72
8010651d:	e9 16 f7 ff ff       	jmp    80105c38 <alltraps>

80106522 <vector115>:
80106522:	6a 00                	push   $0x0
80106524:	6a 73                	push   $0x73
80106526:	e9 0d f7 ff ff       	jmp    80105c38 <alltraps>

8010652b <vector116>:
8010652b:	6a 00                	push   $0x0
8010652d:	6a 74                	push   $0x74
8010652f:	e9 04 f7 ff ff       	jmp    80105c38 <alltraps>

80106534 <vector117>:
80106534:	6a 00                	push   $0x0
80106536:	6a 75                	push   $0x75
80106538:	e9 fb f6 ff ff       	jmp    80105c38 <alltraps>

8010653d <vector118>:
8010653d:	6a 00                	push   $0x0
8010653f:	6a 76                	push   $0x76
80106541:	e9 f2 f6 ff ff       	jmp    80105c38 <alltraps>

80106546 <vector119>:
80106546:	6a 00                	push   $0x0
80106548:	6a 77                	push   $0x77
8010654a:	e9 e9 f6 ff ff       	jmp    80105c38 <alltraps>

8010654f <vector120>:
8010654f:	6a 00                	push   $0x0
80106551:	6a 78                	push   $0x78
80106553:	e9 e0 f6 ff ff       	jmp    80105c38 <alltraps>

80106558 <vector121>:
80106558:	6a 00                	push   $0x0
8010655a:	6a 79                	push   $0x79
8010655c:	e9 d7 f6 ff ff       	jmp    80105c38 <alltraps>

80106561 <vector122>:
80106561:	6a 00                	push   $0x0
80106563:	6a 7a                	push   $0x7a
80106565:	e9 ce f6 ff ff       	jmp    80105c38 <alltraps>

8010656a <vector123>:
8010656a:	6a 00                	push   $0x0
8010656c:	6a 7b                	push   $0x7b
8010656e:	e9 c5 f6 ff ff       	jmp    80105c38 <alltraps>

80106573 <vector124>:
80106573:	6a 00                	push   $0x0
80106575:	6a 7c                	push   $0x7c
80106577:	e9 bc f6 ff ff       	jmp    80105c38 <alltraps>

8010657c <vector125>:
8010657c:	6a 00                	push   $0x0
8010657e:	6a 7d                	push   $0x7d
80106580:	e9 b3 f6 ff ff       	jmp    80105c38 <alltraps>

80106585 <vector126>:
80106585:	6a 00                	push   $0x0
80106587:	6a 7e                	push   $0x7e
80106589:	e9 aa f6 ff ff       	jmp    80105c38 <alltraps>

8010658e <vector127>:
8010658e:	6a 00                	push   $0x0
80106590:	6a 7f                	push   $0x7f
80106592:	e9 a1 f6 ff ff       	jmp    80105c38 <alltraps>

80106597 <vector128>:
80106597:	6a 00                	push   $0x0
80106599:	68 80 00 00 00       	push   $0x80
8010659e:	e9 95 f6 ff ff       	jmp    80105c38 <alltraps>

801065a3 <vector129>:
801065a3:	6a 00                	push   $0x0
801065a5:	68 81 00 00 00       	push   $0x81
801065aa:	e9 89 f6 ff ff       	jmp    80105c38 <alltraps>

801065af <vector130>:
801065af:	6a 00                	push   $0x0
801065b1:	68 82 00 00 00       	push   $0x82
801065b6:	e9 7d f6 ff ff       	jmp    80105c38 <alltraps>

801065bb <vector131>:
801065bb:	6a 00                	push   $0x0
801065bd:	68 83 00 00 00       	push   $0x83
801065c2:	e9 71 f6 ff ff       	jmp    80105c38 <alltraps>

801065c7 <vector132>:
801065c7:	6a 00                	push   $0x0
801065c9:	68 84 00 00 00       	push   $0x84
801065ce:	e9 65 f6 ff ff       	jmp    80105c38 <alltraps>

801065d3 <vector133>:
801065d3:	6a 00                	push   $0x0
801065d5:	68 85 00 00 00       	push   $0x85
801065da:	e9 59 f6 ff ff       	jmp    80105c38 <alltraps>

801065df <vector134>:
801065df:	6a 00                	push   $0x0
801065e1:	68 86 00 00 00       	push   $0x86
801065e6:	e9 4d f6 ff ff       	jmp    80105c38 <alltraps>

801065eb <vector135>:
801065eb:	6a 00                	push   $0x0
801065ed:	68 87 00 00 00       	push   $0x87
801065f2:	e9 41 f6 ff ff       	jmp    80105c38 <alltraps>

801065f7 <vector136>:
801065f7:	6a 00                	push   $0x0
801065f9:	68 88 00 00 00       	push   $0x88
801065fe:	e9 35 f6 ff ff       	jmp    80105c38 <alltraps>

80106603 <vector137>:
80106603:	6a 00                	push   $0x0
80106605:	68 89 00 00 00       	push   $0x89
8010660a:	e9 29 f6 ff ff       	jmp    80105c38 <alltraps>

8010660f <vector138>:
8010660f:	6a 00                	push   $0x0
80106611:	68 8a 00 00 00       	push   $0x8a
80106616:	e9 1d f6 ff ff       	jmp    80105c38 <alltraps>

8010661b <vector139>:
8010661b:	6a 00                	push   $0x0
8010661d:	68 8b 00 00 00       	push   $0x8b
80106622:	e9 11 f6 ff ff       	jmp    80105c38 <alltraps>

80106627 <vector140>:
80106627:	6a 00                	push   $0x0
80106629:	68 8c 00 00 00       	push   $0x8c
8010662e:	e9 05 f6 ff ff       	jmp    80105c38 <alltraps>

80106633 <vector141>:
80106633:	6a 00                	push   $0x0
80106635:	68 8d 00 00 00       	push   $0x8d
8010663a:	e9 f9 f5 ff ff       	jmp    80105c38 <alltraps>

8010663f <vector142>:
8010663f:	6a 00                	push   $0x0
80106641:	68 8e 00 00 00       	push   $0x8e
80106646:	e9 ed f5 ff ff       	jmp    80105c38 <alltraps>

8010664b <vector143>:
8010664b:	6a 00                	push   $0x0
8010664d:	68 8f 00 00 00       	push   $0x8f
80106652:	e9 e1 f5 ff ff       	jmp    80105c38 <alltraps>

80106657 <vector144>:
80106657:	6a 00                	push   $0x0
80106659:	68 90 00 00 00       	push   $0x90
8010665e:	e9 d5 f5 ff ff       	jmp    80105c38 <alltraps>

80106663 <vector145>:
80106663:	6a 00                	push   $0x0
80106665:	68 91 00 00 00       	push   $0x91
8010666a:	e9 c9 f5 ff ff       	jmp    80105c38 <alltraps>

8010666f <vector146>:
8010666f:	6a 00                	push   $0x0
80106671:	68 92 00 00 00       	push   $0x92
80106676:	e9 bd f5 ff ff       	jmp    80105c38 <alltraps>

8010667b <vector147>:
8010667b:	6a 00                	push   $0x0
8010667d:	68 93 00 00 00       	push   $0x93
80106682:	e9 b1 f5 ff ff       	jmp    80105c38 <alltraps>

80106687 <vector148>:
80106687:	6a 00                	push   $0x0
80106689:	68 94 00 00 00       	push   $0x94
8010668e:	e9 a5 f5 ff ff       	jmp    80105c38 <alltraps>

80106693 <vector149>:
80106693:	6a 00                	push   $0x0
80106695:	68 95 00 00 00       	push   $0x95
8010669a:	e9 99 f5 ff ff       	jmp    80105c38 <alltraps>

8010669f <vector150>:
8010669f:	6a 00                	push   $0x0
801066a1:	68 96 00 00 00       	push   $0x96
801066a6:	e9 8d f5 ff ff       	jmp    80105c38 <alltraps>

801066ab <vector151>:
801066ab:	6a 00                	push   $0x0
801066ad:	68 97 00 00 00       	push   $0x97
801066b2:	e9 81 f5 ff ff       	jmp    80105c38 <alltraps>

801066b7 <vector152>:
801066b7:	6a 00                	push   $0x0
801066b9:	68 98 00 00 00       	push   $0x98
801066be:	e9 75 f5 ff ff       	jmp    80105c38 <alltraps>

801066c3 <vector153>:
801066c3:	6a 00                	push   $0x0
801066c5:	68 99 00 00 00       	push   $0x99
801066ca:	e9 69 f5 ff ff       	jmp    80105c38 <alltraps>

801066cf <vector154>:
801066cf:	6a 00                	push   $0x0
801066d1:	68 9a 00 00 00       	push   $0x9a
801066d6:	e9 5d f5 ff ff       	jmp    80105c38 <alltraps>

801066db <vector155>:
801066db:	6a 00                	push   $0x0
801066dd:	68 9b 00 00 00       	push   $0x9b
801066e2:	e9 51 f5 ff ff       	jmp    80105c38 <alltraps>

801066e7 <vector156>:
801066e7:	6a 00                	push   $0x0
801066e9:	68 9c 00 00 00       	push   $0x9c
801066ee:	e9 45 f5 ff ff       	jmp    80105c38 <alltraps>

801066f3 <vector157>:
801066f3:	6a 00                	push   $0x0
801066f5:	68 9d 00 00 00       	push   $0x9d
801066fa:	e9 39 f5 ff ff       	jmp    80105c38 <alltraps>

801066ff <vector158>:
801066ff:	6a 00                	push   $0x0
80106701:	68 9e 00 00 00       	push   $0x9e
80106706:	e9 2d f5 ff ff       	jmp    80105c38 <alltraps>

8010670b <vector159>:
8010670b:	6a 00                	push   $0x0
8010670d:	68 9f 00 00 00       	push   $0x9f
80106712:	e9 21 f5 ff ff       	jmp    80105c38 <alltraps>

80106717 <vector160>:
80106717:	6a 00                	push   $0x0
80106719:	68 a0 00 00 00       	push   $0xa0
8010671e:	e9 15 f5 ff ff       	jmp    80105c38 <alltraps>

80106723 <vector161>:
80106723:	6a 00                	push   $0x0
80106725:	68 a1 00 00 00       	push   $0xa1
8010672a:	e9 09 f5 ff ff       	jmp    80105c38 <alltraps>

8010672f <vector162>:
8010672f:	6a 00                	push   $0x0
80106731:	68 a2 00 00 00       	push   $0xa2
80106736:	e9 fd f4 ff ff       	jmp    80105c38 <alltraps>

8010673b <vector163>:
8010673b:	6a 00                	push   $0x0
8010673d:	68 a3 00 00 00       	push   $0xa3
80106742:	e9 f1 f4 ff ff       	jmp    80105c38 <alltraps>

80106747 <vector164>:
80106747:	6a 00                	push   $0x0
80106749:	68 a4 00 00 00       	push   $0xa4
8010674e:	e9 e5 f4 ff ff       	jmp    80105c38 <alltraps>

80106753 <vector165>:
80106753:	6a 00                	push   $0x0
80106755:	68 a5 00 00 00       	push   $0xa5
8010675a:	e9 d9 f4 ff ff       	jmp    80105c38 <alltraps>

8010675f <vector166>:
8010675f:	6a 00                	push   $0x0
80106761:	68 a6 00 00 00       	push   $0xa6
80106766:	e9 cd f4 ff ff       	jmp    80105c38 <alltraps>

8010676b <vector167>:
8010676b:	6a 00                	push   $0x0
8010676d:	68 a7 00 00 00       	push   $0xa7
80106772:	e9 c1 f4 ff ff       	jmp    80105c38 <alltraps>

80106777 <vector168>:
80106777:	6a 00                	push   $0x0
80106779:	68 a8 00 00 00       	push   $0xa8
8010677e:	e9 b5 f4 ff ff       	jmp    80105c38 <alltraps>

80106783 <vector169>:
80106783:	6a 00                	push   $0x0
80106785:	68 a9 00 00 00       	push   $0xa9
8010678a:	e9 a9 f4 ff ff       	jmp    80105c38 <alltraps>

8010678f <vector170>:
8010678f:	6a 00                	push   $0x0
80106791:	68 aa 00 00 00       	push   $0xaa
80106796:	e9 9d f4 ff ff       	jmp    80105c38 <alltraps>

8010679b <vector171>:
8010679b:	6a 00                	push   $0x0
8010679d:	68 ab 00 00 00       	push   $0xab
801067a2:	e9 91 f4 ff ff       	jmp    80105c38 <alltraps>

801067a7 <vector172>:
801067a7:	6a 00                	push   $0x0
801067a9:	68 ac 00 00 00       	push   $0xac
801067ae:	e9 85 f4 ff ff       	jmp    80105c38 <alltraps>

801067b3 <vector173>:
801067b3:	6a 00                	push   $0x0
801067b5:	68 ad 00 00 00       	push   $0xad
801067ba:	e9 79 f4 ff ff       	jmp    80105c38 <alltraps>

801067bf <vector174>:
801067bf:	6a 00                	push   $0x0
801067c1:	68 ae 00 00 00       	push   $0xae
801067c6:	e9 6d f4 ff ff       	jmp    80105c38 <alltraps>

801067cb <vector175>:
801067cb:	6a 00                	push   $0x0
801067cd:	68 af 00 00 00       	push   $0xaf
801067d2:	e9 61 f4 ff ff       	jmp    80105c38 <alltraps>

801067d7 <vector176>:
801067d7:	6a 00                	push   $0x0
801067d9:	68 b0 00 00 00       	push   $0xb0
801067de:	e9 55 f4 ff ff       	jmp    80105c38 <alltraps>

801067e3 <vector177>:
801067e3:	6a 00                	push   $0x0
801067e5:	68 b1 00 00 00       	push   $0xb1
801067ea:	e9 49 f4 ff ff       	jmp    80105c38 <alltraps>

801067ef <vector178>:
801067ef:	6a 00                	push   $0x0
801067f1:	68 b2 00 00 00       	push   $0xb2
801067f6:	e9 3d f4 ff ff       	jmp    80105c38 <alltraps>

801067fb <vector179>:
801067fb:	6a 00                	push   $0x0
801067fd:	68 b3 00 00 00       	push   $0xb3
80106802:	e9 31 f4 ff ff       	jmp    80105c38 <alltraps>

80106807 <vector180>:
80106807:	6a 00                	push   $0x0
80106809:	68 b4 00 00 00       	push   $0xb4
8010680e:	e9 25 f4 ff ff       	jmp    80105c38 <alltraps>

80106813 <vector181>:
80106813:	6a 00                	push   $0x0
80106815:	68 b5 00 00 00       	push   $0xb5
8010681a:	e9 19 f4 ff ff       	jmp    80105c38 <alltraps>

8010681f <vector182>:
8010681f:	6a 00                	push   $0x0
80106821:	68 b6 00 00 00       	push   $0xb6
80106826:	e9 0d f4 ff ff       	jmp    80105c38 <alltraps>

8010682b <vector183>:
8010682b:	6a 00                	push   $0x0
8010682d:	68 b7 00 00 00       	push   $0xb7
80106832:	e9 01 f4 ff ff       	jmp    80105c38 <alltraps>

80106837 <vector184>:
80106837:	6a 00                	push   $0x0
80106839:	68 b8 00 00 00       	push   $0xb8
8010683e:	e9 f5 f3 ff ff       	jmp    80105c38 <alltraps>

80106843 <vector185>:
80106843:	6a 00                	push   $0x0
80106845:	68 b9 00 00 00       	push   $0xb9
8010684a:	e9 e9 f3 ff ff       	jmp    80105c38 <alltraps>

8010684f <vector186>:
8010684f:	6a 00                	push   $0x0
80106851:	68 ba 00 00 00       	push   $0xba
80106856:	e9 dd f3 ff ff       	jmp    80105c38 <alltraps>

8010685b <vector187>:
8010685b:	6a 00                	push   $0x0
8010685d:	68 bb 00 00 00       	push   $0xbb
80106862:	e9 d1 f3 ff ff       	jmp    80105c38 <alltraps>

80106867 <vector188>:
80106867:	6a 00                	push   $0x0
80106869:	68 bc 00 00 00       	push   $0xbc
8010686e:	e9 c5 f3 ff ff       	jmp    80105c38 <alltraps>

80106873 <vector189>:
80106873:	6a 00                	push   $0x0
80106875:	68 bd 00 00 00       	push   $0xbd
8010687a:	e9 b9 f3 ff ff       	jmp    80105c38 <alltraps>

8010687f <vector190>:
8010687f:	6a 00                	push   $0x0
80106881:	68 be 00 00 00       	push   $0xbe
80106886:	e9 ad f3 ff ff       	jmp    80105c38 <alltraps>

8010688b <vector191>:
8010688b:	6a 00                	push   $0x0
8010688d:	68 bf 00 00 00       	push   $0xbf
80106892:	e9 a1 f3 ff ff       	jmp    80105c38 <alltraps>

80106897 <vector192>:
80106897:	6a 00                	push   $0x0
80106899:	68 c0 00 00 00       	push   $0xc0
8010689e:	e9 95 f3 ff ff       	jmp    80105c38 <alltraps>

801068a3 <vector193>:
801068a3:	6a 00                	push   $0x0
801068a5:	68 c1 00 00 00       	push   $0xc1
801068aa:	e9 89 f3 ff ff       	jmp    80105c38 <alltraps>

801068af <vector194>:
801068af:	6a 00                	push   $0x0
801068b1:	68 c2 00 00 00       	push   $0xc2
801068b6:	e9 7d f3 ff ff       	jmp    80105c38 <alltraps>

801068bb <vector195>:
801068bb:	6a 00                	push   $0x0
801068bd:	68 c3 00 00 00       	push   $0xc3
801068c2:	e9 71 f3 ff ff       	jmp    80105c38 <alltraps>

801068c7 <vector196>:
801068c7:	6a 00                	push   $0x0
801068c9:	68 c4 00 00 00       	push   $0xc4
801068ce:	e9 65 f3 ff ff       	jmp    80105c38 <alltraps>

801068d3 <vector197>:
801068d3:	6a 00                	push   $0x0
801068d5:	68 c5 00 00 00       	push   $0xc5
801068da:	e9 59 f3 ff ff       	jmp    80105c38 <alltraps>

801068df <vector198>:
801068df:	6a 00                	push   $0x0
801068e1:	68 c6 00 00 00       	push   $0xc6
801068e6:	e9 4d f3 ff ff       	jmp    80105c38 <alltraps>

801068eb <vector199>:
801068eb:	6a 00                	push   $0x0
801068ed:	68 c7 00 00 00       	push   $0xc7
801068f2:	e9 41 f3 ff ff       	jmp    80105c38 <alltraps>

801068f7 <vector200>:
801068f7:	6a 00                	push   $0x0
801068f9:	68 c8 00 00 00       	push   $0xc8
801068fe:	e9 35 f3 ff ff       	jmp    80105c38 <alltraps>

80106903 <vector201>:
80106903:	6a 00                	push   $0x0
80106905:	68 c9 00 00 00       	push   $0xc9
8010690a:	e9 29 f3 ff ff       	jmp    80105c38 <alltraps>

8010690f <vector202>:
8010690f:	6a 00                	push   $0x0
80106911:	68 ca 00 00 00       	push   $0xca
80106916:	e9 1d f3 ff ff       	jmp    80105c38 <alltraps>

8010691b <vector203>:
8010691b:	6a 00                	push   $0x0
8010691d:	68 cb 00 00 00       	push   $0xcb
80106922:	e9 11 f3 ff ff       	jmp    80105c38 <alltraps>

80106927 <vector204>:
80106927:	6a 00                	push   $0x0
80106929:	68 cc 00 00 00       	push   $0xcc
8010692e:	e9 05 f3 ff ff       	jmp    80105c38 <alltraps>

80106933 <vector205>:
80106933:	6a 00                	push   $0x0
80106935:	68 cd 00 00 00       	push   $0xcd
8010693a:	e9 f9 f2 ff ff       	jmp    80105c38 <alltraps>

8010693f <vector206>:
8010693f:	6a 00                	push   $0x0
80106941:	68 ce 00 00 00       	push   $0xce
80106946:	e9 ed f2 ff ff       	jmp    80105c38 <alltraps>

8010694b <vector207>:
8010694b:	6a 00                	push   $0x0
8010694d:	68 cf 00 00 00       	push   $0xcf
80106952:	e9 e1 f2 ff ff       	jmp    80105c38 <alltraps>

80106957 <vector208>:
80106957:	6a 00                	push   $0x0
80106959:	68 d0 00 00 00       	push   $0xd0
8010695e:	e9 d5 f2 ff ff       	jmp    80105c38 <alltraps>

80106963 <vector209>:
80106963:	6a 00                	push   $0x0
80106965:	68 d1 00 00 00       	push   $0xd1
8010696a:	e9 c9 f2 ff ff       	jmp    80105c38 <alltraps>

8010696f <vector210>:
8010696f:	6a 00                	push   $0x0
80106971:	68 d2 00 00 00       	push   $0xd2
80106976:	e9 bd f2 ff ff       	jmp    80105c38 <alltraps>

8010697b <vector211>:
8010697b:	6a 00                	push   $0x0
8010697d:	68 d3 00 00 00       	push   $0xd3
80106982:	e9 b1 f2 ff ff       	jmp    80105c38 <alltraps>

80106987 <vector212>:
80106987:	6a 00                	push   $0x0
80106989:	68 d4 00 00 00       	push   $0xd4
8010698e:	e9 a5 f2 ff ff       	jmp    80105c38 <alltraps>

80106993 <vector213>:
80106993:	6a 00                	push   $0x0
80106995:	68 d5 00 00 00       	push   $0xd5
8010699a:	e9 99 f2 ff ff       	jmp    80105c38 <alltraps>

8010699f <vector214>:
8010699f:	6a 00                	push   $0x0
801069a1:	68 d6 00 00 00       	push   $0xd6
801069a6:	e9 8d f2 ff ff       	jmp    80105c38 <alltraps>

801069ab <vector215>:
801069ab:	6a 00                	push   $0x0
801069ad:	68 d7 00 00 00       	push   $0xd7
801069b2:	e9 81 f2 ff ff       	jmp    80105c38 <alltraps>

801069b7 <vector216>:
801069b7:	6a 00                	push   $0x0
801069b9:	68 d8 00 00 00       	push   $0xd8
801069be:	e9 75 f2 ff ff       	jmp    80105c38 <alltraps>

801069c3 <vector217>:
801069c3:	6a 00                	push   $0x0
801069c5:	68 d9 00 00 00       	push   $0xd9
801069ca:	e9 69 f2 ff ff       	jmp    80105c38 <alltraps>

801069cf <vector218>:
801069cf:	6a 00                	push   $0x0
801069d1:	68 da 00 00 00       	push   $0xda
801069d6:	e9 5d f2 ff ff       	jmp    80105c38 <alltraps>

801069db <vector219>:
801069db:	6a 00                	push   $0x0
801069dd:	68 db 00 00 00       	push   $0xdb
801069e2:	e9 51 f2 ff ff       	jmp    80105c38 <alltraps>

801069e7 <vector220>:
801069e7:	6a 00                	push   $0x0
801069e9:	68 dc 00 00 00       	push   $0xdc
801069ee:	e9 45 f2 ff ff       	jmp    80105c38 <alltraps>

801069f3 <vector221>:
801069f3:	6a 00                	push   $0x0
801069f5:	68 dd 00 00 00       	push   $0xdd
801069fa:	e9 39 f2 ff ff       	jmp    80105c38 <alltraps>

801069ff <vector222>:
801069ff:	6a 00                	push   $0x0
80106a01:	68 de 00 00 00       	push   $0xde
80106a06:	e9 2d f2 ff ff       	jmp    80105c38 <alltraps>

80106a0b <vector223>:
80106a0b:	6a 00                	push   $0x0
80106a0d:	68 df 00 00 00       	push   $0xdf
80106a12:	e9 21 f2 ff ff       	jmp    80105c38 <alltraps>

80106a17 <vector224>:
80106a17:	6a 00                	push   $0x0
80106a19:	68 e0 00 00 00       	push   $0xe0
80106a1e:	e9 15 f2 ff ff       	jmp    80105c38 <alltraps>

80106a23 <vector225>:
80106a23:	6a 00                	push   $0x0
80106a25:	68 e1 00 00 00       	push   $0xe1
80106a2a:	e9 09 f2 ff ff       	jmp    80105c38 <alltraps>

80106a2f <vector226>:
80106a2f:	6a 00                	push   $0x0
80106a31:	68 e2 00 00 00       	push   $0xe2
80106a36:	e9 fd f1 ff ff       	jmp    80105c38 <alltraps>

80106a3b <vector227>:
80106a3b:	6a 00                	push   $0x0
80106a3d:	68 e3 00 00 00       	push   $0xe3
80106a42:	e9 f1 f1 ff ff       	jmp    80105c38 <alltraps>

80106a47 <vector228>:
80106a47:	6a 00                	push   $0x0
80106a49:	68 e4 00 00 00       	push   $0xe4
80106a4e:	e9 e5 f1 ff ff       	jmp    80105c38 <alltraps>

80106a53 <vector229>:
80106a53:	6a 00                	push   $0x0
80106a55:	68 e5 00 00 00       	push   $0xe5
80106a5a:	e9 d9 f1 ff ff       	jmp    80105c38 <alltraps>

80106a5f <vector230>:
80106a5f:	6a 00                	push   $0x0
80106a61:	68 e6 00 00 00       	push   $0xe6
80106a66:	e9 cd f1 ff ff       	jmp    80105c38 <alltraps>

80106a6b <vector231>:
80106a6b:	6a 00                	push   $0x0
80106a6d:	68 e7 00 00 00       	push   $0xe7
80106a72:	e9 c1 f1 ff ff       	jmp    80105c38 <alltraps>

80106a77 <vector232>:
80106a77:	6a 00                	push   $0x0
80106a79:	68 e8 00 00 00       	push   $0xe8
80106a7e:	e9 b5 f1 ff ff       	jmp    80105c38 <alltraps>

80106a83 <vector233>:
80106a83:	6a 00                	push   $0x0
80106a85:	68 e9 00 00 00       	push   $0xe9
80106a8a:	e9 a9 f1 ff ff       	jmp    80105c38 <alltraps>

80106a8f <vector234>:
80106a8f:	6a 00                	push   $0x0
80106a91:	68 ea 00 00 00       	push   $0xea
80106a96:	e9 9d f1 ff ff       	jmp    80105c38 <alltraps>

80106a9b <vector235>:
80106a9b:	6a 00                	push   $0x0
80106a9d:	68 eb 00 00 00       	push   $0xeb
80106aa2:	e9 91 f1 ff ff       	jmp    80105c38 <alltraps>

80106aa7 <vector236>:
80106aa7:	6a 00                	push   $0x0
80106aa9:	68 ec 00 00 00       	push   $0xec
80106aae:	e9 85 f1 ff ff       	jmp    80105c38 <alltraps>

80106ab3 <vector237>:
80106ab3:	6a 00                	push   $0x0
80106ab5:	68 ed 00 00 00       	push   $0xed
80106aba:	e9 79 f1 ff ff       	jmp    80105c38 <alltraps>

80106abf <vector238>:
80106abf:	6a 00                	push   $0x0
80106ac1:	68 ee 00 00 00       	push   $0xee
80106ac6:	e9 6d f1 ff ff       	jmp    80105c38 <alltraps>

80106acb <vector239>:
80106acb:	6a 00                	push   $0x0
80106acd:	68 ef 00 00 00       	push   $0xef
80106ad2:	e9 61 f1 ff ff       	jmp    80105c38 <alltraps>

80106ad7 <vector240>:
80106ad7:	6a 00                	push   $0x0
80106ad9:	68 f0 00 00 00       	push   $0xf0
80106ade:	e9 55 f1 ff ff       	jmp    80105c38 <alltraps>

80106ae3 <vector241>:
80106ae3:	6a 00                	push   $0x0
80106ae5:	68 f1 00 00 00       	push   $0xf1
80106aea:	e9 49 f1 ff ff       	jmp    80105c38 <alltraps>

80106aef <vector242>:
80106aef:	6a 00                	push   $0x0
80106af1:	68 f2 00 00 00       	push   $0xf2
80106af6:	e9 3d f1 ff ff       	jmp    80105c38 <alltraps>

80106afb <vector243>:
80106afb:	6a 00                	push   $0x0
80106afd:	68 f3 00 00 00       	push   $0xf3
80106b02:	e9 31 f1 ff ff       	jmp    80105c38 <alltraps>

80106b07 <vector244>:
80106b07:	6a 00                	push   $0x0
80106b09:	68 f4 00 00 00       	push   $0xf4
80106b0e:	e9 25 f1 ff ff       	jmp    80105c38 <alltraps>

80106b13 <vector245>:
80106b13:	6a 00                	push   $0x0
80106b15:	68 f5 00 00 00       	push   $0xf5
80106b1a:	e9 19 f1 ff ff       	jmp    80105c38 <alltraps>

80106b1f <vector246>:
80106b1f:	6a 00                	push   $0x0
80106b21:	68 f6 00 00 00       	push   $0xf6
80106b26:	e9 0d f1 ff ff       	jmp    80105c38 <alltraps>

80106b2b <vector247>:
80106b2b:	6a 00                	push   $0x0
80106b2d:	68 f7 00 00 00       	push   $0xf7
80106b32:	e9 01 f1 ff ff       	jmp    80105c38 <alltraps>

80106b37 <vector248>:
80106b37:	6a 00                	push   $0x0
80106b39:	68 f8 00 00 00       	push   $0xf8
80106b3e:	e9 f5 f0 ff ff       	jmp    80105c38 <alltraps>

80106b43 <vector249>:
80106b43:	6a 00                	push   $0x0
80106b45:	68 f9 00 00 00       	push   $0xf9
80106b4a:	e9 e9 f0 ff ff       	jmp    80105c38 <alltraps>

80106b4f <vector250>:
80106b4f:	6a 00                	push   $0x0
80106b51:	68 fa 00 00 00       	push   $0xfa
80106b56:	e9 dd f0 ff ff       	jmp    80105c38 <alltraps>

80106b5b <vector251>:
80106b5b:	6a 00                	push   $0x0
80106b5d:	68 fb 00 00 00       	push   $0xfb
80106b62:	e9 d1 f0 ff ff       	jmp    80105c38 <alltraps>

80106b67 <vector252>:
80106b67:	6a 00                	push   $0x0
80106b69:	68 fc 00 00 00       	push   $0xfc
80106b6e:	e9 c5 f0 ff ff       	jmp    80105c38 <alltraps>

80106b73 <vector253>:
80106b73:	6a 00                	push   $0x0
80106b75:	68 fd 00 00 00       	push   $0xfd
80106b7a:	e9 b9 f0 ff ff       	jmp    80105c38 <alltraps>

80106b7f <vector254>:
80106b7f:	6a 00                	push   $0x0
80106b81:	68 fe 00 00 00       	push   $0xfe
80106b86:	e9 ad f0 ff ff       	jmp    80105c38 <alltraps>

80106b8b <vector255>:
80106b8b:	6a 00                	push   $0x0
80106b8d:	68 ff 00 00 00       	push   $0xff
80106b92:	e9 a1 f0 ff ff       	jmp    80105c38 <alltraps>
80106b97:	66 90                	xchg   %ax,%ax
80106b99:	66 90                	xchg   %ax,%ax
80106b9b:	66 90                	xchg   %ax,%ax
80106b9d:	66 90                	xchg   %ax,%ax
80106b9f:	90                   	nop

80106ba0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ba7:	c1 ea 16             	shr    $0x16,%edx
{
80106baa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106bab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106bae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106bb1:	8b 1f                	mov    (%edi),%ebx
80106bb3:	f6 c3 01             	test   $0x1,%bl
80106bb6:	74 28                	je     80106be0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106bbe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106bc4:	89 f0                	mov    %esi,%eax
}
80106bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106bc9:	c1 e8 0a             	shr    $0xa,%eax
80106bcc:	25 fc 0f 00 00       	and    $0xffc,%eax
80106bd1:	01 d8                	add    %ebx,%eax
}
80106bd3:	5b                   	pop    %ebx
80106bd4:	5e                   	pop    %esi
80106bd5:	5f                   	pop    %edi
80106bd6:	5d                   	pop    %ebp
80106bd7:	c3                   	ret    
80106bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bdf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106be0:	85 c9                	test   %ecx,%ecx
80106be2:	74 2c                	je     80106c10 <walkpgdir+0x70>
80106be4:	e8 07 bc ff ff       	call   801027f0 <kalloc>
80106be9:	89 c3                	mov    %eax,%ebx
80106beb:	85 c0                	test   %eax,%eax
80106bed:	74 21                	je     80106c10 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106bef:	83 ec 04             	sub    $0x4,%esp
80106bf2:	68 00 10 00 00       	push   $0x1000
80106bf7:	6a 00                	push   $0x0
80106bf9:	50                   	push   %eax
80106bfa:	e8 e1 dc ff ff       	call   801048e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c05:	83 c4 10             	add    $0x10,%esp
80106c08:	83 c8 07             	or     $0x7,%eax
80106c0b:	89 07                	mov    %eax,(%edi)
80106c0d:	eb b5                	jmp    80106bc4 <walkpgdir+0x24>
80106c0f:	90                   	nop
}
80106c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c13:	31 c0                	xor    %eax,%eax
}
80106c15:	5b                   	pop    %ebx
80106c16:	5e                   	pop    %esi
80106c17:	5f                   	pop    %edi
80106c18:	5d                   	pop    %ebp
80106c19:	c3                   	ret    
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c20 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	89 c7                	mov    %eax,%edi
  // if physical address is in huge range,
  if (pa >= HUGE_PAGE_START && pa < HUGE_PAGE_END)
  {
    // huge code
    a = (char*)HUGEPGROUNDDOWN((uint)va);
    last = (char*)HUGEPGROUNDDOWN(((uint)va) + size - 1);
80106c26:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106c2a:	56                   	push   %esi
80106c2b:	53                   	push   %ebx
80106c2c:	83 ec 1c             	sub    $0x1c,%esp
  if (pa >= HUGE_PAGE_START && pa < HUGE_PAGE_END)
80106c2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106c32:	81 e9 00 00 00 1e    	sub    $0x1e000000,%ecx
80106c38:	81 f9 ff ff ff 1f    	cmp    $0x1fffffff,%ecx
80106c3e:	77 50                	ja     80106c90 <mappages+0x70>
    a = (char*)HUGEPGROUNDDOWN((uint)va);
80106c40:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
    last = (char*)HUGEPGROUNDDOWN(((uint)va) + size - 1);
80106c46:	25 00 00 c0 ff       	and    $0xffc00000,%eax
80106c4b:	89 c6                	mov    %eax,%esi
    for(;;)
    {
      pde = &pgdir[PDX(a)];
80106c4d:	89 d3                	mov    %edx,%ebx
      // mapping to a huge page
      *pde = pa | perm | PTE_P | PTE_PS;
80106c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106c52:	0b 45 0c             	or     0xc(%ebp),%eax
      pde = &pgdir[PDX(a)];
80106c55:	c1 eb 16             	shr    $0x16,%ebx
      *pde = pa | perm | PTE_P | PTE_PS;
80106c58:	0c 81                	or     $0x81,%al
    a = (char*)HUGEPGROUNDDOWN((uint)va);
80106c5a:	89 d1                	mov    %edx,%ecx
      *pde = pa | perm | PTE_P | PTE_PS;
80106c5c:	89 04 9f             	mov    %eax,(%edi,%ebx,4)
      if(a == last)
80106c5f:	39 f2                	cmp    %esi,%edx
80106c61:	74 23                	je     80106c86 <mappages+0x66>
80106c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c67:	90                   	nop
      *pde = pa | perm | PTE_P | PTE_PS;
80106c68:	8b 45 08             	mov    0x8(%ebp),%eax
        break;
      a += HUGE_PAGE_SIZE;
80106c6b:	81 c1 00 00 40 00    	add    $0x400000,%ecx
      pde = &pgdir[PDX(a)];
80106c71:	89 cb                	mov    %ecx,%ebx
      *pde = pa | perm | PTE_P | PTE_PS;
80106c73:	01 c8                	add    %ecx,%eax
      pde = &pgdir[PDX(a)];
80106c75:	c1 eb 16             	shr    $0x16,%ebx
      *pde = pa | perm | PTE_P | PTE_PS;
80106c78:	29 d0                	sub    %edx,%eax
80106c7a:	0b 45 0c             	or     0xc(%ebp),%eax
80106c7d:	0c 81                	or     $0x81,%al
80106c7f:	89 04 9f             	mov    %eax,(%edi,%ebx,4)
      if(a == last)
80106c82:	39 ce                	cmp    %ecx,%esi
80106c84:	75 e2                	jne    80106c68 <mappages+0x48>
      a += PGSIZE;
      pa += PGSIZE;
    }
  }
  return 0;
}
80106c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c89:	31 c0                	xor    %eax,%eax
}
80106c8b:	5b                   	pop    %ebx
80106c8c:	5e                   	pop    %esi
80106c8d:	5f                   	pop    %edi
80106c8e:	5d                   	pop    %ebp
80106c8f:	c3                   	ret    
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a = (char*)PGROUNDDOWN((uint)va);
80106c95:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c9e:	8b 45 08             	mov    0x8(%ebp),%eax
    a = (char*)PGROUNDDOWN((uint)va);
80106ca1:	89 d6                	mov    %edx,%esi
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ca3:	29 d0                	sub    %edx,%eax
80106ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ca8:	eb 1e                	jmp    80106cc8 <mappages+0xa8>
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(*pte & PTE_P)
80106cb0:	f6 00 01             	testb  $0x1,(%eax)
80106cb3:	75 38                	jne    80106ced <mappages+0xcd>
      *pte = pa | perm | PTE_P;
80106cb5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106cb8:	83 cb 01             	or     $0x1,%ebx
80106cbb:	89 18                	mov    %ebx,(%eax)
      if(a == last)
80106cbd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106cc0:	74 c4                	je     80106c86 <mappages+0x66>
      a += PGSIZE;
80106cc2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    for(;;){
80106cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ccb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106cd0:	89 f2                	mov    %esi,%edx
80106cd2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106cd5:	89 f8                	mov    %edi,%eax
80106cd7:	e8 c4 fe ff ff       	call   80106ba0 <walkpgdir>
80106cdc:	85 c0                	test   %eax,%eax
80106cde:	75 d0                	jne    80106cb0 <mappages+0x90>
}
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80106ce3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ce8:	5b                   	pop    %ebx
80106ce9:	5e                   	pop    %esi
80106cea:	5f                   	pop    %edi
80106ceb:	5d                   	pop    %ebp
80106cec:	c3                   	ret    
        panic("remap");
80106ced:	83 ec 0c             	sub    $0xc,%esp
80106cf0:	68 ac 81 10 80       	push   $0x801081ac
80106cf5:	e8 86 96 ff ff       	call   80100380 <panic>
80106cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
  */

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106d0c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d12:	83 ec 2c             	sub    $0x2c,%esp
80106d15:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  for(; a  < oldsz; )
80106d18:	39 d3                	cmp    %edx,%ebx
80106d1a:	0f 83 80 00 00 00    	jae    80106da0 <deallocuvm.part.0+0xa0>
80106d20:	89 c6                	mov    %eax,%esi
80106d22:	89 c8                	mov    %ecx,%eax
80106d24:	89 d7                	mov    %edx,%edi
    // check if a points to hugepage
    pde = &pgdir[PDX(a)];
    if (*pde & PTE_PS)
    {
      // is a hugepage
      a = HUGEPGROUNDUP(newsz);
80106d26:	05 ff ff 3f 00       	add    $0x3fffff,%eax
80106d2b:	89 c1                	mov    %eax,%ecx
  pde = &pgdir[PDX(va)];
80106d2d:	c1 e8 16             	shr    $0x16,%eax
      a = HUGEPGROUNDUP(newsz);
80106d30:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
80106d36:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  pde = &pgdir[PDX(va)];
80106d39:	8d 0c 86             	lea    (%esi,%eax,4),%ecx
      pte = walkpgdir(pgdir, (char*)a, 0);
      if(!pte)
        a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
80106d3c:	83 c0 01             	add    $0x1,%eax
80106d3f:	c1 e0 16             	shl    $0x16,%eax
  pde = &pgdir[PDX(va)];
80106d42:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
80106d45:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d48:	eb 3a                	jmp    80106d84 <deallocuvm.part.0+0x84>
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80106d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d53:	8b 18                	mov    (%eax),%ebx
80106d55:	f6 c3 01             	test   $0x1,%bl
80106d58:	74 56                	je     80106db0 <deallocuvm.part.0+0xb0>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d5a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
      if(!pte)
80106d60:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80106d66:	74 48                	je     80106db0 <deallocuvm.part.0+0xb0>
      else if((*pte & PTE_P) != 0)
80106d68:	8b 83 00 00 00 80    	mov    -0x80000000(%ebx),%eax
80106d6e:	a8 01                	test   $0x1,%al
80106d70:	75 76                	jne    80106de8 <deallocuvm.part.0+0xe8>
          panic("khugefree");
        char *v = P2V(pa);
        khugefree(v);
        *pte = 0;
      }
      a += HUGE_PAGE_SIZE; //if freed a hugepage
80106d72:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d75:	8d 98 00 00 40 00    	lea    0x400000(%eax),%ebx
80106d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d7f:	90                   	nop
  for(; a  < oldsz; )
80106d80:	39 df                	cmp    %ebx,%edi
80106d82:	76 1c                	jbe    80106da0 <deallocuvm.part.0+0xa0>
    pde = &pgdir[PDX(a)];
80106d84:	89 da                	mov    %ebx,%edx
80106d86:	c1 ea 16             	shr    $0x16,%edx
    if (*pde & PTE_PS)
80106d89:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106d8c:	a8 80                	test   $0x80,%al
80106d8e:	75 c0                	jne    80106d50 <deallocuvm.part.0+0x50>
  if(*pde & PTE_P){
80106d90:	a8 01                	test   $0x1,%al
80106d92:	75 24                	jne    80106db8 <deallocuvm.part.0+0xb8>
    else
    {
      // is not a hugepage
      pte = walkpgdir(pgdir, (char*)a, 0);
      if(!pte)
        a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d94:	83 c2 01             	add    $0x1,%edx
80106d97:	89 d3                	mov    %edx,%ebx
80106d99:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; )
80106d9c:	39 df                	cmp    %ebx,%edi
80106d9e:	77 e4                	ja     80106d84 <deallocuvm.part.0+0x84>
      a += PGSIZE; // if freed a basepage
    }

  }
  return newsz;
}
80106da0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da6:	5b                   	pop    %ebx
80106da7:	5e                   	pop    %esi
80106da8:	5f                   	pop    %edi
80106da9:	5d                   	pop    %ebp
80106daa:	c3                   	ret    
80106dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106daf:	90                   	nop
80106db0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
      a += HUGE_PAGE_SIZE; //if freed a hugepage
80106db3:	eb cb                	jmp    80106d80 <deallocuvm.part.0+0x80>
80106db5:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106db8:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106dbf:	c1 e9 0a             	shr    $0xa,%ecx
80106dc2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106dc8:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
      if(!pte)
80106dcf:	85 c0                	test   %eax,%eax
80106dd1:	74 c1                	je     80106d94 <deallocuvm.part.0+0x94>
      else if((*pte & PTE_P) != 0){
80106dd3:	8b 10                	mov    (%eax),%edx
80106dd5:	f6 c2 01             	test   $0x1,%dl
80106dd8:	75 46                	jne    80106e20 <deallocuvm.part.0+0x120>
      a += PGSIZE; // if freed a basepage
80106dda:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106de0:	eb 9e                	jmp    80106d80 <deallocuvm.part.0+0x80>
80106de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(pa == 0)
80106de8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ded:	74 62                	je     80106e51 <deallocuvm.part.0+0x151>
        khugefree(v);
80106def:	83 ec 0c             	sub    $0xc,%esp
        char *v = P2V(pa);
80106df2:	05 00 00 00 80       	add    $0x80000000,%eax
        khugefree(v);
80106df7:	50                   	push   %eax
80106df8:	e8 93 b8 ff ff       	call   80102690 <khugefree>
      a += HUGE_PAGE_SIZE; //if freed a hugepage
80106dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e00:	83 c4 10             	add    $0x10,%esp
        *pte = 0;
80106e03:	c7 83 00 00 00 80 00 	movl   $0x0,-0x80000000(%ebx)
80106e0a:	00 00 00 
      a += HUGE_PAGE_SIZE; //if freed a hugepage
80106e0d:	8d 98 00 00 40 00    	lea    0x400000(%eax),%ebx
80106e13:	e9 68 ff ff ff       	jmp    80106d80 <deallocuvm.part.0+0x80>
80106e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1f:	90                   	nop
        if(pa == 0)
80106e20:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e26:	74 36                	je     80106e5e <deallocuvm.part.0+0x15e>
        kfree(v);
80106e28:	83 ec 0c             	sub    $0xc,%esp
        char *v = P2V(pa);
80106e2b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e31:	89 45 dc             	mov    %eax,-0x24(%ebp)
      a += PGSIZE; // if freed a basepage
80106e34:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(v);
80106e3a:	52                   	push   %edx
80106e3b:	e8 90 b6 ff ff       	call   801024d0 <kfree>
        *pte = 0;
80106e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
      a += PGSIZE; // if freed a basepage
80106e43:	83 c4 10             	add    $0x10,%esp
        *pte = 0;
80106e46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106e4c:	e9 2f ff ff ff       	jmp    80106d80 <deallocuvm.part.0+0x80>
          panic("khugefree");
80106e51:	83 ec 0c             	sub    $0xc,%esp
80106e54:	68 31 7b 10 80       	push   $0x80107b31
80106e59:	e8 22 95 ff ff       	call   80100380 <panic>
          panic("kfree");
80106e5e:	83 ec 0c             	sub    $0xc,%esp
80106e61:	68 26 7b 10 80       	push   $0x80107b26
80106e66:	e8 15 95 ff ff       	call   80100380 <panic>
80106e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e6f:	90                   	nop

80106e70 <seginit>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e76:	e8 c5 cc ff ff       	call   80103b40 <cpuid>
  pd[0] = size-1;
80106e7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e8a:	c7 80 78 28 11 80 ff 	movl   $0xffff,-0x7feed788(%eax)
80106e91:	ff 00 00 
80106e94:	c7 80 7c 28 11 80 00 	movl   $0xcf9a00,-0x7feed784(%eax)
80106e9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e9e:	c7 80 80 28 11 80 ff 	movl   $0xffff,-0x7feed780(%eax)
80106ea5:	ff 00 00 
80106ea8:	c7 80 84 28 11 80 00 	movl   $0xcf9200,-0x7feed77c(%eax)
80106eaf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106eb2:	c7 80 88 28 11 80 ff 	movl   $0xffff,-0x7feed778(%eax)
80106eb9:	ff 00 00 
80106ebc:	c7 80 8c 28 11 80 00 	movl   $0xcffa00,-0x7feed774(%eax)
80106ec3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ec6:	c7 80 90 28 11 80 ff 	movl   $0xffff,-0x7feed770(%eax)
80106ecd:	ff 00 00 
80106ed0:	c7 80 94 28 11 80 00 	movl   $0xcff200,-0x7feed76c(%eax)
80106ed7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eda:	05 70 28 11 80       	add    $0x80112870,%eax
  pd[1] = (uint)p;
80106edf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ee3:	c1 e8 10             	shr    $0x10,%eax
80106ee6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106eed:	0f 01 10             	lgdtl  (%eax)
}
80106ef0:	c9                   	leave  
80106ef1:	c3                   	ret    
80106ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f00:	a1 24 56 11 80       	mov    0x80115624,%eax
80106f05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f0a:	0f 22 d8             	mov    %eax,%cr3
}
80106f0d:	c3                   	ret    
80106f0e:	66 90                	xchg   %ax,%ax

80106f10 <switchuvm>:
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
80106f19:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f1c:	85 f6                	test   %esi,%esi
80106f1e:	0f 84 cb 00 00 00    	je     80106fef <switchuvm+0xdf>
  if(p->kstack == 0)
80106f24:	8b 46 0c             	mov    0xc(%esi),%eax
80106f27:	85 c0                	test   %eax,%eax
80106f29:	0f 84 da 00 00 00    	je     80107009 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f2f:	8b 46 08             	mov    0x8(%esi),%eax
80106f32:	85 c0                	test   %eax,%eax
80106f34:	0f 84 c2 00 00 00    	je     80106ffc <switchuvm+0xec>
  pushcli();
80106f3a:	e8 91 d7 ff ff       	call   801046d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f3f:	e8 9c cb ff ff       	call   80103ae0 <mycpu>
80106f44:	89 c3                	mov    %eax,%ebx
80106f46:	e8 95 cb ff ff       	call   80103ae0 <mycpu>
80106f4b:	89 c7                	mov    %eax,%edi
80106f4d:	e8 8e cb ff ff       	call   80103ae0 <mycpu>
80106f52:	83 c7 08             	add    $0x8,%edi
80106f55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f58:	e8 83 cb ff ff       	call   80103ae0 <mycpu>
80106f5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f60:	ba 67 00 00 00       	mov    $0x67,%edx
80106f65:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f6c:	83 c0 08             	add    $0x8,%eax
80106f6f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f76:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f7b:	83 c1 08             	add    $0x8,%ecx
80106f7e:	c1 e8 18             	shr    $0x18,%eax
80106f81:	c1 e9 10             	shr    $0x10,%ecx
80106f84:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f8a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f95:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106fa1:	e8 3a cb ff ff       	call   80103ae0 <mycpu>
80106fa6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fad:	e8 2e cb ff ff       	call   80103ae0 <mycpu>
80106fb2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fb6:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106fb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fbf:	e8 1c cb ff ff       	call   80103ae0 <mycpu>
80106fc4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fc7:	e8 14 cb ff ff       	call   80103ae0 <mycpu>
80106fcc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106fd5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fd8:	8b 46 08             	mov    0x8(%esi),%eax
80106fdb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fe0:	0f 22 d8             	mov    %eax,%cr3
}
80106fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe6:	5b                   	pop    %ebx
80106fe7:	5e                   	pop    %esi
80106fe8:	5f                   	pop    %edi
80106fe9:	5d                   	pop    %ebp
  popcli();
80106fea:	e9 31 d7 ff ff       	jmp    80104720 <popcli>
    panic("switchuvm: no process");
80106fef:	83 ec 0c             	sub    $0xc,%esp
80106ff2:	68 b2 81 10 80       	push   $0x801081b2
80106ff7:	e8 84 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106ffc:	83 ec 0c             	sub    $0xc,%esp
80106fff:	68 dd 81 10 80       	push   $0x801081dd
80107004:	e8 77 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107009:	83 ec 0c             	sub    $0xc,%esp
8010700c:	68 c8 81 10 80       	push   $0x801081c8
80107011:	e8 6a 93 ff ff       	call   80100380 <panic>
80107016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701d:	8d 76 00             	lea    0x0(%esi),%esi

80107020 <inituvm>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
80107026:	83 ec 1c             	sub    $0x1c,%esp
80107029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010702c:	8b 75 08             	mov    0x8(%ebp),%esi
8010702f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107032:	8b 45 10             	mov    0x10(%ebp),%eax
80107035:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(sz >= PGSIZE)
80107038:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010703d:	77 7d                	ja     801070bc <inituvm+0x9c>
  mem = kalloc();
8010703f:	e8 ac b7 ff ff       	call   801027f0 <kalloc>
  memset(mem, 0, PGSIZE);
80107044:	83 ec 04             	sub    $0x4,%esp
80107047:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010704c:	89 c7                	mov    %eax,%edi
  memset(mem, 0, PGSIZE);
8010704e:	6a 00                	push   $0x0
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107050:	8d 9f 00 00 00 80    	lea    -0x80000000(%edi),%ebx
  memset(mem, 0, PGSIZE);
80107056:	50                   	push   %eax
80107057:	e8 84 d8 ff ff       	call   801048e0 <memset>
  if (pa >= HUGE_PAGE_START && pa < HUGE_PAGE_END)
8010705c:	8d 87 00 00 00 62    	lea    0x62000000(%edi),%eax
80107062:	83 c4 10             	add    $0x10,%esp
80107065:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
8010706a:	76 3c                	jbe    801070a8 <inituvm+0x88>
      if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010706c:	31 d2                	xor    %edx,%edx
8010706e:	b9 01 00 00 00       	mov    $0x1,%ecx
80107073:	89 f0                	mov    %esi,%eax
80107075:	e8 26 fb ff ff       	call   80106ba0 <walkpgdir>
8010707a:	85 c0                	test   %eax,%eax
8010707c:	74 0a                	je     80107088 <inituvm+0x68>
      if(*pte & PTE_P)
8010707e:	f6 00 01             	testb  $0x1,(%eax)
80107081:	75 2c                	jne    801070af <inituvm+0x8f>
      *pte = pa | perm | PTE_P;
80107083:	83 cb 07             	or     $0x7,%ebx
80107086:	89 18                	mov    %ebx,(%eax)
  memmove(mem, init, sz);
80107088:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010708b:	89 7d 08             	mov    %edi,0x8(%ebp)
8010708e:	89 45 10             	mov    %eax,0x10(%ebp)
80107091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107094:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709a:	5b                   	pop    %ebx
8010709b:	5e                   	pop    %esi
8010709c:	5f                   	pop    %edi
8010709d:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010709e:	e9 dd d8 ff ff       	jmp    80104980 <memmove>
801070a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070a7:	90                   	nop
      *pde = pa | perm | PTE_P | PTE_PS;
801070a8:	80 cb 87             	or     $0x87,%bl
801070ab:	89 1e                	mov    %ebx,(%esi)
      if(a == last)
801070ad:	eb d9                	jmp    80107088 <inituvm+0x68>
        panic("remap");
801070af:	83 ec 0c             	sub    $0xc,%esp
801070b2:	68 ac 81 10 80       	push   $0x801081ac
801070b7:	e8 c4 92 ff ff       	call   80100380 <panic>
    panic("inituvm: more than a page");
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	68 f1 81 10 80       	push   $0x801081f1
801070c4:	e8 b7 92 ff ff       	call   80100380 <panic>
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <loaduvm>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
801070d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070dc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801070df:	a9 ff 0f 00 00       	test   $0xfff,%eax
801070e4:	0f 85 bb 00 00 00    	jne    801071a5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801070ea:	01 f0                	add    %esi,%eax
801070ec:	89 f3                	mov    %esi,%ebx
801070ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070f1:	8b 45 14             	mov    0x14(%ebp),%eax
801070f4:	01 f0                	add    %esi,%eax
801070f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801070f9:	85 f6                	test   %esi,%esi
801070fb:	0f 84 87 00 00 00    	je     80107188 <loaduvm+0xb8>
80107101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010710b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010710e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107110:	89 c2                	mov    %eax,%edx
80107112:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107115:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107118:	f6 c2 01             	test   $0x1,%dl
8010711b:	75 13                	jne    80107130 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010711d:	83 ec 0c             	sub    $0xc,%esp
80107120:	68 0b 82 10 80       	push   $0x8010820b
80107125:	e8 56 92 ff ff       	call   80100380 <panic>
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107130:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107133:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107139:	25 fc 0f 00 00       	and    $0xffc,%eax
8010713e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107145:	85 c0                	test   %eax,%eax
80107147:	74 d4                	je     8010711d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107149:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010714b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010714e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107153:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107158:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010715e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107161:	29 d9                	sub    %ebx,%ecx
80107163:	05 00 00 00 80       	add    $0x80000000,%eax
80107168:	57                   	push   %edi
80107169:	51                   	push   %ecx
8010716a:	50                   	push   %eax
8010716b:	ff 75 10             	push   0x10(%ebp)
8010716e:	e8 2d a9 ff ff       	call   80101aa0 <readi>
80107173:	83 c4 10             	add    $0x10,%esp
80107176:	39 f8                	cmp    %edi,%eax
80107178:	75 1e                	jne    80107198 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010717a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107180:	89 f0                	mov    %esi,%eax
80107182:	29 d8                	sub    %ebx,%eax
80107184:	39 c6                	cmp    %eax,%esi
80107186:	77 80                	ja     80107108 <loaduvm+0x38>
}
80107188:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010718b:	31 c0                	xor    %eax,%eax
}
8010718d:	5b                   	pop    %ebx
8010718e:	5e                   	pop    %esi
8010718f:	5f                   	pop    %edi
80107190:	5d                   	pop    %ebp
80107191:	c3                   	ret    
80107192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107198:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010719b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071a0:	5b                   	pop    %ebx
801071a1:	5e                   	pop    %esi
801071a2:	5f                   	pop    %edi
801071a3:	5d                   	pop    %ebp
801071a4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801071a5:	83 ec 0c             	sub    $0xc,%esp
801071a8:	68 c8 82 10 80       	push   $0x801082c8
801071ad:	e8 ce 91 ff ff       	call   80100380 <panic>
801071b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071c0 <allocuvm>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071c9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801071cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071d2:	85 c0                	test   %eax,%eax
801071d4:	0f 88 b6 00 00 00    	js     80107290 <allocuvm+0xd0>
  if(newsz < oldsz)
801071da:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801071dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801071e0:	0f 82 9a 00 00 00    	jb     80107280 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801071e6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801071ec:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801071f2:	39 75 10             	cmp    %esi,0x10(%ebp)
801071f5:	77 44                	ja     8010723b <allocuvm+0x7b>
801071f7:	e9 87 00 00 00       	jmp    80107283 <allocuvm+0xc3>
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107200:	83 ec 04             	sub    $0x4,%esp
80107203:	68 00 10 00 00       	push   $0x1000
80107208:	6a 00                	push   $0x0
8010720a:	50                   	push   %eax
8010720b:	e8 d0 d6 ff ff       	call   801048e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107210:	58                   	pop    %eax
80107211:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107217:	5a                   	pop    %edx
80107218:	6a 06                	push   $0x6
8010721a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010721f:	89 f2                	mov    %esi,%edx
80107221:	50                   	push   %eax
80107222:	89 f8                	mov    %edi,%eax
80107224:	e8 f7 f9 ff ff       	call   80106c20 <mappages>
80107229:	83 c4 10             	add    $0x10,%esp
8010722c:	85 c0                	test   %eax,%eax
8010722e:	78 78                	js     801072a8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107230:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107236:	39 75 10             	cmp    %esi,0x10(%ebp)
80107239:	76 48                	jbe    80107283 <allocuvm+0xc3>
    mem = kalloc();
8010723b:	e8 b0 b5 ff ff       	call   801027f0 <kalloc>
80107240:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107242:	85 c0                	test   %eax,%eax
80107244:	75 ba                	jne    80107200 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	68 29 82 10 80       	push   $0x80108229
8010724e:	e8 4d 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107253:	8b 45 0c             	mov    0xc(%ebp),%eax
80107256:	83 c4 10             	add    $0x10,%esp
80107259:	39 45 10             	cmp    %eax,0x10(%ebp)
8010725c:	74 32                	je     80107290 <allocuvm+0xd0>
8010725e:	8b 55 10             	mov    0x10(%ebp),%edx
80107261:	89 c1                	mov    %eax,%ecx
80107263:	89 f8                	mov    %edi,%eax
80107265:	e8 96 fa ff ff       	call   80106d00 <deallocuvm.part.0>
      return 0;
8010726a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107274:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107277:	5b                   	pop    %ebx
80107278:	5e                   	pop    %esi
80107279:	5f                   	pop    %edi
8010727a:	5d                   	pop    %ebp
8010727b:	c3                   	ret    
8010727c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107280:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107286:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107289:	5b                   	pop    %ebx
8010728a:	5e                   	pop    %esi
8010728b:	5f                   	pop    %edi
8010728c:	5d                   	pop    %ebp
8010728d:	c3                   	ret    
8010728e:	66 90                	xchg   %ax,%ax
    return 0;
80107290:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010729a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010729d:	5b                   	pop    %ebx
8010729e:	5e                   	pop    %esi
8010729f:	5f                   	pop    %edi
801072a0:	5d                   	pop    %ebp
801072a1:	c3                   	ret    
801072a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072a8:	83 ec 0c             	sub    $0xc,%esp
801072ab:	68 41 82 10 80       	push   $0x80108241
801072b0:	e8 eb 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072b8:	83 c4 10             	add    $0x10,%esp
801072bb:	39 45 10             	cmp    %eax,0x10(%ebp)
801072be:	74 0c                	je     801072cc <allocuvm+0x10c>
801072c0:	8b 55 10             	mov    0x10(%ebp),%edx
801072c3:	89 c1                	mov    %eax,%ecx
801072c5:	89 f8                	mov    %edi,%eax
801072c7:	e8 34 fa ff ff       	call   80106d00 <deallocuvm.part.0>
      kfree(mem);
801072cc:	83 ec 0c             	sub    $0xc,%esp
801072cf:	53                   	push   %ebx
801072d0:	e8 fb b1 ff ff       	call   801024d0 <kfree>
      return 0;
801072d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072dc:	83 c4 10             	add    $0x10,%esp
}
801072df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e5:	5b                   	pop    %ebx
801072e6:	5e                   	pop    %esi
801072e7:	5f                   	pop    %edi
801072e8:	5d                   	pop    %ebp
801072e9:	c3                   	ret    
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072f0 <allochugeuvm>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 0c             	sub    $0xc,%esp
  if(newsz < oldsz)
801072f9:	8b 45 0c             	mov    0xc(%ebp),%eax
{
801072fc:	8b 7d 08             	mov    0x8(%ebp),%edi
    return oldsz;
801072ff:	89 c3                	mov    %eax,%ebx
  if(newsz < oldsz)
80107301:	39 45 10             	cmp    %eax,0x10(%ebp)
80107304:	0f 82 8f 00 00 00    	jb     80107399 <allochugeuvm+0xa9>
  a = HUGEPGROUNDUP(oldsz);
8010730a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010730d:	8d b0 ff ff 3f 00    	lea    0x3fffff(%eax),%esi
80107313:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
  for(; a < newsz; a += HUGE_PAGE_SIZE){
80107319:	39 75 10             	cmp    %esi,0x10(%ebp)
8010731c:	77 4c                	ja     8010736a <allochugeuvm+0x7a>
8010731e:	e9 85 00 00 00       	jmp    801073a8 <allochugeuvm+0xb8>
80107323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107327:	90                   	nop
    memset(mem, 0, HUGE_PAGE_SIZE);
80107328:	83 ec 04             	sub    $0x4,%esp
8010732b:	68 00 00 40 00       	push   $0x400000
80107330:	6a 00                	push   $0x0
80107332:	50                   	push   %eax
80107333:	e8 a8 d5 ff ff       	call   801048e0 <memset>
    if(mappages(pgdir, (char*)a + HUGE_VA_OFFSET, HUGE_PAGE_SIZE, V2P(mem), PTE_PS|PTE_W|PTE_U) < 0){
80107338:	58                   	pop    %eax
80107339:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010733f:	59                   	pop    %ecx
80107340:	68 86 00 00 00       	push   $0x86
80107345:	8d 96 00 00 00 1e    	lea    0x1e000000(%esi),%edx
8010734b:	b9 00 00 40 00       	mov    $0x400000,%ecx
80107350:	50                   	push   %eax
80107351:	89 f8                	mov    %edi,%eax
80107353:	e8 c8 f8 ff ff       	call   80106c20 <mappages>
80107358:	83 c4 10             	add    $0x10,%esp
8010735b:	85 c0                	test   %eax,%eax
8010735d:	78 59                	js     801073b8 <allochugeuvm+0xc8>
  for(; a < newsz; a += HUGE_PAGE_SIZE){
8010735f:	81 c6 00 00 40 00    	add    $0x400000,%esi
80107365:	39 75 10             	cmp    %esi,0x10(%ebp)
80107368:	76 3e                	jbe    801073a8 <allochugeuvm+0xb8>
    mem = khugealloc();
8010736a:	e8 f1 b4 ff ff       	call   80102860 <khugealloc>
8010736f:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107371:	85 c0                	test   %eax,%eax
80107373:	75 b3                	jne    80107328 <allochugeuvm+0x38>
      cprintf("allochugeuvm out of memory\n");
80107375:	83 ec 0c             	sub    $0xc,%esp
80107378:	68 5d 82 10 80       	push   $0x8010825d
8010737d:	e8 1e 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107382:	8b 45 0c             	mov    0xc(%ebp),%eax
80107385:	83 c4 10             	add    $0x10,%esp
80107388:	39 45 10             	cmp    %eax,0x10(%ebp)
8010738b:	74 0c                	je     80107399 <allochugeuvm+0xa9>
8010738d:	8b 55 10             	mov    0x10(%ebp),%edx
80107390:	89 c1                	mov    %eax,%ecx
80107392:	89 f8                	mov    %edi,%eax
80107394:	e8 67 f9 ff ff       	call   80106d00 <deallocuvm.part.0>
}
80107399:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010739c:	89 d8                	mov    %ebx,%eax
8010739e:	5b                   	pop    %ebx
8010739f:	5e                   	pop    %esi
801073a0:	5f                   	pop    %edi
801073a1:	5d                   	pop    %ebp
801073a2:	c3                   	ret    
801073a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073a7:	90                   	nop
  return newsz;
801073a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
}
801073ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ae:	89 d8                	mov    %ebx,%eax
801073b0:	5b                   	pop    %ebx
801073b1:	5e                   	pop    %esi
801073b2:	5f                   	pop    %edi
801073b3:	5d                   	pop    %ebp
801073b4:	c3                   	ret    
801073b5:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allochugeuvm out of memory (2)\n");
801073b8:	83 ec 0c             	sub    $0xc,%esp
801073bb:	68 ec 82 10 80       	push   $0x801082ec
801073c0:	e8 db 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801073c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801073c8:	83 c4 10             	add    $0x10,%esp
801073cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801073ce:	74 0c                	je     801073dc <allochugeuvm+0xec>
801073d0:	8b 55 10             	mov    0x10(%ebp),%edx
801073d3:	89 c1                	mov    %eax,%ecx
801073d5:	89 f8                	mov    %edi,%eax
801073d7:	e8 24 f9 ff ff       	call   80106d00 <deallocuvm.part.0>
      kfree(mem);
801073dc:	83 ec 0c             	sub    $0xc,%esp
801073df:	53                   	push   %ebx
      return 0;
801073e0:	31 db                	xor    %ebx,%ebx
      kfree(mem);
801073e2:	e8 e9 b0 ff ff       	call   801024d0 <kfree>
      return 0;
801073e7:	83 c4 10             	add    $0x10,%esp
}
801073ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ed:	89 d8                	mov    %ebx,%eax
801073ef:	5b                   	pop    %ebx
801073f0:	5e                   	pop    %esi
801073f1:	5f                   	pop    %edi
801073f2:	5d                   	pop    %ebp
801073f3:	c3                   	ret    
801073f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073ff:	90                   	nop

80107400 <deallocuvm>:
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	8b 55 0c             	mov    0xc(%ebp),%edx
80107406:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107409:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010740c:	39 d1                	cmp    %edx,%ecx
8010740e:	73 10                	jae    80107420 <deallocuvm+0x20>
}
80107410:	5d                   	pop    %ebp
80107411:	e9 ea f8 ff ff       	jmp    80106d00 <deallocuvm.part.0>
80107416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010741d:	8d 76 00             	lea    0x0(%esi),%esi
80107420:	89 d0                	mov    %edx,%eax
80107422:	5d                   	pop    %ebp
80107423:	c3                   	ret    
80107424:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010742b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010742f:	90                   	nop

80107430 <deallochugeuvm>:
// TODO: implement this
// part 2
// I havent touched this, only copy paste
int
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 0c             	sub    $0xc,%esp
80107439:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010743c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
8010743f:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
80107441:	39 7d 10             	cmp    %edi,0x10(%ebp)
80107444:	73 32                	jae    80107478 <deallochugeuvm+0x48>

  a = HUGEPGROUNDUP(newsz);
80107446:	8b 45 10             	mov    0x10(%ebp),%eax
80107449:	8d b0 ff ff 3f 00    	lea    0x3fffff(%eax),%esi
8010744f:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
80107455:	8d 76 00             	lea    0x0(%esi),%esi
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80107458:	39 f7                	cmp    %esi,%edi
8010745a:	76 19                	jbe    80107475 <deallochugeuvm+0x45>
  pde = &pgdir[PDX(va)];
8010745c:	89 f2                	mov    %esi,%edx
8010745e:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107461:	8b 1c 91             	mov    (%ecx,%edx,4),%ebx
80107464:	f6 c3 01             	test   $0x1,%bl
80107467:	75 17                	jne    80107480 <deallochugeuvm+0x50>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
80107469:	83 c2 01             	add    $0x1,%edx
8010746c:	89 d6                	mov    %edx,%esi
8010746e:	c1 e6 16             	shl    $0x16,%esi
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80107471:	39 f7                	cmp    %esi,%edi
80107473:	77 e7                	ja     8010745c <deallochugeuvm+0x2c>
      char *v = P2V(pa);
      khugefree(v);
      *pte = 0;
    }
  }
  return newsz;
80107475:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010747b:	5b                   	pop    %ebx
8010747c:	5e                   	pop    %esi
8010747d:	5f                   	pop    %edi
8010747e:	5d                   	pop    %ebp
8010747f:	c3                   	ret    
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107480:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(!pte)
80107486:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
8010748c:	74 db                	je     80107469 <deallochugeuvm+0x39>
    else if((*pte & PTE_P) != 0){
8010748e:	8b 93 00 00 00 80    	mov    -0x80000000(%ebx),%edx
80107494:	f6 c2 01             	test   $0x1,%dl
80107497:	75 0f                	jne    801074a8 <deallochugeuvm+0x78>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80107499:	81 c6 00 00 40 00    	add    $0x400000,%esi
8010749f:	eb b7                	jmp    80107458 <deallochugeuvm+0x28>
801074a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801074a8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801074ae:	74 2d                	je     801074dd <deallochugeuvm+0xad>
      khugefree(v);
801074b0:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801074b3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801074b9:	89 4d 08             	mov    %ecx,0x8(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
801074bc:	81 c6 00 00 40 00    	add    $0x400000,%esi
      khugefree(v);
801074c2:	52                   	push   %edx
801074c3:	e8 c8 b1 ff ff       	call   80102690 <khugefree>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
801074c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074cb:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801074ce:	c7 83 00 00 00 80 00 	movl   $0x0,-0x80000000(%ebx)
801074d5:	00 00 00 
801074d8:	e9 7b ff ff ff       	jmp    80107458 <deallochugeuvm+0x28>
        panic("khugefree");
801074dd:	83 ec 0c             	sub    $0xc,%esp
801074e0:	68 31 7b 10 80       	push   $0x80107b31
801074e5:	e8 96 8e ff ff       	call   80100380 <panic>
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074f0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 0c             	sub    $0xc,%esp
801074f9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801074fc:	85 f6                	test   %esi,%esi
801074fe:	74 5d                	je     8010755d <freevm+0x6d>
  if(newsz >= oldsz)
80107500:	31 c9                	xor    %ecx,%ecx
80107502:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107507:	89 f0                	mov    %esi,%eax
80107509:	89 f3                	mov    %esi,%ebx
8010750b:	e8 f0 f7 ff ff       	call   80106d00 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);

  for(i = 0; i < NPDENTRIES; i++){
80107510:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107516:	eb 0f                	jmp    80107527 <freevm+0x37>
80107518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751f:	90                   	nop
80107520:	83 c3 04             	add    $0x4,%ebx
80107523:	39 fb                	cmp    %edi,%ebx
80107525:	74 27                	je     8010754e <freevm+0x5e>
    if(pgdir[i] & PTE_P){
80107527:	8b 03                	mov    (%ebx),%eax
80107529:	a8 01                	test   $0x1,%al
8010752b:	74 f3                	je     80107520 <freevm+0x30>
      //check if huge page
      if (pgdir[i] & PTE_PS)
8010752d:	a8 80                	test   $0x80,%al
8010752f:	75 ef                	jne    80107520 <freevm+0x30>
      {
      }
      else
      {
        char * v = P2V(PTE_ADDR(pgdir[i]));
80107531:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        kfree(v);
80107536:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107539:	83 c3 04             	add    $0x4,%ebx
        char * v = P2V(PTE_ADDR(pgdir[i]));
8010753c:	05 00 00 00 80       	add    $0x80000000,%eax
        kfree(v);
80107541:	50                   	push   %eax
80107542:	e8 89 af ff ff       	call   801024d0 <kfree>
80107547:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010754a:	39 fb                	cmp    %edi,%ebx
8010754c:	75 d9                	jne    80107527 <freevm+0x37>
      }
    }
  }
  kfree((char*)pgdir);
8010754e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107554:	5b                   	pop    %ebx
80107555:	5e                   	pop    %esi
80107556:	5f                   	pop    %edi
80107557:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107558:	e9 73 af ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
8010755d:	83 ec 0c             	sub    $0xc,%esp
80107560:	68 79 82 10 80       	push   $0x80108279
80107565:	e8 16 8e ff ff       	call   80100380 <panic>
8010756a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107570 <setupkvm>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	56                   	push   %esi
80107574:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107575:	e8 76 b2 ff ff       	call   801027f0 <kalloc>
8010757a:	89 c6                	mov    %eax,%esi
8010757c:	85 c0                	test   %eax,%eax
8010757e:	74 42                	je     801075c2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107580:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107583:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107588:	68 00 10 00 00       	push   $0x1000
8010758d:	6a 00                	push   $0x0
8010758f:	50                   	push   %eax
80107590:	e8 4b d3 ff ff       	call   801048e0 <memset>
80107595:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107598:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010759b:	83 ec 08             	sub    $0x8,%esp
8010759e:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075a1:	ff 73 0c             	push   0xc(%ebx)
801075a4:	8b 13                	mov    (%ebx),%edx
801075a6:	50                   	push   %eax
801075a7:	29 c1                	sub    %eax,%ecx
801075a9:	89 f0                	mov    %esi,%eax
801075ab:	e8 70 f6 ff ff       	call   80106c20 <mappages>
801075b0:	83 c4 10             	add    $0x10,%esp
801075b3:	85 c0                	test   %eax,%eax
801075b5:	78 19                	js     801075d0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075b7:	83 c3 10             	add    $0x10,%ebx
801075ba:	81 fb 70 b4 10 80    	cmp    $0x8010b470,%ebx
801075c0:	75 d6                	jne    80107598 <setupkvm+0x28>
}
801075c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075c5:	89 f0                	mov    %esi,%eax
801075c7:	5b                   	pop    %ebx
801075c8:	5e                   	pop    %esi
801075c9:	5d                   	pop    %ebp
801075ca:	c3                   	ret    
801075cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075cf:	90                   	nop
      freevm(pgdir);
801075d0:	83 ec 0c             	sub    $0xc,%esp
801075d3:	56                   	push   %esi
      return 0;
801075d4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801075d6:	e8 15 ff ff ff       	call   801074f0 <freevm>
      return 0;
801075db:	83 c4 10             	add    $0x10,%esp
}
801075de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075e1:	89 f0                	mov    %esi,%eax
801075e3:	5b                   	pop    %ebx
801075e4:	5e                   	pop    %esi
801075e5:	5d                   	pop    %ebp
801075e6:	c3                   	ret    
801075e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ee:	66 90                	xchg   %ax,%ax

801075f0 <kvmalloc>:
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801075f6:	e8 75 ff ff ff       	call   80107570 <setupkvm>
801075fb:	a3 24 56 11 80       	mov    %eax,0x80115624
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107600:	05 00 00 00 80       	add    $0x80000000,%eax
80107605:	0f 22 d8             	mov    %eax,%cr3
}
80107608:	c9                   	leave  
80107609:	c3                   	ret    
8010760a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107610 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	83 ec 08             	sub    $0x8,%esp
80107616:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107619:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010761c:	89 c1                	mov    %eax,%ecx
8010761e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107621:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107624:	f6 c2 01             	test   $0x1,%dl
80107627:	75 17                	jne    80107640 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107629:	83 ec 0c             	sub    $0xc,%esp
8010762c:	68 8a 82 10 80       	push   $0x8010828a
80107631:	e8 4a 8d ff ff       	call   80100380 <panic>
80107636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010763d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107640:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107643:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107649:	25 fc 0f 00 00       	and    $0xffc,%eax
8010764e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107655:	85 c0                	test   %eax,%eax
80107657:	74 d0                	je     80107629 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107659:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010765c:	c9                   	leave  
8010765d:	c3                   	ret    
8010765e:	66 90                	xchg   %ax,%ax

80107660 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107669:	e8 02 ff ff ff       	call   80107570 <setupkvm>
8010766e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107671:	85 c0                	test   %eax,%eax
80107673:	0f 84 bd 00 00 00    	je     80107736 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107679:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010767c:	85 c9                	test   %ecx,%ecx
8010767e:	0f 84 b2 00 00 00    	je     80107736 <copyuvm+0xd6>
80107684:	31 f6                	xor    %esi,%esi
80107686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107690:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107693:	89 f0                	mov    %esi,%eax
80107695:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107698:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010769b:	a8 01                	test   $0x1,%al
8010769d:	75 11                	jne    801076b0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010769f:	83 ec 0c             	sub    $0xc,%esp
801076a2:	68 94 82 10 80       	push   $0x80108294
801076a7:	e8 d4 8c ff ff       	call   80100380 <panic>
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801076b0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801076b7:	c1 ea 0a             	shr    $0xa,%edx
801076ba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801076c0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076c7:	85 c0                	test   %eax,%eax
801076c9:	74 d4                	je     8010769f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801076cb:	8b 00                	mov    (%eax),%eax
801076cd:	a8 01                	test   $0x1,%al
801076cf:	0f 84 9f 00 00 00    	je     80107774 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801076d5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801076d7:	25 ff 0f 00 00       	and    $0xfff,%eax
801076dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801076df:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801076e5:	e8 06 b1 ff ff       	call   801027f0 <kalloc>
801076ea:	89 c3                	mov    %eax,%ebx
801076ec:	85 c0                	test   %eax,%eax
801076ee:	74 64                	je     80107754 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801076f0:	83 ec 04             	sub    $0x4,%esp
801076f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801076f9:	68 00 10 00 00       	push   $0x1000
801076fe:	57                   	push   %edi
801076ff:	50                   	push   %eax
80107700:	e8 7b d2 ff ff       	call   80104980 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107705:	58                   	pop    %eax
80107706:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010770c:	5a                   	pop    %edx
8010770d:	ff 75 e4             	push   -0x1c(%ebp)
80107710:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107715:	89 f2                	mov    %esi,%edx
80107717:	50                   	push   %eax
80107718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010771b:	e8 00 f5 ff ff       	call   80106c20 <mappages>
80107720:	83 c4 10             	add    $0x10,%esp
80107723:	85 c0                	test   %eax,%eax
80107725:	78 21                	js     80107748 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107727:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010772d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107730:	0f 87 5a ff ff ff    	ja     80107690 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107736:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107739:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010773c:	5b                   	pop    %ebx
8010773d:	5e                   	pop    %esi
8010773e:	5f                   	pop    %edi
8010773f:	5d                   	pop    %ebp
80107740:	c3                   	ret    
80107741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107748:	83 ec 0c             	sub    $0xc,%esp
8010774b:	53                   	push   %ebx
8010774c:	e8 7f ad ff ff       	call   801024d0 <kfree>
      goto bad;
80107751:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107754:	83 ec 0c             	sub    $0xc,%esp
80107757:	ff 75 e0             	push   -0x20(%ebp)
8010775a:	e8 91 fd ff ff       	call   801074f0 <freevm>
  return 0;
8010775f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107766:	83 c4 10             	add    $0x10,%esp
}
80107769:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010776c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010776f:	5b                   	pop    %ebx
80107770:	5e                   	pop    %esi
80107771:	5f                   	pop    %edi
80107772:	5d                   	pop    %ebp
80107773:	c3                   	ret    
      panic("copyuvm: page not present");
80107774:	83 ec 0c             	sub    $0xc,%esp
80107777:	68 ae 82 10 80       	push   $0x801082ae
8010777c:	e8 ff 8b ff ff       	call   80100380 <panic>
80107781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778f:	90                   	nop

80107790 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107796:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107799:	89 c1                	mov    %eax,%ecx
8010779b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010779e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801077a1:	f6 c2 01             	test   $0x1,%dl
801077a4:	0f 84 00 01 00 00    	je     801078aa <uva2ka.cold>
  return &pgtab[PTX(va)];
801077aa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077ad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801077b3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801077b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801077b9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801077c0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801077c7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077ca:	05 00 00 00 80       	add    $0x80000000,%eax
801077cf:	83 fa 05             	cmp    $0x5,%edx
801077d2:	ba 00 00 00 00       	mov    $0x0,%edx
801077d7:	0f 45 c2             	cmovne %edx,%eax
}
801077da:	c3                   	ret    
801077db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077df:	90                   	nop

801077e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
801077e6:	83 ec 0c             	sub    $0xc,%esp
801077e9:	8b 75 14             	mov    0x14(%ebp),%esi
801077ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801077ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077f2:	85 f6                	test   %esi,%esi
801077f4:	75 51                	jne    80107847 <copyout+0x67>
801077f6:	e9 a5 00 00 00       	jmp    801078a0 <copyout+0xc0>
801077fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ff:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107800:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107806:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010780c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107812:	74 75                	je     80107889 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107814:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107816:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107819:	29 c3                	sub    %eax,%ebx
8010781b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107821:	39 f3                	cmp    %esi,%ebx
80107823:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107826:	29 f8                	sub    %edi,%eax
80107828:	83 ec 04             	sub    $0x4,%esp
8010782b:	01 c1                	add    %eax,%ecx
8010782d:	53                   	push   %ebx
8010782e:	52                   	push   %edx
8010782f:	51                   	push   %ecx
80107830:	e8 4b d1 ff ff       	call   80104980 <memmove>
    len -= n;
    buf += n;
80107835:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107838:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010783e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107841:	01 da                	add    %ebx,%edx
  while(len > 0){
80107843:	29 de                	sub    %ebx,%esi
80107845:	74 59                	je     801078a0 <copyout+0xc0>
  if(*pde & PTE_P){
80107847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010784a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010784c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010784e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107851:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107857:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010785a:	f6 c1 01             	test   $0x1,%cl
8010785d:	0f 84 4e 00 00 00    	je     801078b1 <copyout.cold>
  return &pgtab[PTX(va)];
80107863:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107865:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010786b:	c1 eb 0c             	shr    $0xc,%ebx
8010786e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107874:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010787b:	89 d9                	mov    %ebx,%ecx
8010787d:	83 e1 05             	and    $0x5,%ecx
80107880:	83 f9 05             	cmp    $0x5,%ecx
80107883:	0f 84 77 ff ff ff    	je     80107800 <copyout+0x20>
  }
  return 0;
}
80107889:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010788c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107891:	5b                   	pop    %ebx
80107892:	5e                   	pop    %esi
80107893:	5f                   	pop    %edi
80107894:	5d                   	pop    %ebp
80107895:	c3                   	ret    
80107896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789d:	8d 76 00             	lea    0x0(%esi),%esi
801078a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078a3:	31 c0                	xor    %eax,%eax
}
801078a5:	5b                   	pop    %ebx
801078a6:	5e                   	pop    %esi
801078a7:	5f                   	pop    %edi
801078a8:	5d                   	pop    %ebp
801078a9:	c3                   	ret    

801078aa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801078aa:	a1 00 00 00 00       	mov    0x0,%eax
801078af:	0f 0b                	ud2    

801078b1 <copyout.cold>:
801078b1:	a1 00 00 00 00       	mov    0x0,%eax
801078b6:	0f 0b                	ud2    
