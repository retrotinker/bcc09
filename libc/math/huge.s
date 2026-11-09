; huge.s: HUGE_VAL (math.h), positive infinity, which a C constant
; can't be in bcc09 (1.0 / 0.0 is an error there)
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.data
	export	___huge_val
___huge_val:
	fdb	$7ff0,0,0,0
