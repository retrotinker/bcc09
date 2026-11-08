; 1 
; 1 # 1 "float.c"
; 1  
; 2 
; 3 float f1 = 1.5;
	LOC	3
	EXPORT	_f1
_f1:
	FDB	$3FC0
	FDB	0
;BCC_EOS
; 4 double d1 = 2.25, d2;
	EXPORT	_d1
_d1:
	FDB	$4002
	FDB	0
	FDB	0
	FDB	0
;BCC_EOS
; 5 
; 6 double fops(a,b)
; 7 double a, b;
	LOC	0
	EXPORT	_fops
_fops:
;BCC_EOS
; 8 {
; 9 	d2 = a + b;
; Debug: add double b = [S+0+$A] to double a = [S+0+2] (used reg = )
	LEAX	2,S
	JSR	>Fpushd
	LEAX	$12,S
	JSR	>Faddd
; Debug: eq double (temp) = [S+8-8] to double = [d2+0] (used reg = )
	LDX	#_d2
	JSR	>Fpulld
;BCC_EOS
; 10 	d2 = a - b;
; Debug: sub double b = [S+0+$A] to double a = [S+0+2] (used reg = )
	LEAX	2,S
	JSR	>Fpushd
	LEAX	$12,S
	JSR	>Fsubd
; Debug: eq double (temp) = [S+8-8] to double = [d2+0] (used reg = )
	LDX	#_d2
	JSR	>Fpulld
;BCC_EOS
; 11 	d2 = a * b;
; Debug: mul double b = [S+0+$A] to double a = [S+0+2] (used reg = )
	LEAX	2,S
	JSR	>Fpushd
	LEAX	$12,S
	JSR	>Fmuld
; Debug: eq double (temp) = [S+8-8] to double = [d2+0] (used reg = )
	LDX	#_d2
	JSR	>Fpulld
;BCC_EOS
; 12 	d2 = a / b;
; Debug: div double b = [S+0+$A] to double a = [S+0+2] (used reg = )
	LEAX	2,S
	JSR	>Fpushd
	LEAX	$12,S
	JSR	>Fdivd
; Debug: eq double (temp) = [S+8-8] to double = [d2+0] (used reg = )
	LDX	#_d2
	JSR	>Fpulld
;BCC_EOS
; 13 	if (a < b)
; Debug: lt double b = [S+0+$A] to double a = [S+0+2] (used reg = )
	LEAX	2,S
	JSR	>Fpushd
	LEAX	$12,S
	JSR	>Fcompd
		BGE	.1
.2:
; 14 		d2 = -d2;
; Debug: neg double = [d2+0] (used reg = )
	LDX	#_d2
	JSR	>Fnegd
; Debug: eq double (temp) = [S+8-8] to double = [d2+0] (used reg = )
	LDX	#_d2
	JSR	>Fpulld
;BCC_EOS
; 15 	return a * 2.0;
.1:
; Debug: mul double = const (whatever) to double a = [S+0+2] (used reg = )
; Debug: expression subtree swapping
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#0
	PSHS	D
	LDD	#$4000
	PSHS	D
	LEAX	$A,S
	JSR	>Fmuld
; Debug: cast double = const (whatever) to double (temp) = [S+8-8] (used reg = )
	PULS	D,X,U,Y
	RTS
;BCC_EOS
; 16 }
; 17 
; 18 int fconv(i)
; 19 int i;
	EXPORT	_fconv
_fconv:
;BCC_EOS
; 20 {
; 21 	f1 = i;
	PSHS	X
; Debug: eq int i = [S+2-2] to float = [f1+0] (used reg = )
	LDD	0,S
	JSR	>Fpushi
	LEAX	0,S
	JSR	>dtof
	LDD	,S++
	STD	>_f1
	LDD	,S++
	STD	>_f1+2
	LEAS	$C,S
;BCC_EOS
; 22 	d2 = f1;
; Debug: eq float = [f1+0] to double = [d2+0] (used reg = )
	LDX	#_f1
	JSR	>Fpushf
	LDX	#_d2
	JSR	>Fpulld
;BCC_EOS
; 23 	return (int)(d1 * i);
; Debug: cast double = const (whatever) to int i = [S+2-2] (used reg = )
	LDD	0,S
	JSR	>Fpushi
; Debug: mul double (temp) = [S+$A-$A] to double = [d1+0] (used reg = )
	LDX	#_d1
	JSR	>Fpushd
	JSR	>Fmul
; Debug: cast int = const 0 to double (temp) = [S+$A-$A] (used reg = )
	LEAX	0,S
	JSR	>dtoi
	LEAS	8,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 24 }
; 25 
	LOC	3
_d2		COMM	8

; 0 errors detected
