; draw: the Vectrex BIOS's drawing routines, for C (bcc09 -Mv, libvec.a;
; see vectrex.h).  Each puts its arguments where the routine wants them
; (y in A, x in B; the first argument comes in X, the others on the
; stack, after the return address), sets DP to $D0, as the BIOS expects,
; calls it, and puts the caller's DP back (a program's __direct variables
; are in its page, $C8).
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

; the BIOS's entry points (by the names Vectrex programmers know, with
; B_ in front) and variables
B_Wait_Recal	equ	$F192
B_Intensity_1F	equ	$F29D
B_Intensity_3F	equ	$F2A1
B_Intensity_5F	equ	$F2A5
B_Intensity_7F	equ	$F2A9
B_Intensity_a	equ	$F2AB
B_Dot_d		equ	$F2C3
B_Moveto_d_7F	equ	$F2FC
B_Moveto_d	equ	$F312
B_Reset0Ref	equ	$F354
B_Print_Str_d	equ	$F37A
B_Draw_VLc	equ	$F3CE
B_Draw_Line_d	equ	$F3DF
Vec_Misc_Count	equ	$C823

	.text
	export	_Wait_Recal
	export	_Intensity_a
	export	_Intensity_1F
	export	_Intensity_3F
	export	_Intensity_5F
	export	_Intensity_7F
	export	_Moveto_d_7F
	export	_Moveto_d
	export	_Draw_Line_d
	export	_Dot_d
	export	_Reset0Ref
	export	_Print_Str_d
	export	_Draw_VLc

dpd0:	lda	#$D0		; (DP for the BIOS, in a subroutine: it
	tfr	a,dp		; changes only A)
	rts

; Wait_Recal(): wait for the next frame, and recalibrate the beam
_Wait_Recal:
	pshs	dp
	bsr	dpd0
	jsr	B_Wait_Recal
	puls	dp,pc

; Intensity_a(i): the beam's brightness, 0 to $7F
_Intensity_a:
	pshs	dp
	bsr	dpd0
	tfr	x,d
	tfr	b,a
	jsr	B_Intensity_a
	puls	dp,pc

; Intensity_1F() ... Intensity_7F(): the brightness $1F, $3F, $5F or $7F
_Intensity_1F:
	pshs	dp
	bsr	dpd0
	jsr	B_Intensity_1F
	puls	dp,pc
_Intensity_3F:
	pshs	dp
	bsr	dpd0
	jsr	B_Intensity_3F
	puls	dp,pc
_Intensity_5F:
	pshs	dp
	bsr	dpd0
	jsr	B_Intensity_5F
	puls	dp,pc
_Intensity_7F:
	pshs	dp
	bsr	dpd0
	jsr	B_Intensity_7F
	puls	dp,pc

; yx: y (in X) to A, x (2 bytes after the return address: the wrapper's
; own return address and its saved DP are above it) to B, DP $D0
yx:	bsr	dpd0
	tfr	x,d
	tfr	b,a
	ldb	6,s
	rts

; Moveto_d(y, x): move the beam, relative to where it is
_Moveto_d:
	pshs	dp
	bsr	yx
	jsr	B_Moveto_d
	puls	dp,pc

; Moveto_d_7F(y, x): move the beam, relative, at scale $7F (whatever
; the scale was: Print_Str_d's way)
_Moveto_d_7F:
	pshs	dp
	bsr	yx
	jsr	B_Moveto_d_7F
	puls	dp,pc

; Draw_Line_d(y, x): draw a line from where the beam is (Vec_Misc_Count,
; the BIOS's count of lines to draw, must be 0 for one)
_Draw_Line_d:
	pshs	dp
	bsr	yx
	clr	Vec_Misc_Count
	jsr	B_Draw_Line_d
	puls	dp,pc

; Dot_d(y, x): a dot at y, x from where the beam is
_Dot_d:
	pshs	dp
	bsr	yx
	jsr	B_Dot_d
	puls	dp,pc

; Reset0Ref(): the beam back to the centre
_Reset0Ref:
	pshs	dp
	bsr	dpd0
	jsr	B_Reset0Ref
	puls	dp,pc

; Print_Str_d(y, x, s): print s (in capitals, ended by $80, not 0) at y,
; x from the centre
_Print_Str_d:
	pshs	dp
	bsr	yx
	ldu	5,s		; (s, after DP, the return address and x)
	jsr	B_Print_Str_d
	puls	dp,pc

; Draw_VLc(list): draw a vector list from where the beam is: a count
; (one less than the lines), then y, x of each line
_Draw_VLc:
	pshs	dp
	lbsr	dpd0
	jsr	B_Draw_VLc
	puls	dp,pc
