/* bignum.c - unsigned big integers, for the conversions between
 * floating point and decimal (see bignum.h)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * Bytes, so that each step fits a 16-bit unsigned int.  The callers keep
 * the numbers within BNMAX bytes.
 */

#include "bignum.h"

/* drop the high bytes that are 0 */
static void
norm(a)
struct __bn *a;
{
   while (a->n > 0 && a->b[a->n - 1] == 0)
      a->n--;
}

void
__bnint(a, v)
struct __bn *a;
unsigned v;
{
   a->n = 0;
   while (v)
   {
      a->b[a->n++] = v;
      v >>= 8;
   }
}

void
__bnset(a, p, len)
struct __bn *a;
unsigned char *p;
int len;
{
   int i;

   for (i = 0; i < len; i++)
      a->b[i] = p[len - 1 - i];
   a->n = len;
   norm(a);
}

void
__bnmuls(a, m, c)
struct __bn *a;
unsigned m, c;
{
   int i;
   unsigned t;

   for (i = 0; i < a->n; i++)
   {
      t = a->b[i] * m + c;
      a->b[i] = t;
      c = t >> 8;
   }
   if (c)
      a->b[a->n++] = c;
   norm(a);			/* (if m was 0) */
}

unsigned
__bndivs(a, d)
struct __bn *a;
unsigned d;
{
   int i;
   unsigned t, r = 0;

   for (i = a->n - 1; i >= 0; i--)
   {
      t = (r << 8) | a->b[i];
      a->b[i] = t / d;
      r = t % d;
   }
   norm(a);
   return r;
}

void
__bnshl(a, s)
struct __bn *a;
int s;
{
   int i, by = s >> 3, bits = s & 7;
   unsigned t, c = 0;

   if (a->n == 0)
      return;
   for (i = a->n - 1; i >= 0; i--)
      a->b[i + by] = a->b[i];
   for (i = 0; i < by; i++)
      a->b[i] = 0;
   a->n += by;
   if (bits)
   {
      for (i = by; i < a->n; i++)
      {
	 t = (a->b[i] << bits) | c;
	 a->b[i] = t;
	 c = t >> 8;
      }
      if (c)
	 a->b[a->n++] = c;
   }
}

void
__bnshr(a, s)
struct __bn *a;
int s;
{
   int i, by = s >> 3, bits = s & 7;

   if (by >= a->n)
   {
      a->n = 0;
      return;
   }
   for (i = by; i < a->n; i++)
      a->b[i - by] = a->b[i];
   a->n -= by;
   if (bits)
   {
      for (i = 0; i < a->n; i++)
	 a->b[i] = (a->b[i] >> bits)
	    | (i + 1 < a->n ? a->b[i + 1] << (8 - bits) : 0);
      norm(a);
   }
}

int
__bncmp(a, b)
struct __bn *a, *b;
{
   int i;

   if (a->n != b->n)
      return a->n - b->n;
   for (i = a->n - 1; i >= 0; i--)
      if (a->b[i] != b->b[i])
	 return a->b[i] < b->b[i] ? -1 : 1;
   return 0;
}

void
__bnsub(a, b)
struct __bn *a, *b;
{
   int i, t, borrow = 0;

   for (i = 0; i < a->n; i++)
   {
      t = a->b[i] - (i < b->n ? b->b[i] : 0) - borrow;
      borrow = t < 0;
      a->b[i] = t;
   }
   norm(a);
}

int
__bnbits(a)
struct __bn *a;
{
   int n;
   unsigned t;

   if (a->n == 0)
      return 0;
   n = (a->n - 1) * 8;
   for (t = a->b[a->n - 1]; t; t >>= 1)
      n++;
   return n;
}
