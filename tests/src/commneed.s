; commneed.s - the common block shared, as commmain.s has it, and junk,
; which the library's member defines: the member is linked, and shared
; has one block of storage
	.text
	entry	start
	import	junk
start:	ldx	shared
	jsr	junk
	rts
	loc	3
shared	comm	2
