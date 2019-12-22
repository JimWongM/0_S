
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 a0 11 00 	lgdtl  0x11a018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss
	#memlayout.h
    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 a0 11 c0       	mov    $0xc011a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 48 ba 11 c0       	mov    $0xc011ba48,%edx
c0100035:	b8 36 aa 11 c0       	mov    $0xc011aa36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 aa 11 c0 	movl   $0xc011aa36,(%esp)
c0100051:	e8 ca 71 00 00       	call   c0107220 <memset>

    cons_init();                // init the console
c0100056:	e8 7c 15 00 00       	call   c01015d7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 73 10 c0 	movl   $0xc01073c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc 73 10 c0 	movl   $0xc01073dc,(%esp)
c0100070:	e8 d2 02 00 00       	call   c0100347 <cprintf>

    print_kerninfo();
c0100075:	e8 01 08 00 00       	call   c010087b <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 ae 56 00 00       	call   c0105732 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b7 16 00 00       	call   c0101740 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 2f 18 00 00       	call   c01018bd <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 fa 0c 00 00       	call   c0100d8d <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 16 16 00 00       	call   c01016ae <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 03 0c 00 00       	call   c0100cbf <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 e1 73 10 c0 	movl   $0xc01073e1,(%esp)
c010015c:	e8 e6 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 ef 73 10 c0 	movl   $0xc01073ef,(%esp)
c010017c:	e8 c6 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 fd 73 10 c0 	movl   $0xc01073fd,(%esp)
c010019c:	e8 a6 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 0b 74 10 c0 	movl   $0xc010740b,(%esp)
c01001bc:	e8 86 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 19 74 10 c0 	movl   $0xc0107419,(%esp)
c01001dc:	e8 66 01 00 00       	call   c0100347 <cprintf>
    round ++;
c01001e1:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 aa 11 c0       	mov    %eax,0xc011aa40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile
c01001f3:	83 ec 08             	sub    $0x8,%esp
c01001f6:	cd 78                	int    $0x78
c01001f8:	89 ec                	mov    %ebp,%esp
				"int %0  \n"
				"movl %%ebp,%%esp  \n"
				:
				:"i"(T_SWITCH_TOU)
		);
}
c01001fa:	5d                   	pop    %ebp
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile
c01001ff:	cd 79                	int    $0x79
c0100201:	89 ec                	mov    %ebp,%esp
				"int %0  \n"
				"movl %%ebp,%%esp  \n"
				:
				:"i"(T_SWITCH_TOK)
		);
}
c0100203:	5d                   	pop    %ebp
c0100204:	c3                   	ret    

c0100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100205:	55                   	push   %ebp
c0100206:	89 e5                	mov    %esp,%ebp
c0100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020b:	e8 1a ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100210:	c7 04 24 28 74 10 c0 	movl   $0xc0107428,(%esp)
c0100217:	e8 2b 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_user();
c010021c:	e8 cf ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100221:	e8 04 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100226:	c7 04 24 48 74 10 c0 	movl   $0xc0107448,(%esp)
c010022d:	e8 15 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_kernel();
c0100232:	e8 c5 ff ff ff       	call   c01001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100237:	e8 ee fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100248:	74 13                	je     c010025d <readline+0x1f>
        cprintf("%s", prompt);
c010024a:	8b 45 08             	mov    0x8(%ebp),%eax
c010024d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100251:	c7 04 24 67 74 10 c0 	movl   $0xc0107467,(%esp)
c0100258:	e8 ea 00 00 00       	call   c0100347 <cprintf>
    }
    int i = 0, c;
c010025d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100264:	e8 66 01 00 00       	call   c01003cf <getchar>
c0100269:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010026c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100270:	79 07                	jns    c0100279 <readline+0x3b>
            return NULL;
c0100272:	b8 00 00 00 00       	mov    $0x0,%eax
c0100277:	eb 79                	jmp    c01002f2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100279:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027d:	7e 28                	jle    c01002a7 <readline+0x69>
c010027f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100286:	7f 1f                	jg     c01002a7 <readline+0x69>
            cputchar(c);
c0100288:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028b:	89 04 24             	mov    %eax,(%esp)
c010028e:	e8 da 00 00 00       	call   c010036d <cputchar>
            buf[i ++] = c;
c0100293:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100296:	8d 50 01             	lea    0x1(%eax),%edx
c0100299:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010029c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010029f:	88 90 60 aa 11 c0    	mov    %dl,-0x3fee55a0(%eax)
c01002a5:	eb 46                	jmp    c01002ed <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002ab:	75 17                	jne    c01002c4 <readline+0x86>
c01002ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b1:	7e 11                	jle    c01002c4 <readline+0x86>
            cputchar(c);
c01002b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b6:	89 04 24             	mov    %eax,(%esp)
c01002b9:	e8 af 00 00 00       	call   c010036d <cputchar>
            i --;
c01002be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c2:	eb 29                	jmp    c01002ed <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c8:	74 06                	je     c01002d0 <readline+0x92>
c01002ca:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002ce:	75 1d                	jne    c01002ed <readline+0xaf>
            cputchar(c);
c01002d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d3:	89 04 24             	mov    %eax,(%esp)
c01002d6:	e8 92 00 00 00       	call   c010036d <cputchar>
            buf[i] = '\0';
c01002db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002de:	05 60 aa 11 c0       	add    $0xc011aa60,%eax
c01002e3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e6:	b8 60 aa 11 c0       	mov    $0xc011aa60,%eax
c01002eb:	eb 05                	jmp    c01002f2 <readline+0xb4>
        }
    }
c01002ed:	e9 72 ff ff ff       	jmp    c0100264 <readline+0x26>
}
c01002f2:	c9                   	leave  
c01002f3:	c3                   	ret    

c01002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f4:	55                   	push   %ebp
c01002f5:	89 e5                	mov    %esp,%ebp
c01002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fd:	89 04 24             	mov    %eax,(%esp)
c0100300:	e8 fe 12 00 00       	call   c0101603 <cons_putc>
    (*cnt) ++;
c0100305:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100308:	8b 00                	mov    (%eax),%eax
c010030a:	8d 50 01             	lea    0x1(%eax),%edx
c010030d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100310:	89 10                	mov    %edx,(%eax)
}
c0100312:	c9                   	leave  
c0100313:	c3                   	ret    

c0100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100314:	55                   	push   %ebp
c0100315:	89 e5                	mov    %esp,%ebp
c0100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100321:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100328:	8b 45 08             	mov    0x8(%ebp),%eax
c010032b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100332:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100336:	c7 04 24 f4 02 10 c0 	movl   $0xc01002f4,(%esp)
c010033d:	e8 f7 66 00 00       	call   c0106a39 <vprintfmt>
    return cnt;
c0100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100345:	c9                   	leave  
c0100346:	c3                   	ret    

c0100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100347:	55                   	push   %ebp
c0100348:	89 e5                	mov    %esp,%ebp
c010034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100350:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100356:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035a:	8b 45 08             	mov    0x8(%ebp),%eax
c010035d:	89 04 24             	mov    %eax,(%esp)
c0100360:	e8 af ff ff ff       	call   c0100314 <vcprintf>
c0100365:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036b:	c9                   	leave  
c010036c:	c3                   	ret    

c010036d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036d:	55                   	push   %ebp
c010036e:	89 e5                	mov    %esp,%ebp
c0100370:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100373:	8b 45 08             	mov    0x8(%ebp),%eax
c0100376:	89 04 24             	mov    %eax,(%esp)
c0100379:	e8 85 12 00 00       	call   c0101603 <cons_putc>
}
c010037e:	c9                   	leave  
c010037f:	c3                   	ret    

c0100380 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100380:	55                   	push   %ebp
c0100381:	89 e5                	mov    %esp,%ebp
c0100383:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038d:	eb 13                	jmp    c01003a2 <cputs+0x22>
        cputch(c, &cnt);
c010038f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100393:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100396:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039a:	89 04 24             	mov    %eax,(%esp)
c010039d:	e8 52 ff ff ff       	call   c01002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a5:	8d 50 01             	lea    0x1(%eax),%edx
c01003a8:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ab:	0f b6 00             	movzbl (%eax),%eax
c01003ae:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b1:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b5:	75 d8                	jne    c010038f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003be:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c5:	e8 2a ff ff ff       	call   c01002f4 <cputch>
    return cnt;
c01003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003cd:	c9                   	leave  
c01003ce:	c3                   	ret    

c01003cf <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003cf:	55                   	push   %ebp
c01003d0:	89 e5                	mov    %esp,%ebp
c01003d2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d5:	e8 65 12 00 00       	call   c010163f <cons_getc>
c01003da:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e1:	74 f2                	je     c01003d5 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e6:	c9                   	leave  
c01003e7:	c3                   	ret    

c01003e8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e8:	55                   	push   %ebp
c01003e9:	89 e5                	mov    %esp,%ebp
c01003eb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f1:	8b 00                	mov    (%eax),%eax
c01003f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01003f9:	8b 00                	mov    (%eax),%eax
c01003fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100405:	e9 d2 00 00 00       	jmp    c01004dc <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100410:	01 d0                	add    %edx,%eax
c0100412:	89 c2                	mov    %eax,%edx
c0100414:	c1 ea 1f             	shr    $0x1f,%edx
c0100417:	01 d0                	add    %edx,%eax
c0100419:	d1 f8                	sar    %eax
c010041b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100421:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100424:	eb 04                	jmp    c010042a <stab_binsearch+0x42>
            m --;
c0100426:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100430:	7c 1f                	jl     c0100451 <stab_binsearch+0x69>
c0100432:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100435:	89 d0                	mov    %edx,%eax
c0100437:	01 c0                	add    %eax,%eax
c0100439:	01 d0                	add    %edx,%eax
c010043b:	c1 e0 02             	shl    $0x2,%eax
c010043e:	89 c2                	mov    %eax,%edx
c0100440:	8b 45 08             	mov    0x8(%ebp),%eax
c0100443:	01 d0                	add    %edx,%eax
c0100445:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100449:	0f b6 c0             	movzbl %al,%eax
c010044c:	3b 45 14             	cmp    0x14(%ebp),%eax
c010044f:	75 d5                	jne    c0100426 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100451:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100457:	7d 0b                	jge    c0100464 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010045c:	83 c0 01             	add    $0x1,%eax
c010045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100462:	eb 78                	jmp    c01004dc <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100464:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046e:	89 d0                	mov    %edx,%eax
c0100470:	01 c0                	add    %eax,%eax
c0100472:	01 d0                	add    %edx,%eax
c0100474:	c1 e0 02             	shl    $0x2,%eax
c0100477:	89 c2                	mov    %eax,%edx
c0100479:	8b 45 08             	mov    0x8(%ebp),%eax
c010047c:	01 d0                	add    %edx,%eax
c010047e:	8b 40 08             	mov    0x8(%eax),%eax
c0100481:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100484:	73 13                	jae    c0100499 <stab_binsearch+0xb1>
            *region_left = m;
c0100486:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100491:	83 c0 01             	add    $0x1,%eax
c0100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100497:	eb 43                	jmp    c01004dc <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049c:	89 d0                	mov    %edx,%eax
c010049e:	01 c0                	add    %eax,%eax
c01004a0:	01 d0                	add    %edx,%eax
c01004a2:	c1 e0 02             	shl    $0x2,%eax
c01004a5:	89 c2                	mov    %eax,%edx
c01004a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01004aa:	01 d0                	add    %edx,%eax
c01004ac:	8b 40 08             	mov    0x8(%eax),%eax
c01004af:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b2:	76 16                	jbe    c01004ca <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01004bd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c2:	83 e8 01             	sub    $0x1,%eax
c01004c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c8:	eb 12                	jmp    c01004dc <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d0:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e2:	0f 8e 22 ff ff ff    	jle    c010040a <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004ec:	75 0f                	jne    c01004fd <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f1:	8b 00                	mov    (%eax),%eax
c01004f3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f9:	89 10                	mov    %edx,(%eax)
c01004fb:	eb 3f                	jmp    c010053c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100500:	8b 00                	mov    (%eax),%eax
c0100502:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100505:	eb 04                	jmp    c010050b <stab_binsearch+0x123>
c0100507:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050e:	8b 00                	mov    (%eax),%eax
c0100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100513:	7d 1f                	jge    c0100534 <stab_binsearch+0x14c>
c0100515:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100518:	89 d0                	mov    %edx,%eax
c010051a:	01 c0                	add    %eax,%eax
c010051c:	01 d0                	add    %edx,%eax
c010051e:	c1 e0 02             	shl    $0x2,%eax
c0100521:	89 c2                	mov    %eax,%edx
c0100523:	8b 45 08             	mov    0x8(%ebp),%eax
c0100526:	01 d0                	add    %edx,%eax
c0100528:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052c:	0f b6 c0             	movzbl %al,%eax
c010052f:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100532:	75 d3                	jne    c0100507 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100534:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100537:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053a:	89 10                	mov    %edx,(%eax)
    }
}
c010053c:	c9                   	leave  
c010053d:	c3                   	ret    

c010053e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053e:	55                   	push   %ebp
c010053f:	89 e5                	mov    %esp,%ebp
c0100541:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	c7 00 6c 74 10 c0    	movl   $0xc010746c,(%eax)
    info->eip_line = 0;
c010054d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100557:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055a:	c7 40 08 6c 74 10 c0 	movl   $0xc010746c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100561:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100564:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056e:	8b 55 08             	mov    0x8(%ebp),%edx
c0100571:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100577:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057e:	c7 45 f4 c0 89 10 c0 	movl   $0xc01089c0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100585:	c7 45 f0 9c 4f 11 c0 	movl   $0xc0114f9c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058c:	c7 45 ec 9d 4f 11 c0 	movl   $0xc0114f9d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100593:	c7 45 e8 cf 7c 11 c0 	movl   $0xc0117ccf,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a0:	76 0d                	jbe    c01005af <debuginfo_eip+0x71>
c01005a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a5:	83 e8 01             	sub    $0x1,%eax
c01005a8:	0f b6 00             	movzbl (%eax),%eax
c01005ab:	84 c0                	test   %al,%al
c01005ad:	74 0a                	je     c01005b9 <debuginfo_eip+0x7b>
        return -1;
c01005af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b4:	e9 c0 02 00 00       	jmp    c0100879 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c6:	29 c2                	sub    %eax,%edx
c01005c8:	89 d0                	mov    %edx,%eax
c01005ca:	c1 f8 02             	sar    $0x2,%eax
c01005cd:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d3:	83 e8 01             	sub    $0x1,%eax
c01005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dc:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e7:	00 
c01005e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005eb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005f9:	89 04 24             	mov    %eax,(%esp)
c01005fc:	e8 e7 fd ff ff       	call   c01003e8 <stab_binsearch>
    if (lfile == 0)
c0100601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100604:	85 c0                	test   %eax,%eax
c0100606:	75 0a                	jne    c0100612 <debuginfo_eip+0xd4>
        return -1;
c0100608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060d:	e9 67 02 00 00       	jmp    c0100879 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100615:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100618:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100621:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100625:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010062c:	00 
c010062d:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100630:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100634:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100637:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063e:	89 04 24             	mov    %eax,(%esp)
c0100641:	e8 a2 fd ff ff       	call   c01003e8 <stab_binsearch>

    if (lfun <= rfun) {
c0100646:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100649:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010064c:	39 c2                	cmp    %eax,%edx
c010064e:	7f 7c                	jg     c01006cc <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	89 d0                	mov    %edx,%eax
c0100657:	01 c0                	add    %eax,%eax
c0100659:	01 d0                	add    %edx,%eax
c010065b:	c1 e0 02             	shl    $0x2,%eax
c010065e:	89 c2                	mov    %eax,%edx
c0100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100663:	01 d0                	add    %edx,%eax
c0100665:	8b 10                	mov    (%eax),%edx
c0100667:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066d:	29 c1                	sub    %eax,%ecx
c010066f:	89 c8                	mov    %ecx,%eax
c0100671:	39 c2                	cmp    %eax,%edx
c0100673:	73 22                	jae    c0100697 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100675:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	89 d0                	mov    %edx,%eax
c010067c:	01 c0                	add    %eax,%eax
c010067e:	01 d0                	add    %edx,%eax
c0100680:	c1 e0 02             	shl    $0x2,%eax
c0100683:	89 c2                	mov    %eax,%edx
c0100685:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100688:	01 d0                	add    %edx,%eax
c010068a:	8b 10                	mov    (%eax),%edx
c010068c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010068f:	01 c2                	add    %eax,%edx
c0100691:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100694:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100697:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	89 d0                	mov    %edx,%eax
c010069e:	01 c0                	add    %eax,%eax
c01006a0:	01 d0                	add    %edx,%eax
c01006a2:	c1 e0 02             	shl    $0x2,%eax
c01006a5:	89 c2                	mov    %eax,%edx
c01006a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006aa:	01 d0                	add    %edx,%eax
c01006ac:	8b 50 08             	mov    0x8(%eax),%edx
c01006af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b2:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b8:	8b 40 10             	mov    0x10(%eax),%eax
c01006bb:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ca:	eb 15                	jmp    c01006e1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006cf:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006de:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e4:	8b 40 08             	mov    0x8(%eax),%eax
c01006e7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ee:	00 
c01006ef:	89 04 24             	mov    %eax,(%esp)
c01006f2:	e8 9d 69 00 00       	call   c0107094 <strfind>
c01006f7:	89 c2                	mov    %eax,%edx
c01006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fc:	8b 40 08             	mov    0x8(%eax),%eax
c01006ff:	29 c2                	sub    %eax,%edx
c0100701:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100704:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100707:	8b 45 08             	mov    0x8(%ebp),%eax
c010070a:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070e:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100715:	00 
c0100716:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100719:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100720:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100727:	89 04 24             	mov    %eax,(%esp)
c010072a:	e8 b9 fc ff ff       	call   c01003e8 <stab_binsearch>
    if (lline <= rline) {
c010072f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100732:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100735:	39 c2                	cmp    %eax,%edx
c0100737:	7f 24                	jg     c010075d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	89 d0                	mov    %edx,%eax
c0100740:	01 c0                	add    %eax,%eax
c0100742:	01 d0                	add    %edx,%eax
c0100744:	c1 e0 02             	shl    $0x2,%eax
c0100747:	89 c2                	mov    %eax,%edx
c0100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074c:	01 d0                	add    %edx,%eax
c010074e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100752:	0f b7 d0             	movzwl %ax,%edx
c0100755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100758:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075b:	eb 13                	jmp    c0100770 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100762:	e9 12 01 00 00       	jmp    c0100879 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076a:	83 e8 01             	sub    $0x1,%eax
c010076d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100770:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100776:	39 c2                	cmp    %eax,%edx
c0100778:	7c 56                	jl     c01007d0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	89 d0                	mov    %edx,%eax
c0100781:	01 c0                	add    %eax,%eax
c0100783:	01 d0                	add    %edx,%eax
c0100785:	c1 e0 02             	shl    $0x2,%eax
c0100788:	89 c2                	mov    %eax,%edx
c010078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078d:	01 d0                	add    %edx,%eax
c010078f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100793:	3c 84                	cmp    $0x84,%al
c0100795:	74 39                	je     c01007d0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100797:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	89 d0                	mov    %edx,%eax
c010079e:	01 c0                	add    %eax,%eax
c01007a0:	01 d0                	add    %edx,%eax
c01007a2:	c1 e0 02             	shl    $0x2,%eax
c01007a5:	89 c2                	mov    %eax,%edx
c01007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007aa:	01 d0                	add    %edx,%eax
c01007ac:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b0:	3c 64                	cmp    $0x64,%al
c01007b2:	75 b3                	jne    c0100767 <debuginfo_eip+0x229>
c01007b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	89 d0                	mov    %edx,%eax
c01007bb:	01 c0                	add    %eax,%eax
c01007bd:	01 d0                	add    %edx,%eax
c01007bf:	c1 e0 02             	shl    $0x2,%eax
c01007c2:	89 c2                	mov    %eax,%edx
c01007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c7:	01 d0                	add    %edx,%eax
c01007c9:	8b 40 08             	mov    0x8(%eax),%eax
c01007cc:	85 c0                	test   %eax,%eax
c01007ce:	74 97                	je     c0100767 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d6:	39 c2                	cmp    %eax,%edx
c01007d8:	7c 46                	jl     c0100820 <debuginfo_eip+0x2e2>
c01007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	89 d0                	mov    %edx,%eax
c01007e1:	01 c0                	add    %eax,%eax
c01007e3:	01 d0                	add    %edx,%eax
c01007e5:	c1 e0 02             	shl    $0x2,%eax
c01007e8:	89 c2                	mov    %eax,%edx
c01007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ed:	01 d0                	add    %edx,%eax
c01007ef:	8b 10                	mov    (%eax),%edx
c01007f1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f7:	29 c1                	sub    %eax,%ecx
c01007f9:	89 c8                	mov    %ecx,%eax
c01007fb:	39 c2                	cmp    %eax,%edx
c01007fd:	73 21                	jae    c0100820 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	89 d0                	mov    %edx,%eax
c0100806:	01 c0                	add    %eax,%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	c1 e0 02             	shl    $0x2,%eax
c010080d:	89 c2                	mov    %eax,%edx
c010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100812:	01 d0                	add    %edx,%eax
c0100814:	8b 10                	mov    (%eax),%edx
c0100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100819:	01 c2                	add    %eax,%edx
c010081b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100826:	39 c2                	cmp    %eax,%edx
c0100828:	7d 4a                	jge    c0100874 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082d:	83 c0 01             	add    $0x1,%eax
c0100830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100833:	eb 18                	jmp    c010084d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100835:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100838:	8b 40 14             	mov    0x14(%eax),%eax
c010083b:	8d 50 01             	lea    0x1(%eax),%edx
c010083e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100841:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100847:	83 c0 01             	add    $0x1,%eax
c010084a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100850:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100853:	39 c2                	cmp    %eax,%edx
c0100855:	7d 1d                	jge    c0100874 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	89 d0                	mov    %edx,%eax
c010085e:	01 c0                	add    %eax,%eax
c0100860:	01 d0                	add    %edx,%eax
c0100862:	c1 e0 02             	shl    $0x2,%eax
c0100865:	89 c2                	mov    %eax,%edx
c0100867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086a:	01 d0                	add    %edx,%eax
c010086c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100870:	3c a0                	cmp    $0xa0,%al
c0100872:	74 c1                	je     c0100835 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100874:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100879:	c9                   	leave  
c010087a:	c3                   	ret    

c010087b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087b:	55                   	push   %ebp
c010087c:	89 e5                	mov    %esp,%ebp
c010087e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100881:	c7 04 24 76 74 10 c0 	movl   $0xc0107476,(%esp)
c0100888:	e8 ba fa ff ff       	call   c0100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088d:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100894:	c0 
c0100895:	c7 04 24 8f 74 10 c0 	movl   $0xc010748f,(%esp)
c010089c:	e8 a6 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a1:	c7 44 24 04 a9 73 10 	movl   $0xc01073a9,0x4(%esp)
c01008a8:	c0 
c01008a9:	c7 04 24 a7 74 10 c0 	movl   $0xc01074a7,(%esp)
c01008b0:	e8 92 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b5:	c7 44 24 04 36 aa 11 	movl   $0xc011aa36,0x4(%esp)
c01008bc:	c0 
c01008bd:	c7 04 24 bf 74 10 c0 	movl   $0xc01074bf,(%esp)
c01008c4:	e8 7e fa ff ff       	call   c0100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c9:	c7 44 24 04 48 ba 11 	movl   $0xc011ba48,0x4(%esp)
c01008d0:	c0 
c01008d1:	c7 04 24 d7 74 10 c0 	movl   $0xc01074d7,(%esp)
c01008d8:	e8 6a fa ff ff       	call   c0100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008dd:	b8 48 ba 11 c0       	mov    $0xc011ba48,%eax
c01008e2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e8:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008ed:	29 c2                	sub    %eax,%edx
c01008ef:	89 d0                	mov    %edx,%eax
c01008f1:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f7:	85 c0                	test   %eax,%eax
c01008f9:	0f 48 c2             	cmovs  %edx,%eax
c01008fc:	c1 f8 0a             	sar    $0xa,%eax
c01008ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100903:	c7 04 24 f0 74 10 c0 	movl   $0xc01074f0,(%esp)
c010090a:	e8 38 fa ff ff       	call   c0100347 <cprintf>
}
c010090f:	c9                   	leave  
c0100910:	c3                   	ret    

c0100911 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100911:	55                   	push   %ebp
c0100912:	89 e5                	mov    %esp,%ebp
c0100914:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010091d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100921:	8b 45 08             	mov    0x8(%ebp),%eax
c0100924:	89 04 24             	mov    %eax,(%esp)
c0100927:	e8 12 fc ff ff       	call   c010053e <debuginfo_eip>
c010092c:	85 c0                	test   %eax,%eax
c010092e:	74 15                	je     c0100945 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100930:	8b 45 08             	mov    0x8(%ebp),%eax
c0100933:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100937:	c7 04 24 1a 75 10 c0 	movl   $0xc010751a,(%esp)
c010093e:	e8 04 fa ff ff       	call   c0100347 <cprintf>
c0100943:	eb 6d                	jmp    c01009b2 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094c:	eb 1c                	jmp    c010096a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010094e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100951:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100954:	01 d0                	add    %edx,%eax
c0100956:	0f b6 00             	movzbl (%eax),%eax
c0100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010095f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100962:	01 ca                	add    %ecx,%edx
c0100964:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100966:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100970:	7f dc                	jg     c010094e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100972:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100978:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097b:	01 d0                	add    %edx,%eax
c010097d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100980:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100983:	8b 55 08             	mov    0x8(%ebp),%edx
c0100986:	89 d1                	mov    %edx,%ecx
c0100988:	29 c1                	sub    %eax,%ecx
c010098a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100990:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100994:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099e:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a6:	c7 04 24 36 75 10 c0 	movl   $0xc0107536,(%esp)
c01009ad:	e8 95 f9 ff ff       	call   c0100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b2:	c9                   	leave  
c01009b3:	c3                   	ret    

c01009b4 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b4:	55                   	push   %ebp
c01009b5:	89 e5                	mov    %esp,%ebp
c01009b7:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009ba:	8b 45 04             	mov    0x4(%ebp),%eax
c01009bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c3:	c9                   	leave  
c01009c4:	c3                   	ret    

c01009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c5:	55                   	push   %ebp
c01009c6:	89 e5                	mov    %esp,%ebp
c01009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cb:	89 e8                	mov    %ebp,%eax
c01009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
		uint32_t ebp=read_ebp();
c01009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t eip=read_eip();
c01009d6:	e8 d9 ff ff ff       	call   c01009b4 <read_eip>
c01009db:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int i;
		for(i=0;ebp!=0&&i<STACKFRAME_DEPTH;i++)
c01009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e5:	e9 88 00 00 00       	jmp    c0100a72 <print_stackframe+0xad>
		{
			cprintf("ebp:0x%08x,eip:0x%08x,args:",ebp,eip);
c01009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f8:	c7 04 24 48 75 10 c0 	movl   $0xc0107548,(%esp)
c01009ff:	e8 43 f9 ff ff       	call   c0100347 <cprintf>
			uint32_t *arg=(uint32_t*)ebp+2;
c0100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a07:	83 c0 08             	add    $0x8,%eax
c0100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			int j;
			for(j=0;j<4;j++)
c0100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a14:	eb 25                	jmp    c0100a3b <print_stackframe+0x76>
			{
				cprintf("0x%08x ",arg[j]);
c0100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a23:	01 d0                	add    %edx,%eax
c0100a25:	8b 00                	mov    (%eax),%eax
c0100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2b:	c7 04 24 64 75 10 c0 	movl   $0xc0107564,(%esp)
c0100a32:	e8 10 f9 ff ff       	call   c0100347 <cprintf>
		for(i=0;ebp!=0&&i<STACKFRAME_DEPTH;i++)
		{
			cprintf("ebp:0x%08x,eip:0x%08x,args:",ebp,eip);
			uint32_t *arg=(uint32_t*)ebp+2;
			int j;
			for(j=0;j<4;j++)
c0100a37:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3f:	7e d5                	jle    c0100a16 <print_stackframe+0x51>
			{
				cprintf("0x%08x ",arg[j]);
			}
			cprintf("\n");
c0100a41:	c7 04 24 6c 75 10 c0 	movl   $0xc010756c,(%esp)
c0100a48:	e8 fa f8 ff ff       	call   c0100347 <cprintf>
			print_debuginfo(eip-1);
c0100a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a50:	83 e8 01             	sub    $0x1,%eax
c0100a53:	89 04 24             	mov    %eax,(%esp)
c0100a56:	e8 b6 fe ff ff       	call   c0100911 <print_debuginfo>
			eip=*((uint32_t*)ebp+1);
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	83 c0 04             	add    $0x4,%eax
c0100a61:	8b 00                	mov    (%eax),%eax
c0100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
			ebp=*((uint32_t*)ebp);
c0100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a69:	8b 00                	mov    (%eax),%eax
c0100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
		uint32_t ebp=read_ebp();
		uint32_t eip=read_eip();
		int i;
		for(i=0;ebp!=0&&i<STACKFRAME_DEPTH;i++)
c0100a6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a76:	74 0a                	je     c0100a82 <print_stackframe+0xbd>
c0100a78:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7c:	0f 8e 68 ff ff ff    	jle    c01009ea <print_stackframe+0x25>
			cprintf("\n");
			print_debuginfo(eip-1);
			eip=*((uint32_t*)ebp+1);
			ebp=*((uint32_t*)ebp);
		}
}
c0100a82:	c9                   	leave  
c0100a83:	c3                   	ret    

c0100a84 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a84:	55                   	push   %ebp
c0100a85:	89 e5                	mov    %esp,%ebp
c0100a87:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a91:	eb 0c                	jmp    c0100a9f <parse+0x1b>
            *buf ++ = '\0';
c0100a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a96:	8d 50 01             	lea    0x1(%eax),%edx
c0100a99:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa2:	0f b6 00             	movzbl (%eax),%eax
c0100aa5:	84 c0                	test   %al,%al
c0100aa7:	74 1d                	je     c0100ac6 <parse+0x42>
c0100aa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aac:	0f b6 00             	movzbl (%eax),%eax
c0100aaf:	0f be c0             	movsbl %al,%eax
c0100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab6:	c7 04 24 f0 75 10 c0 	movl   $0xc01075f0,(%esp)
c0100abd:	e8 9f 65 00 00       	call   c0107061 <strchr>
c0100ac2:	85 c0                	test   %eax,%eax
c0100ac4:	75 cd                	jne    c0100a93 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac9:	0f b6 00             	movzbl (%eax),%eax
c0100acc:	84 c0                	test   %al,%al
c0100ace:	75 02                	jne    c0100ad2 <parse+0x4e>
            break;
c0100ad0:	eb 67                	jmp    c0100b39 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad6:	75 14                	jne    c0100aec <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100adf:	00 
c0100ae0:	c7 04 24 f5 75 10 c0 	movl   $0xc01075f5,(%esp)
c0100ae7:	e8 5b f8 ff ff       	call   c0100347 <cprintf>
        }
        argv[argc ++] = buf;
c0100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aef:	8d 50 01             	lea    0x1(%eax),%edx
c0100af2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100aff:	01 c2                	add    %eax,%edx
c0100b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b04:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b06:	eb 04                	jmp    c0100b0c <parse+0x88>
            buf ++;
c0100b08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0f:	0f b6 00             	movzbl (%eax),%eax
c0100b12:	84 c0                	test   %al,%al
c0100b14:	74 1d                	je     c0100b33 <parse+0xaf>
c0100b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b19:	0f b6 00             	movzbl (%eax),%eax
c0100b1c:	0f be c0             	movsbl %al,%eax
c0100b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b23:	c7 04 24 f0 75 10 c0 	movl   $0xc01075f0,(%esp)
c0100b2a:	e8 32 65 00 00       	call   c0107061 <strchr>
c0100b2f:	85 c0                	test   %eax,%eax
c0100b31:	74 d5                	je     c0100b08 <parse+0x84>
            buf ++;
        }
    }
c0100b33:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b34:	e9 66 ff ff ff       	jmp    c0100a9f <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3c:	c9                   	leave  
c0100b3d:	c3                   	ret    

c0100b3e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3e:	55                   	push   %ebp
c0100b3f:	89 e5                	mov    %esp,%ebp
c0100b41:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b44:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4e:	89 04 24             	mov    %eax,(%esp)
c0100b51:	e8 2e ff ff ff       	call   c0100a84 <parse>
c0100b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5d:	75 0a                	jne    c0100b69 <runcmd+0x2b>
        return 0;
c0100b5f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b64:	e9 85 00 00 00       	jmp    c0100bee <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b70:	eb 5c                	jmp    c0100bce <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b72:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b78:	89 d0                	mov    %edx,%eax
c0100b7a:	01 c0                	add    %eax,%eax
c0100b7c:	01 d0                	add    %edx,%eax
c0100b7e:	c1 e0 02             	shl    $0x2,%eax
c0100b81:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100b86:	8b 00                	mov    (%eax),%eax
c0100b88:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8c:	89 04 24             	mov    %eax,(%esp)
c0100b8f:	e8 2e 64 00 00       	call   c0106fc2 <strcmp>
c0100b94:	85 c0                	test   %eax,%eax
c0100b96:	75 32                	jne    c0100bca <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9b:	89 d0                	mov    %edx,%eax
c0100b9d:	01 c0                	add    %eax,%eax
c0100b9f:	01 d0                	add    %edx,%eax
c0100ba1:	c1 e0 02             	shl    $0x2,%eax
c0100ba4:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100ba9:	8b 40 08             	mov    0x8(%eax),%eax
c0100bac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100baf:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb9:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bbc:	83 c2 04             	add    $0x4,%edx
c0100bbf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc3:	89 0c 24             	mov    %ecx,(%esp)
c0100bc6:	ff d0                	call   *%eax
c0100bc8:	eb 24                	jmp    c0100bee <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd1:	83 f8 02             	cmp    $0x2,%eax
c0100bd4:	76 9c                	jbe    c0100b72 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdd:	c7 04 24 13 76 10 c0 	movl   $0xc0107613,(%esp)
c0100be4:	e8 5e f7 ff ff       	call   c0100347 <cprintf>
    return 0;
c0100be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bee:	c9                   	leave  
c0100bef:	c3                   	ret    

c0100bf0 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf0:	55                   	push   %ebp
c0100bf1:	89 e5                	mov    %esp,%ebp
c0100bf3:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf6:	c7 04 24 2c 76 10 c0 	movl   $0xc010762c,(%esp)
c0100bfd:	e8 45 f7 ff ff       	call   c0100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c02:	c7 04 24 54 76 10 c0 	movl   $0xc0107654,(%esp)
c0100c09:	e8 39 f7 ff ff       	call   c0100347 <cprintf>

    if (tf != NULL) {
c0100c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c12:	74 0b                	je     c0100c1f <kmonitor+0x2f>
        print_trapframe(tf);
c0100c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c17:	89 04 24             	mov    %eax,(%esp)
c0100c1a:	e8 55 0e 00 00       	call   c0101a74 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1f:	c7 04 24 79 76 10 c0 	movl   $0xc0107679,(%esp)
c0100c26:	e8 13 f6 ff ff       	call   c010023e <readline>
c0100c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c32:	74 18                	je     c0100c4c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3e:	89 04 24             	mov    %eax,(%esp)
c0100c41:	e8 f8 fe ff ff       	call   c0100b3e <runcmd>
c0100c46:	85 c0                	test   %eax,%eax
c0100c48:	79 02                	jns    c0100c4c <kmonitor+0x5c>
                break;
c0100c4a:	eb 02                	jmp    c0100c4e <kmonitor+0x5e>
            }
        }
    }
c0100c4c:	eb d1                	jmp    c0100c1f <kmonitor+0x2f>
}
c0100c4e:	c9                   	leave  
c0100c4f:	c3                   	ret    

c0100c50 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c50:	55                   	push   %ebp
c0100c51:	89 e5                	mov    %esp,%ebp
c0100c53:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c5d:	eb 3f                	jmp    c0100c9e <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c62:	89 d0                	mov    %edx,%eax
c0100c64:	01 c0                	add    %eax,%eax
c0100c66:	01 d0                	add    %edx,%eax
c0100c68:	c1 e0 02             	shl    $0x2,%eax
c0100c6b:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100c70:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c76:	89 d0                	mov    %edx,%eax
c0100c78:	01 c0                	add    %eax,%eax
c0100c7a:	01 d0                	add    %edx,%eax
c0100c7c:	c1 e0 02             	shl    $0x2,%eax
c0100c7f:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100c84:	8b 00                	mov    (%eax),%eax
c0100c86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8e:	c7 04 24 7d 76 10 c0 	movl   $0xc010767d,(%esp)
c0100c95:	e8 ad f6 ff ff       	call   c0100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca1:	83 f8 02             	cmp    $0x2,%eax
c0100ca4:	76 b9                	jbe    c0100c5f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cab:	c9                   	leave  
c0100cac:	c3                   	ret    

c0100cad <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cad:	55                   	push   %ebp
c0100cae:	89 e5                	mov    %esp,%ebp
c0100cb0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb3:	e8 c3 fb ff ff       	call   c010087b <print_kerninfo>
    return 0;
c0100cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbd:	c9                   	leave  
c0100cbe:	c3                   	ret    

c0100cbf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbf:	55                   	push   %ebp
c0100cc0:	89 e5                	mov    %esp,%ebp
c0100cc2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc5:	e8 fb fc ff ff       	call   c01009c5 <print_stackframe>
    return 0;
c0100cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccf:	c9                   	leave  
c0100cd0:	c3                   	ret    

c0100cd1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd1:	55                   	push   %ebp
c0100cd2:	89 e5                	mov    %esp,%ebp
c0100cd4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd7:	a1 60 ae 11 c0       	mov    0xc011ae60,%eax
c0100cdc:	85 c0                	test   %eax,%eax
c0100cde:	74 02                	je     c0100ce2 <__panic+0x11>
        goto panic_dead;
c0100ce0:	eb 48                	jmp    c0100d2a <__panic+0x59>
    }
    is_panic = 1;
c0100ce2:	c7 05 60 ae 11 c0 01 	movl   $0x1,0xc011ae60
c0100ce9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cec:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d00:	c7 04 24 86 76 10 c0 	movl   $0xc0107686,(%esp)
c0100d07:	e8 3b f6 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d13:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d16:	89 04 24             	mov    %eax,(%esp)
c0100d19:	e8 f6 f5 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100d1e:	c7 04 24 a2 76 10 c0 	movl   $0xc01076a2,(%esp)
c0100d25:	e8 1d f6 ff ff       	call   c0100347 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d2a:	e8 85 09 00 00       	call   c01016b4 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d36:	e8 b5 fe ff ff       	call   c0100bf0 <kmonitor>
    }
c0100d3b:	eb f2                	jmp    c0100d2f <__panic+0x5e>

c0100d3d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d3d:	55                   	push   %ebp
c0100d3e:	89 e5                	mov    %esp,%ebp
c0100d40:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d43:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d4c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d50:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d57:	c7 04 24 a4 76 10 c0 	movl   $0xc01076a4,(%esp)
c0100d5e:	e8 e4 f5 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d6d:	89 04 24             	mov    %eax,(%esp)
c0100d70:	e8 9f f5 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100d75:	c7 04 24 a2 76 10 c0 	movl   $0xc01076a2,(%esp)
c0100d7c:	e8 c6 f5 ff ff       	call   c0100347 <cprintf>
    va_end(ap);
}
c0100d81:	c9                   	leave  
c0100d82:	c3                   	ret    

c0100d83 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d83:	55                   	push   %ebp
c0100d84:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d86:	a1 60 ae 11 c0       	mov    0xc011ae60,%eax
}
c0100d8b:	5d                   	pop    %ebp
c0100d8c:	c3                   	ret    

c0100d8d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d8d:	55                   	push   %ebp
c0100d8e:	89 e5                	mov    %esp,%ebp
c0100d90:	83 ec 28             	sub    $0x28,%esp
c0100d93:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d99:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d9d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da5:	ee                   	out    %al,(%dx)
c0100da6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dac:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db8:	ee                   	out    %al,(%dx)
c0100db9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dbf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dcb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dcc:	c7 05 2c ba 11 c0 00 	movl   $0x0,0xc011ba2c
c0100dd3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd6:	c7 04 24 c2 76 10 c0 	movl   $0xc01076c2,(%esp)
c0100ddd:	e8 65 f5 ff ff       	call   c0100347 <cprintf>
    pic_enable(IRQ_TIMER);
c0100de2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de9:	e8 24 09 00 00       	call   c0101712 <pic_enable>
}
c0100dee:	c9                   	leave  
c0100def:	c3                   	ret    

c0100df0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df0:	55                   	push   %ebp
c0100df1:	89 e5                	mov    %esp,%ebp
c0100df3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df6:	9c                   	pushf  
c0100df7:	58                   	pop    %eax
c0100df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfe:	25 00 02 00 00       	and    $0x200,%eax
c0100e03:	85 c0                	test   %eax,%eax
c0100e05:	74 0c                	je     c0100e13 <__intr_save+0x23>
        intr_disable();
c0100e07:	e8 a8 08 00 00       	call   c01016b4 <intr_disable>
        return 1;
c0100e0c:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e11:	eb 05                	jmp    c0100e18 <__intr_save+0x28>
    }
    return 0;
c0100e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e18:	c9                   	leave  
c0100e19:	c3                   	ret    

c0100e1a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e1a:	55                   	push   %ebp
c0100e1b:	89 e5                	mov    %esp,%ebp
c0100e1d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e24:	74 05                	je     c0100e2b <__intr_restore+0x11>
        intr_enable();
c0100e26:	e8 83 08 00 00       	call   c01016ae <intr_enable>
    }
}
c0100e2b:	c9                   	leave  
c0100e2c:	c3                   	ret    

c0100e2d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e2d:	55                   	push   %ebp
c0100e2e:	89 e5                	mov    %esp,%ebp
c0100e30:	83 ec 10             	sub    $0x10,%esp
c0100e33:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e39:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e3d:	89 c2                	mov    %eax,%edx
c0100e3f:	ec                   	in     (%dx),%al
c0100e40:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e43:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e49:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e4d:	89 c2                	mov    %eax,%edx
c0100e4f:	ec                   	in     (%dx),%al
c0100e50:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e53:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e59:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e5d:	89 c2                	mov    %eax,%edx
c0100e5f:	ec                   	in     (%dx),%al
c0100e60:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e63:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e69:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e6d:	89 c2                	mov    %eax,%edx
c0100e6f:	ec                   	in     (%dx),%al
c0100e70:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e73:	c9                   	leave  
c0100e74:	c3                   	ret    

c0100e75 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e75:	55                   	push   %ebp
c0100e76:	89 e5                	mov    %esp,%ebp
c0100e78:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e7b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e85:	0f b7 00             	movzwl (%eax),%eax
c0100e88:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 00             	movzwl (%eax),%eax
c0100e9a:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9e:	74 12                	je     c0100eb2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea7:	66 c7 05 86 ae 11 c0 	movw   $0x3b4,0xc011ae86
c0100eae:	b4 03 
c0100eb0:	eb 13                	jmp    c0100ec5 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ebc:	66 c7 05 86 ae 11 c0 	movw   $0x3d4,0xc011ae86
c0100ec3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec5:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100ecc:	0f b7 c0             	movzwl %ax,%eax
c0100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100edb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100edf:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee0:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100ee7:	83 c0 01             	add    $0x1,%eax
c0100eea:	0f b7 c0             	movzwl %ax,%eax
c0100eed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef5:	89 c2                	mov    %eax,%edx
c0100ef7:	ec                   	in     (%dx),%al
c0100ef8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100efb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100eff:	0f b6 c0             	movzbl %al,%eax
c0100f02:	c1 e0 08             	shl    $0x8,%eax
c0100f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f08:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100f0f:	0f b7 c0             	movzwl %ax,%eax
c0100f12:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f16:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f1a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f22:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f23:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100f2a:	83 c0 01             	add    $0x1,%eax
c0100f2d:	0f b7 c0             	movzwl %ax,%eax
c0100f30:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f34:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f38:	89 c2                	mov    %eax,%edx
c0100f3a:	ec                   	in     (%dx),%al
c0100f3b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f3e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f42:	0f b6 c0             	movzbl %al,%eax
c0100f45:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f4b:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    crt_pos = pos;
c0100f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f53:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
}
c0100f59:	c9                   	leave  
c0100f5a:	c3                   	ret    

c0100f5b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f5b:	55                   	push   %ebp
c0100f5c:	89 e5                	mov    %esp,%ebp
c0100f5e:	83 ec 48             	sub    $0x48,%esp
c0100f61:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f67:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f6b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f73:	ee                   	out    %al,(%dx)
c0100f74:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f7a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f7e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f82:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f86:	ee                   	out    %al,(%dx)
c0100f87:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f8d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f99:	ee                   	out    %al,(%dx)
c0100f9a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fac:	ee                   	out    %al,(%dx)
c0100fad:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fbb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbf:	ee                   	out    %al,(%dx)
c0100fc0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fca:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fce:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd2:	ee                   	out    %al,(%dx)
c0100fd3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fdd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe5:	ee                   	out    %al,(%dx)
c0100fe6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fec:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff0:	89 c2                	mov    %eax,%edx
c0100ff2:	ec                   	in     (%dx),%al
c0100ff3:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ffa:	3c ff                	cmp    $0xff,%al
c0100ffc:	0f 95 c0             	setne  %al
c0100fff:	0f b6 c0             	movzbl %al,%eax
c0101002:	a3 88 ae 11 c0       	mov    %eax,0xc011ae88
c0101007:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101011:	89 c2                	mov    %eax,%edx
c0101013:	ec                   	in     (%dx),%al
c0101014:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101017:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010101d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101021:	89 c2                	mov    %eax,%edx
c0101023:	ec                   	in     (%dx),%al
c0101024:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101027:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c010102c:	85 c0                	test   %eax,%eax
c010102e:	74 0c                	je     c010103c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101030:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101037:	e8 d6 06 00 00       	call   c0101712 <pic_enable>
    }
}
c010103c:	c9                   	leave  
c010103d:	c3                   	ret    

c010103e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103e:	55                   	push   %ebp
c010103f:	89 e5                	mov    %esp,%ebp
c0101041:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010104b:	eb 09                	jmp    c0101056 <lpt_putc_sub+0x18>
        delay();
c010104d:	e8 db fd ff ff       	call   c0100e2d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101052:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101056:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010105c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101060:	89 c2                	mov    %eax,%edx
c0101062:	ec                   	in     (%dx),%al
c0101063:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101066:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010106a:	84 c0                	test   %al,%al
c010106c:	78 09                	js     c0101077 <lpt_putc_sub+0x39>
c010106e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101075:	7e d6                	jle    c010104d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101077:	8b 45 08             	mov    0x8(%ebp),%eax
c010107a:	0f b6 c0             	movzbl %al,%eax
c010107d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101083:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101086:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010108a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010108e:	ee                   	out    %al,(%dx)
c010108f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101095:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101099:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010109d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a1:	ee                   	out    %al,(%dx)
c01010a2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b5:	c9                   	leave  
c01010b6:	c3                   	ret    

c01010b7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b7:	55                   	push   %ebp
c01010b8:	89 e5                	mov    %esp,%ebp
c01010ba:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010bd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c1:	74 0d                	je     c01010d0 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c6:	89 04 24             	mov    %eax,(%esp)
c01010c9:	e8 70 ff ff ff       	call   c010103e <lpt_putc_sub>
c01010ce:	eb 24                	jmp    c01010f4 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d7:	e8 62 ff ff ff       	call   c010103e <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010dc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e3:	e8 56 ff ff ff       	call   c010103e <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ef:	e8 4a ff ff ff       	call   c010103e <lpt_putc_sub>
    }
}
c01010f4:	c9                   	leave  
c01010f5:	c3                   	ret    

c01010f6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f6:	55                   	push   %ebp
c01010f7:	89 e5                	mov    %esp,%ebp
c01010f9:	53                   	push   %ebx
c01010fa:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101100:	b0 00                	mov    $0x0,%al
c0101102:	85 c0                	test   %eax,%eax
c0101104:	75 07                	jne    c010110d <cga_putc+0x17>
        c |= 0x0700;
c0101106:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010110d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101110:	0f b6 c0             	movzbl %al,%eax
c0101113:	83 f8 0a             	cmp    $0xa,%eax
c0101116:	74 4c                	je     c0101164 <cga_putc+0x6e>
c0101118:	83 f8 0d             	cmp    $0xd,%eax
c010111b:	74 57                	je     c0101174 <cga_putc+0x7e>
c010111d:	83 f8 08             	cmp    $0x8,%eax
c0101120:	0f 85 88 00 00 00    	jne    c01011ae <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101126:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c010112d:	66 85 c0             	test   %ax,%ax
c0101130:	74 30                	je     c0101162 <cga_putc+0x6c>
            crt_pos --;
c0101132:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101139:	83 e8 01             	sub    $0x1,%eax
c010113c:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101142:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0101147:	0f b7 15 84 ae 11 c0 	movzwl 0xc011ae84,%edx
c010114e:	0f b7 d2             	movzwl %dx,%edx
c0101151:	01 d2                	add    %edx,%edx
c0101153:	01 c2                	add    %eax,%edx
c0101155:	8b 45 08             	mov    0x8(%ebp),%eax
c0101158:	b0 00                	mov    $0x0,%al
c010115a:	83 c8 20             	or     $0x20,%eax
c010115d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101160:	eb 72                	jmp    c01011d4 <cga_putc+0xde>
c0101162:	eb 70                	jmp    c01011d4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101164:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c010116b:	83 c0 50             	add    $0x50,%eax
c010116e:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101174:	0f b7 1d 84 ae 11 c0 	movzwl 0xc011ae84,%ebx
c010117b:	0f b7 0d 84 ae 11 c0 	movzwl 0xc011ae84,%ecx
c0101182:	0f b7 c1             	movzwl %cx,%eax
c0101185:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010118b:	c1 e8 10             	shr    $0x10,%eax
c010118e:	89 c2                	mov    %eax,%edx
c0101190:	66 c1 ea 06          	shr    $0x6,%dx
c0101194:	89 d0                	mov    %edx,%eax
c0101196:	c1 e0 02             	shl    $0x2,%eax
c0101199:	01 d0                	add    %edx,%eax
c010119b:	c1 e0 04             	shl    $0x4,%eax
c010119e:	29 c1                	sub    %eax,%ecx
c01011a0:	89 ca                	mov    %ecx,%edx
c01011a2:	89 d8                	mov    %ebx,%eax
c01011a4:	29 d0                	sub    %edx,%eax
c01011a6:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
        break;
c01011ac:	eb 26                	jmp    c01011d4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ae:	8b 0d 80 ae 11 c0    	mov    0xc011ae80,%ecx
c01011b4:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c01011bb:	8d 50 01             	lea    0x1(%eax),%edx
c01011be:	66 89 15 84 ae 11 c0 	mov    %dx,0xc011ae84
c01011c5:	0f b7 c0             	movzwl %ax,%eax
c01011c8:	01 c0                	add    %eax,%eax
c01011ca:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d0:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d4:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c01011db:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011df:	76 5b                	jbe    c010123c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e1:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01011e6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011ec:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01011f1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f8:	00 
c01011f9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011fd:	89 04 24             	mov    %eax,(%esp)
c0101200:	e8 5a 60 00 00       	call   c010725f <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101205:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010120c:	eb 15                	jmp    c0101223 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010120e:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0101213:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101216:	01 d2                	add    %edx,%edx
c0101218:	01 d0                	add    %edx,%eax
c010121a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101223:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010122a:	7e e2                	jle    c010120e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010122c:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101233:	83 e8 50             	sub    $0x50,%eax
c0101236:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010123c:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0101243:	0f b7 c0             	movzwl %ax,%eax
c0101246:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010124a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010124e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101252:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101256:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101257:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c010125e:	66 c1 e8 08          	shr    $0x8,%ax
c0101262:	0f b6 c0             	movzbl %al,%eax
c0101265:	0f b7 15 86 ae 11 c0 	movzwl 0xc011ae86,%edx
c010126c:	83 c2 01             	add    $0x1,%edx
c010126f:	0f b7 d2             	movzwl %dx,%edx
c0101272:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101276:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101279:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010127d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101281:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101282:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0101289:	0f b7 c0             	movzwl %ax,%eax
c010128c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101290:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101294:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101298:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010129c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010129d:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c01012a4:	0f b6 c0             	movzbl %al,%eax
c01012a7:	0f b7 15 86 ae 11 c0 	movzwl 0xc011ae86,%edx
c01012ae:	83 c2 01             	add    $0x1,%edx
c01012b1:	0f b7 d2             	movzwl %dx,%edx
c01012b4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b8:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c3:	ee                   	out    %al,(%dx)
}
c01012c4:	83 c4 34             	add    $0x34,%esp
c01012c7:	5b                   	pop    %ebx
c01012c8:	5d                   	pop    %ebp
c01012c9:	c3                   	ret    

c01012ca <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ca:	55                   	push   %ebp
c01012cb:	89 e5                	mov    %esp,%ebp
c01012cd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d7:	eb 09                	jmp    c01012e2 <serial_putc_sub+0x18>
        delay();
c01012d9:	e8 4f fb ff ff       	call   c0100e2d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012ec:	89 c2                	mov    %eax,%edx
c01012ee:	ec                   	in     (%dx),%al
c01012ef:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f6:	0f b6 c0             	movzbl %al,%eax
c01012f9:	83 e0 20             	and    $0x20,%eax
c01012fc:	85 c0                	test   %eax,%eax
c01012fe:	75 09                	jne    c0101309 <serial_putc_sub+0x3f>
c0101300:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101307:	7e d0                	jle    c01012d9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101309:	8b 45 08             	mov    0x8(%ebp),%eax
c010130c:	0f b6 c0             	movzbl %al,%eax
c010130f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101315:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101318:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010131c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101320:	ee                   	out    %al,(%dx)
}
c0101321:	c9                   	leave  
c0101322:	c3                   	ret    

c0101323 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101323:	55                   	push   %ebp
c0101324:	89 e5                	mov    %esp,%ebp
c0101326:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101329:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010132d:	74 0d                	je     c010133c <serial_putc+0x19>
        serial_putc_sub(c);
c010132f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101332:	89 04 24             	mov    %eax,(%esp)
c0101335:	e8 90 ff ff ff       	call   c01012ca <serial_putc_sub>
c010133a:	eb 24                	jmp    c0101360 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010133c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101343:	e8 82 ff ff ff       	call   c01012ca <serial_putc_sub>
        serial_putc_sub(' ');
c0101348:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134f:	e8 76 ff ff ff       	call   c01012ca <serial_putc_sub>
        serial_putc_sub('\b');
c0101354:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010135b:	e8 6a ff ff ff       	call   c01012ca <serial_putc_sub>
    }
}
c0101360:	c9                   	leave  
c0101361:	c3                   	ret    

c0101362 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101362:	55                   	push   %ebp
c0101363:	89 e5                	mov    %esp,%ebp
c0101365:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101368:	eb 33                	jmp    c010139d <cons_intr+0x3b>
        if (c != 0) {
c010136a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136e:	74 2d                	je     c010139d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101370:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c0101375:	8d 50 01             	lea    0x1(%eax),%edx
c0101378:	89 15 a4 b0 11 c0    	mov    %edx,0xc011b0a4
c010137e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101381:	88 90 a0 ae 11 c0    	mov    %dl,-0x3fee5160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101387:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c010138c:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101391:	75 0a                	jne    c010139d <cons_intr+0x3b>
                cons.wpos = 0;
c0101393:	c7 05 a4 b0 11 c0 00 	movl   $0x0,0xc011b0a4
c010139a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010139d:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a0:	ff d0                	call   *%eax
c01013a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a9:	75 bf                	jne    c010136a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013ab:	c9                   	leave  
c01013ac:	c3                   	ret    

c01013ad <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ad:	55                   	push   %ebp
c01013ae:	89 e5                	mov    %esp,%ebp
c01013b0:	83 ec 10             	sub    $0x10,%esp
c01013b3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013bd:	89 c2                	mov    %eax,%edx
c01013bf:	ec                   	in     (%dx),%al
c01013c0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c7:	0f b6 c0             	movzbl %al,%eax
c01013ca:	83 e0 01             	and    $0x1,%eax
c01013cd:	85 c0                	test   %eax,%eax
c01013cf:	75 07                	jne    c01013d8 <serial_proc_data+0x2b>
        return -1;
c01013d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d6:	eb 2a                	jmp    c0101402 <serial_proc_data+0x55>
c01013d8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013de:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e2:	89 c2                	mov    %eax,%edx
c01013e4:	ec                   	in     (%dx),%al
c01013e5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ec:	0f b6 c0             	movzbl %al,%eax
c01013ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f6:	75 07                	jne    c01013ff <serial_proc_data+0x52>
        c = '\b';
c01013f8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101402:	c9                   	leave  
c0101403:	c3                   	ret    

c0101404 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101404:	55                   	push   %ebp
c0101405:	89 e5                	mov    %esp,%ebp
c0101407:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010140a:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c010140f:	85 c0                	test   %eax,%eax
c0101411:	74 0c                	je     c010141f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101413:	c7 04 24 ad 13 10 c0 	movl   $0xc01013ad,(%esp)
c010141a:	e8 43 ff ff ff       	call   c0101362 <cons_intr>
    }
}
c010141f:	c9                   	leave  
c0101420:	c3                   	ret    

c0101421 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101421:	55                   	push   %ebp
c0101422:	89 e5                	mov    %esp,%ebp
c0101424:	83 ec 38             	sub    $0x38,%esp
c0101427:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101431:	89 c2                	mov    %eax,%edx
c0101433:	ec                   	in     (%dx),%al
c0101434:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101437:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010143b:	0f b6 c0             	movzbl %al,%eax
c010143e:	83 e0 01             	and    $0x1,%eax
c0101441:	85 c0                	test   %eax,%eax
c0101443:	75 0a                	jne    c010144f <kbd_proc_data+0x2e>
        return -1;
c0101445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010144a:	e9 59 01 00 00       	jmp    c01015a8 <kbd_proc_data+0x187>
c010144f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101455:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101459:	89 c2                	mov    %eax,%edx
c010145b:	ec                   	in     (%dx),%al
c010145c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101463:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101466:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010146a:	75 17                	jne    c0101483 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010146c:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101471:	83 c8 40             	or     $0x40,%eax
c0101474:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
        return 0;
c0101479:	b8 00 00 00 00       	mov    $0x0,%eax
c010147e:	e9 25 01 00 00       	jmp    c01015a8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101483:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101487:	84 c0                	test   %al,%al
c0101489:	79 47                	jns    c01014d2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010148b:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101490:	83 e0 40             	and    $0x40,%eax
c0101493:	85 c0                	test   %eax,%eax
c0101495:	75 09                	jne    c01014a0 <kbd_proc_data+0x7f>
c0101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149b:	83 e0 7f             	and    $0x7f,%eax
c010149e:	eb 04                	jmp    c01014a4 <kbd_proc_data+0x83>
c01014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ab:	0f b6 80 60 a0 11 c0 	movzbl -0x3fee5fa0(%eax),%eax
c01014b2:	83 c8 40             	or     $0x40,%eax
c01014b5:	0f b6 c0             	movzbl %al,%eax
c01014b8:	f7 d0                	not    %eax
c01014ba:	89 c2                	mov    %eax,%edx
c01014bc:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014c1:	21 d0                	and    %edx,%eax
c01014c3:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
        return 0;
c01014c8:	b8 00 00 00 00       	mov    $0x0,%eax
c01014cd:	e9 d6 00 00 00       	jmp    c01015a8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d2:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014d7:	83 e0 40             	and    $0x40,%eax
c01014da:	85 c0                	test   %eax,%eax
c01014dc:	74 11                	je     c01014ef <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014de:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e2:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014e7:	83 e0 bf             	and    $0xffffffbf,%eax
c01014ea:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
    }

    shift |= shiftcode[data];
c01014ef:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f3:	0f b6 80 60 a0 11 c0 	movzbl -0x3fee5fa0(%eax),%eax
c01014fa:	0f b6 d0             	movzbl %al,%edx
c01014fd:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101502:	09 d0                	or     %edx,%eax
c0101504:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
    shift ^= togglecode[data];
c0101509:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150d:	0f b6 80 60 a1 11 c0 	movzbl -0x3fee5ea0(%eax),%eax
c0101514:	0f b6 d0             	movzbl %al,%edx
c0101517:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c010151c:	31 d0                	xor    %edx,%eax
c010151e:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101523:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101528:	83 e0 03             	and    $0x3,%eax
c010152b:	8b 14 85 60 a5 11 c0 	mov    -0x3fee5aa0(,%eax,4),%edx
c0101532:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101536:	01 d0                	add    %edx,%eax
c0101538:	0f b6 00             	movzbl (%eax),%eax
c010153b:	0f b6 c0             	movzbl %al,%eax
c010153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101541:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101546:	83 e0 08             	and    $0x8,%eax
c0101549:	85 c0                	test   %eax,%eax
c010154b:	74 22                	je     c010156f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010154d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101551:	7e 0c                	jle    c010155f <kbd_proc_data+0x13e>
c0101553:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101557:	7f 06                	jg     c010155f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101559:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010155d:	eb 10                	jmp    c010156f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101563:	7e 0a                	jle    c010156f <kbd_proc_data+0x14e>
c0101565:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101569:	7f 04                	jg     c010156f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010156b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156f:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101574:	f7 d0                	not    %eax
c0101576:	83 e0 06             	and    $0x6,%eax
c0101579:	85 c0                	test   %eax,%eax
c010157b:	75 28                	jne    c01015a5 <kbd_proc_data+0x184>
c010157d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101584:	75 1f                	jne    c01015a5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101586:	c7 04 24 dd 76 10 c0 	movl   $0xc01076dd,(%esp)
c010158d:	e8 b5 ed ff ff       	call   c0100347 <cprintf>
c0101592:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101598:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010159c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a8:	c9                   	leave  
c01015a9:	c3                   	ret    

c01015aa <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015aa:	55                   	push   %ebp
c01015ab:	89 e5                	mov    %esp,%ebp
c01015ad:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b0:	c7 04 24 21 14 10 c0 	movl   $0xc0101421,(%esp)
c01015b7:	e8 a6 fd ff ff       	call   c0101362 <cons_intr>
}
c01015bc:	c9                   	leave  
c01015bd:	c3                   	ret    

c01015be <kbd_init>:

static void
kbd_init(void) {
c01015be:	55                   	push   %ebp
c01015bf:	89 e5                	mov    %esp,%ebp
c01015c1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c4:	e8 e1 ff ff ff       	call   c01015aa <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d0:	e8 3d 01 00 00       	call   c0101712 <pic_enable>
}
c01015d5:	c9                   	leave  
c01015d6:	c3                   	ret    

c01015d7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d7:	55                   	push   %ebp
c01015d8:	89 e5                	mov    %esp,%ebp
c01015da:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015dd:	e8 93 f8 ff ff       	call   c0100e75 <cga_init>
    serial_init();
c01015e2:	e8 74 f9 ff ff       	call   c0100f5b <serial_init>
    kbd_init();
c01015e7:	e8 d2 ff ff ff       	call   c01015be <kbd_init>
    if (!serial_exists) {
c01015ec:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c01015f1:	85 c0                	test   %eax,%eax
c01015f3:	75 0c                	jne    c0101601 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f5:	c7 04 24 e9 76 10 c0 	movl   $0xc01076e9,(%esp)
c01015fc:	e8 46 ed ff ff       	call   c0100347 <cprintf>
    }
}
c0101601:	c9                   	leave  
c0101602:	c3                   	ret    

c0101603 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101603:	55                   	push   %ebp
c0101604:	89 e5                	mov    %esp,%ebp
c0101606:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101609:	e8 e2 f7 ff ff       	call   c0100df0 <__intr_save>
c010160e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101611:	8b 45 08             	mov    0x8(%ebp),%eax
c0101614:	89 04 24             	mov    %eax,(%esp)
c0101617:	e8 9b fa ff ff       	call   c01010b7 <lpt_putc>
        cga_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 cf fa ff ff       	call   c01010f6 <cga_putc>
        serial_putc(c);
c0101627:	8b 45 08             	mov    0x8(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 f1 fc ff ff       	call   c0101323 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101632:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 dd f7 ff ff       	call   c0100e1a <__intr_restore>
}
c010163d:	c9                   	leave  
c010163e:	c3                   	ret    

c010163f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163f:	55                   	push   %ebp
c0101640:	89 e5                	mov    %esp,%ebp
c0101642:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010164c:	e8 9f f7 ff ff       	call   c0100df0 <__intr_save>
c0101651:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101654:	e8 ab fd ff ff       	call   c0101404 <serial_intr>
        kbd_intr();
c0101659:	e8 4c ff ff ff       	call   c01015aa <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165e:	8b 15 a0 b0 11 c0    	mov    0xc011b0a0,%edx
c0101664:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c0101669:	39 c2                	cmp    %eax,%edx
c010166b:	74 31                	je     c010169e <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010166d:	a1 a0 b0 11 c0       	mov    0xc011b0a0,%eax
c0101672:	8d 50 01             	lea    0x1(%eax),%edx
c0101675:	89 15 a0 b0 11 c0    	mov    %edx,0xc011b0a0
c010167b:	0f b6 80 a0 ae 11 c0 	movzbl -0x3fee5160(%eax),%eax
c0101682:	0f b6 c0             	movzbl %al,%eax
c0101685:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101688:	a1 a0 b0 11 c0       	mov    0xc011b0a0,%eax
c010168d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101692:	75 0a                	jne    c010169e <cons_getc+0x5f>
                cons.rpos = 0;
c0101694:	c7 05 a0 b0 11 c0 00 	movl   $0x0,0xc011b0a0
c010169b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a1:	89 04 24             	mov    %eax,(%esp)
c01016a4:	e8 71 f7 ff ff       	call   c0100e1a <__intr_restore>
    return c;
c01016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016ac:	c9                   	leave  
c01016ad:	c3                   	ret    

c01016ae <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016b1:	fb                   	sti    
    sti();
}
c01016b2:	5d                   	pop    %ebp
c01016b3:	c3                   	ret    

c01016b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016b4:	55                   	push   %ebp
c01016b5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b7:	fa                   	cli    
    cli();
}
c01016b8:	5d                   	pop    %ebp
c01016b9:	c3                   	ret    

c01016ba <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
c01016bd:	83 ec 14             	sub    $0x14,%esp
c01016c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cb:	66 a3 70 a5 11 c0    	mov    %ax,0xc011a570
    if (did_init) {
c01016d1:	a1 ac b0 11 c0       	mov    0xc011b0ac,%eax
c01016d6:	85 c0                	test   %eax,%eax
c01016d8:	74 36                	je     c0101710 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016da:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016de:	0f b6 c0             	movzbl %al,%eax
c01016e1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e7:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016ea:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016ee:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016f2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016f3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f7:	66 c1 e8 08          	shr    $0x8,%ax
c01016fb:	0f b6 c0             	movzbl %al,%eax
c01016fe:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101704:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101707:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010170b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170f:	ee                   	out    %al,(%dx)
    }
}
c0101710:	c9                   	leave  
c0101711:	c3                   	ret    

c0101712 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101712:	55                   	push   %ebp
c0101713:	89 e5                	mov    %esp,%ebp
c0101715:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101718:	8b 45 08             	mov    0x8(%ebp),%eax
c010171b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101720:	89 c1                	mov    %eax,%ecx
c0101722:	d3 e2                	shl    %cl,%edx
c0101724:	89 d0                	mov    %edx,%eax
c0101726:	f7 d0                	not    %eax
c0101728:	89 c2                	mov    %eax,%edx
c010172a:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c0101731:	21 d0                	and    %edx,%eax
c0101733:	0f b7 c0             	movzwl %ax,%eax
c0101736:	89 04 24             	mov    %eax,(%esp)
c0101739:	e8 7c ff ff ff       	call   c01016ba <pic_setmask>
}
c010173e:	c9                   	leave  
c010173f:	c3                   	ret    

c0101740 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101740:	55                   	push   %ebp
c0101741:	89 e5                	mov    %esp,%ebp
c0101743:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101746:	c7 05 ac b0 11 c0 01 	movl   $0x1,0xc011b0ac
c010174d:	00 00 00 
c0101750:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101756:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010175a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010175e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101762:	ee                   	out    %al,(%dx)
c0101763:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101769:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010176d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101771:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101775:	ee                   	out    %al,(%dx)
c0101776:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010177c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101780:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101784:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101788:	ee                   	out    %al,(%dx)
c0101789:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101793:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101797:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010179b:	ee                   	out    %al,(%dx)
c010179c:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017a2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ae:	ee                   	out    %al,(%dx)
c01017af:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017bd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017c1:	ee                   	out    %al,(%dx)
c01017c2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017cc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017d0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017d4:	ee                   	out    %al,(%dx)
c01017d5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017db:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017df:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017e3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e7:	ee                   	out    %al,(%dx)
c01017e8:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017ee:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017f2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017fa:	ee                   	out    %al,(%dx)
c01017fb:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101801:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101805:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101809:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010180d:	ee                   	out    %al,(%dx)
c010180e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101814:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101818:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010181c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101820:	ee                   	out    %al,(%dx)
c0101821:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101827:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010182b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101833:	ee                   	out    %al,(%dx)
c0101834:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010183a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010183e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101842:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101846:	ee                   	out    %al,(%dx)
c0101847:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010184d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101851:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101855:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101859:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010185a:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c0101861:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101865:	74 12                	je     c0101879 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101867:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c010186e:	0f b7 c0             	movzwl %ax,%eax
c0101871:	89 04 24             	mov    %eax,(%esp)
c0101874:	e8 41 fe ff ff       	call   c01016ba <pic_setmask>
    }
}
c0101879:	c9                   	leave  
c010187a:	c3                   	ret    

c010187b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010187b:	55                   	push   %ebp
c010187c:	89 e5                	mov    %esp,%ebp
c010187e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101881:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101888:	00 
c0101889:	c7 04 24 20 77 10 c0 	movl   $0xc0107720,(%esp)
c0101890:	e8 b2 ea ff ff       	call   c0100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101895:	c7 04 24 2a 77 10 c0 	movl   $0xc010772a,(%esp)
c010189c:	e8 a6 ea ff ff       	call   c0100347 <cprintf>
    panic("EOT: kernel seems ok.");
c01018a1:	c7 44 24 08 38 77 10 	movl   $0xc0107738,0x8(%esp)
c01018a8:	c0 
c01018a9:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018b0:	00 
c01018b1:	c7 04 24 4e 77 10 c0 	movl   $0xc010774e,(%esp)
c01018b8:	e8 14 f4 ff ff       	call   c0100cd1 <__panic>

c01018bd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018bd:	55                   	push   %ebp
c01018be:	89 e5                	mov    %esp,%ebp
c01018c0:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
		extern uintptr_t __vectors[];
		int i;
		for(i=0;i<256;i++)
c01018c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018ca:	e9 c3 00 00 00       	jmp    c0101992 <idt_init+0xd5>
		{
			SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
c01018cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d2:	8b 04 85 00 a6 11 c0 	mov    -0x3fee5a00(,%eax,4),%eax
c01018d9:	89 c2                	mov    %eax,%edx
c01018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018de:	66 89 14 c5 c0 b0 11 	mov    %dx,-0x3fee4f40(,%eax,8)
c01018e5:	c0 
c01018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e9:	66 c7 04 c5 c2 b0 11 	movw   $0x8,-0x3fee4f3e(,%eax,8)
c01018f0:	c0 08 00 
c01018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f6:	0f b6 14 c5 c4 b0 11 	movzbl -0x3fee4f3c(,%eax,8),%edx
c01018fd:	c0 
c01018fe:	83 e2 e0             	and    $0xffffffe0,%edx
c0101901:	88 14 c5 c4 b0 11 c0 	mov    %dl,-0x3fee4f3c(,%eax,8)
c0101908:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190b:	0f b6 14 c5 c4 b0 11 	movzbl -0x3fee4f3c(,%eax,8),%edx
c0101912:	c0 
c0101913:	83 e2 1f             	and    $0x1f,%edx
c0101916:	88 14 c5 c4 b0 11 c0 	mov    %dl,-0x3fee4f3c(,%eax,8)
c010191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101920:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c0101927:	c0 
c0101928:	83 e2 f0             	and    $0xfffffff0,%edx
c010192b:	83 ca 0e             	or     $0xe,%edx
c010192e:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c0101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101938:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c010193f:	c0 
c0101940:	83 e2 ef             	and    $0xffffffef,%edx
c0101943:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c010194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194d:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c0101954:	c0 
c0101955:	83 e2 9f             	and    $0xffffff9f,%edx
c0101958:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c010195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101962:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c0101969:	c0 
c010196a:	83 ca 80             	or     $0xffffff80,%edx
c010196d:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c0101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101977:	8b 04 85 00 a6 11 c0 	mov    -0x3fee5a00(,%eax,4),%eax
c010197e:	c1 e8 10             	shr    $0x10,%eax
c0101981:	89 c2                	mov    %eax,%edx
c0101983:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101986:	66 89 14 c5 c6 b0 11 	mov    %dx,-0x3fee4f3a(,%eax,8)
c010198d:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
		extern uintptr_t __vectors[];
		int i;
		for(i=0;i<256;i++)
c010198e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101992:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101999:	0f 8e 30 ff ff ff    	jle    c01018cf <idt_init+0x12>
		{
			SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
		}
		SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],3);
c010199f:	a1 e4 a7 11 c0       	mov    0xc011a7e4,%eax
c01019a4:	66 a3 88 b4 11 c0    	mov    %ax,0xc011b488
c01019aa:	66 c7 05 8a b4 11 c0 	movw   $0x8,0xc011b48a
c01019b1:	08 00 
c01019b3:	0f b6 05 8c b4 11 c0 	movzbl 0xc011b48c,%eax
c01019ba:	83 e0 e0             	and    $0xffffffe0,%eax
c01019bd:	a2 8c b4 11 c0       	mov    %al,0xc011b48c
c01019c2:	0f b6 05 8c b4 11 c0 	movzbl 0xc011b48c,%eax
c01019c9:	83 e0 1f             	and    $0x1f,%eax
c01019cc:	a2 8c b4 11 c0       	mov    %al,0xc011b48c
c01019d1:	0f b6 05 8d b4 11 c0 	movzbl 0xc011b48d,%eax
c01019d8:	83 e0 f0             	and    $0xfffffff0,%eax
c01019db:	83 c8 0e             	or     $0xe,%eax
c01019de:	a2 8d b4 11 c0       	mov    %al,0xc011b48d
c01019e3:	0f b6 05 8d b4 11 c0 	movzbl 0xc011b48d,%eax
c01019ea:	83 e0 ef             	and    $0xffffffef,%eax
c01019ed:	a2 8d b4 11 c0       	mov    %al,0xc011b48d
c01019f2:	0f b6 05 8d b4 11 c0 	movzbl 0xc011b48d,%eax
c01019f9:	83 c8 60             	or     $0x60,%eax
c01019fc:	a2 8d b4 11 c0       	mov    %al,0xc011b48d
c0101a01:	0f b6 05 8d b4 11 c0 	movzbl 0xc011b48d,%eax
c0101a08:	83 c8 80             	or     $0xffffff80,%eax
c0101a0b:	a2 8d b4 11 c0       	mov    %al,0xc011b48d
c0101a10:	a1 e4 a7 11 c0       	mov    0xc011a7e4,%eax
c0101a15:	c1 e8 10             	shr    $0x10,%eax
c0101a18:	66 a3 8e b4 11 c0    	mov    %ax,0xc011b48e
c0101a1e:	c7 45 f8 80 a5 11 c0 	movl   $0xc011a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a25:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a28:	0f 01 18             	lidtl  (%eax)
		lidt(&idt_pd);
}
c0101a2b:	c9                   	leave  
c0101a2c:	c3                   	ret    

c0101a2d <trapname>:

static const char *
trapname(int trapno) {
c0101a2d:	55                   	push   %ebp
c0101a2e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a33:	83 f8 13             	cmp    $0x13,%eax
c0101a36:	77 0c                	ja     c0101a44 <trapname+0x17>
        return excnames[trapno];
c0101a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3b:	8b 04 85 a0 7a 10 c0 	mov    -0x3fef8560(,%eax,4),%eax
c0101a42:	eb 18                	jmp    c0101a5c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a44:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a48:	7e 0d                	jle    c0101a57 <trapname+0x2a>
c0101a4a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a4e:	7f 07                	jg     c0101a57 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a50:	b8 5f 77 10 c0       	mov    $0xc010775f,%eax
c0101a55:	eb 05                	jmp    c0101a5c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a57:	b8 72 77 10 c0       	mov    $0xc0107772,%eax
}
c0101a5c:	5d                   	pop    %ebp
c0101a5d:	c3                   	ret    

c0101a5e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a5e:	55                   	push   %ebp
c0101a5f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a68:	66 83 f8 08          	cmp    $0x8,%ax
c0101a6c:	0f 94 c0             	sete   %al
c0101a6f:	0f b6 c0             	movzbl %al,%eax
}
c0101a72:	5d                   	pop    %ebp
c0101a73:	c3                   	ret    

c0101a74 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a74:	55                   	push   %ebp
c0101a75:	89 e5                	mov    %esp,%ebp
c0101a77:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a81:	c7 04 24 b3 77 10 c0 	movl   $0xc01077b3,(%esp)
c0101a88:	e8 ba e8 ff ff       	call   c0100347 <cprintf>
    print_regs(&tf->tf_regs);
c0101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a90:	89 04 24             	mov    %eax,(%esp)
c0101a93:	e8 a1 01 00 00       	call   c0101c39 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a9f:	0f b7 c0             	movzwl %ax,%eax
c0101aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa6:	c7 04 24 c4 77 10 c0 	movl   $0xc01077c4,(%esp)
c0101aad:	e8 95 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ab9:	0f b7 c0             	movzwl %ax,%eax
c0101abc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac0:	c7 04 24 d7 77 10 c0 	movl   $0xc01077d7,(%esp)
c0101ac7:	e8 7b e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101acc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acf:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ad3:	0f b7 c0             	movzwl %ax,%eax
c0101ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ada:	c7 04 24 ea 77 10 c0 	movl   $0xc01077ea,(%esp)
c0101ae1:	e8 61 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101aed:	0f b7 c0             	movzwl %ax,%eax
c0101af0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af4:	c7 04 24 fd 77 10 c0 	movl   $0xc01077fd,(%esp)
c0101afb:	e8 47 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b03:	8b 40 30             	mov    0x30(%eax),%eax
c0101b06:	89 04 24             	mov    %eax,(%esp)
c0101b09:	e8 1f ff ff ff       	call   c0101a2d <trapname>
c0101b0e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b11:	8b 52 30             	mov    0x30(%edx),%edx
c0101b14:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b18:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b1c:	c7 04 24 10 78 10 c0 	movl   $0xc0107810,(%esp)
c0101b23:	e8 1f e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2b:	8b 40 34             	mov    0x34(%eax),%eax
c0101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b32:	c7 04 24 22 78 10 c0 	movl   $0xc0107822,(%esp)
c0101b39:	e8 09 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	8b 40 38             	mov    0x38(%eax),%eax
c0101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b48:	c7 04 24 31 78 10 c0 	movl   $0xc0107831,(%esp)
c0101b4f:	e8 f3 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b57:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b5b:	0f b7 c0             	movzwl %ax,%eax
c0101b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b62:	c7 04 24 40 78 10 c0 	movl   $0xc0107840,(%esp)
c0101b69:	e8 d9 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b71:	8b 40 40             	mov    0x40(%eax),%eax
c0101b74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b78:	c7 04 24 53 78 10 c0 	movl   $0xc0107853,(%esp)
c0101b7f:	e8 c3 e7 ff ff       	call   c0100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b8b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b92:	eb 3e                	jmp    c0101bd2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b97:	8b 50 40             	mov    0x40(%eax),%edx
c0101b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b9d:	21 d0                	and    %edx,%eax
c0101b9f:	85 c0                	test   %eax,%eax
c0101ba1:	74 28                	je     c0101bcb <print_trapframe+0x157>
c0101ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba6:	8b 04 85 a0 a5 11 c0 	mov    -0x3fee5a60(,%eax,4),%eax
c0101bad:	85 c0                	test   %eax,%eax
c0101baf:	74 1a                	je     c0101bcb <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb4:	8b 04 85 a0 a5 11 c0 	mov    -0x3fee5a60(,%eax,4),%eax
c0101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbf:	c7 04 24 62 78 10 c0 	movl   $0xc0107862,(%esp)
c0101bc6:	e8 7c e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bcf:	d1 65 f0             	shll   -0x10(%ebp)
c0101bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd5:	83 f8 17             	cmp    $0x17,%eax
c0101bd8:	76 ba                	jbe    c0101b94 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdd:	8b 40 40             	mov    0x40(%eax),%eax
c0101be0:	25 00 30 00 00       	and    $0x3000,%eax
c0101be5:	c1 e8 0c             	shr    $0xc,%eax
c0101be8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bec:	c7 04 24 66 78 10 c0 	movl   $0xc0107866,(%esp)
c0101bf3:	e8 4f e7 ff ff       	call   c0100347 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfb:	89 04 24             	mov    %eax,(%esp)
c0101bfe:	e8 5b fe ff ff       	call   c0101a5e <trap_in_kernel>
c0101c03:	85 c0                	test   %eax,%eax
c0101c05:	75 30                	jne    c0101c37 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0a:	8b 40 44             	mov    0x44(%eax),%eax
c0101c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c11:	c7 04 24 6f 78 10 c0 	movl   $0xc010786f,(%esp)
c0101c18:	e8 2a e7 ff ff       	call   c0100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c20:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c24:	0f b7 c0             	movzwl %ax,%eax
c0101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2b:	c7 04 24 7e 78 10 c0 	movl   $0xc010787e,(%esp)
c0101c32:	e8 10 e7 ff ff       	call   c0100347 <cprintf>
    }
}
c0101c37:	c9                   	leave  
c0101c38:	c3                   	ret    

c0101c39 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c39:	55                   	push   %ebp
c0101c3a:	89 e5                	mov    %esp,%ebp
c0101c3c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c42:	8b 00                	mov    (%eax),%eax
c0101c44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c48:	c7 04 24 91 78 10 c0 	movl   $0xc0107891,(%esp)
c0101c4f:	e8 f3 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c57:	8b 40 04             	mov    0x4(%eax),%eax
c0101c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5e:	c7 04 24 a0 78 10 c0 	movl   $0xc01078a0,(%esp)
c0101c65:	e8 dd e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6d:	8b 40 08             	mov    0x8(%eax),%eax
c0101c70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c74:	c7 04 24 af 78 10 c0 	movl   $0xc01078af,(%esp)
c0101c7b:	e8 c7 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c83:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8a:	c7 04 24 be 78 10 c0 	movl   $0xc01078be,(%esp)
c0101c91:	e8 b1 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c99:	8b 40 10             	mov    0x10(%eax),%eax
c0101c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca0:	c7 04 24 cd 78 10 c0 	movl   $0xc01078cd,(%esp)
c0101ca7:	e8 9b e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101caf:	8b 40 14             	mov    0x14(%eax),%eax
c0101cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb6:	c7 04 24 dc 78 10 c0 	movl   $0xc01078dc,(%esp)
c0101cbd:	e8 85 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc5:	8b 40 18             	mov    0x18(%eax),%eax
c0101cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ccc:	c7 04 24 eb 78 10 c0 	movl   $0xc01078eb,(%esp)
c0101cd3:	e8 6f e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdb:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce2:	c7 04 24 fa 78 10 c0 	movl   $0xc01078fa,(%esp)
c0101ce9:	e8 59 e6 ff ff       	call   c0100347 <cprintf>
}
c0101cee:	c9                   	leave  
c0101cef:	c3                   	ret    

c0101cf0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cf0:	55                   	push   %ebp
c0101cf1:	89 e5                	mov    %esp,%ebp
c0101cf3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf9:	8b 40 30             	mov    0x30(%eax),%eax
c0101cfc:	83 f8 2f             	cmp    $0x2f,%eax
c0101cff:	77 21                	ja     c0101d22 <trap_dispatch+0x32>
c0101d01:	83 f8 2e             	cmp    $0x2e,%eax
c0101d04:	0f 83 46 02 00 00    	jae    c0101f50 <trap_dispatch+0x260>
c0101d0a:	83 f8 21             	cmp    $0x21,%eax
c0101d0d:	0f 84 8a 00 00 00    	je     c0101d9d <trap_dispatch+0xad>
c0101d13:	83 f8 24             	cmp    $0x24,%eax
c0101d16:	74 5c                	je     c0101d74 <trap_dispatch+0x84>
c0101d18:	83 f8 20             	cmp    $0x20,%eax
c0101d1b:	74 1c                	je     c0101d39 <trap_dispatch+0x49>
c0101d1d:	e9 f6 01 00 00       	jmp    c0101f18 <trap_dispatch+0x228>
c0101d22:	83 f8 78             	cmp    $0x78,%eax
c0101d25:	0f 84 3d 01 00 00    	je     c0101e68 <trap_dispatch+0x178>
c0101d2b:	83 f8 79             	cmp    $0x79,%eax
c0101d2e:	0f 84 85 01 00 00    	je     c0101eb9 <trap_dispatch+0x1c9>
c0101d34:	e9 df 01 00 00       	jmp    c0101f18 <trap_dispatch+0x228>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    		ticks++;
c0101d39:	a1 2c ba 11 c0       	mov    0xc011ba2c,%eax
c0101d3e:	83 c0 01             	add    $0x1,%eax
c0101d41:	a3 2c ba 11 c0       	mov    %eax,0xc011ba2c
        	if(ticks%TICK_NUM==0)
c0101d46:	8b 0d 2c ba 11 c0    	mov    0xc011ba2c,%ecx
c0101d4c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d51:	89 c8                	mov    %ecx,%eax
c0101d53:	f7 e2                	mul    %edx
c0101d55:	89 d0                	mov    %edx,%eax
c0101d57:	c1 e8 05             	shr    $0x5,%eax
c0101d5a:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d5d:	29 c1                	sub    %eax,%ecx
c0101d5f:	89 c8                	mov    %ecx,%eax
c0101d61:	85 c0                	test   %eax,%eax
c0101d63:	75 0a                	jne    c0101d6f <trap_dispatch+0x7f>
        		print_ticks();
c0101d65:	e8 11 fb ff ff       	call   c010187b <print_ticks>
        	break;
c0101d6a:	e9 e2 01 00 00       	jmp    c0101f51 <trap_dispatch+0x261>
c0101d6f:	e9 dd 01 00 00       	jmp    c0101f51 <trap_dispatch+0x261>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d74:	e8 c6 f8 ff ff       	call   c010163f <cons_getc>
c0101d79:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d7c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d80:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d84:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d8c:	c7 04 24 09 79 10 c0 	movl   $0xc0107909,(%esp)
c0101d93:	e8 af e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101d98:	e9 b4 01 00 00       	jmp    c0101f51 <trap_dispatch+0x261>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d9d:	e8 9d f8 ff ff       	call   c010163f <cons_getc>
c0101da2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101da5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101da9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dad:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101db1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db5:	c7 04 24 1b 79 10 c0 	movl   $0xc010791b,(%esp)
c0101dbc:	e8 86 e5 ff ff       	call   c0100347 <cprintf>
        if(c=='0')
c0101dc1:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
c0101dc5:	75 44                	jne    c0101e0b <trap_dispatch+0x11b>
               {
               	if(tf->tf_cs!=KERNEL_CS)
c0101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dca:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dce:	66 83 f8 08          	cmp    $0x8,%ax
c0101dd2:	74 2c                	je     c0101e00 <trap_dispatch+0x110>
               	    	{
               	    		tf->tf_cs=KERNEL_CS;
c0101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd7:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
               	    		tf->tf_ds=KERNEL_DS;
c0101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de0:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
               	    		tf->tf_es=KERNEL_DS;
c0101de6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
               	    		tf->tf_eflags &=~FL_IOPL_MASK;
c0101def:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df2:	8b 40 40             	mov    0x40(%eax),%eax
c0101df5:	80 e4 cf             	and    $0xcf,%ah
c0101df8:	89 c2                	mov    %eax,%edx
c0101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dfd:	89 50 40             	mov    %edx,0x40(%eax)
               	    	}
               	print_trapframe(tf);
c0101e00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e03:	89 04 24             	mov    %eax,(%esp)
c0101e06:	e8 69 fc ff ff       	call   c0101a74 <print_trapframe>
               }
               if(c=='3')
c0101e0b:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
c0101e0f:	75 52                	jne    c0101e63 <trap_dispatch+0x173>
               {
               	if(tf->tf_cs!=USER_CS)
c0101e11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e14:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e18:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101e1c:	74 35                	je     c0101e53 <trap_dispatch+0x163>
               	    	{
               	    		tf->tf_cs=USER_CS;
c0101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e21:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
               	    		tf->tf_ds=USER_DS;
c0101e27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e2a:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
               	    		tf->tf_es=USER_DS;
c0101e30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e33:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
               	    		tf->tf_ss=USER_DS;
c0101e39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e3c:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
               	    		tf->tf_eflags|=FL_IOPL_MASK;
c0101e42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e45:	8b 40 40             	mov    0x40(%eax),%eax
c0101e48:	80 cc 30             	or     $0x30,%ah
c0101e4b:	89 c2                	mov    %eax,%edx
c0101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e50:	89 50 40             	mov    %edx,0x40(%eax)
               	    	}
               	print_trapframe(tf);
c0101e53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e56:	89 04 24             	mov    %eax,(%esp)
c0101e59:	e8 16 fc ff ff       	call   c0101a74 <print_trapframe>
               }

        break;
c0101e5e:	e9 ee 00 00 00       	jmp    c0101f51 <trap_dispatch+0x261>
c0101e63:	e9 e9 00 00 00       	jmp    c0101f51 <trap_dispatch+0x261>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    			tf->tf_cs=USER_CS;
c0101e68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    	    	tf->tf_ds=USER_DS;
c0101e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e74:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
    	    	tf->tf_es=USER_DS;
c0101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7d:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
    	    	tf->tf_ss=USER_DS;
c0101e83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e86:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
    	    	tf->tf_esp=(uint32_t)tf+sizeof(struct trapframe)-8;
c0101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8f:	8d 50 44             	lea    0x44(%eax),%edx
c0101e92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e95:	89 50 44             	mov    %edx,0x44(%eax)
    	    	tf->tf_eflags|=FL_IOPL_MASK;
c0101e98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9b:	8b 40 40             	mov    0x40(%eax),%eax
c0101e9e:	80 cc 30             	or     $0x30,%ah
c0101ea1:	89 c2                	mov    %eax,%edx
c0101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea6:	89 50 40             	mov    %edx,0x40(%eax)
    	    	*((uint32_t*)tf-1)=(uint32_t)tf;
c0101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eac:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb2:	89 02                	mov    %eax,(%edx)
    	    	break;
c0101eb4:	e9 98 00 00 00       	jmp    c0101f51 <trap_dispatch+0x261>
    case T_SWITCH_TOK:
    			tf->tf_cs=KERNEL_CS;
c0101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebc:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
    	    	tf->tf_ds=KERNEL_DS;
c0101ec2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec5:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
    	    	tf->tf_es=KERNEL_DS;
c0101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ece:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
    	    	tf->tf_eflags &=~FL_IOPL_MASK;
c0101ed4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed7:	8b 40 40             	mov    0x40(%eax),%eax
c0101eda:	80 e4 cf             	and    $0xcf,%ah
c0101edd:	89 c2                	mov    %eax,%edx
c0101edf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee2:	89 50 40             	mov    %edx,0x40(%eax)
    	    	struct trapframe* switchu2k=(struct trapframe*)(tf->tf_esp-(sizeof(struct trapframe)-8));
c0101ee5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee8:	8b 40 44             	mov    0x44(%eax),%eax
c0101eeb:	83 e8 44             	sub    $0x44,%eax
c0101eee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	    	memmove(switchu2k,tf,sizeof(struct trapframe)-8);
c0101ef1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101ef8:	00 
c0101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101efc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f03:	89 04 24             	mov    %eax,(%esp)
c0101f06:	e8 54 53 00 00       	call   c010725f <memmove>
    	    	*((uint32_t*)tf-1)=(uint32_t)switchu2k;
c0101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f0e:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f14:	89 02                	mov    %eax,(%edx)
    	        break;
c0101f16:	eb 39                	jmp    c0101f51 <trap_dispatch+0x261>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101f18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f1b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f1f:	0f b7 c0             	movzwl %ax,%eax
c0101f22:	83 e0 03             	and    $0x3,%eax
c0101f25:	85 c0                	test   %eax,%eax
c0101f27:	75 28                	jne    c0101f51 <trap_dispatch+0x261>
            print_trapframe(tf);
c0101f29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2c:	89 04 24             	mov    %eax,(%esp)
c0101f2f:	e8 40 fb ff ff       	call   c0101a74 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f34:	c7 44 24 08 2a 79 10 	movl   $0xc010792a,0x8(%esp)
c0101f3b:	c0 
c0101f3c:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0101f43:	00 
c0101f44:	c7 04 24 4e 77 10 c0 	movl   $0xc010774e,(%esp)
c0101f4b:	e8 81 ed ff ff       	call   c0100cd1 <__panic>
    	    	*((uint32_t*)tf-1)=(uint32_t)switchu2k;
    	        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101f50:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101f51:	c9                   	leave  
c0101f52:	c3                   	ret    

c0101f53 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101f53:	55                   	push   %ebp
c0101f54:	89 e5                	mov    %esp,%ebp
c0101f56:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5c:	89 04 24             	mov    %eax,(%esp)
c0101f5f:	e8 8c fd ff ff       	call   c0101cf0 <trap_dispatch>
}
c0101f64:	c9                   	leave  
c0101f65:	c3                   	ret    

c0101f66 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101f66:	1e                   	push   %ds
    pushl %es
c0101f67:	06                   	push   %es
    pushl %fs
c0101f68:	0f a0                	push   %fs
    pushl %gs
c0101f6a:	0f a8                	push   %gs
    pushal
c0101f6c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101f6d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101f72:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101f74:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101f76:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101f77:	e8 d7 ff ff ff       	call   c0101f53 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101f7c:	5c                   	pop    %esp

c0101f7d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101f7d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101f7e:	0f a9                	pop    %gs
    popl %fs
c0101f80:	0f a1                	pop    %fs
    popl %es
c0101f82:	07                   	pop    %es
    popl %ds
c0101f83:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101f84:	83 c4 08             	add    $0x8,%esp
    iret
c0101f87:	cf                   	iret   

c0101f88 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $0
c0101f8a:	6a 00                	push   $0x0
  jmp __alltraps
c0101f8c:	e9 d5 ff ff ff       	jmp    c0101f66 <__alltraps>

c0101f91 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $1
c0101f93:	6a 01                	push   $0x1
  jmp __alltraps
c0101f95:	e9 cc ff ff ff       	jmp    c0101f66 <__alltraps>

c0101f9a <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $2
c0101f9c:	6a 02                	push   $0x2
  jmp __alltraps
c0101f9e:	e9 c3 ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fa3 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $3
c0101fa5:	6a 03                	push   $0x3
  jmp __alltraps
c0101fa7:	e9 ba ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fac <vector4>:
.globl vector4
vector4:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $4
c0101fae:	6a 04                	push   $0x4
  jmp __alltraps
c0101fb0:	e9 b1 ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fb5 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $5
c0101fb7:	6a 05                	push   $0x5
  jmp __alltraps
c0101fb9:	e9 a8 ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fbe <vector6>:
.globl vector6
vector6:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $6
c0101fc0:	6a 06                	push   $0x6
  jmp __alltraps
c0101fc2:	e9 9f ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fc7 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $7
c0101fc9:	6a 07                	push   $0x7
  jmp __alltraps
c0101fcb:	e9 96 ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fd0 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101fd0:	6a 08                	push   $0x8
  jmp __alltraps
c0101fd2:	e9 8f ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fd7 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101fd7:	6a 09                	push   $0x9
  jmp __alltraps
c0101fd9:	e9 88 ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fde <vector10>:
.globl vector10
vector10:
  pushl $10
c0101fde:	6a 0a                	push   $0xa
  jmp __alltraps
c0101fe0:	e9 81 ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fe5 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101fe5:	6a 0b                	push   $0xb
  jmp __alltraps
c0101fe7:	e9 7a ff ff ff       	jmp    c0101f66 <__alltraps>

c0101fec <vector12>:
.globl vector12
vector12:
  pushl $12
c0101fec:	6a 0c                	push   $0xc
  jmp __alltraps
c0101fee:	e9 73 ff ff ff       	jmp    c0101f66 <__alltraps>

c0101ff3 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ff3:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ff5:	e9 6c ff ff ff       	jmp    c0101f66 <__alltraps>

c0101ffa <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ffa:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ffc:	e9 65 ff ff ff       	jmp    c0101f66 <__alltraps>

c0102001 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102001:	6a 00                	push   $0x0
  pushl $15
c0102003:	6a 0f                	push   $0xf
  jmp __alltraps
c0102005:	e9 5c ff ff ff       	jmp    c0101f66 <__alltraps>

c010200a <vector16>:
.globl vector16
vector16:
  pushl $0
c010200a:	6a 00                	push   $0x0
  pushl $16
c010200c:	6a 10                	push   $0x10
  jmp __alltraps
c010200e:	e9 53 ff ff ff       	jmp    c0101f66 <__alltraps>

c0102013 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102013:	6a 11                	push   $0x11
  jmp __alltraps
c0102015:	e9 4c ff ff ff       	jmp    c0101f66 <__alltraps>

c010201a <vector18>:
.globl vector18
vector18:
  pushl $0
c010201a:	6a 00                	push   $0x0
  pushl $18
c010201c:	6a 12                	push   $0x12
  jmp __alltraps
c010201e:	e9 43 ff ff ff       	jmp    c0101f66 <__alltraps>

c0102023 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102023:	6a 00                	push   $0x0
  pushl $19
c0102025:	6a 13                	push   $0x13
  jmp __alltraps
c0102027:	e9 3a ff ff ff       	jmp    c0101f66 <__alltraps>

c010202c <vector20>:
.globl vector20
vector20:
  pushl $0
c010202c:	6a 00                	push   $0x0
  pushl $20
c010202e:	6a 14                	push   $0x14
  jmp __alltraps
c0102030:	e9 31 ff ff ff       	jmp    c0101f66 <__alltraps>

c0102035 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102035:	6a 00                	push   $0x0
  pushl $21
c0102037:	6a 15                	push   $0x15
  jmp __alltraps
c0102039:	e9 28 ff ff ff       	jmp    c0101f66 <__alltraps>

c010203e <vector22>:
.globl vector22
vector22:
  pushl $0
c010203e:	6a 00                	push   $0x0
  pushl $22
c0102040:	6a 16                	push   $0x16
  jmp __alltraps
c0102042:	e9 1f ff ff ff       	jmp    c0101f66 <__alltraps>

c0102047 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102047:	6a 00                	push   $0x0
  pushl $23
c0102049:	6a 17                	push   $0x17
  jmp __alltraps
c010204b:	e9 16 ff ff ff       	jmp    c0101f66 <__alltraps>

c0102050 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $24
c0102052:	6a 18                	push   $0x18
  jmp __alltraps
c0102054:	e9 0d ff ff ff       	jmp    c0101f66 <__alltraps>

c0102059 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $25
c010205b:	6a 19                	push   $0x19
  jmp __alltraps
c010205d:	e9 04 ff ff ff       	jmp    c0101f66 <__alltraps>

c0102062 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $26
c0102064:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102066:	e9 fb fe ff ff       	jmp    c0101f66 <__alltraps>

c010206b <vector27>:
.globl vector27
vector27:
  pushl $0
c010206b:	6a 00                	push   $0x0
  pushl $27
c010206d:	6a 1b                	push   $0x1b
  jmp __alltraps
c010206f:	e9 f2 fe ff ff       	jmp    c0101f66 <__alltraps>

c0102074 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $28
c0102076:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102078:	e9 e9 fe ff ff       	jmp    c0101f66 <__alltraps>

c010207d <vector29>:
.globl vector29
vector29:
  pushl $0
c010207d:	6a 00                	push   $0x0
  pushl $29
c010207f:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102081:	e9 e0 fe ff ff       	jmp    c0101f66 <__alltraps>

c0102086 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102086:	6a 00                	push   $0x0
  pushl $30
c0102088:	6a 1e                	push   $0x1e
  jmp __alltraps
c010208a:	e9 d7 fe ff ff       	jmp    c0101f66 <__alltraps>

c010208f <vector31>:
.globl vector31
vector31:
  pushl $0
c010208f:	6a 00                	push   $0x0
  pushl $31
c0102091:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102093:	e9 ce fe ff ff       	jmp    c0101f66 <__alltraps>

c0102098 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $32
c010209a:	6a 20                	push   $0x20
  jmp __alltraps
c010209c:	e9 c5 fe ff ff       	jmp    c0101f66 <__alltraps>

c01020a1 <vector33>:
.globl vector33
vector33:
  pushl $0
c01020a1:	6a 00                	push   $0x0
  pushl $33
c01020a3:	6a 21                	push   $0x21
  jmp __alltraps
c01020a5:	e9 bc fe ff ff       	jmp    c0101f66 <__alltraps>

c01020aa <vector34>:
.globl vector34
vector34:
  pushl $0
c01020aa:	6a 00                	push   $0x0
  pushl $34
c01020ac:	6a 22                	push   $0x22
  jmp __alltraps
c01020ae:	e9 b3 fe ff ff       	jmp    c0101f66 <__alltraps>

c01020b3 <vector35>:
.globl vector35
vector35:
  pushl $0
c01020b3:	6a 00                	push   $0x0
  pushl $35
c01020b5:	6a 23                	push   $0x23
  jmp __alltraps
c01020b7:	e9 aa fe ff ff       	jmp    c0101f66 <__alltraps>

c01020bc <vector36>:
.globl vector36
vector36:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $36
c01020be:	6a 24                	push   $0x24
  jmp __alltraps
c01020c0:	e9 a1 fe ff ff       	jmp    c0101f66 <__alltraps>

c01020c5 <vector37>:
.globl vector37
vector37:
  pushl $0
c01020c5:	6a 00                	push   $0x0
  pushl $37
c01020c7:	6a 25                	push   $0x25
  jmp __alltraps
c01020c9:	e9 98 fe ff ff       	jmp    c0101f66 <__alltraps>

c01020ce <vector38>:
.globl vector38
vector38:
  pushl $0
c01020ce:	6a 00                	push   $0x0
  pushl $38
c01020d0:	6a 26                	push   $0x26
  jmp __alltraps
c01020d2:	e9 8f fe ff ff       	jmp    c0101f66 <__alltraps>

c01020d7 <vector39>:
.globl vector39
vector39:
  pushl $0
c01020d7:	6a 00                	push   $0x0
  pushl $39
c01020d9:	6a 27                	push   $0x27
  jmp __alltraps
c01020db:	e9 86 fe ff ff       	jmp    c0101f66 <__alltraps>

c01020e0 <vector40>:
.globl vector40
vector40:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $40
c01020e2:	6a 28                	push   $0x28
  jmp __alltraps
c01020e4:	e9 7d fe ff ff       	jmp    c0101f66 <__alltraps>

c01020e9 <vector41>:
.globl vector41
vector41:
  pushl $0
c01020e9:	6a 00                	push   $0x0
  pushl $41
c01020eb:	6a 29                	push   $0x29
  jmp __alltraps
c01020ed:	e9 74 fe ff ff       	jmp    c0101f66 <__alltraps>

c01020f2 <vector42>:
.globl vector42
vector42:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $42
c01020f4:	6a 2a                	push   $0x2a
  jmp __alltraps
c01020f6:	e9 6b fe ff ff       	jmp    c0101f66 <__alltraps>

c01020fb <vector43>:
.globl vector43
vector43:
  pushl $0
c01020fb:	6a 00                	push   $0x0
  pushl $43
c01020fd:	6a 2b                	push   $0x2b
  jmp __alltraps
c01020ff:	e9 62 fe ff ff       	jmp    c0101f66 <__alltraps>

c0102104 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $44
c0102106:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102108:	e9 59 fe ff ff       	jmp    c0101f66 <__alltraps>

c010210d <vector45>:
.globl vector45
vector45:
  pushl $0
c010210d:	6a 00                	push   $0x0
  pushl $45
c010210f:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102111:	e9 50 fe ff ff       	jmp    c0101f66 <__alltraps>

c0102116 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $46
c0102118:	6a 2e                	push   $0x2e
  jmp __alltraps
c010211a:	e9 47 fe ff ff       	jmp    c0101f66 <__alltraps>

c010211f <vector47>:
.globl vector47
vector47:
  pushl $0
c010211f:	6a 00                	push   $0x0
  pushl $47
c0102121:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102123:	e9 3e fe ff ff       	jmp    c0101f66 <__alltraps>

c0102128 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $48
c010212a:	6a 30                	push   $0x30
  jmp __alltraps
c010212c:	e9 35 fe ff ff       	jmp    c0101f66 <__alltraps>

c0102131 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102131:	6a 00                	push   $0x0
  pushl $49
c0102133:	6a 31                	push   $0x31
  jmp __alltraps
c0102135:	e9 2c fe ff ff       	jmp    c0101f66 <__alltraps>

c010213a <vector50>:
.globl vector50
vector50:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $50
c010213c:	6a 32                	push   $0x32
  jmp __alltraps
c010213e:	e9 23 fe ff ff       	jmp    c0101f66 <__alltraps>

c0102143 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $51
c0102145:	6a 33                	push   $0x33
  jmp __alltraps
c0102147:	e9 1a fe ff ff       	jmp    c0101f66 <__alltraps>

c010214c <vector52>:
.globl vector52
vector52:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $52
c010214e:	6a 34                	push   $0x34
  jmp __alltraps
c0102150:	e9 11 fe ff ff       	jmp    c0101f66 <__alltraps>

c0102155 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $53
c0102157:	6a 35                	push   $0x35
  jmp __alltraps
c0102159:	e9 08 fe ff ff       	jmp    c0101f66 <__alltraps>

c010215e <vector54>:
.globl vector54
vector54:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $54
c0102160:	6a 36                	push   $0x36
  jmp __alltraps
c0102162:	e9 ff fd ff ff       	jmp    c0101f66 <__alltraps>

c0102167 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $55
c0102169:	6a 37                	push   $0x37
  jmp __alltraps
c010216b:	e9 f6 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102170 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $56
c0102172:	6a 38                	push   $0x38
  jmp __alltraps
c0102174:	e9 ed fd ff ff       	jmp    c0101f66 <__alltraps>

c0102179 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $57
c010217b:	6a 39                	push   $0x39
  jmp __alltraps
c010217d:	e9 e4 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102182 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $58
c0102184:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102186:	e9 db fd ff ff       	jmp    c0101f66 <__alltraps>

c010218b <vector59>:
.globl vector59
vector59:
  pushl $0
c010218b:	6a 00                	push   $0x0
  pushl $59
c010218d:	6a 3b                	push   $0x3b
  jmp __alltraps
c010218f:	e9 d2 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102194 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $60
c0102196:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102198:	e9 c9 fd ff ff       	jmp    c0101f66 <__alltraps>

c010219d <vector61>:
.globl vector61
vector61:
  pushl $0
c010219d:	6a 00                	push   $0x0
  pushl $61
c010219f:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021a1:	e9 c0 fd ff ff       	jmp    c0101f66 <__alltraps>

c01021a6 <vector62>:
.globl vector62
vector62:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $62
c01021a8:	6a 3e                	push   $0x3e
  jmp __alltraps
c01021aa:	e9 b7 fd ff ff       	jmp    c0101f66 <__alltraps>

c01021af <vector63>:
.globl vector63
vector63:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $63
c01021b1:	6a 3f                	push   $0x3f
  jmp __alltraps
c01021b3:	e9 ae fd ff ff       	jmp    c0101f66 <__alltraps>

c01021b8 <vector64>:
.globl vector64
vector64:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $64
c01021ba:	6a 40                	push   $0x40
  jmp __alltraps
c01021bc:	e9 a5 fd ff ff       	jmp    c0101f66 <__alltraps>

c01021c1 <vector65>:
.globl vector65
vector65:
  pushl $0
c01021c1:	6a 00                	push   $0x0
  pushl $65
c01021c3:	6a 41                	push   $0x41
  jmp __alltraps
c01021c5:	e9 9c fd ff ff       	jmp    c0101f66 <__alltraps>

c01021ca <vector66>:
.globl vector66
vector66:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $66
c01021cc:	6a 42                	push   $0x42
  jmp __alltraps
c01021ce:	e9 93 fd ff ff       	jmp    c0101f66 <__alltraps>

c01021d3 <vector67>:
.globl vector67
vector67:
  pushl $0
c01021d3:	6a 00                	push   $0x0
  pushl $67
c01021d5:	6a 43                	push   $0x43
  jmp __alltraps
c01021d7:	e9 8a fd ff ff       	jmp    c0101f66 <__alltraps>

c01021dc <vector68>:
.globl vector68
vector68:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $68
c01021de:	6a 44                	push   $0x44
  jmp __alltraps
c01021e0:	e9 81 fd ff ff       	jmp    c0101f66 <__alltraps>

c01021e5 <vector69>:
.globl vector69
vector69:
  pushl $0
c01021e5:	6a 00                	push   $0x0
  pushl $69
c01021e7:	6a 45                	push   $0x45
  jmp __alltraps
c01021e9:	e9 78 fd ff ff       	jmp    c0101f66 <__alltraps>

c01021ee <vector70>:
.globl vector70
vector70:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $70
c01021f0:	6a 46                	push   $0x46
  jmp __alltraps
c01021f2:	e9 6f fd ff ff       	jmp    c0101f66 <__alltraps>

c01021f7 <vector71>:
.globl vector71
vector71:
  pushl $0
c01021f7:	6a 00                	push   $0x0
  pushl $71
c01021f9:	6a 47                	push   $0x47
  jmp __alltraps
c01021fb:	e9 66 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102200 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $72
c0102202:	6a 48                	push   $0x48
  jmp __alltraps
c0102204:	e9 5d fd ff ff       	jmp    c0101f66 <__alltraps>

c0102209 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102209:	6a 00                	push   $0x0
  pushl $73
c010220b:	6a 49                	push   $0x49
  jmp __alltraps
c010220d:	e9 54 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102212 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $74
c0102214:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102216:	e9 4b fd ff ff       	jmp    c0101f66 <__alltraps>

c010221b <vector75>:
.globl vector75
vector75:
  pushl $0
c010221b:	6a 00                	push   $0x0
  pushl $75
c010221d:	6a 4b                	push   $0x4b
  jmp __alltraps
c010221f:	e9 42 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102224 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $76
c0102226:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102228:	e9 39 fd ff ff       	jmp    c0101f66 <__alltraps>

c010222d <vector77>:
.globl vector77
vector77:
  pushl $0
c010222d:	6a 00                	push   $0x0
  pushl $77
c010222f:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102231:	e9 30 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102236 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102236:	6a 00                	push   $0x0
  pushl $78
c0102238:	6a 4e                	push   $0x4e
  jmp __alltraps
c010223a:	e9 27 fd ff ff       	jmp    c0101f66 <__alltraps>

c010223f <vector79>:
.globl vector79
vector79:
  pushl $0
c010223f:	6a 00                	push   $0x0
  pushl $79
c0102241:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102243:	e9 1e fd ff ff       	jmp    c0101f66 <__alltraps>

c0102248 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $80
c010224a:	6a 50                	push   $0x50
  jmp __alltraps
c010224c:	e9 15 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102251 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102251:	6a 00                	push   $0x0
  pushl $81
c0102253:	6a 51                	push   $0x51
  jmp __alltraps
c0102255:	e9 0c fd ff ff       	jmp    c0101f66 <__alltraps>

c010225a <vector82>:
.globl vector82
vector82:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $82
c010225c:	6a 52                	push   $0x52
  jmp __alltraps
c010225e:	e9 03 fd ff ff       	jmp    c0101f66 <__alltraps>

c0102263 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102263:	6a 00                	push   $0x0
  pushl $83
c0102265:	6a 53                	push   $0x53
  jmp __alltraps
c0102267:	e9 fa fc ff ff       	jmp    c0101f66 <__alltraps>

c010226c <vector84>:
.globl vector84
vector84:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $84
c010226e:	6a 54                	push   $0x54
  jmp __alltraps
c0102270:	e9 f1 fc ff ff       	jmp    c0101f66 <__alltraps>

c0102275 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102275:	6a 00                	push   $0x0
  pushl $85
c0102277:	6a 55                	push   $0x55
  jmp __alltraps
c0102279:	e9 e8 fc ff ff       	jmp    c0101f66 <__alltraps>

c010227e <vector86>:
.globl vector86
vector86:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $86
c0102280:	6a 56                	push   $0x56
  jmp __alltraps
c0102282:	e9 df fc ff ff       	jmp    c0101f66 <__alltraps>

c0102287 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102287:	6a 00                	push   $0x0
  pushl $87
c0102289:	6a 57                	push   $0x57
  jmp __alltraps
c010228b:	e9 d6 fc ff ff       	jmp    c0101f66 <__alltraps>

c0102290 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $88
c0102292:	6a 58                	push   $0x58
  jmp __alltraps
c0102294:	e9 cd fc ff ff       	jmp    c0101f66 <__alltraps>

c0102299 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102299:	6a 00                	push   $0x0
  pushl $89
c010229b:	6a 59                	push   $0x59
  jmp __alltraps
c010229d:	e9 c4 fc ff ff       	jmp    c0101f66 <__alltraps>

c01022a2 <vector90>:
.globl vector90
vector90:
  pushl $0
c01022a2:	6a 00                	push   $0x0
  pushl $90
c01022a4:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022a6:	e9 bb fc ff ff       	jmp    c0101f66 <__alltraps>

c01022ab <vector91>:
.globl vector91
vector91:
  pushl $0
c01022ab:	6a 00                	push   $0x0
  pushl $91
c01022ad:	6a 5b                	push   $0x5b
  jmp __alltraps
c01022af:	e9 b2 fc ff ff       	jmp    c0101f66 <__alltraps>

c01022b4 <vector92>:
.globl vector92
vector92:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $92
c01022b6:	6a 5c                	push   $0x5c
  jmp __alltraps
c01022b8:	e9 a9 fc ff ff       	jmp    c0101f66 <__alltraps>

c01022bd <vector93>:
.globl vector93
vector93:
  pushl $0
c01022bd:	6a 00                	push   $0x0
  pushl $93
c01022bf:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022c1:	e9 a0 fc ff ff       	jmp    c0101f66 <__alltraps>

c01022c6 <vector94>:
.globl vector94
vector94:
  pushl $0
c01022c6:	6a 00                	push   $0x0
  pushl $94
c01022c8:	6a 5e                	push   $0x5e
  jmp __alltraps
c01022ca:	e9 97 fc ff ff       	jmp    c0101f66 <__alltraps>

c01022cf <vector95>:
.globl vector95
vector95:
  pushl $0
c01022cf:	6a 00                	push   $0x0
  pushl $95
c01022d1:	6a 5f                	push   $0x5f
  jmp __alltraps
c01022d3:	e9 8e fc ff ff       	jmp    c0101f66 <__alltraps>

c01022d8 <vector96>:
.globl vector96
vector96:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $96
c01022da:	6a 60                	push   $0x60
  jmp __alltraps
c01022dc:	e9 85 fc ff ff       	jmp    c0101f66 <__alltraps>

c01022e1 <vector97>:
.globl vector97
vector97:
  pushl $0
c01022e1:	6a 00                	push   $0x0
  pushl $97
c01022e3:	6a 61                	push   $0x61
  jmp __alltraps
c01022e5:	e9 7c fc ff ff       	jmp    c0101f66 <__alltraps>

c01022ea <vector98>:
.globl vector98
vector98:
  pushl $0
c01022ea:	6a 00                	push   $0x0
  pushl $98
c01022ec:	6a 62                	push   $0x62
  jmp __alltraps
c01022ee:	e9 73 fc ff ff       	jmp    c0101f66 <__alltraps>

c01022f3 <vector99>:
.globl vector99
vector99:
  pushl $0
c01022f3:	6a 00                	push   $0x0
  pushl $99
c01022f5:	6a 63                	push   $0x63
  jmp __alltraps
c01022f7:	e9 6a fc ff ff       	jmp    c0101f66 <__alltraps>

c01022fc <vector100>:
.globl vector100
vector100:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $100
c01022fe:	6a 64                	push   $0x64
  jmp __alltraps
c0102300:	e9 61 fc ff ff       	jmp    c0101f66 <__alltraps>

c0102305 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102305:	6a 00                	push   $0x0
  pushl $101
c0102307:	6a 65                	push   $0x65
  jmp __alltraps
c0102309:	e9 58 fc ff ff       	jmp    c0101f66 <__alltraps>

c010230e <vector102>:
.globl vector102
vector102:
  pushl $0
c010230e:	6a 00                	push   $0x0
  pushl $102
c0102310:	6a 66                	push   $0x66
  jmp __alltraps
c0102312:	e9 4f fc ff ff       	jmp    c0101f66 <__alltraps>

c0102317 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102317:	6a 00                	push   $0x0
  pushl $103
c0102319:	6a 67                	push   $0x67
  jmp __alltraps
c010231b:	e9 46 fc ff ff       	jmp    c0101f66 <__alltraps>

c0102320 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $104
c0102322:	6a 68                	push   $0x68
  jmp __alltraps
c0102324:	e9 3d fc ff ff       	jmp    c0101f66 <__alltraps>

c0102329 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102329:	6a 00                	push   $0x0
  pushl $105
c010232b:	6a 69                	push   $0x69
  jmp __alltraps
c010232d:	e9 34 fc ff ff       	jmp    c0101f66 <__alltraps>

c0102332 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $106
c0102334:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102336:	e9 2b fc ff ff       	jmp    c0101f66 <__alltraps>

c010233b <vector107>:
.globl vector107
vector107:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $107
c010233d:	6a 6b                	push   $0x6b
  jmp __alltraps
c010233f:	e9 22 fc ff ff       	jmp    c0101f66 <__alltraps>

c0102344 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $108
c0102346:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102348:	e9 19 fc ff ff       	jmp    c0101f66 <__alltraps>

c010234d <vector109>:
.globl vector109
vector109:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $109
c010234f:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102351:	e9 10 fc ff ff       	jmp    c0101f66 <__alltraps>

c0102356 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102356:	6a 00                	push   $0x0
  pushl $110
c0102358:	6a 6e                	push   $0x6e
  jmp __alltraps
c010235a:	e9 07 fc ff ff       	jmp    c0101f66 <__alltraps>

c010235f <vector111>:
.globl vector111
vector111:
  pushl $0
c010235f:	6a 00                	push   $0x0
  pushl $111
c0102361:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102363:	e9 fe fb ff ff       	jmp    c0101f66 <__alltraps>

c0102368 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $112
c010236a:	6a 70                	push   $0x70
  jmp __alltraps
c010236c:	e9 f5 fb ff ff       	jmp    c0101f66 <__alltraps>

c0102371 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $113
c0102373:	6a 71                	push   $0x71
  jmp __alltraps
c0102375:	e9 ec fb ff ff       	jmp    c0101f66 <__alltraps>

c010237a <vector114>:
.globl vector114
vector114:
  pushl $0
c010237a:	6a 00                	push   $0x0
  pushl $114
c010237c:	6a 72                	push   $0x72
  jmp __alltraps
c010237e:	e9 e3 fb ff ff       	jmp    c0101f66 <__alltraps>

c0102383 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102383:	6a 00                	push   $0x0
  pushl $115
c0102385:	6a 73                	push   $0x73
  jmp __alltraps
c0102387:	e9 da fb ff ff       	jmp    c0101f66 <__alltraps>

c010238c <vector116>:
.globl vector116
vector116:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $116
c010238e:	6a 74                	push   $0x74
  jmp __alltraps
c0102390:	e9 d1 fb ff ff       	jmp    c0101f66 <__alltraps>

c0102395 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $117
c0102397:	6a 75                	push   $0x75
  jmp __alltraps
c0102399:	e9 c8 fb ff ff       	jmp    c0101f66 <__alltraps>

c010239e <vector118>:
.globl vector118
vector118:
  pushl $0
c010239e:	6a 00                	push   $0x0
  pushl $118
c01023a0:	6a 76                	push   $0x76
  jmp __alltraps
c01023a2:	e9 bf fb ff ff       	jmp    c0101f66 <__alltraps>

c01023a7 <vector119>:
.globl vector119
vector119:
  pushl $0
c01023a7:	6a 00                	push   $0x0
  pushl $119
c01023a9:	6a 77                	push   $0x77
  jmp __alltraps
c01023ab:	e9 b6 fb ff ff       	jmp    c0101f66 <__alltraps>

c01023b0 <vector120>:
.globl vector120
vector120:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $120
c01023b2:	6a 78                	push   $0x78
  jmp __alltraps
c01023b4:	e9 ad fb ff ff       	jmp    c0101f66 <__alltraps>

c01023b9 <vector121>:
.globl vector121
vector121:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $121
c01023bb:	6a 79                	push   $0x79
  jmp __alltraps
c01023bd:	e9 a4 fb ff ff       	jmp    c0101f66 <__alltraps>

c01023c2 <vector122>:
.globl vector122
vector122:
  pushl $0
c01023c2:	6a 00                	push   $0x0
  pushl $122
c01023c4:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023c6:	e9 9b fb ff ff       	jmp    c0101f66 <__alltraps>

c01023cb <vector123>:
.globl vector123
vector123:
  pushl $0
c01023cb:	6a 00                	push   $0x0
  pushl $123
c01023cd:	6a 7b                	push   $0x7b
  jmp __alltraps
c01023cf:	e9 92 fb ff ff       	jmp    c0101f66 <__alltraps>

c01023d4 <vector124>:
.globl vector124
vector124:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $124
c01023d6:	6a 7c                	push   $0x7c
  jmp __alltraps
c01023d8:	e9 89 fb ff ff       	jmp    c0101f66 <__alltraps>

c01023dd <vector125>:
.globl vector125
vector125:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $125
c01023df:	6a 7d                	push   $0x7d
  jmp __alltraps
c01023e1:	e9 80 fb ff ff       	jmp    c0101f66 <__alltraps>

c01023e6 <vector126>:
.globl vector126
vector126:
  pushl $0
c01023e6:	6a 00                	push   $0x0
  pushl $126
c01023e8:	6a 7e                	push   $0x7e
  jmp __alltraps
c01023ea:	e9 77 fb ff ff       	jmp    c0101f66 <__alltraps>

c01023ef <vector127>:
.globl vector127
vector127:
  pushl $0
c01023ef:	6a 00                	push   $0x0
  pushl $127
c01023f1:	6a 7f                	push   $0x7f
  jmp __alltraps
c01023f3:	e9 6e fb ff ff       	jmp    c0101f66 <__alltraps>

c01023f8 <vector128>:
.globl vector128
vector128:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $128
c01023fa:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01023ff:	e9 62 fb ff ff       	jmp    c0101f66 <__alltraps>

c0102404 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $129
c0102406:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010240b:	e9 56 fb ff ff       	jmp    c0101f66 <__alltraps>

c0102410 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $130
c0102412:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102417:	e9 4a fb ff ff       	jmp    c0101f66 <__alltraps>

c010241c <vector131>:
.globl vector131
vector131:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $131
c010241e:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102423:	e9 3e fb ff ff       	jmp    c0101f66 <__alltraps>

c0102428 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $132
c010242a:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010242f:	e9 32 fb ff ff       	jmp    c0101f66 <__alltraps>

c0102434 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $133
c0102436:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010243b:	e9 26 fb ff ff       	jmp    c0101f66 <__alltraps>

c0102440 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $134
c0102442:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102447:	e9 1a fb ff ff       	jmp    c0101f66 <__alltraps>

c010244c <vector135>:
.globl vector135
vector135:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $135
c010244e:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102453:	e9 0e fb ff ff       	jmp    c0101f66 <__alltraps>

c0102458 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $136
c010245a:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010245f:	e9 02 fb ff ff       	jmp    c0101f66 <__alltraps>

c0102464 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $137
c0102466:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010246b:	e9 f6 fa ff ff       	jmp    c0101f66 <__alltraps>

c0102470 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $138
c0102472:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102477:	e9 ea fa ff ff       	jmp    c0101f66 <__alltraps>

c010247c <vector139>:
.globl vector139
vector139:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $139
c010247e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102483:	e9 de fa ff ff       	jmp    c0101f66 <__alltraps>

c0102488 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $140
c010248a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010248f:	e9 d2 fa ff ff       	jmp    c0101f66 <__alltraps>

c0102494 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $141
c0102496:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010249b:	e9 c6 fa ff ff       	jmp    c0101f66 <__alltraps>

c01024a0 <vector142>:
.globl vector142
vector142:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $142
c01024a2:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024a7:	e9 ba fa ff ff       	jmp    c0101f66 <__alltraps>

c01024ac <vector143>:
.globl vector143
vector143:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $143
c01024ae:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01024b3:	e9 ae fa ff ff       	jmp    c0101f66 <__alltraps>

c01024b8 <vector144>:
.globl vector144
vector144:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $144
c01024ba:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024bf:	e9 a2 fa ff ff       	jmp    c0101f66 <__alltraps>

c01024c4 <vector145>:
.globl vector145
vector145:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $145
c01024c6:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01024cb:	e9 96 fa ff ff       	jmp    c0101f66 <__alltraps>

c01024d0 <vector146>:
.globl vector146
vector146:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $146
c01024d2:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01024d7:	e9 8a fa ff ff       	jmp    c0101f66 <__alltraps>

c01024dc <vector147>:
.globl vector147
vector147:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $147
c01024de:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01024e3:	e9 7e fa ff ff       	jmp    c0101f66 <__alltraps>

c01024e8 <vector148>:
.globl vector148
vector148:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $148
c01024ea:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01024ef:	e9 72 fa ff ff       	jmp    c0101f66 <__alltraps>

c01024f4 <vector149>:
.globl vector149
vector149:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $149
c01024f6:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01024fb:	e9 66 fa ff ff       	jmp    c0101f66 <__alltraps>

c0102500 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $150
c0102502:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102507:	e9 5a fa ff ff       	jmp    c0101f66 <__alltraps>

c010250c <vector151>:
.globl vector151
vector151:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $151
c010250e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102513:	e9 4e fa ff ff       	jmp    c0101f66 <__alltraps>

c0102518 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $152
c010251a:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010251f:	e9 42 fa ff ff       	jmp    c0101f66 <__alltraps>

c0102524 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $153
c0102526:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010252b:	e9 36 fa ff ff       	jmp    c0101f66 <__alltraps>

c0102530 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $154
c0102532:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102537:	e9 2a fa ff ff       	jmp    c0101f66 <__alltraps>

c010253c <vector155>:
.globl vector155
vector155:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $155
c010253e:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102543:	e9 1e fa ff ff       	jmp    c0101f66 <__alltraps>

c0102548 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $156
c010254a:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010254f:	e9 12 fa ff ff       	jmp    c0101f66 <__alltraps>

c0102554 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $157
c0102556:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010255b:	e9 06 fa ff ff       	jmp    c0101f66 <__alltraps>

c0102560 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $158
c0102562:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102567:	e9 fa f9 ff ff       	jmp    c0101f66 <__alltraps>

c010256c <vector159>:
.globl vector159
vector159:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $159
c010256e:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102573:	e9 ee f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102578 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $160
c010257a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010257f:	e9 e2 f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102584 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $161
c0102586:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010258b:	e9 d6 f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102590 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $162
c0102592:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102597:	e9 ca f9 ff ff       	jmp    c0101f66 <__alltraps>

c010259c <vector163>:
.globl vector163
vector163:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $163
c010259e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025a3:	e9 be f9 ff ff       	jmp    c0101f66 <__alltraps>

c01025a8 <vector164>:
.globl vector164
vector164:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $164
c01025aa:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01025af:	e9 b2 f9 ff ff       	jmp    c0101f66 <__alltraps>

c01025b4 <vector165>:
.globl vector165
vector165:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $165
c01025b6:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01025bb:	e9 a6 f9 ff ff       	jmp    c0101f66 <__alltraps>

c01025c0 <vector166>:
.globl vector166
vector166:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $166
c01025c2:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01025c7:	e9 9a f9 ff ff       	jmp    c0101f66 <__alltraps>

c01025cc <vector167>:
.globl vector167
vector167:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $167
c01025ce:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01025d3:	e9 8e f9 ff ff       	jmp    c0101f66 <__alltraps>

c01025d8 <vector168>:
.globl vector168
vector168:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $168
c01025da:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01025df:	e9 82 f9 ff ff       	jmp    c0101f66 <__alltraps>

c01025e4 <vector169>:
.globl vector169
vector169:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $169
c01025e6:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01025eb:	e9 76 f9 ff ff       	jmp    c0101f66 <__alltraps>

c01025f0 <vector170>:
.globl vector170
vector170:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $170
c01025f2:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01025f7:	e9 6a f9 ff ff       	jmp    c0101f66 <__alltraps>

c01025fc <vector171>:
.globl vector171
vector171:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $171
c01025fe:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102603:	e9 5e f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102608 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $172
c010260a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010260f:	e9 52 f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102614 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $173
c0102616:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010261b:	e9 46 f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102620 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $174
c0102622:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102627:	e9 3a f9 ff ff       	jmp    c0101f66 <__alltraps>

c010262c <vector175>:
.globl vector175
vector175:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $175
c010262e:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102633:	e9 2e f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102638 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $176
c010263a:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010263f:	e9 22 f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102644 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $177
c0102646:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010264b:	e9 16 f9 ff ff       	jmp    c0101f66 <__alltraps>

c0102650 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $178
c0102652:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102657:	e9 0a f9 ff ff       	jmp    c0101f66 <__alltraps>

c010265c <vector179>:
.globl vector179
vector179:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $179
c010265e:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102663:	e9 fe f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102668 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $180
c010266a:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010266f:	e9 f2 f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102674 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $181
c0102676:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010267b:	e9 e6 f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102680 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $182
c0102682:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102687:	e9 da f8 ff ff       	jmp    c0101f66 <__alltraps>

c010268c <vector183>:
.globl vector183
vector183:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $183
c010268e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102693:	e9 ce f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102698 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $184
c010269a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010269f:	e9 c2 f8 ff ff       	jmp    c0101f66 <__alltraps>

c01026a4 <vector185>:
.globl vector185
vector185:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $185
c01026a6:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01026ab:	e9 b6 f8 ff ff       	jmp    c0101f66 <__alltraps>

c01026b0 <vector186>:
.globl vector186
vector186:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $186
c01026b2:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01026b7:	e9 aa f8 ff ff       	jmp    c0101f66 <__alltraps>

c01026bc <vector187>:
.globl vector187
vector187:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $187
c01026be:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026c3:	e9 9e f8 ff ff       	jmp    c0101f66 <__alltraps>

c01026c8 <vector188>:
.globl vector188
vector188:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $188
c01026ca:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01026cf:	e9 92 f8 ff ff       	jmp    c0101f66 <__alltraps>

c01026d4 <vector189>:
.globl vector189
vector189:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $189
c01026d6:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01026db:	e9 86 f8 ff ff       	jmp    c0101f66 <__alltraps>

c01026e0 <vector190>:
.globl vector190
vector190:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $190
c01026e2:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01026e7:	e9 7a f8 ff ff       	jmp    c0101f66 <__alltraps>

c01026ec <vector191>:
.globl vector191
vector191:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $191
c01026ee:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01026f3:	e9 6e f8 ff ff       	jmp    c0101f66 <__alltraps>

c01026f8 <vector192>:
.globl vector192
vector192:
  pushl $0
c01026f8:	6a 00                	push   $0x0
  pushl $192
c01026fa:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01026ff:	e9 62 f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102704 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $193
c0102706:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010270b:	e9 56 f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102710 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $194
c0102712:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102717:	e9 4a f8 ff ff       	jmp    c0101f66 <__alltraps>

c010271c <vector195>:
.globl vector195
vector195:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $195
c010271e:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102723:	e9 3e f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102728 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $196
c010272a:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010272f:	e9 32 f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102734 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $197
c0102736:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010273b:	e9 26 f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102740 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102740:	6a 00                	push   $0x0
  pushl $198
c0102742:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102747:	e9 1a f8 ff ff       	jmp    c0101f66 <__alltraps>

c010274c <vector199>:
.globl vector199
vector199:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $199
c010274e:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102753:	e9 0e f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102758 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $200
c010275a:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010275f:	e9 02 f8 ff ff       	jmp    c0101f66 <__alltraps>

c0102764 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102764:	6a 00                	push   $0x0
  pushl $201
c0102766:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010276b:	e9 f6 f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102770 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $202
c0102772:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102777:	e9 ea f7 ff ff       	jmp    c0101f66 <__alltraps>

c010277c <vector203>:
.globl vector203
vector203:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $203
c010277e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102783:	e9 de f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102788 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102788:	6a 00                	push   $0x0
  pushl $204
c010278a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010278f:	e9 d2 f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102794 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $205
c0102796:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010279b:	e9 c6 f7 ff ff       	jmp    c0101f66 <__alltraps>

c01027a0 <vector206>:
.globl vector206
vector206:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $206
c01027a2:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027a7:	e9 ba f7 ff ff       	jmp    c0101f66 <__alltraps>

c01027ac <vector207>:
.globl vector207
vector207:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $207
c01027ae:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01027b3:	e9 ae f7 ff ff       	jmp    c0101f66 <__alltraps>

c01027b8 <vector208>:
.globl vector208
vector208:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $208
c01027ba:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027bf:	e9 a2 f7 ff ff       	jmp    c0101f66 <__alltraps>

c01027c4 <vector209>:
.globl vector209
vector209:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $209
c01027c6:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01027cb:	e9 96 f7 ff ff       	jmp    c0101f66 <__alltraps>

c01027d0 <vector210>:
.globl vector210
vector210:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $210
c01027d2:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01027d7:	e9 8a f7 ff ff       	jmp    c0101f66 <__alltraps>

c01027dc <vector211>:
.globl vector211
vector211:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $211
c01027de:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01027e3:	e9 7e f7 ff ff       	jmp    c0101f66 <__alltraps>

c01027e8 <vector212>:
.globl vector212
vector212:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $212
c01027ea:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01027ef:	e9 72 f7 ff ff       	jmp    c0101f66 <__alltraps>

c01027f4 <vector213>:
.globl vector213
vector213:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $213
c01027f6:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01027fb:	e9 66 f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102800 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $214
c0102802:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102807:	e9 5a f7 ff ff       	jmp    c0101f66 <__alltraps>

c010280c <vector215>:
.globl vector215
vector215:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $215
c010280e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102813:	e9 4e f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102818 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $216
c010281a:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010281f:	e9 42 f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102824 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102824:	6a 00                	push   $0x0
  pushl $217
c0102826:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010282b:	e9 36 f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102830 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $218
c0102832:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102837:	e9 2a f7 ff ff       	jmp    c0101f66 <__alltraps>

c010283c <vector219>:
.globl vector219
vector219:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $219
c010283e:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102843:	e9 1e f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102848 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102848:	6a 00                	push   $0x0
  pushl $220
c010284a:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010284f:	e9 12 f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102854 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $221
c0102856:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010285b:	e9 06 f7 ff ff       	jmp    c0101f66 <__alltraps>

c0102860 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102860:	6a 00                	push   $0x0
  pushl $222
c0102862:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102867:	e9 fa f6 ff ff       	jmp    c0101f66 <__alltraps>

c010286c <vector223>:
.globl vector223
vector223:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $223
c010286e:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102873:	e9 ee f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102878 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102878:	6a 00                	push   $0x0
  pushl $224
c010287a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010287f:	e9 e2 f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102884 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102884:	6a 00                	push   $0x0
  pushl $225
c0102886:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010288b:	e9 d6 f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102890 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $226
c0102892:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102897:	e9 ca f6 ff ff       	jmp    c0101f66 <__alltraps>

c010289c <vector227>:
.globl vector227
vector227:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $227
c010289e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028a3:	e9 be f6 ff ff       	jmp    c0101f66 <__alltraps>

c01028a8 <vector228>:
.globl vector228
vector228:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $228
c01028aa:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01028af:	e9 b2 f6 ff ff       	jmp    c0101f66 <__alltraps>

c01028b4 <vector229>:
.globl vector229
vector229:
  pushl $0
c01028b4:	6a 00                	push   $0x0
  pushl $229
c01028b6:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01028bb:	e9 a6 f6 ff ff       	jmp    c0101f66 <__alltraps>

c01028c0 <vector230>:
.globl vector230
vector230:
  pushl $0
c01028c0:	6a 00                	push   $0x0
  pushl $230
c01028c2:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01028c7:	e9 9a f6 ff ff       	jmp    c0101f66 <__alltraps>

c01028cc <vector231>:
.globl vector231
vector231:
  pushl $0
c01028cc:	6a 00                	push   $0x0
  pushl $231
c01028ce:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01028d3:	e9 8e f6 ff ff       	jmp    c0101f66 <__alltraps>

c01028d8 <vector232>:
.globl vector232
vector232:
  pushl $0
c01028d8:	6a 00                	push   $0x0
  pushl $232
c01028da:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01028df:	e9 82 f6 ff ff       	jmp    c0101f66 <__alltraps>

c01028e4 <vector233>:
.globl vector233
vector233:
  pushl $0
c01028e4:	6a 00                	push   $0x0
  pushl $233
c01028e6:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01028eb:	e9 76 f6 ff ff       	jmp    c0101f66 <__alltraps>

c01028f0 <vector234>:
.globl vector234
vector234:
  pushl $0
c01028f0:	6a 00                	push   $0x0
  pushl $234
c01028f2:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01028f7:	e9 6a f6 ff ff       	jmp    c0101f66 <__alltraps>

c01028fc <vector235>:
.globl vector235
vector235:
  pushl $0
c01028fc:	6a 00                	push   $0x0
  pushl $235
c01028fe:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102903:	e9 5e f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102908 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102908:	6a 00                	push   $0x0
  pushl $236
c010290a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010290f:	e9 52 f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102914 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102914:	6a 00                	push   $0x0
  pushl $237
c0102916:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010291b:	e9 46 f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102920 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102920:	6a 00                	push   $0x0
  pushl $238
c0102922:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102927:	e9 3a f6 ff ff       	jmp    c0101f66 <__alltraps>

c010292c <vector239>:
.globl vector239
vector239:
  pushl $0
c010292c:	6a 00                	push   $0x0
  pushl $239
c010292e:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102933:	e9 2e f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102938 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102938:	6a 00                	push   $0x0
  pushl $240
c010293a:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010293f:	e9 22 f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102944 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102944:	6a 00                	push   $0x0
  pushl $241
c0102946:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010294b:	e9 16 f6 ff ff       	jmp    c0101f66 <__alltraps>

c0102950 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102950:	6a 00                	push   $0x0
  pushl $242
c0102952:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102957:	e9 0a f6 ff ff       	jmp    c0101f66 <__alltraps>

c010295c <vector243>:
.globl vector243
vector243:
  pushl $0
c010295c:	6a 00                	push   $0x0
  pushl $243
c010295e:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102963:	e9 fe f5 ff ff       	jmp    c0101f66 <__alltraps>

c0102968 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102968:	6a 00                	push   $0x0
  pushl $244
c010296a:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010296f:	e9 f2 f5 ff ff       	jmp    c0101f66 <__alltraps>

c0102974 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102974:	6a 00                	push   $0x0
  pushl $245
c0102976:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010297b:	e9 e6 f5 ff ff       	jmp    c0101f66 <__alltraps>

c0102980 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102980:	6a 00                	push   $0x0
  pushl $246
c0102982:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102987:	e9 da f5 ff ff       	jmp    c0101f66 <__alltraps>

c010298c <vector247>:
.globl vector247
vector247:
  pushl $0
c010298c:	6a 00                	push   $0x0
  pushl $247
c010298e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102993:	e9 ce f5 ff ff       	jmp    c0101f66 <__alltraps>

c0102998 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102998:	6a 00                	push   $0x0
  pushl $248
c010299a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010299f:	e9 c2 f5 ff ff       	jmp    c0101f66 <__alltraps>

c01029a4 <vector249>:
.globl vector249
vector249:
  pushl $0
c01029a4:	6a 00                	push   $0x0
  pushl $249
c01029a6:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01029ab:	e9 b6 f5 ff ff       	jmp    c0101f66 <__alltraps>

c01029b0 <vector250>:
.globl vector250
vector250:
  pushl $0
c01029b0:	6a 00                	push   $0x0
  pushl $250
c01029b2:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01029b7:	e9 aa f5 ff ff       	jmp    c0101f66 <__alltraps>

c01029bc <vector251>:
.globl vector251
vector251:
  pushl $0
c01029bc:	6a 00                	push   $0x0
  pushl $251
c01029be:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029c3:	e9 9e f5 ff ff       	jmp    c0101f66 <__alltraps>

c01029c8 <vector252>:
.globl vector252
vector252:
  pushl $0
c01029c8:	6a 00                	push   $0x0
  pushl $252
c01029ca:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01029cf:	e9 92 f5 ff ff       	jmp    c0101f66 <__alltraps>

c01029d4 <vector253>:
.globl vector253
vector253:
  pushl $0
c01029d4:	6a 00                	push   $0x0
  pushl $253
c01029d6:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01029db:	e9 86 f5 ff ff       	jmp    c0101f66 <__alltraps>

c01029e0 <vector254>:
.globl vector254
vector254:
  pushl $0
c01029e0:	6a 00                	push   $0x0
  pushl $254
c01029e2:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01029e7:	e9 7a f5 ff ff       	jmp    c0101f66 <__alltraps>

c01029ec <vector255>:
.globl vector255
vector255:
  pushl $0
c01029ec:	6a 00                	push   $0x0
  pushl $255
c01029ee:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01029f3:	e9 6e f5 ff ff       	jmp    c0101f66 <__alltraps>

c01029f8 <set_page_ref>:
page_ref(struct Page *page) {
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
c01029f8:	55                   	push   %ebp
c01029f9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01029fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01029fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a01:	89 10                	mov    %edx,(%eax)
}
c0102a03:	5d                   	pop    %ebp
c0102a04:	c3                   	ret    

c0102a05 <buddy_init>:
struct Zone {
    struct Page *mem_base;
} zones[MAX_ZONE_NUM] = {{NULL}};

static void
buddy_init(void) {
c0102a05:	55                   	push   %ebp
c0102a06:	89 e5                	mov    %esp,%ebp
c0102a08:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; i <= MAX_ORDER; i ++) {
c0102a0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102a12:	eb 44                	jmp    c0102a58 <buddy_init+0x53>
        list_init(&free_list(i));
c0102a14:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a17:	89 d0                	mov    %edx,%eax
c0102a19:	01 c0                	add    %eax,%eax
c0102a1b:	01 d0                	add    %edx,%eax
c0102a1d:	c1 e0 02             	shl    $0x2,%eax
c0102a20:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102a28:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102a2b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102a2e:	89 50 04             	mov    %edx,0x4(%eax)
c0102a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102a34:	8b 50 04             	mov    0x4(%eax),%edx
c0102a37:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102a3a:	89 10                	mov    %edx,(%eax)
        nr_free(i) = 0;
c0102a3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a3f:	89 d0                	mov    %edx,%eax
c0102a41:	01 c0                	add    %eax,%eax
c0102a43:	01 d0                	add    %edx,%eax
c0102a45:	c1 e0 02             	shl    $0x2,%eax
c0102a48:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102a4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
} zones[MAX_ZONE_NUM] = {{NULL}};

static void
buddy_init(void) {
    int i;
    for (i = 0; i <= MAX_ORDER; i ++) {
c0102a54:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102a58:	83 7d fc 0a          	cmpl   $0xa,-0x4(%ebp)
c0102a5c:	7e b6                	jle    c0102a14 <buddy_init+0xf>
        list_init(&free_list(i));
        nr_free(i) = 0;
    }
}
c0102a5e:	c9                   	leave  
c0102a5f:	c3                   	ret    

c0102a60 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
c0102a60:	55                   	push   %ebp
c0102a61:	89 e5                	mov    %esp,%ebp
c0102a63:	83 ec 38             	sub    $0x38,%esp
    static int zone_num = 0;
    struct Page *p = base;
c0102a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a69:	89 45 fc             	mov    %eax,-0x4(%ebp)
    for (; p != base + n; p ++) {
c0102a6c:	eb 39                	jmp    c0102aa7 <buddy_init_memmap+0x47>
        p->flags = p->property = 0;
c0102a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102a78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a7b:	8b 50 08             	mov    0x8(%eax),%edx
c0102a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a81:	89 50 04             	mov    %edx,0x4(%eax)
        p->zone_num = zone_num;
c0102a84:	8b 15 84 b9 11 c0    	mov    0xc011b984,%edx
c0102a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a8d:	89 50 0c             	mov    %edx,0xc(%eax)
        set_page_ref(p, 0);
c0102a90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a97:	00 
c0102a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a9b:	89 04 24             	mov    %eax,(%esp)
c0102a9e:	e8 55 ff ff ff       	call   c01029f8 <set_page_ref>

static void
buddy_init_memmap(struct Page *base, size_t n) {
    static int zone_num = 0;
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102aa3:	83 45 fc 18          	addl   $0x18,-0x4(%ebp)
c0102aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aaa:	89 d0                	mov    %edx,%eax
c0102aac:	01 c0                	add    %eax,%eax
c0102aae:	01 d0                	add    %edx,%eax
c0102ab0:	c1 e0 03             	shl    $0x3,%eax
c0102ab3:	89 c2                	mov    %eax,%edx
c0102ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab8:	01 d0                	add    %edx,%eax
c0102aba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102abd:	75 af                	jne    c0102a6e <buddy_init_memmap+0xe>
        p->flags = p->property = 0;
        p->zone_num = zone_num;
        set_page_ref(p, 0);
    }
    p = zones[zone_num ++].mem_base = base;
c0102abf:	a1 84 b9 11 c0       	mov    0xc011b984,%eax
c0102ac4:	8d 50 01             	lea    0x1(%eax),%edx
c0102ac7:	89 15 84 b9 11 c0    	mov    %edx,0xc011b984
c0102acd:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ad0:	89 14 85 c0 b8 11 c0 	mov    %edx,-0x3fee4740(,%eax,4)
c0102ad7:	8b 04 85 c0 b8 11 c0 	mov    -0x3fee4740(,%eax,4),%eax
c0102ade:	89 45 fc             	mov    %eax,-0x4(%ebp)
    size_t order = MAX_ORDER, order_size = (1 << order);
c0102ae1:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%ebp)
c0102ae8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102aeb:	ba 01 00 00 00       	mov    $0x1,%edx
c0102af0:	89 c1                	mov    %eax,%ecx
c0102af2:	d3 e2                	shl    %cl,%edx
c0102af4:	89 d0                	mov    %edx,%eax
c0102af6:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // cut
    while (n != 0) {
c0102af9:	e9 dc 00 00 00       	jmp    c0102bda <buddy_init_memmap+0x17a>
        while (n >= order_size) {
c0102afe:	e9 c4 00 00 00       	jmp    c0102bc7 <buddy_init_memmap+0x167>
            p->property = order;
c0102b03:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b06:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102b09:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102b0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b0f:	83 c0 04             	add    $0x4,%eax
c0102b12:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102b19:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102b22:	0f ab 10             	bts    %edx,(%eax)
            list_add(&free_list(order), &(p->page_link));
c0102b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b28:	8d 48 10             	lea    0x10(%eax),%ecx
c0102b2b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102b2e:	89 d0                	mov    %edx,%eax
c0102b30:	01 c0                	add    %eax,%eax
c0102b32:	01 d0                	add    %edx,%eax
c0102b34:	c1 e0 02             	shl    $0x2,%eax
c0102b37:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102b3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102b3f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c0102b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b51:	8b 40 04             	mov    0x4(%eax),%eax
c0102b54:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b57:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102b5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b5d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102b60:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b63:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b66:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b69:	89 10                	mov    %edx,(%eax)
c0102b6b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b6e:	8b 10                	mov    (%eax),%edx
c0102b70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b73:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b76:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b79:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b7c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b82:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b85:	89 10                	mov    %edx,(%eax)
            n -= order_size, p += order_size;
c0102b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b8a:	29 45 0c             	sub    %eax,0xc(%ebp)
c0102b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102b90:	89 d0                	mov    %edx,%eax
c0102b92:	01 c0                	add    %eax,%eax
c0102b94:	01 d0                	add    %edx,%eax
c0102b96:	c1 e0 03             	shl    $0x3,%eax
c0102b99:	01 45 fc             	add    %eax,-0x4(%ebp)
            nr_free(order) ++;
c0102b9c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102b9f:	89 d0                	mov    %edx,%eax
c0102ba1:	01 c0                	add    %eax,%eax
c0102ba3:	01 d0                	add    %edx,%eax
c0102ba5:	c1 e0 02             	shl    $0x2,%eax
c0102ba8:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102bad:	8b 40 08             	mov    0x8(%eax),%eax
c0102bb0:	8d 48 01             	lea    0x1(%eax),%ecx
c0102bb3:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102bb6:	89 d0                	mov    %edx,%eax
c0102bb8:	01 c0                	add    %eax,%eax
c0102bba:	01 d0                	add    %edx,%eax
c0102bbc:	c1 e0 02             	shl    $0x2,%eax
c0102bbf:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102bc4:	89 48 08             	mov    %ecx,0x8(%eax)
    p = zones[zone_num ++].mem_base = base;
    size_t order = MAX_ORDER, order_size = (1 << order);

    // cut
    while (n != 0) {
        while (n >= order_size) {
c0102bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102bcd:	0f 83 30 ff ff ff    	jae    c0102b03 <buddy_init_memmap+0xa3>
            SetPageProperty(p);
            list_add(&free_list(order), &(p->page_link));
            n -= order_size, p += order_size;
            nr_free(order) ++;
        }
        order --;
c0102bd3:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
        order_size >>= 1;
c0102bd7:	d1 6d f4             	shrl   -0xc(%ebp)
    }
    p = zones[zone_num ++].mem_base = base;
    size_t order = MAX_ORDER, order_size = (1 << order);

    // cut
    while (n != 0) {
c0102bda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bde:	0f 85 1a ff ff ff    	jne    c0102afe <buddy_init_memmap+0x9e>
            nr_free(order) ++;
        }
        order --;
        order_size >>= 1;
    }
}
c0102be4:	c9                   	leave  
c0102be5:	c3                   	ret    

c0102be6 <getorder>:

static inline size_t
getorder(size_t n) {
c0102be6:	55                   	push   %ebp
c0102be7:	89 e5                	mov    %esp,%ebp
c0102be9:	83 ec 10             	sub    $0x10,%esp
    size_t order, order_size;
    for (order = 0, order_size = 1; order <= MAX_ORDER; order ++, order_size <<= 1) {
c0102bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102bf3:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
c0102bfa:	eb 14                	jmp    c0102c10 <getorder+0x2a>
        if (n <= order_size) {
c0102bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0102c02:	77 05                	ja     c0102c09 <getorder+0x23>
            return order;
c0102c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c07:	eb 0d                	jmp    c0102c16 <getorder+0x30>
}

static inline size_t
getorder(size_t n) {
    size_t order, order_size;
    for (order = 0, order_size = 1; order <= MAX_ORDER; order ++, order_size <<= 1) {
c0102c09:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102c0d:	d1 65 f8             	shll   -0x8(%ebp)
c0102c10:	83 7d fc 0a          	cmpl   $0xa,-0x4(%ebp)
c0102c14:	76 e6                	jbe    c0102bfc <getorder+0x16>
        if (n <= order_size) {
            return order;
        }
    }
}
c0102c16:	c9                   	leave  
c0102c17:	c3                   	ret    

c0102c18 <buddy_alloc_pages_sub>:

static inline struct Page *
buddy_alloc_pages_sub(size_t order) {
c0102c18:	55                   	push   %ebp
c0102c19:	89 e5                	mov    %esp,%ebp
c0102c1b:	83 ec 60             	sub    $0x60,%esp
    size_t cur_order;
    for (cur_order = order; cur_order <= MAX_ORDER; cur_order ++) {
c0102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c21:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0102c24:	e9 b4 01 00 00       	jmp    c0102ddd <buddy_alloc_pages_sub+0x1c5>
        if (!list_empty(&free_list(cur_order))) {
c0102c29:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102c2c:	89 d0                	mov    %edx,%eax
c0102c2e:	01 c0                	add    %eax,%eax
c0102c30:	01 d0                	add    %edx,%eax
c0102c32:	c1 e0 02             	shl    $0x2,%eax
c0102c35:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102c3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c40:	8b 40 04             	mov    0x4(%eax),%eax
c0102c43:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0102c46:	0f 94 c0             	sete   %al
c0102c49:	0f b6 c0             	movzbl %al,%eax
c0102c4c:	85 c0                	test   %eax,%eax
c0102c4e:	0f 85 85 01 00 00    	jne    c0102dd9 <buddy_alloc_pages_sub+0x1c1>
            list_entry_t *le = list_next(&free_list(cur_order));
c0102c54:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102c57:	89 d0                	mov    %edx,%eax
c0102c59:	01 c0                	add    %eax,%eax
c0102c5b:	01 d0                	add    %edx,%eax
c0102c5d:	c1 e0 02             	shl    $0x2,%eax
c0102c60:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102c65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c6b:	8b 40 04             	mov    0x4(%eax),%eax
c0102c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            struct Page *page = le2page(le, page_link);
c0102c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c74:	83 e8 10             	sub    $0x10,%eax
c0102c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
            nr_free(cur_order) --;
c0102c7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102c7d:	89 d0                	mov    %edx,%eax
c0102c7f:	01 c0                	add    %eax,%eax
c0102c81:	01 d0                	add    %edx,%eax
c0102c83:	c1 e0 02             	shl    $0x2,%eax
c0102c86:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102c8b:	8b 40 08             	mov    0x8(%eax),%eax
c0102c8e:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0102c91:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102c94:	89 d0                	mov    %edx,%eax
c0102c96:	01 c0                	add    %eax,%eax
c0102c98:	01 d0                	add    %edx,%eax
c0102c9a:	c1 e0 02             	shl    $0x2,%eax
c0102c9d:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102ca2:	89 48 08             	mov    %ecx,0x8(%eax)
c0102ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102cab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cae:	8b 40 04             	mov    0x4(%eax),%eax
c0102cb1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102cb4:	8b 12                	mov    (%edx),%edx
c0102cb6:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102cb9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102cbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cbf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cc2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102cc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102cc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ccb:	89 10                	mov    %edx,(%eax)
            list_del(le);
            size_t size = 1 << cur_order;
c0102ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102cd0:	ba 01 00 00 00       	mov    $0x1,%edx
c0102cd5:	89 c1                	mov    %eax,%ecx
c0102cd7:	d3 e2                	shl    %cl,%edx
c0102cd9:	89 d0                	mov    %edx,%eax
c0102cdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
            while (cur_order > order) {
c0102cde:	e9 cc 00 00 00       	jmp    c0102daf <buddy_alloc_pages_sub+0x197>
                cur_order --;
c0102ce3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
                size >>= 1;
c0102ce7:	d1 6d f8             	shrl   -0x8(%ebp)
                struct Page *buddy = page + size;//+
c0102cea:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102ced:	89 d0                	mov    %edx,%eax
c0102cef:	01 c0                	add    %eax,%eax
c0102cf1:	01 d0                	add    %edx,%eax
c0102cf3:	c1 e0 03             	shl    $0x3,%eax
c0102cf6:	89 c2                	mov    %eax,%edx
c0102cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cfb:	01 d0                	add    %edx,%eax
c0102cfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
                buddy->property = cur_order;
c0102d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d03:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102d06:	89 50 08             	mov    %edx,0x8(%eax)
                SetPageProperty(buddy);
c0102d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d0c:	83 c0 04             	add    $0x4,%eax
c0102d0f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102d16:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d1f:	0f ab 10             	bts    %edx,(%eax)
                nr_free(cur_order) ++;
c0102d22:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102d25:	89 d0                	mov    %edx,%eax
c0102d27:	01 c0                	add    %eax,%eax
c0102d29:	01 d0                	add    %edx,%eax
c0102d2b:	c1 e0 02             	shl    $0x2,%eax
c0102d2e:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102d33:	8b 40 08             	mov    0x8(%eax),%eax
c0102d36:	8d 48 01             	lea    0x1(%eax),%ecx
c0102d39:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102d3c:	89 d0                	mov    %edx,%eax
c0102d3e:	01 c0                	add    %eax,%eax
c0102d40:	01 d0                	add    %edx,%eax
c0102d42:	c1 e0 02             	shl    $0x2,%eax
c0102d45:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102d4a:	89 48 08             	mov    %ecx,0x8(%eax)
                list_add(&free_list(cur_order), &(buddy->page_link));
c0102d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d50:	8d 48 10             	lea    0x10(%eax),%ecx
c0102d53:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102d56:	89 d0                	mov    %edx,%eax
c0102d58:	01 c0                	add    %eax,%eax
c0102d5a:	01 d0                	add    %edx,%eax
c0102d5c:	c1 e0 02             	shl    $0x2,%eax
c0102d5f:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102d64:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102d67:	89 4d c8             	mov    %ecx,-0x38(%ebp)
c0102d6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d6d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0102d70:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d73:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102d76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d79:	8b 40 04             	mov    0x4(%eax),%eax
c0102d7c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d7f:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102d82:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d85:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d88:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102d8b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d8e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d91:	89 10                	mov    %edx,(%eax)
c0102d93:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d96:	8b 10                	mov    (%eax),%edx
c0102d98:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d9b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102d9e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102da1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102da4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102da7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102daa:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102dad:	89 10                	mov    %edx,(%eax)
            list_entry_t *le = list_next(&free_list(cur_order));
            struct Page *page = le2page(le, page_link);
            nr_free(cur_order) --;
            list_del(le);
            size_t size = 1 << cur_order;
            while (cur_order > order) {
c0102daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102db2:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102db5:	0f 87 28 ff ff ff    	ja     c0102ce3 <buddy_alloc_pages_sub+0xcb>
                buddy->property = cur_order;
                SetPageProperty(buddy);
                nr_free(cur_order) ++;
                list_add(&free_list(cur_order), &(buddy->page_link));
            }
            ClearPageProperty(page);
c0102dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dbe:	83 c0 04             	add    $0x4,%eax
c0102dc1:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102dc8:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dcb:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102dce:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102dd1:	0f b3 10             	btr    %edx,(%eax)
            return page;
c0102dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dd7:	eb 13                	jmp    c0102dec <buddy_alloc_pages_sub+0x1d4>
}

static inline struct Page *
buddy_alloc_pages_sub(size_t order) {
    size_t cur_order;
    for (cur_order = order; cur_order <= MAX_ORDER; cur_order ++) {
c0102dd9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102ddd:	83 7d fc 0a          	cmpl   $0xa,-0x4(%ebp)
c0102de1:	0f 86 42 fe ff ff    	jbe    c0102c29 <buddy_alloc_pages_sub+0x11>
            }
            ClearPageProperty(page);
            return page;
        }
    }
    return NULL;
c0102de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102dec:	c9                   	leave  
c0102ded:	c3                   	ret    

c0102dee <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
c0102dee:	55                   	push   %ebp
c0102def:	89 e5                	mov    %esp,%ebp
c0102df1:	83 ec 28             	sub    $0x28,%esp
    size_t order = getorder(n), order_size = (1 << order);
c0102df4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102df7:	89 04 24             	mov    %eax,(%esp)
c0102dfa:	e8 e7 fd ff ff       	call   c0102be6 <getorder>
c0102dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e05:	ba 01 00 00 00       	mov    $0x1,%edx
c0102e0a:	89 c1                	mov    %eax,%ecx
c0102e0c:	d3 e2                	shl    %cl,%edx
c0102e0e:	89 d0                	mov    %edx,%eax
c0102e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *page = buddy_alloc_pages_sub(order);
c0102e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e16:	89 04 24             	mov    %eax,(%esp)
c0102e19:	e8 fa fd ff ff       	call   c0102c18 <buddy_alloc_pages_sub>
c0102e1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //economic
    if (page != NULL && n != order_size) {
c0102e21:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e25:	74 31                	je     c0102e58 <buddy_alloc_pages+0x6a>
c0102e27:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e2a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e2d:	74 29                	je     c0102e58 <buddy_alloc_pages+0x6a>
        free_pages(page + n, order_size - n);
c0102e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e32:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102e35:	89 d1                	mov    %edx,%ecx
c0102e37:	29 c1                	sub    %eax,%ecx
c0102e39:	8b 55 08             	mov    0x8(%ebp),%edx
c0102e3c:	89 d0                	mov    %edx,%eax
c0102e3e:	01 c0                	add    %eax,%eax
c0102e40:	01 d0                	add    %edx,%eax
c0102e42:	c1 e0 03             	shl    $0x3,%eax
c0102e45:	89 c2                	mov    %eax,%edx
c0102e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e4a:	01 d0                	add    %edx,%eax
c0102e4c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102e50:	89 04 24             	mov    %eax,(%esp)
c0102e53:	e8 04 23 00 00       	call   c010515c <free_pages>
    }
    return page;
c0102e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
c0102e5b:	c9                   	leave  
c0102e5c:	c3                   	ret    

c0102e5d <page_is_buddy>:

//page_is_buddy - Does this page belong to the No. zone_num Zone & this page
//              -  be in the continuous page block whose size is 2^order pages?
static inline bool
page_is_buddy(struct Page *page, size_t order, int zone_num) {
c0102e5d:	55                   	push   %ebp
c0102e5e:	89 e5                	mov    %esp,%ebp
c0102e60:	83 ec 20             	sub    $0x20,%esp
        if (page->zone_num == zone_num) {
c0102e63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e66:	8b 40 0c             	mov    0xc(%eax),%eax
c0102e69:	3b 45 10             	cmp    0x10(%ebp),%eax
c0102e6c:	75 71                	jne    c0102edf <page_is_buddy+0x82>
            return !PageReserved(page) && PageProperty(page) && page->property == order;
c0102e6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e71:	83 c0 04             	add    $0x4,%eax
c0102e74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102e7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102e81:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102e84:	0f a3 10             	bt     %edx,(%eax)
c0102e87:	19 c0                	sbb    %eax,%eax
c0102e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return oldbit != 0;
c0102e8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102e90:	0f 95 c0             	setne  %al
c0102e93:	0f b6 c0             	movzbl %al,%eax
c0102e96:	85 c0                	test   %eax,%eax
c0102e98:	75 3e                	jne    c0102ed8 <page_is_buddy+0x7b>
c0102e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e9d:	83 c0 04             	add    $0x4,%eax
c0102ea0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102ea7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102eb0:	0f a3 10             	bt     %edx,(%eax)
c0102eb3:	19 c0                	sbb    %eax,%eax
c0102eb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102eb8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102ebc:	0f 95 c0             	setne  %al
c0102ebf:	0f b6 c0             	movzbl %al,%eax
c0102ec2:	85 c0                	test   %eax,%eax
c0102ec4:	74 12                	je     c0102ed8 <page_is_buddy+0x7b>
c0102ec6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ec9:	8b 40 08             	mov    0x8(%eax),%eax
c0102ecc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0102ecf:	75 07                	jne    c0102ed8 <page_is_buddy+0x7b>
c0102ed1:	b8 01 00 00 00       	mov    $0x1,%eax
c0102ed6:	eb 05                	jmp    c0102edd <page_is_buddy+0x80>
c0102ed8:	b8 00 00 00 00       	mov    $0x0,%eax
c0102edd:	eb 05                	jmp    c0102ee4 <page_is_buddy+0x87>
        }
    return 0;
c0102edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102ee4:	c9                   	leave  
c0102ee5:	c3                   	ret    

c0102ee6 <page2idx>:

static inline ppn_t
page2idx(struct Page *page) {
c0102ee6:	55                   	push   %ebp
c0102ee7:	89 e5                	mov    %esp,%ebp
    return page - zones[page->zone_num].mem_base;
c0102ee9:	8b 55 08             	mov    0x8(%ebp),%edx
c0102eec:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eef:	8b 40 0c             	mov    0xc(%eax),%eax
c0102ef2:	8b 04 85 c0 b8 11 c0 	mov    -0x3fee4740(,%eax,4),%eax
c0102ef9:	29 c2                	sub    %eax,%edx
c0102efb:	89 d0                	mov    %edx,%eax
c0102efd:	c1 f8 03             	sar    $0x3,%eax
c0102f00:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
c0102f06:	5d                   	pop    %ebp
c0102f07:	c3                   	ret    

c0102f08 <idx2page>:

static inline struct Page *
idx2page(int zone_num, ppn_t idx) {
c0102f08:	55                   	push   %ebp
c0102f09:	89 e5                	mov    %esp,%ebp
    return zones[zone_num].mem_base + idx;
c0102f0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f0e:	8b 0c 85 c0 b8 11 c0 	mov    -0x3fee4740(,%eax,4),%ecx
c0102f15:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f18:	89 d0                	mov    %edx,%eax
c0102f1a:	01 c0                	add    %eax,%eax
c0102f1c:	01 d0                	add    %edx,%eax
c0102f1e:	c1 e0 03             	shl    $0x3,%eax
c0102f21:	01 c8                	add    %ecx,%eax
}
c0102f23:	5d                   	pop    %ebp
c0102f24:	c3                   	ret    

c0102f25 <buddy_free_pages_sub>:


static void
buddy_free_pages_sub(struct Page *base, size_t order) {
c0102f25:	55                   	push   %ebp
c0102f26:	89 e5                	mov    %esp,%ebp
c0102f28:	83 ec 5c             	sub    $0x5c,%esp
    ppn_t buddy_idx, page_idx = page2idx(base);
c0102f2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f2e:	89 04 24             	mov    %eax,(%esp)
c0102f31:	e8 b0 ff ff ff       	call   c0102ee6 <page2idx>
c0102f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct Page *p = base;
c0102f39:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for (; p != base + (1 << order); p ++) {
c0102f3f:	eb 21                	jmp    c0102f62 <buddy_free_pages_sub+0x3d>
        p->flags = 0;
c0102f41:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102f4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102f52:	00 
c0102f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102f56:	89 04 24             	mov    %eax,(%esp)
c0102f59:	e8 9a fa ff ff       	call   c01029f8 <set_page_ref>

static void
buddy_free_pages_sub(struct Page *base, size_t order) {
    ppn_t buddy_idx, page_idx = page2idx(base);
    struct Page *p = base;
    for (; p != base + (1 << order); p ++) {
c0102f5e:	83 45 f8 18          	addl   $0x18,-0x8(%ebp)
c0102f62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f65:	ba 18 00 00 00       	mov    $0x18,%edx
c0102f6a:	89 c1                	mov    %eax,%ecx
c0102f6c:	d3 e2                	shl    %cl,%edx
c0102f6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f71:	01 d0                	add    %edx,%eax
c0102f73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0102f76:	75 c9                	jne    c0102f41 <buddy_free_pages_sub+0x1c>
        p->flags = 0;
        set_page_ref(p, 0);
    }
    int zone_num = base->zone_num;
c0102f78:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f7b:	8b 40 0c             	mov    0xc(%eax),%eax
c0102f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (order < MAX_ORDER) {
c0102f81:	e9 c4 00 00 00       	jmp    c010304a <buddy_free_pages_sub+0x125>
    	//amazing
        buddy_idx = page_idx ^ (1 << order);
c0102f86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f89:	ba 01 00 00 00       	mov    $0x1,%edx
c0102f8e:	89 c1                	mov    %eax,%ecx
c0102f90:	d3 e2                	shl    %cl,%edx
c0102f92:	89 d0                	mov    %edx,%eax
c0102f94:	33 45 fc             	xor    -0x4(%ebp),%eax
c0102f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
        struct Page *buddy = idx2page(zone_num, buddy_idx);
c0102f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fa4:	89 04 24             	mov    %eax,(%esp)
c0102fa7:	e8 5c ff ff ff       	call   c0102f08 <idx2page>
c0102fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (!page_is_buddy(buddy, order, zone_num)) {
c0102faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fb2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fc0:	89 04 24             	mov    %eax,(%esp)
c0102fc3:	e8 95 fe ff ff       	call   c0102e5d <page_is_buddy>
c0102fc8:	85 c0                	test   %eax,%eax
c0102fca:	75 05                	jne    c0102fd1 <buddy_free_pages_sub+0xac>
            break;
c0102fcc:	e9 83 00 00 00       	jmp    c0103054 <buddy_free_pages_sub+0x12f>
        }
        nr_free(order) --;
c0102fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102fd4:	89 d0                	mov    %edx,%eax
c0102fd6:	01 c0                	add    %eax,%eax
c0102fd8:	01 d0                	add    %edx,%eax
c0102fda:	c1 e0 02             	shl    $0x2,%eax
c0102fdd:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102fe2:	8b 40 08             	mov    0x8(%eax),%eax
c0102fe5:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0102fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102feb:	89 d0                	mov    %edx,%eax
c0102fed:	01 c0                	add    %eax,%eax
c0102fef:	01 d0                	add    %edx,%eax
c0102ff1:	c1 e0 02             	shl    $0x2,%eax
c0102ff4:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0102ff9:	89 48 08             	mov    %ecx,0x8(%eax)
        list_del(&(buddy->page_link));
c0102ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fff:	83 c0 10             	add    $0x10,%eax
c0103002:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103008:	8b 40 04             	mov    0x4(%eax),%eax
c010300b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010300e:	8b 12                	mov    (%edx),%edx
c0103010:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0103013:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103016:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103019:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010301c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010301f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103022:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103025:	89 10                	mov    %edx,(%eax)
        ClearPageProperty(buddy);
c0103027:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010302a:	83 c0 04             	add    $0x4,%eax
c010302d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0103034:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103037:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010303a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010303d:	0f b3 10             	btr    %edx,(%eax)
        page_idx &= buddy_idx;
c0103040:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103043:	21 45 fc             	and    %eax,-0x4(%ebp)
        order ++;
c0103046:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    for (; p != base + (1 << order); p ++) {
        p->flags = 0;
        set_page_ref(p, 0);
    }
    int zone_num = base->zone_num;
    while (order < MAX_ORDER) {
c010304a:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
c010304e:	0f 86 32 ff ff ff    	jbe    c0102f86 <buddy_free_pages_sub+0x61>
        list_del(&(buddy->page_link));
        ClearPageProperty(buddy);
        page_idx &= buddy_idx;
        order ++;
    }
    struct Page *page = idx2page(zone_num, page_idx);
c0103054:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103057:	89 44 24 04          	mov    %eax,0x4(%esp)
c010305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010305e:	89 04 24             	mov    %eax,(%esp)
c0103061:	e8 a2 fe ff ff       	call   c0102f08 <idx2page>
c0103066:	89 45 e8             	mov    %eax,-0x18(%ebp)
    page->property = order;
c0103069:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010306c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010306f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(page);
c0103072:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103075:	83 c0 04             	add    $0x4,%eax
c0103078:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010307f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103082:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103085:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103088:	0f ab 10             	bts    %edx,(%eax)
    nr_free(order) ++;
c010308b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010308e:	89 d0                	mov    %edx,%eax
c0103090:	01 c0                	add    %eax,%eax
c0103092:	01 d0                	add    %edx,%eax
c0103094:	c1 e0 02             	shl    $0x2,%eax
c0103097:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c010309c:	8b 40 08             	mov    0x8(%eax),%eax
c010309f:	8d 48 01             	lea    0x1(%eax),%ecx
c01030a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01030a5:	89 d0                	mov    %edx,%eax
c01030a7:	01 c0                	add    %eax,%eax
c01030a9:	01 d0                	add    %edx,%eax
c01030ab:	c1 e0 02             	shl    $0x2,%eax
c01030ae:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c01030b3:	89 48 08             	mov    %ecx,0x8(%eax)
    list_add(&free_list(order), &(page->page_link));
c01030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030b9:	8d 48 10             	lea    0x10(%eax),%ecx
c01030bc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01030bf:	89 d0                	mov    %edx,%eax
c01030c1:	01 c0                	add    %eax,%eax
c01030c3:	01 d0                	add    %edx,%eax
c01030c5:	c1 e0 02             	shl    $0x2,%eax
c01030c8:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c01030cd:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01030d0:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
c01030d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030d6:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01030d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01030dc:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01030df:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01030e2:	8b 40 04             	mov    0x4(%eax),%eax
c01030e5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01030e8:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01030eb:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01030ee:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c01030f1:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01030f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01030f7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01030fa:	89 10                	mov    %edx,(%eax)
c01030fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01030ff:	8b 10                	mov    (%eax),%edx
c0103101:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103104:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103107:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010310a:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010310d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103110:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103113:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103116:	89 10                	mov    %edx,(%eax)
}
c0103118:	c9                   	leave  
c0103119:	c3                   	ret    

c010311a <buddy_free_pages>:

//根据分配模块的调用，释放模块释放的大小不一定是2的幂的大小
static void
buddy_free_pages(struct Page *base, size_t n) {
c010311a:	55                   	push   %ebp
c010311b:	89 e5                	mov    %esp,%ebp
c010311d:	83 ec 18             	sub    $0x18,%esp
    if (n == 1) {
c0103120:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0103124:	75 18                	jne    c010313e <buddy_free_pages+0x24>
        buddy_free_pages_sub(base, 0);
c0103126:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010312d:	00 
c010312e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103131:	89 04 24             	mov    %eax,(%esp)
c0103134:	e8 ec fd ff ff       	call   c0102f25 <buddy_free_pages_sub>
c0103139:	e9 98 00 00 00       	jmp    c01031d6 <buddy_free_pages+0xbc>
    }
    else {
        size_t order = 0, order_size = 1;
c010313e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103145:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
        while (n >= order_size) {
c010314c:	eb 40                	jmp    c010318e <buddy_free_pages+0x74>
            if ((page2idx(base) & order_size) != 0) {
c010314e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103151:	89 04 24             	mov    %eax,(%esp)
c0103154:	e8 8d fd ff ff       	call   c0102ee6 <page2idx>
c0103159:	23 45 f8             	and    -0x8(%ebp),%eax
c010315c:	85 c0                	test   %eax,%eax
c010315e:	74 27                	je     c0103187 <buddy_free_pages+0x6d>
                buddy_free_pages_sub(base, order);
c0103160:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103167:	8b 45 08             	mov    0x8(%ebp),%eax
c010316a:	89 04 24             	mov    %eax,(%esp)
c010316d:	e8 b3 fd ff ff       	call   c0102f25 <buddy_free_pages_sub>
                base += order_size;
c0103172:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0103175:	89 d0                	mov    %edx,%eax
c0103177:	01 c0                	add    %eax,%eax
c0103179:	01 d0                	add    %edx,%eax
c010317b:	c1 e0 03             	shl    $0x3,%eax
c010317e:	01 45 08             	add    %eax,0x8(%ebp)
                n -= order_size;
c0103181:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103184:	29 45 0c             	sub    %eax,0xc(%ebp)
            }
            order ++;
c0103187:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
            order_size <<= 1;
c010318b:	d1 65 f8             	shll   -0x8(%ebp)
    if (n == 1) {
        buddy_free_pages_sub(base, 0);
    }
    else {
        size_t order = 0, order_size = 1;
        while (n >= order_size) {
c010318e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103191:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0103194:	73 b8                	jae    c010314e <buddy_free_pages+0x34>
                n -= order_size;
            }
            order ++;
            order_size <<= 1;
        }
        while (n != 0) {
c0103196:	eb 38                	jmp    c01031d0 <buddy_free_pages+0xb6>
            while (n < order_size) {
c0103198:	eb 07                	jmp    c01031a1 <buddy_free_pages+0x87>
                order --;
c010319a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
                order_size >>= 1;
c010319e:	d1 6d f8             	shrl   -0x8(%ebp)
            }
            order ++;
            order_size <<= 1;
        }
        while (n != 0) {
            while (n < order_size) {
c01031a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01031a7:	72 f1                	jb     c010319a <buddy_free_pages+0x80>
                order --;
                order_size >>= 1;
            }
            buddy_free_pages_sub(base, order);
c01031a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01031b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01031b3:	89 04 24             	mov    %eax,(%esp)
c01031b6:	e8 6a fd ff ff       	call   c0102f25 <buddy_free_pages_sub>
            base += order_size;
c01031bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01031be:	89 d0                	mov    %edx,%eax
c01031c0:	01 c0                	add    %eax,%eax
c01031c2:	01 d0                	add    %edx,%eax
c01031c4:	c1 e0 03             	shl    $0x3,%eax
c01031c7:	01 45 08             	add    %eax,0x8(%ebp)
            n -= order_size;
c01031ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01031cd:	29 45 0c             	sub    %eax,0xc(%ebp)
                n -= order_size;
            }
            order ++;
            order_size <<= 1;
        }
        while (n != 0) {
c01031d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01031d4:	75 c2                	jne    c0103198 <buddy_free_pages+0x7e>
            buddy_free_pages_sub(base, order);
            base += order_size;
            n -= order_size;
        }
    }
}
c01031d6:	c9                   	leave  
c01031d7:	c3                   	ret    

c01031d8 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c01031d8:	55                   	push   %ebp
c01031d9:	89 e5                	mov    %esp,%ebp
c01031db:	83 ec 10             	sub    $0x10,%esp
    size_t ret = 0, order = 0;
c01031de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01031e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for (; order <= MAX_ORDER; order ++) {
c01031ec:	eb 24                	jmp    c0103212 <buddy_nr_free_pages+0x3a>
        ret += nr_free(order) * (1 << order);
c01031ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01031f1:	89 d0                	mov    %edx,%eax
c01031f3:	01 c0                	add    %eax,%eax
c01031f5:	01 d0                	add    %edx,%eax
c01031f7:	c1 e0 02             	shl    $0x2,%eax
c01031fa:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c01031ff:	8b 50 08             	mov    0x8(%eax),%edx
c0103202:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103205:	89 c1                	mov    %eax,%ecx
c0103207:	d3 e2                	shl    %cl,%edx
c0103209:	89 d0                	mov    %edx,%eax
c010320b:	01 45 fc             	add    %eax,-0x4(%ebp)
}

static size_t
buddy_nr_free_pages(void) {
    size_t ret = 0, order = 0;
    for (; order <= MAX_ORDER; order ++) {
c010320e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0103212:	83 7d f8 0a          	cmpl   $0xa,-0x8(%ebp)
c0103216:	76 d6                	jbe    c01031ee <buddy_nr_free_pages+0x16>
        ret += nr_free(order) * (1 << order);
    }
    return ret;
c0103218:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010321b:	c9                   	leave  
c010321c:	c3                   	ret    

c010321d <buddy_check>:


static void
buddy_check(void) {
c010321d:	55                   	push   %ebp
c010321e:	89 e5                	mov    %esp,%ebp
c0103220:	53                   	push   %ebx
c0103221:	81 ec 54 01 00 00    	sub    $0x154,%esp
    int i;
    int count = 0, total = 0;
c0103227:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010322e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (i = 0; i <= MAX_ORDER; i ++) {
c0103235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010323c:	e9 b6 00 00 00       	jmp    c01032f7 <buddy_check+0xda>
        list_entry_t *list = &free_list(i), *le = list;
c0103241:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103244:	89 d0                	mov    %edx,%eax
c0103246:	01 c0                	add    %eax,%eax
c0103248:	01 d0                	add    %edx,%eax
c010324a:	c1 e0 02             	shl    $0x2,%eax
c010324d:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0103252:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103255:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103258:	89 45 e8             	mov    %eax,-0x18(%ebp)
        while ((le = list_next(le)) != list) {
c010325b:	eb 7b                	jmp    c01032d8 <buddy_check+0xbb>
            struct Page *p = le2page(le, page_link);
c010325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103260:	83 e8 10             	sub    $0x10,%eax
c0103263:	89 45 dc             	mov    %eax,-0x24(%ebp)
            assert(PageProperty(p) && p->property == i);
c0103266:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103269:	83 c0 04             	add    $0x4,%eax
c010326c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103273:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103276:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103279:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010327c:	0f a3 10             	bt     %edx,(%eax)
c010327f:	19 c0                	sbb    %eax,%eax
c0103281:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0103284:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103288:	0f 95 c0             	setne  %al
c010328b:	0f b6 c0             	movzbl %al,%eax
c010328e:	85 c0                	test   %eax,%eax
c0103290:	74 0d                	je     c010329f <buddy_check+0x82>
c0103292:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103295:	8b 50 08             	mov    0x8(%eax),%edx
c0103298:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010329b:	39 c2                	cmp    %eax,%edx
c010329d:	74 24                	je     c01032c3 <buddy_check+0xa6>
c010329f:	c7 44 24 0c f0 7a 10 	movl   $0xc0107af0,0xc(%esp)
c01032a6:	c0 
c01032a7:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c01032ae:	c0 
c01032af:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c01032b6:	00 
c01032b7:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01032be:	e8 0e da ff ff       	call   c0100cd1 <__panic>
            count ++, total += (1 << i);
c01032c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ca:	ba 01 00 00 00       	mov    $0x1,%edx
c01032cf:	89 c1                	mov    %eax,%ecx
c01032d1:	d3 e2                	shl    %cl,%edx
c01032d3:	89 d0                	mov    %edx,%eax
c01032d5:	01 45 ec             	add    %eax,-0x14(%ebp)
c01032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032db:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01032de:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01032e1:	8b 40 04             	mov    0x4(%eax),%eax
buddy_check(void) {
    int i;
    int count = 0, total = 0;
    for (i = 0; i <= MAX_ORDER; i ++) {
        list_entry_t *list = &free_list(i), *le = list;
        while ((le = list_next(le)) != list) {
c01032e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032ea:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01032ed:	0f 85 6a ff ff ff    	jne    c010325d <buddy_check+0x40>

static void
buddy_check(void) {
    int i;
    int count = 0, total = 0;
    for (i = 0; i <= MAX_ORDER; i ++) {
c01032f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01032f7:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
c01032fb:	0f 8e 40 ff ff ff    	jle    c0103241 <buddy_check+0x24>
            struct Page *p = le2page(le, page_link);
            assert(PageProperty(p) && p->property == i);
            count ++, total += (1 << i);
        }
    }
    assert(total == nr_free_pages());
c0103301:	8b 5d ec             	mov    -0x14(%ebp),%ebx
c0103304:	e8 85 1e 00 00       	call   c010518e <nr_free_pages>
c0103309:	39 c3                	cmp    %eax,%ebx
c010330b:	74 24                	je     c0103331 <buddy_check+0x114>
c010330d:	c7 44 24 0c 3d 7b 10 	movl   $0xc0107b3d,0xc(%esp)
c0103314:	c0 
c0103315:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c010331c:	c0 
c010331d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103324:	00 
c0103325:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c010332c:	e8 a0 d9 ff ff       	call   c0100cd1 <__panic>

    struct Page *p0 = alloc_pages(8), *buddy = alloc_pages(8), *p1;
c0103331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0103338:	e8 e7 1d 00 00       	call   c0105124 <alloc_pages>
c010333d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103340:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0103347:	e8 d8 1d 00 00       	call   c0105124 <alloc_pages>
c010334c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    assert(p0 != NULL);
c010334f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103353:	75 24                	jne    c0103379 <buddy_check+0x15c>
c0103355:	c7 44 24 0c 56 7b 10 	movl   $0xc0107b56,0xc(%esp)
c010335c:	c0 
c010335d:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103364:	c0 
c0103365:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c010336c:	00 
c010336d:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103374:	e8 58 d9 ff ff       	call   c0100cd1 <__panic>
    assert((page2idx(p0) & 7) == 0);
c0103379:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010337c:	89 04 24             	mov    %eax,(%esp)
c010337f:	e8 62 fb ff ff       	call   c0102ee6 <page2idx>
c0103384:	83 e0 07             	and    $0x7,%eax
c0103387:	85 c0                	test   %eax,%eax
c0103389:	74 24                	je     c01033af <buddy_check+0x192>
c010338b:	c7 44 24 0c 61 7b 10 	movl   $0xc0107b61,0xc(%esp)
c0103392:	c0 
c0103393:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c010339a:	c0 
c010339b:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01033a2:	00 
c01033a3:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01033aa:	e8 22 d9 ff ff       	call   c0100cd1 <__panic>
    assert(!PageProperty(p0));
c01033af:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033b2:	83 c0 04             	add    $0x4,%eax
c01033b5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01033bc:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01033c2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01033c5:	0f a3 10             	bt     %edx,(%eax)
c01033c8:	19 c0                	sbb    %eax,%eax
c01033ca:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c01033cd:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c01033d1:	0f 95 c0             	setne  %al
c01033d4:	0f b6 c0             	movzbl %al,%eax
c01033d7:	85 c0                	test   %eax,%eax
c01033d9:	74 24                	je     c01033ff <buddy_check+0x1e2>
c01033db:	c7 44 24 0c 79 7b 10 	movl   $0xc0107b79,0xc(%esp)
c01033e2:	c0 
c01033e3:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c01033ea:	c0 
c01033eb:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c01033f2:	00 
c01033f3:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01033fa:	e8 d2 d8 ff ff       	call   c0100cd1 <__panic>

    list_entry_t free_lists_store[MAX_ORDER + 1];
    unsigned int nr_free_store[MAX_ORDER + 1];

    for (i = 0; i <= MAX_ORDER; i ++) {
c01033ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103406:	e9 d4 00 00 00       	jmp    c01034df <buddy_check+0x2c2>
        free_lists_store[i] = free_list(i);
c010340b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c010340e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103411:	89 d0                	mov    %edx,%eax
c0103413:	01 c0                	add    %eax,%eax
c0103415:	01 d0                	add    %edx,%eax
c0103417:	c1 e0 02             	shl    $0x2,%eax
c010341a:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c010341f:	8b 50 04             	mov    0x4(%eax),%edx
c0103422:	8b 00                	mov    (%eax),%eax
c0103424:	89 84 cd e8 fe ff ff 	mov    %eax,-0x118(%ebp,%ecx,8)
c010342b:	89 94 cd ec fe ff ff 	mov    %edx,-0x114(%ebp,%ecx,8)
        list_init(&free_list(i));
c0103432:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103435:	89 d0                	mov    %edx,%eax
c0103437:	01 c0                	add    %eax,%eax
c0103439:	01 d0                	add    %edx,%eax
c010343b:	c1 e0 02             	shl    $0x2,%eax
c010343e:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0103443:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103446:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103449:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010344c:	89 50 04             	mov    %edx,0x4(%eax)
c010344f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103452:	8b 50 04             	mov    0x4(%eax),%edx
c0103455:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103458:	89 10                	mov    %edx,(%eax)
        assert(list_empty(&free_list(i)));
c010345a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010345d:	89 d0                	mov    %edx,%eax
c010345f:	01 c0                	add    %eax,%eax
c0103461:	01 d0                	add    %edx,%eax
c0103463:	c1 e0 02             	shl    $0x2,%eax
c0103466:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c010346b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010346e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103471:	8b 40 04             	mov    0x4(%eax),%eax
c0103474:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0103477:	0f 94 c0             	sete   %al
c010347a:	0f b6 c0             	movzbl %al,%eax
c010347d:	85 c0                	test   %eax,%eax
c010347f:	75 24                	jne    c01034a5 <buddy_check+0x288>
c0103481:	c7 44 24 0c 8b 7b 10 	movl   $0xc0107b8b,0xc(%esp)
c0103488:	c0 
c0103489:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103490:	c0 
c0103491:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0103498:	00 
c0103499:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01034a0:	e8 2c d8 ff ff       	call   c0100cd1 <__panic>
        nr_free_store[i] = nr_free(i);
c01034a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01034a8:	89 d0                	mov    %edx,%eax
c01034aa:	01 c0                	add    %eax,%eax
c01034ac:	01 d0                	add    %edx,%eax
c01034ae:	c1 e0 02             	shl    $0x2,%eax
c01034b1:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c01034b6:	8b 50 08             	mov    0x8(%eax),%edx
c01034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034bc:	89 94 85 bc fe ff ff 	mov    %edx,-0x144(%ebp,%eax,4)
        nr_free(i) = 0;
c01034c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01034c6:	89 d0                	mov    %edx,%eax
c01034c8:	01 c0                	add    %eax,%eax
c01034ca:	01 d0                	add    %edx,%eax
c01034cc:	c1 e0 02             	shl    $0x2,%eax
c01034cf:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c01034d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    assert(!PageProperty(p0));

    list_entry_t free_lists_store[MAX_ORDER + 1];
    unsigned int nr_free_store[MAX_ORDER + 1];

    for (i = 0; i <= MAX_ORDER; i ++) {
c01034db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01034df:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
c01034e3:	0f 8e 22 ff ff ff    	jle    c010340b <buddy_check+0x1ee>
        assert(list_empty(&free_list(i)));
        nr_free_store[i] = nr_free(i);
        nr_free(i) = 0;
    }

    assert(nr_free_pages() == 0);
c01034e9:	e8 a0 1c 00 00       	call   c010518e <nr_free_pages>
c01034ee:	85 c0                	test   %eax,%eax
c01034f0:	74 24                	je     c0103516 <buddy_check+0x2f9>
c01034f2:	c7 44 24 0c a5 7b 10 	movl   $0xc0107ba5,0xc(%esp)
c01034f9:	c0 
c01034fa:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103501:	c0 
c0103502:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0103509:	00 
c010350a:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103511:	e8 bb d7 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c0103516:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010351d:	e8 02 1c 00 00       	call   c0105124 <alloc_pages>
c0103522:	85 c0                	test   %eax,%eax
c0103524:	74 24                	je     c010354a <buddy_check+0x32d>
c0103526:	c7 44 24 0c ba 7b 10 	movl   $0xc0107bba,0xc(%esp)
c010352d:	c0 
c010352e:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103535:	c0 
c0103536:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c010353d:	00 
c010353e:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103545:	e8 87 d7 ff ff       	call   c0100cd1 <__panic>
    free_pages(p0, 8);
c010354a:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
c0103551:	00 
c0103552:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103555:	89 04 24             	mov    %eax,(%esp)
c0103558:	e8 ff 1b 00 00       	call   c010515c <free_pages>
    assert(nr_free_pages() == 8);
c010355d:	e8 2c 1c 00 00       	call   c010518e <nr_free_pages>
c0103562:	83 f8 08             	cmp    $0x8,%eax
c0103565:	74 24                	je     c010358b <buddy_check+0x36e>
c0103567:	c7 44 24 0c cf 7b 10 	movl   $0xc0107bcf,0xc(%esp)
c010356e:	c0 
c010356f:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103576:	c0 
c0103577:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010357e:	00 
c010357f:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103586:	e8 46 d7 ff ff       	call   c0100cd1 <__panic>
    assert(PageProperty(p0) && p0->property == 3);
c010358b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010358e:	83 c0 04             	add    $0x4,%eax
c0103591:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103598:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010359b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010359e:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01035a1:	0f a3 10             	bt     %edx,(%eax)
c01035a4:	19 c0                	sbb    %eax,%eax
c01035a6:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01035a9:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01035ad:	0f 95 c0             	setne  %al
c01035b0:	0f b6 c0             	movzbl %al,%eax
c01035b3:	85 c0                	test   %eax,%eax
c01035b5:	74 0b                	je     c01035c2 <buddy_check+0x3a5>
c01035b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035ba:	8b 40 08             	mov    0x8(%eax),%eax
c01035bd:	83 f8 03             	cmp    $0x3,%eax
c01035c0:	74 24                	je     c01035e6 <buddy_check+0x3c9>
c01035c2:	c7 44 24 0c e4 7b 10 	movl   $0xc0107be4,0xc(%esp)
c01035c9:	c0 
c01035ca:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c01035d1:	c0 
c01035d2:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01035d9:	00 
c01035da:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01035e1:	e8 eb d6 ff ff       	call   c0100cd1 <__panic>
    assert((p0 = alloc_pages(6)) != NULL && !PageProperty(p0) && nr_free_pages() == 2);
c01035e6:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
c01035ed:	e8 32 1b 00 00       	call   c0105124 <alloc_pages>
c01035f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01035f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01035f9:	74 36                	je     c0103631 <buddy_check+0x414>
c01035fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035fe:	83 c0 04             	add    $0x4,%eax
c0103601:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103608:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010360b:	8b 45 90             	mov    -0x70(%ebp),%eax
c010360e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103611:	0f a3 10             	bt     %edx,(%eax)
c0103614:	19 c0                	sbb    %eax,%eax
c0103616:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103619:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010361d:	0f 95 c0             	setne  %al
c0103620:	0f b6 c0             	movzbl %al,%eax
c0103623:	85 c0                	test   %eax,%eax
c0103625:	75 0a                	jne    c0103631 <buddy_check+0x414>
c0103627:	e8 62 1b 00 00       	call   c010518e <nr_free_pages>
c010362c:	83 f8 02             	cmp    $0x2,%eax
c010362f:	74 24                	je     c0103655 <buddy_check+0x438>
c0103631:	c7 44 24 0c 0c 7c 10 	movl   $0xc0107c0c,0xc(%esp)
c0103638:	c0 
c0103639:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103640:	c0 
c0103641:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103648:	00 
c0103649:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103650:	e8 7c d6 ff ff       	call   c0100cd1 <__panic>

    assert((p1 = alloc_pages(2)) != NULL && p1 == p0 + 6);
c0103655:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010365c:	e8 c3 1a 00 00       	call   c0105124 <alloc_pages>
c0103661:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103664:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103668:	74 0d                	je     c0103677 <buddy_check+0x45a>
c010366a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010366d:	05 90 00 00 00       	add    $0x90,%eax
c0103672:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103675:	74 24                	je     c010369b <buddy_check+0x47e>
c0103677:	c7 44 24 0c 58 7c 10 	movl   $0xc0107c58,0xc(%esp)
c010367e:	c0 
c010367f:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103686:	c0 
c0103687:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c010368e:	00 
c010368f:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103696:	e8 36 d6 ff ff       	call   c0100cd1 <__panic>
    assert(nr_free_pages() == 0);
c010369b:	e8 ee 1a 00 00       	call   c010518e <nr_free_pages>
c01036a0:	85 c0                	test   %eax,%eax
c01036a2:	74 24                	je     c01036c8 <buddy_check+0x4ab>
c01036a4:	c7 44 24 0c a5 7b 10 	movl   $0xc0107ba5,0xc(%esp)
c01036ab:	c0 
c01036ac:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c01036b3:	c0 
c01036b4:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01036bb:	00 
c01036bc:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01036c3:	e8 09 d6 ff ff       	call   c0100cd1 <__panic>

    free_pages(p0, 3);
c01036c8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036cf:	00 
c01036d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036d3:	89 04 24             	mov    %eax,(%esp)
c01036d6:	e8 81 1a 00 00       	call   c010515c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01036db:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036de:	83 c0 04             	add    $0x4,%eax
c01036e1:	c7 45 88 01 00 00 00 	movl   $0x1,-0x78(%ebp)
c01036e8:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036eb:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01036ee:	8b 55 88             	mov    -0x78(%ebp),%edx
c01036f1:	0f a3 10             	bt     %edx,(%eax)
c01036f4:	19 c0                	sbb    %eax,%eax
c01036f6:	89 45 80             	mov    %eax,-0x80(%ebp)
    return oldbit != 0;
c01036f9:	83 7d 80 00          	cmpl   $0x0,-0x80(%ebp)
c01036fd:	0f 95 c0             	setne  %al
c0103700:	0f b6 c0             	movzbl %al,%eax
c0103703:	85 c0                	test   %eax,%eax
c0103705:	74 0b                	je     c0103712 <buddy_check+0x4f5>
c0103707:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010370a:	8b 40 08             	mov    0x8(%eax),%eax
c010370d:	83 f8 01             	cmp    $0x1,%eax
c0103710:	74 24                	je     c0103736 <buddy_check+0x519>
c0103712:	c7 44 24 0c 88 7c 10 	movl   $0xc0107c88,0xc(%esp)
c0103719:	c0 
c010371a:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103721:	c0 
c0103722:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103729:	00 
c010372a:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103731:	e8 9b d5 ff ff       	call   c0100cd1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 0);
c0103736:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103739:	83 c0 30             	add    $0x30,%eax
c010373c:	83 c0 04             	add    $0x4,%eax
c010373f:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
c0103746:	00 00 00 
c0103749:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010374f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0103755:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c010375b:	0f a3 10             	bt     %edx,(%eax)
c010375e:	19 c0                	sbb    %eax,%eax
c0103760:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    return oldbit != 0;
c0103766:	83 bd 74 ff ff ff 00 	cmpl   $0x0,-0x8c(%ebp)
c010376d:	0f 95 c0             	setne  %al
c0103770:	0f b6 c0             	movzbl %al,%eax
c0103773:	85 c0                	test   %eax,%eax
c0103775:	74 0d                	je     c0103784 <buddy_check+0x567>
c0103777:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010377a:	83 c0 30             	add    $0x30,%eax
c010377d:	8b 40 08             	mov    0x8(%eax),%eax
c0103780:	85 c0                	test   %eax,%eax
c0103782:	74 24                	je     c01037a8 <buddy_check+0x58b>
c0103784:	c7 44 24 0c b0 7c 10 	movl   $0xc0107cb0,0xc(%esp)
c010378b:	c0 
c010378c:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103793:	c0 
c0103794:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010379b:	00 
c010379c:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01037a3:	e8 29 d5 ff ff       	call   c0100cd1 <__panic>

    free_pages(p0 + 3, 3);
c01037a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037ab:	83 c0 48             	add    $0x48,%eax
c01037ae:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037b5:	00 
c01037b6:	89 04 24             	mov    %eax,(%esp)
c01037b9:	e8 9e 19 00 00       	call   c010515c <free_pages>
    free_pages(p1, 2);
c01037be:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01037c5:	00 
c01037c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01037c9:	89 04 24             	mov    %eax,(%esp)
c01037cc:	e8 8b 19 00 00       	call   c010515c <free_pages>

    assert(PageProperty(p0) && p0->property == 3);
c01037d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037d4:	83 c0 04             	add    $0x4,%eax
c01037d7:	c7 85 70 ff ff ff 01 	movl   $0x1,-0x90(%ebp)
c01037de:	00 00 00 
c01037e1:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037e7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c01037ed:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c01037f3:	0f a3 10             	bt     %edx,(%eax)
c01037f6:	19 c0                	sbb    %eax,%eax
c01037f8:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
    return oldbit != 0;
c01037fe:	83 bd 68 ff ff ff 00 	cmpl   $0x0,-0x98(%ebp)
c0103805:	0f 95 c0             	setne  %al
c0103808:	0f b6 c0             	movzbl %al,%eax
c010380b:	85 c0                	test   %eax,%eax
c010380d:	74 0b                	je     c010381a <buddy_check+0x5fd>
c010380f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103812:	8b 40 08             	mov    0x8(%eax),%eax
c0103815:	83 f8 03             	cmp    $0x3,%eax
c0103818:	74 24                	je     c010383e <buddy_check+0x621>
c010381a:	c7 44 24 0c e4 7b 10 	movl   $0xc0107be4,0xc(%esp)
c0103821:	c0 
c0103822:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103829:	c0 
c010382a:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103831:	00 
c0103832:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103839:	e8 93 d4 ff ff       	call   c0100cd1 <__panic>

    assert((p0 = alloc_pages(6)) != NULL);
c010383e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
c0103845:	e8 da 18 00 00       	call   c0105124 <alloc_pages>
c010384a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010384d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103851:	75 24                	jne    c0103877 <buddy_check+0x65a>
c0103853:	c7 44 24 0c dc 7c 10 	movl   $0xc0107cdc,0xc(%esp)
c010385a:	c0 
c010385b:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103862:	c0 
c0103863:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c010386a:	00 
c010386b:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103872:	e8 5a d4 ff ff       	call   c0100cd1 <__panic>
    assert((p1 = alloc_pages(2)) != NULL);
c0103877:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010387e:	e8 a1 18 00 00       	call   c0105124 <alloc_pages>
c0103883:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103886:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010388a:	75 24                	jne    c01038b0 <buddy_check+0x693>
c010388c:	c7 44 24 0c fa 7c 10 	movl   $0xc0107cfa,0xc(%esp)
c0103893:	c0 
c0103894:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c010389b:	c0 
c010389c:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01038a3:	00 
c01038a4:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01038ab:	e8 21 d4 ff ff       	call   c0100cd1 <__panic>
    free_pages(p0 + 4, 2);
c01038b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038b3:	83 c0 60             	add    $0x60,%eax
c01038b6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01038bd:	00 
c01038be:	89 04 24             	mov    %eax,(%esp)
c01038c1:	e8 96 18 00 00       	call   c010515c <free_pages>
    free_pages(p1, 2);
c01038c6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01038cd:	00 
c01038ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038d1:	89 04 24             	mov    %eax,(%esp)
c01038d4:	e8 83 18 00 00       	call   c010515c <free_pages>

    p1 = p0 + 4;
c01038d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038dc:	83 c0 60             	add    $0x60,%eax
c01038df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    assert(PageProperty(p1) && p1->property == 2);
c01038e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038e5:	83 c0 04             	add    $0x4,%eax
c01038e8:	c7 85 64 ff ff ff 01 	movl   $0x1,-0x9c(%ebp)
c01038ef:	00 00 00 
c01038f2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01038f8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
c01038fe:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
c0103904:	0f a3 10             	bt     %edx,(%eax)
c0103907:	19 c0                	sbb    %eax,%eax
c0103909:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    return oldbit != 0;
c010390f:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
c0103916:	0f 95 c0             	setne  %al
c0103919:	0f b6 c0             	movzbl %al,%eax
c010391c:	85 c0                	test   %eax,%eax
c010391e:	74 0b                	je     c010392b <buddy_check+0x70e>
c0103920:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103923:	8b 40 08             	mov    0x8(%eax),%eax
c0103926:	83 f8 02             	cmp    $0x2,%eax
c0103929:	74 24                	je     c010394f <buddy_check+0x732>
c010392b:	c7 44 24 0c 18 7d 10 	movl   $0xc0107d18,0xc(%esp)
c0103932:	c0 
c0103933:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c010393a:	c0 
c010393b:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103942:	00 
c0103943:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c010394a:	e8 82 d3 ff ff       	call   c0100cd1 <__panic>
    free_pages(p0, 4);
c010394f:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
c0103956:	00 
c0103957:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010395a:	89 04 24             	mov    %eax,(%esp)
c010395d:	e8 fa 17 00 00       	call   c010515c <free_pages>
    assert(PageProperty(p0) && p0->property == 3);
c0103962:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103965:	83 c0 04             	add    $0x4,%eax
c0103968:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
c010396f:	00 00 00 
c0103972:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103978:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
c010397e:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
c0103984:	0f a3 10             	bt     %edx,(%eax)
c0103987:	19 c0                	sbb    %eax,%eax
c0103989:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
    return oldbit != 0;
c010398f:	83 bd 50 ff ff ff 00 	cmpl   $0x0,-0xb0(%ebp)
c0103996:	0f 95 c0             	setne  %al
c0103999:	0f b6 c0             	movzbl %al,%eax
c010399c:	85 c0                	test   %eax,%eax
c010399e:	74 0b                	je     c01039ab <buddy_check+0x78e>
c01039a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01039a3:	8b 40 08             	mov    0x8(%eax),%eax
c01039a6:	83 f8 03             	cmp    $0x3,%eax
c01039a9:	74 24                	je     c01039cf <buddy_check+0x7b2>
c01039ab:	c7 44 24 0c e4 7b 10 	movl   $0xc0107be4,0xc(%esp)
c01039b2:	c0 
c01039b3:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c01039ba:	c0 
c01039bb:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c01039c2:	00 
c01039c3:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c01039ca:	e8 02 d3 ff ff       	call   c0100cd1 <__panic>

    assert((p0 = alloc_pages(8)) != NULL);
c01039cf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01039d6:	e8 49 17 00 00       	call   c0105124 <alloc_pages>
c01039db:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01039de:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01039e2:	75 24                	jne    c0103a08 <buddy_check+0x7eb>
c01039e4:	c7 44 24 0c 3e 7d 10 	movl   $0xc0107d3e,0xc(%esp)
c01039eb:	c0 
c01039ec:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c01039f3:	c0 
c01039f4:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c01039fb:	00 
c01039fc:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103a03:	e8 c9 d2 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL && nr_free_pages() == 0);
c0103a08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a0f:	e8 10 17 00 00       	call   c0105124 <alloc_pages>
c0103a14:	85 c0                	test   %eax,%eax
c0103a16:	75 09                	jne    c0103a21 <buddy_check+0x804>
c0103a18:	e8 71 17 00 00       	call   c010518e <nr_free_pages>
c0103a1d:	85 c0                	test   %eax,%eax
c0103a1f:	74 24                	je     c0103a45 <buddy_check+0x828>
c0103a21:	c7 44 24 0c 5c 7d 10 	movl   $0xc0107d5c,0xc(%esp)
c0103a28:	c0 
c0103a29:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103a30:	c0 
c0103a31:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103a38:	00 
c0103a39:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103a40:	e8 8c d2 ff ff       	call   c0100cd1 <__panic>

    for (i = 0; i <= MAX_ORDER; i ++) {
c0103a45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103a4c:	eb 4a                	jmp    c0103a98 <buddy_check+0x87b>
        free_list(i) = free_lists_store[i];
c0103a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a51:	89 d0                	mov    %edx,%eax
c0103a53:	01 c0                	add    %eax,%eax
c0103a55:	01 d0                	add    %edx,%eax
c0103a57:	c1 e0 02             	shl    $0x2,%eax
c0103a5a:	8d 88 00 b9 11 c0    	lea    -0x3fee4700(%eax),%ecx
c0103a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a63:	8b 94 c5 ec fe ff ff 	mov    -0x114(%ebp,%eax,8),%edx
c0103a6a:	8b 84 c5 e8 fe ff ff 	mov    -0x118(%ebp,%eax,8),%eax
c0103a71:	89 01                	mov    %eax,(%ecx)
c0103a73:	89 51 04             	mov    %edx,0x4(%ecx)
        nr_free(i) = nr_free_store[i];
c0103a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a79:	8b 8c 85 bc fe ff ff 	mov    -0x144(%ebp,%eax,4),%ecx
c0103a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a83:	89 d0                	mov    %edx,%eax
c0103a85:	01 c0                	add    %eax,%eax
c0103a87:	01 d0                	add    %edx,%eax
c0103a89:	c1 e0 02             	shl    $0x2,%eax
c0103a8c:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0103a91:	89 48 08             	mov    %ecx,0x8(%eax)
    assert(PageProperty(p0) && p0->property == 3);

    assert((p0 = alloc_pages(8)) != NULL);
    assert(alloc_page() == NULL && nr_free_pages() == 0);

    for (i = 0; i <= MAX_ORDER; i ++) {
c0103a94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103a98:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
c0103a9c:	7e b0                	jle    c0103a4e <buddy_check+0x831>
        free_list(i) = free_lists_store[i];
        nr_free(i) = nr_free_store[i];
    }

    free_pages(p0, 8);
c0103a9e:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
c0103aa5:	00 
c0103aa6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103aa9:	89 04 24             	mov    %eax,(%esp)
c0103aac:	e8 ab 16 00 00       	call   c010515c <free_pages>
    free_pages(buddy, 8);
c0103ab1:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
c0103ab8:	00 
c0103ab9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103abc:	89 04 24             	mov    %eax,(%esp)
c0103abf:	e8 98 16 00 00       	call   c010515c <free_pages>

    assert(total == nr_free_pages());
c0103ac4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
c0103ac7:	e8 c2 16 00 00       	call   c010518e <nr_free_pages>
c0103acc:	39 c3                	cmp    %eax,%ebx
c0103ace:	74 24                	je     c0103af4 <buddy_check+0x8d7>
c0103ad0:	c7 44 24 0c 3d 7b 10 	movl   $0xc0107b3d,0xc(%esp)
c0103ad7:	c0 
c0103ad8:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103adf:	c0 
c0103ae0:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103ae7:	00 
c0103ae8:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103aef:	e8 dd d1 ff ff       	call   c0100cd1 <__panic>

    for (i = 0; i <= MAX_ORDER; i ++) {
c0103af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103afb:	e9 d1 00 00 00       	jmp    c0103bd1 <buddy_check+0x9b4>
        list_entry_t *list = &free_list(i), *le = list;
c0103b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b03:	89 d0                	mov    %edx,%eax
c0103b05:	01 c0                	add    %eax,%eax
c0103b07:	01 d0                	add    %edx,%eax
c0103b09:	c1 e0 02             	shl    $0x2,%eax
c0103b0c:	05 00 b9 11 c0       	add    $0xc011b900,%eax
c0103b11:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0103b14:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103b17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        while ((le = list_next(le)) != list) {
c0103b1a:	e9 8d 00 00 00       	jmp    c0103bac <buddy_check+0x98f>
            struct Page *p = le2page(le, page_link);
c0103b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b22:	83 e8 10             	sub    $0x10,%eax
c0103b25:	89 45 c8             	mov    %eax,-0x38(%ebp)
            assert(PageProperty(p) && p->property == i);
c0103b28:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103b2b:	83 c0 04             	add    $0x4,%eax
c0103b2e:	c7 85 4c ff ff ff 01 	movl   $0x1,-0xb4(%ebp)
c0103b35:	00 00 00 
c0103b38:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103b3e:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
c0103b44:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
c0103b4a:	0f a3 10             	bt     %edx,(%eax)
c0103b4d:	19 c0                	sbb    %eax,%eax
c0103b4f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
    return oldbit != 0;
c0103b55:	83 bd 44 ff ff ff 00 	cmpl   $0x0,-0xbc(%ebp)
c0103b5c:	0f 95 c0             	setne  %al
c0103b5f:	0f b6 c0             	movzbl %al,%eax
c0103b62:	85 c0                	test   %eax,%eax
c0103b64:	74 0d                	je     c0103b73 <buddy_check+0x956>
c0103b66:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103b69:	8b 50 08             	mov    0x8(%eax),%edx
c0103b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b6f:	39 c2                	cmp    %eax,%edx
c0103b71:	74 24                	je     c0103b97 <buddy_check+0x97a>
c0103b73:	c7 44 24 0c f0 7a 10 	movl   $0xc0107af0,0xc(%esp)
c0103b7a:	c0 
c0103b7b:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103b82:	c0 
c0103b83:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103b8a:	00 
c0103b8b:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103b92:	e8 3a d1 ff ff       	call   c0100cd1 <__panic>
            count --, total -= (1 << i);
c0103b97:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
c0103b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b9e:	ba 01 00 00 00       	mov    $0x1,%edx
c0103ba3:	89 c1                	mov    %eax,%ecx
c0103ba5:	d3 e2                	shl    %cl,%edx
c0103ba7:	89 d0                	mov    %edx,%eax
c0103ba9:	29 45 ec             	sub    %eax,-0x14(%ebp)
c0103bac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103baf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103bb5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
c0103bbb:	8b 40 04             	mov    0x4(%eax),%eax

    assert(total == nr_free_pages());

    for (i = 0; i <= MAX_ORDER; i ++) {
        list_entry_t *list = &free_list(i), *le = list;
        while ((le = list_next(le)) != list) {
c0103bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bc4:	3b 45 cc             	cmp    -0x34(%ebp),%eax
c0103bc7:	0f 85 52 ff ff ff    	jne    c0103b1f <buddy_check+0x902>
    free_pages(p0, 8);
    free_pages(buddy, 8);

    assert(total == nr_free_pages());

    for (i = 0; i <= MAX_ORDER; i ++) {
c0103bcd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103bd1:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
c0103bd5:	0f 8e 25 ff ff ff    	jle    c0103b00 <buddy_check+0x8e3>
            struct Page *p = le2page(le, page_link);
            assert(PageProperty(p) && p->property == i);
            count --, total -= (1 << i);
        }
    }
    assert(count == 0);
c0103bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bdf:	74 24                	je     c0103c05 <buddy_check+0x9e8>
c0103be1:	c7 44 24 0c 89 7d 10 	movl   $0xc0107d89,0xc(%esp)
c0103be8:	c0 
c0103be9:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103bf0:	c0 
c0103bf1:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103bf8:	00 
c0103bf9:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103c00:	e8 cc d0 ff ff       	call   c0100cd1 <__panic>
    assert(total == 0);
c0103c05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103c09:	74 24                	je     c0103c2f <buddy_check+0xa12>
c0103c0b:	c7 44 24 0c 94 7d 10 	movl   $0xc0107d94,0xc(%esp)
c0103c12:	c0 
c0103c13:	c7 44 24 08 14 7b 10 	movl   $0xc0107b14,0x8(%esp)
c0103c1a:	c0 
c0103c1b:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0103c22:	00 
c0103c23:	c7 04 24 29 7b 10 c0 	movl   $0xc0107b29,(%esp)
c0103c2a:	e8 a2 d0 ff ff       	call   c0100cd1 <__panic>
}
c0103c2f:	81 c4 54 01 00 00    	add    $0x154,%esp
c0103c35:	5b                   	pop    %ebx
c0103c36:	5d                   	pop    %ebp
c0103c37:	c3                   	ret    

c0103c38 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103c38:	55                   	push   %ebp
c0103c39:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c3b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c3e:	a1 44 ba 11 c0       	mov    0xc011ba44,%eax
c0103c43:	29 c2                	sub    %eax,%edx
c0103c45:	89 d0                	mov    %edx,%eax
c0103c47:	c1 f8 03             	sar    $0x3,%eax
c0103c4a:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
c0103c50:	5d                   	pop    %ebp
c0103c51:	c3                   	ret    

c0103c52 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103c52:	55                   	push   %ebp
c0103c53:	89 e5                	mov    %esp,%ebp
c0103c55:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c58:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c5b:	89 04 24             	mov    %eax,(%esp)
c0103c5e:	e8 d5 ff ff ff       	call   c0103c38 <page2ppn>
c0103c63:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c66:	c9                   	leave  
c0103c67:	c3                   	ret    

c0103c68 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103c68:	55                   	push   %ebp
c0103c69:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c6e:	8b 00                	mov    (%eax),%eax
}
c0103c70:	5d                   	pop    %ebp
c0103c71:	c3                   	ret    

c0103c72 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103c72:	55                   	push   %ebp
c0103c73:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103c75:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c78:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c7b:	89 10                	mov    %edx,(%eax)
}
c0103c7d:	5d                   	pop    %ebp
c0103c7e:	c3                   	ret    

c0103c7f <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103c7f:	55                   	push   %ebp
c0103c80:	89 e5                	mov    %esp,%ebp
c0103c82:	83 ec 10             	sub    $0x10,%esp
c0103c85:	c7 45 fc 30 ba 11 c0 	movl   $0xc011ba30,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103c8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103c92:	89 50 04             	mov    %edx,0x4(%eax)
c0103c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c98:	8b 50 04             	mov    0x4(%eax),%edx
c0103c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c9e:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103ca0:	c7 05 38 ba 11 c0 00 	movl   $0x0,0xc011ba38
c0103ca7:	00 00 00 
}
c0103caa:	c9                   	leave  
c0103cab:	c3                   	ret    

c0103cac <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103cac:	55                   	push   %ebp
c0103cad:	89 e5                	mov    %esp,%ebp
c0103caf:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103cb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103cb6:	75 24                	jne    c0103cdc <default_init_memmap+0x30>
c0103cb8:	c7 44 24 0c d0 7d 10 	movl   $0xc0107dd0,0xc(%esp)
c0103cbf:	c0 
c0103cc0:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0103cc7:	c0 
c0103cc8:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103ccf:	00 
c0103cd0:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0103cd7:	e8 f5 cf ff ff       	call   c0100cd1 <__panic>
    struct Page *p = base;
c0103cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103ce2:	eb 7d                	jmp    c0103d61 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce7:	83 c0 04             	add    $0x4,%eax
c0103cea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103cf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103cfa:	0f a3 10             	bt     %edx,(%eax)
c0103cfd:	19 c0                	sbb    %eax,%eax
c0103cff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103d02:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103d06:	0f 95 c0             	setne  %al
c0103d09:	0f b6 c0             	movzbl %al,%eax
c0103d0c:	85 c0                	test   %eax,%eax
c0103d0e:	75 24                	jne    c0103d34 <default_init_memmap+0x88>
c0103d10:	c7 44 24 0c 01 7e 10 	movl   $0xc0107e01,0xc(%esp)
c0103d17:	c0 
c0103d18:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0103d1f:	c0 
c0103d20:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0103d27:	00 
c0103d28:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0103d2f:	e8 9d cf ff ff       	call   c0100cd1 <__panic>
        p->flags = p->property = 0;
c0103d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d41:	8b 50 08             	mov    0x8(%eax),%edx
c0103d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d47:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0103d4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103d51:	00 
c0103d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d55:	89 04 24             	mov    %eax,(%esp)
c0103d58:	e8 15 ff ff ff       	call   c0103c72 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103d5d:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
c0103d61:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d64:	89 d0                	mov    %edx,%eax
c0103d66:	01 c0                	add    %eax,%eax
c0103d68:	01 d0                	add    %edx,%eax
c0103d6a:	c1 e0 03             	shl    $0x3,%eax
c0103d6d:	89 c2                	mov    %eax,%edx
c0103d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d72:	01 d0                	add    %edx,%eax
c0103d74:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d77:	0f 85 67 ff ff ff    	jne    c0103ce4 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d80:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d83:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103d86:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d89:	83 c0 04             	add    $0x4,%eax
c0103d8c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103d93:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d9c:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0103d9f:	8b 15 38 ba 11 c0    	mov    0xc011ba38,%edx
c0103da5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103da8:	01 d0                	add    %edx,%eax
c0103daa:	a3 38 ba 11 c0       	mov    %eax,0xc011ba38
    //list_add(&free_list, &(base->page_link));
    list_add_before(&free_list,&(base->page_link));//相当于每次插入到最后
c0103daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103db2:	83 c0 10             	add    $0x10,%eax
c0103db5:	c7 45 dc 30 ba 11 c0 	movl   $0xc011ba30,-0x24(%ebp)
c0103dbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103dc2:	8b 00                	mov    (%eax),%eax
c0103dc4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103dc7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103dca:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103dd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103dd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103dd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103dd9:	89 10                	mov    %edx,(%eax)
c0103ddb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103dde:	8b 10                	mov    (%eax),%edx
c0103de0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103de3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103de6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103de9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103dec:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103def:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103df2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103df5:	89 10                	mov    %edx,(%eax)
}
c0103df7:	c9                   	leave  
c0103df8:	c3                   	ret    

c0103df9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103df9:	55                   	push   %ebp
c0103dfa:	89 e5                	mov    %esp,%ebp
c0103dfc:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103dff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103e03:	75 24                	jne    c0103e29 <default_alloc_pages+0x30>
c0103e05:	c7 44 24 0c d0 7d 10 	movl   $0xc0107dd0,0xc(%esp)
c0103e0c:	c0 
c0103e0d:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0103e14:	c0 
c0103e15:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0103e1c:	00 
c0103e1d:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0103e24:	e8 a8 ce ff ff       	call   c0100cd1 <__panic>
    if (n > nr_free) {
c0103e29:	a1 38 ba 11 c0       	mov    0xc011ba38,%eax
c0103e2e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103e31:	73 0a                	jae    c0103e3d <default_alloc_pages+0x44>
        return NULL;
c0103e33:	b8 00 00 00 00       	mov    $0x0,%eax
c0103e38:	e9 48 01 00 00       	jmp    c0103f85 <default_alloc_pages+0x18c>
    }
    struct Page *page = NULL;
c0103e3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103e44:	c7 45 f0 30 ba 11 c0 	movl   $0xc011ba30,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103e4b:	eb 1c                	jmp    c0103e69 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);//memlayout.h
c0103e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e50:	83 e8 10             	sub    $0x10,%eax
c0103e53:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0103e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e59:	8b 40 08             	mov    0x8(%eax),%eax
c0103e5c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103e5f:	72 08                	jb     c0103e69 <default_alloc_pages+0x70>
            page = p;
c0103e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103e67:	eb 18                	jmp    c0103e81 <default_alloc_pages+0x88>
c0103e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e72:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e78:	81 7d f0 30 ba 11 c0 	cmpl   $0xc011ba30,-0x10(%ebp)
c0103e7f:	75 cc                	jne    c0103e4d <default_alloc_pages+0x54>
        if (page->property > n) {
            struct Page *p = page + n;
            p->property = page->property - n;
            list_add(&free_list, &(p->page_link));//
    }*/
    if (page != NULL) {
c0103e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103e85:	0f 84 f7 00 00 00    	je     c0103f82 <default_alloc_pages+0x189>

            if (page->property > n) {
c0103e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e8e:	8b 40 08             	mov    0x8(%eax),%eax
c0103e91:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103e94:	0f 86 97 00 00 00    	jbe    c0103f31 <default_alloc_pages+0x138>
                struct Page *p = page + n;
c0103e9a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e9d:	89 d0                	mov    %edx,%eax
c0103e9f:	01 c0                	add    %eax,%eax
c0103ea1:	01 d0                	add    %edx,%eax
c0103ea3:	c1 e0 03             	shl    $0x3,%eax
c0103ea6:	89 c2                	mov    %eax,%edx
c0103ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103eab:	01 d0                	add    %edx,%eax
c0103ead:	89 45 e8             	mov    %eax,-0x18(%ebp)
                p->property = page->property - n;
c0103eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103eb3:	8b 40 08             	mov    0x8(%eax),%eax
c0103eb6:	2b 45 08             	sub    0x8(%ebp),%eax
c0103eb9:	89 c2                	mov    %eax,%edx
c0103ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ebe:	89 50 08             	mov    %edx,0x8(%eax)
                SetPageProperty(p);
c0103ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ec4:	83 c0 04             	add    $0x4,%eax
c0103ec7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103ece:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103ed1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ed4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103ed7:	0f ab 10             	bts    %edx,(%eax)
                list_add(&(page->page_link), &(p->page_link));//before也可以
c0103eda:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103edd:	83 c0 10             	add    $0x10,%eax
c0103ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ee3:	83 c2 10             	add    $0x10,%edx
c0103ee6:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0103ee9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103eec:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103eef:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ef2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103ef5:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103ef8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103efb:	8b 40 04             	mov    0x4(%eax),%eax
c0103efe:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103f01:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103f04:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f07:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0103f0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103f0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103f10:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103f13:	89 10                	mov    %edx,(%eax)
c0103f15:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103f18:	8b 10                	mov    (%eax),%edx
c0103f1a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f1d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103f20:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f23:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103f26:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103f29:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f2c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103f2f:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0103f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f34:	83 c0 10             	add    $0x10,%eax
c0103f37:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103f3a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103f3d:	8b 40 04             	mov    0x4(%eax),%eax
c0103f40:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103f43:	8b 12                	mov    (%edx),%edx
c0103f45:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0103f48:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103f4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103f4e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f51:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103f54:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f57:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103f5a:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0103f5c:	a1 38 ba 11 c0       	mov    0xc011ba38,%eax
c0103f61:	2b 45 08             	sub    0x8(%ebp),%eax
c0103f64:	a3 38 ba 11 c0       	mov    %eax,0xc011ba38
        ClearPageProperty(page);//memlayout.h
c0103f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f6c:	83 c0 04             	add    $0x4,%eax
c0103f6f:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0103f76:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f79:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f7c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103f7f:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0103f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f85:	c9                   	leave  
c0103f86:	c3                   	ret    

c0103f87 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103f87:	55                   	push   %ebp
c0103f88:	89 e5                	mov    %esp,%ebp
c0103f8a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0103f90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103f94:	75 24                	jne    c0103fba <default_free_pages+0x33>
c0103f96:	c7 44 24 0c d0 7d 10 	movl   $0xc0107dd0,0xc(%esp)
c0103f9d:	c0 
c0103f9e:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0103fa5:	c0 
c0103fa6:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0103fad:	00 
c0103fae:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0103fb5:	e8 17 cd ff ff       	call   c0100cd1 <__panic>
    struct Page *p = base;
c0103fba:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103fc0:	e9 9d 00 00 00       	jmp    c0104062 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0103fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fc8:	83 c0 04             	add    $0x4,%eax
c0103fcb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103fd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103fdb:	0f a3 10             	bt     %edx,(%eax)
c0103fde:	19 c0                	sbb    %eax,%eax
c0103fe0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103fe3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103fe7:	0f 95 c0             	setne  %al
c0103fea:	0f b6 c0             	movzbl %al,%eax
c0103fed:	85 c0                	test   %eax,%eax
c0103fef:	75 2c                	jne    c010401d <default_free_pages+0x96>
c0103ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ff4:	83 c0 04             	add    $0x4,%eax
c0103ff7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103ffe:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104001:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104004:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104007:	0f a3 10             	bt     %edx,(%eax)
c010400a:	19 c0                	sbb    %eax,%eax
c010400c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010400f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104013:	0f 95 c0             	setne  %al
c0104016:	0f b6 c0             	movzbl %al,%eax
c0104019:	85 c0                	test   %eax,%eax
c010401b:	74 24                	je     c0104041 <default_free_pages+0xba>
c010401d:	c7 44 24 0c 14 7e 10 	movl   $0xc0107e14,0xc(%esp)
c0104024:	c0 
c0104025:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010402c:	c0 
c010402d:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c0104034:	00 
c0104035:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010403c:	e8 90 cc ff ff       	call   c0100cd1 <__panic>
        p->flags = 0;
c0104041:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c010404b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104052:	00 
c0104053:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104056:	89 04 24             	mov    %eax,(%esp)
c0104059:	e8 14 fc ff ff       	call   c0103c72 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010405e:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
c0104062:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104065:	89 d0                	mov    %edx,%eax
c0104067:	01 c0                	add    %eax,%eax
c0104069:	01 d0                	add    %edx,%eax
c010406b:	c1 e0 03             	shl    $0x3,%eax
c010406e:	89 c2                	mov    %eax,%edx
c0104070:	8b 45 08             	mov    0x8(%ebp),%eax
c0104073:	01 d0                	add    %edx,%eax
c0104075:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104078:	0f 85 47 ff ff ff    	jne    c0103fc5 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c010407e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104081:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104084:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104087:	8b 45 08             	mov    0x8(%ebp),%eax
c010408a:	83 c0 04             	add    $0x4,%eax
c010408d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104094:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104097:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010409a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010409d:	0f ab 10             	bts    %edx,(%eax)
c01040a0:	c7 45 cc 30 ba 11 c0 	movl   $0xc011ba30,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01040a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01040aa:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01040ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01040b0:	e9 06 01 00 00       	jmp    c01041bb <default_free_pages+0x234>
        p = le2page(le, page_link);
c01040b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040b8:	83 e8 10             	sub    $0x10,%eax
c01040bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01040be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040c7:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01040ca:	89 45 f0             	mov    %eax,-0x10(%ebp)

        //向后合并
        if (base + base->property == p) {
c01040cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01040d0:	8b 50 08             	mov    0x8(%eax),%edx
c01040d3:	89 d0                	mov    %edx,%eax
c01040d5:	01 c0                	add    %eax,%eax
c01040d7:	01 d0                	add    %edx,%eax
c01040d9:	c1 e0 03             	shl    $0x3,%eax
c01040dc:	89 c2                	mov    %eax,%edx
c01040de:	8b 45 08             	mov    0x8(%ebp),%eax
c01040e1:	01 d0                	add    %edx,%eax
c01040e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01040e6:	75 5a                	jne    c0104142 <default_free_pages+0x1bb>
            base->property += p->property;
c01040e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01040eb:	8b 50 08             	mov    0x8(%eax),%edx
c01040ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040f1:	8b 40 08             	mov    0x8(%eax),%eax
c01040f4:	01 c2                	add    %eax,%edx
c01040f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01040f9:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c01040fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040ff:	83 c0 04             	add    $0x4,%eax
c0104102:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104109:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010410c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010410f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104112:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104115:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104118:	83 c0 10             	add    $0x10,%eax
c010411b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010411e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104121:	8b 40 04             	mov    0x4(%eax),%eax
c0104124:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104127:	8b 12                	mov    (%edx),%edx
c0104129:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010412c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010412f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104132:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104135:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104138:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010413b:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010413e:	89 10                	mov    %edx,(%eax)
c0104140:	eb 79                	jmp    c01041bb <default_free_pages+0x234>
        }

        //向前合并
        else if (p + p->property == base) {
c0104142:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104145:	8b 50 08             	mov    0x8(%eax),%edx
c0104148:	89 d0                	mov    %edx,%eax
c010414a:	01 c0                	add    %eax,%eax
c010414c:	01 d0                	add    %edx,%eax
c010414e:	c1 e0 03             	shl    $0x3,%eax
c0104151:	89 c2                	mov    %eax,%edx
c0104153:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104156:	01 d0                	add    %edx,%eax
c0104158:	3b 45 08             	cmp    0x8(%ebp),%eax
c010415b:	75 5e                	jne    c01041bb <default_free_pages+0x234>
            p->property += base->property;
c010415d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104160:	8b 50 08             	mov    0x8(%eax),%edx
c0104163:	8b 45 08             	mov    0x8(%ebp),%eax
c0104166:	8b 40 08             	mov    0x8(%eax),%eax
c0104169:	01 c2                	add    %eax,%edx
c010416b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010416e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104171:	8b 45 08             	mov    0x8(%ebp),%eax
c0104174:	83 c0 04             	add    $0x4,%eax
c0104177:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c010417e:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104181:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104184:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104187:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c010418a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010418d:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104190:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104193:	83 c0 10             	add    $0x10,%eax
c0104196:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104199:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010419c:	8b 40 04             	mov    0x4(%eax),%eax
c010419f:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01041a2:	8b 12                	mov    (%edx),%edx
c01041a4:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01041a7:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01041aa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01041ad:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01041b0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01041b3:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01041b6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01041b9:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c01041bb:	81 7d f0 30 ba 11 c0 	cmpl   $0xc011ba30,-0x10(%ebp)
c01041c2:	0f 85 ed fe ff ff    	jne    c01040b5 <default_free_pages+0x12e>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c01041c8:	8b 15 38 ba 11 c0    	mov    0xc011ba38,%edx
c01041ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041d1:	01 d0                	add    %edx,%eax
c01041d3:	a3 38 ba 11 c0       	mov    %eax,0xc011ba38
c01041d8:	c7 45 9c 30 ba 11 c0 	movl   $0xc011ba30,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01041df:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01041e2:	8b 40 04             	mov    0x4(%eax),%eax

    //按地址顺序插入
    le=list_next(&free_list);
c01041e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le!=&free_list)
c01041e8:	eb 35                	jmp    c010421f <default_free_pages+0x298>
    {
    	p=le2page(le,page_link);
c01041ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041ed:	83 e8 10             	sub    $0x10,%eax
c01041f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if(base+base->property<=p)
c01041f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01041f6:	8b 50 08             	mov    0x8(%eax),%edx
c01041f9:	89 d0                	mov    %edx,%eax
c01041fb:	01 c0                	add    %eax,%eax
c01041fd:	01 d0                	add    %edx,%eax
c01041ff:	c1 e0 03             	shl    $0x3,%eax
c0104202:	89 c2                	mov    %eax,%edx
c0104204:	8b 45 08             	mov    0x8(%ebp),%eax
c0104207:	01 d0                	add    %edx,%eax
c0104209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010420c:	77 02                	ja     c0104210 <default_free_pages+0x289>
    	{
    		//assert(base+base->property!=p)
    		break;
c010420e:	eb 18                	jmp    c0104228 <default_free_pages+0x2a1>
c0104210:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104213:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104216:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104219:	8b 40 04             	mov    0x4(%eax),%eax
    	}
    	le=list_next(le);
c010421c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    nr_free += n;

    //按地址顺序插入
    le=list_next(&free_list);
    while(le!=&free_list)
c010421f:	81 7d f0 30 ba 11 c0 	cmpl   $0xc011ba30,-0x10(%ebp)
c0104226:	75 c2                	jne    c01041ea <default_free_pages+0x263>
    		//assert(base+base->property!=p)
    		break;
    	}
    	le=list_next(le);
    }
    list_add_before(le,&(base->page_link));
c0104228:	8b 45 08             	mov    0x8(%ebp),%eax
c010422b:	8d 50 10             	lea    0x10(%eax),%edx
c010422e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104231:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104234:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104237:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010423a:	8b 00                	mov    (%eax),%eax
c010423c:	8b 55 90             	mov    -0x70(%ebp),%edx
c010423f:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104242:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104245:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104248:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010424b:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010424e:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104251:	89 10                	mov    %edx,(%eax)
c0104253:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104256:	8b 10                	mov    (%eax),%edx
c0104258:	8b 45 88             	mov    -0x78(%ebp),%eax
c010425b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010425e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104261:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104264:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104267:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010426a:	8b 55 88             	mov    -0x78(%ebp),%edx
c010426d:	89 10                	mov    %edx,(%eax)
    //list_add(&free_list, &(base->page_link));
}
c010426f:	c9                   	leave  
c0104270:	c3                   	ret    

c0104271 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104271:	55                   	push   %ebp
c0104272:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104274:	a1 38 ba 11 c0       	mov    0xc011ba38,%eax
}
c0104279:	5d                   	pop    %ebp
c010427a:	c3                   	ret    

c010427b <basic_check>:

static void
basic_check(void) {
c010427b:	55                   	push   %ebp
c010427c:	89 e5                	mov    %esp,%ebp
c010427e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104281:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010428b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010428e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104291:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104294:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010429b:	e8 84 0e 00 00       	call   c0105124 <alloc_pages>
c01042a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01042a7:	75 24                	jne    c01042cd <basic_check+0x52>
c01042a9:	c7 44 24 0c 39 7e 10 	movl   $0xc0107e39,0xc(%esp)
c01042b0:	c0 
c01042b1:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01042b8:	c0 
c01042b9:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c01042c0:	00 
c01042c1:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c01042c8:	e8 04 ca ff ff       	call   c0100cd1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01042cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042d4:	e8 4b 0e 00 00       	call   c0105124 <alloc_pages>
c01042d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01042e0:	75 24                	jne    c0104306 <basic_check+0x8b>
c01042e2:	c7 44 24 0c 55 7e 10 	movl   $0xc0107e55,0xc(%esp)
c01042e9:	c0 
c01042ea:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01042f1:	c0 
c01042f2:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01042f9:	00 
c01042fa:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104301:	e8 cb c9 ff ff       	call   c0100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104306:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010430d:	e8 12 0e 00 00       	call   c0105124 <alloc_pages>
c0104312:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104319:	75 24                	jne    c010433f <basic_check+0xc4>
c010431b:	c7 44 24 0c 71 7e 10 	movl   $0xc0107e71,0xc(%esp)
c0104322:	c0 
c0104323:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010432a:	c0 
c010432b:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0104332:	00 
c0104333:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010433a:	e8 92 c9 ff ff       	call   c0100cd1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010433f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104342:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104345:	74 10                	je     c0104357 <basic_check+0xdc>
c0104347:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010434a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010434d:	74 08                	je     c0104357 <basic_check+0xdc>
c010434f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104352:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104355:	75 24                	jne    c010437b <basic_check+0x100>
c0104357:	c7 44 24 0c 90 7e 10 	movl   $0xc0107e90,0xc(%esp)
c010435e:	c0 
c010435f:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104366:	c0 
c0104367:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c010436e:	00 
c010436f:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104376:	e8 56 c9 ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010437b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010437e:	89 04 24             	mov    %eax,(%esp)
c0104381:	e8 e2 f8 ff ff       	call   c0103c68 <page_ref>
c0104386:	85 c0                	test   %eax,%eax
c0104388:	75 1e                	jne    c01043a8 <basic_check+0x12d>
c010438a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010438d:	89 04 24             	mov    %eax,(%esp)
c0104390:	e8 d3 f8 ff ff       	call   c0103c68 <page_ref>
c0104395:	85 c0                	test   %eax,%eax
c0104397:	75 0f                	jne    c01043a8 <basic_check+0x12d>
c0104399:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439c:	89 04 24             	mov    %eax,(%esp)
c010439f:	e8 c4 f8 ff ff       	call   c0103c68 <page_ref>
c01043a4:	85 c0                	test   %eax,%eax
c01043a6:	74 24                	je     c01043cc <basic_check+0x151>
c01043a8:	c7 44 24 0c b4 7e 10 	movl   $0xc0107eb4,0xc(%esp)
c01043af:	c0 
c01043b0:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01043b7:	c0 
c01043b8:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01043bf:	00 
c01043c0:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c01043c7:	e8 05 c9 ff ff       	call   c0100cd1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01043cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043cf:	89 04 24             	mov    %eax,(%esp)
c01043d2:	e8 7b f8 ff ff       	call   c0103c52 <page2pa>
c01043d7:	8b 15 a0 b9 11 c0    	mov    0xc011b9a0,%edx
c01043dd:	c1 e2 0c             	shl    $0xc,%edx
c01043e0:	39 d0                	cmp    %edx,%eax
c01043e2:	72 24                	jb     c0104408 <basic_check+0x18d>
c01043e4:	c7 44 24 0c f0 7e 10 	movl   $0xc0107ef0,0xc(%esp)
c01043eb:	c0 
c01043ec:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01043f3:	c0 
c01043f4:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01043fb:	00 
c01043fc:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104403:	e8 c9 c8 ff ff       	call   c0100cd1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104408:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010440b:	89 04 24             	mov    %eax,(%esp)
c010440e:	e8 3f f8 ff ff       	call   c0103c52 <page2pa>
c0104413:	8b 15 a0 b9 11 c0    	mov    0xc011b9a0,%edx
c0104419:	c1 e2 0c             	shl    $0xc,%edx
c010441c:	39 d0                	cmp    %edx,%eax
c010441e:	72 24                	jb     c0104444 <basic_check+0x1c9>
c0104420:	c7 44 24 0c 0d 7f 10 	movl   $0xc0107f0d,0xc(%esp)
c0104427:	c0 
c0104428:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010442f:	c0 
c0104430:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0104437:	00 
c0104438:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010443f:	e8 8d c8 ff ff       	call   c0100cd1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104444:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104447:	89 04 24             	mov    %eax,(%esp)
c010444a:	e8 03 f8 ff ff       	call   c0103c52 <page2pa>
c010444f:	8b 15 a0 b9 11 c0    	mov    0xc011b9a0,%edx
c0104455:	c1 e2 0c             	shl    $0xc,%edx
c0104458:	39 d0                	cmp    %edx,%eax
c010445a:	72 24                	jb     c0104480 <basic_check+0x205>
c010445c:	c7 44 24 0c 2a 7f 10 	movl   $0xc0107f2a,0xc(%esp)
c0104463:	c0 
c0104464:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010446b:	c0 
c010446c:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0104473:	00 
c0104474:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010447b:	e8 51 c8 ff ff       	call   c0100cd1 <__panic>

    list_entry_t free_list_store = free_list;
c0104480:	a1 30 ba 11 c0       	mov    0xc011ba30,%eax
c0104485:	8b 15 34 ba 11 c0    	mov    0xc011ba34,%edx
c010448b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010448e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104491:	c7 45 e0 30 ba 11 c0 	movl   $0xc011ba30,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104498:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010449b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010449e:	89 50 04             	mov    %edx,0x4(%eax)
c01044a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044a4:	8b 50 04             	mov    0x4(%eax),%edx
c01044a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044aa:	89 10                	mov    %edx,(%eax)
c01044ac:	c7 45 dc 30 ba 11 c0 	movl   $0xc011ba30,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01044b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01044b6:	8b 40 04             	mov    0x4(%eax),%eax
c01044b9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01044bc:	0f 94 c0             	sete   %al
c01044bf:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01044c2:	85 c0                	test   %eax,%eax
c01044c4:	75 24                	jne    c01044ea <basic_check+0x26f>
c01044c6:	c7 44 24 0c 47 7f 10 	movl   $0xc0107f47,0xc(%esp)
c01044cd:	c0 
c01044ce:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01044d5:	c0 
c01044d6:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01044dd:	00 
c01044de:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c01044e5:	e8 e7 c7 ff ff       	call   c0100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
c01044ea:	a1 38 ba 11 c0       	mov    0xc011ba38,%eax
c01044ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01044f2:	c7 05 38 ba 11 c0 00 	movl   $0x0,0xc011ba38
c01044f9:	00 00 00 

    assert(alloc_page() == NULL);
c01044fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104503:	e8 1c 0c 00 00       	call   c0105124 <alloc_pages>
c0104508:	85 c0                	test   %eax,%eax
c010450a:	74 24                	je     c0104530 <basic_check+0x2b5>
c010450c:	c7 44 24 0c 5e 7f 10 	movl   $0xc0107f5e,0xc(%esp)
c0104513:	c0 
c0104514:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010451b:	c0 
c010451c:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0104523:	00 
c0104524:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010452b:	e8 a1 c7 ff ff       	call   c0100cd1 <__panic>

    free_page(p0);
c0104530:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104537:	00 
c0104538:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010453b:	89 04 24             	mov    %eax,(%esp)
c010453e:	e8 19 0c 00 00       	call   c010515c <free_pages>
    free_page(p1);
c0104543:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010454a:	00 
c010454b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010454e:	89 04 24             	mov    %eax,(%esp)
c0104551:	e8 06 0c 00 00       	call   c010515c <free_pages>
    free_page(p2);
c0104556:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010455d:	00 
c010455e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104561:	89 04 24             	mov    %eax,(%esp)
c0104564:	e8 f3 0b 00 00       	call   c010515c <free_pages>
    assert(nr_free == 3);
c0104569:	a1 38 ba 11 c0       	mov    0xc011ba38,%eax
c010456e:	83 f8 03             	cmp    $0x3,%eax
c0104571:	74 24                	je     c0104597 <basic_check+0x31c>
c0104573:	c7 44 24 0c 73 7f 10 	movl   $0xc0107f73,0xc(%esp)
c010457a:	c0 
c010457b:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104582:	c0 
c0104583:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c010458a:	00 
c010458b:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104592:	e8 3a c7 ff ff       	call   c0100cd1 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104597:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010459e:	e8 81 0b 00 00       	call   c0105124 <alloc_pages>
c01045a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01045a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01045aa:	75 24                	jne    c01045d0 <basic_check+0x355>
c01045ac:	c7 44 24 0c 39 7e 10 	movl   $0xc0107e39,0xc(%esp)
c01045b3:	c0 
c01045b4:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01045bb:	c0 
c01045bc:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01045c3:	00 
c01045c4:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c01045cb:	e8 01 c7 ff ff       	call   c0100cd1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01045d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01045d7:	e8 48 0b 00 00       	call   c0105124 <alloc_pages>
c01045dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01045e3:	75 24                	jne    c0104609 <basic_check+0x38e>
c01045e5:	c7 44 24 0c 55 7e 10 	movl   $0xc0107e55,0xc(%esp)
c01045ec:	c0 
c01045ed:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01045f4:	c0 
c01045f5:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c01045fc:	00 
c01045fd:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104604:	e8 c8 c6 ff ff       	call   c0100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104609:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104610:	e8 0f 0b 00 00       	call   c0105124 <alloc_pages>
c0104615:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010461c:	75 24                	jne    c0104642 <basic_check+0x3c7>
c010461e:	c7 44 24 0c 71 7e 10 	movl   $0xc0107e71,0xc(%esp)
c0104625:	c0 
c0104626:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010462d:	c0 
c010462e:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0104635:	00 
c0104636:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010463d:	e8 8f c6 ff ff       	call   c0100cd1 <__panic>

    assert(alloc_page() == NULL);
c0104642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104649:	e8 d6 0a 00 00       	call   c0105124 <alloc_pages>
c010464e:	85 c0                	test   %eax,%eax
c0104650:	74 24                	je     c0104676 <basic_check+0x3fb>
c0104652:	c7 44 24 0c 5e 7f 10 	movl   $0xc0107f5e,0xc(%esp)
c0104659:	c0 
c010465a:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104661:	c0 
c0104662:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104669:	00 
c010466a:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104671:	e8 5b c6 ff ff       	call   c0100cd1 <__panic>

    free_page(p0);
c0104676:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010467d:	00 
c010467e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104681:	89 04 24             	mov    %eax,(%esp)
c0104684:	e8 d3 0a 00 00       	call   c010515c <free_pages>
c0104689:	c7 45 d8 30 ba 11 c0 	movl   $0xc011ba30,-0x28(%ebp)
c0104690:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104693:	8b 40 04             	mov    0x4(%eax),%eax
c0104696:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104699:	0f 94 c0             	sete   %al
c010469c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010469f:	85 c0                	test   %eax,%eax
c01046a1:	74 24                	je     c01046c7 <basic_check+0x44c>
c01046a3:	c7 44 24 0c 80 7f 10 	movl   $0xc0107f80,0xc(%esp)
c01046aa:	c0 
c01046ab:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01046b2:	c0 
c01046b3:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01046ba:	00 
c01046bb:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c01046c2:	e8 0a c6 ff ff       	call   c0100cd1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01046c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046ce:	e8 51 0a 00 00       	call   c0105124 <alloc_pages>
c01046d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01046d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01046dc:	74 24                	je     c0104702 <basic_check+0x487>
c01046de:	c7 44 24 0c 98 7f 10 	movl   $0xc0107f98,0xc(%esp)
c01046e5:	c0 
c01046e6:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01046ed:	c0 
c01046ee:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01046f5:	00 
c01046f6:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c01046fd:	e8 cf c5 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c0104702:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104709:	e8 16 0a 00 00       	call   c0105124 <alloc_pages>
c010470e:	85 c0                	test   %eax,%eax
c0104710:	74 24                	je     c0104736 <basic_check+0x4bb>
c0104712:	c7 44 24 0c 5e 7f 10 	movl   $0xc0107f5e,0xc(%esp)
c0104719:	c0 
c010471a:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104721:	c0 
c0104722:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104729:	00 
c010472a:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104731:	e8 9b c5 ff ff       	call   c0100cd1 <__panic>

    assert(nr_free == 0);
c0104736:	a1 38 ba 11 c0       	mov    0xc011ba38,%eax
c010473b:	85 c0                	test   %eax,%eax
c010473d:	74 24                	je     c0104763 <basic_check+0x4e8>
c010473f:	c7 44 24 0c b1 7f 10 	movl   $0xc0107fb1,0xc(%esp)
c0104746:	c0 
c0104747:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010474e:	c0 
c010474f:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0104756:	00 
c0104757:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010475e:	e8 6e c5 ff ff       	call   c0100cd1 <__panic>
    free_list = free_list_store;
c0104763:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104766:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104769:	a3 30 ba 11 c0       	mov    %eax,0xc011ba30
c010476e:	89 15 34 ba 11 c0    	mov    %edx,0xc011ba34
    nr_free = nr_free_store;
c0104774:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104777:	a3 38 ba 11 c0       	mov    %eax,0xc011ba38

    free_page(p);
c010477c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104783:	00 
c0104784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104787:	89 04 24             	mov    %eax,(%esp)
c010478a:	e8 cd 09 00 00       	call   c010515c <free_pages>
    free_page(p1);
c010478f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104796:	00 
c0104797:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010479a:	89 04 24             	mov    %eax,(%esp)
c010479d:	e8 ba 09 00 00       	call   c010515c <free_pages>
    free_page(p2);
c01047a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01047a9:	00 
c01047aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ad:	89 04 24             	mov    %eax,(%esp)
c01047b0:	e8 a7 09 00 00       	call   c010515c <free_pages>
}
c01047b5:	c9                   	leave  
c01047b6:	c3                   	ret    

c01047b7 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01047b7:	55                   	push   %ebp
c01047b8:	89 e5                	mov    %esp,%ebp
c01047ba:	53                   	push   %ebx
c01047bb:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01047c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01047c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01047cf:	c7 45 ec 30 ba 11 c0 	movl   $0xc011ba30,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01047d6:	eb 6b                	jmp    c0104843 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01047d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047db:	83 e8 10             	sub    $0x10,%eax
c01047de:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01047e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047e4:	83 c0 04             	add    $0x4,%eax
c01047e7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01047ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01047f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01047f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01047f7:	0f a3 10             	bt     %edx,(%eax)
c01047fa:	19 c0                	sbb    %eax,%eax
c01047fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01047ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104803:	0f 95 c0             	setne  %al
c0104806:	0f b6 c0             	movzbl %al,%eax
c0104809:	85 c0                	test   %eax,%eax
c010480b:	75 24                	jne    c0104831 <default_check+0x7a>
c010480d:	c7 44 24 0c be 7f 10 	movl   $0xc0107fbe,0xc(%esp)
c0104814:	c0 
c0104815:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010481c:	c0 
c010481d:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0104824:	00 
c0104825:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010482c:	e8 a0 c4 ff ff       	call   c0100cd1 <__panic>
        count ++, total += p->property;
c0104831:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104835:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104838:	8b 50 08             	mov    0x8(%eax),%edx
c010483b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010483e:	01 d0                	add    %edx,%eax
c0104840:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104843:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104846:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104849:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010484c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010484f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104852:	81 7d ec 30 ba 11 c0 	cmpl   $0xc011ba30,-0x14(%ebp)
c0104859:	0f 85 79 ff ff ff    	jne    c01047d8 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010485f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0104862:	e8 27 09 00 00       	call   c010518e <nr_free_pages>
c0104867:	39 c3                	cmp    %eax,%ebx
c0104869:	74 24                	je     c010488f <default_check+0xd8>
c010486b:	c7 44 24 0c ce 7f 10 	movl   $0xc0107fce,0xc(%esp)
c0104872:	c0 
c0104873:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c010487a:	c0 
c010487b:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0104882:	00 
c0104883:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c010488a:	e8 42 c4 ff ff       	call   c0100cd1 <__panic>

    basic_check();
c010488f:	e8 e7 f9 ff ff       	call   c010427b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104894:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010489b:	e8 84 08 00 00       	call   c0105124 <alloc_pages>
c01048a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01048a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01048a7:	75 24                	jne    c01048cd <default_check+0x116>
c01048a9:	c7 44 24 0c e7 7f 10 	movl   $0xc0107fe7,0xc(%esp)
c01048b0:	c0 
c01048b1:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01048b8:	c0 
c01048b9:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01048c0:	00 
c01048c1:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c01048c8:	e8 04 c4 ff ff       	call   c0100cd1 <__panic>
    assert(!PageProperty(p0));
c01048cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048d0:	83 c0 04             	add    $0x4,%eax
c01048d3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01048da:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01048dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01048e0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01048e3:	0f a3 10             	bt     %edx,(%eax)
c01048e6:	19 c0                	sbb    %eax,%eax
c01048e8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01048eb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01048ef:	0f 95 c0             	setne  %al
c01048f2:	0f b6 c0             	movzbl %al,%eax
c01048f5:	85 c0                	test   %eax,%eax
c01048f7:	74 24                	je     c010491d <default_check+0x166>
c01048f9:	c7 44 24 0c f2 7f 10 	movl   $0xc0107ff2,0xc(%esp)
c0104900:	c0 
c0104901:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104908:	c0 
c0104909:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0104910:	00 
c0104911:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104918:	e8 b4 c3 ff ff       	call   c0100cd1 <__panic>

    list_entry_t free_list_store = free_list;
c010491d:	a1 30 ba 11 c0       	mov    0xc011ba30,%eax
c0104922:	8b 15 34 ba 11 c0    	mov    0xc011ba34,%edx
c0104928:	89 45 80             	mov    %eax,-0x80(%ebp)
c010492b:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010492e:	c7 45 b4 30 ba 11 c0 	movl   $0xc011ba30,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104935:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104938:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010493b:	89 50 04             	mov    %edx,0x4(%eax)
c010493e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104941:	8b 50 04             	mov    0x4(%eax),%edx
c0104944:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104947:	89 10                	mov    %edx,(%eax)
c0104949:	c7 45 b0 30 ba 11 c0 	movl   $0xc011ba30,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104950:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104953:	8b 40 04             	mov    0x4(%eax),%eax
c0104956:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0104959:	0f 94 c0             	sete   %al
c010495c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010495f:	85 c0                	test   %eax,%eax
c0104961:	75 24                	jne    c0104987 <default_check+0x1d0>
c0104963:	c7 44 24 0c 47 7f 10 	movl   $0xc0107f47,0xc(%esp)
c010496a:	c0 
c010496b:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104972:	c0 
c0104973:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c010497a:	00 
c010497b:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104982:	e8 4a c3 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c0104987:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010498e:	e8 91 07 00 00       	call   c0105124 <alloc_pages>
c0104993:	85 c0                	test   %eax,%eax
c0104995:	74 24                	je     c01049bb <default_check+0x204>
c0104997:	c7 44 24 0c 5e 7f 10 	movl   $0xc0107f5e,0xc(%esp)
c010499e:	c0 
c010499f:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c01049a6:	c0 
c01049a7:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01049ae:	00 
c01049af:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c01049b6:	e8 16 c3 ff ff       	call   c0100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
c01049bb:	a1 38 ba 11 c0       	mov    0xc011ba38,%eax
c01049c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01049c3:	c7 05 38 ba 11 c0 00 	movl   $0x0,0xc011ba38
c01049ca:	00 00 00 

    free_pages(p0 + 2, 3);
c01049cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049d0:	83 c0 30             	add    $0x30,%eax
c01049d3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01049da:	00 
c01049db:	89 04 24             	mov    %eax,(%esp)
c01049de:	e8 79 07 00 00       	call   c010515c <free_pages>
    assert(alloc_pages(4) == NULL);
c01049e3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01049ea:	e8 35 07 00 00       	call   c0105124 <alloc_pages>
c01049ef:	85 c0                	test   %eax,%eax
c01049f1:	74 24                	je     c0104a17 <default_check+0x260>
c01049f3:	c7 44 24 0c 04 80 10 	movl   $0xc0108004,0xc(%esp)
c01049fa:	c0 
c01049fb:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104a02:	c0 
c0104a03:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104a0a:	00 
c0104a0b:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104a12:	e8 ba c2 ff ff       	call   c0100cd1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a1a:	83 c0 30             	add    $0x30,%eax
c0104a1d:	83 c0 04             	add    $0x4,%eax
c0104a20:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104a27:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a2a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104a2d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104a30:	0f a3 10             	bt     %edx,(%eax)
c0104a33:	19 c0                	sbb    %eax,%eax
c0104a35:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104a38:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104a3c:	0f 95 c0             	setne  %al
c0104a3f:	0f b6 c0             	movzbl %al,%eax
c0104a42:	85 c0                	test   %eax,%eax
c0104a44:	74 0e                	je     c0104a54 <default_check+0x29d>
c0104a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a49:	83 c0 30             	add    $0x30,%eax
c0104a4c:	8b 40 08             	mov    0x8(%eax),%eax
c0104a4f:	83 f8 03             	cmp    $0x3,%eax
c0104a52:	74 24                	je     c0104a78 <default_check+0x2c1>
c0104a54:	c7 44 24 0c 1c 80 10 	movl   $0xc010801c,0xc(%esp)
c0104a5b:	c0 
c0104a5c:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104a63:	c0 
c0104a64:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0104a6b:	00 
c0104a6c:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104a73:	e8 59 c2 ff ff       	call   c0100cd1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104a78:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104a7f:	e8 a0 06 00 00       	call   c0105124 <alloc_pages>
c0104a84:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104a87:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104a8b:	75 24                	jne    c0104ab1 <default_check+0x2fa>
c0104a8d:	c7 44 24 0c 48 80 10 	movl   $0xc0108048,0xc(%esp)
c0104a94:	c0 
c0104a95:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104a9c:	c0 
c0104a9d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104aa4:	00 
c0104aa5:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104aac:	e8 20 c2 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c0104ab1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ab8:	e8 67 06 00 00       	call   c0105124 <alloc_pages>
c0104abd:	85 c0                	test   %eax,%eax
c0104abf:	74 24                	je     c0104ae5 <default_check+0x32e>
c0104ac1:	c7 44 24 0c 5e 7f 10 	movl   $0xc0107f5e,0xc(%esp)
c0104ac8:	c0 
c0104ac9:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104ad0:	c0 
c0104ad1:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0104ad8:	00 
c0104ad9:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104ae0:	e8 ec c1 ff ff       	call   c0100cd1 <__panic>
    assert(p0 + 2 == p1);
c0104ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ae8:	83 c0 30             	add    $0x30,%eax
c0104aeb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104aee:	74 24                	je     c0104b14 <default_check+0x35d>
c0104af0:	c7 44 24 0c 66 80 10 	movl   $0xc0108066,0xc(%esp)
c0104af7:	c0 
c0104af8:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104aff:	c0 
c0104b00:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104b07:	00 
c0104b08:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104b0f:	e8 bd c1 ff ff       	call   c0100cd1 <__panic>

    p2 = p0 + 1;
c0104b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b17:	83 c0 18             	add    $0x18,%eax
c0104b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0104b1d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b24:	00 
c0104b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b28:	89 04 24             	mov    %eax,(%esp)
c0104b2b:	e8 2c 06 00 00       	call   c010515c <free_pages>
    free_pages(p1, 3);
c0104b30:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104b37:	00 
c0104b38:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b3b:	89 04 24             	mov    %eax,(%esp)
c0104b3e:	e8 19 06 00 00       	call   c010515c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b46:	83 c0 04             	add    $0x4,%eax
c0104b49:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104b50:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b53:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104b56:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104b59:	0f a3 10             	bt     %edx,(%eax)
c0104b5c:	19 c0                	sbb    %eax,%eax
c0104b5e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104b61:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104b65:	0f 95 c0             	setne  %al
c0104b68:	0f b6 c0             	movzbl %al,%eax
c0104b6b:	85 c0                	test   %eax,%eax
c0104b6d:	74 0b                	je     c0104b7a <default_check+0x3c3>
c0104b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b72:	8b 40 08             	mov    0x8(%eax),%eax
c0104b75:	83 f8 01             	cmp    $0x1,%eax
c0104b78:	74 24                	je     c0104b9e <default_check+0x3e7>
c0104b7a:	c7 44 24 0c 74 80 10 	movl   $0xc0108074,0xc(%esp)
c0104b81:	c0 
c0104b82:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104b89:	c0 
c0104b8a:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104b91:	00 
c0104b92:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104b99:	e8 33 c1 ff ff       	call   c0100cd1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104b9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ba1:	83 c0 04             	add    $0x4,%eax
c0104ba4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104bab:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104bae:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104bb1:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104bb4:	0f a3 10             	bt     %edx,(%eax)
c0104bb7:	19 c0                	sbb    %eax,%eax
c0104bb9:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104bbc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104bc0:	0f 95 c0             	setne  %al
c0104bc3:	0f b6 c0             	movzbl %al,%eax
c0104bc6:	85 c0                	test   %eax,%eax
c0104bc8:	74 0b                	je     c0104bd5 <default_check+0x41e>
c0104bca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104bcd:	8b 40 08             	mov    0x8(%eax),%eax
c0104bd0:	83 f8 03             	cmp    $0x3,%eax
c0104bd3:	74 24                	je     c0104bf9 <default_check+0x442>
c0104bd5:	c7 44 24 0c 9c 80 10 	movl   $0xc010809c,0xc(%esp)
c0104bdc:	c0 
c0104bdd:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104be4:	c0 
c0104be5:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0104bec:	00 
c0104bed:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104bf4:	e8 d8 c0 ff ff       	call   c0100cd1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104bf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c00:	e8 1f 05 00 00       	call   c0105124 <alloc_pages>
c0104c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104c0b:	83 e8 18             	sub    $0x18,%eax
c0104c0e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104c11:	74 24                	je     c0104c37 <default_check+0x480>
c0104c13:	c7 44 24 0c c2 80 10 	movl   $0xc01080c2,0xc(%esp)
c0104c1a:	c0 
c0104c1b:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104c22:	c0 
c0104c23:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104c2a:	00 
c0104c2b:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104c32:	e8 9a c0 ff ff       	call   c0100cd1 <__panic>
    free_page(p0);
c0104c37:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c3e:	00 
c0104c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c42:	89 04 24             	mov    %eax,(%esp)
c0104c45:	e8 12 05 00 00       	call   c010515c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104c4a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104c51:	e8 ce 04 00 00       	call   c0105124 <alloc_pages>
c0104c56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104c5c:	83 c0 18             	add    $0x18,%eax
c0104c5f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104c62:	74 24                	je     c0104c88 <default_check+0x4d1>
c0104c64:	c7 44 24 0c e0 80 10 	movl   $0xc01080e0,0xc(%esp)
c0104c6b:	c0 
c0104c6c:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104c73:	c0 
c0104c74:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104c7b:	00 
c0104c7c:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104c83:	e8 49 c0 ff ff       	call   c0100cd1 <__panic>

    free_pages(p0, 2);
c0104c88:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104c8f:	00 
c0104c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c93:	89 04 24             	mov    %eax,(%esp)
c0104c96:	e8 c1 04 00 00       	call   c010515c <free_pages>
    free_page(p2);
c0104c9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ca2:	00 
c0104ca3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ca6:	89 04 24             	mov    %eax,(%esp)
c0104ca9:	e8 ae 04 00 00       	call   c010515c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104cae:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104cb5:	e8 6a 04 00 00       	call   c0105124 <alloc_pages>
c0104cba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104cbd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104cc1:	75 24                	jne    c0104ce7 <default_check+0x530>
c0104cc3:	c7 44 24 0c 00 81 10 	movl   $0xc0108100,0xc(%esp)
c0104cca:	c0 
c0104ccb:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104cd2:	c0 
c0104cd3:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104cda:	00 
c0104cdb:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104ce2:	e8 ea bf ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c0104ce7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cee:	e8 31 04 00 00       	call   c0105124 <alloc_pages>
c0104cf3:	85 c0                	test   %eax,%eax
c0104cf5:	74 24                	je     c0104d1b <default_check+0x564>
c0104cf7:	c7 44 24 0c 5e 7f 10 	movl   $0xc0107f5e,0xc(%esp)
c0104cfe:	c0 
c0104cff:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104d06:	c0 
c0104d07:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0104d0e:	00 
c0104d0f:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104d16:	e8 b6 bf ff ff       	call   c0100cd1 <__panic>

    assert(nr_free == 0);
c0104d1b:	a1 38 ba 11 c0       	mov    0xc011ba38,%eax
c0104d20:	85 c0                	test   %eax,%eax
c0104d22:	74 24                	je     c0104d48 <default_check+0x591>
c0104d24:	c7 44 24 0c b1 7f 10 	movl   $0xc0107fb1,0xc(%esp)
c0104d2b:	c0 
c0104d2c:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104d33:	c0 
c0104d34:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0104d3b:	00 
c0104d3c:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104d43:	e8 89 bf ff ff       	call   c0100cd1 <__panic>
    nr_free = nr_free_store;
c0104d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d4b:	a3 38 ba 11 c0       	mov    %eax,0xc011ba38

    free_list = free_list_store;
c0104d50:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104d53:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104d56:	a3 30 ba 11 c0       	mov    %eax,0xc011ba30
c0104d5b:	89 15 34 ba 11 c0    	mov    %edx,0xc011ba34
    free_pages(p0, 5);
c0104d61:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104d68:	00 
c0104d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d6c:	89 04 24             	mov    %eax,(%esp)
c0104d6f:	e8 e8 03 00 00       	call   c010515c <free_pages>

    le = &free_list;
c0104d74:	c7 45 ec 30 ba 11 c0 	movl   $0xc011ba30,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104d7b:	eb 1d                	jmp    c0104d9a <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d80:	83 e8 10             	sub    $0x10,%eax
c0104d83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104d86:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104d8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104d8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104d90:	8b 40 08             	mov    0x8(%eax),%eax
c0104d93:	29 c2                	sub    %eax,%edx
c0104d95:	89 d0                	mov    %edx,%eax
c0104d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d9d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104da0:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104da3:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104da9:	81 7d ec 30 ba 11 c0 	cmpl   $0xc011ba30,-0x14(%ebp)
c0104db0:	75 cb                	jne    c0104d7d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104db6:	74 24                	je     c0104ddc <default_check+0x625>
c0104db8:	c7 44 24 0c 1e 81 10 	movl   $0xc010811e,0xc(%esp)
c0104dbf:	c0 
c0104dc0:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104dc7:	c0 
c0104dc8:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0104dcf:	00 
c0104dd0:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104dd7:	e8 f5 be ff ff       	call   c0100cd1 <__panic>
    assert(total == 0);
c0104ddc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104de0:	74 24                	je     c0104e06 <default_check+0x64f>
c0104de2:	c7 44 24 0c 29 81 10 	movl   $0xc0108129,0xc(%esp)
c0104de9:	c0 
c0104dea:	c7 44 24 08 d6 7d 10 	movl   $0xc0107dd6,0x8(%esp)
c0104df1:	c0 
c0104df2:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0104df9:	00 
c0104dfa:	c7 04 24 eb 7d 10 c0 	movl   $0xc0107deb,(%esp)
c0104e01:	e8 cb be ff ff       	call   c0100cd1 <__panic>
}
c0104e06:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104e0c:	5b                   	pop    %ebx
c0104e0d:	5d                   	pop    %ebp
c0104e0e:	c3                   	ret    

c0104e0f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104e0f:	55                   	push   %ebp
c0104e10:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104e12:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e15:	a1 44 ba 11 c0       	mov    0xc011ba44,%eax
c0104e1a:	29 c2                	sub    %eax,%edx
c0104e1c:	89 d0                	mov    %edx,%eax
c0104e1e:	c1 f8 03             	sar    $0x3,%eax
c0104e21:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
c0104e27:	5d                   	pop    %ebp
c0104e28:	c3                   	ret    

c0104e29 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104e29:	55                   	push   %ebp
c0104e2a:	89 e5                	mov    %esp,%ebp
c0104e2c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e32:	89 04 24             	mov    %eax,(%esp)
c0104e35:	e8 d5 ff ff ff       	call   c0104e0f <page2ppn>
c0104e3a:	c1 e0 0c             	shl    $0xc,%eax
}
c0104e3d:	c9                   	leave  
c0104e3e:	c3                   	ret    

c0104e3f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104e3f:	55                   	push   %ebp
c0104e40:	89 e5                	mov    %esp,%ebp
c0104e42:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {//mmu.h
c0104e45:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e48:	c1 e8 0c             	shr    $0xc,%eax
c0104e4b:	89 c2                	mov    %eax,%edx
c0104e4d:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c0104e52:	39 c2                	cmp    %eax,%edx
c0104e54:	72 1c                	jb     c0104e72 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104e56:	c7 44 24 08 64 81 10 	movl   $0xc0108164,0x8(%esp)
c0104e5d:	c0 
c0104e5e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0104e65:	00 
c0104e66:	c7 04 24 83 81 10 c0 	movl   $0xc0108183,(%esp)
c0104e6d:	e8 5f be ff ff       	call   c0100cd1 <__panic>
    }
    return &pages[PPN(pa)];
c0104e72:	8b 0d 44 ba 11 c0    	mov    0xc011ba44,%ecx
c0104e78:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e7b:	c1 e8 0c             	shr    $0xc,%eax
c0104e7e:	89 c2                	mov    %eax,%edx
c0104e80:	89 d0                	mov    %edx,%eax
c0104e82:	01 c0                	add    %eax,%eax
c0104e84:	01 d0                	add    %edx,%eax
c0104e86:	c1 e0 03             	shl    $0x3,%eax
c0104e89:	01 c8                	add    %ecx,%eax
}
c0104e8b:	c9                   	leave  
c0104e8c:	c3                   	ret    

c0104e8d <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104e8d:	55                   	push   %ebp
c0104e8e:	89 e5                	mov    %esp,%ebp
c0104e90:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));//pmm.h
c0104e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e96:	89 04 24             	mov    %eax,(%esp)
c0104e99:	e8 8b ff ff ff       	call   c0104e29 <page2pa>
c0104e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ea4:	c1 e8 0c             	shr    $0xc,%eax
c0104ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104eaa:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c0104eaf:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104eb2:	72 23                	jb     c0104ed7 <page2kva+0x4a>
c0104eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ebb:	c7 44 24 08 94 81 10 	movl   $0xc0108194,0x8(%esp)
c0104ec2:	c0 
c0104ec3:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0104eca:	00 
c0104ecb:	c7 04 24 83 81 10 c0 	movl   $0xc0108183,(%esp)
c0104ed2:	e8 fa bd ff ff       	call   c0100cd1 <__panic>
c0104ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eda:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104edf:	c9                   	leave  
c0104ee0:	c3                   	ret    

c0104ee1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104ee1:	55                   	push   %ebp
c0104ee2:	89 e5                	mov    %esp,%ebp
c0104ee4:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104ee7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eea:	83 e0 01             	and    $0x1,%eax
c0104eed:	85 c0                	test   %eax,%eax
c0104eef:	75 1c                	jne    c0104f0d <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104ef1:	c7 44 24 08 b8 81 10 	movl   $0xc01081b8,0x8(%esp)
c0104ef8:	c0 
c0104ef9:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0104f00:	00 
c0104f01:	c7 04 24 83 81 10 c0 	movl   $0xc0108183,(%esp)
c0104f08:	e8 c4 bd ff ff       	call   c0100cd1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104f0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f15:	89 04 24             	mov    %eax,(%esp)
c0104f18:	e8 22 ff ff ff       	call   c0104e3f <pa2page>
}
c0104f1d:	c9                   	leave  
c0104f1e:	c3                   	ret    

c0104f1f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104f1f:	55                   	push   %ebp
c0104f20:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104f22:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f25:	8b 00                	mov    (%eax),%eax
}
c0104f27:	5d                   	pop    %ebp
c0104f28:	c3                   	ret    

c0104f29 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104f29:	55                   	push   %ebp
c0104f2a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104f32:	89 10                	mov    %edx,(%eax)
}
c0104f34:	5d                   	pop    %ebp
c0104f35:	c3                   	ret    

c0104f36 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104f36:	55                   	push   %ebp
c0104f37:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104f39:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f3c:	8b 00                	mov    (%eax),%eax
c0104f3e:	8d 50 01             	lea    0x1(%eax),%edx
c0104f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f44:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104f46:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f49:	8b 00                	mov    (%eax),%eax
}
c0104f4b:	5d                   	pop    %ebp
c0104f4c:	c3                   	ret    

c0104f4d <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104f4d:	55                   	push   %ebp
c0104f4e:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104f50:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f53:	8b 00                	mov    (%eax),%eax
c0104f55:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104f58:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f5b:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104f5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f60:	8b 00                	mov    (%eax),%eax
}
c0104f62:	5d                   	pop    %ebp
c0104f63:	c3                   	ret    

c0104f64 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104f64:	55                   	push   %ebp
c0104f65:	89 e5                	mov    %esp,%ebp
c0104f67:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104f6a:	9c                   	pushf  
c0104f6b:	58                   	pop    %eax
c0104f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104f72:	25 00 02 00 00       	and    $0x200,%eax
c0104f77:	85 c0                	test   %eax,%eax
c0104f79:	74 0c                	je     c0104f87 <__intr_save+0x23>
        intr_disable();
c0104f7b:	e8 34 c7 ff ff       	call   c01016b4 <intr_disable>
        return 1;
c0104f80:	b8 01 00 00 00       	mov    $0x1,%eax
c0104f85:	eb 05                	jmp    c0104f8c <__intr_save+0x28>
    }
    return 0;
c0104f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f8c:	c9                   	leave  
c0104f8d:	c3                   	ret    

c0104f8e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104f8e:	55                   	push   %ebp
c0104f8f:	89 e5                	mov    %esp,%ebp
c0104f91:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104f94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104f98:	74 05                	je     c0104f9f <__intr_restore+0x11>
        intr_enable();
c0104f9a:	e8 0f c7 ff ff       	call   c01016ae <intr_enable>
    }
}
c0104f9f:	c9                   	leave  
c0104fa0:	c3                   	ret    

c0104fa1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104fa1:	55                   	push   %ebp
c0104fa2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104fa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fa7:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104faa:	b8 23 00 00 00       	mov    $0x23,%eax
c0104faf:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104fb1:	b8 23 00 00 00       	mov    $0x23,%eax
c0104fb6:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104fb8:	b8 10 00 00 00       	mov    $0x10,%eax
c0104fbd:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104fbf:	b8 10 00 00 00       	mov    $0x10,%eax
c0104fc4:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104fc6:	b8 10 00 00 00       	mov    $0x10,%eax
c0104fcb:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104fcd:	ea d4 4f 10 c0 08 00 	ljmp   $0x8,$0xc0104fd4
}
c0104fd4:	5d                   	pop    %ebp
c0104fd5:	c3                   	ret    

c0104fd6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104fd6:	55                   	push   %ebp
c0104fd7:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104fd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fdc:	a3 c4 b9 11 c0       	mov    %eax,0xc011b9c4
}
c0104fe1:	5d                   	pop    %ebp
c0104fe2:	c3                   	ret    

c0104fe3 <gdt_init>:
 * mode, the x86 CPU will look in the TSS for SS0 and ESP0 and load their value
 * into SS and ESP respectively.
 * */
/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104fe3:	55                   	push   %ebp
c0104fe4:	89 e5                	mov    %esp,%ebp
c0104fe6:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104fe9:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0104fee:	89 04 24             	mov    %eax,(%esp)
c0104ff1:	e8 e0 ff ff ff       	call   c0104fd6 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104ff6:	66 c7 05 c8 b9 11 c0 	movw   $0x10,0xc011b9c8
c0104ffd:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104fff:	66 c7 05 28 aa 11 c0 	movw   $0x68,0xc011aa28
c0105006:	68 00 
c0105008:	b8 c0 b9 11 c0       	mov    $0xc011b9c0,%eax
c010500d:	66 a3 2a aa 11 c0    	mov    %ax,0xc011aa2a
c0105013:	b8 c0 b9 11 c0       	mov    $0xc011b9c0,%eax
c0105018:	c1 e8 10             	shr    $0x10,%eax
c010501b:	a2 2c aa 11 c0       	mov    %al,0xc011aa2c
c0105020:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0105027:	83 e0 f0             	and    $0xfffffff0,%eax
c010502a:	83 c8 09             	or     $0x9,%eax
c010502d:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0105032:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0105039:	83 e0 ef             	and    $0xffffffef,%eax
c010503c:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0105041:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0105048:	83 e0 9f             	and    $0xffffff9f,%eax
c010504b:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0105050:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0105057:	83 c8 80             	or     $0xffffff80,%eax
c010505a:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c010505f:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0105066:	83 e0 f0             	and    $0xfffffff0,%eax
c0105069:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c010506e:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0105075:	83 e0 ef             	and    $0xffffffef,%eax
c0105078:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c010507d:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0105084:	83 e0 df             	and    $0xffffffdf,%eax
c0105087:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c010508c:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0105093:	83 c8 40             	or     $0x40,%eax
c0105096:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c010509b:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c01050a2:	83 e0 7f             	and    $0x7f,%eax
c01050a5:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c01050aa:	b8 c0 b9 11 c0       	mov    $0xc011b9c0,%eax
c01050af:	c1 e8 18             	shr    $0x18,%eax
c01050b2:	a2 2f aa 11 c0       	mov    %al,0xc011aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01050b7:	c7 04 24 30 aa 11 c0 	movl   $0xc011aa30,(%esp)
c01050be:	e8 de fe ff ff       	call   c0104fa1 <lgdt>
c01050c3:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01050c9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01050cd:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01050d0:	c9                   	leave  
c01050d1:	c3                   	ret    

c01050d2 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01050d2:	55                   	push   %ebp
c01050d3:	89 e5                	mov    %esp,%ebp
c01050d5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
c01050d8:	c7 05 3c ba 11 c0 b4 	movl   $0xc0107db4,0xc011ba3c
c01050df:	7d 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01050e2:	a1 3c ba 11 c0       	mov    0xc011ba3c,%eax
c01050e7:	8b 00                	mov    (%eax),%eax
c01050e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050ed:	c7 04 24 e4 81 10 c0 	movl   $0xc01081e4,(%esp)
c01050f4:	e8 4e b2 ff ff       	call   c0100347 <cprintf>
    pmm_manager->init();
c01050f9:	a1 3c ba 11 c0       	mov    0xc011ba3c,%eax
c01050fe:	8b 40 04             	mov    0x4(%eax),%eax
c0105101:	ff d0                	call   *%eax
}
c0105103:	c9                   	leave  
c0105104:	c3                   	ret    

c0105105 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0105105:	55                   	push   %ebp
c0105106:	89 e5                	mov    %esp,%ebp
c0105108:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c010510b:	a1 3c ba 11 c0       	mov    0xc011ba3c,%eax
c0105110:	8b 40 08             	mov    0x8(%eax),%eax
c0105113:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105116:	89 54 24 04          	mov    %edx,0x4(%esp)
c010511a:	8b 55 08             	mov    0x8(%ebp),%edx
c010511d:	89 14 24             	mov    %edx,(%esp)
c0105120:	ff d0                	call   *%eax
}
c0105122:	c9                   	leave  
c0105123:	c3                   	ret    

c0105124 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0105124:	55                   	push   %ebp
c0105125:	89 e5                	mov    %esp,%ebp
c0105127:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c010512a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0105131:	e8 2e fe ff ff       	call   c0104f64 <__intr_save>
c0105136:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0105139:	a1 3c ba 11 c0       	mov    0xc011ba3c,%eax
c010513e:	8b 40 0c             	mov    0xc(%eax),%eax
c0105141:	8b 55 08             	mov    0x8(%ebp),%edx
c0105144:	89 14 24             	mov    %edx,(%esp)
c0105147:	ff d0                	call   *%eax
c0105149:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c010514c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010514f:	89 04 24             	mov    %eax,(%esp)
c0105152:	e8 37 fe ff ff       	call   c0104f8e <__intr_restore>
    return page;
c0105157:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010515a:	c9                   	leave  
c010515b:	c3                   	ret    

c010515c <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c010515c:	55                   	push   %ebp
c010515d:	89 e5                	mov    %esp,%ebp
c010515f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0105162:	e8 fd fd ff ff       	call   c0104f64 <__intr_save>
c0105167:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c010516a:	a1 3c ba 11 c0       	mov    0xc011ba3c,%eax
c010516f:	8b 40 10             	mov    0x10(%eax),%eax
c0105172:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105175:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105179:	8b 55 08             	mov    0x8(%ebp),%edx
c010517c:	89 14 24             	mov    %edx,(%esp)
c010517f:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0105181:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105184:	89 04 24             	mov    %eax,(%esp)
c0105187:	e8 02 fe ff ff       	call   c0104f8e <__intr_restore>
}
c010518c:	c9                   	leave  
c010518d:	c3                   	ret    

c010518e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010518e:	55                   	push   %ebp
c010518f:	89 e5                	mov    %esp,%ebp
c0105191:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0105194:	e8 cb fd ff ff       	call   c0104f64 <__intr_save>
c0105199:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010519c:	a1 3c ba 11 c0       	mov    0xc011ba3c,%eax
c01051a1:	8b 40 14             	mov    0x14(%eax),%eax
c01051a4:	ff d0                	call   *%eax
c01051a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01051a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051ac:	89 04 24             	mov    %eax,(%esp)
c01051af:	e8 da fd ff ff       	call   c0104f8e <__intr_restore>
    return ret;
c01051b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01051b7:	c9                   	leave  
c01051b8:	c3                   	ret    

c01051b9 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01051b9:	55                   	push   %ebp
c01051ba:	89 e5                	mov    %esp,%ebp
c01051bc:	57                   	push   %edi
c01051bd:	56                   	push   %esi
c01051be:	53                   	push   %ebx
c01051bf:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01051c5:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01051cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01051d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01051da:	c7 04 24 fb 81 10 c0 	movl   $0xc01081fb,(%esp)
c01051e1:	e8 61 b1 ff ff       	call   c0100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01051e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01051ed:	e9 15 01 00 00       	jmp    c0105307 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01051f2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051f8:	89 d0                	mov    %edx,%eax
c01051fa:	c1 e0 02             	shl    $0x2,%eax
c01051fd:	01 d0                	add    %edx,%eax
c01051ff:	c1 e0 02             	shl    $0x2,%eax
c0105202:	01 c8                	add    %ecx,%eax
c0105204:	8b 50 08             	mov    0x8(%eax),%edx
c0105207:	8b 40 04             	mov    0x4(%eax),%eax
c010520a:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010520d:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105210:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105213:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105216:	89 d0                	mov    %edx,%eax
c0105218:	c1 e0 02             	shl    $0x2,%eax
c010521b:	01 d0                	add    %edx,%eax
c010521d:	c1 e0 02             	shl    $0x2,%eax
c0105220:	01 c8                	add    %ecx,%eax
c0105222:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105225:	8b 58 10             	mov    0x10(%eax),%ebx
c0105228:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010522b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010522e:	01 c8                	add    %ecx,%eax
c0105230:	11 da                	adc    %ebx,%edx
c0105232:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105235:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0105238:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010523b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010523e:	89 d0                	mov    %edx,%eax
c0105240:	c1 e0 02             	shl    $0x2,%eax
c0105243:	01 d0                	add    %edx,%eax
c0105245:	c1 e0 02             	shl    $0x2,%eax
c0105248:	01 c8                	add    %ecx,%eax
c010524a:	83 c0 14             	add    $0x14,%eax
c010524d:	8b 00                	mov    (%eax),%eax
c010524f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0105255:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105258:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010525b:	83 c0 ff             	add    $0xffffffff,%eax
c010525e:	83 d2 ff             	adc    $0xffffffff,%edx
c0105261:	89 c6                	mov    %eax,%esi
c0105263:	89 d7                	mov    %edx,%edi
c0105265:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105268:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010526b:	89 d0                	mov    %edx,%eax
c010526d:	c1 e0 02             	shl    $0x2,%eax
c0105270:	01 d0                	add    %edx,%eax
c0105272:	c1 e0 02             	shl    $0x2,%eax
c0105275:	01 c8                	add    %ecx,%eax
c0105277:	8b 48 0c             	mov    0xc(%eax),%ecx
c010527a:	8b 58 10             	mov    0x10(%eax),%ebx
c010527d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0105283:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0105287:	89 74 24 14          	mov    %esi,0x14(%esp)
c010528b:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010528f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105292:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105295:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105299:	89 54 24 10          	mov    %edx,0x10(%esp)
c010529d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01052a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01052a5:	c7 04 24 08 82 10 c0 	movl   $0xc0108208,(%esp)
c01052ac:	e8 96 b0 ff ff       	call   c0100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01052b1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01052b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052b7:	89 d0                	mov    %edx,%eax
c01052b9:	c1 e0 02             	shl    $0x2,%eax
c01052bc:	01 d0                	add    %edx,%eax
c01052be:	c1 e0 02             	shl    $0x2,%eax
c01052c1:	01 c8                	add    %ecx,%eax
c01052c3:	83 c0 14             	add    $0x14,%eax
c01052c6:	8b 00                	mov    (%eax),%eax
c01052c8:	83 f8 01             	cmp    $0x1,%eax
c01052cb:	75 36                	jne    c0105303 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01052cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01052d3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01052d6:	77 2b                	ja     c0105303 <page_init+0x14a>
c01052d8:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01052db:	72 05                	jb     c01052e2 <page_init+0x129>
c01052dd:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01052e0:	73 21                	jae    c0105303 <page_init+0x14a>
c01052e2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01052e6:	77 1b                	ja     c0105303 <page_init+0x14a>
c01052e8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01052ec:	72 09                	jb     c01052f7 <page_init+0x13e>
c01052ee:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01052f5:	77 0c                	ja     c0105303 <page_init+0x14a>
                maxpa = end;
c01052f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01052fa:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01052fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105300:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105303:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105307:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010530a:	8b 00                	mov    (%eax),%eax
c010530c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010530f:	0f 8f dd fe ff ff    	jg     c01051f2 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0105315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105319:	72 1d                	jb     c0105338 <page_init+0x17f>
c010531b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010531f:	77 09                	ja     c010532a <page_init+0x171>
c0105321:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0105328:	76 0e                	jbe    c0105338 <page_init+0x17f>
        maxpa = KMEMSIZE;
c010532a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0105331:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0105338:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010533b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010533e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0105342:	c1 ea 0c             	shr    $0xc,%edx
c0105345:	a3 a0 b9 11 c0       	mov    %eax,0xc011b9a0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010534a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0105351:	b8 48 ba 11 c0       	mov    $0xc011ba48,%eax
c0105356:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105359:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010535c:	01 d0                	add    %edx,%eax
c010535e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0105361:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105364:	ba 00 00 00 00       	mov    $0x0,%edx
c0105369:	f7 75 ac             	divl   -0x54(%ebp)
c010536c:	89 d0                	mov    %edx,%eax
c010536e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105371:	29 c2                	sub    %eax,%edx
c0105373:	89 d0                	mov    %edx,%eax
c0105375:	a3 44 ba 11 c0       	mov    %eax,0xc011ba44

    for (i = 0; i < npage; i ++) {
c010537a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105381:	eb 2e                	jmp    c01053b1 <page_init+0x1f8>
        SetPageReserved(pages + i);
c0105383:	8b 0d 44 ba 11 c0    	mov    0xc011ba44,%ecx
c0105389:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010538c:	89 d0                	mov    %edx,%eax
c010538e:	01 c0                	add    %eax,%eax
c0105390:	01 d0                	add    %edx,%eax
c0105392:	c1 e0 03             	shl    $0x3,%eax
c0105395:	01 c8                	add    %ecx,%eax
c0105397:	83 c0 04             	add    $0x4,%eax
c010539a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01053a1:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01053a4:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01053a7:	8b 55 90             	mov    -0x70(%ebp),%edx
c01053aa:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01053ad:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01053b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053b4:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c01053b9:	39 c2                	cmp    %eax,%edx
c01053bb:	72 c6                	jb     c0105383 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01053bd:	8b 15 a0 b9 11 c0    	mov    0xc011b9a0,%edx
c01053c3:	89 d0                	mov    %edx,%eax
c01053c5:	01 c0                	add    %eax,%eax
c01053c7:	01 d0                	add    %edx,%eax
c01053c9:	c1 e0 03             	shl    $0x3,%eax
c01053cc:	89 c2                	mov    %eax,%edx
c01053ce:	a1 44 ba 11 c0       	mov    0xc011ba44,%eax
c01053d3:	01 d0                	add    %edx,%eax
c01053d5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01053d8:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01053df:	77 23                	ja     c0105404 <page_init+0x24b>
c01053e1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01053e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01053e8:	c7 44 24 08 38 82 10 	movl   $0xc0108238,0x8(%esp)
c01053ef:	c0 
c01053f0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01053f7:	00 
c01053f8:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01053ff:	e8 cd b8 ff ff       	call   c0100cd1 <__panic>
c0105404:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105407:	05 00 00 00 40       	add    $0x40000000,%eax
c010540c:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010540f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105416:	e9 74 01 00 00       	jmp    c010558f <page_init+0x3d6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010541b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010541e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105421:	89 d0                	mov    %edx,%eax
c0105423:	c1 e0 02             	shl    $0x2,%eax
c0105426:	01 d0                	add    %edx,%eax
c0105428:	c1 e0 02             	shl    $0x2,%eax
c010542b:	01 c8                	add    %ecx,%eax
c010542d:	8b 50 08             	mov    0x8(%eax),%edx
c0105430:	8b 40 04             	mov    0x4(%eax),%eax
c0105433:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105436:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105439:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010543c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010543f:	89 d0                	mov    %edx,%eax
c0105441:	c1 e0 02             	shl    $0x2,%eax
c0105444:	01 d0                	add    %edx,%eax
c0105446:	c1 e0 02             	shl    $0x2,%eax
c0105449:	01 c8                	add    %ecx,%eax
c010544b:	8b 48 0c             	mov    0xc(%eax),%ecx
c010544e:	8b 58 10             	mov    0x10(%eax),%ebx
c0105451:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105454:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105457:	01 c8                	add    %ecx,%eax
c0105459:	11 da                	adc    %ebx,%edx
c010545b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010545e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0105461:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105464:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105467:	89 d0                	mov    %edx,%eax
c0105469:	c1 e0 02             	shl    $0x2,%eax
c010546c:	01 d0                	add    %edx,%eax
c010546e:	c1 e0 02             	shl    $0x2,%eax
c0105471:	01 c8                	add    %ecx,%eax
c0105473:	83 c0 14             	add    $0x14,%eax
c0105476:	8b 00                	mov    (%eax),%eax
c0105478:	83 f8 01             	cmp    $0x1,%eax
c010547b:	0f 85 0a 01 00 00    	jne    c010558b <page_init+0x3d2>
            if (begin < freemem) {
c0105481:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105484:	ba 00 00 00 00       	mov    $0x0,%edx
c0105489:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010548c:	72 17                	jb     c01054a5 <page_init+0x2ec>
c010548e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105491:	77 05                	ja     c0105498 <page_init+0x2df>
c0105493:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105496:	76 0d                	jbe    c01054a5 <page_init+0x2ec>
                begin = freemem;
c0105498:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010549b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010549e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01054a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01054a9:	72 1d                	jb     c01054c8 <page_init+0x30f>
c01054ab:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01054af:	77 09                	ja     c01054ba <page_init+0x301>
c01054b1:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01054b8:	76 0e                	jbe    c01054c8 <page_init+0x30f>
                end = KMEMSIZE;
c01054ba:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01054c1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01054c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054ce:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01054d1:	0f 87 b4 00 00 00    	ja     c010558b <page_init+0x3d2>
c01054d7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01054da:	72 09                	jb     c01054e5 <page_init+0x32c>
c01054dc:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01054df:	0f 83 a6 00 00 00    	jae    c010558b <page_init+0x3d2>
                begin = ROUNDUP(begin, PGSIZE);
c01054e5:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01054ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01054ef:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01054f2:	01 d0                	add    %edx,%eax
c01054f4:	83 e8 01             	sub    $0x1,%eax
c01054f7:	89 45 98             	mov    %eax,-0x68(%ebp)
c01054fa:	8b 45 98             	mov    -0x68(%ebp),%eax
c01054fd:	ba 00 00 00 00       	mov    $0x0,%edx
c0105502:	f7 75 9c             	divl   -0x64(%ebp)
c0105505:	89 d0                	mov    %edx,%eax
c0105507:	8b 55 98             	mov    -0x68(%ebp),%edx
c010550a:	29 c2                	sub    %eax,%edx
c010550c:	89 d0                	mov    %edx,%eax
c010550e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105513:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105516:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0105519:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010551c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010551f:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105522:	ba 00 00 00 00       	mov    $0x0,%edx
c0105527:	89 c7                	mov    %eax,%edi
c0105529:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010552f:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0105532:	89 d0                	mov    %edx,%eax
c0105534:	83 e0 00             	and    $0x0,%eax
c0105537:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010553a:	8b 45 80             	mov    -0x80(%ebp),%eax
c010553d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105540:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105543:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105546:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105549:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010554c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010554f:	77 3a                	ja     c010558b <page_init+0x3d2>
c0105551:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105554:	72 05                	jb     c010555b <page_init+0x3a2>
c0105556:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105559:	73 30                	jae    c010558b <page_init+0x3d2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010555b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010555e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0105561:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105564:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105567:	29 c8                	sub    %ecx,%eax
c0105569:	19 da                	sbb    %ebx,%edx
c010556b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010556f:	c1 ea 0c             	shr    $0xc,%edx
c0105572:	89 c3                	mov    %eax,%ebx
c0105574:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105577:	89 04 24             	mov    %eax,(%esp)
c010557a:	e8 c0 f8 ff ff       	call   c0104e3f <pa2page>
c010557f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105583:	89 04 24             	mov    %eax,(%esp)
c0105586:	e8 7a fb ff ff       	call   c0105105 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010558b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010558f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105592:	8b 00                	mov    (%eax),%eax
c0105594:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105597:	0f 8f 7e fe ff ff    	jg     c010541b <page_init+0x262>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010559d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01055a3:	5b                   	pop    %ebx
c01055a4:	5e                   	pop    %esi
c01055a5:	5f                   	pop    %edi
c01055a6:	5d                   	pop    %ebp
c01055a7:	c3                   	ret    

c01055a8 <enable_paging>:

static void
enable_paging(void) {
c01055a8:	55                   	push   %ebp
c01055a9:	89 e5                	mov    %esp,%ebp
c01055ab:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01055ae:	a1 40 ba 11 c0       	mov    0xc011ba40,%eax
c01055b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01055b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055b9:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01055bc:	0f 20 c0             	mov    %cr0,%eax
c01055bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01055c2:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01055c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01055c8:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01055cf:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01055d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01055d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055dc:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01055df:	c9                   	leave  
c01055e0:	c3                   	ret    

c01055e1 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01055e1:	55                   	push   %ebp
c01055e2:	89 e5                	mov    %esp,%ebp
c01055e4:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01055e7:	8b 45 14             	mov    0x14(%ebp),%eax
c01055ea:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055ed:	31 d0                	xor    %edx,%eax
c01055ef:	25 ff 0f 00 00       	and    $0xfff,%eax
c01055f4:	85 c0                	test   %eax,%eax
c01055f6:	74 24                	je     c010561c <boot_map_segment+0x3b>
c01055f8:	c7 44 24 0c 6a 82 10 	movl   $0xc010826a,0xc(%esp)
c01055ff:	c0 
c0105600:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105607:	c0 
c0105608:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010560f:	00 
c0105610:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105617:	e8 b5 b6 ff ff       	call   c0100cd1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010561c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105623:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105626:	25 ff 0f 00 00       	and    $0xfff,%eax
c010562b:	89 c2                	mov    %eax,%edx
c010562d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105630:	01 c2                	add    %eax,%edx
c0105632:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105635:	01 d0                	add    %edx,%eax
c0105637:	83 e8 01             	sub    $0x1,%eax
c010563a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010563d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105640:	ba 00 00 00 00       	mov    $0x0,%edx
c0105645:	f7 75 f0             	divl   -0x10(%ebp)
c0105648:	89 d0                	mov    %edx,%eax
c010564a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010564d:	29 c2                	sub    %eax,%edx
c010564f:	89 d0                	mov    %edx,%eax
c0105651:	c1 e8 0c             	shr    $0xc,%eax
c0105654:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105657:	8b 45 0c             	mov    0xc(%ebp),%eax
c010565a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010565d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105660:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105665:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105668:	8b 45 14             	mov    0x14(%ebp),%eax
c010566b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010566e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105671:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105676:	89 45 14             	mov    %eax,0x14(%ebp)
    //线性地址和物理地址映射
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {//低12位对齐
c0105679:	eb 6b                	jmp    c01056e6 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010567b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105682:	00 
c0105683:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105686:	89 44 24 04          	mov    %eax,0x4(%esp)
c010568a:	8b 45 08             	mov    0x8(%ebp),%eax
c010568d:	89 04 24             	mov    %eax,(%esp)
c0105690:	e8 cc 01 00 00       	call   c0105861 <get_pte>
c0105695:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0105698:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010569c:	75 24                	jne    c01056c2 <boot_map_segment+0xe1>
c010569e:	c7 44 24 0c 96 82 10 	movl   $0xc0108296,0xc(%esp)
c01056a5:	c0 
c01056a6:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01056ad:	c0 
c01056ae:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01056b5:	00 
c01056b6:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01056bd:	e8 0f b6 ff ff       	call   c0100cd1 <__panic>
        *ptep = pa | PTE_P | perm;
c01056c2:	8b 45 18             	mov    0x18(%ebp),%eax
c01056c5:	8b 55 14             	mov    0x14(%ebp),%edx
c01056c8:	09 d0                	or     %edx,%eax
c01056ca:	83 c8 01             	or     $0x1,%eax
c01056cd:	89 c2                	mov    %eax,%edx
c01056cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056d2:	89 10                	mov    %edx,(%eax)
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    //线性地址和物理地址映射
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {//低12位对齐
c01056d4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01056d8:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01056df:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01056e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056ea:	75 8f                	jne    c010567b <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01056ec:	c9                   	leave  
c01056ed:	c3                   	ret    

c01056ee <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01056ee:	55                   	push   %ebp
c01056ef:	89 e5                	mov    %esp,%ebp
c01056f1:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();//pmm.h
c01056f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01056fb:	e8 24 fa ff ff       	call   c0105124 <alloc_pages>
c0105700:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105707:	75 1c                	jne    c0105725 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0105709:	c7 44 24 08 a3 82 10 	movl   $0xc01082a3,0x8(%esp)
c0105710:	c0 
c0105711:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0105718:	00 
c0105719:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105720:	e8 ac b5 ff ff       	call   c0100cd1 <__panic>
    }
    return page2kva(p);//pmm.h
c0105725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105728:	89 04 24             	mov    %eax,(%esp)
c010572b:	e8 5d f7 ff ff       	call   c0104e8d <page2kva>
}
c0105730:	c9                   	leave  
c0105731:	c3                   	ret    

c0105732 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105732:	55                   	push   %ebp
c0105733:	89 e5                	mov    %esp,%ebp
c0105735:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105738:	e8 95 f9 ff ff       	call   c01050d2 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010573d:	e8 77 fa ff ff       	call   c01051b9 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0105742:	e8 70 04 00 00       	call   c0105bb7 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105747:	e8 a2 ff ff ff       	call   c01056ee <boot_alloc_page>
c010574c:	a3 a4 b9 11 c0       	mov    %eax,0xc011b9a4
    memset(boot_pgdir, 0, PGSIZE);
c0105751:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105756:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010575d:	00 
c010575e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105765:	00 
c0105766:	89 04 24             	mov    %eax,(%esp)
c0105769:	e8 b2 1a 00 00       	call   c0107220 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010576e:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105773:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105776:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010577d:	77 23                	ja     c01057a2 <pmm_init+0x70>
c010577f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105782:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105786:	c7 44 24 08 38 82 10 	movl   $0xc0108238,0x8(%esp)
c010578d:	c0 
c010578e:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0105795:	00 
c0105796:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c010579d:	e8 2f b5 ff ff       	call   c0100cd1 <__panic>
c01057a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057a5:	05 00 00 00 40       	add    $0x40000000,%eax
c01057aa:	a3 40 ba 11 c0       	mov    %eax,0xc011ba40

    check_pgdir();
c01057af:	e8 21 04 00 00       	call   c0105bd5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01057b4:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c01057b9:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01057bf:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c01057c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057c7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01057ce:	77 23                	ja     c01057f3 <pmm_init+0xc1>
c01057d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057d7:	c7 44 24 08 38 82 10 	movl   $0xc0108238,0x8(%esp)
c01057de:	c0 
c01057df:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01057e6:	00 
c01057e7:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01057ee:	e8 de b4 ff ff       	call   c0100cd1 <__panic>
c01057f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f6:	05 00 00 00 40       	add    $0x40000000,%eax
c01057fb:	83 c8 03             	or     $0x3,%eax
c01057fe:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);//建立一一映射关系
c0105800:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105805:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010580c:	00 
c010580d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105814:	00 
c0105815:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010581c:	38 
c010581d:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105824:	c0 
c0105825:	89 04 24             	mov    %eax,(%esp)
c0105828:	e8 b4 fd ff ff       	call   c01055e1 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010582d:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105832:	8b 15 a4 b9 11 c0    	mov    0xc011b9a4,%edx
c0105838:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010583e:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0105840:	e8 63 fd ff ff       	call   c01055a8 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105845:	e8 99 f7 ff ff       	call   c0104fe3 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010584a:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c010584f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105855:	e8 16 0a 00 00       	call   c0106270 <check_boot_pgdir>

    print_pgdir();
c010585a:	e8 a3 0e 00 00       	call   c0106702 <print_pgdir>

}
c010585f:	c9                   	leave  
c0105860:	c3                   	ret    

c0105861 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0105861:	55                   	push   %ebp
c0105862:	89 e5                	mov    %esp,%ebp
c0105864:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

    pde_t *pdep=&pgdir[PDX(la)];
c0105867:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586a:	c1 e8 16             	shr    $0x16,%eax
c010586d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105874:	8b 45 08             	mov    0x8(%ebp),%eax
c0105877:	01 d0                	add    %edx,%eax
c0105879:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //lack 对应的页表空间
    if(!(*pdep&PTE_P))
c010587c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010587f:	8b 00                	mov    (%eax),%eax
c0105881:	83 e0 01             	and    $0x1,%eax
c0105884:	85 c0                	test   %eax,%eax
c0105886:	0f 85 b9 00 00 00    	jne    c0105945 <get_pte+0xe4>
    {
    	struct Page *page;
    	if(!create)
c010588c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105890:	75 0a                	jne    c010589c <get_pte+0x3b>
    		return NULL;
c0105892:	b8 00 00 00 00       	mov    $0x0,%eax
c0105897:	e9 05 01 00 00       	jmp    c01059a1 <get_pte+0x140>
    	page=alloc_page();
c010589c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01058a3:	e8 7c f8 ff ff       	call   c0105124 <alloc_pages>
c01058a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(page==NULL)
c01058ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058af:	75 0a                	jne    c01058bb <get_pte+0x5a>
    		return NULL;
c01058b1:	b8 00 00 00 00       	mov    $0x0,%eax
c01058b6:	e9 e6 00 00 00       	jmp    c01059a1 <get_pte+0x140>
    	set_page_ref(page,1);
c01058bb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01058c2:	00 
c01058c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058c6:	89 04 24             	mov    %eax,(%esp)
c01058c9:	e8 5b f6 ff ff       	call   c0104f29 <set_page_ref>
    	uintptr_t pa=page2pa(page);//此时物理地址等于线性地址
c01058ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058d1:	89 04 24             	mov    %eax,(%esp)
c01058d4:	e8 50 f5 ff ff       	call   c0104e29 <page2pa>
c01058d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	memset(KADDR(pa),0,PGSIZE);
c01058dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058df:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058e5:	c1 e8 0c             	shr    $0xc,%eax
c01058e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058eb:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c01058f0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01058f3:	72 23                	jb     c0105918 <get_pte+0xb7>
c01058f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058fc:	c7 44 24 08 94 81 10 	movl   $0xc0108194,0x8(%esp)
c0105903:	c0 
c0105904:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
c010590b:	00 
c010590c:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105913:	e8 b9 b3 ff ff       	call   c0100cd1 <__panic>
c0105918:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010591b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105920:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105927:	00 
c0105928:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010592f:	00 
c0105930:	89 04 24             	mov    %eax,(%esp)
c0105933:	e8 e8 18 00 00       	call   c0107220 <memset>
    	*pdep=pa|PTE_U|PTE_W|PTE_P;//填写PDE
c0105938:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010593b:	83 c8 07             	or     $0x7,%eax
c010593e:	89 c2                	mov    %eax,%edx
c0105940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105943:	89 10                	mov    %edx,(%eax)
    }

    return &((pte_t*)KADDR(PDE_ADDR(*pdep)))[PTX(la)];//mmu.h
c0105945:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105948:	8b 00                	mov    (%eax),%eax
c010594a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010594f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105952:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105955:	c1 e8 0c             	shr    $0xc,%eax
c0105958:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010595b:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c0105960:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105963:	72 23                	jb     c0105988 <get_pte+0x127>
c0105965:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105968:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010596c:	c7 44 24 08 94 81 10 	movl   $0xc0108194,0x8(%esp)
c0105973:	c0 
c0105974:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
c010597b:	00 
c010597c:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105983:	e8 49 b3 ff ff       	call   c0100cd1 <__panic>
c0105988:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010598b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105990:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105993:	c1 ea 0c             	shr    $0xc,%edx
c0105996:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010599c:	c1 e2 02             	shl    $0x2,%edx
c010599f:	01 d0                	add    %edx,%eax
}
c01059a1:	c9                   	leave  
c01059a2:	c3                   	ret    

c01059a3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01059a3:	55                   	push   %ebp
c01059a4:	89 e5                	mov    %esp,%ebp
c01059a6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01059a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059b0:	00 
c01059b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bb:	89 04 24             	mov    %eax,(%esp)
c01059be:	e8 9e fe ff ff       	call   c0105861 <get_pte>
c01059c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01059c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059ca:	74 08                	je     c01059d4 <get_page+0x31>
        *ptep_store = ptep;
c01059cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01059cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059d2:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01059d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01059d8:	74 1b                	je     c01059f5 <get_page+0x52>
c01059da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059dd:	8b 00                	mov    (%eax),%eax
c01059df:	83 e0 01             	and    $0x1,%eax
c01059e2:	85 c0                	test   %eax,%eax
c01059e4:	74 0f                	je     c01059f5 <get_page+0x52>
        return pa2page(*ptep);
c01059e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059e9:	8b 00                	mov    (%eax),%eax
c01059eb:	89 04 24             	mov    %eax,(%esp)
c01059ee:	e8 4c f4 ff ff       	call   c0104e3f <pa2page>
c01059f3:	eb 05                	jmp    c01059fa <get_page+0x57>
    }
    return NULL;
c01059f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01059fa:	c9                   	leave  
c01059fb:	c3                   	ret    

c01059fc <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01059fc:	55                   	push   %ebp
c01059fd:	89 e5                	mov    %esp,%ebp
c01059ff:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if(*ptep&PTE_P)
c0105a02:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a05:	8b 00                	mov    (%eax),%eax
c0105a07:	83 e0 01             	and    $0x1,%eax
c0105a0a:	85 c0                	test   %eax,%eax
c0105a0c:	74 4d                	je     c0105a5b <page_remove_pte+0x5f>
    {
    	struct Page *page=pte2page(*ptep);
c0105a0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a11:	8b 00                	mov    (%eax),%eax
c0105a13:	89 04 24             	mov    %eax,(%esp)
c0105a16:	e8 c6 f4 ff ff       	call   c0104ee1 <pte2page>
c0105a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if(page_ref_dec(page)==0)
c0105a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a21:	89 04 24             	mov    %eax,(%esp)
c0105a24:	e8 24 f5 ff ff       	call   c0104f4d <page_ref_dec>
c0105a29:	85 c0                	test   %eax,%eax
c0105a2b:	75 13                	jne    c0105a40 <page_remove_pte+0x44>
    		free_page(page);
c0105a2d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105a34:	00 
c0105a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a38:	89 04 24             	mov    %eax,(%esp)
c0105a3b:	e8 1c f7 ff ff       	call   c010515c <free_pages>
    	*ptep=0;
c0105a40:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	tlb_invalidate(pgdir,la);
c0105a49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a53:	89 04 24             	mov    %eax,(%esp)
c0105a56:	e8 ff 00 00 00       	call   c0105b5a <tlb_invalidate>
    }

}
c0105a5b:	c9                   	leave  
c0105a5c:	c3                   	ret    

c0105a5d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105a5d:	55                   	push   %ebp
c0105a5e:	89 e5                	mov    %esp,%ebp
c0105a60:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105a63:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a6a:	00 
c0105a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a75:	89 04 24             	mov    %eax,(%esp)
c0105a78:	e8 e4 fd ff ff       	call   c0105861 <get_pte>
c0105a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a84:	74 19                	je     c0105a9f <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a89:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a97:	89 04 24             	mov    %eax,(%esp)
c0105a9a:	e8 5d ff ff ff       	call   c01059fc <page_remove_pte>
    }
}
c0105a9f:	c9                   	leave  
c0105aa0:	c3                   	ret    

c0105aa1 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105aa1:	55                   	push   %ebp
c0105aa2:	89 e5                	mov    %esp,%ebp
c0105aa4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105aa7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105aae:	00 
c0105aaf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab9:	89 04 24             	mov    %eax,(%esp)
c0105abc:	e8 a0 fd ff ff       	call   c0105861 <get_pte>
c0105ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105ac8:	75 0a                	jne    c0105ad4 <page_insert+0x33>
        return -E_NO_MEM;
c0105aca:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105acf:	e9 84 00 00 00       	jmp    c0105b58 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad7:	89 04 24             	mov    %eax,(%esp)
c0105ada:	e8 57 f4 ff ff       	call   c0104f36 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ae2:	8b 00                	mov    (%eax),%eax
c0105ae4:	83 e0 01             	and    $0x1,%eax
c0105ae7:	85 c0                	test   %eax,%eax
c0105ae9:	74 3e                	je     c0105b29 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105aee:	8b 00                	mov    (%eax),%eax
c0105af0:	89 04 24             	mov    %eax,(%esp)
c0105af3:	e8 e9 f3 ff ff       	call   c0104ee1 <pte2page>
c0105af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105afe:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b01:	75 0d                	jne    c0105b10 <page_insert+0x6f>
            page_ref_dec(page);
c0105b03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b06:	89 04 24             	mov    %eax,(%esp)
c0105b09:	e8 3f f4 ff ff       	call   c0104f4d <page_ref_dec>
c0105b0e:	eb 19                	jmp    c0105b29 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b13:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b17:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b21:	89 04 24             	mov    %eax,(%esp)
c0105b24:	e8 d3 fe ff ff       	call   c01059fc <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105b29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2c:	89 04 24             	mov    %eax,(%esp)
c0105b2f:	e8 f5 f2 ff ff       	call   c0104e29 <page2pa>
c0105b34:	0b 45 14             	or     0x14(%ebp),%eax
c0105b37:	83 c8 01             	or     $0x1,%eax
c0105b3a:	89 c2                	mov    %eax,%edx
c0105b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b3f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105b41:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4b:	89 04 24             	mov    %eax,(%esp)
c0105b4e:	e8 07 00 00 00       	call   c0105b5a <tlb_invalidate>
    return 0;
c0105b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b58:	c9                   	leave  
c0105b59:	c3                   	ret    

c0105b5a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105b5a:	55                   	push   %ebp
c0105b5b:	89 e5                	mov    %esp,%ebp
c0105b5d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105b60:	0f 20 d8             	mov    %cr3,%eax
c0105b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105b69:	89 c2                	mov    %eax,%edx
c0105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b71:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105b78:	77 23                	ja     c0105b9d <tlb_invalidate+0x43>
c0105b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b81:	c7 44 24 08 38 82 10 	movl   $0xc0108238,0x8(%esp)
c0105b88:	c0 
c0105b89:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0105b90:	00 
c0105b91:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105b98:	e8 34 b1 ff ff       	call   c0100cd1 <__panic>
c0105b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ba0:	05 00 00 00 40       	add    $0x40000000,%eax
c0105ba5:	39 c2                	cmp    %eax,%edx
c0105ba7:	75 0c                	jne    c0105bb5 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bac:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bb2:	0f 01 38             	invlpg (%eax)
    }
}
c0105bb5:	c9                   	leave  
c0105bb6:	c3                   	ret    

c0105bb7 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105bb7:	55                   	push   %ebp
c0105bb8:	89 e5                	mov    %esp,%ebp
c0105bba:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105bbd:	a1 3c ba 11 c0       	mov    0xc011ba3c,%eax
c0105bc2:	8b 40 18             	mov    0x18(%eax),%eax
c0105bc5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105bc7:	c7 04 24 bc 82 10 c0 	movl   $0xc01082bc,(%esp)
c0105bce:	e8 74 a7 ff ff       	call   c0100347 <cprintf>
}
c0105bd3:	c9                   	leave  
c0105bd4:	c3                   	ret    

c0105bd5 <check_pgdir>:

static void
check_pgdir(void) {
c0105bd5:	55                   	push   %ebp
c0105bd6:	89 e5                	mov    %esp,%ebp
c0105bd8:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105bdb:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c0105be0:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105be5:	76 24                	jbe    c0105c0b <check_pgdir+0x36>
c0105be7:	c7 44 24 0c db 82 10 	movl   $0xc01082db,0xc(%esp)
c0105bee:	c0 
c0105bef:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105bf6:	c0 
c0105bf7:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0105bfe:	00 
c0105bff:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105c06:	e8 c6 b0 ff ff       	call   c0100cd1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105c0b:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105c10:	85 c0                	test   %eax,%eax
c0105c12:	74 0e                	je     c0105c22 <check_pgdir+0x4d>
c0105c14:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105c19:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105c1e:	85 c0                	test   %eax,%eax
c0105c20:	74 24                	je     c0105c46 <check_pgdir+0x71>
c0105c22:	c7 44 24 0c f8 82 10 	movl   $0xc01082f8,0xc(%esp)
c0105c29:	c0 
c0105c2a:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105c31:	c0 
c0105c32:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0105c39:	00 
c0105c3a:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105c41:	e8 8b b0 ff ff       	call   c0100cd1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105c46:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105c4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c52:	00 
c0105c53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105c5a:	00 
c0105c5b:	89 04 24             	mov    %eax,(%esp)
c0105c5e:	e8 40 fd ff ff       	call   c01059a3 <get_page>
c0105c63:	85 c0                	test   %eax,%eax
c0105c65:	74 24                	je     c0105c8b <check_pgdir+0xb6>
c0105c67:	c7 44 24 0c 30 83 10 	movl   $0xc0108330,0xc(%esp)
c0105c6e:	c0 
c0105c6f:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105c76:	c0 
c0105c77:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0105c7e:	00 
c0105c7f:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105c86:	e8 46 b0 ff ff       	call   c0100cd1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105c8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c92:	e8 8d f4 ff ff       	call   c0105124 <alloc_pages>
c0105c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105c9a:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105c9f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105ca6:	00 
c0105ca7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105cae:	00 
c0105caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105cb2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105cb6:	89 04 24             	mov    %eax,(%esp)
c0105cb9:	e8 e3 fd ff ff       	call   c0105aa1 <page_insert>
c0105cbe:	85 c0                	test   %eax,%eax
c0105cc0:	74 24                	je     c0105ce6 <check_pgdir+0x111>
c0105cc2:	c7 44 24 0c 58 83 10 	movl   $0xc0108358,0xc(%esp)
c0105cc9:	c0 
c0105cca:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105cd1:	c0 
c0105cd2:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0105cd9:	00 
c0105cda:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105ce1:	e8 eb af ff ff       	call   c0100cd1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105ce6:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105ceb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105cf2:	00 
c0105cf3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105cfa:	00 
c0105cfb:	89 04 24             	mov    %eax,(%esp)
c0105cfe:	e8 5e fb ff ff       	call   c0105861 <get_pte>
c0105d03:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105d0a:	75 24                	jne    c0105d30 <check_pgdir+0x15b>
c0105d0c:	c7 44 24 0c 84 83 10 	movl   $0xc0108384,0xc(%esp)
c0105d13:	c0 
c0105d14:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105d1b:	c0 
c0105d1c:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0105d23:	00 
c0105d24:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105d2b:	e8 a1 af ff ff       	call   c0100cd1 <__panic>
    assert(pa2page(*ptep) == p1);
c0105d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d33:	8b 00                	mov    (%eax),%eax
c0105d35:	89 04 24             	mov    %eax,(%esp)
c0105d38:	e8 02 f1 ff ff       	call   c0104e3f <pa2page>
c0105d3d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105d40:	74 24                	je     c0105d66 <check_pgdir+0x191>
c0105d42:	c7 44 24 0c b1 83 10 	movl   $0xc01083b1,0xc(%esp)
c0105d49:	c0 
c0105d4a:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105d51:	c0 
c0105d52:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0105d59:	00 
c0105d5a:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105d61:	e8 6b af ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p1) == 1);
c0105d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d69:	89 04 24             	mov    %eax,(%esp)
c0105d6c:	e8 ae f1 ff ff       	call   c0104f1f <page_ref>
c0105d71:	83 f8 01             	cmp    $0x1,%eax
c0105d74:	74 24                	je     c0105d9a <check_pgdir+0x1c5>
c0105d76:	c7 44 24 0c c6 83 10 	movl   $0xc01083c6,0xc(%esp)
c0105d7d:	c0 
c0105d7e:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105d85:	c0 
c0105d86:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0105d8d:	00 
c0105d8e:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105d95:	e8 37 af ff ff       	call   c0100cd1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105d9a:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105d9f:	8b 00                	mov    (%eax),%eax
c0105da1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dac:	c1 e8 0c             	shr    $0xc,%eax
c0105daf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105db2:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c0105db7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105dba:	72 23                	jb     c0105ddf <check_pgdir+0x20a>
c0105dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105dc3:	c7 44 24 08 94 81 10 	movl   $0xc0108194,0x8(%esp)
c0105dca:	c0 
c0105dcb:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0105dd2:	00 
c0105dd3:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105dda:	e8 f2 ae ff ff       	call   c0100cd1 <__panic>
c0105ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105de2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105de7:	83 c0 04             	add    $0x4,%eax
c0105dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105ded:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105df2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105df9:	00 
c0105dfa:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105e01:	00 
c0105e02:	89 04 24             	mov    %eax,(%esp)
c0105e05:	e8 57 fa ff ff       	call   c0105861 <get_pte>
c0105e0a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105e0d:	74 24                	je     c0105e33 <check_pgdir+0x25e>
c0105e0f:	c7 44 24 0c d8 83 10 	movl   $0xc01083d8,0xc(%esp)
c0105e16:	c0 
c0105e17:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105e1e:	c0 
c0105e1f:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105e26:	00 
c0105e27:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105e2e:	e8 9e ae ff ff       	call   c0100cd1 <__panic>

    p2 = alloc_page();
c0105e33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105e3a:	e8 e5 f2 ff ff       	call   c0105124 <alloc_pages>
c0105e3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105e42:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105e47:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105e4e:	00 
c0105e4f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105e56:	00 
c0105e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e5a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e5e:	89 04 24             	mov    %eax,(%esp)
c0105e61:	e8 3b fc ff ff       	call   c0105aa1 <page_insert>
c0105e66:	85 c0                	test   %eax,%eax
c0105e68:	74 24                	je     c0105e8e <check_pgdir+0x2b9>
c0105e6a:	c7 44 24 0c 00 84 10 	movl   $0xc0108400,0xc(%esp)
c0105e71:	c0 
c0105e72:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105e79:	c0 
c0105e7a:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0105e81:	00 
c0105e82:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105e89:	e8 43 ae ff ff       	call   c0100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105e8e:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105e93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e9a:	00 
c0105e9b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105ea2:	00 
c0105ea3:	89 04 24             	mov    %eax,(%esp)
c0105ea6:	e8 b6 f9 ff ff       	call   c0105861 <get_pte>
c0105eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105eae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105eb2:	75 24                	jne    c0105ed8 <check_pgdir+0x303>
c0105eb4:	c7 44 24 0c 38 84 10 	movl   $0xc0108438,0xc(%esp)
c0105ebb:	c0 
c0105ebc:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105ec3:	c0 
c0105ec4:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0105ecb:	00 
c0105ecc:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105ed3:	e8 f9 ad ff ff       	call   c0100cd1 <__panic>
    assert(*ptep & PTE_U);
c0105ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105edb:	8b 00                	mov    (%eax),%eax
c0105edd:	83 e0 04             	and    $0x4,%eax
c0105ee0:	85 c0                	test   %eax,%eax
c0105ee2:	75 24                	jne    c0105f08 <check_pgdir+0x333>
c0105ee4:	c7 44 24 0c 68 84 10 	movl   $0xc0108468,0xc(%esp)
c0105eeb:	c0 
c0105eec:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105ef3:	c0 
c0105ef4:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0105efb:	00 
c0105efc:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105f03:	e8 c9 ad ff ff       	call   c0100cd1 <__panic>
    assert(*ptep & PTE_W);
c0105f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f0b:	8b 00                	mov    (%eax),%eax
c0105f0d:	83 e0 02             	and    $0x2,%eax
c0105f10:	85 c0                	test   %eax,%eax
c0105f12:	75 24                	jne    c0105f38 <check_pgdir+0x363>
c0105f14:	c7 44 24 0c 76 84 10 	movl   $0xc0108476,0xc(%esp)
c0105f1b:	c0 
c0105f1c:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105f23:	c0 
c0105f24:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0105f2b:	00 
c0105f2c:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105f33:	e8 99 ad ff ff       	call   c0100cd1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105f38:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105f3d:	8b 00                	mov    (%eax),%eax
c0105f3f:	83 e0 04             	and    $0x4,%eax
c0105f42:	85 c0                	test   %eax,%eax
c0105f44:	75 24                	jne    c0105f6a <check_pgdir+0x395>
c0105f46:	c7 44 24 0c 84 84 10 	movl   $0xc0108484,0xc(%esp)
c0105f4d:	c0 
c0105f4e:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105f55:	c0 
c0105f56:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0105f5d:	00 
c0105f5e:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105f65:	e8 67 ad ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p2) == 1);
c0105f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f6d:	89 04 24             	mov    %eax,(%esp)
c0105f70:	e8 aa ef ff ff       	call   c0104f1f <page_ref>
c0105f75:	83 f8 01             	cmp    $0x1,%eax
c0105f78:	74 24                	je     c0105f9e <check_pgdir+0x3c9>
c0105f7a:	c7 44 24 0c 9a 84 10 	movl   $0xc010849a,0xc(%esp)
c0105f81:	c0 
c0105f82:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105f89:	c0 
c0105f8a:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0105f91:	00 
c0105f92:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105f99:	e8 33 ad ff ff       	call   c0100cd1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105f9e:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0105fa3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105faa:	00 
c0105fab:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105fb2:	00 
c0105fb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105fb6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105fba:	89 04 24             	mov    %eax,(%esp)
c0105fbd:	e8 df fa ff ff       	call   c0105aa1 <page_insert>
c0105fc2:	85 c0                	test   %eax,%eax
c0105fc4:	74 24                	je     c0105fea <check_pgdir+0x415>
c0105fc6:	c7 44 24 0c ac 84 10 	movl   $0xc01084ac,0xc(%esp)
c0105fcd:	c0 
c0105fce:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0105fd5:	c0 
c0105fd6:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0105fdd:	00 
c0105fde:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0105fe5:	e8 e7 ac ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p1) == 2);
c0105fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fed:	89 04 24             	mov    %eax,(%esp)
c0105ff0:	e8 2a ef ff ff       	call   c0104f1f <page_ref>
c0105ff5:	83 f8 02             	cmp    $0x2,%eax
c0105ff8:	74 24                	je     c010601e <check_pgdir+0x449>
c0105ffa:	c7 44 24 0c d8 84 10 	movl   $0xc01084d8,0xc(%esp)
c0106001:	c0 
c0106002:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106009:	c0 
c010600a:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0106011:	00 
c0106012:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106019:	e8 b3 ac ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p2) == 0);
c010601e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106021:	89 04 24             	mov    %eax,(%esp)
c0106024:	e8 f6 ee ff ff       	call   c0104f1f <page_ref>
c0106029:	85 c0                	test   %eax,%eax
c010602b:	74 24                	je     c0106051 <check_pgdir+0x47c>
c010602d:	c7 44 24 0c ea 84 10 	movl   $0xc01084ea,0xc(%esp)
c0106034:	c0 
c0106035:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c010603c:	c0 
c010603d:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0106044:	00 
c0106045:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c010604c:	e8 80 ac ff ff       	call   c0100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0106051:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0106056:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010605d:	00 
c010605e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106065:	00 
c0106066:	89 04 24             	mov    %eax,(%esp)
c0106069:	e8 f3 f7 ff ff       	call   c0105861 <get_pte>
c010606e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106075:	75 24                	jne    c010609b <check_pgdir+0x4c6>
c0106077:	c7 44 24 0c 38 84 10 	movl   $0xc0108438,0xc(%esp)
c010607e:	c0 
c010607f:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106086:	c0 
c0106087:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c010608e:	00 
c010608f:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106096:	e8 36 ac ff ff       	call   c0100cd1 <__panic>
    assert(pa2page(*ptep) == p1);
c010609b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010609e:	8b 00                	mov    (%eax),%eax
c01060a0:	89 04 24             	mov    %eax,(%esp)
c01060a3:	e8 97 ed ff ff       	call   c0104e3f <pa2page>
c01060a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01060ab:	74 24                	je     c01060d1 <check_pgdir+0x4fc>
c01060ad:	c7 44 24 0c b1 83 10 	movl   $0xc01083b1,0xc(%esp)
c01060b4:	c0 
c01060b5:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01060bc:	c0 
c01060bd:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c01060c4:	00 
c01060c5:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01060cc:	e8 00 ac ff ff       	call   c0100cd1 <__panic>
    assert((*ptep & PTE_U) == 0);
c01060d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060d4:	8b 00                	mov    (%eax),%eax
c01060d6:	83 e0 04             	and    $0x4,%eax
c01060d9:	85 c0                	test   %eax,%eax
c01060db:	74 24                	je     c0106101 <check_pgdir+0x52c>
c01060dd:	c7 44 24 0c fc 84 10 	movl   $0xc01084fc,0xc(%esp)
c01060e4:	c0 
c01060e5:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01060ec:	c0 
c01060ed:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c01060f4:	00 
c01060f5:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01060fc:	e8 d0 ab ff ff       	call   c0100cd1 <__panic>

    page_remove(boot_pgdir, 0x0);
c0106101:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0106106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010610d:	00 
c010610e:	89 04 24             	mov    %eax,(%esp)
c0106111:	e8 47 f9 ff ff       	call   c0105a5d <page_remove>
    assert(page_ref(p1) == 1);
c0106116:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106119:	89 04 24             	mov    %eax,(%esp)
c010611c:	e8 fe ed ff ff       	call   c0104f1f <page_ref>
c0106121:	83 f8 01             	cmp    $0x1,%eax
c0106124:	74 24                	je     c010614a <check_pgdir+0x575>
c0106126:	c7 44 24 0c c6 83 10 	movl   $0xc01083c6,0xc(%esp)
c010612d:	c0 
c010612e:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106135:	c0 
c0106136:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c010613d:	00 
c010613e:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106145:	e8 87 ab ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p2) == 0);
c010614a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010614d:	89 04 24             	mov    %eax,(%esp)
c0106150:	e8 ca ed ff ff       	call   c0104f1f <page_ref>
c0106155:	85 c0                	test   %eax,%eax
c0106157:	74 24                	je     c010617d <check_pgdir+0x5a8>
c0106159:	c7 44 24 0c ea 84 10 	movl   $0xc01084ea,0xc(%esp)
c0106160:	c0 
c0106161:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106168:	c0 
c0106169:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0106170:	00 
c0106171:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106178:	e8 54 ab ff ff       	call   c0100cd1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010617d:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0106182:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106189:	00 
c010618a:	89 04 24             	mov    %eax,(%esp)
c010618d:	e8 cb f8 ff ff       	call   c0105a5d <page_remove>
    assert(page_ref(p1) == 0);
c0106192:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106195:	89 04 24             	mov    %eax,(%esp)
c0106198:	e8 82 ed ff ff       	call   c0104f1f <page_ref>
c010619d:	85 c0                	test   %eax,%eax
c010619f:	74 24                	je     c01061c5 <check_pgdir+0x5f0>
c01061a1:	c7 44 24 0c 11 85 10 	movl   $0xc0108511,0xc(%esp)
c01061a8:	c0 
c01061a9:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01061b0:	c0 
c01061b1:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c01061b8:	00 
c01061b9:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01061c0:	e8 0c ab ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p2) == 0);
c01061c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061c8:	89 04 24             	mov    %eax,(%esp)
c01061cb:	e8 4f ed ff ff       	call   c0104f1f <page_ref>
c01061d0:	85 c0                	test   %eax,%eax
c01061d2:	74 24                	je     c01061f8 <check_pgdir+0x623>
c01061d4:	c7 44 24 0c ea 84 10 	movl   $0xc01084ea,0xc(%esp)
c01061db:	c0 
c01061dc:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01061e3:	c0 
c01061e4:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c01061eb:	00 
c01061ec:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01061f3:	e8 d9 aa ff ff       	call   c0100cd1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c01061f8:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c01061fd:	8b 00                	mov    (%eax),%eax
c01061ff:	89 04 24             	mov    %eax,(%esp)
c0106202:	e8 38 ec ff ff       	call   c0104e3f <pa2page>
c0106207:	89 04 24             	mov    %eax,(%esp)
c010620a:	e8 10 ed ff ff       	call   c0104f1f <page_ref>
c010620f:	83 f8 01             	cmp    $0x1,%eax
c0106212:	74 24                	je     c0106238 <check_pgdir+0x663>
c0106214:	c7 44 24 0c 24 85 10 	movl   $0xc0108524,0xc(%esp)
c010621b:	c0 
c010621c:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106223:	c0 
c0106224:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c010622b:	00 
c010622c:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106233:	e8 99 aa ff ff       	call   c0100cd1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0106238:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c010623d:	8b 00                	mov    (%eax),%eax
c010623f:	89 04 24             	mov    %eax,(%esp)
c0106242:	e8 f8 eb ff ff       	call   c0104e3f <pa2page>
c0106247:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010624e:	00 
c010624f:	89 04 24             	mov    %eax,(%esp)
c0106252:	e8 05 ef ff ff       	call   c010515c <free_pages>
    boot_pgdir[0] = 0;
c0106257:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c010625c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0106262:	c7 04 24 4a 85 10 c0 	movl   $0xc010854a,(%esp)
c0106269:	e8 d9 a0 ff ff       	call   c0100347 <cprintf>
}
c010626e:	c9                   	leave  
c010626f:	c3                   	ret    

c0106270 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0106270:	55                   	push   %ebp
c0106271:	89 e5                	mov    %esp,%ebp
c0106273:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106276:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010627d:	e9 ca 00 00 00       	jmp    c010634c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0106282:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106285:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106288:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010628b:	c1 e8 0c             	shr    $0xc,%eax
c010628e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106291:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c0106296:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106299:	72 23                	jb     c01062be <check_boot_pgdir+0x4e>
c010629b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010629e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01062a2:	c7 44 24 08 94 81 10 	movl   $0xc0108194,0x8(%esp)
c01062a9:	c0 
c01062aa:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01062b1:	00 
c01062b2:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01062b9:	e8 13 aa ff ff       	call   c0100cd1 <__panic>
c01062be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062c1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01062c6:	89 c2                	mov    %eax,%edx
c01062c8:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c01062cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062d4:	00 
c01062d5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062d9:	89 04 24             	mov    %eax,(%esp)
c01062dc:	e8 80 f5 ff ff       	call   c0105861 <get_pte>
c01062e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01062e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01062e8:	75 24                	jne    c010630e <check_boot_pgdir+0x9e>
c01062ea:	c7 44 24 0c 64 85 10 	movl   $0xc0108564,0xc(%esp)
c01062f1:	c0 
c01062f2:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01062f9:	c0 
c01062fa:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0106301:	00 
c0106302:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106309:	e8 c3 a9 ff ff       	call   c0100cd1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010630e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106311:	8b 00                	mov    (%eax),%eax
c0106313:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106318:	89 c2                	mov    %eax,%edx
c010631a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010631d:	39 c2                	cmp    %eax,%edx
c010631f:	74 24                	je     c0106345 <check_boot_pgdir+0xd5>
c0106321:	c7 44 24 0c a1 85 10 	movl   $0xc01085a1,0xc(%esp)
c0106328:	c0 
c0106329:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106330:	c0 
c0106331:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0106338:	00 
c0106339:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106340:	e8 8c a9 ff ff       	call   c0100cd1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106345:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010634c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010634f:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c0106354:	39 c2                	cmp    %eax,%edx
c0106356:	0f 82 26 ff ff ff    	jb     c0106282 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010635c:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0106361:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106366:	8b 00                	mov    (%eax),%eax
c0106368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010636d:	89 c2                	mov    %eax,%edx
c010636f:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0106374:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106377:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c010637e:	77 23                	ja     c01063a3 <check_boot_pgdir+0x133>
c0106380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106383:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106387:	c7 44 24 08 38 82 10 	movl   $0xc0108238,0x8(%esp)
c010638e:	c0 
c010638f:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0106396:	00 
c0106397:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c010639e:	e8 2e a9 ff ff       	call   c0100cd1 <__panic>
c01063a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063a6:	05 00 00 00 40       	add    $0x40000000,%eax
c01063ab:	39 c2                	cmp    %eax,%edx
c01063ad:	74 24                	je     c01063d3 <check_boot_pgdir+0x163>
c01063af:	c7 44 24 0c b8 85 10 	movl   $0xc01085b8,0xc(%esp)
c01063b6:	c0 
c01063b7:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01063be:	c0 
c01063bf:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c01063c6:	00 
c01063c7:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01063ce:	e8 fe a8 ff ff       	call   c0100cd1 <__panic>

    assert(boot_pgdir[0] == 0);
c01063d3:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c01063d8:	8b 00                	mov    (%eax),%eax
c01063da:	85 c0                	test   %eax,%eax
c01063dc:	74 24                	je     c0106402 <check_boot_pgdir+0x192>
c01063de:	c7 44 24 0c ec 85 10 	movl   $0xc01085ec,0xc(%esp)
c01063e5:	c0 
c01063e6:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01063ed:	c0 
c01063ee:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01063f5:	00 
c01063f6:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01063fd:	e8 cf a8 ff ff       	call   c0100cd1 <__panic>

    struct Page *p;
    p = alloc_page();
c0106402:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106409:	e8 16 ed ff ff       	call   c0105124 <alloc_pages>
c010640e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106411:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0106416:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010641d:	00 
c010641e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0106425:	00 
c0106426:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106429:	89 54 24 04          	mov    %edx,0x4(%esp)
c010642d:	89 04 24             	mov    %eax,(%esp)
c0106430:	e8 6c f6 ff ff       	call   c0105aa1 <page_insert>
c0106435:	85 c0                	test   %eax,%eax
c0106437:	74 24                	je     c010645d <check_boot_pgdir+0x1ed>
c0106439:	c7 44 24 0c 00 86 10 	movl   $0xc0108600,0xc(%esp)
c0106440:	c0 
c0106441:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106448:	c0 
c0106449:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0106450:	00 
c0106451:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106458:	e8 74 a8 ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p) == 1);
c010645d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106460:	89 04 24             	mov    %eax,(%esp)
c0106463:	e8 b7 ea ff ff       	call   c0104f1f <page_ref>
c0106468:	83 f8 01             	cmp    $0x1,%eax
c010646b:	74 24                	je     c0106491 <check_boot_pgdir+0x221>
c010646d:	c7 44 24 0c 2e 86 10 	movl   $0xc010862e,0xc(%esp)
c0106474:	c0 
c0106475:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c010647c:	c0 
c010647d:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0106484:	00 
c0106485:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c010648c:	e8 40 a8 ff ff       	call   c0100cd1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0106491:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c0106496:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010649d:	00 
c010649e:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01064a5:	00 
c01064a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01064a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064ad:	89 04 24             	mov    %eax,(%esp)
c01064b0:	e8 ec f5 ff ff       	call   c0105aa1 <page_insert>
c01064b5:	85 c0                	test   %eax,%eax
c01064b7:	74 24                	je     c01064dd <check_boot_pgdir+0x26d>
c01064b9:	c7 44 24 0c 40 86 10 	movl   $0xc0108640,0xc(%esp)
c01064c0:	c0 
c01064c1:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01064c8:	c0 
c01064c9:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c01064d0:	00 
c01064d1:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01064d8:	e8 f4 a7 ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p) == 2);
c01064dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01064e0:	89 04 24             	mov    %eax,(%esp)
c01064e3:	e8 37 ea ff ff       	call   c0104f1f <page_ref>
c01064e8:	83 f8 02             	cmp    $0x2,%eax
c01064eb:	74 24                	je     c0106511 <check_boot_pgdir+0x2a1>
c01064ed:	c7 44 24 0c 77 86 10 	movl   $0xc0108677,0xc(%esp)
c01064f4:	c0 
c01064f5:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c01064fc:	c0 
c01064fd:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0106504:	00 
c0106505:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c010650c:	e8 c0 a7 ff ff       	call   c0100cd1 <__panic>

    const char *str = "ucore: Hello world!!";
c0106511:	c7 45 dc 88 86 10 c0 	movl   $0xc0108688,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106518:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010651b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010651f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106526:	e8 1e 0a 00 00       	call   c0106f49 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010652b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106532:	00 
c0106533:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010653a:	e8 83 0a 00 00       	call   c0106fc2 <strcmp>
c010653f:	85 c0                	test   %eax,%eax
c0106541:	74 24                	je     c0106567 <check_boot_pgdir+0x2f7>
c0106543:	c7 44 24 0c a0 86 10 	movl   $0xc01086a0,0xc(%esp)
c010654a:	c0 
c010654b:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106552:	c0 
c0106553:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c010655a:	00 
c010655b:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c0106562:	e8 6a a7 ff ff       	call   c0100cd1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106567:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010656a:	89 04 24             	mov    %eax,(%esp)
c010656d:	e8 1b e9 ff ff       	call   c0104e8d <page2kva>
c0106572:	05 00 01 00 00       	add    $0x100,%eax
c0106577:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010657a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106581:	e8 6b 09 00 00       	call   c0106ef1 <strlen>
c0106586:	85 c0                	test   %eax,%eax
c0106588:	74 24                	je     c01065ae <check_boot_pgdir+0x33e>
c010658a:	c7 44 24 0c d8 86 10 	movl   $0xc01086d8,0xc(%esp)
c0106591:	c0 
c0106592:	c7 44 24 08 81 82 10 	movl   $0xc0108281,0x8(%esp)
c0106599:	c0 
c010659a:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c01065a1:	00 
c01065a2:	c7 04 24 5c 82 10 c0 	movl   $0xc010825c,(%esp)
c01065a9:	e8 23 a7 ff ff       	call   c0100cd1 <__panic>

    free_page(p);
c01065ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01065b5:	00 
c01065b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01065b9:	89 04 24             	mov    %eax,(%esp)
c01065bc:	e8 9b eb ff ff       	call   c010515c <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01065c1:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c01065c6:	8b 00                	mov    (%eax),%eax
c01065c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01065cd:	89 04 24             	mov    %eax,(%esp)
c01065d0:	e8 6a e8 ff ff       	call   c0104e3f <pa2page>
c01065d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01065dc:	00 
c01065dd:	89 04 24             	mov    %eax,(%esp)
c01065e0:	e8 77 eb ff ff       	call   c010515c <free_pages>
    boot_pgdir[0] = 0;
c01065e5:	a1 a4 b9 11 c0       	mov    0xc011b9a4,%eax
c01065ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01065f0:	c7 04 24 fc 86 10 c0 	movl   $0xc01086fc,(%esp)
c01065f7:	e8 4b 9d ff ff       	call   c0100347 <cprintf>
}
c01065fc:	c9                   	leave  
c01065fd:	c3                   	ret    

c01065fe <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01065fe:	55                   	push   %ebp
c01065ff:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106601:	8b 45 08             	mov    0x8(%ebp),%eax
c0106604:	83 e0 04             	and    $0x4,%eax
c0106607:	85 c0                	test   %eax,%eax
c0106609:	74 07                	je     c0106612 <perm2str+0x14>
c010660b:	b8 75 00 00 00       	mov    $0x75,%eax
c0106610:	eb 05                	jmp    c0106617 <perm2str+0x19>
c0106612:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106617:	a2 28 ba 11 c0       	mov    %al,0xc011ba28
    str[1] = 'r';
c010661c:	c6 05 29 ba 11 c0 72 	movb   $0x72,0xc011ba29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106623:	8b 45 08             	mov    0x8(%ebp),%eax
c0106626:	83 e0 02             	and    $0x2,%eax
c0106629:	85 c0                	test   %eax,%eax
c010662b:	74 07                	je     c0106634 <perm2str+0x36>
c010662d:	b8 77 00 00 00       	mov    $0x77,%eax
c0106632:	eb 05                	jmp    c0106639 <perm2str+0x3b>
c0106634:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106639:	a2 2a ba 11 c0       	mov    %al,0xc011ba2a
    str[3] = '\0';
c010663e:	c6 05 2b ba 11 c0 00 	movb   $0x0,0xc011ba2b
    return str;
c0106645:	b8 28 ba 11 c0       	mov    $0xc011ba28,%eax
}
c010664a:	5d                   	pop    %ebp
c010664b:	c3                   	ret    

c010664c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010664c:	55                   	push   %ebp
c010664d:	89 e5                	mov    %esp,%ebp
c010664f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106652:	8b 45 10             	mov    0x10(%ebp),%eax
c0106655:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106658:	72 0a                	jb     c0106664 <get_pgtable_items+0x18>
        return 0;
c010665a:	b8 00 00 00 00       	mov    $0x0,%eax
c010665f:	e9 9c 00 00 00       	jmp    c0106700 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106664:	eb 04                	jmp    c010666a <get_pgtable_items+0x1e>
        start ++;
c0106666:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010666a:	8b 45 10             	mov    0x10(%ebp),%eax
c010666d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106670:	73 18                	jae    c010668a <get_pgtable_items+0x3e>
c0106672:	8b 45 10             	mov    0x10(%ebp),%eax
c0106675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010667c:	8b 45 14             	mov    0x14(%ebp),%eax
c010667f:	01 d0                	add    %edx,%eax
c0106681:	8b 00                	mov    (%eax),%eax
c0106683:	83 e0 01             	and    $0x1,%eax
c0106686:	85 c0                	test   %eax,%eax
c0106688:	74 dc                	je     c0106666 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010668a:	8b 45 10             	mov    0x10(%ebp),%eax
c010668d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106690:	73 69                	jae    c01066fb <get_pgtable_items+0xaf>
    	//记录左边界
        if (left_store != NULL) {
c0106692:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106696:	74 08                	je     c01066a0 <get_pgtable_items+0x54>
            *left_store = start;
c0106698:	8b 45 18             	mov    0x18(%ebp),%eax
c010669b:	8b 55 10             	mov    0x10(%ebp),%edx
c010669e:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01066a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01066a3:	8d 50 01             	lea    0x1(%eax),%edx
c01066a6:	89 55 10             	mov    %edx,0x10(%ebp)
c01066a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01066b0:	8b 45 14             	mov    0x14(%ebp),%eax
c01066b3:	01 d0                	add    %edx,%eax
c01066b5:	8b 00                	mov    (%eax),%eax
c01066b7:	83 e0 07             	and    $0x7,%eax
c01066ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01066bd:	eb 04                	jmp    c01066c3 <get_pgtable_items+0x77>
            start ++;
c01066bf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    	//记录左边界
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01066c3:	8b 45 10             	mov    0x10(%ebp),%eax
c01066c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01066c9:	73 1d                	jae    c01066e8 <get_pgtable_items+0x9c>
c01066cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01066ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01066d5:	8b 45 14             	mov    0x14(%ebp),%eax
c01066d8:	01 d0                	add    %edx,%eax
c01066da:	8b 00                	mov    (%eax),%eax
c01066dc:	83 e0 07             	and    $0x7,%eax
c01066df:	89 c2                	mov    %eax,%edx
c01066e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01066e4:	39 c2                	cmp    %eax,%edx
c01066e6:	74 d7                	je     c01066bf <get_pgtable_items+0x73>
            start ++;
        }
        //跳出循环，记录右边界
        if (right_store != NULL) {
c01066e8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01066ec:	74 08                	je     c01066f6 <get_pgtable_items+0xaa>
            *right_store = start;
c01066ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01066f1:	8b 55 10             	mov    0x10(%ebp),%edx
c01066f4:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01066f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01066f9:	eb 05                	jmp    c0106700 <get_pgtable_items+0xb4>
    }
    return 0;
c01066fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106700:	c9                   	leave  
c0106701:	c3                   	ret    

c0106702 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106702:	55                   	push   %ebp
c0106703:	89 e5                	mov    %esp,%ebp
c0106705:	57                   	push   %edi
c0106706:	56                   	push   %esi
c0106707:	53                   	push   %ebx
c0106708:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010670b:	c7 04 24 1c 87 10 c0 	movl   $0xc010871c,(%esp)
c0106712:	e8 30 9c ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
c0106717:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010671e:	e9 fa 00 00 00       	jmp    c010681d <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106726:	89 04 24             	mov    %eax,(%esp)
c0106729:	e8 d0 fe ff ff       	call   c01065fe <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010672e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106731:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106734:	29 d1                	sub    %edx,%ecx
c0106736:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106738:	89 d6                	mov    %edx,%esi
c010673a:	c1 e6 16             	shl    $0x16,%esi
c010673d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106740:	89 d3                	mov    %edx,%ebx
c0106742:	c1 e3 16             	shl    $0x16,%ebx
c0106745:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106748:	89 d1                	mov    %edx,%ecx
c010674a:	c1 e1 16             	shl    $0x16,%ecx
c010674d:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106750:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106753:	29 d7                	sub    %edx,%edi
c0106755:	89 fa                	mov    %edi,%edx
c0106757:	89 44 24 14          	mov    %eax,0x14(%esp)
c010675b:	89 74 24 10          	mov    %esi,0x10(%esp)
c010675f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106763:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106767:	89 54 24 04          	mov    %edx,0x4(%esp)
c010676b:	c7 04 24 4d 87 10 c0 	movl   $0xc010874d,(%esp)
c0106772:	e8 d0 9b ff ff       	call   c0100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106777:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010677a:	c1 e0 0a             	shl    $0xa,%eax
c010677d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106780:	eb 54                	jmp    c01067d6 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106785:	89 04 24             	mov    %eax,(%esp)
c0106788:	e8 71 fe ff ff       	call   c01065fe <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010678d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106790:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106793:	29 d1                	sub    %edx,%ecx
c0106795:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106797:	89 d6                	mov    %edx,%esi
c0106799:	c1 e6 0c             	shl    $0xc,%esi
c010679c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010679f:	89 d3                	mov    %edx,%ebx
c01067a1:	c1 e3 0c             	shl    $0xc,%ebx
c01067a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01067a7:	c1 e2 0c             	shl    $0xc,%edx
c01067aa:	89 d1                	mov    %edx,%ecx
c01067ac:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01067af:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01067b2:	29 d7                	sub    %edx,%edi
c01067b4:	89 fa                	mov    %edi,%edx
c01067b6:	89 44 24 14          	mov    %eax,0x14(%esp)
c01067ba:	89 74 24 10          	mov    %esi,0x10(%esp)
c01067be:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01067c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01067c6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01067ca:	c7 04 24 6c 87 10 c0 	movl   $0xc010876c,(%esp)
c01067d1:	e8 71 9b ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01067d6:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01067db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01067de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01067e1:	89 ce                	mov    %ecx,%esi
c01067e3:	c1 e6 0a             	shl    $0xa,%esi
c01067e6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01067e9:	89 cb                	mov    %ecx,%ebx
c01067eb:	c1 e3 0a             	shl    $0xa,%ebx
c01067ee:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01067f1:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01067f5:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01067f8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01067fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106800:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106804:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106808:	89 1c 24             	mov    %ebx,(%esp)
c010680b:	e8 3c fe ff ff       	call   c010664c <get_pgtable_items>
c0106810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106813:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106817:	0f 85 65 ff ff ff    	jne    c0106782 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010681d:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106822:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106825:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106828:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010682c:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010682f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106833:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106837:	89 44 24 08          	mov    %eax,0x8(%esp)
c010683b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106842:	00 
c0106843:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010684a:	e8 fd fd ff ff       	call   c010664c <get_pgtable_items>
c010684f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106852:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106856:	0f 85 c7 fe ff ff    	jne    c0106723 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010685c:	c7 04 24 90 87 10 c0 	movl   $0xc0108790,(%esp)
c0106863:	e8 df 9a ff ff       	call   c0100347 <cprintf>
}
c0106868:	83 c4 4c             	add    $0x4c,%esp
c010686b:	5b                   	pop    %ebx
c010686c:	5e                   	pop    %esi
c010686d:	5f                   	pop    %edi
c010686e:	5d                   	pop    %ebp
c010686f:	c3                   	ret    

c0106870 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0106870:	55                   	push   %ebp
c0106871:	89 e5                	mov    %esp,%ebp
c0106873:	83 ec 58             	sub    $0x58,%esp
c0106876:	8b 45 10             	mov    0x10(%ebp),%eax
c0106879:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010687c:	8b 45 14             	mov    0x14(%ebp),%eax
c010687f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0106882:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106888:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010688b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010688e:	8b 45 18             	mov    0x18(%ebp),%eax
c0106891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106894:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106897:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010689a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010689d:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01068a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01068a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01068aa:	74 1c                	je     c01068c8 <printnum+0x58>
c01068ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068af:	ba 00 00 00 00       	mov    $0x0,%edx
c01068b4:	f7 75 e4             	divl   -0x1c(%ebp)
c01068b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01068ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068bd:	ba 00 00 00 00       	mov    $0x0,%edx
c01068c2:	f7 75 e4             	divl   -0x1c(%ebp)
c01068c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01068c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01068ce:	f7 75 e4             	divl   -0x1c(%ebp)
c01068d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01068d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01068d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068da:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01068dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01068e0:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01068e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01068e6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01068e9:	8b 45 18             	mov    0x18(%ebp),%eax
c01068ec:	ba 00 00 00 00       	mov    $0x0,%edx
c01068f1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01068f4:	77 56                	ja     c010694c <printnum+0xdc>
c01068f6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01068f9:	72 05                	jb     c0106900 <printnum+0x90>
c01068fb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01068fe:	77 4c                	ja     c010694c <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0106900:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106903:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106906:	8b 45 20             	mov    0x20(%ebp),%eax
c0106909:	89 44 24 18          	mov    %eax,0x18(%esp)
c010690d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106911:	8b 45 18             	mov    0x18(%ebp),%eax
c0106914:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106918:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010691b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010691e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106922:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106926:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010692d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106930:	89 04 24             	mov    %eax,(%esp)
c0106933:	e8 38 ff ff ff       	call   c0106870 <printnum>
c0106938:	eb 1c                	jmp    c0106956 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010693a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010693d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106941:	8b 45 20             	mov    0x20(%ebp),%eax
c0106944:	89 04 24             	mov    %eax,(%esp)
c0106947:	8b 45 08             	mov    0x8(%ebp),%eax
c010694a:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010694c:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0106950:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106954:	7f e4                	jg     c010693a <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0106956:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106959:	05 44 88 10 c0       	add    $0xc0108844,%eax
c010695e:	0f b6 00             	movzbl (%eax),%eax
c0106961:	0f be c0             	movsbl %al,%eax
c0106964:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106967:	89 54 24 04          	mov    %edx,0x4(%esp)
c010696b:	89 04 24             	mov    %eax,(%esp)
c010696e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106971:	ff d0                	call   *%eax
}
c0106973:	c9                   	leave  
c0106974:	c3                   	ret    

c0106975 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0106975:	55                   	push   %ebp
c0106976:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106978:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010697c:	7e 14                	jle    c0106992 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010697e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106981:	8b 00                	mov    (%eax),%eax
c0106983:	8d 48 08             	lea    0x8(%eax),%ecx
c0106986:	8b 55 08             	mov    0x8(%ebp),%edx
c0106989:	89 0a                	mov    %ecx,(%edx)
c010698b:	8b 50 04             	mov    0x4(%eax),%edx
c010698e:	8b 00                	mov    (%eax),%eax
c0106990:	eb 30                	jmp    c01069c2 <getuint+0x4d>
    }
    else if (lflag) {
c0106992:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106996:	74 16                	je     c01069ae <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0106998:	8b 45 08             	mov    0x8(%ebp),%eax
c010699b:	8b 00                	mov    (%eax),%eax
c010699d:	8d 48 04             	lea    0x4(%eax),%ecx
c01069a0:	8b 55 08             	mov    0x8(%ebp),%edx
c01069a3:	89 0a                	mov    %ecx,(%edx)
c01069a5:	8b 00                	mov    (%eax),%eax
c01069a7:	ba 00 00 00 00       	mov    $0x0,%edx
c01069ac:	eb 14                	jmp    c01069c2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01069ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01069b1:	8b 00                	mov    (%eax),%eax
c01069b3:	8d 48 04             	lea    0x4(%eax),%ecx
c01069b6:	8b 55 08             	mov    0x8(%ebp),%edx
c01069b9:	89 0a                	mov    %ecx,(%edx)
c01069bb:	8b 00                	mov    (%eax),%eax
c01069bd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01069c2:	5d                   	pop    %ebp
c01069c3:	c3                   	ret    

c01069c4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01069c4:	55                   	push   %ebp
c01069c5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01069c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01069cb:	7e 14                	jle    c01069e1 <getint+0x1d>
        return va_arg(*ap, long long);
c01069cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01069d0:	8b 00                	mov    (%eax),%eax
c01069d2:	8d 48 08             	lea    0x8(%eax),%ecx
c01069d5:	8b 55 08             	mov    0x8(%ebp),%edx
c01069d8:	89 0a                	mov    %ecx,(%edx)
c01069da:	8b 50 04             	mov    0x4(%eax),%edx
c01069dd:	8b 00                	mov    (%eax),%eax
c01069df:	eb 28                	jmp    c0106a09 <getint+0x45>
    }
    else if (lflag) {
c01069e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01069e5:	74 12                	je     c01069f9 <getint+0x35>
        return va_arg(*ap, long);
c01069e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ea:	8b 00                	mov    (%eax),%eax
c01069ec:	8d 48 04             	lea    0x4(%eax),%ecx
c01069ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01069f2:	89 0a                	mov    %ecx,(%edx)
c01069f4:	8b 00                	mov    (%eax),%eax
c01069f6:	99                   	cltd   
c01069f7:	eb 10                	jmp    c0106a09 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01069f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01069fc:	8b 00                	mov    (%eax),%eax
c01069fe:	8d 48 04             	lea    0x4(%eax),%ecx
c0106a01:	8b 55 08             	mov    0x8(%ebp),%edx
c0106a04:	89 0a                	mov    %ecx,(%edx)
c0106a06:	8b 00                	mov    (%eax),%eax
c0106a08:	99                   	cltd   
    }
}
c0106a09:	5d                   	pop    %ebp
c0106a0a:	c3                   	ret    

c0106a0b <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0106a0b:	55                   	push   %ebp
c0106a0c:	89 e5                	mov    %esp,%ebp
c0106a0e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0106a11:	8d 45 14             	lea    0x14(%ebp),%eax
c0106a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0106a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106a1e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a21:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106a25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a2f:	89 04 24             	mov    %eax,(%esp)
c0106a32:	e8 02 00 00 00       	call   c0106a39 <vprintfmt>
    va_end(ap);
}
c0106a37:	c9                   	leave  
c0106a38:	c3                   	ret    

c0106a39 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0106a39:	55                   	push   %ebp
c0106a3a:	89 e5                	mov    %esp,%ebp
c0106a3c:	56                   	push   %esi
c0106a3d:	53                   	push   %ebx
c0106a3e:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106a41:	eb 18                	jmp    c0106a5b <vprintfmt+0x22>
            if (ch == '\0') {
c0106a43:	85 db                	test   %ebx,%ebx
c0106a45:	75 05                	jne    c0106a4c <vprintfmt+0x13>
                return;
c0106a47:	e9 d1 03 00 00       	jmp    c0106e1d <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0106a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a53:	89 1c 24             	mov    %ebx,(%esp)
c0106a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a59:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106a5b:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a5e:	8d 50 01             	lea    0x1(%eax),%edx
c0106a61:	89 55 10             	mov    %edx,0x10(%ebp)
c0106a64:	0f b6 00             	movzbl (%eax),%eax
c0106a67:	0f b6 d8             	movzbl %al,%ebx
c0106a6a:	83 fb 25             	cmp    $0x25,%ebx
c0106a6d:	75 d4                	jne    c0106a43 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0106a6f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0106a73:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0106a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0106a80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106a87:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a8a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0106a8d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a90:	8d 50 01             	lea    0x1(%eax),%edx
c0106a93:	89 55 10             	mov    %edx,0x10(%ebp)
c0106a96:	0f b6 00             	movzbl (%eax),%eax
c0106a99:	0f b6 d8             	movzbl %al,%ebx
c0106a9c:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0106a9f:	83 f8 55             	cmp    $0x55,%eax
c0106aa2:	0f 87 44 03 00 00    	ja     c0106dec <vprintfmt+0x3b3>
c0106aa8:	8b 04 85 68 88 10 c0 	mov    -0x3fef7798(,%eax,4),%eax
c0106aaf:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0106ab1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0106ab5:	eb d6                	jmp    c0106a8d <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0106ab7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0106abb:	eb d0                	jmp    c0106a8d <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106abd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0106ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ac7:	89 d0                	mov    %edx,%eax
c0106ac9:	c1 e0 02             	shl    $0x2,%eax
c0106acc:	01 d0                	add    %edx,%eax
c0106ace:	01 c0                	add    %eax,%eax
c0106ad0:	01 d8                	add    %ebx,%eax
c0106ad2:	83 e8 30             	sub    $0x30,%eax
c0106ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0106ad8:	8b 45 10             	mov    0x10(%ebp),%eax
c0106adb:	0f b6 00             	movzbl (%eax),%eax
c0106ade:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0106ae1:	83 fb 2f             	cmp    $0x2f,%ebx
c0106ae4:	7e 0b                	jle    c0106af1 <vprintfmt+0xb8>
c0106ae6:	83 fb 39             	cmp    $0x39,%ebx
c0106ae9:	7f 06                	jg     c0106af1 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106aeb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0106aef:	eb d3                	jmp    c0106ac4 <vprintfmt+0x8b>
            goto process_precision;
c0106af1:	eb 33                	jmp    c0106b26 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0106af3:	8b 45 14             	mov    0x14(%ebp),%eax
c0106af6:	8d 50 04             	lea    0x4(%eax),%edx
c0106af9:	89 55 14             	mov    %edx,0x14(%ebp)
c0106afc:	8b 00                	mov    (%eax),%eax
c0106afe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0106b01:	eb 23                	jmp    c0106b26 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0106b03:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106b07:	79 0c                	jns    c0106b15 <vprintfmt+0xdc>
                width = 0;
c0106b09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0106b10:	e9 78 ff ff ff       	jmp    c0106a8d <vprintfmt+0x54>
c0106b15:	e9 73 ff ff ff       	jmp    c0106a8d <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0106b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0106b21:	e9 67 ff ff ff       	jmp    c0106a8d <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0106b26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106b2a:	79 12                	jns    c0106b3e <vprintfmt+0x105>
                width = precision, precision = -1;
c0106b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106b32:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0106b39:	e9 4f ff ff ff       	jmp    c0106a8d <vprintfmt+0x54>
c0106b3e:	e9 4a ff ff ff       	jmp    c0106a8d <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106b43:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0106b47:	e9 41 ff ff ff       	jmp    c0106a8d <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0106b4c:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b4f:	8d 50 04             	lea    0x4(%eax),%edx
c0106b52:	89 55 14             	mov    %edx,0x14(%ebp)
c0106b55:	8b 00                	mov    (%eax),%eax
c0106b57:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106b5a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b5e:	89 04 24             	mov    %eax,(%esp)
c0106b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b64:	ff d0                	call   *%eax
            break;
c0106b66:	e9 ac 02 00 00       	jmp    c0106e17 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0106b6b:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b6e:	8d 50 04             	lea    0x4(%eax),%edx
c0106b71:	89 55 14             	mov    %edx,0x14(%ebp)
c0106b74:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0106b76:	85 db                	test   %ebx,%ebx
c0106b78:	79 02                	jns    c0106b7c <vprintfmt+0x143>
                err = -err;
c0106b7a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0106b7c:	83 fb 06             	cmp    $0x6,%ebx
c0106b7f:	7f 0b                	jg     c0106b8c <vprintfmt+0x153>
c0106b81:	8b 34 9d 28 88 10 c0 	mov    -0x3fef77d8(,%ebx,4),%esi
c0106b88:	85 f6                	test   %esi,%esi
c0106b8a:	75 23                	jne    c0106baf <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0106b8c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106b90:	c7 44 24 08 55 88 10 	movl   $0xc0108855,0x8(%esp)
c0106b97:	c0 
c0106b98:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ba2:	89 04 24             	mov    %eax,(%esp)
c0106ba5:	e8 61 fe ff ff       	call   c0106a0b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0106baa:	e9 68 02 00 00       	jmp    c0106e17 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0106baf:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0106bb3:	c7 44 24 08 5e 88 10 	movl   $0xc010885e,0x8(%esp)
c0106bba:	c0 
c0106bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bc5:	89 04 24             	mov    %eax,(%esp)
c0106bc8:	e8 3e fe ff ff       	call   c0106a0b <printfmt>
            }
            break;
c0106bcd:	e9 45 02 00 00       	jmp    c0106e17 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0106bd2:	8b 45 14             	mov    0x14(%ebp),%eax
c0106bd5:	8d 50 04             	lea    0x4(%eax),%edx
c0106bd8:	89 55 14             	mov    %edx,0x14(%ebp)
c0106bdb:	8b 30                	mov    (%eax),%esi
c0106bdd:	85 f6                	test   %esi,%esi
c0106bdf:	75 05                	jne    c0106be6 <vprintfmt+0x1ad>
                p = "(null)";
c0106be1:	be 61 88 10 c0       	mov    $0xc0108861,%esi
            }
            if (width > 0 && padc != '-') {
c0106be6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106bea:	7e 3e                	jle    c0106c2a <vprintfmt+0x1f1>
c0106bec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0106bf0:	74 38                	je     c0106c2a <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106bf2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0106bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bfc:	89 34 24             	mov    %esi,(%esp)
c0106bff:	e8 15 03 00 00       	call   c0106f19 <strnlen>
c0106c04:	29 c3                	sub    %eax,%ebx
c0106c06:	89 d8                	mov    %ebx,%eax
c0106c08:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106c0b:	eb 17                	jmp    c0106c24 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0106c0d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0106c11:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106c14:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c18:	89 04 24             	mov    %eax,(%esp)
c0106c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c1e:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106c20:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106c24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106c28:	7f e3                	jg     c0106c0d <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106c2a:	eb 38                	jmp    c0106c64 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106c2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106c30:	74 1f                	je     c0106c51 <vprintfmt+0x218>
c0106c32:	83 fb 1f             	cmp    $0x1f,%ebx
c0106c35:	7e 05                	jle    c0106c3c <vprintfmt+0x203>
c0106c37:	83 fb 7e             	cmp    $0x7e,%ebx
c0106c3a:	7e 15                	jle    c0106c51 <vprintfmt+0x218>
                    putch('?', putdat);
c0106c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c43:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c4d:	ff d0                	call   *%eax
c0106c4f:	eb 0f                	jmp    c0106c60 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0106c51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c58:	89 1c 24             	mov    %ebx,(%esp)
c0106c5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c5e:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106c60:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106c64:	89 f0                	mov    %esi,%eax
c0106c66:	8d 70 01             	lea    0x1(%eax),%esi
c0106c69:	0f b6 00             	movzbl (%eax),%eax
c0106c6c:	0f be d8             	movsbl %al,%ebx
c0106c6f:	85 db                	test   %ebx,%ebx
c0106c71:	74 10                	je     c0106c83 <vprintfmt+0x24a>
c0106c73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106c77:	78 b3                	js     c0106c2c <vprintfmt+0x1f3>
c0106c79:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0106c7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106c81:	79 a9                	jns    c0106c2c <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0106c83:	eb 17                	jmp    c0106c9c <vprintfmt+0x263>
                putch(' ', putdat);
c0106c85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c8c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0106c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c96:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0106c98:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106c9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106ca0:	7f e3                	jg     c0106c85 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0106ca2:	e9 70 01 00 00       	jmp    c0106e17 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0106ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cae:	8d 45 14             	lea    0x14(%ebp),%eax
c0106cb1:	89 04 24             	mov    %eax,(%esp)
c0106cb4:	e8 0b fd ff ff       	call   c01069c4 <getint>
c0106cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0106cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106cc5:	85 d2                	test   %edx,%edx
c0106cc7:	79 26                	jns    c0106cef <vprintfmt+0x2b6>
                putch('-', putdat);
c0106cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cd0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0106cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cda:	ff d0                	call   *%eax
                num = -(long long)num;
c0106cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106ce2:	f7 d8                	neg    %eax
c0106ce4:	83 d2 00             	adc    $0x0,%edx
c0106ce7:	f7 da                	neg    %edx
c0106ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cec:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106cef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106cf6:	e9 a8 00 00 00       	jmp    c0106da3 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0106cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d02:	8d 45 14             	lea    0x14(%ebp),%eax
c0106d05:	89 04 24             	mov    %eax,(%esp)
c0106d08:	e8 68 fc ff ff       	call   c0106975 <getuint>
c0106d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d10:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0106d13:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106d1a:	e9 84 00 00 00       	jmp    c0106da3 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106d1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d26:	8d 45 14             	lea    0x14(%ebp),%eax
c0106d29:	89 04 24             	mov    %eax,(%esp)
c0106d2c:	e8 44 fc ff ff       	call   c0106975 <getuint>
c0106d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d34:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106d37:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0106d3e:	eb 63                	jmp    c0106da3 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0106d40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d47:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d51:	ff d0                	call   *%eax
            putch('x', putdat);
c0106d53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d5a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106d61:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d64:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0106d66:	8b 45 14             	mov    0x14(%ebp),%eax
c0106d69:	8d 50 04             	lea    0x4(%eax),%edx
c0106d6c:	89 55 14             	mov    %edx,0x14(%ebp)
c0106d6f:	8b 00                	mov    (%eax),%eax
c0106d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0106d7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106d82:	eb 1f                	jmp    c0106da3 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106d84:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d8b:	8d 45 14             	lea    0x14(%ebp),%eax
c0106d8e:	89 04 24             	mov    %eax,(%esp)
c0106d91:	e8 df fb ff ff       	call   c0106975 <getuint>
c0106d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d99:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0106d9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106da3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0106da7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106daa:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106dae:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106db1:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106db5:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106dbf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106dc3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106dca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106dce:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dd1:	89 04 24             	mov    %eax,(%esp)
c0106dd4:	e8 97 fa ff ff       	call   c0106870 <printnum>
            break;
c0106dd9:	eb 3c                	jmp    c0106e17 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106dde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106de2:	89 1c 24             	mov    %ebx,(%esp)
c0106de5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106de8:	ff d0                	call   *%eax
            break;
c0106dea:	eb 2b                	jmp    c0106e17 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106dec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106def:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106df3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0106dfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dfd:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106dff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106e03:	eb 04                	jmp    c0106e09 <vprintfmt+0x3d0>
c0106e05:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106e09:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e0c:	83 e8 01             	sub    $0x1,%eax
c0106e0f:	0f b6 00             	movzbl (%eax),%eax
c0106e12:	3c 25                	cmp    $0x25,%al
c0106e14:	75 ef                	jne    c0106e05 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0106e16:	90                   	nop
        }
    }
c0106e17:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106e18:	e9 3e fc ff ff       	jmp    c0106a5b <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0106e1d:	83 c4 40             	add    $0x40,%esp
c0106e20:	5b                   	pop    %ebx
c0106e21:	5e                   	pop    %esi
c0106e22:	5d                   	pop    %ebp
c0106e23:	c3                   	ret    

c0106e24 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106e24:	55                   	push   %ebp
c0106e25:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0106e27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e2a:	8b 40 08             	mov    0x8(%eax),%eax
c0106e2d:	8d 50 01             	lea    0x1(%eax),%edx
c0106e30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e33:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0106e36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e39:	8b 10                	mov    (%eax),%edx
c0106e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e3e:	8b 40 04             	mov    0x4(%eax),%eax
c0106e41:	39 c2                	cmp    %eax,%edx
c0106e43:	73 12                	jae    c0106e57 <sprintputch+0x33>
        *b->buf ++ = ch;
c0106e45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e48:	8b 00                	mov    (%eax),%eax
c0106e4a:	8d 48 01             	lea    0x1(%eax),%ecx
c0106e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e50:	89 0a                	mov    %ecx,(%edx)
c0106e52:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e55:	88 10                	mov    %dl,(%eax)
    }
}
c0106e57:	5d                   	pop    %ebp
c0106e58:	c3                   	ret    

c0106e59 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106e59:	55                   	push   %ebp
c0106e5a:	89 e5                	mov    %esp,%ebp
c0106e5c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106e5f:	8d 45 14             	lea    0x14(%ebp),%eax
c0106e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e68:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106e6c:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e6f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106e73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e7d:	89 04 24             	mov    %eax,(%esp)
c0106e80:	e8 08 00 00 00       	call   c0106e8d <vsnprintf>
c0106e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106e8b:	c9                   	leave  
c0106e8c:	c3                   	ret    

c0106e8d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106e8d:	55                   	push   %ebp
c0106e8e:	89 e5                	mov    %esp,%ebp
c0106e90:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106e99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e9c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106e9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ea2:	01 d0                	add    %edx,%eax
c0106ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ea7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106eae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106eb2:	74 0a                	je     c0106ebe <vsnprintf+0x31>
c0106eb4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106eba:	39 c2                	cmp    %eax,%edx
c0106ebc:	76 07                	jbe    c0106ec5 <vsnprintf+0x38>
        return -E_INVAL;
c0106ebe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106ec3:	eb 2a                	jmp    c0106eef <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106ec5:	8b 45 14             	mov    0x14(%ebp),%eax
c0106ec8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106ecc:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ecf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106ed3:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106eda:	c7 04 24 24 6e 10 c0 	movl   $0xc0106e24,(%esp)
c0106ee1:	e8 53 fb ff ff       	call   c0106a39 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0106ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ee9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106eef:	c9                   	leave  
c0106ef0:	c3                   	ret    

c0106ef1 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0106ef1:	55                   	push   %ebp
c0106ef2:	89 e5                	mov    %esp,%ebp
c0106ef4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0106ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0106efe:	eb 04                	jmp    c0106f04 <strlen+0x13>
        cnt ++;
c0106f00:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0106f04:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f07:	8d 50 01             	lea    0x1(%eax),%edx
c0106f0a:	89 55 08             	mov    %edx,0x8(%ebp)
c0106f0d:	0f b6 00             	movzbl (%eax),%eax
c0106f10:	84 c0                	test   %al,%al
c0106f12:	75 ec                	jne    c0106f00 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0106f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106f17:	c9                   	leave  
c0106f18:	c3                   	ret    

c0106f19 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0106f19:	55                   	push   %ebp
c0106f1a:	89 e5                	mov    %esp,%ebp
c0106f1c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0106f1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0106f26:	eb 04                	jmp    c0106f2c <strnlen+0x13>
        cnt ++;
c0106f28:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0106f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106f32:	73 10                	jae    c0106f44 <strnlen+0x2b>
c0106f34:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f37:	8d 50 01             	lea    0x1(%eax),%edx
c0106f3a:	89 55 08             	mov    %edx,0x8(%ebp)
c0106f3d:	0f b6 00             	movzbl (%eax),%eax
c0106f40:	84 c0                	test   %al,%al
c0106f42:	75 e4                	jne    c0106f28 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0106f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106f47:	c9                   	leave  
c0106f48:	c3                   	ret    

c0106f49 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0106f49:	55                   	push   %ebp
c0106f4a:	89 e5                	mov    %esp,%ebp
c0106f4c:	57                   	push   %edi
c0106f4d:	56                   	push   %esi
c0106f4e:	83 ec 20             	sub    $0x20,%esp
c0106f51:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106f57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0106f5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f63:	89 d1                	mov    %edx,%ecx
c0106f65:	89 c2                	mov    %eax,%edx
c0106f67:	89 ce                	mov    %ecx,%esi
c0106f69:	89 d7                	mov    %edx,%edi
c0106f6b:	ac                   	lods   %ds:(%esi),%al
c0106f6c:	aa                   	stos   %al,%es:(%edi)
c0106f6d:	84 c0                	test   %al,%al
c0106f6f:	75 fa                	jne    c0106f6b <strcpy+0x22>
c0106f71:	89 fa                	mov    %edi,%edx
c0106f73:	89 f1                	mov    %esi,%ecx
c0106f75:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106f78:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0106f7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0106f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0106f81:	83 c4 20             	add    $0x20,%esp
c0106f84:	5e                   	pop    %esi
c0106f85:	5f                   	pop    %edi
c0106f86:	5d                   	pop    %ebp
c0106f87:	c3                   	ret    

c0106f88 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0106f88:	55                   	push   %ebp
c0106f89:	89 e5                	mov    %esp,%ebp
c0106f8b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0106f8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0106f94:	eb 21                	jmp    c0106fb7 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0106f96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f99:	0f b6 10             	movzbl (%eax),%edx
c0106f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f9f:	88 10                	mov    %dl,(%eax)
c0106fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106fa4:	0f b6 00             	movzbl (%eax),%eax
c0106fa7:	84 c0                	test   %al,%al
c0106fa9:	74 04                	je     c0106faf <strncpy+0x27>
            src ++;
c0106fab:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0106faf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106fb3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0106fb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106fbb:	75 d9                	jne    c0106f96 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0106fbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0106fc0:	c9                   	leave  
c0106fc1:	c3                   	ret    

c0106fc2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0106fc2:	55                   	push   %ebp
c0106fc3:	89 e5                	mov    %esp,%ebp
c0106fc5:	57                   	push   %edi
c0106fc6:	56                   	push   %esi
c0106fc7:	83 ec 20             	sub    $0x20,%esp
c0106fca:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0106fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fdc:	89 d1                	mov    %edx,%ecx
c0106fde:	89 c2                	mov    %eax,%edx
c0106fe0:	89 ce                	mov    %ecx,%esi
c0106fe2:	89 d7                	mov    %edx,%edi
c0106fe4:	ac                   	lods   %ds:(%esi),%al
c0106fe5:	ae                   	scas   %es:(%edi),%al
c0106fe6:	75 08                	jne    c0106ff0 <strcmp+0x2e>
c0106fe8:	84 c0                	test   %al,%al
c0106fea:	75 f8                	jne    c0106fe4 <strcmp+0x22>
c0106fec:	31 c0                	xor    %eax,%eax
c0106fee:	eb 04                	jmp    c0106ff4 <strcmp+0x32>
c0106ff0:	19 c0                	sbb    %eax,%eax
c0106ff2:	0c 01                	or     $0x1,%al
c0106ff4:	89 fa                	mov    %edi,%edx
c0106ff6:	89 f1                	mov    %esi,%ecx
c0106ff8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106ffb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106ffe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0107001:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0107004:	83 c4 20             	add    $0x20,%esp
c0107007:	5e                   	pop    %esi
c0107008:	5f                   	pop    %edi
c0107009:	5d                   	pop    %ebp
c010700a:	c3                   	ret    

c010700b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010700b:	55                   	push   %ebp
c010700c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010700e:	eb 0c                	jmp    c010701c <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0107010:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0107014:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107018:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010701c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107020:	74 1a                	je     c010703c <strncmp+0x31>
c0107022:	8b 45 08             	mov    0x8(%ebp),%eax
c0107025:	0f b6 00             	movzbl (%eax),%eax
c0107028:	84 c0                	test   %al,%al
c010702a:	74 10                	je     c010703c <strncmp+0x31>
c010702c:	8b 45 08             	mov    0x8(%ebp),%eax
c010702f:	0f b6 10             	movzbl (%eax),%edx
c0107032:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107035:	0f b6 00             	movzbl (%eax),%eax
c0107038:	38 c2                	cmp    %al,%dl
c010703a:	74 d4                	je     c0107010 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010703c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107040:	74 18                	je     c010705a <strncmp+0x4f>
c0107042:	8b 45 08             	mov    0x8(%ebp),%eax
c0107045:	0f b6 00             	movzbl (%eax),%eax
c0107048:	0f b6 d0             	movzbl %al,%edx
c010704b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010704e:	0f b6 00             	movzbl (%eax),%eax
c0107051:	0f b6 c0             	movzbl %al,%eax
c0107054:	29 c2                	sub    %eax,%edx
c0107056:	89 d0                	mov    %edx,%eax
c0107058:	eb 05                	jmp    c010705f <strncmp+0x54>
c010705a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010705f:	5d                   	pop    %ebp
c0107060:	c3                   	ret    

c0107061 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0107061:	55                   	push   %ebp
c0107062:	89 e5                	mov    %esp,%ebp
c0107064:	83 ec 04             	sub    $0x4,%esp
c0107067:	8b 45 0c             	mov    0xc(%ebp),%eax
c010706a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010706d:	eb 14                	jmp    c0107083 <strchr+0x22>
        if (*s == c) {
c010706f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107072:	0f b6 00             	movzbl (%eax),%eax
c0107075:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0107078:	75 05                	jne    c010707f <strchr+0x1e>
            return (char *)s;
c010707a:	8b 45 08             	mov    0x8(%ebp),%eax
c010707d:	eb 13                	jmp    c0107092 <strchr+0x31>
        }
        s ++;
c010707f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0107083:	8b 45 08             	mov    0x8(%ebp),%eax
c0107086:	0f b6 00             	movzbl (%eax),%eax
c0107089:	84 c0                	test   %al,%al
c010708b:	75 e2                	jne    c010706f <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010708d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107092:	c9                   	leave  
c0107093:	c3                   	ret    

c0107094 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0107094:	55                   	push   %ebp
c0107095:	89 e5                	mov    %esp,%ebp
c0107097:	83 ec 04             	sub    $0x4,%esp
c010709a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010709d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01070a0:	eb 11                	jmp    c01070b3 <strfind+0x1f>
        if (*s == c) {
c01070a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01070a5:	0f b6 00             	movzbl (%eax),%eax
c01070a8:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01070ab:	75 02                	jne    c01070af <strfind+0x1b>
            break;
c01070ad:	eb 0e                	jmp    c01070bd <strfind+0x29>
        }
        s ++;
c01070af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01070b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01070b6:	0f b6 00             	movzbl (%eax),%eax
c01070b9:	84 c0                	test   %al,%al
c01070bb:	75 e5                	jne    c01070a2 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c01070bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01070c0:	c9                   	leave  
c01070c1:	c3                   	ret    

c01070c2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01070c2:	55                   	push   %ebp
c01070c3:	89 e5                	mov    %esp,%ebp
c01070c5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01070c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01070cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01070d6:	eb 04                	jmp    c01070dc <strtol+0x1a>
        s ++;
c01070d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01070dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01070df:	0f b6 00             	movzbl (%eax),%eax
c01070e2:	3c 20                	cmp    $0x20,%al
c01070e4:	74 f2                	je     c01070d8 <strtol+0x16>
c01070e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01070e9:	0f b6 00             	movzbl (%eax),%eax
c01070ec:	3c 09                	cmp    $0x9,%al
c01070ee:	74 e8                	je     c01070d8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01070f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01070f3:	0f b6 00             	movzbl (%eax),%eax
c01070f6:	3c 2b                	cmp    $0x2b,%al
c01070f8:	75 06                	jne    c0107100 <strtol+0x3e>
        s ++;
c01070fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01070fe:	eb 15                	jmp    c0107115 <strtol+0x53>
    }
    else if (*s == '-') {
c0107100:	8b 45 08             	mov    0x8(%ebp),%eax
c0107103:	0f b6 00             	movzbl (%eax),%eax
c0107106:	3c 2d                	cmp    $0x2d,%al
c0107108:	75 0b                	jne    c0107115 <strtol+0x53>
        s ++, neg = 1;
c010710a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010710e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0107115:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107119:	74 06                	je     c0107121 <strtol+0x5f>
c010711b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010711f:	75 24                	jne    c0107145 <strtol+0x83>
c0107121:	8b 45 08             	mov    0x8(%ebp),%eax
c0107124:	0f b6 00             	movzbl (%eax),%eax
c0107127:	3c 30                	cmp    $0x30,%al
c0107129:	75 1a                	jne    c0107145 <strtol+0x83>
c010712b:	8b 45 08             	mov    0x8(%ebp),%eax
c010712e:	83 c0 01             	add    $0x1,%eax
c0107131:	0f b6 00             	movzbl (%eax),%eax
c0107134:	3c 78                	cmp    $0x78,%al
c0107136:	75 0d                	jne    c0107145 <strtol+0x83>
        s += 2, base = 16;
c0107138:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010713c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0107143:	eb 2a                	jmp    c010716f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0107145:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107149:	75 17                	jne    c0107162 <strtol+0xa0>
c010714b:	8b 45 08             	mov    0x8(%ebp),%eax
c010714e:	0f b6 00             	movzbl (%eax),%eax
c0107151:	3c 30                	cmp    $0x30,%al
c0107153:	75 0d                	jne    c0107162 <strtol+0xa0>
        s ++, base = 8;
c0107155:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107159:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0107160:	eb 0d                	jmp    c010716f <strtol+0xad>
    }
    else if (base == 0) {
c0107162:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107166:	75 07                	jne    c010716f <strtol+0xad>
        base = 10;
c0107168:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010716f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107172:	0f b6 00             	movzbl (%eax),%eax
c0107175:	3c 2f                	cmp    $0x2f,%al
c0107177:	7e 1b                	jle    c0107194 <strtol+0xd2>
c0107179:	8b 45 08             	mov    0x8(%ebp),%eax
c010717c:	0f b6 00             	movzbl (%eax),%eax
c010717f:	3c 39                	cmp    $0x39,%al
c0107181:	7f 11                	jg     c0107194 <strtol+0xd2>
            dig = *s - '0';
c0107183:	8b 45 08             	mov    0x8(%ebp),%eax
c0107186:	0f b6 00             	movzbl (%eax),%eax
c0107189:	0f be c0             	movsbl %al,%eax
c010718c:	83 e8 30             	sub    $0x30,%eax
c010718f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107192:	eb 48                	jmp    c01071dc <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0107194:	8b 45 08             	mov    0x8(%ebp),%eax
c0107197:	0f b6 00             	movzbl (%eax),%eax
c010719a:	3c 60                	cmp    $0x60,%al
c010719c:	7e 1b                	jle    c01071b9 <strtol+0xf7>
c010719e:	8b 45 08             	mov    0x8(%ebp),%eax
c01071a1:	0f b6 00             	movzbl (%eax),%eax
c01071a4:	3c 7a                	cmp    $0x7a,%al
c01071a6:	7f 11                	jg     c01071b9 <strtol+0xf7>
            dig = *s - 'a' + 10;
c01071a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01071ab:	0f b6 00             	movzbl (%eax),%eax
c01071ae:	0f be c0             	movsbl %al,%eax
c01071b1:	83 e8 57             	sub    $0x57,%eax
c01071b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01071b7:	eb 23                	jmp    c01071dc <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01071b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01071bc:	0f b6 00             	movzbl (%eax),%eax
c01071bf:	3c 40                	cmp    $0x40,%al
c01071c1:	7e 3d                	jle    c0107200 <strtol+0x13e>
c01071c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01071c6:	0f b6 00             	movzbl (%eax),%eax
c01071c9:	3c 5a                	cmp    $0x5a,%al
c01071cb:	7f 33                	jg     c0107200 <strtol+0x13e>
            dig = *s - 'A' + 10;
c01071cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01071d0:	0f b6 00             	movzbl (%eax),%eax
c01071d3:	0f be c0             	movsbl %al,%eax
c01071d6:	83 e8 37             	sub    $0x37,%eax
c01071d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01071dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071df:	3b 45 10             	cmp    0x10(%ebp),%eax
c01071e2:	7c 02                	jl     c01071e6 <strtol+0x124>
            break;
c01071e4:	eb 1a                	jmp    c0107200 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c01071e6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01071ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01071ed:	0f af 45 10          	imul   0x10(%ebp),%eax
c01071f1:	89 c2                	mov    %eax,%edx
c01071f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071f6:	01 d0                	add    %edx,%eax
c01071f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01071fb:	e9 6f ff ff ff       	jmp    c010716f <strtol+0xad>

    if (endptr) {
c0107200:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107204:	74 08                	je     c010720e <strtol+0x14c>
        *endptr = (char *) s;
c0107206:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107209:	8b 55 08             	mov    0x8(%ebp),%edx
c010720c:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010720e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107212:	74 07                	je     c010721b <strtol+0x159>
c0107214:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107217:	f7 d8                	neg    %eax
c0107219:	eb 03                	jmp    c010721e <strtol+0x15c>
c010721b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010721e:	c9                   	leave  
c010721f:	c3                   	ret    

c0107220 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0107220:	55                   	push   %ebp
c0107221:	89 e5                	mov    %esp,%ebp
c0107223:	57                   	push   %edi
c0107224:	83 ec 24             	sub    $0x24,%esp
c0107227:	8b 45 0c             	mov    0xc(%ebp),%eax
c010722a:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010722d:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0107231:	8b 55 08             	mov    0x8(%ebp),%edx
c0107234:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0107237:	88 45 f7             	mov    %al,-0x9(%ebp)
c010723a:	8b 45 10             	mov    0x10(%ebp),%eax
c010723d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0107240:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107243:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0107247:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010724a:	89 d7                	mov    %edx,%edi
c010724c:	f3 aa                	rep stos %al,%es:(%edi)
c010724e:	89 fa                	mov    %edi,%edx
c0107250:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0107253:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0107256:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0107259:	83 c4 24             	add    $0x24,%esp
c010725c:	5f                   	pop    %edi
c010725d:	5d                   	pop    %ebp
c010725e:	c3                   	ret    

c010725f <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010725f:	55                   	push   %ebp
c0107260:	89 e5                	mov    %esp,%ebp
c0107262:	57                   	push   %edi
c0107263:	56                   	push   %esi
c0107264:	53                   	push   %ebx
c0107265:	83 ec 30             	sub    $0x30,%esp
c0107268:	8b 45 08             	mov    0x8(%ebp),%eax
c010726b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010726e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107271:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107274:	8b 45 10             	mov    0x10(%ebp),%eax
c0107277:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010727a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010727d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107280:	73 42                	jae    c01072c4 <memmove+0x65>
c0107282:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107285:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107288:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010728b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010728e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107291:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0107294:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107297:	c1 e8 02             	shr    $0x2,%eax
c010729a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010729c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010729f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01072a2:	89 d7                	mov    %edx,%edi
c01072a4:	89 c6                	mov    %eax,%esi
c01072a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01072a8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01072ab:	83 e1 03             	and    $0x3,%ecx
c01072ae:	74 02                	je     c01072b2 <memmove+0x53>
c01072b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01072b2:	89 f0                	mov    %esi,%eax
c01072b4:	89 fa                	mov    %edi,%edx
c01072b6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01072b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01072bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01072bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072c2:	eb 36                	jmp    c01072fa <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01072c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072c7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01072ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072cd:	01 c2                	add    %eax,%edx
c01072cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072d2:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01072d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072d8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01072db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072de:	89 c1                	mov    %eax,%ecx
c01072e0:	89 d8                	mov    %ebx,%eax
c01072e2:	89 d6                	mov    %edx,%esi
c01072e4:	89 c7                	mov    %eax,%edi
c01072e6:	fd                   	std    
c01072e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01072e9:	fc                   	cld    
c01072ea:	89 f8                	mov    %edi,%eax
c01072ec:	89 f2                	mov    %esi,%edx
c01072ee:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01072f1:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01072f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01072f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01072fa:	83 c4 30             	add    $0x30,%esp
c01072fd:	5b                   	pop    %ebx
c01072fe:	5e                   	pop    %esi
c01072ff:	5f                   	pop    %edi
c0107300:	5d                   	pop    %ebp
c0107301:	c3                   	ret    

c0107302 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0107302:	55                   	push   %ebp
c0107303:	89 e5                	mov    %esp,%ebp
c0107305:	57                   	push   %edi
c0107306:	56                   	push   %esi
c0107307:	83 ec 20             	sub    $0x20,%esp
c010730a:	8b 45 08             	mov    0x8(%ebp),%eax
c010730d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107310:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107313:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107316:	8b 45 10             	mov    0x10(%ebp),%eax
c0107319:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010731c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010731f:	c1 e8 02             	shr    $0x2,%eax
c0107322:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0107324:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107327:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010732a:	89 d7                	mov    %edx,%edi
c010732c:	89 c6                	mov    %eax,%esi
c010732e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0107330:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0107333:	83 e1 03             	and    $0x3,%ecx
c0107336:	74 02                	je     c010733a <memcpy+0x38>
c0107338:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010733a:	89 f0                	mov    %esi,%eax
c010733c:	89 fa                	mov    %edi,%edx
c010733e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0107341:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107344:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0107347:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010734a:	83 c4 20             	add    $0x20,%esp
c010734d:	5e                   	pop    %esi
c010734e:	5f                   	pop    %edi
c010734f:	5d                   	pop    %ebp
c0107350:	c3                   	ret    

c0107351 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0107351:	55                   	push   %ebp
c0107352:	89 e5                	mov    %esp,%ebp
c0107354:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0107357:	8b 45 08             	mov    0x8(%ebp),%eax
c010735a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010735d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107360:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0107363:	eb 30                	jmp    c0107395 <memcmp+0x44>
        if (*s1 != *s2) {
c0107365:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107368:	0f b6 10             	movzbl (%eax),%edx
c010736b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010736e:	0f b6 00             	movzbl (%eax),%eax
c0107371:	38 c2                	cmp    %al,%dl
c0107373:	74 18                	je     c010738d <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0107375:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107378:	0f b6 00             	movzbl (%eax),%eax
c010737b:	0f b6 d0             	movzbl %al,%edx
c010737e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107381:	0f b6 00             	movzbl (%eax),%eax
c0107384:	0f b6 c0             	movzbl %al,%eax
c0107387:	29 c2                	sub    %eax,%edx
c0107389:	89 d0                	mov    %edx,%eax
c010738b:	eb 1a                	jmp    c01073a7 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010738d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0107391:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0107395:	8b 45 10             	mov    0x10(%ebp),%eax
c0107398:	8d 50 ff             	lea    -0x1(%eax),%edx
c010739b:	89 55 10             	mov    %edx,0x10(%ebp)
c010739e:	85 c0                	test   %eax,%eax
c01073a0:	75 c3                	jne    c0107365 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01073a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01073a7:	c9                   	leave  
c01073a8:	c3                   	ret    
