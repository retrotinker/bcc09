
/* @(#)s_finite.c 1.3 95/01/18 */
/*
 * Adapted for bcc09's libc (libc/math/README says how): these changes are
 * distributed under the GNU Library General Public License, version 2
 * (see COPYING.LIB), and fdlibm's own code under Sun's notice above.
 */

/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunSoft, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice 
 * is preserved.
 * ====================================================
 */

/*
 * finite(x) returns 1 is x is finite, else 0;
 * no branching!
 */

#include "fdlibm.h"

#ifdef __STDC__
	int finite(double x)
#else
	int finite(x)
	double x;
#endif
{
	__i32 hx; 
	hx = __HI(x);
	return  (__u32)((hx&0x7fffffff)-0x7ff00000)>>31;
}
