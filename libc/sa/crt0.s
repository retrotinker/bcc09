; crt0: start-up code for bcc09 programs (the default, -Ms)
;
; bcc09 links this first (ld09 -C0).  The program runs on the stack its
; loader gave it (Color BASIC's EXEC, a monitor, a debugger): start
; clears the BSS, saves S and calls main.  When main returns, its result
; goes to exit(), as the C standard says; exit() calls the atexit()
; functions, then _exit() puts the status in D, puts S back as it was,
; and returns to the loader.
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
	export	__savesp

start:	ldx	#__edata	; clear the BSS
clear:	cmpx	#__end
	bhs	go
	clr	,x+
	bra	clear
go:	sts	__savesp	; for _exit()
	jsr	_main
	jmp	_exit		; main's result is in X, exit()'s argument

	.bss
__savesp: .blkb	2		; S on entry, for returning to the loader
