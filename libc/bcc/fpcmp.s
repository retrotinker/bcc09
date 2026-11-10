; fpcmp.s: floating point comparisons for bcc09
;
;   Fcomp   pop two doubles, the left operand on top, and compare them
;   Fcompd  pop the left one and compare it with the double at X
;   Fcompf  the same, with the float at X
;   Ftstd   compare the double at X with 0
;   Ftstf   compare the float at X with 0
;
; They set CC as comparing two signed numbers would, for the compiler's
; signed branches (BLT, BGE, BEQ, ...): -0 equals +0.  A NaN compares
; greater than anything, and unequal to everything (IEEE 754 says that
; every comparison with a NaN but != is false, which one setting of CC
; can't say).  Change D, X and CC; keep Y and U.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	Fcomp
	export	Fcompd
	export	Fcompf
	export	Ftstd
	export	Ftstf
	import	__fpf2d

; Z is set if the double at X is a NaN
isnan:	lda	,x
	anda	#$7f
	cmpa	#$7f
	bne	in2
	lda	1,x
	anda	#$f0
	cmpa	#$f0
	bne	in2
	lda	1,x
	anda	#$0f
	ora	2,x
	ora	3,x
	ora	4,x
	ora	5,x
	ora	6,x
	ora	7,x
	beq	in1
	clra			; (Z)
	rts
in1:	inca			; (not Z)
in2:	rts

; Z is set if the double at X is +0 or -0
iszero:	lda	,x
	anda	#$7f
	ora	1,x
	ora	2,x
	ora	3,x
	ora	4,x
	ora	5,x
	ora	6,x
	ora	7,x
	rts

; compare the doubles at X and Y: A = -1, 0 or 1 (X <, =, > Y)
compare:
	lbsr	isnan
	beq	cm1
	exg	x,y
	lbsr	isnan
	exg	x,y
	beq	cm1
	lbsr	iszero
	bne	cm2
	exg	x,y
	lbsr	iszero
	exg	x,y
	beq	cm0		; both are 0
cm2:	lda	,x
	eora	,y
	bpl	cm3
	lda	,x		; the signs differ: the negative one is less
	bmi	cmm
cm1:	lda	#1
	rts
cm0:	clra
	rts
cmm:	lda	#-1
	rts
cm3:	ldb	#8		; the same sign: the bits compare as the
	pshs	x,y		; magnitudes do
cm4:	lda	,x+
	cmpa	,y+
	bne	cm5
	decb
	bne	cm4
	puls	x,y
	bra	cm0
cm5:	puls	x,y		; (keeps CC)
	bhi	cm6
	lda	,x		; less: unless they're negative
	bmi	cm1
	bra	cmm
cm6:	lda	,x		; greater: unless they're negative
	bmi	cmm
	bra	cm1

; after PSHS Y: 0,S: Y  2,S: return address  4,S: the left one
; 12,S: (Fcomp) the right one; the flags are set last
Fcomp:	pshs	y
	leax	4,s
	leay	12,s
	lbsr	compare
	puls	y
	puls	x
	leas	16,s
	tsta
	jmp	,x

Fcompd:	pshs	y
	tfr	x,y
	leax	4,s
	lbsr	compare
	puls	y
	puls	x
	leas	8,s
	tsta
	jmp	,x

Fcompf:	pshs	y		; the float as a double, at 0,S
	leas	-8,s
	leay	,s
	lbsr	__fpf2d
	leax	12,s
	lbsr	compare
	leas	8,s
	puls	y
	puls	x
	leas	8,s
	tsta
	jmp	,x

Ftstd:	lbsr	isnan
	beq	ts1
	lbsr	iszero
	beq	ts0
	lda	,x
	bmi	ts2
ts1:	lda	#1
	rts
ts2:	lda	#-1
	rts
ts0:	clra
	rts

Ftstf:	lda	,x		; a NaN: all 1s in the exponent, and not 0
	anda	#$7f
	cmpa	#$7f
	bne	tf1
	lda	1,x
	bpl	tf1
	anda	#$7f
	ora	2,x
	ora	3,x
	bne	ts1
tf1:	lda	,x
	anda	#$7f
	ora	1,x
	ora	2,x
	ora	3,x
	beq	ts0
	lda	,x
	bmi	ts2
	bra	ts1
