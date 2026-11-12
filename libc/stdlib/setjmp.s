; setjmp(env), longjmp(env, val) (setjmp.h): env is S as setjmp found it
; (at its return address), that return address, and U (the data pointer
; on OS-9); longjmp puts them back, the return address in its place too
; (the frame below may have been used since), and returns val, or 1 for
; 0, as if from setjmp.  Position-independent, for OS-9 too.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	_setjmp
	export	_longjmp

; setjmp(env): env in X
_setjmp:
	sts	,x
	ldd	,s		; the return address
	std	2,x
	stu	4,x
	ldx	#0
	rts

; longjmp(env, val): env in X, val on the stack (above the return address)
_longjmp:
	ldd	2,s
	bne	lj1
	incb			; (val 0: 1)
lj1:	lds	,x
	ldu	4,x
	ldy	2,x
	sty	,s		; setjmp's return address, again
	tfr	d,x		; setjmp's result
	rts
