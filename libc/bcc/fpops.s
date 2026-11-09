; fpops.s: addition, multiplication and division of unpacked floating
; point records (see fpcore.s) for bcc09
;
; __fpadd: Y = Y + X    __fpmul: Y = Y * X    __fpdiv: Y = Y / X
;
; Y and X point at records; the result is in the record at Y, and the
; record at X may be changed.  Change D, X and CC; keep Y and U.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	__fpadd
	export	__fpmul
	export	__fpdiv
	import	__fpnorm
	import	__fprsh
	import	__fpmr1
	import	__fpml1

SGN	equ	0
CLS	equ	1
EXP	equ	2
MAN	equ	4

; the record at Y becomes a NaN, or a copy of the one at X
nan:	lda	#3
	sta	CLS,y
	rts
copy:	ldd	,x
	std	,y
	ldd	2,x
	std	2,y
	ldd	4,x
	std	4,y
	ldd	6,x
	std	6,y
	ldd	8,x
	std	8,y
	ldd	10,x
	std	10,y
	rts

; __fpadd: Y = Y + X
__fpadd:
	lda	CLS,y
	cmpa	#3
	lbeq	ad9		; NaN + x
	ldb	CLS,x
	cmpb	#3
	lbeq	nan		; x + NaN
	cmpa	#2
	bne	ad1
	cmpb	#2		; inf + x
	lbne	ad9
	lda	SGN,y		; inf + inf: NaN if the signs differ
	cmpa	SGN,x
	lbne	nan
ad9:	rts
ad1:	cmpb	#2
	beq	copy		; x + inf
	tstb
	bne	ad2
	tsta			; x + 0
	lbne	ad9
	lda	SGN,y		; 0 + 0: -0 only if both are
	anda	SGN,x
	sta	SGN,y
	rts
ad2:	tsta
	beq	copy		; 0 + x
; both finite: the one at Y gets the larger exponent
	ldd	EXP,y
	subd	EXP,x
	bge	ad3
	ldb	#12		; swap the records
	pshs	b
ad2a:	lda	,x
	ldb	,y
	sta	,y+
	stb	,x+
	dec	,s
	bne	ad2a
	leas	1,s
	leax	-12,x
	leay	-12,y
	ldd	EXP,y
	subd	EXP,x
ad3:	tsta			; line up the other one: shift it right
	beq	ad3a		; by the difference
	ldb	#255
ad3a:	exg	x,y
	lbsr	__fprsh
	exg	x,y
	lda	SGN,y
	cmpa	SGN,x
	bne	ad5
; the same signs: add the mantissas (bit 63 takes a carry)
	ldd	MAN+6,y
	addd	MAN+6,x
	std	MAN+6,y
	ldd	MAN+4,y
	adcb	MAN+5,x
	adca	MAN+4,x
	std	MAN+4,y
	ldd	MAN+2,y
	adcb	MAN+3,x
	adca	MAN+2,x
	std	MAN+2,y
	ldd	MAN,y
	adcb	MAN+1,x
	adca	MAN,x
	std	MAN,y
	bpl	ad9
	ldb	#1		; one bit too many
	lbsr	__fprsh
	ldd	EXP,y
	addd	#1
	std	EXP,y
	rts
; different signs: subtract them, and if the one at X was larger, the
; result is negative (its sign)
ad5:	ldd	MAN+6,y
	subd	MAN+6,x
	std	MAN+6,y
	ldd	MAN+4,y
	sbcb	MAN+5,x
	sbca	MAN+4,x
	std	MAN+4,y
	ldd	MAN+2,y
	sbcb	MAN+3,x
	sbca	MAN+2,x
	std	MAN+2,y
	ldd	MAN,y
	sbcb	MAN+1,x
	sbca	MAN,x
	std	MAN,y
	bcc	ad6
	lda	SGN,x		; negate the difference
	sta	SGN,y
	com	MAN,y
	com	MAN+1,y
	com	MAN+2,y
	com	MAN+3,y
	com	MAN+4,y
	com	MAN+5,y
	com	MAN+6,y
	com	MAN+7,y
	ldd	MAN+6,y
	addd	#1
	std	MAN+6,y
	bcc	ad6
	inc	MAN+5,y
	bne	ad6
	inc	MAN+4,y
	bne	ad6
	inc	MAN+3,y
	bne	ad6
	inc	MAN+2,y
	bne	ad6
	inc	MAN+1,y
	bne	ad6
	inc	MAN,y
ad6:	lbsr	__fpnorm
	lda	CLS,y		; x - x is +0
	lbne	ad9
	clr	SGN,y
	rts

; the sign of a product or quotient, then the special cases: B is 0 if
; neither is special (both finite), else the class of the result
signs:	lda	SGN,y
	eora	SGN,x
	sta	SGN,y
	lda	CLS,y
	ldb	CLS,x
	cmpa	#3
	beq	sg3
	cmpb	#3
	beq	sg3
	clrb
	rts
sg3:	ldb	#3
	rts

; __fpmul: Y = Y * X
__fpmul:
	bsr	signs
	tstb
	lbne	nan
	lda	CLS,y
	ldb	CLS,x
	cmpa	#2
	beq	mu1		; inf * x
	cmpb	#2
	bne	mu2
	exg	a,b		; x * inf
mu1:	tstb
	lbeq	nan		; inf * 0
	lda	#2
	sta	CLS,y
	rts
mu2:	tstb			; x * 0
	bne	mu3
	clr	CLS,y
mu3:	tst	CLS,y		; (and 0 * x)
	bne	mu4
	rts
; both finite: the 56-bit mantissas (the bytes but the last, which is 0
; in a record just unpacked) multiply to 112 bits, in 14 bytes at 0,S
mu4:	ldd	EXP,y		; the product's leading 1 is at bit 60
	addd	EXP,x		; or 61 of its top 64 bits
	addd	#2
	std	EXP,y
	pshs	u,x,y		; 14,S: X  16,S: Y  18,S: U
	leas	-14,s
	clra
	clrb
	std	,s
	std	2,s
	std	4,s
	std	6,s
	std	8,s
	std	10,s
	std	12,s
	lda	#7		; each byte of one, times the other
	pshs	a		; 0,S: count; the product from 1,S
	leay	MAN+6,y		; Y: the one byte, the last first
	leau	1+12,s		; U: where its product with the other's
mu5:	ldx	15,s		; last byte goes (the word at U)
	leax	MAN+6,x		; X: each of the other's bytes
	ldb	#7
	pshs	b		; 0,S: count
mu6:	lda	,y
	ldb	,x
	mul
	addd	,u
	std	,u
	bcc	mu8
	pshs	u		; carry up
mu7:	leau	-1,u
	inc	,u
	beq	mu7
	puls	u
mu8:	leax	-1,x
	leau	-1,u
	dec	,s
	bne	mu6
	leas	1,s
	leay	-1,y
	leau	6,u		; (one place up from where it began)
	dec	,s
	bne	mu5
	leas	1,s
	ldy	16,s		; the top 8 bytes are the mantissa, and the
	ldd	,s		; rest sticky
	std	MAN,y
	ldd	2,s
	std	MAN+2,y
	ldd	4,s
	std	MAN+4,y
	ldd	6,s
	std	MAN+6,y
	lda	8,s
	ora	9,s
	ora	10,s
	ora	11,s
	ora	12,s
	ora	13,s
	beq	mu9
	lda	MAN+7,y
	ora	#1
	sta	MAN+7,y
mu9:	leas	14,s
	puls	y,x,u
	lbra	__fpnorm

; __fpdiv: Y = Y / X
__fpdiv:
	lbsr	signs
	tstb
	lbne	nan
	lda	CLS,y
	ldb	CLS,x
	cmpa	#2
	bne	dv2
	cmpb	#2		; inf / inf
	lbeq	nan
dv1:	rts			; inf / x
dv2:	cmpb	#2		; x / inf: 0
	bne	dv3
	clr	CLS,y
	rts
dv3:	tstb
	bne	dv4
	tsta			; x / 0: inf, but 0 / 0 is NaN
	lbeq	nan
	lda	#2
	sta	CLS,y
	rts
dv4:	tsta			; 0 / x
	beq	dv1
; both finite: 63 bits of quotient, at 0,S, one at a time; Y's mantissa
; is the remainder
	ldd	EXP,y
	subd	EXP,x
	std	EXP,y
	clra
	clrb
	pshs	d
	pshs	d
	pshs	d
	pshs	d		; 0,S: the quotient, 8 bytes
	lda	#63
	pshs	a		; 0,S: count; the quotient from 1,S
dv5:	asl	8,s		; the quotient left 1
	rol	7,s
	rol	6,s
	rol	5,s
	rol	4,s
	rol	3,s
	rol	2,s
	rol	1,s
	lda	MAN,y		; if the remainder is less than the
	cmpa	MAN,x		; divisor, a 0
	bne	dv6
	lda	MAN+1,y
	cmpa	MAN+1,x
	bne	dv6
	lda	MAN+2,y
	cmpa	MAN+2,x
	bne	dv6
	lda	MAN+3,y
	cmpa	MAN+3,x
	bne	dv6
	lda	MAN+4,y
	cmpa	MAN+4,x
	bne	dv6
	lda	MAN+5,y
	cmpa	MAN+5,x
	bne	dv6
	lda	MAN+6,y
	cmpa	MAN+6,x
	bne	dv6
	lda	MAN+7,y
	cmpa	MAN+7,x
dv6:	blo	dv7
	ldd	MAN+6,y		; else a 1, and subtract it
	subd	MAN+6,x
	std	MAN+6,y
	ldd	MAN+4,y
	sbcb	MAN+5,x
	sbca	MAN+4,x
	std	MAN+4,y
	ldd	MAN+2,y
	sbcb	MAN+3,x
	sbca	MAN+2,x
	std	MAN+2,y
	ldd	MAN,y
	sbcb	MAN+1,x
	sbca	MAN,x
	std	MAN,y
	inc	8,s
dv7:	lbsr	__fpml1		; the remainder left 1
	dec	,s
	bne	dv5
	lda	MAN,y		; anything left is sticky
	ora	MAN+1,y
	ora	MAN+2,y
	ora	MAN+3,y
	ora	MAN+4,y
	ora	MAN+5,y
	ora	MAN+6,y
	ora	MAN+7,y
	beq	dv8
	lda	#1
	ora	8,s
	sta	8,s
dv8:	leas	1,s
	puls	d
	std	MAN,y
	puls	d
	std	MAN+2,y
	puls	d
	std	MAN+4,y
	puls	d
	std	MAN+6,y
	lbra	__fpnorm
