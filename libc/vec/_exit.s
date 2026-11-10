; _exit() for Vectrex cartridges (bcc09 -Mv, libvec.a): a cartridge has
; nothing to return to, so it stops, with the status in D, in a loop
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	__exit

__exit:	tfr	x,d		; the status, the first argument
stop:	bra	stop
