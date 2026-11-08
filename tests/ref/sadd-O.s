; 1 
; 1 # 1 "sadd.c"
; 1 
; 2  
; 3 # 8 "../prefix.tmp/lib/bcc09/include/stdio.h"
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
; 135 # 6 "sadd.c"
; 6 int main()
; 7 {
EXPORT	_main
_main:
; 8 	int a = 10;
LEAS	-2,S
; Debug: eq int = const $A to int a = [S+2-2] (used reg = )
LDD	#$A
STD	0,S
;BCC_EOS
; 9 	signed char c = -1;
LEAS	-1,S
; Debug: eq int = const -1 to char c = [S+3-3] (used reg = )
LDB	#$FF
STB	0,S
;BCC_EOS
; 10 
; 11 	printf("%d\n",a + c);
LOC	1
.1:
FCC	"%d"
FCB	$A
FCB	0
LOC	0
; Debug: add char c = [S+3-3] to int a = [S+3-2] (used reg = )
LDD	1,S
ADDB	0,S
ADCA	#0
; Debug: list int = D+0 (used reg = )
PSHS	D
; Debug: rootlist * char = .1+0 (used reg = )
LDX	#.1
; Debug: func () int = printf+0 (used reg = )
JSR	>_printf
LEAS	2,S
;BCC_EOS
; 12 	return 0;
LDX	#0
PULS	B,Y,PC
;BCC_EOS
; 13 }
; 14 
; 0 errors detected
