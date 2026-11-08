; read(fd, buf, n): read from sim6809's input (bcc09 -Mi)
;
; Only standard input (0) can be read; any other fd gives -1, with errno
; EBADF.  As from a terminal, it reads up to n bytes, but stops after a
; newline, and returns how many it read, 0 at the end of the input.  The
; simulator gives a 0 byte at the end of the input, so a 0 in the input
; ends it too.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

IO_IN	equ	$ff01		; reading here gives the next input byte
EBADF	equ	9

	.data
	import	_errno

	.text
	export	_read

; fd is in X; buf and n are on the stack, above the return address
_read:	cmpx	#0
	bne	rdbad
	ldx	2,s		; buf
	ldy	4,s		; n
	pshs	u
	ldu	#0		; the count
	leay	,y		; Z for n == 0
	beq	rddone
rdloop:	ldb	IO_IN
	beq	rddone		; the end of the input
	stb	,x+
	leau	1,u
	cmpb	#$0a		; a newline ends a line
	beq	rddone
	leay	-1,y
	bne	rdloop
rddone:	tfr	u,x
	puls	u,pc
rdbad:	ldd	#EBADF
	std	_errno
	ldx	#-1
	rts
