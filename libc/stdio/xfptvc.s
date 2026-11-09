; xfptvc.s: scanf's %a, %e, %f and %g, in a program that wants them
;
; bcc09 makes a module that passes a pointer to a float or double to a
; scanf function refer to __xfptvc (as dev86's did).  This module defines
; it, and has the start-up code call an init function (see crt0.s) that
; points scanf at __scanfp (scanfp.c), so that only such a program
; carries that code (and strtod's).
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	loc	3		; (C's globals are in segment 3)
	import	___scanfp_hook

	.text
	export	___xfptvc
	import	___scanfp

___xfptvc:
fpinit:	ldx	#___scanfp
	stx	___scanfp_hook
	rts

	loc	5		; the init function
	fdb	fpinit
