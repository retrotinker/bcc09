; 1 
; 1 # 1 "asmseg.c"
; 1 
; 2 
; 3 
; 4  
; 5 
; 6 int a = 1;
	LOC	3
	EXPORT	_a
_a:
	FDB	1
;BCC_EOS
; 7 #asm
;BCC_ASM
	loc	12
	fcb	8
; 10 endasm
;BCC_ENDASM
; 11 int b = 2;
	LOC	3
	EXPORT	_b
_b:
	FDB	2
;BCC_EOS
; 12 
; 13 int f()
; 14 {
	LOC	0
	EXPORT	_f
_f:
; 15 	return a;
	LDX	>_a
	RTS
;BCC_EOS
; 16 }
; 17 
; 18 asm("loc 12","fcb 9");
;BCC_ASM
	loc 12
	fcb 9
;BCC_ENDASM
;BCC_EOS
; 19 
; 20 int g()
; 21 {
	LOC	0
	EXPORT	_g
_g:
; 22 	asm("nop");
;BCC_ASM
	nop
;BCC_ENDASM
;BCC_EOS
; 23 	return b;
	LDX	>_b
	RTS
;BCC_EOS
; 24 }
; 25 
; 26 char *s = "x";
	LOC	3
	EXPORT	_s
_s:
	LOC	1
.1:
	FCC	"x"
	FCB	0
	LOC	3
	FDB	.1+0
;BCC_EOS
; 27 
; 28 char *h()
; 29 {
	LOC	0
	EXPORT	_h
_h:
; 30 	asm("loc 0");
;BCC_ASM
	loc 0
;BCC_ENDASM
;BCC_EOS
; 31 	return "y";
	LOC	1
.2:
	FCC	"y"
	FCB	0
	LOC	0
	LDX	#.2
	RTS
;BCC_EOS
; 32 }
; 33 

; 0 errors detected
