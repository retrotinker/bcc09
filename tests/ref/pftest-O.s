; 1 
; 1 # 1 "pftest.c"
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
; 51 # 10 "pftest.c"
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
; 22 static char *flags[] = {
LOC	3
_flags:
; 23 	"", "-", "+", " ", "#", "0", "-+", "+0", " 0", "#0", "-#", "- 0", 0
LOC	1
.4:
FCB	0
LOC	3
FDB	.4+0
LOC	1
.5:
FCC	"-"
FCB	0
LOC	3
FDB	.5+0
LOC	1
.6:
FCC	"+"
FCB	0
LOC	3
FDB	.6+0
LOC	1
.7:
FCC	" "
FCB	0
LOC	3
FDB	.7+0
LOC	1
.8:
FCC	"#"
FCB	0
LOC	3
FDB	.8+0
LOC	1
.9:
FCC	"0"
FCB	0
LOC	3
FDB	.9+0
LOC	1
.A:
FCC	"-+"
FCB	0
LOC	3
FDB	.A+0
LOC	1
.B:
FCC	"+0"
FCB	0
LOC	3
FDB	.B+0
LOC	1
.C:
FCC	" 0"
FCB	0
LOC	3
FDB	.C+0
LOC	1
.D:
FCC	"#0"
FCB	0
LOC	3
FDB	.D+0
LOC	1
.E:
FCC	"-#"
FCB	0
LOC	3
FDB	.E+0
LOC	1
.F:
FCC	"- 0"
FCB	0
LOC	3
FDB	.F+0
; 24 };
FDB	0
;BCC_EOS
; 25 static char *widths[] = { "", "1", "7", 0 };
_widths:
LOC	1
.10:
FCB	0
LOC	3
FDB	.10+0
LOC	1
.11:
FCC	"1"
FCB	0
LOC	3
FDB	.11+0
LOC	1
.12:
FCC	"7"
FCB	0
LOC	3
FDB	.12+0
FDB	0
;BCC_EOS
; 26 static char *precs[] = { "", ".0", ".1", ".4", 0 };
_precs:
LOC	1
.13:
FCB	0
LOC	3
FDB	.13+0
LOC	1
.14:
FCC	".0"
FCB	0
LOC	3
FDB	.14+0
LOC	1
.15:
FCC	".1"
FCB	0
LOC	3
FDB	.15+0
LOC	1
.16:
FCC	".4"
FCB	0
LOC	3
FDB	.16+0
FDB	0
;BCC_EOS
; 27 static int ivals[] = { 0, 1, -1, 7, -42, 255, 4096, 32767, -32767 };
_ivals:
FDB	0
FDB	1
FDB	$FFFF
FDB	7
FDB	$FFD6
FDB	$FF
FDB	$1000
FDB	$7FFF
FDB	$8001
;BCC_EOS
; 28 static unsigned uvals[] = { 0, 1, 8, 42, 255, 4096, 32768U, 65535U };
_uvals:
FDB	0
FDB	1
FDB	8
FDB	$2A
FDB	$FF
FDB	$1000
FDB	$8000
FDB	$FFFF
;BCC_EOS
; 29 static long lvals[] = { 0L, 1L, -1L, 65536L, -100000L, 2147483647L };
_lvals:
FDB	0
FDB	0
FDB	0
FDB	1
FDB	$FFFF
FDB	$FFFF
FDB	1
FDB	0
FDB	$FFFE
FDB	$7960
FDB	$7FFF
FDB	$FFFF
;BCC_EOS
; 30 static unsigned long ulvals[] = { 0L, 65535L, 65536L, 4294967295UL };
_ulvals:
FDB	0
FDB	0
FDB	0
FDB	$FFFF
FDB	1
FDB	0
FDB	$FFFF
FDB	$FFFF
;BCC_EOS
; 31 
; 32 
; 33 
; 34  
; 35 void grid(c,size)
; 36 char *c;
LOC	0
EXPORT	_grid
_grid:
;BCC_EOS
; 37 int size;
;BCC_EOS
; 38 {
; 39 	char fmt[32];
;BCC_EOS
; 40 	int f, w, p, v, n;
;BCC_EOS
; 41 
; 42 	for (f = 0; flags[f]; f++)
PSHS	X
LEAS	-$2A,S
; Debug: eq int = const 0 to int f = [S+$2C-$24] (used reg = )
CLRA
CLRB
STD	8,S
;BCC_EOS
;BCC_EOS
; 43 		for (w = 0; widths[w]; w++)
JMP	.19
.1A:
; Debug: eq int = const 0 to int w = [S+$2C-$26] (used reg = )
CLRA
CLRB
STD	6,S
;BCC_EOS
;BCC_EOS
; 44 			for (p = 0; precs[p]; p++) {
JMP	.1D
.1E:
; Debug: eq int = const 0 to int p = [S+$2C-$28] (used reg = )
CLRA
CLRB
STD	4,S
;BCC_EOS
;BCC_EOS
JMP	.21
.22:
; 45 				strcpy(fmt,"[%");
LOC	1
.23:
FCC	"[%"
FCB	0
LOC	0
; Debug: list * char = .23+0 (used reg = )
LDX	#.23
PSHS	X
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () * char = strcpy+0 (used reg = )
JSR	>_strcpy
LEAS	2,S
;BCC_EOS
; 46 				strcat(fmt,flags[f]);
; Debug: ptradd int f = [S+$2C-$24] to [$D] * char = flags+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_flags
LEAX	D,X
; Debug: list * char = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () * char = strcat+0 (used reg = )
JSR	>_strcat
LEAS	2,S
;BCC_EOS
; 47 				strcat(fmt,widths[w]);
; Debug: ptradd int w = [S+$2C-$26] to [4] * char = widths+0 (used reg = )
LDD	6,S
LSLB
ROLA
LDX	#_widths
LEAX	D,X
; Debug: list * char = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () * char = strcat+0 (used reg = )
JSR	>_strcat
LEAS	2,S
;BCC_EOS
; 48 				strcat(fmt,precs[p]);
; Debug: ptradd int p = [S+$2C-$28] to [5] * char = precs+0 (used reg = )
LDD	4,S
LSLB
ROLA
LDX	#_precs
LEAX	D,X
; Debug: list * char = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () * char = strcat+0 (used reg = )
JSR	>_strcat
LEAS	2,S
;BCC_EOS
; 49 				strcat(fmt,c);
; Debug: list * char c = [S+$2C-2] (used reg = )
LDX	$2A,S
PSHS	X
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () * char = strcat+0 (used reg = )
JSR	>_strcat
LEAS	2,S
;BCC_EOS
; 50 				strcat(fmt,"]");
LOC	1
.24:
FCC	"]"
FCB	0
LOC	0
; Debug: list * char = .24+0 (used reg = )
LDX	#.24
PSHS	X
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () * char = strcat+0 (used reg = )
JSR	>_strcat
LEAS	2,S
;BCC_EOS
; 51 				printf("%s ",fmt);
LOC	1
.25:
FCC	"%s "
FCB	0
LOC	0
; Debug: list * char fmt = S+$2C-$22 (used reg = )
LEAX	$A,S
PSHS	X
; Debug: rootlist * char = .25+0 (used reg = )
LDX	#.25
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 52 				if (size == 0 && (*c == 'd' || *c == 'i'))
; Debug: logeq int = const 0 to int size = [S+$2C+2] (used reg = )
LDD	$2E,S
BNE	.26
.28:
; Debug: logeq int = const $64 to char c = [[S+$2C-2]] (used reg = )
LDB	[$2A,S]
SUBB	#$64
BEQ	.27
.29:
; Debug: logeq int = const $69 to char c = [[S+$2C-2]] (used reg = )
LDB	[$2A,S]
SUBB	#$69
BNE	.26
.27:
; 53 					for (v = 0; v < (sizeof(ivals)/ sizeof(ivals[0])); v++)
; Debug: eq int = const 0 to int v = [S+$2C-$2A] (used reg = )
CLRA
CLRB
STD	2,S
;BCC_EOS
;BCC_EOS
; 54 						printf(fmt,ivals[v]);
BRA	.2C
.2D:
; Debug: ptradd int v = [S+$2C-$2A] to [9] int = ivals+0 (used reg = )
LDD	2,S
LSLB
ROLA
LDX	#_ivals
LEAX	D,X
; Debug: list int = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 55 				else if (size == 0)
.2B:
; Debug: postinc int v = [S+$2C-$2A] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.2C:
; Debug: lt int = const 9 to int v = [S+$2C-$2A] (used reg = )
LDD	2,S
SUBD	#9
BLT	.2D
.2E:
.2A:
JMP	.2F
.26:
; Debug: logeq int = const 0 to int size = [S+$2C+2] (used reg = )
LDD	$2E,S
BNE	.30
.31:
; 56 					for (v = 0; v < (sizeof(uvals)/ sizeof(uvals[0])); v++)
; Debug: eq int = const 0 to int v = [S+$2C-$2A] (used reg = )
CLRA
CLRB
STD	2,S
;BCC_EOS
;BCC_EOS
; 57 						printf(fmt,uvals[v]);
BRA	.34
.35:
; Debug: ptradd int v = [S+$2C-$2A] to [8] unsigned int = uvals+0 (used reg = )
LDD	2,S
LSLB
ROLA
LDX	#_uvals
LEAX	D,X
; Debug: list unsigned int = [X+0] (used reg = )
LDX	0,X
PSHS	X
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 58 				else if (*c == 'l' && (c[1] == 'd'))
.33:
; Debug: postinc int v = [S+$2C-$2A] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.34:
; Debug: lt int = const 8 to int v = [S+$2C-$2A] (used reg = )
LDD	2,S
SUBD	#8
BLT	.35
.36:
.32:
BRA	.37
.30:
; Debug: logeq int = const $6C to char c = [[S+$2C-2]] (used reg = )
LDB	[$2A,S]
SUBB	#$6C
BNE	.38
.3A:
; Debug: ptradd int = const 1 to * char c = [S+$2C-2] (used reg = )
LDX	$2A,S
; Debug: logeq int = const $64 to char = [X+1] (used reg = )
LDB	1,X
SUBB	#$64
BNE	.38
.39:
; 59 					for (v = 0; v < (sizeof(lvals)/ sizeof(lvals[0])); v++)
; Debug: eq int = const 0 to int v = [S+$2C-$2A] (used reg = )
CLRA
CLRB
STD	2,S
;BCC_EOS
;BCC_EOS
; 60 						printf(fmt,lvals[v]);
BRA	.3D
.3E:
; Debug: ptradd int v = [S+$2C-$2A] to [6] long = lvals+0 (used reg = )
LDD	2,S
LSLB
ROLA
LSLB
ROLA
LDX	#_lvals
LEAX	D,X
; Debug: list long = [X+0] (used reg = )
LDD	0,X
LDX	2,X
PSHS	D,X
; Debug: rootlist * char fmt = S+$30-$22 (used reg = )
LEAX	$E,S
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 61 				else
.3C:
; Debug: postinc int v = [S+$2C-$2A] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.3D:
; Debug: lt int = const 6 to int v = [S+$2C-$2A] (used reg = )
LDD	2,S
SUBD	#6
BLT	.3E
.3F:
.3B:
; 62 					for (v = 0; v < (sizeof(ulvals)/ sizeof(ulvals[0])); v++)
BRA	.40
.38:
; Debug: eq int = const 0 to int v = [S+$2C-$2A] (used reg = )
CLRA
CLRB
STD	2,S
;BCC_EOS
;BCC_EOS
; 63 						printf(fmt,ulvals[v]);
BRA	.43
.44:
; Debug: ptradd int v = [S+$2C-$2A] to [4] unsigned long = ulvals+0 (used reg = )
LDD	2,S
LSLB
ROLA
LSLB
ROLA
LDX	#_ulvals
LEAX	D,X
; Debug: list unsigned long = [X+0] (used reg = )
LDD	0,X
LDX	2,X
PSHS	D,X
; Debug: rootlist * char fmt = S+$30-$22 (used reg = )
LEAX	$E,S
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 64 				 
; 65 				if (size)
.42:
; Debug: postinc int v = [S+$2C-$2A] (used reg = )
LDD	2,S
ADDD	#1
STD	2,S
.43:
; Debug: lt int = const 4 to int v = [S+$2C-$2A] (used reg = )
LDD	2,S
SUBD	#4
BLT	.44
.45:
.41:
.40:
.37:
.2F:
LDD	$2E,S
BEQ	.46
.47:
; 66 					n = printf(fmt,1L);
; Debug: list long = const 1 (used reg = )
CLRA
CLRB
LDX	#1
PSHS	D,X
; Debug: rootlist * char fmt = S+$30-$22 (used reg = )
LEAX	$E,S
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
; Debug: eq int = X+0 to int n = [S+$2C-$2C] (used reg = )
STX	0,S
;BCC_EOS
; 67 				else
; 68 					n = printf(fmt,1);
BRA	.48
.46:
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist * char fmt = S+$2E-$22 (used reg = )
LEAX	$C,S
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
; Debug: eq int = X+0 to int n = [S+$2C-$2C] (used reg = )
STX	0,S
;BCC_EOS
; 69 				printf(" %d\n",n);
.48:
LOC	1
.49:
FCC	" %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+$2C-$2C] (used reg = )
LDD	0,S
PSHS	D
; Debug: rootlist * char = .49+0 (used reg = )
LDX	#.49
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 70 			}
; 71 }
.20:
; Debug: postinc int p = [S+$2C-$28] (used reg = )
LDD	4,S
ADDD	#1
STD	4,S
.21:
; Debug: ptradd int p = [S+$2C-$28] to [5] * char = precs+0 (used reg = )
LDD	4,S
LSLB
ROLA
LDX	#_precs
LEAX	D,X
LDD	0,X
LBNE	.22
.4A:
.1F:
.1C:
; Debug: postinc int w = [S+$2C-$26] (used reg = )
LDD	6,S
ADDD	#1
STD	6,S
.1D:
; Debug: ptradd int w = [S+$2C-$26] to [4] * char = widths+0 (used reg = )
LDD	6,S
LSLB
ROLA
LDX	#_widths
LEAX	D,X
LDD	0,X
LBNE	.1E
.4B:
.1B:
.18:
; Debug: postinc int f = [S+$2C-$24] (used reg = )
LDD	8,S
ADDD	#1
STD	8,S
.19:
; Debug: ptradd int f = [S+$2C-$24] to [$D] * char = flags+0 (used reg = )
LDD	8,S
LSLB
ROLA
LDX	#_flags
LEAX	D,X
LDD	0,X
LBNE	.1A
.4C:
.17:
LEAS	$2C,S
RTS
; 72 
; 73 void others()
; 74 {
EXPORT	_others
_others:
; 75 	char buf[32];
;BCC_EOS
; 76 	int n, m;
;BCC_EOS
; 77 	short sh;
;BCC_EOS
; 78 	long ln;
;BCC_EOS
; 79 	char *np = 0;
LEAS	-$2C,S
; Debug: eq int = const 0 to * char np = [S+$2C-$2C] (used reg = )
CLRA
CLRB
STD	0,S
;BCC_EOS
; 80 
; 81 	 
; 82 	printf("[%c][%3c][%-3c]\n",'a','b','c');
LOC	1
.4D:
FCC	"[%c][%3c][%-3c]"
FCB	$A
FCB	0
LOC	0
; Debug: list int = const $63 (used reg = )
LDD	#$63
PSHS	D
; Debug: list int = const $62 (used reg = )
LDD	#$62
PSHS	D
; Debug: list int = const $61 (used reg = )
LDD	#$61
PSHS	D
; Debug: rootlist * char = .4D+0 (used reg = )
LDX	#.4D
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 83 	printf("[%s][%8s][%-8s][%.2s][%8.3s][%-8.3s][%.0s]\n",
LOC	1
.4E:
FCC	"[%s][%8s][%-8s][%.2s][%8.3s][%-8.3s][%.0"
FCC	"s]"
FCB	$A
FCB	0
LOC	0
; 84 "hello","hello","hello","hello","hello","hello","hello");
LOC	1
.4F:
FCC	"hello"
FCB	0
LOC	0
LOC	1
.50:
FCC	"hello"
FCB	0
LOC	0
LOC	1
.51:
FCC	"hello"
FCB	0
LOC	0
LOC	1
.52:
FCC	"hello"
FCB	0
LOC	0
LOC	1
.53:
FCC	"hello"
FCB	0
LOC	0
LOC	1
.54:
FCC	"hello"
FCB	0
LOC	0
LOC	1
.55:
FCC	"hello"
FCB	0
LOC	0
; Debug: list * char = .55+0 (used reg = )
LDX	#.55
PSHS	X
; Debug: list * char = .54+0 (used reg = )
LDX	#.54
PSHS	X
; Debug: list * char = .53+0 (used reg = )
LDX	#.53
PSHS	X
; Debug: list * char = .52+0 (used reg = )
LDX	#.52
PSHS	X
; Debug: list * char = .51+0 (used reg = )
LDX	#.51
PSHS	X
; Debug: list * char = .50+0 (used reg = )
LDX	#.50
PSHS	X
; Debug: list * char = .4F+0 (used reg = )
LDX	#.4F
PSHS	X
; Debug: rootlist * char = .4E+0 (used reg = )
LDX	#.4E
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$E,S
;BCC_EOS
; 85 	printf("[%s][%5s]\n","","");
LOC	1
.56:
FCC	"[%s][%5s]"
FCB	$A
FCB	0
LOC	0
LOC	1
.57:
FCB	0
LOC	0
LOC	1
.58:
FCB	0
LOC	0
; Debug: list * char = .58+0 (used reg = )
LDX	#.58
PSHS	X
; Debug: list * char = .57+0 (used reg = )
LDX	#.57
PSHS	X
; Debug: rootlist * char = .56+0 (used reg = )
LDX	#.56
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 86 	printf("[%s]\n",np);			 
LOC	1
.59:
FCC	"[%s]"
FCB	$A
FCB	0
LOC	0
; Debug: list * char np = [S+$2C-$2C] (used reg = )
LDX	0,S
PSHS	X
; Debug: rootlist * char = .59+0 (used reg = )
LDX	#.59
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 87 	printf("[%%][%5%]\n");
LOC	1
.5A:
FCC	"[%%][%5%]"
FCB	$A
FCB	0
LOC	0
; Debug: rootlist * char = .5A+0 (used reg = )
LDX	#.5A
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
;BCC_EOS
; 88 
; 89 	 
; 90 	printf("[%*d][%-*d][%*d]\n",5,42,5,42,-5,42);
LOC	1
.5B:
FCC	"[%*d][%-*d][%*d]"
FCB	$A
FCB	0
LOC	0
; Debug: list int = const $2A (used reg = )
LDD	#$2A
PSHS	D
; Debug: list int = const -5 (used reg = )
LDD	#-5
PSHS	D
; Debug: list int = const $2A (used reg = )
LDD	#$2A
PSHS	D
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: list int = const $2A (used reg = )
LDD	#$2A
PSHS	D
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: rootlist * char = .5B+0 (used reg = )
LDX	#.5B
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$C,S
;BCC_EOS
; 91 	printf("[%.*d][%.*d][%*.*d]\n",4,7,-1,7,6,3,9);
LOC	1
.5C:
FCC	"[%.*d][%.*d][%*.*d]"
FCB	$A
FCB	0
LOC	0
; Debug: list int = const 9 (used reg = )
LDD	#9
PSHS	D
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: list int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: list int = const 7 (used reg = )
LDD	#7
PSHS	D
; Debug: list int = const -1 (used reg = )
LDD	#-1
PSHS	D
; Debug: list int = const 7 (used reg = )
LDD	#7
PSHS	D
; Debug: list int = const 4 (used reg = )
LDD	#4
PSHS	D
; Debug: rootlist * char = .5C+0 (used reg = )
LDX	#.5C
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$E,S
;BCC_EOS
; 92 	printf("[%.*s][%*s]\n",3,"abcdef",-4,"x");
LOC	1
.5D:
FCC	"[%.*s][%*s]"
FCB	$A
FCB	0
LOC	0
LOC	1
.5E:
FCC	"abcdef"
FCB	0
LOC	0
LOC	1
.5F:
FCC	"x"
FCB	0
LOC	0
; Debug: list * char = .5F+0 (used reg = )
LDX	#.5F
PSHS	X
; Debug: list int = const -4 (used reg = )
LDD	#-4
PSHS	D
; Debug: list * char = .5E+0 (used reg = )
LDX	#.5E
PSHS	X
; Debug: list int = const 3 (used reg = )
LDD	#3
PSHS	D
; Debug: rootlist * char = .5D+0 (used reg = )
LDX	#.5D
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	8,S
;BCC_EOS
; 93 
; 94 	 
; 95 	printf("[%hhd][%hhu][%hhx]\n",300,300,511);
LOC	1
.60:
FCC	"[%hhd][%hhu][%hhx]"
FCB	$A
FCB	0
LOC	0
; Debug: list int = const $1FF (used reg = )
LDD	#$1FF
PSHS	D
; Debug: list int = const $12C (used reg = )
LDD	#$12C
PSHS	D
; Debug: list int = const $12C (used reg = )
LDD	#$12C
PSHS	D
; Debug: rootlist * char = .60+0 (used reg = )
LDX	#.60
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 96 	printf("[%hd][%hu][%ho]\n",-2,2,8);
LOC	1
.61:
FCC	"[%hd][%hu][%ho]"
FCB	$A
FCB	0
LOC	0
; Debug: list int = const 8 (used reg = )
LDD	#8
PSHS	D
; Debug: list int = const 2 (used reg = )
LDD	#2
PSHS	D
; Debug: list int = const -2 (used reg = )
LDD	#-2
PSHS	D
; Debug: rootlist * char = .61+0 (used reg = )
LDX	#.61
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 97 	printf("[%ld][%li][%lu][%lx][%lX][%lo]\n",-1L,123456L,3000000000UL,
LOC	1
.62:
FCC	"[%ld][%li][%lu][%lx][%lX][%lo]"
FCB	$A
FCB	0
LOC	0
; 98 0xdeadbeefUL,0xcafeUL,8L);
; Debug: list long = const 8 (used reg = )
CLRA
CLRB
LDX	#8
PSHS	D,X
; Debug: list unsigned long = const $CAFE (used reg = )
CLRA
CLRB
LDX	#$CAFE
PSHS	D,X
; Debug: list unsigned long = const $DEADBEEF (used reg = )
LDD	#$DEAD
LDX	#$BEEF
PSHS	D,X
; Debug: list unsigned long = const $B2D05E00 (used reg = )
LDD	#$B2D0
LDX	#$5E00
PSHS	D,X
; Debug: list long = const $1E240 (used reg = )
LDD	#1
LDX	#$E240
PSHS	D,X
; Debug: list long = const -1 (used reg = )
LDD	#$FFFF
LDX	#$FFFF
PSHS	D,X
; Debug: rootlist * char = .62+0 (used reg = )
LDX	#.62
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$18,S
;BCC_EOS
; 99 
; 100 	
; 100  
; 101 	printf("[%p][%10p][%-10p]\n",(void *)0,(void *)0,(void *)0);
LOC	1
.63:
FCC	"[%p][%10p][%-10p]"
FCB	$A
FCB	0
LOC	0
; Debug: list * void = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list * void = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: list * void = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist * char = .63+0 (used reg = )
LDX	#.63
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 102 	printf("[%p][%8p][%-8p]\n",(void *)0x1234,(void *)0x1234,
LOC	1
.64:
FCC	"[%p][%8p][%-8p]"
FCB	$A
FCB	0
LOC	0
; 103 (void *)0x1234);
; Debug: list * void = const $1234 (used reg = )
LDD	#$1234
PSHS	D
; Debug: list * void = const $1234 (used reg = )
LDD	#$1234
PSHS	D
; Debug: list * void = const $1234 (used reg = )
LDD	#$1234
PSHS	D
; Debug: rootlist * char = .64+0 (used reg = )
LDX	#.64
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 104 
; 105 	 
; 106 	n = 0;
; Debug: eq int = const 0 to int n = [S+$2C-$22] (used reg = )
CLRA
CLRB
STD	$A,S
;BCC_EOS
; 107 	printf("abc%ndef\n",&n);
LOC	1
.65:
FCC	"abc%ndef"
FCB	$A
FCB	0
LOC	0
; Debug: list * int n = S+$2C-$22 (used reg = )
LEAX	$A,S
PSHS	X
; Debug: rootlist * char = .65+0 (used reg = )
LDX	#.65
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 108 	ok(1,n == 3);
; Debug: logeq int = const 3 to int n = [S+$2C-$22] (used reg = )
LDX	$A,S
LEAX	-3,X
BNE	.66
LDB	#1
BRA	.67
.66:
CLRB
.67:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 1 (used reg = )
LDX	#1
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 109 	sh = 0;
; Debug: eq int = const 0 to short sh = [S+$2C-$26] (used reg = )
CLRA
CLRB
STD	6,S
;BCC_EOS
; 110 	ln = 0;
; Debug: eq int = const 0 to long ln = [S+$2C-$2A] (used reg = )
CLRA
CLRB
LDX	#0
STD	2,S
STX	4,S
;BCC_EOS
; 111 	printf("%d%hn%ld%ln\n",12345,&sh,7L,&ln);
LOC	1
.68:
FCC	"%d%hn%ld%ln"
FCB	$A
FCB	0
LOC	0
; Debug: list * long ln = S+$2C-$2A (used reg = )
LEAX	2,S
PSHS	X
; Debug: list long = const 7 (used reg = )
CLRA
CLRB
LDX	#7
PSHS	D,X
; Debug: list * short sh = S+$32-$26 (used reg = )
LEAX	$C,S
PSHS	X
; Debug: list int = const $3039 (used reg = )
LDD	#$3039
PSHS	D
; Debug: rootlist * char = .68+0 (used reg = )
LDX	#.68
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$A,S
;BCC_EOS
; 112 	ok(2,sh == 5 && ln == 6);
; Debug: logeq int = const 5 to short sh = [S+$2C-$26] (used reg = )
LDX	6,S
LEAX	-5,X
BNE	.69
.6B:
; Debug: logeq long = const 6 to long ln = [S+$2C-$2A] (used reg = )
; Debug: expression subtree swapping
CLRA
CLRB
LDX	#6
PSHS	D,X
LDD	6,S
LDX	8,S
LEAY	0,S
JSR	>lcmp_b
LEAS	4,S
BNE	.69
.6A:
LDB	#1
BRA	.6C
.69:
CLRB
.6C:
; Debug: list char = B+0 (used reg = )
CLRA
PSHS	D
; Debug: rootlist int = const 2 (used reg = )
LDX	#2
; Debug: func () void = ok+0 (used reg = )
JSR	>_ok
LEAS	2,S
;BCC_EOS
; 113 
; 114 	 
; 115 	n = sprintf(buf,"%d-%s",-12,"xy");
LOC	1
.6D:
FCC	"%d-%s"
FCB	0
LOC	0
LOC	1
.6E:
FCC	"xy"
FCB	0
LOC	0
; Debug: list * char = .6E+0 (used reg = )
LDX	#.6E
PSHS	X
; Debug: list int = const -$C (used reg = )
LDD	#-$C
PSHS	D
; Debug: list * char = .6D+0 (used reg = )
LDX	#.6D
PSHS	X
; Debug: rootlist * char buf = S+$32-$20 (used reg = )
LEAX	$12,S
; Debug: func () int = sprintf+0 (used reg = )
JSR	>_sprintf
LEAS	6,S
; Debug: eq int = X+0 to int n = [S+$2C-$22] (used reg = )
STX	$A,S
;BCC_EOS
; 116 	printf("[%s] %d\n",buf,n);
LOC	1
.6F:
FCC	"[%s] %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+$2C-$22] (used reg = )
LDD	$A,S
PSHS	D
; Debug: list * char buf = S+$2E-$20 (used reg = )
LEAX	$E,S
PSHS	X
; Debug: rootlist * char = .6F+0 (used reg = )
LDX	#.6F
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 117 	memset(buf,'z',sizeof(buf));
; Debug: list unsigned int = const $20 (used reg = )
LDD	#$20
PSHS	D
; Debug: list int = const $7A (used reg = )
LDD	#$7A
PSHS	D
; Debug: rootlist * char buf = S+$30-$20 (used reg = )
LEAX	$10,S
; Debug: func () * void = memset+0 (used reg = )
JSR	>_memset
LEAS	4,S
;BCC_EOS
; 118 	n = snprintf(buf,6,"%s","hello, world");
LOC	1
.70:
FCC	"%s"
FCB	0
LOC	0
LOC	1
.71:
FCC	"hello, world"
FCB	0
LOC	0
; Debug: list * char = .71+0 (used reg = )
LDX	#.71
PSHS	X
; Debug: list * char = .70+0 (used reg = )
LDX	#.70
PSHS	X
; Debug: list unsigned int = const 6 (used reg = )
LDD	#6
PSHS	D
; Debug: rootlist * char buf = S+$32-$20 (used reg = )
LEAX	$12,S
; Debug: func () int = snprintf+0 (used reg = )
JSR	>_snprintf
LEAS	6,S
; Debug: eq int = X+0 to int n = [S+$2C-$22] (used reg = )
STX	$A,S
;BCC_EOS
; 119 	printf("[%s] %d %c\n",buf,n,buf[6]);
LOC	1
.72:
FCC	"[%s] %d %c"
FCB	$A
FCB	0
LOC	0
; Debug: list char buf = [S+$2C-$1A] (used reg = )
LDB	$12,S
CLRA
PSHS	D
; Debug: list int n = [S+$2E-$22] (used reg = )
LDD	$C,S
PSHS	D
; Debug: list * char buf = S+$30-$20 (used reg = )
LEAX	$10,S
PSHS	X
; Debug: rootlist * char = .72+0 (used reg = )
LDX	#.72
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 120 	memset(buf,'z',sizeof(buf));
; Debug: list unsigned int = const $20 (used reg = )
LDD	#$20
PSHS	D
; Debug: list int = const $7A (used reg = )
LDD	#$7A
PSHS	D
; Debug: rootlist * char buf = S+$30-$20 (used reg = )
LEAX	$10,S
; Debug: func () * void = memset+0 (used reg = )
JSR	>_memset
LEAS	4,S
;BCC_EOS
; 121 	n = snprintf(buf,1,"abc");
LOC	1
.73:
FCC	"abc"
FCB	0
LOC	0
; Debug: list * char = .73+0 (used reg = )
LDX	#.73
PSHS	X
; Debug: list unsigned int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist * char buf = S+$30-$20 (used reg = )
LEAX	$10,S
; Debug: func () int = snprintf+0 (used reg = )
JSR	>_snprintf
LEAS	4,S
; Debug: eq int = X+0 to int n = [S+$2C-$22] (used reg = )
STX	$A,S
;BCC_EOS
; 122 	printf("[%s] %d\n",buf,n);
LOC	1
.74:
FCC	"[%s] %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+$2C-$22] (used reg = )
LDD	$A,S
PSHS	D
; Debug: list * char buf = S+$2E-$20 (used reg = )
LEAX	$E,S
PSHS	X
; Debug: rootlist * char = .74+0 (used reg = )
LDX	#.74
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 123 	buf[0] = 'q';
; Debug: eq int = const $71 to char buf = [S+$2C-$20] (used reg = )
LDB	#$71
STB	$C,S
;BCC_EOS
; 124 	n = snprintf(buf,0,"abc");
LOC	1
.75:
FCC	"abc"
FCB	0
LOC	0
; Debug: list * char = .75+0 (used reg = )
LDX	#.75
PSHS	X
; Debug: list unsigned int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist * char buf = S+$30-$20 (used reg = )
LEAX	$10,S
; Debug: func () int = snprintf+0 (used reg = )
JSR	>_snprintf
LEAS	4,S
; Debug: eq int = X+0 to int n = [S+$2C-$22] (used reg = )
STX	$A,S
;BCC_EOS
; 125 	printf("[%c] %d\n",buf[0],n);
LOC	1
.76:
FCC	"[%c] %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+$2C-$22] (used reg = )
LDD	$A,S
PSHS	D
; Debug: list char buf = [S+$2E-$20] (used reg = )
LDB	$E,S
CLRA
PSHS	D
; Debug: rootlist * char = .76+0 (used reg = )
LDX	#.76
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 126 	n = snprintf(buf,sizeof(buf),"%05d|%x",42,255);
LOC	1
.77:
FCC	"%05d|%x"
FCB	0
LOC	0
; Debug: list int = const $FF (used reg = )
LDD	#$FF
PSHS	D
; Debug: list int = const $2A (used reg = )
LDD	#$2A
PSHS	D
; Debug: list * char = .77+0 (used reg = )
LDX	#.77
PSHS	X
; Debug: list unsigned int = const $20 (used reg = )
LDD	#$20
PSHS	D
; Debug: rootlist * char buf = S+$34-$20 (used reg = )
LEAX	$14,S
; Debug: func () int = snprintf+0 (used reg = )
JSR	>_snprintf
LEAS	8,S
; Debug: eq int = X+0 to int n = [S+$2C-$22] (used reg = )
STX	$A,S
;BCC_EOS
; 127 	printf("[%s] %d\n",buf,n);
LOC	1
.78:
FCC	"[%s] %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+$2C-$22] (used reg = )
LDD	$A,S
PSHS	D
; Debug: list * char buf = S+$2E-$20 (used reg = )
LEAX	$E,S
PSHS	X
; Debug: rootlist * char = .78+0 (used reg = )
LDX	#.78
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 128 
; 129 	 
; 130 	n = printf("twelve chars");
LOC	1
.79:
FCC	"twelve chars"
FCB	0
LOC	0
; Debug: rootlist * char = .79+0 (used reg = )
LDX	#.79
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
; Debug: eq int = X+0 to int n = [S+$2C-$22] (used reg = )
STX	$A,S
;BCC_EOS
; 131 	m = printf("\n");
LOC	1
.7A:
FCB	$A
FCB	0
LOC	0
; Debug: rootlist * char = .7A+0 (used reg = )
LDX	#.7A
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
; Debug: eq int = X+0 to int m = [S+$2C-$24] (used reg = )
STX	8,S
;BCC_EOS
; 132 	printf("%d %d\n",n,m);
LOC	1
.7B:
FCC	"%d %d"
FCB	$A
FCB	0
LOC	0
; Debug: list int m = [S+$2C-$24] (used reg = )
LDD	8,S
PSHS	D
; Debug: list int n = [S+$2E-$22] (used reg = )
LDD	$C,S
PSHS	D
; Debug: rootlist * char = .7B+0 (used reg = )
LDX	#.7B
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 133 	n = fprintf(stdout,"%s=%d\n","x",5);
LOC	1
.7C:
FCC	"%s=%d"
FCB	$A
FCB	0
LOC	0
LOC	1
.7D:
FCC	"x"
FCB	0
LOC	0
; Debug: list int = const 5 (used reg = )
LDD	#5
PSHS	D
; Debug: list * char = .7D+0 (used reg = )
LDX	#.7D
PSHS	X
; Debug: list * char = .7C+0 (used reg = )
LDX	#.7C
PSHS	X
; Debug: rootlist * struct __stdio_file = stdout+0 (used reg = )
LDX	#_stdout
; Debug: func () int = fprintf+0 (used reg = )
JSR	>_fprintf
LEAS	6,S
; Debug: eq int = X+0 to int n = [S+$2C-$22] (used reg = )
STX	$A,S
;BCC_EOS
; 134 	printf("%d\n",n);
LOC	1
.7E:
FCC	"%d"
FCB	$A
FCB	0
LOC	0
; Debug: list int n = [S+$2C-$22] (used reg = )
LDD	$A,S
PSHS	D
; Debug: rootlist * char = .7E+0 (used reg = )
LDX	#.7E
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	$2e,S
RTS
; 136 
; 137 int main()
; 138 {
EXPORT	_main
_main:
; 139 	grid("d",0);
LOC	1
.7F:
FCC	"d"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist * char = .7F+0 (used reg = )
LDX	#.7F
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 140 	grid("i",0);
LOC	1
.80:
FCC	"i"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist * char = .80+0 (used reg = )
LDX	#.80
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 141 	grid("u",0);
LOC	1
.81:
FCC	"u"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist * char = .81+0 (used reg = )
LDX	#.81
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 142 	grid("o",0);
LOC	1
.82:
FCC	"o"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist * char = .82+0 (used reg = )
LDX	#.82
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 143 	grid("x",0);
LOC	1
.83:
FCC	"x"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist * char = .83+0 (used reg = )
LDX	#.83
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 144 	grid("X",0);
LOC	1
.84:
FCC	"X"
FCB	0
LOC	0
; Debug: list int = const 0 (used reg = )
CLRA
CLRB
PSHS	D
; Debug: rootlist * char = .84+0 (used reg = )
LDX	#.84
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 145 	grid("ld",1);
LOC	1
.85:
FCC	"ld"
FCB	0
LOC	0
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist * char = .85+0 (used reg = )
LDX	#.85
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 146 	grid("lu",1);
LOC	1
.86:
FCC	"lu"
FCB	0
LOC	0
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist * char = .86+0 (used reg = )
LDX	#.86
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 147 	grid("lx",1);
LOC	1
.87:
FCC	"lx"
FCB	0
LOC	0
; Debug: list int = const 1 (used reg = )
LDD	#1
PSHS	D
; Debug: rootlist * char = .87+0 (used reg = )
LDX	#.87
; Debug: func () void = grid+0 (used reg = )
JSR	>_grid
LEAS	2,S
;BCC_EOS
; 148 	others();
; Debug: func () void = others+0 (used reg = )
JSR	>_others
;BCC_EOS
; 149 	printf("checks %d failures %d\n",checks,failures);
LOC	1
.88:
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
; Debug: rootlist * char = .88+0 (used reg = )
LDX	#.88
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	4,S
;BCC_EOS
; 150 	return failures;
LDX	>_failures
RTS
;BCC_EOS
; 151 }
; 152 
LOC	3
_checks		COMM	2
_failures		COMM	2
; 0 errors detected
