; ladd_b, laddu_b, lsub_b, lsubu_b: 32-bit add and subtract for bcc09
;
; D:X = D:X + [Y] or D:X - [Y]: D holds the high word and X the low one,
; and Y points at the other operand, high word first.  Signed and
; unsigned are the same.  Changes D, X and CC.

	.text
	export	ladd_b
	export	laddu_b
	export	lsub_b
	export	lsubu_b

ladd_b:
laddu_b:
	pshs	d
	tfr	x,d
	addd	2,y		; the low words
	tfr	d,x
	puls	d		; (PULS and TFR leave the carry)
	adcb	1,y
	adca	0,y
	rts

lsub_b:
lsubu_b:
	pshs	d
	tfr	x,d
	subd	2,y
	tfr	d,x
	puls	d
	sbcb	1,y
	sbca	0,y
	rts
