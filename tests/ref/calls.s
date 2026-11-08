; 1 
; 1 # 1 "calls.c"
; 1  
; 2 
; 3 extern int ext_func();
;BCC_EOS
; 4 extern int ext_var;
;BCC_EOS
; 5 
; 6 static int counter;
;BCC_EOS
; 7 
; 8 static int square(x)
; 9 int x;
_square:
;BCC_EOS
; 10 {
; 11 	return x * x;
	PSHS	X
; Debug: mul int x = [S+2-2] to int x = [S+2-2] (used reg = )
	LDD	0,S
	LDX	0,S
	JSR	>imul
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 12 }
; 13 
; 14 int fact(n)
; 15 int n;
	EXPORT	_fact
_fact:
;BCC_EOS
; 16 {
; 17 	return n <= 1 ? 1 : n * fact(n - 1);
	PSHS	X
; Debug: le int = const 1 to int n = [S+2-2] (used reg = )
	LDD	0,S
	SUBD	#1
	LBGT	.1
.2:
	LDD	#1
	BRA	.3
.1:
; Debug: sub int = const 1 to int n = [S+2-2] (used reg = )
	LDD	0,S
; Debug: rootlist int = D-1 (used reg = )
	ADDD	#-1
	TFR	D,X
; Debug: func () int = fact+0 (used reg = )
	JSR	>_fact
; Debug: mul int = X+0 to int n = [S+2-2] (used reg = )
	LDD	0,S
	JSR	>imul
.3:
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 18 }
; 19 
; 20 int apply(f,a)
; 21 int (*f)();
	EXPORT	_apply
_apply:
;BCC_EOS
; 22 int a;
;BCC_EOS
; 23 {
; 24 	return (*f)(a) + f(a + 1);
	PSHS	X
; Debug: add int = const 1 to int a = [S+2+2] (used reg = )
	LDD	4,S
; Debug: rootlist int = D+1 (used reg = )
	ADDD	#1
	TFR	D,X
; Debug: func () int f = [S+2-2] (used reg = )
	JSR	[0,S]
	PSHS	X
; Debug: rootlist int a = [S+4+2] (used reg = )
	LDX	6,S
; Debug: func () int f = [S+4-2] (used reg = )
	JSR	[2,S]
; Debug: add int (temp) = [S+4-4] to int = X+0 (used reg = )
	TFR	X,D
	ADDD	,S++
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 25 }
; 26 
; 27 int many(a,b,c,d,e)
; 28 char a;
	EXPORT	_many
_many:
;BCC_EOS
; 29 int b;
;BCC_EOS
; 30 long c;
;BCC_EOS
; 31 char *d;
;BCC_EOS
; 32 int e;
;BCC_EOS
; 33 {
; 34 	return a + b + (int)c + *d + e;
	PSHS	X
; Debug: add int b = [S+2+2] to char a = [S+2-1] (used reg = )
	LDB	1,S
	CLRA
	ADDD	4,S
; Debug: add int c = [S+2+6] to int = D+0 (used reg = )
	ADDD	8,S
; Debug: add char d = [[S+2+8]] to int = D+0 (used reg = )
	ADDB	[$A,S]
	ADCA	#0
; Debug: add int e = [S+2+$A] to int = D+0 (used reg = )
	ADDD	$C,S
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 35 }
; 36 
; 37 int next_id()
; 38 {
	EXPORT	_next_id
_next_id:
; 39 	static int id = 100;
	LOC	3
.4:
	FDB	$64
	LOC	0
;BCC_EOS
; 40 
; 41 	return id++;
; Debug: postinc int = [.4+0] (used reg = )
	LDD	>.4
	ADDD	#1
	STD	>.4
; Debug: cast int = const 0 to int = D-1 (used reg = )
	ADDD	#-1
	TFR	D,X
	RTS
;BCC_EOS
; 42 }
; 43 
; 44 int calls()
; 45 {
	EXPORT	_calls
_calls:
; 46 	register int r;
;BCC_EOS
; 47 	int (*fp)()= square;
	LEAS	-4,S
; Debug: eq () int = square+0 to * () int fp = [S+4-4] (used reg = )
	LDX	#_square
	STX	0,S
;BCC_EOS
; 48 
; 49 	counter++;
; Debug: postinc int = [counter+0] (used reg = )
	LDD	>_counter
	ADDD	#1
	STD	>_counter
;BCC_EOS
; 50 	r = apply(fp,3);
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: rootlist * () int fp = [S+6-4] (used reg = )
	LDX	2,S
; Debug: func () int = apply+0 (used reg = )
	JSR	>_apply
	LEAS	2,S
; Debug: eq int = X+0 to int r = [S+4-2] (used reg = )
	STX	2,S
;BCC_EOS
; 51 	r += many('x',2,3L,"q",5);
	LOC	1
.5:
	FCC	"q"
	FCB	0
	LOC	0
; Debug: list int = const 5 (used reg = )
	LDD	#5
	PSHS	D
; Debug: list * char = .5+0 (used reg = )
	LDX	#.5
	PSHS	X
; Debug: list long = const 3 (used reg = )
	LDD	#0
	LDX	#3
	PSHS	D,X
; Debug: list int = const 2 (used reg = )
	LDD	#2
	PSHS	D
; Debug: rootlist int = const $78 (used reg = )
	LDX	#$78
; Debug: func () int = many+0 (used reg = )
	JSR	>_many
	LEAS	$A,S
; Debug: addab int = X+0 to int r = [S+4-2] (used reg = )
	TFR	X,D
	ADDD	2,S
	STD	2,S
;BCC_EOS
; 52 	r += ext_func(ext_var,counter);
; Debug: list int = [counter+0] (used reg = )
	LDD	>_counter
	PSHS	D
; Debug: rootlist int = [ext_var+0] (used reg = )
	LDX	>_ext_var
; Debug: func () int = ext_func+0 (used reg = )
	JSR	>_ext_func
	LEAS	2,S
; Debug: addab int = X+0 to int r = [S+4-2] (used reg = )
	TFR	X,D
	ADDD	2,S
	STD	2,S
;BCC_EOS
; 53 	return r + fact(5) + next_id();
; Debug: func () int = next_id+0 (used reg = )
	JSR	>_next_id
	LEAS	-2,S
	PSHS	X
; Debug: rootlist int = const 5 (used reg = X)
	LDX	#5
; Debug: func () int = fact+0 (used reg = X)
	JSR	>_fact
	STX	2,S
	PULS	X
; Debug: add int (temp) = [S+6-6] to int r = [S+6-2] (used reg = X)
	LDD	4,S
	ADDD	,S++
; Debug: add int = X+0 to int = D+0 (used reg = )
	LEAX	D,X
; Debug: cast int = const 0 to int = X+0 (used reg = )
	PULS	U,Y,PC
;BCC_EOS
; 54 }
; 55 
	LOC	3
_counter		LCOMM	2

; 0 errors detected
