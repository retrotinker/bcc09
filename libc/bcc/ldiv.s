; ldiv_b, lmod_b, ldivu_b, lmodu_b: 32-bit divide and remainder for
; bcc09
;
; D:X = D:X / [Y] or D:X % [Y], signed (ldiv_b, lmod_b) or unsigned
; (ldivu_b, lmodu_b): D holds the high word and X the low one, and Y
; points at the divisor.  As for 16 bits (see idiv.s): signed division
; truncates toward zero and the remainder has the sign of the dividend;
; division by zero doesn't trap, but gives the dividend as the remainder
; and a quotient of all ones (unsigned), or signed -1 for a dividend of
; 0 or more and 1 for a negative one; and LONG_MIN / -1 gives LONG_MIN.
; Changes D, X and CC.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	ldiv_b
	export	lmod_b
	export	ldivu_b
	export	lmodu_b

; a work area on the stack, at U (whose old value is saved above it)
Q	equ	0		; the dividend, becoming the quotient
R	equ	4		; the remainder
V	equ	8		; the divisor
COUNT	equ	12		; bits left to do
QNEG	equ	13		; non-zero: negate the quotient
RNEG	equ	14		; non-zero: negate the remainder
SIZE	equ	15

ldivu_b:
	pshs	u
	leas	-SIZE,s
	tfr	s,u
	bsr	ldsetup
	bsr	udiv32
	ldd	Q,u
	ldx	Q+2,u
	bra	ldexit

lmodu_b:
	pshs	u
	leas	-SIZE,s
	tfr	s,u
	bsr	ldsetup
	bsr	udiv32
	ldd	R,u
	ldx	R+2,u
	bra	ldexit

ldiv_b:
	pshs	u
	leas	-SIZE,s
	tfr	s,u
	bsr	ldsetup
	bsr	sdiv32
	leax	Q,u
	tst	QNEG,u
	beq	ldq
	lbsr	neg32
ldq:	ldd	Q,u
	ldx	Q+2,u
	bra	ldexit

lmod_b:
	pshs	u
	leas	-SIZE,s
	tfr	s,u
	bsr	ldsetup
	bsr	sdiv32
	leax	R,u
	tst	RNEG,u
	beq	ldr
	lbsr	neg32
ldr:	ldd	R,u
	ldx	R+2,u
ldexit:	leas	SIZE,u
	puls	u,pc

; the dividend from D:X, and the divisor from [Y]
ldsetup:
	std	Q,u
	stx	Q+2,u
	ldd	0,y
	std	V,u
	ldd	2,y
	std	V+2,u
	rts

; signed: divide the magnitudes, and note the signs of the results
sdiv32:
	clr	QNEG,u
	clr	RNEG,u
	tst	Q,u
	bpl	sdvpos
	leax	Q,u
	lbsr	neg32
	com	QNEG,u
	com	RNEG,u
sdvpos:	tst	V,u
	bpl	udiv32
	leax	V,u
	lbsr	neg32
	com	QNEG,u
				; (on into udiv32)

; unsigned: Q = Q / V and R = Q % V, by shifting and subtracting
udiv32:
	ldd	#0
	std	R,u
	std	R+2,u
	lda	#32
	sta	COUNT,u
udloop:	lsl	Q+3,u		; the dividend's next bit into C, and 0
	rol	Q+2,u		; into the quotient's lowest bit
	rol	Q+1,u
	rol	Q,u
	rol	R+3,u		; into the remainder
	rol	R+2,u
	rol	R+1,u
	rol	R,u
	bcs	udsub		; 33 bits: certainly not less than V
	ldd	R,u
	cmpd	V,u
	bhi	udsub
	blo	udnext
	ldd	R+2,u
	cmpd	V+2,u
	blo	udnext
udsub:	ldd	R+2,u
	subd	V+2,u
	std	R+2,u
	ldd	R,u		; (LDD leaves the borrow)
	sbcb	V+1,u
	sbca	V,u
	std	R,u
	inc	Q+3,u		; a 1 in the quotient
udnext:	dec	COUNT,u
	bne	udloop
	rts

; negate the long at X
neg32:	ldd	#0
	subd	2,x
	std	2,x
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	0,x
	rts
