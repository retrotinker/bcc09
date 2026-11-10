; xfpcvt.s: printf's %e, %f, %g and %a, in a program that wants them
;
; bcc09 makes a module that calls a printf function with a floating
; point argument refer to __xfpcvt (as dev86's did).  This module defines
; it, and has the start-up code call __fpinit (an init function: see
; crt0.s), which points printf at __fmtfp (fpfmt.c), so that only such a
; program carries that code.  (A program that formats floating point some
; other way, through vsprintf in a function of its own, say, can refer to
; __xfpcvt itself.)
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	loc	3		; (C's globals are in segment 3)
	import	___fmtfp_hook

	.text
	export	___xfpcvt
	import	___fmtfp

___xfpcvt:
fpinit:	ldx	#___fmtfp
	stx	___fmtfp_hook
	rts

	loc	5		; the init function
	fdb	fpinit
