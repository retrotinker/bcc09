; crtvec: start-up code for Vectrex cartridges (bcc09 -Mv)
;
; bcc09 links this first (ld09 -Cvec), with vectrex.ld, which puts the
; cartridge's header (segment 12: a module of the program's own that
; defines __vec_header, or libvec.a's) at $0000, then this module's
; code, which the BIOS runs after the header: the rest of the code, and
; an image of the initialized data, follow it in the ROM, and the data,
; BSS and stack are in the Vectrex's RAM ($C880 to $CBEA: the BIOS uses
; the rest).  start sets S to __stack_top and DP to $D0 (the VIA's page,
; where the BIOS routines expect it), copies the initialized data from
; the ROM to RAM, clears the BSS, calls the init functions (as crt0
; does) and main.  When main returns, its result goes to exit(), which
; calls the atexit() functions and then _exit() (libvec.a's: a cartridge
; has nothing to return to, so it stops).
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end
	import	__data_start	; (vectrex.ld's .data section)
	import	__data_end
	loc	5		; (and these in segment 5)
	import	__seg5DL
	import	__seg5DH
	loc	2		; (and these in segment 2)
	import	__seg2DL
	import	__seg2CH
	loc	12		; (and the header in segment 12: this links it)
	import	__vec_header

	.text
	entry	start
	import	__data_load
	import	__stack_top
	import	_main
	import	_exit

start:	lds	#__stack_top
	lda	#$D0		; the BIOS's direct page
	tfr	a,dp
	ldx	#__data_load	; the initialized data, to the RAM
	ldu	#__data_start
copy:	cmpu	#__data_end
	bhs	clear1
	lda	,x+
	sta	,u+
	bra	copy
clear1:	ldx	#__edata	; clear the BSS
clear:	cmpx	#__end
	bhs	clear2
	clr	,x+
	bra	clear
clear2:
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
go:	jsr	_main
	jmp	_exit		; main's result is in X, exit()'s argument
