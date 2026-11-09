; 1 
; 1 # 1 "cbtest.c"
; 1 # 6
; 6  
; 7 # 8 "../prefix.tmp/share/bcc09/include/stdio.h"
; 8  
; 9 # 6 "../prefix.tmp/share/bcc09/include/features.h"
; 6  
; 7 # 17
; 17  
; 18 # 32
; 32  
; 33 # 5 "../prefix.tmp/share/bcc09/include/sys/types.h"
; 5  
; 6 # 6 "../prefix.tmp/share/bcc09/include/features.h"
; 6  
; 7 # 10 "../prefix.tmp/share/bcc09/include/sys/types.h"
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
; 23 # 44 "../prefix.tmp/share/bcc09/include/stdio.h"
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
; 110 
; 111  
; 112 extern ssize_t getdelim () __proto(char**,size_t*,int,FILE*);
;BCC_EOS
; 113 extern ssize_t getline () __proto(char**,size_t*,FILE*);
;BCC_EOS
; 114 extern char *gets () __proto(char*);		 
;BCC_EOS
; 115 extern size_t fread () __proto(void*,size_t,size_t,FILE*);
;BCC_EOS
; 116 extern size_t fwrite () __proto(void*,size_t,size_t,FILE*);
;BCC_EOS
; 117 
; 118 extern FILE *fopen () __proto(char*,char*);
;BCC_EOS
; 119 extern int remove () __proto(char*);
;BCC_EOS
; 120 extern int rename () __proto(char*,char*);	 
;BCC_EOS
; 121 extern FILE *fdopen () __proto(int,char*);
;BCC_EOS
; 122 extern FILE *freopen  () __proto(char*,char*,FILE*);
;BCC_EOS
; 123 extern FILE *__fopen () __proto(char*,int,FILE*,char*);
;BCC_EOS
; 124 
; 125 extern int fseek () __proto(FILE*,long,int);
;BCC_EOS
; 126 extern long ftell () __proto(FILE*);
;BCC_EOS
; 127 extern void rewind () __proto(FILE*);
;BCC_EOS
; 128 
; 129 extern int fputs () __proto(char*,FILE*);
;BCC_EOS
; 130 extern int puts () __proto(char*);
;BCC_EOS
; 131 
; 132 extern int printf () __proto(char*,...);
;BCC_EOS
; 133 
; 133 extern int fprintf () __proto(FILE*,char*,...);
;BCC_EOS
; 134 extern int sprintf () __proto(char*,char*,...);
;BCC_EOS
; 135 extern int snprintf () __proto(char*,size_t,char*,...);
;BCC_EOS
; 136  
; 137 extern int vprintf () __proto(char*,char*);
;BCC_EOS
; 138 extern int vfprintf () __proto(FILE*,char*,char*);
;BCC_EOS
; 139 extern int vsprintf () __proto(char*,char*,char*);
;BCC_EOS
; 140 extern int vsnprintf () __proto(char*,size_t,char*,char*);
;BCC_EOS
; 141 
; 142 extern int scanf () __proto(char*,...);
;BCC_EOS
; 143 extern int fscanf () __proto(FILE*,char*,...);
;BCC_EOS
; 144 extern int sscanf () __proto(char*,char*,...);
;BCC_EOS
; 145 extern int vscanf () __proto(char*,char*);
;BCC_EOS
; 146 extern int vfscanf () __proto(FILE*,char*,char*);
;BCC_EOS
; 147 extern int vsscanf () __proto(char*,char*,char*);
;BCC_EOS
; 148 # 5 "../prefix.tmp/share/bcc09/include/stdlib.h"
; 5  
; 6 # 6 "../prefix.tmp/share/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/share/bcc09/include/stdlib.h"
; 9 # 5 "../prefix.tmp/share/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/share/bcc09/include/stdlib.h"
; 10 # 5 "../prefix.tmp/share/bcc09/include/stddef.h"
; 5  
; 6 # 5 "../prefix.tmp/share/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/share/bcc09/include/stddef.h"
; 10 # 17 "../prefix.tmp/share/bcc09/include/stdlib.h"
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
; 33 # 31 "../prefix.tmp/share/bcc09/include/stdlib.h"
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
; 45 extern cha
; 45 r * ltoa () __proto(long);
;BCC_EOS
; 46 extern char * ultoa () __proto(unsigned long);
;BCC_EOS
; 47 extern char * ltostr () __proto(long,int);
;BCC_EOS
; 48 extern char * ultostr () __proto(unsigned long,int);
;BCC_EOS
; 49 # 5 "../prefix.tmp/share/bcc09/include/string.h"
; 5  
; 6 # 6 "../prefix.tmp/share/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/share/bcc09/include/string.h"
; 9 # 5 "../prefix.tmp/share/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/share/bcc09/include/string.h"
; 10 # 5 "../prefix.tmp/share/bcc09/include/stddef.h"
; 5  
; 6 # 13 "../prefix.tmp/share/bcc09/include/string.h"
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
; 51 # 12 "cbtest.c"
; 12 int main()
; 13 {
	EXPORT	_main
_main:
; 14 	char *line = 0, *p;
	LEAS	-2,S
; Debug: eq int = const 0 to * char line = [S+2-2] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 15 	size_t size = 0;
	LEAS	-4,S
; Debug: eq int = const 0 to unsigned int size = [S+6-6] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 16 	int n, lines = 0;
	LEAS	-4,S
; Debug: eq int = const 0 to int lines = [S+$A-$A] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 17 
; 18 	printf("hello from Color BASIC\r");
	LOC	1
.1:
	FCC	"hello from Color BASIC"
	FCB	$D
	FCB	0
	LOC	0
; Debug: rootlist * char = .1+0 (used reg = )
	LDX	#.1
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 19 	while ((n = getdelim(&line,&size,'\r',stdin))> 0) {
	BRA	.3
.4:
; 20 		lines++;
; Debug: postinc int lines = [S+$A-$A] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 21 		printf("got %d: [%.*s]\r",n,n - 1,line);
	LOC	1
.5:
	FCC	"got %d: [%.*s]"
	FCB	$D
	FCB	0
	LOC	0
; Debug: list * char line = [S+$A-2] (used reg = )
	LDX	8,S
	PSHS	X
; Debug: sub int = const 1 to int n = [S+$C-8] (used reg = )
	LDD	4,S
; Debug: list int = D-1 (used reg = )
	ADDD	#-1
	PSHS	D
; Debug: list int n = [S+$E-8] (used reg = )
	LDD	6,S
	PSHS	D
; Debug: rootlist * char = .5+0 (used reg = )
	LDX	#.5
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
	LEAS	6,S
;BCC_EOS
; 22 	}
; 23 	p = malloc(1000);
.3:
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: list int = const $D (used reg = )
	LDD	#$D
	PSHS	D
; Debug: list * unsigned int size = S+$E-6 (used reg = )
	LEAX	8,S
	PSHS	X
; Debug: rootlist * * char line = S+$10-2 (used reg = )
	LEAX	$E,S
; Debug: func () int = getdelim+0 (used reg = )
	JSR	>_getdelim
	LEAS	6,S
; Debug: eq int = X+0 to int n = [S+$A-8] (used reg = )
	STX	2,S
; Debug: gt int = const 0 to int = X+0 (used reg = )
	CMPX	#0
	BGT	.4
.6:
.2:
; Debug: rootlist unsigned int = const $3E8 (used reg = )
	LDX	#$3E8
; Debug: func () * void = malloc+0 (used reg = )
	JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+$A-4] (used reg = )
	STX	6,S
;BCC_EOS
; 24 	printf("malloc %s\r",p ? "ok": "failed");
	LOC	1
.7:
	FCC	"malloc %s"
	FCB	$D
	FCB	0
	LOC	0
	LOC	1
.8:
	FCC	"ok"
	FCB	0
	LOC	0
	LOC	1
.9:
	FCC	"failed"
	FCB	0
	LOC	0
	LDD	6,S
		BEQ	.A
.B:
	LDX	#.8
	BRA	.C
.A:
	LDX	#.9
.C:
; Debug: list * char = X+0 (used reg = )
	PSHS	X
; Debug: rootlist * char = .7+0 (used reg = )
	LDX	#.7
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
	LEAS	2,S
;BCC_EOS
; 25 	printf("%d lines\r",lines);
	LOC	1
.D:
	FCC	"%d lines"
	FCB	$D
	FCB	0
	LOC	0
; Debug: list int lines = [S+$A-$A] (used reg = )
	LDD	0,S
	PSHS	D
; Debug: rootlist * char = .D+0 (used reg = )
	LDX	#.D
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
	LEAS	2,S
;BCC_EOS
; 26 	return lines;
	LDX	0,S
	LEAS	$A,S
	RTS
;BCC_EOS
; 27 }
; 28 

; 0 errors detected
