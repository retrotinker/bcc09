; stands in for a loader (such as Color BASIC's EXEC) on sim6809: set a
; stack, call the program's start-up code, check that the stack pointer
; is back where it was, and exit with the low byte of the program's
; status (99 if S is wrong)

	.text
	entry	loader		; (so that ld09 loads this module)
	import	start

loader:	lds	#$7f00
	jsr	start
	cmps	#$7f00
	beq	ok
	ldb	#99
ok:	stb	$ff02
stop:	bra	stop
