; calls to FLEX's DOS, through its jump table at $CD00, for the FLEX
; target (bcc09 -Mf)
;
; _exit(status): back to FLEX (WARMS), with the status in B (FLEX has no
;   exit status: sim6809 --flex takes B as its own)
; __flex_inch(): INCH, a character from the terminal (no echo)
; __flex_putchr(c): PUTCHR, c to the terminal (or where FLEX's output
;   goes)
;
; The last two keep every register but X, the result.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

WARMS	equ	$cd03
INCH	equ	$cd09
PUTCHR	equ	$cd18

	.text
	export	__exit
	export	___flex_inch
	export	___flex_putchr

__exit:
	tfr	x,d		; the status, the first argument
	jmp	WARMS

___flex_inch:
	pshs	d,y,u
	jsr	INCH		; A: the character
	tfr	a,b
	clra
	tfr	d,x
	puls	d,y,u,pc

; c is in X
___flex_putchr:
	pshs	d,x,y,u
	tfr	x,d
	tfr	b,a		; the character, in A
	jsr	PUTCHR
	puls	d,x,y,u,pc
