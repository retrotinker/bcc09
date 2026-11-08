; 1 
; 1 # 1 "control.c"
; 1  
; 2 
; 3 int select(n)
; 4 int n;
	EXPORT	_select
_select:
;BCC_EOS
; 5 {
; 6 	switch (n) {
	PSHS	X
	LDD	0,S
	BRA	.3
; 7 	case 0:
; 8 		return 10;
.4:
	LDX	#$A
	PULS	Y,PC
;BCC_EOS
; 9 	case 1:
; 10 	case 2:
.5:
; 11 		n += 5;
.6:
; Debug: addab int = const 5 to int n = [S+2-2] (used reg = )
	LDD	0,S
	ADDD	#5
	STD	0,S
;BCC_EOS
; 12 		break;
	BRA	.1
;BCC_EOS
; 13 	case 7:
; 14 		n = -n;
.7:
; Debug: neg int n = [S+2-2] (used reg = )
	LDD	#0
	SUBD	0,S
; Debug: eq int = D+0 to int n = [S+2-2] (used reg = )
	STD	0,S
;BCC_EOS
; 15 		 
; 16 	case 8:
; 17 		n *= 2;
.8:
; Debug: mulab int = const 2 to int n = [S+2-2] (used reg = )
	LDD	0,S
	LSLB
	ROLA
	STD	0,S
;BCC_EOS
; 18 		break;
	BRA	.1
;BCC_EOS
; 19 	case 100:
; 20 		return 1;
.9:
	LDX	#1
	PULS	Y,PC
;BCC_EOS
; 21 	default:
; 22 		n = 0;
.A:
; Debug: eq int = const 0 to int n = [S+2-2] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 23 	}
; 24 	return n;
	BRA	.1
.3:
	SUBD	#0
	BEQ	.4
	SUBD	#1
	BEQ	.5
	SUBD	#1
	BEQ	.6
	SUBD	#5
	BEQ	.7
	SUBD	#1
	BEQ	.8
	SUBD	#$5C
	BEQ	.9
	BRA	.A
.1:
..FFFF		EQU	-2
	LDX	0,S
	PULS	Y,PC
;BCC_EOS
; 25 }
; 26 
; 27 int loops(n)
; 28 int n;
	EXPORT	_loops
_loops:
;BCC_EOS
; 29 {
; 30 	int i, j, t = 0;
	PSHS	X
	LEAS	-6,S
; Debug: eq int = const 0 to int t = [S+8-8] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 31 
; 32 	for (i = 0; i < n; i++) {
; Debug: eq int = const 0 to int i = [S+8-4] (used reg = )
	LDD	#0
	STD	4,S
;BCC_EOS
;BCC_EOS
	BRA	.D
.E:
; 33 		if (i == 3)
; Debug: logeq int = const 3 to int i = [S+8-4] (used reg = )
	LDX	4,S
	LEAX	-3,X
	LBNE	.F
.10:
; 34 			continue;
	BRA	.C
;BCC_EOS
; 35 		if (i > 10)
.F:
; Debug: gt int = const $A to int i = [S+8-4] (used reg = )
	LDD	4,S
	SUBD	#$A
	LBLE	.11
.12:
; 36 			break;
	BRA	.B
;BCC_EOS
; 37 		t += i;
.11:
; Debug: addab int i = [S+8-4] to int t = [S+8-8] (used reg = )
	LDD	0,S
	ADDD	4,S
	STD	0,S
;BCC_EOS
; 38 	}
; 39 	while (t > 100)
.C:
; Debug: postinc int i = [S+8-4] (used reg = )
	LDD	4,S
	ADDD	#1
	STD	4,S
.D:
; Debug: lt int n = [S+8-2] to int i = [S+8-4] (used reg = )
	LDD	4,S
	SUBD	6,S
	BLT	.E
.13:
.B:
; 40 		t -= 7;
	BRA	.15
.16:
; Debug: subab int = const 7 to int t = [S+8-8] (used reg = )
	LDD	0,S
	ADDD	#-7
	STD	0,S
;BCC_EOS
; 41 	j = 0;
.15:
; Debug: gt int = const $64 to int t = [S+8-8] (used reg = )
	LDD	0,S
	SUBD	#$64
	BGT	.16
.17:
.14:
; Debug: eq int = const 0 to int j = [S+8-6] (used reg = )
	LDD	#0
	STD	2,S
;BCC_EOS
; 42 	do {
.1A:
; 43 		j++;
; Debug: postinc int j = [S+8-6] (used reg = )
	LDD	2,S
	ADDD	#1
	STD	2,S
;BCC_EOS
; 44 	} while (j < n);
.19:
; Debug: lt int n = [S+8-2] to int j = [S+8-6] (used reg = )
	LDD	2,S
	SUBD	6,S
	BLT	.1A
.1B:
;BCC_EOS
; 45 	for (;;) {
.18:
;BCC_EOS
;BCC_EOS
.1E:
; 46 		if (--j <= 0)
; Debug: predec int j = [S+8-6] (used reg = )
	LDD	2,S
	ADDD	#-1
	STD	2,S
; Debug: le int = const 0 to int = D+0 (used reg = )
	SUBD	#0
	LBGT	.1F
.20:
; 47 			goto out;
	LEAS	..FFFE+8,S
	BRA	.FFFE
;BCC_EOS
; 48 	}
.1F:
; 49 out:
.1D:
	BRA	.1E
.1C:
.FFFE:
..FFFE		=	-8
; 50 	for (i = 0,j = n; i < j; i++,j--)
; Debug: eq int = const 0 to int i = [S+8-4] (used reg = )
	LDD	#0
	STD	4,S
; Debug: eq int n = [S+8-2] to int j = [S+8-6] (used reg = )
	LDD	6,S
	STD	2,S
;BCC_EOS
;BCC_EOS
; 51 		t = t ? t + 1 : 1;
	BRA	.23
.24:
	LDD	0,S
	LBEQ	.25
.26:
; Debug: add int = const 1 to int t = [S+8-8] (used reg = )
	LDD	0,S
	ADDD	#1
	BRA	.27
.25:
	LDD	#1
.27:
; Debug: eq int = D+0 to int t = [S+8-8] (used reg = )
	STD	0,S
;BCC_EOS
; 52 	return t;
.22:
; Debug: postinc int i = [S+8-4] (used reg = )
	LDD	4,S
	ADDD	#1
	STD	4,S
; Debug: postdec int j = [S+8-6] (used reg = )
	LDD	2,S
	ADDD	#-1
	STD	2,S
.23:
; Debug: lt int j = [S+8-6] to int i = [S+8-4] (used reg = )
	LDD	4,S
	SUBD	2,S
	BLT	.24
.28:
.21:
	LDX	0,S
	LEAS	8,S
	RTS
;BCC_EOS
; 53 }
; 54 

; 0 errors detected
