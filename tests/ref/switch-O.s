; 1 
; 1 # 1 "switch.c"
; 1  
; 2 
; 3 int dense(n)
; 4 int n;
EXPORT	_dense
_dense:
;BCC_EOS
; 5 {
; 6 	switch (n) {
PSHS	X
LDD	0,S
BRA	.3
; 7 	case 1: return 11;
.4:
LDX	#$B
PULS	Y,PC
;BCC_EOS
; 8 	case 2: return 22;
.5:
LDX	#$16
PULS	Y,PC
;BCC_EOS
; 9 	case 3: return 33;
.6:
LDX	#$21
PULS	Y,PC
;BCC_EOS
; 10 	case 4: return 44;
.7:
LDX	#$2C
PULS	Y,PC
;BCC_EOS
; 11 	case 5: return 55;
.8:
LDX	#$37
PULS	Y,PC
;BCC_EOS
; 12 	case 6: return 66;
.9:
LDX	#$42
PULS	Y,PC
;BCC_EOS
; 13 	}
; 14 	return -1;
BRA	.1
.3:
SUBD	#1
LBLT	.1
CMPD	#5
LBHI	.A
LSLB
ROLA
LDX	#.B
JMP	[D,X]
.B:
FDB	.4
FDB	.5
FDB	.6
FDB	.7
FDB	.8
FDB	.9
.A:
.1:
..FFFF		EQU	-2
LDX	#-1
PULS	Y,PC
;BCC_EOS
; 15 }
; 16 
; 0 errors detected
