; lneg_b, lcom_b: 32-bit negate and complement for bcc09
;
; D:X = -D:X or ~D:X: D holds the high word and X the low one.
; Changes D, X and CC.

	.text
	export	lneg_b
	export	lcom_b

lneg_b:
	pshs	d,x		; 0,S: the high word  2,S: the low one
	ldd	#0
	subd	2,s
	tfr	d,x
	ldd	#0		; (LDD leaves the borrow)
	sbcb	1,s
	sbca	0,s
	leas	4,s
	rts

lcom_b:
	coma
	comb
	exg	d,x
	coma
	comb
	exg	d,x
	rts
