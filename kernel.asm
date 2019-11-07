
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
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
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 78 10 80       	push   $0x80107860
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 15 4a 00 00       	call   80104a70 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 78 10 80       	push   $0x80107867
80100097:	50                   	push   %eax
80100098:	e8 a3 48 00 00       	call   80104940 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 c7 4a 00 00       	call   80104bb0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 09 4b 00 00       	call   80104c70 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 48 00 00       	call   80104980 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 78 10 80       	push   $0x8010786e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 6d 48 00 00       	call   80104a20 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 78 10 80       	push   $0x8010787f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 2c 48 00 00       	call   80104a20 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 47 00 00       	call   801049e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 a0 49 00 00       	call   80104bb0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 0f 4a 00 00       	jmp    80104c70 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 78 10 80       	push   $0x80107886
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 1f 49 00 00       	call   80104bb0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 20 15 11 80    	mov    0x80111520,%edx
801002a7:	39 15 24 15 11 80    	cmp    %edx,0x80111524
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 20 15 11 80       	push   $0x80111520
801002c5:	e8 36 37 00 00       	call   80103a00 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 20 15 11 80    	mov    0x80111520,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 24 15 11 80    	cmp    0x80111524,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 70 34 00 00       	call   80103750 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 7c 49 00 00       	call   80104c70 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 20 15 11 80       	mov    %eax,0x80111520
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 a0 14 11 80 	movsbl -0x7feeeb60(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 1e 49 00 00       	call   80104c70 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 20 15 11 80    	mov    %edx,0x80111520
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 78 10 80       	push   $0x8010788d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 03 82 10 80 	movl   $0x80108203,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 b3 46 00 00       	call   80104a90 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 78 10 80       	push   $0x801078a1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 31 60 00 00       	call   80106470 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 7f 5f 00 00       	call   80106470 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 73 5f 00 00       	call   80106470 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 67 5f 00 00       	call   80106470 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 47 48 00 00       	call   80104d70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 7a 47 00 00       	call   80104cc0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 78 10 80       	push   $0x801078a5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 d0 78 10 80 	movzbl -0x7fef8730(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 90 45 00 00       	call   80104bb0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 24 46 00 00       	call   80104c70 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 4c 45 00 00       	call   80104c70 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba b8 78 10 80       	mov    $0x801078b8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 bb 43 00 00       	call   80104bb0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 78 10 80       	push   $0x801078bf
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 88 43 00 00       	call   80104bb0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 28 15 11 80       	mov    0x80111528,%eax
80100856:	3b 05 24 15 11 80    	cmp    0x80111524,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 28 15 11 80       	mov    %eax,0x80111528
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 e3 43 00 00       	call   80104c70 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 28 15 11 80       	mov    0x80111528,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 20 15 11 80    	sub    0x80111520,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 28 15 11 80    	mov    %edx,0x80111528
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 a0 14 11 80    	mov    %cl,-0x7feeeb60(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 20 15 11 80       	mov    0x80111520,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 28 15 11 80    	cmp    %eax,0x80111528
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 24 15 11 80       	mov    %eax,0x80111524
          wakeup(&input.r);
80100911:	68 20 15 11 80       	push   $0x80111520
80100916:	e8 c5 33 00 00       	call   80103ce0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 28 15 11 80       	mov    0x80111528,%eax
8010093d:	39 05 24 15 11 80    	cmp    %eax,0x80111524
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 28 15 11 80       	mov    %eax,0x80111528
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 28 15 11 80       	mov    0x80111528,%eax
80100964:	3b 05 24 15 11 80    	cmp    0x80111524,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba a0 14 11 80 0a 	cmpb   $0xa,-0x7feeeb60(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 24 34 00 00       	jmp    80103dc0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 a0 14 11 80 0a 	movb   $0xa,-0x7feeeb60(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 28 15 11 80       	mov    0x80111528,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 c8 78 10 80       	push   $0x801078c8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 9b 40 00 00       	call   80104a70 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ec 1e 11 80 00 	movl   $0x80100600,0x80111eec
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 e8 1e 11 80 70 	movl   $0x80100270,0x80111ee8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 2f 2d 00 00       	call   80103750 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 27 6b 00 00       	call   801075c0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 e5 68 00 00       	call   801073e0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 f3 67 00 00       	call   80107320 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 c9 69 00 00       	call   80107540 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 31 68 00 00       	call   801073e0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 7a 69 00 00       	call   80107540 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 78 10 80       	push   $0x801078e1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 55 6a 00 00       	call   80107660 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 a2 42 00 00       	call   80104ee0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 8f 42 00 00       	call   80104ee0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 5e 6b 00 00       	call   801077c0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 f4 6a 00 00       	call   801077c0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 91 41 00 00       	call   80104ea0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 57 64 00 00       	call   80107190 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 ff 67 00 00       	call   80107540 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 ed 78 10 80       	push   $0x801078ed
80100d6b:	68 40 15 11 80       	push   $0x80111540
80100d70:	e8 fb 3c 00 00       	call   80104a70 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 74 15 11 80       	mov    $0x80111574,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 40 15 11 80       	push   $0x80111540
80100d91:	e8 1a 3e 00 00       	call   80104bb0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb d4 1e 11 80    	cmp    $0x80111ed4,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 40 15 11 80       	push   $0x80111540
80100dc1:	e8 aa 3e 00 00       	call   80104c70 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 40 15 11 80       	push   $0x80111540
80100dda:	e8 91 3e 00 00       	call   80104c70 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 40 15 11 80       	push   $0x80111540
80100dff:	e8 ac 3d 00 00       	call   80104bb0 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 40 15 11 80       	push   $0x80111540
80100e1c:	e8 4f 3e 00 00       	call   80104c70 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 f4 78 10 80       	push   $0x801078f4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 40 15 11 80       	push   $0x80111540
80100e51:	e8 5a 3d 00 00       	call   80104bb0 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 40 15 11 80 	movl   $0x80111540,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 ef 3d 00 00       	jmp    80104c70 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 40 15 11 80       	push   $0x80111540
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 c3 3d 00 00       	call   80104c70 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 ba 24 00 00       	call   80103390 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 fc 78 10 80       	push   $0x801078fc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 6e 25 00 00       	jmp    80103540 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 06 79 10 80       	push   $0x80107906
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 3e 23 00 00       	jmp    80103430 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 0f 79 10 80       	push   $0x8010790f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 15 79 10 80       	push   $0x80107915
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 58 1f 11 80    	add    0x80111f58,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 1f 79 10 80       	push   $0x8010791f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d 40 1f 11 80    	mov    0x80111f40,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 58 1f 11 80    	add    0x80111f58,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 40 1f 11 80       	mov    0x80111f40,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 40 1f 11 80    	cmp    %eax,0x80111f40
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 32 79 10 80       	push   $0x80107932
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 56 3a 00 00       	call   80104cc0 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 94 1f 11 80       	mov    $0x80111f94,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 60 1f 11 80       	push   $0x80111f60
801012aa:	e8 01 39 00 00       	call   80104bb0 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb b4 3b 11 80    	cmp    $0x80113bb4,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb b4 3b 11 80    	cmp    $0x80113bb4,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 60 1f 11 80       	push   $0x80111f60
8010130f:	e8 5c 39 00 00       	call   80104c70 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 60 1f 11 80       	push   $0x80111f60
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 2e 39 00 00       	call   80104c70 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 48 79 10 80       	push   $0x80107948
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 58 79 10 80       	push   $0x80107958
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 0a 39 00 00       	call   80104d70 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb a0 1f 11 80       	mov    $0x80111fa0,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 6b 79 10 80       	push   $0x8010796b
80101491:	68 60 1f 11 80       	push   $0x80111f60
80101496:	e8 d5 35 00 00       	call   80104a70 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 72 79 10 80       	push   $0x80107972
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 8c 34 00 00       	call   80104940 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb c0 3b 11 80    	cmp    $0x80113bc0,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 40 1f 11 80       	push   $0x80111f40
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 58 1f 11 80    	pushl  0x80111f58
801014d5:	ff 35 54 1f 11 80    	pushl  0x80111f54
801014db:	ff 35 50 1f 11 80    	pushl  0x80111f50
801014e1:	ff 35 4c 1f 11 80    	pushl  0x80111f4c
801014e7:	ff 35 48 1f 11 80    	pushl  0x80111f48
801014ed:	ff 35 44 1f 11 80    	pushl  0x80111f44
801014f3:	ff 35 40 1f 11 80    	pushl  0x80111f40
801014f9:	68 d8 79 10 80       	push   $0x801079d8
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d 48 1f 11 80 01 	cmpl   $0x1,0x80111f48
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d 48 1f 11 80    	cmp    %ebx,0x80111f48
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 54 1f 11 80    	add    0x80111f54,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 2d 37 00 00       	call   80104cc0 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 78 79 10 80       	push   $0x80107978
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 54 1f 11 80    	add    0x80111f54,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 3a 37 00 00       	call   80104d70 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 60 1f 11 80       	push   $0x80111f60
8010165f:	e8 4c 35 00 00       	call   80104bb0 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
8010166f:	e8 fc 35 00 00       	call   80104c70 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 d9 32 00 00       	call   80104980 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 54 1f 11 80    	add    0x80111f54,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 53 36 00 00       	call   80104d70 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 90 79 10 80       	push   $0x80107990
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 8a 79 10 80       	push   $0x8010798a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 a8 32 00 00       	call   80104a20 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 4c 32 00 00       	jmp    801049e0 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 9f 79 10 80       	push   $0x8010799f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 bb 31 00 00       	call   80104980 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 01 32 00 00       	call   801049e0 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
801017e6:	e8 c5 33 00 00       	call   80104bb0 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 60 1f 11 80 	movl   $0x80111f60,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 6b 34 00 00       	jmp    80104c70 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 60 1f 11 80       	push   $0x80111f60
80101810:	e8 9b 33 00 00       	call   80104bb0 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
8010181f:	e8 4c 34 00 00       	call   80104c70 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 64 33 00 00       	call   80104d70 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 e0 1e 11 80 	mov    -0x7feee120(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 68 32 00 00       	call   80104d70 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 e4 1e 11 80 	mov    -0x7feee11c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 3d 32 00 00       	call   80104de0 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 de 31 00 00       	call   80104de0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 b9 79 10 80       	push   $0x801079b9
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 a7 79 10 80       	push   $0x801079a7
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 d2 1a 00 00       	call   80103750 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 60 1f 11 80       	push   $0x80111f60
80101c89:	e8 22 2f 00 00       	call   80104bb0 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
80101c99:	e8 d2 2f 00 00       	call   80104c70 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 76 30 00 00       	call   80104d70 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 e3 2f 00 00       	call   80104d70 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 be 2f 00 00       	call   80104e40 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 c8 79 10 80       	push   $0x801079c8
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 ea 7f 10 80       	push   $0x80107fea
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 34 7a 10 80       	push   $0x80107a34
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 2b 7a 10 80       	push   $0x80107a2b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 46 7a 10 80       	push   $0x80107a46
8010200b:	68 80 b5 10 80       	push   $0x8010b580
80102010:	e8 5b 2a 00 00       	call   80104a70 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 80 42 11 80       	mov    0x80114280,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 80 b5 10 80       	push   $0x8010b580
8010208e:	e8 1d 2b 00 00       	call   80104bb0 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 ea 1b 00 00       	call   80103ce0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 b5 10 80       	push   $0x8010b580
8010210f:	e8 5c 2b 00 00       	call   80104c70 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 ed 28 00 00       	call   80104a20 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 b5 10 80       	push   $0x8010b580
80102168:	e8 43 2a 00 00       	call   80104bb0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 b5 10 80       	push   $0x8010b580
801021b8:	53                   	push   %ebx
801021b9:	e8 42 18 00 00       	call   80103a00 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 95 2a 00 00       	jmp    80104c70 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 60 7a 10 80       	push   $0x80107a60
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 4a 7a 10 80       	push   $0x80107a4a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 75 7a 10 80       	push   $0x80107a75
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 b4 3b 11 80 00 	movl   $0xfec00000,0x80113bb4
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 b4 3b 11 80       	mov    0x80113bb4,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 e0 3c 11 80 	movzbl 0x80113ce0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 94 7a 10 80       	push   $0x80107a94
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 b4 3b 11 80       	mov    0x80113bb4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb 28 77 11 80    	cmp    $0x80117728,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 79 29 00 00       	call   80104cc0 <memset>

  if(kmem.use_lock)
80102347:	8b 15 f4 3b 11 80    	mov    0x80113bf4,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 f8 3b 11 80       	mov    0x80113bf8,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
  kmem.freelist = r;
80102360:	89 1d f8 3b 11 80    	mov    %ebx,0x80113bf8
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 c0 3b 11 80 	movl   $0x80113bc0,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 f0 28 00 00       	jmp    80104c70 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 c0 3b 11 80       	push   $0x80113bc0
80102388:	e8 23 28 00 00       	call   80104bb0 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 c6 7a 10 80       	push   $0x80107ac6
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 cc 7a 10 80       	push   $0x80107acc
80102400:	68 c0 3b 11 80       	push   $0x80113bc0
80102405:	e8 66 26 00 00       	call   80104a70 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 f4 3b 11 80 00 	movl   $0x0,0x80113bf4
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 f4 3b 11 80 01 	movl   $0x1,0x80113bf4
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 f8 3b 11 80       	mov    0x80113bf8,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 f8 3b 11 80    	mov    %edx,0x80113bf8
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 c0 3b 11 80       	push   $0x80113bc0
801024f3:	e8 b8 26 00 00       	call   80104bb0 <acquire>
  r = kmem.freelist;
801024f8:	a1 f8 3b 11 80       	mov    0x80113bf8,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 f4 3b 11 80    	mov    0x80113bf4,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d f8 3b 11 80    	mov    %ecx,0x80113bf8
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 c0 3b 11 80       	push   $0x80113bc0
80102521:	e8 4a 27 00 00       	call   80104c70 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 00 7c 10 80 	movzbl -0x7fef8400(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 00 7b 10 80 	movzbl -0x7fef8500(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 e0 7a 10 80 	mov    -0x7fef8520(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 00 7c 10 80 	movzbl -0x7fef8400(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 fc 3b 11 80    	mov    0x80113bfc,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 d4 23 00 00       	call   80104d10 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d 48 3c 11 80    	mov    0x80113c48,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 44 3c 11 80    	pushl  0x80113c44
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d 4c 3c 11 80 	pushl  -0x7feec3b4(,%ebx,4)
80102a44:	ff 35 44 3c 11 80    	pushl  0x80113c44
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 07 23 00 00       	call   80104d70 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d 48 3c 11 80    	cmp    %ebx,0x80113c48
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 34 3c 11 80    	pushl  0x80113c34
80102aae:	ff 35 44 3c 11 80    	pushl  0x80113c44
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d 48 3c 11 80    	mov    0x80113c48,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a 4c 3c 11 80    	mov    -0x7feec3b4(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 00 7d 10 80       	push   $0x80107d00
80102b0f:	68 00 3c 11 80       	push   $0x80113c00
80102b14:	e8 57 1f 00 00       	call   80104a70 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d 44 3c 11 80    	mov    %ebx,0x80113c44
  log.size = sb.nlog;
80102b32:	89 15 38 3c 11 80    	mov    %edx,0x80113c38
  log.start = sb.logstart;
80102b38:	a3 34 3c 11 80       	mov    %eax,0x80113c34
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d 48 3c 11 80    	mov    %ebx,0x80113c48
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a 48 3c 11 80    	mov    %ecx,-0x7feec3b8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 48 3c 11 80 00 	movl   $0x0,0x80113c48
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 00 3c 11 80       	push   $0x80113c00
80102bab:	e8 00 20 00 00       	call   80104bb0 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 00 3c 11 80       	push   $0x80113c00
80102bc0:	68 00 3c 11 80       	push   $0x80113c00
80102bc5:	e8 36 0e 00 00       	call   80103a00 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 40 3c 11 80       	mov    0x80113c40,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80102bdb:	8b 15 48 3c 11 80    	mov    0x80113c48,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 3c 3c 11 80       	mov    %eax,0x80113c3c
      release(&log.lock);
80102bf7:	68 00 3c 11 80       	push   $0x80113c00
80102bfc:	e8 6f 20 00 00       	call   80104c70 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 00 3c 11 80       	push   $0x80113c00
80102c1e:	e8 8d 1f 00 00       	call   80104bb0 <acquire>
  log.outstanding -= 1;
80102c23:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
  if(log.committing)
80102c28:	8b 35 40 3c 11 80    	mov    0x80113c40,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d 3c 3c 11 80    	mov    %ebx,0x80113c3c
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 40 3c 11 80 01 	movl   $0x1,0x80113c40
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 00 3c 11 80       	push   $0x80113c00
80102c5c:	e8 0f 20 00 00       	call   80104c70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d 48 3c 11 80    	mov    0x80113c48,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 44 3c 11 80    	pushl  0x80113c44
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d 4c 3c 11 80 	pushl  -0x7feec3b4(,%ebx,4)
80102c96:	ff 35 44 3c 11 80    	pushl  0x80113c44
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 b5 20 00 00       	call   80104d70 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d 48 3c 11 80    	cmp    0x80113c48,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 48 3c 11 80 00 	movl   $0x0,0x80113c48
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 00 3c 11 80       	push   $0x80113c00
80102cff:	e8 ac 1e 00 00       	call   80104bb0 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
    log.committing = 0;
80102d0b:	c7 05 40 3c 11 80 00 	movl   $0x0,0x80113c40
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 c6 0f 00 00       	call   80103ce0 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
80102d21:	e8 4a 1f 00 00       	call   80104c70 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 00 3c 11 80       	push   $0x80113c00
80102d40:	e8 9b 0f 00 00       	call   80103ce0 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
80102d4c:	e8 1f 1f 00 00       	call   80104c70 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 04 7d 10 80       	push   $0x80107d04
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 48 3c 11 80    	mov    0x80113c48,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 38 3c 11 80       	mov    0x80113c38,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 00 3c 11 80       	push   $0x80113c00
80102dae:	e8 fd 1d 00 00       	call   80104bb0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d 48 3c 11 80    	mov    0x80113c48,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 4c 3c 11 80    	cmp    0x80113c4c,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 4c 3c 11 80 	cmp    %edx,-0x7feec3b4(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 4c 3c 11 80 	mov    %edx,-0x7feec3b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 48 3c 11 80       	mov    %eax,0x80113c48
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 00 3c 11 80 	movl   $0x80113c00,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 6e 1e 00 00       	jmp    80104c70 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 4c 3c 11 80 	mov    %edx,-0x7feec3b4(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 4c 3c 11 80       	mov    %eax,0x80113c4c
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 13 7d 10 80       	push   $0x80107d13
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 29 7d 10 80       	push   $0x80107d29
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 e4 08 00 00       	call   80103730 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 dd 08 00 00       	call   80103730 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 44 7d 10 80       	push   $0x80107d44
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 d9 31 00 00       	call   80106040 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 44 08 00 00       	call   801036b0 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 51 17 00 00       	call   801045d0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 e5 42 00 00       	call   80107170 <switchkvm>
  seginit();
80102e8b:	e8 50 42 00 00       	call   801070e0 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
    ticksQ[i] = (1 << i);
80102ea7:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102eac:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaf:	55                   	push   %ebp
80102eb0:	89 e5                	mov    %esp,%ebp
80102eb2:	53                   	push   %ebx
80102eb3:	51                   	push   %ecx
  for(int i = 0; i < 5; i++)
80102eb4:	31 c9                	xor    %ecx,%ecx
    ticksQ[i] = (1 << i);
80102eb6:	89 d0                	mov    %edx,%eax
    front[i] = -1;
80102eb8:	c7 04 8d 60 14 11 80 	movl   $0xffffffff,-0x7feeeba0(,%ecx,4)
80102ebf:	ff ff ff ff 
    rear[i] = -1;
80102ec3:	c7 04 8d c0 c5 10 80 	movl   $0xffffffff,-0x7fef3a40(,%ecx,4)
80102eca:	ff ff ff ff 
    ticksQ[i] = (1 << i);
80102ece:	d3 e0                	shl    %cl,%eax
    sz[i] = 0;
80102ed0:	c7 04 8d 74 14 11 80 	movl   $0x0,-0x7feeeb8c(,%ecx,4)
80102ed7:	00 00 00 00 
    ticksQ[i] = (1 << i);
80102edb:	89 04 8d 38 0f 11 80 	mov    %eax,-0x7feef0c8(,%ecx,4)
  for(int i = 0; i < 5; i++)
80102ee2:	83 c1 01             	add    $0x1,%ecx
80102ee5:	83 f9 05             	cmp    $0x5,%ecx
80102ee8:	75 cc                	jne    80102eb6 <main+0x16>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eea:	83 ec 08             	sub    $0x8,%esp
80102eed:	68 00 00 40 80       	push   $0x80400000
80102ef2:	68 28 77 11 80       	push   $0x80117728
80102ef7:	e8 f4 f4 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102efc:	e8 3f 47 00 00       	call   80107640 <kvmalloc>
  mpinit();        // detect other processors
80102f01:	e8 7a 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f06:	e8 25 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102f0b:	e8 d0 41 00 00       	call   801070e0 <seginit>
  picinit();       // disable pic
80102f10:	e8 4b 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f15:	e8 06 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102f1a:	e8 a1 da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f1f:	e8 8c 34 00 00       	call   801063b0 <uartinit>
  pinit();         // process table
80102f24:	e8 67 07 00 00       	call   80103690 <pinit>
  tvinit();        // trap vectors
80102f29:	e8 92 30 00 00       	call   80105fc0 <tvinit>
  binit();         // buffer cache
80102f2e:	e8 0d d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f33:	e8 28 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f38:	e8 c3 f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f3d:	83 c4 0c             	add    $0xc,%esp
80102f40:	68 8a 00 00 00       	push   $0x8a
80102f45:	68 8c b4 10 80       	push   $0x8010b48c
80102f4a:	68 00 70 00 80       	push   $0x80007000
80102f4f:	e8 1c 1e 00 00       	call   80104d70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f54:	69 05 80 42 11 80 b0 	imul   $0xb0,0x80114280,%eax
80102f5b:	00 00 00 
80102f5e:	83 c4 10             	add    $0x10,%esp
80102f61:	05 00 3d 11 80       	add    $0x80113d00,%eax
80102f66:	3d 00 3d 11 80       	cmp    $0x80113d00,%eax
80102f6b:	76 76                	jbe    80102fe3 <main+0x143>
80102f6d:	bb 00 3d 11 80       	mov    $0x80113d00,%ebx
80102f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(c == mycpu())  // We've started already.
80102f78:	e8 33 07 00 00       	call   801036b0 <mycpu>
80102f7d:	39 d8                	cmp    %ebx,%eax
80102f7f:	74 49                	je     80102fca <main+0x12a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f81:	e8 3a f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f86:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f8b:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f92:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f95:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f9c:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f9f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fa4:	0f b6 03             	movzbl (%ebx),%eax
80102fa7:	83 ec 08             	sub    $0x8,%esp
80102faa:	68 00 70 00 00       	push   $0x7000
80102faf:	50                   	push   %eax
80102fb0:	e8 cb f7 ff ff       	call   80102780 <lapicstartap>
80102fb5:	83 c4 10             	add    $0x10,%esp
80102fb8:	90                   	nop
80102fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fc0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	74 f6                	je     80102fc0 <main+0x120>
  for(c = cpus; c < cpus+ncpu; c++){
80102fca:	69 05 80 42 11 80 b0 	imul   $0xb0,0x80114280,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fda:	05 00 3d 11 80       	add    $0x80113d00,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 95                	jb     80102f78 <main+0xd8>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 6b f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102ff5:	e8 46 12 00 00       	call   80104240 <userinit>
  mpmain();        // finish this processor's setup
80102ffa:	e8 41 fe ff ff       	call   80102e40 <mpmain>
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103005:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010300b:	53                   	push   %ebx
  e = addr+len;
8010300c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010300f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103012:	39 de                	cmp    %ebx,%esi
80103014:	72 10                	jb     80103026 <mpsearch1+0x26>
80103016:	eb 50                	jmp    80103068 <mpsearch1+0x68>
80103018:	90                   	nop
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	39 fb                	cmp    %edi,%ebx
80103022:	89 fe                	mov    %edi,%esi
80103024:	76 42                	jbe    80103068 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103026:	83 ec 04             	sub    $0x4,%esp
80103029:	8d 7e 10             	lea    0x10(%esi),%edi
8010302c:	6a 04                	push   $0x4
8010302e:	68 58 7d 10 80       	push   $0x80107d58
80103033:	56                   	push   %esi
80103034:	e8 d7 1c 00 00       	call   80104d10 <memcmp>
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	85 c0                	test   %eax,%eax
8010303e:	75 e0                	jne    80103020 <mpsearch1+0x20>
80103040:	89 f1                	mov    %esi,%ecx
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103048:	0f b6 11             	movzbl (%ecx),%edx
8010304b:	83 c1 01             	add    $0x1,%ecx
8010304e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103050:	39 f9                	cmp    %edi,%ecx
80103052:	75 f4                	jne    80103048 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103054:	84 c0                	test   %al,%al
80103056:	75 c8                	jne    80103020 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305b:	89 f0                	mov    %esi,%eax
8010305d:	5b                   	pop    %ebx
8010305e:	5e                   	pop    %esi
8010305f:	5f                   	pop    %edi
80103060:	5d                   	pop    %ebp
80103061:	c3                   	ret    
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010306b:	31 f6                	xor    %esi,%esi
}
8010306d:	89 f0                	mov    %esi,%eax
8010306f:	5b                   	pop    %ebx
80103070:	5e                   	pop    %esi
80103071:	5f                   	pop    %edi
80103072:	5d                   	pop    %ebp
80103073:	c3                   	ret    
80103074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010307a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103080 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103089:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103090:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103097:	c1 e0 08             	shl    $0x8,%eax
8010309a:	09 d0                	or     %edx,%eax
8010309c:	c1 e0 04             	shl    $0x4,%eax
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 1b                	jne    801030be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030b1:	c1 e0 08             	shl    $0x8,%eax
801030b4:	09 d0                	or     %edx,%eax
801030b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030be:	ba 00 04 00 00       	mov    $0x400,%edx
801030c3:	e8 38 ff ff ff       	call   80103000 <mpsearch1>
801030c8:	85 c0                	test   %eax,%eax
801030ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030cd:	0f 84 3d 01 00 00    	je     80103210 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d6:	8b 58 04             	mov    0x4(%eax),%ebx
801030d9:	85 db                	test   %ebx,%ebx
801030db:	0f 84 4f 01 00 00    	je     80103230 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030e7:	83 ec 04             	sub    $0x4,%esp
801030ea:	6a 04                	push   $0x4
801030ec:	68 75 7d 10 80       	push   $0x80107d75
801030f1:	56                   	push   %esi
801030f2:	e8 19 1c 00 00       	call   80104d10 <memcmp>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	85 c0                	test   %eax,%eax
801030fc:	0f 85 2e 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103102:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103109:	3c 01                	cmp    $0x1,%al
8010310b:	0f 95 c2             	setne  %dl
8010310e:	3c 04                	cmp    $0x4,%al
80103110:	0f 95 c0             	setne  %al
80103113:	20 c2                	and    %al,%dl
80103115:	0f 85 15 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010311b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103122:	66 85 ff             	test   %di,%di
80103125:	74 1a                	je     80103141 <mpinit+0xc1>
80103127:	89 f0                	mov    %esi,%eax
80103129:	01 f7                	add    %esi,%edi
  sum = 0;
8010312b:	31 d2                	xor    %edx,%edx
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103130:	0f b6 08             	movzbl (%eax),%ecx
80103133:	83 c0 01             	add    $0x1,%eax
80103136:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103138:	39 c7                	cmp    %eax,%edi
8010313a:	75 f4                	jne    80103130 <mpinit+0xb0>
8010313c:	84 d2                	test   %dl,%dl
8010313e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103141:	85 f6                	test   %esi,%esi
80103143:	0f 84 e7 00 00 00    	je     80103230 <mpinit+0x1b0>
80103149:	84 d2                	test   %dl,%dl
8010314b:	0f 85 df 00 00 00    	jne    80103230 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103151:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103157:	a3 fc 3b 11 80       	mov    %eax,0x80113bfc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103163:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103169:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010316e:	01 d6                	add    %edx,%esi
80103170:	39 c6                	cmp    %eax,%esi
80103172:	76 23                	jbe    80103197 <mpinit+0x117>
    switch(*p){
80103174:	0f b6 10             	movzbl (%eax),%edx
80103177:	80 fa 04             	cmp    $0x4,%dl
8010317a:	0f 87 ca 00 00 00    	ja     8010324a <mpinit+0x1ca>
80103180:	ff 24 95 9c 7d 10 80 	jmp    *-0x7fef8264(,%edx,4)
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103190:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103193:	39 c6                	cmp    %eax,%esi
80103195:	77 dd                	ja     80103174 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103197:	85 db                	test   %ebx,%ebx
80103199:	0f 84 9e 00 00 00    	je     8010323d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031a6:	74 15                	je     801031bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ad:	ba 22 00 00 00       	mov    $0x22,%edx
801031b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b3:	ba 23 00 00 00       	mov    $0x23,%edx
801031b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bc:	ee                   	out    %al,(%dx)
  }
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031c8:	8b 0d 80 42 11 80    	mov    0x80114280,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 80 42 11 80    	mov    %ecx,0x80114280
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e6:	88 97 00 3d 11 80    	mov    %dl,-0x7feec300(%edi)
      p += sizeof(struct mpproc);
801031ec:	83 c0 14             	add    $0x14,%eax
      continue;
801031ef:	e9 7c ff ff ff       	jmp    80103170 <mpinit+0xf0>
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ff:	88 15 e0 3c 11 80    	mov    %dl,0x80113ce0
      continue;
80103205:	e9 66 ff ff ff       	jmp    80103170 <mpinit+0xf0>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103210:	ba 00 00 01 00       	mov    $0x10000,%edx
80103215:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010321a:	e8 e1 fd ff ff       	call   80103000 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103224:	0f 85 a9 fe ff ff    	jne    801030d3 <mpinit+0x53>
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103230:	83 ec 0c             	sub    $0xc,%esp
80103233:	68 5d 7d 10 80       	push   $0x80107d5d
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 7c 7d 10 80       	push   $0x80107d7c
80103245:	e8 46 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010324a:	31 db                	xor    %ebx,%ebx
8010324c:	e9 26 ff ff ff       	jmp    80103177 <mpinit+0xf7>
80103251:	66 90                	xchg   %ax,%ax
80103253:	66 90                	xchg   %ax,%ax
80103255:	66 90                	xchg   %ax,%ax
80103257:	66 90                	xchg   %ax,%ax
80103259:	66 90                	xchg   %ax,%ax
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103260:	55                   	push   %ebp
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	ba 21 00 00 00       	mov    $0x21,%edx
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	ee                   	out    %al,(%dx)
8010326e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103273:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103274:	5d                   	pop    %ebp
80103275:	c3                   	ret    
80103276:	66 90                	xchg   %ax,%ax
80103278:	66 90                	xchg   %ax,%ax
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010328f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010329b:	e8 e0 da ff ff       	call   80100d80 <filealloc>
801032a0:	85 c0                	test   %eax,%eax
801032a2:	89 03                	mov    %eax,(%ebx)
801032a4:	74 22                	je     801032c8 <pipealloc+0x48>
801032a6:	e8 d5 da ff ff       	call   80100d80 <filealloc>
801032ab:	85 c0                	test   %eax,%eax
801032ad:	89 06                	mov    %eax,(%esi)
801032af:	74 3f                	je     801032f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032b1:	e8 0a f2 ff ff       	call   801024c0 <kalloc>
801032b6:	85 c0                	test   %eax,%eax
801032b8:	89 c7                	mov    %eax,%edi
801032ba:	75 54                	jne    80103310 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032bc:	8b 03                	mov    (%ebx),%eax
801032be:	85 c0                	test   %eax,%eax
801032c0:	75 34                	jne    801032f6 <pipealloc+0x76>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032c8:	8b 06                	mov    (%esi),%eax
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 0c                	je     801032da <pipealloc+0x5a>
    fileclose(*f1);
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	50                   	push   %eax
801032d2:	e8 69 db ff ff       	call   80100e40 <fileclose>
801032d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032e2:	5b                   	pop    %ebx
801032e3:	5e                   	pop    %esi
801032e4:	5f                   	pop    %edi
801032e5:	5d                   	pop    %ebp
801032e6:	c3                   	ret    
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032f0:	8b 03                	mov    (%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 e4                	je     801032da <pipealloc+0x5a>
    fileclose(*f0);
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	50                   	push   %eax
801032fa:	e8 41 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103301:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103304:	85 c0                	test   %eax,%eax
80103306:	75 c6                	jne    801032ce <pipealloc+0x4e>
80103308:	eb d0                	jmp    801032da <pipealloc+0x5a>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103310:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103313:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010331a:	00 00 00 
  p->writeopen = 1;
8010331d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103324:	00 00 00 
  p->nwrite = 0;
80103327:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010332e:	00 00 00 
  p->nread = 0;
80103331:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103338:	00 00 00 
  initlock(&p->lock, "pipe");
8010333b:	68 b0 7d 10 80       	push   $0x80107db0
80103340:	50                   	push   %eax
80103341:	e8 2a 17 00 00       	call   80104a70 <initlock>
  (*f0)->type = FD_PIPE;
80103346:	8b 03                	mov    (%ebx),%eax
  return 0;
80103348:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010334b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103351:	8b 03                	mov    (%ebx),%eax
80103353:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103357:	8b 03                	mov    (%ebx),%eax
80103359:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103362:	8b 06                	mov    (%esi),%eax
80103364:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010336a:	8b 06                	mov    (%esi),%eax
8010336c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103370:	8b 06                	mov    (%esi),%eax
80103372:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103376:	8b 06                	mov    (%esi),%eax
80103378:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010337b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010337e:	31 c0                	xor    %eax,%eax
}
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret    
80103385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	56                   	push   %esi
80103394:	53                   	push   %ebx
80103395:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103398:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	53                   	push   %ebx
8010339f:	e8 0c 18 00 00       	call   80104bb0 <acquire>
  if(writable){
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 f6                	test   %esi,%esi
801033a9:	74 45                	je     801033f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033bb:	00 00 00 
    wakeup(&p->nread);
801033be:	50                   	push   %eax
801033bf:	e8 1c 09 00 00       	call   80103ce0 <wakeup>
801033c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cd:	85 d2                	test   %edx,%edx
801033cf:	75 0a                	jne    801033db <pipeclose+0x4b>
801033d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033d7:	85 c0                	test   %eax,%eax
801033d9:	74 35                	je     80103410 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e1:	5b                   	pop    %ebx
801033e2:	5e                   	pop    %esi
801033e3:	5d                   	pop    %ebp
    release(&p->lock);
801033e4:	e9 87 18 00 00       	jmp    80104c70 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 d7 08 00 00       	call   80103ce0 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 57 18 00 00       	call   80104c70 <release>
    kfree((char*)p);
80103419:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010341c:	83 c4 10             	add    $0x10,%esp
}
8010341f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5d                   	pop    %ebp
    kfree((char*)p);
80103425:	e9 e6 ee ff ff       	jmp    80102310 <kfree>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103430 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 28             	sub    $0x28,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010343c:	53                   	push   %ebx
8010343d:	e8 6e 17 00 00       	call   80104bb0 <acquire>
  for(i = 0; i < n; i++){
80103442:	8b 45 10             	mov    0x10(%ebp),%eax
80103445:	83 c4 10             	add    $0x10,%esp
80103448:	85 c0                	test   %eax,%eax
8010344a:	0f 8e c9 00 00 00    	jle    80103519 <pipewrite+0xe9>
80103450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103453:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103459:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010345f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103462:	03 4d 10             	add    0x10(%ebp),%ecx
80103465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103468:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010346e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103474:	39 d0                	cmp    %edx,%eax
80103476:	75 71                	jne    801034e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103478:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	74 4e                	je     801034d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103482:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103488:	eb 3a                	jmp    801034c4 <pipewrite+0x94>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	57                   	push   %edi
80103494:	e8 47 08 00 00       	call   80103ce0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 5e 05 00 00       	call   80103a00 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ae:	83 c4 10             	add    $0x10,%esp
801034b1:	05 00 02 00 00       	add    $0x200,%eax
801034b6:	39 c2                	cmp    %eax,%edx
801034b8:	75 36                	jne    801034f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034c0:	85 c0                	test   %eax,%eax
801034c2:	74 0c                	je     801034d0 <pipewrite+0xa0>
801034c4:	e8 87 02 00 00       	call   80103750 <myproc>
801034c9:	8b 40 24             	mov    0x24(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 97 17 00 00       	call   80104c70 <release>
        return -1;
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034f3:	8d 42 01             	lea    0x1(%edx),%eax
801034f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103502:	83 c6 01             	add    $0x1,%esi
80103505:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103509:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010350c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010350f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103513:	0f 85 4f ff ff ff    	jne    80103468 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103519:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	50                   	push   %eax
80103523:	e8 b8 07 00 00       	call   80103ce0 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 40 17 00 00       	call   80104c70 <release>
  return n;
80103530:	83 c4 10             	add    $0x10,%esp
80103533:	8b 45 10             	mov    0x10(%ebp),%eax
80103536:	eb a9                	jmp    801034e1 <pipewrite+0xb1>
80103538:	90                   	nop
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103540 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 18             	sub    $0x18,%esp
80103549:	8b 75 08             	mov    0x8(%ebp),%esi
8010354c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010354f:	56                   	push   %esi
80103550:	e8 5b 16 00 00       	call   80104bb0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010355e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103564:	75 6a                	jne    801035d0 <piperead+0x90>
80103566:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010356c:	85 db                	test   %ebx,%ebx
8010356e:	0f 84 c4 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103574:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010357a:	eb 2d                	jmp    801035a9 <piperead+0x69>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103580:	83 ec 08             	sub    $0x8,%esp
80103583:	56                   	push   %esi
80103584:	53                   	push   %ebx
80103585:	e8 76 04 00 00       	call   80103a00 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
801035a9:	e8 a2 01 00 00       	call   80103750 <myproc>
801035ae:	8b 48 24             	mov    0x24(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 ad 16 00 00       	call   80104c70 <release>
      return -1;
801035c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c9:	89 d8                	mov    %ebx,%eax
801035cb:	5b                   	pop    %ebx
801035cc:	5e                   	pop    %esi
801035cd:	5f                   	pop    %edi
801035ce:	5d                   	pop    %ebp
801035cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 45 10             	mov    0x10(%ebp),%eax
801035d3:	85 c0                	test   %eax,%eax
801035d5:	7e 61                	jle    80103638 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035d7:	31 db                	xor    %ebx,%ebx
801035d9:	eb 13                	jmp    801035ee <piperead+0xae>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ec:	74 1f                	je     8010360d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ee:	8d 41 01             	lea    0x1(%ecx),%eax
801035f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103602:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103605:	83 c3 01             	add    $0x1,%ebx
80103608:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010360b:	75 d3                	jne    801035e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	50                   	push   %eax
80103617:	e8 c4 06 00 00       	call   80103ce0 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 4c 16 00 00       	call   80104c70 <release>
  return i;
80103624:	83 c4 10             	add    $0x10,%esp
}
80103627:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362a:	89 d8                	mov    %ebx,%eax
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	31 db                	xor    %ebx,%ebx
8010363a:	eb d1                	jmp    8010360d <piperead+0xcd>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103646:	68 a0 42 11 80       	push   $0x801142a0
8010364b:	e8 20 16 00 00       	call   80104c70 <release>

  if (first) {
80103650:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103655:	83 c4 10             	add    $0x10,%esp
80103658:	85 c0                	test   %eax,%eax
8010365a:	75 04                	jne    80103660 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010365c:	c9                   	leave  
8010365d:	c3                   	ret    
8010365e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103660:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103663:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010366a:	00 00 00 
    iinit(ROOTDEV);
8010366d:	6a 01                	push   $0x1
8010366f:	e8 0c de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103674:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010367b:	e8 80 f4 ff ff       	call   80102b00 <initlog>
80103680:	83 c4 10             	add    $0x10,%esp
}
80103683:	c9                   	leave  
80103684:	c3                   	ret    
80103685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103690 <pinit>:
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103696:	68 b5 7d 10 80       	push   $0x80107db5
8010369b:	68 a0 42 11 80       	push   $0x801142a0
801036a0:	e8 cb 13 00 00       	call   80104a70 <initlock>
}
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	c9                   	leave  
801036a9:	c3                   	ret    
801036aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036b0 <mycpu>:
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	56                   	push   %esi
801036b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036b5:	9c                   	pushf  
801036b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801036b7:	f6 c4 02             	test   $0x2,%ah
801036ba:	75 5e                	jne    8010371a <mycpu+0x6a>
  apicid = lapicid();
801036bc:	e8 6f f0 ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801036c1:	8b 35 80 42 11 80    	mov    0x80114280,%esi
801036c7:	85 f6                	test   %esi,%esi
801036c9:	7e 42                	jle    8010370d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801036cb:	0f b6 15 00 3d 11 80 	movzbl 0x80113d00,%edx
801036d2:	39 d0                	cmp    %edx,%eax
801036d4:	74 30                	je     80103706 <mycpu+0x56>
801036d6:	b9 b0 3d 11 80       	mov    $0x80113db0,%ecx
  for (i = 0; i < ncpu; ++i) {
801036db:	31 d2                	xor    %edx,%edx
801036dd:	8d 76 00             	lea    0x0(%esi),%esi
801036e0:	83 c2 01             	add    $0x1,%edx
801036e3:	39 f2                	cmp    %esi,%edx
801036e5:	74 26                	je     8010370d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801036e7:	0f b6 19             	movzbl (%ecx),%ebx
801036ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801036f0:	39 c3                	cmp    %eax,%ebx
801036f2:	75 ec                	jne    801036e0 <mycpu+0x30>
801036f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801036fa:	05 00 3d 11 80       	add    $0x80113d00,%eax
}
801036ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103702:	5b                   	pop    %ebx
80103703:	5e                   	pop    %esi
80103704:	5d                   	pop    %ebp
80103705:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103706:	b8 00 3d 11 80       	mov    $0x80113d00,%eax
      return &cpus[i];
8010370b:	eb f2                	jmp    801036ff <mycpu+0x4f>
  panic("unknown apicid\n");
8010370d:	83 ec 0c             	sub    $0xc,%esp
80103710:	68 bc 7d 10 80       	push   $0x80107dbc
80103715:	e8 76 cc ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010371a:	83 ec 0c             	sub    $0xc,%esp
8010371d:	68 b0 7e 10 80       	push   $0x80107eb0
80103722:	e8 69 cc ff ff       	call   80100390 <panic>
80103727:	89 f6                	mov    %esi,%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103730 <cpuid>:
cpuid() {
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103736:	e8 75 ff ff ff       	call   801036b0 <mycpu>
8010373b:	2d 00 3d 11 80       	sub    $0x80113d00,%eax
}
80103740:	c9                   	leave  
  return mycpu()-cpus;
80103741:	c1 f8 04             	sar    $0x4,%eax
80103744:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010374a:	c3                   	ret    
8010374b:	90                   	nop
8010374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103750 <myproc>:
myproc(void) {
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
80103754:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103757:	e8 84 13 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010375c:	e8 4f ff ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103761:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103767:	e8 b4 13 00 00       	call   80104b20 <popcli>
}
8010376c:	83 c4 04             	add    $0x4,%esp
8010376f:	89 d8                	mov    %ebx,%eax
80103771:	5b                   	pop    %ebx
80103772:	5d                   	pop    %ebp
80103773:	c3                   	ret    
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <growproc>:
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
80103785:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103788:	e8 53 13 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010378d:	e8 1e ff ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103792:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103798:	e8 83 13 00 00       	call   80104b20 <popcli>
  if(n > 0){
8010379d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801037a0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801037a2:	7f 1c                	jg     801037c0 <growproc+0x40>
  } else if(n < 0){
801037a4:	75 3a                	jne    801037e0 <growproc+0x60>
  switchuvm(curproc);
801037a6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801037a9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801037ab:	53                   	push   %ebx
801037ac:	e8 df 39 00 00       	call   80107190 <switchuvm>
  return 0;
801037b1:	83 c4 10             	add    $0x10,%esp
801037b4:	31 c0                	xor    %eax,%eax
}
801037b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b9:	5b                   	pop    %ebx
801037ba:	5e                   	pop    %esi
801037bb:	5d                   	pop    %ebp
801037bc:	c3                   	ret    
801037bd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037c0:	83 ec 04             	sub    $0x4,%esp
801037c3:	01 c6                	add    %eax,%esi
801037c5:	56                   	push   %esi
801037c6:	50                   	push   %eax
801037c7:	ff 73 04             	pushl  0x4(%ebx)
801037ca:	e8 11 3c 00 00       	call   801073e0 <allocuvm>
801037cf:	83 c4 10             	add    $0x10,%esp
801037d2:	85 c0                	test   %eax,%eax
801037d4:	75 d0                	jne    801037a6 <growproc+0x26>
      return -1;
801037d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037db:	eb d9                	jmp    801037b6 <growproc+0x36>
801037dd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037e0:	83 ec 04             	sub    $0x4,%esp
801037e3:	01 c6                	add    %eax,%esi
801037e5:	56                   	push   %esi
801037e6:	50                   	push   %eax
801037e7:	ff 73 04             	pushl  0x4(%ebx)
801037ea:	e8 21 3d 00 00       	call   80107510 <deallocuvm>
801037ef:	83 c4 10             	add    $0x10,%esp
801037f2:	85 c0                	test   %eax,%eax
801037f4:	75 b0                	jne    801037a6 <growproc+0x26>
801037f6:	eb de                	jmp    801037d6 <growproc+0x56>
801037f8:	90                   	nop
801037f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103800 <sched>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
  pushcli();
80103805:	e8 d6 12 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010380a:	e8 a1 fe ff ff       	call   801036b0 <mycpu>
  p = c->proc;
8010380f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103815:	e8 06 13 00 00       	call   80104b20 <popcli>
  if(!holding(&ptable.lock))
8010381a:	83 ec 0c             	sub    $0xc,%esp
8010381d:	68 a0 42 11 80       	push   $0x801142a0
80103822:	e8 59 13 00 00       	call   80104b80 <holding>
80103827:	83 c4 10             	add    $0x10,%esp
8010382a:	85 c0                	test   %eax,%eax
8010382c:	74 4f                	je     8010387d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010382e:	e8 7d fe ff ff       	call   801036b0 <mycpu>
80103833:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010383a:	75 68                	jne    801038a4 <sched+0xa4>
  if(p->state == RUNNING)
8010383c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103840:	74 55                	je     80103897 <sched+0x97>
80103842:	9c                   	pushf  
80103843:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103844:	f6 c4 02             	test   $0x2,%ah
80103847:	75 41                	jne    8010388a <sched+0x8a>
  intena = mycpu()->intena;
80103849:	e8 62 fe ff ff       	call   801036b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010384e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103851:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103857:	e8 54 fe ff ff       	call   801036b0 <mycpu>
8010385c:	83 ec 08             	sub    $0x8,%esp
8010385f:	ff 70 04             	pushl  0x4(%eax)
80103862:	53                   	push   %ebx
80103863:	e8 93 16 00 00       	call   80104efb <swtch>
  mycpu()->intena = intena;
80103868:	e8 43 fe ff ff       	call   801036b0 <mycpu>
}
8010386d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103870:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103876:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103879:	5b                   	pop    %ebx
8010387a:	5e                   	pop    %esi
8010387b:	5d                   	pop    %ebp
8010387c:	c3                   	ret    
    panic("sched ptable.lock");
8010387d:	83 ec 0c             	sub    $0xc,%esp
80103880:	68 cc 7d 10 80       	push   $0x80107dcc
80103885:	e8 06 cb ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010388a:	83 ec 0c             	sub    $0xc,%esp
8010388d:	68 f8 7d 10 80       	push   $0x80107df8
80103892:	e8 f9 ca ff ff       	call   80100390 <panic>
    panic("sched running");
80103897:	83 ec 0c             	sub    $0xc,%esp
8010389a:	68 ea 7d 10 80       	push   $0x80107dea
8010389f:	e8 ec ca ff ff       	call   80100390 <panic>
    panic("sched locks");
801038a4:	83 ec 0c             	sub    $0xc,%esp
801038a7:	68 de 7d 10 80       	push   $0x80107dde
801038ac:	e8 df ca ff ff       	call   80100390 <panic>
801038b1:	eb 0d                	jmp    801038c0 <exit>
801038b3:	90                   	nop
801038b4:	90                   	nop
801038b5:	90                   	nop
801038b6:	90                   	nop
801038b7:	90                   	nop
801038b8:	90                   	nop
801038b9:	90                   	nop
801038ba:	90                   	nop
801038bb:	90                   	nop
801038bc:	90                   	nop
801038bd:	90                   	nop
801038be:	90                   	nop
801038bf:	90                   	nop

801038c0 <exit>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	57                   	push   %edi
801038c4:	56                   	push   %esi
801038c5:	53                   	push   %ebx
801038c6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801038c9:	e8 12 12 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
801038ce:	e8 dd fd ff ff       	call   801036b0 <mycpu>
  p = c->proc;
801038d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801038d9:	e8 42 12 00 00       	call   80104b20 <popcli>
  if(curproc == initproc)
801038de:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801038e4:	8d 5e 28             	lea    0x28(%esi),%ebx
801038e7:	8d 7e 68             	lea    0x68(%esi),%edi
801038ea:	0f 84 fc 00 00 00    	je     801039ec <exit+0x12c>
    if(curproc->ofile[fd]){
801038f0:	8b 03                	mov    (%ebx),%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	74 12                	je     80103908 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	50                   	push   %eax
801038fa:	e8 41 d5 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
801038ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010390b:	39 fb                	cmp    %edi,%ebx
8010390d:	75 e1                	jne    801038f0 <exit+0x30>
  begin_op();
8010390f:	e8 8c f2 ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80103914:	83 ec 0c             	sub    $0xc,%esp
80103917:	ff 76 68             	pushl  0x68(%esi)
8010391a:	e8 91 de ff ff       	call   801017b0 <iput>
  end_op();
8010391f:	e8 ec f2 ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80103924:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010392b:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80103932:	e8 79 12 00 00       	call   80104bb0 <acquire>
  wakeup1(curproc->parent);
80103937:	8b 56 14             	mov    0x14(%esi),%edx
8010393a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010393d:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
80103942:	eb 10                	jmp    80103954 <exit+0x94>
80103944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103948:	05 b0 00 00 00       	add    $0xb0,%eax
8010394d:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80103952:	73 1e                	jae    80103972 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103954:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103958:	75 ee                	jne    80103948 <exit+0x88>
8010395a:	3b 50 20             	cmp    0x20(%eax),%edx
8010395d:	75 e9                	jne    80103948 <exit+0x88>
    {  
      p->state = RUNNABLE;
8010395f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103966:	05 b0 00 00 00       	add    $0xb0,%eax
8010396b:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80103970:	72 e2                	jb     80103954 <exit+0x94>
      pq->parent = initproc;
80103972:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(pq = ptable.proc; pq < &ptable.proc[NPROC]; pq++){
80103978:	ba d4 42 11 80       	mov    $0x801142d4,%edx
8010397d:	eb 0f                	jmp    8010398e <exit+0xce>
8010397f:	90                   	nop
80103980:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80103986:	81 fa d4 6e 11 80    	cmp    $0x80116ed4,%edx
8010398c:	73 3a                	jae    801039c8 <exit+0x108>
    if(pq->parent == curproc){
8010398e:	39 72 14             	cmp    %esi,0x14(%edx)
80103991:	75 ed                	jne    80103980 <exit+0xc0>
      if(pq->state == ZOMBIE)
80103993:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      pq->parent = initproc;
80103997:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(pq->state == ZOMBIE)
8010399a:	75 e4                	jne    80103980 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010399c:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
801039a1:	eb 11                	jmp    801039b4 <exit+0xf4>
801039a3:	90                   	nop
801039a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039a8:	05 b0 00 00 00       	add    $0xb0,%eax
801039ad:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
801039b2:	73 cc                	jae    80103980 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801039b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801039b8:	75 ee                	jne    801039a8 <exit+0xe8>
801039ba:	3b 48 20             	cmp    0x20(%eax),%ecx
801039bd:	75 e9                	jne    801039a8 <exit+0xe8>
      p->state = RUNNABLE;
801039bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801039c6:	eb e0                	jmp    801039a8 <exit+0xe8>
  curproc->end_time = ticks;
801039c8:	a1 20 77 11 80       	mov    0x80117720,%eax
  curproc->state = ZOMBIE;
801039cd:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  curproc->end_time = ticks;
801039d4:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
  sched();
801039da:	e8 21 fe ff ff       	call   80103800 <sched>
  panic("zombie exit");
801039df:	83 ec 0c             	sub    $0xc,%esp
801039e2:	68 19 7e 10 80       	push   $0x80107e19
801039e7:	e8 a4 c9 ff ff       	call   80100390 <panic>
    panic("init exiting");
801039ec:	83 ec 0c             	sub    $0xc,%esp
801039ef:	68 0c 7e 10 80       	push   $0x80107e0c
801039f4:	e8 97 c9 ff ff       	call   80100390 <panic>
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a00 <sleep>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	57                   	push   %edi
80103a04:	56                   	push   %esi
80103a05:	53                   	push   %ebx
80103a06:	83 ec 0c             	sub    $0xc,%esp
80103a09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103a0f:	e8 cc 10 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103a14:	e8 97 fc ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103a19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a1f:	e8 fc 10 00 00       	call   80104b20 <popcli>
  if(p == 0)
80103a24:	85 db                	test   %ebx,%ebx
80103a26:	0f 84 87 00 00 00    	je     80103ab3 <sleep+0xb3>
  if(lk == 0)
80103a2c:	85 f6                	test   %esi,%esi
80103a2e:	74 76                	je     80103aa6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103a30:	81 fe a0 42 11 80    	cmp    $0x801142a0,%esi
80103a36:	74 50                	je     80103a88 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103a38:	83 ec 0c             	sub    $0xc,%esp
80103a3b:	68 a0 42 11 80       	push   $0x801142a0
80103a40:	e8 6b 11 00 00       	call   80104bb0 <acquire>
    release(lk);
80103a45:	89 34 24             	mov    %esi,(%esp)
80103a48:	e8 23 12 00 00       	call   80104c70 <release>
  p->chan = chan;
80103a4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103a50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103a57:	e8 a4 fd ff ff       	call   80103800 <sched>
  p->chan = 0;
80103a5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103a63:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80103a6a:	e8 01 12 00 00       	call   80104c70 <release>
    acquire(lk);
80103a6f:	89 75 08             	mov    %esi,0x8(%ebp)
80103a72:	83 c4 10             	add    $0x10,%esp
}
80103a75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a78:	5b                   	pop    %ebx
80103a79:	5e                   	pop    %esi
80103a7a:	5f                   	pop    %edi
80103a7b:	5d                   	pop    %ebp
    acquire(lk);
80103a7c:	e9 2f 11 00 00       	jmp    80104bb0 <acquire>
80103a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103a88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103a8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103a92:	e8 69 fd ff ff       	call   80103800 <sched>
  p->chan = 0;
80103a97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aa1:	5b                   	pop    %ebx
80103aa2:	5e                   	pop    %esi
80103aa3:	5f                   	pop    %edi
80103aa4:	5d                   	pop    %ebp
80103aa5:	c3                   	ret    
    panic("sleep without lk");
80103aa6:	83 ec 0c             	sub    $0xc,%esp
80103aa9:	68 2b 7e 10 80       	push   $0x80107e2b
80103aae:	e8 dd c8 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ab3:	83 ec 0c             	sub    $0xc,%esp
80103ab6:	68 25 7e 10 80       	push   $0x80107e25
80103abb:	e8 d0 c8 ff ff       	call   80100390 <panic>

80103ac0 <wait>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
  pushcli();
80103ac5:	e8 16 10 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103aca:	e8 e1 fb ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103acf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ad5:	e8 46 10 00 00       	call   80104b20 <popcli>
  acquire(&ptable.lock);
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	68 a0 42 11 80       	push   $0x801142a0
80103ae2:	e8 c9 10 00 00       	call   80104bb0 <acquire>
80103ae7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103aea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aec:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
80103af1:	eb 13                	jmp    80103b06 <wait+0x46>
80103af3:	90                   	nop
80103af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103afe:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80103b04:	73 1e                	jae    80103b24 <wait+0x64>
      if(p->parent != curproc)
80103b06:	39 73 14             	cmp    %esi,0x14(%ebx)
80103b09:	75 ed                	jne    80103af8 <wait+0x38>
      if(p->state == ZOMBIE){
80103b0b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103b0f:	74 37                	je     80103b48 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b11:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80103b17:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b1c:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80103b22:	72 e2                	jb     80103b06 <wait+0x46>
    if(!havekids || curproc->killed){
80103b24:	85 c0                	test   %eax,%eax
80103b26:	74 76                	je     80103b9e <wait+0xde>
80103b28:	8b 46 24             	mov    0x24(%esi),%eax
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	75 6f                	jne    80103b9e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103b2f:	83 ec 08             	sub    $0x8,%esp
80103b32:	68 a0 42 11 80       	push   $0x801142a0
80103b37:	56                   	push   %esi
80103b38:	e8 c3 fe ff ff       	call   80103a00 <sleep>
    havekids = 0;
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	eb a8                	jmp    80103aea <wait+0x2a>
80103b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103b48:	83 ec 0c             	sub    $0xc,%esp
80103b4b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103b4e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103b51:	e8 ba e7 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103b56:	5a                   	pop    %edx
80103b57:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103b5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103b61:	e8 da 39 00 00       	call   80107540 <freevm>
        release(&ptable.lock);
80103b66:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
        p->pid = 0;
80103b6d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103b74:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103b7b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103b7f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103b86:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103b8d:	e8 de 10 00 00       	call   80104c70 <release>
        return pid;
80103b92:	83 c4 10             	add    $0x10,%esp
}
80103b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b98:	89 f0                	mov    %esi,%eax
80103b9a:	5b                   	pop    %ebx
80103b9b:	5e                   	pop    %esi
80103b9c:	5d                   	pop    %ebp
80103b9d:	c3                   	ret    
      release(&ptable.lock);
80103b9e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ba1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103ba6:	68 a0 42 11 80       	push   $0x801142a0
80103bab:	e8 c0 10 00 00       	call   80104c70 <release>
      return -1;
80103bb0:	83 c4 10             	add    $0x10,%esp
80103bb3:	eb e0                	jmp    80103b95 <wait+0xd5>
80103bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <waitx>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx
  pushcli();
80103bc5:	e8 16 0f 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103bca:	e8 e1 fa ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103bcf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103bd5:	e8 46 0f 00 00       	call   80104b20 <popcli>
  acquire(&ptable.lock);
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	68 a0 42 11 80       	push   $0x801142a0
80103be2:	e8 c9 0f 00 00       	call   80104bb0 <acquire>
80103be7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103bea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bec:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
80103bf1:	eb 13                	jmp    80103c06 <waitx+0x46>
80103bf3:	90                   	nop
80103bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bf8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103bfe:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80103c04:	73 1e                	jae    80103c24 <waitx+0x64>
      if(p->parent != curproc)
80103c06:	39 73 14             	cmp    %esi,0x14(%ebx)
80103c09:	75 ed                	jne    80103bf8 <waitx+0x38>
      if(p->state == ZOMBIE){
80103c0b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103c0f:	74 3f                	je     80103c50 <waitx+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c11:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80103c17:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c1c:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80103c22:	72 e2                	jb     80103c06 <waitx+0x46>
    if(!havekids || curproc->killed){
80103c24:	85 c0                	test   %eax,%eax
80103c26:	0f 84 99 00 00 00    	je     80103cc5 <waitx+0x105>
80103c2c:	8b 46 24             	mov    0x24(%esi),%eax
80103c2f:	85 c0                	test   %eax,%eax
80103c31:	0f 85 8e 00 00 00    	jne    80103cc5 <waitx+0x105>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103c37:	83 ec 08             	sub    $0x8,%esp
80103c3a:	68 a0 42 11 80       	push   $0x801142a0
80103c3f:	56                   	push   %esi
80103c40:	e8 bb fd ff ff       	call   80103a00 <sleep>
    havekids = 0;
80103c45:	83 c4 10             	add    $0x10,%esp
80103c48:	eb a0                	jmp    80103bea <waitx+0x2a>
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103c50:	83 ec 0c             	sub    $0xc,%esp
80103c53:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103c56:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103c59:	e8 b2 e6 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103c5e:	5a                   	pop    %edx
80103c5f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103c62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103c69:	e8 d2 38 00 00       	call   80107540 <freevm>
        *rtime = p->run_time; // Assignment
80103c6e:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80103c74:	8b 45 0c             	mov    0xc(%ebp),%eax
        p->pid = 0;
80103c77:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103c7e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103c85:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103c89:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103c90:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        *rtime = p->run_time; // Assignment
80103c97:	89 10                	mov    %edx,(%eax)
        *wtime = (p->end_time - p->start_time) - (p->run_time); // Assignment
80103c99:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80103c9f:	2b 53 7c             	sub    0x7c(%ebx),%edx
80103ca2:	2b 93 84 00 00 00    	sub    0x84(%ebx),%edx
80103ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80103cab:	89 10                	mov    %edx,(%eax)
        release(&ptable.lock);
80103cad:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80103cb4:	e8 b7 0f 00 00       	call   80104c70 <release>
        return pid;
80103cb9:	83 c4 10             	add    $0x10,%esp
}
80103cbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cbf:	89 f0                	mov    %esi,%eax
80103cc1:	5b                   	pop    %ebx
80103cc2:	5e                   	pop    %esi
80103cc3:	5d                   	pop    %ebp
80103cc4:	c3                   	ret    
      release(&ptable.lock);
80103cc5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103cc8:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103ccd:	68 a0 42 11 80       	push   $0x801142a0
80103cd2:	e8 99 0f 00 00       	call   80104c70 <release>
      return -1;
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	eb e0                	jmp    80103cbc <waitx+0xfc>
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	53                   	push   %ebx
80103ce4:	83 ec 10             	sub    $0x10,%esp
80103ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103cea:	68 a0 42 11 80       	push   $0x801142a0
80103cef:	e8 bc 0e 00 00       	call   80104bb0 <acquire>
80103cf4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf7:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
80103cfc:	eb 0e                	jmp    80103d0c <wakeup+0x2c>
80103cfe:	66 90                	xchg   %ax,%ax
80103d00:	05 b0 00 00 00       	add    $0xb0,%eax
80103d05:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80103d0a:	73 1e                	jae    80103d2a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103d0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d10:	75 ee                	jne    80103d00 <wakeup+0x20>
80103d12:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d15:	75 e9                	jne    80103d00 <wakeup+0x20>
      p->state = RUNNABLE;
80103d17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d1e:	05 b0 00 00 00       	add    $0xb0,%eax
80103d23:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80103d28:	72 e2                	jb     80103d0c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103d2a:	c7 45 08 a0 42 11 80 	movl   $0x801142a0,0x8(%ebp)
}
80103d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d34:	c9                   	leave  
  release(&ptable.lock);
80103d35:	e9 36 0f 00 00       	jmp    80104c70 <release>
80103d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	83 ec 10             	sub    $0x10,%esp
80103d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103d4a:	68 a0 42 11 80       	push   $0x801142a0
80103d4f:	e8 5c 0e 00 00       	call   80104bb0 <acquire>
80103d54:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d57:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
80103d5c:	eb 0e                	jmp    80103d6c <kill+0x2c>
80103d5e:	66 90                	xchg   %ax,%ax
80103d60:	05 b0 00 00 00       	add    $0xb0,%eax
80103d65:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80103d6a:	73 34                	jae    80103da0 <kill+0x60>
    if(p->pid == pid){
80103d6c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103d6f:	75 ef                	jne    80103d60 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103d71:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103d75:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103d7c:	75 07                	jne    80103d85 <kill+0x45>
        p->state = RUNNABLE;
80103d7e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80103d85:	83 ec 0c             	sub    $0xc,%esp
80103d88:	68 a0 42 11 80       	push   $0x801142a0
80103d8d:	e8 de 0e 00 00       	call   80104c70 <release>
      return 0;
80103d92:	83 c4 10             	add    $0x10,%esp
80103d95:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103d97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d9a:	c9                   	leave  
80103d9b:	c3                   	ret    
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	68 a0 42 11 80       	push   $0x801142a0
80103da8:	e8 c3 0e 00 00       	call   80104c70 <release>
  return -1;
80103dad:	83 c4 10             	add    $0x10,%esp
80103db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103db8:	c9                   	leave  
80103db9:	c3                   	ret    
80103dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103dc0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc9:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
{
80103dce:	83 ec 3c             	sub    $0x3c,%esp
80103dd1:	eb 27                	jmp    80103dfa <procdump+0x3a>
80103dd3:	90                   	nop
80103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	68 03 82 10 80       	push   $0x80108203
80103de0:	e8 7b c8 ff ff       	call   80100660 <cprintf>
80103de5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103dee:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80103df4:	0f 83 86 00 00 00    	jae    80103e80 <procdump+0xc0>
    if(p->state == UNUSED)
80103dfa:	8b 43 0c             	mov    0xc(%ebx),%eax
80103dfd:	85 c0                	test   %eax,%eax
80103dff:	74 e7                	je     80103de8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e01:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103e04:	ba 3c 7e 10 80       	mov    $0x80107e3c,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e09:	77 11                	ja     80103e1c <procdump+0x5c>
80103e0b:	8b 14 85 d8 7e 10 80 	mov    -0x7fef8128(,%eax,4),%edx
      state = "???";
80103e12:	b8 3c 7e 10 80       	mov    $0x80107e3c,%eax
80103e17:	85 d2                	test   %edx,%edx
80103e19:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103e1c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e1f:	50                   	push   %eax
80103e20:	52                   	push   %edx
80103e21:	ff 73 10             	pushl  0x10(%ebx)
80103e24:	68 40 7e 10 80       	push   $0x80107e40
80103e29:	e8 32 c8 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80103e2e:	83 c4 10             	add    $0x10,%esp
80103e31:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103e35:	75 a1                	jne    80103dd8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103e37:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103e3a:	83 ec 08             	sub    $0x8,%esp
80103e3d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103e40:	50                   	push   %eax
80103e41:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e44:	8b 40 0c             	mov    0xc(%eax),%eax
80103e47:	83 c0 08             	add    $0x8,%eax
80103e4a:	50                   	push   %eax
80103e4b:	e8 40 0c 00 00       	call   80104a90 <getcallerpcs>
80103e50:	83 c4 10             	add    $0x10,%esp
80103e53:	90                   	nop
80103e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103e58:	8b 17                	mov    (%edi),%edx
80103e5a:	85 d2                	test   %edx,%edx
80103e5c:	0f 84 76 ff ff ff    	je     80103dd8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103e62:	83 ec 08             	sub    $0x8,%esp
80103e65:	83 c7 04             	add    $0x4,%edi
80103e68:	52                   	push   %edx
80103e69:	68 a1 78 10 80       	push   $0x801078a1
80103e6e:	e8 ed c7 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103e73:	83 c4 10             	add    $0x10,%esp
80103e76:	39 fe                	cmp    %edi,%esi
80103e78:	75 de                	jne    80103e58 <procdump+0x98>
80103e7a:	e9 59 ff ff ff       	jmp    80103dd8 <procdump+0x18>
80103e7f:	90                   	nop
  }
}
80103e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e83:	5b                   	pop    %ebx
80103e84:	5e                   	pop    %esi
80103e85:	5f                   	pop    %edi
80103e86:	5d                   	pop    %ebp
80103e87:	c3                   	ret    
80103e88:	90                   	nop
80103e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e90 <set_priority>:

  release(&ptable.lock);
}

int set_priority(int pid, int priority)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	53                   	push   %ebx
80103e94:	83 ec 10             	sub    $0x10,%esp
80103e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e9a:	68 a0 42 11 80       	push   $0x801142a0
80103e9f:	e8 0c 0d 00 00       	call   80104bb0 <acquire>
80103ea4:	83 c4 10             	add    $0x10,%esp

  int old_priority = -1;

  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea7:	ba d4 42 11 80       	mov    $0x801142d4,%edx
80103eac:	eb 10                	jmp    80103ebe <set_priority+0x2e>
80103eae:	66 90                	xchg   %ax,%ax
80103eb0:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80103eb6:	81 fa d4 6e 11 80    	cmp    $0x80116ed4,%edx
80103ebc:	73 32                	jae    80103ef0 <set_priority+0x60>
  {
    if(p -> pid == pid)
80103ebe:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103ec1:	75 ed                	jne    80103eb0 <set_priority+0x20>
    {
      old_priority = p -> priority;
      p -> priority = priority;
80103ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
      old_priority = p -> priority;
80103ec6:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
      p -> priority = priority;
80103ecc:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)
      break;
    }
  } 
  
  release(&ptable.lock);
80103ed2:	83 ec 0c             	sub    $0xc,%esp
80103ed5:	68 a0 42 11 80       	push   $0x801142a0
80103eda:	e8 91 0d 00 00       	call   80104c70 <release>

  return old_priority;
}
80103edf:	89 d8                	mov    %ebx,%eax
80103ee1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ee4:	c9                   	leave  
80103ee5:	c3                   	ret    
80103ee6:	8d 76 00             	lea    0x0(%esi),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int old_priority = -1;
80103ef0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ef5:	eb db                	jmp    80103ed2 <set_priority+0x42>
80103ef7:	89 f6                	mov    %esi,%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f00 <isEmpty>:

int isEmpty(int queueNo)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
    if(front[queueNo] == -1) 
80103f03:	8b 45 08             	mov    0x8(%ebp),%eax
    {
      return 1;
    }

    return 0;
}
80103f06:	5d                   	pop    %ebp
    if(front[queueNo] == -1) 
80103f07:	83 3c 85 60 14 11 80 	cmpl   $0xffffffff,-0x7feeeba0(,%eax,4)
80103f0e:	ff 
80103f0f:	0f 94 c0             	sete   %al
80103f12:	0f b6 c0             	movzbl %al,%eax
}
80103f15:	c3                   	ret    
80103f16:	8d 76 00             	lea    0x0(%esi),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <isFull>:

int isFull(int queueNo)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	8b 45 08             	mov    0x8(%ebp),%eax
    if((front[queueNo] == rear[queueNo] + 1) || (front[queueNo] == 0 && rear[queueNo] == NPROC-1)) 
80103f27:	8b 0c 85 c0 c5 10 80 	mov    -0x7fef3a40(,%eax,4),%ecx
80103f2e:	8b 14 85 60 14 11 80 	mov    -0x7feeeba0(,%eax,4),%edx
80103f35:	b8 01 00 00 00       	mov    $0x1,%eax
80103f3a:	8d 59 01             	lea    0x1(%ecx),%ebx
80103f3d:	39 da                	cmp    %ebx,%edx
80103f3f:	74 0f                	je     80103f50 <isFull+0x30>
80103f41:	83 f9 3f             	cmp    $0x3f,%ecx
80103f44:	0f 94 c1             	sete   %cl
80103f47:	31 c0                	xor    %eax,%eax
80103f49:	85 d2                	test   %edx,%edx
80103f4b:	0f 94 c0             	sete   %al
    {
      return 1;
80103f4e:	21 c8                	and    %ecx,%eax
    }

    return 0;
}
80103f50:	5b                   	pop    %ebx
80103f51:	5d                   	pop    %ebp
80103f52:	c3                   	ret    
80103f53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <push>:

void push(int queueNo, struct proc* cur)
{
80103f60:	55                   	push   %ebp
80103f61:	31 c9                	xor    %ecx,%ecx
80103f63:	89 e5                	mov    %esp,%ebp
80103f65:	57                   	push   %edi
80103f66:	56                   	push   %esi
80103f67:	53                   	push   %ebx
  // Check if the element to be pushed already exists in the queue
  for(int i = 0; i < 5; i++)
80103f68:	31 ff                	xor    %edi,%edi
{
80103f6a:	83 ec 1c             	sub    $0x1c,%esp
80103f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  {
    if(front[i] > rear[i])
80103f76:	8b 34 bd 60 14 11 80 	mov    -0x7feeeba0(,%edi,4),%esi
80103f7d:	8b 14 bd c0 c5 10 80 	mov    -0x7fef3a40(,%edi,4),%edx
80103f84:	39 d6                	cmp    %edx,%esi
80103f86:	0f 8f c4 00 00 00    	jg     80104050 <push+0xf0>
      }
    }

    else
    {
      for(int j = front[i]; j <= rear[i] && j >= 0; j++)
80103f8c:	85 f6                	test   %esi,%esi
80103f8e:	78 34                	js     80103fc4 <push+0x64>
      {
        if(queue[i][j] == cur)
80103f90:	89 f8                	mov    %edi,%eax
80103f92:	c1 e0 06             	shl    $0x6,%eax
80103f95:	01 f0                	add    %esi,%eax
80103f97:	39 1c 85 60 0f 11 80 	cmp    %ebx,-0x7feef0a0(,%eax,4)
80103f9e:	0f 84 9a 00 00 00    	je     8010403e <push+0xde>
      for(int j = front[i]; j <= rear[i] && j >= 0; j++)
80103fa4:	8d 46 01             	lea    0x1(%esi),%eax
80103fa7:	39 c2                	cmp    %eax,%edx
80103fa9:	7c 19                	jl     80103fc4 <push+0x64>
80103fab:	90                   	nop
80103fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(queue[i][j] == cur)
80103fb0:	39 9c 81 60 0f 11 80 	cmp    %ebx,-0x7feef0a0(%ecx,%eax,4)
80103fb7:	0f 84 81 00 00 00    	je     8010403e <push+0xde>
      for(int j = front[i]; j <= rear[i] && j >= 0; j++)
80103fbd:	83 c0 01             	add    $0x1,%eax
80103fc0:	39 c2                	cmp    %eax,%edx
80103fc2:	7d ec                	jge    80103fb0 <push+0x50>
  for(int i = 0; i < 5; i++)
80103fc4:	83 c7 01             	add    $0x1,%edi
80103fc7:	81 c1 00 01 00 00    	add    $0x100,%ecx
80103fcd:	83 ff 05             	cmp    $0x5,%edi
80103fd0:	75 a4                	jne    80103f76 <push+0x16>
    if((front[queueNo] == rear[queueNo] + 1) || (front[queueNo] == 0 && rear[queueNo] == NPROC-1)) 
80103fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103fd5:	8b 0c 85 c0 c5 10 80 	mov    -0x7fef3a40(,%eax,4),%ecx
80103fdc:	8b 14 85 60 14 11 80 	mov    -0x7feeeba0(,%eax,4),%edx
80103fe3:	8d 41 01             	lea    0x1(%ecx),%eax
80103fe6:	39 c2                	cmp    %eax,%edx
80103fe8:	0f 84 a3 00 00 00    	je     80104091 <push+0x131>
80103fee:	85 d2                	test   %edx,%edx
80103ff0:	0f 84 8a 00 00 00    	je     80104080 <push+0x120>

  else
  {
    cur -> cur_time = 0;
    
    if(front[queueNo] == -1)
80103ff6:	83 fa ff             	cmp    $0xffffffff,%edx
    cur -> cur_time = 0;
80103ff9:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80104000:	00 00 00 
    if(front[queueNo] == -1)
80104003:	75 0e                	jne    80104013 <push+0xb3>
    {
      front[queueNo] = 0;
80104005:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104008:	c7 04 bd 60 14 11 80 	movl   $0x0,-0x7feeeba0(,%edi,4)
8010400f:	00 00 00 00 
    }

    rear[queueNo]++;
    rear[queueNo]%=NPROC;
80104013:	99                   	cltd   
80104014:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104017:	c1 ea 1a             	shr    $0x1a,%edx
8010401a:	01 d0                	add    %edx,%eax
8010401c:	83 e0 3f             	and    $0x3f,%eax
    
    queue[queueNo][rear[queueNo]] = cur;
    sz[queueNo]++;
8010401f:	83 04 bd 74 14 11 80 	addl   $0x1,-0x7feeeb8c(,%edi,4)
80104026:	01 
    rear[queueNo]%=NPROC;
80104027:	29 d0                	sub    %edx,%eax
    queue[queueNo][rear[queueNo]] = cur;
80104029:	89 fa                	mov    %edi,%edx
8010402b:	c1 e2 06             	shl    $0x6,%edx
    rear[queueNo]%=NPROC;
8010402e:	89 04 bd c0 c5 10 80 	mov    %eax,-0x7fef3a40(,%edi,4)
    queue[queueNo][rear[queueNo]] = cur;
80104035:	01 d0                	add    %edx,%eax
80104037:	89 1c 85 60 0f 11 80 	mov    %ebx,-0x7feef0a0(,%eax,4)
  }
}
8010403e:	83 c4 1c             	add    $0x1c,%esp
80104041:	5b                   	pop    %ebx
80104042:	5e                   	pop    %esi
80104043:	5f                   	pop    %edi
80104044:	5d                   	pop    %ebp
80104045:	c3                   	ret    
80104046:	8d 76 00             	lea    0x0(%esi),%esi
80104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      for(int j = 0; j < NPROC; j++)
80104050:	31 c0                	xor    %eax,%eax
80104052:	eb 10                	jmp    80104064 <push+0x104>
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104058:	83 c0 01             	add    $0x1,%eax
8010405b:	83 f8 40             	cmp    $0x40,%eax
8010405e:	0f 84 60 ff ff ff    	je     80103fc4 <push+0x64>
        if(j >= front[i] || j <= rear[i])
80104064:	39 c6                	cmp    %eax,%esi
80104066:	7e 04                	jle    8010406c <push+0x10c>
80104068:	39 c2                	cmp    %eax,%edx
8010406a:	7c ec                	jl     80104058 <push+0xf8>
          if(queue[i][j] == cur)
8010406c:	39 9c 81 60 0f 11 80 	cmp    %ebx,-0x7feef0a0(%ecx,%eax,4)
80104073:	75 e3                	jne    80104058 <push+0xf8>
}
80104075:	83 c4 1c             	add    $0x1c,%esp
80104078:	5b                   	pop    %ebx
80104079:	5e                   	pop    %esi
8010407a:	5f                   	pop    %edi
8010407b:	5d                   	pop    %ebp
8010407c:	c3                   	ret    
8010407d:	8d 76 00             	lea    0x0(%esi),%esi
    if((front[queueNo] == rear[queueNo] + 1) || (front[queueNo] == 0 && rear[queueNo] == NPROC-1)) 
80104080:	83 f9 3f             	cmp    $0x3f,%ecx
80104083:	74 0c                	je     80104091 <push+0x131>
    cur -> cur_time = 0;
80104085:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
8010408c:	00 00 00 
8010408f:	eb 82                	jmp    80104013 <push+0xb3>
    cprintf("\n Error: Queue is Full\n");
80104091:	c7 45 08 49 7e 10 80 	movl   $0x80107e49,0x8(%ebp)
}
80104098:	83 c4 1c             	add    $0x1c,%esp
8010409b:	5b                   	pop    %ebx
8010409c:	5e                   	pop    %esi
8010409d:	5f                   	pop    %edi
8010409e:	5d                   	pop    %ebp
    cprintf("\n Error: Queue is Full\n");
8010409f:	e9 bc c5 ff ff       	jmp    80100660 <cprintf>
801040a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801040b0 <allocproc>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b5:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
  acquire(&ptable.lock);
801040ba:	83 ec 0c             	sub    $0xc,%esp
801040bd:	68 a0 42 11 80       	push   $0x801142a0
801040c2:	e8 e9 0a 00 00       	call   80104bb0 <acquire>
801040c7:	83 c4 10             	add    $0x10,%esp
801040ca:	eb 16                	jmp    801040e2 <allocproc+0x32>
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040d0:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801040d6:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
801040dc:	0f 83 2e 01 00 00    	jae    80104210 <allocproc+0x160>
    if(p->state == UNUSED)
801040e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801040e5:	85 c0                	test   %eax,%eax
801040e7:	75 e7                	jne    801040d0 <allocproc+0x20>
  p->pid = nextpid++;
801040e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->state = EMBRYO;
801040ee:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p -> end_time = 0;                              
801040f5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801040fc:	00 00 00 
  p -> run_time = 0;                               
801040ff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104106:	00 00 00 
  p -> wait_time = 0;                           
80104109:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104110:	00 00 00 
  p -> priority = 60;
80104113:	c7 83 8c 00 00 00 3c 	movl   $0x3c,0x8c(%ebx)
8010411a:	00 00 00 
  p->pid = nextpid++;
8010411d:	8d 50 01             	lea    0x1(%eax),%edx
80104120:	89 43 10             	mov    %eax,0x10(%ebx)
  p -> start_time = ticks;
80104123:	a1 20 77 11 80       	mov    0x80117720,%eax
  p -> queueNo = 0;
80104128:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010412f:	00 00 00 
  p -> cur_time = 0;
80104132:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80104139:	00 00 00 
  p->pid = nextpid++;
8010413c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p -> num_run = 0;
80104142:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80104149:	00 00 00 
  p -> start_time = ticks;
8010414c:	89 43 7c             	mov    %eax,0x7c(%ebx)
    p -> ticks[i] = 0;
8010414f:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80104156:	00 00 00 
  for(int i = 0; i < 5; i++) 
80104159:	31 c0                	xor    %eax,%eax
    p -> ticks[i] = 0;
8010415b:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80104162:	00 00 00 
80104165:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
8010416c:	00 00 00 
8010416f:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
80104176:	00 00 00 
80104179:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80104180:	00 00 00 
    if((front[queueNo] == rear[queueNo] + 1) || (front[queueNo] == 0 && rear[queueNo] == NPROC-1)) 
80104183:	8b 14 85 c0 c5 10 80 	mov    -0x7fef3a40(,%eax,4),%edx
8010418a:	8b 0c 85 60 14 11 80 	mov    -0x7feeeba0(,%eax,4),%ecx
80104191:	8d 72 01             	lea    0x1(%edx),%esi
80104194:	39 f1                	cmp    %esi,%ecx
80104196:	74 09                	je     801041a1 <allocproc+0xf1>
80104198:	83 fa 3f             	cmp    $0x3f,%edx
8010419b:	75 63                	jne    80104200 <allocproc+0x150>
8010419d:	85 c9                	test   %ecx,%ecx
8010419f:	75 5f                	jne    80104200 <allocproc+0x150>
  for(int i = 0; i < 5; i++) 
801041a1:	83 c0 01             	add    $0x1,%eax
801041a4:	83 f8 05             	cmp    $0x5,%eax
801041a7:	75 da                	jne    80104183 <allocproc+0xd3>
  release(&ptable.lock);
801041a9:	83 ec 0c             	sub    $0xc,%esp
801041ac:	68 a0 42 11 80       	push   $0x801142a0
801041b1:	e8 ba 0a 00 00       	call   80104c70 <release>
  if((p->kstack = kalloc()) == 0){
801041b6:	e8 05 e3 ff ff       	call   801024c0 <kalloc>
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	85 c0                	test   %eax,%eax
801041c0:	89 43 08             	mov    %eax,0x8(%ebx)
801041c3:	74 66                	je     8010422b <allocproc+0x17b>
  sp -= sizeof *p->tf;
801041c5:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
801041cb:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801041ce:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801041d3:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801041d6:	c7 40 14 a7 5f 10 80 	movl   $0x80105fa7,0x14(%eax)
  p->context = (struct context*)sp;
801041dd:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801041e0:	6a 14                	push   $0x14
801041e2:	6a 00                	push   $0x0
801041e4:	50                   	push   %eax
801041e5:	e8 d6 0a 00 00       	call   80104cc0 <memset>
  p->context->eip = (uint)forkret;
801041ea:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
801041ed:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801041f0:	c7 40 10 40 36 10 80 	movl   $0x80103640,0x10(%eax)
}
801041f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041fa:	89 d8                	mov    %ebx,%eax
801041fc:	5b                   	pop    %ebx
801041fd:	5e                   	pop    %esi
801041fe:	5d                   	pop    %ebp
801041ff:	c3                   	ret    
      push(i, p);
80104200:	83 ec 08             	sub    $0x8,%esp
80104203:	53                   	push   %ebx
80104204:	50                   	push   %eax
80104205:	e8 56 fd ff ff       	call   80103f60 <push>
      break;
8010420a:	83 c4 10             	add    $0x10,%esp
8010420d:	eb 9a                	jmp    801041a9 <allocproc+0xf9>
8010420f:	90                   	nop
  release(&ptable.lock);
80104210:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104213:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104215:	68 a0 42 11 80       	push   $0x801142a0
8010421a:	e8 51 0a 00 00       	call   80104c70 <release>
  return 0;
8010421f:	83 c4 10             	add    $0x10,%esp
}
80104222:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104225:	89 d8                	mov    %ebx,%eax
80104227:	5b                   	pop    %ebx
80104228:	5e                   	pop    %esi
80104229:	5d                   	pop    %ebp
8010422a:	c3                   	ret    
    p->state = UNUSED;
8010422b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104232:	31 db                	xor    %ebx,%ebx
80104234:	eb c1                	jmp    801041f7 <allocproc+0x147>
80104236:	8d 76 00             	lea    0x0(%esi),%esi
80104239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104240 <userinit>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104247:	e8 64 fe ff ff       	call   801040b0 <allocproc>
8010424c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010424e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104253:	e8 68 33 00 00       	call   801075c0 <setupkvm>
80104258:	85 c0                	test   %eax,%eax
8010425a:	89 43 04             	mov    %eax,0x4(%ebx)
8010425d:	0f 84 bd 00 00 00    	je     80104320 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104263:	83 ec 04             	sub    $0x4,%esp
80104266:	68 2c 00 00 00       	push   $0x2c
8010426b:	68 60 b4 10 80       	push   $0x8010b460
80104270:	50                   	push   %eax
80104271:	e8 2a 30 00 00       	call   801072a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104276:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104279:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010427f:	6a 4c                	push   $0x4c
80104281:	6a 00                	push   $0x0
80104283:	ff 73 18             	pushl  0x18(%ebx)
80104286:	e8 35 0a 00 00       	call   80104cc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010428b:	8b 43 18             	mov    0x18(%ebx),%eax
8010428e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104293:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104298:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010429b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010429f:	8b 43 18             	mov    0x18(%ebx),%eax
801042a2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042a6:	8b 43 18             	mov    0x18(%ebx),%eax
801042a9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042ad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801042b1:	8b 43 18             	mov    0x18(%ebx),%eax
801042b4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042b8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801042bc:	8b 43 18             	mov    0x18(%ebx),%eax
801042bf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801042c6:	8b 43 18             	mov    0x18(%ebx),%eax
801042c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801042d0:	8b 43 18             	mov    0x18(%ebx),%eax
801042d3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042da:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042dd:	6a 10                	push   $0x10
801042df:	68 7a 7e 10 80       	push   $0x80107e7a
801042e4:	50                   	push   %eax
801042e5:	e8 b6 0b 00 00       	call   80104ea0 <safestrcpy>
  p->cwd = namei("/");
801042ea:	c7 04 24 83 7e 10 80 	movl   $0x80107e83,(%esp)
801042f1:	e8 ea db ff ff       	call   80101ee0 <namei>
801042f6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801042f9:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80104300:	e8 ab 08 00 00       	call   80104bb0 <acquire>
  p->state = RUNNABLE;
80104305:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010430c:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80104313:	e8 58 09 00 00       	call   80104c70 <release>
}
80104318:	83 c4 10             	add    $0x10,%esp
8010431b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010431e:	c9                   	leave  
8010431f:	c3                   	ret    
    panic("userinit: out of memory?");
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	68 61 7e 10 80       	push   $0x80107e61
80104328:	e8 63 c0 ff ff       	call   80100390 <panic>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <fork>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104339:	e8 a2 07 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010433e:	e8 6d f3 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80104343:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104349:	e8 d2 07 00 00       	call   80104b20 <popcli>
  if((np = allocproc()) == 0){
8010434e:	e8 5d fd ff ff       	call   801040b0 <allocproc>
80104353:	85 c0                	test   %eax,%eax
80104355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104358:	0f 84 b7 00 00 00    	je     80104415 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010435e:	83 ec 08             	sub    $0x8,%esp
80104361:	ff 33                	pushl  (%ebx)
80104363:	ff 73 04             	pushl  0x4(%ebx)
80104366:	89 c7                	mov    %eax,%edi
80104368:	e8 23 33 00 00       	call   80107690 <copyuvm>
8010436d:	83 c4 10             	add    $0x10,%esp
80104370:	85 c0                	test   %eax,%eax
80104372:	89 47 04             	mov    %eax,0x4(%edi)
80104375:	0f 84 a1 00 00 00    	je     8010441c <fork+0xec>
  np->sz = curproc->sz;
8010437b:	8b 03                	mov    (%ebx),%eax
8010437d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104380:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80104382:	89 59 14             	mov    %ebx,0x14(%ecx)
80104385:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80104387:	8b 79 18             	mov    0x18(%ecx),%edi
8010438a:	8b 73 18             	mov    0x18(%ebx),%esi
8010438d:	b9 13 00 00 00       	mov    $0x13,%ecx
80104392:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104394:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104396:	8b 40 18             	mov    0x18(%eax),%eax
80104399:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801043a0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801043a4:	85 c0                	test   %eax,%eax
801043a6:	74 13                	je     801043bb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	50                   	push   %eax
801043ac:	e8 3f ca ff ff       	call   80100df0 <filedup>
801043b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043b4:	83 c4 10             	add    $0x10,%esp
801043b7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801043bb:	83 c6 01             	add    $0x1,%esi
801043be:	83 fe 10             	cmp    $0x10,%esi
801043c1:	75 dd                	jne    801043a0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801043c3:	83 ec 0c             	sub    $0xc,%esp
801043c6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043c9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801043cc:	e8 7f d2 ff ff       	call   80101650 <idup>
801043d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043d4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801043d7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043da:	8d 47 6c             	lea    0x6c(%edi),%eax
801043dd:	6a 10                	push   $0x10
801043df:	53                   	push   %ebx
801043e0:	50                   	push   %eax
801043e1:	e8 ba 0a 00 00       	call   80104ea0 <safestrcpy>
  pid = np->pid;
801043e6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801043e9:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
801043f0:	e8 bb 07 00 00       	call   80104bb0 <acquire>
  np->state = RUNNABLE;
801043f5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801043fc:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80104403:	e8 68 08 00 00       	call   80104c70 <release>
  return pid;
80104408:	83 c4 10             	add    $0x10,%esp
}
8010440b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010440e:	89 d8                	mov    %ebx,%eax
80104410:	5b                   	pop    %ebx
80104411:	5e                   	pop    %esi
80104412:	5f                   	pop    %edi
80104413:	5d                   	pop    %ebp
80104414:	c3                   	ret    
    return -1;
80104415:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010441a:	eb ef                	jmp    8010440b <fork+0xdb>
    kfree(np->kstack);
8010441c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010441f:	83 ec 0c             	sub    $0xc,%esp
80104422:	ff 73 08             	pushl  0x8(%ebx)
80104425:	e8 e6 de ff ff       	call   80102310 <kfree>
    np->kstack = 0;
8010442a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80104431:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104438:	83 c4 10             	add    $0x10,%esp
8010443b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104440:	eb c9                	jmp    8010440b <fork+0xdb>
80104442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104450 <yield>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80104455:	83 ec 0c             	sub    $0xc,%esp
80104458:	68 a0 42 11 80       	push   $0x801142a0
8010445d:	e8 4e 07 00 00       	call   80104bb0 <acquire>
  pushcli();
80104462:	e8 79 06 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80104467:	e8 44 f2 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
8010446c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104472:	e8 a9 06 00 00       	call   80104b20 <popcli>
  myproc()->state = RUNNABLE;
80104477:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
8010447e:	e8 5d 06 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80104483:	e8 28 f2 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80104488:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448e:	e8 8d 06 00 00       	call   80104b20 <popcli>
  myproc() -> cur_time = 0;
80104493:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
8010449a:	00 00 00 
  pushcli();
8010449d:	e8 3e 06 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
801044a2:	e8 09 f2 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
801044a7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044ad:	e8 6e 06 00 00       	call   80104b20 <popcli>
  myproc() -> queueNo++;
801044b2:	83 83 ac 00 00 00 01 	addl   $0x1,0xac(%ebx)
  pushcli();
801044b9:	e8 22 06 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
801044be:	e8 ed f1 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
801044c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044c9:	e8 52 06 00 00       	call   80104b20 <popcli>
  pushcli();
801044ce:	e8 0d 06 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
801044d3:	e8 d8 f1 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
801044d8:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044de:	e8 3d 06 00 00       	call   80104b20 <popcli>
  push(myproc() -> queueNo, myproc());
801044e3:	58                   	pop    %eax
801044e4:	5a                   	pop    %edx
801044e5:	56                   	push   %esi
801044e6:	ff b3 ac 00 00 00    	pushl  0xac(%ebx)
801044ec:	e8 6f fa ff ff       	call   80103f60 <push>
  sched();
801044f1:	e8 0a f3 ff ff       	call   80103800 <sched>
  release(&ptable.lock);
801044f6:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
801044fd:	e8 6e 07 00 00       	call   80104c70 <release>
}
80104502:	83 c4 10             	add    $0x10,%esp
80104505:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104508:	5b                   	pop    %ebx
80104509:	5e                   	pop    %esi
8010450a:	5d                   	pop    %ebp
8010450b:	c3                   	ret    
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104510 <modify_times>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104514:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
{
80104519:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010451c:	68 a0 42 11 80       	push   $0x801142a0
80104521:	e8 8a 06 00 00       	call   80104bb0 <acquire>
80104526:	83 c4 10             	add    $0x10,%esp
80104529:	eb 2b                	jmp    80104556 <modify_times+0x46>
8010452b:	90                   	nop
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p->wait_time++;
80104530:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80104536:	83 c0 01             	add    $0x1,%eax
      if(p -> queueNo != 0 && p -> wait_time > AGE) 
80104539:	83 f8 14             	cmp    $0x14,%eax
      p->wait_time++;
8010453c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
      if(p -> queueNo != 0 && p -> wait_time > AGE) 
80104542:	7e 04                	jle    80104548 <modify_times+0x38>
80104544:	85 d2                	test   %edx,%edx
80104546:	75 58                	jne    801045a0 <modify_times+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104548:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010454e:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80104554:	73 30                	jae    80104586 <modify_times+0x76>
  	if(p -> state == RUNNING)
80104556:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
8010455a:	8b 93 ac 00 00 00    	mov    0xac(%ebx),%edx
80104560:	75 ce                	jne    80104530 <modify_times+0x20>
      p -> run_time++;
80104562:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
      p -> ticks[p -> queueNo]++;
80104569:	83 84 93 98 00 00 00 	addl   $0x1,0x98(%ebx,%edx,4)
80104570:	01 
      p -> cur_time++;     
80104571:	83 83 94 00 00 00 01 	addl   $0x1,0x94(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104578:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010457e:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80104584:	72 d0                	jb     80104556 <modify_times+0x46>
  release(&ptable.lock);
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	68 a0 42 11 80       	push   $0x801142a0
8010458e:	e8 dd 06 00 00       	call   80104c70 <release>
}
80104593:	83 c4 10             	add    $0x10,%esp
80104596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104599:	c9                   	leave  
8010459a:	c3                   	ret    
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        push(p -> queueNo, p);
801045a0:	83 ec 08             	sub    $0x8,%esp
        p -> queueNo--;
801045a3:	83 ea 01             	sub    $0x1,%edx
        p -> cur_time = 0;
801045a6:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801045ad:	00 00 00 
        push(p -> queueNo, p);
801045b0:	53                   	push   %ebx
801045b1:	52                   	push   %edx
        p -> queueNo--;
801045b2:	89 93 ac 00 00 00    	mov    %edx,0xac(%ebx)
        p -> wait_time = 0;
801045b8:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801045bf:	00 00 00 
        push(p -> queueNo, p);
801045c2:	e8 99 f9 ff ff       	call   80103f60 <push>
801045c7:	83 c4 10             	add    $0x10,%esp
801045ca:	e9 79 ff ff ff       	jmp    80104548 <modify_times+0x38>
801045cf:	90                   	nop

801045d0 <scheduler>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801045d9:	e8 d2 f0 ff ff       	call   801036b0 <mycpu>
  c->proc = 0;
801045de:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801045e5:	00 00 00 
  struct cpu *c = mycpu();
801045e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801045eb:	83 c0 04             	add    $0x4,%eax
801045ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
801045f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801045f8:	fb                   	sti    
    acquire(&ptable.lock);
801045f9:	83 ec 0c             	sub    $0xc,%esp
    for(int i = 0; i < 5; i++)
801045fc:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
801045fe:	68 a0 42 11 80       	push   $0x801142a0
80104603:	e8 a8 05 00 00       	call   80104bb0 <acquire>
80104608:	83 c4 10             	add    $0x10,%esp
    if(front[queueNo] == -1) 
8010460b:	8b 04 9d 60 14 11 80 	mov    -0x7feeeba0(,%ebx,4),%eax
80104612:	83 f8 ff             	cmp    $0xffffffff,%eax
80104615:	0f 84 8d 00 00 00    	je     801046a8 <scheduler+0xd8>
        while(sz[i] > cursz)
8010461b:	8b 14 9d 74 14 11 80 	mov    -0x7feeeb8c(,%ebx,4),%edx
struct proc* pop(int queueNo)
{
  struct proc* cur = queue[queueNo][front[queueNo]];
80104622:	89 de                	mov    %ebx,%esi
        int cursz = 0;
80104624:	31 ff                	xor    %edi,%edi
  struct proc* cur = queue[queueNo][front[queueNo]];
80104626:	c1 e6 06             	shl    $0x6,%esi
        while(sz[i] > cursz)
80104629:	85 d2                	test   %edx,%edx
8010462b:	7f 4a                	jg     80104677 <scheduler+0xa7>
8010462d:	eb 79                	jmp    801046a8 <scheduler+0xd8>
8010462f:	90                   	nop
    rear[queueNo] = -1;
  }

  else
  {
    front[queueNo]++;
80104630:	83 c0 01             	add    $0x1,%eax
    front[queueNo]%=NPROC;
80104633:	99                   	cltd   
80104634:	c1 ea 1a             	shr    $0x1a,%edx
80104637:	01 d0                	add    %edx,%eax
80104639:	83 e0 3f             	and    $0x3f,%eax
8010463c:	29 d0                	sub    %edx,%eax
8010463e:	89 04 9d 60 14 11 80 	mov    %eax,-0x7feeeba0(,%ebx,4)
  }
  
  sz[queueNo]--;
80104645:	83 2c 9d 74 14 11 80 	subl   $0x1,-0x7feeeb8c(,%ebx,4)
8010464c:	01 
          cursz++;
8010464d:	83 c7 01             	add    $0x1,%edi
          if(p -> state != RUNNABLE)
80104650:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
80104654:	0f 84 a6 00 00 00    	je     80104700 <scheduler+0x130>
            push(i, p);
8010465a:	83 ec 08             	sub    $0x8,%esp
8010465d:	51                   	push   %ecx
8010465e:	53                   	push   %ebx
8010465f:	e8 fc f8 ff ff       	call   80103f60 <push>
        while(sz[i] > cursz)
80104664:	83 c4 10             	add    $0x10,%esp
80104667:	39 3c 9d 74 14 11 80 	cmp    %edi,-0x7feeeb8c(,%ebx,4)
8010466e:	7e 38                	jle    801046a8 <scheduler+0xd8>
80104670:	8b 04 9d 60 14 11 80 	mov    -0x7feeeba0(,%ebx,4),%eax
  if(front[queueNo] == rear[queueNo])
80104677:	39 04 9d c0 c5 10 80 	cmp    %eax,-0x7fef3a40(,%ebx,4)
  struct proc* cur = queue[queueNo][front[queueNo]];
8010467e:	8d 14 06             	lea    (%esi,%eax,1),%edx
80104681:	8b 0c 95 60 0f 11 80 	mov    -0x7feef0a0(,%edx,4),%ecx
  if(front[queueNo] == rear[queueNo])
80104688:	75 a6                	jne    80104630 <scheduler+0x60>
    front[queueNo] = -1;
8010468a:	c7 04 9d 60 14 11 80 	movl   $0xffffffff,-0x7feeeba0(,%ebx,4)
80104691:	ff ff ff ff 
    rear[queueNo] = -1;
80104695:	c7 04 9d c0 c5 10 80 	movl   $0xffffffff,-0x7fef3a40(,%ebx,4)
8010469c:	ff ff ff ff 
801046a0:	eb a3                	jmp    80104645 <scheduler+0x75>
801046a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(int i = 0; i < 5; i++)
801046a8:	83 c3 01             	add    $0x1,%ebx
801046ab:	83 fb 05             	cmp    $0x5,%ebx
801046ae:	0f 85 57 ff ff ff    	jne    8010460b <scheduler+0x3b>
        int cursz = 0;
801046b4:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(p -> pid == 0 || p->state != RUNNABLE)
801046c0:	8b 43 10             	mov    0x10(%ebx),%eax
801046c3:	85 c0                	test   %eax,%eax
801046c5:	74 14                	je     801046db <scheduler+0x10b>
801046c7:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801046cb:	75 0e                	jne    801046db <scheduler+0x10b>
        push(0, p);
801046cd:	83 ec 08             	sub    $0x8,%esp
801046d0:	53                   	push   %ebx
801046d1:	6a 00                	push   $0x0
801046d3:	e8 88 f8 ff ff       	call   80103f60 <push>
801046d8:	83 c4 10             	add    $0x10,%esp
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046db:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801046e1:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
801046e7:	72 d7                	jb     801046c0 <scheduler+0xf0>
    release(&ptable.lock);
801046e9:	83 ec 0c             	sub    $0xc,%esp
801046ec:	68 a0 42 11 80       	push   $0x801142a0
801046f1:	e8 7a 05 00 00       	call   80104c70 <release>
    sti();
801046f6:	83 c4 10             	add    $0x10,%esp
801046f9:	e9 fa fe ff ff       	jmp    801045f8 <scheduler+0x28>
801046fe:	66 90                	xchg   %ax,%ax
      c -> proc = p;
80104700:	8b 75 e0             	mov    -0x20(%ebp),%esi
      p -> num_run++;
80104703:	83 81 90 00 00 00 01 	addl   $0x1,0x90(%ecx)
      switchuvm(p);
8010470a:	83 ec 0c             	sub    $0xc,%esp
      p -> wait_time = 0;
8010470d:	c7 81 88 00 00 00 00 	movl   $0x0,0x88(%ecx)
80104714:	00 00 00 
      switchuvm(p);
80104717:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      c -> proc = p;
8010471a:	89 8e ac 00 00 00    	mov    %ecx,0xac(%esi)
      switchuvm(p);
80104720:	51                   	push   %ecx
80104721:	e8 6a 2a 00 00       	call   80107190 <switchuvm>
      p -> state = RUNNING;
80104726:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104729:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
      swtch(&(c->scheduler), p->context);
80104730:	5a                   	pop    %edx
80104731:	5b                   	pop    %ebx
80104732:	ff 71 1c             	pushl  0x1c(%ecx)
80104735:	ff 75 dc             	pushl  -0x24(%ebp)
80104738:	e8 be 07 00 00       	call   80104efb <swtch>
      switchkvm();
8010473d:	e8 2e 2a 00 00       	call   80107170 <switchkvm>
      c -> proc = 0;
80104742:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104749:	00 00 00 
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	e9 60 ff ff ff       	jmp    801046b4 <scheduler+0xe4>
80104754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010475a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104760 <pop>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct proc* cur = queue[queueNo][front[queueNo]];
80104767:	8b 14 8d 60 14 11 80 	mov    -0x7feeeba0(,%ecx,4),%edx
8010476e:	89 c8                	mov    %ecx,%eax
80104770:	c1 e0 06             	shl    $0x6,%eax
80104773:	01 d0                	add    %edx,%eax
  if(front[queueNo] == rear[queueNo])
80104775:	3b 14 8d c0 c5 10 80 	cmp    -0x7fef3a40(,%ecx,4),%edx
  struct proc* cur = queue[queueNo][front[queueNo]];
8010477c:	8b 04 85 60 0f 11 80 	mov    -0x7feef0a0(,%eax,4),%eax
  if(front[queueNo] == rear[queueNo])
80104783:	74 2b                	je     801047b0 <pop+0x50>
    front[queueNo]++;
80104785:	83 c2 01             	add    $0x1,%edx
  sz[queueNo]--;
80104788:	83 2c 8d 74 14 11 80 	subl   $0x1,-0x7feeeb8c(,%ecx,4)
8010478f:	01 
    front[queueNo]%=NPROC;
80104790:	89 d3                	mov    %edx,%ebx
80104792:	c1 fb 1f             	sar    $0x1f,%ebx
80104795:	c1 eb 1a             	shr    $0x1a,%ebx
80104798:	01 da                	add    %ebx,%edx
8010479a:	83 e2 3f             	and    $0x3f,%edx
8010479d:	29 da                	sub    %ebx,%edx
8010479f:	89 14 8d 60 14 11 80 	mov    %edx,-0x7feeeba0(,%ecx,4)

  return cur;
}
801047a6:	5b                   	pop    %ebx
801047a7:	5d                   	pop    %ebp
801047a8:	c3                   	ret    
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b0:	5b                   	pop    %ebx
    front[queueNo] = -1;
801047b1:	c7 04 8d 60 14 11 80 	movl   $0xffffffff,-0x7feeeba0(,%ecx,4)
801047b8:	ff ff ff ff 
    rear[queueNo] = -1;
801047bc:	c7 04 8d c0 c5 10 80 	movl   $0xffffffff,-0x7fef3a40(,%ecx,4)
801047c3:	ff ff ff ff 
  sz[queueNo]--;
801047c7:	83 2c 8d 74 14 11 80 	subl   $0x1,-0x7feeeb8c(,%ecx,4)
801047ce:	01 
}
801047cf:	5d                   	pop    %ebp
801047d0:	c3                   	ret    
801047d1:	eb 0d                	jmp    801047e0 <getpinfo>
801047d3:	90                   	nop
801047d4:	90                   	nop
801047d5:	90                   	nop
801047d6:	90                   	nop
801047d7:	90                   	nop
801047d8:	90                   	nop
801047d9:	90                   	nop
801047da:	90                   	nop
801047db:	90                   	nop
801047dc:	90                   	nop
801047dd:	90                   	nop
801047de:	90                   	nop
801047df:	90                   	nop

801047e0 <getpinfo>:

int getpinfo(int pid, struct proc_stat* pp)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	8b 75 0c             	mov    0xc(%ebp),%esi
801047e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801047eb:	83 ec 0c             	sub    $0xc,%esp
801047ee:	68 a0 42 11 80       	push   $0x801142a0
801047f3:	e8 b8 03 00 00       	call   80104bb0 <acquire>
801047f8:	83 c4 10             	add    $0x10,%esp

  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047fb:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
80104800:	eb 12                	jmp    80104814 <getpinfo+0x34>
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104808:	05 b0 00 00 00       	add    $0xb0,%eax
8010480d:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80104812:	73 6c                	jae    80104880 <getpinfo+0xa0>
  {
    if(p -> pid == pid)
80104814:	39 58 10             	cmp    %ebx,0x10(%eax)
80104817:	75 ef                	jne    80104808 <getpinfo+0x28>
    {
      pp -> pid = p -> pid;
80104819:	89 1e                	mov    %ebx,(%esi)
      pp -> num_run = p -> num_run;
8010481b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
      for(int i = 0; i < 5; i++)
      {
        pp -> ticks[i] = p -> ticks[i];
      }

      release(&ptable.lock);
80104821:	83 ec 0c             	sub    $0xc,%esp
      pp -> num_run = p -> num_run;
80104824:	89 56 08             	mov    %edx,0x8(%esi)
      pp -> current_queue = p -> queueNo;
80104827:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010482d:	89 56 0c             	mov    %edx,0xc(%esi)
      pp -> runtime = p -> run_time;
80104830:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104836:	89 56 04             	mov    %edx,0x4(%esi)
        pp -> ticks[i] = p -> ticks[i];
80104839:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010483f:	89 56 10             	mov    %edx,0x10(%esi)
80104842:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80104848:	89 56 14             	mov    %edx,0x14(%esi)
8010484b:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
80104851:	89 56 18             	mov    %edx,0x18(%esi)
80104854:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010485a:	89 56 1c             	mov    %edx,0x1c(%esi)
8010485d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104863:	89 46 20             	mov    %eax,0x20(%esi)
      release(&ptable.lock);
80104866:	68 a0 42 11 80       	push   $0x801142a0
8010486b:	e8 00 04 00 00       	call   80104c70 <release>
      return 1;
80104870:	83 c4 10             	add    $0x10,%esp
    }
  }

  release(&ptable.lock);
  return 0;
}
80104873:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 1;
80104876:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010487b:	5b                   	pop    %ebx
8010487c:	5e                   	pop    %esi
8010487d:	5d                   	pop    %ebp
8010487e:	c3                   	ret    
8010487f:	90                   	nop
  release(&ptable.lock);
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	68 a0 42 11 80       	push   $0x801142a0
80104888:	e8 e3 03 00 00       	call   80104c70 <release>
  return 0;
8010488d:	83 c4 10             	add    $0x10,%esp
}
80104890:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
80104893:	31 c0                	xor    %eax,%eax
}
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5d                   	pop    %ebp
80104898:	c3                   	ret    
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048a0 <checkPremption>:

int checkPremption(int priority, int f) 
{ 
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 10             	sub    $0x10,%esp
801048a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048aa:	68 a0 42 11 80       	push   $0x801142a0
801048af:	e8 fc 02 00 00       	call   80104bb0 <acquire>
  struct proc* p = 0;

  if(!f)
801048b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801048b7:	83 c4 10             	add    $0x10,%esp
  {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
801048ba:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
  if(!f)
801048bf:	85 d2                	test   %edx,%edx
801048c1:	75 49                	jne    8010490c <checkPremption+0x6c>
801048c3:	eb 0f                	jmp    801048d4 <checkPremption+0x34>
801048c5:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
801048c8:	05 b0 00 00 00       	add    $0xb0,%eax
801048cd:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
801048d2:	73 53                	jae    80104927 <checkPremption+0x87>
    {
      if(p -> pid != 0 && p -> priority < priority) 
801048d4:	8b 48 10             	mov    0x10(%eax),%ecx
801048d7:	85 c9                	test   %ecx,%ecx
801048d9:	74 ed                	je     801048c8 <checkPremption+0x28>
801048db:	39 98 8c 00 00 00    	cmp    %ebx,0x8c(%eax)
801048e1:	7d e5                	jge    801048c8 <checkPremption+0x28>
      {
        // cprintf("%d process with higher priority %d than %d found\n", p -> pid, p -> priority, priority);
        release(&ptable.lock);
801048e3:	83 ec 0c             	sub    $0xc,%esp
801048e6:	68 a0 42 11 80       	push   $0x801142a0
801048eb:	e8 80 03 00 00       	call   80104c70 <release>
        return 1;
801048f0:	83 c4 10             	add    $0x10,%esp
801048f3:	b8 01 00 00 00       	mov    $0x1,%eax
  }

  release(&ptable.lock);

  return 0; 
801048f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048fb:	c9                   	leave  
801048fc:	c3                   	ret    
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
80104900:	05 b0 00 00 00       	add    $0xb0,%eax
80104905:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
8010490a:	73 1b                	jae    80104927 <checkPremption+0x87>
      if(p -> pid != 0 && p -> priority <= priority) 
8010490c:	8b 50 10             	mov    0x10(%eax),%edx
8010490f:	85 d2                	test   %edx,%edx
80104911:	74 ed                	je     80104900 <checkPremption+0x60>
80104913:	39 98 8c 00 00 00    	cmp    %ebx,0x8c(%eax)
80104919:	7e c8                	jle    801048e3 <checkPremption+0x43>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
8010491b:	05 b0 00 00 00       	add    $0xb0,%eax
80104920:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80104925:	72 e5                	jb     8010490c <checkPremption+0x6c>
  release(&ptable.lock);
80104927:	83 ec 0c             	sub    $0xc,%esp
8010492a:	68 a0 42 11 80       	push   $0x801142a0
8010492f:	e8 3c 03 00 00       	call   80104c70 <release>
  return 0; 
80104934:	83 c4 10             	add    $0x10,%esp
80104937:	31 c0                	xor    %eax,%eax
80104939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010493c:	c9                   	leave  
8010493d:	c3                   	ret    
8010493e:	66 90                	xchg   %ax,%ax

80104940 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 0c             	sub    $0xc,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010494a:	68 f0 7e 10 80       	push   $0x80107ef0
8010494f:	8d 43 04             	lea    0x4(%ebx),%eax
80104952:	50                   	push   %eax
80104953:	e8 18 01 00 00       	call   80104a70 <initlock>
  lk->name = name;
80104958:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010495b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104961:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104964:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010496b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010496e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104971:	c9                   	leave  
80104972:	c3                   	ret    
80104973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	8d 73 04             	lea    0x4(%ebx),%esi
8010498e:	56                   	push   %esi
8010498f:	e8 1c 02 00 00       	call   80104bb0 <acquire>
  while (lk->locked) {
80104994:	8b 13                	mov    (%ebx),%edx
80104996:	83 c4 10             	add    $0x10,%esp
80104999:	85 d2                	test   %edx,%edx
8010499b:	74 16                	je     801049b3 <acquiresleep+0x33>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049a0:	83 ec 08             	sub    $0x8,%esp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	e8 56 f0 ff ff       	call   80103a00 <sleep>
  while (lk->locked) {
801049aa:	8b 03                	mov    (%ebx),%eax
801049ac:	83 c4 10             	add    $0x10,%esp
801049af:	85 c0                	test   %eax,%eax
801049b1:	75 ed                	jne    801049a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049b9:	e8 92 ed ff ff       	call   80103750 <myproc>
801049be:	8b 40 10             	mov    0x10(%eax),%eax
801049c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049ca:	5b                   	pop    %ebx
801049cb:	5e                   	pop    %esi
801049cc:	5d                   	pop    %ebp
  release(&lk->lk);
801049cd:	e9 9e 02 00 00       	jmp    80104c70 <release>
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ee:	56                   	push   %esi
801049ef:	e8 bc 01 00 00       	call   80104bb0 <acquire>
  lk->locked = 0;
801049f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a01:	89 1c 24             	mov    %ebx,(%esp)
80104a04:	e8 d7 f2 ff ff       	call   80103ce0 <wakeup>
  release(&lk->lk);
80104a09:	89 75 08             	mov    %esi,0x8(%ebp)
80104a0c:	83 c4 10             	add    $0x10,%esp
}
80104a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
  release(&lk->lk);
80104a15:	e9 56 02 00 00       	jmp    80104c70 <release>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	53                   	push   %ebx
80104a26:	31 ff                	xor    %edi,%edi
80104a28:	83 ec 18             	sub    $0x18,%esp
80104a2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a2e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a31:	56                   	push   %esi
80104a32:	e8 79 01 00 00       	call   80104bb0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a37:	8b 03                	mov    (%ebx),%eax
80104a39:	83 c4 10             	add    $0x10,%esp
80104a3c:	85 c0                	test   %eax,%eax
80104a3e:	74 13                	je     80104a53 <holdingsleep+0x33>
80104a40:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a43:	e8 08 ed ff ff       	call   80103750 <myproc>
80104a48:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a4b:	0f 94 c0             	sete   %al
80104a4e:	0f b6 c0             	movzbl %al,%eax
80104a51:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104a53:	83 ec 0c             	sub    $0xc,%esp
80104a56:	56                   	push   %esi
80104a57:	e8 14 02 00 00       	call   80104c70 <release>
  return r;
}
80104a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a5f:	89 f8                	mov    %edi,%eax
80104a61:	5b                   	pop    %ebx
80104a62:	5e                   	pop    %esi
80104a63:	5f                   	pop    %edi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a7f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret    
80104a8b:	90                   	nop
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a90:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a91:	31 d2                	xor    %edx,%edx
{
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a96:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a9c:	83 e8 08             	sub    $0x8,%eax
80104a9f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104aa0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104aa6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aac:	77 1a                	ja     80104ac8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aae:	8b 58 04             	mov    0x4(%eax),%ebx
80104ab1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ab4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ab7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ab9:	83 fa 0a             	cmp    $0xa,%edx
80104abc:	75 e2                	jne    80104aa0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104abe:	5b                   	pop    %ebx
80104abf:	5d                   	pop    %ebp
80104ac0:	c3                   	ret    
80104ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104acb:	83 c1 28             	add    $0x28,%ecx
80104ace:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ad6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ad9:	39 c1                	cmp    %eax,%ecx
80104adb:	75 f3                	jne    80104ad0 <getcallerpcs+0x40>
}
80104add:	5b                   	pop    %ebx
80104ade:	5d                   	pop    %ebp
80104adf:	c3                   	ret    

80104ae0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ae7:	9c                   	pushf  
80104ae8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ae9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104aea:	e8 c1 eb ff ff       	call   801036b0 <mycpu>
80104aef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af5:	85 c0                	test   %eax,%eax
80104af7:	75 11                	jne    80104b0a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104af9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104aff:	e8 ac eb ff ff       	call   801036b0 <mycpu>
80104b04:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b0a:	e8 a1 eb ff ff       	call   801036b0 <mycpu>
80104b0f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b16:	83 c4 04             	add    $0x4,%esp
80104b19:	5b                   	pop    %ebx
80104b1a:	5d                   	pop    %ebp
80104b1b:	c3                   	ret    
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b20 <popcli>:

void
popcli(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b26:	9c                   	pushf  
80104b27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b28:	f6 c4 02             	test   $0x2,%ah
80104b2b:	75 35                	jne    80104b62 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b2d:	e8 7e eb ff ff       	call   801036b0 <mycpu>
80104b32:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b39:	78 34                	js     80104b6f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b3b:	e8 70 eb ff ff       	call   801036b0 <mycpu>
80104b40:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b46:	85 d2                	test   %edx,%edx
80104b48:	74 06                	je     80104b50 <popcli+0x30>
    sti();
}
80104b4a:	c9                   	leave  
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b50:	e8 5b eb ff ff       	call   801036b0 <mycpu>
80104b55:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b5b:	85 c0                	test   %eax,%eax
80104b5d:	74 eb                	je     80104b4a <popcli+0x2a>
  asm volatile("sti");
80104b5f:	fb                   	sti    
}
80104b60:	c9                   	leave  
80104b61:	c3                   	ret    
    panic("popcli - interruptible");
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	68 fb 7e 10 80       	push   $0x80107efb
80104b6a:	e8 21 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b6f:	83 ec 0c             	sub    $0xc,%esp
80104b72:	68 12 7f 10 80       	push   $0x80107f12
80104b77:	e8 14 b8 ff ff       	call   80100390 <panic>
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b80 <holding>:
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 75 08             	mov    0x8(%ebp),%esi
80104b88:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b8a:	e8 51 ff ff ff       	call   80104ae0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b8f:	8b 06                	mov    (%esi),%eax
80104b91:	85 c0                	test   %eax,%eax
80104b93:	74 10                	je     80104ba5 <holding+0x25>
80104b95:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b98:	e8 13 eb ff ff       	call   801036b0 <mycpu>
80104b9d:	39 c3                	cmp    %eax,%ebx
80104b9f:	0f 94 c3             	sete   %bl
80104ba2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104ba5:	e8 76 ff ff ff       	call   80104b20 <popcli>
}
80104baa:	89 d8                	mov    %ebx,%eax
80104bac:	5b                   	pop    %ebx
80104bad:	5e                   	pop    %esi
80104bae:	5d                   	pop    %ebp
80104baf:	c3                   	ret    

80104bb0 <acquire>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104bb5:	e8 26 ff ff ff       	call   80104ae0 <pushcli>
  if(holding(lk))
80104bba:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bbd:	83 ec 0c             	sub    $0xc,%esp
80104bc0:	53                   	push   %ebx
80104bc1:	e8 ba ff ff ff       	call   80104b80 <holding>
80104bc6:	83 c4 10             	add    $0x10,%esp
80104bc9:	85 c0                	test   %eax,%eax
80104bcb:	0f 85 83 00 00 00    	jne    80104c54 <acquire+0xa4>
80104bd1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104bd3:	ba 01 00 00 00       	mov    $0x1,%edx
80104bd8:	eb 09                	jmp    80104be3 <acquire+0x33>
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104be0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104be3:	89 d0                	mov    %edx,%eax
80104be5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104be8:	85 c0                	test   %eax,%eax
80104bea:	75 f4                	jne    80104be0 <acquire+0x30>
  __sync_synchronize();
80104bec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104bf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bf4:	e8 b7 ea ff ff       	call   801036b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104bf9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104bfc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104bff:	89 e8                	mov    %ebp,%eax
80104c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c08:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104c0e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104c14:	77 1a                	ja     80104c30 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c16:	8b 48 04             	mov    0x4(%eax),%ecx
80104c19:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104c1c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c1f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c21:	83 fe 0a             	cmp    $0xa,%esi
80104c24:	75 e2                	jne    80104c08 <acquire+0x58>
}
80104c26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c29:	5b                   	pop    %ebx
80104c2a:	5e                   	pop    %esi
80104c2b:	5d                   	pop    %ebp
80104c2c:	c3                   	ret    
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
80104c30:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104c33:	83 c2 28             	add    $0x28,%edx
80104c36:	8d 76 00             	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c46:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c49:	39 d0                	cmp    %edx,%eax
80104c4b:	75 f3                	jne    80104c40 <acquire+0x90>
}
80104c4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c50:	5b                   	pop    %ebx
80104c51:	5e                   	pop    %esi
80104c52:	5d                   	pop    %ebp
80104c53:	c3                   	ret    
    panic("acquire");
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	68 19 7f 10 80       	push   $0x80107f19
80104c5c:	e8 2f b7 ff ff       	call   80100390 <panic>
80104c61:	eb 0d                	jmp    80104c70 <release>
80104c63:	90                   	nop
80104c64:	90                   	nop
80104c65:	90                   	nop
80104c66:	90                   	nop
80104c67:	90                   	nop
80104c68:	90                   	nop
80104c69:	90                   	nop
80104c6a:	90                   	nop
80104c6b:	90                   	nop
80104c6c:	90                   	nop
80104c6d:	90                   	nop
80104c6e:	90                   	nop
80104c6f:	90                   	nop

80104c70 <release>:
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 10             	sub    $0x10,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c7a:	53                   	push   %ebx
80104c7b:	e8 00 ff ff ff       	call   80104b80 <holding>
80104c80:	83 c4 10             	add    $0x10,%esp
80104c83:	85 c0                	test   %eax,%eax
80104c85:	74 22                	je     80104ca9 <release+0x39>
  lk->pcs[0] = 0;
80104c87:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c95:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c9a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca3:	c9                   	leave  
  popcli();
80104ca4:	e9 77 fe ff ff       	jmp    80104b20 <popcli>
    panic("release");
80104ca9:	83 ec 0c             	sub    $0xc,%esp
80104cac:	68 21 7f 10 80       	push   $0x80107f21
80104cb1:	e8 da b6 ff ff       	call   80100390 <panic>
80104cb6:	66 90                	xchg   %ax,%ax
80104cb8:	66 90                	xchg   %ax,%ax
80104cba:	66 90                	xchg   %ax,%ax
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104ccb:	f6 c2 03             	test   $0x3,%dl
80104cce:	75 05                	jne    80104cd5 <memset+0x15>
80104cd0:	f6 c1 03             	test   $0x3,%cl
80104cd3:	74 13                	je     80104ce8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104cd5:	89 d7                	mov    %edx,%edi
80104cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cda:	fc                   	cld    
80104cdb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cdd:	5b                   	pop    %ebx
80104cde:	89 d0                	mov    %edx,%eax
80104ce0:	5f                   	pop    %edi
80104ce1:	5d                   	pop    %ebp
80104ce2:	c3                   	ret    
80104ce3:	90                   	nop
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104ce8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cec:	c1 e9 02             	shr    $0x2,%ecx
80104cef:	89 f8                	mov    %edi,%eax
80104cf1:	89 fb                	mov    %edi,%ebx
80104cf3:	c1 e0 18             	shl    $0x18,%eax
80104cf6:	c1 e3 10             	shl    $0x10,%ebx
80104cf9:	09 d8                	or     %ebx,%eax
80104cfb:	09 f8                	or     %edi,%eax
80104cfd:	c1 e7 08             	shl    $0x8,%edi
80104d00:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d02:	89 d7                	mov    %edx,%edi
80104d04:	fc                   	cld    
80104d05:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d07:	5b                   	pop    %ebx
80104d08:	89 d0                	mov    %edx,%eax
80104d0a:	5f                   	pop    %edi
80104d0b:	5d                   	pop    %ebp
80104d0c:	c3                   	ret    
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi

80104d10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
80104d15:	53                   	push   %ebx
80104d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d19:	8b 75 08             	mov    0x8(%ebp),%esi
80104d1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d1f:	85 db                	test   %ebx,%ebx
80104d21:	74 29                	je     80104d4c <memcmp+0x3c>
    if(*s1 != *s2)
80104d23:	0f b6 16             	movzbl (%esi),%edx
80104d26:	0f b6 0f             	movzbl (%edi),%ecx
80104d29:	38 d1                	cmp    %dl,%cl
80104d2b:	75 2b                	jne    80104d58 <memcmp+0x48>
80104d2d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d32:	eb 14                	jmp    80104d48 <memcmp+0x38>
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d38:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d3c:	83 c0 01             	add    $0x1,%eax
80104d3f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d44:	38 ca                	cmp    %cl,%dl
80104d46:	75 10                	jne    80104d58 <memcmp+0x48>
  while(n-- > 0){
80104d48:	39 d8                	cmp    %ebx,%eax
80104d4a:	75 ec                	jne    80104d38 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d4c:	5b                   	pop    %ebx
  return 0;
80104d4d:	31 c0                	xor    %eax,%eax
}
80104d4f:	5e                   	pop    %esi
80104d50:	5f                   	pop    %edi
80104d51:	5d                   	pop    %ebp
80104d52:	c3                   	ret    
80104d53:	90                   	nop
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d58:	0f b6 c2             	movzbl %dl,%eax
}
80104d5b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d5c:	29 c8                	sub    %ecx,%eax
}
80104d5e:	5e                   	pop    %esi
80104d5f:	5f                   	pop    %edi
80104d60:	5d                   	pop    %ebp
80104d61:	c3                   	ret    
80104d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	8b 45 08             	mov    0x8(%ebp),%eax
80104d78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d7b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d7e:	39 c3                	cmp    %eax,%ebx
80104d80:	73 26                	jae    80104da8 <memmove+0x38>
80104d82:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104d85:	39 c8                	cmp    %ecx,%eax
80104d87:	73 1f                	jae    80104da8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104d89:	85 f6                	test   %esi,%esi
80104d8b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104d8e:	74 0f                	je     80104d9f <memmove+0x2f>
      *--d = *--s;
80104d90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104d97:	83 ea 01             	sub    $0x1,%edx
80104d9a:	83 fa ff             	cmp    $0xffffffff,%edx
80104d9d:	75 f1                	jne    80104d90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d9f:	5b                   	pop    %ebx
80104da0:	5e                   	pop    %esi
80104da1:	5d                   	pop    %ebp
80104da2:	c3                   	ret    
80104da3:	90                   	nop
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104da8:	31 d2                	xor    %edx,%edx
80104daa:	85 f6                	test   %esi,%esi
80104dac:	74 f1                	je     80104d9f <memmove+0x2f>
80104dae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104db0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104db4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104db7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104dba:	39 d6                	cmp    %edx,%esi
80104dbc:	75 f2                	jne    80104db0 <memmove+0x40>
}
80104dbe:	5b                   	pop    %ebx
80104dbf:	5e                   	pop    %esi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret    
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104dd3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104dd4:	eb 9a                	jmp    80104d70 <memmove>
80104dd6:	8d 76 00             	lea    0x0(%esi),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104de8:	53                   	push   %ebx
80104de9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104def:	85 ff                	test   %edi,%edi
80104df1:	74 2f                	je     80104e22 <strncmp+0x42>
80104df3:	0f b6 01             	movzbl (%ecx),%eax
80104df6:	0f b6 1e             	movzbl (%esi),%ebx
80104df9:	84 c0                	test   %al,%al
80104dfb:	74 37                	je     80104e34 <strncmp+0x54>
80104dfd:	38 c3                	cmp    %al,%bl
80104dff:	75 33                	jne    80104e34 <strncmp+0x54>
80104e01:	01 f7                	add    %esi,%edi
80104e03:	eb 13                	jmp    80104e18 <strncmp+0x38>
80104e05:	8d 76 00             	lea    0x0(%esi),%esi
80104e08:	0f b6 01             	movzbl (%ecx),%eax
80104e0b:	84 c0                	test   %al,%al
80104e0d:	74 21                	je     80104e30 <strncmp+0x50>
80104e0f:	0f b6 1a             	movzbl (%edx),%ebx
80104e12:	89 d6                	mov    %edx,%esi
80104e14:	38 d8                	cmp    %bl,%al
80104e16:	75 1c                	jne    80104e34 <strncmp+0x54>
    n--, p++, q++;
80104e18:	8d 56 01             	lea    0x1(%esi),%edx
80104e1b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e1e:	39 fa                	cmp    %edi,%edx
80104e20:	75 e6                	jne    80104e08 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e22:	5b                   	pop    %ebx
    return 0;
80104e23:	31 c0                	xor    %eax,%eax
}
80104e25:	5e                   	pop    %esi
80104e26:	5f                   	pop    %edi
80104e27:	5d                   	pop    %ebp
80104e28:	c3                   	ret    
80104e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e30:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e34:	29 d8                	sub    %ebx,%eax
}
80104e36:	5b                   	pop    %ebx
80104e37:	5e                   	pop    %esi
80104e38:	5f                   	pop    %edi
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
80104e45:	8b 45 08             	mov    0x8(%ebp),%eax
80104e48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e4e:	89 c2                	mov    %eax,%edx
80104e50:	eb 19                	jmp    80104e6b <strncpy+0x2b>
80104e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e58:	83 c3 01             	add    $0x1,%ebx
80104e5b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e5f:	83 c2 01             	add    $0x1,%edx
80104e62:	84 c9                	test   %cl,%cl
80104e64:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e67:	74 09                	je     80104e72 <strncpy+0x32>
80104e69:	89 f1                	mov    %esi,%ecx
80104e6b:	85 c9                	test   %ecx,%ecx
80104e6d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e70:	7f e6                	jg     80104e58 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e72:	31 c9                	xor    %ecx,%ecx
80104e74:	85 f6                	test   %esi,%esi
80104e76:	7e 17                	jle    80104e8f <strncpy+0x4f>
80104e78:	90                   	nop
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e80:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e84:	89 f3                	mov    %esi,%ebx
80104e86:	83 c1 01             	add    $0x1,%ecx
80104e89:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104e8b:	85 db                	test   %ebx,%ebx
80104e8d:	7f f1                	jg     80104e80 <strncpy+0x40>
  return os;
}
80104e8f:	5b                   	pop    %ebx
80104e90:	5e                   	pop    %esi
80104e91:	5d                   	pop    %ebp
80104e92:	c3                   	ret    
80104e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80104eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104eae:	85 c9                	test   %ecx,%ecx
80104eb0:	7e 26                	jle    80104ed8 <safestrcpy+0x38>
80104eb2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104eb6:	89 c1                	mov    %eax,%ecx
80104eb8:	eb 17                	jmp    80104ed1 <safestrcpy+0x31>
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ec0:	83 c2 01             	add    $0x1,%edx
80104ec3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ec7:	83 c1 01             	add    $0x1,%ecx
80104eca:	84 db                	test   %bl,%bl
80104ecc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104ecf:	74 04                	je     80104ed5 <safestrcpy+0x35>
80104ed1:	39 f2                	cmp    %esi,%edx
80104ed3:	75 eb                	jne    80104ec0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ed5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ed8:	5b                   	pop    %ebx
80104ed9:	5e                   	pop    %esi
80104eda:	5d                   	pop    %ebp
80104edb:	c3                   	ret    
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <strlen>:

int
strlen(const char *s)
{
80104ee0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ee1:	31 c0                	xor    %eax,%eax
{
80104ee3:	89 e5                	mov    %esp,%ebp
80104ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ee8:	80 3a 00             	cmpb   $0x0,(%edx)
80104eeb:	74 0c                	je     80104ef9 <strlen+0x19>
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
80104ef0:	83 c0 01             	add    $0x1,%eax
80104ef3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ef7:	75 f7                	jne    80104ef0 <strlen+0x10>
    ;
  return n;
}
80104ef9:	5d                   	pop    %ebp
80104efa:	c3                   	ret    

80104efb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104efb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104eff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f03:	55                   	push   %ebp
  pushl %ebx
80104f04:	53                   	push   %ebx
  pushl %esi
80104f05:	56                   	push   %esi
  pushl %edi
80104f06:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f07:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f09:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f0b:	5f                   	pop    %edi
  popl %esi
80104f0c:	5e                   	pop    %esi
  popl %ebx
80104f0d:	5b                   	pop    %ebx
  popl %ebp
80104f0e:	5d                   	pop    %ebp
  ret
80104f0f:	c3                   	ret    

80104f10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	53                   	push   %ebx
80104f14:	83 ec 04             	sub    $0x4,%esp
80104f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f1a:	e8 31 e8 ff ff       	call   80103750 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f1f:	8b 00                	mov    (%eax),%eax
80104f21:	39 d8                	cmp    %ebx,%eax
80104f23:	76 1b                	jbe    80104f40 <fetchint+0x30>
80104f25:	8d 53 04             	lea    0x4(%ebx),%edx
80104f28:	39 d0                	cmp    %edx,%eax
80104f2a:	72 14                	jb     80104f40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2f:	8b 13                	mov    (%ebx),%edx
80104f31:	89 10                	mov    %edx,(%eax)
  return 0;
80104f33:	31 c0                	xor    %eax,%eax
}
80104f35:	83 c4 04             	add    $0x4,%esp
80104f38:	5b                   	pop    %ebx
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    
80104f3b:	90                   	nop
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb ee                	jmp    80104f35 <fetchint+0x25>
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 04             	sub    $0x4,%esp
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f5a:	e8 f1 e7 ff ff       	call   80103750 <myproc>

  if(addr >= curproc->sz)
80104f5f:	39 18                	cmp    %ebx,(%eax)
80104f61:	76 29                	jbe    80104f8c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f66:	89 da                	mov    %ebx,%edx
80104f68:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f6a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f6c:	39 c3                	cmp    %eax,%ebx
80104f6e:	73 1c                	jae    80104f8c <fetchstr+0x3c>
    if(*s == 0)
80104f70:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f73:	75 10                	jne    80104f85 <fetchstr+0x35>
80104f75:	eb 39                	jmp    80104fb0 <fetchstr+0x60>
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f80:	80 3a 00             	cmpb   $0x0,(%edx)
80104f83:	74 1b                	je     80104fa0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104f85:	83 c2 01             	add    $0x1,%edx
80104f88:	39 d0                	cmp    %edx,%eax
80104f8a:	77 f4                	ja     80104f80 <fetchstr+0x30>
    return -1;
80104f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104f91:	83 c4 04             	add    $0x4,%esp
80104f94:	5b                   	pop    %ebx
80104f95:	5d                   	pop    %ebp
80104f96:	c3                   	ret    
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fa0:	83 c4 04             	add    $0x4,%esp
80104fa3:	89 d0                	mov    %edx,%eax
80104fa5:	29 d8                	sub    %ebx,%eax
80104fa7:	5b                   	pop    %ebx
80104fa8:	5d                   	pop    %ebp
80104fa9:	c3                   	ret    
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104fb0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104fb2:	eb dd                	jmp    80104f91 <fetchstr+0x41>
80104fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104fc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fc5:	e8 86 e7 ff ff       	call   80103750 <myproc>
80104fca:	8b 40 18             	mov    0x18(%eax),%eax
80104fcd:	8b 55 08             	mov    0x8(%ebp),%edx
80104fd0:	8b 40 44             	mov    0x44(%eax),%eax
80104fd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fd6:	e8 75 e7 ff ff       	call   80103750 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fdb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fdd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fe0:	39 c6                	cmp    %eax,%esi
80104fe2:	73 1c                	jae    80105000 <argint+0x40>
80104fe4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fe7:	39 d0                	cmp    %edx,%eax
80104fe9:	72 15                	jb     80105000 <argint+0x40>
  *ip = *(int*)(addr);
80104feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fee:	8b 53 04             	mov    0x4(%ebx),%edx
80104ff1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ff3:	31 c0                	xor    %eax,%eax
}
80104ff5:	5b                   	pop    %ebx
80104ff6:	5e                   	pop    %esi
80104ff7:	5d                   	pop    %ebp
80104ff8:	c3                   	ret    
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105005:	eb ee                	jmp    80104ff5 <argint+0x35>
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	83 ec 10             	sub    $0x10,%esp
80105018:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010501b:	e8 30 e7 ff ff       	call   80103750 <myproc>
80105020:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105022:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105025:	83 ec 08             	sub    $0x8,%esp
80105028:	50                   	push   %eax
80105029:	ff 75 08             	pushl  0x8(%ebp)
8010502c:	e8 8f ff ff ff       	call   80104fc0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105031:	83 c4 10             	add    $0x10,%esp
80105034:	85 c0                	test   %eax,%eax
80105036:	78 28                	js     80105060 <argptr+0x50>
80105038:	85 db                	test   %ebx,%ebx
8010503a:	78 24                	js     80105060 <argptr+0x50>
8010503c:	8b 16                	mov    (%esi),%edx
8010503e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105041:	39 c2                	cmp    %eax,%edx
80105043:	76 1b                	jbe    80105060 <argptr+0x50>
80105045:	01 c3                	add    %eax,%ebx
80105047:	39 da                	cmp    %ebx,%edx
80105049:	72 15                	jb     80105060 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010504b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010504e:	89 02                	mov    %eax,(%edx)
  return 0;
80105050:	31 c0                	xor    %eax,%eax
}
80105052:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105055:	5b                   	pop    %ebx
80105056:	5e                   	pop    %esi
80105057:	5d                   	pop    %ebp
80105058:	c3                   	ret    
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	eb eb                	jmp    80105052 <argptr+0x42>
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105076:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105079:	50                   	push   %eax
8010507a:	ff 75 08             	pushl  0x8(%ebp)
8010507d:	e8 3e ff ff ff       	call   80104fc0 <argint>
80105082:	83 c4 10             	add    $0x10,%esp
80105085:	85 c0                	test   %eax,%eax
80105087:	78 17                	js     801050a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105089:	83 ec 08             	sub    $0x8,%esp
8010508c:	ff 75 0c             	pushl  0xc(%ebp)
8010508f:	ff 75 f4             	pushl  -0xc(%ebp)
80105092:	e8 b9 fe ff ff       	call   80104f50 <fetchstr>
80105097:	83 c4 10             	add    $0x10,%esp
}
8010509a:	c9                   	leave  
8010509b:	c3                   	ret    
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <syscall>:
[SYS_getpinfo]  sys_getpinfo, 
};

void
syscall(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	53                   	push   %ebx
801050b4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050b7:	e8 94 e6 ff ff       	call   80103750 <myproc>
801050bc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050be:	8b 40 18             	mov    0x18(%eax),%eax
801050c1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050c4:	8d 50 ff             	lea    -0x1(%eax),%edx
801050c7:	83 fa 17             	cmp    $0x17,%edx
801050ca:	77 1c                	ja     801050e8 <syscall+0x38>
801050cc:	8b 14 85 60 7f 10 80 	mov    -0x7fef80a0(,%eax,4),%edx
801050d3:	85 d2                	test   %edx,%edx
801050d5:	74 11                	je     801050e8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050d7:	ff d2                	call   *%edx
801050d9:	8b 53 18             	mov    0x18(%ebx),%edx
801050dc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050e2:	c9                   	leave  
801050e3:	c3                   	ret    
801050e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050e8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050ec:	50                   	push   %eax
801050ed:	ff 73 10             	pushl  0x10(%ebx)
801050f0:	68 29 7f 10 80       	push   $0x80107f29
801050f5:	e8 66 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801050fa:	8b 43 18             	mov    0x18(%ebx),%eax
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105107:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010510a:	c9                   	leave  
8010510b:	c3                   	ret    
8010510c:	66 90                	xchg   %ax,%ax
8010510e:	66 90                	xchg   %ax,%ax

80105110 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	57                   	push   %edi
80105114:	56                   	push   %esi
80105115:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105116:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105119:	83 ec 34             	sub    $0x34,%esp
8010511c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010511f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105122:	56                   	push   %esi
80105123:	50                   	push   %eax
{
80105124:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105127:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010512a:	e8 d1 cd ff ff       	call   80101f00 <nameiparent>
8010512f:	83 c4 10             	add    $0x10,%esp
80105132:	85 c0                	test   %eax,%eax
80105134:	0f 84 46 01 00 00    	je     80105280 <create+0x170>
    return 0;
  ilock(dp);
8010513a:	83 ec 0c             	sub    $0xc,%esp
8010513d:	89 c3                	mov    %eax,%ebx
8010513f:	50                   	push   %eax
80105140:	e8 3b c5 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105145:	83 c4 0c             	add    $0xc,%esp
80105148:	6a 00                	push   $0x0
8010514a:	56                   	push   %esi
8010514b:	53                   	push   %ebx
8010514c:	e8 5f ca ff ff       	call   80101bb0 <dirlookup>
80105151:	83 c4 10             	add    $0x10,%esp
80105154:	85 c0                	test   %eax,%eax
80105156:	89 c7                	mov    %eax,%edi
80105158:	74 36                	je     80105190 <create+0x80>
    iunlockput(dp);
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	53                   	push   %ebx
8010515e:	e8 ad c7 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105163:	89 3c 24             	mov    %edi,(%esp)
80105166:	e8 15 c5 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010516b:	83 c4 10             	add    $0x10,%esp
8010516e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105173:	0f 85 97 00 00 00    	jne    80105210 <create+0x100>
80105179:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010517e:	0f 85 8c 00 00 00    	jne    80105210 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105184:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105187:	89 f8                	mov    %edi,%eax
80105189:	5b                   	pop    %ebx
8010518a:	5e                   	pop    %esi
8010518b:	5f                   	pop    %edi
8010518c:	5d                   	pop    %ebp
8010518d:	c3                   	ret    
8010518e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105190:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105194:	83 ec 08             	sub    $0x8,%esp
80105197:	50                   	push   %eax
80105198:	ff 33                	pushl  (%ebx)
8010519a:	e8 71 c3 ff ff       	call   80101510 <ialloc>
8010519f:	83 c4 10             	add    $0x10,%esp
801051a2:	85 c0                	test   %eax,%eax
801051a4:	89 c7                	mov    %eax,%edi
801051a6:	0f 84 e8 00 00 00    	je     80105294 <create+0x184>
  ilock(ip);
801051ac:	83 ec 0c             	sub    $0xc,%esp
801051af:	50                   	push   %eax
801051b0:	e8 cb c4 ff ff       	call   80101680 <ilock>
  ip->major = major;
801051b5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801051b9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801051bd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801051c1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801051c5:	b8 01 00 00 00       	mov    $0x1,%eax
801051ca:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801051ce:	89 3c 24             	mov    %edi,(%esp)
801051d1:	e8 fa c3 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801051d6:	83 c4 10             	add    $0x10,%esp
801051d9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801051de:	74 50                	je     80105230 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801051e0:	83 ec 04             	sub    $0x4,%esp
801051e3:	ff 77 04             	pushl  0x4(%edi)
801051e6:	56                   	push   %esi
801051e7:	53                   	push   %ebx
801051e8:	e8 33 cc ff ff       	call   80101e20 <dirlink>
801051ed:	83 c4 10             	add    $0x10,%esp
801051f0:	85 c0                	test   %eax,%eax
801051f2:	0f 88 8f 00 00 00    	js     80105287 <create+0x177>
  iunlockput(dp);
801051f8:	83 ec 0c             	sub    $0xc,%esp
801051fb:	53                   	push   %ebx
801051fc:	e8 0f c7 ff ff       	call   80101910 <iunlockput>
  return ip;
80105201:	83 c4 10             	add    $0x10,%esp
}
80105204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105207:	89 f8                	mov    %edi,%eax
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5f                   	pop    %edi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105210:	83 ec 0c             	sub    $0xc,%esp
80105213:	57                   	push   %edi
    return 0;
80105214:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105216:	e8 f5 c6 ff ff       	call   80101910 <iunlockput>
    return 0;
8010521b:	83 c4 10             	add    $0x10,%esp
}
8010521e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105221:	89 f8                	mov    %edi,%eax
80105223:	5b                   	pop    %ebx
80105224:	5e                   	pop    %esi
80105225:	5f                   	pop    %edi
80105226:	5d                   	pop    %ebp
80105227:	c3                   	ret    
80105228:	90                   	nop
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105230:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105235:	83 ec 0c             	sub    $0xc,%esp
80105238:	53                   	push   %ebx
80105239:	e8 92 c3 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010523e:	83 c4 0c             	add    $0xc,%esp
80105241:	ff 77 04             	pushl  0x4(%edi)
80105244:	68 e0 7f 10 80       	push   $0x80107fe0
80105249:	57                   	push   %edi
8010524a:	e8 d1 cb ff ff       	call   80101e20 <dirlink>
8010524f:	83 c4 10             	add    $0x10,%esp
80105252:	85 c0                	test   %eax,%eax
80105254:	78 1c                	js     80105272 <create+0x162>
80105256:	83 ec 04             	sub    $0x4,%esp
80105259:	ff 73 04             	pushl  0x4(%ebx)
8010525c:	68 df 7f 10 80       	push   $0x80107fdf
80105261:	57                   	push   %edi
80105262:	e8 b9 cb ff ff       	call   80101e20 <dirlink>
80105267:	83 c4 10             	add    $0x10,%esp
8010526a:	85 c0                	test   %eax,%eax
8010526c:	0f 89 6e ff ff ff    	jns    801051e0 <create+0xd0>
      panic("create dots");
80105272:	83 ec 0c             	sub    $0xc,%esp
80105275:	68 d3 7f 10 80       	push   $0x80107fd3
8010527a:	e8 11 b1 ff ff       	call   80100390 <panic>
8010527f:	90                   	nop
    return 0;
80105280:	31 ff                	xor    %edi,%edi
80105282:	e9 fd fe ff ff       	jmp    80105184 <create+0x74>
    panic("create: dirlink");
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	68 e2 7f 10 80       	push   $0x80107fe2
8010528f:	e8 fc b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	68 c4 7f 10 80       	push   $0x80107fc4
8010529c:	e8 ef b0 ff ff       	call   80100390 <panic>
801052a1:	eb 0d                	jmp    801052b0 <argfd.constprop.0>
801052a3:	90                   	nop
801052a4:	90                   	nop
801052a5:	90                   	nop
801052a6:	90                   	nop
801052a7:	90                   	nop
801052a8:	90                   	nop
801052a9:	90                   	nop
801052aa:	90                   	nop
801052ab:	90                   	nop
801052ac:	90                   	nop
801052ad:	90                   	nop
801052ae:	90                   	nop
801052af:	90                   	nop

801052b0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	56                   	push   %esi
801052b4:	53                   	push   %ebx
801052b5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801052b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801052ba:	89 d6                	mov    %edx,%esi
801052bc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052bf:	50                   	push   %eax
801052c0:	6a 00                	push   $0x0
801052c2:	e8 f9 fc ff ff       	call   80104fc0 <argint>
801052c7:	83 c4 10             	add    $0x10,%esp
801052ca:	85 c0                	test   %eax,%eax
801052cc:	78 2a                	js     801052f8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052ce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052d2:	77 24                	ja     801052f8 <argfd.constprop.0+0x48>
801052d4:	e8 77 e4 ff ff       	call   80103750 <myproc>
801052d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052dc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801052e0:	85 c0                	test   %eax,%eax
801052e2:	74 14                	je     801052f8 <argfd.constprop.0+0x48>
  if(pfd)
801052e4:	85 db                	test   %ebx,%ebx
801052e6:	74 02                	je     801052ea <argfd.constprop.0+0x3a>
    *pfd = fd;
801052e8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801052ea:	89 06                	mov    %eax,(%esi)
  return 0;
801052ec:	31 c0                	xor    %eax,%eax
}
801052ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052f1:	5b                   	pop    %ebx
801052f2:	5e                   	pop    %esi
801052f3:	5d                   	pop    %ebp
801052f4:	c3                   	ret    
801052f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fd:	eb ef                	jmp    801052ee <argfd.constprop.0+0x3e>
801052ff:	90                   	nop

80105300 <sys_dup>:
{
80105300:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105301:	31 c0                	xor    %eax,%eax
{
80105303:	89 e5                	mov    %esp,%ebp
80105305:	56                   	push   %esi
80105306:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105307:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010530a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010530d:	e8 9e ff ff ff       	call   801052b0 <argfd.constprop.0>
80105312:	85 c0                	test   %eax,%eax
80105314:	78 42                	js     80105358 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105316:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105319:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010531b:	e8 30 e4 ff ff       	call   80103750 <myproc>
80105320:	eb 0e                	jmp    80105330 <sys_dup+0x30>
80105322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105328:	83 c3 01             	add    $0x1,%ebx
8010532b:	83 fb 10             	cmp    $0x10,%ebx
8010532e:	74 28                	je     80105358 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105330:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105334:	85 d2                	test   %edx,%edx
80105336:	75 f0                	jne    80105328 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105338:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	ff 75 f4             	pushl  -0xc(%ebp)
80105342:	e8 a9 ba ff ff       	call   80100df0 <filedup>
  return fd;
80105347:	83 c4 10             	add    $0x10,%esp
}
8010534a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010534d:	89 d8                	mov    %ebx,%eax
8010534f:	5b                   	pop    %ebx
80105350:	5e                   	pop    %esi
80105351:	5d                   	pop    %ebp
80105352:	c3                   	ret    
80105353:	90                   	nop
80105354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105358:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010535b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105360:	89 d8                	mov    %ebx,%eax
80105362:	5b                   	pop    %ebx
80105363:	5e                   	pop    %esi
80105364:	5d                   	pop    %ebp
80105365:	c3                   	ret    
80105366:	8d 76 00             	lea    0x0(%esi),%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <sys_read>:
{
80105370:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105371:	31 c0                	xor    %eax,%eax
{
80105373:	89 e5                	mov    %esp,%ebp
80105375:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105378:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010537b:	e8 30 ff ff ff       	call   801052b0 <argfd.constprop.0>
80105380:	85 c0                	test   %eax,%eax
80105382:	78 4c                	js     801053d0 <sys_read+0x60>
80105384:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105387:	83 ec 08             	sub    $0x8,%esp
8010538a:	50                   	push   %eax
8010538b:	6a 02                	push   $0x2
8010538d:	e8 2e fc ff ff       	call   80104fc0 <argint>
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	85 c0                	test   %eax,%eax
80105397:	78 37                	js     801053d0 <sys_read+0x60>
80105399:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539c:	83 ec 04             	sub    $0x4,%esp
8010539f:	ff 75 f0             	pushl  -0x10(%ebp)
801053a2:	50                   	push   %eax
801053a3:	6a 01                	push   $0x1
801053a5:	e8 66 fc ff ff       	call   80105010 <argptr>
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	85 c0                	test   %eax,%eax
801053af:	78 1f                	js     801053d0 <sys_read+0x60>
  return fileread(f, p, n);
801053b1:	83 ec 04             	sub    $0x4,%esp
801053b4:	ff 75 f0             	pushl  -0x10(%ebp)
801053b7:	ff 75 f4             	pushl  -0xc(%ebp)
801053ba:	ff 75 ec             	pushl  -0x14(%ebp)
801053bd:	e8 9e bb ff ff       	call   80100f60 <fileread>
801053c2:	83 c4 10             	add    $0x10,%esp
}
801053c5:	c9                   	leave  
801053c6:	c3                   	ret    
801053c7:	89 f6                	mov    %esi,%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d5:	c9                   	leave  
801053d6:	c3                   	ret    
801053d7:	89 f6                	mov    %esi,%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_write>:
{
801053e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053e1:	31 c0                	xor    %eax,%eax
{
801053e3:	89 e5                	mov    %esp,%ebp
801053e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053eb:	e8 c0 fe ff ff       	call   801052b0 <argfd.constprop.0>
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 4c                	js     80105440 <sys_write+0x60>
801053f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053f7:	83 ec 08             	sub    $0x8,%esp
801053fa:	50                   	push   %eax
801053fb:	6a 02                	push   $0x2
801053fd:	e8 be fb ff ff       	call   80104fc0 <argint>
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	85 c0                	test   %eax,%eax
80105407:	78 37                	js     80105440 <sys_write+0x60>
80105409:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540c:	83 ec 04             	sub    $0x4,%esp
8010540f:	ff 75 f0             	pushl  -0x10(%ebp)
80105412:	50                   	push   %eax
80105413:	6a 01                	push   $0x1
80105415:	e8 f6 fb ff ff       	call   80105010 <argptr>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	78 1f                	js     80105440 <sys_write+0x60>
  return filewrite(f, p, n);
80105421:	83 ec 04             	sub    $0x4,%esp
80105424:	ff 75 f0             	pushl  -0x10(%ebp)
80105427:	ff 75 f4             	pushl  -0xc(%ebp)
8010542a:	ff 75 ec             	pushl  -0x14(%ebp)
8010542d:	e8 be bb ff ff       	call   80100ff0 <filewrite>
80105432:	83 c4 10             	add    $0x10,%esp
}
80105435:	c9                   	leave  
80105436:	c3                   	ret    
80105437:	89 f6                	mov    %esi,%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_close>:
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105456:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105459:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010545c:	e8 4f fe ff ff       	call   801052b0 <argfd.constprop.0>
80105461:	85 c0                	test   %eax,%eax
80105463:	78 2b                	js     80105490 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105465:	e8 e6 e2 ff ff       	call   80103750 <myproc>
8010546a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010546d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105470:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105477:	00 
  fileclose(f);
80105478:	ff 75 f4             	pushl  -0xc(%ebp)
8010547b:	e8 c0 b9 ff ff       	call   80100e40 <fileclose>
  return 0;
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	31 c0                	xor    %eax,%eax
}
80105485:	c9                   	leave  
80105486:	c3                   	ret    
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105495:	c9                   	leave  
80105496:	c3                   	ret    
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <sys_fstat>:
{
801054a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054a1:	31 c0                	xor    %eax,%eax
{
801054a3:	89 e5                	mov    %esp,%ebp
801054a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054a8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054ab:	e8 00 fe ff ff       	call   801052b0 <argfd.constprop.0>
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 2c                	js     801054e0 <sys_fstat+0x40>
801054b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b7:	83 ec 04             	sub    $0x4,%esp
801054ba:	6a 14                	push   $0x14
801054bc:	50                   	push   %eax
801054bd:	6a 01                	push   $0x1
801054bf:	e8 4c fb ff ff       	call   80105010 <argptr>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	78 15                	js     801054e0 <sys_fstat+0x40>
  return filestat(f, st);
801054cb:	83 ec 08             	sub    $0x8,%esp
801054ce:	ff 75 f4             	pushl  -0xc(%ebp)
801054d1:	ff 75 f0             	pushl  -0x10(%ebp)
801054d4:	e8 37 ba ff ff       	call   80100f10 <filestat>
801054d9:	83 c4 10             	add    $0x10,%esp
}
801054dc:	c9                   	leave  
801054dd:	c3                   	ret    
801054de:	66 90                	xchg   %ax,%ax
    return -1;
801054e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e5:	c9                   	leave  
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <sys_link>:
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054f6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801054f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 6c fb ff ff       	call   80105070 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 fb 00 00 00    	js     8010560a <sys_link+0x11a>
8010550f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105512:	83 ec 08             	sub    $0x8,%esp
80105515:	50                   	push   %eax
80105516:	6a 01                	push   $0x1
80105518:	e8 53 fb ff ff       	call   80105070 <argstr>
8010551d:	83 c4 10             	add    $0x10,%esp
80105520:	85 c0                	test   %eax,%eax
80105522:	0f 88 e2 00 00 00    	js     8010560a <sys_link+0x11a>
  begin_op();
80105528:	e8 73 d6 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
8010552d:	83 ec 0c             	sub    $0xc,%esp
80105530:	ff 75 d4             	pushl  -0x2c(%ebp)
80105533:	e8 a8 c9 ff ff       	call   80101ee0 <namei>
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	85 c0                	test   %eax,%eax
8010553d:	89 c3                	mov    %eax,%ebx
8010553f:	0f 84 ea 00 00 00    	je     8010562f <sys_link+0x13f>
  ilock(ip);
80105545:	83 ec 0c             	sub    $0xc,%esp
80105548:	50                   	push   %eax
80105549:	e8 32 c1 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010554e:	83 c4 10             	add    $0x10,%esp
80105551:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105556:	0f 84 bb 00 00 00    	je     80105617 <sys_link+0x127>
  ip->nlink++;
8010555c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105561:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105564:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105567:	53                   	push   %ebx
80105568:	e8 63 c0 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010556d:	89 1c 24             	mov    %ebx,(%esp)
80105570:	e8 eb c1 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105575:	58                   	pop    %eax
80105576:	5a                   	pop    %edx
80105577:	57                   	push   %edi
80105578:	ff 75 d0             	pushl  -0x30(%ebp)
8010557b:	e8 80 c9 ff ff       	call   80101f00 <nameiparent>
80105580:	83 c4 10             	add    $0x10,%esp
80105583:	85 c0                	test   %eax,%eax
80105585:	89 c6                	mov    %eax,%esi
80105587:	74 5b                	je     801055e4 <sys_link+0xf4>
  ilock(dp);
80105589:	83 ec 0c             	sub    $0xc,%esp
8010558c:	50                   	push   %eax
8010558d:	e8 ee c0 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	8b 03                	mov    (%ebx),%eax
80105597:	39 06                	cmp    %eax,(%esi)
80105599:	75 3d                	jne    801055d8 <sys_link+0xe8>
8010559b:	83 ec 04             	sub    $0x4,%esp
8010559e:	ff 73 04             	pushl  0x4(%ebx)
801055a1:	57                   	push   %edi
801055a2:	56                   	push   %esi
801055a3:	e8 78 c8 ff ff       	call   80101e20 <dirlink>
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	85 c0                	test   %eax,%eax
801055ad:	78 29                	js     801055d8 <sys_link+0xe8>
  iunlockput(dp);
801055af:	83 ec 0c             	sub    $0xc,%esp
801055b2:	56                   	push   %esi
801055b3:	e8 58 c3 ff ff       	call   80101910 <iunlockput>
  iput(ip);
801055b8:	89 1c 24             	mov    %ebx,(%esp)
801055bb:	e8 f0 c1 ff ff       	call   801017b0 <iput>
  end_op();
801055c0:	e8 4b d6 ff ff       	call   80102c10 <end_op>
  return 0;
801055c5:	83 c4 10             	add    $0x10,%esp
801055c8:	31 c0                	xor    %eax,%eax
}
801055ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055cd:	5b                   	pop    %ebx
801055ce:	5e                   	pop    %esi
801055cf:	5f                   	pop    %edi
801055d0:	5d                   	pop    %ebp
801055d1:	c3                   	ret    
801055d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	56                   	push   %esi
801055dc:	e8 2f c3 ff ff       	call   80101910 <iunlockput>
    goto bad;
801055e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801055e4:	83 ec 0c             	sub    $0xc,%esp
801055e7:	53                   	push   %ebx
801055e8:	e8 93 c0 ff ff       	call   80101680 <ilock>
  ip->nlink--;
801055ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055f2:	89 1c 24             	mov    %ebx,(%esp)
801055f5:	e8 d6 bf ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801055fa:	89 1c 24             	mov    %ebx,(%esp)
801055fd:	e8 0e c3 ff ff       	call   80101910 <iunlockput>
  end_op();
80105602:	e8 09 d6 ff ff       	call   80102c10 <end_op>
  return -1;
80105607:	83 c4 10             	add    $0x10,%esp
}
8010560a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010560d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105612:	5b                   	pop    %ebx
80105613:	5e                   	pop    %esi
80105614:	5f                   	pop    %edi
80105615:	5d                   	pop    %ebp
80105616:	c3                   	ret    
    iunlockput(ip);
80105617:	83 ec 0c             	sub    $0xc,%esp
8010561a:	53                   	push   %ebx
8010561b:	e8 f0 c2 ff ff       	call   80101910 <iunlockput>
    end_op();
80105620:	e8 eb d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562d:	eb 9b                	jmp    801055ca <sys_link+0xda>
    end_op();
8010562f:	e8 dc d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105639:	eb 8f                	jmp    801055ca <sys_link+0xda>
8010563b:	90                   	nop
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_unlink>:
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
80105645:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105646:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105649:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010564c:	50                   	push   %eax
8010564d:	6a 00                	push   $0x0
8010564f:	e8 1c fa ff ff       	call   80105070 <argstr>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	0f 88 77 01 00 00    	js     801057d6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010565f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105662:	e8 39 d5 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105667:	83 ec 08             	sub    $0x8,%esp
8010566a:	53                   	push   %ebx
8010566b:	ff 75 c0             	pushl  -0x40(%ebp)
8010566e:	e8 8d c8 ff ff       	call   80101f00 <nameiparent>
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	89 c6                	mov    %eax,%esi
8010567a:	0f 84 60 01 00 00    	je     801057e0 <sys_unlink+0x1a0>
  ilock(dp);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	50                   	push   %eax
80105684:	e8 f7 bf ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105689:	58                   	pop    %eax
8010568a:	5a                   	pop    %edx
8010568b:	68 e0 7f 10 80       	push   $0x80107fe0
80105690:	53                   	push   %ebx
80105691:	e8 fa c4 ff ff       	call   80101b90 <namecmp>
80105696:	83 c4 10             	add    $0x10,%esp
80105699:	85 c0                	test   %eax,%eax
8010569b:	0f 84 03 01 00 00    	je     801057a4 <sys_unlink+0x164>
801056a1:	83 ec 08             	sub    $0x8,%esp
801056a4:	68 df 7f 10 80       	push   $0x80107fdf
801056a9:	53                   	push   %ebx
801056aa:	e8 e1 c4 ff ff       	call   80101b90 <namecmp>
801056af:	83 c4 10             	add    $0x10,%esp
801056b2:	85 c0                	test   %eax,%eax
801056b4:	0f 84 ea 00 00 00    	je     801057a4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801056ba:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056bd:	83 ec 04             	sub    $0x4,%esp
801056c0:	50                   	push   %eax
801056c1:	53                   	push   %ebx
801056c2:	56                   	push   %esi
801056c3:	e8 e8 c4 ff ff       	call   80101bb0 <dirlookup>
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	85 c0                	test   %eax,%eax
801056cd:	89 c3                	mov    %eax,%ebx
801056cf:	0f 84 cf 00 00 00    	je     801057a4 <sys_unlink+0x164>
  ilock(ip);
801056d5:	83 ec 0c             	sub    $0xc,%esp
801056d8:	50                   	push   %eax
801056d9:	e8 a2 bf ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801056e6:	0f 8e 10 01 00 00    	jle    801057fc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801056ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056f1:	74 6d                	je     80105760 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801056f3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056f6:	83 ec 04             	sub    $0x4,%esp
801056f9:	6a 10                	push   $0x10
801056fb:	6a 00                	push   $0x0
801056fd:	50                   	push   %eax
801056fe:	e8 bd f5 ff ff       	call   80104cc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105703:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105706:	6a 10                	push   $0x10
80105708:	ff 75 c4             	pushl  -0x3c(%ebp)
8010570b:	50                   	push   %eax
8010570c:	56                   	push   %esi
8010570d:	e8 4e c3 ff ff       	call   80101a60 <writei>
80105712:	83 c4 20             	add    $0x20,%esp
80105715:	83 f8 10             	cmp    $0x10,%eax
80105718:	0f 85 eb 00 00 00    	jne    80105809 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010571e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105723:	0f 84 97 00 00 00    	je     801057c0 <sys_unlink+0x180>
  iunlockput(dp);
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	56                   	push   %esi
8010572d:	e8 de c1 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105732:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105737:	89 1c 24             	mov    %ebx,(%esp)
8010573a:	e8 91 be ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010573f:	89 1c 24             	mov    %ebx,(%esp)
80105742:	e8 c9 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
80105747:	e8 c4 d4 ff ff       	call   80102c10 <end_op>
  return 0;
8010574c:	83 c4 10             	add    $0x10,%esp
8010574f:	31 c0                	xor    %eax,%eax
}
80105751:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105754:	5b                   	pop    %ebx
80105755:	5e                   	pop    %esi
80105756:	5f                   	pop    %edi
80105757:	5d                   	pop    %ebp
80105758:	c3                   	ret    
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105760:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105764:	76 8d                	jbe    801056f3 <sys_unlink+0xb3>
80105766:	bf 20 00 00 00       	mov    $0x20,%edi
8010576b:	eb 0f                	jmp    8010577c <sys_unlink+0x13c>
8010576d:	8d 76 00             	lea    0x0(%esi),%esi
80105770:	83 c7 10             	add    $0x10,%edi
80105773:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105776:	0f 83 77 ff ff ff    	jae    801056f3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010577c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010577f:	6a 10                	push   $0x10
80105781:	57                   	push   %edi
80105782:	50                   	push   %eax
80105783:	53                   	push   %ebx
80105784:	e8 d7 c1 ff ff       	call   80101960 <readi>
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	83 f8 10             	cmp    $0x10,%eax
8010578f:	75 5e                	jne    801057ef <sys_unlink+0x1af>
    if(de.inum != 0)
80105791:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105796:	74 d8                	je     80105770 <sys_unlink+0x130>
    iunlockput(ip);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	53                   	push   %ebx
8010579c:	e8 6f c1 ff ff       	call   80101910 <iunlockput>
    goto bad;
801057a1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801057a4:	83 ec 0c             	sub    $0xc,%esp
801057a7:	56                   	push   %esi
801057a8:	e8 63 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
801057ad:	e8 5e d4 ff ff       	call   80102c10 <end_op>
  return -1;
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ba:	eb 95                	jmp    80105751 <sys_unlink+0x111>
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801057c0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801057c5:	83 ec 0c             	sub    $0xc,%esp
801057c8:	56                   	push   %esi
801057c9:	e8 02 be ff ff       	call   801015d0 <iupdate>
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	e9 53 ff ff ff       	jmp    80105729 <sys_unlink+0xe9>
    return -1;
801057d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057db:	e9 71 ff ff ff       	jmp    80105751 <sys_unlink+0x111>
    end_op();
801057e0:	e8 2b d4 ff ff       	call   80102c10 <end_op>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ea:	e9 62 ff ff ff       	jmp    80105751 <sys_unlink+0x111>
      panic("isdirempty: readi");
801057ef:	83 ec 0c             	sub    $0xc,%esp
801057f2:	68 04 80 10 80       	push   $0x80108004
801057f7:	e8 94 ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801057fc:	83 ec 0c             	sub    $0xc,%esp
801057ff:	68 f2 7f 10 80       	push   $0x80107ff2
80105804:	e8 87 ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105809:	83 ec 0c             	sub    $0xc,%esp
8010580c:	68 16 80 10 80       	push   $0x80108016
80105811:	e8 7a ab ff ff       	call   80100390 <panic>
80105816:	8d 76 00             	lea    0x0(%esi),%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <sys_open>:

int
sys_open(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	57                   	push   %edi
80105824:	56                   	push   %esi
80105825:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105826:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105829:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010582c:	50                   	push   %eax
8010582d:	6a 00                	push   $0x0
8010582f:	e8 3c f8 ff ff       	call   80105070 <argstr>
80105834:	83 c4 10             	add    $0x10,%esp
80105837:	85 c0                	test   %eax,%eax
80105839:	0f 88 1d 01 00 00    	js     8010595c <sys_open+0x13c>
8010583f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105842:	83 ec 08             	sub    $0x8,%esp
80105845:	50                   	push   %eax
80105846:	6a 01                	push   $0x1
80105848:	e8 73 f7 ff ff       	call   80104fc0 <argint>
8010584d:	83 c4 10             	add    $0x10,%esp
80105850:	85 c0                	test   %eax,%eax
80105852:	0f 88 04 01 00 00    	js     8010595c <sys_open+0x13c>
    return -1;

  begin_op();
80105858:	e8 43 d3 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
8010585d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105861:	0f 85 a9 00 00 00    	jne    80105910 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105867:	83 ec 0c             	sub    $0xc,%esp
8010586a:	ff 75 e0             	pushl  -0x20(%ebp)
8010586d:	e8 6e c6 ff ff       	call   80101ee0 <namei>
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	85 c0                	test   %eax,%eax
80105877:	89 c6                	mov    %eax,%esi
80105879:	0f 84 b2 00 00 00    	je     80105931 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010587f:	83 ec 0c             	sub    $0xc,%esp
80105882:	50                   	push   %eax
80105883:	e8 f8 bd ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105888:	83 c4 10             	add    $0x10,%esp
8010588b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105890:	0f 84 aa 00 00 00    	je     80105940 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105896:	e8 e5 b4 ff ff       	call   80100d80 <filealloc>
8010589b:	85 c0                	test   %eax,%eax
8010589d:	89 c7                	mov    %eax,%edi
8010589f:	0f 84 a6 00 00 00    	je     8010594b <sys_open+0x12b>
  struct proc *curproc = myproc();
801058a5:	e8 a6 de ff ff       	call   80103750 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058aa:	31 db                	xor    %ebx,%ebx
801058ac:	eb 0e                	jmp    801058bc <sys_open+0x9c>
801058ae:	66 90                	xchg   %ax,%ax
801058b0:	83 c3 01             	add    $0x1,%ebx
801058b3:	83 fb 10             	cmp    $0x10,%ebx
801058b6:	0f 84 ac 00 00 00    	je     80105968 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801058bc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058c0:	85 d2                	test   %edx,%edx
801058c2:	75 ec                	jne    801058b0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058c4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801058c7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801058cb:	56                   	push   %esi
801058cc:	e8 8f be ff ff       	call   80101760 <iunlock>
  end_op();
801058d1:	e8 3a d3 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
801058d6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801058dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058df:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801058e2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801058e5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801058ec:	89 d0                	mov    %edx,%eax
801058ee:	f7 d0                	not    %eax
801058f0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058f3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801058f6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058f9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801058fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105900:	89 d8                	mov    %ebx,%eax
80105902:	5b                   	pop    %ebx
80105903:	5e                   	pop    %esi
80105904:	5f                   	pop    %edi
80105905:	5d                   	pop    %ebp
80105906:	c3                   	ret    
80105907:	89 f6                	mov    %esi,%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105916:	31 c9                	xor    %ecx,%ecx
80105918:	6a 00                	push   $0x0
8010591a:	ba 02 00 00 00       	mov    $0x2,%edx
8010591f:	e8 ec f7 ff ff       	call   80105110 <create>
    if(ip == 0){
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105929:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010592b:	0f 85 65 ff ff ff    	jne    80105896 <sys_open+0x76>
      end_op();
80105931:	e8 da d2 ff ff       	call   80102c10 <end_op>
      return -1;
80105936:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010593b:	eb c0                	jmp    801058fd <sys_open+0xdd>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105940:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105943:	85 c9                	test   %ecx,%ecx
80105945:	0f 84 4b ff ff ff    	je     80105896 <sys_open+0x76>
    iunlockput(ip);
8010594b:	83 ec 0c             	sub    $0xc,%esp
8010594e:	56                   	push   %esi
8010594f:	e8 bc bf ff ff       	call   80101910 <iunlockput>
    end_op();
80105954:	e8 b7 d2 ff ff       	call   80102c10 <end_op>
    return -1;
80105959:	83 c4 10             	add    $0x10,%esp
8010595c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105961:	eb 9a                	jmp    801058fd <sys_open+0xdd>
80105963:	90                   	nop
80105964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	57                   	push   %edi
8010596c:	e8 cf b4 ff ff       	call   80100e40 <fileclose>
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	eb d5                	jmp    8010594b <sys_open+0x12b>
80105976:	8d 76 00             	lea    0x0(%esi),%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105980 <sys_mkdir>:

int
sys_mkdir(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105986:	e8 15 d2 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010598b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010598e:	83 ec 08             	sub    $0x8,%esp
80105991:	50                   	push   %eax
80105992:	6a 00                	push   $0x0
80105994:	e8 d7 f6 ff ff       	call   80105070 <argstr>
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	85 c0                	test   %eax,%eax
8010599e:	78 30                	js     801059d0 <sys_mkdir+0x50>
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a6:	31 c9                	xor    %ecx,%ecx
801059a8:	6a 00                	push   $0x0
801059aa:	ba 01 00 00 00       	mov    $0x1,%edx
801059af:	e8 5c f7 ff ff       	call   80105110 <create>
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	85 c0                	test   %eax,%eax
801059b9:	74 15                	je     801059d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059bb:	83 ec 0c             	sub    $0xc,%esp
801059be:	50                   	push   %eax
801059bf:	e8 4c bf ff ff       	call   80101910 <iunlockput>
  end_op();
801059c4:	e8 47 d2 ff ff       	call   80102c10 <end_op>
  return 0;
801059c9:	83 c4 10             	add    $0x10,%esp
801059cc:	31 c0                	xor    %eax,%eax
}
801059ce:	c9                   	leave  
801059cf:	c3                   	ret    
    end_op();
801059d0:	e8 3b d2 ff ff       	call   80102c10 <end_op>
    return -1;
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059da:	c9                   	leave  
801059db:	c3                   	ret    
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_mknod>:

int
sys_mknod(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059e6:	e8 b5 d1 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059ee:	83 ec 08             	sub    $0x8,%esp
801059f1:	50                   	push   %eax
801059f2:	6a 00                	push   $0x0
801059f4:	e8 77 f6 ff ff       	call   80105070 <argstr>
801059f9:	83 c4 10             	add    $0x10,%esp
801059fc:	85 c0                	test   %eax,%eax
801059fe:	78 60                	js     80105a60 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a00:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a03:	83 ec 08             	sub    $0x8,%esp
80105a06:	50                   	push   %eax
80105a07:	6a 01                	push   $0x1
80105a09:	e8 b2 f5 ff ff       	call   80104fc0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a0e:	83 c4 10             	add    $0x10,%esp
80105a11:	85 c0                	test   %eax,%eax
80105a13:	78 4b                	js     80105a60 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a15:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a18:	83 ec 08             	sub    $0x8,%esp
80105a1b:	50                   	push   %eax
80105a1c:	6a 02                	push   $0x2
80105a1e:	e8 9d f5 ff ff       	call   80104fc0 <argint>
     argint(1, &major) < 0 ||
80105a23:	83 c4 10             	add    $0x10,%esp
80105a26:	85 c0                	test   %eax,%eax
80105a28:	78 36                	js     80105a60 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a2a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a2e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a31:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105a35:	ba 03 00 00 00       	mov    $0x3,%edx
80105a3a:	50                   	push   %eax
80105a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a3e:	e8 cd f6 ff ff       	call   80105110 <create>
80105a43:	83 c4 10             	add    $0x10,%esp
80105a46:	85 c0                	test   %eax,%eax
80105a48:	74 16                	je     80105a60 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a4a:	83 ec 0c             	sub    $0xc,%esp
80105a4d:	50                   	push   %eax
80105a4e:	e8 bd be ff ff       	call   80101910 <iunlockput>
  end_op();
80105a53:	e8 b8 d1 ff ff       	call   80102c10 <end_op>
  return 0;
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	31 c0                	xor    %eax,%eax
}
80105a5d:	c9                   	leave  
80105a5e:	c3                   	ret    
80105a5f:	90                   	nop
    end_op();
80105a60:	e8 ab d1 ff ff       	call   80102c10 <end_op>
    return -1;
80105a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a6a:	c9                   	leave  
80105a6b:	c3                   	ret    
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a70 <sys_chdir>:

int
sys_chdir(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	56                   	push   %esi
80105a74:	53                   	push   %ebx
80105a75:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a78:	e8 d3 dc ff ff       	call   80103750 <myproc>
80105a7d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a7f:	e8 1c d1 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a87:	83 ec 08             	sub    $0x8,%esp
80105a8a:	50                   	push   %eax
80105a8b:	6a 00                	push   $0x0
80105a8d:	e8 de f5 ff ff       	call   80105070 <argstr>
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	85 c0                	test   %eax,%eax
80105a97:	78 77                	js     80105b10 <sys_chdir+0xa0>
80105a99:	83 ec 0c             	sub    $0xc,%esp
80105a9c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a9f:	e8 3c c4 ff ff       	call   80101ee0 <namei>
80105aa4:	83 c4 10             	add    $0x10,%esp
80105aa7:	85 c0                	test   %eax,%eax
80105aa9:	89 c3                	mov    %eax,%ebx
80105aab:	74 63                	je     80105b10 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105aad:	83 ec 0c             	sub    $0xc,%esp
80105ab0:	50                   	push   %eax
80105ab1:	e8 ca bb ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105abe:	75 30                	jne    80105af0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	53                   	push   %ebx
80105ac4:	e8 97 bc ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105ac9:	58                   	pop    %eax
80105aca:	ff 76 68             	pushl  0x68(%esi)
80105acd:	e8 de bc ff ff       	call   801017b0 <iput>
  end_op();
80105ad2:	e8 39 d1 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105ad7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	31 c0                	xor    %eax,%eax
}
80105adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ae2:	5b                   	pop    %ebx
80105ae3:	5e                   	pop    %esi
80105ae4:	5d                   	pop    %ebp
80105ae5:	c3                   	ret    
80105ae6:	8d 76 00             	lea    0x0(%esi),%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	53                   	push   %ebx
80105af4:	e8 17 be ff ff       	call   80101910 <iunlockput>
    end_op();
80105af9:	e8 12 d1 ff ff       	call   80102c10 <end_op>
    return -1;
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b06:	eb d7                	jmp    80105adf <sys_chdir+0x6f>
80105b08:	90                   	nop
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b10:	e8 fb d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1a:	eb c3                	jmp    80105adf <sys_chdir+0x6f>
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b20 <sys_exec>:

int
sys_exec(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	57                   	push   %edi
80105b24:	56                   	push   %esi
80105b25:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b26:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b2c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b32:	50                   	push   %eax
80105b33:	6a 00                	push   $0x0
80105b35:	e8 36 f5 ff ff       	call   80105070 <argstr>
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	85 c0                	test   %eax,%eax
80105b3f:	0f 88 87 00 00 00    	js     80105bcc <sys_exec+0xac>
80105b45:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b4b:	83 ec 08             	sub    $0x8,%esp
80105b4e:	50                   	push   %eax
80105b4f:	6a 01                	push   $0x1
80105b51:	e8 6a f4 ff ff       	call   80104fc0 <argint>
80105b56:	83 c4 10             	add    $0x10,%esp
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	78 6f                	js     80105bcc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b5d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b63:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105b66:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b68:	68 80 00 00 00       	push   $0x80
80105b6d:	6a 00                	push   $0x0
80105b6f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b75:	50                   	push   %eax
80105b76:	e8 45 f1 ff ff       	call   80104cc0 <memset>
80105b7b:	83 c4 10             	add    $0x10,%esp
80105b7e:	eb 2c                	jmp    80105bac <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105b80:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b86:	85 c0                	test   %eax,%eax
80105b88:	74 56                	je     80105be0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b8a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105b90:	83 ec 08             	sub    $0x8,%esp
80105b93:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105b96:	52                   	push   %edx
80105b97:	50                   	push   %eax
80105b98:	e8 b3 f3 ff ff       	call   80104f50 <fetchstr>
80105b9d:	83 c4 10             	add    $0x10,%esp
80105ba0:	85 c0                	test   %eax,%eax
80105ba2:	78 28                	js     80105bcc <sys_exec+0xac>
  for(i=0;; i++){
80105ba4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105ba7:	83 fb 20             	cmp    $0x20,%ebx
80105baa:	74 20                	je     80105bcc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bac:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bb2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105bb9:	83 ec 08             	sub    $0x8,%esp
80105bbc:	57                   	push   %edi
80105bbd:	01 f0                	add    %esi,%eax
80105bbf:	50                   	push   %eax
80105bc0:	e8 4b f3 ff ff       	call   80104f10 <fetchint>
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	79 b4                	jns    80105b80 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105bcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105bcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bd4:	5b                   	pop    %ebx
80105bd5:	5e                   	pop    %esi
80105bd6:	5f                   	pop    %edi
80105bd7:	5d                   	pop    %ebp
80105bd8:	c3                   	ret    
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105be0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105be6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105be9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105bf0:	00 00 00 00 
  return exec(path, argv);
80105bf4:	50                   	push   %eax
80105bf5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bfb:	e8 10 ae ff ff       	call   80100a10 <exec>
80105c00:	83 c4 10             	add    $0x10,%esp
}
80105c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c06:	5b                   	pop    %ebx
80105c07:	5e                   	pop    %esi
80105c08:	5f                   	pop    %edi
80105c09:	5d                   	pop    %ebp
80105c0a:	c3                   	ret    
80105c0b:	90                   	nop
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_pipe>:

int
sys_pipe(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c16:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c19:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c1c:	6a 08                	push   $0x8
80105c1e:	50                   	push   %eax
80105c1f:	6a 00                	push   $0x0
80105c21:	e8 ea f3 ff ff       	call   80105010 <argptr>
80105c26:	83 c4 10             	add    $0x10,%esp
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	0f 88 ae 00 00 00    	js     80105cdf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c31:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c34:	83 ec 08             	sub    $0x8,%esp
80105c37:	50                   	push   %eax
80105c38:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c3b:	50                   	push   %eax
80105c3c:	e8 3f d6 ff ff       	call   80103280 <pipealloc>
80105c41:	83 c4 10             	add    $0x10,%esp
80105c44:	85 c0                	test   %eax,%eax
80105c46:	0f 88 93 00 00 00    	js     80105cdf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c4c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c4f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c51:	e8 fa da ff ff       	call   80103750 <myproc>
80105c56:	eb 10                	jmp    80105c68 <sys_pipe+0x58>
80105c58:	90                   	nop
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105c60:	83 c3 01             	add    $0x1,%ebx
80105c63:	83 fb 10             	cmp    $0x10,%ebx
80105c66:	74 60                	je     80105cc8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105c68:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c6c:	85 f6                	test   %esi,%esi
80105c6e:	75 f0                	jne    80105c60 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105c70:	8d 73 08             	lea    0x8(%ebx),%esi
80105c73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105c7a:	e8 d1 da ff ff       	call   80103750 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c7f:	31 d2                	xor    %edx,%edx
80105c81:	eb 0d                	jmp    80105c90 <sys_pipe+0x80>
80105c83:	90                   	nop
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c88:	83 c2 01             	add    $0x1,%edx
80105c8b:	83 fa 10             	cmp    $0x10,%edx
80105c8e:	74 28                	je     80105cb8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105c90:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c94:	85 c9                	test   %ecx,%ecx
80105c96:	75 f0                	jne    80105c88 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105c98:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105c9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c9f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ca1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ca4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ca7:	31 c0                	xor    %eax,%eax
}
80105ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cac:	5b                   	pop    %ebx
80105cad:	5e                   	pop    %esi
80105cae:	5f                   	pop    %edi
80105caf:	5d                   	pop    %ebp
80105cb0:	c3                   	ret    
80105cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105cb8:	e8 93 da ff ff       	call   80103750 <myproc>
80105cbd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105cc4:	00 
80105cc5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105cc8:	83 ec 0c             	sub    $0xc,%esp
80105ccb:	ff 75 e0             	pushl  -0x20(%ebp)
80105cce:	e8 6d b1 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105cd3:	58                   	pop    %eax
80105cd4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cd7:	e8 64 b1 ff ff       	call   80100e40 <fileclose>
    return -1;
80105cdc:	83 c4 10             	add    $0x10,%esp
80105cdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce4:	eb c3                	jmp    80105ca9 <sys_pipe+0x99>
80105ce6:	66 90                	xchg   %ax,%ax
80105ce8:	66 90                	xchg   %ax,%ax
80105cea:	66 90                	xchg   %ax,%ax
80105cec:	66 90                	xchg   %ax,%ax
80105cee:	66 90                	xchg   %ax,%ax

80105cf0 <sys_fork>:
#include "proc.h"
#include "proc_stat.h"

int
sys_fork(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105cf3:	5d                   	pop    %ebp
  return fork();
80105cf4:	e9 37 e6 ff ff       	jmp    80104330 <fork>
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_exit>:

int
sys_exit(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d06:	e8 b5 db ff ff       	call   801038c0 <exit>
  return 0;  // not reached
}
80105d0b:	31 c0                	xor    %eax,%eax
80105d0d:	c9                   	leave  
80105d0e:	c3                   	ret    
80105d0f:	90                   	nop

80105d10 <sys_wait>:

int
sys_wait(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d13:	5d                   	pop    %ebp
  return wait();
80105d14:	e9 a7 dd ff ff       	jmp    80103ac0 <wait>
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d20 <sys_kill>:

int
sys_kill(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	6a 00                	push   $0x0
80105d2c:	e8 8f f2 ff ff       	call   80104fc0 <argint>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	85 c0                	test   %eax,%eax
80105d36:	78 18                	js     80105d50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3e:	e8 fd df ff ff       	call   80103d40 <kill>
80105d43:	83 c4 10             	add    $0x10,%esp
}
80105d46:	c9                   	leave  
80105d47:	c3                   	ret    
80105d48:	90                   	nop
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d55:	c9                   	leave  
80105d56:	c3                   	ret    
80105d57:	89 f6                	mov    %esi,%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d60 <sys_getpid>:

int
sys_getpid(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d66:	e8 e5 d9 ff ff       	call   80103750 <myproc>
80105d6b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d6e:	c9                   	leave  
80105d6f:	c3                   	ret    

80105d70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d7a:	50                   	push   %eax
80105d7b:	6a 00                	push   $0x0
80105d7d:	e8 3e f2 ff ff       	call   80104fc0 <argint>
80105d82:	83 c4 10             	add    $0x10,%esp
80105d85:	85 c0                	test   %eax,%eax
80105d87:	78 27                	js     80105db0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105d89:	e8 c2 d9 ff ff       	call   80103750 <myproc>
  if(growproc(n) < 0)
80105d8e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d91:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d93:	ff 75 f4             	pushl  -0xc(%ebp)
80105d96:	e8 e5 d9 ff ff       	call   80103780 <growproc>
80105d9b:	83 c4 10             	add    $0x10,%esp
80105d9e:	85 c0                	test   %eax,%eax
80105da0:	78 0e                	js     80105db0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105da2:	89 d8                	mov    %ebx,%eax
80105da4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105da7:	c9                   	leave  
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105db0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105db5:	eb eb                	jmp    80105da2 <sys_sbrk+0x32>
80105db7:	89 f6                	mov    %esi,%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dc0 <sys_sleep>:

int
sys_sleep(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dca:	50                   	push   %eax
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 ee f1 ff ff       	call   80104fc0 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	0f 88 8a 00 00 00    	js     80105e67 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	68 e0 6e 11 80       	push   $0x80116ee0
80105de5:	e8 c6 ed ff ff       	call   80104bb0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ded:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105df0:	8b 1d 20 77 11 80    	mov    0x80117720,%ebx
  while(ticks - ticks0 < n){
80105df6:	85 d2                	test   %edx,%edx
80105df8:	75 27                	jne    80105e21 <sys_sleep+0x61>
80105dfa:	eb 54                	jmp    80105e50 <sys_sleep+0x90>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e00:	83 ec 08             	sub    $0x8,%esp
80105e03:	68 e0 6e 11 80       	push   $0x80116ee0
80105e08:	68 20 77 11 80       	push   $0x80117720
80105e0d:	e8 ee db ff ff       	call   80103a00 <sleep>
  while(ticks - ticks0 < n){
80105e12:	a1 20 77 11 80       	mov    0x80117720,%eax
80105e17:	83 c4 10             	add    $0x10,%esp
80105e1a:	29 d8                	sub    %ebx,%eax
80105e1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e1f:	73 2f                	jae    80105e50 <sys_sleep+0x90>
    if(myproc()->killed){
80105e21:	e8 2a d9 ff ff       	call   80103750 <myproc>
80105e26:	8b 40 24             	mov    0x24(%eax),%eax
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	74 d3                	je     80105e00 <sys_sleep+0x40>
      release(&tickslock);
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	68 e0 6e 11 80       	push   $0x80116ee0
80105e35:	e8 36 ee ff ff       	call   80104c70 <release>
      return -1;
80105e3a:	83 c4 10             	add    $0x10,%esp
80105e3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	68 e0 6e 11 80       	push   $0x80116ee0
80105e58:	e8 13 ee ff ff       	call   80104c70 <release>
  return 0;
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	31 c0                	xor    %eax,%eax
}
80105e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e65:	c9                   	leave  
80105e66:	c3                   	ret    
    return -1;
80105e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6c:	eb f4                	jmp    80105e62 <sys_sleep+0xa2>
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	53                   	push   %ebx
80105e74:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105e77:	68 e0 6e 11 80       	push   $0x80116ee0
80105e7c:	e8 2f ed ff ff       	call   80104bb0 <acquire>
  xticks = ticks;
80105e81:	8b 1d 20 77 11 80    	mov    0x80117720,%ebx
  release(&tickslock);
80105e87:	c7 04 24 e0 6e 11 80 	movl   $0x80116ee0,(%esp)
80105e8e:	e8 dd ed ff ff       	call   80104c70 <release>
  return xticks;
}
80105e93:	89 d8                	mov    %ebx,%eax
80105e95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e98:	c9                   	leave  
80105e99:	c3                   	ret    
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ea0 <sys_waitx>:

// Assignment
int sys_waitx(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime, *rtime;

  if(argptr(0, (char **)&wtime, sizeof(int)) < 0)
80105ea6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ea9:	6a 04                	push   $0x4
80105eab:	50                   	push   %eax
80105eac:	6a 00                	push   $0x0
80105eae:	e8 5d f1 ff ff       	call   80105010 <argptr>
80105eb3:	83 c4 10             	add    $0x10,%esp
80105eb6:	85 c0                	test   %eax,%eax
80105eb8:	78 2e                	js     80105ee8 <sys_waitx+0x48>
  {
    return -1;
  }

  if(argptr(1, (char **)&rtime, sizeof(int)) < 0)
80105eba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ebd:	83 ec 04             	sub    $0x4,%esp
80105ec0:	6a 04                	push   $0x4
80105ec2:	50                   	push   %eax
80105ec3:	6a 01                	push   $0x1
80105ec5:	e8 46 f1 ff ff       	call   80105010 <argptr>
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	85 c0                	test   %eax,%eax
80105ecf:	78 17                	js     80105ee8 <sys_waitx+0x48>
  {
    return -1;
  }

  return waitx(wtime, rtime);
80105ed1:	83 ec 08             	sub    $0x8,%esp
80105ed4:	ff 75 f4             	pushl  -0xc(%ebp)
80105ed7:	ff 75 f0             	pushl  -0x10(%ebp)
80105eda:	e8 e1 dc ff ff       	call   80103bc0 <waitx>
80105edf:	83 c4 10             	add    $0x10,%esp
}
80105ee2:	c9                   	leave  
80105ee3:	c3                   	ret    
80105ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eed:	c9                   	leave  
80105eee:	c3                   	ret    
80105eef:	90                   	nop

80105ef0 <sys_set_priority>:

int sys_set_priority(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 20             	sub    $0x20,%esp
  int new_priority;
  int pid;

  if(argint(0, &pid) < 0)
80105ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ef9:	50                   	push   %eax
80105efa:	6a 00                	push   $0x0
80105efc:	e8 bf f0 ff ff       	call   80104fc0 <argint>
80105f01:	83 c4 10             	add    $0x10,%esp
80105f04:	85 c0                	test   %eax,%eax
80105f06:	78 28                	js     80105f30 <sys_set_priority+0x40>
  {
    return -1;
  }

  if(argint(1, &new_priority) < 0)
80105f08:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f0b:	83 ec 08             	sub    $0x8,%esp
80105f0e:	50                   	push   %eax
80105f0f:	6a 01                	push   $0x1
80105f11:	e8 aa f0 ff ff       	call   80104fc0 <argint>
80105f16:	83 c4 10             	add    $0x10,%esp
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	78 13                	js     80105f30 <sys_set_priority+0x40>
  {
    return -1;
  }

  return set_priority(pid, new_priority);
80105f1d:	83 ec 08             	sub    $0x8,%esp
80105f20:	ff 75 f0             	pushl  -0x10(%ebp)
80105f23:	ff 75 f4             	pushl  -0xc(%ebp)
80105f26:	e8 65 df ff ff       	call   80103e90 <set_priority>
80105f2b:	83 c4 10             	add    $0x10,%esp
}
80105f2e:	c9                   	leave  
80105f2f:	c3                   	ret    
    return -1;
80105f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f35:	c9                   	leave  
80105f36:	c3                   	ret    
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f40 <sys_getpinfo>:

int sys_getpinfo(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 20             	sub    $0x20,%esp
    int pid;
    struct proc_stat* stat;

    if(argint(0, &pid) < 0)
80105f46:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f49:	50                   	push   %eax
80105f4a:	6a 00                	push   $0x0
80105f4c:	e8 6f f0 ff ff       	call   80104fc0 <argint>
80105f51:	83 c4 10             	add    $0x10,%esp
80105f54:	85 c0                	test   %eax,%eax
80105f56:	78 30                	js     80105f88 <sys_getpinfo+0x48>
    {
        return -1;
    }

    if(argptr(1, (char**)&stat, sizeof(struct proc_stat)) < 0)
80105f58:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f5b:	83 ec 04             	sub    $0x4,%esp
80105f5e:	6a 24                	push   $0x24
80105f60:	50                   	push   %eax
80105f61:	6a 01                	push   $0x1
80105f63:	e8 a8 f0 ff ff       	call   80105010 <argptr>
80105f68:	83 c4 10             	add    $0x10,%esp
80105f6b:	85 c0                	test   %eax,%eax
80105f6d:	78 19                	js     80105f88 <sys_getpinfo+0x48>
    {
        return -1;
    }
    
    return getpinfo(pid, stat);
80105f6f:	83 ec 08             	sub    $0x8,%esp
80105f72:	ff 75 f4             	pushl  -0xc(%ebp)
80105f75:	ff 75 f0             	pushl  -0x10(%ebp)
80105f78:	e8 63 e8 ff ff       	call   801047e0 <getpinfo>
80105f7d:	83 c4 10             	add    $0x10,%esp
}
80105f80:	c9                   	leave  
80105f81:	c3                   	ret    
80105f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80105f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f8d:	c9                   	leave  
80105f8e:	c3                   	ret    

80105f8f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f8f:	1e                   	push   %ds
  pushl %es
80105f90:	06                   	push   %es
  pushl %fs
80105f91:	0f a0                	push   %fs
  pushl %gs
80105f93:	0f a8                	push   %gs
  pushal
80105f95:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f96:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f9a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f9c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f9e:	54                   	push   %esp
  call trap
80105f9f:	e8 cc 00 00 00       	call   80106070 <trap>
  addl $4, %esp
80105fa4:	83 c4 04             	add    $0x4,%esp

80105fa7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fa7:	61                   	popa   
  popl %gs
80105fa8:	0f a9                	pop    %gs
  popl %fs
80105faa:	0f a1                	pop    %fs
  popl %es
80105fac:	07                   	pop    %es
  popl %ds
80105fad:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fae:	83 c4 08             	add    $0x8,%esp
  iret
80105fb1:	cf                   	iret   
80105fb2:	66 90                	xchg   %ax,%ax
80105fb4:	66 90                	xchg   %ax,%ax
80105fb6:	66 90                	xchg   %ax,%ax
80105fb8:	66 90                	xchg   %ax,%ax
80105fba:	66 90                	xchg   %ax,%ax
80105fbc:	66 90                	xchg   %ax,%ax
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105fc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105fc1:	31 c0                	xor    %eax,%eax
{
80105fc3:	89 e5                	mov    %esp,%ebp
80105fc5:	83 ec 08             	sub    $0x8,%esp
80105fc8:	90                   	nop
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105fd0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105fd7:	c7 04 c5 22 6f 11 80 	movl   $0x8e000008,-0x7fee90de(,%eax,8)
80105fde:	08 00 00 8e 
80105fe2:	66 89 14 c5 20 6f 11 	mov    %dx,-0x7fee90e0(,%eax,8)
80105fe9:	80 
80105fea:	c1 ea 10             	shr    $0x10,%edx
80105fed:	66 89 14 c5 26 6f 11 	mov    %dx,-0x7fee90da(,%eax,8)
80105ff4:	80 
  for(i = 0; i < 256; i++)
80105ff5:	83 c0 01             	add    $0x1,%eax
80105ff8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ffd:	75 d1                	jne    80105fd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fff:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106004:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106007:	c7 05 22 71 11 80 08 	movl   $0xef000008,0x80117122
8010600e:	00 00 ef 
  initlock(&tickslock, "time");
80106011:	68 25 80 10 80       	push   $0x80108025
80106016:	68 e0 6e 11 80       	push   $0x80116ee0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010601b:	66 a3 20 71 11 80    	mov    %ax,0x80117120
80106021:	c1 e8 10             	shr    $0x10,%eax
80106024:	66 a3 26 71 11 80    	mov    %ax,0x80117126
  initlock(&tickslock, "time");
8010602a:	e8 41 ea ff ff       	call   80104a70 <initlock>
}
8010602f:	83 c4 10             	add    $0x10,%esp
80106032:	c9                   	leave  
80106033:	c3                   	ret    
80106034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010603a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106040 <idtinit>:

void
idtinit(void)
{
80106040:	55                   	push   %ebp
  pd[0] = size-1;
80106041:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106046:	89 e5                	mov    %esp,%ebp
80106048:	83 ec 10             	sub    $0x10,%esp
8010604b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010604f:	b8 20 6f 11 80       	mov    $0x80116f20,%eax
80106054:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106058:	c1 e8 10             	shr    $0x10,%eax
8010605b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010605f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106062:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106065:	c9                   	leave  
80106066:	c3                   	ret    
80106067:	89 f6                	mov    %esi,%esi
80106069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106070 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	57                   	push   %edi
80106074:	56                   	push   %esi
80106075:	53                   	push   %ebx
80106076:	83 ec 1c             	sub    $0x1c,%esp
80106079:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010607c:	8b 47 30             	mov    0x30(%edi),%eax
8010607f:	83 f8 40             	cmp    $0x40,%eax
80106082:	0f 84 f8 00 00 00    	je     80106180 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106088:	83 e8 20             	sub    $0x20,%eax
8010608b:	83 f8 1f             	cmp    $0x1f,%eax
8010608e:	77 10                	ja     801060a0 <trap+0x30>
80106090:	ff 24 85 cc 80 10 80 	jmp    *-0x7fef7f34(,%eax,4)
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801060a0:	e8 ab d6 ff ff       	call   80103750 <myproc>
801060a5:	85 c0                	test   %eax,%eax
801060a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801060aa:	0f 84 4a 02 00 00    	je     801062fa <trap+0x28a>
801060b0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801060b4:	0f 84 40 02 00 00    	je     801062fa <trap+0x28a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060ba:	0f 20 d1             	mov    %cr2,%ecx
801060bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060c0:	e8 6b d6 ff ff       	call   80103730 <cpuid>
801060c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801060c8:	8b 47 34             	mov    0x34(%edi),%eax
801060cb:	8b 77 30             	mov    0x30(%edi),%esi
801060ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801060d1:	e8 7a d6 ff ff       	call   80103750 <myproc>
801060d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060d9:	e8 72 d6 ff ff       	call   80103750 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060e4:	51                   	push   %ecx
801060e5:	53                   	push   %ebx
801060e6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801060e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801060ed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060ee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060f1:	52                   	push   %edx
801060f2:	ff 70 10             	pushl  0x10(%eax)
801060f5:	68 88 80 10 80       	push   $0x80108088
801060fa:	e8 61 a5 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801060ff:	83 c4 20             	add    $0x20,%esp
80106102:	e8 49 d6 ff ff       	call   80103750 <myproc>
80106107:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010610e:	e8 3d d6 ff ff       	call   80103750 <myproc>
80106113:	85 c0                	test   %eax,%eax
80106115:	74 1d                	je     80106134 <trap+0xc4>
80106117:	e8 34 d6 ff ff       	call   80103750 <myproc>
8010611c:	8b 50 24             	mov    0x24(%eax),%edx
8010611f:	85 d2                	test   %edx,%edx
80106121:	74 11                	je     80106134 <trap+0xc4>
80106123:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106127:	83 e0 03             	and    $0x3,%eax
8010612a:	66 83 f8 03          	cmp    $0x3,%ax
8010612e:	0f 84 bc 01 00 00    	je     801062f0 <trap+0x280>
    }

    #else
    #ifdef MLFQ

    if(myproc() && myproc()->state == RUNNING && myproc() -> queueNo != 4 && myproc() -> cur_time > ticksQ[myproc() -> queueNo])
80106134:	e8 17 d6 ff ff       	call   80103750 <myproc>
80106139:	85 c0                	test   %eax,%eax
8010613b:	74 0f                	je     8010614c <trap+0xdc>
8010613d:	e8 0e d6 ff ff       	call   80103750 <myproc>
80106142:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106146:	0f 84 4c 01 00 00    	je     80106298 <trap+0x228>

    #endif
    #endif

    // Check if the process has been killed since we yielded
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010614c:	e8 ff d5 ff ff       	call   80103750 <myproc>
80106151:	85 c0                	test   %eax,%eax
80106153:	74 19                	je     8010616e <trap+0xfe>
80106155:	e8 f6 d5 ff ff       	call   80103750 <myproc>
8010615a:	8b 40 24             	mov    0x24(%eax),%eax
8010615d:	85 c0                	test   %eax,%eax
8010615f:	74 0d                	je     8010616e <trap+0xfe>
80106161:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106165:	83 e0 03             	and    $0x3,%eax
80106168:	66 83 f8 03          	cmp    $0x3,%ax
8010616c:	74 3b                	je     801061a9 <trap+0x139>
      exit();
  
  #endif
}
8010616e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106171:	5b                   	pop    %ebx
80106172:	5e                   	pop    %esi
80106173:	5f                   	pop    %edi
80106174:	5d                   	pop    %ebp
80106175:	c3                   	ret    
80106176:	8d 76 00             	lea    0x0(%esi),%esi
80106179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(myproc()->killed)
80106180:	e8 cb d5 ff ff       	call   80103750 <myproc>
80106185:	8b 58 24             	mov    0x24(%eax),%ebx
80106188:	85 db                	test   %ebx,%ebx
8010618a:	0f 85 50 01 00 00    	jne    801062e0 <trap+0x270>
    myproc()->tf = tf;
80106190:	e8 bb d5 ff ff       	call   80103750 <myproc>
80106195:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106198:	e8 13 ef ff ff       	call   801050b0 <syscall>
    if(myproc()->killed)
8010619d:	e8 ae d5 ff ff       	call   80103750 <myproc>
801061a2:	8b 48 24             	mov    0x24(%eax),%ecx
801061a5:	85 c9                	test   %ecx,%ecx
801061a7:	74 c5                	je     8010616e <trap+0xfe>
}
801061a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061ac:	5b                   	pop    %ebx
801061ad:	5e                   	pop    %esi
801061ae:	5f                   	pop    %edi
801061af:	5d                   	pop    %ebp
      exit();
801061b0:	e9 0b d7 ff ff       	jmp    801038c0 <exit>
801061b5:	8d 76 00             	lea    0x0(%esi),%esi
    ideintr();
801061b8:	e8 c3 be ff ff       	call   80102080 <ideintr>
    lapiceoi();
801061bd:	e8 8e c5 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061c2:	e8 89 d5 ff ff       	call   80103750 <myproc>
801061c7:	85 c0                	test   %eax,%eax
801061c9:	0f 85 48 ff ff ff    	jne    80106117 <trap+0xa7>
801061cf:	e9 60 ff ff ff       	jmp    80106134 <trap+0xc4>
801061d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801061d8:	e8 53 d5 ff ff       	call   80103730 <cpuid>
801061dd:	85 c0                	test   %eax,%eax
801061df:	75 dc                	jne    801061bd <trap+0x14d>
      acquire(&tickslock);
801061e1:	83 ec 0c             	sub    $0xc,%esp
801061e4:	68 e0 6e 11 80       	push   $0x80116ee0
801061e9:	e8 c2 e9 ff ff       	call   80104bb0 <acquire>
      ticks++;
801061ee:	83 05 20 77 11 80 01 	addl   $0x1,0x80117720
      modify_times();
801061f5:	e8 16 e3 ff ff       	call   80104510 <modify_times>
      wakeup(&ticks);
801061fa:	c7 04 24 20 77 11 80 	movl   $0x80117720,(%esp)
80106201:	e8 da da ff ff       	call   80103ce0 <wakeup>
      release(&tickslock);
80106206:	c7 04 24 e0 6e 11 80 	movl   $0x80116ee0,(%esp)
8010620d:	e8 5e ea ff ff       	call   80104c70 <release>
80106212:	83 c4 10             	add    $0x10,%esp
80106215:	eb a6                	jmp    801061bd <trap+0x14d>
80106217:	89 f6                	mov    %esi,%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
80106220:	e8 eb c3 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
80106225:	e8 26 c5 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010622a:	e8 21 d5 ff ff       	call   80103750 <myproc>
8010622f:	85 c0                	test   %eax,%eax
80106231:	0f 85 e0 fe ff ff    	jne    80106117 <trap+0xa7>
80106237:	e9 f8 fe ff ff       	jmp    80106134 <trap+0xc4>
8010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106240:	e8 5b 02 00 00       	call   801064a0 <uartintr>
    lapiceoi();
80106245:	e8 06 c5 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010624a:	e8 01 d5 ff ff       	call   80103750 <myproc>
8010624f:	85 c0                	test   %eax,%eax
80106251:	0f 85 c0 fe ff ff    	jne    80106117 <trap+0xa7>
80106257:	e9 d8 fe ff ff       	jmp    80106134 <trap+0xc4>
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106260:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106264:	8b 77 38             	mov    0x38(%edi),%esi
80106267:	e8 c4 d4 ff ff       	call   80103730 <cpuid>
8010626c:	56                   	push   %esi
8010626d:	53                   	push   %ebx
8010626e:	50                   	push   %eax
8010626f:	68 30 80 10 80       	push   $0x80108030
80106274:	e8 e7 a3 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106279:	e8 d2 c4 ff ff       	call   80102750 <lapiceoi>
    break;
8010627e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106281:	e8 ca d4 ff ff       	call   80103750 <myproc>
80106286:	85 c0                	test   %eax,%eax
80106288:	0f 85 89 fe ff ff    	jne    80106117 <trap+0xa7>
8010628e:	e9 a1 fe ff ff       	jmp    80106134 <trap+0xc4>
80106293:	90                   	nop
80106294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc() && myproc()->state == RUNNING && myproc() -> queueNo != 4 && myproc() -> cur_time > ticksQ[myproc() -> queueNo])
80106298:	e8 b3 d4 ff ff       	call   80103750 <myproc>
8010629d:	83 b8 ac 00 00 00 04 	cmpl   $0x4,0xac(%eax)
801062a4:	0f 84 a2 fe ff ff    	je     8010614c <trap+0xdc>
801062aa:	e8 a1 d4 ff ff       	call   80103750 <myproc>
801062af:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
801062b5:	e8 96 d4 ff ff       	call   80103750 <myproc>
801062ba:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801062c0:	3b 1c 85 38 0f 11 80 	cmp    -0x7feef0c8(,%eax,4),%ebx
801062c7:	0f 8e 7f fe ff ff    	jle    8010614c <trap+0xdc>
      yield();
801062cd:	e8 7e e1 ff ff       	call   80104450 <yield>
801062d2:	e9 75 fe ff ff       	jmp    8010614c <trap+0xdc>
801062d7:	89 f6                	mov    %esi,%esi
801062d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
801062e0:	e8 db d5 ff ff       	call   801038c0 <exit>
801062e5:	e9 a6 fe ff ff       	jmp    80106190 <trap+0x120>
801062ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801062f0:	e8 cb d5 ff ff       	call   801038c0 <exit>
801062f5:	e9 3a fe ff ff       	jmp    80106134 <trap+0xc4>
801062fa:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062fd:	e8 2e d4 ff ff       	call   80103730 <cpuid>
80106302:	83 ec 0c             	sub    $0xc,%esp
80106305:	56                   	push   %esi
80106306:	53                   	push   %ebx
80106307:	50                   	push   %eax
80106308:	ff 77 30             	pushl  0x30(%edi)
8010630b:	68 54 80 10 80       	push   $0x80108054
80106310:	e8 4b a3 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106315:	83 c4 14             	add    $0x14,%esp
80106318:	68 2a 80 10 80       	push   $0x8010802a
8010631d:	e8 6e a0 ff ff       	call   80100390 <panic>
80106322:	66 90                	xchg   %ax,%ax
80106324:	66 90                	xchg   %ax,%ax
80106326:	66 90                	xchg   %ax,%ax
80106328:	66 90                	xchg   %ax,%ax
8010632a:	66 90                	xchg   %ax,%ax
8010632c:	66 90                	xchg   %ax,%ax
8010632e:	66 90                	xchg   %ax,%ax

80106330 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106330:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106335:	55                   	push   %ebp
80106336:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106338:	85 c0                	test   %eax,%eax
8010633a:	74 1c                	je     80106358 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010633c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106341:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106342:	a8 01                	test   $0x1,%al
80106344:	74 12                	je     80106358 <uartgetc+0x28>
80106346:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010634b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010634c:	0f b6 c0             	movzbl %al,%eax
}
8010634f:	5d                   	pop    %ebp
80106350:	c3                   	ret    
80106351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010635d:	5d                   	pop    %ebp
8010635e:	c3                   	ret    
8010635f:	90                   	nop

80106360 <uartputc.part.0>:
uartputc(int c)
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	57                   	push   %edi
80106364:	56                   	push   %esi
80106365:	53                   	push   %ebx
80106366:	89 c7                	mov    %eax,%edi
80106368:	bb 80 00 00 00       	mov    $0x80,%ebx
8010636d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106372:	83 ec 0c             	sub    $0xc,%esp
80106375:	eb 1b                	jmp    80106392 <uartputc.part.0+0x32>
80106377:	89 f6                	mov    %esi,%esi
80106379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106380:	83 ec 0c             	sub    $0xc,%esp
80106383:	6a 0a                	push   $0xa
80106385:	e8 e6 c3 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010638a:	83 c4 10             	add    $0x10,%esp
8010638d:	83 eb 01             	sub    $0x1,%ebx
80106390:	74 07                	je     80106399 <uartputc.part.0+0x39>
80106392:	89 f2                	mov    %esi,%edx
80106394:	ec                   	in     (%dx),%al
80106395:	a8 20                	test   $0x20,%al
80106397:	74 e7                	je     80106380 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106399:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010639e:	89 f8                	mov    %edi,%eax
801063a0:	ee                   	out    %al,(%dx)
}
801063a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a4:	5b                   	pop    %ebx
801063a5:	5e                   	pop    %esi
801063a6:	5f                   	pop    %edi
801063a7:	5d                   	pop    %ebp
801063a8:	c3                   	ret    
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063b0 <uartinit>:
{
801063b0:	55                   	push   %ebp
801063b1:	31 c9                	xor    %ecx,%ecx
801063b3:	89 c8                	mov    %ecx,%eax
801063b5:	89 e5                	mov    %esp,%ebp
801063b7:	57                   	push   %edi
801063b8:	56                   	push   %esi
801063b9:	53                   	push   %ebx
801063ba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801063bf:	89 da                	mov    %ebx,%edx
801063c1:	83 ec 0c             	sub    $0xc,%esp
801063c4:	ee                   	out    %al,(%dx)
801063c5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801063ca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801063cf:	89 fa                	mov    %edi,%edx
801063d1:	ee                   	out    %al,(%dx)
801063d2:	b8 0c 00 00 00       	mov    $0xc,%eax
801063d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063dc:	ee                   	out    %al,(%dx)
801063dd:	be f9 03 00 00       	mov    $0x3f9,%esi
801063e2:	89 c8                	mov    %ecx,%eax
801063e4:	89 f2                	mov    %esi,%edx
801063e6:	ee                   	out    %al,(%dx)
801063e7:	b8 03 00 00 00       	mov    $0x3,%eax
801063ec:	89 fa                	mov    %edi,%edx
801063ee:	ee                   	out    %al,(%dx)
801063ef:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063f4:	89 c8                	mov    %ecx,%eax
801063f6:	ee                   	out    %al,(%dx)
801063f7:	b8 01 00 00 00       	mov    $0x1,%eax
801063fc:	89 f2                	mov    %esi,%edx
801063fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063ff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106404:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106405:	3c ff                	cmp    $0xff,%al
80106407:	74 5a                	je     80106463 <uartinit+0xb3>
  uart = 1;
80106409:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106410:	00 00 00 
80106413:	89 da                	mov    %ebx,%edx
80106415:	ec                   	in     (%dx),%al
80106416:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010641b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010641c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010641f:	bb 4c 81 10 80       	mov    $0x8010814c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106424:	6a 00                	push   $0x0
80106426:	6a 04                	push   $0x4
80106428:	e8 a3 be ff ff       	call   801022d0 <ioapicenable>
8010642d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106430:	b8 78 00 00 00       	mov    $0x78,%eax
80106435:	eb 13                	jmp    8010644a <uartinit+0x9a>
80106437:	89 f6                	mov    %esi,%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106440:	83 c3 01             	add    $0x1,%ebx
80106443:	0f be 03             	movsbl (%ebx),%eax
80106446:	84 c0                	test   %al,%al
80106448:	74 19                	je     80106463 <uartinit+0xb3>
  if(!uart)
8010644a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106450:	85 d2                	test   %edx,%edx
80106452:	74 ec                	je     80106440 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106454:	83 c3 01             	add    $0x1,%ebx
80106457:	e8 04 ff ff ff       	call   80106360 <uartputc.part.0>
8010645c:	0f be 03             	movsbl (%ebx),%eax
8010645f:	84 c0                	test   %al,%al
80106461:	75 e7                	jne    8010644a <uartinit+0x9a>
}
80106463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106466:	5b                   	pop    %ebx
80106467:	5e                   	pop    %esi
80106468:	5f                   	pop    %edi
80106469:	5d                   	pop    %ebp
8010646a:	c3                   	ret    
8010646b:	90                   	nop
8010646c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106470 <uartputc>:
  if(!uart)
80106470:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106476:	55                   	push   %ebp
80106477:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106479:	85 d2                	test   %edx,%edx
{
8010647b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010647e:	74 10                	je     80106490 <uartputc+0x20>
}
80106480:	5d                   	pop    %ebp
80106481:	e9 da fe ff ff       	jmp    80106360 <uartputc.part.0>
80106486:	8d 76 00             	lea    0x0(%esi),%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106490:	5d                   	pop    %ebp
80106491:	c3                   	ret    
80106492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064a0 <uartintr>:

void
uartintr(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801064a6:	68 30 63 10 80       	push   $0x80106330
801064ab:	e8 60 a3 ff ff       	call   80100810 <consoleintr>
}
801064b0:	83 c4 10             	add    $0x10,%esp
801064b3:	c9                   	leave  
801064b4:	c3                   	ret    

801064b5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $0
801064b7:	6a 00                	push   $0x0
  jmp alltraps
801064b9:	e9 d1 fa ff ff       	jmp    80105f8f <alltraps>

801064be <vector1>:
.globl vector1
vector1:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $1
801064c0:	6a 01                	push   $0x1
  jmp alltraps
801064c2:	e9 c8 fa ff ff       	jmp    80105f8f <alltraps>

801064c7 <vector2>:
.globl vector2
vector2:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $2
801064c9:	6a 02                	push   $0x2
  jmp alltraps
801064cb:	e9 bf fa ff ff       	jmp    80105f8f <alltraps>

801064d0 <vector3>:
.globl vector3
vector3:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $3
801064d2:	6a 03                	push   $0x3
  jmp alltraps
801064d4:	e9 b6 fa ff ff       	jmp    80105f8f <alltraps>

801064d9 <vector4>:
.globl vector4
vector4:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $4
801064db:	6a 04                	push   $0x4
  jmp alltraps
801064dd:	e9 ad fa ff ff       	jmp    80105f8f <alltraps>

801064e2 <vector5>:
.globl vector5
vector5:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $5
801064e4:	6a 05                	push   $0x5
  jmp alltraps
801064e6:	e9 a4 fa ff ff       	jmp    80105f8f <alltraps>

801064eb <vector6>:
.globl vector6
vector6:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $6
801064ed:	6a 06                	push   $0x6
  jmp alltraps
801064ef:	e9 9b fa ff ff       	jmp    80105f8f <alltraps>

801064f4 <vector7>:
.globl vector7
vector7:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $7
801064f6:	6a 07                	push   $0x7
  jmp alltraps
801064f8:	e9 92 fa ff ff       	jmp    80105f8f <alltraps>

801064fd <vector8>:
.globl vector8
vector8:
  pushl $8
801064fd:	6a 08                	push   $0x8
  jmp alltraps
801064ff:	e9 8b fa ff ff       	jmp    80105f8f <alltraps>

80106504 <vector9>:
.globl vector9
vector9:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $9
80106506:	6a 09                	push   $0x9
  jmp alltraps
80106508:	e9 82 fa ff ff       	jmp    80105f8f <alltraps>

8010650d <vector10>:
.globl vector10
vector10:
  pushl $10
8010650d:	6a 0a                	push   $0xa
  jmp alltraps
8010650f:	e9 7b fa ff ff       	jmp    80105f8f <alltraps>

80106514 <vector11>:
.globl vector11
vector11:
  pushl $11
80106514:	6a 0b                	push   $0xb
  jmp alltraps
80106516:	e9 74 fa ff ff       	jmp    80105f8f <alltraps>

8010651b <vector12>:
.globl vector12
vector12:
  pushl $12
8010651b:	6a 0c                	push   $0xc
  jmp alltraps
8010651d:	e9 6d fa ff ff       	jmp    80105f8f <alltraps>

80106522 <vector13>:
.globl vector13
vector13:
  pushl $13
80106522:	6a 0d                	push   $0xd
  jmp alltraps
80106524:	e9 66 fa ff ff       	jmp    80105f8f <alltraps>

80106529 <vector14>:
.globl vector14
vector14:
  pushl $14
80106529:	6a 0e                	push   $0xe
  jmp alltraps
8010652b:	e9 5f fa ff ff       	jmp    80105f8f <alltraps>

80106530 <vector15>:
.globl vector15
vector15:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $15
80106532:	6a 0f                	push   $0xf
  jmp alltraps
80106534:	e9 56 fa ff ff       	jmp    80105f8f <alltraps>

80106539 <vector16>:
.globl vector16
vector16:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $16
8010653b:	6a 10                	push   $0x10
  jmp alltraps
8010653d:	e9 4d fa ff ff       	jmp    80105f8f <alltraps>

80106542 <vector17>:
.globl vector17
vector17:
  pushl $17
80106542:	6a 11                	push   $0x11
  jmp alltraps
80106544:	e9 46 fa ff ff       	jmp    80105f8f <alltraps>

80106549 <vector18>:
.globl vector18
vector18:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $18
8010654b:	6a 12                	push   $0x12
  jmp alltraps
8010654d:	e9 3d fa ff ff       	jmp    80105f8f <alltraps>

80106552 <vector19>:
.globl vector19
vector19:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $19
80106554:	6a 13                	push   $0x13
  jmp alltraps
80106556:	e9 34 fa ff ff       	jmp    80105f8f <alltraps>

8010655b <vector20>:
.globl vector20
vector20:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $20
8010655d:	6a 14                	push   $0x14
  jmp alltraps
8010655f:	e9 2b fa ff ff       	jmp    80105f8f <alltraps>

80106564 <vector21>:
.globl vector21
vector21:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $21
80106566:	6a 15                	push   $0x15
  jmp alltraps
80106568:	e9 22 fa ff ff       	jmp    80105f8f <alltraps>

8010656d <vector22>:
.globl vector22
vector22:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $22
8010656f:	6a 16                	push   $0x16
  jmp alltraps
80106571:	e9 19 fa ff ff       	jmp    80105f8f <alltraps>

80106576 <vector23>:
.globl vector23
vector23:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $23
80106578:	6a 17                	push   $0x17
  jmp alltraps
8010657a:	e9 10 fa ff ff       	jmp    80105f8f <alltraps>

8010657f <vector24>:
.globl vector24
vector24:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $24
80106581:	6a 18                	push   $0x18
  jmp alltraps
80106583:	e9 07 fa ff ff       	jmp    80105f8f <alltraps>

80106588 <vector25>:
.globl vector25
vector25:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $25
8010658a:	6a 19                	push   $0x19
  jmp alltraps
8010658c:	e9 fe f9 ff ff       	jmp    80105f8f <alltraps>

80106591 <vector26>:
.globl vector26
vector26:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $26
80106593:	6a 1a                	push   $0x1a
  jmp alltraps
80106595:	e9 f5 f9 ff ff       	jmp    80105f8f <alltraps>

8010659a <vector27>:
.globl vector27
vector27:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $27
8010659c:	6a 1b                	push   $0x1b
  jmp alltraps
8010659e:	e9 ec f9 ff ff       	jmp    80105f8f <alltraps>

801065a3 <vector28>:
.globl vector28
vector28:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $28
801065a5:	6a 1c                	push   $0x1c
  jmp alltraps
801065a7:	e9 e3 f9 ff ff       	jmp    80105f8f <alltraps>

801065ac <vector29>:
.globl vector29
vector29:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $29
801065ae:	6a 1d                	push   $0x1d
  jmp alltraps
801065b0:	e9 da f9 ff ff       	jmp    80105f8f <alltraps>

801065b5 <vector30>:
.globl vector30
vector30:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $30
801065b7:	6a 1e                	push   $0x1e
  jmp alltraps
801065b9:	e9 d1 f9 ff ff       	jmp    80105f8f <alltraps>

801065be <vector31>:
.globl vector31
vector31:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $31
801065c0:	6a 1f                	push   $0x1f
  jmp alltraps
801065c2:	e9 c8 f9 ff ff       	jmp    80105f8f <alltraps>

801065c7 <vector32>:
.globl vector32
vector32:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $32
801065c9:	6a 20                	push   $0x20
  jmp alltraps
801065cb:	e9 bf f9 ff ff       	jmp    80105f8f <alltraps>

801065d0 <vector33>:
.globl vector33
vector33:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $33
801065d2:	6a 21                	push   $0x21
  jmp alltraps
801065d4:	e9 b6 f9 ff ff       	jmp    80105f8f <alltraps>

801065d9 <vector34>:
.globl vector34
vector34:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $34
801065db:	6a 22                	push   $0x22
  jmp alltraps
801065dd:	e9 ad f9 ff ff       	jmp    80105f8f <alltraps>

801065e2 <vector35>:
.globl vector35
vector35:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $35
801065e4:	6a 23                	push   $0x23
  jmp alltraps
801065e6:	e9 a4 f9 ff ff       	jmp    80105f8f <alltraps>

801065eb <vector36>:
.globl vector36
vector36:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $36
801065ed:	6a 24                	push   $0x24
  jmp alltraps
801065ef:	e9 9b f9 ff ff       	jmp    80105f8f <alltraps>

801065f4 <vector37>:
.globl vector37
vector37:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $37
801065f6:	6a 25                	push   $0x25
  jmp alltraps
801065f8:	e9 92 f9 ff ff       	jmp    80105f8f <alltraps>

801065fd <vector38>:
.globl vector38
vector38:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $38
801065ff:	6a 26                	push   $0x26
  jmp alltraps
80106601:	e9 89 f9 ff ff       	jmp    80105f8f <alltraps>

80106606 <vector39>:
.globl vector39
vector39:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $39
80106608:	6a 27                	push   $0x27
  jmp alltraps
8010660a:	e9 80 f9 ff ff       	jmp    80105f8f <alltraps>

8010660f <vector40>:
.globl vector40
vector40:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $40
80106611:	6a 28                	push   $0x28
  jmp alltraps
80106613:	e9 77 f9 ff ff       	jmp    80105f8f <alltraps>

80106618 <vector41>:
.globl vector41
vector41:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $41
8010661a:	6a 29                	push   $0x29
  jmp alltraps
8010661c:	e9 6e f9 ff ff       	jmp    80105f8f <alltraps>

80106621 <vector42>:
.globl vector42
vector42:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $42
80106623:	6a 2a                	push   $0x2a
  jmp alltraps
80106625:	e9 65 f9 ff ff       	jmp    80105f8f <alltraps>

8010662a <vector43>:
.globl vector43
vector43:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $43
8010662c:	6a 2b                	push   $0x2b
  jmp alltraps
8010662e:	e9 5c f9 ff ff       	jmp    80105f8f <alltraps>

80106633 <vector44>:
.globl vector44
vector44:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $44
80106635:	6a 2c                	push   $0x2c
  jmp alltraps
80106637:	e9 53 f9 ff ff       	jmp    80105f8f <alltraps>

8010663c <vector45>:
.globl vector45
vector45:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $45
8010663e:	6a 2d                	push   $0x2d
  jmp alltraps
80106640:	e9 4a f9 ff ff       	jmp    80105f8f <alltraps>

80106645 <vector46>:
.globl vector46
vector46:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $46
80106647:	6a 2e                	push   $0x2e
  jmp alltraps
80106649:	e9 41 f9 ff ff       	jmp    80105f8f <alltraps>

8010664e <vector47>:
.globl vector47
vector47:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $47
80106650:	6a 2f                	push   $0x2f
  jmp alltraps
80106652:	e9 38 f9 ff ff       	jmp    80105f8f <alltraps>

80106657 <vector48>:
.globl vector48
vector48:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $48
80106659:	6a 30                	push   $0x30
  jmp alltraps
8010665b:	e9 2f f9 ff ff       	jmp    80105f8f <alltraps>

80106660 <vector49>:
.globl vector49
vector49:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $49
80106662:	6a 31                	push   $0x31
  jmp alltraps
80106664:	e9 26 f9 ff ff       	jmp    80105f8f <alltraps>

80106669 <vector50>:
.globl vector50
vector50:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $50
8010666b:	6a 32                	push   $0x32
  jmp alltraps
8010666d:	e9 1d f9 ff ff       	jmp    80105f8f <alltraps>

80106672 <vector51>:
.globl vector51
vector51:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $51
80106674:	6a 33                	push   $0x33
  jmp alltraps
80106676:	e9 14 f9 ff ff       	jmp    80105f8f <alltraps>

8010667b <vector52>:
.globl vector52
vector52:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $52
8010667d:	6a 34                	push   $0x34
  jmp alltraps
8010667f:	e9 0b f9 ff ff       	jmp    80105f8f <alltraps>

80106684 <vector53>:
.globl vector53
vector53:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $53
80106686:	6a 35                	push   $0x35
  jmp alltraps
80106688:	e9 02 f9 ff ff       	jmp    80105f8f <alltraps>

8010668d <vector54>:
.globl vector54
vector54:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $54
8010668f:	6a 36                	push   $0x36
  jmp alltraps
80106691:	e9 f9 f8 ff ff       	jmp    80105f8f <alltraps>

80106696 <vector55>:
.globl vector55
vector55:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $55
80106698:	6a 37                	push   $0x37
  jmp alltraps
8010669a:	e9 f0 f8 ff ff       	jmp    80105f8f <alltraps>

8010669f <vector56>:
.globl vector56
vector56:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $56
801066a1:	6a 38                	push   $0x38
  jmp alltraps
801066a3:	e9 e7 f8 ff ff       	jmp    80105f8f <alltraps>

801066a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $57
801066aa:	6a 39                	push   $0x39
  jmp alltraps
801066ac:	e9 de f8 ff ff       	jmp    80105f8f <alltraps>

801066b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $58
801066b3:	6a 3a                	push   $0x3a
  jmp alltraps
801066b5:	e9 d5 f8 ff ff       	jmp    80105f8f <alltraps>

801066ba <vector59>:
.globl vector59
vector59:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $59
801066bc:	6a 3b                	push   $0x3b
  jmp alltraps
801066be:	e9 cc f8 ff ff       	jmp    80105f8f <alltraps>

801066c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $60
801066c5:	6a 3c                	push   $0x3c
  jmp alltraps
801066c7:	e9 c3 f8 ff ff       	jmp    80105f8f <alltraps>

801066cc <vector61>:
.globl vector61
vector61:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $61
801066ce:	6a 3d                	push   $0x3d
  jmp alltraps
801066d0:	e9 ba f8 ff ff       	jmp    80105f8f <alltraps>

801066d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $62
801066d7:	6a 3e                	push   $0x3e
  jmp alltraps
801066d9:	e9 b1 f8 ff ff       	jmp    80105f8f <alltraps>

801066de <vector63>:
.globl vector63
vector63:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $63
801066e0:	6a 3f                	push   $0x3f
  jmp alltraps
801066e2:	e9 a8 f8 ff ff       	jmp    80105f8f <alltraps>

801066e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $64
801066e9:	6a 40                	push   $0x40
  jmp alltraps
801066eb:	e9 9f f8 ff ff       	jmp    80105f8f <alltraps>

801066f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $65
801066f2:	6a 41                	push   $0x41
  jmp alltraps
801066f4:	e9 96 f8 ff ff       	jmp    80105f8f <alltraps>

801066f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $66
801066fb:	6a 42                	push   $0x42
  jmp alltraps
801066fd:	e9 8d f8 ff ff       	jmp    80105f8f <alltraps>

80106702 <vector67>:
.globl vector67
vector67:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $67
80106704:	6a 43                	push   $0x43
  jmp alltraps
80106706:	e9 84 f8 ff ff       	jmp    80105f8f <alltraps>

8010670b <vector68>:
.globl vector68
vector68:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $68
8010670d:	6a 44                	push   $0x44
  jmp alltraps
8010670f:	e9 7b f8 ff ff       	jmp    80105f8f <alltraps>

80106714 <vector69>:
.globl vector69
vector69:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $69
80106716:	6a 45                	push   $0x45
  jmp alltraps
80106718:	e9 72 f8 ff ff       	jmp    80105f8f <alltraps>

8010671d <vector70>:
.globl vector70
vector70:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $70
8010671f:	6a 46                	push   $0x46
  jmp alltraps
80106721:	e9 69 f8 ff ff       	jmp    80105f8f <alltraps>

80106726 <vector71>:
.globl vector71
vector71:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $71
80106728:	6a 47                	push   $0x47
  jmp alltraps
8010672a:	e9 60 f8 ff ff       	jmp    80105f8f <alltraps>

8010672f <vector72>:
.globl vector72
vector72:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $72
80106731:	6a 48                	push   $0x48
  jmp alltraps
80106733:	e9 57 f8 ff ff       	jmp    80105f8f <alltraps>

80106738 <vector73>:
.globl vector73
vector73:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $73
8010673a:	6a 49                	push   $0x49
  jmp alltraps
8010673c:	e9 4e f8 ff ff       	jmp    80105f8f <alltraps>

80106741 <vector74>:
.globl vector74
vector74:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $74
80106743:	6a 4a                	push   $0x4a
  jmp alltraps
80106745:	e9 45 f8 ff ff       	jmp    80105f8f <alltraps>

8010674a <vector75>:
.globl vector75
vector75:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $75
8010674c:	6a 4b                	push   $0x4b
  jmp alltraps
8010674e:	e9 3c f8 ff ff       	jmp    80105f8f <alltraps>

80106753 <vector76>:
.globl vector76
vector76:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $76
80106755:	6a 4c                	push   $0x4c
  jmp alltraps
80106757:	e9 33 f8 ff ff       	jmp    80105f8f <alltraps>

8010675c <vector77>:
.globl vector77
vector77:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $77
8010675e:	6a 4d                	push   $0x4d
  jmp alltraps
80106760:	e9 2a f8 ff ff       	jmp    80105f8f <alltraps>

80106765 <vector78>:
.globl vector78
vector78:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $78
80106767:	6a 4e                	push   $0x4e
  jmp alltraps
80106769:	e9 21 f8 ff ff       	jmp    80105f8f <alltraps>

8010676e <vector79>:
.globl vector79
vector79:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $79
80106770:	6a 4f                	push   $0x4f
  jmp alltraps
80106772:	e9 18 f8 ff ff       	jmp    80105f8f <alltraps>

80106777 <vector80>:
.globl vector80
vector80:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $80
80106779:	6a 50                	push   $0x50
  jmp alltraps
8010677b:	e9 0f f8 ff ff       	jmp    80105f8f <alltraps>

80106780 <vector81>:
.globl vector81
vector81:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $81
80106782:	6a 51                	push   $0x51
  jmp alltraps
80106784:	e9 06 f8 ff ff       	jmp    80105f8f <alltraps>

80106789 <vector82>:
.globl vector82
vector82:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $82
8010678b:	6a 52                	push   $0x52
  jmp alltraps
8010678d:	e9 fd f7 ff ff       	jmp    80105f8f <alltraps>

80106792 <vector83>:
.globl vector83
vector83:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $83
80106794:	6a 53                	push   $0x53
  jmp alltraps
80106796:	e9 f4 f7 ff ff       	jmp    80105f8f <alltraps>

8010679b <vector84>:
.globl vector84
vector84:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $84
8010679d:	6a 54                	push   $0x54
  jmp alltraps
8010679f:	e9 eb f7 ff ff       	jmp    80105f8f <alltraps>

801067a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $85
801067a6:	6a 55                	push   $0x55
  jmp alltraps
801067a8:	e9 e2 f7 ff ff       	jmp    80105f8f <alltraps>

801067ad <vector86>:
.globl vector86
vector86:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $86
801067af:	6a 56                	push   $0x56
  jmp alltraps
801067b1:	e9 d9 f7 ff ff       	jmp    80105f8f <alltraps>

801067b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $87
801067b8:	6a 57                	push   $0x57
  jmp alltraps
801067ba:	e9 d0 f7 ff ff       	jmp    80105f8f <alltraps>

801067bf <vector88>:
.globl vector88
vector88:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $88
801067c1:	6a 58                	push   $0x58
  jmp alltraps
801067c3:	e9 c7 f7 ff ff       	jmp    80105f8f <alltraps>

801067c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $89
801067ca:	6a 59                	push   $0x59
  jmp alltraps
801067cc:	e9 be f7 ff ff       	jmp    80105f8f <alltraps>

801067d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $90
801067d3:	6a 5a                	push   $0x5a
  jmp alltraps
801067d5:	e9 b5 f7 ff ff       	jmp    80105f8f <alltraps>

801067da <vector91>:
.globl vector91
vector91:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $91
801067dc:	6a 5b                	push   $0x5b
  jmp alltraps
801067de:	e9 ac f7 ff ff       	jmp    80105f8f <alltraps>

801067e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $92
801067e5:	6a 5c                	push   $0x5c
  jmp alltraps
801067e7:	e9 a3 f7 ff ff       	jmp    80105f8f <alltraps>

801067ec <vector93>:
.globl vector93
vector93:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $93
801067ee:	6a 5d                	push   $0x5d
  jmp alltraps
801067f0:	e9 9a f7 ff ff       	jmp    80105f8f <alltraps>

801067f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $94
801067f7:	6a 5e                	push   $0x5e
  jmp alltraps
801067f9:	e9 91 f7 ff ff       	jmp    80105f8f <alltraps>

801067fe <vector95>:
.globl vector95
vector95:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $95
80106800:	6a 5f                	push   $0x5f
  jmp alltraps
80106802:	e9 88 f7 ff ff       	jmp    80105f8f <alltraps>

80106807 <vector96>:
.globl vector96
vector96:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $96
80106809:	6a 60                	push   $0x60
  jmp alltraps
8010680b:	e9 7f f7 ff ff       	jmp    80105f8f <alltraps>

80106810 <vector97>:
.globl vector97
vector97:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $97
80106812:	6a 61                	push   $0x61
  jmp alltraps
80106814:	e9 76 f7 ff ff       	jmp    80105f8f <alltraps>

80106819 <vector98>:
.globl vector98
vector98:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $98
8010681b:	6a 62                	push   $0x62
  jmp alltraps
8010681d:	e9 6d f7 ff ff       	jmp    80105f8f <alltraps>

80106822 <vector99>:
.globl vector99
vector99:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $99
80106824:	6a 63                	push   $0x63
  jmp alltraps
80106826:	e9 64 f7 ff ff       	jmp    80105f8f <alltraps>

8010682b <vector100>:
.globl vector100
vector100:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $100
8010682d:	6a 64                	push   $0x64
  jmp alltraps
8010682f:	e9 5b f7 ff ff       	jmp    80105f8f <alltraps>

80106834 <vector101>:
.globl vector101
vector101:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $101
80106836:	6a 65                	push   $0x65
  jmp alltraps
80106838:	e9 52 f7 ff ff       	jmp    80105f8f <alltraps>

8010683d <vector102>:
.globl vector102
vector102:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $102
8010683f:	6a 66                	push   $0x66
  jmp alltraps
80106841:	e9 49 f7 ff ff       	jmp    80105f8f <alltraps>

80106846 <vector103>:
.globl vector103
vector103:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $103
80106848:	6a 67                	push   $0x67
  jmp alltraps
8010684a:	e9 40 f7 ff ff       	jmp    80105f8f <alltraps>

8010684f <vector104>:
.globl vector104
vector104:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $104
80106851:	6a 68                	push   $0x68
  jmp alltraps
80106853:	e9 37 f7 ff ff       	jmp    80105f8f <alltraps>

80106858 <vector105>:
.globl vector105
vector105:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $105
8010685a:	6a 69                	push   $0x69
  jmp alltraps
8010685c:	e9 2e f7 ff ff       	jmp    80105f8f <alltraps>

80106861 <vector106>:
.globl vector106
vector106:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $106
80106863:	6a 6a                	push   $0x6a
  jmp alltraps
80106865:	e9 25 f7 ff ff       	jmp    80105f8f <alltraps>

8010686a <vector107>:
.globl vector107
vector107:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $107
8010686c:	6a 6b                	push   $0x6b
  jmp alltraps
8010686e:	e9 1c f7 ff ff       	jmp    80105f8f <alltraps>

80106873 <vector108>:
.globl vector108
vector108:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $108
80106875:	6a 6c                	push   $0x6c
  jmp alltraps
80106877:	e9 13 f7 ff ff       	jmp    80105f8f <alltraps>

8010687c <vector109>:
.globl vector109
vector109:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $109
8010687e:	6a 6d                	push   $0x6d
  jmp alltraps
80106880:	e9 0a f7 ff ff       	jmp    80105f8f <alltraps>

80106885 <vector110>:
.globl vector110
vector110:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $110
80106887:	6a 6e                	push   $0x6e
  jmp alltraps
80106889:	e9 01 f7 ff ff       	jmp    80105f8f <alltraps>

8010688e <vector111>:
.globl vector111
vector111:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $111
80106890:	6a 6f                	push   $0x6f
  jmp alltraps
80106892:	e9 f8 f6 ff ff       	jmp    80105f8f <alltraps>

80106897 <vector112>:
.globl vector112
vector112:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $112
80106899:	6a 70                	push   $0x70
  jmp alltraps
8010689b:	e9 ef f6 ff ff       	jmp    80105f8f <alltraps>

801068a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $113
801068a2:	6a 71                	push   $0x71
  jmp alltraps
801068a4:	e9 e6 f6 ff ff       	jmp    80105f8f <alltraps>

801068a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $114
801068ab:	6a 72                	push   $0x72
  jmp alltraps
801068ad:	e9 dd f6 ff ff       	jmp    80105f8f <alltraps>

801068b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $115
801068b4:	6a 73                	push   $0x73
  jmp alltraps
801068b6:	e9 d4 f6 ff ff       	jmp    80105f8f <alltraps>

801068bb <vector116>:
.globl vector116
vector116:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $116
801068bd:	6a 74                	push   $0x74
  jmp alltraps
801068bf:	e9 cb f6 ff ff       	jmp    80105f8f <alltraps>

801068c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $117
801068c6:	6a 75                	push   $0x75
  jmp alltraps
801068c8:	e9 c2 f6 ff ff       	jmp    80105f8f <alltraps>

801068cd <vector118>:
.globl vector118
vector118:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $118
801068cf:	6a 76                	push   $0x76
  jmp alltraps
801068d1:	e9 b9 f6 ff ff       	jmp    80105f8f <alltraps>

801068d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $119
801068d8:	6a 77                	push   $0x77
  jmp alltraps
801068da:	e9 b0 f6 ff ff       	jmp    80105f8f <alltraps>

801068df <vector120>:
.globl vector120
vector120:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $120
801068e1:	6a 78                	push   $0x78
  jmp alltraps
801068e3:	e9 a7 f6 ff ff       	jmp    80105f8f <alltraps>

801068e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $121
801068ea:	6a 79                	push   $0x79
  jmp alltraps
801068ec:	e9 9e f6 ff ff       	jmp    80105f8f <alltraps>

801068f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $122
801068f3:	6a 7a                	push   $0x7a
  jmp alltraps
801068f5:	e9 95 f6 ff ff       	jmp    80105f8f <alltraps>

801068fa <vector123>:
.globl vector123
vector123:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $123
801068fc:	6a 7b                	push   $0x7b
  jmp alltraps
801068fe:	e9 8c f6 ff ff       	jmp    80105f8f <alltraps>

80106903 <vector124>:
.globl vector124
vector124:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $124
80106905:	6a 7c                	push   $0x7c
  jmp alltraps
80106907:	e9 83 f6 ff ff       	jmp    80105f8f <alltraps>

8010690c <vector125>:
.globl vector125
vector125:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $125
8010690e:	6a 7d                	push   $0x7d
  jmp alltraps
80106910:	e9 7a f6 ff ff       	jmp    80105f8f <alltraps>

80106915 <vector126>:
.globl vector126
vector126:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $126
80106917:	6a 7e                	push   $0x7e
  jmp alltraps
80106919:	e9 71 f6 ff ff       	jmp    80105f8f <alltraps>

8010691e <vector127>:
.globl vector127
vector127:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $127
80106920:	6a 7f                	push   $0x7f
  jmp alltraps
80106922:	e9 68 f6 ff ff       	jmp    80105f8f <alltraps>

80106927 <vector128>:
.globl vector128
vector128:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $128
80106929:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010692e:	e9 5c f6 ff ff       	jmp    80105f8f <alltraps>

80106933 <vector129>:
.globl vector129
vector129:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $129
80106935:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010693a:	e9 50 f6 ff ff       	jmp    80105f8f <alltraps>

8010693f <vector130>:
.globl vector130
vector130:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $130
80106941:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106946:	e9 44 f6 ff ff       	jmp    80105f8f <alltraps>

8010694b <vector131>:
.globl vector131
vector131:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $131
8010694d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106952:	e9 38 f6 ff ff       	jmp    80105f8f <alltraps>

80106957 <vector132>:
.globl vector132
vector132:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $132
80106959:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010695e:	e9 2c f6 ff ff       	jmp    80105f8f <alltraps>

80106963 <vector133>:
.globl vector133
vector133:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $133
80106965:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010696a:	e9 20 f6 ff ff       	jmp    80105f8f <alltraps>

8010696f <vector134>:
.globl vector134
vector134:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $134
80106971:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106976:	e9 14 f6 ff ff       	jmp    80105f8f <alltraps>

8010697b <vector135>:
.globl vector135
vector135:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $135
8010697d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106982:	e9 08 f6 ff ff       	jmp    80105f8f <alltraps>

80106987 <vector136>:
.globl vector136
vector136:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $136
80106989:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010698e:	e9 fc f5 ff ff       	jmp    80105f8f <alltraps>

80106993 <vector137>:
.globl vector137
vector137:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $137
80106995:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010699a:	e9 f0 f5 ff ff       	jmp    80105f8f <alltraps>

8010699f <vector138>:
.globl vector138
vector138:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $138
801069a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801069a6:	e9 e4 f5 ff ff       	jmp    80105f8f <alltraps>

801069ab <vector139>:
.globl vector139
vector139:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $139
801069ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801069b2:	e9 d8 f5 ff ff       	jmp    80105f8f <alltraps>

801069b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $140
801069b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801069be:	e9 cc f5 ff ff       	jmp    80105f8f <alltraps>

801069c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $141
801069c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801069ca:	e9 c0 f5 ff ff       	jmp    80105f8f <alltraps>

801069cf <vector142>:
.globl vector142
vector142:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $142
801069d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801069d6:	e9 b4 f5 ff ff       	jmp    80105f8f <alltraps>

801069db <vector143>:
.globl vector143
vector143:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $143
801069dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801069e2:	e9 a8 f5 ff ff       	jmp    80105f8f <alltraps>

801069e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $144
801069e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801069ee:	e9 9c f5 ff ff       	jmp    80105f8f <alltraps>

801069f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $145
801069f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801069fa:	e9 90 f5 ff ff       	jmp    80105f8f <alltraps>

801069ff <vector146>:
.globl vector146
vector146:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $146
80106a01:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a06:	e9 84 f5 ff ff       	jmp    80105f8f <alltraps>

80106a0b <vector147>:
.globl vector147
vector147:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $147
80106a0d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a12:	e9 78 f5 ff ff       	jmp    80105f8f <alltraps>

80106a17 <vector148>:
.globl vector148
vector148:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $148
80106a19:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a1e:	e9 6c f5 ff ff       	jmp    80105f8f <alltraps>

80106a23 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $149
80106a25:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a2a:	e9 60 f5 ff ff       	jmp    80105f8f <alltraps>

80106a2f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $150
80106a31:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a36:	e9 54 f5 ff ff       	jmp    80105f8f <alltraps>

80106a3b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $151
80106a3d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a42:	e9 48 f5 ff ff       	jmp    80105f8f <alltraps>

80106a47 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $152
80106a49:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a4e:	e9 3c f5 ff ff       	jmp    80105f8f <alltraps>

80106a53 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $153
80106a55:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a5a:	e9 30 f5 ff ff       	jmp    80105f8f <alltraps>

80106a5f <vector154>:
.globl vector154
vector154:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $154
80106a61:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a66:	e9 24 f5 ff ff       	jmp    80105f8f <alltraps>

80106a6b <vector155>:
.globl vector155
vector155:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $155
80106a6d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a72:	e9 18 f5 ff ff       	jmp    80105f8f <alltraps>

80106a77 <vector156>:
.globl vector156
vector156:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $156
80106a79:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a7e:	e9 0c f5 ff ff       	jmp    80105f8f <alltraps>

80106a83 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $157
80106a85:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a8a:	e9 00 f5 ff ff       	jmp    80105f8f <alltraps>

80106a8f <vector158>:
.globl vector158
vector158:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $158
80106a91:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a96:	e9 f4 f4 ff ff       	jmp    80105f8f <alltraps>

80106a9b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $159
80106a9d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106aa2:	e9 e8 f4 ff ff       	jmp    80105f8f <alltraps>

80106aa7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $160
80106aa9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106aae:	e9 dc f4 ff ff       	jmp    80105f8f <alltraps>

80106ab3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $161
80106ab5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106aba:	e9 d0 f4 ff ff       	jmp    80105f8f <alltraps>

80106abf <vector162>:
.globl vector162
vector162:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $162
80106ac1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ac6:	e9 c4 f4 ff ff       	jmp    80105f8f <alltraps>

80106acb <vector163>:
.globl vector163
vector163:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $163
80106acd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ad2:	e9 b8 f4 ff ff       	jmp    80105f8f <alltraps>

80106ad7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $164
80106ad9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106ade:	e9 ac f4 ff ff       	jmp    80105f8f <alltraps>

80106ae3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $165
80106ae5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106aea:	e9 a0 f4 ff ff       	jmp    80105f8f <alltraps>

80106aef <vector166>:
.globl vector166
vector166:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $166
80106af1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106af6:	e9 94 f4 ff ff       	jmp    80105f8f <alltraps>

80106afb <vector167>:
.globl vector167
vector167:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $167
80106afd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b02:	e9 88 f4 ff ff       	jmp    80105f8f <alltraps>

80106b07 <vector168>:
.globl vector168
vector168:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $168
80106b09:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b0e:	e9 7c f4 ff ff       	jmp    80105f8f <alltraps>

80106b13 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $169
80106b15:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b1a:	e9 70 f4 ff ff       	jmp    80105f8f <alltraps>

80106b1f <vector170>:
.globl vector170
vector170:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $170
80106b21:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b26:	e9 64 f4 ff ff       	jmp    80105f8f <alltraps>

80106b2b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $171
80106b2d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b32:	e9 58 f4 ff ff       	jmp    80105f8f <alltraps>

80106b37 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $172
80106b39:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b3e:	e9 4c f4 ff ff       	jmp    80105f8f <alltraps>

80106b43 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $173
80106b45:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b4a:	e9 40 f4 ff ff       	jmp    80105f8f <alltraps>

80106b4f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $174
80106b51:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b56:	e9 34 f4 ff ff       	jmp    80105f8f <alltraps>

80106b5b <vector175>:
.globl vector175
vector175:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $175
80106b5d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b62:	e9 28 f4 ff ff       	jmp    80105f8f <alltraps>

80106b67 <vector176>:
.globl vector176
vector176:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $176
80106b69:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b6e:	e9 1c f4 ff ff       	jmp    80105f8f <alltraps>

80106b73 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $177
80106b75:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b7a:	e9 10 f4 ff ff       	jmp    80105f8f <alltraps>

80106b7f <vector178>:
.globl vector178
vector178:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $178
80106b81:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b86:	e9 04 f4 ff ff       	jmp    80105f8f <alltraps>

80106b8b <vector179>:
.globl vector179
vector179:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $179
80106b8d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b92:	e9 f8 f3 ff ff       	jmp    80105f8f <alltraps>

80106b97 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $180
80106b99:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b9e:	e9 ec f3 ff ff       	jmp    80105f8f <alltraps>

80106ba3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $181
80106ba5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106baa:	e9 e0 f3 ff ff       	jmp    80105f8f <alltraps>

80106baf <vector182>:
.globl vector182
vector182:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $182
80106bb1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106bb6:	e9 d4 f3 ff ff       	jmp    80105f8f <alltraps>

80106bbb <vector183>:
.globl vector183
vector183:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $183
80106bbd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106bc2:	e9 c8 f3 ff ff       	jmp    80105f8f <alltraps>

80106bc7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $184
80106bc9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106bce:	e9 bc f3 ff ff       	jmp    80105f8f <alltraps>

80106bd3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $185
80106bd5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106bda:	e9 b0 f3 ff ff       	jmp    80105f8f <alltraps>

80106bdf <vector186>:
.globl vector186
vector186:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $186
80106be1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106be6:	e9 a4 f3 ff ff       	jmp    80105f8f <alltraps>

80106beb <vector187>:
.globl vector187
vector187:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $187
80106bed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106bf2:	e9 98 f3 ff ff       	jmp    80105f8f <alltraps>

80106bf7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $188
80106bf9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106bfe:	e9 8c f3 ff ff       	jmp    80105f8f <alltraps>

80106c03 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $189
80106c05:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c0a:	e9 80 f3 ff ff       	jmp    80105f8f <alltraps>

80106c0f <vector190>:
.globl vector190
vector190:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $190
80106c11:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c16:	e9 74 f3 ff ff       	jmp    80105f8f <alltraps>

80106c1b <vector191>:
.globl vector191
vector191:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $191
80106c1d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c22:	e9 68 f3 ff ff       	jmp    80105f8f <alltraps>

80106c27 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $192
80106c29:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c2e:	e9 5c f3 ff ff       	jmp    80105f8f <alltraps>

80106c33 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $193
80106c35:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c3a:	e9 50 f3 ff ff       	jmp    80105f8f <alltraps>

80106c3f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $194
80106c41:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c46:	e9 44 f3 ff ff       	jmp    80105f8f <alltraps>

80106c4b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $195
80106c4d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c52:	e9 38 f3 ff ff       	jmp    80105f8f <alltraps>

80106c57 <vector196>:
.globl vector196
vector196:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $196
80106c59:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c5e:	e9 2c f3 ff ff       	jmp    80105f8f <alltraps>

80106c63 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $197
80106c65:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c6a:	e9 20 f3 ff ff       	jmp    80105f8f <alltraps>

80106c6f <vector198>:
.globl vector198
vector198:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $198
80106c71:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c76:	e9 14 f3 ff ff       	jmp    80105f8f <alltraps>

80106c7b <vector199>:
.globl vector199
vector199:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $199
80106c7d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c82:	e9 08 f3 ff ff       	jmp    80105f8f <alltraps>

80106c87 <vector200>:
.globl vector200
vector200:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $200
80106c89:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c8e:	e9 fc f2 ff ff       	jmp    80105f8f <alltraps>

80106c93 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $201
80106c95:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c9a:	e9 f0 f2 ff ff       	jmp    80105f8f <alltraps>

80106c9f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $202
80106ca1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106ca6:	e9 e4 f2 ff ff       	jmp    80105f8f <alltraps>

80106cab <vector203>:
.globl vector203
vector203:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $203
80106cad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106cb2:	e9 d8 f2 ff ff       	jmp    80105f8f <alltraps>

80106cb7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $204
80106cb9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106cbe:	e9 cc f2 ff ff       	jmp    80105f8f <alltraps>

80106cc3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $205
80106cc5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106cca:	e9 c0 f2 ff ff       	jmp    80105f8f <alltraps>

80106ccf <vector206>:
.globl vector206
vector206:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $206
80106cd1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106cd6:	e9 b4 f2 ff ff       	jmp    80105f8f <alltraps>

80106cdb <vector207>:
.globl vector207
vector207:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $207
80106cdd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ce2:	e9 a8 f2 ff ff       	jmp    80105f8f <alltraps>

80106ce7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $208
80106ce9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106cee:	e9 9c f2 ff ff       	jmp    80105f8f <alltraps>

80106cf3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $209
80106cf5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106cfa:	e9 90 f2 ff ff       	jmp    80105f8f <alltraps>

80106cff <vector210>:
.globl vector210
vector210:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $210
80106d01:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d06:	e9 84 f2 ff ff       	jmp    80105f8f <alltraps>

80106d0b <vector211>:
.globl vector211
vector211:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $211
80106d0d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d12:	e9 78 f2 ff ff       	jmp    80105f8f <alltraps>

80106d17 <vector212>:
.globl vector212
vector212:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $212
80106d19:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d1e:	e9 6c f2 ff ff       	jmp    80105f8f <alltraps>

80106d23 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $213
80106d25:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d2a:	e9 60 f2 ff ff       	jmp    80105f8f <alltraps>

80106d2f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $214
80106d31:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d36:	e9 54 f2 ff ff       	jmp    80105f8f <alltraps>

80106d3b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $215
80106d3d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d42:	e9 48 f2 ff ff       	jmp    80105f8f <alltraps>

80106d47 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $216
80106d49:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d4e:	e9 3c f2 ff ff       	jmp    80105f8f <alltraps>

80106d53 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $217
80106d55:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d5a:	e9 30 f2 ff ff       	jmp    80105f8f <alltraps>

80106d5f <vector218>:
.globl vector218
vector218:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $218
80106d61:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d66:	e9 24 f2 ff ff       	jmp    80105f8f <alltraps>

80106d6b <vector219>:
.globl vector219
vector219:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $219
80106d6d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d72:	e9 18 f2 ff ff       	jmp    80105f8f <alltraps>

80106d77 <vector220>:
.globl vector220
vector220:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $220
80106d79:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d7e:	e9 0c f2 ff ff       	jmp    80105f8f <alltraps>

80106d83 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $221
80106d85:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d8a:	e9 00 f2 ff ff       	jmp    80105f8f <alltraps>

80106d8f <vector222>:
.globl vector222
vector222:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $222
80106d91:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d96:	e9 f4 f1 ff ff       	jmp    80105f8f <alltraps>

80106d9b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $223
80106d9d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106da2:	e9 e8 f1 ff ff       	jmp    80105f8f <alltraps>

80106da7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $224
80106da9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106dae:	e9 dc f1 ff ff       	jmp    80105f8f <alltraps>

80106db3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $225
80106db5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106dba:	e9 d0 f1 ff ff       	jmp    80105f8f <alltraps>

80106dbf <vector226>:
.globl vector226
vector226:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $226
80106dc1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106dc6:	e9 c4 f1 ff ff       	jmp    80105f8f <alltraps>

80106dcb <vector227>:
.globl vector227
vector227:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $227
80106dcd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106dd2:	e9 b8 f1 ff ff       	jmp    80105f8f <alltraps>

80106dd7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $228
80106dd9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106dde:	e9 ac f1 ff ff       	jmp    80105f8f <alltraps>

80106de3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $229
80106de5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106dea:	e9 a0 f1 ff ff       	jmp    80105f8f <alltraps>

80106def <vector230>:
.globl vector230
vector230:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $230
80106df1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106df6:	e9 94 f1 ff ff       	jmp    80105f8f <alltraps>

80106dfb <vector231>:
.globl vector231
vector231:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $231
80106dfd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e02:	e9 88 f1 ff ff       	jmp    80105f8f <alltraps>

80106e07 <vector232>:
.globl vector232
vector232:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $232
80106e09:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e0e:	e9 7c f1 ff ff       	jmp    80105f8f <alltraps>

80106e13 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $233
80106e15:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e1a:	e9 70 f1 ff ff       	jmp    80105f8f <alltraps>

80106e1f <vector234>:
.globl vector234
vector234:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $234
80106e21:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e26:	e9 64 f1 ff ff       	jmp    80105f8f <alltraps>

80106e2b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $235
80106e2d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e32:	e9 58 f1 ff ff       	jmp    80105f8f <alltraps>

80106e37 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $236
80106e39:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e3e:	e9 4c f1 ff ff       	jmp    80105f8f <alltraps>

80106e43 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $237
80106e45:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e4a:	e9 40 f1 ff ff       	jmp    80105f8f <alltraps>

80106e4f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $238
80106e51:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e56:	e9 34 f1 ff ff       	jmp    80105f8f <alltraps>

80106e5b <vector239>:
.globl vector239
vector239:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $239
80106e5d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e62:	e9 28 f1 ff ff       	jmp    80105f8f <alltraps>

80106e67 <vector240>:
.globl vector240
vector240:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $240
80106e69:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e6e:	e9 1c f1 ff ff       	jmp    80105f8f <alltraps>

80106e73 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $241
80106e75:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e7a:	e9 10 f1 ff ff       	jmp    80105f8f <alltraps>

80106e7f <vector242>:
.globl vector242
vector242:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $242
80106e81:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e86:	e9 04 f1 ff ff       	jmp    80105f8f <alltraps>

80106e8b <vector243>:
.globl vector243
vector243:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $243
80106e8d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e92:	e9 f8 f0 ff ff       	jmp    80105f8f <alltraps>

80106e97 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $244
80106e99:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e9e:	e9 ec f0 ff ff       	jmp    80105f8f <alltraps>

80106ea3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $245
80106ea5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106eaa:	e9 e0 f0 ff ff       	jmp    80105f8f <alltraps>

80106eaf <vector246>:
.globl vector246
vector246:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $246
80106eb1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106eb6:	e9 d4 f0 ff ff       	jmp    80105f8f <alltraps>

80106ebb <vector247>:
.globl vector247
vector247:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $247
80106ebd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ec2:	e9 c8 f0 ff ff       	jmp    80105f8f <alltraps>

80106ec7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $248
80106ec9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ece:	e9 bc f0 ff ff       	jmp    80105f8f <alltraps>

80106ed3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $249
80106ed5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106eda:	e9 b0 f0 ff ff       	jmp    80105f8f <alltraps>

80106edf <vector250>:
.globl vector250
vector250:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $250
80106ee1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ee6:	e9 a4 f0 ff ff       	jmp    80105f8f <alltraps>

80106eeb <vector251>:
.globl vector251
vector251:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $251
80106eed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ef2:	e9 98 f0 ff ff       	jmp    80105f8f <alltraps>

80106ef7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $252
80106ef9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106efe:	e9 8c f0 ff ff       	jmp    80105f8f <alltraps>

80106f03 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $253
80106f05:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f0a:	e9 80 f0 ff ff       	jmp    80105f8f <alltraps>

80106f0f <vector254>:
.globl vector254
vector254:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $254
80106f11:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f16:	e9 74 f0 ff ff       	jmp    80105f8f <alltraps>

80106f1b <vector255>:
.globl vector255
vector255:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $255
80106f1d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f22:	e9 68 f0 ff ff       	jmp    80105f8f <alltraps>
80106f27:	66 90                	xchg   %ax,%ax
80106f29:	66 90                	xchg   %ax,%ax
80106f2b:	66 90                	xchg   %ax,%ax
80106f2d:	66 90                	xchg   %ax,%ax
80106f2f:	90                   	nop

80106f30 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106f36:	89 d3                	mov    %edx,%ebx
{
80106f38:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106f3a:	c1 eb 16             	shr    $0x16,%ebx
80106f3d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106f40:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106f43:	8b 06                	mov    (%esi),%eax
80106f45:	a8 01                	test   $0x1,%al
80106f47:	74 27                	je     80106f70 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f4e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106f54:	c1 ef 0a             	shr    $0xa,%edi
}
80106f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106f5a:	89 fa                	mov    %edi,%edx
80106f5c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106f62:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106f65:	5b                   	pop    %ebx
80106f66:	5e                   	pop    %esi
80106f67:	5f                   	pop    %edi
80106f68:	5d                   	pop    %ebp
80106f69:	c3                   	ret    
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f70:	85 c9                	test   %ecx,%ecx
80106f72:	74 2c                	je     80106fa0 <walkpgdir+0x70>
80106f74:	e8 47 b5 ff ff       	call   801024c0 <kalloc>
80106f79:	85 c0                	test   %eax,%eax
80106f7b:	89 c3                	mov    %eax,%ebx
80106f7d:	74 21                	je     80106fa0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106f7f:	83 ec 04             	sub    $0x4,%esp
80106f82:	68 00 10 00 00       	push   $0x1000
80106f87:	6a 00                	push   $0x0
80106f89:	50                   	push   %eax
80106f8a:	e8 31 dd ff ff       	call   80104cc0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f8f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f95:	83 c4 10             	add    $0x10,%esp
80106f98:	83 c8 07             	or     $0x7,%eax
80106f9b:	89 06                	mov    %eax,(%esi)
80106f9d:	eb b5                	jmp    80106f54 <walkpgdir+0x24>
80106f9f:	90                   	nop
}
80106fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106fa3:	31 c0                	xor    %eax,%eax
}
80106fa5:	5b                   	pop    %ebx
80106fa6:	5e                   	pop    %esi
80106fa7:	5f                   	pop    %edi
80106fa8:	5d                   	pop    %ebp
80106fa9:	c3                   	ret    
80106faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fb0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106fb6:	89 d3                	mov    %edx,%ebx
80106fb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106fbe:	83 ec 1c             	sub    $0x1c,%esp
80106fc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106fc4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106fc8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fd6:	29 df                	sub    %ebx,%edi
80106fd8:	83 c8 01             	or     $0x1,%eax
80106fdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106fde:	eb 15                	jmp    80106ff5 <mappages+0x45>
    if(*pte & PTE_P)
80106fe0:	f6 00 01             	testb  $0x1,(%eax)
80106fe3:	75 45                	jne    8010702a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106fe5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106fe8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106feb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106fed:	74 31                	je     80107020 <mappages+0x70>
      break;
    a += PGSIZE;
80106fef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ff5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ff8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106ffd:	89 da                	mov    %ebx,%edx
80106fff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107002:	e8 29 ff ff ff       	call   80106f30 <walkpgdir>
80107007:	85 c0                	test   %eax,%eax
80107009:	75 d5                	jne    80106fe0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010700b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010700e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107013:	5b                   	pop    %ebx
80107014:	5e                   	pop    %esi
80107015:	5f                   	pop    %edi
80107016:	5d                   	pop    %ebp
80107017:	c3                   	ret    
80107018:	90                   	nop
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107020:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107023:	31 c0                	xor    %eax,%eax
}
80107025:	5b                   	pop    %ebx
80107026:	5e                   	pop    %esi
80107027:	5f                   	pop    %edi
80107028:	5d                   	pop    %ebp
80107029:	c3                   	ret    
      panic("remap");
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	68 54 81 10 80       	push   $0x80108154
80107032:	e8 59 93 ff ff       	call   80100390 <panic>
80107037:	89 f6                	mov    %esi,%esi
80107039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107040 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107046:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010704c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010704e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107054:	83 ec 1c             	sub    $0x1c,%esp
80107057:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010705a:	39 d3                	cmp    %edx,%ebx
8010705c:	73 66                	jae    801070c4 <deallocuvm.part.0+0x84>
8010705e:	89 d6                	mov    %edx,%esi
80107060:	eb 3d                	jmp    8010709f <deallocuvm.part.0+0x5f>
80107062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107068:	8b 10                	mov    (%eax),%edx
8010706a:	f6 c2 01             	test   $0x1,%dl
8010706d:	74 26                	je     80107095 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010706f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107075:	74 58                	je     801070cf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107077:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010707a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107083:	52                   	push   %edx
80107084:	e8 87 b2 ff ff       	call   80102310 <kfree>
      *pte = 0;
80107089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010708c:	83 c4 10             	add    $0x10,%esp
8010708f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107095:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010709b:	39 f3                	cmp    %esi,%ebx
8010709d:	73 25                	jae    801070c4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010709f:	31 c9                	xor    %ecx,%ecx
801070a1:	89 da                	mov    %ebx,%edx
801070a3:	89 f8                	mov    %edi,%eax
801070a5:	e8 86 fe ff ff       	call   80106f30 <walkpgdir>
    if(!pte)
801070aa:	85 c0                	test   %eax,%eax
801070ac:	75 ba                	jne    80107068 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070ae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801070b4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801070ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070c0:	39 f3                	cmp    %esi,%ebx
801070c2:	72 db                	jb     8010709f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801070c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ca:	5b                   	pop    %ebx
801070cb:	5e                   	pop    %esi
801070cc:	5f                   	pop    %edi
801070cd:	5d                   	pop    %ebp
801070ce:	c3                   	ret    
        panic("kfree");
801070cf:	83 ec 0c             	sub    $0xc,%esp
801070d2:	68 c6 7a 10 80       	push   $0x80107ac6
801070d7:	e8 b4 92 ff ff       	call   80100390 <panic>
801070dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070e0 <seginit>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801070e6:	e8 45 c6 ff ff       	call   80103730 <cpuid>
801070eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801070f1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070fa:	c7 80 78 3d 11 80 ff 	movl   $0xffff,-0x7feec288(%eax)
80107101:	ff 00 00 
80107104:	c7 80 7c 3d 11 80 00 	movl   $0xcf9a00,-0x7feec284(%eax)
8010710b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010710e:	c7 80 80 3d 11 80 ff 	movl   $0xffff,-0x7feec280(%eax)
80107115:	ff 00 00 
80107118:	c7 80 84 3d 11 80 00 	movl   $0xcf9200,-0x7feec27c(%eax)
8010711f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107122:	c7 80 88 3d 11 80 ff 	movl   $0xffff,-0x7feec278(%eax)
80107129:	ff 00 00 
8010712c:	c7 80 8c 3d 11 80 00 	movl   $0xcffa00,-0x7feec274(%eax)
80107133:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107136:	c7 80 90 3d 11 80 ff 	movl   $0xffff,-0x7feec270(%eax)
8010713d:	ff 00 00 
80107140:	c7 80 94 3d 11 80 00 	movl   $0xcff200,-0x7feec26c(%eax)
80107147:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010714a:	05 70 3d 11 80       	add    $0x80113d70,%eax
  pd[1] = (uint)p;
8010714f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107153:	c1 e8 10             	shr    $0x10,%eax
80107156:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010715a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010715d:	0f 01 10             	lgdtl  (%eax)
}
80107160:	c9                   	leave  
80107161:	c3                   	ret    
80107162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107170 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107170:	a1 24 77 11 80       	mov    0x80117724,%eax
{
80107175:	55                   	push   %ebp
80107176:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107178:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010717d:	0f 22 d8             	mov    %eax,%cr3
}
80107180:	5d                   	pop    %ebp
80107181:	c3                   	ret    
80107182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107190 <switchuvm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
80107196:	83 ec 1c             	sub    $0x1c,%esp
80107199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010719c:	85 db                	test   %ebx,%ebx
8010719e:	0f 84 cb 00 00 00    	je     8010726f <switchuvm+0xdf>
  if(p->kstack == 0)
801071a4:	8b 43 08             	mov    0x8(%ebx),%eax
801071a7:	85 c0                	test   %eax,%eax
801071a9:	0f 84 da 00 00 00    	je     80107289 <switchuvm+0xf9>
  if(p->pgdir == 0)
801071af:	8b 43 04             	mov    0x4(%ebx),%eax
801071b2:	85 c0                	test   %eax,%eax
801071b4:	0f 84 c2 00 00 00    	je     8010727c <switchuvm+0xec>
  pushcli();
801071ba:	e8 21 d9 ff ff       	call   80104ae0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071bf:	e8 ec c4 ff ff       	call   801036b0 <mycpu>
801071c4:	89 c6                	mov    %eax,%esi
801071c6:	e8 e5 c4 ff ff       	call   801036b0 <mycpu>
801071cb:	89 c7                	mov    %eax,%edi
801071cd:	e8 de c4 ff ff       	call   801036b0 <mycpu>
801071d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071d5:	83 c7 08             	add    $0x8,%edi
801071d8:	e8 d3 c4 ff ff       	call   801036b0 <mycpu>
801071dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071e0:	83 c0 08             	add    $0x8,%eax
801071e3:	ba 67 00 00 00       	mov    $0x67,%edx
801071e8:	c1 e8 18             	shr    $0x18,%eax
801071eb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801071f2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801071f9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107204:	83 c1 08             	add    $0x8,%ecx
80107207:	c1 e9 10             	shr    $0x10,%ecx
8010720a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107210:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107215:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010721c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107221:	e8 8a c4 ff ff       	call   801036b0 <mycpu>
80107226:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010722d:	e8 7e c4 ff ff       	call   801036b0 <mycpu>
80107232:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107236:	8b 73 08             	mov    0x8(%ebx),%esi
80107239:	e8 72 c4 ff ff       	call   801036b0 <mycpu>
8010723e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107244:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107247:	e8 64 c4 ff ff       	call   801036b0 <mycpu>
8010724c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107250:	b8 28 00 00 00       	mov    $0x28,%eax
80107255:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107258:	8b 43 04             	mov    0x4(%ebx),%eax
8010725b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107260:	0f 22 d8             	mov    %eax,%cr3
}
80107263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107266:	5b                   	pop    %ebx
80107267:	5e                   	pop    %esi
80107268:	5f                   	pop    %edi
80107269:	5d                   	pop    %ebp
  popcli();
8010726a:	e9 b1 d8 ff ff       	jmp    80104b20 <popcli>
    panic("switchuvm: no process");
8010726f:	83 ec 0c             	sub    $0xc,%esp
80107272:	68 5a 81 10 80       	push   $0x8010815a
80107277:	e8 14 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010727c:	83 ec 0c             	sub    $0xc,%esp
8010727f:	68 85 81 10 80       	push   $0x80108185
80107284:	e8 07 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107289:	83 ec 0c             	sub    $0xc,%esp
8010728c:	68 70 81 10 80       	push   $0x80108170
80107291:	e8 fa 90 ff ff       	call   80100390 <panic>
80107296:	8d 76 00             	lea    0x0(%esi),%esi
80107299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072a0 <inituvm>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 1c             	sub    $0x1c,%esp
801072a9:	8b 75 10             	mov    0x10(%ebp),%esi
801072ac:	8b 45 08             	mov    0x8(%ebp),%eax
801072af:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801072b2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801072b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801072bb:	77 49                	ja     80107306 <inituvm+0x66>
  mem = kalloc();
801072bd:	e8 fe b1 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
801072c2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801072c5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801072c7:	68 00 10 00 00       	push   $0x1000
801072cc:	6a 00                	push   $0x0
801072ce:	50                   	push   %eax
801072cf:	e8 ec d9 ff ff       	call   80104cc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801072d4:	58                   	pop    %eax
801072d5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072db:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072e0:	5a                   	pop    %edx
801072e1:	6a 06                	push   $0x6
801072e3:	50                   	push   %eax
801072e4:	31 d2                	xor    %edx,%edx
801072e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072e9:	e8 c2 fc ff ff       	call   80106fb0 <mappages>
  memmove(mem, init, sz);
801072ee:	89 75 10             	mov    %esi,0x10(%ebp)
801072f1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801072f4:	83 c4 10             	add    $0x10,%esp
801072f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801072fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072fd:	5b                   	pop    %ebx
801072fe:	5e                   	pop    %esi
801072ff:	5f                   	pop    %edi
80107300:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107301:	e9 6a da ff ff       	jmp    80104d70 <memmove>
    panic("inituvm: more than a page");
80107306:	83 ec 0c             	sub    $0xc,%esp
80107309:	68 99 81 10 80       	push   $0x80108199
8010730e:	e8 7d 90 ff ff       	call   80100390 <panic>
80107313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107320 <loaduvm>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107329:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107330:	0f 85 91 00 00 00    	jne    801073c7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107336:	8b 75 18             	mov    0x18(%ebp),%esi
80107339:	31 db                	xor    %ebx,%ebx
8010733b:	85 f6                	test   %esi,%esi
8010733d:	75 1a                	jne    80107359 <loaduvm+0x39>
8010733f:	eb 6f                	jmp    801073b0 <loaduvm+0x90>
80107341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107348:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010734e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107354:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107357:	76 57                	jbe    801073b0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107359:	8b 55 0c             	mov    0xc(%ebp),%edx
8010735c:	8b 45 08             	mov    0x8(%ebp),%eax
8010735f:	31 c9                	xor    %ecx,%ecx
80107361:	01 da                	add    %ebx,%edx
80107363:	e8 c8 fb ff ff       	call   80106f30 <walkpgdir>
80107368:	85 c0                	test   %eax,%eax
8010736a:	74 4e                	je     801073ba <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010736c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010736e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107371:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107376:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010737b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107381:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107384:	01 d9                	add    %ebx,%ecx
80107386:	05 00 00 00 80       	add    $0x80000000,%eax
8010738b:	57                   	push   %edi
8010738c:	51                   	push   %ecx
8010738d:	50                   	push   %eax
8010738e:	ff 75 10             	pushl  0x10(%ebp)
80107391:	e8 ca a5 ff ff       	call   80101960 <readi>
80107396:	83 c4 10             	add    $0x10,%esp
80107399:	39 f8                	cmp    %edi,%eax
8010739b:	74 ab                	je     80107348 <loaduvm+0x28>
}
8010739d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5f                   	pop    %edi
801073a8:	5d                   	pop    %ebp
801073a9:	c3                   	ret    
801073aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073b3:	31 c0                	xor    %eax,%eax
}
801073b5:	5b                   	pop    %ebx
801073b6:	5e                   	pop    %esi
801073b7:	5f                   	pop    %edi
801073b8:	5d                   	pop    %ebp
801073b9:	c3                   	ret    
      panic("loaduvm: address should exist");
801073ba:	83 ec 0c             	sub    $0xc,%esp
801073bd:	68 b3 81 10 80       	push   $0x801081b3
801073c2:	e8 c9 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801073c7:	83 ec 0c             	sub    $0xc,%esp
801073ca:	68 54 82 10 80       	push   $0x80108254
801073cf:	e8 bc 8f ff ff       	call   80100390 <panic>
801073d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801073e0 <allocuvm>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801073e9:	8b 7d 10             	mov    0x10(%ebp),%edi
801073ec:	85 ff                	test   %edi,%edi
801073ee:	0f 88 8e 00 00 00    	js     80107482 <allocuvm+0xa2>
  if(newsz < oldsz)
801073f4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801073f7:	0f 82 93 00 00 00    	jb     80107490 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801073fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107400:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107406:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010740c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010740f:	0f 86 7e 00 00 00    	jbe    80107493 <allocuvm+0xb3>
80107415:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107418:	8b 7d 08             	mov    0x8(%ebp),%edi
8010741b:	eb 42                	jmp    8010745f <allocuvm+0x7f>
8010741d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107420:	83 ec 04             	sub    $0x4,%esp
80107423:	68 00 10 00 00       	push   $0x1000
80107428:	6a 00                	push   $0x0
8010742a:	50                   	push   %eax
8010742b:	e8 90 d8 ff ff       	call   80104cc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107430:	58                   	pop    %eax
80107431:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107437:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010743c:	5a                   	pop    %edx
8010743d:	6a 06                	push   $0x6
8010743f:	50                   	push   %eax
80107440:	89 da                	mov    %ebx,%edx
80107442:	89 f8                	mov    %edi,%eax
80107444:	e8 67 fb ff ff       	call   80106fb0 <mappages>
80107449:	83 c4 10             	add    $0x10,%esp
8010744c:	85 c0                	test   %eax,%eax
8010744e:	78 50                	js     801074a0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107450:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107456:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107459:	0f 86 81 00 00 00    	jbe    801074e0 <allocuvm+0x100>
    mem = kalloc();
8010745f:	e8 5c b0 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107464:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107466:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107468:	75 b6                	jne    80107420 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010746a:	83 ec 0c             	sub    $0xc,%esp
8010746d:	68 d1 81 10 80       	push   $0x801081d1
80107472:	e8 e9 91 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107477:	83 c4 10             	add    $0x10,%esp
8010747a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010747d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107480:	77 6e                	ja     801074f0 <allocuvm+0x110>
}
80107482:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107485:	31 ff                	xor    %edi,%edi
}
80107487:	89 f8                	mov    %edi,%eax
80107489:	5b                   	pop    %ebx
8010748a:	5e                   	pop    %esi
8010748b:	5f                   	pop    %edi
8010748c:	5d                   	pop    %ebp
8010748d:	c3                   	ret    
8010748e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107490:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107493:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107496:	89 f8                	mov    %edi,%eax
80107498:	5b                   	pop    %ebx
80107499:	5e                   	pop    %esi
8010749a:	5f                   	pop    %edi
8010749b:	5d                   	pop    %ebp
8010749c:	c3                   	ret    
8010749d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801074a0:	83 ec 0c             	sub    $0xc,%esp
801074a3:	68 e9 81 10 80       	push   $0x801081e9
801074a8:	e8 b3 91 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801074ad:	83 c4 10             	add    $0x10,%esp
801074b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801074b3:	39 45 10             	cmp    %eax,0x10(%ebp)
801074b6:	76 0d                	jbe    801074c5 <allocuvm+0xe5>
801074b8:	89 c1                	mov    %eax,%ecx
801074ba:	8b 55 10             	mov    0x10(%ebp),%edx
801074bd:	8b 45 08             	mov    0x8(%ebp),%eax
801074c0:	e8 7b fb ff ff       	call   80107040 <deallocuvm.part.0>
      kfree(mem);
801074c5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801074c8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801074ca:	56                   	push   %esi
801074cb:	e8 40 ae ff ff       	call   80102310 <kfree>
      return 0;
801074d0:	83 c4 10             	add    $0x10,%esp
}
801074d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d6:	89 f8                	mov    %edi,%eax
801074d8:	5b                   	pop    %ebx
801074d9:	5e                   	pop    %esi
801074da:	5f                   	pop    %edi
801074db:	5d                   	pop    %ebp
801074dc:	c3                   	ret    
801074dd:	8d 76 00             	lea    0x0(%esi),%esi
801074e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801074e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074e6:	5b                   	pop    %ebx
801074e7:	89 f8                	mov    %edi,%eax
801074e9:	5e                   	pop    %esi
801074ea:	5f                   	pop    %edi
801074eb:	5d                   	pop    %ebp
801074ec:	c3                   	ret    
801074ed:	8d 76 00             	lea    0x0(%esi),%esi
801074f0:	89 c1                	mov    %eax,%ecx
801074f2:	8b 55 10             	mov    0x10(%ebp),%edx
801074f5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801074f8:	31 ff                	xor    %edi,%edi
801074fa:	e8 41 fb ff ff       	call   80107040 <deallocuvm.part.0>
801074ff:	eb 92                	jmp    80107493 <allocuvm+0xb3>
80107501:	eb 0d                	jmp    80107510 <deallocuvm>
80107503:	90                   	nop
80107504:	90                   	nop
80107505:	90                   	nop
80107506:	90                   	nop
80107507:	90                   	nop
80107508:	90                   	nop
80107509:	90                   	nop
8010750a:	90                   	nop
8010750b:	90                   	nop
8010750c:	90                   	nop
8010750d:	90                   	nop
8010750e:	90                   	nop
8010750f:	90                   	nop

80107510 <deallocuvm>:
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	8b 55 0c             	mov    0xc(%ebp),%edx
80107516:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107519:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010751c:	39 d1                	cmp    %edx,%ecx
8010751e:	73 10                	jae    80107530 <deallocuvm+0x20>
}
80107520:	5d                   	pop    %ebp
80107521:	e9 1a fb ff ff       	jmp    80107040 <deallocuvm.part.0>
80107526:	8d 76 00             	lea    0x0(%esi),%esi
80107529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107530:	89 d0                	mov    %edx,%eax
80107532:	5d                   	pop    %ebp
80107533:	c3                   	ret    
80107534:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010753a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107540 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	57                   	push   %edi
80107544:	56                   	push   %esi
80107545:	53                   	push   %ebx
80107546:	83 ec 0c             	sub    $0xc,%esp
80107549:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010754c:	85 f6                	test   %esi,%esi
8010754e:	74 59                	je     801075a9 <freevm+0x69>
80107550:	31 c9                	xor    %ecx,%ecx
80107552:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107557:	89 f0                	mov    %esi,%eax
80107559:	e8 e2 fa ff ff       	call   80107040 <deallocuvm.part.0>
8010755e:	89 f3                	mov    %esi,%ebx
80107560:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107566:	eb 0f                	jmp    80107577 <freevm+0x37>
80107568:	90                   	nop
80107569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107570:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107573:	39 fb                	cmp    %edi,%ebx
80107575:	74 23                	je     8010759a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107577:	8b 03                	mov    (%ebx),%eax
80107579:	a8 01                	test   $0x1,%al
8010757b:	74 f3                	je     80107570 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010757d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107582:	83 ec 0c             	sub    $0xc,%esp
80107585:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107588:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010758d:	50                   	push   %eax
8010758e:	e8 7d ad ff ff       	call   80102310 <kfree>
80107593:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107596:	39 fb                	cmp    %edi,%ebx
80107598:	75 dd                	jne    80107577 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010759a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010759d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075a0:	5b                   	pop    %ebx
801075a1:	5e                   	pop    %esi
801075a2:	5f                   	pop    %edi
801075a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801075a4:	e9 67 ad ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
801075a9:	83 ec 0c             	sub    $0xc,%esp
801075ac:	68 05 82 10 80       	push   $0x80108205
801075b1:	e8 da 8d ff ff       	call   80100390 <panic>
801075b6:	8d 76 00             	lea    0x0(%esi),%esi
801075b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075c0 <setupkvm>:
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	56                   	push   %esi
801075c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075c5:	e8 f6 ae ff ff       	call   801024c0 <kalloc>
801075ca:	85 c0                	test   %eax,%eax
801075cc:	89 c6                	mov    %eax,%esi
801075ce:	74 42                	je     80107612 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801075d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801075d8:	68 00 10 00 00       	push   $0x1000
801075dd:	6a 00                	push   $0x0
801075df:	50                   	push   %eax
801075e0:	e8 db d6 ff ff       	call   80104cc0 <memset>
801075e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801075e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075eb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075ee:	83 ec 08             	sub    $0x8,%esp
801075f1:	8b 13                	mov    (%ebx),%edx
801075f3:	ff 73 0c             	pushl  0xc(%ebx)
801075f6:	50                   	push   %eax
801075f7:	29 c1                	sub    %eax,%ecx
801075f9:	89 f0                	mov    %esi,%eax
801075fb:	e8 b0 f9 ff ff       	call   80106fb0 <mappages>
80107600:	83 c4 10             	add    $0x10,%esp
80107603:	85 c0                	test   %eax,%eax
80107605:	78 19                	js     80107620 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107607:	83 c3 10             	add    $0x10,%ebx
8010760a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107610:	75 d6                	jne    801075e8 <setupkvm+0x28>
}
80107612:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107615:	89 f0                	mov    %esi,%eax
80107617:	5b                   	pop    %ebx
80107618:	5e                   	pop    %esi
80107619:	5d                   	pop    %ebp
8010761a:	c3                   	ret    
8010761b:	90                   	nop
8010761c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107620:	83 ec 0c             	sub    $0xc,%esp
80107623:	56                   	push   %esi
      return 0;
80107624:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107626:	e8 15 ff ff ff       	call   80107540 <freevm>
      return 0;
8010762b:	83 c4 10             	add    $0x10,%esp
}
8010762e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107631:	89 f0                	mov    %esi,%eax
80107633:	5b                   	pop    %ebx
80107634:	5e                   	pop    %esi
80107635:	5d                   	pop    %ebp
80107636:	c3                   	ret    
80107637:	89 f6                	mov    %esi,%esi
80107639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107640 <kvmalloc>:
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107646:	e8 75 ff ff ff       	call   801075c0 <setupkvm>
8010764b:	a3 24 77 11 80       	mov    %eax,0x80117724
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107650:	05 00 00 00 80       	add    $0x80000000,%eax
80107655:	0f 22 d8             	mov    %eax,%cr3
}
80107658:	c9                   	leave  
80107659:	c3                   	ret    
8010765a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107660 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107660:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107661:	31 c9                	xor    %ecx,%ecx
{
80107663:	89 e5                	mov    %esp,%ebp
80107665:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107668:	8b 55 0c             	mov    0xc(%ebp),%edx
8010766b:	8b 45 08             	mov    0x8(%ebp),%eax
8010766e:	e8 bd f8 ff ff       	call   80106f30 <walkpgdir>
  if(pte == 0)
80107673:	85 c0                	test   %eax,%eax
80107675:	74 05                	je     8010767c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107677:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010767a:	c9                   	leave  
8010767b:	c3                   	ret    
    panic("clearpteu");
8010767c:	83 ec 0c             	sub    $0xc,%esp
8010767f:	68 16 82 10 80       	push   $0x80108216
80107684:	e8 07 8d ff ff       	call   80100390 <panic>
80107689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107690 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	57                   	push   %edi
80107694:	56                   	push   %esi
80107695:	53                   	push   %ebx
80107696:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107699:	e8 22 ff ff ff       	call   801075c0 <setupkvm>
8010769e:	85 c0                	test   %eax,%eax
801076a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076a3:	0f 84 9f 00 00 00    	je     80107748 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076ac:	85 c9                	test   %ecx,%ecx
801076ae:	0f 84 94 00 00 00    	je     80107748 <copyuvm+0xb8>
801076b4:	31 ff                	xor    %edi,%edi
801076b6:	eb 4a                	jmp    80107702 <copyuvm+0x72>
801076b8:	90                   	nop
801076b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801076c0:	83 ec 04             	sub    $0x4,%esp
801076c3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801076c9:	68 00 10 00 00       	push   $0x1000
801076ce:	53                   	push   %ebx
801076cf:	50                   	push   %eax
801076d0:	e8 9b d6 ff ff       	call   80104d70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076d5:	58                   	pop    %eax
801076d6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801076dc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076e1:	5a                   	pop    %edx
801076e2:	ff 75 e4             	pushl  -0x1c(%ebp)
801076e5:	50                   	push   %eax
801076e6:	89 fa                	mov    %edi,%edx
801076e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076eb:	e8 c0 f8 ff ff       	call   80106fb0 <mappages>
801076f0:	83 c4 10             	add    $0x10,%esp
801076f3:	85 c0                	test   %eax,%eax
801076f5:	78 61                	js     80107758 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801076f7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801076fd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107700:	76 46                	jbe    80107748 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107702:	8b 45 08             	mov    0x8(%ebp),%eax
80107705:	31 c9                	xor    %ecx,%ecx
80107707:	89 fa                	mov    %edi,%edx
80107709:	e8 22 f8 ff ff       	call   80106f30 <walkpgdir>
8010770e:	85 c0                	test   %eax,%eax
80107710:	74 61                	je     80107773 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107712:	8b 00                	mov    (%eax),%eax
80107714:	a8 01                	test   $0x1,%al
80107716:	74 4e                	je     80107766 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107718:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010771a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010771f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107728:	e8 93 ad ff ff       	call   801024c0 <kalloc>
8010772d:	85 c0                	test   %eax,%eax
8010772f:	89 c6                	mov    %eax,%esi
80107731:	75 8d                	jne    801076c0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107733:	83 ec 0c             	sub    $0xc,%esp
80107736:	ff 75 e0             	pushl  -0x20(%ebp)
80107739:	e8 02 fe ff ff       	call   80107540 <freevm>
  return 0;
8010773e:	83 c4 10             	add    $0x10,%esp
80107741:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107748:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010774b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010774e:	5b                   	pop    %ebx
8010774f:	5e                   	pop    %esi
80107750:	5f                   	pop    %edi
80107751:	5d                   	pop    %ebp
80107752:	c3                   	ret    
80107753:	90                   	nop
80107754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107758:	83 ec 0c             	sub    $0xc,%esp
8010775b:	56                   	push   %esi
8010775c:	e8 af ab ff ff       	call   80102310 <kfree>
      goto bad;
80107761:	83 c4 10             	add    $0x10,%esp
80107764:	eb cd                	jmp    80107733 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107766:	83 ec 0c             	sub    $0xc,%esp
80107769:	68 3a 82 10 80       	push   $0x8010823a
8010776e:	e8 1d 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107773:	83 ec 0c             	sub    $0xc,%esp
80107776:	68 20 82 10 80       	push   $0x80108220
8010777b:	e8 10 8c ff ff       	call   80100390 <panic>

80107780 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107780:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107781:	31 c9                	xor    %ecx,%ecx
{
80107783:	89 e5                	mov    %esp,%ebp
80107785:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107788:	8b 55 0c             	mov    0xc(%ebp),%edx
8010778b:	8b 45 08             	mov    0x8(%ebp),%eax
8010778e:	e8 9d f7 ff ff       	call   80106f30 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107793:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107795:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107796:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107798:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010779d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077a0:	05 00 00 00 80       	add    $0x80000000,%eax
801077a5:	83 fa 05             	cmp    $0x5,%edx
801077a8:	ba 00 00 00 00       	mov    $0x0,%edx
801077ad:	0f 45 c2             	cmovne %edx,%eax
}
801077b0:	c3                   	ret    
801077b1:	eb 0d                	jmp    801077c0 <copyout>
801077b3:	90                   	nop
801077b4:	90                   	nop
801077b5:	90                   	nop
801077b6:	90                   	nop
801077b7:	90                   	nop
801077b8:	90                   	nop
801077b9:	90                   	nop
801077ba:	90                   	nop
801077bb:	90                   	nop
801077bc:	90                   	nop
801077bd:	90                   	nop
801077be:	90                   	nop
801077bf:	90                   	nop

801077c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
801077c6:	83 ec 1c             	sub    $0x1c,%esp
801077c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801077cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801077cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077d2:	85 db                	test   %ebx,%ebx
801077d4:	75 40                	jne    80107816 <copyout+0x56>
801077d6:	eb 70                	jmp    80107848 <copyout+0x88>
801077d8:	90                   	nop
801077d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801077e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801077e3:	89 f1                	mov    %esi,%ecx
801077e5:	29 d1                	sub    %edx,%ecx
801077e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801077ed:	39 d9                	cmp    %ebx,%ecx
801077ef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077f2:	29 f2                	sub    %esi,%edx
801077f4:	83 ec 04             	sub    $0x4,%esp
801077f7:	01 d0                	add    %edx,%eax
801077f9:	51                   	push   %ecx
801077fa:	57                   	push   %edi
801077fb:	50                   	push   %eax
801077fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801077ff:	e8 6c d5 ff ff       	call   80104d70 <memmove>
    len -= n;
    buf += n;
80107804:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107807:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010780a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107810:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107812:	29 cb                	sub    %ecx,%ebx
80107814:	74 32                	je     80107848 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107816:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107818:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010781b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010781e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107824:	56                   	push   %esi
80107825:	ff 75 08             	pushl  0x8(%ebp)
80107828:	e8 53 ff ff ff       	call   80107780 <uva2ka>
    if(pa0 == 0)
8010782d:	83 c4 10             	add    $0x10,%esp
80107830:	85 c0                	test   %eax,%eax
80107832:	75 ac                	jne    801077e0 <copyout+0x20>
  }
  return 0;
}
80107834:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010783c:	5b                   	pop    %ebx
8010783d:	5e                   	pop    %esi
8010783e:	5f                   	pop    %edi
8010783f:	5d                   	pop    %ebp
80107840:	c3                   	ret    
80107841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107848:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010784b:	31 c0                	xor    %eax,%eax
}
8010784d:	5b                   	pop    %ebx
8010784e:	5e                   	pop    %esi
8010784f:	5f                   	pop    %edi
80107850:	5d                   	pop    %ebp
80107851:	c3                   	ret    
