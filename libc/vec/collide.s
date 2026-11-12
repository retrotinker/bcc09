; collide: the Vectrex BIOS's collision tests, for C (bcc09 -Mv,
; libvec.a; see vectrex.h).  They don't use the VIA, so DP stays as it
; is.  Obj_Hit has object 1's y, x in Y, object 2's in X, and the box's
; half height and width in A, B, and sets C for a hit: y1 - h <= y2 <=
; y1 + h and the same for x (each sum held to -128..127); Obj_Will_Hit
; first moves object 1 by U's y, x.  They keep every register.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

B_Obj_Will_Hit	equ	$F8F3
B_Obj_Hit	equ	$F8FF

	.text
	export	_Obj_Hit
	export	_Obj_Will_Hit

; Obj_Hit(y1, x1, y2, x2, h, w): 1 if the object at y2, x2 is within h
; (up or down) and w (left or right) of the one at y1, x1, else 0
_Obj_Hit:
	tfr	x,d
	tfr	b,a		; y1
	ldb	3,s		; x1 (the arguments after the return address)
	tfr	d,y
	lda	5,s		; y2
	ldb	7,s		; x2
	tfr	d,x
	lda	9,s		; h
	ldb	11,s		; w
	jsr	B_Obj_Hit
	bra	result

; Obj_Will_Hit(y1, x1, dy, dx, y2, x2, h, w): Obj_Hit() with the object
; at y1, x1 moved by dy, dx first (where it will be)
_Obj_Will_Hit:
	tfr	x,d
	tfr	b,a		; y1
	ldb	3,s		; x1
	tfr	d,y
	lda	5,s		; dy
	ldb	7,s		; dx
	tfr	d,u
	lda	9,s		; y2
	ldb	11,s		; x2
	tfr	d,x
	lda	13,s		; h
	ldb	15,s		; w
	jsr	B_Obj_Will_Hit
result:	ldx	#0		; (C: a hit)
	bcc	r1
	leax	1,x
r1:	rts
