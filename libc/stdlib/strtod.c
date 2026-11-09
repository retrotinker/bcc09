/* strtod.c - strtod for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * As C99 says: white space, a sign, then a decimal number (digits with
 * an optional point, and an optional exponent), a hexadecimal one (0x,
 * hex digits with an optional point, an optional binary exponent p...),
 * INF or INFINITY, or NAN or NAN(chars), case aside.  The result is
 * rounded to the nearest double (to even on a tie), exactly, from up to
 * MAXDIG significant digits (more only as a sticky digit), with big
 * integers (bignum.c): the value is D * 10^e = D * 5^e * 2^e, so only
 * powers of 5 are worked out.  errno is ERANGE if the result overflows
 * (to an infinity) or underflows (to a denormal or 0, and inexact), as in
 * the GNU C library.
 */

#include <stdlib.h>
#include <ctype.h>
#include <errno.h>
#include "bignum.h"

#define MAXDIG	120

static union
{
   double d;
   unsigned char b[8];
} res;

/* Z unless s starts with word (lower case), case aside */
static int
word(s, w)
char *s, *w;
{
   for (; *w; s++, w++)
      if ((*s | 0x20) != *w)
	 return 0;
   return 1;
}

/* the bit at i of a */
static int
bit(a, i)
struct __bn *a;
int i;
{
   return i >= 0 && (i >> 3) < a->n ? (a->b[i >> 3] >> (i & 7)) & 1 : 0;
}

/* Z unless a bit of a below i is set */
static int
below(a, i)
struct __bn *a;
int i;
{
   int j;

   for (j = 0; j < i; j++)
      if (bit(a, j))
	 return 1;
   return 0;
}

/* res = q * 2^b, plus a little if sticky (q has at most 64 bits), rounded,
   with the sign neg */
static void
pack(q, b, sticky, neg)
struct __bn *q;
int b, sticky, neg;
{
   int p, sh, i, ef, up, inexact;

   for (i = 0; i < 8; i++)
      res.b[i] = 0;
   if (q->n == 0)
      goto zero;
   p = __bnbits(q) - 1;		/* the value is about 2^(p + b) */
   if (p + b > 1023)
      goto inf;
   sh = p - 52;			/* 53 bits */
   if (p + b < -1022)
      sh += -1022 - (p + b);	/* fewer, for a denormal */
   if (sh > 0)
   {
      if (sh > p + 1)
	 up = 0, sticky = 1;	/* (all of it goes) */
      else
	 up = bit(q, sh - 1);
      sticky = sticky || below(q, sh - 1);
      inexact = up || sticky;
      __bnshr(q, sh);
      if (up && (sticky || bit(q, 0)))
      {
	 /* add 1 */
	 for (i = 0; i < q->n && ++q->b[i] == 0; i++)
	    ;
	 if (i == q->n)
	    q->b[q->n++] = 1;
      }
      b += sh;
      if (__bnbits(q) > 53)
      {
	 __bnshr(q, 1);
	 b++;
      }
   }
   else
   {
      __bnshl(q, -sh);
      b += sh;
      inexact = sticky;
   }
   if (q->n == 0)
      goto zero;
   if (bit(q, 52))
   {
      ef = b + 52 + 1023;
      if (ef >= 2047)
	 goto inf;
   }
   else
   {
      ef = 0;			/* a denormal */
      if (inexact)
	 errno = ERANGE;
   }
   for (i = 0; i < 7; i++)
      res.b[7 - i] = i < q->n ? q->b[i] : 0;
   res.b[1] = (res.b[1] & 0x0f) | (ef << 4);
   res.b[0] = ef >> 4;
   goto sign;
 zero:
   errno = ERANGE;
   goto sign;
 inf:
   errno = ERANGE;
   res.b[0] = 0x7f;
   res.b[1] = 0xf0;
 sign:
   if (neg)
      res.b[0] |= 0x80;
}

double
strtod(nptr, endptr)
char *nptr;
char **endptr;
{
   struct __bn num, den;
   register char *s = nptr;
   char *end;
   int neg = 0, digits = 0, kept = 0, point = 0, sticky = 0, d, e = 0, x;
   int xneg, hex, i, p = 0;

   while (isspace(*s))
      s++;
   if (*s == '+' || *s == '-')
      neg = (*s++ == '-');
   for (i = 0; i < 8; i++)
      res.b[i] = 0;

   /* infinity and NaN */
   if (word(s, "inf"))
   {
      end = s + (word(s, "infinity") ? 8 : 3);
      res.b[0] = 0x7f;
      res.b[1] = 0xf0;
      goto sign;
   }
   if (word(s, "nan"))
   {
      end = s + 3;
      if (*end == '(')
      {
	 for (s = end + 1; isalnum(*s) || *s == '_'; s++)
	    ;
	 if (*s == ')')
	    end = s + 1;
      }
      res.b[0] = 0x7f;
      res.b[1] = 0xf8;
      goto sign;
   }

   /* the digits: num = D, the value D * base^e */
   hex = (s[0] == '0' && (s[1] | 0x20) == 'x' &&
	  (isxdigit(s[2]) || (s[2] == '.' && isxdigit(s[3]))));
   if (hex)
      s += 2;
   num.n = 0;
   for (;; s++)
   {
      if (*s == '.' && !point)
      {
	 point = 1;
	 continue;
      }
      if (hex ? !isxdigit(*s) : !isdigit(*s))
	 break;
      d = isdigit(*s) ? *s - '0' : (*s | 0x20) - 'a' + 10;
      digits++;
      if (kept == 0 && d == 0)
      {
	 if (point)		/* (a 0 before the first that isn't) */
	    e--;
	 continue;
      }
      if (kept < MAXDIG)
      {
	 __bnmuls(&num, hex ? 16 : 10, d);
	 kept++;
	 if (point)
	    e--;
      }
      else
      {
	 if (d)
	    sticky = 1;
	 if (!point)
	    e++;
      }
   }
   if (digits == 0)
   {
      end = nptr;		/* no number */
      neg = 0;
      goto done;
   }
   end = s;
   if ((*s | 0x20) == (hex ? 'p' : 'e'))
   {
      /* the exponent, if there are digits */
      s++;
      xneg = 0;
      if (*s == '+' || *s == '-')
	 xneg = (*s++ == '-');
      if (isdigit(*s))
      {
	 for (x = 0; isdigit(*s); s++)
	    if (x < 10000)
	       x = x * 10 + *s - '0';
	 p = xneg ? -x : x;	/* (a power of 10, or for hex of 2) */
	 end = s;
      }
   }
   if (sticky)
   {
      /* a digit more, a little more than those kept */
      __bnmuls(&num, hex ? 16 : 10, 1);
      e--;
   }

   if (num.n == 0)
   {
      goto sign;		/* 0 (not an underflow) */
   }
   if (hex)
   {
      /* D * 16^e * 2^p */
      pack(&num, 4 * e + p, 0, neg);
      goto done;
   }
   e += p;
   if (kept + e > 310)		/* too big */
   {
      __bnint(&num, 1);
      pack(&num, 2000, 0, neg);
      goto done;
   }
   if (kept + e < -324)		/* too small */
   {
      num.n = 0;
      pack(&num, 0, 0, neg);
      goto done;
   }
   if (e >= 0)
   {
      /* D * 5^e * 2^e: an integer */
      for (i = 0; i < e; i++)
	 __bnmuls(&num, 5, 0);
      x = __bnbits(&num) - 64;	/* (pack takes 64 bits) */
      if (x > 0)
      {
	 sticky = below(&num, x);
	 __bnshr(&num, x);
      }
      else
	 x = 0;
      pack(&num, e + x, sticky, neg);
      goto done;
   }

   /* D / (5^-e * 2^-e): 57 or so bits of quotient, num / den, with
      num shifted so that it has 56 bits more than den */
   __bnint(&den, 1);
   for (i = 0; i < -e; i++)
      __bnmuls(&den, 5, 0);
   x = 56 - (__bnbits(&num) - __bnbits(&den));
   if (x > 0)
      __bnshl(&num, x);
   else
      __bnshl(&den, -x);
   {
      struct __bn q;
      int j;

      q.n = 8;
      for (j = 0; j < 8; j++)
	 q.b[j] = 0;
      __bnshl(&den, 57);
      for (j = 57; j >= 0; j--)
      {
	 if (__bncmp(&num, &den) >= 0)
	 {
	    __bnsub(&num, &den);
	    q.b[j >> 3] |= 1 << (j & 7);
	 }
	 __bnshr(&den, 1);
      }
      while (q.n > 0 && q.b[q.n - 1] == 0)
	 q.n--;
      pack(&q, e - x, num.n != 0, neg);
   }

 sign:
   if (neg)
      res.b[0] |= 0x80;
 done:
   if (endptr)
      *endptr = end;
   return res.d;
}
