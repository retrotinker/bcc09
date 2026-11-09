/* stdint.h - for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * C99's integer types, for bcc09's: char 8 bits, short and int 16,
 * long 32, and pointers 16.  There is no 64-bit type, so no int64_t or
 * uint64_t; intmax_t is long.
 */

#ifndef __STDINT_H
#define __STDINT_H

typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef int int16_t;
typedef unsigned int uint16_t;
typedef long int32_t;
typedef unsigned long uint32_t;

typedef signed char int_least8_t;
typedef unsigned char uint_least8_t;
typedef int int_least16_t;
typedef unsigned int uint_least16_t;
typedef long int_least32_t;
typedef unsigned long uint_least32_t;

/* (the 6809 handles a byte as quickly as anything) */
typedef signed char int_fast8_t;
typedef unsigned char uint_fast8_t;
typedef int int_fast16_t;
typedef unsigned int uint_fast16_t;
typedef long int_fast32_t;
typedef unsigned long uint_fast32_t;

typedef int intptr_t;
typedef unsigned int uintptr_t;

typedef long intmax_t;
typedef unsigned long uintmax_t;

#define INT8_MIN	(-127 - 1)
#define INT8_MAX	127
#define UINT8_MAX	255
#define INT16_MIN	(-32767 - 1)
#define INT16_MAX	32767
#define UINT16_MAX	65535U
#define INT32_MIN	(-2147483647L - 1)
#define INT32_MAX	2147483647L
#define UINT32_MAX	4294967295UL

#define INT_LEAST8_MIN	INT8_MIN
#define INT_LEAST8_MAX	INT8_MAX
#define UINT_LEAST8_MAX	UINT8_MAX
#define INT_LEAST16_MIN	INT16_MIN
#define INT_LEAST16_MAX	INT16_MAX
#define UINT_LEAST16_MAX UINT16_MAX
#define INT_LEAST32_MIN	INT32_MIN
#define INT_LEAST32_MAX	INT32_MAX
#define UINT_LEAST32_MAX UINT32_MAX

#define INT_FAST8_MIN	INT8_MIN
#define INT_FAST8_MAX	INT8_MAX
#define UINT_FAST8_MAX	UINT8_MAX
#define INT_FAST16_MIN	INT16_MIN
#define INT_FAST16_MAX	INT16_MAX
#define UINT_FAST16_MAX	UINT16_MAX
#define INT_FAST32_MIN	INT32_MIN
#define INT_FAST32_MAX	INT32_MAX
#define UINT_FAST32_MAX	UINT32_MAX

#define INTPTR_MIN	INT16_MIN
#define INTPTR_MAX	INT16_MAX
#define UINTPTR_MAX	UINT16_MAX
#define INTMAX_MIN	INT32_MIN
#define INTMAX_MAX	INT32_MAX
#define UINTMAX_MAX	UINT32_MAX

#define PTRDIFF_MIN	INT16_MIN
#define PTRDIFF_MAX	INT16_MAX
#define SIG_ATOMIC_MIN	INT16_MIN
#define SIG_ATOMIC_MAX	INT16_MAX
#define SIZE_MAX	UINT16_MAX
#define WCHAR_MIN	0
#define WCHAR_MAX	255
#define WINT_MIN	INT16_MIN
#define WINT_MAX	INT16_MAX

/* constants of the least types (as int, unsigned int, long and
   unsigned long are promoted) */
#define INT8_C(c)	c
#define UINT8_C(c)	c
#define INT16_C(c)	c
#define UINT16_C(c)	c ## U
#define INT32_C(c)	c ## L
#define UINT32_C(c)	c ## UL
#define INTMAX_C(c)	c ## L
#define UINTMAX_C(c)	c ## UL

#endif
