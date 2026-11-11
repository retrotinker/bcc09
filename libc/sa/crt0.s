; crt0: start-up code for bcc09 programs (the default, -Ms)
;
; bcc09 links this first (ld09 -C0).  The program runs on the stack its
; loader gave it (Color BASIC's EXEC, a monitor, a debugger): start
; clears the BSS, saves S and calls main.  When main returns, its result
; goes to exit(), as the C standard says; exit() calls the atexit()
; functions, then _exit() puts the status in D, puts S back as it was,
; and returns to the loader.
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
	loc	2		; (and these in segment 2)
	import	__seg2DL
	import	__seg2CH

	.text
	entry	start
	import	_main
	import	_exit
	export	__savesp
	export	__sysdp

start:	ldx	#__edata	; clear the BSS
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
go:	sts	__savesp	; for _exit()
	jsr	_main
	jmp	_exit		; main's result is in X, exit()'s argument

	.bss
__savesp: .blkb	2		; S on entry, for returning to the loader
__sysdp: .blkb	1		; and DP
