; 1 
; 1 # 1 "os9data.c"
; 1 # 7
; 7  
; 8 
; 9 extern void putchar(), putnum();
;BCC_EOS
; 10 
; 11 int checks, failures;
;BCC_EOS
; 12 int g;
;BCC_EOS
; 13 static int s = 5;
	LOC	3
_s:
	FDB	5
;BCC_EOS
; 14 char buf[10];
;BCC_EOS
; 15 char *str = 0;
	EXPORT	_str
_str:
	FDB	0
;BCC_EOS
; 16 long lg = 70000L;
	EXPORT	_lg
_lg:
	FDB	1
	FDB	$1170
;BCC_EOS
; 17 double dg = 2.5;
	EXPORT	_dg
_dg:
	FDB	$4004
	FDB	0
	FDB	0
	FDB	0
;BCC_EOS
; 18 int (*fp)();
;BCC_EOS
; 19 static double sd;
;BCC_EOS
; 20 
; 21 void check(n,cond)
; 22 int n, cond;
	LOC	0
	EXPORT	_check
_check:
;BCC_EOS
; 23 {
; 24 	++checks;
	PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
	LDD	_checks,U
	ADDD	#1
	STD	_checks,U
;BCC_EOS
; 25 	if (!cond) {
	LDD	4,S
		BNE	.1
.2:
; 26 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
	LDD	_failures,U
	ADDD	#1
	STD	_failures,U
;BCC_EOS
; 27 		putnum(n);
; Debug: rootlist int n = [S+2-2] (used reg = )
	LDX	0,S
; Debug: func () void = putnum+0 (used reg = )
	LBSR	_putnum
;BCC_EOS
; 28 		putchar('\n');
; Debug: rootlist int = const $A (used reg = )
	LDX	#$A
; Debug: func () void = putchar+0 (used reg = )
	LBSR	_putchar
;BCC_EOS
; 29 	}
; 30 }
.1:
	PULS	Y,PC
; 31 
; 32 int twice(x)
; 33 int x;
	EXPORT	_twice
_twice:
;BCC_EOS
; 34 {
; 35 	static int calls;	 
	LOC	3
.3		LCOMM	2
	LOC	0
;BCC_EOS
; 36 
; 37 	++calls;
	PSHS	X
; Debug: preinc int = [.3+0] (used reg = )
	LDD	.3,U
	ADDD	#1
	STD	.3,U
;BCC_EOS
; 38 	return x + x + calls - calls;
; Debug: add int x = [S+2-2] to int x = [S+2-2] (used reg = )
	LDD	0,S
	ADDD	0,S
; Debug: add int = [.3+0] to int = D+0 (used reg = )
	ADDD	.3,U
; Debug: sub int = [.3+0] to int = D+0 (used reg = )
	SUBD	.3,U
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 39 }
; 40 
; 41 double half(d)
; 42 double d;
	EXPORT	_half
_half:
;BCC_EOS
; 43 {
; 44 	return d / 2;
; Debug: div double = const (whatever) to double d = [S+0+2] (used reg = )
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4000
	PSHS	D
	LEAX	$A,S
	LBSR	Fpushd
	LBSR	Fdiv
; Debug: cast double = const (whatever) to double (temp) = [S+8-8] (used reg = )
; Debug: eq double (temp) = [S+8-8] to double = [__dret+0] (used reg = )
	LEAX	___dret,U
	LBSR	Fpulld
	RTS
;BCC_EOS
; 45 }
; 46 
; 47 double pick(c,a,b)
; 48 int c;
	EXPORT	_pick
_pick:
;BCC_EOS
; 49 double a, b;
;BCC_EOS
; 50 {
; 51 	return c ? a : b;
	PSHS	X
	LDD	0,S
		BEQ	.4
.5:
	LEAX	4,S
	LBSR	Fpushd
	BRA		.6
.4:
	LEAX	$C,S
	LBSR	Fpushd
.6:
; Debug: cast double = const (whatever) to double (temp) = [S+$A-$A] (used reg = )
; Debug: eq double (temp) = [S+$A-$A] to double = [__dret+0] (used reg = )
	LEAX	___dret,U
	LBSR	Fpulld
	LEAS	2,S
	RTS
;BCC_EOS
; 52 }
; 53 
; 54 double scale(f,i)
; 55 double f;		 
	EXPORT	_scale
_scale:
;BCC_EOS
; 56 int i;
;BCC_EOS
; 57 {
; 58 	return f * i;
; Debug: cast double = const (whatever) to int i = [S+0+$A] (used reg = )
	LDD	$A,S
	LBSR	Fpushi
; Debug: mul double (temp) = [S+8-8] to double f = [S+8+2] (used reg = )
	LEAX	$A,S
	LBSR	Fpushd
	LBSR	Fmul
; Debug: cast double = const (whatever) to double (temp) = [S+8-8] (used reg = )
; Debug: eq double (temp) = [S+8-8] to double = [__dret+0] (used reg = )
	LEAX	___dret,U
	LBSR	Fpulld
	RTS
;BCC_EOS
; 59 }
; 60 
; 61 int main()
; 62 {
	EXPORT	_main
_main:
; 63 	char *p = "hello";
	LEAS	-2,S
	LOC	1
.7:
	FCC	"hello"
	FCB	0
	LOC	0
; Debug: eq [6] char = .7+0 to * char p = [S+2-2] (used reg = )
	LEAX	.7,PC
	STX	0,S
;BCC_EOS
; 64 	static char lit[] = "abc";
	LOC	3
.8:
.9:
	FCC	"abc"
	FCB	0
	LOC	0
;BCC_EOS
; 65 
; 66 	g = 3;
; Debug: eq int = const 3 to int = [g+0] (used reg = )
	LDD	#3
	STD	_g,U
;BCC_EOS
; 67 	buf[2] = 'x';
; Debug: eq int = const $78 to char = [buf+2] (used reg = )
	LDB	#$78
	STB	_buf+2,U
;BCC_EOS
; 68 	str = p;
; Debug: eq * char p = [S+2-2] to * char = [str+0] (used reg = )
	LDX	0,S
	STX	_str,U
;BCC_EOS
; 69 	check(1,g + s == 8 && buf[2] == 'x' && str[1] == 'e');
; Debug: add int = [s+0] to int = [g+0] (used reg = )
	LDD	_g,U
	ADDD	_s,U
; Debug: logeq int = const 8 to int = D+0 (used reg = )
	SUBD	#8
		BNE	.A
.D:
; Debug: logeq int = const $78 to char = [buf+2] (used reg = )
	LDB	_buf+2,U
	SUBB	#$78
		BNE	.A
.C:
; Debug: ptradd int = const 1 to * char = [str+0] (used reg = )
	LDX	_str,U
; Debug: logeq int = const $65 to char = [X+1] (used reg = )
	LDB	1,X
	SUBB	#$65
		BNE	.A
.B:
	LDB	#1
	BRA	.E
.A:
	CLRB
.E:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 70 	check(2,lg + g == 70003L && lit[2] == 'c');
; Debug: cast long = const 0 to int = [g+0] (used reg = )
	LDD	_g,U
	TFR	D,X
	CLRB
	ROLA
	SBCB	#0
	SEX
; Debug: add long = X+0 to long = [lg+0] (used reg = )
; Debug: expression subtree swapping
	LEAY	_lg,U
	LBSR	ladd_b
; Debug: logeq long = const $11173 to long = X+0 (used reg = )
	PSHS	D,X
	LDD	#1
	LDX	#$1173
	PSHS	D,X
	LDD	4,S
	LDX	6,S
	LEAY	0,S
	LBSR	lcmp_b
	LEAS	8,S
		BNE	.F
.11:
; Debug: logeq int = const $63 to char = [.8+2] (used reg = )
	LDB	.8+2,U
	SUBB	#$63
		BNE	.F
.10:
	LDB	#1
	BRA	.13
.F:
	CLRB
.13:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 2 (used reg = )
	LDX	#2
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 71 	fp = twice;
; Debug: eq () int = twice+0 to * () int = [fp+0] (used reg = )
	LEAX	_twice,PC
	STX	_fp,U
;BCC_EOS
; 72 	check(3,fp(21)== 42 && (*fp)(s)== 10);
; Debug: rootlist int = const $15 (used reg = )
	LDX	#$15
; Debug: func () int = [fp+0] (used reg = )
	JSR	[_fp,U]
; Debug: logeq int = const $2A to int = X+0 (used reg = )
	LEAX	-$2A,X
		BNE	.14
.16:
; Debug: rootlist int = [s+0] (used reg = )
	LDX	_s,U
; Debug: func () int = [fp+0] (used reg = )
	JSR	[_fp,U]
; Debug: logeq int = const $A to int = X+0 (used reg = )
	LEAX	-$A,X
		BNE	.14
.15:
	LDB	#1
	BRA	.17
.14:
	CLRB
.17:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 3 (used reg = )
	LDX	#3
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 73 	sd = half(dg);
	LEAS	-8,S
; Debug: list double = [dg+0] (used reg = )
	LEAX	_dg,U
	LBSR	Fpushd
; Debug: func () double = half+0 (used reg = )
	LBSR	_half
	LEAS	8,S
	LDD	___dret,U
	STD	0,S
	LDD	___dret+2,U
	STD	2,S
	LDD	___dret+4,U
	STD	4,S
	LDD	___dret+6,U
	STD	6,S
; Debug: eq double (temp) = [S+$A-$A] to double = [sd+0] (used reg = )
	LEAX	_sd,U
	LBSR	Fpulld
;BCC_EOS
; 74 	check(4,sd == 1.25 && half(half(8.0))== 2.0);
; Debug: logeq double = const (whatever) to double = [sd+0] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$3FF4
	PSHS	D
	LEAX	_sd,U
	LBSR	Fpushd
	LBSR	Fcomp
		BNE	.18
.1A:
	LEAS	-8,S
	LEAS	-8,S
; Debug: list double = const (whatever) (used reg = )
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4020
	PSHS	D
; Debug: func () double = half+0 (used reg = )
	LBSR	_half
	LEAS	8,S
	LDD	___dret,U
	STD	0,S
	LDD	___dret+2,U
	STD	2,S
	LDD	___dret+4,U
	STD	4,S
	LDD	___dret+6,U
	STD	6,S
; Debug: list double (temp) = [S+$12-$12] (used reg = )
; Debug: func () double = half+0 (used reg = )
	LBSR	_half
	LEAS	8,S
	LDD	___dret,U
	STD	0,S
	LDD	___dret+2,U
	STD	2,S
	LDD	___dret+4,U
	STD	4,S
	LDD	___dret+6,U
	STD	6,S
; Debug: logeq double = const (whatever) to double (temp) = [S+$A-$A] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4000
	PSHS	D
	LEAX	8,S
	LBSR	Fpushd
	LBSR	Fcomp
	LEAS	8,S
		BNE	.18
.19:
	LDB	#1
	BRA	.1B
.18:
	CLRB
.1B:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 4 (used reg = )
	LDX	#4
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 75 	check(5,pick(1,1.5,2.5)== 1.5 && pick(0,1.5,2.5)== 2.5);
	LEAS	-8,S
; Debug: list double = const (whatever) (used reg = )
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4004
	PSHS	D
; Debug: list double = const (whatever) (used reg = )
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$3FF8
	PSHS	D
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () double = pick+0 (used reg = )
	LBSR	_pick
	LEAS	$10,S
	LDD	___dret,U
	STD	0,S
	LDD	___dret+2,U
	STD	2,S
	LDD	___dret+4,U
	STD	4,S
	LDD	___dret+6,U
	STD	6,S
; Debug: logeq double = const (whatever) to double (temp) = [S+$A-$A] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$3FF8
	PSHS	D
	LEAX	8,S
	LBSR	Fpushd
	LBSR	Fcomp
	LEAS	8,S
		BNE	.1C
.1E:
	LEAS	-8,S
; Debug: list double = const (whatever) (used reg = )
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4004
	PSHS	D
; Debug: list double = const (whatever) (used reg = )
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$3FF8
	PSHS	D
; Debug: rootlist int = const 0 (used reg = )
	LDX	#0
; Debug: func () double = pick+0 (used reg = )
	LBSR	_pick
	LEAS	$10,S
	LDD	___dret,U
	STD	0,S
	LDD	___dret+2,U
	STD	2,S
	LDD	___dret+4,U
	STD	4,S
	LDD	___dret+6,U
	STD	6,S
; Debug: logeq double = const (whatever) to double (temp) = [S+$A-$A] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4004
	PSHS	D
	LEAX	8,S
	LBSR	Fpushd
	LBSR	Fcomp
	LEAS	8,S
		BNE	.1C
.1D:
	LDB	#1
	BRA	.1F
.1C:
	CLRB
.1F:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 5 (used reg = )
	LDX	#5
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 76 	check(6,(g > 2 ? dg : sd)== 2.5 && scale((float)1.5,4)== 6.0);
; Debug: gt int = const 2 to int = [g+0] (used reg = )
	LDD	_g,U
	SUBD	#2
		BLE	.23
.24:
	LEAX	_dg,U
	LBSR	Fpushd
	BRA		.25
.23:
	LEAX	_sd,U
	LBSR	Fpushd
.25:
; Debug: logeq double = const (whatever) to double (temp) = [S+$A-$A] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4004
	PSHS	D
	LEAX	8,S
	LBSR	Fpushd
	LBSR	Fcomp
	LEAS	8,S
		BNE	.20
.22:
	LEAS	-8,S
; Debug: list int = const 4 (used reg = )
	LDD	#4
	PSHS	D
; Debug: list float = const (whatever) (used reg = )
	LDD	#0
	PSHS	D
	LDD	#$3FC0
	PSHS	D
	LEAX	0,S
	LBSR	Fpushf
	LDD	6,S
	STD	$A,S
	LDD	4,S
	STD	8,S
	LDD	2,S
	STD	6,S
	LDD	0,S
	STD	4,S
	LEAS	4,S
; Debug: func () double = scale+0 (used reg = )
	LBSR	_scale
	LEAS	$A,S
	LDD	___dret,U
	STD	0,S
	LDD	___dret+2,U
	STD	2,S
	LDD	___dret+4,U
	STD	4,S
	LDD	___dret+6,U
	STD	6,S
; Debug: logeq double = const (whatever) to double (temp) = [S+$A-$A] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4018
	PSHS	D
	LEAX	8,S
	LBSR	Fpushd
	LBSR	Fcomp
	LEAS	8,S
		BNE	.20
.21:
	LDB	#1
	BRA	.26
.20:
	CLRB
.26:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 6 (used reg = )
	LDX	#6
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 77 	putnum(checks);
; Debug: rootlist int = [checks+0] (used reg = )
	LDX	_checks,U
; Debug: func () void = putnum+0 (used reg = )
	LBSR	_putnum
;BCC_EOS
; 78 	putchar('\n');
; Debug: rootlist int = const $A (used reg = )
	LDX	#$A
; Debug: func () void = putchar+0 (used reg = )
	LBSR	_putchar
;BCC_EOS
; 79 	return failures;
	LDX	_failures,U
	PULS	Y,PC
;BCC_EOS
; 80 }
; 81 
	LOC	3
_g		COMM	2
_sd		LCOMM	8
_buf		COMM	$A
_checks		COMM	2
_failures		COMM	2
_fp		COMM	2
___dret		COMM	8

; 0 errors detected
