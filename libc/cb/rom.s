; calls to Color BASIC's ROM, through its vector table at $A000, for the
; Color BASIC target (bcc09 -Me)
;
; __cb_polcat(): POLCAT, the keyboard: a key's ASCII code, or 0 if no key
;   is pressed
; __cb_chrout(c): CHROUT: print c (on the screen, or the device DEVNUM
;   selects)
;
; Both keep every register but X, the result (the ROM routines are
; documented to keep them, but this doesn't rely on it), and call the ROM
; with DP 0, as it wants (a program's may be its __direct variables').
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

POLCAT	equ	$a000		; the ROM's vectors
CHROUT	equ	$a002

	.text
	export	___cb_polcat
	export	___cb_chrout

___cb_polcat:
	pshs	d,dp,y,u
	clra
	tfr	a,dp
	jsr	[POLCAT]	; A: the key, Z set if none
	bne	pckey
	clra
pckey:	tfr	a,b
	clra
	tfr	d,x		; the result, in X
	puls	d,dp,y,u,pc

; c is in X
___cb_chrout:
	pshs	d,dp,x,y,u
	clra
	tfr	a,dp
	tfr	x,d
	tfr	b,a		; the character, in A
	jsr	[CHROUT]
	puls	d,dp,x,y,u,pc
