; 1 
; 1 # 1 "strtest.c"
; 1 # 5
; 5  
; 6 # 5 "../prefix.tmp/lib/bcc09/include/string.h"
; 5  
; 6 # 6 "../prefix.tmp/lib/bcc09/include/features.h"
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
; 21 # 5 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 5  
; 6 # 5 "../prefix.tmp/lib/bcc09/include/sys/types.h"
; 5  
; 6 # 10 "../prefix.tmp/lib/bcc09/include/stddef.h"
; 10 # 13 "../prefix.tmp/lib/bcc09/include/string.h"
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
; 26 
; 27  
; 28 extern void * memcpy ();
;BCC_EOS
; 29 extern void * memccpy ();
;BCC_EOS
; 30 extern void * memchr ();
;BCC_EOS
; 31 extern void * memset ();
;BCC_EOS
; 32 extern int memcmp ();
;BCC_EOS
; 33 
; 34 extern void * memmove ();
;BCC_EOS
; 35 
; 36  
; 37 
; 38 
; 39  
; 40 
; 41 
; 42 
; 43  
; 44 extern char * strpbrk ();
;BCC_EOS
; 45 extern char * strsep ();
;BCC_EOS
; 46 extern char * strstr ();
;BCC_EOS
; 47 extern char * strtok ();
;BCC_EOS
; 48 extern size_t strcspn ();
;BCC_EOS
; 49 extern size_t strspn ();
;BCC_EOS
; 50 # 9 "strtest.c"
; 9 extern int putchar();
;BCC_EOS
; 10 extern void putnum();
;BCC_EOS
; 11 
; 12 int checks, failures;
;BCC_EOS
; 13 
; 14 void say(s)
; 15 char *s;
	EXPORT	_say
_say:
;BCC_EOS
; 16 {
; 17 	while (*s)
	PSHS	X
; 18 		putchar(*s++);
	BRA	.2
.3:
; Debug: postinc * char s = [S+2-2] (used reg = )
	LDX	0,S
	LEAU	1,X
	STU	0,S
; Debug: rootlist char = [X+0] (used reg = )
	LDB	0,X
	CLRA
	TFR	D,X
; Debug: func () int = putchar+0 (used reg = )
	JSR	>_putchar
;BCC_EOS
; 19 }
.2:
	LDB	[0,S]
	BNE	.3
.4:
.1:
	PULS	Y,PC
; 20 
; 21  
; 22 void ok(n,cond)
; 23 int n, cond;
	EXPORT	_ok
_ok:
;BCC_EOS
; 24 {
; 25 	++checks;
	PSHS	X
; Debug: preinc int = [checks+0] (used reg = )
	LDD	>_checks
	ADDD	#1
	STD	>_checks
;BCC_EOS
; 26 	if (!cond) {
	LDD	4,S
	LBNE	.5
.6:
; 27 		++failures;
; Debug: preinc int = [failures+0] (used reg = )
	LDD	>_failures
	ADDD	#1
	STD	>_failures
;BCC_EOS
; 28 		say("FAIL ");
	LOC	1
.7:
	FCC	"FAIL "
	FCB	0
	LOC	0
; Debug: rootlist * char = .7+0 (used reg = )
	LDX	#.7
; Debug: func () void = say+0 (used reg = )
	JSR	>_say
;BCC_EOS
; 29 		putnum(n);
; Debug: rootlist int n = [S+2-2] (used reg = )
	LDX	0,S
; Debug: func () void = putnum+0 (used reg = )
	JSR	>_putnum
;BCC_EOS
; 30 	}
; 31 }
.5:
	PULS	Y,PC
; 32 
; 33 int sign(n)
; 34 int n;
	EXPORT	_sign
_sign:
;BCC_EOS
; 35 {
; 36 	return n < 0 ? -1 : n > 0;
	PSHS	X
; Debug: lt int = const 0 to int n = [S+2-2] (used reg = )
	LDD	0,S
	LBGE	.8
.9:
	LDD	#-1
	BRA	.A
.8:
; Debug: gt int = const 0 to int n = [S+2-2] (used reg = )
	LDD	0,S
	BLE	.B
	LDB	#1
	BRA	.C
.B:
	CLRB
.C:
; Debug: cast int = const 0 to char = B+0 (used reg = )
	CLRA
.A:
; Debug: cast int = const 0 to int = D+0 (used reg = )
	TFR	D,X
	PULS	Y,PC
;BCC_EOS
; 37 }
; 38 
; 39 char buf[64], buf2[64];
;BCC_EOS
; 40 
; 41 void lengths()
; 42 {
	EXPORT	_lengths
_lengths:
; 43 	int i;
;BCC_EOS
; 44 
; 45 	ok(1,strlen("")== 0);
	LEAS	-2,S
	LOC	1
.D:
	FCB	0
	LOC	0
; Debug: rootlist * char = .D+0 (used reg = )
	LDX	#.D
; Debug: func () unsigned int = strlen+0 (used reg = )
	JSR	>_strlen
; Debug: logeq int = const 0 to unsigned int = X+0 (used reg = )
	LEAX	0,X
	BNE	.E
	LDB	#1
	BRA	.F
.E:
	CLRB
.F:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 1 (used reg = )
	LDX	#1
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 46 	ok(2,strlen("a")== 1);
	LOC	1
.10:
	FCC	"a"
	FCB	0
	LOC	0
; Debug: rootlist * char = .10+0 (used reg = )
	LDX	#.10
; Debug: func () unsigned int = strlen+0 (used reg = )
	JSR	>_strlen
; Debug: logeq int = const 1 to unsigned int = X+0 (used reg = )
	LEAX	-1,X
	BNE	.11
	LDB	#1
	BRA	.12
.11:
	CLRB
.12:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 2 (used reg = )
	LDX	#2
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 47 	ok(3,strlen("hello, world")== 12);
	LOC	1
.13:
	FCC	"hello, world"
	FCB	0
	LOC	0
; Debug: rootlist * char = .13+0 (used reg = )
	LDX	#.13
; Debug: func () unsigned int = strlen+0 (used reg = )
	JSR	>_strlen
; Debug: logeq int = const $C to unsigned int = X+0 (used reg = )
	LEAX	-$C,X
	BNE	.14
	LDB	#1
	BRA	.15
.14:
	CLRB
.15:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 3 (used reg = )
	LDX	#3
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 48 	for (i = 0; i < 40; i++)
; Debug: eq int = const 0 to int i = [S+2-2] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
;BCC_EOS
; 49 		buf[i] = 'x';
	BRA	.18
.19:
; Debug: ptradd int i = [S+2-2] to [$40] char = buf+0 (used reg = )
	LDD	0,S
	LDX	#_buf
	LEAX	D,X
; Debug: eq int = const $78 to char = [X+0] (used reg = )
	LDB	#$78
	STB	0,X
;BCC_EOS
; 50 	buf[40] = 0;
.17:
; Debug: postinc int i = [S+2-2] (used reg = )
	LDD	0,S
	ADDD	#1
	STD	0,S
.18:
; Debug: lt int = const $28 to int i = [S+2-2] (used reg = )
	LDD	0,S
	SUBD	#$28
	BLT	.19
.1A:
.16:
; Debug: eq int = const 0 to char = [buf+$28] (used reg = )
	CLRB
	STB	>_buf+$28
;BCC_EOS
; 51 	ok(4,strlen(buf)== 40);
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () unsigned int = strlen+0 (used reg = )
	JSR	>_strlen
; Debug: logeq int = const $28 to unsigned int = X+0 (used reg = )
	LEAX	-$28,X
	BNE	.1B
	LDB	#1
	BRA	.1C
.1B:
	CLRB
.1C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const 4 (used reg = )
	LDX	#4
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 52 }
	PULS	Y,PC
; 53 
; 54 void copies()
; 55 {
	EXPORT	_copies
_copies:
; 56 	ok(10,strcpy(buf,"abc")== buf);
	LOC	1
.1D:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list * char = .1D+0 (used reg = )
	LDX	#.1D
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
; Debug: logeq * char = buf+0 to * char = X+0 (used reg = )
	CMPX	#_buf
	BNE	.1E
	LDB	#1
	BRA	.1F
.1E:
	CLRB
.1F:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $A (used reg = )
	LDX	#$A
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 57 	ok(11,strcmp(buf,"abc")== 0 && buf[3] == 0);
	LOC	1
.20:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list * char = .20+0 (used reg = )
	LDX	#.20
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	LBNE	.21
.23:
; Debug: logeq int = const 0 to char = [buf+3] (used reg = )
	LDB	>_buf+3
	LBNE	.21
.22:
	LDB	#1
	BRA	.24
.21:
	CLRB
.24:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $B (used reg = )
	LDX	#$B
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 58 	ok(12,strcpy(buf,"")== buf && buf[0] == 0);
	LOC	1
.25:
	FCB	0
	LOC	0
; Debug: list * char = .25+0 (used reg = )
	LDX	#.25
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
; Debug: logeq * char = buf+0 to * char = X+0 (used reg = )
	CMPX	#_buf
	LBNE	.26
.28:
; Debug: logeq int = const 0 to char = [buf+0] (used reg = )
	LDB	>_buf
	LBNE	.26
.27:
	LDB	#1
	BRA	.29
.26:
	CLRB
.29:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $C (used reg = )
	LDX	#$C
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 59 
; 60 	strcpy(buf,"ab");
	LOC	1
.2A:
	FCC	"ab"
	FCB	0
	LOC	0
; Debug: list * char = .2A+0 (used reg = )
	LDX	#.2A
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 61 	ok(13,strcat(buf,"cd")== buf);
	LOC	1
.2B:
	FCC	"cd"
	FCB	0
	LOC	0
; Debug: list * char = .2B+0 (used reg = )
	LDX	#.2B
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcat+0 (used reg = )
	JSR	>_strcat
	LEAS	2,S
; Debug: logeq * char = buf+0 to * char = X+0 (used reg = )
	CMPX	#_buf
	BNE	.2C
	LDB	#1
	BRA	.2D
.2C:
	CLRB
.2D:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $D (used reg = )
	LDX	#$D
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 62 	ok(14,strcmp(buf,"abcd")== 0);
	LOC	1
.2E:
	FCC	"abcd"
	FCB	0
	LOC	0
; Debug: list * char = .2E+0 (used reg = )
	LDX	#.2E
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.2F
	LDB	#1
	BRA	.30
.2F:
	CLRB
.30:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $E (used reg = )
	LDX	#$E
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 63 	strcat(buf,"");
	LOC	1
.31:
	FCB	0
	LOC	0
; Debug: list * char = .31+0 (used reg = )
	LDX	#.31
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcat+0 (used reg = )
	JSR	>_strcat
	LEAS	2,S
;BCC_EOS
; 64 	ok(15,strcmp(buf,"abcd")== 0);
	LOC	1
.32:
	FCC	"abcd"
	FCB	0
	LOC	0
; Debug: list * char = .32+0 (used reg = )
	LDX	#.32
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.33
	LDB	#1
	BRA	.34
.33:
	CLRB
.34:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $F (used reg = )
	LDX	#$F
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 65 
; 66 	 
; 67 	memset(buf,'z',10);
; Debug: list int = const $A (used reg = )
	LDD	#$A
	PSHS	D
; Debug: list int = const $7A (used reg = )
	LDD	#$7A
	PSHS	D
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memset+0 (used reg = )
	JSR	>_memset
	LEAS	4,S
;BCC_EOS
; 68 	ok(16,strncpy(buf,"ab",5)== buf);
	LOC	1
.35:
	FCC	"ab"
	FCB	0
	LOC	0
; Debug: list int = const 5 (used reg = )
	LDD	#5
	PSHS	D
; Debug: list * char = .35+0 (used reg = )
	LDX	#.35
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strncpy+0 (used reg = )
	JSR	>_strncpy
	LEAS	4,S
; Debug: logeq * char = buf+0 to * char = X+0 (used reg = )
	CMPX	#_buf
	BNE	.36
	LDB	#1
	BRA	.37
.36:
	CLRB
.37:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $10 (used reg = )
	LDX	#$10
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 69 	ok(17,buf[0] == 'a' && buf[1] == 'b' && buf
; 69 [2] == 0
; 70 	   && buf[4] == 0 && buf[5] == 'z');
; Debug: logeq int = const $61 to char = [buf+0] (used reg = )
	LDB	>_buf
	SUBB	#$61
	LBNE	.38
.3D:
; Debug: logeq int = const $62 to char = [buf+1] (used reg = )
	LDB	>_buf+1
	SUBB	#$62
	LBNE	.38
.3C:
; Debug: logeq int = const 0 to char = [buf+2] (used reg = )
	LDB	>_buf+2
	LBNE	.38
.3B:
; Debug: logeq int = const 0 to char = [buf+4] (used reg = )
	LDB	>_buf+4
	LBNE	.38
.3A:
; Debug: logeq int = const $7A to char = [buf+5] (used reg = )
	LDB	>_buf+5
	SUBB	#$7A
	LBNE	.38
.39:
	LDB	#1
	BRA	.3E
.38:
	CLRB
.3E:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $11 (used reg = )
	LDX	#$11
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 71 	memset(buf,'z',10);
; Debug: list int = const $A (used reg = )
	LDD	#$A
	PSHS	D
; Debug: list int = const $7A (used reg = )
	LDD	#$7A
	PSHS	D
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memset+0 (used reg = )
	JSR	>_memset
	LEAS	4,S
;BCC_EOS
; 72 	strncpy(buf,"abcdef",3);
	LOC	1
.3F:
	FCC	"abcdef"
	FCB	0
	LOC	0
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list * char = .3F+0 (used reg = )
	LDX	#.3F
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strncpy+0 (used reg = )
	JSR	>_strncpy
	LEAS	4,S
;BCC_EOS
; 73 	ok(18,buf[2] == 'c' && buf[3] == 'z');
; Debug: logeq int = const $63 to char = [buf+2] (used reg = )
	LDB	>_buf+2
	SUBB	#$63
	LBNE	.40
.42:
; Debug: logeq int = const $7A to char = [buf+3] (used reg = )
	LDB	>_buf+3
	SUBB	#$7A
	LBNE	.40
.41:
	LDB	#1
	BRA	.43
.40:
	CLRB
.43:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $12 (used reg = )
	LDX	#$12
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 74 
; 75 
; 76 	 
; 77 	memset(buf,'z',20);
; Debug: list int = const $14 (used reg = )
	LDD	#$14
	PSHS	D
; Debug: list int = const $7A (used reg = )
	LDD	#$7A
	PSHS	D
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memset+0 (used reg = )
	JSR	>_memset
	LEAS	4,S
;BCC_EOS
; 78 	strcpy(buf,"ab");
	LOC	1
.44:
	FCC	"ab"
	FCB	0
	LOC	0
; Debug: list * char = .44+0 (used reg = )
	LDX	#.44
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 79 	ok(19,strncat(buf,"cdef",2)== buf);
	LOC	1
.45:
	FCC	"cdef"
	FCB	0
	LOC	0
; Debug: list int = const 2 (used reg = )
	LDD	#2
	PSHS	D
; Debug: list * char = .45+0 (used reg = )
	LDX	#.45
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strncat+0 (used reg = )
	JSR	>_strncat
	LEAS	4,S
; Debug: logeq * char = buf+0 to * char = X+0 (used reg = )
	CMPX	#_buf
	BNE	.46
	LDB	#1
	BRA	.47
.46:
	CLRB
.47:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $13 (used reg = )
	LDX	#$13
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 80 	ok(20,strcmp(buf,"abcd")== 0 && buf[5] == 'z');
	LOC	1
.48:
	FCC	"abcd"
	FCB	0
	LOC	0
; Debug: list * char = .48+0 (used reg = )
	LDX	#.48
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	LBNE	.49
.4B:
; Debug: logeq int = const $7A to char = [buf+5] (used reg = )
	LDB	>_buf+5
	SUBB	#$7A
	LBNE	.49
.4A:
	LDB	#1
	BRA	.4C
.49:
	CLRB
.4C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $14 (used reg = )
	LDX	#$14
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 81 	memset(buf,'z',20);
; Debug: list int = const $14 (used reg = )
	LDD	#$14
	PSHS	D
; Debug: list int = const $7A (used reg = )
	LDD	#$7A
	PSHS	D
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memset+0 (used reg = )
	JSR	>_memset
	LEAS	4,S
;BCC_EOS
; 82 	strcpy(buf,"ab");
	LOC	1
.4D:
	FCC	"ab"
	FCB	0
	LOC	0
; Debug: list * char = .4D+0 (used reg = )
	LDX	#.4D
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 83 	strncat(buf,"cd",10);
	LOC	1
.4E:
	FCC	"cd"
	FCB	0
	LOC	0
; Debug: list int = const $A (used reg = )
	LDD	#$A
	PSHS	D
; Debug: list * char = .4E+0 (used reg = )
	LDX	#.4E
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strncat+0 (used reg = )
	JSR	>_strncat
	LEAS	4,S
;BCC_EOS
; 84 	ok(21,strcmp(buf,"abcd")== 0 && buf[5] == 'z' && buf[12] == 'z');
	LOC	1
.4F:
	FCC	"abcd"
	FCB	0
	LOC	0
; Debug: list * char = .4F+0 (used reg = )
	LDX	#.4F
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	LBNE	.50
.53:
; Debug: logeq int = const $7A to char = [buf+5] (used reg = )
	LDB	>_buf+5
	SUBB	#$7A
	LBNE	.50
.52:
; Debug: logeq int = const $7A to char = [buf+$C] (used reg = )
	LDB	>_buf+$C
	SUBB	#$7A
	LBNE	.50
.51:
	LDB	#1
	BRA	.54
.50:
	CLRB
.54:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $15 (used reg = )
	LDX	#$15
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 85 }
	RTS
; 86 
; 87 void compares()
; 88 {
	EXPORT	_compares
_compares:
; 89 	ok(30,strcmp("abc","abc")== 0);
	LOC	1
.55:
	FCC	"abc"
	FCB	0
	LOC	0
	LOC	1
.56:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list * char = .56+0 (used reg = )
	LDX	#.56
	PSHS	X
; Debug: rootlist * char = .55+0 (used reg = )
	LDX	#.55
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.57
	LDB	#1
	BRA	.58
.57:
	CLRB
.58:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $1E (used reg = )
	LDX	#$1E
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 90 	ok(31,sign(strcmp("abc","abd"))== -1);
	LOC	1
.59:
	FCC	"abc"
	FCB	0
	LOC	0
	LOC	1
.5A:
	FCC	"abd"
	FCB	0
	LOC	0
; Debug: list * char = .5A+0 (used reg = )
	LDX	#.5A
	PSHS	X
; Debug: rootlist * char = .59+0 (used reg = )
	LDX	#.59
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
	LEAX	1,X
	BNE	.5B
	LDB	#1
	BRA	.5C
.5B:
	CLRB
.5C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $1F (used reg = )
	LDX	#$1F
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 91 	ok(32,sign(strcmp("abd","abc"))== 1);
	LOC	1
.5D:
	FCC	"abd"
	FCB	0
	LOC	0
	LOC	1
.5E:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list * char = .5E+0 (used reg = )
	LDX	#.5E
	PSHS	X
; Debug: rootlist * char = .5D+0 (used reg = )
	LDX	#.5D
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const 1 to int = X+0 (used reg = )
	LEAX	-1,X
	BNE	.5F
	LDB	#1
	BRA	.60
.5F:
	CLRB
.60:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $20 (used reg = )
	LDX	#$20
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 92 	ok(33,sign(strcmp("ab","abc"))== -1);
	LOC	1
.61:
	FCC	"ab"
	FCB	0
	LOC	0
	LOC	1
.62:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list * char = .62+0 (used reg = )
	LDX	#.62
	PSHS	X
; Debug: rootlist * char = .61+0 (used reg = )
	LDX	#.61
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
	LEAX	1,X
	BNE	.63
	LDB	#1
	BRA	.64
.63:
	CLRB
.64:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $21 (used reg = )
	LDX	#$21
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 93 	ok(34,sign(strcmp("abc","ab"))== 1);
	LOC	1
.65:
	FCC	"abc"
	FCB	0
	LOC	0
	LOC	1
.66:
	FCC	"ab"
	FCB	0
	LOC	0
; Debug: list * char = .66+0 (used reg = )
	LDX	#.66
	PSHS	X
; Debug: rootlist * char = .65+0 (used reg = )
	LDX	#.65
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const 1 to int = X+0 (used reg = )
	LEAX	-1,X
	BNE	.67
	LDB	#1
	BRA	.68
.67:
	CLRB
.68:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $22 (used reg = )
	LDX	#$22
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 94 	ok(35,sign(strcmp("","a"))== -1);
	LOC	1
.69:
	FCB	0
	LOC	0
	LOC	1
.6A:
	FCC	"a"
	FCB	0
	LOC	0
; Debug: list * char = .6A+0 (used reg = )
	LDX	#.6A
	PSHS	X
; Debug: rootlist * char = .69+0 (used reg = )
	LDX	#.69
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
	LEAX	1,X
	BNE	.6B
	LDB	#1
	BRA	.6C
.6B:
	CLRB
.6C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $23 (used reg = )
	LDX	#$23
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 95 	ok(36,sign(strcmp("\200","a"))== 1);	 
	LOC	1
.6D:
	FCB	$80
	FCB	0
	LOC	0
	LOC	1
.6E:
	FCC	"a"
	FCB	0
	LOC	0
; Debug: list * char = .6E+0 (used reg = )
	LDX	#.6E
	PSHS	X
; Debug: rootlist * char = .6D+0 (used reg = )
	LDX	#.6D
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const 1 to int = X+0 (used reg = )
	LEAX	-1,X
	BNE	.6F
	LDB	#1
	BRA	.70
.6F:
	CLRB
.70:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $24 (used reg = )
	LDX	#$24
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 96 
; 97 	ok(37,strncmp("abcd","abce",3)== 0);
	LOC	1
.71:
	FCC	"abcd"
	FCB	0
	LOC	0
	LOC	1
.72:
	FCC	"abce"
	FCB	0
	LOC	0
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list * char = .72+0 (used reg = )
	LDX	#.72
	PSHS	X
; Debug: rootlist * char = .71+0 (used reg = )
	LDX	#.71
; Debug: func () int = strncmp+0 (used reg = )
	JSR	>_strncmp
	LEAS	4,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.73
	LDB	#1
	BRA	.74
.73:
	CLRB
.74:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $25 (used reg = )
	LDX	#$25
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 98 	ok(38,sign(strncmp("abcd","abce",4))== -1);
	LOC	1
.75:
	FCC	"abcd"
	FCB	0
	LOC	0
	LOC	1
.76:
	FCC	"abce"
	FCB	0
	LOC	0
; Debug: list int = const 4 (used reg = )
	LDD	#4
	PSHS	D
; Debug: list * char = .76+0 (used reg = )
	LDX	#.76
	PSHS	X
; Debug: rootlist * char = .75+0 (used reg = )
	LDX	#.75
; Debug: func () int = strncmp+0 (used reg = )
	JSR	>_strncmp
	LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
	LEAX	1,X
	BNE	.77
	LDB	#1
	BRA	.78
.77:
	CLRB
.78:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $26 (used reg = )
	LDX	#$26
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 99 	ok(39,strncmp("abc","xyz",0)== 0);
	LOC	1
.79:
	FCC	"abc"
	FCB	0
	LOC	0
	LOC	1
.7A:
	FCC	"xyz"
	FCB	0
	LOC	0
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: list * char = .7A+0 (used reg = )
	LDX	#.7A
	PSHS	X
; Debug: rootlist * char = .79+0 (used reg = )
	LDX	#.79
; Debug: func () int = strncmp+0 (used reg = )
	JSR	>_strncmp
	LEAS	4,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.7B
	LDB	#1
	BRA	.7C
.7B:
	CLRB
.7C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $27 (used reg = )
	LDX	#$27
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 100 	ok(40,strncmp("ab","ab",10)== 0);
	LOC	1
.7D:
	FCC	"ab"
	FCB	0
	LOC	0
	LOC	1
.7E:
	FCC	"ab"
	FCB	0
	LOC	0
; Debug: list int = const $A (used reg = )
	LDD	#$A
	PSHS	D
; Debug: list * char = .7E+0 (used reg = )
	LDX	#.7E
	PSHS	X
; Debug: rootlist * char = .7D+0 (used reg = )
	LDX	#.7D
; Debug: func () int = strncmp+0 (used reg = )
	JSR	>_strncmp
	LEAS	4,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.7F
	LDB	#1
	BRA	.80
.7F:
	CLRB
.80:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $28 (used reg = )
	LDX	#$28
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 101 	ok(41,sign(strncmp("ab","abc",10))== -1);
	LOC	1
.81:
	FCC	"ab"
	FCB	0
	LOC	0
	LOC	1
.82:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list int = const $A (used reg = )
	LDD	#$A
	PSHS	D
; Debug: list * char = .82+0 (used reg = )
	LDX	#.82
	PSHS	X
; Debug: rootlist * char = .81+0 (used reg = )
	LDX	#.81
; Debug: func () int = strncmp+0 (used reg = )
	JSR	>_strncmp
	LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
	LEAX	1,X
	BNE	.83
	LDB	#1
	BRA	.84
.83:
	CLRB
.84:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $29 (used reg = )
	LDX	#$29
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 102 
; 103 	ok(42,memcmp("abc","abc",3)== 0);
	LOC	1
.85:
	FCC	"abc"
	FCB	0
	LOC	0
	LOC	1
.86:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list * char = .86+0 (used reg = )
	LDX	#.86
	PSHS	X
; Debug: rootlist * char = .85+0 (used reg = )
	LDX	#.85
; Debug: func () int = memcmp+0 (used reg = )
	JSR	>_memcmp
	LEAS	4,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.87
	LDB	#1
	BRA	.88
.87:
	CLRB
.88:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $2A (used reg = )
	LDX	#$2A
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 104 	ok(43,sign(memcmp("abc","abd",3))== -1);	 
	LOC	1
.89:
	FCC	"abc"
	FCB	0
	LOC	0
	LOC	1
.8A:
	FCC	"abd"
	FCB	0
	LOC	0
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list * char = .8A+0 (used reg = )
	LDX	#.8A
	PSHS	X
; Debug: rootlist * char = .89+0 (used reg = )
	LDX	#.89
; Debug: func () int = memcmp+0 (used reg = )
	JSR	>_memcmp
	LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
	LEAX	1,X
	BNE	.8B
	LDB	#1
	BRA	.8C
.8B:
	CLRB
.8C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $2B (used reg = )
	LDX	#$2B
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 105 	ok(44,sign(memcmp("abd","abc",3))== 1);	 
	LOC	1
.8D:
	FCC	"abd"
	FCB	0
	LOC	0
	LOC	1
.8E:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list * char = .8E+0 (used reg = )
	LDX	#.8E
	PSHS	X
; Debug: rootlist * char = .8D+0 (used reg = )
	LDX	#.8D
; Debug: func () int = memcmp+0 (used reg = )
	JSR	>_memcmp
	LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const 1 to int = X+0 (used reg = )
	LEAX	-1,X
	BNE	.8F
	LDB	#1
	BRA	.90
.8F:
	CLRB
.90:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $2C (used reg = )
	LDX	#$2C
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 106 	ok(45,memcmp("abc","xyz",0)== 0);
	LOC	1
.91:
	FCC	"abc"
	FCB	0
	LOC	0
	LOC	1
.92:
	FCC	"xyz"
	FCB	0
	LOC	0
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: list * char = .92+0 (used reg = )
	LDX	#.92
	PSHS	X
; Debug: rootlist * char = .91+0 (used reg = )
	LDX	#.91
; Debug: func () int = memcmp+0 (used reg = )
	JSR	>_memcmp
	LEAS	4,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.93
	LDB	#1
	BRA	.94
.93:
	CLRB
.94:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $2D (used reg = )
	LDX	#$2D
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 107 	ok(46,sign(memcmp("\200","a",1))== 1);
	LOC	1
.95:
	FCB	$80
	FCB	0
	LOC	0
	LOC	1
.96:
	FCC	"a"
	FCB	0
	LOC	0
; Debug: list int = const 1 (used reg = )
	LDD	#1
	PSHS	D
; Debug: list * char = .96+0 (used reg = )
	LDX	#.96
	PSHS	X
; Debug: rootlist * char = .95+0 (used reg = )
	LDX	#.95
; Debug: func () int = memcmp+0 (used reg = )
	JSR	>_memcmp
	LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const 1 to int = X+0 (used reg = )
	LEAX	-1,X
	BNE	.97
	LDB	#1
	BRA	.98
.97:
	CLRB
.98:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $2E (used reg = )
	LDX	#$2E
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 108 	ok(47,memcmp("a\000b","a\000b",3)== 0);		 
	LOC	1
.99:
	FCC	"a"
	FCB	0
	FCC	"b"
	FCB	0
	LOC	0
	LOC	1
.9A:
	FCC	"a"
	FCB	0
	FCC	"b"
	FCB	0
	LOC	0
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list * char = .9A+0 (used reg = )
	LDX	#.9A
	PSHS	X
; Debug: rootlist * char = .99+0 (used reg = )
	LDX	#.99
; Debug: func () int = memcmp+0 (used reg = )
	JSR	>_memcmp
	LEAS	4,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.9B
	LDB	#1
	BRA	.9C
.9B:
	CLRB
.9C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $2F (used reg = )
	LDX	#$2F
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 109 	ok(48,sign(memcmp("a\000b","a\000c",3))== -1);
	LOC	1
.9D:
	FCC	"a"
	FCB	0
	FCC	"b"
	FCB	0
	LOC	0
	LOC	1
.9E:
	FCC	"a"
	FCB	0
	FCC	"c"
	FCB	0
	LOC	0
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list * char = .9E+0 (used reg = )
	LDX	#.9E
	PSHS	X
; Debug: rootlist * char = .9D+0 (used reg = )
	LDX	#.9D
; Debug: func () int = memcmp+0 (used reg = )
	JSR	>_memcmp
	LEAS	4,S
; Debug: rootlist int = X+0 (used reg = )
; Debug: func () int = sign+0 (used reg = )
	JSR	>_sign
; Debug: logeq int = const -1 to int = X+0 (used reg = )
	LEAX	1,X
	BNE	.9F
	LDB	#1
	BRA	.A0
.9F:
	CLRB
.A0:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $30 (used reg = )
	LDX	#$30
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 110 }
	RTS
; 111 
; 112 void searches()
; 113 {
	EXPORT	_searches
_searches:
; 114 	char *s = "hello, world";
	LEAS	-2,S
	LOC	1
.A1:
	FCC	"hello, world"
	FCB	0
	LOC	0
; Debug: eq [$D] char = .A1+0 to * char s = [S+2-2] (used reg = )
	LDX	#.A1
	STX	0,S
;BCC_EOS
; 115 
; 116 	ok(50,strchr(s,'o')== s + 4);
; Debug: expression subtree swapping
; Debug: list int = const $6F (used reg = )
	LDD	#$6F
	PSHS	D
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strchr+0 (used reg = )
	JSR	>_strchr
	LEAS	2,S
; Debug: ptradd int = const 4 to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * char = X+0 to * char = U+4 (used reg = )
	PSHS	X
	LEAU	4,U
	CMPU	,S++
	BNE	.A2
	LDB	#1
	BRA	.A3
.A2:
	CLRB
.A3:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $32 (used reg = )
	LDX	#$32
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 117 	ok(51,strchr(s,'z')== 0);
; Debug: list int = const $7A (used reg = )
	LDD	#$7A
	PSHS	D
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strchr+0 (used reg = )
	JSR	>_strchr
	LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.A4
	LDB	#1
	BRA	.A5
.A4:
	CLRB
.A5:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $33 (used reg = )
	LDX	#$33
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 118 	ok(52,strchr(s,0)== s + 12);
; Debug: expression subtree swapping
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strchr+0 (used reg = )
	JSR	>_strchr
	LEAS	2,S
; Debug: ptradd int = const $C to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * char = X+0 to * char = U+$C (used reg = )
	PSHS	X
	LEAU	$C,U
	CMPU	,S++
	BNE	.A6
	LDB	#1
	BRA	.A7
.A6:
	CLRB
.A7:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $34 (used reg = )
	LDX	#$34
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 119 	ok(53,strchr(s,'h' + 256)== s);	 
; Debug: list int = const $168 (used reg = )
	LDD	#$168
	PSHS	D
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strchr+0 (used reg = )
	JSR	>_strchr
	LEAS	2,S
; Debug: logeq * char s = [S+2-2] to * char = X+0 (used reg = )
	CMPX	0,S
	BNE	.A8
	LDB	#1
	BRA	.A9
.A8:
	CLRB
.A9:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $35 (used reg = )
	LDX	#$35
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 120 	ok(54,strrchr(s,'o')== s + 8);
; Debug: expression subtree swapping
; Debug: list int = const $6F (used reg = )
	LDD	#$6F
	PSHS	D
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strrchr+0 (used reg = )
	JSR	>_strrchr
	LEAS	2,S
; Debug: ptradd int = const 8 to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * char = X+0 to * char = U+8 (used reg = )
	PSHS	X
	LEAU	8,U
	CMPU	,S++
	BNE	.AA
	LDB	#1
	BRA	.AB
.AA:
	CLRB
.AB:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $36 (used reg = )
	LDX	#$36
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 121 	ok(55,strrchr(s,'z')== 0);
; Debug: list int = const $7A (used reg = )
	LDD	#$7A
	PSHS	D
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strrchr+0 (used reg = )
	JSR	>_strrchr
	LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.AC
	LDB	#1
	BRA	.AD
.AC:
	CLRB
.AD:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $37 (used reg = )
	LDX	#$37
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 122 	ok(56,strrchr(s,0)== s + 12);
; Debug: expression subtree swapping
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strrchr+0 (used reg = )
	JSR	>_strrchr
	LEAS	2,S
; Debug: ptradd int = const $C to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * char = X+0 to * char = U+$C (used reg = )
	PSHS	X
	LEAU	$C,U
	CMPU	,S++
	BNE	.AE
	LDB	#1
	BRA	.AF
.AE:
	CLRB
.AF:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $38 (used reg = )
	LDX	#$38
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 123 	ok(57,strrchr(s,'l')== s + 10);
; Debug: expression subtree swapping
; Debug: list int = const $6C (used reg = )
	LDD	#$6C
	PSHS	D
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strrchr+0 (used reg = )
	JSR	>_strrchr
	LEAS	2,S
; Debug: ptradd int = const $A to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * char = X+0 to * char = U+$A (used reg = )
	PSHS	X
	LEAU	$A,U
	CMPU	,S++
	BNE	.B0
	LDB	#1
	BRA	.B1
.B0:
	CLRB
.B1:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $39 (used reg = )
	LDX	#$39
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 124 
; 125 	ok(58,memchr(s,'w',12)== s + 7);
; Debug: expression subtree swapping
; Debug: list int = const $C (used reg = )
	LDD	#$C
	PSHS	D
; Debug: list int = const $77 (used reg = )
	LDD	#$77
	PSHS	D
; Debug: rootlist * char s = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () * void = memchr+0 (used reg = )
	JSR	>_memchr
	LEAS	4,S
; Debug: ptradd int = const 7 to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * void = X+0 to * char = U+7 (used reg = )
	PSHS	X
	LEAU	7,U
	CMPU	,S++
	BNE	.B2
	LDB	#1
	BRA	.B3
.B2:
	CLRB
.B3:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $3A (used reg = )
	LDX	#$3A
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 126 	ok(59,memchr(s,'w',7)== 0);
; Debug: list int = const 7 (used reg = )
	LDD	#7
	PSHS	D
; Debug: list int = const $77 (used reg = )
	LDD	#$77
	PSHS	D
; Debug: rootlist * char s = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () * void = memchr+0 (used reg = )
	JSR	>_memchr
	LEAS	4,S
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
	LEAX	0,X
	BNE	.B4
	LDB	#1
	BRA	.B5
.B4:
	CLRB
.B5:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $3B (used reg = )
	LDX	#$3B
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 127 	ok(60,memchr(s,0,13)== s + 12);
; Debug: expression subtree swapping
; Debug: list int = const $D (used reg = )
	LDD	#$D
	PSHS	D
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: rootlist * char s = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () * void = memchr+0 (used reg = )
	JSR	>_memchr
	LEAS	4,S
; Debug: ptradd int = const $C to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * void = X+0 to * char = U+$C (used reg = )
	PSHS	X
	LEAU	$C,U
	CMPU	,S++
	BNE	.B6
	LDB	#1
	BRA	.B7
.B6:
	CLRB
.B7:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $3C (used reg = )
	LDX	#$3C
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 128 	ok(61,memchr(s,'h' + 256,1)== s);
; Debug: list int = const 1 (used reg = )
	LDD	#1
	PSHS	D
; Debug: list int = const $168 (used reg = )
	LDD	#$168
	PSHS	D
; Debug: rootlist * char s = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () * void = memchr+0 (used reg = )
	JSR	>_memchr
	LEAS	4,S
; Debug: logeq * char s = [S+2-2] to * void = X+0 (used reg = )
	CMPX	0,S
	BNE	.B8
	LDB	#1
	BRA	.B9
.B8:
	CLRB
.B9:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $3D (used reg = )
	LDX	#$3D
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 129 	ok(62,memchr(s,'h',0)== 0);
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: list int = const $68 (used reg = )
	LDD	#$68
	PSHS	D
; Debug: rootlist * char s = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () * void = memchr+0 (used reg = )
	JSR	>_memchr
	LEAS	4,S
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
	LEAX	0,X
	BNE	.BA
	LDB	#1
	BRA	.BB
.BA:
	CLRB
.BB:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $3E (used reg = )
	LDX	#$3E
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 130 
; 131 	ok(63,strstr(s,"world")== s + 7);
	LOC	1
.BC:
	FCC	"world"
	FCB	0
	LOC	0
; Debug: expression subtree swapping
; Debug: list * char = .BC+0 (used reg = )
	LDX	#.BC
	PSHS	X
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strstr+0 (used reg = )
	JSR	>_strstr
	LEAS	2,S
; Debug: ptradd int = const 7 to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * char = X+0 to * char = U+7 (used reg = )
	PSHS	X
	LEAU	7,U
	CMPU	,S++
	BNE	.BD
	LDB	#1
	BRA	.BE
.BD:
	CLRB
.BE:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $3F (used reg = )
	LDX	#$3F
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 132 	ok(64,strstr(s,"")== s);
	LOC	1
.BF:
	FCB	0
	LOC	0
; Debug: list * char = .BF+0 (used reg = )
	LDX	#.BF
	PSHS	X
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strstr+0 (used reg = )
	JSR	>_strstr
	LEAS	2,S
; Debug: logeq * char s = [S+2-2] to * char = X+0 (used reg = )
	CMPX	0,S
	BNE	.C0
	LDB	#1
	BRA	.C1
.C0:
	CLRB
.C1:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $40 (used reg = )
	LDX	#$40
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 133 	ok(65,strstr(s,"worlds")== 0);
	LOC	1
.C2:
	FCC	"worlds"
	FCB	0
	LOC	0
; Debug: list * char = .C2+0 (used reg = )
	LDX	#.C2
	PSHS	X
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strstr+0 (used reg = )
	JSR	>_strstr
	LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.C3
	LDB	#1
	BRA	.C4
.C3:
	CLRB
.C4:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $41 (used reg = )
	LDX	#$41
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 134 	ok(66,strstr(s,"lo, w")== s + 3);
	LOC	1
.C5:
	FCC	"lo, w"
	FCB	0
	LOC	0
; Debug: expression subtree swapping
; Debug: list * char = .C5+0 (used reg = )
	LDX	#.C5
	PSHS	X
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strstr+0 (used reg = )
	JSR	>_strstr
	LEAS	2,S
; Debug: ptradd int = const 3 to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * char = X+0 to * char = U+3 (used reg = )
	PSHS	X
	LEAU	3,U
	CMPU	,S++
	BNE	.C6
	LDB	#1
	BRA	.C7
.C6:
	CLRB
.C7:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $42 (used reg = )
	LDX	#$42
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 135 	strcpy(buf,"aaab");			 
	LOC	1
.C8:
	FCC	"aaab"
	FCB	0
	LOC	0
; Debug: list * char = .C8+0 (used reg = )
	LDX	#.C8
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 136 	ok(67,strstr(buf,"aab")== buf + 1);
	LOC	1
.C9:
	FCC	"aab"
	FCB	0
	LOC	0
; Debug: list * char = .C9+0 (used reg = )
	LDX	#.C9
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strstr+0 (used reg = )
	JSR	>_strstr
	LEAS	2,S
; Debug: logeq * char = buf+1 to * char = X+0 (used reg = )
	CMPX	#_buf+1
	BNE	.CA
	LDB	#1
	BRA	.CB
.CA:
	CLRB
.CB:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $43 (used reg = )
	LDX	#$43
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 137 	ok(68,strstr(buf,"aaaa")== 0);
	LOC	1
.CC:
	FCC	"aaaa"
	FCB	0
	LOC	0
; Debug: list * char = .CC+0 (used reg = )
	LDX	#.CC
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strstr+0 (used reg = )
	JSR	>_strstr
	LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.CD
	LDB	#1
	BRA	.CE
.CD:
	CLRB
.CE:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $44 (used reg = )
	LDX	#$44
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 138 
; 139 	ok(69,strspn("abcde","abc")== 3);
	LOC	1
.CF:
	FCC	"abcde"
	FCB	0
	LOC	0
	LOC	1
.D0:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list * char = .D0+0 (used reg = )
	LDX	#.D0
	PSHS	X
; Debug: rootlist * char = .CF+0 (used reg = )
	LDX	#.CF
; Debug: func () unsigned int = strspn+0 (used reg = )
	JSR	>_strspn
	LEAS	2,S
; Debug: logeq int = const 3 to unsigned int = X+0 (used reg = )
	LEAX	-3,X
	BNE	.D1
	LDB	#1
	BRA	.D2
.D1:
	CLRB
.D2:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $45 (used reg = )
	LDX	#$45
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 140 	ok(70,strspn("abcde","xyz")== 0);
	LOC	1
.D3:
	FCC	"abcde"
	FCB	0
	LOC	0
	LOC	1
.D4:
	FCC	"xyz"
	FCB	0
	LOC	0
; Debug: list * char = .D4+0 (used reg = )
	LDX	#.D4
	PSHS	X
; Debug: rootlist * char = .D3+0 (used reg = )
	LDX	#.D3
; Debug: func () unsigned int = strspn+0 (used reg = )
	JSR	>_strspn
	LEAS	2,S
; Debug: logeq int = const 0 to unsigned int = X+0 (used reg = )
	LEAX	0,X
	BNE	.D5
	LDB	#1
	BRA	.D6
.D5:
	CLRB
.D6:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $46 (used reg = )
	LDX	#$46
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 141 	ok(71,strspn("","abc")== 0);
	LOC	1
.D7:
	FCB	0
	LOC	0
	LOC	1
.D8:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list * char = .D8+0 (used reg = )
	LDX	#.D8
	PSHS	X
; Debug: rootlist * char = .D7+0 (used reg = )
	LDX	#.D7
; Debug: func () unsigned int = strspn+0 (used reg = )
	JSR	>_strspn
	LEAS	2,S
; Debug: logeq int = const 0 to unsigned int = X+0 (used reg = )
	LEAX	0,X
	BNE	.D9
	LDB	#1
	BRA	.DA
.D9:
	CLRB
.DA:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $47 (used reg = )
	LDX	#$47
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 142 	ok(72,strcspn("abcde","dx")== 3);
	LOC	1
.DB:
	FCC	"abcde"
	FCB	0
	LOC	0
	LOC	1
.DC:
	FCC	"dx"
	FCB	0
	LOC	0
; Debug: list * char = .DC+0 (used reg = )
	LDX	#.DC
	PSHS	X
; Debug: rootlist * char = .DB+0 (used reg = )
	LDX	#.DB
; Debug: func () unsigned int = strcspn+0 (used reg = )
	JSR	>_strcspn
	LEAS	2,S
; Debug: logeq int = const 3 to unsigned int = X+0 (used reg = )
	LEAX	-3,X
	BNE	.DD
	LDB	#1
	BRA	.DE
.DD:
	CLRB
.DE:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $48 (used reg = )
	LDX	#$48
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 143 	ok(73,strcspn("abcde","xyz")== 5);
	LOC	1
.DF:
	FCC	"abcde"
	FCB	0
	LOC	0
	LOC	1
.E0:
	FCC	"xyz"
	FCB	0
	LOC	0
; Debug: list * char = .E0+0 (used reg = )
	LDX	#.E0
	PSHS	X
; Debug: rootlist * char = .DF+0 (used reg = )
	LDX	#.DF
; Debug: func () unsigned int = strcspn+0 (used reg = )
	JSR	>_strcspn
	LEAS	2,S
; Debug: logeq int = const 5 to unsigned int = X+0 (used reg = )
	LEAX	-5,X
	BNE	.E1
	LDB	#1
	BRA	.E2
.E1:
	CLRB
.E2:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $49 (used reg = )
	LDX	#$49
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 144 	ok(74,strcspn("abcde","")==
	LOC	1
.E3:
	FCC	"abcde"
	FCB	0
	LOC	0
	LOC	1
.E4:
	FCB	0
	LOC	0
; 144  5);
; Debug: list * char = .E4+0 (used reg = )
	LDX	#.E4
	PSHS	X
; Debug: rootlist * char = .E3+0 (used reg = )
	LDX	#.E3
; Debug: func () unsigned int = strcspn+0 (used reg = )
	JSR	>_strcspn
	LEAS	2,S
; Debug: logeq int = const 5 to unsigned int = X+0 (used reg = )
	LEAX	-5,X
	BNE	.E5
	LDB	#1
	BRA	.E6
.E5:
	CLRB
.E6:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $4A (used reg = )
	LDX	#$4A
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 145 	ok(75,strpbrk(s,"w,")== s + 5);
	LOC	1
.E7:
	FCC	"w,"
	FCB	0
	LOC	0
; Debug: expression subtree swapping
; Debug: list * char = .E7+0 (used reg = )
	LDX	#.E7
	PSHS	X
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strpbrk+0 (used reg = )
	JSR	>_strpbrk
	LEAS	2,S
; Debug: ptradd int = const 5 to * char s = [S+2-2] (used reg = X)
	LDU	0,S
; Debug: logeq * char = X+0 to * char = U+5 (used reg = )
	PSHS	X
	LEAU	5,U
	CMPU	,S++
	BNE	.E8
	LDB	#1
	BRA	.E9
.E8:
	CLRB
.E9:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $4B (used reg = )
	LDX	#$4B
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 146 	ok(76,strpbrk(s,"xyz")== 0);
	LOC	1
.EA:
	FCC	"xyz"
	FCB	0
	LOC	0
; Debug: list * char = .EA+0 (used reg = )
	LDX	#.EA
	PSHS	X
; Debug: rootlist * char s = [S+4-2] (used reg = )
	LDX	2,S
; Debug: func () * char = strpbrk+0 (used reg = )
	JSR	>_strpbrk
	LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.EB
	LDB	#1
	BRA	.EC
.EB:
	CLRB
.EC:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $4C (used reg = )
	LDX	#$4C
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 147 }
	PULS	Y,PC
; 148 
; 149 void tokens()
; 150 {
	EXPORT	_tokens
_tokens:
; 151 	char *p, *q;
;BCC_EOS
; 152 
; 153 	strcpy(buf,"-abc=-def");
	LEAS	-4,S
	LOC	1
.ED:
	FCC	"-abc=-def"
	FCB	0
	LOC	0
; Debug: list * char = .ED+0 (used reg = )
	LDX	#.ED
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 154 	p = strtok(buf,"-");
	LOC	1
.EE:
	FCC	"-"
	FCB	0
	LOC	0
; Debug: list * char = .EE+0 (used reg = )
	LDX	#.EE
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strtok+0 (used reg = )
	JSR	>_strtok
	LEAS	2,S
; Debug: eq * char = X+0 to * char p = [S+4-2] (used reg = )
	STX	2,S
;BCC_EOS
; 155 	ok(80,p == buf + 1 && strcmp(p,"abc=")== 0);
	LOC	1
.EF:
	FCC	"abc="
	FCB	0
	LOC	0
; Debug: logeq * char = buf+1 to * char p = [S+4-2] (used reg = )
	LDX	#_buf+1
	CMPX	2,S
	LBNE	.F0
.F2:
; Debug: list * char = .EF+0 (used reg = )
	LDX	#.EF
	PSHS	X
; Debug: rootlist * char p = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	LBNE	.F0
.F1:
	LDB	#1
	BRA	.F3
.F0:
	CLRB
.F3:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $50 (used reg = )
	LDX	#$50
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 156 	p = strtok((char *)0,"=-");
	LOC	1
.F4:
	FCC	"=-"
	FCB	0
	LOC	0
; Debug: list * char = .F4+0 (used reg = )
	LDX	#.F4
	PSHS	X
; Debug: rootlist * char = const 0 (used reg = )
	LDX	#0
; Debug: func () * char = strtok+0 (used reg = )
	JSR	>_strtok
	LEAS	2,S
; Debug: eq * char = X+0 to * char p = [S+4-2] (used reg = )
	STX	2,S
;BCC_EOS
; 157 	ok(81,p == buf + 6 && strcmp(p,"def")== 0);
	LOC	1
.F5:
	FCC	"def"
	FCB	0
	LOC	0
; Debug: logeq * char = buf+6 to * char p = [S+4-2] (used reg = )
	LDX	#_buf+6
	CMPX	2,S
	LBNE	.F6
.F8:
; Debug: list * char = .F5+0 (used reg = )
	LDX	#.F5
	PSHS	X
; Debug: rootlist * char p = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	LBNE	.F6
.F7:
	LDB	#1
	BRA	.F9
.F6:
	CLRB
.F9:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $51 (used reg = )
	LDX	#$51
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 158 	ok(82,strtok((char *)0,"=")== 0);
	LOC	1
.FA:
	FCC	"="
	FCB	0
	LOC	0
; Debug: list * char = .FA+0 (used reg = )
	LDX	#.FA
	PSHS	X
; Debug: rootlist * char = const 0 (used reg = )
	LDX	#0
; Debug: func () * char = strtok+0 (used reg = )
	JSR	>_strtok
	LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.FB
	LDB	#1
	BRA	.FC
.FB:
	CLRB
.FC:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $52 (used reg = )
	LDX	#$52
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 159 	strcpy(buf,"---");
	LOC	1
.FD:
	FCC	"---"
	FCB	0
	LOC	0
; Debug: list * char = .FD+0 (used reg = )
	LDX	#.FD
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 160 	ok(83,strtok(buf,"-")== 0);
	LOC	1
.FE:
	FCC	"-"
	FCB	0
	LOC	0
; Debug: list * char = .FE+0 (used reg = )
	LDX	#.FE
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strtok+0 (used reg = )
	JSR	>_strtok
	LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.FF
	LDB	#1
	BRA	.100
.FF:
	CLRB
.100:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $53 (used reg = )
	LDX	#$53
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 161 
; 162 	strcpy(buf,"a,b,,c");
	LOC	1
.101:
	FCC	"a,b,,c"
	FCB	0
	LOC	0
; Debug: list * char = .101+0 (used reg = )
	LDX	#.101
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 163 	q = buf;
; Debug: eq [$40] char = buf+0 to * char q = [S+4-4] (used reg = )
	LDX	#_buf
	STX	0,S
;BCC_EOS
; 164 	p = strsep(&q,",");
	LOC	1
.102:
	FCC	","
	FCB	0
	LOC	0
; Debug: list * char = .102+0 (used reg = )
	LDX	#.102
	PSHS	X
; Debug: rootlist * * char q = S+6-4 (used reg = )
	LEAX	2,S
; Debug: func () * char = strsep+0 (used reg = )
	JSR	>_strsep
	LEAS	2,S
; Debug: eq * char = X+0 to * char p = [S+4-2] (used reg = )
	STX	2,S
;BCC_EOS
; 165 	ok(84,p == buf && strcmp(p,"a")== 0);
	LOC	1
.103:
	FCC	"a"
	FCB	0
	LOC	0
; Debug: logeq * char = buf+0 to * char p = [S+4-2] (used reg = )
	LDX	#_buf
	CMPX	2,S
	LBNE	.104
.106:
; Debug: list * char = .103+0 (used reg = )
	LDX	#.103
	PSHS	X
; Debug: rootlist * char p = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	LBNE	.104
.105:
	LDB	#1
	BRA	.107
.104:
	CLRB
.107:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $54 (used reg = )
	LDX	#$54
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 166 	p = strsep(&q,",");
	LOC	1
.108:
	FCC	","
	FCB	0
	LOC	0
; Debug: list * char = .108+0 (used reg = )
	LDX	#.108
	PSHS	X
; Debug: rootlist * * char q = S+6-4 (used reg = )
	LEAX	2,S
; Debug: func () * char = strsep+0 (used reg = )
	JSR	>_strsep
	LEAS	2,S
; Debug: eq * char = X+0 to * char p = [S+4-2] (used reg = )
	STX	2,S
;BCC_EOS
; 167 	ok(85,strcmp(p,"b")== 0);
	LOC	1
.109:
	FCC	"b"
	FCB	0
	LOC	0
; Debug: list * char = .109+0 (used reg = )
	LDX	#.109
	PSHS	X
; Debug: rootlist * char p = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.10A
	LDB	#1
	BRA	.10B
.10A:
	CLRB
.10B:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $55 (used reg = )
	LDX	#$55
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 168 	p = strsep(&q,",");
	LOC	1
.10C:
	FCC	","
	FCB	0
	LOC	0
; Debug: list * char = .10C+0 (used reg = )
	LDX	#.10C
	PSHS	X
; Debug: rootlist * * char q = S+6-4 (used reg = )
	LEAX	2,S
; Debug: func () * char = strsep+0 (used reg = )
	JSR	>_strsep
	LEAS	2,S
; Debug: eq * char = X+0 to * char p = [S+4-2] (used reg = )
	STX	2,S
;BCC_EOS
; 169 	ok(86,strcmp(p,"")== 0);
	LOC	1
.10D:
	FCB	0
	LOC	0
; Debug: list * char = .10D+0 (used reg = )
	LDX	#.10D
	PSHS	X
; Debug: rootlist * char p = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.10E
	LDB	#1
	BRA	.10F
.10E:
	CLRB
.10F:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $56 (used reg = )
	LDX	#$56
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 170 	p = strsep(&q,",");
	LOC	1
.110:
	FCC	","
	FCB	0
	LOC	0
; Debug: list * char = .110+0 (used reg = )
	LDX	#.110
	PSHS	X
; Debug: rootlist * * char q = S+6-4 (used reg = )
	LEAX	2,S
; Debug: func () * char = strsep+0 (used reg = )
	JSR	>_strsep
	LEAS	2,S
; Debug: eq * char = X+0 to * char p = [S+4-2] (used reg = )
	STX	2,S
;BCC_EOS
; 171 	ok(87,strcmp(p,"c")== 0 && q == 0);
	LOC	1
.111:
	FCC	"c"
	FCB	0
	LOC	0
; Debug: list * char = .111+0 (used reg = )
	LDX	#.111
	PSHS	X
; Debug: rootlist * char p = [S+6-2] (used reg = )
	LDX	4,S
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	LBNE	.112
.114:
; Debug: logeq int = const 0 to * char q = [S+4-4] (used reg = )
	LDD	0,S
	LBNE	.112
.113:
	LDB	#1
	BRA	.115
.112:
	CLRB
.115:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $57 (used reg = )
	LDX	#$57
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 172 	ok(88,strsep(&q,",")== 0);
	LOC	1
.116:
	FCC	","
	FCB	0
	LOC	0
; Debug: list * char = .116+0 (used reg = )
	LDX	#.116
	PSHS	X
; Debug: rootlist * * char q = S+6-4 (used reg = )
	LEAX	2,S
; Debug: func () * char = strsep+0 (used reg = )
	JSR	>_strsep
	LEAS	2,S
; Debug: logeq int = const 0 to * char = X+0 (used reg = )
	LEAX	0,X
	BNE	.117
	LDB	#1
	BRA	.118
.117:
	CLRB
.118:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $58 (used reg = )
	LDX	#$58
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 173 }
	PULS	U,Y,PC
; 174 
; 175 void memories()
; 176 {
	EXPORT	_memories
_memories:
; 177 	int i, good;
;BCC_EOS
; 178 
; 179 	ok(90,memset(buf,'q',10)== buf);
	LEAS	-4,S
; Debug: list int = const $A (used reg = )
	LDD	#$A
	PSHS	D
; Debug: list int = const $71 (used reg = )
	LDD	#$71
	PSHS	D
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memset+0 (used reg = )
	JSR	>_memset
	LEAS	4,S
; Debug: logeq * char = buf+0 to * void = X+0 (used reg = )
	CMPX	#_buf
	BNE	.119
	LDB	#1
	BRA	.11A
.119:
	CLRB
.11A:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $5A (used reg = )
	LDX	#$5A
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 180 	good = 1;
; Debug: eq int = const 1 to int good = [S+4-4] (used reg = )
	LDD	#1
	STD	0,S
;BCC_EOS
; 181 	for (i = 0; i < 10; i++)
; Debug: eq int = const 0 to int i = [S+4-2] (used reg = )
	LDD	#0
	STD	2,S
;BCC_EOS
;BCC_EOS
; 182 		if (buf[i] != 'q')
	BRA	.11D
.11E:
; Debug: ptradd int i = [S+4-2] to [$40] char = buf+0 (used reg = )
	LDD	2,S
	LDX	#_buf
	LEAX	D,X
; Debug: ne int = const $71 to char = [X+0] (used reg = )
	LDB	0,X
	SUBB	#$71
	LBEQ	.11F
.120:
; 183 			good = 0;
; Debug: eq int = const 0 to int good = [S+4-4] (used reg = )
	LDD	#0
	STD	0,S
;BCC_EOS
; 184 	ok(91,good);
.11F:
.11C:
; Debug: postinc int i = [S+4-2] (used reg = )
	LDD	2,S
	ADDD	#1
	STD	2,S
.11D:
; Debug: lt int = const $A to int i = [S+4-2] (used reg = )
	LDD	2,S
	SUBD	#$A
	BLT	.11E
.121:
.11B:
; Debug: list int good = [S+4-4] (used reg = )
	LDD	0,S
	PSHS	D
; Debug: rootlist int = const $5B (used reg = )
	LDX	#$5B
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 185 	memset(buf,0x1ff,3);			 
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list int = const $1FF (used reg = )
	LDD	#$1FF
	PSHS	D
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memset+0 (used reg = )
	JSR	>_memset
	LEAS	4,S
;BCC_EOS
; 186 	ok(92,(buf[0] & 0xff)== 0xff && (buf[2] & 0xff)== 0xff
; 187 	   && buf[3] == 'q');
; Debug: and int = const $FF to char = [buf+0] (used reg = )
	LDB	>_buf
; Debug: logeq int = const $FF to char = B+0 (used reg = )
	SUBB	#$FF
	LBNE	.122
.125:
; Debug: and int = const $FF to char = [buf+2] (used reg = )
	LDB	>_buf+2
; Debug: logeq int = const $FF to char = B+0 (used reg = )
	SUBB	#$FF
	LBNE	.122
.124:
; Debug: logeq int = const $71 to char = [buf+3] (used reg = )
	LDB	>_buf+3
	SUBB	#$71
	LBNE	.122
.123:
	LDB	#1
	BRA	.126
.122:
	CLRB
.126:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $5C (used reg = )
	LDX	#$5C
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 188 	memset(buf,'r',0);
; Debug: list int = const 0 (used reg = )
	LDD	#0
	PSHS	D
; Debug: list int = const $72 (used reg = )
	LDD	#$72
	PSHS	D
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memset+0 (used reg = )
	JSR	>_memset
	LEAS	4,S
;BCC_EOS
; 189 	ok(93,(buf[0] & 0xff)== 0xff);
; Debug: and int = const $FF to char = [buf+0] (used reg = )
	LDB	>_buf
; Debug: logeq int = const $FF to char = B+0 (used reg = )
	SUBB	#$FF
	BNE	.127
	LDB	#1
	BRA	.128
.127:
	CLRB
.128:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $5D (used reg = )
	LDX	#$5D
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 190 
; 191 	strcpy(buf,"abcdef");
	LOC	1
.129:
	FCC	"abcdef"
	FCB	0
	LOC	0
; Debug: list * char = .129+0 (used reg = )
	LDX	#.129
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 192 	ok(94,memcpy(buf2,buf,7)== buf2 && strcmp(buf2,"abcdef")== 0);
	LOC	1
.12A:
	FCC	"abcdef"
	FCB	0
	LOC	0
; Debug: list int = const 7 (used reg = )
	LDD	#7
	PSHS	D
; Debug: list * char = buf+0 (used reg = )
	LDX	#_buf
	PSHS	X
; Debug: rootlist * char = buf2+0 (used reg = )
	LDX	#_buf2
; Debug: func () * void = memcpy+0 (used reg = )
	JSR	>_memcpy
	LEAS	4,S
; Debug: logeq * char = buf2+0 to * void = X+0 (used reg = )
	CMPX	#_buf2
	LBNE	.12B
.12D:
; Debug: list * char = .12A+0 (used reg = )
	LDX	#.12A
	PSHS	X
; Debug: rootlist * char = buf2+0 (used reg = )
	LDX	#_buf2
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	LBNE	.12B
.12C:
	LDB	#1
	BRA	.12E
.12B:
	CLRB
.12E:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $5E (used reg = )
	LDX	#$5E
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 193 
; 194 	 
; 195 	strcpy(buf,"abcdefgh");
	LOC	1
.12F:
	FCC	"abcdefgh"
	FCB	0
	LOC	0
; Debug: list * char = .12F+0 (used reg = )
	LDX	#.12F
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 196 	ok(95,memmove(buf + 2,buf,4)== buf + 2);
; Debug: list int = const 4 (used reg = )
	LDD	#4
	PSHS	D
; Debug: list * char = buf+0 (used reg = )
	LDX	#_buf
	PSHS	X
; Debug: rootlist * char = buf+2 (used reg = )
	LDX	#_buf+2
; Debug: func () * void = memmove+0 (used reg = )
	JSR	>_memmove
	LEAS	4,S
; Debug: logeq * char = buf+2 to * void = X+0 (used reg = )
	CMPX	#_buf+2
	BNE	.130
	LDB	#1
	BRA	.131
.130:
	CLRB
.131:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $5F (used reg = )
	LDX	#$5F
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 197 	ok(96,strcmp(buf,"ababcdgh")== 0);
	LOC	1
.132:
	FCC	"ababcdgh"
	FCB	0
	LOC	0
; Debug: list * char = .132+0 (used reg = )
	LDX	#.132
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.133
	LDB	#1
	BRA	.134
.133:
	CLRB
.134:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $60 (used reg = )
	LDX	#$60
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 198 	strcpy(buf,"abcdefgh");
	LOC	1
.135:
	FCC	"abcdefgh"
	FCB	0
	LOC	0
; Debug: list * char = .135+0 (used reg = )
	LDX	#.135
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 199 	memmove(buf,buf + 2,4);
; Debug: list int = const 4 (used reg = )
	LDD	#4
	PSHS	D
; Debug: list * char = buf+2 (used reg = )
	LDX	#_buf+2
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memmove+0 (used reg = )
	JSR	>_memmove
	LEAS	4,S
;BCC_EOS
; 200 	ok(97,strcmp(buf,"cdefefgh")== 0);
	LOC	1
.136:
	FCC	"cdefefgh"
	FCB	0
	LOC	0
; Debug: list * char = .136+0 (used reg = )
	LDX	#.136
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.137
	LDB	#1
	BRA	.138
.137:
	CLRB
.138:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $61 (used reg = )
	LDX	#$61
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 201 	strcpy(buf,"abcdefgh");
	LOC	1
.139:
	FCC	"abcdefgh"
	FCB	0
	LOC	0
; Debug: list * char = .139+0 (used reg = )
	LDX	#.139
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * char = strcpy+0 (used reg = )
	JSR	>_strcpy
	LEAS	2,S
;BCC_EOS
; 202 	memmove(buf2,buf,9);
; Debug: list int = const 9 (used reg = )
	LDD	#9
	PSHS	D
; Debug: list * char = buf+0 (used reg = )
	LDX	#_buf
	PSHS	X
; Debug: rootlist * char = buf2+0 (used reg = )
	LDX	#_buf2
; Debug: func () * void = memmove+0 (used reg = )
	JSR	>_memmove
	LEAS	4,S
;BCC_EOS
; 203 	ok(98,strcmp(buf2,"abcdefgh")== 0);
	LOC	1
.13A:
	FCC	"abcdefgh"
	FCB	0
	LOC	0
; Debug: list * char = .13A+0 (used reg = )
	LDX	#.13A
	PSHS	X
; Debug: rootlist * char = buf2+0 (used reg = )
	LDX	#_buf2
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.13B
	LDB	#1
	BRA	.13C
.13B:
	CLRB
.13C:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $62 (used reg = )
	LDX	#$62
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 204 	memmove(buf,buf,9);
; Debug: list int = const 9 (used reg = )
	LDD	#9
	PSHS	D
; Debug: list * char = buf+0 (used reg = )
	LDX	#_buf
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () * void = memmove+0 (used reg = )
	JSR	>_memmove
	LEAS	4,S
;BCC_EOS
; 205 	ok(99,strcmp(buf,"abcdefgh")== 0);
	LOC	1
.13D:
	FCC	"abcdefgh"
	FCB	0
	LOC	0
; Debug: list * char = .13D+0 (used reg = )
	LDX	#.13D
	PSHS	X
; Debug: rootlist * char = buf+0 (used reg = )
	LDX	#_buf
; Debug: func () int = strcmp+0 (used reg = )
	JSR	>_strcmp
	LEAS	2,S
; Debug: logeq int = const 0 to int = X+0 (used reg = )
	LEAX	0,X
	BNE	.13E
	LDB	#1
	BRA	.13F
.13E:
	CLRB
.13F:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $63 (used reg = )
	LDX	#$63
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 206 
; 207 	 
; 208 	memset(buf2,'z',10);
; Debug: list int = const $A (used reg = )
	LDD	#$A
	PSHS	D
; Debug: list int = const $7A (used reg = )
	LDD	#$7A
	PSHS	D
; Debug: rootlist * char = buf2+0 (used reg = )
	LDX	#_buf2
; Debug: func () * void = memset+0 (used reg = )
	JSR	>_memset
	LEAS	4,S
;BCC_EOS
; 209 	ok(100,memccpy(buf2,"abcdef",'c',6)== buf2 + 3);
	LOC	1
.140:
	FCC	"abcdef"
	FCB	0
	LOC	0
; Debug: list int = const 6 (used reg = )
	LDD	#6
	PSHS	D
; Debug: list int = const $63 (used reg = )
	LDD	#$63
	PSHS	D
; Debug: list * char = .140+0 (used reg = )
	LDX	#.140
	PSHS	X
; Debug: rootlist * char = buf2+0 (used reg = )
	LDX	#_buf2
; Debug: func () * void = memccpy+0 (used reg = )
	JSR	>_memccpy
	LEAS	6,S
; Debug: logeq * char = buf2+3 to * void = X+0 (used reg = )
	CMPX	#_buf2+3
	BNE	.141
	LDB	#1
	BRA	.142
.141:
	CLRB
.142:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $64 (used reg = )
	LDX	#$64
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 210 	ok(101,buf2[2] == 'c' && buf2[3] == 'z');
; Debug: logeq int = const $63 to char = [buf2+2] (used reg = )
	LDB	>_buf2+2
	SUBB	#$63
	LBNE	.143
.145:
; Debug: logeq int = const $7A to char = [buf2+3] (used reg = )
	LDB	>_buf2+3
	SUBB	#$7A
	LBNE	.143
.144:
	LDB	#1
	BRA	.146
.143:
	CLRB
.146:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $65 (used reg = )
	LDX	#$65
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 211 	ok(102,memccpy(buf2,"abcdef",'x',6)== 0 && buf2[5] == 'f');
	LOC	1
.147:
	FCC	"abcdef"
	FCB	0
	LOC	0
; Debug: list int = const 6 (used reg = )
	LDD	#6
	PSHS	D
; Debug: list int = const $78 (used reg = )
	LDD	#$78
	PSHS	D
; Debug: list * char = .147+0 (used reg = )
	LDX	#.147
	PSHS	X
; Debug: rootlist * char = buf2+0 (used reg = )
	LDX	#_buf2
; Debug: func () * void = memccpy+0 (used reg = )
	JSR	>_memccpy
	LEAS	6,S
; Debug: logeq int = const 0 to * void = X+0 (used reg = )
	LEAX	0,X
	LBNE	.148
.14A:
; Debug: logeq int = const $66 to char = [buf2+5] (used reg = )
	LDB	>_buf2+5
	SUBB	#$66
	LBNE	.148
.149:
	LDB	#1
	BRA	.14B
.148:
	CLRB
.14B:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $66 (used reg = )
	LDX	#$66
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 212 	ok(103,memccpy(buf2,"abc",'a' + 256,3)== buf2 + 1);
	LOC	1
.14C:
	FCC	"abc"
	FCB	0
	LOC	0
; Debug: list int = const 3 (used reg = )
	LDD	#3
	PSHS	D
; Debug: list int = const $161 (used reg = )
	LDD	#$161
	PSHS	D
; Debug: list * char = .14C+0 (used reg = )
	LDX	#.14C
	PSHS	X
; Debug: rootlist * char = buf2+0 (used reg = )
	LDX	#_buf2
; Debug: func () * void = memccpy+0 (used reg = )
	JSR	>_memccpy
	LEAS	6,S
; Debug: logeq * char = buf2+1 to * void = X+0 (used reg = )
	CMPX	#_buf2+1
	BNE	.14D
	LDB	#1
	BRA	.14E
.14D:
	CLRB
.14E:
; Debug: list char = B+0 (used reg = )
	CLRA
	PSHS	D
; Debug: rootlist int = const $67 (used reg = )
	LDX	#$67
; Debug: func () void = ok+0 (used reg = )
	JSR	>_ok
	LEAS	2,S
;BCC_EOS
; 213 }
	PULS	U,Y,PC
; 214 
; 215 int main()
; 216 {
	EXPORT	_main
_main:
; 217 	lengths();
; Debug: func () void = lengths+0 (used reg = )
	JSR	>_lengths
;BCC_EOS
; 218 	copies();
; Debug: func () void = copies+0 (used reg = )
	JSR	>_copies
;BCC_EOS
; 219 	compares();
; Debug: func () void = compares+0 (used reg = )
	JSR	>_compares
;BCC_EOS
; 220 	searches();
; Debug: func () void = searches+0 (used reg = )
	JSR	>_searches
;BCC_EOS
; 221 	tokens();
; Debug: func () void = tokens+0 (used reg = )
	JSR	>_tokens
;BCC_EOS
; 222 	memories();
; Debug: func () void = memories+0 (used reg = )
	JSR	>_memories
;BCC_EOS
; 223 	say("checks ");
	LOC	1
.14F:
	FCC	"checks "
	FCB	0
	LOC	0
; Debug: rootlist * char = .14F+0 (used reg = )
	LDX	#.14F
; Debug: func () void = say+0 (used reg = )
	JSR	>_say
;BCC_EOS
; 224 	putnum(checks);
; Debug: rootlist int = [checks+0] (used reg = )
	LDX	>_checks
; Debug: func () void = putnum+0 (used reg = )
	JSR	>_putnum
;BCC_EOS
; 225 	say("failures ");
	LOC	1
.150:
	FCC	"failures "
	FCB	0
	LOC	0
; Debug: rootlist * char = .150+0 (used reg = )
	LDX	#.150
; Debug: func () void = say+0 (used reg = )
	JSR	>_say
;BCC_EOS
; 226 	putnum(failures);
; Debug: rootlist int = [failures+0] (used reg = )
	LDX	>_failures
; Debug: func () void = putnum+0 (used reg = )
	JSR	>_putnum
;BCC_EOS
; 227 	return failures;
	LDX	>_failures
	RTS
;BCC_EOS
; 228 }
; 229 
	LOC	3
_buf		COMM	$40
_checks		COMM	2
_buf2		COMM	$40
_failures		COMM	2

; 0 errors detected
