; lists: the Vectrex BIOS's routines that draw a whole list of lines (or
; dots) in one call, and rotate one, for C (bcc09 -Mv, libvec.a; see
; vectrex.h).  Each puts its arguments where the routine wants them (the
; first comes in X, the others on the stack, after the return address),
; sets DP to $D0, calls it, and gives the caller's DP back.  A list's
; lines are y, x pairs, relative, at the current scale (VIA_t1_cnt_lo)
; unless the list gives its own.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

; the BIOS's entry points (by the names Vectrex programmers know, with
; B_ in front) and variables
B_Dot_List	equ	$F2D5
B_Mov_Draw_VL_a	equ	$F3B9
B_Draw_VLcs	equ	$F3D6
B_Draw_VL_a	equ	$F3DA
B_Draw_VLp	equ	$F410
B_Draw_Pat_VL_a	equ	$F434
B_Rot_VL_ab	equ	$F610
Vec_Misc_Count	equ	$C823
Vec_Pattern	equ	$C829

	.text
	export	_Draw_VL_a
	export	_Draw_VLcs
	export	_Draw_VLp
	export	_Mov_Draw_VL_a
	export	_Draw_Pat_VL_a
	export	_Dot_List
	export	_Rot_VL_ab

dpd0:	lda	#$D0		; (DP for the BIOS, in a subroutine: it
	tfr	a,dp		; changes only A)
	rts

; na: n (in X) to A, the list (2 bytes after the return address: the
; wrapper's own return address and its saved DP are above it) to X,
; DP $D0
na:	bsr	dpd0
	tfr	x,d
	tfr	b,a
	ldx	5,s
	rts

; Draw_VL_a(n, list): draw n + 1 lines (n as Draw_VLc's count)
_Draw_VL_a:
	pshs	dp
	bsr	na
	jsr	B_Draw_VL_a
	puls	dp,pc

; Mov_Draw_VL_a(n, list): move by the list's first y, x, then draw n
; lines (n itself, not n + 1)
_Mov_Draw_VL_a:
	pshs	dp
	bsr	na
	jsr	B_Mov_Draw_VL_a
	puls	dp,pc

; Draw_VLcs(list): the count (lines - 1), the scale, then the lines
_Draw_VLcs:
	pshs	dp
	bsr	dpd0
	jsr	B_Draw_VLcs
	puls	dp,pc

; Draw_VLp(list): each line is a pattern, y, x: a pattern of $FF draws
; it solid, another negative one dashed, 0 moves without drawing; a
; positive pattern (1) ends the list
_Draw_VLp:
	pshs	dp
	bsr	dpd0
	jsr	B_Draw_VLp
	puls	dp,pc

; Draw_Pat_VL_a(n, pattern, list): n + 1 lines, dashed by the pattern
; (the bits, $FF solid; kept in Vec_Pattern)
_Draw_Pat_VL_a:
	pshs	dp
	bsr	dpd0
	ldb	4,s		; the pattern (after DP and the return
	stb	Vec_Pattern	; address)
	tfr	x,d
	tfr	b,a
	ldx	5,s
	jsr	B_Draw_Pat_VL_a
	puls	dp,pc

; Dot_List(n, list): n + 1 dots, each y, x from the last (for
; Vec_Dot_Dwell); the beam goes back to the centre after
_Dot_List:
	pshs	dp
	bsr	dpd0
	tfr	x,d
	stb	Vec_Misc_Count
	ldx	3,s
	jsr	B_Dot_List
	puls	dp,pc

; Rot_VL_ab(angle, n, from, to): the n + 1 points at from, rotated by
; angle (0 to 63: a whole turn, anticlockwise), to to (which may be
; from)
_Rot_VL_ab:
	pshs	dp
	bsr	dpd0
	tfr	x,d
	tfr	b,a		; the angle
	ldb	4,s		; n
	ldx	5,s		; from
	ldu	7,s		; to
	jsr	B_Rot_VL_ab
	puls	dp,pc
