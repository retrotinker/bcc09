; redefboth.s - defines dup too, but needs other, from the same library
; member as the library's dup: both definitions are linked
	.text
	entry	start
	export	dup
	import	other
start:	jsr	dup
	jsr	other
	rts
dup:	rts
