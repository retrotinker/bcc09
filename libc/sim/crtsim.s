; crtsim: start-up code for programs run on sim6809 (bcc09 -Mi)
;
; sim6809 starts a program at its entry point with S = 0 and memory
; filled with $A5 (see tests/sim): start puts the stack just below the
; simulator's I/O block at $FF00, clears the BSS and calls main; when
; main returns, its result goes to exit(), which calls the atexit()
; functions and then _exit(), which stops the simulator with the low byte
; of the status as its exit status.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end

	.text
	entry	start
	import	_main
	import	_exit

start:	lds	#$ff00		; the stack, below the I/O block
	ldx	#__edata	; clear the BSS
clear:	cmpx	#__end
	bhs	go
	clr	,x+
	bra	clear
go:	jsr	_main
	jmp	_exit		; main's result is in X, exit()'s argument
