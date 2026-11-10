; draw: the Vectrex BIOS's drawing routines, for C (bcc09 -Mv, libvec.a;
; see vectrex.h).  Each puts its arguments where the routine wants them
; (y in A, x in B; the first argument comes in X, the others on the
; stack, after the return address), sets DP to $D0, as the BIOS expects,
; and jumps to it, which returns to the caller.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

; the BIOS's entry points (by the names Vectrex programmers know, with
; B_ in front) and variables
B_Wait_Recal	equ	$F192
B_Intensity_a	equ	$F2AB
B_Dot_d		equ	$F2C3
B_Moveto_d	equ	$F312
B_Reset0Ref	equ	$F354
B_Print_Str_d	equ	$F37A
B_Draw_VLc	equ	$F3CE
B_Draw_Line_d	equ	$F3DF
Vec_Misc_Count	equ	$C823

	.text
	export	_Wait_Recal
	export	_Intensity_a
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
	bsr	dpd0
	jmp	B_Wait_Recal

; Intensity_a(i): the beam's brightness, 0 to $7F
_Intensity_a:
	bsr	dpd0
	tfr	x,d
	tfr	b,a
	jmp	B_Intensity_a

; yx: y (in X) to A, x (2 bytes after the return address: the wrapper's
; own return address is above it) to B, DP $D0
yx:	bsr	dpd0
	tfr	x,d
	tfr	b,a
	ldb	5,s
	rts

; Moveto_d(y, x): move the beam, relative to where it is
_Moveto_d:
	bsr	yx
	jmp	B_Moveto_d

; Draw_Line_d(y, x): draw a line from where the beam is (Vec_Misc_Count,
; the BIOS's count of lines to draw, must be 0 for one)
_Draw_Line_d:
	bsr	yx
	clr	Vec_Misc_Count
	jmp	B_Draw_Line_d

; Dot_d(y, x): a dot at y, x from where the beam is
_Dot_d:
	bsr	yx
	jmp	B_Dot_d

; Reset0Ref(): the beam back to the centre
_Reset0Ref:
	bsr	dpd0
	jmp	B_Reset0Ref

; Print_Str_d(y, x, s): print s (in capitals, ended by $80, not 0) at y,
; x from the centre
_Print_Str_d:
	bsr	yx
	ldu	4,s		; (s, after the return address and x)
	jmp	B_Print_Str_d

; Draw_VLc(list): draw a vector list from where the beam is: a count
; (one less than the lines), then y, x of each line
_Draw_VLc:
	bsr	dpd0
	jmp	B_Draw_VLc
