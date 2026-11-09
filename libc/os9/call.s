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

; each: SWI2, the call's code, RTS (in the order of os9/os9.h)
stubs:	swi2
	fcb	$06		; 0: F$Exit
	rts
	swi2
	fcb	$84		; 1: I$Open
	rts
	swi2
	fcb	$83		; 2: I$Create
	rts
	swi2
	fcb	$8f		; 3: I$Close
	rts
	swi2
	fcb	$8b		; 4: I$ReadLn
	rts
	swi2
	fcb	$8c		; 5: I$WritLn
	rts
	swi2
	fcb	$88		; 6: I$Seek
	rts
	swi2
	fcb	$8d		; 7: I$GetStt
	rts
	swi2
	fcb	$8e		; 8: I$SetStt
	rts
	swi2
	fcb	$87		; 9: I$Delete
	rts
	swi2
	fcb	$89		; 10: I$Read
	rts
	swi2
	fcb	$85		; 11: I$MakDir
	rts
	swi2
	fcb	$86		; 12: I$ChgDir
	rts
	swi2
	fcb	$07		; 13: F$Mem
	rts
	swi2
	fcb	$03		; 14: F$Fork
	rts
	swi2
	fcb	$04		; 15: F$Wait
	rts
