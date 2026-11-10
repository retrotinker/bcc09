; fpcore.s: the core of bcc09's software floating point
;
; Floats and doubles are IEEE single and double precision, big-endian
; (the sign and exponent in the first byte), as the 6809 holds other
; numbers.  The helpers that the compiler calls (fparith.s, fpcmp.s,
; fppush.s, fpconv.s, fpincdec.s) unpack their operands into records,
; work on those, and pack the result again, rounding to the nearest
; (to even on a tie), with infinities, NaNs and denormals as IEEE 754 has
; them.  A record is 12 bytes:
;
;   SGN  sign: $80 if negative, else 0
;   CLS  class: 0 zero, 1 finite and not zero, 2 infinity, 3 NaN
;   EXP  exponent (16 bits, signed): the value is MAN * 2^(EXP - 62)
;   MAN  mantissa: 64 bits, big-endian; when finite, bit 62 is the leading
;        1 (bit 63 is room for a carry), and below the 53 bits of a double
;        are 10 more, for rounding, with any bits shifted out of the
;        bottom ORed into bit 0 ("sticky")
;
; Each routine here takes a record's address in Y (and another's in X),
; changes D, X and CC, and keeps Y and U.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	__fpud
	export	__fpuf
	export	__fppd
	export	__fppf
	export	__fpnorm
	export	__fprsh
	export	__fpmr1
	export	__fpml1
	export	__fpf2d
	export	__fpd2f

SGN	equ	0
CLS	equ	1
EXP	equ	2
MAN	equ	4

; Z is set if the mantissa of the record at Y is 0
mzero:	ldd	MAN,y
	bne	mz1
	ldd	MAN+2,y
	bne	mz1
	ldd	MAN+4,y
	bne	mz1
	ldd	MAN+6,y
mz1:	rts

; the mantissa of the record at Y, shifted left 1 bit
__fpml1:
	asl	MAN+7,y
	rol	MAN+6,y
	rol	MAN+5,y
	rol	MAN+4,y
	rol	MAN+3,y
	rol	MAN+2,y
	rol	MAN+1,y
	rol	MAN,y
	rts

; the mantissa of the record at Y, shifted right 1 bit (nothing sticky)
__fpmr1:
	lsr	MAN,y
	ror	MAN+1,y
	ror	MAN+2,y
	ror	MAN+3,y
	ror	MAN+4,y
	ror	MAN+5,y
	ror	MAN+6,y
	ror	MAN+7,y
	rts

; __fpud: unpack the double at X into the record at Y
;
; The fraction goes 2 bits left as it is copied: byte k of the mantissa
; is the low byte of the double's bytes k+1 and k+2, 2 bits left.
__fpud:
	lda	,x
	anda	#$80
	sta	SGN,y
	ldd	,x		; the exponent: 11 bits after the sign
	anda	#$7f
	lsra
	rorb
	lsra
	rorb
	lsra
	rorb
	lsra
	rorb
	std	EXP,y
	ldd	1,x		; the 52 bits of fraction, from bit 61
	aslb
	rola
	aslb
	rola
	anda	#$3f
	sta	MAN,y
	ldd	2,x
	aslb
	rola
	aslb
	rola
	sta	MAN+1,y
	ldd	3,x
	aslb
	rola
	aslb
	rola
	sta	MAN+2,y
	ldd	4,x
	aslb
	rola
	aslb
	rola
	sta	MAN+3,y
	ldd	5,x
	aslb
	rola
	aslb
	rola
	sta	MAN+4,y
	ldd	6,x
	aslb
	rola
	aslb
	rola
	std	MAN+5,y
	clr	MAN+7,y
	ldd	EXP,y
	beq	udsub		; zero or denormal
	cmpd	#$7ff
	beq	udinf		; infinity or NaN
	subd	#1023
	std	EXP,y
	lda	MAN,y		; the leading 1
	ora	#$40
	sta	MAN,y
	lda	#1
	sta	CLS,y
	rts
udsub:	lbsr	mzero
	beq	uzero
	ldd	#-1022
	std	EXP,y
	lda	#1
	sta	CLS,y
	bra	__fpnorm
uzero:	clr	CLS,y
	rts
udinf:	lbsr	mzero
	beq	uinf
	lda	#3		; NaN
	sta	CLS,y
	rts
uinf:	lda	#2
	sta	CLS,y
	rts

; __fpuf: unpack the float at X into the record at Y
__fpuf:
	lda	,x
	anda	#$80
	sta	SGN,y
	ldd	,x		; the exponent: 8 bits after the sign
	aslb
	rola
	tfr	a,b
	clra
	std	EXP,y
	ldd	1,x		; the 23 bits of fraction, from bit 62 down
	anda	#$7f
	std	MAN,y
	lda	3,x
	sta	MAN+2,y
	clr	MAN+3,y
	clr	MAN+4,y
	clr	MAN+5,y
	clr	MAN+6,y
	clr	MAN+7,y
	ldd	EXP,y
	beq	ufsub
	cmpd	#$ff
	beq	udinf
	subd	#127
	std	EXP,y
	lda	MAN,y
	ora	#$80
	sta	MAN,y
	lda	#1
	sta	CLS,y
	lbra	__fpmr1
ufsub:	lbsr	mzero
	beq	uzero
	ldd	#-126
	std	EXP,y
	lbsr	__fpmr1
	lda	#1
	sta	CLS,y
	; (and normalize)

; __fpnorm: normalize the finite record at Y (whose bit 63 is clear):
; shift the mantissa left until bit 62 is set, or make it zero
__fpnorm:
	lbsr	mzero
	bne	nm1
	clr	CLS,y
	rts
nm1:	lda	MAN,y		; a byte at a time while the top one is 0
	bne	nm2
	lda	MAN+1,y
	bmi	nm2
	ldd	MAN+1,y
	std	MAN,y
	ldd	MAN+3,y
	std	MAN+2,y
	ldd	MAN+5,y
	std	MAN+4,y
	lda	MAN+7,y
	sta	MAN+6,y
	clr	MAN+7,y
	ldd	EXP,y
	subd	#8
	std	EXP,y
	bra	nm1
nm2:	lda	MAN,y		; then a bit at a time
	bita	#$40
	bne	nm3
	lbsr	__fpml1
	ldd	EXP,y
	subd	#1
	std	EXP,y
	bra	nm2
nm3:	rts

; __fprsh: shift the mantissa of the record at Y right B bits (0 to 255),
; ORing any 1s shifted out into bit 0
__fprsh:
	cmpb	#64
	blo	rs0
	lbsr	mzero		; all of it: only the sticky bit is left
	beq	rs5
	clra
	clrb
	std	MAN,y
	std	MAN+2,y
	std	MAN+4,y
	incb
	std	MAN+6,y
rs5:	rts
rs0:	pshs	b
	clr	,-s		; 0,S: the bits shifted out; 1,S: the count
rs1:	lda	1,s
	cmpa	#8
	blo	rs2
	suba	#8
	sta	1,s
	lda	MAN+7,y		; a byte at a time
	ora	,s
	sta	,s
	ldd	MAN+5,y
	std	MAN+6,y
	ldd	MAN+3,y
	std	MAN+4,y
	ldd	MAN+1,y
	std	MAN+2,y
	lda	MAN,y
	sta	MAN+1,y
	clr	MAN,y
	bra	rs1
rs2:	tst	1,s		; then a bit at a time
	beq	rs3
	lsr	MAN,y
	ror	MAN+1,y
	ror	MAN+2,y
	ror	MAN+3,y
	ror	MAN+4,y
	ror	MAN+5,y
	ror	MAN+6,y
	ror	MAN+7,y
	bcc	rs2a
	lda	#1		; (not INC: the byte loop may have left $FF)
	ora	,s
	sta	,s
rs2a:	dec	1,s
	bra	rs2
rs3:	tst	,s
	beq	rs4
	lda	MAN+7,y
	ora	#1
	sta	MAN+7,y
rs4:	leas	2,s
	rts

; round: shift the finite mantissa of the record at Y right B bits (2 to
; 255), rounding to the nearest, to even on a tie; the result may be
; one bit longer than was wanted (a carry from rounding up)
round:	subb	#2		; keep a round bit and a sticky bit
	lbsr	__fprsh
	lda	MAN+7,y
	bita	#2
	beq	rd2		; below half: down
	bita	#5
	beq	rd2		; just half, and even: down
	ldd	MAN+6,y		; up
	addd	#4
	std	MAN+6,y
	bcc	rd2
	inc	MAN+5,y
	bne	rd2
	inc	MAN+4,y
	bne	rd2
	inc	MAN+3,y
	bne	rd2
	inc	MAN+2,y
	bne	rd2
	inc	MAN+1,y
	bne	rd2
	inc	MAN,y
rd2:	lbsr	__fpmr1
	lbra	__fpmr1

; __fppd: pack the record at Y into the double at X, rounding (this
; changes the record)
__fppd:
	lda	CLS,y
	cmpa	#1
	beq	pdfin
	blo	pdzero
	cmpa	#2
	beq	pdinf
pdnan:	ldd	#$7ff8		; NaN
	bra	pd2
pdzero:	lda	SGN,y
	clrb
	bra	pd2
pdinf:	lda	SGN,y
	ora	#$7f
	ldb	#$f0
pd2:	std	,x
	clra
	clrb
	std	2,x
	std	4,x
	std	6,x
	rts
pdfin:	ldd	EXP,y		; the biased exponent
	addd	#1023
	lble	pdsub		; a denormal (or 0)
	cmpd	#$7ff
	bge	pdinf		; too big
; normal: round at bit 10 (the last of the 53), then bits 61 to 10 are
; the fraction: byte j of the double is the low byte of the mantissa's
; bytes j-2 and j-1, 2 bits right
	pshs	d		; 0,S: the biased exponent
	lda	MAN+6,y
	bita	#2		; bit 9: below half?
	beq	pn3
	bita	#5		; above half, or odd?
	bne	pn1
	tst	MAN+7,y
	beq	pn3		; just half, and even: down
pn1:	ldd	MAN+6,y		; up
	addd	#$400
	std	MAN+6,y
	bcc	pn3
	inc	MAN+5,y
	bne	pn3
	inc	MAN+4,y
	bne	pn3
	inc	MAN+3,y
	bne	pn3
	inc	MAN+2,y
	bne	pn3
	inc	MAN+1,y
	bne	pn3
	inc	MAN,y
	bpl	pn3
	lbsr	__fpmr1		; a carry to bit 63: one more in the
	ldd	,s		; exponent
	addd	#1
	std	,s
	cmpd	#$7ff
	bne	pn3
	leas	2,s		; rounded up to infinity
	lbra	pdinf
pn3:	ldd	MAN+5,y
	lsra
	rorb
	lsra
	rorb
	stb	7,x
	ldd	MAN+4,y
	lsra
	rorb
	lsra
	rorb
	stb	6,x
	ldd	MAN+3,y
	lsra
	rorb
	lsra
	rorb
	stb	5,x
	ldd	MAN+2,y
	lsra
	rorb
	lsra
	rorb
	stb	4,x
	ldd	MAN+1,y
	lsra
	rorb
	lsra
	rorb
	stb	3,x
	ldd	MAN,y
	lsra
	rorb
	lsra
	rorb
	stb	2,x
	puls	d		; sign, exponent, the top 4 bits of fraction
	aslb
	rola
	aslb
	rola
	aslb
	rola
	aslb
	rola
	ora	SGN,y
	std	,x
	lda	MAN,y
	lsra
	lsra
	anda	#$0f
	ora	1,x
	sta	1,x
	rts
pdsub:	pshs	x		; a denormal: 10 bits and 1 - exponent
	pshs	d		; more go (0,S: the biased exponent, then
	ldd	#11		; 0; 2,S: X)
	subd	,s
	tsta
	beq	pd1
	ldb	#255
pd1:	clr	,s
	clr	1,s
	lbsr	round
pdden:	lda	MAN+1,y		; a denormal that rounded up to a normal
	bita	#$10
	beq	pd4
	ldd	#1
	std	,s
pd4:	ldd	,s		; sign, exponent, the top 4 bits of fraction
	aslb
	rola
	aslb
	rola
	aslb
	rola
	aslb
	rola
	ora	SGN,y
	std	,s
	ldb	MAN+1,y
	andb	#$0f
	orb	1,s
	stb	1,s
	puls	d
	puls	x
	std	,x
	ldd	MAN+2,y
	std	2,x
	ldd	MAN+4,y
	std	4,x
	ldd	MAN+6,y
	std	6,x
	rts

; __fppf: pack the record at Y into the float at X, rounding (this
; changes the record)
__fppf:
	lda	CLS,y
	cmpa	#1
	beq	pffin
	blo	pfzero
	cmpa	#2
	beq	pfinf
	ldd	#$7fc0		; NaN
	bra	pf2
pfzero:	lda	SGN,y
	clrb
	bra	pf2
pfinf:	lda	SGN,y
	ora	#$7f
	ldb	#$80
pf2:	std	,x
	clr	2,x
	clr	3,x
	rts
pffin:	ldd	EXP,y		; the biased exponent
	addd	#127
	cmpd	#$ff
	bge	pfinf		; too big
	pshs	x
	pshs	d		; 0,S: the biased exponent  2,S: X
	ldd	,s		; (for its flags)
	ble	pf0
	ldb	#39		; the bits below a float's 24
	bra	pf3
pf0:	ldd	#40		; a denormal: 1 - exponent bits more
	subd	,s
	tsta
	beq	pf1
	ldb	#255
pf1:	clr	,s
	clr	1,s
pf3:	lbsr	round
	ldd	,s
	beq	pfden
	lda	MAN+4,y		; a carry to bit 24
	bita	#1
	beq	pf4
	lbsr	__fpmr1
	ldd	,s
	addd	#1
	std	,s
	cmpd	#$ff
	bne	pf4
	leas	2,s
	puls	x
	bra	pfinf
pfden:	lda	MAN+5,y
	bpl	pf4
	ldd	#1
	std	,s
pf4:	puls	d		; B: the exponent
	puls	x
	lsrb			; C: its low bit
	orb	SGN,y
	stb	,x
	lda	MAN+5,y		; (these keep C)
	anda	#$7f
	bcc	pf5
	ora	#$80
pf5:	sta	1,x
	ldd	MAN+6,y
	std	2,x
	rts

; __fpf2d: the float at X as the double at Y (which is exact)
;
; A normal float's bits move straight over: the exponent and fraction 3
; bits right, the exponent rebiased (1023 - 127 more), and the sign.  The
; others (zero, denormals, infinities, NaNs) go through a record.
__fpf2d:
	ldd	,x
	aslb
	rola			; A: the exponent
	beq	f2ds
	cmpa	#$ff
	beq	f2ds
	ldd	,x
	anda	#$7f
	std	,y
	ldd	2,x
	std	2,y
	clra
	clrb
	std	4,y
	std	6,y
	lsr	,y		; 3 bits right
	ror	1,y
	ror	2,y
	ror	3,y
	ror	4,y
	lsr	,y
	ror	1,y
	ror	2,y
	ror	3,y
	ror	4,y
	lsr	,y
	ror	1,y
	ror	2,y
	ror	3,y
	ror	4,y
	ldd	,y
	addd	#(1023-127)*16
	std	,y
	lda	,x		; the sign
	anda	#$80
	ora	,y
	sta	,y
	rts
f2ds:	pshs	u,y		; 0,S: a record  12,S: Y, U
	leas	-12,s
	leay	,s
	lbsr	__fpuf
	ldx	12,s
	lbsr	__fppd
	leas	12,s
	puls	y,u,pc

; __fpd2f: the double at X as the float at Y, rounding
;
; A double whose exponent is a normal float's: its bits 60 to 29 (8 bits
; of exponent, 23 of fraction) are those of the float, but for the bias
; (128 less, and so bit 60 goes) and the sign, and rounding by bit 28 and
; those below it.  A carry from rounding may make the float infinite, as
; it should.  The others go through a record.
__fpd2f:
	ldd	,x
	anda	#$7f		; the exponent in the top 11 bits
	cmpd	#(1023-127+1)*16
	blo	d2fs		; a float's would be 0 or less
	cmpd	#(1023+127+1)*16
	bhs	d2fs		; or 255 or more
	ldb	4,x
	pshs	b		; 0,S: the 5th byte
	ldd	,x
	std	,y
	ldd	2,x
	std	2,y
	asl	,s		; 3 bits left
	rol	3,y
	rol	2,y
	rol	1,y
	rol	,y
	asl	,s
	rol	3,y
	rol	2,y
	rol	1,y
	rol	,y
	asl	,s
	rol	3,y
	rol	2,y
	rol	1,y
	rol	,y
	ldd	,y		; the exponent: 128 less (no borrow, in
	subd	#$80*128	; range), then the sign for bit 60
	anda	#$7f
	std	,y
	lda	,x
	anda	#$80
	ora	,y
	sta	,y
	lda	,s+		; bit 28: below half?
	bpl	d2f9
	anda	#$7f		; above half?
	ora	5,x
	ora	6,x
	ora	7,x
	bne	d2f8
	lda	3,y		; just half: to even
	bita	#1
	beq	d2f9
d2f8:	ldd	2,y		; up
	addd	#1
	std	2,y
	bcc	d2f9
	ldd	,y
	addd	#1
	std	,y
d2f9:	rts
d2fs:	pshs	u,y
	leas	-12,s
	leay	,s
	lbsr	__fpud
	ldx	12,s
	lbsr	__fppf
	leas	12,s
	puls	y,u,pc
