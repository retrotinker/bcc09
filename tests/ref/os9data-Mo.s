; 1 
; 1 # 1 "os9data.c"
; 1 # 8
; 8  
; 9 
; 10 extern void putchar(), putnum();
;BCC_EOS
; 11 
; 12 int checks, failures;
;BCC_EOS
; 13 int g;
;BCC_EOS
; 14 static int s = 5;
	LOC	3
_s:
	FDB	5
;BCC_EOS
; 15 char buf[10];
;BCC_EOS
; 16 char *str = 0;
	EXPORT	_str
_str:
	FDB	0
;BCC_EOS
; 17 long lg = 70000L;
	EXPORT	_lg
_lg:
	FDB	1
	FDB	$1170
;BCC_EOS
; 18 double dg = 2.5;
	EXPORT	_dg
_dg:
	FDB	$4004
	FDB	0
	FDB	0
	FDB	0
;BCC_EOS
; 19 int (*fp)();
;BCC_EOS
; 20 static double sd;
;BCC_EOS
; 21 int twice();
;BCC_EOS
; 22 char *greet = "hey";		 
	EXPORT	_greet
_greet:
	LOC	1
.1:
	FCC	"hey"
	FCB	0
	LOC	3
.2:
	FDB	0
;BCC_EOS
; 23 int (*tfp)()= twice;
	EXPORT	_tfp
_tfp:
.3:
	FDB	0
;BCC_EOS
; 24 int *gp = &g;
	EXPORT	_gp
_gp:
.4:
	FDB	0
;BCC_EOS
; 25 char *bp = buf + 3;
	EXPORT	_bp
_bp:
.5:
	FDB	0
;BCC_EOS
; 26 static char *strs[] = { "one", "two", 0 };
_strs:
	LOC	1
.6:
	FCC	"one"
	FCB	0
	LOC	3
.7:
	FDB	0
	LOC	1
.8:
	FCC	"two"
	FCB	0
	LOC	3
.9:
	FDB	0
	FDB	0
;BCC_EOS
; 27 
; 28 void check(n,cond)
; 29 int n, cond;
	LOC	0
	EXPORT	_check
_check:
;BCC_EOS
; 30 {
; 31 	++checks;
	PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
	LDD	_checks,U
	ADDD	#1
	STD	_checks,U
;BCC_EOS
; 32 	if (!cond) {
	LDD	4,S
		BNE	.A
.B:
; 33 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
	LDD	_failures,U
	ADDD	#1
	STD	_failures,U
;BCC_EOS
; 34 		putnum(n);
; Debug: rootlist int n = [S+2-2] (used reg = )
	LDX	0,S
; Debug: func () void = putnum+0 (used reg = )
	LBSR	_putnum
;BCC_EOS
; 35 		putchar('\n');
; Debug: rootlist int = const $A (used reg = )
	LDX	#$A
; Debug: func () void = putchar+0 (used reg = )
	LBSR	_putchar
;BCC_EOS
; 36 	}
; 37 }
.A:
	PULS	Y,PC
; 38 
; 39 int twice(x)
; 40 int x;
	EXPORT	_twice
_twice:
;BCC_EOS
; 41 {
; 42 	static int calls;	 
	LOC	3
.C		LCOMM	2
	LOC	0
;BCC_EOS
; 43 
; 44 	++calls;
	PSHS	X
; Debug: preinc int = [.C+0] (used reg = )
	LDD	.C,U
	ADDD	#1
	STD	.C,U
;BCC_EOS
; 45 	return x + x + calls - calls;
; Debug: add int x = [S+2-2] to int x = [S+2-2] (used reg = )
	LDD	0,S
	ADDD	0,S
; Debug: add int = [.C+0] to int = D+0 (used reg = )
	ADDD	.C,U
; Debug: sub int = [.C+0] to int = D+0 (used reg = )
	SUBD	.C,U
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 46 }
; 47 
; 48 double half(d)
; 49 double d;
	EXPORT	_half
_half:
;BCC_EOS
; 50 {
; 51 	return d / 2;
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
; 52 }
; 53 
; 54 double pick(c,a,b)
; 55 int c;
	EXPORT	_pick
_pick:
;BCC_EOS
; 56 double a, b;
;BCC_EOS
; 57 {
; 58 	return c ? a : b;
	PSHS	X
	LDD	0,S
		BEQ	.D
.E:
	LEAX	4,S
	LBSR	Fpushd
	BRA		.F
.D:
	LEAX	$C,S
	LBSR	Fpushd
.F:
; Debug: cast double = const (whatever) to double (temp) = [S+$A-$A] (used reg = )
; Debug: eq double (temp) = [S+$A-$A] to double = [__dret+0] (used reg = )
	LEAX	___dret,U
	LBSR	Fpulld
	LEAS	2,S
	RTS
;BCC_EOS
; 59 }
; 60 
; 61 double scale(f,i)
; 62 double f;		 
	EXPORT	_scale
_scale:
;BCC_EOS
; 63 int i;
;BCC_EOS
; 64 {
; 65 	return f * i;
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
; 66 }
; 67 
; 68 int main()
; 69 {
	EXPORT	_main
_main:
; 70 	char *p = "hello";
	LEAS	-2,S
	LOC	1
.10:
	FCC	"hello"
	FCB	0
	LOC	0
; Debug: eq [6] char = .10+0 to * char p = [S+2-2] (used reg = )
	LEAX	.10,PC
	STX	0,S
;BCC_EOS
; 71 	static char lit[] = "abc";
	LOC	3
.11:
.12:
	FCC	"abc"
	FCB	0
	LOC	0
;BCC_EOS
; 72 
; 73 	g = 3;
; Debug: eq int = const 3 to int = [g+0] (used reg = )
	LDD	#3
	STD	_g,U
;BCC_EOS
; 74 	buf[2] = 'x';
; Debug: eq int = const $78 to char = [buf+2] (used reg = )
	LDB	#$78
	STB	_buf+2,U
;BCC_EOS
; 75 	str = p;
; Debug: eq * char p = [S+2-2] to * char = [str+0] (used reg = )
	LDX	0,S
	STX	_str,U
;BCC_EOS
; 76 	check(1,g + s == 8 && buf[2] == 'x' && str[1] == 'e');
; Debug: add int = [s+0] to int = [g+0] (used reg = )
	LDD	_g,U
	ADDD	_s,U
; Debug: logeq int = const 8 to int = D+0 (used reg = )
	SUBD	#8
		BNE	.13
.16:
; Debug: logeq int = const $78 to char = [buf+2] (used reg = )
	LDB	_buf+2,U
	SUBB	#$78
		BNE	.13
.15:
; Debug: ptradd int = const 1 to * char = [str+0] (used reg = )
	LDX	_str,U
; Debug: logeq int = const $65 to char = [X+1] (used reg = )
	LDB	1,X
	SUBB	#$65
		BNE	.13
.14:
	LDB	#1
	BRA	.17
.13:
	CLRB
.17:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 77 	check(2,lg + g == 70003L && lit[2] == 'c');
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
		BNE	.18
.1A:
; Debug: logeq int = const $63 to char = [.11+2] (used reg = )
	LDB	.11+2,U
	SUBB	#$63
		BNE	.18
.19:
	LDB	#1
	BRA	.1C
.18:
	CLRB
.1C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 2 (used reg = )
	LDX	#2
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 78 	fp = twice;
; Debug: eq () int = twice+0 to * () int = [fp+0] (used reg = )
	LEAX	_twice,PC
	STX	_fp,U
;BCC_EOS
; 79 	check(3,fp(21)== 42 && (*fp)(s)== 10);
; Debug: rootlist int = const $15 (used reg = )
	LDX	#$15
; Debug: func () int = [fp+0] (used reg = )
	JSR	[_fp,U]
; Debug: logeq int = const $2A to int = X+0 (used reg = )
	LEAX	-$2A,X
		BNE	.1D
.1F:
; Debug: rootlist int = [s+0] (used reg = )
	LDX	_s,U
; Debug: func () int = [fp+0] (used reg = )
	JSR	[_fp,U]
; Debug: logeq int = const $A to int = X+0 (used reg = )
	LEAX	-$A,X
		BNE	.1D
.1E:
	LDB	#1
	BRA	.20
.1D:
	CLRB
.20:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 3 (used reg = )
	LDX	#3
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 80 	sd = half(dg);
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
; 81 	check(4,sd == 1.25 && half(half(8.0))== 2.0);
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
		BNE	.21
.23:
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
		BNE	.21
.22:
	LDB	#1
	BRA	.24
.21:
	CLRB
.24:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 4 (used reg = )
	LDX	#4
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 82 	check(5,pick(1,1.5,2.5)== 1.5 && pick(0,1.5,2.5)== 2.5);
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
		BNE	.25
.27:
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
		BNE	.25
.26:
	LDB	#1
	BRA	.28
.25:
	CLRB
.28:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 5 (used reg = )
	LDX	#5
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 83 	check(6,(g > 2 ? dg : sd)== 2.5 && scale((float)1.5,4)== 6.0);
; Debug: gt int = const 2 to int = [g+0] (used reg = )
	LDD	_g,U
	SUBD	#2
		BLE	.2C
.2D:
	LEAX	_dg,U
	LBSR	Fpushd
	BRA		.2E
.2C:
	LEAX	_sd,U
	LBSR	Fpushd
.2E:
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
		BNE	.29
.2B:
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
		BNE	.29
.2A:
	LDB	#1
	BRA	.2F
.29:
	CLRB
.2F:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 6 (used reg = )
	LDX	#6
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 84 	check(7,greet[1] == 'e' && tfp(5)== 10 && *gp == 3);
; Debug: ptradd int = const 1 to * char = [greet+0] (used reg = )
	LDX	_greet,U
; Debug: logeq int = const $65 to char = [X+1] (used reg = )
	LDB	1,X
	SUBB	#$65
		BNE	.30
.33:
; Debug: rootlist int = const 5 (used reg = )
	LDX	#5
; Debug: func () int = [tfp+0] (used reg = )
	JSR	[_tfp,U]
; Debug: logeq int = const $A to int = X+0 (used reg = )
	LEAX	-$A,X
		BNE	.30
.32:
; Debug: logeq int = const 3 to int = [[gp+0]] (used reg = )
	LDX	[_gp,U]
	LEAX	-3,X
		BNE	.30
.31:
	LDB	#1
	BRA	.34
.30:
	CLRB
.34:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 7 (used reg = )
	LDX	#7
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 85 	check(8,bp == &buf[3] && strs[1][2] == 'o' && strs[2] == 0);
; Debug: logeq * char = buf+3 to * char = [bp+0] (used reg = )
	LEAX	_buf+3,U
	CMPX	_bp,U
		BNE	.35
.38:
; Debug: ptradd int = const 2 to * char = [strs+2] (used reg = )
	LDX	_strs+2,U
; Debug: logeq int = const $6F to char = [X+2] (used reg = )
	LDB	2,X
	SUBB	#$6F
		BNE	.35
.37:
; Debug: logeq int = const 0 to * char = [strs+4] (used reg = )
	LDD	_strs+4,U
		BNE	.35
.36:
	LDB	#1
	BRA	.39
.35:
	CLRB
.39:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 8 (used reg = )
	LDX	#8
; Debug: func () void = check+0 (used reg = )
	LBSR	_check
	LEAS	2,S
;BCC_EOS
; 86 	putnum(checks);
; Debug: rootlist int = [checks+0] (used reg = )
	LDX	_checks,U
; Debug: func () void = putnum+0 (used reg = )
	LBSR	_putnum
;BCC_EOS
; 87 	putchar('\n');
; Debug: rootlist int = const $A (used reg = )
	LDX	#$A
; Debug: func () void = putchar+0 (used reg = )
	LBSR	_putchar
;BCC_EOS
; 88 	return failures;
	LDX	_failures,U
	PULS	Y,PC
;BCC_EOS
; 89 }
; 90 
	LOC	3
_g		COMM	2
_sd		LCOMM	8
_buf		COMM	$A
_checks		COMM	2
_failures		COMM	2
_fp		COMM	2
___dret		COMM	8
	LOC	0
.3A:
	LEAX	.8,PC
	STX	.9,U
	LEAX	.6,PC
	STX	.7,U
	LEAX	_buf+3,U
	STX	.5,U
	LEAX	_g,U
	STX	.4,U
	LEAX	_twice,PC
	STX	.3,U
	LEAX	.1,PC
	STX	.2,U
	RTS
	LOC	5
	FDB	.3A

; 0 errors detected
