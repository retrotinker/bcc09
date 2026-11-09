; the last command of the FLEX tests' command file (see run.sh), linked
; at $C600, in the utility command area, where nothing else the tests run
; has code: XRoar traps on that PC and quits, so the tests needn't guess
; how long the programs take (as plm09's tests/flex/done.asm does)

WARMS	equ	$cd03

	.text
	entry	start
start:	nop
	jmp	WARMS
