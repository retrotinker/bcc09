; start-up code for programs run on sim6809: set the stack, clear the
; BSS, call main, and exit with the low byte of its result; and routines
; for C that use the simulator's I/O block at $FF00 (libc's crt0 and
; exit() are for programs with a loader to return to)

io_out	equ	$ff00		; write a character
io_exit	equ	$ff02		; stop, with this exit status
io_numh	equ	$ff04		; high byte of a number to print
io_numl	equ	$ff05		; low byte: print the number

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end

	.text
	entry	start
	import	_main
start:	lds	#$7f00
	ldx	#__edata
clear:	cmpx	#__end
	bhs	go
	clr	,x+
	bra	clear
go:	jsr	_main
stop:	tfr	x,d		; main's result is in X
	stb	io_exit
	bra	stop

; putchar(c): write c
	export	_putchar
_putchar:
	tfr	x,d
	stb	io_out
	rts

; putnum(n): print n as an unsigned decimal number and a newline
	export	_putnum
_putnum:
	stx	io_numh
	rts
