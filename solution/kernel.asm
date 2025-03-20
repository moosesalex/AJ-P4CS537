
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
80100028:	bc d0 65 11 80       	mov    $0x801165d0,%esp
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
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 77 10 80       	push   $0x80107760
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 a5 45 00 00       	call   80104600 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
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
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 77 10 80       	push   $0x80107767
80100097:	50                   	push   %eax
80100098:	e8 33 44 00 00       	call   801044d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
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
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 e7 46 00 00       	call   801047d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 09 46 00 00       	call   80104770 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 43 00 00       	call   80104510 <acquiresleep>
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
801001a1:	68 6e 77 10 80       	push   $0x8010776e
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
801001be:	e8 ed 43 00 00       	call   801045b0 <holdingsleep>
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
801001dc:	68 7f 77 10 80       	push   $0x8010777f
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
801001ff:	e8 ac 43 00 00       	call   801045b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 43 00 00       	call   80104570 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 b0 45 00 00       	call   801047d0 <acquire>
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
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ff 44 00 00       	jmp    80104770 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 77 10 80       	push   $0x80107786
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
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 2b 45 00 00       	call   801047d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
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
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 9e 3f 00 00       	call   80104270 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 38 00 00       	call   80103b20 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 75 44 00 00       	call   80104770 <release>
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
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
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
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 1f 44 00 00       	call   80104770 <release>
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
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
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
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 02 27 00 00       	call   80102aa0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 77 10 80       	push   $0x8010778d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 db 80 10 80 	movl   $0x801080db,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 42 00 00       	call   80104620 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 77 10 80       	push   $0x801077a1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
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
8010041a:	e8 41 5c 00 00       	call   80106060 <uartputc>
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
80100505:	e8 56 5b 00 00       	call   80106060 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 4a 5b 00 00       	call   80106060 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 3e 5b 00 00       	call   80106060 <uartputc>
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
80100551:	e8 da 43 00 00       	call   80104930 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 25 43 00 00       	call   80104890 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 77 10 80       	push   $0x801077a5
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
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 20 42 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 87 41 00 00       	call   80104770 <release>
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
80100636:	0f b6 92 d0 77 10 80 	movzbl -0x7fef8830(%edx),%edx
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
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
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
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
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
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 e3 3f 00 00       	call   801047d0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
80100838:	bf b8 77 10 80       	mov    $0x801077b8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 10 3f 00 00       	call   80104770 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 77 10 80       	push   $0x801077bf
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
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 38 3f 00 00       	call   801047d0 <acquire>
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
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
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
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 9b 3d 00 00       	call   80104770 <release>
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
80100a0e:	e9 fd 39 00 00       	jmp    80104410 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
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
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 e7 38 00 00       	call   80104330 <wakeup>
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
80100a66:	68 c8 77 10 80       	push   $0x801077c8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 8b 3b 00 00       	call   80104600 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
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
80100abc:	e8 5f 30 00 00       	call   80103b20 <myproc>
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
80100b34:	e8 d7 68 00 00       	call   80107410 <setupkvm>
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
80100ba3:	e8 18 65 00 00       	call   801070c0 <allocuvm>
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
80100bd9:	e8 f2 63 00 00       	call   80106fd0 <loaduvm>
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
80100c1b:	e8 70 67 00 00       	call   80107390 <freevm>
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
80100c62:	e8 59 64 00 00       	call   801070c0 <allocuvm>
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
80100c83:	e8 28 68 00 00       	call   801074b0 <clearpteu>
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
80100cd3:	e8 b8 3d 00 00       	call   80104a90 <strlen>
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
80100ce7:	e8 a4 3d 00 00       	call   80104a90 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 83 69 00 00       	call   80107680 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 7a 66 00 00       	call   80107390 <freevm>
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
80100d63:	e8 18 69 00 00       	call   80107680 <copyout>
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
80100da1:	e8 aa 3c 00 00       	call   80104a50 <safestrcpy>
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
80100dcd:	e8 6e 60 00 00       	call   80106e40 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 b6 65 00 00       	call   80107390 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 97 21 00 00       	call   80102f80 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 e1 77 10 80       	push   $0x801077e1
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
80100e16:	68 ed 77 10 80       	push   $0x801077ed
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 db 37 00 00       	call   80104600 <initlock>
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
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 8a 39 00 00       	call   801047d0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
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
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 fa 38 00 00       	call   80104770 <release>
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
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 e1 38 00 00       	call   80104770 <release>
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
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 1c 39 00 00       	call   801047d0 <acquire>
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
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 9f 38 00 00       	call   80104770 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 f4 77 10 80       	push   $0x801077f4
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
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 ca 38 00 00       	call   801047d0 <acquire>
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
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 2f 38 00 00       	call   80104770 <release>

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
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 fd 37 00 00       	jmp    80104770 <release>
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
80100fa9:	e8 32 27 00 00       	call   801036e0 <pipeclose>
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
80100fbc:	68 fc 77 10 80       	push   $0x801077fc
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
8010108d:	e9 ee 27 00 00       	jmp    80103880 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 06 78 10 80       	push   $0x80107806
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
80101177:	68 0f 78 10 80       	push   $0x8010780f
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
801011a9:	e9 d2 25 00 00       	jmp    80103780 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 15 78 10 80       	push   $0x80107815
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
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
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
80101227:	68 1f 78 10 80       	push   $0x8010781f
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
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
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
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
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
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 32 78 10 80       	push   $0x80107832
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
80101325:	e8 66 35 00 00       	call   80104890 <memset>
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
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 61 34 00 00       	call   801047d0 <acquire>
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
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
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
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
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
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 94 33 00 00       	call   80104770 <release>

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
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 66 33 00 00       	call   80104770 <release>
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
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 48 78 10 80       	push   $0x80107848
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
80101515:	68 58 78 10 80       	push   $0x80107858
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
80101541:	e8 ea 33 00 00       	call   80104930 <memmove>
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
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 6b 78 10 80       	push   $0x8010786b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 85 30 00 00       	call   80104600 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 72 78 10 80       	push   $0x80107872
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 3c 2f 00 00       	call   801044d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
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
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 6f 33 00 00       	call   80104930 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 d8 78 10 80       	push   $0x801078d8
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
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
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
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
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
8010168e:	e8 fd 31 00 00       	call   80104890 <memset>
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
801016c3:	68 78 78 10 80       	push   $0x80107878
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
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
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
80101731:	e8 fa 31 00 00       	call   80104930 <memmove>
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
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 6c 30 00 00       	call   801047d0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 fc 2f 00 00       	call   80104770 <release>
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
801017a2:	e8 69 2d 00 00       	call   80104510 <acquiresleep>
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
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
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
80101818:	e8 13 31 00 00       	call   80104930 <memmove>
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
8010183d:	68 90 78 10 80       	push   $0x80107890
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 8a 78 10 80       	push   $0x8010788a
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
80101873:	e8 38 2d 00 00       	call   801045b0 <holdingsleep>
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
8010188f:	e9 dc 2c 00 00       	jmp    80104570 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 9f 78 10 80       	push   $0x8010789f
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
801018c0:	e8 4b 2c 00 00       	call   80104510 <acquiresleep>
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
801018da:	e8 91 2c 00 00       	call   80104570 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 e5 2e 00 00       	call   801047d0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 6b 2e 00 00       	jmp    80104770 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 bb 2e 00 00       	call   801047d0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 4c 2e 00 00       	call   80104770 <release>
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
80101a23:	e8 88 2b 00 00       	call   801045b0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 31 2b 00 00       	call   80104570 <releasesleep>
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
80101a53:	68 9f 78 10 80       	push   $0x8010789f
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
80101b37:	e8 f4 2d 00 00       	call   80104930 <memmove>
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
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
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
80101c33:	e8 f8 2c 00 00       	call   80104930 <memmove>
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
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
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
80101cce:	e8 cd 2c 00 00       	call   801049a0 <strncmp>
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
80101d2d:	e8 6e 2c 00 00       	call   801049a0 <strncmp>
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
80101d72:	68 b9 78 10 80       	push   $0x801078b9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 a7 78 10 80       	push   $0x801078a7
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
80101daa:	e8 71 1d 00 00       	call   80103b20 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 11 2a 00 00       	call   801047d0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 a1 29 00 00       	call   80104770 <release>
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
80101e27:	e8 04 2b 00 00       	call   80104930 <memmove>
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
80101e8c:	e8 1f 27 00 00       	call   801045b0 <holdingsleep>
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
80101eae:	e8 bd 26 00 00       	call   80104570 <releasesleep>
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
80101edb:	e8 50 2a 00 00       	call   80104930 <memmove>
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
80101f2b:	e8 80 26 00 00       	call   801045b0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 21 26 00 00       	call   80104570 <releasesleep>
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
80101f6d:	e8 3e 26 00 00       	call   801045b0 <holdingsleep>
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
80101f90:	e8 1b 26 00 00       	call   801045b0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 c4 25 00 00       	call   80104570 <releasesleep>
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
80101fcf:	68 9f 78 10 80       	push   $0x8010789f
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
8010203d:	e8 ae 29 00 00       	call   801049f0 <strncpy>
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
8010207b:	68 c8 78 10 80       	push   $0x801078c8
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 aa 7e 10 80       	push   $0x80107eaa
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
8010219b:	68 34 79 10 80       	push   $0x80107934
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 2b 79 10 80       	push   $0x8010792b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 46 79 10 80       	push   $0x80107946
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 2b 24 00 00       	call   80104600 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
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
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
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
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 7d 25 00 00       	call   801047d0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

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
801022ad:	e8 7e 20 00 00       	call   80104330 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 a0 24 00 00       	call   80104770 <release>

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
801022ee:	e8 bd 22 00 00       	call   801045b0 <holdingsleep>
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
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 a3 24 00 00       	call   801047d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
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
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
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
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 02 1f 00 00       	call   80104270 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 e5 23 00 00       	jmp    80104770 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 75 79 10 80       	push   $0x80107975
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 60 79 10 80       	push   $0x80107960
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 4a 79 10 80       	push   $0x8010794a
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
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
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
8010241a:	68 94 79 10 80       	push   $0x80107994
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
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
801024d2:	81 fb d0 65 11 80    	cmp    $0x801165d0,%ebx
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
801024f2:	e8 99 23 00 00       	call   80104890 <memset>

  if (kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if (kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
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
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 a3 22 00 00       	call   801047d0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 28 22 00 00       	jmp    80104770 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 c6 79 10 80       	push   $0x801079c6
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
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
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
8010261b:	68 cc 79 10 80       	push   $0x801079cc
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 d6 1f 00 00       	call   80104600 <initlock>
  p = (char *)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
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
801026aa:	e8 e1 21 00 00       	call   80104890 <memset>

  if (kmem.use_lock)
801026af:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801026b5:	83 c4 10             	add    $0x10,%esp
801026b8:	85 d2                	test   %edx,%edx
801026ba:	75 24                	jne    801026e0 <khugefree+0x60>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freehugelist;
801026bc:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801026c1:	89 03                	mov    %eax,(%ebx)
  kmem.freehugelist = r;
  if (kmem.use_lock)
801026c3:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freehugelist = r;
801026c8:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
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
801026e3:	68 40 26 11 80       	push   $0x80112640
801026e8:	e8 e3 20 00 00       	call   801047d0 <acquire>
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	eb ca                	jmp    801026bc <khugefree+0x3c>
801026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801026f8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801026ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102702:	c9                   	leave  
    release(&kmem.lock);
80102703:	e9 68 20 00 00       	jmp    80104770 <release>
    panic("khugefree");
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	68 d1 79 10 80       	push   $0x801079d1
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
801027c0:	a1 74 26 11 80       	mov    0x80112674,%eax
801027c5:	85 c0                	test   %eax,%eax
801027c7:	75 1f                	jne    801027e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027c9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if (r)
801027ce:	85 c0                	test   %eax,%eax
801027d0:	74 0e                	je     801027e0 <kalloc+0x20>
    kmem.freelist = r->next;
801027d2:	8b 10                	mov    (%eax),%edx
801027d4:	89 15 78 26 11 80    	mov    %edx,0x80112678
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
801027ee:	68 40 26 11 80       	push   $0x80112640
801027f3:	e8 d8 1f 00 00       	call   801047d0 <acquire>
  r = kmem.freelist;
801027f8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if (kmem.use_lock)
801027fd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if (r)
80102803:	83 c4 10             	add    $0x10,%esp
80102806:	85 c0                	test   %eax,%eax
80102808:	74 08                	je     80102812 <kalloc+0x52>
    kmem.freelist = r->next;
8010280a:	8b 08                	mov    (%eax),%ecx
8010280c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if (kmem.use_lock)
80102812:	85 d2                	test   %edx,%edx
80102814:	74 16                	je     8010282c <kalloc+0x6c>
    release(&kmem.lock);
80102816:	83 ec 0c             	sub    $0xc,%esp
80102819:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010281c:	68 40 26 11 80       	push   $0x80112640
80102821:	e8 4a 1f 00 00       	call   80104770 <release>
  return (char *)r;
80102826:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102829:	83 c4 10             	add    $0x10,%esp
}
8010282c:	c9                   	leave  
8010282d:	c3                   	ret    
8010282e:	66 90                	xchg   %ax,%ax

80102830 <khugealloc>:
char *
khugealloc(void)
{
  struct run *r;

  if (kmem.use_lock)
80102830:	a1 74 26 11 80       	mov    0x80112674,%eax
80102835:	85 c0                	test   %eax,%eax
80102837:	75 1f                	jne    80102858 <khugealloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freehugelist;
80102839:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  if (r)
8010283e:	85 c0                	test   %eax,%eax
80102840:	74 0e                	je     80102850 <khugealloc+0x20>
    kmem.freehugelist = r->next;
80102842:	8b 10                	mov    (%eax),%edx
80102844:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
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
8010285e:	68 40 26 11 80       	push   $0x80112640
80102863:	e8 68 1f 00 00       	call   801047d0 <acquire>
  r = kmem.freehugelist;
80102868:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  if (kmem.use_lock)
8010286d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if (r)
80102873:	83 c4 10             	add    $0x10,%esp
80102876:	85 c0                	test   %eax,%eax
80102878:	74 08                	je     80102882 <khugealloc+0x52>
    kmem.freehugelist = r->next;
8010287a:	8b 08                	mov    (%eax),%ecx
8010287c:	89 0d 7c 26 11 80    	mov    %ecx,0x8011267c
  if (kmem.use_lock)
80102882:	85 d2                	test   %edx,%edx
80102884:	74 16                	je     8010289c <khugealloc+0x6c>
    release(&kmem.lock);
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010288c:	68 40 26 11 80       	push   $0x80112640
80102891:	e8 da 1e 00 00       	call   80104770 <release>
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
801028b8:	8b 1d 80 26 11 80    	mov    0x80112680,%ebx
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
801028db:	0f b6 91 00 7b 10 80 	movzbl -0x7fef8500(%ecx),%edx
  shift ^= togglecode[data];
801028e2:	0f b6 81 00 7a 10 80 	movzbl -0x7fef8600(%ecx),%eax
  shift |= shiftcode[data];
801028e9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028eb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028ef:	89 15 80 26 11 80    	mov    %edx,0x80112680
  c = charcode[shift & (CTL | SHIFT)][data];
801028f5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028f8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028fb:	8b 04 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%eax
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
80102925:	89 1d 80 26 11 80    	mov    %ebx,0x80112680
}
8010292b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010292e:	c9                   	leave  
8010292f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102930:	83 e0 7f             	and    $0x7f,%eax
80102933:	85 d2                	test   %edx,%edx
80102935:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102938:	0f b6 81 00 7b 10 80 	movzbl -0x7fef8500(%ecx),%eax
8010293f:	83 c8 40             	or     $0x40,%eax
80102942:	0f b6 c0             	movzbl %al,%eax
80102945:	f7 d0                	not    %eax
80102947:	21 d8                	and    %ebx,%eax
}
80102949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010294c:	a3 80 26 11 80       	mov    %eax,0x80112680
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
801029a0:	a1 84 26 11 80       	mov    0x80112684,%eax
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
80102aa0:	a1 84 26 11 80       	mov    0x80112684,%eax
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
80102ac0:	a1 84 26 11 80       	mov    0x80112684,%eax
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
80102b2e:	a1 84 26 11 80       	mov    0x80112684,%eax
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
80102ca7:	e8 34 1c 00 00       	call   801048e0 <memcmp>
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
80102d70:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
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
80102d90:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102d95:	83 ec 08             	sub    $0x8,%esp
80102d98:	01 f8                	add    %edi,%eax
80102d9a:	83 c0 01             	add    $0x1,%eax
80102d9d:	50                   	push   %eax
80102d9e:	ff 35 e4 26 11 80    	push   0x801126e4
80102da4:	e8 27 d3 ff ff       	call   801000d0 <bread>
80102da9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dab:	58                   	pop    %eax
80102dac:	5a                   	pop    %edx
80102dad:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102db4:	ff 35 e4 26 11 80    	push   0x801126e4
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
80102dd4:	e8 57 1b 00 00       	call   80104930 <memmove>
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
80102df4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
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
80102e17:	ff 35 d4 26 11 80    	push   0x801126d4
80102e1d:	ff 35 e4 26 11 80    	push   0x801126e4
80102e23:	e8 a8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e28:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e2b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e2d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102e32:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e35:	85 c0                	test   %eax,%eax
80102e37:	7e 19                	jle    80102e52 <write_head+0x42>
80102e39:	31 d2                	xor    %edx,%edx
80102e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e3f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e40:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
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
80102e7a:	68 00 7c 10 80       	push   $0x80107c00
80102e7f:	68 a0 26 11 80       	push   $0x801126a0
80102e84:	e8 77 17 00 00       	call   80104600 <initlock>
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
80102e99:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102e9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ea2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102ea7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102ead:	5a                   	pop    %edx
80102eae:	50                   	push   %eax
80102eaf:	53                   	push   %ebx
80102eb0:	e8 1b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102eb5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102eb8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ebb:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102ec1:	85 db                	test   %ebx,%ebx
80102ec3:	7e 1d                	jle    80102ee2 <initlog+0x72>
80102ec5:	31 d2                	xor    %edx,%edx
80102ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ece:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ed0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ed4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
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
80102ef0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
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
80102f16:	68 a0 26 11 80       	push   $0x801126a0
80102f1b:	e8 b0 18 00 00       	call   801047d0 <acquire>
80102f20:	83 c4 10             	add    $0x10,%esp
80102f23:	eb 18                	jmp    80102f3d <begin_op+0x2d>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f28:	83 ec 08             	sub    $0x8,%esp
80102f2b:	68 a0 26 11 80       	push   $0x801126a0
80102f30:	68 a0 26 11 80       	push   $0x801126a0
80102f35:	e8 36 13 00 00       	call   80104270 <sleep>
80102f3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f3d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	75 e2                	jne    80102f28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f46:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f4b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
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
80102f62:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102f67:	68 a0 26 11 80       	push   $0x801126a0
80102f6c:	e8 ff 17 00 00       	call   80104770 <release>
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
80102f89:	68 a0 26 11 80       	push   $0x801126a0
80102f8e:	e8 3d 18 00 00       	call   801047d0 <acquire>
  log.outstanding -= 1;
80102f93:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102f98:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102f9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fa1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fa4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102faa:	85 f6                	test   %esi,%esi
80102fac:	0f 85 22 01 00 00    	jne    801030d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fb2:	85 db                	test   %ebx,%ebx
80102fb4:	0f 85 f6 00 00 00    	jne    801030b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fba:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102fc1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fc4:	83 ec 0c             	sub    $0xc,%esp
80102fc7:	68 a0 26 11 80       	push   $0x801126a0
80102fcc:	e8 9f 17 00 00       	call   80104770 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fd1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102fd7:	83 c4 10             	add    $0x10,%esp
80102fda:	85 c9                	test   %ecx,%ecx
80102fdc:	7f 42                	jg     80103020 <end_op+0xa0>
    acquire(&log.lock);
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 a0 26 11 80       	push   $0x801126a0
80102fe6:	e8 e5 17 00 00       	call   801047d0 <acquire>
    wakeup(&log);
80102feb:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102ff2:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102ff9:	00 00 00 
    wakeup(&log);
80102ffc:	e8 2f 13 00 00       	call   80104330 <wakeup>
    release(&log.lock);
80103001:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103008:	e8 63 17 00 00       	call   80104770 <release>
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
80103020:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80103025:	83 ec 08             	sub    $0x8,%esp
80103028:	01 d8                	add    %ebx,%eax
8010302a:	83 c0 01             	add    $0x1,%eax
8010302d:	50                   	push   %eax
8010302e:	ff 35 e4 26 11 80    	push   0x801126e4
80103034:	e8 97 d0 ff ff       	call   801000d0 <bread>
80103039:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303b:	58                   	pop    %eax
8010303c:	5a                   	pop    %edx
8010303d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80103044:	ff 35 e4 26 11 80    	push   0x801126e4
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
80103064:	e8 c7 18 00 00       	call   80104930 <memmove>
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
80103084:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
8010308a:	7c 94                	jl     80103020 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010308c:	e8 7f fd ff ff       	call   80102e10 <write_head>
    install_trans(); // Now install writes to home locations
80103091:	e8 da fc ff ff       	call   80102d70 <install_trans>
    log.lh.n = 0;
80103096:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
8010309d:	00 00 00 
    write_head();    // Erase the transaction from the log
801030a0:	e8 6b fd ff ff       	call   80102e10 <write_head>
801030a5:	e9 34 ff ff ff       	jmp    80102fde <end_op+0x5e>
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030b0:	83 ec 0c             	sub    $0xc,%esp
801030b3:	68 a0 26 11 80       	push   $0x801126a0
801030b8:	e8 73 12 00 00       	call   80104330 <wakeup>
  release(&log.lock);
801030bd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801030c4:	e8 a7 16 00 00       	call   80104770 <release>
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
801030d7:	68 04 7c 10 80       	push   $0x80107c04
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
801030f7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
801030fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103100:	83 fa 1d             	cmp    $0x1d,%edx
80103103:	0f 8f 85 00 00 00    	jg     8010318e <log_write+0x9e>
80103109:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010310e:	83 e8 01             	sub    $0x1,%eax
80103111:	39 c2                	cmp    %eax,%edx
80103113:	7d 79                	jge    8010318e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103115:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010311a:	85 c0                	test   %eax,%eax
8010311c:	7e 7d                	jle    8010319b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010311e:	83 ec 0c             	sub    $0xc,%esp
80103121:	68 a0 26 11 80       	push   $0x801126a0
80103126:	e8 a5 16 00 00       	call   801047d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010312b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
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
80103147:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010314e:	75 f0                	jne    80103140 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103150:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103157:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010315a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010315d:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103164:	c9                   	leave  
  release(&log.lock);
80103165:	e9 06 16 00 00       	jmp    80104770 <release>
8010316a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103170:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103177:	83 c2 01             	add    $0x1,%edx
8010317a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103180:	eb d5                	jmp    80103157 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103182:	8b 43 08             	mov    0x8(%ebx),%eax
80103185:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
8010318a:	75 cb                	jne    80103157 <log_write+0x67>
8010318c:	eb e9                	jmp    80103177 <log_write+0x87>
    panic("too big a transaction");
8010318e:	83 ec 0c             	sub    $0xc,%esp
80103191:	68 13 7c 10 80       	push   $0x80107c13
80103196:	e8 e5 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010319b:	83 ec 0c             	sub    $0xc,%esp
8010319e:	68 29 7c 10 80       	push   $0x80107c29
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
801031b7:	e8 44 09 00 00       	call   80103b00 <cpuid>
801031bc:	89 c3                	mov    %eax,%ebx
801031be:	e8 3d 09 00 00       	call   80103b00 <cpuid>
801031c3:	83 ec 04             	sub    $0x4,%esp
801031c6:	53                   	push   %ebx
801031c7:	50                   	push   %eax
801031c8:	68 44 7c 10 80       	push   $0x80107c44
801031cd:	e8 ce d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801031d2:	e8 b9 2a 00 00       	call   80105c90 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031d7:	e8 c4 08 00 00       	call   80103aa0 <mycpu>
801031dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031de:	b8 01 00 00 00       	mov    $0x1,%eax
801031e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ea:	e8 71 0c 00 00       	call   80103e60 <scheduler>
801031ef:	90                   	nop

801031f0 <mpenter>:
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031f6:	e8 35 3c 00 00       	call   80106e30 <switchkvm>
  seginit();
801031fb:	e8 a0 3b 00 00       	call   80106da0 <seginit>
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
80103227:	68 d0 65 11 80       	push   $0x801165d0
8010322c:	e8 df f3 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103231:	e8 5a 42 00 00       	call   80107490 <kvmalloc>
  mpinit();        // detect other processors
80103236:	e8 85 01 00 00       	call   801033c0 <mpinit>
  lapicinit();     // interrupt controller
8010323b:	e8 60 f7 ff ff       	call   801029a0 <lapicinit>
  seginit();       // segment descriptors
80103240:	e8 5b 3b 00 00       	call   80106da0 <seginit>
  picinit();       // disable pic
80103245:	e8 76 03 00 00       	call   801035c0 <picinit>
  ioapicinit();    // another interrupt controller
8010324a:	e8 81 f1 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010324f:	e8 0c d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103254:	e8 27 2d 00 00       	call   80105f80 <uartinit>
  pinit();         // process table
80103259:	e8 22 08 00 00       	call   80103a80 <pinit>
  tvinit();        // trap vectors
8010325e:	e8 ad 29 00 00       	call   80105c10 <tvinit>
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
8010327a:	68 8c b4 10 80       	push   $0x8010b48c
8010327f:	68 00 70 00 80       	push   $0x80007000
80103284:	e8 a7 16 00 00       	call   80104930 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103293:	00 00 00 
80103296:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010329b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801032a0:	76 7e                	jbe    80103320 <main+0x110>
801032a2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801032a7:	eb 20                	jmp    801032c9 <main+0xb9>
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032b0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801032b7:	00 00 00 
801032ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032c0:	05 a0 27 11 80       	add    $0x801127a0,%eax
801032c5:	39 c3                	cmp    %eax,%ebx
801032c7:	73 57                	jae    80103320 <main+0x110>
    if(c == mycpu())  // We've started already.
801032c9:	e8 d2 07 00 00       	call   80103aa0 <mycpu>
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
  userinit();      // first user process
80103332:	e8 19 08 00 00       	call   80103b50 <userinit>
  mpmain();        // finish this processor's setup
80103337:	e8 74 fe ff ff       	call   801031b0 <mpmain>
8010333c:	66 90                	xchg   %ax,%ax
8010333e:	66 90                	xchg   %ax,%ax

80103340 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103345:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010334b:	53                   	push   %ebx
  e = addr+len;
8010334c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010334f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103352:	39 de                	cmp    %ebx,%esi
80103354:	72 10                	jb     80103366 <mpsearch1+0x26>
80103356:	eb 50                	jmp    801033a8 <mpsearch1+0x68>
80103358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335f:	90                   	nop
80103360:	89 fe                	mov    %edi,%esi
80103362:	39 fb                	cmp    %edi,%ebx
80103364:	76 42                	jbe    801033a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103366:	83 ec 04             	sub    $0x4,%esp
80103369:	8d 7e 10             	lea    0x10(%esi),%edi
8010336c:	6a 04                	push   $0x4
8010336e:	68 58 7c 10 80       	push   $0x80107c58
80103373:	56                   	push   %esi
80103374:	e8 67 15 00 00       	call   801048e0 <memcmp>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	85 c0                	test   %eax,%eax
8010337e:	75 e0                	jne    80103360 <mpsearch1+0x20>
80103380:	89 f2                	mov    %esi,%edx
80103382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103388:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010338b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010338e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103390:	39 fa                	cmp    %edi,%edx
80103392:	75 f4                	jne    80103388 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103394:	84 c0                	test   %al,%al
80103396:	75 c8                	jne    80103360 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010339b:	89 f0                	mov    %esi,%eax
8010339d:	5b                   	pop    %ebx
8010339e:	5e                   	pop    %esi
8010339f:	5f                   	pop    %edi
801033a0:	5d                   	pop    %ebp
801033a1:	c3                   	ret    
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033ab:	31 f6                	xor    %esi,%esi
}
801033ad:	5b                   	pop    %ebx
801033ae:	89 f0                	mov    %esi,%eax
801033b0:	5e                   	pop    %esi
801033b1:	5f                   	pop    %edi
801033b2:	5d                   	pop    %ebp
801033b3:	c3                   	ret    
801033b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033bf:	90                   	nop

801033c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033d7:	c1 e0 08             	shl    $0x8,%eax
801033da:	09 d0                	or     %edx,%eax
801033dc:	c1 e0 04             	shl    $0x4,%eax
801033df:	75 1b                	jne    801033fc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033e1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033e8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033ef:	c1 e0 08             	shl    $0x8,%eax
801033f2:	09 d0                	or     %edx,%eax
801033f4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033f7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033fc:	ba 00 04 00 00       	mov    $0x400,%edx
80103401:	e8 3a ff ff ff       	call   80103340 <mpsearch1>
80103406:	89 c3                	mov    %eax,%ebx
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 84 40 01 00 00    	je     80103550 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103410:	8b 73 04             	mov    0x4(%ebx),%esi
80103413:	85 f6                	test   %esi,%esi
80103415:	0f 84 25 01 00 00    	je     80103540 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010341b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010341e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103424:	6a 04                	push   $0x4
80103426:	68 5d 7c 10 80       	push   $0x80107c5d
8010342b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010342c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010342f:	e8 ac 14 00 00       	call   801048e0 <memcmp>
80103434:	83 c4 10             	add    $0x10,%esp
80103437:	85 c0                	test   %eax,%eax
80103439:	0f 85 01 01 00 00    	jne    80103540 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010343f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103446:	3c 01                	cmp    $0x1,%al
80103448:	74 08                	je     80103452 <mpinit+0x92>
8010344a:	3c 04                	cmp    $0x4,%al
8010344c:	0f 85 ee 00 00 00    	jne    80103540 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103452:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103459:	66 85 d2             	test   %dx,%dx
8010345c:	74 22                	je     80103480 <mpinit+0xc0>
8010345e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103461:	89 f0                	mov    %esi,%eax
  sum = 0;
80103463:	31 d2                	xor    %edx,%edx
80103465:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103468:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010346f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103472:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103474:	39 c7                	cmp    %eax,%edi
80103476:	75 f0                	jne    80103468 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103478:	84 d2                	test   %dl,%dl
8010347a:	0f 85 c0 00 00 00    	jne    80103540 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103480:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103486:	a3 84 26 11 80       	mov    %eax,0x80112684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010348b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103492:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103498:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010349d:	03 55 e4             	add    -0x1c(%ebp),%edx
801034a0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034a7:	90                   	nop
801034a8:	39 d0                	cmp    %edx,%eax
801034aa:	73 15                	jae    801034c1 <mpinit+0x101>
    switch(*p){
801034ac:	0f b6 08             	movzbl (%eax),%ecx
801034af:	80 f9 02             	cmp    $0x2,%cl
801034b2:	74 4c                	je     80103500 <mpinit+0x140>
801034b4:	77 3a                	ja     801034f0 <mpinit+0x130>
801034b6:	84 c9                	test   %cl,%cl
801034b8:	74 56                	je     80103510 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034ba:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034bd:	39 d0                	cmp    %edx,%eax
801034bf:	72 eb                	jb     801034ac <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034c4:	85 f6                	test   %esi,%esi
801034c6:	0f 84 d9 00 00 00    	je     801035a5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034cc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034d0:	74 15                	je     801034e7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d2:	b8 70 00 00 00       	mov    $0x70,%eax
801034d7:	ba 22 00 00 00       	mov    $0x22,%edx
801034dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034dd:	ba 23 00 00 00       	mov    $0x23,%edx
801034e2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034e3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e6:	ee                   	out    %al,(%dx)
  }
}
801034e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034ea:	5b                   	pop    %ebx
801034eb:	5e                   	pop    %esi
801034ec:	5f                   	pop    %edi
801034ed:	5d                   	pop    %ebp
801034ee:	c3                   	ret    
801034ef:	90                   	nop
    switch(*p){
801034f0:	83 e9 03             	sub    $0x3,%ecx
801034f3:	80 f9 01             	cmp    $0x1,%cl
801034f6:	76 c2                	jbe    801034ba <mpinit+0xfa>
801034f8:	31 f6                	xor    %esi,%esi
801034fa:	eb ac                	jmp    801034a8 <mpinit+0xe8>
801034fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103500:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103504:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103507:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010350d:	eb 99                	jmp    801034a8 <mpinit+0xe8>
8010350f:	90                   	nop
      if(ncpu < NCPU) {
80103510:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103516:	83 f9 07             	cmp    $0x7,%ecx
80103519:	7f 19                	jg     80103534 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010351b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103521:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103525:	83 c1 01             	add    $0x1,%ecx
80103528:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010352e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103534:	83 c0 14             	add    $0x14,%eax
      continue;
80103537:	e9 6c ff ff ff       	jmp    801034a8 <mpinit+0xe8>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103540:	83 ec 0c             	sub    $0xc,%esp
80103543:	68 62 7c 10 80       	push   $0x80107c62
80103548:	e8 33 ce ff ff       	call   80100380 <panic>
8010354d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103550:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103555:	eb 13                	jmp    8010356a <mpinit+0x1aa>
80103557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103560:	89 f3                	mov    %esi,%ebx
80103562:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103568:	74 d6                	je     80103540 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010356a:	83 ec 04             	sub    $0x4,%esp
8010356d:	8d 73 10             	lea    0x10(%ebx),%esi
80103570:	6a 04                	push   $0x4
80103572:	68 58 7c 10 80       	push   $0x80107c58
80103577:	53                   	push   %ebx
80103578:	e8 63 13 00 00       	call   801048e0 <memcmp>
8010357d:	83 c4 10             	add    $0x10,%esp
80103580:	85 c0                	test   %eax,%eax
80103582:	75 dc                	jne    80103560 <mpinit+0x1a0>
80103584:	89 da                	mov    %ebx,%edx
80103586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010358d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103590:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103593:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103596:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103598:	39 d6                	cmp    %edx,%esi
8010359a:	75 f4                	jne    80103590 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010359c:	84 c0                	test   %al,%al
8010359e:	75 c0                	jne    80103560 <mpinit+0x1a0>
801035a0:	e9 6b fe ff ff       	jmp    80103410 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035a5:	83 ec 0c             	sub    $0xc,%esp
801035a8:	68 7c 7c 10 80       	push   $0x80107c7c
801035ad:	e8 ce cd ff ff       	call   80100380 <panic>
801035b2:	66 90                	xchg   %ax,%ax
801035b4:	66 90                	xchg   %ax,%ax
801035b6:	66 90                	xchg   %ax,%ax
801035b8:	66 90                	xchg   %ax,%ax
801035ba:	66 90                	xchg   %ax,%ax
801035bc:	66 90                	xchg   %ax,%ax
801035be:	66 90                	xchg   %ax,%ax

801035c0 <picinit>:
801035c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035c5:	ba 21 00 00 00       	mov    $0x21,%edx
801035ca:	ee                   	out    %al,(%dx)
801035cb:	ba a1 00 00 00       	mov    $0xa1,%edx
801035d0:	ee                   	out    %al,(%dx)
801035d1:	c3                   	ret    
801035d2:	66 90                	xchg   %ax,%ax
801035d4:	66 90                	xchg   %ax,%ax
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035fb:	e8 30 d8 ff ff       	call   80100e30 <filealloc>
80103600:	89 03                	mov    %eax,(%ebx)
80103602:	85 c0                	test   %eax,%eax
80103604:	0f 84 a8 00 00 00    	je     801036b2 <pipealloc+0xd2>
8010360a:	e8 21 d8 ff ff       	call   80100e30 <filealloc>
8010360f:	89 06                	mov    %eax,(%esi)
80103611:	85 c0                	test   %eax,%eax
80103613:	0f 84 87 00 00 00    	je     801036a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103619:	e8 a2 f1 ff ff       	call   801027c0 <kalloc>
8010361e:	89 c7                	mov    %eax,%edi
80103620:	85 c0                	test   %eax,%eax
80103622:	0f 84 b0 00 00 00    	je     801036d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103628:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010362f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103632:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103635:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010363c:	00 00 00 
  p->nwrite = 0;
8010363f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103646:	00 00 00 
  p->nread = 0;
80103649:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103650:	00 00 00 
  initlock(&p->lock, "pipe");
80103653:	68 9b 7c 10 80       	push   $0x80107c9b
80103658:	50                   	push   %eax
80103659:	e8 a2 0f 00 00       	call   80104600 <initlock>
  (*f0)->type = FD_PIPE;
8010365e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103660:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103663:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103669:	8b 03                	mov    (%ebx),%eax
8010366b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010366f:	8b 03                	mov    (%ebx),%eax
80103671:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103675:	8b 03                	mov    (%ebx),%eax
80103677:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010367a:	8b 06                	mov    (%esi),%eax
8010367c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103682:	8b 06                	mov    (%esi),%eax
80103684:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103688:	8b 06                	mov    (%esi),%eax
8010368a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010368e:	8b 06                	mov    (%esi),%eax
80103690:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103693:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103696:	31 c0                	xor    %eax,%eax
}
80103698:	5b                   	pop    %ebx
80103699:	5e                   	pop    %esi
8010369a:	5f                   	pop    %edi
8010369b:	5d                   	pop    %ebp
8010369c:	c3                   	ret    
8010369d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801036a0:	8b 03                	mov    (%ebx),%eax
801036a2:	85 c0                	test   %eax,%eax
801036a4:	74 1e                	je     801036c4 <pipealloc+0xe4>
    fileclose(*f0);
801036a6:	83 ec 0c             	sub    $0xc,%esp
801036a9:	50                   	push   %eax
801036aa:	e8 41 d8 ff ff       	call   80100ef0 <fileclose>
801036af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036b2:	8b 06                	mov    (%esi),%eax
801036b4:	85 c0                	test   %eax,%eax
801036b6:	74 0c                	je     801036c4 <pipealloc+0xe4>
    fileclose(*f1);
801036b8:	83 ec 0c             	sub    $0xc,%esp
801036bb:	50                   	push   %eax
801036bc:	e8 2f d8 ff ff       	call   80100ef0 <fileclose>
801036c1:	83 c4 10             	add    $0x10,%esp
}
801036c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036cc:	5b                   	pop    %ebx
801036cd:	5e                   	pop    %esi
801036ce:	5f                   	pop    %edi
801036cf:	5d                   	pop    %ebp
801036d0:	c3                   	ret    
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801036d8:	8b 03                	mov    (%ebx),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	75 c8                	jne    801036a6 <pipealloc+0xc6>
801036de:	eb d2                	jmp    801036b2 <pipealloc+0xd2>

801036e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036eb:	83 ec 0c             	sub    $0xc,%esp
801036ee:	53                   	push   %ebx
801036ef:	e8 dc 10 00 00       	call   801047d0 <acquire>
  if(writable){
801036f4:	83 c4 10             	add    $0x10,%esp
801036f7:	85 f6                	test   %esi,%esi
801036f9:	74 65                	je     80103760 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103704:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010370b:	00 00 00 
    wakeup(&p->nread);
8010370e:	50                   	push   %eax
8010370f:	e8 1c 0c 00 00       	call   80104330 <wakeup>
80103714:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103717:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010371d:	85 d2                	test   %edx,%edx
8010371f:	75 0a                	jne    8010372b <pipeclose+0x4b>
80103721:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	74 15                	je     80103740 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010372b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010372e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103731:	5b                   	pop    %ebx
80103732:	5e                   	pop    %esi
80103733:	5d                   	pop    %ebp
    release(&p->lock);
80103734:	e9 37 10 00 00       	jmp    80104770 <release>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	53                   	push   %ebx
80103744:	e8 27 10 00 00       	call   80104770 <release>
    kfree((char*)p);
80103749:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010374c:	83 c4 10             	add    $0x10,%esp
}
8010374f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103752:	5b                   	pop    %ebx
80103753:	5e                   	pop    %esi
80103754:	5d                   	pop    %ebp
    kfree((char*)p);
80103755:	e9 66 ed ff ff       	jmp    801024c0 <kfree>
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103769:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103770:	00 00 00 
    wakeup(&p->nwrite);
80103773:	50                   	push   %eax
80103774:	e8 b7 0b 00 00       	call   80104330 <wakeup>
80103779:	83 c4 10             	add    $0x10,%esp
8010377c:	eb 99                	jmp    80103717 <pipeclose+0x37>
8010377e:	66 90                	xchg   %ax,%ax

80103780 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 28             	sub    $0x28,%esp
80103789:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010378c:	53                   	push   %ebx
8010378d:	e8 3e 10 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++){
80103792:	8b 45 10             	mov    0x10(%ebp),%eax
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 c0                	test   %eax,%eax
8010379a:	0f 8e c0 00 00 00    	jle    80103860 <pipewrite+0xe0>
801037a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037b2:	03 45 10             	add    0x10(%ebp),%eax
801037b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037b8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037be:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c4:	89 ca                	mov    %ecx,%edx
801037c6:	05 00 02 00 00       	add    $0x200,%eax
801037cb:	39 c1                	cmp    %eax,%ecx
801037cd:	74 3f                	je     8010380e <pipewrite+0x8e>
801037cf:	eb 67                	jmp    80103838 <pipewrite+0xb8>
801037d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801037d8:	e8 43 03 00 00       	call   80103b20 <myproc>
801037dd:	8b 48 28             	mov    0x28(%eax),%ecx
801037e0:	85 c9                	test   %ecx,%ecx
801037e2:	75 34                	jne    80103818 <pipewrite+0x98>
      wakeup(&p->nread);
801037e4:	83 ec 0c             	sub    $0xc,%esp
801037e7:	57                   	push   %edi
801037e8:	e8 43 0b 00 00       	call   80104330 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037ed:	58                   	pop    %eax
801037ee:	5a                   	pop    %edx
801037ef:	53                   	push   %ebx
801037f0:	56                   	push   %esi
801037f1:	e8 7a 0a 00 00       	call   80104270 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037fc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103802:	83 c4 10             	add    $0x10,%esp
80103805:	05 00 02 00 00       	add    $0x200,%eax
8010380a:	39 c2                	cmp    %eax,%edx
8010380c:	75 2a                	jne    80103838 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010380e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103814:	85 c0                	test   %eax,%eax
80103816:	75 c0                	jne    801037d8 <pipewrite+0x58>
        release(&p->lock);
80103818:	83 ec 0c             	sub    $0xc,%esp
8010381b:	53                   	push   %ebx
8010381c:	e8 4f 0f 00 00       	call   80104770 <release>
        return -1;
80103821:	83 c4 10             	add    $0x10,%esp
80103824:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010382c:	5b                   	pop    %ebx
8010382d:	5e                   	pop    %esi
8010382e:	5f                   	pop    %edi
8010382f:	5d                   	pop    %ebp
80103830:	c3                   	ret    
80103831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103838:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010383b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010383e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103844:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010384a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010384d:	83 c6 01             	add    $0x1,%esi
80103850:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103853:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103857:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010385a:	0f 85 58 ff ff ff    	jne    801037b8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103860:	83 ec 0c             	sub    $0xc,%esp
80103863:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103869:	50                   	push   %eax
8010386a:	e8 c1 0a 00 00       	call   80104330 <wakeup>
  release(&p->lock);
8010386f:	89 1c 24             	mov    %ebx,(%esp)
80103872:	e8 f9 0e 00 00       	call   80104770 <release>
  return n;
80103877:	8b 45 10             	mov    0x10(%ebp),%eax
8010387a:	83 c4 10             	add    $0x10,%esp
8010387d:	eb aa                	jmp    80103829 <pipewrite+0xa9>
8010387f:	90                   	nop

80103880 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 18             	sub    $0x18,%esp
80103889:	8b 75 08             	mov    0x8(%ebp),%esi
8010388c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010388f:	56                   	push   %esi
80103890:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103896:	e8 35 0f 00 00       	call   801047d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010389b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038a1:	83 c4 10             	add    $0x10,%esp
801038a4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038aa:	74 2f                	je     801038db <piperead+0x5b>
801038ac:	eb 37                	jmp    801038e5 <piperead+0x65>
801038ae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038b0:	e8 6b 02 00 00       	call   80103b20 <myproc>
801038b5:	8b 48 28             	mov    0x28(%eax),%ecx
801038b8:	85 c9                	test   %ecx,%ecx
801038ba:	0f 85 80 00 00 00    	jne    80103940 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038c0:	83 ec 08             	sub    $0x8,%esp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
801038c5:	e8 a6 09 00 00       	call   80104270 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ca:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801038d9:	75 0a                	jne    801038e5 <piperead+0x65>
801038db:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801038e1:	85 c0                	test   %eax,%eax
801038e3:	75 cb                	jne    801038b0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e5:	8b 55 10             	mov    0x10(%ebp),%edx
801038e8:	31 db                	xor    %ebx,%ebx
801038ea:	85 d2                	test   %edx,%edx
801038ec:	7f 20                	jg     8010390e <piperead+0x8e>
801038ee:	eb 2c                	jmp    8010391c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038f0:	8d 48 01             	lea    0x1(%eax),%ecx
801038f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801038f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801038fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103903:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103906:	83 c3 01             	add    $0x1,%ebx
80103909:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010390c:	74 0e                	je     8010391c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010390e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103914:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010391a:	75 d4                	jne    801038f0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010391c:	83 ec 0c             	sub    $0xc,%esp
8010391f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103925:	50                   	push   %eax
80103926:	e8 05 0a 00 00       	call   80104330 <wakeup>
  release(&p->lock);
8010392b:	89 34 24             	mov    %esi,(%esp)
8010392e:	e8 3d 0e 00 00       	call   80104770 <release>
  return i;
80103933:	83 c4 10             	add    $0x10,%esp
}
80103936:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103939:	89 d8                	mov    %ebx,%eax
8010393b:	5b                   	pop    %ebx
8010393c:	5e                   	pop    %esi
8010393d:	5f                   	pop    %edi
8010393e:	5d                   	pop    %ebp
8010393f:	c3                   	ret    
      release(&p->lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103943:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103948:	56                   	push   %esi
80103949:	e8 22 0e 00 00       	call   80104770 <release>
      return -1;
8010394e:	83 c4 10             	add    $0x10,%esp
}
80103951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103954:	89 d8                	mov    %ebx,%eax
80103956:	5b                   	pop    %ebx
80103957:	5e                   	pop    %esi
80103958:	5f                   	pop    %edi
80103959:	5d                   	pop    %ebp
8010395a:	c3                   	ret    
8010395b:	66 90                	xchg   %ax,%ax
8010395d:	66 90                	xchg   %ax,%ax
8010395f:	90                   	nop

80103960 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103964:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103969:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010396c:	68 20 2d 11 80       	push   $0x80112d20
80103971:	e8 5a 0e 00 00       	call   801047d0 <acquire>
80103976:	83 c4 10             	add    $0x10,%esp
80103979:	eb 10                	jmp    8010398b <allocproc+0x2b>
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103980:	83 eb 80             	sub    $0xffffff80,%ebx
80103983:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103989:	74 75                	je     80103a00 <allocproc+0xa0>
    if(p->state == UNUSED)
8010398b:	8b 43 10             	mov    0x10(%ebx),%eax
8010398e:	85 c0                	test   %eax,%eax
80103990:	75 ee                	jne    80103980 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103992:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103997:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010399a:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039a1:	89 43 14             	mov    %eax,0x14(%ebx)
801039a4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039a7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801039ac:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039b2:	e8 b9 0d 00 00       	call   80104770 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039b7:	e8 04 ee ff ff       	call   801027c0 <kalloc>
801039bc:	83 c4 10             	add    $0x10,%esp
801039bf:	89 43 0c             	mov    %eax,0xc(%ebx)
801039c2:	85 c0                	test   %eax,%eax
801039c4:	74 53                	je     80103a19 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039c6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039cc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039cf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039d4:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
801039d7:	c7 40 14 00 5c 10 80 	movl   $0x80105c00,0x14(%eax)
  p->context = (struct context*)sp;
801039de:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039e1:	6a 14                	push   $0x14
801039e3:	6a 00                	push   $0x0
801039e5:	50                   	push   %eax
801039e6:	e8 a5 0e 00 00       	call   80104890 <memset>
  p->context->eip = (uint)forkret;
801039eb:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
801039ee:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039f1:	c7 40 10 30 3a 10 80 	movl   $0x80103a30,0x10(%eax)
}
801039f8:	89 d8                	mov    %ebx,%eax
801039fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039fd:	c9                   	leave  
801039fe:	c3                   	ret    
801039ff:	90                   	nop
  release(&ptable.lock);
80103a00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a03:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a05:	68 20 2d 11 80       	push   $0x80112d20
80103a0a:	e8 61 0d 00 00       	call   80104770 <release>
}
80103a0f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a11:	83 c4 10             	add    $0x10,%esp
}
80103a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a17:	c9                   	leave  
80103a18:	c3                   	ret    
    p->state = UNUSED;
80103a19:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103a20:	31 db                	xor    %ebx,%ebx
}
80103a22:	89 d8                	mov    %ebx,%eax
80103a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a27:	c9                   	leave  
80103a28:	c3                   	ret    
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a36:	68 20 2d 11 80       	push   $0x80112d20
80103a3b:	e8 30 0d 00 00       	call   80104770 <release>

  if (first) {
80103a40:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	85 c0                	test   %eax,%eax
80103a4a:	75 04                	jne    80103a50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a4c:	c9                   	leave  
80103a4d:	c3                   	ret    
80103a4e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a50:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a57:	00 00 00 
    iinit(ROOTDEV);
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	6a 01                	push   $0x1
80103a5f:	e8 fc da ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a6b:	e8 00 f4 ff ff       	call   80102e70 <initlog>
}
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	c9                   	leave  
80103a74:	c3                   	ret    
80103a75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a80 <pinit>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a86:	68 a0 7c 10 80       	push   $0x80107ca0
80103a8b:	68 20 2d 11 80       	push   $0x80112d20
80103a90:	e8 6b 0b 00 00       	call   80104600 <initlock>
}
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	c9                   	leave  
80103a99:	c3                   	ret    
80103a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103aa0 <mycpu>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aa5:	9c                   	pushf  
80103aa6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103aa7:	f6 c4 02             	test   $0x2,%ah
80103aaa:	75 46                	jne    80103af2 <mycpu+0x52>
  apicid = lapicid();
80103aac:	e8 ef ef ff ff       	call   80102aa0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ab1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103ab7:	85 f6                	test   %esi,%esi
80103ab9:	7e 2a                	jle    80103ae5 <mycpu+0x45>
80103abb:	31 d2                	xor    %edx,%edx
80103abd:	eb 08                	jmp    80103ac7 <mycpu+0x27>
80103abf:	90                   	nop
80103ac0:	83 c2 01             	add    $0x1,%edx
80103ac3:	39 f2                	cmp    %esi,%edx
80103ac5:	74 1e                	je     80103ae5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ac7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103acd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103ad4:	39 c3                	cmp    %eax,%ebx
80103ad6:	75 e8                	jne    80103ac0 <mycpu+0x20>
}
80103ad8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103adb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103ae1:	5b                   	pop    %ebx
80103ae2:	5e                   	pop    %esi
80103ae3:	5d                   	pop    %ebp
80103ae4:	c3                   	ret    
  panic("unknown apicid\n");
80103ae5:	83 ec 0c             	sub    $0xc,%esp
80103ae8:	68 a7 7c 10 80       	push   $0x80107ca7
80103aed:	e8 8e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103af2:	83 ec 0c             	sub    $0xc,%esp
80103af5:	68 84 7d 10 80       	push   $0x80107d84
80103afa:	e8 81 c8 ff ff       	call   80100380 <panic>
80103aff:	90                   	nop

80103b00 <cpuid>:
cpuid() {
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b06:	e8 95 ff ff ff       	call   80103aa0 <mycpu>
}
80103b0b:	c9                   	leave  
  return mycpu()-cpus;
80103b0c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103b11:	c1 f8 04             	sar    $0x4,%eax
80103b14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b1a:	c3                   	ret    
80103b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <myproc>:
myproc(void) {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b27:	e8 54 0b 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103b2c:	e8 6f ff ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103b31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b37:	e8 94 0b 00 00       	call   801046d0 <popcli>
}
80103b3c:	89 d8                	mov    %ebx,%eax
80103b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b41:	c9                   	leave  
80103b42:	c3                   	ret    
80103b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b50 <userinit>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b57:	e8 04 fe ff ff       	call   80103960 <allocproc>
80103b5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b5e:	a3 54 4d 11 80       	mov    %eax,0x80114d54
  if((p->pgdir = setupkvm()) == 0)
80103b63:	e8 a8 38 00 00       	call   80107410 <setupkvm>
80103b68:	89 43 08             	mov    %eax,0x8(%ebx)
80103b6b:	85 c0                	test   %eax,%eax
80103b6d:	0f 84 bd 00 00 00    	je     80103c30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b73:	83 ec 04             	sub    $0x4,%esp
80103b76:	68 2c 00 00 00       	push   $0x2c
80103b7b:	68 60 b4 10 80       	push   $0x8010b460
80103b80:	50                   	push   %eax
80103b81:	e8 ca 33 00 00       	call   80106f50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b8f:	6a 4c                	push   $0x4c
80103b91:	6a 00                	push   $0x0
80103b93:	ff 73 1c             	push   0x1c(%ebx)
80103b96:	e8 f5 0c 00 00       	call   80104890 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b9b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103b9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ba3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ba6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103baf:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bb6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bbd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bc1:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bc8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bcc:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bcf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bd6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103be0:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bea:	8d 43 70             	lea    0x70(%ebx),%eax
80103bed:	6a 10                	push   $0x10
80103bef:	68 d0 7c 10 80       	push   $0x80107cd0
80103bf4:	50                   	push   %eax
80103bf5:	e8 56 0e 00 00       	call   80104a50 <safestrcpy>
  p->cwd = namei("/");
80103bfa:	c7 04 24 d9 7c 10 80 	movl   $0x80107cd9,(%esp)
80103c01:	e8 9a e4 ff ff       	call   801020a0 <namei>
80103c06:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c09:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c10:	e8 bb 0b 00 00       	call   801047d0 <acquire>
  p->state = RUNNABLE;
80103c15:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c1c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c23:	e8 48 0b 00 00       	call   80104770 <release>
}
80103c28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c2b:	83 c4 10             	add    $0x10,%esp
80103c2e:	c9                   	leave  
80103c2f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	68 b7 7c 10 80       	push   $0x80107cb7
80103c38:	e8 43 c7 ff ff       	call   80100380 <panic>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi

80103c40 <growproc>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
80103c45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c48:	e8 33 0a 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103c4d:	e8 4e fe ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103c52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c58:	e8 73 0a 00 00       	call   801046d0 <popcli>
  sz = curproc->sz;
80103c5d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c5f:	85 f6                	test   %esi,%esi
80103c61:	7f 1d                	jg     80103c80 <growproc+0x40>
  } else if(n < 0){
80103c63:	75 3b                	jne    80103ca0 <growproc+0x60>
  switchuvm(curproc);
80103c65:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c68:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c6a:	53                   	push   %ebx
80103c6b:	e8 d0 31 00 00       	call   80106e40 <switchuvm>
  return 0;
80103c70:	83 c4 10             	add    $0x10,%esp
80103c73:	31 c0                	xor    %eax,%eax
}
80103c75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c78:	5b                   	pop    %ebx
80103c79:	5e                   	pop    %esi
80103c7a:	5d                   	pop    %ebp
80103c7b:	c3                   	ret    
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c80:	83 ec 04             	sub    $0x4,%esp
80103c83:	01 c6                	add    %eax,%esi
80103c85:	56                   	push   %esi
80103c86:	50                   	push   %eax
80103c87:	ff 73 08             	push   0x8(%ebx)
80103c8a:	e8 31 34 00 00       	call   801070c0 <allocuvm>
80103c8f:	83 c4 10             	add    $0x10,%esp
80103c92:	85 c0                	test   %eax,%eax
80103c94:	75 cf                	jne    80103c65 <growproc+0x25>
      return -1;
80103c96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c9b:	eb d8                	jmp    80103c75 <growproc+0x35>
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca0:	83 ec 04             	sub    $0x4,%esp
80103ca3:	01 c6                	add    %eax,%esi
80103ca5:	56                   	push   %esi
80103ca6:	50                   	push   %eax
80103ca7:	ff 73 08             	push   0x8(%ebx)
80103caa:	e8 81 36 00 00       	call   80107330 <deallocuvm>
80103caf:	83 c4 10             	add    $0x10,%esp
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	75 af                	jne    80103c65 <growproc+0x25>
80103cb6:	eb de                	jmp    80103c96 <growproc+0x56>
80103cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbf:	90                   	nop

80103cc0 <growhugeproc>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
80103cc5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cc8:	e8 b3 09 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103ccd:	e8 ce fd ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103cd2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd8:	e8 f3 09 00 00       	call   801046d0 <popcli>
  sz = curproc->hugesz;
80103cdd:	8b 43 04             	mov    0x4(%ebx),%eax
  if(n > 0){
80103ce0:	85 f6                	test   %esi,%esi
80103ce2:	7f 1c                	jg     80103d00 <growhugeproc+0x40>
  } else if(n < 0){
80103ce4:	75 3a                	jne    80103d20 <growhugeproc+0x60>
  switchuvm(curproc);
80103ce6:	83 ec 0c             	sub    $0xc,%esp
  curproc->hugesz = sz;
80103ce9:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103cec:	53                   	push   %ebx
80103ced:	e8 4e 31 00 00       	call   80106e40 <switchuvm>
  return 0;
80103cf2:	83 c4 10             	add    $0x10,%esp
80103cf5:	31 c0                	xor    %eax,%eax
}
80103cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cfa:	5b                   	pop    %ebx
80103cfb:	5e                   	pop    %esi
80103cfc:	5d                   	pop    %ebp
80103cfd:	c3                   	ret    
80103cfe:	66 90                	xchg   %ax,%ax
    if((sz = allochugeuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	83 ec 04             	sub    $0x4,%esp
80103d03:	01 c6                	add    %eax,%esi
80103d05:	56                   	push   %esi
80103d06:	50                   	push   %eax
80103d07:	ff 73 08             	push   0x8(%ebx)
80103d0a:	e8 e1 34 00 00       	call   801071f0 <allochugeuvm>
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	85 c0                	test   %eax,%eax
80103d14:	75 d0                	jne    80103ce6 <growhugeproc+0x26>
      return -1;
80103d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1b:	eb da                	jmp    80103cf7 <growhugeproc+0x37>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallochugeuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 08             	push   0x8(%ebx)
80103d2a:	e8 31 36 00 00       	call   80107360 <deallochugeuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 b0                	jne    80103ce6 <growhugeproc+0x26>
80103d36:	eb de                	jmp    80103d16 <growhugeproc+0x56>
80103d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop

80103d40 <fork>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d49:	e8 32 09 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103d4e:	e8 4d fd ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103d53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d59:	e8 72 09 00 00       	call   801046d0 <popcli>
  if((np = allocproc()) == 0){
80103d5e:	e8 fd fb ff ff       	call   80103960 <allocproc>
80103d63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d66:	85 c0                	test   %eax,%eax
80103d68:	0f 84 b7 00 00 00    	je     80103e25 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d6e:	83 ec 08             	sub    $0x8,%esp
80103d71:	ff 33                	push   (%ebx)
80103d73:	89 c7                	mov    %eax,%edi
80103d75:	ff 73 08             	push   0x8(%ebx)
80103d78:	e8 83 37 00 00       	call   80107500 <copyuvm>
80103d7d:	83 c4 10             	add    $0x10,%esp
80103d80:	89 47 08             	mov    %eax,0x8(%edi)
80103d83:	85 c0                	test   %eax,%eax
80103d85:	0f 84 a1 00 00 00    	je     80103e2c <fork+0xec>
  np->sz = curproc->sz;
80103d8b:	8b 03                	mov    (%ebx),%eax
80103d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d90:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d92:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103d95:	89 c8                	mov    %ecx,%eax
80103d97:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103d9a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d9f:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103da2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103da4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103da6:	8b 40 1c             	mov    0x1c(%eax),%eax
80103da9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103db0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103db4:	85 c0                	test   %eax,%eax
80103db6:	74 13                	je     80103dcb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103db8:	83 ec 0c             	sub    $0xc,%esp
80103dbb:	50                   	push   %eax
80103dbc:	e8 df d0 ff ff       	call   80100ea0 <filedup>
80103dc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dc4:	83 c4 10             	add    $0x10,%esp
80103dc7:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dcb:	83 c6 01             	add    $0x1,%esi
80103dce:	83 fe 10             	cmp    $0x10,%esi
80103dd1:	75 dd                	jne    80103db0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103dd3:	83 ec 0c             	sub    $0xc,%esp
80103dd6:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dd9:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103ddc:	e8 6f d9 ff ff       	call   80101750 <idup>
80103de1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103de4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103de7:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dea:	8d 47 70             	lea    0x70(%edi),%eax
80103ded:	6a 10                	push   $0x10
80103def:	53                   	push   %ebx
80103df0:	50                   	push   %eax
80103df1:	e8 5a 0c 00 00       	call   80104a50 <safestrcpy>
  pid = np->pid;
80103df6:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103df9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e00:	e8 cb 09 00 00       	call   801047d0 <acquire>
  np->state = RUNNABLE;
80103e05:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103e0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e13:	e8 58 09 00 00       	call   80104770 <release>
  return pid;
80103e18:	83 c4 10             	add    $0x10,%esp
}
80103e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e1e:	89 d8                	mov    %ebx,%eax
80103e20:	5b                   	pop    %ebx
80103e21:	5e                   	pop    %esi
80103e22:	5f                   	pop    %edi
80103e23:	5d                   	pop    %ebp
80103e24:	c3                   	ret    
    return -1;
80103e25:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e2a:	eb ef                	jmp    80103e1b <fork+0xdb>
    kfree(np->kstack);
80103e2c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e2f:	83 ec 0c             	sub    $0xc,%esp
80103e32:	ff 73 0c             	push   0xc(%ebx)
80103e35:	e8 86 e6 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103e3a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e41:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e44:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103e4b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e50:	eb c9                	jmp    80103e1b <fork+0xdb>
80103e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e60 <scheduler>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e69:	e8 32 fc ff ff       	call   80103aa0 <mycpu>
  c->proc = 0;
80103e6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e75:	00 00 00 
  struct cpu *c = mycpu();
80103e78:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e7a:	8d 78 04             	lea    0x4(%eax),%edi
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e80:	fb                   	sti    
    acquire(&ptable.lock);
80103e81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e84:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103e89:	68 20 2d 11 80       	push   $0x80112d20
80103e8e:	e8 3d 09 00 00       	call   801047d0 <acquire>
80103e93:	83 c4 10             	add    $0x10,%esp
80103e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ea0:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103ea4:	75 33                	jne    80103ed9 <scheduler+0x79>
      switchuvm(p);
80103ea6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ea9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103eaf:	53                   	push   %ebx
80103eb0:	e8 8b 2f 00 00       	call   80106e40 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103eb5:	58                   	pop    %eax
80103eb6:	5a                   	pop    %edx
80103eb7:	ff 73 20             	push   0x20(%ebx)
80103eba:	57                   	push   %edi
      p->state = RUNNING;
80103ebb:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103ec2:	e8 e4 0b 00 00       	call   80104aab <swtch>
      switchkvm();
80103ec7:	e8 64 2f 00 00       	call   80106e30 <switchkvm>
      c->proc = 0;
80103ecc:	83 c4 10             	add    $0x10,%esp
80103ecf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ed6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed9:	83 eb 80             	sub    $0xffffff80,%ebx
80103edc:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103ee2:	75 bc                	jne    80103ea0 <scheduler+0x40>
    release(&ptable.lock);
80103ee4:	83 ec 0c             	sub    $0xc,%esp
80103ee7:	68 20 2d 11 80       	push   $0x80112d20
80103eec:	e8 7f 08 00 00       	call   80104770 <release>
    sti();
80103ef1:	83 c4 10             	add    $0x10,%esp
80103ef4:	eb 8a                	jmp    80103e80 <scheduler+0x20>
80103ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efd:	8d 76 00             	lea    0x0(%esi),%esi

80103f00 <sched>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
  pushcli();
80103f05:	e8 76 07 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103f0a:	e8 91 fb ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103f0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f15:	e8 b6 07 00 00       	call   801046d0 <popcli>
  if(!holding(&ptable.lock))
80103f1a:	83 ec 0c             	sub    $0xc,%esp
80103f1d:	68 20 2d 11 80       	push   $0x80112d20
80103f22:	e8 09 08 00 00       	call   80104730 <holding>
80103f27:	83 c4 10             	add    $0x10,%esp
80103f2a:	85 c0                	test   %eax,%eax
80103f2c:	74 4f                	je     80103f7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f2e:	e8 6d fb ff ff       	call   80103aa0 <mycpu>
80103f33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f3a:	75 68                	jne    80103fa4 <sched+0xa4>
  if(p->state == RUNNING)
80103f3c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f40:	74 55                	je     80103f97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f42:	9c                   	pushf  
80103f43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f44:	f6 c4 02             	test   $0x2,%ah
80103f47:	75 41                	jne    80103f8a <sched+0x8a>
  intena = mycpu()->intena;
80103f49:	e8 52 fb ff ff       	call   80103aa0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f4e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103f51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f57:	e8 44 fb ff ff       	call   80103aa0 <mycpu>
80103f5c:	83 ec 08             	sub    $0x8,%esp
80103f5f:	ff 70 04             	push   0x4(%eax)
80103f62:	53                   	push   %ebx
80103f63:	e8 43 0b 00 00       	call   80104aab <swtch>
  mycpu()->intena = intena;
80103f68:	e8 33 fb ff ff       	call   80103aa0 <mycpu>
}
80103f6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f79:	5b                   	pop    %ebx
80103f7a:	5e                   	pop    %esi
80103f7b:	5d                   	pop    %ebp
80103f7c:	c3                   	ret    
    panic("sched ptable.lock");
80103f7d:	83 ec 0c             	sub    $0xc,%esp
80103f80:	68 db 7c 10 80       	push   $0x80107cdb
80103f85:	e8 f6 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 07 7d 10 80       	push   $0x80107d07
80103f92:	e8 e9 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f97:	83 ec 0c             	sub    $0xc,%esp
80103f9a:	68 f9 7c 10 80       	push   $0x80107cf9
80103f9f:	e8 dc c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103fa4:	83 ec 0c             	sub    $0xc,%esp
80103fa7:	68 ed 7c 10 80       	push   $0x80107ced
80103fac:	e8 cf c3 ff ff       	call   80100380 <panic>
80103fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbf:	90                   	nop

80103fc0 <exit>:
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
80103fc6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fc9:	e8 52 fb ff ff       	call   80103b20 <myproc>
  if(curproc == initproc)
80103fce:	39 05 54 4d 11 80    	cmp    %eax,0x80114d54
80103fd4:	0f 84 fd 00 00 00    	je     801040d7 <exit+0x117>
80103fda:	89 c3                	mov    %eax,%ebx
80103fdc:	8d 70 2c             	lea    0x2c(%eax),%esi
80103fdf:	8d 78 6c             	lea    0x6c(%eax),%edi
80103fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fe8:	8b 06                	mov    (%esi),%eax
80103fea:	85 c0                	test   %eax,%eax
80103fec:	74 12                	je     80104000 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103fee:	83 ec 0c             	sub    $0xc,%esp
80103ff1:	50                   	push   %eax
80103ff2:	e8 f9 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103ff7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ffd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104000:	83 c6 04             	add    $0x4,%esi
80104003:	39 f7                	cmp    %esi,%edi
80104005:	75 e1                	jne    80103fe8 <exit+0x28>
  begin_op();
80104007:	e8 04 ef ff ff       	call   80102f10 <begin_op>
  iput(curproc->cwd);
8010400c:	83 ec 0c             	sub    $0xc,%esp
8010400f:	ff 73 6c             	push   0x6c(%ebx)
80104012:	e8 99 d8 ff ff       	call   801018b0 <iput>
  end_op();
80104017:	e8 64 ef ff ff       	call   80102f80 <end_op>
  curproc->cwd = 0;
8010401c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104023:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010402a:	e8 a1 07 00 00       	call   801047d0 <acquire>
  wakeup1(curproc->parent);
8010402f:	8b 53 18             	mov    0x18(%ebx),%edx
80104032:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104035:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010403a:	eb 0e                	jmp    8010404a <exit+0x8a>
8010403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104040:	83 e8 80             	sub    $0xffffff80,%eax
80104043:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104048:	74 1c                	je     80104066 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010404a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010404e:	75 f0                	jne    80104040 <exit+0x80>
80104050:	3b 50 24             	cmp    0x24(%eax),%edx
80104053:	75 eb                	jne    80104040 <exit+0x80>
      p->state = RUNNABLE;
80104055:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010405c:	83 e8 80             	sub    $0xffffff80,%eax
8010405f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104064:	75 e4                	jne    8010404a <exit+0x8a>
      p->parent = initproc;
80104066:	8b 0d 54 4d 11 80    	mov    0x80114d54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010406c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104071:	eb 10                	jmp    80104083 <exit+0xc3>
80104073:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104077:	90                   	nop
80104078:	83 ea 80             	sub    $0xffffff80,%edx
8010407b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80104081:	74 3b                	je     801040be <exit+0xfe>
    if(p->parent == curproc){
80104083:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104086:	75 f0                	jne    80104078 <exit+0xb8>
      if(p->state == ZOMBIE)
80104088:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
8010408c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010408f:	75 e7                	jne    80104078 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104091:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104096:	eb 12                	jmp    801040aa <exit+0xea>
80104098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop
801040a0:	83 e8 80             	sub    $0xffffff80,%eax
801040a3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801040a8:	74 ce                	je     80104078 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801040aa:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040ae:	75 f0                	jne    801040a0 <exit+0xe0>
801040b0:	3b 48 24             	cmp    0x24(%eax),%ecx
801040b3:	75 eb                	jne    801040a0 <exit+0xe0>
      p->state = RUNNABLE;
801040b5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
801040bc:	eb e2                	jmp    801040a0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040be:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
801040c5:	e8 36 fe ff ff       	call   80103f00 <sched>
  panic("zombie exit");
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 28 7d 10 80       	push   $0x80107d28
801040d2:	e8 a9 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	68 1b 7d 10 80       	push   $0x80107d1b
801040df:	e8 9c c2 ff ff       	call   80100380 <panic>
801040e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop

801040f0 <wait>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
  pushcli();
801040f5:	e8 86 05 00 00       	call   80104680 <pushcli>
  c = mycpu();
801040fa:	e8 a1 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801040ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104105:	e8 c6 05 00 00       	call   801046d0 <popcli>
  acquire(&ptable.lock);
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 20 2d 11 80       	push   $0x80112d20
80104112:	e8 b9 06 00 00       	call   801047d0 <acquire>
80104117:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010411a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104121:	eb 10                	jmp    80104133 <wait+0x43>
80104123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104127:	90                   	nop
80104128:	83 eb 80             	sub    $0xffffff80,%ebx
8010412b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104131:	74 1b                	je     8010414e <wait+0x5e>
      if(p->parent != curproc)
80104133:	39 73 18             	cmp    %esi,0x18(%ebx)
80104136:	75 f0                	jne    80104128 <wait+0x38>
      if(p->state == ZOMBIE){
80104138:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010413c:	74 62                	je     801041a0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104141:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104146:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
8010414c:	75 e5                	jne    80104133 <wait+0x43>
    if(!havekids || curproc->killed){
8010414e:	85 c0                	test   %eax,%eax
80104150:	0f 84 a0 00 00 00    	je     801041f6 <wait+0x106>
80104156:	8b 46 28             	mov    0x28(%esi),%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	0f 85 95 00 00 00    	jne    801041f6 <wait+0x106>
  pushcli();
80104161:	e8 1a 05 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104166:	e8 35 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 5a 05 00 00       	call   801046d0 <popcli>
  if(p == 0)
80104176:	85 db                	test   %ebx,%ebx
80104178:	0f 84 8f 00 00 00    	je     8010420d <wait+0x11d>
  p->chan = chan;
8010417e:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
80104181:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104188:	e8 73 fd ff ff       	call   80103f00 <sched>
  p->chan = 0;
8010418d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80104194:	eb 84                	jmp    8010411a <wait+0x2a>
80104196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801041a0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041a3:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801041a6:	ff 73 0c             	push   0xc(%ebx)
801041a9:	e8 12 e3 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801041ae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
801041b5:	5a                   	pop    %edx
801041b6:	ff 73 08             	push   0x8(%ebx)
801041b9:	e8 d2 31 00 00       	call   80107390 <freevm>
        p->pid = 0;
801041be:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041c5:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041cc:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801041d0:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
801041d7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801041de:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801041e5:	e8 86 05 00 00       	call   80104770 <release>
        return pid;
801041ea:	83 c4 10             	add    $0x10,%esp
}
801041ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041f0:	89 f0                	mov    %esi,%eax
801041f2:	5b                   	pop    %ebx
801041f3:	5e                   	pop    %esi
801041f4:	5d                   	pop    %ebp
801041f5:	c3                   	ret    
      release(&ptable.lock);
801041f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041fe:	68 20 2d 11 80       	push   $0x80112d20
80104203:	e8 68 05 00 00       	call   80104770 <release>
      return -1;
80104208:	83 c4 10             	add    $0x10,%esp
8010420b:	eb e0                	jmp    801041ed <wait+0xfd>
    panic("sleep");
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 34 7d 10 80       	push   $0x80107d34
80104215:	e8 66 c1 ff ff       	call   80100380 <panic>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <yield>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104227:	68 20 2d 11 80       	push   $0x80112d20
8010422c:	e8 9f 05 00 00       	call   801047d0 <acquire>
  pushcli();
80104231:	e8 4a 04 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104236:	e8 65 f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010423b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104241:	e8 8a 04 00 00       	call   801046d0 <popcli>
  myproc()->state = RUNNABLE;
80104246:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010424d:	e8 ae fc ff ff       	call   80103f00 <sched>
  release(&ptable.lock);
80104252:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104259:	e8 12 05 00 00       	call   80104770 <release>
}
8010425e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104261:	83 c4 10             	add    $0x10,%esp
80104264:	c9                   	leave  
80104265:	c3                   	ret    
80104266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426d:	8d 76 00             	lea    0x0(%esi),%esi

80104270 <sleep>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010427c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010427f:	e8 fc 03 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104284:	e8 17 f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104289:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010428f:	e8 3c 04 00 00       	call   801046d0 <popcli>
  if(p == 0)
80104294:	85 db                	test   %ebx,%ebx
80104296:	0f 84 87 00 00 00    	je     80104323 <sleep+0xb3>
  if(lk == 0)
8010429c:	85 f6                	test   %esi,%esi
8010429e:	74 76                	je     80104316 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042a0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801042a6:	74 50                	je     801042f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 20 2d 11 80       	push   $0x80112d20
801042b0:	e8 1b 05 00 00       	call   801047d0 <acquire>
    release(lk);
801042b5:	89 34 24             	mov    %esi,(%esp)
801042b8:	e8 b3 04 00 00       	call   80104770 <release>
  p->chan = chan;
801042bd:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042c0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042c7:	e8 34 fc ff ff       	call   80103f00 <sched>
  p->chan = 0;
801042cc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
801042d3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042da:	e8 91 04 00 00       	call   80104770 <release>
    acquire(lk);
801042df:	89 75 08             	mov    %esi,0x8(%ebp)
801042e2:	83 c4 10             	add    $0x10,%esp
}
801042e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e8:	5b                   	pop    %ebx
801042e9:	5e                   	pop    %esi
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
    acquire(lk);
801042ec:	e9 df 04 00 00       	jmp    801047d0 <acquire>
801042f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042f8:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042fb:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104302:	e8 f9 fb ff ff       	call   80103f00 <sched>
  p->chan = 0;
80104307:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010430e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104311:	5b                   	pop    %ebx
80104312:	5e                   	pop    %esi
80104313:	5f                   	pop    %edi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
    panic("sleep without lk");
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 3a 7d 10 80       	push   $0x80107d3a
8010431e:	e8 5d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	68 34 7d 10 80       	push   $0x80107d34
8010432b:	e8 50 c0 ff ff       	call   80100380 <panic>

80104330 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010433a:	68 20 2d 11 80       	push   $0x80112d20
8010433f:	e8 8c 04 00 00       	call   801047d0 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104347:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010434c:	eb 0c                	jmp    8010435a <wakeup+0x2a>
8010434e:	66 90                	xchg   %ax,%ax
80104350:	83 e8 80             	sub    $0xffffff80,%eax
80104353:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104358:	74 1c                	je     80104376 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010435a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010435e:	75 f0                	jne    80104350 <wakeup+0x20>
80104360:	3b 58 24             	cmp    0x24(%eax),%ebx
80104363:	75 eb                	jne    80104350 <wakeup+0x20>
      p->state = RUNNABLE;
80104365:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010436c:	83 e8 80             	sub    $0xffffff80,%eax
8010436f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104374:	75 e4                	jne    8010435a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104376:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010437d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104380:	c9                   	leave  
  release(&ptable.lock);
80104381:	e9 ea 03 00 00       	jmp    80104770 <release>
80104386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010439a:	68 20 2d 11 80       	push   $0x80112d20
8010439f:	e8 2c 04 00 00       	call   801047d0 <acquire>
801043a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043ac:	eb 0c                	jmp    801043ba <kill+0x2a>
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	83 e8 80             	sub    $0xffffff80,%eax
801043b3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801043b8:	74 36                	je     801043f0 <kill+0x60>
    if(p->pid == pid){
801043ba:	39 58 14             	cmp    %ebx,0x14(%eax)
801043bd:	75 f1                	jne    801043b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043bf:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801043c3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801043ca:	75 07                	jne    801043d3 <kill+0x43>
        p->state = RUNNABLE;
801043cc:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 20 2d 11 80       	push   $0x80112d20
801043db:	e8 90 03 00 00       	call   80104770 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043e3:	83 c4 10             	add    $0x10,%esp
801043e6:	31 c0                	xor    %eax,%eax
}
801043e8:	c9                   	leave  
801043e9:	c3                   	ret    
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 20 2d 11 80       	push   $0x80112d20
801043f8:	e8 73 03 00 00       	call   80104770 <release>
}
801043fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104400:	83 c4 10             	add    $0x10,%esp
80104403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104408:	c9                   	leave  
80104409:	c3                   	ret    
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104418:	53                   	push   %ebx
80104419:	bb c4 2d 11 80       	mov    $0x80112dc4,%ebx
8010441e:	83 ec 3c             	sub    $0x3c,%esp
80104421:	eb 24                	jmp    80104447 <procdump+0x37>
80104423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104427:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 db 80 10 80       	push   $0x801080db
80104430:	e8 6b c2 ff ff       	call   801006a0 <cprintf>
80104435:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104438:	83 eb 80             	sub    $0xffffff80,%ebx
8010443b:	81 fb c4 4d 11 80    	cmp    $0x80114dc4,%ebx
80104441:	0f 84 81 00 00 00    	je     801044c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104447:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010444a:	85 c0                	test   %eax,%eax
8010444c:	74 ea                	je     80104438 <procdump+0x28>
      state = "???";
8010444e:	ba 4b 7d 10 80       	mov    $0x80107d4b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104453:	83 f8 05             	cmp    $0x5,%eax
80104456:	77 11                	ja     80104469 <procdump+0x59>
80104458:	8b 14 85 ac 7d 10 80 	mov    -0x7fef8254(,%eax,4),%edx
      state = "???";
8010445f:	b8 4b 7d 10 80       	mov    $0x80107d4b,%eax
80104464:	85 d2                	test   %edx,%edx
80104466:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104469:	53                   	push   %ebx
8010446a:	52                   	push   %edx
8010446b:	ff 73 a4             	push   -0x5c(%ebx)
8010446e:	68 4f 7d 10 80       	push   $0x80107d4f
80104473:	e8 28 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104478:	83 c4 10             	add    $0x10,%esp
8010447b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010447f:	75 a7                	jne    80104428 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104481:	83 ec 08             	sub    $0x8,%esp
80104484:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104487:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010448a:	50                   	push   %eax
8010448b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010448e:	8b 40 0c             	mov    0xc(%eax),%eax
80104491:	83 c0 08             	add    $0x8,%eax
80104494:	50                   	push   %eax
80104495:	e8 86 01 00 00       	call   80104620 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010449a:	83 c4 10             	add    $0x10,%esp
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	8b 17                	mov    (%edi),%edx
801044a2:	85 d2                	test   %edx,%edx
801044a4:	74 82                	je     80104428 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044ac:	52                   	push   %edx
801044ad:	68 a1 77 10 80       	push   $0x801077a1
801044b2:	e8 e9 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044b7:	83 c4 10             	add    $0x10,%esp
801044ba:	39 fe                	cmp    %edi,%esi
801044bc:	75 e2                	jne    801044a0 <procdump+0x90>
801044be:	e9 65 ff ff ff       	jmp    80104428 <procdump+0x18>
801044c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c7:	90                   	nop
  }
}
801044c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044cb:	5b                   	pop    %ebx
801044cc:	5e                   	pop    %esi
801044cd:	5f                   	pop    %edi
801044ce:	5d                   	pop    %ebp
801044cf:	c3                   	ret    

801044d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044da:	68 c4 7d 10 80       	push   $0x80107dc4
801044df:	8d 43 04             	lea    0x4(%ebx),%eax
801044e2:	50                   	push   %eax
801044e3:	e8 18 01 00 00       	call   80104600 <initlock>
  lk->name = name;
801044e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104501:	c9                   	leave  
80104502:	c3                   	ret    
80104503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104518:	8d 73 04             	lea    0x4(%ebx),%esi
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	56                   	push   %esi
8010451f:	e8 ac 02 00 00       	call   801047d0 <acquire>
  while (lk->locked) {
80104524:	8b 13                	mov    (%ebx),%edx
80104526:	83 c4 10             	add    $0x10,%esp
80104529:	85 d2                	test   %edx,%edx
8010452b:	74 16                	je     80104543 <acquiresleep+0x33>
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104530:	83 ec 08             	sub    $0x8,%esp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	e8 36 fd ff ff       	call   80104270 <sleep>
  while (lk->locked) {
8010453a:	8b 03                	mov    (%ebx),%eax
8010453c:	83 c4 10             	add    $0x10,%esp
8010453f:	85 c0                	test   %eax,%eax
80104541:	75 ed                	jne    80104530 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104543:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104549:	e8 d2 f5 ff ff       	call   80103b20 <myproc>
8010454e:	8b 40 14             	mov    0x14(%eax),%eax
80104551:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104554:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104557:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010455a:	5b                   	pop    %ebx
8010455b:	5e                   	pop    %esi
8010455c:	5d                   	pop    %ebp
  release(&lk->lk);
8010455d:	e9 0e 02 00 00       	jmp    80104770 <release>
80104562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104570 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104578:	8d 73 04             	lea    0x4(%ebx),%esi
8010457b:	83 ec 0c             	sub    $0xc,%esp
8010457e:	56                   	push   %esi
8010457f:	e8 4c 02 00 00       	call   801047d0 <acquire>
  lk->locked = 0;
80104584:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010458a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104591:	89 1c 24             	mov    %ebx,(%esp)
80104594:	e8 97 fd ff ff       	call   80104330 <wakeup>
  release(&lk->lk);
80104599:	89 75 08             	mov    %esi,0x8(%ebp)
8010459c:	83 c4 10             	add    $0x10,%esp
}
8010459f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a2:	5b                   	pop    %ebx
801045a3:	5e                   	pop    %esi
801045a4:	5d                   	pop    %ebp
  release(&lk->lk);
801045a5:	e9 c6 01 00 00       	jmp    80104770 <release>
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	31 ff                	xor    %edi,%edi
801045b6:	56                   	push   %esi
801045b7:	53                   	push   %ebx
801045b8:	83 ec 18             	sub    $0x18,%esp
801045bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045be:	8d 73 04             	lea    0x4(%ebx),%esi
801045c1:	56                   	push   %esi
801045c2:	e8 09 02 00 00       	call   801047d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045c7:	8b 03                	mov    (%ebx),%eax
801045c9:	83 c4 10             	add    $0x10,%esp
801045cc:	85 c0                	test   %eax,%eax
801045ce:	75 18                	jne    801045e8 <holdingsleep+0x38>
  release(&lk->lk);
801045d0:	83 ec 0c             	sub    $0xc,%esp
801045d3:	56                   	push   %esi
801045d4:	e8 97 01 00 00       	call   80104770 <release>
  return r;
}
801045d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045dc:	89 f8                	mov    %edi,%eax
801045de:	5b                   	pop    %ebx
801045df:	5e                   	pop    %esi
801045e0:	5f                   	pop    %edi
801045e1:	5d                   	pop    %ebp
801045e2:	c3                   	ret    
801045e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801045e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045eb:	e8 30 f5 ff ff       	call   80103b20 <myproc>
801045f0:	39 58 14             	cmp    %ebx,0x14(%eax)
801045f3:	0f 94 c0             	sete   %al
801045f6:	0f b6 c0             	movzbl %al,%eax
801045f9:	89 c7                	mov    %eax,%edi
801045fb:	eb d3                	jmp    801045d0 <holdingsleep+0x20>
801045fd:	66 90                	xchg   %ax,%ax
801045ff:	90                   	nop

80104600 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104606:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010460f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104619:	5d                   	pop    %ebp
8010461a:	c3                   	ret    
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop

80104620 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104620:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104621:	31 d2                	xor    %edx,%edx
{
80104623:	89 e5                	mov    %esp,%ebp
80104625:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104626:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010462c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010462f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104630:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104636:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010463c:	77 1a                	ja     80104658 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010463e:	8b 58 04             	mov    0x4(%eax),%ebx
80104641:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104644:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104647:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104649:	83 fa 0a             	cmp    $0xa,%edx
8010464c:	75 e2                	jne    80104630 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010464e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104651:	c9                   	leave  
80104652:	c3                   	ret    
80104653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104657:	90                   	nop
  for(; i < 10; i++)
80104658:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010465b:	8d 51 28             	lea    0x28(%ecx),%edx
8010465e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104666:	83 c0 04             	add    $0x4,%eax
80104669:	39 d0                	cmp    %edx,%eax
8010466b:	75 f3                	jne    80104660 <getcallerpcs+0x40>
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave  
80104671:	c3                   	ret    
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104680 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	83 ec 04             	sub    $0x4,%esp
80104687:	9c                   	pushf  
80104688:	5b                   	pop    %ebx
  asm volatile("cli");
80104689:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010468a:	e8 11 f4 ff ff       	call   80103aa0 <mycpu>
8010468f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104695:	85 c0                	test   %eax,%eax
80104697:	74 17                	je     801046b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104699:	e8 02 f4 ff ff       	call   80103aa0 <mycpu>
8010469e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a8:	c9                   	leave  
801046a9:	c3                   	ret    
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046b0:	e8 eb f3 ff ff       	call   80103aa0 <mycpu>
801046b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046c1:	eb d6                	jmp    80104699 <pushcli+0x19>
801046c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <popcli>:

void
popcli(void)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046d6:	9c                   	pushf  
801046d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046d8:	f6 c4 02             	test   $0x2,%ah
801046db:	75 35                	jne    80104712 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046dd:	e8 be f3 ff ff       	call   80103aa0 <mycpu>
801046e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046e9:	78 34                	js     8010471f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046eb:	e8 b0 f3 ff ff       	call   80103aa0 <mycpu>
801046f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046f6:	85 d2                	test   %edx,%edx
801046f8:	74 06                	je     80104700 <popcli+0x30>
    sti();
}
801046fa:	c9                   	leave  
801046fb:	c3                   	ret    
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104700:	e8 9b f3 ff ff       	call   80103aa0 <mycpu>
80104705:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010470b:	85 c0                	test   %eax,%eax
8010470d:	74 eb                	je     801046fa <popcli+0x2a>
  asm volatile("sti");
8010470f:	fb                   	sti    
}
80104710:	c9                   	leave  
80104711:	c3                   	ret    
    panic("popcli - interruptible");
80104712:	83 ec 0c             	sub    $0xc,%esp
80104715:	68 cf 7d 10 80       	push   $0x80107dcf
8010471a:	e8 61 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010471f:	83 ec 0c             	sub    $0xc,%esp
80104722:	68 e6 7d 10 80       	push   $0x80107de6
80104727:	e8 54 bc ff ff       	call   80100380 <panic>
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <holding>:
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 75 08             	mov    0x8(%ebp),%esi
80104738:	31 db                	xor    %ebx,%ebx
  pushcli();
8010473a:	e8 41 ff ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010473f:	8b 06                	mov    (%esi),%eax
80104741:	85 c0                	test   %eax,%eax
80104743:	75 0b                	jne    80104750 <holding+0x20>
  popcli();
80104745:	e8 86 ff ff ff       	call   801046d0 <popcli>
}
8010474a:	89 d8                	mov    %ebx,%eax
8010474c:	5b                   	pop    %ebx
8010474d:	5e                   	pop    %esi
8010474e:	5d                   	pop    %ebp
8010474f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104750:	8b 5e 08             	mov    0x8(%esi),%ebx
80104753:	e8 48 f3 ff ff       	call   80103aa0 <mycpu>
80104758:	39 c3                	cmp    %eax,%ebx
8010475a:	0f 94 c3             	sete   %bl
  popcli();
8010475d:	e8 6e ff ff ff       	call   801046d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104762:	0f b6 db             	movzbl %bl,%ebx
}
80104765:	89 d8                	mov    %ebx,%eax
80104767:	5b                   	pop    %ebx
80104768:	5e                   	pop    %esi
80104769:	5d                   	pop    %ebp
8010476a:	c3                   	ret    
8010476b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop

80104770 <release>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104778:	e8 03 ff ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010477d:	8b 03                	mov    (%ebx),%eax
8010477f:	85 c0                	test   %eax,%eax
80104781:	75 15                	jne    80104798 <release+0x28>
  popcli();
80104783:	e8 48 ff ff ff       	call   801046d0 <popcli>
    panic("release");
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	68 ed 7d 10 80       	push   $0x80107ded
80104790:	e8 eb bb ff ff       	call   80100380 <panic>
80104795:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104798:	8b 73 08             	mov    0x8(%ebx),%esi
8010479b:	e8 00 f3 ff ff       	call   80103aa0 <mycpu>
801047a0:	39 c6                	cmp    %eax,%esi
801047a2:	75 df                	jne    80104783 <release+0x13>
  popcli();
801047a4:	e8 27 ff ff ff       	call   801046d0 <popcli>
  lk->pcs[0] = 0;
801047a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c5:	5b                   	pop    %ebx
801047c6:	5e                   	pop    %esi
801047c7:	5d                   	pop    %ebp
  popcli();
801047c8:	e9 03 ff ff ff       	jmp    801046d0 <popcli>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <acquire>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047d7:	e8 a4 fe ff ff       	call   80104680 <pushcli>
  if(holding(lk))
801047dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047df:	e8 9c fe ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047e4:	8b 03                	mov    (%ebx),%eax
801047e6:	85 c0                	test   %eax,%eax
801047e8:	75 7e                	jne    80104868 <acquire+0x98>
  popcli();
801047ea:	e8 e1 fe ff ff       	call   801046d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801047f8:	8b 55 08             	mov    0x8(%ebp),%edx
801047fb:	89 c8                	mov    %ecx,%eax
801047fd:	f0 87 02             	lock xchg %eax,(%edx)
80104800:	85 c0                	test   %eax,%eax
80104802:	75 f4                	jne    801047f8 <acquire+0x28>
  __sync_synchronize();
80104804:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104809:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010480c:	e8 8f f2 ff ff       	call   80103aa0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104814:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104816:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104819:	31 c0                	xor    %eax,%eax
8010481b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104820:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104826:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010482c:	77 1a                	ja     80104848 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010482e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104831:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104835:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104838:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010483a:	83 f8 0a             	cmp    $0xa,%eax
8010483d:	75 e1                	jne    80104820 <acquire+0x50>
}
8010483f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104842:	c9                   	leave  
80104843:	c3                   	ret    
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104848:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010484c:	8d 51 34             	lea    0x34(%ecx),%edx
8010484f:	90                   	nop
    pcs[i] = 0;
80104850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104856:	83 c0 04             	add    $0x4,%eax
80104859:	39 c2                	cmp    %eax,%edx
8010485b:	75 f3                	jne    80104850 <acquire+0x80>
}
8010485d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104860:	c9                   	leave  
80104861:	c3                   	ret    
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104868:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010486b:	e8 30 f2 ff ff       	call   80103aa0 <mycpu>
80104870:	39 c3                	cmp    %eax,%ebx
80104872:	0f 85 72 ff ff ff    	jne    801047ea <acquire+0x1a>
  popcli();
80104878:	e8 53 fe ff ff       	call   801046d0 <popcli>
    panic("acquire");
8010487d:	83 ec 0c             	sub    $0xc,%esp
80104880:	68 f5 7d 10 80       	push   $0x80107df5
80104885:	e8 f6 ba ff ff       	call   80100380 <panic>
8010488a:	66 90                	xchg   %ax,%ax
8010488c:	66 90                	xchg   %ax,%ax
8010488e:	66 90                	xchg   %ax,%ax

80104890 <memset>:
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	8b 55 08             	mov    0x8(%ebp),%edx
80104897:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010489a:	53                   	push   %ebx
8010489b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010489e:	89 d7                	mov    %edx,%edi
801048a0:	09 cf                	or     %ecx,%edi
801048a2:	83 e7 03             	and    $0x3,%edi
801048a5:	75 29                	jne    801048d0 <memset+0x40>
801048a7:	0f b6 f8             	movzbl %al,%edi
801048aa:	c1 e0 18             	shl    $0x18,%eax
801048ad:	89 fb                	mov    %edi,%ebx
801048af:	c1 e9 02             	shr    $0x2,%ecx
801048b2:	c1 e3 10             	shl    $0x10,%ebx
801048b5:	09 d8                	or     %ebx,%eax
801048b7:	09 f8                	or     %edi,%eax
801048b9:	c1 e7 08             	shl    $0x8,%edi
801048bc:	09 f8                	or     %edi,%eax
801048be:	89 d7                	mov    %edx,%edi
801048c0:	fc                   	cld    
801048c1:	f3 ab                	rep stos %eax,%es:(%edi)
801048c3:	5b                   	pop    %ebx
801048c4:	89 d0                	mov    %edx,%eax
801048c6:	5f                   	pop    %edi
801048c7:	5d                   	pop    %ebp
801048c8:	c3                   	ret    
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048d0:	89 d7                	mov    %edx,%edi
801048d2:	fc                   	cld    
801048d3:	f3 aa                	rep stos %al,%es:(%edi)
801048d5:	5b                   	pop    %ebx
801048d6:	89 d0                	mov    %edx,%eax
801048d8:	5f                   	pop    %edi
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    
801048db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop

801048e0 <memcmp>:
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	8b 75 10             	mov    0x10(%ebp),%esi
801048e7:	8b 55 08             	mov    0x8(%ebp),%edx
801048ea:	53                   	push   %ebx
801048eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ee:	85 f6                	test   %esi,%esi
801048f0:	74 2e                	je     80104920 <memcmp+0x40>
801048f2:	01 c6                	add    %eax,%esi
801048f4:	eb 14                	jmp    8010490a <memcmp+0x2a>
801048f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
80104900:	83 c0 01             	add    $0x1,%eax
80104903:	83 c2 01             	add    $0x1,%edx
80104906:	39 f0                	cmp    %esi,%eax
80104908:	74 16                	je     80104920 <memcmp+0x40>
8010490a:	0f b6 0a             	movzbl (%edx),%ecx
8010490d:	0f b6 18             	movzbl (%eax),%ebx
80104910:	38 d9                	cmp    %bl,%cl
80104912:	74 ec                	je     80104900 <memcmp+0x20>
80104914:	0f b6 c1             	movzbl %cl,%eax
80104917:	29 d8                	sub    %ebx,%eax
80104919:	5b                   	pop    %ebx
8010491a:	5e                   	pop    %esi
8010491b:	5d                   	pop    %ebp
8010491c:	c3                   	ret    
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
80104920:	5b                   	pop    %ebx
80104921:	31 c0                	xor    %eax,%eax
80104923:	5e                   	pop    %esi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret    
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi

80104930 <memmove>:
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	8b 55 08             	mov    0x8(%ebp),%edx
80104937:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010493a:	56                   	push   %esi
8010493b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010493e:	39 d6                	cmp    %edx,%esi
80104940:	73 26                	jae    80104968 <memmove+0x38>
80104942:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104945:	39 fa                	cmp    %edi,%edx
80104947:	73 1f                	jae    80104968 <memmove+0x38>
80104949:	8d 41 ff             	lea    -0x1(%ecx),%eax
8010494c:	85 c9                	test   %ecx,%ecx
8010494e:	74 0c                	je     8010495c <memmove+0x2c>
80104950:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104954:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104957:	83 e8 01             	sub    $0x1,%eax
8010495a:	73 f4                	jae    80104950 <memmove+0x20>
8010495c:	5e                   	pop    %esi
8010495d:	89 d0                	mov    %edx,%eax
8010495f:	5f                   	pop    %edi
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret    
80104962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104968:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010496b:	89 d7                	mov    %edx,%edi
8010496d:	85 c9                	test   %ecx,%ecx
8010496f:	74 eb                	je     8010495c <memmove+0x2c>
80104971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104978:	a4                   	movsb  %ds:(%esi),%es:(%edi)
80104979:	39 c6                	cmp    %eax,%esi
8010497b:	75 fb                	jne    80104978 <memmove+0x48>
8010497d:	5e                   	pop    %esi
8010497e:	89 d0                	mov    %edx,%eax
80104980:	5f                   	pop    %edi
80104981:	5d                   	pop    %ebp
80104982:	c3                   	ret    
80104983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <memcpy>:
80104990:	eb 9e                	jmp    80104930 <memmove>
80104992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049a0 <strncmp>:
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	8b 75 10             	mov    0x10(%ebp),%esi
801049a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049aa:	53                   	push   %ebx
801049ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801049ae:	85 f6                	test   %esi,%esi
801049b0:	74 2e                	je     801049e0 <strncmp+0x40>
801049b2:	01 d6                	add    %edx,%esi
801049b4:	eb 18                	jmp    801049ce <strncmp+0x2e>
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
801049c0:	38 d8                	cmp    %bl,%al
801049c2:	75 14                	jne    801049d8 <strncmp+0x38>
801049c4:	83 c2 01             	add    $0x1,%edx
801049c7:	83 c1 01             	add    $0x1,%ecx
801049ca:	39 f2                	cmp    %esi,%edx
801049cc:	74 12                	je     801049e0 <strncmp+0x40>
801049ce:	0f b6 01             	movzbl (%ecx),%eax
801049d1:	0f b6 1a             	movzbl (%edx),%ebx
801049d4:	84 c0                	test   %al,%al
801049d6:	75 e8                	jne    801049c0 <strncmp+0x20>
801049d8:	29 d8                	sub    %ebx,%eax
801049da:	5b                   	pop    %ebx
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret    
801049de:	66 90                	xchg   %ax,%ax
801049e0:	5b                   	pop    %ebx
801049e1:	31 c0                	xor    %eax,%eax
801049e3:	5e                   	pop    %esi
801049e4:	5d                   	pop    %ebp
801049e5:	c3                   	ret    
801049e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ed:	8d 76 00             	lea    0x0(%esi),%esi

801049f0 <strncpy>:
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	8b 75 08             	mov    0x8(%ebp),%esi
801049f8:	53                   	push   %ebx
801049f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049fc:	89 f0                	mov    %esi,%eax
801049fe:	eb 15                	jmp    80104a15 <strncpy+0x25>
80104a00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a04:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a07:	83 c0 01             	add    $0x1,%eax
80104a0a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a0e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a11:	84 d2                	test   %dl,%dl
80104a13:	74 09                	je     80104a1e <strncpy+0x2e>
80104a15:	89 cb                	mov    %ecx,%ebx
80104a17:	83 e9 01             	sub    $0x1,%ecx
80104a1a:	85 db                	test   %ebx,%ebx
80104a1c:	7f e2                	jg     80104a00 <strncpy+0x10>
80104a1e:	89 c2                	mov    %eax,%edx
80104a20:	85 c9                	test   %ecx,%ecx
80104a22:	7e 17                	jle    80104a3b <strncpy+0x4b>
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a28:	83 c2 01             	add    $0x1,%edx
80104a2b:	89 c1                	mov    %eax,%ecx
80104a2d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80104a31:	29 d1                	sub    %edx,%ecx
80104a33:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a37:	85 c9                	test   %ecx,%ecx
80104a39:	7f ed                	jg     80104a28 <strncpy+0x38>
80104a3b:	5b                   	pop    %ebx
80104a3c:	89 f0                	mov    %esi,%eax
80104a3e:	5e                   	pop    %esi
80104a3f:	5f                   	pop    %edi
80104a40:	5d                   	pop    %ebp
80104a41:	c3                   	ret    
80104a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a50 <safestrcpy>:
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	8b 55 10             	mov    0x10(%ebp),%edx
80104a57:	8b 75 08             	mov    0x8(%ebp),%esi
80104a5a:	53                   	push   %ebx
80104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a5e:	85 d2                	test   %edx,%edx
80104a60:	7e 25                	jle    80104a87 <safestrcpy+0x37>
80104a62:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a66:	89 f2                	mov    %esi,%edx
80104a68:	eb 16                	jmp    80104a80 <safestrcpy+0x30>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a70:	0f b6 08             	movzbl (%eax),%ecx
80104a73:	83 c0 01             	add    $0x1,%eax
80104a76:	83 c2 01             	add    $0x1,%edx
80104a79:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a7c:	84 c9                	test   %cl,%cl
80104a7e:	74 04                	je     80104a84 <safestrcpy+0x34>
80104a80:	39 d8                	cmp    %ebx,%eax
80104a82:	75 ec                	jne    80104a70 <safestrcpy+0x20>
80104a84:	c6 02 00             	movb   $0x0,(%edx)
80104a87:	89 f0                	mov    %esi,%eax
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret    
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <strlen>:
80104a90:	55                   	push   %ebp
80104a91:	31 c0                	xor    %eax,%eax
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	8b 55 08             	mov    0x8(%ebp),%edx
80104a98:	80 3a 00             	cmpb   $0x0,(%edx)
80104a9b:	74 0c                	je     80104aa9 <strlen+0x19>
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	83 c0 01             	add    $0x1,%eax
80104aa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104aa7:	75 f7                	jne    80104aa0 <strlen+0x10>
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    

80104aab <swtch>:
80104aab:	8b 44 24 04          	mov    0x4(%esp),%eax
80104aaf:	8b 54 24 08          	mov    0x8(%esp),%edx
80104ab3:	55                   	push   %ebp
80104ab4:	53                   	push   %ebx
80104ab5:	56                   	push   %esi
80104ab6:	57                   	push   %edi
80104ab7:	89 20                	mov    %esp,(%eax)
80104ab9:	89 d4                	mov    %edx,%esp
80104abb:	5f                   	pop    %edi
80104abc:	5e                   	pop    %esi
80104abd:	5b                   	pop    %ebx
80104abe:	5d                   	pop    %ebp
80104abf:	c3                   	ret    

80104ac0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aca:	e8 51 f0 ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104acf:	8b 00                	mov    (%eax),%eax
80104ad1:	39 d8                	cmp    %ebx,%eax
80104ad3:	76 1b                	jbe    80104af0 <fetchint+0x30>
80104ad5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ad8:	39 d0                	cmp    %edx,%eax
80104ada:	72 14                	jb     80104af0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104adf:	8b 13                	mov    (%ebx),%edx
80104ae1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ae3:	31 c0                	xor    %eax,%eax
}
80104ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae8:	c9                   	leave  
80104ae9:	c3                   	ret    
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af5:	eb ee                	jmp    80104ae5 <fetchint+0x25>
80104af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
80104b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b0a:	e8 11 f0 ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz)
80104b0f:	39 18                	cmp    %ebx,(%eax)
80104b11:	76 2d                	jbe    80104b40 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b16:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b18:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b1a:	39 d3                	cmp    %edx,%ebx
80104b1c:	73 22                	jae    80104b40 <fetchstr+0x40>
80104b1e:	89 d8                	mov    %ebx,%eax
80104b20:	eb 0d                	jmp    80104b2f <fetchstr+0x2f>
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b28:	83 c0 01             	add    $0x1,%eax
80104b2b:	39 c2                	cmp    %eax,%edx
80104b2d:	76 11                	jbe    80104b40 <fetchstr+0x40>
    if(*s == 0)
80104b2f:	80 38 00             	cmpb   $0x0,(%eax)
80104b32:	75 f4                	jne    80104b28 <fetchstr+0x28>
      return s - *pp;
80104b34:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b39:	c9                   	leave  
80104b3a:	c3                   	ret    
80104b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b3f:	90                   	nop
80104b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b48:	c9                   	leave  
80104b49:	c3                   	ret    
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b55:	e8 c6 ef ff ff       	call   80103b20 <myproc>
80104b5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b5d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b60:	8b 40 44             	mov    0x44(%eax),%eax
80104b63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b66:	e8 b5 ef ff ff       	call   80103b20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b6e:	8b 00                	mov    (%eax),%eax
80104b70:	39 c6                	cmp    %eax,%esi
80104b72:	73 1c                	jae    80104b90 <argint+0x40>
80104b74:	8d 53 08             	lea    0x8(%ebx),%edx
80104b77:	39 d0                	cmp    %edx,%eax
80104b79:	72 15                	jb     80104b90 <argint+0x40>
  *ip = *(int*)(addr);
80104b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b81:	89 10                	mov    %edx,(%eax)
  return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	5b                   	pop    %ebx
80104b86:	5e                   	pop    %esi
80104b87:	5d                   	pop    %ebp
80104b88:	c3                   	ret    
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	eb ee                	jmp    80104b85 <argint+0x35>
80104b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	53                   	push   %ebx
80104ba6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ba9:	e8 72 ef ff ff       	call   80103b20 <myproc>
80104bae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb0:	e8 6b ef ff ff       	call   80103b20 <myproc>
80104bb5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bb8:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bbb:	8b 40 44             	mov    0x44(%eax),%eax
80104bbe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bc1:	e8 5a ef ff ff       	call   80103b20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bc9:	8b 00                	mov    (%eax),%eax
80104bcb:	39 c7                	cmp    %eax,%edi
80104bcd:	73 31                	jae    80104c00 <argptr+0x60>
80104bcf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104bd2:	39 c8                	cmp    %ecx,%eax
80104bd4:	72 2a                	jb     80104c00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bd6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104bd9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bdc:	85 d2                	test   %edx,%edx
80104bde:	78 20                	js     80104c00 <argptr+0x60>
80104be0:	8b 16                	mov    (%esi),%edx
80104be2:	39 c2                	cmp    %eax,%edx
80104be4:	76 1a                	jbe    80104c00 <argptr+0x60>
80104be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104be9:	01 c3                	add    %eax,%ebx
80104beb:	39 da                	cmp    %ebx,%edx
80104bed:	72 11                	jb     80104c00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bef:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bf2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bf4:	31 c0                	xor    %eax,%eax
}
80104bf6:	83 c4 0c             	add    $0xc,%esp
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5f                   	pop    %edi
80104bfc:	5d                   	pop    %ebp
80104bfd:	c3                   	ret    
80104bfe:	66 90                	xchg   %ax,%ax
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c05:	eb ef                	jmp    80104bf6 <argptr+0x56>
80104c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	e8 06 ef ff ff       	call   80103b20 <myproc>
80104c1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c1d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c20:	8b 40 44             	mov    0x44(%eax),%eax
80104c23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c26:	e8 f5 ee ff ff       	call   80103b20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c2e:	8b 00                	mov    (%eax),%eax
80104c30:	39 c6                	cmp    %eax,%esi
80104c32:	73 44                	jae    80104c78 <argstr+0x68>
80104c34:	8d 53 08             	lea    0x8(%ebx),%edx
80104c37:	39 d0                	cmp    %edx,%eax
80104c39:	72 3d                	jb     80104c78 <argstr+0x68>
  *ip = *(int*)(addr);
80104c3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c3e:	e8 dd ee ff ff       	call   80103b20 <myproc>
  if(addr >= curproc->sz)
80104c43:	3b 18                	cmp    (%eax),%ebx
80104c45:	73 31                	jae    80104c78 <argstr+0x68>
  *pp = (char*)addr;
80104c47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c4e:	39 d3                	cmp    %edx,%ebx
80104c50:	73 26                	jae    80104c78 <argstr+0x68>
80104c52:	89 d8                	mov    %ebx,%eax
80104c54:	eb 11                	jmp    80104c67 <argstr+0x57>
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
80104c60:	83 c0 01             	add    $0x1,%eax
80104c63:	39 c2                	cmp    %eax,%edx
80104c65:	76 11                	jbe    80104c78 <argstr+0x68>
    if(*s == 0)
80104c67:	80 38 00             	cmpb   $0x0,(%eax)
80104c6a:	75 f4                	jne    80104c60 <argstr+0x50>
      return s - *pp;
80104c6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c6e:	5b                   	pop    %ebx
80104c6f:	5e                   	pop    %esi
80104c70:	5d                   	pop    %ebp
80104c71:	c3                   	ret    
80104c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c78:	5b                   	pop    %ebx
    return -1;
80104c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c7e:	5e                   	pop    %esi
80104c7f:	5d                   	pop    %ebp
80104c80:	c3                   	ret    
80104c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop

80104c90 <syscall>:
[SYS_shugebrk] sys_shugebrk, // part 2
};

void
syscall(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c97:	e8 84 ee ff ff       	call   80103b20 <myproc>
80104c9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c9e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ca1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ca4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ca7:	83 fa 17             	cmp    $0x17,%edx
80104caa:	77 24                	ja     80104cd0 <syscall+0x40>
80104cac:	8b 14 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%edx
80104cb3:	85 d2                	test   %edx,%edx
80104cb5:	74 19                	je     80104cd0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104cb7:	ff d2                	call   *%edx
80104cb9:	89 c2                	mov    %eax,%edx
80104cbb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104cbe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc4:	c9                   	leave  
80104cc5:	c3                   	ret    
80104cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104cd0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cd1:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cd4:	50                   	push   %eax
80104cd5:	ff 73 14             	push   0x14(%ebx)
80104cd8:	68 fd 7d 10 80       	push   $0x80107dfd
80104cdd:	e8 be b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104ce2:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104ce5:	83 c4 10             	add    $0x10,%esp
80104ce8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf2:	c9                   	leave  
80104cf3:	c3                   	ret    
80104cf4:	66 90                	xchg   %ax,%ax
80104cf6:	66 90                	xchg   %ax,%ax
80104cf8:	66 90                	xchg   %ax,%ax
80104cfa:	66 90                	xchg   %ax,%ax
80104cfc:	66 90                	xchg   %ax,%ax
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d08:	53                   	push   %ebx
80104d09:	83 ec 34             	sub    $0x34,%esp
80104d0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d12:	57                   	push   %edi
80104d13:	50                   	push   %eax
{
80104d14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d1a:	e8 a1 d3 ff ff       	call   801020c0 <nameiparent>
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	85 c0                	test   %eax,%eax
80104d24:	0f 84 46 01 00 00    	je     80104e70 <create+0x170>
    return 0;
  ilock(dp);
80104d2a:	83 ec 0c             	sub    $0xc,%esp
80104d2d:	89 c3                	mov    %eax,%ebx
80104d2f:	50                   	push   %eax
80104d30:	e8 4b ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d35:	83 c4 0c             	add    $0xc,%esp
80104d38:	6a 00                	push   $0x0
80104d3a:	57                   	push   %edi
80104d3b:	53                   	push   %ebx
80104d3c:	e8 9f cf ff ff       	call   80101ce0 <dirlookup>
80104d41:	83 c4 10             	add    $0x10,%esp
80104d44:	89 c6                	mov    %eax,%esi
80104d46:	85 c0                	test   %eax,%eax
80104d48:	74 56                	je     80104da0 <create+0xa0>
    iunlockput(dp);
80104d4a:	83 ec 0c             	sub    $0xc,%esp
80104d4d:	53                   	push   %ebx
80104d4e:	e8 bd cc ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104d53:	89 34 24             	mov    %esi,(%esp)
80104d56:	e8 25 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d5b:	83 c4 10             	add    $0x10,%esp
80104d5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d63:	75 1b                	jne    80104d80 <create+0x80>
80104d65:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d6a:	75 14                	jne    80104d80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d6f:	89 f0                	mov    %esi,%eax
80104d71:	5b                   	pop    %ebx
80104d72:	5e                   	pop    %esi
80104d73:	5f                   	pop    %edi
80104d74:	5d                   	pop    %ebp
80104d75:	c3                   	ret    
80104d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d80:	83 ec 0c             	sub    $0xc,%esp
80104d83:	56                   	push   %esi
    return 0;
80104d84:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d86:	e8 85 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d8b:	83 c4 10             	add    $0x10,%esp
}
80104d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d91:	89 f0                	mov    %esi,%eax
80104d93:	5b                   	pop    %ebx
80104d94:	5e                   	pop    %esi
80104d95:	5f                   	pop    %edi
80104d96:	5d                   	pop    %ebp
80104d97:	c3                   	ret    
80104d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104da0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104da4:	83 ec 08             	sub    $0x8,%esp
80104da7:	50                   	push   %eax
80104da8:	ff 33                	push   (%ebx)
80104daa:	e8 61 c8 ff ff       	call   80101610 <ialloc>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	89 c6                	mov    %eax,%esi
80104db4:	85 c0                	test   %eax,%eax
80104db6:	0f 84 cd 00 00 00    	je     80104e89 <create+0x189>
  ilock(ip);
80104dbc:	83 ec 0c             	sub    $0xc,%esp
80104dbf:	50                   	push   %eax
80104dc0:	e8 bb c9 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104dc5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104dc9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104dcd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104dd1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104dd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dda:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dde:	89 34 24             	mov    %esi,(%esp)
80104de1:	e8 ea c8 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104de6:	83 c4 10             	add    $0x10,%esp
80104de9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dee:	74 30                	je     80104e20 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104df0:	83 ec 04             	sub    $0x4,%esp
80104df3:	ff 76 04             	push   0x4(%esi)
80104df6:	57                   	push   %edi
80104df7:	53                   	push   %ebx
80104df8:	e8 e3 d1 ff ff       	call   80101fe0 <dirlink>
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	85 c0                	test   %eax,%eax
80104e02:	78 78                	js     80104e7c <create+0x17c>
  iunlockput(dp);
80104e04:	83 ec 0c             	sub    $0xc,%esp
80104e07:	53                   	push   %ebx
80104e08:	e8 03 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104e0d:	83 c4 10             	add    $0x10,%esp
}
80104e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e13:	89 f0                	mov    %esi,%eax
80104e15:	5b                   	pop    %ebx
80104e16:	5e                   	pop    %esi
80104e17:	5f                   	pop    %edi
80104e18:	5d                   	pop    %ebp
80104e19:	c3                   	ret    
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e28:	53                   	push   %ebx
80104e29:	e8 a2 c8 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e2e:	83 c4 0c             	add    $0xc,%esp
80104e31:	ff 76 04             	push   0x4(%esi)
80104e34:	68 a0 7e 10 80       	push   $0x80107ea0
80104e39:	56                   	push   %esi
80104e3a:	e8 a1 d1 ff ff       	call   80101fe0 <dirlink>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	85 c0                	test   %eax,%eax
80104e44:	78 18                	js     80104e5e <create+0x15e>
80104e46:	83 ec 04             	sub    $0x4,%esp
80104e49:	ff 73 04             	push   0x4(%ebx)
80104e4c:	68 9f 7e 10 80       	push   $0x80107e9f
80104e51:	56                   	push   %esi
80104e52:	e8 89 d1 ff ff       	call   80101fe0 <dirlink>
80104e57:	83 c4 10             	add    $0x10,%esp
80104e5a:	85 c0                	test   %eax,%eax
80104e5c:	79 92                	jns    80104df0 <create+0xf0>
      panic("create dots");
80104e5e:	83 ec 0c             	sub    $0xc,%esp
80104e61:	68 93 7e 10 80       	push   $0x80107e93
80104e66:	e8 15 b5 ff ff       	call   80100380 <panic>
80104e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e6f:	90                   	nop
}
80104e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e73:	31 f6                	xor    %esi,%esi
}
80104e75:	5b                   	pop    %ebx
80104e76:	89 f0                	mov    %esi,%eax
80104e78:	5e                   	pop    %esi
80104e79:	5f                   	pop    %edi
80104e7a:	5d                   	pop    %ebp
80104e7b:	c3                   	ret    
    panic("create: dirlink");
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	68 a2 7e 10 80       	push   $0x80107ea2
80104e84:	e8 f7 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e89:	83 ec 0c             	sub    $0xc,%esp
80104e8c:	68 84 7e 10 80       	push   $0x80107e84
80104e91:	e8 ea b4 ff ff       	call   80100380 <panic>
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <sys_dup>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ea5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ea8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eab:	50                   	push   %eax
80104eac:	6a 00                	push   $0x0
80104eae:	e8 9d fc ff ff       	call   80104b50 <argint>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 36                	js     80104ef0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ebe:	77 30                	ja     80104ef0 <sys_dup+0x50>
80104ec0:	e8 5b ec ff ff       	call   80103b20 <myproc>
80104ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ec8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104ecc:	85 f6                	test   %esi,%esi
80104ece:	74 20                	je     80104ef0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ed0:	e8 4b ec ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ed5:	31 db                	xor    %ebx,%ebx
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ee0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104ee4:	85 d2                	test   %edx,%edx
80104ee6:	74 18                	je     80104f00 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ee8:	83 c3 01             	add    $0x1,%ebx
80104eeb:	83 fb 10             	cmp    $0x10,%ebx
80104eee:	75 f0                	jne    80104ee0 <sys_dup+0x40>
}
80104ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ef3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ef8:	89 d8                	mov    %ebx,%eax
80104efa:	5b                   	pop    %ebx
80104efb:	5e                   	pop    %esi
80104efc:	5d                   	pop    %ebp
80104efd:	c3                   	ret    
80104efe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f00:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f03:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104f07:	56                   	push   %esi
80104f08:	e8 93 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104f0d:	83 c4 10             	add    $0x10,%esp
}
80104f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f13:	89 d8                	mov    %ebx,%eax
80104f15:	5b                   	pop    %ebx
80104f16:	5e                   	pop    %esi
80104f17:	5d                   	pop    %ebp
80104f18:	c3                   	ret    
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f20 <sys_read>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	53                   	push   %ebx
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 1d fc ff ff       	call   80104b50 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 5e                	js     80104f98 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 58                	ja     80104f98 <sys_read+0x78>
80104f40:	e8 db eb ff ff       	call   80103b20 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 48                	je     80104f98 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f50:	83 ec 08             	sub    $0x8,%esp
80104f53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f56:	50                   	push   %eax
80104f57:	6a 02                	push   $0x2
80104f59:	e8 f2 fb ff ff       	call   80104b50 <argint>
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	85 c0                	test   %eax,%eax
80104f63:	78 33                	js     80104f98 <sys_read+0x78>
80104f65:	83 ec 04             	sub    $0x4,%esp
80104f68:	ff 75 f0             	push   -0x10(%ebp)
80104f6b:	53                   	push   %ebx
80104f6c:	6a 01                	push   $0x1
80104f6e:	e8 2d fc ff ff       	call   80104ba0 <argptr>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 1e                	js     80104f98 <sys_read+0x78>
  return fileread(f, p, n);
80104f7a:	83 ec 04             	sub    $0x4,%esp
80104f7d:	ff 75 f0             	push   -0x10(%ebp)
80104f80:	ff 75 f4             	push   -0xc(%ebp)
80104f83:	56                   	push   %esi
80104f84:	e8 97 c0 ff ff       	call   80101020 <fileread>
80104f89:	83 c4 10             	add    $0x10,%esp
}
80104f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f8f:	5b                   	pop    %ebx
80104f90:	5e                   	pop    %esi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f97:	90                   	nop
    return -1;
80104f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9d:	eb ed                	jmp    80104f8c <sys_read+0x6c>
80104f9f:	90                   	nop

80104fa0 <sys_write>:
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
80104fae:	e8 9d fb ff ff       	call   80104b50 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 5e                	js     80105018 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 58                	ja     80105018 <sys_write+0x78>
80104fc0:	e8 5b eb ff ff       	call   80103b20 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 48                	je     80105018 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	6a 02                	push   $0x2
80104fd9:	e8 72 fb ff ff       	call   80104b50 <argint>
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 33                	js     80105018 <sys_write+0x78>
80104fe5:	83 ec 04             	sub    $0x4,%esp
80104fe8:	ff 75 f0             	push   -0x10(%ebp)
80104feb:	53                   	push   %ebx
80104fec:	6a 01                	push   $0x1
80104fee:	e8 ad fb ff ff       	call   80104ba0 <argptr>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 1e                	js     80105018 <sys_write+0x78>
  return filewrite(f, p, n);
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	ff 75 f0             	push   -0x10(%ebp)
80105000:	ff 75 f4             	push   -0xc(%ebp)
80105003:	56                   	push   %esi
80105004:	e8 a7 c0 ff ff       	call   801010b0 <filewrite>
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
8010501d:	eb ed                	jmp    8010500c <sys_write+0x6c>
8010501f:	90                   	nop

80105020 <sys_close>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	50                   	push   %eax
8010502c:	6a 00                	push   $0x0
8010502e:	e8 1d fb ff ff       	call   80104b50 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 3e                	js     80105078 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 38                	ja     80105078 <sys_close+0x58>
80105040:	e8 db ea ff ff       	call   80103b20 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8d 5a 08             	lea    0x8(%edx),%ebx
8010504b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010504f:	85 f6                	test   %esi,%esi
80105051:	74 25                	je     80105078 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105053:	e8 c8 ea ff ff       	call   80103b20 <myproc>
  fileclose(f);
80105058:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010505b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
80105062:	00 
  fileclose(f);
80105063:	56                   	push   %esi
80105064:	e8 87 be ff ff       	call   80100ef0 <fileclose>
  return 0;
80105069:	83 c4 10             	add    $0x10,%esp
8010506c:	31 c0                	xor    %eax,%eax
}
8010506e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105071:	5b                   	pop    %ebx
80105072:	5e                   	pop    %esi
80105073:	5d                   	pop    %ebp
80105074:	c3                   	ret    
80105075:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507d:	eb ef                	jmp    8010506e <sys_close+0x4e>
8010507f:	90                   	nop

80105080 <sys_fstat>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105085:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105088:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010508b:	53                   	push   %ebx
8010508c:	6a 00                	push   $0x0
8010508e:	e8 bd fa ff ff       	call   80104b50 <argint>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	78 46                	js     801050e0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010509a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010509e:	77 40                	ja     801050e0 <sys_fstat+0x60>
801050a0:	e8 7b ea ff ff       	call   80103b20 <myproc>
801050a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050a8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801050ac:	85 f6                	test   %esi,%esi
801050ae:	74 30                	je     801050e0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050b0:	83 ec 04             	sub    $0x4,%esp
801050b3:	6a 14                	push   $0x14
801050b5:	53                   	push   %ebx
801050b6:	6a 01                	push   $0x1
801050b8:	e8 e3 fa ff ff       	call   80104ba0 <argptr>
801050bd:	83 c4 10             	add    $0x10,%esp
801050c0:	85 c0                	test   %eax,%eax
801050c2:	78 1c                	js     801050e0 <sys_fstat+0x60>
  return filestat(f, st);
801050c4:	83 ec 08             	sub    $0x8,%esp
801050c7:	ff 75 f4             	push   -0xc(%ebp)
801050ca:	56                   	push   %esi
801050cb:	e8 00 bf ff ff       	call   80100fd0 <filestat>
801050d0:	83 c4 10             	add    $0x10,%esp
}
801050d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050d6:	5b                   	pop    %ebx
801050d7:	5e                   	pop    %esi
801050d8:	5d                   	pop    %ebp
801050d9:	c3                   	ret    
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050e5:	eb ec                	jmp    801050d3 <sys_fstat+0x53>
801050e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ee:	66 90                	xchg   %ax,%ax

801050f0 <sys_link>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050f8:	53                   	push   %ebx
801050f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050fc:	50                   	push   %eax
801050fd:	6a 00                	push   $0x0
801050ff:	e8 0c fb ff ff       	call   80104c10 <argstr>
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
80105109:	0f 88 fb 00 00 00    	js     8010520a <sys_link+0x11a>
8010510f:	83 ec 08             	sub    $0x8,%esp
80105112:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105115:	50                   	push   %eax
80105116:	6a 01                	push   $0x1
80105118:	e8 f3 fa ff ff       	call   80104c10 <argstr>
8010511d:	83 c4 10             	add    $0x10,%esp
80105120:	85 c0                	test   %eax,%eax
80105122:	0f 88 e2 00 00 00    	js     8010520a <sys_link+0x11a>
  begin_op();
80105128:	e8 e3 dd ff ff       	call   80102f10 <begin_op>
  if((ip = namei(old)) == 0){
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	ff 75 d4             	push   -0x2c(%ebp)
80105133:	e8 68 cf ff ff       	call   801020a0 <namei>
80105138:	83 c4 10             	add    $0x10,%esp
8010513b:	89 c3                	mov    %eax,%ebx
8010513d:	85 c0                	test   %eax,%eax
8010513f:	0f 84 e4 00 00 00    	je     80105229 <sys_link+0x139>
  ilock(ip);
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	50                   	push   %eax
80105149:	e8 32 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010514e:	83 c4 10             	add    $0x10,%esp
80105151:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105156:	0f 84 b5 00 00 00    	je     80105211 <sys_link+0x121>
  iupdate(ip);
8010515c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010515f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105164:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105167:	53                   	push   %ebx
80105168:	e8 63 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010516d:	89 1c 24             	mov    %ebx,(%esp)
80105170:	e8 eb c6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105175:	58                   	pop    %eax
80105176:	5a                   	pop    %edx
80105177:	57                   	push   %edi
80105178:	ff 75 d0             	push   -0x30(%ebp)
8010517b:	e8 40 cf ff ff       	call   801020c0 <nameiparent>
80105180:	83 c4 10             	add    $0x10,%esp
80105183:	89 c6                	mov    %eax,%esi
80105185:	85 c0                	test   %eax,%eax
80105187:	74 5b                	je     801051e4 <sys_link+0xf4>
  ilock(dp);
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	50                   	push   %eax
8010518d:	e8 ee c5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105192:	8b 03                	mov    (%ebx),%eax
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	39 06                	cmp    %eax,(%esi)
80105199:	75 3d                	jne    801051d8 <sys_link+0xe8>
8010519b:	83 ec 04             	sub    $0x4,%esp
8010519e:	ff 73 04             	push   0x4(%ebx)
801051a1:	57                   	push   %edi
801051a2:	56                   	push   %esi
801051a3:	e8 38 ce ff ff       	call   80101fe0 <dirlink>
801051a8:	83 c4 10             	add    $0x10,%esp
801051ab:	85 c0                	test   %eax,%eax
801051ad:	78 29                	js     801051d8 <sys_link+0xe8>
  iunlockput(dp);
801051af:	83 ec 0c             	sub    $0xc,%esp
801051b2:	56                   	push   %esi
801051b3:	e8 58 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801051b8:	89 1c 24             	mov    %ebx,(%esp)
801051bb:	e8 f0 c6 ff ff       	call   801018b0 <iput>
  end_op();
801051c0:	e8 bb dd ff ff       	call   80102f80 <end_op>
  return 0;
801051c5:	83 c4 10             	add    $0x10,%esp
801051c8:	31 c0                	xor    %eax,%eax
}
801051ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051cd:	5b                   	pop    %ebx
801051ce:	5e                   	pop    %esi
801051cf:	5f                   	pop    %edi
801051d0:	5d                   	pop    %ebp
801051d1:	c3                   	ret    
801051d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051d8:	83 ec 0c             	sub    $0xc,%esp
801051db:	56                   	push   %esi
801051dc:	e8 2f c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051e4:	83 ec 0c             	sub    $0xc,%esp
801051e7:	53                   	push   %ebx
801051e8:	e8 93 c5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801051ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051f2:	89 1c 24             	mov    %ebx,(%esp)
801051f5:	e8 d6 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801051fa:	89 1c 24             	mov    %ebx,(%esp)
801051fd:	e8 0e c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105202:	e8 79 dd ff ff       	call   80102f80 <end_op>
  return -1;
80105207:	83 c4 10             	add    $0x10,%esp
8010520a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520f:	eb b9                	jmp    801051ca <sys_link+0xda>
    iunlockput(ip);
80105211:	83 ec 0c             	sub    $0xc,%esp
80105214:	53                   	push   %ebx
80105215:	e8 f6 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010521a:	e8 61 dd ff ff       	call   80102f80 <end_op>
    return -1;
8010521f:	83 c4 10             	add    $0x10,%esp
80105222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105227:	eb a1                	jmp    801051ca <sys_link+0xda>
    end_op();
80105229:	e8 52 dd ff ff       	call   80102f80 <end_op>
    return -1;
8010522e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105233:	eb 95                	jmp    801051ca <sys_link+0xda>
80105235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105240 <sys_unlink>:
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105245:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105248:	53                   	push   %ebx
80105249:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010524c:	50                   	push   %eax
8010524d:	6a 00                	push   $0x0
8010524f:	e8 bc f9 ff ff       	call   80104c10 <argstr>
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	85 c0                	test   %eax,%eax
80105259:	0f 88 7a 01 00 00    	js     801053d9 <sys_unlink+0x199>
  begin_op();
8010525f:	e8 ac dc ff ff       	call   80102f10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105264:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105267:	83 ec 08             	sub    $0x8,%esp
8010526a:	53                   	push   %ebx
8010526b:	ff 75 c0             	push   -0x40(%ebp)
8010526e:	e8 4d ce ff ff       	call   801020c0 <nameiparent>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105279:	85 c0                	test   %eax,%eax
8010527b:	0f 84 62 01 00 00    	je     801053e3 <sys_unlink+0x1a3>
  ilock(dp);
80105281:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105284:	83 ec 0c             	sub    $0xc,%esp
80105287:	57                   	push   %edi
80105288:	e8 f3 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010528d:	58                   	pop    %eax
8010528e:	5a                   	pop    %edx
8010528f:	68 a0 7e 10 80       	push   $0x80107ea0
80105294:	53                   	push   %ebx
80105295:	e8 26 ca ff ff       	call   80101cc0 <namecmp>
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	85 c0                	test   %eax,%eax
8010529f:	0f 84 fb 00 00 00    	je     801053a0 <sys_unlink+0x160>
801052a5:	83 ec 08             	sub    $0x8,%esp
801052a8:	68 9f 7e 10 80       	push   $0x80107e9f
801052ad:	53                   	push   %ebx
801052ae:	e8 0d ca ff ff       	call   80101cc0 <namecmp>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	0f 84 e2 00 00 00    	je     801053a0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052be:	83 ec 04             	sub    $0x4,%esp
801052c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052c4:	50                   	push   %eax
801052c5:	53                   	push   %ebx
801052c6:	57                   	push   %edi
801052c7:	e8 14 ca ff ff       	call   80101ce0 <dirlookup>
801052cc:	83 c4 10             	add    $0x10,%esp
801052cf:	89 c3                	mov    %eax,%ebx
801052d1:	85 c0                	test   %eax,%eax
801052d3:	0f 84 c7 00 00 00    	je     801053a0 <sys_unlink+0x160>
  ilock(ip);
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	50                   	push   %eax
801052dd:	e8 9e c4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801052e2:	83 c4 10             	add    $0x10,%esp
801052e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052ea:	0f 8e 1c 01 00 00    	jle    8010540c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052f8:	74 66                	je     80105360 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052fa:	83 ec 04             	sub    $0x4,%esp
801052fd:	6a 10                	push   $0x10
801052ff:	6a 00                	push   $0x0
80105301:	57                   	push   %edi
80105302:	e8 89 f5 ff ff       	call   80104890 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105307:	6a 10                	push   $0x10
80105309:	ff 75 c4             	push   -0x3c(%ebp)
8010530c:	57                   	push   %edi
8010530d:	ff 75 b4             	push   -0x4c(%ebp)
80105310:	e8 7b c8 ff ff       	call   80101b90 <writei>
80105315:	83 c4 20             	add    $0x20,%esp
80105318:	83 f8 10             	cmp    $0x10,%eax
8010531b:	0f 85 de 00 00 00    	jne    801053ff <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105321:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105326:	0f 84 94 00 00 00    	je     801053c0 <sys_unlink+0x180>
  iunlockput(dp);
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	ff 75 b4             	push   -0x4c(%ebp)
80105332:	e8 d9 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105337:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010533c:	89 1c 24             	mov    %ebx,(%esp)
8010533f:	e8 8c c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105344:	89 1c 24             	mov    %ebx,(%esp)
80105347:	e8 c4 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010534c:	e8 2f dc ff ff       	call   80102f80 <end_op>
  return 0;
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	31 c0                	xor    %eax,%eax
}
80105356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105359:	5b                   	pop    %ebx
8010535a:	5e                   	pop    %esi
8010535b:	5f                   	pop    %edi
8010535c:	5d                   	pop    %ebp
8010535d:	c3                   	ret    
8010535e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105360:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105364:	76 94                	jbe    801052fa <sys_unlink+0xba>
80105366:	be 20 00 00 00       	mov    $0x20,%esi
8010536b:	eb 0b                	jmp    80105378 <sys_unlink+0x138>
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
80105370:	83 c6 10             	add    $0x10,%esi
80105373:	3b 73 58             	cmp    0x58(%ebx),%esi
80105376:	73 82                	jae    801052fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105378:	6a 10                	push   $0x10
8010537a:	56                   	push   %esi
8010537b:	57                   	push   %edi
8010537c:	53                   	push   %ebx
8010537d:	e8 0e c7 ff ff       	call   80101a90 <readi>
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	83 f8 10             	cmp    $0x10,%eax
80105388:	75 68                	jne    801053f2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010538a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010538f:	74 df                	je     80105370 <sys_unlink+0x130>
    iunlockput(ip);
80105391:	83 ec 0c             	sub    $0xc,%esp
80105394:	53                   	push   %ebx
80105395:	e8 76 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	ff 75 b4             	push   -0x4c(%ebp)
801053a6:	e8 65 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053ab:	e8 d0 db ff ff       	call   80102f80 <end_op>
  return -1;
801053b0:	83 c4 10             	add    $0x10,%esp
801053b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b8:	eb 9c                	jmp    80105356 <sys_unlink+0x116>
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053c3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053c6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053cb:	50                   	push   %eax
801053cc:	e8 ff c2 ff ff       	call   801016d0 <iupdate>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	e9 53 ff ff ff       	jmp    8010532c <sys_unlink+0xec>
    return -1;
801053d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053de:	e9 73 ff ff ff       	jmp    80105356 <sys_unlink+0x116>
    end_op();
801053e3:	e8 98 db ff ff       	call   80102f80 <end_op>
    return -1;
801053e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ed:	e9 64 ff ff ff       	jmp    80105356 <sys_unlink+0x116>
      panic("isdirempty: readi");
801053f2:	83 ec 0c             	sub    $0xc,%esp
801053f5:	68 c4 7e 10 80       	push   $0x80107ec4
801053fa:	e8 81 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053ff:	83 ec 0c             	sub    $0xc,%esp
80105402:	68 d6 7e 10 80       	push   $0x80107ed6
80105407:	e8 74 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010540c:	83 ec 0c             	sub    $0xc,%esp
8010540f:	68 b2 7e 10 80       	push   $0x80107eb2
80105414:	e8 67 af ff ff       	call   80100380 <panic>
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_open>:

int
sys_open(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	57                   	push   %edi
80105424:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105425:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105428:	53                   	push   %ebx
80105429:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010542c:	50                   	push   %eax
8010542d:	6a 00                	push   $0x0
8010542f:	e8 dc f7 ff ff       	call   80104c10 <argstr>
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	85 c0                	test   %eax,%eax
80105439:	0f 88 8e 00 00 00    	js     801054cd <sys_open+0xad>
8010543f:	83 ec 08             	sub    $0x8,%esp
80105442:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105445:	50                   	push   %eax
80105446:	6a 01                	push   $0x1
80105448:	e8 03 f7 ff ff       	call   80104b50 <argint>
8010544d:	83 c4 10             	add    $0x10,%esp
80105450:	85 c0                	test   %eax,%eax
80105452:	78 79                	js     801054cd <sys_open+0xad>
    return -1;

  begin_op();
80105454:	e8 b7 da ff ff       	call   80102f10 <begin_op>

  if(omode & O_CREATE){
80105459:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010545d:	75 79                	jne    801054d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	ff 75 e0             	push   -0x20(%ebp)
80105465:	e8 36 cc ff ff       	call   801020a0 <namei>
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	89 c6                	mov    %eax,%esi
8010546f:	85 c0                	test   %eax,%eax
80105471:	0f 84 7e 00 00 00    	je     801054f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105477:	83 ec 0c             	sub    $0xc,%esp
8010547a:	50                   	push   %eax
8010547b:	e8 00 c3 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105488:	0f 84 c2 00 00 00    	je     80105550 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010548e:	e8 9d b9 ff ff       	call   80100e30 <filealloc>
80105493:	89 c7                	mov    %eax,%edi
80105495:	85 c0                	test   %eax,%eax
80105497:	74 23                	je     801054bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105499:	e8 82 e6 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010549e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054a0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801054a4:	85 d2                	test   %edx,%edx
801054a6:	74 60                	je     80105508 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054a8:	83 c3 01             	add    $0x1,%ebx
801054ab:	83 fb 10             	cmp    $0x10,%ebx
801054ae:	75 f0                	jne    801054a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	57                   	push   %edi
801054b4:	e8 37 ba ff ff       	call   80100ef0 <fileclose>
801054b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054bc:	83 ec 0c             	sub    $0xc,%esp
801054bf:	56                   	push   %esi
801054c0:	e8 4b c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054c5:	e8 b6 da ff ff       	call   80102f80 <end_op>
    return -1;
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054d2:	eb 6d                	jmp    80105541 <sys_open+0x121>
801054d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054de:	31 c9                	xor    %ecx,%ecx
801054e0:	ba 02 00 00 00       	mov    $0x2,%edx
801054e5:	6a 00                	push   $0x0
801054e7:	e8 14 f8 ff ff       	call   80104d00 <create>
    if(ip == 0){
801054ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054f1:	85 c0                	test   %eax,%eax
801054f3:	75 99                	jne    8010548e <sys_open+0x6e>
      end_op();
801054f5:	e8 86 da ff ff       	call   80102f80 <end_op>
      return -1;
801054fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054ff:	eb 40                	jmp    80105541 <sys_open+0x121>
80105501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105508:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010550b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010550f:	56                   	push   %esi
80105510:	e8 4b c3 ff ff       	call   80101860 <iunlock>
  end_op();
80105515:	e8 66 da ff ff       	call   80102f80 <end_op>

  f->type = FD_INODE;
8010551a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105523:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105526:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105529:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010552b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105532:	f7 d0                	not    %eax
80105534:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105537:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010553a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010553d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105544:	89 d8                	mov    %ebx,%eax
80105546:	5b                   	pop    %ebx
80105547:	5e                   	pop    %esi
80105548:	5f                   	pop    %edi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105550:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105553:	85 c9                	test   %ecx,%ecx
80105555:	0f 84 33 ff ff ff    	je     8010548e <sys_open+0x6e>
8010555b:	e9 5c ff ff ff       	jmp    801054bc <sys_open+0x9c>

80105560 <sys_mkdir>:

int
sys_mkdir(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105566:	e8 a5 d9 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105571:	50                   	push   %eax
80105572:	6a 00                	push   $0x0
80105574:	e8 97 f6 ff ff       	call   80104c10 <argstr>
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	85 c0                	test   %eax,%eax
8010557e:	78 30                	js     801055b0 <sys_mkdir+0x50>
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105586:	31 c9                	xor    %ecx,%ecx
80105588:	ba 01 00 00 00       	mov    $0x1,%edx
8010558d:	6a 00                	push   $0x0
8010558f:	e8 6c f7 ff ff       	call   80104d00 <create>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	74 15                	je     801055b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010559b:	83 ec 0c             	sub    $0xc,%esp
8010559e:	50                   	push   %eax
8010559f:	e8 6c c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055a4:	e8 d7 d9 ff ff       	call   80102f80 <end_op>
  return 0;
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	31 c0                	xor    %eax,%eax
}
801055ae:	c9                   	leave  
801055af:	c3                   	ret    
    end_op();
801055b0:	e8 cb d9 ff ff       	call   80102f80 <end_op>
    return -1;
801055b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ba:	c9                   	leave  
801055bb:	c3                   	ret    
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_mknod>:

int
sys_mknod(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055c6:	e8 45 d9 ff ff       	call   80102f10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055cb:	83 ec 08             	sub    $0x8,%esp
801055ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055d1:	50                   	push   %eax
801055d2:	6a 00                	push   $0x0
801055d4:	e8 37 f6 ff ff       	call   80104c10 <argstr>
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	85 c0                	test   %eax,%eax
801055de:	78 60                	js     80105640 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e6:	50                   	push   %eax
801055e7:	6a 01                	push   $0x1
801055e9:	e8 62 f5 ff ff       	call   80104b50 <argint>
  if((argstr(0, &path)) < 0 ||
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 4b                	js     80105640 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055f5:	83 ec 08             	sub    $0x8,%esp
801055f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055fb:	50                   	push   %eax
801055fc:	6a 02                	push   $0x2
801055fe:	e8 4d f5 ff ff       	call   80104b50 <argint>
     argint(1, &major) < 0 ||
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	78 36                	js     80105640 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010560a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010560e:	83 ec 0c             	sub    $0xc,%esp
80105611:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105615:	ba 03 00 00 00       	mov    $0x3,%edx
8010561a:	50                   	push   %eax
8010561b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010561e:	e8 dd f6 ff ff       	call   80104d00 <create>
     argint(2, &minor) < 0 ||
80105623:	83 c4 10             	add    $0x10,%esp
80105626:	85 c0                	test   %eax,%eax
80105628:	74 16                	je     80105640 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010562a:	83 ec 0c             	sub    $0xc,%esp
8010562d:	50                   	push   %eax
8010562e:	e8 dd c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105633:	e8 48 d9 ff ff       	call   80102f80 <end_op>
  return 0;
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	31 c0                	xor    %eax,%eax
}
8010563d:	c9                   	leave  
8010563e:	c3                   	ret    
8010563f:	90                   	nop
    end_op();
80105640:	e8 3b d9 ff ff       	call   80102f80 <end_op>
    return -1;
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_chdir>:

int
sys_chdir(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	56                   	push   %esi
80105654:	53                   	push   %ebx
80105655:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105658:	e8 c3 e4 ff ff       	call   80103b20 <myproc>
8010565d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010565f:	e8 ac d8 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105664:	83 ec 08             	sub    $0x8,%esp
80105667:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566a:	50                   	push   %eax
8010566b:	6a 00                	push   $0x0
8010566d:	e8 9e f5 ff ff       	call   80104c10 <argstr>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	85 c0                	test   %eax,%eax
80105677:	78 77                	js     801056f0 <sys_chdir+0xa0>
80105679:	83 ec 0c             	sub    $0xc,%esp
8010567c:	ff 75 f4             	push   -0xc(%ebp)
8010567f:	e8 1c ca ff ff       	call   801020a0 <namei>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	89 c3                	mov    %eax,%ebx
80105689:	85 c0                	test   %eax,%eax
8010568b:	74 63                	je     801056f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	50                   	push   %eax
80105691:	e8 ea c0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105696:	83 c4 10             	add    $0x10,%esp
80105699:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010569e:	75 30                	jne    801056d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	53                   	push   %ebx
801056a4:	e8 b7 c1 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801056a9:	58                   	pop    %eax
801056aa:	ff 76 6c             	push   0x6c(%esi)
801056ad:	e8 fe c1 ff ff       	call   801018b0 <iput>
  end_op();
801056b2:	e8 c9 d8 ff ff       	call   80102f80 <end_op>
  curproc->cwd = ip;
801056b7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	31 c0                	xor    %eax,%eax
}
801056bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056c2:	5b                   	pop    %ebx
801056c3:	5e                   	pop    %esi
801056c4:	5d                   	pop    %ebp
801056c5:	c3                   	ret    
801056c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 37 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056d9:	e8 a2 d8 ff ff       	call   80102f80 <end_op>
    return -1;
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e6:	eb d7                	jmp    801056bf <sys_chdir+0x6f>
801056e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop
    end_op();
801056f0:	e8 8b d8 ff ff       	call   80102f80 <end_op>
    return -1;
801056f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fa:	eb c3                	jmp    801056bf <sys_chdir+0x6f>
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_exec>:

int
sys_exec(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105705:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010570b:	53                   	push   %ebx
8010570c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105712:	50                   	push   %eax
80105713:	6a 00                	push   $0x0
80105715:	e8 f6 f4 ff ff       	call   80104c10 <argstr>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	0f 88 87 00 00 00    	js     801057ac <sys_exec+0xac>
80105725:	83 ec 08             	sub    $0x8,%esp
80105728:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010572e:	50                   	push   %eax
8010572f:	6a 01                	push   $0x1
80105731:	e8 1a f4 ff ff       	call   80104b50 <argint>
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	85 c0                	test   %eax,%eax
8010573b:	78 6f                	js     801057ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010573d:	83 ec 04             	sub    $0x4,%esp
80105740:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105746:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105748:	68 80 00 00 00       	push   $0x80
8010574d:	6a 00                	push   $0x0
8010574f:	56                   	push   %esi
80105750:	e8 3b f1 ff ff       	call   80104890 <memset>
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105769:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105770:	50                   	push   %eax
80105771:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105777:	01 f8                	add    %edi,%eax
80105779:	50                   	push   %eax
8010577a:	e8 41 f3 ff ff       	call   80104ac0 <fetchint>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	85 c0                	test   %eax,%eax
80105784:	78 26                	js     801057ac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105786:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010578c:	85 c0                	test   %eax,%eax
8010578e:	74 30                	je     801057c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105790:	83 ec 08             	sub    $0x8,%esp
80105793:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105796:	52                   	push   %edx
80105797:	50                   	push   %eax
80105798:	e8 63 f3 ff ff       	call   80104b00 <fetchstr>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 08                	js     801057ac <sys_exec+0xac>
  for(i=0;; i++){
801057a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057a7:	83 fb 20             	cmp    $0x20,%ebx
801057aa:	75 b4                	jne    80105760 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057c0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057c7:	00 00 00 00 
  return exec(path, argv);
801057cb:	83 ec 08             	sub    $0x8,%esp
801057ce:	56                   	push   %esi
801057cf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057d5:	e8 d6 b2 ff ff       	call   80100ab0 <exec>
801057da:	83 c4 10             	add    $0x10,%esp
}
801057dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e0:	5b                   	pop    %ebx
801057e1:	5e                   	pop    %esi
801057e2:	5f                   	pop    %edi
801057e3:	5d                   	pop    %ebp
801057e4:	c3                   	ret    
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_pipe>:

int
sys_pipe(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057f8:	53                   	push   %ebx
801057f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057fc:	6a 08                	push   $0x8
801057fe:	50                   	push   %eax
801057ff:	6a 00                	push   $0x0
80105801:	e8 9a f3 ff ff       	call   80104ba0 <argptr>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 4a                	js     80105857 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010580d:	83 ec 08             	sub    $0x8,%esp
80105810:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105813:	50                   	push   %eax
80105814:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105817:	50                   	push   %eax
80105818:	e8 c3 dd ff ff       	call   801035e0 <pipealloc>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 33                	js     80105857 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105824:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105827:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105829:	e8 f2 e2 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010582e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105830:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105834:	85 f6                	test   %esi,%esi
80105836:	74 28                	je     80105860 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105838:	83 c3 01             	add    $0x1,%ebx
8010583b:	83 fb 10             	cmp    $0x10,%ebx
8010583e:	75 f0                	jne    80105830 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	ff 75 e0             	push   -0x20(%ebp)
80105846:	e8 a5 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010584b:	58                   	pop    %eax
8010584c:	ff 75 e4             	push   -0x1c(%ebp)
8010584f:	e8 9c b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585c:	eb 53                	jmp    801058b1 <sys_pipe+0xc1>
8010585e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105860:	8d 73 08             	lea    0x8(%ebx),%esi
80105863:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105867:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010586a:	e8 b1 e2 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010586f:	31 d2                	xor    %edx,%edx
80105871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105878:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
8010587c:	85 c9                	test   %ecx,%ecx
8010587e:	74 20                	je     801058a0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105880:	83 c2 01             	add    $0x1,%edx
80105883:	83 fa 10             	cmp    $0x10,%edx
80105886:	75 f0                	jne    80105878 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105888:	e8 93 e2 ff ff       	call   80103b20 <myproc>
8010588d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105894:	00 
80105895:	eb a9                	jmp    80105840 <sys_pipe+0x50>
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058a0:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
801058a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058af:	31 c0                	xor    %eax,%eax
}
801058b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b4:	5b                   	pop    %ebx
801058b5:	5e                   	pop    %esi
801058b6:	5f                   	pop    %edi
801058b7:	5d                   	pop    %ebp
801058b8:	c3                   	ret    
801058b9:	66 90                	xchg   %ax,%ax
801058bb:	66 90                	xchg   %ax,%ax
801058bd:	66 90                	xchg   %ax,%ax
801058bf:	90                   	nop

801058c0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801058c0:	e9 7b e4 ff ff       	jmp    80103d40 <fork>
801058c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_exit>:
}

int
sys_exit(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058d6:	e8 e5 e6 ff ff       	call   80103fc0 <exit>
  return 0;  // not reached
}
801058db:	31 c0                	xor    %eax,%eax
801058dd:	c9                   	leave  
801058de:	c3                   	ret    
801058df:	90                   	nop

801058e0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058e0:	e9 0b e8 ff ff       	jmp    801040f0 <wait>
801058e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_kill>:
}

int
sys_kill(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058f9:	50                   	push   %eax
801058fa:	6a 00                	push   $0x0
801058fc:	e8 4f f2 ff ff       	call   80104b50 <argint>
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	85 c0                	test   %eax,%eax
80105906:	78 18                	js     80105920 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105908:	83 ec 0c             	sub    $0xc,%esp
8010590b:	ff 75 f4             	push   -0xc(%ebp)
8010590e:	e8 7d ea ff ff       	call   80104390 <kill>
80105913:	83 c4 10             	add    $0x10,%esp
}
80105916:	c9                   	leave  
80105917:	c3                   	ret    
80105918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
80105920:	c9                   	leave  
    return -1;
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105926:	c3                   	ret    
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax

80105930 <sys_getpid>:

int
sys_getpid(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105936:	e8 e5 e1 ff ff       	call   80103b20 <myproc>
8010593b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010593e:	c9                   	leave  
8010593f:	c3                   	ret    

80105940 <sys_sbrk>:

int
sys_sbrk(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105947:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 fe f1 ff ff       	call   80104b50 <argint>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 27                	js     80105980 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105959:	e8 c2 e1 ff ff       	call   80103b20 <myproc>
  if(growproc(n) < 0)
8010595e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105961:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105963:	ff 75 f4             	push   -0xc(%ebp)
80105966:	e8 d5 e2 ff ff       	call   80103c40 <growproc>
8010596b:	83 c4 10             	add    $0x10,%esp
8010596e:	85 c0                	test   %eax,%eax
80105970:	78 0e                	js     80105980 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105972:	89 d8                	mov    %ebx,%eax
80105974:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105977:	c9                   	leave  
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105980:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105985:	eb eb                	jmp    80105972 <sys_sbrk+0x32>
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_shugebrk>:
// TODO: implement this
// part 2
// TODO: add growhugeproc
int
sys_shugebrk(void)
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
8010599d:	e8 ae f1 ff ff       	call   80104b50 <argint>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	85 c0                	test   %eax,%eax
801059a7:	78 27                	js     801059d0 <sys_shugebrk+0x40>
    return -1;
  addr = myproc()->hugesz;
801059a9:	e8 72 e1 ff ff       	call   80103b20 <myproc>
  if(growhugeproc(n + HUGE_VA_OFFSET) < 0)
801059ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->hugesz;
801059b1:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growhugeproc(n + HUGE_VA_OFFSET) < 0)
801059b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b7:	05 00 00 00 1e       	add    $0x1e000000,%eax
801059bc:	50                   	push   %eax
801059bd:	e8 fe e2 ff ff       	call   80103cc0 <growhugeproc>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	85 c0                	test   %eax,%eax
801059c7:	78 07                	js     801059d0 <sys_shugebrk+0x40>
    return -1;
  return addr;
}
801059c9:	89 d8                	mov    %ebx,%eax
801059cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059ce:	c9                   	leave  
801059cf:	c3                   	ret    
    return -1;
801059d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059d5:	eb f2                	jmp    801059c9 <sys_shugebrk+0x39>
801059d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059de:	66 90                	xchg   %ax,%ax

801059e0 <sys_sleep>:

int
sys_sleep(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 5e f1 ff ff       	call   80104b50 <argint>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	0f 88 8a 00 00 00    	js     80105a87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	68 80 4d 11 80       	push   $0x80114d80
80105a05:	e8 c6 ed ff ff       	call   801047d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a0d:	8b 1d 60 4d 11 80    	mov    0x80114d60,%ebx
  while(ticks - ticks0 < n){
80105a13:	83 c4 10             	add    $0x10,%esp
80105a16:	85 d2                	test   %edx,%edx
80105a18:	75 27                	jne    80105a41 <sys_sleep+0x61>
80105a1a:	eb 54                	jmp    80105a70 <sys_sleep+0x90>
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a20:	83 ec 08             	sub    $0x8,%esp
80105a23:	68 80 4d 11 80       	push   $0x80114d80
80105a28:	68 60 4d 11 80       	push   $0x80114d60
80105a2d:	e8 3e e8 ff ff       	call   80104270 <sleep>
  while(ticks - ticks0 < n){
80105a32:	a1 60 4d 11 80       	mov    0x80114d60,%eax
80105a37:	83 c4 10             	add    $0x10,%esp
80105a3a:	29 d8                	sub    %ebx,%eax
80105a3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a3f:	73 2f                	jae    80105a70 <sys_sleep+0x90>
    if(myproc()->killed){
80105a41:	e8 da e0 ff ff       	call   80103b20 <myproc>
80105a46:	8b 40 28             	mov    0x28(%eax),%eax
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	74 d3                	je     80105a20 <sys_sleep+0x40>
      release(&tickslock);
80105a4d:	83 ec 0c             	sub    $0xc,%esp
80105a50:	68 80 4d 11 80       	push   $0x80114d80
80105a55:	e8 16 ed ff ff       	call   80104770 <release>
  }
  release(&tickslock);
  return 0;
}
80105a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a65:	c9                   	leave  
80105a66:	c3                   	ret    
80105a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	68 80 4d 11 80       	push   $0x80114d80
80105a78:	e8 f3 ec ff ff       	call   80104770 <release>
  return 0;
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	31 c0                	xor    %eax,%eax
}
80105a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a85:	c9                   	leave  
80105a86:	c3                   	ret    
    return -1;
80105a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8c:	eb f4                	jmp    80105a82 <sys_sleep+0xa2>
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	53                   	push   %ebx
80105a94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a97:	68 80 4d 11 80       	push   $0x80114d80
80105a9c:	e8 2f ed ff ff       	call   801047d0 <acquire>
  xticks = ticks;
80105aa1:	8b 1d 60 4d 11 80    	mov    0x80114d60,%ebx
  release(&tickslock);
80105aa7:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80105aae:	e8 bd ec ff ff       	call   80104770 <release>
  return xticks;
}
80105ab3:	89 d8                	mov    %ebx,%eax
80105ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ab8:	c9                   	leave  
80105ab9:	c3                   	ret    
80105aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ac0 <sys_printhugepde>:

// System calls for debugging huge page allocations/mappings
int
sys_printhugepde()
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
80105ac5:	53                   	push   %ebx
  pde_t *pgdir = myproc()->pgdir;
  int pid = myproc()->pid;
  int i = 0;
  for (i = 0; i < 1024; i++) {
80105ac6:	31 db                	xor    %ebx,%ebx
{
80105ac8:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pgdir = myproc()->pgdir;
80105acb:	e8 50 e0 ff ff       	call   80103b20 <myproc>
80105ad0:	8b 78 08             	mov    0x8(%eax),%edi
  int pid = myproc()->pid;
80105ad3:	e8 48 e0 ff ff       	call   80103b20 <myproc>
80105ad8:	8b 70 14             	mov    0x14(%eax),%esi
  for (i = 0; i < 1024; i++) {
80105adb:	eb 0e                	jmp    80105aeb <sys_printhugepde+0x2b>
80105add:	8d 76 00             	lea    0x0(%esi),%esi
80105ae0:	83 c3 01             	add    $0x1,%ebx
80105ae3:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105ae9:	74 2e                	je     80105b19 <sys_printhugepde+0x59>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P))
80105aeb:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80105aee:	89 c2                	mov    %eax,%edx
80105af0:	81 e2 85 00 00 00    	and    $0x85,%edx
80105af6:	81 fa 85 00 00 00    	cmp    $0x85,%edx
80105afc:	75 e2                	jne    80105ae0 <sys_printhugepde+0x20>
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105afe:	50                   	push   %eax
80105aff:	53                   	push   %ebx
  for (i = 0; i < 1024; i++) {
80105b00:	83 c3 01             	add    $0x1,%ebx
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105b03:	56                   	push   %esi
80105b04:	68 e5 7e 10 80       	push   $0x80107ee5
80105b09:	e8 92 ab ff ff       	call   801006a0 <cprintf>
80105b0e:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 1024; i++) {
80105b11:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b17:	75 d2                	jne    80105aeb <sys_printhugepde+0x2b>
  }
  return 0;
}
80105b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b1c:	31 c0                	xor    %eax,%eax
80105b1e:	5b                   	pop    %ebx
80105b1f:	5e                   	pop    %esi
80105b20:	5f                   	pop    %edi
80105b21:	5d                   	pop    %ebp
80105b22:	c3                   	ret    
80105b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b30 <sys_procpgdirinfo>:

int
sys_procpgdirinfo()
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	57                   	push   %edi
80105b34:	56                   	push   %esi
  int *buf;
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b35:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105b38:	53                   	push   %ebx
80105b39:	83 ec 30             	sub    $0x30,%esp
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b3c:	6a 08                	push   $0x8
80105b3e:	50                   	push   %eax
80105b3f:	6a 00                	push   $0x0
80105b41:	e8 5a f0 ff ff       	call   80104ba0 <argptr>
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	0f 88 90 00 00 00    	js     80105be1 <sys_procpgdirinfo+0xb1>
    return -1;
  pde_t *pgdir = myproc()->pgdir;
80105b51:	e8 ca df ff ff       	call   80103b20 <myproc>
  int base_cnt = 0; // base page count
  int huge_cnt = 0; // huge page count
80105b56:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  int base_cnt = 0; // base page count
80105b5d:	31 c9                	xor    %ecx,%ecx
80105b5f:	8b 70 08             	mov    0x8(%eax),%esi
80105b62:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105b68:	eb 12                	jmp    80105b7c <sys_procpgdirinfo+0x4c>
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i = 0;
  int j = 0;
  for (i = 0; i < 1024; i++) {
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
      ++huge_cnt;
    if((pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) && ((pgdir[i] & PTE_PS) == 0) /*Only PTE_P and PTE_U should be set for base pages*/) {
80105b70:	83 f8 05             	cmp    $0x5,%eax
80105b73:	74 3a                	je     80105baf <sys_procpgdirinfo+0x7f>
  for (i = 0; i < 1024; i++) {
80105b75:	83 c6 04             	add    $0x4,%esi
80105b78:	39 f7                	cmp    %esi,%edi
80105b7a:	74 1b                	je     80105b97 <sys_procpgdirinfo+0x67>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
80105b7c:	8b 1e                	mov    (%esi),%ebx
80105b7e:	89 d8                	mov    %ebx,%eax
80105b80:	25 85 00 00 00       	and    $0x85,%eax
80105b85:	3d 85 00 00 00       	cmp    $0x85,%eax
80105b8a:	75 e4                	jne    80105b70 <sys_procpgdirinfo+0x40>
  for (i = 0; i < 1024; i++) {
80105b8c:	83 c6 04             	add    $0x4,%esi
      ++huge_cnt;
80105b8f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  for (i = 0; i < 1024; i++) {
80105b93:	39 f7                	cmp    %esi,%edi
80105b95:	75 e5                	jne    80105b7c <sys_procpgdirinfo+0x4c>
          ++base_cnt;
        }
      }
    }
  }
  buf[0] = base_cnt; // base page count
80105b97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  buf[1] = huge_cnt; // huge page count
80105b9a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  buf[0] = base_cnt; // base page count
80105b9d:	89 08                	mov    %ecx,(%eax)
  buf[1] = huge_cnt; // huge page count
80105b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ba2:	89 78 04             	mov    %edi,0x4(%eax)
  return 0;
80105ba5:	31 c0                	xor    %eax,%eax
}
80105ba7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105baa:	5b                   	pop    %ebx
80105bab:	5e                   	pop    %esi
80105bac:	5f                   	pop    %edi
80105bad:	5d                   	pop    %ebp
80105bae:	c3                   	ret    
      uint* pgtab = (uint*)P2V(PTE_ADDR(pgdir[i]));
80105baf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105bb5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
      for (j = 0; j < 1024; j++) {
80105bbb:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
80105bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((pgtab[j] & PTE_U) && (pgtab[j] & PTE_P)) {
80105bc8:	8b 10                	mov    (%eax),%edx
80105bca:	83 e2 05             	and    $0x5,%edx
          ++base_cnt;
80105bcd:	83 fa 05             	cmp    $0x5,%edx
80105bd0:	0f 94 c2             	sete   %dl
      for (j = 0; j < 1024; j++) {
80105bd3:	83 c0 04             	add    $0x4,%eax
          ++base_cnt;
80105bd6:	0f b6 d2             	movzbl %dl,%edx
80105bd9:	01 d1                	add    %edx,%ecx
      for (j = 0; j < 1024; j++) {
80105bdb:	39 d8                	cmp    %ebx,%eax
80105bdd:	75 e9                	jne    80105bc8 <sys_procpgdirinfo+0x98>
80105bdf:	eb 94                	jmp    80105b75 <sys_procpgdirinfo+0x45>
    return -1;
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be6:	eb bf                	jmp    80105ba7 <sys_procpgdirinfo+0x77>

80105be8 <alltraps>:
80105be8:	1e                   	push   %ds
80105be9:	06                   	push   %es
80105bea:	0f a0                	push   %fs
80105bec:	0f a8                	push   %gs
80105bee:	60                   	pusha  
80105bef:	66 b8 10 00          	mov    $0x10,%ax
80105bf3:	8e d8                	mov    %eax,%ds
80105bf5:	8e c0                	mov    %eax,%es
80105bf7:	54                   	push   %esp
80105bf8:	e8 c3 00 00 00       	call   80105cc0 <trap>
80105bfd:	83 c4 04             	add    $0x4,%esp

80105c00 <trapret>:
80105c00:	61                   	popa   
80105c01:	0f a9                	pop    %gs
80105c03:	0f a1                	pop    %fs
80105c05:	07                   	pop    %es
80105c06:	1f                   	pop    %ds
80105c07:	83 c4 08             	add    $0x8,%esp
80105c0a:	cf                   	iret   
80105c0b:	66 90                	xchg   %ax,%ax
80105c0d:	66 90                	xchg   %ax,%ax
80105c0f:	90                   	nop

80105c10 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c10:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c11:	31 c0                	xor    %eax,%eax
{
80105c13:	89 e5                	mov    %esp,%ebp
80105c15:	83 ec 08             	sub    $0x8,%esp
80105c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c20:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c27:	c7 04 c5 c2 4d 11 80 	movl   $0x8e000008,-0x7feeb23e(,%eax,8)
80105c2e:	08 00 00 8e 
80105c32:	66 89 14 c5 c0 4d 11 	mov    %dx,-0x7feeb240(,%eax,8)
80105c39:	80 
80105c3a:	c1 ea 10             	shr    $0x10,%edx
80105c3d:	66 89 14 c5 c6 4d 11 	mov    %dx,-0x7feeb23a(,%eax,8)
80105c44:	80 
  for(i = 0; i < 256; i++)
80105c45:	83 c0 01             	add    $0x1,%eax
80105c48:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c4d:	75 d1                	jne    80105c20 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c4f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c52:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105c57:	c7 05 c2 4f 11 80 08 	movl   $0xef000008,0x80114fc2
80105c5e:	00 00 ef 
  initlock(&tickslock, "time");
80105c61:	68 fe 7e 10 80       	push   $0x80107efe
80105c66:	68 80 4d 11 80       	push   $0x80114d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c6b:	66 a3 c0 4f 11 80    	mov    %ax,0x80114fc0
80105c71:	c1 e8 10             	shr    $0x10,%eax
80105c74:	66 a3 c6 4f 11 80    	mov    %ax,0x80114fc6
  initlock(&tickslock, "time");
80105c7a:	e8 81 e9 ff ff       	call   80104600 <initlock>
}
80105c7f:	83 c4 10             	add    $0x10,%esp
80105c82:	c9                   	leave  
80105c83:	c3                   	ret    
80105c84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c8f:	90                   	nop

80105c90 <idtinit>:

void
idtinit(void)
{
80105c90:	55                   	push   %ebp
  pd[0] = size-1;
80105c91:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c96:	89 e5                	mov    %esp,%ebp
80105c98:	83 ec 10             	sub    $0x10,%esp
80105c9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c9f:	b8 c0 4d 11 80       	mov    $0x80114dc0,%eax
80105ca4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ca8:	c1 e8 10             	shr    $0x10,%eax
80105cab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105caf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cb2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cb5:	c9                   	leave  
80105cb6:	c3                   	ret    
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	57                   	push   %edi
80105cc4:	56                   	push   %esi
80105cc5:	53                   	push   %ebx
80105cc6:	83 ec 1c             	sub    $0x1c,%esp
80105cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ccc:	8b 43 30             	mov    0x30(%ebx),%eax
80105ccf:	83 f8 40             	cmp    $0x40,%eax
80105cd2:	0f 84 68 01 00 00    	je     80105e40 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cd8:	83 e8 20             	sub    $0x20,%eax
80105cdb:	83 f8 1f             	cmp    $0x1f,%eax
80105cde:	0f 87 8c 00 00 00    	ja     80105d70 <trap+0xb0>
80105ce4:	ff 24 85 a4 7f 10 80 	jmp    *-0x7fef805c(,%eax,4)
80105ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105cf0:	e8 4b c5 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105cf5:	e8 c6 cd ff ff       	call   80102ac0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cfa:	e8 21 de ff ff       	call   80103b20 <myproc>
80105cff:	85 c0                	test   %eax,%eax
80105d01:	74 1d                	je     80105d20 <trap+0x60>
80105d03:	e8 18 de ff ff       	call   80103b20 <myproc>
80105d08:	8b 50 28             	mov    0x28(%eax),%edx
80105d0b:	85 d2                	test   %edx,%edx
80105d0d:	74 11                	je     80105d20 <trap+0x60>
80105d0f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d13:	83 e0 03             	and    $0x3,%eax
80105d16:	66 83 f8 03          	cmp    $0x3,%ax
80105d1a:	0f 84 e8 01 00 00    	je     80105f08 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d20:	e8 fb dd ff ff       	call   80103b20 <myproc>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	74 0f                	je     80105d38 <trap+0x78>
80105d29:	e8 f2 dd ff ff       	call   80103b20 <myproc>
80105d2e:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105d32:	0f 84 b8 00 00 00    	je     80105df0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d38:	e8 e3 dd ff ff       	call   80103b20 <myproc>
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	74 1d                	je     80105d5e <trap+0x9e>
80105d41:	e8 da dd ff ff       	call   80103b20 <myproc>
80105d46:	8b 40 28             	mov    0x28(%eax),%eax
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	74 11                	je     80105d5e <trap+0x9e>
80105d4d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d51:	83 e0 03             	and    $0x3,%eax
80105d54:	66 83 f8 03          	cmp    $0x3,%ax
80105d58:	0f 84 0f 01 00 00    	je     80105e6d <trap+0x1ad>
    exit();
}
80105d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d61:	5b                   	pop    %ebx
80105d62:	5e                   	pop    %esi
80105d63:	5f                   	pop    %edi
80105d64:	5d                   	pop    %ebp
80105d65:	c3                   	ret    
80105d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d70:	e8 ab dd ff ff       	call   80103b20 <myproc>
80105d75:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	0f 84 a2 01 00 00    	je     80105f22 <trap+0x262>
80105d80:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d84:	0f 84 98 01 00 00    	je     80105f22 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d8a:	0f 20 d1             	mov    %cr2,%ecx
80105d8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d90:	e8 6b dd ff ff       	call   80103b00 <cpuid>
80105d95:	8b 73 30             	mov    0x30(%ebx),%esi
80105d98:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d9b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105da1:	e8 7a dd ff ff       	call   80103b20 <myproc>
80105da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105da9:	e8 72 dd ff ff       	call   80103b20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105db4:	51                   	push   %ecx
80105db5:	57                   	push   %edi
80105db6:	52                   	push   %edx
80105db7:	ff 75 e4             	push   -0x1c(%ebp)
80105dba:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105dbb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105dbe:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dc1:	56                   	push   %esi
80105dc2:	ff 70 14             	push   0x14(%eax)
80105dc5:	68 60 7f 10 80       	push   $0x80107f60
80105dca:	e8 d1 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105dcf:	83 c4 20             	add    $0x20,%esp
80105dd2:	e8 49 dd ff ff       	call   80103b20 <myproc>
80105dd7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dde:	e8 3d dd ff ff       	call   80103b20 <myproc>
80105de3:	85 c0                	test   %eax,%eax
80105de5:	0f 85 18 ff ff ff    	jne    80105d03 <trap+0x43>
80105deb:	e9 30 ff ff ff       	jmp    80105d20 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105df0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105df4:	0f 85 3e ff ff ff    	jne    80105d38 <trap+0x78>
    yield();
80105dfa:	e8 21 e4 ff ff       	call   80104220 <yield>
80105dff:	e9 34 ff ff ff       	jmp    80105d38 <trap+0x78>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e08:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e0b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e0f:	e8 ec dc ff ff       	call   80103b00 <cpuid>
80105e14:	57                   	push   %edi
80105e15:	56                   	push   %esi
80105e16:	50                   	push   %eax
80105e17:	68 08 7f 10 80       	push   $0x80107f08
80105e1c:	e8 7f a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105e21:	e8 9a cc ff ff       	call   80102ac0 <lapiceoi>
    break;
80105e26:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e29:	e8 f2 dc ff ff       	call   80103b20 <myproc>
80105e2e:	85 c0                	test   %eax,%eax
80105e30:	0f 85 cd fe ff ff    	jne    80105d03 <trap+0x43>
80105e36:	e9 e5 fe ff ff       	jmp    80105d20 <trap+0x60>
80105e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e3f:	90                   	nop
    if(myproc()->killed)
80105e40:	e8 db dc ff ff       	call   80103b20 <myproc>
80105e45:	8b 70 28             	mov    0x28(%eax),%esi
80105e48:	85 f6                	test   %esi,%esi
80105e4a:	0f 85 c8 00 00 00    	jne    80105f18 <trap+0x258>
    myproc()->tf = tf;
80105e50:	e8 cb dc ff ff       	call   80103b20 <myproc>
80105e55:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105e58:	e8 33 ee ff ff       	call   80104c90 <syscall>
    if(myproc()->killed)
80105e5d:	e8 be dc ff ff       	call   80103b20 <myproc>
80105e62:	8b 48 28             	mov    0x28(%eax),%ecx
80105e65:	85 c9                	test   %ecx,%ecx
80105e67:	0f 84 f1 fe ff ff    	je     80105d5e <trap+0x9e>
}
80105e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e70:	5b                   	pop    %ebx
80105e71:	5e                   	pop    %esi
80105e72:	5f                   	pop    %edi
80105e73:	5d                   	pop    %ebp
      exit();
80105e74:	e9 47 e1 ff ff       	jmp    80103fc0 <exit>
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e80:	e8 3b 02 00 00       	call   801060c0 <uartintr>
    lapiceoi();
80105e85:	e8 36 cc ff ff       	call   80102ac0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e8a:	e8 91 dc ff ff       	call   80103b20 <myproc>
80105e8f:	85 c0                	test   %eax,%eax
80105e91:	0f 85 6c fe ff ff    	jne    80105d03 <trap+0x43>
80105e97:	e9 84 fe ff ff       	jmp    80105d20 <trap+0x60>
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ea0:	e8 db ca ff ff       	call   80102980 <kbdintr>
    lapiceoi();
80105ea5:	e8 16 cc ff ff       	call   80102ac0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eaa:	e8 71 dc ff ff       	call   80103b20 <myproc>
80105eaf:	85 c0                	test   %eax,%eax
80105eb1:	0f 85 4c fe ff ff    	jne    80105d03 <trap+0x43>
80105eb7:	e9 64 fe ff ff       	jmp    80105d20 <trap+0x60>
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ec0:	e8 3b dc ff ff       	call   80103b00 <cpuid>
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	0f 85 28 fe ff ff    	jne    80105cf5 <trap+0x35>
      acquire(&tickslock);
80105ecd:	83 ec 0c             	sub    $0xc,%esp
80105ed0:	68 80 4d 11 80       	push   $0x80114d80
80105ed5:	e8 f6 e8 ff ff       	call   801047d0 <acquire>
      wakeup(&ticks);
80105eda:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
      ticks++;
80105ee1:	83 05 60 4d 11 80 01 	addl   $0x1,0x80114d60
      wakeup(&ticks);
80105ee8:	e8 43 e4 ff ff       	call   80104330 <wakeup>
      release(&tickslock);
80105eed:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80105ef4:	e8 77 e8 ff ff       	call   80104770 <release>
80105ef9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105efc:	e9 f4 fd ff ff       	jmp    80105cf5 <trap+0x35>
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f08:	e8 b3 e0 ff ff       	call   80103fc0 <exit>
80105f0d:	e9 0e fe ff ff       	jmp    80105d20 <trap+0x60>
80105f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f18:	e8 a3 e0 ff ff       	call   80103fc0 <exit>
80105f1d:	e9 2e ff ff ff       	jmp    80105e50 <trap+0x190>
80105f22:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f25:	e8 d6 db ff ff       	call   80103b00 <cpuid>
80105f2a:	83 ec 0c             	sub    $0xc,%esp
80105f2d:	56                   	push   %esi
80105f2e:	57                   	push   %edi
80105f2f:	50                   	push   %eax
80105f30:	ff 73 30             	push   0x30(%ebx)
80105f33:	68 2c 7f 10 80       	push   $0x80107f2c
80105f38:	e8 63 a7 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105f3d:	83 c4 14             	add    $0x14,%esp
80105f40:	68 03 7f 10 80       	push   $0x80107f03
80105f45:	e8 36 a4 ff ff       	call   80100380 <panic>
80105f4a:	66 90                	xchg   %ax,%ax
80105f4c:	66 90                	xchg   %ax,%ax
80105f4e:	66 90                	xchg   %ax,%ax

80105f50 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f50:	a1 c0 55 11 80       	mov    0x801155c0,%eax
80105f55:	85 c0                	test   %eax,%eax
80105f57:	74 17                	je     80105f70 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f59:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f5e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f5f:	a8 01                	test   $0x1,%al
80105f61:	74 0d                	je     80105f70 <uartgetc+0x20>
80105f63:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f68:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f69:	0f b6 c0             	movzbl %al,%eax
80105f6c:	c3                   	ret    
80105f6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f75:	c3                   	ret    
80105f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7d:	8d 76 00             	lea    0x0(%esi),%esi

80105f80 <uartinit>:
{
80105f80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f81:	31 c9                	xor    %ecx,%ecx
80105f83:	89 c8                	mov    %ecx,%eax
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	57                   	push   %edi
80105f88:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f8d:	56                   	push   %esi
80105f8e:	89 fa                	mov    %edi,%edx
80105f90:	53                   	push   %ebx
80105f91:	83 ec 1c             	sub    $0x1c,%esp
80105f94:	ee                   	out    %al,(%dx)
80105f95:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f9f:	89 f2                	mov    %esi,%edx
80105fa1:	ee                   	out    %al,(%dx)
80105fa2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fa7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fac:	ee                   	out    %al,(%dx)
80105fad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105fb2:	89 c8                	mov    %ecx,%eax
80105fb4:	89 da                	mov    %ebx,%edx
80105fb6:	ee                   	out    %al,(%dx)
80105fb7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fbc:	89 f2                	mov    %esi,%edx
80105fbe:	ee                   	out    %al,(%dx)
80105fbf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fc4:	89 c8                	mov    %ecx,%eax
80105fc6:	ee                   	out    %al,(%dx)
80105fc7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fcc:	89 da                	mov    %ebx,%edx
80105fce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fcf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fd4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fd5:	3c ff                	cmp    $0xff,%al
80105fd7:	74 78                	je     80106051 <uartinit+0xd1>
  uart = 1;
80105fd9:	c7 05 c0 55 11 80 01 	movl   $0x1,0x801155c0
80105fe0:	00 00 00 
80105fe3:	89 fa                	mov    %edi,%edx
80105fe5:	ec                   	in     (%dx),%al
80105fe6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105feb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fef:	bf 24 80 10 80       	mov    $0x80108024,%edi
80105ff4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105ff9:	6a 00                	push   $0x0
80105ffb:	6a 04                	push   $0x4
80105ffd:	e8 7e c4 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106002:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106010:	a1 c0 55 11 80       	mov    0x801155c0,%eax
80106015:	bb 80 00 00 00       	mov    $0x80,%ebx
8010601a:	85 c0                	test   %eax,%eax
8010601c:	75 14                	jne    80106032 <uartinit+0xb2>
8010601e:	eb 23                	jmp    80106043 <uartinit+0xc3>
    microdelay(10);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	6a 0a                	push   $0xa
80106025:	e8 b6 ca ff ff       	call   80102ae0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	83 eb 01             	sub    $0x1,%ebx
80106030:	74 07                	je     80106039 <uartinit+0xb9>
80106032:	89 f2                	mov    %esi,%edx
80106034:	ec                   	in     (%dx),%al
80106035:	a8 20                	test   $0x20,%al
80106037:	74 e7                	je     80106020 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106039:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010603d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106042:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106043:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106047:	83 c7 01             	add    $0x1,%edi
8010604a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010604d:	84 c0                	test   %al,%al
8010604f:	75 bf                	jne    80106010 <uartinit+0x90>
}
80106051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106054:	5b                   	pop    %ebx
80106055:	5e                   	pop    %esi
80106056:	5f                   	pop    %edi
80106057:	5d                   	pop    %ebp
80106058:	c3                   	ret    
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106060 <uartputc>:
  if(!uart)
80106060:	a1 c0 55 11 80       	mov    0x801155c0,%eax
80106065:	85 c0                	test   %eax,%eax
80106067:	74 47                	je     801060b0 <uartputc+0x50>
{
80106069:	55                   	push   %ebp
8010606a:	89 e5                	mov    %esp,%ebp
8010606c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010606d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106072:	53                   	push   %ebx
80106073:	bb 80 00 00 00       	mov    $0x80,%ebx
80106078:	eb 18                	jmp    80106092 <uartputc+0x32>
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	6a 0a                	push   $0xa
80106085:	e8 56 ca ff ff       	call   80102ae0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	83 eb 01             	sub    $0x1,%ebx
80106090:	74 07                	je     80106099 <uartputc+0x39>
80106092:	89 f2                	mov    %esi,%edx
80106094:	ec                   	in     (%dx),%al
80106095:	a8 20                	test   $0x20,%al
80106097:	74 e7                	je     80106080 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106099:	8b 45 08             	mov    0x8(%ebp),%eax
8010609c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060a1:	ee                   	out    %al,(%dx)
}
801060a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060a5:	5b                   	pop    %ebx
801060a6:	5e                   	pop    %esi
801060a7:	5d                   	pop    %ebp
801060a8:	c3                   	ret    
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060b0:	c3                   	ret    
801060b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060bf:	90                   	nop

801060c0 <uartintr>:

void
uartintr(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060c6:	68 50 5f 10 80       	push   $0x80105f50
801060cb:	e8 b0 a7 ff ff       	call   80100880 <consoleintr>
}
801060d0:	83 c4 10             	add    $0x10,%esp
801060d3:	c9                   	leave  
801060d4:	c3                   	ret    

801060d5 <vector0>:
801060d5:	6a 00                	push   $0x0
801060d7:	6a 00                	push   $0x0
801060d9:	e9 0a fb ff ff       	jmp    80105be8 <alltraps>

801060de <vector1>:
801060de:	6a 00                	push   $0x0
801060e0:	6a 01                	push   $0x1
801060e2:	e9 01 fb ff ff       	jmp    80105be8 <alltraps>

801060e7 <vector2>:
801060e7:	6a 00                	push   $0x0
801060e9:	6a 02                	push   $0x2
801060eb:	e9 f8 fa ff ff       	jmp    80105be8 <alltraps>

801060f0 <vector3>:
801060f0:	6a 00                	push   $0x0
801060f2:	6a 03                	push   $0x3
801060f4:	e9 ef fa ff ff       	jmp    80105be8 <alltraps>

801060f9 <vector4>:
801060f9:	6a 00                	push   $0x0
801060fb:	6a 04                	push   $0x4
801060fd:	e9 e6 fa ff ff       	jmp    80105be8 <alltraps>

80106102 <vector5>:
80106102:	6a 00                	push   $0x0
80106104:	6a 05                	push   $0x5
80106106:	e9 dd fa ff ff       	jmp    80105be8 <alltraps>

8010610b <vector6>:
8010610b:	6a 00                	push   $0x0
8010610d:	6a 06                	push   $0x6
8010610f:	e9 d4 fa ff ff       	jmp    80105be8 <alltraps>

80106114 <vector7>:
80106114:	6a 00                	push   $0x0
80106116:	6a 07                	push   $0x7
80106118:	e9 cb fa ff ff       	jmp    80105be8 <alltraps>

8010611d <vector8>:
8010611d:	6a 08                	push   $0x8
8010611f:	e9 c4 fa ff ff       	jmp    80105be8 <alltraps>

80106124 <vector9>:
80106124:	6a 00                	push   $0x0
80106126:	6a 09                	push   $0x9
80106128:	e9 bb fa ff ff       	jmp    80105be8 <alltraps>

8010612d <vector10>:
8010612d:	6a 0a                	push   $0xa
8010612f:	e9 b4 fa ff ff       	jmp    80105be8 <alltraps>

80106134 <vector11>:
80106134:	6a 0b                	push   $0xb
80106136:	e9 ad fa ff ff       	jmp    80105be8 <alltraps>

8010613b <vector12>:
8010613b:	6a 0c                	push   $0xc
8010613d:	e9 a6 fa ff ff       	jmp    80105be8 <alltraps>

80106142 <vector13>:
80106142:	6a 0d                	push   $0xd
80106144:	e9 9f fa ff ff       	jmp    80105be8 <alltraps>

80106149 <vector14>:
80106149:	6a 0e                	push   $0xe
8010614b:	e9 98 fa ff ff       	jmp    80105be8 <alltraps>

80106150 <vector15>:
80106150:	6a 00                	push   $0x0
80106152:	6a 0f                	push   $0xf
80106154:	e9 8f fa ff ff       	jmp    80105be8 <alltraps>

80106159 <vector16>:
80106159:	6a 00                	push   $0x0
8010615b:	6a 10                	push   $0x10
8010615d:	e9 86 fa ff ff       	jmp    80105be8 <alltraps>

80106162 <vector17>:
80106162:	6a 11                	push   $0x11
80106164:	e9 7f fa ff ff       	jmp    80105be8 <alltraps>

80106169 <vector18>:
80106169:	6a 00                	push   $0x0
8010616b:	6a 12                	push   $0x12
8010616d:	e9 76 fa ff ff       	jmp    80105be8 <alltraps>

80106172 <vector19>:
80106172:	6a 00                	push   $0x0
80106174:	6a 13                	push   $0x13
80106176:	e9 6d fa ff ff       	jmp    80105be8 <alltraps>

8010617b <vector20>:
8010617b:	6a 00                	push   $0x0
8010617d:	6a 14                	push   $0x14
8010617f:	e9 64 fa ff ff       	jmp    80105be8 <alltraps>

80106184 <vector21>:
80106184:	6a 00                	push   $0x0
80106186:	6a 15                	push   $0x15
80106188:	e9 5b fa ff ff       	jmp    80105be8 <alltraps>

8010618d <vector22>:
8010618d:	6a 00                	push   $0x0
8010618f:	6a 16                	push   $0x16
80106191:	e9 52 fa ff ff       	jmp    80105be8 <alltraps>

80106196 <vector23>:
80106196:	6a 00                	push   $0x0
80106198:	6a 17                	push   $0x17
8010619a:	e9 49 fa ff ff       	jmp    80105be8 <alltraps>

8010619f <vector24>:
8010619f:	6a 00                	push   $0x0
801061a1:	6a 18                	push   $0x18
801061a3:	e9 40 fa ff ff       	jmp    80105be8 <alltraps>

801061a8 <vector25>:
801061a8:	6a 00                	push   $0x0
801061aa:	6a 19                	push   $0x19
801061ac:	e9 37 fa ff ff       	jmp    80105be8 <alltraps>

801061b1 <vector26>:
801061b1:	6a 00                	push   $0x0
801061b3:	6a 1a                	push   $0x1a
801061b5:	e9 2e fa ff ff       	jmp    80105be8 <alltraps>

801061ba <vector27>:
801061ba:	6a 00                	push   $0x0
801061bc:	6a 1b                	push   $0x1b
801061be:	e9 25 fa ff ff       	jmp    80105be8 <alltraps>

801061c3 <vector28>:
801061c3:	6a 00                	push   $0x0
801061c5:	6a 1c                	push   $0x1c
801061c7:	e9 1c fa ff ff       	jmp    80105be8 <alltraps>

801061cc <vector29>:
801061cc:	6a 00                	push   $0x0
801061ce:	6a 1d                	push   $0x1d
801061d0:	e9 13 fa ff ff       	jmp    80105be8 <alltraps>

801061d5 <vector30>:
801061d5:	6a 00                	push   $0x0
801061d7:	6a 1e                	push   $0x1e
801061d9:	e9 0a fa ff ff       	jmp    80105be8 <alltraps>

801061de <vector31>:
801061de:	6a 00                	push   $0x0
801061e0:	6a 1f                	push   $0x1f
801061e2:	e9 01 fa ff ff       	jmp    80105be8 <alltraps>

801061e7 <vector32>:
801061e7:	6a 00                	push   $0x0
801061e9:	6a 20                	push   $0x20
801061eb:	e9 f8 f9 ff ff       	jmp    80105be8 <alltraps>

801061f0 <vector33>:
801061f0:	6a 00                	push   $0x0
801061f2:	6a 21                	push   $0x21
801061f4:	e9 ef f9 ff ff       	jmp    80105be8 <alltraps>

801061f9 <vector34>:
801061f9:	6a 00                	push   $0x0
801061fb:	6a 22                	push   $0x22
801061fd:	e9 e6 f9 ff ff       	jmp    80105be8 <alltraps>

80106202 <vector35>:
80106202:	6a 00                	push   $0x0
80106204:	6a 23                	push   $0x23
80106206:	e9 dd f9 ff ff       	jmp    80105be8 <alltraps>

8010620b <vector36>:
8010620b:	6a 00                	push   $0x0
8010620d:	6a 24                	push   $0x24
8010620f:	e9 d4 f9 ff ff       	jmp    80105be8 <alltraps>

80106214 <vector37>:
80106214:	6a 00                	push   $0x0
80106216:	6a 25                	push   $0x25
80106218:	e9 cb f9 ff ff       	jmp    80105be8 <alltraps>

8010621d <vector38>:
8010621d:	6a 00                	push   $0x0
8010621f:	6a 26                	push   $0x26
80106221:	e9 c2 f9 ff ff       	jmp    80105be8 <alltraps>

80106226 <vector39>:
80106226:	6a 00                	push   $0x0
80106228:	6a 27                	push   $0x27
8010622a:	e9 b9 f9 ff ff       	jmp    80105be8 <alltraps>

8010622f <vector40>:
8010622f:	6a 00                	push   $0x0
80106231:	6a 28                	push   $0x28
80106233:	e9 b0 f9 ff ff       	jmp    80105be8 <alltraps>

80106238 <vector41>:
80106238:	6a 00                	push   $0x0
8010623a:	6a 29                	push   $0x29
8010623c:	e9 a7 f9 ff ff       	jmp    80105be8 <alltraps>

80106241 <vector42>:
80106241:	6a 00                	push   $0x0
80106243:	6a 2a                	push   $0x2a
80106245:	e9 9e f9 ff ff       	jmp    80105be8 <alltraps>

8010624a <vector43>:
8010624a:	6a 00                	push   $0x0
8010624c:	6a 2b                	push   $0x2b
8010624e:	e9 95 f9 ff ff       	jmp    80105be8 <alltraps>

80106253 <vector44>:
80106253:	6a 00                	push   $0x0
80106255:	6a 2c                	push   $0x2c
80106257:	e9 8c f9 ff ff       	jmp    80105be8 <alltraps>

8010625c <vector45>:
8010625c:	6a 00                	push   $0x0
8010625e:	6a 2d                	push   $0x2d
80106260:	e9 83 f9 ff ff       	jmp    80105be8 <alltraps>

80106265 <vector46>:
80106265:	6a 00                	push   $0x0
80106267:	6a 2e                	push   $0x2e
80106269:	e9 7a f9 ff ff       	jmp    80105be8 <alltraps>

8010626e <vector47>:
8010626e:	6a 00                	push   $0x0
80106270:	6a 2f                	push   $0x2f
80106272:	e9 71 f9 ff ff       	jmp    80105be8 <alltraps>

80106277 <vector48>:
80106277:	6a 00                	push   $0x0
80106279:	6a 30                	push   $0x30
8010627b:	e9 68 f9 ff ff       	jmp    80105be8 <alltraps>

80106280 <vector49>:
80106280:	6a 00                	push   $0x0
80106282:	6a 31                	push   $0x31
80106284:	e9 5f f9 ff ff       	jmp    80105be8 <alltraps>

80106289 <vector50>:
80106289:	6a 00                	push   $0x0
8010628b:	6a 32                	push   $0x32
8010628d:	e9 56 f9 ff ff       	jmp    80105be8 <alltraps>

80106292 <vector51>:
80106292:	6a 00                	push   $0x0
80106294:	6a 33                	push   $0x33
80106296:	e9 4d f9 ff ff       	jmp    80105be8 <alltraps>

8010629b <vector52>:
8010629b:	6a 00                	push   $0x0
8010629d:	6a 34                	push   $0x34
8010629f:	e9 44 f9 ff ff       	jmp    80105be8 <alltraps>

801062a4 <vector53>:
801062a4:	6a 00                	push   $0x0
801062a6:	6a 35                	push   $0x35
801062a8:	e9 3b f9 ff ff       	jmp    80105be8 <alltraps>

801062ad <vector54>:
801062ad:	6a 00                	push   $0x0
801062af:	6a 36                	push   $0x36
801062b1:	e9 32 f9 ff ff       	jmp    80105be8 <alltraps>

801062b6 <vector55>:
801062b6:	6a 00                	push   $0x0
801062b8:	6a 37                	push   $0x37
801062ba:	e9 29 f9 ff ff       	jmp    80105be8 <alltraps>

801062bf <vector56>:
801062bf:	6a 00                	push   $0x0
801062c1:	6a 38                	push   $0x38
801062c3:	e9 20 f9 ff ff       	jmp    80105be8 <alltraps>

801062c8 <vector57>:
801062c8:	6a 00                	push   $0x0
801062ca:	6a 39                	push   $0x39
801062cc:	e9 17 f9 ff ff       	jmp    80105be8 <alltraps>

801062d1 <vector58>:
801062d1:	6a 00                	push   $0x0
801062d3:	6a 3a                	push   $0x3a
801062d5:	e9 0e f9 ff ff       	jmp    80105be8 <alltraps>

801062da <vector59>:
801062da:	6a 00                	push   $0x0
801062dc:	6a 3b                	push   $0x3b
801062de:	e9 05 f9 ff ff       	jmp    80105be8 <alltraps>

801062e3 <vector60>:
801062e3:	6a 00                	push   $0x0
801062e5:	6a 3c                	push   $0x3c
801062e7:	e9 fc f8 ff ff       	jmp    80105be8 <alltraps>

801062ec <vector61>:
801062ec:	6a 00                	push   $0x0
801062ee:	6a 3d                	push   $0x3d
801062f0:	e9 f3 f8 ff ff       	jmp    80105be8 <alltraps>

801062f5 <vector62>:
801062f5:	6a 00                	push   $0x0
801062f7:	6a 3e                	push   $0x3e
801062f9:	e9 ea f8 ff ff       	jmp    80105be8 <alltraps>

801062fe <vector63>:
801062fe:	6a 00                	push   $0x0
80106300:	6a 3f                	push   $0x3f
80106302:	e9 e1 f8 ff ff       	jmp    80105be8 <alltraps>

80106307 <vector64>:
80106307:	6a 00                	push   $0x0
80106309:	6a 40                	push   $0x40
8010630b:	e9 d8 f8 ff ff       	jmp    80105be8 <alltraps>

80106310 <vector65>:
80106310:	6a 00                	push   $0x0
80106312:	6a 41                	push   $0x41
80106314:	e9 cf f8 ff ff       	jmp    80105be8 <alltraps>

80106319 <vector66>:
80106319:	6a 00                	push   $0x0
8010631b:	6a 42                	push   $0x42
8010631d:	e9 c6 f8 ff ff       	jmp    80105be8 <alltraps>

80106322 <vector67>:
80106322:	6a 00                	push   $0x0
80106324:	6a 43                	push   $0x43
80106326:	e9 bd f8 ff ff       	jmp    80105be8 <alltraps>

8010632b <vector68>:
8010632b:	6a 00                	push   $0x0
8010632d:	6a 44                	push   $0x44
8010632f:	e9 b4 f8 ff ff       	jmp    80105be8 <alltraps>

80106334 <vector69>:
80106334:	6a 00                	push   $0x0
80106336:	6a 45                	push   $0x45
80106338:	e9 ab f8 ff ff       	jmp    80105be8 <alltraps>

8010633d <vector70>:
8010633d:	6a 00                	push   $0x0
8010633f:	6a 46                	push   $0x46
80106341:	e9 a2 f8 ff ff       	jmp    80105be8 <alltraps>

80106346 <vector71>:
80106346:	6a 00                	push   $0x0
80106348:	6a 47                	push   $0x47
8010634a:	e9 99 f8 ff ff       	jmp    80105be8 <alltraps>

8010634f <vector72>:
8010634f:	6a 00                	push   $0x0
80106351:	6a 48                	push   $0x48
80106353:	e9 90 f8 ff ff       	jmp    80105be8 <alltraps>

80106358 <vector73>:
80106358:	6a 00                	push   $0x0
8010635a:	6a 49                	push   $0x49
8010635c:	e9 87 f8 ff ff       	jmp    80105be8 <alltraps>

80106361 <vector74>:
80106361:	6a 00                	push   $0x0
80106363:	6a 4a                	push   $0x4a
80106365:	e9 7e f8 ff ff       	jmp    80105be8 <alltraps>

8010636a <vector75>:
8010636a:	6a 00                	push   $0x0
8010636c:	6a 4b                	push   $0x4b
8010636e:	e9 75 f8 ff ff       	jmp    80105be8 <alltraps>

80106373 <vector76>:
80106373:	6a 00                	push   $0x0
80106375:	6a 4c                	push   $0x4c
80106377:	e9 6c f8 ff ff       	jmp    80105be8 <alltraps>

8010637c <vector77>:
8010637c:	6a 00                	push   $0x0
8010637e:	6a 4d                	push   $0x4d
80106380:	e9 63 f8 ff ff       	jmp    80105be8 <alltraps>

80106385 <vector78>:
80106385:	6a 00                	push   $0x0
80106387:	6a 4e                	push   $0x4e
80106389:	e9 5a f8 ff ff       	jmp    80105be8 <alltraps>

8010638e <vector79>:
8010638e:	6a 00                	push   $0x0
80106390:	6a 4f                	push   $0x4f
80106392:	e9 51 f8 ff ff       	jmp    80105be8 <alltraps>

80106397 <vector80>:
80106397:	6a 00                	push   $0x0
80106399:	6a 50                	push   $0x50
8010639b:	e9 48 f8 ff ff       	jmp    80105be8 <alltraps>

801063a0 <vector81>:
801063a0:	6a 00                	push   $0x0
801063a2:	6a 51                	push   $0x51
801063a4:	e9 3f f8 ff ff       	jmp    80105be8 <alltraps>

801063a9 <vector82>:
801063a9:	6a 00                	push   $0x0
801063ab:	6a 52                	push   $0x52
801063ad:	e9 36 f8 ff ff       	jmp    80105be8 <alltraps>

801063b2 <vector83>:
801063b2:	6a 00                	push   $0x0
801063b4:	6a 53                	push   $0x53
801063b6:	e9 2d f8 ff ff       	jmp    80105be8 <alltraps>

801063bb <vector84>:
801063bb:	6a 00                	push   $0x0
801063bd:	6a 54                	push   $0x54
801063bf:	e9 24 f8 ff ff       	jmp    80105be8 <alltraps>

801063c4 <vector85>:
801063c4:	6a 00                	push   $0x0
801063c6:	6a 55                	push   $0x55
801063c8:	e9 1b f8 ff ff       	jmp    80105be8 <alltraps>

801063cd <vector86>:
801063cd:	6a 00                	push   $0x0
801063cf:	6a 56                	push   $0x56
801063d1:	e9 12 f8 ff ff       	jmp    80105be8 <alltraps>

801063d6 <vector87>:
801063d6:	6a 00                	push   $0x0
801063d8:	6a 57                	push   $0x57
801063da:	e9 09 f8 ff ff       	jmp    80105be8 <alltraps>

801063df <vector88>:
801063df:	6a 00                	push   $0x0
801063e1:	6a 58                	push   $0x58
801063e3:	e9 00 f8 ff ff       	jmp    80105be8 <alltraps>

801063e8 <vector89>:
801063e8:	6a 00                	push   $0x0
801063ea:	6a 59                	push   $0x59
801063ec:	e9 f7 f7 ff ff       	jmp    80105be8 <alltraps>

801063f1 <vector90>:
801063f1:	6a 00                	push   $0x0
801063f3:	6a 5a                	push   $0x5a
801063f5:	e9 ee f7 ff ff       	jmp    80105be8 <alltraps>

801063fa <vector91>:
801063fa:	6a 00                	push   $0x0
801063fc:	6a 5b                	push   $0x5b
801063fe:	e9 e5 f7 ff ff       	jmp    80105be8 <alltraps>

80106403 <vector92>:
80106403:	6a 00                	push   $0x0
80106405:	6a 5c                	push   $0x5c
80106407:	e9 dc f7 ff ff       	jmp    80105be8 <alltraps>

8010640c <vector93>:
8010640c:	6a 00                	push   $0x0
8010640e:	6a 5d                	push   $0x5d
80106410:	e9 d3 f7 ff ff       	jmp    80105be8 <alltraps>

80106415 <vector94>:
80106415:	6a 00                	push   $0x0
80106417:	6a 5e                	push   $0x5e
80106419:	e9 ca f7 ff ff       	jmp    80105be8 <alltraps>

8010641e <vector95>:
8010641e:	6a 00                	push   $0x0
80106420:	6a 5f                	push   $0x5f
80106422:	e9 c1 f7 ff ff       	jmp    80105be8 <alltraps>

80106427 <vector96>:
80106427:	6a 00                	push   $0x0
80106429:	6a 60                	push   $0x60
8010642b:	e9 b8 f7 ff ff       	jmp    80105be8 <alltraps>

80106430 <vector97>:
80106430:	6a 00                	push   $0x0
80106432:	6a 61                	push   $0x61
80106434:	e9 af f7 ff ff       	jmp    80105be8 <alltraps>

80106439 <vector98>:
80106439:	6a 00                	push   $0x0
8010643b:	6a 62                	push   $0x62
8010643d:	e9 a6 f7 ff ff       	jmp    80105be8 <alltraps>

80106442 <vector99>:
80106442:	6a 00                	push   $0x0
80106444:	6a 63                	push   $0x63
80106446:	e9 9d f7 ff ff       	jmp    80105be8 <alltraps>

8010644b <vector100>:
8010644b:	6a 00                	push   $0x0
8010644d:	6a 64                	push   $0x64
8010644f:	e9 94 f7 ff ff       	jmp    80105be8 <alltraps>

80106454 <vector101>:
80106454:	6a 00                	push   $0x0
80106456:	6a 65                	push   $0x65
80106458:	e9 8b f7 ff ff       	jmp    80105be8 <alltraps>

8010645d <vector102>:
8010645d:	6a 00                	push   $0x0
8010645f:	6a 66                	push   $0x66
80106461:	e9 82 f7 ff ff       	jmp    80105be8 <alltraps>

80106466 <vector103>:
80106466:	6a 00                	push   $0x0
80106468:	6a 67                	push   $0x67
8010646a:	e9 79 f7 ff ff       	jmp    80105be8 <alltraps>

8010646f <vector104>:
8010646f:	6a 00                	push   $0x0
80106471:	6a 68                	push   $0x68
80106473:	e9 70 f7 ff ff       	jmp    80105be8 <alltraps>

80106478 <vector105>:
80106478:	6a 00                	push   $0x0
8010647a:	6a 69                	push   $0x69
8010647c:	e9 67 f7 ff ff       	jmp    80105be8 <alltraps>

80106481 <vector106>:
80106481:	6a 00                	push   $0x0
80106483:	6a 6a                	push   $0x6a
80106485:	e9 5e f7 ff ff       	jmp    80105be8 <alltraps>

8010648a <vector107>:
8010648a:	6a 00                	push   $0x0
8010648c:	6a 6b                	push   $0x6b
8010648e:	e9 55 f7 ff ff       	jmp    80105be8 <alltraps>

80106493 <vector108>:
80106493:	6a 00                	push   $0x0
80106495:	6a 6c                	push   $0x6c
80106497:	e9 4c f7 ff ff       	jmp    80105be8 <alltraps>

8010649c <vector109>:
8010649c:	6a 00                	push   $0x0
8010649e:	6a 6d                	push   $0x6d
801064a0:	e9 43 f7 ff ff       	jmp    80105be8 <alltraps>

801064a5 <vector110>:
801064a5:	6a 00                	push   $0x0
801064a7:	6a 6e                	push   $0x6e
801064a9:	e9 3a f7 ff ff       	jmp    80105be8 <alltraps>

801064ae <vector111>:
801064ae:	6a 00                	push   $0x0
801064b0:	6a 6f                	push   $0x6f
801064b2:	e9 31 f7 ff ff       	jmp    80105be8 <alltraps>

801064b7 <vector112>:
801064b7:	6a 00                	push   $0x0
801064b9:	6a 70                	push   $0x70
801064bb:	e9 28 f7 ff ff       	jmp    80105be8 <alltraps>

801064c0 <vector113>:
801064c0:	6a 00                	push   $0x0
801064c2:	6a 71                	push   $0x71
801064c4:	e9 1f f7 ff ff       	jmp    80105be8 <alltraps>

801064c9 <vector114>:
801064c9:	6a 00                	push   $0x0
801064cb:	6a 72                	push   $0x72
801064cd:	e9 16 f7 ff ff       	jmp    80105be8 <alltraps>

801064d2 <vector115>:
801064d2:	6a 00                	push   $0x0
801064d4:	6a 73                	push   $0x73
801064d6:	e9 0d f7 ff ff       	jmp    80105be8 <alltraps>

801064db <vector116>:
801064db:	6a 00                	push   $0x0
801064dd:	6a 74                	push   $0x74
801064df:	e9 04 f7 ff ff       	jmp    80105be8 <alltraps>

801064e4 <vector117>:
801064e4:	6a 00                	push   $0x0
801064e6:	6a 75                	push   $0x75
801064e8:	e9 fb f6 ff ff       	jmp    80105be8 <alltraps>

801064ed <vector118>:
801064ed:	6a 00                	push   $0x0
801064ef:	6a 76                	push   $0x76
801064f1:	e9 f2 f6 ff ff       	jmp    80105be8 <alltraps>

801064f6 <vector119>:
801064f6:	6a 00                	push   $0x0
801064f8:	6a 77                	push   $0x77
801064fa:	e9 e9 f6 ff ff       	jmp    80105be8 <alltraps>

801064ff <vector120>:
801064ff:	6a 00                	push   $0x0
80106501:	6a 78                	push   $0x78
80106503:	e9 e0 f6 ff ff       	jmp    80105be8 <alltraps>

80106508 <vector121>:
80106508:	6a 00                	push   $0x0
8010650a:	6a 79                	push   $0x79
8010650c:	e9 d7 f6 ff ff       	jmp    80105be8 <alltraps>

80106511 <vector122>:
80106511:	6a 00                	push   $0x0
80106513:	6a 7a                	push   $0x7a
80106515:	e9 ce f6 ff ff       	jmp    80105be8 <alltraps>

8010651a <vector123>:
8010651a:	6a 00                	push   $0x0
8010651c:	6a 7b                	push   $0x7b
8010651e:	e9 c5 f6 ff ff       	jmp    80105be8 <alltraps>

80106523 <vector124>:
80106523:	6a 00                	push   $0x0
80106525:	6a 7c                	push   $0x7c
80106527:	e9 bc f6 ff ff       	jmp    80105be8 <alltraps>

8010652c <vector125>:
8010652c:	6a 00                	push   $0x0
8010652e:	6a 7d                	push   $0x7d
80106530:	e9 b3 f6 ff ff       	jmp    80105be8 <alltraps>

80106535 <vector126>:
80106535:	6a 00                	push   $0x0
80106537:	6a 7e                	push   $0x7e
80106539:	e9 aa f6 ff ff       	jmp    80105be8 <alltraps>

8010653e <vector127>:
8010653e:	6a 00                	push   $0x0
80106540:	6a 7f                	push   $0x7f
80106542:	e9 a1 f6 ff ff       	jmp    80105be8 <alltraps>

80106547 <vector128>:
80106547:	6a 00                	push   $0x0
80106549:	68 80 00 00 00       	push   $0x80
8010654e:	e9 95 f6 ff ff       	jmp    80105be8 <alltraps>

80106553 <vector129>:
80106553:	6a 00                	push   $0x0
80106555:	68 81 00 00 00       	push   $0x81
8010655a:	e9 89 f6 ff ff       	jmp    80105be8 <alltraps>

8010655f <vector130>:
8010655f:	6a 00                	push   $0x0
80106561:	68 82 00 00 00       	push   $0x82
80106566:	e9 7d f6 ff ff       	jmp    80105be8 <alltraps>

8010656b <vector131>:
8010656b:	6a 00                	push   $0x0
8010656d:	68 83 00 00 00       	push   $0x83
80106572:	e9 71 f6 ff ff       	jmp    80105be8 <alltraps>

80106577 <vector132>:
80106577:	6a 00                	push   $0x0
80106579:	68 84 00 00 00       	push   $0x84
8010657e:	e9 65 f6 ff ff       	jmp    80105be8 <alltraps>

80106583 <vector133>:
80106583:	6a 00                	push   $0x0
80106585:	68 85 00 00 00       	push   $0x85
8010658a:	e9 59 f6 ff ff       	jmp    80105be8 <alltraps>

8010658f <vector134>:
8010658f:	6a 00                	push   $0x0
80106591:	68 86 00 00 00       	push   $0x86
80106596:	e9 4d f6 ff ff       	jmp    80105be8 <alltraps>

8010659b <vector135>:
8010659b:	6a 00                	push   $0x0
8010659d:	68 87 00 00 00       	push   $0x87
801065a2:	e9 41 f6 ff ff       	jmp    80105be8 <alltraps>

801065a7 <vector136>:
801065a7:	6a 00                	push   $0x0
801065a9:	68 88 00 00 00       	push   $0x88
801065ae:	e9 35 f6 ff ff       	jmp    80105be8 <alltraps>

801065b3 <vector137>:
801065b3:	6a 00                	push   $0x0
801065b5:	68 89 00 00 00       	push   $0x89
801065ba:	e9 29 f6 ff ff       	jmp    80105be8 <alltraps>

801065bf <vector138>:
801065bf:	6a 00                	push   $0x0
801065c1:	68 8a 00 00 00       	push   $0x8a
801065c6:	e9 1d f6 ff ff       	jmp    80105be8 <alltraps>

801065cb <vector139>:
801065cb:	6a 00                	push   $0x0
801065cd:	68 8b 00 00 00       	push   $0x8b
801065d2:	e9 11 f6 ff ff       	jmp    80105be8 <alltraps>

801065d7 <vector140>:
801065d7:	6a 00                	push   $0x0
801065d9:	68 8c 00 00 00       	push   $0x8c
801065de:	e9 05 f6 ff ff       	jmp    80105be8 <alltraps>

801065e3 <vector141>:
801065e3:	6a 00                	push   $0x0
801065e5:	68 8d 00 00 00       	push   $0x8d
801065ea:	e9 f9 f5 ff ff       	jmp    80105be8 <alltraps>

801065ef <vector142>:
801065ef:	6a 00                	push   $0x0
801065f1:	68 8e 00 00 00       	push   $0x8e
801065f6:	e9 ed f5 ff ff       	jmp    80105be8 <alltraps>

801065fb <vector143>:
801065fb:	6a 00                	push   $0x0
801065fd:	68 8f 00 00 00       	push   $0x8f
80106602:	e9 e1 f5 ff ff       	jmp    80105be8 <alltraps>

80106607 <vector144>:
80106607:	6a 00                	push   $0x0
80106609:	68 90 00 00 00       	push   $0x90
8010660e:	e9 d5 f5 ff ff       	jmp    80105be8 <alltraps>

80106613 <vector145>:
80106613:	6a 00                	push   $0x0
80106615:	68 91 00 00 00       	push   $0x91
8010661a:	e9 c9 f5 ff ff       	jmp    80105be8 <alltraps>

8010661f <vector146>:
8010661f:	6a 00                	push   $0x0
80106621:	68 92 00 00 00       	push   $0x92
80106626:	e9 bd f5 ff ff       	jmp    80105be8 <alltraps>

8010662b <vector147>:
8010662b:	6a 00                	push   $0x0
8010662d:	68 93 00 00 00       	push   $0x93
80106632:	e9 b1 f5 ff ff       	jmp    80105be8 <alltraps>

80106637 <vector148>:
80106637:	6a 00                	push   $0x0
80106639:	68 94 00 00 00       	push   $0x94
8010663e:	e9 a5 f5 ff ff       	jmp    80105be8 <alltraps>

80106643 <vector149>:
80106643:	6a 00                	push   $0x0
80106645:	68 95 00 00 00       	push   $0x95
8010664a:	e9 99 f5 ff ff       	jmp    80105be8 <alltraps>

8010664f <vector150>:
8010664f:	6a 00                	push   $0x0
80106651:	68 96 00 00 00       	push   $0x96
80106656:	e9 8d f5 ff ff       	jmp    80105be8 <alltraps>

8010665b <vector151>:
8010665b:	6a 00                	push   $0x0
8010665d:	68 97 00 00 00       	push   $0x97
80106662:	e9 81 f5 ff ff       	jmp    80105be8 <alltraps>

80106667 <vector152>:
80106667:	6a 00                	push   $0x0
80106669:	68 98 00 00 00       	push   $0x98
8010666e:	e9 75 f5 ff ff       	jmp    80105be8 <alltraps>

80106673 <vector153>:
80106673:	6a 00                	push   $0x0
80106675:	68 99 00 00 00       	push   $0x99
8010667a:	e9 69 f5 ff ff       	jmp    80105be8 <alltraps>

8010667f <vector154>:
8010667f:	6a 00                	push   $0x0
80106681:	68 9a 00 00 00       	push   $0x9a
80106686:	e9 5d f5 ff ff       	jmp    80105be8 <alltraps>

8010668b <vector155>:
8010668b:	6a 00                	push   $0x0
8010668d:	68 9b 00 00 00       	push   $0x9b
80106692:	e9 51 f5 ff ff       	jmp    80105be8 <alltraps>

80106697 <vector156>:
80106697:	6a 00                	push   $0x0
80106699:	68 9c 00 00 00       	push   $0x9c
8010669e:	e9 45 f5 ff ff       	jmp    80105be8 <alltraps>

801066a3 <vector157>:
801066a3:	6a 00                	push   $0x0
801066a5:	68 9d 00 00 00       	push   $0x9d
801066aa:	e9 39 f5 ff ff       	jmp    80105be8 <alltraps>

801066af <vector158>:
801066af:	6a 00                	push   $0x0
801066b1:	68 9e 00 00 00       	push   $0x9e
801066b6:	e9 2d f5 ff ff       	jmp    80105be8 <alltraps>

801066bb <vector159>:
801066bb:	6a 00                	push   $0x0
801066bd:	68 9f 00 00 00       	push   $0x9f
801066c2:	e9 21 f5 ff ff       	jmp    80105be8 <alltraps>

801066c7 <vector160>:
801066c7:	6a 00                	push   $0x0
801066c9:	68 a0 00 00 00       	push   $0xa0
801066ce:	e9 15 f5 ff ff       	jmp    80105be8 <alltraps>

801066d3 <vector161>:
801066d3:	6a 00                	push   $0x0
801066d5:	68 a1 00 00 00       	push   $0xa1
801066da:	e9 09 f5 ff ff       	jmp    80105be8 <alltraps>

801066df <vector162>:
801066df:	6a 00                	push   $0x0
801066e1:	68 a2 00 00 00       	push   $0xa2
801066e6:	e9 fd f4 ff ff       	jmp    80105be8 <alltraps>

801066eb <vector163>:
801066eb:	6a 00                	push   $0x0
801066ed:	68 a3 00 00 00       	push   $0xa3
801066f2:	e9 f1 f4 ff ff       	jmp    80105be8 <alltraps>

801066f7 <vector164>:
801066f7:	6a 00                	push   $0x0
801066f9:	68 a4 00 00 00       	push   $0xa4
801066fe:	e9 e5 f4 ff ff       	jmp    80105be8 <alltraps>

80106703 <vector165>:
80106703:	6a 00                	push   $0x0
80106705:	68 a5 00 00 00       	push   $0xa5
8010670a:	e9 d9 f4 ff ff       	jmp    80105be8 <alltraps>

8010670f <vector166>:
8010670f:	6a 00                	push   $0x0
80106711:	68 a6 00 00 00       	push   $0xa6
80106716:	e9 cd f4 ff ff       	jmp    80105be8 <alltraps>

8010671b <vector167>:
8010671b:	6a 00                	push   $0x0
8010671d:	68 a7 00 00 00       	push   $0xa7
80106722:	e9 c1 f4 ff ff       	jmp    80105be8 <alltraps>

80106727 <vector168>:
80106727:	6a 00                	push   $0x0
80106729:	68 a8 00 00 00       	push   $0xa8
8010672e:	e9 b5 f4 ff ff       	jmp    80105be8 <alltraps>

80106733 <vector169>:
80106733:	6a 00                	push   $0x0
80106735:	68 a9 00 00 00       	push   $0xa9
8010673a:	e9 a9 f4 ff ff       	jmp    80105be8 <alltraps>

8010673f <vector170>:
8010673f:	6a 00                	push   $0x0
80106741:	68 aa 00 00 00       	push   $0xaa
80106746:	e9 9d f4 ff ff       	jmp    80105be8 <alltraps>

8010674b <vector171>:
8010674b:	6a 00                	push   $0x0
8010674d:	68 ab 00 00 00       	push   $0xab
80106752:	e9 91 f4 ff ff       	jmp    80105be8 <alltraps>

80106757 <vector172>:
80106757:	6a 00                	push   $0x0
80106759:	68 ac 00 00 00       	push   $0xac
8010675e:	e9 85 f4 ff ff       	jmp    80105be8 <alltraps>

80106763 <vector173>:
80106763:	6a 00                	push   $0x0
80106765:	68 ad 00 00 00       	push   $0xad
8010676a:	e9 79 f4 ff ff       	jmp    80105be8 <alltraps>

8010676f <vector174>:
8010676f:	6a 00                	push   $0x0
80106771:	68 ae 00 00 00       	push   $0xae
80106776:	e9 6d f4 ff ff       	jmp    80105be8 <alltraps>

8010677b <vector175>:
8010677b:	6a 00                	push   $0x0
8010677d:	68 af 00 00 00       	push   $0xaf
80106782:	e9 61 f4 ff ff       	jmp    80105be8 <alltraps>

80106787 <vector176>:
80106787:	6a 00                	push   $0x0
80106789:	68 b0 00 00 00       	push   $0xb0
8010678e:	e9 55 f4 ff ff       	jmp    80105be8 <alltraps>

80106793 <vector177>:
80106793:	6a 00                	push   $0x0
80106795:	68 b1 00 00 00       	push   $0xb1
8010679a:	e9 49 f4 ff ff       	jmp    80105be8 <alltraps>

8010679f <vector178>:
8010679f:	6a 00                	push   $0x0
801067a1:	68 b2 00 00 00       	push   $0xb2
801067a6:	e9 3d f4 ff ff       	jmp    80105be8 <alltraps>

801067ab <vector179>:
801067ab:	6a 00                	push   $0x0
801067ad:	68 b3 00 00 00       	push   $0xb3
801067b2:	e9 31 f4 ff ff       	jmp    80105be8 <alltraps>

801067b7 <vector180>:
801067b7:	6a 00                	push   $0x0
801067b9:	68 b4 00 00 00       	push   $0xb4
801067be:	e9 25 f4 ff ff       	jmp    80105be8 <alltraps>

801067c3 <vector181>:
801067c3:	6a 00                	push   $0x0
801067c5:	68 b5 00 00 00       	push   $0xb5
801067ca:	e9 19 f4 ff ff       	jmp    80105be8 <alltraps>

801067cf <vector182>:
801067cf:	6a 00                	push   $0x0
801067d1:	68 b6 00 00 00       	push   $0xb6
801067d6:	e9 0d f4 ff ff       	jmp    80105be8 <alltraps>

801067db <vector183>:
801067db:	6a 00                	push   $0x0
801067dd:	68 b7 00 00 00       	push   $0xb7
801067e2:	e9 01 f4 ff ff       	jmp    80105be8 <alltraps>

801067e7 <vector184>:
801067e7:	6a 00                	push   $0x0
801067e9:	68 b8 00 00 00       	push   $0xb8
801067ee:	e9 f5 f3 ff ff       	jmp    80105be8 <alltraps>

801067f3 <vector185>:
801067f3:	6a 00                	push   $0x0
801067f5:	68 b9 00 00 00       	push   $0xb9
801067fa:	e9 e9 f3 ff ff       	jmp    80105be8 <alltraps>

801067ff <vector186>:
801067ff:	6a 00                	push   $0x0
80106801:	68 ba 00 00 00       	push   $0xba
80106806:	e9 dd f3 ff ff       	jmp    80105be8 <alltraps>

8010680b <vector187>:
8010680b:	6a 00                	push   $0x0
8010680d:	68 bb 00 00 00       	push   $0xbb
80106812:	e9 d1 f3 ff ff       	jmp    80105be8 <alltraps>

80106817 <vector188>:
80106817:	6a 00                	push   $0x0
80106819:	68 bc 00 00 00       	push   $0xbc
8010681e:	e9 c5 f3 ff ff       	jmp    80105be8 <alltraps>

80106823 <vector189>:
80106823:	6a 00                	push   $0x0
80106825:	68 bd 00 00 00       	push   $0xbd
8010682a:	e9 b9 f3 ff ff       	jmp    80105be8 <alltraps>

8010682f <vector190>:
8010682f:	6a 00                	push   $0x0
80106831:	68 be 00 00 00       	push   $0xbe
80106836:	e9 ad f3 ff ff       	jmp    80105be8 <alltraps>

8010683b <vector191>:
8010683b:	6a 00                	push   $0x0
8010683d:	68 bf 00 00 00       	push   $0xbf
80106842:	e9 a1 f3 ff ff       	jmp    80105be8 <alltraps>

80106847 <vector192>:
80106847:	6a 00                	push   $0x0
80106849:	68 c0 00 00 00       	push   $0xc0
8010684e:	e9 95 f3 ff ff       	jmp    80105be8 <alltraps>

80106853 <vector193>:
80106853:	6a 00                	push   $0x0
80106855:	68 c1 00 00 00       	push   $0xc1
8010685a:	e9 89 f3 ff ff       	jmp    80105be8 <alltraps>

8010685f <vector194>:
8010685f:	6a 00                	push   $0x0
80106861:	68 c2 00 00 00       	push   $0xc2
80106866:	e9 7d f3 ff ff       	jmp    80105be8 <alltraps>

8010686b <vector195>:
8010686b:	6a 00                	push   $0x0
8010686d:	68 c3 00 00 00       	push   $0xc3
80106872:	e9 71 f3 ff ff       	jmp    80105be8 <alltraps>

80106877 <vector196>:
80106877:	6a 00                	push   $0x0
80106879:	68 c4 00 00 00       	push   $0xc4
8010687e:	e9 65 f3 ff ff       	jmp    80105be8 <alltraps>

80106883 <vector197>:
80106883:	6a 00                	push   $0x0
80106885:	68 c5 00 00 00       	push   $0xc5
8010688a:	e9 59 f3 ff ff       	jmp    80105be8 <alltraps>

8010688f <vector198>:
8010688f:	6a 00                	push   $0x0
80106891:	68 c6 00 00 00       	push   $0xc6
80106896:	e9 4d f3 ff ff       	jmp    80105be8 <alltraps>

8010689b <vector199>:
8010689b:	6a 00                	push   $0x0
8010689d:	68 c7 00 00 00       	push   $0xc7
801068a2:	e9 41 f3 ff ff       	jmp    80105be8 <alltraps>

801068a7 <vector200>:
801068a7:	6a 00                	push   $0x0
801068a9:	68 c8 00 00 00       	push   $0xc8
801068ae:	e9 35 f3 ff ff       	jmp    80105be8 <alltraps>

801068b3 <vector201>:
801068b3:	6a 00                	push   $0x0
801068b5:	68 c9 00 00 00       	push   $0xc9
801068ba:	e9 29 f3 ff ff       	jmp    80105be8 <alltraps>

801068bf <vector202>:
801068bf:	6a 00                	push   $0x0
801068c1:	68 ca 00 00 00       	push   $0xca
801068c6:	e9 1d f3 ff ff       	jmp    80105be8 <alltraps>

801068cb <vector203>:
801068cb:	6a 00                	push   $0x0
801068cd:	68 cb 00 00 00       	push   $0xcb
801068d2:	e9 11 f3 ff ff       	jmp    80105be8 <alltraps>

801068d7 <vector204>:
801068d7:	6a 00                	push   $0x0
801068d9:	68 cc 00 00 00       	push   $0xcc
801068de:	e9 05 f3 ff ff       	jmp    80105be8 <alltraps>

801068e3 <vector205>:
801068e3:	6a 00                	push   $0x0
801068e5:	68 cd 00 00 00       	push   $0xcd
801068ea:	e9 f9 f2 ff ff       	jmp    80105be8 <alltraps>

801068ef <vector206>:
801068ef:	6a 00                	push   $0x0
801068f1:	68 ce 00 00 00       	push   $0xce
801068f6:	e9 ed f2 ff ff       	jmp    80105be8 <alltraps>

801068fb <vector207>:
801068fb:	6a 00                	push   $0x0
801068fd:	68 cf 00 00 00       	push   $0xcf
80106902:	e9 e1 f2 ff ff       	jmp    80105be8 <alltraps>

80106907 <vector208>:
80106907:	6a 00                	push   $0x0
80106909:	68 d0 00 00 00       	push   $0xd0
8010690e:	e9 d5 f2 ff ff       	jmp    80105be8 <alltraps>

80106913 <vector209>:
80106913:	6a 00                	push   $0x0
80106915:	68 d1 00 00 00       	push   $0xd1
8010691a:	e9 c9 f2 ff ff       	jmp    80105be8 <alltraps>

8010691f <vector210>:
8010691f:	6a 00                	push   $0x0
80106921:	68 d2 00 00 00       	push   $0xd2
80106926:	e9 bd f2 ff ff       	jmp    80105be8 <alltraps>

8010692b <vector211>:
8010692b:	6a 00                	push   $0x0
8010692d:	68 d3 00 00 00       	push   $0xd3
80106932:	e9 b1 f2 ff ff       	jmp    80105be8 <alltraps>

80106937 <vector212>:
80106937:	6a 00                	push   $0x0
80106939:	68 d4 00 00 00       	push   $0xd4
8010693e:	e9 a5 f2 ff ff       	jmp    80105be8 <alltraps>

80106943 <vector213>:
80106943:	6a 00                	push   $0x0
80106945:	68 d5 00 00 00       	push   $0xd5
8010694a:	e9 99 f2 ff ff       	jmp    80105be8 <alltraps>

8010694f <vector214>:
8010694f:	6a 00                	push   $0x0
80106951:	68 d6 00 00 00       	push   $0xd6
80106956:	e9 8d f2 ff ff       	jmp    80105be8 <alltraps>

8010695b <vector215>:
8010695b:	6a 00                	push   $0x0
8010695d:	68 d7 00 00 00       	push   $0xd7
80106962:	e9 81 f2 ff ff       	jmp    80105be8 <alltraps>

80106967 <vector216>:
80106967:	6a 00                	push   $0x0
80106969:	68 d8 00 00 00       	push   $0xd8
8010696e:	e9 75 f2 ff ff       	jmp    80105be8 <alltraps>

80106973 <vector217>:
80106973:	6a 00                	push   $0x0
80106975:	68 d9 00 00 00       	push   $0xd9
8010697a:	e9 69 f2 ff ff       	jmp    80105be8 <alltraps>

8010697f <vector218>:
8010697f:	6a 00                	push   $0x0
80106981:	68 da 00 00 00       	push   $0xda
80106986:	e9 5d f2 ff ff       	jmp    80105be8 <alltraps>

8010698b <vector219>:
8010698b:	6a 00                	push   $0x0
8010698d:	68 db 00 00 00       	push   $0xdb
80106992:	e9 51 f2 ff ff       	jmp    80105be8 <alltraps>

80106997 <vector220>:
80106997:	6a 00                	push   $0x0
80106999:	68 dc 00 00 00       	push   $0xdc
8010699e:	e9 45 f2 ff ff       	jmp    80105be8 <alltraps>

801069a3 <vector221>:
801069a3:	6a 00                	push   $0x0
801069a5:	68 dd 00 00 00       	push   $0xdd
801069aa:	e9 39 f2 ff ff       	jmp    80105be8 <alltraps>

801069af <vector222>:
801069af:	6a 00                	push   $0x0
801069b1:	68 de 00 00 00       	push   $0xde
801069b6:	e9 2d f2 ff ff       	jmp    80105be8 <alltraps>

801069bb <vector223>:
801069bb:	6a 00                	push   $0x0
801069bd:	68 df 00 00 00       	push   $0xdf
801069c2:	e9 21 f2 ff ff       	jmp    80105be8 <alltraps>

801069c7 <vector224>:
801069c7:	6a 00                	push   $0x0
801069c9:	68 e0 00 00 00       	push   $0xe0
801069ce:	e9 15 f2 ff ff       	jmp    80105be8 <alltraps>

801069d3 <vector225>:
801069d3:	6a 00                	push   $0x0
801069d5:	68 e1 00 00 00       	push   $0xe1
801069da:	e9 09 f2 ff ff       	jmp    80105be8 <alltraps>

801069df <vector226>:
801069df:	6a 00                	push   $0x0
801069e1:	68 e2 00 00 00       	push   $0xe2
801069e6:	e9 fd f1 ff ff       	jmp    80105be8 <alltraps>

801069eb <vector227>:
801069eb:	6a 00                	push   $0x0
801069ed:	68 e3 00 00 00       	push   $0xe3
801069f2:	e9 f1 f1 ff ff       	jmp    80105be8 <alltraps>

801069f7 <vector228>:
801069f7:	6a 00                	push   $0x0
801069f9:	68 e4 00 00 00       	push   $0xe4
801069fe:	e9 e5 f1 ff ff       	jmp    80105be8 <alltraps>

80106a03 <vector229>:
80106a03:	6a 00                	push   $0x0
80106a05:	68 e5 00 00 00       	push   $0xe5
80106a0a:	e9 d9 f1 ff ff       	jmp    80105be8 <alltraps>

80106a0f <vector230>:
80106a0f:	6a 00                	push   $0x0
80106a11:	68 e6 00 00 00       	push   $0xe6
80106a16:	e9 cd f1 ff ff       	jmp    80105be8 <alltraps>

80106a1b <vector231>:
80106a1b:	6a 00                	push   $0x0
80106a1d:	68 e7 00 00 00       	push   $0xe7
80106a22:	e9 c1 f1 ff ff       	jmp    80105be8 <alltraps>

80106a27 <vector232>:
80106a27:	6a 00                	push   $0x0
80106a29:	68 e8 00 00 00       	push   $0xe8
80106a2e:	e9 b5 f1 ff ff       	jmp    80105be8 <alltraps>

80106a33 <vector233>:
80106a33:	6a 00                	push   $0x0
80106a35:	68 e9 00 00 00       	push   $0xe9
80106a3a:	e9 a9 f1 ff ff       	jmp    80105be8 <alltraps>

80106a3f <vector234>:
80106a3f:	6a 00                	push   $0x0
80106a41:	68 ea 00 00 00       	push   $0xea
80106a46:	e9 9d f1 ff ff       	jmp    80105be8 <alltraps>

80106a4b <vector235>:
80106a4b:	6a 00                	push   $0x0
80106a4d:	68 eb 00 00 00       	push   $0xeb
80106a52:	e9 91 f1 ff ff       	jmp    80105be8 <alltraps>

80106a57 <vector236>:
80106a57:	6a 00                	push   $0x0
80106a59:	68 ec 00 00 00       	push   $0xec
80106a5e:	e9 85 f1 ff ff       	jmp    80105be8 <alltraps>

80106a63 <vector237>:
80106a63:	6a 00                	push   $0x0
80106a65:	68 ed 00 00 00       	push   $0xed
80106a6a:	e9 79 f1 ff ff       	jmp    80105be8 <alltraps>

80106a6f <vector238>:
80106a6f:	6a 00                	push   $0x0
80106a71:	68 ee 00 00 00       	push   $0xee
80106a76:	e9 6d f1 ff ff       	jmp    80105be8 <alltraps>

80106a7b <vector239>:
80106a7b:	6a 00                	push   $0x0
80106a7d:	68 ef 00 00 00       	push   $0xef
80106a82:	e9 61 f1 ff ff       	jmp    80105be8 <alltraps>

80106a87 <vector240>:
80106a87:	6a 00                	push   $0x0
80106a89:	68 f0 00 00 00       	push   $0xf0
80106a8e:	e9 55 f1 ff ff       	jmp    80105be8 <alltraps>

80106a93 <vector241>:
80106a93:	6a 00                	push   $0x0
80106a95:	68 f1 00 00 00       	push   $0xf1
80106a9a:	e9 49 f1 ff ff       	jmp    80105be8 <alltraps>

80106a9f <vector242>:
80106a9f:	6a 00                	push   $0x0
80106aa1:	68 f2 00 00 00       	push   $0xf2
80106aa6:	e9 3d f1 ff ff       	jmp    80105be8 <alltraps>

80106aab <vector243>:
80106aab:	6a 00                	push   $0x0
80106aad:	68 f3 00 00 00       	push   $0xf3
80106ab2:	e9 31 f1 ff ff       	jmp    80105be8 <alltraps>

80106ab7 <vector244>:
80106ab7:	6a 00                	push   $0x0
80106ab9:	68 f4 00 00 00       	push   $0xf4
80106abe:	e9 25 f1 ff ff       	jmp    80105be8 <alltraps>

80106ac3 <vector245>:
80106ac3:	6a 00                	push   $0x0
80106ac5:	68 f5 00 00 00       	push   $0xf5
80106aca:	e9 19 f1 ff ff       	jmp    80105be8 <alltraps>

80106acf <vector246>:
80106acf:	6a 00                	push   $0x0
80106ad1:	68 f6 00 00 00       	push   $0xf6
80106ad6:	e9 0d f1 ff ff       	jmp    80105be8 <alltraps>

80106adb <vector247>:
80106adb:	6a 00                	push   $0x0
80106add:	68 f7 00 00 00       	push   $0xf7
80106ae2:	e9 01 f1 ff ff       	jmp    80105be8 <alltraps>

80106ae7 <vector248>:
80106ae7:	6a 00                	push   $0x0
80106ae9:	68 f8 00 00 00       	push   $0xf8
80106aee:	e9 f5 f0 ff ff       	jmp    80105be8 <alltraps>

80106af3 <vector249>:
80106af3:	6a 00                	push   $0x0
80106af5:	68 f9 00 00 00       	push   $0xf9
80106afa:	e9 e9 f0 ff ff       	jmp    80105be8 <alltraps>

80106aff <vector250>:
80106aff:	6a 00                	push   $0x0
80106b01:	68 fa 00 00 00       	push   $0xfa
80106b06:	e9 dd f0 ff ff       	jmp    80105be8 <alltraps>

80106b0b <vector251>:
80106b0b:	6a 00                	push   $0x0
80106b0d:	68 fb 00 00 00       	push   $0xfb
80106b12:	e9 d1 f0 ff ff       	jmp    80105be8 <alltraps>

80106b17 <vector252>:
80106b17:	6a 00                	push   $0x0
80106b19:	68 fc 00 00 00       	push   $0xfc
80106b1e:	e9 c5 f0 ff ff       	jmp    80105be8 <alltraps>

80106b23 <vector253>:
80106b23:	6a 00                	push   $0x0
80106b25:	68 fd 00 00 00       	push   $0xfd
80106b2a:	e9 b9 f0 ff ff       	jmp    80105be8 <alltraps>

80106b2f <vector254>:
80106b2f:	6a 00                	push   $0x0
80106b31:	68 fe 00 00 00       	push   $0xfe
80106b36:	e9 ad f0 ff ff       	jmp    80105be8 <alltraps>

80106b3b <vector255>:
80106b3b:	6a 00                	push   $0x0
80106b3d:	68 ff 00 00 00       	push   $0xff
80106b42:	e9 a1 f0 ff ff       	jmp    80105be8 <alltraps>
80106b47:	66 90                	xchg   %ax,%ax
80106b49:	66 90                	xchg   %ax,%ax
80106b4b:	66 90                	xchg   %ax,%ax
80106b4d:	66 90                	xchg   %ax,%ax
80106b4f:	90                   	nop

80106b50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b5c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b62:	83 ec 1c             	sub    $0x1c,%esp
80106b65:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b68:	39 d3                	cmp    %edx,%ebx
80106b6a:	73 49                	jae    80106bb5 <deallocuvm.part.0+0x65>
80106b6c:	89 c7                	mov    %eax,%edi
80106b6e:	eb 0c                	jmp    80106b7c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b70:	83 c0 01             	add    $0x1,%eax
80106b73:	c1 e0 16             	shl    $0x16,%eax
80106b76:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b78:	39 da                	cmp    %ebx,%edx
80106b7a:	76 39                	jbe    80106bb5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106b7c:	89 d8                	mov    %ebx,%eax
80106b7e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b81:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106b84:	f6 c1 01             	test   $0x1,%cl
80106b87:	74 e7                	je     80106b70 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b89:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b8b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106b91:	c1 ee 0a             	shr    $0xa,%esi
80106b94:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b9a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106ba1:	85 f6                	test   %esi,%esi
80106ba3:	74 cb                	je     80106b70 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106ba5:	8b 06                	mov    (%esi),%eax
80106ba7:	a8 01                	test   $0x1,%al
80106ba9:	75 15                	jne    80106bc0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106bab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bb1:	39 da                	cmp    %ebx,%edx
80106bb3:	77 c7                	ja     80106b7c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bbb:	5b                   	pop    %ebx
80106bbc:	5e                   	pop    %esi
80106bbd:	5f                   	pop    %edi
80106bbe:	5d                   	pop    %ebp
80106bbf:	c3                   	ret    
      if(pa == 0)
80106bc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bc5:	74 25                	je     80106bec <deallocuvm.part.0+0x9c>
      kfree(v);
80106bc7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bca:	05 00 00 00 80       	add    $0x80000000,%eax
80106bcf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bd2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106bd8:	50                   	push   %eax
80106bd9:	e8 e2 b8 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106bde:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106be4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106be7:	83 c4 10             	add    $0x10,%esp
80106bea:	eb 8c                	jmp    80106b78 <deallocuvm.part.0+0x28>
        panic("kfree");
80106bec:	83 ec 0c             	sub    $0xc,%esp
80106bef:	68 c6 79 10 80       	push   $0x801079c6
80106bf4:	e8 87 97 ff ff       	call   80100380 <panic>
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <deallochugeuvm.part.0>:

// TODO: implement this
// part 2
// I havent touched this, only copy paste
int
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	89 d7                	mov    %edx,%edi
80106c06:	56                   	push   %esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = HUGEPGROUNDUP(newsz);
80106c07:	8d b1 ff ff 3f 00    	lea    0x3fffff(%ecx),%esi
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c0d:	53                   	push   %ebx
  a = HUGEPGROUNDUP(newsz);
80106c0e:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c14:	83 ec 1c             	sub    $0x1c,%esp
80106c17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c1a:	39 d6                	cmp    %edx,%esi
80106c1c:	72 0e                	jb     80106c2c <deallochugeuvm.part.0+0x2c>
80106c1e:	eb 3c                	jmp    80106c5c <deallochugeuvm.part.0+0x5c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
80106c20:	83 c1 01             	add    $0x1,%ecx
80106c23:	89 ce                	mov    %ecx,%esi
80106c25:	c1 e6 16             	shl    $0x16,%esi
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c28:	39 f7                	cmp    %esi,%edi
80106c2a:	76 30                	jbe    80106c5c <deallochugeuvm.part.0+0x5c>
  pde = &pgdir[PDX(va)];
80106c2c:	89 f1                	mov    %esi,%ecx
80106c2e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106c31:	8b 1c 88             	mov    (%eax,%ecx,4),%ebx
80106c34:	f6 c3 01             	test   $0x1,%bl
80106c37:	74 e7                	je     80106c20 <deallochugeuvm.part.0+0x20>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c39:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(!pte)
80106c3f:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80106c45:	74 d9                	je     80106c20 <deallochugeuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106c47:	8b 8b 00 00 00 80    	mov    -0x80000000(%ebx),%ecx
80106c4d:	f6 c1 01             	test   $0x1,%cl
80106c50:	75 1e                	jne    80106c70 <deallochugeuvm.part.0+0x70>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c52:	81 c6 00 00 40 00    	add    $0x400000,%esi
80106c58:	39 f7                	cmp    %esi,%edi
80106c5a:	77 d0                	ja     80106c2c <deallochugeuvm.part.0+0x2c>
      khugefree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c62:	5b                   	pop    %ebx
80106c63:	5e                   	pop    %esi
80106c64:	5f                   	pop    %edi
80106c65:	5d                   	pop    %ebp
80106c66:	c3                   	ret    
80106c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c6e:	66 90                	xchg   %ax,%ax
      if(pa == 0)
80106c70:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106c76:	74 2a                	je     80106ca2 <deallochugeuvm.part.0+0xa2>
      khugefree(v);
80106c78:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c7b:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80106c81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c84:	81 c6 00 00 40 00    	add    $0x400000,%esi
      khugefree(v);
80106c8a:	51                   	push   %ecx
80106c8b:	e8 f0 b9 ff ff       	call   80102680 <khugefree>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80106c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c93:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106c96:	c7 83 00 00 00 80 00 	movl   $0x0,-0x80000000(%ebx)
80106c9d:	00 00 00 
80106ca0:	eb 86                	jmp    80106c28 <deallochugeuvm.part.0+0x28>
        panic("khugefree");
80106ca2:	83 ec 0c             	sub    $0xc,%esp
80106ca5:	68 d1 79 10 80       	push   $0x801079d1
80106caa:	e8 d1 96 ff ff       	call   80100380 <panic>
80106caf:	90                   	nop

80106cb0 <mappages>:
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	56                   	push   %esi
80106cb5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106cb6:	89 d3                	mov    %edx,%ebx
80106cb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cbe:	83 ec 1c             	sub    $0x1c,%esp
80106cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cc4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106cc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ccd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106cd0:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd3:	29 d8                	sub    %ebx,%eax
80106cd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cd8:	eb 3d                	jmp    80106d17 <mappages+0x67>
80106cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ce0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ce2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ce7:	c1 ea 0a             	shr    $0xa,%edx
80106cea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106cf0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106cf7:	85 c0                	test   %eax,%eax
80106cf9:	74 75                	je     80106d70 <mappages+0xc0>
    if(*pte & PTE_P)
80106cfb:	f6 00 01             	testb  $0x1,(%eax)
80106cfe:	0f 85 86 00 00 00    	jne    80106d8a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d04:	0b 75 0c             	or     0xc(%ebp),%esi
80106d07:	83 ce 01             	or     $0x1,%esi
80106d0a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d0c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106d0f:	74 6f                	je     80106d80 <mappages+0xd0>
    a += PGSIZE;
80106d11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106d1a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d1d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106d20:	89 d8                	mov    %ebx,%eax
80106d22:	c1 e8 16             	shr    $0x16,%eax
80106d25:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106d28:	8b 07                	mov    (%edi),%eax
80106d2a:	a8 01                	test   $0x1,%al
80106d2c:	75 b2                	jne    80106ce0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d2e:	e8 8d ba ff ff       	call   801027c0 <kalloc>
80106d33:	85 c0                	test   %eax,%eax
80106d35:	74 39                	je     80106d70 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d37:	83 ec 04             	sub    $0x4,%esp
80106d3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d3d:	68 00 10 00 00       	push   $0x1000
80106d42:	6a 00                	push   $0x0
80106d44:	50                   	push   %eax
80106d45:	e8 46 db ff ff       	call   80104890 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106d4d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d50:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d56:	83 c8 07             	or     $0x7,%eax
80106d59:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d5b:	89 d8                	mov    %ebx,%eax
80106d5d:	c1 e8 0a             	shr    $0xa,%eax
80106d60:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d65:	01 d0                	add    %edx,%eax
80106d67:	eb 92                	jmp    80106cfb <mappages+0x4b>
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d78:	5b                   	pop    %ebx
80106d79:	5e                   	pop    %esi
80106d7a:	5f                   	pop    %edi
80106d7b:	5d                   	pop    %ebp
80106d7c:	c3                   	ret    
80106d7d:	8d 76 00             	lea    0x0(%esi),%esi
80106d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d83:	31 c0                	xor    %eax,%eax
}
80106d85:	5b                   	pop    %ebx
80106d86:	5e                   	pop    %esi
80106d87:	5f                   	pop    %edi
80106d88:	5d                   	pop    %ebp
80106d89:	c3                   	ret    
      panic("remap");
80106d8a:	83 ec 0c             	sub    $0xc,%esp
80106d8d:	68 2c 80 10 80       	push   $0x8010802c
80106d92:	e8 e9 95 ff ff       	call   80100380 <panic>
80106d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d9e:	66 90                	xchg   %ax,%ax

80106da0 <seginit>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106da6:	e8 55 cd ff ff       	call   80103b00 <cpuid>
  pd[0] = size-1;
80106dab:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106db0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106db6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106dba:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106dc1:	ff 00 00 
80106dc4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106dcb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106dce:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106dd5:	ff 00 00 
80106dd8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106ddf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106de2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106de9:	ff 00 00 
80106dec:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106df3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106df6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106dfd:	ff 00 00 
80106e00:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106e07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e0a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106e0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e13:	c1 e8 10             	shr    $0x10,%eax
80106e16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e1d:	0f 01 10             	lgdtl  (%eax)
}
80106e20:	c9                   	leave  
80106e21:	c3                   	ret    
80106e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e30:	a1 c4 55 11 80       	mov    0x801155c4,%eax
80106e35:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e3a:	0f 22 d8             	mov    %eax,%cr3
}
80106e3d:	c3                   	ret    
80106e3e:	66 90                	xchg   %ax,%ax

80106e40 <switchuvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106e4c:	85 f6                	test   %esi,%esi
80106e4e:	0f 84 cb 00 00 00    	je     80106f1f <switchuvm+0xdf>
  if(p->kstack == 0)
80106e54:	8b 46 0c             	mov    0xc(%esi),%eax
80106e57:	85 c0                	test   %eax,%eax
80106e59:	0f 84 da 00 00 00    	je     80106f39 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e5f:	8b 46 08             	mov    0x8(%esi),%eax
80106e62:	85 c0                	test   %eax,%eax
80106e64:	0f 84 c2 00 00 00    	je     80106f2c <switchuvm+0xec>
  pushcli();
80106e6a:	e8 11 d8 ff ff       	call   80104680 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e6f:	e8 2c cc ff ff       	call   80103aa0 <mycpu>
80106e74:	89 c3                	mov    %eax,%ebx
80106e76:	e8 25 cc ff ff       	call   80103aa0 <mycpu>
80106e7b:	89 c7                	mov    %eax,%edi
80106e7d:	e8 1e cc ff ff       	call   80103aa0 <mycpu>
80106e82:	83 c7 08             	add    $0x8,%edi
80106e85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e88:	e8 13 cc ff ff       	call   80103aa0 <mycpu>
80106e8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e90:	ba 67 00 00 00       	mov    $0x67,%edx
80106e95:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106e9c:	83 c0 08             	add    $0x8,%eax
80106e9f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ea6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eab:	83 c1 08             	add    $0x8,%ecx
80106eae:	c1 e8 18             	shr    $0x18,%eax
80106eb1:	c1 e9 10             	shr    $0x10,%ecx
80106eb4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106eba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ec0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ec5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ecc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ed1:	e8 ca cb ff ff       	call   80103aa0 <mycpu>
80106ed6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106edd:	e8 be cb ff ff       	call   80103aa0 <mycpu>
80106ee2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ee6:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106ee9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eef:	e8 ac cb ff ff       	call   80103aa0 <mycpu>
80106ef4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ef7:	e8 a4 cb ff ff       	call   80103aa0 <mycpu>
80106efc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f00:	b8 28 00 00 00       	mov    $0x28,%eax
80106f05:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f08:	8b 46 08             	mov    0x8(%esi),%eax
80106f0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f10:	0f 22 d8             	mov    %eax,%cr3
}
80106f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f16:	5b                   	pop    %ebx
80106f17:	5e                   	pop    %esi
80106f18:	5f                   	pop    %edi
80106f19:	5d                   	pop    %ebp
  popcli();
80106f1a:	e9 b1 d7 ff ff       	jmp    801046d0 <popcli>
    panic("switchuvm: no process");
80106f1f:	83 ec 0c             	sub    $0xc,%esp
80106f22:	68 32 80 10 80       	push   $0x80108032
80106f27:	e8 54 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106f2c:	83 ec 0c             	sub    $0xc,%esp
80106f2f:	68 5d 80 10 80       	push   $0x8010805d
80106f34:	e8 47 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106f39:	83 ec 0c             	sub    $0xc,%esp
80106f3c:	68 48 80 10 80       	push   $0x80108048
80106f41:	e8 3a 94 ff ff       	call   80100380 <panic>
80106f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4d:	8d 76 00             	lea    0x0(%esi),%esi

80106f50 <inituvm>:
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
80106f56:	83 ec 1c             	sub    $0x1c,%esp
80106f59:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f5c:	8b 75 10             	mov    0x10(%ebp),%esi
80106f5f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f65:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f6b:	77 4b                	ja     80106fb8 <inituvm+0x68>
  mem = kalloc();
80106f6d:	e8 4e b8 ff ff       	call   801027c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106f72:	83 ec 04             	sub    $0x4,%esp
80106f75:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106f7a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f7c:	6a 00                	push   $0x0
80106f7e:	50                   	push   %eax
80106f7f:	e8 0c d9 ff ff       	call   80104890 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f84:	58                   	pop    %eax
80106f85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f8b:	5a                   	pop    %edx
80106f8c:	6a 06                	push   $0x6
80106f8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f93:	31 d2                	xor    %edx,%edx
80106f95:	50                   	push   %eax
80106f96:	89 f8                	mov    %edi,%eax
80106f98:	e8 13 fd ff ff       	call   80106cb0 <mappages>
  memmove(mem, init, sz);
80106f9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fa0:	89 75 10             	mov    %esi,0x10(%ebp)
80106fa3:	83 c4 10             	add    $0x10,%esp
80106fa6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106fa9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106faf:	5b                   	pop    %ebx
80106fb0:	5e                   	pop    %esi
80106fb1:	5f                   	pop    %edi
80106fb2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106fb3:	e9 78 d9 ff ff       	jmp    80104930 <memmove>
    panic("inituvm: more than a page");
80106fb8:	83 ec 0c             	sub    $0xc,%esp
80106fbb:	68 71 80 10 80       	push   $0x80108071
80106fc0:	e8 bb 93 ff ff       	call   80100380 <panic>
80106fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106fd0 <loaduvm>:
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	57                   	push   %edi
80106fd4:	56                   	push   %esi
80106fd5:	53                   	push   %ebx
80106fd6:	83 ec 1c             	sub    $0x1c,%esp
80106fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fdc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106fdf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106fe4:	0f 85 bb 00 00 00    	jne    801070a5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106fea:	01 f0                	add    %esi,%eax
80106fec:	89 f3                	mov    %esi,%ebx
80106fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ff1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ff4:	01 f0                	add    %esi,%eax
80106ff6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ff9:	85 f6                	test   %esi,%esi
80106ffb:	0f 84 87 00 00 00    	je     80107088 <loaduvm+0xb8>
80107001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107008:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010700b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010700e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107010:	89 c2                	mov    %eax,%edx
80107012:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107015:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107018:	f6 c2 01             	test   $0x1,%dl
8010701b:	75 13                	jne    80107030 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010701d:	83 ec 0c             	sub    $0xc,%esp
80107020:	68 8b 80 10 80       	push   $0x8010808b
80107025:	e8 56 93 ff ff       	call   80100380 <panic>
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107030:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107033:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107039:	25 fc 0f 00 00       	and    $0xffc,%eax
8010703e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107045:	85 c0                	test   %eax,%eax
80107047:	74 d4                	je     8010701d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107049:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010704b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010704e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107053:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107058:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010705e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107061:	29 d9                	sub    %ebx,%ecx
80107063:	05 00 00 00 80       	add    $0x80000000,%eax
80107068:	57                   	push   %edi
80107069:	51                   	push   %ecx
8010706a:	50                   	push   %eax
8010706b:	ff 75 10             	push   0x10(%ebp)
8010706e:	e8 1d aa ff ff       	call   80101a90 <readi>
80107073:	83 c4 10             	add    $0x10,%esp
80107076:	39 f8                	cmp    %edi,%eax
80107078:	75 1e                	jne    80107098 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010707a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107080:	89 f0                	mov    %esi,%eax
80107082:	29 d8                	sub    %ebx,%eax
80107084:	39 c6                	cmp    %eax,%esi
80107086:	77 80                	ja     80107008 <loaduvm+0x38>
}
80107088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010708b:	31 c0                	xor    %eax,%eax
}
8010708d:	5b                   	pop    %ebx
8010708e:	5e                   	pop    %esi
8010708f:	5f                   	pop    %edi
80107090:	5d                   	pop    %ebp
80107091:	c3                   	ret    
80107092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107098:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010709b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070a0:	5b                   	pop    %ebx
801070a1:	5e                   	pop    %esi
801070a2:	5f                   	pop    %edi
801070a3:	5d                   	pop    %ebp
801070a4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801070a5:	83 ec 0c             	sub    $0xc,%esp
801070a8:	68 48 81 10 80       	push   $0x80108148
801070ad:	e8 ce 92 ff ff       	call   80100380 <panic>
801070b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070c0 <allocuvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801070c9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801070cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801070cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070d2:	85 c0                	test   %eax,%eax
801070d4:	0f 88 b6 00 00 00    	js     80107190 <allocuvm+0xd0>
  if(newsz < oldsz)
801070da:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801070dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801070e0:	0f 82 9a 00 00 00    	jb     80107180 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801070e6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801070ec:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801070f2:	39 75 10             	cmp    %esi,0x10(%ebp)
801070f5:	77 44                	ja     8010713b <allocuvm+0x7b>
801070f7:	e9 87 00 00 00       	jmp    80107183 <allocuvm+0xc3>
801070fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107100:	83 ec 04             	sub    $0x4,%esp
80107103:	68 00 10 00 00       	push   $0x1000
80107108:	6a 00                	push   $0x0
8010710a:	50                   	push   %eax
8010710b:	e8 80 d7 ff ff       	call   80104890 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107110:	58                   	pop    %eax
80107111:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107117:	5a                   	pop    %edx
80107118:	6a 06                	push   $0x6
8010711a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010711f:	89 f2                	mov    %esi,%edx
80107121:	50                   	push   %eax
80107122:	89 f8                	mov    %edi,%eax
80107124:	e8 87 fb ff ff       	call   80106cb0 <mappages>
80107129:	83 c4 10             	add    $0x10,%esp
8010712c:	85 c0                	test   %eax,%eax
8010712e:	78 78                	js     801071a8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107130:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107136:	39 75 10             	cmp    %esi,0x10(%ebp)
80107139:	76 48                	jbe    80107183 <allocuvm+0xc3>
    mem = kalloc();
8010713b:	e8 80 b6 ff ff       	call   801027c0 <kalloc>
80107140:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107142:	85 c0                	test   %eax,%eax
80107144:	75 ba                	jne    80107100 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107146:	83 ec 0c             	sub    $0xc,%esp
80107149:	68 a9 80 10 80       	push   $0x801080a9
8010714e:	e8 4d 95 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107153:	8b 45 0c             	mov    0xc(%ebp),%eax
80107156:	83 c4 10             	add    $0x10,%esp
80107159:	39 45 10             	cmp    %eax,0x10(%ebp)
8010715c:	74 32                	je     80107190 <allocuvm+0xd0>
8010715e:	8b 55 10             	mov    0x10(%ebp),%edx
80107161:	89 c1                	mov    %eax,%ecx
80107163:	89 f8                	mov    %edi,%eax
80107165:	e8 e6 f9 ff ff       	call   80106b50 <deallocuvm.part.0>
      return 0;
8010716a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107174:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107177:	5b                   	pop    %ebx
80107178:	5e                   	pop    %esi
80107179:	5f                   	pop    %edi
8010717a:	5d                   	pop    %ebp
8010717b:	c3                   	ret    
8010717c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107180:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107189:	5b                   	pop    %ebx
8010718a:	5e                   	pop    %esi
8010718b:	5f                   	pop    %edi
8010718c:	5d                   	pop    %ebp
8010718d:	c3                   	ret    
8010718e:	66 90                	xchg   %ax,%ax
    return 0;
80107190:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010719a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010719d:	5b                   	pop    %ebx
8010719e:	5e                   	pop    %esi
8010719f:	5f                   	pop    %edi
801071a0:	5d                   	pop    %ebp
801071a1:	c3                   	ret    
801071a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801071a8:	83 ec 0c             	sub    $0xc,%esp
801071ab:	68 c1 80 10 80       	push   $0x801080c1
801071b0:	e8 eb 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801071b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801071b8:	83 c4 10             	add    $0x10,%esp
801071bb:	39 45 10             	cmp    %eax,0x10(%ebp)
801071be:	74 0c                	je     801071cc <allocuvm+0x10c>
801071c0:	8b 55 10             	mov    0x10(%ebp),%edx
801071c3:	89 c1                	mov    %eax,%ecx
801071c5:	89 f8                	mov    %edi,%eax
801071c7:	e8 84 f9 ff ff       	call   80106b50 <deallocuvm.part.0>
      kfree(mem);
801071cc:	83 ec 0c             	sub    $0xc,%esp
801071cf:	53                   	push   %ebx
801071d0:	e8 eb b2 ff ff       	call   801024c0 <kfree>
      return 0;
801071d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801071dc:	83 c4 10             	add    $0x10,%esp
}
801071df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret    
801071ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071f0 <allochugeuvm>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071f9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801071fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107202:	85 c0                	test   %eax,%eax
80107204:	0f 88 c6 00 00 00    	js     801072d0 <allochugeuvm+0xe0>
  if(newsz < oldsz)
8010720a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010720d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107210:	0f 82 aa 00 00 00    	jb     801072c0 <allochugeuvm+0xd0>
  a = HUGEPGROUNDUP(oldsz);
80107216:	8d b0 ff ff 3f 00    	lea    0x3fffff(%eax),%esi
8010721c:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
  for(; a < newsz; a += HUGE_PAGE_SIZE){
80107222:	39 75 10             	cmp    %esi,0x10(%ebp)
80107225:	77 4f                	ja     80107276 <allochugeuvm+0x86>
80107227:	e9 97 00 00 00       	jmp    801072c3 <allochugeuvm+0xd3>
8010722c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, HUGE_PAGE_SIZE);
80107230:	83 ec 04             	sub    $0x4,%esp
80107233:	68 00 00 40 00       	push   $0x400000
80107238:	6a 00                	push   $0x0
8010723a:	50                   	push   %eax
8010723b:	e8 50 d6 ff ff       	call   80104890 <memset>
    if(mappages(pgdir, (char*)a + HUGE_VA_OFFSET, HUGE_PAGE_SIZE, V2P(mem), PTE_PS|PTE_W|PTE_U) < 0){
80107240:	58                   	pop    %eax
80107241:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107247:	59                   	pop    %ecx
80107248:	68 86 00 00 00       	push   $0x86
8010724d:	8d 96 00 00 00 1e    	lea    0x1e000000(%esi),%edx
80107253:	b9 00 00 40 00       	mov    $0x400000,%ecx
80107258:	50                   	push   %eax
80107259:	89 f8                	mov    %edi,%eax
8010725b:	e8 50 fa ff ff       	call   80106cb0 <mappages>
80107260:	83 c4 10             	add    $0x10,%esp
80107263:	85 c0                	test   %eax,%eax
80107265:	0f 88 7d 00 00 00    	js     801072e8 <allochugeuvm+0xf8>
  for(; a < newsz; a += HUGE_PAGE_SIZE){
8010726b:	81 c6 00 00 40 00    	add    $0x400000,%esi
80107271:	39 75 10             	cmp    %esi,0x10(%ebp)
80107274:	76 4d                	jbe    801072c3 <allochugeuvm+0xd3>
    mem = khugealloc();
80107276:	e8 b5 b5 ff ff       	call   80102830 <khugealloc>
8010727b:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010727d:	85 c0                	test   %eax,%eax
8010727f:	75 af                	jne    80107230 <allochugeuvm+0x40>
      cprintf("allochugeuvm out of memory\n");
80107281:	83 ec 0c             	sub    $0xc,%esp
80107284:	68 dd 80 10 80       	push   $0x801080dd
80107289:	e8 12 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
8010728e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107291:	83 c4 10             	add    $0x10,%esp
80107294:	39 45 10             	cmp    %eax,0x10(%ebp)
80107297:	74 37                	je     801072d0 <allochugeuvm+0xe0>
80107299:	8b 55 10             	mov    0x10(%ebp),%edx
8010729c:	89 c1                	mov    %eax,%ecx
8010729e:	89 f8                	mov    %edi,%eax
801072a0:	e8 5b f9 ff ff       	call   80106c00 <deallochugeuvm.part.0>
      return 0;
801072a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b2:	5b                   	pop    %ebx
801072b3:	5e                   	pop    %esi
801072b4:	5f                   	pop    %edi
801072b5:	5d                   	pop    %ebp
801072b6:	c3                   	ret    
801072b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072be:	66 90                	xchg   %ax,%ax
    return oldsz;
801072c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801072c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072c9:	5b                   	pop    %ebx
801072ca:	5e                   	pop    %esi
801072cb:	5f                   	pop    %edi
801072cc:	5d                   	pop    %ebp
801072cd:	c3                   	ret    
801072ce:	66 90                	xchg   %ax,%ax
    return 0;
801072d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072dd:	5b                   	pop    %ebx
801072de:	5e                   	pop    %esi
801072df:	5f                   	pop    %edi
801072e0:	5d                   	pop    %ebp
801072e1:	c3                   	ret    
801072e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allochugeuvm out of memory (2)\n");
801072e8:	83 ec 0c             	sub    $0xc,%esp
801072eb:	68 6c 81 10 80       	push   $0x8010816c
801072f0:	e8 ab 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072f8:	83 c4 10             	add    $0x10,%esp
801072fb:	39 45 10             	cmp    %eax,0x10(%ebp)
801072fe:	74 0c                	je     8010730c <allochugeuvm+0x11c>
80107300:	8b 55 10             	mov    0x10(%ebp),%edx
80107303:	89 c1                	mov    %eax,%ecx
80107305:	89 f8                	mov    %edi,%eax
80107307:	e8 f4 f8 ff ff       	call   80106c00 <deallochugeuvm.part.0>
      kfree(mem);
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	53                   	push   %ebx
80107310:	e8 ab b1 ff ff       	call   801024c0 <kfree>
      return 0;
80107315:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010731c:	83 c4 10             	add    $0x10,%esp
}
8010731f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107322:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
8010732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107330 <deallocuvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	8b 55 0c             	mov    0xc(%ebp),%edx
80107336:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107339:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010733c:	39 d1                	cmp    %edx,%ecx
8010733e:	73 10                	jae    80107350 <deallocuvm+0x20>
}
80107340:	5d                   	pop    %ebp
80107341:	e9 0a f8 ff ff       	jmp    80106b50 <deallocuvm.part.0>
80107346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734d:	8d 76 00             	lea    0x0(%esi),%esi
80107350:	89 d0                	mov    %edx,%eax
80107352:	5d                   	pop    %ebp
80107353:	c3                   	ret    
80107354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010735f:	90                   	nop

80107360 <deallochugeuvm>:
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	8b 55 0c             	mov    0xc(%ebp),%edx
80107366:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107369:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010736c:	39 d1                	cmp    %edx,%ecx
8010736e:	73 10                	jae    80107380 <deallochugeuvm+0x20>
}
80107370:	5d                   	pop    %ebp
80107371:	e9 8a f8 ff ff       	jmp    80106c00 <deallochugeuvm.part.0>
80107376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737d:	8d 76 00             	lea    0x0(%esi),%esi
80107380:	89 d0                	mov    %edx,%eax
80107382:	5d                   	pop    %ebp
80107383:	c3                   	ret    
80107384:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010738f:	90                   	nop

80107390 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 0c             	sub    $0xc,%esp
80107399:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010739c:	85 f6                	test   %esi,%esi
8010739e:	74 59                	je     801073f9 <freevm+0x69>
  if(newsz >= oldsz)
801073a0:	31 c9                	xor    %ecx,%ecx
801073a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073a7:	89 f0                	mov    %esi,%eax
801073a9:	89 f3                	mov    %esi,%ebx
801073ab:	e8 a0 f7 ff ff       	call   80106b50 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801073b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801073b6:	eb 0f                	jmp    801073c7 <freevm+0x37>
801073b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073bf:	90                   	nop
801073c0:	83 c3 04             	add    $0x4,%ebx
801073c3:	39 df                	cmp    %ebx,%edi
801073c5:	74 23                	je     801073ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801073c7:	8b 03                	mov    (%ebx),%eax
801073c9:	a8 01                	test   $0x1,%al
801073cb:	74 f3                	je     801073c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801073d2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801073dd:	50                   	push   %eax
801073de:	e8 dd b0 ff ff       	call   801024c0 <kfree>
801073e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073e6:	39 df                	cmp    %ebx,%edi
801073e8:	75 dd                	jne    801073c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801073ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f0:	5b                   	pop    %ebx
801073f1:	5e                   	pop    %esi
801073f2:	5f                   	pop    %edi
801073f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073f4:	e9 c7 b0 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	68 f9 80 10 80       	push   $0x801080f9
80107401:	e8 7a 8f ff ff       	call   80100380 <panic>
80107406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740d:	8d 76 00             	lea    0x0(%esi),%esi

80107410 <setupkvm>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	56                   	push   %esi
80107414:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107415:	e8 a6 b3 ff ff       	call   801027c0 <kalloc>
8010741a:	89 c6                	mov    %eax,%esi
8010741c:	85 c0                	test   %eax,%eax
8010741e:	74 42                	je     80107462 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107420:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107423:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107428:	68 00 10 00 00       	push   $0x1000
8010742d:	6a 00                	push   $0x0
8010742f:	50                   	push   %eax
80107430:	e8 5b d4 ff ff       	call   80104890 <memset>
80107435:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107438:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010743b:	83 ec 08             	sub    $0x8,%esp
8010743e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107441:	ff 73 0c             	push   0xc(%ebx)
80107444:	8b 13                	mov    (%ebx),%edx
80107446:	50                   	push   %eax
80107447:	29 c1                	sub    %eax,%ecx
80107449:	89 f0                	mov    %esi,%eax
8010744b:	e8 60 f8 ff ff       	call   80106cb0 <mappages>
80107450:	83 c4 10             	add    $0x10,%esp
80107453:	85 c0                	test   %eax,%eax
80107455:	78 19                	js     80107470 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107457:	83 c3 10             	add    $0x10,%ebx
8010745a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107460:	75 d6                	jne    80107438 <setupkvm+0x28>
}
80107462:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107465:	89 f0                	mov    %esi,%eax
80107467:	5b                   	pop    %ebx
80107468:	5e                   	pop    %esi
80107469:	5d                   	pop    %ebp
8010746a:	c3                   	ret    
8010746b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop
      freevm(pgdir);
80107470:	83 ec 0c             	sub    $0xc,%esp
80107473:	56                   	push   %esi
      return 0;
80107474:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107476:	e8 15 ff ff ff       	call   80107390 <freevm>
      return 0;
8010747b:	83 c4 10             	add    $0x10,%esp
}
8010747e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107481:	89 f0                	mov    %esi,%eax
80107483:	5b                   	pop    %ebx
80107484:	5e                   	pop    %esi
80107485:	5d                   	pop    %ebp
80107486:	c3                   	ret    
80107487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748e:	66 90                	xchg   %ax,%ax

80107490 <kvmalloc>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107496:	e8 75 ff ff ff       	call   80107410 <setupkvm>
8010749b:	a3 c4 55 11 80       	mov    %eax,0x801155c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074a0:	05 00 00 00 80       	add    $0x80000000,%eax
801074a5:	0f 22 d8             	mov    %eax,%cr3
}
801074a8:	c9                   	leave  
801074a9:	c3                   	ret    
801074aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	83 ec 08             	sub    $0x8,%esp
801074b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801074b9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801074bc:	89 c1                	mov    %eax,%ecx
801074be:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074c1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801074c4:	f6 c2 01             	test   $0x1,%dl
801074c7:	75 17                	jne    801074e0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801074c9:	83 ec 0c             	sub    $0xc,%esp
801074cc:	68 0a 81 10 80       	push   $0x8010810a
801074d1:	e8 aa 8e ff ff       	call   80100380 <panic>
801074d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074dd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801074f5:	85 c0                	test   %eax,%eax
801074f7:	74 d0                	je     801074c9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801074f9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074fc:	c9                   	leave  
801074fd:	c3                   	ret    
801074fe:	66 90                	xchg   %ax,%ax

80107500 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107509:	e8 02 ff ff ff       	call   80107410 <setupkvm>
8010750e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107511:	85 c0                	test   %eax,%eax
80107513:	0f 84 bd 00 00 00    	je     801075d6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107519:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010751c:	85 c9                	test   %ecx,%ecx
8010751e:	0f 84 b2 00 00 00    	je     801075d6 <copyuvm+0xd6>
80107524:	31 f6                	xor    %esi,%esi
80107526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107530:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107533:	89 f0                	mov    %esi,%eax
80107535:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107538:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010753b:	a8 01                	test   $0x1,%al
8010753d:	75 11                	jne    80107550 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010753f:	83 ec 0c             	sub    $0xc,%esp
80107542:	68 14 81 10 80       	push   $0x80108114
80107547:	e8 34 8e ff ff       	call   80100380 <panic>
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107550:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107552:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107557:	c1 ea 0a             	shr    $0xa,%edx
8010755a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107560:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107567:	85 c0                	test   %eax,%eax
80107569:	74 d4                	je     8010753f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010756b:	8b 00                	mov    (%eax),%eax
8010756d:	a8 01                	test   $0x1,%al
8010756f:	0f 84 9f 00 00 00    	je     80107614 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107575:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107577:	25 ff 0f 00 00       	and    $0xfff,%eax
8010757c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010757f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107585:	e8 36 b2 ff ff       	call   801027c0 <kalloc>
8010758a:	89 c3                	mov    %eax,%ebx
8010758c:	85 c0                	test   %eax,%eax
8010758e:	74 64                	je     801075f4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107590:	83 ec 04             	sub    $0x4,%esp
80107593:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107599:	68 00 10 00 00       	push   $0x1000
8010759e:	57                   	push   %edi
8010759f:	50                   	push   %eax
801075a0:	e8 8b d3 ff ff       	call   80104930 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801075a5:	58                   	pop    %eax
801075a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075ac:	5a                   	pop    %edx
801075ad:	ff 75 e4             	push   -0x1c(%ebp)
801075b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075b5:	89 f2                	mov    %esi,%edx
801075b7:	50                   	push   %eax
801075b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075bb:	e8 f0 f6 ff ff       	call   80106cb0 <mappages>
801075c0:	83 c4 10             	add    $0x10,%esp
801075c3:	85 c0                	test   %eax,%eax
801075c5:	78 21                	js     801075e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801075c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801075d0:	0f 87 5a ff ff ff    	ja     80107530 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801075d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075dc:	5b                   	pop    %ebx
801075dd:	5e                   	pop    %esi
801075de:	5f                   	pop    %edi
801075df:	5d                   	pop    %ebp
801075e0:	c3                   	ret    
801075e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801075e8:	83 ec 0c             	sub    $0xc,%esp
801075eb:	53                   	push   %ebx
801075ec:	e8 cf ae ff ff       	call   801024c0 <kfree>
      goto bad;
801075f1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801075f4:	83 ec 0c             	sub    $0xc,%esp
801075f7:	ff 75 e0             	push   -0x20(%ebp)
801075fa:	e8 91 fd ff ff       	call   80107390 <freevm>
  return 0;
801075ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107606:	83 c4 10             	add    $0x10,%esp
}
80107609:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010760c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010760f:	5b                   	pop    %ebx
80107610:	5e                   	pop    %esi
80107611:	5f                   	pop    %edi
80107612:	5d                   	pop    %ebp
80107613:	c3                   	ret    
      panic("copyuvm: page not present");
80107614:	83 ec 0c             	sub    $0xc,%esp
80107617:	68 2e 81 10 80       	push   $0x8010812e
8010761c:	e8 5f 8d ff ff       	call   80100380 <panic>
80107621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762f:	90                   	nop

80107630 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107636:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107639:	89 c1                	mov    %eax,%ecx
8010763b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010763e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107641:	f6 c2 01             	test   $0x1,%dl
80107644:	0f 84 00 01 00 00    	je     8010774a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010764a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010764d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107653:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107654:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107659:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107660:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107662:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107667:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010766a:	05 00 00 00 80       	add    $0x80000000,%eax
8010766f:	83 fa 05             	cmp    $0x5,%edx
80107672:	ba 00 00 00 00       	mov    $0x0,%edx
80107677:	0f 45 c2             	cmovne %edx,%eax
}
8010767a:	c3                   	ret    
8010767b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010767f:	90                   	nop

80107680 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	57                   	push   %edi
80107684:	56                   	push   %esi
80107685:	53                   	push   %ebx
80107686:	83 ec 0c             	sub    $0xc,%esp
80107689:	8b 75 14             	mov    0x14(%ebp),%esi
8010768c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010768f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107692:	85 f6                	test   %esi,%esi
80107694:	75 51                	jne    801076e7 <copyout+0x67>
80107696:	e9 a5 00 00 00       	jmp    80107740 <copyout+0xc0>
8010769b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010769f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801076a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801076a6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801076ac:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801076b2:	74 75                	je     80107729 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801076b4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801076b6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801076b9:	29 c3                	sub    %eax,%ebx
801076bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076c1:	39 f3                	cmp    %esi,%ebx
801076c3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801076c6:	29 f8                	sub    %edi,%eax
801076c8:	83 ec 04             	sub    $0x4,%esp
801076cb:	01 c1                	add    %eax,%ecx
801076cd:	53                   	push   %ebx
801076ce:	52                   	push   %edx
801076cf:	51                   	push   %ecx
801076d0:	e8 5b d2 ff ff       	call   80104930 <memmove>
    len -= n;
    buf += n;
801076d5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801076d8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801076de:	83 c4 10             	add    $0x10,%esp
    buf += n;
801076e1:	01 da                	add    %ebx,%edx
  while(len > 0){
801076e3:	29 de                	sub    %ebx,%esi
801076e5:	74 59                	je     80107740 <copyout+0xc0>
  if(*pde & PTE_P){
801076e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801076ea:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076ec:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801076ee:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076f1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801076f7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801076fa:	f6 c1 01             	test   $0x1,%cl
801076fd:	0f 84 4e 00 00 00    	je     80107751 <copyout.cold>
  return &pgtab[PTX(va)];
80107703:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107705:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010770b:	c1 eb 0c             	shr    $0xc,%ebx
8010770e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107714:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010771b:	89 d9                	mov    %ebx,%ecx
8010771d:	83 e1 05             	and    $0x5,%ecx
80107720:	83 f9 05             	cmp    $0x5,%ecx
80107723:	0f 84 77 ff ff ff    	je     801076a0 <copyout+0x20>
  }
  return 0;
}
80107729:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010772c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107731:	5b                   	pop    %ebx
80107732:	5e                   	pop    %esi
80107733:	5f                   	pop    %edi
80107734:	5d                   	pop    %ebp
80107735:	c3                   	ret    
80107736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010773d:	8d 76 00             	lea    0x0(%esi),%esi
80107740:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107743:	31 c0                	xor    %eax,%eax
}
80107745:	5b                   	pop    %ebx
80107746:	5e                   	pop    %esi
80107747:	5f                   	pop    %edi
80107748:	5d                   	pop    %ebp
80107749:	c3                   	ret    

8010774a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010774a:	a1 00 00 00 00       	mov    0x0,%eax
8010774f:	0f 0b                	ud2    

80107751 <copyout.cold>:
80107751:	a1 00 00 00 00       	mov    0x0,%eax
80107756:	0f 0b                	ud2    
