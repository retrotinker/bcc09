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
	ldb	1,x		; the 52 bits of fraction, from bit 51 at
	andb	#$0f		; MAN+0 bit 3 down; then 2 bits left
	stb	MAN,y
	ldd	2,x
	std	MAN+1,y
	ldd	4,x
	std	MAN+3,y
	ldd	6,x
	std	MAN+5,y
	clr	MAN+7,y
	ldd	EXP,y
	beq	udsub		; zero or denormal
	cmpd	#$7ff
	beq	udinf		; infinity or NaN
	subd	#1023
	std	EXP,y
	lda	MAN,y		; the leading 1
	ora	#$10
	sta	MAN,y
	lbsr	__fpml1
	lbsr	__fpml1
	lda	#1
	sta	CLS,y
	rts
udsub:	lbsr	mzero
	beq	uzero
	ldd	#-1022
	std	EXP,y
	lbsr	__fpml1
	lbsr	__fpml1
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
	pshs	b
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
	lbsr	__fpmr1
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
	cmpd	#$7ff
	bge	pdinf		; too big
	pshs	x
	pshs	d		; 0,S: the biased exponent  2,S: X
	ldd	,s		; (for its flags)
	ble	pd0
	ldb	#10		; the bits below a double's 53
	bra	pd2a
pd0:	ldd	#11		; a denormal: 1 - exponent bits more
	subd	,s
	tsta
	beq	pd1
	ldb	#255
pd1:	clr	,s		; (the exponent is 0)
	clr	1,s
pd2a:	lbsr	round
	ldd	,s
	beq	pdden
	lda	MAN+1,y		; a carry to bit 53: one bit less, and one
	bita	#$20		; more in the exponent
	beq	pd4
	lbsr	__fpmr1
	ldd	,s
	addd	#1
	std	,s
	cmpd	#$7ff
	bne	pd4
	leas	2,s		; rounded up to infinity
	puls	x
	bra	pdinf
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
