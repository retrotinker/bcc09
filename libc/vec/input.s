; input: the Vectrex BIOS's routines for the controllers, for C (bcc09
; -Mv, libvec.a; see vectrex.h)
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

; the BIOS's entry points (by the names Vectrex programmers know, with
; B_ in front) and variables
B_Read_Btns	equ	$F1BA
B_Joy_Digital	equ	$F1F8

	.text
	export	_Read_Btns
	export	_Joy_Digital

; Read_Btns(): read the buttons: the result has a bit set for each that
; has been pressed since the last call (bits 0-3 controller 1's buttons
; 1-4, bits 4-7 controller 2's); Vec_Btn_State has those held down
_Read_Btns:
	pshs	dp		; (the caller's DP, put back after)
	lda	#$D0
	tfr	a,dp
	jsr	B_Read_Btns
	tfr	a,b
	clra
	tfr	d,x
	puls	dp,pc

; Joy_Digital(): read the joysticks enabled in Vec_Joy_Mux_1_X and the
; others (1, 3, 5, 7 enable them; 0 doesn't) into Vec_Joy_1_X and the
; others: <0, 0 or >0 for left, centre or right (down, centre, up)
_Joy_Digital:
	pshs	dp
	lda	#$D0
	tfr	a,dp
	jsr	B_Joy_Digital
	puls	dp,pc
