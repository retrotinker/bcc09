; xfpcvt.s: printf's %e, %f and %g, on OS-9 (bcc09 -Mo): as
; libc/stdio/xfpcvt.s, with the hook in the data area (through U) and
; __fmtfp found PC-relative
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	loc	3		; (C's globals are in segment 3)
	import	___fmtfp_hook

	.text
	export	___xfpcvt
	import	___fmtfp

___xfpcvt:
fpinit:	leax	___fmtfp,pcr
	stx	___fmtfp_hook,u
	rts

	loc	5		; the init function
	fdb	fpinit
