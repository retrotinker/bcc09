; isl, islu, isr, isru: 16-bit shifts by a variable count for bcc09
;
; D = D << X (isl, islu), or D >> X, arithmetic (isr) or logical (isru).
; A count of 16 or more, taken as unsigned (so negative counts too),
; gives 0, or for isr all copies of the sign bit, as shifting one bit at
; a time that many times would.  Changes D, X and CC.

	.text
	export	isl
	export	islu
	export	isr
	export	isru

isl:
islu:
	cmpx	#16
	bhs	shzero
	leax	,x		; Z for a count of 0
	beq	shdone
slloop:	lslb
	rola
	leax	-1,x
	bne	slloop
shdone:	rts

isru:
	cmpx	#16
	bhs	shzero
	leax	,x
	beq	shdone
srloop:	lsra
	rorb
	leax	-1,x
	bne	srloop
	rts

shzero:	ldd	#0
	rts

isr:
	cmpx	#16
	bhs	srsign
	leax	,x
	beq	shdone
sraloop: asra
	rorb
	leax	-1,x
	bne	sraloop
	rts

srsign:	tsta
	bmi	srneg
	ldd	#0
	rts
srneg:	ldd	#-1
	rts
