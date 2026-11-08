; 1 
; 1 # 1 "proto.c"
; 1  
; 2 
; 3 int add();
;BCC_EOS
; 4 static long widen();
;BCC_EOS
; 5 
; 6 int add(a,b)
; 7 # 6 "proto.c"
; 6 int a;
	EXPORT	_add
_add:
;BCC_EOS
; 7 # 6 "proto.c"
; 6 int b;
;BCC_EOS
; 7 {
; 8 	return a + b;
	PSHS	X
; Debug: add int b = [S+2+2] to int a = [S+2-2] (used reg = )
	LDD	0,S
	ADDD	4,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 9 }
; 10 
; 11 static long widen(x)
; 12 # 11 "proto.c"
; 11 int x;
_widen:
;BCC_EOS
; 12 {
; 13 	return (long)x << 8;
	PSHS	X
; Debug: cast long = const 0 to int x = [S+2-2] (used reg = )
	LDD	0,S
	TFR	D,X
	CLRB
	ROLA
	SBCB	#0
	SEX
; Debug: sl int = const 8 to long = X+0 (used reg = )
	LDY	#8
	JSR	>lsl_b
; Debug: cast long = const 0 to long = X+0 (used reg = )
	PULS	Y,PC
;BCC_EOS
; 14 }
; 15 
; 16 unsigned char clip(v)
; 17 # 16 "proto.c"
; 16 unsigned int v;
	EXPORT	_clip
_clip:
;BCC_EOS
; 17 {
; 18 	return v > 255 ? 255 : (unsigned char)v;
	PSHS	X
; Debug: gt int = const $FF to unsigned int v = [S+2-2] (used reg = )
	LDD	0,S
	SUBD	#$FF
		BLS	.2
.3:
	LDD	#$FF
	BRA	.4
.2:
; Debug: cast unsigned int = const 0 to unsigned char v = [S+2-1] (used reg = )
	LDB	1,S
	CLRA
.4:
; Debug: cast unsigned char = const 0 to unsigned int = D+0 (used reg = )
	TFR	B,X
	PULS	Y,PC
;BCC_EOS
; 19 }
; 20 
; 21 int use()
; 22 {
	EXPORT	_use
_use:
; 23 	return add(clip(300),(int)widen(2));
; Debug: rootlist int = const 2 (used reg = )
	LDX	#2
; Debug: func () long = widen+0 (used reg = )
	JSR	>_widen
; Debug: cast int = const 0 to long = X+0 (used reg = )
	TFR	X,D
; Debug: list int = D+0 (used reg = )
	PSHS	D
; Debug: rootlist int = const $12C (used reg = )
	LDX	#$12C
; Debug: func () unsigned char = clip+0 (used reg = )
	JSR	>_clip
	TFR	PC,D
; Debug: rootlist unsigned char = X+0 (used reg = )
	TFR	X,B
	CLRA
	TFR	D,X
; Debug: func () int = add+0 (used reg = )
	JSR	>_add
	LEAS	2,S
; Debug: cast int = const 0 to int = X+0 (used reg = )
	RTS
;BCC_EOS
; 24 }
; 25 

; 0 errors detected
