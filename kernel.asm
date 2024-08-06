
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot_header>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4                   	.byte 0xe4

0010000c <_start>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
  10000c:	bc e0 3c 10 00       	mov    $0x103ce0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
  100011:	b8 80 06 10 00       	mov    $0x100680,%eax
  jmp *%eax
  100016:	ff e0                	jmp    *%eax
  100018:	66 90                	xchg   %ax,%ax
  10001a:	66 90                	xchg   %ax,%ax
  10001c:	66 90                	xchg   %ax,%ax
  10001e:	66 90                	xchg   %ax,%ax

00100020 <printint>:
static void consputc(int);
static int panicked = 0;

static void
printint(int xx, int base, int sign)
{
  100020:	55                   	push   %ebp
  100021:	89 e5                	mov    %esp,%ebp
  100023:	57                   	push   %edi
  100024:	56                   	push   %esi
  100025:	53                   	push   %ebx
  100026:	89 d3                	mov    %edx,%ebx
  100028:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
  10002b:	85 c0                	test   %eax,%eax
  10002d:	79 05                	jns    100034 <printint+0x14>
  10002f:	83 e1 01             	and    $0x1,%ecx
  100032:	75 6c                	jne    1000a0 <printint+0x80>
    x = -xx;
  else
    x = xx;
  100034:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  10003b:	89 c1                	mov    %eax,%ecx

  i = 0;
  10003d:	31 f6                	xor    %esi,%esi
  10003f:	90                   	nop
  do{
    buf[i++] = digits[x % base];
  100040:	89 c8                	mov    %ecx,%eax
  100042:	31 d2                	xor    %edx,%edx
  100044:	89 f7                	mov    %esi,%edi
  100046:	f7 f3                	div    %ebx
  100048:	8d 76 01             	lea    0x1(%esi),%esi
  10004b:	0f b6 92 18 1c 10 00 	movzbl 0x101c18(%edx),%edx
  100052:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
  100056:	89 ca                	mov    %ecx,%edx
  100058:	89 c1                	mov    %eax,%ecx
  10005a:	39 da                	cmp    %ebx,%edx
  10005c:	73 e2                	jae    100040 <printint+0x20>

  if(sign)
  10005e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100061:	85 c0                	test   %eax,%eax
  100063:	74 07                	je     10006c <printint+0x4c>
    buf[i++] = '-';
  100065:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
  10006a:	89 f7                	mov    %esi,%edi
  10006c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  10006f:	01 df                	add    %ebx,%edi
  100071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
  100078:	0f be 07             	movsbl (%edi),%eax
consputc(int c)
{
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  10007b:	83 ec 0c             	sub    $0xc,%esp
  10007e:	50                   	push   %eax
  10007f:	e8 cc 09 00 00       	call   100a50 <uartputc>
  while(--i >= 0)
  100084:	89 f8                	mov    %edi,%eax
  100086:	83 c4 10             	add    $0x10,%esp
  100089:	83 ef 01             	sub    $0x1,%edi
  10008c:	39 d8                	cmp    %ebx,%eax
  10008e:	75 e8                	jne    100078 <printint+0x58>
}
  100090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100093:	5b                   	pop    %ebx
  100094:	5e                   	pop    %esi
  100095:	5f                   	pop    %edi
  100096:	5d                   	pop    %ebp
  100097:	c3                   	ret
  100098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10009f:	90                   	nop
    x = -xx;
  1000a0:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
  1000a2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
  1000a9:	89 c1                	mov    %eax,%ecx
  1000ab:	eb 90                	jmp    10003d <printint+0x1d>
  1000ad:	8d 76 00             	lea    0x0(%esi),%esi

001000b0 <cprintf>:
{
  1000b0:	55                   	push   %ebp
  1000b1:	89 e5                	mov    %esp,%ebp
  1000b3:	57                   	push   %edi
  1000b4:	56                   	push   %esi
  1000b5:	53                   	push   %ebx
  1000b6:	83 ec 1c             	sub    $0x1c,%esp
  if (fmt == 0)
  1000b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1000bc:	85 f6                	test   %esi,%esi
  1000be:	74 7d                	je     10013d <cprintf+0x8d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  1000c0:	0f b6 06             	movzbl (%esi),%eax
  1000c3:	85 c0                	test   %eax,%eax
  1000c5:	74 76                	je     10013d <cprintf+0x8d>
  argp = (uint*)(void*)(&fmt + 1);
  1000c7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  1000ca:	31 db                	xor    %ebx,%ebx
  1000cc:	eb 4d                	jmp    10011b <cprintf+0x6b>
  1000ce:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
  1000d0:	83 c3 01             	add    $0x1,%ebx
  1000d3:	0f b6 3c 1e          	movzbl (%esi,%ebx,1),%edi
    if(c == 0)
  1000d7:	85 ff                	test   %edi,%edi
  1000d9:	74 62                	je     10013d <cprintf+0x8d>
    switch(c){
  1000db:	83 ff 70             	cmp    $0x70,%edi
  1000de:	0f 84 ec 00 00 00    	je     1001d0 <cprintf+0x120>
  1000e4:	7f 62                	jg     100148 <cprintf+0x98>
  1000e6:	83 ff 25             	cmp    $0x25,%edi
  1000e9:	0f 84 c1 00 00 00    	je     1001b0 <cprintf+0x100>
  1000ef:	83 ff 64             	cmp    $0x64,%edi
  1000f2:	75 5e                	jne    100152 <cprintf+0xa2>
      printint(*argp++, 10, 1);
  1000f4:	8b 01                	mov    (%ecx),%eax
  1000f6:	8d 79 04             	lea    0x4(%ecx),%edi
  1000f9:	ba 0a 00 00 00       	mov    $0xa,%edx
  1000fe:	b9 01 00 00 00       	mov    $0x1,%ecx
  100103:	e8 18 ff ff ff       	call   100020 <printint>
  100108:	89 f9                	mov    %edi,%ecx
  10010a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100110:	83 c3 01             	add    $0x1,%ebx
  100113:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
  100117:	85 c0                	test   %eax,%eax
  100119:	74 22                	je     10013d <cprintf+0x8d>
    if(c != '%'){
  10011b:	83 f8 25             	cmp    $0x25,%eax
  10011e:	74 b0                	je     1000d0 <cprintf+0x20>
    uartputc(c);
  100120:	83 ec 0c             	sub    $0xc,%esp
  100123:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100126:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
  100129:	50                   	push   %eax
  10012a:	e8 21 09 00 00       	call   100a50 <uartputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10012f:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
  100133:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  100136:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100139:	85 c0                	test   %eax,%eax
  10013b:	75 de                	jne    10011b <cprintf+0x6b>
}
  10013d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100140:	5b                   	pop    %ebx
  100141:	5e                   	pop    %esi
  100142:	5f                   	pop    %edi
  100143:	5d                   	pop    %ebp
  100144:	c3                   	ret
  100145:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
  100148:	83 ff 73             	cmp    $0x73,%edi
  10014b:	74 23                	je     100170 <cprintf+0xc0>
  10014d:	83 ff 78             	cmp    $0x78,%edi
  100150:	74 7e                	je     1001d0 <cprintf+0x120>
    uartputc(c);
  100152:	83 ec 0c             	sub    $0xc,%esp
  100155:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  100158:	6a 25                	push   $0x25
  10015a:	e8 f1 08 00 00       	call   100a50 <uartputc>
  10015f:	89 3c 24             	mov    %edi,(%esp)
  100162:	e8 e9 08 00 00       	call   100a50 <uartputc>
  100167:	83 c4 10             	add    $0x10,%esp
  10016a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10016d:	eb a1                	jmp    100110 <cprintf+0x60>
  10016f:	90                   	nop
      if((s = (char*)*argp++) == 0)
  100170:	8b 11                	mov    (%ecx),%edx
  100172:	8d 41 04             	lea    0x4(%ecx),%eax
  100175:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100178:	85 d2                	test   %edx,%edx
  10017a:	74 74                	je     1001f0 <cprintf+0x140>
      for(; *s; s++)
  10017c:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
  10017f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  100182:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
  100184:	84 c0                	test   %al,%al
  100186:	74 88                	je     100110 <cprintf+0x60>
  100188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10018f:	90                   	nop
    uartputc(c);
  100190:	83 ec 0c             	sub    $0xc,%esp
      for(; *s; s++)
  100193:	83 c7 01             	add    $0x1,%edi
    uartputc(c);
  100196:	50                   	push   %eax
  100197:	e8 b4 08 00 00       	call   100a50 <uartputc>
      for(; *s; s++)
  10019c:	0f be 07             	movsbl (%edi),%eax
  10019f:	83 c4 10             	add    $0x10,%esp
  1001a2:	84 c0                	test   %al,%al
  1001a4:	75 ea                	jne    100190 <cprintf+0xe0>
  1001a6:	eb c2                	jmp    10016a <cprintf+0xba>
  1001a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1001af:	90                   	nop
    uartputc(c);
  1001b0:	83 ec 0c             	sub    $0xc,%esp
  1001b3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1001b6:	6a 25                	push   $0x25
  1001b8:	e8 93 08 00 00       	call   100a50 <uartputc>
}
  1001bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1001c0:	83 c4 10             	add    $0x10,%esp
  1001c3:	e9 48 ff ff ff       	jmp    100110 <cprintf+0x60>
  1001c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1001cf:	90                   	nop
      printint(*argp++, 16, 0);
  1001d0:	8b 01                	mov    (%ecx),%eax
  1001d2:	8d 79 04             	lea    0x4(%ecx),%edi
  1001d5:	ba 10 00 00 00       	mov    $0x10,%edx
  1001da:	31 c9                	xor    %ecx,%ecx
  1001dc:	e8 3f fe ff ff       	call   100020 <printint>
  1001e1:	89 f9                	mov    %edi,%ecx
      break;
  1001e3:	e9 28 ff ff ff       	jmp    100110 <cprintf+0x60>
  1001e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1001ef:	90                   	nop
  1001f0:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
  1001f5:	bf 7c 1b 10 00       	mov    $0x101b7c,%edi
  1001fa:	eb 94                	jmp    100190 <cprintf+0xe0>
  1001fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100200 <halt>:
{
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 10             	sub    $0x10,%esp
  cprintf("Bye COL%d!\n\0", 331);
  100206:	68 4b 01 00 00       	push   $0x14b
  10020b:	68 08 1c 10 00       	push   $0x101c08
  100210:	e8 9b fe ff ff       	call   1000b0 <cprintf>
}

static inline void
outw(ushort port, ushort data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100215:	b8 00 20 00 00       	mov    $0x2000,%eax
  10021a:	ba 02 06 00 00       	mov    $0x602,%edx
  10021f:	66 ef                	out    %ax,(%dx)
  100221:	ba 02 b0 ff ff       	mov    $0xffffb002,%edx
  100226:	66 ef                	out    %ax,(%dx)
}
  100228:	83 c4 10             	add    $0x10,%esp
  for(;;);
  10022b:	eb fe                	jmp    10022b <halt+0x2b>
  10022d:	8d 76 00             	lea    0x0(%esi),%esi

00100230 <panic>:
{
  100230:	55                   	push   %ebp
  100231:	89 e5                	mov    %esp,%ebp
  100233:	56                   	push   %esi
  100234:	53                   	push   %ebx
  100235:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
  100238:	fa                   	cli
  cprintf("lapicid %d: panic: ", lapicid());
  100239:	e8 f2 03 00 00       	call   100630 <lapicid>
  10023e:	83 ec 08             	sub    $0x8,%esp
  getcallerpcs(&s, pcs);
  100241:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  100244:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
  100247:	50                   	push   %eax
  100248:	68 83 1b 10 00       	push   $0x101b83
  10024d:	e8 5e fe ff ff       	call   1000b0 <cprintf>
  cprintf(s);
  100252:	58                   	pop    %eax
  100253:	ff 75 08             	push   0x8(%ebp)
  100256:	e8 55 fe ff ff       	call   1000b0 <cprintf>
  cprintf("\n");
  10025b:	c7 04 24 c3 1b 10 00 	movl   $0x101bc3,(%esp)
  100262:	e8 49 fe ff ff       	call   1000b0 <cprintf>
  getcallerpcs(&s, pcs);
  100267:	8d 45 08             	lea    0x8(%ebp),%eax
  10026a:	5a                   	pop    %edx
  10026b:	59                   	pop    %ecx
  10026c:	53                   	push   %ebx
  10026d:	50                   	push   %eax
  10026e:	e8 cd 0a 00 00       	call   100d40 <getcallerpcs>
  for(i=0; i<10; i++)
  100273:	83 c4 10             	add    $0x10,%esp
  100276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10027d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf(" %p", pcs[i]);
  100280:	83 ec 08             	sub    $0x8,%esp
  100283:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
  100285:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
  100288:	68 97 1b 10 00       	push   $0x101b97
  10028d:	e8 1e fe ff ff       	call   1000b0 <cprintf>
  for(i=0; i<10; i++)
  100292:	83 c4 10             	add    $0x10,%esp
  100295:	39 f3                	cmp    %esi,%ebx
  100297:	75 e7                	jne    100280 <panic+0x50>
  halt();
  100299:	e8 62 ff ff ff       	call   100200 <halt>
  10029e:	66 90                	xchg   %ax,%ax

001002a0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  1002a0:	55                   	push   %ebp
  1002a1:	89 e5                	mov    %esp,%ebp
  1002a3:	53                   	push   %ebx
  1002a4:	83 ec 14             	sub    $0x14,%esp
  1002a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  while((c = getc()) >= 0){
  1002aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1002b0:	ff d3                	call   *%ebx
  1002b2:	85 c0                	test   %eax,%eax
  1002b4:	0f 88 9b 00 00 00    	js     100355 <consoleintr+0xb5>
    switch(c){
  1002ba:	83 f8 15             	cmp    $0x15,%eax
  1002bd:	0f 84 9d 00 00 00    	je     100360 <consoleintr+0xc0>
  1002c3:	83 f8 7f             	cmp    $0x7f,%eax
  1002c6:	0f 84 04 01 00 00    	je     1003d0 <consoleintr+0x130>
  1002cc:	83 f8 08             	cmp    $0x8,%eax
  1002cf:	0f 84 fb 00 00 00    	je     1003d0 <consoleintr+0x130>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  1002d5:	85 c0                	test   %eax,%eax
  1002d7:	74 d7                	je     1002b0 <consoleintr+0x10>
  1002d9:	8b 15 88 24 10 00    	mov    0x102488,%edx
  1002df:	89 d1                	mov    %edx,%ecx
  1002e1:	2b 0d 80 24 10 00    	sub    0x102480,%ecx
  1002e7:	83 f9 7f             	cmp    $0x7f,%ecx
  1002ea:	77 c4                	ja     1002b0 <consoleintr+0x10>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
  1002ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  1002ef:	83 e2 7f             	and    $0x7f,%edx
  1002f2:	89 0d 88 24 10 00    	mov    %ecx,0x102488
        c = (c == '\r') ? '\n' : c;
  1002f8:	83 f8 0d             	cmp    $0xd,%eax
  1002fb:	0f 84 12 01 00 00    	je     100413 <consoleintr+0x173>
        input.buf[input.e++ % INPUT_BUF] = c;
  100301:	88 82 00 24 10 00    	mov    %al,0x102400(%edx)
  if(c == BACKSPACE){
  100307:	3d 00 01 00 00       	cmp    $0x100,%eax
  10030c:	0f 85 24 01 00 00    	jne    100436 <consoleintr+0x196>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  100312:	83 ec 0c             	sub    $0xc,%esp
  100315:	6a 08                	push   $0x8
  100317:	e8 34 07 00 00       	call   100a50 <uartputc>
  10031c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100323:	e8 28 07 00 00       	call   100a50 <uartputc>
  100328:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10032f:	e8 1c 07 00 00       	call   100a50 <uartputc>
  100334:	83 c4 10             	add    $0x10,%esp
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100337:	a1 80 24 10 00       	mov    0x102480,%eax
  10033c:	83 e8 80             	sub    $0xffffff80,%eax
  10033f:	39 05 88 24 10 00    	cmp    %eax,0x102488
  100345:	0f 84 e1 00 00 00    	je     10042c <consoleintr+0x18c>
  while((c = getc()) >= 0){
  10034b:	ff d3                	call   *%ebx
  10034d:	85 c0                	test   %eax,%eax
  10034f:	0f 89 65 ff ff ff    	jns    1002ba <consoleintr+0x1a>
        }
      }
      break;
    }
  }
  100355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100358:	c9                   	leave
  100359:	c3                   	ret
  10035a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
  100360:	a1 88 24 10 00       	mov    0x102488,%eax
  100365:	39 05 84 24 10 00    	cmp    %eax,0x102484
  10036b:	75 46                	jne    1003b3 <consoleintr+0x113>
  10036d:	e9 3e ff ff ff       	jmp    1002b0 <consoleintr+0x10>
  100372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
  100378:	83 ec 0c             	sub    $0xc,%esp
        input.e--;
  10037b:	a3 88 24 10 00       	mov    %eax,0x102488
    uartputc('\b'); uartputc(' '); uartputc('\b');
  100380:	6a 08                	push   $0x8
  100382:	e8 c9 06 00 00       	call   100a50 <uartputc>
  100387:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10038e:	e8 bd 06 00 00       	call   100a50 <uartputc>
  100393:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10039a:	e8 b1 06 00 00       	call   100a50 <uartputc>
      while(input.e != input.w &&
  10039f:	a1 88 24 10 00       	mov    0x102488,%eax
  1003a4:	83 c4 10             	add    $0x10,%esp
  1003a7:	3b 05 84 24 10 00    	cmp    0x102484,%eax
  1003ad:	0f 84 fd fe ff ff    	je     1002b0 <consoleintr+0x10>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1003b3:	83 e8 01             	sub    $0x1,%eax
  1003b6:	89 c2                	mov    %eax,%edx
  1003b8:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
  1003bb:	80 ba 00 24 10 00 0a 	cmpb   $0xa,0x102400(%edx)
  1003c2:	75 b4                	jne    100378 <consoleintr+0xd8>
  1003c4:	e9 e7 fe ff ff       	jmp    1002b0 <consoleintr+0x10>
  1003c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
  1003d0:	a1 88 24 10 00       	mov    0x102488,%eax
  1003d5:	3b 05 84 24 10 00    	cmp    0x102484,%eax
  1003db:	0f 84 cf fe ff ff    	je     1002b0 <consoleintr+0x10>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  1003e1:	83 ec 0c             	sub    $0xc,%esp
        input.e--;
  1003e4:	83 e8 01             	sub    $0x1,%eax
    uartputc('\b'); uartputc(' '); uartputc('\b');
  1003e7:	6a 08                	push   $0x8
        input.e--;
  1003e9:	a3 88 24 10 00       	mov    %eax,0x102488
    uartputc('\b'); uartputc(' '); uartputc('\b');
  1003ee:	e8 5d 06 00 00       	call   100a50 <uartputc>
  1003f3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1003fa:	e8 51 06 00 00       	call   100a50 <uartputc>
  1003ff:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100406:	e8 45 06 00 00       	call   100a50 <uartputc>
  10040b:	83 c4 10             	add    $0x10,%esp
  10040e:	e9 9d fe ff ff       	jmp    1002b0 <consoleintr+0x10>
    uartputc(c);
  100413:	83 ec 0c             	sub    $0xc,%esp
        input.buf[input.e++ % INPUT_BUF] = c;
  100416:	c6 82 00 24 10 00 0a 	movb   $0xa,0x102400(%edx)
    uartputc(c);
  10041d:	6a 0a                	push   $0xa
  10041f:	e8 2c 06 00 00       	call   100a50 <uartputc>
          input.w = input.e;
  100424:	a1 88 24 10 00       	mov    0x102488,%eax
  100429:	83 c4 10             	add    $0x10,%esp
  10042c:	a3 84 24 10 00       	mov    %eax,0x102484
  100431:	e9 7a fe ff ff       	jmp    1002b0 <consoleintr+0x10>
    uartputc(c);
  100436:	83 ec 0c             	sub    $0xc,%esp
  100439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10043c:	50                   	push   %eax
  10043d:	e8 0e 06 00 00       	call   100a50 <uartputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100445:	83 c4 10             	add    $0x10,%esp
  100448:	83 f8 0a             	cmp    $0xa,%eax
  10044b:	74 09                	je     100456 <consoleintr+0x1b6>
  10044d:	83 f8 04             	cmp    $0x4,%eax
  100450:	0f 85 e1 fe ff ff    	jne    100337 <consoleintr+0x97>
          input.w = input.e;
  100456:	a1 88 24 10 00       	mov    0x102488,%eax
  10045b:	eb cf                	jmp    10042c <consoleintr+0x18c>
  10045d:	66 90                	xchg   %ax,%ax
  10045f:	90                   	nop

00100460 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
  100460:	55                   	push   %ebp
  100461:	89 e5                	mov    %esp,%ebp
  100463:	56                   	push   %esi
  100464:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  100465:	c7 05 8c 24 10 00 00 	movl   $0xfec00000,0x10248c
  10046c:	00 c0 fe 
  ioapic->reg = reg;
  10046f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  100476:	00 00 00 
  return ioapic->data;
  100479:	8b 15 8c 24 10 00    	mov    0x10248c,%edx
  10047f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
  100482:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
  100488:	8b 1d 8c 24 10 00    	mov    0x10248c,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  10048e:	0f b6 15 94 24 10 00 	movzbl 0x102494,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  100495:	c1 ee 10             	shr    $0x10,%esi
  100498:	89 f0                	mov    %esi,%eax
  10049a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
  10049d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
  1004a0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
  1004a3:	39 c2                	cmp    %eax,%edx
  1004a5:	74 16                	je     1004bd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  1004a7:	83 ec 0c             	sub    $0xc,%esp
  1004aa:	68 2c 1c 10 00       	push   $0x101c2c
  1004af:	e8 fc fb ff ff       	call   1000b0 <cprintf>
  ioapic->reg = reg;
  1004b4:	8b 1d 8c 24 10 00    	mov    0x10248c,%ebx
  1004ba:	83 c4 10             	add    $0x10,%esp
{
  1004bd:	ba 10 00 00 00       	mov    $0x10,%edx
  1004c2:	31 c0                	xor    %eax,%eax
  1004c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
  1004c8:	89 13                	mov    %edx,(%ebx)
  1004ca:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
  1004cd:	8b 1d 8c 24 10 00    	mov    0x10248c,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1004d3:	83 c0 01             	add    $0x1,%eax
  1004d6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
  1004dc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
  1004df:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
  1004e2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
  1004e5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
  1004e7:	8b 1d 8c 24 10 00    	mov    0x10248c,%ebx
  1004ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
  1004f4:	39 c6                	cmp    %eax,%esi
  1004f6:	7d d0                	jge    1004c8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
  1004f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1004fb:	5b                   	pop    %ebx
  1004fc:	5e                   	pop    %esi
  1004fd:	5d                   	pop    %ebp
  1004fe:	c3                   	ret
  1004ff:	90                   	nop

00100500 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  100500:	55                   	push   %ebp
  ioapic->reg = reg;
  100501:	8b 0d 8c 24 10 00    	mov    0x10248c,%ecx
{
  100507:	89 e5                	mov    %esp,%ebp
  100509:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  10050c:	8d 50 20             	lea    0x20(%eax),%edx
  10050f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
  100513:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  100515:	8b 0d 8c 24 10 00    	mov    0x10248c,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  10051b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
  10051e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  100521:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
  100524:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  100526:	a1 8c 24 10 00       	mov    0x10248c,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  10052b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
  10052e:	89 50 10             	mov    %edx,0x10(%eax)
}
  100531:	5d                   	pop    %ebp
  100532:	c3                   	ret
  100533:	66 90                	xchg   %ax,%ax
  100535:	66 90                	xchg   %ax,%ax
  100537:	66 90                	xchg   %ax,%ax
  100539:	66 90                	xchg   %ax,%ax
  10053b:	66 90                	xchg   %ax,%ax
  10053d:	66 90                	xchg   %ax,%ax
  10053f:	90                   	nop

00100540 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
  100540:	a1 90 24 10 00       	mov    0x102490,%eax
  100545:	85 c0                	test   %eax,%eax
  100547:	0f 84 c3 00 00 00    	je     100610 <lapicinit+0xd0>
  lapic[index] = value;
  10054d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  100554:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100557:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  10055a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  100561:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100564:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100567:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  10056e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  100571:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100574:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  10057b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  10057e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100581:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  100588:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10058b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  10058e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  100595:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  100598:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10059b:	8b 50 30             	mov    0x30(%eax),%edx
  10059e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
  1005a4:	75 72                	jne    100618 <lapicinit+0xd8>
  lapic[index] = value;
  1005a6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  1005ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1005ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005c0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1005c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1005d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005da:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  1005e1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005e7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  1005ee:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  1005f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  1005f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1005f8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
  1005fe:	80 e6 10             	and    $0x10,%dh
  100601:	75 f5                	jne    1005f8 <lapicinit+0xb8>
  lapic[index] = value;
  100603:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  10060a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10060d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  100610:	c3                   	ret
  100611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
  100618:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  10061f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  100622:	8b 50 20             	mov    0x20(%eax),%edx
}
  100625:	e9 7c ff ff ff       	jmp    1005a6 <lapicinit+0x66>
  10062a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100630 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
  100630:	a1 90 24 10 00       	mov    0x102490,%eax
  100635:	85 c0                	test   %eax,%eax
  100637:	74 07                	je     100640 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
  100639:	8b 40 20             	mov    0x20(%eax),%eax
  10063c:	c1 e8 18             	shr    $0x18,%eax
  10063f:	c3                   	ret
    return 0;
  100640:	31 c0                	xor    %eax,%eax
}
  100642:	c3                   	ret
  100643:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10064a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100650 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
  100650:	a1 90 24 10 00       	mov    0x102490,%eax
  100655:	85 c0                	test   %eax,%eax
  100657:	74 0d                	je     100666 <lapiceoi+0x16>
  lapic[index] = value;
  100659:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  100660:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100663:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
  100666:	c3                   	ret
  100667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10066e:	66 90                	xchg   %ax,%ax

00100670 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  100670:	c3                   	ret
  100671:	66 90                	xchg   %ax,%ax
  100673:	66 90                	xchg   %ax,%ax
  100675:	66 90                	xchg   %ax,%ax
  100677:	66 90                	xchg   %ax,%ax
  100679:	66 90                	xchg   %ax,%ax
  10067b:	66 90                	xchg   %ax,%ax
  10067d:	66 90                	xchg   %ax,%ax
  10067f:	90                   	nop

00100680 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  100680:	55                   	push   %ebp
  100681:	89 e5                	mov    %esp,%ebp
  100683:	83 e4 f0             	and    $0xfffffff0,%esp
  mpinit();        // detect other processors
  100686:	e8 a5 00 00 00       	call   100730 <mpinit>
  lapicinit();     // interrupt controller
  10068b:	e8 b0 fe ff ff       	call   100540 <lapicinit>
  picinit();       // disable pic
  100690:	e8 7b 02 00 00       	call   100910 <picinit>
  ioapicinit();    // another interrupt controller
  100695:	e8 c6 fd ff ff       	call   100460 <ioapicinit>
  uartinit();      // serial port
  10069a:	e8 c1 02 00 00       	call   100960 <uartinit>
  tvinit();        // trap vectors
  10069f:	e8 2c 07 00 00       	call   100dd0 <tvinit>
  idtinit();
  1006a4:	e8 67 07 00 00       	call   100e10 <idtinit>


static inline void
sti(void)
{
  asm volatile("sti");
  1006a9:	fb                   	sti
      // load idt register
  sti();
  mouseinit();  
  1006aa:	e8 31 13 00 00       	call   1019e0 <mouseinit>
  1006af:	90                   	nop
}

static inline void
wfi(void)
{
  asm volatile("hlt");
  1006b0:	f4                   	hlt
  for(;;)
  1006b1:	eb fd                	jmp    1006b0 <main+0x30>
  1006b3:	66 90                	xchg   %ax,%ax
  1006b5:	66 90                	xchg   %ax,%ax
  1006b7:	66 90                	xchg   %ax,%ax
  1006b9:	66 90                	xchg   %ax,%ax
  1006bb:	66 90                	xchg   %ax,%ax
  1006bd:	66 90                	xchg   %ax,%ax
  1006bf:	90                   	nop

001006c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
  1006c0:	55                   	push   %ebp
  1006c1:	89 e5                	mov    %esp,%ebp
  1006c3:	57                   	push   %edi
  1006c4:	56                   	push   %esi
  1006c5:	53                   	push   %ebx
  uchar *e, *p, *addr;

  // addr = P2V(a);
  addr = (uchar*) a;
  e = addr+len;
  1006c6:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
{
  1006c9:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
  1006cc:	39 d8                	cmp    %ebx,%eax
  1006ce:	73 50                	jae    100720 <mpsearch1+0x60>
  1006d0:	89 c6                	mov    %eax,%esi
  1006d2:	eb 0a                	jmp    1006de <mpsearch1+0x1e>
  1006d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1006d8:	89 fe                	mov    %edi,%esi
  1006da:	39 df                	cmp    %ebx,%edi
  1006dc:	73 42                	jae    100720 <mpsearch1+0x60>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1006de:	83 ec 04             	sub    $0x4,%esp
  1006e1:	8d 7e 10             	lea    0x10(%esi),%edi
  1006e4:	6a 04                	push   $0x4
  1006e6:	68 9b 1b 10 00       	push   $0x101b9b
  1006eb:	56                   	push   %esi
  1006ec:	e8 ff 03 00 00       	call   100af0 <memcmp>
  1006f1:	83 c4 10             	add    $0x10,%esp
  1006f4:	85 c0                	test   %eax,%eax
  1006f6:	75 e0                	jne    1006d8 <mpsearch1+0x18>
  1006f8:	89 f2                	mov    %esi,%edx
  1006fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
  100700:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
  100703:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
  100706:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
  100708:	39 fa                	cmp    %edi,%edx
  10070a:	75 f4                	jne    100700 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  10070c:	84 c0                	test   %al,%al
  10070e:	75 c8                	jne    1006d8 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
  100710:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100713:	89 f0                	mov    %esi,%eax
  100715:	5b                   	pop    %ebx
  100716:	5e                   	pop    %esi
  100717:	5f                   	pop    %edi
  100718:	5d                   	pop    %ebp
  100719:	c3                   	ret
  10071a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
  100723:	31 f6                	xor    %esi,%esi
}
  100725:	5b                   	pop    %ebx
  100726:	89 f0                	mov    %esi,%eax
  100728:	5e                   	pop    %esi
  100729:	5f                   	pop    %edi
  10072a:	5d                   	pop    %ebp
  10072b:	c3                   	ret
  10072c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100730 <mpinit>:
  return conf;
}

void
mpinit(void)
{
  100730:	55                   	push   %ebp
  100731:	89 e5                	mov    %esp,%ebp
  100733:	57                   	push   %edi
  100734:	56                   	push   %esi
  100735:	53                   	push   %ebx
  100736:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
  100739:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  100740:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  100747:	c1 e0 08             	shl    $0x8,%eax
  10074a:	09 d0                	or     %edx,%eax
  10074c:	c1 e0 04             	shl    $0x4,%eax
  10074f:	75 1b                	jne    10076c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
  100751:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  100758:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  10075f:	c1 e0 08             	shl    $0x8,%eax
  100762:	09 d0                	or     %edx,%eax
  100764:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
  100767:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
  10076c:	ba 00 04 00 00       	mov    $0x400,%edx
  100771:	e8 4a ff ff ff       	call   1006c0 <mpsearch1>
  100776:	89 c6                	mov    %eax,%esi
  100778:	85 c0                	test   %eax,%eax
  10077a:	0f 84 28 01 00 00    	je     1008a8 <mpinit+0x178>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100780:	8b 5e 04             	mov    0x4(%esi),%ebx
  100783:	85 db                	test   %ebx,%ebx
  100785:	0f 84 0d 01 00 00    	je     100898 <mpinit+0x168>
  if(memcmp(conf, "PCMP", 4) != 0)
  10078b:	83 ec 04             	sub    $0x4,%esp
  10078e:	6a 04                	push   $0x4
  100790:	68 a0 1b 10 00       	push   $0x101ba0
  100795:	53                   	push   %ebx
  100796:	e8 55 03 00 00       	call   100af0 <memcmp>
  10079b:	83 c4 10             	add    $0x10,%esp
  10079e:	85 c0                	test   %eax,%eax
  1007a0:	0f 85 f2 00 00 00    	jne    100898 <mpinit+0x168>
  if(conf->version != 1 && conf->version != 4)
  1007a6:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  1007aa:	3c 01                	cmp    $0x1,%al
  1007ac:	74 08                	je     1007b6 <mpinit+0x86>
  1007ae:	3c 04                	cmp    $0x4,%al
  1007b0:	0f 85 e2 00 00 00    	jne    100898 <mpinit+0x168>
  if(sum((uchar*)conf, conf->length) != 0)
  1007b6:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  for(i=0; i<len; i++)
  1007ba:	31 c9                	xor    %ecx,%ecx
  1007bc:	66 85 d2             	test   %dx,%dx
  1007bf:	74 26                	je     1007e7 <mpinit+0xb7>
  sum = 0;
  1007c1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  1007c4:	0f b7 ca             	movzwl %dx,%ecx
  1007c7:	89 d8                	mov    %ebx,%eax
  1007c9:	31 d2                	xor    %edx,%edx
  1007cb:	8d 3c 0b             	lea    (%ebx,%ecx,1),%edi
  1007ce:	66 90                	xchg   %ax,%ax
    sum += addr[i];
  1007d0:	0f b6 30             	movzbl (%eax),%esi
  for(i=0; i<len; i++)
  1007d3:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  1007d6:	01 f2                	add    %esi,%edx
  for(i=0; i<len; i++)
  1007d8:	39 f8                	cmp    %edi,%eax
  1007da:	75 f4                	jne    1007d0 <mpinit+0xa0>
  if(sum((uchar*)conf, conf->length) != 0)
  1007dc:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  1007df:	84 d2                	test   %dl,%dl
  1007e1:	0f 85 b1 00 00 00    	jne    100898 <mpinit+0x168>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  1007e7:	8b 43 24             	mov    0x24(%ebx),%eax
  1007ea:	a3 90 24 10 00       	mov    %eax,0x102490
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  1007ef:	8d 43 2c             	lea    0x2c(%ebx),%eax
  1007f2:	01 cb                	add    %ecx,%ebx
  ismp = 1;
  1007f4:	b9 01 00 00 00       	mov    $0x1,%ecx
  1007f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100800:	39 d8                	cmp    %ebx,%eax
  100802:	73 15                	jae    100819 <mpinit+0xe9>
    switch(*p){
  100804:	0f b6 10             	movzbl (%eax),%edx
  100807:	80 fa 02             	cmp    $0x2,%dl
  10080a:	74 74                	je     100880 <mpinit+0x150>
  10080c:	77 62                	ja     100870 <mpinit+0x140>
  10080e:	84 d2                	test   %dl,%dl
  100810:	74 36                	je     100848 <mpinit+0x118>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  100812:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100815:	39 d8                	cmp    %ebx,%eax
  100817:	72 eb                	jb     100804 <mpinit+0xd4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
  100819:	85 c9                	test   %ecx,%ecx
  10081b:	0f 84 d4 00 00 00    	je     1008f5 <mpinit+0x1c5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
  100821:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  100825:	74 15                	je     10083c <mpinit+0x10c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100827:	b8 70 00 00 00       	mov    $0x70,%eax
  10082c:	ba 22 00 00 00       	mov    $0x22,%edx
  100831:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100832:	ba 23 00 00 00       	mov    $0x23,%edx
  100837:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  100838:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10083b:	ee                   	out    %al,(%dx)
  }
}
  10083c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10083f:	5b                   	pop    %ebx
  100840:	5e                   	pop    %esi
  100841:	5f                   	pop    %edi
  100842:	5d                   	pop    %ebp
  100843:	c3                   	ret
  100844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
  100848:	8b 3d 98 24 10 00    	mov    0x102498,%edi
  10084e:	83 ff 07             	cmp    $0x7,%edi
  100851:	7f 13                	jg     100866 <mpinit+0x136>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  100853:	0f b6 50 01          	movzbl 0x1(%eax),%edx
        ncpu++;
  100857:	83 c7 01             	add    $0x1,%edi
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  10085a:	88 97 9b 24 10 00    	mov    %dl,0x10249b(%edi)
        ncpu++;
  100860:	89 3d 98 24 10 00    	mov    %edi,0x102498
      p += sizeof(struct mpproc);
  100866:	83 c0 14             	add    $0x14,%eax
      continue;
  100869:	eb 95                	jmp    100800 <mpinit+0xd0>
  10086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10086f:	90                   	nop
    switch(*p){
  100870:	83 ea 03             	sub    $0x3,%edx
  100873:	80 fa 01             	cmp    $0x1,%dl
  100876:	76 9a                	jbe    100812 <mpinit+0xe2>
  100878:	31 c9                	xor    %ecx,%ecx
  10087a:	eb 84                	jmp    100800 <mpinit+0xd0>
  10087c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
  100880:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
  100884:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
  100887:	88 15 94 24 10 00    	mov    %dl,0x102494
      continue;
  10088d:	e9 6e ff ff ff       	jmp    100800 <mpinit+0xd0>
  100892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
  100898:	83 ec 0c             	sub    $0xc,%esp
  10089b:	68 a5 1b 10 00       	push   $0x101ba5
  1008a0:	e8 8b f9 ff ff       	call   100230 <panic>
  1008a5:	8d 76 00             	lea    0x0(%esi),%esi
{
  1008a8:	be 00 00 0f 00       	mov    $0xf0000,%esi
  1008ad:	eb 0b                	jmp    1008ba <mpinit+0x18a>
  1008af:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
  1008b0:	89 de                	mov    %ebx,%esi
  1008b2:	81 fb 00 00 10 00    	cmp    $0x100000,%ebx
  1008b8:	74 de                	je     100898 <mpinit+0x168>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1008ba:	83 ec 04             	sub    $0x4,%esp
  1008bd:	8d 5e 10             	lea    0x10(%esi),%ebx
  1008c0:	6a 04                	push   $0x4
  1008c2:	68 9b 1b 10 00       	push   $0x101b9b
  1008c7:	56                   	push   %esi
  1008c8:	e8 23 02 00 00       	call   100af0 <memcmp>
  1008cd:	83 c4 10             	add    $0x10,%esp
  1008d0:	85 c0                	test   %eax,%eax
  1008d2:	75 dc                	jne    1008b0 <mpinit+0x180>
  1008d4:	89 f2                	mov    %esi,%edx
  1008d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1008dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
  1008e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
  1008e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
  1008e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
  1008e8:	39 da                	cmp    %ebx,%edx
  1008ea:	75 f4                	jne    1008e0 <mpinit+0x1b0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1008ec:	84 c0                	test   %al,%al
  1008ee:	75 c0                	jne    1008b0 <mpinit+0x180>
  1008f0:	e9 8b fe ff ff       	jmp    100780 <mpinit+0x50>
    panic("Didn't find a suitable machine");
  1008f5:	83 ec 0c             	sub    $0xc,%esp
  1008f8:	68 60 1c 10 00       	push   $0x101c60
  1008fd:	e8 2e f9 ff ff       	call   100230 <panic>
  100902:	66 90                	xchg   %ax,%ax
  100904:	66 90                	xchg   %ax,%ax
  100906:	66 90                	xchg   %ax,%ax
  100908:	66 90                	xchg   %ax,%ax
  10090a:	66 90                	xchg   %ax,%ax
  10090c:	66 90                	xchg   %ax,%ax
  10090e:	66 90                	xchg   %ax,%ax

00100910 <picinit>:
  100910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100915:	ba 21 00 00 00       	mov    $0x21,%edx
  10091a:	ee                   	out    %al,(%dx)
  10091b:	ba a1 00 00 00       	mov    $0xa1,%edx
  100920:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
  100921:	c3                   	ret
  100922:	66 90                	xchg   %ax,%ax
  100924:	66 90                	xchg   %ax,%ax
  100926:	66 90                	xchg   %ax,%ax
  100928:	66 90                	xchg   %ax,%ax
  10092a:	66 90                	xchg   %ax,%ax
  10092c:	66 90                	xchg   %ax,%ax
  10092e:	66 90                	xchg   %ax,%ax

00100930 <uartgetc>:


static int
uartgetc(void)
{
  if(!uart)
  100930:	a1 a4 24 10 00       	mov    0x1024a4,%eax
  100935:	85 c0                	test   %eax,%eax
  100937:	74 17                	je     100950 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100939:	ba fd 03 00 00       	mov    $0x3fd,%edx
  10093e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
  10093f:	a8 01                	test   $0x1,%al
  100941:	74 0d                	je     100950 <uartgetc+0x20>
  100943:	ba f8 03 00 00       	mov    $0x3f8,%edx
  100948:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
  100949:	0f b6 c0             	movzbl %al,%eax
  10094c:	c3                   	ret
  10094d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
  100950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  100955:	c3                   	ret
  100956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10095d:	8d 76 00             	lea    0x0(%esi),%esi

00100960 <uartinit>:
{
  100960:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100961:	31 c9                	xor    %ecx,%ecx
  100963:	89 c8                	mov    %ecx,%eax
  100965:	89 e5                	mov    %esp,%ebp
  100967:	57                   	push   %edi
  100968:	bf fa 03 00 00       	mov    $0x3fa,%edi
  10096d:	56                   	push   %esi
  10096e:	89 fa                	mov    %edi,%edx
  100970:	53                   	push   %ebx
  100971:	83 ec 0c             	sub    $0xc,%esp
  100974:	ee                   	out    %al,(%dx)
  100975:	be fb 03 00 00       	mov    $0x3fb,%esi
  10097a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  10097f:	89 f2                	mov    %esi,%edx
  100981:	ee                   	out    %al,(%dx)
  100982:	b8 0c 00 00 00       	mov    $0xc,%eax
  100987:	ba f8 03 00 00       	mov    $0x3f8,%edx
  10098c:	ee                   	out    %al,(%dx)
  10098d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
  100992:	89 c8                	mov    %ecx,%eax
  100994:	89 da                	mov    %ebx,%edx
  100996:	ee                   	out    %al,(%dx)
  100997:	b8 03 00 00 00       	mov    $0x3,%eax
  10099c:	89 f2                	mov    %esi,%edx
  10099e:	ee                   	out    %al,(%dx)
  10099f:	ba fc 03 00 00       	mov    $0x3fc,%edx
  1009a4:	89 c8                	mov    %ecx,%eax
  1009a6:	ee                   	out    %al,(%dx)
  1009a7:	b8 01 00 00 00       	mov    $0x1,%eax
  1009ac:	89 da                	mov    %ebx,%edx
  1009ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1009af:	ba fd 03 00 00       	mov    $0x3fd,%edx
  1009b4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
  1009b5:	3c ff                	cmp    $0xff,%al
  1009b7:	74 3d                	je     1009f6 <uartinit+0x96>
  uart = 1;
  1009b9:	c7 05 a4 24 10 00 01 	movl   $0x1,0x1024a4
  1009c0:	00 00 00 
  1009c3:	89 fa                	mov    %edi,%edx
  1009c5:	ec                   	in     (%dx),%al
  1009c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
  1009cb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
  1009cc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
  1009cf:	be bd 1b 10 00       	mov    $0x101bbd,%esi
  1009d4:	bf 78 00 00 00       	mov    $0x78,%edi
  ioapicenable(IRQ_COM1, 0);
  1009d9:	6a 00                	push   $0x0
  1009db:	6a 04                	push   $0x4
  1009dd:	e8 1e fb ff ff       	call   100500 <ioapicenable>
  if(!uart)
  1009e2:	a1 a4 24 10 00       	mov    0x1024a4,%eax
  1009e7:	83 c4 10             	add    $0x10,%esp
  1009ea:	85 c0                	test   %eax,%eax
  1009ec:	75 10                	jne    1009fe <uartinit+0x9e>
  for(p="xv6...\n"; *p; p++)
  1009ee:	83 c6 01             	add    $0x1,%esi
  1009f1:	80 3e 00             	cmpb   $0x0,(%esi)
  1009f4:	75 f8                	jne    1009ee <uartinit+0x8e>
}
  1009f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1009f9:	5b                   	pop    %ebx
  1009fa:	5e                   	pop    %esi
  1009fb:	5f                   	pop    %edi
  1009fc:	5d                   	pop    %ebp
  1009fd:	c3                   	ret
  1009fe:	bb fd 03 00 00       	mov    $0x3fd,%ebx
  100a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100a07:	90                   	nop
  100a08:	89 da                	mov    %ebx,%edx
  100a0a:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++);
  100a0b:	a8 20                	test   $0x20,%al
  100a0d:	75 15                	jne    100a24 <uartinit+0xc4>
  100a0f:	b9 80 00 00 00       	mov    $0x80,%ecx
  100a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100a18:	83 e9 01             	sub    $0x1,%ecx
  100a1b:	74 07                	je     100a24 <uartinit+0xc4>
  100a1d:	89 da                	mov    %ebx,%edx
  100a1f:	ec                   	in     (%dx),%al
  100a20:	a8 20                	test   $0x20,%al
  100a22:	74 f4                	je     100a18 <uartinit+0xb8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100a24:	ba f8 03 00 00       	mov    $0x3f8,%edx
  100a29:	89 f8                	mov    %edi,%eax
  100a2b:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
  100a2c:	0f b6 7e 01          	movzbl 0x1(%esi),%edi
  100a30:	83 c6 01             	add    $0x1,%esi
  100a33:	89 f8                	mov    %edi,%eax
  100a35:	84 c0                	test   %al,%al
  100a37:	75 cf                	jne    100a08 <uartinit+0xa8>
}
  100a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100a3c:	5b                   	pop    %ebx
  100a3d:	5e                   	pop    %esi
  100a3e:	5f                   	pop    %edi
  100a3f:	5d                   	pop    %ebp
  100a40:	c3                   	ret
  100a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100a4f:	90                   	nop

00100a50 <uartputc>:
  if(!uart)
  100a50:	a1 a4 24 10 00       	mov    0x1024a4,%eax
  100a55:	85 c0                	test   %eax,%eax
  100a57:	74 2f                	je     100a88 <uartputc+0x38>
{
  100a59:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100a5a:	ba fd 03 00 00       	mov    $0x3fd,%edx
  100a5f:	89 e5                	mov    %esp,%ebp
  100a61:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++);
  100a62:	a8 20                	test   $0x20,%al
  100a64:	75 14                	jne    100a7a <uartputc+0x2a>
  100a66:	b9 80 00 00 00       	mov    $0x80,%ecx
  100a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100a6f:	90                   	nop
  100a70:	83 e9 01             	sub    $0x1,%ecx
  100a73:	74 05                	je     100a7a <uartputc+0x2a>
  100a75:	ec                   	in     (%dx),%al
  100a76:	a8 20                	test   $0x20,%al
  100a78:	74 f6                	je     100a70 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7d:	ba f8 03 00 00       	mov    $0x3f8,%edx
  100a82:	ee                   	out    %al,(%dx)
}
  100a83:	5d                   	pop    %ebp
  100a84:	c3                   	ret
  100a85:	8d 76 00             	lea    0x0(%esi),%esi
  100a88:	c3                   	ret
  100a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100a90 <uartintr>:

void
uartintr(void)
{
  100a90:	55                   	push   %ebp
  100a91:	89 e5                	mov    %esp,%ebp
  100a93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
  100a96:	68 30 09 10 00       	push   $0x100930
  100a9b:	e8 00 f8 ff ff       	call   1002a0 <consoleintr>
  100aa0:	83 c4 10             	add    $0x10,%esp
  100aa3:	c9                   	leave
  100aa4:	c3                   	ret
  100aa5:	66 90                	xchg   %ax,%ax
  100aa7:	66 90                	xchg   %ax,%ax
  100aa9:	66 90                	xchg   %ax,%ax
  100aab:	66 90                	xchg   %ax,%ax
  100aad:	66 90                	xchg   %ax,%ax
  100aaf:	90                   	nop

00100ab0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  100ab0:	55                   	push   %ebp
  100ab1:	89 e5                	mov    %esp,%ebp
  100ab3:	57                   	push   %edi
  100ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  100ab7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
  100aba:	89 d0                	mov    %edx,%eax
  100abc:	09 c8                	or     %ecx,%eax
  100abe:	a8 03                	test   $0x3,%al
  100ac0:	75 1e                	jne    100ae0 <memset+0x30>
    c &= 0xFF;
  100ac2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  100ac6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
  100ac9:	89 d7                	mov    %edx,%edi
  100acb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
  100ad1:	fc                   	cld
  100ad2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
  100ad4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100ad7:	89 d0                	mov    %edx,%eax
  100ad9:	c9                   	leave
  100ada:	c3                   	ret
  100adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100adf:	90                   	nop
  asm volatile("cld; rep stosb" :
  100ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ae3:	89 d7                	mov    %edx,%edi
  100ae5:	fc                   	cld
  100ae6:	f3 aa                	rep stos %al,%es:(%edi)
  100ae8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100aeb:	89 d0                	mov    %edx,%eax
  100aed:	c9                   	leave
  100aee:	c3                   	ret
  100aef:	90                   	nop

00100af0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  100af0:	55                   	push   %ebp
  100af1:	89 e5                	mov    %esp,%ebp
  100af3:	56                   	push   %esi
  100af4:	8b 75 10             	mov    0x10(%ebp),%esi
  100af7:	8b 45 08             	mov    0x8(%ebp),%eax
  100afa:	53                   	push   %ebx
  100afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  100afe:	85 f6                	test   %esi,%esi
  100b00:	74 2e                	je     100b30 <memcmp+0x40>
  100b02:	01 c6                	add    %eax,%esi
  100b04:	eb 14                	jmp    100b1a <memcmp+0x2a>
  100b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  100b10:	83 c0 01             	add    $0x1,%eax
  100b13:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
  100b16:	39 f0                	cmp    %esi,%eax
  100b18:	74 16                	je     100b30 <memcmp+0x40>
    if(*s1 != *s2)
  100b1a:	0f b6 08             	movzbl (%eax),%ecx
  100b1d:	0f b6 1a             	movzbl (%edx),%ebx
  100b20:	38 d9                	cmp    %bl,%cl
  100b22:	74 ec                	je     100b10 <memcmp+0x20>
      return *s1 - *s2;
  100b24:	0f b6 c1             	movzbl %cl,%eax
  100b27:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
  100b29:	5b                   	pop    %ebx
  100b2a:	5e                   	pop    %esi
  100b2b:	5d                   	pop    %ebp
  100b2c:	c3                   	ret
  100b2d:	8d 76 00             	lea    0x0(%esi),%esi
  100b30:	5b                   	pop    %ebx
  return 0;
  100b31:	31 c0                	xor    %eax,%eax
}
  100b33:	5e                   	pop    %esi
  100b34:	5d                   	pop    %ebp
  100b35:	c3                   	ret
  100b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100b3d:	8d 76 00             	lea    0x0(%esi),%esi

00100b40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  100b40:	55                   	push   %ebp
  100b41:	89 e5                	mov    %esp,%ebp
  100b43:	57                   	push   %edi
  100b44:	8b 55 08             	mov    0x8(%ebp),%edx
  100b47:	8b 45 10             	mov    0x10(%ebp),%eax
  100b4a:	56                   	push   %esi
  100b4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  100b4e:	39 d6                	cmp    %edx,%esi
  100b50:	73 26                	jae    100b78 <memmove+0x38>
  100b52:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
  100b55:	39 ca                	cmp    %ecx,%edx
  100b57:	73 1f                	jae    100b78 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
  100b59:	85 c0                	test   %eax,%eax
  100b5b:	74 0f                	je     100b6c <memmove+0x2c>
  100b5d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
  100b60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  100b64:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
  100b67:	83 e8 01             	sub    $0x1,%eax
  100b6a:	73 f4                	jae    100b60 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  100b6c:	5e                   	pop    %esi
  100b6d:	89 d0                	mov    %edx,%eax
  100b6f:	5f                   	pop    %edi
  100b70:	5d                   	pop    %ebp
  100b71:	c3                   	ret
  100b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
  100b78:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
  100b7b:	89 d7                	mov    %edx,%edi
  100b7d:	85 c0                	test   %eax,%eax
  100b7f:	74 eb                	je     100b6c <memmove+0x2c>
  100b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
  100b88:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
  100b89:	39 ce                	cmp    %ecx,%esi
  100b8b:	75 fb                	jne    100b88 <memmove+0x48>
}
  100b8d:	5e                   	pop    %esi
  100b8e:	89 d0                	mov    %edx,%eax
  100b90:	5f                   	pop    %edi
  100b91:	5d                   	pop    %ebp
  100b92:	c3                   	ret
  100b93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100ba0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
  100ba0:	eb 9e                	jmp    100b40 <memmove>
  100ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100bb0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
  100bb0:	55                   	push   %ebp
  100bb1:	89 e5                	mov    %esp,%ebp
  100bb3:	53                   	push   %ebx
  100bb4:	8b 55 10             	mov    0x10(%ebp),%edx
  100bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  100bba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
  100bbd:	85 d2                	test   %edx,%edx
  100bbf:	75 16                	jne    100bd7 <strncmp+0x27>
  100bc1:	eb 2d                	jmp    100bf0 <strncmp+0x40>
  100bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100bc7:	90                   	nop
  100bc8:	3a 19                	cmp    (%ecx),%bl
  100bca:	75 12                	jne    100bde <strncmp+0x2e>
    n--, p++, q++;
  100bcc:	83 c0 01             	add    $0x1,%eax
  100bcf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
  100bd2:	83 ea 01             	sub    $0x1,%edx
  100bd5:	74 19                	je     100bf0 <strncmp+0x40>
  100bd7:	0f b6 18             	movzbl (%eax),%ebx
  100bda:	84 db                	test   %bl,%bl
  100bdc:	75 ea                	jne    100bc8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  100bde:	0f b6 00             	movzbl (%eax),%eax
  100be1:	0f b6 11             	movzbl (%ecx),%edx
}
  100be4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100be7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
  100be8:	29 d0                	sub    %edx,%eax
}
  100bea:	c3                   	ret
  100beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100bef:	90                   	nop
  100bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
  100bf3:	31 c0                	xor    %eax,%eax
}
  100bf5:	c9                   	leave
  100bf6:	c3                   	ret
  100bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100bfe:	66 90                	xchg   %ax,%ax

00100c00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  100c00:	55                   	push   %ebp
  100c01:	89 e5                	mov    %esp,%ebp
  100c03:	57                   	push   %edi
  100c04:	56                   	push   %esi
  100c05:	8b 75 08             	mov    0x8(%ebp),%esi
  100c08:	53                   	push   %ebx
  100c09:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  100c0c:	89 f0                	mov    %esi,%eax
  100c0e:	eb 15                	jmp    100c25 <strncpy+0x25>
  100c10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  100c14:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100c17:	83 c0 01             	add    $0x1,%eax
  100c1a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
  100c1e:	88 48 ff             	mov    %cl,-0x1(%eax)
  100c21:	84 c9                	test   %cl,%cl
  100c23:	74 13                	je     100c38 <strncpy+0x38>
  100c25:	89 d3                	mov    %edx,%ebx
  100c27:	83 ea 01             	sub    $0x1,%edx
  100c2a:	85 db                	test   %ebx,%ebx
  100c2c:	7f e2                	jg     100c10 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
  100c2e:	5b                   	pop    %ebx
  100c2f:	89 f0                	mov    %esi,%eax
  100c31:	5e                   	pop    %esi
  100c32:	5f                   	pop    %edi
  100c33:	5d                   	pop    %ebp
  100c34:	c3                   	ret
  100c35:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
  100c38:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  100c3b:	83 e9 01             	sub    $0x1,%ecx
  100c3e:	85 d2                	test   %edx,%edx
  100c40:	74 ec                	je     100c2e <strncpy+0x2e>
  100c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
  100c48:	83 c0 01             	add    $0x1,%eax
  100c4b:	89 ca                	mov    %ecx,%edx
  100c4d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
  100c51:	29 c2                	sub    %eax,%edx
  100c53:	85 d2                	test   %edx,%edx
  100c55:	7f f1                	jg     100c48 <strncpy+0x48>
}
  100c57:	5b                   	pop    %ebx
  100c58:	89 f0                	mov    %esi,%eax
  100c5a:	5e                   	pop    %esi
  100c5b:	5f                   	pop    %edi
  100c5c:	5d                   	pop    %ebp
  100c5d:	c3                   	ret
  100c5e:	66 90                	xchg   %ax,%ax

00100c60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  100c60:	55                   	push   %ebp
  100c61:	89 e5                	mov    %esp,%ebp
  100c63:	56                   	push   %esi
  100c64:	8b 55 10             	mov    0x10(%ebp),%edx
  100c67:	8b 75 08             	mov    0x8(%ebp),%esi
  100c6a:	53                   	push   %ebx
  100c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
  100c6e:	85 d2                	test   %edx,%edx
  100c70:	7e 25                	jle    100c97 <safestrcpy+0x37>
  100c72:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
  100c76:	89 f2                	mov    %esi,%edx
  100c78:	eb 16                	jmp    100c90 <safestrcpy+0x30>
  100c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  100c80:	0f b6 08             	movzbl (%eax),%ecx
  100c83:	83 c0 01             	add    $0x1,%eax
  100c86:	83 c2 01             	add    $0x1,%edx
  100c89:	88 4a ff             	mov    %cl,-0x1(%edx)
  100c8c:	84 c9                	test   %cl,%cl
  100c8e:	74 04                	je     100c94 <safestrcpy+0x34>
  100c90:	39 d8                	cmp    %ebx,%eax
  100c92:	75 ec                	jne    100c80 <safestrcpy+0x20>
    ;
  *s = 0;
  100c94:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  100c97:	89 f0                	mov    %esi,%eax
  100c99:	5b                   	pop    %ebx
  100c9a:	5e                   	pop    %esi
  100c9b:	5d                   	pop    %ebp
  100c9c:	c3                   	ret
  100c9d:	8d 76 00             	lea    0x0(%esi),%esi

00100ca0 <strlen>:

int
strlen(const char *s)
{
  100ca0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  100ca1:	31 c0                	xor    %eax,%eax
{
  100ca3:	89 e5                	mov    %esp,%ebp
  100ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
  100ca8:	80 3a 00             	cmpb   $0x0,(%edx)
  100cab:	74 0c                	je     100cb9 <strlen+0x19>
  100cad:	8d 76 00             	lea    0x0(%esi),%esi
  100cb0:	83 c0 01             	add    $0x1,%eax
  100cb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100cb7:	75 f7                	jne    100cb0 <strlen+0x10>
    ;
  return n;
}
  100cb9:	5d                   	pop    %ebp
  100cba:	c3                   	ret
  100cbb:	66 90                	xchg   %ax,%ax
  100cbd:	66 90                	xchg   %ax,%ax
  100cbf:	90                   	nop

00100cc0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  100cc0:	55                   	push   %ebp
  100cc1:	89 e5                	mov    %esp,%ebp
  100cc3:	53                   	push   %ebx
  100cc4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  100cc7:	9c                   	pushf
  100cc8:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
  100cc9:	f6 c4 02             	test   $0x2,%ah
  100ccc:	75 44                	jne    100d12 <mycpu+0x52>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  100cce:	e8 5d f9 ff ff       	call   100630 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
  100cd3:	8b 1d 98 24 10 00    	mov    0x102498,%ebx
  100cd9:	85 db                	test   %ebx,%ebx
  100cdb:	7e 28                	jle    100d05 <mycpu+0x45>
  100cdd:	31 d2                	xor    %edx,%edx
  100cdf:	eb 0e                	jmp    100cef <mycpu+0x2f>
  100ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100ce8:	83 c2 01             	add    $0x1,%edx
  100ceb:	39 da                	cmp    %ebx,%edx
  100ced:	74 16                	je     100d05 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
  100cef:	0f b6 8a 9c 24 10 00 	movzbl 0x10249c(%edx),%ecx
  100cf6:	39 c1                	cmp    %eax,%ecx
  100cf8:	75 ee                	jne    100ce8 <mycpu+0x28>
      return &cpus[i];
  }
  panic("unknown apicid\n");
  100cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return &cpus[i];
  100cfd:	8d 82 9c 24 10 00    	lea    0x10249c(%edx),%eax
  100d03:	c9                   	leave
  100d04:	c3                   	ret
  panic("unknown apicid\n");
  100d05:	83 ec 0c             	sub    $0xc,%esp
  100d08:	68 c5 1b 10 00       	push   $0x101bc5
  100d0d:	e8 1e f5 ff ff       	call   100230 <panic>
    panic("mycpu called with interrupts enabled\n");
  100d12:	83 ec 0c             	sub    $0xc,%esp
  100d15:	68 80 1c 10 00       	push   $0x101c80
  100d1a:	e8 11 f5 ff ff       	call   100230 <panic>
  100d1f:	90                   	nop

00100d20 <cpuid>:
cpuid() {
  100d20:	55                   	push   %ebp
  100d21:	89 e5                	mov    %esp,%ebp
  100d23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
  100d26:	e8 95 ff ff ff       	call   100cc0 <mycpu>
}
  100d2b:	c9                   	leave
  return mycpu()-cpus;
  100d2c:	2d 9c 24 10 00       	sub    $0x10249c,%eax
}
  100d31:	c3                   	ret
  100d32:	66 90                	xchg   %ax,%ax
  100d34:	66 90                	xchg   %ax,%ax
  100d36:	66 90                	xchg   %ax,%ax
  100d38:	66 90                	xchg   %ax,%ax
  100d3a:	66 90                	xchg   %ax,%ax
  100d3c:	66 90                	xchg   %ax,%ax
  100d3e:	66 90                	xchg   %ax,%ax

00100d40 <getcallerpcs>:
// #include "memlayout.h"

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  100d40:	55                   	push   %ebp
  100d41:	89 e5                	mov    %esp,%ebp
  100d43:	53                   	push   %ebx
  100d44:	8b 45 08             	mov    0x8(%ebp),%eax
  100d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    // if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  100d4a:	83 f8 07             	cmp    $0x7,%eax
  100d4d:	74 2e                	je     100d7d <getcallerpcs+0x3d>
  100d4f:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
  100d52:	31 c0                	xor    %eax,%eax
  100d54:	eb 12                	jmp    100d68 <getcallerpcs+0x28>
  100d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  100d60:	8d 5a ff             	lea    -0x1(%edx),%ebx
  100d63:	83 fb fd             	cmp    $0xfffffffd,%ebx
  100d66:	77 18                	ja     100d80 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
  100d68:	8b 5a 04             	mov    0x4(%edx),%ebx
  100d6b:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
  100d6e:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
  100d71:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
  100d73:	83 f8 0a             	cmp    $0xa,%eax
  100d76:	75 e8                	jne    100d60 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
  100d78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100d7b:	c9                   	leave
  100d7c:	c3                   	ret
  for(i = 0; i < 10; i++){
  100d7d:	31 c0                	xor    %eax,%eax
  100d7f:	90                   	nop
  100d80:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  100d83:	83 c1 28             	add    $0x28,%ecx
  100d86:	89 ca                	mov    %ecx,%edx
  100d88:	29 c2                	sub    %eax,%edx
  100d8a:	83 e2 04             	and    $0x4,%edx
  100d8d:	74 11                	je     100da0 <getcallerpcs+0x60>
    pcs[i] = 0;
  100d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
  100d95:	83 c0 04             	add    $0x4,%eax
  100d98:	39 c1                	cmp    %eax,%ecx
  100d9a:	74 dc                	je     100d78 <getcallerpcs+0x38>
  100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
  100da0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
  100da6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
  100da9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
  100db0:	39 c1                	cmp    %eax,%ecx
  100db2:	75 ec                	jne    100da0 <getcallerpcs+0x60>
  100db4:	eb c2                	jmp    100d78 <getcallerpcs+0x38>

00100db6 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushal
  100db6:	60                   	pusha
  
  # Call trap(tf), where tf=%esp
  pushl %esp
  100db7:	54                   	push   %esp
  call trap
  100db8:	e8 83 00 00 00       	call   100e40 <trap>
  addl $4, %esp
  100dbd:	83 c4 04             	add    $0x4,%esp

00100dc0 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  100dc0:	61                   	popa
  addl $0x8, %esp  # trapno and errcode
  100dc1:	83 c4 08             	add    $0x8,%esp
  iret
  100dc4:	cf                   	iret
  100dc5:	66 90                	xchg   %ax,%ax
  100dc7:	66 90                	xchg   %ax,%ax
  100dc9:	66 90                	xchg   %ax,%ax
  100dcb:	66 90                	xchg   %ax,%ax
  100dcd:	66 90                	xchg   %ax,%ax
  100dcf:	90                   	nop

00100dd0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  100dd0:	31 c0                	xor    %eax,%eax
  100dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  100dd8:	8b 14 85 00 20 10 00 	mov    0x102000(,%eax,4),%edx
  100ddf:	c7 04 c5 e2 24 10 00 	movl   $0x8e000008,0x1024e2(,%eax,8)
  100de6:	08 00 00 8e 
  100dea:	66 89 14 c5 e0 24 10 	mov    %dx,0x1024e0(,%eax,8)
  100df1:	00 
  100df2:	c1 ea 10             	shr    $0x10,%edx
  100df5:	66 89 14 c5 e6 24 10 	mov    %dx,0x1024e6(,%eax,8)
  100dfc:	00 
  for(i = 0; i < 256; i++)
  100dfd:	83 c0 01             	add    $0x1,%eax
  100e00:	3d 00 01 00 00       	cmp    $0x100,%eax
  100e05:	75 d1                	jne    100dd8 <tvinit+0x8>
}
  100e07:	c3                   	ret
  100e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100e0f:	90                   	nop

00100e10 <idtinit>:

void
idtinit(void)
{
  100e10:	55                   	push   %ebp
  pd[0] = size-1;
  100e11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
  100e16:	89 e5                	mov    %esp,%ebp
  100e18:	83 ec 10             	sub    $0x10,%esp
  100e1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
  100e1f:	b8 e0 24 10 00       	mov    $0x1024e0,%eax
  100e24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  100e28:	c1 e8 10             	shr    $0x10,%eax
  100e2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
  100e2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
  100e32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  100e35:	c9                   	leave
  100e36:	c3                   	ret
  100e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100e3e:	66 90                	xchg   %ax,%ax

00100e40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  100e40:	55                   	push   %ebp
  100e41:	89 e5                	mov    %esp,%ebp
  100e43:	57                   	push   %edi
  100e44:	56                   	push   %esi
  100e45:	53                   	push   %ebx
  100e46:	83 ec 0c             	sub    $0xc,%esp
  100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  switch(tf->trapno){
  100e4c:	8b 43 20             	mov    0x20(%ebx),%eax
  100e4f:	83 e8 20             	sub    $0x20,%eax
  100e52:	83 f8 1f             	cmp    $0x1f,%eax
  100e55:	77 7c                	ja     100ed3 <trap+0x93>
  100e57:	ff 24 85 00 1d 10 00 	jmp    *0x101d00(,%eax,4)
  100e5e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;
  
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  100e60:	8b 73 28             	mov    0x28(%ebx),%esi
  100e63:	0f b7 5b 2c          	movzwl 0x2c(%ebx),%ebx
  100e67:	e8 b4 fe ff ff       	call   100d20 <cpuid>
  100e6c:	56                   	push   %esi
  100e6d:	53                   	push   %ebx
  100e6e:	50                   	push   %eax
  100e6f:	68 a8 1c 10 00       	push   $0x101ca8
  100e74:	e8 37 f2 ff ff       	call   1000b0 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
  100e79:	83 c4 10             	add    $0x10,%esp
  default:
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
            tf->trapno, cpuid(), tf->eip, rcr2());
    panic("trap");
  }
}
  100e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e7f:	5b                   	pop    %ebx
  100e80:	5e                   	pop    %esi
  100e81:	5f                   	pop    %edi
  100e82:	5d                   	pop    %ebp
    lapiceoi();
  100e83:	e9 c8 f7 ff ff       	jmp    100650 <lapiceoi>
  100e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100e8f:	90                   	nop
    mouseintr();
  100e90:	e8 5b 0c 00 00       	call   101af0 <mouseintr>
}
  100e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e98:	5b                   	pop    %ebx
  100e99:	5e                   	pop    %esi
  100e9a:	5f                   	pop    %edi
  100e9b:	5d                   	pop    %ebp
    lapiceoi();
  100e9c:	e9 af f7 ff ff       	jmp    100650 <lapiceoi>
  100ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
  100ea8:	e8 e3 fb ff ff       	call   100a90 <uartintr>
}
  100ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100eb0:	5b                   	pop    %ebx
  100eb1:	5e                   	pop    %esi
  100eb2:	5f                   	pop    %edi
  100eb3:	5d                   	pop    %ebp
    lapiceoi();
  100eb4:	e9 97 f7 ff ff       	jmp    100650 <lapiceoi>
  100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ticks++;
  100ec0:	83 05 c0 24 10 00 01 	addl   $0x1,0x1024c0
}
  100ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100eca:	5b                   	pop    %ebx
  100ecb:	5e                   	pop    %esi
  100ecc:	5f                   	pop    %edi
  100ecd:	5d                   	pop    %ebp
    lapiceoi();
  100ece:	e9 7d f7 ff ff       	jmp    100650 <lapiceoi>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  100ed3:	0f 20 d7             	mov    %cr2,%edi
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  100ed6:	8b 73 28             	mov    0x28(%ebx),%esi
  100ed9:	e8 42 fe ff ff       	call   100d20 <cpuid>
  100ede:	83 ec 0c             	sub    $0xc,%esp
  100ee1:	57                   	push   %edi
  100ee2:	56                   	push   %esi
  100ee3:	50                   	push   %eax
  100ee4:	ff 73 20             	push   0x20(%ebx)
  100ee7:	68 cc 1c 10 00       	push   $0x101ccc
  100eec:	e8 bf f1 ff ff       	call   1000b0 <cprintf>
    panic("trap");
  100ef1:	83 c4 14             	add    $0x14,%esp
  100ef4:	68 d5 1b 10 00       	push   $0x101bd5
  100ef9:	e8 32 f3 ff ff       	call   100230 <panic>

00100efe <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  100efe:	6a 00                	push   $0x0
  pushl $0
  100f00:	6a 00                	push   $0x0
  jmp alltraps
  100f02:	e9 af fe ff ff       	jmp    100db6 <alltraps>

00100f07 <vector1>:
.globl vector1
vector1:
  pushl $0
  100f07:	6a 00                	push   $0x0
  pushl $1
  100f09:	6a 01                	push   $0x1
  jmp alltraps
  100f0b:	e9 a6 fe ff ff       	jmp    100db6 <alltraps>

00100f10 <vector2>:
.globl vector2
vector2:
  pushl $0
  100f10:	6a 00                	push   $0x0
  pushl $2
  100f12:	6a 02                	push   $0x2
  jmp alltraps
  100f14:	e9 9d fe ff ff       	jmp    100db6 <alltraps>

00100f19 <vector3>:
.globl vector3
vector3:
  pushl $0
  100f19:	6a 00                	push   $0x0
  pushl $3
  100f1b:	6a 03                	push   $0x3
  jmp alltraps
  100f1d:	e9 94 fe ff ff       	jmp    100db6 <alltraps>

00100f22 <vector4>:
.globl vector4
vector4:
  pushl $0
  100f22:	6a 00                	push   $0x0
  pushl $4
  100f24:	6a 04                	push   $0x4
  jmp alltraps
  100f26:	e9 8b fe ff ff       	jmp    100db6 <alltraps>

00100f2b <vector5>:
.globl vector5
vector5:
  pushl $0
  100f2b:	6a 00                	push   $0x0
  pushl $5
  100f2d:	6a 05                	push   $0x5
  jmp alltraps
  100f2f:	e9 82 fe ff ff       	jmp    100db6 <alltraps>

00100f34 <vector6>:
.globl vector6
vector6:
  pushl $0
  100f34:	6a 00                	push   $0x0
  pushl $6
  100f36:	6a 06                	push   $0x6
  jmp alltraps
  100f38:	e9 79 fe ff ff       	jmp    100db6 <alltraps>

00100f3d <vector7>:
.globl vector7
vector7:
  pushl $0
  100f3d:	6a 00                	push   $0x0
  pushl $7
  100f3f:	6a 07                	push   $0x7
  jmp alltraps
  100f41:	e9 70 fe ff ff       	jmp    100db6 <alltraps>

00100f46 <vector8>:
.globl vector8
vector8:
  pushl $8
  100f46:	6a 08                	push   $0x8
  jmp alltraps
  100f48:	e9 69 fe ff ff       	jmp    100db6 <alltraps>

00100f4d <vector9>:
.globl vector9
vector9:
  pushl $0
  100f4d:	6a 00                	push   $0x0
  pushl $9
  100f4f:	6a 09                	push   $0x9
  jmp alltraps
  100f51:	e9 60 fe ff ff       	jmp    100db6 <alltraps>

00100f56 <vector10>:
.globl vector10
vector10:
  pushl $10
  100f56:	6a 0a                	push   $0xa
  jmp alltraps
  100f58:	e9 59 fe ff ff       	jmp    100db6 <alltraps>

00100f5d <vector11>:
.globl vector11
vector11:
  pushl $11
  100f5d:	6a 0b                	push   $0xb
  jmp alltraps
  100f5f:	e9 52 fe ff ff       	jmp    100db6 <alltraps>

00100f64 <vector12>:
.globl vector12
vector12:
  pushl $12
  100f64:	6a 0c                	push   $0xc
  jmp alltraps
  100f66:	e9 4b fe ff ff       	jmp    100db6 <alltraps>

00100f6b <vector13>:
.globl vector13
vector13:
  pushl $13
  100f6b:	6a 0d                	push   $0xd
  jmp alltraps
  100f6d:	e9 44 fe ff ff       	jmp    100db6 <alltraps>

00100f72 <vector14>:
.globl vector14
vector14:
  pushl $14
  100f72:	6a 0e                	push   $0xe
  jmp alltraps
  100f74:	e9 3d fe ff ff       	jmp    100db6 <alltraps>

00100f79 <vector15>:
.globl vector15
vector15:
  pushl $0
  100f79:	6a 00                	push   $0x0
  pushl $15
  100f7b:	6a 0f                	push   $0xf
  jmp alltraps
  100f7d:	e9 34 fe ff ff       	jmp    100db6 <alltraps>

00100f82 <vector16>:
.globl vector16
vector16:
  pushl $0
  100f82:	6a 00                	push   $0x0
  pushl $16
  100f84:	6a 10                	push   $0x10
  jmp alltraps
  100f86:	e9 2b fe ff ff       	jmp    100db6 <alltraps>

00100f8b <vector17>:
.globl vector17
vector17:
  pushl $17
  100f8b:	6a 11                	push   $0x11
  jmp alltraps
  100f8d:	e9 24 fe ff ff       	jmp    100db6 <alltraps>

00100f92 <vector18>:
.globl vector18
vector18:
  pushl $0
  100f92:	6a 00                	push   $0x0
  pushl $18
  100f94:	6a 12                	push   $0x12
  jmp alltraps
  100f96:	e9 1b fe ff ff       	jmp    100db6 <alltraps>

00100f9b <vector19>:
.globl vector19
vector19:
  pushl $0
  100f9b:	6a 00                	push   $0x0
  pushl $19
  100f9d:	6a 13                	push   $0x13
  jmp alltraps
  100f9f:	e9 12 fe ff ff       	jmp    100db6 <alltraps>

00100fa4 <vector20>:
.globl vector20
vector20:
  pushl $0
  100fa4:	6a 00                	push   $0x0
  pushl $20
  100fa6:	6a 14                	push   $0x14
  jmp alltraps
  100fa8:	e9 09 fe ff ff       	jmp    100db6 <alltraps>

00100fad <vector21>:
.globl vector21
vector21:
  pushl $0
  100fad:	6a 00                	push   $0x0
  pushl $21
  100faf:	6a 15                	push   $0x15
  jmp alltraps
  100fb1:	e9 00 fe ff ff       	jmp    100db6 <alltraps>

00100fb6 <vector22>:
.globl vector22
vector22:
  pushl $0
  100fb6:	6a 00                	push   $0x0
  pushl $22
  100fb8:	6a 16                	push   $0x16
  jmp alltraps
  100fba:	e9 f7 fd ff ff       	jmp    100db6 <alltraps>

00100fbf <vector23>:
.globl vector23
vector23:
  pushl $0
  100fbf:	6a 00                	push   $0x0
  pushl $23
  100fc1:	6a 17                	push   $0x17
  jmp alltraps
  100fc3:	e9 ee fd ff ff       	jmp    100db6 <alltraps>

00100fc8 <vector24>:
.globl vector24
vector24:
  pushl $0
  100fc8:	6a 00                	push   $0x0
  pushl $24
  100fca:	6a 18                	push   $0x18
  jmp alltraps
  100fcc:	e9 e5 fd ff ff       	jmp    100db6 <alltraps>

00100fd1 <vector25>:
.globl vector25
vector25:
  pushl $0
  100fd1:	6a 00                	push   $0x0
  pushl $25
  100fd3:	6a 19                	push   $0x19
  jmp alltraps
  100fd5:	e9 dc fd ff ff       	jmp    100db6 <alltraps>

00100fda <vector26>:
.globl vector26
vector26:
  pushl $0
  100fda:	6a 00                	push   $0x0
  pushl $26
  100fdc:	6a 1a                	push   $0x1a
  jmp alltraps
  100fde:	e9 d3 fd ff ff       	jmp    100db6 <alltraps>

00100fe3 <vector27>:
.globl vector27
vector27:
  pushl $0
  100fe3:	6a 00                	push   $0x0
  pushl $27
  100fe5:	6a 1b                	push   $0x1b
  jmp alltraps
  100fe7:	e9 ca fd ff ff       	jmp    100db6 <alltraps>

00100fec <vector28>:
.globl vector28
vector28:
  pushl $0
  100fec:	6a 00                	push   $0x0
  pushl $28
  100fee:	6a 1c                	push   $0x1c
  jmp alltraps
  100ff0:	e9 c1 fd ff ff       	jmp    100db6 <alltraps>

00100ff5 <vector29>:
.globl vector29
vector29:
  pushl $0
  100ff5:	6a 00                	push   $0x0
  pushl $29
  100ff7:	6a 1d                	push   $0x1d
  jmp alltraps
  100ff9:	e9 b8 fd ff ff       	jmp    100db6 <alltraps>

00100ffe <vector30>:
.globl vector30
vector30:
  pushl $0
  100ffe:	6a 00                	push   $0x0
  pushl $30
  101000:	6a 1e                	push   $0x1e
  jmp alltraps
  101002:	e9 af fd ff ff       	jmp    100db6 <alltraps>

00101007 <vector31>:
.globl vector31
vector31:
  pushl $0
  101007:	6a 00                	push   $0x0
  pushl $31
  101009:	6a 1f                	push   $0x1f
  jmp alltraps
  10100b:	e9 a6 fd ff ff       	jmp    100db6 <alltraps>

00101010 <vector32>:
.globl vector32
vector32:
  pushl $0
  101010:	6a 00                	push   $0x0
  pushl $32
  101012:	6a 20                	push   $0x20
  jmp alltraps
  101014:	e9 9d fd ff ff       	jmp    100db6 <alltraps>

00101019 <vector33>:
.globl vector33
vector33:
  pushl $0
  101019:	6a 00                	push   $0x0
  pushl $33
  10101b:	6a 21                	push   $0x21
  jmp alltraps
  10101d:	e9 94 fd ff ff       	jmp    100db6 <alltraps>

00101022 <vector34>:
.globl vector34
vector34:
  pushl $0
  101022:	6a 00                	push   $0x0
  pushl $34
  101024:	6a 22                	push   $0x22
  jmp alltraps
  101026:	e9 8b fd ff ff       	jmp    100db6 <alltraps>

0010102b <vector35>:
.globl vector35
vector35:
  pushl $0
  10102b:	6a 00                	push   $0x0
  pushl $35
  10102d:	6a 23                	push   $0x23
  jmp alltraps
  10102f:	e9 82 fd ff ff       	jmp    100db6 <alltraps>

00101034 <vector36>:
.globl vector36
vector36:
  pushl $0
  101034:	6a 00                	push   $0x0
  pushl $36
  101036:	6a 24                	push   $0x24
  jmp alltraps
  101038:	e9 79 fd ff ff       	jmp    100db6 <alltraps>

0010103d <vector37>:
.globl vector37
vector37:
  pushl $0
  10103d:	6a 00                	push   $0x0
  pushl $37
  10103f:	6a 25                	push   $0x25
  jmp alltraps
  101041:	e9 70 fd ff ff       	jmp    100db6 <alltraps>

00101046 <vector38>:
.globl vector38
vector38:
  pushl $0
  101046:	6a 00                	push   $0x0
  pushl $38
  101048:	6a 26                	push   $0x26
  jmp alltraps
  10104a:	e9 67 fd ff ff       	jmp    100db6 <alltraps>

0010104f <vector39>:
.globl vector39
vector39:
  pushl $0
  10104f:	6a 00                	push   $0x0
  pushl $39
  101051:	6a 27                	push   $0x27
  jmp alltraps
  101053:	e9 5e fd ff ff       	jmp    100db6 <alltraps>

00101058 <vector40>:
.globl vector40
vector40:
  pushl $0
  101058:	6a 00                	push   $0x0
  pushl $40
  10105a:	6a 28                	push   $0x28
  jmp alltraps
  10105c:	e9 55 fd ff ff       	jmp    100db6 <alltraps>

00101061 <vector41>:
.globl vector41
vector41:
  pushl $0
  101061:	6a 00                	push   $0x0
  pushl $41
  101063:	6a 29                	push   $0x29
  jmp alltraps
  101065:	e9 4c fd ff ff       	jmp    100db6 <alltraps>

0010106a <vector42>:
.globl vector42
vector42:
  pushl $0
  10106a:	6a 00                	push   $0x0
  pushl $42
  10106c:	6a 2a                	push   $0x2a
  jmp alltraps
  10106e:	e9 43 fd ff ff       	jmp    100db6 <alltraps>

00101073 <vector43>:
.globl vector43
vector43:
  pushl $0
  101073:	6a 00                	push   $0x0
  pushl $43
  101075:	6a 2b                	push   $0x2b
  jmp alltraps
  101077:	e9 3a fd ff ff       	jmp    100db6 <alltraps>

0010107c <vector44>:
.globl vector44
vector44:
  pushl $0
  10107c:	6a 00                	push   $0x0
  pushl $44
  10107e:	6a 2c                	push   $0x2c
  jmp alltraps
  101080:	e9 31 fd ff ff       	jmp    100db6 <alltraps>

00101085 <vector45>:
.globl vector45
vector45:
  pushl $0
  101085:	6a 00                	push   $0x0
  pushl $45
  101087:	6a 2d                	push   $0x2d
  jmp alltraps
  101089:	e9 28 fd ff ff       	jmp    100db6 <alltraps>

0010108e <vector46>:
.globl vector46
vector46:
  pushl $0
  10108e:	6a 00                	push   $0x0
  pushl $46
  101090:	6a 2e                	push   $0x2e
  jmp alltraps
  101092:	e9 1f fd ff ff       	jmp    100db6 <alltraps>

00101097 <vector47>:
.globl vector47
vector47:
  pushl $0
  101097:	6a 00                	push   $0x0
  pushl $47
  101099:	6a 2f                	push   $0x2f
  jmp alltraps
  10109b:	e9 16 fd ff ff       	jmp    100db6 <alltraps>

001010a0 <vector48>:
.globl vector48
vector48:
  pushl $0
  1010a0:	6a 00                	push   $0x0
  pushl $48
  1010a2:	6a 30                	push   $0x30
  jmp alltraps
  1010a4:	e9 0d fd ff ff       	jmp    100db6 <alltraps>

001010a9 <vector49>:
.globl vector49
vector49:
  pushl $0
  1010a9:	6a 00                	push   $0x0
  pushl $49
  1010ab:	6a 31                	push   $0x31
  jmp alltraps
  1010ad:	e9 04 fd ff ff       	jmp    100db6 <alltraps>

001010b2 <vector50>:
.globl vector50
vector50:
  pushl $0
  1010b2:	6a 00                	push   $0x0
  pushl $50
  1010b4:	6a 32                	push   $0x32
  jmp alltraps
  1010b6:	e9 fb fc ff ff       	jmp    100db6 <alltraps>

001010bb <vector51>:
.globl vector51
vector51:
  pushl $0
  1010bb:	6a 00                	push   $0x0
  pushl $51
  1010bd:	6a 33                	push   $0x33
  jmp alltraps
  1010bf:	e9 f2 fc ff ff       	jmp    100db6 <alltraps>

001010c4 <vector52>:
.globl vector52
vector52:
  pushl $0
  1010c4:	6a 00                	push   $0x0
  pushl $52
  1010c6:	6a 34                	push   $0x34
  jmp alltraps
  1010c8:	e9 e9 fc ff ff       	jmp    100db6 <alltraps>

001010cd <vector53>:
.globl vector53
vector53:
  pushl $0
  1010cd:	6a 00                	push   $0x0
  pushl $53
  1010cf:	6a 35                	push   $0x35
  jmp alltraps
  1010d1:	e9 e0 fc ff ff       	jmp    100db6 <alltraps>

001010d6 <vector54>:
.globl vector54
vector54:
  pushl $0
  1010d6:	6a 00                	push   $0x0
  pushl $54
  1010d8:	6a 36                	push   $0x36
  jmp alltraps
  1010da:	e9 d7 fc ff ff       	jmp    100db6 <alltraps>

001010df <vector55>:
.globl vector55
vector55:
  pushl $0
  1010df:	6a 00                	push   $0x0
  pushl $55
  1010e1:	6a 37                	push   $0x37
  jmp alltraps
  1010e3:	e9 ce fc ff ff       	jmp    100db6 <alltraps>

001010e8 <vector56>:
.globl vector56
vector56:
  pushl $0
  1010e8:	6a 00                	push   $0x0
  pushl $56
  1010ea:	6a 38                	push   $0x38
  jmp alltraps
  1010ec:	e9 c5 fc ff ff       	jmp    100db6 <alltraps>

001010f1 <vector57>:
.globl vector57
vector57:
  pushl $0
  1010f1:	6a 00                	push   $0x0
  pushl $57
  1010f3:	6a 39                	push   $0x39
  jmp alltraps
  1010f5:	e9 bc fc ff ff       	jmp    100db6 <alltraps>

001010fa <vector58>:
.globl vector58
vector58:
  pushl $0
  1010fa:	6a 00                	push   $0x0
  pushl $58
  1010fc:	6a 3a                	push   $0x3a
  jmp alltraps
  1010fe:	e9 b3 fc ff ff       	jmp    100db6 <alltraps>

00101103 <vector59>:
.globl vector59
vector59:
  pushl $0
  101103:	6a 00                	push   $0x0
  pushl $59
  101105:	6a 3b                	push   $0x3b
  jmp alltraps
  101107:	e9 aa fc ff ff       	jmp    100db6 <alltraps>

0010110c <vector60>:
.globl vector60
vector60:
  pushl $0
  10110c:	6a 00                	push   $0x0
  pushl $60
  10110e:	6a 3c                	push   $0x3c
  jmp alltraps
  101110:	e9 a1 fc ff ff       	jmp    100db6 <alltraps>

00101115 <vector61>:
.globl vector61
vector61:
  pushl $0
  101115:	6a 00                	push   $0x0
  pushl $61
  101117:	6a 3d                	push   $0x3d
  jmp alltraps
  101119:	e9 98 fc ff ff       	jmp    100db6 <alltraps>

0010111e <vector62>:
.globl vector62
vector62:
  pushl $0
  10111e:	6a 00                	push   $0x0
  pushl $62
  101120:	6a 3e                	push   $0x3e
  jmp alltraps
  101122:	e9 8f fc ff ff       	jmp    100db6 <alltraps>

00101127 <vector63>:
.globl vector63
vector63:
  pushl $0
  101127:	6a 00                	push   $0x0
  pushl $63
  101129:	6a 3f                	push   $0x3f
  jmp alltraps
  10112b:	e9 86 fc ff ff       	jmp    100db6 <alltraps>

00101130 <vector64>:
.globl vector64
vector64:
  pushl $0
  101130:	6a 00                	push   $0x0
  pushl $64
  101132:	6a 40                	push   $0x40
  jmp alltraps
  101134:	e9 7d fc ff ff       	jmp    100db6 <alltraps>

00101139 <vector65>:
.globl vector65
vector65:
  pushl $0
  101139:	6a 00                	push   $0x0
  pushl $65
  10113b:	6a 41                	push   $0x41
  jmp alltraps
  10113d:	e9 74 fc ff ff       	jmp    100db6 <alltraps>

00101142 <vector66>:
.globl vector66
vector66:
  pushl $0
  101142:	6a 00                	push   $0x0
  pushl $66
  101144:	6a 42                	push   $0x42
  jmp alltraps
  101146:	e9 6b fc ff ff       	jmp    100db6 <alltraps>

0010114b <vector67>:
.globl vector67
vector67:
  pushl $0
  10114b:	6a 00                	push   $0x0
  pushl $67
  10114d:	6a 43                	push   $0x43
  jmp alltraps
  10114f:	e9 62 fc ff ff       	jmp    100db6 <alltraps>

00101154 <vector68>:
.globl vector68
vector68:
  pushl $0
  101154:	6a 00                	push   $0x0
  pushl $68
  101156:	6a 44                	push   $0x44
  jmp alltraps
  101158:	e9 59 fc ff ff       	jmp    100db6 <alltraps>

0010115d <vector69>:
.globl vector69
vector69:
  pushl $0
  10115d:	6a 00                	push   $0x0
  pushl $69
  10115f:	6a 45                	push   $0x45
  jmp alltraps
  101161:	e9 50 fc ff ff       	jmp    100db6 <alltraps>

00101166 <vector70>:
.globl vector70
vector70:
  pushl $0
  101166:	6a 00                	push   $0x0
  pushl $70
  101168:	6a 46                	push   $0x46
  jmp alltraps
  10116a:	e9 47 fc ff ff       	jmp    100db6 <alltraps>

0010116f <vector71>:
.globl vector71
vector71:
  pushl $0
  10116f:	6a 00                	push   $0x0
  pushl $71
  101171:	6a 47                	push   $0x47
  jmp alltraps
  101173:	e9 3e fc ff ff       	jmp    100db6 <alltraps>

00101178 <vector72>:
.globl vector72
vector72:
  pushl $0
  101178:	6a 00                	push   $0x0
  pushl $72
  10117a:	6a 48                	push   $0x48
  jmp alltraps
  10117c:	e9 35 fc ff ff       	jmp    100db6 <alltraps>

00101181 <vector73>:
.globl vector73
vector73:
  pushl $0
  101181:	6a 00                	push   $0x0
  pushl $73
  101183:	6a 49                	push   $0x49
  jmp alltraps
  101185:	e9 2c fc ff ff       	jmp    100db6 <alltraps>

0010118a <vector74>:
.globl vector74
vector74:
  pushl $0
  10118a:	6a 00                	push   $0x0
  pushl $74
  10118c:	6a 4a                	push   $0x4a
  jmp alltraps
  10118e:	e9 23 fc ff ff       	jmp    100db6 <alltraps>

00101193 <vector75>:
.globl vector75
vector75:
  pushl $0
  101193:	6a 00                	push   $0x0
  pushl $75
  101195:	6a 4b                	push   $0x4b
  jmp alltraps
  101197:	e9 1a fc ff ff       	jmp    100db6 <alltraps>

0010119c <vector76>:
.globl vector76
vector76:
  pushl $0
  10119c:	6a 00                	push   $0x0
  pushl $76
  10119e:	6a 4c                	push   $0x4c
  jmp alltraps
  1011a0:	e9 11 fc ff ff       	jmp    100db6 <alltraps>

001011a5 <vector77>:
.globl vector77
vector77:
  pushl $0
  1011a5:	6a 00                	push   $0x0
  pushl $77
  1011a7:	6a 4d                	push   $0x4d
  jmp alltraps
  1011a9:	e9 08 fc ff ff       	jmp    100db6 <alltraps>

001011ae <vector78>:
.globl vector78
vector78:
  pushl $0
  1011ae:	6a 00                	push   $0x0
  pushl $78
  1011b0:	6a 4e                	push   $0x4e
  jmp alltraps
  1011b2:	e9 ff fb ff ff       	jmp    100db6 <alltraps>

001011b7 <vector79>:
.globl vector79
vector79:
  pushl $0
  1011b7:	6a 00                	push   $0x0
  pushl $79
  1011b9:	6a 4f                	push   $0x4f
  jmp alltraps
  1011bb:	e9 f6 fb ff ff       	jmp    100db6 <alltraps>

001011c0 <vector80>:
.globl vector80
vector80:
  pushl $0
  1011c0:	6a 00                	push   $0x0
  pushl $80
  1011c2:	6a 50                	push   $0x50
  jmp alltraps
  1011c4:	e9 ed fb ff ff       	jmp    100db6 <alltraps>

001011c9 <vector81>:
.globl vector81
vector81:
  pushl $0
  1011c9:	6a 00                	push   $0x0
  pushl $81
  1011cb:	6a 51                	push   $0x51
  jmp alltraps
  1011cd:	e9 e4 fb ff ff       	jmp    100db6 <alltraps>

001011d2 <vector82>:
.globl vector82
vector82:
  pushl $0
  1011d2:	6a 00                	push   $0x0
  pushl $82
  1011d4:	6a 52                	push   $0x52
  jmp alltraps
  1011d6:	e9 db fb ff ff       	jmp    100db6 <alltraps>

001011db <vector83>:
.globl vector83
vector83:
  pushl $0
  1011db:	6a 00                	push   $0x0
  pushl $83
  1011dd:	6a 53                	push   $0x53
  jmp alltraps
  1011df:	e9 d2 fb ff ff       	jmp    100db6 <alltraps>

001011e4 <vector84>:
.globl vector84
vector84:
  pushl $0
  1011e4:	6a 00                	push   $0x0
  pushl $84
  1011e6:	6a 54                	push   $0x54
  jmp alltraps
  1011e8:	e9 c9 fb ff ff       	jmp    100db6 <alltraps>

001011ed <vector85>:
.globl vector85
vector85:
  pushl $0
  1011ed:	6a 00                	push   $0x0
  pushl $85
  1011ef:	6a 55                	push   $0x55
  jmp alltraps
  1011f1:	e9 c0 fb ff ff       	jmp    100db6 <alltraps>

001011f6 <vector86>:
.globl vector86
vector86:
  pushl $0
  1011f6:	6a 00                	push   $0x0
  pushl $86
  1011f8:	6a 56                	push   $0x56
  jmp alltraps
  1011fa:	e9 b7 fb ff ff       	jmp    100db6 <alltraps>

001011ff <vector87>:
.globl vector87
vector87:
  pushl $0
  1011ff:	6a 00                	push   $0x0
  pushl $87
  101201:	6a 57                	push   $0x57
  jmp alltraps
  101203:	e9 ae fb ff ff       	jmp    100db6 <alltraps>

00101208 <vector88>:
.globl vector88
vector88:
  pushl $0
  101208:	6a 00                	push   $0x0
  pushl $88
  10120a:	6a 58                	push   $0x58
  jmp alltraps
  10120c:	e9 a5 fb ff ff       	jmp    100db6 <alltraps>

00101211 <vector89>:
.globl vector89
vector89:
  pushl $0
  101211:	6a 00                	push   $0x0
  pushl $89
  101213:	6a 59                	push   $0x59
  jmp alltraps
  101215:	e9 9c fb ff ff       	jmp    100db6 <alltraps>

0010121a <vector90>:
.globl vector90
vector90:
  pushl $0
  10121a:	6a 00                	push   $0x0
  pushl $90
  10121c:	6a 5a                	push   $0x5a
  jmp alltraps
  10121e:	e9 93 fb ff ff       	jmp    100db6 <alltraps>

00101223 <vector91>:
.globl vector91
vector91:
  pushl $0
  101223:	6a 00                	push   $0x0
  pushl $91
  101225:	6a 5b                	push   $0x5b
  jmp alltraps
  101227:	e9 8a fb ff ff       	jmp    100db6 <alltraps>

0010122c <vector92>:
.globl vector92
vector92:
  pushl $0
  10122c:	6a 00                	push   $0x0
  pushl $92
  10122e:	6a 5c                	push   $0x5c
  jmp alltraps
  101230:	e9 81 fb ff ff       	jmp    100db6 <alltraps>

00101235 <vector93>:
.globl vector93
vector93:
  pushl $0
  101235:	6a 00                	push   $0x0
  pushl $93
  101237:	6a 5d                	push   $0x5d
  jmp alltraps
  101239:	e9 78 fb ff ff       	jmp    100db6 <alltraps>

0010123e <vector94>:
.globl vector94
vector94:
  pushl $0
  10123e:	6a 00                	push   $0x0
  pushl $94
  101240:	6a 5e                	push   $0x5e
  jmp alltraps
  101242:	e9 6f fb ff ff       	jmp    100db6 <alltraps>

00101247 <vector95>:
.globl vector95
vector95:
  pushl $0
  101247:	6a 00                	push   $0x0
  pushl $95
  101249:	6a 5f                	push   $0x5f
  jmp alltraps
  10124b:	e9 66 fb ff ff       	jmp    100db6 <alltraps>

00101250 <vector96>:
.globl vector96
vector96:
  pushl $0
  101250:	6a 00                	push   $0x0
  pushl $96
  101252:	6a 60                	push   $0x60
  jmp alltraps
  101254:	e9 5d fb ff ff       	jmp    100db6 <alltraps>

00101259 <vector97>:
.globl vector97
vector97:
  pushl $0
  101259:	6a 00                	push   $0x0
  pushl $97
  10125b:	6a 61                	push   $0x61
  jmp alltraps
  10125d:	e9 54 fb ff ff       	jmp    100db6 <alltraps>

00101262 <vector98>:
.globl vector98
vector98:
  pushl $0
  101262:	6a 00                	push   $0x0
  pushl $98
  101264:	6a 62                	push   $0x62
  jmp alltraps
  101266:	e9 4b fb ff ff       	jmp    100db6 <alltraps>

0010126b <vector99>:
.globl vector99
vector99:
  pushl $0
  10126b:	6a 00                	push   $0x0
  pushl $99
  10126d:	6a 63                	push   $0x63
  jmp alltraps
  10126f:	e9 42 fb ff ff       	jmp    100db6 <alltraps>

00101274 <vector100>:
.globl vector100
vector100:
  pushl $0
  101274:	6a 00                	push   $0x0
  pushl $100
  101276:	6a 64                	push   $0x64
  jmp alltraps
  101278:	e9 39 fb ff ff       	jmp    100db6 <alltraps>

0010127d <vector101>:
.globl vector101
vector101:
  pushl $0
  10127d:	6a 00                	push   $0x0
  pushl $101
  10127f:	6a 65                	push   $0x65
  jmp alltraps
  101281:	e9 30 fb ff ff       	jmp    100db6 <alltraps>

00101286 <vector102>:
.globl vector102
vector102:
  pushl $0
  101286:	6a 00                	push   $0x0
  pushl $102
  101288:	6a 66                	push   $0x66
  jmp alltraps
  10128a:	e9 27 fb ff ff       	jmp    100db6 <alltraps>

0010128f <vector103>:
.globl vector103
vector103:
  pushl $0
  10128f:	6a 00                	push   $0x0
  pushl $103
  101291:	6a 67                	push   $0x67
  jmp alltraps
  101293:	e9 1e fb ff ff       	jmp    100db6 <alltraps>

00101298 <vector104>:
.globl vector104
vector104:
  pushl $0
  101298:	6a 00                	push   $0x0
  pushl $104
  10129a:	6a 68                	push   $0x68
  jmp alltraps
  10129c:	e9 15 fb ff ff       	jmp    100db6 <alltraps>

001012a1 <vector105>:
.globl vector105
vector105:
  pushl $0
  1012a1:	6a 00                	push   $0x0
  pushl $105
  1012a3:	6a 69                	push   $0x69
  jmp alltraps
  1012a5:	e9 0c fb ff ff       	jmp    100db6 <alltraps>

001012aa <vector106>:
.globl vector106
vector106:
  pushl $0
  1012aa:	6a 00                	push   $0x0
  pushl $106
  1012ac:	6a 6a                	push   $0x6a
  jmp alltraps
  1012ae:	e9 03 fb ff ff       	jmp    100db6 <alltraps>

001012b3 <vector107>:
.globl vector107
vector107:
  pushl $0
  1012b3:	6a 00                	push   $0x0
  pushl $107
  1012b5:	6a 6b                	push   $0x6b
  jmp alltraps
  1012b7:	e9 fa fa ff ff       	jmp    100db6 <alltraps>

001012bc <vector108>:
.globl vector108
vector108:
  pushl $0
  1012bc:	6a 00                	push   $0x0
  pushl $108
  1012be:	6a 6c                	push   $0x6c
  jmp alltraps
  1012c0:	e9 f1 fa ff ff       	jmp    100db6 <alltraps>

001012c5 <vector109>:
.globl vector109
vector109:
  pushl $0
  1012c5:	6a 00                	push   $0x0
  pushl $109
  1012c7:	6a 6d                	push   $0x6d
  jmp alltraps
  1012c9:	e9 e8 fa ff ff       	jmp    100db6 <alltraps>

001012ce <vector110>:
.globl vector110
vector110:
  pushl $0
  1012ce:	6a 00                	push   $0x0
  pushl $110
  1012d0:	6a 6e                	push   $0x6e
  jmp alltraps
  1012d2:	e9 df fa ff ff       	jmp    100db6 <alltraps>

001012d7 <vector111>:
.globl vector111
vector111:
  pushl $0
  1012d7:	6a 00                	push   $0x0
  pushl $111
  1012d9:	6a 6f                	push   $0x6f
  jmp alltraps
  1012db:	e9 d6 fa ff ff       	jmp    100db6 <alltraps>

001012e0 <vector112>:
.globl vector112
vector112:
  pushl $0
  1012e0:	6a 00                	push   $0x0
  pushl $112
  1012e2:	6a 70                	push   $0x70
  jmp alltraps
  1012e4:	e9 cd fa ff ff       	jmp    100db6 <alltraps>

001012e9 <vector113>:
.globl vector113
vector113:
  pushl $0
  1012e9:	6a 00                	push   $0x0
  pushl $113
  1012eb:	6a 71                	push   $0x71
  jmp alltraps
  1012ed:	e9 c4 fa ff ff       	jmp    100db6 <alltraps>

001012f2 <vector114>:
.globl vector114
vector114:
  pushl $0
  1012f2:	6a 00                	push   $0x0
  pushl $114
  1012f4:	6a 72                	push   $0x72
  jmp alltraps
  1012f6:	e9 bb fa ff ff       	jmp    100db6 <alltraps>

001012fb <vector115>:
.globl vector115
vector115:
  pushl $0
  1012fb:	6a 00                	push   $0x0
  pushl $115
  1012fd:	6a 73                	push   $0x73
  jmp alltraps
  1012ff:	e9 b2 fa ff ff       	jmp    100db6 <alltraps>

00101304 <vector116>:
.globl vector116
vector116:
  pushl $0
  101304:	6a 00                	push   $0x0
  pushl $116
  101306:	6a 74                	push   $0x74
  jmp alltraps
  101308:	e9 a9 fa ff ff       	jmp    100db6 <alltraps>

0010130d <vector117>:
.globl vector117
vector117:
  pushl $0
  10130d:	6a 00                	push   $0x0
  pushl $117
  10130f:	6a 75                	push   $0x75
  jmp alltraps
  101311:	e9 a0 fa ff ff       	jmp    100db6 <alltraps>

00101316 <vector118>:
.globl vector118
vector118:
  pushl $0
  101316:	6a 00                	push   $0x0
  pushl $118
  101318:	6a 76                	push   $0x76
  jmp alltraps
  10131a:	e9 97 fa ff ff       	jmp    100db6 <alltraps>

0010131f <vector119>:
.globl vector119
vector119:
  pushl $0
  10131f:	6a 00                	push   $0x0
  pushl $119
  101321:	6a 77                	push   $0x77
  jmp alltraps
  101323:	e9 8e fa ff ff       	jmp    100db6 <alltraps>

00101328 <vector120>:
.globl vector120
vector120:
  pushl $0
  101328:	6a 00                	push   $0x0
  pushl $120
  10132a:	6a 78                	push   $0x78
  jmp alltraps
  10132c:	e9 85 fa ff ff       	jmp    100db6 <alltraps>

00101331 <vector121>:
.globl vector121
vector121:
  pushl $0
  101331:	6a 00                	push   $0x0
  pushl $121
  101333:	6a 79                	push   $0x79
  jmp alltraps
  101335:	e9 7c fa ff ff       	jmp    100db6 <alltraps>

0010133a <vector122>:
.globl vector122
vector122:
  pushl $0
  10133a:	6a 00                	push   $0x0
  pushl $122
  10133c:	6a 7a                	push   $0x7a
  jmp alltraps
  10133e:	e9 73 fa ff ff       	jmp    100db6 <alltraps>

00101343 <vector123>:
.globl vector123
vector123:
  pushl $0
  101343:	6a 00                	push   $0x0
  pushl $123
  101345:	6a 7b                	push   $0x7b
  jmp alltraps
  101347:	e9 6a fa ff ff       	jmp    100db6 <alltraps>

0010134c <vector124>:
.globl vector124
vector124:
  pushl $0
  10134c:	6a 00                	push   $0x0
  pushl $124
  10134e:	6a 7c                	push   $0x7c
  jmp alltraps
  101350:	e9 61 fa ff ff       	jmp    100db6 <alltraps>

00101355 <vector125>:
.globl vector125
vector125:
  pushl $0
  101355:	6a 00                	push   $0x0
  pushl $125
  101357:	6a 7d                	push   $0x7d
  jmp alltraps
  101359:	e9 58 fa ff ff       	jmp    100db6 <alltraps>

0010135e <vector126>:
.globl vector126
vector126:
  pushl $0
  10135e:	6a 00                	push   $0x0
  pushl $126
  101360:	6a 7e                	push   $0x7e
  jmp alltraps
  101362:	e9 4f fa ff ff       	jmp    100db6 <alltraps>

00101367 <vector127>:
.globl vector127
vector127:
  pushl $0
  101367:	6a 00                	push   $0x0
  pushl $127
  101369:	6a 7f                	push   $0x7f
  jmp alltraps
  10136b:	e9 46 fa ff ff       	jmp    100db6 <alltraps>

00101370 <vector128>:
.globl vector128
vector128:
  pushl $0
  101370:	6a 00                	push   $0x0
  pushl $128
  101372:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  101377:	e9 3a fa ff ff       	jmp    100db6 <alltraps>

0010137c <vector129>:
.globl vector129
vector129:
  pushl $0
  10137c:	6a 00                	push   $0x0
  pushl $129
  10137e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  101383:	e9 2e fa ff ff       	jmp    100db6 <alltraps>

00101388 <vector130>:
.globl vector130
vector130:
  pushl $0
  101388:	6a 00                	push   $0x0
  pushl $130
  10138a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  10138f:	e9 22 fa ff ff       	jmp    100db6 <alltraps>

00101394 <vector131>:
.globl vector131
vector131:
  pushl $0
  101394:	6a 00                	push   $0x0
  pushl $131
  101396:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  10139b:	e9 16 fa ff ff       	jmp    100db6 <alltraps>

001013a0 <vector132>:
.globl vector132
vector132:
  pushl $0
  1013a0:	6a 00                	push   $0x0
  pushl $132
  1013a2:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  1013a7:	e9 0a fa ff ff       	jmp    100db6 <alltraps>

001013ac <vector133>:
.globl vector133
vector133:
  pushl $0
  1013ac:	6a 00                	push   $0x0
  pushl $133
  1013ae:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  1013b3:	e9 fe f9 ff ff       	jmp    100db6 <alltraps>

001013b8 <vector134>:
.globl vector134
vector134:
  pushl $0
  1013b8:	6a 00                	push   $0x0
  pushl $134
  1013ba:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  1013bf:	e9 f2 f9 ff ff       	jmp    100db6 <alltraps>

001013c4 <vector135>:
.globl vector135
vector135:
  pushl $0
  1013c4:	6a 00                	push   $0x0
  pushl $135
  1013c6:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  1013cb:	e9 e6 f9 ff ff       	jmp    100db6 <alltraps>

001013d0 <vector136>:
.globl vector136
vector136:
  pushl $0
  1013d0:	6a 00                	push   $0x0
  pushl $136
  1013d2:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  1013d7:	e9 da f9 ff ff       	jmp    100db6 <alltraps>

001013dc <vector137>:
.globl vector137
vector137:
  pushl $0
  1013dc:	6a 00                	push   $0x0
  pushl $137
  1013de:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  1013e3:	e9 ce f9 ff ff       	jmp    100db6 <alltraps>

001013e8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1013e8:	6a 00                	push   $0x0
  pushl $138
  1013ea:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  1013ef:	e9 c2 f9 ff ff       	jmp    100db6 <alltraps>

001013f4 <vector139>:
.globl vector139
vector139:
  pushl $0
  1013f4:	6a 00                	push   $0x0
  pushl $139
  1013f6:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  1013fb:	e9 b6 f9 ff ff       	jmp    100db6 <alltraps>

00101400 <vector140>:
.globl vector140
vector140:
  pushl $0
  101400:	6a 00                	push   $0x0
  pushl $140
  101402:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  101407:	e9 aa f9 ff ff       	jmp    100db6 <alltraps>

0010140c <vector141>:
.globl vector141
vector141:
  pushl $0
  10140c:	6a 00                	push   $0x0
  pushl $141
  10140e:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  101413:	e9 9e f9 ff ff       	jmp    100db6 <alltraps>

00101418 <vector142>:
.globl vector142
vector142:
  pushl $0
  101418:	6a 00                	push   $0x0
  pushl $142
  10141a:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  10141f:	e9 92 f9 ff ff       	jmp    100db6 <alltraps>

00101424 <vector143>:
.globl vector143
vector143:
  pushl $0
  101424:	6a 00                	push   $0x0
  pushl $143
  101426:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  10142b:	e9 86 f9 ff ff       	jmp    100db6 <alltraps>

00101430 <vector144>:
.globl vector144
vector144:
  pushl $0
  101430:	6a 00                	push   $0x0
  pushl $144
  101432:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  101437:	e9 7a f9 ff ff       	jmp    100db6 <alltraps>

0010143c <vector145>:
.globl vector145
vector145:
  pushl $0
  10143c:	6a 00                	push   $0x0
  pushl $145
  10143e:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  101443:	e9 6e f9 ff ff       	jmp    100db6 <alltraps>

00101448 <vector146>:
.globl vector146
vector146:
  pushl $0
  101448:	6a 00                	push   $0x0
  pushl $146
  10144a:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  10144f:	e9 62 f9 ff ff       	jmp    100db6 <alltraps>

00101454 <vector147>:
.globl vector147
vector147:
  pushl $0
  101454:	6a 00                	push   $0x0
  pushl $147
  101456:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  10145b:	e9 56 f9 ff ff       	jmp    100db6 <alltraps>

00101460 <vector148>:
.globl vector148
vector148:
  pushl $0
  101460:	6a 00                	push   $0x0
  pushl $148
  101462:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  101467:	e9 4a f9 ff ff       	jmp    100db6 <alltraps>

0010146c <vector149>:
.globl vector149
vector149:
  pushl $0
  10146c:	6a 00                	push   $0x0
  pushl $149
  10146e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  101473:	e9 3e f9 ff ff       	jmp    100db6 <alltraps>

00101478 <vector150>:
.globl vector150
vector150:
  pushl $0
  101478:	6a 00                	push   $0x0
  pushl $150
  10147a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  10147f:	e9 32 f9 ff ff       	jmp    100db6 <alltraps>

00101484 <vector151>:
.globl vector151
vector151:
  pushl $0
  101484:	6a 00                	push   $0x0
  pushl $151
  101486:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  10148b:	e9 26 f9 ff ff       	jmp    100db6 <alltraps>

00101490 <vector152>:
.globl vector152
vector152:
  pushl $0
  101490:	6a 00                	push   $0x0
  pushl $152
  101492:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  101497:	e9 1a f9 ff ff       	jmp    100db6 <alltraps>

0010149c <vector153>:
.globl vector153
vector153:
  pushl $0
  10149c:	6a 00                	push   $0x0
  pushl $153
  10149e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  1014a3:	e9 0e f9 ff ff       	jmp    100db6 <alltraps>

001014a8 <vector154>:
.globl vector154
vector154:
  pushl $0
  1014a8:	6a 00                	push   $0x0
  pushl $154
  1014aa:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  1014af:	e9 02 f9 ff ff       	jmp    100db6 <alltraps>

001014b4 <vector155>:
.globl vector155
vector155:
  pushl $0
  1014b4:	6a 00                	push   $0x0
  pushl $155
  1014b6:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  1014bb:	e9 f6 f8 ff ff       	jmp    100db6 <alltraps>

001014c0 <vector156>:
.globl vector156
vector156:
  pushl $0
  1014c0:	6a 00                	push   $0x0
  pushl $156
  1014c2:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  1014c7:	e9 ea f8 ff ff       	jmp    100db6 <alltraps>

001014cc <vector157>:
.globl vector157
vector157:
  pushl $0
  1014cc:	6a 00                	push   $0x0
  pushl $157
  1014ce:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  1014d3:	e9 de f8 ff ff       	jmp    100db6 <alltraps>

001014d8 <vector158>:
.globl vector158
vector158:
  pushl $0
  1014d8:	6a 00                	push   $0x0
  pushl $158
  1014da:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  1014df:	e9 d2 f8 ff ff       	jmp    100db6 <alltraps>

001014e4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1014e4:	6a 00                	push   $0x0
  pushl $159
  1014e6:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  1014eb:	e9 c6 f8 ff ff       	jmp    100db6 <alltraps>

001014f0 <vector160>:
.globl vector160
vector160:
  pushl $0
  1014f0:	6a 00                	push   $0x0
  pushl $160
  1014f2:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  1014f7:	e9 ba f8 ff ff       	jmp    100db6 <alltraps>

001014fc <vector161>:
.globl vector161
vector161:
  pushl $0
  1014fc:	6a 00                	push   $0x0
  pushl $161
  1014fe:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  101503:	e9 ae f8 ff ff       	jmp    100db6 <alltraps>

00101508 <vector162>:
.globl vector162
vector162:
  pushl $0
  101508:	6a 00                	push   $0x0
  pushl $162
  10150a:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  10150f:	e9 a2 f8 ff ff       	jmp    100db6 <alltraps>

00101514 <vector163>:
.globl vector163
vector163:
  pushl $0
  101514:	6a 00                	push   $0x0
  pushl $163
  101516:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  10151b:	e9 96 f8 ff ff       	jmp    100db6 <alltraps>

00101520 <vector164>:
.globl vector164
vector164:
  pushl $0
  101520:	6a 00                	push   $0x0
  pushl $164
  101522:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  101527:	e9 8a f8 ff ff       	jmp    100db6 <alltraps>

0010152c <vector165>:
.globl vector165
vector165:
  pushl $0
  10152c:	6a 00                	push   $0x0
  pushl $165
  10152e:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  101533:	e9 7e f8 ff ff       	jmp    100db6 <alltraps>

00101538 <vector166>:
.globl vector166
vector166:
  pushl $0
  101538:	6a 00                	push   $0x0
  pushl $166
  10153a:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  10153f:	e9 72 f8 ff ff       	jmp    100db6 <alltraps>

00101544 <vector167>:
.globl vector167
vector167:
  pushl $0
  101544:	6a 00                	push   $0x0
  pushl $167
  101546:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  10154b:	e9 66 f8 ff ff       	jmp    100db6 <alltraps>

00101550 <vector168>:
.globl vector168
vector168:
  pushl $0
  101550:	6a 00                	push   $0x0
  pushl $168
  101552:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  101557:	e9 5a f8 ff ff       	jmp    100db6 <alltraps>

0010155c <vector169>:
.globl vector169
vector169:
  pushl $0
  10155c:	6a 00                	push   $0x0
  pushl $169
  10155e:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  101563:	e9 4e f8 ff ff       	jmp    100db6 <alltraps>

00101568 <vector170>:
.globl vector170
vector170:
  pushl $0
  101568:	6a 00                	push   $0x0
  pushl $170
  10156a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  10156f:	e9 42 f8 ff ff       	jmp    100db6 <alltraps>

00101574 <vector171>:
.globl vector171
vector171:
  pushl $0
  101574:	6a 00                	push   $0x0
  pushl $171
  101576:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  10157b:	e9 36 f8 ff ff       	jmp    100db6 <alltraps>

00101580 <vector172>:
.globl vector172
vector172:
  pushl $0
  101580:	6a 00                	push   $0x0
  pushl $172
  101582:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  101587:	e9 2a f8 ff ff       	jmp    100db6 <alltraps>

0010158c <vector173>:
.globl vector173
vector173:
  pushl $0
  10158c:	6a 00                	push   $0x0
  pushl $173
  10158e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  101593:	e9 1e f8 ff ff       	jmp    100db6 <alltraps>

00101598 <vector174>:
.globl vector174
vector174:
  pushl $0
  101598:	6a 00                	push   $0x0
  pushl $174
  10159a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  10159f:	e9 12 f8 ff ff       	jmp    100db6 <alltraps>

001015a4 <vector175>:
.globl vector175
vector175:
  pushl $0
  1015a4:	6a 00                	push   $0x0
  pushl $175
  1015a6:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  1015ab:	e9 06 f8 ff ff       	jmp    100db6 <alltraps>

001015b0 <vector176>:
.globl vector176
vector176:
  pushl $0
  1015b0:	6a 00                	push   $0x0
  pushl $176
  1015b2:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  1015b7:	e9 fa f7 ff ff       	jmp    100db6 <alltraps>

001015bc <vector177>:
.globl vector177
vector177:
  pushl $0
  1015bc:	6a 00                	push   $0x0
  pushl $177
  1015be:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  1015c3:	e9 ee f7 ff ff       	jmp    100db6 <alltraps>

001015c8 <vector178>:
.globl vector178
vector178:
  pushl $0
  1015c8:	6a 00                	push   $0x0
  pushl $178
  1015ca:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  1015cf:	e9 e2 f7 ff ff       	jmp    100db6 <alltraps>

001015d4 <vector179>:
.globl vector179
vector179:
  pushl $0
  1015d4:	6a 00                	push   $0x0
  pushl $179
  1015d6:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  1015db:	e9 d6 f7 ff ff       	jmp    100db6 <alltraps>

001015e0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1015e0:	6a 00                	push   $0x0
  pushl $180
  1015e2:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  1015e7:	e9 ca f7 ff ff       	jmp    100db6 <alltraps>

001015ec <vector181>:
.globl vector181
vector181:
  pushl $0
  1015ec:	6a 00                	push   $0x0
  pushl $181
  1015ee:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  1015f3:	e9 be f7 ff ff       	jmp    100db6 <alltraps>

001015f8 <vector182>:
.globl vector182
vector182:
  pushl $0
  1015f8:	6a 00                	push   $0x0
  pushl $182
  1015fa:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  1015ff:	e9 b2 f7 ff ff       	jmp    100db6 <alltraps>

00101604 <vector183>:
.globl vector183
vector183:
  pushl $0
  101604:	6a 00                	push   $0x0
  pushl $183
  101606:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  10160b:	e9 a6 f7 ff ff       	jmp    100db6 <alltraps>

00101610 <vector184>:
.globl vector184
vector184:
  pushl $0
  101610:	6a 00                	push   $0x0
  pushl $184
  101612:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  101617:	e9 9a f7 ff ff       	jmp    100db6 <alltraps>

0010161c <vector185>:
.globl vector185
vector185:
  pushl $0
  10161c:	6a 00                	push   $0x0
  pushl $185
  10161e:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  101623:	e9 8e f7 ff ff       	jmp    100db6 <alltraps>

00101628 <vector186>:
.globl vector186
vector186:
  pushl $0
  101628:	6a 00                	push   $0x0
  pushl $186
  10162a:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  10162f:	e9 82 f7 ff ff       	jmp    100db6 <alltraps>

00101634 <vector187>:
.globl vector187
vector187:
  pushl $0
  101634:	6a 00                	push   $0x0
  pushl $187
  101636:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  10163b:	e9 76 f7 ff ff       	jmp    100db6 <alltraps>

00101640 <vector188>:
.globl vector188
vector188:
  pushl $0
  101640:	6a 00                	push   $0x0
  pushl $188
  101642:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  101647:	e9 6a f7 ff ff       	jmp    100db6 <alltraps>

0010164c <vector189>:
.globl vector189
vector189:
  pushl $0
  10164c:	6a 00                	push   $0x0
  pushl $189
  10164e:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  101653:	e9 5e f7 ff ff       	jmp    100db6 <alltraps>

00101658 <vector190>:
.globl vector190
vector190:
  pushl $0
  101658:	6a 00                	push   $0x0
  pushl $190
  10165a:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  10165f:	e9 52 f7 ff ff       	jmp    100db6 <alltraps>

00101664 <vector191>:
.globl vector191
vector191:
  pushl $0
  101664:	6a 00                	push   $0x0
  pushl $191
  101666:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  10166b:	e9 46 f7 ff ff       	jmp    100db6 <alltraps>

00101670 <vector192>:
.globl vector192
vector192:
  pushl $0
  101670:	6a 00                	push   $0x0
  pushl $192
  101672:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  101677:	e9 3a f7 ff ff       	jmp    100db6 <alltraps>

0010167c <vector193>:
.globl vector193
vector193:
  pushl $0
  10167c:	6a 00                	push   $0x0
  pushl $193
  10167e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  101683:	e9 2e f7 ff ff       	jmp    100db6 <alltraps>

00101688 <vector194>:
.globl vector194
vector194:
  pushl $0
  101688:	6a 00                	push   $0x0
  pushl $194
  10168a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  10168f:	e9 22 f7 ff ff       	jmp    100db6 <alltraps>

00101694 <vector195>:
.globl vector195
vector195:
  pushl $0
  101694:	6a 00                	push   $0x0
  pushl $195
  101696:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  10169b:	e9 16 f7 ff ff       	jmp    100db6 <alltraps>

001016a0 <vector196>:
.globl vector196
vector196:
  pushl $0
  1016a0:	6a 00                	push   $0x0
  pushl $196
  1016a2:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  1016a7:	e9 0a f7 ff ff       	jmp    100db6 <alltraps>

001016ac <vector197>:
.globl vector197
vector197:
  pushl $0
  1016ac:	6a 00                	push   $0x0
  pushl $197
  1016ae:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  1016b3:	e9 fe f6 ff ff       	jmp    100db6 <alltraps>

001016b8 <vector198>:
.globl vector198
vector198:
  pushl $0
  1016b8:	6a 00                	push   $0x0
  pushl $198
  1016ba:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  1016bf:	e9 f2 f6 ff ff       	jmp    100db6 <alltraps>

001016c4 <vector199>:
.globl vector199
vector199:
  pushl $0
  1016c4:	6a 00                	push   $0x0
  pushl $199
  1016c6:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  1016cb:	e9 e6 f6 ff ff       	jmp    100db6 <alltraps>

001016d0 <vector200>:
.globl vector200
vector200:
  pushl $0
  1016d0:	6a 00                	push   $0x0
  pushl $200
  1016d2:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  1016d7:	e9 da f6 ff ff       	jmp    100db6 <alltraps>

001016dc <vector201>:
.globl vector201
vector201:
  pushl $0
  1016dc:	6a 00                	push   $0x0
  pushl $201
  1016de:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  1016e3:	e9 ce f6 ff ff       	jmp    100db6 <alltraps>

001016e8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1016e8:	6a 00                	push   $0x0
  pushl $202
  1016ea:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  1016ef:	e9 c2 f6 ff ff       	jmp    100db6 <alltraps>

001016f4 <vector203>:
.globl vector203
vector203:
  pushl $0
  1016f4:	6a 00                	push   $0x0
  pushl $203
  1016f6:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  1016fb:	e9 b6 f6 ff ff       	jmp    100db6 <alltraps>

00101700 <vector204>:
.globl vector204
vector204:
  pushl $0
  101700:	6a 00                	push   $0x0
  pushl $204
  101702:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  101707:	e9 aa f6 ff ff       	jmp    100db6 <alltraps>

0010170c <vector205>:
.globl vector205
vector205:
  pushl $0
  10170c:	6a 00                	push   $0x0
  pushl $205
  10170e:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  101713:	e9 9e f6 ff ff       	jmp    100db6 <alltraps>

00101718 <vector206>:
.globl vector206
vector206:
  pushl $0
  101718:	6a 00                	push   $0x0
  pushl $206
  10171a:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  10171f:	e9 92 f6 ff ff       	jmp    100db6 <alltraps>

00101724 <vector207>:
.globl vector207
vector207:
  pushl $0
  101724:	6a 00                	push   $0x0
  pushl $207
  101726:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  10172b:	e9 86 f6 ff ff       	jmp    100db6 <alltraps>

00101730 <vector208>:
.globl vector208
vector208:
  pushl $0
  101730:	6a 00                	push   $0x0
  pushl $208
  101732:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  101737:	e9 7a f6 ff ff       	jmp    100db6 <alltraps>

0010173c <vector209>:
.globl vector209
vector209:
  pushl $0
  10173c:	6a 00                	push   $0x0
  pushl $209
  10173e:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  101743:	e9 6e f6 ff ff       	jmp    100db6 <alltraps>

00101748 <vector210>:
.globl vector210
vector210:
  pushl $0
  101748:	6a 00                	push   $0x0
  pushl $210
  10174a:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  10174f:	e9 62 f6 ff ff       	jmp    100db6 <alltraps>

00101754 <vector211>:
.globl vector211
vector211:
  pushl $0
  101754:	6a 00                	push   $0x0
  pushl $211
  101756:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  10175b:	e9 56 f6 ff ff       	jmp    100db6 <alltraps>

00101760 <vector212>:
.globl vector212
vector212:
  pushl $0
  101760:	6a 00                	push   $0x0
  pushl $212
  101762:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  101767:	e9 4a f6 ff ff       	jmp    100db6 <alltraps>

0010176c <vector213>:
.globl vector213
vector213:
  pushl $0
  10176c:	6a 00                	push   $0x0
  pushl $213
  10176e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  101773:	e9 3e f6 ff ff       	jmp    100db6 <alltraps>

00101778 <vector214>:
.globl vector214
vector214:
  pushl $0
  101778:	6a 00                	push   $0x0
  pushl $214
  10177a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  10177f:	e9 32 f6 ff ff       	jmp    100db6 <alltraps>

00101784 <vector215>:
.globl vector215
vector215:
  pushl $0
  101784:	6a 00                	push   $0x0
  pushl $215
  101786:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  10178b:	e9 26 f6 ff ff       	jmp    100db6 <alltraps>

00101790 <vector216>:
.globl vector216
vector216:
  pushl $0
  101790:	6a 00                	push   $0x0
  pushl $216
  101792:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  101797:	e9 1a f6 ff ff       	jmp    100db6 <alltraps>

0010179c <vector217>:
.globl vector217
vector217:
  pushl $0
  10179c:	6a 00                	push   $0x0
  pushl $217
  10179e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  1017a3:	e9 0e f6 ff ff       	jmp    100db6 <alltraps>

001017a8 <vector218>:
.globl vector218
vector218:
  pushl $0
  1017a8:	6a 00                	push   $0x0
  pushl $218
  1017aa:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  1017af:	e9 02 f6 ff ff       	jmp    100db6 <alltraps>

001017b4 <vector219>:
.globl vector219
vector219:
  pushl $0
  1017b4:	6a 00                	push   $0x0
  pushl $219
  1017b6:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  1017bb:	e9 f6 f5 ff ff       	jmp    100db6 <alltraps>

001017c0 <vector220>:
.globl vector220
vector220:
  pushl $0
  1017c0:	6a 00                	push   $0x0
  pushl $220
  1017c2:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  1017c7:	e9 ea f5 ff ff       	jmp    100db6 <alltraps>

001017cc <vector221>:
.globl vector221
vector221:
  pushl $0
  1017cc:	6a 00                	push   $0x0
  pushl $221
  1017ce:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  1017d3:	e9 de f5 ff ff       	jmp    100db6 <alltraps>

001017d8 <vector222>:
.globl vector222
vector222:
  pushl $0
  1017d8:	6a 00                	push   $0x0
  pushl $222
  1017da:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  1017df:	e9 d2 f5 ff ff       	jmp    100db6 <alltraps>

001017e4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1017e4:	6a 00                	push   $0x0
  pushl $223
  1017e6:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  1017eb:	e9 c6 f5 ff ff       	jmp    100db6 <alltraps>

001017f0 <vector224>:
.globl vector224
vector224:
  pushl $0
  1017f0:	6a 00                	push   $0x0
  pushl $224
  1017f2:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  1017f7:	e9 ba f5 ff ff       	jmp    100db6 <alltraps>

001017fc <vector225>:
.globl vector225
vector225:
  pushl $0
  1017fc:	6a 00                	push   $0x0
  pushl $225
  1017fe:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  101803:	e9 ae f5 ff ff       	jmp    100db6 <alltraps>

00101808 <vector226>:
.globl vector226
vector226:
  pushl $0
  101808:	6a 00                	push   $0x0
  pushl $226
  10180a:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  10180f:	e9 a2 f5 ff ff       	jmp    100db6 <alltraps>

00101814 <vector227>:
.globl vector227
vector227:
  pushl $0
  101814:	6a 00                	push   $0x0
  pushl $227
  101816:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  10181b:	e9 96 f5 ff ff       	jmp    100db6 <alltraps>

00101820 <vector228>:
.globl vector228
vector228:
  pushl $0
  101820:	6a 00                	push   $0x0
  pushl $228
  101822:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  101827:	e9 8a f5 ff ff       	jmp    100db6 <alltraps>

0010182c <vector229>:
.globl vector229
vector229:
  pushl $0
  10182c:	6a 00                	push   $0x0
  pushl $229
  10182e:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  101833:	e9 7e f5 ff ff       	jmp    100db6 <alltraps>

00101838 <vector230>:
.globl vector230
vector230:
  pushl $0
  101838:	6a 00                	push   $0x0
  pushl $230
  10183a:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  10183f:	e9 72 f5 ff ff       	jmp    100db6 <alltraps>

00101844 <vector231>:
.globl vector231
vector231:
  pushl $0
  101844:	6a 00                	push   $0x0
  pushl $231
  101846:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  10184b:	e9 66 f5 ff ff       	jmp    100db6 <alltraps>

00101850 <vector232>:
.globl vector232
vector232:
  pushl $0
  101850:	6a 00                	push   $0x0
  pushl $232
  101852:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  101857:	e9 5a f5 ff ff       	jmp    100db6 <alltraps>

0010185c <vector233>:
.globl vector233
vector233:
  pushl $0
  10185c:	6a 00                	push   $0x0
  pushl $233
  10185e:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  101863:	e9 4e f5 ff ff       	jmp    100db6 <alltraps>

00101868 <vector234>:
.globl vector234
vector234:
  pushl $0
  101868:	6a 00                	push   $0x0
  pushl $234
  10186a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  10186f:	e9 42 f5 ff ff       	jmp    100db6 <alltraps>

00101874 <vector235>:
.globl vector235
vector235:
  pushl $0
  101874:	6a 00                	push   $0x0
  pushl $235
  101876:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  10187b:	e9 36 f5 ff ff       	jmp    100db6 <alltraps>

00101880 <vector236>:
.globl vector236
vector236:
  pushl $0
  101880:	6a 00                	push   $0x0
  pushl $236
  101882:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  101887:	e9 2a f5 ff ff       	jmp    100db6 <alltraps>

0010188c <vector237>:
.globl vector237
vector237:
  pushl $0
  10188c:	6a 00                	push   $0x0
  pushl $237
  10188e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  101893:	e9 1e f5 ff ff       	jmp    100db6 <alltraps>

00101898 <vector238>:
.globl vector238
vector238:
  pushl $0
  101898:	6a 00                	push   $0x0
  pushl $238
  10189a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  10189f:	e9 12 f5 ff ff       	jmp    100db6 <alltraps>

001018a4 <vector239>:
.globl vector239
vector239:
  pushl $0
  1018a4:	6a 00                	push   $0x0
  pushl $239
  1018a6:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  1018ab:	e9 06 f5 ff ff       	jmp    100db6 <alltraps>

001018b0 <vector240>:
.globl vector240
vector240:
  pushl $0
  1018b0:	6a 00                	push   $0x0
  pushl $240
  1018b2:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  1018b7:	e9 fa f4 ff ff       	jmp    100db6 <alltraps>

001018bc <vector241>:
.globl vector241
vector241:
  pushl $0
  1018bc:	6a 00                	push   $0x0
  pushl $241
  1018be:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  1018c3:	e9 ee f4 ff ff       	jmp    100db6 <alltraps>

001018c8 <vector242>:
.globl vector242
vector242:
  pushl $0
  1018c8:	6a 00                	push   $0x0
  pushl $242
  1018ca:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  1018cf:	e9 e2 f4 ff ff       	jmp    100db6 <alltraps>

001018d4 <vector243>:
.globl vector243
vector243:
  pushl $0
  1018d4:	6a 00                	push   $0x0
  pushl $243
  1018d6:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  1018db:	e9 d6 f4 ff ff       	jmp    100db6 <alltraps>

001018e0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1018e0:	6a 00                	push   $0x0
  pushl $244
  1018e2:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  1018e7:	e9 ca f4 ff ff       	jmp    100db6 <alltraps>

001018ec <vector245>:
.globl vector245
vector245:
  pushl $0
  1018ec:	6a 00                	push   $0x0
  pushl $245
  1018ee:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  1018f3:	e9 be f4 ff ff       	jmp    100db6 <alltraps>

001018f8 <vector246>:
.globl vector246
vector246:
  pushl $0
  1018f8:	6a 00                	push   $0x0
  pushl $246
  1018fa:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  1018ff:	e9 b2 f4 ff ff       	jmp    100db6 <alltraps>

00101904 <vector247>:
.globl vector247
vector247:
  pushl $0
  101904:	6a 00                	push   $0x0
  pushl $247
  101906:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  10190b:	e9 a6 f4 ff ff       	jmp    100db6 <alltraps>

00101910 <vector248>:
.globl vector248
vector248:
  pushl $0
  101910:	6a 00                	push   $0x0
  pushl $248
  101912:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  101917:	e9 9a f4 ff ff       	jmp    100db6 <alltraps>

0010191c <vector249>:
.globl vector249
vector249:
  pushl $0
  10191c:	6a 00                	push   $0x0
  pushl $249
  10191e:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  101923:	e9 8e f4 ff ff       	jmp    100db6 <alltraps>

00101928 <vector250>:
.globl vector250
vector250:
  pushl $0
  101928:	6a 00                	push   $0x0
  pushl $250
  10192a:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  10192f:	e9 82 f4 ff ff       	jmp    100db6 <alltraps>

00101934 <vector251>:
.globl vector251
vector251:
  pushl $0
  101934:	6a 00                	push   $0x0
  pushl $251
  101936:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  10193b:	e9 76 f4 ff ff       	jmp    100db6 <alltraps>

00101940 <vector252>:
.globl vector252
vector252:
  pushl $0
  101940:	6a 00                	push   $0x0
  pushl $252
  101942:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  101947:	e9 6a f4 ff ff       	jmp    100db6 <alltraps>

0010194c <vector253>:
.globl vector253
vector253:
  pushl $0
  10194c:	6a 00                	push   $0x0
  pushl $253
  10194e:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  101953:	e9 5e f4 ff ff       	jmp    100db6 <alltraps>

00101958 <vector254>:
.globl vector254
vector254:
  pushl $0
  101958:	6a 00                	push   $0x0
  pushl $254
  10195a:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  10195f:	e9 52 f4 ff ff       	jmp    100db6 <alltraps>

00101964 <vector255>:
.globl vector255
vector255:
  pushl $0
  101964:	6a 00                	push   $0x0
  pushl $255
  101966:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  10196b:	e9 46 f4 ff ff       	jmp    100db6 <alltraps>

00101970 <mousewait_send>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101970:	ba 64 00 00 00       	mov    $0x64,%edx
  101975:	8d 76 00             	lea    0x0(%esi),%esi
  101978:	ec                   	in     (%dx),%al

// Wait until the mouse controller is ready for us to send a packet
void mousewait_send(void) 
{
    //wait until bit 1 of register is clear
    while((inb(0x64) & 0x02) != 0x00){
  101979:	a8 02                	test   $0x2,%al
  10197b:	75 fb                	jne    101978 <mousewait_send+0x8>
        ;
    }
    return;
}
  10197d:	c3                   	ret
  10197e:	66 90                	xchg   %ax,%ax

00101980 <mousewait_recv>:
  101980:	ba 64 00 00 00       	mov    $0x64,%edx
  101985:	8d 76 00             	lea    0x0(%esi),%esi
  101988:	ec                   	in     (%dx),%al

// Wait until the mouse controller has data for us to receive
void 
mousewait_recv(void) 
{
    while((inb(0x64) & 0x01) == 0x00){
  101989:	a8 01                	test   $0x1,%al
  10198b:	74 fb                	je     101988 <mousewait_recv+0x8>
        ;
    }
    return;
}
  10198d:	c3                   	ret
  10198e:	66 90                	xchg   %ax,%ax

00101990 <mousecmd>:

void 
mousecmd(uchar cmd) 
{
  101990:	55                   	push   %ebp
  101991:	ba 64 00 00 00       	mov    $0x64,%edx
  101996:	89 e5                	mov    %esp,%ebp
  101998:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
  10199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1019a0:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x02) != 0x00){
  1019a1:	a8 02                	test   $0x2,%al
  1019a3:	75 fb                	jne    1019a0 <mousecmd+0x10>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1019a5:	b8 d4 ff ff ff       	mov    $0xffffffd4,%eax
  1019aa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1019ab:	ba 64 00 00 00       	mov    $0x64,%edx
  1019b0:	ec                   	in     (%dx),%al
  1019b1:	a8 02                	test   $0x2,%al
  1019b3:	75 fb                	jne    1019b0 <mousecmd+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1019b5:	ba 60 00 00 00       	mov    $0x60,%edx
  1019ba:	89 c8                	mov    %ecx,%eax
  1019bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1019bd:	ba 64 00 00 00       	mov    $0x64,%edx
  1019c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1019c8:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x01) == 0x00){
  1019c9:	a8 01                	test   $0x1,%al
  1019cb:	74 fb                	je     1019c8 <mousecmd+0x38>
  1019cd:	ba 60 00 00 00       	mov    $0x60,%edx
  1019d2:	ec                   	in     (%dx),%al
    mousewait_send();
    outb(0x60, cmd);
    mousewait_recv();
    inb(0x60);
    return;
}
  1019d3:	5d                   	pop    %ebp
  1019d4:	c3                   	ret
  1019d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001019e0 <mouseinit>:

// Send a one-byte command to the mouse controller, and wait for it
//
void
mouseinit(void)
{
  1019e0:	55                   	push   %ebp
  1019e1:	ba 64 00 00 00       	mov    $0x64,%edx
  1019e6:	89 e5                	mov    %esp,%ebp
  1019e8:	83 ec 08             	sub    $0x8,%esp
  1019eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1019ef:	90                   	nop
  1019f0:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x02) != 0x00){
  1019f1:	a8 02                	test   $0x2,%al
  1019f3:	75 fb                	jne    1019f0 <mouseinit+0x10>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1019f5:	b8 a8 ff ff ff       	mov    $0xffffffa8,%eax
  1019fa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1019fb:	ba 64 00 00 00       	mov    $0x64,%edx
  101a00:	ec                   	in     (%dx),%al
  101a01:	a8 02                	test   $0x2,%al
  101a03:	75 fb                	jne    101a00 <mouseinit+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a05:	b8 20 00 00 00       	mov    $0x20,%eax
  101a0a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a0b:	ba 64 00 00 00       	mov    $0x64,%edx
  101a10:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x01) == 0x00){
  101a11:	a8 01                	test   $0x1,%al
  101a13:	74 fb                	je     101a10 <mouseinit+0x30>
  101a15:	ba 60 00 00 00       	mov    $0x60,%edx
  101a1a:	ec                   	in     (%dx),%al
    // interupts
    mousewait_send();
    outb(0x64, 0x20);
    mousewait_recv();
    uchar status = inb(0x60);
    uchar newstatus = status | 0x02;
  101a1b:	83 c8 02             	or     $0x2,%eax
  101a1e:	ba 64 00 00 00       	mov    $0x64,%edx
  101a23:	89 c1                	mov    %eax,%ecx
    while((inb(0x64) & 0x02) != 0x00){
  101a25:	8d 76 00             	lea    0x0(%esi),%esi
  101a28:	ec                   	in     (%dx),%al
  101a29:	a8 02                	test   $0x2,%al
  101a2b:	75 fb                	jne    101a28 <mouseinit+0x48>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a2d:	b8 60 00 00 00       	mov    $0x60,%eax
  101a32:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a33:	ba 64 00 00 00       	mov    $0x64,%edx
  101a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101a3f:	90                   	nop
  101a40:	ec                   	in     (%dx),%al
  101a41:	a8 02                	test   $0x2,%al
  101a43:	75 fb                	jne    101a40 <mouseinit+0x60>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a45:	ba 60 00 00 00       	mov    $0x60,%edx
  101a4a:	89 c8                	mov    %ecx,%eax
  101a4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a4d:	ba 64 00 00 00       	mov    $0x64,%edx
  101a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101a58:	ec                   	in     (%dx),%al
  101a59:	a8 02                	test   $0x2,%al
  101a5b:	75 fb                	jne    101a58 <mouseinit+0x78>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a5d:	b8 d4 ff ff ff       	mov    $0xffffffd4,%eax
  101a62:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a63:	ba 64 00 00 00       	mov    $0x64,%edx
  101a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101a6f:	90                   	nop
  101a70:	ec                   	in     (%dx),%al
  101a71:	a8 02                	test   $0x2,%al
  101a73:	75 fb                	jne    101a70 <mouseinit+0x90>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a75:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  101a7a:	ba 60 00 00 00       	mov    $0x60,%edx
  101a7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a80:	ba 64 00 00 00       	mov    $0x64,%edx
  101a85:	8d 76 00             	lea    0x0(%esi),%esi
  101a88:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x01) == 0x00){
  101a89:	a8 01                	test   $0x1,%al
  101a8b:	74 fb                	je     101a88 <mouseinit+0xa8>
  101a8d:	ba 60 00 00 00       	mov    $0x60,%edx
  101a92:	ec                   	in     (%dx),%al
  101a93:	ba 64 00 00 00       	mov    $0x64,%edx
  101a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101a9f:	90                   	nop
  101aa0:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x02) != 0x00){
  101aa1:	a8 02                	test   $0x2,%al
  101aa3:	75 fb                	jne    101aa0 <mouseinit+0xc0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101aa5:	b8 d4 ff ff ff       	mov    $0xffffffd4,%eax
  101aaa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101aab:	ba 64 00 00 00       	mov    $0x64,%edx
  101ab0:	ec                   	in     (%dx),%al
  101ab1:	a8 02                	test   $0x2,%al
  101ab3:	75 fb                	jne    101ab0 <mouseinit+0xd0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101ab5:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  101aba:	ba 60 00 00 00       	mov    $0x60,%edx
  101abf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101ac0:	ba 64 00 00 00       	mov    $0x64,%edx
  101ac5:	8d 76 00             	lea    0x0(%esi),%esi
  101ac8:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x01) == 0x00){
  101ac9:	a8 01                	test   $0x1,%al
  101acb:	74 fb                	je     101ac8 <mouseinit+0xe8>
  101acd:	ba 60 00 00 00       	mov    $0x60,%edx
  101ad2:	ec                   	in     (%dx),%al
    outb(0x64, 0x60);
    mousewait_send();
    outb(0x60, newstatus);
    mousecmd(0xF6);
    mousecmd(0xF4);
    ioapicenable(IRQ_MOUSE, 0);
  101ad3:	83 ec 08             	sub    $0x8,%esp
  101ad6:	6a 00                	push   $0x0
  101ad8:	6a 0c                	push   $0xc
  101ada:	e8 21 ea ff ff       	call   100500 <ioapicenable>
    //ensure line number 71 in lab1.md
    cprintf("Mouse has been initialized\n");
  101adf:	c7 04 24 da 1b 10 00 	movl   $0x101bda,(%esp)
  101ae6:	e8 c5 e5 ff ff       	call   1000b0 <cprintf>
}
  101aeb:	83 c4 10             	add    $0x10,%esp
  101aee:	c9                   	leave
  101aef:	c3                   	ret

00101af0 <mouseintr>:

void
mouseintr(void)
{
  101af0:	55                   	push   %ebp
  101af1:	ba 64 00 00 00       	mov    $0x64,%edx
  101af6:	89 e5                	mov    %esp,%ebp
  101af8:	53                   	push   %ebx
  101af9:	83 ec 04             	sub    $0x4,%esp
  101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101b00:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x01) == 0x00){
  101b01:	a8 01                	test   $0x1,%al
  101b03:	74 fb                	je     101b00 <mouseintr+0x10>
  101b05:	ba 60 00 00 00       	mov    $0x60,%edx
  101b0a:	ec                   	in     (%dx),%al
  101b0b:	89 c3                	mov    %eax,%ebx
    // if((status & 0x01) == 0x01){

        mousewait_recv();
    data = inb(0x60);

    if(((data & 0x01) == 0x01)){
  101b0d:	a8 01                	test   $0x1,%al
  101b0f:	75 2f                	jne    101b40 <mouseintr+0x50>
        cprintf("LEFT\n");
    }
    if((data & 0x02) == 0x02){
  101b11:	f6 c3 02             	test   $0x2,%bl
  101b14:	75 3f                	jne    101b55 <mouseintr+0x65>
        cprintf("RIGHT\n");
    }
    if((data & 0x04) == 0x04){
  101b16:	83 e3 04             	and    $0x4,%ebx
  101b19:	75 4f                	jne    101b6a <mouseintr+0x7a>
  101b1b:	ba 64 00 00 00       	mov    $0x64,%edx
  101b20:	ec                   	in     (%dx),%al
    while((inb(0x64) & 0x01) == 0x00){
  101b21:	a8 01                	test   $0x1,%al
  101b23:	74 fb                	je     101b20 <mouseintr+0x30>
  101b25:	ba 60 00 00 00       	mov    $0x60,%edx
  101b2a:	ec                   	in     (%dx),%al
  101b2b:	ba 64 00 00 00       	mov    $0x64,%edx
  101b30:	ec                   	in     (%dx),%al
  101b31:	a8 01                	test   $0x1,%al
  101b33:	74 fb                	je     101b30 <mouseintr+0x40>
  101b35:	ba 60 00 00 00       	mov    $0x60,%edx
  101b3a:	ec                   	in     (%dx),%al
    mousewait_recv();
    inb(0x60);
    mousewait_recv();
    inb(0x60);
    
  101b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101b3e:	c9                   	leave
  101b3f:	c3                   	ret
        cprintf("LEFT\n");
  101b40:	83 ec 0c             	sub    $0xc,%esp
  101b43:	68 f6 1b 10 00       	push   $0x101bf6
  101b48:	e8 63 e5 ff ff       	call   1000b0 <cprintf>
  101b4d:	83 c4 10             	add    $0x10,%esp
    if((data & 0x02) == 0x02){
  101b50:	f6 c3 02             	test   $0x2,%bl
  101b53:	74 c1                	je     101b16 <mouseintr+0x26>
        cprintf("RIGHT\n");
  101b55:	83 ec 0c             	sub    $0xc,%esp
  101b58:	68 fc 1b 10 00       	push   $0x101bfc
  101b5d:	e8 4e e5 ff ff       	call   1000b0 <cprintf>
  101b62:	83 c4 10             	add    $0x10,%esp
    if((data & 0x04) == 0x04){
  101b65:	83 e3 04             	and    $0x4,%ebx
  101b68:	74 b1                	je     101b1b <mouseintr+0x2b>
        cprintf("MID\n");
  101b6a:	83 ec 0c             	sub    $0xc,%esp
  101b6d:	68 03 1c 10 00       	push   $0x101c03
  101b72:	e8 39 e5 ff ff       	call   1000b0 <cprintf>
  101b77:	83 c4 10             	add    $0x10,%esp
  101b7a:	eb 9f                	jmp    101b1b <mouseintr+0x2b>
