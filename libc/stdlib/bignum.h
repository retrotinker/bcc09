/* bignum.h - unsigned big integers, for the conversions between
 * floating point and decimal (printf's %f, strtod): libc's own, not
 * installed
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

/* little-endian bytes, b[0] to b[n - 1], with b[n - 1] not 0 (0 has no
   bytes); BNMAX is enough for 10^444 (strtod's largest divisor) shifted
   left 64 bits, and for a double's integer part (2^1024) */
#define BNMAX	200

struct __bn
{
   int n;
   unsigned char b[BNMAX];
};

extern void __bnint();		/* (a, v): a = v, an unsigned int */
extern void __bnset();		/* (a, p, len): a = the big-endian bytes at p */
extern void __bnmuls();		/* (a, m, c): a = a * m + c (m, c < 256) */
extern unsigned __bndivs();	/* (a, d): a /= d (d < 256), the remainder */
extern void __bnshl();		/* (a, s): a <<= s */
extern void __bnshr();		/* (a, s): a >>= s */
extern int __bncmp();		/* (a, b): < 0, 0 or > 0 as a <, =, > b */
extern void __bnsub();		/* (a, b): a -= b (a >= b) */
extern int __bnbits();		/* (a): the number of bits in a */
