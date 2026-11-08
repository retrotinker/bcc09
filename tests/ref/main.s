; 1 
; 1 # 1 "main.c"
; 1  
; 2 
; 3 extern int loops(), select(), ptrs();
;BCC_EOS
; 4 
; 5 int result[4];
;BCC_EOS
; 6 
; 7 int main()
; 8 {
	EXPORT	_main
_main:
; 9 	result[0] = loops(12);
; Debug: rootlist int = const $C (used reg = )
	LDX	#$C
; Debug: func () int = loops+0 (used reg = )
	JSR	>_loops
; Debug: eq int = X+0 to int = [result+0] (used reg = )
	STX	>_result
;BCC_EOS
; 10 	result[1] = select(7) + select(1);
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () int = select+0 (used reg = )
	JSR	>_select
	PSHS	X
; Debug: rootlist int = const 7 (used reg = )
	LDX	#7
; Debug: func () int = select+0 (used reg = )
	JSR	>_select
; Debug: add int (temp) = [S+2-2] to int = X+0 (used reg = )
	TFR	X,D
	ADDD	,S++
; Debug: eq int = D+0 to int = [result+2] (used reg = )
	STD	>_result+2
;BCC_EOS
; 11 	result[2] = ptrs();
; Debug: func () int = ptrs+0 (used reg = )
	JSR	>_ptrs
; Debug: eq int = X+0 to int = [result+4] (used reg = )
	STX	>_result+4
;BCC_EOS
; 12 	result[3] = result[0] + result[1] + result[2];
; Debug: add int = [result+2] to int = [result+0] (used reg = )
	LDD	>_result
	ADDD	>_result+2
; Debug: add int = [result+4] to int = D+0 (used reg = )
	ADDD	>_result+4
; Debug: eq int = D+0 to int = [result+6] (used reg = )
	STD	>_result+6
;BCC_EOS
; 13 	return 0;
	LDX	#0
	RTS
;BCC_EOS
; 14 }
; 15 
	LOC	3
_result		COMM	8

; 0 errors detected
