
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 a0 11 40 	lgdtl  0x4011a018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss
	#memlayout.h
    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 a0 11 00       	mov    $0x11a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 48 ba 11 00       	mov    $0x11ba48,%edx
  100035:	b8 36 aa 11 00       	mov    $0x11aa36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 aa 11 00 	movl   $0x11aa36,(%esp)
  100051:	e8 ca 71 00 00       	call   107220 <memset>

    cons_init();                // init the console
  100056:	e8 7c 15 00 00       	call   1015d7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 c0 73 10 00 	movl   $0x1073c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 dc 73 10 00 	movl   $0x1073dc,(%esp)
  100070:	e8 d2 02 00 00       	call   100347 <cprintf>

    print_kerninfo();
  100075:	e8 01 08 00 00       	call   10087b <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 ae 56 00 00       	call   105732 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b7 16 00 00       	call   101740 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 2f 18 00 00       	call   1018bd <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 fa 0c 00 00       	call   100d8d <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 16 16 00 00       	call   1016ae <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 03 0c 00 00       	call   100cbf <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 e1 73 10 00 	movl   $0x1073e1,(%esp)
  10015c:	e8 e6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 ef 73 10 00 	movl   $0x1073ef,(%esp)
  10017c:	e8 c6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 fd 73 10 00 	movl   $0x1073fd,(%esp)
  10019c:	e8 a6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 0b 74 10 00 	movl   $0x10740b,(%esp)
  1001bc:	e8 86 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 19 74 10 00 	movl   $0x107419,(%esp)
  1001dc:	e8 66 01 00 00       	call   100347 <cprintf>
    round ++;
  1001e1:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 aa 11 00       	mov    %eax,0x11aa40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile
  1001f3:	83 ec 08             	sub    $0x8,%esp
  1001f6:	cd 78                	int    $0x78
  1001f8:	89 ec                	mov    %ebp,%esp
				"int %0  \n"
				"movl %%ebp,%%esp  \n"
				:
				:"i"(T_SWITCH_TOU)
		);
}
  1001fa:	5d                   	pop    %ebp
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile
  1001ff:	cd 79                	int    $0x79
  100201:	89 ec                	mov    %ebp,%esp
				"int %0  \n"
				"movl %%ebp,%%esp  \n"
				:
				:"i"(T_SWITCH_TOK)
		);
}
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
  100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020b:	e8 1a ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100210:	c7 04 24 28 74 10 00 	movl   $0x107428,(%esp)
  100217:	e8 2b 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_user();
  10021c:	e8 cf ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100221:	e8 04 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100226:	c7 04 24 48 74 10 00 	movl   $0x107448,(%esp)
  10022d:	e8 15 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_kernel();
  100232:	e8 c5 ff ff ff       	call   1001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100237:	e8 ee fe ff ff       	call   10012a <lab1_print_cur_status>
}
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100248:	74 13                	je     10025d <readline+0x1f>
        cprintf("%s", prompt);
  10024a:	8b 45 08             	mov    0x8(%ebp),%eax
  10024d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100251:	c7 04 24 67 74 10 00 	movl   $0x107467,(%esp)
  100258:	e8 ea 00 00 00       	call   100347 <cprintf>
    }
    int i = 0, c;
  10025d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100264:	e8 66 01 00 00       	call   1003cf <getchar>
  100269:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10026c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100270:	79 07                	jns    100279 <readline+0x3b>
            return NULL;
  100272:	b8 00 00 00 00       	mov    $0x0,%eax
  100277:	eb 79                	jmp    1002f2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100279:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027d:	7e 28                	jle    1002a7 <readline+0x69>
  10027f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100286:	7f 1f                	jg     1002a7 <readline+0x69>
            cputchar(c);
  100288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028b:	89 04 24             	mov    %eax,(%esp)
  10028e:	e8 da 00 00 00       	call   10036d <cputchar>
            buf[i ++] = c;
  100293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100296:	8d 50 01             	lea    0x1(%eax),%edx
  100299:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10029c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10029f:	88 90 60 aa 11 00    	mov    %dl,0x11aa60(%eax)
  1002a5:	eb 46                	jmp    1002ed <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002ab:	75 17                	jne    1002c4 <readline+0x86>
  1002ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b1:	7e 11                	jle    1002c4 <readline+0x86>
            cputchar(c);
  1002b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b6:	89 04 24             	mov    %eax,(%esp)
  1002b9:	e8 af 00 00 00       	call   10036d <cputchar>
            i --;
  1002be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c2:	eb 29                	jmp    1002ed <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c8:	74 06                	je     1002d0 <readline+0x92>
  1002ca:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002ce:	75 1d                	jne    1002ed <readline+0xaf>
            cputchar(c);
  1002d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d3:	89 04 24             	mov    %eax,(%esp)
  1002d6:	e8 92 00 00 00       	call   10036d <cputchar>
            buf[i] = '\0';
  1002db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002de:	05 60 aa 11 00       	add    $0x11aa60,%eax
  1002e3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e6:	b8 60 aa 11 00       	mov    $0x11aa60,%eax
  1002eb:	eb 05                	jmp    1002f2 <readline+0xb4>
        }
    }
  1002ed:	e9 72 ff ff ff       	jmp    100264 <readline+0x26>
}
  1002f2:	c9                   	leave  
  1002f3:	c3                   	ret    

001002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f4:	55                   	push   %ebp
  1002f5:	89 e5                	mov    %esp,%ebp
  1002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fd:	89 04 24             	mov    %eax,(%esp)
  100300:	e8 fe 12 00 00       	call   101603 <cons_putc>
    (*cnt) ++;
  100305:	8b 45 0c             	mov    0xc(%ebp),%eax
  100308:	8b 00                	mov    (%eax),%eax
  10030a:	8d 50 01             	lea    0x1(%eax),%edx
  10030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100310:	89 10                	mov    %edx,(%eax)
}
  100312:	c9                   	leave  
  100313:	c3                   	ret    

00100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100314:	55                   	push   %ebp
  100315:	89 e5                	mov    %esp,%ebp
  100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100321:	8b 45 0c             	mov    0xc(%ebp),%eax
  100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100328:	8b 45 08             	mov    0x8(%ebp),%eax
  10032b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100332:	89 44 24 04          	mov    %eax,0x4(%esp)
  100336:	c7 04 24 f4 02 10 00 	movl   $0x1002f4,(%esp)
  10033d:	e8 f7 66 00 00       	call   106a39 <vprintfmt>
    return cnt;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100347:	55                   	push   %ebp
  100348:	89 e5                	mov    %esp,%ebp
  10034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100350:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100356:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035a:	8b 45 08             	mov    0x8(%ebp),%eax
  10035d:	89 04 24             	mov    %eax,(%esp)
  100360:	e8 af ff ff ff       	call   100314 <vcprintf>
  100365:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036b:	c9                   	leave  
  10036c:	c3                   	ret    

0010036d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036d:	55                   	push   %ebp
  10036e:	89 e5                	mov    %esp,%ebp
  100370:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100373:	8b 45 08             	mov    0x8(%ebp),%eax
  100376:	89 04 24             	mov    %eax,(%esp)
  100379:	e8 85 12 00 00       	call   101603 <cons_putc>
}
  10037e:	c9                   	leave  
  10037f:	c3                   	ret    

00100380 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100380:	55                   	push   %ebp
  100381:	89 e5                	mov    %esp,%ebp
  100383:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038d:	eb 13                	jmp    1003a2 <cputs+0x22>
        cputch(c, &cnt);
  10038f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100393:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100396:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039a:	89 04 24             	mov    %eax,(%esp)
  10039d:	e8 52 ff ff ff       	call   1002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a5:	8d 50 01             	lea    0x1(%eax),%edx
  1003a8:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ab:	0f b6 00             	movzbl (%eax),%eax
  1003ae:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b1:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b5:	75 d8                	jne    10038f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003be:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c5:	e8 2a ff ff ff       	call   1002f4 <cputch>
    return cnt;
  1003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003cd:	c9                   	leave  
  1003ce:	c3                   	ret    

001003cf <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003cf:	55                   	push   %ebp
  1003d0:	89 e5                	mov    %esp,%ebp
  1003d2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d5:	e8 65 12 00 00       	call   10163f <cons_getc>
  1003da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e1:	74 f2                	je     1003d5 <getchar+0x6>
        /* do nothing */;
    return c;
  1003e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e6:	c9                   	leave  
  1003e7:	c3                   	ret    

001003e8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e8:	55                   	push   %ebp
  1003e9:	89 e5                	mov    %esp,%ebp
  1003eb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f1:	8b 00                	mov    (%eax),%eax
  1003f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1003f9:	8b 00                	mov    (%eax),%eax
  1003fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100405:	e9 d2 00 00 00       	jmp    1004dc <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10040d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100410:	01 d0                	add    %edx,%eax
  100412:	89 c2                	mov    %eax,%edx
  100414:	c1 ea 1f             	shr    $0x1f,%edx
  100417:	01 d0                	add    %edx,%eax
  100419:	d1 f8                	sar    %eax
  10041b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100421:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100424:	eb 04                	jmp    10042a <stab_binsearch+0x42>
            m --;
  100426:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100430:	7c 1f                	jl     100451 <stab_binsearch+0x69>
  100432:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100435:	89 d0                	mov    %edx,%eax
  100437:	01 c0                	add    %eax,%eax
  100439:	01 d0                	add    %edx,%eax
  10043b:	c1 e0 02             	shl    $0x2,%eax
  10043e:	89 c2                	mov    %eax,%edx
  100440:	8b 45 08             	mov    0x8(%ebp),%eax
  100443:	01 d0                	add    %edx,%eax
  100445:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100449:	0f b6 c0             	movzbl %al,%eax
  10044c:	3b 45 14             	cmp    0x14(%ebp),%eax
  10044f:	75 d5                	jne    100426 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100457:	7d 0b                	jge    100464 <stab_binsearch+0x7c>
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100462:	eb 78                	jmp    1004dc <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100464:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046e:	89 d0                	mov    %edx,%eax
  100470:	01 c0                	add    %eax,%eax
  100472:	01 d0                	add    %edx,%eax
  100474:	c1 e0 02             	shl    $0x2,%eax
  100477:	89 c2                	mov    %eax,%edx
  100479:	8b 45 08             	mov    0x8(%ebp),%eax
  10047c:	01 d0                	add    %edx,%eax
  10047e:	8b 40 08             	mov    0x8(%eax),%eax
  100481:	3b 45 18             	cmp    0x18(%ebp),%eax
  100484:	73 13                	jae    100499 <stab_binsearch+0xb1>
            *region_left = m;
  100486:	8b 45 0c             	mov    0xc(%ebp),%eax
  100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100491:	83 c0 01             	add    $0x1,%eax
  100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100497:	eb 43                	jmp    1004dc <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049c:	89 d0                	mov    %edx,%eax
  10049e:	01 c0                	add    %eax,%eax
  1004a0:	01 d0                	add    %edx,%eax
  1004a2:	c1 e0 02             	shl    $0x2,%eax
  1004a5:	89 c2                	mov    %eax,%edx
  1004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1004aa:	01 d0                	add    %edx,%eax
  1004ac:	8b 40 08             	mov    0x8(%eax),%eax
  1004af:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b2:	76 16                	jbe    1004ca <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004ba:	8b 45 10             	mov    0x10(%ebp),%eax
  1004bd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c2:	83 e8 01             	sub    $0x1,%eax
  1004c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c8:	eb 12                	jmp    1004dc <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d0:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e2:	0f 8e 22 ff ff ff    	jle    10040a <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004ec:	75 0f                	jne    1004fd <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f1:	8b 00                	mov    (%eax),%eax
  1004f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f9:	89 10                	mov    %edx,(%eax)
  1004fb:	eb 3f                	jmp    10053c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100500:	8b 00                	mov    (%eax),%eax
  100502:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100505:	eb 04                	jmp    10050b <stab_binsearch+0x123>
  100507:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050e:	8b 00                	mov    (%eax),%eax
  100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100513:	7d 1f                	jge    100534 <stab_binsearch+0x14c>
  100515:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100518:	89 d0                	mov    %edx,%eax
  10051a:	01 c0                	add    %eax,%eax
  10051c:	01 d0                	add    %edx,%eax
  10051e:	c1 e0 02             	shl    $0x2,%eax
  100521:	89 c2                	mov    %eax,%edx
  100523:	8b 45 08             	mov    0x8(%ebp),%eax
  100526:	01 d0                	add    %edx,%eax
  100528:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052c:	0f b6 c0             	movzbl %al,%eax
  10052f:	3b 45 14             	cmp    0x14(%ebp),%eax
  100532:	75 d3                	jne    100507 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053a:	89 10                	mov    %edx,(%eax)
    }
}
  10053c:	c9                   	leave  
  10053d:	c3                   	ret    

0010053e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053e:	55                   	push   %ebp
  10053f:	89 e5                	mov    %esp,%ebp
  100541:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	c7 00 6c 74 10 00    	movl   $0x10746c,(%eax)
    info->eip_line = 0;
  10054d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100557:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055a:	c7 40 08 6c 74 10 00 	movl   $0x10746c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100561:	8b 45 0c             	mov    0xc(%ebp),%eax
  100564:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10056b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056e:	8b 55 08             	mov    0x8(%ebp),%edx
  100571:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100574:	8b 45 0c             	mov    0xc(%ebp),%eax
  100577:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057e:	c7 45 f4 c0 89 10 00 	movl   $0x1089c0,-0xc(%ebp)
    stab_end = __STAB_END__;
  100585:	c7 45 f0 9c 4f 11 00 	movl   $0x114f9c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058c:	c7 45 ec 9d 4f 11 00 	movl   $0x114f9d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100593:	c7 45 e8 cf 7c 11 00 	movl   $0x117ccf,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a0:	76 0d                	jbe    1005af <debuginfo_eip+0x71>
  1005a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a5:	83 e8 01             	sub    $0x1,%eax
  1005a8:	0f b6 00             	movzbl (%eax),%eax
  1005ab:	84 c0                	test   %al,%al
  1005ad:	74 0a                	je     1005b9 <debuginfo_eip+0x7b>
        return -1;
  1005af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b4:	e9 c0 02 00 00       	jmp    100879 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c6:	29 c2                	sub    %eax,%edx
  1005c8:	89 d0                	mov    %edx,%eax
  1005ca:	c1 f8 02             	sar    $0x2,%eax
  1005cd:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d3:	83 e8 01             	sub    $0x1,%eax
  1005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e7:	00 
  1005e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005f9:	89 04 24             	mov    %eax,(%esp)
  1005fc:	e8 e7 fd ff ff       	call   1003e8 <stab_binsearch>
    if (lfile == 0)
  100601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100604:	85 c0                	test   %eax,%eax
  100606:	75 0a                	jne    100612 <debuginfo_eip+0xd4>
        return -1;
  100608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10060d:	e9 67 02 00 00       	jmp    100879 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100615:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061e:	8b 45 08             	mov    0x8(%ebp),%eax
  100621:	89 44 24 10          	mov    %eax,0x10(%esp)
  100625:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10062c:	00 
  10062d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100630:	89 44 24 08          	mov    %eax,0x8(%esp)
  100634:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100637:	89 44 24 04          	mov    %eax,0x4(%esp)
  10063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063e:	89 04 24             	mov    %eax,(%esp)
  100641:	e8 a2 fd ff ff       	call   1003e8 <stab_binsearch>

    if (lfun <= rfun) {
  100646:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10064c:	39 c2                	cmp    %eax,%edx
  10064e:	7f 7c                	jg     1006cc <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	89 d0                	mov    %edx,%eax
  100657:	01 c0                	add    %eax,%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	c1 e0 02             	shl    $0x2,%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100663:	01 d0                	add    %edx,%eax
  100665:	8b 10                	mov    (%eax),%edx
  100667:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066d:	29 c1                	sub    %eax,%ecx
  10066f:	89 c8                	mov    %ecx,%eax
  100671:	39 c2                	cmp    %eax,%edx
  100673:	73 22                	jae    100697 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	89 d0                	mov    %edx,%eax
  10067c:	01 c0                	add    %eax,%eax
  10067e:	01 d0                	add    %edx,%eax
  100680:	c1 e0 02             	shl    $0x2,%eax
  100683:	89 c2                	mov    %eax,%edx
  100685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100688:	01 d0                	add    %edx,%eax
  10068a:	8b 10                	mov    (%eax),%edx
  10068c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10068f:	01 c2                	add    %eax,%edx
  100691:	8b 45 0c             	mov    0xc(%ebp),%eax
  100694:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100697:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	89 d0                	mov    %edx,%eax
  10069e:	01 c0                	add    %eax,%eax
  1006a0:	01 d0                	add    %edx,%eax
  1006a2:	c1 e0 02             	shl    $0x2,%eax
  1006a5:	89 c2                	mov    %eax,%edx
  1006a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006aa:	01 d0                	add    %edx,%eax
  1006ac:	8b 50 08             	mov    0x8(%eax),%edx
  1006af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b2:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b8:	8b 40 10             	mov    0x10(%eax),%eax
  1006bb:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006ca:	eb 15                	jmp    1006e1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006de:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e4:	8b 40 08             	mov    0x8(%eax),%eax
  1006e7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ee:	00 
  1006ef:	89 04 24             	mov    %eax,(%esp)
  1006f2:	e8 9d 69 00 00       	call   107094 <strfind>
  1006f7:	89 c2                	mov    %eax,%edx
  1006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fc:	8b 40 08             	mov    0x8(%eax),%eax
  1006ff:	29 c2                	sub    %eax,%edx
  100701:	8b 45 0c             	mov    0xc(%ebp),%eax
  100704:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100707:	8b 45 08             	mov    0x8(%ebp),%eax
  10070a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070e:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100715:	00 
  100716:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100719:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100720:	89 44 24 04          	mov    %eax,0x4(%esp)
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	89 04 24             	mov    %eax,(%esp)
  10072a:	e8 b9 fc ff ff       	call   1003e8 <stab_binsearch>
    if (lline <= rline) {
  10072f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100732:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100735:	39 c2                	cmp    %eax,%edx
  100737:	7f 24                	jg     10075d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	89 d0                	mov    %edx,%eax
  100740:	01 c0                	add    %eax,%eax
  100742:	01 d0                	add    %edx,%eax
  100744:	c1 e0 02             	shl    $0x2,%eax
  100747:	89 c2                	mov    %eax,%edx
  100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074c:	01 d0                	add    %edx,%eax
  10074e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100752:	0f b7 d0             	movzwl %ax,%edx
  100755:	8b 45 0c             	mov    0xc(%ebp),%eax
  100758:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075b:	eb 13                	jmp    100770 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10075d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100762:	e9 12 01 00 00       	jmp    100879 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076a:	83 e8 01             	sub    $0x1,%eax
  10076d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100770:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100776:	39 c2                	cmp    %eax,%edx
  100778:	7c 56                	jl     1007d0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	89 d0                	mov    %edx,%eax
  100781:	01 c0                	add    %eax,%eax
  100783:	01 d0                	add    %edx,%eax
  100785:	c1 e0 02             	shl    $0x2,%eax
  100788:	89 c2                	mov    %eax,%edx
  10078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078d:	01 d0                	add    %edx,%eax
  10078f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100793:	3c 84                	cmp    $0x84,%al
  100795:	74 39                	je     1007d0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100797:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	89 d0                	mov    %edx,%eax
  10079e:	01 c0                	add    %eax,%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	c1 e0 02             	shl    $0x2,%eax
  1007a5:	89 c2                	mov    %eax,%edx
  1007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007aa:	01 d0                	add    %edx,%eax
  1007ac:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b0:	3c 64                	cmp    $0x64,%al
  1007b2:	75 b3                	jne    100767 <debuginfo_eip+0x229>
  1007b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	89 d0                	mov    %edx,%eax
  1007bb:	01 c0                	add    %eax,%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	c1 e0 02             	shl    $0x2,%eax
  1007c2:	89 c2                	mov    %eax,%edx
  1007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c7:	01 d0                	add    %edx,%eax
  1007c9:	8b 40 08             	mov    0x8(%eax),%eax
  1007cc:	85 c0                	test   %eax,%eax
  1007ce:	74 97                	je     100767 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d6:	39 c2                	cmp    %eax,%edx
  1007d8:	7c 46                	jl     100820 <debuginfo_eip+0x2e2>
  1007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	89 d0                	mov    %edx,%eax
  1007e1:	01 c0                	add    %eax,%eax
  1007e3:	01 d0                	add    %edx,%eax
  1007e5:	c1 e0 02             	shl    $0x2,%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ed:	01 d0                	add    %edx,%eax
  1007ef:	8b 10                	mov    (%eax),%edx
  1007f1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f7:	29 c1                	sub    %eax,%ecx
  1007f9:	89 c8                	mov    %ecx,%eax
  1007fb:	39 c2                	cmp    %eax,%edx
  1007fd:	73 21                	jae    100820 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	89 d0                	mov    %edx,%eax
  100806:	01 c0                	add    %eax,%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	c1 e0 02             	shl    $0x2,%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100812:	01 d0                	add    %edx,%eax
  100814:	8b 10                	mov    (%eax),%edx
  100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100819:	01 c2                	add    %eax,%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100826:	39 c2                	cmp    %eax,%edx
  100828:	7d 4a                	jge    100874 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082d:	83 c0 01             	add    $0x1,%eax
  100830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100833:	eb 18                	jmp    10084d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100835:	8b 45 0c             	mov    0xc(%ebp),%eax
  100838:	8b 40 14             	mov    0x14(%eax),%eax
  10083b:	8d 50 01             	lea    0x1(%eax),%edx
  10083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100841:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100847:	83 c0 01             	add    $0x1,%eax
  10084a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100850:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100853:	39 c2                	cmp    %eax,%edx
  100855:	7d 1d                	jge    100874 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	89 d0                	mov    %edx,%eax
  10085e:	01 c0                	add    %eax,%eax
  100860:	01 d0                	add    %edx,%eax
  100862:	c1 e0 02             	shl    $0x2,%eax
  100865:	89 c2                	mov    %eax,%edx
  100867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086a:	01 d0                	add    %edx,%eax
  10086c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100870:	3c a0                	cmp    $0xa0,%al
  100872:	74 c1                	je     100835 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100879:	c9                   	leave  
  10087a:	c3                   	ret    

0010087b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10087b:	55                   	push   %ebp
  10087c:	89 e5                	mov    %esp,%ebp
  10087e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100881:	c7 04 24 76 74 10 00 	movl   $0x107476,(%esp)
  100888:	e8 ba fa ff ff       	call   100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088d:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100894:	00 
  100895:	c7 04 24 8f 74 10 00 	movl   $0x10748f,(%esp)
  10089c:	e8 a6 fa ff ff       	call   100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a1:	c7 44 24 04 a9 73 10 	movl   $0x1073a9,0x4(%esp)
  1008a8:	00 
  1008a9:	c7 04 24 a7 74 10 00 	movl   $0x1074a7,(%esp)
  1008b0:	e8 92 fa ff ff       	call   100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b5:	c7 44 24 04 36 aa 11 	movl   $0x11aa36,0x4(%esp)
  1008bc:	00 
  1008bd:	c7 04 24 bf 74 10 00 	movl   $0x1074bf,(%esp)
  1008c4:	e8 7e fa ff ff       	call   100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c9:	c7 44 24 04 48 ba 11 	movl   $0x11ba48,0x4(%esp)
  1008d0:	00 
  1008d1:	c7 04 24 d7 74 10 00 	movl   $0x1074d7,(%esp)
  1008d8:	e8 6a fa ff ff       	call   100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008dd:	b8 48 ba 11 00       	mov    $0x11ba48,%eax
  1008e2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e8:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008ed:	29 c2                	sub    %eax,%edx
  1008ef:	89 d0                	mov    %edx,%eax
  1008f1:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	0f 48 c2             	cmovs  %edx,%eax
  1008fc:	c1 f8 0a             	sar    $0xa,%eax
  1008ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100903:	c7 04 24 f0 74 10 00 	movl   $0x1074f0,(%esp)
  10090a:	e8 38 fa ff ff       	call   100347 <cprintf>
}
  10090f:	c9                   	leave  
  100910:	c3                   	ret    

00100911 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100911:	55                   	push   %ebp
  100912:	89 e5                	mov    %esp,%ebp
  100914:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10091d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100921:	8b 45 08             	mov    0x8(%ebp),%eax
  100924:	89 04 24             	mov    %eax,(%esp)
  100927:	e8 12 fc ff ff       	call   10053e <debuginfo_eip>
  10092c:	85 c0                	test   %eax,%eax
  10092e:	74 15                	je     100945 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100930:	8b 45 08             	mov    0x8(%ebp),%eax
  100933:	89 44 24 04          	mov    %eax,0x4(%esp)
  100937:	c7 04 24 1a 75 10 00 	movl   $0x10751a,(%esp)
  10093e:	e8 04 fa ff ff       	call   100347 <cprintf>
  100943:	eb 6d                	jmp    1009b2 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094c:	eb 1c                	jmp    10096a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10094e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100954:	01 d0                	add    %edx,%eax
  100956:	0f b6 00             	movzbl (%eax),%eax
  100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100962:	01 ca                	add    %ecx,%edx
  100964:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100966:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100970:	7f dc                	jg     10094e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100972:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097b:	01 d0                	add    %edx,%eax
  10097d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100980:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100983:	8b 55 08             	mov    0x8(%ebp),%edx
  100986:	89 d1                	mov    %edx,%ecx
  100988:	29 c1                	sub    %eax,%ecx
  10098a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100990:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100994:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099e:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a6:	c7 04 24 36 75 10 00 	movl   $0x107536,(%esp)
  1009ad:	e8 95 f9 ff ff       	call   100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b2:	c9                   	leave  
  1009b3:	c3                   	ret    

001009b4 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b4:	55                   	push   %ebp
  1009b5:	89 e5                	mov    %esp,%ebp
  1009b7:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009ba:	8b 45 04             	mov    0x4(%ebp),%eax
  1009bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c3:	c9                   	leave  
  1009c4:	c3                   	ret    

001009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c5:	55                   	push   %ebp
  1009c6:	89 e5                	mov    %esp,%ebp
  1009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cb:	89 e8                	mov    %ebp,%eax
  1009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
		uint32_t ebp=read_ebp();
  1009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t eip=read_eip();
  1009d6:	e8 d9 ff ff ff       	call   1009b4 <read_eip>
  1009db:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int i;
		for(i=0;ebp!=0&&i<STACKFRAME_DEPTH;i++)
  1009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e5:	e9 88 00 00 00       	jmp    100a72 <print_stackframe+0xad>
		{
			cprintf("ebp:0x%08x,eip:0x%08x,args:",ebp,eip);
  1009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f8:	c7 04 24 48 75 10 00 	movl   $0x107548,(%esp)
  1009ff:	e8 43 f9 ff ff       	call   100347 <cprintf>
			uint32_t *arg=(uint32_t*)ebp+2;
  100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a07:	83 c0 08             	add    $0x8,%eax
  100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			int j;
			for(j=0;j<4;j++)
  100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a14:	eb 25                	jmp    100a3b <print_stackframe+0x76>
			{
				cprintf("0x%08x ",arg[j]);
  100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a23:	01 d0                	add    %edx,%eax
  100a25:	8b 00                	mov    (%eax),%eax
  100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2b:	c7 04 24 64 75 10 00 	movl   $0x107564,(%esp)
  100a32:	e8 10 f9 ff ff       	call   100347 <cprintf>
		for(i=0;ebp!=0&&i<STACKFRAME_DEPTH;i++)
		{
			cprintf("ebp:0x%08x,eip:0x%08x,args:",ebp,eip);
			uint32_t *arg=(uint32_t*)ebp+2;
			int j;
			for(j=0;j<4;j++)
  100a37:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a3b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3f:	7e d5                	jle    100a16 <print_stackframe+0x51>
			{
				cprintf("0x%08x ",arg[j]);
			}
			cprintf("\n");
  100a41:	c7 04 24 6c 75 10 00 	movl   $0x10756c,(%esp)
  100a48:	e8 fa f8 ff ff       	call   100347 <cprintf>
			print_debuginfo(eip-1);
  100a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a50:	83 e8 01             	sub    $0x1,%eax
  100a53:	89 04 24             	mov    %eax,(%esp)
  100a56:	e8 b6 fe ff ff       	call   100911 <print_debuginfo>
			eip=*((uint32_t*)ebp+1);
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	83 c0 04             	add    $0x4,%eax
  100a61:	8b 00                	mov    (%eax),%eax
  100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
			ebp=*((uint32_t*)ebp);
  100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a69:	8b 00                	mov    (%eax),%eax
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
		uint32_t ebp=read_ebp();
		uint32_t eip=read_eip();
		int i;
		for(i=0;ebp!=0&&i<STACKFRAME_DEPTH;i++)
  100a6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a76:	74 0a                	je     100a82 <print_stackframe+0xbd>
  100a78:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a7c:	0f 8e 68 ff ff ff    	jle    1009ea <print_stackframe+0x25>
			cprintf("\n");
			print_debuginfo(eip-1);
			eip=*((uint32_t*)ebp+1);
			ebp=*((uint32_t*)ebp);
		}
}
  100a82:	c9                   	leave  
  100a83:	c3                   	ret    

00100a84 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a84:	55                   	push   %ebp
  100a85:	89 e5                	mov    %esp,%ebp
  100a87:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a91:	eb 0c                	jmp    100a9f <parse+0x1b>
            *buf ++ = '\0';
  100a93:	8b 45 08             	mov    0x8(%ebp),%eax
  100a96:	8d 50 01             	lea    0x1(%eax),%edx
  100a99:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa2:	0f b6 00             	movzbl (%eax),%eax
  100aa5:	84 c0                	test   %al,%al
  100aa7:	74 1d                	je     100ac6 <parse+0x42>
  100aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  100aac:	0f b6 00             	movzbl (%eax),%eax
  100aaf:	0f be c0             	movsbl %al,%eax
  100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab6:	c7 04 24 f0 75 10 00 	movl   $0x1075f0,(%esp)
  100abd:	e8 9f 65 00 00       	call   107061 <strchr>
  100ac2:	85 c0                	test   %eax,%eax
  100ac4:	75 cd                	jne    100a93 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac9:	0f b6 00             	movzbl (%eax),%eax
  100acc:	84 c0                	test   %al,%al
  100ace:	75 02                	jne    100ad2 <parse+0x4e>
            break;
  100ad0:	eb 67                	jmp    100b39 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad6:	75 14                	jne    100aec <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adf:	00 
  100ae0:	c7 04 24 f5 75 10 00 	movl   $0x1075f5,(%esp)
  100ae7:	e8 5b f8 ff ff       	call   100347 <cprintf>
        }
        argv[argc ++] = buf;
  100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aef:	8d 50 01             	lea    0x1(%eax),%edx
  100af2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aff:	01 c2                	add    %eax,%edx
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b06:	eb 04                	jmp    100b0c <parse+0x88>
            buf ++;
  100b08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0f:	0f b6 00             	movzbl (%eax),%eax
  100b12:	84 c0                	test   %al,%al
  100b14:	74 1d                	je     100b33 <parse+0xaf>
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	0f b6 00             	movzbl (%eax),%eax
  100b1c:	0f be c0             	movsbl %al,%eax
  100b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b23:	c7 04 24 f0 75 10 00 	movl   $0x1075f0,(%esp)
  100b2a:	e8 32 65 00 00       	call   107061 <strchr>
  100b2f:	85 c0                	test   %eax,%eax
  100b31:	74 d5                	je     100b08 <parse+0x84>
            buf ++;
        }
    }
  100b33:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b34:	e9 66 ff ff ff       	jmp    100a9f <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b3c:	c9                   	leave  
  100b3d:	c3                   	ret    

00100b3e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3e:	55                   	push   %ebp
  100b3f:	89 e5                	mov    %esp,%ebp
  100b41:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b44:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4e:	89 04 24             	mov    %eax,(%esp)
  100b51:	e8 2e ff ff ff       	call   100a84 <parse>
  100b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5d:	75 0a                	jne    100b69 <runcmd+0x2b>
        return 0;
  100b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b64:	e9 85 00 00 00       	jmp    100bee <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b70:	eb 5c                	jmp    100bce <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b72:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b78:	89 d0                	mov    %edx,%eax
  100b7a:	01 c0                	add    %eax,%eax
  100b7c:	01 d0                	add    %edx,%eax
  100b7e:	c1 e0 02             	shl    $0x2,%eax
  100b81:	05 20 a0 11 00       	add    $0x11a020,%eax
  100b86:	8b 00                	mov    (%eax),%eax
  100b88:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b8c:	89 04 24             	mov    %eax,(%esp)
  100b8f:	e8 2e 64 00 00       	call   106fc2 <strcmp>
  100b94:	85 c0                	test   %eax,%eax
  100b96:	75 32                	jne    100bca <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9b:	89 d0                	mov    %edx,%eax
  100b9d:	01 c0                	add    %eax,%eax
  100b9f:	01 d0                	add    %edx,%eax
  100ba1:	c1 e0 02             	shl    $0x2,%eax
  100ba4:	05 20 a0 11 00       	add    $0x11a020,%eax
  100ba9:	8b 40 08             	mov    0x8(%eax),%eax
  100bac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100baf:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb5:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb9:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bbc:	83 c2 04             	add    $0x4,%edx
  100bbf:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bc3:	89 0c 24             	mov    %ecx,(%esp)
  100bc6:	ff d0                	call   *%eax
  100bc8:	eb 24                	jmp    100bee <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd1:	83 f8 02             	cmp    $0x2,%eax
  100bd4:	76 9c                	jbe    100b72 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdd:	c7 04 24 13 76 10 00 	movl   $0x107613,(%esp)
  100be4:	e8 5e f7 ff ff       	call   100347 <cprintf>
    return 0;
  100be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bee:	c9                   	leave  
  100bef:	c3                   	ret    

00100bf0 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf0:	55                   	push   %ebp
  100bf1:	89 e5                	mov    %esp,%ebp
  100bf3:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf6:	c7 04 24 2c 76 10 00 	movl   $0x10762c,(%esp)
  100bfd:	e8 45 f7 ff ff       	call   100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c02:	c7 04 24 54 76 10 00 	movl   $0x107654,(%esp)
  100c09:	e8 39 f7 ff ff       	call   100347 <cprintf>

    if (tf != NULL) {
  100c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c12:	74 0b                	je     100c1f <kmonitor+0x2f>
        print_trapframe(tf);
  100c14:	8b 45 08             	mov    0x8(%ebp),%eax
  100c17:	89 04 24             	mov    %eax,(%esp)
  100c1a:	e8 55 0e 00 00       	call   101a74 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1f:	c7 04 24 79 76 10 00 	movl   $0x107679,(%esp)
  100c26:	e8 13 f6 ff ff       	call   10023e <readline>
  100c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c32:	74 18                	je     100c4c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c34:	8b 45 08             	mov    0x8(%ebp),%eax
  100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3e:	89 04 24             	mov    %eax,(%esp)
  100c41:	e8 f8 fe ff ff       	call   100b3e <runcmd>
  100c46:	85 c0                	test   %eax,%eax
  100c48:	79 02                	jns    100c4c <kmonitor+0x5c>
                break;
  100c4a:	eb 02                	jmp    100c4e <kmonitor+0x5e>
            }
        }
    }
  100c4c:	eb d1                	jmp    100c1f <kmonitor+0x2f>
}
  100c4e:	c9                   	leave  
  100c4f:	c3                   	ret    

00100c50 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c50:	55                   	push   %ebp
  100c51:	89 e5                	mov    %esp,%ebp
  100c53:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5d:	eb 3f                	jmp    100c9e <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c62:	89 d0                	mov    %edx,%eax
  100c64:	01 c0                	add    %eax,%eax
  100c66:	01 d0                	add    %edx,%eax
  100c68:	c1 e0 02             	shl    $0x2,%eax
  100c6b:	05 20 a0 11 00       	add    $0x11a020,%eax
  100c70:	8b 48 04             	mov    0x4(%eax),%ecx
  100c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c76:	89 d0                	mov    %edx,%eax
  100c78:	01 c0                	add    %eax,%eax
  100c7a:	01 d0                	add    %edx,%eax
  100c7c:	c1 e0 02             	shl    $0x2,%eax
  100c7f:	05 20 a0 11 00       	add    $0x11a020,%eax
  100c84:	8b 00                	mov    (%eax),%eax
  100c86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8e:	c7 04 24 7d 76 10 00 	movl   $0x10767d,(%esp)
  100c95:	e8 ad f6 ff ff       	call   100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca1:	83 f8 02             	cmp    $0x2,%eax
  100ca4:	76 b9                	jbe    100c5f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cab:	c9                   	leave  
  100cac:	c3                   	ret    

00100cad <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cad:	55                   	push   %ebp
  100cae:	89 e5                	mov    %esp,%ebp
  100cb0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb3:	e8 c3 fb ff ff       	call   10087b <print_kerninfo>
    return 0;
  100cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbd:	c9                   	leave  
  100cbe:	c3                   	ret    

00100cbf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbf:	55                   	push   %ebp
  100cc0:	89 e5                	mov    %esp,%ebp
  100cc2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc5:	e8 fb fc ff ff       	call   1009c5 <print_stackframe>
    return 0;
  100cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccf:	c9                   	leave  
  100cd0:	c3                   	ret    

00100cd1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cd1:	55                   	push   %ebp
  100cd2:	89 e5                	mov    %esp,%ebp
  100cd4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd7:	a1 60 ae 11 00       	mov    0x11ae60,%eax
  100cdc:	85 c0                	test   %eax,%eax
  100cde:	74 02                	je     100ce2 <__panic+0x11>
        goto panic_dead;
  100ce0:	eb 48                	jmp    100d2a <__panic+0x59>
    }
    is_panic = 1;
  100ce2:	c7 05 60 ae 11 00 01 	movl   $0x1,0x11ae60
  100ce9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cec:	8d 45 14             	lea    0x14(%ebp),%eax
  100cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d00:	c7 04 24 86 76 10 00 	movl   $0x107686,(%esp)
  100d07:	e8 3b f6 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d13:	8b 45 10             	mov    0x10(%ebp),%eax
  100d16:	89 04 24             	mov    %eax,(%esp)
  100d19:	e8 f6 f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d1e:	c7 04 24 a2 76 10 00 	movl   $0x1076a2,(%esp)
  100d25:	e8 1d f6 ff ff       	call   100347 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d2a:	e8 85 09 00 00       	call   1016b4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d36:	e8 b5 fe ff ff       	call   100bf0 <kmonitor>
    }
  100d3b:	eb f2                	jmp    100d2f <__panic+0x5e>

00100d3d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d3d:	55                   	push   %ebp
  100d3e:	89 e5                	mov    %esp,%ebp
  100d40:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d43:	8d 45 14             	lea    0x14(%ebp),%eax
  100d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d50:	8b 45 08             	mov    0x8(%ebp),%eax
  100d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d57:	c7 04 24 a4 76 10 00 	movl   $0x1076a4,(%esp)
  100d5e:	e8 e4 f5 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d6d:	89 04 24             	mov    %eax,(%esp)
  100d70:	e8 9f f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d75:	c7 04 24 a2 76 10 00 	movl   $0x1076a2,(%esp)
  100d7c:	e8 c6 f5 ff ff       	call   100347 <cprintf>
    va_end(ap);
}
  100d81:	c9                   	leave  
  100d82:	c3                   	ret    

00100d83 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d83:	55                   	push   %ebp
  100d84:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d86:	a1 60 ae 11 00       	mov    0x11ae60,%eax
}
  100d8b:	5d                   	pop    %ebp
  100d8c:	c3                   	ret    

00100d8d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d8d:	55                   	push   %ebp
  100d8e:	89 e5                	mov    %esp,%ebp
  100d90:	83 ec 28             	sub    $0x28,%esp
  100d93:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d99:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d9d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100da1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da5:	ee                   	out    %al,(%dx)
  100da6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dac:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100db0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db8:	ee                   	out    %al,(%dx)
  100db9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dc3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dcb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dcc:	c7 05 2c ba 11 00 00 	movl   $0x0,0x11ba2c
  100dd3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd6:	c7 04 24 c2 76 10 00 	movl   $0x1076c2,(%esp)
  100ddd:	e8 65 f5 ff ff       	call   100347 <cprintf>
    pic_enable(IRQ_TIMER);
  100de2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de9:	e8 24 09 00 00       	call   101712 <pic_enable>
}
  100dee:	c9                   	leave  
  100def:	c3                   	ret    

00100df0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100df0:	55                   	push   %ebp
  100df1:	89 e5                	mov    %esp,%ebp
  100df3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df6:	9c                   	pushf  
  100df7:	58                   	pop    %eax
  100df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfe:	25 00 02 00 00       	and    $0x200,%eax
  100e03:	85 c0                	test   %eax,%eax
  100e05:	74 0c                	je     100e13 <__intr_save+0x23>
        intr_disable();
  100e07:	e8 a8 08 00 00       	call   1016b4 <intr_disable>
        return 1;
  100e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  100e11:	eb 05                	jmp    100e18 <__intr_save+0x28>
    }
    return 0;
  100e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e18:	c9                   	leave  
  100e19:	c3                   	ret    

00100e1a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e1a:	55                   	push   %ebp
  100e1b:	89 e5                	mov    %esp,%ebp
  100e1d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e24:	74 05                	je     100e2b <__intr_restore+0x11>
        intr_enable();
  100e26:	e8 83 08 00 00       	call   1016ae <intr_enable>
    }
}
  100e2b:	c9                   	leave  
  100e2c:	c3                   	ret    

00100e2d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e2d:	55                   	push   %ebp
  100e2e:	89 e5                	mov    %esp,%ebp
  100e30:	83 ec 10             	sub    $0x10,%esp
  100e33:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e39:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e3d:	89 c2                	mov    %eax,%edx
  100e3f:	ec                   	in     (%dx),%al
  100e40:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e43:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e49:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e4d:	89 c2                	mov    %eax,%edx
  100e4f:	ec                   	in     (%dx),%al
  100e50:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e53:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e59:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5d:	89 c2                	mov    %eax,%edx
  100e5f:	ec                   	in     (%dx),%al
  100e60:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e63:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e69:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e6d:	89 c2                	mov    %eax,%edx
  100e6f:	ec                   	in     (%dx),%al
  100e70:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e73:	c9                   	leave  
  100e74:	c3                   	ret    

00100e75 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e75:	55                   	push   %ebp
  100e76:	89 e5                	mov    %esp,%ebp
  100e78:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e7b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e85:	0f b7 00             	movzwl (%eax),%eax
  100e88:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e97:	0f b7 00             	movzwl (%eax),%eax
  100e9a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9e:	74 12                	je     100eb2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ea0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea7:	66 c7 05 86 ae 11 00 	movw   $0x3b4,0x11ae86
  100eae:	b4 03 
  100eb0:	eb 13                	jmp    100ec5 <cga_init+0x50>
    } else {
        *cp = was;
  100eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ebc:	66 c7 05 86 ae 11 00 	movw   $0x3d4,0x11ae86
  100ec3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec5:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  100ecc:	0f b7 c0             	movzwl %ax,%eax
  100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ed3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100edb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100edf:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ee0:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  100ee7:	83 c0 01             	add    $0x1,%eax
  100eea:	0f b7 c0             	movzwl %ax,%eax
  100eed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef5:	89 c2                	mov    %eax,%edx
  100ef7:	ec                   	in     (%dx),%al
  100ef8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100efb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eff:	0f b6 c0             	movzbl %al,%eax
  100f02:	c1 e0 08             	shl    $0x8,%eax
  100f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f08:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  100f0f:	0f b7 c0             	movzwl %ax,%eax
  100f12:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f16:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f1a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f22:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f23:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  100f2a:	83 c0 01             	add    $0x1,%eax
  100f2d:	0f b7 c0             	movzwl %ax,%eax
  100f30:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f34:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f38:	89 c2                	mov    %eax,%edx
  100f3a:	ec                   	in     (%dx),%al
  100f3b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f3e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f42:	0f b6 c0             	movzbl %al,%eax
  100f45:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f4b:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    crt_pos = pos;
  100f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f53:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
}
  100f59:	c9                   	leave  
  100f5a:	c3                   	ret    

00100f5b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f5b:	55                   	push   %ebp
  100f5c:	89 e5                	mov    %esp,%ebp
  100f5e:	83 ec 48             	sub    $0x48,%esp
  100f61:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f67:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f6b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
  100f74:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f7a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f7e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f82:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f86:	ee                   	out    %al,(%dx)
  100f87:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f8d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f99:	ee                   	out    %al,(%dx)
  100f9a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fa4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fac:	ee                   	out    %al,(%dx)
  100fad:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fb3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fbb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbf:	ee                   	out    %al,(%dx)
  100fc0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fca:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fce:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd2:	ee                   	out    %al,(%dx)
  100fd3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fdd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe5:	ee                   	out    %al,(%dx)
  100fe6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fec:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100ff0:	89 c2                	mov    %eax,%edx
  100ff2:	ec                   	in     (%dx),%al
  100ff3:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ffa:	3c ff                	cmp    $0xff,%al
  100ffc:	0f 95 c0             	setne  %al
  100fff:	0f b6 c0             	movzbl %al,%eax
  101002:	a3 88 ae 11 00       	mov    %eax,0x11ae88
  101007:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10100d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101011:	89 c2                	mov    %eax,%edx
  101013:	ec                   	in     (%dx),%al
  101014:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101017:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10101d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101021:	89 c2                	mov    %eax,%edx
  101023:	ec                   	in     (%dx),%al
  101024:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101027:	a1 88 ae 11 00       	mov    0x11ae88,%eax
  10102c:	85 c0                	test   %eax,%eax
  10102e:	74 0c                	je     10103c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101030:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101037:	e8 d6 06 00 00       	call   101712 <pic_enable>
    }
}
  10103c:	c9                   	leave  
  10103d:	c3                   	ret    

0010103e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103e:	55                   	push   %ebp
  10103f:	89 e5                	mov    %esp,%ebp
  101041:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10104b:	eb 09                	jmp    101056 <lpt_putc_sub+0x18>
        delay();
  10104d:	e8 db fd ff ff       	call   100e2d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101052:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101056:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10105c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101060:	89 c2                	mov    %eax,%edx
  101062:	ec                   	in     (%dx),%al
  101063:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101066:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10106a:	84 c0                	test   %al,%al
  10106c:	78 09                	js     101077 <lpt_putc_sub+0x39>
  10106e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101075:	7e d6                	jle    10104d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101077:	8b 45 08             	mov    0x8(%ebp),%eax
  10107a:	0f b6 c0             	movzbl %al,%eax
  10107d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101083:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101086:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10108a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108e:	ee                   	out    %al,(%dx)
  10108f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101095:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101099:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10109d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010a1:	ee                   	out    %al,(%dx)
  1010a2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b5:	c9                   	leave  
  1010b6:	c3                   	ret    

001010b7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b7:	55                   	push   %ebp
  1010b8:	89 e5                	mov    %esp,%ebp
  1010ba:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010bd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010c1:	74 0d                	je     1010d0 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c6:	89 04 24             	mov    %eax,(%esp)
  1010c9:	e8 70 ff ff ff       	call   10103e <lpt_putc_sub>
  1010ce:	eb 24                	jmp    1010f4 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010d0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d7:	e8 62 ff ff ff       	call   10103e <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010dc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010e3:	e8 56 ff ff ff       	call   10103e <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ef:	e8 4a ff ff ff       	call   10103e <lpt_putc_sub>
    }
}
  1010f4:	c9                   	leave  
  1010f5:	c3                   	ret    

001010f6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f6:	55                   	push   %ebp
  1010f7:	89 e5                	mov    %esp,%ebp
  1010f9:	53                   	push   %ebx
  1010fa:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101100:	b0 00                	mov    $0x0,%al
  101102:	85 c0                	test   %eax,%eax
  101104:	75 07                	jne    10110d <cga_putc+0x17>
        c |= 0x0700;
  101106:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10110d:	8b 45 08             	mov    0x8(%ebp),%eax
  101110:	0f b6 c0             	movzbl %al,%eax
  101113:	83 f8 0a             	cmp    $0xa,%eax
  101116:	74 4c                	je     101164 <cga_putc+0x6e>
  101118:	83 f8 0d             	cmp    $0xd,%eax
  10111b:	74 57                	je     101174 <cga_putc+0x7e>
  10111d:	83 f8 08             	cmp    $0x8,%eax
  101120:	0f 85 88 00 00 00    	jne    1011ae <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101126:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  10112d:	66 85 c0             	test   %ax,%ax
  101130:	74 30                	je     101162 <cga_putc+0x6c>
            crt_pos --;
  101132:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  101139:	83 e8 01             	sub    $0x1,%eax
  10113c:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101142:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  101147:	0f b7 15 84 ae 11 00 	movzwl 0x11ae84,%edx
  10114e:	0f b7 d2             	movzwl %dx,%edx
  101151:	01 d2                	add    %edx,%edx
  101153:	01 c2                	add    %eax,%edx
  101155:	8b 45 08             	mov    0x8(%ebp),%eax
  101158:	b0 00                	mov    $0x0,%al
  10115a:	83 c8 20             	or     $0x20,%eax
  10115d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101160:	eb 72                	jmp    1011d4 <cga_putc+0xde>
  101162:	eb 70                	jmp    1011d4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101164:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  10116b:	83 c0 50             	add    $0x50,%eax
  10116e:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101174:	0f b7 1d 84 ae 11 00 	movzwl 0x11ae84,%ebx
  10117b:	0f b7 0d 84 ae 11 00 	movzwl 0x11ae84,%ecx
  101182:	0f b7 c1             	movzwl %cx,%eax
  101185:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10118b:	c1 e8 10             	shr    $0x10,%eax
  10118e:	89 c2                	mov    %eax,%edx
  101190:	66 c1 ea 06          	shr    $0x6,%dx
  101194:	89 d0                	mov    %edx,%eax
  101196:	c1 e0 02             	shl    $0x2,%eax
  101199:	01 d0                	add    %edx,%eax
  10119b:	c1 e0 04             	shl    $0x4,%eax
  10119e:	29 c1                	sub    %eax,%ecx
  1011a0:	89 ca                	mov    %ecx,%edx
  1011a2:	89 d8                	mov    %ebx,%eax
  1011a4:	29 d0                	sub    %edx,%eax
  1011a6:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
        break;
  1011ac:	eb 26                	jmp    1011d4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011ae:	8b 0d 80 ae 11 00    	mov    0x11ae80,%ecx
  1011b4:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  1011bb:	8d 50 01             	lea    0x1(%eax),%edx
  1011be:	66 89 15 84 ae 11 00 	mov    %dx,0x11ae84
  1011c5:	0f b7 c0             	movzwl %ax,%eax
  1011c8:	01 c0                	add    %eax,%eax
  1011ca:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d0:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d4:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  1011db:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011df:	76 5b                	jbe    10123c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e1:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1011e6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ec:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1011f1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f8:	00 
  1011f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011fd:	89 04 24             	mov    %eax,(%esp)
  101200:	e8 5a 60 00 00       	call   10725f <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101205:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10120c:	eb 15                	jmp    101223 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10120e:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  101213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101216:	01 d2                	add    %edx,%edx
  101218:	01 d0                	add    %edx,%eax
  10121a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101223:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10122a:	7e e2                	jle    10120e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10122c:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  101233:	83 e8 50             	sub    $0x50,%eax
  101236:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10123c:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  101243:	0f b7 c0             	movzwl %ax,%eax
  101246:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10124a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10124e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101252:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101256:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101257:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  10125e:	66 c1 e8 08          	shr    $0x8,%ax
  101262:	0f b6 c0             	movzbl %al,%eax
  101265:	0f b7 15 86 ae 11 00 	movzwl 0x11ae86,%edx
  10126c:	83 c2 01             	add    $0x1,%edx
  10126f:	0f b7 d2             	movzwl %dx,%edx
  101272:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101276:	88 45 ed             	mov    %al,-0x13(%ebp)
  101279:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10127d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101281:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101282:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  101289:	0f b7 c0             	movzwl %ax,%eax
  10128c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101290:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101294:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101298:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10129c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10129d:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  1012a4:	0f b6 c0             	movzbl %al,%eax
  1012a7:	0f b7 15 86 ae 11 00 	movzwl 0x11ae86,%edx
  1012ae:	83 c2 01             	add    $0x1,%edx
  1012b1:	0f b7 d2             	movzwl %dx,%edx
  1012b4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b8:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c3:	ee                   	out    %al,(%dx)
}
  1012c4:	83 c4 34             	add    $0x34,%esp
  1012c7:	5b                   	pop    %ebx
  1012c8:	5d                   	pop    %ebp
  1012c9:	c3                   	ret    

001012ca <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012ca:	55                   	push   %ebp
  1012cb:	89 e5                	mov    %esp,%ebp
  1012cd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d7:	eb 09                	jmp    1012e2 <serial_putc_sub+0x18>
        delay();
  1012d9:	e8 4f fb ff ff       	call   100e2d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012ec:	89 c2                	mov    %eax,%edx
  1012ee:	ec                   	in     (%dx),%al
  1012ef:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f6:	0f b6 c0             	movzbl %al,%eax
  1012f9:	83 e0 20             	and    $0x20,%eax
  1012fc:	85 c0                	test   %eax,%eax
  1012fe:	75 09                	jne    101309 <serial_putc_sub+0x3f>
  101300:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101307:	7e d0                	jle    1012d9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101309:	8b 45 08             	mov    0x8(%ebp),%eax
  10130c:	0f b6 c0             	movzbl %al,%eax
  10130f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101315:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101318:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10131c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101320:	ee                   	out    %al,(%dx)
}
  101321:	c9                   	leave  
  101322:	c3                   	ret    

00101323 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101323:	55                   	push   %ebp
  101324:	89 e5                	mov    %esp,%ebp
  101326:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101329:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10132d:	74 0d                	je     10133c <serial_putc+0x19>
        serial_putc_sub(c);
  10132f:	8b 45 08             	mov    0x8(%ebp),%eax
  101332:	89 04 24             	mov    %eax,(%esp)
  101335:	e8 90 ff ff ff       	call   1012ca <serial_putc_sub>
  10133a:	eb 24                	jmp    101360 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10133c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101343:	e8 82 ff ff ff       	call   1012ca <serial_putc_sub>
        serial_putc_sub(' ');
  101348:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134f:	e8 76 ff ff ff       	call   1012ca <serial_putc_sub>
        serial_putc_sub('\b');
  101354:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10135b:	e8 6a ff ff ff       	call   1012ca <serial_putc_sub>
    }
}
  101360:	c9                   	leave  
  101361:	c3                   	ret    

00101362 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101362:	55                   	push   %ebp
  101363:	89 e5                	mov    %esp,%ebp
  101365:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101368:	eb 33                	jmp    10139d <cons_intr+0x3b>
        if (c != 0) {
  10136a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136e:	74 2d                	je     10139d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101370:	a1 a4 b0 11 00       	mov    0x11b0a4,%eax
  101375:	8d 50 01             	lea    0x1(%eax),%edx
  101378:	89 15 a4 b0 11 00    	mov    %edx,0x11b0a4
  10137e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101381:	88 90 a0 ae 11 00    	mov    %dl,0x11aea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101387:	a1 a4 b0 11 00       	mov    0x11b0a4,%eax
  10138c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101391:	75 0a                	jne    10139d <cons_intr+0x3b>
                cons.wpos = 0;
  101393:	c7 05 a4 b0 11 00 00 	movl   $0x0,0x11b0a4
  10139a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10139d:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a0:	ff d0                	call   *%eax
  1013a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a9:	75 bf                	jne    10136a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013ab:	c9                   	leave  
  1013ac:	c3                   	ret    

001013ad <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ad:	55                   	push   %ebp
  1013ae:	89 e5                	mov    %esp,%ebp
  1013b0:	83 ec 10             	sub    $0x10,%esp
  1013b3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bd:	89 c2                	mov    %eax,%edx
  1013bf:	ec                   	in     (%dx),%al
  1013c0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	83 e0 01             	and    $0x1,%eax
  1013cd:	85 c0                	test   %eax,%eax
  1013cf:	75 07                	jne    1013d8 <serial_proc_data+0x2b>
        return -1;
  1013d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d6:	eb 2a                	jmp    101402 <serial_proc_data+0x55>
  1013d8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013de:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e2:	89 c2                	mov    %eax,%edx
  1013e4:	ec                   	in     (%dx),%al
  1013e5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ec:	0f b6 c0             	movzbl %al,%eax
  1013ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f6:	75 07                	jne    1013ff <serial_proc_data+0x52>
        c = '\b';
  1013f8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101402:	c9                   	leave  
  101403:	c3                   	ret    

00101404 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101404:	55                   	push   %ebp
  101405:	89 e5                	mov    %esp,%ebp
  101407:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10140a:	a1 88 ae 11 00       	mov    0x11ae88,%eax
  10140f:	85 c0                	test   %eax,%eax
  101411:	74 0c                	je     10141f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101413:	c7 04 24 ad 13 10 00 	movl   $0x1013ad,(%esp)
  10141a:	e8 43 ff ff ff       	call   101362 <cons_intr>
    }
}
  10141f:	c9                   	leave  
  101420:	c3                   	ret    

00101421 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101421:	55                   	push   %ebp
  101422:	89 e5                	mov    %esp,%ebp
  101424:	83 ec 38             	sub    $0x38,%esp
  101427:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10142d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101431:	89 c2                	mov    %eax,%edx
  101433:	ec                   	in     (%dx),%al
  101434:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101437:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10143b:	0f b6 c0             	movzbl %al,%eax
  10143e:	83 e0 01             	and    $0x1,%eax
  101441:	85 c0                	test   %eax,%eax
  101443:	75 0a                	jne    10144f <kbd_proc_data+0x2e>
        return -1;
  101445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10144a:	e9 59 01 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
  10144f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101455:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101459:	89 c2                	mov    %eax,%edx
  10145b:	ec                   	in     (%dx),%al
  10145c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101463:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101466:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10146a:	75 17                	jne    101483 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10146c:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101471:	83 c8 40             	or     $0x40,%eax
  101474:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8
        return 0;
  101479:	b8 00 00 00 00       	mov    $0x0,%eax
  10147e:	e9 25 01 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101483:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101487:	84 c0                	test   %al,%al
  101489:	79 47                	jns    1014d2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10148b:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101490:	83 e0 40             	and    $0x40,%eax
  101493:	85 c0                	test   %eax,%eax
  101495:	75 09                	jne    1014a0 <kbd_proc_data+0x7f>
  101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149b:	83 e0 7f             	and    $0x7f,%eax
  10149e:	eb 04                	jmp    1014a4 <kbd_proc_data+0x83>
  1014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	0f b6 80 60 a0 11 00 	movzbl 0x11a060(%eax),%eax
  1014b2:	83 c8 40             	or     $0x40,%eax
  1014b5:	0f b6 c0             	movzbl %al,%eax
  1014b8:	f7 d0                	not    %eax
  1014ba:	89 c2                	mov    %eax,%edx
  1014bc:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  1014c1:	21 d0                	and    %edx,%eax
  1014c3:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8
        return 0;
  1014c8:	b8 00 00 00 00       	mov    $0x0,%eax
  1014cd:	e9 d6 00 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014d2:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  1014d7:	83 e0 40             	and    $0x40,%eax
  1014da:	85 c0                	test   %eax,%eax
  1014dc:	74 11                	je     1014ef <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014de:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e2:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  1014e7:	83 e0 bf             	and    $0xffffffbf,%eax
  1014ea:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8
    }

    shift |= shiftcode[data];
  1014ef:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f3:	0f b6 80 60 a0 11 00 	movzbl 0x11a060(%eax),%eax
  1014fa:	0f b6 d0             	movzbl %al,%edx
  1014fd:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101502:	09 d0                	or     %edx,%eax
  101504:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8
    shift ^= togglecode[data];
  101509:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150d:	0f b6 80 60 a1 11 00 	movzbl 0x11a160(%eax),%eax
  101514:	0f b6 d0             	movzbl %al,%edx
  101517:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  10151c:	31 d0                	xor    %edx,%eax
  10151e:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101523:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101528:	83 e0 03             	and    $0x3,%eax
  10152b:	8b 14 85 60 a5 11 00 	mov    0x11a560(,%eax,4),%edx
  101532:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101536:	01 d0                	add    %edx,%eax
  101538:	0f b6 00             	movzbl (%eax),%eax
  10153b:	0f b6 c0             	movzbl %al,%eax
  10153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101541:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101546:	83 e0 08             	and    $0x8,%eax
  101549:	85 c0                	test   %eax,%eax
  10154b:	74 22                	je     10156f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10154d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101551:	7e 0c                	jle    10155f <kbd_proc_data+0x13e>
  101553:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101557:	7f 06                	jg     10155f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101559:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10155d:	eb 10                	jmp    10156f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101563:	7e 0a                	jle    10156f <kbd_proc_data+0x14e>
  101565:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101569:	7f 04                	jg     10156f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10156b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156f:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101574:	f7 d0                	not    %eax
  101576:	83 e0 06             	and    $0x6,%eax
  101579:	85 c0                	test   %eax,%eax
  10157b:	75 28                	jne    1015a5 <kbd_proc_data+0x184>
  10157d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101584:	75 1f                	jne    1015a5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101586:	c7 04 24 dd 76 10 00 	movl   $0x1076dd,(%esp)
  10158d:	e8 b5 ed ff ff       	call   100347 <cprintf>
  101592:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101598:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10159c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015a4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a8:	c9                   	leave  
  1015a9:	c3                   	ret    

001015aa <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015aa:	55                   	push   %ebp
  1015ab:	89 e5                	mov    %esp,%ebp
  1015ad:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b0:	c7 04 24 21 14 10 00 	movl   $0x101421,(%esp)
  1015b7:	e8 a6 fd ff ff       	call   101362 <cons_intr>
}
  1015bc:	c9                   	leave  
  1015bd:	c3                   	ret    

001015be <kbd_init>:

static void
kbd_init(void) {
  1015be:	55                   	push   %ebp
  1015bf:	89 e5                	mov    %esp,%ebp
  1015c1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015c4:	e8 e1 ff ff ff       	call   1015aa <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015d0:	e8 3d 01 00 00       	call   101712 <pic_enable>
}
  1015d5:	c9                   	leave  
  1015d6:	c3                   	ret    

001015d7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d7:	55                   	push   %ebp
  1015d8:	89 e5                	mov    %esp,%ebp
  1015da:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015dd:	e8 93 f8 ff ff       	call   100e75 <cga_init>
    serial_init();
  1015e2:	e8 74 f9 ff ff       	call   100f5b <serial_init>
    kbd_init();
  1015e7:	e8 d2 ff ff ff       	call   1015be <kbd_init>
    if (!serial_exists) {
  1015ec:	a1 88 ae 11 00       	mov    0x11ae88,%eax
  1015f1:	85 c0                	test   %eax,%eax
  1015f3:	75 0c                	jne    101601 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f5:	c7 04 24 e9 76 10 00 	movl   $0x1076e9,(%esp)
  1015fc:	e8 46 ed ff ff       	call   100347 <cprintf>
    }
}
  101601:	c9                   	leave  
  101602:	c3                   	ret    

00101603 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101603:	55                   	push   %ebp
  101604:	89 e5                	mov    %esp,%ebp
  101606:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101609:	e8 e2 f7 ff ff       	call   100df0 <__intr_save>
  10160e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 9b fa ff ff       	call   1010b7 <lpt_putc>
        cga_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 cf fa ff ff       	call   1010f6 <cga_putc>
        serial_putc(c);
  101627:	8b 45 08             	mov    0x8(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 f1 fc ff ff       	call   101323 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101635:	89 04 24             	mov    %eax,(%esp)
  101638:	e8 dd f7 ff ff       	call   100e1a <__intr_restore>
}
  10163d:	c9                   	leave  
  10163e:	c3                   	ret    

0010163f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163f:	55                   	push   %ebp
  101640:	89 e5                	mov    %esp,%ebp
  101642:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10164c:	e8 9f f7 ff ff       	call   100df0 <__intr_save>
  101651:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101654:	e8 ab fd ff ff       	call   101404 <serial_intr>
        kbd_intr();
  101659:	e8 4c ff ff ff       	call   1015aa <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165e:	8b 15 a0 b0 11 00    	mov    0x11b0a0,%edx
  101664:	a1 a4 b0 11 00       	mov    0x11b0a4,%eax
  101669:	39 c2                	cmp    %eax,%edx
  10166b:	74 31                	je     10169e <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10166d:	a1 a0 b0 11 00       	mov    0x11b0a0,%eax
  101672:	8d 50 01             	lea    0x1(%eax),%edx
  101675:	89 15 a0 b0 11 00    	mov    %edx,0x11b0a0
  10167b:	0f b6 80 a0 ae 11 00 	movzbl 0x11aea0(%eax),%eax
  101682:	0f b6 c0             	movzbl %al,%eax
  101685:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101688:	a1 a0 b0 11 00       	mov    0x11b0a0,%eax
  10168d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101692:	75 0a                	jne    10169e <cons_getc+0x5f>
                cons.rpos = 0;
  101694:	c7 05 a0 b0 11 00 00 	movl   $0x0,0x11b0a0
  10169b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016a1:	89 04 24             	mov    %eax,(%esp)
  1016a4:	e8 71 f7 ff ff       	call   100e1a <__intr_restore>
    return c;
  1016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016ac:	c9                   	leave  
  1016ad:	c3                   	ret    

001016ae <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ae:	55                   	push   %ebp
  1016af:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016b1:	fb                   	sti    
    sti();
}
  1016b2:	5d                   	pop    %ebp
  1016b3:	c3                   	ret    

001016b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b4:	55                   	push   %ebp
  1016b5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b7:	fa                   	cli    
    cli();
}
  1016b8:	5d                   	pop    %ebp
  1016b9:	c3                   	ret    

001016ba <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
  1016bd:	83 ec 14             	sub    $0x14,%esp
  1016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016cb:	66 a3 70 a5 11 00    	mov    %ax,0x11a570
    if (did_init) {
  1016d1:	a1 ac b0 11 00       	mov    0x11b0ac,%eax
  1016d6:	85 c0                	test   %eax,%eax
  1016d8:	74 36                	je     101710 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016da:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016de:	0f b6 c0             	movzbl %al,%eax
  1016e1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e7:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016ea:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ee:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016f2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f7:	66 c1 e8 08          	shr    $0x8,%ax
  1016fb:	0f b6 c0             	movzbl %al,%eax
  1016fe:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101704:	88 45 f9             	mov    %al,-0x7(%ebp)
  101707:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10170b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
    }
}
  101710:	c9                   	leave  
  101711:	c3                   	ret    

00101712 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101712:	55                   	push   %ebp
  101713:	89 e5                	mov    %esp,%ebp
  101715:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101718:	8b 45 08             	mov    0x8(%ebp),%eax
  10171b:	ba 01 00 00 00       	mov    $0x1,%edx
  101720:	89 c1                	mov    %eax,%ecx
  101722:	d3 e2                	shl    %cl,%edx
  101724:	89 d0                	mov    %edx,%eax
  101726:	f7 d0                	not    %eax
  101728:	89 c2                	mov    %eax,%edx
  10172a:	0f b7 05 70 a5 11 00 	movzwl 0x11a570,%eax
  101731:	21 d0                	and    %edx,%eax
  101733:	0f b7 c0             	movzwl %ax,%eax
  101736:	89 04 24             	mov    %eax,(%esp)
  101739:	e8 7c ff ff ff       	call   1016ba <pic_setmask>
}
  10173e:	c9                   	leave  
  10173f:	c3                   	ret    

00101740 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101740:	55                   	push   %ebp
  101741:	89 e5                	mov    %esp,%ebp
  101743:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101746:	c7 05 ac b0 11 00 01 	movl   $0x1,0x11b0ac
  10174d:	00 00 00 
  101750:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101756:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10175a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
  101763:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101769:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10176d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101771:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101775:	ee                   	out    %al,(%dx)
  101776:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10177c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101780:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101784:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
  101789:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101793:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101797:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10179b:	ee                   	out    %al,(%dx)
  10179c:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017a2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ae:	ee                   	out    %al,(%dx)
  1017af:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017bd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017c1:	ee                   	out    %al,(%dx)
  1017c2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017cc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017d0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d4:	ee                   	out    %al,(%dx)
  1017d5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017db:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017df:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e7:	ee                   	out    %al,(%dx)
  1017e8:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ee:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017f2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017fa:	ee                   	out    %al,(%dx)
  1017fb:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101801:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101805:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101809:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10180d:	ee                   	out    %al,(%dx)
  10180e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101814:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101818:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10181c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101820:	ee                   	out    %al,(%dx)
  101821:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101827:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10182b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101833:	ee                   	out    %al,(%dx)
  101834:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10183a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10183e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101842:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101846:	ee                   	out    %al,(%dx)
  101847:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10184d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101851:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101855:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101859:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10185a:	0f b7 05 70 a5 11 00 	movzwl 0x11a570,%eax
  101861:	66 83 f8 ff          	cmp    $0xffff,%ax
  101865:	74 12                	je     101879 <pic_init+0x139>
        pic_setmask(irq_mask);
  101867:	0f b7 05 70 a5 11 00 	movzwl 0x11a570,%eax
  10186e:	0f b7 c0             	movzwl %ax,%eax
  101871:	89 04 24             	mov    %eax,(%esp)
  101874:	e8 41 fe ff ff       	call   1016ba <pic_setmask>
    }
}
  101879:	c9                   	leave  
  10187a:	c3                   	ret    

0010187b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10187b:	55                   	push   %ebp
  10187c:	89 e5                	mov    %esp,%ebp
  10187e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101881:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101888:	00 
  101889:	c7 04 24 20 77 10 00 	movl   $0x107720,(%esp)
  101890:	e8 b2 ea ff ff       	call   100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101895:	c7 04 24 2a 77 10 00 	movl   $0x10772a,(%esp)
  10189c:	e8 a6 ea ff ff       	call   100347 <cprintf>
    panic("EOT: kernel seems ok.");
  1018a1:	c7 44 24 08 38 77 10 	movl   $0x107738,0x8(%esp)
  1018a8:	00 
  1018a9:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018b0:	00 
  1018b1:	c7 04 24 4e 77 10 00 	movl   $0x10774e,(%esp)
  1018b8:	e8 14 f4 ff ff       	call   100cd1 <__panic>

001018bd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018bd:	55                   	push   %ebp
  1018be:	89 e5                	mov    %esp,%ebp
  1018c0:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
		extern uintptr_t __vectors[];
		int i;
		for(i=0;i<256;i++)
  1018c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018ca:	e9 c3 00 00 00       	jmp    101992 <idt_init+0xd5>
		{
			SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
  1018cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d2:	8b 04 85 00 a6 11 00 	mov    0x11a600(,%eax,4),%eax
  1018d9:	89 c2                	mov    %eax,%edx
  1018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018de:	66 89 14 c5 c0 b0 11 	mov    %dx,0x11b0c0(,%eax,8)
  1018e5:	00 
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	66 c7 04 c5 c2 b0 11 	movw   $0x8,0x11b0c2(,%eax,8)
  1018f0:	00 08 00 
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	0f b6 14 c5 c4 b0 11 	movzbl 0x11b0c4(,%eax,8),%edx
  1018fd:	00 
  1018fe:	83 e2 e0             	and    $0xffffffe0,%edx
  101901:	88 14 c5 c4 b0 11 00 	mov    %dl,0x11b0c4(,%eax,8)
  101908:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190b:	0f b6 14 c5 c4 b0 11 	movzbl 0x11b0c4(,%eax,8),%edx
  101912:	00 
  101913:	83 e2 1f             	and    $0x1f,%edx
  101916:	88 14 c5 c4 b0 11 00 	mov    %dl,0x11b0c4(,%eax,8)
  10191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101920:	0f b6 14 c5 c5 b0 11 	movzbl 0x11b0c5(,%eax,8),%edx
  101927:	00 
  101928:	83 e2 f0             	and    $0xfffffff0,%edx
  10192b:	83 ca 0e             	or     $0xe,%edx
  10192e:	88 14 c5 c5 b0 11 00 	mov    %dl,0x11b0c5(,%eax,8)
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	0f b6 14 c5 c5 b0 11 	movzbl 0x11b0c5(,%eax,8),%edx
  10193f:	00 
  101940:	83 e2 ef             	and    $0xffffffef,%edx
  101943:	88 14 c5 c5 b0 11 00 	mov    %dl,0x11b0c5(,%eax,8)
  10194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194d:	0f b6 14 c5 c5 b0 11 	movzbl 0x11b0c5(,%eax,8),%edx
  101954:	00 
  101955:	83 e2 9f             	and    $0xffffff9f,%edx
  101958:	88 14 c5 c5 b0 11 00 	mov    %dl,0x11b0c5(,%eax,8)
  10195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101962:	0f b6 14 c5 c5 b0 11 	movzbl 0x11b0c5(,%eax,8),%edx
  101969:	00 
  10196a:	83 ca 80             	or     $0xffffff80,%edx
  10196d:	88 14 c5 c5 b0 11 00 	mov    %dl,0x11b0c5(,%eax,8)
  101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101977:	8b 04 85 00 a6 11 00 	mov    0x11a600(,%eax,4),%eax
  10197e:	c1 e8 10             	shr    $0x10,%eax
  101981:	89 c2                	mov    %eax,%edx
  101983:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101986:	66 89 14 c5 c6 b0 11 	mov    %dx,0x11b0c6(,%eax,8)
  10198d:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
		extern uintptr_t __vectors[];
		int i;
		for(i=0;i<256;i++)
  10198e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101992:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101999:	0f 8e 30 ff ff ff    	jle    1018cf <idt_init+0x12>
		{
			SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
		}
		SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],3);
  10199f:	a1 e4 a7 11 00       	mov    0x11a7e4,%eax
  1019a4:	66 a3 88 b4 11 00    	mov    %ax,0x11b488
  1019aa:	66 c7 05 8a b4 11 00 	movw   $0x8,0x11b48a
  1019b1:	08 00 
  1019b3:	0f b6 05 8c b4 11 00 	movzbl 0x11b48c,%eax
  1019ba:	83 e0 e0             	and    $0xffffffe0,%eax
  1019bd:	a2 8c b4 11 00       	mov    %al,0x11b48c
  1019c2:	0f b6 05 8c b4 11 00 	movzbl 0x11b48c,%eax
  1019c9:	83 e0 1f             	and    $0x1f,%eax
  1019cc:	a2 8c b4 11 00       	mov    %al,0x11b48c
  1019d1:	0f b6 05 8d b4 11 00 	movzbl 0x11b48d,%eax
  1019d8:	83 e0 f0             	and    $0xfffffff0,%eax
  1019db:	83 c8 0e             	or     $0xe,%eax
  1019de:	a2 8d b4 11 00       	mov    %al,0x11b48d
  1019e3:	0f b6 05 8d b4 11 00 	movzbl 0x11b48d,%eax
  1019ea:	83 e0 ef             	and    $0xffffffef,%eax
  1019ed:	a2 8d b4 11 00       	mov    %al,0x11b48d
  1019f2:	0f b6 05 8d b4 11 00 	movzbl 0x11b48d,%eax
  1019f9:	83 c8 60             	or     $0x60,%eax
  1019fc:	a2 8d b4 11 00       	mov    %al,0x11b48d
  101a01:	0f b6 05 8d b4 11 00 	movzbl 0x11b48d,%eax
  101a08:	83 c8 80             	or     $0xffffff80,%eax
  101a0b:	a2 8d b4 11 00       	mov    %al,0x11b48d
  101a10:	a1 e4 a7 11 00       	mov    0x11a7e4,%eax
  101a15:	c1 e8 10             	shr    $0x10,%eax
  101a18:	66 a3 8e b4 11 00    	mov    %ax,0x11b48e
  101a1e:	c7 45 f8 80 a5 11 00 	movl   $0x11a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a28:	0f 01 18             	lidtl  (%eax)
		lidt(&idt_pd);
}
  101a2b:	c9                   	leave  
  101a2c:	c3                   	ret    

00101a2d <trapname>:

static const char *
trapname(int trapno) {
  101a2d:	55                   	push   %ebp
  101a2e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a30:	8b 45 08             	mov    0x8(%ebp),%eax
  101a33:	83 f8 13             	cmp    $0x13,%eax
  101a36:	77 0c                	ja     101a44 <trapname+0x17>
        return excnames[trapno];
  101a38:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3b:	8b 04 85 a0 7a 10 00 	mov    0x107aa0(,%eax,4),%eax
  101a42:	eb 18                	jmp    101a5c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a44:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a48:	7e 0d                	jle    101a57 <trapname+0x2a>
  101a4a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a4e:	7f 07                	jg     101a57 <trapname+0x2a>
        return "Hardware Interrupt";
  101a50:	b8 5f 77 10 00       	mov    $0x10775f,%eax
  101a55:	eb 05                	jmp    101a5c <trapname+0x2f>
    }
    return "(unknown trap)";
  101a57:	b8 72 77 10 00       	mov    $0x107772,%eax
}
  101a5c:	5d                   	pop    %ebp
  101a5d:	c3                   	ret    

00101a5e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a5e:	55                   	push   %ebp
  101a5f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a61:	8b 45 08             	mov    0x8(%ebp),%eax
  101a64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a68:	66 83 f8 08          	cmp    $0x8,%ax
  101a6c:	0f 94 c0             	sete   %al
  101a6f:	0f b6 c0             	movzbl %al,%eax
}
  101a72:	5d                   	pop    %ebp
  101a73:	c3                   	ret    

00101a74 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a74:	55                   	push   %ebp
  101a75:	89 e5                	mov    %esp,%ebp
  101a77:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a81:	c7 04 24 b3 77 10 00 	movl   $0x1077b3,(%esp)
  101a88:	e8 ba e8 ff ff       	call   100347 <cprintf>
    print_regs(&tf->tf_regs);
  101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a90:	89 04 24             	mov    %eax,(%esp)
  101a93:	e8 a1 01 00 00       	call   101c39 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a98:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a9f:	0f b7 c0             	movzwl %ax,%eax
  101aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa6:	c7 04 24 c4 77 10 00 	movl   $0x1077c4,(%esp)
  101aad:	e8 95 e8 ff ff       	call   100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ab9:	0f b7 c0             	movzwl %ax,%eax
  101abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac0:	c7 04 24 d7 77 10 00 	movl   $0x1077d7,(%esp)
  101ac7:	e8 7b e8 ff ff       	call   100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101acc:	8b 45 08             	mov    0x8(%ebp),%eax
  101acf:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ad3:	0f b7 c0             	movzwl %ax,%eax
  101ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ada:	c7 04 24 ea 77 10 00 	movl   $0x1077ea,(%esp)
  101ae1:	e8 61 e8 ff ff       	call   100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101aed:	0f b7 c0             	movzwl %ax,%eax
  101af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af4:	c7 04 24 fd 77 10 00 	movl   $0x1077fd,(%esp)
  101afb:	e8 47 e8 ff ff       	call   100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b00:	8b 45 08             	mov    0x8(%ebp),%eax
  101b03:	8b 40 30             	mov    0x30(%eax),%eax
  101b06:	89 04 24             	mov    %eax,(%esp)
  101b09:	e8 1f ff ff ff       	call   101a2d <trapname>
  101b0e:	8b 55 08             	mov    0x8(%ebp),%edx
  101b11:	8b 52 30             	mov    0x30(%edx),%edx
  101b14:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b18:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b1c:	c7 04 24 10 78 10 00 	movl   $0x107810,(%esp)
  101b23:	e8 1f e8 ff ff       	call   100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b28:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2b:	8b 40 34             	mov    0x34(%eax),%eax
  101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b32:	c7 04 24 22 78 10 00 	movl   $0x107822,(%esp)
  101b39:	e8 09 e8 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	8b 40 38             	mov    0x38(%eax),%eax
  101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b48:	c7 04 24 31 78 10 00 	movl   $0x107831,(%esp)
  101b4f:	e8 f3 e7 ff ff       	call   100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b54:	8b 45 08             	mov    0x8(%ebp),%eax
  101b57:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b5b:	0f b7 c0             	movzwl %ax,%eax
  101b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b62:	c7 04 24 40 78 10 00 	movl   $0x107840,(%esp)
  101b69:	e8 d9 e7 ff ff       	call   100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b71:	8b 40 40             	mov    0x40(%eax),%eax
  101b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b78:	c7 04 24 53 78 10 00 	movl   $0x107853,(%esp)
  101b7f:	e8 c3 e7 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b8b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b92:	eb 3e                	jmp    101bd2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b94:	8b 45 08             	mov    0x8(%ebp),%eax
  101b97:	8b 50 40             	mov    0x40(%eax),%edx
  101b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b9d:	21 d0                	and    %edx,%eax
  101b9f:	85 c0                	test   %eax,%eax
  101ba1:	74 28                	je     101bcb <print_trapframe+0x157>
  101ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba6:	8b 04 85 a0 a5 11 00 	mov    0x11a5a0(,%eax,4),%eax
  101bad:	85 c0                	test   %eax,%eax
  101baf:	74 1a                	je     101bcb <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb4:	8b 04 85 a0 a5 11 00 	mov    0x11a5a0(,%eax,4),%eax
  101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbf:	c7 04 24 62 78 10 00 	movl   $0x107862,(%esp)
  101bc6:	e8 7c e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bcf:	d1 65 f0             	shll   -0x10(%ebp)
  101bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd5:	83 f8 17             	cmp    $0x17,%eax
  101bd8:	76 ba                	jbe    101b94 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bda:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdd:	8b 40 40             	mov    0x40(%eax),%eax
  101be0:	25 00 30 00 00       	and    $0x3000,%eax
  101be5:	c1 e8 0c             	shr    $0xc,%eax
  101be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bec:	c7 04 24 66 78 10 00 	movl   $0x107866,(%esp)
  101bf3:	e8 4f e7 ff ff       	call   100347 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	89 04 24             	mov    %eax,(%esp)
  101bfe:	e8 5b fe ff ff       	call   101a5e <trap_in_kernel>
  101c03:	85 c0                	test   %eax,%eax
  101c05:	75 30                	jne    101c37 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c07:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0a:	8b 40 44             	mov    0x44(%eax),%eax
  101c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c11:	c7 04 24 6f 78 10 00 	movl   $0x10786f,(%esp)
  101c18:	e8 2a e7 ff ff       	call   100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c20:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c24:	0f b7 c0             	movzwl %ax,%eax
  101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2b:	c7 04 24 7e 78 10 00 	movl   $0x10787e,(%esp)
  101c32:	e8 10 e7 ff ff       	call   100347 <cprintf>
    }
}
  101c37:	c9                   	leave  
  101c38:	c3                   	ret    

00101c39 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c39:	55                   	push   %ebp
  101c3a:	89 e5                	mov    %esp,%ebp
  101c3c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c42:	8b 00                	mov    (%eax),%eax
  101c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c48:	c7 04 24 91 78 10 00 	movl   $0x107891,(%esp)
  101c4f:	e8 f3 e6 ff ff       	call   100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c54:	8b 45 08             	mov    0x8(%ebp),%eax
  101c57:	8b 40 04             	mov    0x4(%eax),%eax
  101c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5e:	c7 04 24 a0 78 10 00 	movl   $0x1078a0,(%esp)
  101c65:	e8 dd e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6d:	8b 40 08             	mov    0x8(%eax),%eax
  101c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c74:	c7 04 24 af 78 10 00 	movl   $0x1078af,(%esp)
  101c7b:	e8 c7 e6 ff ff       	call   100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c80:	8b 45 08             	mov    0x8(%ebp),%eax
  101c83:	8b 40 0c             	mov    0xc(%eax),%eax
  101c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8a:	c7 04 24 be 78 10 00 	movl   $0x1078be,(%esp)
  101c91:	e8 b1 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c96:	8b 45 08             	mov    0x8(%ebp),%eax
  101c99:	8b 40 10             	mov    0x10(%eax),%eax
  101c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca0:	c7 04 24 cd 78 10 00 	movl   $0x1078cd,(%esp)
  101ca7:	e8 9b e6 ff ff       	call   100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cac:	8b 45 08             	mov    0x8(%ebp),%eax
  101caf:	8b 40 14             	mov    0x14(%eax),%eax
  101cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb6:	c7 04 24 dc 78 10 00 	movl   $0x1078dc,(%esp)
  101cbd:	e8 85 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc5:	8b 40 18             	mov    0x18(%eax),%eax
  101cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccc:	c7 04 24 eb 78 10 00 	movl   $0x1078eb,(%esp)
  101cd3:	e8 6f e6 ff ff       	call   100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdb:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce2:	c7 04 24 fa 78 10 00 	movl   $0x1078fa,(%esp)
  101ce9:	e8 59 e6 ff ff       	call   100347 <cprintf>
}
  101cee:	c9                   	leave  
  101cef:	c3                   	ret    

00101cf0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cf0:	55                   	push   %ebp
  101cf1:	89 e5                	mov    %esp,%ebp
  101cf3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf9:	8b 40 30             	mov    0x30(%eax),%eax
  101cfc:	83 f8 2f             	cmp    $0x2f,%eax
  101cff:	77 21                	ja     101d22 <trap_dispatch+0x32>
  101d01:	83 f8 2e             	cmp    $0x2e,%eax
  101d04:	0f 83 46 02 00 00    	jae    101f50 <trap_dispatch+0x260>
  101d0a:	83 f8 21             	cmp    $0x21,%eax
  101d0d:	0f 84 8a 00 00 00    	je     101d9d <trap_dispatch+0xad>
  101d13:	83 f8 24             	cmp    $0x24,%eax
  101d16:	74 5c                	je     101d74 <trap_dispatch+0x84>
  101d18:	83 f8 20             	cmp    $0x20,%eax
  101d1b:	74 1c                	je     101d39 <trap_dispatch+0x49>
  101d1d:	e9 f6 01 00 00       	jmp    101f18 <trap_dispatch+0x228>
  101d22:	83 f8 78             	cmp    $0x78,%eax
  101d25:	0f 84 3d 01 00 00    	je     101e68 <trap_dispatch+0x178>
  101d2b:	83 f8 79             	cmp    $0x79,%eax
  101d2e:	0f 84 85 01 00 00    	je     101eb9 <trap_dispatch+0x1c9>
  101d34:	e9 df 01 00 00       	jmp    101f18 <trap_dispatch+0x228>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    		ticks++;
  101d39:	a1 2c ba 11 00       	mov    0x11ba2c,%eax
  101d3e:	83 c0 01             	add    $0x1,%eax
  101d41:	a3 2c ba 11 00       	mov    %eax,0x11ba2c
        	if(ticks%TICK_NUM==0)
  101d46:	8b 0d 2c ba 11 00    	mov    0x11ba2c,%ecx
  101d4c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d51:	89 c8                	mov    %ecx,%eax
  101d53:	f7 e2                	mul    %edx
  101d55:	89 d0                	mov    %edx,%eax
  101d57:	c1 e8 05             	shr    $0x5,%eax
  101d5a:	6b c0 64             	imul   $0x64,%eax,%eax
  101d5d:	29 c1                	sub    %eax,%ecx
  101d5f:	89 c8                	mov    %ecx,%eax
  101d61:	85 c0                	test   %eax,%eax
  101d63:	75 0a                	jne    101d6f <trap_dispatch+0x7f>
        		print_ticks();
  101d65:	e8 11 fb ff ff       	call   10187b <print_ticks>
        	break;
  101d6a:	e9 e2 01 00 00       	jmp    101f51 <trap_dispatch+0x261>
  101d6f:	e9 dd 01 00 00       	jmp    101f51 <trap_dispatch+0x261>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d74:	e8 c6 f8 ff ff       	call   10163f <cons_getc>
  101d79:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d7c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d80:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d84:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8c:	c7 04 24 09 79 10 00 	movl   $0x107909,(%esp)
  101d93:	e8 af e5 ff ff       	call   100347 <cprintf>
        break;
  101d98:	e9 b4 01 00 00       	jmp    101f51 <trap_dispatch+0x261>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d9d:	e8 9d f8 ff ff       	call   10163f <cons_getc>
  101da2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101da5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dad:	89 54 24 08          	mov    %edx,0x8(%esp)
  101db1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db5:	c7 04 24 1b 79 10 00 	movl   $0x10791b,(%esp)
  101dbc:	e8 86 e5 ff ff       	call   100347 <cprintf>
        if(c=='0')
  101dc1:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101dc5:	75 44                	jne    101e0b <trap_dispatch+0x11b>
               {
               	if(tf->tf_cs!=KERNEL_CS)
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dce:	66 83 f8 08          	cmp    $0x8,%ax
  101dd2:	74 2c                	je     101e00 <trap_dispatch+0x110>
               	    	{
               	    		tf->tf_cs=KERNEL_CS;
  101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd7:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
               	    		tf->tf_ds=KERNEL_DS;
  101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  101de0:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
               	    		tf->tf_es=KERNEL_DS;
  101de6:	8b 45 08             	mov    0x8(%ebp),%eax
  101de9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
               	    		tf->tf_eflags &=~FL_IOPL_MASK;
  101def:	8b 45 08             	mov    0x8(%ebp),%eax
  101df2:	8b 40 40             	mov    0x40(%eax),%eax
  101df5:	80 e4 cf             	and    $0xcf,%ah
  101df8:	89 c2                	mov    %eax,%edx
  101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfd:	89 50 40             	mov    %edx,0x40(%eax)
               	    	}
               	print_trapframe(tf);
  101e00:	8b 45 08             	mov    0x8(%ebp),%eax
  101e03:	89 04 24             	mov    %eax,(%esp)
  101e06:	e8 69 fc ff ff       	call   101a74 <print_trapframe>
               }
               if(c=='3')
  101e0b:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101e0f:	75 52                	jne    101e63 <trap_dispatch+0x173>
               {
               	if(tf->tf_cs!=USER_CS)
  101e11:	8b 45 08             	mov    0x8(%ebp),%eax
  101e14:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e18:	66 83 f8 1b          	cmp    $0x1b,%ax
  101e1c:	74 35                	je     101e53 <trap_dispatch+0x163>
               	    	{
               	    		tf->tf_cs=USER_CS;
  101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e21:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
               	    		tf->tf_ds=USER_DS;
  101e27:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2a:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
               	    		tf->tf_es=USER_DS;
  101e30:	8b 45 08             	mov    0x8(%ebp),%eax
  101e33:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
               	    		tf->tf_ss=USER_DS;
  101e39:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3c:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
               	    		tf->tf_eflags|=FL_IOPL_MASK;
  101e42:	8b 45 08             	mov    0x8(%ebp),%eax
  101e45:	8b 40 40             	mov    0x40(%eax),%eax
  101e48:	80 cc 30             	or     $0x30,%ah
  101e4b:	89 c2                	mov    %eax,%edx
  101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e50:	89 50 40             	mov    %edx,0x40(%eax)
               	    	}
               	print_trapframe(tf);
  101e53:	8b 45 08             	mov    0x8(%ebp),%eax
  101e56:	89 04 24             	mov    %eax,(%esp)
  101e59:	e8 16 fc ff ff       	call   101a74 <print_trapframe>
               }

        break;
  101e5e:	e9 ee 00 00 00       	jmp    101f51 <trap_dispatch+0x261>
  101e63:	e9 e9 00 00 00       	jmp    101f51 <trap_dispatch+0x261>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    			tf->tf_cs=USER_CS;
  101e68:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    	    	tf->tf_ds=USER_DS;
  101e71:	8b 45 08             	mov    0x8(%ebp),%eax
  101e74:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
    	    	tf->tf_es=USER_DS;
  101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7d:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
    	    	tf->tf_ss=USER_DS;
  101e83:	8b 45 08             	mov    0x8(%ebp),%eax
  101e86:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
    	    	tf->tf_esp=(uint32_t)tf+sizeof(struct trapframe)-8;
  101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8f:	8d 50 44             	lea    0x44(%eax),%edx
  101e92:	8b 45 08             	mov    0x8(%ebp),%eax
  101e95:	89 50 44             	mov    %edx,0x44(%eax)
    	    	tf->tf_eflags|=FL_IOPL_MASK;
  101e98:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9b:	8b 40 40             	mov    0x40(%eax),%eax
  101e9e:	80 cc 30             	or     $0x30,%ah
  101ea1:	89 c2                	mov    %eax,%edx
  101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea6:	89 50 40             	mov    %edx,0x40(%eax)
    	    	*((uint32_t*)tf-1)=(uint32_t)tf;
  101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  101eac:	8d 50 fc             	lea    -0x4(%eax),%edx
  101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb2:	89 02                	mov    %eax,(%edx)
    	    	break;
  101eb4:	e9 98 00 00 00       	jmp    101f51 <trap_dispatch+0x261>
    case T_SWITCH_TOK:
    			tf->tf_cs=KERNEL_CS;
  101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebc:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
    	    	tf->tf_ds=KERNEL_DS;
  101ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec5:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
    	    	tf->tf_es=KERNEL_DS;
  101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ece:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
    	    	tf->tf_eflags &=~FL_IOPL_MASK;
  101ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed7:	8b 40 40             	mov    0x40(%eax),%eax
  101eda:	80 e4 cf             	and    $0xcf,%ah
  101edd:	89 c2                	mov    %eax,%edx
  101edf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee2:	89 50 40             	mov    %edx,0x40(%eax)
    	    	struct trapframe* switchu2k=(struct trapframe*)(tf->tf_esp-(sizeof(struct trapframe)-8));
  101ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee8:	8b 40 44             	mov    0x44(%eax),%eax
  101eeb:	83 e8 44             	sub    $0x44,%eax
  101eee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	    	memmove(switchu2k,tf,sizeof(struct trapframe)-8);
  101ef1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ef8:	00 
  101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  101efc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101f03:	89 04 24             	mov    %eax,(%esp)
  101f06:	e8 54 53 00 00       	call   10725f <memmove>
    	    	*((uint32_t*)tf-1)=(uint32_t)switchu2k;
  101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0e:	8d 50 fc             	lea    -0x4(%eax),%edx
  101f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101f14:	89 02                	mov    %eax,(%edx)
    	        break;
  101f16:	eb 39                	jmp    101f51 <trap_dispatch+0x261>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f18:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f1f:	0f b7 c0             	movzwl %ax,%eax
  101f22:	83 e0 03             	and    $0x3,%eax
  101f25:	85 c0                	test   %eax,%eax
  101f27:	75 28                	jne    101f51 <trap_dispatch+0x261>
            print_trapframe(tf);
  101f29:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2c:	89 04 24             	mov    %eax,(%esp)
  101f2f:	e8 40 fb ff ff       	call   101a74 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f34:	c7 44 24 08 2a 79 10 	movl   $0x10792a,0x8(%esp)
  101f3b:	00 
  101f3c:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  101f43:	00 
  101f44:	c7 04 24 4e 77 10 00 	movl   $0x10774e,(%esp)
  101f4b:	e8 81 ed ff ff       	call   100cd1 <__panic>
    	    	*((uint32_t*)tf-1)=(uint32_t)switchu2k;
    	        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101f50:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101f51:	c9                   	leave  
  101f52:	c3                   	ret    

00101f53 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f53:	55                   	push   %ebp
  101f54:	89 e5                	mov    %esp,%ebp
  101f56:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f59:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5c:	89 04 24             	mov    %eax,(%esp)
  101f5f:	e8 8c fd ff ff       	call   101cf0 <trap_dispatch>
}
  101f64:	c9                   	leave  
  101f65:	c3                   	ret    

00101f66 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f66:	1e                   	push   %ds
    pushl %es
  101f67:	06                   	push   %es
    pushl %fs
  101f68:	0f a0                	push   %fs
    pushl %gs
  101f6a:	0f a8                	push   %gs
    pushal
  101f6c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f6d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f72:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f74:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f76:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f77:	e8 d7 ff ff ff       	call   101f53 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f7c:	5c                   	pop    %esp

00101f7d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f7d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f7e:	0f a9                	pop    %gs
    popl %fs
  101f80:	0f a1                	pop    %fs
    popl %es
  101f82:	07                   	pop    %es
    popl %ds
  101f83:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f84:	83 c4 08             	add    $0x8,%esp
    iret
  101f87:	cf                   	iret   

00101f88 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $0
  101f8a:	6a 00                	push   $0x0
  jmp __alltraps
  101f8c:	e9 d5 ff ff ff       	jmp    101f66 <__alltraps>

00101f91 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $1
  101f93:	6a 01                	push   $0x1
  jmp __alltraps
  101f95:	e9 cc ff ff ff       	jmp    101f66 <__alltraps>

00101f9a <vector2>:
.globl vector2
vector2:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $2
  101f9c:	6a 02                	push   $0x2
  jmp __alltraps
  101f9e:	e9 c3 ff ff ff       	jmp    101f66 <__alltraps>

00101fa3 <vector3>:
.globl vector3
vector3:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $3
  101fa5:	6a 03                	push   $0x3
  jmp __alltraps
  101fa7:	e9 ba ff ff ff       	jmp    101f66 <__alltraps>

00101fac <vector4>:
.globl vector4
vector4:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $4
  101fae:	6a 04                	push   $0x4
  jmp __alltraps
  101fb0:	e9 b1 ff ff ff       	jmp    101f66 <__alltraps>

00101fb5 <vector5>:
.globl vector5
vector5:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $5
  101fb7:	6a 05                	push   $0x5
  jmp __alltraps
  101fb9:	e9 a8 ff ff ff       	jmp    101f66 <__alltraps>

00101fbe <vector6>:
.globl vector6
vector6:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $6
  101fc0:	6a 06                	push   $0x6
  jmp __alltraps
  101fc2:	e9 9f ff ff ff       	jmp    101f66 <__alltraps>

00101fc7 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $7
  101fc9:	6a 07                	push   $0x7
  jmp __alltraps
  101fcb:	e9 96 ff ff ff       	jmp    101f66 <__alltraps>

00101fd0 <vector8>:
.globl vector8
vector8:
  pushl $8
  101fd0:	6a 08                	push   $0x8
  jmp __alltraps
  101fd2:	e9 8f ff ff ff       	jmp    101f66 <__alltraps>

00101fd7 <vector9>:
.globl vector9
vector9:
  pushl $9
  101fd7:	6a 09                	push   $0x9
  jmp __alltraps
  101fd9:	e9 88 ff ff ff       	jmp    101f66 <__alltraps>

00101fde <vector10>:
.globl vector10
vector10:
  pushl $10
  101fde:	6a 0a                	push   $0xa
  jmp __alltraps
  101fe0:	e9 81 ff ff ff       	jmp    101f66 <__alltraps>

00101fe5 <vector11>:
.globl vector11
vector11:
  pushl $11
  101fe5:	6a 0b                	push   $0xb
  jmp __alltraps
  101fe7:	e9 7a ff ff ff       	jmp    101f66 <__alltraps>

00101fec <vector12>:
.globl vector12
vector12:
  pushl $12
  101fec:	6a 0c                	push   $0xc
  jmp __alltraps
  101fee:	e9 73 ff ff ff       	jmp    101f66 <__alltraps>

00101ff3 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ff3:	6a 0d                	push   $0xd
  jmp __alltraps
  101ff5:	e9 6c ff ff ff       	jmp    101f66 <__alltraps>

00101ffa <vector14>:
.globl vector14
vector14:
  pushl $14
  101ffa:	6a 0e                	push   $0xe
  jmp __alltraps
  101ffc:	e9 65 ff ff ff       	jmp    101f66 <__alltraps>

00102001 <vector15>:
.globl vector15
vector15:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $15
  102003:	6a 0f                	push   $0xf
  jmp __alltraps
  102005:	e9 5c ff ff ff       	jmp    101f66 <__alltraps>

0010200a <vector16>:
.globl vector16
vector16:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $16
  10200c:	6a 10                	push   $0x10
  jmp __alltraps
  10200e:	e9 53 ff ff ff       	jmp    101f66 <__alltraps>

00102013 <vector17>:
.globl vector17
vector17:
  pushl $17
  102013:	6a 11                	push   $0x11
  jmp __alltraps
  102015:	e9 4c ff ff ff       	jmp    101f66 <__alltraps>

0010201a <vector18>:
.globl vector18
vector18:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $18
  10201c:	6a 12                	push   $0x12
  jmp __alltraps
  10201e:	e9 43 ff ff ff       	jmp    101f66 <__alltraps>

00102023 <vector19>:
.globl vector19
vector19:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $19
  102025:	6a 13                	push   $0x13
  jmp __alltraps
  102027:	e9 3a ff ff ff       	jmp    101f66 <__alltraps>

0010202c <vector20>:
.globl vector20
vector20:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $20
  10202e:	6a 14                	push   $0x14
  jmp __alltraps
  102030:	e9 31 ff ff ff       	jmp    101f66 <__alltraps>

00102035 <vector21>:
.globl vector21
vector21:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $21
  102037:	6a 15                	push   $0x15
  jmp __alltraps
  102039:	e9 28 ff ff ff       	jmp    101f66 <__alltraps>

0010203e <vector22>:
.globl vector22
vector22:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $22
  102040:	6a 16                	push   $0x16
  jmp __alltraps
  102042:	e9 1f ff ff ff       	jmp    101f66 <__alltraps>

00102047 <vector23>:
.globl vector23
vector23:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $23
  102049:	6a 17                	push   $0x17
  jmp __alltraps
  10204b:	e9 16 ff ff ff       	jmp    101f66 <__alltraps>

00102050 <vector24>:
.globl vector24
vector24:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $24
  102052:	6a 18                	push   $0x18
  jmp __alltraps
  102054:	e9 0d ff ff ff       	jmp    101f66 <__alltraps>

00102059 <vector25>:
.globl vector25
vector25:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $25
  10205b:	6a 19                	push   $0x19
  jmp __alltraps
  10205d:	e9 04 ff ff ff       	jmp    101f66 <__alltraps>

00102062 <vector26>:
.globl vector26
vector26:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $26
  102064:	6a 1a                	push   $0x1a
  jmp __alltraps
  102066:	e9 fb fe ff ff       	jmp    101f66 <__alltraps>

0010206b <vector27>:
.globl vector27
vector27:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $27
  10206d:	6a 1b                	push   $0x1b
  jmp __alltraps
  10206f:	e9 f2 fe ff ff       	jmp    101f66 <__alltraps>

00102074 <vector28>:
.globl vector28
vector28:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $28
  102076:	6a 1c                	push   $0x1c
  jmp __alltraps
  102078:	e9 e9 fe ff ff       	jmp    101f66 <__alltraps>

0010207d <vector29>:
.globl vector29
vector29:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $29
  10207f:	6a 1d                	push   $0x1d
  jmp __alltraps
  102081:	e9 e0 fe ff ff       	jmp    101f66 <__alltraps>

00102086 <vector30>:
.globl vector30
vector30:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $30
  102088:	6a 1e                	push   $0x1e
  jmp __alltraps
  10208a:	e9 d7 fe ff ff       	jmp    101f66 <__alltraps>

0010208f <vector31>:
.globl vector31
vector31:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $31
  102091:	6a 1f                	push   $0x1f
  jmp __alltraps
  102093:	e9 ce fe ff ff       	jmp    101f66 <__alltraps>

00102098 <vector32>:
.globl vector32
vector32:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $32
  10209a:	6a 20                	push   $0x20
  jmp __alltraps
  10209c:	e9 c5 fe ff ff       	jmp    101f66 <__alltraps>

001020a1 <vector33>:
.globl vector33
vector33:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $33
  1020a3:	6a 21                	push   $0x21
  jmp __alltraps
  1020a5:	e9 bc fe ff ff       	jmp    101f66 <__alltraps>

001020aa <vector34>:
.globl vector34
vector34:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $34
  1020ac:	6a 22                	push   $0x22
  jmp __alltraps
  1020ae:	e9 b3 fe ff ff       	jmp    101f66 <__alltraps>

001020b3 <vector35>:
.globl vector35
vector35:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $35
  1020b5:	6a 23                	push   $0x23
  jmp __alltraps
  1020b7:	e9 aa fe ff ff       	jmp    101f66 <__alltraps>

001020bc <vector36>:
.globl vector36
vector36:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $36
  1020be:	6a 24                	push   $0x24
  jmp __alltraps
  1020c0:	e9 a1 fe ff ff       	jmp    101f66 <__alltraps>

001020c5 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $37
  1020c7:	6a 25                	push   $0x25
  jmp __alltraps
  1020c9:	e9 98 fe ff ff       	jmp    101f66 <__alltraps>

001020ce <vector38>:
.globl vector38
vector38:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $38
  1020d0:	6a 26                	push   $0x26
  jmp __alltraps
  1020d2:	e9 8f fe ff ff       	jmp    101f66 <__alltraps>

001020d7 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $39
  1020d9:	6a 27                	push   $0x27
  jmp __alltraps
  1020db:	e9 86 fe ff ff       	jmp    101f66 <__alltraps>

001020e0 <vector40>:
.globl vector40
vector40:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $40
  1020e2:	6a 28                	push   $0x28
  jmp __alltraps
  1020e4:	e9 7d fe ff ff       	jmp    101f66 <__alltraps>

001020e9 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $41
  1020eb:	6a 29                	push   $0x29
  jmp __alltraps
  1020ed:	e9 74 fe ff ff       	jmp    101f66 <__alltraps>

001020f2 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $42
  1020f4:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020f6:	e9 6b fe ff ff       	jmp    101f66 <__alltraps>

001020fb <vector43>:
.globl vector43
vector43:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $43
  1020fd:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020ff:	e9 62 fe ff ff       	jmp    101f66 <__alltraps>

00102104 <vector44>:
.globl vector44
vector44:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $44
  102106:	6a 2c                	push   $0x2c
  jmp __alltraps
  102108:	e9 59 fe ff ff       	jmp    101f66 <__alltraps>

0010210d <vector45>:
.globl vector45
vector45:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $45
  10210f:	6a 2d                	push   $0x2d
  jmp __alltraps
  102111:	e9 50 fe ff ff       	jmp    101f66 <__alltraps>

00102116 <vector46>:
.globl vector46
vector46:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $46
  102118:	6a 2e                	push   $0x2e
  jmp __alltraps
  10211a:	e9 47 fe ff ff       	jmp    101f66 <__alltraps>

0010211f <vector47>:
.globl vector47
vector47:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $47
  102121:	6a 2f                	push   $0x2f
  jmp __alltraps
  102123:	e9 3e fe ff ff       	jmp    101f66 <__alltraps>

00102128 <vector48>:
.globl vector48
vector48:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $48
  10212a:	6a 30                	push   $0x30
  jmp __alltraps
  10212c:	e9 35 fe ff ff       	jmp    101f66 <__alltraps>

00102131 <vector49>:
.globl vector49
vector49:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $49
  102133:	6a 31                	push   $0x31
  jmp __alltraps
  102135:	e9 2c fe ff ff       	jmp    101f66 <__alltraps>

0010213a <vector50>:
.globl vector50
vector50:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $50
  10213c:	6a 32                	push   $0x32
  jmp __alltraps
  10213e:	e9 23 fe ff ff       	jmp    101f66 <__alltraps>

00102143 <vector51>:
.globl vector51
vector51:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $51
  102145:	6a 33                	push   $0x33
  jmp __alltraps
  102147:	e9 1a fe ff ff       	jmp    101f66 <__alltraps>

0010214c <vector52>:
.globl vector52
vector52:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $52
  10214e:	6a 34                	push   $0x34
  jmp __alltraps
  102150:	e9 11 fe ff ff       	jmp    101f66 <__alltraps>

00102155 <vector53>:
.globl vector53
vector53:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $53
  102157:	6a 35                	push   $0x35
  jmp __alltraps
  102159:	e9 08 fe ff ff       	jmp    101f66 <__alltraps>

0010215e <vector54>:
.globl vector54
vector54:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $54
  102160:	6a 36                	push   $0x36
  jmp __alltraps
  102162:	e9 ff fd ff ff       	jmp    101f66 <__alltraps>

00102167 <vector55>:
.globl vector55
vector55:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $55
  102169:	6a 37                	push   $0x37
  jmp __alltraps
  10216b:	e9 f6 fd ff ff       	jmp    101f66 <__alltraps>

00102170 <vector56>:
.globl vector56
vector56:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $56
  102172:	6a 38                	push   $0x38
  jmp __alltraps
  102174:	e9 ed fd ff ff       	jmp    101f66 <__alltraps>

00102179 <vector57>:
.globl vector57
vector57:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $57
  10217b:	6a 39                	push   $0x39
  jmp __alltraps
  10217d:	e9 e4 fd ff ff       	jmp    101f66 <__alltraps>

00102182 <vector58>:
.globl vector58
vector58:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $58
  102184:	6a 3a                	push   $0x3a
  jmp __alltraps
  102186:	e9 db fd ff ff       	jmp    101f66 <__alltraps>

0010218b <vector59>:
.globl vector59
vector59:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $59
  10218d:	6a 3b                	push   $0x3b
  jmp __alltraps
  10218f:	e9 d2 fd ff ff       	jmp    101f66 <__alltraps>

00102194 <vector60>:
.globl vector60
vector60:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $60
  102196:	6a 3c                	push   $0x3c
  jmp __alltraps
  102198:	e9 c9 fd ff ff       	jmp    101f66 <__alltraps>

0010219d <vector61>:
.globl vector61
vector61:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $61
  10219f:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021a1:	e9 c0 fd ff ff       	jmp    101f66 <__alltraps>

001021a6 <vector62>:
.globl vector62
vector62:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $62
  1021a8:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021aa:	e9 b7 fd ff ff       	jmp    101f66 <__alltraps>

001021af <vector63>:
.globl vector63
vector63:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $63
  1021b1:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021b3:	e9 ae fd ff ff       	jmp    101f66 <__alltraps>

001021b8 <vector64>:
.globl vector64
vector64:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $64
  1021ba:	6a 40                	push   $0x40
  jmp __alltraps
  1021bc:	e9 a5 fd ff ff       	jmp    101f66 <__alltraps>

001021c1 <vector65>:
.globl vector65
vector65:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $65
  1021c3:	6a 41                	push   $0x41
  jmp __alltraps
  1021c5:	e9 9c fd ff ff       	jmp    101f66 <__alltraps>

001021ca <vector66>:
.globl vector66
vector66:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $66
  1021cc:	6a 42                	push   $0x42
  jmp __alltraps
  1021ce:	e9 93 fd ff ff       	jmp    101f66 <__alltraps>

001021d3 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $67
  1021d5:	6a 43                	push   $0x43
  jmp __alltraps
  1021d7:	e9 8a fd ff ff       	jmp    101f66 <__alltraps>

001021dc <vector68>:
.globl vector68
vector68:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $68
  1021de:	6a 44                	push   $0x44
  jmp __alltraps
  1021e0:	e9 81 fd ff ff       	jmp    101f66 <__alltraps>

001021e5 <vector69>:
.globl vector69
vector69:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $69
  1021e7:	6a 45                	push   $0x45
  jmp __alltraps
  1021e9:	e9 78 fd ff ff       	jmp    101f66 <__alltraps>

001021ee <vector70>:
.globl vector70
vector70:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $70
  1021f0:	6a 46                	push   $0x46
  jmp __alltraps
  1021f2:	e9 6f fd ff ff       	jmp    101f66 <__alltraps>

001021f7 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $71
  1021f9:	6a 47                	push   $0x47
  jmp __alltraps
  1021fb:	e9 66 fd ff ff       	jmp    101f66 <__alltraps>

00102200 <vector72>:
.globl vector72
vector72:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $72
  102202:	6a 48                	push   $0x48
  jmp __alltraps
  102204:	e9 5d fd ff ff       	jmp    101f66 <__alltraps>

00102209 <vector73>:
.globl vector73
vector73:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $73
  10220b:	6a 49                	push   $0x49
  jmp __alltraps
  10220d:	e9 54 fd ff ff       	jmp    101f66 <__alltraps>

00102212 <vector74>:
.globl vector74
vector74:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $74
  102214:	6a 4a                	push   $0x4a
  jmp __alltraps
  102216:	e9 4b fd ff ff       	jmp    101f66 <__alltraps>

0010221b <vector75>:
.globl vector75
vector75:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $75
  10221d:	6a 4b                	push   $0x4b
  jmp __alltraps
  10221f:	e9 42 fd ff ff       	jmp    101f66 <__alltraps>

00102224 <vector76>:
.globl vector76
vector76:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $76
  102226:	6a 4c                	push   $0x4c
  jmp __alltraps
  102228:	e9 39 fd ff ff       	jmp    101f66 <__alltraps>

0010222d <vector77>:
.globl vector77
vector77:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $77
  10222f:	6a 4d                	push   $0x4d
  jmp __alltraps
  102231:	e9 30 fd ff ff       	jmp    101f66 <__alltraps>

00102236 <vector78>:
.globl vector78
vector78:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $78
  102238:	6a 4e                	push   $0x4e
  jmp __alltraps
  10223a:	e9 27 fd ff ff       	jmp    101f66 <__alltraps>

0010223f <vector79>:
.globl vector79
vector79:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $79
  102241:	6a 4f                	push   $0x4f
  jmp __alltraps
  102243:	e9 1e fd ff ff       	jmp    101f66 <__alltraps>

00102248 <vector80>:
.globl vector80
vector80:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $80
  10224a:	6a 50                	push   $0x50
  jmp __alltraps
  10224c:	e9 15 fd ff ff       	jmp    101f66 <__alltraps>

00102251 <vector81>:
.globl vector81
vector81:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $81
  102253:	6a 51                	push   $0x51
  jmp __alltraps
  102255:	e9 0c fd ff ff       	jmp    101f66 <__alltraps>

0010225a <vector82>:
.globl vector82
vector82:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $82
  10225c:	6a 52                	push   $0x52
  jmp __alltraps
  10225e:	e9 03 fd ff ff       	jmp    101f66 <__alltraps>

00102263 <vector83>:
.globl vector83
vector83:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $83
  102265:	6a 53                	push   $0x53
  jmp __alltraps
  102267:	e9 fa fc ff ff       	jmp    101f66 <__alltraps>

0010226c <vector84>:
.globl vector84
vector84:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $84
  10226e:	6a 54                	push   $0x54
  jmp __alltraps
  102270:	e9 f1 fc ff ff       	jmp    101f66 <__alltraps>

00102275 <vector85>:
.globl vector85
vector85:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $85
  102277:	6a 55                	push   $0x55
  jmp __alltraps
  102279:	e9 e8 fc ff ff       	jmp    101f66 <__alltraps>

0010227e <vector86>:
.globl vector86
vector86:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $86
  102280:	6a 56                	push   $0x56
  jmp __alltraps
  102282:	e9 df fc ff ff       	jmp    101f66 <__alltraps>

00102287 <vector87>:
.globl vector87
vector87:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $87
  102289:	6a 57                	push   $0x57
  jmp __alltraps
  10228b:	e9 d6 fc ff ff       	jmp    101f66 <__alltraps>

00102290 <vector88>:
.globl vector88
vector88:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $88
  102292:	6a 58                	push   $0x58
  jmp __alltraps
  102294:	e9 cd fc ff ff       	jmp    101f66 <__alltraps>

00102299 <vector89>:
.globl vector89
vector89:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $89
  10229b:	6a 59                	push   $0x59
  jmp __alltraps
  10229d:	e9 c4 fc ff ff       	jmp    101f66 <__alltraps>

001022a2 <vector90>:
.globl vector90
vector90:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $90
  1022a4:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022a6:	e9 bb fc ff ff       	jmp    101f66 <__alltraps>

001022ab <vector91>:
.globl vector91
vector91:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $91
  1022ad:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022af:	e9 b2 fc ff ff       	jmp    101f66 <__alltraps>

001022b4 <vector92>:
.globl vector92
vector92:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $92
  1022b6:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022b8:	e9 a9 fc ff ff       	jmp    101f66 <__alltraps>

001022bd <vector93>:
.globl vector93
vector93:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $93
  1022bf:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022c1:	e9 a0 fc ff ff       	jmp    101f66 <__alltraps>

001022c6 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $94
  1022c8:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022ca:	e9 97 fc ff ff       	jmp    101f66 <__alltraps>

001022cf <vector95>:
.globl vector95
vector95:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $95
  1022d1:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022d3:	e9 8e fc ff ff       	jmp    101f66 <__alltraps>

001022d8 <vector96>:
.globl vector96
vector96:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $96
  1022da:	6a 60                	push   $0x60
  jmp __alltraps
  1022dc:	e9 85 fc ff ff       	jmp    101f66 <__alltraps>

001022e1 <vector97>:
.globl vector97
vector97:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $97
  1022e3:	6a 61                	push   $0x61
  jmp __alltraps
  1022e5:	e9 7c fc ff ff       	jmp    101f66 <__alltraps>

001022ea <vector98>:
.globl vector98
vector98:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $98
  1022ec:	6a 62                	push   $0x62
  jmp __alltraps
  1022ee:	e9 73 fc ff ff       	jmp    101f66 <__alltraps>

001022f3 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $99
  1022f5:	6a 63                	push   $0x63
  jmp __alltraps
  1022f7:	e9 6a fc ff ff       	jmp    101f66 <__alltraps>

001022fc <vector100>:
.globl vector100
vector100:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $100
  1022fe:	6a 64                	push   $0x64
  jmp __alltraps
  102300:	e9 61 fc ff ff       	jmp    101f66 <__alltraps>

00102305 <vector101>:
.globl vector101
vector101:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $101
  102307:	6a 65                	push   $0x65
  jmp __alltraps
  102309:	e9 58 fc ff ff       	jmp    101f66 <__alltraps>

0010230e <vector102>:
.globl vector102
vector102:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $102
  102310:	6a 66                	push   $0x66
  jmp __alltraps
  102312:	e9 4f fc ff ff       	jmp    101f66 <__alltraps>

00102317 <vector103>:
.globl vector103
vector103:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $103
  102319:	6a 67                	push   $0x67
  jmp __alltraps
  10231b:	e9 46 fc ff ff       	jmp    101f66 <__alltraps>

00102320 <vector104>:
.globl vector104
vector104:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $104
  102322:	6a 68                	push   $0x68
  jmp __alltraps
  102324:	e9 3d fc ff ff       	jmp    101f66 <__alltraps>

00102329 <vector105>:
.globl vector105
vector105:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $105
  10232b:	6a 69                	push   $0x69
  jmp __alltraps
  10232d:	e9 34 fc ff ff       	jmp    101f66 <__alltraps>

00102332 <vector106>:
.globl vector106
vector106:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $106
  102334:	6a 6a                	push   $0x6a
  jmp __alltraps
  102336:	e9 2b fc ff ff       	jmp    101f66 <__alltraps>

0010233b <vector107>:
.globl vector107
vector107:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $107
  10233d:	6a 6b                	push   $0x6b
  jmp __alltraps
  10233f:	e9 22 fc ff ff       	jmp    101f66 <__alltraps>

00102344 <vector108>:
.globl vector108
vector108:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $108
  102346:	6a 6c                	push   $0x6c
  jmp __alltraps
  102348:	e9 19 fc ff ff       	jmp    101f66 <__alltraps>

0010234d <vector109>:
.globl vector109
vector109:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $109
  10234f:	6a 6d                	push   $0x6d
  jmp __alltraps
  102351:	e9 10 fc ff ff       	jmp    101f66 <__alltraps>

00102356 <vector110>:
.globl vector110
vector110:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $110
  102358:	6a 6e                	push   $0x6e
  jmp __alltraps
  10235a:	e9 07 fc ff ff       	jmp    101f66 <__alltraps>

0010235f <vector111>:
.globl vector111
vector111:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $111
  102361:	6a 6f                	push   $0x6f
  jmp __alltraps
  102363:	e9 fe fb ff ff       	jmp    101f66 <__alltraps>

00102368 <vector112>:
.globl vector112
vector112:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $112
  10236a:	6a 70                	push   $0x70
  jmp __alltraps
  10236c:	e9 f5 fb ff ff       	jmp    101f66 <__alltraps>

00102371 <vector113>:
.globl vector113
vector113:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $113
  102373:	6a 71                	push   $0x71
  jmp __alltraps
  102375:	e9 ec fb ff ff       	jmp    101f66 <__alltraps>

0010237a <vector114>:
.globl vector114
vector114:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $114
  10237c:	6a 72                	push   $0x72
  jmp __alltraps
  10237e:	e9 e3 fb ff ff       	jmp    101f66 <__alltraps>

00102383 <vector115>:
.globl vector115
vector115:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $115
  102385:	6a 73                	push   $0x73
  jmp __alltraps
  102387:	e9 da fb ff ff       	jmp    101f66 <__alltraps>

0010238c <vector116>:
.globl vector116
vector116:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $116
  10238e:	6a 74                	push   $0x74
  jmp __alltraps
  102390:	e9 d1 fb ff ff       	jmp    101f66 <__alltraps>

00102395 <vector117>:
.globl vector117
vector117:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $117
  102397:	6a 75                	push   $0x75
  jmp __alltraps
  102399:	e9 c8 fb ff ff       	jmp    101f66 <__alltraps>

0010239e <vector118>:
.globl vector118
vector118:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $118
  1023a0:	6a 76                	push   $0x76
  jmp __alltraps
  1023a2:	e9 bf fb ff ff       	jmp    101f66 <__alltraps>

001023a7 <vector119>:
.globl vector119
vector119:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $119
  1023a9:	6a 77                	push   $0x77
  jmp __alltraps
  1023ab:	e9 b6 fb ff ff       	jmp    101f66 <__alltraps>

001023b0 <vector120>:
.globl vector120
vector120:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $120
  1023b2:	6a 78                	push   $0x78
  jmp __alltraps
  1023b4:	e9 ad fb ff ff       	jmp    101f66 <__alltraps>

001023b9 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $121
  1023bb:	6a 79                	push   $0x79
  jmp __alltraps
  1023bd:	e9 a4 fb ff ff       	jmp    101f66 <__alltraps>

001023c2 <vector122>:
.globl vector122
vector122:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $122
  1023c4:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023c6:	e9 9b fb ff ff       	jmp    101f66 <__alltraps>

001023cb <vector123>:
.globl vector123
vector123:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $123
  1023cd:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023cf:	e9 92 fb ff ff       	jmp    101f66 <__alltraps>

001023d4 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $124
  1023d6:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023d8:	e9 89 fb ff ff       	jmp    101f66 <__alltraps>

001023dd <vector125>:
.globl vector125
vector125:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $125
  1023df:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023e1:	e9 80 fb ff ff       	jmp    101f66 <__alltraps>

001023e6 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $126
  1023e8:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023ea:	e9 77 fb ff ff       	jmp    101f66 <__alltraps>

001023ef <vector127>:
.globl vector127
vector127:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $127
  1023f1:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023f3:	e9 6e fb ff ff       	jmp    101f66 <__alltraps>

001023f8 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $128
  1023fa:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023ff:	e9 62 fb ff ff       	jmp    101f66 <__alltraps>

00102404 <vector129>:
.globl vector129
vector129:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $129
  102406:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10240b:	e9 56 fb ff ff       	jmp    101f66 <__alltraps>

00102410 <vector130>:
.globl vector130
vector130:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $130
  102412:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102417:	e9 4a fb ff ff       	jmp    101f66 <__alltraps>

0010241c <vector131>:
.globl vector131
vector131:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $131
  10241e:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102423:	e9 3e fb ff ff       	jmp    101f66 <__alltraps>

00102428 <vector132>:
.globl vector132
vector132:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $132
  10242a:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10242f:	e9 32 fb ff ff       	jmp    101f66 <__alltraps>

00102434 <vector133>:
.globl vector133
vector133:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $133
  102436:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10243b:	e9 26 fb ff ff       	jmp    101f66 <__alltraps>

00102440 <vector134>:
.globl vector134
vector134:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $134
  102442:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102447:	e9 1a fb ff ff       	jmp    101f66 <__alltraps>

0010244c <vector135>:
.globl vector135
vector135:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $135
  10244e:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102453:	e9 0e fb ff ff       	jmp    101f66 <__alltraps>

00102458 <vector136>:
.globl vector136
vector136:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $136
  10245a:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10245f:	e9 02 fb ff ff       	jmp    101f66 <__alltraps>

00102464 <vector137>:
.globl vector137
vector137:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $137
  102466:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10246b:	e9 f6 fa ff ff       	jmp    101f66 <__alltraps>

00102470 <vector138>:
.globl vector138
vector138:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $138
  102472:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102477:	e9 ea fa ff ff       	jmp    101f66 <__alltraps>

0010247c <vector139>:
.globl vector139
vector139:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $139
  10247e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102483:	e9 de fa ff ff       	jmp    101f66 <__alltraps>

00102488 <vector140>:
.globl vector140
vector140:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $140
  10248a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10248f:	e9 d2 fa ff ff       	jmp    101f66 <__alltraps>

00102494 <vector141>:
.globl vector141
vector141:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $141
  102496:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10249b:	e9 c6 fa ff ff       	jmp    101f66 <__alltraps>

001024a0 <vector142>:
.globl vector142
vector142:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $142
  1024a2:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024a7:	e9 ba fa ff ff       	jmp    101f66 <__alltraps>

001024ac <vector143>:
.globl vector143
vector143:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $143
  1024ae:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024b3:	e9 ae fa ff ff       	jmp    101f66 <__alltraps>

001024b8 <vector144>:
.globl vector144
vector144:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $144
  1024ba:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024bf:	e9 a2 fa ff ff       	jmp    101f66 <__alltraps>

001024c4 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $145
  1024c6:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024cb:	e9 96 fa ff ff       	jmp    101f66 <__alltraps>

001024d0 <vector146>:
.globl vector146
vector146:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $146
  1024d2:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024d7:	e9 8a fa ff ff       	jmp    101f66 <__alltraps>

001024dc <vector147>:
.globl vector147
vector147:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $147
  1024de:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024e3:	e9 7e fa ff ff       	jmp    101f66 <__alltraps>

001024e8 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $148
  1024ea:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024ef:	e9 72 fa ff ff       	jmp    101f66 <__alltraps>

001024f4 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $149
  1024f6:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024fb:	e9 66 fa ff ff       	jmp    101f66 <__alltraps>

00102500 <vector150>:
.globl vector150
vector150:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $150
  102502:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102507:	e9 5a fa ff ff       	jmp    101f66 <__alltraps>

0010250c <vector151>:
.globl vector151
vector151:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $151
  10250e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102513:	e9 4e fa ff ff       	jmp    101f66 <__alltraps>

00102518 <vector152>:
.globl vector152
vector152:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $152
  10251a:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10251f:	e9 42 fa ff ff       	jmp    101f66 <__alltraps>

00102524 <vector153>:
.globl vector153
vector153:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $153
  102526:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10252b:	e9 36 fa ff ff       	jmp    101f66 <__alltraps>

00102530 <vector154>:
.globl vector154
vector154:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $154
  102532:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102537:	e9 2a fa ff ff       	jmp    101f66 <__alltraps>

0010253c <vector155>:
.globl vector155
vector155:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $155
  10253e:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102543:	e9 1e fa ff ff       	jmp    101f66 <__alltraps>

00102548 <vector156>:
.globl vector156
vector156:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $156
  10254a:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10254f:	e9 12 fa ff ff       	jmp    101f66 <__alltraps>

00102554 <vector157>:
.globl vector157
vector157:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $157
  102556:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10255b:	e9 06 fa ff ff       	jmp    101f66 <__alltraps>

00102560 <vector158>:
.globl vector158
vector158:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $158
  102562:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102567:	e9 fa f9 ff ff       	jmp    101f66 <__alltraps>

0010256c <vector159>:
.globl vector159
vector159:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $159
  10256e:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102573:	e9 ee f9 ff ff       	jmp    101f66 <__alltraps>

00102578 <vector160>:
.globl vector160
vector160:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $160
  10257a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10257f:	e9 e2 f9 ff ff       	jmp    101f66 <__alltraps>

00102584 <vector161>:
.globl vector161
vector161:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $161
  102586:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10258b:	e9 d6 f9 ff ff       	jmp    101f66 <__alltraps>

00102590 <vector162>:
.globl vector162
vector162:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $162
  102592:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102597:	e9 ca f9 ff ff       	jmp    101f66 <__alltraps>

0010259c <vector163>:
.globl vector163
vector163:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $163
  10259e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025a3:	e9 be f9 ff ff       	jmp    101f66 <__alltraps>

001025a8 <vector164>:
.globl vector164
vector164:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $164
  1025aa:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025af:	e9 b2 f9 ff ff       	jmp    101f66 <__alltraps>

001025b4 <vector165>:
.globl vector165
vector165:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $165
  1025b6:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025bb:	e9 a6 f9 ff ff       	jmp    101f66 <__alltraps>

001025c0 <vector166>:
.globl vector166
vector166:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $166
  1025c2:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025c7:	e9 9a f9 ff ff       	jmp    101f66 <__alltraps>

001025cc <vector167>:
.globl vector167
vector167:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $167
  1025ce:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025d3:	e9 8e f9 ff ff       	jmp    101f66 <__alltraps>

001025d8 <vector168>:
.globl vector168
vector168:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $168
  1025da:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025df:	e9 82 f9 ff ff       	jmp    101f66 <__alltraps>

001025e4 <vector169>:
.globl vector169
vector169:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $169
  1025e6:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025eb:	e9 76 f9 ff ff       	jmp    101f66 <__alltraps>

001025f0 <vector170>:
.globl vector170
vector170:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $170
  1025f2:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025f7:	e9 6a f9 ff ff       	jmp    101f66 <__alltraps>

001025fc <vector171>:
.globl vector171
vector171:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $171
  1025fe:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102603:	e9 5e f9 ff ff       	jmp    101f66 <__alltraps>

00102608 <vector172>:
.globl vector172
vector172:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $172
  10260a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10260f:	e9 52 f9 ff ff       	jmp    101f66 <__alltraps>

00102614 <vector173>:
.globl vector173
vector173:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $173
  102616:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10261b:	e9 46 f9 ff ff       	jmp    101f66 <__alltraps>

00102620 <vector174>:
.globl vector174
vector174:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $174
  102622:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102627:	e9 3a f9 ff ff       	jmp    101f66 <__alltraps>

0010262c <vector175>:
.globl vector175
vector175:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $175
  10262e:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102633:	e9 2e f9 ff ff       	jmp    101f66 <__alltraps>

00102638 <vector176>:
.globl vector176
vector176:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $176
  10263a:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10263f:	e9 22 f9 ff ff       	jmp    101f66 <__alltraps>

00102644 <vector177>:
.globl vector177
vector177:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $177
  102646:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10264b:	e9 16 f9 ff ff       	jmp    101f66 <__alltraps>

00102650 <vector178>:
.globl vector178
vector178:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $178
  102652:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102657:	e9 0a f9 ff ff       	jmp    101f66 <__alltraps>

0010265c <vector179>:
.globl vector179
vector179:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $179
  10265e:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102663:	e9 fe f8 ff ff       	jmp    101f66 <__alltraps>

00102668 <vector180>:
.globl vector180
vector180:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $180
  10266a:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10266f:	e9 f2 f8 ff ff       	jmp    101f66 <__alltraps>

00102674 <vector181>:
.globl vector181
vector181:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $181
  102676:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10267b:	e9 e6 f8 ff ff       	jmp    101f66 <__alltraps>

00102680 <vector182>:
.globl vector182
vector182:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $182
  102682:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102687:	e9 da f8 ff ff       	jmp    101f66 <__alltraps>

0010268c <vector183>:
.globl vector183
vector183:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $183
  10268e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102693:	e9 ce f8 ff ff       	jmp    101f66 <__alltraps>

00102698 <vector184>:
.globl vector184
vector184:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $184
  10269a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10269f:	e9 c2 f8 ff ff       	jmp    101f66 <__alltraps>

001026a4 <vector185>:
.globl vector185
vector185:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $185
  1026a6:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026ab:	e9 b6 f8 ff ff       	jmp    101f66 <__alltraps>

001026b0 <vector186>:
.globl vector186
vector186:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $186
  1026b2:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026b7:	e9 aa f8 ff ff       	jmp    101f66 <__alltraps>

001026bc <vector187>:
.globl vector187
vector187:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $187
  1026be:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026c3:	e9 9e f8 ff ff       	jmp    101f66 <__alltraps>

001026c8 <vector188>:
.globl vector188
vector188:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $188
  1026ca:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026cf:	e9 92 f8 ff ff       	jmp    101f66 <__alltraps>

001026d4 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $189
  1026d6:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026db:	e9 86 f8 ff ff       	jmp    101f66 <__alltraps>

001026e0 <vector190>:
.globl vector190
vector190:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $190
  1026e2:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026e7:	e9 7a f8 ff ff       	jmp    101f66 <__alltraps>

001026ec <vector191>:
.globl vector191
vector191:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $191
  1026ee:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026f3:	e9 6e f8 ff ff       	jmp    101f66 <__alltraps>

001026f8 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $192
  1026fa:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026ff:	e9 62 f8 ff ff       	jmp    101f66 <__alltraps>

00102704 <vector193>:
.globl vector193
vector193:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $193
  102706:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10270b:	e9 56 f8 ff ff       	jmp    101f66 <__alltraps>

00102710 <vector194>:
.globl vector194
vector194:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $194
  102712:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102717:	e9 4a f8 ff ff       	jmp    101f66 <__alltraps>

0010271c <vector195>:
.globl vector195
vector195:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $195
  10271e:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102723:	e9 3e f8 ff ff       	jmp    101f66 <__alltraps>

00102728 <vector196>:
.globl vector196
vector196:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $196
  10272a:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10272f:	e9 32 f8 ff ff       	jmp    101f66 <__alltraps>

00102734 <vector197>:
.globl vector197
vector197:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $197
  102736:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10273b:	e9 26 f8 ff ff       	jmp    101f66 <__alltraps>

00102740 <vector198>:
.globl vector198
vector198:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $198
  102742:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102747:	e9 1a f8 ff ff       	jmp    101f66 <__alltraps>

0010274c <vector199>:
.globl vector199
vector199:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $199
  10274e:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102753:	e9 0e f8 ff ff       	jmp    101f66 <__alltraps>

00102758 <vector200>:
.globl vector200
vector200:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $200
  10275a:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10275f:	e9 02 f8 ff ff       	jmp    101f66 <__alltraps>

00102764 <vector201>:
.globl vector201
vector201:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $201
  102766:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10276b:	e9 f6 f7 ff ff       	jmp    101f66 <__alltraps>

00102770 <vector202>:
.globl vector202
vector202:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $202
  102772:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102777:	e9 ea f7 ff ff       	jmp    101f66 <__alltraps>

0010277c <vector203>:
.globl vector203
vector203:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $203
  10277e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102783:	e9 de f7 ff ff       	jmp    101f66 <__alltraps>

00102788 <vector204>:
.globl vector204
vector204:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $204
  10278a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10278f:	e9 d2 f7 ff ff       	jmp    101f66 <__alltraps>

00102794 <vector205>:
.globl vector205
vector205:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $205
  102796:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10279b:	e9 c6 f7 ff ff       	jmp    101f66 <__alltraps>

001027a0 <vector206>:
.globl vector206
vector206:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $206
  1027a2:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027a7:	e9 ba f7 ff ff       	jmp    101f66 <__alltraps>

001027ac <vector207>:
.globl vector207
vector207:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $207
  1027ae:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027b3:	e9 ae f7 ff ff       	jmp    101f66 <__alltraps>

001027b8 <vector208>:
.globl vector208
vector208:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $208
  1027ba:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027bf:	e9 a2 f7 ff ff       	jmp    101f66 <__alltraps>

001027c4 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $209
  1027c6:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027cb:	e9 96 f7 ff ff       	jmp    101f66 <__alltraps>

001027d0 <vector210>:
.globl vector210
vector210:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $210
  1027d2:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027d7:	e9 8a f7 ff ff       	jmp    101f66 <__alltraps>

001027dc <vector211>:
.globl vector211
vector211:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $211
  1027de:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027e3:	e9 7e f7 ff ff       	jmp    101f66 <__alltraps>

001027e8 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $212
  1027ea:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027ef:	e9 72 f7 ff ff       	jmp    101f66 <__alltraps>

001027f4 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $213
  1027f6:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027fb:	e9 66 f7 ff ff       	jmp    101f66 <__alltraps>

00102800 <vector214>:
.globl vector214
vector214:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $214
  102802:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102807:	e9 5a f7 ff ff       	jmp    101f66 <__alltraps>

0010280c <vector215>:
.globl vector215
vector215:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $215
  10280e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102813:	e9 4e f7 ff ff       	jmp    101f66 <__alltraps>

00102818 <vector216>:
.globl vector216
vector216:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $216
  10281a:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10281f:	e9 42 f7 ff ff       	jmp    101f66 <__alltraps>

00102824 <vector217>:
.globl vector217
vector217:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $217
  102826:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10282b:	e9 36 f7 ff ff       	jmp    101f66 <__alltraps>

00102830 <vector218>:
.globl vector218
vector218:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $218
  102832:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102837:	e9 2a f7 ff ff       	jmp    101f66 <__alltraps>

0010283c <vector219>:
.globl vector219
vector219:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $219
  10283e:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102843:	e9 1e f7 ff ff       	jmp    101f66 <__alltraps>

00102848 <vector220>:
.globl vector220
vector220:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $220
  10284a:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10284f:	e9 12 f7 ff ff       	jmp    101f66 <__alltraps>

00102854 <vector221>:
.globl vector221
vector221:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $221
  102856:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10285b:	e9 06 f7 ff ff       	jmp    101f66 <__alltraps>

00102860 <vector222>:
.globl vector222
vector222:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $222
  102862:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102867:	e9 fa f6 ff ff       	jmp    101f66 <__alltraps>

0010286c <vector223>:
.globl vector223
vector223:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $223
  10286e:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102873:	e9 ee f6 ff ff       	jmp    101f66 <__alltraps>

00102878 <vector224>:
.globl vector224
vector224:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $224
  10287a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10287f:	e9 e2 f6 ff ff       	jmp    101f66 <__alltraps>

00102884 <vector225>:
.globl vector225
vector225:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $225
  102886:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10288b:	e9 d6 f6 ff ff       	jmp    101f66 <__alltraps>

00102890 <vector226>:
.globl vector226
vector226:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $226
  102892:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102897:	e9 ca f6 ff ff       	jmp    101f66 <__alltraps>

0010289c <vector227>:
.globl vector227
vector227:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $227
  10289e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028a3:	e9 be f6 ff ff       	jmp    101f66 <__alltraps>

001028a8 <vector228>:
.globl vector228
vector228:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $228
  1028aa:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028af:	e9 b2 f6 ff ff       	jmp    101f66 <__alltraps>

001028b4 <vector229>:
.globl vector229
vector229:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $229
  1028b6:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028bb:	e9 a6 f6 ff ff       	jmp    101f66 <__alltraps>

001028c0 <vector230>:
.globl vector230
vector230:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $230
  1028c2:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028c7:	e9 9a f6 ff ff       	jmp    101f66 <__alltraps>

001028cc <vector231>:
.globl vector231
vector231:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $231
  1028ce:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028d3:	e9 8e f6 ff ff       	jmp    101f66 <__alltraps>

001028d8 <vector232>:
.globl vector232
vector232:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $232
  1028da:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028df:	e9 82 f6 ff ff       	jmp    101f66 <__alltraps>

001028e4 <vector233>:
.globl vector233
vector233:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $233
  1028e6:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028eb:	e9 76 f6 ff ff       	jmp    101f66 <__alltraps>

001028f0 <vector234>:
.globl vector234
vector234:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $234
  1028f2:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028f7:	e9 6a f6 ff ff       	jmp    101f66 <__alltraps>

001028fc <vector235>:
.globl vector235
vector235:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $235
  1028fe:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102903:	e9 5e f6 ff ff       	jmp    101f66 <__alltraps>

00102908 <vector236>:
.globl vector236
vector236:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $236
  10290a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10290f:	e9 52 f6 ff ff       	jmp    101f66 <__alltraps>

00102914 <vector237>:
.globl vector237
vector237:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $237
  102916:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10291b:	e9 46 f6 ff ff       	jmp    101f66 <__alltraps>

00102920 <vector238>:
.globl vector238
vector238:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $238
  102922:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102927:	e9 3a f6 ff ff       	jmp    101f66 <__alltraps>

0010292c <vector239>:
.globl vector239
vector239:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $239
  10292e:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102933:	e9 2e f6 ff ff       	jmp    101f66 <__alltraps>

00102938 <vector240>:
.globl vector240
vector240:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $240
  10293a:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10293f:	e9 22 f6 ff ff       	jmp    101f66 <__alltraps>

00102944 <vector241>:
.globl vector241
vector241:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $241
  102946:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10294b:	e9 16 f6 ff ff       	jmp    101f66 <__alltraps>

00102950 <vector242>:
.globl vector242
vector242:
  pushl $0
  102950:	6a 00                	push   $0x0
  pushl $242
  102952:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102957:	e9 0a f6 ff ff       	jmp    101f66 <__alltraps>

0010295c <vector243>:
.globl vector243
vector243:
  pushl $0
  10295c:	6a 00                	push   $0x0
  pushl $243
  10295e:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102963:	e9 fe f5 ff ff       	jmp    101f66 <__alltraps>

00102968 <vector244>:
.globl vector244
vector244:
  pushl $0
  102968:	6a 00                	push   $0x0
  pushl $244
  10296a:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10296f:	e9 f2 f5 ff ff       	jmp    101f66 <__alltraps>

00102974 <vector245>:
.globl vector245
vector245:
  pushl $0
  102974:	6a 00                	push   $0x0
  pushl $245
  102976:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10297b:	e9 e6 f5 ff ff       	jmp    101f66 <__alltraps>

00102980 <vector246>:
.globl vector246
vector246:
  pushl $0
  102980:	6a 00                	push   $0x0
  pushl $246
  102982:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102987:	e9 da f5 ff ff       	jmp    101f66 <__alltraps>

0010298c <vector247>:
.globl vector247
vector247:
  pushl $0
  10298c:	6a 00                	push   $0x0
  pushl $247
  10298e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102993:	e9 ce f5 ff ff       	jmp    101f66 <__alltraps>

00102998 <vector248>:
.globl vector248
vector248:
  pushl $0
  102998:	6a 00                	push   $0x0
  pushl $248
  10299a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10299f:	e9 c2 f5 ff ff       	jmp    101f66 <__alltraps>

001029a4 <vector249>:
.globl vector249
vector249:
  pushl $0
  1029a4:	6a 00                	push   $0x0
  pushl $249
  1029a6:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029ab:	e9 b6 f5 ff ff       	jmp    101f66 <__alltraps>

001029b0 <vector250>:
.globl vector250
vector250:
  pushl $0
  1029b0:	6a 00                	push   $0x0
  pushl $250
  1029b2:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029b7:	e9 aa f5 ff ff       	jmp    101f66 <__alltraps>

001029bc <vector251>:
.globl vector251
vector251:
  pushl $0
  1029bc:	6a 00                	push   $0x0
  pushl $251
  1029be:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029c3:	e9 9e f5 ff ff       	jmp    101f66 <__alltraps>

001029c8 <vector252>:
.globl vector252
vector252:
  pushl $0
  1029c8:	6a 00                	push   $0x0
  pushl $252
  1029ca:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029cf:	e9 92 f5 ff ff       	jmp    101f66 <__alltraps>

001029d4 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029d4:	6a 00                	push   $0x0
  pushl $253
  1029d6:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029db:	e9 86 f5 ff ff       	jmp    101f66 <__alltraps>

001029e0 <vector254>:
.globl vector254
vector254:
  pushl $0
  1029e0:	6a 00                	push   $0x0
  pushl $254
  1029e2:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029e7:	e9 7a f5 ff ff       	jmp    101f66 <__alltraps>

001029ec <vector255>:
.globl vector255
vector255:
  pushl $0
  1029ec:	6a 00                	push   $0x0
  pushl $255
  1029ee:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029f3:	e9 6e f5 ff ff       	jmp    101f66 <__alltraps>

001029f8 <set_page_ref>:
page_ref(struct Page *page) {
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
  1029f8:	55                   	push   %ebp
  1029f9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1029fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a01:	89 10                	mov    %edx,(%eax)
}
  102a03:	5d                   	pop    %ebp
  102a04:	c3                   	ret    

00102a05 <buddy_init>:
struct Zone {
    struct Page *mem_base;
} zones[MAX_ZONE_NUM] = {{NULL}};

static void
buddy_init(void) {
  102a05:	55                   	push   %ebp
  102a06:	89 e5                	mov    %esp,%ebp
  102a08:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; i <= MAX_ORDER; i ++) {
  102a0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102a12:	eb 44                	jmp    102a58 <buddy_init+0x53>
        list_init(&free_list(i));
  102a14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102a17:	89 d0                	mov    %edx,%eax
  102a19:	01 c0                	add    %eax,%eax
  102a1b:	01 d0                	add    %edx,%eax
  102a1d:	c1 e0 02             	shl    $0x2,%eax
  102a20:	05 00 b9 11 00       	add    $0x11b900,%eax
  102a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102a28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102a2b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102a2e:	89 50 04             	mov    %edx,0x4(%eax)
  102a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102a34:	8b 50 04             	mov    0x4(%eax),%edx
  102a37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102a3a:	89 10                	mov    %edx,(%eax)
        nr_free(i) = 0;
  102a3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102a3f:	89 d0                	mov    %edx,%eax
  102a41:	01 c0                	add    %eax,%eax
  102a43:	01 d0                	add    %edx,%eax
  102a45:	c1 e0 02             	shl    $0x2,%eax
  102a48:	05 00 b9 11 00       	add    $0x11b900,%eax
  102a4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
} zones[MAX_ZONE_NUM] = {{NULL}};

static void
buddy_init(void) {
    int i;
    for (i = 0; i <= MAX_ORDER; i ++) {
  102a54:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102a58:	83 7d fc 0a          	cmpl   $0xa,-0x4(%ebp)
  102a5c:	7e b6                	jle    102a14 <buddy_init+0xf>
        list_init(&free_list(i));
        nr_free(i) = 0;
    }
}
  102a5e:	c9                   	leave  
  102a5f:	c3                   	ret    

00102a60 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
  102a60:	55                   	push   %ebp
  102a61:	89 e5                	mov    %esp,%ebp
  102a63:	83 ec 38             	sub    $0x38,%esp
    static int zone_num = 0;
    struct Page *p = base;
  102a66:	8b 45 08             	mov    0x8(%ebp),%eax
  102a69:	89 45 fc             	mov    %eax,-0x4(%ebp)
    for (; p != base + n; p ++) {
  102a6c:	eb 39                	jmp    102aa7 <buddy_init_memmap+0x47>
        p->flags = p->property = 0;
  102a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102a78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a7b:	8b 50 08             	mov    0x8(%eax),%edx
  102a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a81:	89 50 04             	mov    %edx,0x4(%eax)
        p->zone_num = zone_num;
  102a84:	8b 15 84 b9 11 00    	mov    0x11b984,%edx
  102a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a8d:	89 50 0c             	mov    %edx,0xc(%eax)
        set_page_ref(p, 0);
  102a90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a97:	00 
  102a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a9b:	89 04 24             	mov    %eax,(%esp)
  102a9e:	e8 55 ff ff ff       	call   1029f8 <set_page_ref>

static void
buddy_init_memmap(struct Page *base, size_t n) {
    static int zone_num = 0;
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102aa3:	83 45 fc 18          	addl   $0x18,-0x4(%ebp)
  102aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102aaa:	89 d0                	mov    %edx,%eax
  102aac:	01 c0                	add    %eax,%eax
  102aae:	01 d0                	add    %edx,%eax
  102ab0:	c1 e0 03             	shl    $0x3,%eax
  102ab3:	89 c2                	mov    %eax,%edx
  102ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab8:	01 d0                	add    %edx,%eax
  102aba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  102abd:	75 af                	jne    102a6e <buddy_init_memmap+0xe>
        p->flags = p->property = 0;
        p->zone_num = zone_num;
        set_page_ref(p, 0);
    }
    p = zones[zone_num ++].mem_base = base;
  102abf:	a1 84 b9 11 00       	mov    0x11b984,%eax
  102ac4:	8d 50 01             	lea    0x1(%eax),%edx
  102ac7:	89 15 84 b9 11 00    	mov    %edx,0x11b984
  102acd:	8b 55 08             	mov    0x8(%ebp),%edx
  102ad0:	89 14 85 c0 b8 11 00 	mov    %edx,0x11b8c0(,%eax,4)
  102ad7:	8b 04 85 c0 b8 11 00 	mov    0x11b8c0(,%eax,4),%eax
  102ade:	89 45 fc             	mov    %eax,-0x4(%ebp)
    size_t order = MAX_ORDER, order_size = (1 << order);
  102ae1:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%ebp)
  102ae8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102aeb:	ba 01 00 00 00       	mov    $0x1,%edx
  102af0:	89 c1                	mov    %eax,%ecx
  102af2:	d3 e2                	shl    %cl,%edx
  102af4:	89 d0                	mov    %edx,%eax
  102af6:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // cut
    while (n != 0) {
  102af9:	e9 dc 00 00 00       	jmp    102bda <buddy_init_memmap+0x17a>
        while (n >= order_size) {
  102afe:	e9 c4 00 00 00       	jmp    102bc7 <buddy_init_memmap+0x167>
            p->property = order;
  102b03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b06:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102b09:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  102b0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b0f:	83 c0 04             	add    $0x4,%eax
  102b12:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  102b19:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b22:	0f ab 10             	bts    %edx,(%eax)
            list_add(&free_list(order), &(p->page_link));
  102b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b28:	8d 48 10             	lea    0x10(%eax),%ecx
  102b2b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102b2e:	89 d0                	mov    %edx,%eax
  102b30:	01 c0                	add    %eax,%eax
  102b32:	01 d0                	add    %edx,%eax
  102b34:	c1 e0 02             	shl    $0x2,%eax
  102b37:	05 00 b9 11 00       	add    $0x11b900,%eax
  102b3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b3f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  102b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b51:	8b 40 04             	mov    0x4(%eax),%eax
  102b54:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b57:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102b5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b5d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102b60:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b66:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b69:	89 10                	mov    %edx,(%eax)
  102b6b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b6e:	8b 10                	mov    (%eax),%edx
  102b70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b73:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b76:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b79:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b7c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b82:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b85:	89 10                	mov    %edx,(%eax)
            n -= order_size, p += order_size;
  102b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b8a:	29 45 0c             	sub    %eax,0xc(%ebp)
  102b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b90:	89 d0                	mov    %edx,%eax
  102b92:	01 c0                	add    %eax,%eax
  102b94:	01 d0                	add    %edx,%eax
  102b96:	c1 e0 03             	shl    $0x3,%eax
  102b99:	01 45 fc             	add    %eax,-0x4(%ebp)
            nr_free(order) ++;
  102b9c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102b9f:	89 d0                	mov    %edx,%eax
  102ba1:	01 c0                	add    %eax,%eax
  102ba3:	01 d0                	add    %edx,%eax
  102ba5:	c1 e0 02             	shl    $0x2,%eax
  102ba8:	05 00 b9 11 00       	add    $0x11b900,%eax
  102bad:	8b 40 08             	mov    0x8(%eax),%eax
  102bb0:	8d 48 01             	lea    0x1(%eax),%ecx
  102bb3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102bb6:	89 d0                	mov    %edx,%eax
  102bb8:	01 c0                	add    %eax,%eax
  102bba:	01 d0                	add    %edx,%eax
  102bbc:	c1 e0 02             	shl    $0x2,%eax
  102bbf:	05 00 b9 11 00       	add    $0x11b900,%eax
  102bc4:	89 48 08             	mov    %ecx,0x8(%eax)
    p = zones[zone_num ++].mem_base = base;
    size_t order = MAX_ORDER, order_size = (1 << order);

    // cut
    while (n != 0) {
        while (n >= order_size) {
  102bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102bcd:	0f 83 30 ff ff ff    	jae    102b03 <buddy_init_memmap+0xa3>
            SetPageProperty(p);
            list_add(&free_list(order), &(p->page_link));
            n -= order_size, p += order_size;
            nr_free(order) ++;
        }
        order --;
  102bd3:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
        order_size >>= 1;
  102bd7:	d1 6d f4             	shrl   -0xc(%ebp)
    }
    p = zones[zone_num ++].mem_base = base;
    size_t order = MAX_ORDER, order_size = (1 << order);

    // cut
    while (n != 0) {
  102bda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bde:	0f 85 1a ff ff ff    	jne    102afe <buddy_init_memmap+0x9e>
            nr_free(order) ++;
        }
        order --;
        order_size >>= 1;
    }
}
  102be4:	c9                   	leave  
  102be5:	c3                   	ret    

00102be6 <getorder>:

static inline size_t
getorder(size_t n) {
  102be6:	55                   	push   %ebp
  102be7:	89 e5                	mov    %esp,%ebp
  102be9:	83 ec 10             	sub    $0x10,%esp
    size_t order, order_size;
    for (order = 0, order_size = 1; order <= MAX_ORDER; order ++, order_size <<= 1) {
  102bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102bf3:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
  102bfa:	eb 14                	jmp    102c10 <getorder+0x2a>
        if (n <= order_size) {
  102bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  102bff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  102c02:	77 05                	ja     102c09 <getorder+0x23>
            return order;
  102c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c07:	eb 0d                	jmp    102c16 <getorder+0x30>
}

static inline size_t
getorder(size_t n) {
    size_t order, order_size;
    for (order = 0, order_size = 1; order <= MAX_ORDER; order ++, order_size <<= 1) {
  102c09:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102c0d:	d1 65 f8             	shll   -0x8(%ebp)
  102c10:	83 7d fc 0a          	cmpl   $0xa,-0x4(%ebp)
  102c14:	76 e6                	jbe    102bfc <getorder+0x16>
        if (n <= order_size) {
            return order;
        }
    }
}
  102c16:	c9                   	leave  
  102c17:	c3                   	ret    

00102c18 <buddy_alloc_pages_sub>:

static inline struct Page *
buddy_alloc_pages_sub(size_t order) {
  102c18:	55                   	push   %ebp
  102c19:	89 e5                	mov    %esp,%ebp
  102c1b:	83 ec 60             	sub    $0x60,%esp
    size_t cur_order;
    for (cur_order = order; cur_order <= MAX_ORDER; cur_order ++) {
  102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c21:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102c24:	e9 b4 01 00 00       	jmp    102ddd <buddy_alloc_pages_sub+0x1c5>
        if (!list_empty(&free_list(cur_order))) {
  102c29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102c2c:	89 d0                	mov    %edx,%eax
  102c2e:	01 c0                	add    %eax,%eax
  102c30:	01 d0                	add    %edx,%eax
  102c32:	c1 e0 02             	shl    $0x2,%eax
  102c35:	05 00 b9 11 00       	add    $0x11b900,%eax
  102c3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  102c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c40:	8b 40 04             	mov    0x4(%eax),%eax
  102c43:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  102c46:	0f 94 c0             	sete   %al
  102c49:	0f b6 c0             	movzbl %al,%eax
  102c4c:	85 c0                	test   %eax,%eax
  102c4e:	0f 85 85 01 00 00    	jne    102dd9 <buddy_alloc_pages_sub+0x1c1>
            list_entry_t *le = list_next(&free_list(cur_order));
  102c54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102c57:	89 d0                	mov    %edx,%eax
  102c59:	01 c0                	add    %eax,%eax
  102c5b:	01 d0                	add    %edx,%eax
  102c5d:	c1 e0 02             	shl    $0x2,%eax
  102c60:	05 00 b9 11 00       	add    $0x11b900,%eax
  102c65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c6b:	8b 40 04             	mov    0x4(%eax),%eax
  102c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            struct Page *page = le2page(le, page_link);
  102c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c74:	83 e8 10             	sub    $0x10,%eax
  102c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
            nr_free(cur_order) --;
  102c7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102c7d:	89 d0                	mov    %edx,%eax
  102c7f:	01 c0                	add    %eax,%eax
  102c81:	01 d0                	add    %edx,%eax
  102c83:	c1 e0 02             	shl    $0x2,%eax
  102c86:	05 00 b9 11 00       	add    $0x11b900,%eax
  102c8b:	8b 40 08             	mov    0x8(%eax),%eax
  102c8e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102c91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102c94:	89 d0                	mov    %edx,%eax
  102c96:	01 c0                	add    %eax,%eax
  102c98:	01 d0                	add    %edx,%eax
  102c9a:	c1 e0 02             	shl    $0x2,%eax
  102c9d:	05 00 b9 11 00       	add    $0x11b900,%eax
  102ca2:	89 48 08             	mov    %ecx,0x8(%eax)
  102ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102cab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cae:	8b 40 04             	mov    0x4(%eax),%eax
  102cb1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102cb4:	8b 12                	mov    (%edx),%edx
  102cb6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102cb9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102cbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cbf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cc2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102cc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102cc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ccb:	89 10                	mov    %edx,(%eax)
            list_del(le);
            size_t size = 1 << cur_order;
  102ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cd0:	ba 01 00 00 00       	mov    $0x1,%edx
  102cd5:	89 c1                	mov    %eax,%ecx
  102cd7:	d3 e2                	shl    %cl,%edx
  102cd9:	89 d0                	mov    %edx,%eax
  102cdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
            while (cur_order > order) {
  102cde:	e9 cc 00 00 00       	jmp    102daf <buddy_alloc_pages_sub+0x197>
                cur_order --;
  102ce3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
                size >>= 1;
  102ce7:	d1 6d f8             	shrl   -0x8(%ebp)
                struct Page *buddy = page + size;//+
  102cea:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102ced:	89 d0                	mov    %edx,%eax
  102cef:	01 c0                	add    %eax,%eax
  102cf1:	01 d0                	add    %edx,%eax
  102cf3:	c1 e0 03             	shl    $0x3,%eax
  102cf6:	89 c2                	mov    %eax,%edx
  102cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cfb:	01 d0                	add    %edx,%eax
  102cfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
                buddy->property = cur_order;
  102d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102d06:	89 50 08             	mov    %edx,0x8(%eax)
                SetPageProperty(buddy);
  102d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d0c:	83 c0 04             	add    $0x4,%eax
  102d0f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102d16:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d1f:	0f ab 10             	bts    %edx,(%eax)
                nr_free(cur_order) ++;
  102d22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102d25:	89 d0                	mov    %edx,%eax
  102d27:	01 c0                	add    %eax,%eax
  102d29:	01 d0                	add    %edx,%eax
  102d2b:	c1 e0 02             	shl    $0x2,%eax
  102d2e:	05 00 b9 11 00       	add    $0x11b900,%eax
  102d33:	8b 40 08             	mov    0x8(%eax),%eax
  102d36:	8d 48 01             	lea    0x1(%eax),%ecx
  102d39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102d3c:	89 d0                	mov    %edx,%eax
  102d3e:	01 c0                	add    %eax,%eax
  102d40:	01 d0                	add    %edx,%eax
  102d42:	c1 e0 02             	shl    $0x2,%eax
  102d45:	05 00 b9 11 00       	add    $0x11b900,%eax
  102d4a:	89 48 08             	mov    %ecx,0x8(%eax)
                list_add(&free_list(cur_order), &(buddy->page_link));
  102d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d50:	8d 48 10             	lea    0x10(%eax),%ecx
  102d53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102d56:	89 d0                	mov    %edx,%eax
  102d58:	01 c0                	add    %eax,%eax
  102d5a:	01 d0                	add    %edx,%eax
  102d5c:	c1 e0 02             	shl    $0x2,%eax
  102d5f:	05 00 b9 11 00       	add    $0x11b900,%eax
  102d64:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102d67:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  102d6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d6d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  102d70:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d73:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102d76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d79:	8b 40 04             	mov    0x4(%eax),%eax
  102d7c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d7f:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102d82:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d85:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102d88:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102d8b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d8e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d91:	89 10                	mov    %edx,(%eax)
  102d93:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d96:	8b 10                	mov    (%eax),%edx
  102d98:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d9b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102d9e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102da1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102da4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102da7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102daa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102dad:	89 10                	mov    %edx,(%eax)
            list_entry_t *le = list_next(&free_list(cur_order));
            struct Page *page = le2page(le, page_link);
            nr_free(cur_order) --;
            list_del(le);
            size_t size = 1 << cur_order;
            while (cur_order > order) {
  102daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102db2:	3b 45 08             	cmp    0x8(%ebp),%eax
  102db5:	0f 87 28 ff ff ff    	ja     102ce3 <buddy_alloc_pages_sub+0xcb>
                buddy->property = cur_order;
                SetPageProperty(buddy);
                nr_free(cur_order) ++;
                list_add(&free_list(cur_order), &(buddy->page_link));
            }
            ClearPageProperty(page);
  102dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dbe:	83 c0 04             	add    $0x4,%eax
  102dc1:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102dc8:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dcb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102dce:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102dd1:	0f b3 10             	btr    %edx,(%eax)
            return page;
  102dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd7:	eb 13                	jmp    102dec <buddy_alloc_pages_sub+0x1d4>
}

static inline struct Page *
buddy_alloc_pages_sub(size_t order) {
    size_t cur_order;
    for (cur_order = order; cur_order <= MAX_ORDER; cur_order ++) {
  102dd9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102ddd:	83 7d fc 0a          	cmpl   $0xa,-0x4(%ebp)
  102de1:	0f 86 42 fe ff ff    	jbe    102c29 <buddy_alloc_pages_sub+0x11>
            }
            ClearPageProperty(page);
            return page;
        }
    }
    return NULL;
  102de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102dec:	c9                   	leave  
  102ded:	c3                   	ret    

00102dee <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
  102dee:	55                   	push   %ebp
  102def:	89 e5                	mov    %esp,%ebp
  102df1:	83 ec 28             	sub    $0x28,%esp
    size_t order = getorder(n), order_size = (1 << order);
  102df4:	8b 45 08             	mov    0x8(%ebp),%eax
  102df7:	89 04 24             	mov    %eax,(%esp)
  102dfa:	e8 e7 fd ff ff       	call   102be6 <getorder>
  102dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e05:	ba 01 00 00 00       	mov    $0x1,%edx
  102e0a:	89 c1                	mov    %eax,%ecx
  102e0c:	d3 e2                	shl    %cl,%edx
  102e0e:	89 d0                	mov    %edx,%eax
  102e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *page = buddy_alloc_pages_sub(order);
  102e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e16:	89 04 24             	mov    %eax,(%esp)
  102e19:	e8 fa fd ff ff       	call   102c18 <buddy_alloc_pages_sub>
  102e1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //economic
    if (page != NULL && n != order_size) {
  102e21:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e25:	74 31                	je     102e58 <buddy_alloc_pages+0x6a>
  102e27:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102e2d:	74 29                	je     102e58 <buddy_alloc_pages+0x6a>
        free_pages(page + n, order_size - n);
  102e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e35:	89 d1                	mov    %edx,%ecx
  102e37:	29 c1                	sub    %eax,%ecx
  102e39:	8b 55 08             	mov    0x8(%ebp),%edx
  102e3c:	89 d0                	mov    %edx,%eax
  102e3e:	01 c0                	add    %eax,%eax
  102e40:	01 d0                	add    %edx,%eax
  102e42:	c1 e0 03             	shl    $0x3,%eax
  102e45:	89 c2                	mov    %eax,%edx
  102e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e4a:	01 d0                	add    %edx,%eax
  102e4c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e50:	89 04 24             	mov    %eax,(%esp)
  102e53:	e8 04 23 00 00       	call   10515c <free_pages>
    }
    return page;
  102e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  102e5b:	c9                   	leave  
  102e5c:	c3                   	ret    

00102e5d <page_is_buddy>:

//page_is_buddy - Does this page belong to the No. zone_num Zone & this page
//              -  be in the continuous page block whose size is 2^order pages?
static inline bool
page_is_buddy(struct Page *page, size_t order, int zone_num) {
  102e5d:	55                   	push   %ebp
  102e5e:	89 e5                	mov    %esp,%ebp
  102e60:	83 ec 20             	sub    $0x20,%esp
        if (page->zone_num == zone_num) {
  102e63:	8b 45 08             	mov    0x8(%ebp),%eax
  102e66:	8b 40 0c             	mov    0xc(%eax),%eax
  102e69:	3b 45 10             	cmp    0x10(%ebp),%eax
  102e6c:	75 71                	jne    102edf <page_is_buddy+0x82>
            return !PageReserved(page) && PageProperty(page) && page->property == order;
  102e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e71:	83 c0 04             	add    $0x4,%eax
  102e74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102e7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102e84:	0f a3 10             	bt     %edx,(%eax)
  102e87:	19 c0                	sbb    %eax,%eax
  102e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return oldbit != 0;
  102e8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102e90:	0f 95 c0             	setne  %al
  102e93:	0f b6 c0             	movzbl %al,%eax
  102e96:	85 c0                	test   %eax,%eax
  102e98:	75 3e                	jne    102ed8 <page_is_buddy+0x7b>
  102e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9d:	83 c0 04             	add    $0x4,%eax
  102ea0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  102ea7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102eb0:	0f a3 10             	bt     %edx,(%eax)
  102eb3:	19 c0                	sbb    %eax,%eax
  102eb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102eb8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ebc:	0f 95 c0             	setne  %al
  102ebf:	0f b6 c0             	movzbl %al,%eax
  102ec2:	85 c0                	test   %eax,%eax
  102ec4:	74 12                	je     102ed8 <page_is_buddy+0x7b>
  102ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec9:	8b 40 08             	mov    0x8(%eax),%eax
  102ecc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ecf:	75 07                	jne    102ed8 <page_is_buddy+0x7b>
  102ed1:	b8 01 00 00 00       	mov    $0x1,%eax
  102ed6:	eb 05                	jmp    102edd <page_is_buddy+0x80>
  102ed8:	b8 00 00 00 00       	mov    $0x0,%eax
  102edd:	eb 05                	jmp    102ee4 <page_is_buddy+0x87>
        }
    return 0;
  102edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ee4:	c9                   	leave  
  102ee5:	c3                   	ret    

00102ee6 <page2idx>:

static inline ppn_t
page2idx(struct Page *page) {
  102ee6:	55                   	push   %ebp
  102ee7:	89 e5                	mov    %esp,%ebp
    return page - zones[page->zone_num].mem_base;
  102ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  102eec:	8b 45 08             	mov    0x8(%ebp),%eax
  102eef:	8b 40 0c             	mov    0xc(%eax),%eax
  102ef2:	8b 04 85 c0 b8 11 00 	mov    0x11b8c0(,%eax,4),%eax
  102ef9:	29 c2                	sub    %eax,%edx
  102efb:	89 d0                	mov    %edx,%eax
  102efd:	c1 f8 03             	sar    $0x3,%eax
  102f00:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
  102f06:	5d                   	pop    %ebp
  102f07:	c3                   	ret    

00102f08 <idx2page>:

static inline struct Page *
idx2page(int zone_num, ppn_t idx) {
  102f08:	55                   	push   %ebp
  102f09:	89 e5                	mov    %esp,%ebp
    return zones[zone_num].mem_base + idx;
  102f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0e:	8b 0c 85 c0 b8 11 00 	mov    0x11b8c0(,%eax,4),%ecx
  102f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f18:	89 d0                	mov    %edx,%eax
  102f1a:	01 c0                	add    %eax,%eax
  102f1c:	01 d0                	add    %edx,%eax
  102f1e:	c1 e0 03             	shl    $0x3,%eax
  102f21:	01 c8                	add    %ecx,%eax
}
  102f23:	5d                   	pop    %ebp
  102f24:	c3                   	ret    

00102f25 <buddy_free_pages_sub>:


static void
buddy_free_pages_sub(struct Page *base, size_t order) {
  102f25:	55                   	push   %ebp
  102f26:	89 e5                	mov    %esp,%ebp
  102f28:	83 ec 5c             	sub    $0x5c,%esp
    ppn_t buddy_idx, page_idx = page2idx(base);
  102f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2e:	89 04 24             	mov    %eax,(%esp)
  102f31:	e8 b0 ff ff ff       	call   102ee6 <page2idx>
  102f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct Page *p = base;
  102f39:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for (; p != base + (1 << order); p ++) {
  102f3f:	eb 21                	jmp    102f62 <buddy_free_pages_sub+0x3d>
        p->flags = 0;
  102f41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102f4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102f52:	00 
  102f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f56:	89 04 24             	mov    %eax,(%esp)
  102f59:	e8 9a fa ff ff       	call   1029f8 <set_page_ref>

static void
buddy_free_pages_sub(struct Page *base, size_t order) {
    ppn_t buddy_idx, page_idx = page2idx(base);
    struct Page *p = base;
    for (; p != base + (1 << order); p ++) {
  102f5e:	83 45 f8 18          	addl   $0x18,-0x8(%ebp)
  102f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f65:	ba 18 00 00 00       	mov    $0x18,%edx
  102f6a:	89 c1                	mov    %eax,%ecx
  102f6c:	d3 e2                	shl    %cl,%edx
  102f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f71:	01 d0                	add    %edx,%eax
  102f73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  102f76:	75 c9                	jne    102f41 <buddy_free_pages_sub+0x1c>
        p->flags = 0;
        set_page_ref(p, 0);
    }
    int zone_num = base->zone_num;
  102f78:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  102f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (order < MAX_ORDER) {
  102f81:	e9 c4 00 00 00       	jmp    10304a <buddy_free_pages_sub+0x125>
    	//amazing
        buddy_idx = page_idx ^ (1 << order);
  102f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f89:	ba 01 00 00 00       	mov    $0x1,%edx
  102f8e:	89 c1                	mov    %eax,%ecx
  102f90:	d3 e2                	shl    %cl,%edx
  102f92:	89 d0                	mov    %edx,%eax
  102f94:	33 45 fc             	xor    -0x4(%ebp),%eax
  102f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
        struct Page *buddy = idx2page(zone_num, buddy_idx);
  102f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fa4:	89 04 24             	mov    %eax,(%esp)
  102fa7:	e8 5c ff ff ff       	call   102f08 <idx2page>
  102fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (!page_is_buddy(buddy, order, zone_num)) {
  102faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc0:	89 04 24             	mov    %eax,(%esp)
  102fc3:	e8 95 fe ff ff       	call   102e5d <page_is_buddy>
  102fc8:	85 c0                	test   %eax,%eax
  102fca:	75 05                	jne    102fd1 <buddy_free_pages_sub+0xac>
            break;
  102fcc:	e9 83 00 00 00       	jmp    103054 <buddy_free_pages_sub+0x12f>
        }
        nr_free(order) --;
  102fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  102fd4:	89 d0                	mov    %edx,%eax
  102fd6:	01 c0                	add    %eax,%eax
  102fd8:	01 d0                	add    %edx,%eax
  102fda:	c1 e0 02             	shl    $0x2,%eax
  102fdd:	05 00 b9 11 00       	add    $0x11b900,%eax
  102fe2:	8b 40 08             	mov    0x8(%eax),%eax
  102fe5:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  102feb:	89 d0                	mov    %edx,%eax
  102fed:	01 c0                	add    %eax,%eax
  102fef:	01 d0                	add    %edx,%eax
  102ff1:	c1 e0 02             	shl    $0x2,%eax
  102ff4:	05 00 b9 11 00       	add    $0x11b900,%eax
  102ff9:	89 48 08             	mov    %ecx,0x8(%eax)
        list_del(&(buddy->page_link));
  102ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fff:	83 c0 10             	add    $0x10,%eax
  103002:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  103005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103008:	8b 40 04             	mov    0x4(%eax),%eax
  10300b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10300e:	8b 12                	mov    (%edx),%edx
  103010:	89 55 e0             	mov    %edx,-0x20(%ebp)
  103013:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  103016:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103019:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10301c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10301f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103022:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103025:	89 10                	mov    %edx,(%eax)
        ClearPageProperty(buddy);
  103027:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10302a:	83 c0 04             	add    $0x4,%eax
  10302d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  103034:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103037:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10303a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10303d:	0f b3 10             	btr    %edx,(%eax)
        page_idx &= buddy_idx;
  103040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103043:	21 45 fc             	and    %eax,-0x4(%ebp)
        order ++;
  103046:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    for (; p != base + (1 << order); p ++) {
        p->flags = 0;
        set_page_ref(p, 0);
    }
    int zone_num = base->zone_num;
    while (order < MAX_ORDER) {
  10304a:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
  10304e:	0f 86 32 ff ff ff    	jbe    102f86 <buddy_free_pages_sub+0x61>
        list_del(&(buddy->page_link));
        ClearPageProperty(buddy);
        page_idx &= buddy_idx;
        order ++;
    }
    struct Page *page = idx2page(zone_num, page_idx);
  103054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103057:	89 44 24 04          	mov    %eax,0x4(%esp)
  10305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10305e:	89 04 24             	mov    %eax,(%esp)
  103061:	e8 a2 fe ff ff       	call   102f08 <idx2page>
  103066:	89 45 e8             	mov    %eax,-0x18(%ebp)
    page->property = order;
  103069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10306c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10306f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(page);
  103072:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103075:	83 c0 04             	add    $0x4,%eax
  103078:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10307f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103082:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103085:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103088:	0f ab 10             	bts    %edx,(%eax)
    nr_free(order) ++;
  10308b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10308e:	89 d0                	mov    %edx,%eax
  103090:	01 c0                	add    %eax,%eax
  103092:	01 d0                	add    %edx,%eax
  103094:	c1 e0 02             	shl    $0x2,%eax
  103097:	05 00 b9 11 00       	add    $0x11b900,%eax
  10309c:	8b 40 08             	mov    0x8(%eax),%eax
  10309f:	8d 48 01             	lea    0x1(%eax),%ecx
  1030a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030a5:	89 d0                	mov    %edx,%eax
  1030a7:	01 c0                	add    %eax,%eax
  1030a9:	01 d0                	add    %edx,%eax
  1030ab:	c1 e0 02             	shl    $0x2,%eax
  1030ae:	05 00 b9 11 00       	add    $0x11b900,%eax
  1030b3:	89 48 08             	mov    %ecx,0x8(%eax)
    list_add(&free_list(order), &(page->page_link));
  1030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030b9:	8d 48 10             	lea    0x10(%eax),%ecx
  1030bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030bf:	89 d0                	mov    %edx,%eax
  1030c1:	01 c0                	add    %eax,%eax
  1030c3:	01 d0                	add    %edx,%eax
  1030c5:	c1 e0 02             	shl    $0x2,%eax
  1030c8:	05 00 b9 11 00       	add    $0x11b900,%eax
  1030cd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1030d0:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  1030d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030d6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1030d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1030dc:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1030df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1030e2:	8b 40 04             	mov    0x4(%eax),%eax
  1030e5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1030e8:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1030eb:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1030ee:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  1030f1:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1030f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1030f7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1030fa:	89 10                	mov    %edx,(%eax)
  1030fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1030ff:	8b 10                	mov    (%eax),%edx
  103101:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103104:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103107:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10310a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10310d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103110:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103113:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103116:	89 10                	mov    %edx,(%eax)
}
  103118:	c9                   	leave  
  103119:	c3                   	ret    

0010311a <buddy_free_pages>:

//根据分配模块的调用，释放模块释放的大小不一定是2的幂的大小
static void
buddy_free_pages(struct Page *base, size_t n) {
  10311a:	55                   	push   %ebp
  10311b:	89 e5                	mov    %esp,%ebp
  10311d:	83 ec 18             	sub    $0x18,%esp
    if (n == 1) {
  103120:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103124:	75 18                	jne    10313e <buddy_free_pages+0x24>
        buddy_free_pages_sub(base, 0);
  103126:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10312d:	00 
  10312e:	8b 45 08             	mov    0x8(%ebp),%eax
  103131:	89 04 24             	mov    %eax,(%esp)
  103134:	e8 ec fd ff ff       	call   102f25 <buddy_free_pages_sub>
  103139:	e9 98 00 00 00       	jmp    1031d6 <buddy_free_pages+0xbc>
    }
    else {
        size_t order = 0, order_size = 1;
  10313e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  103145:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
        while (n >= order_size) {
  10314c:	eb 40                	jmp    10318e <buddy_free_pages+0x74>
            if ((page2idx(base) & order_size) != 0) {
  10314e:	8b 45 08             	mov    0x8(%ebp),%eax
  103151:	89 04 24             	mov    %eax,(%esp)
  103154:	e8 8d fd ff ff       	call   102ee6 <page2idx>
  103159:	23 45 f8             	and    -0x8(%ebp),%eax
  10315c:	85 c0                	test   %eax,%eax
  10315e:	74 27                	je     103187 <buddy_free_pages+0x6d>
                buddy_free_pages_sub(base, order);
  103160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103163:	89 44 24 04          	mov    %eax,0x4(%esp)
  103167:	8b 45 08             	mov    0x8(%ebp),%eax
  10316a:	89 04 24             	mov    %eax,(%esp)
  10316d:	e8 b3 fd ff ff       	call   102f25 <buddy_free_pages_sub>
                base += order_size;
  103172:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103175:	89 d0                	mov    %edx,%eax
  103177:	01 c0                	add    %eax,%eax
  103179:	01 d0                	add    %edx,%eax
  10317b:	c1 e0 03             	shl    $0x3,%eax
  10317e:	01 45 08             	add    %eax,0x8(%ebp)
                n -= order_size;
  103181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103184:	29 45 0c             	sub    %eax,0xc(%ebp)
            }
            order ++;
  103187:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
            order_size <<= 1;
  10318b:	d1 65 f8             	shll   -0x8(%ebp)
    if (n == 1) {
        buddy_free_pages_sub(base, 0);
    }
    else {
        size_t order = 0, order_size = 1;
        while (n >= order_size) {
  10318e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103191:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  103194:	73 b8                	jae    10314e <buddy_free_pages+0x34>
                n -= order_size;
            }
            order ++;
            order_size <<= 1;
        }
        while (n != 0) {
  103196:	eb 38                	jmp    1031d0 <buddy_free_pages+0xb6>
            while (n < order_size) {
  103198:	eb 07                	jmp    1031a1 <buddy_free_pages+0x87>
                order --;
  10319a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
                order_size >>= 1;
  10319e:	d1 6d f8             	shrl   -0x8(%ebp)
            }
            order ++;
            order_size <<= 1;
        }
        while (n != 0) {
            while (n < order_size) {
  1031a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1031a7:	72 f1                	jb     10319a <buddy_free_pages+0x80>
                order --;
                order_size >>= 1;
            }
            buddy_free_pages_sub(base, order);
  1031a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b3:	89 04 24             	mov    %eax,(%esp)
  1031b6:	e8 6a fd ff ff       	call   102f25 <buddy_free_pages_sub>
            base += order_size;
  1031bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1031be:	89 d0                	mov    %edx,%eax
  1031c0:	01 c0                	add    %eax,%eax
  1031c2:	01 d0                	add    %edx,%eax
  1031c4:	c1 e0 03             	shl    $0x3,%eax
  1031c7:	01 45 08             	add    %eax,0x8(%ebp)
            n -= order_size;
  1031ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1031cd:	29 45 0c             	sub    %eax,0xc(%ebp)
                n -= order_size;
            }
            order ++;
            order_size <<= 1;
        }
        while (n != 0) {
  1031d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031d4:	75 c2                	jne    103198 <buddy_free_pages+0x7e>
            buddy_free_pages_sub(base, order);
            base += order_size;
            n -= order_size;
        }
    }
}
  1031d6:	c9                   	leave  
  1031d7:	c3                   	ret    

001031d8 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  1031d8:	55                   	push   %ebp
  1031d9:	89 e5                	mov    %esp,%ebp
  1031db:	83 ec 10             	sub    $0x10,%esp
    size_t ret = 0, order = 0;
  1031de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1031e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for (; order <= MAX_ORDER; order ++) {
  1031ec:	eb 24                	jmp    103212 <buddy_nr_free_pages+0x3a>
        ret += nr_free(order) * (1 << order);
  1031ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1031f1:	89 d0                	mov    %edx,%eax
  1031f3:	01 c0                	add    %eax,%eax
  1031f5:	01 d0                	add    %edx,%eax
  1031f7:	c1 e0 02             	shl    $0x2,%eax
  1031fa:	05 00 b9 11 00       	add    $0x11b900,%eax
  1031ff:	8b 50 08             	mov    0x8(%eax),%edx
  103202:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103205:	89 c1                	mov    %eax,%ecx
  103207:	d3 e2                	shl    %cl,%edx
  103209:	89 d0                	mov    %edx,%eax
  10320b:	01 45 fc             	add    %eax,-0x4(%ebp)
}

static size_t
buddy_nr_free_pages(void) {
    size_t ret = 0, order = 0;
    for (; order <= MAX_ORDER; order ++) {
  10320e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  103212:	83 7d f8 0a          	cmpl   $0xa,-0x8(%ebp)
  103216:	76 d6                	jbe    1031ee <buddy_nr_free_pages+0x16>
        ret += nr_free(order) * (1 << order);
    }
    return ret;
  103218:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10321b:	c9                   	leave  
  10321c:	c3                   	ret    

0010321d <buddy_check>:


static void
buddy_check(void) {
  10321d:	55                   	push   %ebp
  10321e:	89 e5                	mov    %esp,%ebp
  103220:	53                   	push   %ebx
  103221:	81 ec 54 01 00 00    	sub    $0x154,%esp
    int i;
    int count = 0, total = 0;
  103227:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10322e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (i = 0; i <= MAX_ORDER; i ++) {
  103235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10323c:	e9 b6 00 00 00       	jmp    1032f7 <buddy_check+0xda>
        list_entry_t *list = &free_list(i), *le = list;
  103241:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103244:	89 d0                	mov    %edx,%eax
  103246:	01 c0                	add    %eax,%eax
  103248:	01 d0                	add    %edx,%eax
  10324a:	c1 e0 02             	shl    $0x2,%eax
  10324d:	05 00 b9 11 00       	add    $0x11b900,%eax
  103252:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103255:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103258:	89 45 e8             	mov    %eax,-0x18(%ebp)
        while ((le = list_next(le)) != list) {
  10325b:	eb 7b                	jmp    1032d8 <buddy_check+0xbb>
            struct Page *p = le2page(le, page_link);
  10325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103260:	83 e8 10             	sub    $0x10,%eax
  103263:	89 45 dc             	mov    %eax,-0x24(%ebp)
            assert(PageProperty(p) && p->property == i);
  103266:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103269:	83 c0 04             	add    $0x4,%eax
  10326c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  103273:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103276:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103279:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10327c:	0f a3 10             	bt     %edx,(%eax)
  10327f:	19 c0                	sbb    %eax,%eax
  103281:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
  103284:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103288:	0f 95 c0             	setne  %al
  10328b:	0f b6 c0             	movzbl %al,%eax
  10328e:	85 c0                	test   %eax,%eax
  103290:	74 0d                	je     10329f <buddy_check+0x82>
  103292:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103295:	8b 50 08             	mov    0x8(%eax),%edx
  103298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329b:	39 c2                	cmp    %eax,%edx
  10329d:	74 24                	je     1032c3 <buddy_check+0xa6>
  10329f:	c7 44 24 0c f0 7a 10 	movl   $0x107af0,0xc(%esp)
  1032a6:	00 
  1032a7:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  1032ae:	00 
  1032af:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  1032b6:	00 
  1032b7:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1032be:	e8 0e da ff ff       	call   100cd1 <__panic>
            count ++, total += (1 << i);
  1032c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  1032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032ca:	ba 01 00 00 00       	mov    $0x1,%edx
  1032cf:	89 c1                	mov    %eax,%ecx
  1032d1:	d3 e2                	shl    %cl,%edx
  1032d3:	89 d0                	mov    %edx,%eax
  1032d5:	01 45 ec             	add    %eax,-0x14(%ebp)
  1032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032db:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1032de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1032e1:	8b 40 04             	mov    0x4(%eax),%eax
buddy_check(void) {
    int i;
    int count = 0, total = 0;
    for (i = 0; i <= MAX_ORDER; i ++) {
        list_entry_t *list = &free_list(i), *le = list;
        while ((le = list_next(le)) != list) {
  1032e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ea:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  1032ed:	0f 85 6a ff ff ff    	jne    10325d <buddy_check+0x40>

static void
buddy_check(void) {
    int i;
    int count = 0, total = 0;
    for (i = 0; i <= MAX_ORDER; i ++) {
  1032f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1032f7:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  1032fb:	0f 8e 40 ff ff ff    	jle    103241 <buddy_check+0x24>
            struct Page *p = le2page(le, page_link);
            assert(PageProperty(p) && p->property == i);
            count ++, total += (1 << i);
        }
    }
    assert(total == nr_free_pages());
  103301:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  103304:	e8 85 1e 00 00       	call   10518e <nr_free_pages>
  103309:	39 c3                	cmp    %eax,%ebx
  10330b:	74 24                	je     103331 <buddy_check+0x114>
  10330d:	c7 44 24 0c 3d 7b 10 	movl   $0x107b3d,0xc(%esp)
  103314:	00 
  103315:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  10331c:	00 
  10331d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  103324:	00 
  103325:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  10332c:	e8 a0 d9 ff ff       	call   100cd1 <__panic>

    struct Page *p0 = alloc_pages(8), *buddy = alloc_pages(8), *p1;
  103331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  103338:	e8 e7 1d 00 00       	call   105124 <alloc_pages>
  10333d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  103340:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  103347:	e8 d8 1d 00 00       	call   105124 <alloc_pages>
  10334c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    assert(p0 != NULL);
  10334f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  103353:	75 24                	jne    103379 <buddy_check+0x15c>
  103355:	c7 44 24 0c 56 7b 10 	movl   $0x107b56,0xc(%esp)
  10335c:	00 
  10335d:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103364:	00 
  103365:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  10336c:	00 
  10336d:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103374:	e8 58 d9 ff ff       	call   100cd1 <__panic>
    assert((page2idx(p0) & 7) == 0);
  103379:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10337c:	89 04 24             	mov    %eax,(%esp)
  10337f:	e8 62 fb ff ff       	call   102ee6 <page2idx>
  103384:	83 e0 07             	and    $0x7,%eax
  103387:	85 c0                	test   %eax,%eax
  103389:	74 24                	je     1033af <buddy_check+0x192>
  10338b:	c7 44 24 0c 61 7b 10 	movl   $0x107b61,0xc(%esp)
  103392:	00 
  103393:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  10339a:	00 
  10339b:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  1033a2:	00 
  1033a3:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1033aa:	e8 22 d9 ff ff       	call   100cd1 <__panic>
    assert(!PageProperty(p0));
  1033af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1033b2:	83 c0 04             	add    $0x4,%eax
  1033b5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  1033bc:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1033c2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1033c5:	0f a3 10             	bt     %edx,(%eax)
  1033c8:	19 c0                	sbb    %eax,%eax
  1033ca:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
  1033cd:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  1033d1:	0f 95 c0             	setne  %al
  1033d4:	0f b6 c0             	movzbl %al,%eax
  1033d7:	85 c0                	test   %eax,%eax
  1033d9:	74 24                	je     1033ff <buddy_check+0x1e2>
  1033db:	c7 44 24 0c 79 7b 10 	movl   $0x107b79,0xc(%esp)
  1033e2:	00 
  1033e3:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  1033ea:	00 
  1033eb:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  1033f2:	00 
  1033f3:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1033fa:	e8 d2 d8 ff ff       	call   100cd1 <__panic>

    list_entry_t free_lists_store[MAX_ORDER + 1];
    unsigned int nr_free_store[MAX_ORDER + 1];

    for (i = 0; i <= MAX_ORDER; i ++) {
  1033ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103406:	e9 d4 00 00 00       	jmp    1034df <buddy_check+0x2c2>
        free_lists_store[i] = free_list(i);
  10340b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  10340e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103411:	89 d0                	mov    %edx,%eax
  103413:	01 c0                	add    %eax,%eax
  103415:	01 d0                	add    %edx,%eax
  103417:	c1 e0 02             	shl    $0x2,%eax
  10341a:	05 00 b9 11 00       	add    $0x11b900,%eax
  10341f:	8b 50 04             	mov    0x4(%eax),%edx
  103422:	8b 00                	mov    (%eax),%eax
  103424:	89 84 cd e8 fe ff ff 	mov    %eax,-0x118(%ebp,%ecx,8)
  10342b:	89 94 cd ec fe ff ff 	mov    %edx,-0x114(%ebp,%ecx,8)
        list_init(&free_list(i));
  103432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103435:	89 d0                	mov    %edx,%eax
  103437:	01 c0                	add    %eax,%eax
  103439:	01 d0                	add    %edx,%eax
  10343b:	c1 e0 02             	shl    $0x2,%eax
  10343e:	05 00 b9 11 00       	add    $0x11b900,%eax
  103443:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103446:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103449:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10344c:	89 50 04             	mov    %edx,0x4(%eax)
  10344f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103452:	8b 50 04             	mov    0x4(%eax),%edx
  103455:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103458:	89 10                	mov    %edx,(%eax)
        assert(list_empty(&free_list(i)));
  10345a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10345d:	89 d0                	mov    %edx,%eax
  10345f:	01 c0                	add    %eax,%eax
  103461:	01 d0                	add    %edx,%eax
  103463:	c1 e0 02             	shl    $0x2,%eax
  103466:	05 00 b9 11 00       	add    $0x11b900,%eax
  10346b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10346e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103471:	8b 40 04             	mov    0x4(%eax),%eax
  103474:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
  103477:	0f 94 c0             	sete   %al
  10347a:	0f b6 c0             	movzbl %al,%eax
  10347d:	85 c0                	test   %eax,%eax
  10347f:	75 24                	jne    1034a5 <buddy_check+0x288>
  103481:	c7 44 24 0c 8b 7b 10 	movl   $0x107b8b,0xc(%esp)
  103488:	00 
  103489:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103490:	00 
  103491:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  103498:	00 
  103499:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1034a0:	e8 2c d8 ff ff       	call   100cd1 <__panic>
        nr_free_store[i] = nr_free(i);
  1034a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034a8:	89 d0                	mov    %edx,%eax
  1034aa:	01 c0                	add    %eax,%eax
  1034ac:	01 d0                	add    %edx,%eax
  1034ae:	c1 e0 02             	shl    $0x2,%eax
  1034b1:	05 00 b9 11 00       	add    $0x11b900,%eax
  1034b6:	8b 50 08             	mov    0x8(%eax),%edx
  1034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034bc:	89 94 85 bc fe ff ff 	mov    %edx,-0x144(%ebp,%eax,4)
        nr_free(i) = 0;
  1034c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034c6:	89 d0                	mov    %edx,%eax
  1034c8:	01 c0                	add    %eax,%eax
  1034ca:	01 d0                	add    %edx,%eax
  1034cc:	c1 e0 02             	shl    $0x2,%eax
  1034cf:	05 00 b9 11 00       	add    $0x11b900,%eax
  1034d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    assert(!PageProperty(p0));

    list_entry_t free_lists_store[MAX_ORDER + 1];
    unsigned int nr_free_store[MAX_ORDER + 1];

    for (i = 0; i <= MAX_ORDER; i ++) {
  1034db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1034df:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  1034e3:	0f 8e 22 ff ff ff    	jle    10340b <buddy_check+0x1ee>
        assert(list_empty(&free_list(i)));
        nr_free_store[i] = nr_free(i);
        nr_free(i) = 0;
    }

    assert(nr_free_pages() == 0);
  1034e9:	e8 a0 1c 00 00       	call   10518e <nr_free_pages>
  1034ee:	85 c0                	test   %eax,%eax
  1034f0:	74 24                	je     103516 <buddy_check+0x2f9>
  1034f2:	c7 44 24 0c a5 7b 10 	movl   $0x107ba5,0xc(%esp)
  1034f9:	00 
  1034fa:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103501:	00 
  103502:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  103509:	00 
  10350a:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103511:	e8 bb d7 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  103516:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10351d:	e8 02 1c 00 00       	call   105124 <alloc_pages>
  103522:	85 c0                	test   %eax,%eax
  103524:	74 24                	je     10354a <buddy_check+0x32d>
  103526:	c7 44 24 0c ba 7b 10 	movl   $0x107bba,0xc(%esp)
  10352d:	00 
  10352e:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103535:	00 
  103536:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  10353d:	00 
  10353e:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103545:	e8 87 d7 ff ff       	call   100cd1 <__panic>
    free_pages(p0, 8);
  10354a:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  103551:	00 
  103552:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103555:	89 04 24             	mov    %eax,(%esp)
  103558:	e8 ff 1b 00 00       	call   10515c <free_pages>
    assert(nr_free_pages() == 8);
  10355d:	e8 2c 1c 00 00       	call   10518e <nr_free_pages>
  103562:	83 f8 08             	cmp    $0x8,%eax
  103565:	74 24                	je     10358b <buddy_check+0x36e>
  103567:	c7 44 24 0c cf 7b 10 	movl   $0x107bcf,0xc(%esp)
  10356e:	00 
  10356f:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103576:	00 
  103577:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  10357e:	00 
  10357f:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103586:	e8 46 d7 ff ff       	call   100cd1 <__panic>
    assert(PageProperty(p0) && p0->property == 3);
  10358b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10358e:	83 c0 04             	add    $0x4,%eax
  103591:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103598:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10359b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10359e:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1035a1:	0f a3 10             	bt     %edx,(%eax)
  1035a4:	19 c0                	sbb    %eax,%eax
  1035a6:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1035a9:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1035ad:	0f 95 c0             	setne  %al
  1035b0:	0f b6 c0             	movzbl %al,%eax
  1035b3:	85 c0                	test   %eax,%eax
  1035b5:	74 0b                	je     1035c2 <buddy_check+0x3a5>
  1035b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1035ba:	8b 40 08             	mov    0x8(%eax),%eax
  1035bd:	83 f8 03             	cmp    $0x3,%eax
  1035c0:	74 24                	je     1035e6 <buddy_check+0x3c9>
  1035c2:	c7 44 24 0c e4 7b 10 	movl   $0x107be4,0xc(%esp)
  1035c9:	00 
  1035ca:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  1035d1:	00 
  1035d2:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  1035d9:	00 
  1035da:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1035e1:	e8 eb d6 ff ff       	call   100cd1 <__panic>
    assert((p0 = alloc_pages(6)) != NULL && !PageProperty(p0) && nr_free_pages() == 2);
  1035e6:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  1035ed:	e8 32 1b 00 00       	call   105124 <alloc_pages>
  1035f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1035f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1035f9:	74 36                	je     103631 <buddy_check+0x414>
  1035fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1035fe:	83 c0 04             	add    $0x4,%eax
  103601:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103608:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10360b:	8b 45 90             	mov    -0x70(%ebp),%eax
  10360e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103611:	0f a3 10             	bt     %edx,(%eax)
  103614:	19 c0                	sbb    %eax,%eax
  103616:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103619:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10361d:	0f 95 c0             	setne  %al
  103620:	0f b6 c0             	movzbl %al,%eax
  103623:	85 c0                	test   %eax,%eax
  103625:	75 0a                	jne    103631 <buddy_check+0x414>
  103627:	e8 62 1b 00 00       	call   10518e <nr_free_pages>
  10362c:	83 f8 02             	cmp    $0x2,%eax
  10362f:	74 24                	je     103655 <buddy_check+0x438>
  103631:	c7 44 24 0c 0c 7c 10 	movl   $0x107c0c,0xc(%esp)
  103638:	00 
  103639:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103640:	00 
  103641:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  103648:	00 
  103649:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103650:	e8 7c d6 ff ff       	call   100cd1 <__panic>

    assert((p1 = alloc_pages(2)) != NULL && p1 == p0 + 6);
  103655:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10365c:	e8 c3 1a 00 00       	call   105124 <alloc_pages>
  103661:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103664:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  103668:	74 0d                	je     103677 <buddy_check+0x45a>
  10366a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10366d:	05 90 00 00 00       	add    $0x90,%eax
  103672:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103675:	74 24                	je     10369b <buddy_check+0x47e>
  103677:	c7 44 24 0c 58 7c 10 	movl   $0x107c58,0xc(%esp)
  10367e:	00 
  10367f:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103686:	00 
  103687:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  10368e:	00 
  10368f:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103696:	e8 36 d6 ff ff       	call   100cd1 <__panic>
    assert(nr_free_pages() == 0);
  10369b:	e8 ee 1a 00 00       	call   10518e <nr_free_pages>
  1036a0:	85 c0                	test   %eax,%eax
  1036a2:	74 24                	je     1036c8 <buddy_check+0x4ab>
  1036a4:	c7 44 24 0c a5 7b 10 	movl   $0x107ba5,0xc(%esp)
  1036ab:	00 
  1036ac:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  1036b3:	00 
  1036b4:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1036bb:	00 
  1036bc:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1036c3:	e8 09 d6 ff ff       	call   100cd1 <__panic>

    free_pages(p0, 3);
  1036c8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036cf:	00 
  1036d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1036d3:	89 04 24             	mov    %eax,(%esp)
  1036d6:	e8 81 1a 00 00       	call   10515c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1036de:	83 c0 04             	add    $0x4,%eax
  1036e1:	c7 45 88 01 00 00 00 	movl   $0x1,-0x78(%ebp)
  1036e8:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036eb:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1036ee:	8b 55 88             	mov    -0x78(%ebp),%edx
  1036f1:	0f a3 10             	bt     %edx,(%eax)
  1036f4:	19 c0                	sbb    %eax,%eax
  1036f6:	89 45 80             	mov    %eax,-0x80(%ebp)
    return oldbit != 0;
  1036f9:	83 7d 80 00          	cmpl   $0x0,-0x80(%ebp)
  1036fd:	0f 95 c0             	setne  %al
  103700:	0f b6 c0             	movzbl %al,%eax
  103703:	85 c0                	test   %eax,%eax
  103705:	74 0b                	je     103712 <buddy_check+0x4f5>
  103707:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10370a:	8b 40 08             	mov    0x8(%eax),%eax
  10370d:	83 f8 01             	cmp    $0x1,%eax
  103710:	74 24                	je     103736 <buddy_check+0x519>
  103712:	c7 44 24 0c 88 7c 10 	movl   $0x107c88,0xc(%esp)
  103719:	00 
  10371a:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103721:	00 
  103722:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  103729:	00 
  10372a:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103731:	e8 9b d5 ff ff       	call   100cd1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 0);
  103736:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103739:	83 c0 30             	add    $0x30,%eax
  10373c:	83 c0 04             	add    $0x4,%eax
  10373f:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
  103746:	00 00 00 
  103749:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10374f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  103755:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  10375b:	0f a3 10             	bt     %edx,(%eax)
  10375e:	19 c0                	sbb    %eax,%eax
  103760:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    return oldbit != 0;
  103766:	83 bd 74 ff ff ff 00 	cmpl   $0x0,-0x8c(%ebp)
  10376d:	0f 95 c0             	setne  %al
  103770:	0f b6 c0             	movzbl %al,%eax
  103773:	85 c0                	test   %eax,%eax
  103775:	74 0d                	je     103784 <buddy_check+0x567>
  103777:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10377a:	83 c0 30             	add    $0x30,%eax
  10377d:	8b 40 08             	mov    0x8(%eax),%eax
  103780:	85 c0                	test   %eax,%eax
  103782:	74 24                	je     1037a8 <buddy_check+0x58b>
  103784:	c7 44 24 0c b0 7c 10 	movl   $0x107cb0,0xc(%esp)
  10378b:	00 
  10378c:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103793:	00 
  103794:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10379b:	00 
  10379c:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1037a3:	e8 29 d5 ff ff       	call   100cd1 <__panic>

    free_pages(p0 + 3, 3);
  1037a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037ab:	83 c0 48             	add    $0x48,%eax
  1037ae:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037b5:	00 
  1037b6:	89 04 24             	mov    %eax,(%esp)
  1037b9:	e8 9e 19 00 00       	call   10515c <free_pages>
    free_pages(p1, 2);
  1037be:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1037c5:	00 
  1037c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1037c9:	89 04 24             	mov    %eax,(%esp)
  1037cc:	e8 8b 19 00 00       	call   10515c <free_pages>

    assert(PageProperty(p0) && p0->property == 3);
  1037d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037d4:	83 c0 04             	add    $0x4,%eax
  1037d7:	c7 85 70 ff ff ff 01 	movl   $0x1,-0x90(%ebp)
  1037de:	00 00 00 
  1037e1:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037e7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  1037ed:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  1037f3:	0f a3 10             	bt     %edx,(%eax)
  1037f6:	19 c0                	sbb    %eax,%eax
  1037f8:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
    return oldbit != 0;
  1037fe:	83 bd 68 ff ff ff 00 	cmpl   $0x0,-0x98(%ebp)
  103805:	0f 95 c0             	setne  %al
  103808:	0f b6 c0             	movzbl %al,%eax
  10380b:	85 c0                	test   %eax,%eax
  10380d:	74 0b                	je     10381a <buddy_check+0x5fd>
  10380f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103812:	8b 40 08             	mov    0x8(%eax),%eax
  103815:	83 f8 03             	cmp    $0x3,%eax
  103818:	74 24                	je     10383e <buddy_check+0x621>
  10381a:	c7 44 24 0c e4 7b 10 	movl   $0x107be4,0xc(%esp)
  103821:	00 
  103822:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103829:	00 
  10382a:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103831:	00 
  103832:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103839:	e8 93 d4 ff ff       	call   100cd1 <__panic>

    assert((p0 = alloc_pages(6)) != NULL);
  10383e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  103845:	e8 da 18 00 00       	call   105124 <alloc_pages>
  10384a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10384d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  103851:	75 24                	jne    103877 <buddy_check+0x65a>
  103853:	c7 44 24 0c dc 7c 10 	movl   $0x107cdc,0xc(%esp)
  10385a:	00 
  10385b:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103862:	00 
  103863:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  10386a:	00 
  10386b:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103872:	e8 5a d4 ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_pages(2)) != NULL);
  103877:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10387e:	e8 a1 18 00 00       	call   105124 <alloc_pages>
  103883:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103886:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  10388a:	75 24                	jne    1038b0 <buddy_check+0x693>
  10388c:	c7 44 24 0c fa 7c 10 	movl   $0x107cfa,0xc(%esp)
  103893:	00 
  103894:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  10389b:	00 
  10389c:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1038a3:	00 
  1038a4:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1038ab:	e8 21 d4 ff ff       	call   100cd1 <__panic>
    free_pages(p0 + 4, 2);
  1038b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038b3:	83 c0 60             	add    $0x60,%eax
  1038b6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1038bd:	00 
  1038be:	89 04 24             	mov    %eax,(%esp)
  1038c1:	e8 96 18 00 00       	call   10515c <free_pages>
    free_pages(p1, 2);
  1038c6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1038cd:	00 
  1038ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1038d1:	89 04 24             	mov    %eax,(%esp)
  1038d4:	e8 83 18 00 00       	call   10515c <free_pages>

    p1 = p0 + 4;
  1038d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038dc:	83 c0 60             	add    $0x60,%eax
  1038df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    assert(PageProperty(p1) && p1->property == 2);
  1038e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1038e5:	83 c0 04             	add    $0x4,%eax
  1038e8:	c7 85 64 ff ff ff 01 	movl   $0x1,-0x9c(%ebp)
  1038ef:	00 00 00 
  1038f2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1038f8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  1038fe:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  103904:	0f a3 10             	bt     %edx,(%eax)
  103907:	19 c0                	sbb    %eax,%eax
  103909:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    return oldbit != 0;
  10390f:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
  103916:	0f 95 c0             	setne  %al
  103919:	0f b6 c0             	movzbl %al,%eax
  10391c:	85 c0                	test   %eax,%eax
  10391e:	74 0b                	je     10392b <buddy_check+0x70e>
  103920:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103923:	8b 40 08             	mov    0x8(%eax),%eax
  103926:	83 f8 02             	cmp    $0x2,%eax
  103929:	74 24                	je     10394f <buddy_check+0x732>
  10392b:	c7 44 24 0c 18 7d 10 	movl   $0x107d18,0xc(%esp)
  103932:	00 
  103933:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  10393a:	00 
  10393b:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  103942:	00 
  103943:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  10394a:	e8 82 d3 ff ff       	call   100cd1 <__panic>
    free_pages(p0, 4);
  10394f:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  103956:	00 
  103957:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10395a:	89 04 24             	mov    %eax,(%esp)
  10395d:	e8 fa 17 00 00       	call   10515c <free_pages>
    assert(PageProperty(p0) && p0->property == 3);
  103962:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103965:	83 c0 04             	add    $0x4,%eax
  103968:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  10396f:	00 00 00 
  103972:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103978:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  10397e:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  103984:	0f a3 10             	bt     %edx,(%eax)
  103987:	19 c0                	sbb    %eax,%eax
  103989:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
    return oldbit != 0;
  10398f:	83 bd 50 ff ff ff 00 	cmpl   $0x0,-0xb0(%ebp)
  103996:	0f 95 c0             	setne  %al
  103999:	0f b6 c0             	movzbl %al,%eax
  10399c:	85 c0                	test   %eax,%eax
  10399e:	74 0b                	je     1039ab <buddy_check+0x78e>
  1039a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1039a3:	8b 40 08             	mov    0x8(%eax),%eax
  1039a6:	83 f8 03             	cmp    $0x3,%eax
  1039a9:	74 24                	je     1039cf <buddy_check+0x7b2>
  1039ab:	c7 44 24 0c e4 7b 10 	movl   $0x107be4,0xc(%esp)
  1039b2:	00 
  1039b3:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  1039ba:	00 
  1039bb:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  1039c2:	00 
  1039c3:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  1039ca:	e8 02 d3 ff ff       	call   100cd1 <__panic>

    assert((p0 = alloc_pages(8)) != NULL);
  1039cf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1039d6:	e8 49 17 00 00       	call   105124 <alloc_pages>
  1039db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1039de:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1039e2:	75 24                	jne    103a08 <buddy_check+0x7eb>
  1039e4:	c7 44 24 0c 3e 7d 10 	movl   $0x107d3e,0xc(%esp)
  1039eb:	00 
  1039ec:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  1039f3:	00 
  1039f4:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  1039fb:	00 
  1039fc:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103a03:	e8 c9 d2 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL && nr_free_pages() == 0);
  103a08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a0f:	e8 10 17 00 00       	call   105124 <alloc_pages>
  103a14:	85 c0                	test   %eax,%eax
  103a16:	75 09                	jne    103a21 <buddy_check+0x804>
  103a18:	e8 71 17 00 00       	call   10518e <nr_free_pages>
  103a1d:	85 c0                	test   %eax,%eax
  103a1f:	74 24                	je     103a45 <buddy_check+0x828>
  103a21:	c7 44 24 0c 5c 7d 10 	movl   $0x107d5c,0xc(%esp)
  103a28:	00 
  103a29:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103a30:	00 
  103a31:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  103a38:	00 
  103a39:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103a40:	e8 8c d2 ff ff       	call   100cd1 <__panic>

    for (i = 0; i <= MAX_ORDER; i ++) {
  103a45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103a4c:	eb 4a                	jmp    103a98 <buddy_check+0x87b>
        free_list(i) = free_lists_store[i];
  103a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103a51:	89 d0                	mov    %edx,%eax
  103a53:	01 c0                	add    %eax,%eax
  103a55:	01 d0                	add    %edx,%eax
  103a57:	c1 e0 02             	shl    $0x2,%eax
  103a5a:	8d 88 00 b9 11 00    	lea    0x11b900(%eax),%ecx
  103a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a63:	8b 94 c5 ec fe ff ff 	mov    -0x114(%ebp,%eax,8),%edx
  103a6a:	8b 84 c5 e8 fe ff ff 	mov    -0x118(%ebp,%eax,8),%eax
  103a71:	89 01                	mov    %eax,(%ecx)
  103a73:	89 51 04             	mov    %edx,0x4(%ecx)
        nr_free(i) = nr_free_store[i];
  103a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a79:	8b 8c 85 bc fe ff ff 	mov    -0x144(%ebp,%eax,4),%ecx
  103a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103a83:	89 d0                	mov    %edx,%eax
  103a85:	01 c0                	add    %eax,%eax
  103a87:	01 d0                	add    %edx,%eax
  103a89:	c1 e0 02             	shl    $0x2,%eax
  103a8c:	05 00 b9 11 00       	add    $0x11b900,%eax
  103a91:	89 48 08             	mov    %ecx,0x8(%eax)
    assert(PageProperty(p0) && p0->property == 3);

    assert((p0 = alloc_pages(8)) != NULL);
    assert(alloc_page() == NULL && nr_free_pages() == 0);

    for (i = 0; i <= MAX_ORDER; i ++) {
  103a94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103a98:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  103a9c:	7e b0                	jle    103a4e <buddy_check+0x831>
        free_list(i) = free_lists_store[i];
        nr_free(i) = nr_free_store[i];
    }

    free_pages(p0, 8);
  103a9e:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  103aa5:	00 
  103aa6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103aa9:	89 04 24             	mov    %eax,(%esp)
  103aac:	e8 ab 16 00 00       	call   10515c <free_pages>
    free_pages(buddy, 8);
  103ab1:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  103ab8:	00 
  103ab9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103abc:	89 04 24             	mov    %eax,(%esp)
  103abf:	e8 98 16 00 00       	call   10515c <free_pages>

    assert(total == nr_free_pages());
  103ac4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  103ac7:	e8 c2 16 00 00       	call   10518e <nr_free_pages>
  103acc:	39 c3                	cmp    %eax,%ebx
  103ace:	74 24                	je     103af4 <buddy_check+0x8d7>
  103ad0:	c7 44 24 0c 3d 7b 10 	movl   $0x107b3d,0xc(%esp)
  103ad7:	00 
  103ad8:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103adf:	00 
  103ae0:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103ae7:	00 
  103ae8:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103aef:	e8 dd d1 ff ff       	call   100cd1 <__panic>

    for (i = 0; i <= MAX_ORDER; i ++) {
  103af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103afb:	e9 d1 00 00 00       	jmp    103bd1 <buddy_check+0x9b4>
        list_entry_t *list = &free_list(i), *le = list;
  103b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103b03:	89 d0                	mov    %edx,%eax
  103b05:	01 c0                	add    %eax,%eax
  103b07:	01 d0                	add    %edx,%eax
  103b09:	c1 e0 02             	shl    $0x2,%eax
  103b0c:	05 00 b9 11 00       	add    $0x11b900,%eax
  103b11:	89 45 cc             	mov    %eax,-0x34(%ebp)
  103b14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103b17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        while ((le = list_next(le)) != list) {
  103b1a:	e9 8d 00 00 00       	jmp    103bac <buddy_check+0x98f>
            struct Page *p = le2page(le, page_link);
  103b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b22:	83 e8 10             	sub    $0x10,%eax
  103b25:	89 45 c8             	mov    %eax,-0x38(%ebp)
            assert(PageProperty(p) && p->property == i);
  103b28:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103b2b:	83 c0 04             	add    $0x4,%eax
  103b2e:	c7 85 4c ff ff ff 01 	movl   $0x1,-0xb4(%ebp)
  103b35:	00 00 00 
  103b38:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103b3e:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  103b44:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  103b4a:	0f a3 10             	bt     %edx,(%eax)
  103b4d:	19 c0                	sbb    %eax,%eax
  103b4f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
    return oldbit != 0;
  103b55:	83 bd 44 ff ff ff 00 	cmpl   $0x0,-0xbc(%ebp)
  103b5c:	0f 95 c0             	setne  %al
  103b5f:	0f b6 c0             	movzbl %al,%eax
  103b62:	85 c0                	test   %eax,%eax
  103b64:	74 0d                	je     103b73 <buddy_check+0x956>
  103b66:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103b69:	8b 50 08             	mov    0x8(%eax),%edx
  103b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b6f:	39 c2                	cmp    %eax,%edx
  103b71:	74 24                	je     103b97 <buddy_check+0x97a>
  103b73:	c7 44 24 0c f0 7a 10 	movl   $0x107af0,0xc(%esp)
  103b7a:	00 
  103b7b:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103b82:	00 
  103b83:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103b8a:	00 
  103b8b:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103b92:	e8 3a d1 ff ff       	call   100cd1 <__panic>
            count --, total -= (1 << i);
  103b97:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  103b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b9e:	ba 01 00 00 00       	mov    $0x1,%edx
  103ba3:	89 c1                	mov    %eax,%ecx
  103ba5:	d3 e2                	shl    %cl,%edx
  103ba7:	89 d0                	mov    %edx,%eax
  103ba9:	29 45 ec             	sub    %eax,-0x14(%ebp)
  103bac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103baf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103bb5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  103bbb:	8b 40 04             	mov    0x4(%eax),%eax

    assert(total == nr_free_pages());

    for (i = 0; i <= MAX_ORDER; i ++) {
        list_entry_t *list = &free_list(i), *le = list;
        while ((le = list_next(le)) != list) {
  103bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bc4:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  103bc7:	0f 85 52 ff ff ff    	jne    103b1f <buddy_check+0x902>
    free_pages(p0, 8);
    free_pages(buddy, 8);

    assert(total == nr_free_pages());

    for (i = 0; i <= MAX_ORDER; i ++) {
  103bcd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103bd1:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  103bd5:	0f 8e 25 ff ff ff    	jle    103b00 <buddy_check+0x8e3>
            struct Page *p = le2page(le, page_link);
            assert(PageProperty(p) && p->property == i);
            count --, total -= (1 << i);
        }
    }
    assert(count == 0);
  103bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bdf:	74 24                	je     103c05 <buddy_check+0x9e8>
  103be1:	c7 44 24 0c 89 7d 10 	movl   $0x107d89,0xc(%esp)
  103be8:	00 
  103be9:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103bf0:	00 
  103bf1:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103bf8:	00 
  103bf9:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103c00:	e8 cc d0 ff ff       	call   100cd1 <__panic>
    assert(total == 0);
  103c05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103c09:	74 24                	je     103c2f <buddy_check+0xa12>
  103c0b:	c7 44 24 0c 94 7d 10 	movl   $0x107d94,0xc(%esp)
  103c12:	00 
  103c13:	c7 44 24 08 14 7b 10 	movl   $0x107b14,0x8(%esp)
  103c1a:	00 
  103c1b:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  103c22:	00 
  103c23:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  103c2a:	e8 a2 d0 ff ff       	call   100cd1 <__panic>
}
  103c2f:	81 c4 54 01 00 00    	add    $0x154,%esp
  103c35:	5b                   	pop    %ebx
  103c36:	5d                   	pop    %ebp
  103c37:	c3                   	ret    

00103c38 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103c38:	55                   	push   %ebp
  103c39:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  103c3e:	a1 44 ba 11 00       	mov    0x11ba44,%eax
  103c43:	29 c2                	sub    %eax,%edx
  103c45:	89 d0                	mov    %edx,%eax
  103c47:	c1 f8 03             	sar    $0x3,%eax
  103c4a:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
  103c50:	5d                   	pop    %ebp
  103c51:	c3                   	ret    

00103c52 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103c52:	55                   	push   %ebp
  103c53:	89 e5                	mov    %esp,%ebp
  103c55:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c58:	8b 45 08             	mov    0x8(%ebp),%eax
  103c5b:	89 04 24             	mov    %eax,(%esp)
  103c5e:	e8 d5 ff ff ff       	call   103c38 <page2ppn>
  103c63:	c1 e0 0c             	shl    $0xc,%eax
}
  103c66:	c9                   	leave  
  103c67:	c3                   	ret    

00103c68 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103c68:	55                   	push   %ebp
  103c69:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103c6e:	8b 00                	mov    (%eax),%eax
}
  103c70:	5d                   	pop    %ebp
  103c71:	c3                   	ret    

00103c72 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103c72:	55                   	push   %ebp
  103c73:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103c75:	8b 45 08             	mov    0x8(%ebp),%eax
  103c78:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c7b:	89 10                	mov    %edx,(%eax)
}
  103c7d:	5d                   	pop    %ebp
  103c7e:	c3                   	ret    

00103c7f <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  103c7f:	55                   	push   %ebp
  103c80:	89 e5                	mov    %esp,%ebp
  103c82:	83 ec 10             	sub    $0x10,%esp
  103c85:	c7 45 fc 30 ba 11 00 	movl   $0x11ba30,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103c8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103c8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  103c92:	89 50 04             	mov    %edx,0x4(%eax)
  103c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103c98:	8b 50 04             	mov    0x4(%eax),%edx
  103c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103c9e:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  103ca0:	c7 05 38 ba 11 00 00 	movl   $0x0,0x11ba38
  103ca7:	00 00 00 
}
  103caa:	c9                   	leave  
  103cab:	c3                   	ret    

00103cac <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  103cac:	55                   	push   %ebp
  103cad:	89 e5                	mov    %esp,%ebp
  103caf:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  103cb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103cb6:	75 24                	jne    103cdc <default_init_memmap+0x30>
  103cb8:	c7 44 24 0c d0 7d 10 	movl   $0x107dd0,0xc(%esp)
  103cbf:	00 
  103cc0:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  103cc7:	00 
  103cc8:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  103ccf:	00 
  103cd0:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  103cd7:	e8 f5 cf ff ff       	call   100cd1 <__panic>
    struct Page *p = base;
  103cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  103cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  103ce2:	eb 7d                	jmp    103d61 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ce7:	83 c0 04             	add    $0x4,%eax
  103cea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  103cf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103cf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103cfa:	0f a3 10             	bt     %edx,(%eax)
  103cfd:	19 c0                	sbb    %eax,%eax
  103cff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  103d02:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103d06:	0f 95 c0             	setne  %al
  103d09:	0f b6 c0             	movzbl %al,%eax
  103d0c:	85 c0                	test   %eax,%eax
  103d0e:	75 24                	jne    103d34 <default_init_memmap+0x88>
  103d10:	c7 44 24 0c 01 7e 10 	movl   $0x107e01,0xc(%esp)
  103d17:	00 
  103d18:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  103d1f:	00 
  103d20:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  103d27:	00 
  103d28:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  103d2f:	e8 9d cf ff ff       	call   100cd1 <__panic>
        p->flags = p->property = 0;
  103d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  103d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d41:	8b 50 08             	mov    0x8(%eax),%edx
  103d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d47:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  103d4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103d51:	00 
  103d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d55:	89 04 24             	mov    %eax,(%esp)
  103d58:	e8 15 ff ff ff       	call   103c72 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  103d5d:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
  103d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d64:	89 d0                	mov    %edx,%eax
  103d66:	01 c0                	add    %eax,%eax
  103d68:	01 d0                	add    %edx,%eax
  103d6a:	c1 e0 03             	shl    $0x3,%eax
  103d6d:	89 c2                	mov    %eax,%edx
  103d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  103d72:	01 d0                	add    %edx,%eax
  103d74:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103d77:	0f 85 67 ff ff ff    	jne    103ce4 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d83:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  103d86:	8b 45 08             	mov    0x8(%ebp),%eax
  103d89:	83 c0 04             	add    $0x4,%eax
  103d8c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  103d93:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103d99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103d9c:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  103d9f:	8b 15 38 ba 11 00    	mov    0x11ba38,%edx
  103da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  103da8:	01 d0                	add    %edx,%eax
  103daa:	a3 38 ba 11 00       	mov    %eax,0x11ba38
    //list_add(&free_list, &(base->page_link));
    list_add_before(&free_list,&(base->page_link));//相当于每次插入到最后
  103daf:	8b 45 08             	mov    0x8(%ebp),%eax
  103db2:	83 c0 10             	add    $0x10,%eax
  103db5:	c7 45 dc 30 ba 11 00 	movl   $0x11ba30,-0x24(%ebp)
  103dbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  103dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103dc2:	8b 00                	mov    (%eax),%eax
  103dc4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103dc7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103dca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103dd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103dd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103dd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103dd9:	89 10                	mov    %edx,(%eax)
  103ddb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103dde:	8b 10                	mov    (%eax),%edx
  103de0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103de3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103de6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103de9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103dec:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103def:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103df2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103df5:	89 10                	mov    %edx,(%eax)
}
  103df7:	c9                   	leave  
  103df8:	c3                   	ret    

00103df9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  103df9:	55                   	push   %ebp
  103dfa:	89 e5                	mov    %esp,%ebp
  103dfc:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  103dff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103e03:	75 24                	jne    103e29 <default_alloc_pages+0x30>
  103e05:	c7 44 24 0c d0 7d 10 	movl   $0x107dd0,0xc(%esp)
  103e0c:	00 
  103e0d:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  103e14:	00 
  103e15:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  103e1c:	00 
  103e1d:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  103e24:	e8 a8 ce ff ff       	call   100cd1 <__panic>
    if (n > nr_free) {
  103e29:	a1 38 ba 11 00       	mov    0x11ba38,%eax
  103e2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  103e31:	73 0a                	jae    103e3d <default_alloc_pages+0x44>
        return NULL;
  103e33:	b8 00 00 00 00       	mov    $0x0,%eax
  103e38:	e9 48 01 00 00       	jmp    103f85 <default_alloc_pages+0x18c>
    }
    struct Page *page = NULL;
  103e3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  103e44:	c7 45 f0 30 ba 11 00 	movl   $0x11ba30,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103e4b:	eb 1c                	jmp    103e69 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);//memlayout.h
  103e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e50:	83 e8 10             	sub    $0x10,%eax
  103e53:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  103e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e59:	8b 40 08             	mov    0x8(%eax),%eax
  103e5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  103e5f:	72 08                	jb     103e69 <default_alloc_pages+0x70>
            page = p;
  103e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  103e67:	eb 18                	jmp    103e81 <default_alloc_pages+0x88>
  103e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e72:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e78:	81 7d f0 30 ba 11 00 	cmpl   $0x11ba30,-0x10(%ebp)
  103e7f:	75 cc                	jne    103e4d <default_alloc_pages+0x54>
        if (page->property > n) {
            struct Page *p = page + n;
            p->property = page->property - n;
            list_add(&free_list, &(p->page_link));//
    }*/
    if (page != NULL) {
  103e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103e85:	0f 84 f7 00 00 00    	je     103f82 <default_alloc_pages+0x189>

            if (page->property > n) {
  103e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e8e:	8b 40 08             	mov    0x8(%eax),%eax
  103e91:	3b 45 08             	cmp    0x8(%ebp),%eax
  103e94:	0f 86 97 00 00 00    	jbe    103f31 <default_alloc_pages+0x138>
                struct Page *p = page + n;
  103e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  103e9d:	89 d0                	mov    %edx,%eax
  103e9f:	01 c0                	add    %eax,%eax
  103ea1:	01 d0                	add    %edx,%eax
  103ea3:	c1 e0 03             	shl    $0x3,%eax
  103ea6:	89 c2                	mov    %eax,%edx
  103ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103eab:	01 d0                	add    %edx,%eax
  103ead:	89 45 e8             	mov    %eax,-0x18(%ebp)
                p->property = page->property - n;
  103eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103eb3:	8b 40 08             	mov    0x8(%eax),%eax
  103eb6:	2b 45 08             	sub    0x8(%ebp),%eax
  103eb9:	89 c2                	mov    %eax,%edx
  103ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103ebe:	89 50 08             	mov    %edx,0x8(%eax)
                SetPageProperty(p);
  103ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103ec4:	83 c0 04             	add    $0x4,%eax
  103ec7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  103ece:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103ed1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ed4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103ed7:	0f ab 10             	bts    %edx,(%eax)
                list_add(&(page->page_link), &(p->page_link));//before也可以
  103eda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103edd:	83 c0 10             	add    $0x10,%eax
  103ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ee3:	83 c2 10             	add    $0x10,%edx
  103ee6:	89 55 d8             	mov    %edx,-0x28(%ebp)
  103ee9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  103eec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103eef:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103ef2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103ef5:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  103ef8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103efb:	8b 40 04             	mov    0x4(%eax),%eax
  103efe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103f01:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103f04:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103f07:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  103f0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103f0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103f10:	8b 55 c8             	mov    -0x38(%ebp),%edx
  103f13:	89 10                	mov    %edx,(%eax)
  103f15:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103f18:	8b 10                	mov    (%eax),%edx
  103f1a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f1d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103f20:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103f23:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103f26:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103f29:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103f2c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  103f2f:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  103f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f34:	83 c0 10             	add    $0x10,%eax
  103f37:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  103f3a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103f3d:	8b 40 04             	mov    0x4(%eax),%eax
  103f40:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103f43:	8b 12                	mov    (%edx),%edx
  103f45:	89 55 b8             	mov    %edx,-0x48(%ebp)
  103f48:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  103f4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103f4e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f51:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103f54:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103f57:	8b 55 b8             	mov    -0x48(%ebp),%edx
  103f5a:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  103f5c:	a1 38 ba 11 00       	mov    0x11ba38,%eax
  103f61:	2b 45 08             	sub    0x8(%ebp),%eax
  103f64:	a3 38 ba 11 00       	mov    %eax,0x11ba38
        ClearPageProperty(page);//memlayout.h
  103f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f6c:	83 c0 04             	add    $0x4,%eax
  103f6f:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  103f76:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f79:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f7c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103f7f:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  103f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f85:	c9                   	leave  
  103f86:	c3                   	ret    

00103f87 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  103f87:	55                   	push   %ebp
  103f88:	89 e5                	mov    %esp,%ebp
  103f8a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  103f90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103f94:	75 24                	jne    103fba <default_free_pages+0x33>
  103f96:	c7 44 24 0c d0 7d 10 	movl   $0x107dd0,0xc(%esp)
  103f9d:	00 
  103f9e:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  103fa5:	00 
  103fa6:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  103fad:	00 
  103fae:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  103fb5:	e8 17 cd ff ff       	call   100cd1 <__panic>
    struct Page *p = base;
  103fba:	8b 45 08             	mov    0x8(%ebp),%eax
  103fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  103fc0:	e9 9d 00 00 00       	jmp    104062 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  103fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fc8:	83 c0 04             	add    $0x4,%eax
  103fcb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  103fd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103fd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103fdb:	0f a3 10             	bt     %edx,(%eax)
  103fde:	19 c0                	sbb    %eax,%eax
  103fe0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  103fe3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103fe7:	0f 95 c0             	setne  %al
  103fea:	0f b6 c0             	movzbl %al,%eax
  103fed:	85 c0                	test   %eax,%eax
  103fef:	75 2c                	jne    10401d <default_free_pages+0x96>
  103ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ff4:	83 c0 04             	add    $0x4,%eax
  103ff7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  103ffe:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104001:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104004:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104007:	0f a3 10             	bt     %edx,(%eax)
  10400a:	19 c0                	sbb    %eax,%eax
  10400c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10400f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104013:	0f 95 c0             	setne  %al
  104016:	0f b6 c0             	movzbl %al,%eax
  104019:	85 c0                	test   %eax,%eax
  10401b:	74 24                	je     104041 <default_free_pages+0xba>
  10401d:	c7 44 24 0c 14 7e 10 	movl   $0x107e14,0xc(%esp)
  104024:	00 
  104025:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10402c:	00 
  10402d:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
  104034:	00 
  104035:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10403c:	e8 90 cc ff ff       	call   100cd1 <__panic>
        p->flags = 0;
  104041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  10404b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104052:	00 
  104053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104056:	89 04 24             	mov    %eax,(%esp)
  104059:	e8 14 fc ff ff       	call   103c72 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  10405e:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
  104062:	8b 55 0c             	mov    0xc(%ebp),%edx
  104065:	89 d0                	mov    %edx,%eax
  104067:	01 c0                	add    %eax,%eax
  104069:	01 d0                	add    %edx,%eax
  10406b:	c1 e0 03             	shl    $0x3,%eax
  10406e:	89 c2                	mov    %eax,%edx
  104070:	8b 45 08             	mov    0x8(%ebp),%eax
  104073:	01 d0                	add    %edx,%eax
  104075:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104078:	0f 85 47 ff ff ff    	jne    103fc5 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  10407e:	8b 45 08             	mov    0x8(%ebp),%eax
  104081:	8b 55 0c             	mov    0xc(%ebp),%edx
  104084:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104087:	8b 45 08             	mov    0x8(%ebp),%eax
  10408a:	83 c0 04             	add    $0x4,%eax
  10408d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104094:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104097:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10409a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10409d:	0f ab 10             	bts    %edx,(%eax)
  1040a0:	c7 45 cc 30 ba 11 00 	movl   $0x11ba30,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1040a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1040aa:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  1040ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1040b0:	e9 06 01 00 00       	jmp    1041bb <default_free_pages+0x234>
        p = le2page(le, page_link);
  1040b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040b8:	83 e8 10             	sub    $0x10,%eax
  1040bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1040be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040c7:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1040ca:	89 45 f0             	mov    %eax,-0x10(%ebp)

        //向后合并
        if (base + base->property == p) {
  1040cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1040d0:	8b 50 08             	mov    0x8(%eax),%edx
  1040d3:	89 d0                	mov    %edx,%eax
  1040d5:	01 c0                	add    %eax,%eax
  1040d7:	01 d0                	add    %edx,%eax
  1040d9:	c1 e0 03             	shl    $0x3,%eax
  1040dc:	89 c2                	mov    %eax,%edx
  1040de:	8b 45 08             	mov    0x8(%ebp),%eax
  1040e1:	01 d0                	add    %edx,%eax
  1040e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1040e6:	75 5a                	jne    104142 <default_free_pages+0x1bb>
            base->property += p->property;
  1040e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1040eb:	8b 50 08             	mov    0x8(%eax),%edx
  1040ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040f1:	8b 40 08             	mov    0x8(%eax),%eax
  1040f4:	01 c2                	add    %eax,%edx
  1040f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1040f9:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  1040fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040ff:	83 c0 04             	add    $0x4,%eax
  104102:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  104109:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10410c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10410f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104112:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  104115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104118:	83 c0 10             	add    $0x10,%eax
  10411b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  10411e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104121:	8b 40 04             	mov    0x4(%eax),%eax
  104124:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104127:	8b 12                	mov    (%edx),%edx
  104129:	89 55 b8             	mov    %edx,-0x48(%ebp)
  10412c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10412f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104132:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104135:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104138:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10413b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  10413e:	89 10                	mov    %edx,(%eax)
  104140:	eb 79                	jmp    1041bb <default_free_pages+0x234>
        }

        //向前合并
        else if (p + p->property == base) {
  104142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104145:	8b 50 08             	mov    0x8(%eax),%edx
  104148:	89 d0                	mov    %edx,%eax
  10414a:	01 c0                	add    %eax,%eax
  10414c:	01 d0                	add    %edx,%eax
  10414e:	c1 e0 03             	shl    $0x3,%eax
  104151:	89 c2                	mov    %eax,%edx
  104153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104156:	01 d0                	add    %edx,%eax
  104158:	3b 45 08             	cmp    0x8(%ebp),%eax
  10415b:	75 5e                	jne    1041bb <default_free_pages+0x234>
            p->property += base->property;
  10415d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104160:	8b 50 08             	mov    0x8(%eax),%edx
  104163:	8b 45 08             	mov    0x8(%ebp),%eax
  104166:	8b 40 08             	mov    0x8(%eax),%eax
  104169:	01 c2                	add    %eax,%edx
  10416b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10416e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104171:	8b 45 08             	mov    0x8(%ebp),%eax
  104174:	83 c0 04             	add    $0x4,%eax
  104177:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  10417e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  104181:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104184:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104187:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  10418a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10418d:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104193:	83 c0 10             	add    $0x10,%eax
  104196:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104199:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10419c:	8b 40 04             	mov    0x4(%eax),%eax
  10419f:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1041a2:	8b 12                	mov    (%edx),%edx
  1041a4:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  1041a7:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1041aa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1041ad:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1041b0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1041b3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1041b6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1041b9:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  1041bb:	81 7d f0 30 ba 11 00 	cmpl   $0x11ba30,-0x10(%ebp)
  1041c2:	0f 85 ed fe ff ff    	jne    1040b5 <default_free_pages+0x12e>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  1041c8:	8b 15 38 ba 11 00    	mov    0x11ba38,%edx
  1041ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041d1:	01 d0                	add    %edx,%eax
  1041d3:	a3 38 ba 11 00       	mov    %eax,0x11ba38
  1041d8:	c7 45 9c 30 ba 11 00 	movl   $0x11ba30,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1041df:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1041e2:	8b 40 04             	mov    0x4(%eax),%eax

    //按地址顺序插入
    le=list_next(&free_list);
  1041e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le!=&free_list)
  1041e8:	eb 35                	jmp    10421f <default_free_pages+0x298>
    {
    	p=le2page(le,page_link);
  1041ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041ed:	83 e8 10             	sub    $0x10,%eax
  1041f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if(base+base->property<=p)
  1041f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1041f6:	8b 50 08             	mov    0x8(%eax),%edx
  1041f9:	89 d0                	mov    %edx,%eax
  1041fb:	01 c0                	add    %eax,%eax
  1041fd:	01 d0                	add    %edx,%eax
  1041ff:	c1 e0 03             	shl    $0x3,%eax
  104202:	89 c2                	mov    %eax,%edx
  104204:	8b 45 08             	mov    0x8(%ebp),%eax
  104207:	01 d0                	add    %edx,%eax
  104209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10420c:	77 02                	ja     104210 <default_free_pages+0x289>
    	{
    		//assert(base+base->property!=p)
    		break;
  10420e:	eb 18                	jmp    104228 <default_free_pages+0x2a1>
  104210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104213:	89 45 98             	mov    %eax,-0x68(%ebp)
  104216:	8b 45 98             	mov    -0x68(%ebp),%eax
  104219:	8b 40 04             	mov    0x4(%eax),%eax
    	}
    	le=list_next(le);
  10421c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    nr_free += n;

    //按地址顺序插入
    le=list_next(&free_list);
    while(le!=&free_list)
  10421f:	81 7d f0 30 ba 11 00 	cmpl   $0x11ba30,-0x10(%ebp)
  104226:	75 c2                	jne    1041ea <default_free_pages+0x263>
    		//assert(base+base->property!=p)
    		break;
    	}
    	le=list_next(le);
    }
    list_add_before(le,&(base->page_link));
  104228:	8b 45 08             	mov    0x8(%ebp),%eax
  10422b:	8d 50 10             	lea    0x10(%eax),%edx
  10422e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104231:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104234:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104237:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10423a:	8b 00                	mov    (%eax),%eax
  10423c:	8b 55 90             	mov    -0x70(%ebp),%edx
  10423f:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104242:	89 45 88             	mov    %eax,-0x78(%ebp)
  104245:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104248:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10424b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10424e:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104251:	89 10                	mov    %edx,(%eax)
  104253:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104256:	8b 10                	mov    (%eax),%edx
  104258:	8b 45 88             	mov    -0x78(%ebp),%eax
  10425b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10425e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104261:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104264:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104267:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10426a:	8b 55 88             	mov    -0x78(%ebp),%edx
  10426d:	89 10                	mov    %edx,(%eax)
    //list_add(&free_list, &(base->page_link));
}
  10426f:	c9                   	leave  
  104270:	c3                   	ret    

00104271 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104271:	55                   	push   %ebp
  104272:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104274:	a1 38 ba 11 00       	mov    0x11ba38,%eax
}
  104279:	5d                   	pop    %ebp
  10427a:	c3                   	ret    

0010427b <basic_check>:

static void
basic_check(void) {
  10427b:	55                   	push   %ebp
  10427c:	89 e5                	mov    %esp,%ebp
  10427e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104281:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10428b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10428e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104291:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104294:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10429b:	e8 84 0e 00 00       	call   105124 <alloc_pages>
  1042a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1042a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1042a7:	75 24                	jne    1042cd <basic_check+0x52>
  1042a9:	c7 44 24 0c 39 7e 10 	movl   $0x107e39,0xc(%esp)
  1042b0:	00 
  1042b1:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1042b8:	00 
  1042b9:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  1042c0:	00 
  1042c1:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  1042c8:	e8 04 ca ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1042cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042d4:	e8 4b 0e 00 00       	call   105124 <alloc_pages>
  1042d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1042dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1042e0:	75 24                	jne    104306 <basic_check+0x8b>
  1042e2:	c7 44 24 0c 55 7e 10 	movl   $0x107e55,0xc(%esp)
  1042e9:	00 
  1042ea:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1042f1:	00 
  1042f2:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  1042f9:	00 
  1042fa:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104301:	e8 cb c9 ff ff       	call   100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104306:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10430d:	e8 12 0e 00 00       	call   105124 <alloc_pages>
  104312:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104319:	75 24                	jne    10433f <basic_check+0xc4>
  10431b:	c7 44 24 0c 71 7e 10 	movl   $0x107e71,0xc(%esp)
  104322:	00 
  104323:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10432a:	00 
  10432b:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  104332:	00 
  104333:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10433a:	e8 92 c9 ff ff       	call   100cd1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10433f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104342:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104345:	74 10                	je     104357 <basic_check+0xdc>
  104347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10434a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10434d:	74 08                	je     104357 <basic_check+0xdc>
  10434f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104352:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104355:	75 24                	jne    10437b <basic_check+0x100>
  104357:	c7 44 24 0c 90 7e 10 	movl   $0x107e90,0xc(%esp)
  10435e:	00 
  10435f:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104366:	00 
  104367:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  10436e:	00 
  10436f:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104376:	e8 56 c9 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10437b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10437e:	89 04 24             	mov    %eax,(%esp)
  104381:	e8 e2 f8 ff ff       	call   103c68 <page_ref>
  104386:	85 c0                	test   %eax,%eax
  104388:	75 1e                	jne    1043a8 <basic_check+0x12d>
  10438a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10438d:	89 04 24             	mov    %eax,(%esp)
  104390:	e8 d3 f8 ff ff       	call   103c68 <page_ref>
  104395:	85 c0                	test   %eax,%eax
  104397:	75 0f                	jne    1043a8 <basic_check+0x12d>
  104399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439c:	89 04 24             	mov    %eax,(%esp)
  10439f:	e8 c4 f8 ff ff       	call   103c68 <page_ref>
  1043a4:	85 c0                	test   %eax,%eax
  1043a6:	74 24                	je     1043cc <basic_check+0x151>
  1043a8:	c7 44 24 0c b4 7e 10 	movl   $0x107eb4,0xc(%esp)
  1043af:	00 
  1043b0:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1043b7:	00 
  1043b8:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  1043bf:	00 
  1043c0:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  1043c7:	e8 05 c9 ff ff       	call   100cd1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1043cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043cf:	89 04 24             	mov    %eax,(%esp)
  1043d2:	e8 7b f8 ff ff       	call   103c52 <page2pa>
  1043d7:	8b 15 a0 b9 11 00    	mov    0x11b9a0,%edx
  1043dd:	c1 e2 0c             	shl    $0xc,%edx
  1043e0:	39 d0                	cmp    %edx,%eax
  1043e2:	72 24                	jb     104408 <basic_check+0x18d>
  1043e4:	c7 44 24 0c f0 7e 10 	movl   $0x107ef0,0xc(%esp)
  1043eb:	00 
  1043ec:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1043f3:	00 
  1043f4:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  1043fb:	00 
  1043fc:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104403:	e8 c9 c8 ff ff       	call   100cd1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10440b:	89 04 24             	mov    %eax,(%esp)
  10440e:	e8 3f f8 ff ff       	call   103c52 <page2pa>
  104413:	8b 15 a0 b9 11 00    	mov    0x11b9a0,%edx
  104419:	c1 e2 0c             	shl    $0xc,%edx
  10441c:	39 d0                	cmp    %edx,%eax
  10441e:	72 24                	jb     104444 <basic_check+0x1c9>
  104420:	c7 44 24 0c 0d 7f 10 	movl   $0x107f0d,0xc(%esp)
  104427:	00 
  104428:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10442f:	00 
  104430:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  104437:	00 
  104438:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10443f:	e8 8d c8 ff ff       	call   100cd1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104447:	89 04 24             	mov    %eax,(%esp)
  10444a:	e8 03 f8 ff ff       	call   103c52 <page2pa>
  10444f:	8b 15 a0 b9 11 00    	mov    0x11b9a0,%edx
  104455:	c1 e2 0c             	shl    $0xc,%edx
  104458:	39 d0                	cmp    %edx,%eax
  10445a:	72 24                	jb     104480 <basic_check+0x205>
  10445c:	c7 44 24 0c 2a 7f 10 	movl   $0x107f2a,0xc(%esp)
  104463:	00 
  104464:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10446b:	00 
  10446c:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  104473:	00 
  104474:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10447b:	e8 51 c8 ff ff       	call   100cd1 <__panic>

    list_entry_t free_list_store = free_list;
  104480:	a1 30 ba 11 00       	mov    0x11ba30,%eax
  104485:	8b 15 34 ba 11 00    	mov    0x11ba34,%edx
  10448b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10448e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104491:	c7 45 e0 30 ba 11 00 	movl   $0x11ba30,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10449b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10449e:	89 50 04             	mov    %edx,0x4(%eax)
  1044a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044a4:	8b 50 04             	mov    0x4(%eax),%edx
  1044a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044aa:	89 10                	mov    %edx,(%eax)
  1044ac:	c7 45 dc 30 ba 11 00 	movl   $0x11ba30,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1044b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1044b6:	8b 40 04             	mov    0x4(%eax),%eax
  1044b9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1044bc:	0f 94 c0             	sete   %al
  1044bf:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1044c2:	85 c0                	test   %eax,%eax
  1044c4:	75 24                	jne    1044ea <basic_check+0x26f>
  1044c6:	c7 44 24 0c 47 7f 10 	movl   $0x107f47,0xc(%esp)
  1044cd:	00 
  1044ce:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1044d5:	00 
  1044d6:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  1044dd:	00 
  1044de:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  1044e5:	e8 e7 c7 ff ff       	call   100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
  1044ea:	a1 38 ba 11 00       	mov    0x11ba38,%eax
  1044ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1044f2:	c7 05 38 ba 11 00 00 	movl   $0x0,0x11ba38
  1044f9:	00 00 00 

    assert(alloc_page() == NULL);
  1044fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104503:	e8 1c 0c 00 00       	call   105124 <alloc_pages>
  104508:	85 c0                	test   %eax,%eax
  10450a:	74 24                	je     104530 <basic_check+0x2b5>
  10450c:	c7 44 24 0c 5e 7f 10 	movl   $0x107f5e,0xc(%esp)
  104513:	00 
  104514:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10451b:	00 
  10451c:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  104523:	00 
  104524:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10452b:	e8 a1 c7 ff ff       	call   100cd1 <__panic>

    free_page(p0);
  104530:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104537:	00 
  104538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10453b:	89 04 24             	mov    %eax,(%esp)
  10453e:	e8 19 0c 00 00       	call   10515c <free_pages>
    free_page(p1);
  104543:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10454a:	00 
  10454b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10454e:	89 04 24             	mov    %eax,(%esp)
  104551:	e8 06 0c 00 00       	call   10515c <free_pages>
    free_page(p2);
  104556:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10455d:	00 
  10455e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104561:	89 04 24             	mov    %eax,(%esp)
  104564:	e8 f3 0b 00 00       	call   10515c <free_pages>
    assert(nr_free == 3);
  104569:	a1 38 ba 11 00       	mov    0x11ba38,%eax
  10456e:	83 f8 03             	cmp    $0x3,%eax
  104571:	74 24                	je     104597 <basic_check+0x31c>
  104573:	c7 44 24 0c 73 7f 10 	movl   $0x107f73,0xc(%esp)
  10457a:	00 
  10457b:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104582:	00 
  104583:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  10458a:	00 
  10458b:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104592:	e8 3a c7 ff ff       	call   100cd1 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104597:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10459e:	e8 81 0b 00 00       	call   105124 <alloc_pages>
  1045a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1045a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1045aa:	75 24                	jne    1045d0 <basic_check+0x355>
  1045ac:	c7 44 24 0c 39 7e 10 	movl   $0x107e39,0xc(%esp)
  1045b3:	00 
  1045b4:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1045bb:	00 
  1045bc:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  1045c3:	00 
  1045c4:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  1045cb:	e8 01 c7 ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1045d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1045d7:	e8 48 0b 00 00       	call   105124 <alloc_pages>
  1045dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1045e3:	75 24                	jne    104609 <basic_check+0x38e>
  1045e5:	c7 44 24 0c 55 7e 10 	movl   $0x107e55,0xc(%esp)
  1045ec:	00 
  1045ed:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1045f4:	00 
  1045f5:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  1045fc:	00 
  1045fd:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104604:	e8 c8 c6 ff ff       	call   100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104609:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104610:	e8 0f 0b 00 00       	call   105124 <alloc_pages>
  104615:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10461c:	75 24                	jne    104642 <basic_check+0x3c7>
  10461e:	c7 44 24 0c 71 7e 10 	movl   $0x107e71,0xc(%esp)
  104625:	00 
  104626:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10462d:	00 
  10462e:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  104635:	00 
  104636:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10463d:	e8 8f c6 ff ff       	call   100cd1 <__panic>

    assert(alloc_page() == NULL);
  104642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104649:	e8 d6 0a 00 00       	call   105124 <alloc_pages>
  10464e:	85 c0                	test   %eax,%eax
  104650:	74 24                	je     104676 <basic_check+0x3fb>
  104652:	c7 44 24 0c 5e 7f 10 	movl   $0x107f5e,0xc(%esp)
  104659:	00 
  10465a:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104661:	00 
  104662:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104669:	00 
  10466a:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104671:	e8 5b c6 ff ff       	call   100cd1 <__panic>

    free_page(p0);
  104676:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10467d:	00 
  10467e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104681:	89 04 24             	mov    %eax,(%esp)
  104684:	e8 d3 0a 00 00       	call   10515c <free_pages>
  104689:	c7 45 d8 30 ba 11 00 	movl   $0x11ba30,-0x28(%ebp)
  104690:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104693:	8b 40 04             	mov    0x4(%eax),%eax
  104696:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104699:	0f 94 c0             	sete   %al
  10469c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10469f:	85 c0                	test   %eax,%eax
  1046a1:	74 24                	je     1046c7 <basic_check+0x44c>
  1046a3:	c7 44 24 0c 80 7f 10 	movl   $0x107f80,0xc(%esp)
  1046aa:	00 
  1046ab:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1046b2:	00 
  1046b3:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  1046ba:	00 
  1046bb:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  1046c2:	e8 0a c6 ff ff       	call   100cd1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1046c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046ce:	e8 51 0a 00 00       	call   105124 <alloc_pages>
  1046d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1046d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1046dc:	74 24                	je     104702 <basic_check+0x487>
  1046de:	c7 44 24 0c 98 7f 10 	movl   $0x107f98,0xc(%esp)
  1046e5:	00 
  1046e6:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1046ed:	00 
  1046ee:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  1046f5:	00 
  1046f6:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  1046fd:	e8 cf c5 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  104702:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104709:	e8 16 0a 00 00       	call   105124 <alloc_pages>
  10470e:	85 c0                	test   %eax,%eax
  104710:	74 24                	je     104736 <basic_check+0x4bb>
  104712:	c7 44 24 0c 5e 7f 10 	movl   $0x107f5e,0xc(%esp)
  104719:	00 
  10471a:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104721:	00 
  104722:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  104729:	00 
  10472a:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104731:	e8 9b c5 ff ff       	call   100cd1 <__panic>

    assert(nr_free == 0);
  104736:	a1 38 ba 11 00       	mov    0x11ba38,%eax
  10473b:	85 c0                	test   %eax,%eax
  10473d:	74 24                	je     104763 <basic_check+0x4e8>
  10473f:	c7 44 24 0c b1 7f 10 	movl   $0x107fb1,0xc(%esp)
  104746:	00 
  104747:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10474e:	00 
  10474f:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  104756:	00 
  104757:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10475e:	e8 6e c5 ff ff       	call   100cd1 <__panic>
    free_list = free_list_store;
  104763:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104766:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104769:	a3 30 ba 11 00       	mov    %eax,0x11ba30
  10476e:	89 15 34 ba 11 00    	mov    %edx,0x11ba34
    nr_free = nr_free_store;
  104774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104777:	a3 38 ba 11 00       	mov    %eax,0x11ba38

    free_page(p);
  10477c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104783:	00 
  104784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104787:	89 04 24             	mov    %eax,(%esp)
  10478a:	e8 cd 09 00 00       	call   10515c <free_pages>
    free_page(p1);
  10478f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104796:	00 
  104797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10479a:	89 04 24             	mov    %eax,(%esp)
  10479d:	e8 ba 09 00 00       	call   10515c <free_pages>
    free_page(p2);
  1047a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1047a9:	00 
  1047aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047ad:	89 04 24             	mov    %eax,(%esp)
  1047b0:	e8 a7 09 00 00       	call   10515c <free_pages>
}
  1047b5:	c9                   	leave  
  1047b6:	c3                   	ret    

001047b7 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1047b7:	55                   	push   %ebp
  1047b8:	89 e5                	mov    %esp,%ebp
  1047ba:	53                   	push   %ebx
  1047bb:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1047c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1047c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1047cf:	c7 45 ec 30 ba 11 00 	movl   $0x11ba30,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1047d6:	eb 6b                	jmp    104843 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1047d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047db:	83 e8 10             	sub    $0x10,%eax
  1047de:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1047e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047e4:	83 c0 04             	add    $0x4,%eax
  1047e7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1047ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1047f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1047f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1047f7:	0f a3 10             	bt     %edx,(%eax)
  1047fa:	19 c0                	sbb    %eax,%eax
  1047fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1047ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104803:	0f 95 c0             	setne  %al
  104806:	0f b6 c0             	movzbl %al,%eax
  104809:	85 c0                	test   %eax,%eax
  10480b:	75 24                	jne    104831 <default_check+0x7a>
  10480d:	c7 44 24 0c be 7f 10 	movl   $0x107fbe,0xc(%esp)
  104814:	00 
  104815:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10481c:	00 
  10481d:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  104824:	00 
  104825:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10482c:	e8 a0 c4 ff ff       	call   100cd1 <__panic>
        count ++, total += p->property;
  104831:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104838:	8b 50 08             	mov    0x8(%eax),%edx
  10483b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10483e:	01 d0                	add    %edx,%eax
  104840:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104846:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104849:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10484c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10484f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104852:	81 7d ec 30 ba 11 00 	cmpl   $0x11ba30,-0x14(%ebp)
  104859:	0f 85 79 ff ff ff    	jne    1047d8 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10485f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  104862:	e8 27 09 00 00       	call   10518e <nr_free_pages>
  104867:	39 c3                	cmp    %eax,%ebx
  104869:	74 24                	je     10488f <default_check+0xd8>
  10486b:	c7 44 24 0c ce 7f 10 	movl   $0x107fce,0xc(%esp)
  104872:	00 
  104873:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  10487a:	00 
  10487b:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  104882:	00 
  104883:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  10488a:	e8 42 c4 ff ff       	call   100cd1 <__panic>

    basic_check();
  10488f:	e8 e7 f9 ff ff       	call   10427b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104894:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10489b:	e8 84 08 00 00       	call   105124 <alloc_pages>
  1048a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1048a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1048a7:	75 24                	jne    1048cd <default_check+0x116>
  1048a9:	c7 44 24 0c e7 7f 10 	movl   $0x107fe7,0xc(%esp)
  1048b0:	00 
  1048b1:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1048b8:	00 
  1048b9:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  1048c0:	00 
  1048c1:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  1048c8:	e8 04 c4 ff ff       	call   100cd1 <__panic>
    assert(!PageProperty(p0));
  1048cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1048d0:	83 c0 04             	add    $0x4,%eax
  1048d3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1048da:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1048dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1048e0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1048e3:	0f a3 10             	bt     %edx,(%eax)
  1048e6:	19 c0                	sbb    %eax,%eax
  1048e8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1048eb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1048ef:	0f 95 c0             	setne  %al
  1048f2:	0f b6 c0             	movzbl %al,%eax
  1048f5:	85 c0                	test   %eax,%eax
  1048f7:	74 24                	je     10491d <default_check+0x166>
  1048f9:	c7 44 24 0c f2 7f 10 	movl   $0x107ff2,0xc(%esp)
  104900:	00 
  104901:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104908:	00 
  104909:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  104910:	00 
  104911:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104918:	e8 b4 c3 ff ff       	call   100cd1 <__panic>

    list_entry_t free_list_store = free_list;
  10491d:	a1 30 ba 11 00       	mov    0x11ba30,%eax
  104922:	8b 15 34 ba 11 00    	mov    0x11ba34,%edx
  104928:	89 45 80             	mov    %eax,-0x80(%ebp)
  10492b:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10492e:	c7 45 b4 30 ba 11 00 	movl   $0x11ba30,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104935:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104938:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10493b:	89 50 04             	mov    %edx,0x4(%eax)
  10493e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104941:	8b 50 04             	mov    0x4(%eax),%edx
  104944:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104947:	89 10                	mov    %edx,(%eax)
  104949:	c7 45 b0 30 ba 11 00 	movl   $0x11ba30,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104950:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104953:	8b 40 04             	mov    0x4(%eax),%eax
  104956:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  104959:	0f 94 c0             	sete   %al
  10495c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10495f:	85 c0                	test   %eax,%eax
  104961:	75 24                	jne    104987 <default_check+0x1d0>
  104963:	c7 44 24 0c 47 7f 10 	movl   $0x107f47,0xc(%esp)
  10496a:	00 
  10496b:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104972:	00 
  104973:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  10497a:	00 
  10497b:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104982:	e8 4a c3 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  104987:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10498e:	e8 91 07 00 00       	call   105124 <alloc_pages>
  104993:	85 c0                	test   %eax,%eax
  104995:	74 24                	je     1049bb <default_check+0x204>
  104997:	c7 44 24 0c 5e 7f 10 	movl   $0x107f5e,0xc(%esp)
  10499e:	00 
  10499f:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  1049a6:	00 
  1049a7:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1049ae:	00 
  1049af:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  1049b6:	e8 16 c3 ff ff       	call   100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
  1049bb:	a1 38 ba 11 00       	mov    0x11ba38,%eax
  1049c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1049c3:	c7 05 38 ba 11 00 00 	movl   $0x0,0x11ba38
  1049ca:	00 00 00 

    free_pages(p0 + 2, 3);
  1049cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049d0:	83 c0 30             	add    $0x30,%eax
  1049d3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1049da:	00 
  1049db:	89 04 24             	mov    %eax,(%esp)
  1049de:	e8 79 07 00 00       	call   10515c <free_pages>
    assert(alloc_pages(4) == NULL);
  1049e3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1049ea:	e8 35 07 00 00       	call   105124 <alloc_pages>
  1049ef:	85 c0                	test   %eax,%eax
  1049f1:	74 24                	je     104a17 <default_check+0x260>
  1049f3:	c7 44 24 0c 04 80 10 	movl   $0x108004,0xc(%esp)
  1049fa:	00 
  1049fb:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104a02:	00 
  104a03:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  104a0a:	00 
  104a0b:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104a12:	e8 ba c2 ff ff       	call   100cd1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a1a:	83 c0 30             	add    $0x30,%eax
  104a1d:	83 c0 04             	add    $0x4,%eax
  104a20:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104a27:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a2a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104a2d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104a30:	0f a3 10             	bt     %edx,(%eax)
  104a33:	19 c0                	sbb    %eax,%eax
  104a35:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  104a38:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  104a3c:	0f 95 c0             	setne  %al
  104a3f:	0f b6 c0             	movzbl %al,%eax
  104a42:	85 c0                	test   %eax,%eax
  104a44:	74 0e                	je     104a54 <default_check+0x29d>
  104a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a49:	83 c0 30             	add    $0x30,%eax
  104a4c:	8b 40 08             	mov    0x8(%eax),%eax
  104a4f:	83 f8 03             	cmp    $0x3,%eax
  104a52:	74 24                	je     104a78 <default_check+0x2c1>
  104a54:	c7 44 24 0c 1c 80 10 	movl   $0x10801c,0xc(%esp)
  104a5b:	00 
  104a5c:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104a63:	00 
  104a64:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  104a6b:	00 
  104a6c:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104a73:	e8 59 c2 ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104a78:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  104a7f:	e8 a0 06 00 00       	call   105124 <alloc_pages>
  104a84:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104a87:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104a8b:	75 24                	jne    104ab1 <default_check+0x2fa>
  104a8d:	c7 44 24 0c 48 80 10 	movl   $0x108048,0xc(%esp)
  104a94:	00 
  104a95:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104a9c:	00 
  104a9d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104aa4:	00 
  104aa5:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104aac:	e8 20 c2 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  104ab1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ab8:	e8 67 06 00 00       	call   105124 <alloc_pages>
  104abd:	85 c0                	test   %eax,%eax
  104abf:	74 24                	je     104ae5 <default_check+0x32e>
  104ac1:	c7 44 24 0c 5e 7f 10 	movl   $0x107f5e,0xc(%esp)
  104ac8:	00 
  104ac9:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104ad0:	00 
  104ad1:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  104ad8:	00 
  104ad9:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104ae0:	e8 ec c1 ff ff       	call   100cd1 <__panic>
    assert(p0 + 2 == p1);
  104ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ae8:	83 c0 30             	add    $0x30,%eax
  104aeb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104aee:	74 24                	je     104b14 <default_check+0x35d>
  104af0:	c7 44 24 0c 66 80 10 	movl   $0x108066,0xc(%esp)
  104af7:	00 
  104af8:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104aff:	00 
  104b00:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104b07:	00 
  104b08:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104b0f:	e8 bd c1 ff ff       	call   100cd1 <__panic>

    p2 = p0 + 1;
  104b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b17:	83 c0 18             	add    $0x18,%eax
  104b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  104b1d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b24:	00 
  104b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b28:	89 04 24             	mov    %eax,(%esp)
  104b2b:	e8 2c 06 00 00       	call   10515c <free_pages>
    free_pages(p1, 3);
  104b30:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104b37:	00 
  104b38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b3b:	89 04 24             	mov    %eax,(%esp)
  104b3e:	e8 19 06 00 00       	call   10515c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  104b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b46:	83 c0 04             	add    $0x4,%eax
  104b49:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  104b50:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104b56:	8b 55 a0             	mov    -0x60(%ebp),%edx
  104b59:	0f a3 10             	bt     %edx,(%eax)
  104b5c:	19 c0                	sbb    %eax,%eax
  104b5e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104b61:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104b65:	0f 95 c0             	setne  %al
  104b68:	0f b6 c0             	movzbl %al,%eax
  104b6b:	85 c0                	test   %eax,%eax
  104b6d:	74 0b                	je     104b7a <default_check+0x3c3>
  104b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b72:	8b 40 08             	mov    0x8(%eax),%eax
  104b75:	83 f8 01             	cmp    $0x1,%eax
  104b78:	74 24                	je     104b9e <default_check+0x3e7>
  104b7a:	c7 44 24 0c 74 80 10 	movl   $0x108074,0xc(%esp)
  104b81:	00 
  104b82:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104b89:	00 
  104b8a:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  104b91:	00 
  104b92:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104b99:	e8 33 c1 ff ff       	call   100cd1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104b9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ba1:	83 c0 04             	add    $0x4,%eax
  104ba4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  104bab:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104bae:	8b 45 90             	mov    -0x70(%ebp),%eax
  104bb1:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104bb4:	0f a3 10             	bt     %edx,(%eax)
  104bb7:	19 c0                	sbb    %eax,%eax
  104bb9:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  104bbc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  104bc0:	0f 95 c0             	setne  %al
  104bc3:	0f b6 c0             	movzbl %al,%eax
  104bc6:	85 c0                	test   %eax,%eax
  104bc8:	74 0b                	je     104bd5 <default_check+0x41e>
  104bca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104bcd:	8b 40 08             	mov    0x8(%eax),%eax
  104bd0:	83 f8 03             	cmp    $0x3,%eax
  104bd3:	74 24                	je     104bf9 <default_check+0x442>
  104bd5:	c7 44 24 0c 9c 80 10 	movl   $0x10809c,0xc(%esp)
  104bdc:	00 
  104bdd:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104be4:	00 
  104be5:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  104bec:	00 
  104bed:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104bf4:	e8 d8 c0 ff ff       	call   100cd1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104bf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c00:	e8 1f 05 00 00       	call   105124 <alloc_pages>
  104c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104c0b:	83 e8 18             	sub    $0x18,%eax
  104c0e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104c11:	74 24                	je     104c37 <default_check+0x480>
  104c13:	c7 44 24 0c c2 80 10 	movl   $0x1080c2,0xc(%esp)
  104c1a:	00 
  104c1b:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104c22:	00 
  104c23:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104c2a:	00 
  104c2b:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104c32:	e8 9a c0 ff ff       	call   100cd1 <__panic>
    free_page(p0);
  104c37:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c3e:	00 
  104c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c42:	89 04 24             	mov    %eax,(%esp)
  104c45:	e8 12 05 00 00       	call   10515c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104c4a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104c51:	e8 ce 04 00 00       	call   105124 <alloc_pages>
  104c56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104c5c:	83 c0 18             	add    $0x18,%eax
  104c5f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104c62:	74 24                	je     104c88 <default_check+0x4d1>
  104c64:	c7 44 24 0c e0 80 10 	movl   $0x1080e0,0xc(%esp)
  104c6b:	00 
  104c6c:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104c73:	00 
  104c74:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  104c7b:	00 
  104c7c:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104c83:	e8 49 c0 ff ff       	call   100cd1 <__panic>

    free_pages(p0, 2);
  104c88:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  104c8f:	00 
  104c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c93:	89 04 24             	mov    %eax,(%esp)
  104c96:	e8 c1 04 00 00       	call   10515c <free_pages>
    free_page(p2);
  104c9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ca2:	00 
  104ca3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104ca6:	89 04 24             	mov    %eax,(%esp)
  104ca9:	e8 ae 04 00 00       	call   10515c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  104cae:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104cb5:	e8 6a 04 00 00       	call   105124 <alloc_pages>
  104cba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104cbd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104cc1:	75 24                	jne    104ce7 <default_check+0x530>
  104cc3:	c7 44 24 0c 00 81 10 	movl   $0x108100,0xc(%esp)
  104cca:	00 
  104ccb:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104cd2:	00 
  104cd3:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  104cda:	00 
  104cdb:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104ce2:	e8 ea bf ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  104ce7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cee:	e8 31 04 00 00       	call   105124 <alloc_pages>
  104cf3:	85 c0                	test   %eax,%eax
  104cf5:	74 24                	je     104d1b <default_check+0x564>
  104cf7:	c7 44 24 0c 5e 7f 10 	movl   $0x107f5e,0xc(%esp)
  104cfe:	00 
  104cff:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104d06:	00 
  104d07:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  104d0e:	00 
  104d0f:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104d16:	e8 b6 bf ff ff       	call   100cd1 <__panic>

    assert(nr_free == 0);
  104d1b:	a1 38 ba 11 00       	mov    0x11ba38,%eax
  104d20:	85 c0                	test   %eax,%eax
  104d22:	74 24                	je     104d48 <default_check+0x591>
  104d24:	c7 44 24 0c b1 7f 10 	movl   $0x107fb1,0xc(%esp)
  104d2b:	00 
  104d2c:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104d33:	00 
  104d34:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  104d3b:	00 
  104d3c:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104d43:	e8 89 bf ff ff       	call   100cd1 <__panic>
    nr_free = nr_free_store;
  104d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d4b:	a3 38 ba 11 00       	mov    %eax,0x11ba38

    free_list = free_list_store;
  104d50:	8b 45 80             	mov    -0x80(%ebp),%eax
  104d53:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104d56:	a3 30 ba 11 00       	mov    %eax,0x11ba30
  104d5b:	89 15 34 ba 11 00    	mov    %edx,0x11ba34
    free_pages(p0, 5);
  104d61:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  104d68:	00 
  104d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d6c:	89 04 24             	mov    %eax,(%esp)
  104d6f:	e8 e8 03 00 00       	call   10515c <free_pages>

    le = &free_list;
  104d74:	c7 45 ec 30 ba 11 00 	movl   $0x11ba30,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104d7b:	eb 1d                	jmp    104d9a <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  104d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d80:	83 e8 10             	sub    $0x10,%eax
  104d83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  104d86:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104d8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104d8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104d90:	8b 40 08             	mov    0x8(%eax),%eax
  104d93:	29 c2                	sub    %eax,%edx
  104d95:	89 d0                	mov    %edx,%eax
  104d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d9d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104da0:	8b 45 88             	mov    -0x78(%ebp),%eax
  104da3:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104da9:	81 7d ec 30 ba 11 00 	cmpl   $0x11ba30,-0x14(%ebp)
  104db0:	75 cb                	jne    104d7d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  104db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104db6:	74 24                	je     104ddc <default_check+0x625>
  104db8:	c7 44 24 0c 1e 81 10 	movl   $0x10811e,0xc(%esp)
  104dbf:	00 
  104dc0:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104dc7:	00 
  104dc8:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  104dcf:	00 
  104dd0:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104dd7:	e8 f5 be ff ff       	call   100cd1 <__panic>
    assert(total == 0);
  104ddc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104de0:	74 24                	je     104e06 <default_check+0x64f>
  104de2:	c7 44 24 0c 29 81 10 	movl   $0x108129,0xc(%esp)
  104de9:	00 
  104dea:	c7 44 24 08 d6 7d 10 	movl   $0x107dd6,0x8(%esp)
  104df1:	00 
  104df2:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  104df9:	00 
  104dfa:	c7 04 24 eb 7d 10 00 	movl   $0x107deb,(%esp)
  104e01:	e8 cb be ff ff       	call   100cd1 <__panic>
}
  104e06:	81 c4 94 00 00 00    	add    $0x94,%esp
  104e0c:	5b                   	pop    %ebx
  104e0d:	5d                   	pop    %ebp
  104e0e:	c3                   	ret    

00104e0f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  104e0f:	55                   	push   %ebp
  104e10:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104e12:	8b 55 08             	mov    0x8(%ebp),%edx
  104e15:	a1 44 ba 11 00       	mov    0x11ba44,%eax
  104e1a:	29 c2                	sub    %eax,%edx
  104e1c:	89 d0                	mov    %edx,%eax
  104e1e:	c1 f8 03             	sar    $0x3,%eax
  104e21:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
  104e27:	5d                   	pop    %ebp
  104e28:	c3                   	ret    

00104e29 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  104e29:	55                   	push   %ebp
  104e2a:	89 e5                	mov    %esp,%ebp
  104e2c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  104e32:	89 04 24             	mov    %eax,(%esp)
  104e35:	e8 d5 ff ff ff       	call   104e0f <page2ppn>
  104e3a:	c1 e0 0c             	shl    $0xc,%eax
}
  104e3d:	c9                   	leave  
  104e3e:	c3                   	ret    

00104e3f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  104e3f:	55                   	push   %ebp
  104e40:	89 e5                	mov    %esp,%ebp
  104e42:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {//mmu.h
  104e45:	8b 45 08             	mov    0x8(%ebp),%eax
  104e48:	c1 e8 0c             	shr    $0xc,%eax
  104e4b:	89 c2                	mov    %eax,%edx
  104e4d:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  104e52:	39 c2                	cmp    %eax,%edx
  104e54:	72 1c                	jb     104e72 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  104e56:	c7 44 24 08 64 81 10 	movl   $0x108164,0x8(%esp)
  104e5d:	00 
  104e5e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  104e65:	00 
  104e66:	c7 04 24 83 81 10 00 	movl   $0x108183,(%esp)
  104e6d:	e8 5f be ff ff       	call   100cd1 <__panic>
    }
    return &pages[PPN(pa)];
  104e72:	8b 0d 44 ba 11 00    	mov    0x11ba44,%ecx
  104e78:	8b 45 08             	mov    0x8(%ebp),%eax
  104e7b:	c1 e8 0c             	shr    $0xc,%eax
  104e7e:	89 c2                	mov    %eax,%edx
  104e80:	89 d0                	mov    %edx,%eax
  104e82:	01 c0                	add    %eax,%eax
  104e84:	01 d0                	add    %edx,%eax
  104e86:	c1 e0 03             	shl    $0x3,%eax
  104e89:	01 c8                	add    %ecx,%eax
}
  104e8b:	c9                   	leave  
  104e8c:	c3                   	ret    

00104e8d <page2kva>:

static inline void *
page2kva(struct Page *page) {
  104e8d:	55                   	push   %ebp
  104e8e:	89 e5                	mov    %esp,%ebp
  104e90:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));//pmm.h
  104e93:	8b 45 08             	mov    0x8(%ebp),%eax
  104e96:	89 04 24             	mov    %eax,(%esp)
  104e99:	e8 8b ff ff ff       	call   104e29 <page2pa>
  104e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ea4:	c1 e8 0c             	shr    $0xc,%eax
  104ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104eaa:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  104eaf:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104eb2:	72 23                	jb     104ed7 <page2kva+0x4a>
  104eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ebb:	c7 44 24 08 94 81 10 	movl   $0x108194,0x8(%esp)
  104ec2:	00 
  104ec3:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  104eca:	00 
  104ecb:	c7 04 24 83 81 10 00 	movl   $0x108183,(%esp)
  104ed2:	e8 fa bd ff ff       	call   100cd1 <__panic>
  104ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eda:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  104edf:	c9                   	leave  
  104ee0:	c3                   	ret    

00104ee1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  104ee1:	55                   	push   %ebp
  104ee2:	89 e5                	mov    %esp,%ebp
  104ee4:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  104ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  104eea:	83 e0 01             	and    $0x1,%eax
  104eed:	85 c0                	test   %eax,%eax
  104eef:	75 1c                	jne    104f0d <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  104ef1:	c7 44 24 08 b8 81 10 	movl   $0x1081b8,0x8(%esp)
  104ef8:	00 
  104ef9:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  104f00:	00 
  104f01:	c7 04 24 83 81 10 00 	movl   $0x108183,(%esp)
  104f08:	e8 c4 bd ff ff       	call   100cd1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  104f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  104f10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f15:	89 04 24             	mov    %eax,(%esp)
  104f18:	e8 22 ff ff ff       	call   104e3f <pa2page>
}
  104f1d:	c9                   	leave  
  104f1e:	c3                   	ret    

00104f1f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  104f1f:	55                   	push   %ebp
  104f20:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104f22:	8b 45 08             	mov    0x8(%ebp),%eax
  104f25:	8b 00                	mov    (%eax),%eax
}
  104f27:	5d                   	pop    %ebp
  104f28:	c3                   	ret    

00104f29 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  104f29:	55                   	push   %ebp
  104f2a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  104f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  104f32:	89 10                	mov    %edx,(%eax)
}
  104f34:	5d                   	pop    %ebp
  104f35:	c3                   	ret    

00104f36 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  104f36:	55                   	push   %ebp
  104f37:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  104f39:	8b 45 08             	mov    0x8(%ebp),%eax
  104f3c:	8b 00                	mov    (%eax),%eax
  104f3e:	8d 50 01             	lea    0x1(%eax),%edx
  104f41:	8b 45 08             	mov    0x8(%ebp),%eax
  104f44:	89 10                	mov    %edx,(%eax)
    return page->ref;
  104f46:	8b 45 08             	mov    0x8(%ebp),%eax
  104f49:	8b 00                	mov    (%eax),%eax
}
  104f4b:	5d                   	pop    %ebp
  104f4c:	c3                   	ret    

00104f4d <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  104f4d:	55                   	push   %ebp
  104f4e:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  104f50:	8b 45 08             	mov    0x8(%ebp),%eax
  104f53:	8b 00                	mov    (%eax),%eax
  104f55:	8d 50 ff             	lea    -0x1(%eax),%edx
  104f58:	8b 45 08             	mov    0x8(%ebp),%eax
  104f5b:	89 10                	mov    %edx,(%eax)
    return page->ref;
  104f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  104f60:	8b 00                	mov    (%eax),%eax
}
  104f62:	5d                   	pop    %ebp
  104f63:	c3                   	ret    

00104f64 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  104f64:	55                   	push   %ebp
  104f65:	89 e5                	mov    %esp,%ebp
  104f67:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  104f6a:	9c                   	pushf  
  104f6b:	58                   	pop    %eax
  104f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  104f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  104f72:	25 00 02 00 00       	and    $0x200,%eax
  104f77:	85 c0                	test   %eax,%eax
  104f79:	74 0c                	je     104f87 <__intr_save+0x23>
        intr_disable();
  104f7b:	e8 34 c7 ff ff       	call   1016b4 <intr_disable>
        return 1;
  104f80:	b8 01 00 00 00       	mov    $0x1,%eax
  104f85:	eb 05                	jmp    104f8c <__intr_save+0x28>
    }
    return 0;
  104f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104f8c:	c9                   	leave  
  104f8d:	c3                   	ret    

00104f8e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  104f8e:	55                   	push   %ebp
  104f8f:	89 e5                	mov    %esp,%ebp
  104f91:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  104f94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104f98:	74 05                	je     104f9f <__intr_restore+0x11>
        intr_enable();
  104f9a:	e8 0f c7 ff ff       	call   1016ae <intr_enable>
    }
}
  104f9f:	c9                   	leave  
  104fa0:	c3                   	ret    

00104fa1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  104fa1:	55                   	push   %ebp
  104fa2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  104fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  104fa7:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  104faa:	b8 23 00 00 00       	mov    $0x23,%eax
  104faf:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  104fb1:	b8 23 00 00 00       	mov    $0x23,%eax
  104fb6:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  104fb8:	b8 10 00 00 00       	mov    $0x10,%eax
  104fbd:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  104fbf:	b8 10 00 00 00       	mov    $0x10,%eax
  104fc4:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  104fc6:	b8 10 00 00 00       	mov    $0x10,%eax
  104fcb:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  104fcd:	ea d4 4f 10 00 08 00 	ljmp   $0x8,$0x104fd4
}
  104fd4:	5d                   	pop    %ebp
  104fd5:	c3                   	ret    

00104fd6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  104fd6:	55                   	push   %ebp
  104fd7:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  104fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  104fdc:	a3 c4 b9 11 00       	mov    %eax,0x11b9c4
}
  104fe1:	5d                   	pop    %ebp
  104fe2:	c3                   	ret    

00104fe3 <gdt_init>:
 * mode, the x86 CPU will look in the TSS for SS0 and ESP0 and load their value
 * into SS and ESP respectively.
 * */
/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  104fe3:	55                   	push   %ebp
  104fe4:	89 e5                	mov    %esp,%ebp
  104fe6:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  104fe9:	b8 00 a0 11 00       	mov    $0x11a000,%eax
  104fee:	89 04 24             	mov    %eax,(%esp)
  104ff1:	e8 e0 ff ff ff       	call   104fd6 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  104ff6:	66 c7 05 c8 b9 11 00 	movw   $0x10,0x11b9c8
  104ffd:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  104fff:	66 c7 05 28 aa 11 00 	movw   $0x68,0x11aa28
  105006:	68 00 
  105008:	b8 c0 b9 11 00       	mov    $0x11b9c0,%eax
  10500d:	66 a3 2a aa 11 00    	mov    %ax,0x11aa2a
  105013:	b8 c0 b9 11 00       	mov    $0x11b9c0,%eax
  105018:	c1 e8 10             	shr    $0x10,%eax
  10501b:	a2 2c aa 11 00       	mov    %al,0x11aa2c
  105020:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  105027:	83 e0 f0             	and    $0xfffffff0,%eax
  10502a:	83 c8 09             	or     $0x9,%eax
  10502d:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  105032:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  105039:	83 e0 ef             	and    $0xffffffef,%eax
  10503c:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  105041:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  105048:	83 e0 9f             	and    $0xffffff9f,%eax
  10504b:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  105050:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  105057:	83 c8 80             	or     $0xffffff80,%eax
  10505a:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  10505f:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  105066:	83 e0 f0             	and    $0xfffffff0,%eax
  105069:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  10506e:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  105075:	83 e0 ef             	and    $0xffffffef,%eax
  105078:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  10507d:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  105084:	83 e0 df             	and    $0xffffffdf,%eax
  105087:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  10508c:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  105093:	83 c8 40             	or     $0x40,%eax
  105096:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  10509b:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  1050a2:	83 e0 7f             	and    $0x7f,%eax
  1050a5:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  1050aa:	b8 c0 b9 11 00       	mov    $0x11b9c0,%eax
  1050af:	c1 e8 18             	shr    $0x18,%eax
  1050b2:	a2 2f aa 11 00       	mov    %al,0x11aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
  1050b7:	c7 04 24 30 aa 11 00 	movl   $0x11aa30,(%esp)
  1050be:	e8 de fe ff ff       	call   104fa1 <lgdt>
  1050c3:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  1050c9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1050cd:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1050d0:	c9                   	leave  
  1050d1:	c3                   	ret    

001050d2 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  1050d2:	55                   	push   %ebp
  1050d3:	89 e5                	mov    %esp,%ebp
  1050d5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
  1050d8:	c7 05 3c ba 11 00 b4 	movl   $0x107db4,0x11ba3c
  1050df:	7d 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  1050e2:	a1 3c ba 11 00       	mov    0x11ba3c,%eax
  1050e7:	8b 00                	mov    (%eax),%eax
  1050e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050ed:	c7 04 24 e4 81 10 00 	movl   $0x1081e4,(%esp)
  1050f4:	e8 4e b2 ff ff       	call   100347 <cprintf>
    pmm_manager->init();
  1050f9:	a1 3c ba 11 00       	mov    0x11ba3c,%eax
  1050fe:	8b 40 04             	mov    0x4(%eax),%eax
  105101:	ff d0                	call   *%eax
}
  105103:	c9                   	leave  
  105104:	c3                   	ret    

00105105 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  105105:	55                   	push   %ebp
  105106:	89 e5                	mov    %esp,%ebp
  105108:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  10510b:	a1 3c ba 11 00       	mov    0x11ba3c,%eax
  105110:	8b 40 08             	mov    0x8(%eax),%eax
  105113:	8b 55 0c             	mov    0xc(%ebp),%edx
  105116:	89 54 24 04          	mov    %edx,0x4(%esp)
  10511a:	8b 55 08             	mov    0x8(%ebp),%edx
  10511d:	89 14 24             	mov    %edx,(%esp)
  105120:	ff d0                	call   *%eax
}
  105122:	c9                   	leave  
  105123:	c3                   	ret    

00105124 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  105124:	55                   	push   %ebp
  105125:	89 e5                	mov    %esp,%ebp
  105127:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  10512a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  105131:	e8 2e fe ff ff       	call   104f64 <__intr_save>
  105136:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  105139:	a1 3c ba 11 00       	mov    0x11ba3c,%eax
  10513e:	8b 40 0c             	mov    0xc(%eax),%eax
  105141:	8b 55 08             	mov    0x8(%ebp),%edx
  105144:	89 14 24             	mov    %edx,(%esp)
  105147:	ff d0                	call   *%eax
  105149:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  10514c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10514f:	89 04 24             	mov    %eax,(%esp)
  105152:	e8 37 fe ff ff       	call   104f8e <__intr_restore>
    return page;
  105157:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10515a:	c9                   	leave  
  10515b:	c3                   	ret    

0010515c <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  10515c:	55                   	push   %ebp
  10515d:	89 e5                	mov    %esp,%ebp
  10515f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  105162:	e8 fd fd ff ff       	call   104f64 <__intr_save>
  105167:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  10516a:	a1 3c ba 11 00       	mov    0x11ba3c,%eax
  10516f:	8b 40 10             	mov    0x10(%eax),%eax
  105172:	8b 55 0c             	mov    0xc(%ebp),%edx
  105175:	89 54 24 04          	mov    %edx,0x4(%esp)
  105179:	8b 55 08             	mov    0x8(%ebp),%edx
  10517c:	89 14 24             	mov    %edx,(%esp)
  10517f:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  105181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105184:	89 04 24             	mov    %eax,(%esp)
  105187:	e8 02 fe ff ff       	call   104f8e <__intr_restore>
}
  10518c:	c9                   	leave  
  10518d:	c3                   	ret    

0010518e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  10518e:	55                   	push   %ebp
  10518f:	89 e5                	mov    %esp,%ebp
  105191:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  105194:	e8 cb fd ff ff       	call   104f64 <__intr_save>
  105199:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  10519c:	a1 3c ba 11 00       	mov    0x11ba3c,%eax
  1051a1:	8b 40 14             	mov    0x14(%eax),%eax
  1051a4:	ff d0                	call   *%eax
  1051a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  1051a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051ac:	89 04 24             	mov    %eax,(%esp)
  1051af:	e8 da fd ff ff       	call   104f8e <__intr_restore>
    return ret;
  1051b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1051b7:	c9                   	leave  
  1051b8:	c3                   	ret    

001051b9 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  1051b9:	55                   	push   %ebp
  1051ba:	89 e5                	mov    %esp,%ebp
  1051bc:	57                   	push   %edi
  1051bd:	56                   	push   %esi
  1051be:	53                   	push   %ebx
  1051bf:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  1051c5:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  1051cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1051d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  1051da:	c7 04 24 fb 81 10 00 	movl   $0x1081fb,(%esp)
  1051e1:	e8 61 b1 ff ff       	call   100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1051e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1051ed:	e9 15 01 00 00       	jmp    105307 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1051f2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1051f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1051f8:	89 d0                	mov    %edx,%eax
  1051fa:	c1 e0 02             	shl    $0x2,%eax
  1051fd:	01 d0                	add    %edx,%eax
  1051ff:	c1 e0 02             	shl    $0x2,%eax
  105202:	01 c8                	add    %ecx,%eax
  105204:	8b 50 08             	mov    0x8(%eax),%edx
  105207:	8b 40 04             	mov    0x4(%eax),%eax
  10520a:	89 45 b8             	mov    %eax,-0x48(%ebp)
  10520d:	89 55 bc             	mov    %edx,-0x44(%ebp)
  105210:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  105213:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105216:	89 d0                	mov    %edx,%eax
  105218:	c1 e0 02             	shl    $0x2,%eax
  10521b:	01 d0                	add    %edx,%eax
  10521d:	c1 e0 02             	shl    $0x2,%eax
  105220:	01 c8                	add    %ecx,%eax
  105222:	8b 48 0c             	mov    0xc(%eax),%ecx
  105225:	8b 58 10             	mov    0x10(%eax),%ebx
  105228:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10522b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10522e:	01 c8                	add    %ecx,%eax
  105230:	11 da                	adc    %ebx,%edx
  105232:	89 45 b0             	mov    %eax,-0x50(%ebp)
  105235:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  105238:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10523b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10523e:	89 d0                	mov    %edx,%eax
  105240:	c1 e0 02             	shl    $0x2,%eax
  105243:	01 d0                	add    %edx,%eax
  105245:	c1 e0 02             	shl    $0x2,%eax
  105248:	01 c8                	add    %ecx,%eax
  10524a:	83 c0 14             	add    $0x14,%eax
  10524d:	8b 00                	mov    (%eax),%eax
  10524f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  105255:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105258:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10525b:	83 c0 ff             	add    $0xffffffff,%eax
  10525e:	83 d2 ff             	adc    $0xffffffff,%edx
  105261:	89 c6                	mov    %eax,%esi
  105263:	89 d7                	mov    %edx,%edi
  105265:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  105268:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10526b:	89 d0                	mov    %edx,%eax
  10526d:	c1 e0 02             	shl    $0x2,%eax
  105270:	01 d0                	add    %edx,%eax
  105272:	c1 e0 02             	shl    $0x2,%eax
  105275:	01 c8                	add    %ecx,%eax
  105277:	8b 48 0c             	mov    0xc(%eax),%ecx
  10527a:	8b 58 10             	mov    0x10(%eax),%ebx
  10527d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  105283:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  105287:	89 74 24 14          	mov    %esi,0x14(%esp)
  10528b:	89 7c 24 18          	mov    %edi,0x18(%esp)
  10528f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105292:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105295:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105299:	89 54 24 10          	mov    %edx,0x10(%esp)
  10529d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1052a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1052a5:	c7 04 24 08 82 10 00 	movl   $0x108208,(%esp)
  1052ac:	e8 96 b0 ff ff       	call   100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1052b1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1052b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1052b7:	89 d0                	mov    %edx,%eax
  1052b9:	c1 e0 02             	shl    $0x2,%eax
  1052bc:	01 d0                	add    %edx,%eax
  1052be:	c1 e0 02             	shl    $0x2,%eax
  1052c1:	01 c8                	add    %ecx,%eax
  1052c3:	83 c0 14             	add    $0x14,%eax
  1052c6:	8b 00                	mov    (%eax),%eax
  1052c8:	83 f8 01             	cmp    $0x1,%eax
  1052cb:	75 36                	jne    105303 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  1052cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1052d3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  1052d6:	77 2b                	ja     105303 <page_init+0x14a>
  1052d8:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  1052db:	72 05                	jb     1052e2 <page_init+0x129>
  1052dd:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  1052e0:	73 21                	jae    105303 <page_init+0x14a>
  1052e2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  1052e6:	77 1b                	ja     105303 <page_init+0x14a>
  1052e8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  1052ec:	72 09                	jb     1052f7 <page_init+0x13e>
  1052ee:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  1052f5:	77 0c                	ja     105303 <page_init+0x14a>
                maxpa = end;
  1052f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1052fa:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1052fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105300:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  105303:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  105307:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10530a:	8b 00                	mov    (%eax),%eax
  10530c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10530f:	0f 8f dd fe ff ff    	jg     1051f2 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  105315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105319:	72 1d                	jb     105338 <page_init+0x17f>
  10531b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10531f:	77 09                	ja     10532a <page_init+0x171>
  105321:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  105328:	76 0e                	jbe    105338 <page_init+0x17f>
        maxpa = KMEMSIZE;
  10532a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  105331:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  105338:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10533b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10533e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  105342:	c1 ea 0c             	shr    $0xc,%edx
  105345:	a3 a0 b9 11 00       	mov    %eax,0x11b9a0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10534a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  105351:	b8 48 ba 11 00       	mov    $0x11ba48,%eax
  105356:	8d 50 ff             	lea    -0x1(%eax),%edx
  105359:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10535c:	01 d0                	add    %edx,%eax
  10535e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  105361:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105364:	ba 00 00 00 00       	mov    $0x0,%edx
  105369:	f7 75 ac             	divl   -0x54(%ebp)
  10536c:	89 d0                	mov    %edx,%eax
  10536e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  105371:	29 c2                	sub    %eax,%edx
  105373:	89 d0                	mov    %edx,%eax
  105375:	a3 44 ba 11 00       	mov    %eax,0x11ba44

    for (i = 0; i < npage; i ++) {
  10537a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105381:	eb 2e                	jmp    1053b1 <page_init+0x1f8>
        SetPageReserved(pages + i);
  105383:	8b 0d 44 ba 11 00    	mov    0x11ba44,%ecx
  105389:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10538c:	89 d0                	mov    %edx,%eax
  10538e:	01 c0                	add    %eax,%eax
  105390:	01 d0                	add    %edx,%eax
  105392:	c1 e0 03             	shl    $0x3,%eax
  105395:	01 c8                	add    %ecx,%eax
  105397:	83 c0 04             	add    $0x4,%eax
  10539a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  1053a1:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1053a4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1053a7:	8b 55 90             	mov    -0x70(%ebp),%edx
  1053aa:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  1053ad:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1053b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053b4:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  1053b9:	39 c2                	cmp    %eax,%edx
  1053bb:	72 c6                	jb     105383 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1053bd:	8b 15 a0 b9 11 00    	mov    0x11b9a0,%edx
  1053c3:	89 d0                	mov    %edx,%eax
  1053c5:	01 c0                	add    %eax,%eax
  1053c7:	01 d0                	add    %edx,%eax
  1053c9:	c1 e0 03             	shl    $0x3,%eax
  1053cc:	89 c2                	mov    %eax,%edx
  1053ce:	a1 44 ba 11 00       	mov    0x11ba44,%eax
  1053d3:	01 d0                	add    %edx,%eax
  1053d5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1053d8:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  1053df:	77 23                	ja     105404 <page_init+0x24b>
  1053e1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1053e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1053e8:	c7 44 24 08 38 82 10 	movl   $0x108238,0x8(%esp)
  1053ef:	00 
  1053f0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1053f7:	00 
  1053f8:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1053ff:	e8 cd b8 ff ff       	call   100cd1 <__panic>
  105404:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105407:	05 00 00 00 40       	add    $0x40000000,%eax
  10540c:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10540f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105416:	e9 74 01 00 00       	jmp    10558f <page_init+0x3d6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10541b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10541e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105421:	89 d0                	mov    %edx,%eax
  105423:	c1 e0 02             	shl    $0x2,%eax
  105426:	01 d0                	add    %edx,%eax
  105428:	c1 e0 02             	shl    $0x2,%eax
  10542b:	01 c8                	add    %ecx,%eax
  10542d:	8b 50 08             	mov    0x8(%eax),%edx
  105430:	8b 40 04             	mov    0x4(%eax),%eax
  105433:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105436:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105439:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10543c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10543f:	89 d0                	mov    %edx,%eax
  105441:	c1 e0 02             	shl    $0x2,%eax
  105444:	01 d0                	add    %edx,%eax
  105446:	c1 e0 02             	shl    $0x2,%eax
  105449:	01 c8                	add    %ecx,%eax
  10544b:	8b 48 0c             	mov    0xc(%eax),%ecx
  10544e:	8b 58 10             	mov    0x10(%eax),%ebx
  105451:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105454:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105457:	01 c8                	add    %ecx,%eax
  105459:	11 da                	adc    %ebx,%edx
  10545b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10545e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  105461:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  105464:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105467:	89 d0                	mov    %edx,%eax
  105469:	c1 e0 02             	shl    $0x2,%eax
  10546c:	01 d0                	add    %edx,%eax
  10546e:	c1 e0 02             	shl    $0x2,%eax
  105471:	01 c8                	add    %ecx,%eax
  105473:	83 c0 14             	add    $0x14,%eax
  105476:	8b 00                	mov    (%eax),%eax
  105478:	83 f8 01             	cmp    $0x1,%eax
  10547b:	0f 85 0a 01 00 00    	jne    10558b <page_init+0x3d2>
            if (begin < freemem) {
  105481:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105484:	ba 00 00 00 00       	mov    $0x0,%edx
  105489:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10548c:	72 17                	jb     1054a5 <page_init+0x2ec>
  10548e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105491:	77 05                	ja     105498 <page_init+0x2df>
  105493:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105496:	76 0d                	jbe    1054a5 <page_init+0x2ec>
                begin = freemem;
  105498:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10549b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10549e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1054a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1054a9:	72 1d                	jb     1054c8 <page_init+0x30f>
  1054ab:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1054af:	77 09                	ja     1054ba <page_init+0x301>
  1054b1:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1054b8:	76 0e                	jbe    1054c8 <page_init+0x30f>
                end = KMEMSIZE;
  1054ba:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1054c1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1054c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054ce:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1054d1:	0f 87 b4 00 00 00    	ja     10558b <page_init+0x3d2>
  1054d7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1054da:	72 09                	jb     1054e5 <page_init+0x32c>
  1054dc:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1054df:	0f 83 a6 00 00 00    	jae    10558b <page_init+0x3d2>
                begin = ROUNDUP(begin, PGSIZE);
  1054e5:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1054ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1054ef:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1054f2:	01 d0                	add    %edx,%eax
  1054f4:	83 e8 01             	sub    $0x1,%eax
  1054f7:	89 45 98             	mov    %eax,-0x68(%ebp)
  1054fa:	8b 45 98             	mov    -0x68(%ebp),%eax
  1054fd:	ba 00 00 00 00       	mov    $0x0,%edx
  105502:	f7 75 9c             	divl   -0x64(%ebp)
  105505:	89 d0                	mov    %edx,%eax
  105507:	8b 55 98             	mov    -0x68(%ebp),%edx
  10550a:	29 c2                	sub    %eax,%edx
  10550c:	89 d0                	mov    %edx,%eax
  10550e:	ba 00 00 00 00       	mov    $0x0,%edx
  105513:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105516:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  105519:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10551c:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10551f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105522:	ba 00 00 00 00       	mov    $0x0,%edx
  105527:	89 c7                	mov    %eax,%edi
  105529:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10552f:	89 7d 80             	mov    %edi,-0x80(%ebp)
  105532:	89 d0                	mov    %edx,%eax
  105534:	83 e0 00             	and    $0x0,%eax
  105537:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10553a:	8b 45 80             	mov    -0x80(%ebp),%eax
  10553d:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105540:	89 45 c8             	mov    %eax,-0x38(%ebp)
  105543:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  105546:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105549:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10554c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10554f:	77 3a                	ja     10558b <page_init+0x3d2>
  105551:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  105554:	72 05                	jb     10555b <page_init+0x3a2>
  105556:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  105559:	73 30                	jae    10558b <page_init+0x3d2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10555b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10555e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  105561:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105564:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105567:	29 c8                	sub    %ecx,%eax
  105569:	19 da                	sbb    %ebx,%edx
  10556b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10556f:	c1 ea 0c             	shr    $0xc,%edx
  105572:	89 c3                	mov    %eax,%ebx
  105574:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105577:	89 04 24             	mov    %eax,(%esp)
  10557a:	e8 c0 f8 ff ff       	call   104e3f <pa2page>
  10557f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105583:	89 04 24             	mov    %eax,(%esp)
  105586:	e8 7a fb ff ff       	call   105105 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10558b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10558f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105592:	8b 00                	mov    (%eax),%eax
  105594:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  105597:	0f 8f 7e fe ff ff    	jg     10541b <page_init+0x262>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10559d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1055a3:	5b                   	pop    %ebx
  1055a4:	5e                   	pop    %esi
  1055a5:	5f                   	pop    %edi
  1055a6:	5d                   	pop    %ebp
  1055a7:	c3                   	ret    

001055a8 <enable_paging>:

static void
enable_paging(void) {
  1055a8:	55                   	push   %ebp
  1055a9:	89 e5                	mov    %esp,%ebp
  1055ab:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1055ae:	a1 40 ba 11 00       	mov    0x11ba40,%eax
  1055b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1055b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1055b9:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1055bc:	0f 20 c0             	mov    %cr0,%eax
  1055bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1055c2:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1055c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1055c8:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1055cf:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1055d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1055d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055dc:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1055df:	c9                   	leave  
  1055e0:	c3                   	ret    

001055e1 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1055e1:	55                   	push   %ebp
  1055e2:	89 e5                	mov    %esp,%ebp
  1055e4:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1055e7:	8b 45 14             	mov    0x14(%ebp),%eax
  1055ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055ed:	31 d0                	xor    %edx,%eax
  1055ef:	25 ff 0f 00 00       	and    $0xfff,%eax
  1055f4:	85 c0                	test   %eax,%eax
  1055f6:	74 24                	je     10561c <boot_map_segment+0x3b>
  1055f8:	c7 44 24 0c 6a 82 10 	movl   $0x10826a,0xc(%esp)
  1055ff:	00 
  105600:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105607:	00 
  105608:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10560f:	00 
  105610:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105617:	e8 b5 b6 ff ff       	call   100cd1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10561c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  105623:	8b 45 0c             	mov    0xc(%ebp),%eax
  105626:	25 ff 0f 00 00       	and    $0xfff,%eax
  10562b:	89 c2                	mov    %eax,%edx
  10562d:	8b 45 10             	mov    0x10(%ebp),%eax
  105630:	01 c2                	add    %eax,%edx
  105632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105635:	01 d0                	add    %edx,%eax
  105637:	83 e8 01             	sub    $0x1,%eax
  10563a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10563d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105640:	ba 00 00 00 00       	mov    $0x0,%edx
  105645:	f7 75 f0             	divl   -0x10(%ebp)
  105648:	89 d0                	mov    %edx,%eax
  10564a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10564d:	29 c2                	sub    %eax,%edx
  10564f:	89 d0                	mov    %edx,%eax
  105651:	c1 e8 0c             	shr    $0xc,%eax
  105654:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  105657:	8b 45 0c             	mov    0xc(%ebp),%eax
  10565a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10565d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105660:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105665:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  105668:	8b 45 14             	mov    0x14(%ebp),%eax
  10566b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10566e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105671:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105676:	89 45 14             	mov    %eax,0x14(%ebp)
    //线性地址和物理地址映射
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {//低12位对齐
  105679:	eb 6b                	jmp    1056e6 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10567b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  105682:	00 
  105683:	8b 45 0c             	mov    0xc(%ebp),%eax
  105686:	89 44 24 04          	mov    %eax,0x4(%esp)
  10568a:	8b 45 08             	mov    0x8(%ebp),%eax
  10568d:	89 04 24             	mov    %eax,(%esp)
  105690:	e8 cc 01 00 00       	call   105861 <get_pte>
  105695:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  105698:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10569c:	75 24                	jne    1056c2 <boot_map_segment+0xe1>
  10569e:	c7 44 24 0c 96 82 10 	movl   $0x108296,0xc(%esp)
  1056a5:	00 
  1056a6:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1056ad:	00 
  1056ae:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  1056b5:	00 
  1056b6:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1056bd:	e8 0f b6 ff ff       	call   100cd1 <__panic>
        *ptep = pa | PTE_P | perm;
  1056c2:	8b 45 18             	mov    0x18(%ebp),%eax
  1056c5:	8b 55 14             	mov    0x14(%ebp),%edx
  1056c8:	09 d0                	or     %edx,%eax
  1056ca:	83 c8 01             	or     $0x1,%eax
  1056cd:	89 c2                	mov    %eax,%edx
  1056cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056d2:	89 10                	mov    %edx,(%eax)
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    //线性地址和物理地址映射
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {//低12位对齐
  1056d4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1056d8:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1056df:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1056e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1056ea:	75 8f                	jne    10567b <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1056ec:	c9                   	leave  
  1056ed:	c3                   	ret    

001056ee <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1056ee:	55                   	push   %ebp
  1056ef:	89 e5                	mov    %esp,%ebp
  1056f1:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();//pmm.h
  1056f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056fb:	e8 24 fa ff ff       	call   105124 <alloc_pages>
  105700:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  105703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105707:	75 1c                	jne    105725 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  105709:	c7 44 24 08 a3 82 10 	movl   $0x1082a3,0x8(%esp)
  105710:	00 
  105711:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  105718:	00 
  105719:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105720:	e8 ac b5 ff ff       	call   100cd1 <__panic>
    }
    return page2kva(p);//pmm.h
  105725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105728:	89 04 24             	mov    %eax,(%esp)
  10572b:	e8 5d f7 ff ff       	call   104e8d <page2kva>
}
  105730:	c9                   	leave  
  105731:	c3                   	ret    

00105732 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  105732:	55                   	push   %ebp
  105733:	89 e5                	mov    %esp,%ebp
  105735:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  105738:	e8 95 f9 ff ff       	call   1050d2 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10573d:	e8 77 fa ff ff       	call   1051b9 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  105742:	e8 70 04 00 00       	call   105bb7 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  105747:	e8 a2 ff ff ff       	call   1056ee <boot_alloc_page>
  10574c:	a3 a4 b9 11 00       	mov    %eax,0x11b9a4
    memset(boot_pgdir, 0, PGSIZE);
  105751:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105756:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10575d:	00 
  10575e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105765:	00 
  105766:	89 04 24             	mov    %eax,(%esp)
  105769:	e8 b2 1a 00 00       	call   107220 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10576e:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105773:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105776:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10577d:	77 23                	ja     1057a2 <pmm_init+0x70>
  10577f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105782:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105786:	c7 44 24 08 38 82 10 	movl   $0x108238,0x8(%esp)
  10578d:	00 
  10578e:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  105795:	00 
  105796:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  10579d:	e8 2f b5 ff ff       	call   100cd1 <__panic>
  1057a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057a5:	05 00 00 00 40       	add    $0x40000000,%eax
  1057aa:	a3 40 ba 11 00       	mov    %eax,0x11ba40

    check_pgdir();
  1057af:	e8 21 04 00 00       	call   105bd5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1057b4:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  1057b9:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1057bf:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  1057c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057c7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1057ce:	77 23                	ja     1057f3 <pmm_init+0xc1>
  1057d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1057d7:	c7 44 24 08 38 82 10 	movl   $0x108238,0x8(%esp)
  1057de:	00 
  1057df:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  1057e6:	00 
  1057e7:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1057ee:	e8 de b4 ff ff       	call   100cd1 <__panic>
  1057f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057f6:	05 00 00 00 40       	add    $0x40000000,%eax
  1057fb:	83 c8 03             	or     $0x3,%eax
  1057fe:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);//建立一一映射关系
  105800:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105805:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10580c:	00 
  10580d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105814:	00 
  105815:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10581c:	38 
  10581d:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  105824:	c0 
  105825:	89 04 24             	mov    %eax,(%esp)
  105828:	e8 b4 fd ff ff       	call   1055e1 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10582d:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105832:	8b 15 a4 b9 11 00    	mov    0x11b9a4,%edx
  105838:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10583e:	89 10                	mov    %edx,(%eax)

    enable_paging();
  105840:	e8 63 fd ff ff       	call   1055a8 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  105845:	e8 99 f7 ff ff       	call   104fe3 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  10584a:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  10584f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  105855:	e8 16 0a 00 00       	call   106270 <check_boot_pgdir>

    print_pgdir();
  10585a:	e8 a3 0e 00 00       	call   106702 <print_pgdir>

}
  10585f:	c9                   	leave  
  105860:	c3                   	ret    

00105861 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  105861:	55                   	push   %ebp
  105862:	89 e5                	mov    %esp,%ebp
  105864:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

    pde_t *pdep=&pgdir[PDX(la)];
  105867:	8b 45 0c             	mov    0xc(%ebp),%eax
  10586a:	c1 e8 16             	shr    $0x16,%eax
  10586d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105874:	8b 45 08             	mov    0x8(%ebp),%eax
  105877:	01 d0                	add    %edx,%eax
  105879:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //lack 对应的页表空间
    if(!(*pdep&PTE_P))
  10587c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10587f:	8b 00                	mov    (%eax),%eax
  105881:	83 e0 01             	and    $0x1,%eax
  105884:	85 c0                	test   %eax,%eax
  105886:	0f 85 b9 00 00 00    	jne    105945 <get_pte+0xe4>
    {
    	struct Page *page;
    	if(!create)
  10588c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105890:	75 0a                	jne    10589c <get_pte+0x3b>
    		return NULL;
  105892:	b8 00 00 00 00       	mov    $0x0,%eax
  105897:	e9 05 01 00 00       	jmp    1059a1 <get_pte+0x140>
    	page=alloc_page();
  10589c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1058a3:	e8 7c f8 ff ff       	call   105124 <alloc_pages>
  1058a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(page==NULL)
  1058ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1058af:	75 0a                	jne    1058bb <get_pte+0x5a>
    		return NULL;
  1058b1:	b8 00 00 00 00       	mov    $0x0,%eax
  1058b6:	e9 e6 00 00 00       	jmp    1059a1 <get_pte+0x140>
    	set_page_ref(page,1);
  1058bb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1058c2:	00 
  1058c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058c6:	89 04 24             	mov    %eax,(%esp)
  1058c9:	e8 5b f6 ff ff       	call   104f29 <set_page_ref>
    	uintptr_t pa=page2pa(page);//此时物理地址等于线性地址
  1058ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058d1:	89 04 24             	mov    %eax,(%esp)
  1058d4:	e8 50 f5 ff ff       	call   104e29 <page2pa>
  1058d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	memset(KADDR(pa),0,PGSIZE);
  1058dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058e5:	c1 e8 0c             	shr    $0xc,%eax
  1058e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1058eb:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  1058f0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1058f3:	72 23                	jb     105918 <get_pte+0xb7>
  1058f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058fc:	c7 44 24 08 94 81 10 	movl   $0x108194,0x8(%esp)
  105903:	00 
  105904:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
  10590b:	00 
  10590c:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105913:	e8 b9 b3 ff ff       	call   100cd1 <__panic>
  105918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10591b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105920:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105927:	00 
  105928:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10592f:	00 
  105930:	89 04 24             	mov    %eax,(%esp)
  105933:	e8 e8 18 00 00       	call   107220 <memset>
    	*pdep=pa|PTE_U|PTE_W|PTE_P;//填写PDE
  105938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10593b:	83 c8 07             	or     $0x7,%eax
  10593e:	89 c2                	mov    %eax,%edx
  105940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105943:	89 10                	mov    %edx,(%eax)
    }

    return &((pte_t*)KADDR(PDE_ADDR(*pdep)))[PTX(la)];//mmu.h
  105945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105948:	8b 00                	mov    (%eax),%eax
  10594a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10594f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105955:	c1 e8 0c             	shr    $0xc,%eax
  105958:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10595b:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  105960:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  105963:	72 23                	jb     105988 <get_pte+0x127>
  105965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105968:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10596c:	c7 44 24 08 94 81 10 	movl   $0x108194,0x8(%esp)
  105973:	00 
  105974:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
  10597b:	00 
  10597c:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105983:	e8 49 b3 ff ff       	call   100cd1 <__panic>
  105988:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10598b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105990:	8b 55 0c             	mov    0xc(%ebp),%edx
  105993:	c1 ea 0c             	shr    $0xc,%edx
  105996:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10599c:	c1 e2 02             	shl    $0x2,%edx
  10599f:	01 d0                	add    %edx,%eax
}
  1059a1:	c9                   	leave  
  1059a2:	c3                   	ret    

001059a3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1059a3:	55                   	push   %ebp
  1059a4:	89 e5                	mov    %esp,%ebp
  1059a6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1059a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1059b0:	00 
  1059b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059bb:	89 04 24             	mov    %eax,(%esp)
  1059be:	e8 9e fe ff ff       	call   105861 <get_pte>
  1059c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1059c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1059ca:	74 08                	je     1059d4 <get_page+0x31>
        *ptep_store = ptep;
  1059cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1059cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059d2:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1059d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1059d8:	74 1b                	je     1059f5 <get_page+0x52>
  1059da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059dd:	8b 00                	mov    (%eax),%eax
  1059df:	83 e0 01             	and    $0x1,%eax
  1059e2:	85 c0                	test   %eax,%eax
  1059e4:	74 0f                	je     1059f5 <get_page+0x52>
        return pa2page(*ptep);
  1059e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059e9:	8b 00                	mov    (%eax),%eax
  1059eb:	89 04 24             	mov    %eax,(%esp)
  1059ee:	e8 4c f4 ff ff       	call   104e3f <pa2page>
  1059f3:	eb 05                	jmp    1059fa <get_page+0x57>
    }
    return NULL;
  1059f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1059fa:	c9                   	leave  
  1059fb:	c3                   	ret    

001059fc <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1059fc:	55                   	push   %ebp
  1059fd:	89 e5                	mov    %esp,%ebp
  1059ff:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if(*ptep&PTE_P)
  105a02:	8b 45 10             	mov    0x10(%ebp),%eax
  105a05:	8b 00                	mov    (%eax),%eax
  105a07:	83 e0 01             	and    $0x1,%eax
  105a0a:	85 c0                	test   %eax,%eax
  105a0c:	74 4d                	je     105a5b <page_remove_pte+0x5f>
    {
    	struct Page *page=pte2page(*ptep);
  105a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  105a11:	8b 00                	mov    (%eax),%eax
  105a13:	89 04 24             	mov    %eax,(%esp)
  105a16:	e8 c6 f4 ff ff       	call   104ee1 <pte2page>
  105a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if(page_ref_dec(page)==0)
  105a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a21:	89 04 24             	mov    %eax,(%esp)
  105a24:	e8 24 f5 ff ff       	call   104f4d <page_ref_dec>
  105a29:	85 c0                	test   %eax,%eax
  105a2b:	75 13                	jne    105a40 <page_remove_pte+0x44>
    		free_page(page);
  105a2d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105a34:	00 
  105a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a38:	89 04 24             	mov    %eax,(%esp)
  105a3b:	e8 1c f7 ff ff       	call   10515c <free_pages>
    	*ptep=0;
  105a40:	8b 45 10             	mov    0x10(%ebp),%eax
  105a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	tlb_invalidate(pgdir,la);
  105a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a50:	8b 45 08             	mov    0x8(%ebp),%eax
  105a53:	89 04 24             	mov    %eax,(%esp)
  105a56:	e8 ff 00 00 00       	call   105b5a <tlb_invalidate>
    }

}
  105a5b:	c9                   	leave  
  105a5c:	c3                   	ret    

00105a5d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  105a5d:	55                   	push   %ebp
  105a5e:	89 e5                	mov    %esp,%ebp
  105a60:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  105a63:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105a6a:	00 
  105a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a72:	8b 45 08             	mov    0x8(%ebp),%eax
  105a75:	89 04 24             	mov    %eax,(%esp)
  105a78:	e8 e4 fd ff ff       	call   105861 <get_pte>
  105a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  105a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105a84:	74 19                	je     105a9f <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  105a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a89:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a94:	8b 45 08             	mov    0x8(%ebp),%eax
  105a97:	89 04 24             	mov    %eax,(%esp)
  105a9a:	e8 5d ff ff ff       	call   1059fc <page_remove_pte>
    }
}
  105a9f:	c9                   	leave  
  105aa0:	c3                   	ret    

00105aa1 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  105aa1:	55                   	push   %ebp
  105aa2:	89 e5                	mov    %esp,%ebp
  105aa4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  105aa7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  105aae:	00 
  105aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  105ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab9:	89 04 24             	mov    %eax,(%esp)
  105abc:	e8 a0 fd ff ff       	call   105861 <get_pte>
  105ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  105ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105ac8:	75 0a                	jne    105ad4 <page_insert+0x33>
        return -E_NO_MEM;
  105aca:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  105acf:	e9 84 00 00 00       	jmp    105b58 <page_insert+0xb7>
    }
    page_ref_inc(page);
  105ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ad7:	89 04 24             	mov    %eax,(%esp)
  105ada:	e8 57 f4 ff ff       	call   104f36 <page_ref_inc>
    if (*ptep & PTE_P) {
  105adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ae2:	8b 00                	mov    (%eax),%eax
  105ae4:	83 e0 01             	and    $0x1,%eax
  105ae7:	85 c0                	test   %eax,%eax
  105ae9:	74 3e                	je     105b29 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  105aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105aee:	8b 00                	mov    (%eax),%eax
  105af0:	89 04 24             	mov    %eax,(%esp)
  105af3:	e8 e9 f3 ff ff       	call   104ee1 <pte2page>
  105af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  105afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105afe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b01:	75 0d                	jne    105b10 <page_insert+0x6f>
            page_ref_dec(page);
  105b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b06:	89 04 24             	mov    %eax,(%esp)
  105b09:	e8 3f f4 ff ff       	call   104f4d <page_ref_dec>
  105b0e:	eb 19                	jmp    105b29 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  105b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b13:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b17:	8b 45 10             	mov    0x10(%ebp),%eax
  105b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b21:	89 04 24             	mov    %eax,(%esp)
  105b24:	e8 d3 fe ff ff       	call   1059fc <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  105b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b2c:	89 04 24             	mov    %eax,(%esp)
  105b2f:	e8 f5 f2 ff ff       	call   104e29 <page2pa>
  105b34:	0b 45 14             	or     0x14(%ebp),%eax
  105b37:	83 c8 01             	or     $0x1,%eax
  105b3a:	89 c2                	mov    %eax,%edx
  105b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b3f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  105b41:	8b 45 10             	mov    0x10(%ebp),%eax
  105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b48:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4b:	89 04 24             	mov    %eax,(%esp)
  105b4e:	e8 07 00 00 00       	call   105b5a <tlb_invalidate>
    return 0;
  105b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b58:	c9                   	leave  
  105b59:	c3                   	ret    

00105b5a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  105b5a:	55                   	push   %ebp
  105b5b:	89 e5                	mov    %esp,%ebp
  105b5d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  105b60:	0f 20 d8             	mov    %cr3,%eax
  105b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  105b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  105b69:	89 c2                	mov    %eax,%edx
  105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b71:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  105b78:	77 23                	ja     105b9d <tlb_invalidate+0x43>
  105b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b81:	c7 44 24 08 38 82 10 	movl   $0x108238,0x8(%esp)
  105b88:	00 
  105b89:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  105b90:	00 
  105b91:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105b98:	e8 34 b1 ff ff       	call   100cd1 <__panic>
  105b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ba0:	05 00 00 00 40       	add    $0x40000000,%eax
  105ba5:	39 c2                	cmp    %eax,%edx
  105ba7:	75 0c                	jne    105bb5 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  105ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bac:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  105baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105bb2:	0f 01 38             	invlpg (%eax)
    }
}
  105bb5:	c9                   	leave  
  105bb6:	c3                   	ret    

00105bb7 <check_alloc_page>:

static void
check_alloc_page(void) {
  105bb7:	55                   	push   %ebp
  105bb8:	89 e5                	mov    %esp,%ebp
  105bba:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  105bbd:	a1 3c ba 11 00       	mov    0x11ba3c,%eax
  105bc2:	8b 40 18             	mov    0x18(%eax),%eax
  105bc5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  105bc7:	c7 04 24 bc 82 10 00 	movl   $0x1082bc,(%esp)
  105bce:	e8 74 a7 ff ff       	call   100347 <cprintf>
}
  105bd3:	c9                   	leave  
  105bd4:	c3                   	ret    

00105bd5 <check_pgdir>:

static void
check_pgdir(void) {
  105bd5:	55                   	push   %ebp
  105bd6:	89 e5                	mov    %esp,%ebp
  105bd8:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  105bdb:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  105be0:	3d 00 80 03 00       	cmp    $0x38000,%eax
  105be5:	76 24                	jbe    105c0b <check_pgdir+0x36>
  105be7:	c7 44 24 0c db 82 10 	movl   $0x1082db,0xc(%esp)
  105bee:	00 
  105bef:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105bf6:	00 
  105bf7:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  105bfe:	00 
  105bff:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105c06:	e8 c6 b0 ff ff       	call   100cd1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  105c0b:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105c10:	85 c0                	test   %eax,%eax
  105c12:	74 0e                	je     105c22 <check_pgdir+0x4d>
  105c14:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105c19:	25 ff 0f 00 00       	and    $0xfff,%eax
  105c1e:	85 c0                	test   %eax,%eax
  105c20:	74 24                	je     105c46 <check_pgdir+0x71>
  105c22:	c7 44 24 0c f8 82 10 	movl   $0x1082f8,0xc(%esp)
  105c29:	00 
  105c2a:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105c31:	00 
  105c32:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  105c39:	00 
  105c3a:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105c41:	e8 8b b0 ff ff       	call   100cd1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  105c46:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105c4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105c52:	00 
  105c53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105c5a:	00 
  105c5b:	89 04 24             	mov    %eax,(%esp)
  105c5e:	e8 40 fd ff ff       	call   1059a3 <get_page>
  105c63:	85 c0                	test   %eax,%eax
  105c65:	74 24                	je     105c8b <check_pgdir+0xb6>
  105c67:	c7 44 24 0c 30 83 10 	movl   $0x108330,0xc(%esp)
  105c6e:	00 
  105c6f:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105c76:	00 
  105c77:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  105c7e:	00 
  105c7f:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105c86:	e8 46 b0 ff ff       	call   100cd1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  105c8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105c92:	e8 8d f4 ff ff       	call   105124 <alloc_pages>
  105c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  105c9a:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105c9f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105ca6:	00 
  105ca7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105cae:	00 
  105caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105cb2:	89 54 24 04          	mov    %edx,0x4(%esp)
  105cb6:	89 04 24             	mov    %eax,(%esp)
  105cb9:	e8 e3 fd ff ff       	call   105aa1 <page_insert>
  105cbe:	85 c0                	test   %eax,%eax
  105cc0:	74 24                	je     105ce6 <check_pgdir+0x111>
  105cc2:	c7 44 24 0c 58 83 10 	movl   $0x108358,0xc(%esp)
  105cc9:	00 
  105cca:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105cd1:	00 
  105cd2:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  105cd9:	00 
  105cda:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105ce1:	e8 eb af ff ff       	call   100cd1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  105ce6:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105ceb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105cf2:	00 
  105cf3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105cfa:	00 
  105cfb:	89 04 24             	mov    %eax,(%esp)
  105cfe:	e8 5e fb ff ff       	call   105861 <get_pte>
  105d03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105d0a:	75 24                	jne    105d30 <check_pgdir+0x15b>
  105d0c:	c7 44 24 0c 84 83 10 	movl   $0x108384,0xc(%esp)
  105d13:	00 
  105d14:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105d1b:	00 
  105d1c:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  105d23:	00 
  105d24:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105d2b:	e8 a1 af ff ff       	call   100cd1 <__panic>
    assert(pa2page(*ptep) == p1);
  105d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d33:	8b 00                	mov    (%eax),%eax
  105d35:	89 04 24             	mov    %eax,(%esp)
  105d38:	e8 02 f1 ff ff       	call   104e3f <pa2page>
  105d3d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  105d40:	74 24                	je     105d66 <check_pgdir+0x191>
  105d42:	c7 44 24 0c b1 83 10 	movl   $0x1083b1,0xc(%esp)
  105d49:	00 
  105d4a:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105d51:	00 
  105d52:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  105d59:	00 
  105d5a:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105d61:	e8 6b af ff ff       	call   100cd1 <__panic>
    assert(page_ref(p1) == 1);
  105d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d69:	89 04 24             	mov    %eax,(%esp)
  105d6c:	e8 ae f1 ff ff       	call   104f1f <page_ref>
  105d71:	83 f8 01             	cmp    $0x1,%eax
  105d74:	74 24                	je     105d9a <check_pgdir+0x1c5>
  105d76:	c7 44 24 0c c6 83 10 	movl   $0x1083c6,0xc(%esp)
  105d7d:	00 
  105d7e:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105d85:	00 
  105d86:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  105d8d:	00 
  105d8e:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105d95:	e8 37 af ff ff       	call   100cd1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  105d9a:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105d9f:	8b 00                	mov    (%eax),%eax
  105da1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105dac:	c1 e8 0c             	shr    $0xc,%eax
  105daf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105db2:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  105db7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105dba:	72 23                	jb     105ddf <check_pgdir+0x20a>
  105dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105dbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105dc3:	c7 44 24 08 94 81 10 	movl   $0x108194,0x8(%esp)
  105dca:	00 
  105dcb:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  105dd2:	00 
  105dd3:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105dda:	e8 f2 ae ff ff       	call   100cd1 <__panic>
  105ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105de2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105de7:	83 c0 04             	add    $0x4,%eax
  105dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  105ded:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105df2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105df9:	00 
  105dfa:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105e01:	00 
  105e02:	89 04 24             	mov    %eax,(%esp)
  105e05:	e8 57 fa ff ff       	call   105861 <get_pte>
  105e0a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  105e0d:	74 24                	je     105e33 <check_pgdir+0x25e>
  105e0f:	c7 44 24 0c d8 83 10 	movl   $0x1083d8,0xc(%esp)
  105e16:	00 
  105e17:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105e1e:	00 
  105e1f:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  105e26:	00 
  105e27:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105e2e:	e8 9e ae ff ff       	call   100cd1 <__panic>

    p2 = alloc_page();
  105e33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105e3a:	e8 e5 f2 ff ff       	call   105124 <alloc_pages>
  105e3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  105e42:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105e47:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  105e4e:	00 
  105e4f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105e56:	00 
  105e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e5a:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e5e:	89 04 24             	mov    %eax,(%esp)
  105e61:	e8 3b fc ff ff       	call   105aa1 <page_insert>
  105e66:	85 c0                	test   %eax,%eax
  105e68:	74 24                	je     105e8e <check_pgdir+0x2b9>
  105e6a:	c7 44 24 0c 00 84 10 	movl   $0x108400,0xc(%esp)
  105e71:	00 
  105e72:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105e79:	00 
  105e7a:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  105e81:	00 
  105e82:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105e89:	e8 43 ae ff ff       	call   100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  105e8e:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105e93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105e9a:	00 
  105e9b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105ea2:	00 
  105ea3:	89 04 24             	mov    %eax,(%esp)
  105ea6:	e8 b6 f9 ff ff       	call   105861 <get_pte>
  105eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105eae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105eb2:	75 24                	jne    105ed8 <check_pgdir+0x303>
  105eb4:	c7 44 24 0c 38 84 10 	movl   $0x108438,0xc(%esp)
  105ebb:	00 
  105ebc:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105ec3:	00 
  105ec4:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  105ecb:	00 
  105ecc:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105ed3:	e8 f9 ad ff ff       	call   100cd1 <__panic>
    assert(*ptep & PTE_U);
  105ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105edb:	8b 00                	mov    (%eax),%eax
  105edd:	83 e0 04             	and    $0x4,%eax
  105ee0:	85 c0                	test   %eax,%eax
  105ee2:	75 24                	jne    105f08 <check_pgdir+0x333>
  105ee4:	c7 44 24 0c 68 84 10 	movl   $0x108468,0xc(%esp)
  105eeb:	00 
  105eec:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105ef3:	00 
  105ef4:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  105efb:	00 
  105efc:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105f03:	e8 c9 ad ff ff       	call   100cd1 <__panic>
    assert(*ptep & PTE_W);
  105f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f0b:	8b 00                	mov    (%eax),%eax
  105f0d:	83 e0 02             	and    $0x2,%eax
  105f10:	85 c0                	test   %eax,%eax
  105f12:	75 24                	jne    105f38 <check_pgdir+0x363>
  105f14:	c7 44 24 0c 76 84 10 	movl   $0x108476,0xc(%esp)
  105f1b:	00 
  105f1c:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105f23:	00 
  105f24:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  105f2b:	00 
  105f2c:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105f33:	e8 99 ad ff ff       	call   100cd1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  105f38:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105f3d:	8b 00                	mov    (%eax),%eax
  105f3f:	83 e0 04             	and    $0x4,%eax
  105f42:	85 c0                	test   %eax,%eax
  105f44:	75 24                	jne    105f6a <check_pgdir+0x395>
  105f46:	c7 44 24 0c 84 84 10 	movl   $0x108484,0xc(%esp)
  105f4d:	00 
  105f4e:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105f55:	00 
  105f56:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  105f5d:	00 
  105f5e:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105f65:	e8 67 ad ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 1);
  105f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f6d:	89 04 24             	mov    %eax,(%esp)
  105f70:	e8 aa ef ff ff       	call   104f1f <page_ref>
  105f75:	83 f8 01             	cmp    $0x1,%eax
  105f78:	74 24                	je     105f9e <check_pgdir+0x3c9>
  105f7a:	c7 44 24 0c 9a 84 10 	movl   $0x10849a,0xc(%esp)
  105f81:	00 
  105f82:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105f89:	00 
  105f8a:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  105f91:	00 
  105f92:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105f99:	e8 33 ad ff ff       	call   100cd1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  105f9e:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  105fa3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105faa:	00 
  105fab:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105fb2:	00 
  105fb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105fb6:	89 54 24 04          	mov    %edx,0x4(%esp)
  105fba:	89 04 24             	mov    %eax,(%esp)
  105fbd:	e8 df fa ff ff       	call   105aa1 <page_insert>
  105fc2:	85 c0                	test   %eax,%eax
  105fc4:	74 24                	je     105fea <check_pgdir+0x415>
  105fc6:	c7 44 24 0c ac 84 10 	movl   $0x1084ac,0xc(%esp)
  105fcd:	00 
  105fce:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  105fd5:	00 
  105fd6:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  105fdd:	00 
  105fde:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  105fe5:	e8 e7 ac ff ff       	call   100cd1 <__panic>
    assert(page_ref(p1) == 2);
  105fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105fed:	89 04 24             	mov    %eax,(%esp)
  105ff0:	e8 2a ef ff ff       	call   104f1f <page_ref>
  105ff5:	83 f8 02             	cmp    $0x2,%eax
  105ff8:	74 24                	je     10601e <check_pgdir+0x449>
  105ffa:	c7 44 24 0c d8 84 10 	movl   $0x1084d8,0xc(%esp)
  106001:	00 
  106002:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106009:	00 
  10600a:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  106011:	00 
  106012:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106019:	e8 b3 ac ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  10601e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106021:	89 04 24             	mov    %eax,(%esp)
  106024:	e8 f6 ee ff ff       	call   104f1f <page_ref>
  106029:	85 c0                	test   %eax,%eax
  10602b:	74 24                	je     106051 <check_pgdir+0x47c>
  10602d:	c7 44 24 0c ea 84 10 	movl   $0x1084ea,0xc(%esp)
  106034:	00 
  106035:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  10603c:	00 
  10603d:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  106044:	00 
  106045:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  10604c:	e8 80 ac ff ff       	call   100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  106051:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  106056:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10605d:	00 
  10605e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  106065:	00 
  106066:	89 04 24             	mov    %eax,(%esp)
  106069:	e8 f3 f7 ff ff       	call   105861 <get_pte>
  10606e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106075:	75 24                	jne    10609b <check_pgdir+0x4c6>
  106077:	c7 44 24 0c 38 84 10 	movl   $0x108438,0xc(%esp)
  10607e:	00 
  10607f:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106086:	00 
  106087:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  10608e:	00 
  10608f:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106096:	e8 36 ac ff ff       	call   100cd1 <__panic>
    assert(pa2page(*ptep) == p1);
  10609b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10609e:	8b 00                	mov    (%eax),%eax
  1060a0:	89 04 24             	mov    %eax,(%esp)
  1060a3:	e8 97 ed ff ff       	call   104e3f <pa2page>
  1060a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1060ab:	74 24                	je     1060d1 <check_pgdir+0x4fc>
  1060ad:	c7 44 24 0c b1 83 10 	movl   $0x1083b1,0xc(%esp)
  1060b4:	00 
  1060b5:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1060bc:	00 
  1060bd:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  1060c4:	00 
  1060c5:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1060cc:	e8 00 ac ff ff       	call   100cd1 <__panic>
    assert((*ptep & PTE_U) == 0);
  1060d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060d4:	8b 00                	mov    (%eax),%eax
  1060d6:	83 e0 04             	and    $0x4,%eax
  1060d9:	85 c0                	test   %eax,%eax
  1060db:	74 24                	je     106101 <check_pgdir+0x52c>
  1060dd:	c7 44 24 0c fc 84 10 	movl   $0x1084fc,0xc(%esp)
  1060e4:	00 
  1060e5:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1060ec:	00 
  1060ed:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  1060f4:	00 
  1060f5:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1060fc:	e8 d0 ab ff ff       	call   100cd1 <__panic>

    page_remove(boot_pgdir, 0x0);
  106101:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  106106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10610d:	00 
  10610e:	89 04 24             	mov    %eax,(%esp)
  106111:	e8 47 f9 ff ff       	call   105a5d <page_remove>
    assert(page_ref(p1) == 1);
  106116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106119:	89 04 24             	mov    %eax,(%esp)
  10611c:	e8 fe ed ff ff       	call   104f1f <page_ref>
  106121:	83 f8 01             	cmp    $0x1,%eax
  106124:	74 24                	je     10614a <check_pgdir+0x575>
  106126:	c7 44 24 0c c6 83 10 	movl   $0x1083c6,0xc(%esp)
  10612d:	00 
  10612e:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106135:	00 
  106136:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  10613d:	00 
  10613e:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106145:	e8 87 ab ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  10614a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10614d:	89 04 24             	mov    %eax,(%esp)
  106150:	e8 ca ed ff ff       	call   104f1f <page_ref>
  106155:	85 c0                	test   %eax,%eax
  106157:	74 24                	je     10617d <check_pgdir+0x5a8>
  106159:	c7 44 24 0c ea 84 10 	movl   $0x1084ea,0xc(%esp)
  106160:	00 
  106161:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106168:	00 
  106169:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  106170:	00 
  106171:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106178:	e8 54 ab ff ff       	call   100cd1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  10617d:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  106182:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  106189:	00 
  10618a:	89 04 24             	mov    %eax,(%esp)
  10618d:	e8 cb f8 ff ff       	call   105a5d <page_remove>
    assert(page_ref(p1) == 0);
  106192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106195:	89 04 24             	mov    %eax,(%esp)
  106198:	e8 82 ed ff ff       	call   104f1f <page_ref>
  10619d:	85 c0                	test   %eax,%eax
  10619f:	74 24                	je     1061c5 <check_pgdir+0x5f0>
  1061a1:	c7 44 24 0c 11 85 10 	movl   $0x108511,0xc(%esp)
  1061a8:	00 
  1061a9:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1061b0:	00 
  1061b1:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  1061b8:	00 
  1061b9:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1061c0:	e8 0c ab ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  1061c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1061c8:	89 04 24             	mov    %eax,(%esp)
  1061cb:	e8 4f ed ff ff       	call   104f1f <page_ref>
  1061d0:	85 c0                	test   %eax,%eax
  1061d2:	74 24                	je     1061f8 <check_pgdir+0x623>
  1061d4:	c7 44 24 0c ea 84 10 	movl   $0x1084ea,0xc(%esp)
  1061db:	00 
  1061dc:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1061e3:	00 
  1061e4:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  1061eb:	00 
  1061ec:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1061f3:	e8 d9 aa ff ff       	call   100cd1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  1061f8:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  1061fd:	8b 00                	mov    (%eax),%eax
  1061ff:	89 04 24             	mov    %eax,(%esp)
  106202:	e8 38 ec ff ff       	call   104e3f <pa2page>
  106207:	89 04 24             	mov    %eax,(%esp)
  10620a:	e8 10 ed ff ff       	call   104f1f <page_ref>
  10620f:	83 f8 01             	cmp    $0x1,%eax
  106212:	74 24                	je     106238 <check_pgdir+0x663>
  106214:	c7 44 24 0c 24 85 10 	movl   $0x108524,0xc(%esp)
  10621b:	00 
  10621c:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106223:	00 
  106224:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  10622b:	00 
  10622c:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106233:	e8 99 aa ff ff       	call   100cd1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  106238:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  10623d:	8b 00                	mov    (%eax),%eax
  10623f:	89 04 24             	mov    %eax,(%esp)
  106242:	e8 f8 eb ff ff       	call   104e3f <pa2page>
  106247:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10624e:	00 
  10624f:	89 04 24             	mov    %eax,(%esp)
  106252:	e8 05 ef ff ff       	call   10515c <free_pages>
    boot_pgdir[0] = 0;
  106257:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  10625c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  106262:	c7 04 24 4a 85 10 00 	movl   $0x10854a,(%esp)
  106269:	e8 d9 a0 ff ff       	call   100347 <cprintf>
}
  10626e:	c9                   	leave  
  10626f:	c3                   	ret    

00106270 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  106270:	55                   	push   %ebp
  106271:	89 e5                	mov    %esp,%ebp
  106273:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  106276:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10627d:	e9 ca 00 00 00       	jmp    10634c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  106282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10628b:	c1 e8 0c             	shr    $0xc,%eax
  10628e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106291:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  106296:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  106299:	72 23                	jb     1062be <check_boot_pgdir+0x4e>
  10629b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10629e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1062a2:	c7 44 24 08 94 81 10 	movl   $0x108194,0x8(%esp)
  1062a9:	00 
  1062aa:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  1062b1:	00 
  1062b2:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1062b9:	e8 13 aa ff ff       	call   100cd1 <__panic>
  1062be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1062c1:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1062c6:	89 c2                	mov    %eax,%edx
  1062c8:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  1062cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1062d4:	00 
  1062d5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1062d9:	89 04 24             	mov    %eax,(%esp)
  1062dc:	e8 80 f5 ff ff       	call   105861 <get_pte>
  1062e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1062e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1062e8:	75 24                	jne    10630e <check_boot_pgdir+0x9e>
  1062ea:	c7 44 24 0c 64 85 10 	movl   $0x108564,0xc(%esp)
  1062f1:	00 
  1062f2:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1062f9:	00 
  1062fa:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  106301:	00 
  106302:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106309:	e8 c3 a9 ff ff       	call   100cd1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  10630e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106311:	8b 00                	mov    (%eax),%eax
  106313:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  106318:	89 c2                	mov    %eax,%edx
  10631a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10631d:	39 c2                	cmp    %eax,%edx
  10631f:	74 24                	je     106345 <check_boot_pgdir+0xd5>
  106321:	c7 44 24 0c a1 85 10 	movl   $0x1085a1,0xc(%esp)
  106328:	00 
  106329:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106330:	00 
  106331:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  106338:	00 
  106339:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106340:	e8 8c a9 ff ff       	call   100cd1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  106345:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  10634c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10634f:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  106354:	39 c2                	cmp    %eax,%edx
  106356:	0f 82 26 ff ff ff    	jb     106282 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  10635c:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  106361:	05 ac 0f 00 00       	add    $0xfac,%eax
  106366:	8b 00                	mov    (%eax),%eax
  106368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10636d:	89 c2                	mov    %eax,%edx
  10636f:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  106374:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106377:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  10637e:	77 23                	ja     1063a3 <check_boot_pgdir+0x133>
  106380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106383:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106387:	c7 44 24 08 38 82 10 	movl   $0x108238,0x8(%esp)
  10638e:	00 
  10638f:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  106396:	00 
  106397:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  10639e:	e8 2e a9 ff ff       	call   100cd1 <__panic>
  1063a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063a6:	05 00 00 00 40       	add    $0x40000000,%eax
  1063ab:	39 c2                	cmp    %eax,%edx
  1063ad:	74 24                	je     1063d3 <check_boot_pgdir+0x163>
  1063af:	c7 44 24 0c b8 85 10 	movl   $0x1085b8,0xc(%esp)
  1063b6:	00 
  1063b7:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1063be:	00 
  1063bf:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  1063c6:	00 
  1063c7:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1063ce:	e8 fe a8 ff ff       	call   100cd1 <__panic>

    assert(boot_pgdir[0] == 0);
  1063d3:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  1063d8:	8b 00                	mov    (%eax),%eax
  1063da:	85 c0                	test   %eax,%eax
  1063dc:	74 24                	je     106402 <check_boot_pgdir+0x192>
  1063de:	c7 44 24 0c ec 85 10 	movl   $0x1085ec,0xc(%esp)
  1063e5:	00 
  1063e6:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1063ed:	00 
  1063ee:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  1063f5:	00 
  1063f6:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1063fd:	e8 cf a8 ff ff       	call   100cd1 <__panic>

    struct Page *p;
    p = alloc_page();
  106402:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106409:	e8 16 ed ff ff       	call   105124 <alloc_pages>
  10640e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  106411:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  106416:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10641d:	00 
  10641e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  106425:	00 
  106426:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106429:	89 54 24 04          	mov    %edx,0x4(%esp)
  10642d:	89 04 24             	mov    %eax,(%esp)
  106430:	e8 6c f6 ff ff       	call   105aa1 <page_insert>
  106435:	85 c0                	test   %eax,%eax
  106437:	74 24                	je     10645d <check_boot_pgdir+0x1ed>
  106439:	c7 44 24 0c 00 86 10 	movl   $0x108600,0xc(%esp)
  106440:	00 
  106441:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106448:	00 
  106449:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
  106450:	00 
  106451:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106458:	e8 74 a8 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p) == 1);
  10645d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106460:	89 04 24             	mov    %eax,(%esp)
  106463:	e8 b7 ea ff ff       	call   104f1f <page_ref>
  106468:	83 f8 01             	cmp    $0x1,%eax
  10646b:	74 24                	je     106491 <check_boot_pgdir+0x221>
  10646d:	c7 44 24 0c 2e 86 10 	movl   $0x10862e,0xc(%esp)
  106474:	00 
  106475:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  10647c:	00 
  10647d:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  106484:	00 
  106485:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  10648c:	e8 40 a8 ff ff       	call   100cd1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  106491:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  106496:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10649d:	00 
  10649e:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1064a5:	00 
  1064a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1064a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1064ad:	89 04 24             	mov    %eax,(%esp)
  1064b0:	e8 ec f5 ff ff       	call   105aa1 <page_insert>
  1064b5:	85 c0                	test   %eax,%eax
  1064b7:	74 24                	je     1064dd <check_boot_pgdir+0x26d>
  1064b9:	c7 44 24 0c 40 86 10 	movl   $0x108640,0xc(%esp)
  1064c0:	00 
  1064c1:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1064c8:	00 
  1064c9:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  1064d0:	00 
  1064d1:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1064d8:	e8 f4 a7 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p) == 2);
  1064dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1064e0:	89 04 24             	mov    %eax,(%esp)
  1064e3:	e8 37 ea ff ff       	call   104f1f <page_ref>
  1064e8:	83 f8 02             	cmp    $0x2,%eax
  1064eb:	74 24                	je     106511 <check_boot_pgdir+0x2a1>
  1064ed:	c7 44 24 0c 77 86 10 	movl   $0x108677,0xc(%esp)
  1064f4:	00 
  1064f5:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  1064fc:	00 
  1064fd:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  106504:	00 
  106505:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  10650c:	e8 c0 a7 ff ff       	call   100cd1 <__panic>

    const char *str = "ucore: Hello world!!";
  106511:	c7 45 dc 88 86 10 00 	movl   $0x108688,-0x24(%ebp)
    strcpy((void *)0x100, str);
  106518:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10651b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10651f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  106526:	e8 1e 0a 00 00       	call   106f49 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10652b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  106532:	00 
  106533:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10653a:	e8 83 0a 00 00       	call   106fc2 <strcmp>
  10653f:	85 c0                	test   %eax,%eax
  106541:	74 24                	je     106567 <check_boot_pgdir+0x2f7>
  106543:	c7 44 24 0c a0 86 10 	movl   $0x1086a0,0xc(%esp)
  10654a:	00 
  10654b:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106552:	00 
  106553:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
  10655a:	00 
  10655b:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  106562:	e8 6a a7 ff ff       	call   100cd1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  106567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10656a:	89 04 24             	mov    %eax,(%esp)
  10656d:	e8 1b e9 ff ff       	call   104e8d <page2kva>
  106572:	05 00 01 00 00       	add    $0x100,%eax
  106577:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10657a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  106581:	e8 6b 09 00 00       	call   106ef1 <strlen>
  106586:	85 c0                	test   %eax,%eax
  106588:	74 24                	je     1065ae <check_boot_pgdir+0x33e>
  10658a:	c7 44 24 0c d8 86 10 	movl   $0x1086d8,0xc(%esp)
  106591:	00 
  106592:	c7 44 24 08 81 82 10 	movl   $0x108281,0x8(%esp)
  106599:	00 
  10659a:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
  1065a1:	00 
  1065a2:	c7 04 24 5c 82 10 00 	movl   $0x10825c,(%esp)
  1065a9:	e8 23 a7 ff ff       	call   100cd1 <__panic>

    free_page(p);
  1065ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1065b5:	00 
  1065b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1065b9:	89 04 24             	mov    %eax,(%esp)
  1065bc:	e8 9b eb ff ff       	call   10515c <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1065c1:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  1065c6:	8b 00                	mov    (%eax),%eax
  1065c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1065cd:	89 04 24             	mov    %eax,(%esp)
  1065d0:	e8 6a e8 ff ff       	call   104e3f <pa2page>
  1065d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1065dc:	00 
  1065dd:	89 04 24             	mov    %eax,(%esp)
  1065e0:	e8 77 eb ff ff       	call   10515c <free_pages>
    boot_pgdir[0] = 0;
  1065e5:	a1 a4 b9 11 00       	mov    0x11b9a4,%eax
  1065ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1065f0:	c7 04 24 fc 86 10 00 	movl   $0x1086fc,(%esp)
  1065f7:	e8 4b 9d ff ff       	call   100347 <cprintf>
}
  1065fc:	c9                   	leave  
  1065fd:	c3                   	ret    

001065fe <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1065fe:	55                   	push   %ebp
  1065ff:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  106601:	8b 45 08             	mov    0x8(%ebp),%eax
  106604:	83 e0 04             	and    $0x4,%eax
  106607:	85 c0                	test   %eax,%eax
  106609:	74 07                	je     106612 <perm2str+0x14>
  10660b:	b8 75 00 00 00       	mov    $0x75,%eax
  106610:	eb 05                	jmp    106617 <perm2str+0x19>
  106612:	b8 2d 00 00 00       	mov    $0x2d,%eax
  106617:	a2 28 ba 11 00       	mov    %al,0x11ba28
    str[1] = 'r';
  10661c:	c6 05 29 ba 11 00 72 	movb   $0x72,0x11ba29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  106623:	8b 45 08             	mov    0x8(%ebp),%eax
  106626:	83 e0 02             	and    $0x2,%eax
  106629:	85 c0                	test   %eax,%eax
  10662b:	74 07                	je     106634 <perm2str+0x36>
  10662d:	b8 77 00 00 00       	mov    $0x77,%eax
  106632:	eb 05                	jmp    106639 <perm2str+0x3b>
  106634:	b8 2d 00 00 00       	mov    $0x2d,%eax
  106639:	a2 2a ba 11 00       	mov    %al,0x11ba2a
    str[3] = '\0';
  10663e:	c6 05 2b ba 11 00 00 	movb   $0x0,0x11ba2b
    return str;
  106645:	b8 28 ba 11 00       	mov    $0x11ba28,%eax
}
  10664a:	5d                   	pop    %ebp
  10664b:	c3                   	ret    

0010664c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10664c:	55                   	push   %ebp
  10664d:	89 e5                	mov    %esp,%ebp
  10664f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  106652:	8b 45 10             	mov    0x10(%ebp),%eax
  106655:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106658:	72 0a                	jb     106664 <get_pgtable_items+0x18>
        return 0;
  10665a:	b8 00 00 00 00       	mov    $0x0,%eax
  10665f:	e9 9c 00 00 00       	jmp    106700 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  106664:	eb 04                	jmp    10666a <get_pgtable_items+0x1e>
        start ++;
  106666:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10666a:	8b 45 10             	mov    0x10(%ebp),%eax
  10666d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106670:	73 18                	jae    10668a <get_pgtable_items+0x3e>
  106672:	8b 45 10             	mov    0x10(%ebp),%eax
  106675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10667c:	8b 45 14             	mov    0x14(%ebp),%eax
  10667f:	01 d0                	add    %edx,%eax
  106681:	8b 00                	mov    (%eax),%eax
  106683:	83 e0 01             	and    $0x1,%eax
  106686:	85 c0                	test   %eax,%eax
  106688:	74 dc                	je     106666 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10668a:	8b 45 10             	mov    0x10(%ebp),%eax
  10668d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106690:	73 69                	jae    1066fb <get_pgtable_items+0xaf>
    	//记录左边界
        if (left_store != NULL) {
  106692:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  106696:	74 08                	je     1066a0 <get_pgtable_items+0x54>
            *left_store = start;
  106698:	8b 45 18             	mov    0x18(%ebp),%eax
  10669b:	8b 55 10             	mov    0x10(%ebp),%edx
  10669e:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1066a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1066a3:	8d 50 01             	lea    0x1(%eax),%edx
  1066a6:	89 55 10             	mov    %edx,0x10(%ebp)
  1066a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1066b0:	8b 45 14             	mov    0x14(%ebp),%eax
  1066b3:	01 d0                	add    %edx,%eax
  1066b5:	8b 00                	mov    (%eax),%eax
  1066b7:	83 e0 07             	and    $0x7,%eax
  1066ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1066bd:	eb 04                	jmp    1066c3 <get_pgtable_items+0x77>
            start ++;
  1066bf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    	//记录左边界
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1066c3:	8b 45 10             	mov    0x10(%ebp),%eax
  1066c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1066c9:	73 1d                	jae    1066e8 <get_pgtable_items+0x9c>
  1066cb:	8b 45 10             	mov    0x10(%ebp),%eax
  1066ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1066d5:	8b 45 14             	mov    0x14(%ebp),%eax
  1066d8:	01 d0                	add    %edx,%eax
  1066da:	8b 00                	mov    (%eax),%eax
  1066dc:	83 e0 07             	and    $0x7,%eax
  1066df:	89 c2                	mov    %eax,%edx
  1066e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1066e4:	39 c2                	cmp    %eax,%edx
  1066e6:	74 d7                	je     1066bf <get_pgtable_items+0x73>
            start ++;
        }
        //跳出循环，记录右边界
        if (right_store != NULL) {
  1066e8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1066ec:	74 08                	je     1066f6 <get_pgtable_items+0xaa>
            *right_store = start;
  1066ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1066f1:	8b 55 10             	mov    0x10(%ebp),%edx
  1066f4:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1066f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1066f9:	eb 05                	jmp    106700 <get_pgtable_items+0xb4>
    }
    return 0;
  1066fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106700:	c9                   	leave  
  106701:	c3                   	ret    

00106702 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  106702:	55                   	push   %ebp
  106703:	89 e5                	mov    %esp,%ebp
  106705:	57                   	push   %edi
  106706:	56                   	push   %esi
  106707:	53                   	push   %ebx
  106708:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10670b:	c7 04 24 1c 87 10 00 	movl   $0x10871c,(%esp)
  106712:	e8 30 9c ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
  106717:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10671e:	e9 fa 00 00 00       	jmp    10681d <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  106723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106726:	89 04 24             	mov    %eax,(%esp)
  106729:	e8 d0 fe ff ff       	call   1065fe <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10672e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106731:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106734:	29 d1                	sub    %edx,%ecx
  106736:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  106738:	89 d6                	mov    %edx,%esi
  10673a:	c1 e6 16             	shl    $0x16,%esi
  10673d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106740:	89 d3                	mov    %edx,%ebx
  106742:	c1 e3 16             	shl    $0x16,%ebx
  106745:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106748:	89 d1                	mov    %edx,%ecx
  10674a:	c1 e1 16             	shl    $0x16,%ecx
  10674d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  106750:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106753:	29 d7                	sub    %edx,%edi
  106755:	89 fa                	mov    %edi,%edx
  106757:	89 44 24 14          	mov    %eax,0x14(%esp)
  10675b:	89 74 24 10          	mov    %esi,0x10(%esp)
  10675f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106763:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  106767:	89 54 24 04          	mov    %edx,0x4(%esp)
  10676b:	c7 04 24 4d 87 10 00 	movl   $0x10874d,(%esp)
  106772:	e8 d0 9b ff ff       	call   100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  106777:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10677a:	c1 e0 0a             	shl    $0xa,%eax
  10677d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  106780:	eb 54                	jmp    1067d6 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  106782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106785:	89 04 24             	mov    %eax,(%esp)
  106788:	e8 71 fe ff ff       	call   1065fe <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10678d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  106790:	8b 55 d8             	mov    -0x28(%ebp),%edx
  106793:	29 d1                	sub    %edx,%ecx
  106795:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  106797:	89 d6                	mov    %edx,%esi
  106799:	c1 e6 0c             	shl    $0xc,%esi
  10679c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10679f:	89 d3                	mov    %edx,%ebx
  1067a1:	c1 e3 0c             	shl    $0xc,%ebx
  1067a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1067a7:	c1 e2 0c             	shl    $0xc,%edx
  1067aa:	89 d1                	mov    %edx,%ecx
  1067ac:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1067af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1067b2:	29 d7                	sub    %edx,%edi
  1067b4:	89 fa                	mov    %edi,%edx
  1067b6:	89 44 24 14          	mov    %eax,0x14(%esp)
  1067ba:	89 74 24 10          	mov    %esi,0x10(%esp)
  1067be:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1067c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1067c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1067ca:	c7 04 24 6c 87 10 00 	movl   $0x10876c,(%esp)
  1067d1:	e8 71 9b ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1067d6:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1067db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1067de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1067e1:	89 ce                	mov    %ecx,%esi
  1067e3:	c1 e6 0a             	shl    $0xa,%esi
  1067e6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1067e9:	89 cb                	mov    %ecx,%ebx
  1067eb:	c1 e3 0a             	shl    $0xa,%ebx
  1067ee:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1067f1:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1067f5:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1067f8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1067fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106800:	89 44 24 08          	mov    %eax,0x8(%esp)
  106804:	89 74 24 04          	mov    %esi,0x4(%esp)
  106808:	89 1c 24             	mov    %ebx,(%esp)
  10680b:	e8 3c fe ff ff       	call   10664c <get_pgtable_items>
  106810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106813:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106817:	0f 85 65 ff ff ff    	jne    106782 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10681d:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  106822:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106825:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  106828:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10682c:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10682f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  106833:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106837:	89 44 24 08          	mov    %eax,0x8(%esp)
  10683b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  106842:	00 
  106843:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10684a:	e8 fd fd ff ff       	call   10664c <get_pgtable_items>
  10684f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106852:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106856:	0f 85 c7 fe ff ff    	jne    106723 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10685c:	c7 04 24 90 87 10 00 	movl   $0x108790,(%esp)
  106863:	e8 df 9a ff ff       	call   100347 <cprintf>
}
  106868:	83 c4 4c             	add    $0x4c,%esp
  10686b:	5b                   	pop    %ebx
  10686c:	5e                   	pop    %esi
  10686d:	5f                   	pop    %edi
  10686e:	5d                   	pop    %ebp
  10686f:	c3                   	ret    

00106870 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  106870:	55                   	push   %ebp
  106871:	89 e5                	mov    %esp,%ebp
  106873:	83 ec 58             	sub    $0x58,%esp
  106876:	8b 45 10             	mov    0x10(%ebp),%eax
  106879:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10687c:	8b 45 14             	mov    0x14(%ebp),%eax
  10687f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  106882:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106888:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10688b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10688e:	8b 45 18             	mov    0x18(%ebp),%eax
  106891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106894:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106897:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10689a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10689d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1068a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1068a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1068aa:	74 1c                	je     1068c8 <printnum+0x58>
  1068ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068af:	ba 00 00 00 00       	mov    $0x0,%edx
  1068b4:	f7 75 e4             	divl   -0x1c(%ebp)
  1068b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1068ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068bd:	ba 00 00 00 00       	mov    $0x0,%edx
  1068c2:	f7 75 e4             	divl   -0x1c(%ebp)
  1068c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1068c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1068cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1068ce:	f7 75 e4             	divl   -0x1c(%ebp)
  1068d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1068d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1068d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1068da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1068dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1068e0:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1068e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1068e6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1068e9:	8b 45 18             	mov    0x18(%ebp),%eax
  1068ec:	ba 00 00 00 00       	mov    $0x0,%edx
  1068f1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1068f4:	77 56                	ja     10694c <printnum+0xdc>
  1068f6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1068f9:	72 05                	jb     106900 <printnum+0x90>
  1068fb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1068fe:	77 4c                	ja     10694c <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  106900:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106903:	8d 50 ff             	lea    -0x1(%eax),%edx
  106906:	8b 45 20             	mov    0x20(%ebp),%eax
  106909:	89 44 24 18          	mov    %eax,0x18(%esp)
  10690d:	89 54 24 14          	mov    %edx,0x14(%esp)
  106911:	8b 45 18             	mov    0x18(%ebp),%eax
  106914:	89 44 24 10          	mov    %eax,0x10(%esp)
  106918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10691b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10691e:	89 44 24 08          	mov    %eax,0x8(%esp)
  106922:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106926:	8b 45 0c             	mov    0xc(%ebp),%eax
  106929:	89 44 24 04          	mov    %eax,0x4(%esp)
  10692d:	8b 45 08             	mov    0x8(%ebp),%eax
  106930:	89 04 24             	mov    %eax,(%esp)
  106933:	e8 38 ff ff ff       	call   106870 <printnum>
  106938:	eb 1c                	jmp    106956 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10693a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10693d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106941:	8b 45 20             	mov    0x20(%ebp),%eax
  106944:	89 04 24             	mov    %eax,(%esp)
  106947:	8b 45 08             	mov    0x8(%ebp),%eax
  10694a:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10694c:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  106950:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106954:	7f e4                	jg     10693a <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  106956:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106959:	05 44 88 10 00       	add    $0x108844,%eax
  10695e:	0f b6 00             	movzbl (%eax),%eax
  106961:	0f be c0             	movsbl %al,%eax
  106964:	8b 55 0c             	mov    0xc(%ebp),%edx
  106967:	89 54 24 04          	mov    %edx,0x4(%esp)
  10696b:	89 04 24             	mov    %eax,(%esp)
  10696e:	8b 45 08             	mov    0x8(%ebp),%eax
  106971:	ff d0                	call   *%eax
}
  106973:	c9                   	leave  
  106974:	c3                   	ret    

00106975 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  106975:	55                   	push   %ebp
  106976:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106978:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10697c:	7e 14                	jle    106992 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10697e:	8b 45 08             	mov    0x8(%ebp),%eax
  106981:	8b 00                	mov    (%eax),%eax
  106983:	8d 48 08             	lea    0x8(%eax),%ecx
  106986:	8b 55 08             	mov    0x8(%ebp),%edx
  106989:	89 0a                	mov    %ecx,(%edx)
  10698b:	8b 50 04             	mov    0x4(%eax),%edx
  10698e:	8b 00                	mov    (%eax),%eax
  106990:	eb 30                	jmp    1069c2 <getuint+0x4d>
    }
    else if (lflag) {
  106992:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106996:	74 16                	je     1069ae <getuint+0x39>
        return va_arg(*ap, unsigned long);
  106998:	8b 45 08             	mov    0x8(%ebp),%eax
  10699b:	8b 00                	mov    (%eax),%eax
  10699d:	8d 48 04             	lea    0x4(%eax),%ecx
  1069a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1069a3:	89 0a                	mov    %ecx,(%edx)
  1069a5:	8b 00                	mov    (%eax),%eax
  1069a7:	ba 00 00 00 00       	mov    $0x0,%edx
  1069ac:	eb 14                	jmp    1069c2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1069ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1069b1:	8b 00                	mov    (%eax),%eax
  1069b3:	8d 48 04             	lea    0x4(%eax),%ecx
  1069b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1069b9:	89 0a                	mov    %ecx,(%edx)
  1069bb:	8b 00                	mov    (%eax),%eax
  1069bd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1069c2:	5d                   	pop    %ebp
  1069c3:	c3                   	ret    

001069c4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1069c4:	55                   	push   %ebp
  1069c5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1069c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1069cb:	7e 14                	jle    1069e1 <getint+0x1d>
        return va_arg(*ap, long long);
  1069cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1069d0:	8b 00                	mov    (%eax),%eax
  1069d2:	8d 48 08             	lea    0x8(%eax),%ecx
  1069d5:	8b 55 08             	mov    0x8(%ebp),%edx
  1069d8:	89 0a                	mov    %ecx,(%edx)
  1069da:	8b 50 04             	mov    0x4(%eax),%edx
  1069dd:	8b 00                	mov    (%eax),%eax
  1069df:	eb 28                	jmp    106a09 <getint+0x45>
    }
    else if (lflag) {
  1069e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1069e5:	74 12                	je     1069f9 <getint+0x35>
        return va_arg(*ap, long);
  1069e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1069ea:	8b 00                	mov    (%eax),%eax
  1069ec:	8d 48 04             	lea    0x4(%eax),%ecx
  1069ef:	8b 55 08             	mov    0x8(%ebp),%edx
  1069f2:	89 0a                	mov    %ecx,(%edx)
  1069f4:	8b 00                	mov    (%eax),%eax
  1069f6:	99                   	cltd   
  1069f7:	eb 10                	jmp    106a09 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1069f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1069fc:	8b 00                	mov    (%eax),%eax
  1069fe:	8d 48 04             	lea    0x4(%eax),%ecx
  106a01:	8b 55 08             	mov    0x8(%ebp),%edx
  106a04:	89 0a                	mov    %ecx,(%edx)
  106a06:	8b 00                	mov    (%eax),%eax
  106a08:	99                   	cltd   
    }
}
  106a09:	5d                   	pop    %ebp
  106a0a:	c3                   	ret    

00106a0b <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  106a0b:	55                   	push   %ebp
  106a0c:	89 e5                	mov    %esp,%ebp
  106a0e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  106a11:	8d 45 14             	lea    0x14(%ebp),%eax
  106a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  106a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106a1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  106a21:	89 44 24 08          	mov    %eax,0x8(%esp)
  106a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  106a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  106a2f:	89 04 24             	mov    %eax,(%esp)
  106a32:	e8 02 00 00 00       	call   106a39 <vprintfmt>
    va_end(ap);
}
  106a37:	c9                   	leave  
  106a38:	c3                   	ret    

00106a39 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  106a39:	55                   	push   %ebp
  106a3a:	89 e5                	mov    %esp,%ebp
  106a3c:	56                   	push   %esi
  106a3d:	53                   	push   %ebx
  106a3e:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106a41:	eb 18                	jmp    106a5b <vprintfmt+0x22>
            if (ch == '\0') {
  106a43:	85 db                	test   %ebx,%ebx
  106a45:	75 05                	jne    106a4c <vprintfmt+0x13>
                return;
  106a47:	e9 d1 03 00 00       	jmp    106e1d <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  106a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106a53:	89 1c 24             	mov    %ebx,(%esp)
  106a56:	8b 45 08             	mov    0x8(%ebp),%eax
  106a59:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  106a5e:	8d 50 01             	lea    0x1(%eax),%edx
  106a61:	89 55 10             	mov    %edx,0x10(%ebp)
  106a64:	0f b6 00             	movzbl (%eax),%eax
  106a67:	0f b6 d8             	movzbl %al,%ebx
  106a6a:	83 fb 25             	cmp    $0x25,%ebx
  106a6d:	75 d4                	jne    106a43 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  106a6f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  106a73:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  106a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106a7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  106a80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  106a87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106a8a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  106a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  106a90:	8d 50 01             	lea    0x1(%eax),%edx
  106a93:	89 55 10             	mov    %edx,0x10(%ebp)
  106a96:	0f b6 00             	movzbl (%eax),%eax
  106a99:	0f b6 d8             	movzbl %al,%ebx
  106a9c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  106a9f:	83 f8 55             	cmp    $0x55,%eax
  106aa2:	0f 87 44 03 00 00    	ja     106dec <vprintfmt+0x3b3>
  106aa8:	8b 04 85 68 88 10 00 	mov    0x108868(,%eax,4),%eax
  106aaf:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  106ab1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  106ab5:	eb d6                	jmp    106a8d <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  106ab7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  106abb:	eb d0                	jmp    106a8d <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  106abd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  106ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106ac7:	89 d0                	mov    %edx,%eax
  106ac9:	c1 e0 02             	shl    $0x2,%eax
  106acc:	01 d0                	add    %edx,%eax
  106ace:	01 c0                	add    %eax,%eax
  106ad0:	01 d8                	add    %ebx,%eax
  106ad2:	83 e8 30             	sub    $0x30,%eax
  106ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  106ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  106adb:	0f b6 00             	movzbl (%eax),%eax
  106ade:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  106ae1:	83 fb 2f             	cmp    $0x2f,%ebx
  106ae4:	7e 0b                	jle    106af1 <vprintfmt+0xb8>
  106ae6:	83 fb 39             	cmp    $0x39,%ebx
  106ae9:	7f 06                	jg     106af1 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  106aeb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  106aef:	eb d3                	jmp    106ac4 <vprintfmt+0x8b>
            goto process_precision;
  106af1:	eb 33                	jmp    106b26 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  106af3:	8b 45 14             	mov    0x14(%ebp),%eax
  106af6:	8d 50 04             	lea    0x4(%eax),%edx
  106af9:	89 55 14             	mov    %edx,0x14(%ebp)
  106afc:	8b 00                	mov    (%eax),%eax
  106afe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  106b01:	eb 23                	jmp    106b26 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  106b03:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106b07:	79 0c                	jns    106b15 <vprintfmt+0xdc>
                width = 0;
  106b09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  106b10:	e9 78 ff ff ff       	jmp    106a8d <vprintfmt+0x54>
  106b15:	e9 73 ff ff ff       	jmp    106a8d <vprintfmt+0x54>

        case '#':
            altflag = 1;
  106b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  106b21:	e9 67 ff ff ff       	jmp    106a8d <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  106b26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106b2a:	79 12                	jns    106b3e <vprintfmt+0x105>
                width = precision, precision = -1;
  106b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106b32:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  106b39:	e9 4f ff ff ff       	jmp    106a8d <vprintfmt+0x54>
  106b3e:	e9 4a ff ff ff       	jmp    106a8d <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  106b43:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  106b47:	e9 41 ff ff ff       	jmp    106a8d <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  106b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  106b4f:	8d 50 04             	lea    0x4(%eax),%edx
  106b52:	89 55 14             	mov    %edx,0x14(%ebp)
  106b55:	8b 00                	mov    (%eax),%eax
  106b57:	8b 55 0c             	mov    0xc(%ebp),%edx
  106b5a:	89 54 24 04          	mov    %edx,0x4(%esp)
  106b5e:	89 04 24             	mov    %eax,(%esp)
  106b61:	8b 45 08             	mov    0x8(%ebp),%eax
  106b64:	ff d0                	call   *%eax
            break;
  106b66:	e9 ac 02 00 00       	jmp    106e17 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  106b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  106b6e:	8d 50 04             	lea    0x4(%eax),%edx
  106b71:	89 55 14             	mov    %edx,0x14(%ebp)
  106b74:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  106b76:	85 db                	test   %ebx,%ebx
  106b78:	79 02                	jns    106b7c <vprintfmt+0x143>
                err = -err;
  106b7a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  106b7c:	83 fb 06             	cmp    $0x6,%ebx
  106b7f:	7f 0b                	jg     106b8c <vprintfmt+0x153>
  106b81:	8b 34 9d 28 88 10 00 	mov    0x108828(,%ebx,4),%esi
  106b88:	85 f6                	test   %esi,%esi
  106b8a:	75 23                	jne    106baf <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  106b8c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106b90:	c7 44 24 08 55 88 10 	movl   $0x108855,0x8(%esp)
  106b97:	00 
  106b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  106b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  106b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  106ba2:	89 04 24             	mov    %eax,(%esp)
  106ba5:	e8 61 fe ff ff       	call   106a0b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  106baa:	e9 68 02 00 00       	jmp    106e17 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  106baf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  106bb3:	c7 44 24 08 5e 88 10 	movl   $0x10885e,0x8(%esp)
  106bba:	00 
  106bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  106bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  106bc5:	89 04 24             	mov    %eax,(%esp)
  106bc8:	e8 3e fe ff ff       	call   106a0b <printfmt>
            }
            break;
  106bcd:	e9 45 02 00 00       	jmp    106e17 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  106bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  106bd5:	8d 50 04             	lea    0x4(%eax),%edx
  106bd8:	89 55 14             	mov    %edx,0x14(%ebp)
  106bdb:	8b 30                	mov    (%eax),%esi
  106bdd:	85 f6                	test   %esi,%esi
  106bdf:	75 05                	jne    106be6 <vprintfmt+0x1ad>
                p = "(null)";
  106be1:	be 61 88 10 00       	mov    $0x108861,%esi
            }
            if (width > 0 && padc != '-') {
  106be6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106bea:	7e 3e                	jle    106c2a <vprintfmt+0x1f1>
  106bec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  106bf0:	74 38                	je     106c2a <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  106bf2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  106bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  106bfc:	89 34 24             	mov    %esi,(%esp)
  106bff:	e8 15 03 00 00       	call   106f19 <strnlen>
  106c04:	29 c3                	sub    %eax,%ebx
  106c06:	89 d8                	mov    %ebx,%eax
  106c08:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106c0b:	eb 17                	jmp    106c24 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  106c0d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  106c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  106c14:	89 54 24 04          	mov    %edx,0x4(%esp)
  106c18:	89 04 24             	mov    %eax,(%esp)
  106c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  106c1e:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  106c20:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  106c24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106c28:	7f e3                	jg     106c0d <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106c2a:	eb 38                	jmp    106c64 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  106c2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  106c30:	74 1f                	je     106c51 <vprintfmt+0x218>
  106c32:	83 fb 1f             	cmp    $0x1f,%ebx
  106c35:	7e 05                	jle    106c3c <vprintfmt+0x203>
  106c37:	83 fb 7e             	cmp    $0x7e,%ebx
  106c3a:	7e 15                	jle    106c51 <vprintfmt+0x218>
                    putch('?', putdat);
  106c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c43:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  106c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  106c4d:	ff d0                	call   *%eax
  106c4f:	eb 0f                	jmp    106c60 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  106c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c58:	89 1c 24             	mov    %ebx,(%esp)
  106c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  106c5e:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106c60:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  106c64:	89 f0                	mov    %esi,%eax
  106c66:	8d 70 01             	lea    0x1(%eax),%esi
  106c69:	0f b6 00             	movzbl (%eax),%eax
  106c6c:	0f be d8             	movsbl %al,%ebx
  106c6f:	85 db                	test   %ebx,%ebx
  106c71:	74 10                	je     106c83 <vprintfmt+0x24a>
  106c73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106c77:	78 b3                	js     106c2c <vprintfmt+0x1f3>
  106c79:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  106c7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106c81:	79 a9                	jns    106c2c <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  106c83:	eb 17                	jmp    106c9c <vprintfmt+0x263>
                putch(' ', putdat);
  106c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c8c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  106c93:	8b 45 08             	mov    0x8(%ebp),%eax
  106c96:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  106c98:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  106c9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106ca0:	7f e3                	jg     106c85 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  106ca2:	e9 70 01 00 00       	jmp    106e17 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  106ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  106cae:	8d 45 14             	lea    0x14(%ebp),%eax
  106cb1:	89 04 24             	mov    %eax,(%esp)
  106cb4:	e8 0b fd ff ff       	call   1069c4 <getint>
  106cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106cbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  106cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106cc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106cc5:	85 d2                	test   %edx,%edx
  106cc7:	79 26                	jns    106cef <vprintfmt+0x2b6>
                putch('-', putdat);
  106cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  106cd0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  106cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  106cda:	ff d0                	call   *%eax
                num = -(long long)num;
  106cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106ce2:	f7 d8                	neg    %eax
  106ce4:	83 d2 00             	adc    $0x0,%edx
  106ce7:	f7 da                	neg    %edx
  106ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106cec:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  106cef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106cf6:	e9 a8 00 00 00       	jmp    106da3 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  106cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d02:	8d 45 14             	lea    0x14(%ebp),%eax
  106d05:	89 04 24             	mov    %eax,(%esp)
  106d08:	e8 68 fc ff ff       	call   106975 <getuint>
  106d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106d10:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  106d13:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106d1a:	e9 84 00 00 00       	jmp    106da3 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  106d1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d26:	8d 45 14             	lea    0x14(%ebp),%eax
  106d29:	89 04 24             	mov    %eax,(%esp)
  106d2c:	e8 44 fc ff ff       	call   106975 <getuint>
  106d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106d34:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106d37:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  106d3e:	eb 63                	jmp    106da3 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  106d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d47:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  106d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  106d51:	ff d0                	call   *%eax
            putch('x', putdat);
  106d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d56:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d5a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106d61:	8b 45 08             	mov    0x8(%ebp),%eax
  106d64:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  106d66:	8b 45 14             	mov    0x14(%ebp),%eax
  106d69:	8d 50 04             	lea    0x4(%eax),%edx
  106d6c:	89 55 14             	mov    %edx,0x14(%ebp)
  106d6f:	8b 00                	mov    (%eax),%eax
  106d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106d74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  106d7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106d82:	eb 1f                	jmp    106da3 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106d84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106d87:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d8b:	8d 45 14             	lea    0x14(%ebp),%eax
  106d8e:	89 04 24             	mov    %eax,(%esp)
  106d91:	e8 df fb ff ff       	call   106975 <getuint>
  106d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106d99:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  106d9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  106da3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  106da7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106daa:	89 54 24 18          	mov    %edx,0x18(%esp)
  106dae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106db1:	89 54 24 14          	mov    %edx,0x14(%esp)
  106db5:	89 44 24 10          	mov    %eax,0x10(%esp)
  106db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106dbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  106dc3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  106dca:	89 44 24 04          	mov    %eax,0x4(%esp)
  106dce:	8b 45 08             	mov    0x8(%ebp),%eax
  106dd1:	89 04 24             	mov    %eax,(%esp)
  106dd4:	e8 97 fa ff ff       	call   106870 <printnum>
            break;
  106dd9:	eb 3c                	jmp    106e17 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  106ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  106dde:	89 44 24 04          	mov    %eax,0x4(%esp)
  106de2:	89 1c 24             	mov    %ebx,(%esp)
  106de5:	8b 45 08             	mov    0x8(%ebp),%eax
  106de8:	ff d0                	call   *%eax
            break;
  106dea:	eb 2b                	jmp    106e17 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  106def:	89 44 24 04          	mov    %eax,0x4(%esp)
  106df3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  106dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  106dfd:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  106dff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106e03:	eb 04                	jmp    106e09 <vprintfmt+0x3d0>
  106e05:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106e09:	8b 45 10             	mov    0x10(%ebp),%eax
  106e0c:	83 e8 01             	sub    $0x1,%eax
  106e0f:	0f b6 00             	movzbl (%eax),%eax
  106e12:	3c 25                	cmp    $0x25,%al
  106e14:	75 ef                	jne    106e05 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  106e16:	90                   	nop
        }
    }
  106e17:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106e18:	e9 3e fc ff ff       	jmp    106a5b <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  106e1d:	83 c4 40             	add    $0x40,%esp
  106e20:	5b                   	pop    %ebx
  106e21:	5e                   	pop    %esi
  106e22:	5d                   	pop    %ebp
  106e23:	c3                   	ret    

00106e24 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106e24:	55                   	push   %ebp
  106e25:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e2a:	8b 40 08             	mov    0x8(%eax),%eax
  106e2d:	8d 50 01             	lea    0x1(%eax),%edx
  106e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e33:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e39:	8b 10                	mov    (%eax),%edx
  106e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e3e:	8b 40 04             	mov    0x4(%eax),%eax
  106e41:	39 c2                	cmp    %eax,%edx
  106e43:	73 12                	jae    106e57 <sprintputch+0x33>
        *b->buf ++ = ch;
  106e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e48:	8b 00                	mov    (%eax),%eax
  106e4a:	8d 48 01             	lea    0x1(%eax),%ecx
  106e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e50:	89 0a                	mov    %ecx,(%edx)
  106e52:	8b 55 08             	mov    0x8(%ebp),%edx
  106e55:	88 10                	mov    %dl,(%eax)
    }
}
  106e57:	5d                   	pop    %ebp
  106e58:	c3                   	ret    

00106e59 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106e59:	55                   	push   %ebp
  106e5a:	89 e5                	mov    %esp,%ebp
  106e5c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106e5f:	8d 45 14             	lea    0x14(%ebp),%eax
  106e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106e68:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  106e6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  106e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e76:	89 44 24 04          	mov    %eax,0x4(%esp)
  106e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  106e7d:	89 04 24             	mov    %eax,(%esp)
  106e80:	e8 08 00 00 00       	call   106e8d <vsnprintf>
  106e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106e8b:	c9                   	leave  
  106e8c:	c3                   	ret    

00106e8d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106e8d:	55                   	push   %ebp
  106e8e:	89 e5                	mov    %esp,%ebp
  106e90:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106e93:	8b 45 08             	mov    0x8(%ebp),%eax
  106e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e9c:	8d 50 ff             	lea    -0x1(%eax),%edx
  106e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  106ea2:	01 d0                	add    %edx,%eax
  106ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106ea7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106eae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106eb2:	74 0a                	je     106ebe <vsnprintf+0x31>
  106eb4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106eba:	39 c2                	cmp    %eax,%edx
  106ebc:	76 07                	jbe    106ec5 <vsnprintf+0x38>
        return -E_INVAL;
  106ebe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106ec3:	eb 2a                	jmp    106eef <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  106ec5:	8b 45 14             	mov    0x14(%ebp),%eax
  106ec8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  106ecf:	89 44 24 08          	mov    %eax,0x8(%esp)
  106ed3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
  106eda:	c7 04 24 24 6e 10 00 	movl   $0x106e24,(%esp)
  106ee1:	e8 53 fb ff ff       	call   106a39 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  106ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106ee9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106eef:	c9                   	leave  
  106ef0:	c3                   	ret    

00106ef1 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  106ef1:	55                   	push   %ebp
  106ef2:	89 e5                	mov    %esp,%ebp
  106ef4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  106ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  106efe:	eb 04                	jmp    106f04 <strlen+0x13>
        cnt ++;
  106f00:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  106f04:	8b 45 08             	mov    0x8(%ebp),%eax
  106f07:	8d 50 01             	lea    0x1(%eax),%edx
  106f0a:	89 55 08             	mov    %edx,0x8(%ebp)
  106f0d:	0f b6 00             	movzbl (%eax),%eax
  106f10:	84 c0                	test   %al,%al
  106f12:	75 ec                	jne    106f00 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  106f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106f17:	c9                   	leave  
  106f18:	c3                   	ret    

00106f19 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  106f19:	55                   	push   %ebp
  106f1a:	89 e5                	mov    %esp,%ebp
  106f1c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  106f1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  106f26:	eb 04                	jmp    106f2c <strnlen+0x13>
        cnt ++;
  106f28:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  106f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106f2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106f32:	73 10                	jae    106f44 <strnlen+0x2b>
  106f34:	8b 45 08             	mov    0x8(%ebp),%eax
  106f37:	8d 50 01             	lea    0x1(%eax),%edx
  106f3a:	89 55 08             	mov    %edx,0x8(%ebp)
  106f3d:	0f b6 00             	movzbl (%eax),%eax
  106f40:	84 c0                	test   %al,%al
  106f42:	75 e4                	jne    106f28 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  106f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106f47:	c9                   	leave  
  106f48:	c3                   	ret    

00106f49 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  106f49:	55                   	push   %ebp
  106f4a:	89 e5                	mov    %esp,%ebp
  106f4c:	57                   	push   %edi
  106f4d:	56                   	push   %esi
  106f4e:	83 ec 20             	sub    $0x20,%esp
  106f51:	8b 45 08             	mov    0x8(%ebp),%eax
  106f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  106f5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106f63:	89 d1                	mov    %edx,%ecx
  106f65:	89 c2                	mov    %eax,%edx
  106f67:	89 ce                	mov    %ecx,%esi
  106f69:	89 d7                	mov    %edx,%edi
  106f6b:	ac                   	lods   %ds:(%esi),%al
  106f6c:	aa                   	stos   %al,%es:(%edi)
  106f6d:	84 c0                	test   %al,%al
  106f6f:	75 fa                	jne    106f6b <strcpy+0x22>
  106f71:	89 fa                	mov    %edi,%edx
  106f73:	89 f1                	mov    %esi,%ecx
  106f75:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106f78:	89 55 e8             	mov    %edx,-0x18(%ebp)
  106f7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  106f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  106f81:	83 c4 20             	add    $0x20,%esp
  106f84:	5e                   	pop    %esi
  106f85:	5f                   	pop    %edi
  106f86:	5d                   	pop    %ebp
  106f87:	c3                   	ret    

00106f88 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  106f88:	55                   	push   %ebp
  106f89:	89 e5                	mov    %esp,%ebp
  106f8b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  106f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  106f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  106f94:	eb 21                	jmp    106fb7 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  106f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f99:	0f b6 10             	movzbl (%eax),%edx
  106f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106f9f:	88 10                	mov    %dl,(%eax)
  106fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106fa4:	0f b6 00             	movzbl (%eax),%eax
  106fa7:	84 c0                	test   %al,%al
  106fa9:	74 04                	je     106faf <strncpy+0x27>
            src ++;
  106fab:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  106faf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106fb3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  106fb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106fbb:	75 d9                	jne    106f96 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  106fbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106fc0:	c9                   	leave  
  106fc1:	c3                   	ret    

00106fc2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  106fc2:	55                   	push   %ebp
  106fc3:	89 e5                	mov    %esp,%ebp
  106fc5:	57                   	push   %edi
  106fc6:	56                   	push   %esi
  106fc7:	83 ec 20             	sub    $0x20,%esp
  106fca:	8b 45 08             	mov    0x8(%ebp),%eax
  106fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  106fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  106fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106fdc:	89 d1                	mov    %edx,%ecx
  106fde:	89 c2                	mov    %eax,%edx
  106fe0:	89 ce                	mov    %ecx,%esi
  106fe2:	89 d7                	mov    %edx,%edi
  106fe4:	ac                   	lods   %ds:(%esi),%al
  106fe5:	ae                   	scas   %es:(%edi),%al
  106fe6:	75 08                	jne    106ff0 <strcmp+0x2e>
  106fe8:	84 c0                	test   %al,%al
  106fea:	75 f8                	jne    106fe4 <strcmp+0x22>
  106fec:	31 c0                	xor    %eax,%eax
  106fee:	eb 04                	jmp    106ff4 <strcmp+0x32>
  106ff0:	19 c0                	sbb    %eax,%eax
  106ff2:	0c 01                	or     $0x1,%al
  106ff4:	89 fa                	mov    %edi,%edx
  106ff6:	89 f1                	mov    %esi,%ecx
  106ff8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106ffb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106ffe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  107001:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  107004:	83 c4 20             	add    $0x20,%esp
  107007:	5e                   	pop    %esi
  107008:	5f                   	pop    %edi
  107009:	5d                   	pop    %ebp
  10700a:	c3                   	ret    

0010700b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10700b:	55                   	push   %ebp
  10700c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10700e:	eb 0c                	jmp    10701c <strncmp+0x11>
        n --, s1 ++, s2 ++;
  107010:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  107014:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  107018:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10701c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107020:	74 1a                	je     10703c <strncmp+0x31>
  107022:	8b 45 08             	mov    0x8(%ebp),%eax
  107025:	0f b6 00             	movzbl (%eax),%eax
  107028:	84 c0                	test   %al,%al
  10702a:	74 10                	je     10703c <strncmp+0x31>
  10702c:	8b 45 08             	mov    0x8(%ebp),%eax
  10702f:	0f b6 10             	movzbl (%eax),%edx
  107032:	8b 45 0c             	mov    0xc(%ebp),%eax
  107035:	0f b6 00             	movzbl (%eax),%eax
  107038:	38 c2                	cmp    %al,%dl
  10703a:	74 d4                	je     107010 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10703c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107040:	74 18                	je     10705a <strncmp+0x4f>
  107042:	8b 45 08             	mov    0x8(%ebp),%eax
  107045:	0f b6 00             	movzbl (%eax),%eax
  107048:	0f b6 d0             	movzbl %al,%edx
  10704b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10704e:	0f b6 00             	movzbl (%eax),%eax
  107051:	0f b6 c0             	movzbl %al,%eax
  107054:	29 c2                	sub    %eax,%edx
  107056:	89 d0                	mov    %edx,%eax
  107058:	eb 05                	jmp    10705f <strncmp+0x54>
  10705a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10705f:	5d                   	pop    %ebp
  107060:	c3                   	ret    

00107061 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  107061:	55                   	push   %ebp
  107062:	89 e5                	mov    %esp,%ebp
  107064:	83 ec 04             	sub    $0x4,%esp
  107067:	8b 45 0c             	mov    0xc(%ebp),%eax
  10706a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10706d:	eb 14                	jmp    107083 <strchr+0x22>
        if (*s == c) {
  10706f:	8b 45 08             	mov    0x8(%ebp),%eax
  107072:	0f b6 00             	movzbl (%eax),%eax
  107075:	3a 45 fc             	cmp    -0x4(%ebp),%al
  107078:	75 05                	jne    10707f <strchr+0x1e>
            return (char *)s;
  10707a:	8b 45 08             	mov    0x8(%ebp),%eax
  10707d:	eb 13                	jmp    107092 <strchr+0x31>
        }
        s ++;
  10707f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  107083:	8b 45 08             	mov    0x8(%ebp),%eax
  107086:	0f b6 00             	movzbl (%eax),%eax
  107089:	84 c0                	test   %al,%al
  10708b:	75 e2                	jne    10706f <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10708d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  107092:	c9                   	leave  
  107093:	c3                   	ret    

00107094 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  107094:	55                   	push   %ebp
  107095:	89 e5                	mov    %esp,%ebp
  107097:	83 ec 04             	sub    $0x4,%esp
  10709a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10709d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1070a0:	eb 11                	jmp    1070b3 <strfind+0x1f>
        if (*s == c) {
  1070a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1070a5:	0f b6 00             	movzbl (%eax),%eax
  1070a8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1070ab:	75 02                	jne    1070af <strfind+0x1b>
            break;
  1070ad:	eb 0e                	jmp    1070bd <strfind+0x29>
        }
        s ++;
  1070af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1070b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1070b6:	0f b6 00             	movzbl (%eax),%eax
  1070b9:	84 c0                	test   %al,%al
  1070bb:	75 e5                	jne    1070a2 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1070bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1070c0:	c9                   	leave  
  1070c1:	c3                   	ret    

001070c2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1070c2:	55                   	push   %ebp
  1070c3:	89 e5                	mov    %esp,%ebp
  1070c5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1070c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1070cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1070d6:	eb 04                	jmp    1070dc <strtol+0x1a>
        s ++;
  1070d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1070dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1070df:	0f b6 00             	movzbl (%eax),%eax
  1070e2:	3c 20                	cmp    $0x20,%al
  1070e4:	74 f2                	je     1070d8 <strtol+0x16>
  1070e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1070e9:	0f b6 00             	movzbl (%eax),%eax
  1070ec:	3c 09                	cmp    $0x9,%al
  1070ee:	74 e8                	je     1070d8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1070f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1070f3:	0f b6 00             	movzbl (%eax),%eax
  1070f6:	3c 2b                	cmp    $0x2b,%al
  1070f8:	75 06                	jne    107100 <strtol+0x3e>
        s ++;
  1070fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1070fe:	eb 15                	jmp    107115 <strtol+0x53>
    }
    else if (*s == '-') {
  107100:	8b 45 08             	mov    0x8(%ebp),%eax
  107103:	0f b6 00             	movzbl (%eax),%eax
  107106:	3c 2d                	cmp    $0x2d,%al
  107108:	75 0b                	jne    107115 <strtol+0x53>
        s ++, neg = 1;
  10710a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10710e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  107115:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107119:	74 06                	je     107121 <strtol+0x5f>
  10711b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10711f:	75 24                	jne    107145 <strtol+0x83>
  107121:	8b 45 08             	mov    0x8(%ebp),%eax
  107124:	0f b6 00             	movzbl (%eax),%eax
  107127:	3c 30                	cmp    $0x30,%al
  107129:	75 1a                	jne    107145 <strtol+0x83>
  10712b:	8b 45 08             	mov    0x8(%ebp),%eax
  10712e:	83 c0 01             	add    $0x1,%eax
  107131:	0f b6 00             	movzbl (%eax),%eax
  107134:	3c 78                	cmp    $0x78,%al
  107136:	75 0d                	jne    107145 <strtol+0x83>
        s += 2, base = 16;
  107138:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10713c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  107143:	eb 2a                	jmp    10716f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  107145:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107149:	75 17                	jne    107162 <strtol+0xa0>
  10714b:	8b 45 08             	mov    0x8(%ebp),%eax
  10714e:	0f b6 00             	movzbl (%eax),%eax
  107151:	3c 30                	cmp    $0x30,%al
  107153:	75 0d                	jne    107162 <strtol+0xa0>
        s ++, base = 8;
  107155:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  107159:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  107160:	eb 0d                	jmp    10716f <strtol+0xad>
    }
    else if (base == 0) {
  107162:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107166:	75 07                	jne    10716f <strtol+0xad>
        base = 10;
  107168:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10716f:	8b 45 08             	mov    0x8(%ebp),%eax
  107172:	0f b6 00             	movzbl (%eax),%eax
  107175:	3c 2f                	cmp    $0x2f,%al
  107177:	7e 1b                	jle    107194 <strtol+0xd2>
  107179:	8b 45 08             	mov    0x8(%ebp),%eax
  10717c:	0f b6 00             	movzbl (%eax),%eax
  10717f:	3c 39                	cmp    $0x39,%al
  107181:	7f 11                	jg     107194 <strtol+0xd2>
            dig = *s - '0';
  107183:	8b 45 08             	mov    0x8(%ebp),%eax
  107186:	0f b6 00             	movzbl (%eax),%eax
  107189:	0f be c0             	movsbl %al,%eax
  10718c:	83 e8 30             	sub    $0x30,%eax
  10718f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107192:	eb 48                	jmp    1071dc <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  107194:	8b 45 08             	mov    0x8(%ebp),%eax
  107197:	0f b6 00             	movzbl (%eax),%eax
  10719a:	3c 60                	cmp    $0x60,%al
  10719c:	7e 1b                	jle    1071b9 <strtol+0xf7>
  10719e:	8b 45 08             	mov    0x8(%ebp),%eax
  1071a1:	0f b6 00             	movzbl (%eax),%eax
  1071a4:	3c 7a                	cmp    $0x7a,%al
  1071a6:	7f 11                	jg     1071b9 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1071a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1071ab:	0f b6 00             	movzbl (%eax),%eax
  1071ae:	0f be c0             	movsbl %al,%eax
  1071b1:	83 e8 57             	sub    $0x57,%eax
  1071b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1071b7:	eb 23                	jmp    1071dc <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1071b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1071bc:	0f b6 00             	movzbl (%eax),%eax
  1071bf:	3c 40                	cmp    $0x40,%al
  1071c1:	7e 3d                	jle    107200 <strtol+0x13e>
  1071c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1071c6:	0f b6 00             	movzbl (%eax),%eax
  1071c9:	3c 5a                	cmp    $0x5a,%al
  1071cb:	7f 33                	jg     107200 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1071cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1071d0:	0f b6 00             	movzbl (%eax),%eax
  1071d3:	0f be c0             	movsbl %al,%eax
  1071d6:	83 e8 37             	sub    $0x37,%eax
  1071d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1071dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1071df:	3b 45 10             	cmp    0x10(%ebp),%eax
  1071e2:	7c 02                	jl     1071e6 <strtol+0x124>
            break;
  1071e4:	eb 1a                	jmp    107200 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1071e6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1071ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1071ed:	0f af 45 10          	imul   0x10(%ebp),%eax
  1071f1:	89 c2                	mov    %eax,%edx
  1071f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1071f6:	01 d0                	add    %edx,%eax
  1071f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1071fb:	e9 6f ff ff ff       	jmp    10716f <strtol+0xad>

    if (endptr) {
  107200:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  107204:	74 08                	je     10720e <strtol+0x14c>
        *endptr = (char *) s;
  107206:	8b 45 0c             	mov    0xc(%ebp),%eax
  107209:	8b 55 08             	mov    0x8(%ebp),%edx
  10720c:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10720e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  107212:	74 07                	je     10721b <strtol+0x159>
  107214:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107217:	f7 d8                	neg    %eax
  107219:	eb 03                	jmp    10721e <strtol+0x15c>
  10721b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10721e:	c9                   	leave  
  10721f:	c3                   	ret    

00107220 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  107220:	55                   	push   %ebp
  107221:	89 e5                	mov    %esp,%ebp
  107223:	57                   	push   %edi
  107224:	83 ec 24             	sub    $0x24,%esp
  107227:	8b 45 0c             	mov    0xc(%ebp),%eax
  10722a:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10722d:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  107231:	8b 55 08             	mov    0x8(%ebp),%edx
  107234:	89 55 f8             	mov    %edx,-0x8(%ebp)
  107237:	88 45 f7             	mov    %al,-0x9(%ebp)
  10723a:	8b 45 10             	mov    0x10(%ebp),%eax
  10723d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  107240:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  107243:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  107247:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10724a:	89 d7                	mov    %edx,%edi
  10724c:	f3 aa                	rep stos %al,%es:(%edi)
  10724e:	89 fa                	mov    %edi,%edx
  107250:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  107253:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  107256:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  107259:	83 c4 24             	add    $0x24,%esp
  10725c:	5f                   	pop    %edi
  10725d:	5d                   	pop    %ebp
  10725e:	c3                   	ret    

0010725f <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10725f:	55                   	push   %ebp
  107260:	89 e5                	mov    %esp,%ebp
  107262:	57                   	push   %edi
  107263:	56                   	push   %esi
  107264:	53                   	push   %ebx
  107265:	83 ec 30             	sub    $0x30,%esp
  107268:	8b 45 08             	mov    0x8(%ebp),%eax
  10726b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10726e:	8b 45 0c             	mov    0xc(%ebp),%eax
  107271:	89 45 ec             	mov    %eax,-0x14(%ebp)
  107274:	8b 45 10             	mov    0x10(%ebp),%eax
  107277:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10727a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10727d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  107280:	73 42                	jae    1072c4 <memmove+0x65>
  107282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107285:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  107288:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10728b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10728e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107291:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  107294:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107297:	c1 e8 02             	shr    $0x2,%eax
  10729a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10729c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10729f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1072a2:	89 d7                	mov    %edx,%edi
  1072a4:	89 c6                	mov    %eax,%esi
  1072a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1072a8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1072ab:	83 e1 03             	and    $0x3,%ecx
  1072ae:	74 02                	je     1072b2 <memmove+0x53>
  1072b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1072b2:	89 f0                	mov    %esi,%eax
  1072b4:	89 fa                	mov    %edi,%edx
  1072b6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1072b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1072bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1072bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1072c2:	eb 36                	jmp    1072fa <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1072c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1072c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1072ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1072cd:	01 c2                	add    %eax,%edx
  1072cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1072d2:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1072d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1072d8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1072db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1072de:	89 c1                	mov    %eax,%ecx
  1072e0:	89 d8                	mov    %ebx,%eax
  1072e2:	89 d6                	mov    %edx,%esi
  1072e4:	89 c7                	mov    %eax,%edi
  1072e6:	fd                   	std    
  1072e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1072e9:	fc                   	cld    
  1072ea:	89 f8                	mov    %edi,%eax
  1072ec:	89 f2                	mov    %esi,%edx
  1072ee:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1072f1:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1072f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  1072f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1072fa:	83 c4 30             	add    $0x30,%esp
  1072fd:	5b                   	pop    %ebx
  1072fe:	5e                   	pop    %esi
  1072ff:	5f                   	pop    %edi
  107300:	5d                   	pop    %ebp
  107301:	c3                   	ret    

00107302 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  107302:	55                   	push   %ebp
  107303:	89 e5                	mov    %esp,%ebp
  107305:	57                   	push   %edi
  107306:	56                   	push   %esi
  107307:	83 ec 20             	sub    $0x20,%esp
  10730a:	8b 45 08             	mov    0x8(%ebp),%eax
  10730d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107310:	8b 45 0c             	mov    0xc(%ebp),%eax
  107313:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107316:	8b 45 10             	mov    0x10(%ebp),%eax
  107319:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10731c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10731f:	c1 e8 02             	shr    $0x2,%eax
  107322:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  107324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  107327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10732a:	89 d7                	mov    %edx,%edi
  10732c:	89 c6                	mov    %eax,%esi
  10732e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  107330:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  107333:	83 e1 03             	and    $0x3,%ecx
  107336:	74 02                	je     10733a <memcpy+0x38>
  107338:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10733a:	89 f0                	mov    %esi,%eax
  10733c:	89 fa                	mov    %edi,%edx
  10733e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  107341:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  107344:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  107347:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10734a:	83 c4 20             	add    $0x20,%esp
  10734d:	5e                   	pop    %esi
  10734e:	5f                   	pop    %edi
  10734f:	5d                   	pop    %ebp
  107350:	c3                   	ret    

00107351 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  107351:	55                   	push   %ebp
  107352:	89 e5                	mov    %esp,%ebp
  107354:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  107357:	8b 45 08             	mov    0x8(%ebp),%eax
  10735a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10735d:	8b 45 0c             	mov    0xc(%ebp),%eax
  107360:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  107363:	eb 30                	jmp    107395 <memcmp+0x44>
        if (*s1 != *s2) {
  107365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  107368:	0f b6 10             	movzbl (%eax),%edx
  10736b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10736e:	0f b6 00             	movzbl (%eax),%eax
  107371:	38 c2                	cmp    %al,%dl
  107373:	74 18                	je     10738d <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  107375:	8b 45 fc             	mov    -0x4(%ebp),%eax
  107378:	0f b6 00             	movzbl (%eax),%eax
  10737b:	0f b6 d0             	movzbl %al,%edx
  10737e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107381:	0f b6 00             	movzbl (%eax),%eax
  107384:	0f b6 c0             	movzbl %al,%eax
  107387:	29 c2                	sub    %eax,%edx
  107389:	89 d0                	mov    %edx,%eax
  10738b:	eb 1a                	jmp    1073a7 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10738d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  107391:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  107395:	8b 45 10             	mov    0x10(%ebp),%eax
  107398:	8d 50 ff             	lea    -0x1(%eax),%edx
  10739b:	89 55 10             	mov    %edx,0x10(%ebp)
  10739e:	85 c0                	test   %eax,%eax
  1073a0:	75 c3                	jne    107365 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1073a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1073a7:	c9                   	leave  
  1073a8:	c3                   	ret    
