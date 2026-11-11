; sound2: the Vectrex BIOS's routines that write the sound chip's
; registers themselves, and its explosions, for C (bcc09 -Mv, libvec.a;
; see vectrex.h), apart from sound.s so that a program that only plays
; tunes doesn't carry them
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

; the BIOS's entry points (by the names Vectrex programmers know, with
; B_ in front)
B_Sound_Byte	equ	$F256
B_Clear_Sound	equ	$F272
B_Sound_Bytes	equ	$F27D
B_Explosion_Snd	equ	$F92E

	.text
	export	_Sound_Byte
	export	_Sound_Bytes
	export	_Clear_Sound
	export	_Explosion_Snd

; Sound_Byte(reg, value): the sound chip's register reg (0 to 14) set to
; value (the BIOS keeps a copy, at $C800 + reg)
_Sound_Byte:
	pshs	dp
	lda	#$D0
	tfr	a,dp
	tfr	x,d
	tfr	b,a		; the register
	ldb	4,s		; the value (after DP and the return address)
	jsr	B_Sound_Byte
	puls	dp,pc

; Sound_Bytes(list): register, value pairs, as Sound_Byte(), until a
; negative register ($FF)
_Sound_Bytes:
	pshs	dp
	lda	#$D0
	tfr	a,dp
	tfr	x,u
	jsr	B_Sound_Bytes
	puls	dp,pc

; Clear_Sound(): quiet the sound chip: the BIOS's writes 0 to register
; 14 and 1 to registers 13 to 0 (it means 0, but its Sound_Byte leaves B
; 1: volumes of 1, near silence), and clears the music buffer, its mixer
; off ($3F), which the next Do_Sound() sends: silence
_Clear_Sound:
	pshs	dp
	lda	#$D0
	tfr	a,dp
	jsr	B_Clear_Sound
	puls	dp,pc

; Explosion_Snd(parms): an explosion, with the BIOS's 4 bytes of parms;
; set Vec_Expl_Flag to $80 to start one, then call this in each frame,
; and Do_Sound(); it wants DP $C8
_Explosion_Snd:
	pshs	dp
	lda	#$C8
	tfr	a,dp
	tfr	x,u
	jsr	B_Explosion_Snd
	puls	dp,pc
