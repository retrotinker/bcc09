; lcmp_b, lcmpu_b, ltst_b: 32-bit comparisons for bcc09
;
; Set the condition codes as a 32-bit CMP would, for the compiler's
; branches: lcmp_b compares D:X with [Y] for signed branches (LT, GE,
; ...), lcmpu_b for unsigned ones (LO, HS, ...), and ltst_b compares
; D:X with 0, signed.  D holds the high word and X the low one.  Change
; only CC.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	lcmp_b
	export	lcmpu_b
	export	ltst_b

lcmp_b:
	cmpd	0,y		; the high words decide, if they differ
	bne	lcdone
	cmpx	2,y		; else the low words, unsigned:
	beq	lcdone
	blo	lcless
lcmore:	andcc	#$f0		; greater: N, Z, V and C clear
	rts
lcless:	andcc	#$f0		; less: N and C set (N xor V for the
	orcc	#$09		; signed branches)
lcdone:	rts

lcmpu_b:
	cmpd	0,y
	bne	lcdone
	cmpx	2,y
	rts

ltst_b:
	cmpd	#0		; negative, or positive, if not 0
	bne	lcdone
	cmpx	#0
	bne	lcmore		; positive, whatever X's top bit
	rts			; zero
