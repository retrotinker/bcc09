; stands in for Color BASIC's ROM on sim6809, for testing the Color
; BASIC target (bcc09 -Me): linked at $A000, it has the ROM's vector
; table there, with POLCAT and CHROUT using the simulator's I/O block,
; and JOYIN giving fixed values
;
; POLCAT gives "no key" every other time it is called, to test that
; programs wait for a key; it gives the input's '\n' as ENTER, and BREAK
; at the end of the input.  CHROUT shows a carriage return as '\n'.

IO_OUT	equ	$ff00
IO_IN	equ	$ff01

	.text
	entry	vectors		; (ld09 needs one; it isn't run)
vectors: fdb	polcat		; $A000: POLCAT
	fdb	chrout		; $A002: CHROUT
	fdb	0,0,0		; ($A004-$A009: not stood in for)
	fdb	joyin		; $A00A: JOYIN

polcat:	lda	toggle
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

chrout:	pshs	a
	cmpa	#$0d
	bne	co1
	lda	#$0a
co1:	sta	IO_OUT
	puls	a,pc

; JOYIN: the joysticks' values, 10, 20, 30 and 40, in POTVAL
joyin:	pshs	x,a
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
