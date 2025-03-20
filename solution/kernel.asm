
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
8010002d:	b8 10 32 10 80       	mov    $0x80103210,%eax
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
8010004c:	68 40 77 10 80       	push   $0x80107740
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 b5 45 00 00       	call   80104610 <initlock>
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
80100092:	68 47 77 10 80       	push   $0x80107747
80100097:	50                   	push   %eax
80100098:	e8 43 44 00 00       	call   801044e0 <initsleeplock>
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
801000e4:	e8 f7 46 00 00       	call   801047e0 <acquire>
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
80100162:	e8 19 46 00 00       	call   80104780 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 43 00 00       	call   80104520 <acquiresleep>
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
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
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
801001a1:	68 4e 77 10 80       	push   $0x8010774e
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
801001be:	e8 fd 43 00 00       	call   801045c0 <holdingsleep>
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
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 77 10 80       	push   $0x8010775f
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
801001ff:	e8 bc 43 00 00       	call   801045c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 43 00 00       	call   80104580 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 c0 45 00 00       	call   801047e0 <acquire>
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
8010026c:	e9 0f 45 00 00       	jmp    80104780 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 77 10 80       	push   $0x80107766
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
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801002a0:	e8 3b 45 00 00       	call   801047e0 <acquire>
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
801002cd:	e8 ae 3f 00 00       	call   80104280 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 38 00 00       	call   80103b30 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 85 44 00 00       	call   80104780 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
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
8010034c:	e8 2f 44 00 00       	call   80104780 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
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
80100399:	e8 02 27 00 00       	call   80102aa0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 77 10 80       	push   $0x8010776d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 bb 80 10 80 	movl   $0x801080bb,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 42 00 00       	call   80104630 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 77 10 80       	push   $0x80107781
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
8010041a:	e8 51 5c 00 00       	call   80106070 <uartputc>
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
80100505:	e8 66 5b 00 00       	call   80106070 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 5a 5b 00 00       	call   80106070 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 4e 5b 00 00       	call   80106070 <uartputc>
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
80100551:	e8 ea 43 00 00       	call   80104940 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 35 43 00 00       	call   801048a0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 77 10 80       	push   $0x80107785
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
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801005ab:	e8 30 42 00 00       	call   801047e0 <acquire>
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
801005e4:	e8 97 41 00 00       	call   80104780 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

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
80100636:	0f b6 92 b0 77 10 80 	movzbl -0x7fef8850(%edx),%edx
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
801007e8:	e8 f3 3f 00 00       	call   801047e0 <acquire>
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
80100838:	bf 98 77 10 80       	mov    $0x80107798,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 ff 10 80       	push   $0x8010ff40
8010085b:	e8 20 3f 00 00       	call   80104780 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 77 10 80       	push   $0x8010779f
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
80100893:	e8 48 3f 00 00       	call   801047e0 <acquire>
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
801009d0:	e8 ab 3d 00 00       	call   80104780 <release>
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
80100a0e:	e9 0d 3a 00 00       	jmp    80104420 <procdump>
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
80100a44:	e8 f7 38 00 00       	call   80104340 <wakeup>
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
80100a66:	68 a8 77 10 80       	push   $0x801077a8
80100a6b:	68 40 ff 10 80       	push   $0x8010ff40
80100a70:	e8 9b 3b 00 00       	call   80104610 <initlock>

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
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
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
80100abc:	e8 6f 30 00 00       	call   80103b30 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 44 24 00 00       	call   80102f10 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
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
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 6c 24 00 00       	call   80102f80 <end_op>
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
80100b34:	e8 b7 68 00 00       	call   801073f0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
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
80100ba3:	e8 28 65 00 00       	call   801070d0 <allocuvm>
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
80100bd9:	e8 02 64 00 00       	call   80106fe0 <loaduvm>
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
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 50 67 00 00       	call   80107370 <freevm>
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
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 2a 23 00 00       	call   80102f80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 69 64 00 00       	call   801070d0 <allocuvm>
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
80100c83:	e8 08 68 00 00       	call   80107490 <clearpteu>
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
80100cd3:	e8 c8 3d 00 00       	call   80104aa0 <strlen>
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
80100ce7:	e8 b4 3d 00 00       	call   80104aa0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 63 69 00 00       	call   80107660 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 5a 66 00 00       	call   80107370 <freevm>
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
80100d63:	e8 f8 68 00 00       	call   80107660 <copyout>
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
80100da1:	e8 ba 3c 00 00       	call   80104a60 <safestrcpy>
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
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 7e 60 00 00       	call   80106e50 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 96 65 00 00       	call   80107370 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 97 21 00 00       	call   80102f80 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 c1 77 10 80       	push   $0x801077c1
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 cd 77 10 80       	push   $0x801077cd
80100e1b:	68 80 ff 10 80       	push   $0x8010ff80
80100e20:	e8 eb 37 00 00       	call   80104610 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb b4 ff 10 80       	mov    $0x8010ffb4,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 80 ff 10 80       	push   $0x8010ff80
80100e41:	e8 9a 39 00 00       	call   801047e0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 14 09 11 80    	cmp    $0x80110914,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 80 ff 10 80       	push   $0x8010ff80
80100e71:	e8 0a 39 00 00       	call   80104780 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 80 ff 10 80       	push   $0x8010ff80
80100e8a:	e8 f1 38 00 00       	call   80104780 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 80 ff 10 80       	push   $0x8010ff80
80100eaf:	e8 2c 39 00 00       	call   801047e0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 80 ff 10 80       	push   $0x8010ff80
80100ecc:	e8 af 38 00 00       	call   80104780 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 d4 77 10 80       	push   $0x801077d4
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 80 ff 10 80       	push   $0x8010ff80
80100f01:	e8 da 38 00 00       	call   801047e0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 80 ff 10 80       	push   $0x8010ff80
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 3f 38 00 00       	call   80104780 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 80 ff 10 80 	movl   $0x8010ff80,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 0d 38 00 00       	jmp    80104780 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 93 1f 00 00       	call   80102f10 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 e9 1f 00 00       	jmp    80102f80 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 42 27 00 00       	call   801036f0 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 dc 77 10 80       	push   $0x801077dc
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 fe 27 00 00       	jmp    80103890 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 e6 77 10 80       	push   $0x801077e6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 72 1e 00 00       	call   80102f80 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 dd 1d 00 00       	call   80102f10 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 16 1e 00 00       	call   80102f80 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 ef 77 10 80       	push   $0x801077ef
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 e2 25 00 00       	jmp    80103790 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 f5 77 10 80       	push   $0x801077f5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 ec 25 11 80    	add    0x801125ec,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 de 1e 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 ff 77 10 80       	push   $0x801077ff
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d d4 25 11 80    	mov    0x801125d4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 ec 25 11 80    	add    0x801125ec,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 d4 25 11 80       	mov    0x801125d4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 d4 25 11 80    	cmp    %eax,0x801125d4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 12 78 10 80       	push   $0x80107812
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 ee 1d 00 00       	call   801030f0 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 76 35 00 00       	call   801048a0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 be 1d 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb b4 09 11 80       	mov    $0x801109b4,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 80 09 11 80       	push   $0x80110980
8010136a:	e8 71 34 00 00       	call   801047e0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 80 09 11 80       	push   $0x80110980
801013d7:	e8 a4 33 00 00       	call   80104780 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 80 09 11 80       	push   $0x80110980
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 76 33 00 00       	call   80104780 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 28 78 10 80       	push   $0x80107828
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 26 1c 00 00       	call   801030f0 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 38 78 10 80       	push   $0x80107838
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 fa 33 00 00       	call   80104940 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb c0 09 11 80       	mov    $0x801109c0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 4b 78 10 80       	push   $0x8010784b
80101571:	68 80 09 11 80       	push   $0x80110980
80101576:	e8 95 30 00 00       	call   80104610 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 52 78 10 80       	push   $0x80107852
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 4c 2f 00 00       	call   801044e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb e0 25 11 80    	cmp    $0x801125e0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 d4 25 11 80       	push   $0x801125d4
801015bc:	e8 7f 33 00 00       	call   80104940 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 ec 25 11 80    	push   0x801125ec
801015cf:	ff 35 e8 25 11 80    	push   0x801125e8
801015d5:	ff 35 e4 25 11 80    	push   0x801125e4
801015db:	ff 35 e0 25 11 80    	push   0x801125e0
801015e1:	ff 35 dc 25 11 80    	push   0x801125dc
801015e7:	ff 35 d8 25 11 80    	push   0x801125d8
801015ed:	ff 35 d4 25 11 80    	push   0x801125d4
801015f3:	68 b8 78 10 80       	push   $0x801078b8
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d dc 25 11 80 01 	cmpl   $0x1,0x801125dc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d dc 25 11 80    	cmp    0x801125dc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 e8 25 11 80    	add    0x801125e8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 0d 32 00 00       	call   801048a0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 4b 1a 00 00       	call   801030f0 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 58 78 10 80       	push   $0x80107858
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 e8 25 11 80    	add    0x801125e8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 0a 32 00 00       	call   80104940 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 b2 19 00 00       	call   801030f0 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 80 09 11 80       	push   $0x80110980
8010175f:	e8 7c 30 00 00       	call   801047e0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010176f:	e8 0c 30 00 00       	call   80104780 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 79 2d 00 00       	call   80104520 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 e8 25 11 80    	add    0x801125e8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 23 31 00 00       	call   80104940 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 70 78 10 80       	push   $0x80107870
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 6a 78 10 80       	push   $0x8010786a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 48 2d 00 00       	call   801045c0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 ec 2c 00 00       	jmp    80104580 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 7f 78 10 80       	push   $0x8010787f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 5b 2c 00 00       	call   80104520 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 a1 2c 00 00       	call   80104580 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
801018e6:	e8 f5 2e 00 00       	call   801047e0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 80 09 11 80 	movl   $0x80110980,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 7b 2e 00 00       	jmp    80104780 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 80 09 11 80       	push   $0x80110980
80101910:	e8 cb 2e 00 00       	call   801047e0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010191f:	e8 5c 2e 00 00       	call   80104780 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 98 2b 00 00       	call   801045c0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 41 2b 00 00       	call   80104580 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 7f 78 10 80       	push   $0x8010787f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 04 2e 00 00       	call   80104940 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 20 09 11 80 	mov    -0x7feef6e0(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 08 2d 00 00       	call   80104940 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 b0 14 00 00       	call   801030f0 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 24 09 11 80 	mov    -0x7feef6dc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 dd 2c 00 00       	call   801049b0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 7e 2c 00 00       	call   801049b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 99 78 10 80       	push   $0x80107899
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 87 78 10 80       	push   $0x80107887
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 81 1d 00 00       	call   80103b30 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 80 09 11 80       	push   $0x80110980
80101dba:	e8 21 2a 00 00       	call   801047e0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101dca:	e8 b1 29 00 00       	call   80104780 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 14 2b 00 00       	call   80104940 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 2f 27 00 00       	call   801045c0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 cd 26 00 00       	call   80104580 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 60 2a 00 00       	call   80104940 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 90 26 00 00       	call   801045c0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 31 26 00 00       	call   80104580 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 4e 26 00 00       	call   801045c0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 2b 26 00 00       	call   801045c0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 d4 25 00 00       	call   80104580 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 7f 78 10 80       	push   $0x8010787f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 be 29 00 00       	call   80104a00 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 a8 78 10 80       	push   $0x801078a8
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 8a 7e 10 80       	push   $0x80107e8a
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 14 79 10 80       	push   $0x80107914
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 0b 79 10 80       	push   $0x8010790b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 26 79 10 80       	push   $0x80107926
801021cb:	68 20 26 11 80       	push   $0x80112620
801021d0:	e8 3b 24 00 00       	call   80104610 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 a4 27 11 80       	mov    0x801127a4,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 20 26 11 80       	push   $0x80112620
8010224e:	e8 8d 25 00 00       	call   801047e0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d 04 26 11 80    	mov    0x80112604,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 04 26 11 80       	mov    %eax,0x80112604

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 8e 20 00 00       	call   80104340 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 04 26 11 80       	mov    0x80112604,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 20 26 11 80       	push   $0x80112620
801022cb:	e8 b0 24 00 00       	call   80104780 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 cd 22 00 00       	call   801045c0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 00 26 11 80       	mov    0x80112600,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 20 26 11 80       	push   $0x80112620
80102328:	e8 b3 24 00 00       	call   801047e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 04 26 11 80       	mov    0x80112604,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d 04 26 11 80    	cmp    %ebx,0x80112604
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 20 26 11 80       	push   $0x80112620
80102368:	53                   	push   %ebx
80102369:	e8 12 1f 00 00       	call   80104280 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 20 26 11 80 	movl   $0x80112620,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 f5 23 00 00       	jmp    80104780 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba 04 26 11 80       	mov    $0x80112604,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 55 79 10 80       	push   $0x80107955
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 40 79 10 80       	push   $0x80107940
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 2a 79 10 80       	push   $0x8010792a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 74 79 10 80       	push   $0x80107974
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
//  Free the page of physical memory pointed at by v,
//  which normally should have been returned by a
//  call to kalloc().  (The exception is when
//  initializing the allocator; see kinit above.)
void kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb f0 65 11 80    	cmp    $0x801165f0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 a9 23 00 00       	call   801048a0 <memset>

  if (kmem.use_lock)
801024f7:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
80102504:	a1 98 26 11 80       	mov    0x80112698,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if (kmem.use_lock)
8010250b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102510:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if (kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 60 26 11 80       	push   $0x80112660
80102528:	e8 b3 22 00 00       	call   801047e0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 38 22 00 00       	jmp    80104780 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 a6 79 10 80       	push   $0x801079a6
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char *)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char *)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 ac 79 10 80       	push   $0x801079ac
80102620:	68 60 26 11 80       	push   $0x80112660
80102625:	e8 e6 1f 00 00       	call   80104610 <initlock>
  p = (char *)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102637:	00 00 00 
  p = (char *)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <khugefree>:
// part 1
// I basically just copy-pasted kfree() and replaced every PGSIZE with HUGE_PAGE_SIZE
// also replaced PHYSTOP with HUGE_PAGE_END
// ? also replaced end with HUGE_PAGE_START (???) this might not be correct
void khugefree(char *v)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	53                   	push   %ebx
80102684:	83 ec 04             	sub    $0x4,%esp
80102687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if ((uint)v % HUGE_PAGE_SIZE || V2P(v) < HUGE_PAGE_START || V2P(v) >= HUGE_PAGE_END)
8010268a:	f7 c3 ff ff 3f 00    	test   $0x3fffff,%ebx
80102690:	75 76                	jne    80102708 <khugefree+0x88>
80102692:	8d 83 00 00 00 62    	lea    0x62000000(%ebx),%eax
80102698:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
8010269d:	77 69                	ja     80102708 <khugefree+0x88>
    panic("khugefree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, HUGE_PAGE_SIZE);
8010269f:	83 ec 04             	sub    $0x4,%esp
801026a2:	68 00 00 40 00       	push   $0x400000
801026a7:	6a 01                	push   $0x1
801026a9:	53                   	push   %ebx
801026aa:	e8 f1 21 00 00       	call   801048a0 <memset>

  if (kmem.use_lock)
801026af:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801026b5:	83 c4 10             	add    $0x10,%esp
801026b8:	85 d2                	test   %edx,%edx
801026ba:	75 24                	jne    801026e0 <khugefree+0x60>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freehugelist;
801026bc:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026c1:	89 03                	mov    %eax,(%ebx)
  kmem.freehugelist = r;
  if (kmem.use_lock)
801026c3:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freehugelist = r;
801026c8:	89 1d 9c 26 11 80    	mov    %ebx,0x8011269c
  if (kmem.use_lock)
801026ce:	85 c0                	test   %eax,%eax
801026d0:	75 26                	jne    801026f8 <khugefree+0x78>
    release(&kmem.lock);
}
801026d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d5:	c9                   	leave  
801026d6:	c3                   	ret    
801026d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026de:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	68 60 26 11 80       	push   $0x80112660
801026e8:	e8 f3 20 00 00       	call   801047e0 <acquire>
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	eb ca                	jmp    801026bc <khugefree+0x3c>
801026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801026f8:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801026ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102702:	c9                   	leave  
    release(&kmem.lock);
80102703:	e9 78 20 00 00       	jmp    80104780 <release>
    panic("khugefree");
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	68 b1 79 10 80       	push   $0x801079b1
80102710:	e8 6b dc ff ff       	call   80100380 <panic>
80102715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <freehugerange>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
  p = (char *)HUGEPGROUNDUP((uint)vstart);
80102724:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102727:	8b 75 0c             	mov    0xc(%ebp),%esi
8010272a:	53                   	push   %ebx
  p = (char *)HUGEPGROUNDUP((uint)vstart);
8010272b:	8d 98 ff ff 3f 00    	lea    0x3fffff(%eax),%ebx
80102731:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
80102737:	81 c3 00 00 40 00    	add    $0x400000,%ebx
8010273d:	39 de                	cmp    %ebx,%esi
8010273f:	72 23                	jb     80102764 <freehugerange+0x44>
80102741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    khugefree(p);
80102748:	83 ec 0c             	sub    $0xc,%esp
8010274b:	8d 83 00 00 c0 ff    	lea    -0x400000(%ebx),%eax
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
80102751:	81 c3 00 00 40 00    	add    $0x400000,%ebx
    khugefree(p);
80102757:	50                   	push   %eax
80102758:	e8 23 ff ff ff       	call   80102680 <khugefree>
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
8010275d:	83 c4 10             	add    $0x10,%esp
80102760:	39 f3                	cmp    %esi,%ebx
80102762:	76 e4                	jbe    80102748 <freehugerange+0x28>
}
80102764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102767:	5b                   	pop    %ebx
80102768:	5e                   	pop    %esi
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop

80102770 <khugeinit>:
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	56                   	push   %esi
  p = (char *)HUGEPGROUNDUP((uint)vstart);
80102774:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102777:	8b 75 0c             	mov    0xc(%ebp),%esi
8010277a:	53                   	push   %ebx
  p = (char *)HUGEPGROUNDUP((uint)vstart);
8010277b:	8d 98 ff ff 3f 00    	lea    0x3fffff(%eax),%ebx
80102781:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
80102787:	81 c3 00 00 40 00    	add    $0x400000,%ebx
8010278d:	39 de                	cmp    %ebx,%esi
8010278f:	72 23                	jb     801027b4 <khugeinit+0x44>
80102791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    khugefree(p);
80102798:	83 ec 0c             	sub    $0xc,%esp
8010279b:	8d 83 00 00 c0 ff    	lea    -0x400000(%ebx),%eax
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027a1:	81 c3 00 00 40 00    	add    $0x400000,%ebx
    khugefree(p);
801027a7:	50                   	push   %eax
801027a8:	e8 d3 fe ff ff       	call   80102680 <khugefree>
  for (; p + HUGE_PAGE_SIZE <= (char *)vend; p += HUGE_PAGE_SIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	39 de                	cmp    %ebx,%esi
801027b2:	73 e4                	jae    80102798 <khugeinit+0x28>
}
801027b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027b7:	5b                   	pop    %ebx
801027b8:	5e                   	pop    %esi
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
801027bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027bf:	90                   	nop

801027c0 <kalloc>:
char *
kalloc(void)
{
  struct run *r;

  if (kmem.use_lock)
801027c0:	a1 94 26 11 80       	mov    0x80112694,%eax
801027c5:	85 c0                	test   %eax,%eax
801027c7:	75 1f                	jne    801027e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027c9:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (r)
801027ce:	85 c0                	test   %eax,%eax
801027d0:	74 0e                	je     801027e0 <kalloc+0x20>
    kmem.freelist = r->next;
801027d2:	8b 10                	mov    (%eax),%edx
801027d4:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if (kmem.use_lock)
801027da:	c3                   	ret    
801027db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop
    release(&kmem.lock);
  return (char *)r;
}
801027e0:	c3                   	ret    
801027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027e8:	55                   	push   %ebp
801027e9:	89 e5                	mov    %esp,%ebp
801027eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027ee:	68 60 26 11 80       	push   $0x80112660
801027f3:	e8 e8 1f 00 00       	call   801047e0 <acquire>
  r = kmem.freelist;
801027f8:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (kmem.use_lock)
801027fd:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if (r)
80102803:	83 c4 10             	add    $0x10,%esp
80102806:	85 c0                	test   %eax,%eax
80102808:	74 08                	je     80102812 <kalloc+0x52>
    kmem.freelist = r->next;
8010280a:	8b 08                	mov    (%eax),%ecx
8010280c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if (kmem.use_lock)
80102812:	85 d2                	test   %edx,%edx
80102814:	74 16                	je     8010282c <kalloc+0x6c>
    release(&kmem.lock);
80102816:	83 ec 0c             	sub    $0xc,%esp
80102819:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010281c:	68 60 26 11 80       	push   $0x80112660
80102821:	e8 5a 1f 00 00       	call   80104780 <release>
  return (char *)r;
80102826:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102829:	83 c4 10             	add    $0x10,%esp
}
8010282c:	c9                   	leave  
8010282d:	c3                   	ret    
8010282e:	66 90                	xchg   %ax,%ax

80102830 <khugealloc>:
{
  struct run *r;
  
  //r = (struct run *)HUGE_VA_OFFSET;
  
  if (kmem.use_lock)
80102830:	a1 94 26 11 80       	mov    0x80112694,%eax
80102835:	85 c0                	test   %eax,%eax
80102837:	75 1f                	jne    80102858 <khugealloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freehugelist;
80102839:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  if (r)
8010283e:	85 c0                	test   %eax,%eax
80102840:	74 0e                	je     80102850 <khugealloc+0x20>
    kmem.freehugelist = r->next;
80102842:	8b 10                	mov    (%eax),%edx
80102844:	89 15 9c 26 11 80    	mov    %edx,0x8011269c
  if (kmem.use_lock)
8010284a:	c3                   	ret    
8010284b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010284f:	90                   	nop
    release(&kmem.lock);

  return (char *)r;
}
80102850:	c3                   	ret    
80102851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102858:	55                   	push   %ebp
80102859:	89 e5                	mov    %esp,%ebp
8010285b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010285e:	68 60 26 11 80       	push   $0x80112660
80102863:	e8 78 1f 00 00       	call   801047e0 <acquire>
  r = kmem.freehugelist;
80102868:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  if (kmem.use_lock)
8010286d:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if (r)
80102873:	83 c4 10             	add    $0x10,%esp
80102876:	85 c0                	test   %eax,%eax
80102878:	74 08                	je     80102882 <khugealloc+0x52>
    kmem.freehugelist = r->next;
8010287a:	8b 08                	mov    (%eax),%ecx
8010287c:	89 0d 9c 26 11 80    	mov    %ecx,0x8011269c
  if (kmem.use_lock)
80102882:	85 d2                	test   %edx,%edx
80102884:	74 16                	je     8010289c <khugealloc+0x6c>
    release(&kmem.lock);
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010288c:	68 60 26 11 80       	push   $0x80112660
80102891:	e8 ea 1e 00 00       	call   80104780 <release>
  return (char *)r;
80102896:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102899:	83 c4 10             	add    $0x10,%esp
}
8010289c:	c9                   	leave  
8010289d:	c3                   	ret    
8010289e:	66 90                	xchg   %ax,%ax

801028a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a0:	ba 64 00 00 00       	mov    $0x64,%edx
801028a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028a6:	a8 01                	test   $0x1,%al
801028a8:	0f 84 c2 00 00 00    	je     80102970 <kbdgetc+0xd0>
{
801028ae:	55                   	push   %ebp
801028af:	ba 60 00 00 00       	mov    $0x60,%edx
801028b4:	89 e5                	mov    %esp,%ebp
801028b6:	53                   	push   %ebx
801028b7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028b8:	8b 1d a0 26 11 80    	mov    0x801126a0,%ebx
  data = inb(KBDATAP);
801028be:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028c1:	3c e0                	cmp    $0xe0,%al
801028c3:	74 5b                	je     80102920 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028c5:	89 da                	mov    %ebx,%edx
801028c7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028ca:	84 c0                	test   %al,%al
801028cc:	78 62                	js     80102930 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028ce:	85 d2                	test   %edx,%edx
801028d0:	74 09                	je     801028db <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028d2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028d5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028d8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801028db:	0f b6 91 e0 7a 10 80 	movzbl -0x7fef8520(%ecx),%edx
  shift ^= togglecode[data];
801028e2:	0f b6 81 e0 79 10 80 	movzbl -0x7fef8620(%ecx),%eax
  shift |= shiftcode[data];
801028e9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028eb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028ef:	89 15 a0 26 11 80    	mov    %edx,0x801126a0
  c = charcode[shift & (CTL | SHIFT)][data];
801028f5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028f8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028fb:	8b 04 85 c0 79 10 80 	mov    -0x7fef8640(,%eax,4),%eax
80102902:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102906:	74 0b                	je     80102913 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102908:	8d 50 9f             	lea    -0x61(%eax),%edx
8010290b:	83 fa 19             	cmp    $0x19,%edx
8010290e:	77 48                	ja     80102958 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102910:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102916:	c9                   	leave  
80102917:	c3                   	ret    
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop
    shift |= E0ESC;
80102920:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102923:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102925:	89 1d a0 26 11 80    	mov    %ebx,0x801126a0
}
8010292b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010292e:	c9                   	leave  
8010292f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102930:	83 e0 7f             	and    $0x7f,%eax
80102933:	85 d2                	test   %edx,%edx
80102935:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102938:	0f b6 81 e0 7a 10 80 	movzbl -0x7fef8520(%ecx),%eax
8010293f:	83 c8 40             	or     $0x40,%eax
80102942:	0f b6 c0             	movzbl %al,%eax
80102945:	f7 d0                	not    %eax
80102947:	21 d8                	and    %ebx,%eax
}
80102949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010294c:	a3 a0 26 11 80       	mov    %eax,0x801126a0
    return 0;
80102951:	31 c0                	xor    %eax,%eax
}
80102953:	c9                   	leave  
80102954:	c3                   	ret    
80102955:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102958:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010295b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010295e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102961:	c9                   	leave  
      c += 'a' - 'A';
80102962:	83 f9 1a             	cmp    $0x1a,%ecx
80102965:	0f 42 c2             	cmovb  %edx,%eax
}
80102968:	c3                   	ret    
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102975:	c3                   	ret    
80102976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297d:	8d 76 00             	lea    0x0(%esi),%esi

80102980 <kbdintr>:

void
kbdintr(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102986:	68 a0 28 10 80       	push   $0x801028a0
8010298b:	e8 f0 de ff ff       	call   80100880 <consoleintr>
}
80102990:	83 c4 10             	add    $0x10,%esp
80102993:	c9                   	leave  
80102994:	c3                   	ret    
80102995:	66 90                	xchg   %ax,%ax
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029a0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	0f 84 cb 00 00 00    	je     80102a78 <lapicinit+0xd8>
  lapic[index] = value;
801029ad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029b4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029ce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029db:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029f5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029fb:	8b 50 30             	mov    0x30(%eax),%edx
801029fe:	c1 ea 10             	shr    $0x10,%edx
80102a01:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a07:	75 77                	jne    80102a80 <lapicinit+0xe0>
  lapic[index] = value;
80102a09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a20:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a54:	8b 50 20             	mov    0x20(%eax),%edx
80102a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a66:	80 e6 10             	and    $0x10,%dh
80102a69:	75 f5                	jne    80102a60 <lapicinit+0xc0>
  lapic[index] = value;
80102a6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a75:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a78:	c3                   	ret    
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a8d:	e9 77 ff ff ff       	jmp    80102a09 <lapicinit+0x69>
80102a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102aa0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102aa0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102aa5:	85 c0                	test   %eax,%eax
80102aa7:	74 07                	je     80102ab0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102aa9:	8b 40 20             	mov    0x20(%eax),%eax
80102aac:	c1 e8 18             	shr    $0x18,%eax
80102aaf:	c3                   	ret    
    return 0;
80102ab0:	31 c0                	xor    %eax,%eax
}
80102ab2:	c3                   	ret    
80102ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ac0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ac0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102ac5:	85 c0                	test   %eax,%eax
80102ac7:	74 0d                	je     80102ad6 <lapiceoi+0x16>
  lapic[index] = value;
80102ac9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ad0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ad6:	c3                   	ret    
80102ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ade:	66 90                	xchg   %ax,%ax

80102ae0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ae0:	c3                   	ret    
80102ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aef:	90                   	nop

80102af0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102af0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102af6:	ba 70 00 00 00       	mov    $0x70,%edx
80102afb:	89 e5                	mov    %esp,%ebp
80102afd:	53                   	push   %ebx
80102afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b04:	ee                   	out    %al,(%dx)
80102b05:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b0a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b10:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b1d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b20:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b22:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b2e:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102b33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b77:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    
80102b7f:	90                   	nop

80102b80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b80:	55                   	push   %ebp
80102b81:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b86:	ba 70 00 00 00       	mov    $0x70,%edx
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	57                   	push   %edi
80102b8e:	56                   	push   %esi
80102b8f:	53                   	push   %ebx
80102b90:	83 ec 4c             	sub    $0x4c,%esp
80102b93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b94:	ba 71 00 00 00       	mov    $0x71,%edx
80102b99:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ba2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ba5:	8d 76 00             	lea    0x0(%esi),%esi
80102ba8:	31 c0                	xor    %eax,%eax
80102baa:	89 da                	mov    %ebx,%edx
80102bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bad:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bb2:	89 ca                	mov    %ecx,%edx
80102bb4:	ec                   	in     (%dx),%al
80102bb5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb8:	89 da                	mov    %ebx,%edx
80102bba:	b8 02 00 00 00       	mov    $0x2,%eax
80102bbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc0:	89 ca                	mov    %ecx,%edx
80102bc2:	ec                   	in     (%dx),%al
80102bc3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc6:	89 da                	mov    %ebx,%edx
80102bc8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bce:	89 ca                	mov    %ecx,%edx
80102bd0:	ec                   	in     (%dx),%al
80102bd1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd4:	89 da                	mov    %ebx,%edx
80102bd6:	b8 07 00 00 00       	mov    $0x7,%eax
80102bdb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdc:	89 ca                	mov    %ecx,%edx
80102bde:	ec                   	in     (%dx),%al
80102bdf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be2:	89 da                	mov    %ebx,%edx
80102be4:	b8 08 00 00 00       	mov    $0x8,%eax
80102be9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bea:	89 ca                	mov    %ecx,%edx
80102bec:	ec                   	in     (%dx),%al
80102bed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bef:	89 da                	mov    %ebx,%edx
80102bf1:	b8 09 00 00 00       	mov    $0x9,%eax
80102bf6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf7:	89 ca                	mov    %ecx,%edx
80102bf9:	ec                   	in     (%dx),%al
80102bfa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bfc:	89 da                	mov    %ebx,%edx
80102bfe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c04:	89 ca                	mov    %ecx,%edx
80102c06:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c07:	84 c0                	test   %al,%al
80102c09:	78 9d                	js     80102ba8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c0b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c0f:	89 fa                	mov    %edi,%edx
80102c11:	0f b6 fa             	movzbl %dl,%edi
80102c14:	89 f2                	mov    %esi,%edx
80102c16:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c19:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c1d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c20:	89 da                	mov    %ebx,%edx
80102c22:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c25:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c28:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c2c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c32:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c36:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c39:	31 c0                	xor    %eax,%eax
80102c3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
80102c3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 da                	mov    %ebx,%edx
80102c44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c47:	b8 02 00 00 00       	mov    $0x2,%eax
80102c4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4d:	89 ca                	mov    %ecx,%edx
80102c4f:	ec                   	in     (%dx),%al
80102c50:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c53:	89 da                	mov    %ebx,%edx
80102c55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c58:	b8 04 00 00 00       	mov    $0x4,%eax
80102c5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5e:	89 ca                	mov    %ecx,%edx
80102c60:	ec                   	in     (%dx),%al
80102c61:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	89 da                	mov    %ebx,%edx
80102c66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c69:	b8 07 00 00 00       	mov    $0x7,%eax
80102c6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6f:	89 ca                	mov    %ecx,%edx
80102c71:	ec                   	in     (%dx),%al
80102c72:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c75:	89 da                	mov    %ebx,%edx
80102c77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c80:	89 ca                	mov    %ecx,%edx
80102c82:	ec                   	in     (%dx),%al
80102c83:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c86:	89 da                	mov    %ebx,%edx
80102c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c90:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c91:	89 ca                	mov    %ecx,%edx
80102c93:	ec                   	in     (%dx),%al
80102c94:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c97:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c9d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ca0:	6a 18                	push   $0x18
80102ca2:	50                   	push   %eax
80102ca3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ca6:	50                   	push   %eax
80102ca7:	e8 44 1c 00 00       	call   801048f0 <memcmp>
80102cac:	83 c4 10             	add    $0x10,%esp
80102caf:	85 c0                	test   %eax,%eax
80102cb1:	0f 85 f1 fe ff ff    	jne    80102ba8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102cb7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102cbb:	75 78                	jne    80102d35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cc0:	89 c2                	mov    %eax,%edx
80102cc2:	83 e0 0f             	and    $0xf,%eax
80102cc5:	c1 ea 04             	shr    $0x4,%edx
80102cc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ccb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cd1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cd4:	89 c2                	mov    %eax,%edx
80102cd6:	83 e0 0f             	and    $0xf,%eax
80102cd9:	c1 ea 04             	shr    $0x4,%edx
80102cdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ce5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce8:	89 c2                	mov    %eax,%edx
80102cea:	83 e0 0f             	and    $0xf,%eax
80102ced:	c1 ea 04             	shr    $0x4,%edx
80102cf0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cfc:	89 c2                	mov    %eax,%edx
80102cfe:	83 e0 0f             	and    $0xf,%eax
80102d01:	c1 ea 04             	shr    $0x4,%edx
80102d04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d10:	89 c2                	mov    %eax,%edx
80102d12:	83 e0 0f             	and    $0xf,%eax
80102d15:	c1 ea 04             	shr    $0x4,%edx
80102d18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d24:	89 c2                	mov    %eax,%edx
80102d26:	83 e0 0f             	and    $0xf,%eax
80102d29:	c1 ea 04             	shr    $0x4,%edx
80102d2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d35:	8b 75 08             	mov    0x8(%ebp),%esi
80102d38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d3b:	89 06                	mov    %eax,(%esi)
80102d3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d40:	89 46 04             	mov    %eax,0x4(%esi)
80102d43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d46:	89 46 08             	mov    %eax,0x8(%esi)
80102d49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d52:	89 46 10             	mov    %eax,0x10(%esi)
80102d55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d65:	5b                   	pop    %ebx
80102d66:	5e                   	pop    %esi
80102d67:	5f                   	pop    %edi
80102d68:	5d                   	pop    %ebp
80102d69:	c3                   	ret    
80102d6a:	66 90                	xchg   %ax,%ax
80102d6c:	66 90                	xchg   %ax,%ax
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d70:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102d76:	85 c9                	test   %ecx,%ecx
80102d78:	0f 8e 8a 00 00 00    	jle    80102e08 <install_trans+0x98>
{
80102d7e:	55                   	push   %ebp
80102d7f:	89 e5                	mov    %esp,%ebp
80102d81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d82:	31 ff                	xor    %edi,%edi
{
80102d84:	56                   	push   %esi
80102d85:	53                   	push   %ebx
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d90:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102d95:	83 ec 08             	sub    $0x8,%esp
80102d98:	01 f8                	add    %edi,%eax
80102d9a:	83 c0 01             	add    $0x1,%eax
80102d9d:	50                   	push   %eax
80102d9e:	ff 35 04 27 11 80    	push   0x80112704
80102da4:	e8 27 d3 ff ff       	call   801000d0 <bread>
80102da9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dab:	58                   	pop    %eax
80102dac:	5a                   	pop    %edx
80102dad:	ff 34 bd 0c 27 11 80 	push   -0x7feed8f4(,%edi,4)
80102db4:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102dba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbd:	e8 0e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dc5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dca:	68 00 02 00 00       	push   $0x200
80102dcf:	50                   	push   %eax
80102dd0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102dd3:	50                   	push   %eax
80102dd4:	e8 67 1b 00 00       	call   80104940 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dd9:	89 1c 24             	mov    %ebx,(%esp)
80102ddc:	e8 cf d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102de1:	89 34 24             	mov    %esi,(%esp)
80102de4:	e8 07 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102de9:	89 1c 24             	mov    %ebx,(%esp)
80102dec:	e8 ff d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	39 3d 08 27 11 80    	cmp    %edi,0x80112708
80102dfa:	7f 94                	jg     80102d90 <install_trans+0x20>
  }
}
80102dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dff:	5b                   	pop    %ebx
80102e00:	5e                   	pop    %esi
80102e01:	5f                   	pop    %edi
80102e02:	5d                   	pop    %ebp
80102e03:	c3                   	ret    
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e08:	c3                   	ret    
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e17:	ff 35 f4 26 11 80    	push   0x801126f4
80102e1d:	ff 35 04 27 11 80    	push   0x80112704
80102e23:	e8 a8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e28:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e2b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e2d:	a1 08 27 11 80       	mov    0x80112708,%eax
80102e32:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e35:	85 c0                	test   %eax,%eax
80102e37:	7e 19                	jle    80102e52 <write_head+0x42>
80102e39:	31 d2                	xor    %edx,%edx
80102e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e3f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e40:	8b 0c 95 0c 27 11 80 	mov    -0x7feed8f4(,%edx,4),%ecx
80102e47:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e4b:	83 c2 01             	add    $0x1,%edx
80102e4e:	39 d0                	cmp    %edx,%eax
80102e50:	75 ee                	jne    80102e40 <write_head+0x30>
  }
  bwrite(buf);
80102e52:	83 ec 0c             	sub    $0xc,%esp
80102e55:	53                   	push   %ebx
80102e56:	e8 55 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e5b:	89 1c 24             	mov    %ebx,(%esp)
80102e5e:	e8 8d d3 ff ff       	call   801001f0 <brelse>
}
80102e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e66:	83 c4 10             	add    $0x10,%esp
80102e69:	c9                   	leave  
80102e6a:	c3                   	ret    
80102e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop

80102e70 <initlog>:
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 2c             	sub    $0x2c,%esp
80102e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e7a:	68 e0 7b 10 80       	push   $0x80107be0
80102e7f:	68 c0 26 11 80       	push   $0x801126c0
80102e84:	e8 87 17 00 00       	call   80104610 <initlock>
  readsb(dev, &sb);
80102e89:	58                   	pop    %eax
80102e8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e8d:	5a                   	pop    %edx
80102e8e:	50                   	push   %eax
80102e8f:	53                   	push   %ebx
80102e90:	e8 8b e6 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e98:	59                   	pop    %ecx
  log.dev = dev;
80102e99:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
80102e9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ea2:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  log.size = sb.nlog;
80102ea7:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  struct buf *buf = bread(log.dev, log.start);
80102ead:	5a                   	pop    %edx
80102eae:	50                   	push   %eax
80102eaf:	53                   	push   %ebx
80102eb0:	e8 1b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102eb5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102eb8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ebb:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
80102ec1:	85 db                	test   %ebx,%ebx
80102ec3:	7e 1d                	jle    80102ee2 <initlog+0x72>
80102ec5:	31 d2                	xor    %edx,%edx
80102ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ece:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ed0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ed4:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102edb:	83 c2 01             	add    $0x1,%edx
80102ede:	39 d3                	cmp    %edx,%ebx
80102ee0:	75 ee                	jne    80102ed0 <initlog+0x60>
  brelse(buf);
80102ee2:	83 ec 0c             	sub    $0xc,%esp
80102ee5:	50                   	push   %eax
80102ee6:	e8 05 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eeb:	e8 80 fe ff ff       	call   80102d70 <install_trans>
  log.lh.n = 0;
80102ef0:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102ef7:	00 00 00 
  write_head(); // clear the log
80102efa:	e8 11 ff ff ff       	call   80102e10 <write_head>
}
80102eff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f02:	83 c4 10             	add    $0x10,%esp
80102f05:	c9                   	leave  
80102f06:	c3                   	ret    
80102f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f16:	68 c0 26 11 80       	push   $0x801126c0
80102f1b:	e8 c0 18 00 00       	call   801047e0 <acquire>
80102f20:	83 c4 10             	add    $0x10,%esp
80102f23:	eb 18                	jmp    80102f3d <begin_op+0x2d>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f28:	83 ec 08             	sub    $0x8,%esp
80102f2b:	68 c0 26 11 80       	push   $0x801126c0
80102f30:	68 c0 26 11 80       	push   $0x801126c0
80102f35:	e8 46 13 00 00       	call   80104280 <sleep>
80102f3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f3d:	a1 00 27 11 80       	mov    0x80112700,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	75 e2                	jne    80102f28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f46:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102f4b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102f51:	83 c0 01             	add    $0x1,%eax
80102f54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f5a:	83 fa 1e             	cmp    $0x1e,%edx
80102f5d:	7f c9                	jg     80102f28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f5f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f62:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80102f67:	68 c0 26 11 80       	push   $0x801126c0
80102f6c:	e8 0f 18 00 00       	call   80104780 <release>
      break;
    }
  }
}
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	c9                   	leave  
80102f75:	c3                   	ret    
80102f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7d:	8d 76 00             	lea    0x0(%esi),%esi

80102f80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f89:	68 c0 26 11 80       	push   $0x801126c0
80102f8e:	e8 4d 18 00 00       	call   801047e0 <acquire>
  log.outstanding -= 1;
80102f93:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80102f98:	8b 35 00 27 11 80    	mov    0x80112700,%esi
80102f9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fa1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fa4:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
80102faa:	85 f6                	test   %esi,%esi
80102fac:	0f 85 22 01 00 00    	jne    801030d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fb2:	85 db                	test   %ebx,%ebx
80102fb4:	0f 85 f6 00 00 00    	jne    801030b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fba:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
80102fc1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fc4:	83 ec 0c             	sub    $0xc,%esp
80102fc7:	68 c0 26 11 80       	push   $0x801126c0
80102fcc:	e8 af 17 00 00       	call   80104780 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fd1:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102fd7:	83 c4 10             	add    $0x10,%esp
80102fda:	85 c9                	test   %ecx,%ecx
80102fdc:	7f 42                	jg     80103020 <end_op+0xa0>
    acquire(&log.lock);
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 c0 26 11 80       	push   $0x801126c0
80102fe6:	e8 f5 17 00 00       	call   801047e0 <acquire>
    wakeup(&log);
80102feb:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
    log.committing = 0;
80102ff2:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80102ff9:	00 00 00 
    wakeup(&log);
80102ffc:	e8 3f 13 00 00       	call   80104340 <wakeup>
    release(&log.lock);
80103001:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80103008:	e8 73 17 00 00       	call   80104780 <release>
8010300d:	83 c4 10             	add    $0x10,%esp
}
80103010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103013:	5b                   	pop    %ebx
80103014:	5e                   	pop    %esi
80103015:	5f                   	pop    %edi
80103016:	5d                   	pop    %ebp
80103017:	c3                   	ret    
80103018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103020:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80103025:	83 ec 08             	sub    $0x8,%esp
80103028:	01 d8                	add    %ebx,%eax
8010302a:	83 c0 01             	add    $0x1,%eax
8010302d:	50                   	push   %eax
8010302e:	ff 35 04 27 11 80    	push   0x80112704
80103034:	e8 97 d0 ff ff       	call   801000d0 <bread>
80103039:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303b:	58                   	pop    %eax
8010303c:	5a                   	pop    %edx
8010303d:	ff 34 9d 0c 27 11 80 	push   -0x7feed8f4(,%ebx,4)
80103044:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
8010304a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010304d:	e8 7e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103052:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103055:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103057:	8d 40 5c             	lea    0x5c(%eax),%eax
8010305a:	68 00 02 00 00       	push   $0x200
8010305f:	50                   	push   %eax
80103060:	8d 46 5c             	lea    0x5c(%esi),%eax
80103063:	50                   	push   %eax
80103064:	e8 d7 18 00 00       	call   80104940 <memmove>
    bwrite(to);  // write the log
80103069:	89 34 24             	mov    %esi,(%esp)
8010306c:	e8 3f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103071:	89 3c 24             	mov    %edi,(%esp)
80103074:	e8 77 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103079:	89 34 24             	mov    %esi,(%esp)
8010307c:	e8 6f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103081:	83 c4 10             	add    $0x10,%esp
80103084:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
8010308a:	7c 94                	jl     80103020 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010308c:	e8 7f fd ff ff       	call   80102e10 <write_head>
    install_trans(); // Now install writes to home locations
80103091:	e8 da fc ff ff       	call   80102d70 <install_trans>
    log.lh.n = 0;
80103096:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
8010309d:	00 00 00 
    write_head();    // Erase the transaction from the log
801030a0:	e8 6b fd ff ff       	call   80102e10 <write_head>
801030a5:	e9 34 ff ff ff       	jmp    80102fde <end_op+0x5e>
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030b0:	83 ec 0c             	sub    $0xc,%esp
801030b3:	68 c0 26 11 80       	push   $0x801126c0
801030b8:	e8 83 12 00 00       	call   80104340 <wakeup>
  release(&log.lock);
801030bd:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
801030c4:	e8 b7 16 00 00       	call   80104780 <release>
801030c9:	83 c4 10             	add    $0x10,%esp
}
801030cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cf:	5b                   	pop    %ebx
801030d0:	5e                   	pop    %esi
801030d1:	5f                   	pop    %edi
801030d2:	5d                   	pop    %ebp
801030d3:	c3                   	ret    
    panic("log.committing");
801030d4:	83 ec 0c             	sub    $0xc,%esp
801030d7:	68 e4 7b 10 80       	push   $0x80107be4
801030dc:	e8 9f d2 ff ff       	call   80100380 <panic>
801030e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ef:	90                   	nop

801030f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	53                   	push   %ebx
801030f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030f7:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
801030fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103100:	83 fa 1d             	cmp    $0x1d,%edx
80103103:	0f 8f 85 00 00 00    	jg     8010318e <log_write+0x9e>
80103109:	a1 f8 26 11 80       	mov    0x801126f8,%eax
8010310e:	83 e8 01             	sub    $0x1,%eax
80103111:	39 c2                	cmp    %eax,%edx
80103113:	7d 79                	jge    8010318e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103115:	a1 fc 26 11 80       	mov    0x801126fc,%eax
8010311a:	85 c0                	test   %eax,%eax
8010311c:	7e 7d                	jle    8010319b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010311e:	83 ec 0c             	sub    $0xc,%esp
80103121:	68 c0 26 11 80       	push   $0x801126c0
80103126:	e8 b5 16 00 00       	call   801047e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010312b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80103131:	83 c4 10             	add    $0x10,%esp
80103134:	85 d2                	test   %edx,%edx
80103136:	7e 4a                	jle    80103182 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103138:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010313b:	31 c0                	xor    %eax,%eax
8010313d:	eb 08                	jmp    80103147 <log_write+0x57>
8010313f:	90                   	nop
80103140:	83 c0 01             	add    $0x1,%eax
80103143:	39 c2                	cmp    %eax,%edx
80103145:	74 29                	je     80103170 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103147:	39 0c 85 0c 27 11 80 	cmp    %ecx,-0x7feed8f4(,%eax,4)
8010314e:	75 f0                	jne    80103140 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103150:	89 0c 85 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103157:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010315a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010315d:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80103164:	c9                   	leave  
  release(&log.lock);
80103165:	e9 16 16 00 00       	jmp    80104780 <release>
8010316a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103170:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
    log.lh.n++;
80103177:	83 c2 01             	add    $0x1,%edx
8010317a:	89 15 08 27 11 80    	mov    %edx,0x80112708
80103180:	eb d5                	jmp    80103157 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103182:	8b 43 08             	mov    0x8(%ebx),%eax
80103185:	a3 0c 27 11 80       	mov    %eax,0x8011270c
  if (i == log.lh.n)
8010318a:	75 cb                	jne    80103157 <log_write+0x67>
8010318c:	eb e9                	jmp    80103177 <log_write+0x87>
    panic("too big a transaction");
8010318e:	83 ec 0c             	sub    $0xc,%esp
80103191:	68 f3 7b 10 80       	push   $0x80107bf3
80103196:	e8 e5 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010319b:	83 ec 0c             	sub    $0xc,%esp
8010319e:	68 09 7c 10 80       	push   $0x80107c09
801031a3:	e8 d8 d1 ff ff       	call   80100380 <panic>
801031a8:	66 90                	xchg   %ax,%ax
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	53                   	push   %ebx
801031b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031b7:	e8 54 09 00 00       	call   80103b10 <cpuid>
801031bc:	89 c3                	mov    %eax,%ebx
801031be:	e8 4d 09 00 00       	call   80103b10 <cpuid>
801031c3:	83 ec 04             	sub    $0x4,%esp
801031c6:	53                   	push   %ebx
801031c7:	50                   	push   %eax
801031c8:	68 24 7c 10 80       	push   $0x80107c24
801031cd:	e8 ce d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801031d2:	e8 c9 2a 00 00       	call   80105ca0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031d7:	e8 d4 08 00 00       	call   80103ab0 <mycpu>
801031dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031de:	b8 01 00 00 00       	mov    $0x1,%eax
801031e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ea:	e8 81 0c 00 00       	call   80103e70 <scheduler>
801031ef:	90                   	nop

801031f0 <mpenter>:
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031f6:	e8 45 3c 00 00       	call   80106e40 <switchkvm>
  seginit();
801031fb:	e8 b0 3b 00 00       	call   80106db0 <seginit>
  lapicinit();
80103200:	e8 9b f7 ff ff       	call   801029a0 <lapicinit>
  mpmain();
80103205:	e8 a6 ff ff ff       	call   801031b0 <mpmain>
8010320a:	66 90                	xchg   %ax,%ax
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <main>:
{
80103210:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103214:	83 e4 f0             	and    $0xfffffff0,%esp
80103217:	ff 71 fc             	push   -0x4(%ecx)
8010321a:	55                   	push   %ebp
8010321b:	89 e5                	mov    %esp,%ebp
8010321d:	53                   	push   %ebx
8010321e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010321f:	83 ec 08             	sub    $0x8,%esp
80103222:	68 00 00 40 80       	push   $0x80400000
80103227:	68 f0 65 11 80       	push   $0x801165f0
8010322c:	e8 df f3 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103231:	e8 3a 42 00 00       	call   80107470 <kvmalloc>
  mpinit();        // detect other processors
80103236:	e8 95 01 00 00       	call   801033d0 <mpinit>
  lapicinit();     // interrupt controller
8010323b:	e8 60 f7 ff ff       	call   801029a0 <lapicinit>
  seginit();       // segment descriptors
80103240:	e8 6b 3b 00 00       	call   80106db0 <seginit>
  picinit();       // disable pic
80103245:	e8 86 03 00 00       	call   801035d0 <picinit>
  ioapicinit();    // another interrupt controller
8010324a:	e8 81 f1 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010324f:	e8 0c d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103254:	e8 37 2d 00 00       	call   80105f90 <uartinit>
  pinit();         // process table
80103259:	e8 32 08 00 00       	call   80103a90 <pinit>
  tvinit();        // trap vectors
8010325e:	e8 bd 29 00 00       	call   80105c20 <tvinit>
  binit();         // buffer cache
80103263:	e8 d8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103268:	e8 a3 db ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
8010326d:	e8 4e ef ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103272:	83 c4 0c             	add    $0xc,%esp
80103275:	68 8a 00 00 00       	push   $0x8a
8010327a:	68 9c b4 10 80       	push   $0x8010b49c
8010327f:	68 00 70 00 80       	push   $0x80007000
80103284:	e8 b7 16 00 00       	call   80104940 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
80103293:	00 00 00 
80103296:	05 c0 27 11 80       	add    $0x801127c0,%eax
8010329b:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
801032a0:	76 7e                	jbe    80103320 <main+0x110>
801032a2:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
801032a7:	eb 20                	jmp    801032c9 <main+0xb9>
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032b0:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
801032b7:	00 00 00 
801032ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032c0:	05 c0 27 11 80       	add    $0x801127c0,%eax
801032c5:	39 c3                	cmp    %eax,%ebx
801032c7:	73 57                	jae    80103320 <main+0x110>
    if(c == mycpu())  // We've started already.
801032c9:	e8 e2 07 00 00       	call   80103ab0 <mycpu>
801032ce:	39 c3                	cmp    %eax,%ebx
801032d0:	74 de                	je     801032b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032d2:	e8 e9 f4 ff ff       	call   801027c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032da:	c7 05 f8 6f 00 80 f0 	movl   $0x801031f0,0x80006ff8
801032e1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032e4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032eb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ee:	05 00 10 00 00       	add    $0x1000,%eax
801032f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032f8:	0f b6 03             	movzbl (%ebx),%eax
801032fb:	68 00 70 00 00       	push   $0x7000
80103300:	50                   	push   %eax
80103301:	e8 ea f7 ff ff       	call   80102af0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103306:	83 c4 10             	add    $0x10,%esp
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103310:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103316:	85 c0                	test   %eax,%eax
80103318:	74 f6                	je     80103310 <main+0x100>
8010331a:	eb 94                	jmp    801032b0 <main+0xa0>
8010331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103320:	83 ec 08             	sub    $0x8,%esp
80103323:	68 00 00 00 8e       	push   $0x8e000000
80103328:	68 00 00 40 80       	push   $0x80400000
8010332d:	e8 7e f2 ff ff       	call   801025b0 <kinit2>
  khugeinit(P2V(HUGE_PAGE_START), P2V(HUGE_PAGE_END));
80103332:	58                   	pop    %eax
80103333:	5a                   	pop    %edx
80103334:	68 00 00 00 be       	push   $0xbe000000
80103339:	68 00 00 00 9e       	push   $0x9e000000
8010333e:	e8 2d f4 ff ff       	call   80102770 <khugeinit>
  userinit();      // first user process
80103343:	e8 18 08 00 00       	call   80103b60 <userinit>
  mpmain();        // finish this processor's setup
80103348:	e8 63 fe ff ff       	call   801031b0 <mpmain>
8010334d:	66 90                	xchg   %ax,%ax
8010334f:	90                   	nop

80103350 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103355:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010335b:	53                   	push   %ebx
  e = addr+len;
8010335c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010335f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103362:	39 de                	cmp    %ebx,%esi
80103364:	72 10                	jb     80103376 <mpsearch1+0x26>
80103366:	eb 50                	jmp    801033b8 <mpsearch1+0x68>
80103368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop
80103370:	89 fe                	mov    %edi,%esi
80103372:	39 fb                	cmp    %edi,%ebx
80103374:	76 42                	jbe    801033b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103376:	83 ec 04             	sub    $0x4,%esp
80103379:	8d 7e 10             	lea    0x10(%esi),%edi
8010337c:	6a 04                	push   $0x4
8010337e:	68 38 7c 10 80       	push   $0x80107c38
80103383:	56                   	push   %esi
80103384:	e8 67 15 00 00       	call   801048f0 <memcmp>
80103389:	83 c4 10             	add    $0x10,%esp
8010338c:	85 c0                	test   %eax,%eax
8010338e:	75 e0                	jne    80103370 <mpsearch1+0x20>
80103390:	89 f2                	mov    %esi,%edx
80103392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103398:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010339b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010339e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033a0:	39 fa                	cmp    %edi,%edx
801033a2:	75 f4                	jne    80103398 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033a4:	84 c0                	test   %al,%al
801033a6:	75 c8                	jne    80103370 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ab:	89 f0                	mov    %esi,%eax
801033ad:	5b                   	pop    %ebx
801033ae:	5e                   	pop    %esi
801033af:	5f                   	pop    %edi
801033b0:	5d                   	pop    %ebp
801033b1:	c3                   	ret    
801033b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033bb:	31 f6                	xor    %esi,%esi
}
801033bd:	5b                   	pop    %ebx
801033be:	89 f0                	mov    %esi,%eax
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret    
801033c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033cf:	90                   	nop

801033d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033e7:	c1 e0 08             	shl    $0x8,%eax
801033ea:	09 d0                	or     %edx,%eax
801033ec:	c1 e0 04             	shl    $0x4,%eax
801033ef:	75 1b                	jne    8010340c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033f1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033f8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033ff:	c1 e0 08             	shl    $0x8,%eax
80103402:	09 d0                	or     %edx,%eax
80103404:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103407:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010340c:	ba 00 04 00 00       	mov    $0x400,%edx
80103411:	e8 3a ff ff ff       	call   80103350 <mpsearch1>
80103416:	89 c3                	mov    %eax,%ebx
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 84 40 01 00 00    	je     80103560 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103420:	8b 73 04             	mov    0x4(%ebx),%esi
80103423:	85 f6                	test   %esi,%esi
80103425:	0f 84 25 01 00 00    	je     80103550 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010342b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010342e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103434:	6a 04                	push   $0x4
80103436:	68 3d 7c 10 80       	push   $0x80107c3d
8010343b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010343c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010343f:	e8 ac 14 00 00       	call   801048f0 <memcmp>
80103444:	83 c4 10             	add    $0x10,%esp
80103447:	85 c0                	test   %eax,%eax
80103449:	0f 85 01 01 00 00    	jne    80103550 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010344f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103456:	3c 01                	cmp    $0x1,%al
80103458:	74 08                	je     80103462 <mpinit+0x92>
8010345a:	3c 04                	cmp    $0x4,%al
8010345c:	0f 85 ee 00 00 00    	jne    80103550 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103462:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103469:	66 85 d2             	test   %dx,%dx
8010346c:	74 22                	je     80103490 <mpinit+0xc0>
8010346e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103471:	89 f0                	mov    %esi,%eax
  sum = 0;
80103473:	31 d2                	xor    %edx,%edx
80103475:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103478:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010347f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103482:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103484:	39 c7                	cmp    %eax,%edi
80103486:	75 f0                	jne    80103478 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103488:	84 d2                	test   %dl,%dl
8010348a:	0f 85 c0 00 00 00    	jne    80103550 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103490:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103496:	a3 a4 26 11 80       	mov    %eax,0x801126a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010349b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034a2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034a8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ad:	03 55 e4             	add    -0x1c(%ebp),%edx
801034b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034b7:	90                   	nop
801034b8:	39 d0                	cmp    %edx,%eax
801034ba:	73 15                	jae    801034d1 <mpinit+0x101>
    switch(*p){
801034bc:	0f b6 08             	movzbl (%eax),%ecx
801034bf:	80 f9 02             	cmp    $0x2,%cl
801034c2:	74 4c                	je     80103510 <mpinit+0x140>
801034c4:	77 3a                	ja     80103500 <mpinit+0x130>
801034c6:	84 c9                	test   %cl,%cl
801034c8:	74 56                	je     80103520 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034ca:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034cd:	39 d0                	cmp    %edx,%eax
801034cf:	72 eb                	jb     801034bc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034d4:	85 f6                	test   %esi,%esi
801034d6:	0f 84 d9 00 00 00    	je     801035b5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034dc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034e0:	74 15                	je     801034f7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e2:	b8 70 00 00 00       	mov    $0x70,%eax
801034e7:	ba 22 00 00 00       	mov    $0x22,%edx
801034ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034ed:	ba 23 00 00 00       	mov    $0x23,%edx
801034f2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034f3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f6:	ee                   	out    %al,(%dx)
  }
}
801034f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034fa:	5b                   	pop    %ebx
801034fb:	5e                   	pop    %esi
801034fc:	5f                   	pop    %edi
801034fd:	5d                   	pop    %ebp
801034fe:	c3                   	ret    
801034ff:	90                   	nop
    switch(*p){
80103500:	83 e9 03             	sub    $0x3,%ecx
80103503:	80 f9 01             	cmp    $0x1,%cl
80103506:	76 c2                	jbe    801034ca <mpinit+0xfa>
80103508:	31 f6                	xor    %esi,%esi
8010350a:	eb ac                	jmp    801034b8 <mpinit+0xe8>
8010350c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103510:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103514:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103517:	88 0d a0 27 11 80    	mov    %cl,0x801127a0
      continue;
8010351d:	eb 99                	jmp    801034b8 <mpinit+0xe8>
8010351f:	90                   	nop
      if(ncpu < NCPU) {
80103520:	8b 0d a4 27 11 80    	mov    0x801127a4,%ecx
80103526:	83 f9 07             	cmp    $0x7,%ecx
80103529:	7f 19                	jg     80103544 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010352b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103531:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103535:	83 c1 01             	add    $0x1,%ecx
80103538:	89 0d a4 27 11 80    	mov    %ecx,0x801127a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010353e:	88 9f c0 27 11 80    	mov    %bl,-0x7feed840(%edi)
      p += sizeof(struct mpproc);
80103544:	83 c0 14             	add    $0x14,%eax
      continue;
80103547:	e9 6c ff ff ff       	jmp    801034b8 <mpinit+0xe8>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103550:	83 ec 0c             	sub    $0xc,%esp
80103553:	68 42 7c 10 80       	push   $0x80107c42
80103558:	e8 23 ce ff ff       	call   80100380 <panic>
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103560:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103565:	eb 13                	jmp    8010357a <mpinit+0x1aa>
80103567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010356e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103570:	89 f3                	mov    %esi,%ebx
80103572:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103578:	74 d6                	je     80103550 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010357a:	83 ec 04             	sub    $0x4,%esp
8010357d:	8d 73 10             	lea    0x10(%ebx),%esi
80103580:	6a 04                	push   $0x4
80103582:	68 38 7c 10 80       	push   $0x80107c38
80103587:	53                   	push   %ebx
80103588:	e8 63 13 00 00       	call   801048f0 <memcmp>
8010358d:	83 c4 10             	add    $0x10,%esp
80103590:	85 c0                	test   %eax,%eax
80103592:	75 dc                	jne    80103570 <mpinit+0x1a0>
80103594:	89 da                	mov    %ebx,%edx
80103596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035a0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035a3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035a6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035a8:	39 d6                	cmp    %edx,%esi
801035aa:	75 f4                	jne    801035a0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ac:	84 c0                	test   %al,%al
801035ae:	75 c0                	jne    80103570 <mpinit+0x1a0>
801035b0:	e9 6b fe ff ff       	jmp    80103420 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035b5:	83 ec 0c             	sub    $0xc,%esp
801035b8:	68 5c 7c 10 80       	push   $0x80107c5c
801035bd:	e8 be cd ff ff       	call   80100380 <panic>
801035c2:	66 90                	xchg   %ax,%ax
801035c4:	66 90                	xchg   %ax,%ax
801035c6:	66 90                	xchg   %ax,%ax
801035c8:	66 90                	xchg   %ax,%ax
801035ca:	66 90                	xchg   %ax,%ax
801035cc:	66 90                	xchg   %ax,%ax
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <picinit>:
801035d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035d5:	ba 21 00 00 00       	mov    $0x21,%edx
801035da:	ee                   	out    %al,(%dx)
801035db:	ba a1 00 00 00       	mov    $0xa1,%edx
801035e0:	ee                   	out    %al,(%dx)
801035e1:	c3                   	ret    
801035e2:	66 90                	xchg   %ax,%ax
801035e4:	66 90                	xchg   %ax,%ax
801035e6:	66 90                	xchg   %ax,%ax
801035e8:	66 90                	xchg   %ax,%ax
801035ea:	66 90                	xchg   %ax,%ax
801035ec:	66 90                	xchg   %ax,%ax
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 0c             	sub    $0xc,%esp
801035f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103605:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010360b:	e8 20 d8 ff ff       	call   80100e30 <filealloc>
80103610:	89 03                	mov    %eax,(%ebx)
80103612:	85 c0                	test   %eax,%eax
80103614:	0f 84 a8 00 00 00    	je     801036c2 <pipealloc+0xd2>
8010361a:	e8 11 d8 ff ff       	call   80100e30 <filealloc>
8010361f:	89 06                	mov    %eax,(%esi)
80103621:	85 c0                	test   %eax,%eax
80103623:	0f 84 87 00 00 00    	je     801036b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103629:	e8 92 f1 ff ff       	call   801027c0 <kalloc>
8010362e:	89 c7                	mov    %eax,%edi
80103630:	85 c0                	test   %eax,%eax
80103632:	0f 84 b0 00 00 00    	je     801036e8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103638:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010363f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103642:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103645:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010364c:	00 00 00 
  p->nwrite = 0;
8010364f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103656:	00 00 00 
  p->nread = 0;
80103659:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103660:	00 00 00 
  initlock(&p->lock, "pipe");
80103663:	68 7b 7c 10 80       	push   $0x80107c7b
80103668:	50                   	push   %eax
80103669:	e8 a2 0f 00 00       	call   80104610 <initlock>
  (*f0)->type = FD_PIPE;
8010366e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103670:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103673:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103679:	8b 03                	mov    (%ebx),%eax
8010367b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010367f:	8b 03                	mov    (%ebx),%eax
80103681:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103685:	8b 03                	mov    (%ebx),%eax
80103687:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010368a:	8b 06                	mov    (%esi),%eax
8010368c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103692:	8b 06                	mov    (%esi),%eax
80103694:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103698:	8b 06                	mov    (%esi),%eax
8010369a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010369e:	8b 06                	mov    (%esi),%eax
801036a0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036a6:	31 c0                	xor    %eax,%eax
}
801036a8:	5b                   	pop    %ebx
801036a9:	5e                   	pop    %esi
801036aa:	5f                   	pop    %edi
801036ab:	5d                   	pop    %ebp
801036ac:	c3                   	ret    
801036ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801036b0:	8b 03                	mov    (%ebx),%eax
801036b2:	85 c0                	test   %eax,%eax
801036b4:	74 1e                	je     801036d4 <pipealloc+0xe4>
    fileclose(*f0);
801036b6:	83 ec 0c             	sub    $0xc,%esp
801036b9:	50                   	push   %eax
801036ba:	e8 31 d8 ff ff       	call   80100ef0 <fileclose>
801036bf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036c2:	8b 06                	mov    (%esi),%eax
801036c4:	85 c0                	test   %eax,%eax
801036c6:	74 0c                	je     801036d4 <pipealloc+0xe4>
    fileclose(*f1);
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	50                   	push   %eax
801036cc:	e8 1f d8 ff ff       	call   80100ef0 <fileclose>
801036d1:	83 c4 10             	add    $0x10,%esp
}
801036d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036dc:	5b                   	pop    %ebx
801036dd:	5e                   	pop    %esi
801036de:	5f                   	pop    %edi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret    
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801036e8:	8b 03                	mov    (%ebx),%eax
801036ea:	85 c0                	test   %eax,%eax
801036ec:	75 c8                	jne    801036b6 <pipealloc+0xc6>
801036ee:	eb d2                	jmp    801036c2 <pipealloc+0xd2>

801036f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	56                   	push   %esi
801036f4:	53                   	push   %ebx
801036f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	53                   	push   %ebx
801036ff:	e8 dc 10 00 00       	call   801047e0 <acquire>
  if(writable){
80103704:	83 c4 10             	add    $0x10,%esp
80103707:	85 f6                	test   %esi,%esi
80103709:	74 65                	je     80103770 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103714:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010371b:	00 00 00 
    wakeup(&p->nread);
8010371e:	50                   	push   %eax
8010371f:	e8 1c 0c 00 00       	call   80104340 <wakeup>
80103724:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103727:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010372d:	85 d2                	test   %edx,%edx
8010372f:	75 0a                	jne    8010373b <pipeclose+0x4b>
80103731:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103737:	85 c0                	test   %eax,%eax
80103739:	74 15                	je     80103750 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010373b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010373e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103741:	5b                   	pop    %ebx
80103742:	5e                   	pop    %esi
80103743:	5d                   	pop    %ebp
    release(&p->lock);
80103744:	e9 37 10 00 00       	jmp    80104780 <release>
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103750:	83 ec 0c             	sub    $0xc,%esp
80103753:	53                   	push   %ebx
80103754:	e8 27 10 00 00       	call   80104780 <release>
    kfree((char*)p);
80103759:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010375c:	83 c4 10             	add    $0x10,%esp
}
8010375f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103762:	5b                   	pop    %ebx
80103763:	5e                   	pop    %esi
80103764:	5d                   	pop    %ebp
    kfree((char*)p);
80103765:	e9 56 ed ff ff       	jmp    801024c0 <kfree>
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103779:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103780:	00 00 00 
    wakeup(&p->nwrite);
80103783:	50                   	push   %eax
80103784:	e8 b7 0b 00 00       	call   80104340 <wakeup>
80103789:	83 c4 10             	add    $0x10,%esp
8010378c:	eb 99                	jmp    80103727 <pipeclose+0x37>
8010378e:	66 90                	xchg   %ax,%ax

80103790 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 28             	sub    $0x28,%esp
80103799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010379c:	53                   	push   %ebx
8010379d:	e8 3e 10 00 00       	call   801047e0 <acquire>
  for(i = 0; i < n; i++){
801037a2:	8b 45 10             	mov    0x10(%ebp),%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	0f 8e c0 00 00 00    	jle    80103870 <pipewrite+0xe0>
801037b0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037b3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037c2:	03 45 10             	add    0x10(%ebp),%eax
801037c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037ce:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d4:	89 ca                	mov    %ecx,%edx
801037d6:	05 00 02 00 00       	add    $0x200,%eax
801037db:	39 c1                	cmp    %eax,%ecx
801037dd:	74 3f                	je     8010381e <pipewrite+0x8e>
801037df:	eb 67                	jmp    80103848 <pipewrite+0xb8>
801037e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801037e8:	e8 43 03 00 00       	call   80103b30 <myproc>
801037ed:	8b 48 28             	mov    0x28(%eax),%ecx
801037f0:	85 c9                	test   %ecx,%ecx
801037f2:	75 34                	jne    80103828 <pipewrite+0x98>
      wakeup(&p->nread);
801037f4:	83 ec 0c             	sub    $0xc,%esp
801037f7:	57                   	push   %edi
801037f8:	e8 43 0b 00 00       	call   80104340 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037fd:	58                   	pop    %eax
801037fe:	5a                   	pop    %edx
801037ff:	53                   	push   %ebx
80103800:	56                   	push   %esi
80103801:	e8 7a 0a 00 00       	call   80104280 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103806:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010380c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103812:	83 c4 10             	add    $0x10,%esp
80103815:	05 00 02 00 00       	add    $0x200,%eax
8010381a:	39 c2                	cmp    %eax,%edx
8010381c:	75 2a                	jne    80103848 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010381e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103824:	85 c0                	test   %eax,%eax
80103826:	75 c0                	jne    801037e8 <pipewrite+0x58>
        release(&p->lock);
80103828:	83 ec 0c             	sub    $0xc,%esp
8010382b:	53                   	push   %ebx
8010382c:	e8 4f 0f 00 00       	call   80104780 <release>
        return -1;
80103831:	83 c4 10             	add    $0x10,%esp
80103834:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010383c:	5b                   	pop    %ebx
8010383d:	5e                   	pop    %esi
8010383e:	5f                   	pop    %edi
8010383f:	5d                   	pop    %ebp
80103840:	c3                   	ret    
80103841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103848:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010384b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010384e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103854:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010385a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010385d:	83 c6 01             	add    $0x1,%esi
80103860:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103863:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103867:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010386a:	0f 85 58 ff ff ff    	jne    801037c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103879:	50                   	push   %eax
8010387a:	e8 c1 0a 00 00       	call   80104340 <wakeup>
  release(&p->lock);
8010387f:	89 1c 24             	mov    %ebx,(%esp)
80103882:	e8 f9 0e 00 00       	call   80104780 <release>
  return n;
80103887:	8b 45 10             	mov    0x10(%ebp),%eax
8010388a:	83 c4 10             	add    $0x10,%esp
8010388d:	eb aa                	jmp    80103839 <pipewrite+0xa9>
8010388f:	90                   	nop

80103890 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 18             	sub    $0x18,%esp
80103899:	8b 75 08             	mov    0x8(%ebp),%esi
8010389c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010389f:	56                   	push   %esi
801038a0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038a6:	e8 35 0f 00 00       	call   801047e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ab:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038b1:	83 c4 10             	add    $0x10,%esp
801038b4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038ba:	74 2f                	je     801038eb <piperead+0x5b>
801038bc:	eb 37                	jmp    801038f5 <piperead+0x65>
801038be:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038c0:	e8 6b 02 00 00       	call   80103b30 <myproc>
801038c5:	8b 48 28             	mov    0x28(%eax),%ecx
801038c8:	85 c9                	test   %ecx,%ecx
801038ca:	0f 85 80 00 00 00    	jne    80103950 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038d0:	83 ec 08             	sub    $0x8,%esp
801038d3:	56                   	push   %esi
801038d4:	53                   	push   %ebx
801038d5:	e8 a6 09 00 00       	call   80104280 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038da:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801038e0:	83 c4 10             	add    $0x10,%esp
801038e3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801038e9:	75 0a                	jne    801038f5 <piperead+0x65>
801038eb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801038f1:	85 c0                	test   %eax,%eax
801038f3:	75 cb                	jne    801038c0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038f5:	8b 55 10             	mov    0x10(%ebp),%edx
801038f8:	31 db                	xor    %ebx,%ebx
801038fa:	85 d2                	test   %edx,%edx
801038fc:	7f 20                	jg     8010391e <piperead+0x8e>
801038fe:	eb 2c                	jmp    8010392c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103900:	8d 48 01             	lea    0x1(%eax),%ecx
80103903:	25 ff 01 00 00       	and    $0x1ff,%eax
80103908:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010390e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103913:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103916:	83 c3 01             	add    $0x1,%ebx
80103919:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010391c:	74 0e                	je     8010392c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010391e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103924:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010392a:	75 d4                	jne    80103900 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010392c:	83 ec 0c             	sub    $0xc,%esp
8010392f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103935:	50                   	push   %eax
80103936:	e8 05 0a 00 00       	call   80104340 <wakeup>
  release(&p->lock);
8010393b:	89 34 24             	mov    %esi,(%esp)
8010393e:	e8 3d 0e 00 00       	call   80104780 <release>
  return i;
80103943:	83 c4 10             	add    $0x10,%esp
}
80103946:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103949:	89 d8                	mov    %ebx,%eax
8010394b:	5b                   	pop    %ebx
8010394c:	5e                   	pop    %esi
8010394d:	5f                   	pop    %edi
8010394e:	5d                   	pop    %ebp
8010394f:	c3                   	ret    
      release(&p->lock);
80103950:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103953:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103958:	56                   	push   %esi
80103959:	e8 22 0e 00 00       	call   80104780 <release>
      return -1;
8010395e:	83 c4 10             	add    $0x10,%esp
}
80103961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103964:	89 d8                	mov    %ebx,%eax
80103966:	5b                   	pop    %ebx
80103967:	5e                   	pop    %esi
80103968:	5f                   	pop    %edi
80103969:	5d                   	pop    %ebp
8010396a:	c3                   	ret    
8010396b:	66 90                	xchg   %ax,%ax
8010396d:	66 90                	xchg   %ax,%ax
8010396f:	90                   	nop

80103970 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103974:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
80103979:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010397c:	68 40 2d 11 80       	push   $0x80112d40
80103981:	e8 5a 0e 00 00       	call   801047e0 <acquire>
80103986:	83 c4 10             	add    $0x10,%esp
80103989:	eb 10                	jmp    8010399b <allocproc+0x2b>
8010398b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103990:	83 eb 80             	sub    $0xffffff80,%ebx
80103993:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80103999:	74 75                	je     80103a10 <allocproc+0xa0>
    if(p->state == UNUSED)
8010399b:	8b 43 10             	mov    0x10(%ebx),%eax
8010399e:	85 c0                	test   %eax,%eax
801039a0:	75 ee                	jne    80103990 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039a2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039a7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039aa:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039b1:	89 43 14             	mov    %eax,0x14(%ebx)
801039b4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039b7:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
801039bc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039c2:	e8 b9 0d 00 00       	call   80104780 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039c7:	e8 f4 ed ff ff       	call   801027c0 <kalloc>
801039cc:	83 c4 10             	add    $0x10,%esp
801039cf:	89 43 0c             	mov    %eax,0xc(%ebx)
801039d2:	85 c0                	test   %eax,%eax
801039d4:	74 53                	je     80103a29 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039dc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039df:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039e4:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
801039e7:	c7 40 14 10 5c 10 80 	movl   $0x80105c10,0x14(%eax)
  p->context = (struct context*)sp;
801039ee:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039f1:	6a 14                	push   $0x14
801039f3:	6a 00                	push   $0x0
801039f5:	50                   	push   %eax
801039f6:	e8 a5 0e 00 00       	call   801048a0 <memset>
  p->context->eip = (uint)forkret;
801039fb:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
801039fe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a01:	c7 40 10 40 3a 10 80 	movl   $0x80103a40,0x10(%eax)
}
80103a08:	89 d8                	mov    %ebx,%eax
80103a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a0d:	c9                   	leave  
80103a0e:	c3                   	ret    
80103a0f:	90                   	nop
  release(&ptable.lock);
80103a10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a15:	68 40 2d 11 80       	push   $0x80112d40
80103a1a:	e8 61 0d 00 00       	call   80104780 <release>
}
80103a1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a21:	83 c4 10             	add    $0x10,%esp
}
80103a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a27:	c9                   	leave  
80103a28:	c3                   	ret    
    p->state = UNUSED;
80103a29:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103a30:	31 db                	xor    %ebx,%ebx
}
80103a32:	89 d8                	mov    %ebx,%eax
80103a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a37:	c9                   	leave  
80103a38:	c3                   	ret    
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a46:	68 40 2d 11 80       	push   $0x80112d40
80103a4b:	e8 30 0d 00 00       	call   80104780 <release>

  if (first) {
80103a50:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	85 c0                	test   %eax,%eax
80103a5a:	75 04                	jne    80103a60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a5c:	c9                   	leave  
80103a5d:	c3                   	ret    
80103a5e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a60:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a67:	00 00 00 
    iinit(ROOTDEV);
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	6a 01                	push   $0x1
80103a6f:	e8 ec da ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a7b:	e8 f0 f3 ff ff       	call   80102e70 <initlog>
}
80103a80:	83 c4 10             	add    $0x10,%esp
80103a83:	c9                   	leave  
80103a84:	c3                   	ret    
80103a85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a90 <pinit>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a96:	68 80 7c 10 80       	push   $0x80107c80
80103a9b:	68 40 2d 11 80       	push   $0x80112d40
80103aa0:	e8 6b 0b 00 00       	call   80104610 <initlock>
}
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	c9                   	leave  
80103aa9:	c3                   	ret    
80103aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ab0 <mycpu>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ab5:	9c                   	pushf  
80103ab6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ab7:	f6 c4 02             	test   $0x2,%ah
80103aba:	75 46                	jne    80103b02 <mycpu+0x52>
  apicid = lapicid();
80103abc:	e8 df ef ff ff       	call   80102aa0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ac1:	8b 35 a4 27 11 80    	mov    0x801127a4,%esi
80103ac7:	85 f6                	test   %esi,%esi
80103ac9:	7e 2a                	jle    80103af5 <mycpu+0x45>
80103acb:	31 d2                	xor    %edx,%edx
80103acd:	eb 08                	jmp    80103ad7 <mycpu+0x27>
80103acf:	90                   	nop
80103ad0:	83 c2 01             	add    $0x1,%edx
80103ad3:	39 f2                	cmp    %esi,%edx
80103ad5:	74 1e                	je     80103af5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ad7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103add:	0f b6 99 c0 27 11 80 	movzbl -0x7feed840(%ecx),%ebx
80103ae4:	39 c3                	cmp    %eax,%ebx
80103ae6:	75 e8                	jne    80103ad0 <mycpu+0x20>
}
80103ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103aeb:	8d 81 c0 27 11 80    	lea    -0x7feed840(%ecx),%eax
}
80103af1:	5b                   	pop    %ebx
80103af2:	5e                   	pop    %esi
80103af3:	5d                   	pop    %ebp
80103af4:	c3                   	ret    
  panic("unknown apicid\n");
80103af5:	83 ec 0c             	sub    $0xc,%esp
80103af8:	68 87 7c 10 80       	push   $0x80107c87
80103afd:	e8 7e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b02:	83 ec 0c             	sub    $0xc,%esp
80103b05:	68 64 7d 10 80       	push   $0x80107d64
80103b0a:	e8 71 c8 ff ff       	call   80100380 <panic>
80103b0f:	90                   	nop

80103b10 <cpuid>:
cpuid() {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b16:	e8 95 ff ff ff       	call   80103ab0 <mycpu>
}
80103b1b:	c9                   	leave  
  return mycpu()-cpus;
80103b1c:	2d c0 27 11 80       	sub    $0x801127c0,%eax
80103b21:	c1 f8 04             	sar    $0x4,%eax
80103b24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b2a:	c3                   	ret    
80103b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <myproc>:
myproc(void) {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	53                   	push   %ebx
80103b34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b37:	e8 54 0b 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103b3c:	e8 6f ff ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103b41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b47:	e8 94 0b 00 00       	call   801046e0 <popcli>
}
80103b4c:	89 d8                	mov    %ebx,%eax
80103b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b51:	c9                   	leave  
80103b52:	c3                   	ret    
80103b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b60 <userinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b67:	e8 04 fe ff ff       	call   80103970 <allocproc>
80103b6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b6e:	a3 74 4d 11 80       	mov    %eax,0x80114d74
  if((p->pgdir = setupkvm()) == 0)
80103b73:	e8 78 38 00 00       	call   801073f0 <setupkvm>
80103b78:	89 43 08             	mov    %eax,0x8(%ebx)
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	0f 84 bd 00 00 00    	je     80103c40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b83:	83 ec 04             	sub    $0x4,%esp
80103b86:	68 2c 00 00 00       	push   $0x2c
80103b8b:	68 70 b4 10 80       	push   $0x8010b470
80103b90:	50                   	push   %eax
80103b91:	e8 ca 33 00 00       	call   80106f60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b9f:	6a 4c                	push   $0x4c
80103ba1:	6a 00                	push   $0x0
80103ba3:	ff 73 1c             	push   0x1c(%ebx)
80103ba6:	e8 f5 0c 00 00       	call   801048a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bb3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bb6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bbf:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bc6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bd1:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bdc:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103be6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bf0:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bfa:	8d 43 70             	lea    0x70(%ebx),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	68 b0 7c 10 80       	push   $0x80107cb0
80103c04:	50                   	push   %eax
80103c05:	e8 56 0e 00 00       	call   80104a60 <safestrcpy>
  p->cwd = namei("/");
80103c0a:	c7 04 24 b9 7c 10 80 	movl   $0x80107cb9,(%esp)
80103c11:	e8 8a e4 ff ff       	call   801020a0 <namei>
80103c16:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c19:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c20:	e8 bb 0b 00 00       	call   801047e0 <acquire>
  p->state = RUNNABLE;
80103c25:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c2c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c33:	e8 48 0b 00 00       	call   80104780 <release>
}
80103c38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c3b:	83 c4 10             	add    $0x10,%esp
80103c3e:	c9                   	leave  
80103c3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	68 97 7c 10 80       	push   $0x80107c97
80103c48:	e8 33 c7 ff ff       	call   80100380 <panic>
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi

80103c50 <growproc>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
80103c55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c58:	e8 33 0a 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103c5d:	e8 4e fe ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103c62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c68:	e8 73 0a 00 00       	call   801046e0 <popcli>
  sz = curproc->sz;
80103c6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c6f:	85 f6                	test   %esi,%esi
80103c71:	7f 1d                	jg     80103c90 <growproc+0x40>
  } else if(n < 0){
80103c73:	75 3b                	jne    80103cb0 <growproc+0x60>
  switchuvm(curproc);
80103c75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c7a:	53                   	push   %ebx
80103c7b:	e8 d0 31 00 00       	call   80106e50 <switchuvm>
  return 0;
80103c80:	83 c4 10             	add    $0x10,%esp
80103c83:	31 c0                	xor    %eax,%eax
}
80103c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c88:	5b                   	pop    %ebx
80103c89:	5e                   	pop    %esi
80103c8a:	5d                   	pop    %ebp
80103c8b:	c3                   	ret    
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 08             	push   0x8(%ebx)
80103c9a:	e8 31 34 00 00       	call   801070d0 <allocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 cf                	jne    80103c75 <growproc+0x25>
      return -1;
80103ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cab:	eb d8                	jmp    80103c85 <growproc+0x35>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 08             	push   0x8(%ebx)
80103cba:	e8 51 36 00 00       	call   80107310 <deallocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 af                	jne    80103c75 <growproc+0x25>
80103cc6:	eb de                	jmp    80103ca6 <growproc+0x56>
80103cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccf:	90                   	nop

80103cd0 <growhugeproc>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
80103cd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cd8:	e8 b3 09 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103cdd:	e8 ce fd ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103ce2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce8:	e8 f3 09 00 00       	call   801046e0 <popcli>
  sz = curproc->hugesz;
80103ced:	8b 43 04             	mov    0x4(%ebx),%eax
  if(n > 0){
80103cf0:	85 f6                	test   %esi,%esi
80103cf2:	7f 1c                	jg     80103d10 <growhugeproc+0x40>
  } else if(n < 0){
80103cf4:	75 3a                	jne    80103d30 <growhugeproc+0x60>
  switchuvm(curproc);
80103cf6:	83 ec 0c             	sub    $0xc,%esp
  curproc->hugesz = sz;
80103cf9:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103cfc:	53                   	push   %ebx
80103cfd:	e8 4e 31 00 00       	call   80106e50 <switchuvm>
  return 0;
80103d02:	83 c4 10             	add    $0x10,%esp
80103d05:	31 c0                	xor    %eax,%eax
}
80103d07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d0a:	5b                   	pop    %ebx
80103d0b:	5e                   	pop    %esi
80103d0c:	5d                   	pop    %ebp
80103d0d:	c3                   	ret    
80103d0e:	66 90                	xchg   %ax,%ax
    if((sz = allochugeuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d10:	83 ec 04             	sub    $0x4,%esp
80103d13:	01 c6                	add    %eax,%esi
80103d15:	56                   	push   %esi
80103d16:	50                   	push   %eax
80103d17:	ff 73 08             	push   0x8(%ebx)
80103d1a:	e8 e1 34 00 00       	call   80107200 <allochugeuvm>
80103d1f:	83 c4 10             	add    $0x10,%esp
80103d22:	85 c0                	test   %eax,%eax
80103d24:	75 d0                	jne    80103cf6 <growhugeproc+0x26>
      return -1;
80103d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d2b:	eb da                	jmp    80103d07 <growhugeproc+0x37>
80103d2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallochugeuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d30:	83 ec 04             	sub    $0x4,%esp
80103d33:	01 c6                	add    %eax,%esi
80103d35:	56                   	push   %esi
80103d36:	50                   	push   %eax
80103d37:	ff 73 08             	push   0x8(%ebx)
80103d3a:	e8 01 36 00 00       	call   80107340 <deallochugeuvm>
80103d3f:	83 c4 10             	add    $0x10,%esp
80103d42:	85 c0                	test   %eax,%eax
80103d44:	75 b0                	jne    80103cf6 <growhugeproc+0x26>
80103d46:	eb de                	jmp    80103d26 <growhugeproc+0x56>
80103d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4f:	90                   	nop

80103d50 <fork>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d59:	e8 32 09 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103d5e:	e8 4d fd ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103d63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d69:	e8 72 09 00 00       	call   801046e0 <popcli>
  if((np = allocproc()) == 0){
80103d6e:	e8 fd fb ff ff       	call   80103970 <allocproc>
80103d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d76:	85 c0                	test   %eax,%eax
80103d78:	0f 84 b7 00 00 00    	je     80103e35 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d7e:	83 ec 08             	sub    $0x8,%esp
80103d81:	ff 33                	push   (%ebx)
80103d83:	89 c7                	mov    %eax,%edi
80103d85:	ff 73 08             	push   0x8(%ebx)
80103d88:	e8 53 37 00 00       	call   801074e0 <copyuvm>
80103d8d:	83 c4 10             	add    $0x10,%esp
80103d90:	89 47 08             	mov    %eax,0x8(%edi)
80103d93:	85 c0                	test   %eax,%eax
80103d95:	0f 84 a1 00 00 00    	je     80103e3c <fork+0xec>
  np->sz = curproc->sz;
80103d9b:	8b 03                	mov    (%ebx),%eax
80103d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103da0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103da2:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103da5:	89 c8                	mov    %ecx,%eax
80103da7:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103daa:	b9 13 00 00 00       	mov    $0x13,%ecx
80103daf:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103db2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103db4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103db6:	8b 40 1c             	mov    0x1c(%eax),%eax
80103db9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103dc0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	74 13                	je     80103ddb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	50                   	push   %eax
80103dcc:	e8 cf d0 ff ff       	call   80100ea0 <filedup>
80103dd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dd4:	83 c4 10             	add    $0x10,%esp
80103dd7:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ddb:	83 c6 01             	add    $0x1,%esi
80103dde:	83 fe 10             	cmp    $0x10,%esi
80103de1:	75 dd                	jne    80103dc0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103de3:	83 ec 0c             	sub    $0xc,%esp
80103de6:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103de9:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103dec:	e8 5f d9 ff ff       	call   80101750 <idup>
80103df1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103df7:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dfa:	8d 47 70             	lea    0x70(%edi),%eax
80103dfd:	6a 10                	push   $0x10
80103dff:	53                   	push   %ebx
80103e00:	50                   	push   %eax
80103e01:	e8 5a 0c 00 00       	call   80104a60 <safestrcpy>
  pid = np->pid;
80103e06:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103e09:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e10:	e8 cb 09 00 00       	call   801047e0 <acquire>
  np->state = RUNNABLE;
80103e15:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103e1c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e23:	e8 58 09 00 00       	call   80104780 <release>
  return pid;
80103e28:	83 c4 10             	add    $0x10,%esp
}
80103e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e2e:	89 d8                	mov    %ebx,%eax
80103e30:	5b                   	pop    %ebx
80103e31:	5e                   	pop    %esi
80103e32:	5f                   	pop    %edi
80103e33:	5d                   	pop    %ebp
80103e34:	c3                   	ret    
    return -1;
80103e35:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e3a:	eb ef                	jmp    80103e2b <fork+0xdb>
    kfree(np->kstack);
80103e3c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e3f:	83 ec 0c             	sub    $0xc,%esp
80103e42:	ff 73 0c             	push   0xc(%ebx)
80103e45:	e8 76 e6 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103e4a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e51:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e54:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103e5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e60:	eb c9                	jmp    80103e2b <fork+0xdb>
80103e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e70 <scheduler>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e79:	e8 32 fc ff ff       	call   80103ab0 <mycpu>
  c->proc = 0;
80103e7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e85:	00 00 00 
  struct cpu *c = mycpu();
80103e88:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e8a:	8d 78 04             	lea    0x4(%eax),%edi
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e90:	fb                   	sti    
    acquire(&ptable.lock);
80103e91:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e94:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
80103e99:	68 40 2d 11 80       	push   $0x80112d40
80103e9e:	e8 3d 09 00 00       	call   801047e0 <acquire>
80103ea3:	83 c4 10             	add    $0x10,%esp
80103ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103eb0:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103eb4:	75 33                	jne    80103ee9 <scheduler+0x79>
      switchuvm(p);
80103eb6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103eb9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ebf:	53                   	push   %ebx
80103ec0:	e8 8b 2f 00 00       	call   80106e50 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ec5:	58                   	pop    %eax
80103ec6:	5a                   	pop    %edx
80103ec7:	ff 73 20             	push   0x20(%ebx)
80103eca:	57                   	push   %edi
      p->state = RUNNING;
80103ecb:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103ed2:	e8 e4 0b 00 00       	call   80104abb <swtch>
      switchkvm();
80103ed7:	e8 64 2f 00 00       	call   80106e40 <switchkvm>
      c->proc = 0;
80103edc:	83 c4 10             	add    $0x10,%esp
80103edf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ee6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee9:	83 eb 80             	sub    $0xffffff80,%ebx
80103eec:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80103ef2:	75 bc                	jne    80103eb0 <scheduler+0x40>
    release(&ptable.lock);
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	68 40 2d 11 80       	push   $0x80112d40
80103efc:	e8 7f 08 00 00       	call   80104780 <release>
    sti();
80103f01:	83 c4 10             	add    $0x10,%esp
80103f04:	eb 8a                	jmp    80103e90 <scheduler+0x20>
80103f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi

80103f10 <sched>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
  pushcli();
80103f15:	e8 76 07 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103f1a:	e8 91 fb ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103f1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f25:	e8 b6 07 00 00       	call   801046e0 <popcli>
  if(!holding(&ptable.lock))
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 40 2d 11 80       	push   $0x80112d40
80103f32:	e8 09 08 00 00       	call   80104740 <holding>
80103f37:	83 c4 10             	add    $0x10,%esp
80103f3a:	85 c0                	test   %eax,%eax
80103f3c:	74 4f                	je     80103f8d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f3e:	e8 6d fb ff ff       	call   80103ab0 <mycpu>
80103f43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f4a:	75 68                	jne    80103fb4 <sched+0xa4>
  if(p->state == RUNNING)
80103f4c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f50:	74 55                	je     80103fa7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f52:	9c                   	pushf  
80103f53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f54:	f6 c4 02             	test   $0x2,%ah
80103f57:	75 41                	jne    80103f9a <sched+0x8a>
  intena = mycpu()->intena;
80103f59:	e8 52 fb ff ff       	call   80103ab0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f5e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103f61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f67:	e8 44 fb ff ff       	call   80103ab0 <mycpu>
80103f6c:	83 ec 08             	sub    $0x8,%esp
80103f6f:	ff 70 04             	push   0x4(%eax)
80103f72:	53                   	push   %ebx
80103f73:	e8 43 0b 00 00       	call   80104abb <swtch>
  mycpu()->intena = intena;
80103f78:	e8 33 fb ff ff       	call   80103ab0 <mycpu>
}
80103f7d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f89:	5b                   	pop    %ebx
80103f8a:	5e                   	pop    %esi
80103f8b:	5d                   	pop    %ebp
80103f8c:	c3                   	ret    
    panic("sched ptable.lock");
80103f8d:	83 ec 0c             	sub    $0xc,%esp
80103f90:	68 bb 7c 10 80       	push   $0x80107cbb
80103f95:	e8 e6 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 e7 7c 10 80       	push   $0x80107ce7
80103fa2:	e8 d9 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80103fa7:	83 ec 0c             	sub    $0xc,%esp
80103faa:	68 d9 7c 10 80       	push   $0x80107cd9
80103faf:	e8 cc c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 cd 7c 10 80       	push   $0x80107ccd
80103fbc:	e8 bf c3 ff ff       	call   80100380 <panic>
80103fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcf:	90                   	nop

80103fd0 <exit>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fd9:	e8 52 fb ff ff       	call   80103b30 <myproc>
  if(curproc == initproc)
80103fde:	39 05 74 4d 11 80    	cmp    %eax,0x80114d74
80103fe4:	0f 84 fd 00 00 00    	je     801040e7 <exit+0x117>
80103fea:	89 c3                	mov    %eax,%ebx
80103fec:	8d 70 2c             	lea    0x2c(%eax),%esi
80103fef:	8d 78 6c             	lea    0x6c(%eax),%edi
80103ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ff8:	8b 06                	mov    (%esi),%eax
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	74 12                	je     80104010 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	50                   	push   %eax
80104002:	e8 e9 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104007:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010400d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104010:	83 c6 04             	add    $0x4,%esi
80104013:	39 f7                	cmp    %esi,%edi
80104015:	75 e1                	jne    80103ff8 <exit+0x28>
  begin_op();
80104017:	e8 f4 ee ff ff       	call   80102f10 <begin_op>
  iput(curproc->cwd);
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	ff 73 6c             	push   0x6c(%ebx)
80104022:	e8 89 d8 ff ff       	call   801018b0 <iput>
  end_op();
80104027:	e8 54 ef ff ff       	call   80102f80 <end_op>
  curproc->cwd = 0;
8010402c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104033:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010403a:	e8 a1 07 00 00       	call   801047e0 <acquire>
  wakeup1(curproc->parent);
8010403f:	8b 53 18             	mov    0x18(%ebx),%edx
80104042:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104045:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010404a:	eb 0e                	jmp    8010405a <exit+0x8a>
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104050:	83 e8 80             	sub    $0xffffff80,%eax
80104053:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104058:	74 1c                	je     80104076 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010405a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010405e:	75 f0                	jne    80104050 <exit+0x80>
80104060:	3b 50 24             	cmp    0x24(%eax),%edx
80104063:	75 eb                	jne    80104050 <exit+0x80>
      p->state = RUNNABLE;
80104065:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010406c:	83 e8 80             	sub    $0xffffff80,%eax
8010406f:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104074:	75 e4                	jne    8010405a <exit+0x8a>
      p->parent = initproc;
80104076:	8b 0d 74 4d 11 80    	mov    0x80114d74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407c:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80104081:	eb 10                	jmp    80104093 <exit+0xc3>
80104083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104087:	90                   	nop
80104088:	83 ea 80             	sub    $0xffffff80,%edx
8010408b:	81 fa 74 4d 11 80    	cmp    $0x80114d74,%edx
80104091:	74 3b                	je     801040ce <exit+0xfe>
    if(p->parent == curproc){
80104093:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104096:	75 f0                	jne    80104088 <exit+0xb8>
      if(p->state == ZOMBIE)
80104098:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
8010409c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010409f:	75 e7                	jne    80104088 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a1:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801040a6:	eb 12                	jmp    801040ba <exit+0xea>
801040a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040af:	90                   	nop
801040b0:	83 e8 80             	sub    $0xffffff80,%eax
801040b3:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801040b8:	74 ce                	je     80104088 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801040ba:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040be:	75 f0                	jne    801040b0 <exit+0xe0>
801040c0:	3b 48 24             	cmp    0x24(%eax),%ecx
801040c3:	75 eb                	jne    801040b0 <exit+0xe0>
      p->state = RUNNABLE;
801040c5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
801040cc:	eb e2                	jmp    801040b0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040ce:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
801040d5:	e8 36 fe ff ff       	call   80103f10 <sched>
  panic("zombie exit");
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 08 7d 10 80       	push   $0x80107d08
801040e2:	e8 99 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	68 fb 7c 10 80       	push   $0x80107cfb
801040ef:	e8 8c c2 ff ff       	call   80100380 <panic>
801040f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ff:	90                   	nop

80104100 <wait>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
  pushcli();
80104105:	e8 86 05 00 00       	call   80104690 <pushcli>
  c = mycpu();
8010410a:	e8 a1 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010410f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104115:	e8 c6 05 00 00       	call   801046e0 <popcli>
  acquire(&ptable.lock);
8010411a:	83 ec 0c             	sub    $0xc,%esp
8010411d:	68 40 2d 11 80       	push   $0x80112d40
80104122:	e8 b9 06 00 00       	call   801047e0 <acquire>
80104127:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010412a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80104131:	eb 10                	jmp    80104143 <wait+0x43>
80104133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104137:	90                   	nop
80104138:	83 eb 80             	sub    $0xffffff80,%ebx
8010413b:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80104141:	74 1b                	je     8010415e <wait+0x5e>
      if(p->parent != curproc)
80104143:	39 73 18             	cmp    %esi,0x18(%ebx)
80104146:	75 f0                	jne    80104138 <wait+0x38>
      if(p->state == ZOMBIE){
80104148:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010414c:	74 62                	je     801041b0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104151:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104156:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
8010415c:	75 e5                	jne    80104143 <wait+0x43>
    if(!havekids || curproc->killed){
8010415e:	85 c0                	test   %eax,%eax
80104160:	0f 84 a0 00 00 00    	je     80104206 <wait+0x106>
80104166:	8b 46 28             	mov    0x28(%esi),%eax
80104169:	85 c0                	test   %eax,%eax
8010416b:	0f 85 95 00 00 00    	jne    80104206 <wait+0x106>
  pushcli();
80104171:	e8 1a 05 00 00       	call   80104690 <pushcli>
  c = mycpu();
80104176:	e8 35 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010417b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104181:	e8 5a 05 00 00       	call   801046e0 <popcli>
  if(p == 0)
80104186:	85 db                	test   %ebx,%ebx
80104188:	0f 84 8f 00 00 00    	je     8010421d <wait+0x11d>
  p->chan = chan;
8010418e:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
80104191:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104198:	e8 73 fd ff ff       	call   80103f10 <sched>
  p->chan = 0;
8010419d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801041a4:	eb 84                	jmp    8010412a <wait+0x2a>
801041a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801041b0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041b3:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801041b6:	ff 73 0c             	push   0xc(%ebx)
801041b9:	e8 02 e3 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801041be:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
801041c5:	5a                   	pop    %edx
801041c6:	ff 73 08             	push   0x8(%ebx)
801041c9:	e8 a2 31 00 00       	call   80107370 <freevm>
        p->pid = 0;
801041ce:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041d5:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041dc:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801041e0:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
801041e7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801041ee:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801041f5:	e8 86 05 00 00       	call   80104780 <release>
        return pid;
801041fa:	83 c4 10             	add    $0x10,%esp
}
801041fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104200:	89 f0                	mov    %esi,%eax
80104202:	5b                   	pop    %ebx
80104203:	5e                   	pop    %esi
80104204:	5d                   	pop    %ebp
80104205:	c3                   	ret    
      release(&ptable.lock);
80104206:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104209:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010420e:	68 40 2d 11 80       	push   $0x80112d40
80104213:	e8 68 05 00 00       	call   80104780 <release>
      return -1;
80104218:	83 c4 10             	add    $0x10,%esp
8010421b:	eb e0                	jmp    801041fd <wait+0xfd>
    panic("sleep");
8010421d:	83 ec 0c             	sub    $0xc,%esp
80104220:	68 14 7d 10 80       	push   $0x80107d14
80104225:	e8 56 c1 ff ff       	call   80100380 <panic>
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <yield>:
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104237:	68 40 2d 11 80       	push   $0x80112d40
8010423c:	e8 9f 05 00 00       	call   801047e0 <acquire>
  pushcli();
80104241:	e8 4a 04 00 00       	call   80104690 <pushcli>
  c = mycpu();
80104246:	e8 65 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010424b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104251:	e8 8a 04 00 00       	call   801046e0 <popcli>
  myproc()->state = RUNNABLE;
80104256:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010425d:	e8 ae fc ff ff       	call   80103f10 <sched>
  release(&ptable.lock);
80104262:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104269:	e8 12 05 00 00       	call   80104780 <release>
}
8010426e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104271:	83 c4 10             	add    $0x10,%esp
80104274:	c9                   	leave  
80104275:	c3                   	ret    
80104276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427d:	8d 76 00             	lea    0x0(%esi),%esi

80104280 <sleep>:
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	57                   	push   %edi
80104284:	56                   	push   %esi
80104285:	53                   	push   %ebx
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	8b 7d 08             	mov    0x8(%ebp),%edi
8010428c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010428f:	e8 fc 03 00 00       	call   80104690 <pushcli>
  c = mycpu();
80104294:	e8 17 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104299:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010429f:	e8 3c 04 00 00       	call   801046e0 <popcli>
  if(p == 0)
801042a4:	85 db                	test   %ebx,%ebx
801042a6:	0f 84 87 00 00 00    	je     80104333 <sleep+0xb3>
  if(lk == 0)
801042ac:	85 f6                	test   %esi,%esi
801042ae:	74 76                	je     80104326 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042b0:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
801042b6:	74 50                	je     80104308 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 40 2d 11 80       	push   $0x80112d40
801042c0:	e8 1b 05 00 00       	call   801047e0 <acquire>
    release(lk);
801042c5:	89 34 24             	mov    %esi,(%esp)
801042c8:	e8 b3 04 00 00       	call   80104780 <release>
  p->chan = chan;
801042cd:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042d0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042d7:	e8 34 fc ff ff       	call   80103f10 <sched>
  p->chan = 0;
801042dc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
801042e3:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801042ea:	e8 91 04 00 00       	call   80104780 <release>
    acquire(lk);
801042ef:	89 75 08             	mov    %esi,0x8(%ebp)
801042f2:	83 c4 10             	add    $0x10,%esp
}
801042f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f8:	5b                   	pop    %ebx
801042f9:	5e                   	pop    %esi
801042fa:	5f                   	pop    %edi
801042fb:	5d                   	pop    %ebp
    acquire(lk);
801042fc:	e9 df 04 00 00       	jmp    801047e0 <acquire>
80104301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104308:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010430b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104312:	e8 f9 fb ff ff       	call   80103f10 <sched>
  p->chan = 0;
80104317:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010431e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104321:	5b                   	pop    %ebx
80104322:	5e                   	pop    %esi
80104323:	5f                   	pop    %edi
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    
    panic("sleep without lk");
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	68 1a 7d 10 80       	push   $0x80107d1a
8010432e:	e8 4d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104333:	83 ec 0c             	sub    $0xc,%esp
80104336:	68 14 7d 10 80       	push   $0x80107d14
8010433b:	e8 40 c0 ff ff       	call   80100380 <panic>

80104340 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 10             	sub    $0x10,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010434a:	68 40 2d 11 80       	push   $0x80112d40
8010434f:	e8 8c 04 00 00       	call   801047e0 <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104357:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010435c:	eb 0c                	jmp    8010436a <wakeup+0x2a>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	83 e8 80             	sub    $0xffffff80,%eax
80104363:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104368:	74 1c                	je     80104386 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010436a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010436e:	75 f0                	jne    80104360 <wakeup+0x20>
80104370:	3b 58 24             	cmp    0x24(%eax),%ebx
80104373:	75 eb                	jne    80104360 <wakeup+0x20>
      p->state = RUNNABLE;
80104375:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010437c:	83 e8 80             	sub    $0xffffff80,%eax
8010437f:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104384:	75 e4                	jne    8010436a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104386:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
8010438d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104390:	c9                   	leave  
  release(&ptable.lock);
80104391:	e9 ea 03 00 00       	jmp    80104780 <release>
80104396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
801043a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043aa:	68 40 2d 11 80       	push   $0x80112d40
801043af:	e8 2c 04 00 00       	call   801047e0 <acquire>
801043b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043b7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801043bc:	eb 0c                	jmp    801043ca <kill+0x2a>
801043be:	66 90                	xchg   %ax,%ax
801043c0:	83 e8 80             	sub    $0xffffff80,%eax
801043c3:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801043c8:	74 36                	je     80104400 <kill+0x60>
    if(p->pid == pid){
801043ca:	39 58 14             	cmp    %ebx,0x14(%eax)
801043cd:	75 f1                	jne    801043c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043cf:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801043d3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801043da:	75 07                	jne    801043e3 <kill+0x43>
        p->state = RUNNABLE;
801043dc:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
801043e3:	83 ec 0c             	sub    $0xc,%esp
801043e6:	68 40 2d 11 80       	push   $0x80112d40
801043eb:	e8 90 03 00 00       	call   80104780 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043f3:	83 c4 10             	add    $0x10,%esp
801043f6:	31 c0                	xor    %eax,%eax
}
801043f8:	c9                   	leave  
801043f9:	c3                   	ret    
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104400:	83 ec 0c             	sub    $0xc,%esp
80104403:	68 40 2d 11 80       	push   $0x80112d40
80104408:	e8 73 03 00 00       	call   80104780 <release>
}
8010440d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104410:	83 c4 10             	add    $0x10,%esp
80104413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104418:	c9                   	leave  
80104419:	c3                   	ret    
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	56                   	push   %esi
80104425:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104428:	53                   	push   %ebx
80104429:	bb e4 2d 11 80       	mov    $0x80112de4,%ebx
8010442e:	83 ec 3c             	sub    $0x3c,%esp
80104431:	eb 24                	jmp    80104457 <procdump+0x37>
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104438:	83 ec 0c             	sub    $0xc,%esp
8010443b:	68 bb 80 10 80       	push   $0x801080bb
80104440:	e8 5b c2 ff ff       	call   801006a0 <cprintf>
80104445:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104448:	83 eb 80             	sub    $0xffffff80,%ebx
8010444b:	81 fb e4 4d 11 80    	cmp    $0x80114de4,%ebx
80104451:	0f 84 81 00 00 00    	je     801044d8 <procdump+0xb8>
    if(p->state == UNUSED)
80104457:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010445a:	85 c0                	test   %eax,%eax
8010445c:	74 ea                	je     80104448 <procdump+0x28>
      state = "???";
8010445e:	ba 2b 7d 10 80       	mov    $0x80107d2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104463:	83 f8 05             	cmp    $0x5,%eax
80104466:	77 11                	ja     80104479 <procdump+0x59>
80104468:	8b 14 85 8c 7d 10 80 	mov    -0x7fef8274(,%eax,4),%edx
      state = "???";
8010446f:	b8 2b 7d 10 80       	mov    $0x80107d2b,%eax
80104474:	85 d2                	test   %edx,%edx
80104476:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104479:	53                   	push   %ebx
8010447a:	52                   	push   %edx
8010447b:	ff 73 a4             	push   -0x5c(%ebx)
8010447e:	68 2f 7d 10 80       	push   $0x80107d2f
80104483:	e8 18 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104488:	83 c4 10             	add    $0x10,%esp
8010448b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010448f:	75 a7                	jne    80104438 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104491:	83 ec 08             	sub    $0x8,%esp
80104494:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104497:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010449a:	50                   	push   %eax
8010449b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010449e:	8b 40 0c             	mov    0xc(%eax),%eax
801044a1:	83 c0 08             	add    $0x8,%eax
801044a4:	50                   	push   %eax
801044a5:	e8 86 01 00 00       	call   80104630 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044aa:	83 c4 10             	add    $0x10,%esp
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
801044b0:	8b 17                	mov    (%edi),%edx
801044b2:	85 d2                	test   %edx,%edx
801044b4:	74 82                	je     80104438 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044b6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044bc:	52                   	push   %edx
801044bd:	68 81 77 10 80       	push   $0x80107781
801044c2:	e8 d9 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044c7:	83 c4 10             	add    $0x10,%esp
801044ca:	39 fe                	cmp    %edi,%esi
801044cc:	75 e2                	jne    801044b0 <procdump+0x90>
801044ce:	e9 65 ff ff ff       	jmp    80104438 <procdump+0x18>
801044d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d7:	90                   	nop
  }
}
801044d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044db:	5b                   	pop    %ebx
801044dc:	5e                   	pop    %esi
801044dd:	5f                   	pop    %edi
801044de:	5d                   	pop    %ebp
801044df:	c3                   	ret    

801044e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 0c             	sub    $0xc,%esp
801044e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044ea:	68 a4 7d 10 80       	push   $0x80107da4
801044ef:	8d 43 04             	lea    0x4(%ebx),%eax
801044f2:	50                   	push   %eax
801044f3:	e8 18 01 00 00       	call   80104610 <initlock>
  lk->name = name;
801044f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104501:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104504:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010450b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010450e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104511:	c9                   	leave  
80104512:	c3                   	ret    
80104513:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104528:	8d 73 04             	lea    0x4(%ebx),%esi
8010452b:	83 ec 0c             	sub    $0xc,%esp
8010452e:	56                   	push   %esi
8010452f:	e8 ac 02 00 00       	call   801047e0 <acquire>
  while (lk->locked) {
80104534:	8b 13                	mov    (%ebx),%edx
80104536:	83 c4 10             	add    $0x10,%esp
80104539:	85 d2                	test   %edx,%edx
8010453b:	74 16                	je     80104553 <acquiresleep+0x33>
8010453d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104540:	83 ec 08             	sub    $0x8,%esp
80104543:	56                   	push   %esi
80104544:	53                   	push   %ebx
80104545:	e8 36 fd ff ff       	call   80104280 <sleep>
  while (lk->locked) {
8010454a:	8b 03                	mov    (%ebx),%eax
8010454c:	83 c4 10             	add    $0x10,%esp
8010454f:	85 c0                	test   %eax,%eax
80104551:	75 ed                	jne    80104540 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104553:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104559:	e8 d2 f5 ff ff       	call   80103b30 <myproc>
8010455e:	8b 40 14             	mov    0x14(%eax),%eax
80104561:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104564:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104567:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010456a:	5b                   	pop    %ebx
8010456b:	5e                   	pop    %esi
8010456c:	5d                   	pop    %ebp
  release(&lk->lk);
8010456d:	e9 0e 02 00 00       	jmp    80104780 <release>
80104572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104580 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104588:	8d 73 04             	lea    0x4(%ebx),%esi
8010458b:	83 ec 0c             	sub    $0xc,%esp
8010458e:	56                   	push   %esi
8010458f:	e8 4c 02 00 00       	call   801047e0 <acquire>
  lk->locked = 0;
80104594:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010459a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045a1:	89 1c 24             	mov    %ebx,(%esp)
801045a4:	e8 97 fd ff ff       	call   80104340 <wakeup>
  release(&lk->lk);
801045a9:	89 75 08             	mov    %esi,0x8(%ebp)
801045ac:	83 c4 10             	add    $0x10,%esp
}
801045af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b2:	5b                   	pop    %ebx
801045b3:	5e                   	pop    %esi
801045b4:	5d                   	pop    %ebp
  release(&lk->lk);
801045b5:	e9 c6 01 00 00       	jmp    80104780 <release>
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	57                   	push   %edi
801045c4:	31 ff                	xor    %edi,%edi
801045c6:	56                   	push   %esi
801045c7:	53                   	push   %ebx
801045c8:	83 ec 18             	sub    $0x18,%esp
801045cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045ce:	8d 73 04             	lea    0x4(%ebx),%esi
801045d1:	56                   	push   %esi
801045d2:	e8 09 02 00 00       	call   801047e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045d7:	8b 03                	mov    (%ebx),%eax
801045d9:	83 c4 10             	add    $0x10,%esp
801045dc:	85 c0                	test   %eax,%eax
801045de:	75 18                	jne    801045f8 <holdingsleep+0x38>
  release(&lk->lk);
801045e0:	83 ec 0c             	sub    $0xc,%esp
801045e3:	56                   	push   %esi
801045e4:	e8 97 01 00 00       	call   80104780 <release>
  return r;
}
801045e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045ec:	89 f8                	mov    %edi,%eax
801045ee:	5b                   	pop    %ebx
801045ef:	5e                   	pop    %esi
801045f0:	5f                   	pop    %edi
801045f1:	5d                   	pop    %ebp
801045f2:	c3                   	ret    
801045f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801045f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045fb:	e8 30 f5 ff ff       	call   80103b30 <myproc>
80104600:	39 58 14             	cmp    %ebx,0x14(%eax)
80104603:	0f 94 c0             	sete   %al
80104606:	0f b6 c0             	movzbl %al,%eax
80104609:	89 c7                	mov    %eax,%edi
8010460b:	eb d3                	jmp    801045e0 <holdingsleep+0x20>
8010460d:	66 90                	xchg   %ax,%ax
8010460f:	90                   	nop

80104610 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104616:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010461f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104622:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104629:	5d                   	pop    %ebp
8010462a:	c3                   	ret    
8010462b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010462f:	90                   	nop

80104630 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104630:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104631:	31 d2                	xor    %edx,%edx
{
80104633:	89 e5                	mov    %esp,%ebp
80104635:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104636:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104639:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010463c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010463f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104640:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104646:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010464c:	77 1a                	ja     80104668 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010464e:	8b 58 04             	mov    0x4(%eax),%ebx
80104651:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104654:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104657:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104659:	83 fa 0a             	cmp    $0xa,%edx
8010465c:	75 e2                	jne    80104640 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010465e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104661:	c9                   	leave  
80104662:	c3                   	ret    
80104663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104667:	90                   	nop
  for(; i < 10; i++)
80104668:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010466b:	8d 51 28             	lea    0x28(%ecx),%edx
8010466e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104676:	83 c0 04             	add    $0x4,%eax
80104679:	39 d0                	cmp    %edx,%eax
8010467b:	75 f3                	jne    80104670 <getcallerpcs+0x40>
}
8010467d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104680:	c9                   	leave  
80104681:	c3                   	ret    
80104682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104690 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 04             	sub    $0x4,%esp
80104697:	9c                   	pushf  
80104698:	5b                   	pop    %ebx
  asm volatile("cli");
80104699:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010469a:	e8 11 f4 ff ff       	call   80103ab0 <mycpu>
8010469f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046a5:	85 c0                	test   %eax,%eax
801046a7:	74 17                	je     801046c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046a9:	e8 02 f4 ff ff       	call   80103ab0 <mycpu>
801046ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b8:	c9                   	leave  
801046b9:	c3                   	ret    
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046c0:	e8 eb f3 ff ff       	call   80103ab0 <mycpu>
801046c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046d1:	eb d6                	jmp    801046a9 <pushcli+0x19>
801046d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046e0 <popcli>:

void
popcli(void)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046e6:	9c                   	pushf  
801046e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046e8:	f6 c4 02             	test   $0x2,%ah
801046eb:	75 35                	jne    80104722 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046ed:	e8 be f3 ff ff       	call   80103ab0 <mycpu>
801046f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046f9:	78 34                	js     8010472f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046fb:	e8 b0 f3 ff ff       	call   80103ab0 <mycpu>
80104700:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104706:	85 d2                	test   %edx,%edx
80104708:	74 06                	je     80104710 <popcli+0x30>
    sti();
}
8010470a:	c9                   	leave  
8010470b:	c3                   	ret    
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104710:	e8 9b f3 ff ff       	call   80103ab0 <mycpu>
80104715:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010471b:	85 c0                	test   %eax,%eax
8010471d:	74 eb                	je     8010470a <popcli+0x2a>
  asm volatile("sti");
8010471f:	fb                   	sti    
}
80104720:	c9                   	leave  
80104721:	c3                   	ret    
    panic("popcli - interruptible");
80104722:	83 ec 0c             	sub    $0xc,%esp
80104725:	68 af 7d 10 80       	push   $0x80107daf
8010472a:	e8 51 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010472f:	83 ec 0c             	sub    $0xc,%esp
80104732:	68 c6 7d 10 80       	push   $0x80107dc6
80104737:	e8 44 bc ff ff       	call   80100380 <panic>
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104740 <holding>:
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 75 08             	mov    0x8(%ebp),%esi
80104748:	31 db                	xor    %ebx,%ebx
  pushcli();
8010474a:	e8 41 ff ff ff       	call   80104690 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010474f:	8b 06                	mov    (%esi),%eax
80104751:	85 c0                	test   %eax,%eax
80104753:	75 0b                	jne    80104760 <holding+0x20>
  popcli();
80104755:	e8 86 ff ff ff       	call   801046e0 <popcli>
}
8010475a:	89 d8                	mov    %ebx,%eax
8010475c:	5b                   	pop    %ebx
8010475d:	5e                   	pop    %esi
8010475e:	5d                   	pop    %ebp
8010475f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104760:	8b 5e 08             	mov    0x8(%esi),%ebx
80104763:	e8 48 f3 ff ff       	call   80103ab0 <mycpu>
80104768:	39 c3                	cmp    %eax,%ebx
8010476a:	0f 94 c3             	sete   %bl
  popcli();
8010476d:	e8 6e ff ff ff       	call   801046e0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104772:	0f b6 db             	movzbl %bl,%ebx
}
80104775:	89 d8                	mov    %ebx,%eax
80104777:	5b                   	pop    %ebx
80104778:	5e                   	pop    %esi
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    
8010477b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010477f:	90                   	nop

80104780 <release>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104788:	e8 03 ff ff ff       	call   80104690 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010478d:	8b 03                	mov    (%ebx),%eax
8010478f:	85 c0                	test   %eax,%eax
80104791:	75 15                	jne    801047a8 <release+0x28>
  popcli();
80104793:	e8 48 ff ff ff       	call   801046e0 <popcli>
    panic("release");
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 cd 7d 10 80       	push   $0x80107dcd
801047a0:	e8 db bb ff ff       	call   80100380 <panic>
801047a5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047a8:	8b 73 08             	mov    0x8(%ebx),%esi
801047ab:	e8 00 f3 ff ff       	call   80103ab0 <mycpu>
801047b0:	39 c6                	cmp    %eax,%esi
801047b2:	75 df                	jne    80104793 <release+0x13>
  popcli();
801047b4:	e8 27 ff ff ff       	call   801046e0 <popcli>
  lk->pcs[0] = 0;
801047b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047c7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d5:	5b                   	pop    %ebx
801047d6:	5e                   	pop    %esi
801047d7:	5d                   	pop    %ebp
  popcli();
801047d8:	e9 03 ff ff ff       	jmp    801046e0 <popcli>
801047dd:	8d 76 00             	lea    0x0(%esi),%esi

801047e0 <acquire>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047e7:	e8 a4 fe ff ff       	call   80104690 <pushcli>
  if(holding(lk))
801047ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047ef:	e8 9c fe ff ff       	call   80104690 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047f4:	8b 03                	mov    (%ebx),%eax
801047f6:	85 c0                	test   %eax,%eax
801047f8:	75 7e                	jne    80104878 <acquire+0x98>
  popcli();
801047fa:	e8 e1 fe ff ff       	call   801046e0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047ff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104808:	8b 55 08             	mov    0x8(%ebp),%edx
8010480b:	89 c8                	mov    %ecx,%eax
8010480d:	f0 87 02             	lock xchg %eax,(%edx)
80104810:	85 c0                	test   %eax,%eax
80104812:	75 f4                	jne    80104808 <acquire+0x28>
  __sync_synchronize();
80104814:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104819:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010481c:	e8 8f f2 ff ff       	call   80103ab0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104821:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104824:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104826:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104829:	31 c0                	xor    %eax,%eax
8010482b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010482f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104830:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104836:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010483c:	77 1a                	ja     80104858 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010483e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104841:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104845:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104848:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010484a:	83 f8 0a             	cmp    $0xa,%eax
8010484d:	75 e1                	jne    80104830 <acquire+0x50>
}
8010484f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104852:	c9                   	leave  
80104853:	c3                   	ret    
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104858:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010485c:	8d 51 34             	lea    0x34(%ecx),%edx
8010485f:	90                   	nop
    pcs[i] = 0;
80104860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104866:	83 c0 04             	add    $0x4,%eax
80104869:	39 c2                	cmp    %eax,%edx
8010486b:	75 f3                	jne    80104860 <acquire+0x80>
}
8010486d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104870:	c9                   	leave  
80104871:	c3                   	ret    
80104872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104878:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010487b:	e8 30 f2 ff ff       	call   80103ab0 <mycpu>
80104880:	39 c3                	cmp    %eax,%ebx
80104882:	0f 85 72 ff ff ff    	jne    801047fa <acquire+0x1a>
  popcli();
80104888:	e8 53 fe ff ff       	call   801046e0 <popcli>
    panic("acquire");
8010488d:	83 ec 0c             	sub    $0xc,%esp
80104890:	68 d5 7d 10 80       	push   $0x80107dd5
80104895:	e8 e6 ba ff ff       	call   80100380 <panic>
8010489a:	66 90                	xchg   %ax,%ax
8010489c:	66 90                	xchg   %ax,%ax
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <memset>:
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	8b 55 08             	mov    0x8(%ebp),%edx
801048a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048aa:	53                   	push   %ebx
801048ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ae:	89 d7                	mov    %edx,%edi
801048b0:	09 cf                	or     %ecx,%edi
801048b2:	83 e7 03             	and    $0x3,%edi
801048b5:	75 29                	jne    801048e0 <memset+0x40>
801048b7:	0f b6 f8             	movzbl %al,%edi
801048ba:	c1 e0 18             	shl    $0x18,%eax
801048bd:	89 fb                	mov    %edi,%ebx
801048bf:	c1 e9 02             	shr    $0x2,%ecx
801048c2:	c1 e3 10             	shl    $0x10,%ebx
801048c5:	09 d8                	or     %ebx,%eax
801048c7:	09 f8                	or     %edi,%eax
801048c9:	c1 e7 08             	shl    $0x8,%edi
801048cc:	09 f8                	or     %edi,%eax
801048ce:	89 d7                	mov    %edx,%edi
801048d0:	fc                   	cld    
801048d1:	f3 ab                	rep stos %eax,%es:(%edi)
801048d3:	5b                   	pop    %ebx
801048d4:	89 d0                	mov    %edx,%eax
801048d6:	5f                   	pop    %edi
801048d7:	5d                   	pop    %ebp
801048d8:	c3                   	ret    
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e0:	89 d7                	mov    %edx,%edi
801048e2:	fc                   	cld    
801048e3:	f3 aa                	rep stos %al,%es:(%edi)
801048e5:	5b                   	pop    %ebx
801048e6:	89 d0                	mov    %edx,%eax
801048e8:	5f                   	pop    %edi
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop

801048f0 <memcmp>:
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	8b 75 10             	mov    0x10(%ebp),%esi
801048f7:	8b 55 08             	mov    0x8(%ebp),%edx
801048fa:	53                   	push   %ebx
801048fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048fe:	85 f6                	test   %esi,%esi
80104900:	74 2e                	je     80104930 <memcmp+0x40>
80104902:	01 c6                	add    %eax,%esi
80104904:	eb 14                	jmp    8010491a <memcmp+0x2a>
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
80104910:	83 c0 01             	add    $0x1,%eax
80104913:	83 c2 01             	add    $0x1,%edx
80104916:	39 f0                	cmp    %esi,%eax
80104918:	74 16                	je     80104930 <memcmp+0x40>
8010491a:	0f b6 0a             	movzbl (%edx),%ecx
8010491d:	0f b6 18             	movzbl (%eax),%ebx
80104920:	38 d9                	cmp    %bl,%cl
80104922:	74 ec                	je     80104910 <memcmp+0x20>
80104924:	0f b6 c1             	movzbl %cl,%eax
80104927:	29 d8                	sub    %ebx,%eax
80104929:	5b                   	pop    %ebx
8010492a:	5e                   	pop    %esi
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret    
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
80104930:	5b                   	pop    %ebx
80104931:	31 c0                	xor    %eax,%eax
80104933:	5e                   	pop    %esi
80104934:	5d                   	pop    %ebp
80104935:	c3                   	ret    
80104936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493d:	8d 76 00             	lea    0x0(%esi),%esi

80104940 <memmove>:
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	8b 55 08             	mov    0x8(%ebp),%edx
80104947:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010494a:	56                   	push   %esi
8010494b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010494e:	39 d6                	cmp    %edx,%esi
80104950:	73 26                	jae    80104978 <memmove+0x38>
80104952:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104955:	39 fa                	cmp    %edi,%edx
80104957:	73 1f                	jae    80104978 <memmove+0x38>
80104959:	8d 41 ff             	lea    -0x1(%ecx),%eax
8010495c:	85 c9                	test   %ecx,%ecx
8010495e:	74 0c                	je     8010496c <memmove+0x2c>
80104960:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104964:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104967:	83 e8 01             	sub    $0x1,%eax
8010496a:	73 f4                	jae    80104960 <memmove+0x20>
8010496c:	5e                   	pop    %esi
8010496d:	89 d0                	mov    %edx,%eax
8010496f:	5f                   	pop    %edi
80104970:	5d                   	pop    %ebp
80104971:	c3                   	ret    
80104972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104978:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010497b:	89 d7                	mov    %edx,%edi
8010497d:	85 c9                	test   %ecx,%ecx
8010497f:	74 eb                	je     8010496c <memmove+0x2c>
80104981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104988:	a4                   	movsb  %ds:(%esi),%es:(%edi)
80104989:	39 c6                	cmp    %eax,%esi
8010498b:	75 fb                	jne    80104988 <memmove+0x48>
8010498d:	5e                   	pop    %esi
8010498e:	89 d0                	mov    %edx,%eax
80104990:	5f                   	pop    %edi
80104991:	5d                   	pop    %ebp
80104992:	c3                   	ret    
80104993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <memcpy>:
801049a0:	eb 9e                	jmp    80104940 <memmove>
801049a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049b0 <strncmp>:
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	8b 75 10             	mov    0x10(%ebp),%esi
801049b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049ba:	53                   	push   %ebx
801049bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801049be:	85 f6                	test   %esi,%esi
801049c0:	74 2e                	je     801049f0 <strncmp+0x40>
801049c2:	01 d6                	add    %edx,%esi
801049c4:	eb 18                	jmp    801049de <strncmp+0x2e>
801049c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
801049d0:	38 d8                	cmp    %bl,%al
801049d2:	75 14                	jne    801049e8 <strncmp+0x38>
801049d4:	83 c2 01             	add    $0x1,%edx
801049d7:	83 c1 01             	add    $0x1,%ecx
801049da:	39 f2                	cmp    %esi,%edx
801049dc:	74 12                	je     801049f0 <strncmp+0x40>
801049de:	0f b6 01             	movzbl (%ecx),%eax
801049e1:	0f b6 1a             	movzbl (%edx),%ebx
801049e4:	84 c0                	test   %al,%al
801049e6:	75 e8                	jne    801049d0 <strncmp+0x20>
801049e8:	29 d8                	sub    %ebx,%eax
801049ea:	5b                   	pop    %ebx
801049eb:	5e                   	pop    %esi
801049ec:	5d                   	pop    %ebp
801049ed:	c3                   	ret    
801049ee:	66 90                	xchg   %ax,%ax
801049f0:	5b                   	pop    %ebx
801049f1:	31 c0                	xor    %eax,%eax
801049f3:	5e                   	pop    %esi
801049f4:	5d                   	pop    %ebp
801049f5:	c3                   	ret    
801049f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fd:	8d 76 00             	lea    0x0(%esi),%esi

80104a00 <strncpy>:
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	56                   	push   %esi
80104a05:	8b 75 08             	mov    0x8(%ebp),%esi
80104a08:	53                   	push   %ebx
80104a09:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a0c:	89 f0                	mov    %esi,%eax
80104a0e:	eb 15                	jmp    80104a25 <strncpy+0x25>
80104a10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a14:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a17:	83 c0 01             	add    $0x1,%eax
80104a1a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a1e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a21:	84 d2                	test   %dl,%dl
80104a23:	74 09                	je     80104a2e <strncpy+0x2e>
80104a25:	89 cb                	mov    %ecx,%ebx
80104a27:	83 e9 01             	sub    $0x1,%ecx
80104a2a:	85 db                	test   %ebx,%ebx
80104a2c:	7f e2                	jg     80104a10 <strncpy+0x10>
80104a2e:	89 c2                	mov    %eax,%edx
80104a30:	85 c9                	test   %ecx,%ecx
80104a32:	7e 17                	jle    80104a4b <strncpy+0x4b>
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a38:	83 c2 01             	add    $0x1,%edx
80104a3b:	89 c1                	mov    %eax,%ecx
80104a3d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80104a41:	29 d1                	sub    %edx,%ecx
80104a43:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a47:	85 c9                	test   %ecx,%ecx
80104a49:	7f ed                	jg     80104a38 <strncpy+0x38>
80104a4b:	5b                   	pop    %ebx
80104a4c:	89 f0                	mov    %esi,%eax
80104a4e:	5e                   	pop    %esi
80104a4f:	5f                   	pop    %edi
80104a50:	5d                   	pop    %ebp
80104a51:	c3                   	ret    
80104a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a60 <safestrcpy>:
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	8b 55 10             	mov    0x10(%ebp),%edx
80104a67:	8b 75 08             	mov    0x8(%ebp),%esi
80104a6a:	53                   	push   %ebx
80104a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a6e:	85 d2                	test   %edx,%edx
80104a70:	7e 25                	jle    80104a97 <safestrcpy+0x37>
80104a72:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a76:	89 f2                	mov    %esi,%edx
80104a78:	eb 16                	jmp    80104a90 <safestrcpy+0x30>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a80:	0f b6 08             	movzbl (%eax),%ecx
80104a83:	83 c0 01             	add    $0x1,%eax
80104a86:	83 c2 01             	add    $0x1,%edx
80104a89:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a8c:	84 c9                	test   %cl,%cl
80104a8e:	74 04                	je     80104a94 <safestrcpy+0x34>
80104a90:	39 d8                	cmp    %ebx,%eax
80104a92:	75 ec                	jne    80104a80 <safestrcpy+0x20>
80104a94:	c6 02 00             	movb   $0x0,(%edx)
80104a97:	89 f0                	mov    %esi,%eax
80104a99:	5b                   	pop    %ebx
80104a9a:	5e                   	pop    %esi
80104a9b:	5d                   	pop    %ebp
80104a9c:	c3                   	ret    
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <strlen>:
80104aa0:	55                   	push   %ebp
80104aa1:	31 c0                	xor    %eax,%eax
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	8b 55 08             	mov    0x8(%ebp),%edx
80104aa8:	80 3a 00             	cmpb   $0x0,(%edx)
80104aab:	74 0c                	je     80104ab9 <strlen+0x19>
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
80104ab0:	83 c0 01             	add    $0x1,%eax
80104ab3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ab7:	75 f7                	jne    80104ab0 <strlen+0x10>
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret    

80104abb <swtch>:
80104abb:	8b 44 24 04          	mov    0x4(%esp),%eax
80104abf:	8b 54 24 08          	mov    0x8(%esp),%edx
80104ac3:	55                   	push   %ebp
80104ac4:	53                   	push   %ebx
80104ac5:	56                   	push   %esi
80104ac6:	57                   	push   %edi
80104ac7:	89 20                	mov    %esp,(%eax)
80104ac9:	89 d4                	mov    %edx,%esp
80104acb:	5f                   	pop    %edi
80104acc:	5e                   	pop    %esi
80104acd:	5b                   	pop    %ebx
80104ace:	5d                   	pop    %ebp
80104acf:	c3                   	ret    

80104ad0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104ada:	e8 51 f0 ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104adf:	8b 00                	mov    (%eax),%eax
80104ae1:	39 d8                	cmp    %ebx,%eax
80104ae3:	76 1b                	jbe    80104b00 <fetchint+0x30>
80104ae5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ae8:	39 d0                	cmp    %edx,%eax
80104aea:	72 14                	jb     80104b00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aef:	8b 13                	mov    (%ebx),%edx
80104af1:	89 10                	mov    %edx,(%eax)
  return 0;
80104af3:	31 c0                	xor    %eax,%eax
}
80104af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af8:	c9                   	leave  
80104af9:	c3                   	ret    
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b05:	eb ee                	jmp    80104af5 <fetchint+0x25>
80104b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
80104b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b1a:	e8 11 f0 ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz)
80104b1f:	39 18                	cmp    %ebx,(%eax)
80104b21:	76 2d                	jbe    80104b50 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b26:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b28:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b2a:	39 d3                	cmp    %edx,%ebx
80104b2c:	73 22                	jae    80104b50 <fetchstr+0x40>
80104b2e:	89 d8                	mov    %ebx,%eax
80104b30:	eb 0d                	jmp    80104b3f <fetchstr+0x2f>
80104b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b38:	83 c0 01             	add    $0x1,%eax
80104b3b:	39 c2                	cmp    %eax,%edx
80104b3d:	76 11                	jbe    80104b50 <fetchstr+0x40>
    if(*s == 0)
80104b3f:	80 38 00             	cmpb   $0x0,(%eax)
80104b42:	75 f4                	jne    80104b38 <fetchstr+0x28>
      return s - *pp;
80104b44:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b49:	c9                   	leave  
80104b4a:	c3                   	ret    
80104b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b4f:	90                   	nop
80104b50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b58:	c9                   	leave  
80104b59:	c3                   	ret    
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b65:	e8 c6 ef ff ff       	call   80103b30 <myproc>
80104b6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b6d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b70:	8b 40 44             	mov    0x44(%eax),%eax
80104b73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b76:	e8 b5 ef ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b7e:	8b 00                	mov    (%eax),%eax
80104b80:	39 c6                	cmp    %eax,%esi
80104b82:	73 1c                	jae    80104ba0 <argint+0x40>
80104b84:	8d 53 08             	lea    0x8(%ebx),%edx
80104b87:	39 d0                	cmp    %edx,%eax
80104b89:	72 15                	jb     80104ba0 <argint+0x40>
  *ip = *(int*)(addr);
80104b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b91:	89 10                	mov    %edx,(%eax)
  return 0;
80104b93:	31 c0                	xor    %eax,%eax
}
80104b95:	5b                   	pop    %ebx
80104b96:	5e                   	pop    %esi
80104b97:	5d                   	pop    %ebp
80104b98:	c3                   	ret    
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ba5:	eb ee                	jmp    80104b95 <argint+0x35>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104bb9:	e8 72 ef ff ff       	call   80103b30 <myproc>
80104bbe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc0:	e8 6b ef ff ff       	call   80103b30 <myproc>
80104bc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bc8:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bcb:	8b 40 44             	mov    0x44(%eax),%eax
80104bce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bd1:	e8 5a ef ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bd9:	8b 00                	mov    (%eax),%eax
80104bdb:	39 c7                	cmp    %eax,%edi
80104bdd:	73 31                	jae    80104c10 <argptr+0x60>
80104bdf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104be2:	39 c8                	cmp    %ecx,%eax
80104be4:	72 2a                	jb     80104c10 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104be6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104be9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bec:	85 d2                	test   %edx,%edx
80104bee:	78 20                	js     80104c10 <argptr+0x60>
80104bf0:	8b 16                	mov    (%esi),%edx
80104bf2:	39 c2                	cmp    %eax,%edx
80104bf4:	76 1a                	jbe    80104c10 <argptr+0x60>
80104bf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bf9:	01 c3                	add    %eax,%ebx
80104bfb:	39 da                	cmp    %ebx,%edx
80104bfd:	72 11                	jb     80104c10 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c02:	89 02                	mov    %eax,(%edx)
  return 0;
80104c04:	31 c0                	xor    %eax,%eax
}
80104c06:	83 c4 0c             	add    $0xc,%esp
80104c09:	5b                   	pop    %ebx
80104c0a:	5e                   	pop    %esi
80104c0b:	5f                   	pop    %edi
80104c0c:	5d                   	pop    %ebp
80104c0d:	c3                   	ret    
80104c0e:	66 90                	xchg   %ax,%ax
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c15:	eb ef                	jmp    80104c06 <argptr+0x56>
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	e8 06 ef ff ff       	call   80103b30 <myproc>
80104c2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c30:	8b 40 44             	mov    0x44(%eax),%eax
80104c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c36:	e8 f5 ee ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3e:	8b 00                	mov    (%eax),%eax
80104c40:	39 c6                	cmp    %eax,%esi
80104c42:	73 44                	jae    80104c88 <argstr+0x68>
80104c44:	8d 53 08             	lea    0x8(%ebx),%edx
80104c47:	39 d0                	cmp    %edx,%eax
80104c49:	72 3d                	jb     80104c88 <argstr+0x68>
  *ip = *(int*)(addr);
80104c4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c4e:	e8 dd ee ff ff       	call   80103b30 <myproc>
  if(addr >= curproc->sz)
80104c53:	3b 18                	cmp    (%eax),%ebx
80104c55:	73 31                	jae    80104c88 <argstr+0x68>
  *pp = (char*)addr;
80104c57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c5e:	39 d3                	cmp    %edx,%ebx
80104c60:	73 26                	jae    80104c88 <argstr+0x68>
80104c62:	89 d8                	mov    %ebx,%eax
80104c64:	eb 11                	jmp    80104c77 <argstr+0x57>
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
80104c70:	83 c0 01             	add    $0x1,%eax
80104c73:	39 c2                	cmp    %eax,%edx
80104c75:	76 11                	jbe    80104c88 <argstr+0x68>
    if(*s == 0)
80104c77:	80 38 00             	cmpb   $0x0,(%eax)
80104c7a:	75 f4                	jne    80104c70 <argstr+0x50>
      return s - *pp;
80104c7c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c7e:	5b                   	pop    %ebx
80104c7f:	5e                   	pop    %esi
80104c80:	5d                   	pop    %ebp
80104c81:	c3                   	ret    
80104c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c88:	5b                   	pop    %ebx
    return -1;
80104c89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c8e:	5e                   	pop    %esi
80104c8f:	5d                   	pop    %ebp
80104c90:	c3                   	ret    
80104c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop

80104ca0 <syscall>:
[SYS_shugebrk] sys_shugebrk, // part 2
};

void
syscall(void)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	53                   	push   %ebx
80104ca4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ca7:	e8 84 ee ff ff       	call   80103b30 <myproc>
80104cac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cae:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cb1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cb7:	83 fa 17             	cmp    $0x17,%edx
80104cba:	77 24                	ja     80104ce0 <syscall+0x40>
80104cbc:	8b 14 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%edx
80104cc3:	85 d2                	test   %edx,%edx
80104cc5:	74 19                	je     80104ce0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104cc7:	ff d2                	call   *%edx
80104cc9:	89 c2                	mov    %eax,%edx
80104ccb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104cce:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104cd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cd4:	c9                   	leave  
80104cd5:	c3                   	ret    
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ce0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ce1:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ce4:	50                   	push   %eax
80104ce5:	ff 73 14             	push   0x14(%ebx)
80104ce8:	68 dd 7d 10 80       	push   $0x80107ddd
80104ced:	e8 ae b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104cf2:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104cf5:	83 c4 10             	add    $0x10,%esp
80104cf8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d02:	c9                   	leave  
80104d03:	c3                   	ret    
80104d04:	66 90                	xchg   %ax,%ax
80104d06:	66 90                	xchg   %ax,%ax
80104d08:	66 90                	xchg   %ax,%ax
80104d0a:	66 90                	xchg   %ax,%ax
80104d0c:	66 90                	xchg   %ax,%ax
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d18:	53                   	push   %ebx
80104d19:	83 ec 34             	sub    $0x34,%esp
80104d1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d22:	57                   	push   %edi
80104d23:	50                   	push   %eax
{
80104d24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d2a:	e8 91 d3 ff ff       	call   801020c0 <nameiparent>
80104d2f:	83 c4 10             	add    $0x10,%esp
80104d32:	85 c0                	test   %eax,%eax
80104d34:	0f 84 46 01 00 00    	je     80104e80 <create+0x170>
    return 0;
  ilock(dp);
80104d3a:	83 ec 0c             	sub    $0xc,%esp
80104d3d:	89 c3                	mov    %eax,%ebx
80104d3f:	50                   	push   %eax
80104d40:	e8 3b ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d45:	83 c4 0c             	add    $0xc,%esp
80104d48:	6a 00                	push   $0x0
80104d4a:	57                   	push   %edi
80104d4b:	53                   	push   %ebx
80104d4c:	e8 8f cf ff ff       	call   80101ce0 <dirlookup>
80104d51:	83 c4 10             	add    $0x10,%esp
80104d54:	89 c6                	mov    %eax,%esi
80104d56:	85 c0                	test   %eax,%eax
80104d58:	74 56                	je     80104db0 <create+0xa0>
    iunlockput(dp);
80104d5a:	83 ec 0c             	sub    $0xc,%esp
80104d5d:	53                   	push   %ebx
80104d5e:	e8 ad cc ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104d63:	89 34 24             	mov    %esi,(%esp)
80104d66:	e8 15 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d6b:	83 c4 10             	add    $0x10,%esp
80104d6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d73:	75 1b                	jne    80104d90 <create+0x80>
80104d75:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d7a:	75 14                	jne    80104d90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d7f:	89 f0                	mov    %esi,%eax
80104d81:	5b                   	pop    %ebx
80104d82:	5e                   	pop    %esi
80104d83:	5f                   	pop    %edi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d90:	83 ec 0c             	sub    $0xc,%esp
80104d93:	56                   	push   %esi
    return 0;
80104d94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d96:	e8 75 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d9b:	83 c4 10             	add    $0x10,%esp
}
80104d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104da1:	89 f0                	mov    %esi,%eax
80104da3:	5b                   	pop    %ebx
80104da4:	5e                   	pop    %esi
80104da5:	5f                   	pop    %edi
80104da6:	5d                   	pop    %ebp
80104da7:	c3                   	ret    
80104da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104daf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104db0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104db4:	83 ec 08             	sub    $0x8,%esp
80104db7:	50                   	push   %eax
80104db8:	ff 33                	push   (%ebx)
80104dba:	e8 51 c8 ff ff       	call   80101610 <ialloc>
80104dbf:	83 c4 10             	add    $0x10,%esp
80104dc2:	89 c6                	mov    %eax,%esi
80104dc4:	85 c0                	test   %eax,%eax
80104dc6:	0f 84 cd 00 00 00    	je     80104e99 <create+0x189>
  ilock(ip);
80104dcc:	83 ec 0c             	sub    $0xc,%esp
80104dcf:	50                   	push   %eax
80104dd0:	e8 ab c9 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104dd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104dd9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ddd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104de1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104de5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dee:	89 34 24             	mov    %esi,(%esp)
80104df1:	e8 da c8 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104df6:	83 c4 10             	add    $0x10,%esp
80104df9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dfe:	74 30                	je     80104e30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e00:	83 ec 04             	sub    $0x4,%esp
80104e03:	ff 76 04             	push   0x4(%esi)
80104e06:	57                   	push   %edi
80104e07:	53                   	push   %ebx
80104e08:	e8 d3 d1 ff ff       	call   80101fe0 <dirlink>
80104e0d:	83 c4 10             	add    $0x10,%esp
80104e10:	85 c0                	test   %eax,%eax
80104e12:	78 78                	js     80104e8c <create+0x17c>
  iunlockput(dp);
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	53                   	push   %ebx
80104e18:	e8 f3 cb ff ff       	call   80101a10 <iunlockput>
  return ip;
80104e1d:	83 c4 10             	add    $0x10,%esp
}
80104e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e23:	89 f0                	mov    %esi,%eax
80104e25:	5b                   	pop    %ebx
80104e26:	5e                   	pop    %esi
80104e27:	5f                   	pop    %edi
80104e28:	5d                   	pop    %ebp
80104e29:	c3                   	ret    
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e38:	53                   	push   %ebx
80104e39:	e8 92 c8 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e3e:	83 c4 0c             	add    $0xc,%esp
80104e41:	ff 76 04             	push   0x4(%esi)
80104e44:	68 80 7e 10 80       	push   $0x80107e80
80104e49:	56                   	push   %esi
80104e4a:	e8 91 d1 ff ff       	call   80101fe0 <dirlink>
80104e4f:	83 c4 10             	add    $0x10,%esp
80104e52:	85 c0                	test   %eax,%eax
80104e54:	78 18                	js     80104e6e <create+0x15e>
80104e56:	83 ec 04             	sub    $0x4,%esp
80104e59:	ff 73 04             	push   0x4(%ebx)
80104e5c:	68 7f 7e 10 80       	push   $0x80107e7f
80104e61:	56                   	push   %esi
80104e62:	e8 79 d1 ff ff       	call   80101fe0 <dirlink>
80104e67:	83 c4 10             	add    $0x10,%esp
80104e6a:	85 c0                	test   %eax,%eax
80104e6c:	79 92                	jns    80104e00 <create+0xf0>
      panic("create dots");
80104e6e:	83 ec 0c             	sub    $0xc,%esp
80104e71:	68 73 7e 10 80       	push   $0x80107e73
80104e76:	e8 05 b5 ff ff       	call   80100380 <panic>
80104e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e7f:	90                   	nop
}
80104e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e83:	31 f6                	xor    %esi,%esi
}
80104e85:	5b                   	pop    %ebx
80104e86:	89 f0                	mov    %esi,%eax
80104e88:	5e                   	pop    %esi
80104e89:	5f                   	pop    %edi
80104e8a:	5d                   	pop    %ebp
80104e8b:	c3                   	ret    
    panic("create: dirlink");
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	68 82 7e 10 80       	push   $0x80107e82
80104e94:	e8 e7 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e99:	83 ec 0c             	sub    $0xc,%esp
80104e9c:	68 64 7e 10 80       	push   $0x80107e64
80104ea1:	e8 da b4 ff ff       	call   80100380 <panic>
80104ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ead:	8d 76 00             	lea    0x0(%esi),%esi

80104eb0 <sys_dup>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104eb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104eb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ebb:	50                   	push   %eax
80104ebc:	6a 00                	push   $0x0
80104ebe:	e8 9d fc ff ff       	call   80104b60 <argint>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	78 36                	js     80104f00 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ece:	77 30                	ja     80104f00 <sys_dup+0x50>
80104ed0:	e8 5b ec ff ff       	call   80103b30 <myproc>
80104ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ed8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104edc:	85 f6                	test   %esi,%esi
80104ede:	74 20                	je     80104f00 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ee0:	e8 4b ec ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ee5:	31 db                	xor    %ebx,%ebx
80104ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ef0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104ef4:	85 d2                	test   %edx,%edx
80104ef6:	74 18                	je     80104f10 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ef8:	83 c3 01             	add    $0x1,%ebx
80104efb:	83 fb 10             	cmp    $0x10,%ebx
80104efe:	75 f0                	jne    80104ef0 <sys_dup+0x40>
}
80104f00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f08:	89 d8                	mov    %ebx,%eax
80104f0a:	5b                   	pop    %ebx
80104f0b:	5e                   	pop    %esi
80104f0c:	5d                   	pop    %ebp
80104f0d:	c3                   	ret    
80104f0e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f13:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104f17:	56                   	push   %esi
80104f18:	e8 83 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104f1d:	83 c4 10             	add    $0x10,%esp
}
80104f20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f23:	89 d8                	mov    %ebx,%eax
80104f25:	5b                   	pop    %ebx
80104f26:	5e                   	pop    %esi
80104f27:	5d                   	pop    %ebp
80104f28:	c3                   	ret    
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f30 <sys_read>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f3b:	53                   	push   %ebx
80104f3c:	6a 00                	push   $0x0
80104f3e:	e8 1d fc ff ff       	call   80104b60 <argint>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	85 c0                	test   %eax,%eax
80104f48:	78 5e                	js     80104fa8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f4e:	77 58                	ja     80104fa8 <sys_read+0x78>
80104f50:	e8 db eb ff ff       	call   80103b30 <myproc>
80104f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f58:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104f5c:	85 f6                	test   %esi,%esi
80104f5e:	74 48                	je     80104fa8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f60:	83 ec 08             	sub    $0x8,%esp
80104f63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f66:	50                   	push   %eax
80104f67:	6a 02                	push   $0x2
80104f69:	e8 f2 fb ff ff       	call   80104b60 <argint>
80104f6e:	83 c4 10             	add    $0x10,%esp
80104f71:	85 c0                	test   %eax,%eax
80104f73:	78 33                	js     80104fa8 <sys_read+0x78>
80104f75:	83 ec 04             	sub    $0x4,%esp
80104f78:	ff 75 f0             	push   -0x10(%ebp)
80104f7b:	53                   	push   %ebx
80104f7c:	6a 01                	push   $0x1
80104f7e:	e8 2d fc ff ff       	call   80104bb0 <argptr>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 1e                	js     80104fa8 <sys_read+0x78>
  return fileread(f, p, n);
80104f8a:	83 ec 04             	sub    $0x4,%esp
80104f8d:	ff 75 f0             	push   -0x10(%ebp)
80104f90:	ff 75 f4             	push   -0xc(%ebp)
80104f93:	56                   	push   %esi
80104f94:	e8 87 c0 ff ff       	call   80101020 <fileread>
80104f99:	83 c4 10             	add    $0x10,%esp
}
80104f9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f9f:	5b                   	pop    %ebx
80104fa0:	5e                   	pop    %esi
80104fa1:	5d                   	pop    %ebp
80104fa2:	c3                   	ret    
80104fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fa7:	90                   	nop
    return -1;
80104fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fad:	eb ed                	jmp    80104f9c <sys_read+0x6c>
80104faf:	90                   	nop

80104fb0 <sys_write>:
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fbb:	53                   	push   %ebx
80104fbc:	6a 00                	push   $0x0
80104fbe:	e8 9d fb ff ff       	call   80104b60 <argint>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 5e                	js     80105028 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fce:	77 58                	ja     80105028 <sys_write+0x78>
80104fd0:	e8 5b eb ff ff       	call   80103b30 <myproc>
80104fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fd8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104fdc:	85 f6                	test   %esi,%esi
80104fde:	74 48                	je     80105028 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fe0:	83 ec 08             	sub    $0x8,%esp
80104fe3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fe6:	50                   	push   %eax
80104fe7:	6a 02                	push   $0x2
80104fe9:	e8 72 fb ff ff       	call   80104b60 <argint>
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	85 c0                	test   %eax,%eax
80104ff3:	78 33                	js     80105028 <sys_write+0x78>
80104ff5:	83 ec 04             	sub    $0x4,%esp
80104ff8:	ff 75 f0             	push   -0x10(%ebp)
80104ffb:	53                   	push   %ebx
80104ffc:	6a 01                	push   $0x1
80104ffe:	e8 ad fb ff ff       	call   80104bb0 <argptr>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 1e                	js     80105028 <sys_write+0x78>
  return filewrite(f, p, n);
8010500a:	83 ec 04             	sub    $0x4,%esp
8010500d:	ff 75 f0             	push   -0x10(%ebp)
80105010:	ff 75 f4             	push   -0xc(%ebp)
80105013:	56                   	push   %esi
80105014:	e8 97 c0 ff ff       	call   801010b0 <filewrite>
80105019:	83 c4 10             	add    $0x10,%esp
}
8010501c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010501f:	5b                   	pop    %ebx
80105020:	5e                   	pop    %esi
80105021:	5d                   	pop    %ebp
80105022:	c3                   	ret    
80105023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105027:	90                   	nop
    return -1;
80105028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502d:	eb ed                	jmp    8010501c <sys_write+0x6c>
8010502f:	90                   	nop

80105030 <sys_close>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105035:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105038:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503b:	50                   	push   %eax
8010503c:	6a 00                	push   $0x0
8010503e:	e8 1d fb ff ff       	call   80104b60 <argint>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 3e                	js     80105088 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010504e:	77 38                	ja     80105088 <sys_close+0x58>
80105050:	e8 db ea ff ff       	call   80103b30 <myproc>
80105055:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105058:	8d 5a 08             	lea    0x8(%edx),%ebx
8010505b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010505f:	85 f6                	test   %esi,%esi
80105061:	74 25                	je     80105088 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105063:	e8 c8 ea ff ff       	call   80103b30 <myproc>
  fileclose(f);
80105068:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010506b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
80105072:	00 
  fileclose(f);
80105073:	56                   	push   %esi
80105074:	e8 77 be ff ff       	call   80100ef0 <fileclose>
  return 0;
80105079:	83 c4 10             	add    $0x10,%esp
8010507c:	31 c0                	xor    %eax,%eax
}
8010507e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105081:	5b                   	pop    %ebx
80105082:	5e                   	pop    %esi
80105083:	5d                   	pop    %ebp
80105084:	c3                   	ret    
80105085:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508d:	eb ef                	jmp    8010507e <sys_close+0x4e>
8010508f:	90                   	nop

80105090 <sys_fstat>:
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105095:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105098:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010509b:	53                   	push   %ebx
8010509c:	6a 00                	push   $0x0
8010509e:	e8 bd fa ff ff       	call   80104b60 <argint>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	78 46                	js     801050f0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ae:	77 40                	ja     801050f0 <sys_fstat+0x60>
801050b0:	e8 7b ea ff ff       	call   80103b30 <myproc>
801050b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050b8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801050bc:	85 f6                	test   %esi,%esi
801050be:	74 30                	je     801050f0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050c0:	83 ec 04             	sub    $0x4,%esp
801050c3:	6a 14                	push   $0x14
801050c5:	53                   	push   %ebx
801050c6:	6a 01                	push   $0x1
801050c8:	e8 e3 fa ff ff       	call   80104bb0 <argptr>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 1c                	js     801050f0 <sys_fstat+0x60>
  return filestat(f, st);
801050d4:	83 ec 08             	sub    $0x8,%esp
801050d7:	ff 75 f4             	push   -0xc(%ebp)
801050da:	56                   	push   %esi
801050db:	e8 f0 be ff ff       	call   80100fd0 <filestat>
801050e0:	83 c4 10             	add    $0x10,%esp
}
801050e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e6:	5b                   	pop    %ebx
801050e7:	5e                   	pop    %esi
801050e8:	5d                   	pop    %ebp
801050e9:	c3                   	ret    
801050ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f5:	eb ec                	jmp    801050e3 <sys_fstat+0x53>
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax

80105100 <sys_link>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105105:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105108:	53                   	push   %ebx
80105109:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010510c:	50                   	push   %eax
8010510d:	6a 00                	push   $0x0
8010510f:	e8 0c fb ff ff       	call   80104c20 <argstr>
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	85 c0                	test   %eax,%eax
80105119:	0f 88 fb 00 00 00    	js     8010521a <sys_link+0x11a>
8010511f:	83 ec 08             	sub    $0x8,%esp
80105122:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105125:	50                   	push   %eax
80105126:	6a 01                	push   $0x1
80105128:	e8 f3 fa ff ff       	call   80104c20 <argstr>
8010512d:	83 c4 10             	add    $0x10,%esp
80105130:	85 c0                	test   %eax,%eax
80105132:	0f 88 e2 00 00 00    	js     8010521a <sys_link+0x11a>
  begin_op();
80105138:	e8 d3 dd ff ff       	call   80102f10 <begin_op>
  if((ip = namei(old)) == 0){
8010513d:	83 ec 0c             	sub    $0xc,%esp
80105140:	ff 75 d4             	push   -0x2c(%ebp)
80105143:	e8 58 cf ff ff       	call   801020a0 <namei>
80105148:	83 c4 10             	add    $0x10,%esp
8010514b:	89 c3                	mov    %eax,%ebx
8010514d:	85 c0                	test   %eax,%eax
8010514f:	0f 84 e4 00 00 00    	je     80105239 <sys_link+0x139>
  ilock(ip);
80105155:	83 ec 0c             	sub    $0xc,%esp
80105158:	50                   	push   %eax
80105159:	e8 22 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010515e:	83 c4 10             	add    $0x10,%esp
80105161:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105166:	0f 84 b5 00 00 00    	je     80105221 <sys_link+0x121>
  iupdate(ip);
8010516c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010516f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105174:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105177:	53                   	push   %ebx
80105178:	e8 53 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010517d:	89 1c 24             	mov    %ebx,(%esp)
80105180:	e8 db c6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105185:	58                   	pop    %eax
80105186:	5a                   	pop    %edx
80105187:	57                   	push   %edi
80105188:	ff 75 d0             	push   -0x30(%ebp)
8010518b:	e8 30 cf ff ff       	call   801020c0 <nameiparent>
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	89 c6                	mov    %eax,%esi
80105195:	85 c0                	test   %eax,%eax
80105197:	74 5b                	je     801051f4 <sys_link+0xf4>
  ilock(dp);
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	50                   	push   %eax
8010519d:	e8 de c5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051a2:	8b 03                	mov    (%ebx),%eax
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	39 06                	cmp    %eax,(%esi)
801051a9:	75 3d                	jne    801051e8 <sys_link+0xe8>
801051ab:	83 ec 04             	sub    $0x4,%esp
801051ae:	ff 73 04             	push   0x4(%ebx)
801051b1:	57                   	push   %edi
801051b2:	56                   	push   %esi
801051b3:	e8 28 ce ff ff       	call   80101fe0 <dirlink>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	85 c0                	test   %eax,%eax
801051bd:	78 29                	js     801051e8 <sys_link+0xe8>
  iunlockput(dp);
801051bf:	83 ec 0c             	sub    $0xc,%esp
801051c2:	56                   	push   %esi
801051c3:	e8 48 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801051c8:	89 1c 24             	mov    %ebx,(%esp)
801051cb:	e8 e0 c6 ff ff       	call   801018b0 <iput>
  end_op();
801051d0:	e8 ab dd ff ff       	call   80102f80 <end_op>
  return 0;
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	31 c0                	xor    %eax,%eax
}
801051da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051dd:	5b                   	pop    %ebx
801051de:	5e                   	pop    %esi
801051df:	5f                   	pop    %edi
801051e0:	5d                   	pop    %ebp
801051e1:	c3                   	ret    
801051e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051e8:	83 ec 0c             	sub    $0xc,%esp
801051eb:	56                   	push   %esi
801051ec:	e8 1f c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	53                   	push   %ebx
801051f8:	e8 83 c5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801051fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105202:	89 1c 24             	mov    %ebx,(%esp)
80105205:	e8 c6 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010520a:	89 1c 24             	mov    %ebx,(%esp)
8010520d:	e8 fe c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105212:	e8 69 dd ff ff       	call   80102f80 <end_op>
  return -1;
80105217:	83 c4 10             	add    $0x10,%esp
8010521a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521f:	eb b9                	jmp    801051da <sys_link+0xda>
    iunlockput(ip);
80105221:	83 ec 0c             	sub    $0xc,%esp
80105224:	53                   	push   %ebx
80105225:	e8 e6 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010522a:	e8 51 dd ff ff       	call   80102f80 <end_op>
    return -1;
8010522f:	83 c4 10             	add    $0x10,%esp
80105232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105237:	eb a1                	jmp    801051da <sys_link+0xda>
    end_op();
80105239:	e8 42 dd ff ff       	call   80102f80 <end_op>
    return -1;
8010523e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105243:	eb 95                	jmp    801051da <sys_link+0xda>
80105245:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_unlink>:
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105255:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105258:	53                   	push   %ebx
80105259:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010525c:	50                   	push   %eax
8010525d:	6a 00                	push   $0x0
8010525f:	e8 bc f9 ff ff       	call   80104c20 <argstr>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	0f 88 7a 01 00 00    	js     801053e9 <sys_unlink+0x199>
  begin_op();
8010526f:	e8 9c dc ff ff       	call   80102f10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105274:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105277:	83 ec 08             	sub    $0x8,%esp
8010527a:	53                   	push   %ebx
8010527b:	ff 75 c0             	push   -0x40(%ebp)
8010527e:	e8 3d ce ff ff       	call   801020c0 <nameiparent>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105289:	85 c0                	test   %eax,%eax
8010528b:	0f 84 62 01 00 00    	je     801053f3 <sys_unlink+0x1a3>
  ilock(dp);
80105291:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	57                   	push   %edi
80105298:	e8 e3 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010529d:	58                   	pop    %eax
8010529e:	5a                   	pop    %edx
8010529f:	68 80 7e 10 80       	push   $0x80107e80
801052a4:	53                   	push   %ebx
801052a5:	e8 16 ca ff ff       	call   80101cc0 <namecmp>
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	85 c0                	test   %eax,%eax
801052af:	0f 84 fb 00 00 00    	je     801053b0 <sys_unlink+0x160>
801052b5:	83 ec 08             	sub    $0x8,%esp
801052b8:	68 7f 7e 10 80       	push   $0x80107e7f
801052bd:	53                   	push   %ebx
801052be:	e8 fd c9 ff ff       	call   80101cc0 <namecmp>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	0f 84 e2 00 00 00    	je     801053b0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052ce:	83 ec 04             	sub    $0x4,%esp
801052d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052d4:	50                   	push   %eax
801052d5:	53                   	push   %ebx
801052d6:	57                   	push   %edi
801052d7:	e8 04 ca ff ff       	call   80101ce0 <dirlookup>
801052dc:	83 c4 10             	add    $0x10,%esp
801052df:	89 c3                	mov    %eax,%ebx
801052e1:	85 c0                	test   %eax,%eax
801052e3:	0f 84 c7 00 00 00    	je     801053b0 <sys_unlink+0x160>
  ilock(ip);
801052e9:	83 ec 0c             	sub    $0xc,%esp
801052ec:	50                   	push   %eax
801052ed:	e8 8e c4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052fa:	0f 8e 1c 01 00 00    	jle    8010541c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105300:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105305:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105308:	74 66                	je     80105370 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010530a:	83 ec 04             	sub    $0x4,%esp
8010530d:	6a 10                	push   $0x10
8010530f:	6a 00                	push   $0x0
80105311:	57                   	push   %edi
80105312:	e8 89 f5 ff ff       	call   801048a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105317:	6a 10                	push   $0x10
80105319:	ff 75 c4             	push   -0x3c(%ebp)
8010531c:	57                   	push   %edi
8010531d:	ff 75 b4             	push   -0x4c(%ebp)
80105320:	e8 6b c8 ff ff       	call   80101b90 <writei>
80105325:	83 c4 20             	add    $0x20,%esp
80105328:	83 f8 10             	cmp    $0x10,%eax
8010532b:	0f 85 de 00 00 00    	jne    8010540f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105331:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105336:	0f 84 94 00 00 00    	je     801053d0 <sys_unlink+0x180>
  iunlockput(dp);
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	ff 75 b4             	push   -0x4c(%ebp)
80105342:	e8 c9 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105347:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010534c:	89 1c 24             	mov    %ebx,(%esp)
8010534f:	e8 7c c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105354:	89 1c 24             	mov    %ebx,(%esp)
80105357:	e8 b4 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010535c:	e8 1f dc ff ff       	call   80102f80 <end_op>
  return 0;
80105361:	83 c4 10             	add    $0x10,%esp
80105364:	31 c0                	xor    %eax,%eax
}
80105366:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105369:	5b                   	pop    %ebx
8010536a:	5e                   	pop    %esi
8010536b:	5f                   	pop    %edi
8010536c:	5d                   	pop    %ebp
8010536d:	c3                   	ret    
8010536e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105370:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105374:	76 94                	jbe    8010530a <sys_unlink+0xba>
80105376:	be 20 00 00 00       	mov    $0x20,%esi
8010537b:	eb 0b                	jmp    80105388 <sys_unlink+0x138>
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
80105380:	83 c6 10             	add    $0x10,%esi
80105383:	3b 73 58             	cmp    0x58(%ebx),%esi
80105386:	73 82                	jae    8010530a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105388:	6a 10                	push   $0x10
8010538a:	56                   	push   %esi
8010538b:	57                   	push   %edi
8010538c:	53                   	push   %ebx
8010538d:	e8 fe c6 ff ff       	call   80101a90 <readi>
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	83 f8 10             	cmp    $0x10,%eax
80105398:	75 68                	jne    80105402 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010539a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010539f:	74 df                	je     80105380 <sys_unlink+0x130>
    iunlockput(ip);
801053a1:	83 ec 0c             	sub    $0xc,%esp
801053a4:	53                   	push   %ebx
801053a5:	e8 66 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	ff 75 b4             	push   -0x4c(%ebp)
801053b6:	e8 55 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053bb:	e8 c0 db ff ff       	call   80102f80 <end_op>
  return -1;
801053c0:	83 c4 10             	add    $0x10,%esp
801053c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c8:	eb 9c                	jmp    80105366 <sys_unlink+0x116>
801053ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053d6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053db:	50                   	push   %eax
801053dc:	e8 ef c2 ff ff       	call   801016d0 <iupdate>
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	e9 53 ff ff ff       	jmp    8010533c <sys_unlink+0xec>
    return -1;
801053e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ee:	e9 73 ff ff ff       	jmp    80105366 <sys_unlink+0x116>
    end_op();
801053f3:	e8 88 db ff ff       	call   80102f80 <end_op>
    return -1;
801053f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053fd:	e9 64 ff ff ff       	jmp    80105366 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105402:	83 ec 0c             	sub    $0xc,%esp
80105405:	68 a4 7e 10 80       	push   $0x80107ea4
8010540a:	e8 71 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010540f:	83 ec 0c             	sub    $0xc,%esp
80105412:	68 b6 7e 10 80       	push   $0x80107eb6
80105417:	e8 64 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010541c:	83 ec 0c             	sub    $0xc,%esp
8010541f:	68 92 7e 10 80       	push   $0x80107e92
80105424:	e8 57 af ff ff       	call   80100380 <panic>
80105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_open>:

int
sys_open(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105435:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105438:	53                   	push   %ebx
80105439:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010543c:	50                   	push   %eax
8010543d:	6a 00                	push   $0x0
8010543f:	e8 dc f7 ff ff       	call   80104c20 <argstr>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	0f 88 8e 00 00 00    	js     801054dd <sys_open+0xad>
8010544f:	83 ec 08             	sub    $0x8,%esp
80105452:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105455:	50                   	push   %eax
80105456:	6a 01                	push   $0x1
80105458:	e8 03 f7 ff ff       	call   80104b60 <argint>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	78 79                	js     801054dd <sys_open+0xad>
    return -1;

  begin_op();
80105464:	e8 a7 da ff ff       	call   80102f10 <begin_op>

  if(omode & O_CREATE){
80105469:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010546d:	75 79                	jne    801054e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010546f:	83 ec 0c             	sub    $0xc,%esp
80105472:	ff 75 e0             	push   -0x20(%ebp)
80105475:	e8 26 cc ff ff       	call   801020a0 <namei>
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	89 c6                	mov    %eax,%esi
8010547f:	85 c0                	test   %eax,%eax
80105481:	0f 84 7e 00 00 00    	je     80105505 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105487:	83 ec 0c             	sub    $0xc,%esp
8010548a:	50                   	push   %eax
8010548b:	e8 f0 c2 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105490:	83 c4 10             	add    $0x10,%esp
80105493:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105498:	0f 84 c2 00 00 00    	je     80105560 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010549e:	e8 8d b9 ff ff       	call   80100e30 <filealloc>
801054a3:	89 c7                	mov    %eax,%edi
801054a5:	85 c0                	test   %eax,%eax
801054a7:	74 23                	je     801054cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801054a9:	e8 82 e6 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054b0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801054b4:	85 d2                	test   %edx,%edx
801054b6:	74 60                	je     80105518 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054b8:	83 c3 01             	add    $0x1,%ebx
801054bb:	83 fb 10             	cmp    $0x10,%ebx
801054be:	75 f0                	jne    801054b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	57                   	push   %edi
801054c4:	e8 27 ba ff ff       	call   80100ef0 <fileclose>
801054c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054cc:	83 ec 0c             	sub    $0xc,%esp
801054cf:	56                   	push   %esi
801054d0:	e8 3b c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054d5:	e8 a6 da ff ff       	call   80102f80 <end_op>
    return -1;
801054da:	83 c4 10             	add    $0x10,%esp
801054dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054e2:	eb 6d                	jmp    80105551 <sys_open+0x121>
801054e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054e8:	83 ec 0c             	sub    $0xc,%esp
801054eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054ee:	31 c9                	xor    %ecx,%ecx
801054f0:	ba 02 00 00 00       	mov    $0x2,%edx
801054f5:	6a 00                	push   $0x0
801054f7:	e8 14 f8 ff ff       	call   80104d10 <create>
    if(ip == 0){
801054fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105501:	85 c0                	test   %eax,%eax
80105503:	75 99                	jne    8010549e <sys_open+0x6e>
      end_op();
80105505:	e8 76 da ff ff       	call   80102f80 <end_op>
      return -1;
8010550a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010550f:	eb 40                	jmp    80105551 <sys_open+0x121>
80105511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105518:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010551b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010551f:	56                   	push   %esi
80105520:	e8 3b c3 ff ff       	call   80101860 <iunlock>
  end_op();
80105525:	e8 56 da ff ff       	call   80102f80 <end_op>

  f->type = FD_INODE;
8010552a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105530:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105533:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105536:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105539:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010553b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105542:	f7 d0                	not    %eax
80105544:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105547:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010554a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010554d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105554:	89 d8                	mov    %ebx,%eax
80105556:	5b                   	pop    %ebx
80105557:	5e                   	pop    %esi
80105558:	5f                   	pop    %edi
80105559:	5d                   	pop    %ebp
8010555a:	c3                   	ret    
8010555b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010555f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105560:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105563:	85 c9                	test   %ecx,%ecx
80105565:	0f 84 33 ff ff ff    	je     8010549e <sys_open+0x6e>
8010556b:	e9 5c ff ff ff       	jmp    801054cc <sys_open+0x9c>

80105570 <sys_mkdir>:

int
sys_mkdir(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105576:	e8 95 d9 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010557b:	83 ec 08             	sub    $0x8,%esp
8010557e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105581:	50                   	push   %eax
80105582:	6a 00                	push   $0x0
80105584:	e8 97 f6 ff ff       	call   80104c20 <argstr>
80105589:	83 c4 10             	add    $0x10,%esp
8010558c:	85 c0                	test   %eax,%eax
8010558e:	78 30                	js     801055c0 <sys_mkdir+0x50>
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105596:	31 c9                	xor    %ecx,%ecx
80105598:	ba 01 00 00 00       	mov    $0x1,%edx
8010559d:	6a 00                	push   $0x0
8010559f:	e8 6c f7 ff ff       	call   80104d10 <create>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	74 15                	je     801055c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055ab:	83 ec 0c             	sub    $0xc,%esp
801055ae:	50                   	push   %eax
801055af:	e8 5c c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055b4:	e8 c7 d9 ff ff       	call   80102f80 <end_op>
  return 0;
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	31 c0                	xor    %eax,%eax
}
801055be:	c9                   	leave  
801055bf:	c3                   	ret    
    end_op();
801055c0:	e8 bb d9 ff ff       	call   80102f80 <end_op>
    return -1;
801055c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ca:	c9                   	leave  
801055cb:	c3                   	ret    
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_mknod>:

int
sys_mknod(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055d6:	e8 35 d9 ff ff       	call   80102f10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055db:	83 ec 08             	sub    $0x8,%esp
801055de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055e1:	50                   	push   %eax
801055e2:	6a 00                	push   $0x0
801055e4:	e8 37 f6 ff ff       	call   80104c20 <argstr>
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	85 c0                	test   %eax,%eax
801055ee:	78 60                	js     80105650 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055f0:	83 ec 08             	sub    $0x8,%esp
801055f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055f6:	50                   	push   %eax
801055f7:	6a 01                	push   $0x1
801055f9:	e8 62 f5 ff ff       	call   80104b60 <argint>
  if((argstr(0, &path)) < 0 ||
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	78 4b                	js     80105650 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105605:	83 ec 08             	sub    $0x8,%esp
80105608:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010560b:	50                   	push   %eax
8010560c:	6a 02                	push   $0x2
8010560e:	e8 4d f5 ff ff       	call   80104b60 <argint>
     argint(1, &major) < 0 ||
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	85 c0                	test   %eax,%eax
80105618:	78 36                	js     80105650 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010561a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010561e:	83 ec 0c             	sub    $0xc,%esp
80105621:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105625:	ba 03 00 00 00       	mov    $0x3,%edx
8010562a:	50                   	push   %eax
8010562b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010562e:	e8 dd f6 ff ff       	call   80104d10 <create>
     argint(2, &minor) < 0 ||
80105633:	83 c4 10             	add    $0x10,%esp
80105636:	85 c0                	test   %eax,%eax
80105638:	74 16                	je     80105650 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010563a:	83 ec 0c             	sub    $0xc,%esp
8010563d:	50                   	push   %eax
8010563e:	e8 cd c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105643:	e8 38 d9 ff ff       	call   80102f80 <end_op>
  return 0;
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	31 c0                	xor    %eax,%eax
}
8010564d:	c9                   	leave  
8010564e:	c3                   	ret    
8010564f:	90                   	nop
    end_op();
80105650:	e8 2b d9 ff ff       	call   80102f80 <end_op>
    return -1;
80105655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010565a:	c9                   	leave  
8010565b:	c3                   	ret    
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_chdir>:

int
sys_chdir(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	56                   	push   %esi
80105664:	53                   	push   %ebx
80105665:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105668:	e8 c3 e4 ff ff       	call   80103b30 <myproc>
8010566d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010566f:	e8 9c d8 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105674:	83 ec 08             	sub    $0x8,%esp
80105677:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567a:	50                   	push   %eax
8010567b:	6a 00                	push   $0x0
8010567d:	e8 9e f5 ff ff       	call   80104c20 <argstr>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	85 c0                	test   %eax,%eax
80105687:	78 77                	js     80105700 <sys_chdir+0xa0>
80105689:	83 ec 0c             	sub    $0xc,%esp
8010568c:	ff 75 f4             	push   -0xc(%ebp)
8010568f:	e8 0c ca ff ff       	call   801020a0 <namei>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	89 c3                	mov    %eax,%ebx
80105699:	85 c0                	test   %eax,%eax
8010569b:	74 63                	je     80105700 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010569d:	83 ec 0c             	sub    $0xc,%esp
801056a0:	50                   	push   %eax
801056a1:	e8 da c0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ae:	75 30                	jne    801056e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	53                   	push   %ebx
801056b4:	e8 a7 c1 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801056b9:	58                   	pop    %eax
801056ba:	ff 76 6c             	push   0x6c(%esi)
801056bd:	e8 ee c1 ff ff       	call   801018b0 <iput>
  end_op();
801056c2:	e8 b9 d8 ff ff       	call   80102f80 <end_op>
  curproc->cwd = ip;
801056c7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	31 c0                	xor    %eax,%eax
}
801056cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056d2:	5b                   	pop    %ebx
801056d3:	5e                   	pop    %esi
801056d4:	5d                   	pop    %ebp
801056d5:	c3                   	ret    
801056d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	53                   	push   %ebx
801056e4:	e8 27 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056e9:	e8 92 d8 ff ff       	call   80102f80 <end_op>
    return -1;
801056ee:	83 c4 10             	add    $0x10,%esp
801056f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f6:	eb d7                	jmp    801056cf <sys_chdir+0x6f>
801056f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ff:	90                   	nop
    end_op();
80105700:	e8 7b d8 ff ff       	call   80102f80 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570a:	eb c3                	jmp    801056cf <sys_chdir+0x6f>
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_exec>:

int
sys_exec(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105715:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010571b:	53                   	push   %ebx
8010571c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105722:	50                   	push   %eax
80105723:	6a 00                	push   $0x0
80105725:	e8 f6 f4 ff ff       	call   80104c20 <argstr>
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	85 c0                	test   %eax,%eax
8010572f:	0f 88 87 00 00 00    	js     801057bc <sys_exec+0xac>
80105735:	83 ec 08             	sub    $0x8,%esp
80105738:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010573e:	50                   	push   %eax
8010573f:	6a 01                	push   $0x1
80105741:	e8 1a f4 ff ff       	call   80104b60 <argint>
80105746:	83 c4 10             	add    $0x10,%esp
80105749:	85 c0                	test   %eax,%eax
8010574b:	78 6f                	js     801057bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010574d:	83 ec 04             	sub    $0x4,%esp
80105750:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105756:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105758:	68 80 00 00 00       	push   $0x80
8010575d:	6a 00                	push   $0x0
8010575f:	56                   	push   %esi
80105760:	e8 3b f1 ff ff       	call   801048a0 <memset>
80105765:	83 c4 10             	add    $0x10,%esp
80105768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105770:	83 ec 08             	sub    $0x8,%esp
80105773:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105779:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105780:	50                   	push   %eax
80105781:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105787:	01 f8                	add    %edi,%eax
80105789:	50                   	push   %eax
8010578a:	e8 41 f3 ff ff       	call   80104ad0 <fetchint>
8010578f:	83 c4 10             	add    $0x10,%esp
80105792:	85 c0                	test   %eax,%eax
80105794:	78 26                	js     801057bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105796:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010579c:	85 c0                	test   %eax,%eax
8010579e:	74 30                	je     801057d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057a0:	83 ec 08             	sub    $0x8,%esp
801057a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057a6:	52                   	push   %edx
801057a7:	50                   	push   %eax
801057a8:	e8 63 f3 ff ff       	call   80104b10 <fetchstr>
801057ad:	83 c4 10             	add    $0x10,%esp
801057b0:	85 c0                	test   %eax,%eax
801057b2:	78 08                	js     801057bc <sys_exec+0xac>
  for(i=0;; i++){
801057b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057b7:	83 fb 20             	cmp    $0x20,%ebx
801057ba:	75 b4                	jne    80105770 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c4:	5b                   	pop    %ebx
801057c5:	5e                   	pop    %esi
801057c6:	5f                   	pop    %edi
801057c7:	5d                   	pop    %ebp
801057c8:	c3                   	ret    
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057d7:	00 00 00 00 
  return exec(path, argv);
801057db:	83 ec 08             	sub    $0x8,%esp
801057de:	56                   	push   %esi
801057df:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057e5:	e8 c6 b2 ff ff       	call   80100ab0 <exec>
801057ea:	83 c4 10             	add    $0x10,%esp
}
801057ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f0:	5b                   	pop    %ebx
801057f1:	5e                   	pop    %esi
801057f2:	5f                   	pop    %edi
801057f3:	5d                   	pop    %ebp
801057f4:	c3                   	ret    
801057f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_pipe>:

int
sys_pipe(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105805:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105808:	53                   	push   %ebx
80105809:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010580c:	6a 08                	push   $0x8
8010580e:	50                   	push   %eax
8010580f:	6a 00                	push   $0x0
80105811:	e8 9a f3 ff ff       	call   80104bb0 <argptr>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	78 4a                	js     80105867 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010581d:	83 ec 08             	sub    $0x8,%esp
80105820:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105823:	50                   	push   %eax
80105824:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105827:	50                   	push   %eax
80105828:	e8 c3 dd ff ff       	call   801035f0 <pipealloc>
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	85 c0                	test   %eax,%eax
80105832:	78 33                	js     80105867 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105834:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105837:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105839:	e8 f2 e2 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010583e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105840:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105844:	85 f6                	test   %esi,%esi
80105846:	74 28                	je     80105870 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105848:	83 c3 01             	add    $0x1,%ebx
8010584b:	83 fb 10             	cmp    $0x10,%ebx
8010584e:	75 f0                	jne    80105840 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105850:	83 ec 0c             	sub    $0xc,%esp
80105853:	ff 75 e0             	push   -0x20(%ebp)
80105856:	e8 95 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010585b:	58                   	pop    %eax
8010585c:	ff 75 e4             	push   -0x1c(%ebp)
8010585f:	e8 8c b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586c:	eb 53                	jmp    801058c1 <sys_pipe+0xc1>
8010586e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105870:	8d 73 08             	lea    0x8(%ebx),%esi
80105873:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105877:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010587a:	e8 b1 e2 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010587f:	31 d2                	xor    %edx,%edx
80105881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105888:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
8010588c:	85 c9                	test   %ecx,%ecx
8010588e:	74 20                	je     801058b0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105890:	83 c2 01             	add    $0x1,%edx
80105893:	83 fa 10             	cmp    $0x10,%edx
80105896:	75 f0                	jne    80105888 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105898:	e8 93 e2 ff ff       	call   80103b30 <myproc>
8010589d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
801058a4:	00 
801058a5:	eb a9                	jmp    80105850 <sys_pipe+0x50>
801058a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058b0:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
801058b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058bf:	31 c0                	xor    %eax,%eax
}
801058c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c4:	5b                   	pop    %ebx
801058c5:	5e                   	pop    %esi
801058c6:	5f                   	pop    %edi
801058c7:	5d                   	pop    %ebp
801058c8:	c3                   	ret    
801058c9:	66 90                	xchg   %ax,%ax
801058cb:	66 90                	xchg   %ax,%ax
801058cd:	66 90                	xchg   %ax,%ax
801058cf:	90                   	nop

801058d0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801058d0:	e9 7b e4 ff ff       	jmp    80103d50 <fork>
801058d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_exit>:
}

int
sys_exit(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058e6:	e8 e5 e6 ff ff       	call   80103fd0 <exit>
  return 0;  // not reached
}
801058eb:	31 c0                	xor    %eax,%eax
801058ed:	c9                   	leave  
801058ee:	c3                   	ret    
801058ef:	90                   	nop

801058f0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058f0:	e9 0b e8 ff ff       	jmp    80104100 <wait>
801058f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_kill>:
}

int
sys_kill(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105906:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105909:	50                   	push   %eax
8010590a:	6a 00                	push   $0x0
8010590c:	e8 4f f2 ff ff       	call   80104b60 <argint>
80105911:	83 c4 10             	add    $0x10,%esp
80105914:	85 c0                	test   %eax,%eax
80105916:	78 18                	js     80105930 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105918:	83 ec 0c             	sub    $0xc,%esp
8010591b:	ff 75 f4             	push   -0xc(%ebp)
8010591e:	e8 7d ea ff ff       	call   801043a0 <kill>
80105923:	83 c4 10             	add    $0x10,%esp
}
80105926:	c9                   	leave  
80105927:	c3                   	ret    
80105928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592f:	90                   	nop
80105930:	c9                   	leave  
    return -1;
80105931:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105936:	c3                   	ret    
80105937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593e:	66 90                	xchg   %ax,%ax

80105940 <sys_getpid>:

int
sys_getpid(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105946:	e8 e5 e1 ff ff       	call   80103b30 <myproc>
8010594b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010594e:	c9                   	leave  
8010594f:	c3                   	ret    

80105950 <sys_sbrk>:

int
sys_sbrk(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105957:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010595a:	50                   	push   %eax
8010595b:	6a 00                	push   $0x0
8010595d:	e8 fe f1 ff ff       	call   80104b60 <argint>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	78 27                	js     80105990 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105969:	e8 c2 e1 ff ff       	call   80103b30 <myproc>
  if(growproc(n) < 0)
8010596e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105971:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105973:	ff 75 f4             	push   -0xc(%ebp)
80105976:	e8 d5 e2 ff ff       	call   80103c50 <growproc>
8010597b:	83 c4 10             	add    $0x10,%esp
8010597e:	85 c0                	test   %eax,%eax
80105980:	78 0e                	js     80105990 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105982:	89 d8                	mov    %ebx,%eax
80105984:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105987:	c9                   	leave  
80105988:	c3                   	ret    
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105990:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105995:	eb eb                	jmp    80105982 <sys_sbrk+0x32>
80105997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <sys_shugebrk>:
// TODO: implement this
// part 2
// TODO: add growhugeproc
int
sys_shugebrk(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059aa:	50                   	push   %eax
801059ab:	6a 00                	push   $0x0
801059ad:	e8 ae f1 ff ff       	call   80104b60 <argint>
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	85 c0                	test   %eax,%eax
801059b7:	78 27                	js     801059e0 <sys_shugebrk+0x40>
    return -1;
  addr = myproc()->hugesz;
801059b9:	e8 72 e1 ff ff       	call   80103b30 <myproc>
  if(growhugeproc(n + HUGE_VA_OFFSET) < 0)
801059be:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->hugesz;
801059c1:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growhugeproc(n + HUGE_VA_OFFSET) < 0)
801059c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c7:	05 00 00 00 1e       	add    $0x1e000000,%eax
801059cc:	50                   	push   %eax
801059cd:	e8 fe e2 ff ff       	call   80103cd0 <growhugeproc>
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	85 c0                	test   %eax,%eax
801059d7:	78 07                	js     801059e0 <sys_shugebrk+0x40>
    return -1;
  return addr;
}
801059d9:	89 d8                	mov    %ebx,%eax
801059db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059de:	c9                   	leave  
801059df:	c3                   	ret    
    return -1;
801059e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059e5:	eb f2                	jmp    801059d9 <sys_shugebrk+0x39>
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <sys_sleep>:

int
sys_sleep(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059fa:	50                   	push   %eax
801059fb:	6a 00                	push   $0x0
801059fd:	e8 5e f1 ff ff       	call   80104b60 <argint>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	0f 88 8a 00 00 00    	js     80105a97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a0d:	83 ec 0c             	sub    $0xc,%esp
80105a10:	68 a0 4d 11 80       	push   $0x80114da0
80105a15:	e8 c6 ed ff ff       	call   801047e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a1d:	8b 1d 80 4d 11 80    	mov    0x80114d80,%ebx
  while(ticks - ticks0 < n){
80105a23:	83 c4 10             	add    $0x10,%esp
80105a26:	85 d2                	test   %edx,%edx
80105a28:	75 27                	jne    80105a51 <sys_sleep+0x61>
80105a2a:	eb 54                	jmp    80105a80 <sys_sleep+0x90>
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a30:	83 ec 08             	sub    $0x8,%esp
80105a33:	68 a0 4d 11 80       	push   $0x80114da0
80105a38:	68 80 4d 11 80       	push   $0x80114d80
80105a3d:	e8 3e e8 ff ff       	call   80104280 <sleep>
  while(ticks - ticks0 < n){
80105a42:	a1 80 4d 11 80       	mov    0x80114d80,%eax
80105a47:	83 c4 10             	add    $0x10,%esp
80105a4a:	29 d8                	sub    %ebx,%eax
80105a4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a4f:	73 2f                	jae    80105a80 <sys_sleep+0x90>
    if(myproc()->killed){
80105a51:	e8 da e0 ff ff       	call   80103b30 <myproc>
80105a56:	8b 40 28             	mov    0x28(%eax),%eax
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	74 d3                	je     80105a30 <sys_sleep+0x40>
      release(&tickslock);
80105a5d:	83 ec 0c             	sub    $0xc,%esp
80105a60:	68 a0 4d 11 80       	push   $0x80114da0
80105a65:	e8 16 ed ff ff       	call   80104780 <release>
  }
  release(&tickslock);
  return 0;
}
80105a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    
80105a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	68 a0 4d 11 80       	push   $0x80114da0
80105a88:	e8 f3 ec ff ff       	call   80104780 <release>
  return 0;
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	31 c0                	xor    %eax,%eax
}
80105a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
    return -1;
80105a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9c:	eb f4                	jmp    80105a92 <sys_sleep+0xa2>
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
80105aa4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105aa7:	68 a0 4d 11 80       	push   $0x80114da0
80105aac:	e8 2f ed ff ff       	call   801047e0 <acquire>
  xticks = ticks;
80105ab1:	8b 1d 80 4d 11 80    	mov    0x80114d80,%ebx
  release(&tickslock);
80105ab7:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80105abe:	e8 bd ec ff ff       	call   80104780 <release>
  return xticks;
}
80105ac3:	89 d8                	mov    %ebx,%eax
80105ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac8:	c9                   	leave  
80105ac9:	c3                   	ret    
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ad0 <sys_printhugepde>:

// System calls for debugging huge page allocations/mappings
int
sys_printhugepde()
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	56                   	push   %esi
80105ad5:	53                   	push   %ebx
  pde_t *pgdir = myproc()->pgdir;
  int pid = myproc()->pid;
  int i = 0;
  for (i = 0; i < 1024; i++) {
80105ad6:	31 db                	xor    %ebx,%ebx
{
80105ad8:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pgdir = myproc()->pgdir;
80105adb:	e8 50 e0 ff ff       	call   80103b30 <myproc>
80105ae0:	8b 78 08             	mov    0x8(%eax),%edi
  int pid = myproc()->pid;
80105ae3:	e8 48 e0 ff ff       	call   80103b30 <myproc>
80105ae8:	8b 70 14             	mov    0x14(%eax),%esi
  for (i = 0; i < 1024; i++) {
80105aeb:	eb 0e                	jmp    80105afb <sys_printhugepde+0x2b>
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
80105af0:	83 c3 01             	add    $0x1,%ebx
80105af3:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105af9:	74 2e                	je     80105b29 <sys_printhugepde+0x59>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P))
80105afb:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80105afe:	89 c2                	mov    %eax,%edx
80105b00:	81 e2 85 00 00 00    	and    $0x85,%edx
80105b06:	81 fa 85 00 00 00    	cmp    $0x85,%edx
80105b0c:	75 e2                	jne    80105af0 <sys_printhugepde+0x20>
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b0e:	50                   	push   %eax
80105b0f:	53                   	push   %ebx
  for (i = 0; i < 1024; i++) {
80105b10:	83 c3 01             	add    $0x1,%ebx
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b13:	56                   	push   %esi
80105b14:	68 c5 7e 10 80       	push   $0x80107ec5
80105b19:	e8 82 ab ff ff       	call   801006a0 <cprintf>
80105b1e:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 1024; i++) {
80105b21:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b27:	75 d2                	jne    80105afb <sys_printhugepde+0x2b>
  }
  return 0;
}
80105b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b2c:	31 c0                	xor    %eax,%eax
80105b2e:	5b                   	pop    %ebx
80105b2f:	5e                   	pop    %esi
80105b30:	5f                   	pop    %edi
80105b31:	5d                   	pop    %ebp
80105b32:	c3                   	ret    
80105b33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b40 <sys_procpgdirinfo>:

int
sys_procpgdirinfo()
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
  int *buf;
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b45:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105b48:	53                   	push   %ebx
80105b49:	83 ec 30             	sub    $0x30,%esp
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b4c:	6a 08                	push   $0x8
80105b4e:	50                   	push   %eax
80105b4f:	6a 00                	push   $0x0
80105b51:	e8 5a f0 ff ff       	call   80104bb0 <argptr>
80105b56:	83 c4 10             	add    $0x10,%esp
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	0f 88 90 00 00 00    	js     80105bf1 <sys_procpgdirinfo+0xb1>
    return -1;
  pde_t *pgdir = myproc()->pgdir;
80105b61:	e8 ca df ff ff       	call   80103b30 <myproc>
  int base_cnt = 0; // base page count
  int huge_cnt = 0; // huge page count
80105b66:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  int base_cnt = 0; // base page count
80105b6d:	31 c9                	xor    %ecx,%ecx
80105b6f:	8b 70 08             	mov    0x8(%eax),%esi
80105b72:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105b78:	eb 12                	jmp    80105b8c <sys_procpgdirinfo+0x4c>
80105b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i = 0;
  int j = 0;
  for (i = 0; i < 1024; i++) {
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
      ++huge_cnt;
    if((pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) && ((pgdir[i] & PTE_PS) == 0) /*Only PTE_P and PTE_U should be set for base pages*/) {
80105b80:	83 f8 05             	cmp    $0x5,%eax
80105b83:	74 3a                	je     80105bbf <sys_procpgdirinfo+0x7f>
  for (i = 0; i < 1024; i++) {
80105b85:	83 c6 04             	add    $0x4,%esi
80105b88:	39 f7                	cmp    %esi,%edi
80105b8a:	74 1b                	je     80105ba7 <sys_procpgdirinfo+0x67>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
80105b8c:	8b 1e                	mov    (%esi),%ebx
80105b8e:	89 d8                	mov    %ebx,%eax
80105b90:	25 85 00 00 00       	and    $0x85,%eax
80105b95:	3d 85 00 00 00       	cmp    $0x85,%eax
80105b9a:	75 e4                	jne    80105b80 <sys_procpgdirinfo+0x40>
  for (i = 0; i < 1024; i++) {
80105b9c:	83 c6 04             	add    $0x4,%esi
      ++huge_cnt;
80105b9f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  for (i = 0; i < 1024; i++) {
80105ba3:	39 f7                	cmp    %esi,%edi
80105ba5:	75 e5                	jne    80105b8c <sys_procpgdirinfo+0x4c>
          ++base_cnt;
        }
      }
    }
  }
  buf[0] = base_cnt; // base page count
80105ba7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  buf[1] = huge_cnt; // huge page count
80105baa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  buf[0] = base_cnt; // base page count
80105bad:	89 08                	mov    %ecx,(%eax)
  buf[1] = huge_cnt; // huge page count
80105baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bb2:	89 78 04             	mov    %edi,0x4(%eax)
  return 0;
80105bb5:	31 c0                	xor    %eax,%eax
}
80105bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bba:	5b                   	pop    %ebx
80105bbb:	5e                   	pop    %esi
80105bbc:	5f                   	pop    %edi
80105bbd:	5d                   	pop    %ebp
80105bbe:	c3                   	ret    
      uint* pgtab = (uint*)P2V(PTE_ADDR(pgdir[i]));
80105bbf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105bc5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
      for (j = 0; j < 1024; j++) {
80105bcb:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
80105bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((pgtab[j] & PTE_U) && (pgtab[j] & PTE_P)) {
80105bd8:	8b 10                	mov    (%eax),%edx
80105bda:	83 e2 05             	and    $0x5,%edx
          ++base_cnt;
80105bdd:	83 fa 05             	cmp    $0x5,%edx
80105be0:	0f 94 c2             	sete   %dl
      for (j = 0; j < 1024; j++) {
80105be3:	83 c0 04             	add    $0x4,%eax
          ++base_cnt;
80105be6:	0f b6 d2             	movzbl %dl,%edx
80105be9:	01 d1                	add    %edx,%ecx
      for (j = 0; j < 1024; j++) {
80105beb:	39 d8                	cmp    %ebx,%eax
80105bed:	75 e9                	jne    80105bd8 <sys_procpgdirinfo+0x98>
80105bef:	eb 94                	jmp    80105b85 <sys_procpgdirinfo+0x45>
    return -1;
80105bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf6:	eb bf                	jmp    80105bb7 <sys_procpgdirinfo+0x77>

80105bf8 <alltraps>:
80105bf8:	1e                   	push   %ds
80105bf9:	06                   	push   %es
80105bfa:	0f a0                	push   %fs
80105bfc:	0f a8                	push   %gs
80105bfe:	60                   	pusha  
80105bff:	66 b8 10 00          	mov    $0x10,%ax
80105c03:	8e d8                	mov    %eax,%ds
80105c05:	8e c0                	mov    %eax,%es
80105c07:	54                   	push   %esp
80105c08:	e8 c3 00 00 00       	call   80105cd0 <trap>
80105c0d:	83 c4 04             	add    $0x4,%esp

80105c10 <trapret>:
80105c10:	61                   	popa   
80105c11:	0f a9                	pop    %gs
80105c13:	0f a1                	pop    %fs
80105c15:	07                   	pop    %es
80105c16:	1f                   	pop    %ds
80105c17:	83 c4 08             	add    $0x8,%esp
80105c1a:	cf                   	iret   
80105c1b:	66 90                	xchg   %ax,%ax
80105c1d:	66 90                	xchg   %ax,%ax
80105c1f:	90                   	nop

80105c20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c21:	31 c0                	xor    %eax,%eax
{
80105c23:	89 e5                	mov    %esp,%ebp
80105c25:	83 ec 08             	sub    $0x8,%esp
80105c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c30:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c37:	c7 04 c5 e2 4d 11 80 	movl   $0x8e000008,-0x7feeb21e(,%eax,8)
80105c3e:	08 00 00 8e 
80105c42:	66 89 14 c5 e0 4d 11 	mov    %dx,-0x7feeb220(,%eax,8)
80105c49:	80 
80105c4a:	c1 ea 10             	shr    $0x10,%edx
80105c4d:	66 89 14 c5 e6 4d 11 	mov    %dx,-0x7feeb21a(,%eax,8)
80105c54:	80 
  for(i = 0; i < 256; i++)
80105c55:	83 c0 01             	add    $0x1,%eax
80105c58:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c5d:	75 d1                	jne    80105c30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c5f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c62:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105c67:	c7 05 e2 4f 11 80 08 	movl   $0xef000008,0x80114fe2
80105c6e:	00 00 ef 
  initlock(&tickslock, "time");
80105c71:	68 de 7e 10 80       	push   $0x80107ede
80105c76:	68 a0 4d 11 80       	push   $0x80114da0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c7b:	66 a3 e0 4f 11 80    	mov    %ax,0x80114fe0
80105c81:	c1 e8 10             	shr    $0x10,%eax
80105c84:	66 a3 e6 4f 11 80    	mov    %ax,0x80114fe6
  initlock(&tickslock, "time");
80105c8a:	e8 81 e9 ff ff       	call   80104610 <initlock>
}
80105c8f:	83 c4 10             	add    $0x10,%esp
80105c92:	c9                   	leave  
80105c93:	c3                   	ret    
80105c94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop

80105ca0 <idtinit>:

void
idtinit(void)
{
80105ca0:	55                   	push   %ebp
  pd[0] = size-1;
80105ca1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ca6:	89 e5                	mov    %esp,%ebp
80105ca8:	83 ec 10             	sub    $0x10,%esp
80105cab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105caf:	b8 e0 4d 11 80       	mov    $0x80114de0,%eax
80105cb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cb8:	c1 e8 10             	shr    $0x10,%eax
80105cbb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cbf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cc2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	57                   	push   %edi
80105cd4:	56                   	push   %esi
80105cd5:	53                   	push   %ebx
80105cd6:	83 ec 1c             	sub    $0x1c,%esp
80105cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105cdc:	8b 43 30             	mov    0x30(%ebx),%eax
80105cdf:	83 f8 40             	cmp    $0x40,%eax
80105ce2:	0f 84 68 01 00 00    	je     80105e50 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ce8:	83 e8 20             	sub    $0x20,%eax
80105ceb:	83 f8 1f             	cmp    $0x1f,%eax
80105cee:	0f 87 8c 00 00 00    	ja     80105d80 <trap+0xb0>
80105cf4:	ff 24 85 84 7f 10 80 	jmp    *-0x7fef807c(,%eax,4)
80105cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105d00:	e8 3b c5 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105d05:	e8 b6 cd ff ff       	call   80102ac0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d0a:	e8 21 de ff ff       	call   80103b30 <myproc>
80105d0f:	85 c0                	test   %eax,%eax
80105d11:	74 1d                	je     80105d30 <trap+0x60>
80105d13:	e8 18 de ff ff       	call   80103b30 <myproc>
80105d18:	8b 50 28             	mov    0x28(%eax),%edx
80105d1b:	85 d2                	test   %edx,%edx
80105d1d:	74 11                	je     80105d30 <trap+0x60>
80105d1f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d23:	83 e0 03             	and    $0x3,%eax
80105d26:	66 83 f8 03          	cmp    $0x3,%ax
80105d2a:	0f 84 e8 01 00 00    	je     80105f18 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d30:	e8 fb dd ff ff       	call   80103b30 <myproc>
80105d35:	85 c0                	test   %eax,%eax
80105d37:	74 0f                	je     80105d48 <trap+0x78>
80105d39:	e8 f2 dd ff ff       	call   80103b30 <myproc>
80105d3e:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105d42:	0f 84 b8 00 00 00    	je     80105e00 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d48:	e8 e3 dd ff ff       	call   80103b30 <myproc>
80105d4d:	85 c0                	test   %eax,%eax
80105d4f:	74 1d                	je     80105d6e <trap+0x9e>
80105d51:	e8 da dd ff ff       	call   80103b30 <myproc>
80105d56:	8b 40 28             	mov    0x28(%eax),%eax
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	74 11                	je     80105d6e <trap+0x9e>
80105d5d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d61:	83 e0 03             	and    $0x3,%eax
80105d64:	66 83 f8 03          	cmp    $0x3,%ax
80105d68:	0f 84 0f 01 00 00    	je     80105e7d <trap+0x1ad>
    exit();
}
80105d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d71:	5b                   	pop    %ebx
80105d72:	5e                   	pop    %esi
80105d73:	5f                   	pop    %edi
80105d74:	5d                   	pop    %ebp
80105d75:	c3                   	ret    
80105d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d80:	e8 ab dd ff ff       	call   80103b30 <myproc>
80105d85:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d88:	85 c0                	test   %eax,%eax
80105d8a:	0f 84 a2 01 00 00    	je     80105f32 <trap+0x262>
80105d90:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d94:	0f 84 98 01 00 00    	je     80105f32 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d9a:	0f 20 d1             	mov    %cr2,%ecx
80105d9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105da0:	e8 6b dd ff ff       	call   80103b10 <cpuid>
80105da5:	8b 73 30             	mov    0x30(%ebx),%esi
80105da8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dab:	8b 43 34             	mov    0x34(%ebx),%eax
80105dae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105db1:	e8 7a dd ff ff       	call   80103b30 <myproc>
80105db6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105db9:	e8 72 dd ff ff       	call   80103b30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105dc4:	51                   	push   %ecx
80105dc5:	57                   	push   %edi
80105dc6:	52                   	push   %edx
80105dc7:	ff 75 e4             	push   -0x1c(%ebp)
80105dca:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105dcb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105dce:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dd1:	56                   	push   %esi
80105dd2:	ff 70 14             	push   0x14(%eax)
80105dd5:	68 40 7f 10 80       	push   $0x80107f40
80105dda:	e8 c1 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105ddf:	83 c4 20             	add    $0x20,%esp
80105de2:	e8 49 dd ff ff       	call   80103b30 <myproc>
80105de7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dee:	e8 3d dd ff ff       	call   80103b30 <myproc>
80105df3:	85 c0                	test   %eax,%eax
80105df5:	0f 85 18 ff ff ff    	jne    80105d13 <trap+0x43>
80105dfb:	e9 30 ff ff ff       	jmp    80105d30 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105e00:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e04:	0f 85 3e ff ff ff    	jne    80105d48 <trap+0x78>
    yield();
80105e0a:	e8 21 e4 ff ff       	call   80104230 <yield>
80105e0f:	e9 34 ff ff ff       	jmp    80105d48 <trap+0x78>
80105e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e18:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e1b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e1f:	e8 ec dc ff ff       	call   80103b10 <cpuid>
80105e24:	57                   	push   %edi
80105e25:	56                   	push   %esi
80105e26:	50                   	push   %eax
80105e27:	68 e8 7e 10 80       	push   $0x80107ee8
80105e2c:	e8 6f a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105e31:	e8 8a cc ff ff       	call   80102ac0 <lapiceoi>
    break;
80105e36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e39:	e8 f2 dc ff ff       	call   80103b30 <myproc>
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	0f 85 cd fe ff ff    	jne    80105d13 <trap+0x43>
80105e46:	e9 e5 fe ff ff       	jmp    80105d30 <trap+0x60>
80105e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e4f:	90                   	nop
    if(myproc()->killed)
80105e50:	e8 db dc ff ff       	call   80103b30 <myproc>
80105e55:	8b 70 28             	mov    0x28(%eax),%esi
80105e58:	85 f6                	test   %esi,%esi
80105e5a:	0f 85 c8 00 00 00    	jne    80105f28 <trap+0x258>
    myproc()->tf = tf;
80105e60:	e8 cb dc ff ff       	call   80103b30 <myproc>
80105e65:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105e68:	e8 33 ee ff ff       	call   80104ca0 <syscall>
    if(myproc()->killed)
80105e6d:	e8 be dc ff ff       	call   80103b30 <myproc>
80105e72:	8b 48 28             	mov    0x28(%eax),%ecx
80105e75:	85 c9                	test   %ecx,%ecx
80105e77:	0f 84 f1 fe ff ff    	je     80105d6e <trap+0x9e>
}
80105e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e80:	5b                   	pop    %ebx
80105e81:	5e                   	pop    %esi
80105e82:	5f                   	pop    %edi
80105e83:	5d                   	pop    %ebp
      exit();
80105e84:	e9 47 e1 ff ff       	jmp    80103fd0 <exit>
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e90:	e8 3b 02 00 00       	call   801060d0 <uartintr>
    lapiceoi();
80105e95:	e8 26 cc ff ff       	call   80102ac0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e9a:	e8 91 dc ff ff       	call   80103b30 <myproc>
80105e9f:	85 c0                	test   %eax,%eax
80105ea1:	0f 85 6c fe ff ff    	jne    80105d13 <trap+0x43>
80105ea7:	e9 84 fe ff ff       	jmp    80105d30 <trap+0x60>
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105eb0:	e8 cb ca ff ff       	call   80102980 <kbdintr>
    lapiceoi();
80105eb5:	e8 06 cc ff ff       	call   80102ac0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eba:	e8 71 dc ff ff       	call   80103b30 <myproc>
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	0f 85 4c fe ff ff    	jne    80105d13 <trap+0x43>
80105ec7:	e9 64 fe ff ff       	jmp    80105d30 <trap+0x60>
80105ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ed0:	e8 3b dc ff ff       	call   80103b10 <cpuid>
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	0f 85 28 fe ff ff    	jne    80105d05 <trap+0x35>
      acquire(&tickslock);
80105edd:	83 ec 0c             	sub    $0xc,%esp
80105ee0:	68 a0 4d 11 80       	push   $0x80114da0
80105ee5:	e8 f6 e8 ff ff       	call   801047e0 <acquire>
      wakeup(&ticks);
80105eea:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
      ticks++;
80105ef1:	83 05 80 4d 11 80 01 	addl   $0x1,0x80114d80
      wakeup(&ticks);
80105ef8:	e8 43 e4 ff ff       	call   80104340 <wakeup>
      release(&tickslock);
80105efd:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80105f04:	e8 77 e8 ff ff       	call   80104780 <release>
80105f09:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f0c:	e9 f4 fd ff ff       	jmp    80105d05 <trap+0x35>
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f18:	e8 b3 e0 ff ff       	call   80103fd0 <exit>
80105f1d:	e9 0e fe ff ff       	jmp    80105d30 <trap+0x60>
80105f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f28:	e8 a3 e0 ff ff       	call   80103fd0 <exit>
80105f2d:	e9 2e ff ff ff       	jmp    80105e60 <trap+0x190>
80105f32:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f35:	e8 d6 db ff ff       	call   80103b10 <cpuid>
80105f3a:	83 ec 0c             	sub    $0xc,%esp
80105f3d:	56                   	push   %esi
80105f3e:	57                   	push   %edi
80105f3f:	50                   	push   %eax
80105f40:	ff 73 30             	push   0x30(%ebx)
80105f43:	68 0c 7f 10 80       	push   $0x80107f0c
80105f48:	e8 53 a7 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105f4d:	83 c4 14             	add    $0x14,%esp
80105f50:	68 e3 7e 10 80       	push   $0x80107ee3
80105f55:	e8 26 a4 ff ff       	call   80100380 <panic>
80105f5a:	66 90                	xchg   %ax,%ax
80105f5c:	66 90                	xchg   %ax,%ax
80105f5e:	66 90                	xchg   %ax,%ax

80105f60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f60:	a1 e0 55 11 80       	mov    0x801155e0,%eax
80105f65:	85 c0                	test   %eax,%eax
80105f67:	74 17                	je     80105f80 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f69:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f6e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f6f:	a8 01                	test   $0x1,%al
80105f71:	74 0d                	je     80105f80 <uartgetc+0x20>
80105f73:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f78:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f79:	0f b6 c0             	movzbl %al,%eax
80105f7c:	c3                   	ret    
80105f7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f85:	c3                   	ret    
80105f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8d:	8d 76 00             	lea    0x0(%esi),%esi

80105f90 <uartinit>:
{
80105f90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f91:	31 c9                	xor    %ecx,%ecx
80105f93:	89 c8                	mov    %ecx,%eax
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	57                   	push   %edi
80105f98:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f9d:	56                   	push   %esi
80105f9e:	89 fa                	mov    %edi,%edx
80105fa0:	53                   	push   %ebx
80105fa1:	83 ec 1c             	sub    $0x1c,%esp
80105fa4:	ee                   	out    %al,(%dx)
80105fa5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105faa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105faf:	89 f2                	mov    %esi,%edx
80105fb1:	ee                   	out    %al,(%dx)
80105fb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fbc:	ee                   	out    %al,(%dx)
80105fbd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105fc2:	89 c8                	mov    %ecx,%eax
80105fc4:	89 da                	mov    %ebx,%edx
80105fc6:	ee                   	out    %al,(%dx)
80105fc7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fcc:	89 f2                	mov    %esi,%edx
80105fce:	ee                   	out    %al,(%dx)
80105fcf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fd4:	89 c8                	mov    %ecx,%eax
80105fd6:	ee                   	out    %al,(%dx)
80105fd7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fdc:	89 da                	mov    %ebx,%edx
80105fde:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fdf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fe4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fe5:	3c ff                	cmp    $0xff,%al
80105fe7:	74 78                	je     80106061 <uartinit+0xd1>
  uart = 1;
80105fe9:	c7 05 e0 55 11 80 01 	movl   $0x1,0x801155e0
80105ff0:	00 00 00 
80105ff3:	89 fa                	mov    %edi,%edx
80105ff5:	ec                   	in     (%dx),%al
80105ff6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ffc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fff:	bf 04 80 10 80       	mov    $0x80108004,%edi
80106004:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106009:	6a 00                	push   $0x0
8010600b:	6a 04                	push   $0x4
8010600d:	e8 6e c4 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106012:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106016:	83 c4 10             	add    $0x10,%esp
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106020:	a1 e0 55 11 80       	mov    0x801155e0,%eax
80106025:	bb 80 00 00 00       	mov    $0x80,%ebx
8010602a:	85 c0                	test   %eax,%eax
8010602c:	75 14                	jne    80106042 <uartinit+0xb2>
8010602e:	eb 23                	jmp    80106053 <uartinit+0xc3>
    microdelay(10);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	6a 0a                	push   $0xa
80106035:	e8 a6 ca ff ff       	call   80102ae0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010603a:	83 c4 10             	add    $0x10,%esp
8010603d:	83 eb 01             	sub    $0x1,%ebx
80106040:	74 07                	je     80106049 <uartinit+0xb9>
80106042:	89 f2                	mov    %esi,%edx
80106044:	ec                   	in     (%dx),%al
80106045:	a8 20                	test   $0x20,%al
80106047:	74 e7                	je     80106030 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106049:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010604d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106052:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106053:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106057:	83 c7 01             	add    $0x1,%edi
8010605a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010605d:	84 c0                	test   %al,%al
8010605f:	75 bf                	jne    80106020 <uartinit+0x90>
}
80106061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106064:	5b                   	pop    %ebx
80106065:	5e                   	pop    %esi
80106066:	5f                   	pop    %edi
80106067:	5d                   	pop    %ebp
80106068:	c3                   	ret    
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106070 <uartputc>:
  if(!uart)
80106070:	a1 e0 55 11 80       	mov    0x801155e0,%eax
80106075:	85 c0                	test   %eax,%eax
80106077:	74 47                	je     801060c0 <uartputc+0x50>
{
80106079:	55                   	push   %ebp
8010607a:	89 e5                	mov    %esp,%ebp
8010607c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010607d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106082:	53                   	push   %ebx
80106083:	bb 80 00 00 00       	mov    $0x80,%ebx
80106088:	eb 18                	jmp    801060a2 <uartputc+0x32>
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	6a 0a                	push   $0xa
80106095:	e8 46 ca ff ff       	call   80102ae0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010609a:	83 c4 10             	add    $0x10,%esp
8010609d:	83 eb 01             	sub    $0x1,%ebx
801060a0:	74 07                	je     801060a9 <uartputc+0x39>
801060a2:	89 f2                	mov    %esi,%edx
801060a4:	ec                   	in     (%dx),%al
801060a5:	a8 20                	test   $0x20,%al
801060a7:	74 e7                	je     80106090 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a9:	8b 45 08             	mov    0x8(%ebp),%eax
801060ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060b1:	ee                   	out    %al,(%dx)
}
801060b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060b5:	5b                   	pop    %ebx
801060b6:	5e                   	pop    %esi
801060b7:	5d                   	pop    %ebp
801060b8:	c3                   	ret    
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060c0:	c3                   	ret    
801060c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060cf:	90                   	nop

801060d0 <uartintr>:

void
uartintr(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060d6:	68 60 5f 10 80       	push   $0x80105f60
801060db:	e8 a0 a7 ff ff       	call   80100880 <consoleintr>
}
801060e0:	83 c4 10             	add    $0x10,%esp
801060e3:	c9                   	leave  
801060e4:	c3                   	ret    

801060e5 <vector0>:
801060e5:	6a 00                	push   $0x0
801060e7:	6a 00                	push   $0x0
801060e9:	e9 0a fb ff ff       	jmp    80105bf8 <alltraps>

801060ee <vector1>:
801060ee:	6a 00                	push   $0x0
801060f0:	6a 01                	push   $0x1
801060f2:	e9 01 fb ff ff       	jmp    80105bf8 <alltraps>

801060f7 <vector2>:
801060f7:	6a 00                	push   $0x0
801060f9:	6a 02                	push   $0x2
801060fb:	e9 f8 fa ff ff       	jmp    80105bf8 <alltraps>

80106100 <vector3>:
80106100:	6a 00                	push   $0x0
80106102:	6a 03                	push   $0x3
80106104:	e9 ef fa ff ff       	jmp    80105bf8 <alltraps>

80106109 <vector4>:
80106109:	6a 00                	push   $0x0
8010610b:	6a 04                	push   $0x4
8010610d:	e9 e6 fa ff ff       	jmp    80105bf8 <alltraps>

80106112 <vector5>:
80106112:	6a 00                	push   $0x0
80106114:	6a 05                	push   $0x5
80106116:	e9 dd fa ff ff       	jmp    80105bf8 <alltraps>

8010611b <vector6>:
8010611b:	6a 00                	push   $0x0
8010611d:	6a 06                	push   $0x6
8010611f:	e9 d4 fa ff ff       	jmp    80105bf8 <alltraps>

80106124 <vector7>:
80106124:	6a 00                	push   $0x0
80106126:	6a 07                	push   $0x7
80106128:	e9 cb fa ff ff       	jmp    80105bf8 <alltraps>

8010612d <vector8>:
8010612d:	6a 08                	push   $0x8
8010612f:	e9 c4 fa ff ff       	jmp    80105bf8 <alltraps>

80106134 <vector9>:
80106134:	6a 00                	push   $0x0
80106136:	6a 09                	push   $0x9
80106138:	e9 bb fa ff ff       	jmp    80105bf8 <alltraps>

8010613d <vector10>:
8010613d:	6a 0a                	push   $0xa
8010613f:	e9 b4 fa ff ff       	jmp    80105bf8 <alltraps>

80106144 <vector11>:
80106144:	6a 0b                	push   $0xb
80106146:	e9 ad fa ff ff       	jmp    80105bf8 <alltraps>

8010614b <vector12>:
8010614b:	6a 0c                	push   $0xc
8010614d:	e9 a6 fa ff ff       	jmp    80105bf8 <alltraps>

80106152 <vector13>:
80106152:	6a 0d                	push   $0xd
80106154:	e9 9f fa ff ff       	jmp    80105bf8 <alltraps>

80106159 <vector14>:
80106159:	6a 0e                	push   $0xe
8010615b:	e9 98 fa ff ff       	jmp    80105bf8 <alltraps>

80106160 <vector15>:
80106160:	6a 00                	push   $0x0
80106162:	6a 0f                	push   $0xf
80106164:	e9 8f fa ff ff       	jmp    80105bf8 <alltraps>

80106169 <vector16>:
80106169:	6a 00                	push   $0x0
8010616b:	6a 10                	push   $0x10
8010616d:	e9 86 fa ff ff       	jmp    80105bf8 <alltraps>

80106172 <vector17>:
80106172:	6a 11                	push   $0x11
80106174:	e9 7f fa ff ff       	jmp    80105bf8 <alltraps>

80106179 <vector18>:
80106179:	6a 00                	push   $0x0
8010617b:	6a 12                	push   $0x12
8010617d:	e9 76 fa ff ff       	jmp    80105bf8 <alltraps>

80106182 <vector19>:
80106182:	6a 00                	push   $0x0
80106184:	6a 13                	push   $0x13
80106186:	e9 6d fa ff ff       	jmp    80105bf8 <alltraps>

8010618b <vector20>:
8010618b:	6a 00                	push   $0x0
8010618d:	6a 14                	push   $0x14
8010618f:	e9 64 fa ff ff       	jmp    80105bf8 <alltraps>

80106194 <vector21>:
80106194:	6a 00                	push   $0x0
80106196:	6a 15                	push   $0x15
80106198:	e9 5b fa ff ff       	jmp    80105bf8 <alltraps>

8010619d <vector22>:
8010619d:	6a 00                	push   $0x0
8010619f:	6a 16                	push   $0x16
801061a1:	e9 52 fa ff ff       	jmp    80105bf8 <alltraps>

801061a6 <vector23>:
801061a6:	6a 00                	push   $0x0
801061a8:	6a 17                	push   $0x17
801061aa:	e9 49 fa ff ff       	jmp    80105bf8 <alltraps>

801061af <vector24>:
801061af:	6a 00                	push   $0x0
801061b1:	6a 18                	push   $0x18
801061b3:	e9 40 fa ff ff       	jmp    80105bf8 <alltraps>

801061b8 <vector25>:
801061b8:	6a 00                	push   $0x0
801061ba:	6a 19                	push   $0x19
801061bc:	e9 37 fa ff ff       	jmp    80105bf8 <alltraps>

801061c1 <vector26>:
801061c1:	6a 00                	push   $0x0
801061c3:	6a 1a                	push   $0x1a
801061c5:	e9 2e fa ff ff       	jmp    80105bf8 <alltraps>

801061ca <vector27>:
801061ca:	6a 00                	push   $0x0
801061cc:	6a 1b                	push   $0x1b
801061ce:	e9 25 fa ff ff       	jmp    80105bf8 <alltraps>

801061d3 <vector28>:
801061d3:	6a 00                	push   $0x0
801061d5:	6a 1c                	push   $0x1c
801061d7:	e9 1c fa ff ff       	jmp    80105bf8 <alltraps>

801061dc <vector29>:
801061dc:	6a 00                	push   $0x0
801061de:	6a 1d                	push   $0x1d
801061e0:	e9 13 fa ff ff       	jmp    80105bf8 <alltraps>

801061e5 <vector30>:
801061e5:	6a 00                	push   $0x0
801061e7:	6a 1e                	push   $0x1e
801061e9:	e9 0a fa ff ff       	jmp    80105bf8 <alltraps>

801061ee <vector31>:
801061ee:	6a 00                	push   $0x0
801061f0:	6a 1f                	push   $0x1f
801061f2:	e9 01 fa ff ff       	jmp    80105bf8 <alltraps>

801061f7 <vector32>:
801061f7:	6a 00                	push   $0x0
801061f9:	6a 20                	push   $0x20
801061fb:	e9 f8 f9 ff ff       	jmp    80105bf8 <alltraps>

80106200 <vector33>:
80106200:	6a 00                	push   $0x0
80106202:	6a 21                	push   $0x21
80106204:	e9 ef f9 ff ff       	jmp    80105bf8 <alltraps>

80106209 <vector34>:
80106209:	6a 00                	push   $0x0
8010620b:	6a 22                	push   $0x22
8010620d:	e9 e6 f9 ff ff       	jmp    80105bf8 <alltraps>

80106212 <vector35>:
80106212:	6a 00                	push   $0x0
80106214:	6a 23                	push   $0x23
80106216:	e9 dd f9 ff ff       	jmp    80105bf8 <alltraps>

8010621b <vector36>:
8010621b:	6a 00                	push   $0x0
8010621d:	6a 24                	push   $0x24
8010621f:	e9 d4 f9 ff ff       	jmp    80105bf8 <alltraps>

80106224 <vector37>:
80106224:	6a 00                	push   $0x0
80106226:	6a 25                	push   $0x25
80106228:	e9 cb f9 ff ff       	jmp    80105bf8 <alltraps>

8010622d <vector38>:
8010622d:	6a 00                	push   $0x0
8010622f:	6a 26                	push   $0x26
80106231:	e9 c2 f9 ff ff       	jmp    80105bf8 <alltraps>

80106236 <vector39>:
80106236:	6a 00                	push   $0x0
80106238:	6a 27                	push   $0x27
8010623a:	e9 b9 f9 ff ff       	jmp    80105bf8 <alltraps>

8010623f <vector40>:
8010623f:	6a 00                	push   $0x0
80106241:	6a 28                	push   $0x28
80106243:	e9 b0 f9 ff ff       	jmp    80105bf8 <alltraps>

80106248 <vector41>:
80106248:	6a 00                	push   $0x0
8010624a:	6a 29                	push   $0x29
8010624c:	e9 a7 f9 ff ff       	jmp    80105bf8 <alltraps>

80106251 <vector42>:
80106251:	6a 00                	push   $0x0
80106253:	6a 2a                	push   $0x2a
80106255:	e9 9e f9 ff ff       	jmp    80105bf8 <alltraps>

8010625a <vector43>:
8010625a:	6a 00                	push   $0x0
8010625c:	6a 2b                	push   $0x2b
8010625e:	e9 95 f9 ff ff       	jmp    80105bf8 <alltraps>

80106263 <vector44>:
80106263:	6a 00                	push   $0x0
80106265:	6a 2c                	push   $0x2c
80106267:	e9 8c f9 ff ff       	jmp    80105bf8 <alltraps>

8010626c <vector45>:
8010626c:	6a 00                	push   $0x0
8010626e:	6a 2d                	push   $0x2d
80106270:	e9 83 f9 ff ff       	jmp    80105bf8 <alltraps>

80106275 <vector46>:
80106275:	6a 00                	push   $0x0
80106277:	6a 2e                	push   $0x2e
80106279:	e9 7a f9 ff ff       	jmp    80105bf8 <alltraps>

8010627e <vector47>:
8010627e:	6a 00                	push   $0x0
80106280:	6a 2f                	push   $0x2f
80106282:	e9 71 f9 ff ff       	jmp    80105bf8 <alltraps>

80106287 <vector48>:
80106287:	6a 00                	push   $0x0
80106289:	6a 30                	push   $0x30
8010628b:	e9 68 f9 ff ff       	jmp    80105bf8 <alltraps>

80106290 <vector49>:
80106290:	6a 00                	push   $0x0
80106292:	6a 31                	push   $0x31
80106294:	e9 5f f9 ff ff       	jmp    80105bf8 <alltraps>

80106299 <vector50>:
80106299:	6a 00                	push   $0x0
8010629b:	6a 32                	push   $0x32
8010629d:	e9 56 f9 ff ff       	jmp    80105bf8 <alltraps>

801062a2 <vector51>:
801062a2:	6a 00                	push   $0x0
801062a4:	6a 33                	push   $0x33
801062a6:	e9 4d f9 ff ff       	jmp    80105bf8 <alltraps>

801062ab <vector52>:
801062ab:	6a 00                	push   $0x0
801062ad:	6a 34                	push   $0x34
801062af:	e9 44 f9 ff ff       	jmp    80105bf8 <alltraps>

801062b4 <vector53>:
801062b4:	6a 00                	push   $0x0
801062b6:	6a 35                	push   $0x35
801062b8:	e9 3b f9 ff ff       	jmp    80105bf8 <alltraps>

801062bd <vector54>:
801062bd:	6a 00                	push   $0x0
801062bf:	6a 36                	push   $0x36
801062c1:	e9 32 f9 ff ff       	jmp    80105bf8 <alltraps>

801062c6 <vector55>:
801062c6:	6a 00                	push   $0x0
801062c8:	6a 37                	push   $0x37
801062ca:	e9 29 f9 ff ff       	jmp    80105bf8 <alltraps>

801062cf <vector56>:
801062cf:	6a 00                	push   $0x0
801062d1:	6a 38                	push   $0x38
801062d3:	e9 20 f9 ff ff       	jmp    80105bf8 <alltraps>

801062d8 <vector57>:
801062d8:	6a 00                	push   $0x0
801062da:	6a 39                	push   $0x39
801062dc:	e9 17 f9 ff ff       	jmp    80105bf8 <alltraps>

801062e1 <vector58>:
801062e1:	6a 00                	push   $0x0
801062e3:	6a 3a                	push   $0x3a
801062e5:	e9 0e f9 ff ff       	jmp    80105bf8 <alltraps>

801062ea <vector59>:
801062ea:	6a 00                	push   $0x0
801062ec:	6a 3b                	push   $0x3b
801062ee:	e9 05 f9 ff ff       	jmp    80105bf8 <alltraps>

801062f3 <vector60>:
801062f3:	6a 00                	push   $0x0
801062f5:	6a 3c                	push   $0x3c
801062f7:	e9 fc f8 ff ff       	jmp    80105bf8 <alltraps>

801062fc <vector61>:
801062fc:	6a 00                	push   $0x0
801062fe:	6a 3d                	push   $0x3d
80106300:	e9 f3 f8 ff ff       	jmp    80105bf8 <alltraps>

80106305 <vector62>:
80106305:	6a 00                	push   $0x0
80106307:	6a 3e                	push   $0x3e
80106309:	e9 ea f8 ff ff       	jmp    80105bf8 <alltraps>

8010630e <vector63>:
8010630e:	6a 00                	push   $0x0
80106310:	6a 3f                	push   $0x3f
80106312:	e9 e1 f8 ff ff       	jmp    80105bf8 <alltraps>

80106317 <vector64>:
80106317:	6a 00                	push   $0x0
80106319:	6a 40                	push   $0x40
8010631b:	e9 d8 f8 ff ff       	jmp    80105bf8 <alltraps>

80106320 <vector65>:
80106320:	6a 00                	push   $0x0
80106322:	6a 41                	push   $0x41
80106324:	e9 cf f8 ff ff       	jmp    80105bf8 <alltraps>

80106329 <vector66>:
80106329:	6a 00                	push   $0x0
8010632b:	6a 42                	push   $0x42
8010632d:	e9 c6 f8 ff ff       	jmp    80105bf8 <alltraps>

80106332 <vector67>:
80106332:	6a 00                	push   $0x0
80106334:	6a 43                	push   $0x43
80106336:	e9 bd f8 ff ff       	jmp    80105bf8 <alltraps>

8010633b <vector68>:
8010633b:	6a 00                	push   $0x0
8010633d:	6a 44                	push   $0x44
8010633f:	e9 b4 f8 ff ff       	jmp    80105bf8 <alltraps>

80106344 <vector69>:
80106344:	6a 00                	push   $0x0
80106346:	6a 45                	push   $0x45
80106348:	e9 ab f8 ff ff       	jmp    80105bf8 <alltraps>

8010634d <vector70>:
8010634d:	6a 00                	push   $0x0
8010634f:	6a 46                	push   $0x46
80106351:	e9 a2 f8 ff ff       	jmp    80105bf8 <alltraps>

80106356 <vector71>:
80106356:	6a 00                	push   $0x0
80106358:	6a 47                	push   $0x47
8010635a:	e9 99 f8 ff ff       	jmp    80105bf8 <alltraps>

8010635f <vector72>:
8010635f:	6a 00                	push   $0x0
80106361:	6a 48                	push   $0x48
80106363:	e9 90 f8 ff ff       	jmp    80105bf8 <alltraps>

80106368 <vector73>:
80106368:	6a 00                	push   $0x0
8010636a:	6a 49                	push   $0x49
8010636c:	e9 87 f8 ff ff       	jmp    80105bf8 <alltraps>

80106371 <vector74>:
80106371:	6a 00                	push   $0x0
80106373:	6a 4a                	push   $0x4a
80106375:	e9 7e f8 ff ff       	jmp    80105bf8 <alltraps>

8010637a <vector75>:
8010637a:	6a 00                	push   $0x0
8010637c:	6a 4b                	push   $0x4b
8010637e:	e9 75 f8 ff ff       	jmp    80105bf8 <alltraps>

80106383 <vector76>:
80106383:	6a 00                	push   $0x0
80106385:	6a 4c                	push   $0x4c
80106387:	e9 6c f8 ff ff       	jmp    80105bf8 <alltraps>

8010638c <vector77>:
8010638c:	6a 00                	push   $0x0
8010638e:	6a 4d                	push   $0x4d
80106390:	e9 63 f8 ff ff       	jmp    80105bf8 <alltraps>

80106395 <vector78>:
80106395:	6a 00                	push   $0x0
80106397:	6a 4e                	push   $0x4e
80106399:	e9 5a f8 ff ff       	jmp    80105bf8 <alltraps>

8010639e <vector79>:
8010639e:	6a 00                	push   $0x0
801063a0:	6a 4f                	push   $0x4f
801063a2:	e9 51 f8 ff ff       	jmp    80105bf8 <alltraps>

801063a7 <vector80>:
801063a7:	6a 00                	push   $0x0
801063a9:	6a 50                	push   $0x50
801063ab:	e9 48 f8 ff ff       	jmp    80105bf8 <alltraps>

801063b0 <vector81>:
801063b0:	6a 00                	push   $0x0
801063b2:	6a 51                	push   $0x51
801063b4:	e9 3f f8 ff ff       	jmp    80105bf8 <alltraps>

801063b9 <vector82>:
801063b9:	6a 00                	push   $0x0
801063bb:	6a 52                	push   $0x52
801063bd:	e9 36 f8 ff ff       	jmp    80105bf8 <alltraps>

801063c2 <vector83>:
801063c2:	6a 00                	push   $0x0
801063c4:	6a 53                	push   $0x53
801063c6:	e9 2d f8 ff ff       	jmp    80105bf8 <alltraps>

801063cb <vector84>:
801063cb:	6a 00                	push   $0x0
801063cd:	6a 54                	push   $0x54
801063cf:	e9 24 f8 ff ff       	jmp    80105bf8 <alltraps>

801063d4 <vector85>:
801063d4:	6a 00                	push   $0x0
801063d6:	6a 55                	push   $0x55
801063d8:	e9 1b f8 ff ff       	jmp    80105bf8 <alltraps>

801063dd <vector86>:
801063dd:	6a 00                	push   $0x0
801063df:	6a 56                	push   $0x56
801063e1:	e9 12 f8 ff ff       	jmp    80105bf8 <alltraps>

801063e6 <vector87>:
801063e6:	6a 00                	push   $0x0
801063e8:	6a 57                	push   $0x57
801063ea:	e9 09 f8 ff ff       	jmp    80105bf8 <alltraps>

801063ef <vector88>:
801063ef:	6a 00                	push   $0x0
801063f1:	6a 58                	push   $0x58
801063f3:	e9 00 f8 ff ff       	jmp    80105bf8 <alltraps>

801063f8 <vector89>:
801063f8:	6a 00                	push   $0x0
801063fa:	6a 59                	push   $0x59
801063fc:	e9 f7 f7 ff ff       	jmp    80105bf8 <alltraps>

80106401 <vector90>:
80106401:	6a 00                	push   $0x0
80106403:	6a 5a                	push   $0x5a
80106405:	e9 ee f7 ff ff       	jmp    80105bf8 <alltraps>

8010640a <vector91>:
8010640a:	6a 00                	push   $0x0
8010640c:	6a 5b                	push   $0x5b
8010640e:	e9 e5 f7 ff ff       	jmp    80105bf8 <alltraps>

80106413 <vector92>:
80106413:	6a 00                	push   $0x0
80106415:	6a 5c                	push   $0x5c
80106417:	e9 dc f7 ff ff       	jmp    80105bf8 <alltraps>

8010641c <vector93>:
8010641c:	6a 00                	push   $0x0
8010641e:	6a 5d                	push   $0x5d
80106420:	e9 d3 f7 ff ff       	jmp    80105bf8 <alltraps>

80106425 <vector94>:
80106425:	6a 00                	push   $0x0
80106427:	6a 5e                	push   $0x5e
80106429:	e9 ca f7 ff ff       	jmp    80105bf8 <alltraps>

8010642e <vector95>:
8010642e:	6a 00                	push   $0x0
80106430:	6a 5f                	push   $0x5f
80106432:	e9 c1 f7 ff ff       	jmp    80105bf8 <alltraps>

80106437 <vector96>:
80106437:	6a 00                	push   $0x0
80106439:	6a 60                	push   $0x60
8010643b:	e9 b8 f7 ff ff       	jmp    80105bf8 <alltraps>

80106440 <vector97>:
80106440:	6a 00                	push   $0x0
80106442:	6a 61                	push   $0x61
80106444:	e9 af f7 ff ff       	jmp    80105bf8 <alltraps>

80106449 <vector98>:
80106449:	6a 00                	push   $0x0
8010644b:	6a 62                	push   $0x62
8010644d:	e9 a6 f7 ff ff       	jmp    80105bf8 <alltraps>

80106452 <vector99>:
80106452:	6a 00                	push   $0x0
80106454:	6a 63                	push   $0x63
80106456:	e9 9d f7 ff ff       	jmp    80105bf8 <alltraps>

8010645b <vector100>:
8010645b:	6a 00                	push   $0x0
8010645d:	6a 64                	push   $0x64
8010645f:	e9 94 f7 ff ff       	jmp    80105bf8 <alltraps>

80106464 <vector101>:
80106464:	6a 00                	push   $0x0
80106466:	6a 65                	push   $0x65
80106468:	e9 8b f7 ff ff       	jmp    80105bf8 <alltraps>

8010646d <vector102>:
8010646d:	6a 00                	push   $0x0
8010646f:	6a 66                	push   $0x66
80106471:	e9 82 f7 ff ff       	jmp    80105bf8 <alltraps>

80106476 <vector103>:
80106476:	6a 00                	push   $0x0
80106478:	6a 67                	push   $0x67
8010647a:	e9 79 f7 ff ff       	jmp    80105bf8 <alltraps>

8010647f <vector104>:
8010647f:	6a 00                	push   $0x0
80106481:	6a 68                	push   $0x68
80106483:	e9 70 f7 ff ff       	jmp    80105bf8 <alltraps>

80106488 <vector105>:
80106488:	6a 00                	push   $0x0
8010648a:	6a 69                	push   $0x69
8010648c:	e9 67 f7 ff ff       	jmp    80105bf8 <alltraps>

80106491 <vector106>:
80106491:	6a 00                	push   $0x0
80106493:	6a 6a                	push   $0x6a
80106495:	e9 5e f7 ff ff       	jmp    80105bf8 <alltraps>

8010649a <vector107>:
8010649a:	6a 00                	push   $0x0
8010649c:	6a 6b                	push   $0x6b
8010649e:	e9 55 f7 ff ff       	jmp    80105bf8 <alltraps>

801064a3 <vector108>:
801064a3:	6a 00                	push   $0x0
801064a5:	6a 6c                	push   $0x6c
801064a7:	e9 4c f7 ff ff       	jmp    80105bf8 <alltraps>

801064ac <vector109>:
801064ac:	6a 00                	push   $0x0
801064ae:	6a 6d                	push   $0x6d
801064b0:	e9 43 f7 ff ff       	jmp    80105bf8 <alltraps>

801064b5 <vector110>:
801064b5:	6a 00                	push   $0x0
801064b7:	6a 6e                	push   $0x6e
801064b9:	e9 3a f7 ff ff       	jmp    80105bf8 <alltraps>

801064be <vector111>:
801064be:	6a 00                	push   $0x0
801064c0:	6a 6f                	push   $0x6f
801064c2:	e9 31 f7 ff ff       	jmp    80105bf8 <alltraps>

801064c7 <vector112>:
801064c7:	6a 00                	push   $0x0
801064c9:	6a 70                	push   $0x70
801064cb:	e9 28 f7 ff ff       	jmp    80105bf8 <alltraps>

801064d0 <vector113>:
801064d0:	6a 00                	push   $0x0
801064d2:	6a 71                	push   $0x71
801064d4:	e9 1f f7 ff ff       	jmp    80105bf8 <alltraps>

801064d9 <vector114>:
801064d9:	6a 00                	push   $0x0
801064db:	6a 72                	push   $0x72
801064dd:	e9 16 f7 ff ff       	jmp    80105bf8 <alltraps>

801064e2 <vector115>:
801064e2:	6a 00                	push   $0x0
801064e4:	6a 73                	push   $0x73
801064e6:	e9 0d f7 ff ff       	jmp    80105bf8 <alltraps>

801064eb <vector116>:
801064eb:	6a 00                	push   $0x0
801064ed:	6a 74                	push   $0x74
801064ef:	e9 04 f7 ff ff       	jmp    80105bf8 <alltraps>

801064f4 <vector117>:
801064f4:	6a 00                	push   $0x0
801064f6:	6a 75                	push   $0x75
801064f8:	e9 fb f6 ff ff       	jmp    80105bf8 <alltraps>

801064fd <vector118>:
801064fd:	6a 00                	push   $0x0
801064ff:	6a 76                	push   $0x76
80106501:	e9 f2 f6 ff ff       	jmp    80105bf8 <alltraps>

80106506 <vector119>:
80106506:	6a 00                	push   $0x0
80106508:	6a 77                	push   $0x77
8010650a:	e9 e9 f6 ff ff       	jmp    80105bf8 <alltraps>

8010650f <vector120>:
8010650f:	6a 00                	push   $0x0
80106511:	6a 78                	push   $0x78
80106513:	e9 e0 f6 ff ff       	jmp    80105bf8 <alltraps>

80106518 <vector121>:
80106518:	6a 00                	push   $0x0
8010651a:	6a 79                	push   $0x79
8010651c:	e9 d7 f6 ff ff       	jmp    80105bf8 <alltraps>

80106521 <vector122>:
80106521:	6a 00                	push   $0x0
80106523:	6a 7a                	push   $0x7a
80106525:	e9 ce f6 ff ff       	jmp    80105bf8 <alltraps>

8010652a <vector123>:
8010652a:	6a 00                	push   $0x0
8010652c:	6a 7b                	push   $0x7b
8010652e:	e9 c5 f6 ff ff       	jmp    80105bf8 <alltraps>

80106533 <vector124>:
80106533:	6a 00                	push   $0x0
80106535:	6a 7c                	push   $0x7c
80106537:	e9 bc f6 ff ff       	jmp    80105bf8 <alltraps>

8010653c <vector125>:
8010653c:	6a 00                	push   $0x0
8010653e:	6a 7d                	push   $0x7d
80106540:	e9 b3 f6 ff ff       	jmp    80105bf8 <alltraps>

80106545 <vector126>:
80106545:	6a 00                	push   $0x0
80106547:	6a 7e                	push   $0x7e
80106549:	e9 aa f6 ff ff       	jmp    80105bf8 <alltraps>

8010654e <vector127>:
8010654e:	6a 00                	push   $0x0
80106550:	6a 7f                	push   $0x7f
80106552:	e9 a1 f6 ff ff       	jmp    80105bf8 <alltraps>

80106557 <vector128>:
80106557:	6a 00                	push   $0x0
80106559:	68 80 00 00 00       	push   $0x80
8010655e:	e9 95 f6 ff ff       	jmp    80105bf8 <alltraps>

80106563 <vector129>:
80106563:	6a 00                	push   $0x0
80106565:	68 81 00 00 00       	push   $0x81
8010656a:	e9 89 f6 ff ff       	jmp    80105bf8 <alltraps>

8010656f <vector130>:
8010656f:	6a 00                	push   $0x0
80106571:	68 82 00 00 00       	push   $0x82
80106576:	e9 7d f6 ff ff       	jmp    80105bf8 <alltraps>

8010657b <vector131>:
8010657b:	6a 00                	push   $0x0
8010657d:	68 83 00 00 00       	push   $0x83
80106582:	e9 71 f6 ff ff       	jmp    80105bf8 <alltraps>

80106587 <vector132>:
80106587:	6a 00                	push   $0x0
80106589:	68 84 00 00 00       	push   $0x84
8010658e:	e9 65 f6 ff ff       	jmp    80105bf8 <alltraps>

80106593 <vector133>:
80106593:	6a 00                	push   $0x0
80106595:	68 85 00 00 00       	push   $0x85
8010659a:	e9 59 f6 ff ff       	jmp    80105bf8 <alltraps>

8010659f <vector134>:
8010659f:	6a 00                	push   $0x0
801065a1:	68 86 00 00 00       	push   $0x86
801065a6:	e9 4d f6 ff ff       	jmp    80105bf8 <alltraps>

801065ab <vector135>:
801065ab:	6a 00                	push   $0x0
801065ad:	68 87 00 00 00       	push   $0x87
801065b2:	e9 41 f6 ff ff       	jmp    80105bf8 <alltraps>

801065b7 <vector136>:
801065b7:	6a 00                	push   $0x0
801065b9:	68 88 00 00 00       	push   $0x88
801065be:	e9 35 f6 ff ff       	jmp    80105bf8 <alltraps>

801065c3 <vector137>:
801065c3:	6a 00                	push   $0x0
801065c5:	68 89 00 00 00       	push   $0x89
801065ca:	e9 29 f6 ff ff       	jmp    80105bf8 <alltraps>

801065cf <vector138>:
801065cf:	6a 00                	push   $0x0
801065d1:	68 8a 00 00 00       	push   $0x8a
801065d6:	e9 1d f6 ff ff       	jmp    80105bf8 <alltraps>

801065db <vector139>:
801065db:	6a 00                	push   $0x0
801065dd:	68 8b 00 00 00       	push   $0x8b
801065e2:	e9 11 f6 ff ff       	jmp    80105bf8 <alltraps>

801065e7 <vector140>:
801065e7:	6a 00                	push   $0x0
801065e9:	68 8c 00 00 00       	push   $0x8c
801065ee:	e9 05 f6 ff ff       	jmp    80105bf8 <alltraps>

801065f3 <vector141>:
801065f3:	6a 00                	push   $0x0
801065f5:	68 8d 00 00 00       	push   $0x8d
801065fa:	e9 f9 f5 ff ff       	jmp    80105bf8 <alltraps>

801065ff <vector142>:
801065ff:	6a 00                	push   $0x0
80106601:	68 8e 00 00 00       	push   $0x8e
80106606:	e9 ed f5 ff ff       	jmp    80105bf8 <alltraps>

8010660b <vector143>:
8010660b:	6a 00                	push   $0x0
8010660d:	68 8f 00 00 00       	push   $0x8f
80106612:	e9 e1 f5 ff ff       	jmp    80105bf8 <alltraps>

80106617 <vector144>:
80106617:	6a 00                	push   $0x0
80106619:	68 90 00 00 00       	push   $0x90
8010661e:	e9 d5 f5 ff ff       	jmp    80105bf8 <alltraps>

80106623 <vector145>:
80106623:	6a 00                	push   $0x0
80106625:	68 91 00 00 00       	push   $0x91
8010662a:	e9 c9 f5 ff ff       	jmp    80105bf8 <alltraps>

8010662f <vector146>:
8010662f:	6a 00                	push   $0x0
80106631:	68 92 00 00 00       	push   $0x92
80106636:	e9 bd f5 ff ff       	jmp    80105bf8 <alltraps>

8010663b <vector147>:
8010663b:	6a 00                	push   $0x0
8010663d:	68 93 00 00 00       	push   $0x93
80106642:	e9 b1 f5 ff ff       	jmp    80105bf8 <alltraps>

80106647 <vector148>:
80106647:	6a 00                	push   $0x0
80106649:	68 94 00 00 00       	push   $0x94
8010664e:	e9 a5 f5 ff ff       	jmp    80105bf8 <alltraps>

80106653 <vector149>:
80106653:	6a 00                	push   $0x0
80106655:	68 95 00 00 00       	push   $0x95
8010665a:	e9 99 f5 ff ff       	jmp    80105bf8 <alltraps>

8010665f <vector150>:
8010665f:	6a 00                	push   $0x0
80106661:	68 96 00 00 00       	push   $0x96
80106666:	e9 8d f5 ff ff       	jmp    80105bf8 <alltraps>

8010666b <vector151>:
8010666b:	6a 00                	push   $0x0
8010666d:	68 97 00 00 00       	push   $0x97
80106672:	e9 81 f5 ff ff       	jmp    80105bf8 <alltraps>

80106677 <vector152>:
80106677:	6a 00                	push   $0x0
80106679:	68 98 00 00 00       	push   $0x98
8010667e:	e9 75 f5 ff ff       	jmp    80105bf8 <alltraps>

80106683 <vector153>:
80106683:	6a 00                	push   $0x0
80106685:	68 99 00 00 00       	push   $0x99
8010668a:	e9 69 f5 ff ff       	jmp    80105bf8 <alltraps>

8010668f <vector154>:
8010668f:	6a 00                	push   $0x0
80106691:	68 9a 00 00 00       	push   $0x9a
80106696:	e9 5d f5 ff ff       	jmp    80105bf8 <alltraps>

8010669b <vector155>:
8010669b:	6a 00                	push   $0x0
8010669d:	68 9b 00 00 00       	push   $0x9b
801066a2:	e9 51 f5 ff ff       	jmp    80105bf8 <alltraps>

801066a7 <vector156>:
801066a7:	6a 00                	push   $0x0
801066a9:	68 9c 00 00 00       	push   $0x9c
801066ae:	e9 45 f5 ff ff       	jmp    80105bf8 <alltraps>

801066b3 <vector157>:
801066b3:	6a 00                	push   $0x0
801066b5:	68 9d 00 00 00       	push   $0x9d
801066ba:	e9 39 f5 ff ff       	jmp    80105bf8 <alltraps>

801066bf <vector158>:
801066bf:	6a 00                	push   $0x0
801066c1:	68 9e 00 00 00       	push   $0x9e
801066c6:	e9 2d f5 ff ff       	jmp    80105bf8 <alltraps>

801066cb <vector159>:
801066cb:	6a 00                	push   $0x0
801066cd:	68 9f 00 00 00       	push   $0x9f
801066d2:	e9 21 f5 ff ff       	jmp    80105bf8 <alltraps>

801066d7 <vector160>:
801066d7:	6a 00                	push   $0x0
801066d9:	68 a0 00 00 00       	push   $0xa0
801066de:	e9 15 f5 ff ff       	jmp    80105bf8 <alltraps>

801066e3 <vector161>:
801066e3:	6a 00                	push   $0x0
801066e5:	68 a1 00 00 00       	push   $0xa1
801066ea:	e9 09 f5 ff ff       	jmp    80105bf8 <alltraps>

801066ef <vector162>:
801066ef:	6a 00                	push   $0x0
801066f1:	68 a2 00 00 00       	push   $0xa2
801066f6:	e9 fd f4 ff ff       	jmp    80105bf8 <alltraps>

801066fb <vector163>:
801066fb:	6a 00                	push   $0x0
801066fd:	68 a3 00 00 00       	push   $0xa3
80106702:	e9 f1 f4 ff ff       	jmp    80105bf8 <alltraps>

80106707 <vector164>:
80106707:	6a 00                	push   $0x0
80106709:	68 a4 00 00 00       	push   $0xa4
8010670e:	e9 e5 f4 ff ff       	jmp    80105bf8 <alltraps>

80106713 <vector165>:
80106713:	6a 00                	push   $0x0
80106715:	68 a5 00 00 00       	push   $0xa5
8010671a:	e9 d9 f4 ff ff       	jmp    80105bf8 <alltraps>

8010671f <vector166>:
8010671f:	6a 00                	push   $0x0
80106721:	68 a6 00 00 00       	push   $0xa6
80106726:	e9 cd f4 ff ff       	jmp    80105bf8 <alltraps>

8010672b <vector167>:
8010672b:	6a 00                	push   $0x0
8010672d:	68 a7 00 00 00       	push   $0xa7
80106732:	e9 c1 f4 ff ff       	jmp    80105bf8 <alltraps>

80106737 <vector168>:
80106737:	6a 00                	push   $0x0
80106739:	68 a8 00 00 00       	push   $0xa8
8010673e:	e9 b5 f4 ff ff       	jmp    80105bf8 <alltraps>

80106743 <vector169>:
80106743:	6a 00                	push   $0x0
80106745:	68 a9 00 00 00       	push   $0xa9
8010674a:	e9 a9 f4 ff ff       	jmp    80105bf8 <alltraps>

8010674f <vector170>:
8010674f:	6a 00                	push   $0x0
80106751:	68 aa 00 00 00       	push   $0xaa
80106756:	e9 9d f4 ff ff       	jmp    80105bf8 <alltraps>

8010675b <vector171>:
8010675b:	6a 00                	push   $0x0
8010675d:	68 ab 00 00 00       	push   $0xab
80106762:	e9 91 f4 ff ff       	jmp    80105bf8 <alltraps>

80106767 <vector172>:
80106767:	6a 00                	push   $0x0
80106769:	68 ac 00 00 00       	push   $0xac
8010676e:	e9 85 f4 ff ff       	jmp    80105bf8 <alltraps>

80106773 <vector173>:
80106773:	6a 00                	push   $0x0
80106775:	68 ad 00 00 00       	push   $0xad
8010677a:	e9 79 f4 ff ff       	jmp    80105bf8 <alltraps>

8010677f <vector174>:
8010677f:	6a 00                	push   $0x0
80106781:	68 ae 00 00 00       	push   $0xae
80106786:	e9 6d f4 ff ff       	jmp    80105bf8 <alltraps>

8010678b <vector175>:
8010678b:	6a 00                	push   $0x0
8010678d:	68 af 00 00 00       	push   $0xaf
80106792:	e9 61 f4 ff ff       	jmp    80105bf8 <alltraps>

80106797 <vector176>:
80106797:	6a 00                	push   $0x0
80106799:	68 b0 00 00 00       	push   $0xb0
8010679e:	e9 55 f4 ff ff       	jmp    80105bf8 <alltraps>

801067a3 <vector177>:
801067a3:	6a 00                	push   $0x0
801067a5:	68 b1 00 00 00       	push   $0xb1
801067aa:	e9 49 f4 ff ff       	jmp    80105bf8 <alltraps>

801067af <vector178>:
801067af:	6a 00                	push   $0x0
801067b1:	68 b2 00 00 00       	push   $0xb2
801067b6:	e9 3d f4 ff ff       	jmp    80105bf8 <alltraps>

801067bb <vector179>:
801067bb:	6a 00                	push   $0x0
801067bd:	68 b3 00 00 00       	push   $0xb3
801067c2:	e9 31 f4 ff ff       	jmp    80105bf8 <alltraps>

801067c7 <vector180>:
801067c7:	6a 00                	push   $0x0
801067c9:	68 b4 00 00 00       	push   $0xb4
801067ce:	e9 25 f4 ff ff       	jmp    80105bf8 <alltraps>

801067d3 <vector181>:
801067d3:	6a 00                	push   $0x0
801067d5:	68 b5 00 00 00       	push   $0xb5
801067da:	e9 19 f4 ff ff       	jmp    80105bf8 <alltraps>

801067df <vector182>:
801067df:	6a 00                	push   $0x0
801067e1:	68 b6 00 00 00       	push   $0xb6
801067e6:	e9 0d f4 ff ff       	jmp    80105bf8 <alltraps>

801067eb <vector183>:
801067eb:	6a 00                	push   $0x0
801067ed:	68 b7 00 00 00       	push   $0xb7
801067f2:	e9 01 f4 ff ff       	jmp    80105bf8 <alltraps>

801067f7 <vector184>:
801067f7:	6a 00                	push   $0x0
801067f9:	68 b8 00 00 00       	push   $0xb8
801067fe:	e9 f5 f3 ff ff       	jmp    80105bf8 <alltraps>

80106803 <vector185>:
80106803:	6a 00                	push   $0x0
80106805:	68 b9 00 00 00       	push   $0xb9
8010680a:	e9 e9 f3 ff ff       	jmp    80105bf8 <alltraps>

8010680f <vector186>:
8010680f:	6a 00                	push   $0x0
80106811:	68 ba 00 00 00       	push   $0xba
80106816:	e9 dd f3 ff ff       	jmp    80105bf8 <alltraps>

8010681b <vector187>:
8010681b:	6a 00                	push   $0x0
8010681d:	68 bb 00 00 00       	push   $0xbb
80106822:	e9 d1 f3 ff ff       	jmp    80105bf8 <alltraps>

80106827 <vector188>:
80106827:	6a 00                	push   $0x0
80106829:	68 bc 00 00 00       	push   $0xbc
8010682e:	e9 c5 f3 ff ff       	jmp    80105bf8 <alltraps>

80106833 <vector189>:
80106833:	6a 00                	push   $0x0
80106835:	68 bd 00 00 00       	push   $0xbd
8010683a:	e9 b9 f3 ff ff       	jmp    80105bf8 <alltraps>

8010683f <vector190>:
8010683f:	6a 00                	push   $0x0
80106841:	68 be 00 00 00       	push   $0xbe
80106846:	e9 ad f3 ff ff       	jmp    80105bf8 <alltraps>

8010684b <vector191>:
8010684b:	6a 00                	push   $0x0
8010684d:	68 bf 00 00 00       	push   $0xbf
80106852:	e9 a1 f3 ff ff       	jmp    80105bf8 <alltraps>

80106857 <vector192>:
80106857:	6a 00                	push   $0x0
80106859:	68 c0 00 00 00       	push   $0xc0
8010685e:	e9 95 f3 ff ff       	jmp    80105bf8 <alltraps>

80106863 <vector193>:
80106863:	6a 00                	push   $0x0
80106865:	68 c1 00 00 00       	push   $0xc1
8010686a:	e9 89 f3 ff ff       	jmp    80105bf8 <alltraps>

8010686f <vector194>:
8010686f:	6a 00                	push   $0x0
80106871:	68 c2 00 00 00       	push   $0xc2
80106876:	e9 7d f3 ff ff       	jmp    80105bf8 <alltraps>

8010687b <vector195>:
8010687b:	6a 00                	push   $0x0
8010687d:	68 c3 00 00 00       	push   $0xc3
80106882:	e9 71 f3 ff ff       	jmp    80105bf8 <alltraps>

80106887 <vector196>:
80106887:	6a 00                	push   $0x0
80106889:	68 c4 00 00 00       	push   $0xc4
8010688e:	e9 65 f3 ff ff       	jmp    80105bf8 <alltraps>

80106893 <vector197>:
80106893:	6a 00                	push   $0x0
80106895:	68 c5 00 00 00       	push   $0xc5
8010689a:	e9 59 f3 ff ff       	jmp    80105bf8 <alltraps>

8010689f <vector198>:
8010689f:	6a 00                	push   $0x0
801068a1:	68 c6 00 00 00       	push   $0xc6
801068a6:	e9 4d f3 ff ff       	jmp    80105bf8 <alltraps>

801068ab <vector199>:
801068ab:	6a 00                	push   $0x0
801068ad:	68 c7 00 00 00       	push   $0xc7
801068b2:	e9 41 f3 ff ff       	jmp    80105bf8 <alltraps>

801068b7 <vector200>:
801068b7:	6a 00                	push   $0x0
801068b9:	68 c8 00 00 00       	push   $0xc8
801068be:	e9 35 f3 ff ff       	jmp    80105bf8 <alltraps>

801068c3 <vector201>:
801068c3:	6a 00                	push   $0x0
801068c5:	68 c9 00 00 00       	push   $0xc9
801068ca:	e9 29 f3 ff ff       	jmp    80105bf8 <alltraps>

801068cf <vector202>:
801068cf:	6a 00                	push   $0x0
801068d1:	68 ca 00 00 00       	push   $0xca
801068d6:	e9 1d f3 ff ff       	jmp    80105bf8 <alltraps>

801068db <vector203>:
801068db:	6a 00                	push   $0x0
801068dd:	68 cb 00 00 00       	push   $0xcb
801068e2:	e9 11 f3 ff ff       	jmp    80105bf8 <alltraps>

801068e7 <vector204>:
801068e7:	6a 00                	push   $0x0
801068e9:	68 cc 00 00 00       	push   $0xcc
801068ee:	e9 05 f3 ff ff       	jmp    80105bf8 <alltraps>

801068f3 <vector205>:
801068f3:	6a 00                	push   $0x0
801068f5:	68 cd 00 00 00       	push   $0xcd
801068fa:	e9 f9 f2 ff ff       	jmp    80105bf8 <alltraps>

801068ff <vector206>:
801068ff:	6a 00                	push   $0x0
80106901:	68 ce 00 00 00       	push   $0xce
80106906:	e9 ed f2 ff ff       	jmp    80105bf8 <alltraps>

8010690b <vector207>:
8010690b:	6a 00                	push   $0x0
8010690d:	68 cf 00 00 00       	push   $0xcf
80106912:	e9 e1 f2 ff ff       	jmp    80105bf8 <alltraps>

80106917 <vector208>:
80106917:	6a 00                	push   $0x0
80106919:	68 d0 00 00 00       	push   $0xd0
8010691e:	e9 d5 f2 ff ff       	jmp    80105bf8 <alltraps>

80106923 <vector209>:
80106923:	6a 00                	push   $0x0
80106925:	68 d1 00 00 00       	push   $0xd1
8010692a:	e9 c9 f2 ff ff       	jmp    80105bf8 <alltraps>

8010692f <vector210>:
8010692f:	6a 00                	push   $0x0
80106931:	68 d2 00 00 00       	push   $0xd2
80106936:	e9 bd f2 ff ff       	jmp    80105bf8 <alltraps>

8010693b <vector211>:
8010693b:	6a 00                	push   $0x0
8010693d:	68 d3 00 00 00       	push   $0xd3
80106942:	e9 b1 f2 ff ff       	jmp    80105bf8 <alltraps>

80106947 <vector212>:
80106947:	6a 00                	push   $0x0
80106949:	68 d4 00 00 00       	push   $0xd4
8010694e:	e9 a5 f2 ff ff       	jmp    80105bf8 <alltraps>

80106953 <vector213>:
80106953:	6a 00                	push   $0x0
80106955:	68 d5 00 00 00       	push   $0xd5
8010695a:	e9 99 f2 ff ff       	jmp    80105bf8 <alltraps>

8010695f <vector214>:
8010695f:	6a 00                	push   $0x0
80106961:	68 d6 00 00 00       	push   $0xd6
80106966:	e9 8d f2 ff ff       	jmp    80105bf8 <alltraps>

8010696b <vector215>:
8010696b:	6a 00                	push   $0x0
8010696d:	68 d7 00 00 00       	push   $0xd7
80106972:	e9 81 f2 ff ff       	jmp    80105bf8 <alltraps>

80106977 <vector216>:
80106977:	6a 00                	push   $0x0
80106979:	68 d8 00 00 00       	push   $0xd8
8010697e:	e9 75 f2 ff ff       	jmp    80105bf8 <alltraps>

80106983 <vector217>:
80106983:	6a 00                	push   $0x0
80106985:	68 d9 00 00 00       	push   $0xd9
8010698a:	e9 69 f2 ff ff       	jmp    80105bf8 <alltraps>

8010698f <vector218>:
8010698f:	6a 00                	push   $0x0
80106991:	68 da 00 00 00       	push   $0xda
80106996:	e9 5d f2 ff ff       	jmp    80105bf8 <alltraps>

8010699b <vector219>:
8010699b:	6a 00                	push   $0x0
8010699d:	68 db 00 00 00       	push   $0xdb
801069a2:	e9 51 f2 ff ff       	jmp    80105bf8 <alltraps>

801069a7 <vector220>:
801069a7:	6a 00                	push   $0x0
801069a9:	68 dc 00 00 00       	push   $0xdc
801069ae:	e9 45 f2 ff ff       	jmp    80105bf8 <alltraps>

801069b3 <vector221>:
801069b3:	6a 00                	push   $0x0
801069b5:	68 dd 00 00 00       	push   $0xdd
801069ba:	e9 39 f2 ff ff       	jmp    80105bf8 <alltraps>

801069bf <vector222>:
801069bf:	6a 00                	push   $0x0
801069c1:	68 de 00 00 00       	push   $0xde
801069c6:	e9 2d f2 ff ff       	jmp    80105bf8 <alltraps>

801069cb <vector223>:
801069cb:	6a 00                	push   $0x0
801069cd:	68 df 00 00 00       	push   $0xdf
801069d2:	e9 21 f2 ff ff       	jmp    80105bf8 <alltraps>

801069d7 <vector224>:
801069d7:	6a 00                	push   $0x0
801069d9:	68 e0 00 00 00       	push   $0xe0
801069de:	e9 15 f2 ff ff       	jmp    80105bf8 <alltraps>

801069e3 <vector225>:
801069e3:	6a 00                	push   $0x0
801069e5:	68 e1 00 00 00       	push   $0xe1
801069ea:	e9 09 f2 ff ff       	jmp    80105bf8 <alltraps>

801069ef <vector226>:
801069ef:	6a 00                	push   $0x0
801069f1:	68 e2 00 00 00       	push   $0xe2
801069f6:	e9 fd f1 ff ff       	jmp    80105bf8 <alltraps>

801069fb <vector227>:
801069fb:	6a 00                	push   $0x0
801069fd:	68 e3 00 00 00       	push   $0xe3
80106a02:	e9 f1 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a07 <vector228>:
80106a07:	6a 00                	push   $0x0
80106a09:	68 e4 00 00 00       	push   $0xe4
80106a0e:	e9 e5 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a13 <vector229>:
80106a13:	6a 00                	push   $0x0
80106a15:	68 e5 00 00 00       	push   $0xe5
80106a1a:	e9 d9 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a1f <vector230>:
80106a1f:	6a 00                	push   $0x0
80106a21:	68 e6 00 00 00       	push   $0xe6
80106a26:	e9 cd f1 ff ff       	jmp    80105bf8 <alltraps>

80106a2b <vector231>:
80106a2b:	6a 00                	push   $0x0
80106a2d:	68 e7 00 00 00       	push   $0xe7
80106a32:	e9 c1 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a37 <vector232>:
80106a37:	6a 00                	push   $0x0
80106a39:	68 e8 00 00 00       	push   $0xe8
80106a3e:	e9 b5 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a43 <vector233>:
80106a43:	6a 00                	push   $0x0
80106a45:	68 e9 00 00 00       	push   $0xe9
80106a4a:	e9 a9 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a4f <vector234>:
80106a4f:	6a 00                	push   $0x0
80106a51:	68 ea 00 00 00       	push   $0xea
80106a56:	e9 9d f1 ff ff       	jmp    80105bf8 <alltraps>

80106a5b <vector235>:
80106a5b:	6a 00                	push   $0x0
80106a5d:	68 eb 00 00 00       	push   $0xeb
80106a62:	e9 91 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a67 <vector236>:
80106a67:	6a 00                	push   $0x0
80106a69:	68 ec 00 00 00       	push   $0xec
80106a6e:	e9 85 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a73 <vector237>:
80106a73:	6a 00                	push   $0x0
80106a75:	68 ed 00 00 00       	push   $0xed
80106a7a:	e9 79 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a7f <vector238>:
80106a7f:	6a 00                	push   $0x0
80106a81:	68 ee 00 00 00       	push   $0xee
80106a86:	e9 6d f1 ff ff       	jmp    80105bf8 <alltraps>

80106a8b <vector239>:
80106a8b:	6a 00                	push   $0x0
80106a8d:	68 ef 00 00 00       	push   $0xef
80106a92:	e9 61 f1 ff ff       	jmp    80105bf8 <alltraps>

80106a97 <vector240>:
80106a97:	6a 00                	push   $0x0
80106a99:	68 f0 00 00 00       	push   $0xf0
80106a9e:	e9 55 f1 ff ff       	jmp    80105bf8 <alltraps>

80106aa3 <vector241>:
80106aa3:	6a 00                	push   $0x0
80106aa5:	68 f1 00 00 00       	push   $0xf1
80106aaa:	e9 49 f1 ff ff       	jmp    80105bf8 <alltraps>

80106aaf <vector242>:
80106aaf:	6a 00                	push   $0x0
80106ab1:	68 f2 00 00 00       	push   $0xf2
80106ab6:	e9 3d f1 ff ff       	jmp    80105bf8 <alltraps>

80106abb <vector243>:
80106abb:	6a 00                	push   $0x0
80106abd:	68 f3 00 00 00       	push   $0xf3
80106ac2:	e9 31 f1 ff ff       	jmp    80105bf8 <alltraps>

80106ac7 <vector244>:
80106ac7:	6a 00                	push   $0x0
80106ac9:	68 f4 00 00 00       	push   $0xf4
80106ace:	e9 25 f1 ff ff       	jmp    80105bf8 <alltraps>

80106ad3 <vector245>:
80106ad3:	6a 00                	push   $0x0
80106ad5:	68 f5 00 00 00       	push   $0xf5
80106ada:	e9 19 f1 ff ff       	jmp    80105bf8 <alltraps>

80106adf <vector246>:
80106adf:	6a 00                	push   $0x0
80106ae1:	68 f6 00 00 00       	push   $0xf6
80106ae6:	e9 0d f1 ff ff       	jmp    80105bf8 <alltraps>

80106aeb <vector247>:
80106aeb:	6a 00                	push   $0x0
80106aed:	68 f7 00 00 00       	push   $0xf7
80106af2:	e9 01 f1 ff ff       	jmp    80105bf8 <alltraps>

80106af7 <vector248>:
80106af7:	6a 00                	push   $0x0
80106af9:	68 f8 00 00 00       	push   $0xf8
80106afe:	e9 f5 f0 ff ff       	jmp    80105bf8 <alltraps>

80106b03 <vector249>:
80106b03:	6a 00                	push   $0x0
80106b05:	68 f9 00 00 00       	push   $0xf9
80106b0a:	e9 e9 f0 ff ff       	jmp    80105bf8 <alltraps>

80106b0f <vector250>:
80106b0f:	6a 00                	push   $0x0
80106b11:	68 fa 00 00 00       	push   $0xfa
80106b16:	e9 dd f0 ff ff       	jmp    80105bf8 <alltraps>

80106b1b <vector251>:
80106b1b:	6a 00                	push   $0x0
80106b1d:	68 fb 00 00 00       	push   $0xfb
80106b22:	e9 d1 f0 ff ff       	jmp    80105bf8 <alltraps>

80106b27 <vector252>:
80106b27:	6a 00                	push   $0x0
80106b29:	68 fc 00 00 00       	push   $0xfc
80106b2e:	e9 c5 f0 ff ff       	jmp    80105bf8 <alltraps>

80106b33 <vector253>:
80106b33:	6a 00                	push   $0x0
80106b35:	68 fd 00 00 00       	push   $0xfd
80106b3a:	e9 b9 f0 ff ff       	jmp    80105bf8 <alltraps>

80106b3f <vector254>:
80106b3f:	6a 00                	push   $0x0
80106b41:	68 fe 00 00 00       	push   $0xfe
80106b46:	e9 ad f0 ff ff       	jmp    80105bf8 <alltraps>

80106b4b <vector255>:
80106b4b:	6a 00                	push   $0x0
80106b4d:	68 ff 00 00 00       	push   $0xff
80106b52:	e9 a1 f0 ff ff       	jmp    80105bf8 <alltraps>
80106b57:	66 90                	xchg   %ax,%ax
80106b59:	66 90                	xchg   %ax,%ax
80106b5b:	66 90                	xchg   %ax,%ax
80106b5d:	66 90                	xchg   %ax,%ax
80106b5f:	90                   	nop

80106b60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b66:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b6c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b72:	83 ec 1c             	sub    $0x1c,%esp
80106b75:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b78:	39 d3                	cmp    %edx,%ebx
80106b7a:	73 49                	jae    80106bc5 <deallocuvm.part.0+0x65>
80106b7c:	89 c7                	mov    %eax,%edi
80106b7e:	eb 0c                	jmp    80106b8c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b80:	83 c0 01             	add    $0x1,%eax
80106b83:	c1 e0 16             	shl    $0x16,%eax
80106b86:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b88:	39 da                	cmp    %ebx,%edx
80106b8a:	76 39                	jbe    80106bc5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106b8c:	89 d8                	mov    %ebx,%eax
80106b8e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b91:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106b94:	f6 c1 01             	test   $0x1,%cl
80106b97:	74 e7                	je     80106b80 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b99:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b9b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106ba1:	c1 ee 0a             	shr    $0xa,%esi
80106ba4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106baa:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106bb1:	85 f6                	test   %esi,%esi
80106bb3:	74 cb                	je     80106b80 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106bb5:	8b 06                	mov    (%esi),%eax
80106bb7:	a8 01                	test   $0x1,%al
80106bb9:	75 15                	jne    80106bd0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106bbb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bc1:	39 da                	cmp    %ebx,%edx
80106bc3:	77 c7                	ja     80106b8c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bcb:	5b                   	pop    %ebx
80106bcc:	5e                   	pop    %esi
80106bcd:	5f                   	pop    %edi
80106bce:	5d                   	pop    %ebp
80106bcf:	c3                   	ret    
      if(pa == 0)
80106bd0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bd5:	74 25                	je     80106bfc <deallocuvm.part.0+0x9c>
      kfree(v);
80106bd7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bda:	05 00 00 00 80       	add    $0x80000000,%eax
80106bdf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106be2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106be8:	50                   	push   %eax
80106be9:	e8 d2 b8 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106bee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106bf4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106bf7:	83 c4 10             	add    $0x10,%esp
80106bfa:	eb 8c                	jmp    80106b88 <deallocuvm.part.0+0x28>
        panic("kfree");
80106bfc:	83 ec 0c             	sub    $0xc,%esp
80106bff:	68 a6 79 10 80       	push   $0x801079a6
80106c04:	e8 77 97 ff ff       	call   80100380 <panic>
80106c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c10 <deallochugeuvm.part.0>:

// TODO: implement this
// part 2
// I havent touched this, only copy paste
int
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	89 d7                	mov    %edx,%edi
80106c16:	56                   	push   %esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = HUGEPGROUNDUP(newsz);
80106c17:	8d b1 ff ff 3f 00    	lea    0x3fffff(%ecx),%esi
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c1d:	53                   	push   %ebx
  a = HUGEPGROUNDUP(newsz);
80106c1e:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c24:	83 ec 1c             	sub    $0x1c,%esp
80106c27:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c2a:	39 d6                	cmp    %edx,%esi
80106c2c:	72 0e                	jb     80106c3c <deallochugeuvm.part.0+0x2c>
80106c2e:	eb 3c                	jmp    80106c6c <deallochugeuvm.part.0+0x5c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
80106c30:	83 c1 01             	add    $0x1,%ecx
80106c33:	89 ce                	mov    %ecx,%esi
80106c35:	c1 e6 16             	shl    $0x16,%esi
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c38:	39 f7                	cmp    %esi,%edi
80106c3a:	76 30                	jbe    80106c6c <deallochugeuvm.part.0+0x5c>
  pde = &pgdir[PDX(va)];
80106c3c:	89 f1                	mov    %esi,%ecx
80106c3e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106c41:	8b 1c 88             	mov    (%eax,%ecx,4),%ebx
80106c44:	f6 c3 01             	test   $0x1,%bl
80106c47:	74 e7                	je     80106c30 <deallochugeuvm.part.0+0x20>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c49:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(!pte)
80106c4f:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80106c55:	74 d9                	je     80106c30 <deallochugeuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106c57:	8b 8b 00 00 00 80    	mov    -0x80000000(%ebx),%ecx
80106c5d:	f6 c1 01             	test   $0x1,%cl
80106c60:	75 1e                	jne    80106c80 <deallochugeuvm.part.0+0x70>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c62:	81 c6 00 00 40 00    	add    $0x400000,%esi
80106c68:	39 f7                	cmp    %esi,%edi
80106c6a:	77 d0                	ja     80106c3c <deallochugeuvm.part.0+0x2c>
      khugefree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c72:	5b                   	pop    %ebx
80106c73:	5e                   	pop    %esi
80106c74:	5f                   	pop    %edi
80106c75:	5d                   	pop    %ebp
80106c76:	c3                   	ret    
80106c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c7e:	66 90                	xchg   %ax,%ax
      if(pa == 0)
80106c80:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106c86:	74 2a                	je     80106cb2 <deallochugeuvm.part.0+0xa2>
      khugefree(v);
80106c88:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c8b:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80106c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c94:	81 c6 00 00 40 00    	add    $0x400000,%esi
      khugefree(v);
80106c9a:	51                   	push   %ecx
80106c9b:	e8 e0 b9 ff ff       	call   80102680 <khugefree>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ca3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106ca6:	c7 83 00 00 00 80 00 	movl   $0x0,-0x80000000(%ebx)
80106cad:	00 00 00 
80106cb0:	eb 86                	jmp    80106c38 <deallochugeuvm.part.0+0x28>
        panic("khugefree");
80106cb2:	83 ec 0c             	sub    $0xc,%esp
80106cb5:	68 b1 79 10 80       	push   $0x801079b1
80106cba:	e8 c1 96 ff ff       	call   80100380 <panic>
80106cbf:	90                   	nop

80106cc0 <mappages>:
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106cc6:	89 d3                	mov    %edx,%ebx
80106cc8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cce:	83 ec 1c             	sub    $0x1c,%esp
80106cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cd4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce3:	29 d8                	sub    %ebx,%eax
80106ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ce8:	eb 3d                	jmp    80106d27 <mappages+0x67>
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106cf0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cf2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cf7:	c1 ea 0a             	shr    $0xa,%edx
80106cfa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d00:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d07:	85 c0                	test   %eax,%eax
80106d09:	74 75                	je     80106d80 <mappages+0xc0>
    if(*pte & PTE_P)
80106d0b:	f6 00 01             	testb  $0x1,(%eax)
80106d0e:	0f 85 86 00 00 00    	jne    80106d9a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d14:	0b 75 0c             	or     0xc(%ebp),%esi
80106d17:	83 ce 01             	or     $0x1,%esi
80106d1a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d1c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106d1f:	74 6f                	je     80106d90 <mappages+0xd0>
    a += PGSIZE;
80106d21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106d2a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d2d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106d30:	89 d8                	mov    %ebx,%eax
80106d32:	c1 e8 16             	shr    $0x16,%eax
80106d35:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106d38:	8b 07                	mov    (%edi),%eax
80106d3a:	a8 01                	test   $0x1,%al
80106d3c:	75 b2                	jne    80106cf0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d3e:	e8 7d ba ff ff       	call   801027c0 <kalloc>
80106d43:	85 c0                	test   %eax,%eax
80106d45:	74 39                	je     80106d80 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d47:	83 ec 04             	sub    $0x4,%esp
80106d4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d4d:	68 00 10 00 00       	push   $0x1000
80106d52:	6a 00                	push   $0x0
80106d54:	50                   	push   %eax
80106d55:	e8 46 db ff ff       	call   801048a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d5a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106d5d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d60:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d66:	83 c8 07             	or     $0x7,%eax
80106d69:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d6b:	89 d8                	mov    %ebx,%eax
80106d6d:	c1 e8 0a             	shr    $0xa,%eax
80106d70:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d75:	01 d0                	add    %edx,%eax
80106d77:	eb 92                	jmp    80106d0b <mappages+0x4b>
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d88:	5b                   	pop    %ebx
80106d89:	5e                   	pop    %esi
80106d8a:	5f                   	pop    %edi
80106d8b:	5d                   	pop    %ebp
80106d8c:	c3                   	ret    
80106d8d:	8d 76 00             	lea    0x0(%esi),%esi
80106d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d93:	31 c0                	xor    %eax,%eax
}
80106d95:	5b                   	pop    %ebx
80106d96:	5e                   	pop    %esi
80106d97:	5f                   	pop    %edi
80106d98:	5d                   	pop    %ebp
80106d99:	c3                   	ret    
      panic("remap");
80106d9a:	83 ec 0c             	sub    $0xc,%esp
80106d9d:	68 0c 80 10 80       	push   $0x8010800c
80106da2:	e8 d9 95 ff ff       	call   80100380 <panic>
80106da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dae:	66 90                	xchg   %ax,%ax

80106db0 <seginit>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106db6:	e8 55 cd ff ff       	call   80103b10 <cpuid>
  pd[0] = size-1;
80106dbb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106dc0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106dc6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106dca:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80106dd1:	ff 00 00 
80106dd4:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
80106ddb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106dde:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80106de5:	ff 00 00 
80106de8:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
80106def:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106df2:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
80106df9:	ff 00 00 
80106dfc:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
80106e03:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e06:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
80106e0d:	ff 00 00 
80106e10:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
80106e17:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e1a:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
80106e1f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e23:	c1 e8 10             	shr    $0x10,%eax
80106e26:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e2a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e2d:	0f 01 10             	lgdtl  (%eax)
}
80106e30:	c9                   	leave  
80106e31:	c3                   	ret    
80106e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e40 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e40:	a1 e4 55 11 80       	mov    0x801155e4,%eax
80106e45:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e4a:	0f 22 d8             	mov    %eax,%cr3
}
80106e4d:	c3                   	ret    
80106e4e:	66 90                	xchg   %ax,%ax

80106e50 <switchuvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 1c             	sub    $0x1c,%esp
80106e59:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106e5c:	85 f6                	test   %esi,%esi
80106e5e:	0f 84 cb 00 00 00    	je     80106f2f <switchuvm+0xdf>
  if(p->kstack == 0)
80106e64:	8b 46 0c             	mov    0xc(%esi),%eax
80106e67:	85 c0                	test   %eax,%eax
80106e69:	0f 84 da 00 00 00    	je     80106f49 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e6f:	8b 46 08             	mov    0x8(%esi),%eax
80106e72:	85 c0                	test   %eax,%eax
80106e74:	0f 84 c2 00 00 00    	je     80106f3c <switchuvm+0xec>
  pushcli();
80106e7a:	e8 11 d8 ff ff       	call   80104690 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e7f:	e8 2c cc ff ff       	call   80103ab0 <mycpu>
80106e84:	89 c3                	mov    %eax,%ebx
80106e86:	e8 25 cc ff ff       	call   80103ab0 <mycpu>
80106e8b:	89 c7                	mov    %eax,%edi
80106e8d:	e8 1e cc ff ff       	call   80103ab0 <mycpu>
80106e92:	83 c7 08             	add    $0x8,%edi
80106e95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e98:	e8 13 cc ff ff       	call   80103ab0 <mycpu>
80106e9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ea0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ea5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106eac:	83 c0 08             	add    $0x8,%eax
80106eaf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106eb6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ebb:	83 c1 08             	add    $0x8,%ecx
80106ebe:	c1 e8 18             	shr    $0x18,%eax
80106ec1:	c1 e9 10             	shr    $0x10,%ecx
80106ec4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106eca:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ed0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ed5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106edc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ee1:	e8 ca cb ff ff       	call   80103ab0 <mycpu>
80106ee6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106eed:	e8 be cb ff ff       	call   80103ab0 <mycpu>
80106ef2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ef6:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106ef9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eff:	e8 ac cb ff ff       	call   80103ab0 <mycpu>
80106f04:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f07:	e8 a4 cb ff ff       	call   80103ab0 <mycpu>
80106f0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f10:	b8 28 00 00 00       	mov    $0x28,%eax
80106f15:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f18:	8b 46 08             	mov    0x8(%esi),%eax
80106f1b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f20:	0f 22 d8             	mov    %eax,%cr3
}
80106f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f26:	5b                   	pop    %ebx
80106f27:	5e                   	pop    %esi
80106f28:	5f                   	pop    %edi
80106f29:	5d                   	pop    %ebp
  popcli();
80106f2a:	e9 b1 d7 ff ff       	jmp    801046e0 <popcli>
    panic("switchuvm: no process");
80106f2f:	83 ec 0c             	sub    $0xc,%esp
80106f32:	68 12 80 10 80       	push   $0x80108012
80106f37:	e8 44 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106f3c:	83 ec 0c             	sub    $0xc,%esp
80106f3f:	68 3d 80 10 80       	push   $0x8010803d
80106f44:	e8 37 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106f49:	83 ec 0c             	sub    $0xc,%esp
80106f4c:	68 28 80 10 80       	push   $0x80108028
80106f51:	e8 2a 94 ff ff       	call   80100380 <panic>
80106f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f5d:	8d 76 00             	lea    0x0(%esi),%esi

80106f60 <inituvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f6c:	8b 75 10             	mov    0x10(%ebp),%esi
80106f6f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f75:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f7b:	77 4b                	ja     80106fc8 <inituvm+0x68>
  mem = kalloc();
80106f7d:	e8 3e b8 ff ff       	call   801027c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106f82:	83 ec 04             	sub    $0x4,%esp
80106f85:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106f8a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f8c:	6a 00                	push   $0x0
80106f8e:	50                   	push   %eax
80106f8f:	e8 0c d9 ff ff       	call   801048a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f94:	58                   	pop    %eax
80106f95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f9b:	5a                   	pop    %edx
80106f9c:	6a 06                	push   $0x6
80106f9e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fa3:	31 d2                	xor    %edx,%edx
80106fa5:	50                   	push   %eax
80106fa6:	89 f8                	mov    %edi,%eax
80106fa8:	e8 13 fd ff ff       	call   80106cc0 <mappages>
  memmove(mem, init, sz);
80106fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fb0:	89 75 10             	mov    %esi,0x10(%ebp)
80106fb3:	83 c4 10             	add    $0x10,%esp
80106fb6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106fb9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fbf:	5b                   	pop    %ebx
80106fc0:	5e                   	pop    %esi
80106fc1:	5f                   	pop    %edi
80106fc2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106fc3:	e9 78 d9 ff ff       	jmp    80104940 <memmove>
    panic("inituvm: more than a page");
80106fc8:	83 ec 0c             	sub    $0xc,%esp
80106fcb:	68 51 80 10 80       	push   $0x80108051
80106fd0:	e8 ab 93 ff ff       	call   80100380 <panic>
80106fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106fe0 <loaduvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 1c             	sub    $0x1c,%esp
80106fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fec:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106fef:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ff4:	0f 85 bb 00 00 00    	jne    801070b5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106ffa:	01 f0                	add    %esi,%eax
80106ffc:	89 f3                	mov    %esi,%ebx
80106ffe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107001:	8b 45 14             	mov    0x14(%ebp),%eax
80107004:	01 f0                	add    %esi,%eax
80107006:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107009:	85 f6                	test   %esi,%esi
8010700b:	0f 84 87 00 00 00    	je     80107098 <loaduvm+0xb8>
80107011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010701b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010701e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107020:	89 c2                	mov    %eax,%edx
80107022:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107025:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107028:	f6 c2 01             	test   $0x1,%dl
8010702b:	75 13                	jne    80107040 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010702d:	83 ec 0c             	sub    $0xc,%esp
80107030:	68 6b 80 10 80       	push   $0x8010806b
80107035:	e8 46 93 ff ff       	call   80100380 <panic>
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107040:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107043:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107049:	25 fc 0f 00 00       	and    $0xffc,%eax
8010704e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107055:	85 c0                	test   %eax,%eax
80107057:	74 d4                	je     8010702d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107059:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010705b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010705e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107063:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107068:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010706e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107071:	29 d9                	sub    %ebx,%ecx
80107073:	05 00 00 00 80       	add    $0x80000000,%eax
80107078:	57                   	push   %edi
80107079:	51                   	push   %ecx
8010707a:	50                   	push   %eax
8010707b:	ff 75 10             	push   0x10(%ebp)
8010707e:	e8 0d aa ff ff       	call   80101a90 <readi>
80107083:	83 c4 10             	add    $0x10,%esp
80107086:	39 f8                	cmp    %edi,%eax
80107088:	75 1e                	jne    801070a8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010708a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107090:	89 f0                	mov    %esi,%eax
80107092:	29 d8                	sub    %ebx,%eax
80107094:	39 c6                	cmp    %eax,%esi
80107096:	77 80                	ja     80107018 <loaduvm+0x38>
}
80107098:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010709b:	31 c0                	xor    %eax,%eax
}
8010709d:	5b                   	pop    %ebx
8010709e:	5e                   	pop    %esi
8010709f:	5f                   	pop    %edi
801070a0:	5d                   	pop    %ebp
801070a1:	c3                   	ret    
801070a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070b0:	5b                   	pop    %ebx
801070b1:	5e                   	pop    %esi
801070b2:	5f                   	pop    %edi
801070b3:	5d                   	pop    %ebp
801070b4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801070b5:	83 ec 0c             	sub    $0xc,%esp
801070b8:	68 28 81 10 80       	push   $0x80108128
801070bd:	e8 be 92 ff ff       	call   80100380 <panic>
801070c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <allocuvm>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801070d9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801070dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801070df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070e2:	85 c0                	test   %eax,%eax
801070e4:	0f 88 b6 00 00 00    	js     801071a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801070ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801070ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801070f0:	0f 82 9a 00 00 00    	jb     80107190 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801070f6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801070fc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107102:	39 75 10             	cmp    %esi,0x10(%ebp)
80107105:	77 44                	ja     8010714b <allocuvm+0x7b>
80107107:	e9 87 00 00 00       	jmp    80107193 <allocuvm+0xc3>
8010710c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107110:	83 ec 04             	sub    $0x4,%esp
80107113:	68 00 10 00 00       	push   $0x1000
80107118:	6a 00                	push   $0x0
8010711a:	50                   	push   %eax
8010711b:	e8 80 d7 ff ff       	call   801048a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107120:	58                   	pop    %eax
80107121:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107127:	5a                   	pop    %edx
80107128:	6a 06                	push   $0x6
8010712a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010712f:	89 f2                	mov    %esi,%edx
80107131:	50                   	push   %eax
80107132:	89 f8                	mov    %edi,%eax
80107134:	e8 87 fb ff ff       	call   80106cc0 <mappages>
80107139:	83 c4 10             	add    $0x10,%esp
8010713c:	85 c0                	test   %eax,%eax
8010713e:	78 78                	js     801071b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107140:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107146:	39 75 10             	cmp    %esi,0x10(%ebp)
80107149:	76 48                	jbe    80107193 <allocuvm+0xc3>
    mem = kalloc();
8010714b:	e8 70 b6 ff ff       	call   801027c0 <kalloc>
80107150:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107152:	85 c0                	test   %eax,%eax
80107154:	75 ba                	jne    80107110 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107156:	83 ec 0c             	sub    $0xc,%esp
80107159:	68 89 80 10 80       	push   $0x80108089
8010715e:	e8 3d 95 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107163:	8b 45 0c             	mov    0xc(%ebp),%eax
80107166:	83 c4 10             	add    $0x10,%esp
80107169:	39 45 10             	cmp    %eax,0x10(%ebp)
8010716c:	74 32                	je     801071a0 <allocuvm+0xd0>
8010716e:	8b 55 10             	mov    0x10(%ebp),%edx
80107171:	89 c1                	mov    %eax,%ecx
80107173:	89 f8                	mov    %edi,%eax
80107175:	e8 e6 f9 ff ff       	call   80106b60 <deallocuvm.part.0>
      return 0;
8010717a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107184:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107187:	5b                   	pop    %ebx
80107188:	5e                   	pop    %esi
80107189:	5f                   	pop    %edi
8010718a:	5d                   	pop    %ebp
8010718b:	c3                   	ret    
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107190:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107199:	5b                   	pop    %ebx
8010719a:	5e                   	pop    %esi
8010719b:	5f                   	pop    %edi
8010719c:	5d                   	pop    %ebp
8010719d:	c3                   	ret    
8010719e:	66 90                	xchg   %ax,%ax
    return 0;
801071a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ad:	5b                   	pop    %ebx
801071ae:	5e                   	pop    %esi
801071af:	5f                   	pop    %edi
801071b0:	5d                   	pop    %ebp
801071b1:	c3                   	ret    
801071b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801071b8:	83 ec 0c             	sub    $0xc,%esp
801071bb:	68 a1 80 10 80       	push   $0x801080a1
801071c0:	e8 db 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801071c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801071c8:	83 c4 10             	add    $0x10,%esp
801071cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801071ce:	74 0c                	je     801071dc <allocuvm+0x10c>
801071d0:	8b 55 10             	mov    0x10(%ebp),%edx
801071d3:	89 c1                	mov    %eax,%ecx
801071d5:	89 f8                	mov    %edi,%eax
801071d7:	e8 84 f9 ff ff       	call   80106b60 <deallocuvm.part.0>
      kfree(mem);
801071dc:	83 ec 0c             	sub    $0xc,%esp
801071df:	53                   	push   %ebx
801071e0:	e8 db b2 ff ff       	call   801024c0 <kfree>
      return 0;
801071e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801071ec:	83 c4 10             	add    $0x10,%esp
}
801071ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f5:	5b                   	pop    %ebx
801071f6:	5e                   	pop    %esi
801071f7:	5f                   	pop    %edi
801071f8:	5d                   	pop    %ebp
801071f9:	c3                   	ret    
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107200 <allochugeuvm>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 0c             	sub    $0xc,%esp
  if(newsz < oldsz)
80107209:	8b 45 0c             	mov    0xc(%ebp),%eax
{
8010720c:	8b 7d 08             	mov    0x8(%ebp),%edi
    return oldsz;
8010720f:	89 c3                	mov    %eax,%ebx
  if(newsz < oldsz)
80107211:	39 45 10             	cmp    %eax,0x10(%ebp)
80107214:	0f 82 8f 00 00 00    	jb     801072a9 <allochugeuvm+0xa9>
  a = HUGEPGROUNDUP(oldsz);
8010721a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010721d:	8d b0 ff ff 3f 00    	lea    0x3fffff(%eax),%esi
80107223:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
  for(; a < newsz; a += HUGE_PAGE_SIZE){
80107229:	39 75 10             	cmp    %esi,0x10(%ebp)
8010722c:	77 4c                	ja     8010727a <allochugeuvm+0x7a>
8010722e:	e9 85 00 00 00       	jmp    801072b8 <allochugeuvm+0xb8>
80107233:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107237:	90                   	nop
    memset(mem, 0, HUGE_PAGE_SIZE);
80107238:	83 ec 04             	sub    $0x4,%esp
8010723b:	68 00 00 40 00       	push   $0x400000
80107240:	6a 00                	push   $0x0
80107242:	50                   	push   %eax
80107243:	e8 58 d6 ff ff       	call   801048a0 <memset>
    if(mappages(pgdir, (char*)a + HUGE_VA_OFFSET, HUGE_PAGE_SIZE, V2P(mem), PTE_PS|PTE_W|PTE_U) < 0){
80107248:	58                   	pop    %eax
80107249:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010724f:	59                   	pop    %ecx
80107250:	68 86 00 00 00       	push   $0x86
80107255:	8d 96 00 00 00 1e    	lea    0x1e000000(%esi),%edx
8010725b:	b9 00 00 40 00       	mov    $0x400000,%ecx
80107260:	50                   	push   %eax
80107261:	89 f8                	mov    %edi,%eax
80107263:	e8 58 fa ff ff       	call   80106cc0 <mappages>
80107268:	83 c4 10             	add    $0x10,%esp
8010726b:	85 c0                	test   %eax,%eax
8010726d:	78 59                	js     801072c8 <allochugeuvm+0xc8>
  for(; a < newsz; a += HUGE_PAGE_SIZE){
8010726f:	81 c6 00 00 40 00    	add    $0x400000,%esi
80107275:	39 75 10             	cmp    %esi,0x10(%ebp)
80107278:	76 3e                	jbe    801072b8 <allochugeuvm+0xb8>
    mem = khugealloc();
8010727a:	e8 b1 b5 ff ff       	call   80102830 <khugealloc>
8010727f:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107281:	85 c0                	test   %eax,%eax
80107283:	75 b3                	jne    80107238 <allochugeuvm+0x38>
      cprintf("allochugeuvm out of memory\n");
80107285:	83 ec 0c             	sub    $0xc,%esp
80107288:	68 bd 80 10 80       	push   $0x801080bd
8010728d:	e8 0e 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107292:	8b 45 0c             	mov    0xc(%ebp),%eax
80107295:	83 c4 10             	add    $0x10,%esp
80107298:	39 45 10             	cmp    %eax,0x10(%ebp)
8010729b:	74 0c                	je     801072a9 <allochugeuvm+0xa9>
8010729d:	8b 55 10             	mov    0x10(%ebp),%edx
801072a0:	89 c1                	mov    %eax,%ecx
801072a2:	89 f8                	mov    %edi,%eax
801072a4:	e8 67 f9 ff ff       	call   80106c10 <deallochugeuvm.part.0>
}
801072a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ac:	89 d8                	mov    %ebx,%eax
801072ae:	5b                   	pop    %ebx
801072af:	5e                   	pop    %esi
801072b0:	5f                   	pop    %edi
801072b1:	5d                   	pop    %ebp
801072b2:	c3                   	ret    
801072b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072b7:	90                   	nop
  return newsz;
801072b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
}
801072bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072be:	89 d8                	mov    %ebx,%eax
801072c0:	5b                   	pop    %ebx
801072c1:	5e                   	pop    %esi
801072c2:	5f                   	pop    %edi
801072c3:	5d                   	pop    %ebp
801072c4:	c3                   	ret    
801072c5:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allochugeuvm out of memory (2)\n");
801072c8:	83 ec 0c             	sub    $0xc,%esp
801072cb:	68 4c 81 10 80       	push   $0x8010814c
801072d0:	e8 cb 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072d8:	83 c4 10             	add    $0x10,%esp
801072db:	39 45 10             	cmp    %eax,0x10(%ebp)
801072de:	74 0c                	je     801072ec <allochugeuvm+0xec>
801072e0:	8b 55 10             	mov    0x10(%ebp),%edx
801072e3:	89 c1                	mov    %eax,%ecx
801072e5:	89 f8                	mov    %edi,%eax
801072e7:	e8 24 f9 ff ff       	call   80106c10 <deallochugeuvm.part.0>
      kfree(mem);
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	53                   	push   %ebx
      return 0;
801072f0:	31 db                	xor    %ebx,%ebx
      kfree(mem);
801072f2:	e8 c9 b1 ff ff       	call   801024c0 <kfree>
      return 0;
801072f7:	83 c4 10             	add    $0x10,%esp
}
801072fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072fd:	89 d8                	mov    %ebx,%eax
801072ff:	5b                   	pop    %ebx
80107300:	5e                   	pop    %esi
80107301:	5f                   	pop    %edi
80107302:	5d                   	pop    %ebp
80107303:	c3                   	ret    
80107304:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010730b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010730f:	90                   	nop

80107310 <deallocuvm>:
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	8b 55 0c             	mov    0xc(%ebp),%edx
80107316:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107319:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010731c:	39 d1                	cmp    %edx,%ecx
8010731e:	73 10                	jae    80107330 <deallocuvm+0x20>
}
80107320:	5d                   	pop    %ebp
80107321:	e9 3a f8 ff ff       	jmp    80106b60 <deallocuvm.part.0>
80107326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
80107330:	89 d0                	mov    %edx,%eax
80107332:	5d                   	pop    %ebp
80107333:	c3                   	ret    
80107334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010733f:	90                   	nop

80107340 <deallochugeuvm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	8b 55 0c             	mov    0xc(%ebp),%edx
80107346:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107349:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010734c:	39 d1                	cmp    %edx,%ecx
8010734e:	73 10                	jae    80107360 <deallochugeuvm+0x20>
}
80107350:	5d                   	pop    %ebp
80107351:	e9 ba f8 ff ff       	jmp    80106c10 <deallochugeuvm.part.0>
80107356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735d:	8d 76 00             	lea    0x0(%esi),%esi
80107360:	89 d0                	mov    %edx,%eax
80107362:	5d                   	pop    %ebp
80107363:	c3                   	ret    
80107364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010736f:	90                   	nop

80107370 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
80107376:	83 ec 0c             	sub    $0xc,%esp
80107379:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010737c:	85 f6                	test   %esi,%esi
8010737e:	74 59                	je     801073d9 <freevm+0x69>
  if(newsz >= oldsz)
80107380:	31 c9                	xor    %ecx,%ecx
80107382:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107387:	89 f0                	mov    %esi,%eax
80107389:	89 f3                	mov    %esi,%ebx
8010738b:	e8 d0 f7 ff ff       	call   80106b60 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107390:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107396:	eb 0f                	jmp    801073a7 <freevm+0x37>
80107398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739f:	90                   	nop
801073a0:	83 c3 04             	add    $0x4,%ebx
801073a3:	39 df                	cmp    %ebx,%edi
801073a5:	74 23                	je     801073ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801073a7:	8b 03                	mov    (%ebx),%eax
801073a9:	a8 01                	test   $0x1,%al
801073ab:	74 f3                	je     801073a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801073b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801073bd:	50                   	push   %eax
801073be:	e8 fd b0 ff ff       	call   801024c0 <kfree>
801073c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073c6:	39 df                	cmp    %ebx,%edi
801073c8:	75 dd                	jne    801073a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801073ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d0:	5b                   	pop    %ebx
801073d1:	5e                   	pop    %esi
801073d2:	5f                   	pop    %edi
801073d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073d4:	e9 e7 b0 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
801073d9:	83 ec 0c             	sub    $0xc,%esp
801073dc:	68 d9 80 10 80       	push   $0x801080d9
801073e1:	e8 9a 8f ff ff       	call   80100380 <panic>
801073e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ed:	8d 76 00             	lea    0x0(%esi),%esi

801073f0 <setupkvm>:
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	56                   	push   %esi
801073f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073f5:	e8 c6 b3 ff ff       	call   801027c0 <kalloc>
801073fa:	89 c6                	mov    %eax,%esi
801073fc:	85 c0                	test   %eax,%eax
801073fe:	74 42                	je     80107442 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107400:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107403:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107408:	68 00 10 00 00       	push   $0x1000
8010740d:	6a 00                	push   $0x0
8010740f:	50                   	push   %eax
80107410:	e8 8b d4 ff ff       	call   801048a0 <memset>
80107415:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107418:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010741b:	83 ec 08             	sub    $0x8,%esp
8010741e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107421:	ff 73 0c             	push   0xc(%ebx)
80107424:	8b 13                	mov    (%ebx),%edx
80107426:	50                   	push   %eax
80107427:	29 c1                	sub    %eax,%ecx
80107429:	89 f0                	mov    %esi,%eax
8010742b:	e8 90 f8 ff ff       	call   80106cc0 <mappages>
80107430:	83 c4 10             	add    $0x10,%esp
80107433:	85 c0                	test   %eax,%eax
80107435:	78 19                	js     80107450 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107437:	83 c3 10             	add    $0x10,%ebx
8010743a:	81 fb 70 b4 10 80    	cmp    $0x8010b470,%ebx
80107440:	75 d6                	jne    80107418 <setupkvm+0x28>
}
80107442:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107445:	89 f0                	mov    %esi,%eax
80107447:	5b                   	pop    %ebx
80107448:	5e                   	pop    %esi
80107449:	5d                   	pop    %ebp
8010744a:	c3                   	ret    
8010744b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010744f:	90                   	nop
      freevm(pgdir);
80107450:	83 ec 0c             	sub    $0xc,%esp
80107453:	56                   	push   %esi
      return 0;
80107454:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107456:	e8 15 ff ff ff       	call   80107370 <freevm>
      return 0;
8010745b:	83 c4 10             	add    $0x10,%esp
}
8010745e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107461:	89 f0                	mov    %esi,%eax
80107463:	5b                   	pop    %ebx
80107464:	5e                   	pop    %esi
80107465:	5d                   	pop    %ebp
80107466:	c3                   	ret    
80107467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746e:	66 90                	xchg   %ax,%ax

80107470 <kvmalloc>:
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107476:	e8 75 ff ff ff       	call   801073f0 <setupkvm>
8010747b:	a3 e4 55 11 80       	mov    %eax,0x801155e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107480:	05 00 00 00 80       	add    $0x80000000,%eax
80107485:	0f 22 d8             	mov    %eax,%cr3
}
80107488:	c9                   	leave  
80107489:	c3                   	ret    
8010748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107490 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	83 ec 08             	sub    $0x8,%esp
80107496:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107499:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010749c:	89 c1                	mov    %eax,%ecx
8010749e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801074a4:	f6 c2 01             	test   $0x1,%dl
801074a7:	75 17                	jne    801074c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801074a9:	83 ec 0c             	sub    $0xc,%esp
801074ac:	68 ea 80 10 80       	push   $0x801080ea
801074b1:	e8 ca 8e ff ff       	call   80100380 <panic>
801074b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801074d5:	85 c0                	test   %eax,%eax
801074d7:	74 d0                	je     801074a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801074d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074dc:	c9                   	leave  
801074dd:	c3                   	ret    
801074de:	66 90                	xchg   %ax,%ax

801074e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	57                   	push   %edi
801074e4:	56                   	push   %esi
801074e5:	53                   	push   %ebx
801074e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074e9:	e8 02 ff ff ff       	call   801073f0 <setupkvm>
801074ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074f1:	85 c0                	test   %eax,%eax
801074f3:	0f 84 bd 00 00 00    	je     801075b6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074fc:	85 c9                	test   %ecx,%ecx
801074fe:	0f 84 b2 00 00 00    	je     801075b6 <copyuvm+0xd6>
80107504:	31 f6                	xor    %esi,%esi
80107506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107513:	89 f0                	mov    %esi,%eax
80107515:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107518:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010751b:	a8 01                	test   $0x1,%al
8010751d:	75 11                	jne    80107530 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010751f:	83 ec 0c             	sub    $0xc,%esp
80107522:	68 f4 80 10 80       	push   $0x801080f4
80107527:	e8 54 8e ff ff       	call   80100380 <panic>
8010752c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107530:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107532:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107537:	c1 ea 0a             	shr    $0xa,%edx
8010753a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107540:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107547:	85 c0                	test   %eax,%eax
80107549:	74 d4                	je     8010751f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010754b:	8b 00                	mov    (%eax),%eax
8010754d:	a8 01                	test   $0x1,%al
8010754f:	0f 84 9f 00 00 00    	je     801075f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107555:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107557:	25 ff 0f 00 00       	and    $0xfff,%eax
8010755c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010755f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107565:	e8 56 b2 ff ff       	call   801027c0 <kalloc>
8010756a:	89 c3                	mov    %eax,%ebx
8010756c:	85 c0                	test   %eax,%eax
8010756e:	74 64                	je     801075d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107570:	83 ec 04             	sub    $0x4,%esp
80107573:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107579:	68 00 10 00 00       	push   $0x1000
8010757e:	57                   	push   %edi
8010757f:	50                   	push   %eax
80107580:	e8 bb d3 ff ff       	call   80104940 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107585:	58                   	pop    %eax
80107586:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010758c:	5a                   	pop    %edx
8010758d:	ff 75 e4             	push   -0x1c(%ebp)
80107590:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107595:	89 f2                	mov    %esi,%edx
80107597:	50                   	push   %eax
80107598:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010759b:	e8 20 f7 ff ff       	call   80106cc0 <mappages>
801075a0:	83 c4 10             	add    $0x10,%esp
801075a3:	85 c0                	test   %eax,%eax
801075a5:	78 21                	js     801075c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801075a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801075b0:	0f 87 5a ff ff ff    	ja     80107510 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801075b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075bc:	5b                   	pop    %ebx
801075bd:	5e                   	pop    %esi
801075be:	5f                   	pop    %edi
801075bf:	5d                   	pop    %ebp
801075c0:	c3                   	ret    
801075c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801075c8:	83 ec 0c             	sub    $0xc,%esp
801075cb:	53                   	push   %ebx
801075cc:	e8 ef ae ff ff       	call   801024c0 <kfree>
      goto bad;
801075d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801075d4:	83 ec 0c             	sub    $0xc,%esp
801075d7:	ff 75 e0             	push   -0x20(%ebp)
801075da:	e8 91 fd ff ff       	call   80107370 <freevm>
  return 0;
801075df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801075e6:	83 c4 10             	add    $0x10,%esp
}
801075e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ef:	5b                   	pop    %ebx
801075f0:	5e                   	pop    %esi
801075f1:	5f                   	pop    %edi
801075f2:	5d                   	pop    %ebp
801075f3:	c3                   	ret    
      panic("copyuvm: page not present");
801075f4:	83 ec 0c             	sub    $0xc,%esp
801075f7:	68 0e 81 10 80       	push   $0x8010810e
801075fc:	e8 7f 8d ff ff       	call   80100380 <panic>
80107601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760f:	90                   	nop

80107610 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107616:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107619:	89 c1                	mov    %eax,%ecx
8010761b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010761e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107621:	f6 c2 01             	test   $0x1,%dl
80107624:	0f 84 00 01 00 00    	je     8010772a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010762a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010762d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107633:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107634:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107639:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107640:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107642:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107647:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010764a:	05 00 00 00 80       	add    $0x80000000,%eax
8010764f:	83 fa 05             	cmp    $0x5,%edx
80107652:	ba 00 00 00 00       	mov    $0x0,%edx
80107657:	0f 45 c2             	cmovne %edx,%eax
}
8010765a:	c3                   	ret    
8010765b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010765f:	90                   	nop

80107660 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 0c             	sub    $0xc,%esp
80107669:	8b 75 14             	mov    0x14(%ebp),%esi
8010766c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010766f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107672:	85 f6                	test   %esi,%esi
80107674:	75 51                	jne    801076c7 <copyout+0x67>
80107676:	e9 a5 00 00 00       	jmp    80107720 <copyout+0xc0>
8010767b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010767f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107680:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107686:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010768c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107692:	74 75                	je     80107709 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107694:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107696:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107699:	29 c3                	sub    %eax,%ebx
8010769b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076a1:	39 f3                	cmp    %esi,%ebx
801076a3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801076a6:	29 f8                	sub    %edi,%eax
801076a8:	83 ec 04             	sub    $0x4,%esp
801076ab:	01 c1                	add    %eax,%ecx
801076ad:	53                   	push   %ebx
801076ae:	52                   	push   %edx
801076af:	51                   	push   %ecx
801076b0:	e8 8b d2 ff ff       	call   80104940 <memmove>
    len -= n;
    buf += n;
801076b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801076b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801076be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801076c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801076c3:	29 de                	sub    %ebx,%esi
801076c5:	74 59                	je     80107720 <copyout+0xc0>
  if(*pde & PTE_P){
801076c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801076ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801076ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801076d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801076da:	f6 c1 01             	test   $0x1,%cl
801076dd:	0f 84 4e 00 00 00    	je     80107731 <copyout.cold>
  return &pgtab[PTX(va)];
801076e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801076eb:	c1 eb 0c             	shr    $0xc,%ebx
801076ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801076f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801076fb:	89 d9                	mov    %ebx,%ecx
801076fd:	83 e1 05             	and    $0x5,%ecx
80107700:	83 f9 05             	cmp    $0x5,%ecx
80107703:	0f 84 77 ff ff ff    	je     80107680 <copyout+0x20>
  }
  return 0;
}
80107709:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010770c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107711:	5b                   	pop    %ebx
80107712:	5e                   	pop    %esi
80107713:	5f                   	pop    %edi
80107714:	5d                   	pop    %ebp
80107715:	c3                   	ret    
80107716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010771d:	8d 76 00             	lea    0x0(%esi),%esi
80107720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107723:	31 c0                	xor    %eax,%eax
}
80107725:	5b                   	pop    %ebx
80107726:	5e                   	pop    %esi
80107727:	5f                   	pop    %edi
80107728:	5d                   	pop    %ebp
80107729:	c3                   	ret    

8010772a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010772a:	a1 00 00 00 00       	mov    0x0,%eax
8010772f:	0f 0b                	ud2    

80107731 <copyout.cold>:
80107731:	a1 00 00 00 00       	mov    0x0,%eax
80107736:	0f 0b                	ud2    
