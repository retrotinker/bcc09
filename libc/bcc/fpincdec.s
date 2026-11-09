; fpincdec.s: ++ and -- on floats and doubles, for bcc09
;
;   Fpreincd, Fpredecd     add 1 to (or subtract 1 from) the double at
;                          X (the compiler uses the new value there)
;   Fpostincd, Fpostdecd   the same, and push its old value
;   Fpreincf ... Fpostdecf the same, with the float at X (Fpostincf
;                          and Fpostdecf push 8 bytes, with the old
;                          float in the first 4, as dtof does)
;
; (Pushed is above the return address.)  See fpcore.s for the format.
; Change D, X and CC; keep Y and U.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	Fpreincd
	export	Fpredecd
	export	Fpostincd
	export	Fpostdecd
	export	Fpreincf
	export	Fpredecf
	export	Fpostincf
	export	Fpostdecf
	import	__fpud
	import	__fpuf
	import	__fppd
	import	__fppf
	import	__fpadd

SGN	equ	0
CLS	equ	1
EXP	equ	2
MAN	equ	4

; B: 1 to subtract, + 2 to push the old value (post), + 4 for a float
F_DEC	equ	1
F_POST	equ	2
F_FLT	equ	4

Fpreincd:
	clrb
	bra	incdec
Fpredecd:
	ldb	#F_DEC
	bra	incdec
Fpostincd:
	ldb	#F_POST
	bra	incdec
Fpostdecd:
	ldb	#F_POST+F_DEC
	bra	incdec
Fpreincf:
	ldb	#F_FLT
	bra	incdec
Fpredecf:
	ldb	#F_FLT+F_DEC
	bra	incdec
Fpostincf:
	ldb	#F_FLT+F_POST
	bra	incdec
Fpostdecf:
	ldb	#F_FLT+F_POST+F_DEC

; the frame, from U: the value's record, 1's, then B, X, Y, U, the
; return address, and (post) room for the double pushed
RA	equ	0
RB	equ	12
OP	equ	24
PTR	equ	25
ROOM	equ	33

incdec:	bitb	#F_POST
	bne	id0
	pshs	u,y,x,b
	bra	id00
id0:	leas	-8,s		; the room, under the return address
	pshs	u,y,x,b
	ldd	15,s
	std	7,s
id00:	leas	-24,s
	tfr	s,u
	ldb	OP,u
	bitb	#F_POST
	beq	id1
	ldx	PTR,u		; the old value, pushed as it is
	ldd	,x
	std	ROOM,u
	ldd	2,x
	std	ROOM+2,u
	bitb	#F_FLT
	bne	id1
	ldd	4,x
	std	ROOM+4,u
	ldd	6,x
	std	ROOM+6,u
id1:	bsr	unpack
	clr	SGN+RB,u	; 1, or -1
	ldb	OP,u
	bitb	#F_DEC
	beq	id2
	lda	#$80
	sta	SGN+RB,u
id2:	lda	#1
	sta	CLS+RB,u
	ldd	#0
	std	EXP+RB,u
	std	MAN+RB+2,u
	std	MAN+RB+4,u
	std	MAN+RB+6,u
	lda	#$40
	std	MAN+RB,u
	leay	RA,u
	leax	RB,u
	lbsr	__fpadd
	ldx	PTR,u		; the new value, stored
	ldb	OP,u
	bitb	#F_FLT
	bne	id3
	lbsr	__fppd
	bra	id4
id3:	lbsr	__fppf
id4:	leas	24,s
	puls	u,y,x,b
	rts

; the value at PTR into the record at RA
unpack:	ldx	PTR,u
	leay	RA,u
	ldb	OP,u
	bitb	#F_FLT
	bne	un1
	lbra	__fpud
un1:	lbra	__fpuf
