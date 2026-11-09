; fppush.s: moving floats and doubles to and from the stack, for bcc09
;
;   Fpushd   push the double at X
;   Fnegd    push the double at X, negated
;   Fneg     negate the double on the stack
;   Fpulld   pop a double into X
;   Fpushf   push the float at X, as a double
;   Fnegf    push the float at X, as a double, negated
;   Fpullf   pop a double into the float at X (rounding)
;   dtof     push the double at X as a float (rounding), in 8 bytes of
;            stack, the float in the first 4
;
; (On the stack is above the return address.)  See fpcore.s for the
; format.  Change D, X and CC; keep Y and U.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	Fpushd
	export	Fnegd
	export	Fneg
	export	Fpulld
	export	Fpushf
	export	Fnegf
	export	Fpullf
	export	dtof
	import	__fpud
	import	__fpuf
	import	__fppd
	import	__fppf

; make room for 8 bytes under the caller's return address: at 2,S once
; this returns
room:	puls	d		; (this routine's return address)
	leas	-8,s
	pshs	d
	ldd	10,s		; the caller's return address, from 10,S
	std	2,s		; to 2,S; the room is 4,S to 11,S
	rts

; (these are called after room: the room is at 4,S)
; copy the double at X there
cpd:	ldd	,x
	std	4,s
	ldd	2,x
	std	6,s
	ldd	4,x
	std	8,s
	ldd	6,x
	std	10,s
	rts

; the float at X, as a double, there
cvf:	pshs	u,y		; 0,S: a record  12,S: U, Y  16,S: return
	leas	-12,s		; addresses  20,S: the room
	leay	,s
	lbsr	__fpuf
	leax	20,s
	lbsr	__fppd
	leas	12,s
	puls	u,y
	rts

; the double at X, as a float, there
cvd:	pshs	u,y
	leas	-12,s
	leay	,s
	lbsr	__fpud
	leax	20,s
	lbsr	__fppf
	leas	12,s
	puls	u,y
	rts

Fpushd:	bsr	room
	bsr	cpd
	rts

Fnegd:	bsr	room
	bsr	cpd
Fneg:	lda	2,s
	eora	#$80
	sta	2,s
	rts

Fpushf:	bsr	room
	bsr	cvf
	rts

Fnegf:	bsr	room
	bsr	cvf
	bra	Fneg

dtof:	bsr	room
	bsr	cvd
	rts

Fpulld:	ldd	2,s
	std	,x
	ldd	4,s
	std	2,x
	ldd	6,s
	std	4,x
	ldd	8,s
	std	6,x
	puls	x
	leas	8,s
	jmp	,x

Fpullf:	pshs	u,y,x		; 0,S: a record  12,S: X  14,S: Y, U
	leas	-12,s		; 18,S: return address  20,S: the double
	leax	20,s
	leay	,s
	lbsr	__fpud
	ldx	12,s
	lbsr	__fppf
	leas	12,s
	puls	u,y,x
	puls	x
	leas	8,s
	jmp	,x
