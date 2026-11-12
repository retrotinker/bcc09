/* float.h - for bcc09's libc: float and double are IEEE 754's single and
 * double (big-endian, in software), rounded to nearest; long double is
 * double.  (float arithmetic is done in double, and rounded to float when
 * it is stored.)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __FLOAT_H
#define __FLOAT_H

#define FLT_RADIX	2
#define FLT_ROUNDS	1

#define FLT_MANT_DIG	24
#define FLT_DIG		6
#define FLT_MIN_EXP	(-125)
#define FLT_MIN_10_EXP	(-37)
#define FLT_MAX_EXP	128
#define FLT_MAX_10_EXP	38
#define FLT_MAX		3.40282347e+38F
#define FLT_EPSILON	1.19209290e-07F
#define FLT_MIN		1.17549435e-38F

#define DBL_MANT_DIG	53
#define DBL_DIG		15
#define DBL_MIN_EXP	(-1021)
#define DBL_MIN_10_EXP	(-307)
#define DBL_MAX_EXP	1024
#define DBL_MAX_10_EXP	308
#define DBL_MAX		1.7976931348623157e+308
#define DBL_EPSILON	2.2204460492503131e-16
#define DBL_MIN		2.2250738585072014e-308

#define LDBL_MANT_DIG	DBL_MANT_DIG
#define LDBL_DIG	DBL_DIG
#define LDBL_MIN_EXP	DBL_MIN_EXP
#define LDBL_MIN_10_EXP	DBL_MIN_10_EXP
#define LDBL_MAX_EXP	DBL_MAX_EXP
#define LDBL_MAX_10_EXP	DBL_MAX_10_EXP
#define LDBL_MAX	DBL_MAX
#define LDBL_EPSILON	DBL_EPSILON
#define LDBL_MIN	DBL_MIN

#endif
