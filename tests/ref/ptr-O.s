; 1 
; 1 # 1 "ptr.c"
; 1  
; 2 
; 3 char buf[16];
;BCC_EOS
; 4 int tab[8] = { 1, 2, 3, 5, 8, 13, 21, 34 };
LOC	3
EXPORT	_tab
_tab:
FDB	1
FDB	2
FDB	3
FDB	5
FDB	8
FDB	$D
FDB	$15
FDB	$22
;BCC_EOS
; 5 int grid[3][4];
;BCC_EOS
; 6 char *msg = "hello, world";
EXPORT	_msg
_msg:
LOC	1
.1:
FCC	"hello, world"
FCB	0
LOC	3
FDB	.1+0
;BCC_EOS
; 7 char *msgs[] = { "one", "two", "three"};
EXPORT	_msgs
_msgs:
LOC	1
.2:
FCC	"one"
FCB	0
LOC	3
FDB	.2+0
LOC	1
.3:
FCC	"two"
FCB	0
LOC	3
FDB	.3+0
LOC	1
.4:
FCC	"three"
FCB	0
LOC	3
FDB	.4+0
;BCC_EOS
; 8 int *ip = &tab[2];
EXPORT	_ip
_ip:
FDB	_tab+4
;BCC_EOS
; 9 
; 10 int strlen1(s)
; 11 char *s;
LOC	0
EXPORT	_strlen1
_strlen1:
;BCC_EOS
; 12 {
; 13 	char *p = s;
PSHS	D,X
; Debug: eq * char s = [S+4-2] to * char p = [S+4-4] (used reg = )
LDX	2,S
STX	0,S
;BCC_EOS
; 14 
; 15 	while (*p)
; 16 		p++;
BRA	.6
.7:
; Debug: postinc * char p = [S+4-4] (used reg = )
LDX	0,S
LEAU	1,X
STU	0,S
;BCC_EOS
; 17 	return p - s;
.6:
LDB	[0,S]
BNE	.7
.8:
.5:
; Debug: ptrsub * char s = [S+4-2] to * char p = [S+4-4] (used reg = )
LDD	0,S
SUBD	2,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
PULS	U,Y,PC
;BCC_EOS
; 18 }
; 19 
; 20 void copy(d,s)
; 21 char *d, *s;
EXPORT	_copy
_copy:
;BCC_EOS
; 22 {
; 23 	while ((*d++ = *s++)!= 0)
PSHS	X
; 24 		;
BRA	.A
.B:
;BCC_EOS
; 25 }
.A:
; Debug: postinc * char s = [S+2+2] (used reg = )
LDX	4,S
LEAU	1,X
STU	4,S
; Debug: postinc * char d = [S+2-2] (used reg = X)
LDU	0,S
LEAY	1,U
STY	0,S
; Debug: eq char = [X+0] to char = [U+0] (used reg = )
LDB	0,X
STB	0,U
BNE	.B
.C:
.9:
PULS	Y,PC
; 26 
; 27 int sum(p,n)
; 28 int *p;
EXPORT	_sum
_sum:
;BCC_EOS
; 29 int n;
;BCC_EOS
; 30 {
; 31 	int t = 0;
PSHS	D,X
; Debug: eq int = const 0 to int t = [S+4-4] (used reg = )
LDD	#0
STD	0,S
;BCC_EOS
; 32 
; 33 	while (n-- > 0)
; 34 		t += *p++;
BRA	.E
.F:
; Debug: postinc * int p = [S+4-2] (used reg = )
LDX	2,S
LEAU	2,X
STU	2,S
; Debug: addab int = [X+0] to int t = [S+4-4] (used reg = )
LDD	0,S
ADDD	0,X
STD	0,S
;BCC_EOS
; 35 	return t;
.E:
; Debug: postdec int n = [S+4+2] (used reg = )
LDD	6,S
ADDD	#-1
STD	6,S
; Debug: gt int = const 0 to int = D+1 (used reg = )
ADDD	#1
SUBD	#0
BGT	.F
.10:
.D:
LDX	0,S
PULS	U,Y,PC
;BCC_EOS
; 36 }
; 37 
; 38 int ptrs()
; 39 {
EXPORT	_ptrs
_ptrs:
; 40 	int *q = tab + 3;
LEAS	-2,S
; Debug: eq [8] int = tab+6 to * int q = [S+2-2] (used reg = )
LDX	#_tab+6
STX	0,S
;BCC_EOS
; 41 	int **qq = &q;
LEAS	-2,S
; Debug: eq * * int q = S+4-2 to * * int qq = [S+4-4] (used reg = )
LEAX	2,S
STX	0,S
; Debug: eq int = [[X+0]] to int = [grid+$C] (used reg = )
LDX	[0,X]
STX	>_grid+$C
;BCC_EOS
; 44 	ip[1] = q[-1];
; Debug: ptradd int = const -1 to * int q = [S+4-2] (used reg = )
LDX	2,S
; Debug: ptradd int = const 1 to * int = [ip+0] (used reg = X)
LDU	>_ip
; Debug: eq int = [X-2] to int = [U+2] (used reg = )
LDX	-2,X
STX	2,U
;BCC_EOS
; 45 	copy(buf,msgs[2]);
; Debug: list * char = [msgs+4] (used reg = )
LDX	>_msgs+4
PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
LDX	#_buf
; Debug: func () void = copy+0 (used reg = )
JSR	>_copy
LEAS	2,S
;BCC_EOS
; 46 	return q - tab + sum(tab,8) + strlen1(msg) + grid[1][2] + buf[0];
; Debug: rootlist * char = [msg+0] (used reg = )
LDX	>_msg
; Debug: func () int = strlen1+0 (used reg = )
JSR	>_strlen1
LEAS	-2,S
PSHS	X
; Debug: list int = const 8 (used reg = X)
LDD	#8
PSHS	D
; Debug: rootlist * int = tab+0 (used reg = X)
LDX	#_tab
; Debug: func () int = sum+0 (used reg = X)
JSR	>_sum
LEAS	2,S
STX	2,S
PULS	X
; Debug: ptrsub [8] int = tab+0 to * int q = [S+6-2] (used reg = X)
LDU	#_tab
PSHS	U
LDD	6,S
SUBD	,S++
PSHS	CC
BHS	.11
NEGA
NEGB
SBCA	#0
.11:
LSRA
RORB
PULS	CC
BHS	.12
NEGA
NEGB
SBCA	#0
.12:
; Debug: add int (temp) = [S+6-6] to int = D+0 (used reg = X)
ADDD	,S++
; Debug: add int = X+0 to int = D+0 (used reg = )
LEAX	D,X
; Debug: add int = [grid+$C] to int = X+0 (used reg = )
TFR	X,D
ADDD	>_grid+$C
; Debug: add char = [buf+0] to int = D+0 (used reg = )
ADDB	>_buf
ADCA	#0
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
PULS	U,Y,PC
;BCC_EOS
; 47 }
; 48 
LOC	3
_grid		COMM	$18
_buf		COMM	$10
; 0 errors detected
