; lists2: more of the Vectrex BIOS's list routines, for C (bcc09 -Mv,
; libvec.a; see vectrex.h), apart from lists.s so that a program that
; doesn't call them doesn't carry them: a list with its count (and
; scale) and a move first, and Draw_VLp at fixed scales or the list's.
; Each sets DP to $D0 and gives the caller's back.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

B_Mov_Draw_VLc_a equ	$F3AD
B_Mov_Draw_VLcs	equ	$F3B5
B_Draw_VLp_FF	equ	$F404
B_Draw_VLp_7F	equ	$F408
B_Draw_VLp_scale equ	$F40C

	.text
	export	_Mov_Draw_VLc_a
	export	_Mov_Draw_VLcs
	export	_Draw_VLp_FF
	export	_Draw_VLp_7F
	export	_Draw_VLp_scale

dpd0:	pshs	a		; (DP for the BIOS: changes nothing else)
	lda	#$D0
	tfr	a,dp
	puls	a,pc

; Mov_Draw_VLc_a(list): the count n, a move by y, x, then n lines
_Mov_Draw_VLc_a:
	pshs	dp
	bsr	dpd0
	jsr	B_Mov_Draw_VLc_a
	puls	dp,pc

; Mov_Draw_VLcs(list): the count n, the scale, a move, then n lines
_Mov_Draw_VLcs:
	pshs	dp
	bsr	dpd0
	jsr	B_Mov_Draw_VLcs
	puls	dp,pc

; Draw_VLp_FF(list), Draw_VLp_7F(list): Draw_VLp() at scale $FF, $7F
_Draw_VLp_FF:
	pshs	dp
	bsr	dpd0
	jsr	B_Draw_VLp_FF
	puls	dp,pc

_Draw_VLp_7F:
	pshs	dp
	bsr	dpd0
	jsr	B_Draw_VLp_7F
	puls	dp,pc

; Draw_VLp_scale(list): the scale, then Draw_VLp()'s list
_Draw_VLp_scale:
	pshs	dp
	bsr	dpd0
	jsr	B_Draw_VLp_scale
	puls	dp,pc
