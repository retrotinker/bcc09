; crt0 for FLEX (bcc09 -Mf; installed as crtflex.o): start-up code for a
; FLEX command (a .CMD file: objcopy09 -O flex)
;
; FLEX starts a command at its transfer address on FLEX's own stack, 128
; bytes below $C080; start moves the stack to the end of user memory
; (MEMEND, $CC2B), clears the BSS, calls the init functions (see
; libc/sa/crt0.s), then main(argc, argv) by way of __flexstart
; (flex/start.c), with the words of the command line, and exit() with its
; result.  The heap (stdlib/sbrk.s) grows from the end of the program
; toward the stack.  _exit() goes back to FLEX (WARMS; flex/flex.s).
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

MEMEND	equ	$cc2b		; FLEX's: the end of user memory

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end
	loc	5		; (and these in segment 5)
	import	__seg5DL
	import	__seg5DH
	loc	2		; (and these in segment 2)
	import	__seg2DL
	import	__seg2CH

	.text
	entry	start
	import	___flexstart
	import	_exit
	export	__sysdp

start:	lds	MEMEND		; the stack, from the end of user memory
	leas	1,s
	ldx	#__edata	; clear the BSS
clear:	cmpx	#__end
	bhs	clear2
	clr	,x+
	bra	clear
clear2:
	tfr	dp,a		; the caller's DP, for _exit() (and FLEX's
	sta	__sysdp		; calls)
	ldd	#__seg2CH	; DP: the direct page's (segment 2), if the
	subd	#__seg2DL	; program has __direct variables
	beq	nodp
	ldd	#__seg2DL
	tfr	a,dp
nodp:
	ldx	#__seg5DL	; the init functions
init:	cmpx	#__seg5DH
	bhs	go
	ldd	,x++		; (0: the linker's padding)
	beq	init
	pshs	x
	jsr	[-2,x]
	puls	x
	bra	init
go:	jsr	___flexstart	; main's result, in X
	jmp	_exit		; (exit()'s argument)

	.bss
__sysdp: .blkb	1		; FLEX's DP, for its calls (flex.s)
