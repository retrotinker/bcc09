; commmain.s - a common block, shared, which the library's member has
; too: that is no reason to link the member (nothing else in it is
; needed), and shared's storage comes with the program
	.text
	entry	start
start:	ldx	shared
	rts
	loc	3
shared	comm	2
