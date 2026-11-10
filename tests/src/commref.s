; commref.s - shared imported (in its segment, 3), with no common block
; of its own: only the library's member has one, so the member is
; linked for it
	.text
	entry	start
start:	ldx	shared
	rts
	loc	3
	import	shared
