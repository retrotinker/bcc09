/* math.h - for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * C89's functions, from Sun's fdlibm (libc/math), and copysign, scalbn,
 * expm1 and finite.  Domain errors set errno to EDOM, and overflows,
 * underflows to 0 and poles (log(0)) to ERANGE, as in the GNU C library.
 */

#ifndef __MATH_H
#define __MATH_H

#include <features.h>

extern double __huge_val;
#define HUGE_VAL	__huge_val

extern double acos __P((double));
extern double asin __P((double));
extern double atan __P((double));
extern double atan2 __P((double, double));
extern double cos __P((double));
extern double sin __P((double));
extern double tan __P((double));
extern double cosh __P((double));
extern double sinh __P((double));
extern double tanh __P((double));
extern double exp __P((double));
extern double frexp __P((double, int *));
extern double ldexp __P((double, int));
extern double log __P((double));
extern double log10 __P((double));
extern double modf __P((double, double *));
extern double pow __P((double, double));
extern double sqrt __P((double));
extern double ceil __P((double));
extern double fabs __P((double));
extern double floor __P((double));
extern double fmod __P((double, double));

extern double copysign __P((double, double));
extern double scalbn __P((double, int));
extern double expm1 __P((double));
extern int finite __P((double));

#endif
