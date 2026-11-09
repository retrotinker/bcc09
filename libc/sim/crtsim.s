; crtsim: start-up code for programs run on sim6809 (bcc09 -Mi)
;
; sim6809 starts a program at its entry point with S = 0 and memory
; filled with $A5 (see tests/sim): start puts the stack just below the
; simulator's I/O block at $FF00, clears the BSS and calls main; when
; main returns, its result goes to exit(), which calls the atexit()
; functions and then _exit(), which stops the simulator with the low byte
; of the status as its exit status.
;
; Before main, start calls each function whose address a module has put
; in segment 5 (loc 5): its "init" functions (as xfpcvt.s does; a 0 is
; skipped, as the linker pads the segment).  They
; may change D, X, Y, U and CC.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end
	loc	5		; (and these in segment 5)
	import	__seg5DL
	import	__seg5DH

	.text
	entry	start
	import	_main
	import	_exit

start:	lds	#$ff00		; the stack, below the I/O block
	ldx	#__edata	; clear the BSS
clear:	cmpx	#__end
	bhs	clear2
	clr	,x+
	bra	clear
clear2:
	ldx	#__seg5DL	; the init functions
init:	cmpx	#__seg5DH
	bhs	go
	ldd	,x++		; (0: the linker's padding)
	beq	init
	pshs	x
	jsr	[-2,x]
	puls	x
	bra	init
go:	jsr	_main
	jmp	_exit		; main's result is in X, exit()'s argument
