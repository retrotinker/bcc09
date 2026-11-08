; 1 
; 1 # 1 "maltest.c"
; 1 # 6
; 6  
; 7 # 5 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 17
; 17  
; 18 # 32
; 32  
; 33 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 10 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 10 # 14
; 14 typedef unsigned int size_t;	 
;BCC_EOS
; 15 
; 16 typedef int ssize_t;
;BCC_EOS
; 17 typedef int ptrdiff_t;
;BCC_EOS
; 18 
; 19 typedef long off_t;
;BCC_EOS
; 20 typedef long time_t;
;BCC_EOS
; 21 # 5 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 5  
; 6 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 10 # 17 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 17 extern int atoi ();
;BCC_EOS
; 18 extern long atol ();
;BCC_EOS
; 19 extern long strtol ();
;BCC_EOS
; 20 extern unsigned long strtoul ();
;BCC_EOS
; 21 
; 22 extern int abs ();
;BCC_EOS
; 23 extern long labs ();
;BCC_EOS
; 24 
; 25 extern int rand ();
;BCC_EOS
; 26 extern void srand ();
;BCC_EOS
; 27 
; 28 extern void qsort ();
;BCC_EOS
; 29 extern void * bsearch 
; 30 
; 31 # 29
; 29 
; 30 ();
;BCC_EOS
; 31 
; 32 extern void * malloc ();
;BCC_EOS
; 33 extern void * calloc ();
;BCC_EOS
; 34 extern void * realloc ();
;BCC_EOS
; 35 extern void free ();
;BCC_EOS
; 36 
; 37 extern int atexit ();
;BCC_EOS
; 38 extern void exit ();
;BCC_EOS
; 39 extern void _exit ();
;BCC_EOS
; 40 
; 41  
; 42 extern char * itoa ();
;BCC_EOS
; 43 extern char * ltoa ();
;BCC_EOS
; 44 extern char * ultoa ();
;BCC_EOS
; 45 extern char * ltostr ();
;BCC_EOS
; 46 extern char * ultostr ();
;BCC_EOS
; 47 # 5 "../prefix.tmp/lib/bcc09/include/string.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/lib/bcc09/include/string.h"
; 9 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/string.h"
; 10 # 5 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 5  
; 6 # 13 "../prefix.tmp/lib/bcc09/include/string.h"
; 13  
; 14 extern size_t strlen ();
;BCC_EOS
; 15 
; 16 extern char * strcat ();
;BCC_EOS
; 17 extern char * strcpy ();
;BCC_EOS
; 18 extern int strcmp ();
;BCC_EOS
; 19 
; 20 extern char * strncat ();
;BCC_EOS
; 21 extern char * strncpy ();
;BCC_EOS
; 22 extern int strncmp ();
;BCC_EOS
; 23 
; 24 extern char * strchr ();
;BCC_EOS
; 25 extern char * strrchr ();
;BCC_EOS
; 26 extern char * strdup ();
;BCC_EOS
; 27 
; 28  
; 29 extern void * memcpy ();
;BCC_EOS
; 30 extern void * memccpy ();
;BCC_EOS
; 31 extern void * memchr ();
;BCC_EOS
; 32 extern void * memset ();
;BCC_EOS
; 33 extern int memcmp ();
;BCC_EOS
; 34 
; 35 extern void * memmove ();
;BCC_EOS
; 36 
; 37  
; 38 
; 39 
; 40  
; 41 
; 42 
; 43 
; 44  
; 45 extern char * strpbrk ();
;BCC_EOS
; 46 extern char * strsep ();
;BCC_EOS
; 47 extern char * strstr ();
;BCC_EOS
; 48 extern char * strtok ();
;BCC_EOS
; 49 extern size_t strcspn ();
;BCC_EOS
; 50 extern size_t strspn ()
; 50 ;
;BCC_EOS
; 51 # 6 "../prefix.tmp/lib/bcc09/include/errno.h"
; 6  
; 7 # 11
; 11 extern int errno;
;BCC_EOS
; 12 # 5 "../prefix.tmp/lib/bcc09/include/unistd.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/lib/bcc09/include/unistd.h"
; 9 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/unistd.h"
; 10 # 16
; 16  
; 17 extern ssize_t read ();
;BCC_EOS
; 18 extern ssize_t write ();
;BCC_EOS
; 19 
; 20 
; 21  
; 22 extern int brk ();
;BCC_EOS
; 23 extern void * sbrk ();
;BCC_EOS
; 24 extern unsigned int __heap_margin;
;BCC_EOS
; 25 # 15 "maltest.c"
; 15 extern int putchar();
;BCC_EOS
; 16 extern void putnum();
;BCC_EOS
; 17 
; 18 int checks, failures;
;BCC_EOS
; 19 
; 20 void say(s)
; 21 char *s;
EXPORT	_say
_say:
;BCC_EOS
; 22 {
; 23 	while (*s)
PSHS	X
; 24 		putchar(*s++);
BRA	.2
.3:
; Debug: postinc * char s = [S+2-2] (used reg = )
LDX	0,S
LEAU	1,X
STU	0,S
; Debug: rootlist char = [X+0] (used reg = )
LDB	0,X
CLRA
TFR	D,X
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 25 }
.2:
LDB	[0,S]
BNE	.3
.4:
.1:
PULS	Y,PC
; 26 
; 27  
; 28 void ok(n,cond)
; 29 int n, cond;
EXPORT	_ok
_ok:
;BCC_EOS
; 30 {
; 31 	++checks;
PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
LDD	>_checks
ADDD	#1
STD	>_checks
;BCC_EOS
; 32 	if (!cond) {
LDD	4,S
BNE	.5
.6:
; 33 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
LDD	>_failures
ADDD	#1
STD	>_failures
;BCC_EOS
; 34 		say("FAIL ");
LOC	1
.7:
FCC	"FAIL "
FCB	0
LOC	0
; Debug: rootlist * char = .7+0 (used reg = )
LDX	#.7
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 35 		putnum(n);
; Debug: rootlist int n = [S+2-2] (used reg = )
LDX	0,S
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 36 	}
; 37 }
.5:
PULS	Y,PC
; 38 
; 39  
; 40 
; 41 
; 42 void fill(p,slot,size)
; 43 char *p;
EXPORT	_fill
_fill:
;BCC_EOS
; 44 int slot, size;
;BCC_EOS
; 45 {
; 46 	int i;
;BCC_EOS
; 47 
; 48 	for (i = 0; i < size; i++)
PSHS	D,X
; Debug: eq int = const 0 to int i = [S+4-4] (used reg = )
LDD	#0
STD	0,S
;BCC_EOS
;BCC_EOS
; 49 		p[i] = ((char)((slot)* 7 + (size)+ (i))) ;
BRA	.A
.B:
; Debug: mul int = const 7 to int slot = [S+4+2] (used reg = )
LDD	6,S
PSHS	D
LSLB
ROLA
LSLB
ROLA
LSLB
ROLA
SUBD	,S++
; Debug: add int size = [S+4+4] to int = D+0 (used reg = )
ADDD	8,S
; Debug: add int i = [S+4-4] to int = D+0 (used reg = )
ADDD	0,S
; Debug: cast char = const 0 to int = D+0 (used reg = )
PSHS	B
; Debug: ptradd int i = [S+5-4] to * char p = [S+5-2] (used reg = )
LDD	1,S
ADDD	3,S
TFR	D,X
; Debug: eq char (temp) = [S+5-5] to char = [X+0] (used reg = )
LDB	,S+
STB	0,X
;BCC_EOS
; 50 }
.9:
; Debug: postinc int i = [S+4-4] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
.A:
; Debug: lt int size = [S+4+4] to int i = [S+4-4] (used reg = )
LDD	0,S
SUBD	8,S
BLT	.B
.C:
.8:
PULS	U,Y,PC
; 51 
; 52  
; 53 int intact(p,slot,size,n)
; 54 char *p;
EXPORT	_intact
_intact:
;BCC_EOS
; 55 int slot, size, n;
;BCC_EOS
; 56 {
; 57 	int i;
;BCC_EOS
; 58 
; 59 	for (i = 0; i < n; i++)
PSHS	D,X
; Debug: eq int = const 0 to int i = [S+4-4] (used reg = )
LDD	#0
STD	0,S
;BCC_EOS
;BCC_EOS
; 60 		if (p[i] != ((char)((slot)* 7 + (size)+ (i))))
BRA	.F
.10:
; Debug: mul int = const 7 to int slot = [S+4+2] (used reg = )
LDD	6,S
PSHS	D
LSLB
ROLA
LSLB
ROLA
LSLB
ROLA
SUBD	,S++
; Debug: add int size = [S+4+4] to int = D+0 (used reg = )
ADDD	8,S
; Debug: add int i = [S+4-4] to int = D+0 (used reg = )
ADDD	0,S
; Debug: cast char = const 0 to int = D+0 (used reg = )
PSHS	B
; Debug: ptradd int i = [S+5-4] to * char p = [S+5-2] (used reg = )
LDD	1,S
ADDD	3,S
TFR	D,X
; Debug: ne char (temp) = [S+5-5] to char = [X+0] (used reg = )
LDB	0,X
SUBB	,S+
BEQ	.11
.12:
; 61 			return 0;
LDX	#0
PULS	U,Y,PC
;BCC_EOS
; 62 	return 1;
.11:
.E:
; Debug: postinc int i = [S+4-4] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
.F:
; Debug: lt int n = [S+4+6] to int i = [S+4-4] (used reg = )
LDD	0,S
SUBD	$A,S
BLT	.10
.13:
.D:
LDX	#1
PULS	U,Y,PC
;BCC_EOS
; 63 }
; 64 
; 65 void basics()
; 66 {
EXPORT	_basics
_basics:
; 67 	char *p, *q;
;BCC_EOS
; 68 	int i, zero;
;BCC_EOS
; 69 
; 70 	p = malloc(10);
LEAS	-8,S
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+8-2] (used reg = )
STX	6,S
;BCC_EOS
; 71 	ok(1,p != 0);
; Debug: ne int = const 0 to * char p = [S+8-2] (used reg = )
LDD	6,S
BEQ	.14
LDB	#1
BRA	.15
.14:
CLRB
.15:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 72 	fill(p,1,10);
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist * char p = [S+$C-2] (used reg = )
LDX	$A,S
; Debug: func () void = fill+0 (used reg = )
JSR	>_fill
LEAS	4,S
;BCC_EOS
; 73 	q = malloc(20);
; Debug: rootlist int = const $14 (used reg = )
LDX	#$14
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char q = [S+8-4] (used reg = )
STX	4,S
;BCC_EOS
; 74 	ok(2,q != 0 && (q >= p + 10 || q + 20 <= p));	 
; Debug: ne int = const 0 to * char q = [S+8-4] (used reg = )
LDD	4,S
BEQ	.16
.18:
; Debug: ptradd int = const $A to * char p = [S+8-2] (used reg = )
LDX	6,S
; Debug: ge * char = X+$A to * char q = [S+8-4] (used reg = )
LEAX	$A,X
CMPX	4,S
BLS	.17
.19:
; Debug: ptradd int = const $14 to * char q = [S+8-4] (used reg = )
LDX	4,S
; Debug: le * char p = [S+8-2] to * char = X+$14 (used reg = )
LEAX	$14,X
CMPX	6,S
BHI	.16
.17:
LDB	#1
BRA	.1A
.16:
CLRB
.1A:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 75 	fill(q,2,20);
; Debug: list int = const $14 (used reg = )
LDD	#$14
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: rootlist * char q = [S+$C-4] (used reg = )
LDX	8,S
; Debug: func () void = fill+0 (used reg = )
JSR	>_fill
LEAS	4,S
;BCC_EOS
; 76 	ok(3,intact(p,1,10,10)&& intact(q,2,20,20));
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist * char p = [S+$E-2] (used reg = )
LDX	$C,S
; Debug: func () int = intact+0 (used reg = )
JSR	>_intact
LEAS	6,S
LEAX	0,X
BEQ	.1B
.1D:
; Debug: list int = const $14 (used reg = )
LDD	#$14
PSHS	D
; Debug: list int = const $14 (used reg = )
LDD	#$14
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: rootlist * char q = [S+$E-4] (used reg = )
LDX	$A,S
; Debug: func () int = intact+0 (used reg = )
JSR	>_intact
LEAS	6,S
LEAX	0,X
BEQ	.1B
.1C:
LDB	#1
BRA	.1E
.1B:
CLRB
.1E:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 77 	free(p);
; Debug: rootlist * char p = [S+8-2] (used reg = )
LDX	6,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 78 	free(q);
; Debug: rootlist * char q = [S+8-4] (used reg = )
LDX	4,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 79 	free((char *)0);			 
; Debug: rootlist * char = const 0 (used reg = )
LDX	#0
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 80 
; 81 	p = calloc(20,3);
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: rootlist int = const $14 (used reg = )
LDX	#$14
; Debug: func () * void = calloc+0 (used reg = )
JSR	>_calloc
LEAS	2,S
; Debug: eq * void = X+0 to * char p = [S+8-2] (used reg = )
STX	6,S
;BCC_EOS
; 82 	zero = p != 0;
; Debug: ne int = const 0 to * char p = [S+8-2] (used reg = )
LDD	6,S
BEQ	.1F
LDB	#1
BRA	.20
.1F:
CLRB
.20:
; Debug: eq char = B+0 to int zero = [S+8-8] (used reg = )
CLRA
STD	0,S
;BCC_EOS
; 83 	for (i = 0; zero && i < 60; i++)
; Debug: eq int = const 0 to int i = [S+8-6] (used reg = )
LDD	#0
STD	2,S
;BCC_EOS
;BCC_EOS
; 84 		if (p[i] != 0)
BRA	.23
.24:
; Debug: ptradd int i = [S+8-6] to * char p = [S+8-2] (used reg = )
LDD	2,S
ADDD	6,S
TFR	D,X
; Debug: ne int = const 0 to char = [X+0] (used reg = )
LDB	0,X
BEQ	.25
.26:
; 85 			zero = 0;
; Debug: eq int = const 0 to int zero = [S+8-8] (used reg = )
LDD	#0
STD	0,S
;BCC_EOS
; 86 	ok(4,zero);
.25:
.22:
; Debug: postinc int i = [S+8-6] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.23:
LDD	0,S
BEQ	.27
.28:
; Debug: lt int = const $3C to int i = [S+8-6] (used reg = )
LDD	2,S
SUBD	#$3C
BLT	.24
.27:
.21:
; Debug: list int zero = [S+8-8] (used reg = )
LDD	0,S
PSHS	D
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 87 	free(p);
; Debug: rootlist * char p = [S+8-2] (used reg = )
LDX	6,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 88 
; 89 	 
; 90 	p = realloc((char *)0,16);		 
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: rootlist * char = const 0 (used reg = )
LDX	#0
; Debug: func () * void = realloc+0 (used reg = )
JSR	>_realloc
LEAS	2,S
; Debug: eq * void = X+0 to * char p = [S+8-2] (used reg = )
STX	6,S
;BCC_EOS
; 91 	ok(5,p != 0);
; Debug: ne int = const 0 to * char p = [S+8-2] (used reg = )
LDD	6,S
BEQ	.29
LDB	#1
BRA	.2A
.29:
CLRB
.2A:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 5 (used reg = )
LDX	#5
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 92 	fill(p,3,16);
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: rootlist * char p = [S+$C-2] (used reg = )
LDX	$A,S
; Debug: func () void = fill+0 (used reg = )
JSR	>_fill
LEAS	4,S
;BCC_EOS
; 93 	p = realloc(p,200);
; Debug: list int = const $C8 (used reg = )
LDD	#$C8
PSHS	D
; Debug: rootlist * char p = [S+$A-2] (used reg = )
LDX	8,S
; Debug: func () * void = realloc+0 (used reg = )
JSR	>_realloc
LEAS	2,S
; Debug: eq * void = X+0 to * char p = [S+8-2] (used reg = )
STX	6,S
;BCC_EOS
; 94 	ok(6,p != 0 && intact(p,3,16,16));
; Debug: ne int = const 0 to * char p = [S+8-2] (used reg = )
LDD	6,S
BEQ	.2B
.2D:
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: rootlist * char p = [S+$E-2] (used reg = )
LDX	$C,S
; Debug: func () int = intact+0 (used reg = )
JSR	>_intact
LEAS	6,S
LEAX	0,X
BEQ	.2B
.2C:
LDB	#1
BRA	.2E
.2B:
CLRB
.2E:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 6 (used reg = )
LDX	#6
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 95 	q = malloc(5);				 
; Debug: rootlist int = const 5 (used reg = )
LDX	#5
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char q = [S+8-4] (used reg = )
STX	4,S
;BCC_EOS
; 96 	p = realloc(p,1000);
; Debug: list int = const $3E8 (used reg = )
LDD	#$3E8
PSHS	D
; Debug: rootlist * char p = [S+$A-2] (used reg = )
LDX	8,S
; Debug: func () * void = realloc+0 (used reg = )
JSR	>_realloc
LEAS	2,S
; Debug: eq * void = X+0 to * char p = [S+8-2] (used reg = )
STX	6,S
;BCC_EOS
; 97 	ok(7,p != 0 && intact(p,3,16,16));
; Debug: ne int = const 0 to * char p = [S+8-2] (used reg = )
LDD	6,S
BEQ	.2F
.31:
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: rootlist * char p = [S+$E-2] (used reg = )
LDX	$C,S
; Debug: func () int = intact+0 (used reg = )
JSR	>_intact
LEAS	6,S
LEAX	0,X
BEQ	.2F
.30:
LDB	#1
BRA	.32
.2F:
CLRB
.32:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 7 (used reg = )
LDX	#7
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 98 	p = realloc(p,8);
; Debug: list int = const 8 (used reg = )
LDD	#8
PSHS	D
; Debug: rootlist * char p = [S+$A-2] (used reg = )
LDX	8,S
; Debug: func () * void = realloc+0 (used reg = )
JSR	>_realloc
LEAS	2,S
; Debug: eq * void = X+0 to * char p = [S+8-2] (used reg = )
STX	6,S
;BCC_EOS
; 99 	ok(8,p != 0 && intact(p,3,16,8));
; Debug: ne int = const 0 to * char p = [S+8-2] (used reg = )
LDD	6,S
BEQ	.33
.35:
; Debug: list int = const 8 (used reg = )
LDD	#8
PSHS	D
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: rootlist * char p = [S+$E-2] (used reg = )
LDX	$C,S
; Debug: func () int = intact+0 (used reg = )
JSR	>_intact
LEAS	6,S
LEAX	0,X
BEQ	.33
.34:
LDB	#1
BRA	.36
.33:
CLRB
.36:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 8 (used reg = )
LDX	#8
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 100 	free(p);
; Debug: rootlist * char p = [S+8-2] (used reg = )
LDX	6,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 101 	free(q);
; Debug: rootlist * char q = [S+8-4] (used reg = )
LDX	4,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 102 
; 103 	p = strdup("hello, world");
LOC	1
.37:
FCC	"hello, world"
FCB	0
LOC	0
; Debug: rootlist * char = .37+0 (used reg = )
LDX	#.37
; Debug: func () * char = strdup+0 (used reg = )
JSR	>_strdup
; Debug: eq * char = X+0 to * char p = [S+8-2] (used reg = )
STX	6,S
;BCC_EOS
; 104 	ok(9,p != 0 && strcmp(p,"hello, world")== 0);
LOC	1
.38:
FCC	"hello, world"
FCB	0
LOC	0
; Debug: ne int = const 0 to * char p = [S+8-2] (used reg = )
LDD	6,S
BEQ	.39
.3B:
; Debug: list * char = .38+0 (used reg = )
LDX	#.38
PSHS	X
; Debug: rootlist * char p = [S+$A-2] (used reg = )
LDX	8,S
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.39
.3A:
LDB	#1
BRA	.3C
.39:
CLRB
.3C:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 9 (used reg = )
LDX	#9
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 105 	q = strdup("");
LOC	1
.3D:
FCB	0
LOC	0
; Debug: rootlist * char = .3D+0 (used reg = )
LDX	#.3D
; Debug: func () * char = strdup+0 (used reg = )
JSR	>_strdup
; Debug: eq * char = X+0 to * char q = [S+8-4] (used reg = )
STX	4,S
;BCC_EOS
; 106 	ok(10,q != 0 && q[0] == 0 && q != p);
; Debug: ne int = const 0 to * char q = [S+8-4] (used reg = )
LDD	4,S
BEQ	.3E
.41:
; Debug: ptradd int = const 0 to * char q = [S+8-4] (used reg = )
; Debug: logeq int = const 0 to char q = [[S+8-4]] (used reg = )
LDB	[4,S]
BNE	.3E
.40:
; Debug: ne * char p = [S+8-2] to * char q = [S+8-4] (used reg = )
LDX	4,S
CMPX	6,S
BEQ	.3E
.3F:
LDB	#1
BRA	.42
.3E:
CLRB
.42:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 107 	free(p);
; Debug: rootlist * char p = [S+8-2] (used reg = )
LDX	6,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 108 	free(q);
; Debug: rootlist * char q = [S+8-4] (used reg = )
LDX	4,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 109 }
LEAS	8,S
RTS
; 110 
; 111 
; 112 
; 113  
; 114 
; 115 
; 116 char *slot[40 ];
;BCC_EOS
; 117 int size[40 ];
;BCC_EOS
; 118 unsigned long seed = 12345;
LOC	3
EXPORT	_seed
_seed:
FDB	0
FDB	$3039
;BCC_EOS
; 119 
; 120 int rnd(n)
; 121 int n;
LOC	0
EXPORT	_rnd
_rnd:
;BCC_EOS
; 122 {
; 123 	seed = seed * 1103515245L + 12345;
PSHS	X
; Debug: mul long = const $41C64E6D to unsigned long = [seed+0] (used reg = )
; Debug: expression subtree swapping
LDD	#$41C6
LDX	#$4E6D
LDY	#_seed
JSR	>lmulu_b
; Debug: add unsigned long = const $3039 to unsigned long = X+0 (used reg = )
PSHS	D,X
LDD	#0
LDX	#$3039
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>laddu_b
LEAS	8,S
; Debug: eq unsigned long = X+0 to unsigned long = [seed+0] (used reg = )
STD	>_seed
STX	>_seed+2
;BCC_EOS
; 124 	return (int) ((seed >> 16)& 0x7fff) % n;
; Debug: sr int = const $10 to unsigned long = [seed+0] (used reg = )
LDD	>_seed
LDX	>_seed+2
EXG	D,X
LDD	#0
; Debug: and unsigned long = const $7FFF to unsigned long = X+0 (used reg = )
PSHS	D,X
LDD	#0
LDX	#$7FFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>landu_b
LEAS	8,S
; Debug: cast int = const 0 to unsigned long = X+0 (used reg = )
TFR	X,D
; Debug: mod int n = [S+2-2] to int = D+0 (used reg = )
LDX	0,S
JSR	>imod
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 125 }
; 126 
; 127 int overlaps()
; 128 {
EXPORT	_overlaps
_overlaps:
; 129 	int i, j;
;BCC_EOS
; 130 
; 131 	for (i = 0; i < 40 ; i++
LEAS	-4,S
; Debug: eq int = const 0 to int i = [S+4-2] (used reg = )
LDD	#0
STD	2,S
;BCC_EOS
;BCC_EOS
; 131 )
; 132 		for (j = i + 1; j < 40 ; j++)
JMP	.45
.46:
; Debug: add int = const 1 to int i = [S+4-2] (used reg = )
LDD	2,S
; Debug: eq int = D+1 to int j = [S+4-4] (used reg = )
ADDD	#1
STD	0,S
;BCC_EOS
;BCC_EOS
; 133 			if (slot[i] && slot[j]
JMP	.49
.4A:
; 134 			    && slot[i] < slot[j] + size[j]
; 135 			    && slot[j] < slot[i] + size[i])
; Debug: ptradd int i = [S+4-2] to [$28] * char = slot+0 (used reg = )
LDD	2,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
LDD	0,X
BEQ	.4B
.4F:
; Debug: ptradd int j = [S+4-4] to [$28] * char = slot+0 (used reg = )
LDD	0,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
LDD	0,X
BEQ	.4B
.4E:
; Debug: ptradd int j = [S+4-4] to [$28] int = size+0 (used reg = )
LDD	0,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: ptradd int j = [S+4-4] to [$28] * char = slot+0 (used reg = X)
LDD	0,S
LSLB
ROLA
LDU	#_slot
LEAU	D,U
; Debug: ptradd int = [X+0] to * char = [U+0] (used reg = )
LDD	0,X
ADDD	0,U
PSHS	D
; Debug: ptradd int i = [S+6-2] to [$28] * char = slot+0 (used reg = )
LDD	4,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: lt * char (temp) = [S+6-6] to * char = [X+0] (used reg = )
LDX	0,X
CMPX	,S++
BHS	.4B
.4D:
; Debug: ptradd int i = [S+4-2] to [$28] int = size+0 (used reg = )
LDD	2,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: ptradd int i = [S+4-2] to [$28] * char = slot+0 (used reg = X)
LDD	2,S
LSLB
ROLA
LDU	#_slot
LEAU	D,U
; Debug: ptradd int = [X+0] to * char = [U+0] (used reg = )
LDD	0,X
ADDD	0,U
PSHS	D
; Debug: ptradd int j = [S+6-4] to [$28] * char = slot+0 (used reg = )
LDD	2,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: lt * char (temp) = [S+6-6] to * char = [X+0] (used reg = )
LDX	0,X
CMPX	,S++
BHS	.4B
.4C:
; 136 				return 1;
LDX	#1
PULS	U,Y,PC
;BCC_EOS
; 137 	return 0;
.4B:
.48:
; Debug: postinc int j = [S+4-4] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
.49:
; Debug: lt int = const $28 to int j = [S+4-4] (used reg = )
LDD	0,S
SUBD	#$28
BLT	.4A
.50:
.47:
.44:
; Debug: postinc int i = [S+4-2] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.45:
; Debug: lt int = const $28 to int i = [S+4-2] (used reg = )
LDD	2,S
SUBD	#$28
LBLT	.46
.51:
.43:
LDX	#0
PULS	U,Y,PC
;BCC_EOS
; 138 }
; 139 
; 140 void stress()
; 141 {
EXPORT	_stress
_stress:
; 142 	int n, s, good, nomem, sz;
;BCC_EOS
; 143 	char *p;
;BCC_EOS
; 144 
; 145 	good = 1;
LEAS	-$C,S
; Debug: eq int = const 1 to int good = [S+$C-6] (used reg = )
LDD	#1
STD	6,S
;BCC_EOS
; 146 	nomem = 0;
; Debug: eq int = const 0 to int nomem = [S+$C-8] (used reg = )
LDD	#0
STD	4,S
;BCC_EOS
; 147 	for (n = 0; n < 3000; n++) {
; Debug: eq int = const 0 to int n = [S+$C-2] (used reg = )
LDD	#0
STD	$A,S
;BCC_EOS
;BCC_EOS
JMP	.54
.55:
; 148 		s = rnd(40 );
; Debug: rootlist int = const $28 (used reg = )
LDX	#$28
; Debug: func () int = rnd+0 (used reg = )
JSR	>_rnd
; Debug: eq int = X+0 to int s = [S+$C-4] (used reg = )
STX	8,S
;BCC_EOS
; 149 		if (slot[s]) {
; Debug: ptradd int s = [S+$C-4] to [$28] * char = slot+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
LDD	0,X
LBEQ	.56
.57:
; 150 			if (!intact(slot[s],s,size[s],size[s]))
; Debug: ptradd int s = [S+$C-4] to [$28] int = size+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: list int = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: ptradd int s = [S+$E-4] to [$28] int = size+0 (used reg = )
LDD	$A,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: list int = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: list int s = [S+$10-4] (used reg = )
LDD	$C,S
PSHS	D
; Debug: ptradd int s = [S+$12-4] to [$28] * char = slot+0 (used reg = )
LDD	$E,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: rootlist * char = [X+0] (used reg = )
LDX	0,X
; Debug: func () int = intact+0 (used reg = )
JSR	>_intact
LEAS	6,S
LEAX	0,X
BNE	.58
.59:
; 151 				good = 0;
; Debug: eq int = const 0 to int good = [S+$C-6] (used reg = )
LDD	#0
STD	6,S
;BCC_EOS
; 152 			if (rnd(4)== 0) {	 
.58:
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () int = rnd+0 (used reg = )
JSR	>_rnd
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
LBNE	.5A
.5B:
; 153 				sz = 1 + rnd(300);
; Debug: rootlist int = const $12C (used reg = )
LDX	#$12C
; Debug: func () int = rnd+0 (used reg = )
JSR	>_rnd
; Debug: add int = X+0 to int = const 1 (used reg = )
; Debug: expression subtree swapping
; Debug: eq int = X+1 to int sz = [S+$C-$A] (used reg = )
LEAX	1,X
STX	2,S
;BCC_EOS
; 154 				p = realloc(slot[s],sz);
; Debug: list int sz = [S+$C-$A] (used reg = )
LDD	2,S
PSHS	D
; Debug: ptradd int s = [S+$E-4] to [$28] * char = slot+0 (used reg = )
LDD	$A,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: rootlist * char = [X+0] (used reg = )
LDX	0,X
; Debug: func () * void = realloc+0 (used reg = )
JSR	>_realloc
LEAS	2,S
; Debug: eq * void = X+0 to * char p = [S+$C-$C] (used reg = )
STX	0,S
;BCC_EOS
; 155 				if (p == 0) {
; Debug: logeq int = const 0 to * char p = [S+$C-$C] (used reg = )
LDD	0,S
BNE	.5C
.5D:
; 156 					nomem++;
; Debug: postinc int nomem = [S+$C-8] (used reg = )
LDD	4,S
ADDD	#1
STD	4,S
;BCC_EOS
; 157 					continue;
JMP	.53
;BCC_EOS
; 158 				}
; 159 				if (!intact(p,s,size[s],
.5C:
; 160 sz < size[s] ? sz : size[s]))
; Debug: ptradd int s = [S+$C-4] to [$28] int = size+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: lt int = [X+0] to int sz = [S+$C-$A] (used reg = )
LDD	2,S
SUBD	0,X
BGE	.60
.61:
LDD	2,S
BRA	.62
.60:
; Debug: ptradd int s = [S+$C-4] to [$28] int = size+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
LDD	0,X
.62:
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: ptradd int s = [S+$E-4] to [$28] int = size+0 (used reg = )
LDD	$A,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: list int = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: list int s = [S+$10-4] (used reg = )
LDD	$C,S
PSHS	D
; Debug: rootlist * char p = [S+$12-$C] (used reg = )
LDX	6,S
; Debug: func () int = intact+0 (used reg = )
JSR	>_intact
LEAS	6,S
LEAX	0,X
BNE	.5E
.5F:
; 161 					good = 0;
; Debug: eq int = const 0 to int good = [S+$C-6] (used reg = )
LDD	#0
STD	6,S
;BCC_EOS
; 162 				slot[s] = p;
.5E:
; Debug: ptradd int s = [S+$C-4] to [$28] * char = slot+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: eq * char p = [S+$C-$C] to * char = [X+0] (used reg = )
LDU	0,S
STU	0,X
;BCC_EOS
; 163 				size[s] = sz;
; Debug: ptradd int s = [S+$C-4] to [$28] int = size+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: eq int sz = [S+$C-$A] to int = [X+0] (used reg = )
LDD	2,S
STD	0,X
;BCC_EOS
; 164 				fill(p,s,sz);
; Debug: list int sz = [S+$C-$A] (used reg = )
LDD	2,S
PSHS	D
; Debug: list int s = [S+$E-4] (used reg = )
LDD	$A,S
PSHS	D
; Debug: rootlist * char p = [S+$10-$C] (used reg = )
LDX	4,S
; Debug: func () void = fill+0 (used reg = )
JSR	>_fill
LEAS	4,S
;BCC_EOS
; 165 			} else {
BRA	.63
.5A:
; 166 				free(slot[s]);
; Debug: ptradd int s = [S+$C-4] to [$28] * char = slot+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: rootlist * char = [X+0] (used reg = )
LDX	0,X
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 167 				slot[s] = 0;
; Debug: ptradd int s = [S+$C-4] to [$28] * char = slot+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: eq int = const 0 to * char = [X+0] (used reg = )
LDD	#0
STD	0,X
;BCC_EOS
; 168 			}
; 169 		} else {
.63:
BRA	.64
.56:
; 170 			sz = 1 + rnd(300);
; Debug: rootlist int = const $12C (used reg = )
LDX	#$12C
; Debug: func () int = rnd+0 (used reg = )
JSR	>_rnd
; Debug: add int = X+0 to int = const 1 (used reg = )
; Debug: expression subtree swapping
; Debug: eq int = X+1 to int sz = [S+$C-$A] (used reg = )
LEAX	1,X
STX	2,S
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+$C-$C] (used reg = )
STX	0,S
;BCC_EOS
; 172 			if (p == 0) {
; Debug: logeq int = const 0 to * char p = [S+$C-$C] (used reg = )
LDD	0,S
BNE	.65
.66:
; 173 				nomem++;
; Debug: postinc int nomem = [S+$C-8] (used reg = )
LDD	4,S
ADDD	#1
STD	4,S
;BCC_EOS
; 174 				continue;
BRA	.53
;BCC_EOS
; 175 			}
; 176 			slot[s] = p;
.65:
; Debug: ptradd int s = [S+$C-4] to [$28] * char = slot+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: eq * char p = [S+$C-$C] to * char = [X+0] (used reg = )
LDU	0,S
STU	0,X
;BCC_EOS
; 177 			size[s] = sz;
; Debug: ptradd int s = [S+$C-4] to [$28] int = size+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: eq int sz = [S+$C-$A] to int = [X+0] (used reg = )
LDD	2,S
STD	0,X
;BCC_EOS
; 178 			fill(p,s,sz);
; Debug: list int sz = [S+$C-$A] (used reg = )
LDD	2,S
PSHS	D
; Debug: list int s = [S+$E-4] (used reg = )
LDD	$A,S
PSHS	D
; Debug: rootlist * char p = [S+$10-$C] (used reg = )
LDX	4,S
; Debug: func () void = fill+0 (used reg = )
JSR	>_fill
LEAS	4,S
;BCC_EOS
; 179 		}
; 180 		if (n % 100 == 0 && overlaps())
.64:
; Debug: mod int = const $64 to int n = [S+$C-2] (used reg = )
LDD	$A,S
LDX	#$64
JSR	>imod
; Debug: logeq int = const 0 to int = D+0 (used reg = )
SUBD	#0
BNE	.67
.69:
; Debug: func () int = overlaps+0 (used reg = )
JSR	>_overlaps
LEAX	0,X
BEQ	.67
.68:
; 181 			good = 0;
; Debug: eq int = const 0 to int good = [S+$C-6] (used reg = )
LDD	#0
STD	6,S
;BCC_EOS
; 182 	}
.67:
; 183 	ok(20,good);
.53:
; Debug: postinc int n = [S+$C-2] (used reg = )
LDD	$A,S
ADDD	#1
STD	$A,S
.54:
; Debug: lt int = const $BB8 to int n = [S+$C-2] (used reg = )
LDD	$A,S
SUBD	#$BB8
LBLT	.55
.6A:
.52:
; Debug: list int good = [S+$C-6] (used reg = )
LDD	6,S
PSHS	D
; Debug: rootlist int = const $14 (used reg = )
LDX	#$14
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 184 	ok(21,!overlaps());
; Debug: func () int = overlaps+0 (used reg = )
JSR	>_overlaps
LEAX	0,X
BNE	.6B
.6C:
LDB	#1
BRA	.6D
.6B:
CLRB
.6D:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $15 (used reg = )
LDX	#$15
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 185 	ok(22,nomem == 0);
; Debug: logeq int = const 0 to int nomem = [S+$C-8] (used reg = )
LDD	4,S
BNE	.6E
LDB	#1
BRA	.6F
.6E:
CLRB
.6F:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $16 (used reg = )
LDX	#$16
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 186 	for (s = 0; s < 40 ; s++)
; Debug: eq int = const 0 to int s = [S+$C-4] (used reg = )
LDD	#0
STD	8,S
;BCC_EOS
;BCC_EOS
; 187 		if (slot[s]) {
BRA	.72
.73:
; Debug: ptradd int s = [S+$C-4] to [$28] * char = slot+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
LDD	0,X
BEQ	.74
.75:
; 188 			if (!intact(slot[s],s,size[s],size[s]))
; Debug: ptradd int s = [S+$C-4] to [$28] int = size+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: list int = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: ptradd int s = [S+$E-4] to [$28] int = size+0 (used reg = )
LDD	$A,S
LSLB
ROLA
LDX	#_size
LEAX	D,X
; Debug: list int = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: list int s = [S+$10-4] (used reg = )
LDD	$C,S
PSHS	D
; Debug: ptradd int s = [S+$12-4] to [$28] * char = slot+0 (used reg = )
LDD	$E,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: rootlist * char = [X+0] (used reg = )
LDX	0,X
; Debug: func () int = intact+0 (used reg = )
JSR	>_intact
LEAS	6,S
LEAX	0,X
BNE	.76
.77:
; 189 				good = 0;
; Debug: eq int = const 0 to int good = [S+$C-6] (used reg = )
LDD	#0
STD	6,S
;BCC_EOS
; 190 			free(slot[s]);
.76:
; Debug: ptradd int s = [S+$C-4] to [$28] * char = slot+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: rootlist * char = [X+0] (used reg = )
LDX	0,X
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 191 			slot[s] = 0;
; Debug: ptradd int s = [S+$C-4] to [$28] * char = slot+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_slot
LEAX	D,X
; Debug: eq int = const 0 to * char = [X+0] (used reg = )
LDD	#0
STD	0,X
;BCC_EOS
; 192 		}
; 193 	ok(23,good);
.74:
.71:
; Debug: postinc int s = [S+$C-4] (used reg = )
LDD	8,S
ADDD	#1
STD	8,S
.72:
; Debug: lt int = const $28 to int s = [S+$C-4] (used reg = )
LDD	8,S
SUBD	#$28
BLT	.73
.78:
.70:
; Debug: list int good = [S+$C-6] (used reg = )
LDD	6,S
PSHS	D
; Debug: rootlist int = const $17 (used reg = )
LDX	#$17
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 194 }
LEAS	$C,S
RTS
; 195 
; 196 
; 197 extern char _end[];		 
;BCC_EOS
; 198 
; 199 
; 200  
; 201 void exhaust()
; 202 {
EXPORT	_exhaust
_exhaust:
; 203 	char *list = 0, *p, *top;
LEAS	-2,S
; Debug: eq int = const 0 to * char list = [S+2-2] (used reg = )
LDD	#0
STD	0,S
;BCC_EOS
; 204 	char here;
;BCC_EOS
; 205 	unsigned total = 0, blocks = 0;
LEAS	-7,S
; Debug: eq int = const 0 to unsigned int total = [S+9-9] (used reg = )
LDD	#0
STD	0,S
LEAS	-2,S
; Debug: eq int = const 0 to unsigned int blocks = [S+$B-$B] (used reg = )
LDD	#0
STD	0,S
;BCC_EOS
; 206 
; 207 	errno = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 208 	while ((p = malloc(100))!= 0) {
BRA	.7A
.7B:
; 209 		*(char **) p = list;
; Debug: eq * char list = [S+$B-2] to * char p = [[S+$B-4]] (used reg = )
LDX	9,S
STX	[7,S]
;BCC_EOS
; 210 		list = p;
; Debug: eq * char p = [S+$B-4] to * char list = [S+$B-2] (used reg = )
LDX	7,S
STX	9,S
;BCC_EOS
; 211 		total += 100;
; Debug: addab int = const $64 to unsigned int total = [S+$B-9] (used reg = )
LDD	2,S
ADDD	#$64
STD	2,S
;BCC_EOS
; 212 		blocks++;
; Debug: postinc unsigned int blocks = [S+$B-$B] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
;BCC_EOS
; 213 	}
; 214 	ok(30,errno == 12		  );
.7A:
; Debug: rootlist int = const $64 (used reg = )
LDX	#$64
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+$B-4] (used reg = )
STX	7,S
; Debug: ne int = const 0 to * char = X+0 (used reg = )
LEAX	0,X
BNE	.7B
.7C:
.79:
; Debug: logeq int = const $C to int = [errno+0] (used reg = )
LDX	>_errno
LEAX	-$C,X
BNE	.7D
LDB	#1
BRA	.7E
.7D:
CLRB
.7E:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $1E (used reg = )
LDX	#$1E
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 215 	ok(31,total > 10000);		 
; Debug: gt int = const $2710 to unsigned int total = [S+$B-9] (used reg = )
LDD	2,S
SUBD	#$2710
BLS	.7F
LDB	#1
BRA	.80
.7F:
CLRB
.80:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $1F (used reg = )
LDX	#$1F
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 216 	top = sbrk(0);
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: eq * void = X+0 to * char top = [S+$B-6] (used reg = )
STX	5,S
;BCC_EOS
; 217 	ok(32,top <= &here - __heap_margin && top > _end);
; Debug: neg unsigned int = [__heap_margin+0] (used reg = )
LDD	#0
SUBD	>___heap_margin
; Debug: ptradd unsigned int = D+0 to * char here = S+$B-7 (used reg = )
LEAX	D,S
; Debug: le * char = X+4 to * char top = [S+$B-6] (used reg = )
LEAX	4,X
CMPX	5,S
BLO	.81
.83:
; Debug: gt * char = _end+0 to * char top = [S+$B-6] (used reg = )
LDX	#__end
CMPX	5,S
BHS	.81
.82:
LDB	#1
BRA	.84
.81:
CLRB
.84:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $20 (used reg = )
LDX	#$20
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 218 	ok(33,malloc(100)== 0);	 
; Debug: rootlist int = const $64 (used reg = )
LDX	#$64
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
LEAX	0,X
BNE	.85
LDB	#1
BRA	.86
.85:
CLRB
.86:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $21 (used reg = )
LDX	#$21
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 219 	while (list) {
BRA	.88
.89:
; 220 		p = *(char **) list;
; Debug: eq * char list = [[S+$B-2]] to * char p = [S+$B-4] (used reg = )
LDX	[9,S]
STX	7,S
;BCC_EOS
; 221 		free(list);
; Debug: rootlist * char list = [S+$B-2] (used reg = )
LDX	9,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 222 		list = p;
; Debug: eq * char p = [S+$B-4] to * char list = [S+$B-2] (used reg = )
LDX	7,S
STX	9,S
;BCC_EOS
; 223 	}
; 224 	p = malloc(total - 400);	 
.88:
LDD	9,S
BNE	.89
.8A:
.87:
; Debug: sub int = const $190 to unsigned int total = [S+$B-9] (used reg = )
LDD	2,S
; Debug: rootlist unsigned int = D-$190 (used reg = )
ADDD	#-$190
TFR	D,X
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+$B-4] (used reg = )
STX	7,S
;BCC_EOS
; 225 	ok(34,p != 0);
; Debug: ne int = const 0 to * char p = [S+$B-4] (used reg = )
LDD	7,S
BEQ	.8B
LDB	#1
BRA	.8C
.8B:
CLRB
.8C:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $22 (used reg = )
LDX	#$22
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 226 	free(p);
; Debug: rootlist * char p = [S+$B-4] (used reg = )
LDX	7,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 227 	p = malloc(total / 2);
; Debug: div int = const 2 to unsigned int total = [S+$B-9] (used reg = )
LDD	2,S
LSRA
RORB
; Debug: rootlist unsigned int = D+0 (used reg = )
TFR	D,X
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+$B-4] (used reg = )
STX	7,S
;BCC_EOS
; 228 	ok(35,p != 0);
; Debug: ne int = const 0 to * char p = [S+$B-4] (used reg = )
LDD	7,S
BEQ	.8D
LDB	#1
BRA	.8E
.8D:
CLRB
.8E:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $23 (used reg = )
LDX	#$23
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 229 	free(p);
; Debug: rootlist * char p = [S+$B-4] (used reg = )
LDX	7,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 230 }
LEAS	$B,S
RTS
; 231 
; 232 void heap()
; 233 {
EXPORT	_heap
_heap:
; 234 	char *start, *p;
;BCC_EOS
; 235 	unsigned margin;
;BCC_EOS
; 236 
; 237 	start = sbrk(0);
LEAS	-6,S
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: eq * void = X+0 to * char start = [S+6-2] (used reg = )
STX	4,S
;BCC_EOS
; 238 	ok(40,start >= _end);
; Debug: ge * char = _end+0 to * char start = [S+6-2] (used reg = )
LDX	#__end
CMPX	4,S
BHI	.8F
LDB	#1
BRA	.90
.8F:
CLRB
.90:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $28 (used reg = )
LDX	#$28
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 239 	ok(41,sbrk(10)== start && sbrk(0)== start + 10);
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: logeq * char start = [S+6-2] to * void = X+0 (used reg = )
CMPX	4,S
BNE	.91
.93:
; Debug: expression subtree swapping
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: ptradd int = const $A to * char start = [S+6-2] (used reg = X)
LDU	4,S
; Debug: logeq * void = X+0 to * char = U+$A (used reg = )
PSHS	X
LEAU	$A,U
CMPU	,S++
BNE	.91
.92:
LDB	#1
BRA	.94
.91:
CLRB
.94:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $29 (used reg = )
LDX	#$29
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 240 	ok(42,sbrk(-10)== start + 10 && sbrk(0)== start);
; Debug: expression subtree swapping
; Debug: rootlist int = const -$A (used reg = )
LDX	#-$A
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: ptradd int = const $A to * char start = [S+6-2] (used reg = X)
LDU	4,S
; Debug: logeq * void = X+0 to * char = U+$A (used reg = )
PSHS	X
LEAU	$A,U
CMPU	,S++
BNE	.95
.97:
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: logeq * char start = [S+6-2] to * void = X+0 (used reg = )
CMPX	4,S
BNE	.95
.96:
LDB	#1
BRA	.98
.95:
CLRB
.98:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2A (used reg = )
LDX	#$2A
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 241 	errno = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 242 	ok(43,sbrk(30000)== (char *)-1 && errno == 12		  );	 
; Debug: rootlist int = const $7530 (used reg = )
LDX	#$7530
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: logeq * char = const -1 to * void = X+0 (used reg = )
LEAX	1,X
BNE	.99
.9B:
; Debug: logeq int = const $C to int = [errno+0] (used reg = )
LDX	>_errno
LEAX	-$C,X
BNE	.99
.9A:
LDB	#1
BRA	.9C
.99:
CLRB
.9C:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2B (used reg = )
LDX	#$2B
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 243 	ok(44,sbrk(0)== start);
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: logeq * char start = [S+6-2] to * void = X+0 (used reg = )
CMPX	4,S
BNE	.9D
LDB	#1
BRA	.9E
.9D:
CLRB
.9E:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2C (used reg = )
LDX	#$2C
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 244 	errno = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 245 	ok(45,sbrk(-30000)== (char *)-1 && errno == 12		  );	 
; Debug: rootlist int = const -$7530 (used reg = )
LDX	#-$7530
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: logeq * char = const -1 to * void = X+0 (used reg = )
LEAX	1,X
BNE	.9F
.A1:
; Debug: logeq int = const $C to int = [errno+0] (used reg = )
LDX	>_errno
LEAX	-$C,X
BNE	.9F
.A0:
LDB	#1
BRA	.A2
.9F:
CLRB
.A2:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2D (used reg = )
LDX	#$2D
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 246 	ok(46,brk(_end - 1)== -1 && sbrk(0)== start);
; Debug: rootlist * char = _end-1 (used reg = )
LDX	#__end-1
; Debug: func () int = brk+0 (used reg = )
JSR	>_brk
; Debug: logeq int = const -1 to int = X+0 (used reg = )
LEAX	1,X
BNE	.A3
.A5:
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: logeq * char start = [S+6-2] to * void = X+0 (used reg = )
CMPX	4,S
BNE	.A3
.A4:
LDB	#1
BRA	.A6
.A3:
CLRB
.A6:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2E (used reg = )
LDX	#$2E
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 247 	ok(47,brk(
; 247 start + 50)== 0 && sbrk(0)== start + 50);
; Debug: ptradd int = const $32 to * char start = [S+6-2] (used reg = )
LDX	4,S
; Debug: rootlist * char = X+$32 (used reg = )
LEAX	$32,X
; Debug: func () int = brk+0 (used reg = )
JSR	>_brk
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.A7
.A9:
; Debug: expression subtree swapping
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () * void = sbrk+0 (used reg = )
JSR	>_sbrk
; Debug: ptradd int = const $32 to * char start = [S+6-2] (used reg = X)
LDU	4,S
; Debug: logeq * void = X+0 to * char = U+$32 (used reg = )
PSHS	X
LEAU	$32,U
CMPU	,S++
BNE	.A7
.A8:
LDB	#1
BRA	.AA
.A7:
CLRB
.AA:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2F (used reg = )
LDX	#$2F
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 248 	ok(48,brk(start)== 0);
; Debug: rootlist * char start = [S+6-2] (used reg = )
LDX	4,S
; Debug: func () int = brk+0 (used reg = )
JSR	>_brk
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.AB
LDB	#1
BRA	.AC
.AB:
CLRB
.AC:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $30 (used reg = )
LDX	#$30
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 249 
; 250 	 
; 251 	margin = __heap_margin;
; Debug: eq unsigned int = [__heap_margin+0] to unsigned int margin = [S+6-6] (used reg = )
LDD	>___heap_margin
STD	0,S
;BCC_EOS
; 252 	__heap_margin = 0x7000;
; Debug: eq int = const $7000 to unsigned int = [__heap_margin+0] (used reg = )
LDD	#$7000
STD	>___heap_margin
;BCC_EOS
; 253 	ok(49,malloc(1000)== 0);
; Debug: rootlist int = const $3E8 (used reg = )
LDX	#$3E8
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
LEAX	0,X
BNE	.AD
LDB	#1
BRA	.AE
.AD:
CLRB
.AE:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $31 (used reg = )
LDX	#$31
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 254 	__heap_margin = margin;
; Debug: eq unsigned int margin = [S+6-6] to unsigned int = [__heap_margin+0] (used reg = )
LDD	0,S
STD	>___heap_margin
;BCC_EOS
; 255 	p = malloc(1000);
; Debug: rootlist int = const $3E8 (used reg = )
LDX	#$3E8
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+6-4] (used reg = )
STX	2,S
;BCC_EOS
; 256 	ok(50,p != 0);
; Debug: ne int = const 0 to * char p = [S+6-4] (used reg = )
LDD	2,S
BEQ	.AF
LDB	#1
BRA	.B0
.AF:
CLRB
.B0:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $32 (used reg = )
LDX	#$32
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 257 	free(p);
; Debug: rootlist * char p = [S+6-4] (used reg = )
LDX	2,S
; Debug: func () void = free+0 (used reg = )
JSR	>_free
;BCC_EOS
; 258 
; 259 	 
; 260 	errno = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 261 	ok(51,calloc(300,300)== 0 && errno == 12		  );
; Debug: list int = const $12C (used reg = )
LDD	#$12C
PSHS	D
; Debug: rootlist int = const $12C (used reg = )
LDX	#$12C
; Debug: func () * void = calloc+0 (used reg = )
JSR	>_calloc
LEAS	2,S
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
LEAX	0,X
BNE	.B1
.B3:
; Debug: logeq int = const $C to int = [errno+0] (used reg = )
LDX	>_errno
LEAX	-$C,X
BNE	.B1
.B2:
LDB	#1
BRA	.B4
.B1:
CLRB
.B4:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $33 (used reg = )
LDX	#$33
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 262 }
LEAS	6,S
RTS
; 263 
; 264 
; 265 int main()
; 266 {
EXPORT	_main
_main:
; 267 	basics();
; Debug: func () void = basics+0 (used reg = )
JSR	>_basics
;BCC_EOS
; 268 	stress();
; Debug: func () void = stress+0 (used reg = )
JSR	>_stress
;BCC_EOS
; 269 
; 270 	exhaust();
; Debug: func () void = exhaust+0 (used reg = )
JSR	>_exhaust
;BCC_EOS
; 271 	heap();
; Debug: func () void = heap+0 (used reg = )
JSR	>_heap
;BCC_EOS
; 272 
; 273 	say("checks ");
LOC	1
.B5:
FCC	"checks "
FCB	0
LOC	0
; Debug: rootlist * char = .B5+0 (used reg = )
LDX	#.B5
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 274 	putnum(checks);
; Debug: rootlist int = [checks+0] (used reg = )
LDX	>_checks
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 275 	say("failures ");
LOC	1
.B6:
FCC	"failures "
FCB	0
LOC	0
; Debug: rootlist * char = .B6+0 (used reg = )
LDX	#.B6
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 276 	putnum(failures);
; Debug: rootlist int = [failures+0] (used reg = )
LDX	>_failures
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 277 	return failures;
LDX	>_failures
RTS
;BCC_EOS
; 278 }
; 279 
LOC	3
_size		COMM	$50
_slot		COMM	$50
_checks		COMM	2
_failures		COMM	2
; 0 errors detected
