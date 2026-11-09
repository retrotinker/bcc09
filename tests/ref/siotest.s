; 1 
; 1 # 1 "siotest.c"
; 1 
; 2 
; 3 
; 4  
; 5 # 8 "../prefix.tmp/lib/bcc09/include/stdio.h"
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
; 133 extern int f
; 133 printf () __proto(FILE*,char*,...);
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
; 148 # 6 "../prefix.tmp/lib/bcc09/include/errno.h"
; 6  
; 7 # 11
; 11 extern int errno;
;BCC_EOS
; 12 # 5 "../prefix.tmp/lib/bcc09/include/string.h"
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
; 47 ext
; 47 ern char * strstr () __proto(char *,char *);
;BCC_EOS
; 48 extern char * strtok () __proto(char *,char *);
;BCC_EOS
; 49 extern size_t strcspn () __proto(char *,char *);
;BCC_EOS
; 50 extern size_t strspn () __proto(char *,char *);
;BCC_EOS
; 51 # 5 "../prefix.tmp/lib/bcc09/include/unistd.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/lib/bcc09/include/unistd.h"
; 9 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/unistd.h"
; 10 # 22
; 22  
; 23 extern ssize_t read () __proto(int,void *,size_t);
;BCC_EOS
; 24 extern ssize_t write () __proto(int,void *,size_t);
;BCC_EOS
; 25 extern int close () __proto(int);
;BCC_EOS
; 26 extern off_t lseek () __proto(int,off_t,int);
;BCC_EOS
; 27 extern int isatty () __proto(int);
;BCC_EOS
; 28 extern int unlink () __proto(char *);
;BCC_EOS
; 29 extern int chdir () __proto(char *);	 
;BCC_EOS
; 30 
; 31 
; 32  
; 33 extern int brk () __proto(void *);
;BCC_EOS
; 34 extern void * sbrk () __proto(int);
;BCC_EOS
; 35 extern unsigned int __heap_margin;
;BCC_EOS
; 36 # 11 "siotest.c"
; 11 int checks, failures;
;BCC_EOS
; 12 
; 13 void ok(n,cond)
; 14 int n, cond;
	EXPORT	_ok
_ok:
;BCC_EOS
; 15 {
; 16 	++checks;
	PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
	LDD	>_checks
	ADDD	#1
	STD	>_checks
;BCC_EOS
; 17 	if (!cond) {
	LDD	4,S
		BNE	.1
.2:
; 18 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
	LDD	>_failures
	ADDD	#1
	STD	>_failures
;BCC_EOS
; 19 		printf("FAIL %d\n",n);
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
; 20 	}
; 21 }
.1:
	PULS	Y,PC
; 22 
; 23 void output()
; 24 {
	EXPORT	_output
_output:
; 25 	char buf[(256) ];
;BCC_EOS
; 26 
; 27 	ok(1,puts("puts")>= 0);
	LEAS	-$100,S
	LOC	1
.4:
	FCC	"puts"
	FCB	0
	LOC	0
; Debug: rootlist * char = .4+0 (used reg = )
	LDX	#.4
; Debug: func () int = puts+0 (used reg = )
	JSR	>_puts
; Debug: ge int = const 0 to int = X+0 (used reg = )
	CMPX	#0
	BLT	.5
	LDB	#1
	BRA	.6
.5:
	CLRB
.6:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 28 	ok(2,fputs("fputs, ",stdout)>= 0);
	LOC	1
.7:
	FCC	"fputs, "
	FCB	0
	LOC	0
; Debug: list * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
	PSHS	X
; Debug: rootlist * char = .7+0 (used reg = )
	LDX	#.7
; Debug: func () int = fputs+0 (used reg = )
	JSR	>_fputs
	LEAS	2,S
; Debug: ge int = const 0 to int = X+0 (used reg = )
	CMPX	#0
	BLT	.8
	LDB	#1
	BRA	.9
.8:
	CLRB
.9:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 2 (used reg = )
	LDX	#2
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 29 	(((stdout)->bufpos >= (stdout)->bufwrite)? fputc(('p'),(stdout)): (unsigned char)(*(stdout)->bufpos++ = ('p'))) ;
; Debug: ge * unsigned char = [stdout+4] to * unsigned char = [stdout+0] (used reg = )
	LDX	>_stdout
	CMPX	>_stdout+4
		BLO	.A
.B:
; Debug: list * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
	PSHS	X
; Debug: rootlist int = const $70 (used reg = )
	LDX	#$70
; Debug: func () int = fputc+0 (used reg = )
	JSR	>_fputc
	LEAS	2,S
	BRA	.C
.A:
; Debug: postinc * unsigned char = [stdout+0] (used reg = )
	LDX	>_stdout
	LEAU	1,X
	STU	>_stdout
; Debug: eq int = const $70 to unsigned char = [X+0] (used reg = )
	LDB	#$70
	STB	0,X
; Debug: cast unsigned char = const 0 to unsigned char = B+0 (used reg = )
	CLRA
	TFR	D,X
.C:
;BCC_EOS
; 30 	(((stdout)->bufpos >= (stdout)->bufwrite)? fputc((('c')),(stdout)): (unsigned char)(*(stdout)->bufpos++ = (('c'))))    ;
; Debug: ge * unsigned char = [stdout+4] to * unsigned char = [stdout+0] (used reg = )
	LDX	>_stdout
	CMPX	>_stdout+4
		BLO	.D
.E:
; Debug: list * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
	PSHS	X
; Debug: rootlist int = const $63 (used reg = )
	LDX	#$63
; Debug: func () int = fputc+0 (used reg = )
	JSR	>_fputc
	LEAS	2,S
	BRA	.F
.D:
; Debug: postinc * unsigned char = [stdout+0] (used reg = )
	LDX	>_stdout
	LEAU	1,X
	STU	>_stdout
; Debug: eq int = const $63 to unsigned char = [X+0] (used reg = )
	LDB	#$63
	STB	0,X
; Debug: cast unsigned char = const 0 to unsigned char = B+0 (used reg = )
	CLRA
	TFR	D,X
.F:
;BCC_EOS
; 31 	ok(3,fputc('\n',stdout)== '\n');
; Debug: list * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
	PSHS	X
; Debug: rootlist int = const $A (used reg = )
	LDX	#$A
; Debug: func () int = fputc+0 (used reg = )
	JSR	>_fputc
	LEAS	2,S
; Debug: logeq int = const $A to int = X+0 (used reg = )
	LEAX	-$A,X
	BNE	.10
	LDB	#1
	BRA	.11
.10:
	CLRB
.11:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 3 (used reg = )
	LDX	#3
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 32 	ok(4,fwrite("fwrite\n",1,7,stdout)== 7);
	LOC	1
.12:
	FCC	"fwrite"
	FCB	$A
	FCB	0
	LOC	0
; Debug: list * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
	PSHS	X
; Debug: list unsigned int = const 7 (used reg = )
	LDD	#7
	PSHS	D
; Debug: list unsigned int = const 1 (used reg = )
	LDD	#1
	PSHS	D
; Debug: rootlist * char = .12+0 (used reg = )
	LDX	#.12
; Debug: func () unsigned int = fwrite+0 (used reg = )
	JSR	>_fwrite
	LEAS	6,S
; Debug: logeq int = const 7 to unsigned int = X+0 (used reg = )
	LEAX	-7,X
	BNE	.13
	LDB	#1
	BRA	.14
.13:
	CLRB
.14:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 4 (used reg = )
	LDX	#4
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 33 
; 34 	 
; 35 	printf("[line ");
	LOC	1
.15:
	FCC	"[line "
	FCB	0
	LOC	0
; Debug: rootlist * char = .15+0 (used reg = )
	LDX	#.15
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 36 	fprintf(stderr,"(stderr)");
	LOC	1
.16:
	FCC	"(stderr)"
	FCB	0
	LOC	0
; Debug: list * char = .16+0 (used reg = )
	LDX	#.16
	PSHS	X
; Debug: rootlist * struct __stdio_file = stderr+0 (used reg = )
	LDX	#_stderr
; Debug: func () int = fprintf+0 (used reg = )
	JSR	>_fprintf
	LEAS	2,S
;BCC_EOS
; 37 	printf("buffered]\n");
	LOC	1
.17:
	FCC	"buffered]"
	FCB	$A
	FCB	0
	LOC	0
; Debug: rootlist * char = .17+0 (used reg = )
	LDX	#.17
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 38 
; 39 	 
; 40 	ok(5,setvbuf(stdout,(char *)0,0x02	  ,0)== 0);
; Debug: list unsigned int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: list int = const 2 (used reg = )
	LDD	#2
	PSHS	D
; Debug: list * char = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: rootlist * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
; Debug: func () int = setvbuf+0 (used reg = )
	JSR	>_setvbuf
	LEAS	6,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.18
	LDB	#1
	BRA	.19
.18:
	CLRB
.19:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 5 (used reg = )
	LDX	#5
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 41 	printf("[un");
	LOC	1
.1A:
	FCC	"[un"
	FCB	0
	LOC	0
; Debug: rootlist * char = .1A+0 (used reg = )
	LDX	#.1A
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 42 	write(1,"+",1);
	LOC	1
.1B:
	FCC	"+"
	FCB	0
	LOC	0
; Debug: list unsigned int = const 1 (used reg = )
	LDD	#1
	PSHS	D
; Debug: list * char = .1B+0 (used reg = )
	LDX	#.1B
	PSHS	X
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () int = write+0 (used reg = )
	JSR	>_write
	LEAS	4,S
;BCC_EOS
; 43 	printf("buffered]\n");
	LOC	1
.1C:
	FCC	"buffered]"
	FCB	$A
	FCB	0
	LOC	0
; Debug: rootlist * char = .1C+0 (used reg = )
	LDX	#.1C
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 44 
; 45 	 
; 46 	ok(6,setvbuf(stdout,buf,0x00	  ,sizeof(buf))== 0);
; Debug: list unsigned int = const $100 (used reg = )
	LDD	#$100
	PSHS	D
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: list * char buf = S+$104-$100 (used reg = )
	LEAX	4,S
	PSHS	X
; Debug: rootlist * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
; Debug: func () int = setvbuf+0 (used reg = )
	JSR	>_setvbuf
	LEAS	6,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.1D
	LDB	#1
	BRA	.1E
.1D:
	CLRB
.1E:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 6 (used reg = )
	LDX	#6
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 47 	printf("[full]\n");
	LOC	1
.1F:
	FCC	"[full]"
	FCB	$A
	FCB	0
	LOC	0
; Debug: rootlist * char = .1F+0 (used reg = )
	LDX	#.1F
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 48 	write(1,"(before the flush)\n",19);
	LOC	1
.20:
	FCC	"(before the flush)"
	FCB	$A
	FCB	0
	LOC	0
; Debug: list unsigned int = const $13 (used reg = )
	LDD	#$13
	PSHS	D
; Debug: list * char = .20+0 (used reg = )
	LDX	#.20
	PSHS	X
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () int = write+0 (used reg = )
	JSR	>_write
	LEAS	4,S
;BCC_EOS
; 49 	ok(7,fflush(stdout)== 0);
; Debug: rootlist * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
; Debug: func () int = fflush+0 (used reg = )
	JSR	>_fflush
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.21
	LDB	#1
	BRA	.22
.21:
	CLRB
.22:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 7 (used reg = )
	LDX	#7
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 50 
; 51 	 
; 52 	ok(8,setvbuf(stdout,(char *)0,0x01	  ,(256))== 0);
; Debug: list unsigned int = const $100 (used reg = )
	LDD	#$100
	PSHS	D
; Debug: list int = const 1 (used reg = )
	LDD	#1
	PSHS	D
; Debug: list * char = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: rootlist * struct __stdio_file = stdout+0 (used reg = )
	LDX	#_stdout
; Debug: func () int = setvbuf+0 (used reg = )
	JSR	>_setvbuf
	LEAS	6,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.23
	LDB	#1
	BRA	.24
.23:
	CLRB
.24:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 8 (used reg = )
	LDX	#8
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 53 	printf("[line again ");
	LOC	1
.25:
	FCC	"[line again "
	FCB	0
	LOC	0
; Debug: rootlist * char = .25+0 (used reg = )
	LDX	#.25
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 54 	write(1,"+",1);
	LOC	1
.26:
	FCC	"+"
	FCB	0
	LOC	0
; Debug: list unsigned int = const 1 (used reg = )
	LDD	#1
	PSHS	D
; Debug: list * char = .26+0 (used reg = )
	LDX	#.26
	PSHS	X
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () int = write+0 (used reg = )
	JSR	>_write
	LEAS	4,S
;BCC_EOS
; 55 	printf("]\n");
	LOC	1
.27:
	FCC	"]"
	FCB	$A
	FCB	0
	LOC	0
; Debug: rootlist * char = .27+0 (used reg = )
	LDX	#.27
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 56 }
	LEAS	$100,S
	RTS
; 57 
; 58 void input()
; 59 {
	EXPORT	_input
_input:
; 60 	char buf[32];
;BCC_EOS
; 61 	int c, n;
;BCC_EOS
; 62 
; 63 	c = (((stdin)->bufpos >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++))  ;
	LEAS	-$24,S
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	CMPX	>_stdin+2
		BLO	.28
.29:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
	JSR	>_fgetc
	BRA	.2A
.28:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	LEAU	1,X
	STU	>_stdin
	LDB	0,X
	CLRA
	TFR	D,X
.2A:
; Debug: eq unsigned int = X+0 to int c = [S+$24-$22] (used reg = )
	STX	2,S
;BCC_EOS
; 64 	ok(10,c == 'f');
; Debug: logeq int = const $66 to int c = [S+$24-$22] (used reg = )
	LDX	2,S
	LEAX	-$66,X
	BNE	.2B
	LDB	#1
	BRA	.2C
.2B:
	CLRB
.2C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $A (used reg = )
	LDX	#$A
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 65 	ok(11,ungetc(c,stdin)== 'f');
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: rootlist int c = [S+$26-$22] (used reg = )
	LDX	4,S
; Debug: func () int = ungetc+0 (used reg = )
	JSR	>_ungetc
	LEAS	2,S
; Debug: logeq int = const $66 to int = X+0 (used reg = )
	LEAX	-$66,X
	BNE	.2D
	LDB	#1
	BRA	.2E
.2D:
	CLRB
.2E:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $B (used reg = )
	LDX	#$B
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 66 	ok(12,(((stdin)->bufpos 
; 66 >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++))== 'f');
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	CMPX	>_stdin+2
		BLO	.2F
.30:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
	JSR	>_fgetc
	BRA	.31
.2F:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	LEAU	1,X
	STU	>_stdin
	LDB	0,X
	CLRA
	TFR	D,X
.31:
; Debug: logeq int = const $66 to unsigned int = X+0 (used reg = )
	LEAX	-$66,X
	BNE	.32
	LDB	#1
	BRA	.33
.32:
	CLRB
.33:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $C (used reg = )
	LDX	#$C
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 67 	ok(13,fgets(buf,5,stdin)== buf && strcmp(buf,"irst")== 0);
	LOC	1
.34:
	FCC	"irst"
	FCB	0
	LOC	0
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: list int = const 5 (used reg = )
	LDD	#5
	PSHS	D
; Debug: rootlist * char buf = S+$28-$20 (used reg = )
	LEAX	8,S
; Debug: func () * char = fgets+0 (used reg = )
	JSR	>_fgets
	LEAS	4,S
; Debug: logeq * char buf = S+$24-$20 to * char = X+0 (used reg = )
	LEAU	4,S
	PSHS	U
	CMPX	,S++
		BNE	.35
.37:
; Debug: list * char = .34+0 (used reg = )
	LDX	#.34
	PSHS	X
; Debug: rootlist * char buf = S+$26-$20 (used reg = )
	LEAX	6,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
		BNE	.35
.36:
	LDB	#1
	BRA	.38
.35:
	CLRB
.38:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $D (used reg = )
	LDX	#$D
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 68 	ok(14,fgets(buf,sizeof(buf),stdin)== buf
; 69 	   && strcmp(buf," line\n")== 0);
	LOC	1
.39:
	FCC	" line"
	FCB	$A
	FCB	0
	LOC	0
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: list int = const $20 (used reg = )
	LDD	#$20
	PSHS	D
; Debug: rootlist * char buf = S+$28-$20 (used reg = )
	LEAX	8,S
; Debug: func () * char = fgets+0 (used reg = )
	JSR	>_fgets
	LEAS	4,S
; Debug: logeq * char buf = S+$24-$20 to * char = X+0 (used reg = )
	LEAU	4,S
	PSHS	U
	CMPX	,S++
		BNE	.3A
.3C:
; Debug: list * char = .39+0 (used reg = )
	LDX	#.39
	PSHS	X
; Debug: rootlist * char buf = S+$26-$20 (used reg = )
	LEAX	6,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
		BNE	.3A
.3B:
	LDB	#1
	BRA	.3D
.3A:
	CLRB
.3D:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $E (used reg = )
	LDX	#$E
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 70 	ok(15,fgets(buf,sizeof(buf),stdin)== buf
; 71 	   && strcmp(buf,"second\n")== 0);
	LOC	1
.3E:
	FCC	"second"
	FCB	$A
	FCB	0
	LOC	0
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: list int = const $20 (used reg = )
	LDD	#$20
	PSHS	D
; Debug: rootlist * char buf = S+$28-$20 (used reg = )
	LEAX	8,S
; Debug: func () * char = fgets+0 (used reg = )
	JSR	>_fgets
	LEAS	4,S
; Debug: logeq * char buf = S+$24-$20 to * char = X+0 (used reg = )
	LEAU	4,S
	PSHS	U
	CMPX	,S++
		BNE	.3F
.41:
; Debug: list * char = .3E+0 (used reg = )
	LDX	#.3E
	PSHS	X
; Debug: rootlist * char buf = S+$26-$20 (used reg = )
	LEAX	6,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
		BNE	.3F
.40:
	LDB	#1
	BRA	.42
.3F:
	CLRB
.42:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $F (used reg = )
	LDX	#$F
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 72 	ok(16,fgets(buf,0,stdin)== 0);
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: rootlist * char buf = S+$28-$20 (used reg = )
	LEAX	8,S
; Debug: func () * char = fgets+0 (used reg = )
	JSR	>_fgets
	LEAS	4,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.43
	LDB	#1
	BRA	.44
.43:
	CLRB
.44:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $10 (used reg = )
	LDX	#$10
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 73 	n = 0;
; Debug: eq int = const 0 to int n = [S+$24-$24] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 74 	while ((c = (((stdin)->bufpos >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++)))!= '\n' && c != (-1))
; 75 		buf[n++] = c;
	BRA	.46
.47:
; Debug: postinc int n = [S+$24-$24] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
; Debug: ptradd int = D-1 to [$20] char buf = S+$24-$20 (used reg = )
	ADDD	#-1
	LEAX	D,S
; Debug: eq int c = [S+$24-$22] to char = [X+4] (used reg = )
	LDB	3,S
	STB	4,X
;BCC_EOS
; 76 	buf[n] = 0;
.46:
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	CMPX	>_stdin+2
		BLO	.4A
.4B:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
	JSR	>_fgetc
	BRA	.4C
.4A:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	LEAU	1,X
	STU	>_stdin
	LDB	0,X
	CLRA
	TFR	D,X
.4C:
; Debug: eq unsigned int = X+0 to int c = [S+$24-$22] (used reg = )
	STX	2,S
; Debug: ne int = const $A to int = X+0 (used reg = )
	LEAX	-$A,X
		BEQ	.48
.49:
; Debug: ne int = const -1 to int c = [S+$24-$22] (used reg = )
	LDX	2,S
	LEAX	1,X
	BNE	.47
.48:
.45:
; Debug: ptradd int n = [S+$24-$24] to [$20] char buf = S+$24-$20 (used reg = )
	LDD	0,S
	LEAX	D,S
; Debug: eq int = const 0 to char = [X+4] (used reg = )
	CLRB
	STB	4,X
;BCC_EOS
; 77 	ok(17,strcmp(buf,"12 34")== 0);
	LOC	1
.4D:
	FCC	"12 34"
	FCB	0
	LOC	0
; Debug: list * char = .4D+0 (used reg = )
	LDX	#.4D
	PSHS	X
; Debug: rootlist * char buf = S+$26-$20 (used reg = )
	LEAX	6,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.4E
	LDB	#1
	BRA	.4F
.4E:
	CLRB
.4F:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $11 (used reg = )
	LDX	#$11
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 78 	n = fread(buf,1,sizeof(buf)- 1,stdin);
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: list unsigned int = const $1F (used reg = )
	LDD	#$1F
	PSHS	D
; Debug: list unsigned int = const 1 (used reg = )
	LDD	#1
	PSHS	D
; Debug: rootlist * char buf = S+$2A-$20 (used reg = )
	LEAX	$A,S
; Debug: func () unsigned int = fread+0 (used reg = )
	JSR	>_fread
	LEAS	6,S
; Debug: eq unsigned int = X+0 to int n = [S+$24-$24] (used reg = )
	STX	0,S
;BCC_EOS
; 79 	buf[n > 0 ? n : 0] = 0;
; Debug: gt int = const 0 to int n = [S+$24-$24] (used reg = )
	LDD	0,S
		BLE	.50
.51:
	LDD	0,S
	BRA	.52
.50:
	LDD	#0
.52:
; Debug: ptradd int = D+0 to [$20] char buf = S+$24-$20 (used reg = )
	LEAX	D,S
; Debug: eq int = const 0 to char = [X+4] (used reg = )
	CLRB
	STB	4,X
;BCC_EOS
; 80 	ok(18,n == 20 && strcmp(buf,"last without newline")== 0);
	LOC	1
.53:
	FCC	"last without newline"
	FCB	0
	LOC	0
; Debug: logeq int = const $14 to int n = [S+$24-$24] (used reg = )
	LDX	0,S
	LEAX	-$14,X
		BNE	.54
.56:
; Debug: list * char = .53+0 (used reg = )
	LDX	#.53
	PSHS	X
; Debug: rootlist * char buf = S+$26-$20 (used reg = )
	LEAX	6,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
		BNE	.54
.55:
	LDB	#1
	BRA	.57
.54:
	CLRB
.57:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $12 (used reg = )
	LDX	#$12
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 81 	ok(19,(((stdin)->bufpos >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++))== (-1)&& (((stdin)->mode&0x100	  )!= 0)&& !(((stdin)->mode&0x200	  )!= 0));
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	CMPX	>_stdin+2
		BLO	.5C
.5D:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
	JSR	>_fgetc
	BRA	.5E
.5C:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	LEAU	1,X
	STU	>_stdin
	LDB	0,X
	CLRA
	TFR	D,X
.5E:
; Debug: logeq int = const -1 to unsigned int = X+0 (used reg = )
	LEAX	1,X
		BNE	.58
.5B:
; Debug: and int = const $100 to int = [stdin+$C] (used reg = )
	LDD	>_stdin+$C
	ANDA	#1
	CLRB
; Debug: ne int = const 0 to int = D+0 (used reg = )
	SUBD	#0
		BEQ	.58
.5A:
; Debug: and int = const $200 to int = [stdin+$C] (used reg = )
	LDD	>_stdin+$C
	ANDA	#2
	CLRB
; Debug: ne int = const 0 to int = D+0 (used reg = )
	SUBD	#0
		BNE	.58
.59:
	LDB	#1
	BRA	.5F
.58:
	CLRB
.5F:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $13 (used reg = )
	LDX	#$13
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 82 	ok(20,ungetc((-1),stdin)== (-1)&& (((stdin)->mode&0x100	  )!= 0));
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: rootlist int = const -1 (used reg = )
	LDX	#-1
; Debug: func () int = ungetc+0 (used reg = )
	JSR	>_ungetc
	LEAS	2,S
; Debug: logeq int = const -1 to int = X+0 (used reg = )
	LEAX	1,X
		BNE	.60
.62:
; Debug: and int = const $100 to int = [stdin+$C] (used reg = )
	LDD	>_stdin+$C
	ANDA	#1
	CLRB
; Debug: ne int = const 0 to int = D+0 (used reg = )
	SUBD	#0
		BEQ	.60
.61:
	LDB	#1
	BRA	.63
.60:
	CLRB
.63:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $14 (used reg = )
	LDX	#$14
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 83 	ok(21,ungetc('x',stdin)== 'x' && !(((stdin)->mode&0x100	  )!= 0));
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: rootlist int = const $78 (used reg = )
	LDX	#$78
; Debug: func () int = ungetc+0 (used reg = )
	JSR	>_ungetc
	LEAS	2,S
; Debug: logeq int = const $78 to int = X+0 (used reg = )
	LEAX	-$78,X
		BNE	.64
.66:
; Debug: and int = const $100 to int = [stdin+$C] (used reg = )
	LDD	>_stdin+$C
	ANDA	#1
	CLRB
; Debug: ne int = const 0 to int = D+0 (used reg = )
	SUBD	#0
		BNE	.64
.65:
	LDB	#1
	BRA	.67
.64:
	CLRB
.67:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $15 (used reg = )
	LDX	#$15
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 84 	ok(22,(((stdin)->bufpos >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++))== 'x' && (((stdin)->bufpos >= (stdin)->bufread)? fgetc(stdin):		    (*(stdin)->bufpos++))== (-1));
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	CMPX	>_stdin+2
		BLO	.6B
.6C:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
	JSR	>_fgetc
	BRA	.6D
.6B:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	LEAU	1,X
	STU	>_stdin
	LDB	0,X
	CLRA
	TFR	D,X
.6D:
; Debug: logeq int = const $78 to unsigned int = X+0 (used reg = )
	LEAX	-$78,X
		BNE	.68
.6A:
; Debug: ge * unsigned char = [stdin+2] to * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	CMPX	>_stdin+2
		BLO	.6E
.6F:
; Debug: rootlist * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
; Debug: func () int = fgetc+0 (used reg = )
	JSR	>_fgetc
	BRA	.70
.6E:
; Debug: postinc * unsigned char = [stdin+0] (used reg = )
	LDX	>_stdin
	LEAU	1,X
	STU	>_stdin
	LDB	0,X
	CLRA
	TFR	D,X
.70:
; Debug: logeq int = const -1 to unsigned int = X+0 (used reg = )
	LEAX	1,X
		BNE	.68
.69:
	LDB	#1
	BRA	.71
.68:
	CLRB
.71:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $16 (used reg = )
	LDX	#$16
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 85 	((stdin)->mode &= ~(0x100	  |0x200	  ),0) ;
; Debug: andab int = const -$301 to int = [stdin+$C] (used reg = )
	LDD	>_stdin+$C
	ANDA	#$FC
	STD	>_stdin+$C
;BCC_EOS
; 86 	ok(23,!(((stdin)->mode&0x100	  )!= 0));
; Debug: and int = const $100 to int = [stdin+$C] (used reg = )
	LDD	>_stdin+$C
	ANDA	#1
	CLRB
; Debug: ne int = const 0 to int = D+0 (used reg = )
	SUBD	#0
		BNE	.72
.73:
	LDB	#1
	BRA	.74
.72:
	CLRB
.74:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $17 (used reg = )
	LDX	#$17
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 87 }
	LEAS	$24,S
	RTS
; 88 
; 89 void files()
; 90 {
	EXPORT	_files
_files:
; 91 	FILE *fp1, *fp2;
;BCC_EOS
; 92 
; 93 	errno = 0;
	LEAS	-4,S
; Debug: eq int = const 0 to int = [errno+0] (used reg = )
	LDD	#0
	STD	>_errno
;BCC_EOS
; 94 	ok(30,fopen("nofile","r")== 0 && errno == 2		  );
	LOC	1
.75:
	FCC	"nofile"
	FCB	0
	LOC	0
	LOC	1
.76:
	FCC	"r"
	FCB	0
	LOC	0
; Debug: list * char = .76+0 (used reg = )
	LDX	#.76
	PSHS	X
; Debug: rootlist * char = .75+0 (used reg = )
	LDX	#.75
; Debug: func () * struct __stdio_file = fopen+0 (used reg = )
	JSR	>_fopen
	LEAS	2,S
; Debug: logeq int = const 0 to * struct __stdio_file = X+0 (used reg = )
	LEAX	0,X
		BNE	.77
.79:
; Debug: logeq int = const 2 to int = [errno+0] (used reg = )
	LDX	>_errno
	LEAX	-2,X
		BNE	.77
.78:
	LDB	#1
	BRA	.7A
.77:
	CLRB
.7A:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $1E (used reg = )
	LDX	#$1E
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 95 	ok(31,fopen("nofile","q")== 0);		 
	LOC	1
.7B:
	FCC	"nofile"
	FCB	0
	LOC	0
	LOC	1
.7C:
	FCC	"q"
	FCB	0
	LOC	0
; Debug: list * char = .7C+0 (used reg = )
	LDX	#.7C
	PSHS	X
; Debug: rootlist * char = .7B+0 (used reg = )
	LDX	#.7B
; Debug: func () * struct __stdio_file = fopen+0 (used reg = )
	JSR	>_fopen
	LEAS	2,S
; Debug: logeq int = const 0 to * struct __stdio_file = X+0 (used reg = )
	LEAX	0,X
	BNE	.7D
	LDB	#1
	BRA	.7E
.7D:
	CLRB
.7E:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $1F (used reg = )
	LDX	#$1F
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 96 
; 97 
; 98 	 
; 99 	fp1 = fdopen(1,"w");
	LOC	1
.7F:
	FCC	"w"
	FCB	0
	LOC	0
; Debug: list * char = .7F+0 (used reg = )
	LDX	#.7F
	PSHS	X
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () * struct __stdio_file = fdopen+0 (used reg = )
	JSR	>_fdopen
	LEAS	2,S
; Debug: eq * struct __stdio_file = X+0 to * struct __stdio_file fp1 = [S+4-2] (used reg = )
	STX	2,S
;BCC_EOS
; 100 	fp2 = fdopen(1,"w");
	LOC	1
.80:
	FCC	"w"
	FCB	0
	LOC	0
; Debug: list * char = .80+0 (used reg = )
	LDX	#.80
	PSHS	X
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () * struct __stdio_file = fdopen+0 (used reg = )
	JSR	>_fdopen
	LEAS	2,S
; Debug: eq * struct __stdio_file = X+0 to * struct __stdio_file fp2 = [S+4-4] (used reg = )
	STX	0,S
;BCC_EOS
; 101 	ok(32,fp1 != 0 && fp2 != 0 && ((fp2)->fd)== 1);
; Debug: ne int = const 0 to * struct __stdio_file fp1 = [S+4-2] (used reg = )
	LDD	2,S
		BEQ	.81
.84:
; Debug: ne int = const 0 to * struct __stdio_file fp2 = [S+4-4] (used reg = )
	LDD	0,S
		BEQ	.81
.83:
	LDX	0,S
; Debug: logeq int = const 1 to int = [X+$A] (used reg = )
	LDX	$A,X
	LEAX	-1,X
		BNE	.81
.82:
	LDB	#1
	BRA	.85
.81:
	CLRB
.85:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $20 (used reg = )
	LDX	#$20
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 102 	fprintf(fp1,"[fp1]\n");
	LOC	1
.86:
	FCC	"[fp1]"
	FCB	$A
	FCB	0
	LOC	0
; Debug: list * char = .86+0 (used reg = )
	LDX	#.86
	PSHS	X
; Debug: rootlist * struct __stdio_file fp1 = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () int = fprintf+0 (used reg = )
	JSR	>_fprintf
	LEAS	2,S
;BCC_EOS
; 103 	fprintf(fp2,"[fp2, written at exit]");
	LOC	1
.87:
	FCC	"[fp2, written at exit]"
	FCB	0
	LOC	0
; Debug: list * char = .87+0 (used reg = )
	LDX	#.87
	PSHS	X
; Debug: rootlist * struct __stdio_file fp2 = [S+6-4] (used reg = )
	LDX	2,S
; Debug: func () int = fprintf+0 (used reg = )
	JSR	>_fprintf
	LEAS	2,S
;BCC_EOS
; 104 	ok(33,fclose(fp1)== 0);
; Debug: rootlist * struct __stdio_file fp1 = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () int = fclose+0 (used reg = )
	JSR	>_fclose
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.88
	LDB	#1
	BRA	.89
.88:
	CLRB
.89:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $21 (used reg = )
	LDX	#$21
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 105 }
	PULS	U,Y,PC
; 106 
; 107 int main()
; 108 {
	EXPORT	_main
_main:
; 109 	output();
; Debug: func () void = output+0 (used reg = )
	JSR	>_output
;BCC_EOS
; 110 	input();
; Debug: func () void = input+0 (used reg = )
	JSR	>_input
;BCC_EOS
; 111 	files();
; Debug: func () void = files+0 (used reg = )
	JSR	>_files
;BCC_EOS
; 112 	printf("checks %d failures %d\n",checks,failures);
	LOC	1
.8A:
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
; Debug: rootlist * char = .8A+0 (used reg = )
	LDX	#.8A
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
	LEAS	4,S
;BCC_EOS
; 113 	printf("[stdout, written at exit]");
	LOC	1
.8B:
	FCC	"[stdout, written at exit]"
	FCB	0
	LOC	0
; Debug: rootlist * char = .8B+0 (used reg = )
	LDX	#.8B
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 114 	return failures;
	LDX	>_failures
	RTS
;BCC_EOS
; 115 }
; 116 
	LOC	3
_checks		COMM	2
_failures		COMM	2

; 0 errors detected
