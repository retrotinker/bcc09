; linc_b, ldec_b: add 1 to, or subtract 1 from, a long in memory, for
; bcc09's ++ and --
;
; X points at the long, high word first.  The compiler keeps the old
; value in D and U, so change only the long and CC.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	linc_b
	export	ldec_b

linc_b:
	pshs	d
	ldd	2,x
	addd	#1
	std	2,x
	ldd	0,x		; (LDD leaves the carry)
	adcb	#0
	adca	#0
	std	0,x
	puls	d,pc

ldec_b:
	pshs	d
	ldd	2,x
	subd	#1
	std	2,x
	ldd	0,x
	sbcb	#0
	sbca	#0
	std	0,x
	puls	d,pc
