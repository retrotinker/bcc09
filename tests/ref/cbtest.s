; 1 
; 1 # 1 "cbtest.c"
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
; 97 extern int setvbuf ();
;BCC_EOS
; 98 
; 99  
; 100 
; 101 extern void setbuffer ();
;BCC_EOS
; 102 
; 103 extern int fgetc ();
;BCC_EOS
; 104 extern int fputc ();
;BCC_EOS
; 105 extern int ungetc ();
;BCC_EOS
; 106 
; 107 extern int fclose ();
;BCC_EOS
; 108 extern int fflush ();
;BCC_EOS
; 109 extern char *fgets ();
;BCC_EOS
; 110 extern char *gets ();		 
;BCC_EOS
; 111 extern size_t fread ();
;BCC_EOS
; 112 extern size_t fwrite ();
;BCC_EOS
; 113 
; 114 extern FILE *fopen ();
;BCC_EOS
; 115 extern FILE *fdopen ();
;BCC_EOS
; 116 extern FILE *freopen  ();
;BCC_EOS
; 117 extern FILE *__fopen ();
;BCC_EOS
; 118 
; 119 extern int fseek ();
;BCC_EOS
; 120 extern long ftell ();
;BCC_EOS
; 121 extern void rewind ();
;BCC_EOS
; 122 
; 123 extern int fputs ();
;BCC_EOS
; 124 extern int puts ();
;BCC_EOS
; 125 
; 126 extern int printf ();
;BCC_EOS
; 127 extern int fprintf ();
;BCC_EOS
; 128 extern int sprintf ();
;BCC_EOS
; 129 extern int snprintf ();
;BCC_EOS
; 130  
; 131 extern int vprintf ();
;BCC_EOS
; 132 extern int vfprintf ();
;BCC_EOS
; 133 extern int vsprintf ();
;BCC_EOS
; 134 extern int vsnprintf ();
;BCC_EOS
; 135 # 5 "../prefix.tmp/lib/bcc09/include/stdlib.h"
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
; 17 extern int atoi ();
;BCC_EOS
; 18 extern long atol ();
;BCC_EOS
; 19 extern long strtol ();
;BCC_EOS
; 20 extern unsigned long strtoul ();
;BCC_EOS
; 21 
; 22 extern int ab
; 22 s ();
;BCC_EOS
; 23 extern long labs ();
;BCC_EOS
; 24 
; 25 extern int rand ();
;BCC_EOS
; 26 extern void srand ();
;BCC_EOS
; 27 
; 28 extern void qsort ();
;BCC_EOS
; 29 extern void * bsearch 
; 30 
; 31 # 29
; 29 
; 30 ();
;BCC_EOS
; 31 
; 32 extern void * malloc ();
;BCC_EOS
; 33 extern void * calloc ();
;BCC_EOS
; 34 extern void * realloc ();
;BCC_EOS
; 35 extern void free ();
;BCC_EOS
; 36 
; 37 extern int atexit ();
;BCC_EOS
; 38 extern void exit ();
;BCC_EOS
; 39 extern void _exit ();
;BCC_EOS
; 40 
; 41  
; 42 extern char * itoa ();
;BCC_EOS
; 43 extern char * ltoa ();
;BCC_EOS
; 44 extern char * ultoa ();
;BCC_EOS
; 45 extern char * ltostr ();
;BCC_EOS
; 46 extern char * ultostr ();
;BCC_EOS
; 47 # 5 "../prefix.tmp/lib/bcc09/include/string.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
; 6  
; 7 # 9 "../prefix.tmp/lib/bcc09/include/string.h"
; 9 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/string.h"
; 10 # 5 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 5  
; 6 # 13 "../prefix.tmp/lib/bcc09/include/string.h"
; 13  
; 14 extern size_t strlen ();
;BCC_EOS
; 15 
; 16 extern char * strcat ();
;BCC_EOS
; 17 extern char * strcpy ();
;BCC_EOS
; 18 extern int strcmp ();
;BCC_EOS
; 19 
; 20 extern char * strncat ();
;BCC_EOS
; 21 extern char * strncpy ();
;BCC_EOS
; 22 extern int strncmp ();
;BCC_EOS
; 23 
; 24 extern char * strchr ();
;BCC_EOS
; 25 extern char * strrchr ();
;BCC_EOS
; 26 extern char * strdup ();
;BCC_EOS
; 27 
; 28  
; 29 extern void * memcpy ();
;BCC_EOS
; 30 extern void * memccpy ();
;BCC_EOS
; 31 extern void * memchr ();
;BCC_EOS
; 32 extern void * memset ();
;BCC_EOS
; 33 extern int memcmp ();
;BCC_EOS
; 34 
; 35 extern void * memmove ();
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
; 45 extern char * strpbrk ();
;BCC_EOS
; 46 extern char * strsep ();
;BCC_EOS
; 47 extern char * strstr ();
;BCC_EOS
; 48 extern char * strtok ();
;BCC_EOS
; 49 extern size_t strcspn ();
;BCC_EOS
; 50 extern size_t strspn ();
;BCC_EOS
; 51 # 10 "cbtest.c"
; 10 int main()
; 11 {
	EXPORT	_main
_main:
; 12 	char buf[40], *p;
;BCC_EOS
; 13 	int lines = 0;
	LEAS	-$2C,S
; Debug: eq int = const 0 to int lines = [S+$2C-$2C] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 14 
; 15 	printf("hello from Color BASIC\n");
	LOC	1
.1:
	FCC	"hello from Color BASIC"
	FCB	$A
	FCB	0
	LOC	0
; Debug: rootlist * char = .1+0 (used reg = )
	LDX	#.1
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
;BCC_EOS
; 16 	while (fgets(buf,sizeof(buf),stdin)!= 0) {
	BRA	.3
.4:
; 17 		lines++;
; Debug: postinc int lines = [S+$2C-$2C] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
;BCC_EOS
; 18 		printf("got %d: [%.*s]\n",(int)strlen(buf),(int)strlen(buf)- 1,
	LOC	1
.5:
	FCC	"got %d: [%.*s]"
	FCB	$A
	FCB	0
	LOC	0
; 19 buf);
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
; Debug: rootlist * char = .5+0 (used reg = )
	LDX	#.5
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
	LEAS	6,S
;BCC_EOS
; 20 	}
; 21 	p = malloc(1000);
.3:
; Debug: list * struct __stdio_file = stdin+0 (used reg = )
	LDX	#_stdin
	PSHS	X
; Debug: list int = const $28 (used reg = )
	LDD	#$28
	PSHS	D
; Debug: rootlist * char buf = S+$30-$28 (used reg = )
	LEAX	8,S
; Debug: func () * char = fgets+0 (used reg = )
	JSR	>_fgets
	LEAS	4,S
; Debug: ne int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.4
.6:
.2:
; Debug: rootlist int = const $3E8 (used reg = )
	LDX	#$3E8
; Debug: func () * void = malloc+0 (used reg = )
	JSR	>_malloc
; Debug: eq * void = X+0 to * char p = [S+$2C-$2A] (used reg = )
	STX	2,S
;BCC_EOS
; 22 	printf("malloc %s\n",p ? "ok": "failed");
	LOC	1
.7:
	FCC	"malloc %s"
	FCB	$A
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
	LDD	2,S
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
; 23 	printf("%d lines\n",lines);
	LOC	1
.D:
	FCC	"%d lines"
	FCB	$A
	FCB	0
	LOC	0
; Debug: list int lines = [S+$2C-$2C] (used reg = )
	LDD	0,S
	PSHS	D
; Debug: rootlist * char = .D+0 (used reg = )
	LDX	#.D
; Debug: func () int = printf+0 (used reg = )
	JSR	>_printf
	LEAS	2,S
;BCC_EOS
; 24 	return lines;
	LDX	0,S
	LEAS	$2C,S
	RTS
;BCC_EOS
; 25 }
; 26 

; 0 errors detected
