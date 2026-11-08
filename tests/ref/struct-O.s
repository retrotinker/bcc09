; 1 
; 1 # 1 "struct.c"
; 1  
; 2 
; 3 typedef struct point {
; 4 	int x, y;
;BCC_EOS
; 5 } point;
;BCC_EOS
; 6 
; 7 struct rec {
; 8 	char tag;
;BCC_EOS
; 9 	int count;
;BCC_EOS
; 10 	long total;
;BCC_EOS
; 11 	point where;
;BCC_EOS
; 12 	struct rec *next;
;BCC_EOS
; 13 	char name[6];
;BCC_EOS
; 14 };
;BCC_EOS
; 15 
; 16 union num {
; 17 	long l;
;BCC_EOS
; 18 	int i[2];
;BCC_EOS
; 19 	char c[4];
;BCC_EOS
; 20 };
;BCC_EOS
; 21 
; 22 struct flags {
; 23 	unsigned ready : 1;
;BCC_EOS
; 24 	unsigned mode : 3;
;BCC_EOS
; 25 	unsigned level : 4;
;BCC_EOS
; 26 };
;BCC_EOS
; 27 
; 28 struct rec r1, r2 = { 'a', 3, 70000L, { 1, 2 }, &r1, "abc"};
LOC	3
EXPORT	_r2
_r2:
FCB	$61
FDB	3
FDB	1
FDB	$1170
FDB	1
FDB	2
FDB	_r1
.1:
FCC	"abc"
FCB	0
RMB	2
;BCC_EOS
; 29 union num n;
;BCC_EOS
; 30 struct flags f;
;BCC_EOS
; 31 point pts[4];
;BCC_EOS
; 32 
; 33 int area(p,q)
; 34 point *p, *q;
LOC	0
EXPORT	_area
_area:
;BCC_EOS
; 35 {
; 36 	return (q->x - p->x) * (q->y - p->y);
PSHS	X
LDX	0,S
LDU	4,S
; Debug: sub int = [X+2] to int = [U+2] (used reg = )
LDD	2,U
SUBD	2,X
PSHS	D
; Debug: sub int p = [[S+4-2]] to int q = [[S+4+2]] (used reg = )
LDD	[6,S]
SUBD	[2,S]
; Debug: mul int (temp) = [S+4-4] to int = D+0 (used reg = )
LDX	,S++
JSR	>imul
; Debug: cast int = const 0 to int = D+0 (used reg = )
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 37 }
; 38 
; 39 int structs()
; 40 {
EXPORT	_structs
_structs:
; 41 	struct rec *rp = &r2;
LEAS	-2,S
; Debug: eq * struct rec = r2+0 to * struct rec rp = [S+2-2] (used reg = )
LDX	#_r2
STX	0,S
;BCC_EOS
; 42 
; 43 	r1 = r2;
; Debug: eq struct rec = [r2+0] to struct rec = [r1+0] (used reg = )
LDD	#$13
PSHS	D
LDX	#_r2
PSHS	X
LDX	#_r1
JSR	>_memcpy
LEAS	4,S
;BCC_EOS
; 44 	r1.where.x = rp->next->count;
LDX	0,S
LDX	$B,X
; Debug: eq int = [X+1] to int = [r1+7] (used reg = )
LDX	1,X
STX	>_r1+7
;BCC_EOS
; 45 	rp->next->name[0] = 'z';
LDX	0,S
LDX	$B,X
; Debug: ptradd int = const 0 to [6] char = X+$D (used reg = )
; Debug: eq int = const $7A to char = [X+$D] (used reg = )
LDB	#$7A
STB	$D,X
;BCC_EOS
; 46 	pts[2].y = sizeof(struct rec);
; Debug: eq int = const $13 to int = [pts+$A] (used reg = )
LDD	#$13
STD	>_pts+$A
;BCC_EOS
; 47 	n.l = 0x12345678L;
; Debug: eq long = const $12345678 to long = [n+0] (used reg = )
LDD	#$1234
LDX	#$5678
STD	>_n
STX	>_n+2
;BCC_EOS
; 48 	f.ready = 1;
; Debug: eq int = const 1 to unsigned char = [f+0] (used reg = )
LDB	#1
STB	>_f
;BCC_EOS
; 49 	f.mode = 5;
; Debug: eq int = const 5 to unsigned char = [f+1] (used reg = )
LDB	#5
STB	>_f+1
CLRA
; Debug: eq unsigned int = D+2 to unsigned char = [f+2] (used reg = )
ADDD	#2
STB	>_f+2
;BCC_EOS
; 51 	return area(&pts[0],&pts[1]) + n.i[1] + n.c[3] + f.level;
; Debug: list * struct point = pts+4 (used reg = )
LDX	#_pts+4
PSHS	X
; Debug: rootlist * struct point = pts+0 (used reg = )
LDX	#_pts
; Debug: func () int = area+0 (used reg = )
JSR	>_area
LEAS	2,S
; Debug: add int = [n+2] to int = X+0 (used reg = )
TFR	X,D
ADDD	>_n+2
; Debug: add char = [n+3] to int = D+0 (used reg = )
ADDB	>_n+3
ADCA	#0
; Debug: add unsigned char = [f+2] to int = D+0 (used reg = )
ADDB	>_f+2
ADCA	#0
; Debug: cast int = const 0 to unsigned int = D+0 (used reg = )
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 52 }
; 53 
LOC	3
_n		COMM	4
_f		COMM	3
_pts		COMM	$10
_r1		COMM	$13
; 0 errors detected
