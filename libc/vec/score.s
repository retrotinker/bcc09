; score: the Vectrex BIOS's routines for a score, for C (bcc09 -Mv,
; libvec.a; see vectrex.h).  A score is 7 bytes: 6 characters, the
; number with blanks before it, and $80, so Print_Str_d() prints it.
; They don't use DP, so these jump to them.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

B_Clear_Score	equ	$F84F
B_Add_Score_a	equ	$F85E
B_Add_Score_d	equ	$F87C
B_New_High_Score equ	$F8D8

	.text
	export	_Clear_Score
	export	_Add_Score_a
	export	_Add_Score_d
	export	_New_High_Score

; Clear_Score(score): "     0"
_Clear_Score:
	jmp	B_Clear_Score

; Add_Score_a(n, score): add n, 0 to 99
_Add_Score_a:
	tfr	x,d
	tfr	b,a
	ldx	2,s
	jmp	B_Add_Score_a

; Add_Score_d(bcd, score): add bcd, four decimal digits in BCD ($1234 is
; 1234)
_Add_Score_d:
	tfr	x,d
	ldx	2,s
	jmp	B_Add_Score_d

; New_High_Score(score, high): high becomes score, if score is higher
_New_High_Score:
	ldu	2,s
	jmp	B_New_High_Score
