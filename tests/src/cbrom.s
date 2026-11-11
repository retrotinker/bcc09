; stands in for Color BASIC's ROM on sim6809, for testing the Color
; BASIC target (bcc09 -Me): linked at $A000, it has the ROM's vector
; table there, with POLCAT and CHROUT using the simulator's I/O block,
; and JOYIN giving fixed values
;
; POLCAT gives "no key" every other time it is called, to test that
; programs wait for a key; it gives the input's '\n' as ENTER, and BREAK
; at the end of the input.  CHROUT shows a carriage return as '\n'.
; Each routine prints # if it is called with DP other than 0, which the
; real ROM's need (a program's __direct variables may have their own).

IO_OUT	equ	$ff00
IO_IN	equ	$ff01

	.text
	entry	vectors		; (ld09 needs one; it isn't run)
vectors: fdb	polcat		; $A000: POLCAT
	fdb	chrout		; $A002: CHROUT
	fdb	0,0,0		; ($A004-$A009: not stood in for)
	fdb	joyin		; $A00A: JOYIN

dpcheck: pshs	a,cc		; # if DP isn't 0 (keeping A and CC)
	tfr	dp,a
	tsta
	beq	dc1
	lda	#'#
	sta	IO_OUT
dc1:	puls	a,cc,pc
polcat:	bsr	dpcheck
	lda	toggle
	eora	#1
	sta	toggle
	beq	nokey		; every other call: no key
	lda	IO_IN
	bne	pc1
	lda	#$03		; the end of the input: BREAK
pc1:	cmpa	#$0a
	bne	pc2
	lda	#$0d		; ENTER
pc2:	tsta			; Z clear: a key
	rts
nokey:	clra			; Z set: no key
	rts

chrout:	bsr	dpcheck
	pshs	a
	cmpa	#$0d
	bne	co1
	lda	#$0a
co1:	sta	IO_OUT
	puls	a,pc

; JOYIN: the joysticks' values, 10, 20, 30 and 40, in POTVAL
joyin:	bsr	dpcheck
	pshs	x,a
	ldx	#$015A
	lda	#10
	sta	,x+
	lda	#20
	sta	,x+
	lda	#30
	sta	,x+
	lda	#40
	sta	,x
	puls	x,a,pc

	.data
toggle:	fcb	0
