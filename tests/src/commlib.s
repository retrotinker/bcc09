; commlib.s - the library member: the common block shared (larger than
; the programs'), and junk
	.text
	export	junk
junk:	rts
	loc	3
shared	comm	4
