/* limits.h - sizes of the integer types on the 6809, for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 * char is 8 bits and unsigned; short and int are 16 bits; long is 32.
 */

#ifndef __LIMITS_H
#define __LIMITS_H

#define CHAR_BIT	8
#define SCHAR_MIN	(-128)
#define SCHAR_MAX	127
#define UCHAR_MAX	255
#define CHAR_MIN	0
#define CHAR_MAX	255
#define SHRT_MIN	(-32767-1)
#define SHRT_MAX	32767
#define USHRT_MAX	0xFFFFU
#define INT_MIN		(-32767-1)
#define INT_MAX		32767
#define UINT_MAX	0xFFFFU
#define LONG_MIN	(-2147483647L-1)
#define LONG_MAX	2147483647L
#define ULONG_MAX	0xFFFFFFFFUL

#endif
