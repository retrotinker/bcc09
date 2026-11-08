; 1 
; 1 # 1 "stdtest.c"
; 1 # 7
; 7  
; 8 # 9 "../prefix.tmp/lib/bcc09/include/ctype.h"
; 9  
; 10 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 17
; 17  
; 18 # 32
; 32  
; 33 # 16 "../prefix.tmp/lib/bcc09/include/ctype.h"
; 16 extern	unsigned char	__ctype[];
;BCC_EOS
; 17 # 27
; 27 extern int toupper ();
;BCC_EOS
; 28 extern int tolower ();
;BCC_EOS
; 29 
; 30  
; 31 # 37
; 37  
; 38 # 6 "../prefix.tmp/lib/bcc09/include/errno.h"
; 6  
; 7 # 11
; 11 extern int errno;
;BCC_EOS
; 12 # 6 "../prefix.tmp/lib/bcc09/include/limits.h"
; 6  
; 7 # 5 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 9 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
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
; 22 extern in
; 22 t strncmp ();
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
; 50 extern size_t strspn ();
;BCC_EOS
; 51 # 15 "stdtest.c"
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
; 39 int sign(n)
; 40 int n;
EXPORT	_sign
_sign:
;BCC_EOS
; 41 {
; 42 	return n < 0 ? -1 : n > 0;
PSHS	X
; Debug: lt int = const 0 to int n = [S+2-2] (used reg = )
LDD	0,S
BGE	.8
.9:
LDD	#-1
BRA	.A
.8:
; Debug: gt int = const 0 to int n = [S+2-2] (used reg = )
LDD	0,S
BLE	.B
LDB	#1
BRA	.C
.B:
CLRB
.C:
; Debug: cast int = const 0 to char = B+0 (used reg = )
CLRA
.A:
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 43 }
; 44 
; 45  
; 46 void putlong(l)
; 47 long l;
EXPORT	_putlong
_putlong:
;BCC_EOS
; 48 {
; 49 	char buf[12];
;BCC_EOS
; 50 	char *p = buf + sizeof(buf);
PSHS	D,X
LEAS	-$E,S
; Debug: eq [$C] char buf = S+$12-4 to * char p = [S+$12-$12] (used reg = )
LEAX	$E,S
STX	0,S
;BCC_EOS
; 51 	unsigned long u = l;
LEAS	-4,S
; Debug: eq long l = [S+$16-4] to unsigned long u = [S+$16-$16] (used reg = )
LDD	$12,S
LDX	$14,S
STD	0,S
STX	2,S
;BCC_EOS
; 52 
; 53 	if (l < 0)
; Debug: lt long = const 0 to long l = [S+$16-4] (used reg = )
LDD	#0
LDX	#0
LEAY	$12,S
JSR	>lcmp_b
BLE	.D
.E:
; 54 		u = -u;
; Debug: neg unsigned long u = [S+$16-$16] (used reg = )
LDD	0,S
LDX	2,S
JSR	>lneg_b
; Debug: eq unsigned long = X+0 to unsigned long u = [S+$16-$16] (used reg = )
STD	0,S
STX	2,S
;BCC_EOS
; 55 	*--p = 0;
.D:
; Debug: predec * char p = [S+$16-$12] (used reg = )
LDX	4,S
LEAX	-1,X
STX	4,S
; Debug: eq int = const 0 to char = [X+0] (used reg = )
CLRB
STB	0,X
;BCC_EOS
; 56 	do {
.11:
; 57 		*--p = '0' + (int) (u % 10);
; Debug: mod unsigned long = const $A to unsigned long u = [S+$16-$16] (used reg = )
LDD	#0
LDX	#$A
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lmodu_b
LEAS	4,S
; Debug: cast int = const 0 to unsigned long = X+0 (used reg = )
TFR	X,D
; Debug: add int = D+0 to int = const $30 (used reg = )
; Debug: expression subtree swapping
ADDD	#$30
PSHS	D
; Debug: predec * char p = [S+$18-$12] (used reg = )
LDX	6,S
LEAX	-1,X
STX	6,S
; Debug: eq int (temp) = [S+$18-$18] to char = [X+0] (used reg = )
LDD	,S++
STB	0,X
;BCC_EOS
; 58 		u /= 10;
; Debug: divab unsigned long = const $A to unsigned long u = [S+$16-$16] (used reg = )
LDD	#0
LDX	#$A
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>ldivu_b
STD	4,S
STX	6,S
LEAS	4,S
;BCC_EOS
; 59 	} while (u);
.10:
LDD	0,S
LDX	2,S
JSR	>ltst_b
BNE	.11
.12:
;BCC_EOS
; 60 	if (l < 0)
.F:
; Debug: lt long = const 0 to long l = [S+$16-4] (used reg = )
LDD	#0
LDX	#0
LEAY	$12,S
JSR	>lcmp_b
BLE	.13
.14:
; 61 		*--p = '-';
; Debug: predec * char p = [S+$16-$12] (used reg = )
LDX	4,S
LEAX	-1,X
STX	4,S
; Debug: eq int = const $2D to char = [X+0] (used reg = )
LDB	#$2D
STB	0,X
;BCC_EOS
; 62 	say(p);
.13:
; Debug: rootlist * char p = [S+$16-$12] (used reg = )
LDX	4,S
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 63 	putchar('\n');
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 64 }
LEAS	$16,S
RTS
; 65 
; 66 
; 67  
; 68 void classes()
; 69 {
EXPORT	_classes
_classes:
; 70 	static char *names[] = {
LOC	3
.15:
; 71 		"alnum", "alpha", "cntrl", "digit", "graph", "lower",
LOC	1
.16:
FCC	"alnum"
FCB	0
LOC	3
FDB	.16+0
LOC	1
.17:
FCC	"alpha"
FCB	0
LOC	3
FDB	.17+0
LOC	1
.18:
FCC	"cntrl"
FCB	0
LOC	3
FDB	.18+0
LOC	1
.19:
FCC	"digit"
FCB	0
LOC	3
FDB	.19+0
LOC	1
.1A:
FCC	"graph"
FCB	0
LOC	3
FDB	.1A+0
LOC	1
.1B:
FCC	"lower"
FCB	0
LOC	3
FDB	.1B+0
; 72 		"print", "punct", "space", "upper", "xdigit", 0
LOC	1
.1C:
FCC	"print"
FCB	0
LOC	3
FDB	.1C+0
LOC	1
.1D:
FCC	"punct"
FCB	0
LOC	3
FDB	.1D+0
LOC	1
.1E:
FCC	"space"
FCB	0
LOC	3
FDB	.1E+0
LOC	1
.1F:
FCC	"upper"
FCB	0
LOC	3
FDB	.1F+0
LOC	1
.20:
FCC	"xdigit"
FCB	0
LOC	3
FDB	.20+0
; 73 	};
FDB	0
LOC	0
;BCC_EOS
; 74 	int i, c, r;
;BCC_EOS
; 75 
; 76 	for (i = 0; names[i]; i++) {
LEAS	-6,S
; Debug: eq int = const 0 to int i = [S+6-2] (used reg = )
LDD	#0
STD	4,S
;BCC_EOS
;BCC_EOS
JMP	.23
.24:
; 77 		say(names[i]);
; Debug: ptradd int i = [S+6-2] to [$C] * char = .15+0 (used reg = )
LDD	4,S
LSLB
ROLA
LDX	#.15
LEAX	D,X
; Debug: rootlist * char = [X+0] (used reg = )
LDX	0,X
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 78 		putchar('\n');
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 79 		for (c = -1; c < 256; c++) {
; Debug: eq int = const -1 to int c = [S+6-4] (used reg = )
LDD	#-1
STD	2,S
;BCC_EOS
;BCC_EOS
JMP	.27
.28:
; 80 			switch (i) {
LDD	4,S
JMP	.2B
; 81 			case 0: r = (!!((__ctype[1+(unsigned char)c])&(0x02		  |0x04		  |0x01		  ))) ; break;
.2C:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const 7 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#7
TSTB
BEQ	.2D
.2E:
LDB	#1
BRA	.2F
.2D:
CLRB
.2F:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
JMP	.29
;BCC_EOS
; 82 			case 1: r = (!!((__ctype[1+(unsigned char)c])&(0x02		  |0x04		  ))) ; break;
.30:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const 6 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#6
TSTB
BEQ	.31
.32:
LDB	#1
BRA	.33
.31:
CLRB
.33:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
JMP	.29
;BCC_EOS
; 83 			case 2: r = (!!((__ctype[1+(unsigned char)c])&0x08		  )) ; break;
.34:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const 8 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#8
TSTB
BEQ	.35
.36:
LDB	#1
BRA	.37
.35:
CLRB
.37:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
JMP	.29
;BCC_EOS
; 84 			case 3: r = (!!((__ctype[1+(unsigned char)c])&0x01		  )) ; break;
.38:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const 1 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#1
TSTB
BEQ	.39
.3A:
LDB	#1
BRA	.3B
.39:
CLRB
.3B:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
JMP	.29
;BCC_EOS
; 85 			case 4: r = (!!((__ctype[1+(unsigned char)c])&(0x02		  |0x04		  |0x01		  |0x20		  ))) ; break;
.3C:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const $27 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#$27
TSTB
BEQ	.3D
.3E:
LDB	#1
BRA	.3F
.3D:
CLRB
.3F:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
JMP	.29
;BCC_EOS
; 86 			case 5: r = (!!((__ctype[1+(unsigned char)c])&0x04		  )) ; break;
.40:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const 4 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#4
TSTB
BEQ	.41
.42:
LDB	#1
BRA	.43
.41:
CLRB
.43:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
JMP	.29
;BCC_EOS
; 87 			case 6: r = (!!((__ctype[1+(unsigned char)c])&(0x02		  |0x04		  |0x01		  |0x20		  |0x80		  ))) ; break;
.44:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const $A7 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#$A7
TSTB
BEQ	.45
.46:
LDB	#1
BRA	.47
.45:
CLRB
.47:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
JMP	.29
;BCC_EOS
; 88 			case 7: r = (!!((__ctype[1+(unsigned char)c])&0x20		  )) ; break;
.48:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const $20 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#$20
TSTB
BEQ	.49
.4A:
LDB	#1
BRA	.4B
.49:
CLRB
.4B:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
BRA	.29
;BCC_EOS
; 89 			case 8: r = (!!((__ctype[1+(unsigned char)c])&0x10		  )) ; break;
.4C:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const $10 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#$10
TSTB
BEQ	.4D
.4E:
LDB	#1
BRA	.4F
.4D:
CLRB
.4F:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
BRA	.29
;BCC_EOS
; 90 			case 9: r = (!!((__ctype[1+(unsigned char)c])&0x02		  )) ; break;
.50:
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const 2 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#2
TSTB
BEQ	.51
.52:
LDB	#1
BRA	.53
.51:
CLRB
.53:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
BRA	.29
;BCC_EOS
; 91 			default: r = (!!((__cty
.54:
; 91 pe[1+(unsigned char)c])&0x40		  )) ; break;
; Debug: add unsigned char c = [S+6-3] to int = const 1 (used reg = )
; Debug: expression subtree swapping
LDB	3,S
CLRA
; Debug: ptradd unsigned int = D+1 to [0] unsigned char = __ctype+0 (used reg = )
ADDD	#1
LDX	#___ctype
LEAX	D,X
; Debug: and int = const $40 to unsigned char = [X+0] (used reg = )
LDB	0,X
ANDB	#$40
TSTB
BEQ	.55
.56:
LDB	#1
BRA	.57
.55:
CLRB
.57:
; Debug: eq char = B+0 to int r = [S+6-6] (used reg = )
CLRA
STD	0,S
;BCC_EOS
BRA	.29
;BCC_EOS
; 92 			}
; 93 			putchar(r ? '1' : '0');
BRA	.29
.2B:
SUBD	#0
BLT	.54
CMPD	#9
BHI	.58
LSLB
ROLA
LDX	#.59
JMP	[D,X]
.59:
FDB	.2C
FDB	.30
FDB	.34
FDB	.38
FDB	.3C
FDB	.40
FDB	.44
FDB	.48
FDB	.4C
FDB	.50
.58:
BRA	.54
.29:
..FFFF		EQU	-6
LDD	0,S
BEQ	.5A
.5B:
LDB	#$31
BRA	.5C
.5A:
LDB	#$30
.5C:
; Debug: rootlist char = B+0 (used reg = )
CLRA
TFR	D,X
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 94 			if ((c & 63)== 63)
; Debug: and int = const $3F to int c = [S+6-4] (used reg = )
LDB	3,S
ANDB	#$3F
; Debug: logeq int = const $3F to char = B+0 (used reg = )
SUBB	#$3F
BNE	.5D
.5E:
; 95 				putchar('\n');
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 96 		}
.5D:
; 97 		putchar('\n');
.26:
; Debug: postinc int c = [S+6-4] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.27:
; Debug: lt int = const $100 to int c = [S+6-4] (used reg = )
LDD	2,S
SUBD	#$100
LBLT	.28
.5F:
.25:
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 98 	}
; 99 	say("toupper tolower\n");
.22:
; Debug: postinc int i = [S+6-2] (used reg = )
LDD	4,S
ADDD	#1
STD	4,S
.23:
; Debug: ptradd int i = [S+6-2] to [$C] * char = .15+0 (used reg = )
LDD	4,S
LSLB
ROLA
LDX	#.15
LEAX	D,X
LDD	0,X
LBNE	.24
.60:
.21:
LOC	1
.61:
FCC	"toupper tolower"
FCB	$A
FCB	0
LOC	0
; Debug: rootlist * char = .61+0 (used reg = )
LDX	#.61
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 100 	for (c = -1; c < 256; c++)
; Debug: eq int = const -1 to int c = [S+6-4] (used reg = )
LDD	#-1
STD	2,S
;BCC_EOS
;BCC_EOS
; 101 		if (toupper(c)!= c || tolower(c)!= c) {
BRA	.64
.65:
; Debug: rootlist int c = [S+6-4] (used reg = )
LDX	2,S
; Debug: func () int = toupper+0 (used reg = )
JSR	>_toupper
; Debug: ne int c = [S+6-4] to int = X+0 (used reg = )
CMPX	2,S
BNE	.67
.68:
; Debug: rootlist int c = [S+6-4] (used reg = )
LDX	2,S
; Debug: func () int = tolower+0 (used reg = )
JSR	>_tolower
; Debug: ne int c = [S+6-4] to int = X+0 (used reg = )
CMPX	2,S
BEQ	.66
.67:
; 102 			putnum(c);
; Debug: rootlist int c = [S+6-4] (used reg = )
LDX	2,S
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 103 			putnum(toupper(c));
; Debug: rootlist int c = [S+6-4] (used reg = )
LDX	2,S
; Debug: func () int = toupper+0 (used reg = )
JSR	>_toupper
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 104 			putnum(tolower(c));
; Debug: rootlist int c = [S+6-4] (used reg = )
LDX	2,S
; Debug: func () int = tolower+0 (used reg = )
JSR	>_tolower
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 105 		}
; 106 }
.66:
.63:
; Debug: postinc int c = [S+6-4] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.64:
; Debug: lt int = const $100 to int c = [S+6-4] (used reg = )
LDD	2,S
SUBD	#$100
BLT	.65
.69:
.62:
LEAS	6,S
RTS
; 107 
; 108 void cases()
; 109 {
EXPORT	_cases
_cases:
; 110 	ok(10,strcasecmp("Hello","hELLO")== 0);
LOC	1
.6A:
FCC	"Hello"
FCB	0
LOC	0
LOC	1
.6B:
FCC	"hELLO"
FCB	0
LOC	0
; Debug: list * char = .6B+0 (used reg = )
LDX	#.6B
PSHS	X
; Debug: rootlist * char = .6A+0 (used reg = )
LDX	#.6A
; Debug: func () int = strcasecmp+0 (used reg = )
JSR	>_strcasecmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.6C
LDB	#1
BRA	.6D
.6C:
CLRB
.6D:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 111 	ok(11,sign(strcasecmp("a","B"))== -1);	 
LOC	1
.6E:
FCC	"a"
FCB	0
LOC	0
LOC	1
.6F:
FCC	"B"
FCB	0
LOC	0
; Debug: list * char = .6F+0 (used reg = )
LDX	#.6F
PSHS	X
; Debug: rootlist * char = .6E+0 (used reg = )
LDX	#.6E
; Debug: func () int = strcasecmp+0 (used reg = )
JSR	>_strcasecmp
LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
LEAX	1,X
BNE	.70
LDB	#1
BRA	.71
.70:
CLRB
.71:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $B (used reg = )
LDX	#$B
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 112 	ok(12,sign(strcasecmp("B","a"))== 1);
LOC	1
.72:
FCC	"B"
FCB	0
LOC	0
LOC	1
.73:
FCC	"a"
FCB	0
LOC	0
; Debug: list * char = .73+0 (used reg = )
LDX	#.73
PSHS	X
; Debug: rootlist * char = .72+0 (used reg = )
LDX	#.72
; Debug: func () int = strcasecmp+0 (used reg = )
JSR	>_strcasecmp
LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
JSR	>_sign
; Debug: logeq int = const 1 to int = X+0 (used reg = )
LEAX	-1,X
BNE	.74
LDB	#1
BRA	.75
.74:
CLRB
.75:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $C (used reg = )
LDX	#$C
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 113 	ok(13,sign(strcasecmp("abc","ABCD"))== -1);
LOC	1
.76:
FCC	"abc"
FCB	0
LOC	0
LOC	1
.77:
FCC	"ABCD"
FCB	0
LOC	0
; Debug: list * char = .77+0 (used reg = )
LDX	#.77
PSHS	X
; Debug: rootlist * char = .76+0 (used reg = )
LDX	#.76
; Debug: func () int = strcasecmp+0 (used reg = )
JSR	>_strcasecmp
LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
LEAX	1,X
BNE	.78
LDB	#1
BRA	.79
.78:
CLRB
.79:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $D (used reg = )
LDX	#$D
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 114 	ok(14,strcasecmp("","")== 0);
LOC	1
.7A:
FCB	0
LOC	0
LOC	1
.7B:
FCB	0
LOC	0
; Debug: list * char = .7B+0 (used reg = )
LDX	#.7B
PSHS	X
; Debug: rootlist * char = .7A+0 (used reg = )
LDX	#.7A
; Debug: func () int = strcasecmp+0 (used reg = )
JSR	>_strcasecmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.7C
LDB	#1
BRA	.7D
.7C:
CLRB
.7D:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $E (used reg = )
LDX	#$E
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 115 	ok(15,strncasecmp("abcX","ABCy",3)== 0);
LOC	1
.7E:
FCC	"abcX"
FCB	0
LOC	0
LOC	1
.7F:
FCC	"ABCy"
FCB	0
LOC	0
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list * char = .7F+0 (used reg = )
LDX	#.7F
PSHS	X
; Debug: rootlist * char = .7E+0 (used reg = )
LDX	#.7E
; Debug: func () int = strncasecmp+0 (used reg = )
JSR	>_strncasecmp
LEAS	4,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.80
LDB	#1
BRA	.81
.80:
CLRB
.81:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $F (used reg = )
LDX	#$F
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 116 	ok(16,sign(strncasecmp("abcX","ABCy",4))== -1);
LOC	1
.82:
FCC	"abcX"
FCB	0
LOC	0
LOC	1
.83:
FCC	"ABCy"
FCB	0
LOC	0
; Debug: list int = const 4 (used reg = )
LDD	#4
PSHS	D
; Debug: list * char = .83+0 (used reg = )
LDX	#.83
PSHS	X
; Debug: rootlist * char = .82+0 (used reg = )
LDX	#.82
; Debug: func () int = strncasecmp+0 (used reg = )
JSR	>_strncasecmp
LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
LEAX	1,X
BNE	.84
LDB	#1
BRA	.85
.84:
CLRB
.85:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $10 (used reg = )
LDX	#$10
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 117 	ok(17,strncasecmp("a","b",0)== 0);
LOC	1
.86:
FCC	"a"
FCB	0
LOC	0
LOC	1
.87:
FCC	"b"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: list * char = .87+0 (used reg = )
LDX	#.87
PSHS	X
; Debug: rootlist * char = .86+0 (used reg = )
LDX	#.86
; Debug: func () int = strncasecmp+0 (used reg = )
JSR	>_strncasecmp
LEAS	4,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.88
LDB	#1
BRA	.89
.88:
CLRB
.89:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $11 (used reg = )
LDX	#$11
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 118 	ok(18,sign(strncasecmp("Ab","aC",5))== -1);
LOC	1
.8A:
FCC	"Ab"
FCB	0
LOC	0
LOC	1
.8B:
FCC	"aC"
FCB	0
LOC	0
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: list * char = .8B+0 (used reg = )
LDX	#.8B
PSHS	X
; Debug: rootlist * char = .8A+0 (used reg = )
LDX	#.8A
; Debug: func () int = strncasecmp+0 (used reg = )
JSR	>_strncasecmp
LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
LEAX	1,X
BNE	.8C
LDB	#1
BRA	.8D
.8C:
CLRB
.8D:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $12 (used reg = )
LDX	#$12
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 119 }
RTS
; 120 
; 121  
; 122 void conv(s,base)
; 123 char *s;
EXPORT	_conv
_conv:
;BCC_EOS
; 124 int base;
;BCC_EOS
; 125 {
; 126 	char *end;
;BCC_EOS
; 127 
; 128 	say(s);
PSHS	D,X
; Debug: rootlist * char s = [S+4-2] (used reg = )
LDX	2,S
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 129 	putchar('\n');
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 130 	putlong(strtol(s,&end,base));
; Debug: list int base = [S+4+2] (used reg = )
LDD	6,S
PSHS	D
; Debug: list * * char end = S+6-4 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char s = [S+8-2] (used reg = )
LDX	6,S
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: rootlist long = X+0 (used reg = )
; Debug: func () void = putlong+0 (used reg = )
JSR	>_putlong
;BCC_EOS
; 131 	putnum(end - s);
; Debug: ptrsub * char s = [S+4-2] to * char end = [S+4-4] (used reg = )
LDD	0,S
SUBD	2,S
; Debug: rootlist int = D+0 (used reg = )
TFR	D,X
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 132 	putlong((long)strtoul(s,&end,base)& 0xffffL);
; Debug: list int base = [S+4+2] (used reg = )
LDD	6,S
PSHS	D
; Debug: list * * char end = S+6-4 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char s = [S+8-2] (used reg = )
LDX	6,S
; Debug: func () unsigned long = strtoul+0 (used reg = )
JSR	>_strtoul
LEAS	4,S
; Debug: cast long = const 0 to unsigned long = X+0 (used reg = )
; Debug: and long = const $FFFF to long = X+0 (used reg = )
PSHS	D,X
LDD	#0
LDX	#$FFFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>land_b
LEAS	8,S
; Debug: rootlist long = X+0 (used reg = )
; Debug: func () void = putlong+0 (used reg = )
JSR	>_putlong
;BCC_EOS
; 133 	putnum(end - s);
; Debug: ptrsub * char s = [S+4-2] to * char end = [S+4-4] (used reg = )
LDD	0,S
SUBD	2,S
; Debug: rootlist int = D+0 (used reg = )
TFR	D,X
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 134 }
PULS	U,Y,PC
; 135 
; 136 void numbers()
; 137 {
EXPORT	_numbers
_numbers:
; 138 	char *end;
;BCC_EOS
; 139 
; 140 	putnum(atoi("123"));
LEAS	-2,S
LOC	1
.8E:
FCC	"123"
FCB	0
LOC	0
; Debug: rootlist * char = .8E+0 (used reg = )
LDX	#.8E
; Debug: func () int = atoi+0 (used reg = )
JSR	>_atoi
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 141 	putnum(atoi("  -45x"));
LOC	1
.8F:
FCC	"  -45x"
FCB	0
LOC	0
; Debug: rootlist * char = .8F+0 (used reg = )
LDX	#.8F
; Debug: func () int = atoi+0 (used reg = )
JSR	>_atoi
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 142 	putnum(atoi("+7"));
LOC	1
.90:
FCC	"+7"
FCB	0
LOC	0
; Debug: rootlist * char = .90+0 (used reg = )
LDX	#.90
; Debug: func () int = atoi+0 (used reg = )
JSR	>_atoi
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 143 	putnum(atoi("\t\n 9"));
LOC	1
.91:
FCB	9,$A
FCC	" 9"
FCB	0
LOC	0
; Debug: rootlist * char = .91+0 (used reg = )
LDX	#.91
; Debug: func () int = atoi+0 (used reg = )
JSR	>_atoi
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 144 	putnum(atoi("x9"));
LOC	1
.92:
FCC	"x9"
FCB	0
LOC	0
; Debug: rootlist * char = .92+0 (used reg = )
LDX	#.92
; Debug: func () int = atoi+0 (used reg = )
JSR	>_atoi
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 145 	putlong(atol("  -100000"));
LOC	1
.93:
FCC	"  -100000"
FCB	0
LOC	0
; Debug: rootlist * char = .93+0 (used reg = )
LDX	#.93
; Debug: func () long = atol+0 (used reg = )
JSR	>_atol
; Debug: rootlist long = X+0 (used reg = )
; Debug: func () void = putlong+0 (used reg = )
JSR	>_putlong
;BCC_EOS
; 146 	putlong(atol("2147483647"));
LOC	1
.94:
FCC	"2147483647"
FCB	0
LOC	0
; Debug: rootlist * char = .94+0 (used reg = )
LDX	#.94
; Debug: func () long = atol+0 (used reg = )
JSR	>_atol
; Debug: rootlist long = X+0 (used reg = )
; Debug: func () void = putlong+0 (used reg = )
JSR	>_putlong
;BCC_EOS
; 147 
; 148 	conv("0",10);
LOC	1
.95:
FCC	"0"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist * char = .95+0 (used reg = )
LDX	#.95
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 149 	conv("  -1234",10);
LOC	1
.96:
FCC	"  -1234"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist * char = .96+0 (used reg = )
LDX	#.96
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 150 	conv("+99 bottles",10);
LOC	1
.97:
FCC	"+99 bottles"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist * char = .97+0 (used reg = )
LDX	#.97
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 151 	conv("12a",10);		 
LOC	1
.98:
FCC	"12a"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist * char = .98+0 (used reg = )
LDX	#.98
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 152 	conv("z",36);
LOC	1
.99:
FCC	"z"
FCB	0
LOC	0
; Debug: list int = const $24 (used reg = )
LDD	#$24
PSHS	D
; Debug: rootlist * char = .99+0 (used reg = )
LDX	#.99
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 153 	conv("0x1F",16);
LOC	1
.9A:
FCC	"0x1F"
FCB	0
LOC	0
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: rootlist * char = .9A+0 (used reg = )
LDX	#.9A
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 154 	conv("0x1F",0);
LOC	1
.9B:
FCC	"0x1F"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: rootlist * char = .9B+0 (used reg = )
LDX	#.9B
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 155 	conv("0X1f",0);
LOC	1
.9C:
FCC	"0X1f"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: rootlist * char = .9C+0 (used reg = )
LDX	#.9C
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 156 	conv("0x",0);			 
LOC	1
.9D:
FCC	"0x"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: rootlist * char = .9D+0 (used reg = )
LDX	#.9D
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 157 	conv("0xg",16);
LOC	1
.9E:
FCC	"0xg"
FCB	0
LOC	0
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: rootlist * char = .9E+0 (used reg = )
LDX	#.9E
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 158 	conv("017",0);
LOC	1
.9F:
FCC	"017"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: rootlist * char = .9F+0 (used reg = )
LDX	#.9F
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 159 	conv("08",0);			 
LOC	1
.A0:
FCC	"08"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: rootlist * char = .A0+0 (used reg = )
LDX	#.A0
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 160 	conv("101",2);
LOC	1
.A1:
FCC	"101"
FCB	0
LOC	0
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: rootlist * char = .A1+0 (used reg = )
LDX	#.A1
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 161 	conv("777",8);
LOC	1
.A2:
FCC	"777"
FCB	0
LOC	0
; Debug: list int = const 8 (used reg = )
LDD	#8
PSHS	D
; Debug: rootlist * char = .A2+0 (used reg = )
LDX	#.A2
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 162 	conv("ff",16);
LOC	1
.A3:
FCC	"ff"
FCB	0
LOC	0
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: rootlist * char = .A3+0 (used reg = )
LDX	#.A3
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 163 	conv("-ff",16);
LOC	1
.A4:
FCC	"-ff"
FCB	0
LOC	0
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: rootlist * char = .A4+0 (used reg = )
LDX	#.A4
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 164 	conv("",10);			 
LOC	1
.A5:
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist * char = .A5+0 (used reg = )
LDX	#.A5
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 165 	conv("   ",10);
LOC	1
.A6:
FCC	"   "
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist * char = .A6+0 (used reg = )
LDX	#.A6
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 166 	conv("-",10);
LOC	1
.A7:
FCC	"-"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist * char = .A7+0 (used reg = )
LDX	#.A7
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 167 	conv("+x",10);
LOC	1
.A8:
FCC	"+x"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist * char = .A8+0 (used reg = )
LDX	#.A8
; Debug: func () void = conv+0 (used reg = )
JSR	>_conv
LEAS	2,S
;BCC_EOS
; 168 
; 169 
; 170 
; 171 	 
; 172 	ok(19,strtol("12",&end,1)== 0 && end != 0 && *end == '1'
LOC	1
.A9:
FCC	"12"
FCB	0
LOC	0
; 173 	   && strtol("12",&end,37)== 0 && *end == '1');
LOC	1
.AA:
FCC	"12"
FCB	0
LOC	0
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .A9+0 (used reg = )
LDX	#.A9
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const 0 to long = X+0 (used reg = )
PSHS	D,X
LDD	#0
LDX	#0
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.AB
.B0:
; Debug: ne int = const 0 to * char end = [S+2-2] (used reg = )
LDD	0,S
BEQ	.AB
.AF:
; Debug: logeq int = const $31 to char end = [[S+2-2]] (used reg = )
LDB	[0,S]
SUBB	#$31
BNE	.AB
.AE:
; Debug: list int = const $25 (used reg = )
LDD	#$25
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .AA+0 (used reg = )
LDX	#.AA
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const 0 to long = X+0 (used reg = )
PSHS	D,X
LDD	#0
LDX	#0
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.AB
.AD:
; Debug: logeq int = const $31 to char end = [[S+2-2]] (used reg = )
LDB	[0,S]
SUBB	#$31
BNE	.AB
.AC:
LDB	#1
BRA	.B1
.AB:
CLRB
.B1:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $13 (used reg = )
LDX	#$13
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 174 
; 175 	ok(20,strtol("123",(char **)0,10)== 123);
LOC	1
.B2:
FCC	"123"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: rootlist * char = .B2+0 (used reg = )
LDX	#.B2
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const $7B to long = X+0 (used reg = )
PSHS	D,X
LDD	#0
LDX	#$7B
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
BNE	.B3
LDB	#1
BRA	.B4
.B3:
CLRB
.B4:
LEAS	8,S
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $14 (used reg = )
LDX	#$14
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 176 	errno = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 177 	ok(21,strtol("99",&end,10)== 99 && errno == 0);
LOC	1
.B5:
FCC	"99"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .B5+0 (used reg = )
LDX	#.B5
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const $63 to long = X+0 (used reg = )
PSHS	D,X
LDD	#0
LDX	#$63
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.B6
.B8:
; Debug: logeq int = const 0 to int = [errno+0] (used reg = )
LDD	>_errno
BNE	.B6
.B7:
LDB	#1
BRA	.B9
.B6:
CLRB
.B9:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $15 (used reg = )
LDX	#$15
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 178 
; 179 	if (sizeof(long)== 4) {
.BB:
; 180 		errno = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 181 		ok(22,strtol("2147483647",&end,10)== 2147483647L 
LOC	1
.BC:
FCC	"2147483647"
FCB	0
LOC	0
; 182 		   && errno == 0 && *end == 0);
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .BC+0 (used reg = )
LDX	#.BC
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const $7FFFFFFF to long = X+0 (used reg = )
PSHS	D,X
LDD	#$7FFF
LDX	#$FFFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.BD
.C0:
; Debug: logeq int = const 0 to int = [errno+0] (used reg = )
LDD	>_errno
BNE	.BD
.BF:
; Debug: logeq int = const 0 to char end = [[S+2-2]] (used reg = )
LDB	[0,S]
BNE	.BD
.BE:
LDB	#1
BRA	.C1
.BD:
CLRB
.C1:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $16 (used reg = )
LDX	#$16
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 183 		ok(23,strtol("2147483648",&end,10)== 2147483647L 
LOC	1
.C2:
FCC	"2147483648"
FCB	0
LOC	0
; 184 		   && errno == 34		   && *end == 0);
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .C2+0 (used reg = )
LDX	#.C2
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const $7FFFFFFF to long = X+0 (used reg = )
PSHS	D,X
LDD	#$7FFF
LDX	#$FFFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.C3
.C6:
; Debug: logeq int = const $22 to int = [errno+0] (used reg = )
LDX	>_errno
LEAX	-$22,X
BNE	.C3
.C5:
; Debug: logeq int = const 0 to char end = [[S+2-2]] (used reg = )
LDB	[0,S]
BNE	.C3
.C4:
LDB	#1
BRA	.C7
.C3:
CLRB
.C7:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $17 (used reg = )
LDX	#$17
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 185 		errno = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 186 		ok(24,strtol("-2147483648",&end,10)== (-2147483647L-1)
LOC	1
.C8:
FCC	"-2147483648"
FCB	0
LOC	0
; 187 && errno == 0);
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .C8+0 (used reg = )
LDX	#.C8
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const -$80000000 to long = X+0 (used reg = )
PSHS	D,X
LDD	#$8000
LDX	#0
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.C9
.CB:
; Debug: logeq int = const 0 to int = [errno+0] (used reg = )
LDD	>_errno
BNE	.C9
.CA:
LDB	#1
BRA	.CC
.C9:
CLRB
.CC:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $18 (used reg = )
LDX	#$18
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 188 		ok(25,strtol("-2147483649",&end,10)== (-2147483647L-1)
LOC	1
.CD:
FCC	"-2147483649"
FCB	0
LOC	0
; 189 && errno == 34		  );
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .CD+0 (used reg = )
LDX	#.CD
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const -$80000000 to long = X+0 (used reg = )
PSHS	D,X
LDD	#$8000
LDX	#0
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.CE
.D0:
; Debug: logeq int = const $22 to int = [errno+0] (used reg = )
LDX	>_errno
LEAX	-$22,X
BNE	.CE
.CF:
LDB	#1
BRA	.D1
.CE:
CLRB
.D1:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $19 (used reg = )
LDX	#$19
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 190 		errno
; 190  = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 191 		ok(26,strtoul("4294967295",&end,10)== 0xFFFFFFFFUL 
LOC	1
.D2:
FCC	"4294967295"
FCB	0
LOC	0
; 192 		   && errno == 0);
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .D2+0 (used reg = )
LDX	#.D2
; Debug: func () unsigned long = strtoul+0 (used reg = )
JSR	>_strtoul
LEAS	4,S
; Debug: logeq unsigned long = const $FFFFFFFF to unsigned long = X+0 (used reg = )
PSHS	D,X
LDD	#$FFFF
LDX	#$FFFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmpu_b
LEAS	8,S
BNE	.D3
.D5:
; Debug: logeq int = const 0 to int = [errno+0] (used reg = )
LDD	>_errno
BNE	.D3
.D4:
LDB	#1
BRA	.D6
.D3:
CLRB
.D6:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $1A (used reg = )
LDX	#$1A
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 193 		ok(27,strtoul("4294967296",&end,10)== 0xFFFFFFFFUL 
LOC	1
.D7:
FCC	"4294967296"
FCB	0
LOC	0
; 194 		   && errno == 34		   && *end == 0);
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .D7+0 (used reg = )
LDX	#.D7
; Debug: func () unsigned long = strtoul+0 (used reg = )
JSR	>_strtoul
LEAS	4,S
; Debug: logeq unsigned long = const $FFFFFFFF to unsigned long = X+0 (used reg = )
PSHS	D,X
LDD	#$FFFF
LDX	#$FFFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmpu_b
LEAS	8,S
BNE	.D8
.DB:
; Debug: logeq int = const $22 to int = [errno+0] (used reg = )
LDX	>_errno
LEAX	-$22,X
BNE	.D8
.DA:
; Debug: logeq int = const 0 to char end = [[S+2-2]] (used reg = )
LDB	[0,S]
BNE	.D8
.D9:
LDB	#1
BRA	.DC
.D8:
CLRB
.DC:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $1B (used reg = )
LDX	#$1B
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 195 		errno = 0;
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
LDD	#0
STD	>_errno
;BCC_EOS
; 196 		ok(28,strtoul("-1",&end,10)== 0xFFFFFFFFUL  && errno == 0);
LOC	1
.DD:
FCC	"-1"
FCB	0
LOC	0
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .DD+0 (used reg = )
LDX	#.DD
; Debug: func () unsigned long = strtoul+0 (used reg = )
JSR	>_strtoul
LEAS	4,S
; Debug: logeq unsigned long = const $FFFFFFFF to unsigned long = X+0 (used reg = )
PSHS	D,X
LDD	#$FFFF
LDX	#$FFFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmpu_b
LEAS	8,S
BNE	.DE
.E0:
; Debug: logeq int = const 0 to int = [errno+0] (used reg = )
LDD	>_errno
BNE	.DE
.DF:
LDB	#1
BRA	.E1
.DE:
CLRB
.E1:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $1C (used reg = )
LDX	#$1C
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 197 		ok(29,strtol("99999999999999999999",&end,16)== 2147483647L 
LOC	1
.E2:
FCC	"99999999999999999999"
FCB	0
LOC	0
; 198 		   && *end == 0);
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: list * * char end = S+4-2 (used reg = )
LEAX	2,S
PSHS	X
; Debug: rootlist * char = .E2+0 (used reg = )
LDX	#.E2
; Debug: func () long = strtol+0 (used reg = )
JSR	>_strtol
LEAS	4,S
; Debug: logeq long = const $7FFFFFFF to long = X+0 (used reg = )
PSHS	D,X
LDD	#$7FFF
LDX	#$FFFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.E3
.E5:
; Debug: logeq int = const 0 to char end = [[S+2-2]] (used reg = )
LDB	[0,S]
BNE	.E3
.E4:
LDB	#1
BRA	.E6
.E3:
CLRB
.E6:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $1D (used reg = )
LDX	#$1D
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 199 	}
; 200 	if (sizeof(int)== 2) {
.BA:
.E8:
; 201 		ok(30,atoi("-32768")== (-32767-1));
LOC	1
.E9:
FCC	"-32768"
FCB	0
LOC	0
; Debug: rootlist * char = .E9+0 (used reg = )
LDX	#.E9
; Debug: func () int = atoi+0 (used reg = )
JSR	>_atoi
; Debug: logeq int = const -$8000 to int = X+0 (used reg = )
CMPX	#-$8000
BNE	.EA
LDB	#1
BRA	.EB
.EA:
CLRB
.EB:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $1E (used reg = )
LDX	#$1E
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 202 		ok(31,atoi("32767")== 32767 );
LOC	1
.EC:
FCC	"32767"
FCB	0
LOC	0
; Debug: rootlist * char = .EC+0 (used reg = )
LDX	#.EC
; Debug: func () int = atoi+0 (used reg = )
JSR	>_atoi
; Debug: logeq int = const $7FFF to int = X+0 (used reg = )
CMPX	#$7FFF
BNE	.ED
LDB	#1
BRA	.EE
.ED:
CLRB
.EE:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $1F (used reg = )
LDX	#$1F
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 203 	}
; 204 
; 205 	ok(32,abs(-5)== 5 && abs(5)== 5 && abs(0)== 0);
.E7:
; Debug: rootlist int = const -5 (used reg = )
LDX	#-5
; Debug: func () int = abs+0 (used reg = )
JSR	>_abs
; Debug: logeq int = const 5 to int = X+0 (used reg = )
LEAX	-5,X
BNE	.EF
.F2:
; Debug: rootlist int = const 5 (used reg = )
LDX	#5
; Debug: func () int = abs+0 (used reg = )
JSR	>_abs
; Debug: logeq int = const 5 to int = X+0 (used reg = )
LEAX	-5,X
BNE	.EF
.F1:
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () int = abs+0 (used reg = )
JSR	>_abs
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.EF
.F0:
LDB	#1
BRA	.F3
.EF:
CLRB
.F3:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $20 (used reg = )
LDX	#$20
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 206 	ok(33,labs(-100000L)== 100000L && labs(7L)== 7L);
; Debug: rootlist long = const -$186A0 (used reg = )
LDD	#$FFFE
LDX	#$7960
; Debug: func () long = labs+0 (used reg = )
JSR	>_labs
; Debug: logeq long = const $186A0 to long = X+0 (used reg = )
PSHS	D,X
LDD	#1
LDX	#$86A0
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.F4
.F6:
; Debug: rootlist long = const 7 (used reg = )
LDD	#0
LDX	#7
; Debug: func () long = labs+0 (used reg = )
JSR	>_labs
; Debug: logeq long = const 7 to long = X+0 (used reg = )
PSHS	D,X
LDD	#0
LDX	#7
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
LEAS	8,S
BNE	.F4
.F5:
LDB	#1
BRA	.F7
.F4:
CLRB
.F7:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $21 (used reg = )
LDX	#$21
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 207 	if (sizeof(int)== 2)
.F9:
; 208 		ok(34,abs((-32767-1))== (-32767-1));
; Debug: rootlist int = const -$8000 (used reg = )
LDX	#-$8000
; Debug: func () int = abs+0 (used reg = )
JSR	>_abs
; Debug: logeq int = const -$8000 to int = X+0 (used reg = )
CMPX	#-$8000
BNE	.FA
LDB	#1
BRA	.FB
.FA:
CLRB
.FB:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $22 (used reg = )
LDX	#$22
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 209 }
.F8:
PULS	Y,PC
; 210 
; 211 
; 212  
; 213 void strings()
; 214 {
EXPORT	_strings
_strings:
; 215 	ok(40,strcmp(itoa(0),"0")== 0);
LOC	1
.FC:
FCC	"0"
FCB	0
LOC	0
; Debug: list * char = .FC+0 (used reg = )
LDX	#.FC
PSHS	X
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () * char = itoa+0 (used reg = )
JSR	>_itoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.FD
LDB	#1
BRA	.FE
.FD:
CLRB
.FE:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $28 (used reg = )
LDX	#$28
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 216 	ok(41,strcmp(itoa(-1),"-1")== 0);
LOC	1
.FF:
FCC	"-1"
FCB	0
LOC	0
; Debug: list * char = .FF+0 (used reg = )
LDX	#.FF
PSHS	X
; Debug: rootlist int = const -1 (used reg = )
LDX	#-1
; Debug: func () * char = itoa+0 (used reg = )
JSR	>_itoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.100
LDB	#1
BRA	.101
.100:
CLRB
.101:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $29 (used reg = )
LDX	#$29
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 217 	ok(42,strcmp(itoa(32767),"32767")== 0);
LOC	1
.102:
FCC	"32767"
FCB	0
LOC	0
; Debug: list * char = .102+0 (used reg = )
LDX	#.102
PSHS	X
; Debug: rootlist int = const $7FFF (used reg = )
LDX	#$7FFF
; Debug: func () * char = itoa+0 (used reg = )
JSR	>_itoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.103
LDB	#1
BRA	.104
.103:
CLRB
.104:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2A (used reg = )
LDX	#$2A
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 218 	ok(43,strcmp(itoa(-32768),"-32768")== 0);	 
LOC	1
.105:
FCC	"-32768"
FCB	0
LOC	0
; Debug: list * char = .105+0 (used reg = )
LDX	#.105
PSHS	X
; Debug: rootlist long = const -$8000 (used reg = )
LDD	#$FFFF
LDX	#$8000
; Debug: func () * char = itoa+0 (used reg = )
JSR	>_itoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.106
LDB	#1
BRA	.107
.106:
CLRB
.107:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2B (used reg = )
LDX	#$2B
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 219 	ok(44,strcmp(ltoa(0L),"0")== 0);
LOC	1
.108:
FCC	"0"
FCB	0
LOC	0
; Debug: list * char = .108+0 (used reg = )
LDX	#.108
PSHS	X
; Debug: rootlist long = const 0 (used reg = )
LDD	#0
LDX	#0
; Debug: func () * char = ltoa+0 (used reg = )
JSR	>_ltoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.109
LDB	#1
BRA	.10A
.109:
CLRB
.10A:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2C (used reg = )
LDX	#$2C
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 220 	ok(45,strcmp(ltoa(-100000L),"-100000")== 0);
LOC	1
.10B:
FCC	"-100000"
FCB	0
LOC	0
; Debug: list * char = .10B+0 (used reg = )
LDX	#.10B
PSHS	X
; Debug: rootlist long = const -$186A0 (used reg = )
LDD	#$FFFE
LDX	#$7960
; Debug: func () * char = ltoa+0 (used reg = )
JSR	>_ltoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.10C
LDB	#1
BRA	.10D
.10C:
CLRB
.10D:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2D (used reg = )
LDX	#$2D
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 221 	ok(46,strcmp(ltoa(2147483647L ),"2147483647")== 0);
LOC	1
.10E:
FCC	"2147483647"
FCB	0
LOC	0
; Debug: list * char = .10E+0 (used reg = )
LDX	#.10E
PSHS	X
; Debug: rootlist long = const $7FFFFFFF (used reg = )
LDD	#$7FFF
LDX	#$FFFF
; Debug: func () * char = ltoa+0 (used reg = )
JSR	>_ltoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.10F
LDB	#1
BRA	.110
.10F:
CLRB
.110:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2E (used reg = )
LDX	#$2E
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 222 	ok(47,strcmp(ltoa((-2147483647L-1)),"-2147483648")== 0);
LOC	1
.111:
FCC	"-2147483648"
FCB	0
LOC	0
; Debug: list * char = .111+0 (used reg = )
LDX	#.111
PSHS	X
; Debug: rootlist long = const -$80000000 (used reg = )
LDD	#$8000
LDX	#0
; Debug: func () * char = ltoa+0 (used reg = )
JSR	>_ltoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.112
LDB	#1
BRA	.113
.112:
CLRB
.113:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2F (used reg = )
LDX	#$2F
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 223 	ok(48,strcmp(ultoa(0xFFFFFFFFUL ),"4294967295")== 0);
LOC	1
.114:
FCC	"4294967295"
FCB	0
LOC	0
; Debug: list * char = .114+0 (used reg = )
LDX	#.114
PSHS	X
; Debug: rootlist unsigned long = const $FFFFFFFF (used reg = )
LDD	#$FFFF
LDX	#$FFFF
; Debug: func () * char = ultoa+0 (used reg = )
JSR	>_ultoa
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.115
LDB	#1
BRA	.116
.115:
CLRB
.116:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $30 (used reg = )
LDX	#$30
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 224 	ok(49,strcmp(ltostr(255L,16),"ff")== 0);
LOC	1
.117:
FCC	"ff"
FCB	0
LOC	0
; Debug: list * char = .117+0 (used reg = )
LDX	#.117
PSHS	X
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: rootlist long = const $FF (used reg = )
LDD	#0
LDX	#$FF
; Debug: func () * char = ltostr+0 (used reg = )
JSR	>_ltostr
LEAS	2,S
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.118
LDB	#1
BRA	.119
.118:
CLRB
.119:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $31 (used reg = )
LDX	#$31
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 225 	ok(50,strcmp(ltostr(-255L,2),"-11111111")== 0);
LOC	1
.11A:
FCC	"-11111111"
FCB	0
LOC	0
; Debug: list * char = .11A+0 (used reg = )
LDX	#.11A
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: rootlist long = const -$FF (used reg = )
LDD	#$FFFF
LDX	#$FF01
; Debug: func () * char = ltostr+0 (used reg = )
JSR	>_ltostr
LEAS	2,S
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.11B
LDB	#1
BRA	.11C
.11B:
CLRB
.11C:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $32 (used reg = )
LDX	#$32
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 226 	ok(51,strcmp(ultostr(0xFFFFFFFFUL ,36),"1z141z3")== 0);
LOC	1
.11D:
FCC	"1z141z3"
FCB	0
LOC	0
; Debug: list * char = .11D+0 (used reg = )
LDX	#.11D
PSHS	X
; Debug: list int = const $24 (used reg = )
LDD	#$24
PSHS	D
; Debug: rootlist unsigned long = const $FFFFFFFF (used reg = )
LDD	#$FFFF
LDX	#$FFFF
; Debug: func () * char = ultostr+0 (used reg = )
JSR	>_ultostr
LEAS	2,S
; Debug: rootlist * char = X+0 (used reg = )
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.11E
LDB	#1
BRA	.11F
.11E:
CLRB
.11F:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $33 (used reg = )
LDX	#$33
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 227 	ok(52,ltostr(1L,1)== 0 && ltostr(1L,37)== 0);
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist long = const 1 (used reg = )
LDD	#0
LDX	#1
; Debug: func () * char = ltostr+0 (used reg = )
JSR	>_ltostr
LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
LEAX	0,X
BNE	.120
.122:
; Debug: list int = const $25 (used reg = )
LDD	#$25
PSHS	D
; Debug: rootlist long = const 1 (used reg = )
LDD	#0
LDX	#1
; Debug: func () * char = ltostr+0 (used reg = )
JSR	>_ltostr
LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
LEAX	0,X
BNE	.120
.121:
LDB	#1
BRA	.123
.120:
CLRB
.123:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $34 (used reg = )
LDX	#$34
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 228 }
RTS
; 229 
; 230 
; 231 int icmp(a,b)
; 232 int *a, *b;
EXPORT	_icmp
_icmp:
;BCC_EOS
; 233 {
; 234 	return *a < *b ? -1 : *a > *b;
PSHS	X
; Debug: lt int b = [[S+2+2]] to int a = [[S+2-2]] (used reg = )
LDD	[0,S]
SUBD	[4,S]
BGE	.124
.125:
LDD	#-1
BRA	.126
.124:
; Debug: gt int b = [[S+2+2]] to int a = [[S+2-2]] (used reg = )
LDD	[0,S]
SUBD	[4,S]
BLE	.127
LDB	#1
BRA	.128
.127:
CLRB
.128:
; Debug: cast int = const 0 to char = B+0 (used reg = )
CLRA
.126:
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 235 }
; 236 
; 237 struct rec {
; 238 	char key;
;BCC_EOS
; 239 	long val;
;BCC_EOS
; 240 	char pad;
;BCC_EOS
; 241 };
;BCC_EOS
; 242 
; 243 int rcmp(a,b)
; 244 struct rec *a, *b;
EXPORT	_rcmp
_rcmp:
;BCC_EOS
; 245 {
; 246 	return a->key - b->key;
PSHS	X
; Debug: sub char b = [[S+2+2]] to char a = [[S+2-2]] (used reg = )
LDB	[0,S]
CLRA
SUBB	[4,S]
SBCA	#0
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 247 }
; 248 
; 249 int sorted(a,n)
; 250 int *a, n;
EXPORT	_sorted
_sorted:
;BCC_EOS
; 251 {
; 252 	int i;
;BCC_EOS
; 253 
; 254 	for (i = 1; i < n; i++)
PSHS	D,X
; Debug: eq int = const 1 to int i = [S+4-4] (used reg = )
LDD	#1
STD	0,S
;BCC_EOS
;BCC_EOS
; 255 		if (a[i - 1] > a[i])
BRA	.12B
.12C:
; Debug: ptradd int i = [S+4-4] to * int a = [S+4-2] (used reg = )
LDD	0,S
LSLB
ROLA
ADDD	2,S
TFR	D,X
; Debug: sub int = const 1 to int i = [S+4-4] (used reg = X)
LDD	0,S
; Debug: ptradd int = D-1 to * int a = [S+4-2] (used reg = X)
ADDD	#-1
LSLB
ROLA
ADDD	2,S
TFR	D,U
; Debug: gt int = [X+0] to int = [U+0] (used reg = )
LDU	0,U
CMPU	0,X
BLE	.12D
.12E:
; 256 			return 0;
LDX	#0
PULS	U,Y,PC
;BCC_EOS
; 257 	return 1;
.12D:
.12A:
; Debug: postinc int i = [S+4-4] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
.12B:
; Debug: lt int n = [S+4+2] to int i = [S+4-4] (used reg = )
LDD	0,S
SUBD	6,S
BLT	.12C
.12F:
.129:
LDX	#1
PULS	U,Y,PC
;BCC_EOS
; 258 }
; 259 
; 260 void sorting()
; 261 {
EXPORT	_sorting
_sorting:
; 262 	static int a[] = { 5, -3, 9, 0, 9, 2, -32000, 31000, 1, 7, 3, 3, 8 };
LOC	3
.130:
FDB	5
FDB	$FFFD
FDB	9
FDB	0
FDB	9
FDB	2
FDB	$8300
FDB	$7918
FDB	1
FDB	7
FDB	3
FDB	3
FDB	8
LOC	0
;BCC_EOS
; 263 	static int b[] = { 1 };
LOC	3
.131:
FDB	1
LOC	0
;BCC_EOS
; 264 	static struct rec r[] = {
LOC	3
.132:
; 265 		{ 'm', 1L }, { 'c', 2L }, { 'x', 3L }, { 'a', 4L },
FCB	$6D
FDB	0
FDB	1
RMB	1
FCB	$63
FDB	0
FDB	2
RMB	1
FCB	$78
FDB	0
FDB	3
RMB	1
FCB	$61
FDB	0
FDB	4
RMB	1
; 266 		{ 'q', 5L }, { 'b', 6L }, { 'z', 7L }
FCB	$71
FDB	0
FDB	5
RMB	1
FCB	$62
FDB	0
FDB	6
RMB	1
FCB	$7A
FDB	0
FDB	7
RMB	1
; 267 	};
LOC	0
;BCC_EOS
; 268 	int n = sizeof(a) / sizeof(a[0]), i, key, *p;
LEAS	-2,S
; Debug: eq int = const $D to int n = [S+2-2] (used reg = )
LDD	#$D
STD	0,S
;BCC_EOS
; 269 	int c[50];
;BCC_EOS
; 270 	struct rec k, *rp;
;BCC_EOS
; 271 
; 272 	qsort(a,n,sizeof(a[0]),icmp);
LEAS	-$72,S
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int n = [S+$78-2] (used reg = )
LDD	$76,S
PSHS	D
; Debug: rootlist * int = .130+0 (used reg = )
LDX	#.130
; Debug: func () void = qsort+0 (used reg = )
JSR	>_qsort
LEAS	6,S
;BCC_EOS
; 273 	ok(60,sorted(a,n));
; Debug: list int n = [S+$74-2] (used reg = )
LDD	$72,S
PSHS	D
; Debug: rootlist * int = .130+0 (used reg = )
LDX	#.130
; Debug: func () int = sorted+0 (used reg = )
JSR	>_sorted
LEAS	2,S
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $3C (used reg = )
LDX	#$3C
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 274 	for (i = 0; i < n; i++)
; Debug: eq int = const 0 to int i = [S+$74-4] (used reg = )
LDD	#0
STD	$70,S
;BCC_EOS
;BCC_EOS
; 275 		putnum(a[i]);
BRA	.135
.136:
; Debug: ptradd int i = [S+$74-4] to [$D] int = .130+0 (used reg = )
LDD	$70,S
LSLB
ROLA
LDX	#.130
LEAX	D,X
; Debug: rootlist int = [X+0] (used reg = )
LDX	0,X
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 276 	qsort(b,1,sizeof(b[0]),icmp);
.134:
; Debug: postinc int i = [S+$74-4] (used reg = )
LDD	$70,S
ADDD	#1
STD	$70,S
.135:
; Debug: lt int n = [S+$74-2] to int i = [S+$74-4] (used reg = )
LDD	$70,S
SUBD	$72,S
BLT	.136
.137:
.133:
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist * int = .131+0 (used reg = )
LDX	#.131
; Debug: func () void = qsort+0 (used reg = )
JSR	>_qsort
LEAS	6,S
;BCC_EOS
; 277 	ok(61,b[0] == 1);
; Debug: logeq int = const 1 to int = [.131+0] (used reg = )
LDX	>.131
LEAX	-1,X
BNE	.138
LDB	#1
BRA	.139
.138:
CLRB
.139:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $3D (used reg = )
LDX	#$3D
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 278 	qsort(b,0,sizeof(b[0]),icmp);
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: rootlist * int = .131+0 (used reg = )
LDX	#.131
; Debug: func () void = qsort+0 (used reg = )
JSR	>_qsort
LEAS	6,S
;BCC_EOS
; 279 	ok(62,b[0] == 1);
; Debug: logeq int = const 1 to int = [.131+0] (used reg = )
LDX	>.131
LEAX	-1,X
BNE	.13A
LDB	#1
BRA	.13B
.13A:
CLRB
.13B:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $3E (used reg = )
LDX	#$3E
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 280 
; 281 	 
; 282 	for (i = 0; i < 50; i++)
; Debug: eq int = const 0 to int i = [S+$74-4] (used reg = )
LDD	#0
STD	$70,S
;BCC_EOS
;BCC_EOS
; 283 		
; 283 c[i] = i;
BRA	.13E
.13F:
; Debug: ptradd int i = [S+$74-4] to [$32] int c = S+$74-$6C (used reg = )
LDD	$70,S
LSLB
ROLA
LEAX	D,S
; Debug: eq int i = [S+$74-4] to int = [X+8] (used reg = )
LDD	$70,S
STD	8,X
;BCC_EOS
; 284 	qsort(c,50,sizeof(c[0]),icmp);
.13D:
; Debug: postinc int i = [S+$74-4] (used reg = )
LDD	$70,S
ADDD	#1
STD	$70,S
.13E:
; Debug: lt int = const $32 to int i = [S+$74-4] (used reg = )
LDD	$70,S
SUBD	#$32
BLT	.13F
.140:
.13C:
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const $32 (used reg = )
LDD	#$32
PSHS	D
; Debug: rootlist * int c = S+$7A-$6C (used reg = )
LEAX	$E,S
; Debug: func () void = qsort+0 (used reg = )
JSR	>_qsort
LEAS	6,S
;BCC_EOS
; 285 	ok(63,sorted(c,50)&& c[0] == 0 && c[49] == 49);
; Debug: list int = const $32 (used reg = )
LDD	#$32
PSHS	D
; Debug: rootlist * int c = S+$76-$6C (used reg = )
LEAX	$A,S
; Debug: func () int = sorted+0 (used reg = )
JSR	>_sorted
LEAS	2,S
LEAX	0,X
BEQ	.141
.144:
; Debug: logeq int = const 0 to int c = [S+$74-$6C] (used reg = )
LDD	8,S
BNE	.141
.143:
; Debug: logeq int = const $31 to int c = [S+$74-$A] (used reg = )
LDX	$6A,S
LEAX	-$31,X
BNE	.141
.142:
LDB	#1
BRA	.145
.141:
CLRB
.145:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $3F (used reg = )
LDX	#$3F
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 286 	for (i = 0; i < 50; i++)
; Debug: eq int = const 0 to int i = [S+$74-4] (used reg = )
LDD	#0
STD	$70,S
;BCC_EOS
;BCC_EOS
; 287 		c[i] = 50 - i;
BRA	.148
.149:
; Debug: sub int i = [S+$74-4] to int = const $32 (used reg = )
LDD	#$32
SUBD	$70,S
PSHS	D
; Debug: ptradd int i = [S+$76-4] to [$32] int c = S+$76-$6C (used reg = )
LDD	$72,S
LSLB
ROLA
LEAX	D,S
; Debug: eq int (temp) = [S+$76-$76] to int = [X+$A] (used reg = )
LDD	,S++
STD	$A,X
;BCC_EOS
; 288 	qsort(c,50,sizeof(c[0]),icmp);
.147:
; Debug: postinc int i = [S+$74-4] (used reg = )
LDD	$70,S
ADDD	#1
STD	$70,S
.148:
; Debug: lt int = const $32 to int i = [S+$74-4] (used reg = )
LDD	$70,S
SUBD	#$32
BLT	.149
.14A:
.146:
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const $32 (used reg = )
LDD	#$32
PSHS	D
; Debug: rootlist * int c = S+$7A-$6C (used reg = )
LEAX	$E,S
; Debug: func () void = qsort+0 (used reg = )
JSR	>_qsort
LEAS	6,S
;BCC_EOS
; 289 	ok(64,sorted(c,50)&& c[0] == 1 && c[49] == 50);
; Debug: list int = const $32 (used reg = )
LDD	#$32
PSHS	D
; Debug: rootlist * int c = S+$76-$6C (used reg = )
LEAX	$A,S
; Debug: func () int = sorted+0 (used reg = )
JSR	>_sorted
LEAS	2,S
LEAX	0,X
BEQ	.14B
.14E:
; Debug: logeq int = const 1 to int c = [S+$74-$6C] (used reg = )
LDX	8,S
LEAX	-1,X
BNE	.14B
.14D:
; Debug: logeq int = const $32 to int c = [S+$74-$A] (used reg = )
LDX	$6A,S
LEAX	-$32,X
BNE	.14B
.14C:
LDB	#1
BRA	.14F
.14B:
CLRB
.14F:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $40 (used reg = )
LDX	#$40
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 290 	for (i = 0; i < 50; i++)
; Debug: eq int = const 0 to int i = [S+$74-4] (used reg = )
LDD	#0
STD	$70,S
;BCC_EOS
;BCC_EOS
; 291 		c[i] = 4;
BRA	.152
.153:
; Debug: ptradd int i = [S+$74-4] to [$32] int c = S+$74-$6C (used reg = )
LDD	$70,S
LSLB
ROLA
LEAX	D,S
; Debug: eq int = const 4 to int = [X+8] (used reg = )
LDD	#4
STD	8,X
;BCC_EOS
; 292 	qsort(c,50,sizeof(c[0]),icmp);
.151:
; Debug: postinc int i = [S+$74-4] (used reg = )
LDD	$70,S
ADDD	#1
STD	$70,S
.152:
; Debug: lt int = const $32 to int i = [S+$74-4] (used reg = )
LDD	$70,S
SUBD	#$32
BLT	.153
.154:
.150:
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const $32 (used reg = )
LDD	#$32
PSHS	D
; Debug: rootlist * int c = S+$7A-$6C (used reg = )
LEAX	$E,S
; Debug: func () void = qsort+0 (used reg = )
JSR	>_qsort
LEAS	6,S
;BCC_EOS
; 293 	ok(65,c[0] == 4 && c[49] == 4);
; Debug: logeq int = const 4 to int c = [S+$74-$6C] (used reg = )
LDX	8,S
LEAX	-4,X
BNE	.155
.157:
; Debug: logeq int = const 4 to int c = [S+$74-$A] (used reg = )
LDX	$6A,S
LEAX	-4,X
BNE	.155
.156:
LDB	#1
BRA	.158
.155:
CLRB
.158:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $41 (used reg = )
LDX	#$41
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 294 
; 295 	 
; 296 	qsort(r,7,sizeof(r[0]),rcmp);
; Debug: cast * () int = const 0 to () int = rcmp+0 (used reg = )
; Debug: list * () int = rcmp+0 (used reg = )
LDX	#_rcmp
PSHS	X
; Debug: list int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: list int = const 7 (used reg = )
LDD	#7
PSHS	D
; Debug: rootlist * struct rec = .132+0 (used reg = )
LDX	#.132
; Debug: func () void = qsort+0 (used reg = )
JSR	>_qsort
LEAS	6,S
;BCC_EOS
; 297 	for (i = 0; i < 7; i++)
; Debug: eq int = const 0 to int i = [S+$74-4] (used reg = )
LDD	#0
STD	$70,S
;BCC_EOS
;BCC_EOS
; 298 		putchar(r[i].key);
BRA	.15B
.15C:
; Debug: ptradd int i = [S+$74-4] to [7] struct rec = .132+0 (used reg = )
LDD	$70,S
PSHS	D
LSLB
ROLA
ADDD	,S++
LSLB
ROLA
LDX	#.132
LEAX	D,X
; Debug: rootlist char = [X+0] (used reg = )
LDB	0,X
CLRA
TFR	D,X
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 299 	putchar('\n');
.15A:
; Debug: postinc int i = [S+$74-4] (used reg = )
LDD	$70,S
ADDD	#1
STD	$70,S
.15B:
; Debug: lt int = const 7 to int i = [S+$74-4] (used reg = )
LDD	$70,S
SUBD	#7
BLT	.15C
.15D:
.159:
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 300 	ok(66,r[0].val == 4L && r[6].val == 7L && r[3].val == 1L);
; Debug: logeq long = const 4 to long = [.132+1] (used reg = )
; Debug: expression subtree swapping
LDD	#0
LDX	#4
PSHS	D,X
LDD	>.132+1
LDX	>.132+3
LEAY	0,S
JSR	>lcmp_b
LEAS	4,S
BNE	.15E
.161:
; Debug: logeq long = const 7 to long = [.132+$25] (used reg = )
; Debug: expression subtree swapping
LDD	#0
LDX	#7
PSHS	D,X
LDD	>.132+$25
LDX	>.132+$27
LEAY	0,S
JSR	>lcmp_b
LEAS	4,S
BNE	.15E
.160:
; Debug: logeq long = const 1 to long = [.132+$13] (used reg = )
; Debug: expression subtree swapping
LDD	#0
LDX	#1
PSHS	D,X
LDD	>.132+$13
LDX	>.132+$15
LEAY	0,S
JSR	>lcmp_b
LEAS	4,S
BNE	.15E
.15F:
LDB	#1
BRA	.162
.15E:
CLRB
.162:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $42 (used reg = )
LDX	#$42
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 301 
; 302 	for (i = 0; i < n; i++) {
; Debug: eq int = const 0 to int i = [S+$74-4] (used reg = )
LDD	#0
STD	$70,S
;BCC_EOS
;BCC_EOS
BRA	.165
.166:
; 303 		key = a[i];
; Debug: ptradd int i = [S+$74-4] to [$D] int = .130+0 (used reg = )
LDD	$70,S
LSLB
ROLA
LDX	#.130
LEAX	D,X
; Debug: eq int = [X+0] to int key = [S+$74-6] (used reg = )
LDX	0,X
STX	$6E,S
;BCC_EOS
; 304 		p = (int *) bsearch(&key,a,n,sizeof(a[0]),icmp);
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int n = [S+$78-2] (used reg = )
LDD	$76,S
PSHS	D
; Debug: list * int = .130+0 (used reg = )
LDX	#.130
PSHS	X
; Debug: rootlist * int key = S+$7C-6 (used reg = )
LEAX	$76,S
; Debug: func () * void = bsearch+0 (used reg = )
JSR	>_bsearch
LEAS	8,S
; Debug: cast * int = const 0 to * void = X+0 (used reg = )
; Debug: eq * int = X+0 to * int p = [S+$74-8] (used reg = )
STX	$6C,S
;BCC_EOS
; 305 		ok(70 + i,p != 0 && *p == key);
; Debug: ne int = const 0 to * int p = [S+$74-8] (used reg = )
LDD	$6C,S
BEQ	.167
.169:
; Debug: logeq int key = [S+$74-6] to int p = [[S+$74-8]] (used reg = )
LDD	[$6C,S]
SUBD	$6E,S
BNE	.167
.168:
LDB	#1
BRA	.16A
.167:
CLRB
.16A:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: add int i = [S+$76-4] to int = const $46 (used reg = )
; Debug: expression subtree swapping
LDD	$72,S
; Debug: rootlist int = D+$46 (used reg = )
ADDD	#$46
TFR	D,X
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 306 	}
; 307 	key = 4;
.164:
; Debug: postinc int i = [S+$74-4] (used reg = )
LDD	$70,S
ADDD	#1
STD	$70,S
.165:
; Debug: lt int n = [S+$74-2] to int i = [S+$74-4] (used reg = )
LDD	$70,S
SUBD	$72,S
BLT	.166
.16B:
.163:
; Debug: eq int = const 4 to int key = [S+$74-6] (used reg = )
LDD	#4
STD	$6E,S
;BCC_EOS
; 308 	ok(90,bsearch(&key,a,n,sizeof(a[0]),icmp)== 0);
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int n = [S+$78-2] (used reg = )
LDD	$76,S
PSHS	D
; Debug: list * int = .130+0 (used reg = )
LDX	#.130
PSHS	X
; Debug: rootlist * int key = S+$7C-6 (used reg = )
LEAX	$76,S
; Debug: func () * void = bsearch+0 (used reg = )
JSR	>_bsearch
LEAS	8,S
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
LEAX	0,X
BNE	.16C
LDB	#1
BRA	.16D
.16C:
CLRB
.16D:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $5A (used reg = )
LDX	#$5A
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 309 	key = -32001;
; Debug: eq int = const -$7D01 to int key = [S+$74-6] (used reg = )
LDD	#-$7D01
STD	$6E,S
;BCC_EOS
; 310 	ok(91,bsearch(&key,a,n,sizeof(a[0]),icmp)== 0);
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int n = [S+$78-2] (used reg = )
LDD	$76,S
PSHS	D
; Debug: list * int = .130+0 (used reg = )
LDX	#.130
PSHS	X
; Debug: rootlist * int key = S+$7C-6 (used reg = )
LEAX	$76,S
; Debug: func () * void = bsearch+0 (used reg = )
JSR	>_bsearch
LEAS	8,S
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
LEAX	0,X
BNE	.16E
LDB	#1
BRA	.16F
.16E:
CLRB
.16F:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $5B (used reg = )
LDX	#$5B
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 311 	key = 1;
; Debug: eq int = const 1 to int key = [S+$74-6] (used reg = )
LDD	#1
STD	$6E,S
;BCC_EOS
; 312 	ok(92,bsearch(&key,a,0,sizeof(a[0]),icmp)== 0);
; Debug: cast * () int = const 0 to () int = icmp+0 (used reg = )
; Debug: list * () int = icmp+0 (used reg = )
LDX	#_icmp
PSHS	X
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 0 (used reg = )
LDD	#0
PSHS	D
; Debug: list * int = .130+0 (used reg = )
LDX	#.130
PSHS	X
; Debug: rootlist * int key = S+$7C-6 (used reg = )
LEAX	$76,S
; Debug: func () * void = bsearch+0 (used reg = )
JSR	>_bsearch
LEAS	8,S
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
LEAX	0,X
BNE	.170
LDB	#1
BRA	.171
.170:
CLRB
.171:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $5C (used reg = )
LDX	#$5C
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 313 	k.key = 'q';
; Debug: eq int = const $71 to char k = [S+$74-$72] (used reg = )
LDB	#$71
STB	2,S
;BCC_EOS
; 314 	rp = (struct rec *) bsearch(&k,r,7,sizeof(r[0]),rcmp);
; Debug: cast * () int = const 0 to () int = rcmp+0 (used reg = )
; Debug: list * () int = rcmp+0 (used reg = )
LDX	#_rcmp
PSHS	X
; Debug: list int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: list int = const 7 (used reg = )
LDD	#7
PSHS	D
; Debug: list * struct rec = .132+0 (used reg = )
LDX	#.132
PSHS	X
; Debug: rootlist * struct rec k = S+$7C-$72 (used reg = )
LEAX	$A,S
; Debug: func () * void = bsearch+0 (used reg = )
JSR	>_bsearch
LEAS	8,S
; Debug: cast * struct rec = const 0 to * void = X+0 (used reg = )
; Debug: eq * struct rec = X+0 to * struct rec rp = [S+$74-$74] (used reg = )
STX	0,S
;BCC_EOS
; 315 	ok(93,rp != 0 && rp->val == 5L);
; Debug: ne int = const 0 to * struct rec rp = [S+$74-$74] (used reg = )
LDD	0,S
BEQ	.172
.174:
LDX	0,S
; Debug: logeq long = const 5 to long = [X+1] (used reg = )
; Debug: expression subtree swapping
LDD	#0
LDU	#5
PSHS	D,U
LDD	1,X
LDX	3,X
LEAY	0,S
JSR	>lcmp_b
LEAS	4,S
BNE	.172
.173:
LDB	#1
BRA	.175
.172:
CLRB
.175:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $5D (used reg = )
LDX	#$5D
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 316 }
LEAS	$74,S
RTS
; 317 
; 318 void randoms()
; 319 {
EXPORT	_randoms
_randoms:
; 320 	int i, x, first[5], good;
;BCC_EOS
; 321 
; 322 	srand(1);
LEAS	-$10,S
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () void = srand+0 (used reg = )
JSR	>_srand
;BCC_EOS
; 323 	good = 1;
; Debug: eq int = const 1 to int good = [S+$10-$10] (used reg = )
LDD	#1
STD	0,S
;BCC_EOS
; 324 	for (i = 0; i < 5; i++) {
; Debug: eq int = const 0 to int i = [S+$10-2] (used reg = )
LDD	#0
STD	$E,S
;BCC_EOS
;BCC_EOS
BRA	.178
.179:
; 325 		first[i] = rand();
; Debug: func () int = rand+0 (used reg = )
JSR	>_rand
; Debug: ptradd int i = [S+$10-2] to [5] int first = S+$10-$E (used reg = X)
LDD	$E,S
LSLB
ROLA
LEAU	D,S
; Debug: eq int = X+0 to int = [U+2] (used reg = )
STX	2,U
;BCC_EOS
; 326 		if (first[i] < 0 || first[i] > 32767 )
; Debug: ptradd int i = [S+$10-2] to [5] int first = S+$10-$E (used reg = )
LDD	$E,S
LSLB
ROLA
LEAX	D,S
; Debug: lt int = const 0 to int = [X+2] (used reg = )
LDD	2,X
BLT	.17B
.17C:
; Debug: ptradd int i = [S+$10-2] to [5] int first = S+$10-$E (used reg = )
LDD	$E,S
LSLB
ROLA
LEAX	D,S
; Debug: gt int = const $7FFF to int = [X+2] (used reg = )
LDX	2,X
CMPX	#$7FFF
BLE	.17A
.17B:
; 327 			good = 0;
; Debug: eq int = const 0 to int good = [S+$10-$10] (used reg = )
LDD	#0
STD	0,S
;BCC_EOS
; 328 	}
.17A:
; 329 	ok(100,good);
.177:
; Debug: postinc int i = [S+$10-2] (used reg = )
LDD	$E,S
ADDD	#1
STD	$E,S
.178:
; Debug: lt int = const 5 to int i = [S+$10-2] (used reg = )
LDD	$E,S
SUBD	#5
BLT	.179
.17D:
.176:
; Debug: list int good = [S+$10-$10] (used reg = )
LDD	0,S
PSHS	D
; Debug: rootlist int = const $64 (used reg = )
LDX	#$64
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 330 	srand(1);
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () void = srand+0 (used reg = )
JSR	>_srand
;BCC_EOS
; 331 	for (i = 0; i < 5; i++)
; Debug: eq int = const 0 to int i = [S+$10-2] (used reg = )
LDD	#0
STD	$E,S
;BCC_EOS
;BCC_EOS
; 332 		if (rand()!= first[i])
BRA	.180
.181:
; Debug: expression subtree swapping
; Debug: func () int = rand+0 (used reg = )
JSR	>_rand
; Debug: ptradd int i = [S+$10-2] to [5] int first = S+$10-$E (used reg = X)
LDD	$E,S
LSLB
ROLA
LEAU	D,S
; Debug: ne int = X+0 to int = [U+2] (used reg = )
CMPX	2,U
BEQ	.182
.183:
; 333 			good = 0;
; Debug: eq int = const 0 to int good = [S+$10-$10] (used reg = )
LDD	#0
STD	0,S
;BCC_EOS
; 334 	ok(101,good);			 
.182:
.17F:
; Debug: postinc int i = [S+$10-2] (used reg = )
LDD	$E,S
ADDD	#1
STD	$E,S
.180:
; Debug: lt int = const 5 to int i = [S+$10-2] (used reg = )
LDD	$E,S
SUBD	#5
BLT	.181
.184:
.17E:
; Debug: list int good = [S+$10-$10] (used reg = )
LDD	0,S
PSHS	D
; Debug: rootlist int = const $65 (used reg = )
LDX	#$65
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 335 
; 336 	 
; 337 	ok(102,first[0] == 16838 && first[1] == 5758 && first[2] == 10113);
; Debug: logeq int = const $41C6 to int first = [S+$10-$E] (used reg = )
LDD	2,S
SUBD	#$41C6
BNE	.185
.188:
; Debug: logeq int = const $167E to int first = [S+$10-$C] (used reg = )
LDD	4,S
SUBD	#$167E
BNE	.185
.187:
; Debug: logeq int = const $2781 to int first = [S+$10-$A] (used reg = )
LDD	6,S
SUBD	#$2781
BNE	.185
.186:
LDB	#1
BRA	.189
.185:
CLRB
.189:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $66 (used reg = )
LDX	#$66
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 338 
; 339 	srand(2);
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () void = srand+0 (used reg = )
JSR	>_srand
;BCC_EOS
; 340 	x = rand();
; Debug: func () int = rand+0 (used reg = )
JSR	>_rand
; Debug: eq int = X+0 to int x = [S+$10-4] (used reg = )
STX	$C,S
;BCC_EOS
; 341 	ok(103,x != first[0]);
; Debug: ne int first = [S+$10-$E] to int x = [S+$10-4] (used reg = )
LDD	$C,S
SUBD	2,S
BEQ	.18A
LDB	#1
BRA	.18B
.18A:
CLRB
.18B:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $67 (used reg = )
LDX	#$67
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 342 }
LEAS	$10,S
RTS
; 343 
; 344 int main()
; 345 {
EXPORT	_main
_main:
; 346 	classes();
; Debug: func () void = classes+0 (used reg = )
JSR	>_classes
;BCC_EOS
; 347 	cases();
; Debug: func () void = cases+0 (used reg = )
JSR	>_cases
;BCC_EOS
; 348 	numbers();
; Debug: func () void = numbers+0 (used reg = )
JSR	>_numbers
;BCC_EOS
; 349 
; 350 	strings();
; Debug: func () void = strings+0 (used reg = )
JSR	>_strings
;BCC_EOS
; 351 
; 352 	sorting();
; Debug: func () void = sorting+0 (used reg = )
JSR	>_sorting
;BCC_EOS
; 353 	randoms();
; Debug: func () void = randoms+0 (used reg = )
JSR	>_randoms
;BCC_EOS
; 354 	say("checks ");
LOC	1
.18C:
FCC	"checks "
FCB	0
LOC	0
; Debug: rootlist * char = .18C+0 (used reg = )
LDX	#.18C
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 355 	putnum(checks);
; Debug: rootlist int = [checks+0] (used reg = )
LDX	>_checks
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 356 	say("failures ");
LOC	1
.18D:
FCC	"failures "
FCB	0
LOC	0
; Debug: rootlist * char = .18D+0 (used reg = )
LDX	#.18D
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 357 	putnum(failures);
; Debug: rootlist int = [failures+0] (used reg = )
LDX	>_failures
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 358 	return failures;
LDX	>_failures
RTS
;BCC_EOS
; 359 }
; 360 
LOC	3
_checks		COMM	2
_failures		COMM	2
; 0 errors detected
