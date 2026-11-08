; 1 
; 1 # 1 "arith.c"
; 1  
; 2 
; 3 char c1 = 'A', c2;
	LOC	3
	EXPORT	_c1
_c1:
	FCB	$41
;BCC_EOS
; 4 unsigned char uc = 200;
	EXPORT	_uc
_uc:
	FCB	$C8
;BCC_EOS
; 5 int i1 = 1000, i2 = -7, i3;
	EXPORT	_i1
_i1:
	FDB	$3E8
	EXPORT	_i2
_i2:
	FDB	$FFF9
;BCC_EOS
; 6 unsigned u1 = 40000, u2;
	EXPORT	_u1
_u1:
	FDB	$9C40
;BCC_EOS
; 7 
; 8 int arith(a,b)
; 9 int a, b;
	LOC	0
	EXPORT	_arith
_arith:
;BCC_EOS
; 10 {
; 11 	i3 = a + b;
	PSHS	X
; Debug: add int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	ADDD	4,S
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 12 	i3 = a - b;
; Debug: sub int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	SUBD	4,S
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 13 	i3 = a * b;
; Debug: mul int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>imul
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 14 	i3 = a / b;
; Debug: div int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>idiv
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 15 	i3 = a % b;
; Debug: mod int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>imod
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 16 	i3 = -a;
; Debug: neg int a = [S+2-2] (used reg = )
	LDD	#0
	SUBD	0,S
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 17 	i3 = ~a;
; Debug: not int a = [S+2-2] (used reg = )
	LDD	0,S
	COMA
	COMB
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 18 	i3 = a & b;
; Debug: and int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	ANDA	4,S
	ANDB	5,S
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 19 	i3 = a | b;
; Debug: or int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	ORA	4,S
	ORB	5,S
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 20 	i3 = a ^ b;
; Debug: eor int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	EORA	4,S
	EORB	5,S
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 21 	i3 = a << 3;
; Debug: sl int = const 3 to int a = [S+2-2] (used reg = )
	LDD	0,S
	LSLB
	ROLA
	LSLB
	ROLA
	LSLB
	ROLA
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 22 	i3 = a >> 2;
; Debug: sr int = const 2 to int a = [S+2-2] (used reg = )
	LDD	0,S
	ASRA
	RORB
	ASRA
	RORB
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 23 	i3 = a << b;
; Debug: sl int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>isl
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 24 	i3 = a >> b;
; Debug: sr int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>isr
; Debug: eq int = D+0 to int = [i3+0] (used reg = )
	STD	>_i3
;BCC_EOS
; 25 	return a * 10 + b;
; Debug: mul int = const $A to int a = [S+2-2] (used reg = )
	LDD	0,S
	PSHS	D
	LSLB
	ROLA
	LSLB
	ROLA
	ADDD	,S++
	LSLB
	ROLA
; Debug: add int b = [S+2+2] to int = D+0 (used reg = )
	ADDD	4,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 26 }
; 27 
; 28 unsigned uarith(a,b)
; 29 unsigned a, b;
	EXPORT	_uarith
_uarith:
;BCC_EOS
; 30 {
; 31 	u2 = a / b;
	PSHS	X
; Debug: div unsigned int b = [S+2+2] to unsigned int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>idivu
; Debug: eq unsigned int = D+0 to unsigned int = [u2+0] (used reg = )
	STD	>_u2
;BCC_EOS
; 32 	u2 = a % b;
; Debug: mod unsigned int b = [S+2+2] to unsigned int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>imodu
; Debug: eq unsigned int = D+0 to unsigned int = [u2+0] (used reg = )
	STD	>_u2
;BCC_EOS
; 33 	u2 = a >> 1;
; Debug: sr int = const 1 to unsigned int a = [S+2-2] (used reg = )
	LDD	0,S
	LSRA
	RORB
; Debug: eq unsigned int = D+0 to unsigned int = [u2+0] (used reg = )
	STD	>_u2
;BCC_EOS
; 34 	u2 = a >> b;
; Debug: sr unsigned int b = [S+2+2] to unsigned int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>isru
; Debug: eq unsigned int = D+0 to unsigned int = [u2+0] (used reg = )
	STD	>_u2
;BCC_EOS
; 35 	return a * b;
; Debug: mul unsigned int b = [S+2+2] to unsigned int a = [S+2-2] (used reg = )
	LDD	0,S
	LDX	4,S
	JSR	>imulu
; Debug: cast unsigned int = const 0 to unsigned int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 36 }
; 37 
; 38 int chars()
; 39 {
	EXPORT	_chars
_chars:
; 40 	c2 = c1 + 1;
; Debug: add int = const 1 to char = [c1+0] (used reg = )
	LDB	>_c1
	CLRA
; Debug: eq int = D+1 to char = [c2+0] (used reg = )
	ADDD	#1
	STB	>_c2
;BCC_EOS
; 41 	c2 = uc >> 1;
; Debug: sr int = const 1 to unsigned char = [uc+0] (used reg = )
	LDB	>_uc
	CLRA
	LSRA
	RORB
; Debug: eq unsigned int = D+0 to char = [c2+0] (used reg = )
	STB	>_c2
;BCC_EOS
; 42 	c2 = c1 * 3;
; Debug: mul int = const 3 to char = [c1+0] (used reg = )
	LDB	>_c1
	CLRA
	PSHS	D
	LSLB
	ROLA
	ADDD	,S++
; Debug: eq int = D+0 to char = [c2+0] (used reg = )
	STB	>_c2
;BCC_EOS
; 43 	return c1 + uc;
; Debug: add unsigned char = [uc+0] to char = [c1+0] (used reg = )
	LDB	>_c1
	CLRA
	ADDB	>_uc
	ADCA	#0
; Debug: cast int = const 0 to unsigned int = D+0 (used reg = )
	TFR	D,X
	RTS
;BCC_EOS
; 44 }
; 45 
; 46 int compare(a,b)
; 47 int a, b;
	EXPORT	_compare
_compare:
;BCC_EOS
; 48 {
; 49 	int n = 0;
	PSHS	D,X
; Debug: eq int = const 0 to int n = [S+4-4] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 50 
; 51 	if (a == b) n++;
; Debug: logeq int b = [S+4+2] to int a = [S+4-2] (used reg = )
	LDD	2,S
	SUBD	6,S
		BNE	.1
.2:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 52 	if (a != b) n++;
.1:
; Debug: ne int b = [S+4+2] to int a = [S+4-2] (used reg = )
	LDD	2,S
	SUBD	6,S
		BEQ	.3
.4:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 53 	if (a < b) n++;
.3:
; Debug: lt int b = [S+4+2] to int a = [S+4-2] (used reg = )
	LDD	2,S
	SUBD	6,S
		BGE	.5
.6:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 54 	if (a <= b) n++;
.5:
; Debug: le int b = [S+4+2] to int a = [S+4-2] (used reg = )
	LDD	2,S
	SUBD	6,S
		BGT	.7
.8:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 55 	if (a > b) n++;
.7:
; Debug: gt int b = [S+4+2] to int a = [S+4-2] (used reg = )
	LDD	2,S
	SUBD	6,S
		BLE	.9
.A:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 56 	if (a >= b) n++;
.9:
; Debug: ge int b = [S+4+2] to int a = [S+4-2] (used reg = )
	LDD	2,S
	SUBD	6,S
		BLT	.B
.C:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 57 	if (u1 < u2) n++;
.B:
; Debug: lt unsigned int = [u2+0] to unsigned int = [u1+0] (used reg = )
	LDD	>_u1
	SUBD	>_u2
		BHS	.D
.E:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 58 	if (u1 > 30000) n++;
.D:
; Debug: gt int = const $7530 to unsigned int = [u1+0] (used reg = )
	LDD	>_u1
	SUBD	#$7530
		BLS	.F
.10:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 59 	if (a && b) n++;
.F:
	LDD	2,S
		BEQ	.11
.13:
	LDD	6,S
		BEQ	.11
.12:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 60 	if (a || !b) n++;
.11:
	LDD	2,S
		BNE	.15
.16:
	LDD	6,S
		BNE	.14
.15:
; Debug: postinc int n = [S+4-4] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 61 	return n + (a < b ? a : b);
.14:
; Debug: lt int b = [S+4+2] to int a = [S+4-2] (used reg = )
	LDD	2,S
	SUBD	6,S
		BGE	.17
.18:
	LDD	2,S
	BRA	.19
.17:
	LDD	6,S
.19:
; Debug: add int = D+0 to int n = [S+4-4] (used reg = )
; Debug: expression subtree swapping
	ADDD	0,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	U,Y,PC
;BCC_EOS
; 62 }
; 63 
; 64 int incdec()
; 65 {
	EXPORT	_incdec
_incdec:
; 66 	int x = 5, y;
	LEAS	-2,S
; Debug: eq int = const 5 to int x = [S+2-2] (used reg = )
	LDD	#5
	STD	0,S
;BCC_EOS
; 67 
; 68 	y = x++;
	LEAS	-2,S
; Debug: postinc int x = [S+4-2] (used reg = )
	LDD	2,S
	ADDD	#1
	STD	2,S
; Debug: eq int = D-1 to int y = [S+4-4] (used reg = )
	ADDD	#-1
	STD	0,S
;BCC_EOS
; 69 	y = ++x;
; Debug: preinc int x = [S+4-2] (used reg = )
	LDD	2,S
	ADDD	#1
	STD	2,S
; Debug: eq int = D+0 to int y = [S+4-4] (used reg = )
	STD	0,S
;BCC_EOS
; 70 	y = x--;
; Debug: postdec int x = [S+4-2] (used reg = )
	LDD	2,S
	ADDD	#-1
	STD	2,S
; Debug: eq int = D+1 to int y = [S+4-4] (used reg = )
	ADDD	#1
	STD	0,S
;BCC_EOS
; 71 	y = --x;
; Debug: predec int x = [S+4-2] (used reg = )
	LDD	2,S
	ADDD	#-1
	STD	2,S
; Debug: eq int = D+0 to int y = [S+4-4] (used reg = )
	STD	0,S
;BCC_EOS
; 72 	x += 3; x -= 2; x *= 4; x /= 2; x %= 7;
; Debug: addab int = const 3 to int x = [S+4-2] (used reg = )
	LDD	2,S
	ADDD	#3
	STD	2,S
;BCC_EOS
; Debug: subab int = const 2 to int x = [S+4-2] (used reg = )
	LDD	2,S
	ADDD	#-2
	STD	2,S
;BCC_EOS
; Debug: mulab int = const 4 to int x = [S+4-2] (used reg = )
	LDD	2,S
	LSLB
	ROLA
	LSLB
	ROLA
	STD	2,S
;BCC_EOS
; Debug: divab int = const 2 to int x = [S+4-2] (used reg = )
	LDD	2,S
	TSTA
	BGE	.1A
	ADDD	#1
.1A:
	ASRA
	RORB
	STD	2,S
;BCC_EOS
; Debug: modab int = const 7 to int x = [S+4-2] (used reg = )
	LDD	2,S
	LDX	#7
	JSR	>imod
	STD	2,S
;BCC_EOS
; 73 	x <<= 1; x >>= 1; x &= 0x0f; x |= 0x30; x ^= 0x11;
; Debug: slab int = const 1 to int x = [S+4-2] (used reg = )
	LDD	2,S
	LSLB
	ROLA
	STD	2,S
;BCC_EOS
; Debug: srab int = const 1 to int x = [S+4-2] (used reg = )
	LDD	2,S
	ASRA
	RORB
	STD	2,S
;BCC_EOS
; Debug: andab int = const $F to int x = [S+4-2] (used reg = )
	LDB	3,S
	ANDB	#$F
	CLRA
	STD	2,S
;BCC_EOS
; Debug: orab int = const $30 to int x = [S+4-2] (used reg = )
	LDD	2,S
	ORB	#$30
	STD	2,S
;BCC_EOS
; Debug: eorab int = const $11 to int x = [S+4-2] (used reg = )
	LDD	2,S
	EORB	#$11
	STD	2,S
;BCC_EOS
; 74 	return x + y;
; Debug: add int y = [S+4-4] to int x = [S+4-2] (used reg = )
	LDD	2,S
	ADDD	0,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	U,Y,PC
;BCC_EOS
; 75 }
; 76 
	LOC	3
_i3		COMM	2
_c2		COMM	1
_u2		COMM	2

; 0 errors detected
