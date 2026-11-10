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
; both finite: the one with the smaller exponent is shifted right by the
; difference, and the result has the larger
	ldd	EXP,y
	subd	EXP,x
	bge	ad3
	nega			; X's is larger: shift Y's
	negb
	sbca	#0
	tsta
	beq	ad2b
	ldb	#255
ad2b:	lbsr	__fprsh
	ldd	EXP,x
	std	EXP,y
	bra	ad4
ad3:	tsta			; Y's is larger: shift X's
	beq	ad3a
	ldb	#255
ad3a:	exg	x,y
	lbsr	__fprsh
	exg	x,y
ad4:
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
; in a record just unpacked) multiply to 112 bits, in 14 bytes at 0,S.
; Their trailing bytes of 0 (all but 3 of a float's, say) are left out:
; byte i of Y's times byte j of X's adds to the word at byte i + j.
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
	leax	MAN+7,x		; X, Y: the last bytes that aren't 0 (the
mu4a:	tst	,-x		; first one has the leading 1)
	beq	mu4a
	leay	MAN+7,y
mu4b:	tst	,-y
	beq	mu4b
	tfr	x,d		; U: the word for their product
	subd	14,s
	pshs	d
	tfr	y,d
	subd	18,s
	addd	,s++
	leau	d,s
	leau	-2*MAN,u
	ldd	16,s		; 4,S: where Y's mantissa begins
	addd	#MAN
	pshs	d
	pshs	x		; 2,S: X's last byte
	tfr	x,d		; 0,S: where in mrow to start: past one
	subd	18,s		; block for each byte of X's left out
	negb
	addb	#MAN+6
	lda	#MROW
	mul
	leax	mrow,pc
	leax	d,x
	pshs	x
mu5:	lda	,y		; a row: one byte of Y's times X's
	beq	mu8		; (none if it is 0)
	pshs	u
	ldx	4,s
	leax	1,x		; (X and U one past, for ,-X and ,-U)
	leau	1,u
	jsr	[2,s]
	puls	u
mu8:	leau	-1,u		; the next row: one place up
	leay	-1,y
	cmpy	4,s
	bhs	mu5
	leas	6,s
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

; mrow: the byte at Y times X's bytes, from X - 1 down, each product added
; to the word at U - 1, U going down a byte each time (and a carry out
; of it going up); entered at a block of MROW bytes for each byte to do
MROW	equ	13
mrow:
	lda	,y
	ldb	,-x
	mul
	addd	,-u
	std	,u
	bcc	mr1
	bsr	mcarry
mr1:
	lda	,y
	ldb	,-x
	mul
	addd	,-u
	std	,u
	bcc	mr2
	bsr	mcarry
mr2:
	lda	,y
	ldb	,-x
	mul
	addd	,-u
	std	,u
	bcc	mr3
	bsr	mcarry
mr3:
	lda	,y
	ldb	,-x
	mul
	addd	,-u
	std	,u
	bcc	mr4
	bsr	mcarry
mr4:
	lda	,y
	ldb	,-x
	mul
	addd	,-u
	std	,u
	bcc	mr5
	bsr	mcarry
mr5:
	lda	,y
	ldb	,-x
	mul
	addd	,-u
	std	,u
	bcc	mr6
	bsr	mcarry
mr6:
	lda	,y
	ldb	,-x
	mul
	addd	,-u
	std	,u
	bcc	mr7
	bsr	mcarry
mr7:	rts
mcarry:	pshs	u
mc1:	leau	-1,u
	inc	,u
	beq	mc1
	puls	u,pc

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
; both finite: the quotient a bit at a time, Y's mantissa the remainder.
; The mantissas of records just unpacked end in a byte of 0 (and a
; double's in 10 bits of 0), so only their first 7 bytes take part, and
; the remainder's 8th stays 0.  55 bits of quotient are enough: 53 and a
; round bit even when the first is 0, and the remainder, if not 0, is
; sticky.  They go from bit 62 (the 7 of the first byte) to bit 8, a
; byte at a time, from the carry: set for a 0 (a remainder less than the
; divisor), clear for a 1 (no borrow from subtracting it), so each byte
; is complemented when it is full.
dv4:	tsta			; 0 / x
	beq	dv1
	ldd	EXP,y
	subd	EXP,x
	std	EXP,y
	pshs	u
	leas	-8,s		; the quotient, 8 bytes
	lda	#1		; (the first byte's bit 7: 1, so 0 once
	sta	,s		; complemented)
	clr	7,s
	leau	,s		; U: the byte being made
	ldd	#$0707		; 0,S: bits left in it  1,S: bytes left
	pshs	d
dv5:	lda	MAN,y		; if the remainder is less than the
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
dv6:	blo	dv7
	ldd	MAN+5,y		; else a 1, and subtract it (which leaves
	subd	MAN+5,x		; C clear)
	std	MAN+5,y
	ldd	MAN+3,y
	sbcb	MAN+4,x
	sbca	MAN+3,x
	std	MAN+3,y
	ldd	MAN+1,y
	sbcb	MAN+2,x
	sbca	MAN+1,x
	std	MAN+1,y
	lda	MAN,y
	sbca	MAN,x
	sta	MAN,y
dv7:	rol	,u		; the bit, complemented
	asl	MAN+6,y		; the remainder left 1
	rol	MAN+5,y
	rol	MAN+4,y
	rol	MAN+3,y
	rol	MAN+2,y
	rol	MAN+1,y
	rol	MAN,y
	dec	,s
	bne	dv5
	com	,u+		; a byte done
	lda	#8
	sta	,s
	dec	1,s
	bne	dv5
	leas	2,s
	lda	MAN,y		; anything left is sticky
	ora	MAN+1,y
	ora	MAN+2,y
	ora	MAN+3,y
	ora	MAN+4,y
	ora	MAN+5,y
	ora	MAN+6,y
	beq	dv8
	inc	7,s
dv8:	puls	d
	std	MAN,y
	puls	d
	std	MAN+2,y
	puls	d
	std	MAN+4,y
	puls	d
	std	MAN+6,y
	puls	u
	lbra	__fpnorm
