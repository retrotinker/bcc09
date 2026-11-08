; write(fd, buf, n): write n bytes to sim6809's output (bcc09 -Mi)
;
; Standard output (1) and standard error (2) both go to the simulator's
; standard output; any other fd gives -1, with errno EBADF.  Returns n.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

IO_OUT	equ	$ff00		; a byte written here is printed
EBADF	equ	9

	.data
	import	_errno

	.text
	export	_write

; fd is in X; buf and n are on the stack, above the return address
_write:	cmpx	#1
	beq	wrok
	cmpx	#2
	bne	wrbad
wrok:	ldx	2,s		; buf
	ldy	4,s		; n
	beq	wrdone
wrloop:	ldb	,x+
	stb	IO_OUT
	leay	-1,y
	bne	wrloop
wrdone:	ldx	4,s		; all n written
	rts
wrbad:	ldd	#EBADF
	std	_errno
	ldx	#-1
	rts
