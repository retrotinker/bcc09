; text: the Vectrex BIOS's routines that print a string at a place, a
; list of them, or the ships left, for C (bcc09 -Mv, libvec.a; see
; vectrex.h).  Each sets DP to $D0, calls the routine, and gives the
; caller's DP back.  Strings are the BIOS's: capitals, ended by $80.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

B_Print_Str_hwyx	equ	$F373
B_Print_Str_yx	equ	$F378
B_Print_List	equ	$F38A
B_Print_Ships	equ	$F393

	.text
	export	_Print_Str_hwyx
	export	_Print_Str_yx
	export	_Print_List
	export	_Print_Ships

dpd0:	lda	#$D0
	tfr	a,dp
	rts

; Print_Str_hwyx(p): p is the height and width (into Vec_Text_HW, which
; keeps them), y, x, then the string
_Print_Str_hwyx:
	pshs	dp
	bsr	dpd0
	tfr	x,u
	jsr	B_Print_Str_hwyx
	puls	dp,pc

; Print_Str_yx(p): p is y, x, then the string (from the centre, as
; Print_Str_d)
_Print_Str_yx:
	pshs	dp
	bsr	dpd0
	tfr	x,u
	jsr	B_Print_Str_yx
	puls	dp,pc

; Print_List(list): each y, x and string, as Print_Str_yx's, one after
; another, until a y of 0
_Print_List:
	pshs	dp
	bsr	dpd0
	tfr	x,u
	jsr	B_Print_List
	puls	dp,pc

; Print_Ships(ship, n, y, x): n ships left (up to 9), as the character
; ship (a code in the BIOS's character set) and the number, at y, x
_Print_Ships:
	pshs	dp
	bsr	dpd0
	tfr	x,d
	pshs	b		; the ship
	lda	7,s		; y (after the ship, DP and the return
	ldb	9,s		; address); x
	tfr	d,x
	ldb	5,s		; n
	puls	a
	jsr	B_Print_Ships
	puls	dp,pc
