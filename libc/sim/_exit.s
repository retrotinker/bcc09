; _exit(status): stop sim6809, with the low byte of status as its exit
; status (bcc09 -Mi)
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

IO_EXIT	equ	$ff02		; a byte written here stops the simulator

	.text
	export	__exit

__exit:	tfr	x,d		; the status, the first argument
	stb	IO_EXIT		; (takes effect as this instruction ends)
	bra	__exit
