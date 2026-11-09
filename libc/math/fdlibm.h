/* fdlibm.h - for fdlibm's code, adapted for bcc09's libc (see README):
 * libc's own, not installed
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * fdlibm wants 32-bit ints, for a double's two words: __i32 and __u32
 * are those (a long on bcc09, whose int has 16 bits).  __HI(x) and
 * __LO(x) are the high and low words of the double x: first and second
 * on the 6809, which is big-endian.  The same code builds on a
 * little-endian host with 32-bit ints, for the tests (tests/src/mtest.c).
 */

#include <math.h>
#include <errno.h>

#ifdef __BCC__
typedef long __i32;
typedef unsigned long __u32;
#define __HI(x) *(__i32 *)&x
#define __LO(x) *(1 + (__i32 *)&x)
#define __HIp(x) *(__i32 *)x
#define __LOp(x) *(1 + (__i32 *)x)
#else
typedef int __i32;
typedef unsigned __u32;
#define __HI(x) *(1 + (__i32 *)&x)
#define __LO(x) *(__i32 *)&x
#define __HIp(x) *(1 + (__i32 *)x)
#define __LOp(x) *(__i32 *)x
#endif

/* fdlibm's internals */
extern double __kernel_sin(double x, double y, int iy);
extern double __kernel_cos(double x, double y);
extern double __kernel_tan(double x, double y, int iy);
extern __i32 __rem_pio2(double x, double *y);
extern __i32 __kernel_rem_pio2(double *x, double *y, __i32 e0, __i32 nx,
			       int prec, const __i32 *ipio2);
extern int finite(double x);
extern double scalbn(double x, int n);
extern double copysign(double x, double y);
extern double expm1(double x);
