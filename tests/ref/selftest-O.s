; 1 
; 1 # 1 "selftest.c"
; 1 
; 2 
; 3  
; 4 
; 5 extern int select(), dense(), loops(), strlen1(), sum(), ptrs();
;BCC_EOS
; 6 extern void copy(), putchar(), putnum();
;BCC_EOS
; 7 extern int tab[];
;BCC_EOS
; 8 extern char buf[];
;BCC_EOS
; 9 extern double fops(), d2;
;BCC_EOS
; 10 extern int fconv();
;BCC_EOS
; 11 extern float f1;
;BCC_EOS
; 12 
; 13 int checks, failures;
;BCC_EOS
; 14 int one = 1;
LOC	3
EXPORT	_one
_one:
FDB	1
;BCC_EOS
; 15 
; 16  
; 17 long lsecond(d,l)
; 18 int d;
LOC	0
EXPORT	_lsecond
_lsecond:
;BCC_EOS
; 19 long l;
;BCC_EOS
; 20 {
; 21 	return l;
PSHS	X
LDD	4,S
LDX	6,S
PULS	Y,PC
;BCC_EOS
; 22 }
; 23 
; 24 
; 25  
; 26 long lodd(c)
; 27 char c;
EXPORT	_lodd
_lodd:
;BCC_EOS
; 28 {
; 29 	char k;
;BCC_EOS
; 30 
; 31 	k = c;
PSHS	CC,X
; Debug: eq char c = [S+3-1] to char k = [S+3-3] (used reg = )
LDB	2,S
STB	0,S
CLRA
TFR	D,X
CLRB
ROLA
SBCB	#0
SEX
; Debug: add long = X+0 to long = const $186A0 (used reg = )
PSHS	D,X
LDD	#1
LDX	#$86A0
LEAY	0,S
JSR	>ladd_b
LEAS	$7,S
RTS
;BCC_EOS
; 33 }
; 34 
; 35 void puts1(s)
; 36 char *s;
EXPORT	_puts1
_puts1:
;BCC_EOS
; 37 {
; 38 	while (*s)
PSHS	X
; 39 		putchar(*s++);
BRA	.3
.4:
; Debug: postinc * char s = [S+2-2] (used reg = )
LDX	0,S
LEAU	1,X
STU	0,S
; Debug: rootlist char = [X+0] (used reg = )
LDB	0,X
CLRA
TFR	D,X
; Debug: func () void = putchar+0 (used reg = )
JSR	>_putchar
;BCC_EOS
; 40 }
.3:
LDB	[0,S]
BNE	.4
.5:
.2:
PULS	Y,PC
; 41 
; 42  
; 43 void check(n,got,want)
; 44 int n, got, want;
EXPORT	_check
_check:
;BCC_EOS
; 45 {
; 46 	++checks;
PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
LDD	>_checks
ADDD	#1
STD	>_checks
;BCC_EOS
; 47 	if (got != want) {
; Debug: ne int want = [S+2+4] to int got = [S+2+2] (used reg = )
LDD	4,S
SUBD	6,S
BEQ	.6
.7:
; 48 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
LDD	>_failures
ADDD	#1
STD	>_failures
;BCC_EOS
; 49 		puts1("FAIL ");
LOC	1
.8:
FCC	"FAIL "
FCB	0
LOC	0
; Debug: rootlist * char = .8+0 (used reg = )
LDX	#.8
; Debug: func () void = puts1+0 (used reg = )
JSR	>_puts1
;BCC_EOS
; 50 		putnum(n);
; Debug: rootlist int n = [S+2-2] (used reg = )
LDX	0,S
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 51 		putnum(got);
; Debug: rootlist int got = [S+2+2] (used reg = )
LDX	4,S
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 52 		putnum(want);
; Debug: rootlist int want = [S+2+4] (used reg = )
LDX	6,S
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 53 	}
; 54 }
.6:
PULS	Y,PC
; 55 
; 56 int main()
; 57 {
EXPORT	_main
_main:
; 58 	char tmp[8];
;BCC_EOS
; 59 
; 60 	 
; 61 	check(1,select(0),10);
LEAS	-8,S
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () int = select+0 (used reg = )
JSR	>_select
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 62 	check(2,select(1),6);
; Debug: list int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () int = select+0 (used reg = )
JSR	>_select
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 63 	check(3,select(2),7);
; Debug: list int = const 7 (used reg = )
LDD	#7
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () int = select+0 (used reg = )
JSR	>_select
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 64 	check(4,select(3),0);
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = select+0 (used reg = )
JSR	>_select
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 65 	check(5,select(7),-14);
; Debug: list int = const -$E (used reg = )
LDD	#-$E
PSHS	D
; Debug: rootlist int = const 7 (used reg = )
LDX	#7
; Debug: func () int = select+0 (used reg = )
JSR	>_select
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const 5 (used reg = )
LDX	#5
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 66 	check(6,select(8),16);
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: rootlist int = const 8 (used reg = )
LDX	#8
; Debug: func () int = select+0 (used reg = )
JSR	>_select
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const 6 (used reg = )
LDX	#6
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 67 	check(7,select(100),1);
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist int = const $64 (used reg = )
LDX	#$64
; Debug: func () int = select+0 (used reg = )
JSR	>_select
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const 7 (used reg = )
LDX	#7
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 68 	check(8,select(-1),0);
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist int = const -1 (used reg = )
LDX	#-1
; Debug: func () int = select+0 (used reg = )
JSR	>_select
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const 8 (used reg = )
LDX	#8
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 69 
; 70 	 
; 71 	check(10,dense(0),-1);
; Debug: list int = const -1 (used reg = )
LDD	#-1
PSHS	D
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () int = dense+0 (used reg = )
JSR	>_dense
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 72 	check(11,dense(1),11);
; Debug: list int = const $B (used reg = )
LDD	#$B
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () int = dense+0 (used reg = )
JSR	>_dense
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $B (used reg = )
LDX	#$B
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 73 	check(12,dense(2),22);
; Debug: list int = const $16 (used reg = )
LDD	#$16
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () int = dense+0 (used reg = )
JSR	>_dense
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $C (used reg = )
LDX	#$C
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 74 	check(13,dense(3),33);
; Debug: list int = const $21 (used reg = )
LDD	#$21
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = dense+0 (used reg = )
JSR	>_dense
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $D (used reg = )
LDX	#$D
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 75 	check(14,dense(4),44);
; Debug: list int = const $2C (used reg = )
LDD	#$2C
PSHS	D
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () int = dense+0 (used reg = )
JSR	>_dense
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $E (used reg = )
LDX	#$E
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 76 	check(15,dense(5),55);
; Debug: list int = const $37 (used reg = )
LDD	#$37
PSHS	D
; Debug: rootlist int = const 5 (used reg = )
LDX	#5
; Debug: func () int = dense+0 (used reg = )
JSR	>_dense
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $F (used reg = )
LDX	#$F
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 77 	check(16,dense(6),66);
; Debug: list int = const $42 (used reg = )
LDD	#$42
PSHS	D
; Debug: rootlist int = const 6 (used reg = )
LDX	#6
; Debug: func () int = dense+0 (used reg = )
JSR	>_dense
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $10 (used reg = )
LDX	#$10
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 78 	check(17,dense(7),-1);
; Debug: list int = const -1 (used reg = )
LDD	#-1
PSHS	D
; Debug: rootlist int = const 7 (used reg = )
LDX	#7
; Debug: func () int = dense+0 (used reg = )
JSR	>_dense
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $11 (used reg = )
LDX	#$11
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 79 
; 80 	 
; 81 	check(20,loops(0),0);
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () int = loops+0 (used reg = )
JSR	>_loops
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $14 (used reg = )
LDX	#$14
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 82 	check(21,loops(1),1);
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () int = loops+0 (used reg = )
JSR	>_loops
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $15 (used reg = )
LDX	#$15
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 83 	check(22,loops(3),5);
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = loops+0 (used reg = )
JSR	>_loops
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $16 (used reg = )
LDX	#$16
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 84 	check(23,loops(4),5);
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () int = loops+0 (used reg = )
JSR	>_loops
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $17 (used reg = )
LDX	#$17
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 85 	check(24,loops(5),10);
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
; Debug: rootlist int = const 5 (used reg = )
LDX	#5
; Debug: func () int = loops+0 (used reg = )
JSR	>_loops
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $18 (used reg = )
LDX	#$18
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 86 	check(25,loops(12),58);
; Debug: list int = const $3A (used reg = )
LDD	#$3A
PSHS	D
; Debug: rootlist int = const $C (used reg = )
LDX	#$C
; Debug: func () int = loops+0 (used reg = )
JSR	>_loops
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $19 (used reg = )
LDX	#$19
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 87 	check(26,loops(20),62);
; Debug: list int = const $3E (used reg = )
LDD	#$3E
PSHS	D
; Debug: rootlist int = const $14 (used reg = )
LDX	#$14
; Debug: func () int = loops+0 (used reg = )
JSR	>_loops
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $1A (used reg = )
LDX	#$1A
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 88 
; 89 	 
; 90 	check(30,strlen1("hello, world"),12);
LOC	1
.9:
FCC	"hello, world"
FCB	0
LOC	0
; Debug: list int = const $C (used reg = )
LDD	#$C
PSHS	D
; Debug: rootlist * char = .9+0 (used reg = )
LDX	#.9
; Debug: func () int = strlen1+0 (used reg = )
JSR	>_strlen1
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $1E (used reg = )
LDX	#$1E
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 91 	copy(tmp,"abc");
LOC	1
.A:
FCC	"abc"
FCB	0
LOC	0
; Debug: list * char = .A+0 (used reg = )
LDX	#.A
PSHS	X
; Debug: rootlist * char tmp = S+$A-8 (used reg = )
LEAX	2,S
; Debug: func () void = copy+0 (used reg = )
JSR	>_copy
LEAS	2,S
;BCC_EOS
; 92 	check(31,tmp[0],'a');
; Debug: list int = const $61 (used reg = )
LDD	#$61
PSHS	D
; Debug: list char tmp = [S+$A-8] (used reg = )
LDB	2,S
CLRA
PSHS	D
; Debug: rootlist int = const $1F (used reg = )
LDX	#$1F
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 93 	check(32,tmp[2],'c');
; Debug: list int = const $63 (used reg = )
LDD	#$63
PSHS	D
; Debug: list char tmp = [S+$A-6] (used reg = )
LDB	4,S
CLRA
PSHS	D
; Debug: rootlist int = const $20 (used reg = )
LDX	#$20
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 94 	check(33,tmp[3],0);
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list char tmp = [S+$A-5] (used reg = )
LDB	5,S
CLRA
PSHS	D
; Debug: rootlist int = const $21 (used reg = )
LDX	#$21
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 95 	check(34,sum(tab,8),87);
; Debug: list int = const $57 (used reg = )
LDD	#$57
PSHS	D
; Debug: list int = const 8 (used reg = )
LDD	#8
PSHS	D
; Debug: rootlist * int = tab+0 (used reg = )
LDX	#_tab
; Debug: func () int = sum+0 (used reg = )
JSR	>_sum
LEAS	2,S
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $22 (used reg = )
LDX	#$22
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 96 	check(35,sum(tab + 2,3),16);
; Debug: list int = const $10 (used reg = )
LDD	#$10
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: rootlist * int = tab+4 (used reg = )
LDX	#_tab+4
; Debug: func () int = sum+0 (used reg = )
JSR	>_sum
LEAS	2,S
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $23 (used reg = )
LDX	#$23
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 97 	check(36,ptrs(),221);
; Debug: list int = const $DD (used reg = )
LDD	#$DD
PSHS	D
; Debug: func () int = ptrs+0 (used reg = )
JSR	>_ptrs
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $24 (used reg = )
LDX	#$24
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 98 	check(37,buf[0],'t');
; Debug: list int = const $74 (used reg = )
LDD	#$74
PSHS	D
; Debug: list char = [buf+0] (used reg = )
LDB	>_buf
CLRA
PSHS	D
; Debug: rootlist int = const $25 (used reg = )
LDX	#$25
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 99 	check(38,strlen1(buf),5);
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: rootlist * char = buf+0 (used reg = )
LDX	#_buf
; Debug: func () int = strlen1+0 (used reg = )
JSR	>_strlen1
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $26 (used reg = )
LDX	#$26
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 100 
; 101 
; 102 
; 103 	 
; 104 	{
; 105 		static char spelled[] = {
LOC	3
.B:
; 106 			'0','1','2','3','4','5','6','7','8','9','a','b','c','d',
FCB	$30
FCB	$31
FCB	$32
FCB	$33
FCB	$34
FCB	$35
FCB	$36
FCB	$37
FCB	$38
FCB	$39
FCB	$61
FCB	$62
FCB	$63
FCB	$64
; 107 			'e','f','0','1','2','3','4','5','6','7','8','9','A','B',
FCB	$65
FCB	$66
FCB	$30
FCB	$31
FCB	$32
FCB	$33
FCB	$34
FCB	$35
FCB	$36
FCB	$37
FCB	$38
FCB	$39
FCB	$41
FCB	$42
; 108 			'C','D','E','F', 0
FCB	$43
FCB	$44
FCB	$45
FCB	$46
; 109 		};
FCB	0
LOC	0
;BCC_EOS
; 110 		char *lit = "0123456789abcdef0123456789ABCDEF";
LEAS	-2,S
LOC	1
.C:
FCC	"0123456789abcdef0123456789ABCDEF"
FCB	0
LOC	0
; Debug: eq [$21] char = .C+0 to * char lit = [S+$A-$A] (used reg = )
LDX	#.C
STX	0,S
;BCC_EOS
; 111 		int i, same = 1;
LEAS	-4,S
; Debug: eq int = const 1 to int same = [S+$E-$E] (used reg = )
LDD	#1
STD	0,S
;BCC_EOS
; 112 
; 113 		for (i = 0; i < 33; i++)
; Debug: eq int = const 0 to int i = [S+$E-$C] (used reg = )
CLRA
CLRB
STD	2,S
;BCC_EOS
;BCC_EOS
; 114 			if (lit[i] != spelled[i])
BRA	.F
.10:
; Debug: ptradd int i = [S+$E-$C] to [$21] char = .B+0 (used reg = )
LDD	2,S
LDX	#.B
LEAX	D,X
; Debug: ptradd int i = [S+$E-$C] to * char lit = [S+$E-$A] (used reg = X)
LDD	2,S
ADDD	4,S
TFR	D,U
; Debug: ne char = [X+0] to char = [U+0] (used reg = )
LDB	0,U
SUBB	0,X
BEQ	.11
.12:
; 115 				same = 0;
; Debug: eq int = const 0 to int same = [S+$E-$E] (used reg = )
CLRA
CLRB
STD	0,S
;BCC_EOS
; 116 		check(40,same,1);
.11:
.E:
; Debug: postinc int i = [S+$E-$C] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.F:
; Debug: lt int = const $21 to int i = [S+$E-$C] (used reg = )
LDD	2,S
SUBD	#$21
BLT	.10
.13:
.D:
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: list int same = [S+$10-$E] (used reg = )
LDD	2,S
PSHS	D
; Debug: rootlist int = const $28 (used reg = )
LDX	#$28
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	$a,S
; 118 
; 119 
; 120 	 
; 121 	check(41,lsecond(0,one ? 1L : 1)== 1L,1);
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
LDD	>_one
BEQ	.14
.15:
CLRA
CLRB
LDX	#1
BRA	.16
.14:
CLRA
CLRB
LDX	#1
.16:
; Debug: list long = X+0 (used reg = )
PSHS	D,X
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () long = lsecond+0 (used reg = )
JSR	>_lsecond
LEAS	4,S
; Debug: logeq long = const 1 to long = X+0 (used reg = )
PSHS	D,X
CLRA
CLRB
LDX	#1
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
BNE	.17
LDB	#1
BRA	.18
.17:
CLRB
.18:
LEAS	8,S
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $29 (used reg = )
LDX	#$29
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 122 	check(42,lsecond(0,one ? -1L : 1)== -1L,1);
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
LDD	>_one
BEQ	.19
.1A:
LDD	#$FFFF
LDX	#$FFFF
BRA	.1B
.19:
CLRA
CLRB
LDX	#1
.1B:
; Debug: list long = X+0 (used reg = )
PSHS	D,X
; Debug: rootlist int = const 0 (used reg = )
LDX	#0
; Debug: func () long = lsecond+0 (used reg = )
JSR	>_lsecond
LEAS	4,S
; Debug: logeq long = const -1 to long = X+0 (used reg = )
PSHS	D,X
LDD	#$FFFF
LDX	#$FFFF
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
BNE	.1C
LDB	#1
BRA	.1D
.1C:
CLRB
.1D:
LEAS	8,S
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2A (used reg = )
LDX	#$2A
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 123 	check(43,lodd(2)== 100002L,1);
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () long = lodd+0 (used reg = )
JSR	>_lodd
; Debug: logeq long = const $186A2 to long = X+0 (used reg = )
PSHS	D,X
LDD	#1
LDX	#$86A2
PSHS	D,X
LDD	4,S
LDX	6,S
LEAY	0,S
JSR	>lcmp_b
BNE	.1E
LDB	#1
BRA	.1F
.1E:
CLRB
.1F:
LEAS	8,S
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $2B (used reg = )
LDX	#$2B
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 124 
; 125 
; 126 	 
; 127 	check(50,(int)(fops(3.5,0.5)* 10),70);
; Debug: list int = const $46 (used reg = )
LDD	#$46
PSHS	D
LEAS	-8,S
; Debug: list double = const (whatever) (used reg = )
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$3FE0
PSHS	D
; Debug: list double = const (whatever) (used reg = )
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$400C
PSHS	D
; Debug: func () double = fops+0 (used reg = )
JSR	>_fops
LEAS	$10,S
STD	0,S
STX	2,S
STU	6,S
STY	4,S
; Debug: mul double = const (whatever) to double (temp) = [S+$12-$12] (used reg = )
; Debug: expression subtree swapping
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$4024
PSHS	D
JSR	>Fmul
; Debug: cast int = const 0 to double (temp) = [S+$12-$12] (used reg = )
LEAX	0,S
JSR	>dtoi
LEAS	8,S
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const $32 (used reg = )
LDX	#$32
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 128 	check(51,(int)(d2 * 100),700);
; Debug: list int = const $2BC (used reg = )
LDD	#$2BC
PSHS	D
; Debug: mul double = const (whatever) to double = [d2+0] (used reg = )
; Debug: expression subtree swapping
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$4059
PSHS	D
LDX	#_d2
JSR	>Fmuld
; Debug: cast int = const 0 to double (temp) = [S+$12-$12] (used reg = )
LEAX	0,S
JSR	>dtoi
LEAS	8,S
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const $33 (used reg = )
LDX	#$33
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 129 	check(52,(int)(fops(0.5,2.0)* 10),10);
; Debug: list int = const $A (used reg = )
LDD	#$A
PSHS	D
LEAS	-8,S
; Debug: list double = const (whatever) (used reg = )
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$4000
PSHS	D
; Debug: list double = const (whatever) (used reg = )
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$3FE0
PSHS	D
; Debug: func () double = fops+0 (used reg = )
JSR	>_fops
LEAS	$10,S
STD	0,S
STX	2,S
STU	6,S
STY	4,S
; Debug: mul double = const (whatever) to double (temp) = [S+$12-$12] (used reg = )
; Debug: expression subtree swapping
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$4024
PSHS	D
JSR	>Fmul
; Debug: cast int = const 0 to double (temp) = [S+$12-$12] (used reg = )
LEAX	0,S
JSR	>dtoi
LEAS	8,S
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const $34 (used reg = )
LDX	#$34
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 130 	check(53,(int)
; 130 (d2 * 100),-25);
; Debug: list int = const -$19 (used reg = )
LDD	#-$19
PSHS	D
; Debug: mul double = const (whatever) to double = [d2+0] (used reg = )
; Debug: expression subtree swapping
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$4059
PSHS	D
LDX	#_d2
JSR	>Fmuld
; Debug: cast int = const 0 to double (temp) = [S+$12-$12] (used reg = )
LEAX	0,S
JSR	>dtoi
LEAS	8,S
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const $35 (used reg = )
LDX	#$35
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 131 	check(54,fconv(3),6);
; Debug: list int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = fconv+0 (used reg = )
JSR	>_fconv
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $36 (used reg = )
LDX	#$36
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 132 	check(55,(int)f1,3);
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: cast int = const 0 to float = [f1+0] (used reg = )
LDX	#_f1
JSR	>ftoi
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const $37 (used reg = )
LDX	#$37
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 133 	check(56,(int)d2,3);
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: cast int = const 0 to double = [d2+0] (used reg = )
LDX	#_d2
JSR	>dtoi
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const $38 (used reg = )
LDX	#$38
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 134 	check(57,fconv(-5),-11);
; Debug: list int = const -$B (used reg = )
LDD	#-$B
PSHS	D
; Debug: rootlist int = const -5 (used reg = )
LDX	#-5
; Debug: func () int = fconv+0 (used reg = )
JSR	>_fconv
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const $39 (used reg = )
LDX	#$39
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 135 	check(58,(int)(f1 * 4),-20);
; Debug: list int = const -$14 (used reg = )
LDD	#-$14
PSHS	D
; Debug: cast double = const (whatever) to float = [f1+0] (used reg = )
LDX	#_f1
JSR	>Fpushf
; Debug: mul double = const (whatever) to double (temp) = [S+$12-$12] (used reg = )
; Debug: expression subtree swapping
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$4010
PSHS	D
JSR	>Fmul
; Debug: cast int = const 0 to double (temp) = [S+$12-$12] (used reg = )
LEAX	0,S
JSR	>dtoi
LEAS	8,S
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const $3A (used reg = )
LDX	#$3A
; Debug: func () void = check+0 (used reg = )
JSR	>_check
LEAS	4,S
;BCC_EOS
; 136 
; 137 	puts1("checks ");
LOC	1
.20:
FCC	"checks "
FCB	0
LOC	0
; Debug: rootlist * char = .20+0 (used reg = )
LDX	#.20
; Debug: func () void = puts1+0 (used reg = )
JSR	>_puts1
;BCC_EOS
; 138 	putnum(checks);
; Debug: rootlist int = [checks+0] (used reg = )
LDX	>_checks
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 139 	puts1("failures ");
LOC	1
.21:
FCC	"failures "
FCB	0
LOC	0
; Debug: rootlist * char = .21+0 (used reg = )
LDX	#.21
; Debug: func () void = puts1+0 (used reg = )
JSR	>_puts1
;BCC_EOS
; 140 	putnum(failures);
; Debug: rootlist int = [failures+0] (used reg = )
LDX	>_failures
; Debug: func () void = putnum+0 (used reg = )
JSR	>_putnum
;BCC_EOS
; 141 	return failures;
LDX	>_failures
LEAS	8,S
RTS
;BCC_EOS
; 142 }
; 143 
LOC	3
_checks		COMM	2
_failures		COMM	2
; 0 errors detected
