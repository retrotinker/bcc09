; impuse.s - imports a variable under counter 0, though impdef.s defines
; it in counter 3, and a constant defined with EQU: the definitions win,
; whichever module is read first, with a warning naming both counters
; for the variable (its addressing assumed counter 0); none for the
; constant (absolute)
	.text
	entry	impstart
	import	counter, SIZE
impstart:
	lda	counter
	ldx	#SIZE
	rts
