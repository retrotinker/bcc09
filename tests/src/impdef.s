; impdef.s - defines the variable counter in counter 3, and SIZE with
; EQU, which impuse.s imports
	.data
	export	counter, SIZE
counter: fcb	7
SIZE	equ	$40
