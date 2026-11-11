; random: the Vectrex BIOS's Random, for C (bcc09 -Mv, libvec.a; see
; vectrex.h): Random() is a pseudo-random number, 0 to 255
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

; the BIOS's entry points (by the names Vectrex programmers know, with
; B_ in front) and variables
B_Random	equ	$F517

	.text
	export	_Random

_Random:
	pshs	dp		; DP $D0 for the BIOS (the caller's, put
	lda	#$D0		; back after)
	tfr	a,dp
	jsr	B_Random
	tfr	a,b
	clra
	tfr	d,x
	puls	dp,pc
