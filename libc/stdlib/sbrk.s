; sbrk(incr), brk(addr): move the end of the heap, for malloc
;
; The heap starts at __end, the end of the program's data, and grows up
; toward the stack, which grows down from wherever the loader put it.
; The heap may not come within __heap_margin bytes (256 unless the
; program changes it) of the stack pointer at the time of the call, nor
; go below __end; then sbrk() returns (void *)-1 and brk() -1, and errno
; is ENOMEM.  Otherwise sbrk() returns the old end of the heap, and brk()
; 0.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

ENOMEM	equ	12

	.data			; the linker defines __end in the data
	import	__end		; segment, so it must be imported there
	import	_errno
	export	___heap_margin
___heap_margin:
	fdb	256
curbrk:	fdb	__end		; the end of the heap

	.text
	export	_sbrk
	export	_brk

; sbrk(incr): incr is in X; the result in X
_sbrk:	ldd	curbrk
	pshs	d		; 0,S: the old end
	cmpx	#0
	beq	sbsame
	bmi	sbdown
	tfr	x,d		; up
	addd	0,s
	bcs	sbfail		; past $FFFF
	bsr	limit		; below S - __heap_margin?
	bhi	sbfail
	bra	sbset
sbdown:	tfr	x,d
	addd	0,s
	bcc	sbfail		; below 0
	cmpd	#__end
	blo	sbfail		; below the start of the heap
sbset:	std	curbrk
sbsame:	puls	x,pc		; the old end

sbfail:	leas	2,s
nomem:	ldd	#ENOMEM
	std	_errno
	ldx	#-1
	rts

; brk(addr): addr is in X; the result in X
_brk:	cmpx	#__end
	blo	nomem		; below the start of the heap
	tfr	x,d
	bsr	limit
	bhi	nomem
	std	curbrk
	ldx	#0
	rts

; compare D, a new end for the heap, with S - __heap_margin, leaving D
; as it was and the flags for an unsigned comparison: HI if D is above
; the limit (or the margin is more than S)
limit:	pshs	d
	tfr	s,d
	subd	___heap_margin
	bcs	limbad
	cmpd	0,s		; the limit against the new end
	bhs	limok
limbad:	puls	d		; (PULS leaves the flags alone)
	andcc	#$fa		; Z and C clear: HI
	rts
limok:	puls	d
	orcc	#$04		; Z set: not HI
	rts
