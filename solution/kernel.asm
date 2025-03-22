
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 66 11 80       	mov    $0x80116630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 32 10 80       	mov    $0x80103240,%eax
  jmp *%eax
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
8010004c:	68 a0 79 10 80       	push   $0x801079a0
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 15 46 00 00       	call   80104670 <initlock>
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
80100092:	68 a7 79 10 80       	push   $0x801079a7
80100097:	50                   	push   %eax
80100098:	e8 a3 44 00 00       	call   80104540 <initsleeplock>
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
801000e4:	e8 57 47 00 00       	call   80104840 <acquire>
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
80100162:	e8 79 46 00 00       	call   801047e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 44 00 00       	call   80104580 <acquiresleep>
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
801001a1:	68 ae 79 10 80       	push   $0x801079ae
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
801001be:	e8 5d 44 00 00       	call   80104620 <holdingsleep>
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
801001dc:	68 bf 79 10 80       	push   $0x801079bf
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
801001ff:	e8 1c 44 00 00       	call   80104620 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 43 00 00       	call   801045e0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 20 46 00 00       	call   80104840 <acquire>
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
8010026c:	e9 6f 45 00 00       	jmp    801047e0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 79 10 80       	push   $0x801079c6
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
801002a0:	e8 9b 45 00 00       	call   80104840 <acquire>
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
801002cd:	e8 0e 40 00 00       	call   801042e0 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 89 38 00 00       	call   80103b70 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 e5 44 00 00       	call   801047e0 <release>
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
8010034c:	e8 8f 44 00 00       	call   801047e0 <release>
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
801003a2:	68 cd 79 10 80       	push   $0x801079cd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 43 83 10 80 	movl   $0x80108343,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 42 00 00       	call   80104690 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 79 10 80       	push   $0x801079e1
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
8010041a:	e8 f1 5c 00 00       	call   80106110 <uartputc>
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
80100505:	e8 06 5c 00 00       	call   80106110 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 fa 5b 00 00       	call   80106110 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ee 5b 00 00       	call   80106110 <uartputc>
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
80100551:	e8 4a 44 00 00       	call   801049a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 95 43 00 00       	call   80104900 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 79 10 80       	push   $0x801079e5
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
801005ab:	e8 90 42 00 00       	call   80104840 <acquire>
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
801005e4:	e8 f7 41 00 00       	call   801047e0 <release>
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
80100636:	0f b6 92 10 7a 10 80 	movzbl -0x7fef85f0(%edx),%edx
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
801007e8:	e8 53 40 00 00       	call   80104840 <acquire>
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
80100838:	bf f8 79 10 80       	mov    $0x801079f8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 ff 10 80       	push   $0x8010ff40
8010085b:	e8 80 3f 00 00       	call   801047e0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 79 10 80       	push   $0x801079ff
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
80100893:	e8 a8 3f 00 00       	call   80104840 <acquire>
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
801009d0:	e8 0b 3e 00 00       	call   801047e0 <release>
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
80100a0e:	e9 6d 3a 00 00       	jmp    80104480 <procdump>
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
80100a44:	e8 57 39 00 00       	call   801043a0 <wakeup>
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
80100a66:	68 08 7a 10 80       	push   $0x80107a08
80100a6b:	68 40 ff 10 80       	push   $0x8010ff40
80100a70:	e8 fb 3b 00 00       	call   80104670 <initlock>

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
80100abc:	e8 af 30 00 00       	call   80103b70 <myproc>
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
80100b34:	e8 77 6a 00 00       	call   801075b0 <setupkvm>
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
80100ba3:	e8 68 66 00 00       	call   80107210 <allocuvm>
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
80100bd9:	e8 42 65 00 00       	call   80107120 <loaduvm>
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
80100c1b:	e8 10 69 00 00       	call   80107530 <freevm>
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
80100c62:	e8 a9 65 00 00       	call   80107210 <allocuvm>
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
80100c83:	e8 c8 69 00 00       	call   80107650 <clearpteu>
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
80100cd3:	e8 28 3e 00 00       	call   80104b00 <strlen>
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
80100ce7:	e8 14 3e 00 00       	call   80104b00 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 b3 6b 00 00       	call   801078b0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 1a 68 00 00       	call   80107530 <freevm>
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
80100d63:	e8 48 6b 00 00       	call   801078b0 <copyout>
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
80100da1:	e8 1a 3d 00 00       	call   80104ac0 <safestrcpy>
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
80100dd4:	e8 87 61 00 00       	call   80106f60 <switchuvm>
  freevm(oldpgdir);
80100dd9:	89 3c 24             	mov    %edi,(%esp)
80100ddc:	e8 4f 67 00 00       	call   80107530 <freevm>
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	31 c0                	xor    %eax,%eax
80100de6:	e9 31 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100deb:	e8 c0 21 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	68 21 7a 10 80       	push   $0x80107a21
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
80100e26:	68 2d 7a 10 80       	push   $0x80107a2d
80100e2b:	68 80 ff 10 80       	push   $0x8010ff80
80100e30:	e8 3b 38 00 00       	call   80104670 <initlock>
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
80100e51:	e8 ea 39 00 00       	call   80104840 <acquire>
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
80100e81:	e8 5a 39 00 00       	call   801047e0 <release>
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
80100e9a:	e8 41 39 00 00       	call   801047e0 <release>
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
80100ebf:	e8 7c 39 00 00       	call   80104840 <acquire>
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
80100edc:	e8 ff 38 00 00       	call   801047e0 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 34 7a 10 80       	push   $0x80107a34
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
80100f11:	e8 2a 39 00 00       	call   80104840 <acquire>
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
80100f4c:	e8 8f 38 00 00       	call   801047e0 <release>

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
80100f7e:	e9 5d 38 00 00       	jmp    801047e0 <release>
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
80100fb9:	e8 72 27 00 00       	call   80103730 <pipeclose>
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
80100fcc:	68 3c 7a 10 80       	push   $0x80107a3c
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
8010109d:	e9 2e 28 00 00       	jmp    801038d0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 46 7a 10 80       	push   $0x80107a46
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
80101187:	68 4f 7a 10 80       	push   $0x80107a4f
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
801011b9:	e9 12 26 00 00       	jmp    801037d0 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 55 7a 10 80       	push   $0x80107a55
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
80101237:	68 5f 7a 10 80       	push   $0x80107a5f
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
801012f4:	68 72 7a 10 80       	push   $0x80107a72
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
80101335:	e8 c6 35 00 00       	call   80104900 <memset>
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
8010137a:	e8 c1 34 00 00       	call   80104840 <acquire>
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
801013e7:	e8 f4 33 00 00       	call   801047e0 <release>

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
80101415:	e8 c6 33 00 00       	call   801047e0 <release>
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
80101448:	68 88 7a 10 80       	push   $0x80107a88
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
80101525:	68 98 7a 10 80       	push   $0x80107a98
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
80101551:	e8 4a 34 00 00       	call   801049a0 <memmove>
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
8010157c:	68 ab 7a 10 80       	push   $0x80107aab
80101581:	68 80 09 11 80       	push   $0x80110980
80101586:	e8 e5 30 00 00       	call   80104670 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 b2 7a 10 80       	push   $0x80107ab2
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 9c 2f 00 00       	call   80104540 <initsleeplock>
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
801015cc:	e8 cf 33 00 00       	call   801049a0 <memmove>
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
80101603:	68 18 7b 10 80       	push   $0x80107b18
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
8010169e:	e8 5d 32 00 00       	call   80104900 <memset>
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
801016d3:	68 b8 7a 10 80       	push   $0x80107ab8
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
80101741:	e8 5a 32 00 00       	call   801049a0 <memmove>
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
8010176f:	e8 cc 30 00 00       	call   80104840 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010177f:	e8 5c 30 00 00       	call   801047e0 <release>
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
801017b2:	e8 c9 2d 00 00       	call   80104580 <acquiresleep>
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
80101828:	e8 73 31 00 00       	call   801049a0 <memmove>
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
8010184d:	68 d0 7a 10 80       	push   $0x80107ad0
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 ca 7a 10 80       	push   $0x80107aca
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
80101883:	e8 98 2d 00 00       	call   80104620 <holdingsleep>
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
8010189f:	e9 3c 2d 00 00       	jmp    801045e0 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 df 7a 10 80       	push   $0x80107adf
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
801018d0:	e8 ab 2c 00 00       	call   80104580 <acquiresleep>
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
801018ea:	e8 f1 2c 00 00       	call   801045e0 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
801018f6:	e8 45 2f 00 00       	call   80104840 <acquire>
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
80101910:	e9 cb 2e 00 00       	jmp    801047e0 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 80 09 11 80       	push   $0x80110980
80101920:	e8 1b 2f 00 00       	call   80104840 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010192f:	e8 ac 2e 00 00       	call   801047e0 <release>
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
80101a33:	e8 e8 2b 00 00       	call   80104620 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 91 2b 00 00       	call   801045e0 <releasesleep>
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
80101a63:	68 df 7a 10 80       	push   $0x80107adf
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
80101b47:	e8 54 2e 00 00       	call   801049a0 <memmove>
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
80101c43:	e8 58 2d 00 00       	call   801049a0 <memmove>
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
80101cde:	e8 2d 2d 00 00       	call   80104a10 <strncmp>
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
80101d3d:	e8 ce 2c 00 00       	call   80104a10 <strncmp>
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
80101d82:	68 f9 7a 10 80       	push   $0x80107af9
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 e7 7a 10 80       	push   $0x80107ae7
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
80101dba:	e8 b1 1d 00 00       	call   80103b70 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 80 09 11 80       	push   $0x80110980
80101dca:	e8 71 2a 00 00       	call   80104840 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101dda:	e8 01 2a 00 00       	call   801047e0 <release>
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
80101e37:	e8 64 2b 00 00       	call   801049a0 <memmove>
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
80101e9c:	e8 7f 27 00 00       	call   80104620 <holdingsleep>
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
80101ebe:	e8 1d 27 00 00       	call   801045e0 <releasesleep>
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
80101eeb:	e8 b0 2a 00 00       	call   801049a0 <memmove>
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
80101f3b:	e8 e0 26 00 00       	call   80104620 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 81 26 00 00       	call   801045e0 <releasesleep>
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
80101f7d:	e8 9e 26 00 00       	call   80104620 <holdingsleep>
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
80101fa0:	e8 7b 26 00 00       	call   80104620 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 24 26 00 00       	call   801045e0 <releasesleep>
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
80101fdf:	68 df 7a 10 80       	push   $0x80107adf
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
8010204d:	e8 0e 2a 00 00       	call   80104a60 <strncpy>
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
8010208b:	68 08 7b 10 80       	push   $0x80107b08
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 12 81 10 80       	push   $0x80108112
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
801021ab:	68 74 7b 10 80       	push   $0x80107b74
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 6b 7b 10 80       	push   $0x80107b6b
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 86 7b 10 80       	push   $0x80107b86
801021db:	68 20 26 11 80       	push   $0x80112620
801021e0:	e8 8b 24 00 00       	call   80104670 <initlock>
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
8010225e:	e8 dd 25 00 00       	call   80104840 <acquire>

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
801022bd:	e8 de 20 00 00       	call   801043a0 <wakeup>

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
801022db:	e8 00 25 00 00       	call   801047e0 <release>

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
801022fe:	e8 1d 23 00 00       	call   80104620 <holdingsleep>
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
80102338:	e8 03 25 00 00       	call   80104840 <acquire>

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
80102379:	e8 62 1f 00 00       	call   801042e0 <sleep>
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
80102396:	e9 45 24 00 00       	jmp    801047e0 <release>
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
801023ba:	68 b5 7b 10 80       	push   $0x80107bb5
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 a0 7b 10 80       	push   $0x80107ba0
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 8a 7b 10 80       	push   $0x80107b8a
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
8010242a:	68 d4 7b 10 80       	push   $0x80107bd4
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
80102502:	e8 f9 23 00 00       	call   80104900 <memset>

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
80102538:	e8 03 23 00 00       	call   80104840 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 88 22 00 00       	jmp    801047e0 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 06 7c 10 80       	push   $0x80107c06
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
8010262b:	68 0c 7c 10 80       	push   $0x80107c0c
80102630:	68 a0 26 11 80       	push   $0x801126a0
80102635:	e8 36 20 00 00       	call   80104670 <initlock>
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
801026ba:	e8 41 22 00 00       	call   80104900 <memset>

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
801026f8:	e8 43 21 00 00       	call   80104840 <acquire>
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	eb ca                	jmp    801026cc <khugefree+0x3c>
80102702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&khugemem.lock);
80102708:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010270f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102712:	c9                   	leave  
    release(&khugemem.lock);
80102713:	e9 c8 20 00 00       	jmp    801047e0 <release>
    panic("khugefree");
80102718:	83 ec 0c             	sub    $0xc,%esp
8010271b:	68 11 7c 10 80       	push   $0x80107c11
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
8010278b:	68 1b 7c 10 80       	push   $0x80107c1b
80102790:	68 60 26 11 80       	push   $0x80112660
80102795:	e8 d6 1e 00 00       	call   80104670 <initlock>
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
80102823:	e8 18 20 00 00       	call   80104840 <acquire>
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
80102851:	e8 8a 1f 00 00       	call   801047e0 <release>
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
80102893:	e8 a8 1f 00 00       	call   80104840 <acquire>
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
801028c1:	e8 1a 1f 00 00       	call   801047e0 <release>
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
8010290b:	0f b6 91 60 7d 10 80 	movzbl -0x7fef82a0(%ecx),%edx
  shift ^= togglecode[data];
80102912:	0f b6 81 60 7c 10 80 	movzbl -0x7fef83a0(%ecx),%eax
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
8010292b:	8b 04 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%eax
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
80102968:	0f b6 81 60 7d 10 80 	movzbl -0x7fef82a0(%ecx),%eax
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
80102cd7:	e8 74 1c 00 00       	call   80104950 <memcmp>
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
80102e04:	e8 97 1b 00 00       	call   801049a0 <memmove>
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
80102eaa:	68 60 7e 10 80       	push   $0x80107e60
80102eaf:	68 00 27 11 80       	push   $0x80112700
80102eb4:	e8 b7 17 00 00       	call   80104670 <initlock>
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
80102f4b:	e8 f0 18 00 00       	call   80104840 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 00 27 11 80       	push   $0x80112700
80102f60:	68 00 27 11 80       	push   $0x80112700
80102f65:	e8 76 13 00 00       	call   801042e0 <sleep>
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
80102f9c:	e8 3f 18 00 00       	call   801047e0 <release>
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
80102fbe:	e8 7d 18 00 00       	call   80104840 <acquire>
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
80102ffc:	e8 df 17 00 00       	call   801047e0 <release>
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
80103016:	e8 25 18 00 00       	call   80104840 <acquire>
    wakeup(&log);
8010301b:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
    log.committing = 0;
80103022:	c7 05 40 27 11 80 00 	movl   $0x0,0x80112740
80103029:	00 00 00 
    wakeup(&log);
8010302c:	e8 6f 13 00 00       	call   801043a0 <wakeup>
    release(&log.lock);
80103031:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
80103038:	e8 a3 17 00 00       	call   801047e0 <release>
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
80103094:	e8 07 19 00 00       	call   801049a0 <memmove>
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
801030e8:	e8 b3 12 00 00       	call   801043a0 <wakeup>
  release(&log.lock);
801030ed:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
801030f4:	e8 e7 16 00 00       	call   801047e0 <release>
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
80103107:	68 64 7e 10 80       	push   $0x80107e64
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
80103156:	e8 e5 16 00 00       	call   80104840 <acquire>
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
80103195:	e9 46 16 00 00       	jmp    801047e0 <release>
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
801031c1:	68 73 7e 10 80       	push   $0x80107e73
801031c6:	e8 b5 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031cb:	83 ec 0c             	sub    $0xc,%esp
801031ce:	68 89 7e 10 80       	push   $0x80107e89
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
801031e7:	e8 64 09 00 00       	call   80103b50 <cpuid>
801031ec:	89 c3                	mov    %eax,%ebx
801031ee:	e8 5d 09 00 00       	call   80103b50 <cpuid>
801031f3:	83 ec 04             	sub    $0x4,%esp
801031f6:	53                   	push   %ebx
801031f7:	50                   	push   %eax
801031f8:	68 a4 7e 10 80       	push   $0x80107ea4
801031fd:	e8 9e d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103202:	e8 39 2b 00 00       	call   80105d40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103207:	e8 e4 08 00 00       	call   80103af0 <mycpu>
8010320c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010320e:	b8 01 00 00 00       	mov    $0x1,%eax
80103213:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010321a:	e8 b1 0c 00 00       	call   80103ed0 <scheduler>
8010321f:	90                   	nop

80103220 <mpenter>:
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103226:	e8 25 3d 00 00       	call   80106f50 <switchkvm>
  seginit();
8010322b:	e8 90 3c 00 00       	call   80106ec0 <seginit>
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
  GLOBAL_THP = 0;
8010324b:	c7 05 b8 4d 11 80 00 	movl   $0x0,0x80114db8
80103252:	00 00 00 
{
80103255:	89 e5                	mov    %esp,%ebp
80103257:	53                   	push   %ebx
80103258:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103259:	83 ec 08             	sub    $0x8,%esp
8010325c:	68 00 00 40 80       	push   $0x80400000
80103261:	68 30 66 11 80       	push   $0x80116630
80103266:	e8 b5 f3 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
8010326b:	e8 c0 43 00 00       	call   80107630 <kvmalloc>
  mpinit();        // detect other processors
80103270:	e8 9b 01 00 00       	call   80103410 <mpinit>
  lapicinit();     // interrupt controller
80103275:	e8 56 f7 ff ff       	call   801029d0 <lapicinit>
  seginit();       // segment descriptors
8010327a:	e8 41 3c 00 00       	call   80106ec0 <seginit>
  picinit();       // disable pic
8010327f:	e8 8c 03 00 00       	call   80103610 <picinit>
  ioapicinit();    // another interrupt controller
80103284:	e8 57 f1 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
80103289:	e8 d2 d7 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
8010328e:	e8 9d 2d 00 00       	call   80106030 <uartinit>
  pinit();         // process table
80103293:	e8 38 08 00 00       	call   80103ad0 <pinit>
  tvinit();        // trap vectors
80103298:	e8 23 2a 00 00       	call   80105cc0 <tvinit>
  binit();         // buffer cache
8010329d:	e8 9e cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032a2:	e8 79 db ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801032a7:	e8 24 ef ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032ac:	83 c4 0c             	add    $0xc,%esp
801032af:	68 8a 00 00 00       	push   $0x8a
801032b4:	68 9c b4 10 80       	push   $0x8010b49c
801032b9:	68 00 70 00 80       	push   $0x80007000
801032be:	e8 dd 16 00 00       	call   801049a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032c3:	83 c4 10             	add    $0x10,%esp
801032c6:	69 05 e4 27 11 80 b0 	imul   $0xb0,0x801127e4,%eax
801032cd:	00 00 00 
801032d0:	05 00 28 11 80       	add    $0x80112800,%eax
801032d5:	3d 00 28 11 80       	cmp    $0x80112800,%eax
801032da:	76 7c                	jbe    80103358 <main+0x118>
801032dc:	bb 00 28 11 80       	mov    $0x80112800,%ebx
801032e1:	eb 1e                	jmp    80103301 <main+0xc1>
801032e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032e7:	90                   	nop
801032e8:	69 05 e4 27 11 80 b0 	imul   $0xb0,0x801127e4,%eax
801032ef:	00 00 00 
801032f2:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032f8:	05 00 28 11 80       	add    $0x80112800,%eax
801032fd:	39 c3                	cmp    %eax,%ebx
801032ff:	73 57                	jae    80103358 <main+0x118>
    if(c == mycpu())  // We've started already.
80103301:	e8 ea 07 00 00       	call   80103af0 <mycpu>
80103306:	39 c3                	cmp    %eax,%ebx
80103308:	74 de                	je     801032e8 <main+0xa8>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010330a:	e8 e1 f4 ff ff       	call   801027f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
8010330f:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103312:	c7 05 f8 6f 00 80 20 	movl   $0x80103220,0x80006ff8
80103319:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010331c:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103323:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103326:	05 00 10 00 00       	add    $0x1000,%eax
8010332b:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103330:	0f b6 03             	movzbl (%ebx),%eax
80103333:	68 00 70 00 00       	push   $0x7000
80103338:	50                   	push   %eax
80103339:	e8 e2 f7 ff ff       	call   80102b20 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010333e:	83 c4 10             	add    $0x10,%esp
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103348:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010334e:	85 c0                	test   %eax,%eax
80103350:	74 f6                	je     80103348 <main+0x108>
80103352:	eb 94                	jmp    801032e8 <main+0xa8>
80103354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103358:	83 ec 08             	sub    $0x8,%esp
8010335b:	68 00 00 00 8e       	push   $0x8e000000
80103360:	68 00 00 40 80       	push   $0x80400000
80103365:	e8 56 f2 ff ff       	call   801025c0 <kinit2>
  khugeinit(P2V(HUGE_PAGE_START), P2V(HUGE_PAGE_END));
8010336a:	58                   	pop    %eax
8010336b:	5a                   	pop    %edx
8010336c:	68 00 00 00 be       	push   $0xbe000000
80103371:	68 00 00 00 9e       	push   $0x9e000000
80103376:	e8 05 f4 ff ff       	call   80102780 <khugeinit>
  userinit();      // first user process
8010337b:	e8 20 08 00 00       	call   80103ba0 <userinit>
  mpmain();        // finish this processor's setup
80103380:	e8 5b fe ff ff       	call   801031e0 <mpmain>
80103385:	66 90                	xchg   %ax,%ax
80103387:	66 90                	xchg   %ax,%ax
80103389:	66 90                	xchg   %ax,%ax
8010338b:	66 90                	xchg   %ax,%ax
8010338d:	66 90                	xchg   %ax,%ax
8010338f:	90                   	nop

80103390 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103395:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010339b:	53                   	push   %ebx
  e = addr+len;
8010339c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010339f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033a2:	39 de                	cmp    %ebx,%esi
801033a4:	72 10                	jb     801033b6 <mpsearch1+0x26>
801033a6:	eb 50                	jmp    801033f8 <mpsearch1+0x68>
801033a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033af:	90                   	nop
801033b0:	89 fe                	mov    %edi,%esi
801033b2:	39 fb                	cmp    %edi,%ebx
801033b4:	76 42                	jbe    801033f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b6:	83 ec 04             	sub    $0x4,%esp
801033b9:	8d 7e 10             	lea    0x10(%esi),%edi
801033bc:	6a 04                	push   $0x4
801033be:	68 b8 7e 10 80       	push   $0x80107eb8
801033c3:	56                   	push   %esi
801033c4:	e8 87 15 00 00       	call   80104950 <memcmp>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	85 c0                	test   %eax,%eax
801033ce:	75 e0                	jne    801033b0 <mpsearch1+0x20>
801033d0:	89 f2                	mov    %esi,%edx
801033d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e0:	39 fa                	cmp    %edi,%edx
801033e2:	75 f4                	jne    801033d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e4:	84 c0                	test   %al,%al
801033e6:	75 c8                	jne    801033b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033eb:	89 f0                	mov    %esi,%eax
801033ed:	5b                   	pop    %ebx
801033ee:	5e                   	pop    %esi
801033ef:	5f                   	pop    %edi
801033f0:	5d                   	pop    %ebp
801033f1:	c3                   	ret    
801033f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033fb:	31 f6                	xor    %esi,%esi
}
801033fd:	5b                   	pop    %ebx
801033fe:	89 f0                	mov    %esi,%eax
80103400:	5e                   	pop    %esi
80103401:	5f                   	pop    %edi
80103402:	5d                   	pop    %ebp
80103403:	c3                   	ret    
80103404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010340f:	90                   	nop

80103410 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103419:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103420:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103427:	c1 e0 08             	shl    $0x8,%eax
8010342a:	09 d0                	or     %edx,%eax
8010342c:	c1 e0 04             	shl    $0x4,%eax
8010342f:	75 1b                	jne    8010344c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103431:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103438:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010343f:	c1 e0 08             	shl    $0x8,%eax
80103442:	09 d0                	or     %edx,%eax
80103444:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103447:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010344c:	ba 00 04 00 00       	mov    $0x400,%edx
80103451:	e8 3a ff ff ff       	call   80103390 <mpsearch1>
80103456:	89 c3                	mov    %eax,%ebx
80103458:	85 c0                	test   %eax,%eax
8010345a:	0f 84 40 01 00 00    	je     801035a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103460:	8b 73 04             	mov    0x4(%ebx),%esi
80103463:	85 f6                	test   %esi,%esi
80103465:	0f 84 25 01 00 00    	je     80103590 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010346b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010346e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103474:	6a 04                	push   $0x4
80103476:	68 bd 7e 10 80       	push   $0x80107ebd
8010347b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010347c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010347f:	e8 cc 14 00 00       	call   80104950 <memcmp>
80103484:	83 c4 10             	add    $0x10,%esp
80103487:	85 c0                	test   %eax,%eax
80103489:	0f 85 01 01 00 00    	jne    80103590 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010348f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103496:	3c 01                	cmp    $0x1,%al
80103498:	74 08                	je     801034a2 <mpinit+0x92>
8010349a:	3c 04                	cmp    $0x4,%al
8010349c:	0f 85 ee 00 00 00    	jne    80103590 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801034a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801034a9:	66 85 d2             	test   %dx,%dx
801034ac:	74 22                	je     801034d0 <mpinit+0xc0>
801034ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801034b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801034b3:	31 d2                	xor    %edx,%edx
801034b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801034bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034c4:	39 c7                	cmp    %eax,%edi
801034c6:	75 f0                	jne    801034b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034c8:	84 d2                	test   %dl,%dl
801034ca:	0f 85 c0 00 00 00    	jne    80103590 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801034d6:	a3 e0 26 11 80       	mov    %eax,0x801126e0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801034f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034f7:	90                   	nop
801034f8:	39 d0                	cmp    %edx,%eax
801034fa:	73 15                	jae    80103511 <mpinit+0x101>
    switch(*p){
801034fc:	0f b6 08             	movzbl (%eax),%ecx
801034ff:	80 f9 02             	cmp    $0x2,%cl
80103502:	74 4c                	je     80103550 <mpinit+0x140>
80103504:	77 3a                	ja     80103540 <mpinit+0x130>
80103506:	84 c9                	test   %cl,%cl
80103508:	74 56                	je     80103560 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010350a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010350d:	39 d0                	cmp    %edx,%eax
8010350f:	72 eb                	jb     801034fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103511:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103514:	85 f6                	test   %esi,%esi
80103516:	0f 84 d9 00 00 00    	je     801035f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010351c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103520:	74 15                	je     80103537 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103522:	b8 70 00 00 00       	mov    $0x70,%eax
80103527:	ba 22 00 00 00       	mov    $0x22,%edx
8010352c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010352d:	ba 23 00 00 00       	mov    $0x23,%edx
80103532:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103533:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103536:	ee                   	out    %al,(%dx)
  }
}
80103537:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010353a:	5b                   	pop    %ebx
8010353b:	5e                   	pop    %esi
8010353c:	5f                   	pop    %edi
8010353d:	5d                   	pop    %ebp
8010353e:	c3                   	ret    
8010353f:	90                   	nop
    switch(*p){
80103540:	83 e9 03             	sub    $0x3,%ecx
80103543:	80 f9 01             	cmp    $0x1,%cl
80103546:	76 c2                	jbe    8010350a <mpinit+0xfa>
80103548:	31 f6                	xor    %esi,%esi
8010354a:	eb ac                	jmp    801034f8 <mpinit+0xe8>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103550:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103554:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103557:	88 0d e0 27 11 80    	mov    %cl,0x801127e0
      continue;
8010355d:	eb 99                	jmp    801034f8 <mpinit+0xe8>
8010355f:	90                   	nop
      if(ncpu < NCPU) {
80103560:	8b 0d e4 27 11 80    	mov    0x801127e4,%ecx
80103566:	83 f9 07             	cmp    $0x7,%ecx
80103569:	7f 19                	jg     80103584 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010356b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103571:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103575:	83 c1 01             	add    $0x1,%ecx
80103578:	89 0d e4 27 11 80    	mov    %ecx,0x801127e4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010357e:	88 9f 00 28 11 80    	mov    %bl,-0x7feed800(%edi)
      p += sizeof(struct mpproc);
80103584:	83 c0 14             	add    $0x14,%eax
      continue;
80103587:	e9 6c ff ff ff       	jmp    801034f8 <mpinit+0xe8>
8010358c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	68 c2 7e 10 80       	push   $0x80107ec2
80103598:	e8 e3 cd ff ff       	call   80100380 <panic>
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
{
801035a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801035a5:	eb 13                	jmp    801035ba <mpinit+0x1aa>
801035a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801035b0:	89 f3                	mov    %esi,%ebx
801035b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801035b8:	74 d6                	je     80103590 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ba:	83 ec 04             	sub    $0x4,%esp
801035bd:	8d 73 10             	lea    0x10(%ebx),%esi
801035c0:	6a 04                	push   $0x4
801035c2:	68 b8 7e 10 80       	push   $0x80107eb8
801035c7:	53                   	push   %ebx
801035c8:	e8 83 13 00 00       	call   80104950 <memcmp>
801035cd:	83 c4 10             	add    $0x10,%esp
801035d0:	85 c0                	test   %eax,%eax
801035d2:	75 dc                	jne    801035b0 <mpinit+0x1a0>
801035d4:	89 da                	mov    %ebx,%edx
801035d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035e8:	39 d6                	cmp    %edx,%esi
801035ea:	75 f4                	jne    801035e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ec:	84 c0                	test   %al,%al
801035ee:	75 c0                	jne    801035b0 <mpinit+0x1a0>
801035f0:	e9 6b fe ff ff       	jmp    80103460 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035f5:	83 ec 0c             	sub    $0xc,%esp
801035f8:	68 dc 7e 10 80       	push   $0x80107edc
801035fd:	e8 7e cd ff ff       	call   80100380 <panic>
80103602:	66 90                	xchg   %ax,%ax
80103604:	66 90                	xchg   %ax,%ax
80103606:	66 90                	xchg   %ax,%ax
80103608:	66 90                	xchg   %ax,%ax
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <picinit>:
80103610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103615:	ba 21 00 00 00       	mov    $0x21,%edx
8010361a:	ee                   	out    %al,(%dx)
8010361b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103620:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103621:	c3                   	ret    
80103622:	66 90                	xchg   %ax,%ax
80103624:	66 90                	xchg   %ax,%ax
80103626:	66 90                	xchg   %ax,%ax
80103628:	66 90                	xchg   %ax,%ax
8010362a:	66 90                	xchg   %ax,%ax
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 0c             	sub    $0xc,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010363c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010363f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103645:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010364b:	e8 f0 d7 ff ff       	call   80100e40 <filealloc>
80103650:	89 03                	mov    %eax,(%ebx)
80103652:	85 c0                	test   %eax,%eax
80103654:	0f 84 a8 00 00 00    	je     80103702 <pipealloc+0xd2>
8010365a:	e8 e1 d7 ff ff       	call   80100e40 <filealloc>
8010365f:	89 06                	mov    %eax,(%esi)
80103661:	85 c0                	test   %eax,%eax
80103663:	0f 84 87 00 00 00    	je     801036f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103669:	e8 82 f1 ff ff       	call   801027f0 <kalloc>
8010366e:	89 c7                	mov    %eax,%edi
80103670:	85 c0                	test   %eax,%eax
80103672:	0f 84 b0 00 00 00    	je     80103728 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103678:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010367f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103682:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103685:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010368c:	00 00 00 
  p->nwrite = 0;
8010368f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103696:	00 00 00 
  p->nread = 0;
80103699:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036a0:	00 00 00 
  initlock(&p->lock, "pipe");
801036a3:	68 fb 7e 10 80       	push   $0x80107efb
801036a8:	50                   	push   %eax
801036a9:	e8 c2 0f 00 00       	call   80104670 <initlock>
  (*f0)->type = FD_PIPE;
801036ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036b9:	8b 03                	mov    (%ebx),%eax
801036bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036bf:	8b 03                	mov    (%ebx),%eax
801036c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036c5:	8b 03                	mov    (%ebx),%eax
801036c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ca:	8b 06                	mov    (%esi),%eax
801036cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036d2:	8b 06                	mov    (%esi),%eax
801036d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036d8:	8b 06                	mov    (%esi),%eax
801036da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036de:	8b 06                	mov    (%esi),%eax
801036e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036e6:	31 c0                	xor    %eax,%eax
}
801036e8:	5b                   	pop    %ebx
801036e9:	5e                   	pop    %esi
801036ea:	5f                   	pop    %edi
801036eb:	5d                   	pop    %ebp
801036ec:	c3                   	ret    
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801036f0:	8b 03                	mov    (%ebx),%eax
801036f2:	85 c0                	test   %eax,%eax
801036f4:	74 1e                	je     80103714 <pipealloc+0xe4>
    fileclose(*f0);
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	50                   	push   %eax
801036fa:	e8 01 d8 ff ff       	call   80100f00 <fileclose>
801036ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103702:	8b 06                	mov    (%esi),%eax
80103704:	85 c0                	test   %eax,%eax
80103706:	74 0c                	je     80103714 <pipealloc+0xe4>
    fileclose(*f1);
80103708:	83 ec 0c             	sub    $0xc,%esp
8010370b:	50                   	push   %eax
8010370c:	e8 ef d7 ff ff       	call   80100f00 <fileclose>
80103711:	83 c4 10             	add    $0x10,%esp
}
80103714:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010371c:	5b                   	pop    %ebx
8010371d:	5e                   	pop    %esi
8010371e:	5f                   	pop    %edi
8010371f:	5d                   	pop    %ebp
80103720:	c3                   	ret    
80103721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103728:	8b 03                	mov    (%ebx),%eax
8010372a:	85 c0                	test   %eax,%eax
8010372c:	75 c8                	jne    801036f6 <pipealloc+0xc6>
8010372e:	eb d2                	jmp    80103702 <pipealloc+0xd2>

80103730 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103738:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	53                   	push   %ebx
8010373f:	e8 fc 10 00 00       	call   80104840 <acquire>
  if(writable){
80103744:	83 c4 10             	add    $0x10,%esp
80103747:	85 f6                	test   %esi,%esi
80103749:	74 65                	je     801037b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010374b:	83 ec 0c             	sub    $0xc,%esp
8010374e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103754:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010375b:	00 00 00 
    wakeup(&p->nread);
8010375e:	50                   	push   %eax
8010375f:	e8 3c 0c 00 00       	call   801043a0 <wakeup>
80103764:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103767:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010376d:	85 d2                	test   %edx,%edx
8010376f:	75 0a                	jne    8010377b <pipeclose+0x4b>
80103771:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103777:	85 c0                	test   %eax,%eax
80103779:	74 15                	je     80103790 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010377b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010377e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103781:	5b                   	pop    %ebx
80103782:	5e                   	pop    %esi
80103783:	5d                   	pop    %ebp
    release(&p->lock);
80103784:	e9 57 10 00 00       	jmp    801047e0 <release>
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	53                   	push   %ebx
80103794:	e8 47 10 00 00       	call   801047e0 <release>
    kfree((char*)p);
80103799:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010379c:	83 c4 10             	add    $0x10,%esp
}
8010379f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a2:	5b                   	pop    %ebx
801037a3:	5e                   	pop    %esi
801037a4:	5d                   	pop    %ebp
    kfree((char*)p);
801037a5:	e9 26 ed ff ff       	jmp    801024d0 <kfree>
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037c0:	00 00 00 
    wakeup(&p->nwrite);
801037c3:	50                   	push   %eax
801037c4:	e8 d7 0b 00 00       	call   801043a0 <wakeup>
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	eb 99                	jmp    80103767 <pipeclose+0x37>
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	57                   	push   %edi
801037d4:	56                   	push   %esi
801037d5:	53                   	push   %ebx
801037d6:	83 ec 28             	sub    $0x28,%esp
801037d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037dc:	53                   	push   %ebx
801037dd:	e8 5e 10 00 00       	call   80104840 <acquire>
  for(i = 0; i < n; i++){
801037e2:	8b 45 10             	mov    0x10(%ebp),%eax
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	85 c0                	test   %eax,%eax
801037ea:	0f 8e c0 00 00 00    	jle    801038b0 <pipewrite+0xe0>
801037f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103802:	03 45 10             	add    0x10(%ebp),%eax
80103805:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103808:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010380e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103814:	89 ca                	mov    %ecx,%edx
80103816:	05 00 02 00 00       	add    $0x200,%eax
8010381b:	39 c1                	cmp    %eax,%ecx
8010381d:	74 3f                	je     8010385e <pipewrite+0x8e>
8010381f:	eb 67                	jmp    80103888 <pipewrite+0xb8>
80103821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103828:	e8 43 03 00 00       	call   80103b70 <myproc>
8010382d:	8b 48 28             	mov    0x28(%eax),%ecx
80103830:	85 c9                	test   %ecx,%ecx
80103832:	75 34                	jne    80103868 <pipewrite+0x98>
      wakeup(&p->nread);
80103834:	83 ec 0c             	sub    $0xc,%esp
80103837:	57                   	push   %edi
80103838:	e8 63 0b 00 00       	call   801043a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010383d:	58                   	pop    %eax
8010383e:	5a                   	pop    %edx
8010383f:	53                   	push   %ebx
80103840:	56                   	push   %esi
80103841:	e8 9a 0a 00 00       	call   801042e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103846:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010384c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103852:	83 c4 10             	add    $0x10,%esp
80103855:	05 00 02 00 00       	add    $0x200,%eax
8010385a:	39 c2                	cmp    %eax,%edx
8010385c:	75 2a                	jne    80103888 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010385e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103864:	85 c0                	test   %eax,%eax
80103866:	75 c0                	jne    80103828 <pipewrite+0x58>
        release(&p->lock);
80103868:	83 ec 0c             	sub    $0xc,%esp
8010386b:	53                   	push   %ebx
8010386c:	e8 6f 0f 00 00       	call   801047e0 <release>
        return -1;
80103871:	83 c4 10             	add    $0x10,%esp
80103874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010387c:	5b                   	pop    %ebx
8010387d:	5e                   	pop    %esi
8010387e:	5f                   	pop    %edi
8010387f:	5d                   	pop    %ebp
80103880:	c3                   	ret    
80103881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103888:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010388b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010388e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103894:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010389a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010389d:	83 c6 01             	add    $0x1,%esi
801038a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801038aa:	0f 85 58 ff ff ff    	jne    80103808 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038b9:	50                   	push   %eax
801038ba:	e8 e1 0a 00 00       	call   801043a0 <wakeup>
  release(&p->lock);
801038bf:	89 1c 24             	mov    %ebx,(%esp)
801038c2:	e8 19 0f 00 00       	call   801047e0 <release>
  return n;
801038c7:	8b 45 10             	mov    0x10(%ebp),%eax
801038ca:	83 c4 10             	add    $0x10,%esp
801038cd:	eb aa                	jmp    80103879 <pipewrite+0xa9>
801038cf:	90                   	nop

801038d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 18             	sub    $0x18,%esp
801038d9:	8b 75 08             	mov    0x8(%ebp),%esi
801038dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038df:	56                   	push   %esi
801038e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038e6:	e8 55 0f 00 00       	call   80104840 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038f1:	83 c4 10             	add    $0x10,%esp
801038f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038fa:	74 2f                	je     8010392b <piperead+0x5b>
801038fc:	eb 37                	jmp    80103935 <piperead+0x65>
801038fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103900:	e8 6b 02 00 00       	call   80103b70 <myproc>
80103905:	8b 48 28             	mov    0x28(%eax),%ecx
80103908:	85 c9                	test   %ecx,%ecx
8010390a:	0f 85 80 00 00 00    	jne    80103990 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103910:	83 ec 08             	sub    $0x8,%esp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
80103915:	e8 c6 09 00 00       	call   801042e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010391a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103929:	75 0a                	jne    80103935 <piperead+0x65>
8010392b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103931:	85 c0                	test   %eax,%eax
80103933:	75 cb                	jne    80103900 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103935:	8b 55 10             	mov    0x10(%ebp),%edx
80103938:	31 db                	xor    %ebx,%ebx
8010393a:	85 d2                	test   %edx,%edx
8010393c:	7f 20                	jg     8010395e <piperead+0x8e>
8010393e:	eb 2c                	jmp    8010396c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103940:	8d 48 01             	lea    0x1(%eax),%ecx
80103943:	25 ff 01 00 00       	and    $0x1ff,%eax
80103948:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010394e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103953:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103956:	83 c3 01             	add    $0x1,%ebx
80103959:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010395c:	74 0e                	je     8010396c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010395e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103964:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010396a:	75 d4                	jne    80103940 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010396c:	83 ec 0c             	sub    $0xc,%esp
8010396f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103975:	50                   	push   %eax
80103976:	e8 25 0a 00 00       	call   801043a0 <wakeup>
  release(&p->lock);
8010397b:	89 34 24             	mov    %esi,(%esp)
8010397e:	e8 5d 0e 00 00       	call   801047e0 <release>
  return i;
80103983:	83 c4 10             	add    $0x10,%esp
}
80103986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103989:	89 d8                	mov    %ebx,%eax
8010398b:	5b                   	pop    %ebx
8010398c:	5e                   	pop    %esi
8010398d:	5f                   	pop    %edi
8010398e:	5d                   	pop    %ebp
8010398f:	c3                   	ret    
      release(&p->lock);
80103990:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103993:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103998:	56                   	push   %esi
80103999:	e8 42 0e 00 00       	call   801047e0 <release>
      return -1;
8010399e:	83 c4 10             	add    $0x10,%esp
}
801039a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039a4:	89 d8                	mov    %ebx,%eax
801039a6:	5b                   	pop    %ebx
801039a7:	5e                   	pop    %esi
801039a8:	5f                   	pop    %edi
801039a9:	5d                   	pop    %ebp
801039aa:	c3                   	ret    
801039ab:	66 90                	xchg   %ax,%ax
801039ad:	66 90                	xchg   %ax,%ax
801039af:	90                   	nop

801039b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039b4:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
{
801039b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039bc:	68 80 2d 11 80       	push   $0x80112d80
801039c1:	e8 7a 0e 00 00       	call   80104840 <acquire>
801039c6:	83 c4 10             	add    $0x10,%esp
801039c9:	eb 10                	jmp    801039db <allocproc+0x2b>
801039cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d0:	83 eb 80             	sub    $0xffffff80,%ebx
801039d3:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
801039d9:	74 75                	je     80103a50 <allocproc+0xa0>
    if(p->state == UNUSED)
801039db:	8b 43 10             	mov    0x10(%ebx),%eax
801039de:	85 c0                	test   %eax,%eax
801039e0:	75 ee                	jne    801039d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039e2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039ea:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039f1:	89 43 14             	mov    %eax,0x14(%ebx)
801039f4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039f7:	68 80 2d 11 80       	push   $0x80112d80
  p->pid = nextpid++;
801039fc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103a02:	e8 d9 0d 00 00       	call   801047e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a07:	e8 e4 ed ff ff       	call   801027f0 <kalloc>
80103a0c:	83 c4 10             	add    $0x10,%esp
80103a0f:	89 43 0c             	mov    %eax,0xc(%ebx)
80103a12:	85 c0                	test   %eax,%eax
80103a14:	74 53                	je     80103a69 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a16:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a1c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a1f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a24:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103a27:	c7 40 14 b0 5c 10 80 	movl   $0x80105cb0,0x14(%eax)
  p->context = (struct context*)sp;
80103a2e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a31:	6a 14                	push   $0x14
80103a33:	6a 00                	push   $0x0
80103a35:	50                   	push   %eax
80103a36:	e8 c5 0e 00 00       	call   80104900 <memset>
  p->context->eip = (uint)forkret;
80103a3b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103a3e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a41:	c7 40 10 80 3a 10 80 	movl   $0x80103a80,0x10(%eax)
}
80103a48:	89 d8                	mov    %ebx,%eax
80103a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a4d:	c9                   	leave  
80103a4e:	c3                   	ret    
80103a4f:	90                   	nop
  release(&ptable.lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a53:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a55:	68 80 2d 11 80       	push   $0x80112d80
80103a5a:	e8 81 0d 00 00       	call   801047e0 <release>
}
80103a5f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a61:	83 c4 10             	add    $0x10,%esp
}
80103a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a67:	c9                   	leave  
80103a68:	c3                   	ret    
    p->state = UNUSED;
80103a69:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103a70:	31 db                	xor    %ebx,%ebx
}
80103a72:	89 d8                	mov    %ebx,%eax
80103a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a77:	c9                   	leave  
80103a78:	c3                   	ret    
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a86:	68 80 2d 11 80       	push   $0x80112d80
80103a8b:	e8 50 0d 00 00       	call   801047e0 <release>

  if (first) {
80103a90:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	85 c0                	test   %eax,%eax
80103a9a:	75 04                	jne    80103aa0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a9c:	c9                   	leave  
80103a9d:	c3                   	ret    
80103a9e:	66 90                	xchg   %ax,%ax
    first = 0;
80103aa0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103aa7:	00 00 00 
    iinit(ROOTDEV);
80103aaa:	83 ec 0c             	sub    $0xc,%esp
80103aad:	6a 01                	push   $0x1
80103aaf:	e8 bc da ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103ab4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103abb:	e8 e0 f3 ff ff       	call   80102ea0 <initlog>
}
80103ac0:	83 c4 10             	add    $0x10,%esp
80103ac3:	c9                   	leave  
80103ac4:	c3                   	ret    
80103ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ad0 <pinit>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ad6:	68 00 7f 10 80       	push   $0x80107f00
80103adb:	68 80 2d 11 80       	push   $0x80112d80
80103ae0:	e8 8b 0b 00 00       	call   80104670 <initlock>
}
80103ae5:	83 c4 10             	add    $0x10,%esp
80103ae8:	c9                   	leave  
80103ae9:	c3                   	ret    
80103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103af0 <mycpu>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103af5:	9c                   	pushf  
80103af6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103af7:	f6 c4 02             	test   $0x2,%ah
80103afa:	75 46                	jne    80103b42 <mycpu+0x52>
  apicid = lapicid();
80103afc:	e8 cf ef ff ff       	call   80102ad0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b01:	8b 35 e4 27 11 80    	mov    0x801127e4,%esi
80103b07:	85 f6                	test   %esi,%esi
80103b09:	7e 2a                	jle    80103b35 <mycpu+0x45>
80103b0b:	31 d2                	xor    %edx,%edx
80103b0d:	eb 08                	jmp    80103b17 <mycpu+0x27>
80103b0f:	90                   	nop
80103b10:	83 c2 01             	add    $0x1,%edx
80103b13:	39 f2                	cmp    %esi,%edx
80103b15:	74 1e                	je     80103b35 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103b17:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b1d:	0f b6 99 00 28 11 80 	movzbl -0x7feed800(%ecx),%ebx
80103b24:	39 c3                	cmp    %eax,%ebx
80103b26:	75 e8                	jne    80103b10 <mycpu+0x20>
}
80103b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b2b:	8d 81 00 28 11 80    	lea    -0x7feed800(%ecx),%eax
}
80103b31:	5b                   	pop    %ebx
80103b32:	5e                   	pop    %esi
80103b33:	5d                   	pop    %ebp
80103b34:	c3                   	ret    
  panic("unknown apicid\n");
80103b35:	83 ec 0c             	sub    $0xc,%esp
80103b38:	68 07 7f 10 80       	push   $0x80107f07
80103b3d:	e8 3e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b42:	83 ec 0c             	sub    $0xc,%esp
80103b45:	68 e4 7f 10 80       	push   $0x80107fe4
80103b4a:	e8 31 c8 ff ff       	call   80100380 <panic>
80103b4f:	90                   	nop

80103b50 <cpuid>:
cpuid() {
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b56:	e8 95 ff ff ff       	call   80103af0 <mycpu>
}
80103b5b:	c9                   	leave  
  return mycpu()-cpus;
80103b5c:	2d 00 28 11 80       	sub    $0x80112800,%eax
80103b61:	c1 f8 04             	sar    $0x4,%eax
80103b64:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b6a:	c3                   	ret    
80103b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop

80103b70 <myproc>:
myproc(void) {
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	53                   	push   %ebx
80103b74:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b77:	e8 74 0b 00 00       	call   801046f0 <pushcli>
  c = mycpu();
80103b7c:	e8 6f ff ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103b81:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b87:	e8 b4 0b 00 00       	call   80104740 <popcli>
}
80103b8c:	89 d8                	mov    %ebx,%eax
80103b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b91:	c9                   	leave  
80103b92:	c3                   	ret    
80103b93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <userinit>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	53                   	push   %ebx
80103ba4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ba7:	e8 04 fe ff ff       	call   801039b0 <allocproc>
80103bac:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bae:	a3 b4 4d 11 80       	mov    %eax,0x80114db4
  if((p->pgdir = setupkvm()) == 0)
80103bb3:	e8 f8 39 00 00       	call   801075b0 <setupkvm>
80103bb8:	89 43 08             	mov    %eax,0x8(%ebx)
80103bbb:	85 c0                	test   %eax,%eax
80103bbd:	0f 84 bd 00 00 00    	je     80103c80 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bc3:	83 ec 04             	sub    $0x4,%esp
80103bc6:	68 2c 00 00 00       	push   $0x2c
80103bcb:	68 70 b4 10 80       	push   $0x8010b470
80103bd0:	50                   	push   %eax
80103bd1:	e8 9a 34 00 00       	call   80107070 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bd6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bd9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bdf:	6a 4c                	push   $0x4c
80103be1:	6a 00                	push   $0x0
80103be3:	ff 73 1c             	push   0x1c(%ebx)
80103be6:	e8 15 0d 00 00       	call   80104900 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103beb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bf3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bf6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bfb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bff:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c06:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c11:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c1c:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c26:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c30:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c3a:	8d 43 70             	lea    0x70(%ebx),%eax
80103c3d:	6a 10                	push   $0x10
80103c3f:	68 30 7f 10 80       	push   $0x80107f30
80103c44:	50                   	push   %eax
80103c45:	e8 76 0e 00 00       	call   80104ac0 <safestrcpy>
  p->cwd = namei("/");
80103c4a:	c7 04 24 39 7f 10 80 	movl   $0x80107f39,(%esp)
80103c51:	e8 5a e4 ff ff       	call   801020b0 <namei>
80103c56:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c59:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103c60:	e8 db 0b 00 00       	call   80104840 <acquire>
  p->state = RUNNABLE;
80103c65:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c6c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103c73:	e8 68 0b 00 00       	call   801047e0 <release>
}
80103c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c7b:	83 c4 10             	add    $0x10,%esp
80103c7e:	c9                   	leave  
80103c7f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	68 17 7f 10 80       	push   $0x80107f17
80103c88:	e8 f3 c6 ff ff       	call   80100380 <panic>
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi

80103c90 <growproc>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	56                   	push   %esi
80103c94:	53                   	push   %ebx
80103c95:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c98:	e8 53 0a 00 00       	call   801046f0 <pushcli>
  c = mycpu();
80103c9d:	e8 4e fe ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103ca2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ca8:	e8 93 0a 00 00       	call   80104740 <popcli>
  sz = curproc->sz;
80103cad:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103caf:	85 f6                	test   %esi,%esi
80103cb1:	7f 1d                	jg     80103cd0 <growproc+0x40>
  } else if(n < 0){
80103cb3:	75 3b                	jne    80103cf0 <growproc+0x60>
  switchuvm(curproc);
80103cb5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cb8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cba:	53                   	push   %ebx
80103cbb:	e8 a0 32 00 00       	call   80106f60 <switchuvm>
  return 0;
80103cc0:	83 c4 10             	add    $0x10,%esp
80103cc3:	31 c0                	xor    %eax,%eax
}
80103cc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cc8:	5b                   	pop    %ebx
80103cc9:	5e                   	pop    %esi
80103cca:	5d                   	pop    %ebp
80103ccb:	c3                   	ret    
80103ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cd0:	83 ec 04             	sub    $0x4,%esp
80103cd3:	01 c6                	add    %eax,%esi
80103cd5:	56                   	push   %esi
80103cd6:	50                   	push   %eax
80103cd7:	ff 73 08             	push   0x8(%ebx)
80103cda:	e8 31 35 00 00       	call   80107210 <allocuvm>
80103cdf:	83 c4 10             	add    $0x10,%esp
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	75 cf                	jne    80103cb5 <growproc+0x25>
      return -1;
80103ce6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ceb:	eb d8                	jmp    80103cc5 <growproc+0x35>
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cf0:	83 ec 04             	sub    $0x4,%esp
80103cf3:	01 c6                	add    %eax,%esi
80103cf5:	56                   	push   %esi
80103cf6:	50                   	push   %eax
80103cf7:	ff 73 08             	push   0x8(%ebx)
80103cfa:	e8 41 37 00 00       	call   80107440 <deallocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	85 c0                	test   %eax,%eax
80103d04:	75 af                	jne    80103cb5 <growproc+0x25>
80103d06:	eb de                	jmp    80103ce6 <growproc+0x56>
80103d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0f:	90                   	nop

80103d10 <growhugeproc>:
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	56                   	push   %esi
80103d14:	53                   	push   %ebx
80103d15:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d18:	e8 d3 09 00 00       	call   801046f0 <pushcli>
  c = mycpu();
80103d1d:	e8 ce fd ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103d22:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d28:	e8 13 0a 00 00       	call   80104740 <popcli>
  sz = curproc->hugesz;
80103d2d:	8b 43 04             	mov    0x4(%ebx),%eax
  if(n > 0){
80103d30:	85 f6                	test   %esi,%esi
80103d32:	7f 24                	jg     80103d58 <growhugeproc+0x48>
  } else if(n < 0){
80103d34:	75 4a                	jne    80103d80 <growhugeproc+0x70>
  curproc->hugesz = sz - HUGE_VA_OFFSET;
80103d36:	2d 00 00 00 1e       	sub    $0x1e000000,%eax
  switchuvm(curproc);
80103d3b:	83 ec 0c             	sub    $0xc,%esp
  curproc->hugesz = sz - HUGE_VA_OFFSET;
80103d3e:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103d41:	53                   	push   %ebx
80103d42:	e8 19 32 00 00       	call   80106f60 <switchuvm>
  return 0;
80103d47:	83 c4 10             	add    $0x10,%esp
80103d4a:	31 c0                	xor    %eax,%eax
}
80103d4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d4f:	5b                   	pop    %ebx
80103d50:	5e                   	pop    %esi
80103d51:	5d                   	pop    %ebp
80103d52:	c3                   	ret    
80103d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d57:	90                   	nop
    if((sz = allochugeuvm(curproc->pgdir, sz + HUGE_VA_OFFSET, sz + n + HUGE_VA_OFFSET)) == 0)
80103d58:	83 ec 04             	sub    $0x4,%esp
80103d5b:	8d 94 30 00 00 00 1e 	lea    0x1e000000(%eax,%esi,1),%edx
80103d62:	05 00 00 00 1e       	add    $0x1e000000,%eax
80103d67:	52                   	push   %edx
80103d68:	50                   	push   %eax
80103d69:	ff 73 08             	push   0x8(%ebx)
80103d6c:	e8 cf 35 00 00       	call   80107340 <allochugeuvm>
80103d71:	83 c4 10             	add    $0x10,%esp
80103d74:	85 c0                	test   %eax,%eax
80103d76:	75 be                	jne    80103d36 <growhugeproc+0x26>
      return -1;
80103d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d7d:	eb cd                	jmp    80103d4c <growhugeproc+0x3c>
80103d7f:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d80:	83 ec 04             	sub    $0x4,%esp
80103d83:	01 c6                	add    %eax,%esi
80103d85:	56                   	push   %esi
80103d86:	50                   	push   %eax
80103d87:	ff 73 08             	push   0x8(%ebx)
80103d8a:	e8 b1 36 00 00       	call   80107440 <deallocuvm>
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	85 c0                	test   %eax,%eax
80103d94:	75 a0                	jne    80103d36 <growhugeproc+0x26>
80103d96:	eb e0                	jmp    80103d78 <growhugeproc+0x68>
80103d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d9f:	90                   	nop

80103da0 <fork>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103da9:	e8 42 09 00 00       	call   801046f0 <pushcli>
  c = mycpu();
80103dae:	e8 3d fd ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103db3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db9:	e8 82 09 00 00       	call   80104740 <popcli>
  if((np = allocproc()) == 0){
80103dbe:	e8 ed fb ff ff       	call   801039b0 <allocproc>
80103dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103dc6:	85 c0                	test   %eax,%eax
80103dc8:	0f 84 c7 00 00 00    	je     80103e95 <fork+0xf5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->hugesz)) == 0){
80103dce:	83 ec 04             	sub    $0x4,%esp
80103dd1:	ff 73 04             	push   0x4(%ebx)
80103dd4:	89 c7                	mov    %eax,%edi
80103dd6:	ff 33                	push   (%ebx)
80103dd8:	ff 73 08             	push   0x8(%ebx)
80103ddb:	e8 c0 38 00 00       	call   801076a0 <copyuvm>
80103de0:	83 c4 10             	add    $0x10,%esp
80103de3:	89 47 08             	mov    %eax,0x8(%edi)
80103de6:	85 c0                	test   %eax,%eax
80103de8:	0f 84 ae 00 00 00    	je     80103e9c <fork+0xfc>
  np->sz = curproc->sz;
80103dee:	8b 03                	mov    (%ebx),%eax
80103df0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103df3:	89 01                	mov    %eax,(%ecx)
  np->hugesz = curproc->hugesz;
80103df5:	8b 43 04             	mov    0x4(%ebx),%eax
  *np->tf = *curproc->tf;
80103df8:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103dfb:	89 59 18             	mov    %ebx,0x18(%ecx)
  np->hugesz = curproc->hugesz;
80103dfe:	89 41 04             	mov    %eax,0x4(%ecx)
  np->parent = curproc;
80103e01:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103e03:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103e06:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e0d:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e0f:	8b 40 1c             	mov    0x1c(%eax),%eax
80103e12:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103e20:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103e24:	85 c0                	test   %eax,%eax
80103e26:	74 13                	je     80103e3b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e28:	83 ec 0c             	sub    $0xc,%esp
80103e2b:	50                   	push   %eax
80103e2c:	e8 7f d0 ff ff       	call   80100eb0 <filedup>
80103e31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e34:	83 c4 10             	add    $0x10,%esp
80103e37:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e3b:	83 c6 01             	add    $0x1,%esi
80103e3e:	83 fe 10             	cmp    $0x10,%esi
80103e41:	75 dd                	jne    80103e20 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103e43:	83 ec 0c             	sub    $0xc,%esp
80103e46:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e49:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103e4c:	e8 0f d9 ff ff       	call   80101760 <idup>
80103e51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e54:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e57:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e5a:	8d 47 70             	lea    0x70(%edi),%eax
80103e5d:	6a 10                	push   $0x10
80103e5f:	53                   	push   %ebx
80103e60:	50                   	push   %eax
80103e61:	e8 5a 0c 00 00       	call   80104ac0 <safestrcpy>
  pid = np->pid;
80103e66:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103e69:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e70:	e8 cb 09 00 00       	call   80104840 <acquire>
  np->state = RUNNABLE;
80103e75:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103e7c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e83:	e8 58 09 00 00       	call   801047e0 <release>
  return pid;
80103e88:	83 c4 10             	add    $0x10,%esp
}
80103e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e8e:	89 d8                	mov    %ebx,%eax
80103e90:	5b                   	pop    %ebx
80103e91:	5e                   	pop    %esi
80103e92:	5f                   	pop    %edi
80103e93:	5d                   	pop    %ebp
80103e94:	c3                   	ret    
    return -1;
80103e95:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e9a:	eb ef                	jmp    80103e8b <fork+0xeb>
    kfree(np->kstack);
80103e9c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103e9f:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103ea2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103ea7:	ff 77 0c             	push   0xc(%edi)
80103eaa:	e8 21 e6 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103eaf:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103eb6:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103eb9:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    return -1;
80103ec0:	eb c9                	jmp    80103e8b <fork+0xeb>
80103ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <scheduler>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	57                   	push   %edi
80103ed4:	56                   	push   %esi
80103ed5:	53                   	push   %ebx
80103ed6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ed9:	e8 12 fc ff ff       	call   80103af0 <mycpu>
  c->proc = 0;
80103ede:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ee5:	00 00 00 
  struct cpu *c = mycpu();
80103ee8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103eea:	8d 78 04             	lea    0x4(%eax),%edi
80103eed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ef0:	fb                   	sti    
    acquire(&ptable.lock);
80103ef1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef4:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
    acquire(&ptable.lock);
80103ef9:	68 80 2d 11 80       	push   $0x80112d80
80103efe:	e8 3d 09 00 00       	call   80104840 <acquire>
80103f03:	83 c4 10             	add    $0x10,%esp
80103f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f10:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103f14:	75 33                	jne    80103f49 <scheduler+0x79>
      switchuvm(p);
80103f16:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f19:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f1f:	53                   	push   %ebx
80103f20:	e8 3b 30 00 00       	call   80106f60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f25:	58                   	pop    %eax
80103f26:	5a                   	pop    %edx
80103f27:	ff 73 20             	push   0x20(%ebx)
80103f2a:	57                   	push   %edi
      p->state = RUNNING;
80103f2b:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103f32:	e8 e4 0b 00 00       	call   80104b1b <swtch>
      switchkvm();
80103f37:	e8 14 30 00 00       	call   80106f50 <switchkvm>
      c->proc = 0;
80103f3c:	83 c4 10             	add    $0x10,%esp
80103f3f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f46:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f49:	83 eb 80             	sub    $0xffffff80,%ebx
80103f4c:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80103f52:	75 bc                	jne    80103f10 <scheduler+0x40>
    release(&ptable.lock);
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 80 2d 11 80       	push   $0x80112d80
80103f5c:	e8 7f 08 00 00       	call   801047e0 <release>
    sti();
80103f61:	83 c4 10             	add    $0x10,%esp
80103f64:	eb 8a                	jmp    80103ef0 <scheduler+0x20>
80103f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi

80103f70 <sched>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
  pushcli();
80103f75:	e8 76 07 00 00       	call   801046f0 <pushcli>
  c = mycpu();
80103f7a:	e8 71 fb ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103f7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f85:	e8 b6 07 00 00       	call   80104740 <popcli>
  if(!holding(&ptable.lock))
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 80 2d 11 80       	push   $0x80112d80
80103f92:	e8 09 08 00 00       	call   801047a0 <holding>
80103f97:	83 c4 10             	add    $0x10,%esp
80103f9a:	85 c0                	test   %eax,%eax
80103f9c:	74 4f                	je     80103fed <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f9e:	e8 4d fb ff ff       	call   80103af0 <mycpu>
80103fa3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103faa:	75 68                	jne    80104014 <sched+0xa4>
  if(p->state == RUNNING)
80103fac:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103fb0:	74 55                	je     80104007 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fb2:	9c                   	pushf  
80103fb3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fb4:	f6 c4 02             	test   $0x2,%ah
80103fb7:	75 41                	jne    80103ffa <sched+0x8a>
  intena = mycpu()->intena;
80103fb9:	e8 32 fb ff ff       	call   80103af0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fbe:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103fc1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fc7:	e8 24 fb ff ff       	call   80103af0 <mycpu>
80103fcc:	83 ec 08             	sub    $0x8,%esp
80103fcf:	ff 70 04             	push   0x4(%eax)
80103fd2:	53                   	push   %ebx
80103fd3:	e8 43 0b 00 00       	call   80104b1b <swtch>
  mycpu()->intena = intena;
80103fd8:	e8 13 fb ff ff       	call   80103af0 <mycpu>
}
80103fdd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fe0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fe6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fe9:	5b                   	pop    %ebx
80103fea:	5e                   	pop    %esi
80103feb:	5d                   	pop    %ebp
80103fec:	c3                   	ret    
    panic("sched ptable.lock");
80103fed:	83 ec 0c             	sub    $0xc,%esp
80103ff0:	68 3b 7f 10 80       	push   $0x80107f3b
80103ff5:	e8 86 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 67 7f 10 80       	push   $0x80107f67
80104002:	e8 79 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104007:	83 ec 0c             	sub    $0xc,%esp
8010400a:	68 59 7f 10 80       	push   $0x80107f59
8010400f:	e8 6c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104014:	83 ec 0c             	sub    $0xc,%esp
80104017:	68 4d 7f 10 80       	push   $0x80107f4d
8010401c:	e8 5f c3 ff ff       	call   80100380 <panic>
80104021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010402f:	90                   	nop

80104030 <exit>:
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	57                   	push   %edi
80104034:	56                   	push   %esi
80104035:	53                   	push   %ebx
80104036:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104039:	e8 32 fb ff ff       	call   80103b70 <myproc>
  if(curproc == initproc)
8010403e:	39 05 b4 4d 11 80    	cmp    %eax,0x80114db4
80104044:	0f 84 fd 00 00 00    	je     80104147 <exit+0x117>
8010404a:	89 c3                	mov    %eax,%ebx
8010404c:	8d 70 2c             	lea    0x2c(%eax),%esi
8010404f:	8d 78 6c             	lea    0x6c(%eax),%edi
80104052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104058:	8b 06                	mov    (%esi),%eax
8010405a:	85 c0                	test   %eax,%eax
8010405c:	74 12                	je     80104070 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010405e:	83 ec 0c             	sub    $0xc,%esp
80104061:	50                   	push   %eax
80104062:	e8 99 ce ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80104067:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010406d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104070:	83 c6 04             	add    $0x4,%esi
80104073:	39 f7                	cmp    %esi,%edi
80104075:	75 e1                	jne    80104058 <exit+0x28>
  begin_op();
80104077:	e8 c4 ee ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
8010407c:	83 ec 0c             	sub    $0xc,%esp
8010407f:	ff 73 6c             	push   0x6c(%ebx)
80104082:	e8 39 d8 ff ff       	call   801018c0 <iput>
  end_op();
80104087:	e8 24 ef ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
8010408c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104093:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010409a:	e8 a1 07 00 00       	call   80104840 <acquire>
  wakeup1(curproc->parent);
8010409f:	8b 53 18             	mov    0x18(%ebx),%edx
801040a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a5:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801040aa:	eb 0e                	jmp    801040ba <exit+0x8a>
801040ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040b0:	83 e8 80             	sub    $0xffffff80,%eax
801040b3:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801040b8:	74 1c                	je     801040d6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801040ba:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040be:	75 f0                	jne    801040b0 <exit+0x80>
801040c0:	3b 50 24             	cmp    0x24(%eax),%edx
801040c3:	75 eb                	jne    801040b0 <exit+0x80>
      p->state = RUNNABLE;
801040c5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040cc:	83 e8 80             	sub    $0xffffff80,%eax
801040cf:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801040d4:	75 e4                	jne    801040ba <exit+0x8a>
      p->parent = initproc;
801040d6:	8b 0d b4 4d 11 80    	mov    0x80114db4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040dc:	ba b4 2d 11 80       	mov    $0x80112db4,%edx
801040e1:	eb 10                	jmp    801040f3 <exit+0xc3>
801040e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e7:	90                   	nop
801040e8:	83 ea 80             	sub    $0xffffff80,%edx
801040eb:	81 fa b4 4d 11 80    	cmp    $0x80114db4,%edx
801040f1:	74 3b                	je     8010412e <exit+0xfe>
    if(p->parent == curproc){
801040f3:	39 5a 18             	cmp    %ebx,0x18(%edx)
801040f6:	75 f0                	jne    801040e8 <exit+0xb8>
      if(p->state == ZOMBIE)
801040f8:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
801040fc:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
801040ff:	75 e7                	jne    801040e8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104101:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80104106:	eb 12                	jmp    8010411a <exit+0xea>
80104108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010410f:	90                   	nop
80104110:	83 e8 80             	sub    $0xffffff80,%eax
80104113:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104118:	74 ce                	je     801040e8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010411a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010411e:	75 f0                	jne    80104110 <exit+0xe0>
80104120:	3b 48 24             	cmp    0x24(%eax),%ecx
80104123:	75 eb                	jne    80104110 <exit+0xe0>
      p->state = RUNNABLE;
80104125:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010412c:	eb e2                	jmp    80104110 <exit+0xe0>
  curproc->state = ZOMBIE;
8010412e:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80104135:	e8 36 fe ff ff       	call   80103f70 <sched>
  panic("zombie exit");
8010413a:	83 ec 0c             	sub    $0xc,%esp
8010413d:	68 88 7f 10 80       	push   $0x80107f88
80104142:	e8 39 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104147:	83 ec 0c             	sub    $0xc,%esp
8010414a:	68 7b 7f 10 80       	push   $0x80107f7b
8010414f:	e8 2c c2 ff ff       	call   80100380 <panic>
80104154:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010415f:	90                   	nop

80104160 <wait>:
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	56                   	push   %esi
80104164:	53                   	push   %ebx
  pushcli();
80104165:	e8 86 05 00 00       	call   801046f0 <pushcli>
  c = mycpu();
8010416a:	e8 81 f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
8010416f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104175:	e8 c6 05 00 00       	call   80104740 <popcli>
  acquire(&ptable.lock);
8010417a:	83 ec 0c             	sub    $0xc,%esp
8010417d:	68 80 2d 11 80       	push   $0x80112d80
80104182:	e8 b9 06 00 00       	call   80104840 <acquire>
80104187:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010418a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010418c:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
80104191:	eb 10                	jmp    801041a3 <wait+0x43>
80104193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104197:	90                   	nop
80104198:	83 eb 80             	sub    $0xffffff80,%ebx
8010419b:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
801041a1:	74 1b                	je     801041be <wait+0x5e>
      if(p->parent != curproc)
801041a3:	39 73 18             	cmp    %esi,0x18(%ebx)
801041a6:	75 f0                	jne    80104198 <wait+0x38>
      if(p->state == ZOMBIE){
801041a8:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801041ac:	74 62                	je     80104210 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ae:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
801041b1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b6:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
801041bc:	75 e5                	jne    801041a3 <wait+0x43>
    if(!havekids || curproc->killed){
801041be:	85 c0                	test   %eax,%eax
801041c0:	0f 84 a0 00 00 00    	je     80104266 <wait+0x106>
801041c6:	8b 46 28             	mov    0x28(%esi),%eax
801041c9:	85 c0                	test   %eax,%eax
801041cb:	0f 85 95 00 00 00    	jne    80104266 <wait+0x106>
  pushcli();
801041d1:	e8 1a 05 00 00       	call   801046f0 <pushcli>
  c = mycpu();
801041d6:	e8 15 f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
801041db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041e1:	e8 5a 05 00 00       	call   80104740 <popcli>
  if(p == 0)
801041e6:	85 db                	test   %ebx,%ebx
801041e8:	0f 84 8f 00 00 00    	je     8010427d <wait+0x11d>
  p->chan = chan;
801041ee:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
801041f1:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801041f8:	e8 73 fd ff ff       	call   80103f70 <sched>
  p->chan = 0;
801041fd:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80104204:	eb 84                	jmp    8010418a <wait+0x2a>
80104206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104210:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104213:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104216:	ff 73 0c             	push   0xc(%ebx)
80104219:	e8 b2 e2 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
8010421e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80104225:	5a                   	pop    %edx
80104226:	ff 73 08             	push   0x8(%ebx)
80104229:	e8 02 33 00 00       	call   80107530 <freevm>
        p->pid = 0;
8010422e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104235:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010423c:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104240:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104247:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010424e:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80104255:	e8 86 05 00 00       	call   801047e0 <release>
        return pid;
8010425a:	83 c4 10             	add    $0x10,%esp
}
8010425d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104260:	89 f0                	mov    %esi,%eax
80104262:	5b                   	pop    %ebx
80104263:	5e                   	pop    %esi
80104264:	5d                   	pop    %ebp
80104265:	c3                   	ret    
      release(&ptable.lock);
80104266:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104269:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010426e:	68 80 2d 11 80       	push   $0x80112d80
80104273:	e8 68 05 00 00       	call   801047e0 <release>
      return -1;
80104278:	83 c4 10             	add    $0x10,%esp
8010427b:	eb e0                	jmp    8010425d <wait+0xfd>
    panic("sleep");
8010427d:	83 ec 0c             	sub    $0xc,%esp
80104280:	68 94 7f 10 80       	push   $0x80107f94
80104285:	e8 f6 c0 ff ff       	call   80100380 <panic>
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104290 <yield>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104297:	68 80 2d 11 80       	push   $0x80112d80
8010429c:	e8 9f 05 00 00       	call   80104840 <acquire>
  pushcli();
801042a1:	e8 4a 04 00 00       	call   801046f0 <pushcli>
  c = mycpu();
801042a6:	e8 45 f8 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
801042ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042b1:	e8 8a 04 00 00       	call   80104740 <popcli>
  myproc()->state = RUNNABLE;
801042b6:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
801042bd:	e8 ae fc ff ff       	call   80103f70 <sched>
  release(&ptable.lock);
801042c2:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801042c9:	e8 12 05 00 00       	call   801047e0 <release>
}
801042ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d1:	83 c4 10             	add    $0x10,%esp
801042d4:	c9                   	leave  
801042d5:	c3                   	ret    
801042d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042dd:	8d 76 00             	lea    0x0(%esi),%esi

801042e0 <sleep>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	56                   	push   %esi
801042e5:	53                   	push   %ebx
801042e6:	83 ec 0c             	sub    $0xc,%esp
801042e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042ef:	e8 fc 03 00 00       	call   801046f0 <pushcli>
  c = mycpu();
801042f4:	e8 f7 f7 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
801042f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042ff:	e8 3c 04 00 00       	call   80104740 <popcli>
  if(p == 0)
80104304:	85 db                	test   %ebx,%ebx
80104306:	0f 84 87 00 00 00    	je     80104393 <sleep+0xb3>
  if(lk == 0)
8010430c:	85 f6                	test   %esi,%esi
8010430e:	74 76                	je     80104386 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104310:	81 fe 80 2d 11 80    	cmp    $0x80112d80,%esi
80104316:	74 50                	je     80104368 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	68 80 2d 11 80       	push   $0x80112d80
80104320:	e8 1b 05 00 00       	call   80104840 <acquire>
    release(lk);
80104325:	89 34 24             	mov    %esi,(%esp)
80104328:	e8 b3 04 00 00       	call   801047e0 <release>
  p->chan = chan;
8010432d:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80104330:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104337:	e8 34 fc ff ff       	call   80103f70 <sched>
  p->chan = 0;
8010433c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104343:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010434a:	e8 91 04 00 00       	call   801047e0 <release>
    acquire(lk);
8010434f:	89 75 08             	mov    %esi,0x8(%ebp)
80104352:	83 c4 10             	add    $0x10,%esp
}
80104355:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104358:	5b                   	pop    %ebx
80104359:	5e                   	pop    %esi
8010435a:	5f                   	pop    %edi
8010435b:	5d                   	pop    %ebp
    acquire(lk);
8010435c:	e9 df 04 00 00       	jmp    80104840 <acquire>
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104368:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010436b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104372:	e8 f9 fb ff ff       	call   80103f70 <sched>
  p->chan = 0;
80104377:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010437e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104381:	5b                   	pop    %ebx
80104382:	5e                   	pop    %esi
80104383:	5f                   	pop    %edi
80104384:	5d                   	pop    %ebp
80104385:	c3                   	ret    
    panic("sleep without lk");
80104386:	83 ec 0c             	sub    $0xc,%esp
80104389:	68 9a 7f 10 80       	push   $0x80107f9a
8010438e:	e8 ed bf ff ff       	call   80100380 <panic>
    panic("sleep");
80104393:	83 ec 0c             	sub    $0xc,%esp
80104396:	68 94 7f 10 80       	push   $0x80107f94
8010439b:	e8 e0 bf ff ff       	call   80100380 <panic>

801043a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
801043a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043aa:	68 80 2d 11 80       	push   $0x80112d80
801043af:	e8 8c 04 00 00       	call   80104840 <acquire>
801043b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043b7:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801043bc:	eb 0c                	jmp    801043ca <wakeup+0x2a>
801043be:	66 90                	xchg   %ax,%ax
801043c0:	83 e8 80             	sub    $0xffffff80,%eax
801043c3:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801043c8:	74 1c                	je     801043e6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801043ca:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801043ce:	75 f0                	jne    801043c0 <wakeup+0x20>
801043d0:	3b 58 24             	cmp    0x24(%eax),%ebx
801043d3:	75 eb                	jne    801043c0 <wakeup+0x20>
      p->state = RUNNABLE;
801043d5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043dc:	83 e8 80             	sub    $0xffffff80,%eax
801043df:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801043e4:	75 e4                	jne    801043ca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801043e6:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
801043ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f0:	c9                   	leave  
  release(&ptable.lock);
801043f1:	e9 ea 03 00 00       	jmp    801047e0 <release>
801043f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fd:	8d 76 00             	lea    0x0(%esi),%esi

80104400 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 10             	sub    $0x10,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010440a:	68 80 2d 11 80       	push   $0x80112d80
8010440f:	e8 2c 04 00 00       	call   80104840 <acquire>
80104414:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104417:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010441c:	eb 0c                	jmp    8010442a <kill+0x2a>
8010441e:	66 90                	xchg   %ax,%ax
80104420:	83 e8 80             	sub    $0xffffff80,%eax
80104423:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104428:	74 36                	je     80104460 <kill+0x60>
    if(p->pid == pid){
8010442a:	39 58 14             	cmp    %ebx,0x14(%eax)
8010442d:	75 f1                	jne    80104420 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010442f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
80104433:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
8010443a:	75 07                	jne    80104443 <kill+0x43>
        p->state = RUNNABLE;
8010443c:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104443:	83 ec 0c             	sub    $0xc,%esp
80104446:	68 80 2d 11 80       	push   $0x80112d80
8010444b:	e8 90 03 00 00       	call   801047e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104450:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104453:	83 c4 10             	add    $0x10,%esp
80104456:	31 c0                	xor    %eax,%eax
}
80104458:	c9                   	leave  
80104459:	c3                   	ret    
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104460:	83 ec 0c             	sub    $0xc,%esp
80104463:	68 80 2d 11 80       	push   $0x80112d80
80104468:	e8 73 03 00 00       	call   801047e0 <release>
}
8010446d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104470:	83 c4 10             	add    $0x10,%esp
80104473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104478:	c9                   	leave  
80104479:	c3                   	ret    
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	57                   	push   %edi
80104484:	56                   	push   %esi
80104485:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104488:	53                   	push   %ebx
80104489:	bb 24 2e 11 80       	mov    $0x80112e24,%ebx
8010448e:	83 ec 3c             	sub    $0x3c,%esp
80104491:	eb 24                	jmp    801044b7 <procdump+0x37>
80104493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104497:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	68 43 83 10 80       	push   $0x80108343
801044a0:	e8 fb c1 ff ff       	call   801006a0 <cprintf>
801044a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a8:	83 eb 80             	sub    $0xffffff80,%ebx
801044ab:	81 fb 24 4e 11 80    	cmp    $0x80114e24,%ebx
801044b1:	0f 84 81 00 00 00    	je     80104538 <procdump+0xb8>
    if(p->state == UNUSED)
801044b7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044ba:	85 c0                	test   %eax,%eax
801044bc:	74 ea                	je     801044a8 <procdump+0x28>
      state = "???";
801044be:	ba ab 7f 10 80       	mov    $0x80107fab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044c3:	83 f8 05             	cmp    $0x5,%eax
801044c6:	77 11                	ja     801044d9 <procdump+0x59>
801044c8:	8b 14 85 0c 80 10 80 	mov    -0x7fef7ff4(,%eax,4),%edx
      state = "???";
801044cf:	b8 ab 7f 10 80       	mov    $0x80107fab,%eax
801044d4:	85 d2                	test   %edx,%edx
801044d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044d9:	53                   	push   %ebx
801044da:	52                   	push   %edx
801044db:	ff 73 a4             	push   -0x5c(%ebx)
801044de:	68 af 7f 10 80       	push   $0x80107faf
801044e3:	e8 b8 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801044e8:	83 c4 10             	add    $0x10,%esp
801044eb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044ef:	75 a7                	jne    80104498 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044f1:	83 ec 08             	sub    $0x8,%esp
801044f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044f7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044fa:	50                   	push   %eax
801044fb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104501:	83 c0 08             	add    $0x8,%eax
80104504:	50                   	push   %eax
80104505:	e8 86 01 00 00       	call   80104690 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010450a:	83 c4 10             	add    $0x10,%esp
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
80104510:	8b 17                	mov    (%edi),%edx
80104512:	85 d2                	test   %edx,%edx
80104514:	74 82                	je     80104498 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104516:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104519:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010451c:	52                   	push   %edx
8010451d:	68 e1 79 10 80       	push   $0x801079e1
80104522:	e8 79 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104527:	83 c4 10             	add    $0x10,%esp
8010452a:	39 fe                	cmp    %edi,%esi
8010452c:	75 e2                	jne    80104510 <procdump+0x90>
8010452e:	e9 65 ff ff ff       	jmp    80104498 <procdump+0x18>
80104533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104537:	90                   	nop
  }
}
80104538:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010453b:	5b                   	pop    %ebx
8010453c:	5e                   	pop    %esi
8010453d:	5f                   	pop    %edi
8010453e:	5d                   	pop    %ebp
8010453f:	c3                   	ret    

80104540 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 0c             	sub    $0xc,%esp
80104547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010454a:	68 24 80 10 80       	push   $0x80108024
8010454f:	8d 43 04             	lea    0x4(%ebx),%eax
80104552:	50                   	push   %eax
80104553:	e8 18 01 00 00       	call   80104670 <initlock>
  lk->name = name;
80104558:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010455b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104561:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104564:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010456b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010456e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104571:	c9                   	leave  
80104572:	c3                   	ret    
80104573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
8010458f:	e8 ac 02 00 00       	call   80104840 <acquire>
  while (lk->locked) {
80104594:	8b 13                	mov    (%ebx),%edx
80104596:	83 c4 10             	add    $0x10,%esp
80104599:	85 d2                	test   %edx,%edx
8010459b:	74 16                	je     801045b3 <acquiresleep+0x33>
8010459d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045a0:	83 ec 08             	sub    $0x8,%esp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	e8 36 fd ff ff       	call   801042e0 <sleep>
  while (lk->locked) {
801045aa:	8b 03                	mov    (%ebx),%eax
801045ac:	83 c4 10             	add    $0x10,%esp
801045af:	85 c0                	test   %eax,%eax
801045b1:	75 ed                	jne    801045a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045b9:	e8 b2 f5 ff ff       	call   80103b70 <myproc>
801045be:	8b 40 14             	mov    0x14(%eax),%eax
801045c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045ca:	5b                   	pop    %ebx
801045cb:	5e                   	pop    %esi
801045cc:	5d                   	pop    %ebp
  release(&lk->lk);
801045cd:	e9 0e 02 00 00       	jmp    801047e0 <release>
801045d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045e8:	8d 73 04             	lea    0x4(%ebx),%esi
801045eb:	83 ec 0c             	sub    $0xc,%esp
801045ee:	56                   	push   %esi
801045ef:	e8 4c 02 00 00       	call   80104840 <acquire>
  lk->locked = 0;
801045f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104601:	89 1c 24             	mov    %ebx,(%esp)
80104604:	e8 97 fd ff ff       	call   801043a0 <wakeup>
  release(&lk->lk);
80104609:	89 75 08             	mov    %esi,0x8(%ebp)
8010460c:	83 c4 10             	add    $0x10,%esp
}
8010460f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104612:	5b                   	pop    %ebx
80104613:	5e                   	pop    %esi
80104614:	5d                   	pop    %ebp
  release(&lk->lk);
80104615:	e9 c6 01 00 00       	jmp    801047e0 <release>
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104620 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	31 ff                	xor    %edi,%edi
80104626:	56                   	push   %esi
80104627:	53                   	push   %ebx
80104628:	83 ec 18             	sub    $0x18,%esp
8010462b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010462e:	8d 73 04             	lea    0x4(%ebx),%esi
80104631:	56                   	push   %esi
80104632:	e8 09 02 00 00       	call   80104840 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104637:	8b 03                	mov    (%ebx),%eax
80104639:	83 c4 10             	add    $0x10,%esp
8010463c:	85 c0                	test   %eax,%eax
8010463e:	75 18                	jne    80104658 <holdingsleep+0x38>
  release(&lk->lk);
80104640:	83 ec 0c             	sub    $0xc,%esp
80104643:	56                   	push   %esi
80104644:	e8 97 01 00 00       	call   801047e0 <release>
  return r;
}
80104649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010464c:	89 f8                	mov    %edi,%eax
8010464e:	5b                   	pop    %ebx
8010464f:	5e                   	pop    %esi
80104650:	5f                   	pop    %edi
80104651:	5d                   	pop    %ebp
80104652:	c3                   	ret    
80104653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104657:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104658:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010465b:	e8 10 f5 ff ff       	call   80103b70 <myproc>
80104660:	39 58 14             	cmp    %ebx,0x14(%eax)
80104663:	0f 94 c0             	sete   %al
80104666:	0f b6 c0             	movzbl %al,%eax
80104669:	89 c7                	mov    %eax,%edi
8010466b:	eb d3                	jmp    80104640 <holdingsleep+0x20>
8010466d:	66 90                	xchg   %ax,%ax
8010466f:	90                   	nop

80104670 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104676:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010467f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104682:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    
8010468b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop

80104690 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104690:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104691:	31 d2                	xor    %edx,%edx
{
80104693:	89 e5                	mov    %esp,%ebp
80104695:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104696:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010469c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010469f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046ac:	77 1a                	ja     801046c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046ae:	8b 58 04             	mov    0x4(%eax),%ebx
801046b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046b9:	83 fa 0a             	cmp    $0xa,%edx
801046bc:	75 e2                	jne    801046a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c1:	c9                   	leave  
801046c2:	c3                   	ret    
801046c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046c7:	90                   	nop
  for(; i < 10; i++)
801046c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046cb:	8d 51 28             	lea    0x28(%ecx),%edx
801046ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046d6:	83 c0 04             	add    $0x4,%eax
801046d9:	39 d0                	cmp    %edx,%eax
801046db:	75 f3                	jne    801046d0 <getcallerpcs+0x40>
}
801046dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e0:	c9                   	leave  
801046e1:	c3                   	ret    
801046e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 04             	sub    $0x4,%esp
801046f7:	9c                   	pushf  
801046f8:	5b                   	pop    %ebx
  asm volatile("cli");
801046f9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801046fa:	e8 f1 f3 ff ff       	call   80103af0 <mycpu>
801046ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104705:	85 c0                	test   %eax,%eax
80104707:	74 17                	je     80104720 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104709:	e8 e2 f3 ff ff       	call   80103af0 <mycpu>
8010470e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104718:	c9                   	leave  
80104719:	c3                   	ret    
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104720:	e8 cb f3 ff ff       	call   80103af0 <mycpu>
80104725:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010472b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104731:	eb d6                	jmp    80104709 <pushcli+0x19>
80104733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104740 <popcli>:

void
popcli(void)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104746:	9c                   	pushf  
80104747:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104748:	f6 c4 02             	test   $0x2,%ah
8010474b:	75 35                	jne    80104782 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010474d:	e8 9e f3 ff ff       	call   80103af0 <mycpu>
80104752:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104759:	78 34                	js     8010478f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010475b:	e8 90 f3 ff ff       	call   80103af0 <mycpu>
80104760:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104766:	85 d2                	test   %edx,%edx
80104768:	74 06                	je     80104770 <popcli+0x30>
    sti();
}
8010476a:	c9                   	leave  
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104770:	e8 7b f3 ff ff       	call   80103af0 <mycpu>
80104775:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010477b:	85 c0                	test   %eax,%eax
8010477d:	74 eb                	je     8010476a <popcli+0x2a>
  asm volatile("sti");
8010477f:	fb                   	sti    
}
80104780:	c9                   	leave  
80104781:	c3                   	ret    
    panic("popcli - interruptible");
80104782:	83 ec 0c             	sub    $0xc,%esp
80104785:	68 2f 80 10 80       	push   $0x8010802f
8010478a:	e8 f1 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010478f:	83 ec 0c             	sub    $0xc,%esp
80104792:	68 46 80 10 80       	push   $0x80108046
80104797:	e8 e4 bb ff ff       	call   80100380 <panic>
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047a0 <holding>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	8b 75 08             	mov    0x8(%ebp),%esi
801047a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047aa:	e8 41 ff ff ff       	call   801046f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047af:	8b 06                	mov    (%esi),%eax
801047b1:	85 c0                	test   %eax,%eax
801047b3:	75 0b                	jne    801047c0 <holding+0x20>
  popcli();
801047b5:	e8 86 ff ff ff       	call   80104740 <popcli>
}
801047ba:	89 d8                	mov    %ebx,%eax
801047bc:	5b                   	pop    %ebx
801047bd:	5e                   	pop    %esi
801047be:	5d                   	pop    %ebp
801047bf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801047c0:	8b 5e 08             	mov    0x8(%esi),%ebx
801047c3:	e8 28 f3 ff ff       	call   80103af0 <mycpu>
801047c8:	39 c3                	cmp    %eax,%ebx
801047ca:	0f 94 c3             	sete   %bl
  popcli();
801047cd:	e8 6e ff ff ff       	call   80104740 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801047d2:	0f b6 db             	movzbl %bl,%ebx
}
801047d5:	89 d8                	mov    %ebx,%eax
801047d7:	5b                   	pop    %ebx
801047d8:	5e                   	pop    %esi
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret    
801047db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047df:	90                   	nop

801047e0 <release>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047e8:	e8 03 ff ff ff       	call   801046f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047ed:	8b 03                	mov    (%ebx),%eax
801047ef:	85 c0                	test   %eax,%eax
801047f1:	75 15                	jne    80104808 <release+0x28>
  popcli();
801047f3:	e8 48 ff ff ff       	call   80104740 <popcli>
    panic("release");
801047f8:	83 ec 0c             	sub    $0xc,%esp
801047fb:	68 4d 80 10 80       	push   $0x8010804d
80104800:	e8 7b bb ff ff       	call   80100380 <panic>
80104805:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104808:	8b 73 08             	mov    0x8(%ebx),%esi
8010480b:	e8 e0 f2 ff ff       	call   80103af0 <mycpu>
80104810:	39 c6                	cmp    %eax,%esi
80104812:	75 df                	jne    801047f3 <release+0x13>
  popcli();
80104814:	e8 27 ff ff ff       	call   80104740 <popcli>
  lk->pcs[0] = 0;
80104819:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104820:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104827:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010482c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104832:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104835:	5b                   	pop    %ebx
80104836:	5e                   	pop    %esi
80104837:	5d                   	pop    %ebp
  popcli();
80104838:	e9 03 ff ff ff       	jmp    80104740 <popcli>
8010483d:	8d 76 00             	lea    0x0(%esi),%esi

80104840 <acquire>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104847:	e8 a4 fe ff ff       	call   801046f0 <pushcli>
  if(holding(lk))
8010484c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010484f:	e8 9c fe ff ff       	call   801046f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104854:	8b 03                	mov    (%ebx),%eax
80104856:	85 c0                	test   %eax,%eax
80104858:	75 7e                	jne    801048d8 <acquire+0x98>
  popcli();
8010485a:	e8 e1 fe ff ff       	call   80104740 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010485f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104868:	8b 55 08             	mov    0x8(%ebp),%edx
8010486b:	89 c8                	mov    %ecx,%eax
8010486d:	f0 87 02             	lock xchg %eax,(%edx)
80104870:	85 c0                	test   %eax,%eax
80104872:	75 f4                	jne    80104868 <acquire+0x28>
  __sync_synchronize();
80104874:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104879:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010487c:	e8 6f f2 ff ff       	call   80103af0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104881:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104884:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104886:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104889:	31 c0                	xor    %eax,%eax
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104890:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104896:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010489c:	77 1a                	ja     801048b8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010489e:	8b 5a 04             	mov    0x4(%edx),%ebx
801048a1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048a5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048a8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048aa:	83 f8 0a             	cmp    $0xa,%eax
801048ad:	75 e1                	jne    80104890 <acquire+0x50>
}
801048af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048b2:	c9                   	leave  
801048b3:	c3                   	ret    
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801048b8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801048bc:	8d 51 34             	lea    0x34(%ecx),%edx
801048bf:	90                   	nop
    pcs[i] = 0;
801048c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048c6:	83 c0 04             	add    $0x4,%eax
801048c9:	39 c2                	cmp    %eax,%edx
801048cb:	75 f3                	jne    801048c0 <acquire+0x80>
}
801048cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d0:	c9                   	leave  
801048d1:	c3                   	ret    
801048d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048d8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801048db:	e8 10 f2 ff ff       	call   80103af0 <mycpu>
801048e0:	39 c3                	cmp    %eax,%ebx
801048e2:	0f 85 72 ff ff ff    	jne    8010485a <acquire+0x1a>
  popcli();
801048e8:	e8 53 fe ff ff       	call   80104740 <popcli>
    panic("acquire");
801048ed:	83 ec 0c             	sub    $0xc,%esp
801048f0:	68 55 80 10 80       	push   $0x80108055
801048f5:	e8 86 ba ff ff       	call   80100380 <panic>
801048fa:	66 90                	xchg   %ax,%ax
801048fc:	66 90                	xchg   %ax,%ax
801048fe:	66 90                	xchg   %ax,%ax

80104900 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	8b 55 08             	mov    0x8(%ebp),%edx
80104907:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010490a:	53                   	push   %ebx
8010490b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010490e:	89 d7                	mov    %edx,%edi
80104910:	09 cf                	or     %ecx,%edi
80104912:	83 e7 03             	and    $0x3,%edi
80104915:	75 29                	jne    80104940 <memset+0x40>
    c &= 0xFF;
80104917:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010491a:	c1 e0 18             	shl    $0x18,%eax
8010491d:	89 fb                	mov    %edi,%ebx
8010491f:	c1 e9 02             	shr    $0x2,%ecx
80104922:	c1 e3 10             	shl    $0x10,%ebx
80104925:	09 d8                	or     %ebx,%eax
80104927:	09 f8                	or     %edi,%eax
80104929:	c1 e7 08             	shl    $0x8,%edi
8010492c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010492e:	89 d7                	mov    %edx,%edi
80104930:	fc                   	cld    
80104931:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104933:	5b                   	pop    %ebx
80104934:	89 d0                	mov    %edx,%eax
80104936:	5f                   	pop    %edi
80104937:	5d                   	pop    %ebp
80104938:	c3                   	ret    
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104940:	89 d7                	mov    %edx,%edi
80104942:	fc                   	cld    
80104943:	f3 aa                	rep stos %al,%es:(%edi)
80104945:	5b                   	pop    %ebx
80104946:	89 d0                	mov    %edx,%eax
80104948:	5f                   	pop    %edi
80104949:	5d                   	pop    %ebp
8010494a:	c3                   	ret    
8010494b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010494f:	90                   	nop

80104950 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	8b 75 10             	mov    0x10(%ebp),%esi
80104957:	8b 55 08             	mov    0x8(%ebp),%edx
8010495a:	53                   	push   %ebx
8010495b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010495e:	85 f6                	test   %esi,%esi
80104960:	74 2e                	je     80104990 <memcmp+0x40>
80104962:	01 c6                	add    %eax,%esi
80104964:	eb 14                	jmp    8010497a <memcmp+0x2a>
80104966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104970:	83 c0 01             	add    $0x1,%eax
80104973:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104976:	39 f0                	cmp    %esi,%eax
80104978:	74 16                	je     80104990 <memcmp+0x40>
    if(*s1 != *s2)
8010497a:	0f b6 0a             	movzbl (%edx),%ecx
8010497d:	0f b6 18             	movzbl (%eax),%ebx
80104980:	38 d9                	cmp    %bl,%cl
80104982:	74 ec                	je     80104970 <memcmp+0x20>
      return *s1 - *s2;
80104984:	0f b6 c1             	movzbl %cl,%eax
80104987:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104989:	5b                   	pop    %ebx
8010498a:	5e                   	pop    %esi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
80104990:	5b                   	pop    %ebx
  return 0;
80104991:	31 c0                	xor    %eax,%eax
}
80104993:	5e                   	pop    %esi
80104994:	5d                   	pop    %ebp
80104995:	c3                   	ret    
80104996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499d:	8d 76 00             	lea    0x0(%esi),%esi

801049a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	57                   	push   %edi
801049a4:	8b 55 08             	mov    0x8(%ebp),%edx
801049a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049aa:	56                   	push   %esi
801049ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049ae:	39 d6                	cmp    %edx,%esi
801049b0:	73 26                	jae    801049d8 <memmove+0x38>
801049b2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801049b5:	39 fa                	cmp    %edi,%edx
801049b7:	73 1f                	jae    801049d8 <memmove+0x38>
801049b9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801049bc:	85 c9                	test   %ecx,%ecx
801049be:	74 0c                	je     801049cc <memmove+0x2c>
      *--d = *--s;
801049c0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049c4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801049c7:	83 e8 01             	sub    $0x1,%eax
801049ca:	73 f4                	jae    801049c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049cc:	5e                   	pop    %esi
801049cd:	89 d0                	mov    %edx,%eax
801049cf:	5f                   	pop    %edi
801049d0:	5d                   	pop    %ebp
801049d1:	c3                   	ret    
801049d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801049d8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801049db:	89 d7                	mov    %edx,%edi
801049dd:	85 c9                	test   %ecx,%ecx
801049df:	74 eb                	je     801049cc <memmove+0x2c>
801049e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801049e8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801049e9:	39 c6                	cmp    %eax,%esi
801049eb:	75 fb                	jne    801049e8 <memmove+0x48>
}
801049ed:	5e                   	pop    %esi
801049ee:	89 d0                	mov    %edx,%eax
801049f0:	5f                   	pop    %edi
801049f1:	5d                   	pop    %ebp
801049f2:	c3                   	ret    
801049f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a00:	eb 9e                	jmp    801049a0 <memmove>
80104a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a10 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	8b 75 10             	mov    0x10(%ebp),%esi
80104a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a1a:	53                   	push   %ebx
80104a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104a1e:	85 f6                	test   %esi,%esi
80104a20:	74 2e                	je     80104a50 <strncmp+0x40>
80104a22:	01 d6                	add    %edx,%esi
80104a24:	eb 18                	jmp    80104a3e <strncmp+0x2e>
80104a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi
80104a30:	38 d8                	cmp    %bl,%al
80104a32:	75 14                	jne    80104a48 <strncmp+0x38>
    n--, p++, q++;
80104a34:	83 c2 01             	add    $0x1,%edx
80104a37:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a3a:	39 f2                	cmp    %esi,%edx
80104a3c:	74 12                	je     80104a50 <strncmp+0x40>
80104a3e:	0f b6 01             	movzbl (%ecx),%eax
80104a41:	0f b6 1a             	movzbl (%edx),%ebx
80104a44:	84 c0                	test   %al,%al
80104a46:	75 e8                	jne    80104a30 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a48:	29 d8                	sub    %ebx,%eax
}
80104a4a:	5b                   	pop    %ebx
80104a4b:	5e                   	pop    %esi
80104a4c:	5d                   	pop    %ebp
80104a4d:	c3                   	ret    
80104a4e:	66 90                	xchg   %ax,%ax
80104a50:	5b                   	pop    %ebx
    return 0;
80104a51:	31 c0                	xor    %eax,%eax
}
80104a53:	5e                   	pop    %esi
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi

80104a60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	56                   	push   %esi
80104a65:	8b 75 08             	mov    0x8(%ebp),%esi
80104a68:	53                   	push   %ebx
80104a69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a6c:	89 f0                	mov    %esi,%eax
80104a6e:	eb 15                	jmp    80104a85 <strncpy+0x25>
80104a70:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a74:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a77:	83 c0 01             	add    $0x1,%eax
80104a7a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a7e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a81:	84 d2                	test   %dl,%dl
80104a83:	74 09                	je     80104a8e <strncpy+0x2e>
80104a85:	89 cb                	mov    %ecx,%ebx
80104a87:	83 e9 01             	sub    $0x1,%ecx
80104a8a:	85 db                	test   %ebx,%ebx
80104a8c:	7f e2                	jg     80104a70 <strncpy+0x10>
    ;
  while(n-- > 0)
80104a8e:	89 c2                	mov    %eax,%edx
80104a90:	85 c9                	test   %ecx,%ecx
80104a92:	7e 17                	jle    80104aab <strncpy+0x4b>
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a98:	83 c2 01             	add    $0x1,%edx
80104a9b:	89 c1                	mov    %eax,%ecx
80104a9d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104aa1:	29 d1                	sub    %edx,%ecx
80104aa3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104aa7:	85 c9                	test   %ecx,%ecx
80104aa9:	7f ed                	jg     80104a98 <strncpy+0x38>
  return os;
}
80104aab:	5b                   	pop    %ebx
80104aac:	89 f0                	mov    %esi,%eax
80104aae:	5e                   	pop    %esi
80104aaf:	5f                   	pop    %edi
80104ab0:	5d                   	pop    %ebp
80104ab1:	c3                   	ret    
80104ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ac7:	8b 75 08             	mov    0x8(%ebp),%esi
80104aca:	53                   	push   %ebx
80104acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104ace:	85 d2                	test   %edx,%edx
80104ad0:	7e 25                	jle    80104af7 <safestrcpy+0x37>
80104ad2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ad6:	89 f2                	mov    %esi,%edx
80104ad8:	eb 16                	jmp    80104af0 <safestrcpy+0x30>
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ae0:	0f b6 08             	movzbl (%eax),%ecx
80104ae3:	83 c0 01             	add    $0x1,%eax
80104ae6:	83 c2 01             	add    $0x1,%edx
80104ae9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104aec:	84 c9                	test   %cl,%cl
80104aee:	74 04                	je     80104af4 <safestrcpy+0x34>
80104af0:	39 d8                	cmp    %ebx,%eax
80104af2:	75 ec                	jne    80104ae0 <safestrcpy+0x20>
    ;
  *s = 0;
80104af4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104af7:	89 f0                	mov    %esi,%eax
80104af9:	5b                   	pop    %ebx
80104afa:	5e                   	pop    %esi
80104afb:	5d                   	pop    %ebp
80104afc:	c3                   	ret    
80104afd:	8d 76 00             	lea    0x0(%esi),%esi

80104b00 <strlen>:

int
strlen(const char *s)
{
80104b00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b01:	31 c0                	xor    %eax,%eax
{
80104b03:	89 e5                	mov    %esp,%ebp
80104b05:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b08:	80 3a 00             	cmpb   $0x0,(%edx)
80104b0b:	74 0c                	je     80104b19 <strlen+0x19>
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi
80104b10:	83 c0 01             	add    $0x1,%eax
80104b13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b17:	75 f7                	jne    80104b10 <strlen+0x10>
    ;
  return n;
}
80104b19:	5d                   	pop    %ebp
80104b1a:	c3                   	ret    

80104b1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b23:	55                   	push   %ebp
  pushl %ebx
80104b24:	53                   	push   %ebx
  pushl %esi
80104b25:	56                   	push   %esi
  pushl %edi
80104b26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b29:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b2b:	5f                   	pop    %edi
  popl %esi
80104b2c:	5e                   	pop    %esi
  popl %ebx
80104b2d:	5b                   	pop    %ebx
  popl %ebp
80104b2e:	5d                   	pop    %ebp
  ret
80104b2f:	c3                   	ret    

80104b30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
80104b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b3a:	e8 31 f0 ff ff       	call   80103b70 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b3f:	8b 00                	mov    (%eax),%eax
80104b41:	39 d8                	cmp    %ebx,%eax
80104b43:	76 1b                	jbe    80104b60 <fetchint+0x30>
80104b45:	8d 53 04             	lea    0x4(%ebx),%edx
80104b48:	39 d0                	cmp    %edx,%eax
80104b4a:	72 14                	jb     80104b60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b4f:	8b 13                	mov    (%ebx),%edx
80104b51:	89 10                	mov    %edx,(%eax)
  return 0;
80104b53:	31 c0                	xor    %eax,%eax
}
80104b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b58:	c9                   	leave  
80104b59:	c3                   	ret    
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b65:	eb ee                	jmp    80104b55 <fetchint+0x25>
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 04             	sub    $0x4,%esp
80104b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b7a:	e8 f1 ef ff ff       	call   80103b70 <myproc>

  if(addr >= curproc->sz)
80104b7f:	39 18                	cmp    %ebx,(%eax)
80104b81:	76 2d                	jbe    80104bb0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b86:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b88:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b8a:	39 d3                	cmp    %edx,%ebx
80104b8c:	73 22                	jae    80104bb0 <fetchstr+0x40>
80104b8e:	89 d8                	mov    %ebx,%eax
80104b90:	eb 0d                	jmp    80104b9f <fetchstr+0x2f>
80104b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b98:	83 c0 01             	add    $0x1,%eax
80104b9b:	39 c2                	cmp    %eax,%edx
80104b9d:	76 11                	jbe    80104bb0 <fetchstr+0x40>
    if(*s == 0)
80104b9f:	80 38 00             	cmpb   $0x0,(%eax)
80104ba2:	75 f4                	jne    80104b98 <fetchstr+0x28>
      return s - *pp;
80104ba4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ba6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba9:	c9                   	leave  
80104baa:	c3                   	ret    
80104bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop
80104bb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bb8:	c9                   	leave  
80104bb9:	c3                   	ret    
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc5:	e8 a6 ef ff ff       	call   80103b70 <myproc>
80104bca:	8b 55 08             	mov    0x8(%ebp),%edx
80104bcd:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bd0:	8b 40 44             	mov    0x44(%eax),%eax
80104bd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bd6:	e8 95 ef ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bdb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bde:	8b 00                	mov    (%eax),%eax
80104be0:	39 c6                	cmp    %eax,%esi
80104be2:	73 1c                	jae    80104c00 <argint+0x40>
80104be4:	8d 53 08             	lea    0x8(%ebx),%edx
80104be7:	39 d0                	cmp    %edx,%eax
80104be9:	72 15                	jb     80104c00 <argint+0x40>
  *ip = *(int*)(addr);
80104beb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bee:	8b 53 04             	mov    0x4(%ebx),%edx
80104bf1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bf3:	31 c0                	xor    %eax,%eax
}
80104bf5:	5b                   	pop    %ebx
80104bf6:	5e                   	pop    %esi
80104bf7:	5d                   	pop    %ebp
80104bf8:	c3                   	ret    
80104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c05:	eb ee                	jmp    80104bf5 <argint+0x35>
80104c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	57                   	push   %edi
80104c14:	56                   	push   %esi
80104c15:	53                   	push   %ebx
80104c16:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c19:	e8 52 ef ff ff       	call   80103b70 <myproc>
80104c1e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c20:	e8 4b ef ff ff       	call   80103b70 <myproc>
80104c25:	8b 55 08             	mov    0x8(%ebp),%edx
80104c28:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c2b:	8b 40 44             	mov    0x44(%eax),%eax
80104c2e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c31:	e8 3a ef ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c36:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c39:	8b 00                	mov    (%eax),%eax
80104c3b:	39 c7                	cmp    %eax,%edi
80104c3d:	73 31                	jae    80104c70 <argptr+0x60>
80104c3f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c42:	39 c8                	cmp    %ecx,%eax
80104c44:	72 2a                	jb     80104c70 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c46:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c49:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c4c:	85 d2                	test   %edx,%edx
80104c4e:	78 20                	js     80104c70 <argptr+0x60>
80104c50:	8b 16                	mov    (%esi),%edx
80104c52:	39 c2                	cmp    %eax,%edx
80104c54:	76 1a                	jbe    80104c70 <argptr+0x60>
80104c56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c59:	01 c3                	add    %eax,%ebx
80104c5b:	39 da                	cmp    %ebx,%edx
80104c5d:	72 11                	jb     80104c70 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c62:	89 02                	mov    %eax,(%edx)
  return 0;
80104c64:	31 c0                	xor    %eax,%eax
}
80104c66:	83 c4 0c             	add    $0xc,%esp
80104c69:	5b                   	pop    %ebx
80104c6a:	5e                   	pop    %esi
80104c6b:	5f                   	pop    %edi
80104c6c:	5d                   	pop    %ebp
80104c6d:	c3                   	ret    
80104c6e:	66 90                	xchg   %ax,%ax
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c75:	eb ef                	jmp    80104c66 <argptr+0x56>
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c85:	e8 e6 ee ff ff       	call   80103b70 <myproc>
80104c8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c8d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c90:	8b 40 44             	mov    0x44(%eax),%eax
80104c93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c96:	e8 d5 ee ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c9e:	8b 00                	mov    (%eax),%eax
80104ca0:	39 c6                	cmp    %eax,%esi
80104ca2:	73 44                	jae    80104ce8 <argstr+0x68>
80104ca4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ca7:	39 d0                	cmp    %edx,%eax
80104ca9:	72 3d                	jb     80104ce8 <argstr+0x68>
  *ip = *(int*)(addr);
80104cab:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104cae:	e8 bd ee ff ff       	call   80103b70 <myproc>
  if(addr >= curproc->sz)
80104cb3:	3b 18                	cmp    (%eax),%ebx
80104cb5:	73 31                	jae    80104ce8 <argstr+0x68>
  *pp = (char*)addr;
80104cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104cbc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cbe:	39 d3                	cmp    %edx,%ebx
80104cc0:	73 26                	jae    80104ce8 <argstr+0x68>
80104cc2:	89 d8                	mov    %ebx,%eax
80104cc4:	eb 11                	jmp    80104cd7 <argstr+0x57>
80104cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
80104cd0:	83 c0 01             	add    $0x1,%eax
80104cd3:	39 c2                	cmp    %eax,%edx
80104cd5:	76 11                	jbe    80104ce8 <argstr+0x68>
    if(*s == 0)
80104cd7:	80 38 00             	cmpb   $0x0,(%eax)
80104cda:	75 f4                	jne    80104cd0 <argstr+0x50>
      return s - *pp;
80104cdc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cde:	5b                   	pop    %ebx
80104cdf:	5e                   	pop    %esi
80104ce0:	5d                   	pop    %ebp
80104ce1:	c3                   	ret    
80104ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ce8:	5b                   	pop    %ebx
    return -1;
80104ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cee:	5e                   	pop    %esi
80104cef:	5d                   	pop    %ebp
80104cf0:	c3                   	ret    
80104cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cff:	90                   	nop

80104d00 <syscall>:
[SYS_getthp] sys_getthp,
};

void
syscall(void)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d07:	e8 64 ee ff ff       	call   80103b70 <myproc>
80104d0c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d0e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d11:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d14:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d17:	83 fa 19             	cmp    $0x19,%edx
80104d1a:	77 24                	ja     80104d40 <syscall+0x40>
80104d1c:	8b 14 85 80 80 10 80 	mov    -0x7fef7f80(,%eax,4),%edx
80104d23:	85 d2                	test   %edx,%edx
80104d25:	74 19                	je     80104d40 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d27:	ff d2                	call   *%edx
80104d29:	89 c2                	mov    %eax,%edx
80104d2b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d2e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d34:	c9                   	leave  
80104d35:	c3                   	ret    
80104d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d40:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d41:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d44:	50                   	push   %eax
80104d45:	ff 73 14             	push   0x14(%ebx)
80104d48:	68 5d 80 10 80       	push   $0x8010805d
80104d4d:	e8 4e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d52:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d55:	83 c4 10             	add    $0x10,%esp
80104d58:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d62:	c9                   	leave  
80104d63:	c3                   	ret    
80104d64:	66 90                	xchg   %ax,%ax
80104d66:	66 90                	xchg   %ax,%ax
80104d68:	66 90                	xchg   %ax,%ax
80104d6a:	66 90                	xchg   %ax,%ax
80104d6c:	66 90                	xchg   %ax,%ax
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d75:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d78:	53                   	push   %ebx
80104d79:	83 ec 34             	sub    $0x34,%esp
80104d7c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d82:	57                   	push   %edi
80104d83:	50                   	push   %eax
{
80104d84:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d87:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d8a:	e8 41 d3 ff ff       	call   801020d0 <nameiparent>
80104d8f:	83 c4 10             	add    $0x10,%esp
80104d92:	85 c0                	test   %eax,%eax
80104d94:	0f 84 46 01 00 00    	je     80104ee0 <create+0x170>
    return 0;
  ilock(dp);
80104d9a:	83 ec 0c             	sub    $0xc,%esp
80104d9d:	89 c3                	mov    %eax,%ebx
80104d9f:	50                   	push   %eax
80104da0:	e8 eb c9 ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104da5:	83 c4 0c             	add    $0xc,%esp
80104da8:	6a 00                	push   $0x0
80104daa:	57                   	push   %edi
80104dab:	53                   	push   %ebx
80104dac:	e8 3f cf ff ff       	call   80101cf0 <dirlookup>
80104db1:	83 c4 10             	add    $0x10,%esp
80104db4:	89 c6                	mov    %eax,%esi
80104db6:	85 c0                	test   %eax,%eax
80104db8:	74 56                	je     80104e10 <create+0xa0>
    iunlockput(dp);
80104dba:	83 ec 0c             	sub    $0xc,%esp
80104dbd:	53                   	push   %ebx
80104dbe:	e8 5d cc ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104dc3:	89 34 24             	mov    %esi,(%esp)
80104dc6:	e8 c5 c9 ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104dcb:	83 c4 10             	add    $0x10,%esp
80104dce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104dd3:	75 1b                	jne    80104df0 <create+0x80>
80104dd5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dda:	75 14                	jne    80104df0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ddf:	89 f0                	mov    %esi,%eax
80104de1:	5b                   	pop    %ebx
80104de2:	5e                   	pop    %esi
80104de3:	5f                   	pop    %edi
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104df0:	83 ec 0c             	sub    $0xc,%esp
80104df3:	56                   	push   %esi
    return 0;
80104df4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104df6:	e8 25 cc ff ff       	call   80101a20 <iunlockput>
    return 0;
80104dfb:	83 c4 10             	add    $0x10,%esp
}
80104dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e01:	89 f0                	mov    %esi,%eax
80104e03:	5b                   	pop    %ebx
80104e04:	5e                   	pop    %esi
80104e05:	5f                   	pop    %edi
80104e06:	5d                   	pop    %ebp
80104e07:	c3                   	ret    
80104e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e14:	83 ec 08             	sub    $0x8,%esp
80104e17:	50                   	push   %eax
80104e18:	ff 33                	push   (%ebx)
80104e1a:	e8 01 c8 ff ff       	call   80101620 <ialloc>
80104e1f:	83 c4 10             	add    $0x10,%esp
80104e22:	89 c6                	mov    %eax,%esi
80104e24:	85 c0                	test   %eax,%eax
80104e26:	0f 84 cd 00 00 00    	je     80104ef9 <create+0x189>
  ilock(ip);
80104e2c:	83 ec 0c             	sub    $0xc,%esp
80104e2f:	50                   	push   %eax
80104e30:	e8 5b c9 ff ff       	call   80101790 <ilock>
  ip->major = major;
80104e35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e39:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e41:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e45:	b8 01 00 00 00       	mov    $0x1,%eax
80104e4a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e4e:	89 34 24             	mov    %esi,(%esp)
80104e51:	e8 8a c8 ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e56:	83 c4 10             	add    $0x10,%esp
80104e59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e5e:	74 30                	je     80104e90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e60:	83 ec 04             	sub    $0x4,%esp
80104e63:	ff 76 04             	push   0x4(%esi)
80104e66:	57                   	push   %edi
80104e67:	53                   	push   %ebx
80104e68:	e8 83 d1 ff ff       	call   80101ff0 <dirlink>
80104e6d:	83 c4 10             	add    $0x10,%esp
80104e70:	85 c0                	test   %eax,%eax
80104e72:	78 78                	js     80104eec <create+0x17c>
  iunlockput(dp);
80104e74:	83 ec 0c             	sub    $0xc,%esp
80104e77:	53                   	push   %ebx
80104e78:	e8 a3 cb ff ff       	call   80101a20 <iunlockput>
  return ip;
80104e7d:	83 c4 10             	add    $0x10,%esp
}
80104e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e83:	89 f0                	mov    %esi,%eax
80104e85:	5b                   	pop    %ebx
80104e86:	5e                   	pop    %esi
80104e87:	5f                   	pop    %edi
80104e88:	5d                   	pop    %ebp
80104e89:	c3                   	ret    
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e93:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e98:	53                   	push   %ebx
80104e99:	e8 42 c8 ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e9e:	83 c4 0c             	add    $0xc,%esp
80104ea1:	ff 76 04             	push   0x4(%esi)
80104ea4:	68 08 81 10 80       	push   $0x80108108
80104ea9:	56                   	push   %esi
80104eaa:	e8 41 d1 ff ff       	call   80101ff0 <dirlink>
80104eaf:	83 c4 10             	add    $0x10,%esp
80104eb2:	85 c0                	test   %eax,%eax
80104eb4:	78 18                	js     80104ece <create+0x15e>
80104eb6:	83 ec 04             	sub    $0x4,%esp
80104eb9:	ff 73 04             	push   0x4(%ebx)
80104ebc:	68 07 81 10 80       	push   $0x80108107
80104ec1:	56                   	push   %esi
80104ec2:	e8 29 d1 ff ff       	call   80101ff0 <dirlink>
80104ec7:	83 c4 10             	add    $0x10,%esp
80104eca:	85 c0                	test   %eax,%eax
80104ecc:	79 92                	jns    80104e60 <create+0xf0>
      panic("create dots");
80104ece:	83 ec 0c             	sub    $0xc,%esp
80104ed1:	68 fb 80 10 80       	push   $0x801080fb
80104ed6:	e8 a5 b4 ff ff       	call   80100380 <panic>
80104edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104edf:	90                   	nop
}
80104ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ee3:	31 f6                	xor    %esi,%esi
}
80104ee5:	5b                   	pop    %ebx
80104ee6:	89 f0                	mov    %esi,%eax
80104ee8:	5e                   	pop    %esi
80104ee9:	5f                   	pop    %edi
80104eea:	5d                   	pop    %ebp
80104eeb:	c3                   	ret    
    panic("create: dirlink");
80104eec:	83 ec 0c             	sub    $0xc,%esp
80104eef:	68 0a 81 10 80       	push   $0x8010810a
80104ef4:	e8 87 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104ef9:	83 ec 0c             	sub    $0xc,%esp
80104efc:	68 ec 80 10 80       	push   $0x801080ec
80104f01:	e8 7a b4 ff ff       	call   80100380 <panic>
80104f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi

80104f10 <sys_dup>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	56                   	push   %esi
80104f14:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f15:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f18:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f1b:	50                   	push   %eax
80104f1c:	6a 00                	push   $0x0
80104f1e:	e8 9d fc ff ff       	call   80104bc0 <argint>
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	85 c0                	test   %eax,%eax
80104f28:	78 36                	js     80104f60 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f2a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f2e:	77 30                	ja     80104f60 <sys_dup+0x50>
80104f30:	e8 3b ec ff ff       	call   80103b70 <myproc>
80104f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f38:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104f3c:	85 f6                	test   %esi,%esi
80104f3e:	74 20                	je     80104f60 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f40:	e8 2b ec ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f45:	31 db                	xor    %ebx,%ebx
80104f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f50:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104f54:	85 d2                	test   %edx,%edx
80104f56:	74 18                	je     80104f70 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f58:	83 c3 01             	add    $0x1,%ebx
80104f5b:	83 fb 10             	cmp    $0x10,%ebx
80104f5e:	75 f0                	jne    80104f50 <sys_dup+0x40>
}
80104f60:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f68:	89 d8                	mov    %ebx,%eax
80104f6a:	5b                   	pop    %ebx
80104f6b:	5e                   	pop    %esi
80104f6c:	5d                   	pop    %ebp
80104f6d:	c3                   	ret    
80104f6e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f70:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f73:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104f77:	56                   	push   %esi
80104f78:	e8 33 bf ff ff       	call   80100eb0 <filedup>
  return fd;
80104f7d:	83 c4 10             	add    $0x10,%esp
}
80104f80:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f83:	89 d8                	mov    %ebx,%eax
80104f85:	5b                   	pop    %ebx
80104f86:	5e                   	pop    %esi
80104f87:	5d                   	pop    %ebp
80104f88:	c3                   	ret    
80104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f90 <sys_read>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f9b:	53                   	push   %ebx
80104f9c:	6a 00                	push   $0x0
80104f9e:	e8 1d fc ff ff       	call   80104bc0 <argint>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	78 5e                	js     80105008 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104faa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fae:	77 58                	ja     80105008 <sys_read+0x78>
80104fb0:	e8 bb eb ff ff       	call   80103b70 <myproc>
80104fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104fbc:	85 f6                	test   %esi,%esi
80104fbe:	74 48                	je     80105008 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fc0:	83 ec 08             	sub    $0x8,%esp
80104fc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fc6:	50                   	push   %eax
80104fc7:	6a 02                	push   $0x2
80104fc9:	e8 f2 fb ff ff       	call   80104bc0 <argint>
80104fce:	83 c4 10             	add    $0x10,%esp
80104fd1:	85 c0                	test   %eax,%eax
80104fd3:	78 33                	js     80105008 <sys_read+0x78>
80104fd5:	83 ec 04             	sub    $0x4,%esp
80104fd8:	ff 75 f0             	push   -0x10(%ebp)
80104fdb:	53                   	push   %ebx
80104fdc:	6a 01                	push   $0x1
80104fde:	e8 2d fc ff ff       	call   80104c10 <argptr>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	78 1e                	js     80105008 <sys_read+0x78>
  return fileread(f, p, n);
80104fea:	83 ec 04             	sub    $0x4,%esp
80104fed:	ff 75 f0             	push   -0x10(%ebp)
80104ff0:	ff 75 f4             	push   -0xc(%ebp)
80104ff3:	56                   	push   %esi
80104ff4:	e8 37 c0 ff ff       	call   80101030 <fileread>
80104ff9:	83 c4 10             	add    $0x10,%esp
}
80104ffc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fff:	5b                   	pop    %ebx
80105000:	5e                   	pop    %esi
80105001:	5d                   	pop    %ebp
80105002:	c3                   	ret    
80105003:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105007:	90                   	nop
    return -1;
80105008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010500d:	eb ed                	jmp    80104ffc <sys_read+0x6c>
8010500f:	90                   	nop

80105010 <sys_write>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105015:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105018:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010501b:	53                   	push   %ebx
8010501c:	6a 00                	push   $0x0
8010501e:	e8 9d fb ff ff       	call   80104bc0 <argint>
80105023:	83 c4 10             	add    $0x10,%esp
80105026:	85 c0                	test   %eax,%eax
80105028:	78 5e                	js     80105088 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010502a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010502e:	77 58                	ja     80105088 <sys_write+0x78>
80105030:	e8 3b eb ff ff       	call   80103b70 <myproc>
80105035:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105038:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010503c:	85 f6                	test   %esi,%esi
8010503e:	74 48                	je     80105088 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105040:	83 ec 08             	sub    $0x8,%esp
80105043:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105046:	50                   	push   %eax
80105047:	6a 02                	push   $0x2
80105049:	e8 72 fb ff ff       	call   80104bc0 <argint>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	85 c0                	test   %eax,%eax
80105053:	78 33                	js     80105088 <sys_write+0x78>
80105055:	83 ec 04             	sub    $0x4,%esp
80105058:	ff 75 f0             	push   -0x10(%ebp)
8010505b:	53                   	push   %ebx
8010505c:	6a 01                	push   $0x1
8010505e:	e8 ad fb ff ff       	call   80104c10 <argptr>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	85 c0                	test   %eax,%eax
80105068:	78 1e                	js     80105088 <sys_write+0x78>
  return filewrite(f, p, n);
8010506a:	83 ec 04             	sub    $0x4,%esp
8010506d:	ff 75 f0             	push   -0x10(%ebp)
80105070:	ff 75 f4             	push   -0xc(%ebp)
80105073:	56                   	push   %esi
80105074:	e8 47 c0 ff ff       	call   801010c0 <filewrite>
80105079:	83 c4 10             	add    $0x10,%esp
}
8010507c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010507f:	5b                   	pop    %ebx
80105080:	5e                   	pop    %esi
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret    
80105083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105087:	90                   	nop
    return -1;
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508d:	eb ed                	jmp    8010507c <sys_write+0x6c>
8010508f:	90                   	nop

80105090 <sys_close>:
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105095:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105098:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010509b:	50                   	push   %eax
8010509c:	6a 00                	push   $0x0
8010509e:	e8 1d fb ff ff       	call   80104bc0 <argint>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	78 3e                	js     801050e8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ae:	77 38                	ja     801050e8 <sys_close+0x58>
801050b0:	e8 bb ea ff ff       	call   80103b70 <myproc>
801050b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050b8:	8d 5a 08             	lea    0x8(%edx),%ebx
801050bb:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
801050bf:	85 f6                	test   %esi,%esi
801050c1:	74 25                	je     801050e8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050c3:	e8 a8 ea ff ff       	call   80103b70 <myproc>
  fileclose(f);
801050c8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050cb:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
801050d2:	00 
  fileclose(f);
801050d3:	56                   	push   %esi
801050d4:	e8 27 be ff ff       	call   80100f00 <fileclose>
  return 0;
801050d9:	83 c4 10             	add    $0x10,%esp
801050dc:	31 c0                	xor    %eax,%eax
}
801050de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e1:	5b                   	pop    %ebx
801050e2:	5e                   	pop    %esi
801050e3:	5d                   	pop    %ebp
801050e4:	c3                   	ret    
801050e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb ef                	jmp    801050de <sys_close+0x4e>
801050ef:	90                   	nop

801050f0 <sys_fstat>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050fb:	53                   	push   %ebx
801050fc:	6a 00                	push   $0x0
801050fe:	e8 bd fa ff ff       	call   80104bc0 <argint>
80105103:	83 c4 10             	add    $0x10,%esp
80105106:	85 c0                	test   %eax,%eax
80105108:	78 46                	js     80105150 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010510a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010510e:	77 40                	ja     80105150 <sys_fstat+0x60>
80105110:	e8 5b ea ff ff       	call   80103b70 <myproc>
80105115:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105118:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010511c:	85 f6                	test   %esi,%esi
8010511e:	74 30                	je     80105150 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105120:	83 ec 04             	sub    $0x4,%esp
80105123:	6a 14                	push   $0x14
80105125:	53                   	push   %ebx
80105126:	6a 01                	push   $0x1
80105128:	e8 e3 fa ff ff       	call   80104c10 <argptr>
8010512d:	83 c4 10             	add    $0x10,%esp
80105130:	85 c0                	test   %eax,%eax
80105132:	78 1c                	js     80105150 <sys_fstat+0x60>
  return filestat(f, st);
80105134:	83 ec 08             	sub    $0x8,%esp
80105137:	ff 75 f4             	push   -0xc(%ebp)
8010513a:	56                   	push   %esi
8010513b:	e8 a0 be ff ff       	call   80100fe0 <filestat>
80105140:	83 c4 10             	add    $0x10,%esp
}
80105143:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105146:	5b                   	pop    %ebx
80105147:	5e                   	pop    %esi
80105148:	5d                   	pop    %ebp
80105149:	c3                   	ret    
8010514a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105155:	eb ec                	jmp    80105143 <sys_fstat+0x53>
80105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515e:	66 90                	xchg   %ax,%ax

80105160 <sys_link>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105165:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105168:	53                   	push   %ebx
80105169:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 0c fb ff ff       	call   80104c80 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 fb 00 00 00    	js     8010527a <sys_link+0x11a>
8010517f:	83 ec 08             	sub    $0x8,%esp
80105182:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105185:	50                   	push   %eax
80105186:	6a 01                	push   $0x1
80105188:	e8 f3 fa ff ff       	call   80104c80 <argstr>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	0f 88 e2 00 00 00    	js     8010527a <sys_link+0x11a>
  begin_op();
80105198:	e8 a3 dd ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
8010519d:	83 ec 0c             	sub    $0xc,%esp
801051a0:	ff 75 d4             	push   -0x2c(%ebp)
801051a3:	e8 08 cf ff ff       	call   801020b0 <namei>
801051a8:	83 c4 10             	add    $0x10,%esp
801051ab:	89 c3                	mov    %eax,%ebx
801051ad:	85 c0                	test   %eax,%eax
801051af:	0f 84 e4 00 00 00    	je     80105299 <sys_link+0x139>
  ilock(ip);
801051b5:	83 ec 0c             	sub    $0xc,%esp
801051b8:	50                   	push   %eax
801051b9:	e8 d2 c5 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051c6:	0f 84 b5 00 00 00    	je     80105281 <sys_link+0x121>
  iupdate(ip);
801051cc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051cf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051d7:	53                   	push   %ebx
801051d8:	e8 03 c5 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
801051dd:	89 1c 24             	mov    %ebx,(%esp)
801051e0:	e8 8b c6 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051e5:	58                   	pop    %eax
801051e6:	5a                   	pop    %edx
801051e7:	57                   	push   %edi
801051e8:	ff 75 d0             	push   -0x30(%ebp)
801051eb:	e8 e0 ce ff ff       	call   801020d0 <nameiparent>
801051f0:	83 c4 10             	add    $0x10,%esp
801051f3:	89 c6                	mov    %eax,%esi
801051f5:	85 c0                	test   %eax,%eax
801051f7:	74 5b                	je     80105254 <sys_link+0xf4>
  ilock(dp);
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	50                   	push   %eax
801051fd:	e8 8e c5 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105202:	8b 03                	mov    (%ebx),%eax
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	39 06                	cmp    %eax,(%esi)
80105209:	75 3d                	jne    80105248 <sys_link+0xe8>
8010520b:	83 ec 04             	sub    $0x4,%esp
8010520e:	ff 73 04             	push   0x4(%ebx)
80105211:	57                   	push   %edi
80105212:	56                   	push   %esi
80105213:	e8 d8 cd ff ff       	call   80101ff0 <dirlink>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	78 29                	js     80105248 <sys_link+0xe8>
  iunlockput(dp);
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	56                   	push   %esi
80105223:	e8 f8 c7 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
80105228:	89 1c 24             	mov    %ebx,(%esp)
8010522b:	e8 90 c6 ff ff       	call   801018c0 <iput>
  end_op();
80105230:	e8 7b dd ff ff       	call   80102fb0 <end_op>
  return 0;
80105235:	83 c4 10             	add    $0x10,%esp
80105238:	31 c0                	xor    %eax,%eax
}
8010523a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010523d:	5b                   	pop    %ebx
8010523e:	5e                   	pop    %esi
8010523f:	5f                   	pop    %edi
80105240:	5d                   	pop    %ebp
80105241:	c3                   	ret    
80105242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105248:	83 ec 0c             	sub    $0xc,%esp
8010524b:	56                   	push   %esi
8010524c:	e8 cf c7 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105251:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	53                   	push   %ebx
80105258:	e8 33 c5 ff ff       	call   80101790 <ilock>
  ip->nlink--;
8010525d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105262:	89 1c 24             	mov    %ebx,(%esp)
80105265:	e8 76 c4 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010526a:	89 1c 24             	mov    %ebx,(%esp)
8010526d:	e8 ae c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105272:	e8 39 dd ff ff       	call   80102fb0 <end_op>
  return -1;
80105277:	83 c4 10             	add    $0x10,%esp
8010527a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527f:	eb b9                	jmp    8010523a <sys_link+0xda>
    iunlockput(ip);
80105281:	83 ec 0c             	sub    $0xc,%esp
80105284:	53                   	push   %ebx
80105285:	e8 96 c7 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010528a:	e8 21 dd ff ff       	call   80102fb0 <end_op>
    return -1;
8010528f:	83 c4 10             	add    $0x10,%esp
80105292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105297:	eb a1                	jmp    8010523a <sys_link+0xda>
    end_op();
80105299:	e8 12 dd ff ff       	call   80102fb0 <end_op>
    return -1;
8010529e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a3:	eb 95                	jmp    8010523a <sys_link+0xda>
801052a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052b0 <sys_unlink>:
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052b8:	53                   	push   %ebx
801052b9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052bc:	50                   	push   %eax
801052bd:	6a 00                	push   $0x0
801052bf:	e8 bc f9 ff ff       	call   80104c80 <argstr>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	0f 88 7a 01 00 00    	js     80105449 <sys_unlink+0x199>
  begin_op();
801052cf:	e8 6c dc ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052d4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052d7:	83 ec 08             	sub    $0x8,%esp
801052da:	53                   	push   %ebx
801052db:	ff 75 c0             	push   -0x40(%ebp)
801052de:	e8 ed cd ff ff       	call   801020d0 <nameiparent>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052e9:	85 c0                	test   %eax,%eax
801052eb:	0f 84 62 01 00 00    	je     80105453 <sys_unlink+0x1a3>
  ilock(dp);
801052f1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	57                   	push   %edi
801052f8:	e8 93 c4 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052fd:	58                   	pop    %eax
801052fe:	5a                   	pop    %edx
801052ff:	68 08 81 10 80       	push   $0x80108108
80105304:	53                   	push   %ebx
80105305:	e8 c6 c9 ff ff       	call   80101cd0 <namecmp>
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	85 c0                	test   %eax,%eax
8010530f:	0f 84 fb 00 00 00    	je     80105410 <sys_unlink+0x160>
80105315:	83 ec 08             	sub    $0x8,%esp
80105318:	68 07 81 10 80       	push   $0x80108107
8010531d:	53                   	push   %ebx
8010531e:	e8 ad c9 ff ff       	call   80101cd0 <namecmp>
80105323:	83 c4 10             	add    $0x10,%esp
80105326:	85 c0                	test   %eax,%eax
80105328:	0f 84 e2 00 00 00    	je     80105410 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010532e:	83 ec 04             	sub    $0x4,%esp
80105331:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105334:	50                   	push   %eax
80105335:	53                   	push   %ebx
80105336:	57                   	push   %edi
80105337:	e8 b4 c9 ff ff       	call   80101cf0 <dirlookup>
8010533c:	83 c4 10             	add    $0x10,%esp
8010533f:	89 c3                	mov    %eax,%ebx
80105341:	85 c0                	test   %eax,%eax
80105343:	0f 84 c7 00 00 00    	je     80105410 <sys_unlink+0x160>
  ilock(ip);
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	50                   	push   %eax
8010534d:	e8 3e c4 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010535a:	0f 8e 1c 01 00 00    	jle    8010547c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105360:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105365:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105368:	74 66                	je     801053d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010536a:	83 ec 04             	sub    $0x4,%esp
8010536d:	6a 10                	push   $0x10
8010536f:	6a 00                	push   $0x0
80105371:	57                   	push   %edi
80105372:	e8 89 f5 ff ff       	call   80104900 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105377:	6a 10                	push   $0x10
80105379:	ff 75 c4             	push   -0x3c(%ebp)
8010537c:	57                   	push   %edi
8010537d:	ff 75 b4             	push   -0x4c(%ebp)
80105380:	e8 1b c8 ff ff       	call   80101ba0 <writei>
80105385:	83 c4 20             	add    $0x20,%esp
80105388:	83 f8 10             	cmp    $0x10,%eax
8010538b:	0f 85 de 00 00 00    	jne    8010546f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105391:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105396:	0f 84 94 00 00 00    	je     80105430 <sys_unlink+0x180>
  iunlockput(dp);
8010539c:	83 ec 0c             	sub    $0xc,%esp
8010539f:	ff 75 b4             	push   -0x4c(%ebp)
801053a2:	e8 79 c6 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
801053a7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053ac:	89 1c 24             	mov    %ebx,(%esp)
801053af:	e8 2c c3 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
801053b4:	89 1c 24             	mov    %ebx,(%esp)
801053b7:	e8 64 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
801053bc:	e8 ef db ff ff       	call   80102fb0 <end_op>
  return 0;
801053c1:	83 c4 10             	add    $0x10,%esp
801053c4:	31 c0                	xor    %eax,%eax
}
801053c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c9:	5b                   	pop    %ebx
801053ca:	5e                   	pop    %esi
801053cb:	5f                   	pop    %edi
801053cc:	5d                   	pop    %ebp
801053cd:	c3                   	ret    
801053ce:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053d4:	76 94                	jbe    8010536a <sys_unlink+0xba>
801053d6:	be 20 00 00 00       	mov    $0x20,%esi
801053db:	eb 0b                	jmp    801053e8 <sys_unlink+0x138>
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
801053e0:	83 c6 10             	add    $0x10,%esi
801053e3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053e6:	73 82                	jae    8010536a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053e8:	6a 10                	push   $0x10
801053ea:	56                   	push   %esi
801053eb:	57                   	push   %edi
801053ec:	53                   	push   %ebx
801053ed:	e8 ae c6 ff ff       	call   80101aa0 <readi>
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	83 f8 10             	cmp    $0x10,%eax
801053f8:	75 68                	jne    80105462 <sys_unlink+0x1b2>
    if(de.inum != 0)
801053fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053ff:	74 df                	je     801053e0 <sys_unlink+0x130>
    iunlockput(ip);
80105401:	83 ec 0c             	sub    $0xc,%esp
80105404:	53                   	push   %ebx
80105405:	e8 16 c6 ff ff       	call   80101a20 <iunlockput>
    goto bad;
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	ff 75 b4             	push   -0x4c(%ebp)
80105416:	e8 05 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010541b:	e8 90 db ff ff       	call   80102fb0 <end_op>
  return -1;
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105428:	eb 9c                	jmp    801053c6 <sys_unlink+0x116>
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105430:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105433:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105436:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010543b:	50                   	push   %eax
8010543c:	e8 9f c2 ff ff       	call   801016e0 <iupdate>
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	e9 53 ff ff ff       	jmp    8010539c <sys_unlink+0xec>
    return -1;
80105449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544e:	e9 73 ff ff ff       	jmp    801053c6 <sys_unlink+0x116>
    end_op();
80105453:	e8 58 db ff ff       	call   80102fb0 <end_op>
    return -1;
80105458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545d:	e9 64 ff ff ff       	jmp    801053c6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105462:	83 ec 0c             	sub    $0xc,%esp
80105465:	68 2c 81 10 80       	push   $0x8010812c
8010546a:	e8 11 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010546f:	83 ec 0c             	sub    $0xc,%esp
80105472:	68 3e 81 10 80       	push   $0x8010813e
80105477:	e8 04 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010547c:	83 ec 0c             	sub    $0xc,%esp
8010547f:	68 1a 81 10 80       	push   $0x8010811a
80105484:	e8 f7 ae ff ff       	call   80100380 <panic>
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_open>:

int
sys_open(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105495:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105498:	53                   	push   %ebx
80105499:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010549c:	50                   	push   %eax
8010549d:	6a 00                	push   $0x0
8010549f:	e8 dc f7 ff ff       	call   80104c80 <argstr>
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
801054a9:	0f 88 8e 00 00 00    	js     8010553d <sys_open+0xad>
801054af:	83 ec 08             	sub    $0x8,%esp
801054b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054b5:	50                   	push   %eax
801054b6:	6a 01                	push   $0x1
801054b8:	e8 03 f7 ff ff       	call   80104bc0 <argint>
801054bd:	83 c4 10             	add    $0x10,%esp
801054c0:	85 c0                	test   %eax,%eax
801054c2:	78 79                	js     8010553d <sys_open+0xad>
    return -1;

  begin_op();
801054c4:	e8 77 da ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
801054c9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054cd:	75 79                	jne    80105548 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	ff 75 e0             	push   -0x20(%ebp)
801054d5:	e8 d6 cb ff ff       	call   801020b0 <namei>
801054da:	83 c4 10             	add    $0x10,%esp
801054dd:	89 c6                	mov    %eax,%esi
801054df:	85 c0                	test   %eax,%eax
801054e1:	0f 84 7e 00 00 00    	je     80105565 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054e7:	83 ec 0c             	sub    $0xc,%esp
801054ea:	50                   	push   %eax
801054eb:	e8 a0 c2 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054f0:	83 c4 10             	add    $0x10,%esp
801054f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054f8:	0f 84 c2 00 00 00    	je     801055c0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054fe:	e8 3d b9 ff ff       	call   80100e40 <filealloc>
80105503:	89 c7                	mov    %eax,%edi
80105505:	85 c0                	test   %eax,%eax
80105507:	74 23                	je     8010552c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105509:	e8 62 e6 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010550e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105510:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105514:	85 d2                	test   %edx,%edx
80105516:	74 60                	je     80105578 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105518:	83 c3 01             	add    $0x1,%ebx
8010551b:	83 fb 10             	cmp    $0x10,%ebx
8010551e:	75 f0                	jne    80105510 <sys_open+0x80>
    if(f)
      fileclose(f);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	57                   	push   %edi
80105524:	e8 d7 b9 ff ff       	call   80100f00 <fileclose>
80105529:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	56                   	push   %esi
80105530:	e8 eb c4 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105535:	e8 76 da ff ff       	call   80102fb0 <end_op>
    return -1;
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105542:	eb 6d                	jmp    801055b1 <sys_open+0x121>
80105544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010554e:	31 c9                	xor    %ecx,%ecx
80105550:	ba 02 00 00 00       	mov    $0x2,%edx
80105555:	6a 00                	push   $0x0
80105557:	e8 14 f8 ff ff       	call   80104d70 <create>
    if(ip == 0){
8010555c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010555f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105561:	85 c0                	test   %eax,%eax
80105563:	75 99                	jne    801054fe <sys_open+0x6e>
      end_op();
80105565:	e8 46 da ff ff       	call   80102fb0 <end_op>
      return -1;
8010556a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010556f:	eb 40                	jmp    801055b1 <sys_open+0x121>
80105571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105578:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010557b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010557f:	56                   	push   %esi
80105580:	e8 eb c2 ff ff       	call   80101870 <iunlock>
  end_op();
80105585:	e8 26 da ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
8010558a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105590:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105593:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105596:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105599:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010559b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055a2:	f7 d0                	not    %eax
801055a4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055aa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055ad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b4:	89 d8                	mov    %ebx,%eax
801055b6:	5b                   	pop    %ebx
801055b7:	5e                   	pop    %esi
801055b8:	5f                   	pop    %edi
801055b9:	5d                   	pop    %ebp
801055ba:	c3                   	ret    
801055bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055bf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801055c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055c3:	85 c9                	test   %ecx,%ecx
801055c5:	0f 84 33 ff ff ff    	je     801054fe <sys_open+0x6e>
801055cb:	e9 5c ff ff ff       	jmp    8010552c <sys_open+0x9c>

801055d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055d6:	e8 65 d9 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055db:	83 ec 08             	sub    $0x8,%esp
801055de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055e1:	50                   	push   %eax
801055e2:	6a 00                	push   $0x0
801055e4:	e8 97 f6 ff ff       	call   80104c80 <argstr>
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	85 c0                	test   %eax,%eax
801055ee:	78 30                	js     80105620 <sys_mkdir+0x50>
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f6:	31 c9                	xor    %ecx,%ecx
801055f8:	ba 01 00 00 00       	mov    $0x1,%edx
801055fd:	6a 00                	push   $0x0
801055ff:	e8 6c f7 ff ff       	call   80104d70 <create>
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	85 c0                	test   %eax,%eax
80105609:	74 15                	je     80105620 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010560b:	83 ec 0c             	sub    $0xc,%esp
8010560e:	50                   	push   %eax
8010560f:	e8 0c c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105614:	e8 97 d9 ff ff       	call   80102fb0 <end_op>
  return 0;
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	31 c0                	xor    %eax,%eax
}
8010561e:	c9                   	leave  
8010561f:	c3                   	ret    
    end_op();
80105620:	e8 8b d9 ff ff       	call   80102fb0 <end_op>
    return -1;
80105625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010562a:	c9                   	leave  
8010562b:	c3                   	ret    
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_mknod>:

int
sys_mknod(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105636:	e8 05 d9 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010563b:	83 ec 08             	sub    $0x8,%esp
8010563e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105641:	50                   	push   %eax
80105642:	6a 00                	push   $0x0
80105644:	e8 37 f6 ff ff       	call   80104c80 <argstr>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	85 c0                	test   %eax,%eax
8010564e:	78 60                	js     801056b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105650:	83 ec 08             	sub    $0x8,%esp
80105653:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105656:	50                   	push   %eax
80105657:	6a 01                	push   $0x1
80105659:	e8 62 f5 ff ff       	call   80104bc0 <argint>
  if((argstr(0, &path)) < 0 ||
8010565e:	83 c4 10             	add    $0x10,%esp
80105661:	85 c0                	test   %eax,%eax
80105663:	78 4b                	js     801056b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105665:	83 ec 08             	sub    $0x8,%esp
80105668:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566b:	50                   	push   %eax
8010566c:	6a 02                	push   $0x2
8010566e:	e8 4d f5 ff ff       	call   80104bc0 <argint>
     argint(1, &major) < 0 ||
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	78 36                	js     801056b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010567a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010567e:	83 ec 0c             	sub    $0xc,%esp
80105681:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105685:	ba 03 00 00 00       	mov    $0x3,%edx
8010568a:	50                   	push   %eax
8010568b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010568e:	e8 dd f6 ff ff       	call   80104d70 <create>
     argint(2, &minor) < 0 ||
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	74 16                	je     801056b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010569a:	83 ec 0c             	sub    $0xc,%esp
8010569d:	50                   	push   %eax
8010569e:	e8 7d c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
801056a3:	e8 08 d9 ff ff       	call   80102fb0 <end_op>
  return 0;
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	31 c0                	xor    %eax,%eax
}
801056ad:	c9                   	leave  
801056ae:	c3                   	ret    
801056af:	90                   	nop
    end_op();
801056b0:	e8 fb d8 ff ff       	call   80102fb0 <end_op>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ba:	c9                   	leave  
801056bb:	c3                   	ret    
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_chdir>:

int
sys_chdir(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	56                   	push   %esi
801056c4:	53                   	push   %ebx
801056c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056c8:	e8 a3 e4 ff ff       	call   80103b70 <myproc>
801056cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056cf:	e8 6c d8 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056d4:	83 ec 08             	sub    $0x8,%esp
801056d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056da:	50                   	push   %eax
801056db:	6a 00                	push   $0x0
801056dd:	e8 9e f5 ff ff       	call   80104c80 <argstr>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	78 77                	js     80105760 <sys_chdir+0xa0>
801056e9:	83 ec 0c             	sub    $0xc,%esp
801056ec:	ff 75 f4             	push   -0xc(%ebp)
801056ef:	e8 bc c9 ff ff       	call   801020b0 <namei>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	89 c3                	mov    %eax,%ebx
801056f9:	85 c0                	test   %eax,%eax
801056fb:	74 63                	je     80105760 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056fd:	83 ec 0c             	sub    $0xc,%esp
80105700:	50                   	push   %eax
80105701:	e8 8a c0 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010570e:	75 30                	jne    80105740 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	53                   	push   %ebx
80105714:	e8 57 c1 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
80105719:	58                   	pop    %eax
8010571a:	ff 76 6c             	push   0x6c(%esi)
8010571d:	e8 9e c1 ff ff       	call   801018c0 <iput>
  end_op();
80105722:	e8 89 d8 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105727:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	31 c0                	xor    %eax,%eax
}
8010572f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105732:	5b                   	pop    %ebx
80105733:	5e                   	pop    %esi
80105734:	5d                   	pop    %ebp
80105735:	c3                   	ret    
80105736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	53                   	push   %ebx
80105744:	e8 d7 c2 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105749:	e8 62 d8 ff ff       	call   80102fb0 <end_op>
    return -1;
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105756:	eb d7                	jmp    8010572f <sys_chdir+0x6f>
80105758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575f:	90                   	nop
    end_op();
80105760:	e8 4b d8 ff ff       	call   80102fb0 <end_op>
    return -1;
80105765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576a:	eb c3                	jmp    8010572f <sys_chdir+0x6f>
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_exec>:

int
sys_exec(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105775:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010577b:	53                   	push   %ebx
8010577c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105782:	50                   	push   %eax
80105783:	6a 00                	push   $0x0
80105785:	e8 f6 f4 ff ff       	call   80104c80 <argstr>
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	85 c0                	test   %eax,%eax
8010578f:	0f 88 87 00 00 00    	js     8010581c <sys_exec+0xac>
80105795:	83 ec 08             	sub    $0x8,%esp
80105798:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010579e:	50                   	push   %eax
8010579f:	6a 01                	push   $0x1
801057a1:	e8 1a f4 ff ff       	call   80104bc0 <argint>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	78 6f                	js     8010581c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057ad:	83 ec 04             	sub    $0x4,%esp
801057b0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801057b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057b8:	68 80 00 00 00       	push   $0x80
801057bd:	6a 00                	push   $0x0
801057bf:	56                   	push   %esi
801057c0:	e8 3b f1 ff ff       	call   80104900 <memset>
801057c5:	83 c4 10             	add    $0x10,%esp
801057c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057cf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057d0:	83 ec 08             	sub    $0x8,%esp
801057d3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057d9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057e0:	50                   	push   %eax
801057e1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057e7:	01 f8                	add    %edi,%eax
801057e9:	50                   	push   %eax
801057ea:	e8 41 f3 ff ff       	call   80104b30 <fetchint>
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	85 c0                	test   %eax,%eax
801057f4:	78 26                	js     8010581c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057f6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057fc:	85 c0                	test   %eax,%eax
801057fe:	74 30                	je     80105830 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105800:	83 ec 08             	sub    $0x8,%esp
80105803:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105806:	52                   	push   %edx
80105807:	50                   	push   %eax
80105808:	e8 63 f3 ff ff       	call   80104b70 <fetchstr>
8010580d:	83 c4 10             	add    $0x10,%esp
80105810:	85 c0                	test   %eax,%eax
80105812:	78 08                	js     8010581c <sys_exec+0xac>
  for(i=0;; i++){
80105814:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105817:	83 fb 20             	cmp    $0x20,%ebx
8010581a:	75 b4                	jne    801057d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010581c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010581f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105824:	5b                   	pop    %ebx
80105825:	5e                   	pop    %esi
80105826:	5f                   	pop    %edi
80105827:	5d                   	pop    %ebp
80105828:	c3                   	ret    
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105830:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105837:	00 00 00 00 
  return exec(path, argv);
8010583b:	83 ec 08             	sub    $0x8,%esp
8010583e:	56                   	push   %esi
8010583f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105845:	e8 66 b2 ff ff       	call   80100ab0 <exec>
8010584a:	83 c4 10             	add    $0x10,%esp
}
8010584d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105850:	5b                   	pop    %ebx
80105851:	5e                   	pop    %esi
80105852:	5f                   	pop    %edi
80105853:	5d                   	pop    %ebp
80105854:	c3                   	ret    
80105855:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_pipe>:

int
sys_pipe(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105865:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105868:	53                   	push   %ebx
80105869:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010586c:	6a 08                	push   $0x8
8010586e:	50                   	push   %eax
8010586f:	6a 00                	push   $0x0
80105871:	e8 9a f3 ff ff       	call   80104c10 <argptr>
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	85 c0                	test   %eax,%eax
8010587b:	78 4a                	js     801058c7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010587d:	83 ec 08             	sub    $0x8,%esp
80105880:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105883:	50                   	push   %eax
80105884:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105887:	50                   	push   %eax
80105888:	e8 a3 dd ff ff       	call   80103630 <pipealloc>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	78 33                	js     801058c7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105894:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105897:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105899:	e8 d2 e2 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010589e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058a0:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
801058a4:	85 f6                	test   %esi,%esi
801058a6:	74 28                	je     801058d0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058a8:	83 c3 01             	add    $0x1,%ebx
801058ab:	83 fb 10             	cmp    $0x10,%ebx
801058ae:	75 f0                	jne    801058a0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	ff 75 e0             	push   -0x20(%ebp)
801058b6:	e8 45 b6 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
801058bb:	58                   	pop    %eax
801058bc:	ff 75 e4             	push   -0x1c(%ebp)
801058bf:	e8 3c b6 ff ff       	call   80100f00 <fileclose>
    return -1;
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cc:	eb 53                	jmp    80105921 <sys_pipe+0xc1>
801058ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058d0:	8d 73 08             	lea    0x8(%ebx),%esi
801058d3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058da:	e8 91 e2 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058df:	31 d2                	xor    %edx,%edx
801058e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058e8:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
801058ec:	85 c9                	test   %ecx,%ecx
801058ee:	74 20                	je     80105910 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801058f0:	83 c2 01             	add    $0x1,%edx
801058f3:	83 fa 10             	cmp    $0x10,%edx
801058f6:	75 f0                	jne    801058e8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801058f8:	e8 73 e2 ff ff       	call   80103b70 <myproc>
801058fd:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105904:	00 
80105905:	eb a9                	jmp    801058b0 <sys_pipe+0x50>
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105910:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105914:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105917:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105919:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010591c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010591f:	31 c0                	xor    %eax,%eax
}
80105921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
80105928:	c3                   	ret    
80105929:	66 90                	xchg   %ax,%ax
8010592b:	66 90                	xchg   %ax,%ax
8010592d:	66 90                	xchg   %ax,%ax
8010592f:	90                   	nop

80105930 <sys_fork>:
int GLOBAL_THP;

int
sys_fork(void)
{
  return fork();
80105930:	e9 6b e4 ff ff       	jmp    80103da0 <fork>
80105935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_exit>:
}

int
sys_exit(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 08             	sub    $0x8,%esp
  exit();
80105946:	e8 e5 e6 ff ff       	call   80104030 <exit>
  return 0;  // not reached
}
8010594b:	31 c0                	xor    %eax,%eax
8010594d:	c9                   	leave  
8010594e:	c3                   	ret    
8010594f:	90                   	nop

80105950 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105950:	e9 0b e8 ff ff       	jmp    80104160 <wait>
80105955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_kill>:
}

int
sys_kill(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105966:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105969:	50                   	push   %eax
8010596a:	6a 00                	push   $0x0
8010596c:	e8 4f f2 ff ff       	call   80104bc0 <argint>
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	85 c0                	test   %eax,%eax
80105976:	78 18                	js     80105990 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	ff 75 f4             	push   -0xc(%ebp)
8010597e:	e8 7d ea ff ff       	call   80104400 <kill>
80105983:	83 c4 10             	add    $0x10,%esp
}
80105986:	c9                   	leave  
80105987:	c3                   	ret    
80105988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop
80105990:	c9                   	leave  
    return -1;
80105991:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105996:	c3                   	ret    
80105997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <sys_getpid>:

int
sys_getpid(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059a6:	e8 c5 e1 ff ff       	call   80103b70 <myproc>
801059ab:	8b 40 14             	mov    0x14(%eax),%eax
}
801059ae:	c9                   	leave  
801059af:	c3                   	ret    

801059b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ba:	50                   	push   %eax
801059bb:	6a 00                	push   $0x0
801059bd:	e8 fe f1 ff ff       	call   80104bc0 <argint>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	85 c0                	test   %eax,%eax
801059c7:	78 27                	js     801059f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059c9:	e8 a2 e1 ff ff       	call   80103b70 <myproc>
  if(growproc(n) < 0)
801059ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059d3:	ff 75 f4             	push   -0xc(%ebp)
801059d6:	e8 b5 e2 ff ff       	call   80103c90 <growproc>
801059db:	83 c4 10             	add    $0x10,%esp
801059de:	85 c0                	test   %eax,%eax
801059e0:	78 0e                	js     801059f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059e2:	89 d8                	mov    %ebx,%eax
801059e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059e7:	c9                   	leave  
801059e8:	c3                   	ret    
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059f5:	eb eb                	jmp    801059e2 <sys_sbrk+0x32>
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <sys_shugebrk>:
// TODO: implement this
// part 2
// TODO: add growhugeproc
int
sys_shugebrk(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
  int addr;
  int n;
  
  if(argint(0, &n) < 0)
80105a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a0a:	50                   	push   %eax
80105a0b:	6a 00                	push   $0x0
80105a0d:	e8 ae f1 ff ff       	call   80104bc0 <argint>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	85 c0                	test   %eax,%eax
80105a17:	78 27                	js     80105a40 <sys_shugebrk+0x40>
    return -1;
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
80105a19:	e8 52 e1 ff ff       	call   80103b70 <myproc>
  if(growhugeproc(n) < 0)
80105a1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
80105a21:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growhugeproc(n) < 0)
80105a24:	ff 75 f4             	push   -0xc(%ebp)
  addr = myproc()->hugesz + HUGE_VA_OFFSET;
80105a27:	81 c3 00 00 00 1e    	add    $0x1e000000,%ebx
  if(growhugeproc(n) < 0)
80105a2d:	e8 de e2 ff ff       	call   80103d10 <growhugeproc>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	85 c0                	test   %eax,%eax
80105a37:	78 07                	js     80105a40 <sys_shugebrk+0x40>
    return -1;
  return addr;
}
80105a39:	89 d8                	mov    %ebx,%eax
80105a3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a3e:	c9                   	leave  
80105a3f:	c3                   	ret    
    return -1;
80105a40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a45:	eb f2                	jmp    80105a39 <sys_shugebrk+0x39>
80105a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4e:	66 90                	xchg   %ax,%ax

80105a50 <sys_setthp>:

int sys_setthp(void){
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 20             	sub    $0x20,%esp
  int input;
  if(argint(0, &input) == -1){
80105a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a59:	50                   	push   %eax
80105a5a:	6a 00                	push   $0x0
80105a5c:	e8 5f f1 ff ff       	call   80104bc0 <argint>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	83 f8 ff             	cmp    $0xffffffff,%eax
80105a67:	74 0a                	je     80105a73 <sys_setthp+0x23>
    return -1;
  }
  GLOBAL_THP = input;
80105a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a6c:	a3 b8 4d 11 80       	mov    %eax,0x80114db8
  return 0;
80105a71:	31 c0                	xor    %eax,%eax
}
80105a73:	c9                   	leave  
80105a74:	c3                   	ret    
80105a75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_getthp>:

int sys_getthp(void){
  return GLOBAL_THP;
}
80105a80:	a1 b8 4d 11 80       	mov    0x80114db8,%eax
80105a85:	c3                   	ret    
80105a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8d:	8d 76 00             	lea    0x0(%esi),%esi

80105a90 <sys_sleep>:

int
sys_sleep(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a9a:	50                   	push   %eax
80105a9b:	6a 00                	push   $0x0
80105a9d:	e8 1e f1 ff ff       	call   80104bc0 <argint>
80105aa2:	83 c4 10             	add    $0x10,%esp
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	0f 88 8a 00 00 00    	js     80105b37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105aad:	83 ec 0c             	sub    $0xc,%esp
80105ab0:	68 e0 4d 11 80       	push   $0x80114de0
80105ab5:	e8 86 ed ff ff       	call   80104840 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105abd:	8b 1d c0 4d 11 80    	mov    0x80114dc0,%ebx
  while(ticks - ticks0 < n){
80105ac3:	83 c4 10             	add    $0x10,%esp
80105ac6:	85 d2                	test   %edx,%edx
80105ac8:	75 27                	jne    80105af1 <sys_sleep+0x61>
80105aca:	eb 54                	jmp    80105b20 <sys_sleep+0x90>
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	68 e0 4d 11 80       	push   $0x80114de0
80105ad8:	68 c0 4d 11 80       	push   $0x80114dc0
80105add:	e8 fe e7 ff ff       	call   801042e0 <sleep>
  while(ticks - ticks0 < n){
80105ae2:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	29 d8                	sub    %ebx,%eax
80105aec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105aef:	73 2f                	jae    80105b20 <sys_sleep+0x90>
    if(myproc()->killed){
80105af1:	e8 7a e0 ff ff       	call   80103b70 <myproc>
80105af6:	8b 40 28             	mov    0x28(%eax),%eax
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 d3                	je     80105ad0 <sys_sleep+0x40>
      release(&tickslock);
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	68 e0 4d 11 80       	push   $0x80114de0
80105b05:	e8 d6 ec ff ff       	call   801047e0 <release>
  }
  release(&tickslock);
  return 0;
}
80105b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
80105b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	68 e0 4d 11 80       	push   $0x80114de0
80105b28:	e8 b3 ec ff ff       	call   801047e0 <release>
  return 0;
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	31 c0                	xor    %eax,%eax
}
80105b32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
    return -1;
80105b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3c:	eb f4                	jmp    80105b32 <sys_sleep+0xa2>
80105b3e:	66 90                	xchg   %ax,%ax

80105b40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	53                   	push   %ebx
80105b44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b47:	68 e0 4d 11 80       	push   $0x80114de0
80105b4c:	e8 ef ec ff ff       	call   80104840 <acquire>
  xticks = ticks;
80105b51:	8b 1d c0 4d 11 80    	mov    0x80114dc0,%ebx
  release(&tickslock);
80105b57:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105b5e:	e8 7d ec ff ff       	call   801047e0 <release>
  return xticks;
}
80105b63:	89 d8                	mov    %ebx,%eax
80105b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b68:	c9                   	leave  
80105b69:	c3                   	ret    
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b70 <sys_printhugepde>:

// System calls for debugging huge page allocations/mappings
int
sys_printhugepde()
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
  pde_t *pgdir = myproc()->pgdir;
  int pid = myproc()->pid;
  int i = 0;
  for (i = 0; i < 1024; i++) {
80105b76:	31 db                	xor    %ebx,%ebx
{
80105b78:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pgdir = myproc()->pgdir;
80105b7b:	e8 f0 df ff ff       	call   80103b70 <myproc>
80105b80:	8b 78 08             	mov    0x8(%eax),%edi
  int pid = myproc()->pid;
80105b83:	e8 e8 df ff ff       	call   80103b70 <myproc>
80105b88:	8b 70 14             	mov    0x14(%eax),%esi
  for (i = 0; i < 1024; i++) {
80105b8b:	eb 0e                	jmp    80105b9b <sys_printhugepde+0x2b>
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105b99:	74 2e                	je     80105bc9 <sys_printhugepde+0x59>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P))
80105b9b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80105b9e:	89 c2                	mov    %eax,%edx
80105ba0:	81 e2 85 00 00 00    	and    $0x85,%edx
80105ba6:	81 fa 85 00 00 00    	cmp    $0x85,%edx
80105bac:	75 e2                	jne    80105b90 <sys_printhugepde+0x20>
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105bae:	50                   	push   %eax
80105baf:	53                   	push   %ebx
  for (i = 0; i < 1024; i++) {
80105bb0:	83 c3 01             	add    $0x1,%ebx
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105bb3:	56                   	push   %esi
80105bb4:	68 4d 81 10 80       	push   $0x8010814d
80105bb9:	e8 e2 aa ff ff       	call   801006a0 <cprintf>
80105bbe:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 1024; i++) {
80105bc1:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105bc7:	75 d2                	jne    80105b9b <sys_printhugepde+0x2b>
  }
  return 0;
}
80105bc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bcc:	31 c0                	xor    %eax,%eax
80105bce:	5b                   	pop    %ebx
80105bcf:	5e                   	pop    %esi
80105bd0:	5f                   	pop    %edi
80105bd1:	5d                   	pop    %ebp
80105bd2:	c3                   	ret    
80105bd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105be0 <sys_procpgdirinfo>:

int
sys_procpgdirinfo()
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
  int *buf;
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105be5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105be8:	53                   	push   %ebx
80105be9:	83 ec 30             	sub    $0x30,%esp
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105bec:	6a 08                	push   $0x8
80105bee:	50                   	push   %eax
80105bef:	6a 00                	push   $0x0
80105bf1:	e8 1a f0 ff ff       	call   80104c10 <argptr>
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	0f 88 90 00 00 00    	js     80105c91 <sys_procpgdirinfo+0xb1>
    return -1;
  pde_t *pgdir = myproc()->pgdir;
80105c01:	e8 6a df ff ff       	call   80103b70 <myproc>
  int base_cnt = 0; // base page count
  int huge_cnt = 0; // huge page count
80105c06:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  int base_cnt = 0; // base page count
80105c0d:	31 c9                	xor    %ecx,%ecx
80105c0f:	8b 70 08             	mov    0x8(%eax),%esi
80105c12:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105c18:	eb 12                	jmp    80105c2c <sys_procpgdirinfo+0x4c>
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i = 0;
  int j = 0;
  for (i = 0; i < 1024; i++) {
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
      ++huge_cnt;
    if((pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) && ((pgdir[i] & PTE_PS) == 0) /*Only PTE_P and PTE_U should be set for base pages*/) {
80105c20:	83 f8 05             	cmp    $0x5,%eax
80105c23:	74 3a                	je     80105c5f <sys_procpgdirinfo+0x7f>
  for (i = 0; i < 1024; i++) {
80105c25:	83 c6 04             	add    $0x4,%esi
80105c28:	39 f7                	cmp    %esi,%edi
80105c2a:	74 1b                	je     80105c47 <sys_procpgdirinfo+0x67>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
80105c2c:	8b 1e                	mov    (%esi),%ebx
80105c2e:	89 d8                	mov    %ebx,%eax
80105c30:	25 85 00 00 00       	and    $0x85,%eax
80105c35:	3d 85 00 00 00       	cmp    $0x85,%eax
80105c3a:	75 e4                	jne    80105c20 <sys_procpgdirinfo+0x40>
  for (i = 0; i < 1024; i++) {
80105c3c:	83 c6 04             	add    $0x4,%esi
      ++huge_cnt;
80105c3f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  for (i = 0; i < 1024; i++) {
80105c43:	39 f7                	cmp    %esi,%edi
80105c45:	75 e5                	jne    80105c2c <sys_procpgdirinfo+0x4c>
          ++base_cnt;
        }
      }
    }
  }
  buf[0] = base_cnt; // base page count
80105c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  buf[1] = huge_cnt; // huge page count
80105c4a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  buf[0] = base_cnt; // base page count
80105c4d:	89 08                	mov    %ecx,(%eax)
  buf[1] = huge_cnt; // huge page count
80105c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c52:	89 78 04             	mov    %edi,0x4(%eax)
  return 0;
80105c55:	31 c0                	xor    %eax,%eax
}
80105c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c5a:	5b                   	pop    %ebx
80105c5b:	5e                   	pop    %esi
80105c5c:	5f                   	pop    %edi
80105c5d:	5d                   	pop    %ebp
80105c5e:	c3                   	ret    
      uint* pgtab = (uint*)P2V(PTE_ADDR(pgdir[i]));
80105c5f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105c65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
      for (j = 0; j < 1024; j++) {
80105c6b:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
80105c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((pgtab[j] & PTE_U) && (pgtab[j] & PTE_P)) {
80105c78:	8b 10                	mov    (%eax),%edx
80105c7a:	83 e2 05             	and    $0x5,%edx
          ++base_cnt;
80105c7d:	83 fa 05             	cmp    $0x5,%edx
80105c80:	0f 94 c2             	sete   %dl
      for (j = 0; j < 1024; j++) {
80105c83:	83 c0 04             	add    $0x4,%eax
          ++base_cnt;
80105c86:	0f b6 d2             	movzbl %dl,%edx
80105c89:	01 d1                	add    %edx,%ecx
      for (j = 0; j < 1024; j++) {
80105c8b:	39 d8                	cmp    %ebx,%eax
80105c8d:	75 e9                	jne    80105c78 <sys_procpgdirinfo+0x98>
80105c8f:	eb 94                	jmp    80105c25 <sys_procpgdirinfo+0x45>
    return -1;
80105c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c96:	eb bf                	jmp    80105c57 <sys_procpgdirinfo+0x77>

80105c98 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c98:	1e                   	push   %ds
  pushl %es
80105c99:	06                   	push   %es
  pushl %fs
80105c9a:	0f a0                	push   %fs
  pushl %gs
80105c9c:	0f a8                	push   %gs
  pushal
80105c9e:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c9f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ca3:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ca5:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ca7:	54                   	push   %esp
  call trap
80105ca8:	e8 c3 00 00 00       	call   80105d70 <trap>
  addl $4, %esp
80105cad:	83 c4 04             	add    $0x4,%esp

80105cb0 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105cb0:	61                   	popa   
  popl %gs
80105cb1:	0f a9                	pop    %gs
  popl %fs
80105cb3:	0f a1                	pop    %fs
  popl %es
80105cb5:	07                   	pop    %es
  popl %ds
80105cb6:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105cb7:	83 c4 08             	add    $0x8,%esp
  iret
80105cba:	cf                   	iret   
80105cbb:	66 90                	xchg   %ax,%ax
80105cbd:	66 90                	xchg   %ax,%ax
80105cbf:	90                   	nop

80105cc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105cc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105cc1:	31 c0                	xor    %eax,%eax
{
80105cc3:	89 e5                	mov    %esp,%ebp
80105cc5:	83 ec 08             	sub    $0x8,%esp
80105cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ccf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105cd0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105cd7:	c7 04 c5 22 4e 11 80 	movl   $0x8e000008,-0x7feeb1de(,%eax,8)
80105cde:	08 00 00 8e 
80105ce2:	66 89 14 c5 20 4e 11 	mov    %dx,-0x7feeb1e0(,%eax,8)
80105ce9:	80 
80105cea:	c1 ea 10             	shr    $0x10,%edx
80105ced:	66 89 14 c5 26 4e 11 	mov    %dx,-0x7feeb1da(,%eax,8)
80105cf4:	80 
  for(i = 0; i < 256; i++)
80105cf5:	83 c0 01             	add    $0x1,%eax
80105cf8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105cfd:	75 d1                	jne    80105cd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105cff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d02:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d07:	c7 05 22 50 11 80 08 	movl   $0xef000008,0x80115022
80105d0e:	00 00 ef 
  initlock(&tickslock, "time");
80105d11:	68 66 81 10 80       	push   $0x80108166
80105d16:	68 e0 4d 11 80       	push   $0x80114de0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d1b:	66 a3 20 50 11 80    	mov    %ax,0x80115020
80105d21:	c1 e8 10             	shr    $0x10,%eax
80105d24:	66 a3 26 50 11 80    	mov    %ax,0x80115026
  initlock(&tickslock, "time");
80105d2a:	e8 41 e9 ff ff       	call   80104670 <initlock>
}
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	c9                   	leave  
80105d33:	c3                   	ret    
80105d34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d3f:	90                   	nop

80105d40 <idtinit>:

void
idtinit(void)
{
80105d40:	55                   	push   %ebp
  pd[0] = size-1;
80105d41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d46:	89 e5                	mov    %esp,%ebp
80105d48:	83 ec 10             	sub    $0x10,%esp
80105d4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d4f:	b8 20 4e 11 80       	mov    $0x80114e20,%eax
80105d54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d58:	c1 e8 10             	shr    $0x10,%eax
80105d5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
80105d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
80105d75:	53                   	push   %ebx
80105d76:	83 ec 1c             	sub    $0x1c,%esp
80105d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d7c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d7f:	83 f8 40             	cmp    $0x40,%eax
80105d82:	0f 84 68 01 00 00    	je     80105ef0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d88:	83 e8 20             	sub    $0x20,%eax
80105d8b:	83 f8 1f             	cmp    $0x1f,%eax
80105d8e:	0f 87 8c 00 00 00    	ja     80105e20 <trap+0xb0>
80105d94:	ff 24 85 0c 82 10 80 	jmp    *-0x7fef7df4(,%eax,4)
80105d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105da0:	e8 ab c4 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105da5:	e8 46 cd ff ff       	call   80102af0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105daa:	e8 c1 dd ff ff       	call   80103b70 <myproc>
80105daf:	85 c0                	test   %eax,%eax
80105db1:	74 1d                	je     80105dd0 <trap+0x60>
80105db3:	e8 b8 dd ff ff       	call   80103b70 <myproc>
80105db8:	8b 50 28             	mov    0x28(%eax),%edx
80105dbb:	85 d2                	test   %edx,%edx
80105dbd:	74 11                	je     80105dd0 <trap+0x60>
80105dbf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105dc3:	83 e0 03             	and    $0x3,%eax
80105dc6:	66 83 f8 03          	cmp    $0x3,%ax
80105dca:	0f 84 e8 01 00 00    	je     80105fb8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105dd0:	e8 9b dd ff ff       	call   80103b70 <myproc>
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	74 0f                	je     80105de8 <trap+0x78>
80105dd9:	e8 92 dd ff ff       	call   80103b70 <myproc>
80105dde:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105de2:	0f 84 b8 00 00 00    	je     80105ea0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105de8:	e8 83 dd ff ff       	call   80103b70 <myproc>
80105ded:	85 c0                	test   %eax,%eax
80105def:	74 1d                	je     80105e0e <trap+0x9e>
80105df1:	e8 7a dd ff ff       	call   80103b70 <myproc>
80105df6:	8b 40 28             	mov    0x28(%eax),%eax
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	74 11                	je     80105e0e <trap+0x9e>
80105dfd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e01:	83 e0 03             	and    $0x3,%eax
80105e04:	66 83 f8 03          	cmp    $0x3,%ax
80105e08:	0f 84 0f 01 00 00    	je     80105f1d <trap+0x1ad>
    exit();
}
80105e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e11:	5b                   	pop    %ebx
80105e12:	5e                   	pop    %esi
80105e13:	5f                   	pop    %edi
80105e14:	5d                   	pop    %ebp
80105e15:	c3                   	ret    
80105e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e20:	e8 4b dd ff ff       	call   80103b70 <myproc>
80105e25:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e28:	85 c0                	test   %eax,%eax
80105e2a:	0f 84 a2 01 00 00    	je     80105fd2 <trap+0x262>
80105e30:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e34:	0f 84 98 01 00 00    	je     80105fd2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e3a:	0f 20 d1             	mov    %cr2,%ecx
80105e3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e40:	e8 0b dd ff ff       	call   80103b50 <cpuid>
80105e45:	8b 73 30             	mov    0x30(%ebx),%esi
80105e48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e4b:	8b 43 34             	mov    0x34(%ebx),%eax
80105e4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e51:	e8 1a dd ff ff       	call   80103b70 <myproc>
80105e56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e59:	e8 12 dd ff ff       	call   80103b70 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e64:	51                   	push   %ecx
80105e65:	57                   	push   %edi
80105e66:	52                   	push   %edx
80105e67:	ff 75 e4             	push   -0x1c(%ebp)
80105e6a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e6b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e6e:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e71:	56                   	push   %esi
80105e72:	ff 70 14             	push   0x14(%eax)
80105e75:	68 c8 81 10 80       	push   $0x801081c8
80105e7a:	e8 21 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105e7f:	83 c4 20             	add    $0x20,%esp
80105e82:	e8 e9 dc ff ff       	call   80103b70 <myproc>
80105e87:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e8e:	e8 dd dc ff ff       	call   80103b70 <myproc>
80105e93:	85 c0                	test   %eax,%eax
80105e95:	0f 85 18 ff ff ff    	jne    80105db3 <trap+0x43>
80105e9b:	e9 30 ff ff ff       	jmp    80105dd0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105ea0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ea4:	0f 85 3e ff ff ff    	jne    80105de8 <trap+0x78>
    yield();
80105eaa:	e8 e1 e3 ff ff       	call   80104290 <yield>
80105eaf:	e9 34 ff ff ff       	jmp    80105de8 <trap+0x78>
80105eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105eb8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ebb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105ebf:	e8 8c dc ff ff       	call   80103b50 <cpuid>
80105ec4:	57                   	push   %edi
80105ec5:	56                   	push   %esi
80105ec6:	50                   	push   %eax
80105ec7:	68 70 81 10 80       	push   $0x80108170
80105ecc:	e8 cf a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105ed1:	e8 1a cc ff ff       	call   80102af0 <lapiceoi>
    break;
80105ed6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ed9:	e8 92 dc ff ff       	call   80103b70 <myproc>
80105ede:	85 c0                	test   %eax,%eax
80105ee0:	0f 85 cd fe ff ff    	jne    80105db3 <trap+0x43>
80105ee6:	e9 e5 fe ff ff       	jmp    80105dd0 <trap+0x60>
80105eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eef:	90                   	nop
    if(myproc()->killed)
80105ef0:	e8 7b dc ff ff       	call   80103b70 <myproc>
80105ef5:	8b 70 28             	mov    0x28(%eax),%esi
80105ef8:	85 f6                	test   %esi,%esi
80105efa:	0f 85 c8 00 00 00    	jne    80105fc8 <trap+0x258>
    myproc()->tf = tf;
80105f00:	e8 6b dc ff ff       	call   80103b70 <myproc>
80105f05:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105f08:	e8 f3 ed ff ff       	call   80104d00 <syscall>
    if(myproc()->killed)
80105f0d:	e8 5e dc ff ff       	call   80103b70 <myproc>
80105f12:	8b 48 28             	mov    0x28(%eax),%ecx
80105f15:	85 c9                	test   %ecx,%ecx
80105f17:	0f 84 f1 fe ff ff    	je     80105e0e <trap+0x9e>
}
80105f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f20:	5b                   	pop    %ebx
80105f21:	5e                   	pop    %esi
80105f22:	5f                   	pop    %edi
80105f23:	5d                   	pop    %ebp
      exit();
80105f24:	e9 07 e1 ff ff       	jmp    80104030 <exit>
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f30:	e8 3b 02 00 00       	call   80106170 <uartintr>
    lapiceoi();
80105f35:	e8 b6 cb ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f3a:	e8 31 dc ff ff       	call   80103b70 <myproc>
80105f3f:	85 c0                	test   %eax,%eax
80105f41:	0f 85 6c fe ff ff    	jne    80105db3 <trap+0x43>
80105f47:	e9 84 fe ff ff       	jmp    80105dd0 <trap+0x60>
80105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105f50:	e8 5b ca ff ff       	call   801029b0 <kbdintr>
    lapiceoi();
80105f55:	e8 96 cb ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f5a:	e8 11 dc ff ff       	call   80103b70 <myproc>
80105f5f:	85 c0                	test   %eax,%eax
80105f61:	0f 85 4c fe ff ff    	jne    80105db3 <trap+0x43>
80105f67:	e9 64 fe ff ff       	jmp    80105dd0 <trap+0x60>
80105f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105f70:	e8 db db ff ff       	call   80103b50 <cpuid>
80105f75:	85 c0                	test   %eax,%eax
80105f77:	0f 85 28 fe ff ff    	jne    80105da5 <trap+0x35>
      acquire(&tickslock);
80105f7d:	83 ec 0c             	sub    $0xc,%esp
80105f80:	68 e0 4d 11 80       	push   $0x80114de0
80105f85:	e8 b6 e8 ff ff       	call   80104840 <acquire>
      wakeup(&ticks);
80105f8a:	c7 04 24 c0 4d 11 80 	movl   $0x80114dc0,(%esp)
      ticks++;
80105f91:	83 05 c0 4d 11 80 01 	addl   $0x1,0x80114dc0
      wakeup(&ticks);
80105f98:	e8 03 e4 ff ff       	call   801043a0 <wakeup>
      release(&tickslock);
80105f9d:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105fa4:	e8 37 e8 ff ff       	call   801047e0 <release>
80105fa9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105fac:	e9 f4 fd ff ff       	jmp    80105da5 <trap+0x35>
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105fb8:	e8 73 e0 ff ff       	call   80104030 <exit>
80105fbd:	e9 0e fe ff ff       	jmp    80105dd0 <trap+0x60>
80105fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105fc8:	e8 63 e0 ff ff       	call   80104030 <exit>
80105fcd:	e9 2e ff ff ff       	jmp    80105f00 <trap+0x190>
80105fd2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fd5:	e8 76 db ff ff       	call   80103b50 <cpuid>
80105fda:	83 ec 0c             	sub    $0xc,%esp
80105fdd:	56                   	push   %esi
80105fde:	57                   	push   %edi
80105fdf:	50                   	push   %eax
80105fe0:	ff 73 30             	push   0x30(%ebx)
80105fe3:	68 94 81 10 80       	push   $0x80108194
80105fe8:	e8 b3 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105fed:	83 c4 14             	add    $0x14,%esp
80105ff0:	68 6b 81 10 80       	push   $0x8010816b
80105ff5:	e8 86 a3 ff ff       	call   80100380 <panic>
80105ffa:	66 90                	xchg   %ax,%ax
80105ffc:	66 90                	xchg   %ax,%ax
80105ffe:	66 90                	xchg   %ax,%ax

80106000 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106000:	a1 20 56 11 80       	mov    0x80115620,%eax
80106005:	85 c0                	test   %eax,%eax
80106007:	74 17                	je     80106020 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106009:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010600e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010600f:	a8 01                	test   $0x1,%al
80106011:	74 0d                	je     80106020 <uartgetc+0x20>
80106013:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106018:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106019:	0f b6 c0             	movzbl %al,%eax
8010601c:	c3                   	ret    
8010601d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106025:	c3                   	ret    
80106026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602d:	8d 76 00             	lea    0x0(%esi),%esi

80106030 <uartinit>:
{
80106030:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106031:	31 c9                	xor    %ecx,%ecx
80106033:	89 c8                	mov    %ecx,%eax
80106035:	89 e5                	mov    %esp,%ebp
80106037:	57                   	push   %edi
80106038:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010603d:	56                   	push   %esi
8010603e:	89 fa                	mov    %edi,%edx
80106040:	53                   	push   %ebx
80106041:	83 ec 1c             	sub    $0x1c,%esp
80106044:	ee                   	out    %al,(%dx)
80106045:	be fb 03 00 00       	mov    $0x3fb,%esi
8010604a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010604f:	89 f2                	mov    %esi,%edx
80106051:	ee                   	out    %al,(%dx)
80106052:	b8 0c 00 00 00       	mov    $0xc,%eax
80106057:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010605c:	ee                   	out    %al,(%dx)
8010605d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106062:	89 c8                	mov    %ecx,%eax
80106064:	89 da                	mov    %ebx,%edx
80106066:	ee                   	out    %al,(%dx)
80106067:	b8 03 00 00 00       	mov    $0x3,%eax
8010606c:	89 f2                	mov    %esi,%edx
8010606e:	ee                   	out    %al,(%dx)
8010606f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106074:	89 c8                	mov    %ecx,%eax
80106076:	ee                   	out    %al,(%dx)
80106077:	b8 01 00 00 00       	mov    $0x1,%eax
8010607c:	89 da                	mov    %ebx,%edx
8010607e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010607f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106084:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106085:	3c ff                	cmp    $0xff,%al
80106087:	74 78                	je     80106101 <uartinit+0xd1>
  uart = 1;
80106089:	c7 05 20 56 11 80 01 	movl   $0x1,0x80115620
80106090:	00 00 00 
80106093:	89 fa                	mov    %edi,%edx
80106095:	ec                   	in     (%dx),%al
80106096:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010609b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010609c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010609f:	bf 8c 82 10 80       	mov    $0x8010828c,%edi
801060a4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801060a9:	6a 00                	push   $0x0
801060ab:	6a 04                	push   $0x4
801060ad:	e8 de c3 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801060b2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801060b6:	83 c4 10             	add    $0x10,%esp
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801060c0:	a1 20 56 11 80       	mov    0x80115620,%eax
801060c5:	bb 80 00 00 00       	mov    $0x80,%ebx
801060ca:	85 c0                	test   %eax,%eax
801060cc:	75 14                	jne    801060e2 <uartinit+0xb2>
801060ce:	eb 23                	jmp    801060f3 <uartinit+0xc3>
    microdelay(10);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	6a 0a                	push   $0xa
801060d5:	e8 36 ca ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060da:	83 c4 10             	add    $0x10,%esp
801060dd:	83 eb 01             	sub    $0x1,%ebx
801060e0:	74 07                	je     801060e9 <uartinit+0xb9>
801060e2:	89 f2                	mov    %esi,%edx
801060e4:	ec                   	in     (%dx),%al
801060e5:	a8 20                	test   $0x20,%al
801060e7:	74 e7                	je     801060d0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060e9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801060ed:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060f2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801060f3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801060f7:	83 c7 01             	add    $0x1,%edi
801060fa:	88 45 e7             	mov    %al,-0x19(%ebp)
801060fd:	84 c0                	test   %al,%al
801060ff:	75 bf                	jne    801060c0 <uartinit+0x90>
}
80106101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106104:	5b                   	pop    %ebx
80106105:	5e                   	pop    %esi
80106106:	5f                   	pop    %edi
80106107:	5d                   	pop    %ebp
80106108:	c3                   	ret    
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106110 <uartputc>:
  if(!uart)
80106110:	a1 20 56 11 80       	mov    0x80115620,%eax
80106115:	85 c0                	test   %eax,%eax
80106117:	74 47                	je     80106160 <uartputc+0x50>
{
80106119:	55                   	push   %ebp
8010611a:	89 e5                	mov    %esp,%ebp
8010611c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010611d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106122:	53                   	push   %ebx
80106123:	bb 80 00 00 00       	mov    $0x80,%ebx
80106128:	eb 18                	jmp    80106142 <uartputc+0x32>
8010612a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106130:	83 ec 0c             	sub    $0xc,%esp
80106133:	6a 0a                	push   $0xa
80106135:	e8 d6 c9 ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010613a:	83 c4 10             	add    $0x10,%esp
8010613d:	83 eb 01             	sub    $0x1,%ebx
80106140:	74 07                	je     80106149 <uartputc+0x39>
80106142:	89 f2                	mov    %esi,%edx
80106144:	ec                   	in     (%dx),%al
80106145:	a8 20                	test   $0x20,%al
80106147:	74 e7                	je     80106130 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106149:	8b 45 08             	mov    0x8(%ebp),%eax
8010614c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106151:	ee                   	out    %al,(%dx)
}
80106152:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106155:	5b                   	pop    %ebx
80106156:	5e                   	pop    %esi
80106157:	5d                   	pop    %ebp
80106158:	c3                   	ret    
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106160:	c3                   	ret    
80106161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop

80106170 <uartintr>:

void
uartintr(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106176:	68 00 60 10 80       	push   $0x80106000
8010617b:	e8 00 a7 ff ff       	call   80100880 <consoleintr>
}
80106180:	83 c4 10             	add    $0x10,%esp
80106183:	c9                   	leave  
80106184:	c3                   	ret    

80106185 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $0
80106187:	6a 00                	push   $0x0
  jmp alltraps
80106189:	e9 0a fb ff ff       	jmp    80105c98 <alltraps>

8010618e <vector1>:
.globl vector1
vector1:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $1
80106190:	6a 01                	push   $0x1
  jmp alltraps
80106192:	e9 01 fb ff ff       	jmp    80105c98 <alltraps>

80106197 <vector2>:
.globl vector2
vector2:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $2
80106199:	6a 02                	push   $0x2
  jmp alltraps
8010619b:	e9 f8 fa ff ff       	jmp    80105c98 <alltraps>

801061a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $3
801061a2:	6a 03                	push   $0x3
  jmp alltraps
801061a4:	e9 ef fa ff ff       	jmp    80105c98 <alltraps>

801061a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $4
801061ab:	6a 04                	push   $0x4
  jmp alltraps
801061ad:	e9 e6 fa ff ff       	jmp    80105c98 <alltraps>

801061b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $5
801061b4:	6a 05                	push   $0x5
  jmp alltraps
801061b6:	e9 dd fa ff ff       	jmp    80105c98 <alltraps>

801061bb <vector6>:
.globl vector6
vector6:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $6
801061bd:	6a 06                	push   $0x6
  jmp alltraps
801061bf:	e9 d4 fa ff ff       	jmp    80105c98 <alltraps>

801061c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $7
801061c6:	6a 07                	push   $0x7
  jmp alltraps
801061c8:	e9 cb fa ff ff       	jmp    80105c98 <alltraps>

801061cd <vector8>:
.globl vector8
vector8:
  pushl $8
801061cd:	6a 08                	push   $0x8
  jmp alltraps
801061cf:	e9 c4 fa ff ff       	jmp    80105c98 <alltraps>

801061d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801061d4:	6a 00                	push   $0x0
  pushl $9
801061d6:	6a 09                	push   $0x9
  jmp alltraps
801061d8:	e9 bb fa ff ff       	jmp    80105c98 <alltraps>

801061dd <vector10>:
.globl vector10
vector10:
  pushl $10
801061dd:	6a 0a                	push   $0xa
  jmp alltraps
801061df:	e9 b4 fa ff ff       	jmp    80105c98 <alltraps>

801061e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061e4:	6a 0b                	push   $0xb
  jmp alltraps
801061e6:	e9 ad fa ff ff       	jmp    80105c98 <alltraps>

801061eb <vector12>:
.globl vector12
vector12:
  pushl $12
801061eb:	6a 0c                	push   $0xc
  jmp alltraps
801061ed:	e9 a6 fa ff ff       	jmp    80105c98 <alltraps>

801061f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061f2:	6a 0d                	push   $0xd
  jmp alltraps
801061f4:	e9 9f fa ff ff       	jmp    80105c98 <alltraps>

801061f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061f9:	6a 0e                	push   $0xe
  jmp alltraps
801061fb:	e9 98 fa ff ff       	jmp    80105c98 <alltraps>

80106200 <vector15>:
.globl vector15
vector15:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $15
80106202:	6a 0f                	push   $0xf
  jmp alltraps
80106204:	e9 8f fa ff ff       	jmp    80105c98 <alltraps>

80106209 <vector16>:
.globl vector16
vector16:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $16
8010620b:	6a 10                	push   $0x10
  jmp alltraps
8010620d:	e9 86 fa ff ff       	jmp    80105c98 <alltraps>

80106212 <vector17>:
.globl vector17
vector17:
  pushl $17
80106212:	6a 11                	push   $0x11
  jmp alltraps
80106214:	e9 7f fa ff ff       	jmp    80105c98 <alltraps>

80106219 <vector18>:
.globl vector18
vector18:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $18
8010621b:	6a 12                	push   $0x12
  jmp alltraps
8010621d:	e9 76 fa ff ff       	jmp    80105c98 <alltraps>

80106222 <vector19>:
.globl vector19
vector19:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $19
80106224:	6a 13                	push   $0x13
  jmp alltraps
80106226:	e9 6d fa ff ff       	jmp    80105c98 <alltraps>

8010622b <vector20>:
.globl vector20
vector20:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $20
8010622d:	6a 14                	push   $0x14
  jmp alltraps
8010622f:	e9 64 fa ff ff       	jmp    80105c98 <alltraps>

80106234 <vector21>:
.globl vector21
vector21:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $21
80106236:	6a 15                	push   $0x15
  jmp alltraps
80106238:	e9 5b fa ff ff       	jmp    80105c98 <alltraps>

8010623d <vector22>:
.globl vector22
vector22:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $22
8010623f:	6a 16                	push   $0x16
  jmp alltraps
80106241:	e9 52 fa ff ff       	jmp    80105c98 <alltraps>

80106246 <vector23>:
.globl vector23
vector23:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $23
80106248:	6a 17                	push   $0x17
  jmp alltraps
8010624a:	e9 49 fa ff ff       	jmp    80105c98 <alltraps>

8010624f <vector24>:
.globl vector24
vector24:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $24
80106251:	6a 18                	push   $0x18
  jmp alltraps
80106253:	e9 40 fa ff ff       	jmp    80105c98 <alltraps>

80106258 <vector25>:
.globl vector25
vector25:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $25
8010625a:	6a 19                	push   $0x19
  jmp alltraps
8010625c:	e9 37 fa ff ff       	jmp    80105c98 <alltraps>

80106261 <vector26>:
.globl vector26
vector26:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $26
80106263:	6a 1a                	push   $0x1a
  jmp alltraps
80106265:	e9 2e fa ff ff       	jmp    80105c98 <alltraps>

8010626a <vector27>:
.globl vector27
vector27:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $27
8010626c:	6a 1b                	push   $0x1b
  jmp alltraps
8010626e:	e9 25 fa ff ff       	jmp    80105c98 <alltraps>

80106273 <vector28>:
.globl vector28
vector28:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $28
80106275:	6a 1c                	push   $0x1c
  jmp alltraps
80106277:	e9 1c fa ff ff       	jmp    80105c98 <alltraps>

8010627c <vector29>:
.globl vector29
vector29:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $29
8010627e:	6a 1d                	push   $0x1d
  jmp alltraps
80106280:	e9 13 fa ff ff       	jmp    80105c98 <alltraps>

80106285 <vector30>:
.globl vector30
vector30:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $30
80106287:	6a 1e                	push   $0x1e
  jmp alltraps
80106289:	e9 0a fa ff ff       	jmp    80105c98 <alltraps>

8010628e <vector31>:
.globl vector31
vector31:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $31
80106290:	6a 1f                	push   $0x1f
  jmp alltraps
80106292:	e9 01 fa ff ff       	jmp    80105c98 <alltraps>

80106297 <vector32>:
.globl vector32
vector32:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $32
80106299:	6a 20                	push   $0x20
  jmp alltraps
8010629b:	e9 f8 f9 ff ff       	jmp    80105c98 <alltraps>

801062a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $33
801062a2:	6a 21                	push   $0x21
  jmp alltraps
801062a4:	e9 ef f9 ff ff       	jmp    80105c98 <alltraps>

801062a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $34
801062ab:	6a 22                	push   $0x22
  jmp alltraps
801062ad:	e9 e6 f9 ff ff       	jmp    80105c98 <alltraps>

801062b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $35
801062b4:	6a 23                	push   $0x23
  jmp alltraps
801062b6:	e9 dd f9 ff ff       	jmp    80105c98 <alltraps>

801062bb <vector36>:
.globl vector36
vector36:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $36
801062bd:	6a 24                	push   $0x24
  jmp alltraps
801062bf:	e9 d4 f9 ff ff       	jmp    80105c98 <alltraps>

801062c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $37
801062c6:	6a 25                	push   $0x25
  jmp alltraps
801062c8:	e9 cb f9 ff ff       	jmp    80105c98 <alltraps>

801062cd <vector38>:
.globl vector38
vector38:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $38
801062cf:	6a 26                	push   $0x26
  jmp alltraps
801062d1:	e9 c2 f9 ff ff       	jmp    80105c98 <alltraps>

801062d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $39
801062d8:	6a 27                	push   $0x27
  jmp alltraps
801062da:	e9 b9 f9 ff ff       	jmp    80105c98 <alltraps>

801062df <vector40>:
.globl vector40
vector40:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $40
801062e1:	6a 28                	push   $0x28
  jmp alltraps
801062e3:	e9 b0 f9 ff ff       	jmp    80105c98 <alltraps>

801062e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $41
801062ea:	6a 29                	push   $0x29
  jmp alltraps
801062ec:	e9 a7 f9 ff ff       	jmp    80105c98 <alltraps>

801062f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $42
801062f3:	6a 2a                	push   $0x2a
  jmp alltraps
801062f5:	e9 9e f9 ff ff       	jmp    80105c98 <alltraps>

801062fa <vector43>:
.globl vector43
vector43:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $43
801062fc:	6a 2b                	push   $0x2b
  jmp alltraps
801062fe:	e9 95 f9 ff ff       	jmp    80105c98 <alltraps>

80106303 <vector44>:
.globl vector44
vector44:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $44
80106305:	6a 2c                	push   $0x2c
  jmp alltraps
80106307:	e9 8c f9 ff ff       	jmp    80105c98 <alltraps>

8010630c <vector45>:
.globl vector45
vector45:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $45
8010630e:	6a 2d                	push   $0x2d
  jmp alltraps
80106310:	e9 83 f9 ff ff       	jmp    80105c98 <alltraps>

80106315 <vector46>:
.globl vector46
vector46:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $46
80106317:	6a 2e                	push   $0x2e
  jmp alltraps
80106319:	e9 7a f9 ff ff       	jmp    80105c98 <alltraps>

8010631e <vector47>:
.globl vector47
vector47:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $47
80106320:	6a 2f                	push   $0x2f
  jmp alltraps
80106322:	e9 71 f9 ff ff       	jmp    80105c98 <alltraps>

80106327 <vector48>:
.globl vector48
vector48:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $48
80106329:	6a 30                	push   $0x30
  jmp alltraps
8010632b:	e9 68 f9 ff ff       	jmp    80105c98 <alltraps>

80106330 <vector49>:
.globl vector49
vector49:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $49
80106332:	6a 31                	push   $0x31
  jmp alltraps
80106334:	e9 5f f9 ff ff       	jmp    80105c98 <alltraps>

80106339 <vector50>:
.globl vector50
vector50:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $50
8010633b:	6a 32                	push   $0x32
  jmp alltraps
8010633d:	e9 56 f9 ff ff       	jmp    80105c98 <alltraps>

80106342 <vector51>:
.globl vector51
vector51:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $51
80106344:	6a 33                	push   $0x33
  jmp alltraps
80106346:	e9 4d f9 ff ff       	jmp    80105c98 <alltraps>

8010634b <vector52>:
.globl vector52
vector52:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $52
8010634d:	6a 34                	push   $0x34
  jmp alltraps
8010634f:	e9 44 f9 ff ff       	jmp    80105c98 <alltraps>

80106354 <vector53>:
.globl vector53
vector53:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $53
80106356:	6a 35                	push   $0x35
  jmp alltraps
80106358:	e9 3b f9 ff ff       	jmp    80105c98 <alltraps>

8010635d <vector54>:
.globl vector54
vector54:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $54
8010635f:	6a 36                	push   $0x36
  jmp alltraps
80106361:	e9 32 f9 ff ff       	jmp    80105c98 <alltraps>

80106366 <vector55>:
.globl vector55
vector55:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $55
80106368:	6a 37                	push   $0x37
  jmp alltraps
8010636a:	e9 29 f9 ff ff       	jmp    80105c98 <alltraps>

8010636f <vector56>:
.globl vector56
vector56:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $56
80106371:	6a 38                	push   $0x38
  jmp alltraps
80106373:	e9 20 f9 ff ff       	jmp    80105c98 <alltraps>

80106378 <vector57>:
.globl vector57
vector57:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $57
8010637a:	6a 39                	push   $0x39
  jmp alltraps
8010637c:	e9 17 f9 ff ff       	jmp    80105c98 <alltraps>

80106381 <vector58>:
.globl vector58
vector58:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $58
80106383:	6a 3a                	push   $0x3a
  jmp alltraps
80106385:	e9 0e f9 ff ff       	jmp    80105c98 <alltraps>

8010638a <vector59>:
.globl vector59
vector59:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $59
8010638c:	6a 3b                	push   $0x3b
  jmp alltraps
8010638e:	e9 05 f9 ff ff       	jmp    80105c98 <alltraps>

80106393 <vector60>:
.globl vector60
vector60:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $60
80106395:	6a 3c                	push   $0x3c
  jmp alltraps
80106397:	e9 fc f8 ff ff       	jmp    80105c98 <alltraps>

8010639c <vector61>:
.globl vector61
vector61:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $61
8010639e:	6a 3d                	push   $0x3d
  jmp alltraps
801063a0:	e9 f3 f8 ff ff       	jmp    80105c98 <alltraps>

801063a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $62
801063a7:	6a 3e                	push   $0x3e
  jmp alltraps
801063a9:	e9 ea f8 ff ff       	jmp    80105c98 <alltraps>

801063ae <vector63>:
.globl vector63
vector63:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $63
801063b0:	6a 3f                	push   $0x3f
  jmp alltraps
801063b2:	e9 e1 f8 ff ff       	jmp    80105c98 <alltraps>

801063b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $64
801063b9:	6a 40                	push   $0x40
  jmp alltraps
801063bb:	e9 d8 f8 ff ff       	jmp    80105c98 <alltraps>

801063c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $65
801063c2:	6a 41                	push   $0x41
  jmp alltraps
801063c4:	e9 cf f8 ff ff       	jmp    80105c98 <alltraps>

801063c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $66
801063cb:	6a 42                	push   $0x42
  jmp alltraps
801063cd:	e9 c6 f8 ff ff       	jmp    80105c98 <alltraps>

801063d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $67
801063d4:	6a 43                	push   $0x43
  jmp alltraps
801063d6:	e9 bd f8 ff ff       	jmp    80105c98 <alltraps>

801063db <vector68>:
.globl vector68
vector68:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $68
801063dd:	6a 44                	push   $0x44
  jmp alltraps
801063df:	e9 b4 f8 ff ff       	jmp    80105c98 <alltraps>

801063e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $69
801063e6:	6a 45                	push   $0x45
  jmp alltraps
801063e8:	e9 ab f8 ff ff       	jmp    80105c98 <alltraps>

801063ed <vector70>:
.globl vector70
vector70:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $70
801063ef:	6a 46                	push   $0x46
  jmp alltraps
801063f1:	e9 a2 f8 ff ff       	jmp    80105c98 <alltraps>

801063f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $71
801063f8:	6a 47                	push   $0x47
  jmp alltraps
801063fa:	e9 99 f8 ff ff       	jmp    80105c98 <alltraps>

801063ff <vector72>:
.globl vector72
vector72:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $72
80106401:	6a 48                	push   $0x48
  jmp alltraps
80106403:	e9 90 f8 ff ff       	jmp    80105c98 <alltraps>

80106408 <vector73>:
.globl vector73
vector73:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $73
8010640a:	6a 49                	push   $0x49
  jmp alltraps
8010640c:	e9 87 f8 ff ff       	jmp    80105c98 <alltraps>

80106411 <vector74>:
.globl vector74
vector74:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $74
80106413:	6a 4a                	push   $0x4a
  jmp alltraps
80106415:	e9 7e f8 ff ff       	jmp    80105c98 <alltraps>

8010641a <vector75>:
.globl vector75
vector75:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $75
8010641c:	6a 4b                	push   $0x4b
  jmp alltraps
8010641e:	e9 75 f8 ff ff       	jmp    80105c98 <alltraps>

80106423 <vector76>:
.globl vector76
vector76:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $76
80106425:	6a 4c                	push   $0x4c
  jmp alltraps
80106427:	e9 6c f8 ff ff       	jmp    80105c98 <alltraps>

8010642c <vector77>:
.globl vector77
vector77:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $77
8010642e:	6a 4d                	push   $0x4d
  jmp alltraps
80106430:	e9 63 f8 ff ff       	jmp    80105c98 <alltraps>

80106435 <vector78>:
.globl vector78
vector78:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $78
80106437:	6a 4e                	push   $0x4e
  jmp alltraps
80106439:	e9 5a f8 ff ff       	jmp    80105c98 <alltraps>

8010643e <vector79>:
.globl vector79
vector79:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $79
80106440:	6a 4f                	push   $0x4f
  jmp alltraps
80106442:	e9 51 f8 ff ff       	jmp    80105c98 <alltraps>

80106447 <vector80>:
.globl vector80
vector80:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $80
80106449:	6a 50                	push   $0x50
  jmp alltraps
8010644b:	e9 48 f8 ff ff       	jmp    80105c98 <alltraps>

80106450 <vector81>:
.globl vector81
vector81:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $81
80106452:	6a 51                	push   $0x51
  jmp alltraps
80106454:	e9 3f f8 ff ff       	jmp    80105c98 <alltraps>

80106459 <vector82>:
.globl vector82
vector82:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $82
8010645b:	6a 52                	push   $0x52
  jmp alltraps
8010645d:	e9 36 f8 ff ff       	jmp    80105c98 <alltraps>

80106462 <vector83>:
.globl vector83
vector83:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $83
80106464:	6a 53                	push   $0x53
  jmp alltraps
80106466:	e9 2d f8 ff ff       	jmp    80105c98 <alltraps>

8010646b <vector84>:
.globl vector84
vector84:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $84
8010646d:	6a 54                	push   $0x54
  jmp alltraps
8010646f:	e9 24 f8 ff ff       	jmp    80105c98 <alltraps>

80106474 <vector85>:
.globl vector85
vector85:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $85
80106476:	6a 55                	push   $0x55
  jmp alltraps
80106478:	e9 1b f8 ff ff       	jmp    80105c98 <alltraps>

8010647d <vector86>:
.globl vector86
vector86:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $86
8010647f:	6a 56                	push   $0x56
  jmp alltraps
80106481:	e9 12 f8 ff ff       	jmp    80105c98 <alltraps>

80106486 <vector87>:
.globl vector87
vector87:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $87
80106488:	6a 57                	push   $0x57
  jmp alltraps
8010648a:	e9 09 f8 ff ff       	jmp    80105c98 <alltraps>

8010648f <vector88>:
.globl vector88
vector88:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $88
80106491:	6a 58                	push   $0x58
  jmp alltraps
80106493:	e9 00 f8 ff ff       	jmp    80105c98 <alltraps>

80106498 <vector89>:
.globl vector89
vector89:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $89
8010649a:	6a 59                	push   $0x59
  jmp alltraps
8010649c:	e9 f7 f7 ff ff       	jmp    80105c98 <alltraps>

801064a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $90
801064a3:	6a 5a                	push   $0x5a
  jmp alltraps
801064a5:	e9 ee f7 ff ff       	jmp    80105c98 <alltraps>

801064aa <vector91>:
.globl vector91
vector91:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $91
801064ac:	6a 5b                	push   $0x5b
  jmp alltraps
801064ae:	e9 e5 f7 ff ff       	jmp    80105c98 <alltraps>

801064b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $92
801064b5:	6a 5c                	push   $0x5c
  jmp alltraps
801064b7:	e9 dc f7 ff ff       	jmp    80105c98 <alltraps>

801064bc <vector93>:
.globl vector93
vector93:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $93
801064be:	6a 5d                	push   $0x5d
  jmp alltraps
801064c0:	e9 d3 f7 ff ff       	jmp    80105c98 <alltraps>

801064c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $94
801064c7:	6a 5e                	push   $0x5e
  jmp alltraps
801064c9:	e9 ca f7 ff ff       	jmp    80105c98 <alltraps>

801064ce <vector95>:
.globl vector95
vector95:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $95
801064d0:	6a 5f                	push   $0x5f
  jmp alltraps
801064d2:	e9 c1 f7 ff ff       	jmp    80105c98 <alltraps>

801064d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $96
801064d9:	6a 60                	push   $0x60
  jmp alltraps
801064db:	e9 b8 f7 ff ff       	jmp    80105c98 <alltraps>

801064e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $97
801064e2:	6a 61                	push   $0x61
  jmp alltraps
801064e4:	e9 af f7 ff ff       	jmp    80105c98 <alltraps>

801064e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $98
801064eb:	6a 62                	push   $0x62
  jmp alltraps
801064ed:	e9 a6 f7 ff ff       	jmp    80105c98 <alltraps>

801064f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $99
801064f4:	6a 63                	push   $0x63
  jmp alltraps
801064f6:	e9 9d f7 ff ff       	jmp    80105c98 <alltraps>

801064fb <vector100>:
.globl vector100
vector100:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $100
801064fd:	6a 64                	push   $0x64
  jmp alltraps
801064ff:	e9 94 f7 ff ff       	jmp    80105c98 <alltraps>

80106504 <vector101>:
.globl vector101
vector101:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $101
80106506:	6a 65                	push   $0x65
  jmp alltraps
80106508:	e9 8b f7 ff ff       	jmp    80105c98 <alltraps>

8010650d <vector102>:
.globl vector102
vector102:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $102
8010650f:	6a 66                	push   $0x66
  jmp alltraps
80106511:	e9 82 f7 ff ff       	jmp    80105c98 <alltraps>

80106516 <vector103>:
.globl vector103
vector103:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $103
80106518:	6a 67                	push   $0x67
  jmp alltraps
8010651a:	e9 79 f7 ff ff       	jmp    80105c98 <alltraps>

8010651f <vector104>:
.globl vector104
vector104:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $104
80106521:	6a 68                	push   $0x68
  jmp alltraps
80106523:	e9 70 f7 ff ff       	jmp    80105c98 <alltraps>

80106528 <vector105>:
.globl vector105
vector105:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $105
8010652a:	6a 69                	push   $0x69
  jmp alltraps
8010652c:	e9 67 f7 ff ff       	jmp    80105c98 <alltraps>

80106531 <vector106>:
.globl vector106
vector106:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $106
80106533:	6a 6a                	push   $0x6a
  jmp alltraps
80106535:	e9 5e f7 ff ff       	jmp    80105c98 <alltraps>

8010653a <vector107>:
.globl vector107
vector107:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $107
8010653c:	6a 6b                	push   $0x6b
  jmp alltraps
8010653e:	e9 55 f7 ff ff       	jmp    80105c98 <alltraps>

80106543 <vector108>:
.globl vector108
vector108:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $108
80106545:	6a 6c                	push   $0x6c
  jmp alltraps
80106547:	e9 4c f7 ff ff       	jmp    80105c98 <alltraps>

8010654c <vector109>:
.globl vector109
vector109:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $109
8010654e:	6a 6d                	push   $0x6d
  jmp alltraps
80106550:	e9 43 f7 ff ff       	jmp    80105c98 <alltraps>

80106555 <vector110>:
.globl vector110
vector110:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $110
80106557:	6a 6e                	push   $0x6e
  jmp alltraps
80106559:	e9 3a f7 ff ff       	jmp    80105c98 <alltraps>

8010655e <vector111>:
.globl vector111
vector111:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $111
80106560:	6a 6f                	push   $0x6f
  jmp alltraps
80106562:	e9 31 f7 ff ff       	jmp    80105c98 <alltraps>

80106567 <vector112>:
.globl vector112
vector112:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $112
80106569:	6a 70                	push   $0x70
  jmp alltraps
8010656b:	e9 28 f7 ff ff       	jmp    80105c98 <alltraps>

80106570 <vector113>:
.globl vector113
vector113:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $113
80106572:	6a 71                	push   $0x71
  jmp alltraps
80106574:	e9 1f f7 ff ff       	jmp    80105c98 <alltraps>

80106579 <vector114>:
.globl vector114
vector114:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $114
8010657b:	6a 72                	push   $0x72
  jmp alltraps
8010657d:	e9 16 f7 ff ff       	jmp    80105c98 <alltraps>

80106582 <vector115>:
.globl vector115
vector115:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $115
80106584:	6a 73                	push   $0x73
  jmp alltraps
80106586:	e9 0d f7 ff ff       	jmp    80105c98 <alltraps>

8010658b <vector116>:
.globl vector116
vector116:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $116
8010658d:	6a 74                	push   $0x74
  jmp alltraps
8010658f:	e9 04 f7 ff ff       	jmp    80105c98 <alltraps>

80106594 <vector117>:
.globl vector117
vector117:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $117
80106596:	6a 75                	push   $0x75
  jmp alltraps
80106598:	e9 fb f6 ff ff       	jmp    80105c98 <alltraps>

8010659d <vector118>:
.globl vector118
vector118:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $118
8010659f:	6a 76                	push   $0x76
  jmp alltraps
801065a1:	e9 f2 f6 ff ff       	jmp    80105c98 <alltraps>

801065a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $119
801065a8:	6a 77                	push   $0x77
  jmp alltraps
801065aa:	e9 e9 f6 ff ff       	jmp    80105c98 <alltraps>

801065af <vector120>:
.globl vector120
vector120:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $120
801065b1:	6a 78                	push   $0x78
  jmp alltraps
801065b3:	e9 e0 f6 ff ff       	jmp    80105c98 <alltraps>

801065b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $121
801065ba:	6a 79                	push   $0x79
  jmp alltraps
801065bc:	e9 d7 f6 ff ff       	jmp    80105c98 <alltraps>

801065c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $122
801065c3:	6a 7a                	push   $0x7a
  jmp alltraps
801065c5:	e9 ce f6 ff ff       	jmp    80105c98 <alltraps>

801065ca <vector123>:
.globl vector123
vector123:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $123
801065cc:	6a 7b                	push   $0x7b
  jmp alltraps
801065ce:	e9 c5 f6 ff ff       	jmp    80105c98 <alltraps>

801065d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $124
801065d5:	6a 7c                	push   $0x7c
  jmp alltraps
801065d7:	e9 bc f6 ff ff       	jmp    80105c98 <alltraps>

801065dc <vector125>:
.globl vector125
vector125:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $125
801065de:	6a 7d                	push   $0x7d
  jmp alltraps
801065e0:	e9 b3 f6 ff ff       	jmp    80105c98 <alltraps>

801065e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $126
801065e7:	6a 7e                	push   $0x7e
  jmp alltraps
801065e9:	e9 aa f6 ff ff       	jmp    80105c98 <alltraps>

801065ee <vector127>:
.globl vector127
vector127:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $127
801065f0:	6a 7f                	push   $0x7f
  jmp alltraps
801065f2:	e9 a1 f6 ff ff       	jmp    80105c98 <alltraps>

801065f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $128
801065f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065fe:	e9 95 f6 ff ff       	jmp    80105c98 <alltraps>

80106603 <vector129>:
.globl vector129
vector129:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $129
80106605:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010660a:	e9 89 f6 ff ff       	jmp    80105c98 <alltraps>

8010660f <vector130>:
.globl vector130
vector130:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $130
80106611:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106616:	e9 7d f6 ff ff       	jmp    80105c98 <alltraps>

8010661b <vector131>:
.globl vector131
vector131:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $131
8010661d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106622:	e9 71 f6 ff ff       	jmp    80105c98 <alltraps>

80106627 <vector132>:
.globl vector132
vector132:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $132
80106629:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010662e:	e9 65 f6 ff ff       	jmp    80105c98 <alltraps>

80106633 <vector133>:
.globl vector133
vector133:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $133
80106635:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010663a:	e9 59 f6 ff ff       	jmp    80105c98 <alltraps>

8010663f <vector134>:
.globl vector134
vector134:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $134
80106641:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106646:	e9 4d f6 ff ff       	jmp    80105c98 <alltraps>

8010664b <vector135>:
.globl vector135
vector135:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $135
8010664d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106652:	e9 41 f6 ff ff       	jmp    80105c98 <alltraps>

80106657 <vector136>:
.globl vector136
vector136:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $136
80106659:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010665e:	e9 35 f6 ff ff       	jmp    80105c98 <alltraps>

80106663 <vector137>:
.globl vector137
vector137:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $137
80106665:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010666a:	e9 29 f6 ff ff       	jmp    80105c98 <alltraps>

8010666f <vector138>:
.globl vector138
vector138:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $138
80106671:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106676:	e9 1d f6 ff ff       	jmp    80105c98 <alltraps>

8010667b <vector139>:
.globl vector139
vector139:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $139
8010667d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106682:	e9 11 f6 ff ff       	jmp    80105c98 <alltraps>

80106687 <vector140>:
.globl vector140
vector140:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $140
80106689:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010668e:	e9 05 f6 ff ff       	jmp    80105c98 <alltraps>

80106693 <vector141>:
.globl vector141
vector141:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $141
80106695:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010669a:	e9 f9 f5 ff ff       	jmp    80105c98 <alltraps>

8010669f <vector142>:
.globl vector142
vector142:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $142
801066a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066a6:	e9 ed f5 ff ff       	jmp    80105c98 <alltraps>

801066ab <vector143>:
.globl vector143
vector143:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $143
801066ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066b2:	e9 e1 f5 ff ff       	jmp    80105c98 <alltraps>

801066b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $144
801066b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066be:	e9 d5 f5 ff ff       	jmp    80105c98 <alltraps>

801066c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $145
801066c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066ca:	e9 c9 f5 ff ff       	jmp    80105c98 <alltraps>

801066cf <vector146>:
.globl vector146
vector146:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $146
801066d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801066d6:	e9 bd f5 ff ff       	jmp    80105c98 <alltraps>

801066db <vector147>:
.globl vector147
vector147:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $147
801066dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066e2:	e9 b1 f5 ff ff       	jmp    80105c98 <alltraps>

801066e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $148
801066e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ee:	e9 a5 f5 ff ff       	jmp    80105c98 <alltraps>

801066f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $149
801066f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066fa:	e9 99 f5 ff ff       	jmp    80105c98 <alltraps>

801066ff <vector150>:
.globl vector150
vector150:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $150
80106701:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106706:	e9 8d f5 ff ff       	jmp    80105c98 <alltraps>

8010670b <vector151>:
.globl vector151
vector151:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $151
8010670d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106712:	e9 81 f5 ff ff       	jmp    80105c98 <alltraps>

80106717 <vector152>:
.globl vector152
vector152:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $152
80106719:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010671e:	e9 75 f5 ff ff       	jmp    80105c98 <alltraps>

80106723 <vector153>:
.globl vector153
vector153:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $153
80106725:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010672a:	e9 69 f5 ff ff       	jmp    80105c98 <alltraps>

8010672f <vector154>:
.globl vector154
vector154:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $154
80106731:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106736:	e9 5d f5 ff ff       	jmp    80105c98 <alltraps>

8010673b <vector155>:
.globl vector155
vector155:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $155
8010673d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106742:	e9 51 f5 ff ff       	jmp    80105c98 <alltraps>

80106747 <vector156>:
.globl vector156
vector156:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $156
80106749:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010674e:	e9 45 f5 ff ff       	jmp    80105c98 <alltraps>

80106753 <vector157>:
.globl vector157
vector157:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $157
80106755:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010675a:	e9 39 f5 ff ff       	jmp    80105c98 <alltraps>

8010675f <vector158>:
.globl vector158
vector158:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $158
80106761:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106766:	e9 2d f5 ff ff       	jmp    80105c98 <alltraps>

8010676b <vector159>:
.globl vector159
vector159:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $159
8010676d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106772:	e9 21 f5 ff ff       	jmp    80105c98 <alltraps>

80106777 <vector160>:
.globl vector160
vector160:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $160
80106779:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010677e:	e9 15 f5 ff ff       	jmp    80105c98 <alltraps>

80106783 <vector161>:
.globl vector161
vector161:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $161
80106785:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010678a:	e9 09 f5 ff ff       	jmp    80105c98 <alltraps>

8010678f <vector162>:
.globl vector162
vector162:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $162
80106791:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106796:	e9 fd f4 ff ff       	jmp    80105c98 <alltraps>

8010679b <vector163>:
.globl vector163
vector163:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $163
8010679d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067a2:	e9 f1 f4 ff ff       	jmp    80105c98 <alltraps>

801067a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $164
801067a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067ae:	e9 e5 f4 ff ff       	jmp    80105c98 <alltraps>

801067b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $165
801067b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067ba:	e9 d9 f4 ff ff       	jmp    80105c98 <alltraps>

801067bf <vector166>:
.globl vector166
vector166:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $166
801067c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067c6:	e9 cd f4 ff ff       	jmp    80105c98 <alltraps>

801067cb <vector167>:
.globl vector167
vector167:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $167
801067cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801067d2:	e9 c1 f4 ff ff       	jmp    80105c98 <alltraps>

801067d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $168
801067d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801067de:	e9 b5 f4 ff ff       	jmp    80105c98 <alltraps>

801067e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $169
801067e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067ea:	e9 a9 f4 ff ff       	jmp    80105c98 <alltraps>

801067ef <vector170>:
.globl vector170
vector170:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $170
801067f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067f6:	e9 9d f4 ff ff       	jmp    80105c98 <alltraps>

801067fb <vector171>:
.globl vector171
vector171:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $171
801067fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106802:	e9 91 f4 ff ff       	jmp    80105c98 <alltraps>

80106807 <vector172>:
.globl vector172
vector172:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $172
80106809:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010680e:	e9 85 f4 ff ff       	jmp    80105c98 <alltraps>

80106813 <vector173>:
.globl vector173
vector173:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $173
80106815:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010681a:	e9 79 f4 ff ff       	jmp    80105c98 <alltraps>

8010681f <vector174>:
.globl vector174
vector174:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $174
80106821:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106826:	e9 6d f4 ff ff       	jmp    80105c98 <alltraps>

8010682b <vector175>:
.globl vector175
vector175:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $175
8010682d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106832:	e9 61 f4 ff ff       	jmp    80105c98 <alltraps>

80106837 <vector176>:
.globl vector176
vector176:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $176
80106839:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010683e:	e9 55 f4 ff ff       	jmp    80105c98 <alltraps>

80106843 <vector177>:
.globl vector177
vector177:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $177
80106845:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010684a:	e9 49 f4 ff ff       	jmp    80105c98 <alltraps>

8010684f <vector178>:
.globl vector178
vector178:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $178
80106851:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106856:	e9 3d f4 ff ff       	jmp    80105c98 <alltraps>

8010685b <vector179>:
.globl vector179
vector179:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $179
8010685d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106862:	e9 31 f4 ff ff       	jmp    80105c98 <alltraps>

80106867 <vector180>:
.globl vector180
vector180:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $180
80106869:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010686e:	e9 25 f4 ff ff       	jmp    80105c98 <alltraps>

80106873 <vector181>:
.globl vector181
vector181:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $181
80106875:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010687a:	e9 19 f4 ff ff       	jmp    80105c98 <alltraps>

8010687f <vector182>:
.globl vector182
vector182:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $182
80106881:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106886:	e9 0d f4 ff ff       	jmp    80105c98 <alltraps>

8010688b <vector183>:
.globl vector183
vector183:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $183
8010688d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106892:	e9 01 f4 ff ff       	jmp    80105c98 <alltraps>

80106897 <vector184>:
.globl vector184
vector184:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $184
80106899:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010689e:	e9 f5 f3 ff ff       	jmp    80105c98 <alltraps>

801068a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $185
801068a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068aa:	e9 e9 f3 ff ff       	jmp    80105c98 <alltraps>

801068af <vector186>:
.globl vector186
vector186:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $186
801068b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068b6:	e9 dd f3 ff ff       	jmp    80105c98 <alltraps>

801068bb <vector187>:
.globl vector187
vector187:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $187
801068bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068c2:	e9 d1 f3 ff ff       	jmp    80105c98 <alltraps>

801068c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $188
801068c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068ce:	e9 c5 f3 ff ff       	jmp    80105c98 <alltraps>

801068d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $189
801068d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801068da:	e9 b9 f3 ff ff       	jmp    80105c98 <alltraps>

801068df <vector190>:
.globl vector190
vector190:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $190
801068e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068e6:	e9 ad f3 ff ff       	jmp    80105c98 <alltraps>

801068eb <vector191>:
.globl vector191
vector191:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $191
801068ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068f2:	e9 a1 f3 ff ff       	jmp    80105c98 <alltraps>

801068f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $192
801068f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068fe:	e9 95 f3 ff ff       	jmp    80105c98 <alltraps>

80106903 <vector193>:
.globl vector193
vector193:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $193
80106905:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010690a:	e9 89 f3 ff ff       	jmp    80105c98 <alltraps>

8010690f <vector194>:
.globl vector194
vector194:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $194
80106911:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106916:	e9 7d f3 ff ff       	jmp    80105c98 <alltraps>

8010691b <vector195>:
.globl vector195
vector195:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $195
8010691d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106922:	e9 71 f3 ff ff       	jmp    80105c98 <alltraps>

80106927 <vector196>:
.globl vector196
vector196:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $196
80106929:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010692e:	e9 65 f3 ff ff       	jmp    80105c98 <alltraps>

80106933 <vector197>:
.globl vector197
vector197:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $197
80106935:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010693a:	e9 59 f3 ff ff       	jmp    80105c98 <alltraps>

8010693f <vector198>:
.globl vector198
vector198:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $198
80106941:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106946:	e9 4d f3 ff ff       	jmp    80105c98 <alltraps>

8010694b <vector199>:
.globl vector199
vector199:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $199
8010694d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106952:	e9 41 f3 ff ff       	jmp    80105c98 <alltraps>

80106957 <vector200>:
.globl vector200
vector200:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $200
80106959:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010695e:	e9 35 f3 ff ff       	jmp    80105c98 <alltraps>

80106963 <vector201>:
.globl vector201
vector201:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $201
80106965:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010696a:	e9 29 f3 ff ff       	jmp    80105c98 <alltraps>

8010696f <vector202>:
.globl vector202
vector202:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $202
80106971:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106976:	e9 1d f3 ff ff       	jmp    80105c98 <alltraps>

8010697b <vector203>:
.globl vector203
vector203:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $203
8010697d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106982:	e9 11 f3 ff ff       	jmp    80105c98 <alltraps>

80106987 <vector204>:
.globl vector204
vector204:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $204
80106989:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010698e:	e9 05 f3 ff ff       	jmp    80105c98 <alltraps>

80106993 <vector205>:
.globl vector205
vector205:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $205
80106995:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010699a:	e9 f9 f2 ff ff       	jmp    80105c98 <alltraps>

8010699f <vector206>:
.globl vector206
vector206:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $206
801069a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069a6:	e9 ed f2 ff ff       	jmp    80105c98 <alltraps>

801069ab <vector207>:
.globl vector207
vector207:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $207
801069ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069b2:	e9 e1 f2 ff ff       	jmp    80105c98 <alltraps>

801069b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $208
801069b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069be:	e9 d5 f2 ff ff       	jmp    80105c98 <alltraps>

801069c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $209
801069c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069ca:	e9 c9 f2 ff ff       	jmp    80105c98 <alltraps>

801069cf <vector210>:
.globl vector210
vector210:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $210
801069d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801069d6:	e9 bd f2 ff ff       	jmp    80105c98 <alltraps>

801069db <vector211>:
.globl vector211
vector211:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $211
801069dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069e2:	e9 b1 f2 ff ff       	jmp    80105c98 <alltraps>

801069e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $212
801069e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ee:	e9 a5 f2 ff ff       	jmp    80105c98 <alltraps>

801069f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $213
801069f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069fa:	e9 99 f2 ff ff       	jmp    80105c98 <alltraps>

801069ff <vector214>:
.globl vector214
vector214:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $214
80106a01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a06:	e9 8d f2 ff ff       	jmp    80105c98 <alltraps>

80106a0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $215
80106a0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a12:	e9 81 f2 ff ff       	jmp    80105c98 <alltraps>

80106a17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $216
80106a19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a1e:	e9 75 f2 ff ff       	jmp    80105c98 <alltraps>

80106a23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $217
80106a25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a2a:	e9 69 f2 ff ff       	jmp    80105c98 <alltraps>

80106a2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $218
80106a31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a36:	e9 5d f2 ff ff       	jmp    80105c98 <alltraps>

80106a3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $219
80106a3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a42:	e9 51 f2 ff ff       	jmp    80105c98 <alltraps>

80106a47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $220
80106a49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a4e:	e9 45 f2 ff ff       	jmp    80105c98 <alltraps>

80106a53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $221
80106a55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a5a:	e9 39 f2 ff ff       	jmp    80105c98 <alltraps>

80106a5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $222
80106a61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a66:	e9 2d f2 ff ff       	jmp    80105c98 <alltraps>

80106a6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $223
80106a6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a72:	e9 21 f2 ff ff       	jmp    80105c98 <alltraps>

80106a77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $224
80106a79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a7e:	e9 15 f2 ff ff       	jmp    80105c98 <alltraps>

80106a83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $225
80106a85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a8a:	e9 09 f2 ff ff       	jmp    80105c98 <alltraps>

80106a8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $226
80106a91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a96:	e9 fd f1 ff ff       	jmp    80105c98 <alltraps>

80106a9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $227
80106a9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106aa2:	e9 f1 f1 ff ff       	jmp    80105c98 <alltraps>

80106aa7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $228
80106aa9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106aae:	e9 e5 f1 ff ff       	jmp    80105c98 <alltraps>

80106ab3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $229
80106ab5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106aba:	e9 d9 f1 ff ff       	jmp    80105c98 <alltraps>

80106abf <vector230>:
.globl vector230
vector230:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $230
80106ac1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ac6:	e9 cd f1 ff ff       	jmp    80105c98 <alltraps>

80106acb <vector231>:
.globl vector231
vector231:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $231
80106acd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ad2:	e9 c1 f1 ff ff       	jmp    80105c98 <alltraps>

80106ad7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $232
80106ad9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ade:	e9 b5 f1 ff ff       	jmp    80105c98 <alltraps>

80106ae3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $233
80106ae5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aea:	e9 a9 f1 ff ff       	jmp    80105c98 <alltraps>

80106aef <vector234>:
.globl vector234
vector234:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $234
80106af1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106af6:	e9 9d f1 ff ff       	jmp    80105c98 <alltraps>

80106afb <vector235>:
.globl vector235
vector235:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $235
80106afd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b02:	e9 91 f1 ff ff       	jmp    80105c98 <alltraps>

80106b07 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $236
80106b09:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b0e:	e9 85 f1 ff ff       	jmp    80105c98 <alltraps>

80106b13 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $237
80106b15:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b1a:	e9 79 f1 ff ff       	jmp    80105c98 <alltraps>

80106b1f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $238
80106b21:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b26:	e9 6d f1 ff ff       	jmp    80105c98 <alltraps>

80106b2b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $239
80106b2d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b32:	e9 61 f1 ff ff       	jmp    80105c98 <alltraps>

80106b37 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $240
80106b39:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b3e:	e9 55 f1 ff ff       	jmp    80105c98 <alltraps>

80106b43 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $241
80106b45:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b4a:	e9 49 f1 ff ff       	jmp    80105c98 <alltraps>

80106b4f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $242
80106b51:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b56:	e9 3d f1 ff ff       	jmp    80105c98 <alltraps>

80106b5b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $243
80106b5d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b62:	e9 31 f1 ff ff       	jmp    80105c98 <alltraps>

80106b67 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $244
80106b69:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b6e:	e9 25 f1 ff ff       	jmp    80105c98 <alltraps>

80106b73 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $245
80106b75:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b7a:	e9 19 f1 ff ff       	jmp    80105c98 <alltraps>

80106b7f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $246
80106b81:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b86:	e9 0d f1 ff ff       	jmp    80105c98 <alltraps>

80106b8b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $247
80106b8d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b92:	e9 01 f1 ff ff       	jmp    80105c98 <alltraps>

80106b97 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $248
80106b99:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b9e:	e9 f5 f0 ff ff       	jmp    80105c98 <alltraps>

80106ba3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $249
80106ba5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106baa:	e9 e9 f0 ff ff       	jmp    80105c98 <alltraps>

80106baf <vector250>:
.globl vector250
vector250:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $250
80106bb1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106bb6:	e9 dd f0 ff ff       	jmp    80105c98 <alltraps>

80106bbb <vector251>:
.globl vector251
vector251:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $251
80106bbd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106bc2:	e9 d1 f0 ff ff       	jmp    80105c98 <alltraps>

80106bc7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $252
80106bc9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bce:	e9 c5 f0 ff ff       	jmp    80105c98 <alltraps>

80106bd3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $253
80106bd5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106bda:	e9 b9 f0 ff ff       	jmp    80105c98 <alltraps>

80106bdf <vector254>:
.globl vector254
vector254:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $254
80106be1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106be6:	e9 ad f0 ff ff       	jmp    80105c98 <alltraps>

80106beb <vector255>:
.globl vector255
vector255:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $255
80106bed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bf2:	e9 a1 f0 ff ff       	jmp    80105c98 <alltraps>
80106bf7:	66 90                	xchg   %ax,%ax
80106bf9:	66 90                	xchg   %ax,%ax
80106bfb:	66 90                	xchg   %ax,%ax
80106bfd:	66 90                	xchg   %ax,%ax
80106bff:	90                   	nop

80106c00 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106c07:	c1 ea 16             	shr    $0x16,%edx
{
80106c0a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106c0b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106c0e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c11:	8b 1f                	mov    (%edi),%ebx
80106c13:	f6 c3 01             	test   $0x1,%bl
80106c16:	74 28                	je     80106c40 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106c1e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c24:	89 f0                	mov    %esi,%eax
}
80106c26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c29:	c1 e8 0a             	shr    $0xa,%eax
80106c2c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c31:	01 d8                	add    %ebx,%eax
}
80106c33:	5b                   	pop    %ebx
80106c34:	5e                   	pop    %esi
80106c35:	5f                   	pop    %edi
80106c36:	5d                   	pop    %ebp
80106c37:	c3                   	ret    
80106c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c3f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c40:	85 c9                	test   %ecx,%ecx
80106c42:	74 2c                	je     80106c70 <walkpgdir+0x70>
80106c44:	e8 a7 bb ff ff       	call   801027f0 <kalloc>
80106c49:	89 c3                	mov    %eax,%ebx
80106c4b:	85 c0                	test   %eax,%eax
80106c4d:	74 21                	je     80106c70 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c4f:	83 ec 04             	sub    $0x4,%esp
80106c52:	68 00 10 00 00       	push   $0x1000
80106c57:	6a 00                	push   $0x0
80106c59:	50                   	push   %eax
80106c5a:	e8 a1 dc ff ff       	call   80104900 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c5f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c65:	83 c4 10             	add    $0x10,%esp
80106c68:	83 c8 07             	or     $0x7,%eax
80106c6b:	89 07                	mov    %eax,(%edi)
80106c6d:	eb b5                	jmp    80106c24 <walkpgdir+0x24>
80106c6f:	90                   	nop
}
80106c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c73:	31 c0                	xor    %eax,%eax
}
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5f                   	pop    %edi
80106c78:	5d                   	pop    %ebp
80106c79:	c3                   	ret    
80106c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c80 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	89 c7                	mov    %eax,%edi
  // if physical address is in huge range,
  if (pa >= HUGE_PAGE_START && pa < HUGE_PAGE_END)
  {
    // huge code
    a = (char*)HUGEPGROUNDDOWN((uint)va);
    last = (char*)HUGEPGROUNDDOWN(((uint)va) + size - 1);
80106c86:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106c8a:	56                   	push   %esi
80106c8b:	53                   	push   %ebx
80106c8c:	83 ec 1c             	sub    $0x1c,%esp
  if (pa >= HUGE_PAGE_START && pa < HUGE_PAGE_END)
80106c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106c92:	81 e9 00 00 00 1e    	sub    $0x1e000000,%ecx
80106c98:	81 f9 ff ff ff 1f    	cmp    $0x1fffffff,%ecx
80106c9e:	77 50                	ja     80106cf0 <mappages+0x70>
    a = (char*)HUGEPGROUNDDOWN((uint)va);
80106ca0:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
    last = (char*)HUGEPGROUNDDOWN(((uint)va) + size - 1);
80106ca6:	25 00 00 c0 ff       	and    $0xffc00000,%eax
80106cab:	89 c6                	mov    %eax,%esi
    for(;;)
    {
      pde = &pgdir[PDX(a)];
80106cad:	89 d3                	mov    %edx,%ebx
      // mapping to a huge page
      *pde = pa | perm | PTE_P | PTE_PS;
80106caf:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb2:	0b 45 0c             	or     0xc(%ebp),%eax
      pde = &pgdir[PDX(a)];
80106cb5:	c1 eb 16             	shr    $0x16,%ebx
      *pde = pa | perm | PTE_P | PTE_PS;
80106cb8:	0c 81                	or     $0x81,%al
    a = (char*)HUGEPGROUNDDOWN((uint)va);
80106cba:	89 d1                	mov    %edx,%ecx
      *pde = pa | perm | PTE_P | PTE_PS;
80106cbc:	89 04 9f             	mov    %eax,(%edi,%ebx,4)
      if(a == last)
80106cbf:	39 f2                	cmp    %esi,%edx
80106cc1:	74 23                	je     80106ce6 <mappages+0x66>
80106cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cc7:	90                   	nop
      *pde = pa | perm | PTE_P | PTE_PS;
80106cc8:	8b 45 08             	mov    0x8(%ebp),%eax
        break;
      a += HUGE_PAGE_SIZE;
80106ccb:	81 c1 00 00 40 00    	add    $0x400000,%ecx
      pde = &pgdir[PDX(a)];
80106cd1:	89 cb                	mov    %ecx,%ebx
      *pde = pa | perm | PTE_P | PTE_PS;
80106cd3:	01 c8                	add    %ecx,%eax
      pde = &pgdir[PDX(a)];
80106cd5:	c1 eb 16             	shr    $0x16,%ebx
      *pde = pa | perm | PTE_P | PTE_PS;
80106cd8:	29 d0                	sub    %edx,%eax
80106cda:	0b 45 0c             	or     0xc(%ebp),%eax
80106cdd:	0c 81                	or     $0x81,%al
80106cdf:	89 04 9f             	mov    %eax,(%edi,%ebx,4)
      if(a == last)
80106ce2:	39 ce                	cmp    %ecx,%esi
80106ce4:	75 e2                	jne    80106cc8 <mappages+0x48>
      a += PGSIZE;
      pa += PGSIZE;
    }
  }
  return 0;
}
80106ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ce9:	31 c0                	xor    %eax,%eax
}
80106ceb:	5b                   	pop    %ebx
80106cec:	5e                   	pop    %esi
80106ced:	5f                   	pop    %edi
80106cee:	5d                   	pop    %ebp
80106cef:	c3                   	ret    
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a = (char*)PGROUNDDOWN((uint)va);
80106cf5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cfb:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cfe:	8b 45 08             	mov    0x8(%ebp),%eax
    a = (char*)PGROUNDDOWN((uint)va);
80106d01:	89 d6                	mov    %edx,%esi
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d03:	29 d0                	sub    %edx,%eax
80106d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d08:	eb 1e                	jmp    80106d28 <mappages+0xa8>
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(*pte & PTE_P)
80106d10:	f6 00 01             	testb  $0x1,(%eax)
80106d13:	75 38                	jne    80106d4d <mappages+0xcd>
      *pte = pa | perm | PTE_P;
80106d15:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106d18:	83 cb 01             	or     $0x1,%ebx
80106d1b:	89 18                	mov    %ebx,(%eax)
      if(a == last)
80106d1d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106d20:	74 c4                	je     80106ce6 <mappages+0x66>
      a += PGSIZE;
80106d22:	81 c6 00 10 00 00    	add    $0x1000,%esi
    for(;;){
80106d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d2b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d30:	89 f2                	mov    %esi,%edx
80106d32:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106d35:	89 f8                	mov    %edi,%eax
80106d37:	e8 c4 fe ff ff       	call   80106c00 <walkpgdir>
80106d3c:	85 c0                	test   %eax,%eax
80106d3e:	75 d0                	jne    80106d10 <mappages+0x90>
}
80106d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80106d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d48:	5b                   	pop    %ebx
80106d49:	5e                   	pop    %esi
80106d4a:	5f                   	pop    %edi
80106d4b:	5d                   	pop    %ebp
80106d4c:	c3                   	ret    
        panic("remap");
80106d4d:	83 ec 0c             	sub    $0xc,%esp
80106d50:	68 94 82 10 80       	push   $0x80108294
80106d55:	e8 26 96 ff ff       	call   80100380 <panic>
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	89 d7                	mov    %edx,%edi
80106d66:	56                   	push   %esi
80106d67:	89 c6                	mov    %eax,%esi
  pde & PTE_PS
  */
  if(newsz >= oldsz)
    return oldsz;
  
  pde = &pgdir[PDX(newsz)];
80106d69:	89 c8                	mov    %ecx,%eax
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d6b:	53                   	push   %ebx
  pde = &pgdir[PDX(newsz)];
80106d6c:	c1 e8 16             	shr    $0x16,%eax
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d6f:	83 ec 1c             	sub    $0x1c,%esp
80106d72:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if (*pde & PTE_PS){
80106d75:	f6 04 86 80          	testb  $0x80,(%esi,%eax,4)
80106d79:	0f 84 11 01 00 00    	je     80106e90 <deallocuvm.part.0+0x130>
80106d7f:	89 cb                	mov    %ecx,%ebx
    a = HUGEPGROUNDUP(newsz);
80106d81:	81 c3 ff ff 3f 00    	add    $0x3fffff,%ebx
80106d87:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  }
  else{
    a = PGROUNDUP(newsz);
  }
  for(; a  < oldsz; )
80106d8d:	8d 76 00             	lea    0x0(%esi),%esi
80106d90:	39 df                	cmp    %ebx,%edi
80106d92:	76 1f                	jbe    80106db3 <deallocuvm.part.0+0x53>
  {
    // check if a points to hugepage
    pde = &pgdir[PDX(a)];
80106d94:	89 da                	mov    %ebx,%edx
80106d96:	c1 ea 16             	shr    $0x16,%edx
    if (*pde & PTE_PS)
80106d99:	8b 04 96             	mov    (%esi,%edx,4),%eax
  if(*pde & PTE_P){
80106d9c:	89 c1                	mov    %eax,%ecx
80106d9e:	83 e1 01             	and    $0x1,%ecx
    if (*pde & PTE_PS)
80106da1:	a8 80                	test   $0x80,%al
80106da3:	74 1b                	je     80106dc0 <deallocuvm.part.0+0x60>
  if(*pde & PTE_P){
80106da5:	85 c9                	test   %ecx,%ecx
80106da7:	75 27                	jne    80106dd0 <deallocuvm.part.0+0x70>
    {
      // is a hugepage
      pte = walkpgdir(pgdir, (char*)a, 0);
      if(!pte)
        a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
80106da9:	8d 5a 01             	lea    0x1(%edx),%ebx
80106dac:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; )
80106daf:	39 df                	cmp    %ebx,%edi
80106db1:	77 e1                	ja     80106d94 <deallocuvm.part.0+0x34>
      a += PGSIZE; // if freed a basepage
    }

  }
  return newsz;
}
80106db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db9:	5b                   	pop    %ebx
80106dba:	5e                   	pop    %esi
80106dbb:	5f                   	pop    %edi
80106dbc:	5d                   	pop    %ebp
80106dbd:	c3                   	ret    
80106dbe:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80106dc0:	85 c9                	test   %ecx,%ecx
80106dc2:	75 3c                	jne    80106e00 <deallocuvm.part.0+0xa0>
        a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106dc4:	83 c2 01             	add    $0x1,%edx
80106dc7:	89 d3                	mov    %edx,%ebx
80106dc9:	c1 e3 16             	shl    $0x16,%ebx
80106dcc:	eb c2                	jmp    80106d90 <deallocuvm.part.0+0x30>
80106dce:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80106dd0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106dd7:	c1 e9 0a             	shr    $0xa,%ecx
80106dda:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106de0:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
      if(!pte)
80106de7:	85 c9                	test   %ecx,%ecx
80106de9:	74 be                	je     80106da9 <deallocuvm.part.0+0x49>
      else if((*pte & PTE_P) != 0)
80106deb:	8b 01                	mov    (%ecx),%eax
80106ded:	a8 01                	test   $0x1,%al
80106def:	75 3f                	jne    80106e30 <deallocuvm.part.0+0xd0>
      a += HUGE_PAGE_SIZE; //if freed a hugepage
80106df1:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106df7:	eb 97                	jmp    80106d90 <deallocuvm.part.0+0x30>
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80106e00:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106e07:	c1 e9 0a             	shr    $0xa,%ecx
80106e0a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106e10:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
      if(!pte)
80106e17:	85 c9                	test   %ecx,%ecx
80106e19:	74 a9                	je     80106dc4 <deallocuvm.part.0+0x64>
      else if((*pte & PTE_P) != 0){
80106e1b:	8b 01                	mov    (%ecx),%eax
80106e1d:	a8 01                	test   $0x1,%al
80106e1f:	75 3f                	jne    80106e60 <deallocuvm.part.0+0x100>
      a += PGSIZE; // if freed a basepage
80106e21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e27:	e9 64 ff ff ff       	jmp    80106d90 <deallocuvm.part.0+0x30>
80106e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(pa == 0)
80106e30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e35:	74 6d                	je     80106ea4 <deallocuvm.part.0+0x144>
        khugefree(v);
80106e37:	83 ec 0c             	sub    $0xc,%esp
        char *v = P2V(pa);
80106e3a:	05 00 00 00 80       	add    $0x80000000,%eax
80106e3f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      a += HUGE_PAGE_SIZE; //if freed a hugepage
80106e42:	81 c3 00 00 40 00    	add    $0x400000,%ebx
        khugefree(v);
80106e48:	50                   	push   %eax
80106e49:	e8 42 b8 ff ff       	call   80102690 <khugefree>
        *pte = 0;
80106e4e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      a += HUGE_PAGE_SIZE; //if freed a hugepage
80106e51:	83 c4 10             	add    $0x10,%esp
        *pte = 0;
80106e54:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
80106e5a:	e9 31 ff ff ff       	jmp    80106d90 <deallocuvm.part.0+0x30>
80106e5f:	90                   	nop
        if(pa == 0)
80106e60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e65:	74 4a                	je     80106eb1 <deallocuvm.part.0+0x151>
        kfree(v);
80106e67:	83 ec 0c             	sub    $0xc,%esp
        char *v = P2V(pa);
80106e6a:	05 00 00 00 80       	add    $0x80000000,%eax
80106e6f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      a += PGSIZE; // if freed a basepage
80106e72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(v);
80106e78:	50                   	push   %eax
80106e79:	e8 52 b6 ff ff       	call   801024d0 <kfree>
        *pte = 0;
80106e7e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      a += PGSIZE; // if freed a basepage
80106e81:	83 c4 10             	add    $0x10,%esp
        *pte = 0;
80106e84:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
80106e8a:	e9 01 ff ff ff       	jmp    80106d90 <deallocuvm.part.0+0x30>
80106e8f:	90                   	nop
    a = PGROUNDUP(newsz);
80106e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e93:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e99:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e9f:	e9 ec fe ff ff       	jmp    80106d90 <deallocuvm.part.0+0x30>
          panic("khugefree");
80106ea4:	83 ec 0c             	sub    $0xc,%esp
80106ea7:	68 11 7c 10 80       	push   $0x80107c11
80106eac:	e8 cf 94 ff ff       	call   80100380 <panic>
          panic("kfree");
80106eb1:	83 ec 0c             	sub    $0xc,%esp
80106eb4:	68 06 7c 10 80       	push   $0x80107c06
80106eb9:	e8 c2 94 ff ff       	call   80100380 <panic>
80106ebe:	66 90                	xchg   %ax,%ax

80106ec0 <seginit>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ec6:	e8 85 cc ff ff       	call   80103b50 <cpuid>
  pd[0] = size-1;
80106ecb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ed0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ed6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eda:	c7 80 78 28 11 80 ff 	movl   $0xffff,-0x7feed788(%eax)
80106ee1:	ff 00 00 
80106ee4:	c7 80 7c 28 11 80 00 	movl   $0xcf9a00,-0x7feed784(%eax)
80106eeb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eee:	c7 80 80 28 11 80 ff 	movl   $0xffff,-0x7feed780(%eax)
80106ef5:	ff 00 00 
80106ef8:	c7 80 84 28 11 80 00 	movl   $0xcf9200,-0x7feed77c(%eax)
80106eff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f02:	c7 80 88 28 11 80 ff 	movl   $0xffff,-0x7feed778(%eax)
80106f09:	ff 00 00 
80106f0c:	c7 80 8c 28 11 80 00 	movl   $0xcffa00,-0x7feed774(%eax)
80106f13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f16:	c7 80 90 28 11 80 ff 	movl   $0xffff,-0x7feed770(%eax)
80106f1d:	ff 00 00 
80106f20:	c7 80 94 28 11 80 00 	movl   $0xcff200,-0x7feed76c(%eax)
80106f27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f2a:	05 70 28 11 80       	add    $0x80112870,%eax
  pd[1] = (uint)p;
80106f2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f33:	c1 e8 10             	shr    $0x10,%eax
80106f36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f3d:	0f 01 10             	lgdtl  (%eax)
}
80106f40:	c9                   	leave  
80106f41:	c3                   	ret    
80106f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f50:	a1 24 56 11 80       	mov    0x80115624,%eax
80106f55:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f5a:	0f 22 d8             	mov    %eax,%cr3
}
80106f5d:	c3                   	ret    
80106f5e:	66 90                	xchg   %ax,%ax

80106f60 <switchuvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f6c:	85 f6                	test   %esi,%esi
80106f6e:	0f 84 cb 00 00 00    	je     8010703f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f74:	8b 46 0c             	mov    0xc(%esi),%eax
80106f77:	85 c0                	test   %eax,%eax
80106f79:	0f 84 da 00 00 00    	je     80107059 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f7f:	8b 46 08             	mov    0x8(%esi),%eax
80106f82:	85 c0                	test   %eax,%eax
80106f84:	0f 84 c2 00 00 00    	je     8010704c <switchuvm+0xec>
  pushcli();
80106f8a:	e8 61 d7 ff ff       	call   801046f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f8f:	e8 5c cb ff ff       	call   80103af0 <mycpu>
80106f94:	89 c3                	mov    %eax,%ebx
80106f96:	e8 55 cb ff ff       	call   80103af0 <mycpu>
80106f9b:	89 c7                	mov    %eax,%edi
80106f9d:	e8 4e cb ff ff       	call   80103af0 <mycpu>
80106fa2:	83 c7 08             	add    $0x8,%edi
80106fa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fa8:	e8 43 cb ff ff       	call   80103af0 <mycpu>
80106fad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fb0:	ba 67 00 00 00       	mov    $0x67,%edx
80106fb5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106fbc:	83 c0 08             	add    $0x8,%eax
80106fbf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fc6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fcb:	83 c1 08             	add    $0x8,%ecx
80106fce:	c1 e8 18             	shr    $0x18,%eax
80106fd1:	c1 e9 10             	shr    $0x10,%ecx
80106fd4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106fda:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106fe0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106fe5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ff1:	e8 fa ca ff ff       	call   80103af0 <mycpu>
80106ff6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ffd:	e8 ee ca ff ff       	call   80103af0 <mycpu>
80107002:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107006:	8b 5e 0c             	mov    0xc(%esi),%ebx
80107009:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010700f:	e8 dc ca ff ff       	call   80103af0 <mycpu>
80107014:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107017:	e8 d4 ca ff ff       	call   80103af0 <mycpu>
8010701c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107020:	b8 28 00 00 00       	mov    $0x28,%eax
80107025:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107028:	8b 46 08             	mov    0x8(%esi),%eax
8010702b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107030:	0f 22 d8             	mov    %eax,%cr3
}
80107033:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107036:	5b                   	pop    %ebx
80107037:	5e                   	pop    %esi
80107038:	5f                   	pop    %edi
80107039:	5d                   	pop    %ebp
  popcli();
8010703a:	e9 01 d7 ff ff       	jmp    80104740 <popcli>
    panic("switchuvm: no process");
8010703f:	83 ec 0c             	sub    $0xc,%esp
80107042:	68 9a 82 10 80       	push   $0x8010829a
80107047:	e8 34 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010704c:	83 ec 0c             	sub    $0xc,%esp
8010704f:	68 c5 82 10 80       	push   $0x801082c5
80107054:	e8 27 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107059:	83 ec 0c             	sub    $0xc,%esp
8010705c:	68 b0 82 10 80       	push   $0x801082b0
80107061:	e8 1a 93 ff ff       	call   80100380 <panic>
80107066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010706d:	8d 76 00             	lea    0x0(%esi),%esi

80107070 <inituvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 1c             	sub    $0x1c,%esp
80107079:	8b 45 0c             	mov    0xc(%ebp),%eax
8010707c:	8b 75 08             	mov    0x8(%ebp),%esi
8010707f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107082:	8b 45 10             	mov    0x10(%ebp),%eax
80107085:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(sz >= PGSIZE)
80107088:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010708d:	77 7d                	ja     8010710c <inituvm+0x9c>
  mem = kalloc();
8010708f:	e8 5c b7 ff ff       	call   801027f0 <kalloc>
  memset(mem, 0, PGSIZE);
80107094:	83 ec 04             	sub    $0x4,%esp
80107097:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010709c:	89 c7                	mov    %eax,%edi
  memset(mem, 0, PGSIZE);
8010709e:	6a 00                	push   $0x0
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070a0:	8d 9f 00 00 00 80    	lea    -0x80000000(%edi),%ebx
  memset(mem, 0, PGSIZE);
801070a6:	50                   	push   %eax
801070a7:	e8 54 d8 ff ff       	call   80104900 <memset>
  if (pa >= HUGE_PAGE_START && pa < HUGE_PAGE_END)
801070ac:	8d 87 00 00 00 62    	lea    0x62000000(%edi),%eax
801070b2:	83 c4 10             	add    $0x10,%esp
801070b5:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
801070ba:	76 3c                	jbe    801070f8 <inituvm+0x88>
      if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070bc:	31 d2                	xor    %edx,%edx
801070be:	b9 01 00 00 00       	mov    $0x1,%ecx
801070c3:	89 f0                	mov    %esi,%eax
801070c5:	e8 36 fb ff ff       	call   80106c00 <walkpgdir>
801070ca:	85 c0                	test   %eax,%eax
801070cc:	74 0a                	je     801070d8 <inituvm+0x68>
      if(*pte & PTE_P)
801070ce:	f6 00 01             	testb  $0x1,(%eax)
801070d1:	75 2c                	jne    801070ff <inituvm+0x8f>
      *pte = pa | perm | PTE_P;
801070d3:	83 cb 07             	or     $0x7,%ebx
801070d6:	89 18                	mov    %ebx,(%eax)
  memmove(mem, init, sz);
801070d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070db:	89 7d 08             	mov    %edi,0x8(%ebp)
801070de:	89 45 10             	mov    %eax,0x10(%ebp)
801070e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070e4:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801070e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ea:	5b                   	pop    %ebx
801070eb:	5e                   	pop    %esi
801070ec:	5f                   	pop    %edi
801070ed:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070ee:	e9 ad d8 ff ff       	jmp    801049a0 <memmove>
801070f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070f7:	90                   	nop
      *pde = pa | perm | PTE_P | PTE_PS;
801070f8:	80 cb 87             	or     $0x87,%bl
801070fb:	89 1e                	mov    %ebx,(%esi)
      if(a == last)
801070fd:	eb d9                	jmp    801070d8 <inituvm+0x68>
        panic("remap");
801070ff:	83 ec 0c             	sub    $0xc,%esp
80107102:	68 94 82 10 80       	push   $0x80108294
80107107:	e8 74 92 ff ff       	call   80100380 <panic>
    panic("inituvm: more than a page");
8010710c:	83 ec 0c             	sub    $0xc,%esp
8010710f:	68 d9 82 10 80       	push   $0x801082d9
80107114:	e8 67 92 ff ff       	call   80100380 <panic>
80107119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107120 <loaduvm>:
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
80107129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010712c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010712f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107134:	0f 85 bb 00 00 00    	jne    801071f5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010713a:	01 f0                	add    %esi,%eax
8010713c:	89 f3                	mov    %esi,%ebx
8010713e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107141:	8b 45 14             	mov    0x14(%ebp),%eax
80107144:	01 f0                	add    %esi,%eax
80107146:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107149:	85 f6                	test   %esi,%esi
8010714b:	0f 84 87 00 00 00    	je     801071d8 <loaduvm+0xb8>
80107151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010715b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010715e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107160:	89 c2                	mov    %eax,%edx
80107162:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107165:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107168:	f6 c2 01             	test   $0x1,%dl
8010716b:	75 13                	jne    80107180 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010716d:	83 ec 0c             	sub    $0xc,%esp
80107170:	68 f3 82 10 80       	push   $0x801082f3
80107175:	e8 06 92 ff ff       	call   80100380 <panic>
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107180:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107183:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107189:	25 fc 0f 00 00       	and    $0xffc,%eax
8010718e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107195:	85 c0                	test   %eax,%eax
80107197:	74 d4                	je     8010716d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107199:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010719b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010719e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801071a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071a8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801071ae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071b1:	29 d9                	sub    %ebx,%ecx
801071b3:	05 00 00 00 80       	add    $0x80000000,%eax
801071b8:	57                   	push   %edi
801071b9:	51                   	push   %ecx
801071ba:	50                   	push   %eax
801071bb:	ff 75 10             	push   0x10(%ebp)
801071be:	e8 dd a8 ff ff       	call   80101aa0 <readi>
801071c3:	83 c4 10             	add    $0x10,%esp
801071c6:	39 f8                	cmp    %edi,%eax
801071c8:	75 1e                	jne    801071e8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801071ca:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801071d0:	89 f0                	mov    %esi,%eax
801071d2:	29 d8                	sub    %ebx,%eax
801071d4:	39 c6                	cmp    %eax,%esi
801071d6:	77 80                	ja     80107158 <loaduvm+0x38>
}
801071d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071db:	31 c0                	xor    %eax,%eax
}
801071dd:	5b                   	pop    %ebx
801071de:	5e                   	pop    %esi
801071df:	5f                   	pop    %edi
801071e0:	5d                   	pop    %ebp
801071e1:	c3                   	ret    
801071e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071f0:	5b                   	pop    %ebx
801071f1:	5e                   	pop    %esi
801071f2:	5f                   	pop    %edi
801071f3:	5d                   	pop    %ebp
801071f4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801071f5:	83 ec 0c             	sub    $0xc,%esp
801071f8:	68 b0 83 10 80       	push   $0x801083b0
801071fd:	e8 7e 91 ff ff       	call   80100380 <panic>
80107202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107210 <allocuvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107219:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010721c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010721f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107222:	85 c0                	test   %eax,%eax
80107224:	0f 88 b6 00 00 00    	js     801072e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010722a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010722d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107230:	0f 82 9a 00 00 00    	jb     801072d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107236:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010723c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107242:	39 75 10             	cmp    %esi,0x10(%ebp)
80107245:	77 44                	ja     8010728b <allocuvm+0x7b>
80107247:	e9 87 00 00 00       	jmp    801072d3 <allocuvm+0xc3>
8010724c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107250:	83 ec 04             	sub    $0x4,%esp
80107253:	68 00 10 00 00       	push   $0x1000
80107258:	6a 00                	push   $0x0
8010725a:	50                   	push   %eax
8010725b:	e8 a0 d6 ff ff       	call   80104900 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107260:	58                   	pop    %eax
80107261:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107267:	5a                   	pop    %edx
80107268:	6a 06                	push   $0x6
8010726a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010726f:	89 f2                	mov    %esi,%edx
80107271:	50                   	push   %eax
80107272:	89 f8                	mov    %edi,%eax
80107274:	e8 07 fa ff ff       	call   80106c80 <mappages>
80107279:	83 c4 10             	add    $0x10,%esp
8010727c:	85 c0                	test   %eax,%eax
8010727e:	78 78                	js     801072f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107280:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107286:	39 75 10             	cmp    %esi,0x10(%ebp)
80107289:	76 48                	jbe    801072d3 <allocuvm+0xc3>
    mem = kalloc();
8010728b:	e8 60 b5 ff ff       	call   801027f0 <kalloc>
80107290:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107292:	85 c0                	test   %eax,%eax
80107294:	75 ba                	jne    80107250 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107296:	83 ec 0c             	sub    $0xc,%esp
80107299:	68 11 83 10 80       	push   $0x80108311
8010729e:	e8 fd 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801072a6:	83 c4 10             	add    $0x10,%esp
801072a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801072ac:	74 32                	je     801072e0 <allocuvm+0xd0>
801072ae:	8b 55 10             	mov    0x10(%ebp),%edx
801072b1:	89 c1                	mov    %eax,%ecx
801072b3:	89 f8                	mov    %edi,%eax
801072b5:	e8 a6 fa ff ff       	call   80106d60 <deallocuvm.part.0>
      return 0;
801072ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072c7:	5b                   	pop    %ebx
801072c8:	5e                   	pop    %esi
801072c9:	5f                   	pop    %edi
801072ca:	5d                   	pop    %ebp
801072cb:	c3                   	ret    
801072cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801072d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801072d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d9:	5b                   	pop    %ebx
801072da:	5e                   	pop    %esi
801072db:	5f                   	pop    %edi
801072dc:	5d                   	pop    %ebp
801072dd:	c3                   	ret    
801072de:	66 90                	xchg   %ax,%ax
    return 0;
801072e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ed:	5b                   	pop    %ebx
801072ee:	5e                   	pop    %esi
801072ef:	5f                   	pop    %edi
801072f0:	5d                   	pop    %ebp
801072f1:	c3                   	ret    
801072f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072f8:	83 ec 0c             	sub    $0xc,%esp
801072fb:	68 29 83 10 80       	push   $0x80108329
80107300:	e8 9b 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107305:	8b 45 0c             	mov    0xc(%ebp),%eax
80107308:	83 c4 10             	add    $0x10,%esp
8010730b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010730e:	74 0c                	je     8010731c <allocuvm+0x10c>
80107310:	8b 55 10             	mov    0x10(%ebp),%edx
80107313:	89 c1                	mov    %eax,%ecx
80107315:	89 f8                	mov    %edi,%eax
80107317:	e8 44 fa ff ff       	call   80106d60 <deallocuvm.part.0>
      kfree(mem);
8010731c:	83 ec 0c             	sub    $0xc,%esp
8010731f:	53                   	push   %ebx
80107320:	e8 ab b1 ff ff       	call   801024d0 <kfree>
      return 0;
80107325:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010732c:	83 c4 10             	add    $0x10,%esp
}
8010732f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107332:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107335:	5b                   	pop    %ebx
80107336:	5e                   	pop    %esi
80107337:	5f                   	pop    %edi
80107338:	5d                   	pop    %ebp
80107339:	c3                   	ret    
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107340 <allochugeuvm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 0c             	sub    $0xc,%esp
  if(newsz < oldsz)
80107349:	8b 45 0c             	mov    0xc(%ebp),%eax
{
8010734c:	8b 7d 08             	mov    0x8(%ebp),%edi
    return oldsz;
8010734f:	89 c3                	mov    %eax,%ebx
  if(newsz < oldsz)
80107351:	39 45 10             	cmp    %eax,0x10(%ebp)
80107354:	0f 82 8b 00 00 00    	jb     801073e5 <allochugeuvm+0xa5>
  a = HUGEPGROUNDUP(oldsz);
8010735a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010735d:	8d b0 ff ff 3f 00    	lea    0x3fffff(%eax),%esi
80107363:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
  for(; a < newsz; a += HUGE_PAGE_SIZE){
80107369:	39 75 10             	cmp    %esi,0x10(%ebp)
8010736c:	77 48                	ja     801073b6 <allochugeuvm+0x76>
8010736e:	e9 7d 00 00 00       	jmp    801073f0 <allochugeuvm+0xb0>
80107373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107377:	90                   	nop
    memset(mem, 0, HUGE_PAGE_SIZE);
80107378:	83 ec 04             	sub    $0x4,%esp
8010737b:	68 00 00 40 00       	push   $0x400000
80107380:	6a 00                	push   $0x0
80107382:	50                   	push   %eax
80107383:	e8 78 d5 ff ff       	call   80104900 <memset>
    if(mappages(pgdir, (char*)a, HUGE_PAGE_SIZE, V2P(mem), PTE_PS|PTE_W|PTE_U) < 0){
80107388:	58                   	pop    %eax
80107389:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010738f:	5a                   	pop    %edx
80107390:	68 86 00 00 00       	push   $0x86
80107395:	b9 00 00 40 00       	mov    $0x400000,%ecx
8010739a:	89 f2                	mov    %esi,%edx
8010739c:	50                   	push   %eax
8010739d:	89 f8                	mov    %edi,%eax
8010739f:	e8 dc f8 ff ff       	call   80106c80 <mappages>
801073a4:	83 c4 10             	add    $0x10,%esp
801073a7:	85 c0                	test   %eax,%eax
801073a9:	78 55                	js     80107400 <allochugeuvm+0xc0>
  for(; a < newsz; a += HUGE_PAGE_SIZE){
801073ab:	81 c6 00 00 40 00    	add    $0x400000,%esi
801073b1:	39 75 10             	cmp    %esi,0x10(%ebp)
801073b4:	76 3a                	jbe    801073f0 <allochugeuvm+0xb0>
    mem = khugealloc();
801073b6:	e8 a5 b4 ff ff       	call   80102860 <khugealloc>
801073bb:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801073bd:	85 c0                	test   %eax,%eax
801073bf:	75 b7                	jne    80107378 <allochugeuvm+0x38>
      cprintf("allochugeuvm out of memory\n");
801073c1:	83 ec 0c             	sub    $0xc,%esp
801073c4:	68 45 83 10 80       	push   $0x80108345
801073c9:	e8 d2 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801073ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801073d1:	83 c4 10             	add    $0x10,%esp
801073d4:	39 45 10             	cmp    %eax,0x10(%ebp)
801073d7:	74 0c                	je     801073e5 <allochugeuvm+0xa5>
801073d9:	8b 55 10             	mov    0x10(%ebp),%edx
801073dc:	89 c1                	mov    %eax,%ecx
801073de:	89 f8                	mov    %edi,%eax
801073e0:	e8 7b f9 ff ff       	call   80106d60 <deallocuvm.part.0>
}
801073e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e8:	89 d8                	mov    %ebx,%eax
801073ea:	5b                   	pop    %ebx
801073eb:	5e                   	pop    %esi
801073ec:	5f                   	pop    %edi
801073ed:	5d                   	pop    %ebp
801073ee:	c3                   	ret    
801073ef:	90                   	nop
  return newsz;
801073f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
}
801073f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f6:	89 d8                	mov    %ebx,%eax
801073f8:	5b                   	pop    %ebx
801073f9:	5e                   	pop    %esi
801073fa:	5f                   	pop    %edi
801073fb:	5d                   	pop    %ebp
801073fc:	c3                   	ret    
801073fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allochugeuvm out of memory (2)\n");
80107400:	83 ec 0c             	sub    $0xc,%esp
80107403:	68 d4 83 10 80       	push   $0x801083d4
80107408:	e8 93 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
8010740d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107410:	83 c4 10             	add    $0x10,%esp
80107413:	39 45 10             	cmp    %eax,0x10(%ebp)
80107416:	74 0c                	je     80107424 <allochugeuvm+0xe4>
80107418:	8b 55 10             	mov    0x10(%ebp),%edx
8010741b:	89 c1                	mov    %eax,%ecx
8010741d:	89 f8                	mov    %edi,%eax
8010741f:	e8 3c f9 ff ff       	call   80106d60 <deallocuvm.part.0>
      kfree(mem);
80107424:	83 ec 0c             	sub    $0xc,%esp
80107427:	53                   	push   %ebx
      return 0;
80107428:	31 db                	xor    %ebx,%ebx
      kfree(mem);
8010742a:	e8 a1 b0 ff ff       	call   801024d0 <kfree>
      return 0;
8010742f:	83 c4 10             	add    $0x10,%esp
}
80107432:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107435:	89 d8                	mov    %ebx,%eax
80107437:	5b                   	pop    %ebx
80107438:	5e                   	pop    %esi
80107439:	5f                   	pop    %edi
8010743a:	5d                   	pop    %ebp
8010743b:	c3                   	ret    
8010743c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107440 <deallocuvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	8b 55 0c             	mov    0xc(%ebp),%edx
80107446:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107449:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010744c:	39 d1                	cmp    %edx,%ecx
8010744e:	73 10                	jae    80107460 <deallocuvm+0x20>
}
80107450:	5d                   	pop    %ebp
80107451:	e9 0a f9 ff ff       	jmp    80106d60 <deallocuvm.part.0>
80107456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745d:	8d 76 00             	lea    0x0(%esi),%esi
80107460:	89 d0                	mov    %edx,%eax
80107462:	5d                   	pop    %ebp
80107463:	c3                   	ret    
80107464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop

80107470 <deallochugeuvm>:
// TODO: implement this
// part 2
// I havent touched this, only copy paste
int
deallochugeuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	57                   	push   %edi
80107474:	56                   	push   %esi
80107475:	53                   	push   %ebx
80107476:	83 ec 0c             	sub    $0xc,%esp
80107479:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010747c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
8010747f:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
80107481:	39 7d 10             	cmp    %edi,0x10(%ebp)
80107484:	73 32                	jae    801074b8 <deallochugeuvm+0x48>

  a = HUGEPGROUNDUP(newsz);
80107486:	8b 45 10             	mov    0x10(%ebp),%eax
80107489:	8d b0 ff ff 3f 00    	lea    0x3fffff(%eax),%esi
8010748f:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
80107495:	8d 76 00             	lea    0x0(%esi),%esi
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80107498:	39 f7                	cmp    %esi,%edi
8010749a:	76 19                	jbe    801074b5 <deallochugeuvm+0x45>
  pde = &pgdir[PDX(va)];
8010749c:	89 f2                	mov    %esi,%edx
8010749e:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801074a1:	8b 1c 91             	mov    (%ecx,%edx,4),%ebx
801074a4:	f6 c3 01             	test   $0x1,%bl
801074a7:	75 17                	jne    801074c0 <deallochugeuvm+0x50>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - HUGE_PAGE_SIZE;
801074a9:	83 c2 01             	add    $0x1,%edx
801074ac:	89 d6                	mov    %edx,%esi
801074ae:	c1 e6 16             	shl    $0x16,%esi
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
801074b1:	39 f7                	cmp    %esi,%edi
801074b3:	77 e7                	ja     8010749c <deallochugeuvm+0x2c>
      char *v = P2V(pa);
      khugefree(v);
      *pte = 0;
    }
  }
  return newsz;
801074b5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801074b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074bb:	5b                   	pop    %ebx
801074bc:	5e                   	pop    %esi
801074bd:	5f                   	pop    %edi
801074be:	5d                   	pop    %ebp
801074bf:	c3                   	ret    
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(!pte)
801074c6:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801074cc:	74 db                	je     801074a9 <deallochugeuvm+0x39>
    else if((*pte & PTE_P) != 0){
801074ce:	8b 93 00 00 00 80    	mov    -0x80000000(%ebx),%edx
801074d4:	f6 c2 01             	test   $0x1,%dl
801074d7:	75 0f                	jne    801074e8 <deallochugeuvm+0x78>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
801074d9:	81 c6 00 00 40 00    	add    $0x400000,%esi
801074df:	eb b7                	jmp    80107498 <deallochugeuvm+0x28>
801074e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801074e8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801074ee:	74 2d                	je     8010751d <deallochugeuvm+0xad>
      khugefree(v);
801074f0:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801074f3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801074f9:	89 4d 08             	mov    %ecx,0x8(%ebp)
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
801074fc:	81 c6 00 00 40 00    	add    $0x400000,%esi
      khugefree(v);
80107502:	52                   	push   %edx
80107503:	e8 88 b1 ff ff       	call   80102690 <khugefree>
  for(; a  < oldsz; a += HUGE_PAGE_SIZE){
80107508:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010750b:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010750e:	c7 83 00 00 00 80 00 	movl   $0x0,-0x80000000(%ebx)
80107515:	00 00 00 
80107518:	e9 7b ff ff ff       	jmp    80107498 <deallochugeuvm+0x28>
        panic("khugefree");
8010751d:	83 ec 0c             	sub    $0xc,%esp
80107520:	68 11 7c 10 80       	push   $0x80107c11
80107525:	e8 56 8e ff ff       	call   80100380 <panic>
8010752a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107530 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 0c             	sub    $0xc,%esp
80107539:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  if(pgdir == 0)
8010753c:	85 f6                	test   %esi,%esi
8010753e:	74 5d                	je     8010759d <freevm+0x6d>
  if(newsz >= oldsz)
80107540:	31 c9                	xor    %ecx,%ecx
80107542:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107547:	89 f0                	mov    %esi,%eax
80107549:	89 f3                	mov    %esi,%ebx
8010754b:	e8 10 f8 ff ff       	call   80106d60 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107550:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107556:	eb 0f                	jmp    80107567 <freevm+0x37>
80107558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010755f:	90                   	nop
80107560:	83 c3 04             	add    $0x4,%ebx
80107563:	39 fb                	cmp    %edi,%ebx
80107565:	74 27                	je     8010758e <freevm+0x5e>
    
    if(pgdir[i] & PTE_P){
80107567:	8b 03                	mov    (%ebx),%eax
80107569:	a8 01                	test   $0x1,%al
8010756b:	74 f3                	je     80107560 <freevm+0x30>
      //check if huge page
      if (pgdir[i] & PTE_PS)
8010756d:	a8 80                	test   $0x80,%al
8010756f:	75 ef                	jne    80107560 <freevm+0x30>
        //khugefree(v);
      }
      else
      {
        // otherwise free the page
        char * v = P2V(PTE_ADDR(pgdir[i]));
80107571:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        kfree(v);
80107576:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107579:	83 c3 04             	add    $0x4,%ebx
        char * v = P2V(PTE_ADDR(pgdir[i]));
8010757c:	05 00 00 00 80       	add    $0x80000000,%eax
        kfree(v);
80107581:	50                   	push   %eax
80107582:	e8 49 af ff ff       	call   801024d0 <kfree>
80107587:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010758a:	39 fb                	cmp    %edi,%ebx
8010758c:	75 d9                	jne    80107567 <freevm+0x37>
      }
    }
  }
  kfree((char*)pgdir);
8010758e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107594:	5b                   	pop    %ebx
80107595:	5e                   	pop    %esi
80107596:	5f                   	pop    %edi
80107597:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107598:	e9 33 af ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
8010759d:	83 ec 0c             	sub    $0xc,%esp
801075a0:	68 61 83 10 80       	push   $0x80108361
801075a5:	e8 d6 8d ff ff       	call   80100380 <panic>
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075b0 <setupkvm>:
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	56                   	push   %esi
801075b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075b5:	e8 36 b2 ff ff       	call   801027f0 <kalloc>
801075ba:	89 c6                	mov    %eax,%esi
801075bc:	85 c0                	test   %eax,%eax
801075be:	74 42                	je     80107602 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801075c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801075c8:	68 00 10 00 00       	push   $0x1000
801075cd:	6a 00                	push   $0x0
801075cf:	50                   	push   %eax
801075d0:	e8 2b d3 ff ff       	call   80104900 <memset>
801075d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801075d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075db:	83 ec 08             	sub    $0x8,%esp
801075de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075e1:	ff 73 0c             	push   0xc(%ebx)
801075e4:	8b 13                	mov    (%ebx),%edx
801075e6:	50                   	push   %eax
801075e7:	29 c1                	sub    %eax,%ecx
801075e9:	89 f0                	mov    %esi,%eax
801075eb:	e8 90 f6 ff ff       	call   80106c80 <mappages>
801075f0:	83 c4 10             	add    $0x10,%esp
801075f3:	85 c0                	test   %eax,%eax
801075f5:	78 19                	js     80107610 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075f7:	83 c3 10             	add    $0x10,%ebx
801075fa:	81 fb 70 b4 10 80    	cmp    $0x8010b470,%ebx
80107600:	75 d6                	jne    801075d8 <setupkvm+0x28>
}
80107602:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107605:	89 f0                	mov    %esi,%eax
80107607:	5b                   	pop    %ebx
80107608:	5e                   	pop    %esi
80107609:	5d                   	pop    %ebp
8010760a:	c3                   	ret    
8010760b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010760f:	90                   	nop
      freevm(pgdir);
80107610:	83 ec 0c             	sub    $0xc,%esp
80107613:	56                   	push   %esi
      return 0;
80107614:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107616:	e8 15 ff ff ff       	call   80107530 <freevm>
      return 0;
8010761b:	83 c4 10             	add    $0x10,%esp
}
8010761e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107621:	89 f0                	mov    %esi,%eax
80107623:	5b                   	pop    %ebx
80107624:	5e                   	pop    %esi
80107625:	5d                   	pop    %ebp
80107626:	c3                   	ret    
80107627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762e:	66 90                	xchg   %ax,%ax

80107630 <kvmalloc>:
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107636:	e8 75 ff ff ff       	call   801075b0 <setupkvm>
8010763b:	a3 24 56 11 80       	mov    %eax,0x80115624
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107640:	05 00 00 00 80       	add    $0x80000000,%eax
80107645:	0f 22 d8             	mov    %eax,%cr3
}
80107648:	c9                   	leave  
80107649:	c3                   	ret    
8010764a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107650 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	83 ec 08             	sub    $0x8,%esp
80107656:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107659:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010765c:	89 c1                	mov    %eax,%ecx
8010765e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107661:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107664:	f6 c2 01             	test   $0x1,%dl
80107667:	75 17                	jne    80107680 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107669:	83 ec 0c             	sub    $0xc,%esp
8010766c:	68 72 83 10 80       	push   $0x80108372
80107671:	e8 0a 8d ff ff       	call   80100380 <panic>
80107676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010767d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107680:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107683:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107689:	25 fc 0f 00 00       	and    $0xffc,%eax
8010768e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107695:	85 c0                	test   %eax,%eax
80107697:	74 d0                	je     80107669 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107699:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010769c:	c9                   	leave  
8010769d:	c3                   	ret    
8010769e:	66 90                	xchg   %ax,%ax

801076a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint hugesz)
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
801076a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801076a9:	e8 02 ff ff ff       	call   801075b0 <setupkvm>
801076ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076b1:	85 c0                	test   %eax,%eax
801076b3:	0f 84 6c 01 00 00    	je     80107825 <copyuvm+0x185>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801076bc:	85 c0                	test   %eax,%eax
801076be:	0f 84 ba 00 00 00    	je     8010777e <copyuvm+0xde>
801076c4:	31 f6                	xor    %esi,%esi
801076c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801076d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801076d3:	89 f0                	mov    %esi,%eax
801076d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801076d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801076db:	a8 01                	test   $0x1,%al
801076dd:	75 11                	jne    801076f0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801076df:	83 ec 0c             	sub    $0xc,%esp
801076e2:	68 7c 83 10 80       	push   $0x8010837c
801076e7:	e8 94 8c ff ff       	call   80100380 <panic>
801076ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801076f0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801076f7:	c1 ea 0a             	shr    $0xa,%edx
801076fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107700:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107707:	85 c0                	test   %eax,%eax
80107709:	74 d4                	je     801076df <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010770b:	8b 00                	mov    (%eax),%eax
8010770d:	a8 01                	test   $0x1,%al
8010770f:	0f 84 37 01 00 00    	je     8010784c <copyuvm+0x1ac>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107715:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107717:	25 ff 0f 00 00       	and    $0xfff,%eax
8010771c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010771f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107725:	e8 c6 b0 ff ff       	call   801027f0 <kalloc>
8010772a:	89 c3                	mov    %eax,%ebx
8010772c:	85 c0                	test   %eax,%eax
8010772e:	0f 84 dc 00 00 00    	je     80107810 <copyuvm+0x170>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107734:	83 ec 04             	sub    $0x4,%esp
80107737:	81 c7 00 00 00 80    	add    $0x80000000,%edi
8010773d:	68 00 10 00 00       	push   $0x1000
80107742:	57                   	push   %edi
80107743:	50                   	push   %eax
80107744:	e8 57 d2 ff ff       	call   801049a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107749:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010774f:	59                   	pop    %ecx
80107750:	5f                   	pop    %edi
80107751:	ff 75 e4             	push   -0x1c(%ebp)
80107754:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107759:	89 f2                	mov    %esi,%edx
8010775b:	50                   	push   %eax
8010775c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010775f:	e8 1c f5 ff ff       	call   80106c80 <mappages>
80107764:	83 c4 10             	add    $0x10,%esp
80107767:	85 c0                	test   %eax,%eax
80107769:	0f 88 c1 00 00 00    	js     80107830 <copyuvm+0x190>
  for(i = 0; i < sz; i += PGSIZE){
8010776f:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107775:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107778:	0f 87 52 ff ff ff    	ja     801076d0 <copyuvm+0x30>
      kfree(mem);
      goto bad;
    }
  }
  for(i = HUGE_VA_OFFSET; i < HUGE_VA_OFFSET + hugesz; i += HUGE_PAGE_SIZE){
8010777e:	8b 45 10             	mov    0x10(%ebp),%eax
80107781:	05 00 00 00 1e       	add    $0x1e000000,%eax
80107786:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107789:	3d 00 00 00 1e       	cmp    $0x1e000000,%eax
8010778e:	0f 86 91 00 00 00    	jbe    80107825 <copyuvm+0x185>
80107794:	bf 00 00 00 1e       	mov    $0x1e000000,%edi
80107799:	eb 47                	jmp    801077e2 <copyuvm+0x142>
8010779b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010779f:	90                   	nop
    pde = &pgdir[PDX(i)];
    pa = PTE_ADDR(*pde);
    flags = PTE_FLAGS(*pde);
    if((mem = khugealloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), HUGE_PAGE_SIZE);
801077a0:	83 ec 04             	sub    $0x4,%esp
801077a3:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801077a9:	68 00 00 40 00       	push   $0x400000
801077ae:	56                   	push   %esi
801077af:	50                   	push   %eax
801077b0:	e8 eb d1 ff ff       	call   801049a0 <memmove>
    if(mappages(d, (void*)i, HUGE_PAGE_SIZE, V2P(mem), flags) < 0) {
801077b5:	58                   	pop    %eax
801077b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077bc:	5a                   	pop    %edx
801077bd:	ff 75 e4             	push   -0x1c(%ebp)
801077c0:	b9 00 00 40 00       	mov    $0x400000,%ecx
801077c5:	89 fa                	mov    %edi,%edx
801077c7:	50                   	push   %eax
801077c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077cb:	e8 b0 f4 ff ff       	call   80106c80 <mappages>
801077d0:	83 c4 10             	add    $0x10,%esp
801077d3:	85 c0                	test   %eax,%eax
801077d5:	78 67                	js     8010783e <copyuvm+0x19e>
  for(i = HUGE_VA_OFFSET; i < HUGE_VA_OFFSET + hugesz; i += HUGE_PAGE_SIZE){
801077d7:	81 c7 00 00 40 00    	add    $0x400000,%edi
801077dd:	3b 7d dc             	cmp    -0x24(%ebp),%edi
801077e0:	73 43                	jae    80107825 <copyuvm+0x185>
    pa = PTE_ADDR(*pde);
801077e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
    pde = &pgdir[PDX(i)];
801077e5:	89 f8                	mov    %edi,%eax
801077e7:	c1 e8 16             	shr    $0x16,%eax
    pa = PTE_ADDR(*pde);
801077ea:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801077ed:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pde);
801077ef:	25 ff 0f 00 00       	and    $0xfff,%eax
801077f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pde);
801077f7:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = khugealloc()) == 0)
801077fd:	e8 5e b0 ff ff       	call   80102860 <khugealloc>
80107802:	89 c3                	mov    %eax,%ebx
80107804:	85 c0                	test   %eax,%eax
80107806:	75 98                	jne    801077a0 <copyuvm+0x100>
80107808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780f:	90                   	nop
    }
  }
  return d;

bad:
  freevm(d);
80107810:	83 ec 0c             	sub    $0xc,%esp
80107813:	ff 75 e0             	push   -0x20(%ebp)
80107816:	e8 15 fd ff ff       	call   80107530 <freevm>
  return 0;
8010781b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107822:	83 c4 10             	add    $0x10,%esp
}
80107825:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107828:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010782b:	5b                   	pop    %ebx
8010782c:	5e                   	pop    %esi
8010782d:	5f                   	pop    %edi
8010782e:	5d                   	pop    %ebp
8010782f:	c3                   	ret    
      kfree(mem);
80107830:	83 ec 0c             	sub    $0xc,%esp
80107833:	53                   	push   %ebx
80107834:	e8 97 ac ff ff       	call   801024d0 <kfree>
      goto bad;
80107839:	83 c4 10             	add    $0x10,%esp
8010783c:	eb d2                	jmp    80107810 <copyuvm+0x170>
      khugefree(mem);
8010783e:	83 ec 0c             	sub    $0xc,%esp
80107841:	53                   	push   %ebx
80107842:	e8 49 ae ff ff       	call   80102690 <khugefree>
      goto bad;
80107847:	83 c4 10             	add    $0x10,%esp
8010784a:	eb c4                	jmp    80107810 <copyuvm+0x170>
      panic("copyuvm: page not present");
8010784c:	83 ec 0c             	sub    $0xc,%esp
8010784f:	68 96 83 10 80       	push   $0x80108396
80107854:	e8 27 8b ff ff       	call   80100380 <panic>
80107859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107860 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107866:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107869:	89 c1                	mov    %eax,%ecx
8010786b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010786e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107871:	f6 c2 01             	test   $0x1,%dl
80107874:	0f 84 00 01 00 00    	je     8010797a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010787a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010787d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107883:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107884:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107889:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107890:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107892:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107897:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010789a:	05 00 00 00 80       	add    $0x80000000,%eax
8010789f:	83 fa 05             	cmp    $0x5,%edx
801078a2:	ba 00 00 00 00       	mov    $0x0,%edx
801078a7:	0f 45 c2             	cmovne %edx,%eax
}
801078aa:	c3                   	ret    
801078ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078af:	90                   	nop

801078b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	57                   	push   %edi
801078b4:	56                   	push   %esi
801078b5:	53                   	push   %ebx
801078b6:	83 ec 0c             	sub    $0xc,%esp
801078b9:	8b 75 14             	mov    0x14(%ebp),%esi
801078bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801078bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078c2:	85 f6                	test   %esi,%esi
801078c4:	75 51                	jne    80107917 <copyout+0x67>
801078c6:	e9 a5 00 00 00       	jmp    80107970 <copyout+0xc0>
801078cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078cf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801078d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801078d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801078dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801078e2:	74 75                	je     80107959 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801078e4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801078e6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801078e9:	29 c3                	sub    %eax,%ebx
801078eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078f1:	39 f3                	cmp    %esi,%ebx
801078f3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801078f6:	29 f8                	sub    %edi,%eax
801078f8:	83 ec 04             	sub    $0x4,%esp
801078fb:	01 c1                	add    %eax,%ecx
801078fd:	53                   	push   %ebx
801078fe:	52                   	push   %edx
801078ff:	51                   	push   %ecx
80107900:	e8 9b d0 ff ff       	call   801049a0 <memmove>
    len -= n;
    buf += n;
80107905:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107908:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010790e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107911:	01 da                	add    %ebx,%edx
  while(len > 0){
80107913:	29 de                	sub    %ebx,%esi
80107915:	74 59                	je     80107970 <copyout+0xc0>
  if(*pde & PTE_P){
80107917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010791a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010791c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010791e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107921:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107927:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010792a:	f6 c1 01             	test   $0x1,%cl
8010792d:	0f 84 4e 00 00 00    	je     80107981 <copyout.cold>
  return &pgtab[PTX(va)];
80107933:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107935:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010793b:	c1 eb 0c             	shr    $0xc,%ebx
8010793e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107944:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010794b:	89 d9                	mov    %ebx,%ecx
8010794d:	83 e1 05             	and    $0x5,%ecx
80107950:	83 f9 05             	cmp    $0x5,%ecx
80107953:	0f 84 77 ff ff ff    	je     801078d0 <copyout+0x20>
  }
  return 0;
}
80107959:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010795c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107961:	5b                   	pop    %ebx
80107962:	5e                   	pop    %esi
80107963:	5f                   	pop    %edi
80107964:	5d                   	pop    %ebp
80107965:	c3                   	ret    
80107966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010796d:	8d 76 00             	lea    0x0(%esi),%esi
80107970:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107973:	31 c0                	xor    %eax,%eax
}
80107975:	5b                   	pop    %ebx
80107976:	5e                   	pop    %esi
80107977:	5f                   	pop    %edi
80107978:	5d                   	pop    %ebp
80107979:	c3                   	ret    

8010797a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010797a:	a1 00 00 00 00       	mov    0x0,%eax
8010797f:	0f 0b                	ud2    

80107981 <copyout.cold>:
80107981:	a1 00 00 00 00       	mov    0x0,%eax
80107986:	0f 0b                	ud2    
