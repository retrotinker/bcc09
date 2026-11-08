; crt0: start-up code for bcc09 programs (the default, -Ms)
;
; bcc09 links this first (ld09 -C0).  The program runs on the stack its
; loader gave it (Color BASIC's EXEC, a monitor, a debugger): start
; clears the BSS, saves S and calls main.  When main returns, or the
; program calls exit(), the status goes in D, S is put back as it was,
; and an RTS returns to the loader.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end

	.text
	entry	start
	import	_main
	export	__savesp

start:	ldx	#__edata	; clear the BSS
clear:	cmpx	#__end
	bhs	go
	clr	,x+
	bra	clear
go:	sts	__savesp	; for exit()
	jsr	_main
	tfr	x,d		; main's result
	lds	__savesp
	rts

	.bss
__savesp: .blkb	2		; S on entry, for returning to the loader
