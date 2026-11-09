; 1 
; 1 # 1 "sftest.c"
; 1 # 5
; 5  
; 6 # 8 "../prefix.tmp/lib/bcc09/include/stdio.h"
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
; 21 # 44 "../prefix.tmp/lib/bcc09/include/stdio.h"
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
; 115 extern FILE *fdopen () __proto(int,char*);
;BCC_EOS
; 116 extern FILE *freopen  () __proto(char*,char*,FILE*);
;BCC_EOS
; 117 extern FILE *__fopen () __proto(char*,int,FILE*,char*);
;BCC_EOS
; 118 
; 119 extern int fseek () __proto(FILE*,long,int);
;BCC_EOS
; 120 extern long ftell () __proto(FILE*);
;BCC_EOS
; 121 extern void rewind () __proto(FILE*);
;BCC_EOS
; 122 
; 123 extern int fputs () __proto(char*,FILE*);
;BCC_EOS
; 124 extern int puts () __proto(char*);
;BCC_EOS
; 125 
; 126 extern int printf () __proto(char*,...);
;BCC_EOS
; 127 extern int fprintf () __proto(FILE*,char*,...);
;BCC_EOS
; 128 extern int sprintf () __proto(char*,char*,...);
;BCC_EOS
; 129 extern int snprintf () __proto(char*,size_t,char*,...);
;BCC_EOS
; 130  
; 131 extern int vprintf () __proto(char*,char*);
;BCC_EOS
; 132 extern int vfprintf () __proto(FILE*,char*,char*);
;BCC_EOS
; 133 extern int vspri
; 133 ntf () __proto(char*,char*,char*);
;BCC_EOS
; 134 extern int vsnprintf () __proto(char*,size_t,char*,char*);
;BCC_EOS
; 135 
; 136 extern int scanf () __proto(char*,...);
;BCC_EOS
; 137 extern int fscanf () __proto(FILE*,char*,...);
;BCC_EOS
; 138 extern int sscanf () __proto(char*,char*,...);
;BCC_EOS
; 139 extern int vscanf () __proto(char*,char*);
;BCC_EOS
; 140 extern int vfscanf () __proto(FILE*,char*,char*);
;BCC_EOS
; 141 extern int vsscanf () __proto(char*,char*,char*);
;BCC_EOS
; 142 # 5 "../prefix.tmp/lib/bcc09/include/string.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/lib/bcc09/include/string.h"
; 9 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/string.h"
; 10 # 5 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 5  
; 6 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 10 # 13 "../prefix.tmp/lib/bcc09/include/string.h"
; 13  
; 14 extern size_t strlen () __proto(char* __str);
;BCC_EOS
; 15 
; 16 extern char * strcat () __proto(char*,char*);
;BCC_EOS
; 17 extern char * strcpy () __proto(char*,char*);
;BCC_EOS
; 18 extern int strcmp () __proto(char*,char*);
;BCC_EOS
; 19 
; 20 extern char * strncat () __proto(char*,char*,size_t);
;BCC_EOS
; 21 extern char * strncpy () __proto(char*,char*,size_t);
;BCC_EOS
; 22 extern int strncmp () __proto(char*,char*,size_t);
;BCC_EOS
; 23 
; 24 extern char * strchr () __proto(char*,int);
;BCC_EOS
; 25 extern char * strrchr () __proto(char*,int);
;BCC_EOS
; 26 extern char * strdup () __proto(char*);
;BCC_EOS
; 27 
; 28  
; 29 extern void * memcpy () __proto(void*,void*,size_t);
;BCC_EOS
; 30 extern void * memccpy () __proto(void*,void*,int,size_t);
;BCC_EOS
; 31 extern void * memchr () __proto(void*,int,size_t);
;BCC_EOS
; 32 extern void * memset () __proto(void*,int,size_t);
;BCC_EOS
; 33 extern int memcmp () __proto(void*,void*,size_t);
;BCC_EOS
; 34 
; 35 extern void * memmove () __proto(void*,void*,size_t);
;BCC_EOS
; 36 
; 37  
; 38 
; 39 
; 40  
; 41 
; 42 
; 43 
; 44  
; 45 extern char * strpbrk () __proto(char *,char *);
;BCC_EOS
; 46 extern char * strsep () __proto(char **,char *);
;BCC_EOS
; 47 extern char * strstr () __proto(char *,char *);
;BCC_EOS
; 48 extern char * strtok () __proto(char *,char *);
;BCC_EOS
; 49 extern size_t strcspn () __proto(char *,char *);
;BCC_EOS
; 50 extern size_t strspn () __proto(char *,char *);
;BCC_EOS
; 51 # 10 "sftest.c"
; 10 int checks, failures;
;BCC_EOS
; 11 
; 12 void ok(n,cond)
; 13 int n, cond;
EXPORT	_ok
_ok:
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
; 19 
; 19 	}
; 20 }
.1:
PULS	Y,PC
; 21 
; 22  
; 23 void ti(fmt,in)
; 24 char *fmt, *in;
EXPORT	_ti
_ti:
;BCC_EOS
; 25 {
; 26 	int a = -99, b = -99, c = -99, d = -99, r;
PSHS	D,X
; Debug: eq int = const -$63 to int a = [S+4-4] (used reg = )
LDD	#-$63
STD	0,S
LEAS	-2,S
; Debug: eq int = const -$63 to int b = [S+6-6] (used reg = )
LDD	#-$63
STD	0,S
LEAS	-2,S
; Debug: eq int = const -$63 to int c = [S+8-8] (used reg = )
LDD	#-$63
STD	0,S
LEAS	-2,S
; Debug: eq int = const -$63 to int d = [S+$A-$A] (used reg = )
LDD	#-$63
STD	0,S
;BCC_EOS
; 27 
; 28 	r = sscanf(in,fmt,&a,&b,&c,&d);
LEAS	-2,S
; Debug: list * int d = S+$C-$A (used reg = )
LEAX	2,S
PSHS	X
; Debug: list * int c = S+$E-8 (used reg = )
LEAX	6,S
PSHS	X
; Debug: list * int b = S+$10-6 (used reg = )
LEAX	$A,S
PSHS	X
; Debug: list * int a = S+$12-4 (used reg = )
LEAX	$E,S
PSHS	X
; Debug: list * char fmt = [S+$14-2] (used reg = )
LDX	$12,S
PSHS	X
; Debug: rootlist * char in = [S+$16+2] (used reg = )
LDX	$18,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	$A,S
; Debug: eq int = X+0 to int r = [S+$C-$C] (used reg = )
STX	0,S
;BCC_EOS
; 29 	printf("[%s] [%s] %d: %d %d %d %d\n",fmt,in,r,a,b,c,d);
LOC	1
.4:
FCC	"[%s] [%s] %d: %d %d %d %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int d = [S+$C-$A] (used reg = )
LDD	2,S
PSHS	D
; Debug: list int c = [S+$E-8] (used reg = )
LDD	6,S
PSHS	D
; Debug: list int b = [S+$10-6] (used reg = )
LDD	$A,S
PSHS	D
; Debug: list int a = [S+$12-4] (used reg = )
LDD	$E,S
PSHS	D
; Debug: list int r = [S+$14-$C] (used reg = )
LDD	8,S
PSHS	D
; Debug: list * char in = [S+$16+2] (used reg = )
LDX	$18,S
PSHS	X
; Debug: list * char fmt = [S+$18-2] (used reg = )
LDX	$16,S
PSHS	X
; Debug: rootlist * char = .4+0 (used reg = )
LDX	#.4
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$1a,S
RTS
; 31 
; 32  
; 33 void tl(fmt,in)
; 34 char *fmt, *in;
EXPORT	_tl
_tl:
;BCC_EOS
; 35 {
; 36 	long a = -99, b = -99;
PSHS	CC,D,X,DP
; Debug: eq int = const -$63 to long a = [S+6-6] (used reg = )
LDD	#$FFFF
LDX	#$FF9D
STD	0,S
STX	2,S
LEAS	-4,S
; Debug: eq int = const -$63 to long b = [S+$A-$A] (used reg = )
LDD	#$FFFF
LDX	#$FF9D
STD	0,S
STX	2,S
;BCC_EOS
; 37 	int r;
;BCC_EOS
; 38 
; 39 	r = sscanf(in,fmt,&a,&b);
LEAS	-2,S
; Debug: list * long b = S+$C-$A (used reg = )
LEAX	2,S
PSHS	X
; Debug: list * long a = S+$E-6 (used reg = )
LEAX	8,S
PSHS	X
; Debug: list * char fmt = [S+$10-2] (used reg = )
LDX	$E,S
PSHS	X
; Debug: rootlist * char in = [S+$12+2] (used reg = )
LDX	$14,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	6,S
; Debug: eq int = X+0 to int r = [S+$C-$C] (used reg = )
STX	0,S
;BCC_EOS
; 40 	printf("[%s] [%s] %d: %ld %ld\n",fmt,in,r,a,b);
LOC	1
.5:
FCC	"[%s] [%s] %d: %ld %ld"
FCB	$A
FCB	0
LOC	0
; Debug: list long b = [S+$C-$A] (used reg = )
LDD	2,S
LDX	4,S
PSHS	D,X
; Debug: list long a = [S+$10-6] (used reg = )
LDD	$A,S
LDX	$C,S
PSHS	D,X
; Debug: list int r = [S+$14-$C] (used reg = )
LDD	8,S
PSHS	D
; Debug: list * char in = [S+$16+2] (used reg = )
LDX	$18,S
PSHS	X
; Debug: list * char fmt = [S+$18-2] (used reg = )
LDX	$16,S
PSHS	X
; Debug: rootlist * char = .5+0 (used reg = )
LDX	#.5
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$1a,S
RTS
; 42 
; 43 void tul(fmt,in)
; 44 char *fmt, *in;
EXPORT	_tul
_tul:
;BCC_EOS
; 45 {
; 46 	unsigned long a = 99, b = 99;
PSHS	CC,D,X,DP
; Debug: eq int = const $63 to unsigned long a = [S+6-6] (used reg = )
CLRA
CLRB
LDX	#$63
STD	0,S
STX	2,S
LEAS	-4,S
; Debug: eq int = const $63 to unsigned long b = [S+$A-$A] (used reg = )
CLRA
CLRB
LDX	#$63
STD	0,S
STX	2,S
;BCC_EOS
; 47 	int r;
;BCC_EOS
; 48 
; 49 	r = sscanf(in,fmt,&a,&b);
LEAS	-2,S
; Debug: list * unsigned long b = S+$C-$A (used reg = )
LEAX	2,S
PSHS	X
; Debug: list * unsigned long a = S+$E-6 (used reg = )
LEAX	8,S
PSHS	X
; Debug: list * char fmt = [S+$10-2] (used reg = )
LDX	$E,S
PSHS	X
; Debug: rootlist * char in = [S+$12+2] (used reg = )
LDX	$14,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	6,S
; Debug: eq int = X+0 to int r = [S+$C-$C] (used reg = )
STX	0,S
;BCC_EOS
; 50 	printf("[%s] [%s] %d: %lu %lu\n",fmt,in,r,a,b);
LOC	1
.6:
FCC	"[%s] [%s] %d: %lu %lu"
FCB	$A
FCB	0
LOC	0
; Debug: list unsigned long b = [S+$C-$A] (used reg = )
LDD	2,S
LDX	4,S
PSHS	D,X
; Debug: list unsigned long a = [S+$10-6] (used reg = )
LDD	$A,S
LDX	$C,S
PSHS	D,X
; Debug: list int r = [S+$14-$C] (used reg = )
LDD	8,S
PSHS	D
; Debug: list * char in = [S+$16+2] (used reg = )
LDX	$18,S
PSHS	X
; Debug: list * char fmt = [S+$18-2] (used reg = )
LDX	$16,S
PSHS	X
; Debug: rootlist * char = .6+0 (used reg = )
LDX	#.6
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$1a,S
RTS
; 52 
; 53  
; 54 void th(fmt,in)
; 55 char *fmt, *in;
EXPORT	_th
_th:
;BCC_EOS
; 56 {
; 57 	short a = -99, b = -99;
PSHS	D,X
; Debug: eq int = const -$63 to short a = [S+4-4] (used reg = )
LDD	#-$63
STD	0,S
LEAS	-2,S
; Debug: eq int = const -$63 to short b = [S+6-6] (used reg = )
LDD	#-$63
STD	0,S
;BCC_EOS
; 58 	int r;
;BCC_EOS
; 59 
; 60 	r = sscanf(in,fmt,&a,&b);
LEAS	-2,S
; Debug: list * short b = S+8-6 (used reg = )
LEAX	2,S
PSHS	X
; Debug: list * short a = S+$A-4 (used reg = )
LEAX	6,S
PSHS	X
; Debug: list * char fmt = [S+$C-2] (used reg = )
LDX	$A,S
PSHS	X
; Debug: rootlist * char in = [S+$E+2] (used reg = )
LDX	$10,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	6,S
; Debug: eq int = X+0 to int r = [S+8-8] (used reg = )
STX	0,S
;BCC_EOS
; 61 	printf("[%s] [%s] %d: %d %d\n",fmt,in,r,a,b);
LOC	1
.7:
FCC	"[%s] [%s] %d: %d %d"
FCB	$A
FCB	0
LOC	0
; Debug: list short b = [S+8-6] (used reg = )
LDD	2,S
PSHS	D
; Debug: list short a = [S+$A-4] (used reg = )
LDD	6,S
PSHS	D
; Debug: list int r = [S+$C-8] (used reg = )
LDD	4,S
PSHS	D
; Debug: list * char in = [S+$E+2] (used reg = )
LDX	$10,S
PSHS	X
; Debug: list * char fmt = [S+$10-2] (used reg = )
LDX	$E,S
PSHS	X
; Debug: rootlist * char = .7+0 (used reg = )
LDX	#.7
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$12,S
RTS
; 63 
; 64 void thh(fmt,in)
; 65 char *fmt, *in;
EXPORT	_thh
_thh:
;BCC_EOS
; 66 {
; 67 	signed char a = -99;
PSHS	CC,X
; Debug: eq int = const -$63 to char a = [S+3-3] (used reg = )
LDB	#$9D
STB	0,S
;BCC_EOS
; 68 	unsigned char b = 99;
LEAS	-1,S
; Debug: eq int = const $63 to unsigned char b = [S+4-4] (used reg = )
LDB	#$63
STB	0,S
;BCC_EOS
; 69 	int r;
;BCC_EOS
; 70 
; 71 	r = sscanf(in,fmt,&a,&b);
LEAS	-2,S
; Debug: list * unsigned char b = S+6-4 (used reg = )
LEAX	2,S
PSHS	X
; Debug: list * char a = S+8-3 (used reg = )
LEAX	5,S
PSHS	X
; Debug: list * char fmt = [S+$A-2] (used reg = )
LDX	8,S
PSHS	X
; Debug: rootlist * char in = [S+$C+2] (used reg = )
LDX	$E,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	6,S
; Debug: eq int = X+0 to int r = [S+6-6] (used reg = )
STX	0,S
;BCC_EOS
; 72 	printf("[%s] [%s] %d: %d %d\n",fmt,in,r,a,b);
LOC	1
.8:
FCC	"[%s] [%s] %d: %d %d"
FCB	$A
FCB	0
LOC	0
; Debug: list unsigned char b = [S+6-4] (used reg = )
LDB	2,S
CLRA
PSHS	D
; Debug: list char a = [S+8-3] (used reg = )
LDB	5,S
SEX
PSHS	D
; Debug: list int r = [S+$A-6] (used reg = )
LDD	4,S
PSHS	D
; Debug: list * char in = [S+$C+2] (used reg = )
LDX	$E,S
PSHS	X
; Debug: list * char fmt = [S+$E-2] (used reg = )
LDX	$C,S
PSHS	X
; Debug: rootlist * char = .8+0 (used reg = )
LDX	#.8
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$10,S
RTS
; 74 
; 75  
; 76 void tsn(fmt,in)
; 77 char *fmt, *in;
EXPORT	_tsn
_tsn:
;BCC_EOS
; 78 {
; 79 	char s[16];
;BCC_EOS
; 80 	int n = -99, r;
PSHS	X
LEAS	-$12,S
; Debug: eq int = const -$63 to int n = [S+$14-$14] (used reg = )
LDD	#-$63
STD	0,S
;BCC_EOS
; 81 
; 82 	strcpy(s,"-----");
LEAS	-2,S
LOC	1
.9:
FCC	"-----"
FCB	0
LOC	0
; Debug: list * char = .9+0 (used reg = )
LDX	#.9
PSHS	X
; Debug: rootlist * char s = S+$18-$12 (used reg = )
LEAX	6,S
; Debug: func () * char = strcpy+0 (used reg = )
JSR	>_strcpy
LEAS	2,S
;BCC_EOS
; 83 	r = sscanf(in,fmt,s,&n);
; Debug: list * int n = S+$16-$14 (used reg = )
LEAX	2,S
PSHS	X
; Debug: list * char s = S+$18-$12 (used reg = )
LEAX	6,S
PSHS	X
; Debug: list * char fmt = [S+$1A-2] (used reg = )
LDX	$18,S
PSHS	X
; Debug: rootlist * char in = [S+$1C+2] (used reg = )
LDX	$1E,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	6,S
; Debug: eq int = X+0 to int r = [S+$16-$16] (used reg = )
STX	0,S
;BCC_EOS
; 84 	printf("[%s] [%s] %d: [%s] %d\n",fmt,in,r,s,n);
LOC	1
.A:
FCC	"[%s] [%s] %d: [%s] %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+$16-$14] (used reg = )
LDD	2,S
PSHS	D
; Debug: list * char s = S+$18-$12 (used reg = )
LEAX	6,S
PSHS	X
; Debug: list int r = [S+$1A-$16] (used reg = )
LDD	4,S
PSHS	D
; Debug: list * char in = [S+$1C+2] (used reg = )
LDX	$1E,S
PSHS	X
; Debug: list * char fmt = [S+$1E-2] (used reg = )
LDX	$1C,S
PSHS	X
; Debug: rootlist * char = .A+0 (used reg = )
LDX	#.A
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$20,S
RTS
; 86 
; 87  
; 88 void tstr(fmt,in)
; 89 char *fmt, *in;
EXPORT	_tstr
_tstr:
;BCC_EOS
; 90 {
; 91 	char s1[16], s2[16];
;BCC_EOS
; 92 	int n = -99, r;
PSHS	X
LEAS	-$22,S
; Debug: eq int = const -$63 to int n = [S+$24-$24] (used reg = )
LDD	#-$63
STD	0,S
;BCC_EOS
; 93 
; 94 	strcpy(s1,"-----");
LEAS	-2,S
LOC	1
.B:
FCC	"-----"
FCB	0
LOC	0
; Debug: list * char = .B+0 (used reg = )
LDX	#.B
PSHS	X
; Debug: rootlist * char s1 = S+$28-$12 (used reg = )
LEAX	$16,S
; Debug: func () * char = strcpy+0 (used reg = )
JSR	>_strcpy
LEAS	2,S
;BCC_EOS
; 95 	strcpy(s2,"-----");
LOC	1
.C:
FCC	"-----"
FCB	0
LOC	0
; Debug: list * char = .C+0 (used reg = )
LDX	#.C
PSHS	X
; Debug: rootlist * char s2 = S+$28-$22 (used reg = )
LEAX	6,S
; Debug: func () * char = strcpy+0 (used reg = )
JSR	>_strcpy
LEAS	2,S
;BCC_EOS
; 96 	r = sscanf(in,fmt,s1,s2,&n);
; Debug: list * int n = S+$26-$24 (used reg = )
LEAX	2,S
PSHS	X
; Debug: list * char s2 = S+$28-$22 (used reg = )
LEAX	6,S
PSHS	X
; Debug: list * char s1 = S+$2A-$12 (used reg = )
LEAX	$18,S
PSHS	X
; Debug: list * char fmt = [S+$2C-2] (used reg = )
LDX	$2A,S
PSHS	X
; Debug: rootlist * char in = [S+$2E+2] (used reg = )
LDX	$30,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	8,S
; Debug: eq int = X+0 to int r = [S+$26-$26] (used reg = )
STX	0,S
;BCC_EOS
; 97 	printf("[%s] [%s] %d: [%s] [%s] %d\n",fmt,in,r,s1,s2,n);
LOC	1
.D:
FCC	"[%s] [%s] %d: [%s] [%s] %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+$26-$24] (used reg = )
LDD	2,S
PSHS	D
; Debug: list * char s2 = S+$28-$22 (used reg = )
LEAX	6,S
PSHS	X
; Debug: list * char s1 = S+$2A-$12 (used reg = )
LEAX	$18,S
PSHS	X
; Debug: list int r = [S+$2C-$26] (used reg = )
LDD	6,S
PSHS	D
; Debug: list * char in = [S+$2E+2] (used reg = )
LDX	$30,S
PSHS	X
; Debug: list * char fmt = [S+$30-2] (used reg = )
LDX	$2E,S
PSHS	X
; Debug: rootlist * char = .D+0 (used reg = )
LDX	#.D
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$32,S
RTS
; 99 
; 100 void numbers()
; 101 {
EXPORT	_numbers
_numbers:
; 102 	 
; 103 	ti("%d","42");
LOC	1
.E:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.F:
FCC	"42"
FCB	0
LOC	0
; Debug: list * char = .F+0 (used reg = )
LDX	#.F
PSHS	X
; Debug: rootlist * char = .E+0 (used reg = )
LDX	#.E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 104 	ti("%d","-17");
LOC	1
.10:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.11:
FCC	"-17"
FCB	0
LOC	0
; Debug: list * char = .11+0 (used reg = )
LDX	#.11
PSHS	X
; Debug: rootlist * char = .10+0 (used reg = )
LDX	#.10
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 105 	ti("%d","+5");
LOC	1
.12:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.13:
FCC	"+5"
FCB	0
LOC	0
; Debug: list * char = .13+0 (used reg = )
LDX	#.13
PSHS	X
; Debug: rootlist * char = .12+0 (used reg = )
LDX	#.12
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 106 	ti("%d","  12abc");
LOC	1
.14:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.15:
FCC	"  12abc"
FCB	0
LOC	0
; Debug: list * char = .15+0 (used reg = )
LDX	#.15
PSHS	X
; Debug: rootlist * char = .14+0 (used reg = )
LDX	#.14
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 107 	ti("%d","abc");
LOC	1
.16:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.17:
FCC	"abc"
FCB	0
LOC	0
; Debug: list * char = .17+0 (used reg = )
LDX	#.17
PSHS	X
; Debug: rootlist * char = .16+0 (used reg = )
LDX	#.16
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 108 	ti("%d","");
LOC	1
.18:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.19:
FCB	0
LOC	0
; Debug: list * char = .19+0 (used reg = )
LDX	#.19
PSHS	X
; Debug: rootlist * char = .18+0 (used reg = )
LDX	#.18
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 109 	ti("%d","   ");
LOC	1
.1A:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.1B:
FCC	"   "
FCB	0
LOC	0
; Debug: list * char = .1B+0 (used reg = )
LDX	#.1B
PSHS	X
; Debug: rootlist * char = .1A+0 (used reg = )
LDX	#.1A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 110 	ti("%d","-");
LOC	1
.1C:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.1D:
FCC	"-"
FCB	0
LOC	0
; Debug: list * char = .1D+0 (used reg = )
LDX	#.1D
PSHS	X
; Debug: rootlist * char = .1C+0 (used reg = )
LDX	#.1C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 111 	ti("%d%d","- 3");
LOC	1
.1E:
FCC	"%d%d"
FCB	0
LOC	0
LOC	1
.1F:
FCC	"- 3"
FCB	0
LOC	0
; Debug: list * char = .1F+0 (used reg = )
LDX	#.1F
PSHS	X
; Debug: rootlist * char = .1E+0 (used reg = )
LDX	#.1E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 112 	ti("%d","32767");
LOC	1
.20:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.21:
FCC	"32767"
FCB	0
LOC	0
; Debug: list * char = .21+0 (used reg = )
LDX	#.21
PSHS	X
; Debug: rootlist * char = .20+0 (used reg = )
LDX	#.20
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 113 	ti("%d","-32768");
LOC	1
.22:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.23:
FCC	"-32768"
FCB	0
LOC	0
; Debug: list * char = .23+0 (used reg = )
LDX	#.23
PSHS	X
; Debug: rootlist * char = .22+0 (used reg = )
LDX	#.22
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 114 	ti("%d","0");
LOC	1
.24:
FCC	"%d"
FCB	0
LOC	0
LOC	1
.25:
FCC	"0"
FCB	0
LOC	0
; Debug: list * char = .25+0 (used reg = )
LDX	#.25
PSHS	X
; Debug: rootlist * char = .24+0 (used reg = )
LDX	#.24
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 115 	ti("%d%d","007 8");
LOC	1
.26:
FCC	"%d%d"
FCB	0
LOC	0
LOC	1
.27:
FCC	"007 8"
FCB	0
LOC	0
; Debug: list * char = .27+0 (used reg = )
LDX	#.27
PSHS	X
; Debug: rootlist * char = .26+0 (used reg = )
LDX	#.26
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 116 	ti("%i","0x1f");
LOC	1
.28:
FCC	"%i"
FCB	0
LOC	0
LOC	1
.29:
FCC	"0x1f"
FCB	0
LOC	0
; Debug: list * char = .29+0 (used reg = )
LDX	#.29
PSHS	X
; Debug: rootlist * char = .28+0 (used reg = )
LDX	#.28
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 117 	ti("%i","0X1F");
LOC	1
.2A:
FCC	"%i"
FCB	0
LOC	0
LOC	1
.2B:
FCC	"0X1F"
FCB	0
LOC	0
; Debug: list * char = .2B+0 (used reg = )
LDX	#.2B
PSHS	X
; Debug: rootlist * char = .2A+0 (used reg = )
LDX	#.2A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 118 	ti("%i","017");
LOC	1
.2C:
FCC	"%i"
FCB	0
LOC	0
LOC	1
.2D:
FCC	"017"
FCB	0
LOC	0
; Debug: list * char = .2D+0 (used reg = )
LDX	#.2D
PSHS	X
; Debug: rootlist * char = .2C+0 (used reg = )
LDX	#.2C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 119 	ti("%i","0");
LOC	1
.2E:
FCC	"%i"
FCB	0
LOC	0
LOC	1
.2F:
FCC	"0"
FCB	0
LOC	0
; Debug: list * char = .2F+0 (used reg = )
LDX	#.2F
PSHS	X
; Debug: rootlist * char = .2E+0 (used reg = )
LDX	#.2E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 120 	ti("%i","-0x10");
LOC	1
.30:
FCC	"%i"
FCB	0
LOC	0
LOC	1
.31:
FCC	"-0x10"
FCB	0
LOC	0
; Debug: list * char = .31+0 (used reg = )
LDX	#.31
PSHS	X
; Debug: rootlist * char = .30+0 (used reg = )
LDX	#.30
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 121 	ti("%i%n","0x");
LOC	1
.32:
FCC	"%i%n"
FCB	0
LOC	0
LOC	1
.33:
FCC	"0x"
FCB	0
LOC	0
; Debug: list * char = .33+0 (used reg = )
LDX	#.33
PSHS	X
; Debug: rootlist * char = .32+0 (used reg = )
LDX	#.32
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 122 	ti("%i%d","08");
LOC	1
.34:
FCC	"%i%d"
FCB	0
LOC	0
LOC	1
.35:
FCC	"08"
FCB	0
LOC	0
; Debug: list * char = .35+0 (used reg = )
LDX	#.35
PSHS	X
; Debug: rootlist * char = .34+0 (used reg = )
LDX	#.34
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 123 	ti("%i%d","09");
LOC	1
.36:
FCC	"%i%d"
FCB	0
LOC	0
LOC	1
.37:
FCC	"09"
FCB	0
LOC	0
; Debug: list * char = .37+0 (used reg = )
LDX	#.37
PSHS	X
; Debug: rootlist * char = .36+0 (used reg = )
LDX	#.36
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 124 	ti("%i","+077");
LOC	1
.38:
FCC	"%i"
FCB	0
LOC	0
LOC	1
.39:
FCC	"+077"
FCB	0
LOC	0
; Debug: list * char = .39+0 (used reg = )
LDX	#.39
PSHS	X
; Debug: rootlist * char = .38+0 (used reg = )
LDX	#.38
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 125 	ti("%x","ff");
LOC	1
.3A:
FCC	"%x"
FCB	0
LOC	0
LOC	1
.3B:
FCC	"ff"
FCB	0
LOC	0
; Debug: list * char = .3B+0 (used reg = )
LDX	#.3B
PSHS	X
; Debug: rootlist * char = .3A+0 (used reg = )
LDX	#.3A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 126 	ti("%x","0xff");
LOC	1
.3C:
FCC	"%x"
FCB	0
LOC	0
LOC	1
.3D:
FCC	"0xff"
FCB	0
LOC	0
; Debug: list * char = .3D+0 (used reg = )
LDX	#.3D
PSHS	X
; Debug: rootlist * char = .3C+0 (used reg = )
LDX	#.3C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 127 	ti("%X","FF");
LOC	1
.3E:
FCC	"%X"
FCB	0
LOC	0
LOC	1
.3F:
FCC	"FF"
FCB	0
LOC	0
; Debug: list * char = .3F+0 (used reg = )
LDX	#.3F
PSHS	X
; Debug: rootlist * char = .3E+0 (used reg = )
LDX	#.3E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 128 	ti("%x%n","0x");
LOC	1
.40:
FCC	"%x%n"
FCB	0
LOC	0
LOC	1
.41:
FCC	"0x"
FCB	0
LOC	0
; Debug: list * char = .41+0 (used reg = )
LDX	#.41
PSHS	X
; Debug: rootlist * char = .40+0 (used reg = )
LDX	#.40
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 129 	ti("%x%n","0xg");
LOC	1
.42:
FCC	"%x%n"
FCB	0
LOC	0
LOC	1
.43:
FCC	"0xg"
FCB	0
LOC	0
; Debug: list * char = .43+0 (used reg = )
LDX	#.43
PSHS	X
; Debug: rootlist * char = .42+0 (used reg = )
LDX	#.42
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 130 	ti("%x","g");
LOC	1
.44:
FCC	"%x"
FCB	0
LOC	0
LOC	1
.45:
FCC	"g"
FCB	0
LOC	0
; Debug: list * char = .45+0 (used reg = )
LDX	#.45
PSHS	X
; Debug: rootlist * char = .44+0 (used reg = )
LDX	#.44
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 131 	ti("%x","-1a");
LOC	1
.46:
FCC	"%x"
FCB	0
LOC	0
LOC	1
.47:
FCC	"-1a"
FCB	0
LOC	0
; Debug: list * char = .47+0 (used reg = )
LDX	#.47
PSHS	X
; Debug: rootlist * char = .46+0 (used reg = )
LDX	#.46
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 132 	ti("%o","777");
LOC	1
.48:
FCC	"%o"
FCB	0
LOC	0
LOC	1
.49:
FCC	"777"
FCB	0
LOC	0
; Debug: list * char = .49+0 (used reg = )
LDX	#.49
PSHS	X
; Debug: rootlist * char = .48+0 (used reg = )
LDX	#.48
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 133 	ti("%o%d","78");
LOC	1
.4A:
FCC	"%o%d"
FCB	0
LOC	0
LOC	1
.4B:
FCC	"78"
FCB	0
LOC	0
; Debug: list * char = .4B+0 (used reg = )
LDX	#.4B
PSHS	X
; Debug: rootlist * char = .4A+0 (used reg = )
LDX	#.4A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 134 	ti("%o","8");
LOC	1
.4C:
FCC	"%o"
FCB	0
LOC	0
LOC	1
.4D:
FCC	"8"
FCB	0
LOC	0
; Debug: list * char = .4D+0 (used reg = )
LDX	#.4D
PSHS	X
; Debug: rootlist * char = .4C+0 (used reg = )
LDX	#.4C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 135 	ti("%o","-10");
LOC	1
.4E:
FCC	"%o"
FCB	0
LOC	0
LOC	1
.4F:
FCC	"-10"
FCB	0
LOC	0
; Debug: list * char = .4F+0 (used reg = )
LDX	#.4F
PSHS	X
; Debug: rootlist * char = .4E+0 (used reg = )
LDX	#.4E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 136 	ti("%u","123");
LOC	1
.50:
FCC	"%u"
FCB	0
LOC	0
LOC	1
.51:
FCC	"123"
FCB	0
LOC	0
; Debug: list * char = .51+0 (used reg = )
LDX	#.51
PSHS	X
; Debug: rootlist * char = .50+0 (used reg = )
LDX	#.50
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 137 	ti("%u","+65");
LOC	1
.52:
FCC	"%u"
FCB	0
LOC	0
LOC	1
.53:
FCC	"+65"
FCB	0
LOC	0
; Debug: list * char = .53+0 (used reg = )
LDX	#.53
PSHS	X
; Debug: rootlist * char = .52+0 (used reg = )
LDX	#.52
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 138 
; 139 	 
; 140 	ti("%2d%d","12345");
LOC	1
.54:
FCC	"%2d%d"
FCB	0
LOC	0
LOC	1
.55:
FCC	"12345"
FCB	0
LOC	0
; Debug: list * char = .55+0 (used reg = )
LDX	#.55
PSHS	X
; Debug: rootlist * char = .54+0 (used reg = )
LDX	#.54
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 141 	ti("%3x%n","0x1f");
LOC	1
.56:
FCC	"%3x%n"
FCB	0
LOC	0
LOC	1
.57:
FCC	"0x1f"
FCB	0
LOC	0
; Debug: list * char = .57+0 (used reg = )
LDX	#.57
PSHS	X
; Debug: rootlist * char = .56+0 (used reg = )
LDX	#.56
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 142 	ti("%2i%d","0x1f");
LOC	1
.58:
FCC	"%2i%d"
FCB	0
LOC	0
LOC	1
.59:
FCC	"0x1f"
FCB	0
LOC	0
; Debug: list * char = .59+0 (used reg = )
LDX	#.59
PSHS	X
; Debug: rootlist * char = .58+0 (used reg = )
LDX	#.58
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 143 	ti("%3d%d","-1234");
LOC	1
.5A:
FCC	"%3d%d"
FCB	0
LOC	0
LOC	1
.5B:
FCC	"-1234"
FCB	0
LOC	0
; Debug: list * char = .5B+0 (used reg = )
LDX	#.5B
PSHS	X
; Debug: rootlist * char = .5A+0 (used reg = )
LDX	#.5A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 144 	ti("%1d%n","-5");
LOC	1
.5C:
FCC	"%1d%n"
FCB	0
LOC	0
LOC	1
.5D:
FCC	"-5"
FCB	0
LOC	0
; Debug: list * char = .5D+0 (used reg = )
LDX	#.5D
PSHS	X
; Debug: rootlist * char = .5C+0 (used reg = )
LDX	#.5C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 145 	ti("%1d%d","+5");
LOC	1
.5E:
FCC	"%1d%d"
FCB	0
LOC	0
LOC	1
.5F:
FCC	"+5"
FCB	0
LOC	0
; Debug: list * char = .5F+0 (used reg = )
LDX	#.5F
PSHS	X
; Debug: rootlist * char = .5E+0 (used reg = )
LDX	#.5E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 146 	ti("%4d%n","  12");
LOC	1
.60:
FCC	"%4d%n"
FCB	0
LOC	0
LOC	1
.61:
FCC	"  12"
FCB	0
LOC	0
; Debug: list * char = .61+0 (used reg = )
LDX	#.61
PSHS	X
; Debug: rootlist * char = .60+0 (used reg = )
LDX	#.60
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 147 	ti("%10d","123");
LOC	1
.62:
FCC	"%10d"
FCB	0
LOC	0
LOC	1
.63:
FCC	"123"
FCB	0
LOC	0
; Debug: list * char = .63+0 (used reg = )
LDX	#.63
PSHS	X
; Debug: rootlist * char = .62+0 (used reg = )
LDX	#.62
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 148 
; 149 	 
; 150 	ti("%d%n","12 34");
LOC	1
.64:
FCC	"%d%n"
FCB	0
LOC	0
LOC	1
.65:
FCC	"12 34"
FCB	0
LOC	0
; Debug: list * char = .65+0 (used reg = )
LDX	#.65
PSHS	X
; Debug: rootlist * char = .64+0 (used reg = )
LDX	#.64
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 151 	ti("%d %n%d","12 34");
LOC	1
.66:
FCC	"%d %n%d"
FCB	0
LOC	0
LOC	1
.67:
FCC	"12 34"
FCB	0
LOC	0
; Debug: list * char = .67+0 (used reg = )
LDX	#.67
PSHS	X
; Debug: rootlist * char = .66+0 (used reg = )
LDX	#.66
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 152 	ti("%*d%d","1 2");
LOC	1
.68:
FCC	"%*d%d"
FCB	0
LOC	0
LOC	1
.69:
FCC	"1 2"
FCB	0
LOC	0
; Debug: list * char = .69+0 (used reg = )
LDX	#.69
PSHS	X
; Debug: rootlist * char = .68+0 (used reg = )
LDX	#.68
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 153 	ti("%*d%d","
LOC	1
.6A:
FCC	"%*d%d"
FCB	0
LOC	0
; 153 5");
LOC	1
.6B:
FCC	"5"
FCB	0
LOC	0
; Debug: list * char = .6B+0 (used reg = )
LDX	#.6B
PSHS	X
; Debug: rootlist * char = .6A+0 (used reg = )
LDX	#.6A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 154 	ti("%*d%n","5");
LOC	1
.6C:
FCC	"%*d%n"
FCB	0
LOC	0
LOC	1
.6D:
FCC	"5"
FCB	0
LOC	0
; Debug: list * char = .6D+0 (used reg = )
LDX	#.6D
PSHS	X
; Debug: rootlist * char = .6C+0 (used reg = )
LDX	#.6C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 155 	ti("%*x%*o%d%n","ff 17 9");
LOC	1
.6E:
FCC	"%*x%*o%d%n"
FCB	0
LOC	0
LOC	1
.6F:
FCC	"ff 17 9"
FCB	0
LOC	0
; Debug: list * char = .6F+0 (used reg = )
LDX	#.6F
PSHS	X
; Debug: rootlist * char = .6E+0 (used reg = )
LDX	#.6E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 156 	ti("%d,%d","1,2");
LOC	1
.70:
FCC	"%d,%d"
FCB	0
LOC	0
LOC	1
.71:
FCC	"1,2"
FCB	0
LOC	0
; Debug: list * char = .71+0 (used reg = )
LDX	#.71
PSHS	X
; Debug: rootlist * char = .70+0 (used reg = )
LDX	#.70
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 157 	ti("%d,%d","1 ,2");
LOC	1
.72:
FCC	"%d,%d"
FCB	0
LOC	0
LOC	1
.73:
FCC	"1 ,2"
FCB	0
LOC	0
; Debug: list * char = .73+0 (used reg = )
LDX	#.73
PSHS	X
; Debug: rootlist * char = .72+0 (used reg = )
LDX	#.72
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 158 	ti("%d ,%d","1 , 2");
LOC	1
.74:
FCC	"%d ,%d"
FCB	0
LOC	0
LOC	1
.75:
FCC	"1 , 2"
FCB	0
LOC	0
; Debug: list * char = .75+0 (used reg = )
LDX	#.75
PSHS	X
; Debug: rootlist * char = .74+0 (used reg = )
LDX	#.74
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 159 	ti("%d , %d%n","1,2");
LOC	1
.76:
FCC	"%d , %d%n"
FCB	0
LOC	0
LOC	1
.77:
FCC	"1,2"
FCB	0
LOC	0
; Debug: list * char = .77+0 (used reg = )
LDX	#.77
PSHS	X
; Debug: rootlist * char = .76+0 (used reg = )
LDX	#.76
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 160 	ti("x%d","x5");
LOC	1
.78:
FCC	"x%d"
FCB	0
LOC	0
LOC	1
.79:
FCC	"x5"
FCB	0
LOC	0
; Debug: list * char = .79+0 (used reg = )
LDX	#.79
PSHS	X
; Debug: rootlist * char = .78+0 (used reg = )
LDX	#.78
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 161 	ti("x%d","y5");
LOC	1
.7A:
FCC	"x%d"
FCB	0
LOC	0
LOC	1
.7B:
FCC	"y5"
FCB	0
LOC	0
; Debug: list * char = .7B+0 (used reg = )
LDX	#.7B
PSHS	X
; Debug: rootlist * char = .7A+0 (used reg = )
LDX	#.7A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 162 	ti("x%d"," x5");
LOC	1
.7C:
FCC	"x%d"
FCB	0
LOC	0
LOC	1
.7D:
FCC	" x5"
FCB	0
LOC	0
; Debug: list * char = .7D+0 (used reg = )
LDX	#.7D
PSHS	X
; Debug: rootlist * char = .7C+0 (used reg = )
LDX	#.7C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 163 	ti(" x%d"," x5");
LOC	1
.7E:
FCC	" x%d"
FCB	0
LOC	0
LOC	1
.7F:
FCC	" x5"
FCB	0
LOC	0
; Debug: list * char = .7F+0 (used reg = )
LDX	#.7F
PSHS	X
; Debug: rootlist * char = .7E+0 (used reg = )
LDX	#.7E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 164 	ti("%d%%%d","5% 6");
LOC	1
.80:
FCC	"%d%%%d"
FCB	0
LOC	0
LOC	1
.81:
FCC	"5% 6"
FCB	0
LOC	0
; Debug: list * char = .81+0 (used reg = )
LDX	#.81
PSHS	X
; Debug: rootlist * char = .80+0 (used reg = )
LDX	#.80
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 165 	ti("%d%%%d","5 %6");
LOC	1
.82:
FCC	"%d%%%d"
FCB	0
LOC	0
LOC	1
.83:
FCC	"5 %6"
FCB	0
LOC	0
; Debug: list * char = .83+0 (used reg = )
LDX	#.83
PSHS	X
; Debug: rootlist * char = .82+0 (used reg = )
LDX	#.82
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 166 	ti("%d %% %d","5%6");
LOC	1
.84:
FCC	"%d %% %d"
FCB	0
LOC	0
LOC	1
.85:
FCC	"5%6"
FCB	0
LOC	0
; Debug: list * char = .85+0 (used reg = )
LDX	#.85
PSHS	X
; Debug: rootlist * char = .84+0 (used reg = )
LDX	#.84
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 167 	ti("%d%%","5");
LOC	1
.86:
FCC	"%d%%"
FCB	0
LOC	0
LOC	1
.87:
FCC	"5"
FCB	0
LOC	0
; Debug: list * char = .87+0 (used reg = )
LDX	#.87
PSHS	X
; Debug: rootlist * char = .86+0 (used reg = )
LDX	#.86
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 168 	ti("abc%d","abc");
LOC	1
.88:
FCC	"abc%d"
FCB	0
LOC	0
LOC	1
.89:
FCC	"abc"
FCB	0
LOC	0
; Debug: list * char = .89+0 (used reg = )
LDX	#.89
PSHS	X
; Debug: rootlist * char = .88+0 (used reg = )
LDX	#.88
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 169 	ti("abc%d","ab");
LOC	1
.8A:
FCC	"abc%d"
FCB	0
LOC	0
LOC	1
.8B:
FCC	"ab"
FCB	0
LOC	0
; Debug: list * char = .8B+0 (used reg = )
LDX	#.8B
PSHS	X
; Debug: rootlist * char = .8A+0 (used reg = )
LDX	#.8A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 170 	ti("abc%n","abcd");
LOC	1
.8C:
FCC	"abc%n"
FCB	0
LOC	0
LOC	1
.8D:
FCC	"abcd"
FCB	0
LOC	0
; Debug: list * char = .8D+0 (used reg = )
LDX	#.8D
PSHS	X
; Debug: rootlist * char = .8C+0 (used reg = )
LDX	#.8C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 171 	ti("","");
LOC	1
.8E:
FCB	0
LOC	0
LOC	1
.8F:
FCB	0
LOC	0
; Debug: list * char = .8F+0 (used reg = )
LDX	#.8F
PSHS	X
; Debug: rootlist * char = .8E+0 (used reg = )
LDX	#.8E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 172 	ti("","abc");
LOC	1
.90:
FCB	0
LOC	0
LOC	1
.91:
FCC	"abc"
FCB	0
LOC	0
; Debug: list * char = .91+0 (used reg = )
LDX	#.91
PSHS	X
; Debug: rootlist * char = .90+0 (used reg = )
LDX	#.90
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 173 	ti(" ","");
LOC	1
.92:
FCC	" "
FCB	0
LOC	0
LOC	1
.93:
FCB	0
LOC	0
; Debug: list * char = .93+0 (used reg = )
LDX	#.93
PSHS	X
; Debug: rootlist * char = .92+0 (used reg = )
LDX	#.92
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 174 	ti(" %n","   x");
LOC	1
.94:
FCC	" %n"
FCB	0
LOC	0
LOC	1
.95:
FCC	"   x"
FCB	0
LOC	0
; Debug: list * char = .95+0 (used reg = )
LDX	#.95
PSHS	X
; Debug: rootlist * char = .94+0 (used reg = )
LDX	#.94
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 175 	ti("%n","");
LOC	1
.96:
FCC	"%n"
FCB	0
LOC	0
LOC	1
.97:
FCB	0
LOC	0
; Debug: list * char = .97+0 (used reg = )
LDX	#.97
PSHS	X
; Debug: rootlist * char = .96+0 (used reg = )
LDX	#.96
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 176 	ti("%n%d","");
LOC	1
.98:
FCC	"%n%d"
FCB	0
LOC	0
LOC	1
.99:
FCB	0
LOC	0
; Debug: list * char = .99+0 (used reg = )
LDX	#.99
PSHS	X
; Debug: rootlist * char = .98+0 (used reg = )
LDX	#.98
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 177 	ti("%d%n%d%n","1 2");
LOC	1
.9A:
FCC	"%d%n%d%n"
FCB	0
LOC	0
LOC	1
.9B:
FCC	"1 2"
FCB	0
LOC	0
; Debug: list * char = .9B+0 (used reg = )
LDX	#.9B
PSHS	X
; Debug: rootlist * char = .9A+0 (used reg = )
LDX	#.9A
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 178 	ti("%d%d%d%d","1 2 3 4");
LOC	1
.9C:
FCC	"%d%d%d%d"
FCB	0
LOC	0
LOC	1
.9D:
FCC	"1 2 3 4"
FCB	0
LOC	0
; Debug: list * char = .9D+0 (used reg = )
LDX	#.9D
PSHS	X
; Debug: rootlist * char = .9C+0 (used reg = )
LDX	#.9C
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 179 	ti("%d%d%d%d","1 2 x 4");
LOC	1
.9E:
FCC	"%d%d%d%d"
FCB	0
LOC	0
LOC	1
.9F:
FCC	"1 2 x 4"
FCB	0
LOC	0
; Debug: list * char = .9F+0 (used reg = )
LDX	#.9F
PSHS	X
; Debug: rootlist * char = .9E+0 (used reg = )
LDX	#.9E
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 180 	ti("%d\n%d","1\n\t 2");
LOC	1
.A0:
FCC	"%d"
FCB	$A
FCC	"%d"
FCB	0
LOC	0
LOC	1
.A1:
FCC	"1"
FCB	$A,9
FCC	" 2"
FCB	0
LOC	0
; Debug: list * char = .A1+0 (used reg = )
LDX	#.A1
PSHS	X
; Debug: rootlist * char = .A0+0 (used reg = )
LDX	#.A0
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 181 	ti("%d%d","1\t\n\v\f\r 2");
LOC	1
.A2:
FCC	"%d%d"
FCB	0
LOC	0
LOC	1
.A3:
FCC	"1"
FCB	9,$A,$B,$C,$D
FCC	" 2"
FCB	0
LOC	0
; Debug: list * char = .A3+0 (used reg = )
LDX	#.A3
PSHS	X
; Debug: rootlist * char = .A2+0 (used reg = )
LDX	#.A2
; Debug: func () void = ti+0 (used reg = )
JSR	>_ti
LEAS	2,S
;BCC_EOS
; 182 
; 183 	 
; 184 	th("%hd","-2");
LOC	1
.A4:
FCC	"%hd"
FCB	0
LOC	0
LOC	1
.A5:
FCC	"-2"
FCB	0
LOC	0
; Debug: list * char = .A5+0 (used reg = )
LDX	#.A5
PSHS	X
; Debug: rootlist * char = .A4+0 (used reg = )
LDX	#.A4
; Debug: func () void = th+0 (used reg = )
JSR	>_th
LEAS	2,S
;BCC_EOS
; 185 	th("%hd","70000");
LOC	1
.A6:
FCC	"%hd"
FCB	0
LOC	0
LOC	1
.A7:
FCC	"70000"
FCB	0
LOC	0
; Debug: list * char = .A7+0 (used reg = )
LDX	#.A7
PSHS	X
; Debug: rootlist * char = .A6+0 (used reg = )
LDX	#.A6
; Debug: func () void = th+0 (used reg = )
JSR	>_th
LEAS	2,S
;BCC_EOS
; 186 	th("%hu","-1");
LOC	1
.A8:
FCC	"%hu"
FCB	0
LOC	0
LOC	1
.A9:
FCC	"-1"
FCB	0
LOC	0
; Debug: list * char = .A9+0 (used reg = )
LDX	#.A9
PSHS	X
; Debug: rootlist * char = .A8+0 (used reg = )
LDX	#.A8
; Debug: func () void = th+0 (used reg = )
JSR	>_th
LEAS	2,S
;BCC_EOS
; 187 	th("%hx%ho","ffff 177777");
LOC	1
.AA:
FCC	"%hx%ho"
FCB	0
LOC	0
LOC	1
.AB:
FCC	"ffff 177777"
FCB	0
LOC	0
; Debug: list * char = .AB+0 (used reg = )
LDX	#.AB
PSHS	X
; Debug: rootlist * char = .AA+0 (used reg = )
LDX	#.AA
; Debug: func () void = th+0 (used reg = )
JSR	>_th
LEAS	2,S
;BCC_EOS
; 188 	th("%hi%hn","-0x7fff");
LOC	1
.AC:
FCC	"%hi%hn"
FCB	0
LOC	0
LOC	1
.AD:
FCC	"-0x7fff"
FCB	0
LOC	0
; Debug: list * char = .AD+0 (used reg = )
LDX	#.AD
PSHS	X
; Debug: rootlist * char = .AC+0 (used reg = )
LDX	#.AC
; Debug: func () void = th+0 (used reg = )
JSR	>_th
LEAS	2,S
;BCC_EOS
; 189 	thh("%hhd%hhu","300 255");
LOC	1
.AE:
FCC	"%hhd%hhu"
FCB	0
LOC	0
LOC	1
.AF:
FCC	"300 255"
FCB	0
LOC	0
; Debug: list * char = .AF+0 (used reg = )
LDX	#.AF
PSHS	X
; Debug: rootlist * char = .AE+0 (used reg = )
LDX	#.AE
; Debug: func () void = thh+0 (used reg = )
JSR	>_thh
LEAS	2,S
;BCC_EOS
; 190 	thh("%hhd%hhu","-1 -1");
LOC	1
.B0:
FCC	"%hhd%hhu"
FCB	0
LOC	0
LOC	1
.B1:
FCC	"-1 -1"
FCB	0
LOC	0
; Debug: list * char = .B1+0 (used reg = )
LDX	#.B1
PSHS	X
; Debug: rootlist * char = .B0+0 (used reg = )
LDX	#.B0
; Debug: func () void = thh+0 (used reg = )
JSR	>_thh
LEAS	2,S
;BCC_EOS
; 191 	thh("%hhx%hhn","1ff");
LOC	1
.B2:
FCC	"%hhx%hhn"
FCB	0
LOC	0
LOC	1
.B3:
FCC	"1ff"
FCB	0
LOC	0
; Debug: list * char = .B3+0 (used reg = )
LDX	#.B3
PSHS	X
; Debug: rootlist * char = .B2+0 (used reg = )
LDX	#.B2
; Debug: func () void = thh+0 (used reg = )
JSR	>_thh
LEAS	2,S
;BCC_EOS
; 192 	thh("%hhi","-0200");
LOC	1
.B4:
FCC	"%hhi"
FCB	0
LOC	0
LOC	1
.B5:
FCC	"-0200"
FCB	0
LOC	0
; Debug: list * char = .B5+0 (used reg = )
LDX	#.B5
PSHS	X
; Debug: rootlist * char = .B4+0 (used reg = )
LDX	#.B4
; Debug: func () void = thh+0 (used reg = )
JSR	>_thh
LEAS	2,S
;BCC_EOS
; 193 	tl("%ld","-100000");
LOC	1
.B6:
FCC	"%ld"
FCB	0
LOC	0
LOC	1
.B7:
FCC	"-100000"
FCB	0
LOC	0
; Debug: list * char = .B7+0 (used reg = )
LDX	#.B7
PSHS	X
; Debug: rootlist * char = .B6+0 (used reg = )
LDX	#.B6
; Debug: func () void = tl+0 (used reg = )
JSR	>_tl
LEAS	2,S
;BCC_EOS
; 194 	tl("%ld%ld","2147483647 -2147483647");
LOC	1
.B8:
FCC	"%ld%ld"
FCB	0
LOC	0
LOC	1
.B9:
FCC	"2147483647 -2147483647"
FCB	0
LOC	0
; Debug: list * char = .B9+0 (used reg = )
LDX	#.B9
PSHS	X
; Debug: rootlist * char = .B8+0 (used reg = )
LDX	#.B8
; Debug: func () void = tl+0 (used reg = )
JSR	>_tl
LEAS	2,S
;BCC_EOS
; 195 	tul("%lx","deadbeef");
LOC	1
.BA:
FCC	"%lx"
FCB	0
LOC	0
LOC	1
.BB:
FCC	"deadbeef"
FCB	0
LOC	0
; Debug: list * char = .BB+0 (used reg = )
LDX	#.BB
PSHS	X
; Debug: rootlist * char = .BA+0 (used reg = )
LDX	#.BA
; Debug: func () void = tul+0 (used reg = )
JSR	>_tul
LEAS	2,S
;BCC_EOS
; 196 	tul("%lX%lo","0XCAFE 17777777777");
LOC	1
.BC:
FCC	"%lX%lo"
FCB	0
LOC	0
LOC	1
.BD:
FCC	"0XCAFE 17777777777"
FCB	0
LOC	0
; Debug: list * char = .BD+0 (used reg = )
LDX	#.BD
PSHS	X
; Debug: rootlist * char = .BC+0 (used reg = )
LDX	#.BC
; Debug: func () void = tul+0 (used reg = )
JSR	>_tul
LEAS	2,S
;BCC_EOS
; 197 	tul("%lu","4294967295");
LOC	1
.BE:
FCC	"%lu"
FCB	0
LOC	0
LOC	1
.BF:
FCC	"4294967295"
FCB	0
LOC	0
; Debug: list * char = .BF+0 (used reg = )
LDX	#.BF
PSHS	X
; Debug: rootlist * char = .BE+0 (used reg = )
LDX	#.BE
; Debug: func () void = tul+0 (used reg = )
JSR	>_tul
LEAS	2,S
;BCC_EOS
; 198 	tl("%li%li","0x7fffffff 0777");
LOC	1
.C0:
FCC	"%li%li"
FCB	0
LOC	0
LOC	1
.C1:
FCC	"0x7fffffff 0777"
FCB	0
LOC	0
; Debug: list * char = .C1+0 (used reg = )
LDX	#.C1
PSHS	X
; Debug: rootlist * char = .C0+0 (used reg = )
LDX	#.C0
; Debug: func () void = tl+0 (used reg = )
JSR	>_tl
LEAS	2,S
;BCC_EOS
; 199 	tl("%lld","123456");
LOC	1
.C2:
FCC	"%lld"
FCB	0
LOC	0
LOC	1
.C3:
FCC	"123456"
FCB	0
LOC	0
; Debug: list * char = .C3+0 (used reg = )
LDX	#.C3
PSHS	X
; Debug: rootlist * char = .C2+0 (used reg = )
LDX	#.C2
; Debug: func () void = tl+0 (used reg = )
JSR	>_tl
LEAS	2,S
;BCC_EOS
; 200 	tl("%ld%ln","65536");
LOC	1
.C4:
FCC	"%ld%ln"
FCB	0
LOC	0
LOC	1
.C5:
FCC	"65536"
FCB	0
LOC	0
; Debug: list * char = .C5+0 (used reg = )
LDX	#.C5
PSHS	X
; Debug: rootlist * char = .C4+0 (used reg = )
LDX	#.C4
; Debug: func () void = tl+0 (used reg = )
JSR	>_tl
LEAS	2,S
;BCC_EOS
; 201 	tl("%5ld%ld","1234567");
LOC	1
.C6:
FCC	"%5ld%ld"
FCB	0
LOC	0
LOC	1
.C7:
FCC	"1234567"
FCB	0
LOC	0
; Debug: list * char = .C7+0 (used reg = )
LDX	#.C7
PSHS	X
; Debug: rootlist * char = .C6+0 (used reg = )
LDX	#.C6
; Debug: func () void = tl+0 (used reg = )
JSR	>_tl
LEAS	2,S
;BCC_EOS
; 202 }
RTS
; 203 
; 204 void strings()
; 205 {
EXPORT	_strings
_strings:
; 206 	 
; 207 	tstr("%s","hello world");
LOC	1
.C8:
FCC	"%s"
FCB	0
LOC	0
LOC	1
.C9:
FCC	"hello world"
FCB	0
LOC	0
; Debug: list * char = .C9+0 (used reg = )
LDX	#.C9
PSHS	X
; Debug: rootlist * char = .C8+0 (used reg = )
LDX	#.C8
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 208 	tstr("%s%s","hello world");
LOC	1
.CA:
FCC	"%s%s"
FCB	0
LOC	0
LOC	1
.CB:
FCC	"hello world"
FCB	0
LOC	0
; Debug: list * char = .CB+0 (used reg = )
LDX	#.CB
PSHS	X
; Debug: rootlist * char = .CA+0 (used reg = )
LDX	#.CA
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 209 	tsn("%s%n","  hello  ");
LOC	1
.CC:
FCC	"%s%n"
FCB	0
LOC	0
LOC	1
.CD:
FCC	"  hello  "
FCB	0
LOC	0
; Debug: list * char = .CD+0 (used reg = )
LDX	#.CD
PSHS	X
; Debug: rootlist * char = .CC+0 (used reg = )
LDX	#.CC
; Debug: func () void = tsn+0 (used reg = )
JSR	>_tsn
LEAS	2,S
;BCC_EOS
; 210 	tstr("%3s%s","abcdef");
LOC	1
.CE:
FCC	"%3s%s"
FCB	0
LOC	0
LOC	1
.CF:
FCC	"abcdef"
FCB	0
LOC	0
; Debug: list * char = .CF+0 (used reg = )
LDX	#.CF
PSHS	X
; Debug: rootlist * char = .CE+0 (used reg = )
LDX	#.CE
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 211 	tstr("%s","");
LOC	1
.D0:
FCC	"%s"
FCB	0
LOC	0
LOC	1
.D1:
FCB	0
LOC	0
; Debug: list * char = .D1+0 (used reg = )
LDX	#.D1
PSHS	X
; Debug: rootlist * char = .D0+0 (used reg = )
LDX	#.D0
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 212 	tstr("%s","   ");
LOC	1
.D2:
FCC	"%s"
FCB	0
LOC	0
LOC	1
.D3:
FCC	"   "
FCB	0
LOC	0
; Debug: list * char = .D3+0 (used reg = )
LDX	#.D3
PSHS	X
; Debug: rootlist * char = .D2+0 (used reg = )
LDX	#.D2
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 213 	tstr("%s %s%n","a\tb\nc");
LOC	1
.D4:
FCC	"%s %s%n"
FCB	0
LOC	0
LOC	1
.D5:
FCC	"a"
FCB	9
FCC	"b"
FCB	$A
FCC	"c"
FCB	0
LOC	0
; Debug: list * char = .D5+0 (used reg = )
LDX	#.D5
PSHS	X
; Debug: rootlist * char = .D4+0 (used reg = )
LDX	#.D4
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 214 	tstr("%*s%s","skip this");
LOC	1
.D6:
FCC	"%*s%s"
FCB	0
LOC	0
LOC	1
.D7:
FCC	"skip this"
FCB	0
LOC	0
; Debug: list * char = .D7+0 (used reg = )
LDX	#.D7
PSHS	X
; Debug: rootlist * char = .D6+0 (used reg = )
LDX	#.D6
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 215 
; 216 	 
; 217 	tstr("%c","x");
LOC	1
.D8:
FCC	"%c"
FCB	0
LOC	0
LOC	1
.D9:
FCC	"x"
FCB	0
LOC	0
; Debug: list * char = .D9+0 (used reg = )
LDX	#.D9
PSHS	X
; Debug: rootlist * char = .D8+0 (used reg = )
LDX	#.D8
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 218 	tstr("%c%c"," y");
LOC	1
.DA:
FCC	"%c%c"
FCB	0
LOC	0
LOC	1
.DB:
FCC	" y"
FCB	0
LOC	0
; Debug: list * char = .DB+0 (used reg = )
LDX	#.DB
PSHS	X
; Debug: rootlist * char = .DA+0 (used reg = )
LDX	#.DA
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 219 	tsn(" %c%n","  z");
LOC	1
.DC:
FCC	" %c%n"
FCB	0
LOC	0
LOC	1
.DD:
FCC	"  z"
FCB	0
LOC	0
; Debug: list * char = .DD+0 (used reg = )
LDX	#.DD
PSHS	X
; Debug: rootlist * char = .DC+0 (used reg = )
LDX	#.DC
; Debug: func () void = tsn+0 (used reg = )
JSR	>_tsn
LEAS	2,S
;BCC_EOS
; 220 	tstr("%3c","abcd");
LOC	1
.DE:
FCC	"%3c"
FCB	0
LOC	0
LOC	1
.DF:
FCC	"abcd"
FCB	0
LOC	0
; Debug: list * char = .DF+0 (used reg = )
LDX	#.DF
PSHS	X
; Debug: rootlist * char = .DE+0 (used reg = )
LDX	#.DE
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 221 	tstr("%3c%c","abcd");
LOC	1
.E0:
FCC	"%3c%c"
FCB	0
LOC	0
LOC	1
.E1:
FCC	"abcd"
FCB	0
LOC	0
; Debug: list * char = .E1+0 (used reg = )
LDX	#.E1
PSHS	X
; Debug: rootlist * char = .E0+0 (used reg = )
LDX	#.E0
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 222 	tstr("%c","");
LOC	1
.E2:
FCC	"%c"
FCB	0
LOC	0
LOC	1
.E3:
FCB	0
LOC	0
; Debug: list * char = .E3+0 (used reg = )
LDX	#.E3
PSHS	X
; Debug: rootlist * char = .E2+0 (used reg = )
LDX	#.E2
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 223 	tstr("%3c","ab");
LOC	1
.E4:
FCC	"%3c"
FCB	0
LOC	0
LOC	1
.E5:
FCC	"ab"
FCB	0
LOC	0
; Debug: list * char = .E5+0 (used reg = )
LDX	#.E5
PSHS	X
; Debug: rootlist * char = .E4+0 (used reg = )
LDX	#.E4
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 224 	tstr("%*c%c","pq");
LOC	1
.E6:
FCC	"%*c%c"
FCB	0
LOC	0
LOC	1
.E7:
FCC	"pq"
FCB	0
LOC	0
; Debug: list * char = .E7+0 (used reg = )
LDX	#.E7
PSHS	X
; Debug: rootlist * char = .E6+0 (used reg = )
LDX	#.E6
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 225 
; 226 	 
; 227 	tstr("%[a-z]","abc123");
LOC	1
.E8:
FCC	"%[a-z]"
FCB	0
LOC	0
LOC	1
.E9:
FCC	"abc123"
FCB	0
LOC	0
; Debug: list * char = .E9+0 (used reg = )
LDX	#.E9
PSHS	X
; Debug: rootlist * char = .E8+0 (used reg = )
LDX	#.E8
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 228 	tstr("%[a-z]%s","abc123");
LOC	1
.EA:
FCC	"%[a-z]%s"
FCB	0
LOC	0
LOC	1
.EB:
FCC	"abc123"
FCB	0
LOC	0
; Debug: list * char = .EB+0 (used reg = )
LDX	#.EB
PSHS	X
; Debug: rootlist * char = .EA+0 (used reg = )
LDX	#.EA
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 229 	tstr("%[^,],%[^,]","foo,bar");
LOC	1
.EC:
FCC	"%[^,],%[^,]"
FCB	0
LOC	0
LOC	1
.ED:
FCC	"foo,bar"
FCB	0
LOC	0
; Debug: list * char = .ED+0 (used reg = )
LDX	#.ED
PSHS	X
; Debug: rootlist * char = .EC+0 (used reg = )
LDX	#.EC
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 230 	tstr("%[^,],%[^,]","foo,,bar");
LOC	1
.EE:
FCC	"%[^,],%[^,]"
FCB	0
LOC	0
LOC	1
.EF:
FCC	"foo,,bar"
FCB	0
LOC	0
; Debug: list * char = .EF+0 (used reg = )
LDX	#.EF
PSHS	X
; Debug: rootlist * char = .EE+0 (used reg = )
LDX	#.EE
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 231 	tstr("%[]a]%s","]a]b");
LOC	1
.F0:
FCC	"%[]a]%s"
FCB	0
LOC	0
LOC	1
.F1:
FCC	"]a]b"
FCB	0
LOC	0
; Debug: list * char = .F1+0 (used reg = )
LDX	#.F1
PSHS	X
; Debug: rootlist * char = .F0+0 (used reg = )
LDX	#.F0
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 232 	tstr("%[^]]%s","x]y");
LOC	1
.F2:
FCC	"%[^]]%s"
FCB	0
LOC	0
LOC	1
.F3:
FCC	"x]y"
FCB	0
LOC	0
; Debug: list * char = .F3+0 (used reg = )
LDX	#.F3
PSHS	X
; Debug: rootlist * char = .F2+0 (used reg = )
LDX	#.F2
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 233 	tstr("%[a-]%s","a-b");
LOC	1
.F4:
FCC	"%[a-]%s"
FCB	0
LOC	0
LOC	1
.F5:
FCC	"a-b"
FCB	0
LOC	0
; Debug: list * char = .F5+0 (used reg = )
LDX	#.F5
PSHS	X
; Debug: rootlist * char = .F4+0 (used reg = )
LDX	#.F4
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 234 	tstr("%[-a]%s","-ab");
LOC	1
.F6:
FCC	"%[-a]%s"
FCB	0
LOC	0
LOC	1
.F7:
FCC	"-ab"
FCB	0
LOC	0
; Debug: list * char = .F7+0 (used reg = )
LDX	#.F7
PSHS	X
; Debug: rootlist * char = .F6+0 (used reg = )
LDX	#.F6
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 235 	tstr("%[0-9a-f]%s","12fz");
LOC	1
.F8:
FCC	"%[0-9a-f]%s"
FCB	0
LOC	0
LOC	1
.F9:
FCC	"12fz"
FCB	0
LOC	0
; Debug: list * char = .F9+0 (used reg = )
LDX	#.F9
PSHS	X
; Debug: rootlist * char = .F8+0 (used reg = )
LDX	#.F8
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 236 	tstr("%2[a-z]%s","abc");
LOC	1
.FA:
FCC	"%2[a-z]%s"
FCB	0
LOC	0
LOC	1
.FB:
FCC	"abc"
FCB	0
LOC	0
; Debug: list * char = .FB+0 (used reg = )
LDX	#.FB
PSHS	X
; Debug: rootlist * char = .FA+0 (used reg = )
LDX	#.FA
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 237 	tstr("%[a-z]","123");
LOC	1
.FC:
FCC	"%[a-z]"
FCB	0
LOC	0
LOC	1
.FD:
FCC	"123"
FCB	0
LOC	0
; Debug: list * char = .FD+0 (used reg = )
LDX	#.FD
PSHS	X
; Debug: rootlist * char = .FC+0 (used reg = )
LDX	#.FC
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 238 	tstr("%[a-z]","");
LOC	1
.FE:
FCC	"%[a-z]"
FCB	0
LOC	0
LOC	1
.FF:
FCB	0
LOC	0
; Debug: list * char = .FF+0 (used reg = )
LDX	#.FF
PSHS	X
; Debug: rootlist * char = .FE+0 (used reg = )
LDX	#.FE
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 239 	tstr("%*[a-z]%s","abc 12");
LOC	1
.100:
FCC	"%*[a-z]%s"
FCB	0
LOC	0
LOC	1
.101:
FCC	"abc 12"
FCB	0
LOC	0
; Debug: list * char = .101+0 (used reg = )
LDX	#.101
PSHS	X
; Debug: rootlist * char = .100+0 (used reg = )
LDX	#.100
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 240 	tstr("%[ ]%s%n","  x");
LOC	1
.102:
FCC	"%[ ]%s%n"
FCB	0
LOC	0
LOC	1
.103:
FCC	"  x"
FCB	0
LOC	0
; Debug: list * char = .103+0 (used reg = )
LDX	#.103
PSHS	X
; Debug: rootlist * char = .102+0 (used reg = )
LDX	#.102
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 241 	tsn("%[^\n]%n","a line\nnext");
LOC	1
.104:
FCC	"%[^"
FCB	$A
FCC	"]%n"
FCB	0
LOC	0
LOC	1
.105:
FCC	"a line"
FCB	$A
FCC	"next"
FCB	0
LOC	0
; Debug: list * char = .105+0 (used reg = )
LDX	#.105
PSHS	X
; Debug: rootlist * char = .104+0 (used reg = )
LDX	#.104
; Debug: func () void = tsn+0 (used reg = )
JSR	>_tsn
LEAS	2,S
;BCC_EOS
; 242 	tstr("%[abc]%[cba]","abba");
LOC	1
.106:
FCC	"%[abc]%[cba]"
FCB	0
LOC	0
LOC	1
.107:
FCC	"abba"
FCB	0
LOC	0
; Debug: list * char = .107+0 (used reg = )
LDX	#.107
PSHS	X
; Debug: rootlist * char = .106+0 (used reg = )
LDX	#.106
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 243 	tstr("%s%[ ]","x");
LOC	1
.108:
FCC	"%s%[ ]"
FCB	0
LOC	0
LOC	1
.109:
FCC	"x"
FCB	0
LOC	0
; Debug: list * char = .109+0 (used reg = )
LDX	#.109
PSHS	X
; Debug: rootlist * char = .108+0 (used reg = )
LDX	#.108
; Debug: func () void = tstr+0 (used reg = )
JSR	>_tstr
LEAS	2,S
;BCC_EOS
; 244 }
RTS
; 245 
; 246 void others()
; 247 {
EXPORT	_others
_others:
; 248 	char buf[32];
;BCC_EOS
; 249 	void *p;
;BCC_EOS
; 250 	int a, b, r, n;
;BCC_EOS
; 251 
; 252 	 
; 253 	p = 0;
LEAS	-$2A,S
; Debug: eq int = const 0 to * void p = [S+$2A-$22] (used reg = )
CLRA
CLRB
STD	8,S
;BCC_EOS
; 254 	r = sscanf("0x1234","%p",&p);
LOC	1
.10A:
FCC	"0x1234"
FCB	0
LOC	0
LOC	1
.10B:
FCC	"%p"
FCB	0
LOC	0
; Debug: list * * void p = S+$2A-$22 (used reg = )
LEAX	8,S
PSHS	X
; Debug: list * char = .10B+0 (used reg = )
LDX	#.10B
PSHS	X
; Debug: rootlist * char = .10A+0 (used reg = )
LDX	#.10A
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	4,S
; Debug: eq int = X+0 to int r = [S+$2A-$28] (used reg = )
STX	2,S
;BCC_EOS
; 255 	printf("%d %u\n",r,(unsigned)(unsigned long)p);
LOC	1
.10C:
FCC	"%d %u"
FCB	$A
FCB	0
LOC	0
; Debug: cast unsigned long = const 0 to * void p = [S+$2A-$22] (used reg = )
LDD	8,S
EXG	D,X
CLRA
CLRB
TFR	X,D
; Debug: list unsigned int = D+0 (used reg = )
PSHS	D
; Debug: list int r = [S+$2C-$28] (used reg = )
LDD	4,S
PSHS	D
; Debug: rootlist * char = .10C+0 (used reg = )
LDX	#.10C
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 256 	sprintf(buf,"%p
; 256 ",(void *)0x4321);
LOC	1
.10D:
FCC	"%p"
FCB	0
LOC	0
; Debug: list * void = const $4321 (used reg = )
LDD	#$4321
PSHS	D
; Debug: list * char = .10D+0 (used reg = )
LDX	#.10D
PSHS	X
; Debug: rootlist * char buf = S+$2E-$20 (used reg = )
LEAX	$E,S
; Debug: func () int = sprintf+0 (used reg = )
JSR	>_sprintf
LEAS	4,S
;BCC_EOS
; 257 	r = sscanf(buf,"%p",&p);
LOC	1
.10E:
FCC	"%p"
FCB	0
LOC	0
; Debug: list * * void p = S+$2A-$22 (used reg = )
LEAX	8,S
PSHS	X
; Debug: list * char = .10E+0 (used reg = )
LDX	#.10E
PSHS	X
; Debug: rootlist * char buf = S+$2E-$20 (used reg = )
LEAX	$E,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	4,S
; Debug: eq int = X+0 to int r = [S+$2A-$28] (used reg = )
STX	2,S
LEAX	-1,X
BNE	.10F
.111:
; Debug: logeq * void = const $4321 to * void p = [S+$2A-$22] (used reg = )
LDX	8,S
CMPX	#$4321
BNE	.10F
.110:
LDB	#1
BRA	.112
.10F:
CLRB
.112:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 259 
; 260 	 
; 261 	sprintf(buf,"%d %x %o %s",-1234,0xbeef,0644,"word");
LOC	1
.113:
FCC	"%d %x %o %s"
FCB	0
LOC	0
LOC	1
.114:
FCC	"word"
FCB	0
LOC	0
; Debug: list * char = .114+0 (used reg = )
LDX	#.114
PSHS	X
; Debug: list int = const $1A4 (used reg = )
LDD	#$1A4
PSHS	D
; Debug: list unsigned int = const $BEEF (used reg = )
LDD	#$BEEF
PSHS	D
; Debug: list int = const -$4D2 (used reg = )
LDD	#-$4D2
PSHS	D
; Debug: list * char = .113+0 (used reg = )
LDX	#.113
PSHS	X
; Debug: rootlist * char buf = S+$34-$20 (used reg = )
LEAX	$14,S
; Debug: func () int = sprintf+0 (used reg = )
JSR	>_sprintf
LEAS	$A,S
;BCC_EOS
; 262 	r = sscanf(buf,"%d %x %o %s%n",&a,&b,&n,buf + 20,&r);
LOC	1
.115:
FCC	"%d %x %o %s%n"
FCB	0
LOC	0
; Debug: list * int r = S+$2A-$28 (used reg = )
LEAX	2,S
PSHS	X
; Debug: list * char buf = S+$2C-$C (used reg = )
LEAX	$20,S
PSHS	X
; Debug: list * int n = S+$2E-$2A (used reg = )
LEAX	4,S
PSHS	X
; Debug: list * int b = S+$30-$26 (used reg = )
LEAX	$A,S
PSHS	X
; Debug: list * int a = S+$32-$24 (used reg = )
LEAX	$E,S
PSHS	X
; Debug: list * char = .115+0 (used reg = )
LDX	#.115
PSHS	X
; Debug: rootlist * char buf = S+$36-$20 (used reg = )
LEAX	$16,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	$C,S
; Debug: eq int = X+0 to int r = [S+$2A-$28] (used reg = )
STX	2,S
;BCC_EOS
; 263 	ok(2,a == -1234 && b == 0xbeef && n == 0644);
; Debug: logeq int = const -$4D2 to int a = [S+$2A-$24] (used reg = )
LDD	6,S
SUBD	#-$4D2
BNE	.116
.119:
; Debug: logeq unsigned int = const $BEEF to int b = [S+$2A-$26] (used reg = )
LDD	4,S
SUBD	#$BEEF
BNE	.116
.118:
; Debug: logeq int = const $1A4 to int n = [S+$2A-$2A] (used reg = )
LDD	0,S
SUBD	#$1A4
BNE	.116
.117:
LDB	#1
BRA	.11A
.116:
CLRB
.11A:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 264 	ok(3,strcmp(buf + 20,"word")== 0);
LOC	1
.11B:
FCC	"word"
FCB	0
LOC	0
; Debug: list * char = .11B+0 (used reg = )
LDX	#.11B
PSHS	X
; Debug: rootlist * char buf = S+$2C-$C (used reg = )
LEAX	$20,S
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.11C
LDB	#1
BRA	.11D
.11C:
CLRB
.11D:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 3 (used reg = )
LDX	#3
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 265 
; 266 	 
; 267 	strcpy(buf,"7 8");
LOC	1
.11E:
FCC	"7 8"
FCB	0
LOC	0
; Debug: list * char = .11E+0 (used reg = )
LDX	#.11E
PSHS	X
; Debug: rootlist * char buf = S+$2C-$20 (used reg = )
LEAX	$C,S
; Debug: func () * char = strcpy+0 (used reg = )
JSR	>_strcpy
LEAS	2,S
;BCC_EOS
; 268 	a = b = 0;
; Debug: eq int = const 0 to int b = [S+$2A-$26] (used reg = )
CLRA
CLRB
STD	4,S
; Debug: eq int = D+0 to int a = [S+$2A-$24] (used reg = )
STD	6,S
;BCC_EOS
; 269 	r = sscanf(buf,"%d%d",&a,&b);
LOC	1
.11F:
FCC	"%d%d"
FCB	0
LOC	0
; Debug: list * int b = S+$2A-$26 (used reg = )
LEAX	4,S
PSHS	X
; Debug: list * int a = S+$2C-$24 (used reg = )
LEAX	8,S
PSHS	X
; Debug: list * char = .11F+0 (used reg = )
LDX	#.11F
PSHS	X
; Debug: rootlist * char buf = S+$30-$20 (used reg = )
LEAX	$10,S
; Debug: func () int = sscanf+0 (used reg = )
JSR	>_sscanf
LEAS	6,S
; Debug: eq int = X+0 to int r = [S+$2A-$28] (used reg = )
STX	2,S
;BCC_EOS
; 270 	ok(4,r == 2 && a == 7 && b == 8 && strcmp(buf,"7 8")== 0);
LOC	1
.120:
FCC	"7 8"
FCB	0
LOC	0
; Debug: logeq int = const 2 to int r = [S+$2A-$28] (used reg = )
LDX	2,S
LEAX	-2,X
BNE	.121
.125:
; Debug: logeq int = const 7 to int a = [S+$2A-$24] (used reg = )
LDX	6,S
LEAX	-7,X
BNE	.121
.124:
; Debug: logeq int = const 8 to int b = [S+$2A-$26] (used reg = )
LDX	4,S
LEAX	-8,X
BNE	.121
.123:
; Debug: list * char = .120+0 (used reg = )
LDX	#.120
PSHS	X
; Debug: rootlist * char buf = S+$2C-$20 (used reg = )
LEAX	$C,S
; Debug: func () int = strcmp+0 (used reg = )
JSR	>_strcmp
LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
LEAX	0,X
BNE	.121
.122:
LDB	#1
BRA	.126
.121:
CLRB
.126:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 4 (used reg = )
LDX	#4
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	$2c,S
RTS
; 272 
; 273  
; 274 void input()
; 275 {
EXPORT	_input
_input:
; 276 	char line[40];
;BCC_EOS
; 277 	int v, w, x, r, c;
;BCC_EOS
; 278 
; 279 	while ((r = scanf("%d",&v))== 1)
LEAS	-$32,S
LOC	1
.129:
FCC	"%d"
FCB	0
LOC	0
; 280 		printf("got %d\n",v);
BRA	.128
.12A:
LOC	1
.12B:
FCC	"got %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int v = [S+$32-$2A] (used reg = )
LDD	8,S
PSHS	D
; Debug: rootlist * char = .12B+0 (used reg = )
LDX	#.12B
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 281 	printf("stopped %d\n",r);
.128:
; Debug: list * int v = S+$32-$2A (used reg = )
LEAX	8,S
PSHS	X
; Debug: rootlist * char = .129+0 (used reg = )
LDX	#.129
; Debug: func () int = scanf+0 (used reg = )
JSR	>_scanf
LEAS	2,S
; Debug: eq int = X+0 to int r = [S+$32-$30] (used reg = )
STX	2,S
; Debug: logeq int = const 1 to int = X+0 (used reg = )
LEAX	-1,X
BEQ	.12A
.12C:
.127:
LOC	1
.12D:
FCC	"stopped %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int r = [S+$32-$30] (used reg = )
LDD	2,S
PSHS	D
; Debug: rootlist * char = .12D+0 (used reg = )
LDX	#.12D
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 282 	c = (((stdin)->bufpos >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++))  ;
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
LDX	>_stdin
CMPX	>_stdin+2
BLO	.12E
.12F:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
JSR	>_fgetc
BRA	.130
.12E:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
LDX	>_stdin
LEAU	1,X
STU	>_stdin
LDB	0,X
CLRA
TFR	D,X
.130:
; Debug: eq unsigned int = X+0 to int c = [S+$32-$32] (used reg = )
STX	0,S
;BCC_EOS
; 283 	printf("next [%c]\n",c);
LOC	1
.131:
FCC	"next [%c]"
FCB	$A
FCB	0
LOC	0
; Debug: list int c = [S+$32-$32] (used reg = )
LDD	0,S
PSHS	D
; Debug: rootlist * char = .131+0 (used reg = )
LDX	#.131
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 284 	r = scanf("%d",&v);
LOC	1
.132:
FCC	"%d"
FCB	0
LOC	0
; Debug: list * int v = S+$32-$2A (used reg = )
LEAX	8,S
PSHS	X
; Debug: rootlist * char = .132+0 (used reg = )
LDX	#.132
; Debug: func () int = scanf+0 (used reg = )
JSR	>_scanf
LEAS	2,S
; Debug: eq int = X+0 to int r = [S+$32-$30] (used reg = )
STX	2,S
;BCC_EOS
; 285 	printf("%d %d\n",r,v);
LOC	1
.133:
FCC	"%d %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int v = [S+$32-$2A] (used reg = )
LDD	8,S
PSHS	D
; Debug: list int r = [S+$34-$30] (used reg = )
LDD	4,S
PSHS	D
; Debug: rootlist * char = .133+0 (used reg = )
LDX	#.133
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 286 	r = fscanf(stdin," name: %[^\n]",line);
LOC	1
.134:
FCC	" name: %[^"
FCB	$A
FCC	"]"
FCB	0
LOC	0
; Debug: list * char line = S+$32-$28 (used reg = )
LEAX	$A,S
PSHS	X
; Debug: list * char = .134+0 (used reg = )
LDX	#.134
PSHS	X
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
LDX	#_stdin
; Debug: func () int = fscanf+0 (used reg = )
JSR	>_fscanf
LEAS	4,S
; Debug: eq int = X+0 to int r = [S+$32-$30] (used reg = )
STX	2,S
;BCC_EOS
; 287 	printf("%d [%s]\n",r,line);
LOC	1
.135:
FCC	"%d [%s]"
FCB	$A
FCB	0
LOC	0
; Debug: list * char line = S+$32-$28 (used reg = )
LEAX	$A,S
PSHS	X
; Debug: list int r = [S+$34-$30] (used reg = )
LDD	4,S
PSHS	D
; Debug: rootlist * char = .135+0 (used reg = )
LDX	#.135
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 288 	r = scanf("%i%i%i",&v,&w,&x);
LOC	1
.136:
FCC	"%i%i%i"
FCB	0
LOC	0
; Debug: list * int x = S+$32-$2E (used reg = )
LEAX	4,S
PSHS	X
; Debug: list * int w = S+$34-$2C (used reg = )
LEAX	8,S
PSHS	X
; Debug: list * int v = S+$36-$2A (used reg = )
LEAX	$C,S
PSHS	X
; Debug: rootlist * char = .136+0 (used reg = )
LDX	#.136
; Debug: func () int = scanf+0 (used reg = )
JSR	>_scanf
LEAS	6,S
; Debug: eq int = X+0 to int r = [S+$32-$30] (used reg = )
STX	2,S
;BCC_EOS
; 289 	printf("%d %d %d %d\n",r,v,w,x);
LOC	1
.137:
FCC	"%d %d %d %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int x = [S+$32-$2E] (used reg = )
LDD	4,S
PSHS	D
; Debug: list int w = [S+$34-$2C] (used reg = )
LDD	8,S
PSHS	D
; Debug: list int v = [S+$36-$2A] (used reg = )
LDD	$C,S
PSHS	D
; Debug: list int r = [S+$38-$30] (used reg = )
LDD	8,S
PSHS	D
; Debug: rootlist * char = .137+0 (used reg = )
LDX	#.137
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	8,S
;BCC_EOS
; 290 	r = scanf("%3d%d",&v,&w);
LOC	1
.138:
FCC	"%3d%d"
FCB	0
LOC	0
; Debug: list * int w = S+$32-$2C (used reg = )
LEAX	6,S
PSHS	X
; Debug: list * int v = S+$34-$2A (used reg = )
LEAX	$A,S
PSHS	X
; Debug: rootlist * char = .138+0 (used reg = )
LDX	#.138
; Debug: func () int = scanf+0 (used reg = )
JSR	>_scanf
LEAS	4,S
; Debug: eq int = X+0 to int r = [S+$32-$30] (used reg = )
STX	2,S
;BCC_EOS
; 291 	printf("%d %d %d\n",r,v,w);
LOC	1
.139:
FCC	"%d %d %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int w = [S+$32-$2C] (used reg = )
LDD	6,S
PSHS	D
; Debug: list int v = [S+$34-$2A] (used reg = )
LDD	$A,S
PSHS	D
; Debug: list int r = [S+$36-$30] (used reg = )
LDD	6,S
PSHS	D
; Debug: rootlist * char = .139+0 (used reg = )
LDX	#.139
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 292 	c = (((stdin)->bufpos >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++))  ;
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
LDX	>_stdin
CMPX	>_stdin+2
BLO	.13A
.13B:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
JSR	>_fgetc
BRA	.13C
.13A:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
LDX	>_stdin
LEAU	1,X
STU	>_stdin
LDB	0,X
CLRA
TFR	D,X
.13C:
; Debug: eq unsigned int = X+0 to int c = [S+$32-$32] (used reg = )
STX	0,S
;BCC_EOS
; 293 	printf("next %d\n",c);
LOC	1
.13D:
FCC	"next %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int c = [S+$32-$32] (used reg = )
LDD	0,S
PSHS	D
; Debug: rootlist * char = .13D+0 (used reg = )
LDX	#.13D
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 294 	r = scanf("%d",&v);
LOC	1
.13E:
FCC	"%d"
FCB	0
LOC	0
; Debug: list * int v = S+$32-$2A (used reg = )
LEAX	8,S
PSHS	X
; Debug: rootlist * char = .13E+0 (used reg = )
LDX	#.13E
; Debug: func () int = scanf+0 (used reg = )
JSR	>_scanf
LEAS	2,S
; Debug: eq int = X+0 to int r = [S+$32-$30] (used reg = )
STX	2,S
;BCC_EOS
; 295 	printf("%d %d\n",r,(((stdin)->mode&0x100	  )!= 0)!= 0);
LOC	1
.13F:
FCC	"%d %d"
FCB	$A
FCB	0
LOC	0
; Debug: and int = const $100 to int = [stdin+$C] (used reg = )
LDD	>_stdin+$C
ANDA	#1
CLRB
; Debug: ne int = const 0 to int = D+0 (used reg = )
SUBD	#0
BEQ	.140
LDB	#1
BRA	.141
.140:
CLRB
.141:
; Debug: ne int = const 0 to char = B+0 (used reg = )
TSTB
BEQ	.142
LDB	#1
BRA	.143
.142:
CLRB
.143:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: list int r = [S+$34-$30] (used reg = )
LDD	4,S
PSHS	D
; Debug: rootlist * char = .13F+0 (used reg = )
LDX	#.13F
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$36,S
RTS
; 297 
; 298 int main()
; 299 {
EXPORT	_main
_main:
; 300 	numbers();
; Debug: func () void = numbers+0 (used reg = )
JSR	>_numbers
;BCC_EOS
; 301 	strings();
; Debug: func () void = strings+0 (used reg = )
JSR	>_strings
;BCC_EOS
; 302 	others();
; Debug: func () void = others+0 (used reg = )
JSR	>_others
;BCC_EOS
; 303 	input();
; Debug: func () void = input+0 (used reg = )
JSR	>_input
;BCC_EOS
; 304 	printf("checks %d failures %d\n",checks,failures);
LOC	1
.144:
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
; Debug: rootlist * char = .144+0 (used reg = )
LDX	#.144
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 305 	return failures;
LDX	>_failures
RTS
;BCC_EOS
; 306 }
; 307 
LOC	3
_checks		COMM	2
_failures		COMM	2
; 0 errors detected
