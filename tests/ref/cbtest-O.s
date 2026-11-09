; 1 
; 1 # 1 "cbtest.c"
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
; 132 extern int vprintf () __proto(char*,char*);
;BCC_EOS
; 133 extern int vfprintf () __proto
; 133 (FILE*,char*,char*);
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
; 143 # 5 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 9 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 10 # 5 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 5  
; 6 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 10 # 17 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 17 extern int atoi () __proto(char *);
;BCC_EOS
; 18 extern long atol () __proto(char *);
;BCC_EOS
; 19 extern long strtol () __proto(char *,char **,int);
;BCC_EOS
; 20 extern unsigned long strtoul () __proto(char *,char **,int);
;BCC_EOS
; 21 extern double strtod () __proto(char *,char **);
;BCC_EOS
; 22 extern double atof () __proto(char *);
;BCC_EOS
; 23 
; 24 extern int abs () __proto(int);
;BCC_EOS
; 25 extern long labs () __proto(long);
;BCC_EOS
; 26 
; 27 extern int rand () __proto();
;BCC_EOS
; 28 extern void srand () __proto(unsigned int);
;BCC_EOS
; 29 
; 30 extern void qsort () __proto(void *,size_t,size_t,int (*)());
;BCC_EOS
; 31 extern void * bsearch 
; 32 
; 33 # 31
; 31 
; 32 () __proto(void *,void *,size_t,size_t
; 33 # 31 "../prefix.tmp/lib/bcc09/include/stdlib.h"
; 31 ,
; 32 int (*)());
;BCC_EOS
; 33 
; 34 extern void * malloc () __proto(size_t);
;BCC_EOS
; 35 extern void * calloc () __proto(size_t,size_t);
;BCC_EOS
; 36 extern void * realloc () __proto(void *,size_t);
;BCC_EOS
; 37 extern void free () __proto(void *);
;BCC_EOS
; 38 
; 39 extern int atexit () __proto(void (*)());
;BCC_EOS
; 40 extern void exit () __proto(int);
;BCC_EOS
; 41 extern void _exit () __proto(int);
;BCC_EOS
; 42 
; 43  
; 44 extern char * itoa () __proto(int);
;BCC_EOS
; 45 extern char * ltoa () __proto(long);
;BCC_EOS
; 46 extern char * ultoa () __proto(unsigned long);
;BCC_EOS
; 47 extern char * ltostr () __proto(long,int);
;BCC_EOS
; 48 extern char * ultostr () __proto(unsigned long,int);
;BCC_EOS
; 49 # 5 "../prefix.tmp/lib/bcc09/include/string.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/
; 5 include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/lib/bcc09/include/string.h"
; 9 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/string.h"
; 10 # 5 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 5  
; 6 # 13 "../prefix.tmp/lib/bcc09/include/string.h"
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
; 51 # 11 "cbtest.c"
; 11  
; 12 char *getline(buf,n)
; 13 char *buf;
EXPORT	_getline
_getline:
;BCC_EOS
; 14 int n;
;BCC_EOS
; 15 {
; 16 	int c, i = 0;
PSHS	CC,D,X,DP
; Debug: eq int = const 0 to int i = [S+6-6] (used reg = )
CLRA
CLRB
STD	0,S
;BCC_EOS
; 17 
; 18 	while (i < n - 1 && (c = (((stdin)->bufpos >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++)))!= (-1)) {
BRA	.2
.3:
; 19 		buf[i++] = c;
; Debug: postinc int i = [S+6-6] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
; Debug: ptradd int = D-1 to * char buf = [S+6-2] (used reg = )
ADDD	#-1
ADDD	4,S
TFR	D,X
; Debug: eq int c = [S+6-4] to char = [X+0] (used reg = )
LDB	3,S
STB	0,X
;BCC_EOS
; 20 		if (c == '\r')
; Debug: logeq int = const $D to int c = [S+6-4] (used reg = )
LDX	2,S
LEAX	-$D,X
LBNE	.4
.5:
; 21 			break;
BRA	.1
;BCC_EOS
; 22 	}
.4:
; 23 	buf[i] = 0;
.2:
; Debug: sub int = const 1 to int n = [S+6+2] (used reg = )
LDD	8,S
; Debug: lt int = D-1 to int i = [S+6-6] (used reg = )
ADDD	#-1
SUBD	0,S
BLE	.6
.7:
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
LDX	>_stdin
CMPX	>_stdin+2
BLO	.8
.9:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
JSR	>_fgetc
BRA	.A
.8:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
LDX	>_stdin
LEAU	1,X
STU	>_stdin
LDB	0,X
CLRA
TFR	D,X
.A:
; Debug: eq unsigned int = X+0 to int c = [S+6-4] (used reg = )
STX	2,S
; Debug: ne int = const -1 to int = X+0 (used reg = )
LEAX	1,X
BNE	.3
.6:
.1:
; Debug: ptradd int i = [S+6-6] to * char buf = [S+6-2] (used reg = )
LDD	0,S
ADDD	4,S
TFR	D,X
; Debug: eq int = const 0 to char = [X+0] (used reg = )
CLRB
STB	0,X
;BCC_EOS
; 24 	return i ? buf : 0;
LDD	0,S
BEQ	.B
.C:
LDX	4,S
BRA	.D
.B:
LDX	#0
.D:
; Debug: cast * char = const 0 to * char = X+0 (used reg = )
LEAS	6,S
RTS
;BCC_EOS
; 25 }
; 26 
; 27 int main()
; 28 {
EXPORT	_main
_main:
; 29 	char buf[40], *p;
;BCC_EOS
; 30 	int lines = 0;
LEAS	-$2C,S
; Debug: eq int = const 0 to int lines = [S+$2C-$2C] (used reg = )
CLRA
CLRB
STD	0,S
;BCC_EOS
; 31 
; 32 	printf("hello from Color BASIC\r");
LOC	1
.E:
FCC	"hello from Color BASIC"
FCB	$D
FCB	0
LOC	0
; Debug: rootlist * char = .E+0 (used reg = )
LDX	#.E
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
;BCC_EOS
; 33 	while (getline(buf,sizeof(buf))!= 0) {
BRA	.10
.11:
; 34 		lines++;
; Debug: postinc int lines = [S+$2C-$2C] (used reg = )
LDD	0,S
ADDD	#1
STD	0,S
;BCC_EOS
; 35 		printf("got %d: [%.*s]\r",(int)strlen(buf),(int)strlen(buf)- 1,
LOC	1
.12:
FCC	"got %d: [%.*s]"
FCB	$D
FCB	0
LOC	0
; 36 buf);
; Debug: list * char buf = S+$2C-$28 (used reg = )
LEAX	4,S
PSHS	X
; Debug: rootlist * char buf = S+$2E-$28 (used reg = )
LEAX	6,S
; Debug: func () unsigned int = strlen+0 (used reg = )
JSR	>_strlen
; Debug: cast int = const 0 to unsigned int = X+0 (used reg = )
; Debug: sub int = const 1 to int = X+0 (used reg = )
; Debug: list int = X-1 (used reg = )
LEAX	-1,X
PSHS	X
; Debug: rootlist * char buf = S+$30-$28 (used reg = )
LEAX	8,S
; Debug: func () unsigned int = strlen+0 (used reg = )
JSR	>_strlen
; Debug: cast int = const 0 to unsigned int = X+0 (used reg = )
; Debug: list int = X+0 (used reg = )
PSHS	X
; Debug: rootlist * char = .12+0 (used reg = )
LDX	#.12
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	6,S
;BCC_EOS
; 37 	}
; 38 	p = malloc(1000);
.10:
; Debug: list int = const $28 (used reg = )
LDD	#$28
PSHS	D
; Debug: rootlist * char buf = S+$2E-$28 (used reg = )
LEAX	6,S
; Debug: func () * char = getline+0 (used reg = )
JSR	>_getline
LEAS	2,S
; Debug: ne int = const 0 to * char = X+0 (used reg = )
LEAX	0,X
BNE	.11
.13:
.F:
; Debug: rootlist unsigned int = const $3E8 (used reg = )
LDX	#$3E8
; Debug: func () * void = malloc+0 (used reg = )
JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+$2C-$2A] (used reg = )
STX	2,S
;BCC_EOS
; 39 	printf("malloc %s\r",p ? "ok": "failed");
LOC	1
.14:
FCC	"malloc %s"
FCB	$D
FCB	0
LOC	0
LOC	1
.15:
FCC	"ok"
FCB	0
LOC	0
LOC	1
.16:
FCC	"failed"
FCB	0
LOC	0
LDD	2,S
BEQ	.17
.18:
LDX	#.15
BRA	.19
.17:
LDX	#.16
.19:
; Debug: list * char = X+0 (used reg = )
PSHS	X
; Debug: rootlist * char = .14+0 (used reg = )
LDX	#.14
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 40 	printf("%d lines\r",lines);
LOC	1
.1A:
FCC	"%d lines"
FCB	$D
FCB	0
LOC	0
; Debug: list int lines = [S+$2C-$2C] (used reg = )
LDD	0,S
PSHS	D
; Debug: rootlist * char = .1A+0 (used reg = )
LDX	#.1A
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 41 	return lines;
LDX	0,S
LEAS	$2C,S
RTS
;BCC_EOS
; 42 }
; 43 
; 0 errors detected
