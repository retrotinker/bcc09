; 1 
; 1 # 1 "helpmain.c"
; 1 
; 2  
; 3 
; 4 extern long lops();
;BCC_EOS
; 5 extern double fops();
;BCC_EOS
; 6 extern int arith(), structs(), calls();
;BCC_EOS
; 7 
; 8 int main()
; 9 {
EXPORT	_main
_main:
; 10 	lops(1L,2L);
; Debug: list long = const 2 (used reg = )
CLRA
CLRB
LDX	#2
PSHS	D,X
; Debug: rootlist long = const 1 (used reg = )
CLRA
CLRB
LDX	#1
; Debug: func () long = lops+0 (used reg = )
JSR	>_lops
LEAS	-$4,S
; Debug: list double = const (whatever) (used reg = )
CLRA
CLRB
PSHS	D
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
PSHS	D
CLRA
CLRB
PSHS	D
LDD	#$3FF0
PSHS	D
; Debug: func () double = fops+0 (used reg = )
JSR	>_fops
LEAS	$10,S
STD	0,S
STX	2,S
STU	6,S
STY	4,S
LEAS	8,S
;BCC_EOS
; 12 	arith(3,4);
; Debug: list int = const 4 (used reg = )
LDD	#4
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () int = arith+0 (used reg = )
JSR	>_arith
LEAS	2,S
;BCC_EOS
; 13 	structs();
; Debug: func () int = structs+0 (used reg = )
JSR	>_structs
;BCC_EOS
; 14 	calls();
; Debug: func () int = calls+0 (used reg = )
JSR	>_calls
;BCC_EOS
; 15 	return 0;
LDX	#0
RTS
;BCC_EOS
; 16 }
; 17 
; 0 errors detected
