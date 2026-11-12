; call.s: OS-9's system calls, for libc on OS-9 (bcc09 -Mo)
;
; __os9call(r, call) makes a system call (SWI2, then the call's code: one
; of the stubs below, call being its number in them, as os9/os9.h has
; them) with the registers in the structure at r (CC, A, B, DP, then X,
; Y and U), and puts the registers that come back there; C set in CC
; means an error, whose code is in B.  U is libc's data pointer, so it is
; kept, whatever the call does with it.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	___os9call

; the system calls' codes
F$Exit	equ	$06
I$Open	equ	$84
I$Create	equ	$83
I$Close	equ	$8f
I$ReadLn	equ	$8b
I$WritLn	equ	$8c
I$Seek	equ	$88
I$GetStt	equ	$8d
I$SetStt	equ	$8e
I$Delete	equ	$87
I$Read	equ	$89
I$MakDir	equ	$85
I$ChgDir	equ	$86
F$Mem	equ	$07
F$Fork	equ	$03
F$Wait	equ	$04
F$Time	equ	$15

RCC	equ	0		; struct os9regs
RA	equ	1
RB	equ	2
RX	equ	4
RY	equ	6
RU	equ	8

___os9call:
	pshs	u,y
	pshs	x		; 0,S: r  2,S: Y, U  6,S: return  8,S: call
	ldd	8,s
	aslb			; (each stub is 4 bytes)
	rola
	aslb
	rola
	leay	stubs,pcr
	leay	d,y
	pshs	y		; 0,S: the stub  2,S: r
	lda	RA,x
	ldb	RB,x
	ldy	RY,x
	ldu	RU,x
	ldx	RX,x
	jsr	[,s]
	leas	2,s		; (LEAS and PSHS keep CC)
	pshs	u,y,x,d,cc	; the registers back, then into r
	ldx	9,s
	lda	,s
	sta	RCC,x
	ldd	1,s
	std	RA,x
	ldd	3,s
	std	RX,x
	ldd	5,s
	std	RY,x
	ldd	7,s
	std	RU,x
	leas	9,s
	puls	x
	puls	u,y,pc

; each: the system call (OS9: SWI2 and its code), RTS (in the order of
; os9/os9.h)
stubs:	os9	F$Exit		; 0
	rts
	os9	I$Open		; 1
	rts
	os9	I$Create		; 2
	rts
	os9	I$Close		; 3
	rts
	os9	I$ReadLn		; 4
	rts
	os9	I$WritLn		; 5
	rts
	os9	I$Seek		; 6
	rts
	os9	I$GetStt		; 7
	rts
	os9	I$SetStt		; 8
	rts
	os9	I$Delete		; 9
	rts
	os9	I$Read		; 10
	rts
	os9	I$MakDir		; 11
	rts
	os9	I$ChgDir		; 12
	rts
	os9	F$Mem		; 13
	rts
	os9	F$Fork		; 14
	rts
	os9	F$Wait		; 15
	rts
	os9	F$Time		; 16
	rts
