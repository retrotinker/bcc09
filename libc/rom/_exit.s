; _exit() for Color BASIC ROM cartridges (bcc09 -Mr, librom.a): a
; cartridge has nothing to return to, so it stops, with the status in D,
; in a loop (the interrupts are off: crtrom.o masked them)
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.text
	export	__exit

__exit:	tfr	x,d		; the status, the first argument
stop:	bra	stop
