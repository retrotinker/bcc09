; 1 
; 1 # 1 "vatest.c"
; 1 
; 2 
; 3  
; 4 # 18 "../prefix.tmp/share/bcc09/include/stdarg.h"
; 18  
; 19 # 23
; 23 typedef char *va_list;
;BCC_EOS
; 24 # 7 "vatest.c"
; 7 extern int putchar();
;BCC_EOS
; 8 extern void putnum();
;BCC_EOS
; 9 
; 10 int checks, failures;
;BCC_EOS
; 11 
; 12 void say(s)
; 13 char *s;
EXPORT	_say
_say:
;BCC_EOS
; 14 {
; 15 	while (*s)
PSHS	X
; 16 		putchar(*s++);
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
; 17 }
.2:
LDB	[0,S]
BNE	.3
.4:
.1:
PULS	Y,PC
; 18 
; 19 void ok(n,cond)
; 20 int n, cond;
EXPORT	_ok
_ok:
;BCC_EOS
; 21 {
; 22 	++checks;
PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
LDD	>_checks
ADDD	#1
STD	>_checks
;BCC_EOS
; 23 	if (!cond) {
LDD	4,S
BNE	.5
.6:
; 24 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
LDD	>_failures
ADDD	#1
STD	>_failures
;BCC_EOS
; 25 		say("FAIL ");
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
; 26 		putnum(n);
; Debug: rootlist int n = [S+2-2] (used reg = )
LDX	0,S
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 27 	}
; 28 }
.5:
PULS	Y,PC
; 29 
; 30 void putlong(l)
; 31 long l;
EXPORT	_putlong
_putlong:
;BCC_EOS
; 32 {
; 33 	char buf[12];
;BCC_EOS
; 34 	char *p = buf + sizeof(buf);
PSHS	D,X
LEAS	-$E,S
; Debug: eq [$C] char buf = S+$12-4 to * char p = [S+$12-$12] (used reg = )
LEAX	$E,S
STX	0,S
;BCC_EOS
; 35 	unsigned long u = l;
LEAS	-4,S
; Debug: eq long l = [S+$16-4] to unsigned long u = [S+$16-$16] (used reg = )
LDD	$12,S
LDX	$14,S
STD	0,S
STX	2,S
;BCC_EOS
; 36 
; 37 	if (l < 0)
; Debug: lt long = const 0 to long l = [S+$16-4] (used reg = )
CLRA
CLRB
TFR	D,X
LEAY	$12,S
JSR	>lcmp_b
BLE	.8
.9:
; 38 		u = -u;
; Debug: neg unsigned long u = [S+$16-$16] (used reg = )
LDD	0,S
LDX	2,S
JSR	>lneg_b
; Debug: eq unsigned long = X+0 to unsigned long u = [S+$16-$16] (used reg = )
STD	0,S
STX	2,S
;BCC_EOS
; 39 	*--p = 0;
.8:
; Debug: predec * char p = [S+$16-$12] (used reg = )
LDX	4,S
LEAX	-1,X
STX	4,S
; Debug: eq int = const 0 to char = [X+0] (used reg = )
CLRB
STB	0,X
;BCC_EOS
; 40 	do {
.C:
; 41 		*--p = '0' + (int) (u % 10);
; Debug: mod unsigned long = const $A to unsigned long u = [S+$16-$16] (used reg = )
CLRA
CLRB
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
; 42 		u /= 10;
; Debug: divab unsigned long = const $A to unsigned long u = [S+$16-$16] (used reg = )
CLRA
CLRB
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
; 43 	} while (u);
.B:
LDD	0,S
LDX	2,S
JSR	>ltst_b
BNE	.C
.D:
;BCC_EOS
; 44 	if (l < 0)
.A:
; Debug: lt long = const 0 to long l = [S+$16-4] (used reg = )
CLRA
CLRB
TFR	D,X
LEAY	$12,S
JSR	>lcmp_b
BLE	.E
.F:
; 45 		*--p = '-';
; Debug: predec * char p = [S+$16-$12] (used reg = )
LDX	4,S
LEAX	-1,X
STX	4,S
; Debug: eq int = const $2D to char = [X+0] (used reg = )
LDB	#$2D
STB	0,X
;BCC_EOS
; 46 	say(p);
.E:
; Debug: rootlist * char p = [S+$16-$12] (used reg = )
LDX	4,S
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 47 	putchar('\n');
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 48 }
LEAS	$16,S
RTS
; 49 
; 50  
; 51 int sum(n,__va_alist) __proto(int n,...)
; 52 # 51 "vatest.c"
; 51 int n;
EXPORT	_sum
_sum:
;BCC_EOS
; 52 {
; 53 	va_list ap;
;BCC_EOS
; 54 	int t = 0;
PSHS	CC,D,X,DP
; Debug: eq int = const 0 to int t = [S+6-6] (used reg = )
CLRA
CLRB
STD	0,S
;BCC_EOS
; 55 
; 56 	((ap)= (char *)&__va_alist) ;
; Debug: eq * char __va_alist = S+6+2 to * char ap = [S+6-4] (used reg = )
LEAX	8,S
STX	2,S
;BCC_EOS
; 57 	while (n-- > 0)
; 58 		t += (((int *)((ap)+= sizeof(int)))[-1]) ;
BRA	.11
.12:
; Debug: ptraddab int = const 2 to * char ap = [S+6-4] (used reg = )
LDX	2,S
LEAX	2,X
STX	2,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: addab int = [X-2] to int t = [S+6-6] (used reg = )
LDD	0,S
ADDD	-2,X
STD	0,S
;BCC_EOS
; 59 	 ;
.11:
; Debug: postdec int n = [S+6-2] (used reg = )
LDD	4,S
ADDD	#-1
STD	4,S
; Debug: gt int = const 0 to int = D+1 (used reg = )
ADDD	#1
SUBD	#0
BGT	.12
.13:
.10:
;BCC_EOS
; 60 	return t;
LDX	0,S
LEAS	6,S
RTS
;BCC_EOS
; 61 }
; 62 
; 63 long lsum(n,__va_alist) __proto(int n,...)
; 64 # 63 "vatest.c"
; 63 int n;
EXPORT	_lsum
_lsum:
;BCC_EOS
; 64 {
; 65 	va_list ap;
;BCC_EOS
; 66 	long t = 0;
PSHS	X
LEAS	-6,S
; Debug: eq int = const 0 to long t = [S+8-8] (used reg = )
CLRA
CLRB
TFR	D,X
STD	0,S
STX	2,S
;BCC_EOS
; 67 
; 68 	((ap)= (char *)&__va_alist) ;
; Debug: eq * char __va_alist = S+8+2 to * char ap = [S+8-4] (used reg = )
LEAX	$A,S
STX	4,S
;BCC_EOS
; 69 	while (n-- > 0)
; 70 		t += (((long *)((ap)+= sizeof(long)))[-1]) ;
BRA	.15
.16:
; Debug: ptraddab int = const 4 to * char ap = [S+8-4] (used reg = )
LDX	4,S
LEAX	4,X
STX	4,S
; Debug: cast * long = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * long = X+0 (used reg = )
; Debug: addab long = [X-4] to long t = [S+8-8] (used reg = )
LDD	-4,X
LDX	-2,X
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>ladd_b
STD	4,S
STX	6,S
LEAS	4,S
;BCC_EOS
; 71 	 ;
.15:
; Debug: postdec int n = [S+8-2] (used reg = )
LDD	6,S
ADDD	#-1
STD	6,S
; Debug: gt int = const 0 to int = D+1 (used reg = )
ADDD	#1
SUBD	#0
BGT	.16
.17:
.14:
;BCC_EOS
; 72 	return t;
LDD	0,S
LDX	2,S
LEAS	8,S
RTS
;BCC_EOS
; 73 }
; 74 
; 75  
; 76 int two(a,b,__va_alist) __proto(int a,int b,...)
; 77 # 76 "vatest.c"
; 76 int a;
EXPORT	_two
_two:
;BCC_EOS
; 77 # 76 "vatest.c"
; 76 int b;
;BCC_EOS
; 77 {
; 78 	va_list ap;
;BCC_EOS
; 79 	int t = a * 1000 + b * 100, x;
PSHS	CC,D,X,DP
; Debug: mul int = const $64 to int b = [S+6+2] (used reg = )
LDD	8,S
PSHS	D
LSLB
ROLA
ADDD	,S
LSLB
ROLA
LSLB
ROLA
LSLB
ROLA
ADDD	,S++
LSLB
ROLA
LSLB
ROLA
PSHS	D
; Debug: mul int = const $3E8 to int a = [S+8-2] (used reg = )
LDD	6,S
PSHS	D
LSLB
ROLA
LSLB
ROLA
LSLB
ROLA
LSLB
ROLA
LSLB
ROLA
SUBD	,S
LSLB
ROLA
LSLB
ROLA
ADDD	,S++
LSLB
ROLA
LSLB
ROLA
LSLB
ROLA
; Debug: add int (temp) = [S+8-8] to int = D+0 (used reg = )
ADDD	,S++
; Debug: eq int = D+0 to int t = [S+6-6] (used reg = )
STD	0,S
;BCC_EOS
; 80 
; 81 	((ap)= (char *)&__va_alist) ;
LEAS	-2,S
; Debug: eq * char __va_alist = S+8+4 to * char ap = [S+8-4] (used reg = )
LEAX	$C,S
STX	4,S
;BCC_EOS
; 82 	while ((x = (((int *)((ap)+= sizeof(int)))[-1]))!= 0)
; 83 		t += x;
BRA	.19
.1A:
; Debug: addab int x = [S+8-8] to int t = [S+8-6] (used reg = )
LDD	2,S
ADDD	0,S
STD	2,S
;BCC_EOS
; 84 	 ;
.19:
; Debug: ptraddab int = const 2 to * char ap = [S+8-4] (used reg = )
LDX	4,S
LEAX	2,X
STX	4,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: eq int = [X-2] to int x = [S+8-8] (used reg = )
LDX	-2,X
STX	0,S
; Debug: ne int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.1A
.1B:
.18:
;BCC_EOS
; 85 	return t;
LDX	2,S
LEAS	8,S
RTS
;BCC_EOS
; 86 }
; 87 
; 88  
; 89 long lfirst(base,__va_alist) __proto(long base,...)
; 90 # 89 "vatest.c"
; 89 long base;
EXPORT	_lfirst
_lfirst:
;BCC_EOS
; 90 {
; 91 	va_list ap;
;BCC_EOS
; 92 	int x;
;BCC_EOS
; 93 
; 94 	((ap)= (char *)&__va_alist) ;
PSHS	D,X
LEAS	-4,S
; Debug: eq * char __va_alist = S+8+2 to * char ap = [S+8-6] (used reg = )
LEAX	$A,S
STX	2,S
;BCC_EOS
; 95 	while ((x = (((int *)((ap)+= sizeof(int)))[-1]))!= 0)
; 96 		base += x;
BRA	.1D
.1E:
; Debug: cast long = const 0 to int x = [S+8-8] (used reg = )
LDD	0,S
TFR	D,X
CLRB
ROLA
SBCB	#0
SEX
; Debug: addab long = X+0 to long base = [S+8-4] (used reg = )
LEAY	4,S
JSR	>ladd_b
STD	4,S
STX	6,S
;BCC_EOS
; 97 	 ;
.1D:
; Debug: ptraddab int = const 2 to * char ap = [S+8-6] (used reg = )
LDX	2,S
LEAX	2,X
STX	2,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: eq int = [X-2] to int x = [S+8-8] (used reg = )
LDX	-2,X
STX	0,S
; Debug: ne int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.1E
.20:
.1C:
;BCC_EOS
; 98 	return base;
LDD	4,S
LDX	6,S
LEAS	8,S
RTS
;BCC_EOS
; 99 }
; 100 
; 101 int cfirst(c,__va_alist) __proto(char c,...)
; 102 # 101 "vatest.c"
; 101 char c;
EXPORT	_cfirst
_cfirst:
;BCC_EOS
; 102 {
; 103 	va_list ap;
;BCC_EOS
; 104 	int t = c, x;
PSHS	CC,D,X,DP
; Debug: eq char c = [S+6-1] to int t = [S+6-6] (used reg = )
LDB	5,S
CLRA
STD	0,S
;BCC_EOS
; 105 
; 106 	((ap)= (char *)&__va_alist) ;
LEAS	-2,S
; Debug: eq * char __va_alist = S+8+2 to * char ap = [S+8-4] (used reg = )
LEAX	$A,S
STX	4,S
;BCC_EOS
; 107 	while ((x = (((int *)((ap)+= sizeof(int)))[-1]))!= 0)
; 108 		t = t * 2 + x;
BRA	.22
.23:
; Debug: mul int = const 2 to int t = [S+8-6] (used reg = )
LDD	2,S
LSLB
ROLA
; Debug: add int x = [S+8-8] to int = D+0 (used reg = )
ADDD	0,S
; Debug: eq int = D+0 to int t = [S+8-6] (used reg = )
STD	2,S
;BCC_EOS
; 109 	 ;
.22:
; Debug: ptraddab int = const 2 to * char ap = [S+8-4] (used reg = )
LDX	4,S
LEAX	2,X
STX	4,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: eq int = [X-2] to int x = [S+8-8] (used reg = )
LDX	-2,X
STX	0,S
; Debug: ne int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.23
.24:
.21:
;BCC_EOS
; 110 	return t;
LDX	2,S
LEAS	8,S
RTS
;BCC_EOS
; 111 }
; 112 
; 113 
; 114  
; 115 void show(f,__va_alist) __proto(char *f,...)
; 116 # 115 "vatest.c"
; 115 char *f;
EXPORT	_show
_show:
;BCC_EOS
; 116 {
; 117 	va_list ap;
;BCC_EOS
; 118 	char *s;
;BCC_EOS
; 119 
; 120 	((ap)= (char *)&__va_alist) ;
PSHS	CC,D,X,DP
; Debug: eq * char __va_alist = S+6+2 to * char ap = [S+6-4] (used reg = )
LEAX	8,S
STX	2,S
;BCC_EOS
; 121 	for (; *f; f++)
;BCC_EOS
;BCC_EOS
; 122 		switch (*f) {
BRA	.27
.28:
LDB	[4,S]
BRA	.2B
; 123 		case 'd':
; 124 			putnum((((int *)((ap)+= sizeof(int)))[-1]));
.2C:
; Debug: ptraddab int = const 2 to * char ap = [S+6-4] (used reg = )
LDX	2,S
LEAX	2,X
STX	2,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: rootlist int = [X-2] (used reg = )
LDX	-2,X
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 125 			break;
BRA	.29
;BCC_EOS
; 126 		case 'u':
; 127 			putnum((int)(((unsigned *)((ap)+= sizeof(unsigned)))[-1]));
.2D:
; Debug: ptraddab int = const 2 to * char ap = [S+6-4] (used reg = )
LDX	2,S
LEAX	2,X
STX	2,S
; Debug: cast * unsigned int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * unsigned int = X+0 (used reg = )
; Debug: cast int = const 0 to unsigned int = [X-2] (used reg = )
; Debug: rootlist int = [X-2] (used reg = )
LDX	-2,X
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 128 			break;
BRA	.29
;BCC_EOS
; 129 		case 'l':
; 130 			putlong(((
.2E:
; 130 (long *)((ap)+= sizeof(long)))[-1]));
; Debug: ptraddab int = const 4 to * char ap = [S+6-4] (used reg = )
LDX	2,S
LEAX	4,X
STX	2,S
; Debug: cast * long = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * long = X+0 (used reg = )
; Debug: rootlist long = [X-4] (used reg = )
LDD	-4,X
LDX	-2,X
; Debug: func () void = putlong+0 (used reg = )
JSR	>_putlong
;BCC_EOS
; 131 			break;
BRA	.29
;BCC_EOS
; 132 		case 's':
; 133 			s = (((char * *)((ap)+= sizeof(char *)))[-1]) ;
.2F:
; Debug: ptraddab int = const 2 to * char ap = [S+6-4] (used reg = )
LDX	2,S
LEAX	2,X
STX	2,S
; Debug: cast * * char = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * * char = X+0 (used reg = )
; Debug: eq * char = [X-2] to * char s = [S+6-6] (used reg = )
LDX	-2,X
STX	0,S
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 135 			putchar('\n');
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 136 			break;
BRA	.29
;BCC_EOS
; 137 		case 'c':
; 138 			putchar((((int *)((ap)+= sizeof(int)))[-1]));
.30:
; Debug: ptraddab int = const 2 to * char ap = [S+6-4] (used reg = )
LDX	2,S
LEAX	2,X
STX	2,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: rootlist int = [X-2] (used reg = )
LDX	-2,X
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 139 			putchar('\n');
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 140 			break;
BRA	.29
.2B:
SUBB	#$63
BEQ	.30
SUBB	#1
BEQ	.2C
SUBB	#8
BEQ	.2E
SUBB	#7
BEQ	.2F
SUBB	#2
BEQ	.2D
.29:
..FFFF		EQU	-6
.26:
; Debug: postinc * char f = [S+6-2] (used reg = )
LDX	4,S
LEAU	1,X
STU	4,S
.27:
LDB	[4,S]
BNE	.28
.31:
.25:
;BCC_EOS
; 143 }
LEAS	6,S
RTS
; 144 
; 145  
; 146 int vsum(n,ap) __proto(int n,va_list ap)
; 147 # 146 "vatest.c"
; 146 int n;
EXPORT	_vsum
_vsum:
;BCC_EOS
; 147 # 146 "vatest.c"
; 146 va_list ap;
;BCC_EOS
; 147 {
; 148 	int t = 0;
CLRA
CLRB
PSHS	D,X
;BCC_EOS
; 149 
; 150 	while (n-- > 0)
; 151 		t += (((int *)((ap)+= sizeof(int)))[-1]) ;
BRA	.33
.34:
; Debug: ptraddab int = const 2 to * char ap = [S+4+2] (used reg = )
LDX	6,S
LEAX	2,X
STX	6,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: addab int = [X-2] to int t = [S+4-4] (used reg = )
LDD	0,S
ADDD	-2,X
STD	0,S
;BCC_EOS
; 152 	return t;
.33:
; Debug: postdec int n = [S+4-2] (used reg = )
LDD	2,S
ADDD	#-1
STD	2,S
; Debug: gt int = const 0 to int = D+1 (used reg = )
ADDD	#1
SUBD	#0
BGT	.34
.35:
.32:
LDX	0,S
PULS	U,Y,PC
;BCC_EOS
; 153 }
; 154 
; 155 int handon(n,__va_alist) __proto(int n,...)
; 156 # 155 "vatest.c"
; 155 int n;
EXPORT	_handon
_handon:
;BCC_EOS
; 156 {
; 157 	va_list ap;
;BCC_EOS
; 158 	int t;
;BCC_EOS
; 159 
; 160 	((ap)= (char *)&__va_alist) ;
PSHS	CC,D,X,DP
; Debug: eq * char __va_alist = S+6+2 to * char ap = [S+6-4] (used reg = )
LEAX	8,S
STX	2,S
PSHS	X
; Debug: rootlist int n = [S+8-2] (used reg = )
LDX	6,S
; Debug: func () int = vsum+0 (used reg = )
JSR	>_vsum
LEAS	2,S
; Debug: eq int = X+0 to int t = [S+6-6] (used reg = )
STX	0,S
LEAS	6,S
RTS
;BCC_EOS
; 164 }
; 165 
; 166  
; 167 int twice(n,__va_alist) __proto(int n,...)
; 168 # 167 "vatest.c"
; 167 int n;
EXPORT	_twice
_twice:
;BCC_EOS
; 168 {
; 169 	va_list ap, ap2;
;BCC_EOS
; 170 	int t = 0, i;
PSHS	X
LEAS	-6,S
; Debug: eq int = const 0 to int t = [S+8-8] (used reg = )
CLRA
CLRB
STD	0,S
;BCC_EOS
; 171 
; 172 	((ap)= (char *)&__va_alist) ;
LEAS	-2,S
; Debug: eq * char __va_alist = S+$A+2 to * char ap = [S+$A-4] (used reg = )
LEAX	$C,S
STX	6,S
STX	4,S
;BCC_EOS
; 174 	for (i = 0; i < n; i++)
; Debug: eq int = const 0 to int i = [S+$A-$A] (used reg = )
CLRA
CLRB
STD	0,S
;BCC_EOS
;BCC_EOS
; 175 		t += (((int *)((ap)+= sizeof(int)))[-1]) ;
BRA	.38
.39:
; Debug: ptraddab int = const 2 to * char ap = [S+$A-4] (used reg = )
LDX	6,S
LEAX	2,X
STX	6,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: addab int = [X-2] to int t = [S+$A-8] (used reg = )
LDD	2,S
ADDD	-2,X
STD	2,S
;BCC_EOS
; 176 	for (i = 0; i < n; i++)
.37:
; Debug: postinc int i = [S+$A-$A] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
.38:
; Debug: lt int n = [S+$A-2] to int i = [S+$A-$A] (used reg = )
LDD	0,S
SUBD	8,S
BLT	.39
.3A:
.36:
; Debug: eq int = const 0 to int i = [S+$A-$A] (used reg = )
CLRA
CLRB
STD	0,S
;BCC_EOS
;BCC_EOS
; 177 		t += 10 * (((int *)((ap2)+= sizeof(int)))[-1]) ;
BRA	.3D
.3E:
; Debug: ptraddab int = const 2 to * char ap2 = [S+$A-6] (used reg = )
LDX	4,S
LEAX	2,X
STX	4,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: mul int = [X-2] to int = const $A (used reg = )
; Debug: expression subtree swapping
LDD	-2,X
PSHS	D
LSLB
ROLA
LSLB
ROLA
ADDD	,S++
LSLB
ROLA
; Debug: addab int = D+0 to int t = [S+$A-8] (used reg = )
ADDD	2,S
STD	2,S
;BCC_EOS
; 178 	 ;
.3C:
; Debug: postinc int i = [S+$A-$A] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
.3D:
; Debug: lt int n = [S+$A-2] to int i = [S+$A-$A] (used reg = )
LDD	0,S
SUBD	8,S
BLT	.3E
.3F:
.3B:
;BCC_EOS
; 179 	 ;
;BCC_EOS
; 180 	return t;
LDX	2,S
LEAS	$A,S
RTS
;BCC_EOS
; 181 }
; 182 
; 183  
; 184 int depth(n,__va_alist) __proto(int n,...)
; 185 # 184 "vatest.c"
; 184 int n;
EXPORT	_depth
_depth:
;BCC_EOS
; 185 {
; 186 	va_list ap;
;BCC_EOS
; 187 	int a, b;
;BCC_EOS
; 188 
; 189 	((ap)= (char *)&__va_alist) ;
PSHS	X
LEAS	-6,S
; Debug: eq * char __va_alist = S+8+2 to * char ap = [S+8-4] (used reg = )
LEAX	$A,S
STX	4,S
LEAX	2,X
STX	4,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: eq int = [X-2] to int a = [S+8-6] (used reg = )
LDX	-2,X
STX	2,S
;BCC_EOS
; 191 	b = (((int *)((ap)+= sizeof(int)))[-1]) ;
; Debug: ptraddab int = const 2 to * char ap = [S+8-4] (used reg = )
LDX	4,S
LEAX	2,X
STX	4,S
; Debug: cast * int = const 0 to * char = X+0 (used reg = )
; Debug: ptradd int = const -1 to * int = X+0 (used reg = )
; Debug: eq int = [X-2] to int b = [S+8-8] (used reg = )
LDX	-2,X
STX	0,S
;BCC_EOS
; 192 	 ;
;BCC_EOS
; 193 	if (n == 0)
; Debug: logeq int = const 0 to int n = [S+8-2] (used reg = )
LDD	6,S
BNE	.40
.41:
; 194 		return a + b;
; Debug: add int b = [S+8-8] to int a = [S+8-6] (used reg = )
LDD	2,S
ADDD	0,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
LEAS	8,S
RTS
;BCC_EOS
; 195 	return depth(n - 1,a + 1,b * 2) + n;
.40:
; Debug: mul int = const 2 to int b = [S+8-8] (used reg = )
LDD	0,S
LSLB
ROLA
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: add int = const 1 to int a = [S+$A-6] (used reg = )
LDD	4,S
; Debug: list int = D+1 (used reg = )
ADDD	#1
PSHS	D
; Debug: sub int = const 1 to int n = [S+$C-2] (used reg = )
LDD	$A,S
; Debug: rootlist int = D-1 (used reg = )
ADDD	#-1
TFR	D,X
; Debug: func () int = depth+0 (used reg = )
JSR	>_depth
LEAS	4,S
; Debug: add int n = [S+8-2] to int = X+0 (used reg = )
TFR	X,D
ADDD	6,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
LEAS	8,S
RTS
;BCC_EOS
; 196 }
; 197 
; 198 int main()
; 199 {
EXPORT	_main
_main:
; 200 	int (*fp)()= sum;
LEAS	-2,S
; Debug: eq () int = sum+0 to * () int fp = [S+2-2] (used reg = )
LDX	#_sum
STX	0,S
;BCC_EOS
; 201 	long big = 100000L;
LEAS	-4,S
; Debug: eq long = const $186A0 to long big = [S+6-6] (used reg = )
LDD	#1
LDX	#$86A0
STD	0,S
STX	2,S
;BCC_EOS
; 202 
; 203 	putnum(sum(0));
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () int = sum+0 (used reg = )
JSR	>_sum
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 204 	putnum(sum(1,7));
; Debug: list int = const 7 (used reg = )
LDD	#7
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () int = sum+0 (used reg = )
JSR	>_sum
LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 205 	putnum(sum(3,1,2,3));
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = sum+0 (used reg = )
JSR	>_sum
LEAS	6,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 206 	putnum(sum(12,1,2,3,4,5,6,7,8,9,10,11,12));
; Debug: list int = const $C (used reg = )
LDD	#$C
PSHS	D
; Debug: list int = const $B (used reg = )
LDD	#$B
PSHS	D
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: list int = const 9 (used reg = )
LDD	#9
PSHS	D
; Debug: list int = const 8 (used reg = )
LDD	#8
PSHS	D
; Debug: list int = const 7 (used reg = )
LDD	#7
PSHS	D
; Debug: list int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: list int = const 4 (used reg = )
LDD	#4
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist int = const $C (used reg = )
LDX	#$C
; Debug: func () int = sum+0 (used reg = )
JSR	>_sum
LEAS	$18,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 207 	putlong(lsum(3,100000L,-1L,2000000000L));
; Debug: list long = const $77359400 (used reg = )
LDD	#$7735
LDX	#$9400
PSHS	D,X
; Debug: list long = const -1 (used reg = )
LDD	#$FFFF
LDX	#$FFFF
PSHS	D,X
; Debug: list long = const $186A0 (used reg = )
LDD	#1
LDX	#$86A0
PSHS	D,X
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () long = lsum+0 (used reg = )
JSR	>_lsum
LEAS	$C,S
; Debug: rootlist long = X+0 (used reg = )
; Debug: func () void = putlong+0 (used reg = )
JSR	>_putlong
;BCC_EOS
; 208 	putnum(two(1,2,3,4,0));
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list int = const 4 (used reg = )
LDD	#4
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () int = two+0 (used reg = )
JSR	>_two
LEAS	8,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 209 	putnum(two(5,6,0));
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: rootlist int = const 5 (used reg = )
LDX	#5
; Debug: func () int = two+0 (used reg = )
JSR	>_two
LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 210 	putlong(lfirst(70000L,1,2,3,0));
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
LDX	#$1170
; Debug: func () long = lfirst+0 (used reg = )
JSR	>_lfirst
LEAS	8,S
; Debug: rootlist long = X+0 (used reg = )
; Debug: func () void = putlong+0 (used reg = )
JSR	>_putlong
;BCC_EOS
; 211 	putnum(cfirst('A',1,2,0));
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist char = const $41 (used reg = )
LDX	#$41
; Debug: func () int = cfirst+0 (used reg = )
JSR	>_cfirst
LEAS	6,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 212 	show("dulsc",-5,40000U,big,"hello",'x');	 
LOC	1
.42:
FCC	"dulsc"
FCB	0
LOC	0
LOC	1
.43:
FCC	"hello"
FCB	0
LOC	0
; Debug: list int = const $78 (used reg = )
LDD	#$78
PSHS	D
; Debug: list * char = .43+0 (used reg = )
LDX	#.43
PSHS	X
; Debug: list long big = [S+$A-6] (used reg = )
LDD	4,S
LDX	6,S
PSHS	D,X
; Debug: list unsigned int = const $9C40 (used reg = )
LDD	#$9C40
PSHS	D
; Debug: list int = const -5 (used reg = )
LDD	#-5
PSHS	D
; Debug: rootlist * char = .42+0 (used reg = )
LDX	#.42
; Debug: func () void = show+0 (used reg = )
JSR	>_show
LEAS	$C,S
;BCC_EOS
; 213 	show("lldd",-1L,2147483647L,1,2);
LOC	1
.44:
FCC	"lldd"
FCB	0
LOC	0
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: list long = const $7FFFFFFF (used reg = )
LDD	#$7FFF
LDX	#$FFFF
PSHS	D,X
; Debug: list long = const -1 (used reg = )
LDD	#$FFFF
LDX	#$FFFF
PSHS	D,X
; Debug: rootlist * char = .44+0 (used reg = )
LDX	#.44
; Debug: func () void = show+0 (used reg = )
JSR	>_show
LEAS	$C,S
;BCC_EOS
; 214 	show("");
LOC	1
.45:
FCB	0
LOC	0
; Debug: rootlist * char = .45+0 (used reg = )
LDX	#.45
; Debug: func () void = show+0 (used reg = )
JSR	>_show
;BCC_EOS
; 215 	putnum(handon(4,10,20,30,40));
; Debug: list int = const $28 (used reg = )
LDD	#$28
PSHS	D
; Debug: list int = const $1E (used reg = )
LDD	#$1E
PSHS	D
; Debug: list int = const $14 (used reg = )
LDD	#$14
PSHS	D
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () int = handon+0 (used reg = )
JSR	>_handon
LEAS	8,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 216 	putnum(twice(3,1,2,3));
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = twice+0 (used reg = )
JSR	>_twice
LEAS	6,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 217 	putnum((*fp)(2,300,400));
; Debug: list int = const $190 (used reg = )
LDD	#$190
PSHS	D
; Debug: list int = const $12C (used reg = )
LDD	#$12C
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () int fp = [S+$A-2] (used reg = )
JSR	[8,S]
LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 218 	putnum(depth(3,1,1));
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = depth+0 (used reg = )
JSR	>_depth
LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 219 
; 220 	ok(1,sum(3,1,2,3)== 6);
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = sum+0 (used reg = )
JSR	>_sum
LEAS	6,S
; Debug: logeq int = const 6 to int = X+0 (used reg = )
LEAX	-6,X
BNE	.46
LDB	#1
BRA	.47
.46:
CLRB
.47:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 221 	ok(2,lsum(2,100000L,100000L)== 200000L);
; Debug: list long = const $186A0 (used reg = )
LDD	#1
LDX	#$86A0
PSHS	D,X
; Debug: list long = const $186A0 (used reg = )
LDD	#1
LDX	#$86A0
PSHS	D,X
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () long = lsum+0 (used reg = )
JSR	>_lsum
LEAS	8,S
; Debug: logeq long = const $30D40 to long = X+0 (used reg = )
PSHS	D,X
LDD	#3
LDX	#$D40
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
BNE	.48
LDB	#1
BRA	.49
.48:
CLRB
.49:
LEAS	8,S
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 222 	ok(3,two(1,2,3,0)== 1203);
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () int = two+0 (used reg = )
JSR	>_two
LEAS	6,S
; Debug: logeq int = const $4B3 to int = X+0 (used reg = )
CMPX	#$4B3
BNE	.4A
LDB	#1
BRA	.4B
.4A:
CLRB
.4B:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 223 	ok(4,lfirst(-1L,1,0)== 0L);
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist long = const -1 (used reg = )
LDD	#$FFFF
LDX	#$FFFF
; Debug: func () long = lfirst+0 (used reg = )
JSR	>_lfirst
LEAS	4,S
; Debug: logeq long = const 0 to long = X+0 (used reg = )
PSHS	D,X
CLRA
CLRB
TFR	D,X
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
BNE	.4C
LDB	#1
BRA	.4D
.4C:
CLRB
.4D:
LEAS	8,S
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 224 	ok(5,handon(2,5,6)== 11);
; Debug: list int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () int = handon+0 (used reg = )
JSR	>_handon
LEAS	4,S
; Debug: logeq int = const $B to int = X+0 (used reg = )
LEAX	-$B,X
BNE	.4E
LDB	#1
BRA	.4F
.4E:
CLRB
.4F:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 5 (used reg = )
LDX	#5
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 225 	ok(6,twice(2,1,1)== 22);
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () int = twice+0 (used reg = )
JSR	>_twice
LEAS	4,S
; Debug: logeq int = const $16 to int = X+0 (used reg = )
LEAX	-$16,X
BNE	.50
LDB	#1
BRA	.51
.50:
CLRB
.51:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 6 (used reg = )
LDX	#6
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 226 	say("checks ");
LOC	1
.52:
FCC	"checks "
FCB	0
LOC	0
; Debug: rootlist * char = .52+0 (used reg = )
LDX	#.52
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 227 	putnum(checks);
; Debug: rootlist int = [checks+0] (used reg = )
LDX	>_checks
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 228 	say("failures ");
LOC	1
.53:
FCC	"failures "
FCB	0
LOC	0
; Debug: rootlist * char = .53+0 (used reg = )
LDX	#.53
; Debug: func () void = say+0 (used reg = )
JSR	>_say
;BCC_EOS
; 229 	putnum(failures);
; Debug: rootlist int = [failures+0] (used reg = )
LDX	>_failures
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 230 	return failures;
LDX	>_failures
LEAS	6,S
RTS
;BCC_EOS
; 231 }
; 232 
LOC	3
_checks		COMM	2
_failures		COMM	2
; 0 errors detected
