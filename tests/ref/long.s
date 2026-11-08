; 1 
; 1 # 1 "long.c"
; 1  
; 2 
; 3 long l1 = 100000L, l2 = -5L, l3;
	LOC	3
	EXPORT	_l1
_l1:
	FDB	1
	FDB	$86A0
	EXPORT	_l2
_l2:
	FDB	$FFFF
	FDB	$FFFB
;BCC_EOS
; 4 unsigned long ul = 0x80000000UL;
	EXPORT	_ul
_ul:
	FDB	$8000
	FDB	0
;BCC_EOS
; 5 int i;
;BCC_EOS
; 6 
; 7 long lops(a,b)
; 8 long a, b;
	LOC	0
	EXPORT	_lops
_lops:
;BCC_EOS
; 9 {
; 10 	l3 = a + b;
	PSHS	D,X
; Debug: add long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LEAY	6,S
	JSR	>ladd_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 11 	l3 = a - b;
; Debug: sub long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LEAY	6,S
	JSR	>lsub_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 12 	l3 = a * b;
; Debug: mul long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LEAY	6,S
	JSR	>lmul_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 13 	l3 = a / b;
; Debug: div long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LEAY	6,S
	JSR	>ldiv_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 14 	l3 = a % b;
; Debug: mod long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LEAY	6,S
	JSR	>lmod_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 15 	l3 = a & b;
; Debug: and long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LEAY	6,S
	JSR	>land_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 16 	l3 = a | b;
; Debug: or long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LEAY	6,S
	JSR	>lor_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 17 	l3 = a ^ b;
; Debug: eor long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LEAY	6,S
	JSR	>leor_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 18 	l3 = -a;
; Debug: neg long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	JSR	>lneg_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 19 	l3 = ~a;
; Debug: not long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	JSR	>lcom_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 20 	l3 = a << 4;
; Debug: sl int = const 4 to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LDY	#4
	JSR	>lsl_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 21 	l3 = a >> 4;
; Debug: sr int = const 4 to long a = [S+4-4] (used reg = )
	LDD	0,S
	LDX	2,S
	LDY	#4
	JSR	>lsr_b
; Debug: eq long = X+0 to long = [l3+0] (used reg = )
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 22 	ul = ul >> 3;
; Debug: sr int = const 3 to unsigned long = [ul+0] (used reg = )
	LDD	>_ul
	LDX	>_ul+2
	LDY	#3
	JSR	>lsru_b
; Debug: eq unsigned long = X+0 to unsigned long = [ul+0] (used reg = )
	STD	>_ul
	STX	>_ul+2
;BCC_EOS
; 23 	if (a < b) l3++;
; Debug: lt long b = [S+4+2] to long a = [S+4-4] (used reg = )
	LDD	6,S
	LDX	8,S
	LEAY	0,S
	JSR	>lcmp_b
		BLE	.1
.2:
; Debug: postinc long = [l3+0] (used reg = )
	LDD	>_l3
	LDU	>_l3+2
	LDX	#_l3
	JSR	>linc_b
;BCC_EOS
; 24 	if (a == 0) l3--;
.1:
; Debug: logeq long = const 0 to long a = [S+4-4] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	LDX	#0
	PSHS	D,X
	LDD	4,S
	LDX	6,S
	LEAY	0,S
	JSR	>lcmp_b
	LEAS	4,S
		BNE	.3
.4:
; Debug: postdec long = [l3+0] (used reg = )
	LDD	>_l3
	LDU	>_l3+2
	LDX	#_l3
	JSR	>ldec_b
;BCC_EOS
; 25 	return a * 3L;
.3:
; Debug: mul long = const 3 to long a = [S+4-4] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	LDX	#3
	LEAY	0,S
	JSR	>lmul_b
; Debug: cast long = const 0 to long = X+0 (used reg = )
	PULS	U,Y,PC
;BCC_EOS
; 26 }
; 27 
; 28 int conv()
; 29 {
	EXPORT	_conv
_conv:
; 30 	l3 = i;
; Debug: eq int = [i+0] to long = [l3+0] (used reg = )
	LDD	>_i
	TFR	D,X
	CLRB
	ROLA
	SBCB	#0
	SEX
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 31 	i = l1;
; Debug: eq long = [l1+0] to int = [i+0] (used reg = )
	LDD	>_l1+2
	STD	>_i
;BCC_EOS
; 32 	l3 = (unsigned)i;
; Debug: eq unsigned int = [i+0] to long = [l3+0] (used reg = )
	LDD	>_i
	EXG	D,X
	LDD	#0
	STD	>_l3
	STX	>_l3+2
;BCC_EOS
; 33 	ul = 65536L * i;
; Debug: cast long = const 0 to int = [i+0] (used reg = )
	LDD	>_i
	TFR	D,X
	CLRB
	ROLA
	SBCB	#0
	SEX
; Debug: mul long = X+0 to long = const $10000 (used reg = )
	PSHS	D,X
	LDD	#1
	LDX	#0
	LEAY	0,S
	JSR	>lmul_b
	LEAS	4,S
; Debug: eq long = X+0 to unsigned long = [ul+0] (used reg = )
	STD	>_ul
	STX	>_ul+2
;BCC_EOS
; 34 	return (int)(l1 >> 16);
; Debug: sr int = const $10 to long = [l1+0] (used reg = )
	LDD	>_l1
	LDX	>_l1+2
	TFR	D,X
	CLRB
	ROLA
	SBCB	#0
	SEX
; Debug: cast int = const 0 to long = X+0 (used reg = )
	TFR	X,D
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	RTS
;BCC_EOS
; 35 }
; 36 
	LOC	3
_i		COMM	2
_l3		COMM	4

; 0 errors detected
