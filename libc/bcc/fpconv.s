; fpconv.s: conversions between integers and floating point, for bcc09
;
;   Fpushc, Fpushuc     push the signed or unsigned char in B as a double
;   Fpushs, Fpushus     push the short in D as a double (as an int)
;   Fpushi, Fpushui     push the int in D as a double
;   Fpushl, Fpushul     push the long in D:X (the high word in D)
;   dtoc, dtouc         the double at X as a char, in B
;   dtos, dtous         ... as a short, in D (as an int)
;   dtoi, dtoui         ... as an int, in D
;   dtol, dtoul         ... as a long, in D:X
;   ftoc ... ftoul      the same, from the float at X
;
; (Pushed is above the return address.)  Conversion to an integer
; truncates toward zero; a value out of the type's range gives an
; undefined result in C, and here its low bits, or 0 if it is far out of
; range (or infinite, or a NaN).  An unsigned type gets the same bits as
; the signed one.  See fpcore.s for the format.  Change D, X and CC; keep
; Y and U.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	Fpushc
	export	Fpushuc
	export	Fpushs
	export	Fpushus
	export	Fpushi
	export	Fpushui
	export	Fpushl
	export	Fpushul
	export	dtoc
	export	dtouc
	export	dtos
	export	dtous
	export	dtoi
	export	dtoui
	export	dtol
	export	dtoul
	export	ftoc
	export	ftouc
	export	ftos
	export	ftous
	export	ftoi
	export	ftoui
	export	ftol
	export	ftoul
	import	__fpud
	import	__fpuf
	import	__fppd
	import	__fpnorm
	import	__fprsh
	import	__fpmr1

SGN	equ	0
CLS	equ	1
EXP	equ	2
MAN	equ	4

; integers to doubles: each makes a long in D:X, and says in C whether
; it is signed (C set) or not (C clear); nothing after that changes C
; until it is tested
Fpushc:	sex
Fpushs:
Fpushi:	tfr	d,x
	tfr	a,b
	sex
	tfr	a,b
Fpushl:	orcc	#1
	bra	push
Fpushuc:
	clra
Fpushus:
Fpushui:
	tfr	d,x
	ldd	#0
Fpushul:
	andcc	#$fe

; push the long in D:X as a double: the frame, from U: a record, the
; long, Y and U, the return address, and the double
push:	leas	-8,s		; room for the double, under the return
	pshs	d		; address
	ldd	10,s
	std	2,s
	puls	d
	pshs	u,y,x,d
	leas	-12,s
	tfr	s,u
	bcc	pu0		; unsigned
	tst	12,u
	bpl	pu0
	lda	#$80		; negative: negate it
	sta	SGN,u
	com	12,u
	com	13,u
	com	14,u
	com	15,u
	ldd	14,u
	addd	#1
	std	14,u
	ldd	12,u
	adcb	#0
	adca	#0
	std	12,u
	bra	pu1
pu0:	clr	SGN,u
pu1:	lda	#1		; the value is (long << 24) * 2^(38 - 62)
	sta	CLS,u
	ldd	#38
	std	EXP,u
	clr	MAN,u
	ldd	12,u
	std	MAN+1,u
	ldd	14,u
	std	MAN+3,u
	clr	MAN+5,u
	clr	MAN+6,u
	clr	MAN+7,u
	leay	,u
	lbsr	__fpnorm	; (0 becomes zero)
	leax	22,u
	lbsr	__fppd
	leas	12,s
	puls	d,x,y,u
	rts

; doubles and floats to integers: the long in D:X, then shortened
dtoc:
dtouc:
dtos:
dtous:
dtoi:
dtoui:	bsr	dtol
	tfr	x,d
	rts
ftoc:
ftouc:
ftos:
ftous:
ftoi:
ftoui:	bsr	ftol
	tfr	x,d
	rts

ftol:
ftoul:	pshs	u,y
	leas	-12,s
	leay	,s
	lbsr	__fpuf
	bra	toint
dtol:
dtoul:	pshs	u,y
	leas	-12,s
	leay	,s
	lbsr	__fpud
; the record at Y as a long in D:X; the frame is a record, then Y and U
toint:	lda	CLS,y
	cmpa	#1
	bne	ti0		; zero, infinite or a NaN
	ldd	EXP,y
	blt	ti0		; less than 1
	cmpd	#61
	bgt	ti0		; far too big
	ldd	#61		; the integer part at the bottom: shift
	subd	EXP,y		; right 61 - EXP, keeping one more bit
	lbsr	__fprsh		; than the integer (which the sticky bit
	lbsr	__fpmr1		; may change), then shift that out
	tst	SGN,y
	bpl	ti1
	com	MAN+4,y		; negative
	com	MAN+5,y
	com	MAN+6,y
	com	MAN+7,y
	ldd	MAN+6,y
	addd	#1
	std	MAN+6,y
	ldd	MAN+4,y
	adcb	#0
	adca	#0
	std	MAN+4,y
ti1:	ldd	MAN+4,y
	ldx	MAN+6,y
	bra	ti2
ti0:	ldd	#0
	tfr	d,x
ti2:	leas	12,s
	puls	u,y
	rts
