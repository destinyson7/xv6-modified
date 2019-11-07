
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
8010004c:	68 c0 76 10 80       	push   $0x801076c0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 a5 48 00 00       	call   80104900 <initlock>
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
80100092:	68 c7 76 10 80       	push   $0x801076c7
80100097:	50                   	push   %eax
80100098:	e8 33 47 00 00       	call   801047d0 <initsleeplock>
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
801000e4:	e8 57 49 00 00       	call   80104a40 <acquire>
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
80100162:	e8 99 49 00 00       	call   80104b00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 46 00 00       	call   80104810 <acquiresleep>
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
80100193:	68 ce 76 10 80       	push   $0x801076ce
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
801001ae:	e8 fd 46 00 00       	call   801048b0 <holdingsleep>
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
801001cc:	68 df 76 10 80       	push   $0x801076df
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
801001ef:	e8 bc 46 00 00       	call   801048b0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 46 00 00       	call   80104870 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 30 48 00 00       	call   80104a40 <acquire>
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
8010025c:	e9 9f 48 00 00       	jmp    80104b00 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 76 10 80       	push   $0x801076e6
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
8010028c:	e8 af 47 00 00       	call   80104a40 <acquire>
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
801002c5:	e8 b6 3b 00 00       	call   80103e80 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 20 15 11 80    	mov    0x80111520,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 24 15 11 80    	cmp    0x80111524,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 d0 35 00 00       	call   801038b0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 0c 48 00 00       	call   80104b00 <release>
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
8010034d:	e8 ae 47 00 00       	call   80104b00 <release>
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
801003b2:	68 ed 76 10 80       	push   $0x801076ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 03 81 10 80 	movl   $0x80108103,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 43 45 00 00       	call   80104920 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 77 10 80       	push   $0x80107701
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
8010043a:	e8 91 5e 00 00       	call   801062d0 <uartputc>
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
801004ec:	e8 df 5d 00 00       	call   801062d0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 5d 00 00       	call   801062d0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 5d 00 00       	call   801062d0 <uartputc>
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
80100524:	e8 d7 46 00 00       	call   80104c00 <memmove>
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
80100541:	e8 0a 46 00 00       	call   80104b50 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 77 10 80       	push   $0x80107705
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
801005b1:	0f b6 92 30 77 10 80 	movzbl -0x7fef88d0(%edx),%edx
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
8010061b:	e8 20 44 00 00       	call   80104a40 <acquire>
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
80100647:	e8 b4 44 00 00       	call   80104b00 <release>
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
8010071f:	e8 dc 43 00 00       	call   80104b00 <release>
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
801007d0:	ba 18 77 10 80       	mov    $0x80107718,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 4b 42 00 00       	call   80104a40 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 77 10 80       	push   $0x8010771f
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
80100823:	e8 18 42 00 00       	call   80104a40 <acquire>
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
80100888:	e8 73 42 00 00       	call   80104b00 <release>
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
80100916:	e8 45 38 00 00       	call   80104160 <wakeup>
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
80100997:	e9 a4 38 00 00       	jmp    80104240 <procdump>
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
801009c6:	68 28 77 10 80       	push   $0x80107728
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 2b 3f 00 00       	call   80104900 <initlock>

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
80100a1c:	e8 8f 2e 00 00       	call   801038b0 <myproc>
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
80100a94:	e8 87 69 00 00       	call   80107420 <setupkvm>
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
80100af6:	e8 45 67 00 00       	call   80107240 <allocuvm>
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
80100b28:	e8 53 66 00 00       	call   80107180 <loaduvm>
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
80100b72:	e8 29 68 00 00       	call   801073a0 <freevm>
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
80100baa:	e8 91 66 00 00       	call   80107240 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 da 67 00 00       	call   801073a0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 77 10 80       	push   $0x80107741
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
80100c06:	e8 b5 68 00 00       	call   801074c0 <clearpteu>
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
80100c39:	e8 32 41 00 00       	call   80104d70 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 1f 41 00 00       	call   80104d70 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 be 69 00 00       	call   80107620 <copyout>
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
80100cc7:	e8 54 69 00 00       	call   80107620 <copyout>
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
80100d0a:	e8 21 40 00 00       	call   80104d30 <safestrcpy>
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
80100d34:	e8 b7 62 00 00       	call   80106ff0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 5f 66 00 00       	call   801073a0 <freevm>
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
80100d66:	68 4d 77 10 80       	push   $0x8010774d
80100d6b:	68 40 15 11 80       	push   $0x80111540
80100d70:	e8 8b 3b 00 00       	call   80104900 <initlock>
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
80100d91:	e8 aa 3c 00 00       	call   80104a40 <acquire>
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
80100dc1:	e8 3a 3d 00 00       	call   80104b00 <release>
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
80100dda:	e8 21 3d 00 00       	call   80104b00 <release>
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
80100dff:	e8 3c 3c 00 00       	call   80104a40 <acquire>
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
80100e1c:	e8 df 3c 00 00       	call   80104b00 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 77 10 80       	push   $0x80107754
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
80100e51:	e8 ea 3b 00 00       	call   80104a40 <acquire>
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
80100e7c:	e9 7f 3c 00 00       	jmp    80104b00 <release>
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
80100ea8:	e8 53 3c 00 00       	call   80104b00 <release>
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
80100f02:	68 5c 77 10 80       	push   $0x8010775c
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
80100fe2:	68 66 77 10 80       	push   $0x80107766
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
801010f5:	68 6f 77 10 80       	push   $0x8010776f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 77 10 80       	push   $0x80107775
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
80101173:	68 7f 77 10 80       	push   $0x8010777f
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
80101224:	68 92 77 10 80       	push   $0x80107792
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
80101265:	e8 e6 38 00 00       	call   80104b50 <memset>
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
801012aa:	e8 91 37 00 00       	call   80104a40 <acquire>
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
8010130f:	e8 ec 37 00 00       	call   80104b00 <release>

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
8010133d:	e8 be 37 00 00       	call   80104b00 <release>
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
80101352:	68 a8 77 10 80       	push   $0x801077a8
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
80101427:	68 b8 77 10 80       	push   $0x801077b8
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
80101461:	e8 9a 37 00 00       	call   80104c00 <memmove>
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
8010148c:	68 cb 77 10 80       	push   $0x801077cb
80101491:	68 60 1f 11 80       	push   $0x80111f60
80101496:	e8 65 34 00 00       	call   80104900 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 d2 77 10 80       	push   $0x801077d2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 1c 33 00 00       	call   801047d0 <initsleeplock>
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
801014f9:	68 38 78 10 80       	push   $0x80107838
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
8010158e:	e8 bd 35 00 00       	call   80104b50 <memset>
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
801015c3:	68 d8 77 10 80       	push   $0x801077d8
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
80101631:	e8 ca 35 00 00       	call   80104c00 <memmove>
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
8010165f:	e8 dc 33 00 00       	call   80104a40 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
8010166f:	e8 8c 34 00 00       	call   80104b00 <release>
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
801016a2:	e8 69 31 00 00       	call   80104810 <acquiresleep>
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
80101718:	e8 e3 34 00 00       	call   80104c00 <memmove>
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
8010173d:	68 f0 77 10 80       	push   $0x801077f0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ea 77 10 80       	push   $0x801077ea
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
80101773:	e8 38 31 00 00       	call   801048b0 <holdingsleep>
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
8010178f:	e9 dc 30 00 00       	jmp    80104870 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 ff 77 10 80       	push   $0x801077ff
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
801017c0:	e8 4b 30 00 00       	call   80104810 <acquiresleep>
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
801017da:	e8 91 30 00 00       	call   80104870 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
801017e6:	e8 55 32 00 00       	call   80104a40 <acquire>
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
80101800:	e9 fb 32 00 00       	jmp    80104b00 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 60 1f 11 80       	push   $0x80111f60
80101810:	e8 2b 32 00 00       	call   80104a40 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
8010181f:	e8 dc 32 00 00       	call   80104b00 <release>
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
80101a07:	e8 f4 31 00 00       	call   80104c00 <memmove>
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
80101b03:	e8 f8 30 00 00       	call   80104c00 <memmove>
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
80101b9e:	e8 cd 30 00 00       	call   80104c70 <strncmp>
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
80101bfd:	e8 6e 30 00 00       	call   80104c70 <strncmp>
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
80101c42:	68 19 78 10 80       	push   $0x80107819
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 07 78 10 80       	push   $0x80107807
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
80101c79:	e8 32 1c 00 00       	call   801038b0 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 60 1f 11 80       	push   $0x80111f60
80101c89:	e8 b2 2d 00 00       	call   80104a40 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
80101c99:	e8 62 2e 00 00       	call   80104b00 <release>
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
80101cf5:	e8 06 2f 00 00       	call   80104c00 <memmove>
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
80101d88:	e8 73 2e 00 00       	call   80104c00 <memmove>
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
80101e7d:	e8 4e 2e 00 00       	call   80104cd0 <strncpy>
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
80101ebb:	68 28 78 10 80       	push   $0x80107828
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 ea 7e 10 80       	push   $0x80107eea
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
80101fdb:	68 94 78 10 80       	push   $0x80107894
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 8b 78 10 80       	push   $0x8010788b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 a6 78 10 80       	push   $0x801078a6
8010200b:	68 80 b5 10 80       	push   $0x8010b580
80102010:	e8 eb 28 00 00       	call   80104900 <initlock>
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
8010208e:	e8 ad 29 00 00       	call   80104a40 <acquire>

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
801020f1:	e8 6a 20 00 00       	call   80104160 <wakeup>

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
8010210f:	e8 ec 29 00 00       	call   80104b00 <release>

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
8010212e:	e8 7d 27 00 00       	call   801048b0 <holdingsleep>
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
80102168:	e8 d3 28 00 00       	call   80104a40 <acquire>

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
801021b9:	e8 c2 1c 00 00       	call   80103e80 <sleep>
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
801021d6:	e9 25 29 00 00       	jmp    80104b00 <release>
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
801021fa:	68 c0 78 10 80       	push   $0x801078c0
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 aa 78 10 80       	push   $0x801078aa
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 d5 78 10 80       	push   $0x801078d5
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
80102267:	68 f4 78 10 80       	push   $0x801078f4
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
80102342:	e8 09 28 00 00       	call   80104b50 <memset>

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
8010237b:	e9 80 27 00 00       	jmp    80104b00 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 c0 3b 11 80       	push   $0x80113bc0
80102388:	e8 b3 26 00 00       	call   80104a40 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 26 79 10 80       	push   $0x80107926
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
801023fb:	68 2c 79 10 80       	push   $0x8010792c
80102400:	68 c0 3b 11 80       	push   $0x80113bc0
80102405:	e8 f6 24 00 00       	call   80104900 <initlock>
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
801024f3:	e8 48 25 00 00       	call   80104a40 <acquire>
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
80102521:	e8 da 25 00 00       	call   80104b00 <release>
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
80102573:	0f b6 82 60 7a 10 80 	movzbl -0x7fef85a0(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 60 79 10 80 	movzbl -0x7fef86a0(%edx),%eax
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
80102593:	8b 04 85 40 79 10 80 	mov    -0x7fef86c0(,%eax,4),%eax
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
801025b8:	0f b6 82 60 7a 10 80 	movzbl -0x7fef85a0(%edx),%eax
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
80102937:	e8 64 22 00 00       	call   80104ba0 <memcmp>
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
80102a64:	e8 97 21 00 00       	call   80104c00 <memmove>
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
80102b0a:	68 60 7b 10 80       	push   $0x80107b60
80102b0f:	68 00 3c 11 80       	push   $0x80113c00
80102b14:	e8 e7 1d 00 00       	call   80104900 <initlock>
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
80102bab:	e8 90 1e 00 00       	call   80104a40 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 00 3c 11 80       	push   $0x80113c00
80102bc0:	68 00 3c 11 80       	push   $0x80113c00
80102bc5:	e8 b6 12 00 00       	call   80103e80 <sleep>
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
80102bfc:	e8 ff 1e 00 00       	call   80104b00 <release>
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
80102c1e:	e8 1d 1e 00 00       	call   80104a40 <acquire>
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
80102c5c:	e8 9f 1e 00 00       	call   80104b00 <release>
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
80102cb6:	e8 45 1f 00 00       	call   80104c00 <memmove>
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
80102cff:	e8 3c 1d 00 00       	call   80104a40 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
    log.committing = 0;
80102d0b:	c7 05 40 3c 11 80 00 	movl   $0x0,0x80113c40
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 46 14 00 00       	call   80104160 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
80102d21:	e8 da 1d 00 00       	call   80104b00 <release>
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
80102d40:	e8 1b 14 00 00       	call   80104160 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
80102d4c:	e8 af 1d 00 00       	call   80104b00 <release>
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
80102d5f:	68 64 7b 10 80       	push   $0x80107b64
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
80102dae:	e8 8d 1c 00 00       	call   80104a40 <acquire>
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
80102dfd:	e9 fe 1c 00 00       	jmp    80104b00 <release>
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
80102e29:	68 73 7b 10 80       	push   $0x80107b73
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 89 7b 10 80       	push   $0x80107b89
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
80102e47:	e8 44 0a 00 00       	call   80103890 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 3d 0a 00 00       	call   80103890 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 a4 7b 10 80       	push   $0x80107ba4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 69 30 00 00       	call   80105ed0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 a4 09 00 00       	call   80103810 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 f1 0c 00 00       	call   80103b70 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 45 41 00 00       	call   80106fd0 <switchkvm>
  seginit();
80102e8b:	e8 b0 40 00 00       	call   80106f40 <seginit>
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
80102efc:	e8 9f 45 00 00       	call   801074a0 <kvmalloc>
  mpinit();        // detect other processors
80102f01:	e8 7a 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f06:	e8 25 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102f0b:	e8 30 40 00 00       	call   80106f40 <seginit>
  picinit();       // disable pic
80102f10:	e8 4b 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f15:	e8 06 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102f1a:	e8 a1 da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f1f:	e8 ec 32 00 00       	call   80106210 <uartinit>
  pinit();         // process table
80102f24:	e8 c7 08 00 00       	call   801037f0 <pinit>
  tvinit();        // trap vectors
80102f29:	e8 22 2f 00 00       	call   80105e50 <tvinit>
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
80102f4f:	e8 ac 1c 00 00       	call   80104c00 <memmove>

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
80102f78:	e8 93 08 00 00       	call   80103810 <mycpu>
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
80102ff5:	e8 e6 08 00 00       	call   801038e0 <userinit>
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
8010302e:	68 b8 7b 10 80       	push   $0x80107bb8
80103033:	56                   	push   %esi
80103034:	e8 67 1b 00 00       	call   80104ba0 <memcmp>
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
801030ec:	68 d5 7b 10 80       	push   $0x80107bd5
801030f1:	56                   	push   %esi
801030f2:	e8 a9 1a 00 00       	call   80104ba0 <memcmp>
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
80103180:	ff 24 95 fc 7b 10 80 	jmp    *-0x7fef8404(,%edx,4)
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
80103233:	68 bd 7b 10 80       	push   $0x80107bbd
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 dc 7b 10 80       	push   $0x80107bdc
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
8010333b:	68 10 7c 10 80       	push   $0x80107c10
80103340:	50                   	push   %eax
80103341:	e8 ba 15 00 00       	call   80104900 <initlock>
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
8010339f:	e8 9c 16 00 00       	call   80104a40 <acquire>
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
801033bf:	e8 9c 0d 00 00       	call   80104160 <wakeup>
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
801033e4:	e9 17 17 00 00       	jmp    80104b00 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 57 0d 00 00       	call   80104160 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 e7 16 00 00       	call   80104b00 <release>
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
8010343d:	e8 fe 15 00 00       	call   80104a40 <acquire>
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
80103494:	e8 c7 0c 00 00       	call   80104160 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 de 09 00 00       	call   80103e80 <sleep>
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
801034c4:	e8 e7 03 00 00       	call   801038b0 <myproc>
801034c9:	8b 40 24             	mov    0x24(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 27 16 00 00       	call   80104b00 <release>
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
80103523:	e8 38 0c 00 00       	call   80104160 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 d0 15 00 00       	call   80104b00 <release>
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
80103550:	e8 eb 14 00 00       	call   80104a40 <acquire>
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
80103585:	e8 f6 08 00 00       	call   80103e80 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
801035a9:	e8 02 03 00 00       	call   801038b0 <myproc>
801035ae:	8b 48 24             	mov    0x24(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 3d 15 00 00       	call   80104b00 <release>
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
80103617:	e8 44 0b 00 00       	call   80104160 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 dc 14 00 00       	call   80104b00 <release>
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

80103640 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103644:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
{
80103649:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010364c:	68 a0 42 11 80       	push   $0x801142a0
80103651:	e8 ea 13 00 00       	call   80104a40 <acquire>
80103656:	83 c4 10             	add    $0x10,%esp
80103659:	eb 17                	jmp    80103672 <allocproc+0x32>
8010365b:	90                   	nop
8010365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103660:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103666:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
8010366c:	0f 83 fe 00 00 00    	jae    80103770 <allocproc+0x130>
    if(p->state == UNUSED)
80103672:	8b 43 0c             	mov    0xc(%ebx),%eax
80103675:	85 c0                	test   %eax,%eax
80103677:	75 e7                	jne    80103660 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103679:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  #endif
  
  // cprintf("****** allocproc ******\n");

  release(&ptable.lock);
8010367e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103681:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p -> end_time = 0;                              
80103688:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010368f:	00 00 00 
  p -> run_time = 0;                               
80103692:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103699:	00 00 00 
  p -> wait_time = 0;                           
8010369c:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801036a3:	00 00 00 
  p -> priority = 60;
801036a6:	c7 83 8c 00 00 00 3c 	movl   $0x3c,0x8c(%ebx)
801036ad:	00 00 00 
  p->pid = nextpid++;
801036b0:	8d 50 01             	lea    0x1(%eax),%edx
801036b3:	89 43 10             	mov    %eax,0x10(%ebx)
  p -> start_time = ticks;
801036b6:	a1 20 77 11 80       	mov    0x80117720,%eax
  p -> queueNo = 0;
801036bb:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801036c2:	00 00 00 
  p -> cur_time = 0;
801036c5:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801036cc:	00 00 00 
  p -> num_run = 0;
801036cf:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801036d6:	00 00 00 
    p -> ticks[i] = 0;
801036d9:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801036e0:	00 00 00 
  p -> start_time = ticks;
801036e3:	89 43 7c             	mov    %eax,0x7c(%ebx)
    p -> ticks[i] = 0;
801036e6:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801036ed:	00 00 00 
801036f0:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
801036f7:	00 00 00 
801036fa:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
80103701:	00 00 00 
80103704:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
8010370b:	00 00 00 
  release(&ptable.lock);
8010370e:	68 a0 42 11 80       	push   $0x801142a0
  p->pid = nextpid++;
80103713:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103719:	e8 e2 13 00 00       	call   80104b00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010371e:	e8 9d ed ff ff       	call   801024c0 <kalloc>
80103723:	83 c4 10             	add    $0x10,%esp
80103726:	85 c0                	test   %eax,%eax
80103728:	89 43 08             	mov    %eax,0x8(%ebx)
8010372b:	74 5c                	je     80103789 <allocproc+0x149>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010372d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103733:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103736:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010373b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010373e:	c7 40 14 37 5e 10 80 	movl   $0x80105e37,0x14(%eax)
  p->context = (struct context*)sp;
80103745:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103748:	6a 14                	push   $0x14
8010374a:	6a 00                	push   $0x0
8010374c:	50                   	push   %eax
8010374d:	e8 fe 13 00 00       	call   80104b50 <memset>
  p->context->eip = (uint)forkret;
80103752:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103755:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103758:	c7 40 10 a0 37 10 80 	movl   $0x801037a0,0x10(%eax)
}
8010375f:	89 d8                	mov    %ebx,%eax
80103761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103764:	c9                   	leave  
80103765:	c3                   	ret    
80103766:	8d 76 00             	lea    0x0(%esi),%esi
80103769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&ptable.lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103773:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103775:	68 a0 42 11 80       	push   $0x801142a0
8010377a:	e8 81 13 00 00       	call   80104b00 <release>
}
8010377f:	89 d8                	mov    %ebx,%eax
  return 0;
80103781:	83 c4 10             	add    $0x10,%esp
}
80103784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103787:	c9                   	leave  
80103788:	c3                   	ret    
    p->state = UNUSED;
80103789:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103790:	31 db                	xor    %ebx,%ebx
80103792:	eb cb                	jmp    8010375f <allocproc+0x11f>
80103794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010379a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037a6:	68 a0 42 11 80       	push   $0x801142a0
801037ab:	e8 50 13 00 00       	call   80104b00 <release>

  if (first) {
801037b0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801037b5:	83 c4 10             	add    $0x10,%esp
801037b8:	85 c0                	test   %eax,%eax
801037ba:	75 04                	jne    801037c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037bc:	c9                   	leave  
801037bd:	c3                   	ret    
801037be:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801037c0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801037c3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801037ca:	00 00 00 
    iinit(ROOTDEV);
801037cd:	6a 01                	push   $0x1
801037cf:	e8 ac dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801037d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037db:	e8 20 f3 ff ff       	call   80102b00 <initlog>
801037e0:	83 c4 10             	add    $0x10,%esp
}
801037e3:	c9                   	leave  
801037e4:	c3                   	ret    
801037e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037f0 <pinit>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037f6:	68 15 7c 10 80       	push   $0x80107c15
801037fb:	68 a0 42 11 80       	push   $0x801142a0
80103800:	e8 fb 10 00 00       	call   80104900 <initlock>
}
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	c9                   	leave  
80103809:	c3                   	ret    
8010380a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103810 <mycpu>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	56                   	push   %esi
80103814:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103815:	9c                   	pushf  
80103816:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103817:	f6 c4 02             	test   $0x2,%ah
8010381a:	75 5e                	jne    8010387a <mycpu+0x6a>
  apicid = lapicid();
8010381c:	e8 0f ef ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103821:	8b 35 80 42 11 80    	mov    0x80114280,%esi
80103827:	85 f6                	test   %esi,%esi
80103829:	7e 42                	jle    8010386d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010382b:	0f b6 15 00 3d 11 80 	movzbl 0x80113d00,%edx
80103832:	39 d0                	cmp    %edx,%eax
80103834:	74 30                	je     80103866 <mycpu+0x56>
80103836:	b9 b0 3d 11 80       	mov    $0x80113db0,%ecx
  for (i = 0; i < ncpu; ++i) {
8010383b:	31 d2                	xor    %edx,%edx
8010383d:	8d 76 00             	lea    0x0(%esi),%esi
80103840:	83 c2 01             	add    $0x1,%edx
80103843:	39 f2                	cmp    %esi,%edx
80103845:	74 26                	je     8010386d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103847:	0f b6 19             	movzbl (%ecx),%ebx
8010384a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103850:	39 c3                	cmp    %eax,%ebx
80103852:	75 ec                	jne    80103840 <mycpu+0x30>
80103854:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010385a:	05 00 3d 11 80       	add    $0x80113d00,%eax
}
8010385f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103862:	5b                   	pop    %ebx
80103863:	5e                   	pop    %esi
80103864:	5d                   	pop    %ebp
80103865:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103866:	b8 00 3d 11 80       	mov    $0x80113d00,%eax
      return &cpus[i];
8010386b:	eb f2                	jmp    8010385f <mycpu+0x4f>
  panic("unknown apicid\n");
8010386d:	83 ec 0c             	sub    $0xc,%esp
80103870:	68 1c 7c 10 80       	push   $0x80107c1c
80103875:	e8 16 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010387a:	83 ec 0c             	sub    $0xc,%esp
8010387d:	68 10 7d 10 80       	push   $0x80107d10
80103882:	e8 09 cb ff ff       	call   80100390 <panic>
80103887:	89 f6                	mov    %esi,%esi
80103889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103890 <cpuid>:
cpuid() {
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103896:	e8 75 ff ff ff       	call   80103810 <mycpu>
8010389b:	2d 00 3d 11 80       	sub    $0x80113d00,%eax
}
801038a0:	c9                   	leave  
  return mycpu()-cpus;
801038a1:	c1 f8 04             	sar    $0x4,%eax
801038a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038aa:	c3                   	ret    
801038ab:	90                   	nop
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038b0 <myproc>:
myproc(void) {
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	53                   	push   %ebx
801038b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038b7:	e8 b4 10 00 00       	call   80104970 <pushcli>
  c = mycpu();
801038bc:	e8 4f ff ff ff       	call   80103810 <mycpu>
  p = c->proc;
801038c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038c7:	e8 e4 10 00 00       	call   801049b0 <popcli>
}
801038cc:	83 c4 04             	add    $0x4,%esp
801038cf:	89 d8                	mov    %ebx,%eax
801038d1:	5b                   	pop    %ebx
801038d2:	5d                   	pop    %ebp
801038d3:	c3                   	ret    
801038d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038e0 <userinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
801038e4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801038e7:	e8 54 fd ff ff       	call   80103640 <allocproc>
801038ec:	89 c3                	mov    %eax,%ebx
  initproc = p;
801038ee:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801038f3:	e8 28 3b 00 00       	call   80107420 <setupkvm>
801038f8:	85 c0                	test   %eax,%eax
801038fa:	89 43 04             	mov    %eax,0x4(%ebx)
801038fd:	0f 84 bd 00 00 00    	je     801039c0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103903:	83 ec 04             	sub    $0x4,%esp
80103906:	68 2c 00 00 00       	push   $0x2c
8010390b:	68 60 b4 10 80       	push   $0x8010b460
80103910:	50                   	push   %eax
80103911:	e8 ea 37 00 00       	call   80107100 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103916:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103919:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010391f:	6a 4c                	push   $0x4c
80103921:	6a 00                	push   $0x0
80103923:	ff 73 18             	pushl  0x18(%ebx)
80103926:	e8 25 12 00 00       	call   80104b50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010392b:	8b 43 18             	mov    0x18(%ebx),%eax
8010392e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103933:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103938:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010393b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010393f:	8b 43 18             	mov    0x18(%ebx),%eax
80103942:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103946:	8b 43 18             	mov    0x18(%ebx),%eax
80103949:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010394d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103951:	8b 43 18             	mov    0x18(%ebx),%eax
80103954:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103958:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010395c:	8b 43 18             	mov    0x18(%ebx),%eax
8010395f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103966:	8b 43 18             	mov    0x18(%ebx),%eax
80103969:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103970:	8b 43 18             	mov    0x18(%ebx),%eax
80103973:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010397a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010397d:	6a 10                	push   $0x10
8010397f:	68 45 7c 10 80       	push   $0x80107c45
80103984:	50                   	push   %eax
80103985:	e8 a6 13 00 00       	call   80104d30 <safestrcpy>
  p->cwd = namei("/");
8010398a:	c7 04 24 4e 7c 10 80 	movl   $0x80107c4e,(%esp)
80103991:	e8 4a e5 ff ff       	call   80101ee0 <namei>
80103996:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103999:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
801039a0:	e8 9b 10 00 00       	call   80104a40 <acquire>
  p->state = RUNNABLE;
801039a5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801039ac:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
801039b3:	e8 48 11 00 00       	call   80104b00 <release>
}
801039b8:	83 c4 10             	add    $0x10,%esp
801039bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039be:	c9                   	leave  
801039bf:	c3                   	ret    
    panic("userinit: out of memory?");
801039c0:	83 ec 0c             	sub    $0xc,%esp
801039c3:	68 2c 7c 10 80       	push   $0x80107c2c
801039c8:	e8 c3 c9 ff ff       	call   80100390 <panic>
801039cd:	8d 76 00             	lea    0x0(%esi),%esi

801039d0 <growproc>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	56                   	push   %esi
801039d4:	53                   	push   %ebx
801039d5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801039d8:	e8 93 0f 00 00       	call   80104970 <pushcli>
  c = mycpu();
801039dd:	e8 2e fe ff ff       	call   80103810 <mycpu>
  p = c->proc;
801039e2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039e8:	e8 c3 0f 00 00       	call   801049b0 <popcli>
  if(n > 0){
801039ed:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801039f0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801039f2:	7f 1c                	jg     80103a10 <growproc+0x40>
  } else if(n < 0){
801039f4:	75 3a                	jne    80103a30 <growproc+0x60>
  switchuvm(curproc);
801039f6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801039f9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039fb:	53                   	push   %ebx
801039fc:	e8 ef 35 00 00       	call   80106ff0 <switchuvm>
  return 0;
80103a01:	83 c4 10             	add    $0x10,%esp
80103a04:	31 c0                	xor    %eax,%eax
}
80103a06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a09:	5b                   	pop    %ebx
80103a0a:	5e                   	pop    %esi
80103a0b:	5d                   	pop    %ebp
80103a0c:	c3                   	ret    
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a10:	83 ec 04             	sub    $0x4,%esp
80103a13:	01 c6                	add    %eax,%esi
80103a15:	56                   	push   %esi
80103a16:	50                   	push   %eax
80103a17:	ff 73 04             	pushl  0x4(%ebx)
80103a1a:	e8 21 38 00 00       	call   80107240 <allocuvm>
80103a1f:	83 c4 10             	add    $0x10,%esp
80103a22:	85 c0                	test   %eax,%eax
80103a24:	75 d0                	jne    801039f6 <growproc+0x26>
      return -1;
80103a26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a2b:	eb d9                	jmp    80103a06 <growproc+0x36>
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a30:	83 ec 04             	sub    $0x4,%esp
80103a33:	01 c6                	add    %eax,%esi
80103a35:	56                   	push   %esi
80103a36:	50                   	push   %eax
80103a37:	ff 73 04             	pushl  0x4(%ebx)
80103a3a:	e8 31 39 00 00       	call   80107370 <deallocuvm>
80103a3f:	83 c4 10             	add    $0x10,%esp
80103a42:	85 c0                	test   %eax,%eax
80103a44:	75 b0                	jne    801039f6 <growproc+0x26>
80103a46:	eb de                	jmp    80103a26 <growproc+0x56>
80103a48:	90                   	nop
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a50 <fork>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	57                   	push   %edi
80103a54:	56                   	push   %esi
80103a55:	53                   	push   %ebx
80103a56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a59:	e8 12 0f 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103a5e:	e8 ad fd ff ff       	call   80103810 <mycpu>
  p = c->proc;
80103a63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a69:	e8 42 0f 00 00       	call   801049b0 <popcli>
  if((np = allocproc()) == 0){
80103a6e:	e8 cd fb ff ff       	call   80103640 <allocproc>
80103a73:	85 c0                	test   %eax,%eax
80103a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a78:	0f 84 b7 00 00 00    	je     80103b35 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a7e:	83 ec 08             	sub    $0x8,%esp
80103a81:	ff 33                	pushl  (%ebx)
80103a83:	ff 73 04             	pushl  0x4(%ebx)
80103a86:	89 c7                	mov    %eax,%edi
80103a88:	e8 63 3a 00 00       	call   801074f0 <copyuvm>
80103a8d:	83 c4 10             	add    $0x10,%esp
80103a90:	85 c0                	test   %eax,%eax
80103a92:	89 47 04             	mov    %eax,0x4(%edi)
80103a95:	0f 84 a1 00 00 00    	je     80103b3c <fork+0xec>
  np->sz = curproc->sz;
80103a9b:	8b 03                	mov    (%ebx),%eax
80103a9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103aa0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103aa2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103aa5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103aa7:	8b 79 18             	mov    0x18(%ecx),%edi
80103aaa:	8b 73 18             	mov    0x18(%ebx),%esi
80103aad:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ab2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ab4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ab6:	8b 40 18             	mov    0x18(%eax),%eax
80103ab9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ac0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ac4:	85 c0                	test   %eax,%eax
80103ac6:	74 13                	je     80103adb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ac8:	83 ec 0c             	sub    $0xc,%esp
80103acb:	50                   	push   %eax
80103acc:	e8 1f d3 ff ff       	call   80100df0 <filedup>
80103ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ad4:	83 c4 10             	add    $0x10,%esp
80103ad7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103adb:	83 c6 01             	add    $0x1,%esi
80103ade:	83 fe 10             	cmp    $0x10,%esi
80103ae1:	75 dd                	jne    80103ac0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ae3:	83 ec 0c             	sub    $0xc,%esp
80103ae6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ae9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103aec:	e8 5f db ff ff       	call   80101650 <idup>
80103af1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103af4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103af7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103afa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103afd:	6a 10                	push   $0x10
80103aff:	53                   	push   %ebx
80103b00:	50                   	push   %eax
80103b01:	e8 2a 12 00 00       	call   80104d30 <safestrcpy>
  pid = np->pid;
80103b06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b09:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80103b10:	e8 2b 0f 00 00       	call   80104a40 <acquire>
  np->state = RUNNABLE;
80103b15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b1c:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80103b23:	e8 d8 0f 00 00       	call   80104b00 <release>
  return pid;
80103b28:	83 c4 10             	add    $0x10,%esp
}
80103b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b2e:	89 d8                	mov    %ebx,%eax
80103b30:	5b                   	pop    %ebx
80103b31:	5e                   	pop    %esi
80103b32:	5f                   	pop    %edi
80103b33:	5d                   	pop    %ebp
80103b34:	c3                   	ret    
    return -1;
80103b35:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b3a:	eb ef                	jmp    80103b2b <fork+0xdb>
    kfree(np->kstack);
80103b3c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b3f:	83 ec 0c             	sub    $0xc,%esp
80103b42:	ff 73 08             	pushl  0x8(%ebx)
80103b45:	e8 c6 e7 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103b4a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b51:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b58:	83 c4 10             	add    $0x10,%esp
80103b5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b60:	eb c9                	jmp    80103b2b <fork+0xdb>
80103b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b70 <scheduler>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b79:	e8 92 fc ff ff       	call   80103810 <mycpu>
80103b7e:	8d 78 04             	lea    0x4(%eax),%edi
80103b81:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103b83:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b8a:	00 00 00 
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103b90:	fb                   	sti    
    acquire(&ptable.lock);
80103b91:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b94:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
    acquire(&ptable.lock);
80103b99:	68 a0 42 11 80       	push   $0x801142a0
80103b9e:	e8 9d 0e 00 00       	call   80104a40 <acquire>
80103ba3:	83 c4 10             	add    $0x10,%esp
80103ba6:	8d 76 00             	lea    0x0(%esi),%esi
80103ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103bb0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103bb4:	75 33                	jne    80103be9 <scheduler+0x79>
      switchuvm(p);
80103bb6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103bb9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103bbf:	53                   	push   %ebx
80103bc0:	e8 2b 34 00 00       	call   80106ff0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103bc5:	58                   	pop    %eax
80103bc6:	5a                   	pop    %edx
80103bc7:	ff 73 1c             	pushl  0x1c(%ebx)
80103bca:	57                   	push   %edi
      p->state = RUNNING;
80103bcb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103bd2:	e8 b4 11 00 00       	call   80104d8b <swtch>
      switchkvm();
80103bd7:	e8 f4 33 00 00       	call   80106fd0 <switchkvm>
      c->proc = 0;
80103bdc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103be3:	00 00 00 
80103be6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103be9:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103bef:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80103bf5:	72 b9                	jb     80103bb0 <scheduler+0x40>
    release(&ptable.lock);
80103bf7:	83 ec 0c             	sub    $0xc,%esp
80103bfa:	68 a0 42 11 80       	push   $0x801142a0
80103bff:	e8 fc 0e 00 00       	call   80104b00 <release>
    sti();
80103c04:	83 c4 10             	add    $0x10,%esp
80103c07:	eb 87                	jmp    80103b90 <scheduler+0x20>
80103c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c10 <sched>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	56                   	push   %esi
80103c14:	53                   	push   %ebx
  pushcli();
80103c15:	e8 56 0d 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103c1a:	e8 f1 fb ff ff       	call   80103810 <mycpu>
  p = c->proc;
80103c1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c25:	e8 86 0d 00 00       	call   801049b0 <popcli>
  if(!holding(&ptable.lock))
80103c2a:	83 ec 0c             	sub    $0xc,%esp
80103c2d:	68 a0 42 11 80       	push   $0x801142a0
80103c32:	e8 d9 0d 00 00       	call   80104a10 <holding>
80103c37:	83 c4 10             	add    $0x10,%esp
80103c3a:	85 c0                	test   %eax,%eax
80103c3c:	74 4f                	je     80103c8d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c3e:	e8 cd fb ff ff       	call   80103810 <mycpu>
80103c43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c4a:	75 68                	jne    80103cb4 <sched+0xa4>
  if(p->state == RUNNING)
80103c4c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c50:	74 55                	je     80103ca7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c52:	9c                   	pushf  
80103c53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c54:	f6 c4 02             	test   $0x2,%ah
80103c57:	75 41                	jne    80103c9a <sched+0x8a>
  intena = mycpu()->intena;
80103c59:	e8 b2 fb ff ff       	call   80103810 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c5e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c67:	e8 a4 fb ff ff       	call   80103810 <mycpu>
80103c6c:	83 ec 08             	sub    $0x8,%esp
80103c6f:	ff 70 04             	pushl  0x4(%eax)
80103c72:	53                   	push   %ebx
80103c73:	e8 13 11 00 00       	call   80104d8b <swtch>
  mycpu()->intena = intena;
80103c78:	e8 93 fb ff ff       	call   80103810 <mycpu>
}
80103c7d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c89:	5b                   	pop    %ebx
80103c8a:	5e                   	pop    %esi
80103c8b:	5d                   	pop    %ebp
80103c8c:	c3                   	ret    
    panic("sched ptable.lock");
80103c8d:	83 ec 0c             	sub    $0xc,%esp
80103c90:	68 50 7c 10 80       	push   $0x80107c50
80103c95:	e8 f6 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	68 7c 7c 10 80       	push   $0x80107c7c
80103ca2:	e8 e9 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ca7:	83 ec 0c             	sub    $0xc,%esp
80103caa:	68 6e 7c 10 80       	push   $0x80107c6e
80103caf:	e8 dc c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103cb4:	83 ec 0c             	sub    $0xc,%esp
80103cb7:	68 62 7c 10 80       	push   $0x80107c62
80103cbc:	e8 cf c6 ff ff       	call   80100390 <panic>
80103cc1:	eb 0d                	jmp    80103cd0 <exit>
80103cc3:	90                   	nop
80103cc4:	90                   	nop
80103cc5:	90                   	nop
80103cc6:	90                   	nop
80103cc7:	90                   	nop
80103cc8:	90                   	nop
80103cc9:	90                   	nop
80103cca:	90                   	nop
80103ccb:	90                   	nop
80103ccc:	90                   	nop
80103ccd:	90                   	nop
80103cce:	90                   	nop
80103ccf:	90                   	nop

80103cd0 <exit>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103cd9:	e8 92 0c 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103cde:	e8 2d fb ff ff       	call   80103810 <mycpu>
  p = c->proc;
80103ce3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ce9:	e8 c2 0c 00 00       	call   801049b0 <popcli>
  if(curproc == initproc)
80103cee:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103cf4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103cf7:	8d 7e 68             	lea    0x68(%esi),%edi
80103cfa:	0f 84 fc 00 00 00    	je     80103dfc <exit+0x12c>
    if(curproc->ofile[fd]){
80103d00:	8b 03                	mov    (%ebx),%eax
80103d02:	85 c0                	test   %eax,%eax
80103d04:	74 12                	je     80103d18 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d06:	83 ec 0c             	sub    $0xc,%esp
80103d09:	50                   	push   %eax
80103d0a:	e8 31 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103d0f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d15:	83 c4 10             	add    $0x10,%esp
80103d18:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d1b:	39 fb                	cmp    %edi,%ebx
80103d1d:	75 e1                	jne    80103d00 <exit+0x30>
  begin_op();
80103d1f:	e8 7c ee ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80103d24:	83 ec 0c             	sub    $0xc,%esp
80103d27:	ff 76 68             	pushl  0x68(%esi)
80103d2a:	e8 81 da ff ff       	call   801017b0 <iput>
  end_op();
80103d2f:	e8 dc ee ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80103d34:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d3b:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80103d42:	e8 f9 0c 00 00       	call   80104a40 <acquire>
  wakeup1(curproc->parent);
80103d47:	8b 56 14             	mov    0x14(%esi),%edx
80103d4a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d4d:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
80103d52:	eb 10                	jmp    80103d64 <exit+0x94>
80103d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d58:	05 b0 00 00 00       	add    $0xb0,%eax
80103d5d:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80103d62:	73 1e                	jae    80103d82 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103d64:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d68:	75 ee                	jne    80103d58 <exit+0x88>
80103d6a:	3b 50 20             	cmp    0x20(%eax),%edx
80103d6d:	75 e9                	jne    80103d58 <exit+0x88>
    {  
      p->state = RUNNABLE;
80103d6f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d76:	05 b0 00 00 00       	add    $0xb0,%eax
80103d7b:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80103d80:	72 e2                	jb     80103d64 <exit+0x94>
      pq->parent = initproc;
80103d82:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(pq = ptable.proc; pq < &ptable.proc[NPROC]; pq++){
80103d88:	ba d4 42 11 80       	mov    $0x801142d4,%edx
80103d8d:	eb 0f                	jmp    80103d9e <exit+0xce>
80103d8f:	90                   	nop
80103d90:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80103d96:	81 fa d4 6e 11 80    	cmp    $0x80116ed4,%edx
80103d9c:	73 3a                	jae    80103dd8 <exit+0x108>
    if(pq->parent == curproc){
80103d9e:	39 72 14             	cmp    %esi,0x14(%edx)
80103da1:	75 ed                	jne    80103d90 <exit+0xc0>
      if(pq->state == ZOMBIE)
80103da3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      pq->parent = initproc;
80103da7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(pq->state == ZOMBIE)
80103daa:	75 e4                	jne    80103d90 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dac:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
80103db1:	eb 11                	jmp    80103dc4 <exit+0xf4>
80103db3:	90                   	nop
80103db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103db8:	05 b0 00 00 00       	add    $0xb0,%eax
80103dbd:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80103dc2:	73 cc                	jae    80103d90 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103dc4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dc8:	75 ee                	jne    80103db8 <exit+0xe8>
80103dca:	3b 48 20             	cmp    0x20(%eax),%ecx
80103dcd:	75 e9                	jne    80103db8 <exit+0xe8>
      p->state = RUNNABLE;
80103dcf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dd6:	eb e0                	jmp    80103db8 <exit+0xe8>
  curproc->end_time = ticks;
80103dd8:	a1 20 77 11 80       	mov    0x80117720,%eax
  curproc->state = ZOMBIE;
80103ddd:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  curproc->end_time = ticks;
80103de4:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
  sched();
80103dea:	e8 21 fe ff ff       	call   80103c10 <sched>
  panic("zombie exit");
80103def:	83 ec 0c             	sub    $0xc,%esp
80103df2:	68 9d 7c 10 80       	push   $0x80107c9d
80103df7:	e8 94 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103dfc:	83 ec 0c             	sub    $0xc,%esp
80103dff:	68 90 7c 10 80       	push   $0x80107c90
80103e04:	e8 87 c5 ff ff       	call   80100390 <panic>
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e10 <yield>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
80103e14:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e17:	68 a0 42 11 80       	push   $0x801142a0
80103e1c:	e8 1f 0c 00 00       	call   80104a40 <acquire>
  pushcli();
80103e21:	e8 4a 0b 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103e26:	e8 e5 f9 ff ff       	call   80103810 <mycpu>
  p = c->proc;
80103e2b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e31:	e8 7a 0b 00 00       	call   801049b0 <popcli>
  myproc()->state = RUNNABLE;
80103e36:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
80103e3d:	e8 2e 0b 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103e42:	e8 c9 f9 ff ff       	call   80103810 <mycpu>
  p = c->proc;
80103e47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e4d:	e8 5e 0b 00 00       	call   801049b0 <popcli>
  cprintf("Yield called during process %d\n", myproc() -> pid);
80103e52:	58                   	pop    %eax
80103e53:	5a                   	pop    %edx
80103e54:	ff 73 10             	pushl  0x10(%ebx)
80103e57:	68 38 7d 10 80       	push   $0x80107d38
80103e5c:	e8 ff c7 ff ff       	call   80100660 <cprintf>
  sched();
80103e61:	e8 aa fd ff ff       	call   80103c10 <sched>
  release(&ptable.lock);
80103e66:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80103e6d:	e8 8e 0c 00 00       	call   80104b00 <release>
}
80103e72:	83 c4 10             	add    $0x10,%esp
80103e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e78:	c9                   	leave  
80103e79:	c3                   	ret    
80103e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e80 <sleep>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e8f:	e8 dc 0a 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103e94:	e8 77 f9 ff ff       	call   80103810 <mycpu>
  p = c->proc;
80103e99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e9f:	e8 0c 0b 00 00       	call   801049b0 <popcli>
  if(p == 0)
80103ea4:	85 db                	test   %ebx,%ebx
80103ea6:	0f 84 87 00 00 00    	je     80103f33 <sleep+0xb3>
  if(lk == 0)
80103eac:	85 f6                	test   %esi,%esi
80103eae:	74 76                	je     80103f26 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103eb0:	81 fe a0 42 11 80    	cmp    $0x801142a0,%esi
80103eb6:	74 50                	je     80103f08 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103eb8:	83 ec 0c             	sub    $0xc,%esp
80103ebb:	68 a0 42 11 80       	push   $0x801142a0
80103ec0:	e8 7b 0b 00 00       	call   80104a40 <acquire>
    release(lk);
80103ec5:	89 34 24             	mov    %esi,(%esp)
80103ec8:	e8 33 0c 00 00       	call   80104b00 <release>
  p->chan = chan;
80103ecd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ed0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ed7:	e8 34 fd ff ff       	call   80103c10 <sched>
  p->chan = 0;
80103edc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ee3:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80103eea:	e8 11 0c 00 00       	call   80104b00 <release>
    acquire(lk);
80103eef:	89 75 08             	mov    %esi,0x8(%ebp)
80103ef2:	83 c4 10             	add    $0x10,%esp
}
80103ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ef8:	5b                   	pop    %ebx
80103ef9:	5e                   	pop    %esi
80103efa:	5f                   	pop    %edi
80103efb:	5d                   	pop    %ebp
    acquire(lk);
80103efc:	e9 3f 0b 00 00       	jmp    80104a40 <acquire>
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f08:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f0b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f12:	e8 f9 fc ff ff       	call   80103c10 <sched>
  p->chan = 0;
80103f17:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f21:	5b                   	pop    %ebx
80103f22:	5e                   	pop    %esi
80103f23:	5f                   	pop    %edi
80103f24:	5d                   	pop    %ebp
80103f25:	c3                   	ret    
    panic("sleep without lk");
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	68 af 7c 10 80       	push   $0x80107caf
80103f2e:	e8 5d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f33:	83 ec 0c             	sub    $0xc,%esp
80103f36:	68 a9 7c 10 80       	push   $0x80107ca9
80103f3b:	e8 50 c4 ff ff       	call   80100390 <panic>

80103f40 <wait>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
  pushcli();
80103f45:	e8 26 0a 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103f4a:	e8 c1 f8 ff ff       	call   80103810 <mycpu>
  p = c->proc;
80103f4f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f55:	e8 56 0a 00 00       	call   801049b0 <popcli>
  acquire(&ptable.lock);
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 a0 42 11 80       	push   $0x801142a0
80103f62:	e8 d9 0a 00 00       	call   80104a40 <acquire>
80103f67:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f6a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6c:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
80103f71:	eb 13                	jmp    80103f86 <wait+0x46>
80103f73:	90                   	nop
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f78:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103f7e:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80103f84:	73 1e                	jae    80103fa4 <wait+0x64>
      if(p->parent != curproc)
80103f86:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f89:	75 ed                	jne    80103f78 <wait+0x38>
      if(p->state == ZOMBIE){
80103f8b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f8f:	74 37                	je     80103fc8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f91:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80103f97:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80103fa2:	72 e2                	jb     80103f86 <wait+0x46>
    if(!havekids || curproc->killed){
80103fa4:	85 c0                	test   %eax,%eax
80103fa6:	74 76                	je     8010401e <wait+0xde>
80103fa8:	8b 46 24             	mov    0x24(%esi),%eax
80103fab:	85 c0                	test   %eax,%eax
80103fad:	75 6f                	jne    8010401e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103faf:	83 ec 08             	sub    $0x8,%esp
80103fb2:	68 a0 42 11 80       	push   $0x801142a0
80103fb7:	56                   	push   %esi
80103fb8:	e8 c3 fe ff ff       	call   80103e80 <sleep>
    havekids = 0;
80103fbd:	83 c4 10             	add    $0x10,%esp
80103fc0:	eb a8                	jmp    80103f6a <wait+0x2a>
80103fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103fc8:	83 ec 0c             	sub    $0xc,%esp
80103fcb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103fce:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fd1:	e8 3a e3 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103fd6:	5a                   	pop    %edx
80103fd7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103fda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fe1:	e8 ba 33 00 00       	call   801073a0 <freevm>
        release(&ptable.lock);
80103fe6:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
        p->pid = 0;
80103fed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ff4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ffb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fff:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104006:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010400d:	e8 ee 0a 00 00       	call   80104b00 <release>
        return pid;
80104012:	83 c4 10             	add    $0x10,%esp
}
80104015:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104018:	89 f0                	mov    %esi,%eax
8010401a:	5b                   	pop    %ebx
8010401b:	5e                   	pop    %esi
8010401c:	5d                   	pop    %ebp
8010401d:	c3                   	ret    
      release(&ptable.lock);
8010401e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104021:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104026:	68 a0 42 11 80       	push   $0x801142a0
8010402b:	e8 d0 0a 00 00       	call   80104b00 <release>
      return -1;
80104030:	83 c4 10             	add    $0x10,%esp
80104033:	eb e0                	jmp    80104015 <wait+0xd5>
80104035:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104040 <waitx>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
  pushcli();
80104045:	e8 26 09 00 00       	call   80104970 <pushcli>
  c = mycpu();
8010404a:	e8 c1 f7 ff ff       	call   80103810 <mycpu>
  p = c->proc;
8010404f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104055:	e8 56 09 00 00       	call   801049b0 <popcli>
  acquire(&ptable.lock);
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 a0 42 11 80       	push   $0x801142a0
80104062:	e8 d9 09 00 00       	call   80104a40 <acquire>
80104067:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010406a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010406c:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
80104071:	eb 13                	jmp    80104086 <waitx+0x46>
80104073:	90                   	nop
80104074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104078:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010407e:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80104084:	73 1e                	jae    801040a4 <waitx+0x64>
      if(p->parent != curproc)
80104086:	39 73 14             	cmp    %esi,0x14(%ebx)
80104089:	75 ed                	jne    80104078 <waitx+0x38>
      if(p->state == ZOMBIE){
8010408b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010408f:	74 3f                	je     801040d0 <waitx+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104091:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80104097:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409c:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
801040a2:	72 e2                	jb     80104086 <waitx+0x46>
    if(!havekids || curproc->killed){
801040a4:	85 c0                	test   %eax,%eax
801040a6:	0f 84 99 00 00 00    	je     80104145 <waitx+0x105>
801040ac:	8b 46 24             	mov    0x24(%esi),%eax
801040af:	85 c0                	test   %eax,%eax
801040b1:	0f 85 8e 00 00 00    	jne    80104145 <waitx+0x105>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040b7:	83 ec 08             	sub    $0x8,%esp
801040ba:	68 a0 42 11 80       	push   $0x801142a0
801040bf:	56                   	push   %esi
801040c0:	e8 bb fd ff ff       	call   80103e80 <sleep>
    havekids = 0;
801040c5:	83 c4 10             	add    $0x10,%esp
801040c8:	eb a0                	jmp    8010406a <waitx+0x2a>
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801040d0:	83 ec 0c             	sub    $0xc,%esp
801040d3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040d6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040d9:	e8 32 e2 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
801040de:	5a                   	pop    %edx
801040df:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040e9:	e8 b2 32 00 00       	call   801073a0 <freevm>
        *rtime = p->run_time; // Assignment
801040ee:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
801040f4:	8b 45 0c             	mov    0xc(%ebp),%eax
        p->pid = 0;
801040f7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040fe:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104105:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104109:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104110:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        *rtime = p->run_time; // Assignment
80104117:	89 10                	mov    %edx,(%eax)
        *wtime = (p->end_time - p->start_time) - (p->run_time); // Assignment
80104119:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
8010411f:	2b 53 7c             	sub    0x7c(%ebx),%edx
80104122:	2b 93 84 00 00 00    	sub    0x84(%ebx),%edx
80104128:	8b 45 08             	mov    0x8(%ebp),%eax
8010412b:	89 10                	mov    %edx,(%eax)
        release(&ptable.lock);
8010412d:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
80104134:	e8 c7 09 00 00       	call   80104b00 <release>
        return pid;
80104139:	83 c4 10             	add    $0x10,%esp
}
8010413c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010413f:	89 f0                	mov    %esi,%eax
80104141:	5b                   	pop    %ebx
80104142:	5e                   	pop    %esi
80104143:	5d                   	pop    %ebp
80104144:	c3                   	ret    
      release(&ptable.lock);
80104145:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104148:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010414d:	68 a0 42 11 80       	push   $0x801142a0
80104152:	e8 a9 09 00 00       	call   80104b00 <release>
      return -1;
80104157:	83 c4 10             	add    $0x10,%esp
8010415a:	eb e0                	jmp    8010413c <waitx+0xfc>
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010416a:	68 a0 42 11 80       	push   $0x801142a0
8010416f:	e8 cc 08 00 00       	call   80104a40 <acquire>
80104174:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104177:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
8010417c:	eb 0e                	jmp    8010418c <wakeup+0x2c>
8010417e:	66 90                	xchg   %ax,%ax
80104180:	05 b0 00 00 00       	add    $0xb0,%eax
80104185:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
8010418a:	73 1e                	jae    801041aa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010418c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104190:	75 ee                	jne    80104180 <wakeup+0x20>
80104192:	3b 58 20             	cmp    0x20(%eax),%ebx
80104195:	75 e9                	jne    80104180 <wakeup+0x20>
      p->state = RUNNABLE;
80104197:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419e:	05 b0 00 00 00       	add    $0xb0,%eax
801041a3:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
801041a8:	72 e2                	jb     8010418c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801041aa:	c7 45 08 a0 42 11 80 	movl   $0x801142a0,0x8(%ebp)
}
801041b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b4:	c9                   	leave  
  release(&ptable.lock);
801041b5:	e9 46 09 00 00       	jmp    80104b00 <release>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ca:	68 a0 42 11 80       	push   $0x801142a0
801041cf:	e8 6c 08 00 00       	call   80104a40 <acquire>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d7:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
801041dc:	eb 0e                	jmp    801041ec <kill+0x2c>
801041de:	66 90                	xchg   %ax,%ax
801041e0:	05 b0 00 00 00       	add    $0xb0,%eax
801041e5:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
801041ea:	73 34                	jae    80104220 <kill+0x60>
    if(p->pid == pid){
801041ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801041ef:	75 ef                	jne    801041e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041fc:	75 07                	jne    80104205 <kill+0x45>
        p->state = RUNNABLE;
801041fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104205:	83 ec 0c             	sub    $0xc,%esp
80104208:	68 a0 42 11 80       	push   $0x801142a0
8010420d:	e8 ee 08 00 00       	call   80104b00 <release>
      return 0;
80104212:	83 c4 10             	add    $0x10,%esp
80104215:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010421a:	c9                   	leave  
8010421b:	c3                   	ret    
8010421c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104220:	83 ec 0c             	sub    $0xc,%esp
80104223:	68 a0 42 11 80       	push   $0x801142a0
80104228:	e8 d3 08 00 00       	call   80104b00 <release>
  return -1;
8010422d:	83 c4 10             	add    $0x10,%esp
80104230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104238:	c9                   	leave  
80104239:	c3                   	ret    
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104249:	bb d4 42 11 80       	mov    $0x801142d4,%ebx
{
8010424e:	83 ec 3c             	sub    $0x3c,%esp
80104251:	eb 27                	jmp    8010427a <procdump+0x3a>
80104253:	90                   	nop
80104254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 03 81 10 80       	push   $0x80108103
80104260:	e8 fb c3 ff ff       	call   80100660 <cprintf>
80104265:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104268:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010426e:	81 fb d4 6e 11 80    	cmp    $0x80116ed4,%ebx
80104274:	0f 83 86 00 00 00    	jae    80104300 <procdump+0xc0>
    if(p->state == UNUSED)
8010427a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010427d:	85 c0                	test   %eax,%eax
8010427f:	74 e7                	je     80104268 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104281:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104284:	ba c0 7c 10 80       	mov    $0x80107cc0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104289:	77 11                	ja     8010429c <procdump+0x5c>
8010428b:	8b 14 85 e4 7d 10 80 	mov    -0x7fef821c(,%eax,4),%edx
      state = "???";
80104292:	b8 c0 7c 10 80       	mov    $0x80107cc0,%eax
80104297:	85 d2                	test   %edx,%edx
80104299:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010429c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010429f:	50                   	push   %eax
801042a0:	52                   	push   %edx
801042a1:	ff 73 10             	pushl  0x10(%ebx)
801042a4:	68 c4 7c 10 80       	push   $0x80107cc4
801042a9:	e8 b2 c3 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801042ae:	83 c4 10             	add    $0x10,%esp
801042b1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801042b5:	75 a1                	jne    80104258 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042b7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042ba:	83 ec 08             	sub    $0x8,%esp
801042bd:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042c0:	50                   	push   %eax
801042c1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801042c4:	8b 40 0c             	mov    0xc(%eax),%eax
801042c7:	83 c0 08             	add    $0x8,%eax
801042ca:	50                   	push   %eax
801042cb:	e8 50 06 00 00       	call   80104920 <getcallerpcs>
801042d0:	83 c4 10             	add    $0x10,%esp
801042d3:	90                   	nop
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801042d8:	8b 17                	mov    (%edi),%edx
801042da:	85 d2                	test   %edx,%edx
801042dc:	0f 84 76 ff ff ff    	je     80104258 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042e2:	83 ec 08             	sub    $0x8,%esp
801042e5:	83 c7 04             	add    $0x4,%edi
801042e8:	52                   	push   %edx
801042e9:	68 01 77 10 80       	push   $0x80107701
801042ee:	e8 6d c3 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042f3:	83 c4 10             	add    $0x10,%esp
801042f6:	39 fe                	cmp    %edi,%esi
801042f8:	75 de                	jne    801042d8 <procdump+0x98>
801042fa:	e9 59 ff ff ff       	jmp    80104258 <procdump+0x18>
801042ff:	90                   	nop
  }
}
80104300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104303:	5b                   	pop    %ebx
80104304:	5e                   	pop    %esi
80104305:	5f                   	pop    %edi
80104306:	5d                   	pop    %ebp
80104307:	c3                   	ret    
80104308:	90                   	nop
80104309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104310 <modify_times>:

void modify_times(void)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80104316:	68 a0 42 11 80       	push   $0x801142a0
8010431b:	e8 20 07 00 00       	call   80104a40 <acquire>
80104320:	83 c4 10             	add    $0x10,%esp

  struct proc *p;
	
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104323:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
80104328:	eb 19                	jmp    80104343 <modify_times+0x33>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      #endif
    }

  	else
  	{	
      p->wait_time++;
80104330:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104337:	05 b0 00 00 00       	add    $0xb0,%eax
8010433c:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80104341:	73 19                	jae    8010435c <modify_times+0x4c>
  	if(p -> state == RUNNING)
80104343:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104347:	75 e7                	jne    80104330 <modify_times+0x20>
      p -> run_time++;
80104349:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104350:	05 b0 00 00 00       	add    $0xb0,%eax
80104355:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
8010435a:	72 e7                	jb     80104343 <modify_times+0x33>

      #endif
    }  
  }

  release(&ptable.lock);
8010435c:	83 ec 0c             	sub    $0xc,%esp
8010435f:	68 a0 42 11 80       	push   $0x801142a0
80104364:	e8 97 07 00 00       	call   80104b00 <release>
}
80104369:	83 c4 10             	add    $0x10,%esp
8010436c:	c9                   	leave  
8010436d:	c3                   	ret    
8010436e:	66 90                	xchg   %ax,%ax

80104370 <set_priority>:

int set_priority(int pid, int priority)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 10             	sub    $0x10,%esp
80104377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010437a:	68 a0 42 11 80       	push   $0x801142a0
8010437f:	e8 bc 06 00 00       	call   80104a40 <acquire>
80104384:	83 c4 10             	add    $0x10,%esp

  int old_priority = -1;

  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104387:	ba d4 42 11 80       	mov    $0x801142d4,%edx
8010438c:	eb 10                	jmp    8010439e <set_priority+0x2e>
8010438e:	66 90                	xchg   %ax,%ax
80104390:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80104396:	81 fa d4 6e 11 80    	cmp    $0x80116ed4,%edx
8010439c:	73 32                	jae    801043d0 <set_priority+0x60>
  {
    if(p -> pid == pid)
8010439e:	39 5a 10             	cmp    %ebx,0x10(%edx)
801043a1:	75 ed                	jne    80104390 <set_priority+0x20>
    {
      old_priority = p -> priority;
      p -> priority = priority;
801043a3:	8b 45 0c             	mov    0xc(%ebp),%eax
      old_priority = p -> priority;
801043a6:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
      p -> priority = priority;
801043ac:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)
      break;
    }
  } 
  
  release(&ptable.lock);
801043b2:	83 ec 0c             	sub    $0xc,%esp
801043b5:	68 a0 42 11 80       	push   $0x801142a0
801043ba:	e8 41 07 00 00       	call   80104b00 <release>

  return old_priority;
}
801043bf:	89 d8                	mov    %ebx,%eax
801043c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c4:	c9                   	leave  
801043c5:	c3                   	ret    
801043c6:	8d 76 00             	lea    0x0(%esi),%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int old_priority = -1;
801043d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043d5:	eb db                	jmp    801043b2 <set_priority+0x42>
801043d7:	89 f6                	mov    %esi,%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <isEmpty>:

int isEmpty(int queueNo)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
    if(front[queueNo] == -1) 
801043e3:	8b 45 08             	mov    0x8(%ebp),%eax
    {
      return 1;
    }

    return 0;
}
801043e6:	5d                   	pop    %ebp
    if(front[queueNo] == -1) 
801043e7:	83 3c 85 60 14 11 80 	cmpl   $0xffffffff,-0x7feeeba0(,%eax,4)
801043ee:	ff 
801043ef:	0f 94 c0             	sete   %al
801043f2:	0f b6 c0             	movzbl %al,%eax
}
801043f5:	c3                   	ret    
801043f6:	8d 76 00             	lea    0x0(%esi),%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104400 <isFull>:

int isFull(int queueNo)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	8b 45 08             	mov    0x8(%ebp),%eax
    if((front[queueNo] == rear[queueNo] + 1) || (front[queueNo] == 0 && rear[queueNo] == NPROC-1)) 
80104407:	8b 0c 85 c0 c5 10 80 	mov    -0x7fef3a40(,%eax,4),%ecx
8010440e:	8b 14 85 60 14 11 80 	mov    -0x7feeeba0(,%eax,4),%edx
80104415:	b8 01 00 00 00       	mov    $0x1,%eax
8010441a:	8d 59 01             	lea    0x1(%ecx),%ebx
8010441d:	39 da                	cmp    %ebx,%edx
8010441f:	74 0f                	je     80104430 <isFull+0x30>
80104421:	83 f9 3f             	cmp    $0x3f,%ecx
80104424:	0f 94 c1             	sete   %cl
80104427:	31 c0                	xor    %eax,%eax
80104429:	85 d2                	test   %edx,%edx
8010442b:	0f 94 c0             	sete   %al
    {
      return 1;
8010442e:	21 c8                	and    %ecx,%eax
    }

    return 0;
}
80104430:	5b                   	pop    %ebx
80104431:	5d                   	pop    %ebp
80104432:	c3                   	ret    
80104433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104440 <push>:

void push(int queueNo, struct proc* cur)
{
80104440:	55                   	push   %ebp
80104441:	31 c9                	xor    %ecx,%ecx
80104443:	89 e5                	mov    %esp,%ebp
80104445:	57                   	push   %edi
80104446:	56                   	push   %esi
80104447:	53                   	push   %ebx
  // Check if the element to be pushed already exists in the queue
  for(int i = 0; i < 5; i++)
80104448:	31 ff                	xor    %edi,%edi
{
8010444a:	83 ec 1c             	sub    $0x1c,%esp
8010444d:	8b 45 08             	mov    0x8(%ebp),%eax
80104450:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104453:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  {
    if(front[i] > rear[i])
80104456:	8b 34 bd 60 14 11 80 	mov    -0x7feeeba0(,%edi,4),%esi
8010445d:	8b 14 bd c0 c5 10 80 	mov    -0x7fef3a40(,%edi,4),%edx
80104464:	39 d6                	cmp    %edx,%esi
80104466:	0f 8f c4 00 00 00    	jg     80104530 <push+0xf0>
      }
    }

    else
    {
      for(int j = front[i]; j <= rear[i] && j >= 0; j++)
8010446c:	85 f6                	test   %esi,%esi
8010446e:	78 34                	js     801044a4 <push+0x64>
      {
        if(queue[i][j] == cur)
80104470:	89 f8                	mov    %edi,%eax
80104472:	c1 e0 06             	shl    $0x6,%eax
80104475:	01 f0                	add    %esi,%eax
80104477:	39 1c 85 60 0f 11 80 	cmp    %ebx,-0x7feef0a0(,%eax,4)
8010447e:	0f 84 9a 00 00 00    	je     8010451e <push+0xde>
      for(int j = front[i]; j <= rear[i] && j >= 0; j++)
80104484:	8d 46 01             	lea    0x1(%esi),%eax
80104487:	39 c2                	cmp    %eax,%edx
80104489:	7c 19                	jl     801044a4 <push+0x64>
8010448b:	90                   	nop
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(queue[i][j] == cur)
80104490:	39 9c 81 60 0f 11 80 	cmp    %ebx,-0x7feef0a0(%ecx,%eax,4)
80104497:	0f 84 81 00 00 00    	je     8010451e <push+0xde>
      for(int j = front[i]; j <= rear[i] && j >= 0; j++)
8010449d:	83 c0 01             	add    $0x1,%eax
801044a0:	39 c2                	cmp    %eax,%edx
801044a2:	7d ec                	jge    80104490 <push+0x50>
  for(int i = 0; i < 5; i++)
801044a4:	83 c7 01             	add    $0x1,%edi
801044a7:	81 c1 00 01 00 00    	add    $0x100,%ecx
801044ad:	83 ff 05             	cmp    $0x5,%edi
801044b0:	75 a4                	jne    80104456 <push+0x16>
    if((front[queueNo] == rear[queueNo] + 1) || (front[queueNo] == 0 && rear[queueNo] == NPROC-1)) 
801044b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044b5:	8b 0c 85 c0 c5 10 80 	mov    -0x7fef3a40(,%eax,4),%ecx
801044bc:	8b 14 85 60 14 11 80 	mov    -0x7feeeba0(,%eax,4),%edx
801044c3:	8d 41 01             	lea    0x1(%ecx),%eax
801044c6:	39 c2                	cmp    %eax,%edx
801044c8:	0f 84 a3 00 00 00    	je     80104571 <push+0x131>
801044ce:	85 d2                	test   %edx,%edx
801044d0:	0f 84 8a 00 00 00    	je     80104560 <push+0x120>

  else
  {
    cur -> cur_time = 0;
    
    if(front[queueNo] == -1)
801044d6:	83 fa ff             	cmp    $0xffffffff,%edx
    cur -> cur_time = 0;
801044d9:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801044e0:	00 00 00 
    if(front[queueNo] == -1)
801044e3:	75 0e                	jne    801044f3 <push+0xb3>
    {
      front[queueNo] = 0;
801044e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801044e8:	c7 04 bd 60 14 11 80 	movl   $0x0,-0x7feeeba0(,%edi,4)
801044ef:	00 00 00 00 
    }

    rear[queueNo]++;
    rear[queueNo]%=NPROC;
801044f3:	99                   	cltd   
801044f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801044f7:	c1 ea 1a             	shr    $0x1a,%edx
801044fa:	01 d0                	add    %edx,%eax
801044fc:	83 e0 3f             	and    $0x3f,%eax
    
    queue[queueNo][rear[queueNo]] = cur;
    sz[queueNo]++;
801044ff:	83 04 bd 74 14 11 80 	addl   $0x1,-0x7feeeb8c(,%edi,4)
80104506:	01 
    rear[queueNo]%=NPROC;
80104507:	29 d0                	sub    %edx,%eax
    queue[queueNo][rear[queueNo]] = cur;
80104509:	89 fa                	mov    %edi,%edx
8010450b:	c1 e2 06             	shl    $0x6,%edx
    rear[queueNo]%=NPROC;
8010450e:	89 04 bd c0 c5 10 80 	mov    %eax,-0x7fef3a40(,%edi,4)
    queue[queueNo][rear[queueNo]] = cur;
80104515:	01 d0                	add    %edx,%eax
80104517:	89 1c 85 60 0f 11 80 	mov    %ebx,-0x7feef0a0(,%eax,4)
  }
}
8010451e:	83 c4 1c             	add    $0x1c,%esp
80104521:	5b                   	pop    %ebx
80104522:	5e                   	pop    %esi
80104523:	5f                   	pop    %edi
80104524:	5d                   	pop    %ebp
80104525:	c3                   	ret    
80104526:	8d 76 00             	lea    0x0(%esi),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      for(int j = 0; j < NPROC; j++)
80104530:	31 c0                	xor    %eax,%eax
80104532:	eb 10                	jmp    80104544 <push+0x104>
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104538:	83 c0 01             	add    $0x1,%eax
8010453b:	83 f8 40             	cmp    $0x40,%eax
8010453e:	0f 84 60 ff ff ff    	je     801044a4 <push+0x64>
        if(j >= front[i] || j <= rear[i])
80104544:	39 c6                	cmp    %eax,%esi
80104546:	7e 04                	jle    8010454c <push+0x10c>
80104548:	39 c2                	cmp    %eax,%edx
8010454a:	7c ec                	jl     80104538 <push+0xf8>
          if(queue[i][j] == cur)
8010454c:	39 9c 81 60 0f 11 80 	cmp    %ebx,-0x7feef0a0(%ecx,%eax,4)
80104553:	75 e3                	jne    80104538 <push+0xf8>
}
80104555:	83 c4 1c             	add    $0x1c,%esp
80104558:	5b                   	pop    %ebx
80104559:	5e                   	pop    %esi
8010455a:	5f                   	pop    %edi
8010455b:	5d                   	pop    %ebp
8010455c:	c3                   	ret    
8010455d:	8d 76 00             	lea    0x0(%esi),%esi
    if((front[queueNo] == rear[queueNo] + 1) || (front[queueNo] == 0 && rear[queueNo] == NPROC-1)) 
80104560:	83 f9 3f             	cmp    $0x3f,%ecx
80104563:	74 0c                	je     80104571 <push+0x131>
    cur -> cur_time = 0;
80104565:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
8010456c:	00 00 00 
8010456f:	eb 82                	jmp    801044f3 <push+0xb3>
    cprintf("\n Error: Queue is Full\n");
80104571:	c7 45 08 cd 7c 10 80 	movl   $0x80107ccd,0x8(%ebp)
}
80104578:	83 c4 1c             	add    $0x1c,%esp
8010457b:	5b                   	pop    %ebx
8010457c:	5e                   	pop    %esi
8010457d:	5f                   	pop    %edi
8010457e:	5d                   	pop    %ebp
    cprintf("\n Error: Queue is Full\n");
8010457f:	e9 dc c0 ff ff       	jmp    80100660 <cprintf>
80104584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010458a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104590 <pop>:
struct proc* pop(int queueNo)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct proc* cur = queue[queueNo][front[queueNo]];
80104597:	8b 14 8d 60 14 11 80 	mov    -0x7feeeba0(,%ecx,4),%edx
8010459e:	89 c8                	mov    %ecx,%eax
801045a0:	c1 e0 06             	shl    $0x6,%eax
801045a3:	01 d0                	add    %edx,%eax

  if(front[queueNo] == rear[queueNo])
801045a5:	3b 14 8d c0 c5 10 80 	cmp    -0x7fef3a40(,%ecx,4),%edx
  struct proc* cur = queue[queueNo][front[queueNo]];
801045ac:	8b 04 85 60 0f 11 80 	mov    -0x7feef0a0(,%eax,4),%eax
  if(front[queueNo] == rear[queueNo])
801045b3:	74 2b                	je     801045e0 <pop+0x50>
    rear[queueNo] = -1;
  }

  else
  {
    front[queueNo]++;
801045b5:	83 c2 01             	add    $0x1,%edx
    front[queueNo]%=NPROC;
  }
  
  sz[queueNo]--;
801045b8:	83 2c 8d 74 14 11 80 	subl   $0x1,-0x7feeeb8c(,%ecx,4)
801045bf:	01 
    front[queueNo]%=NPROC;
801045c0:	89 d3                	mov    %edx,%ebx
801045c2:	c1 fb 1f             	sar    $0x1f,%ebx
801045c5:	c1 eb 1a             	shr    $0x1a,%ebx
801045c8:	01 da                	add    %ebx,%edx
801045ca:	83 e2 3f             	and    $0x3f,%edx
801045cd:	29 da                	sub    %ebx,%edx
801045cf:	89 14 8d 60 14 11 80 	mov    %edx,-0x7feeeba0(,%ecx,4)

  return cur;
}
801045d6:	5b                   	pop    %ebx
801045d7:	5d                   	pop    %ebp
801045d8:	c3                   	ret    
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e0:	5b                   	pop    %ebx
    front[queueNo] = -1;
801045e1:	c7 04 8d 60 14 11 80 	movl   $0xffffffff,-0x7feeeba0(,%ecx,4)
801045e8:	ff ff ff ff 
    rear[queueNo] = -1;
801045ec:	c7 04 8d c0 c5 10 80 	movl   $0xffffffff,-0x7fef3a40(,%ecx,4)
801045f3:	ff ff ff ff 
  sz[queueNo]--;
801045f7:	83 2c 8d 74 14 11 80 	subl   $0x1,-0x7feeeb8c(,%ecx,4)
801045fe:	01 
}
801045ff:	5d                   	pop    %ebp
80104600:	c3                   	ret    
80104601:	eb 0d                	jmp    80104610 <getpinfo>
80104603:	90                   	nop
80104604:	90                   	nop
80104605:	90                   	nop
80104606:	90                   	nop
80104607:	90                   	nop
80104608:	90                   	nop
80104609:	90                   	nop
8010460a:	90                   	nop
8010460b:	90                   	nop
8010460c:	90                   	nop
8010460d:	90                   	nop
8010460e:	90                   	nop
8010460f:	90                   	nop

80104610 <getpinfo>:

int getpinfo(int pid, struct proc_stat* pp)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	8b 75 0c             	mov    0xc(%ebp),%esi
80104618:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010461b:	83 ec 0c             	sub    $0xc,%esp
8010461e:	68 a0 42 11 80       	push   $0x801142a0
80104623:	e8 18 04 00 00       	call   80104a40 <acquire>
80104628:	83 c4 10             	add    $0x10,%esp

  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010462b:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
80104630:	eb 12                	jmp    80104644 <getpinfo+0x34>
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104638:	05 b0 00 00 00       	add    $0xb0,%eax
8010463d:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80104642:	73 6c                	jae    801046b0 <getpinfo+0xa0>
  {
    if(p -> pid == pid)
80104644:	39 58 10             	cmp    %ebx,0x10(%eax)
80104647:	75 ef                	jne    80104638 <getpinfo+0x28>
    {
      pp -> pid = p -> pid;
80104649:	89 1e                	mov    %ebx,(%esi)
      pp -> num_run = p -> num_run;
8010464b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
      for(int i = 0; i < 5; i++)
      {
        pp -> ticks[i] = p -> ticks[i];
      }

      release(&ptable.lock);
80104651:	83 ec 0c             	sub    $0xc,%esp
      pp -> num_run = p -> num_run;
80104654:	89 56 08             	mov    %edx,0x8(%esi)
      pp -> current_queue = p -> queueNo;
80104657:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010465d:	89 56 0c             	mov    %edx,0xc(%esi)
      pp -> runtime = p -> run_time;
80104660:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104666:	89 56 04             	mov    %edx,0x4(%esi)
        pp -> ticks[i] = p -> ticks[i];
80104669:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010466f:	89 56 10             	mov    %edx,0x10(%esi)
80104672:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80104678:	89 56 14             	mov    %edx,0x14(%esi)
8010467b:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
80104681:	89 56 18             	mov    %edx,0x18(%esi)
80104684:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010468a:	89 56 1c             	mov    %edx,0x1c(%esi)
8010468d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104693:	89 46 20             	mov    %eax,0x20(%esi)
      release(&ptable.lock);
80104696:	68 a0 42 11 80       	push   $0x801142a0
8010469b:	e8 60 04 00 00       	call   80104b00 <release>
      return 1;
801046a0:	83 c4 10             	add    $0x10,%esp
    }
  }

  release(&ptable.lock);
  return 0;
}
801046a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 1;
801046a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801046ab:	5b                   	pop    %ebx
801046ac:	5e                   	pop    %esi
801046ad:	5d                   	pop    %ebp
801046ae:	c3                   	ret    
801046af:	90                   	nop
  release(&ptable.lock);
801046b0:	83 ec 0c             	sub    $0xc,%esp
801046b3:	68 a0 42 11 80       	push   $0x801142a0
801046b8:	e8 43 04 00 00       	call   80104b00 <release>
  return 0;
801046bd:	83 c4 10             	add    $0x10,%esp
}
801046c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
801046c3:	31 c0                	xor    %eax,%eax
}
801046c5:	5b                   	pop    %ebx
801046c6:	5e                   	pop    %esi
801046c7:	5d                   	pop    %ebp
801046c8:	c3                   	ret    
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046d0 <checkPremption>:

int checkPremption(int priority, int f) 
{ 
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 10             	sub    $0x10,%esp
801046d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046da:	68 a0 42 11 80       	push   $0x801142a0
801046df:	e8 5c 03 00 00       	call   80104a40 <acquire>
  struct proc* p = 0;

  if(!f)
801046e4:	8b 55 0c             	mov    0xc(%ebp),%edx
801046e7:	83 c4 10             	add    $0x10,%esp
  {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
801046ea:	b8 d4 42 11 80       	mov    $0x801142d4,%eax
  if(!f)
801046ef:	85 d2                	test   %edx,%edx
801046f1:	75 59                	jne    8010474c <checkPremption+0x7c>
801046f3:	eb 13                	jmp    80104708 <checkPremption+0x38>
801046f5:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
801046f8:	05 b0 00 00 00       	add    $0xb0,%eax
801046fd:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
80104702:	0f 83 88 00 00 00    	jae    80104790 <checkPremption+0xc0>
    {
      if(p -> pid != 0 && p -> priority < priority) 
80104708:	8b 50 10             	mov    0x10(%eax),%edx
8010470b:	85 d2                	test   %edx,%edx
8010470d:	74 e9                	je     801046f8 <checkPremption+0x28>
8010470f:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
80104715:	39 d9                	cmp    %ebx,%ecx
80104717:	7d df                	jge    801046f8 <checkPremption+0x28>
      {
        cprintf("%d process with higher priority %d than %d found\n", p -> pid, p -> priority, priority);
80104719:	53                   	push   %ebx
8010471a:	51                   	push   %ecx
8010471b:	52                   	push   %edx
8010471c:	68 58 7d 10 80       	push   $0x80107d58
80104721:	e8 3a bf ff ff       	call   80100660 <cprintf>
        release(&ptable.lock);
80104726:	c7 04 24 a0 42 11 80 	movl   $0x801142a0,(%esp)
8010472d:	e8 ce 03 00 00       	call   80104b00 <release>
        return 1;
80104732:	83 c4 10             	add    $0x10,%esp
80104735:	b8 01 00 00 00       	mov    $0x1,%eax
  }

  release(&ptable.lock);

  return 0; 
8010473a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010473d:	c9                   	leave  
8010473e:	c3                   	ret    
8010473f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
80104740:	05 b0 00 00 00       	add    $0xb0,%eax
80104745:	3d d4 6e 11 80       	cmp    $0x80116ed4,%eax
8010474a:	73 44                	jae    80104790 <checkPremption+0xc0>
      if(p -> pid != 0 && p -> priority <= priority) 
8010474c:	8b 50 10             	mov    0x10(%eax),%edx
8010474f:	85 d2                	test   %edx,%edx
80104751:	74 ed                	je     80104740 <checkPremption+0x70>
80104753:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
80104759:	39 d9                	cmp    %ebx,%ecx
8010475b:	7f e3                	jg     80104740 <checkPremption+0x70>
        if(p -> priority == priority)
8010475d:	74 51                	je     801047b0 <checkPremption+0xe0>
          cprintf("%d process with higher priority %d than %d found\n", p -> pid, p -> priority, priority);
8010475f:	53                   	push   %ebx
80104760:	51                   	push   %ecx
80104761:	52                   	push   %edx
80104762:	68 58 7d 10 80       	push   $0x80107d58
80104767:	e8 f4 be ff ff       	call   80100660 <cprintf>
8010476c:	83 c4 10             	add    $0x10,%esp
        release(&ptable.lock);
8010476f:	83 ec 0c             	sub    $0xc,%esp
80104772:	68 a0 42 11 80       	push   $0x801142a0
80104777:	e8 84 03 00 00       	call   80104b00 <release>
        return 1;
8010477c:	83 c4 10             	add    $0x10,%esp
8010477f:	b8 01 00 00 00       	mov    $0x1,%eax
80104784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104787:	c9                   	leave  
80104788:	c3                   	ret    
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104790:	83 ec 0c             	sub    $0xc,%esp
80104793:	68 a0 42 11 80       	push   $0x801142a0
80104798:	e8 63 03 00 00       	call   80104b00 <release>
  return 0; 
8010479d:	83 c4 10             	add    $0x10,%esp
801047a0:	31 c0                	xor    %eax,%eax
801047a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a5:	c9                   	leave  
801047a6:	c3                   	ret    
801047a7:	89 f6                	mov    %esi,%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          cprintf("%d process (Round Robin for Equal Priority) with equal priority %d equal to %d found\n", p -> pid, p -> priority, priority);
801047b0:	53                   	push   %ebx
801047b1:	53                   	push   %ebx
801047b2:	52                   	push   %edx
801047b3:	68 8c 7d 10 80       	push   $0x80107d8c
801047b8:	e8 a3 be ff ff       	call   80100660 <cprintf>
801047bd:	83 c4 10             	add    $0x10,%esp
801047c0:	eb ad                	jmp    8010476f <checkPremption+0x9f>
801047c2:	66 90                	xchg   %ax,%ax
801047c4:	66 90                	xchg   %ax,%ax
801047c6:	66 90                	xchg   %ax,%ax
801047c8:	66 90                	xchg   %ax,%ax
801047ca:	66 90                	xchg   %ax,%ax
801047cc:	66 90                	xchg   %ax,%ax
801047ce:	66 90                	xchg   %ax,%ax

801047d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 0c             	sub    $0xc,%esp
801047d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047da:	68 fc 7d 10 80       	push   $0x80107dfc
801047df:	8d 43 04             	lea    0x4(%ebx),%eax
801047e2:	50                   	push   %eax
801047e3:	e8 18 01 00 00       	call   80104900 <initlock>
  lk->name = name;
801047e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801047f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801047fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801047fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104801:	c9                   	leave  
80104802:	c3                   	ret    
80104803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	8d 73 04             	lea    0x4(%ebx),%esi
8010481e:	56                   	push   %esi
8010481f:	e8 1c 02 00 00       	call   80104a40 <acquire>
  while (lk->locked) {
80104824:	8b 13                	mov    (%ebx),%edx
80104826:	83 c4 10             	add    $0x10,%esp
80104829:	85 d2                	test   %edx,%edx
8010482b:	74 16                	je     80104843 <acquiresleep+0x33>
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104830:	83 ec 08             	sub    $0x8,%esp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	e8 46 f6 ff ff       	call   80103e80 <sleep>
  while (lk->locked) {
8010483a:	8b 03                	mov    (%ebx),%eax
8010483c:	83 c4 10             	add    $0x10,%esp
8010483f:	85 c0                	test   %eax,%eax
80104841:	75 ed                	jne    80104830 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104843:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104849:	e8 62 f0 ff ff       	call   801038b0 <myproc>
8010484e:	8b 40 10             	mov    0x10(%eax),%eax
80104851:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104854:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104857:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010485a:	5b                   	pop    %ebx
8010485b:	5e                   	pop    %esi
8010485c:	5d                   	pop    %ebp
  release(&lk->lk);
8010485d:	e9 9e 02 00 00       	jmp    80104b00 <release>
80104862:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104878:	83 ec 0c             	sub    $0xc,%esp
8010487b:	8d 73 04             	lea    0x4(%ebx),%esi
8010487e:	56                   	push   %esi
8010487f:	e8 bc 01 00 00       	call   80104a40 <acquire>
  lk->locked = 0;
80104884:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010488a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104891:	89 1c 24             	mov    %ebx,(%esp)
80104894:	e8 c7 f8 ff ff       	call   80104160 <wakeup>
  release(&lk->lk);
80104899:	89 75 08             	mov    %esi,0x8(%ebp)
8010489c:	83 c4 10             	add    $0x10,%esp
}
8010489f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a2:	5b                   	pop    %ebx
801048a3:	5e                   	pop    %esi
801048a4:	5d                   	pop    %ebp
  release(&lk->lk);
801048a5:	e9 56 02 00 00       	jmp    80104b00 <release>
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	56                   	push   %esi
801048b5:	53                   	push   %ebx
801048b6:	31 ff                	xor    %edi,%edi
801048b8:	83 ec 18             	sub    $0x18,%esp
801048bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048be:	8d 73 04             	lea    0x4(%ebx),%esi
801048c1:	56                   	push   %esi
801048c2:	e8 79 01 00 00       	call   80104a40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801048c7:	8b 03                	mov    (%ebx),%eax
801048c9:	83 c4 10             	add    $0x10,%esp
801048cc:	85 c0                	test   %eax,%eax
801048ce:	74 13                	je     801048e3 <holdingsleep+0x33>
801048d0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048d3:	e8 d8 ef ff ff       	call   801038b0 <myproc>
801048d8:	39 58 10             	cmp    %ebx,0x10(%eax)
801048db:	0f 94 c0             	sete   %al
801048de:	0f b6 c0             	movzbl %al,%eax
801048e1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801048e3:	83 ec 0c             	sub    $0xc,%esp
801048e6:	56                   	push   %esi
801048e7:	e8 14 02 00 00       	call   80104b00 <release>
  return r;
}
801048ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048ef:	89 f8                	mov    %edi,%eax
801048f1:	5b                   	pop    %ebx
801048f2:	5e                   	pop    %esi
801048f3:	5f                   	pop    %edi
801048f4:	5d                   	pop    %ebp
801048f5:	c3                   	ret    
801048f6:	66 90                	xchg   %ax,%ax
801048f8:	66 90                	xchg   %ax,%ax
801048fa:	66 90                	xchg   %ax,%ax
801048fc:	66 90                	xchg   %ax,%ax
801048fe:	66 90                	xchg   %ax,%ax

80104900 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104906:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010490f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104912:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104919:	5d                   	pop    %ebp
8010491a:	c3                   	ret    
8010491b:	90                   	nop
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104920 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104920:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104921:	31 d2                	xor    %edx,%edx
{
80104923:	89 e5                	mov    %esp,%ebp
80104925:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104926:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010492c:	83 e8 08             	sub    $0x8,%eax
8010492f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104930:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104936:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010493c:	77 1a                	ja     80104958 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010493e:	8b 58 04             	mov    0x4(%eax),%ebx
80104941:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104944:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104947:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104949:	83 fa 0a             	cmp    $0xa,%edx
8010494c:	75 e2                	jne    80104930 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010494e:	5b                   	pop    %ebx
8010494f:	5d                   	pop    %ebp
80104950:	c3                   	ret    
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104958:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010495b:	83 c1 28             	add    $0x28,%ecx
8010495e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104960:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104966:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104969:	39 c1                	cmp    %eax,%ecx
8010496b:	75 f3                	jne    80104960 <getcallerpcs+0x40>
}
8010496d:	5b                   	pop    %ebx
8010496e:	5d                   	pop    %ebp
8010496f:	c3                   	ret    

80104970 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
80104977:	9c                   	pushf  
80104978:	5b                   	pop    %ebx
  asm volatile("cli");
80104979:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010497a:	e8 91 ee ff ff       	call   80103810 <mycpu>
8010497f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104985:	85 c0                	test   %eax,%eax
80104987:	75 11                	jne    8010499a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104989:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010498f:	e8 7c ee ff ff       	call   80103810 <mycpu>
80104994:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010499a:	e8 71 ee ff ff       	call   80103810 <mycpu>
8010499f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049a6:	83 c4 04             	add    $0x4,%esp
801049a9:	5b                   	pop    %ebx
801049aa:	5d                   	pop    %ebp
801049ab:	c3                   	ret    
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049b0 <popcli>:

void
popcli(void)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049b6:	9c                   	pushf  
801049b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049b8:	f6 c4 02             	test   $0x2,%ah
801049bb:	75 35                	jne    801049f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049bd:	e8 4e ee ff ff       	call   80103810 <mycpu>
801049c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049c9:	78 34                	js     801049ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049cb:	e8 40 ee ff ff       	call   80103810 <mycpu>
801049d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049d6:	85 d2                	test   %edx,%edx
801049d8:	74 06                	je     801049e0 <popcli+0x30>
    sti();
}
801049da:	c9                   	leave  
801049db:	c3                   	ret    
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049e0:	e8 2b ee ff ff       	call   80103810 <mycpu>
801049e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049eb:	85 c0                	test   %eax,%eax
801049ed:	74 eb                	je     801049da <popcli+0x2a>
  asm volatile("sti");
801049ef:	fb                   	sti    
}
801049f0:	c9                   	leave  
801049f1:	c3                   	ret    
    panic("popcli - interruptible");
801049f2:	83 ec 0c             	sub    $0xc,%esp
801049f5:	68 07 7e 10 80       	push   $0x80107e07
801049fa:	e8 91 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
801049ff:	83 ec 0c             	sub    $0xc,%esp
80104a02:	68 1e 7e 10 80       	push   $0x80107e1e
80104a07:	e8 84 b9 ff ff       	call   80100390 <panic>
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <holding>:
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	8b 75 08             	mov    0x8(%ebp),%esi
80104a18:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a1a:	e8 51 ff ff ff       	call   80104970 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a1f:	8b 06                	mov    (%esi),%eax
80104a21:	85 c0                	test   %eax,%eax
80104a23:	74 10                	je     80104a35 <holding+0x25>
80104a25:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a28:	e8 e3 ed ff ff       	call   80103810 <mycpu>
80104a2d:	39 c3                	cmp    %eax,%ebx
80104a2f:	0f 94 c3             	sete   %bl
80104a32:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104a35:	e8 76 ff ff ff       	call   801049b0 <popcli>
}
80104a3a:	89 d8                	mov    %ebx,%eax
80104a3c:	5b                   	pop    %ebx
80104a3d:	5e                   	pop    %esi
80104a3e:	5d                   	pop    %ebp
80104a3f:	c3                   	ret    

80104a40 <acquire>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104a45:	e8 26 ff ff ff       	call   80104970 <pushcli>
  if(holding(lk))
80104a4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a4d:	83 ec 0c             	sub    $0xc,%esp
80104a50:	53                   	push   %ebx
80104a51:	e8 ba ff ff ff       	call   80104a10 <holding>
80104a56:	83 c4 10             	add    $0x10,%esp
80104a59:	85 c0                	test   %eax,%eax
80104a5b:	0f 85 83 00 00 00    	jne    80104ae4 <acquire+0xa4>
80104a61:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104a63:	ba 01 00 00 00       	mov    $0x1,%edx
80104a68:	eb 09                	jmp    80104a73 <acquire+0x33>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a73:	89 d0                	mov    %edx,%eax
80104a75:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104a78:	85 c0                	test   %eax,%eax
80104a7a:	75 f4                	jne    80104a70 <acquire+0x30>
  __sync_synchronize();
80104a7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a84:	e8 87 ed ff ff       	call   80103810 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104a89:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104a8c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104a8f:	89 e8                	mov    %ebp,%eax
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a98:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104a9e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104aa4:	77 1a                	ja     80104ac0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104aa6:	8b 48 04             	mov    0x4(%eax),%ecx
80104aa9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104aac:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104aaf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ab1:	83 fe 0a             	cmp    $0xa,%esi
80104ab4:	75 e2                	jne    80104a98 <acquire+0x58>
}
80104ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab9:	5b                   	pop    %ebx
80104aba:	5e                   	pop    %esi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
80104ac0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104ac3:	83 c2 28             	add    $0x28,%edx
80104ac6:	8d 76 00             	lea    0x0(%esi),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ad6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ad9:	39 d0                	cmp    %edx,%eax
80104adb:	75 f3                	jne    80104ad0 <acquire+0x90>
}
80104add:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae0:	5b                   	pop    %ebx
80104ae1:	5e                   	pop    %esi
80104ae2:	5d                   	pop    %ebp
80104ae3:	c3                   	ret    
    panic("acquire");
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	68 25 7e 10 80       	push   $0x80107e25
80104aec:	e8 9f b8 ff ff       	call   80100390 <panic>
80104af1:	eb 0d                	jmp    80104b00 <release>
80104af3:	90                   	nop
80104af4:	90                   	nop
80104af5:	90                   	nop
80104af6:	90                   	nop
80104af7:	90                   	nop
80104af8:	90                   	nop
80104af9:	90                   	nop
80104afa:	90                   	nop
80104afb:	90                   	nop
80104afc:	90                   	nop
80104afd:	90                   	nop
80104afe:	90                   	nop
80104aff:	90                   	nop

80104b00 <release>:
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 10             	sub    $0x10,%esp
80104b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104b0a:	53                   	push   %ebx
80104b0b:	e8 00 ff ff ff       	call   80104a10 <holding>
80104b10:	83 c4 10             	add    $0x10,%esp
80104b13:	85 c0                	test   %eax,%eax
80104b15:	74 22                	je     80104b39 <release+0x39>
  lk->pcs[0] = 0;
80104b17:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b1e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b25:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b2a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b33:	c9                   	leave  
  popcli();
80104b34:	e9 77 fe ff ff       	jmp    801049b0 <popcli>
    panic("release");
80104b39:	83 ec 0c             	sub    $0xc,%esp
80104b3c:	68 2d 7e 10 80       	push   $0x80107e2d
80104b41:	e8 4a b8 ff ff       	call   80100390 <panic>
80104b46:	66 90                	xchg   %ax,%ax
80104b48:	66 90                	xchg   %ax,%ax
80104b4a:	66 90                	xchg   %ax,%ax
80104b4c:	66 90                	xchg   %ax,%ax
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	53                   	push   %ebx
80104b55:	8b 55 08             	mov    0x8(%ebp),%edx
80104b58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b5b:	f6 c2 03             	test   $0x3,%dl
80104b5e:	75 05                	jne    80104b65 <memset+0x15>
80104b60:	f6 c1 03             	test   $0x3,%cl
80104b63:	74 13                	je     80104b78 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104b65:	89 d7                	mov    %edx,%edi
80104b67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b6a:	fc                   	cld    
80104b6b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b6d:	5b                   	pop    %ebx
80104b6e:	89 d0                	mov    %edx,%eax
80104b70:	5f                   	pop    %edi
80104b71:	5d                   	pop    %ebp
80104b72:	c3                   	ret    
80104b73:	90                   	nop
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104b78:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b7c:	c1 e9 02             	shr    $0x2,%ecx
80104b7f:	89 f8                	mov    %edi,%eax
80104b81:	89 fb                	mov    %edi,%ebx
80104b83:	c1 e0 18             	shl    $0x18,%eax
80104b86:	c1 e3 10             	shl    $0x10,%ebx
80104b89:	09 d8                	or     %ebx,%eax
80104b8b:	09 f8                	or     %edi,%eax
80104b8d:	c1 e7 08             	shl    $0x8,%edi
80104b90:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104b92:	89 d7                	mov    %edx,%edi
80104b94:	fc                   	cld    
80104b95:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104b97:	5b                   	pop    %ebx
80104b98:	89 d0                	mov    %edx,%eax
80104b9a:	5f                   	pop    %edi
80104b9b:	5d                   	pop    %ebp
80104b9c:	c3                   	ret    
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ba0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	53                   	push   %ebx
80104ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ba9:	8b 75 08             	mov    0x8(%ebp),%esi
80104bac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104baf:	85 db                	test   %ebx,%ebx
80104bb1:	74 29                	je     80104bdc <memcmp+0x3c>
    if(*s1 != *s2)
80104bb3:	0f b6 16             	movzbl (%esi),%edx
80104bb6:	0f b6 0f             	movzbl (%edi),%ecx
80104bb9:	38 d1                	cmp    %dl,%cl
80104bbb:	75 2b                	jne    80104be8 <memcmp+0x48>
80104bbd:	b8 01 00 00 00       	mov    $0x1,%eax
80104bc2:	eb 14                	jmp    80104bd8 <memcmp+0x38>
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104bcc:	83 c0 01             	add    $0x1,%eax
80104bcf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104bd4:	38 ca                	cmp    %cl,%dl
80104bd6:	75 10                	jne    80104be8 <memcmp+0x48>
  while(n-- > 0){
80104bd8:	39 d8                	cmp    %ebx,%eax
80104bda:	75 ec                	jne    80104bc8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104bdc:	5b                   	pop    %ebx
  return 0;
80104bdd:	31 c0                	xor    %eax,%eax
}
80104bdf:	5e                   	pop    %esi
80104be0:	5f                   	pop    %edi
80104be1:	5d                   	pop    %ebp
80104be2:	c3                   	ret    
80104be3:	90                   	nop
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104be8:	0f b6 c2             	movzbl %dl,%eax
}
80104beb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104bec:	29 c8                	sub    %ecx,%eax
}
80104bee:	5e                   	pop    %esi
80104bef:	5f                   	pop    %edi
80104bf0:	5d                   	pop    %ebp
80104bf1:	c3                   	ret    
80104bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
80104c05:	8b 45 08             	mov    0x8(%ebp),%eax
80104c08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c0b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c0e:	39 c3                	cmp    %eax,%ebx
80104c10:	73 26                	jae    80104c38 <memmove+0x38>
80104c12:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104c15:	39 c8                	cmp    %ecx,%eax
80104c17:	73 1f                	jae    80104c38 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104c19:	85 f6                	test   %esi,%esi
80104c1b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104c1e:	74 0f                	je     80104c2f <memmove+0x2f>
      *--d = *--s;
80104c20:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c24:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104c27:	83 ea 01             	sub    $0x1,%edx
80104c2a:	83 fa ff             	cmp    $0xffffffff,%edx
80104c2d:	75 f1                	jne    80104c20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c2f:	5b                   	pop    %ebx
80104c30:	5e                   	pop    %esi
80104c31:	5d                   	pop    %ebp
80104c32:	c3                   	ret    
80104c33:	90                   	nop
80104c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104c38:	31 d2                	xor    %edx,%edx
80104c3a:	85 f6                	test   %esi,%esi
80104c3c:	74 f1                	je     80104c2f <memmove+0x2f>
80104c3e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104c40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c47:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104c4a:	39 d6                	cmp    %edx,%esi
80104c4c:	75 f2                	jne    80104c40 <memmove+0x40>
}
80104c4e:	5b                   	pop    %ebx
80104c4f:	5e                   	pop    %esi
80104c50:	5d                   	pop    %ebp
80104c51:	c3                   	ret    
80104c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104c63:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104c64:	eb 9a                	jmp    80104c00 <memmove>
80104c66:	8d 76 00             	lea    0x0(%esi),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	8b 7d 10             	mov    0x10(%ebp),%edi
80104c78:	53                   	push   %ebx
80104c79:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104c7f:	85 ff                	test   %edi,%edi
80104c81:	74 2f                	je     80104cb2 <strncmp+0x42>
80104c83:	0f b6 01             	movzbl (%ecx),%eax
80104c86:	0f b6 1e             	movzbl (%esi),%ebx
80104c89:	84 c0                	test   %al,%al
80104c8b:	74 37                	je     80104cc4 <strncmp+0x54>
80104c8d:	38 c3                	cmp    %al,%bl
80104c8f:	75 33                	jne    80104cc4 <strncmp+0x54>
80104c91:	01 f7                	add    %esi,%edi
80104c93:	eb 13                	jmp    80104ca8 <strncmp+0x38>
80104c95:	8d 76 00             	lea    0x0(%esi),%esi
80104c98:	0f b6 01             	movzbl (%ecx),%eax
80104c9b:	84 c0                	test   %al,%al
80104c9d:	74 21                	je     80104cc0 <strncmp+0x50>
80104c9f:	0f b6 1a             	movzbl (%edx),%ebx
80104ca2:	89 d6                	mov    %edx,%esi
80104ca4:	38 d8                	cmp    %bl,%al
80104ca6:	75 1c                	jne    80104cc4 <strncmp+0x54>
    n--, p++, q++;
80104ca8:	8d 56 01             	lea    0x1(%esi),%edx
80104cab:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104cae:	39 fa                	cmp    %edi,%edx
80104cb0:	75 e6                	jne    80104c98 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104cb2:	5b                   	pop    %ebx
    return 0;
80104cb3:	31 c0                	xor    %eax,%eax
}
80104cb5:	5e                   	pop    %esi
80104cb6:	5f                   	pop    %edi
80104cb7:	5d                   	pop    %ebp
80104cb8:	c3                   	ret    
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cc0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104cc4:	29 d8                	sub    %ebx,%eax
}
80104cc6:	5b                   	pop    %ebx
80104cc7:	5e                   	pop    %esi
80104cc8:	5f                   	pop    %edi
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
80104ccb:	90                   	nop
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cd0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
80104cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104cdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cde:	89 c2                	mov    %eax,%edx
80104ce0:	eb 19                	jmp    80104cfb <strncpy+0x2b>
80104ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ce8:	83 c3 01             	add    $0x1,%ebx
80104ceb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104cef:	83 c2 01             	add    $0x1,%edx
80104cf2:	84 c9                	test   %cl,%cl
80104cf4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104cf7:	74 09                	je     80104d02 <strncpy+0x32>
80104cf9:	89 f1                	mov    %esi,%ecx
80104cfb:	85 c9                	test   %ecx,%ecx
80104cfd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104d00:	7f e6                	jg     80104ce8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d02:	31 c9                	xor    %ecx,%ecx
80104d04:	85 f6                	test   %esi,%esi
80104d06:	7e 17                	jle    80104d1f <strncpy+0x4f>
80104d08:	90                   	nop
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d10:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d14:	89 f3                	mov    %esi,%ebx
80104d16:	83 c1 01             	add    $0x1,%ecx
80104d19:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104d1b:	85 db                	test   %ebx,%ebx
80104d1d:	7f f1                	jg     80104d10 <strncpy+0x40>
  return os;
}
80104d1f:	5b                   	pop    %ebx
80104d20:	5e                   	pop    %esi
80104d21:	5d                   	pop    %ebp
80104d22:	c3                   	ret    
80104d23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
80104d35:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d38:	8b 45 08             	mov    0x8(%ebp),%eax
80104d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d3e:	85 c9                	test   %ecx,%ecx
80104d40:	7e 26                	jle    80104d68 <safestrcpy+0x38>
80104d42:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d46:	89 c1                	mov    %eax,%ecx
80104d48:	eb 17                	jmp    80104d61 <safestrcpy+0x31>
80104d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d50:	83 c2 01             	add    $0x1,%edx
80104d53:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d57:	83 c1 01             	add    $0x1,%ecx
80104d5a:	84 db                	test   %bl,%bl
80104d5c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d5f:	74 04                	je     80104d65 <safestrcpy+0x35>
80104d61:	39 f2                	cmp    %esi,%edx
80104d63:	75 eb                	jne    80104d50 <safestrcpy+0x20>
    ;
  *s = 0;
80104d65:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104d68:	5b                   	pop    %ebx
80104d69:	5e                   	pop    %esi
80104d6a:	5d                   	pop    %ebp
80104d6b:	c3                   	ret    
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d70 <strlen>:

int
strlen(const char *s)
{
80104d70:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d71:	31 c0                	xor    %eax,%eax
{
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d78:	80 3a 00             	cmpb   $0x0,(%edx)
80104d7b:	74 0c                	je     80104d89 <strlen+0x19>
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
80104d80:	83 c0 01             	add    $0x1,%eax
80104d83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d87:	75 f7                	jne    80104d80 <strlen+0x10>
    ;
  return n;
}
80104d89:	5d                   	pop    %ebp
80104d8a:	c3                   	ret    

80104d8b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d8b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d8f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d93:	55                   	push   %ebp
  pushl %ebx
80104d94:	53                   	push   %ebx
  pushl %esi
80104d95:	56                   	push   %esi
  pushl %edi
80104d96:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d97:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d99:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d9b:	5f                   	pop    %edi
  popl %esi
80104d9c:	5e                   	pop    %esi
  popl %ebx
80104d9d:	5b                   	pop    %ebx
  popl %ebp
80104d9e:	5d                   	pop    %ebp
  ret
80104d9f:	c3                   	ret    

80104da0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	53                   	push   %ebx
80104da4:	83 ec 04             	sub    $0x4,%esp
80104da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104daa:	e8 01 eb ff ff       	call   801038b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104daf:	8b 00                	mov    (%eax),%eax
80104db1:	39 d8                	cmp    %ebx,%eax
80104db3:	76 1b                	jbe    80104dd0 <fetchint+0x30>
80104db5:	8d 53 04             	lea    0x4(%ebx),%edx
80104db8:	39 d0                	cmp    %edx,%eax
80104dba:	72 14                	jb     80104dd0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dbf:	8b 13                	mov    (%ebx),%edx
80104dc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dc3:	31 c0                	xor    %eax,%eax
}
80104dc5:	83 c4 04             	add    $0x4,%esp
80104dc8:	5b                   	pop    %ebx
80104dc9:	5d                   	pop    %ebp
80104dca:	c3                   	ret    
80104dcb:	90                   	nop
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd5:	eb ee                	jmp    80104dc5 <fetchint+0x25>
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
80104de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dea:	e8 c1 ea ff ff       	call   801038b0 <myproc>

  if(addr >= curproc->sz)
80104def:	39 18                	cmp    %ebx,(%eax)
80104df1:	76 29                	jbe    80104e1c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104df6:	89 da                	mov    %ebx,%edx
80104df8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104dfa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104dfc:	39 c3                	cmp    %eax,%ebx
80104dfe:	73 1c                	jae    80104e1c <fetchstr+0x3c>
    if(*s == 0)
80104e00:	80 3b 00             	cmpb   $0x0,(%ebx)
80104e03:	75 10                	jne    80104e15 <fetchstr+0x35>
80104e05:	eb 39                	jmp    80104e40 <fetchstr+0x60>
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e10:	80 3a 00             	cmpb   $0x0,(%edx)
80104e13:	74 1b                	je     80104e30 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104e15:	83 c2 01             	add    $0x1,%edx
80104e18:	39 d0                	cmp    %edx,%eax
80104e1a:	77 f4                	ja     80104e10 <fetchstr+0x30>
    return -1;
80104e1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104e21:	83 c4 04             	add    $0x4,%esp
80104e24:	5b                   	pop    %ebx
80104e25:	5d                   	pop    %ebp
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e30:	83 c4 04             	add    $0x4,%esp
80104e33:	89 d0                	mov    %edx,%eax
80104e35:	29 d8                	sub    %ebx,%eax
80104e37:	5b                   	pop    %ebx
80104e38:	5d                   	pop    %ebp
80104e39:	c3                   	ret    
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104e40:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104e42:	eb dd                	jmp    80104e21 <fetchstr+0x41>
80104e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e55:	e8 56 ea ff ff       	call   801038b0 <myproc>
80104e5a:	8b 40 18             	mov    0x18(%eax),%eax
80104e5d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e60:	8b 40 44             	mov    0x44(%eax),%eax
80104e63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e66:	e8 45 ea ff ff       	call   801038b0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e6b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e6d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e70:	39 c6                	cmp    %eax,%esi
80104e72:	73 1c                	jae    80104e90 <argint+0x40>
80104e74:	8d 53 08             	lea    0x8(%ebx),%edx
80104e77:	39 d0                	cmp    %edx,%eax
80104e79:	72 15                	jb     80104e90 <argint+0x40>
  *ip = *(int*)(addr);
80104e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e81:	89 10                	mov    %edx,(%eax)
  return 0;
80104e83:	31 c0                	xor    %eax,%eax
}
80104e85:	5b                   	pop    %ebx
80104e86:	5e                   	pop    %esi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e95:	eb ee                	jmp    80104e85 <argint+0x35>
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	83 ec 10             	sub    $0x10,%esp
80104ea8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104eab:	e8 00 ea ff ff       	call   801038b0 <myproc>
80104eb0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104eb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eb5:	83 ec 08             	sub    $0x8,%esp
80104eb8:	50                   	push   %eax
80104eb9:	ff 75 08             	pushl  0x8(%ebp)
80104ebc:	e8 8f ff ff ff       	call   80104e50 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ec1:	83 c4 10             	add    $0x10,%esp
80104ec4:	85 c0                	test   %eax,%eax
80104ec6:	78 28                	js     80104ef0 <argptr+0x50>
80104ec8:	85 db                	test   %ebx,%ebx
80104eca:	78 24                	js     80104ef0 <argptr+0x50>
80104ecc:	8b 16                	mov    (%esi),%edx
80104ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed1:	39 c2                	cmp    %eax,%edx
80104ed3:	76 1b                	jbe    80104ef0 <argptr+0x50>
80104ed5:	01 c3                	add    %eax,%ebx
80104ed7:	39 da                	cmp    %ebx,%edx
80104ed9:	72 15                	jb     80104ef0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104edb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ede:	89 02                	mov    %eax,(%edx)
  return 0;
80104ee0:	31 c0                	xor    %eax,%eax
}
80104ee2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee5:	5b                   	pop    %ebx
80104ee6:	5e                   	pop    %esi
80104ee7:	5d                   	pop    %ebp
80104ee8:	c3                   	ret    
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef5:	eb eb                	jmp    80104ee2 <argptr+0x42>
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f09:	50                   	push   %eax
80104f0a:	ff 75 08             	pushl  0x8(%ebp)
80104f0d:	e8 3e ff ff ff       	call   80104e50 <argint>
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	85 c0                	test   %eax,%eax
80104f17:	78 17                	js     80104f30 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f19:	83 ec 08             	sub    $0x8,%esp
80104f1c:	ff 75 0c             	pushl  0xc(%ebp)
80104f1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f22:	e8 b9 fe ff ff       	call   80104de0 <fetchstr>
80104f27:	83 c4 10             	add    $0x10,%esp
}
80104f2a:	c9                   	leave  
80104f2b:	c3                   	ret    
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f35:	c9                   	leave  
80104f36:	c3                   	ret    
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f40 <syscall>:
[SYS_getpinfo]  sys_getpinfo, 
};

void
syscall(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	53                   	push   %ebx
80104f44:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f47:	e8 64 e9 ff ff       	call   801038b0 <myproc>
80104f4c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f4e:	8b 40 18             	mov    0x18(%eax),%eax
80104f51:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f54:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f57:	83 fa 17             	cmp    $0x17,%edx
80104f5a:	77 1c                	ja     80104f78 <syscall+0x38>
80104f5c:	8b 14 85 60 7e 10 80 	mov    -0x7fef81a0(,%eax,4),%edx
80104f63:	85 d2                	test   %edx,%edx
80104f65:	74 11                	je     80104f78 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104f67:	ff d2                	call   *%edx
80104f69:	8b 53 18             	mov    0x18(%ebx),%edx
80104f6c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f72:	c9                   	leave  
80104f73:	c3                   	ret    
80104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f78:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f79:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f7c:	50                   	push   %eax
80104f7d:	ff 73 10             	pushl  0x10(%ebx)
80104f80:	68 35 7e 10 80       	push   $0x80107e35
80104f85:	e8 d6 b6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104f8a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f9a:	c9                   	leave  
80104f9b:	c3                   	ret    
80104f9c:	66 90                	xchg   %ax,%ax
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	56                   	push   %esi
80104fa5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fa6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104fa9:	83 ec 34             	sub    $0x34,%esp
80104fac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104faf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104fb2:	56                   	push   %esi
80104fb3:	50                   	push   %eax
{
80104fb4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104fb7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104fba:	e8 41 cf ff ff       	call   80101f00 <nameiparent>
80104fbf:	83 c4 10             	add    $0x10,%esp
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	0f 84 46 01 00 00    	je     80105110 <create+0x170>
    return 0;
  ilock(dp);
80104fca:	83 ec 0c             	sub    $0xc,%esp
80104fcd:	89 c3                	mov    %eax,%ebx
80104fcf:	50                   	push   %eax
80104fd0:	e8 ab c6 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fd5:	83 c4 0c             	add    $0xc,%esp
80104fd8:	6a 00                	push   $0x0
80104fda:	56                   	push   %esi
80104fdb:	53                   	push   %ebx
80104fdc:	e8 cf cb ff ff       	call   80101bb0 <dirlookup>
80104fe1:	83 c4 10             	add    $0x10,%esp
80104fe4:	85 c0                	test   %eax,%eax
80104fe6:	89 c7                	mov    %eax,%edi
80104fe8:	74 36                	je     80105020 <create+0x80>
    iunlockput(dp);
80104fea:	83 ec 0c             	sub    $0xc,%esp
80104fed:	53                   	push   %ebx
80104fee:	e8 1d c9 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104ff3:	89 3c 24             	mov    %edi,(%esp)
80104ff6:	e8 85 c6 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ffb:	83 c4 10             	add    $0x10,%esp
80104ffe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105003:	0f 85 97 00 00 00    	jne    801050a0 <create+0x100>
80105009:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010500e:	0f 85 8c 00 00 00    	jne    801050a0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105017:	89 f8                	mov    %edi,%eax
80105019:	5b                   	pop    %ebx
8010501a:	5e                   	pop    %esi
8010501b:	5f                   	pop    %edi
8010501c:	5d                   	pop    %ebp
8010501d:	c3                   	ret    
8010501e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105020:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105024:	83 ec 08             	sub    $0x8,%esp
80105027:	50                   	push   %eax
80105028:	ff 33                	pushl  (%ebx)
8010502a:	e8 e1 c4 ff ff       	call   80101510 <ialloc>
8010502f:	83 c4 10             	add    $0x10,%esp
80105032:	85 c0                	test   %eax,%eax
80105034:	89 c7                	mov    %eax,%edi
80105036:	0f 84 e8 00 00 00    	je     80105124 <create+0x184>
  ilock(ip);
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	50                   	push   %eax
80105040:	e8 3b c6 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105045:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105049:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010504d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105051:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105055:	b8 01 00 00 00       	mov    $0x1,%eax
8010505a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010505e:	89 3c 24             	mov    %edi,(%esp)
80105061:	e8 6a c5 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010506e:	74 50                	je     801050c0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105070:	83 ec 04             	sub    $0x4,%esp
80105073:	ff 77 04             	pushl  0x4(%edi)
80105076:	56                   	push   %esi
80105077:	53                   	push   %ebx
80105078:	e8 a3 cd ff ff       	call   80101e20 <dirlink>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	0f 88 8f 00 00 00    	js     80105117 <create+0x177>
  iunlockput(dp);
80105088:	83 ec 0c             	sub    $0xc,%esp
8010508b:	53                   	push   %ebx
8010508c:	e8 7f c8 ff ff       	call   80101910 <iunlockput>
  return ip;
80105091:	83 c4 10             	add    $0x10,%esp
}
80105094:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105097:	89 f8                	mov    %edi,%eax
80105099:	5b                   	pop    %ebx
8010509a:	5e                   	pop    %esi
8010509b:	5f                   	pop    %edi
8010509c:	5d                   	pop    %ebp
8010509d:	c3                   	ret    
8010509e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	57                   	push   %edi
    return 0;
801050a4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801050a6:	e8 65 c8 ff ff       	call   80101910 <iunlockput>
    return 0;
801050ab:	83 c4 10             	add    $0x10,%esp
}
801050ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050b1:	89 f8                	mov    %edi,%eax
801050b3:	5b                   	pop    %ebx
801050b4:	5e                   	pop    %esi
801050b5:	5f                   	pop    %edi
801050b6:	5d                   	pop    %ebp
801050b7:	c3                   	ret    
801050b8:	90                   	nop
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801050c0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801050c5:	83 ec 0c             	sub    $0xc,%esp
801050c8:	53                   	push   %ebx
801050c9:	e8 02 c5 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050ce:	83 c4 0c             	add    $0xc,%esp
801050d1:	ff 77 04             	pushl  0x4(%edi)
801050d4:	68 e0 7e 10 80       	push   $0x80107ee0
801050d9:	57                   	push   %edi
801050da:	e8 41 cd ff ff       	call   80101e20 <dirlink>
801050df:	83 c4 10             	add    $0x10,%esp
801050e2:	85 c0                	test   %eax,%eax
801050e4:	78 1c                	js     80105102 <create+0x162>
801050e6:	83 ec 04             	sub    $0x4,%esp
801050e9:	ff 73 04             	pushl  0x4(%ebx)
801050ec:	68 df 7e 10 80       	push   $0x80107edf
801050f1:	57                   	push   %edi
801050f2:	e8 29 cd ff ff       	call   80101e20 <dirlink>
801050f7:	83 c4 10             	add    $0x10,%esp
801050fa:	85 c0                	test   %eax,%eax
801050fc:	0f 89 6e ff ff ff    	jns    80105070 <create+0xd0>
      panic("create dots");
80105102:	83 ec 0c             	sub    $0xc,%esp
80105105:	68 d3 7e 10 80       	push   $0x80107ed3
8010510a:	e8 81 b2 ff ff       	call   80100390 <panic>
8010510f:	90                   	nop
    return 0;
80105110:	31 ff                	xor    %edi,%edi
80105112:	e9 fd fe ff ff       	jmp    80105014 <create+0x74>
    panic("create: dirlink");
80105117:	83 ec 0c             	sub    $0xc,%esp
8010511a:	68 e2 7e 10 80       	push   $0x80107ee2
8010511f:	e8 6c b2 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	68 c4 7e 10 80       	push   $0x80107ec4
8010512c:	e8 5f b2 ff ff       	call   80100390 <panic>
80105131:	eb 0d                	jmp    80105140 <argfd.constprop.0>
80105133:	90                   	nop
80105134:	90                   	nop
80105135:	90                   	nop
80105136:	90                   	nop
80105137:	90                   	nop
80105138:	90                   	nop
80105139:	90                   	nop
8010513a:	90                   	nop
8010513b:	90                   	nop
8010513c:	90                   	nop
8010513d:	90                   	nop
8010513e:	90                   	nop
8010513f:	90                   	nop

80105140 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
80105145:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105147:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010514a:	89 d6                	mov    %edx,%esi
8010514c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010514f:	50                   	push   %eax
80105150:	6a 00                	push   $0x0
80105152:	e8 f9 fc ff ff       	call   80104e50 <argint>
80105157:	83 c4 10             	add    $0x10,%esp
8010515a:	85 c0                	test   %eax,%eax
8010515c:	78 2a                	js     80105188 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105162:	77 24                	ja     80105188 <argfd.constprop.0+0x48>
80105164:	e8 47 e7 ff ff       	call   801038b0 <myproc>
80105169:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010516c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105170:	85 c0                	test   %eax,%eax
80105172:	74 14                	je     80105188 <argfd.constprop.0+0x48>
  if(pfd)
80105174:	85 db                	test   %ebx,%ebx
80105176:	74 02                	je     8010517a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105178:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010517a:	89 06                	mov    %eax,(%esi)
  return 0;
8010517c:	31 c0                	xor    %eax,%eax
}
8010517e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105181:	5b                   	pop    %ebx
80105182:	5e                   	pop    %esi
80105183:	5d                   	pop    %ebp
80105184:	c3                   	ret    
80105185:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518d:	eb ef                	jmp    8010517e <argfd.constprop.0+0x3e>
8010518f:	90                   	nop

80105190 <sys_dup>:
{
80105190:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105191:	31 c0                	xor    %eax,%eax
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	56                   	push   %esi
80105196:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105197:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010519a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010519d:	e8 9e ff ff ff       	call   80105140 <argfd.constprop.0>
801051a2:	85 c0                	test   %eax,%eax
801051a4:	78 42                	js     801051e8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801051a6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801051a9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801051ab:	e8 00 e7 ff ff       	call   801038b0 <myproc>
801051b0:	eb 0e                	jmp    801051c0 <sys_dup+0x30>
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801051b8:	83 c3 01             	add    $0x1,%ebx
801051bb:	83 fb 10             	cmp    $0x10,%ebx
801051be:	74 28                	je     801051e8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801051c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051c4:	85 d2                	test   %edx,%edx
801051c6:	75 f0                	jne    801051b8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801051c8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	ff 75 f4             	pushl  -0xc(%ebp)
801051d2:	e8 19 bc ff ff       	call   80100df0 <filedup>
  return fd;
801051d7:	83 c4 10             	add    $0x10,%esp
}
801051da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051dd:	89 d8                	mov    %ebx,%eax
801051df:	5b                   	pop    %ebx
801051e0:	5e                   	pop    %esi
801051e1:	5d                   	pop    %ebp
801051e2:	c3                   	ret    
801051e3:	90                   	nop
801051e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051eb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051f0:	89 d8                	mov    %ebx,%eax
801051f2:	5b                   	pop    %ebx
801051f3:	5e                   	pop    %esi
801051f4:	5d                   	pop    %ebp
801051f5:	c3                   	ret    
801051f6:	8d 76 00             	lea    0x0(%esi),%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_read>:
{
80105200:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105201:	31 c0                	xor    %eax,%eax
{
80105203:	89 e5                	mov    %esp,%ebp
80105205:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105208:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010520b:	e8 30 ff ff ff       	call   80105140 <argfd.constprop.0>
80105210:	85 c0                	test   %eax,%eax
80105212:	78 4c                	js     80105260 <sys_read+0x60>
80105214:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105217:	83 ec 08             	sub    $0x8,%esp
8010521a:	50                   	push   %eax
8010521b:	6a 02                	push   $0x2
8010521d:	e8 2e fc ff ff       	call   80104e50 <argint>
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	85 c0                	test   %eax,%eax
80105227:	78 37                	js     80105260 <sys_read+0x60>
80105229:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010522c:	83 ec 04             	sub    $0x4,%esp
8010522f:	ff 75 f0             	pushl  -0x10(%ebp)
80105232:	50                   	push   %eax
80105233:	6a 01                	push   $0x1
80105235:	e8 66 fc ff ff       	call   80104ea0 <argptr>
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	85 c0                	test   %eax,%eax
8010523f:	78 1f                	js     80105260 <sys_read+0x60>
  return fileread(f, p, n);
80105241:	83 ec 04             	sub    $0x4,%esp
80105244:	ff 75 f0             	pushl  -0x10(%ebp)
80105247:	ff 75 f4             	pushl  -0xc(%ebp)
8010524a:	ff 75 ec             	pushl  -0x14(%ebp)
8010524d:	e8 0e bd ff ff       	call   80100f60 <fileread>
80105252:	83 c4 10             	add    $0x10,%esp
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105270 <sys_write>:
{
80105270:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105271:	31 c0                	xor    %eax,%eax
{
80105273:	89 e5                	mov    %esp,%ebp
80105275:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105278:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010527b:	e8 c0 fe ff ff       	call   80105140 <argfd.constprop.0>
80105280:	85 c0                	test   %eax,%eax
80105282:	78 4c                	js     801052d0 <sys_write+0x60>
80105284:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105287:	83 ec 08             	sub    $0x8,%esp
8010528a:	50                   	push   %eax
8010528b:	6a 02                	push   $0x2
8010528d:	e8 be fb ff ff       	call   80104e50 <argint>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	85 c0                	test   %eax,%eax
80105297:	78 37                	js     801052d0 <sys_write+0x60>
80105299:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529c:	83 ec 04             	sub    $0x4,%esp
8010529f:	ff 75 f0             	pushl  -0x10(%ebp)
801052a2:	50                   	push   %eax
801052a3:	6a 01                	push   $0x1
801052a5:	e8 f6 fb ff ff       	call   80104ea0 <argptr>
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	85 c0                	test   %eax,%eax
801052af:	78 1f                	js     801052d0 <sys_write+0x60>
  return filewrite(f, p, n);
801052b1:	83 ec 04             	sub    $0x4,%esp
801052b4:	ff 75 f0             	pushl  -0x10(%ebp)
801052b7:	ff 75 f4             	pushl  -0xc(%ebp)
801052ba:	ff 75 ec             	pushl  -0x14(%ebp)
801052bd:	e8 2e bd ff ff       	call   80100ff0 <filewrite>
801052c2:	83 c4 10             	add    $0x10,%esp
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_close>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801052e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052ec:	e8 4f fe ff ff       	call   80105140 <argfd.constprop.0>
801052f1:	85 c0                	test   %eax,%eax
801052f3:	78 2b                	js     80105320 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801052f5:	e8 b6 e5 ff ff       	call   801038b0 <myproc>
801052fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052fd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105300:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105307:	00 
  fileclose(f);
80105308:	ff 75 f4             	pushl  -0xc(%ebp)
8010530b:	e8 30 bb ff ff       	call   80100e40 <fileclose>
  return 0;
80105310:	83 c4 10             	add    $0x10,%esp
80105313:	31 c0                	xor    %eax,%eax
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_fstat>:
{
80105330:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105331:	31 c0                	xor    %eax,%eax
{
80105333:	89 e5                	mov    %esp,%ebp
80105335:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105338:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010533b:	e8 00 fe ff ff       	call   80105140 <argfd.constprop.0>
80105340:	85 c0                	test   %eax,%eax
80105342:	78 2c                	js     80105370 <sys_fstat+0x40>
80105344:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105347:	83 ec 04             	sub    $0x4,%esp
8010534a:	6a 14                	push   $0x14
8010534c:	50                   	push   %eax
8010534d:	6a 01                	push   $0x1
8010534f:	e8 4c fb ff ff       	call   80104ea0 <argptr>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	78 15                	js     80105370 <sys_fstat+0x40>
  return filestat(f, st);
8010535b:	83 ec 08             	sub    $0x8,%esp
8010535e:	ff 75 f4             	pushl  -0xc(%ebp)
80105361:	ff 75 f0             	pushl  -0x10(%ebp)
80105364:	e8 a7 bb ff ff       	call   80100f10 <filestat>
80105369:	83 c4 10             	add    $0x10,%esp
}
8010536c:	c9                   	leave  
8010536d:	c3                   	ret    
8010536e:	66 90                	xchg   %ax,%ax
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105375:	c9                   	leave  
80105376:	c3                   	ret    
80105377:	89 f6                	mov    %esi,%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <sys_link>:
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105386:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105389:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010538c:	50                   	push   %eax
8010538d:	6a 00                	push   $0x0
8010538f:	e8 6c fb ff ff       	call   80104f00 <argstr>
80105394:	83 c4 10             	add    $0x10,%esp
80105397:	85 c0                	test   %eax,%eax
80105399:	0f 88 fb 00 00 00    	js     8010549a <sys_link+0x11a>
8010539f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053a2:	83 ec 08             	sub    $0x8,%esp
801053a5:	50                   	push   %eax
801053a6:	6a 01                	push   $0x1
801053a8:	e8 53 fb ff ff       	call   80104f00 <argstr>
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	85 c0                	test   %eax,%eax
801053b2:	0f 88 e2 00 00 00    	js     8010549a <sys_link+0x11a>
  begin_op();
801053b8:	e8 e3 d7 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	ff 75 d4             	pushl  -0x2c(%ebp)
801053c3:	e8 18 cb ff ff       	call   80101ee0 <namei>
801053c8:	83 c4 10             	add    $0x10,%esp
801053cb:	85 c0                	test   %eax,%eax
801053cd:	89 c3                	mov    %eax,%ebx
801053cf:	0f 84 ea 00 00 00    	je     801054bf <sys_link+0x13f>
  ilock(ip);
801053d5:	83 ec 0c             	sub    $0xc,%esp
801053d8:	50                   	push   %eax
801053d9:	e8 a2 c2 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053e6:	0f 84 bb 00 00 00    	je     801054a7 <sys_link+0x127>
  ip->nlink++;
801053ec:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801053f1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801053f4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053f7:	53                   	push   %ebx
801053f8:	e8 d3 c1 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
801053fd:	89 1c 24             	mov    %ebx,(%esp)
80105400:	e8 5b c3 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105405:	58                   	pop    %eax
80105406:	5a                   	pop    %edx
80105407:	57                   	push   %edi
80105408:	ff 75 d0             	pushl  -0x30(%ebp)
8010540b:	e8 f0 ca ff ff       	call   80101f00 <nameiparent>
80105410:	83 c4 10             	add    $0x10,%esp
80105413:	85 c0                	test   %eax,%eax
80105415:	89 c6                	mov    %eax,%esi
80105417:	74 5b                	je     80105474 <sys_link+0xf4>
  ilock(dp);
80105419:	83 ec 0c             	sub    $0xc,%esp
8010541c:	50                   	push   %eax
8010541d:	e8 5e c2 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	8b 03                	mov    (%ebx),%eax
80105427:	39 06                	cmp    %eax,(%esi)
80105429:	75 3d                	jne    80105468 <sys_link+0xe8>
8010542b:	83 ec 04             	sub    $0x4,%esp
8010542e:	ff 73 04             	pushl  0x4(%ebx)
80105431:	57                   	push   %edi
80105432:	56                   	push   %esi
80105433:	e8 e8 c9 ff ff       	call   80101e20 <dirlink>
80105438:	83 c4 10             	add    $0x10,%esp
8010543b:	85 c0                	test   %eax,%eax
8010543d:	78 29                	js     80105468 <sys_link+0xe8>
  iunlockput(dp);
8010543f:	83 ec 0c             	sub    $0xc,%esp
80105442:	56                   	push   %esi
80105443:	e8 c8 c4 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105448:	89 1c 24             	mov    %ebx,(%esp)
8010544b:	e8 60 c3 ff ff       	call   801017b0 <iput>
  end_op();
80105450:	e8 bb d7 ff ff       	call   80102c10 <end_op>
  return 0;
80105455:	83 c4 10             	add    $0x10,%esp
80105458:	31 c0                	xor    %eax,%eax
}
8010545a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010545d:	5b                   	pop    %ebx
8010545e:	5e                   	pop    %esi
8010545f:	5f                   	pop    %edi
80105460:	5d                   	pop    %ebp
80105461:	c3                   	ret    
80105462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105468:	83 ec 0c             	sub    $0xc,%esp
8010546b:	56                   	push   %esi
8010546c:	e8 9f c4 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105471:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105474:	83 ec 0c             	sub    $0xc,%esp
80105477:	53                   	push   %ebx
80105478:	e8 03 c2 ff ff       	call   80101680 <ilock>
  ip->nlink--;
8010547d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105482:	89 1c 24             	mov    %ebx,(%esp)
80105485:	e8 46 c1 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010548a:	89 1c 24             	mov    %ebx,(%esp)
8010548d:	e8 7e c4 ff ff       	call   80101910 <iunlockput>
  end_op();
80105492:	e8 79 d7 ff ff       	call   80102c10 <end_op>
  return -1;
80105497:	83 c4 10             	add    $0x10,%esp
}
8010549a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010549d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a2:	5b                   	pop    %ebx
801054a3:	5e                   	pop    %esi
801054a4:	5f                   	pop    %edi
801054a5:	5d                   	pop    %ebp
801054a6:	c3                   	ret    
    iunlockput(ip);
801054a7:	83 ec 0c             	sub    $0xc,%esp
801054aa:	53                   	push   %ebx
801054ab:	e8 60 c4 ff ff       	call   80101910 <iunlockput>
    end_op();
801054b0:	e8 5b d7 ff ff       	call   80102c10 <end_op>
    return -1;
801054b5:	83 c4 10             	add    $0x10,%esp
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	eb 9b                	jmp    8010545a <sys_link+0xda>
    end_op();
801054bf:	e8 4c d7 ff ff       	call   80102c10 <end_op>
    return -1;
801054c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c9:	eb 8f                	jmp    8010545a <sys_link+0xda>
801054cb:	90                   	nop
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054d0 <sys_unlink>:
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	57                   	push   %edi
801054d4:	56                   	push   %esi
801054d5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801054d6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054d9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801054dc:	50                   	push   %eax
801054dd:	6a 00                	push   $0x0
801054df:	e8 1c fa ff ff       	call   80104f00 <argstr>
801054e4:	83 c4 10             	add    $0x10,%esp
801054e7:	85 c0                	test   %eax,%eax
801054e9:	0f 88 77 01 00 00    	js     80105666 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801054ef:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801054f2:	e8 a9 d6 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054f7:	83 ec 08             	sub    $0x8,%esp
801054fa:	53                   	push   %ebx
801054fb:	ff 75 c0             	pushl  -0x40(%ebp)
801054fe:	e8 fd c9 ff ff       	call   80101f00 <nameiparent>
80105503:	83 c4 10             	add    $0x10,%esp
80105506:	85 c0                	test   %eax,%eax
80105508:	89 c6                	mov    %eax,%esi
8010550a:	0f 84 60 01 00 00    	je     80105670 <sys_unlink+0x1a0>
  ilock(dp);
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	50                   	push   %eax
80105514:	e8 67 c1 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105519:	58                   	pop    %eax
8010551a:	5a                   	pop    %edx
8010551b:	68 e0 7e 10 80       	push   $0x80107ee0
80105520:	53                   	push   %ebx
80105521:	e8 6a c6 ff ff       	call   80101b90 <namecmp>
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	85 c0                	test   %eax,%eax
8010552b:	0f 84 03 01 00 00    	je     80105634 <sys_unlink+0x164>
80105531:	83 ec 08             	sub    $0x8,%esp
80105534:	68 df 7e 10 80       	push   $0x80107edf
80105539:	53                   	push   %ebx
8010553a:	e8 51 c6 ff ff       	call   80101b90 <namecmp>
8010553f:	83 c4 10             	add    $0x10,%esp
80105542:	85 c0                	test   %eax,%eax
80105544:	0f 84 ea 00 00 00    	je     80105634 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010554a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010554d:	83 ec 04             	sub    $0x4,%esp
80105550:	50                   	push   %eax
80105551:	53                   	push   %ebx
80105552:	56                   	push   %esi
80105553:	e8 58 c6 ff ff       	call   80101bb0 <dirlookup>
80105558:	83 c4 10             	add    $0x10,%esp
8010555b:	85 c0                	test   %eax,%eax
8010555d:	89 c3                	mov    %eax,%ebx
8010555f:	0f 84 cf 00 00 00    	je     80105634 <sys_unlink+0x164>
  ilock(ip);
80105565:	83 ec 0c             	sub    $0xc,%esp
80105568:	50                   	push   %eax
80105569:	e8 12 c1 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105576:	0f 8e 10 01 00 00    	jle    8010568c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010557c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105581:	74 6d                	je     801055f0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105583:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105586:	83 ec 04             	sub    $0x4,%esp
80105589:	6a 10                	push   $0x10
8010558b:	6a 00                	push   $0x0
8010558d:	50                   	push   %eax
8010558e:	e8 bd f5 ff ff       	call   80104b50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105593:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105596:	6a 10                	push   $0x10
80105598:	ff 75 c4             	pushl  -0x3c(%ebp)
8010559b:	50                   	push   %eax
8010559c:	56                   	push   %esi
8010559d:	e8 be c4 ff ff       	call   80101a60 <writei>
801055a2:	83 c4 20             	add    $0x20,%esp
801055a5:	83 f8 10             	cmp    $0x10,%eax
801055a8:	0f 85 eb 00 00 00    	jne    80105699 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801055ae:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055b3:	0f 84 97 00 00 00    	je     80105650 <sys_unlink+0x180>
  iunlockput(dp);
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	56                   	push   %esi
801055bd:	e8 4e c3 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
801055c2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055c7:	89 1c 24             	mov    %ebx,(%esp)
801055ca:	e8 01 c0 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801055cf:	89 1c 24             	mov    %ebx,(%esp)
801055d2:	e8 39 c3 ff ff       	call   80101910 <iunlockput>
  end_op();
801055d7:	e8 34 d6 ff ff       	call   80102c10 <end_op>
  return 0;
801055dc:	83 c4 10             	add    $0x10,%esp
801055df:	31 c0                	xor    %eax,%eax
}
801055e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055e4:	5b                   	pop    %ebx
801055e5:	5e                   	pop    %esi
801055e6:	5f                   	pop    %edi
801055e7:	5d                   	pop    %ebp
801055e8:	c3                   	ret    
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055f0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801055f4:	76 8d                	jbe    80105583 <sys_unlink+0xb3>
801055f6:	bf 20 00 00 00       	mov    $0x20,%edi
801055fb:	eb 0f                	jmp    8010560c <sys_unlink+0x13c>
801055fd:	8d 76 00             	lea    0x0(%esi),%esi
80105600:	83 c7 10             	add    $0x10,%edi
80105603:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105606:	0f 83 77 ff ff ff    	jae    80105583 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010560c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010560f:	6a 10                	push   $0x10
80105611:	57                   	push   %edi
80105612:	50                   	push   %eax
80105613:	53                   	push   %ebx
80105614:	e8 47 c3 ff ff       	call   80101960 <readi>
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	83 f8 10             	cmp    $0x10,%eax
8010561f:	75 5e                	jne    8010567f <sys_unlink+0x1af>
    if(de.inum != 0)
80105621:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105626:	74 d8                	je     80105600 <sys_unlink+0x130>
    iunlockput(ip);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	53                   	push   %ebx
8010562c:	e8 df c2 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105631:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105634:	83 ec 0c             	sub    $0xc,%esp
80105637:	56                   	push   %esi
80105638:	e8 d3 c2 ff ff       	call   80101910 <iunlockput>
  end_op();
8010563d:	e8 ce d5 ff ff       	call   80102c10 <end_op>
  return -1;
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010564a:	eb 95                	jmp    801055e1 <sys_unlink+0x111>
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105650:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105655:	83 ec 0c             	sub    $0xc,%esp
80105658:	56                   	push   %esi
80105659:	e8 72 bf ff ff       	call   801015d0 <iupdate>
8010565e:	83 c4 10             	add    $0x10,%esp
80105661:	e9 53 ff ff ff       	jmp    801055b9 <sys_unlink+0xe9>
    return -1;
80105666:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566b:	e9 71 ff ff ff       	jmp    801055e1 <sys_unlink+0x111>
    end_op();
80105670:	e8 9b d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567a:	e9 62 ff ff ff       	jmp    801055e1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010567f:	83 ec 0c             	sub    $0xc,%esp
80105682:	68 04 7f 10 80       	push   $0x80107f04
80105687:	e8 04 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	68 f2 7e 10 80       	push   $0x80107ef2
80105694:	e8 f7 ac ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105699:	83 ec 0c             	sub    $0xc,%esp
8010569c:	68 16 7f 10 80       	push   $0x80107f16
801056a1:	e8 ea ac ff ff       	call   80100390 <panic>
801056a6:	8d 76 00             	lea    0x0(%esi),%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056b0 <sys_open>:

int
sys_open(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
801056b5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801056b9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056bc:	50                   	push   %eax
801056bd:	6a 00                	push   $0x0
801056bf:	e8 3c f8 ff ff       	call   80104f00 <argstr>
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	85 c0                	test   %eax,%eax
801056c9:	0f 88 1d 01 00 00    	js     801057ec <sys_open+0x13c>
801056cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056d2:	83 ec 08             	sub    $0x8,%esp
801056d5:	50                   	push   %eax
801056d6:	6a 01                	push   $0x1
801056d8:	e8 73 f7 ff ff       	call   80104e50 <argint>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	0f 88 04 01 00 00    	js     801057ec <sys_open+0x13c>
    return -1;

  begin_op();
801056e8:	e8 b3 d4 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
801056ed:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801056f1:	0f 85 a9 00 00 00    	jne    801057a0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801056f7:	83 ec 0c             	sub    $0xc,%esp
801056fa:	ff 75 e0             	pushl  -0x20(%ebp)
801056fd:	e8 de c7 ff ff       	call   80101ee0 <namei>
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	85 c0                	test   %eax,%eax
80105707:	89 c6                	mov    %eax,%esi
80105709:	0f 84 b2 00 00 00    	je     801057c1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010570f:	83 ec 0c             	sub    $0xc,%esp
80105712:	50                   	push   %eax
80105713:	e8 68 bf ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105718:	83 c4 10             	add    $0x10,%esp
8010571b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105720:	0f 84 aa 00 00 00    	je     801057d0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105726:	e8 55 b6 ff ff       	call   80100d80 <filealloc>
8010572b:	85 c0                	test   %eax,%eax
8010572d:	89 c7                	mov    %eax,%edi
8010572f:	0f 84 a6 00 00 00    	je     801057db <sys_open+0x12b>
  struct proc *curproc = myproc();
80105735:	e8 76 e1 ff ff       	call   801038b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010573a:	31 db                	xor    %ebx,%ebx
8010573c:	eb 0e                	jmp    8010574c <sys_open+0x9c>
8010573e:	66 90                	xchg   %ax,%ax
80105740:	83 c3 01             	add    $0x1,%ebx
80105743:	83 fb 10             	cmp    $0x10,%ebx
80105746:	0f 84 ac 00 00 00    	je     801057f8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010574c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105750:	85 d2                	test   %edx,%edx
80105752:	75 ec                	jne    80105740 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105754:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105757:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010575b:	56                   	push   %esi
8010575c:	e8 ff bf ff ff       	call   80101760 <iunlock>
  end_op();
80105761:	e8 aa d4 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105766:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010576c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010576f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105772:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105775:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010577c:	89 d0                	mov    %edx,%eax
8010577e:	f7 d0                	not    %eax
80105780:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105783:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105786:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105789:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010578d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105790:	89 d8                	mov    %ebx,%eax
80105792:	5b                   	pop    %ebx
80105793:	5e                   	pop    %esi
80105794:	5f                   	pop    %edi
80105795:	5d                   	pop    %ebp
80105796:	c3                   	ret    
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057a6:	31 c9                	xor    %ecx,%ecx
801057a8:	6a 00                	push   $0x0
801057aa:	ba 02 00 00 00       	mov    $0x2,%edx
801057af:	e8 ec f7 ff ff       	call   80104fa0 <create>
    if(ip == 0){
801057b4:	83 c4 10             	add    $0x10,%esp
801057b7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801057b9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057bb:	0f 85 65 ff ff ff    	jne    80105726 <sys_open+0x76>
      end_op();
801057c1:	e8 4a d4 ff ff       	call   80102c10 <end_op>
      return -1;
801057c6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057cb:	eb c0                	jmp    8010578d <sys_open+0xdd>
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801057d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801057d3:	85 c9                	test   %ecx,%ecx
801057d5:	0f 84 4b ff ff ff    	je     80105726 <sys_open+0x76>
    iunlockput(ip);
801057db:	83 ec 0c             	sub    $0xc,%esp
801057de:	56                   	push   %esi
801057df:	e8 2c c1 ff ff       	call   80101910 <iunlockput>
    end_op();
801057e4:	e8 27 d4 ff ff       	call   80102c10 <end_op>
    return -1;
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057f1:	eb 9a                	jmp    8010578d <sys_open+0xdd>
801057f3:	90                   	nop
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801057f8:	83 ec 0c             	sub    $0xc,%esp
801057fb:	57                   	push   %edi
801057fc:	e8 3f b6 ff ff       	call   80100e40 <fileclose>
80105801:	83 c4 10             	add    $0x10,%esp
80105804:	eb d5                	jmp    801057db <sys_open+0x12b>
80105806:	8d 76 00             	lea    0x0(%esi),%esi
80105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105810 <sys_mkdir>:

int
sys_mkdir(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105816:	e8 85 d3 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010581b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010581e:	83 ec 08             	sub    $0x8,%esp
80105821:	50                   	push   %eax
80105822:	6a 00                	push   $0x0
80105824:	e8 d7 f6 ff ff       	call   80104f00 <argstr>
80105829:	83 c4 10             	add    $0x10,%esp
8010582c:	85 c0                	test   %eax,%eax
8010582e:	78 30                	js     80105860 <sys_mkdir+0x50>
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105836:	31 c9                	xor    %ecx,%ecx
80105838:	6a 00                	push   $0x0
8010583a:	ba 01 00 00 00       	mov    $0x1,%edx
8010583f:	e8 5c f7 ff ff       	call   80104fa0 <create>
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	85 c0                	test   %eax,%eax
80105849:	74 15                	je     80105860 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010584b:	83 ec 0c             	sub    $0xc,%esp
8010584e:	50                   	push   %eax
8010584f:	e8 bc c0 ff ff       	call   80101910 <iunlockput>
  end_op();
80105854:	e8 b7 d3 ff ff       	call   80102c10 <end_op>
  return 0;
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	31 c0                	xor    %eax,%eax
}
8010585e:	c9                   	leave  
8010585f:	c3                   	ret    
    end_op();
80105860:	e8 ab d3 ff ff       	call   80102c10 <end_op>
    return -1;
80105865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010586a:	c9                   	leave  
8010586b:	c3                   	ret    
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_mknod>:

int
sys_mknod(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105876:	e8 25 d3 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010587b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010587e:	83 ec 08             	sub    $0x8,%esp
80105881:	50                   	push   %eax
80105882:	6a 00                	push   $0x0
80105884:	e8 77 f6 ff ff       	call   80104f00 <argstr>
80105889:	83 c4 10             	add    $0x10,%esp
8010588c:	85 c0                	test   %eax,%eax
8010588e:	78 60                	js     801058f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105890:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105893:	83 ec 08             	sub    $0x8,%esp
80105896:	50                   	push   %eax
80105897:	6a 01                	push   $0x1
80105899:	e8 b2 f5 ff ff       	call   80104e50 <argint>
  if((argstr(0, &path)) < 0 ||
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	85 c0                	test   %eax,%eax
801058a3:	78 4b                	js     801058f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a8:	83 ec 08             	sub    $0x8,%esp
801058ab:	50                   	push   %eax
801058ac:	6a 02                	push   $0x2
801058ae:	e8 9d f5 ff ff       	call   80104e50 <argint>
     argint(1, &major) < 0 ||
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	85 c0                	test   %eax,%eax
801058b8:	78 36                	js     801058f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801058ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801058be:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801058c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801058c5:	ba 03 00 00 00       	mov    $0x3,%edx
801058ca:	50                   	push   %eax
801058cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058ce:	e8 cd f6 ff ff       	call   80104fa0 <create>
801058d3:	83 c4 10             	add    $0x10,%esp
801058d6:	85 c0                	test   %eax,%eax
801058d8:	74 16                	je     801058f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058da:	83 ec 0c             	sub    $0xc,%esp
801058dd:	50                   	push   %eax
801058de:	e8 2d c0 ff ff       	call   80101910 <iunlockput>
  end_op();
801058e3:	e8 28 d3 ff ff       	call   80102c10 <end_op>
  return 0;
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	31 c0                	xor    %eax,%eax
}
801058ed:	c9                   	leave  
801058ee:	c3                   	ret    
801058ef:	90                   	nop
    end_op();
801058f0:	e8 1b d3 ff ff       	call   80102c10 <end_op>
    return -1;
801058f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058fa:	c9                   	leave  
801058fb:	c3                   	ret    
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_chdir>:

int
sys_chdir(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	56                   	push   %esi
80105904:	53                   	push   %ebx
80105905:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105908:	e8 a3 df ff ff       	call   801038b0 <myproc>
8010590d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010590f:	e8 8c d2 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105914:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105917:	83 ec 08             	sub    $0x8,%esp
8010591a:	50                   	push   %eax
8010591b:	6a 00                	push   $0x0
8010591d:	e8 de f5 ff ff       	call   80104f00 <argstr>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	78 77                	js     801059a0 <sys_chdir+0xa0>
80105929:	83 ec 0c             	sub    $0xc,%esp
8010592c:	ff 75 f4             	pushl  -0xc(%ebp)
8010592f:	e8 ac c5 ff ff       	call   80101ee0 <namei>
80105934:	83 c4 10             	add    $0x10,%esp
80105937:	85 c0                	test   %eax,%eax
80105939:	89 c3                	mov    %eax,%ebx
8010593b:	74 63                	je     801059a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	50                   	push   %eax
80105941:	e8 3a bd ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105946:	83 c4 10             	add    $0x10,%esp
80105949:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010594e:	75 30                	jne    80105980 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	53                   	push   %ebx
80105954:	e8 07 be ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105959:	58                   	pop    %eax
8010595a:	ff 76 68             	pushl  0x68(%esi)
8010595d:	e8 4e be ff ff       	call   801017b0 <iput>
  end_op();
80105962:	e8 a9 d2 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105967:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010596a:	83 c4 10             	add    $0x10,%esp
8010596d:	31 c0                	xor    %eax,%eax
}
8010596f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105972:	5b                   	pop    %ebx
80105973:	5e                   	pop    %esi
80105974:	5d                   	pop    %ebp
80105975:	c3                   	ret    
80105976:	8d 76 00             	lea    0x0(%esi),%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	53                   	push   %ebx
80105984:	e8 87 bf ff ff       	call   80101910 <iunlockput>
    end_op();
80105989:	e8 82 d2 ff ff       	call   80102c10 <end_op>
    return -1;
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105996:	eb d7                	jmp    8010596f <sys_chdir+0x6f>
80105998:	90                   	nop
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801059a0:	e8 6b d2 ff ff       	call   80102c10 <end_op>
    return -1;
801059a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059aa:	eb c3                	jmp    8010596f <sys_chdir+0x6f>
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_exec>:

int
sys_exec(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059b6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801059bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059c2:	50                   	push   %eax
801059c3:	6a 00                	push   $0x0
801059c5:	e8 36 f5 ff ff       	call   80104f00 <argstr>
801059ca:	83 c4 10             	add    $0x10,%esp
801059cd:	85 c0                	test   %eax,%eax
801059cf:	0f 88 87 00 00 00    	js     80105a5c <sys_exec+0xac>
801059d5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801059db:	83 ec 08             	sub    $0x8,%esp
801059de:	50                   	push   %eax
801059df:	6a 01                	push   $0x1
801059e1:	e8 6a f4 ff ff       	call   80104e50 <argint>
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	85 c0                	test   %eax,%eax
801059eb:	78 6f                	js     80105a5c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801059ed:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801059f3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801059f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801059f8:	68 80 00 00 00       	push   $0x80
801059fd:	6a 00                	push   $0x0
801059ff:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a05:	50                   	push   %eax
80105a06:	e8 45 f1 ff ff       	call   80104b50 <memset>
80105a0b:	83 c4 10             	add    $0x10,%esp
80105a0e:	eb 2c                	jmp    80105a3c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105a10:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a16:	85 c0                	test   %eax,%eax
80105a18:	74 56                	je     80105a70 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a1a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a20:	83 ec 08             	sub    $0x8,%esp
80105a23:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a26:	52                   	push   %edx
80105a27:	50                   	push   %eax
80105a28:	e8 b3 f3 ff ff       	call   80104de0 <fetchstr>
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	85 c0                	test   %eax,%eax
80105a32:	78 28                	js     80105a5c <sys_exec+0xac>
  for(i=0;; i++){
80105a34:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a37:	83 fb 20             	cmp    $0x20,%ebx
80105a3a:	74 20                	je     80105a5c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a3c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a42:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a49:	83 ec 08             	sub    $0x8,%esp
80105a4c:	57                   	push   %edi
80105a4d:	01 f0                	add    %esi,%eax
80105a4f:	50                   	push   %eax
80105a50:	e8 4b f3 ff ff       	call   80104da0 <fetchint>
80105a55:	83 c4 10             	add    $0x10,%esp
80105a58:	85 c0                	test   %eax,%eax
80105a5a:	79 b4                	jns    80105a10 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a64:	5b                   	pop    %ebx
80105a65:	5e                   	pop    %esi
80105a66:	5f                   	pop    %edi
80105a67:	5d                   	pop    %ebp
80105a68:	c3                   	ret    
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105a70:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a76:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105a79:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a80:	00 00 00 00 
  return exec(path, argv);
80105a84:	50                   	push   %eax
80105a85:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105a8b:	e8 80 af ff ff       	call   80100a10 <exec>
80105a90:	83 c4 10             	add    $0x10,%esp
}
80105a93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a96:	5b                   	pop    %ebx
80105a97:	5e                   	pop    %esi
80105a98:	5f                   	pop    %edi
80105a99:	5d                   	pop    %ebp
80105a9a:	c3                   	ret    
80105a9b:	90                   	nop
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105aa0 <sys_pipe>:

int
sys_pipe(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105aa6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105aa9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105aac:	6a 08                	push   $0x8
80105aae:	50                   	push   %eax
80105aaf:	6a 00                	push   $0x0
80105ab1:	e8 ea f3 ff ff       	call   80104ea0 <argptr>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	0f 88 ae 00 00 00    	js     80105b6f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ac1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ac4:	83 ec 08             	sub    $0x8,%esp
80105ac7:	50                   	push   %eax
80105ac8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105acb:	50                   	push   %eax
80105acc:	e8 af d7 ff ff       	call   80103280 <pipealloc>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	0f 88 93 00 00 00    	js     80105b6f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105adc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105adf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ae1:	e8 ca dd ff ff       	call   801038b0 <myproc>
80105ae6:	eb 10                	jmp    80105af8 <sys_pipe+0x58>
80105ae8:	90                   	nop
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105af0:	83 c3 01             	add    $0x1,%ebx
80105af3:	83 fb 10             	cmp    $0x10,%ebx
80105af6:	74 60                	je     80105b58 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105af8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105afc:	85 f6                	test   %esi,%esi
80105afe:	75 f0                	jne    80105af0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105b00:	8d 73 08             	lea    0x8(%ebx),%esi
80105b03:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b0a:	e8 a1 dd ff ff       	call   801038b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b0f:	31 d2                	xor    %edx,%edx
80105b11:	eb 0d                	jmp    80105b20 <sys_pipe+0x80>
80105b13:	90                   	nop
80105b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b18:	83 c2 01             	add    $0x1,%edx
80105b1b:	83 fa 10             	cmp    $0x10,%edx
80105b1e:	74 28                	je     80105b48 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105b20:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b24:	85 c9                	test   %ecx,%ecx
80105b26:	75 f0                	jne    80105b18 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105b28:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105b2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b2f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b31:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b34:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b37:	31 c0                	xor    %eax,%eax
}
80105b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b3c:	5b                   	pop    %ebx
80105b3d:	5e                   	pop    %esi
80105b3e:	5f                   	pop    %edi
80105b3f:	5d                   	pop    %ebp
80105b40:	c3                   	ret    
80105b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105b48:	e8 63 dd ff ff       	call   801038b0 <myproc>
80105b4d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b54:	00 
80105b55:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	ff 75 e0             	pushl  -0x20(%ebp)
80105b5e:	e8 dd b2 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105b63:	58                   	pop    %eax
80105b64:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b67:	e8 d4 b2 ff ff       	call   80100e40 <fileclose>
    return -1;
80105b6c:	83 c4 10             	add    $0x10,%esp
80105b6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b74:	eb c3                	jmp    80105b39 <sys_pipe+0x99>
80105b76:	66 90                	xchg   %ax,%ax
80105b78:	66 90                	xchg   %ax,%ax
80105b7a:	66 90                	xchg   %ax,%ax
80105b7c:	66 90                	xchg   %ax,%ax
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <sys_fork>:
#include "proc.h"
#include "proc_stat.h"

int
sys_fork(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b83:	5d                   	pop    %ebp
  return fork();
80105b84:	e9 c7 de ff ff       	jmp    80103a50 <fork>
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_exit>:

int
sys_exit(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b96:	e8 35 e1 ff ff       	call   80103cd0 <exit>
  return 0;  // not reached
}
80105b9b:	31 c0                	xor    %eax,%eax
80105b9d:	c9                   	leave  
80105b9e:	c3                   	ret    
80105b9f:	90                   	nop

80105ba0 <sys_wait>:

int
sys_wait(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ba3:	5d                   	pop    %ebp
  return wait();
80105ba4:	e9 97 e3 ff ff       	jmp    80103f40 <wait>
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <sys_kill>:

int
sys_kill(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bb9:	50                   	push   %eax
80105bba:	6a 00                	push   $0x0
80105bbc:	e8 8f f2 ff ff       	call   80104e50 <argint>
80105bc1:	83 c4 10             	add    $0x10,%esp
80105bc4:	85 c0                	test   %eax,%eax
80105bc6:	78 18                	js     80105be0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bc8:	83 ec 0c             	sub    $0xc,%esp
80105bcb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bce:	e8 ed e5 ff ff       	call   801041c0 <kill>
80105bd3:	83 c4 10             	add    $0x10,%esp
}
80105bd6:	c9                   	leave  
80105bd7:	c3                   	ret    
80105bd8:	90                   	nop
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be5:	c9                   	leave  
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <sys_getpid>:

int
sys_getpid(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105bf6:	e8 b5 dc ff ff       	call   801038b0 <myproc>
80105bfb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105bfe:	c9                   	leave  
80105bff:	c3                   	ret    

80105c00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c0a:	50                   	push   %eax
80105c0b:	6a 00                	push   $0x0
80105c0d:	e8 3e f2 ff ff       	call   80104e50 <argint>
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	85 c0                	test   %eax,%eax
80105c17:	78 27                	js     80105c40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c19:	e8 92 dc ff ff       	call   801038b0 <myproc>
  if(growproc(n) < 0)
80105c1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c21:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c23:	ff 75 f4             	pushl  -0xc(%ebp)
80105c26:	e8 a5 dd ff ff       	call   801039d0 <growproc>
80105c2b:	83 c4 10             	add    $0x10,%esp
80105c2e:	85 c0                	test   %eax,%eax
80105c30:	78 0e                	js     80105c40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c32:	89 d8                	mov    %ebx,%eax
80105c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c37:	c9                   	leave  
80105c38:	c3                   	ret    
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c45:	eb eb                	jmp    80105c32 <sys_sbrk+0x32>
80105c47:	89 f6                	mov    %esi,%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c50 <sys_sleep>:

int
sys_sleep(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c5a:	50                   	push   %eax
80105c5b:	6a 00                	push   $0x0
80105c5d:	e8 ee f1 ff ff       	call   80104e50 <argint>
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	0f 88 8a 00 00 00    	js     80105cf7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c6d:	83 ec 0c             	sub    $0xc,%esp
80105c70:	68 e0 6e 11 80       	push   $0x80116ee0
80105c75:	e8 c6 ed ff ff       	call   80104a40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c7d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105c80:	8b 1d 20 77 11 80    	mov    0x80117720,%ebx
  while(ticks - ticks0 < n){
80105c86:	85 d2                	test   %edx,%edx
80105c88:	75 27                	jne    80105cb1 <sys_sleep+0x61>
80105c8a:	eb 54                	jmp    80105ce0 <sys_sleep+0x90>
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c90:	83 ec 08             	sub    $0x8,%esp
80105c93:	68 e0 6e 11 80       	push   $0x80116ee0
80105c98:	68 20 77 11 80       	push   $0x80117720
80105c9d:	e8 de e1 ff ff       	call   80103e80 <sleep>
  while(ticks - ticks0 < n){
80105ca2:	a1 20 77 11 80       	mov    0x80117720,%eax
80105ca7:	83 c4 10             	add    $0x10,%esp
80105caa:	29 d8                	sub    %ebx,%eax
80105cac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105caf:	73 2f                	jae    80105ce0 <sys_sleep+0x90>
    if(myproc()->killed){
80105cb1:	e8 fa db ff ff       	call   801038b0 <myproc>
80105cb6:	8b 40 24             	mov    0x24(%eax),%eax
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	74 d3                	je     80105c90 <sys_sleep+0x40>
      release(&tickslock);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	68 e0 6e 11 80       	push   $0x80116ee0
80105cc5:	e8 36 ee ff ff       	call   80104b00 <release>
      return -1;
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cd5:	c9                   	leave  
80105cd6:	c3                   	ret    
80105cd7:	89 f6                	mov    %esi,%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	68 e0 6e 11 80       	push   $0x80116ee0
80105ce8:	e8 13 ee ff ff       	call   80104b00 <release>
  return 0;
80105ced:	83 c4 10             	add    $0x10,%esp
80105cf0:	31 c0                	xor    %eax,%eax
}
80105cf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    
    return -1;
80105cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfc:	eb f4                	jmp    80105cf2 <sys_sleep+0xa2>
80105cfe:	66 90                	xchg   %ax,%ax

80105d00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	53                   	push   %ebx
80105d04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d07:	68 e0 6e 11 80       	push   $0x80116ee0
80105d0c:	e8 2f ed ff ff       	call   80104a40 <acquire>
  xticks = ticks;
80105d11:	8b 1d 20 77 11 80    	mov    0x80117720,%ebx
  release(&tickslock);
80105d17:	c7 04 24 e0 6e 11 80 	movl   $0x80116ee0,(%esp)
80105d1e:	e8 dd ed ff ff       	call   80104b00 <release>
  return xticks;
}
80105d23:	89 d8                	mov    %ebx,%eax
80105d25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d28:	c9                   	leave  
80105d29:	c3                   	ret    
80105d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d30 <sys_waitx>:

// Assignment
int sys_waitx(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime, *rtime;

  if(argptr(0, (char **)&wtime, sizeof(int)) < 0)
80105d36:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d39:	6a 04                	push   $0x4
80105d3b:	50                   	push   %eax
80105d3c:	6a 00                	push   $0x0
80105d3e:	e8 5d f1 ff ff       	call   80104ea0 <argptr>
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	85 c0                	test   %eax,%eax
80105d48:	78 2e                	js     80105d78 <sys_waitx+0x48>
  {
    return -1;
  }

  if(argptr(1, (char **)&rtime, sizeof(int)) < 0)
80105d4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d4d:	83 ec 04             	sub    $0x4,%esp
80105d50:	6a 04                	push   $0x4
80105d52:	50                   	push   %eax
80105d53:	6a 01                	push   $0x1
80105d55:	e8 46 f1 ff ff       	call   80104ea0 <argptr>
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	85 c0                	test   %eax,%eax
80105d5f:	78 17                	js     80105d78 <sys_waitx+0x48>
  {
    return -1;
  }

  return waitx(wtime, rtime);
80105d61:	83 ec 08             	sub    $0x8,%esp
80105d64:	ff 75 f4             	pushl  -0xc(%ebp)
80105d67:	ff 75 f0             	pushl  -0x10(%ebp)
80105d6a:	e8 d1 e2 ff ff       	call   80104040 <waitx>
80105d6f:	83 c4 10             	add    $0x10,%esp
}
80105d72:	c9                   	leave  
80105d73:	c3                   	ret    
80105d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d7d:	c9                   	leave  
80105d7e:	c3                   	ret    
80105d7f:	90                   	nop

80105d80 <sys_set_priority>:

int sys_set_priority(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 20             	sub    $0x20,%esp
  int new_priority;
  int pid;

  if(argint(0, &pid) < 0)
80105d86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d89:	50                   	push   %eax
80105d8a:	6a 00                	push   $0x0
80105d8c:	e8 bf f0 ff ff       	call   80104e50 <argint>
80105d91:	83 c4 10             	add    $0x10,%esp
80105d94:	85 c0                	test   %eax,%eax
80105d96:	78 28                	js     80105dc0 <sys_set_priority+0x40>
  {
    return -1;
  }

  if(argint(1, &new_priority) < 0)
80105d98:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d9b:	83 ec 08             	sub    $0x8,%esp
80105d9e:	50                   	push   %eax
80105d9f:	6a 01                	push   $0x1
80105da1:	e8 aa f0 ff ff       	call   80104e50 <argint>
80105da6:	83 c4 10             	add    $0x10,%esp
80105da9:	85 c0                	test   %eax,%eax
80105dab:	78 13                	js     80105dc0 <sys_set_priority+0x40>
  {
    return -1;
  }

  return set_priority(pid, new_priority);
80105dad:	83 ec 08             	sub    $0x8,%esp
80105db0:	ff 75 f0             	pushl  -0x10(%ebp)
80105db3:	ff 75 f4             	pushl  -0xc(%ebp)
80105db6:	e8 b5 e5 ff ff       	call   80104370 <set_priority>
80105dbb:	83 c4 10             	add    $0x10,%esp
}
80105dbe:	c9                   	leave  
80105dbf:	c3                   	ret    
    return -1;
80105dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dc5:	c9                   	leave  
80105dc6:	c3                   	ret    
80105dc7:	89 f6                	mov    %esi,%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dd0 <sys_getpinfo>:

int sys_getpinfo(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	83 ec 20             	sub    $0x20,%esp
    int pid;
    struct proc_stat* stat;

    if(argint(0, &pid) < 0)
80105dd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dd9:	50                   	push   %eax
80105dda:	6a 00                	push   $0x0
80105ddc:	e8 6f f0 ff ff       	call   80104e50 <argint>
80105de1:	83 c4 10             	add    $0x10,%esp
80105de4:	85 c0                	test   %eax,%eax
80105de6:	78 30                	js     80105e18 <sys_getpinfo+0x48>
    {
        return -1;
    }

    if(argptr(1, (char**)&stat, sizeof(struct proc_stat)) < 0)
80105de8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105deb:	83 ec 04             	sub    $0x4,%esp
80105dee:	6a 24                	push   $0x24
80105df0:	50                   	push   %eax
80105df1:	6a 01                	push   $0x1
80105df3:	e8 a8 f0 ff ff       	call   80104ea0 <argptr>
80105df8:	83 c4 10             	add    $0x10,%esp
80105dfb:	85 c0                	test   %eax,%eax
80105dfd:	78 19                	js     80105e18 <sys_getpinfo+0x48>
    {
        return -1;
    }
    
    return getpinfo(pid, stat);
80105dff:	83 ec 08             	sub    $0x8,%esp
80105e02:	ff 75 f4             	pushl  -0xc(%ebp)
80105e05:	ff 75 f0             	pushl  -0x10(%ebp)
80105e08:	e8 03 e8 ff ff       	call   80104610 <getpinfo>
80105e0d:	83 c4 10             	add    $0x10,%esp
}
80105e10:	c9                   	leave  
80105e11:	c3                   	ret    
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80105e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e1d:	c9                   	leave  
80105e1e:	c3                   	ret    

80105e1f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e1f:	1e                   	push   %ds
  pushl %es
80105e20:	06                   	push   %es
  pushl %fs
80105e21:	0f a0                	push   %fs
  pushl %gs
80105e23:	0f a8                	push   %gs
  pushal
80105e25:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e26:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e2a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e2c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e2e:	54                   	push   %esp
  call trap
80105e2f:	e8 cc 00 00 00       	call   80105f00 <trap>
  addl $4, %esp
80105e34:	83 c4 04             	add    $0x4,%esp

80105e37 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e37:	61                   	popa   
  popl %gs
80105e38:	0f a9                	pop    %gs
  popl %fs
80105e3a:	0f a1                	pop    %fs
  popl %es
80105e3c:	07                   	pop    %es
  popl %ds
80105e3d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e3e:	83 c4 08             	add    $0x8,%esp
  iret
80105e41:	cf                   	iret   
80105e42:	66 90                	xchg   %ax,%ax
80105e44:	66 90                	xchg   %ax,%ax
80105e46:	66 90                	xchg   %ax,%ax
80105e48:	66 90                	xchg   %ax,%ax
80105e4a:	66 90                	xchg   %ax,%ax
80105e4c:	66 90                	xchg   %ax,%ax
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e51:	31 c0                	xor    %eax,%eax
{
80105e53:	89 e5                	mov    %esp,%ebp
80105e55:	83 ec 08             	sub    $0x8,%esp
80105e58:	90                   	nop
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e67:	c7 04 c5 22 6f 11 80 	movl   $0x8e000008,-0x7fee90de(,%eax,8)
80105e6e:	08 00 00 8e 
80105e72:	66 89 14 c5 20 6f 11 	mov    %dx,-0x7fee90e0(,%eax,8)
80105e79:	80 
80105e7a:	c1 ea 10             	shr    $0x10,%edx
80105e7d:	66 89 14 c5 26 6f 11 	mov    %dx,-0x7fee90da(,%eax,8)
80105e84:	80 
  for(i = 0; i < 256; i++)
80105e85:	83 c0 01             	add    $0x1,%eax
80105e88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e8d:	75 d1                	jne    80105e60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e8f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105e94:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e97:	c7 05 22 71 11 80 08 	movl   $0xef000008,0x80117122
80105e9e:	00 00 ef 
  initlock(&tickslock, "time");
80105ea1:	68 25 7f 10 80       	push   $0x80107f25
80105ea6:	68 e0 6e 11 80       	push   $0x80116ee0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105eab:	66 a3 20 71 11 80    	mov    %ax,0x80117120
80105eb1:	c1 e8 10             	shr    $0x10,%eax
80105eb4:	66 a3 26 71 11 80    	mov    %ax,0x80117126
  initlock(&tickslock, "time");
80105eba:	e8 41 ea ff ff       	call   80104900 <initlock>
}
80105ebf:	83 c4 10             	add    $0x10,%esp
80105ec2:	c9                   	leave  
80105ec3:	c3                   	ret    
80105ec4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105eca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ed0 <idtinit>:

void
idtinit(void)
{
80105ed0:	55                   	push   %ebp
  pd[0] = size-1;
80105ed1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ed6:	89 e5                	mov    %esp,%ebp
80105ed8:	83 ec 10             	sub    $0x10,%esp
80105edb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105edf:	b8 20 6f 11 80       	mov    $0x80116f20,%eax
80105ee4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ee8:	c1 e8 10             	shr    $0x10,%eax
80105eeb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105eef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ef2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ef5:	c9                   	leave  
80105ef6:	c3                   	ret    
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	57                   	push   %edi
80105f04:	56                   	push   %esi
80105f05:	53                   	push   %ebx
80105f06:	83 ec 1c             	sub    $0x1c,%esp
80105f09:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f0c:	8b 47 30             	mov    0x30(%edi),%eax
80105f0f:	83 f8 40             	cmp    $0x40,%eax
80105f12:	0f 84 f0 00 00 00    	je     80106008 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f18:	83 e8 20             	sub    $0x20,%eax
80105f1b:	83 f8 1f             	cmp    $0x1f,%eax
80105f1e:	77 10                	ja     80105f30 <trap+0x30>
80105f20:	ff 24 85 cc 7f 10 80 	jmp    *-0x7fef8034(,%eax,4)
80105f27:	89 f6                	mov    %esi,%esi
80105f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f30:	e8 7b d9 ff ff       	call   801038b0 <myproc>
80105f35:	85 c0                	test   %eax,%eax
80105f37:	8b 5f 38             	mov    0x38(%edi),%ebx
80105f3a:	0f 84 19 02 00 00    	je     80106159 <trap+0x259>
80105f40:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105f44:	0f 84 0f 02 00 00    	je     80106159 <trap+0x259>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f4a:	0f 20 d1             	mov    %cr2,%ecx
80105f4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f50:	e8 3b d9 ff ff       	call   80103890 <cpuid>
80105f55:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f58:	8b 47 34             	mov    0x34(%edi),%eax
80105f5b:	8b 77 30             	mov    0x30(%edi),%esi
80105f5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f61:	e8 4a d9 ff ff       	call   801038b0 <myproc>
80105f66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f69:	e8 42 d9 ff ff       	call   801038b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f74:	51                   	push   %ecx
80105f75:	53                   	push   %ebx
80105f76:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105f77:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f7a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f7d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f7e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f81:	52                   	push   %edx
80105f82:	ff 70 10             	pushl  0x10(%eax)
80105f85:	68 88 7f 10 80       	push   $0x80107f88
80105f8a:	e8 d1 a6 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f8f:	83 c4 20             	add    $0x20,%esp
80105f92:	e8 19 d9 ff ff       	call   801038b0 <myproc>
80105f97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f9e:	e8 0d d9 ff ff       	call   801038b0 <myproc>
80105fa3:	85 c0                	test   %eax,%eax
80105fa5:	74 1d                	je     80105fc4 <trap+0xc4>
80105fa7:	e8 04 d9 ff ff       	call   801038b0 <myproc>
80105fac:	8b 50 24             	mov    0x24(%eax),%edx
80105faf:	85 d2                	test   %edx,%edx
80105fb1:	74 11                	je     80105fc4 <trap+0xc4>
80105fb3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fb7:	83 e0 03             	and    $0x3,%eax
80105fba:	66 83 f8 03          	cmp    $0x3,%ax
80105fbe:	0f 84 4c 01 00 00    	je     80106110 <trap+0x210>
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  #ifndef FCFS

    #ifdef ROUND_ROBIN
    if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105fc4:	e8 e7 d8 ff ff       	call   801038b0 <myproc>
80105fc9:	85 c0                	test   %eax,%eax
80105fcb:	74 0b                	je     80105fd8 <trap+0xd8>
80105fcd:	e8 de d8 ff ff       	call   801038b0 <myproc>
80105fd2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105fd6:	74 68                	je     80106040 <trap+0x140>

    #endif
    #endif

    // Check if the process has been killed since we yielded
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fd8:	e8 d3 d8 ff ff       	call   801038b0 <myproc>
80105fdd:	85 c0                	test   %eax,%eax
80105fdf:	74 19                	je     80105ffa <trap+0xfa>
80105fe1:	e8 ca d8 ff ff       	call   801038b0 <myproc>
80105fe6:	8b 40 24             	mov    0x24(%eax),%eax
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	74 0d                	je     80105ffa <trap+0xfa>
80105fed:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ff1:	83 e0 03             	and    $0x3,%eax
80105ff4:	66 83 f8 03          	cmp    $0x3,%ax
80105ff8:	74 37                	je     80106031 <trap+0x131>
      exit();
  
  #endif
}
80105ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ffd:	5b                   	pop    %ebx
80105ffe:	5e                   	pop    %esi
80105fff:	5f                   	pop    %edi
80106000:	5d                   	pop    %ebp
80106001:	c3                   	ret    
80106002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106008:	e8 a3 d8 ff ff       	call   801038b0 <myproc>
8010600d:	8b 58 24             	mov    0x24(%eax),%ebx
80106010:	85 db                	test   %ebx,%ebx
80106012:	0f 85 e8 00 00 00    	jne    80106100 <trap+0x200>
    myproc()->tf = tf;
80106018:	e8 93 d8 ff ff       	call   801038b0 <myproc>
8010601d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106020:	e8 1b ef ff ff       	call   80104f40 <syscall>
    if(myproc()->killed)
80106025:	e8 86 d8 ff ff       	call   801038b0 <myproc>
8010602a:	8b 48 24             	mov    0x24(%eax),%ecx
8010602d:	85 c9                	test   %ecx,%ecx
8010602f:	74 c9                	je     80105ffa <trap+0xfa>
}
80106031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106034:	5b                   	pop    %ebx
80106035:	5e                   	pop    %esi
80106036:	5f                   	pop    %edi
80106037:	5d                   	pop    %ebp
      exit();
80106038:	e9 93 dc ff ff       	jmp    80103cd0 <exit>
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106040:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106044:	75 92                	jne    80105fd8 <trap+0xd8>
      yield();
80106046:	e8 c5 dd ff ff       	call   80103e10 <yield>
8010604b:	eb 8b                	jmp    80105fd8 <trap+0xd8>
8010604d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106050:	e8 3b d8 ff ff       	call   80103890 <cpuid>
80106055:	85 c0                	test   %eax,%eax
80106057:	0f 84 c3 00 00 00    	je     80106120 <trap+0x220>
    lapiceoi();
8010605d:	e8 ee c6 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106062:	e8 49 d8 ff ff       	call   801038b0 <myproc>
80106067:	85 c0                	test   %eax,%eax
80106069:	0f 85 38 ff ff ff    	jne    80105fa7 <trap+0xa7>
8010606f:	e9 50 ff ff ff       	jmp    80105fc4 <trap+0xc4>
80106074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106078:	e8 93 c5 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
8010607d:	e8 ce c6 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106082:	e8 29 d8 ff ff       	call   801038b0 <myproc>
80106087:	85 c0                	test   %eax,%eax
80106089:	0f 85 18 ff ff ff    	jne    80105fa7 <trap+0xa7>
8010608f:	e9 30 ff ff ff       	jmp    80105fc4 <trap+0xc4>
80106094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106098:	e8 63 02 00 00       	call   80106300 <uartintr>
    lapiceoi();
8010609d:	e8 ae c6 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060a2:	e8 09 d8 ff ff       	call   801038b0 <myproc>
801060a7:	85 c0                	test   %eax,%eax
801060a9:	0f 85 f8 fe ff ff    	jne    80105fa7 <trap+0xa7>
801060af:	e9 10 ff ff ff       	jmp    80105fc4 <trap+0xc4>
801060b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060b8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801060bc:	8b 77 38             	mov    0x38(%edi),%esi
801060bf:	e8 cc d7 ff ff       	call   80103890 <cpuid>
801060c4:	56                   	push   %esi
801060c5:	53                   	push   %ebx
801060c6:	50                   	push   %eax
801060c7:	68 30 7f 10 80       	push   $0x80107f30
801060cc:	e8 8f a5 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801060d1:	e8 7a c6 ff ff       	call   80102750 <lapiceoi>
    break;
801060d6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060d9:	e8 d2 d7 ff ff       	call   801038b0 <myproc>
801060de:	85 c0                	test   %eax,%eax
801060e0:	0f 85 c1 fe ff ff    	jne    80105fa7 <trap+0xa7>
801060e6:	e9 d9 fe ff ff       	jmp    80105fc4 <trap+0xc4>
801060eb:	90                   	nop
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801060f0:	e8 8b bf ff ff       	call   80102080 <ideintr>
801060f5:	e9 63 ff ff ff       	jmp    8010605d <trap+0x15d>
801060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106100:	e8 cb db ff ff       	call   80103cd0 <exit>
80106105:	e9 0e ff ff ff       	jmp    80106018 <trap+0x118>
8010610a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106110:	e8 bb db ff ff       	call   80103cd0 <exit>
80106115:	e9 aa fe ff ff       	jmp    80105fc4 <trap+0xc4>
8010611a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106120:	83 ec 0c             	sub    $0xc,%esp
80106123:	68 e0 6e 11 80       	push   $0x80116ee0
80106128:	e8 13 e9 ff ff       	call   80104a40 <acquire>
      ticks++;
8010612d:	83 05 20 77 11 80 01 	addl   $0x1,0x80117720
      modify_times();
80106134:	e8 d7 e1 ff ff       	call   80104310 <modify_times>
      wakeup(&ticks);
80106139:	c7 04 24 20 77 11 80 	movl   $0x80117720,(%esp)
80106140:	e8 1b e0 ff ff       	call   80104160 <wakeup>
      release(&tickslock);
80106145:	c7 04 24 e0 6e 11 80 	movl   $0x80116ee0,(%esp)
8010614c:	e8 af e9 ff ff       	call   80104b00 <release>
80106151:	83 c4 10             	add    $0x10,%esp
80106154:	e9 04 ff ff ff       	jmp    8010605d <trap+0x15d>
80106159:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010615c:	e8 2f d7 ff ff       	call   80103890 <cpuid>
80106161:	83 ec 0c             	sub    $0xc,%esp
80106164:	56                   	push   %esi
80106165:	53                   	push   %ebx
80106166:	50                   	push   %eax
80106167:	ff 77 30             	pushl  0x30(%edi)
8010616a:	68 54 7f 10 80       	push   $0x80107f54
8010616f:	e8 ec a4 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106174:	83 c4 14             	add    $0x14,%esp
80106177:	68 2a 7f 10 80       	push   $0x80107f2a
8010617c:	e8 0f a2 ff ff       	call   80100390 <panic>
80106181:	66 90                	xchg   %ax,%ax
80106183:	66 90                	xchg   %ax,%ax
80106185:	66 90                	xchg   %ax,%ax
80106187:	66 90                	xchg   %ax,%ax
80106189:	66 90                	xchg   %ax,%ax
8010618b:	66 90                	xchg   %ax,%ax
8010618d:	66 90                	xchg   %ax,%ax
8010618f:	90                   	nop

80106190 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106190:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106195:	55                   	push   %ebp
80106196:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106198:	85 c0                	test   %eax,%eax
8010619a:	74 1c                	je     801061b8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010619c:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061a1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801061a2:	a8 01                	test   $0x1,%al
801061a4:	74 12                	je     801061b8 <uartgetc+0x28>
801061a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061ab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801061ac:	0f b6 c0             	movzbl %al,%eax
}
801061af:	5d                   	pop    %ebp
801061b0:	c3                   	ret    
801061b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801061b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061bd:	5d                   	pop    %ebp
801061be:	c3                   	ret    
801061bf:	90                   	nop

801061c0 <uartputc.part.0>:
uartputc(int c)
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	57                   	push   %edi
801061c4:	56                   	push   %esi
801061c5:	53                   	push   %ebx
801061c6:	89 c7                	mov    %eax,%edi
801061c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801061d2:	83 ec 0c             	sub    $0xc,%esp
801061d5:	eb 1b                	jmp    801061f2 <uartputc.part.0+0x32>
801061d7:	89 f6                	mov    %esi,%esi
801061d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801061e0:	83 ec 0c             	sub    $0xc,%esp
801061e3:	6a 0a                	push   $0xa
801061e5:	e8 86 c5 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	83 eb 01             	sub    $0x1,%ebx
801061f0:	74 07                	je     801061f9 <uartputc.part.0+0x39>
801061f2:	89 f2                	mov    %esi,%edx
801061f4:	ec                   	in     (%dx),%al
801061f5:	a8 20                	test   $0x20,%al
801061f7:	74 e7                	je     801061e0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061fe:	89 f8                	mov    %edi,%eax
80106200:	ee                   	out    %al,(%dx)
}
80106201:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106204:	5b                   	pop    %ebx
80106205:	5e                   	pop    %esi
80106206:	5f                   	pop    %edi
80106207:	5d                   	pop    %ebp
80106208:	c3                   	ret    
80106209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106210 <uartinit>:
{
80106210:	55                   	push   %ebp
80106211:	31 c9                	xor    %ecx,%ecx
80106213:	89 c8                	mov    %ecx,%eax
80106215:	89 e5                	mov    %esp,%ebp
80106217:	57                   	push   %edi
80106218:	56                   	push   %esi
80106219:	53                   	push   %ebx
8010621a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010621f:	89 da                	mov    %ebx,%edx
80106221:	83 ec 0c             	sub    $0xc,%esp
80106224:	ee                   	out    %al,(%dx)
80106225:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010622a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010622f:	89 fa                	mov    %edi,%edx
80106231:	ee                   	out    %al,(%dx)
80106232:	b8 0c 00 00 00       	mov    $0xc,%eax
80106237:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010623c:	ee                   	out    %al,(%dx)
8010623d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106242:	89 c8                	mov    %ecx,%eax
80106244:	89 f2                	mov    %esi,%edx
80106246:	ee                   	out    %al,(%dx)
80106247:	b8 03 00 00 00       	mov    $0x3,%eax
8010624c:	89 fa                	mov    %edi,%edx
8010624e:	ee                   	out    %al,(%dx)
8010624f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106254:	89 c8                	mov    %ecx,%eax
80106256:	ee                   	out    %al,(%dx)
80106257:	b8 01 00 00 00       	mov    $0x1,%eax
8010625c:	89 f2                	mov    %esi,%edx
8010625e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010625f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106264:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106265:	3c ff                	cmp    $0xff,%al
80106267:	74 5a                	je     801062c3 <uartinit+0xb3>
  uart = 1;
80106269:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106270:	00 00 00 
80106273:	89 da                	mov    %ebx,%edx
80106275:	ec                   	in     (%dx),%al
80106276:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010627b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010627c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010627f:	bb 4c 80 10 80       	mov    $0x8010804c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106284:	6a 00                	push   $0x0
80106286:	6a 04                	push   $0x4
80106288:	e8 43 c0 ff ff       	call   801022d0 <ioapicenable>
8010628d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106290:	b8 78 00 00 00       	mov    $0x78,%eax
80106295:	eb 13                	jmp    801062aa <uartinit+0x9a>
80106297:	89 f6                	mov    %esi,%esi
80106299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801062a0:	83 c3 01             	add    $0x1,%ebx
801062a3:	0f be 03             	movsbl (%ebx),%eax
801062a6:	84 c0                	test   %al,%al
801062a8:	74 19                	je     801062c3 <uartinit+0xb3>
  if(!uart)
801062aa:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801062b0:	85 d2                	test   %edx,%edx
801062b2:	74 ec                	je     801062a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801062b4:	83 c3 01             	add    $0x1,%ebx
801062b7:	e8 04 ff ff ff       	call   801061c0 <uartputc.part.0>
801062bc:	0f be 03             	movsbl (%ebx),%eax
801062bf:	84 c0                	test   %al,%al
801062c1:	75 e7                	jne    801062aa <uartinit+0x9a>
}
801062c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c6:	5b                   	pop    %ebx
801062c7:	5e                   	pop    %esi
801062c8:	5f                   	pop    %edi
801062c9:	5d                   	pop    %ebp
801062ca:	c3                   	ret    
801062cb:	90                   	nop
801062cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062d0 <uartputc>:
  if(!uart)
801062d0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801062d6:	55                   	push   %ebp
801062d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801062d9:	85 d2                	test   %edx,%edx
{
801062db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801062de:	74 10                	je     801062f0 <uartputc+0x20>
}
801062e0:	5d                   	pop    %ebp
801062e1:	e9 da fe ff ff       	jmp    801061c0 <uartputc.part.0>
801062e6:	8d 76 00             	lea    0x0(%esi),%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801062f0:	5d                   	pop    %ebp
801062f1:	c3                   	ret    
801062f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106300 <uartintr>:

void
uartintr(void)
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106306:	68 90 61 10 80       	push   $0x80106190
8010630b:	e8 00 a5 ff ff       	call   80100810 <consoleintr>
}
80106310:	83 c4 10             	add    $0x10,%esp
80106313:	c9                   	leave  
80106314:	c3                   	ret    

80106315 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $0
80106317:	6a 00                	push   $0x0
  jmp alltraps
80106319:	e9 01 fb ff ff       	jmp    80105e1f <alltraps>

8010631e <vector1>:
.globl vector1
vector1:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $1
80106320:	6a 01                	push   $0x1
  jmp alltraps
80106322:	e9 f8 fa ff ff       	jmp    80105e1f <alltraps>

80106327 <vector2>:
.globl vector2
vector2:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $2
80106329:	6a 02                	push   $0x2
  jmp alltraps
8010632b:	e9 ef fa ff ff       	jmp    80105e1f <alltraps>

80106330 <vector3>:
.globl vector3
vector3:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $3
80106332:	6a 03                	push   $0x3
  jmp alltraps
80106334:	e9 e6 fa ff ff       	jmp    80105e1f <alltraps>

80106339 <vector4>:
.globl vector4
vector4:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $4
8010633b:	6a 04                	push   $0x4
  jmp alltraps
8010633d:	e9 dd fa ff ff       	jmp    80105e1f <alltraps>

80106342 <vector5>:
.globl vector5
vector5:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $5
80106344:	6a 05                	push   $0x5
  jmp alltraps
80106346:	e9 d4 fa ff ff       	jmp    80105e1f <alltraps>

8010634b <vector6>:
.globl vector6
vector6:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $6
8010634d:	6a 06                	push   $0x6
  jmp alltraps
8010634f:	e9 cb fa ff ff       	jmp    80105e1f <alltraps>

80106354 <vector7>:
.globl vector7
vector7:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $7
80106356:	6a 07                	push   $0x7
  jmp alltraps
80106358:	e9 c2 fa ff ff       	jmp    80105e1f <alltraps>

8010635d <vector8>:
.globl vector8
vector8:
  pushl $8
8010635d:	6a 08                	push   $0x8
  jmp alltraps
8010635f:	e9 bb fa ff ff       	jmp    80105e1f <alltraps>

80106364 <vector9>:
.globl vector9
vector9:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $9
80106366:	6a 09                	push   $0x9
  jmp alltraps
80106368:	e9 b2 fa ff ff       	jmp    80105e1f <alltraps>

8010636d <vector10>:
.globl vector10
vector10:
  pushl $10
8010636d:	6a 0a                	push   $0xa
  jmp alltraps
8010636f:	e9 ab fa ff ff       	jmp    80105e1f <alltraps>

80106374 <vector11>:
.globl vector11
vector11:
  pushl $11
80106374:	6a 0b                	push   $0xb
  jmp alltraps
80106376:	e9 a4 fa ff ff       	jmp    80105e1f <alltraps>

8010637b <vector12>:
.globl vector12
vector12:
  pushl $12
8010637b:	6a 0c                	push   $0xc
  jmp alltraps
8010637d:	e9 9d fa ff ff       	jmp    80105e1f <alltraps>

80106382 <vector13>:
.globl vector13
vector13:
  pushl $13
80106382:	6a 0d                	push   $0xd
  jmp alltraps
80106384:	e9 96 fa ff ff       	jmp    80105e1f <alltraps>

80106389 <vector14>:
.globl vector14
vector14:
  pushl $14
80106389:	6a 0e                	push   $0xe
  jmp alltraps
8010638b:	e9 8f fa ff ff       	jmp    80105e1f <alltraps>

80106390 <vector15>:
.globl vector15
vector15:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $15
80106392:	6a 0f                	push   $0xf
  jmp alltraps
80106394:	e9 86 fa ff ff       	jmp    80105e1f <alltraps>

80106399 <vector16>:
.globl vector16
vector16:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $16
8010639b:	6a 10                	push   $0x10
  jmp alltraps
8010639d:	e9 7d fa ff ff       	jmp    80105e1f <alltraps>

801063a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801063a2:	6a 11                	push   $0x11
  jmp alltraps
801063a4:	e9 76 fa ff ff       	jmp    80105e1f <alltraps>

801063a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $18
801063ab:	6a 12                	push   $0x12
  jmp alltraps
801063ad:	e9 6d fa ff ff       	jmp    80105e1f <alltraps>

801063b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $19
801063b4:	6a 13                	push   $0x13
  jmp alltraps
801063b6:	e9 64 fa ff ff       	jmp    80105e1f <alltraps>

801063bb <vector20>:
.globl vector20
vector20:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $20
801063bd:	6a 14                	push   $0x14
  jmp alltraps
801063bf:	e9 5b fa ff ff       	jmp    80105e1f <alltraps>

801063c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $21
801063c6:	6a 15                	push   $0x15
  jmp alltraps
801063c8:	e9 52 fa ff ff       	jmp    80105e1f <alltraps>

801063cd <vector22>:
.globl vector22
vector22:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $22
801063cf:	6a 16                	push   $0x16
  jmp alltraps
801063d1:	e9 49 fa ff ff       	jmp    80105e1f <alltraps>

801063d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $23
801063d8:	6a 17                	push   $0x17
  jmp alltraps
801063da:	e9 40 fa ff ff       	jmp    80105e1f <alltraps>

801063df <vector24>:
.globl vector24
vector24:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $24
801063e1:	6a 18                	push   $0x18
  jmp alltraps
801063e3:	e9 37 fa ff ff       	jmp    80105e1f <alltraps>

801063e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $25
801063ea:	6a 19                	push   $0x19
  jmp alltraps
801063ec:	e9 2e fa ff ff       	jmp    80105e1f <alltraps>

801063f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $26
801063f3:	6a 1a                	push   $0x1a
  jmp alltraps
801063f5:	e9 25 fa ff ff       	jmp    80105e1f <alltraps>

801063fa <vector27>:
.globl vector27
vector27:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $27
801063fc:	6a 1b                	push   $0x1b
  jmp alltraps
801063fe:	e9 1c fa ff ff       	jmp    80105e1f <alltraps>

80106403 <vector28>:
.globl vector28
vector28:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $28
80106405:	6a 1c                	push   $0x1c
  jmp alltraps
80106407:	e9 13 fa ff ff       	jmp    80105e1f <alltraps>

8010640c <vector29>:
.globl vector29
vector29:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $29
8010640e:	6a 1d                	push   $0x1d
  jmp alltraps
80106410:	e9 0a fa ff ff       	jmp    80105e1f <alltraps>

80106415 <vector30>:
.globl vector30
vector30:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $30
80106417:	6a 1e                	push   $0x1e
  jmp alltraps
80106419:	e9 01 fa ff ff       	jmp    80105e1f <alltraps>

8010641e <vector31>:
.globl vector31
vector31:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $31
80106420:	6a 1f                	push   $0x1f
  jmp alltraps
80106422:	e9 f8 f9 ff ff       	jmp    80105e1f <alltraps>

80106427 <vector32>:
.globl vector32
vector32:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $32
80106429:	6a 20                	push   $0x20
  jmp alltraps
8010642b:	e9 ef f9 ff ff       	jmp    80105e1f <alltraps>

80106430 <vector33>:
.globl vector33
vector33:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $33
80106432:	6a 21                	push   $0x21
  jmp alltraps
80106434:	e9 e6 f9 ff ff       	jmp    80105e1f <alltraps>

80106439 <vector34>:
.globl vector34
vector34:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $34
8010643b:	6a 22                	push   $0x22
  jmp alltraps
8010643d:	e9 dd f9 ff ff       	jmp    80105e1f <alltraps>

80106442 <vector35>:
.globl vector35
vector35:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $35
80106444:	6a 23                	push   $0x23
  jmp alltraps
80106446:	e9 d4 f9 ff ff       	jmp    80105e1f <alltraps>

8010644b <vector36>:
.globl vector36
vector36:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $36
8010644d:	6a 24                	push   $0x24
  jmp alltraps
8010644f:	e9 cb f9 ff ff       	jmp    80105e1f <alltraps>

80106454 <vector37>:
.globl vector37
vector37:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $37
80106456:	6a 25                	push   $0x25
  jmp alltraps
80106458:	e9 c2 f9 ff ff       	jmp    80105e1f <alltraps>

8010645d <vector38>:
.globl vector38
vector38:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $38
8010645f:	6a 26                	push   $0x26
  jmp alltraps
80106461:	e9 b9 f9 ff ff       	jmp    80105e1f <alltraps>

80106466 <vector39>:
.globl vector39
vector39:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $39
80106468:	6a 27                	push   $0x27
  jmp alltraps
8010646a:	e9 b0 f9 ff ff       	jmp    80105e1f <alltraps>

8010646f <vector40>:
.globl vector40
vector40:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $40
80106471:	6a 28                	push   $0x28
  jmp alltraps
80106473:	e9 a7 f9 ff ff       	jmp    80105e1f <alltraps>

80106478 <vector41>:
.globl vector41
vector41:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $41
8010647a:	6a 29                	push   $0x29
  jmp alltraps
8010647c:	e9 9e f9 ff ff       	jmp    80105e1f <alltraps>

80106481 <vector42>:
.globl vector42
vector42:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $42
80106483:	6a 2a                	push   $0x2a
  jmp alltraps
80106485:	e9 95 f9 ff ff       	jmp    80105e1f <alltraps>

8010648a <vector43>:
.globl vector43
vector43:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $43
8010648c:	6a 2b                	push   $0x2b
  jmp alltraps
8010648e:	e9 8c f9 ff ff       	jmp    80105e1f <alltraps>

80106493 <vector44>:
.globl vector44
vector44:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $44
80106495:	6a 2c                	push   $0x2c
  jmp alltraps
80106497:	e9 83 f9 ff ff       	jmp    80105e1f <alltraps>

8010649c <vector45>:
.globl vector45
vector45:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $45
8010649e:	6a 2d                	push   $0x2d
  jmp alltraps
801064a0:	e9 7a f9 ff ff       	jmp    80105e1f <alltraps>

801064a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $46
801064a7:	6a 2e                	push   $0x2e
  jmp alltraps
801064a9:	e9 71 f9 ff ff       	jmp    80105e1f <alltraps>

801064ae <vector47>:
.globl vector47
vector47:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $47
801064b0:	6a 2f                	push   $0x2f
  jmp alltraps
801064b2:	e9 68 f9 ff ff       	jmp    80105e1f <alltraps>

801064b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $48
801064b9:	6a 30                	push   $0x30
  jmp alltraps
801064bb:	e9 5f f9 ff ff       	jmp    80105e1f <alltraps>

801064c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $49
801064c2:	6a 31                	push   $0x31
  jmp alltraps
801064c4:	e9 56 f9 ff ff       	jmp    80105e1f <alltraps>

801064c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $50
801064cb:	6a 32                	push   $0x32
  jmp alltraps
801064cd:	e9 4d f9 ff ff       	jmp    80105e1f <alltraps>

801064d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $51
801064d4:	6a 33                	push   $0x33
  jmp alltraps
801064d6:	e9 44 f9 ff ff       	jmp    80105e1f <alltraps>

801064db <vector52>:
.globl vector52
vector52:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $52
801064dd:	6a 34                	push   $0x34
  jmp alltraps
801064df:	e9 3b f9 ff ff       	jmp    80105e1f <alltraps>

801064e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $53
801064e6:	6a 35                	push   $0x35
  jmp alltraps
801064e8:	e9 32 f9 ff ff       	jmp    80105e1f <alltraps>

801064ed <vector54>:
.globl vector54
vector54:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $54
801064ef:	6a 36                	push   $0x36
  jmp alltraps
801064f1:	e9 29 f9 ff ff       	jmp    80105e1f <alltraps>

801064f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $55
801064f8:	6a 37                	push   $0x37
  jmp alltraps
801064fa:	e9 20 f9 ff ff       	jmp    80105e1f <alltraps>

801064ff <vector56>:
.globl vector56
vector56:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $56
80106501:	6a 38                	push   $0x38
  jmp alltraps
80106503:	e9 17 f9 ff ff       	jmp    80105e1f <alltraps>

80106508 <vector57>:
.globl vector57
vector57:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $57
8010650a:	6a 39                	push   $0x39
  jmp alltraps
8010650c:	e9 0e f9 ff ff       	jmp    80105e1f <alltraps>

80106511 <vector58>:
.globl vector58
vector58:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $58
80106513:	6a 3a                	push   $0x3a
  jmp alltraps
80106515:	e9 05 f9 ff ff       	jmp    80105e1f <alltraps>

8010651a <vector59>:
.globl vector59
vector59:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $59
8010651c:	6a 3b                	push   $0x3b
  jmp alltraps
8010651e:	e9 fc f8 ff ff       	jmp    80105e1f <alltraps>

80106523 <vector60>:
.globl vector60
vector60:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $60
80106525:	6a 3c                	push   $0x3c
  jmp alltraps
80106527:	e9 f3 f8 ff ff       	jmp    80105e1f <alltraps>

8010652c <vector61>:
.globl vector61
vector61:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $61
8010652e:	6a 3d                	push   $0x3d
  jmp alltraps
80106530:	e9 ea f8 ff ff       	jmp    80105e1f <alltraps>

80106535 <vector62>:
.globl vector62
vector62:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $62
80106537:	6a 3e                	push   $0x3e
  jmp alltraps
80106539:	e9 e1 f8 ff ff       	jmp    80105e1f <alltraps>

8010653e <vector63>:
.globl vector63
vector63:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $63
80106540:	6a 3f                	push   $0x3f
  jmp alltraps
80106542:	e9 d8 f8 ff ff       	jmp    80105e1f <alltraps>

80106547 <vector64>:
.globl vector64
vector64:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $64
80106549:	6a 40                	push   $0x40
  jmp alltraps
8010654b:	e9 cf f8 ff ff       	jmp    80105e1f <alltraps>

80106550 <vector65>:
.globl vector65
vector65:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $65
80106552:	6a 41                	push   $0x41
  jmp alltraps
80106554:	e9 c6 f8 ff ff       	jmp    80105e1f <alltraps>

80106559 <vector66>:
.globl vector66
vector66:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $66
8010655b:	6a 42                	push   $0x42
  jmp alltraps
8010655d:	e9 bd f8 ff ff       	jmp    80105e1f <alltraps>

80106562 <vector67>:
.globl vector67
vector67:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $67
80106564:	6a 43                	push   $0x43
  jmp alltraps
80106566:	e9 b4 f8 ff ff       	jmp    80105e1f <alltraps>

8010656b <vector68>:
.globl vector68
vector68:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $68
8010656d:	6a 44                	push   $0x44
  jmp alltraps
8010656f:	e9 ab f8 ff ff       	jmp    80105e1f <alltraps>

80106574 <vector69>:
.globl vector69
vector69:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $69
80106576:	6a 45                	push   $0x45
  jmp alltraps
80106578:	e9 a2 f8 ff ff       	jmp    80105e1f <alltraps>

8010657d <vector70>:
.globl vector70
vector70:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $70
8010657f:	6a 46                	push   $0x46
  jmp alltraps
80106581:	e9 99 f8 ff ff       	jmp    80105e1f <alltraps>

80106586 <vector71>:
.globl vector71
vector71:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $71
80106588:	6a 47                	push   $0x47
  jmp alltraps
8010658a:	e9 90 f8 ff ff       	jmp    80105e1f <alltraps>

8010658f <vector72>:
.globl vector72
vector72:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $72
80106591:	6a 48                	push   $0x48
  jmp alltraps
80106593:	e9 87 f8 ff ff       	jmp    80105e1f <alltraps>

80106598 <vector73>:
.globl vector73
vector73:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $73
8010659a:	6a 49                	push   $0x49
  jmp alltraps
8010659c:	e9 7e f8 ff ff       	jmp    80105e1f <alltraps>

801065a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $74
801065a3:	6a 4a                	push   $0x4a
  jmp alltraps
801065a5:	e9 75 f8 ff ff       	jmp    80105e1f <alltraps>

801065aa <vector75>:
.globl vector75
vector75:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $75
801065ac:	6a 4b                	push   $0x4b
  jmp alltraps
801065ae:	e9 6c f8 ff ff       	jmp    80105e1f <alltraps>

801065b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $76
801065b5:	6a 4c                	push   $0x4c
  jmp alltraps
801065b7:	e9 63 f8 ff ff       	jmp    80105e1f <alltraps>

801065bc <vector77>:
.globl vector77
vector77:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $77
801065be:	6a 4d                	push   $0x4d
  jmp alltraps
801065c0:	e9 5a f8 ff ff       	jmp    80105e1f <alltraps>

801065c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $78
801065c7:	6a 4e                	push   $0x4e
  jmp alltraps
801065c9:	e9 51 f8 ff ff       	jmp    80105e1f <alltraps>

801065ce <vector79>:
.globl vector79
vector79:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $79
801065d0:	6a 4f                	push   $0x4f
  jmp alltraps
801065d2:	e9 48 f8 ff ff       	jmp    80105e1f <alltraps>

801065d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $80
801065d9:	6a 50                	push   $0x50
  jmp alltraps
801065db:	e9 3f f8 ff ff       	jmp    80105e1f <alltraps>

801065e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $81
801065e2:	6a 51                	push   $0x51
  jmp alltraps
801065e4:	e9 36 f8 ff ff       	jmp    80105e1f <alltraps>

801065e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $82
801065eb:	6a 52                	push   $0x52
  jmp alltraps
801065ed:	e9 2d f8 ff ff       	jmp    80105e1f <alltraps>

801065f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $83
801065f4:	6a 53                	push   $0x53
  jmp alltraps
801065f6:	e9 24 f8 ff ff       	jmp    80105e1f <alltraps>

801065fb <vector84>:
.globl vector84
vector84:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $84
801065fd:	6a 54                	push   $0x54
  jmp alltraps
801065ff:	e9 1b f8 ff ff       	jmp    80105e1f <alltraps>

80106604 <vector85>:
.globl vector85
vector85:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $85
80106606:	6a 55                	push   $0x55
  jmp alltraps
80106608:	e9 12 f8 ff ff       	jmp    80105e1f <alltraps>

8010660d <vector86>:
.globl vector86
vector86:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $86
8010660f:	6a 56                	push   $0x56
  jmp alltraps
80106611:	e9 09 f8 ff ff       	jmp    80105e1f <alltraps>

80106616 <vector87>:
.globl vector87
vector87:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $87
80106618:	6a 57                	push   $0x57
  jmp alltraps
8010661a:	e9 00 f8 ff ff       	jmp    80105e1f <alltraps>

8010661f <vector88>:
.globl vector88
vector88:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $88
80106621:	6a 58                	push   $0x58
  jmp alltraps
80106623:	e9 f7 f7 ff ff       	jmp    80105e1f <alltraps>

80106628 <vector89>:
.globl vector89
vector89:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $89
8010662a:	6a 59                	push   $0x59
  jmp alltraps
8010662c:	e9 ee f7 ff ff       	jmp    80105e1f <alltraps>

80106631 <vector90>:
.globl vector90
vector90:
  pushl $0
80106631:	6a 00                	push   $0x0
  pushl $90
80106633:	6a 5a                	push   $0x5a
  jmp alltraps
80106635:	e9 e5 f7 ff ff       	jmp    80105e1f <alltraps>

8010663a <vector91>:
.globl vector91
vector91:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $91
8010663c:	6a 5b                	push   $0x5b
  jmp alltraps
8010663e:	e9 dc f7 ff ff       	jmp    80105e1f <alltraps>

80106643 <vector92>:
.globl vector92
vector92:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $92
80106645:	6a 5c                	push   $0x5c
  jmp alltraps
80106647:	e9 d3 f7 ff ff       	jmp    80105e1f <alltraps>

8010664c <vector93>:
.globl vector93
vector93:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $93
8010664e:	6a 5d                	push   $0x5d
  jmp alltraps
80106650:	e9 ca f7 ff ff       	jmp    80105e1f <alltraps>

80106655 <vector94>:
.globl vector94
vector94:
  pushl $0
80106655:	6a 00                	push   $0x0
  pushl $94
80106657:	6a 5e                	push   $0x5e
  jmp alltraps
80106659:	e9 c1 f7 ff ff       	jmp    80105e1f <alltraps>

8010665e <vector95>:
.globl vector95
vector95:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $95
80106660:	6a 5f                	push   $0x5f
  jmp alltraps
80106662:	e9 b8 f7 ff ff       	jmp    80105e1f <alltraps>

80106667 <vector96>:
.globl vector96
vector96:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $96
80106669:	6a 60                	push   $0x60
  jmp alltraps
8010666b:	e9 af f7 ff ff       	jmp    80105e1f <alltraps>

80106670 <vector97>:
.globl vector97
vector97:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $97
80106672:	6a 61                	push   $0x61
  jmp alltraps
80106674:	e9 a6 f7 ff ff       	jmp    80105e1f <alltraps>

80106679 <vector98>:
.globl vector98
vector98:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $98
8010667b:	6a 62                	push   $0x62
  jmp alltraps
8010667d:	e9 9d f7 ff ff       	jmp    80105e1f <alltraps>

80106682 <vector99>:
.globl vector99
vector99:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $99
80106684:	6a 63                	push   $0x63
  jmp alltraps
80106686:	e9 94 f7 ff ff       	jmp    80105e1f <alltraps>

8010668b <vector100>:
.globl vector100
vector100:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $100
8010668d:	6a 64                	push   $0x64
  jmp alltraps
8010668f:	e9 8b f7 ff ff       	jmp    80105e1f <alltraps>

80106694 <vector101>:
.globl vector101
vector101:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $101
80106696:	6a 65                	push   $0x65
  jmp alltraps
80106698:	e9 82 f7 ff ff       	jmp    80105e1f <alltraps>

8010669d <vector102>:
.globl vector102
vector102:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $102
8010669f:	6a 66                	push   $0x66
  jmp alltraps
801066a1:	e9 79 f7 ff ff       	jmp    80105e1f <alltraps>

801066a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $103
801066a8:	6a 67                	push   $0x67
  jmp alltraps
801066aa:	e9 70 f7 ff ff       	jmp    80105e1f <alltraps>

801066af <vector104>:
.globl vector104
vector104:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $104
801066b1:	6a 68                	push   $0x68
  jmp alltraps
801066b3:	e9 67 f7 ff ff       	jmp    80105e1f <alltraps>

801066b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $105
801066ba:	6a 69                	push   $0x69
  jmp alltraps
801066bc:	e9 5e f7 ff ff       	jmp    80105e1f <alltraps>

801066c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $106
801066c3:	6a 6a                	push   $0x6a
  jmp alltraps
801066c5:	e9 55 f7 ff ff       	jmp    80105e1f <alltraps>

801066ca <vector107>:
.globl vector107
vector107:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $107
801066cc:	6a 6b                	push   $0x6b
  jmp alltraps
801066ce:	e9 4c f7 ff ff       	jmp    80105e1f <alltraps>

801066d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $108
801066d5:	6a 6c                	push   $0x6c
  jmp alltraps
801066d7:	e9 43 f7 ff ff       	jmp    80105e1f <alltraps>

801066dc <vector109>:
.globl vector109
vector109:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $109
801066de:	6a 6d                	push   $0x6d
  jmp alltraps
801066e0:	e9 3a f7 ff ff       	jmp    80105e1f <alltraps>

801066e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $110
801066e7:	6a 6e                	push   $0x6e
  jmp alltraps
801066e9:	e9 31 f7 ff ff       	jmp    80105e1f <alltraps>

801066ee <vector111>:
.globl vector111
vector111:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $111
801066f0:	6a 6f                	push   $0x6f
  jmp alltraps
801066f2:	e9 28 f7 ff ff       	jmp    80105e1f <alltraps>

801066f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $112
801066f9:	6a 70                	push   $0x70
  jmp alltraps
801066fb:	e9 1f f7 ff ff       	jmp    80105e1f <alltraps>

80106700 <vector113>:
.globl vector113
vector113:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $113
80106702:	6a 71                	push   $0x71
  jmp alltraps
80106704:	e9 16 f7 ff ff       	jmp    80105e1f <alltraps>

80106709 <vector114>:
.globl vector114
vector114:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $114
8010670b:	6a 72                	push   $0x72
  jmp alltraps
8010670d:	e9 0d f7 ff ff       	jmp    80105e1f <alltraps>

80106712 <vector115>:
.globl vector115
vector115:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $115
80106714:	6a 73                	push   $0x73
  jmp alltraps
80106716:	e9 04 f7 ff ff       	jmp    80105e1f <alltraps>

8010671b <vector116>:
.globl vector116
vector116:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $116
8010671d:	6a 74                	push   $0x74
  jmp alltraps
8010671f:	e9 fb f6 ff ff       	jmp    80105e1f <alltraps>

80106724 <vector117>:
.globl vector117
vector117:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $117
80106726:	6a 75                	push   $0x75
  jmp alltraps
80106728:	e9 f2 f6 ff ff       	jmp    80105e1f <alltraps>

8010672d <vector118>:
.globl vector118
vector118:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $118
8010672f:	6a 76                	push   $0x76
  jmp alltraps
80106731:	e9 e9 f6 ff ff       	jmp    80105e1f <alltraps>

80106736 <vector119>:
.globl vector119
vector119:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $119
80106738:	6a 77                	push   $0x77
  jmp alltraps
8010673a:	e9 e0 f6 ff ff       	jmp    80105e1f <alltraps>

8010673f <vector120>:
.globl vector120
vector120:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $120
80106741:	6a 78                	push   $0x78
  jmp alltraps
80106743:	e9 d7 f6 ff ff       	jmp    80105e1f <alltraps>

80106748 <vector121>:
.globl vector121
vector121:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $121
8010674a:	6a 79                	push   $0x79
  jmp alltraps
8010674c:	e9 ce f6 ff ff       	jmp    80105e1f <alltraps>

80106751 <vector122>:
.globl vector122
vector122:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $122
80106753:	6a 7a                	push   $0x7a
  jmp alltraps
80106755:	e9 c5 f6 ff ff       	jmp    80105e1f <alltraps>

8010675a <vector123>:
.globl vector123
vector123:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $123
8010675c:	6a 7b                	push   $0x7b
  jmp alltraps
8010675e:	e9 bc f6 ff ff       	jmp    80105e1f <alltraps>

80106763 <vector124>:
.globl vector124
vector124:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $124
80106765:	6a 7c                	push   $0x7c
  jmp alltraps
80106767:	e9 b3 f6 ff ff       	jmp    80105e1f <alltraps>

8010676c <vector125>:
.globl vector125
vector125:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $125
8010676e:	6a 7d                	push   $0x7d
  jmp alltraps
80106770:	e9 aa f6 ff ff       	jmp    80105e1f <alltraps>

80106775 <vector126>:
.globl vector126
vector126:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $126
80106777:	6a 7e                	push   $0x7e
  jmp alltraps
80106779:	e9 a1 f6 ff ff       	jmp    80105e1f <alltraps>

8010677e <vector127>:
.globl vector127
vector127:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $127
80106780:	6a 7f                	push   $0x7f
  jmp alltraps
80106782:	e9 98 f6 ff ff       	jmp    80105e1f <alltraps>

80106787 <vector128>:
.globl vector128
vector128:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $128
80106789:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010678e:	e9 8c f6 ff ff       	jmp    80105e1f <alltraps>

80106793 <vector129>:
.globl vector129
vector129:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $129
80106795:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010679a:	e9 80 f6 ff ff       	jmp    80105e1f <alltraps>

8010679f <vector130>:
.globl vector130
vector130:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $130
801067a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801067a6:	e9 74 f6 ff ff       	jmp    80105e1f <alltraps>

801067ab <vector131>:
.globl vector131
vector131:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $131
801067ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801067b2:	e9 68 f6 ff ff       	jmp    80105e1f <alltraps>

801067b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $132
801067b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801067be:	e9 5c f6 ff ff       	jmp    80105e1f <alltraps>

801067c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $133
801067c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801067ca:	e9 50 f6 ff ff       	jmp    80105e1f <alltraps>

801067cf <vector134>:
.globl vector134
vector134:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $134
801067d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801067d6:	e9 44 f6 ff ff       	jmp    80105e1f <alltraps>

801067db <vector135>:
.globl vector135
vector135:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $135
801067dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801067e2:	e9 38 f6 ff ff       	jmp    80105e1f <alltraps>

801067e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $136
801067e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801067ee:	e9 2c f6 ff ff       	jmp    80105e1f <alltraps>

801067f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $137
801067f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801067fa:	e9 20 f6 ff ff       	jmp    80105e1f <alltraps>

801067ff <vector138>:
.globl vector138
vector138:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $138
80106801:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106806:	e9 14 f6 ff ff       	jmp    80105e1f <alltraps>

8010680b <vector139>:
.globl vector139
vector139:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $139
8010680d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106812:	e9 08 f6 ff ff       	jmp    80105e1f <alltraps>

80106817 <vector140>:
.globl vector140
vector140:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $140
80106819:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010681e:	e9 fc f5 ff ff       	jmp    80105e1f <alltraps>

80106823 <vector141>:
.globl vector141
vector141:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $141
80106825:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010682a:	e9 f0 f5 ff ff       	jmp    80105e1f <alltraps>

8010682f <vector142>:
.globl vector142
vector142:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $142
80106831:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106836:	e9 e4 f5 ff ff       	jmp    80105e1f <alltraps>

8010683b <vector143>:
.globl vector143
vector143:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $143
8010683d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106842:	e9 d8 f5 ff ff       	jmp    80105e1f <alltraps>

80106847 <vector144>:
.globl vector144
vector144:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $144
80106849:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010684e:	e9 cc f5 ff ff       	jmp    80105e1f <alltraps>

80106853 <vector145>:
.globl vector145
vector145:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $145
80106855:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010685a:	e9 c0 f5 ff ff       	jmp    80105e1f <alltraps>

8010685f <vector146>:
.globl vector146
vector146:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $146
80106861:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106866:	e9 b4 f5 ff ff       	jmp    80105e1f <alltraps>

8010686b <vector147>:
.globl vector147
vector147:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $147
8010686d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106872:	e9 a8 f5 ff ff       	jmp    80105e1f <alltraps>

80106877 <vector148>:
.globl vector148
vector148:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $148
80106879:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010687e:	e9 9c f5 ff ff       	jmp    80105e1f <alltraps>

80106883 <vector149>:
.globl vector149
vector149:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $149
80106885:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010688a:	e9 90 f5 ff ff       	jmp    80105e1f <alltraps>

8010688f <vector150>:
.globl vector150
vector150:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $150
80106891:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106896:	e9 84 f5 ff ff       	jmp    80105e1f <alltraps>

8010689b <vector151>:
.globl vector151
vector151:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $151
8010689d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801068a2:	e9 78 f5 ff ff       	jmp    80105e1f <alltraps>

801068a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $152
801068a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801068ae:	e9 6c f5 ff ff       	jmp    80105e1f <alltraps>

801068b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $153
801068b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801068ba:	e9 60 f5 ff ff       	jmp    80105e1f <alltraps>

801068bf <vector154>:
.globl vector154
vector154:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $154
801068c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801068c6:	e9 54 f5 ff ff       	jmp    80105e1f <alltraps>

801068cb <vector155>:
.globl vector155
vector155:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $155
801068cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801068d2:	e9 48 f5 ff ff       	jmp    80105e1f <alltraps>

801068d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $156
801068d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801068de:	e9 3c f5 ff ff       	jmp    80105e1f <alltraps>

801068e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $157
801068e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801068ea:	e9 30 f5 ff ff       	jmp    80105e1f <alltraps>

801068ef <vector158>:
.globl vector158
vector158:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $158
801068f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801068f6:	e9 24 f5 ff ff       	jmp    80105e1f <alltraps>

801068fb <vector159>:
.globl vector159
vector159:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $159
801068fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106902:	e9 18 f5 ff ff       	jmp    80105e1f <alltraps>

80106907 <vector160>:
.globl vector160
vector160:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $160
80106909:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010690e:	e9 0c f5 ff ff       	jmp    80105e1f <alltraps>

80106913 <vector161>:
.globl vector161
vector161:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $161
80106915:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010691a:	e9 00 f5 ff ff       	jmp    80105e1f <alltraps>

8010691f <vector162>:
.globl vector162
vector162:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $162
80106921:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106926:	e9 f4 f4 ff ff       	jmp    80105e1f <alltraps>

8010692b <vector163>:
.globl vector163
vector163:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $163
8010692d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106932:	e9 e8 f4 ff ff       	jmp    80105e1f <alltraps>

80106937 <vector164>:
.globl vector164
vector164:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $164
80106939:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010693e:	e9 dc f4 ff ff       	jmp    80105e1f <alltraps>

80106943 <vector165>:
.globl vector165
vector165:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $165
80106945:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010694a:	e9 d0 f4 ff ff       	jmp    80105e1f <alltraps>

8010694f <vector166>:
.globl vector166
vector166:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $166
80106951:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106956:	e9 c4 f4 ff ff       	jmp    80105e1f <alltraps>

8010695b <vector167>:
.globl vector167
vector167:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $167
8010695d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106962:	e9 b8 f4 ff ff       	jmp    80105e1f <alltraps>

80106967 <vector168>:
.globl vector168
vector168:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $168
80106969:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010696e:	e9 ac f4 ff ff       	jmp    80105e1f <alltraps>

80106973 <vector169>:
.globl vector169
vector169:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $169
80106975:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010697a:	e9 a0 f4 ff ff       	jmp    80105e1f <alltraps>

8010697f <vector170>:
.globl vector170
vector170:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $170
80106981:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106986:	e9 94 f4 ff ff       	jmp    80105e1f <alltraps>

8010698b <vector171>:
.globl vector171
vector171:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $171
8010698d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106992:	e9 88 f4 ff ff       	jmp    80105e1f <alltraps>

80106997 <vector172>:
.globl vector172
vector172:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $172
80106999:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010699e:	e9 7c f4 ff ff       	jmp    80105e1f <alltraps>

801069a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $173
801069a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801069aa:	e9 70 f4 ff ff       	jmp    80105e1f <alltraps>

801069af <vector174>:
.globl vector174
vector174:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $174
801069b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801069b6:	e9 64 f4 ff ff       	jmp    80105e1f <alltraps>

801069bb <vector175>:
.globl vector175
vector175:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $175
801069bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801069c2:	e9 58 f4 ff ff       	jmp    80105e1f <alltraps>

801069c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $176
801069c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801069ce:	e9 4c f4 ff ff       	jmp    80105e1f <alltraps>

801069d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $177
801069d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801069da:	e9 40 f4 ff ff       	jmp    80105e1f <alltraps>

801069df <vector178>:
.globl vector178
vector178:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $178
801069e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801069e6:	e9 34 f4 ff ff       	jmp    80105e1f <alltraps>

801069eb <vector179>:
.globl vector179
vector179:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $179
801069ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801069f2:	e9 28 f4 ff ff       	jmp    80105e1f <alltraps>

801069f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $180
801069f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801069fe:	e9 1c f4 ff ff       	jmp    80105e1f <alltraps>

80106a03 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $181
80106a05:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a0a:	e9 10 f4 ff ff       	jmp    80105e1f <alltraps>

80106a0f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $182
80106a11:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a16:	e9 04 f4 ff ff       	jmp    80105e1f <alltraps>

80106a1b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $183
80106a1d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a22:	e9 f8 f3 ff ff       	jmp    80105e1f <alltraps>

80106a27 <vector184>:
.globl vector184
vector184:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $184
80106a29:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a2e:	e9 ec f3 ff ff       	jmp    80105e1f <alltraps>

80106a33 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $185
80106a35:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a3a:	e9 e0 f3 ff ff       	jmp    80105e1f <alltraps>

80106a3f <vector186>:
.globl vector186
vector186:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $186
80106a41:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106a46:	e9 d4 f3 ff ff       	jmp    80105e1f <alltraps>

80106a4b <vector187>:
.globl vector187
vector187:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $187
80106a4d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a52:	e9 c8 f3 ff ff       	jmp    80105e1f <alltraps>

80106a57 <vector188>:
.globl vector188
vector188:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $188
80106a59:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a5e:	e9 bc f3 ff ff       	jmp    80105e1f <alltraps>

80106a63 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $189
80106a65:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a6a:	e9 b0 f3 ff ff       	jmp    80105e1f <alltraps>

80106a6f <vector190>:
.globl vector190
vector190:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $190
80106a71:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a76:	e9 a4 f3 ff ff       	jmp    80105e1f <alltraps>

80106a7b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $191
80106a7d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a82:	e9 98 f3 ff ff       	jmp    80105e1f <alltraps>

80106a87 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $192
80106a89:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a8e:	e9 8c f3 ff ff       	jmp    80105e1f <alltraps>

80106a93 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $193
80106a95:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a9a:	e9 80 f3 ff ff       	jmp    80105e1f <alltraps>

80106a9f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $194
80106aa1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106aa6:	e9 74 f3 ff ff       	jmp    80105e1f <alltraps>

80106aab <vector195>:
.globl vector195
vector195:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $195
80106aad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ab2:	e9 68 f3 ff ff       	jmp    80105e1f <alltraps>

80106ab7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $196
80106ab9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106abe:	e9 5c f3 ff ff       	jmp    80105e1f <alltraps>

80106ac3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $197
80106ac5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106aca:	e9 50 f3 ff ff       	jmp    80105e1f <alltraps>

80106acf <vector198>:
.globl vector198
vector198:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $198
80106ad1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ad6:	e9 44 f3 ff ff       	jmp    80105e1f <alltraps>

80106adb <vector199>:
.globl vector199
vector199:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $199
80106add:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ae2:	e9 38 f3 ff ff       	jmp    80105e1f <alltraps>

80106ae7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $200
80106ae9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106aee:	e9 2c f3 ff ff       	jmp    80105e1f <alltraps>

80106af3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $201
80106af5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106afa:	e9 20 f3 ff ff       	jmp    80105e1f <alltraps>

80106aff <vector202>:
.globl vector202
vector202:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $202
80106b01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b06:	e9 14 f3 ff ff       	jmp    80105e1f <alltraps>

80106b0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $203
80106b0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b12:	e9 08 f3 ff ff       	jmp    80105e1f <alltraps>

80106b17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $204
80106b19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b1e:	e9 fc f2 ff ff       	jmp    80105e1f <alltraps>

80106b23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $205
80106b25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b2a:	e9 f0 f2 ff ff       	jmp    80105e1f <alltraps>

80106b2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $206
80106b31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b36:	e9 e4 f2 ff ff       	jmp    80105e1f <alltraps>

80106b3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $207
80106b3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106b42:	e9 d8 f2 ff ff       	jmp    80105e1f <alltraps>

80106b47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $208
80106b49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106b4e:	e9 cc f2 ff ff       	jmp    80105e1f <alltraps>

80106b53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $209
80106b55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b5a:	e9 c0 f2 ff ff       	jmp    80105e1f <alltraps>

80106b5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $210
80106b61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b66:	e9 b4 f2 ff ff       	jmp    80105e1f <alltraps>

80106b6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $211
80106b6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b72:	e9 a8 f2 ff ff       	jmp    80105e1f <alltraps>

80106b77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $212
80106b79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b7e:	e9 9c f2 ff ff       	jmp    80105e1f <alltraps>

80106b83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $213
80106b85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b8a:	e9 90 f2 ff ff       	jmp    80105e1f <alltraps>

80106b8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $214
80106b91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b96:	e9 84 f2 ff ff       	jmp    80105e1f <alltraps>

80106b9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $215
80106b9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ba2:	e9 78 f2 ff ff       	jmp    80105e1f <alltraps>

80106ba7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $216
80106ba9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106bae:	e9 6c f2 ff ff       	jmp    80105e1f <alltraps>

80106bb3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $217
80106bb5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106bba:	e9 60 f2 ff ff       	jmp    80105e1f <alltraps>

80106bbf <vector218>:
.globl vector218
vector218:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $218
80106bc1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106bc6:	e9 54 f2 ff ff       	jmp    80105e1f <alltraps>

80106bcb <vector219>:
.globl vector219
vector219:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $219
80106bcd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106bd2:	e9 48 f2 ff ff       	jmp    80105e1f <alltraps>

80106bd7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $220
80106bd9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106bde:	e9 3c f2 ff ff       	jmp    80105e1f <alltraps>

80106be3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $221
80106be5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106bea:	e9 30 f2 ff ff       	jmp    80105e1f <alltraps>

80106bef <vector222>:
.globl vector222
vector222:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $222
80106bf1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106bf6:	e9 24 f2 ff ff       	jmp    80105e1f <alltraps>

80106bfb <vector223>:
.globl vector223
vector223:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $223
80106bfd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c02:	e9 18 f2 ff ff       	jmp    80105e1f <alltraps>

80106c07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $224
80106c09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c0e:	e9 0c f2 ff ff       	jmp    80105e1f <alltraps>

80106c13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $225
80106c15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c1a:	e9 00 f2 ff ff       	jmp    80105e1f <alltraps>

80106c1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $226
80106c21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c26:	e9 f4 f1 ff ff       	jmp    80105e1f <alltraps>

80106c2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $227
80106c2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c32:	e9 e8 f1 ff ff       	jmp    80105e1f <alltraps>

80106c37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $228
80106c39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c3e:	e9 dc f1 ff ff       	jmp    80105e1f <alltraps>

80106c43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $229
80106c45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106c4a:	e9 d0 f1 ff ff       	jmp    80105e1f <alltraps>

80106c4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $230
80106c51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c56:	e9 c4 f1 ff ff       	jmp    80105e1f <alltraps>

80106c5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $231
80106c5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c62:	e9 b8 f1 ff ff       	jmp    80105e1f <alltraps>

80106c67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $232
80106c69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c6e:	e9 ac f1 ff ff       	jmp    80105e1f <alltraps>

80106c73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $233
80106c75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c7a:	e9 a0 f1 ff ff       	jmp    80105e1f <alltraps>

80106c7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $234
80106c81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c86:	e9 94 f1 ff ff       	jmp    80105e1f <alltraps>

80106c8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $235
80106c8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c92:	e9 88 f1 ff ff       	jmp    80105e1f <alltraps>

80106c97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $236
80106c99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c9e:	e9 7c f1 ff ff       	jmp    80105e1f <alltraps>

80106ca3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $237
80106ca5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106caa:	e9 70 f1 ff ff       	jmp    80105e1f <alltraps>

80106caf <vector238>:
.globl vector238
vector238:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $238
80106cb1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106cb6:	e9 64 f1 ff ff       	jmp    80105e1f <alltraps>

80106cbb <vector239>:
.globl vector239
vector239:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $239
80106cbd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106cc2:	e9 58 f1 ff ff       	jmp    80105e1f <alltraps>

80106cc7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $240
80106cc9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106cce:	e9 4c f1 ff ff       	jmp    80105e1f <alltraps>

80106cd3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $241
80106cd5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106cda:	e9 40 f1 ff ff       	jmp    80105e1f <alltraps>

80106cdf <vector242>:
.globl vector242
vector242:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $242
80106ce1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ce6:	e9 34 f1 ff ff       	jmp    80105e1f <alltraps>

80106ceb <vector243>:
.globl vector243
vector243:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $243
80106ced:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106cf2:	e9 28 f1 ff ff       	jmp    80105e1f <alltraps>

80106cf7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $244
80106cf9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106cfe:	e9 1c f1 ff ff       	jmp    80105e1f <alltraps>

80106d03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $245
80106d05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d0a:	e9 10 f1 ff ff       	jmp    80105e1f <alltraps>

80106d0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $246
80106d11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d16:	e9 04 f1 ff ff       	jmp    80105e1f <alltraps>

80106d1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $247
80106d1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d22:	e9 f8 f0 ff ff       	jmp    80105e1f <alltraps>

80106d27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $248
80106d29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d2e:	e9 ec f0 ff ff       	jmp    80105e1f <alltraps>

80106d33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $249
80106d35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d3a:	e9 e0 f0 ff ff       	jmp    80105e1f <alltraps>

80106d3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $250
80106d41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106d46:	e9 d4 f0 ff ff       	jmp    80105e1f <alltraps>

80106d4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $251
80106d4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d52:	e9 c8 f0 ff ff       	jmp    80105e1f <alltraps>

80106d57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $252
80106d59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d5e:	e9 bc f0 ff ff       	jmp    80105e1f <alltraps>

80106d63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $253
80106d65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d6a:	e9 b0 f0 ff ff       	jmp    80105e1f <alltraps>

80106d6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $254
80106d71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d76:	e9 a4 f0 ff ff       	jmp    80105e1f <alltraps>

80106d7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $255
80106d7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d82:	e9 98 f0 ff ff       	jmp    80105e1f <alltraps>
80106d87:	66 90                	xchg   %ax,%ax
80106d89:	66 90                	xchg   %ax,%ax
80106d8b:	66 90                	xchg   %ax,%ax
80106d8d:	66 90                	xchg   %ax,%ax
80106d8f:	90                   	nop

80106d90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106d96:	89 d3                	mov    %edx,%ebx
{
80106d98:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106d9a:	c1 eb 16             	shr    $0x16,%ebx
80106d9d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106da0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106da3:	8b 06                	mov    (%esi),%eax
80106da5:	a8 01                	test   $0x1,%al
80106da7:	74 27                	je     80106dd0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106da9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106db4:	c1 ef 0a             	shr    $0xa,%edi
}
80106db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106dba:	89 fa                	mov    %edi,%edx
80106dbc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106dc2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106dc5:	5b                   	pop    %ebx
80106dc6:	5e                   	pop    %esi
80106dc7:	5f                   	pop    %edi
80106dc8:	5d                   	pop    %ebp
80106dc9:	c3                   	ret    
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106dd0:	85 c9                	test   %ecx,%ecx
80106dd2:	74 2c                	je     80106e00 <walkpgdir+0x70>
80106dd4:	e8 e7 b6 ff ff       	call   801024c0 <kalloc>
80106dd9:	85 c0                	test   %eax,%eax
80106ddb:	89 c3                	mov    %eax,%ebx
80106ddd:	74 21                	je     80106e00 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106ddf:	83 ec 04             	sub    $0x4,%esp
80106de2:	68 00 10 00 00       	push   $0x1000
80106de7:	6a 00                	push   $0x0
80106de9:	50                   	push   %eax
80106dea:	e8 61 dd ff ff       	call   80104b50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106def:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106df5:	83 c4 10             	add    $0x10,%esp
80106df8:	83 c8 07             	or     $0x7,%eax
80106dfb:	89 06                	mov    %eax,(%esi)
80106dfd:	eb b5                	jmp    80106db4 <walkpgdir+0x24>
80106dff:	90                   	nop
}
80106e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e03:	31 c0                	xor    %eax,%eax
}
80106e05:	5b                   	pop    %ebx
80106e06:	5e                   	pop    %esi
80106e07:	5f                   	pop    %edi
80106e08:	5d                   	pop    %ebp
80106e09:	c3                   	ret    
80106e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e10 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106e16:	89 d3                	mov    %edx,%ebx
80106e18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106e1e:	83 ec 1c             	sub    $0x1c,%esp
80106e21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e28:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e33:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e36:	29 df                	sub    %ebx,%edi
80106e38:	83 c8 01             	or     $0x1,%eax
80106e3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e3e:	eb 15                	jmp    80106e55 <mappages+0x45>
    if(*pte & PTE_P)
80106e40:	f6 00 01             	testb  $0x1,(%eax)
80106e43:	75 45                	jne    80106e8a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106e45:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106e48:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106e4b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e4d:	74 31                	je     80106e80 <mappages+0x70>
      break;
    a += PGSIZE;
80106e4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e58:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e5d:	89 da                	mov    %ebx,%edx
80106e5f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106e62:	e8 29 ff ff ff       	call   80106d90 <walkpgdir>
80106e67:	85 c0                	test   %eax,%eax
80106e69:	75 d5                	jne    80106e40 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e73:	5b                   	pop    %ebx
80106e74:	5e                   	pop    %esi
80106e75:	5f                   	pop    %edi
80106e76:	5d                   	pop    %ebp
80106e77:	c3                   	ret    
80106e78:	90                   	nop
80106e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e83:	31 c0                	xor    %eax,%eax
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
      panic("remap");
80106e8a:	83 ec 0c             	sub    $0xc,%esp
80106e8d:	68 54 80 10 80       	push   $0x80108054
80106e92:	e8 f9 94 ff ff       	call   80100390 <panic>
80106e97:	89 f6                	mov    %esi,%esi
80106e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ea0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ea6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106eac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106eae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106eb4:	83 ec 1c             	sub    $0x1c,%esp
80106eb7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106eba:	39 d3                	cmp    %edx,%ebx
80106ebc:	73 66                	jae    80106f24 <deallocuvm.part.0+0x84>
80106ebe:	89 d6                	mov    %edx,%esi
80106ec0:	eb 3d                	jmp    80106eff <deallocuvm.part.0+0x5f>
80106ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ec8:	8b 10                	mov    (%eax),%edx
80106eca:	f6 c2 01             	test   $0x1,%dl
80106ecd:	74 26                	je     80106ef5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106ecf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ed5:	74 58                	je     80106f2f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106ed7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106eda:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ee0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ee3:	52                   	push   %edx
80106ee4:	e8 27 b4 ff ff       	call   80102310 <kfree>
      *pte = 0;
80106ee9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eec:	83 c4 10             	add    $0x10,%esp
80106eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ef5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106efb:	39 f3                	cmp    %esi,%ebx
80106efd:	73 25                	jae    80106f24 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106eff:	31 c9                	xor    %ecx,%ecx
80106f01:	89 da                	mov    %ebx,%edx
80106f03:	89 f8                	mov    %edi,%eax
80106f05:	e8 86 fe ff ff       	call   80106d90 <walkpgdir>
    if(!pte)
80106f0a:	85 c0                	test   %eax,%eax
80106f0c:	75 ba                	jne    80106ec8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106f14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f20:	39 f3                	cmp    %esi,%ebx
80106f22:	72 db                	jb     80106eff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f2a:	5b                   	pop    %ebx
80106f2b:	5e                   	pop    %esi
80106f2c:	5f                   	pop    %edi
80106f2d:	5d                   	pop    %ebp
80106f2e:	c3                   	ret    
        panic("kfree");
80106f2f:	83 ec 0c             	sub    $0xc,%esp
80106f32:	68 26 79 10 80       	push   $0x80107926
80106f37:	e8 54 94 ff ff       	call   80100390 <panic>
80106f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f40 <seginit>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f46:	e8 45 c9 ff ff       	call   80103890 <cpuid>
80106f4b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f5a:	c7 80 78 3d 11 80 ff 	movl   $0xffff,-0x7feec288(%eax)
80106f61:	ff 00 00 
80106f64:	c7 80 7c 3d 11 80 00 	movl   $0xcf9a00,-0x7feec284(%eax)
80106f6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f6e:	c7 80 80 3d 11 80 ff 	movl   $0xffff,-0x7feec280(%eax)
80106f75:	ff 00 00 
80106f78:	c7 80 84 3d 11 80 00 	movl   $0xcf9200,-0x7feec27c(%eax)
80106f7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f82:	c7 80 88 3d 11 80 ff 	movl   $0xffff,-0x7feec278(%eax)
80106f89:	ff 00 00 
80106f8c:	c7 80 8c 3d 11 80 00 	movl   $0xcffa00,-0x7feec274(%eax)
80106f93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f96:	c7 80 90 3d 11 80 ff 	movl   $0xffff,-0x7feec270(%eax)
80106f9d:	ff 00 00 
80106fa0:	c7 80 94 3d 11 80 00 	movl   $0xcff200,-0x7feec26c(%eax)
80106fa7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106faa:	05 70 3d 11 80       	add    $0x80113d70,%eax
  pd[1] = (uint)p;
80106faf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fb3:	c1 e8 10             	shr    $0x10,%eax
80106fb6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fbd:	0f 01 10             	lgdtl  (%eax)
}
80106fc0:	c9                   	leave  
80106fc1:	c3                   	ret    
80106fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fd0:	a1 24 77 11 80       	mov    0x80117724,%eax
{
80106fd5:	55                   	push   %ebp
80106fd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fd8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fdd:	0f 22 d8             	mov    %eax,%cr3
}
80106fe0:	5d                   	pop    %ebp
80106fe1:	c3                   	ret    
80106fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ff0 <switchuvm>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106ffc:	85 db                	test   %ebx,%ebx
80106ffe:	0f 84 cb 00 00 00    	je     801070cf <switchuvm+0xdf>
  if(p->kstack == 0)
80107004:	8b 43 08             	mov    0x8(%ebx),%eax
80107007:	85 c0                	test   %eax,%eax
80107009:	0f 84 da 00 00 00    	je     801070e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010700f:	8b 43 04             	mov    0x4(%ebx),%eax
80107012:	85 c0                	test   %eax,%eax
80107014:	0f 84 c2 00 00 00    	je     801070dc <switchuvm+0xec>
  pushcli();
8010701a:	e8 51 d9 ff ff       	call   80104970 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010701f:	e8 ec c7 ff ff       	call   80103810 <mycpu>
80107024:	89 c6                	mov    %eax,%esi
80107026:	e8 e5 c7 ff ff       	call   80103810 <mycpu>
8010702b:	89 c7                	mov    %eax,%edi
8010702d:	e8 de c7 ff ff       	call   80103810 <mycpu>
80107032:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107035:	83 c7 08             	add    $0x8,%edi
80107038:	e8 d3 c7 ff ff       	call   80103810 <mycpu>
8010703d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107040:	83 c0 08             	add    $0x8,%eax
80107043:	ba 67 00 00 00       	mov    $0x67,%edx
80107048:	c1 e8 18             	shr    $0x18,%eax
8010704b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107052:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107059:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010705f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107064:	83 c1 08             	add    $0x8,%ecx
80107067:	c1 e9 10             	shr    $0x10,%ecx
8010706a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107070:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107075:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010707c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107081:	e8 8a c7 ff ff       	call   80103810 <mycpu>
80107086:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010708d:	e8 7e c7 ff ff       	call   80103810 <mycpu>
80107092:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107096:	8b 73 08             	mov    0x8(%ebx),%esi
80107099:	e8 72 c7 ff ff       	call   80103810 <mycpu>
8010709e:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070a4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070a7:	e8 64 c7 ff ff       	call   80103810 <mycpu>
801070ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801070b0:	b8 28 00 00 00       	mov    $0x28,%eax
801070b5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801070b8:	8b 43 04             	mov    0x4(%ebx),%eax
801070bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070c0:	0f 22 d8             	mov    %eax,%cr3
}
801070c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c6:	5b                   	pop    %ebx
801070c7:	5e                   	pop    %esi
801070c8:	5f                   	pop    %edi
801070c9:	5d                   	pop    %ebp
  popcli();
801070ca:	e9 e1 d8 ff ff       	jmp    801049b0 <popcli>
    panic("switchuvm: no process");
801070cf:	83 ec 0c             	sub    $0xc,%esp
801070d2:	68 5a 80 10 80       	push   $0x8010805a
801070d7:	e8 b4 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801070dc:	83 ec 0c             	sub    $0xc,%esp
801070df:	68 85 80 10 80       	push   $0x80108085
801070e4:	e8 a7 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801070e9:	83 ec 0c             	sub    $0xc,%esp
801070ec:	68 70 80 10 80       	push   $0x80108070
801070f1:	e8 9a 92 ff ff       	call   80100390 <panic>
801070f6:	8d 76 00             	lea    0x0(%esi),%esi
801070f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107100 <inituvm>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 1c             	sub    $0x1c,%esp
80107109:	8b 75 10             	mov    0x10(%ebp),%esi
8010710c:	8b 45 08             	mov    0x8(%ebp),%eax
8010710f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107112:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107118:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010711b:	77 49                	ja     80107166 <inituvm+0x66>
  mem = kalloc();
8010711d:	e8 9e b3 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107122:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107125:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107127:	68 00 10 00 00       	push   $0x1000
8010712c:	6a 00                	push   $0x0
8010712e:	50                   	push   %eax
8010712f:	e8 1c da ff ff       	call   80104b50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107134:	58                   	pop    %eax
80107135:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010713b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107140:	5a                   	pop    %edx
80107141:	6a 06                	push   $0x6
80107143:	50                   	push   %eax
80107144:	31 d2                	xor    %edx,%edx
80107146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107149:	e8 c2 fc ff ff       	call   80106e10 <mappages>
  memmove(mem, init, sz);
8010714e:	89 75 10             	mov    %esi,0x10(%ebp)
80107151:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107154:	83 c4 10             	add    $0x10,%esp
80107157:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010715a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010715d:	5b                   	pop    %ebx
8010715e:	5e                   	pop    %esi
8010715f:	5f                   	pop    %edi
80107160:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107161:	e9 9a da ff ff       	jmp    80104c00 <memmove>
    panic("inituvm: more than a page");
80107166:	83 ec 0c             	sub    $0xc,%esp
80107169:	68 99 80 10 80       	push   $0x80108099
8010716e:	e8 1d 92 ff ff       	call   80100390 <panic>
80107173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <loaduvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107189:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107190:	0f 85 91 00 00 00    	jne    80107227 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107196:	8b 75 18             	mov    0x18(%ebp),%esi
80107199:	31 db                	xor    %ebx,%ebx
8010719b:	85 f6                	test   %esi,%esi
8010719d:	75 1a                	jne    801071b9 <loaduvm+0x39>
8010719f:	eb 6f                	jmp    80107210 <loaduvm+0x90>
801071a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801071b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801071b7:	76 57                	jbe    80107210 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801071b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801071bc:	8b 45 08             	mov    0x8(%ebp),%eax
801071bf:	31 c9                	xor    %ecx,%ecx
801071c1:	01 da                	add    %ebx,%edx
801071c3:	e8 c8 fb ff ff       	call   80106d90 <walkpgdir>
801071c8:	85 c0                	test   %eax,%eax
801071ca:	74 4e                	je     8010721a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801071cc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801071d1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801071d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071e1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071e4:	01 d9                	add    %ebx,%ecx
801071e6:	05 00 00 00 80       	add    $0x80000000,%eax
801071eb:	57                   	push   %edi
801071ec:	51                   	push   %ecx
801071ed:	50                   	push   %eax
801071ee:	ff 75 10             	pushl  0x10(%ebp)
801071f1:	e8 6a a7 ff ff       	call   80101960 <readi>
801071f6:	83 c4 10             	add    $0x10,%esp
801071f9:	39 f8                	cmp    %edi,%eax
801071fb:	74 ab                	je     801071a8 <loaduvm+0x28>
}
801071fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107205:	5b                   	pop    %ebx
80107206:	5e                   	pop    %esi
80107207:	5f                   	pop    %edi
80107208:	5d                   	pop    %ebp
80107209:	c3                   	ret    
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107213:	31 c0                	xor    %eax,%eax
}
80107215:	5b                   	pop    %ebx
80107216:	5e                   	pop    %esi
80107217:	5f                   	pop    %edi
80107218:	5d                   	pop    %ebp
80107219:	c3                   	ret    
      panic("loaduvm: address should exist");
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	68 b3 80 10 80       	push   $0x801080b3
80107222:	e8 69 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107227:	83 ec 0c             	sub    $0xc,%esp
8010722a:	68 54 81 10 80       	push   $0x80108154
8010722f:	e8 5c 91 ff ff       	call   80100390 <panic>
80107234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010723a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107240 <allocuvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107249:	8b 7d 10             	mov    0x10(%ebp),%edi
8010724c:	85 ff                	test   %edi,%edi
8010724e:	0f 88 8e 00 00 00    	js     801072e2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107254:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107257:	0f 82 93 00 00 00    	jb     801072f0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010725d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107260:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107266:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010726c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010726f:	0f 86 7e 00 00 00    	jbe    801072f3 <allocuvm+0xb3>
80107275:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107278:	8b 7d 08             	mov    0x8(%ebp),%edi
8010727b:	eb 42                	jmp    801072bf <allocuvm+0x7f>
8010727d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107280:	83 ec 04             	sub    $0x4,%esp
80107283:	68 00 10 00 00       	push   $0x1000
80107288:	6a 00                	push   $0x0
8010728a:	50                   	push   %eax
8010728b:	e8 c0 d8 ff ff       	call   80104b50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107290:	58                   	pop    %eax
80107291:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107297:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010729c:	5a                   	pop    %edx
8010729d:	6a 06                	push   $0x6
8010729f:	50                   	push   %eax
801072a0:	89 da                	mov    %ebx,%edx
801072a2:	89 f8                	mov    %edi,%eax
801072a4:	e8 67 fb ff ff       	call   80106e10 <mappages>
801072a9:	83 c4 10             	add    $0x10,%esp
801072ac:	85 c0                	test   %eax,%eax
801072ae:	78 50                	js     80107300 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801072b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072b6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801072b9:	0f 86 81 00 00 00    	jbe    80107340 <allocuvm+0x100>
    mem = kalloc();
801072bf:	e8 fc b1 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
801072c4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801072c6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801072c8:	75 b6                	jne    80107280 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801072ca:	83 ec 0c             	sub    $0xc,%esp
801072cd:	68 d1 80 10 80       	push   $0x801080d1
801072d2:	e8 89 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801072d7:	83 c4 10             	add    $0x10,%esp
801072da:	8b 45 0c             	mov    0xc(%ebp),%eax
801072dd:	39 45 10             	cmp    %eax,0x10(%ebp)
801072e0:	77 6e                	ja     80107350 <allocuvm+0x110>
}
801072e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801072e5:	31 ff                	xor    %edi,%edi
}
801072e7:	89 f8                	mov    %edi,%eax
801072e9:	5b                   	pop    %ebx
801072ea:	5e                   	pop    %esi
801072eb:	5f                   	pop    %edi
801072ec:	5d                   	pop    %ebp
801072ed:	c3                   	ret    
801072ee:	66 90                	xchg   %ax,%ax
    return oldsz;
801072f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801072f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f6:	89 f8                	mov    %edi,%eax
801072f8:	5b                   	pop    %ebx
801072f9:	5e                   	pop    %esi
801072fa:	5f                   	pop    %edi
801072fb:	5d                   	pop    %ebp
801072fc:	c3                   	ret    
801072fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107300:	83 ec 0c             	sub    $0xc,%esp
80107303:	68 e9 80 10 80       	push   $0x801080e9
80107308:	e8 53 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010730d:	83 c4 10             	add    $0x10,%esp
80107310:	8b 45 0c             	mov    0xc(%ebp),%eax
80107313:	39 45 10             	cmp    %eax,0x10(%ebp)
80107316:	76 0d                	jbe    80107325 <allocuvm+0xe5>
80107318:	89 c1                	mov    %eax,%ecx
8010731a:	8b 55 10             	mov    0x10(%ebp),%edx
8010731d:	8b 45 08             	mov    0x8(%ebp),%eax
80107320:	e8 7b fb ff ff       	call   80106ea0 <deallocuvm.part.0>
      kfree(mem);
80107325:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107328:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010732a:	56                   	push   %esi
8010732b:	e8 e0 af ff ff       	call   80102310 <kfree>
      return 0;
80107330:	83 c4 10             	add    $0x10,%esp
}
80107333:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107336:	89 f8                	mov    %edi,%eax
80107338:	5b                   	pop    %ebx
80107339:	5e                   	pop    %esi
8010733a:	5f                   	pop    %edi
8010733b:	5d                   	pop    %ebp
8010733c:	c3                   	ret    
8010733d:	8d 76 00             	lea    0x0(%esi),%esi
80107340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107346:	5b                   	pop    %ebx
80107347:	89 f8                	mov    %edi,%eax
80107349:	5e                   	pop    %esi
8010734a:	5f                   	pop    %edi
8010734b:	5d                   	pop    %ebp
8010734c:	c3                   	ret    
8010734d:	8d 76 00             	lea    0x0(%esi),%esi
80107350:	89 c1                	mov    %eax,%ecx
80107352:	8b 55 10             	mov    0x10(%ebp),%edx
80107355:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107358:	31 ff                	xor    %edi,%edi
8010735a:	e8 41 fb ff ff       	call   80106ea0 <deallocuvm.part.0>
8010735f:	eb 92                	jmp    801072f3 <allocuvm+0xb3>
80107361:	eb 0d                	jmp    80107370 <deallocuvm>
80107363:	90                   	nop
80107364:	90                   	nop
80107365:	90                   	nop
80107366:	90                   	nop
80107367:	90                   	nop
80107368:	90                   	nop
80107369:	90                   	nop
8010736a:	90                   	nop
8010736b:	90                   	nop
8010736c:	90                   	nop
8010736d:	90                   	nop
8010736e:	90                   	nop
8010736f:	90                   	nop

80107370 <deallocuvm>:
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	8b 55 0c             	mov    0xc(%ebp),%edx
80107376:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107379:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010737c:	39 d1                	cmp    %edx,%ecx
8010737e:	73 10                	jae    80107390 <deallocuvm+0x20>
}
80107380:	5d                   	pop    %ebp
80107381:	e9 1a fb ff ff       	jmp    80106ea0 <deallocuvm.part.0>
80107386:	8d 76 00             	lea    0x0(%esi),%esi
80107389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107390:	89 d0                	mov    %edx,%eax
80107392:	5d                   	pop    %ebp
80107393:	c3                   	ret    
80107394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010739a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801073a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	83 ec 0c             	sub    $0xc,%esp
801073a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801073ac:	85 f6                	test   %esi,%esi
801073ae:	74 59                	je     80107409 <freevm+0x69>
801073b0:	31 c9                	xor    %ecx,%ecx
801073b2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073b7:	89 f0                	mov    %esi,%eax
801073b9:	e8 e2 fa ff ff       	call   80106ea0 <deallocuvm.part.0>
801073be:	89 f3                	mov    %esi,%ebx
801073c0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801073c6:	eb 0f                	jmp    801073d7 <freevm+0x37>
801073c8:	90                   	nop
801073c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073d0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801073d3:	39 fb                	cmp    %edi,%ebx
801073d5:	74 23                	je     801073fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801073d7:	8b 03                	mov    (%ebx),%eax
801073d9:	a8 01                	test   $0x1,%al
801073db:	74 f3                	je     801073d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801073e2:	83 ec 0c             	sub    $0xc,%esp
801073e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801073ed:	50                   	push   %eax
801073ee:	e8 1d af ff ff       	call   80102310 <kfree>
801073f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073f6:	39 fb                	cmp    %edi,%ebx
801073f8:	75 dd                	jne    801073d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801073fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107400:	5b                   	pop    %ebx
80107401:	5e                   	pop    %esi
80107402:	5f                   	pop    %edi
80107403:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107404:	e9 07 af ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107409:	83 ec 0c             	sub    $0xc,%esp
8010740c:	68 05 81 10 80       	push   $0x80108105
80107411:	e8 7a 8f ff ff       	call   80100390 <panic>
80107416:	8d 76 00             	lea    0x0(%esi),%esi
80107419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107420 <setupkvm>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	56                   	push   %esi
80107424:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107425:	e8 96 b0 ff ff       	call   801024c0 <kalloc>
8010742a:	85 c0                	test   %eax,%eax
8010742c:	89 c6                	mov    %eax,%esi
8010742e:	74 42                	je     80107472 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107430:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107433:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107438:	68 00 10 00 00       	push   $0x1000
8010743d:	6a 00                	push   $0x0
8010743f:	50                   	push   %eax
80107440:	e8 0b d7 ff ff       	call   80104b50 <memset>
80107445:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107448:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010744b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010744e:	83 ec 08             	sub    $0x8,%esp
80107451:	8b 13                	mov    (%ebx),%edx
80107453:	ff 73 0c             	pushl  0xc(%ebx)
80107456:	50                   	push   %eax
80107457:	29 c1                	sub    %eax,%ecx
80107459:	89 f0                	mov    %esi,%eax
8010745b:	e8 b0 f9 ff ff       	call   80106e10 <mappages>
80107460:	83 c4 10             	add    $0x10,%esp
80107463:	85 c0                	test   %eax,%eax
80107465:	78 19                	js     80107480 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107467:	83 c3 10             	add    $0x10,%ebx
8010746a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107470:	75 d6                	jne    80107448 <setupkvm+0x28>
}
80107472:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107475:	89 f0                	mov    %esi,%eax
80107477:	5b                   	pop    %ebx
80107478:	5e                   	pop    %esi
80107479:	5d                   	pop    %ebp
8010747a:	c3                   	ret    
8010747b:	90                   	nop
8010747c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107480:	83 ec 0c             	sub    $0xc,%esp
80107483:	56                   	push   %esi
      return 0;
80107484:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107486:	e8 15 ff ff ff       	call   801073a0 <freevm>
      return 0;
8010748b:	83 c4 10             	add    $0x10,%esp
}
8010748e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107491:	89 f0                	mov    %esi,%eax
80107493:	5b                   	pop    %ebx
80107494:	5e                   	pop    %esi
80107495:	5d                   	pop    %ebp
80107496:	c3                   	ret    
80107497:	89 f6                	mov    %esi,%esi
80107499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074a0 <kvmalloc>:
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801074a6:	e8 75 ff ff ff       	call   80107420 <setupkvm>
801074ab:	a3 24 77 11 80       	mov    %eax,0x80117724
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074b0:	05 00 00 00 80       	add    $0x80000000,%eax
801074b5:	0f 22 d8             	mov    %eax,%cr3
}
801074b8:	c9                   	leave  
801074b9:	c3                   	ret    
801074ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801074c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074c1:	31 c9                	xor    %ecx,%ecx
{
801074c3:	89 e5                	mov    %esp,%ebp
801074c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074cb:	8b 45 08             	mov    0x8(%ebp),%eax
801074ce:	e8 bd f8 ff ff       	call   80106d90 <walkpgdir>
  if(pte == 0)
801074d3:	85 c0                	test   %eax,%eax
801074d5:	74 05                	je     801074dc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801074d7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074da:	c9                   	leave  
801074db:	c3                   	ret    
    panic("clearpteu");
801074dc:	83 ec 0c             	sub    $0xc,%esp
801074df:	68 16 81 10 80       	push   $0x80108116
801074e4:	e8 a7 8e ff ff       	call   80100390 <panic>
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074f9:	e8 22 ff ff ff       	call   80107420 <setupkvm>
801074fe:	85 c0                	test   %eax,%eax
80107500:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107503:	0f 84 9f 00 00 00    	je     801075a8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107509:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010750c:	85 c9                	test   %ecx,%ecx
8010750e:	0f 84 94 00 00 00    	je     801075a8 <copyuvm+0xb8>
80107514:	31 ff                	xor    %edi,%edi
80107516:	eb 4a                	jmp    80107562 <copyuvm+0x72>
80107518:	90                   	nop
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107520:	83 ec 04             	sub    $0x4,%esp
80107523:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107529:	68 00 10 00 00       	push   $0x1000
8010752e:	53                   	push   %ebx
8010752f:	50                   	push   %eax
80107530:	e8 cb d6 ff ff       	call   80104c00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107535:	58                   	pop    %eax
80107536:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010753c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107541:	5a                   	pop    %edx
80107542:	ff 75 e4             	pushl  -0x1c(%ebp)
80107545:	50                   	push   %eax
80107546:	89 fa                	mov    %edi,%edx
80107548:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010754b:	e8 c0 f8 ff ff       	call   80106e10 <mappages>
80107550:	83 c4 10             	add    $0x10,%esp
80107553:	85 c0                	test   %eax,%eax
80107555:	78 61                	js     801075b8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107557:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010755d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107560:	76 46                	jbe    801075a8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107562:	8b 45 08             	mov    0x8(%ebp),%eax
80107565:	31 c9                	xor    %ecx,%ecx
80107567:	89 fa                	mov    %edi,%edx
80107569:	e8 22 f8 ff ff       	call   80106d90 <walkpgdir>
8010756e:	85 c0                	test   %eax,%eax
80107570:	74 61                	je     801075d3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107572:	8b 00                	mov    (%eax),%eax
80107574:	a8 01                	test   $0x1,%al
80107576:	74 4e                	je     801075c6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107578:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010757a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010757f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107588:	e8 33 af ff ff       	call   801024c0 <kalloc>
8010758d:	85 c0                	test   %eax,%eax
8010758f:	89 c6                	mov    %eax,%esi
80107591:	75 8d                	jne    80107520 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107593:	83 ec 0c             	sub    $0xc,%esp
80107596:	ff 75 e0             	pushl  -0x20(%ebp)
80107599:	e8 02 fe ff ff       	call   801073a0 <freevm>
  return 0;
8010759e:	83 c4 10             	add    $0x10,%esp
801075a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801075a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ae:	5b                   	pop    %ebx
801075af:	5e                   	pop    %esi
801075b0:	5f                   	pop    %edi
801075b1:	5d                   	pop    %ebp
801075b2:	c3                   	ret    
801075b3:	90                   	nop
801075b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801075b8:	83 ec 0c             	sub    $0xc,%esp
801075bb:	56                   	push   %esi
801075bc:	e8 4f ad ff ff       	call   80102310 <kfree>
      goto bad;
801075c1:	83 c4 10             	add    $0x10,%esp
801075c4:	eb cd                	jmp    80107593 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801075c6:	83 ec 0c             	sub    $0xc,%esp
801075c9:	68 3a 81 10 80       	push   $0x8010813a
801075ce:	e8 bd 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801075d3:	83 ec 0c             	sub    $0xc,%esp
801075d6:	68 20 81 10 80       	push   $0x80108120
801075db:	e8 b0 8d ff ff       	call   80100390 <panic>

801075e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075e1:	31 c9                	xor    %ecx,%ecx
{
801075e3:	89 e5                	mov    %esp,%ebp
801075e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075eb:	8b 45 08             	mov    0x8(%ebp),%eax
801075ee:	e8 9d f7 ff ff       	call   80106d90 <walkpgdir>
  if((*pte & PTE_P) == 0)
801075f3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801075f5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801075f6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801075fd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107600:	05 00 00 00 80       	add    $0x80000000,%eax
80107605:	83 fa 05             	cmp    $0x5,%edx
80107608:	ba 00 00 00 00       	mov    $0x0,%edx
8010760d:	0f 45 c2             	cmovne %edx,%eax
}
80107610:	c3                   	ret    
80107611:	eb 0d                	jmp    80107620 <copyout>
80107613:	90                   	nop
80107614:	90                   	nop
80107615:	90                   	nop
80107616:	90                   	nop
80107617:	90                   	nop
80107618:	90                   	nop
80107619:	90                   	nop
8010761a:	90                   	nop
8010761b:	90                   	nop
8010761c:	90                   	nop
8010761d:	90                   	nop
8010761e:	90                   	nop
8010761f:	90                   	nop

80107620 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 1c             	sub    $0x1c,%esp
80107629:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010762c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010762f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107632:	85 db                	test   %ebx,%ebx
80107634:	75 40                	jne    80107676 <copyout+0x56>
80107636:	eb 70                	jmp    801076a8 <copyout+0x88>
80107638:	90                   	nop
80107639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107643:	89 f1                	mov    %esi,%ecx
80107645:	29 d1                	sub    %edx,%ecx
80107647:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010764d:	39 d9                	cmp    %ebx,%ecx
8010764f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107652:	29 f2                	sub    %esi,%edx
80107654:	83 ec 04             	sub    $0x4,%esp
80107657:	01 d0                	add    %edx,%eax
80107659:	51                   	push   %ecx
8010765a:	57                   	push   %edi
8010765b:	50                   	push   %eax
8010765c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010765f:	e8 9c d5 ff ff       	call   80104c00 <memmove>
    len -= n;
    buf += n;
80107664:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107667:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010766a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107670:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107672:	29 cb                	sub    %ecx,%ebx
80107674:	74 32                	je     801076a8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107676:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107678:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010767b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010767e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107684:	56                   	push   %esi
80107685:	ff 75 08             	pushl  0x8(%ebp)
80107688:	e8 53 ff ff ff       	call   801075e0 <uva2ka>
    if(pa0 == 0)
8010768d:	83 c4 10             	add    $0x10,%esp
80107690:	85 c0                	test   %eax,%eax
80107692:	75 ac                	jne    80107640 <copyout+0x20>
  }
  return 0;
}
80107694:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010769c:	5b                   	pop    %ebx
8010769d:	5e                   	pop    %esi
8010769e:	5f                   	pop    %edi
8010769f:	5d                   	pop    %ebp
801076a0:	c3                   	ret    
801076a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076ab:	31 c0                	xor    %eax,%eax
}
801076ad:	5b                   	pop    %ebx
801076ae:	5e                   	pop    %esi
801076af:	5f                   	pop    %edi
801076b0:	5d                   	pop    %ebp
801076b1:	c3                   	ret    
