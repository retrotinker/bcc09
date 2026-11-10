; sound: the Vectrex BIOS's music routines, for C (bcc09 -Mv, libvec.a;
; see vectrex.h).  To play a tune, set Vec_Music_Flag to 1, then in each
; frame call Init_Music_chk(tune) before Wait_Recal() and Do_Sound()
; after it, until Vec_Music_Flag is 0 again.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

; the BIOS's entry points (by the names Vectrex programmers know, with
; B_ in front) and variables
B_Do_Sound	equ	$F289
B_Init_Music_chk	equ	$F687

	.text
	export	_Init_Music_chk
	export	_Do_Sound

; Init_Music_chk(tune): start (or go on with) the tune, in the BIOS's
; music format (Music1, $FD0D, is the BIOS's own); it wants DP $C8
_Init_Music_chk:
	tfr	x,u
	lda	#$C8
	tfr	a,dp
	jsr	B_Init_Music_chk
	lda	#$D0
	tfr	a,dp
	rts

; Do_Sound(): send this frame's notes to the sound chip
_Do_Sound:
	lda	#$D0
	tfr	a,dp
	jmp	B_Do_Sound
