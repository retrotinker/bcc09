; idiv, imod, idivu, imodu: 16-bit divide and remainder for bcc09
;
; D = D / X or D = D % X, signed (idiv, imod) or unsigned (idivu, imodu).
; Signed division truncates toward zero, and the remainder has the sign
; of the dividend, as C99 requires.  Division by zero doesn't trap: the
; remainder is the dividend, and the quotient is $FFFF unsigned, or
; signed -1 for a dividend of 0 or more and 1 for a negative one.
; -32768 / -1 gives -32768.  Changes D, X and CC.

	.text
	export	idiv
	export	imod
	export	idivu
	export	imodu

idiv:
	bsr	sdivmod
	rts

imod:
	bsr	sdivmod
	tfr	x,d
	rts

idivu:
	bsr	udivmod
	rts

imodu:
	bsr	udivmod
	tfr	x,d
	rts

; signed: D = D / X, X = D % X
sdivmod:
	leas	-2,s		; 0,S: negate the quotient if non-zero
				; 1,S: negate the remainder if non-zero
	clr	0,s
	clr	1,s
	tsta
	bpl	sdpos
	nega			; negate D
	negb
	sbca	#0
	com	0,s
	com	1,s
sdpos:	exg	d,x
	tsta
	bpl	sdvpos
	nega
	negb
	sbca	#0
	com	0,s
sdvpos:	exg	d,x
	bsr	udivmod
	tst	0,s
	beq	sdqpos
	nega
	negb
	sbca	#0
sdqpos:	tst	1,s
	beq	sdrpos
	exg	d,x
	nega
	negb
	sbca	#0
	exg	d,x
sdrpos:	leas	2,s
	rts

; unsigned: D = D / X, X = D % X, by shifting and subtracting
udivmod:
	pshs	d,x		; 0,S: dividend, becoming the quotient
				; 2,S: divisor
	ldd	#0		; the remainder
	ldx	#16		; one pass for each bit
udloop:	lsl	1,s		; the dividend's next bit into C, and 0
	rol	0,s		; into the quotient's lowest bit
	rolb			; into the remainder
	rola
	bcs	udsub		; 17 bits: certainly not less than the divisor
	cmpd	2,s
	blo	udnext
udsub:	subd	2,s
	inc	1,s		; a 1 in the quotient
udnext:	leax	-1,x
	bne	udloop
	tfr	d,x		; the remainder
	puls	d		; the quotient
	leas	2,s
	rts
