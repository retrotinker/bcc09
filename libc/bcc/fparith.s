; fparith.s: floating point arithmetic for bcc09
;
; The compiler leaves the left operand, a double, on the stack (above the
; return address), and the right one either there too, below it, or at X,
; a double or a float:
;
;   Fadd, Fsub, Fmul, Fdiv      pop both, push the result
;   Faddd, Fsubd, Fmuld, Fdivd  the right one is the double at X: the
;                               result takes the left one's place
;   Faddf, Fsubf, Fmulf, Fdivf  the same, with the float at X
;
; See fpcore.s for the format.  Change D, X and CC; keep Y and U.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	Fadd
	export	Fsub
	export	Fmul
	export	Fdiv
	export	Faddd
	export	Fsubd
	export	Fmuld
	export	Fdivd
	export	Faddf
	export	Fsubf
	export	Fmulf
	export	Fdivf
	import	__fpud
	import	__fpuf
	import	__fppd
	import	__fpadd
	import	__fpmul
	import	__fpdiv

; the operation, in B: 0 add, 1 subtract, 2 multiply, 3 divide; + 4 if
; the right one is a float at X; + 8 if both are on the stack
OPF	equ	4
OPS	equ	8

Fadd:	ldb	#OPS+0
	bra	arith
Fsub:	ldb	#OPS+1
	bra	arith
Fmul:	ldb	#OPS+2
	bra	arith
Fdiv:	ldb	#OPS+3
	bra	arith
Faddd:	clrb
	bra	arith
Fsubd:	ldb	#1
	bra	arith
Fmuld:	ldb	#2
	bra	arith
Fdivd:	ldb	#3
	bra	arith
Faddf:	ldb	#OPF+0
	bra	arith
Fsubf:	ldb	#OPF+1
	bra	arith
Fmulf:	ldb	#OPF+2
	bra	arith
Fdivf:	ldb	#OPF+3

; the frame, from U: the left one's record, the right one's, then B, Y,
; U, the return address, the left operand and (OPS) the right one
RA	equ	0
RB	equ	12
OP	equ	24
LEFT	equ	31
RIGHT	equ	39

arith:	pshs	u,y,b
	leas	-24,s
	tfr	s,u
	leay	RB,u
	bitb	#OPS
	bne	ar2
	bitb	#OPF
	bne	ar1
	lbsr	__fpud		; the double at X
	bra	ar3
ar1:	lbsr	__fpuf		; the float at X
	bra	ar3
ar2:	leax	RIGHT,u		; the one on the stack
	lbsr	__fpud
ar3:	leax	LEFT,u
	leay	RA,u
	lbsr	__fpud
	leax	RB,u
	ldb	OP,u
	andb	#3
	beq	ar5
	decb
	bne	ar4
	lda	RB,u		; subtract: add the negative
	eora	#$80
	sta	RB,u
ar5:	lbsr	__fpadd
	bra	ar7
ar4:	decb
	bne	ar6
	lbsr	__fpmul
	bra	ar7
ar6:	lbsr	__fpdiv
ar7:	leax	LEFT,u		; the result: in the left one's place, or
	ldb	OP,u		; the right one's if both are popped
	bitb	#OPS
	beq	ar8
	leax	RIGHT,u
ar8:	lbsr	__fppd
	ldb	OP,u
	leas	24,s
	bitb	#OPS		; (CC is kept to the end)
	puls	b,y,u
	bne	ar9
	rts
ar9:	puls	x		; pop the left one
	leas	8,s
	jmp	,x
