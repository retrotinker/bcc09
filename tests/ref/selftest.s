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
; 9 
; 10 int checks, failures;
;BCC_EOS
; 11 
; 12 void puts1(s)
; 13 char *s;
	EXPORT	_puts1
_puts1:
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
; Debug: func () void = putchar+0 (used reg = )
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
; 19  
; 20 void check(n,got,want)
; 21 int n, got, want;
	EXPORT	_check
_check:
;BCC_EOS
; 22 {
; 23 	++checks;
	PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
	LDD	>_checks
	ADDD	#1
	STD	>_checks
;BCC_EOS
; 24 	if (got != want) {
; Debug: ne int want = [S+2+4] to int got = [S+2+2] (used reg = )
	LDD	4,S
	SUBD	6,S
	LBEQ	.5
.6:
; 25 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
	LDD	>_failures
	ADDD	#1
	STD	>_failures
;BCC_EOS
; 26 		puts1("FAIL ");
	LOC	1
.7:
	FCC	"FAIL "
	FCB	0
	LOC	0
; Debug: rootlist * char = .7+0 (used reg = )
	LDX	#.7
; Debug: func () void = puts1+0 (used reg = )
	JSR	>_puts1
;BCC_EOS
; 27 		putnum(n);
; Debug: rootlist int n = [S+2-2] (used reg = )
	LDX	0,S
; Debug: func () void = putnum+0 (used reg = )
	JSR	>_putnum
;BCC_EOS
; 28 		putnum(got);
; Debug: rootlist int got = [S+2+2] (used reg = )
	LDX	4,S
; Debug: func () void = putnum+0 (used reg = )
	JSR	>_putnum
;BCC_EOS
; 29 		putnum(want);
; Debug: rootlist int want = [S+2+4] (used reg = )
	LDX	6,S
; Debug: func () void = putnum+0 (used reg = )
	JSR	>_putnum
;BCC_EOS
; 30 	}
; 31 }
.5:
	PULS	Y,PC
; 32 
; 33 int main()
; 34 {
	EXPORT	_main
_main:
; 35 	char tmp[8];
;BCC_EOS
; 36 
; 37 	 
; 38 	check(1,select(0),10);
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
; 39 	check(2,select(1),6);
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
; 40 	check(3,select(2),7);
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
; 41 	check(4,select(3),0);
; Debug: list int = const 0 (used reg = )
	LDD	#0
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
; 42 	check(5,select(7),-14);
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
; 43 	check(6,select(8),16);
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
; 44 	check(7,select(100),1);
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
; 45 	check(8,select(-1),0);
; Debug: list int = const 0 (used reg = )
	LDD	#0
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
; 46 
; 47 	 
; 48 	check(10,dense(0),-1);
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
; 49 	check(11,dense(1),11);
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
; 50 	check(12,dense(2),22);
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
; 51 	check(13,dense(3),33);
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
; 52 	check(14,dense(4),44);
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
; 53 	check(15,dense(5),55);
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
; 54 	check(16,dense(6),66);
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
; 55 	check(17,dense(7),-1);
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
; 56 
; 57 	 
; 58 	check(20,loops(0),0);
; Debug: list int = const 0 (used reg = )
	LDD	#0
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
; 59 	check(21,loops(1),1);
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
; 60 	check(22,loops(3),5);
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
; 61 	check(23,loops(4),5);
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
; 62 	check(24,loops(5),10);
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
; 63 	check(25,loops(12),58);
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
; 64 	check(26,loops(20),62);
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
; 65 
; 66 	 
; 67 	check(30,strlen1("hello, world"),12);
	LOC	1
.8:
	FCC	"hello, world"
	FCB	0
	LOC	0
; Debug: list int = const $C (used reg = )
	LDD	#$C
	PSHS	D
; Debug: rootlist * char = .8+0 (used reg = )
	LDX	#.8
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
; 68 	copy(tmp,"abc");
	LOC	1
.9:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list * char = .9+0 (used reg = )
	LDX	#.9
	PSHS	X
; Debug: rootlist * char tmp = S+$A-8 (used reg = )
	LEAX	2,S
; Debug: func () void = copy+0 (used reg = )
	JSR	>_copy
	LEAS	2,S
;BCC_EOS
; 69 	check(31,tmp[0],'a');
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
; 70 	check(32,tmp[2],'c');
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
; 71 	check(33,tmp[3],0);
; Debug: list int = const 0 (used reg = )
	LDD	#0
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
; 72 	check(34,sum(tab,8),87);
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
; 73 	check(35,sum(tab + 2,3),16);
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
; 74 	check(36,ptrs(),221);
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
; 75 	check(37,buf[0],'t');
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
; 76 	check(38,strlen1(buf),5);
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
; 77 
; 78 	puts1("checks ");
	LOC	1
.A:
	FCC	"checks "
	FCB	0
	LOC	0
; Debug: rootlist * char = .A+0 (used reg = )
	LDX	#.A
; Debug: func () void = puts1+0 (used reg = )
	JSR	>_puts1
;BCC_EOS
; 79 	putnum(checks);
; Debug: rootlist int = [checks+0] (used reg = )
	LDX	>_checks
; Debug: func () void = putnum+0 (used reg = )
	JSR	>_putnum
;BCC_EOS
; 80 	puts1("failures ");
	LOC	1
.B:
	FCC	"failures "
	FCB	0
	LOC	0
; Debug: rootlist * char = .B+0 (used reg = )
	LDX	#.B
; Debug: func () void = puts1+0 (used reg = )
	JSR	>_puts1
;BCC_EOS
; 81 	putnum(failures);
; Debug: rootlist int = [failures+0] (used reg = )
	LDX	>_failures
; Debug: func () void = putnum+0 (used reg = )
	JSR	>_putnum
;BCC_EOS
; 82 	return failures;
	LDX	>_failures
	LEAS	8,S
	RTS
;BCC_EOS
; 83 }
; 84 
	LOC	3
_checks		COMM	2
_failures		COMM	2

; 0 errors detected
