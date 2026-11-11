; 1 
; 1 # 1 "direct.c"
; 1 # 6
; 6  
; 7 
; 8 __direct int dx;
;BCC_EOS
; 9 __direct char dc = 5;
	LOC	2
	EXPORT	_dc
_dc:
	FCB	5
;BCC_EOS
; 10 __direct int darr[4] = { 1, 2, 3, 4 };
	EXPORT	_darr
_darr:
	FDB	1
	FDB	2
	FDB	3
	FDB	4
;BCC_EOS
; 11 __direct struct { int a; char b; } ds;
;BCC_EOS
;BCC_EOS
;BCC_EOS
; 12 __direct char *dp;
;BCC_EOS
; 13 __direct long dl = 70000L;
	EXPORT	_dl
_dl:
	FDB	1
	FDB	$1170
;BCC_EOS
; 14 int plain;
;BCC_EOS
; 15 __direct char dmsg[] = "DP";
	EXPORT	_dmsg
_dmsg:
.1:
	FCC	"DP"
	FCB	0
;BCC_EOS
; 16 __direct int *dpi = &plain;
	EXPORT	_dpi
_dpi:
	FDB	_plain
;BCC_EOS
; 17 extern __direct int dext;
;BCC_EOS
; 18 static __direct int dstat;
;BCC_EOS
; 19 
; 20 int f(i)
; 21 int i;
	LOC	0
	EXPORT	_f
_f:
;BCC_EOS
; 22 {
; 23 	static __direct int loc;
	LOC	2
.2		LCOMM	2
	LOC	0
;BCC_EOS
; 24 	int *p;
;BCC_EOS
; 25 
; 26 	dx = 1;
	PSHS	D,X
; Debug: eq int = const 1 to int = [dx+0] (used reg = )
	LDD	#1
	STD	<_dx
;BCC_EOS
; 27 	dc++;
; Debug: postinc char = [dc+0] (used reg = )
	LDB	<_dc
	INCB
	STB	<_dc
;BCC_EOS
; 28 	darr[2] = dx + dc;
; Debug: add char = [dc+0] to int = [dx+0] (used reg = )
	LDD	<_dx
	ADDB	<_dc
	ADCA	#0
; Debug: eq int = D+0 to int = [darr+4] (used reg = )
	STD	<_darr+4
;BCC_EOS
; 29 	darr[i] = 7;
; Debug: ptradd int i = [S+4-2] to [4] int = darr+0 (used reg = )
	LDD	2,S
	LSLB
	ROLA
	LDX	#_darr
	LEAX	D,X
; Debug: eq int = const 7 to int = [X+0] (used reg = )
	LDD	#7
	STD	0,X
;BCC_EOS
; 30 	ds.b = 3;
; Debug: eq int = const 3 to char = [ds+2] (used reg = )
	LDB	#3
	STB	<_ds+2
;BCC_EOS
; 31 	ds.a += 4;
; Debug: addab int = const 4 to int = [ds+0] (used reg = )
	LDD	<_ds
	ADDD	#4
	STD	<_ds
;BCC_EOS
; 32 	p = &dx;
; Debug: eq * int = dx+0 to * int p = [S+4-4] (used reg = )
	LDX	#_dx
	STX	0,S
;BCC_EOS
; 33 	*dp = 9;
; Debug: eq int = const 9 to char = [[dp+0]] (used reg = )
	LDB	#9
	STB	[>_dp]
;BCC_EOS
; 34 	dl += dx;
; Debug: cast long = const 0 to int = [dx+0] (used reg = )
	LDD	<_dx
	TFR	D,X
	CLRB
	ROLA
	SBCB	#0
	SEX
; Debug: addab long = X+0 to long = [dl+0] (used reg = )
	LDY	#_dl
	JSR	>ladd_b
	STD	<_dl
	STX	<_dl+2
;BCC_EOS
; 35 	loc = dext + dstat + plain;
; Debug: add int = [dstat+0] to int = [dext+0] (used reg = )
	LDD	<_dext
	ADDD	<_dstat
; Debug: add int = [plain+0] to int = D+0 (used reg = )
	ADDD	>_plain
; Debug: eq int = D+0 to int = [.2+0] (used reg = )
	STD	<.2
;BCC_EOS
; 36 	p = darr;
; Debug: eq [4] int = darr+0 to * int p = [S+4-4] (used reg = )
	LDX	#_darr
	STX	0,S
;BCC_EOS
; 37 	return loc + darr[3] + *p;
; Debug: add int = [darr+6] to int = [.2+0] (used reg = )
	LDD	<.2
	ADDD	<_darr+6
; Debug: add int p = [[S+4-4]] to int = D+0 (used reg = )
	ADDD	[0,S]
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	U,Y,PC
;BCC_EOS
; 38 }
; 39 
	LOC	3
_plain		COMM	2
	LOC	2
_dstat		LCOMM	2
_ds		COMM	3
_dx		COMM	2
_dp		COMM	2
	IMPORT	_dext

; 0 errors detected
