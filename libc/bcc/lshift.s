; lsl_b, lslu_b, lsr_b, lsru_b: 32-bit shifts by a variable count for
; bcc09
;
; D:X = D:X << Y (lsl_b, lslu_b), or D:X >> Y, arithmetic (lsr_b) or
; logical (lsru_b): D holds the high word and X the low one.  A count of
; 32 or more, taken as unsigned (so negative counts too), gives 0, or
; for lsr_b all copies of the sign bit, as shifting one bit at a time
; that many times would.  Changes D, X, Y and CC.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	lsl_b
	export	lslu_b
	export	lsr_b
	export	lsru_b

lsl_b:
lslu_b:
	cmpy	#32
	bhs	lszero
	pshs	d,x		; 0,S: high word  2,S: low word
	leay	,y		; Z for a count of 0
	beq	lsdone
lsloop:	lsl	3,s
	rol	2,s
	rol	1,s
	rol	0,s
	leay	-1,y
	bne	lsloop
lsdone:	puls	d,x,pc

lsru_b:
	cmpy	#32
	bhs	lszero
	pshs	d,x
	leay	,y
	beq	lsdone
lruloop: lsr	0,s
	ror	1,s
	ror	2,s
	ror	3,s
	leay	-1,y
	bne	lruloop
	puls	d,x,pc

lszero:	ldd	#0
	tfr	d,x
	rts

lsr_b:
	cmpy	#32
	bhs	lrsign
	pshs	d,x
	leay	,y
	beq	lsdone
lrloop:	asr	0,s
	ror	1,s
	ror	2,s
	ror	3,s
	leay	-1,y
	bne	lrloop
	puls	d,x,pc

lrsign:	tsta
	bpl	lszero
	ldd	#-1
	tfr	d,x
	rts
