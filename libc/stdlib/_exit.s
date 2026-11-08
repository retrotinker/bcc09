; _exit(status): end the program at once, returning to its loader
;
; crt0 saved the loader's stack pointer in __savesp; put it back and
; return to the loader, with the status in D.  (exit(), in exit.c, calls
; the atexit() functions first.)
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.bss			; crt0 defines it there, so import it there
	import	__savesp

	.text
	export	__exit

__exit:
	tfr	x,d		; the status, the first argument
	lds	__savesp
	rts
