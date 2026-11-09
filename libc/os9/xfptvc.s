; xfptvc.s: scanf's %a, %e, %f and %g, on OS-9 (bcc09 -Mo): as
; libc/stdio/xfptvc.s, with the hook in the data area (through U) and
; __scanfp found PC-relative
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	loc	3		; (C's globals are in segment 3)
	import	___scanfp_hook

	.text
	export	___xfptvc
	import	___scanfp

___xfptvc:
fpinit:	leax	___scanfp,pcr
	stx	___scanfp_hook,u
	rts

	loc	5		; the init function
	fdb	fpinit
