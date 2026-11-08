; land_b, landu_b, lor_b, loru_b, leor_b, leoru_b: 32-bit bitwise
; operations for bcc09
;
; D:X = D:X & [Y], | [Y] or ^ [Y]: D holds the high word and X the low
; one, and Y points at the other operand.  Changes D, X and CC.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	land_b
	export	landu_b
	export	lor_b
	export	loru_b
	export	leor_b
	export	leoru_b

land_b:
landu_b:
	pshs	d
	tfr	x,d
	anda	2,y
	andb	3,y
	tfr	d,x
	puls	d
	anda	0,y
	andb	1,y
	rts

lor_b:
loru_b:
	pshs	d
	tfr	x,d
	ora	2,y
	orb	3,y
	tfr	d,x
	puls	d
	ora	0,y
	orb	1,y
	rts

leor_b:
leoru_b:
	pshs	d
	tfr	x,d
	eora	2,y
	eorb	3,y
	tfr	d,x
	puls	d
	eora	0,y
	eorb	1,y
	rts
