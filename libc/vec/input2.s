; input2: more of the Vectrex BIOS's routines for the controllers, for C
; (bcc09 -Mv, libvec.a; see vectrex.h), apart from input.s so that a
; program that only reads the buttons and joysticks doesn't carry them
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

; the BIOS's entry points (by the names Vectrex programmers know, with
; B_ in front)
B_Read_Btns_Mask equ	$F1B4
B_Joy_Analog	equ	$F1F5
B_Select_Game	equ	$F7A9

	.text
	export	_Read_Btns_Mask
	export	_Joy_Analog
	export	_Select_Game

; Read_Btns_Mask(mask): Read_Btns(), but a button whose bit is clear in
; mask counts as pressed again in each call while it is held (the
; BIOS forgets it was held: Vec_Btn_State &= mask first)
_Read_Btns_Mask:
	pshs	dp
	lda	#$D0
	tfr	a,dp
	tfr	x,d
	tfr	b,a		; the mask
	jsr	B_Read_Btns_Mask
	tfr	a,b
	clra
	tfr	d,x
	puls	dp,pc

; Joy_Analog(): as Joy_Digital(), but how far each enabled joystick is
; pushed, -128 to 127 (to the resolution in Vec_Joy_Resltn); the BIOS
; tells them apart by Vec_Misc_Count, which this makes non-zero (it must
; be 0 before, as for Draw_Line_d())
_Joy_Analog:
	pshs	dp
	lda	#$D0
	tfr	a,dp
	jsr	B_Joy_Analog
	puls	dp,pc

; Select_Game(players, games): the BIOS's screen for choosing the number
; of players (up to players) and the game (up to games), with the
; controller's buttons; it ends after a while with no button pressed,
; leaving the choices in Vec_Num_Players and Vec_Num_Game (from 1)
_Select_Game:
	pshs	dp
	lda	#$D0
	tfr	a,dp
	tfr	x,d
	tfr	b,a		; players
	ldb	4,s		; games (after DP and the return address)
	jsr	B_Select_Game
	puls	dp,pc
