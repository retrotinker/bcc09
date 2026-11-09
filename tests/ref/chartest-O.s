; 1 
; 1 # 1 "chartest.c"
; 1 # 7
; 7  
; 8 # 8 "../prefix.tmp/lib/bcc09/include/stdio.h"
; 8  
; 9 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 17
; 17  
; 18 # 32
; 32  
; 33 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 10 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 10 # 14
; 14 typedef unsigned int size_t;	 
;BCC_EOS
; 15 
; 16 typedef int ssize_t;
;BCC_EOS
; 17 typedef int ptrdiff_t;
;BCC_EOS
; 18 
; 19 typedef long off_t;
;BCC_EOS
; 20 typedef long time_t;
;BCC_EOS
; 21 typedef unsigned int mode_t;
;BCC_EOS
; 22 typedef long ino_t;
;BCC_EOS
; 23 # 44 "../prefix.tmp/lib/bcc09/include/stdio.h"
; 44  
; 45 struct __stdio_file {
; 46   unsigned char *bufpos;    
;BCC_EOS
; 47   unsigned char *bufread;   
;BCC_EOS
; 48   unsigned char *bufwrite;  
;BCC_EOS
; 49   unsigned char *bufstart;  
;BCC_EOS
; 50   unsigned char *bufend;
;BCC_EOS
; 51     
; 52 
; 53   int fd;  
;BCC_EOS
; 54   int mode;
;BCC_EOS
; 55 
; 56   char unbuf[8];	    
;BCC_EOS
; 57 
; 58   struct __stdio_file * next;
;BCC_EOS
; 59 };
;BCC_EOS
; 60 # 66
; 66 typedef struct __stdio_file FILE;
;BCC_EOS
; 67 
; 68 
; 69 
; 70 extern FILE stdin[1];
;BCC_EOS
; 71 extern FILE stdout[1];
;BCC_EOS
; 72 extern FILE stderr[1];
;BCC_EOS
; 73 # 90
; 90  
; 91 
; 92 
; 93  
; 94 
; 95  
; 96 
; 97 extern int setvbuf () __proto(FILE*,char*,int,size_t);
;BCC_EOS
; 98 
; 99  
; 100 
; 101 extern void setbuffer () __proto(FILE*,char*,int);
;BCC_EOS
; 102 
; 103 extern int fgetc () __proto(FILE*);
;BCC_EOS
; 104 extern int fputc () __proto(int,FILE*);
;BCC_EOS
; 105 extern int ungetc () __proto(int,FILE*);
;BCC_EOS
; 106 
; 107 extern int fclose () __proto(FILE*);
;BCC_EOS
; 108 extern int fflush () __proto(FILE*);
;BCC_EOS
; 109 extern char *fgets () __proto(char*,int,FILE*);
;BCC_EOS
; 110 extern char *gets () __proto(char*);		 
;BCC_EOS
; 111 extern size_t fread () __proto(void*,size_t,size_t,FILE*);
;BCC_EOS
; 112 extern size_t fwrite () __proto(void*,size_t,size_t,FILE*);
;BCC_EOS
; 113 
; 114 extern FILE *fopen () __proto(char*,char*);
;BCC_EOS
; 115 extern int remove () __proto(char*);
;BCC_EOS
; 116 extern FILE *fdopen () __proto(int,char*);
;BCC_EOS
; 117 extern FILE *freopen  () __proto(char*,char*,FILE*);
;BCC_EOS
; 118 extern FILE *__fopen () __proto(char*,int,FILE*,char*);
;BCC_EOS
; 119 
; 120 extern int fseek () __proto(FILE*,long,int);
;BCC_EOS
; 121 extern long ftell () __proto(FILE*);
;BCC_EOS
; 122 extern void rewind () __proto(FILE*);
;BCC_EOS
; 123 
; 124 extern int fputs () __proto(char*,FILE*);
;BCC_EOS
; 125 extern int puts () __proto(char*);
;BCC_EOS
; 126 
; 127 extern int printf () __proto(char*,...);
;BCC_EOS
; 128 extern int fprintf () __proto(FILE*,char*,...);
;BCC_EOS
; 129 extern int sprintf () __proto(char*,char*,...);
;BCC_EOS
; 130 extern int snprintf () __proto(char*,size_t,char*,...);
;BCC_EOS
; 131  
; 132 extern int vprintf () _
; 132 _proto(char*,char*);
;BCC_EOS
; 133 extern int vfprintf () __proto(FILE*,char*,char*);
;BCC_EOS
; 134 extern int vsprintf () __proto(char*,char*,char*);
;BCC_EOS
; 135 extern int vsnprintf () __proto(char*,size_t,char*,char*);
;BCC_EOS
; 136 
; 137 extern int scanf () __proto(char*,...);
;BCC_EOS
; 138 extern int fscanf () __proto(FILE*,char*,...);
;BCC_EOS
; 139 extern int sscanf () __proto(char*,char*,...);
;BCC_EOS
; 140 extern int vscanf () __proto(char*,char*);
;BCC_EOS
; 141 extern int vfscanf () __proto(FILE*,char*,char*);
;BCC_EOS
; 142 extern int vsscanf () __proto(char*,char*,char*);
;BCC_EOS
; 143 # 11 "chartest.c"
; 11 int checks, failures;
;BCC_EOS
; 12 
; 13 void ok(n,cond) __proto(int n,int cond)
; 14 # 13 "chartest.c"
; 13 int n;
EXPORT	_ok
_ok:
;BCC_EOS
; 14 # 13 "chartest.c"
; 13 int cond;
;BCC_EOS
; 14 {
; 15 	++checks;
PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
LDD	>_checks
ADDD	#1
STD	>_checks
;BCC_EOS
; 16 	if (!cond) {
LDD	4,S
BNE	.1
.2:
; 17 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
LDD	>_failures
ADDD	#1
STD	>_failures
;BCC_EOS
; 18 		printf("FAIL %d\n",n);
LOC	1
.3:
FCC	"FAIL %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+2-2] (used reg = )
LDD	0,S
PSHS	D
; Debug: rootlist * char = .3+0 (used reg = )
LDX	#.3
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 19 	}
; 20 }
.1:
PULS	Y,PC
; 21 
; 22 unsigned char uc_low(v) __proto(unsigned int v)
; 23 # 22 "chartest.c"
; 22 unsigned int v;
EXPORT	_uc_low
_uc_low:
;BCC_EOS
; 23 {
; 24 	return (unsigned char) v;
PSHS	X
LDB	1,S
CLRA
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 25 }
; 26 
; 27 signed char sc_low(v) __proto(int v)
; 28 # 27 "chartest.c"
; 27 int v;
EXPORT	_sc_low
_sc_low:
;BCC_EOS
; 28 {
; 29 	return (signed char) v;
PSHS	X
LDB	1,S
SEX
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 30 }
; 31 
; 32 unsigned char uc_clip(v) __proto(unsigned int v)
; 33 # 32 "chartest.c"
; 32 unsigned int v;
EXPORT	_uc_clip
_uc_clip:
;BCC_EOS
; 33 {
; 34 	return v > 255 ? 255 : (unsigned char) v;
PSHS	X
; Debug: gt int = const $FF to unsigned int v = [S+2-2] (used reg = )
LDD	0,S
SUBD	#$FF
BLS	.4
.5:
LDD	#$FF
BRA	.6
.4:
; Debug: cast unsigned int = const 0 to unsigned char v = [S+2-1] (used reg = )
LDB	1,S
CLRA
.6:
; Debug: cast unsigned char = const 0 to unsigned int = D+0 (used reg = )
CLRA
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 35 }
; 36 
; 37 unsigned char uc_add(a,b) __proto(unsigned char a,unsigned char b)
; 38 # 37 "chartest.c"
; 37 unsigned char a;
EXPORT	_uc_add
_uc_add:
;BCC_EOS
; 38 # 37 "chartest.c"
; 37 unsigned char b;
;BCC_EOS
; 38 {
; 39 	return a + b;			 
PSHS	X
; Debug: add unsigned char b = [S+2+3] to unsigned char a = [S+2-1] (used reg = )
LDB	1,S
CLRA
ADDB	5,S
ADCA	#0
; Debug: cast unsigned char = const 0 to unsigned int = D+0 (used reg = )
CLRA
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 40 }
; 41 
; 42 signed char sc_neg(c) __proto(signed char c)
; 43 # 42 "chartest.c"
; 42 signed char c;
EXPORT	_sc_neg
_sc_neg:
;BCC_EOS
; 43 {
; 44 	return -c;
PSHS	X
; Debug: neg char c = [S+2-1] (used reg = )
LDB	1,S
SEX
PSHS	D
CLRA
CLRB
SUBD	,S++
; Debug: cast char = const 0 to int = D+0 (used reg = )
SEX
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 45 }
; 46 
; 47 int widen(a,b) __proto(unsigned char a,signed char b)
; 48 # 47 "chartest.c"
; 47 unsigned char a;
EXPORT	_widen
_widen:
;BCC_EOS
; 48 # 47 "chartest.c"
; 47 signed char b;
;BCC_EOS
; 48 {
; 49 	return a * 100 + b;
PSHS	X
; Debug: mul int = const $64 to unsigned char a = [S+2-1] (used reg = )
LDB	1,S
CLRA
PSHS	D
LSLB
ROLA
ADDD	,S
LSLB
ROLA
LSLB
ROLA
LSLB
ROLA
ADDD	,S++
LSLB
ROLA
LSLB
ROLA
; Debug: add char b = [S+2+3] to unsigned int = D+0 (used reg = )
PSHS	D
LDB	7,S
SEX
PSHS	D
LDD	2,S
ADDD	,S++
LEAS	2,S
; Debug: cast int = const 0 to unsigned int = D+0 (used reg = )
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 50 }
; 51 
; 52  
; 53 int second(a,b,c) __proto(int a,unsigned char b,signed char c)
; 54 # 53 "chartest.c"
; 53 int a;
EXPORT	_second
_second:
;BCC_EOS
; 54 # 53 "chartest.c"
; 53 unsigned char b;
;BCC_EOS
; 54 # 53 "chartest.c"
; 53 signed char c;
;BCC_EOS
; 54 {
; 55 	return a + b * 2 + c;
PSHS	X
; Debug: mul int = const 2 to unsigned char b = [S+2+3] (used reg = )
LDB	5,S
CLRA
LSLB
ROLA
; Debug: add unsigned int = D+0 to int a = [S+2-2] (used reg = )
; Debug: expression subtree swapping
ADDD	0,S
; Debug: add char c = [S+2+5] to unsigned int = D+0 (used reg = )
PSHS	D
LDB	9,S
SEX
PSHS	D
LDD	2,S
ADDD	,S++
LEAS	2,S
; Debug: cast int = const 0 to unsigned int = D+0 (used reg = )
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 56 }
; 57 
; 58 unsigned char uc_rec(n) __proto(unsigned char n)
; 59 # 58 "chartest.c"
; 58 unsigned char n;
EXPORT	_uc_rec
_uc_rec:
;BCC_EOS
; 59 {
; 60 	return n == 0 ? 0 : uc_rec(n - 1) + 2;
PSHS	X
; Debug: logeq int = const 0 to unsigned char n = [S+2-1] (used reg = )
LDB	1,S
BNE	.7
.8:
LDD	#0
BRA	.9
.7:
; Debug: sub int = const 1 to unsigned char n = [S+2-1] (used reg = )
LDB	1,S
CLRA
; Debug: cast unsigned char = const 0 to unsigned int = D-1 (used reg = )
ADDD	#-1
; Debug: rootlist unsigned char = B+0 (used reg = )
CLRA
TFR	D,X
; Debug: func () unsigned char = uc_rec+0 (used reg = )
JSR	>_uc_rec
TFR	X,D
; Debug: add int = const 2 to unsigned char = B+0 (used reg = )
CLRA
ADDD	#2
.9:
; Debug: cast unsigned char = const 0 to unsigned int = D+0 (used reg = )
CLRA
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 61 }
; 62 
; 63 unsigned char (*ucp)() __proto(unsigned int)= uc_low;
LOC	3
EXPORT	_ucp
_ucp:
FDB	_uc_low
;BCC_EOS
; 64 
; 65 
; 66 char c_low(v) __proto(int v)
; 67 # 66 "chartest.c"
; 66 int v;
LOC	0
EXPORT	_c_low
_c_low:
;BCC_EOS
; 67 {
; 68 	return (char) v;
PSHS	X
LDB	1,S
CLRA
TFR	D,X
PULS	Y,PC
;BCC_EOS
; 69 }
; 70 
; 71 
; 72 int main()
; 73 {
EXPORT	_main
_main:
; 74 	unsigned char u;
;BCC_EOS
; 75 	signed char s;
;BCC_EOS
; 76 
; 77 	printf("%d %d %d %d\n",uc_low(0x1234),uc_low(300),uc_low(255),
LEAS	-2,S
LOC	1
.A:
FCC	"%d %d %d %d"
FCB	$A
FCB	0
LOC	0
; 78 uc_low(0));
; Debug: rootlist unsigned int = const 0 (used reg = )
LDX	#0
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist unsigned int = const $FF (used reg = )
LDX	#$FF
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist unsigned int = const $12C (used reg = )
LDX	#$12C
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist unsigned int = const $1234 (used reg = )
LDX	#$1234
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist * char = .A+0 (used reg = )
LDX	#.A
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	8,S
;BCC_EOS
; 79 	printf("%d %d %d %d\n",sc_low(0x1234),sc_low(200),sc_low(-1),
LOC	1
.B:
FCC	"%d %d %d %d"
FCB	$A
FCB	0
LOC	0
; 80 sc_lo
; 80 w(127));
; Debug: rootlist int = const $7F (used reg = )
LDX	#$7F
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist int = const -1 (used reg = )
LDX	#-1
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist int = const $C8 (used reg = )
LDX	#$C8
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist int = const $1234 (used reg = )
LDX	#$1234
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist * char = .B+0 (used reg = )
LDX	#.B
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	8,S
;BCC_EOS
; 81 	printf("%d %d %d\n",uc_clip(300),uc_clip(77),uc_clip(256));
LOC	1
.C:
FCC	"%d %d %d"
FCB	$A
FCB	0
LOC	0
; Debug: rootlist unsigned int = const $100 (used reg = )
LDX	#$100
; Debug: func () unsigned char = uc_clip+0 (used reg = )
JSR	>_uc_clip
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist unsigned int = const $4D (used reg = )
LDX	#$4D
; Debug: func () unsigned char = uc_clip+0 (used reg = )
JSR	>_uc_clip
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist unsigned int = const $12C (used reg = )
LDX	#$12C
; Debug: func () unsigned char = uc_clip+0 (used reg = )
JSR	>_uc_clip
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist * char = .C+0 (used reg = )
LDX	#.C
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 82 	printf("%d %d\n",uc_add(200,100),uc_add(1,2));
LOC	1
.D:
FCC	"%d %d"
FCB	$A
FCB	0
LOC	0
; Debug: list unsigned char = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: rootlist unsigned char = const 1 (used reg = )
LDX	#1
; Debug: func () unsigned char = uc_add+0 (used reg = )
JSR	>_uc_add
TFR	X,D
LEAS	2,S
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: list unsigned char = const $64 (used reg = )
LDD	#$64
PSHS	D
; Debug: rootlist unsigned char = const $C8 (used reg = )
LDX	#$C8
; Debug: func () unsigned char = uc_add+0 (used reg = )
JSR	>_uc_add
TFR	X,D
LEAS	2,S
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist * char = .D+0 (used reg = )
LDX	#.D
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 83 	printf("%d %d %d\n",sc_neg(5),sc_neg(-128),sc_neg(0));
LOC	1
.E:
FCC	"%d %d %d"
FCB	$A
FCB	0
LOC	0
; Debug: rootlist char = const 0 (used reg = )
LDX	#0
; Debug: func () char = sc_neg+0 (used reg = )
JSR	>_sc_neg
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist char = const -$80 (used reg = )
LDX	#-$80
; Debug: func () char = sc_neg+0 (used reg = )
JSR	>_sc_neg
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist char = const 5 (used reg = )
LDX	#5
; Debug: func () char = sc_neg+0 (used reg = )
JSR	>_sc_neg
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist * char = .E+0 (used reg = )
LDX	#.E
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 84 	printf("%d %d\n",widen(uc_low(250),sc_low(-3)),
LOC	1
.F:
FCC	"%d %d"
FCB	$A
FCB	0
LOC	0
; 85 widen(uc_add(255,1),sc_neg(7)));
; Debug: rootlist char = const 7 (used reg = )
LDX	#7
; Debug: func () char = sc_neg+0 (used reg = )
JSR	>_sc_neg
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: list unsigned char = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist unsigned char = const $FF (used reg = )
LDX	#$FF
; Debug: func () unsigned char = uc_add+0 (used reg = )
JSR	>_uc_add
TFR	X,D
LEAS	2,S
; Debug: rootlist unsigned char = B+0 (used reg = )
CLRA
TFR	D,X
; Debug: func () int = widen+0 (used reg = )
JSR	>_widen
LEAS	2,S
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const -3 (used reg = )
LDX	#-3
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist unsigned int = const $FA (used reg = )
LDX	#$FA
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: rootlist unsigned char = B+0 (used reg = )
CLRA
TFR	D,X
; Debug: func () int = widen+0 (used reg = )
JSR	>_widen
LEAS	2,S
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist * char = .F+0 (used reg = )
LDX	#.F
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 86 	printf("%d %d\n",second(10,uc_low(0x1ff),sc_low(-1)),
LOC	1
.10:
FCC	"%d %d"
FCB	$A
FCB	0
LOC	0
; 87 second(uc_clip(9),200,-100));
; Debug: list char = const -$64 (used reg = )
LDD	#-$64
PSHS	D
; Debug: list unsigned char = const $C8 (used reg = )
LDD	#$C8
PSHS	D
; Debug: rootlist unsigned int = const 9 (used reg = )
LDX	#9
; Debug: func () unsigned char = uc_clip+0 (used reg = )
JSR	>_uc_clip
TFR	X,D
; Debug: cast int = const 0 to unsigned char = B+0 (used reg = )
CLRA
; Debug: rootlist int = D+0 (used reg = )
TFR	D,X
; Debug: func () int = second+0 (used reg = )
JSR	>_second
LEAS	4,S
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist int = const -1 (used reg = )
LDX	#-1
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: list char = B+0 (used reg = )
SEX
PSHS	D
; Debug: rootlist unsigned int = const $1FF (used reg = )
LDX	#$1FF
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const $A (used reg = )
LDX	#$A
; Debug: func () int = second+0 (used reg = )
JSR	>_second
LEAS	4,S
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist * char = .10+0 (used reg = )
LDX	#.10
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 88 	printf("%d %d\n",uc_rec(10),uc_rec(200));
LOC	1
.11:
FCC	"%d %d"
FCB	$A
FCB	0
LOC	0
; Debug: rootlist unsigned char = const $C8 (used reg = )
LDX	#$C8
; Debug: func () unsigned char = uc_rec+0 (used reg = )
JSR	>_uc_rec
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist unsigned char = const $A (used reg = )
LDX	#$A
; Debug: func () unsigned char = uc_rec+0 (used reg = )
JSR	>_uc_rec
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist * char = .11+0 (used reg = )
LDX	#.11
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 89 	printf("%d\n",(*ucp)(0x4142));
LOC	1
.12:
FCC	"%d"
FCB	$A
FCB	0
LOC	0
; Debug: rootlist unsigned int = const $4142 (used reg = )
LDX	#$4142
; Debug: func () unsigned char = [ucp+0] (used reg = )
JSR	[>_ucp]
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist * char = .12+0 (used reg = )
LDX	#.12
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 90 
; 91 	 
; 92 	u = uc_low(0x81);
; Debug: rootlist unsigned int = const $81 (used reg = )
LDX	#$81
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: eq unsigned char = B+0 to unsigned char u = [S+2-1] (used reg = )
STB	1,S
;BCC_EOS
; 93 	s = sc_low(0x81);
; Debug: rootlist int = const $81 (used reg = )
LDX	#$81
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: eq char = B+0 to char s = [S+2-2] (used reg = )
STB	0,S
;BCC_EOS
; 94 	printf("%d %d %d\n",u,s,uc_low(3)+ sc_low(-5)* 2);
LOC	1
.13:
FCC	"%d %d %d"
FCB	$A
FCB	0
LOC	0
; Debug: rootlist int = const -5 (used reg = )
LDX	#-5
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: mul int = const 2 to char = B+0 (used reg = )
SEX
LSLB
ROLA
PSHS	D
; Debug: rootlist unsigned int = const 3 (used reg = )
LDX	#3
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: add int (temp) = [S+4-4] to unsigned char = B+0 (used reg = )
CLRA
ADDD	,S++
; Debug: list unsigned int = D+0 (used reg = )
PSHS	D
; Debug: list char s = [S+4-2] (used reg = )
LDB	2,S
SEX
PSHS	D
; Debug: list unsigned char u = [S+6-1] (used reg = )
LDB	5,S
CLRA
PSHS	D
; Debug: rootlist * char = .13+0 (used reg = )
LDX	#.13
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 95 	ok(1,u == 0x81 && s == -127);
; Debug: logeq int = const $81 to unsigned char u = [S+2-1] (used reg = )
LDB	1,S
SUBB	#$81
BNE	.14
.16:
; Debug: logeq int = const -$7F to char s = [S+2-2] (used reg = )
LDB	0,S
SEX
SUBD	#-$7F
BNE	.14
.15:
LDB	#1
BRA	.17
.14:
CLRB
.17:
; Debug: cast int = const 0 to char = B+0 (used reg = )
CLRA
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 96 	ok(2,uc_low(0x1234)== 0x34 && sc_low(0xff)== -1);
; Debug: rootlist unsigned int = const $1234 (used reg = )
LDX	#$1234
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: logeq int = const $34 to unsigned char = B+0 (used reg = )
SUBB	#$34
BNE	.18
.1A:
; Debug: rootlist int = const $FF (used reg = )
LDX	#$FF
; Debug: func () char = sc_low+0 (used reg = )
JSR	>_sc_low
TFR	X,D
; Debug: logeq int = const -1 to char = B+0 (used reg = )
SEX
SUBD	#-1
BNE	.18
.19:
LDB	#1
BRA	.1B
.18:
CLRB
.1B:
; Debug: cast int = const 0 to char = B+0 (used reg = )
CLRA
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 97 	ok(3,uc_add(uc_low(250),uc_low(10))== 4);
; Debug: rootlist unsigned int = const $A (used reg = )
LDX	#$A
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: list unsigned char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist unsigned int = const $FA (used reg = )
LDX	#$FA
; Debug: func () unsigned char = uc_low+0 (used reg = )
JSR	>_uc_low
TFR	X,D
; Debug: rootlist unsigned char = B+0 (used reg = )
CLRA
TFR	D,X
; Debug: func () unsigned char = uc_add+0 (used reg = )
JSR	>_uc_add
TFR	X,D
LEAS	2,S
; Debug: logeq int = const 4 to unsigned char = B+0 (used reg = )
SUBB	#4
BNE	.1C
LDB	#1
BRA	.1D
.1C:
CLRB
.1D:
; Debug: cast int = const 0 to char = B+0 (used reg = )
CLRA
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 98 
; 99 	ok(4,c_low(0x1fe)== 0xfe);	 
; Debug: rootlist int = const $1FE (used reg = )
LDX	#$1FE
; Debug: func () char = c_low+0 (used reg = )
JSR	>_c_low
TFR	X,D
; Debug: logeq int = const $FE to char = B+0 (used reg = )
SUBB	#$FE
BNE	.1E
LDB	#1
BRA	.1F
.1E:
CLRB
.1F:
; Debug: cast int = const 0 to char = B+0 (used reg = )
CLRA
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 100 
; 101 	printf("checks %d failures %d\n",checks,failures);
LOC	1
.20:
FCC	"checks %d failures %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int = [failures+0] (used reg = )
LDD	>_failures
PSHS	D
; Debug: list int = [checks+0] (used reg = )
LDD	>_checks
PSHS	D
; Debug: rootlist * char = .20+0 (used reg = )
LDX	#.20
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 102 	return failures;
LDX	>_failures
PULS	Y,PC
;BCC_EOS
; 103 }
; 104 
LOC	3
_checks		COMM	2
_failures		COMM	2
; 0 errors detected
