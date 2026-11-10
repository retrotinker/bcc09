; page.s - location counter 2 crosses a 256-byte page boundary, so the
; linker moves it to the next page
	LOC	0
	ENTRY	pstart
pstart	ldx	#dpvar
	rts
	rmb	$f0

	LOC	2
dpvar	rmb	$20
	fcb	1
