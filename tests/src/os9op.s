; os9op.s - OS9, an OS-9 system call: SWI2 and the call's code, as OS-9's
; own assembler writes it; names with $ (after the first character), as
; OS-9's are; a code defined after its use; and SWI2 and FCB, the same

	.text
	export	os9op
I$WritLn	equ	$8C
F$Exit	equ	6

os9op:	os9	I$WritLn
	os9	F$Exit
	os9	F$Time
	os9	$10+2
	swi2
	fcb	$8C
	rts
F$Time	equ	$15
