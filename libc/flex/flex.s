; calls to FLEX's DOS, through its jump table at $CD00, for the FLEX
; target (bcc09 -Mf)
;
; _exit(status): back to FLEX (WARMS), with the status in B (FLEX has no
;   exit status: sim6809 --flex takes B as its own), after closing every
;   open file (FMSCLS)
; __flex_fms(fcb, a): FLEX's File Management System, with X the File
;   Control Block (its function code set) and A a; A after it (a byte
;   read), or the error number negated, -1 to -255 (the FCB's byte 1)
; __flex_inch(): INCH, a character from the terminal (no echo)
; __flex_putchr(c): PUTCHR, c to the terminal (or where FLEX's output
;   goes)
;
; The last two keep every register but X, the result.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

WARMS	equ	$cd03
FMSCLS	equ	$d403
FMS	equ	$d406
INCH	equ	$cd09
PUTCHR	equ	$cd18

	.text
	export	__exit
	export	___flex_inch
	export	___flex_putchr
	export	___flex_fms
	.bss			; crt0 defines it there, so import it there
	import	__sysdp
	.text

__exit:
	pshs	x		; the status, the first argument
	lda	__sysdp		; FLEX's DP again
	tfr	a,dp
	jsr	FMSCLS
	puls	d
	jmp	WARMS

; fcb is in X, a above the return address
___flex_fms:
	pshs	d,dp,y,u	; 7,S: return  9,S: a
	lda	__sysdp		; FLEX's DP, for the call
	tfr	a,dp
	lda	10,s
	jsr	FMS		; (keeps B, X, Y and U)
	bne	fmserr
	tfr	a,b
	clra
	tfr	d,x
	puls	d,dp,y,u,pc
fmserr:	ldb	1,x		; the error, negated
	clra
	coma
	comb
	addd	#1
	tfr	d,x
	puls	d,dp,y,u,pc

___flex_inch:
	pshs	d,dp,y,u
	lda	__sysdp		; FLEX's DP, for the call
	tfr	a,dp
	jsr	INCH		; A: the character
	tfr	a,b
	clra
	tfr	d,x
	puls	d,dp,y,u,pc

; c is in X
___flex_putchr:
	pshs	d,dp,x,y,u
	lda	__sysdp		; FLEX's DP, for the call
	tfr	a,dp
	tfr	x,d
	tfr	b,a		; the character, in A
	jsr	PUTCHR
	puls	d,dp,x,y,u,pc
